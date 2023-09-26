Class CHSS.PersonInHosRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = InHosRowId, SqlTableName = PersonInHosRecord ]
{

Index PersonIndex On PersonRowId;

//个人档案主键

Property PersonRowId As CHSS.PersonHealthRecordMain;

//入院日期

Property DateInHos As %Date;

//医院名称

Property HospitalName As %String(MAXLEN = 50, TRUNCATE = 1);

//科室

Property DeptName As %String(MAXLEN = 50, TRUNCATE = 1);

//诊断

Property Diagnose As %String(MAXLEN = 100, TRUNCATE = 1);

//结果

Property Result As %String(MAXLEN = 100, TRUNCATE = 1);

//出院日期

Property DateOutHos As %Date;

//入院号

Property InHosCode As %String(MAXLEN = 50, TRUNCATE = 1);

//备注 

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

//登记日期

Property DateRegister As %Date;

//登记人员

Property Register As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="PersonInHosRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateInHos</Value>
</Value>
<Value name="3">
<Value>PersonRowId</Value>
</Value>
<Value name="4">
<Value>DateOutHos</Value>
</Value>
<Value name="5">
<Value>DateRegister</Value>
</Value>
<Value name="6">
<Value>DeptName</Value>
</Value>
<Value name="7">
<Value>Diagnose</Value>
</Value>
<Value name="8">
<Value>HospitalName</Value>
</Value>
<Value name="9">
<Value>InHosCode</Value>
</Value>
<Value name="10">
<Value>Register</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>Result</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonInHosRecordD</DataLocation>
<DefaultData>PersonInHosRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonInHosRecordD</IdLocation>
<IndexLocation>^CHSS.PersonInHosRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonInHosRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
