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
		mkdir -p verse-spec && cp -r media *.html verse-spec && tar czf verse-spec.tgz verse-spec && rm -r verse-spec

dist2:		dist
		scp verse-spec.tgz www.blender.org:www/

# ---------------------------------------------------------

clean:		clean-protocol
		rm -f *.html *~

clean-protocol:
		cd protocol && make clean
