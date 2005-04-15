#
# Makefile for audio node media files. Requires SVG2PNG to be set externally.
#

ALL:	audio.png

%.png : %.svg
	$(SVG2PNG) $^

clean:
	rm -f *.png
