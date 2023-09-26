/// Desc:患者问诊病史表格型数据
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistoryGrid Extends %Persistent
{

/// 关联EMRinstance.MedicalHistory
Property MedicalHistoryID As EMRinstance.MedicalHistory;

/// 行号
Property rowNamber As %Integer;

/// 字段名
Property Field As %String(TRUNCATE = 1);

/// 字段名
Property Title As %String(TRUNCATE = 1);

/// 字段名类型
Property Type As %String(TRUNCATE = 1);

/// 字段值
Property Value As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalHistoryGridDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicalHistoryID</Value>
</Value>
<Value name="3">
<Value>rowNamber</Value>
</Value>
<Value name="4">
<Value>key</Value>
</Value>
<Value name="5">
<Value>value</Value>
</Value>
<Value name="6">
<Value>FieldName</Value>
</Value>
<Value name="7">
<Value>FieldType</Value>
</Value>
<Value name="8">
<Value>FieldValue</Value>
</Value>
<Value name="9">
<Value>Field</Value>
</Value>
<Value name="10">
<Value>Title</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHIstoryGirdD</DataLocation>
<DefaultData>MedicalHistoryGridDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHIstoryGirdD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHIstoryGirdI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHIstoryGirdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
