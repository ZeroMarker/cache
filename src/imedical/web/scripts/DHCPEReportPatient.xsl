<?xml version="1.0" encoding="gb2312" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<!-- 文档匹配 -->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- 根节点 -->
<xsl:template match="DHCPEReport">
	<xsl:apply-templates select="PatInfo"/>
</xsl:template>

<!-- 当前数据 起节点 -->
<xsl:template match="PatInfo">
	<TABLE>
		<TBODY>
			<TR>
				<TD>
					<TABLE>
						<TBODY>
							<TR>
								<TD id="lPatCompany">单位：</TD><TD id="PatCompany"><xsl:value-of select="PatCompany"/></TD>
								<TD id="lRegNo">编号：</TD><TD id="PatRegNo"><xsl:value-of select="PatRegNo"/></TD>
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
								<TD id="lPatName">姓名：</TD><TD id="PatName"><xsl:value-of select="PatName"/></TD>
								<TD id="lPatSex">性别：</TD><TD id="PatSex"><xsl:value-of select="PatSex"/></TD>
								<TD id="lPatBirthday">生日：</TD><TD id="PatBirthday"><xsl:value-of select="Birthday"/></TD>
								<TD id="lPatPosition">职业：</TD><TD id="PatPosition"><xsl:value-of select="PatPosition"/></TD>
							</TR>
						</TBODY>
					</TABLE>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
</xsl:template>

</xsl:stylesheet>