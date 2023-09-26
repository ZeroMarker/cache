Class CHSS.ElerlyHealthCheckRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CheckRowId, SqlTableName = ElerlyHealthCheckRecord ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 随访日期
Property DateCheck As %Date;

/// 随访地点
Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

/// 随访医生
Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

/// 录入人员
Property StaffInput As User.SSUser;

/// 录入时间
Property DateOfInput As %Date;

/// 更新日期
Property DateOfUpdate As %Date;

/// 下次随访目标
Property TargetOfNextCheck As %String(MAXLEN = 60, TRUNCATE = 1);

/// 下次预约日期
Property BookingDate As %Date;

/// 是否下次预约
Property bBooking As %String(MAXLEN = 5, TRUNCATE = 1);

/// 症状
Property Symptom As CHSS.DictSymptomType;

/// 新症状
Property NewSymptom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 原症状持续
Property OlsSymptom As %String(MAXLEN = 100, TRUNCATE = 1);

/// 精神状况
Property MentalStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 心理状态是否良好
Property PsychologyStatus As CHSS.DictPsychologyStatus;

/// 收缩压
Property HighPressure As %Numeric;

/// 舒张压
Property LowPressure As %Numeric;

/// 心率
Property HeartRate As %Numeric;

/// 体重
Property Weight As %Float;

/// 身高
Property Height As %Float;

/// BMI(自动计算)
Property BMI As %Float;

/// 饮食
Property Food As CHSS.DictElderFood;

/// 心里调整
Property MentalityAdjust As %String(MAXLEN = 50, TRUNCATE = 1);

/// 接受知识教育
Property EduKnowledge As %String(MAXLEN = 100, TRUNCATE = 1);

/// 预防目的
Property EduKnowledgeAim As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否吸烟
Property bSmoke As %String(MAXLEN = 5, TRUNCATE = 1);

/// 吸烟
Property Smoke As %String(MAXLEN = 20, TRUNCATE = 1);

/// 平均每天吸烟量
Property SmokeNum As %Integer;

/// 戒烟日期
Property DateOfStopSmoke As %Date;

/// 是否饮酒
Property bDrink As %String(MAXLEN = 5, TRUNCATE = 1);

/// 饮酒
Property Drink As %String(MAXLEN = 20, TRUNCATE = 1);

/// 平均每天饮酒量
Property DrinkQuentity As %Float;

/// 戒酒日期
Property DateOfStopDrink As %Date;

/// 运动
Property Exercise As %String(MAXLEN = 20, TRUNCATE = 1);

/// 规律用药
Property DrugRegularity As CHSS.DictDrugRegularityRate;

/// 用药
Property EatDrug As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体育锻炼
Property ExerciseNum As %Numeric;

/// 每天锻炼时间
Property ExerciseMin As %Numeric;

/// 餐后血糖
Property BloodAfterDining As %String(MAXLEN = 10, TRUNCATE = 1);

/// 餐后两小时血糖
Property BloodAfterDiningOfTwo As %String(MAXLEN = 10, TRUNCATE = 1);

/// 空腹血糖
Property BloodSurgeLimosis As %String(MAXLEN = 10, TRUNCATE = 1);

/// 是否无不适
Property NoComplaints As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否需要转诊
Property NeedTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 心理指导
Property PsychologyOfCoaching As %String(MAXLEN = 50, TRUNCATE = 1);

/// 可疑抑郁
Property Drepress As %String(MAXLEN = 50, TRUNCATE = 1);

/// 遵医行为
Property ComplyDoctor As CHSS.DictComplyDoctor;

/// 疫苗接种
Property GiveVaccination As %String(MAXLEN = 80, TRUNCATE = 1);

/// 冠心病预防
Property DefendOfCoronary As %String(MAXLEN = 80, TRUNCATE = 1);

/// 骨质酥松预防
Property DefendOfOsteoporosis As %String(MAXLEN = 80, TRUNCATE = 1);

/// 病例种类
Property CaseType As CHSS.DictElderCaseType;

