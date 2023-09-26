Class dbo.BTMIMachineExpertRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineExpertRule ]
{

/// Foreign Key FKMachineQCMach created via DDL
ForeignKey FKMachineExpertRuleMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineExpertRuleMach ];

/// Foreign Key FKMachineQCMat created via DDL
ForeignKey FKMachineExpertRuleExpertRule(ExpertRuleDR) References dbo.BTExpertRule(PKBTEXPERTRULE) [ SqlName = FK_MachineExpertRuleExpertRule ];

Index IndexMaster On (MachineParameterDR, ExpertRuleDR, Channel) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChannel On (MachineParameterDR, Channel, ExpertRuleDR) [ SqlName = Index_Channel, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEEXPERTRULE On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEEXPERTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ExpertRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Channel As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineExpertRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>ExpertRuleDR</Value>
</Value>
<Value name="4">
<Value>Channel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineExpertRuleD</DataLocation>
<DefaultData>BTMIMachineExpertRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineExpertRuleD</IdLocation>
<IndexLocation>^dbo.BTMIMachineExpertRuleI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineExpertRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
