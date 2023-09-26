/// Descript:集成视图显示数据
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// 
Class DWR.MSG.ViewInfo Extends (%Persistent, %XML.Adaptor)
{

Property searchDate As %String;

Property startDate As %String;

Property endDate As %String;

Property patientInfo As DWR.MSG.PatientInfo;

Property actCategoryData As list Of DWR.MSG.ActCategoryData(XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="ViewInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>searchDate</Value>
</Value>
<Value name="3">
<Value>startDate</Value>
</Value>
<Value name="4">
<Value>endDate</Value>
</Value>
<Value name="5">
<Value>patientInfo</Value>
</Value>
<Value name="6">
<Value>actCategoryData</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.ViewInfoD</DataLocation>
<DefaultData>ViewInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.ViewInfoD</IdLocation>
<IndexLocation>^DWR.MSG.ViewInfoI</IndexLocation>
<StreamLocation>^DWR.MSG.ViewInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
