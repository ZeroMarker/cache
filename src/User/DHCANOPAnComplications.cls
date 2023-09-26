Class User.DHCANOPAnComplications Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPAnComplications ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// 神经阻滞麻醉

Property NerveBlockAnest As %String;

// 椎管内麻醉

Property IntraspinalAnest As %String;

// 椎管内麻醉-部位

Property IntraspinalPosition As %String;

// 肌力

Property MuscleStrength As %String;

// 痛觉

Property SenseOfPain As %String;

// 触觉

Property TactileSensation As %String;

// 全身麻醉

Property GeneralAnest As %String;

// 气管插管

Property TracheaCannula As %String;

// 全麻-术中知晓

Property GenInOpAwareness As %String;

// 全麻-嗜睡

Property GenSleepiness As %String;

// 全麻-肌肉

Property GenMuscle As %String;

// 全麻-恶心

Property GenNausea As %String;

// 全麻-呕吐

Property GenVomit As %String;

// 全麻-声音

Property GenVoice As %String;

// 全麻-咽喉

Property GenThroat As %String;

// 全麻-其它并发症

Property GenOtherComplication As %String;

// 全麻-并发症信息

Property GenComplicationNote As %String;

// 全麻-处理措施

Property GenComplicatMeasures As %String;

// 椎管并发-腰痛

Property IntrLumbago As %String;

// 椎管并发-恶心

Property IntrNausea As %String;

// 椎管并发-呕吐

Property IntrVomit As %String;

// 椎管并发-下肢感觉

Property IntrLowerLimbFeel As %String;

// 椎管并发-下肢运动

Property IntrLowerLimbMove As %String;

// 椎管并发-其它

Property IntrOtherComplication As %String;

// 椎管并发-其它并发信息

Property IntrComplicationNote As %String;

// 椎管并发-处理措施

Property IntrComplicatMeasures As %String;

// 神经阻滞-并发症

Property NerComplication As %String;

// 神经阻滞-并发症信息

Property NerComplicationNote As %String;

// 神经阻滞-处理措施

Property NerComplicatMeasures As %String;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

Storage Default
{
<Data name="DHCANOPAnComplicationsDefaultData">
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
<Value>NerveBlockAnest</Value>
</Value>
<Value name="9">
<Value>IntraspinalAnest</Value>
</Value>
<Value name="10">
<Value>IntraspinalPosition</Value>
</Value>
<Value name="11">
<Value>MuscleStrength</Value>
</Value>
<Value name="12">
<Value>SenseOfPain</Value>
</Value>
<Value name="13">
<Value>TactileSensation</Value>
</Value>
<Value name="14">
<Value>GeneralAnest</Value>
</Value>
<Value name="15">
<Value>TracheaCannula</Value>
</Value>
<Value name="16">
<Value>GenInOpAwareness</Value>
</Value>
<Value name="17">
<Value>GenSleepiness</Value>
</Value>
<Value name="18">
<Value>GenMuscle</Value>
</Value>
<Value name="19">
<Value>GenNausea</Value>
</Value>
<Value name="20">
<Value>GenVomit</Value>
</Value>
<Value name="21">
<Value>GenVoice</Value>
</Value>
<Value name="22">
<Value>GenThroat</Value>
</Value>
<Value name="23">
<Value>GenOtherComplication</Value>
</Value>
<Value name="24">
<Value>GenComplicationNote</Value>
</Value>
<Value name="25">
<Value>GenComplicatMeasures</Value>
</Value>
<Value name="26">
<Value>IntrLumbago</Value>
</Value>
<Value name="27">
<Value>IntrNausea</Value>
</Value>
<Value name="28">
<Value>IntrVomit</Value>
</Value>
<Value name="29">
<Value>IntrLowerLimbFeel</Value>
</Value>
<Value name="30">
<Value>IntrLowerLimbMove</Value>
</Value>
<Value name="31">
<Value>IntrOtherComplication</Value>
</Value>
<Value name="32">
<Value>IntrComplicationNote</Value>
</Value>
<Value name="33">
<Value>IntrComplicatMeasures</Value>
</Value>
<Value name="34">
<Value>NerComplication</Value>
</Value>
<Value name="35">
<Value>NerComplicationNote</Value>
</Value>
<Value name="36">
<Value>NerComplicatMeasures</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPAnComplicationsD</DataLocation>
<DefaultData>DHCANOPAnComplicationsDefaultData</DefaultData>
<IdLocation>^User.DHCANOPAnComplicationsD</IdLocation>
<IndexLocation>^User.DHCANOPAnComplicationsI</IndexLocation>
<StreamLocation>^User.DHCANOPAnComplicationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
