Class CHSS.HBPCheckRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = HBPCheckRecord ]
{

/// 外键
Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

/// 随访日期
Property DateCheck As %Date(FORMAT = 1);

/// 复核日期
Property DateOfCheck As %Date(FORMAT = 1);

/// 随访方式
Property CheckType As CHSS.DictCheckType;

/// 随访地点
Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

/// 症状
Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他症状
Property OtherSymptom As %String(MAXLEN = 60, TRUNCATE = 1);

/// 随访医生
Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

/// 收缩压
Property nHighPressure As %Numeric;

/// 舒张压
Property nLowPressure As %Numeric;

/// 心率
Property HeartRate As %Numeric;

/// 其他检查
Property OtherCheck As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体重
Property Weight As %Float;

/// 身高
Property Height As %Float;

/// BMI
Property BMI As %Float;

/// 足背动脉博动
Property FootArteryThrob As %String(MAXLEN = 30, TRUNCATE = 1);

/// 饮食
Property Food As CHSS.DictFood;

/// 戒烟日期
Property DateOfStopSmoke As %Date(FORMAT = 1);

/// 是否吸烟
Property bSmoke As %String(MAXLEN = 5, TRUNCATE = 1);

/// 吸烟
Property Smoke As %String(MAXLEN = 20, TRUNCATE = 1);

/// 每天吸烟量
Property SmokeNum As %Float;

/// 戒酒日期
Property DateOfStopDrink As %Date(FORMAT = 1);

/// 是否饮酒
Property bDrink As %String(MAXLEN = 5, TRUNCATE = 1);

/// 饮酒
Property Drink As %String(MAXLEN = 20, TRUNCATE = 1);

/// 平均每天饮酒量
Property DrinkQuentity As %Float;

/// 运动
Property Exercise As %String(MAXLEN = 20, TRUNCATE = 1);

/// 服药情况
/// Property DoseCondition As CHSS.DictDoseCondition;
/// 其它
Property Other As %String(MAXLEN = 20, TRUNCATE = 1);

/// 腰围/臀围
Property WaistlineStern As %Float;

/// 下次预约日期
Property BookingDate As %Date(FORMAT = 1);

/// 是否下次预约
Property bBooking As %String(MAXLEN = 5, TRUNCATE = 1);

/// 体育锻炼
Property ExerciseNum As %Float;

/// 每天锻炼时间
Property ExerciseMin As %Float;

/// 药物毒副作用
Property DrugSideEffect As %String(MAXLEN = 40, TRUNCATE = 1);

/// 服药依从性
Property DoseComplier As %String(MAXLEN = 40, TRUNCATE = 1);

/// 餐后血糖
Property BloodAfterDining As %String(MAXLEN = 10, TRUNCATE = 1);

/// 餐后两小时血糖
Property BloodAfterDiningOfTwo As %String(MAXLEN = 10, TRUNCATE = 1);

/// 空腹血糖
Property BloodSurgeLimosis As %String(MAXLEN = 10, TRUNCATE = 1);

/// 总胆固醇
Property Cholesterin As %String(MAXLEN = 10, TRUNCATE = 1);

/// 糖化血红蛋白
Property HbAlC As %String(MAXLEN = 10, TRUNCATE = 1);

/// 血其它
Property OtherOfBlood As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血红蛋白
Property Hb As %String(MAXLEN = 10, TRUNCATE = 1);

/// 尿蛋白
Property NAlbumen As %String(MAXLEN = 10, TRUNCATE = 1);

/// 尿其它
Property NOther As %String(MAXLEN = 50, TRUNCATE = 1);

/// 24小时糖定量
Property SugarInDay As %String(MAXLEN = 10, TRUNCATE = 1);

/// 合并症
Property UniteIll As %String(MAXLEN = 10, TRUNCATE = 1);

/// 遵医行为
Property ComplyDoctor As CHSS.DictComplyDoctor;

/// 心里调整
Property MentalityAdjust As CHSS.DictMentalityAdjust;

/// 是否药物不良反应
Property bAdverseEffects As %String(MAXLEN = 5, TRUNCATE = 1);

/// 不良反应药物
Property DrugOfAdverseEffects As %String(MAXLEN = 50, TRUNCATE = 1);

/// 此次随访结果
Property CheckResult As CHSS.DictCheckResult;

/// 用药
Property EatDrug As %String(MAXLEN = 100, TRUNCATE = 1);

/// 指导
Property Direction As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否转科
Property bTranfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 转诊科室	
Property TransferDept As User.CTLoc;

/// 转诊原因
Property TransferReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用药规律	
Property DrugRegularityRate As CHSS.DictDrugRegularityRate;

/// 处理
Property Deal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 录入人员	
Property StaffInput As User.SSUser;

/// 录入时间	
Property DateOfInput As %Date(FORMAT = 1);

/// 更新日期
Property DateOfUpdate As %Date(FORMAT = 1);

/// 危险因素
Property DangerousFactor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 非药物治疗方法
Property NonDrugTherapy As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复核者
Property Checker As %String(MAXLEN = 50, TRUNCATE = 1);

Index PersonRowIdParrefIndex On PersonRowIdParref;

Storage Default
{
<Data name="HBPCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>BloodAfterDining</Value>
</Value>
<Value name="4">
<Value>BloodAfterDiningOfTwo</Value>
</Value>
<Value name="5">
<Value>BloodSurgeLimosis</Value>
</Value>
<Value name="6">
<Value>BookingDate</Value>
</Value>
<Value name="7">
<Value>CheckAdd</Value>
</Value>
<Value name="8">
<Value>CheckDoctor</Value>
</Value>
<Value name="9">
<Value>CheckResult</Value>
</Value>
<Value name="10">
<Value>CheckType</Value>
</Value>
<Value name="11">
<Value>Cholesterin</Value>
</Value>
<Value name="12">
<Value>ComplyDoctor</Value>
</Value>
<Value name="13">
<Value>DateCheck</Value>
</Value>
<Value name="14">
<Value>DateOfInput</Value>
</Value>
<Value name="15">
<Value>DateOfStopDrink</Value>
</Value>
<Value name="16">
<Value>DateOfStopSmoke</Value>
</Value>
<Value name="17">
<Value>DateOfUpdate</Value>
</Value>
<Value name="18">
<Value>Deal</Value>
</Value>
<Value name="19">
<Value>Direction</Value>
</Value>
<Value name="20">
<Value>DoseComplier</Value>
</Value>
<Value name="21">
<Value>Drink</Value>
</Value>
<Value name="22">
<Value>DrinkQuentity</Value>
</Value>
<Value name="23">
<Value>DrugOfAdverseEffects</Value>
</Value>
<Value name="24">
<Value>DrugRegularityRate</Value>
</Value>
<Value name="25">
<Value>DrugSideEffect</Value>
</Value>
<Value name="26">
<Value>EatDrug</Value>
</Value>
<Value name="27">
<Value>Exercise</Value>
</Value>
<Value name="28">
<Value>ExerciseMin</Value>
</Value>
<Value name="29">
<Value>ExerciseNum</Value>
</Value>
<Value name="30">
<Value>Food</Value>
</Value>
<Value name="31">
<Value>FootArteryThrob</Value>
</Value>
<Value name="32">
<Value>Hb</Value>
</Value>
<Value name="33">
<Value>HbAlC</Value>
</Value>
<Value name="34">
<Value>HeartRate</Value>
</Value>
<Value name="35">
<Value>Height</Value>
</Value>
<Value name="36">
<Value>MentalityAdjust</Value>
</Value>
<Value name="37">
<Value>NAlbumen</Value>
</Value>
<Value name="38">
<Value>NOther</Value>
</Value>
<Value name="39">
<Value>Other</Value>
</Value>
<Value name="40">
<Value>OtherCheck</Value>
</Value>
<Value name="41">
<Value>OtherOfBlood</Value>
</Value>
<Value name="42">
<Value>OtherSymptom</Value>
</Value>
<Value name="43">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="44">
<Value>Remark</Value>
</Value>
<Value name="45">
<Value>Smoke</Value>
</Value>
<Value name="46">
<Value>SmokeNum</Value>
</Value>
<Value name="47">
<Value>StaffInput</Value>
</Value>
<Value name="48">
<Value>SugarInDay</Value>
</Value>
<Value name="49">
<Value>Symptom</Value>
</Value>
<Value name="50">
<Value>TransferDept</Value>
</Value>
<Value name="51">
<Value>TransferReason</Value>
</Value>
<Value name="52">
<Value>UniteIll</Value>
</Value>
<Value name="53">
<Value>WaistlineStern</Value>
</Value>
<Value name="54">
<Value>Weight</Value>
</Value>
<Value name="55">
<Value>bAdverseEffects</Value>
</Value>
<Value name="56">
<Value>bBooking</Value>
</Value>
<Value name="57">
<Value>bDrink</Value>
</Value>
<Value name="58">
<Value>bSmoke</Value>
</Value>
<Value name="59">
<Value>bTranfer</Value>
</Value>
<Value name="60">
<Value>nHighPressure</Value>
</Value>
<Value name="61">
<Value>nLowPressure</Value>
</Value>
<Value name="62">
<Value>DangerousFactor</Value>
</Value>
<Value name="63">
<Value>NonDrugTherapy</Value>
</Value>
<Value name="64">
<Value>Checker</Value>
</Value>
<Value name="65">
<Value>DateOfCheck</Value>
</Value>
</Data>
<DataLocation>^CHSS.HBPCheckRecordD</DataLocation>
<DefaultData>HBPCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HBPCheckRecordD</IdLocation>
<IndexLocation>^CHSS.HBPCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.HBPCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
