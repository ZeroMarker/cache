/// 标本医嘱
Class dbo.RPVisitNumberTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberTestSet, StorageStrategy = Default ]
{

Index IndexMaster On (VisitNumberDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (VisitNumberDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexWGMachineDR On (VisitNumberDR, WorkGroupMachineDR, TestSetDR) [ SqlName = Index_WGMachineDR, Type = index ];

Index IndexReportID On (VisitNumberReportDR, TestSetDR) [ SqlName = Index_ReportID, Type = index ];

Index IndexHISOrderID On (HISOrderID, VisitNumberReportDR) [ SqlName = Index_HISOrderID, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERTESTSET On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERTESTSET, Type = index, Unique ];

/// Foreign Key FKVisitNumberTestSet created via DDL
ForeignKey FKVisitNumberTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_VisitNumberTestSet ];

/// Foreign Key FKVisitNumberTestSetSpec created via DDL
ForeignKey FKVisitNumberTestSetSpec(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberTestSetSpec ];

/// Foreign Key FKVisitNumberTestSetWorkGroup created via DDL
ForeignKey FKVisitNumberTestSetWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberTestSetWorkGroup ];

/// Foreign Key FKVisitNumberTestSetReportDR created via DDL
ForeignKey FKVisitNumberTestSetReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberTestSetReportDR ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否完成接收  {1:true,0:false}
Property Recieved As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 核收工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 传输日期  
Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 检测号  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 项目组合套价格  
Property TestSetFee As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// HIS医嘱ID  
Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// ReceivableFee  
Property ReceivableFee As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="RPVisitNumberTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>Recieved</Value>
</Value>
<Value name="5">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="6">
<Value>TransmitDate</Value>
</Value>
<Value name="7">
<Value>AssayNo</Value>
</Value>
<Value name="8">
<Value>TestSetFee</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>HISOrderID</Value>
</Value>
<Value name="11">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="12">
<Value>ReceivableFee</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberTestSetD</DataLocation>
<DefaultData>RPVisitNumberTestSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberTestSetD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberTestSetI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
