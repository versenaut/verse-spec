<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!--

 An XSLT transform to compute command-space coverage. Fun.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="xml"/>

 <xsl:key name="commandKey" match="command" use="@id"/>

 <xsl:template match="/">
  <xsl:call-template name="emit-table"/>
 </xsl:template>

<!--
 <xsl:template match="command[@id]">
  <xsl:variable name="prefix">
   <xsl:if test="../@prefix"><xsl:value-of select="../@prefix"/>_</xsl:if>
  </xsl:variable>
  <xsl:variable name="cname">
   <xsl:value-of select="$prefix"/><xsl:value-of select="meta/name"/>
   <xsl:if test="alias">/<xsl:value-of select="$prefix"/><xsl:value-of select="alias/meta/name"/></xsl:if>
  </xsl:variable>
  <xsl:value-of select="@id"/>: <xsl:value-of select="$cname"/> (<xsl:value-of select="../@node"/>)
  <xsl:call-template name="emit-table">
   <xsl:with-param name="n">3</xsl:with-param>
  </xsl:call-template>
 </xsl:template> -->


 <xsl:template name="emit-table">
  <xsl:call-template name="do-emit-table">
   <xsl:with-param name="y">0</xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <xsl:template name="do-emit-table">
  <xsl:param name="y" select="0"/>

  <xsl:call-template name="emit-row">
   <xsl:with-param name="y" select="$y"/>
  </xsl:call-template>

  <xsl:if test="$y &lt; 15">
   <xsl:call-template name="do-emit-table">
   <xsl:with-param name="y" select="$y+1"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <xsl:template name="emit-row">
  <xsl:param name="y" select="0"/>
  <xsl:call-template name="do-emit-row">
   <xsl:with-param name="y" select="$y"/>
  </xsl:call-template>
 </xsl:template>

 <xsl:template name="do-emit-row">
  <xsl:param name="x" select="0"/>
  <xsl:param name="y" select="0"/>

  <xsl:call-template name="emit-cell">
   <xsl:with-param name="x" select="$x"/>
   <xsl:with-param name="y" select="$y"/>
  </xsl:call-template>

  <xsl:if test="$x &lt; 15">
   <xsl:call-template name="do-emit-row">
    <xsl:with-param name="x" select="$x+1"/>
    <xsl:with-param name="y" select="$y"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <xsl:template name="emit-cell">
  <xsl:param name="x" select="0"/>
  <xsl:param name="y" select="0"/>
  <xsl:variable name="id"><xsl:value-of select="$y*16+$x"/></xsl:variable>

  <xsl:for-each select="key('commandKey', $id)">
   <xsl:value-of select="meta/name"/>
  </xsl:for-each>

  <xsl:if test="not(key('commandKey', $id))">
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
