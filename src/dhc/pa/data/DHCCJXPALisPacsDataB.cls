Class dhc.pa.data.DHCCJXPALisPacsDataB Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

//影像号

Property ImageNo As %String [ SqlColumnNumber = 2 ];

//检查号

Property CheckNo As %String [ SqlColumnNumber = 3 ];

//预留存储设备code

Property CheckCode As %String [ SqlColumnNumber = 4 ];

//检查设备

Property CheckEquipment As %String [ SqlColumnNumber = 5 ];

//登记医生

Property RegisterDoc As %String [ SqlColumnNumber = 6 ];

//登记日期

Property RegisterPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//登记时间

Property RegisterTime As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

//检查项目

Property CheckItem As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

//申请科室ID As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0)

Property ApplyDeptID [ SqlColumnNumber = 10 ];

//申请科室

Property ApplyDept As %String [ SqlColumnNumber = 11 ];

//申请医生

Property ApplyDoctor As %String [ SqlColumnNumber = 12 ];

//检查日期

Property CheckDate As %String [ SqlColumnNumber = 13 ];

//检查时间

Property CheckTime As %String [ SqlColumnNumber = 14 ];

//影像室

Property ImageRoom As %String [ SqlColumnNumber = 15 ];

//报告医生

Property ReportDoc As %String [ SqlColumnNumber = 16 ];

//审核医师

Property AuditDoc As %String [ SqlColumnNumber = 17 ];

//检查医生

Property CheckDoc As %String [ SqlColumnNumber = 18 ];

//操作技师

Property OperateDoc As %String [ SqlColumnNumber = 19 ];

//申请医院

Property ApplyHos As %String [ SqlColumnNumber = 20 ];

//申请单号

Property ApplyNo As %String [ SqlColumnNumber = 21 ];

//报告日期

Property ReportDate As %String [ SqlColumnNumber = 22 ];

//总费用

Property AllCost As %String [ SqlColumnNumber = 23 ];

//HISID号

Property HISID As %String [ SqlColumnNumber = 24 ];

//记费

Property CountCost As %String [ SqlColumnNumber = 25 ];

//患者来源

Property PaSource As %String [ SqlColumnNumber = 26 ];

//阴阳性

Property YinYang As %String [ SqlColumnNumber = 27 ];

//数据来源

Property DataSource As %String [ SqlColumnNumber = 28 ];

//工作量

Property workload As %Integer [ SqlColumnNumber = 29 ];

//出报告时间

Property ReportTime As %Float [ SqlColumnNumber = 30 ];

//插入时间

Property InsertDate As %String [ SqlColumnNumber = 31 ];

//导入说明

Property LoadDesc As %String [ SqlColumnNumber = 32 ];

Storage Default
{
<Data name="DHCCJXPALisPacsDataBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ImageNo</Value>
</Value>
<Value name="3">
<Value>CheckNo</Value>
</Value>
<Value name="4">
<Value>CheckCode</Value>
</Value>
<Value name="5">
<Value>CheckEquipment</Value>
</Value>
<Value name="6">
<Value>RegisterDoc</Value>
</Value>
<Value name="7">
<Value>RegisterPeriod</Value>
</Value>
<Value name="8">
<Value>RegisterTime</Value>
</Value>
<Value name="9">
<Value>CheckItem</Value>
</Value>
<Value name="10">
<Value>ApplyDept</Value>
</Value>
<Value name="11">
<Value>ApplyDoctor</Value>
</Value>
<Value name="12">
<Value>CheckDate</Value>
</Value>
<Value name="13">
<Value>CheckTime</Value>
</Value>
<Value name="14">
<Value>ImageRoom</Value>
</Value>
<Value name="15">
<Value>ReportDoc</Value>
</Value>
<Value name="16">
<Value>AuditDoc</Value>
</Value>
<Value name="17">
<Value>CheckDoc</Value>
</Value>
<Value name="18">
<Value>OperateDoc</Value>
</Value>
<Value name="19">
<Value>ApplyHos</Value>
</Value>
<Value name="20">
<Value>ApplyNo</Value>
</Value>
<Value name="21">
<Value>ReportDate</Value>
</Value>
<Value name="22">
<Value>AllCost</Value>
</Value>
<Value name="23">
<Value>HISID</Value>
</Value>
<Value name="24">
<Value>CountCost</Value>
</Value>
<Value name="25">
<Value>PaSource</Value>
</Value>
<Value name="26">
<Value>YinYang</Value>
</Value>
<Value name="27">
<Value>DataSource</Value>
</Value>
<Value name="28">
<Value>ApplyDeptID</Value>
</Value>
<Value name="29">
<Value>workload</Value>
</Value>
<Value name="30">
<Value>ReportTime</Value>
</Value>
<Value name="31">
<Value>InsertDate</Value>
</Value>
<Value name="32">
<Value>LoadDesc</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.DHCCJXPALis1139D</DataLocation>
<DefaultData>DHCCJXPALisPacsDataBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.DHCCJXPALis1139D</IdLocation>
<IndexLocation>^dhc.pa.data.DHCCJXPALis1139I</IndexLocation>
<StreamLocation>^dhc.pa.data.DHCCJXPALis1139S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
