<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" language="JavaScript">

<!-- 根节点-->
<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- 入口节点-->
<xsl:template match="tree">
	<xsl:apply-templates select="Node"/>
</xsl:template>

<xsl:template match="Node">
	<div class="NodeDIV" onclick="clickOnEntity(this);ClickOnCustom(this);" onselectstart="return false" ondragstart="return false">
	
	<xsl:attribute name="open">false</xsl:attribute>
	<xsl:attribute name="ChildCount">
		<xsl:value-of select="ChildCount"/>
	</xsl:attribute>
	<xsl:attribute name="id">
		<xsl:value-of select="ID"/>
	</xsl:attribute>
	<xsl:attribute name="URL">
		<xsl:value-of select="URL"/>
	</xsl:attribute>
	<xsl:attribute name="Caption">
		<xsl:value-of select="Text"/>
	</xsl:attribute>

	<xsl:attribute name="STYLE"><xsl:if expr="depth(this) > 3">display: none;</xsl:if></xsl:attribute>
	<table>
		<tr>
			<xsl:apply-templates select="Spaces"/>
			<xsl:apply-templates select="checked"/>
        	<xsl:apply-templates select="Image"/>
        	<td class="NodeTD">
				<xsl:value-of select="Text"/>
			</td>
		</tr>
	</table>
	<xsl:apply-templates select="Node"/>
	</div>
</xsl:template>
<!-- 显示图片-->
<xsl:template match="Spaces">
	<xsl:value-of select="."/>
</xsl:template>

<!-- 显示图片-->
<xsl:template match="Image">
	<td>
		<img border="0" src="../images/websys/edit.gif"/>
	</td>
</xsl:template>


<!-- 选择框 -->
<xsl:template match="checked">
	<td class="select">
		<input type="checkbox" onclick="checkedOnEntity(this);checkedOnCustom(this);">
			<xsl:attribute name="id">
				<xsl:value-of select="ID"/>
			</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="Value"/>
			</xsl:attribute>
		</input>
	</td>
</xsl:template>

</xsl:stylesheet>