/// 眼底检查
Property EyegroundCheck As CHSS.DictEyegroundCheck;

/// 转诊科别
Property TransferEachOther As %String(MAXLEN = 60, TRUNCATE = 1);

/// 转诊原因
Property TransferReason As %String(MAXLEN = 60, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="ElerlyHealthCheckRecordDefaultData">
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
<Value>CaseType</Value>
</Value>
<Value name="8">
<Value>CheckAdd</Value>
</Value>
<Value name="9">
<Value>CheckDoctor</Value>
</Value>
<Value name="10">
<Value>ComplyDoctor</Value>
</Value>
<Value name="11">
<Value>DateCheck</Value>
</Value>
<Value name="12">
<Value>DateOfInput</Value>
</Value>
<Value name="13">
<Value>DateOfStopDrink</Value>
</Value>
<Value name="14">
<Value>DateOfStopSmoke</Value>
</Value>
<Value name="15">
<Value>DateOfUpdate</Value>
</Value>
<Value name="16">
<Value>DefendOfCoronary</Value>
</Value>
<Value name="17">
<Value>DefendOfOsteoporosis</Value>
</Value>
<Value name="18">
<Value>Drepress</Value>
</Value>
<Value name="19">
<Value>Drink</Value>
</Value>
<Value name="20">
<Value>DrinkQuentity</Value>
</Value>
<Value name="21">
<Value>DrugRegularity</Value>
</Value>
<Value name="22">
<Value>EatDrug</Value>
</Value>
<Value name="23">
<Value>EduKnowledge</Value>
</Value>
<Value name="24">
<Value>EduKnowledgeAim</Value>
</Value>
<Value name="25">
<Value>Exercise</Value>
</Value>
<Value name="26">
<Value>ExerciseMin</Value>
</Value>
<Value name="27">
<Value>ExerciseNum</Value>
</Value>
<Value name="28">
<Value>EyegroundCheck</Value>
</Value>
<Value name="29">
<Value>Food</Value>
</Value>
<Value name="30">
<Value>GiveVaccination</Value>
</Value>
<Value name="31">
<Value>HeartRate</Value>
</Value>
<Value name="32">
<Value>Height</Value>
</Value>
<Value name="33">
<Value>HighPressure</Value>
</Value>
<Value name="34">
<Value>LowPressure</Value>
</Value>
<Value name="35">
<Value>MentalStatus</Value>
</Value>
<Value name="36">
<Value>MentalityAdjust</Value>
</Value>
<Value name="37">
<Value>NeedTransfer</Value>
</Value>
<Value name="38">
<Value>NewSymptom</Value>
</Value>
<Value name="39">
<Value>NoComplaints</Value>
</Value>
<Value name="40">
<Value>OlsSymptom</Value>
</Value>
<Value name="41">
<Value>PersonRowId</Value>
</Value>
<Value name="42">
<Value>PsychologyOfCoaching</Value>
</Value>
<Value name="43">
<Value>PsychologyStatus</Value>
</Value>
<Value name="44">
<Value>Smoke</Value>
</Value>
<Value name="45">
<Value>SmokeNum</Value>
</Value>
<Value name="46">
<Value>StaffInput</Value>
</Value>
<Value name="47">
<Value>Symptom</Value>
</Value>
<Value name="48">
<Value>TargetOfNextCheck</Value>
</Value>
<Value name="49">
<Value>TransferEachOther</Value>
</Value>
<Value name="50">
<Value>TransferReason</Value>
</Value>
<Value name="51">
<Value>Weight</Value>
</Value>
<Value name="52">
<Value>bBooking</Value>
</Value>
<Value name="53">
<Value>bDrink</Value>
</Value>
<Value name="54">
<Value>bSmoke</Value>
</Value>
</Data>
<DataLocation>^CHSS.ElerlyHealthCheckRecordD</DataLocation>
<DefaultData>ElerlyHealthCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ElerlyHealthCheckRecordD</IdLocation>
<IndexLocation>^CHSS.ElerlyHealthCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.ElerlyHealthCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
