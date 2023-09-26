<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- �ĵ�ƥ�� -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ���ڵ� -->
<xsl:template match="GroupList">
	<Table>
		<xsl:apply-templates select="Group"/>
	</Table>
</xsl:template>

<!-- ��ǰ���� ��ڵ� -->
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