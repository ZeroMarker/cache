/// 名称: 病种分组
/// 描述: 病种分组表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosGroup Extends %Persistent
{

Index IdxParentID On ParentID;

Index IdxCTLocID On CTLocID;

Index IdxGroupCode On GroupCode;

Index IdxSeq On (ParentID, Sequence);

Index IdxLocSeq On (CTLocID, ParentID, Sequence);

Index IdxCTLocGroupCode On (CTLocID, GroupCode);

/// 病种分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="DiagnosGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>CTLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosGroupD</DataLocation>
<DefaultData>DiagnosGroupDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosGroupD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
