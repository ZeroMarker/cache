/// 
Class dbo.PTReportPrintPaper Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintPaper, StorageStrategy = Default ]
{

/// Foreign Key FKBTReportPrintPaperHospital created via DDL
ForeignKey FKBTReportPrintPaperHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BT_ReportPrintPaper_Hospital ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTPAPER On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINTPAPER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property Width As %Library.Float [ SqlColumnNumber = 5 ];

Property Height As %Library.Float [ SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="PTReportPrintPaperDefaultData">
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
<Value>Width</Value>
</Value>
<Value name="5">
<Value>Height</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintPaperD</DataLocation>
<DefaultData>PTReportPrintPaperDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.PTReportPrintPaperD</IdLocation>
<IndexLocation>^dbo.PTReportPrintPaperI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintPaperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
