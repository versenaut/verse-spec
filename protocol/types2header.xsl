<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY tab "<xsl:text>&#x9;</xsl:text>">
]>

<!--

 An XSLT transform from home-grown type format format to C header.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="text"/>
 <xsl:strip-space elements="*"/>

 <xsl:key name="typeKey" match="axiomatictype|aliasedtype|enumeratedtype" use="@name"/>

 <xsl:template match="/">
  /* Hello. */
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="types">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="meta">
  <!-- Suppress, suppress. -->
 </xsl:template>

 <xsl:template match="axiomatictype[@family='integer']">
  <xsl:if test="not(@stand-alone='no')">
   <xsl:variable name="ctype">
    <xsl:call-template name="c-get-integer-type">
     <xsl:with-param name="bits"><xsl:value-of select="bits"/></xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   typedef <xsl:if test="signed='no'">unsigned </xsl:if><xsl:if test="signed='yes'">signed </xsl:if> <xsl:value-of select="$ctype"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>;
  </xsl:if>
 </xsl:template>

 <xsl:template match="axiomatictype[@family='real']">
  <xsl:if test="not(@stand-alone='no')">
   <xsl:variable name="ctype">
    <xsl:call-template name="c-get-real-type">
     <xsl:with-param name="bits"><xsl:value-of select="bits"/></xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   typedef <xsl:value-of select="$ctype"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>;
  </xsl:if>
 </xsl:template>

 <xsl:template match="aliasedtype">
  typedef <xsl:value-of select="type"/>
  <xsl:text> </xsl:text>
  <xsl:call-template name="format-name"><xsl:with-param name="name" select="@name"/></xsl:call-template>;
 </xsl:template>

 <xsl:template match="enumeratedtype">
  typedef enum {
   <xsl:for-each select="enumitem">
    <xsl:variable name="prefix">
     <xsl:if test="not(contains('0123456789', substring(@value, 1, 1)))">V_</xsl:if></xsl:variable>
    <xsl:text>	</xsl:text>V_<xsl:value-of select="@name"/> = <xsl:value-of select="concat($prefix, @value)"/>,
   </xsl:for-each>} <xsl:call-template name="format-name"><xsl:with-param name="name" select="@name"/></xsl:call-template>;
 </xsl:template>

 <xsl:template match="structtype">
  <xsl:if test="not(ancestor::structtype)">  typedef</xsl:if>
  <xsl:text> </xsl:text>
  <xsl:choose>
   <xsl:when test="@union='yes'">union</xsl:when>
   <xsl:otherwise>struct</xsl:otherwise>
  </xsl:choose> {
   <xsl:for-each select="structitem">
    <xsl:if test="@type">
     <xsl:if test="key('typeKey', @type)">
      &tab;
      <xsl:call-template name="format-name"><xsl:with-param name="name" select="@type"/></xsl:call-template>
      &tab;
      <xsl:value-of select="@name"/>;
     </xsl:if>
    </xsl:if>
    <xsl:if test="not(@type)">
     <xsl:apply-templates/>
    </xsl:if>
   </xsl:for-each>} <xsl:call-template name="format-name"><xsl:with-param name="name" select="@name"/></xsl:call-template>;
 </xsl:template>

 <!-- ******************************************************************************** -->

 <!-- Select a C integer type given a bitcount. Should be C99, but isn't. -->
 <xsl:template name="c-get-integer-type">
  <xsl:param name="bits" select="8"/>
  <xsl:choose>
   <xsl:when test="$bits=8">char</xsl:when>
   <xsl:when test="$bits=16">short</xsl:when>
   <xsl:when test="$bits=32">int</xsl:when>
   <xsl:otherwise>
    <xsl:message>Can't compute C integer type with <xsl:value-of select="$bits"/> bits</xsl:message>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- Select a C floating point type given a bitcount. -->
 <xsl:template name="c-get-real-type">
  <xsl:param name="bits" select="32"/>
  <xsl:choose>
   <xsl:when test="$bits=32">float</xsl:when>
   <xsl:when test="$bits=64">double</xsl:when>
   <xsl:otherwise>
    <xsl:message>Can't compute C floating point type with <xsl:value-of select="$bits"/> bits</xsl:message>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- Format a type name. Prepends V if name begins with capital letter. -->
 <xsl:template name="format-name">
  <xsl:param name="name" select="x"/>
  <xsl:if test="contains('ABCDEFGHIJKLMNOPQRSTUVWYZ', substring($name, 1, 1))">V</xsl:if><xsl:value-of select="$name"/>
 </xsl:template>

</xsl:stylesheet>
