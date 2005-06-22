<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
 <!ENTITY paramintro "The following table shows how the command is encoded for network transmission:">
]>

<!--

 An XSLT transform from home-grown command XML format to DocBook.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 <xsl:output method="xml" indent="yes"/>

 <xsl:template match="/">
  <xsl:comment>This file is automatically generated, do not hand edit.</xsl:comment>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="commands">
  <xsl:variable name="anch"><xsl:value-of select="@node"/>-commands</xsl:variable>
  <sect1 id="{$anch}">
   <title><xsl:value-of select="concat(translate(substring(@node, 1, 1), 'sogmbtca', 'SOGMBTCA'),
                                       substring(@node, 2))"/> Node Commands</title>
  <xsl:apply-templates/>
  </sect1>

  <!-- Print nerdy statistics. -->
  <xsl:variable name="numcmd"><xsl:value-of select="count(command)"/></xsl:variable>
  <xsl:variable name="numalias"><xsl:value-of select="count(command/alias)"/></xsl:variable>
   <xsl:variable name="cmddesc"><xsl:value-of select="count(command/desc)"/></xsl:variable>
   <xsl:variable name="aliasdesc"><xsl:value-of select="count(command/alias/desc)"/></xsl:variable>
   <xsl:variable name="totdesc"><xsl:value-of select="$cmddesc+$aliasdesc"/></xsl:variable>
   <xsl:variable name="descquot"><xsl:value-of select="100 * $totdesc div ($numcmd+$numalias)"/></xsl:variable>
  <xsl:message><xsl:value-of select="@node"/>: Emitted <xsl:value-of select="$numcmd"/>+<xsl:value-of select="$numalias"/> commands. <xsl:value-of select="$totdesc"/> descriptions, coverage is <xsl:value-of select="format-number($descquot, '##.#')"/>%.</xsl:message>
 </xsl:template>

 <xsl:template match="commands/desc">
  <sect2>
   <sect>
    <title>
     <xsl:value-of select="@title"/>
    </title>
    <xsl:apply-templates/>
   </sect>
  </sect2>
 </xsl:template>

 <xsl:template match="commands/desc/para">
  <para>
   <xsl:apply-templates/>
  </para>
 </xsl:template>

 <xsl:template match="commands/command">

  <xsl:variable name="refid">
   <xsl:value-of select="../@prefix"/><xsl:if test="../@prefix">_</xsl:if>
   <xsl:value-of select="./meta/name"/>
  </xsl:variable>

  <refentry id="{$refid}">
   <xsl:apply-templates select="*[not(self::alias)]"/>
  </refentry>
  <xsl:apply-templates select="*[self::alias]"/>
 </xsl:template>

 <xsl:template match="commands/command/meta">
  <refnamediv>
   <xsl:apply-templates/>
  </refnamediv>
 </xsl:template>

 <xsl:template match="commands/command/meta/name">
  <refname>
   <xsl:value-of select="ancestor::*[command]/@prefix"/><xsl:if test="ancestor::*[command]/@prefix">_</xsl:if><xsl:value-of select="text()"/>
   <!-- Make commands without any parameters stand out real good. -->
   <xsl:if test="not(../../params)">
    <xsl:text disable-output-escaping="yes">&amp;xcirc;</xsl:text>
   </xsl:if>
   <xsl:if test="not(../../desc)">
    <xsl:text disable-output-escaping="yes">&amp;xdtri;</xsl:text>
   </xsl:if>
  </refname>
 </xsl:template>

 <xsl:template match="commands/command/meta/purpose">
  <refpurpose>
   <xsl:value-of select="text()"/>
  </refpurpose>
 </xsl:template>


 <xsl:template match="commands/command/params">
  <refsect1>
   <title>Parameter Format</title>
   <para>&paramintro;
   <informaltable>
    <tgroup cols="3">
     <colspec colname='col-type' colwidth='1*'/>
     <colspec colname='col-name' colwidth='1*'/>
     <colspec colname='col-desc' colwidth='6*'/>
     <spanspec spanname='post-address' namest='col-type' nameend='col-desc'/>
     <thead>
      <row><entry>Type</entry><entry>Name</entry><entry>Description</entry></row>
     </thead>
     <tbody>
      <row><entry><link linkend="type-uint8"><type>uint8</type></link></entry><entry><varname>id</varname>
        =
       <literal><xsl:value-of select="ancestor::command[1]/@id"/></literal>
      </entry><entry>The command byte that identifies this command.</entry></row>
      <xsl:apply-templates/>

      <!-- If we have an explicit, field-adding, alias, emit param row for that. -->
      <xsl:if test="../*[self::alias][@add-field='yes']">
       <xsl:variable name="alink"><xsl:value-of select="../../@prefix"/><xsl:if test="../../@prefix">_</xsl:if><xsl:value-of select="following-sibling::alias/meta/name"/></xsl:variable>
       <row>
        <entry><link linkend="type-uint8"><type>uint8</type></link></entry>
        <entry><varname>alias</varname> = <literal>0</literal></entry>
        <entry>If this field is zero (<literal>FALSE</literal>), <emphasis>aliasing</emphasis> is activated, and
