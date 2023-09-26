Class User.DHCANOPMedicalHistory Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPMedicalHistory ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// 心血管系统

Property Cardiovascular As %String;

// 呼吸系统

Property RespSystem As %String;

// 呼吸系统(其他)

Property RespSystemOther As %String;

// 循环系统

Property CirculatorySystem As %String;

// 循环系统(其他)

Property CirculSystemOther As %String;

// 神经系统

Property NervousSystem As %String;

// 内分泌系统

Property EndocrineSystem As %String;

// 血液系统

Property BloodSystem As %String;

// 血液系统(其他)

Property BloodSystemOther As %String;

// 消化系统

Property DigestiveSystem As %String;

// 消化系统(其他)

Property DigestiveSystemOther As %String;

// 泌尿系统

Property UrinarySystem As %String;

// 泌尿系统(其他)

Property UrinarySystemOther As %String;

// 神经系统

Property NervSystemOther As %String;

// 生殖系统

Property GenitalSystem As %String;

// 骨骼系统

Property BoneSystem As %String;

// 骨骼系统(其他)

Property BoneSystemOther As %String;

// 心节律

Property CardiacRhythm As %String;

// 高血压

Property Hypertension As %String;

// 肌肉系统 重症肌无力;瘫痪;

Property Muscle As %String;

// 精神系统 精神分裂症;抑郁症;

Property MindSystem As %String;

// 其他

Property OtherSystem As %String;

// 手术麻醉史

Property PreAnop As %String;

// 手术麻醉史(其他)

Property PreAnopOther As %String;

// 药物过敏史

Property PreAllergy As %String;

// 手术史

Property PreOperation As %String;

// 传染病史

Property PreContagion As %String;

// 家族病史

Property FamilyMedHistory As %String;

// 家族病史(其他)

Property FamilyMedHistoryOther As %String;

// 心脏病

Property HeartDisease As %String;

// 脑血管疾病

Property Cerebrovascular As %String;

// 癫痫

Property Epilepsy As %String;

// 糖尿病

Property Diabetes As %String;

// 甲亢

Property Hyperthyroidism As %String;

// 麻醉史并发症

Property AnComplication As %String;

// 过敏物

Property Allergen As %String;

// 术前合并症

Property PreComplication As %String;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

Storage Default
{
<Data name="DHCANOPMedicalHistoryDefaultData">
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
<Value>Cardiovascular</Value>
</Value>
<Value name="9">
<Value>RespSystem</Value>
</Value>
<Value name="10">
<Value>RespSystemOther</Value>
</Value>
<Value name="11">
<Value>CirculatorySystem</Value>
</Value>
<Value name="12">
<Value>CirculSystemOther</Value>
</Value>
<Value name="13">
<Value>NervousSystem</Value>
</Value>
<Value name="14">
<Value>EndocrineSystem</Value>
</Value>
<Value name="15">
<Value>BloodSystem</Value>
</Value>
<Value name="16">
<Value>BloodSystemOther</Value>
</Value>
<Value name="17">
<Value>DigestiveSystem</Value>
</Value>
<Value name="18">
<Value>DigestiveSystemOther</Value>
</Value>
<Value name="19">
<Value>UrinarySystem</Value>
</Value>
<Value name="20">
<Value>UrinarySystemOther</Value>
</Value>
<Value name="21">
<Value>NervSystemOther</Value>
</Value>
<Value name="22">
<Value>GenitalSystem</Value>
</Value>
<Value name="23">
<Value>BoneSystem</Value>
</Value>
<Value name="24">
<Value>BoneSystemOther</Value>
</Value>
<Value name="25">
<Value>CardiacRhythm</Value>
</Value>
<Value name="26">
<Value>Hypertension</Value>
</Value>
<Value name="27">
<Value>Muscle</Value>
</Value>
<Value name="28">
<Value>MindSystem</Value>
</Value>
<Value name="29">
<Value>OtherSystem</Value>
</Value>
<Value name="30">
<Value>PreAnop</Value>
</Value>
<Value name="31">
<Value>PreAnopOther</Value>
</Value>
<Value name="32">
<Value>PreAnopOtherOther</Value>
</Value>
<Value name="33">
<Value>PreAllergy</Value>
</Value>
<Value name="34">
<Value>FamilyMedHistory</Value>
</Value>
<Value name="35">
<Value>FamilyMedHistoryOther</Value>
</Value>
<Value name="36">
<Value>PreOp</Value>
</Value>
<Value name="37">
<Value>PreContagion</Value>
</Value>
<Value name="38">
<Value>PreOperation</Value>
</Value>
<Value name="39">
<Value>HeartDisease</Value>
</Value>
<Value name="40">
<Value>Cerebrovascular</Value>
</Value>
<Value name="41">
<Value>Epilepsy</Value>
</Value>
<Value name="42">
<Value>Diabetes</Value>
</Value>
<Value name="43">
<Value>Hyperthyroidism</Value>
</Value>
<Value name="44">
<Value>AnComplication</Value>
</Value>
<Value name="45">
<Value>Allergen</Value>
</Value>
<Value name="46">
<Value>PreComplication</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPMedicalHistoryD</DataLocation>
<DefaultData>DHCANOPMedicalHistoryDefaultData</DefaultData>
<IdLocation>^User.DHCANOPMedicalHistoryD</IdLocation>
<IndexLocation>^User.DHCANOPMedicalHistoryI</IndexLocation>
<StreamLocation>^User.DHCANOPMedicalHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
