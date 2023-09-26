Class dbo.BTTestCodeNotReportLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeNotReportLink, StorageStrategy = Default ]
{

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

ForeignKey FKNoreportTestCode(NotReportTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_NoreportTestCode ];

/// Foreign Key FKTestSetWorkGroup created via DDL
ForeignKey FKTestCodeNotReportLinkWGM(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestCodeNotReportLinkWGM ];

Index IndexDataMaster On (TestCodeDR, WorkGroupMachineDR, NotReportTestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 工作小组小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 不报告项目项目  
Property NotReportTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestCodeNotReportLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>NotReportTestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeNotReportLinkD</DataLocation>
<DefaultData>BTTestCodeNotReportLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeNotReportLinkD</IdLocation>
<IndexLocation>^dbo.BTTestCodeNotReportLinkI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeNotReportLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
