Class dhc.ca.cache.io.IncomeDatasReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 月份
Property month As %Library.String(TRUNCATE = 1);

/// 收费日期
Property feeDate As %Library.String(TRUNCATE = 1);

/// 病人类型
Property patType As %Library.String(TRUNCATE = 1);

/// 项目代码
Property itemCode As %Library.String(TRUNCATE = 1);

/// 项目名称
Property itemName As %Library.String(TRUNCATE = 1);

/// 收费金额
Property fee As %Library.Float;

/// 开单科室代码
Property fDeptCode As %Library.String(TRUNCATE = 1);

/// 开单科室名称
Property fDeptName As %Library.String(TRUNCATE = 1);

/// 接受科室代码
Property tDeptCode As %Library.String(TRUNCATE = 1);

/// 接受科室名称
Property tDeptName As %Library.String(TRUNCATE = 1);

/// 病人科室代码
Property patDeptCode As %Library.String(TRUNCATE = 1);

/// 病人科室名称
Property patDeptName As %Library.String(TRUNCATE = 1);

/// 采集方式
Property inType As %Library.String(TRUNCATE = 1);

/// 备注
Property remark As %Library.String(TRUNCATE = 1);

/// 采集日期
Property inDate As %Library.String(TRUNCATE = 1);

Storage Default
{
<Data name="IncomeDatasReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IncomeDatascost</Value>
</Value>
<Value name="3">
<Value>IncomeDatasfDeptCode</Value>
</Value>
<Value name="4">
<Value>IncomeDatasfDeptDr</Value>
</Value>
<Value name="5">
<Value>IncomeDatasfDeptName</Value>
</Value>
<Value name="6">
<Value>IncomeDatasfee</Value>
</Value>
<Value name="7">
<Value>IncomeDatasfeeDate</Value>
</Value>
<Value name="8">
<Value>IncomeDatasinDate</Value>
</Value>
<Value name="9">
<Value>IncomeDatasinPersonDr</Value>
</Value>
<Value name="10">
<Value>IncomeDatasinType</Value>
</Value>
<Value name="11">
<Value>IncomeDatasitemCode</Value>
</Value>
<Value name="12">
<Value>IncomeDatasitemDr</Value>
</Value>
<Value name="13">
<Value>IncomeDatasitemName</Value>
</Value>
<Value name="14">
<Value>IncomeDataspatDeptCode</Value>
</Value>
<Value name="15">
<Value>IncomeDataspatDeptDr</Value>
</Value>
<Value name="16">
<Value>IncomeDataspatDeptName</Value>
</Value>
<Value name="17">
<Value>IncomeDataspatType</Value>
</Value>
<Value name="18">
<Value>IncomeDatasremark</Value>
</Value>
<Value name="19">
<Value>IncomeDatastDeptCode</Value>
</Value>
<Value name="20">
<Value>IncomeDatastDeptDr</Value>
</Value>
<Value name="21">
<Value>IncomeDatastDeptName</Value>
</Value>
<Value name="22">
<Value>month</Value>
</Value>
<Value name="23">
<Value>IncomeDatasinPerson</Value>
</Value>
<Value name="24">
<Value>cost</Value>
</Value>
<Value name="25">
<Value>fDeptCode</Value>
</Value>
<Value name="26">
<Value>fDeptName</Value>
</Value>
<Value name="27">
<Value>fee</Value>
</Value>
<Value name="28">
<Value>feeDate</Value>
</Value>
<Value name="29">
<Value>inDate</Value>
</Value>
<Value name="30">
<Value>inPerson</Value>
</Value>
<Value name="31">
<Value>inType</Value>
</Value>
<Value name="32">
<Value>itemCode</Value>
</Value>
<Value name="33">
<Value>itemName</Value>
</Value>
<Value name="34">
<Value>patDeptCode</Value>
</Value>
<Value name="35">
<Value>patDeptName</Value>
</Value>
<Value name="36">
<Value>patType</Value>
</Value>
<Value name="37">
<Value>remark</Value>
</Value>
<Value name="38">
<Value>tDeptCode</Value>
</Value>
<Value name="39">
<Value>tDeptName</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach549.IncomeDatasR6C4D</DataLocation>
<DefaultData>IncomeDatasReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cach549.IncomeDatasR6C4D</IdLocation>
<IndexLocation>^dhc.ca.cach549.IncomeDatasR6C4I</IndexLocation>
<StreamLocation>^dhc.ca.cach549.IncomeDatasR6C4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
