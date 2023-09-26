/// Desc:患者问诊病史选择
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistoryCheck Extends %Persistent
{

/// 关联EMRinstance.MedicalHistory
Property MedicalHistoryID As EMRinstance.MedicalHistory;

/// 选项描述
Property ItemLable As %String(TRUNCATE = 1);

/// 选项value
Property ItemValue As %String(TRUNCATE = 1);

/// 备注
Property Memo As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalHistoryCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicalHistoryID</Value>
</Value>
<Value name="3">
<Value>ItemLable</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
<Value name="5">
<Value>Memo</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHistoryCheckD</DataLocation>
<DefaultData>MedicalHistoryCheckDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHistoryCheckD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHistoryCheckI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHistoryCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
