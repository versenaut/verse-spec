#
# Construct media that is not "literal".
#

# Go via SVG and Batik for glorious-looking anti-aliasing. See below, though.
BATIK=/usr/local/share/batik/batik-rasterizer.jar

ALL:	subscription-node.png subscription-o.png subscription-g.png subscription-m.png \
	subscription-b.png subscription-t.png subscription-c.png subscription-a.png \

%.svg : %.dot
	dot -TSVG -o$@ $^

%.png : %.svg
	java -jar $(BATIK) $^ && cp $@ ..

# If Batik isn't available, comment out the above implicit rules, and comment in the
# following that lets Graphviz do the conversion. You'll be without anti-aliasing.
#
#%.png : %.dot
#	dot -Tpng -O$@ $^

# ---------------------------------------------------------

clean:
	rm -rf *.png *.svg
