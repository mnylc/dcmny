<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mods="http://www.loc.gov/mods/v3"
  version="3.4">
  <xsl:output indent="yes"/>

  <!-- the well-known identity transform. -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- Strip quotation marks and weird MS Word cruft from elements. -->
  <xsl:template match="*/text()">
    <xsl:value-of select="replace(replace(., '\\u2019', ''''), '&quot;', '')"/>
  </xsl:template>

  <!-- Don't emit anything whose text value is the word 'null.' -->
  <xsl:template match="mods:subject[mods:name/mods:namePart[text()='null']]"/>
  <xsl:template match="mods:subject[./mods:topic[./text()='null']]"/>
  <xsl:template match="mods:subject[mods:geographic[text()='null']]"/>

  <!-- 'Image' is not a valid value for typeOfResource. -->
  <xsl:template match="mods:typeOfResource[text()='Image']">
    <xsl:element name="typeOfResource" namespace="http://www.loc.gov/mods/v3">image</xsl:element>
  </xsl:template>

  <xsl:template match="mods:subject[./mods:geographic[not(contains(./text(), 'null'))]]">
      <xsl:variable name="topiclist" select="tokenize(replace(., '&quot;', ''), ';')"/>
      <xsl:for-each select="$topiclist">
        <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
          <xsl:element name="geographic" namespace="http://www.loc.gov/mods/v3">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        </xsl:element>
      </xsl:for-each>
  </xsl:template>

  <xsl:template match="mods:subject[./mods:topic[not(contains(./text(), 'null'))]]">
      <xsl:variable name="topiclist" select="tokenize(replace(., '&quot;', ''), ';')"/>
      <xsl:for-each select="$topiclist">
        <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
          <xsl:element name="topic" namespace="http://www.loc.gov/mods/v3">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        </xsl:element>
      </xsl:for-each>
  </xsl:template>

  <xsl:template match="mods:genre">
    <xsl:variable name="genrelist" select="tokenize(replace(., '&quot;', ''), ';')"/>
      <xsl:for-each select="$genrelist">
        <xsl:element name="genre" namespace="http://www.loc.gov/mods/v3">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:for-each>
  </xsl:template>

  <!-- Remove assorted attribute cruft. -->
  <xsl:template match="mods:languageTerm/@type"/>
  <xsl:template match="mods:relatedItem/@type"/>



</xsl:stylesheet>
