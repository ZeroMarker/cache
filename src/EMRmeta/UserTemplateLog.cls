/// 名称: EMRinstance.UserTemplateLog
/// 描述: 科室模板审核日志表
/// 编写者：liuyunfei
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplateLog Extends %Persistent
{

/// 科室模板表
Property UserTemplateID As EMRmeta.UserTemplate;

/// 操作者ID
Property AuditID As %String;

/// 操作日期
Property AuditDate As %Date;

/// 操作时间
Property AuditTime As %Time;

/// 动作（审核:AUDIT、退回:BACK）
Property Action As %String;

/// 级别（几级审核）(1、2、3 ...)
Property Levle As %String;

/// 是否在该操作后退回（审核完后退回）（退回:Y）
Property IsBack As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 操作IP地址
Property OperateMachineIP As %String;

Index IdxUserTemplateID On UserTemplateID;

Index IdxIDAndAction On (UserTemplateID, Action);

Storage Default
{
<Data name="UserTemplateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserTemplateID</Value>
</Value>
<Value name="3">
<Value>AuditID</Value>
</Value>
<Value name="4">
<Value>AuditDate</Value>
</Value>
<Value name="5">
<Value>AuditTime</Value>
</Value>
<Value name="6">
<Value>Action</Value>
</Value>
<Value name="7">
<Value>Levle</Value>
</Value>
<Value name="8">
<Value>IsBack</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>OperateMachineIP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateLogD</DataLocation>
<DefaultData>UserTemplateLogDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateLogD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateLogI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
