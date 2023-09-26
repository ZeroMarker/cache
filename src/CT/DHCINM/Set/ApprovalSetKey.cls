/// Creator:lulin
/// Descriptions:审批关键字
/// Date:2021-06-07
Class CT.DHCINM.Set.ApprovalSetKey Extends %Persistent
{

Relationship Parref As CT.DHCINM.Set.ApprovalSet [ Cardinality = parent, Inverse = ChildSub, Required ];

/// 描述
Property KeyDesc As %String [ SqlColumnNumber = 2, SqlFieldName = KeyDesc ];

/// 位置
Property KeyProperNum As %String [ SqlColumnNumber = 3, SqlFieldName = KeyProperNum ];

/// 原始值
Property KeyProperValue As %String [ SqlColumnNumber = 4, SqlFieldName = KeyProperValue ];

/// 预置值
Property KeyProperToValue As %String [ SqlColumnNumber = 5, SqlFieldName = KeyProperToValue ];

/// 角色
Property KeyRoles As %String [ SqlColumnNumber = 6, SqlFieldName = KeyRoles ];

/// 是否带驳回,Y:是,N：否
Property BackFlag As %String [ SqlColumnNumber = 7, SqlFieldName = BackFlag ];

/// 驳回值
Property BackToValue As %String [ SqlColumnNumber = 8, SqlFieldName = BackToValue ];

/// 审核人位置
Property AuditorNum As %String [ SqlColumnNumber = 9, SqlFieldName = AuditorNum ];

/// 审核日期Global位置
Property AuditDateNum As %String [ SqlColumnNumber = 10, SqlFieldName = AuditDateNum ];

/// 审核时间Global位置
Property AuditTimeNum As %String [ SqlColumnNumber = 11, SqlFieldName = AuditTimeNum ];

/// 审核意见是否启用
Property OpinionFlag As %String [ SqlColumnNumber = 12, SqlFieldName = OpinionFlag ];

/// 审核意见Global位置
Property OpinionNum As %String [ SqlColumnNumber = 13, SqlFieldName = OpinionNum ];

/// 状态
Property KeyStatus As %String [ SqlColumnNumber = 14, SqlFieldName = KeyStatus ];

/// 附属值_位置
Property KeyOtherNum As %String [ SqlColumnNumber = 15, SqlFieldName = KeyOtherNum ];

/// 附属值_值
Property KeyOtherValue As %String [ SqlColumnNumber = 16, SqlFieldName = KeyOtherValue ];

Storage Default
{
<Data name="ApprovalSetKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyDesc</Value>
</Value>
<Value name="3">
<Value>KeyProperNum</Value>
</Value>
<Value name="4">
<Value>KeyProperValue</Value>
</Value>
<Value name="5">
<Value>KeyProperToValue</Value>
</Value>
<Value name="6">
<Value>KeyRoles</Value>
</Value>
<Value name="7">
<Value>BackFlag</Value>
</Value>
<Value name="8">
<Value>BackToValue</Value>
</Value>
<Value name="9">
<Value>AuditorNum</Value>
</Value>
<Value name="10">
<Value>AuditDateNum</Value>
</Value>
<Value name="11">
<Value>AuditTimeNum</Value>
</Value>
<Value name="12">
<Value>OpinionFlag</Value>
</Value>
<Value name="13">
<Value>OpinionNum</Value>
</Value>
<Value name="14">
<Value>KeyStatus</Value>
</Value>
<Value name="15">
<Value>KeyOtherNum</Value>
</Value>
<Value name="16">
<Value>KeyOtherValue</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.ApprovalSetKeyD</DataLocation>
<DefaultData>ApprovalSetKeyDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCINM.Set.ApprovalSetKeyI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.ApprovalSetKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
