/// Creator:丁亚男
/// CreatDate:2022-02-15
/// Description：对接方字典关联院区表V2.0
/// Table：CT.WDT.CDSS.ConDictConArea
Class CT.WDT.CDSS.ConDictConArea Extends (%Persistent, User.Abstract)
{

/// 对接方字典类型
Property ConDictType As %String;

/// 对接方字典DR
Property InterDictDR As %String;

/// 院区指针
Property HospAreaDR As CT.WDT.CDSS.CustomerHospArea;

Index InterDictDRIndex On (ConDictType As Exact, InterDictDR As Exact);

Index ConAreaIndex On (ConDictType As Exact, InterDictDR As Exact, HospAreaDR As Exact);

Storage Default
{
<Data name="ConDictConAreaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConDictType</Value>
</Value>
<Value name="3">
<Value>InterDictDR</Value>
</Value>
<Value name="4">
<Value>HospAreaDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConDictConAreaD</DataLocation>
<DefaultData>ConDictConAreaDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConDictConAreaD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConDictConAreaI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConDictConAreaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
