#
# Makefile for bitmap node media files. Requires BATIK to be set externally.
#

ALL:	coords.png

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	rm -f *.png
