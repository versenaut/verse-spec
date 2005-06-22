<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!-- An XSLT transform to create something that looks like a C header file. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:strip-space elements="*"/>
 <xsl:output method="text" indent="no"/>

 <xsl:variable name="typesDoc" select="document('types.xml')"/>

 <xsl:template match="command[not(@api='no')]">
  <xsl:variable name="pfx">
   <xsl:value-of select="../@prefix"/><xsl:if test="../@prefix">_</xsl:if>
  </xsl:variable>
  extern void verse_send_<xsl:value-of select="$pfx"/><xsl:value-of select="meta/name"/><xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="command[@api='no']"/>

 <xsl:template match="params">(<xsl:apply-templates/>);
 </xsl:template>

 <xsl:template match="param">
  <xsl:if test="not(@mask='yes')">
   <xsl:if test="position() &gt; 1">,<xsl:text> </xsl:text></xsl:if>
   <xsl:call-template name="do-type"/><xsl:value-of select="name"/>
  </xsl:if>
 </xsl:template>

 <!-- Format a parameter type. Converts various magical things to C. -->
 <xsl:template match="type" name="do-type">
  <xsl:variable name="typename"><xsl:value-of select="type"/></xsl:variable>
  <!-- Emit array prelude ("const"). -->
  <xsl:if test='type[@array-length]'>const </xsl:if>
  <xsl:choose>
   <xsl:when test="type='string16'">const char *</xsl:when>
   <xsl:when test="type='string500'">const char *</xsl:when>
   <xsl:when test="$typesDoc/types/typegroup/structtype[@name=$typename]">const <link linkend='type-{$typename}'><xsl:value-of select="$typename"/></link> *   </xsl:when>
   <xsl:otherwise>
     <link linkend='type-{$typename}'><xsl:value-of select="type"/></link><xsl:text> </xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  <!-- Emit array postlude ("*"). -->
  <xsl:if test='type[@array-length]'> *</xsl:if>
 </xsl:template>

 <!-- Suppress some crap. -->
 <xsl:template match="meta"/>
 <xsl:template match="desc"/>

</xsl:stylesheet>
