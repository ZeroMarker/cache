Class ABN.DHCNurCureRecChild Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//周次，

Relationship CureRecParef As ABN.DHCNurCureRec [ Cardinality = parent, Inverse = ChildSub, Required ];

Relationship BadSub As ABN.DHCNurBadResponse [ Cardinality = children, Inverse = CureRecsubParef ];

Property WeekNo As %String(TRUNCATE = 1);

//	日期，

Property CureDate As %Library.Date(FORMAT = 1);

//	健康评估有无异常，

Property HealthExcepFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	是否用抗组胺药，

Property Antihistamine As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	峰流速（l/min）

Property PeakFlowRate As %String(TRUNCATE = 1);

//	评估医生, 

Property AssessmentDoc As %String(TRUNCATE = 1);

//	上臂，

Property Upperarm As %Library.String(DISPLAYLIST = ",Right,Left", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",R,L");

//	瓶号，

Property BottleNo As %String(TRUNCATE = 1);

//	浓度，

Property Density As %String(TRUNCATE = 1);

//	注射体积，

Property InjectionVolume As %String(TRUNCATE = 1);

//	风团，

Property MissionWind As %String(TRUNCATE = 1);

//	红晕，

Property blushes As %String(TRUNCATE = 1);

//	荨麻疹，

Property urticaria As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	鼻部症状，

Property Nose As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	哮喘，

Property Asthma As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	喉头水肿，

Property LaryngealEdema As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	休克，

Property Shock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	其他，

Property Other As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	备注，

Property Memo As %String(TRUNCATE = 1);

//	注射者签字 

Property injectionNurse As %String(TRUNCATE = 1);

//Exec,Abort

Property Status As %String;

//	风团2，

Property MissionWind2 As %String(TRUNCATE = 1);

//	红晕2，

Property blushes2 As %String(TRUNCATE = 1);

// 收费医嘱

Property Oeorditem As %String;

Index CureDate On CureDate;

Index Oeorditem On Oeorditem;

Storage Default
{
<Data name="DHCNurCureRecChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WeekNo</Value>
</Value>
<Value name="3">
<Value>CureDate</Value>
</Value>
<Value name="4">
<Value>HealthExcepFlag</Value>
</Value>
<Value name="5">
<Value>Antihistamine</Value>
</Value>
<Value name="6">
<Value>PeakFlowRate</Value>
</Value>
<Value name="7">
<Value>AssessmentDoc</Value>
</Value>
<Value name="8">
<Value>Upperarm</Value>
</Value>
<Value name="9">
<Value>BottleNo</Value>
</Value>
<Value name="10">
<Value>Density</Value>
</Value>
<Value name="11">
<Value>InjectionVolume</Value>
</Value>
<Value name="12">
<Value>MissionWind</Value>
</Value>
<Value name="13">
<Value>blushes</Value>
</Value>
<Value name="14">
<Value>urticaria</Value>
</Value>
<Value name="15">
<Value>Nose</Value>
</Value>
<Value name="16">
<Value>Asthma</Value>
</Value>
<Value name="17">
<Value>LaryngealEdema</Value>
</Value>
<Value name="18">
<Value>Shock</Value>
</Value>
<Value name="19">
<Value>Other</Value>
</Value>
<Value name="20">
<Value>Memo</Value>
</Value>
<Value name="21">
<Value>injectionNurse</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
<Value name="23">
<Value>MissionWind2</Value>
</Value>
<Value name="24">
<Value>blushes2</Value>
</Value>
<Value name="25">
<Value>Oeorditem</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCNurCureRecChildDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurCureRecChildD</IdLocation>
<IndexLocation>^ABN.DHCNurCureRecChildI</IndexLocation>
<StreamLocation>^ABN.DHCNurCureRecChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
