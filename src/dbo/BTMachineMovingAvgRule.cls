/// 移动均值规则
Class dbo.BTMachineMovingAvgRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MachineMovingAvgRule, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMACHINEMOVINGAVGRULE On RowID [ PrimaryKey, SqlName = PK_BT_MACHINEMOVINGAVGRULE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// IsNullValueCount  {1:true,0:false}
Property IsNullValueCount As %Library.Boolean [ SqlColumnNumber = 5 ];

/// IsNegativeCount  {1:true,0:false}
Property IsNegativeCount As %Library.Boolean [ SqlColumnNumber = 6 ];

/// IsSpecialCount  {1:true,0:false}
Property IsSpecialCount As %Library.Boolean [ SqlColumnNumber = 7 ];

/// IsReCount  {1:true,0:false}
Property IsReCount As %Library.Boolean [ SqlColumnNumber = 8 ];

/// IsAvgStop  {1:true,0:false}
Property IsAvgStop As %Library.Boolean [ SqlColumnNumber = 9 ];

/// IsLimitStop  {1:true,0:false}
Property IsLimitStop As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTMachineMovingAvgRuleDefaultData">
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
<Value>IsNullValueCount</Value>
</Value>
<Value name="5">
<Value>IsNegativeCount</Value>
</Value>
<Value name="6">
<Value>IsSpecialCount</Value>
</Value>
<Value name="7">
<Value>isReCount</Value>
</Value>
<Value name="8">
<Value>IsAvgStop</Value>
</Value>
<Value name="9">
<Value>isLimitStop</Value>
</Value>
<Value name="10">
<Value>IsReCount</Value>
</Value>
<Value name="11">
<Value>IsLimitStop</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMachineMovingAvgRuleD</DataLocation>
<DefaultData>BTMachineMovingAvgRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTMachineMovingAvgRuleD</IdLocation>
<IndexLocation>^dbo.BTMachineMovingAvgRuleI</IndexLocation>
<StreamLocation>^dbo.BTMachineMovingAvgRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
