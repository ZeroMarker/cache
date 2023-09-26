/// 
Class dbo.PTReportPrintDefine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintDefine, StorageStrategy = Default ]
{

/// Foreign Key FKPTRPDefineHospital created via DDL
ForeignKey FKPTRPDefineHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_PT_RPDefine_Hospital ];

/// Foreign Key FKPTRPDefineReportPrint created via DDL
ForeignKey FKPTRPDefineReportPrint(ReportPrintDR) References dbo.PTReportPrint(PKPTREPORTPRINT) [ SqlName = FK_PT_RPDefine_ReportPrint ];

/// Foreign Key FKPTRPDefineTestCode created via DDL
ForeignKey FKPTRPDefineTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_PT_RPDefine_TestCode ];

/// Foreign Key FKPTRPDefineTransTestCodeDR created via DDL
ForeignKey FKPTRPDefineTransTestCodeDR(TransTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_PT_RPDefine_TransTestCodeDR ];

/// Foreign Key FKPTRPDefineTestSet created via DDL
ForeignKey FKPTRPDefineTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_PT_RPDefine_TestSet ];

/// Foreign Key FKPTRPDefineWorkGroupMachine created via DDL
ForeignKey FKPTRPDefineWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_PT_RPDefine_WorkGroupMachine ];

Index IndexWorkGroupMachine On WorkGroupMachineDR [ SqlName = Index_WorkGroupMachine, Type = index ];

Index IndexTestSet On TestSetDR [ SqlName = Index_TestSet, Type = index ];

Index IndexHosTestSet On (HospitalDR, TestSetDR) [ SqlName = Index_HosTestSet, Type = index ];

Index IndexTestCode On TestCodeDR [ SqlName = Index_TestCode, Type = index ];

Index IndexHosTestCode On (HospitalDR, TestCodeDR) [ SqlName = Index_HosTestCode, Type = index ];

Index IndexReportPrintDR On ReportPrintDR [ SqlName = Index_ReportPrintDR, Type = index ];

Index IndexTransTestCodeDR On TransTestCodeDR [ SqlName = Index_TransTestCodeDR, Type = index ];

Index IndexHosTransTestCodeDR On (HospitalDR, TransTestCodeDR) [ SqlName = Index_HosTransTestCodeDR, Type = index ];

Index IndexReportPrintWGM On (ReportPrintDR, WorkGroupMachineDR) [ SqlName = Index_ReportPrintWGM, Type = index ];

Index IndexReportPrintTS On (ReportPrintDR, TestSetDR) [ SqlName = Index_ReportPrintTS, Type = index ];

Index IndexReportPrintTestCode On (ReportPrintDR, TestCodeDR) [ SqlName = Index_ReportPrintTestCode, Type = index ];

Index IndexReportPrintTransTestCode On (ReportPrintDR, TransTestCodeDR) [ SqlName = Index_ReportPrintTransTestCode, Type = index ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTDEFINE On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINTDEFINE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReportPrintDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property TransTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property TransRes As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="PTReportPrintDefineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportPrintDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>TestSetDR</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>TestCodeDR</Value>
</Value>
<Value name="7">
<Value>TransTestCodeDR</Value>
</Value>
<Value name="8">
<Value>TransRes</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintDefineD</DataLocation>
<DefaultData>PTReportPrintDefineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.PTReportPrintDefineD</IdLocation>
<IndexLocation>^dbo.PTReportPrintDefineI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintDefineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
