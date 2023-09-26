/// Description：护士长夜查房任务
/// Date:2018-05-14
/// Creator:gzj
Class DHCNMG.CHK.MgNurNightTask Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgNurHeadSchdule [ Cardinality = parent, Inverse = ChildSub ];

/// 明细描述
Property TaskItems As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Task_Items ];

/// 对应的质控项目ID
Property TaskQual As %String [ SqlColumnNumber = 3, SqlFieldName = Task_Qual ];

/// 对应的质控项目父节点
Property TaskPar As %String [ SqlColumnNumber = 4, SqlFieldName = Task_Par ];

Storage Default
{
<Data name="MgNurNightTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskItems</Value>
</Value>
<Value name="3">
<Value>TaskQual</Value>
</Value>
<Value name="4">
<Value>TaskPar</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurNightTaskD</DataLocation>
<DefaultData>MgNurNightTaskDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Parref")</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurNightTaskI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurNightTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
