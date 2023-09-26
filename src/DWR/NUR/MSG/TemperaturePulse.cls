/// 每一次的体温和脉搏等数据
Class DWR.NUR.MSG.TemperaturePulse Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "TemperaturePulse";

/// 时刻顺序号
Property TimeNum As %String(MAXLEN = 50, TRUNCATE = 1);

/// 时刻
Property Hour As %String(MAXLEN = 50, TRUNCATE = 1);

/// 体温
Property Temperature As %String(MAXLEN = 50, TRUNCATE = 1);

/// 测温方式
Property TemperatureMethod As %String(MAXLEN = 50, TRUNCATE = 1);

/// 脉搏       
Property Pulse As %String(MAXLEN = 50, TRUNCATE = 1);

/// 呼吸      
Property Respiration As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="TemperaturePulseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Pulse</Value>
</Value>
<Value name="3">
<Value>Respiration</Value>
</Value>
<Value name="4">
<Value>Temperature</Value>
</Value>
<Value name="5">
<Value>Hour</Value>
</Value>
<Value name="6">
<Value>TemperatureMethod</Value>
</Value>
</Data>
<DataLocation>^DWR.NUR.MSG.TemperaturePulseD</DataLocation>
<DefaultData>TemperaturePulseDefaultData</DefaultData>
<IdLocation>^DWR.NUR.MSG.TemperaturePulseD</IdLocation>
<IndexLocation>^DWR.NUR.MSG.TemperaturePulseI</IndexLocation>
<StreamLocation>^DWR.NUR.MSG.TemperaturePulseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
