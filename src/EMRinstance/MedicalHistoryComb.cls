/// Desc:患者问诊病史下拉选择
/// Creator:Candy
/// CreateDate:20201218
Class EMRinstance.MedicalHistoryComb Extends %Persistent
{

/// 关联EMRinstance.MedicalHistory
Property MedicalHistoryID As EMRinstance.MedicalHistory;

/// key
Property ItemKey As %String(TRUNCATE = 1);

/// value
Property ItemValue As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalHistoryCombDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedicalHistoryID</Value>
</Value>
<Value name="3">
<Value>ItemKey</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MedicalHistoryCombD</DataLocation>
<DefaultData>MedicalHistoryCombDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MedicalHistoryCombD</IdLocation>
<IndexLocation>^DHCEMRI.MedicalHistoryCombI</IndexLocation>
<StreamLocation>^DHCEMRI.MedicalHistoryCombS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
