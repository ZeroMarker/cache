/// 检验报告
Class DWR.ORD.MSG.LISReport Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "LISReport";

/// 检验号
Property LabNo As %String(TRUNCATE = 1);

/// 报告编号
Property LabSerialNo As %String(TRUNCATE = 1);

/// 类别号
Property CategroryNo As %String(TRUNCATE = 1);

/// 报告类型
Property ReportType As %String(TRUNCATE = 1);

/// 检验医嘱代码
Property LabItemCode As %String(TRUNCATE = 1);

/// 检验医嘱名称
Property LabItemDesc As %String(TRUNCATE = 1);

/// 检验科室
Property LabLoc As %String(TRUNCATE = 1);

/// 标本类型
Property SpecimenType As %String(TRUNCATE = 1);

/// 采标本日期
Property SamplingDate As %String(TRUNCATE = 1);

/// 接收标本日期
Property ReceiveSpecDate As %String(TRUNCATE = 1);

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告医生
Property ReportDoctor As %String(TRUNCATE = 1);

/// 审核日期
Property VerifyDate As %String(TRUNCATE = 1);

/// 审核医生
Property VerifyDoctor As %String(TRUNCATE = 1);

/// 检验项目列表
Property LISReportItemList As list Of DWR.ORD.MSG.LISReportItem(XMLNAME = "LISReportItemList");

/// 检验报告浏览URL
Property LISReportURL As %String(MAXLEN = 2000, TRUNCATE = 1);

Storage Default
{
<Data name="LISReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategroryNo</Value>
</Value>
<Value name="3">
<Value>LISReportItemList</Value>
</Value>
<Value name="4">
<Value>LabItemCode</Value>
</Value>
<Value name="5">
<Value>LabItemDesc</Value>
</Value>
<Value name="6">
<Value>LabLoc</Value>
</Value>
<Value name="7">
<Value>LabNo</Value>
</Value>
<Value name="8">
<Value>LabSerialNo</Value>
</Value>
<Value name="9">
<Value>ReceiveSpecDate</Value>
</Value>
<Value name="10">
<Value>ReportDate</Value>
</Value>
<Value name="11">
<Value>ReportDoctor</Value>
</Value>
<Value name="12">
<Value>ReportType</Value>
</Value>
<Value name="13">
<Value>SamplingDate</Value>
</Value>
<Value name="14">
<Value>SpecimenType</Value>
</Value>
<Value name="15">
<Value>VerifyDate</Value>
</Value>
<Value name="16">
<Value>VerifyDoctor</Value>
</Value>
<Value name="17">
<Value>LISReportURL</Value>
</Value>
</Data>
<DataLocation>^DWR.ORD.MSG.LISReportD</DataLocation>
<DefaultData>LISReportDefaultData</DefaultData>
<IdLocation>^DWR.ORD.MSG.LISReportD</IdLocation>
<IndexLocation>^DWR.ORD.MSG.LISReportI</IndexLocation>
<StreamLocation>^DWR.ORD.MSG.LISReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
