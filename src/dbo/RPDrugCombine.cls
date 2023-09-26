/// 联合用药表
Class dbo.RPDrugCombine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_DrugCombine ]
{

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKRPDrugCombineResultDR(ReportResultDR) References dbo.RPVisitNumberReportResult(PKRPVISITNUMBERREPORTRESULT) [ SqlName = FK_RPDrugCombineResultDR ];

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKBTDrugCombineAntibioticsIDR(AntibioticsIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombineAntibioticsIDR ];

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKBTDrugCombineAntibioticsIIDR(AntibioticsIIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombineAntibioticsIIDR ];

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKBTDrugCombineAntibioticsIIIDR(AntibioticsIIIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombineAntibioticsIIIDR ];

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKBTDrugCombineAntibioticsIVDR(AntibioticsIVDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombineAntibioticsIVDR ];

/// Foreign Key FKRPDrugCombineResultDR created via DDL
ForeignKey FKBTDrugCombineAntibioticsVIDR(AntibioticsVIDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_BTDrugCombineAntibioticsVIDR ];

Index IndexMaster On (ReportResultDR, DrugGOrder) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexDate On OperDate [ SqlName = Index_Date, Type = index ];

Index IndexAntGroup On (ReportResultDR, AntGroup) [ SqlName = Index_AntGroup, Type = index ];

/// DDL Primary Key PKRPDrugCombine
Index PKRPDrugCombine On RowID [ PrimaryKey, SqlName = PK_RP_DrugCombine, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 结果表
Property ReportResultDR As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Required, SqlColumnNumber = 3 ];

/// 用药组结果序号
Property DrugGOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 用药组
Property AntGroup As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 抗生素1
Property AntibioticsIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 抗生素2
Property AntibioticsIIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 抗生素3
Property AntibioticsIIIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 抗生素4
Property AntibioticsIVDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 抗生素5
Property AntibioticsVIDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 用药结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 模板ID
Property DrugCombinePanelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 操作人
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPDrugCombineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportResultDR</Value>
</Value>
<Value name="3">
<Value>DrugGOrder</Value>
</Value>
<Value name="4">
<Value>AntGroup</Value>
</Value>
<Value name="5">
<Value>AntibioticsIDR</Value>
</Value>
<Value name="6">
<Value>AntibioticsIIDR</Value>
</Value>
<Value name="7">
<Value>AntibioticsIIIDR</Value>
</Value>
<Value name="8">
<Value>AntibioticsIVDR</Value>
</Value>
<Value name="9">
<Value>AntibioticsVIDR</Value>
</Value>
<Value name="10">
<Value>Result</Value>
</Value>
<Value name="11">
<Value>DrugCombinePanelDR</Value>
</Value>
<Value name="12">
<Value>OperDate</Value>
</Value>
<Value name="13">
<Value>OperTime</Value>
</Value>
<Value name="14">
<Value>OperUser</Value>
</Value>
<Value name="15">
<Value>OperUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPDrugCombineD</DataLocation>
<DefaultData>RPDrugCombineDefaultData</DefaultData>
<IdLocation>^dbo.RPDrugCombineD</IdLocation>
<IndexLocation>^dbo.RPDrugCombineI</IndexLocation>
<StreamLocation>^dbo.RPDrugCombineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
