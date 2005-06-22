<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>

<!--

 An XSLT transform from home-grown type format format to DocBook descriptions.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="xml" indent="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:template match="/">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="types">
  <sect1 id="protocol-datatypes"><title>Data Types</title>
   <xsl:apply-templates/>
  </sect1>
 </xsl:template>

 <!-- Create a clickable index of all types. -->
 <xsl:template match="typeindex">
  <para>
  These are the types defined below, collected for easy reference:
  <variablelist>
   <xsl:for-each select="//*[self::typegroup][child::*[@name]]">
    <varlistentry>
     <term><xsl:value-of select="meta/name"/></term>
     <listitem><para>
      <xsl:for-each select="*[self::axiomatictype or self::aliasedtype or self::enumeratedtype or self::structtype][@name]">
       <link linkend='type-{@name}'><xsl:value-of select="@name"/></link>
       <xsl:if test="following-sibling::*[@name]">, </xsl:if>
      </xsl:for-each>
     </para></listitem>
    </varlistentry>
   </xsl:for-each>
  </variablelist>
  </para>
<!--
  <itemizedlist>
  <xsl:for-each select="//*[self::axiomatictype or self::aliasedtype or self::enumeratedtype or self::structtype][@name]">
   <xsl:sort select="@name" case-order="lower-first"/>
   <listitem><para><xsl:value-of select="@name"/></para></listitem>
  </xsl:for-each>
  </itemizedlist>
-->
 </xsl:template>

 <xsl:template match="typegroup">
  <xsl:variable name="groupid"><xsl:value-of select="@groupid"/></xsl:variable>
  <sect2 id='{$groupid}'>
   <title><xsl:value-of select="meta/name"/></title>
   <xsl:apply-templates select="./meta/desc"/>

   <xsl:choose>
    <xsl:when test="axiomatictype">
     <variablelist>
      <xsl:apply-templates select="*[not(self::meta)]"/>
     </variablelist>
    </xsl:when>

    <xsl:when test="enumeratedtype">
     <xsl:apply-templates select="*[not(self::meta)]"/>
    </xsl:when>

    <xsl:when test="aliasedtype">
     <table align="center">
      <title><xsl:value-of select="meta/name"/></title>
      <tgroup cols="3" align="center">
      <thead>
       <row>
        <entry>Name</entry><entry>Alias For</entry><entry>Description</entry>
       </row>
      </thead>
      <tbody>
       <xsl:apply-templates select="*[not(self::meta)]"/>
      </tbody>
      </tgroup>
     </table>
    </xsl:when>

    <xsl:when test="structtype">
     <xsl:apply-templates select="*[not(self::meta)]"/>
    </xsl:when>

<!--
    <xsl:otherwise>
     <xsl:message>Can't format typegroup <xsl:value-of select="."/></xsl:message>
    </xsl:otherwise> -->
   </xsl:choose>
 
  </sect2>
 </xsl:template>

 <xsl:template match="axiomatictype[@family='integer']">
   <varlistentry xreflabel="{@name}">
    <term><anchor id="type-{@name}"/><type><xsl:value-of select="@name"/></type></term>
    <listitem>
     <para>
      <xsl:if test="signed='yes'">A signed</xsl:if>
      <xsl:if test="signed='no'">An unsigned</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bits"/>-bit integer quantity. Can represent values between <literal>
      <xsl:if test="signed='yes'">
       -<xsl:call-template name="power-of-two"><xsl:with-param name="x" select="bits -1"/></xsl:call-template>
      </xsl:if>
      <xsl:if test="signed='no'">
       0
      </xsl:if>
      </literal> and <literal>
      <xsl:if test="signed='yes'">
       <xsl:variable name="max">
        <xsl:call-template name="power-of-two"><xsl:with-param name="x" select="bits -1"/></xsl:call-template>
       </xsl:variable>
       <xsl:value-of select="format-number($max -1, '#')"/>
      </xsl:if>
      <xsl:if test="signed='no'">
       <xsl:variable name="max">
        <xsl:call-template name="power-of-two"><xsl:with-param name="x" select="bits"/></xsl:call-template>
       </xsl:variable>
       <xsl:value-of select="format-number($max -1, '#')"/>
      </xsl:if>
      </literal>, inclusive.
      <xsl:if test="@stand-alone='no'">
       This type cannot be used on its own, it must always be used as the type for an array.
      </xsl:if>
     </para>
<!--    <xsl:apply-templates select="desc"/> -->
    </listitem>
   </varlistentry>
 </xsl:template>

 <xsl:template match="axiomatictype[@family='real']">
  <varlistentry>
   <term><anchor id="type-{@name}"/><xsl:value-of select="@name"/></term>
   <listitem>
    <para>An IEEE 754 floating-point number using exactly <xsl:value-of select="bits"/> bits in its representation.</para>
   </listitem>
  </varlistentry>
 </xsl:template>

 <xsl:template match="axiomatictype[@family='string']">
  <varlistentry>
   <term><anchor id="type-{@name}"/><xsl:value-of select="@name"/></term>
   <listitem><para>A string type. Maximum size for strings of this type is <xsl:value-of select="maxlength"/>
