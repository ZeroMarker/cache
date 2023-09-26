<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- �ĵ�ƥ�� -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ���ڵ� -->
<xsl:template match="Report">
	<xsl:apply-templates select="ReportList"/>
</xsl:template>

<!-- ��ǰ���� ��ڵ� -->
<xsl:template match="ReportList">
		<xsl:apply-templates select="DHCPEReport"/>
</xsl:template>

<xsl:template match="DHCPEReport">
	<DIV class="report">
<table border="0px">
	<thead>
		<tr>
			<td colspan="2" class="TestName"><xsl:value-of select="ARCIMDesc"/></td>
		</tr>

	</thead>

	<tbody>
		<tr>
			<td colspan="2" height="1px" class="line"><hr/></td>
		</tr>	
		<tr>
			<th>��Ŀ����</th>
			<th>�����</th>
		</tr>
		
		<tr>
			<td colspan="2" height="1px" class="line"><hr/></td>
		</tr>
		
		<xsl:apply-templates select="Result"/>
		
		<tr>
			<td colspan="2" height="1px"  class="line"><hr/></td>
		</tr>		
	</tbody>
	<tfoot>
		<tr>
			<td>���ҽ��:<label class="Checker"><xsl:value-of select="Checker"/></label></td>
			<td>�������:<label class="CheckDate"><xsl:value-of select="TestDate"/></label></td>
		</tr>
	</tfoot>
</table>
<hr/>
</DIV>
</xsl:template>

<xsl:template match="Result">
		<xsl:apply-templates select="Value"/>
</xsl:template>

<xsl:template match="Value">
		<tr>
			<td class="ResultName"><xsl:value-of select="TestName"/></td>
			<td class="ResultValue"><xsl:value-of select="TestValue"/></td>
		</tr>
</xsl:template>

</xsl:stylesheet>