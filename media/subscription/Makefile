#
# Construct media that is not "literal".
#

ALL:	subscription-node.png subscription-o.png subscription-g.png subscription-m.png \
	subscription-b.png subscription-t.png subscription-c.png subscription-a.png \

# First create SVG from input toplevel dot files, using Dot.
%.svg: %.dot
	dot -TSVG -o$@ $^

# Then generate PNGs from the SVG using $(SVG2PNG).
%.png: %.svg
	$(SVG2PNG) $^ && cp $@ ..

# If $(SVG2PNG) isn't available, comment out the above implicit rules, and comment in the
# following that lets Graphviz do the conversion directly. You'll be without anti-aliasing.
#
#%.png : %.dot
#	dot -Tpng -O$@ $^

# ---------------------------------------------------------

clean:
	rm -rf *.png *.svg
