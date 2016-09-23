<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="#all"
	version="2.0">

	<xsl:template match="/">
		<select class="form-control add-filter-object">
			<option value="">Select...</option>
			<xsl:apply-templates select="descendant::res:result"/>
		</select>
	</xsl:template>

	<xsl:template match="res:result">
		<option value="{replace(res:binding[@name='o']/res:uri, 'http://nomisma.org/id/', 'nm:')}">
			<xsl:value-of select="res:binding[@name='label']/res:literal"/>
		</option>
	</xsl:template>

</xsl:stylesheet>