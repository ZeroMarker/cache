/// 打印模板分组
Class dbo.PTReportPrintGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintGroup ]
{

/// Foreign Key FKPTReportPrintGrpHospital created via DDL
ForeignKey FKPTReportPrintGrpHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PT_ReportPrintGrp_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTGroup On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 模板代码
Property Code As %Library.String(MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 模板名称
Property CName As %Library.String(MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="PTReportPrintGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintGroupD</DataLocation>
<DefaultData>PTReportPrintGroupDefaultData</DefaultData>
<IdLocation>^dbo.PTReportPrintGroupD</IdLocation>
<IndexLocation>^dbo.PTReportPrintGroupI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
