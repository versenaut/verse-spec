#
# Makefile for bitmap node media files. Requires BATIK_SVG2PNG to be set externally.
#

ALL:	coords.png

%.png : %.svg
	$(SVG2PNG) $^

clean:
	rm -f *.png
