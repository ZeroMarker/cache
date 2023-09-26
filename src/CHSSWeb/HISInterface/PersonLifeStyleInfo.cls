Class CHSSWeb.HISInterface.PersonLifeStyleInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As %Integer;

Property PersonCode As %String(TRUNCATE = 1);

Property PersonName As %String(TRUNCATE = 1);

Property SexName As %String(TRUNCATE = 1);

Property Birth As %Date;

//Property PersonRowIdParref As %String;

/// 个人档案主键
/// 责任医生
Property DoctorRegister As %String(TRUNCATE = 1);

/// 是否锻炼
Property IsExercise As %String(TRUNCATE = 1);

/// 锻炼频率
Property ExerciseInfoDR As %String(TRUNCATE = 1);

/// 锻炼类型
Property ExerciseTypeDR As %String;

Property ExerciseTypeDRName As %String;

/// 锻炼场所
Property ExercisePlace As %String(TRUNCATE = 1);

Property ExercisePlaceName As %String;

/// 每次锻炼时间
Property DateOfExercisePer As %String(TRUNCATE = 1);

/// 坚持锻炼时间
Property YearOfExercise As %Numeric;

/// 中等强度工作或者家务劳动天数
Property MiddleWorkDays As %String(TRUNCATE = 1);

/// 每天用多少时间
Property TimeOfMiddleWork As %String(TRUNCATE = 1);

/// 中等强度体育锻炼天数
Property MiddleExercise As %String(TRUNCATE = 1);

/// 每天锻炼持续时间
Property TimeOfMiddleExer As %String(TRUNCATE = 1);

/// 气质类型
Property TemperType As %String(TRUNCATE = 1);

/// 社交活动
Property Doings As %String(MAXLEN = 5, TRUNCATE = 1);

/// 睡眠状况
Property SleepStatus As %String(TRUNCATE = 1);

/// 睡眠小时数
Property SleepHour As %Float;

/// 饮食习惯
Property DietHabit As %String(TRUNCATE = 1);

/// 不吃的食物
Property DietNotEat As %String(TRUNCATE = 1);

/// 是否吸烟
Property Smoke As %String(TRUNCATE = 1);

/// 开始吸烟时间
Property DateOfStartSmoke As %Date;

/// 戒烟年数
Property YearsOfEndSmoke As %Integer;

/// 戒烟时间
Property DateOfEndSmoke As %Date;

/// 平均每天支数
Property NumOfSmoke As %Numeric;

/// 吸烟量
Property DCSC As %Float;

/// 是否饮酒
Property Drink As %String(TRUNCATE = 1);

/// 饮酒量
Property DPAC As %Float;

/// 年饮酒量
Property DPACofYear As %String(TRUNCATE = 1);

/// 月饮酒量
Property DPACofMonth As %String(TRUNCATE = 1);

/// 饮酒频率
Property DrinkFrequencyDR As %String(TRUNCATE = 1);

/// 开始饮酒日期
Property DateOfStartDrink As %Date;

/// 开始饮酒年龄
Property AgeOfStartDrink As %Integer;

/// 戒酒日期
Property DateOfEndDrink As %Date;

/// 主要饮酒品种
Property DrinkType As %String(TRUNCATE = 1);

Property DrinkTypeName As %String(TRUNCATE = 1);

/// 是否戒酒
Property bDryOut As %String(TRUNCATE = 1);

/// 戒酒年龄
Property AgeOfEndDrink As %Integer;

/// 精神状况
Property MentalStatus As %String(TRUNCATE = 1);

/// 是否找亲朋倾诉
Property bConfide As %String(TRUNCATE = 1);

/// 是否感到工作或学习压力
Property bFeelPressure As %String(TRUNCATE = 1);

/// 心里状况
Property PsychologicStatus As %String(TRUNCATE = 1);

/// 遵医行为
Property ComplyDoctor As %String(TRUNCATE = 1);

/// 其他习惯
Property OtherCustom As %String(TRUNCATE = 1);

/// 食盐量
Property Salinity As %Float;

/// 饮食次数
Property DietTime As %Integer;

/// 每月一般用油量
Property OilQuantity As %String(TRUNCATE = 1);

/// 吸氧
Property OxygenHour As %Integer;

/// 是否接种流感疫苗
Property FluBacterin As %String(TRUNCATE = 1);

/// 肺炎球菌疫苗
Property Pneumococcus As %String(TRUNCATE = 1);

/// 家中煤火取暖
Property bFamilyCoal As %String(TRUNCATE = 1);

/// 取暖年数
Property FamilyCoalYears As %Numeric;

/// 家中成员吸烟
Property bFamilySmoke As %String(TRUNCATE = 1);

/// 长期居住地
Property PlaceOfResidence As %String(TRUNCATE = 1);

/// 年检日期
Property DateOfYearCheck As %Date;

/// 更新日期
Property DateOfUpdate As %Date;

/// 更新人员
Property StaffOfUpdate As %String(TRUNCATE = 1);

/// 吃含脂肪多的食物天数
Property EatFatDays As %Numeric;

/// 吃油炸食物天数
Property EatDeepFryDays As %Numeric;

/// / 吃腌制食物的天数
Property EatPickleDays As %Numeric;

/// 吃甜食的天数
Property EatSweetmeatDays As %Numeric;

/// 平均每天吃多少水果
Property EatFruitQuantity As %String(TRUNCATE = 1);

