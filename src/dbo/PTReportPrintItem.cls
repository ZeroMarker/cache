/// 
Class dbo.PTReportPrintItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintItem, StorageStrategy = Default ]
{

/// Foreign Key FKPTItemReportPrint created via DDL
ForeignKey FKPTItemReportPrint(ReportPrintDR) References dbo.PTReportPrint(PKPTREPORTPRINT) [ SqlName = FK_PT_Item_ReportPrint ];

Index IndexMaster On (ReportPrintDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPrintType On (ReportPrintDR, PrintType, Code) [ SqlName = Index_PrintType, Type = index, Unique ];

Index IndexDataField On (ReportPrintDR, PrintType, DataField) [ SqlName = Index_DataField, Type = index ];

Index IndexPrintFlag On (ReportPrintDR, PrintFlag, Code) [ SqlName = Index_PrintFlag, Type = index ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTITEM On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReportPrintDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property PrintType As %Library.String(MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property PrintX As %Library.Float [ SqlColumnNumber = 6 ];

Property PrintY As %Library.Float [ SqlColumnNumber = 7 ];

Property PrintFont As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property PrintFontSize As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property PrintFontStyle As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property PrintLength As %Library.Float [ SqlColumnNumber = 11 ];

Property PrintWidth As %Library.Float [ SqlColumnNumber = 12 ];

Property PrintHeight As %Library.Float [ SqlColumnNumber = 13 ];

Property PrintText As %Library.String(MAXLEN = 2000) [ SqlColumnNumber = 14 ];

Property DataField As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 15 ];

Property PrintFlag As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 16 ];

Property PrintAlignment As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 17 ];

Property PrintImageFile As %Library.String(MAXLEN = 120) [ SqlColumnNumber = 18 ];

Property FixedReport As %Library.Boolean [ SqlColumnNumber = 19 ];

Property Angle As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 20 ];

Property IsVShow As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 21 ];

Property Color As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 22 ];

Storage Default
{
<Data name="PTReportPrintItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportPrintDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>PrintType</Value>
</Value>
<Value name="5">
<Value>PrintX</Value>
</Value>
<Value name="6">
<Value>PrintY</Value>
</Value>
<Value name="7">
<Value>PrintFont</Value>
</Value>
<Value name="8">
<Value>PrintFontSize</Value>
</Value>
<Value name="9">
<Value>PrintFontStyle</Value>
</Value>
<Value name="10">
<Value>PrintLength</Value>
</Value>
<Value name="11">
<Value>PrintWidth</Value>
</Value>
<Value name="12">
<Value>PrintHeight</Value>
</Value>
<Value name="13">
<Value>PrintText</Value>
</Value>
<Value name="14">
<Value>DataField</Value>
</Value>
<Value name="15">
<Value>PrintFlag</Value>
</Value>
<Value name="16">
<Value>PrintAlignment</Value>
</Value>
<Value name="17">
<Value>PrintImageFile</Value>
</Value>
<Value name="18">
<Value>FixedReport</Value>
</Value>
<Value name="19">
<Value>Angle</Value>
</Value>
<Value name="20">
<Value>IsVShow</Value>
</Value>
<Value name="21">
<Value>Color</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintItemD</DataLocation>
<DefaultData>PTReportPrintItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.PTReportPrintItemD</IdLocation>
<IndexLocation>^dbo.PTReportPrintItemI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
