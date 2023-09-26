<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- �ĵ�ƥ�� -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ���ڵ� -->
<xsl:template match="Report">
	<xsl:apply-templates select="SummarizeList"/>
</xsl:template>

<!-- ��ǰ���� ��ڵ� -->
<xsl:template match="SummarizeList">
		<xsl:apply-templates select="Summarize"/>
</xsl:template>

<xsl:template match="Summarize">
<table border="0px">
	<thead>
		<tr>
			<td><xsl:value-of select="Station"/>���ۣ�</td>
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