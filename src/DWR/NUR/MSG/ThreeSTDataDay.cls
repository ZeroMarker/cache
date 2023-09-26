/// 患者一天的三测单数据
Class DWR.NUR.MSG.ThreeSTDataDay Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "ThreeSTDataDay";

/// 每周中的第几天      
Property WeekDay As %String(MAXLEN = 50, TRUNCATE = 1);

/// 日期
Property DataDate As %String(MAXLEN = 50, TRUNCATE = 1);

/// 住院天数       
Property InDays As %String(MAXLEN = 50, TRUNCATE = 1);

/// 手术后天数       
Property DaysAfterSurgery As %String(MAXLEN = 50, TRUNCATE = 1);

/// 体温、脉搏等数据列表
Property TempPulseList As list Of DWR.NUR.MSG.TemperaturePulse(XMLNAME = "TempPulseList");

/// 其他每天一次的数据列表
Property OtherDataList As list Of DWR.NUR.MSG.OtherDataOnce(XMLNAME = "OtherDataList");

Storage Default
{
<Data name="ThreeSTDataDayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataDate</Value>
</Value>
<Value name="3">
<Value>DaysAfterSurgery</Value>
</Value>
<Value name="4">
<Value>InDays</Value>
</Value>
<Value name="5">
<Value>OtherDataList</Value>
</Value>
<Value name="6">
<Value>TempPulseList</Value>
</Value>
</Data>
<DataLocation>^DWR.NUR.MSG.ThreeSTDataDayD</DataLocation>
<DefaultData>ThreeSTDataDayDefaultData</DefaultData>
<IdLocation>^DWR.NUR.MSG.ThreeSTDataDayD</IdLocation>
<IndexLocation>^DWR.NUR.MSG.ThreeSTDataDayI</IndexLocation>
<StreamLocation>^DWR.NUR.MSG.ThreeSTDataDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
