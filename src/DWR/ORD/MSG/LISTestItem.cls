/// 检验项目检验结果记录
Class DWR.ORD.MSG.LISTestItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "LISTestItem";

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

/// 检验组套
Property LabTestSetRow As %String(TRUNCATE = 1);

/// 检验医嘱名称
Property LabOrderItemdesc As %String(TRUNCATE = 1);

/// 检验日期
Property ReportDate As %String(TRUNCATE = 1);

/// 检验时间
Property ReportTime As %String(TRUNCATE = 1);

Storage Default
{
<Data name="LISTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Abbreviation</Value>
</Value>
<Value name="3">
<Value>LabOrderItemdesc</Value>
</Value>
<Value name="4">
<Value>LabTestSetRow</Value>
</Value>
<Value name="5">
<Value>NaturalRange</Value>
</Value>
<Value name="6">
<Value>ReportDate</Value>
</Value>
<Value name="7">
<Value>ReportTime</Value>
</Value>
<Value name="8">
<Value>Result</Value>
</Value>
<Value name="9">
<Value>ResultValue</Value>
</Value>
<Value name="10">
<Value>SerialNo</Value>
</Value>
<Value name="11">
<Value>TestItemCode</Value>
</Value>
<Value name="12">
<Value>TestItemDesc</Value>
</Value>
<Value name="13">
<Value>Unit</Value>
</Value>
<Value name="14">
<Value>UpDownFlag</Value>
</Value>
<Value name="15">
<Value>ItemCode</Value>
</Value>
<Value name="16">
<Value>ItemDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.ORD.MSG.LISTestItemD</DataLocation>
<DefaultData>LISTestItemDefaultData</DefaultData>
<IdLocation>^DWR.ORD.MSG.LISTestItemD</IdLocation>
<IndexLocation>^DWR.ORD.MSG.LISTestItemI</IndexLocation>
<StreamLocation>^DWR.ORD.MSG.LISTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
