/// 快速鉴定结果
Class dbo.IDPFastIdentifyRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_FastIdentifyRes ]
{

Index IndexMaster On (IDPResultDR, Sequence) [ SqlName = Index_Master, Type = index ];

Index IndexCultureMedRes On (CultureMedResDR, Sequence) [ SqlName = Index_CultureMedRes, Type = index ];

/// Foreign Key FKIDPFastIdentifyResIDPResultDR created via DDL
ForeignKey FKIDPFastIdentifyResIDPResultDR(IDPResultDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPFastIdentifyResIDPResultDR ];

/// Foreign Key FKIDPFastIdentifyResOrganismDR created via DDL
ForeignKey FKIDPFastIdentifyResOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_IDPFastIdentifyResOrganismDR ];

/// Foreign Key FKIDPFastIdentifyResCultureMedResDR created via DDL
ForeignKey FKIDPFastIdentifyResCultureMedResDR(CultureMedResDR) References dbo.IDPCultureMedRes(PKIDPCULTUREMEDRES) [ SqlName = FK_IDPFastIdentifyResCultureMedResDR ];

/// Foreign Key FKIDPFastIdentifyResOperUserDR created via DDL
ForeignKey FKIDPFastIdentifyResOperUserDR(OperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPFastIdentifyResOperUserDR ];

/// DDL Primary Key Specification
Index PKIDPFASTIDENTIFYRES On RowID [ PrimaryKey, SqlName = PK_IDP_FASTIDENTIFYRES, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定节点主键
Property IDPResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 菌
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 菌落计数
Property ColonyCount As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 培养基
Property CultureMedResDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 打印数量
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 操作人
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 生成的药敏节点ID
Property AntNodeID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 生成的中间报告节点ID
Property MidRepNodeID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="IDPFastIdentifyResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPResultDR</Value>
</Value>
<Value name="3">
<Value>OrganismDR</Value>
</Value>
<Value name="4">
<Value>ColonyCount</Value>
</Value>
<Value name="5">
<Value>CultureMedResDR</Value>
</Value>
<Value name="6">
<Value>PrintNum</Value>
</Value>
<Value name="7">
<Value>OperUserDR</Value>
</Value>
<Value name="8">
<Value>OperDate</Value>
</Value>
<Value name="9">
<Value>OperTime</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>AntNodeID</Value>
</Value>
<Value name="12">
<Value>MidRepNodeID</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPFastIdentifyResD</DataLocation>
<DefaultData>IDPFastIdentifyResDefaultData</DefaultData>
<IdLocation>^dbo.IDPFastIdentifyResD</IdLocation>
<IndexLocation>^dbo.IDPFastIdentifyResI</IndexLocation>
<StreamLocation>^dbo.IDPFastIdentifyResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
