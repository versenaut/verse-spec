#
#
#

BATIK=/usr/share/batik/lib/batik-rasterizer.jar

ALL:	curve.png

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	rm *.png

