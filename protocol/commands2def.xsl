<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!--

 An XSLT transform to create a command definition log, similiar to the one
 I can instrument into v_cmd_gen when needed. Handy when comparing IDs to
 make sure the XML is in sync with the C definitions.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="text"/>

 <xsl:key name="commandKey" match="command[@id]" use="@id"/>

 <xsl:template match="/">
  <xsl:call-template name="lookup"/>

 </xsl:template>

 <xsl:template name="lookup">
  <xsl:param name="i"   select="0"/>
  <xsl:param name="num" select="0"/>
  <xsl:for-each select="key('commandKey', $i)">
   <xsl:variable name="pfx">
    <xsl:value-of select="../@prefix"/><xsl:if test="../@prefix">_</xsl:if>
   </xsl:variable>
   <xsl:variable name="refid" select="concat($pfx, meta/name)"/>
def: <xsl:value-of select="@id"/><xsl:text>: </xsl:text><xsl:value-of select="$refid"/>
  </xsl:for-each>

  <!-- A nice and terse recursive call. Heh. -->
  <xsl:if test="$i&lt;255">
   <xsl:call-template name="lookup">
    <xsl:with-param name="i" select="$i + 1"/>
    <xsl:with-param name="num">
     <xsl:choose>
      <xsl:when test="key('commandKey', $i)"><xsl:value-of select="$num + 1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$num"/></xsl:otherwise>
     </xsl:choose>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
