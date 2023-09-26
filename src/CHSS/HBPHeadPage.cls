Class CHSS.HBPHeadPage Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HeadPageRowId, SqlTableName = HBPHeadPage ]
{

//个人档案主键	

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

//建档日期

Property Intime As %Date(FORMAT = 1);

//建档医生

Property Doctor As %String(MAXLEN = 60, TRUNCATE = 1);

//建档护士

Property Nurse As User.SSUser;

//录入人员

Property StaffInput As User.SSUser;

//录入时间

Property DateOfInput As %Date(FORMAT = 1);

//更新时间

Property DateOfUpdate As %Date(FORMAT = 1);

//经常就诊单位

Property DiagnoseUnit As %String(MAXLEN = 60, TRUNCATE = 1);

//吸烟情况

Property SmokeInfo As %String(MAXLEN = 20, TRUNCATE = 1);

//饮酒情况

Property DrinkInfo As %String(MAXLEN = 20, TRUNCATE = 1);

//体育锻炼

Property GymInfo As %String(MAXLEN = 20, TRUNCATE = 1);

//疾病史

Property DiseaseHistory As %String(MAXLEN = 100, TRUNCATE = 1);

//体重 

Property Weight As %Float;

//身高

Property High As %Float;

//BMI(自动计算)

Property BMI As %Float;

//危险因素

Property DangerousFactor As %String(MAXLEN = 100, TRUNCATE = 1);

//收缩压

Property HighPressure As %Numeric;

//舒张压

Property LowPressure As %Numeric;

//合并症

Property UniteIll As %String(MAXLEN = 100, TRUNCATE = 1);

//生活自理能力

Property SelfCare As CHSS.DictSelfCare;

//病例讨论

Property CaseDiscuss As %String(MAXLEN = 100, TRUNCATE = 1);

//讨论原因

Property ReasonOfDisc As %String(MAXLEN = 100, TRUNCATE = 1);

//讨论结果

Property ResultOfDisc As %String(MAXLEN = 100, TRUNCATE = 1);

//靶器官损害

Property Mof As %String(MAXLEN = 100, TRUNCATE = 1);

//检出途径

Property CheckOutWay As %String(MAXLEN = 60, TRUNCATE = 1);

//复核日期

Property DateOfCheck As %Date(FORMAT = 1);

//复核者

Property Checker As %String(MAXLEN = 60, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId [ Unique ];

Storage Default
{
<Data name="HBPHeadPageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>CaseDiscuss</Value>
</Value>
<Value name="4">
<Value>DangerousFactor</Value>
</Value>
<Value name="5">
<Value>DateOfInput</Value>
</Value>
<Value name="6">
<Value>DateOfUpdate</Value>
</Value>
<Value name="7">
<Value>DiagnoseUnit</Value>
</Value>
<Value name="8">
<Value>DiseaseHistory</Value>
</Value>
<Value name="9">
<Value>Doctor</Value>
</Value>
<Value name="10">
<Value>DrinkInfo</Value>
</Value>
<Value name="11">
<Value>GymInfo</Value>
</Value>
<Value name="12">
<Value>High</Value>
</Value>
<Value name="13">
<Value>HighPressure</Value>
</Value>
<Value name="14">
<Value>Intime</Value>
</Value>
<Value name="15">
<Value>LowPressure</Value>
</Value>
<Value name="16">
<Value>Nurse</Value>
</Value>
<Value name="17">
<Value>PersonRowId</Value>
</Value>
<Value name="18">
<Value>ReasonOfDisc</Value>
</Value>
<Value name="19">
<Value>ResultOfDisc</Value>
</Value>
<Value name="20">
<Value>SelfCare</Value>
</Value>
<Value name="21">
<Value>SmokeInfo</Value>
</Value>
<Value name="22">
<Value>StaffInput</Value>
</Value>
<Value name="23">
<Value>UniteIll</Value>
</Value>
<Value name="24">
<Value>Weight</Value>
</Value>
<Value name="25">
<Value>CheckOutWay</Value>
</Value>
<Value name="26">
<Value>Checker</Value>
</Value>
<Value name="27">
<Value>DateOfCheck</Value>
</Value>
<Value name="28">
<Value>Mof</Value>
</Value>
</Data>
<DataLocation>^CHSS.HBPHeadPageD</DataLocation>
<DefaultData>HBPHeadPageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HBPHeadPageD</IdLocation>
<IndexLocation>^CHSS.HBPHeadPageI</IndexLocation>
<StreamLocation>^CHSS.HBPHeadPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
