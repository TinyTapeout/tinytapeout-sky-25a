#!/usr/bin/env python3

import sys
import gdstk

URPM  = ( 79, 20 )
RPM   = ( 86, 20 )
LICON = ( 66, 44 )


def is_square_licon(p):
	# Check layer
	if (p.layer, p.datatype) != LICON:
		return False

	# Only 4 points
	if p.size != 4:
		return False

	# Check it's square
	x_max = max(pt[0] for pt in p.points)
	x_min = min(pt[0] for pt in p.points)
	y_max = max(pt[1] for pt in p.points)
	y_min = min(pt[1] for pt in p.points)

	if abs((x_max - x_min) / (y_max - y_min) - 1.0) > 1e-2:
		return False
	
	return True


def cell_remove_square_licon(cell):
	td = []
	for p in cell.polygons:
		if is_square_licon(p):
			td.append(p)

	cell.remove(*td)


def main(argv0, fn_input, fn_output):

	if fn_input.endswith('oas'):
		lib = gdstk.read_oas(fn_input)
	else:
		lib = gdstk.read_gds(fn_input)

	# Get top cell
	top_cell = lib.top_level()[0]

	# Flatten top cell
	top_flat = top_cell.copy('flat').flatten()

	# Remove square licons from all cells
	for cell in lib.cells:
		cell_remove_square_licon(cell)

	# Get all URPM / RPM from flat top level
	rpm_polys = []
	for p in top_flat.polygons:
		if ((p.layer, p.datatype) == URPM) or ((p.layer, p.datatype) == RPM):
			rpm_polys.append(p)

	rpm_polys = gdstk.boolean(rpm_polys, [], 'or')

	# Re-add square licons on top-level if they don't conflict with URPM / RPM
	offending = 0

	for p in top_flat.polygons:
		# Check it's a square licon
		if not is_square_licon(p):
			continue

		# Check if it intersects URPM / RPM
		if gdstk.boolean(p, rpm_polys, 'and'):
			offending += 1
			continue

		# Add it to top level
		top_cell.add(p)

	# Save result
	if offending > 0:
		print(f"Removed {offending} offending licons")

		if fn_output.endswith('oas'):
			lib.write_oas(fn_output)
		else:
			lib.write_gds(fn_output)

	else:
		print("No offending licon found")



if __name__ == '__main__':
	main(*sys.argv)


