<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- 文档匹配 -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- 根节点 -->
<xsl:template match="GroupList">
	<Table>
		<xsl:apply-templates select="Group"/>
	</Table>
</xsl:template>

<!-- 当前数据 起节点 -->
<xsl:template match="Group">
  <tr>
    <td>
	<input type='checkbox'>
		<xsl:attribute name="id"><xsl:value-of select="ID"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="Value"/></xsl:attribute>
	</input>
	</td>
    <td><xsl:value-of select="Text"/></td>
  </tr>
</xsl:template>

</xsl:stylesheet>