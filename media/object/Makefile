#
#
#

BATIK=/usr/share/batik/lib/batik-rasterizer.jar

ALL:	transform-eq.png

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	make *.png

