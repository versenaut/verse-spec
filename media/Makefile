#
# Top-level Makefile for Verse Specification media files.
#
# Exports:
#  BATIK	Full name (with path) of Batik's rasterizer jar file.
#

BATIK=/usr/share/batik/lib/batik-rasterizer.jar
export BATIK

DIRS=bitmap curve material object subscription

ALL:
	for d in $(DIRS) ; do $(MAKE) -C $$d ; done

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	for d in $(DIRS) ; do $(MAKE) -C $$d clean ; done
