/// Description:检查任务维护
/// Date:2018-05-05
/// Creator:guozj
Class DHCNMG.CHK.MgNurTaskGroup Extends %Persistent
{

/// 月份
Property TaskMonth As %Integer [ SqlColumnNumber = 2, SqlFieldName = Task_Month ];

/// 夜班分组
Property TaskGroup As %Integer [ SqlColumnNumber = 3, SqlFieldName = Task_Group ];

/// 夜班当前组信息
Property TaskNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = Task_Num ];

/// 周末班分组
Property TaskWGroup As %Integer [ SqlColumnNumber = 5, SqlFieldName = Task_WGroup ];

/// 周末班当前组信息
Property TaskWNum As %Integer [ SqlColumnNumber = 6, SqlFieldName = Task_WNum ];

/// 节假日分组
Property TaskHGroup As %Integer [ SqlColumnNumber = 7, SqlFieldName = Task_HGroup ];

/// 节假日当前组信息
Property TaskHNum As %Integer [ SqlColumnNumber = 8, SqlFieldName = Task_HNum ];

Index group On TaskMonth;

Storage Default
{
<Data name="MgNurTaskGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskMonth</Value>
</Value>
<Value name="3">
<Value>TaskGroup</Value>
</Value>
<Value name="4">
<Value>TaskNum</Value>
</Value>
<Value name="5">
<Value>TaskWGroup</Value>
</Value>
<Value name="6">
<Value>TaskWNum</Value>
</Value>
<Value name="7">
<Value>TaskHGroup</Value>
</Value>
<Value name="8">
<Value>TaskHNum</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurTaskGroupD</DataLocation>
<DefaultData>MgNurTaskGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurTaskGroupD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurTaskGroupI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurTaskGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
