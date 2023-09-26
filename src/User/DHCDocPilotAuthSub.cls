/// CTOR: QP
/// DATE: 2022-03-07
/// DESC: 药物临床试验审核权限管理子表
Class User.DHCDocPilotAuthSub Extends (%Persistent, User.Abstract)
{

Relationship SParRef As User.DHCDocPilotAuth [ Cardinality = parent, Inverse = ChildSub, Required, SqlFieldName = S_ParRef ];

/// 用户
Property SUser As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = S_User ];

/// 是否激活
Property SActive As %String [ SqlColumnNumber = 3, SqlFieldName = S_Active ];

/// 添加日期
Property SAddDate As %Date [ SqlColumnNumber = 4, SqlFieldName = S_AddDate ];

/// 添加时间
Property SAddTime As %Time [ SqlColumnNumber = 5, SqlFieldName = S_AddTime ];

/// 添加用户
Property SAddUser As %Date [ SqlColumnNumber = 6, SqlFieldName = S_AddUser ];

Storage Default
{
<Data name="DHCDocPilotAuthSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SUser</Value>
</Value>
<Value name="3">
<Value>SActive</Value>
</Value>
<Value name="4">
<Value>SAddDate</Value>
</Value>
<Value name="5">
<Value>SAddTime</Value>
</Value>
<Value name="6">
<Value>SAddUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCDocPilotAuthSubDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotAuthC("ChildSub")</IdLocation>
<IndexLocation>^User.DHCDocPilotAuthSubI</IndexLocation>
<StreamLocation>^User.DHCDocPilotAuthSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
