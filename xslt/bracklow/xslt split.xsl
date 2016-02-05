<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//mods:mods">
        <xsl:variable name="filename" select="replace(substring-before(mods:identifier[@type='local']/text(), '.'), '&quot;', '')"/>
        <xsl:result-document method="xml" indent="yes" href="{$filename}.xml">
           <xsl:copy-of select="."/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>