#
# Makefile for bitmap node media files. Requires BATIK to be set externally.
#

ALL:	curve.png

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	rm -f *.png
