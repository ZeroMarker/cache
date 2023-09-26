///     
Class dbo.BTReportActuator Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ReportActuator ]
{

Index IndexMaster On WorkGroupMachineDR [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTReportActuatorWorkGroupMachineDR created via DDL
ForeignKey FKBTReportActuatorWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTReportActuatorWorkGroupMachineDR ];

/// DDL Primary Key Specification
Index PKBTREPORTACTUATOR On RowID [ PrimaryKey, SqlName = PK_BT_REPORTACTUATOR, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property HitFormula As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 4 ];

Property ExeFormula As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 5 ];

Property ExeFormulaTrans As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property DealMethod As %Library.String(COLLATION = "Exact", MAXLEN = 5000) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTReportActuatorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>HitFormula</Value>
</Value>
<Value name="4">
<Value>ExeFormula</Value>
</Value>
<Value name="5">
<Value>ExeFormulaTrans</Value>
</Value>
<Value name="6">
<Value>DealMethod</Value>
</Value>
</Data>
<DataLocation>^dbo.BTReportActuatorD</DataLocation>
<DefaultData>BTReportActuatorDefaultData</DefaultData>
<IdLocation>^dbo.BTReportActuatorD</IdLocation>
<IndexLocation>^dbo.BTReportActuatorI</IndexLocation>
<StreamLocation>^dbo.BTReportActuatorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
