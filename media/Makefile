#
#
#

BATIK=/usr/share/batik/lib/batik-rasterizer.jar

DIRS=bitmap curve material subscription

ALL:
	for d in $(DIRS) ; do (cd $$d && make) ; done

%.png : %.svg
	java -jar $(BATIK) $^

clean:
	for d in $(DIRS) ; do (cd $$d && make clean) ; done