the command should be interpreted as a <link linkend="{$alink}"><xsl:value-of select="$alink"/></link> instead. It
is encoded as one (TRUE) to indicate
<xsl:value-of select="ancestor::*[command]/@prefix"/><xsl:if test="ancestor::*[command]/@prefix">_</xsl:if>
<xsl:value-of select="ancestor::command[1]/meta/name/text()"/>.
        </entry>
       </row>
      </xsl:if>
     </tbody>
    </tgroup>
   </informaltable>
   </para>
  </refsect1>
 </xsl:template>

 <!-- Emit a separator row after address part of command. Only if there are non-address parts following. -->
 <xsl:template match="commands/command/params/address">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::param">
   <row rowsep='0'>
    <entry align='center' spanname='post-address'>(End of address part of command, below is data payload)</entry>
   </row>
  </xsl:if>
 </xsl:template>

 <xsl:template match="commands/command/params//param[not(@send='no')]">
  <row>
   <xsl:call-template name="do-param"/>
  </row>
 </xsl:template>

 <xsl:template match="param[@send='no']"/>	<!-- Suppress non-sending parameters. -->

 <!-- Emit a single parameter, as table entries. -->
 <xsl:template name="do-param">
  <xsl:param name="in-alias" select="false"/>
  <!-- Type name. -->
  <entry>
   <xsl:apply-templates select="type"/>
  </entry>

  <!-- Field name. -->
  <entry>
   <varname>
    <xsl:value-of select="name"/>
   </varname>
   <xsl:if test="$in-alias='true'">
    <xsl:if test="alias/value">
     =
     <literal>
     <xsl:value-of select="alias/value"/>
     </literal>
    </xsl:if>
   </xsl:if>
  </entry>

  <!-- Description. -->
  <entry>
   <xsl:if test="not($in-alias='true')">
    <xsl:value-of select="desc"/>
    <xsl:if test="type[@union-control]">
    The content of this union value is controlled by the
    <varname><xsl:value-of select="type/@union-control"/></varname>
    parameter, above.
    </xsl:if>
   </xsl:if>
   <xsl:if test="$in-alias='true'">
    <xsl:if test="alias/desc">
     <xsl:value-of select="alias/desc"/>
    </xsl:if>
    <xsl:if test="not(alias/desc)">
     <xsl:if test="alias/value">
      Reserved value used for alias-detection in the encoding.
     </xsl:if>
     <xsl:if test="not(alias/value)">
      <xsl:if test="alias[@skip='yes']">
       (Ignored for this aliased command, not present in encoded form.)
      </xsl:if>
      <xsl:if test="not(alias[@skip='yes'])">
        (Ignored for this aliased command, but must still be present.)
      </xsl:if>
     </xsl:if>
    </xsl:if>
   </xsl:if>
   <xsl:if test="@masked">
    This parameter is only present if bit <literal><xsl:value-of select="substring-after(@masked, ':')"/></literal> of the
<varname><xsl:value-of select="substring-before(@masked, ':')"/></varname> parameter is set.
   </xsl:if>
  </entry>
 </xsl:template>

 <!-- Type templates. -->

 <xsl:template match="type">
  <xsl:variable name="typename"><xsl:value-of select="."/></xsl:variable>
  <link linkend="type-{$typename}">
   <type>
    <xsl:value-of select="$typename"/>
   </type>
  </link>
  <xsl:if test="@array-length">[<xsl:value-of select="@array-length"/>]</xsl:if>
  <xsl:if test="@array-lengths">
  </xsl:if>
 </xsl:template>

 <xsl:template match="commands/command/desc">
  <refsect1>
   <title>Description</title>
   <xsl:apply-templates/>
  </refsect1>
 </xsl:template>

 <xsl:template match="boilerplate">
  <xsl:if test="@context='subscribe'">
   <xsl:variable name="article">
    <xsl:call-template name="compute-article">
     <xsl:with-param name="x"><xsl:value-of select="@what"/></xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <para>This command is sent by a client that wishes to subscribe to
   <xsl:value-of select="$article"/><xsl:text> </xsl:text>
   <xsl:value-of select="@what"/>.
   </para>
   <para>
   If the request is granted by the host, it will add the client to the list of subscribers to
the referenced <xsl:value-of select="@what"/>, and send a description of its current contents.
The host will continue to send updates as the contents change, until the client unsubscribes or the
<xsl:value-of select="@what"/> is destroyed. If the request to subscribe is denied, nothing happens.
</para>
<para>
It is only possible to subscribe once to a specific <xsl:value-of select="@what"/>, any further
attempts to subscribe will have no effect.
</para>
  </xsl:if>
  <xsl:if test="@context='unsubscribe'">
   <xsl:variable name="article">
    <xsl:call-template name="compute-article">
     <xsl:with-param name="x"><xsl:value-of select="@what"/></xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <para>
     Stop subscribing to <xsl:value-of select="$article"/><xsl:text> </xsl:text><xsl:value-of select="@what"/>.
