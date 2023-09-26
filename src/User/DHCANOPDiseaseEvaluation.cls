Class User.DHCANOPDiseaseEvaluation Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPEiseaseEvaluation ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

// ASA分级

Property ASAGrade As %String;

// 心功能分级

Property FunctionGrade As %String;

// 手术风险

Property OperationRisk As %String;

// 麻醉风险

Property AnaClass As %String;

// Mallampati分类

Property Mallampati分类 As %String;

// 呼吸道分类

Property RespTractClass As %String;

// 呼吸困难分类

Property DyspneaClass As %String;

// 插管困难

Property IntubatDiffcult As %String;

// 麻醉困难估计及意外防范措施

Property DifficultyEstimation As %String;

// 心理评估

Property PsycholAssessment As %String;

// 营养状况

Property NutrStatus As %String;

// 皮肤状况

Property SkinCondition As %String;

// 镇痛泵

Property AnalgesicPump As %String;

// 敷料

Property Dressing As %String;

// 引流管

Property DrainageTube As %String;

// 评价

Property Evaluate As %String;

// 建议

Property Proposal As %String;

// 饮食情况

Property Diet As %String;

// 运动情况

Property Motion As %String;

// 假体

Property Prosthesis As %String;

// 植入物

Property Implants As %String;

// 过敏原

Property Allergen As %String;

// 感染情况

Property Infected As %String;

// 假牙

Property FalseTeeth As %String;

// 压疮

Property PressureSore As %String;

// 月经期

Property MenstrualPeriod As %String;

// 沟通

Property Communicate As %String;

// 访视方式

Property VisitType As %String;

// 病人去向

Property Whereabouts As %String;

// 术后日期

Property PostOpDate As %String;

// 不适

Property Discomfort As %String;

// 并发症

Property Complication As %String;

// 疼痛

Property Pain As %String;

// 红肿

Property Swollen As %String;

// 恶心、呕吐

Property Nausea As %String;

Storage Default
{
<Data name="DHCANOPDiseaseEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeId</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>DataDate</Value>
</Value>
<Value name="5">
<Value>DataTime</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>ASAGrade</Value>
</Value>
<Value name="9">
<Value>FunctionGrade</Value>
</Value>
<Value name="10">
<Value>OperationRisk</Value>
</Value>
<Value name="11">
<Value>AnaClass</Value>
</Value>
<Value name="12">
<Value>Mallampati分类</Value>
</Value>
<Value name="13">
<Value>RespTractClass</Value>
</Value>
<Value name="14">
<Value>DyspneaClass</Value>
</Value>
<Value name="15">
<Value>IntubatDiffcult</Value>
</Value>
<Value name="16">
<Value>AnaestType</Value>
</Value>
<Value name="17">
<Value>DifficultyEstimation</Value>
</Value>
<Value name="18">
<Value>PsycholAssessment</Value>
</Value>
<Value name="19">
<Value>NutrStatus</Value>
</Value>
<Value name="20">
<Value>SkinCondition</Value>
</Value>
<Value name="21">
<Value>Consciousness</Value>
</Value>
<Value name="22">
<Value>AnalgesicPump</Value>
</Value>
<Value name="23">
<Value>Dressing</Value>
</Value>
<Value name="24">
<Value>DrainageTube</Value>
</Value>
<Value name="25">
<Value>Evaluate</Value>
</Value>
<Value name="26">
<Value>Proposal</Value>
</Value>
<Value name="27">
<Value>Diet</Value>
</Value>
<Value name="28">
<Value>Motion</Value>
</Value>
<Value name="29">
<Value>Prosthesis</Value>
</Value>
<Value name="30">
<Value>Implants</Value>
</Value>
<Value name="31">
<Value>Allergen</Value>
</Value>
<Value name="32">
<Value>Infected</Value>
</Value>
<Value name="33">
<Value>FalseTeeth</Value>
</Value>
<Value name="34">
<Value>PressureSore</Value>
</Value>
<Value name="35">
<Value>MenstrualPeriod</Value>
</Value>
<Value name="36">
<Value>Communicate</Value>
</Value>
<Value name="37">
<Value>VisitType</Value>
</Value>
<Value name="38">
<Value>Whereabouts</Value>
</Value>
<Value name="39">
<Value>PostOpDate</Value>
</Value>
<Value name="40">
<Value>Discomfort</Value>
</Value>
<Value name="41">
<Value>Complication</Value>
</Value>
<Value name="42">
<Value>Pain</Value>
</Value>
<Value name="43">
<Value>Swollen</Value>
</Value>
<Value name="44">
<Value>Nausea</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPDiseaseEvaluationD</DataLocation>
<DefaultData>DHCANOPDiseaseEvaluationDefaultData</DefaultData>
<IdLocation>^User.DHCANOPDiseaseEvaluationD</IdLocation>
<IndexLocation>^User.DHCANOPDiseaseEvaluationI</IndexLocation>
<StreamLocation>^User.DHCANOPDiseaseEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
