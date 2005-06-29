#
# Makefile for the Verse specification document, which is a little bit complex.
#

ALL:		book1.html

.PHONY:		protocol clean clean-protocol

book1.html:	spec.docbook protocol media
		docbook2html $< -V '%use-id-as-filename%'

protocol:
		cd protocol && make

media:
		cd media && make

# Kludgy dist-builder.
dist:
		mkdir -p verse-spec && cp -r media/ *.html verse-spec && tar cz --exclude CVS --exclude Makefile --exclude "*.svg" --exclude "*.dot" --file verse-spec.tgz verse-spec && rm -r verse-spec

# Upload (publish) spec on the Blender project site where it lives. Requires password, of course.
publish:	dist
		scp verse-spec.tgz www.blender.org:www/ && ssh www.blender.org "cd www && rm -fr verse-spec && tar xzf verse-spec.tgz && rm verse-spec.tgz"

# ---------------------------------------------------------

clean:		clean-protocol
		rm -f *.html *~

clean-protocol:
		cd protocol && make clean
