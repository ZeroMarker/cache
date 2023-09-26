<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- �ĵ�ƥ�� -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ���ڵ� -->
<xsl:template match="DHCPEReport">
	<xsl:apply-templates select="PatInfo"/>
</xsl:template>

<!-- ��ǰ���� ��ڵ� -->
<xsl:template match="PatInfo">
	<TABLE>
		<TBODY>
			<TR>
				<TD>
					<TABLE>
						<TBODY>
							<TR>
								<TD id="lPatCompany">��λ��</TD><TD id="PatCompany"><xsl:value-of select="PatCompany"/></TD>
								<TD id="lRegNo">��ţ�</TD><TD id="PatRegNo"><xsl:value-of select="PatRegNo"/></TD>
							</TR>
						</TBODY>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD>
					<TABLE>
						<TBODY>
							<TR>
								<TD id="lPatName">������</TD><TD id="PatName"><xsl:value-of select="PatName"/></TD>
								<TD id="lPatSex">�Ա�</TD><TD id="PatSex"><xsl:value-of select="PatSex"/></TD>
								<TD id="lPatBirthday">���գ�</TD><TD id="PatBirthday"><xsl:value-of select="Birthday"/></TD>
								<TD id="lPatPosition">ְҵ��</TD><TD id="PatPosition"><xsl:value-of select="PatPosition"/></TD>
							</TR>
						</TBODY>
					</TABLE>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
</xsl:template>

</xsl:stylesheet>