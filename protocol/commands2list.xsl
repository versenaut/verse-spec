<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!--

 An XSLT transform to create a command index page.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="xml" indent="yes"/>

 <xsl:key name="commandKey" match="command[@id]" use="@id"/>

 <xsl:template match="/">
  <table align="center">
  <title>Command Index</title>
  <tgroup cols="2">
   <colspec colname="id"  colwidth="1*" align="right"/>
   <colspec colname="cmd" colwidth="9*" align="left"/>
   <spanspec spanname="summary" align="center" namest="id" nameend="cmd"/>
   <tbody>
    <xsl:call-template name="lookup"/>
   </tbody>
  </tgroup>
  </table>
 </xsl:template>

 <xsl:template name="lookup">
  <xsl:param name="i" select="0"/>
  <xsl:param name="num" select="0"/>
  <xsl:for-each select="key('commandKey', $i)">
   <xsl:variable name="pfx">
    <xsl:value-of select="../@prefix"/><xsl:if test="../@prefix">_</xsl:if>
   </xsl:variable>
   <row>
    <entry colname="id"><literal><xsl:value-of select="@id"/></literal></entry>
    <entry colname="cmd">
     <xsl:variable name="refid" select="concat($pfx, meta/name)"/>
     <xref linkend="{$refid}"/>
     <xsl:if test="alias">
      <xsl:variable name="aliasid" select="concat($pfx, alias/meta/name)"/>
      / <xref linkend="{$aliasid}"/>
     </xsl:if>
    </entry>
   </row>
  </xsl:for-each>
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
  <xsl:if test="$i=255">
   <row>
    <entry spanname="summary"><xsl:value-of select="$num"/> IDs used, 
<xsl:value-of select="format-number(100 * $num div 256, '#.#')"/>% of the code space.</entry>
   </row>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