bytes.</para>
   </listitem>
  </varlistentry>
 </xsl:template>

 <xsl:template match="aliasedtype">
  <row>
   <entry><anchor id="type-{@name}"/><type><xsl:value-of select="@name"/></type></entry>
   <entry><type><xsl:value-of select="type"/></type></entry>
   <entry align="left"><xsl:apply-templates select="desc"/></entry>
  </row>
 </xsl:template>

 <xsl:template match="enumeratedtype">
  <sect3 id="type-{@name}">
   <title><xsl:value-of select="@name"/></title>
    <xsl:apply-templates select="desc"/>
    <para>
    <xsl:if test="@using!='uint8'">
      This enumeration is represented in the network as values of type <type><xsl:value-of select="@using"/></type>
    </xsl:if>
    <informaltable align="center">
<!--     <title>Enumeration <xsl:value-of select="@name"/></title> -->
     <tgroup cols="2" align="center">
     <thead>
      <row><entry>Symbol</entry><entry>Value</entry></row>
     </thead>
     <tbody>
     <xsl:for-each select="enumitem[not(@public='no')]">
      <row>
       <entry><symbol><xsl:value-of select="@name"/></symbol></entry>
       <entry><literal><xsl:value-of select="@value"/></literal></entry>
      </row>
     </xsl:for-each>
     </tbody>
     </tgroup>
    </informaltable>
   </para>
  </sect3>
 </xsl:template>

 <xsl:template match="structtype">
  <xsl:variable name="pclass"><xsl:if test="@union='yes'">union</xsl:if></xsl:variable>
  <sect3 xreflabel="{@name}" id="type-{@name}">
   <title><xsl:value-of select="@name"/></title>
   <xsl:apply-templates select="desc"/>
   <para>
    <informaltable class="{$pclass}">
     <xsl:if test="@name">
<!--      <title>
       <xsl:if test="@union='yes'">Union </xsl:if>
       <xsl:if test="not(@union='yes')">Structure </xsl:if>
       <xsl:value-of select="@name"/>
      </title> -->
     </xsl:if>
     <tgroup cols="2" align="center">
      <thead>
       <row><entry>Type</entry><entry>Name</entry></row>
      </thead>
      <tbody>
       <xsl:for-each select="structitem">
        <row>
         <xsl:choose>
          <xsl:when test="not(@type)">
           <xsl:call-template name="format-structitem-type"/>
           <entry><structfield><xsl:value-of select="@name"/></structfield></entry>
          </xsl:when>
          <xsl:when test="@name">
           <xsl:call-template name="format-structitem-type"/>
           <entry><structfield><xsl:value-of select="@name"/></structfield></entry>
          </xsl:when>
         </xsl:choose>
        </row>
       </xsl:for-each>
      </tbody>
     </tgroup>
    </informaltable>
   </para>
  </sect3>
 </xsl:template>

 <!-- Format a structitem type field. Knows that nested structures don't need an entry element. -->
 <xsl:template name="format-structitem-type">
  <xsl:choose>
   <xsl:when test="name(child::*[1])='structtype'"><xsl:apply-templates/></xsl:when>
   <xsl:when test="name(child::*[1])='arraytype'"><entry><xsl:apply-templates/></entry></xsl:when>
   <xsl:when test="name(child::*[1])='vararraytype'"><entry><xsl:apply-templates/></entry></xsl:when>
   <xsl:when test="@type"><entry><link linkend="type-{@type}"><xsl:value-of select="@type"/></link></entry></xsl:when>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="structitem/structtype">
  <entrytbl cols="2">
   <tbody>
    <xsl:for-each select="structitem">
     <row>
      <xsl:call-template name="format-structitem-type"/>
      <entry>
       <structfield><xsl:value-of select="@name"/></structfield>
      </entry>
     </row>
    </xsl:for-each>
   </tbody>
  </entrytbl>
 </xsl:template>

 <xsl:template match="arraytype">
  <link linkend="type-{@type}"><type><xsl:value-of select="@type"/></type></link>[<xsl:value-of select="@length"/>]
 </xsl:template>

 <xsl:template match="vararraytype">
  <link linkend="type-{@type}"><type><xsl:value-of select="@type"/></type></link>[<xsl:value-of select="@length-min"/>..<xsl:value-of select="@length-max"/>]
 </xsl:template>

 <xsl:template match="desc">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="para">
  <para>
   <xsl:apply-templates/>
  </para>
 </xsl:template>

 <xsl:template match="literal">
  <literal>
   <xsl:apply-templates/>
  </literal>
 </xsl:template>

 <xsl:template match="superscript">
  <superscript><xsl:apply-templates/></superscript>
 </xsl:template>

 <xsl:template match="ulink">
  <ulink url="{@url}"><xsl:apply-templates/></ulink>
 </xsl:template>


 <!--
    Utility template to "compute" 2^x. Only works for some x. True computational method
    risks overflow, so a cut-down table-based approach was used instead.
  -->
 <xsl:template name="power-of-two">
  <xsl:param name="x" select="0"/>
  <xsl:choose>
   <xsl:when test="$x=0">1</xsl:when>
   <xsl:when test="$x=7">128</xsl:when>
   <xsl:when test="$x=8">256</xsl:when>
   <xsl:when test="$x=15">32768</xsl:when>
   <xsl:when test="$x=16">65536</xsl:when>
   <xsl:when test="$x=31">2147483648</xsl:when>
   <xsl:when test="$x=32">4294967296</xsl:when>
   <xsl:otherwise>NaN
    <xsl:message>Can't compute 2^<xsl:value-of select="$x"/></xsl:message>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="name"/>

</xsl:stylesheet>
