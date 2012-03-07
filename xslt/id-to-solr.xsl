<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:nuds="http://nomisma.org/id/nuds"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="#all" version="2.0">
	<xsl:output method="xml" media-type="text/xml" encoding="UTF-8"/>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="/xhtml:div"/>
		</add>
	</xsl:template>

	<xsl:template match="/xhtml:div">
		<doc>
			<xsl:variable name="id" select="substring-after(translate(@about, '[]', ''), 'nm:')"/>
			<field name="id">
				<xsl:value-of select="$id"/>
			</field>
			<field name="typeof">
				<xsl:value-of select="substring-after(@typeof, 'nm:')"/>
			</field>
			<xsl:if test="string(xhtml:div[@property='skos:prefLabel'][@xml:lang='en'][1])">
				<field name="prefLabel">
					<xsl:value-of select="xhtml:div[@property='skos:prefLabel'][@xml:lang='en'][1]"/>
				</field>
			</xsl:if>
			<xsl:for-each select="xhtml:div[@property='skos:prefLabel'][@xml:lang!='en']">
				<field name="altLabel">
					<xsl:value-of select="."/>
				</field>
			</xsl:for-each>
			<xsl:for-each select="xhtml:div[@property='skos:definition']">
				<field name="definition">
					<xsl:value-of select="."/>
				</field>
			</xsl:for-each>
			<xsl:if test="xhtml:div[@property='owl:sameAs']">
				<field name="object_uri">
					<xsl:value-of select="xhtml:div[@property='owl:sameAs']/@href"/>
				</field>
			</xsl:if>
			<xsl:if test="count(xhtml:div[@property='gml:pos']) = 1">
				<xsl:variable name="pos" select="tokenize(xhtml:div[@property='gml:pos'], ' ')"/>
				<field name="pos">
					<xsl:value-of select="xhtml:div[@property='gml:pos']"/>
				</field>
				<field name="georef">
					<xsl:value-of select="concat('http://nomisma.org/id/', $id)"/>
					<xsl:text>|</xsl:text>
					<xsl:value-of select="normalize-space(xhtml:div[@property='skos:prefLabel'][@xml:lang='en'][1])"/>
					<xsl:text>|</xsl:text>
					<xsl:value-of select="$pos[2]"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$pos[1]"/>
				</field>
			</xsl:if>
			<xsl:for-each select="xhtml:div[@property='skos:related']">
				<field name="related">
					<xsl:value-of select="@href"/>
				</field>
				<xsl:if test="contains(@href, 'pleiades')">
					<field name="pleiades_uri">
						<xsl:value-of select="@href"/>
					</field>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="number(xhtml:div[@property='nm:approximateburialdate_start'])">
				<field name="burial_start">
					<xsl:value-of select="xhtml:div[@property='nm:approximateburialdate_start']"/>
				</field>
			</xsl:if>
			<xsl:if test="number(xhtml:div[@property='nm:approximateburialdate_end'])">
				<field name="burial_start">
					<xsl:value-of select="xhtml:div[@property='nm:approximateburialdate_end']"/>
				</field>
			</xsl:if>
			<field name="timestamp">
				<xsl:variable name="timestamp" select="datetime:dateTime()"/>
				<xsl:choose>
					<xsl:when test="contains($timestamp, 'Z')">
						<xsl:value-of select="$timestamp"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($timestamp, 'Z')"/>
					</xsl:otherwise>
				</xsl:choose>
			</field>
			<field name="fulltext">
				<xsl:value-of select="$id"/>
				<xsl:text> </xsl:text>
				<xsl:for-each select="descendant-or-self::node()">
					<xsl:value-of select="text()"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</field>
		</doc>
	</xsl:template>
</xsl:stylesheet>