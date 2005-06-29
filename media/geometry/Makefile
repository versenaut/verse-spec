#
# Makefile for geometry node media files. Requires SVG2PNG to be set externally.
#

ALL:	cube.png

%.png : %.svg
	$(SVG2PNG) $^

clean:
	rm -f *.png
