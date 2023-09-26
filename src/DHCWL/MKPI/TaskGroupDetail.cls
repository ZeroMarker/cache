/// DHCWL_MKPI.DHCWLTaskGroupDetail  k ^DHCWL.MKPI.TaskGroupDetailI  d ##class(DHCWL.MKPI.TaskGroupDetail).%BuildIndices()
Class DHCWL.MKPI.TaskGroupDetail Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLTaskGroupDetail ]
{

/// 关联任务组
Property DTaskGroupDr As DHCWL.MKPI.ConfigTaskGroup [ SqlColumnNumber = 2, SqlFieldName = DTask_GroupDr ];

/// 关联指标
Property DTaskKpiDr As %String [ SqlColumnNumber = 3, SqlFieldName = DTask_KpiDr ];

/// 创建日期
Property DTaskDetailDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DTask_DetailDate ];

Index Code On DTaskGroupDr;

Index kpi On DTaskKpiDr;

Index kpiGroup On (DTaskGroupDr, DTaskKpiDr);

Storage Default
{
<Data name="TaskGroupDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DTaskGroupDr</Value>
</Value>
<Value name="3">
<Value>DTaskKpiDr</Value>
</Value>
<Value name="4">
<Value>DTaskDetailDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.TaskGroupDetailD</DataLocation>
<DefaultData>TaskGroupDetailDefaultData</DefaultData>
<IdLocation>^DHCWL.MKPI.TaskGroupDetailD</IdLocation>
<IndexLocation>^DHCWL.MKPI.TaskGroupDetailI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.TaskGroupDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
