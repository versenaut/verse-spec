<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY cr "<xsl:text>
</xsl:text>">
]>

<!--

 An XSLT transform to create a C function that packs commands structures. For Purple.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="text" indent="no"/>
 <xsl:strip-space elements="*"/>

 <xsl:variable name="typesDoc" select="document('types.xml')"/>

 <xsl:template match="verse-commands">
  #include &lt;stdarg.h&gt;
  #include &lt;string.h&gt;

  #include "verse.h"

  #include "mem.h"
  #include "command-structs.h"
  <xsl:call-template name="build-pack-function"/>
 </xsl:template>

 <xsl:template name="build-pack-function">
  /* Call this function with first the numerical ID of the command to store, then the parameters
  ** of the command in the proper order. The function will return a pointer to a structure holding
  ** the command in question.
  */
  PVCmd * command_pack(uint8 id, ...)
  {
    PVCmd *cmd = mem_alloc(sizeof *cmd);
    va_list args;

    cmd->id = id;
    va_start(args, id);
    switch(id)
    { <xsl:for-each select="//command[@id]">
      <xsl:variable name="enum"><xsl:call-template name="build-id-enum"/></xsl:variable>
      case <xsl:value-of select="$enum"/>:
        <xsl:for-each select=".//param">
         <xsl:call-template name="pack-argument"/>
        </xsl:for-each>
	break;</xsl:for-each>
    }
    va_end(args);
    return cmd;
  }
 </xsl:template>

 <xsl:template name="pack-argument">
  <xsl:variable name="typename" select="type"/>
  <xsl:variable name="fieldname">cmd->cmd.cmd<xsl:value-of select="ancestor::command/@id"/>.<xsl:value-of select="name"/>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="type[@array-length]">
    {
      const <xsl:value-of select="type"/> *tmp = va_arg(args, const <xsl:value-of select="type"/> *);
      <xsl:if test="type[@array-length='3']">
       <xsl:value-of select="$fieldname"/>[0] = tmp[0];
       <xsl:value-of select="$fieldname"/>[1] = tmp[1];
       <xsl:value-of select="$fieldname"/>[2] = tmp[2];
      </xsl:if>
    }
   </xsl:when>
   <xsl:when test="$typesDoc//axiomatictype[@name=$typename and @family='integer']">
    <xsl:value-of select="$fieldname"/> = va_arg(args, int);
   </xsl:when>
   <xsl:when test="$typesDoc//aliasedtype[@name=$typename]">
    <xsl:variable name="aliastarget" select="$typesDoc//aliasedtype[@name=$typename]/type"/>
    <xsl:choose>
     <xsl:when test="$typesDoc//axiomatictype[@name=$aliastarget and @family='integer']">
      <xsl:value-of select="$fieldname"/> = va_arg(args, int);
     </xsl:when>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="$typesDoc//axiomatictype[@name=$typename and @family='real']">
    <xsl:value-of select="$fieldname"/> = va_arg(args, double);
   </xsl:when>
   <xsl:when test="$typesDoc//axiomatictype[@name=$typename and @family='string']">
    strcpy(<xsl:value-of select="$fieldname"/>, va_arg(args, const char *));
   </xsl:when>
   <xsl:when test="$typesDoc//enumeratedtype[@name=$typename]">
    <xsl:value-of select="$fieldname"/> = va_arg(args, <xsl:value-of select="$typename"/>);
   </xsl:when>
   <xsl:when test="$typesDoc//structtype[@name=$typename and @union='yes']">
    <xsl:value-of select="$fieldname"/> = * va_arg(args, const <xsl:value-of select="$typename"/> *);
   </xsl:when>
   <xsl:otherwise>
    /* Ignored <xsl:value-of select="type"/>-type field '<xsl:value-of select="name"/>' -- tweak XSLT. */
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template name="build-id-enum">
  <xsl:variable name="prefix">
   <xsl:if test="../@prefix">
    <xsl:call-template name="to-upper">
     <xsl:with-param name="str" select="concat(../@prefix, '_')"/>
    </xsl:call-template>
   </xsl:if>
  </xsl:variable>P_VCMD_<xsl:value-of select="$prefix"/><xsl:call-template name="to-upper"><xsl:with-param name="str" select="meta/name"/></xsl:call-template>
 </xsl:template>

 <xsl:template name="to-upper">
  <xsl:param name="str"/>
  <xsl:value-of select="translate($str, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
 </xsl:template>

</xsl:stylesheet>
