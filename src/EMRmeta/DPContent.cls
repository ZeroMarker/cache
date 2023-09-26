/// Table:      EMRmeta.DPContent
/// Desc:       科室短语内容
/// Creator:    Lina
/// CreateDate: 2012-10-08
Class EMRmeta.DPContent Extends %Persistent
{

/// 关联表EMRmeta.DPCategory
Property CategoryID As %Integer;

/// 创建者UserID
Property UserID As %String;

/// 创建时间
Property CreateDate As %String;

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String;

/// 使用状态 0 未审核，1 已审核,2 申请审核,3 重新申请审核,4 审核不通过,-1 已删除 
Property Status As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 科室短语内容
Property Content As %GlobalCharacterStream(LOCATION = "^DHCEMRM.DPContentS");

/// 纯文本内容
Property TextData As %GlobalCharacterStream(LOCATION = "^DHCEMRM.DPContentS");

Index IdxCategoryID On CategoryID [ Unique ];

Storage Default
{
<Data name="DPContentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>AuditID</Value>
</Value>
<Value name="6">
<Value>AuditDate</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Content</Value>
</Value>
<Value name="10">
<Value>TextData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DPContentD</DataLocation>
<DefaultData>DPContentDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DPContentD</IdLocation>
<IndexLocation>^DHCEMRM.DPContentI</IndexLocation>
<StreamLocation>^DHCEMRM.DPContentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
