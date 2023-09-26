Class EMRmeta.TemKBApprove Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxTypeReID On (Type, RelationID) [ Unique ];

/// 名称
Property UserID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 备注	
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

/// 知识库kbnode或者模板templateversion的ID
Property RelationID As %String(TRUNCATE = 1);

/// 类型：TEMPLATE,KB
Property Type As %String(TRUNCATE = 1);

/// 状态（针对未发布状态）：1、审核者审核发布，2、需要创建者修改
Property Status As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TemKBApproveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ResChildCount</Value>
</Value>
<Value name="5">
<Value>InternalID</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>RelationID</Value>
</Value>
<Value name="10">
<Value>Type</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemKBApproveD</DataLocation>
<DefaultData>TemKBApproveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemKBApproveD</IdLocation>
<IndexLocation>^DHCEMRM.TemKBApproveI</IndexLocation>
<StreamLocation>^DHCEMRM.TemKBApproveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
