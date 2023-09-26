/// 任务组
/// DHCWL_MKPI.DHCWLConfigTaskGroup  k ^DHCWL.MKPI.ConfigTaskGroupI  d ##class(DHCWL.MKPI.ConfigTaskGroup).%BuildIndices()
Class DHCWL.MKPI.ConfigTaskGroup Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLConfigTaskGroup ]
{

/// 任务组编码
Property DTaskGroupCode As %String [ SqlColumnNumber = 2, SqlFieldName = DTask_GroupCode ];

/// 任务组描述
Property DTaskGroupDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DTask_GroupDesc ];

/// 创建日期
Property DTaskGroupDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DTask_GroupDate ];

/// 创建人
Property DTaskGroupUser As %String [ SqlColumnNumber = 5, SqlFieldName = DTask_GroupUser ];

Index Code On DTaskGroupCode;

Storage Default
{
<Data name="ConfigTaskGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DTaskGroupCode</Value>
</Value>
<Value name="3">
<Value>DTaskGroupDesc</Value>
</Value>
<Value name="4">
<Value>DTaskGroupDate</Value>
</Value>
<Value name="5">
<Value>DTaskGroupUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ConfigTaskGroupD</DataLocation>
<DefaultData>ConfigTaskGroupDefaultData</DefaultData>
<IdLocation>^DHCWL.MKPI.ConfigTaskGroupD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ConfigTaskGroupI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ConfigTaskGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
