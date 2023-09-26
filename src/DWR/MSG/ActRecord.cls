/// Descript:临床事件基础数据明细
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// 
Class DWR.MSG.ActRecord Extends (%Persistent, %XML.Adaptor)
{

Property actDate As %String;

Property actTime As %String;

Property dataValue As %String;

Property summary As %String;

Property parameters As %String;

Property actDesc As %String;

Property actCode As %String;

Property subActRecord As list Of DWR.MSG.ActRecord;

Property endDate As %String;

Property endTime As %String;

Property objId As %String;

Storage Default
{
<Data name="ActRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>actDate</Value>
</Value>
<Value name="3">
<Value>actTime</Value>
</Value>
<Value name="4">
<Value>dataValue</Value>
</Value>
<Value name="5">
<Value>summary</Value>
</Value>
<Value name="6">
<Value>parameters</Value>
</Value>
<Value name="7">
<Value>actDesc</Value>
</Value>
<Value name="8">
<Value>subActRecord</Value>
</Value>
<Value name="9">
<Value>endDate</Value>
</Value>
<Value name="10">
<Value>endTime</Value>
</Value>
<Value name="11">
<Value>objId</Value>
</Value>
<Value name="12">
<Value>actCode</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.ActRecordD</DataLocation>
<DefaultData>ActRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.ActRecordD</IdLocation>
<IndexLocation>^DWR.MSG.ActRecordI</IndexLocation>
<StreamLocation>^DWR.MSG.ActRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
