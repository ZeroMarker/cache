/// 名称: 病种关联表
/// 描述: 根据诊断关联病种
/// 编写者：FLC
/// 编写日期: 2015-08-26
Class EMRmeta.DiseaseRelation Extends %Persistent
{

Index IdxCTLocID On CTLocID;

Index IdxKBDiagnosID On KBDiagnosID;

Index IdxDiagnosRelationID On (CTLocID, KBDiagnosID, ICDID);

Index IdxDiagnosRelationCode On (CTLocID, KBDiagnosID, ICDCode);

/// CT_Loc指针
Property CTLocID As %Integer [ Required ];

/// 科室病种ID
Property KBDiagnosID As %Integer [ Required ];

/// ICD10 ID
Property ICDID As %Integer [ Required ];

/// ICD10编码
Property ICDCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD10名称
Property ICDName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Storage Default
{
<Data name="DiseaseRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocID</Value>
</Value>
<Value name="3">
<Value>KBDiagnosID</Value>
</Value>
<Value name="4">
<Value>ICDID</Value>
</Value>
<Value name="5">
<Value>ICDCode</Value>
</Value>
<Value name="6">
<Value>ICDCNmae</Value>
</Value>
<Value name="7">
<Value>ICDCName</Value>
</Value>
<Value name="8">
<Value>ICDName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DiseaseRelationD</DataLocation>
<DefaultData>DiseaseRelationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.DiseaseRelationD</IdLocation>
<IndexLocation>^DHCEMRM.DiseaseRelationI</IndexLocation>
<StreamLocation>^DHCEMRM.DiseaseRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
