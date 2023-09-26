Class CHSSWeb.HISInterface.WomenAfterCheckInfo Extends %Persistent
{

/// WomanRowId
Property WomanRowId As %Integer;

/// VisitRowId
Property VisitRowId As %Integer;

/// 检查日期
Property CheckDate As %Date;

/// 检查单位
Property CheckUnit As %String(MAXLEN = 60, TRUNCATE = 1);

/// 检查者
Property Checker As %String(MAXLEN = 50, TRUNCATE = 1);

/// 一般检查
Property GeneralCheck As %String(MAXLEN = 100, TRUNCATE = 1);

/// 收缩压
Property HighPressure As %Numeric;

/// 舒张压
Property LowPressure As %Numeric;

/// 体重
Property Weight As %Float;

/// 乳房
Property Brest As %String(MAXLEN = 50, TRUNCATE = 1);

/// 子宫
Property Uterus As %String(MAXLEN = 50, TRUNCATE = 1);

/// 恶露
Property Lochia As %String(MAXLEN = 50, TRUNCATE = 1);

/// 伤口
Property Wound As %String(MAXLEN = 50, TRUNCATE = 1);

/// 其他检查
Property OtherCheck As %String(MAXLEN = 50, TRUNCATE = 1);

/// 一般指导
Property GeneralGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 心理及卫生指导
Property PsychologyGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 营养指导
Property NutritionGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 母乳喂养指导
Property BreastFeedingGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体温
Property Temperature As %Float;

/// 一般心理状况
Property Psychologic As %String(MAXLEN = 100, TRUNCATE = 1);

/// 预约日期
Property PreDate As %Date;

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
<Data name="WomenAfterCheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BreastFeedingGuid</Value>
</Value>
<Value name="3">
<Value>Brest</Value>
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
<Value>ClassAbnormityInfo</Value>
</Value>
<Value name="8">
<Value>GeneralCheck</Value>
</Value>
<Value name="9">
<Value>GeneralGuid</Value>
</Value>
<Value name="10">
<Value>HighPressure</Value>
</Value>
<Value name="11">
<Value>Lochia</Value>
</Value>
<Value name="12">
<Value>LowPressure</Value>
</Value>
<Value name="13">
<Value>NutritionGuid</Value>
</Value>
<Value name="14">
<Value>OtherCheck</Value>
</Value>
<Value name="15">
<Value>PreDate</Value>
</Value>
<Value name="16">
<Value>Psychologic</Value>
</Value>
<Value name="17">
<Value>PsychologyGuid</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>Temperature</Value>
</Value>
<Value name="20">
<Value>TransferDept</Value>
</Value>
<Value name="21">
<Value>TransferReason</Value>
</Value>
<Value name="22">
<Value>Uterus</Value>
</Value>
<Value name="23">
<Value>VisitRowId</Value>
</Value>
<Value name="24">
<Value>Weight</Value>
</Value>
<Value name="25">
<Value>WomanRowId</Value>
</Value>
<Value name="26">
<Value>Wound</Value>
</Value>
<Value name="27">
<Value>bClassAbnormity</Value>
</Value>
<Value name="28">
<Value>bTransfer</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenAfterCh762D</DataLocation>
<DefaultData>WomenAfterCheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenAfterCh762D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenAfterCh762I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenAfterCh762S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
