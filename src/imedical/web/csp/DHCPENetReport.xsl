<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<xsl:template match="/">
<DIV class="report">
<DIV class="header">
  <span align="left"><strong><xsl:value-of select="Report/ARCIMDesc"/></strong></span>
</DIV>
<DIV class="result">
	<table width="683">
		<tr>
			<td width="407" height="18"><span align="left"><strong>项目名称</strong></span></td>
			<td width="264"><span align="left"><strong>检查结果</strong></span></td>
		</tr>
		
			<xsl:for-each select="Report/Result/Value">
			<tr>
			<td><span align="left"><xsl:value-of select="TestName"/></span></td>
			<td><span align="left"><xsl:value-of select="TestValue"/></span></td>
			</tr>
			</xsl:for-each>
	</table>
</DIV>
<DIV class="footer">
<table width="683">
		<tr>
			<td width="75" height="18">检查日期:</td><td width="88" height="18"><xsl:value-of select="report/Checker"/></td>
			<td width="254"> </td>
			<td width="80">检查医生：</td><td width="143"><xsl:value-of select="Report/TestDate"/></td>
			<td width="15"> </td>
		</tr>
	</table>
	<hr/>
</DIV>
</DIV>
</xsl:template>

</xsl:stylesheet>
