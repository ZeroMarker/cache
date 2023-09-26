<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- 文档匹配 -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- 根节点 -->
<xsl:template match="Report">
	<xsl:apply-templates select="SummarizeList"/>
</xsl:template>

<!-- 当前数据 起节点 -->
<xsl:template match="SummarizeList">
		<xsl:apply-templates select="Summarize"/>
</xsl:template>

<xsl:template match="Summarize">
<table border="0px">
	<thead>
		<tr>
			<td><xsl:value-of select="Station"/>结论：</td>
		</tr>
	</thead>
		<tr>
			<td colspan="2" height="1px" class="line"><hr/></td>
		</tr>		
	<tbody>
		<tr>
			<td>
				<pre>
					<xsl:value-of select="Desc"/>
				</pre>
			</td>
		</tr>
	</tbody>
</table>
<hr/>
</xsl:template>

<xsl:template match="Station">
		<tr>
			<td>
				<pre>
					<xsl:value-of select="Desc"/>
				</pre>
			</td>
		</tr>
</xsl:template>


</xsl:stylesheet>