#
# Make the protocol docbook snippets, that are included by the main spec document in parent dir.
#

TYPESTYLE=./types2spec.xsl
CMDSTYLE=./commands2spec.xsl
APISTYLE=./commands2api.xsl
CMDINDXSTYLE=./commands2list.xsl

CMDS=commands-s.xml commands-o.xml commands-g.xml commands-m.xml commands-b.xml commands-t.xml commands-c.xml commands-a.xml

ALL:	types.snip cmd.snip cmd-indx.snip api.snip

types.snip:	$(TYPESTYLE) types.xml
		xsltproc $^ >$@

cmd.snip:	$(CMDSTYLE) commands.xml $(CMDS)
		xsltproc $(CMDSTYLE) commands.xml >$@

cmd-indx.snip:	$(CMDINDXSTYLE) commands.xml $(CMDS)
		xsltproc $(CMDINDXSTYLE) commands.xml >$@

api.snip:	$(APISTYLE) commands.xml $(CMDS)
		xsltproc $(APISTYLE) commands.xml >$@

# ---------------------------------------------------------

clean:
	rm -f *.html *.snip
