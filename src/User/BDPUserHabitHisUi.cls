/// 基础数据平台用户习惯表HISUI版
Class User.BDPUserHabitHisUi Extends (%Persistent, User.Abstract)
{

Property UserID As %String [ Required ];

Property TableName As %String [ Required ];

Property IndexInfo As %String [ Required ];

Index Index On (UserID As Exact, TableName As Exact, UpdateDate As Exact, UpdateTime As Exact, IndexInfo As Exact);

Property UpdateDate As %String [ Required ];

Property UpdateTime As %String [ Required ];

Storage Default
{
<Data name="BDPUserHabitHisUiDefaultData">
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
<DataLocation>^User.BDPUserHabitHisUiD</DataLocation>
<DefaultData>BDPUserHabitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPUserHabitHisUiD</IdLocation>
<IndexLocation>^User.BDPUserHabitHisUiI</IndexLocation>
<StreamLocation>^User.BDPUserHabitHisUiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
