<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY cr "<xsl:text>
</xsl:text>">
]>

<!--

 An XSLT transform to create C structures for each command. For Purple.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="text" indent="no"/>
 <xsl:strip-space elements="*"/>

 <xsl:template match="verse-commands">
  /* Structures for storing all relevant Verse commands. This is auto-generated from
  ** the command definitions in XML (part of the Verse spec sources), using XSLT.
  ** Structures are intended to be constructed by code, so they can (and do) use
  ** dynamic arrays and stuff.
  */

  <xsl:call-template name="build-id-enum"/>

  <xsl:apply-templates mode="first"/>

  typedef struct {
   uint8 id;
   union {
    <xsl:apply-templates mode="second"/>
   } cmd;
  } PVCmd;
 </xsl:template>

 <xsl:template name="build-id-enum">
  typedef enum {  <xsl:for-each select="//command[@id]">
   <xsl:variable name="prefix">
    <xsl:if test="../@prefix">
     <xsl:call-template name="to-upper">
      <xsl:with-param name="str" select="concat(../@prefix, '_')"/>
     </xsl:call-template>
    </xsl:if>
   </xsl:variable>
   P_VCMD_<xsl:value-of select="$prefix"/><xsl:call-template name="to-upper"><xsl:with-param name="str" select="meta/name"/></xsl:call-template> = <xsl:value-of select="@id"/>,</xsl:for-each>
  } PVCmdID;
 </xsl:template>

 <xsl:template match="command[@id]" mode="first">
  <xsl:variable name="prefix">
   <xsl:call-template name="to-upper-first">
    <xsl:with-param name="str" select="../@prefix"/>
   </xsl:call-template>
  </xsl:variable>

  typedef struct { /* <xsl:value-of select="meta/name"/> */
  <xsl:for-each select="params//param">
   <xsl:call-template name="type-to-c">
    <xsl:with-param name="type" select="type"/>
   </xsl:call-template>
   <xsl:text> </xsl:text>
   <!-- **************************************************** -->
   <xsl:if test="not(type/@array-length)">
    <xsl:value-of select="name"/><xsl:call-template name="type-to-c-suffix">
     <xsl:with-param name="type" select="type"/>
    </xsl:call-template>
   </xsl:if>
   <!-- **************************************************** -->
   <xsl:if test="type/@array-length">
    <xsl:if test="starts-with(type, 'string')">*</xsl:if>
    <xsl:if test="not(contains('0123456789', substring(type/@array-length, 1, 1)))">
     *
    </xsl:if>
    <xsl:value-of select="name"/>
    <xsl:call-template name="format-array-length">
     <xsl:with-param name="length" select="type/@array-length"/>
    </xsl:call-template>
   </xsl:if>;
  </xsl:for-each>} PVCmd_<xsl:value-of select="$prefix"/><xsl:call-template name="format-name"><xsl:with-param name="name" select="meta/name"/>
 </xsl:call-template>;</xsl:template>

 <xsl:template match="command[@id]" mode="second">
  <xsl:variable name="prefix">
   <xsl:call-template name="to-upper-first">
    <xsl:with-param name="str" select="../@prefix"/>
   </xsl:call-template>
  </xsl:variable>PVCmd_<xsl:value-of select="$prefix"/><xsl:call-template name="format-name"><xsl:with-param name="name" select="meta/name"/></xsl:call-template> cmd<xsl:value-of select="@id"/>;
 </xsl:template>

 <!-- Emit array length [<length>] specifier. Only if constant, i.e. begins with digit. -->
 <xsl:template name="format-array-length">
  <xsl:param name="length"/>
  <xsl:if test="contains('0123456789', substring($length, 1, 1))">[<xsl:value-of select="$length"/>]</xsl:if>
 </xsl:template>

 <xsl:template name="type-to-c">
  <xsl:param name="type"/>
  <xsl:choose>
   <xsl:when test="starts-with($type, 'string')">char</xsl:when>
   <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- Emit [size] suffix for string types. Rather primitive, assumes things. -->
 <xsl:template name="type-to-c-suffix">
  <xsl:param name="type"/>
  <xsl:if test="starts-with($type, 'string')">[<xsl:value-of select="substring($type, 7)"/>]</xsl:if>
 </xsl:template>

 <xsl:template name="format-name">
  <xsl:param name="name"/>
  <xsl:choose>
   <xsl:when test="contains($name, '_')">
    <xsl:call-template name="to-upper-initial">
     <xsl:with-param name="str" select="substring-before($name, '_')"/>
    </xsl:call-template>
    <xsl:call-template name="format-name">
     <xsl:with-param name="name" select="substring-after($name, '_')"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="to-upper-initial">
     <xsl:with-param name="str" select="$name"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>


 <!-- Convert string to upper case. -->
 <xsl:template name="to-upper">
  <xsl:param name="str"/>
  <xsl:value-of select="translate($str, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 </xsl:template>

 <!-- Make string's first character upper case. -->
 <xsl:template name="to-upper-initial">
  <xsl:param name="str"/>
  <xsl:value-of select="concat(translate(substring($str, 1, 1),
					 'abcdefghijklmnopqrstuvwxyz',
					 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
			       substring($str, 2))"/>
 </xsl:template>

 <!-- Return upper cased version of string's first character. -->
 <xsl:template name="to-upper-first">
  <xsl:param name="str"/>
  <xsl:value-of select="translate(substring($str, 1, 1),
				  'abcdefghijklmnopqrstuvwxyz',
				  'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 </xsl:template>

</xsl:stylesheet>
