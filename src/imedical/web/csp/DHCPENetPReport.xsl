<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<xsl:template match="/">
<table width="707" height="68">
	<tr>
		<td>
		<table>
			<tr>
				<td width="83" height="30"><span align="left"><strong>��λ��</strong></span></td>
				<td width="295"><xsl:value-of select="PatInfo/PatCompany"/></td>            
				<td width="146"><span align="left"><strong>��ţ�</strong></span></td>          
				<td width="163"><xsl:value-of select="PatInfo/RegNo"/></td>
			</tr>
		</table>
		</td>

		</tr>
		<tr>
			<td>
			<table>
				<tr>
				<td width="75"><span align="left"><strong>������</strong></span></td>
				<td width="89"><xsl:value-of select="PatInfo/PatName"/></td>
				<td width="146"><span align="left"><strong>�Ա�</strong></span>    </td>   
				<td width="295"><xsl:value-of select="PatInfo/PatSex"/></td>     
				<td width="163"><span align="left">����</span></td>
				<td width="295"><xsl:value-of select="PatInfo/Birthday"/></td>  
				<td width="163"><span align="left">ְҵ��</span></td>
				<td width="295"></td>  
			</tr>
	
			</table>
			</td>
		</tr>
	</table>


</xsl:template>

</xsl:stylesheet>
