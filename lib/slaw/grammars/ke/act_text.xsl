<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:a="http://www.akomantoso.org/2.0"
  exclude-result-prefixes="a">

  <xsl:output method="text" indent="no" omit-xml-declaration="yes" />
  <xsl:strip-space elements="*"/>

  <!-- adds a backslash to the start of the value param, if necessary -->
  <xsl:template name="escape">
    <xsl:param name="value"/>

    <xsl:variable name="prefix" select="translate(substring($value, 1, 10), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
    <!-- '(' is considered special, so translate numbers into '(' so we can find and escape them -->
    <xsl:variable name="numprefix" select="translate(substring($value, 1, 3), '1234567890', '((((((((((')" />

    <!-- p tags must escape initial content that looks like a block element marker -->
    <xsl:if test="$prefix = 'BODY' or
                  $prefix = 'PREAMBLE' or
                  $prefix = 'PREFACE' or
                  starts-with($prefix, 'CHAPTER ') or
                  starts-with($prefix, 'PART ') or
                  starts-with($prefix, 'SCHEDULE ') or
                  starts-with($prefix, '{|') or
                  starts-with($numprefix, '(')">
      <xsl:text>\</xsl:text>
    </xsl:if>
    <xsl:value-of select="$value"/>
  </xsl:template>

  <xsl:template match="a:act">
    <xsl:apply-templates select="a:coverPage" />
    <xsl:apply-templates select="a:preface" />
    <xsl:apply-templates select="a:preamble" />
    <xsl:apply-templates select="a:body" />
    <xsl:apply-templates select="a:conclusions" />
  </xsl:template>

  <xsl:template match="a:preface">
    <xsl:text>PREFACE</xsl:text>
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="a:preamble">
    <xsl:text>PREAMBLE</xsl:text>
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="a:part">
    <xsl:text>Part </xsl:text>
    <xsl:value-of select="a:num" />
    <xsl:text> - </xsl:text>
    <xsl:apply-templates select="a:heading" />
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
  </xsl:template>

  <xsl:template match="a:chapter">
    <xsl:text>Chapter </xsl:text>
    <xsl:value-of select="a:num" />
    <xsl:text> - </xsl:text>
    <xsl:apply-templates select="a:heading" />
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
  </xsl:template>

  <xsl:template match="a:section">
    <xsl:value-of select="a:num" />
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="a:heading" />
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
  </xsl:template>

  <xsl:template match="a:subsection">
    <xsl:if test="a:num != ''">
      <xsl:value-of select="a:num" />
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:apply-templates select="./*[not(self::a:num) and not(self::a:heading)]" />
  </xsl:template>

  <!-- crossheadings -->
  <xsl:template match="a:hcontainer[@name='crossheading']">
    <xsl:text>CROSSHEADING </xsl:text>
    <xsl:apply-templates select="a:heading" />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- longtitle -->
  <xsl:template match="a:longTitle">
    <xsl:text>LONGTITLE </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <!-- p tags must end with a blank line -->
  <xsl:template match="a:p">
    <xsl:apply-templates/>
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="a:blockList">
    <xsl:if test="a:listIntroduction != ''">
      <xsl:apply-templates select="a:listIntroduction" />
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="./*[not(self::a:listIntroduction)]" />
  </xsl:template>

  <xsl:template match="a:item">
    <xsl:value-of select="a:num" />
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="./*[not(self::a:num)]" />
  </xsl:template>

  <xsl:template match="a:list">
    <xsl:if test="a:intro != ''">
      <xsl:apply-templates select="a:intro" />
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="./*[not(self::a:intro)]" />
  </xsl:template>

  <!-- first text nodes of these elems must be escaped if they have special chars -->
  <xsl:template match="a:p[not(ancestor::a:table)]/text()[1] | a:listIntroduction/text()[1] | a:intro/text()[1]">
    <xsl:call-template name="escape">
      <xsl:with-param name="value" select="." />
    </xsl:call-template>
  </xsl:template>


  <!-- components/schedules -->
  <!-- new-style schedules, "article" elements -->
  <xsl:template match="a:hcontainer[@name='schedule']">
    <xsl:text>SCHEDULE - </xsl:text>
    <xsl:apply-templates select="a:heading" />
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="a:subheading">
      <xsl:apply-templates select="a:subheading" />
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates select="./*[not(self::a:heading) and not(self::a:subheading)]" />
  </xsl:template>


  <!-- old-style schedules, "article" elements -->
  <xsl:template match="a:doc/a:mainBody/a:article">
    <xsl:text>Schedule - </xsl:text>
    <xsl:value-of select="../../a:meta/a:identification/a:FRBRWork/a:FRBRalias/@value" />
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="not(a:mainBody/a:article/a:heading)">
      <!-- ensure an extra blank line if there is no heading -->
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="a:mainBody" />
  </xsl:template>


  <!-- tables -->
  <xsl:template match="a:table">
    <xsl:text>{| </xsl:text>

    <!-- attributes -->
    <xsl:for-each select="@*[local-name()!='id']">
      <xsl:value-of select="local-name(.)" />
      <xsl:text>="</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>" </xsl:text>
    </xsl:for-each>
    <xsl:text>
|-</xsl:text>

    <xsl:apply-templates />
    <xsl:text>
|}

</xsl:text>
  </xsl:template>

  <xsl:template match="a:tr">
    <xsl:apply-templates />
    <xsl:text>
|-</xsl:text>
  </xsl:template>

  <xsl:template match="a:th|a:td">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'th'">
        <xsl:text>
! </xsl:text>
      </xsl:when>
      <xsl:when test="local-name(.) = 'td'">
        <xsl:text>
| </xsl:text>
      </xsl:when>
    </xsl:choose>

    <!-- attributes -->
    <xsl:if test="@*">
      <xsl:for-each select="@*">
        <xsl:value-of select="local-name(.)" />
        <xsl:text>="</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>" </xsl:text>
      </xsl:for-each>
      <xsl:text>| </xsl:text>
    </xsl:if>

    <xsl:apply-templates />
  </xsl:template>

  <!-- don't end p tags with newlines in tables -->
  <xsl:template match="a:table//a:p">
    <xsl:apply-templates />
  </xsl:template>

  <!-- END tables -->

  <xsl:template match="a:remark">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="a:ref">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@href" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="a:img">
    <xsl:text>![</xsl:text>
    <xsl:value-of select="@alt" />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@src" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="a:i">
    <xsl:text>//</xsl:text>
    <xsl:apply-templates />
    <xsl:text>//</xsl:text>
  </xsl:template>

  <xsl:template match="a:b">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates />
    <xsl:text>**</xsl:text>
  </xsl:template>

  <xsl:template match="a:eol">
    <xsl:text>&#10;</xsl:text>
  </xsl:template>


  <!-- for most nodes, just dump their text content -->
  <xsl:template match="*">
    <xsl:text/><xsl:apply-templates /><xsl:text/>
  </xsl:template>
  
</xsl:stylesheet>
