Class dbo.BTCheckValidWGMachineTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidWGMachineTC ]
{

Index IndexCode On TestCodeDR [ SqlName = Index_TestCode, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CheckType As %Library.SmallInt [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTCheckValidWGMachineTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidWGMachineTCD</DataLocation>
<DefaultData>BTCheckValidWGMachineTCDefaultData</DefaultData>
<IdLocation>^dbo.BTCheckValidWGMachineTCD</IdLocation>
<IndexLocation>^dbo.BTCheckValidWGMachineTCI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidWGMachineTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
