#
# Make the protocol docbook snippets, that are included by the main spec document in parent dir.
#

TYPESTYLE=./types2spec.xsl
CMDSTYLE=./commands2spec.xsl
APISTYLE=./commands2api.xsl
CMDINDXSTYLE=./commands2list.xsl

CMDS=commands-s.xml commands-o.xml commands-g.xml commands-m.xml commands-b.xml commands-t.xml commands-c.xml commands-a.xml

ALL:	types.snip cmd.snip cmd-indx.snip api.snip

VERSEH=../../verse/verse.h

types.snip:	$(TYPESTYLE) types.xml
		xsltproc $^ >$@

cmd.snip:	$(CMDSTYLE) commands.xml $(CMDS)
		xsltproc $(CMDSTYLE) commands.xml >$@

cmd-indx.snip:	$(CMDINDXSTYLE) commands.xml $(CMDS)
		xsltproc $(CMDINDXSTYLE) commands.xml >$@

api.snip:	$(APISTYLE) commands.xml $(CMDS)
		xsltproc $(APISTYLE) commands.xml >$@

# ---------------------------------------------------------

# Testing framework is based on a simple approach:
#
# 1) Use XSLT to transform command definitions into C header format.
# 2) Concatenate actual verse.h header with what 1) generated.
# 3) Create silly C program that includes the header generated in step 2).
# 4) Try to compile the C program, letting the compiler catch conflicts.
#
# This should protect against cases where the specification says one thing,
# and the API says another. Obviously, it would be better to generate the
# actual API from the spec, too.

test:		test.c test.h
		gcc test.c

test.c:		test.h
		echo -e "#include \"test.h\"\n\nint main(void)\n{\n\treturn 0;\n}" >test.c

test.h:		verse.h-auto $(VERSEH)
		cat $(VERSEH) $^ >$@ && echo >>$@

verse.h-auto:	commands2header.xsl commands.xml $(CMDS)
		xsltproc commands2header.xsl commands.xml >$@

# ---------------------------------------------------------

clean:
	rm -f *.html *.snip test.[ch] verse.h-auto
