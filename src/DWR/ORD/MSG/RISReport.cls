/// 检查报告
Class DWR.ORD.MSG.RISReport Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "RISReport";

/// 报告标题1
Property ReportTitle1 As %String(TRUNCATE = 1);

/// 报告标题2
Property ReportTitle2 As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 就诊科室
Property AdmDept As %String(TRUNCATE = 1);

/// 病区
Property Ward As %String(TRUNCATE = 1);

/// 病房
Property Room As %String(TRUNCATE = 1);

/// 床号
Property Bed As %String(TRUNCATE = 1);

/// 检查号
Property StudyID As %String(TRUNCATE = 1);

/// 临床诊断
Property Diagnosis As %String(MAXLEN = 500, TRUNCATE = 1);

/// 资源
Property Resource As %String(TRUNCATE = 1);

/// 检查科室
Property ExamLoc As %String(TRUNCATE = 1);

/// 检查项目名称
Property ItemName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 检查所见
Property ExamDescEx As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 诊断意见
Property ResultDescEx As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 检查所见(备用字段)
Property SeeDesc As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 备注(备用字段)
Property Memo As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 报告日期
Property ReportDate As %Date;

/// 报告人
Property ReportUser As %String(TRUNCATE = 1);

/// 审核日期
Property VerifyDate As %Date;

/// 审核人
Property VerifyUser As %String(TRUNCATE = 1);

/// 检查报告浏览URL
Property RISReportURL As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 影像浏览URL
Property RISImageURL As %String(MAXLEN = 2000, TRUNCATE = 1);

Storage Default
{
<Data name="RISReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmDept</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>Bed</Value>
</Value>
<Value name="5">
<Value>Diagnosis</Value>
</Value>
<Value name="6">
<Value>ExamDescEx</Value>
</Value>
<Value name="7">
<Value>ExamLoc</Value>
</Value>
<Value name="8">
<Value>ItemName</Value>
</Value>
<Value name="9">
<Value>Memo</Value>
</Value>
<Value name="10">
<Value>Name</Value>
</Value>
<Value name="11">
<Value>RegNo</Value>
</Value>
<Value name="12">
<Value>ReportDate</Value>
</Value>
<Value name="13">
<Value>ReportTitle1</Value>
</Value>
<Value name="14">
<Value>ReportTitle2</Value>
</Value>
<Value name="15">
<Value>ReportUser</Value>
</Value>
<Value name="16">
<Value>Resource</Value>
</Value>
<Value name="17">
<Value>ResultDescEx</Value>
</Value>
<Value name="18">
<Value>Room</Value>
</Value>
<Value name="19">
<Value>SeeDesc</Value>
</Value>
<Value name="20">
<Value>Sex</Value>
</Value>
<Value name="21">
<Value>StudyID</Value>
</Value>
<Value name="22">
<Value>VerifyDate</Value>
</Value>
<Value name="23">
<Value>VerifyUser</Value>
</Value>
<Value name="24">
<Value>Ward</Value>
</Value>
<Value name="25">
<Value>RISReportURL</Value>
</Value>
</Data>
<DataLocation>^DWR.ORD.MSG.RISReportD</DataLocation>
<DefaultData>RISReportDefaultData</DefaultData>
<IdLocation>^DWR.ORD.MSG.RISReportD</IdLocation>
<IndexLocation>^DWR.ORD.MSG.RISReportI</IndexLocation>
<StreamLocation>^DWR.ORD.MSG.RISReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
