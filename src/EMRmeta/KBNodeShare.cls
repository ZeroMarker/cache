/// Description:知识库节点与科室关联（共享个人知识库）
/// Creator:    DongLulu
/// CreateDate: 2019-5-13
Class EMRmeta.KBNodeShare Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.KBNode表ID
Property KBNodeID As %Integer;

/// 分享者UserID
Property UserID As %String;

/// 科室ID
Property CTLocID As %String;

/// KBNodeID 关联的 EMRmeta.KBTree表中ParentID为0的KBTreeID（知识库目录与科室关联的一级）
Property KBTreeParentID As %String(TRUNCATE = 1);

/// 使用状态 1 已审核,2 申请审核, （-1 审核不通过，取消分享该数据，物理删除）
Property Status As %String(TRUNCATE = 1);

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String;

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IdxLocTreeParentNode On (CTLocID, KBTreeParentID, KBNodeID);

Index IdxUserIDLocIDKBNode On (UserID, CTLocID, KBNodeID);

Index IdxKBNodeID On KBNodeID;

Storage Default
{
<Data name="KBNodeShareDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KBNodeID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>KBTreeID</Value>
</Value>
<Value name="6">
<Value>KBTreeParentID</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>AuditID</Value>
</Value>
<Value name="9">
<Value>AuditDate</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBNodeShareD</DataLocation>
<DefaultData>KBNodeShareDefaultData</DefaultData>
<IdLocation>^DHCEMRM.KBNodeShareD</IdLocation>
<IndexLocation>^DHCEMRM.KBNodeShareI</IndexLocation>
<StreamLocation>^DHCEMRM.KBNodeShareS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
