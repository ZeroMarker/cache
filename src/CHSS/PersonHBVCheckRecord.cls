Class CHSS.PersonHBVCheckRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HBVCheckRowId, SqlTableName = PersonHBVCheckRecord ]
{

/// 个人档案外键
Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

/// 随访日期
Property DateCheck As %Date;

/// 随访地点
Property CheckAdd As %String(MAXLEN = 100, TRUNCATE = 1);

/// 随访医生
Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

/// 录入人员 隐藏字段从session中取
Property StaffInput As User.SSUser;

/// 症状
Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他症状
Property OtherSymptom As %String(MAXLEN = 60, TRUNCATE = 1);

/// 体温
Property Temperature As %Float;

/// 呼吸
Property Breath As %Numeric;

/// 脉搏
Property Pulse As %Numeric;

/// 收缩压
Property nHighPressure As %Numeric;

/// 舒张压
Property nLowPressure As %Numeric;

/// 体重(kg)
Property Weight As %Float;

/// 身高（cm）
Property Height As %Float;

/// BMI(自动计算)
Property BMI As %Float;

/// 臀围
Property Saddle As %Float;

/// 腰围
Property Waist As %Float;

/// 腰围/臀围
Property WaistlineAndSaddle As %Float;

/// 空腹血糖
Property BloodSurgeLimosis As %String(MAXLEN = 10, TRUNCATE = 1);

/// 餐后血糖
Property BloodAfterDining As %String(MAXLEN = 10, TRUNCATE = 1);

/// 餐后两小时血糖
Property BloodAfterDiningOfTwo As %String(MAXLEN = 10, TRUNCATE = 1);

/// HbsAg
Property HbsAg As CHSS.DictHBVTag;

/// HbsAb 
Property HbsAb As CHSS.DictHBVTag;

/// 其他
Property Other As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否吸烟
Property Smoke As %String(MAXLEN = 5, TRUNCATE = 1);

/// 吸烟量
Property DCSC As %Float;

/// 是否饮酒
Property Drink As %String(MAXLEN = 5, TRUNCATE = 1);

/// 饮酒量
Property DPAC As %Float;

/// 是否锻炼
Property IsExercise As %String(MAXLEN = 5, TRUNCATE = 1);

/// 锻炼频率
Property TimesOfExercise As %Numeric;

/// 每次锻炼时间
Property DateOfExercisePer As %Numeric;

/// 营养
Property Nutrition As CHSS.DictRationality;

/// 环境
Property Entironment As CHSS.DictRationality;

/// 心理调整
Property MentalityAdjust As CHSS.DictMentalityAdjust;

/// 遵医行为
Property ComplyDoctor As CHSS.DictComplyDoctor;

/// 其他相关检查
Property OtherCheckResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用药规律
Property DrugRegularityRate As CHSS.DictDrugRegularityRate;

/// 服药依从性
Property DoseComplier As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否有药物不良反应
Property bDrugAdverseReaction As %String(MAXLEN = 5, TRUNCATE = 1);

/// 不良反应药物
Property AdverseReactionDrugs As %String(MAXLEN = 60, TRUNCATE = 1);

/// 是否转科
Property bTranfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 转诊科室
Property TransferDept As User.CTLoc;

/// 转诊原因
Property TransferReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否下次预约
Property bBooking As %String(MAXLEN = 5, TRUNCATE = 1);

/// 下次预约日期
Property BookingDate As %Date;

Index PersonRowIdParrefIndex On PersonRowIdParref;

Storage Default
{
<Data name="PersonHBVCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdverseReactionDrugs</Value>
</Value>
<Value name="3">
<Value>BMI</Value>
</Value>
<Value name="4">
<Value>BloodAfterDining</Value>
</Value>
<Value name="5">
<Value>BloodAfterDiningOfTwo</Value>
</Value>
<Value name="6">
<Value>BloodSurgeLimosis</Value>
</Value>
<Value name="7">
<Value>BookingDate</Value>
</Value>
<Value name="8">
<Value>Breath</Value>
</Value>
<Value name="9">
<Value>CheckAdd</Value>
</Value>
<Value name="10">
<Value>CheckDoctor</Value>
</Value>
<Value name="11">
<Value>ComplyDoctor</Value>
</Value>
<Value name="12">
<Value>DCSC</Value>
</Value>
<Value name="13">
<Value>DPAC</Value>
</Value>
<Value name="14">
<Value>DateCheck</Value>
</Value>
<Value name="15">
<Value>DateOfExercisePer</Value>
</Value>
<Value name="16">
<Value>DoseComplier</Value>
</Value>
<Value name="17">
<Value>Drink</Value>
</Value>
<Value name="18">
<Value>DrugRegularityRate</Value>
</Value>
<Value name="19">
<Value>Entironment</Value>
</Value>
<Value name="20">
<Value>HBsAg</Value>
</Value>
<Value name="21">
<Value>HbsAb</Value>
</Value>
<Value name="22">
<Value>Height</Value>
</Value>
<Value name="23">
<Value>IsExercise</Value>
</Value>
<Value name="24">
<Value>MentalityAdjust</Value>
</Value>
<Value name="25">
<Value>Nutrition</Value>
</Value>
<Value name="26">
<Value>Other</Value>
</Value>
<Value name="27">
<Value>OtherCheckResult</Value>
</Value>
<Value name="28">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="29">
<Value>Pulse</Value>
</Value>
<Value name="30">
<Value>Saddle</Value>
</Value>
<Value name="31">
<Value>Smoke</Value>
</Value>
<Value name="32">
<Value>StaffInput</Value>
</Value>
<Value name="33">
<Value>Symptom</Value>
</Value>
<Value name="34">
<Value>Temperature</Value>
</Value>
<Value name="35">
<Value>TimesOfExercise</Value>
</Value>
<Value name="36">
<Value>TransferDept</Value>
</Value>
<Value name="37">
<Value>TransferReason</Value>
</Value>
<Value name="38">
<Value>Waist</Value>
</Value>
<Value name="39">
<Value>WaistlineAndSaddle</Value>
</Value>
<Value name="40">
<Value>Weight</Value>
</Value>
<Value name="41">
<Value>bBooking</Value>
</Value>
<Value name="42">
<Value>bDrugAdverseReaction</Value>
</Value>
<Value name="43">
<Value>bTranfer</Value>
</Value>
<Value name="44">
<Value>nHighPressure</Value>
</Value>
<Value name="45">
<Value>nLowPressure</Value>
</Value>
<Value name="46">
<Value>HbsAg</Value>
</Value>
<Value name="47">
<Value>OtherSymptom</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHBVCheckRecordD</DataLocation>
<DefaultData>PersonHBVCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHBVCheckRecordD</IdLocation>
<IndexLocation>^CHSS.PersonHBVCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonHBVCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
