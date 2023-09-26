/// 名称: 病种科室关联
/// 描述: 病种科室关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosCTLoc Extends %Persistent
{

Index IdxCTLocID On CTLocID;

Index IdxDiagnosCode On DiagnosCode;

Index IdxCTLocIDAndDiagnosCode On (CTLocID, DiagnosCode);

/// 分组代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 分组名称EMRmeta.Diagnos的DiagnosName
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

/// CT_Loc名称
Property CTLocName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosCTLocDefaultData">
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
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocName</Value>
</Value>
<Value name="6">
<Value>DiagnosCode</Value>
</Value>
<Value name="7">
<Value>DiagnosName</Value>
</Value>
<Value name="8">
<Value>GroupCode</Value>
</Value>
<Value name="9">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosCTLocD</DataLocation>
<DefaultData>DiagnosCTLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosCTLocD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosCTLocI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosCTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
