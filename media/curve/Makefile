#
# Makefile for bitmap node media files. Requires SVG2PNG to be set externally.
#

ALL:	curve.png

%.png : %.svg
	$(SVG2PNG) $^

clean:
	rm -f *.png
