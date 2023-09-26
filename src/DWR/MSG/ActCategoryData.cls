/// Descript:临床事件基础数据记录
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// 
Class DWR.MSG.ActCategoryData Extends (%Persistent, %XML.Adaptor)
{

Property categoryCode As %String;

Property dataTypeCode As %String;

Property actRecord As list Of DWR.MSG.ActRecord(XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="ActCategoryDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>categoryCode</Value>
</Value>
<Value name="3">
<Value>dataTypeCode</Value>
</Value>
<Value name="4">
<Value>ActRecord</Value>
</Value>
<Value name="5">
<Value>actRecord</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.ActCategoryDataD</DataLocation>
<DefaultData>ActCategoryDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.ActCategoryDataD</IdLocation>
<IndexLocation>^DWR.MSG.ActCategoryDataI</IndexLocation>
<StreamLocation>^DWR.MSG.ActCategoryDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
