Class dbo.BTCheckValidWGMachineTS Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidWGMachineTS ]
{

Index IndexCode On TestSetDR [ SqlName = Index_TestSet, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, TestSetDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CheckType As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTCheckValidWGMachineTSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>TestSetDR</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidWGMachineTSD</DataLocation>
<DefaultData>BTCheckValidWGMachineTSDefaultData</DefaultData>
<IdLocation>^dbo.BTCheckValidWGMachineTSD</IdLocation>
<IndexLocation>^dbo.BTCheckValidWGMachineTSI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidWGMachineTSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
