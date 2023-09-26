Class ABN.DHCNurBadResponse Extends %Persistent
{

//注射日期 

Relationship CureRecsubParef As ABN.DHCNurCureRecChild [ Cardinality = parent, Inverse = BadSub, Required ];

Property InjectionDate As %Library.Date(FORMAT = 1);

//	时间    

Property InjectionTime As %Library.Time;

//	反应日期 

Property ResponseDate As %Library.Date(FORMAT = 1);

//	时间    

Property RecponseTime As %Library.Time;

//	稀释液浓度（瓶号）

Property LiquidDensity As %String(TRUNCATE = 1);

//	是否第一次注射该瓶药物

Property FirstInjection As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	局部反应（风团）

Property MissionWind As %String(TRUNCATE = 1);

//	红晕 

Property Blushes As %String(TRUNCATE = 1);

//	呼吸系统 

Property Breath As %String(TRUNCATE = 1);

//	皮肤   

Property Skin As %String(TRUNCATE = 1);

//	鼻眼

Property NoseEye As %String(TRUNCATE = 1);

//	心血管系统 

Property CardiovascularSystem As %String(TRUNCATE = 1);

//	其他 

Property Other As %String(TRUNCATE = 1);

//	措施  

Property Measure As %String(TRUNCATE = 1);

//	离院时间 

Property leaveDate As %Library.Date(FORMAT = 1);

//	         

Property LeaveTime As %Library.Time;

//	离院时状况 

Property LeaveStatus As %String(TRUNCATE = 1);

//	患者指导  

Property InstructionForPatients As %String(TRUNCATE = 1);

//	临床印象  

Property ClinicalImpression As %String(TRUNCATE = 1);

//	下次注射是否需要调整剂量 

Property AdjustDose As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//	签名  

Property Signature As %String;

//	日期  

Property SignatureDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property SignatureTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Storage Default
{
<Data name="DHCNurBadResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InjectionDate</Value>
</Value>
<Value name="3">
<Value>InjectionTime</Value>
</Value>
<Value name="4">
<Value>ResponseDate</Value>
</Value>
<Value name="5">
<Value>RecponseTime</Value>
</Value>
<Value name="6">
<Value>LiquidDensity</Value>
</Value>
<Value name="7">
<Value>FirstInjection</Value>
</Value>
<Value name="8">
<Value>MissionWind</Value>
</Value>
<Value name="9">
<Value>blushes</Value>
</Value>
<Value name="10">
<Value>Breath</Value>
</Value>
<Value name="11">
<Value>Skin</Value>
</Value>
<Value name="12">
<Value>NoseEye</Value>
</Value>
<Value name="13">
<Value>CardiovascularSystem</Value>
</Value>
<Value name="14">
<Value>Other</Value>
</Value>
<Value name="15">
<Value>Measure</Value>
</Value>
<Value name="16">
<Value>leaveDate</Value>
</Value>
<Value name="17">
<Value>LeaveTime</Value>
</Value>
<Value name="18">
<Value>LeaveStatus</Value>
</Value>
<Value name="19">
<Value>InstructionForPatients</Value>
</Value>
<Value name="20">
<Value>ClinicalImpression</Value>
</Value>
<Value name="21">
<Value>AdjustDose</Value>
</Value>
<Value name="22">
<Value>Signature</Value>
</Value>
<Value name="23">
<Value>SignatureDate</Value>
</Value>
<Value name="24">
<Value>Blushes</Value>
</Value>
<Value name="25">
<Value>SignatureTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("BadSub")</DataLocation>
<DefaultData>DHCNurBadResponseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurBadResponseD</IdLocation>
<IndexLocation>^ABN.DHCNurBadResponseI</IndexLocation>
<StreamLocation>^ABN.DHCNurBadResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
