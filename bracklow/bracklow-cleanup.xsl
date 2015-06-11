<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns="http://www.loc.gov/mods/v3"
  version="3.4">

  <!-- TODO: break out semi-colon delimited lists into individual elements. -->
  <!-- the well-known identity transform. -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Don't emit anything whose text value is the word 'null.' -->
  <!-- TODO: kill parent elements as well. -->
  <xsl:template match="*[text()='null']"/>
  
  <!-- Strip quotation marks from elements. -->
  <xsl:template match="*/text()">
    <xsl:value-of select="replace(., '&quot;', '')"/>
  </xsl:template>
  
  <!-- 'Image' is not a valid value for typeOfResource. -->
  <xsl:template match="//mods:typeOfResource[text()='&quot;Image&quot;']">
    <xsl:element name="typeOfResource">image</xsl:element>
  </xsl:template>
  
  <xsl:template match="//mods:abstract">
    <xsl:element name="abstract">
      <!-- First replace the MSWord "printer's quotes" garbage, then strip the quotation marks in the result.
      Only real way to do this. -->
      <xsl:value-of select="replace(replace(., '\\u2019', ''''), '&quot;', '')"/>
    </xsl:element>
  </xsl:template>
    
  <!-- Remove assorted attribute cruft. -->
  <xsl:template match="mods:languageTerm/@type"/>
  <xsl:template match="mods:relatedItem/@type"/> 
  
</xsl:stylesheet>