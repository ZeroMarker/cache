Class CHSS.WomenFirstCheck Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = FirstCheckRowId, SqlTableName = WomenFirstCheck ]
{

/// ﻿妇女基本信息主键
Property WomanRowIdParref As CHSS.WomenBaseInfo [ Required ];

/// 检查单位
Property CheckUnit As %String(MAXLEN = 50, TRUNCATE = 1);

/// 检查单位级别
/// Property CheckUnitRank;
/// 检查日期
Property CheckDate As %Date;

/// 填表人
Property FinishTable As %String(MAXLEN = 50, TRUNCATE = 1);

/// 录入人
Property Operator As User.SSUser;

/// 录入日期
Property OperateTime As %Date;

/// 初诊日期
Property FVTADDate As %Date;

/// 末次月经开始日期
Property LastEmmeniaDate As %Date;

/// 首次尿妊免阳性日期
/// Property FNoPosPregDate As %Date;
/// 初检孕周
Property FCWeekforPreg As %Integer;

/// 预产期
Property EstimateBDate As %Date;

/// 孕次
Property PregnancyNum As %Integer;

/// 产次
Property BearingNum As %Integer;

/// 早产次数
Property PrematureLaborNum As %Integer;

/// 手术产次数
Property OpsBearingNum As %Integer;

/// 自然流产次数
Property NaAbortionNum As %Integer;

/// 人工流产次数
Property AbortionNum As %Integer;

/// 其他孕产史
Property OtherPregHis As %String(MAXLEN = 100, TRUNCATE = 1);

/// 本次妊娠早孕期异常情况
Property AbPregDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 第一次产前检查日期
Property DateOfFirstCheck As %Date;

/// 血压单位
Property BlPressureUnit As CHSS.DictHBPUnit;

/// 收缩压
Property HighBlPressure As %Integer;

/// 舒张压
Property LowBlPressure As %Integer;

/// 身高
Property Height As %Float;

/// 体重
Property Weight As %Float;

/// BMI
Property BMI As %Float;

/// 心脏
Property Heart As CHSS.DictHeartCheckResult;

/// 心脏异常详述
Property HeartAbDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 肺部
Property Lung As CHSS.DictHeartCheckResult;

/// 肺部异常详述
Property LungAbDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 阴道炎
Property VaginaInflammation As CHSS.DictWomenCheck;

/// 阴道炎详述
Property VaginaInflammationDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 宫颈炎
Property Cervicitis As CHSS.DictWomenCheck;

/// 宫颈炎详述
Property CervicitisDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 双阴道, 双子宫
Property DoubleWombs As CHSS.DictWomenCheck;

/// 双阴道, 双子宫详述
Property DoubleWombsDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 子宫肌瘤
Property UterineFibroids As CHSS.DictWomenCheck;

/// 子宫肌瘤详述
Property UterineFibroidsDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 附件肿物
Property AccessaryTumour As CHSS.DictWomenCheck;

/// 附件肿物详述
Property AccessaryTumourDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 妇科检查其它详述
Property OtherGynecologyDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子宫大小与孕周相符
Property Compare As %String(MAXLEN = 5, TRUNCATE = 1);

/// 子宫大小与孕周不符详述
Property CompareDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血红蛋白
Property Hemoglobin As %String(MAXLEN = 10, TRUNCATE = 1);

/// 尿蛋白
Property UrineProtein As %String(MAXLEN = 10, TRUNCATE = 1);

/// 尿糖
Property UrineSugar As %String(MAXLEN = 10, TRUNCATE = 1);

/// 甲胎蛋白
Property AFP As CHSS.DictHeartCheckResult;

/// GPT或ALT
Property GPTALT As CHSS.DictHeartCheckResult;

/// GPT或ALT异常详述
Property GPTALTAbDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 肝功能
Property LiverFunction As %String(MAXLEN = 50, TRUNCATE = 1);

/// 肾功能
Property RenalFunction As %String(MAXLEN = 50, TRUNCATE = 1);

/// 白带
Property VaginalDischarge As %String(MAXLEN = 50, TRUNCATE = 1);

/// 乙肝病毒表面抗原
Property HBsAg As CHSS.DictHBVTag;

/// 血型
Property ABO As User.PACBloodType;

/// 梅毒筛查结果
Property LuesResult As CHSS.DictHBVTag;

/// HIV结果
Property HIVResult As CHSS.DictHBVTag;

/// 其它检查详述
Property OtherCheckDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 高危评分分级
Property DangerGrade As CHSS.DictWomenDangerGrade;

/// 一般高危详述
Property CDangerDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 异常妊娠结局
Property AbPregResult As CHSS.DictWomenAbPregResult;

/// 终止异常妊娠日期
Property MisbirthDate As %Date;

/// 处理及建议
Property Suggestion As %String(MAXLEN = 100, TRUNCATE = 1);

/// 预约日期
Property PreDate As %Date;

/// 既往史
Property PastHistory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家族史
Property FamilyHistory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 死胎
Property DyingFetus As %Numeric;

/// 死产
Property StillBirth As %Numeric;

/// 新生儿死亡
Property NeonatalDeath As %Numeric;

/// 血细胞计数值
Property HemocytesNum As %Float;

/// 血小板计数值
Property PLTNum As %Float;

/// 血常规其他
Property BloodRoutineOther As %String(MAXLEN = 50, TRUNCATE = 1);

/// 尿常规其他
Property URTOther As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血清丙谷转氨酶
Property GPT As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血清谷草转氨酶
Property AST As %String(MAXLEN = 50, TRUNCATE = 1);

/// 白蛋白
Property ALB As %String(MAXLEN = 50, TRUNCATE = 1);

/// 总胆红素
Property TB As %String(MAXLEN = 50, TRUNCATE = 1);

/// 结合胆红素
Property DBIL As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血清肌酐
Property Cr As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血尿素氮
Property BUN As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血钾浓度
Property Sk As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血钠浓度
Property Na As %String(MAXLEN = 50, TRUNCATE = 1);

/// 阴道分泌物
Property VaginalFluid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 是否转诊
Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 转诊原因
Property TransferReason As %String(MAXLEN = 60, TRUNCATE = 1);

/// 转诊科室
Property TransferDept As %String(MAXLEN = 50, TRUNCATE = 1);

/// 是否妇科手术史
Property bOPS As %String(MAXLEN = 5, TRUNCATE = 1);

/// 妇科手术史
Property WomenOPS As %String(MAXLEN = 50, TRUNCATE = 1);

/// 尿酮体
Property UrineKetone As %String(MAXLEN = 50, TRUNCATE = 1);

/// 尿潜血
Property BLD As %String(MAXLEN = 50, TRUNCATE = 1);

Index WomanRowIdParrefIndex On WomanRowIdParref [ Unique ];

Storage Default
{
<Data name="WomenFirstCheckDefaultData">
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
<Value>ALB</Value>
</Value>
<Value name="65">
<Value>AST</Value>
</Value>
<Value name="66">
<Value>BLD</Value>
</Value>
<Value name="67">
<Value>BUN</Value>
</Value>
<Value name="68">
<Value>BloodRoutineOther</Value>
</Value>
<Value name="69">
<Value>Cr</Value>
</Value>
<Value name="70">
<Value>DBIL</Value>
</Value>
<Value name="71">
<Value>DyingFetus</Value>
</Value>
<Value name="72">
<Value>FamilyHistory</Value>
</Value>
<Value name="73">
<Value>GPT</Value>
</Value>
<Value name="74">
<Value>HemocytesNum</Value>
</Value>
<Value name="75">
<Value>Na</Value>
</Value>
<Value name="76">
<Value>NeonatalDeath</Value>
</Value>
<Value name="77">
<Value>PLTNum</Value>
</Value>
<Value name="78">
<Value>PastHistory</Value>
</Value>
<Value name="79">
<Value>Sk</Value>
</Value>
<Value name="80">
<Value>StillBirth</Value>
</Value>
<Value name="81">
<Value>TB</Value>
</Value>
<Value name="82">
<Value>TransferDept</Value>
</Value>
<Value name="83">
<Value>TransferReason</Value>
</Value>
<Value name="84">
<Value>URTOther</Value>
</Value>
<Value name="85">
<Value>UrineKetone</Value>
</Value>
<Value name="86">
<Value>VaginalFluid</Value>
</Value>
<Value name="87">
<Value>WomenOPS</Value>
</Value>
<Value name="88">
<Value>bOPS</Value>
</Value>
<Value name="89">
<Value>bTransfer</Value>
</Value>
</Data>
<DataLocation>^CHSS.WomenFirstCheckD</DataLocation>
<DefaultData>WomenFirstCheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WomenFirstCheckD</IdLocation>
<IndexLocation>^CHSS.WomenFirstCheckI</IndexLocation>
<StreamLocation>^CHSS.WomenFirstCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
