/// Desc:患者问诊病史表格下选择
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistoryGridCheck Extends %Persistent
{

/// 关联EMRinstance.MedicalHistoryGrid
Property MedicalHistoryGridID As EMRinstance.MedicalHistoryGrid;

/// 选项描述
Property ItemLable As %String(TRUNCATE = 1);

/// 选项value
Property ItemValue As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalHistoryGridCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicalHistoryGridID</Value>
</Value>
<Value name="3">
<Value>ItemLable</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHGridCheckD</DataLocation>
<DefaultData>MedicalHistoryGridCheckDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHGridCheckD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHGridCheckI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHGridCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
