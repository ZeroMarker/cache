/// 名称: 病种诊断关联
/// 描述: 病种诊断关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.DiagnosDisease Extends %Persistent
{

Index IdxDiagnosCode On DiagnosCode;

Index IdxICDID On ICDID;

Index IdxICDCode On ICDCode;

Index IdxDiagnosCodeAndICDID On (DiagnosCode, ICDID);

Index IdxDiagnosCodeAndICDCode On (DiagnosCode, ICDCode);

/// 病种代码EMRmeta.Diagnos的Code
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种名称EMRmeta.Diagnos的Name
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD10 ID
Property ICDID As %Integer [ Required ];

/// ICD10编码
Property ICDCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD10名称
Property ICDName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="DiagnosDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagnosCode</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ICDID</Value>
</Value>
<Value name="5">
<Value>ICDCode</Value>
</Value>
<Value name="6">
<Value>ICDName</Value>
</Value>
<Value name="7">
<Value>DiagnosName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiagnosDiseaseD</DataLocation>
<DefaultData>DiagnosDiseaseDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DiagnosDiseaseD</IdLocation>
<IndexLocation>^DHCEMRM.DiagnosDiseaseI</IndexLocation>
<StreamLocation>^DHCEMRM.DiagnosDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
