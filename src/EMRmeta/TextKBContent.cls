/// Desc:       文本知识库内容
/// Creator:    Candyxu
/// CreateDate: 2018-2-27
Class EMRmeta.TextKBContent Extends (%Persistent, %XML.Adaptor)
{

Index IdxCategoryID On CategoryID [ Unique ];

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

Property Content As %GlobalCharacterStream(LOCATION = "^DHCEMRM.TextKBContentS");

Storage Default
{
<Data name="TextKBContentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>AuditID</Value>
</Value>
<Value name="7">
<Value>AuditDate</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TextKBContentD</DataLocation>
<DefaultData>TextKBContentDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TextKBContentD</IdLocation>
<IndexLocation>^DHCEMRM.TextKBContentI</IndexLocation>
<StreamLocation>^DHCEMRM.TextKBContentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
