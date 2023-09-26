Class CHSSWeb.HISInterface.WomenAntepartumRecheckInfo Extends %Persistent
{

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
Property DangerGradeRowId As %Integer;

Property DangerGradeName As %String;

/// 孕周
Property PregWeeks As %Numeric;

/// 血压单位
Property BPUnit As %Integer;

Property BPUnitName As %String;

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

Storage Default
{
<Data name="WomenAntepartumRecheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AbdomenGirth</Value>
</Value>
<Value name="3">
<Value>BPUnit</Value>
</Value>
<Value name="4">
<Value>CheckDate</Value>
</Value>
<Value name="5">
<Value>CheckUnit</Value>
</Value>
<Value name="6">
<Value>Checker</Value>
</Value>
<Value name="7">
<Value>Chiefcomplaint</Value>
</Value>
<Value name="8">
<Value>ClassAbnormityInfo</Value>
</Value>
<Value name="9">
<Value>DangerGradeRowId</Value>
</Value>
<Value name="10">
<Value>FHR</Value>
</Value>
<Value name="11">
<Value>FetusCentre</Value>
</Value>
<Value name="12">
<Value>FetusPosition</Value>
</Value>
<Value name="13">
<Value>FirstAppear</Value>
</Value>
<Value name="14">
<Value>Gedema</Value>
</Value>
<Value name="15">
<Value>Hemglobin</Value>
</Value>
<Value name="16">
<Value>HighPressure</Value>
</Value>
<Value name="17">
<Value>LowPressure</Value>
</Value>
<Value name="18">
<Value>OtherCheck</Value>
</Value>
<Value name="19">
<Value>OtherDeal</Value>
</Value>
<Value name="20">
<Value>PreDate</Value>
</Value>
<Value name="21">
<Value>PregWeeks</Value>
</Value>
<Value name="22">
<Value>Remark</Value>
</Value>
<Value name="23">
<Value>TransferAdvice</Value>
</Value>
<Value name="24">
<Value>TransferDept</Value>
</Value>
<Value name="25">
<Value>TransferReason</Value>
</Value>
<Value name="26">
<Value>UrineProtein</Value>
</Value>
<Value name="27">
<Value>Weight</Value>
</Value>
<Value name="28">
<Value>WomanRowId</Value>
</Value>
<Value name="29">
<Value>WombHeight</Value>
</Value>
<Value name="30">
<Value>bClassAbnormity</Value>
</Value>
<Value name="31">
<Value>bTransfer</Value>
</Value>
<Value name="32">
<Value>BPUnitName</Value>
</Value>
<Value name="33">
<Value>DangerGradeName</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenAnteparA68D</DataLocation>
<DefaultData>WomenAntepartumRecheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenAnteparA68D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenAnteparA68I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenAnteparA68S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
