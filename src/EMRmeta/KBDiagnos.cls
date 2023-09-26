/// 名称: 科室病种表
/// 描述: 科室与病种关系表
/// 编写者：candy
/// 编写日期: 2014-01-016
Class EMRmeta.KBDiagnos Extends %Persistent
{

Index IdxCTLocID On CTLocID;

Index IdxCTLocIDAndName On (CTLocID, Name);

Index IdxCTLocIDAndGroupNameAndName On (CTLocID, GroupName, Name);

/// 病种代码
Property Name As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种名称
Property Description As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组代码
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组名称
Property GroupDescription As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD诊断代码串
Property Diagnos As %String(TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %Integer [ Required ];

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 创建时间
Property CreateDate As %Date;

/// 使用状态 0 正常，1 停用
Property Status As %String(TRUNCATE = 1);

Storage Default
{
<Data name="KBDiagnosDefaultData">
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
<Value>Diagnos</Value>
</Value>
<Value name="5">
<Value>CTLocID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>GroupName</Value>
</Value>
<Value name="9">
<Value>GroupDescription</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBDiagnosD</DataLocation>
<DefaultData>KBDiagnosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBDiagnosD</IdLocation>
<IndexLocation>^DHCEMRM.KBDiagnosI</IndexLocation>
<StreamLocation>^DHCEMRM.KBDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
