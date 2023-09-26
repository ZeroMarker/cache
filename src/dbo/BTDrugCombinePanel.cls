/// 用药指南模板
Class dbo.BTDrugCombinePanel Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_DrugCombinePanel ]
{

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey BTDrugCombinePanelAntibioticsIDR(AntibioticsIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombinePanelAntibioticsIDR ];

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey BTDrugCombinePanelAntibioticsIIDR(AntibioticsIIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombinePanelAntibioticsIIDR ];

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey BTDrugCombinePanelAntibioticsIIIDR(AntibioticsIIIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombinePanelAntibioticsIIIDR ];

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey BTDrugCombinePanelAntibioticsIVDR(AntibioticsIVDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombinePanelAntibioticsIVDR ];

/// Foreign Key FKRPDrugCombinationResultDR created via DDL
ForeignKey BTDrugCombinePanelAntibioticsVIDR(AntibioticsVIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombinePanelAntibioticsVIDR ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key PKRPDrugCombination
Index PKBTDrugCombinePanel On RowID [ PrimaryKey, SqlName = PK_BT_DrugCombinePanel, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 结果表
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 用药组
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 抗生素1
Property AntibioticsIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 抗生素2
Property AntibioticsIIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 抗生素3
Property AntibioticsIIIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 抗生素4
Property AntibioticsIVDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 抗生素5
Property AntibioticsVIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 操作日期
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 操作时间
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTDrugCombinePanelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>AntibioticsIDR</Value>
</Value>
<Value name="5">
<Value>AntibioticsIIDR</Value>
</Value>
<Value name="6">
<Value>AntibioticsIIIDR</Value>
</Value>
<Value name="7">
<Value>AntibioticsIVDR</Value>
</Value>
<Value name="8">
<Value>AntibioticsVIDR</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDrugCombinePanelD</DataLocation>
<DefaultData>BTDrugCombinePanelDefaultData</DefaultData>
<IdLocation>^dbo.BTDrugCombinePanelD</IdLocation>
<IndexLocation>^dbo.BTDrugCombinePanelI</IndexLocation>
<StreamLocation>^dbo.BTDrugCombinePanelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
