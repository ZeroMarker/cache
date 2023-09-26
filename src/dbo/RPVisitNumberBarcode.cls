Class dbo.RPVisitNumberBarcode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberBarcode ]
{

/// Foreign Key FKVisitNumberReport created via DDL
ForeignKey FKRPVisitNumberBarcode(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RPVisitNumberBarcode ];

/// Foreign Key FKVisitNumberReportWorkGroup created via DDL
ForeignKey FKRPVisitNumberBarcodeWGM(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RPVisitNumberBarcodeWGM ];

/// Foreign Key FKVisitNumberReportReAuthUser created via DDL
ForeignKey FKRPVisitNumberBarcodeUser(LastUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPVisitNumberBarcodeUser ];

/// DDL Primary Key Specification
Index PKRPVisitNumberBarcode On RowID [ PrimaryKey, SqlName = PK_RP_VisitNumberBarcode, Type = index, Unique ];

Index IndexMaster On (VisitNumberDR, NewBarcode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReportID On ReportID [ SqlName = Index_ReportID, Type = index ];

Index IndexNewBarcode On NewBarcode [ SqlName = Index_NewBarcode, Type = index ];

Index IndexOldBarcode On OldBarcode [ SqlName = Index_OldBarcode, Type = index ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, LastDate) [ SqlName = Index_WorkGroupMachine, Type = index ];

Index IndexLastDate On LastDate [ SqlName = Index_LastDate, Type = index ];

Index IndexLastUser On (LastUserDR, LastDate) [ SqlName = Index_LastUser, Type = index ];

Index IndexVisitNumber On (VisitNumberDR, WorkGroupMachineDR, OrderNo) [ SqlName = Index_VisitNumber, Type = index ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本号  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 新条码  
Property NewBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

/// 老条码
Property OldBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

/// 标本报告  
Property ReportID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 传输日期  
Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 医嘱列表  
Property TestSetIDs As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 最新更换用户  
Property LastUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 最新更换用户  
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 最新更换时间  
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RPVisitNumberBarcodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>NewBarcode</Value>
</Value>
<Value name="4">
<Value>OldBarcode</Value>
</Value>
<Value name="5">
<Value>ReportID</Value>
</Value>
<Value name="6">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="7">
<Value>OrderNo</Value>
</Value>
<Value name="8">
<Value>TransmitDate</Value>
</Value>
<Value name="9">
<Value>EpisodeNo</Value>
</Value>
<Value name="10">
<Value>TestSetIDs</Value>
</Value>
<Value name="11">
<Value>LastUserDR</Value>
</Value>
<Value name="12">
<Value>LastDate</Value>
</Value>
<Value name="13">
<Value>LastTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberBarcodeD</DataLocation>
<DefaultData>RPVisitNumberBarcodeDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberBarcodeD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberBarcodeI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberBarcodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
