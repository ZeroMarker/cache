/// 培养基结果
Class dbo.IDPCultureMedRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_CultureMedRes ]
{

Index IndexMaster On (IDPResultDR, Sequence, IDPCultureMediumDR) [ SqlName = Index_Master, Type = index ];

Index IndexContainerCode On ContainerCode [ SqlName = Index_ContainerCode, Type = index ];

/// Foreign Key FKIDPCultureMedResIDpMachDR created via DDL
ForeignKey FKIDPCultureMedResIDPMachDR(IDPMachDR) References dbo.BTIDPMach(PKBTIDPMACH) [ SqlName = FK_IDPCultureMedResIDPMachDR ];

/// Foreign Key FKIDPCultureMedResOrganismDR created via DDL
ForeignKey FKIDPCultureMedResOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_IDPCultureMedResOrganismDR ];

/// Foreign Key FKIDPCultureMedResIDPResultDR created via DDL
ForeignKey FKIDPCultureMedResIDPResultDR(IDPResultDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPCultureMedResIDPResultDR ];

/// Foreign Key FKIDPCultureMedResIDPCultureMediumDR created via DDL
ForeignKey FKIDPCultureMedResIDPCultureMediumDR(IDPCultureMediumDR) References dbo.BTIDPCultureMedium(PKBTIDPCULTUREMEDIUM) [ SqlName = FK_IDPCultureMedResIDPCultureMediumDR ];

/// Foreign Key FKIDPCultureMedResOperUserDR created via DDL
ForeignKey FKIDPCultureMedResOperUserDR(OperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPCultureMedResOperUserDR ];

/// DDL Primary Key Specification
Index PKIDPCULTUREMEDRES On RowID [ PrimaryKey, SqlName = PK_IDP_CULTUREMEDRES, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定结果主键
Property IDPResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 培养基
Property IDPCultureMediumDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 计数
Property Num As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 形态描述
Property CultureDesk As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 6 ];

/// 容器编码
Property ContainerCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

/// 特殊描述
Property Special As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 8 ];

/// 打印次数
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 操作人
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 溶血性
Property Hemolysis As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 14 ];

/// 生化反应
Property BioReaction As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 15 ];

/// 百分百
Property Rate As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 上机仪器
Property IDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 快速鉴定菌
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 插入的上机数据RowID
Property UpMachID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 插入的快速鉴定数据RowID
Property FastIdentifyID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="IDPCultureMedResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPResultDR</Value>
</Value>
<Value name="3">
<Value>IDPCultureMediumDR</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>CultureDesk</Value>
</Value>
<Value name="6">
<Value>ContainerCode</Value>
</Value>
<Value name="7">
<Value>Special</Value>
</Value>
<Value name="8">
<Value>PrintNum</Value>
</Value>
<Value name="9">
<Value>OperUserDR</Value>
</Value>
<Value name="10">
<Value>OperDate</Value>
</Value>
<Value name="11">
<Value>OperTime</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>Hemolysis</Value>
</Value>
<Value name="14">
<Value>BioReaction</Value>
</Value>
<Value name="15">
<Value>Rate</Value>
</Value>
<Value name="16">
<Value>IDPMachDR</Value>
</Value>
<Value name="17">
<Value>OrganismDR</Value>
</Value>
<Value name="18">
<Value>UpMachID</Value>
</Value>
<Value name="19">
<Value>FastIdentifyID</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPCultureMedResD</DataLocation>
<DefaultData>IDPCultureMedResDefaultData</DefaultData>
<IdLocation>^dbo.IDPCultureMedResD</IdLocation>
<IndexLocation>^dbo.IDPCultureMedResI</IndexLocation>
<StreamLocation>^dbo.IDPCultureMedResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
