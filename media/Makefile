#
# Top-level Makefile for Verse Specification media files.
#
# Exports:
# SVG2PNG	SVG to PNG converter, accepts .svg and emits .png.
#

# Set up SVG2PNG to use Batik. Editing for version/location might be handy, here.
JAVA=`java-config -J`
BATIK="batik-1.5.1"
BATIKRASTER="/usr/share/$(BATIK)/lib/batik-rasterizer.jar"
SVG2PNG=$(JAVA) -Xbootclasspath/p:`java-config -p xerces-2` -jar $(BATIKRASTER)
export SVG2PNG

DIRS=audio bitmap curve geometry material object subscription

ALL:
	for d in $(DIRS) ; do $(MAKE) -C $$d ; done

%.png : %.svg
	$(SVG2PNG) $^

clean:
	for d in $(DIRS) ; do $(MAKE) -C $$d clean ; done
