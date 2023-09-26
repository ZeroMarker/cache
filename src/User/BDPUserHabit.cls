/// 基础数据平台  用户习惯表（列隐藏，列显示，拖动改变列的顺序）
/// 陈莹
Class User.BDPUserHabit Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = BDP_UserHabit ]
{

Property UserID As %String [ Required ];

Property TableName As %String [ Required ];

Property IndexInfo As %String [ Required ];

Index Index On (UserID As Exact, TableName As Exact, UpdateDate As Exact, UpdateTime As Exact, IndexInfo As Exact);

Property UpdateDate As %String [ Required ];

Property UpdateTime As %String [ Required ];

Storage Default
{
<Data name="BDPUserHabitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>IndexInfo</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.BDPUserHabitD</DataLocation>
<DefaultData>BDPUserHabitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPUserHabitD</IdLocation>
<IndexLocation>^User.BDPUserHabitI</IndexLocation>
<StreamLocation>^User.BDPUserHabitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
