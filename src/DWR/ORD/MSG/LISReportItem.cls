/// 检验报告子项目
Class DWR.ORD.MSG.LISReportItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "LISReportItem";

/// 项目序号
Property SerialNo As %String(TRUNCATE = 1);

/// 项目代码
Property ItemCode As %String(TRUNCATE = 1);

/// 项目名称
Property ItemDesc As %String(TRUNCATE = 1);

/// 缩写
Property Abbreviation As %String(TRUNCATE = 1);

/// 结果
Property Result As %String(TRUNCATE = 1);

/// 结果值
Property ResultValue As %String(TRUNCATE = 1);

/// 单位
Property Unit As %String(TRUNCATE = 1);

/// 高低标志
Property UpDownFlag As %String(TRUNCATE = 1);

/// 正常范围
Property NaturalRange As %String(TRUNCATE = 1);

Storage Default
{
<Data name="LISReportItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Abbreviation</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemDesc</Value>
</Value>
<Value name="5">
<Value>NaturalRange</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>ResultValue</Value>
</Value>
<Value name="8">
<Value>SerialNo</Value>
</Value>
<Value name="9">
<Value>Unit</Value>
</Value>
<Value name="10">
<Value>UpDownFlag</Value>
</Value>
</Data>
<DataLocation>^DWR.ORD.MSG.LISReportItemD</DataLocation>
<DefaultData>LISReportItemDefaultData</DefaultData>
<IdLocation>^DWR.ORD.MSG.LISReportItemD</IdLocation>
<IndexLocation>^DWR.ORD.MSG.LISReportItemI</IndexLocation>
<StreamLocation>^DWR.ORD.MSG.LISReportItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
