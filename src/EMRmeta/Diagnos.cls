/// 名称: 病种基础表
/// 描述: 病种基础表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.Diagnos Extends %Persistent
{

Index IdxDiagnosCode On DiagnosCode [ Unique ];

Index IdxCategoryCodeAndDiagnosCode On (CategoryCode, DiagnosCode);

Index IdxSeq On (CategoryCode, DiagnosCode, Sequence);

/// 病种代码
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种名称
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种目录代码
Property CategoryCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种目录名称
Property CategoryName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 创建时间
Property CreateDate As %Date;

/// 顺序(病种目录下的顺序)
Property Sequence As %Integer;

/// 使用状态 0 正常，1 停用
Property Status As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>GroupCode</Value>
</Value>
<Value name="5">
<Value>GroupName</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>DiagnosCode</Value>
</Value>
<Value name="10">
<Value>DiagnosName</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
<Value name="12">
<Value>CategoryCode</Value>
</Value>
<Value name="13">
<Value>CategoryName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosD</DataLocation>
<DefaultData>DiagnosDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