The host is asked to remove the sending client from the list of subscribers to the indicated
<xsl:value-of select="@what"/>. If granted, the client will no longer receive updates as the contents
of said <xsl:value-of select="@what"/> change. If denied, nothing happens.
   </para>
  </xsl:if>
  <xsl:apply-templates/>
 </xsl:template>

 <!-- Do magic to format a command description. Can contain embedded links. -->
 <xsl:template match="//command//desc/para">
  <para>
   <xsl:for-each select="child::node()">
    <xsl:choose>
     <xsl:when test="self::link">
      <xsl:call-template name="do-link"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="."/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:for-each>
  </para>
 </xsl:template>

 <xsl:template name="do-link">
  <link linkend="{@target}"><xsl:value-of select="text()"/></link>
 </xsl:template>

 <!-- Helper template for boilerplate generation. -->
 <xsl:template name="compute-article">
  <xsl:param name="x" select="nothing"/>
  a<xsl:if test="contains('aeiou', substring($x, 1, 1))">n</xsl:if>
 </xsl:template>

 <!-- Generate an alias reference entry. -->
 <xsl:template match="commands/command/alias">
  <xsl:variable name="refid">
   <xsl:value-of select="ancestor::*[command]/@prefix"/>
   <xsl:if test="ancestor::*[command]/@prefix">_</xsl:if>
   <xsl:value-of select="./meta/name"/>
  </xsl:variable>
  <xsl:variable name="alink">
   <xsl:value-of select="../../@prefix"/><xsl:if test="../../@prefix">_</xsl:if><xsl:value-of select="preceding-sibling::meta/name"/>
  </xsl:variable>
  <refentry id="{$refid}">

   <!-- Generate name and purpose part. -->
   <refnamediv>
    <refname>
     <xsl:value-of select="ancestor::*[command]/@prefix"/><xsl:if test="ancestor::*[command]/@prefix">_</xsl:if><xsl:value-of select="meta/name"/>
     <xsl:if test="not(desc)">
      <xsl:text disable-output-escaping="yes">&amp;xdtri;</xsl:text>
     </xsl:if>
    </refname>
    <refpurpose><!--<anchor id="{$refid}"/> --> <xsl:value-of select="meta/purpose"/> </refpurpose>
   </refnamediv>

   <!-- Generate alias parameter table. -->
   <refsect1>
    <title>Parameter Format</title>
    <para>&paramintro;
     <informaltable>
      <tgroup cols="3">
       <thead>
        <row><entry>Type</entry><entry>Name</entry><entry>Description</entry></row>
       </thead>
       <tbody>
        <row><entry><link linkend="type-uint8"><type>uint8</type></link></entry><entry><varname>id</varname> =
         <literal><xsl:value-of select="ancestor::command[1]/@id"/></literal>
        </entry><entry>The command byte that identifies this command. Since this command is an alias
for <link linkend="{$alink}"><xsl:value-of select="$alink"/></link>, this value is shared with that command.
To identify it as an alias, certain fields are given specific values, see below.</entry></row>
         <xsl:for-each select="preceding-sibling::params/*">
          <xsl:if test="self::address">
           <xsl:for-each select="param">
            <row class="address">
             <xsl:call-template name="do-param">
              <xsl:with-param name="in-alias">true</xsl:with-param>
             </xsl:call-template>
            </row>
           </xsl:for-each>
          </xsl:if>
          <xsl:if test="self::param">
           <row>
            <xsl:call-template name="do-param">
             <xsl:with-param name="in-alias">true</xsl:with-param>
            </xsl:call-template>
           </row>
          </xsl:if>
         <xsl:value-of select="descendant-or-self::*/meta/type"/>
        </xsl:for-each>

        <!-- If field-adding alias, add an alias field to the table. -->
        <xsl:if test="@add-field='yes'">
         <row>
          <entry><link linkend="type-uint8"><type>uint8</type></link></entry>
          <entry><varname>alias</varname> = <literal>1</literal></entry>
          <entry>A boolean that indicates that this command is, in fact, an alias.</entry>
         </row>
        </xsl:if>
       </tbody>
      </tgroup>
     </informaltable>
    </para>
   </refsect1>

   <!-- Generate alias description. -->
   <xsl:if test="desc">
    <refsect1>
     <title>Description</title>
     <xsl:apply-templates select="desc/*"/>
    </refsect1>
   </xsl:if>
  </refentry>
 </xsl:template>

 <xsl:template match="command/alias/desc/para">
  <para>
   <xsl:apply-templates/>
  </para>
 </xsl:template>

</xsl:stylesheet>
