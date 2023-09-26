Class CHSS.WhAntepartumRecheck Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RecheckRowId, SqlTableName = WhAntepartumRecheck ]
{

/// WomanRowId
Property WomanRowIdParref As CHSS.WomenBaseInfo;

/// 检查日期
Property CheckDate As %Date;

/// 检查单位
Property CheckUnit As %String(MAXLEN = 60, TRUNCATE = 1);

/// 检查者
Property Checker As %String(MAXLEN = 50, TRUNCATE = 1);

/// 预约日期
Property PreDate As %Date;

/// 尿蛋白
Property UrineProtein As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血红蛋白
Property Hemglobin As %String(MAXLEN = 50, TRUNCATE = 1);

/// 高危评分
Property DangerGradeRowId As CHSS.DictWomenDangerGrade;

/// 孕周
Property PregWeeks As %Numeric;

/// 血压单位
Property BPUnit As CHSS.DictHBPUnit;

/// 收缩压
Property HighPressure As %Numeric;

/// 舒张压
Property LowPressure As %Numeric;

/// 体重
Property Weight As %Float;

/// 宫高
Property WombHeight As %Float;

/// 腹围
Property AbdomenGirth As %Float;

/// 胎位
Property FetusPosition As %String(MAXLEN = 60, TRUNCATE = 1);

/// 胎心
Property FetusCentre As %String(MAXLEN = 30, TRUNCATE = 1);

/// 先露
Property FirstAppear As %String(MAXLEN = 30, TRUNCATE = 1);

/// 水种
Property Gedema As %String(MAXLEN = 50, TRUNCATE = 1);

/// 保健指导
Property OtherDeal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 相关检查
Property OtherCheck As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转诊指征
Property TransferAdvice As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主诉
Property Chiefcomplaint As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胎心率
Property FHR As %String(MAXLEN = 30, TRUNCATE = 1);

/// 分类异常
Property bClassAbnormity As %String(MAXLEN = 5, TRUNCATE = 1);

/// 分类异常情况
Property ClassAbnormityInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否转诊
Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 转诊原因
Property TransferReason As %String(MAXLEN = 60, TRUNCATE = 1);

/// 转诊科室
Property TransferDept As %String(MAXLEN = 50, TRUNCATE = 1);

Index WomanRowIdParrefIndex On WomanRowIdParref;

Storage Default
{
<Data name="WhAntepartumRecheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ABO</Value>
</Value>
<Value name="3">
<Value>AFP</Value>
</Value>
<Value name="4">
<Value>AbPregDes</Value>
</Value>
<Value name="5">
<Value>AbPregResult</Value>
</Value>
<Value name="6">
<Value>AbortionNum</Value>
</Value>
<Value name="7">
<Value>AccessaryTumour</Value>
</Value>
<Value name="8">
<Value>AccessaryTumourDes</Value>
</Value>
<Value name="9">
<Value>BMI</Value>
</Value>
<Value name="10">
<Value>BearingNum</Value>
</Value>
<Value name="11">
<Value>BlPressureUnit</Value>
</Value>
<Value name="12">
<Value>CDangerDes</Value>
</Value>
<Value name="13">
<Value>Cervicitis</Value>
</Value>
<Value name="14">
<Value>CervicitisDes</Value>
</Value>
<Value name="15">
<Value>CheckDate</Value>
</Value>
<Value name="16">
<Value>CheckUnit</Value>
</Value>
<Value name="17">
<Value>Compare</Value>
</Value>
<Value name="18">
<Value>CompareDes</Value>
</Value>
<Value name="19">
<Value>DangerGrade</Value>
</Value>
<Value name="20">
<Value>DateOfFirstCheck</Value>
</Value>
<Value name="21">
<Value>DoubleWombs</Value>
</Value>
<Value name="22">
<Value>DoubleWombsDes</Value>
</Value>
<Value name="23">
<Value>EstimateBDate</Value>
</Value>
<Value name="24">
<Value>FCWeekforPreg</Value>
</Value>
<Value name="25">
<Value>FVTADDate</Value>
</Value>
<Value name="26">
<Value>FinishTable</Value>
</Value>
<Value name="27">
<Value>GPTALT</Value>
</Value>
<Value name="28">
<Value>GPTALTAbDes</Value>
</Value>
<Value name="29">
<Value>HBsAg</Value>
</Value>
<Value name="30">
<Value>HIVResult</Value>
</Value>
<Value name="31">
<Value>Heart</Value>
</Value>
<Value name="32">
<Value>HeartAbDes</Value>
</Value>
<Value name="33">
<Value>Height</Value>
</Value>
<Value name="34">
<Value>Hemoglobin</Value>
</Value>
<Value name="35">
<Value>HighBlPressure</Value>
</Value>
<Value name="36">
<Value>LastEmmeniaDate</Value>
</Value>
<Value name="37">
<Value>LiverFunction</Value>
</Value>
<Value name="38">
<Value>LowBlPressure</Value>
</Value>
<Value name="39">
<Value>LuesResult</Value>
</Value>
<Value name="40">
<Value>Lung</Value>
</Value>
<Value name="41">
<Value>LungAbDes</Value>
</Value>
<Value name="42">
<Value>MisbirthDate</Value>
</Value>
<Value name="43">
<Value>NaAbortionNum</Value>
</Value>
<Value name="44">
<Value>OperateTime</Value>
</Value>
<Value name="45">
<Value>Operator</Value>
</Value>
<Value name="46">
<Value>OpsBearingNum</Value>
</Value>
<Value name="47">
<Value>OtherCheckDes</Value>
</Value>
<Value name="48">
<Value>OtherGynecologyDes</Value>
</Value>
<Value name="49">
<Value>OtherPregHis</Value>
</Value>
<Value name="50">
<Value>PreDate</Value>
</Value>
<Value name="51">
<Value>PregnancyNum</Value>
</Value>
<Value name="52">
<Value>PrematureLaborNum</Value>
</Value>
<Value name="53">
<Value>RenalFunction</Value>
</Value>
<Value name="54">
<Value>Suggestion</Value>
</Value>
<Value name="55">
<Value>UrineProtein</Value>
</Value>
<Value name="56">
<Value>UrineSugar</Value>
</Value>
<Value name="57">
<Value>UterineFibroids</Value>
</Value>
<Value name="58">
<Value>UterineFibroidsDes</Value>
</Value>
<Value name="59">
<Value>VaginaInflammation</Value>
</Value>
<Value name="60">
<Value>VaginaInflammationDes</Value>
</Value>
<Value name="61">
<Value>VaginalDischarge</Value>
</Value>
<Value name="62">
<Value>Weight</Value>
</Value>
<Value name="63">
<Value>WomanRowIdParref</Value>
</Value>
<Value name="64">
<Value>AbdomenGirth</Value>
</Value>
<Value name="65">
<Value>BPUnit</Value>
</Value>
<Value name="66">
<Value>Checker</Value>
</Value>
<Value name="67">
<Value>DangerGradeRowId</Value>
</Value>
<Value name="68">
<Value>FetusCentre</Value>
</Value>
<Value name="69">
<Value>FetusPosition</Value>
</Value>
<Value name="70">
<Value>FirstAppear</Value>
</Value>
<Value name="71">
<Value>Gedema</Value>
</Value>
<Value name="72">
<Value>HemglobinRowId</Value>
</Value>
<Value name="73">
<Value>HighPressure</Value>
</Value>
<Value name="74">
<Value>LowPressure</Value>
</Value>
<Value name="75">
<Value>OtherCheck</Value>
</Value>
<Value name="76">
<Value>OtherDeal</Value>
</Value>
<Value name="77">
<Value>PregWeeks</Value>
</Value>
<Value name="78">
<Value>Remark</Value>
</Value>
<Value name="79">
<Value>TransferAdvice</Value>
</Value>
<Value name="80">
<Value>UrineProteinRowId</Value>
</Value>
<Value name="81">
<Value>WombHeight</Value>
</Value>
<Value name="82">
<Value>Hemglobin</Value>
</Value>
<Value name="83">
<Value>Chiefcomplaint</Value>
</Value>
<Value name="84">
<Value>ClassAbnormityInfo</Value>
</Value>
<Value name="85">
<Value>FHR</Value>
</Value>
<Value name="86">
<Value>TransferDept</Value>
</Value>
<Value name="87">
<Value>TransferReason</Value>
</Value>
<Value name="88">
<Value>bClassAbnormity</Value>
</Value>
<Value name="89">
<Value>bTransfer</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhAntepartumRecheckD</DataLocation>
<DefaultData>WhAntepartumRecheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhAntepartumRecheckD</IdLocation>
<IndexLocation>^CHSS.WhAntepartumRecheckI</IndexLocation>
<StreamLocation>^CHSS.WhAntepartumRecheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
