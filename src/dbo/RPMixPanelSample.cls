Class dbo.RPMixPanelSample Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MixPanelSample, StorageStrategy = Default ]
{

/// Foreign Key FKRPMixPanelSampleVisitNumberReport created via DDL
ForeignKey FKRPMixPanelSampleVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RPMixPanelSampleVisitNumberReport ];

/// Foreign Key FKMixPanelSampleMixPanel created via DDL
ForeignKey FKMixPanelSampleMixPanel(MixPanelDR) References dbo.RPMixPanel(PKRPMixPanel) [ SqlName = FK_MixPanelSampleMixPanel ];

Index IndexMaster On (MixPanelDR, RowNo, ColNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexBarcode On Barcode [ SqlName = Index_Barcode, Type = index ];

Index IndexAcceptDate On AcceptDate [ SqlName = Index_AcceptDate, Type = index ];

Index IndexReportID On VisitNumberReportDR [ SqlName = Index_ReportID, Type = index ];

/// DDL Primary Key Specification
Index PKRPMixPanelSample On RowID [ PrimaryKey, SqlName = PK_RP_MixPanelSample, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 检测板排样  
Property MixPanelDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 行数
Property RowNo As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 4 ];

/// 列数
Property ColNo As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

/// 混检条码号
Property Barcode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

/// 标本报告
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 核收日期  
Property AcceptDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 核收时间  
Property AcceptTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 核收者  
Property AcceptUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 类型 SM:样本，PQC:阳性质控，NQC：阴性质控，SMC：复制标本
Property ResType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 11 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 是否阳性
Property IsPos As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property SampleClass As %TinyInt [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPMixPanelSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MixPanelDR</Value>
</Value>
<Value name="3">
<Value>RowNo</Value>
</Value>
<Value name="4">
<Value>ColNo</Value>
</Value>
<Value name="5">
<Value>Barcode</Value>
</Value>
<Value name="6">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="7">
<Value>AcceptDate</Value>
</Value>
<Value name="8">
<Value>AcceptTime</Value>
</Value>
<Value name="9">
<Value>AcceptUserDR</Value>
</Value>
<Value name="10">
<Value>ResType</Value>
</Value>
<Value name="11">
<Value>Result</Value>
</Value>
<Value name="12">
<Value>IsPos</Value>
</Value>
<Value name="13">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="14">
<Value>SampleClass</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMixPanelSampleD</DataLocation>
<DefaultData>RPMixPanelSampleDefaultData</DefaultData>
<IdLocation>^dbo.RPMixPanelSampleD</IdLocation>
<IndexLocation>^dbo.RPMixPanelSampleI</IndexLocation>
<StreamLocation>^dbo.RPMixPanelSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
