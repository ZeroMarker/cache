Class CHSS.WhAfter42DaysRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = VisitRowId, SqlTableName = WhAfter42DaysRecord ]
{

/// WomanRowId
Property WomanRowId As CHSS.WomenBaseInfo;

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

/// 计划生育指导	
Property BirthControlGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 心理及卫生指导
Property PsychologyGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 营养指导
Property NutritionGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 坚持纯母乳喂养6个月
Property BreastFeedingGuid As %String(MAXLEN = 50, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一般心理状况
Property Psychologic As %String(MAXLEN = 100, TRUNCATE = 1);

/// 分类异常
Property bClassAbnormity As %String(MAXLEN = 10, TRUNCATE = 1);

/// 分类异常情况
Property ClassAbnormityInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否转诊
Property bTransfer As %String(MAXLEN = 10, TRUNCATE = 1);

/// 转诊原因
Property TransferReason As %String(MAXLEN = 60, TRUNCATE = 1);

/// 转诊科室
Property TransferDept As %String(MAXLEN = 50, TRUNCATE = 1);

Index WomanRowIdIndex On WomanRowId [ Unique ];

Storage Default
{
<Data name="WhAfter42DaysRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BirthControlGuid</Value>
</Value>
<Value name="3">
<Value>BreastFeedingGuid</Value>
</Value>
<Value name="4">
<Value>Brest</Value>
</Value>
<Value name="5">
<Value>CheckDate</Value>
</Value>
<Value name="6">
<Value>CheckUnit</Value>
</Value>
<Value name="7">
<Value>Checker</Value>
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
<Value>PsychologyGuid</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>Uterus</Value>
</Value>
<Value name="18">
<Value>Weight</Value>
</Value>
<Value name="19">
<Value>WomanRowId</Value>
</Value>
<Value name="20">
<Value>Wound</Value>
</Value>
<Value name="21">
<Value>ClassAbnormityInfo</Value>
</Value>
<Value name="22">
<Value>Psychologic</Value>
</Value>
<Value name="23">
<Value>TransferDept</Value>
</Value>
<Value name="24">
<Value>TransferReason</Value>
</Value>
<Value name="25">
<Value>bClassAbnormity</Value>
</Value>
<Value name="26">
<Value>bTransfer</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhAfter42DaysRecordD</DataLocation>
<DefaultData>WhAfter42DaysRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhAfter42DaysRecordD</IdLocation>
<IndexLocation>^CHSS.WhAfter42DaysRecordI</IndexLocation>
<StreamLocation>^CHSS.WhAfter42DaysRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
