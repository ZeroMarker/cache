<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- 文档匹配 -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- 根节点 -->
<xsl:template match="Report">
	<xsl:apply-templates select="GeneralAdvice"/>
</xsl:template>

<!-- 当前数据 起节点 -->
<xsl:template match="GeneralAdvice">
<table border="0px">
	<thead>
		<tr>
			<td><xsl:value-of select="Caption"/></td>
		</tr>
	</thead>
		<tr>
			<td colspan="2" height="1px" class="line"><hr/></td>
		</tr>		
	<tbody>
		<tr>
			<td>
				<pre>
					<xsl:value-of select="Advice"/>
				</pre>
			</td>
		</tr>
	</tbody>
</table>
<hr/>
</xsl:template>

</xsl:stylesheet>