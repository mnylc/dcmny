<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mods="http://www.loc.gov/mods/v3"
  version="3.4">
  <xsl:output indent="no"/>

  <!-- the well-known identity transform. -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- Don't emit anything whose text value is the word 'null.' -->
  <xsl:template match="mods:subject[mods:name/mods:namePart[text()='null']]"/>
  <xsl:template match="mods:subject[./mods:topic[./text()='null']]"/>
  <xsl:template match="mods:subject[mods:geographic[text()='null']]"/>
  <xsl:template match="mods:subject[mods:temporal[text()='null']]"/>
  <xsl:template match="mods:name[mods:namePart[text()='null']]"/>
  <xsl:template match="mods:originInfo[mods:dateCreated[text()='null']]"/>
  
  <xsl:template match="mods:typeOfResource">
    <xsl:variable name="typelist" select="tokenize(., ';')"/>
    <xsl:for-each select="$typelist">
    <xsl:element name="typeOfResource" namespace="http://www.loc.gov/mods/v3">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mods:language">
    <xsl:variable name="languagelist" select="tokenize(., ';')"/>
    <xsl:for-each select="$languagelist">
      <xsl:element name="language" namespace="http://www.loc.gov/mods/v3">
        <xsl:element name="languageTerm" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="type">code</xsl:attribute>
          <xsl:attribute name="authority">iso639-2b</xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mods:subject[./mods:name[@type='personal']/namePart[not(contains(./text(), 'null'))]]">
    <xsl:variable name="namelist" select="tokenize(replace(., '&quot;', ''), ';')"/>
    <xsl:for-each select="$namelist">
      <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
        <xsl:attribute name="authority">fast</xsl:attribute>
        <xsl:element name="name" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="type">personal</xsl:attribute>
            <xsl:element name="namePart" namespace="http://www.loc.gov/mods/v3">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mods:subject[./mods:name[@type='corporate']/namePart[not(contains(./text(), 'null'))]]">
    <xsl:variable name="namelist" select="tokenize(replace(., '&quot;', ''), ';')"/>
    <xsl:for-each select="$namelist">
      <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
        <xsl:attribute name="authority">fast</xsl:attribute>
        <xsl:element name="name" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="type">corporate</xsl:attribute>
            <xsl:element name="namePart" namespace="http://www.loc.gov/mods/v3">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  

  <xsl:template match="mods:subject[./mods:geographic[not(contains(./text(), 'null'))]]">
      <xsl:variable name="topiclist" select="tokenize(replace(., '&quot;', ''), ';')"/>
      <xsl:for-each select="$topiclist">
        <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="authority">fast</xsl:attribute>
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
          <xsl:attribute name="authority">fast</xsl:attribute>
          <xsl:element name="topic" namespace="http://www.loc.gov/mods/v3">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        </xsl:element>
      </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mods:subject[./mods:temporal[not(contains(./text(), 'null'))]]">
    <xsl:variable name="temporallist" select="tokenize(replace(., '&quot;', ''), ';')"/>
    <xsl:for-each select="$temporallist">
      <xsl:element name="subject" namespace="http://www.loc.gov/mods/v3">
        <xsl:attribute name="authority">fast</xsl:attribute>
        <xsl:element name="temporal" namespace="http://www.loc.gov/mods/v3">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="mods:dateCreated">
    <xsl:call-template name="date-to-mods">
      <xsl:with-param name="dateval">
        <xsl:value-of select="normalize-space(.)"/>                    
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template name="date-to-mods">
    <xsl:param name="dateval"/>
    <xsl:variable name="date_list" select="tokenize($dateval, ';')"/>
    <xsl:variable name="list_length" select="count($date_list)"/>
    <xsl:choose>
      <xsl:when test="$list_length > 1">
        <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
          <xsl:attribute name="keyDate">yes</xsl:attribute>
          <xsl:attribute name="point">start</xsl:attribute>
          <xsl:call-template name="datequal">
            <xsl:with-param name="dateval" select="$date_list[1]"/>
          </xsl:call-template>
          <xsl:call-template name="clean-date">
            <xsl:with-param name="dateval">
              <xsl:value-of select="normalize-space($date_list[1])"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
        
        <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
          <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
          <xsl:attribute name="point">end</xsl:attribute>
          <xsl:call-template name="datequal">
            <xsl:with-param name="dateval" select="normalize-space($date_list[$list_length])"/>
          </xsl:call-template>
          <xsl:call-template name="clean-date">
            <xsl:with-param name="dateval">
              <xsl:value-of select="normalize-space($date_list[$list_length])"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:variable name="date_parts" select="tokenize($dateval, '-')"/>
        <xsl:variable name="parts_length" select="count($date_parts)"/>
        <xsl:choose>
          <xsl:when test="$parts_length = 3">
            <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
              <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
              <xsl:attribute name="keyDate">yes</xsl:attribute>
              <xsl:call-template name="datequal">
                <xsl:with-param name="dateval" select="normalize-space(.)"/>
              </xsl:call-template>
              <xsl:call-template name="clean-date">
                <xsl:with-param name="dateval">
                  <xsl:value-of select="."/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:element>                                             
          </xsl:when>
          <xsl:when test="$parts_length = 2">
            <xsl:choose>
              <xsl:when test="string-length($date_parts[2]) >= 4">
                <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
                  <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                  <xsl:attribute name="keyDate">yes</xsl:attribute>
                  <xsl:attribute name="point">start</xsl:attribute>
                  <xsl:call-template name="datequal">
                    <xsl:with-param name="dateval" select="normalize-space($date_parts[1])"/>
                  </xsl:call-template>
                  <xsl:call-template name="clean-date">
                    <xsl:with-param name="dateval">
                      <xsl:value-of select="normalize-space($date_parts[1])"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:element>
                <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
                  <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                  <xsl:attribute name="point">end</xsl:attribute>
                  <xsl:call-template name="datequal">
                    <xsl:with-param name="dateval" select="normalize-space($date_parts[2])"/>
                  </xsl:call-template>
                  <xsl:call-template name="clean-date">
                    <xsl:with-param name="dateval">
                      <xsl:value-of select="normalize-space($date_parts[2])"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
                  <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                  <xsl:attribute name="keyDate">yes</xsl:attribute>
                  <xsl:call-template name="datequal">
                    <xsl:with-param name="dateval" select="normalize-space($date_parts[1])"/>
                  </xsl:call-template>
                  <xsl:call-template name="clean-date">
                    <xsl:with-param name="dateval">
                      <xsl:value-of select="normalize-space($date_parts[1])"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="normalize-space(.)!='9999'">
              <xsl:element name="dateCreated" namespace="http://www.loc.gov/mods/v3">
                <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                <xsl:attribute name="keyDate">yes</xsl:attribute>
                <xsl:call-template name="datequal">
                  <xsl:with-param name="dateval" select="normalize-space(.)"/>
                </xsl:call-template>
                <xsl:call-template name="clean-date">
                  <xsl:with-param name="dateval">
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:element>   
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- determine qualifier attribute for date element. -->
  <xsl:template name="datequal">
    <xsl:param name="dateval"/>
    <xsl:choose>
      <xsl:when test="starts-with(lower-case($dateval), 'c')">
        <xsl:attribute name="qualifier" exclude-result-prefixes="#all">approximate</xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($dateval, '?')">
        <xsl:attribute name="qualifier" exclude-result-prefixes="#all">questionable</xsl:attribute>
      </xsl:when>
      <xsl:when test="contains($dateval, '[')">
        <xsl:attribute name="qualifier" exclude-result-prefixes="#all">inferred</xsl:attribute>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>        
  </xsl:template>
  
  <!-- strip superfluous characters from date once it's been qualified -->
  <xsl:template name="clean-date">
    <xsl:param name="dateval"/>
    <xsl:value-of select="replace($dateval, '[^0-9\-/]', '')"/>
  </xsl:template>



</xsl:stylesheet>
