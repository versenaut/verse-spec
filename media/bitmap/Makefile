#
#
#

BATIK=/usr/share/batik/lib/batik-rasterizer.jar

ALL:	coords.png

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	rm -f *.png
