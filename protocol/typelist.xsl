<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!--

 An XSLT transform from home-grown type format format to DocBook descriptions.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="xml" indent="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:template match="/">
  <xsl:for-each select="//*[self::axiomatictype or self::aliasedtype or self::enumeratedtype or self::structtype]">
   <xsl:sort select="@name" case-order="lower-first"/>
   <xsl:message><xsl:value-of select="@name"/></xsl:message>
  </xsl:for-each>
 </xsl:template>


</xsl:stylesheet>
