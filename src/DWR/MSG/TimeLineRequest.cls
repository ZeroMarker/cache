/// Descript:集成视图请求相关
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// 
Class DWR.MSG.TimeLineRequest Extends (%Persistent, %XML.Adaptor)
{

Property userCode As %String;

Property admId As %String;

Property timeLineId As %String;

Property startDate As %String;

Property timeLineConfigStr As %String(MAXLEN = 300);

Property patientId As %String;

Storage Default
{
<Data name="TimeLineRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userCode</Value>
</Value>
<Value name="3">
<Value>admId</Value>
</Value>
<Value name="4">
<Value>timeLineId</Value>
</Value>
<Value name="5">
<Value>timeLineCategory</Value>
</Value>
<Value name="6">
<Value>startDate</Value>
</Value>
<Value name="7">
<Value>timeLineConfigStr</Value>
</Value>
<Value name="8">
<Value>patientId</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.TimeLineRequestD</DataLocation>
<DefaultData>TimeLineRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.TimeLineRequestD</IdLocation>
<IndexLocation>^DWR.MSG.TimeLineRequestI</IndexLocation>
<StreamLocation>^DWR.MSG.TimeLineRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
