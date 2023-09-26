Class User.DHCANOPLIS Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPLIS ]
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

/*
// 白血球

Property WBC As %String;

// 红细胞计数

Property RBC As %String;

// 血红蛋白

Property Hb As %String;

// 红细胞比容

Property HCT As %String;

// 血小板

Property PLT As %String;

// 谷丙转氨酶

Property ALT As %String;

// 谷草转氨酶

Property AST As %String;

// 白蛋白

Property ALB As %String;

// 胆红素

Property BIL As %String;

// 碱性磷酸酶

Property ALP As %String;

// 葡萄糖(血糖)

Property GLU As %String;

// 肌酐

Property CREA As %String;

// 尿素

Property BUN As %String;

// 尿酸

Property UA As %String;

Property CHOL As %String;

// 甘油三酯

Property TG As %String;

// 高密度脂蛋白

Property HDLC As %String;

// 低密度脂蛋白

Property LDLC As %String;

// 血清乳酸脱氢酶

Property LDH As %String;

// 肌酸激酶同工酶

Property CKMB As %String;

// 血浆中存在狼疮抗凝物

Property LAC As %String;

// 活化部分凝血活酶时间

Property APTT As %String;

Property K As %String;

Property Na As %String;

Property Ca As %String;

Property Cl As %String;

// 乙型肝炎表面抗原

Property HBSAg As %String;

// 表面抗体

Property HBsAb As %String;

// e抗原

Property HBeAg As %String;

// 核心抗体

Property HBcAb As %String;

// 丙型肝炎病毒(HCV)抗体

Property HCVAb As %String;

// 人类免疫缺陷病毒抗体

Property HivAb As %String;

// 抗胰腺腺泡抗体

Property PAb As %String;

// 凝血酶原时间

Property PT As %String;

// 凝血酶原活动度

Property PTA As %String;

// 凝血酶原时间比值

Property PTR As %String;

// 国际标准化比值

Property INR As %String;

// 肺结核皮试

Property PTT As %String;

// 血浆纤维蛋白原

Property FIB As %String;

// D二聚体

Property DDimer As %String;

// 纤溶酶原降解产物

Property FDP As %String;

// 尿酮体

Property KET As %String;

// 尿液蛋白质定性

Property UrineNPRO As %String;

// 尿液酸碱度

Property UrinePH As %String;

// 尿液隐血

Property UrineERY As %String;

Property PH As %String;

Property PCO2 As %String;

Property PO2 As %String;

Property HCO3 As %String;

Property BE As %String;

Property SO2 As %String;

Property GPL As %String;

Property GOT As %String;

Property Cr As %String;

Property Other As %String;
*/
Storage Default
{
<Data name="DHCANOPLISDefaultData">
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
<Value>WBC</Value>
</Value>
<Value name="9">
<Value>RBC</Value>
</Value>
<Value name="10">
<Value>Hb</Value>
</Value>
<Value name="11">
<Value>Hct</Value>
</Value>
<Value name="12">
<Value>Plt</Value>
</Value>
<Value name="13">
<Value>ALT</Value>
</Value>
<Value name="14">
<Value>AST</Value>
</Value>
<Value name="15">
<Value>ALB</Value>
</Value>
<Value name="16">
<Value>BIL</Value>
</Value>
<Value name="17">
<Value>ALP</Value>
</Value>
<Value name="18">
<Value>GLU</Value>
</Value>
<Value name="19">
<Value>CREA</Value>
</Value>
<Value name="20">
<Value>BUN</Value>
</Value>
<Value name="21">
<Value>UA</Value>
</Value>
<Value name="22">
<Value>CHOL</Value>
</Value>
<Value name="23">
<Value>TG</Value>
</Value>
<Value name="24">
<Value>HDLC</Value>
</Value>
<Value name="25">
<Value>LDLC</Value>
</Value>
<Value name="26">
<Value>LDH</Value>
</Value>
<Value name="27">
<Value>CKMB</Value>
</Value>
<Value name="28">
<Value>LAC</Value>
</Value>
<Value name="29">
<Value>APTT</Value>
</Value>
<Value name="30">
<Value>K</Value>
</Value>
<Value name="31">
<Value>Na</Value>
</Value>
<Value name="32">
<Value>Ca</Value>
</Value>
<Value name="33">
<Value>Cl</Value>
</Value>
<Value name="34">
<Value>HBSAg</Value>
</Value>
<Value name="35">
<Value>HBsAb</Value>
</Value>
<Value name="36">
<Value>HBeAg</Value>
</Value>
<Value name="37">
<Value>HBcAb</Value>
</Value>
<Value name="38">
<Value>HCVAb</Value>
</Value>
<Value name="39">
<Value>HivAb</Value>
</Value>
<Value name="40">
<Value>PAb</Value>
</Value>
<Value name="41">
<Value>PT</Value>
</Value>
<Value name="42">
<Value>PTA</Value>
</Value>
<Value name="43">
<Value>PTR</Value>
</Value>
<Value name="44">
<Value>INR</Value>
</Value>
<Value name="45">
<Value>PTT</Value>
</Value>
<Value name="46">
<Value>FIB</Value>
</Value>
<Value name="47">
<Value>DDimer</Value>
</Value>
<Value name="48">
<Value>FDP</Value>
</Value>
<Value name="49">
<Value>KET</Value>
</Value>
<Value name="50">
<Value>UrineNPRO</Value>
</Value>
<Value name="51">
<Value>UrinePH</Value>
</Value>
<Value name="52">
<Value>UrineERY</Value>
</Value>
<Value name="53">
<Value>PH</Value>
</Value>
<Value name="54">
<Value>PCO2</Value>
</Value>
<Value name="55">
<Value>PO2</Value>
</Value>
<Value name="56">
<Value>HCO3</Value>
</Value>
<Value name="57">
<Value>BE</Value>
</Value>
<Value name="58">
<Value>SO2</Value>
</Value>
<Value name="59">
<Value>GPL</Value>
</Value>
<Value name="60">
<Value>GOT</Value>
</Value>
<Value name="61">
<Value>Cr</Value>
</Value>
<Value name="62">
<Value>Other</Value>
</Value>
</Data>
<Data name="DataList">
<Attribute>DataList</Attribute>
<Structure>subnode</Structure>
<Subscript>"DataList"</Subscript>
</Data>
<DataLocation>^User.DHCANOPLISD</DataLocation>
<DefaultData>DHCANOPLISDefaultData</DefaultData>
<IdLocation>^User.DHCANOPLISD</IdLocation>
<IndexLocation>^User.DHCANOPLISI</IndexLocation>
<StreamLocation>^User.DHCANOPLISS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
