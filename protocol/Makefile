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
