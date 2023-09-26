Class User.DHCBPDialysisApp Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_BP_DialysisApp ]
{

// 就诊号

Property AdmId As User.PAAdm;

// 创建用户

Property UserId As %String;

Property LocId As %String;

Property WardId As %String;

Property BedId As %String;

Property AppDate As %Date;

Property AppTime As %Time;

// 创建日期

Property UpdateDate As %Date;

// 创建时间

Property UpdateTime As %Time;

// 血管通路

Property VascularAccess As User.DHCBPCVascularAccess;

// 传染病类型

Property InfectiousDiseaseInfo As %String;

// 急诊

Property IsEmergency As %String;

// 联系电话

Property PhoneNum As %String;

// 备注

Property Note As %String;

// 申请、登记、删除

Property Status As %String(DISPLAYLIST = ",Apply,Receive,Decline", MAXLEN = 9, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",A,R,D");

// 身体部位

Property BodySite As User.DHCCLCBodySite;

// 透析状态(诱导、维持、过渡)

Property DialysisStatus As %String(DISPLAYLIST = ",Guide,Keep,Transit", MAXLEN = 9, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",G,K,T");

// 排班计划

Property ArrangePlan As %String(DISPLAYLIST = ",Guide3,Keep3,Temp1,Temp2,Temp3", MAXLEN = 9, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",G3,K3,T1,T2,T3");

// 血管通路其他

Property VascularAccessOther As %String;

// 抗凝方式

Property AnticoagulantMode As User.DHCBPCAnticoagulantMode;

// 抗凝药品

Property AnticoagulantDrug As %String;

// 治疗方式

Property BloodPurificationMode As User.DHCBPCBloodPurificationMode;

// 治疗时间

Property PlanTherapyDuration As %Float;

// 血流速

Property BFR As %Float;

// 透析液钾

Property K As %Float;

// 透析液钙

Property Ca2 As %Float;

// 透析液钠

Property Na As %Float;

// 净超滤量

Property DewaterAmount As %Float;

Index AdmIndex On (AdmId As Plus, AppDate As Plus, AppTime As Plus);

Index TimeIndex On (AppDate As Plus, AppTime As Plus, AdmId As Plus);

Index AppDate On AppDate As Exact;

Storage Default
{
<Data name="DHCBPDialysisAppDefaultData">
<Value name="1">
<Value>AdmId</Value>
</Value>
<Value name="2">
<Value>UserId</Value>
</Value>
<Value name="3">
<Value>LocId</Value>
</Value>
<Value name="4">
<Value>WardId</Value>
</Value>
<Value name="5">
<Value>BedId</Value>
</Value>
<Value name="6">
<Value>AppDate</Value>
</Value>
<Value name="7">
<Value>AppTime</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>VascularAccess</Value>
</Value>
<Value name="11">
<Value>InfectiousDiseaseInfo</Value>
</Value>
<Value name="12">
<Value>IsEmergency</Value>
</Value>
<Value name="13">
<Value>PhoneNum</Value>
</Value>
<Value name="14">
<Value>Note</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>BodySite</Value>
</Value>
<Value name="17">
<Value>DialysisStatus</Value>
</Value>
<Value name="18">
<Value>ArrangePlan</Value>
</Value>
<Value name="19">
<Value>VascularAccessOther</Value>
</Value>
<Value name="20">
<Value>AnticoagulantMode</Value>
</Value>
<Value name="21">
<Value>AnticoagulantDrug</Value>
</Value>
<Value name="22">
<Value>BloodPurificationMode</Value>
</Value>
<Value name="23">
<Value>PlanTherapyDuration</Value>
</Value>
<Value name="24">
<Value>BFR</Value>
</Value>
<Value name="25">
<Value>K</Value>
</Value>
<Value name="26">
<Value>Ca2</Value>
</Value>
<Value name="27">
<Value>Na</Value>
</Value>
<Value name="28">
<Value>DewaterAmount</Value>
</Value>
<Value name="29">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DHCBPDialysisAppD</DataLocation>
<DefaultData>DHCBPDialysisAppDefaultData</DefaultData>
<IdLocation>^User.DHCBPDialysisAppD</IdLocation>
<IndexLocation>^User.DHCBPDialysisAppI</IndexLocation>
<StreamLocation>^User.DHCBPDialysisAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