/// 饮食喜好
Property FoodFavor As %String(TRUNCATE = 1);

Property FoodFavorValue As %String;

/// 每周几次
Property TimesOfWeekly As %Numeric;

Storage Default
{
<Data name="PersonLifeStyleInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AgeOfEndDrink</Value>
</Value>
<Value name="3">
<Value>AgeOfStartDrink</Value>
</Value>
<Value name="4">
<Value>ComplyDoctor</Value>
</Value>
<Value name="5">
<Value>DCSC</Value>
</Value>
<Value name="6">
<Value>DPAC</Value>
</Value>
<Value name="7">
<Value>DPACofMonth</Value>
</Value>
<Value name="8">
<Value>DPACofYear</Value>
</Value>
<Value name="9">
<Value>DateOfEndDrink</Value>
</Value>
<Value name="10">
<Value>DateOfEndSmoke</Value>
</Value>
<Value name="11">
<Value>DateOfExercisePer</Value>
</Value>
<Value name="12">
<Value>DateOfStartDrink</Value>
</Value>
<Value name="13">
<Value>DateOfStartSmoke</Value>
</Value>
<Value name="14">
<Value>DateOfUpdate</Value>
</Value>
<Value name="15">
<Value>DateOfYearCheck</Value>
</Value>
<Value name="16">
<Value>DietHabit</Value>
</Value>
<Value name="17">
<Value>DietNotEat</Value>
</Value>
<Value name="18">
<Value>DietTime</Value>
</Value>
<Value name="19">
<Value>DoctorRegister</Value>
</Value>
<Value name="20">
<Value>Doings</Value>
</Value>
<Value name="21">
<Value>Drink</Value>
</Value>
<Value name="22">
<Value>DrinkFrequencyDR</Value>
</Value>
<Value name="23">
<Value>DrinkType</Value>
</Value>
<Value name="24">
<Value>DrinkTypeName</Value>
</Value>
<Value name="25">
<Value>EatDeepFryDays</Value>
</Value>
<Value name="26">
<Value>EatFatDays</Value>
</Value>
<Value name="27">
<Value>EatFruitQuantity</Value>
</Value>
<Value name="28">
<Value>EatPickleDays</Value>
</Value>
<Value name="29">
<Value>EatSweetmeatDays</Value>
</Value>
<Value name="30">
<Value>ExerciseInfoDR</Value>
</Value>
<Value name="31">
<Value>ExercisePlace</Value>
</Value>
<Value name="32">
<Value>FamilyCoalYears</Value>
</Value>
<Value name="33">
<Value>FluBacterin</Value>
</Value>
<Value name="34">
<Value>FoodFavor</Value>
</Value>
<Value name="35">
<Value>IsExercise</Value>
</Value>
<Value name="36">
<Value>MentalStatus</Value>
</Value>
<Value name="37">
<Value>MiddleExercise</Value>
</Value>
<Value name="38">
<Value>MiddleWorkDays</Value>
</Value>
<Value name="39">
<Value>NumOfSmoke</Value>
</Value>
<Value name="40">
<Value>OilQuantity</Value>
</Value>
<Value name="41">
<Value>OtherCustom</Value>
</Value>
<Value name="42">
<Value>OxygenHour</Value>
</Value>
<Value name="43">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="44">
<Value>PlaceOfResidence</Value>
</Value>
<Value name="45">
<Value>Pneumococcus</Value>
</Value>
<Value name="46">
<Value>PsychologicStatus</Value>
</Value>
<Value name="47">
<Value>Salinity</Value>
</Value>
<Value name="48">
<Value>SleepHour</Value>
</Value>
<Value name="49">
<Value>SleepStatus</Value>
</Value>
<Value name="50">
<Value>Smoke</Value>
</Value>
<Value name="51">
<Value>StaffOfUpdate</Value>
</Value>
<Value name="52">
<Value>TemperType</Value>
</Value>
<Value name="53">
<Value>TimeOfMiddleExer</Value>
</Value>
<Value name="54">
<Value>TimeOfMiddleWork</Value>
</Value>
<Value name="55">
<Value>TimesOfWeekly</Value>
</Value>
<Value name="56">
<Value>YearOfExercise</Value>
</Value>
<Value name="57">
<Value>YearsOfEndSmoke</Value>
</Value>
<Value name="58">
<Value>bConfide</Value>
</Value>
<Value name="59">
<Value>bDryOut</Value>
</Value>
<Value name="60">
<Value>bFamilyCoal</Value>
</Value>
<Value name="61">
<Value>bFamilySmoke</Value>
</Value>
<Value name="62">
<Value>bFeelPressure</Value>
</Value>
<Value name="63">
<Value>Birth</Value>
</Value>
<Value name="64">
<Value>PersonCode</Value>
</Value>
<Value name="65">
<Value>PersonName</Value>
</Value>
<Value name="66">
<Value>PersonRowId</Value>
</Value>
<Value name="67">
<Value>SexName</Value>
</Value>
<Value name="68">
<Value>ExerciseTypeDR</Value>
</Value>
<Value name="69">
<Value>ExerciseTypeDRName</Value>
</Value>
<Value name="70">
<Value>ExercisePlaceName</Value>
</Value>
<Value name="71">
<Value>FoodFavorValue</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonLifeSt794D</DataLocation>
<DefaultData>PersonLifeStyleInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonLifeSt794D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonLifeSt794I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonLifeSt794S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
