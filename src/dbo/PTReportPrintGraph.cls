/// 
Class dbo.PTReportPrintGraph Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintGraph, StorageStrategy = Default ]
{

Index IndexMaster On (HospitalDR, Code, GraphType) [ SqlName = Index_Master, Type = index ];

Index IndexDate On (HospitalDR, Code, GraphType, StartDate, EndDate) [ SqlName = Index_Date, Type = index, Unique ];

/// Foreign Key FKPTRPDefineHospital created via DDL
ForeignKey FKPTRPGraphHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PT_RPGraph_Hospital ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTGRAPH On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINTGRAPH, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property GraphBase64String As %Library.String(MAXLEN = 327670) [ SqlColumnNumber = 7 ];

Property GraphType As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="PTReportPrintGraphDefaultData">
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
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>GraphBase64String</Value>
</Value>
<Value name="7">
<Value>GraphType</Value>
</Value>
<Value name="8">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintGraphD</DataLocation>
<DefaultData>PTReportPrintGraphDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.PTReportPrintGraphD</IdLocation>
<IndexLocation>^dbo.PTReportPrintGraphI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintGraphS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
