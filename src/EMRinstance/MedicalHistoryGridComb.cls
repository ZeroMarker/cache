/// Desc:患者问诊病史列表中下拉选择
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistoryGridComb Extends %Persistent
{

/// 关联EMRinstance.MedicalHistoryGrid
Property MedicalHistoryGridID As EMRinstance.MedicalHistoryGrid;

/// key
Property ItemKey As %String(TRUNCATE = 1);

/// value
Property ItemValue As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalHistoryGridCombDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicalHistoryGridID</Value>
</Value>
<Value name="3">
<Value>ItemKey</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHGirdCombD</DataLocation>
<DefaultData>MedicalHistoryGridCombDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHGirdCombD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHGirdCombI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHGirdCombS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
