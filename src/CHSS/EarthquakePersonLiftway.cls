Class CHSS.EarthquakePersonLiftway Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = EarthquakePersonLiftway ]
{

/// 外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 地震前是否吸烟	
Property bSmoke As %String(MAXLEN = 5, TRUNCATE = 1);

/// 吸烟总时间	
Property SmokeYears As %Numeric;

/// 吸烟总时间吸烟量	
Property SmokeNum As %Numeric;

/// 是否戒烟	
Property bStopSmoke As %String(MAXLEN = 5, TRUNCATE = 1);

/// 戒烟年限	
Property StopSmokeTime As %Numeric;

/// 地震前是否饮酒	
Property bDrink As %String(MAXLEN = 5, TRUNCATE = 1);

/// 饮酒类型
Property DrinkType As CHSS.DictDrinkType;

/// 饮酒总时间	
Property DrinkTime As %Numeric;

/// 饮酒量
Property DPAC As %Numeric;

/// 是否戒酒	
Property bDryOut As %String(MAXLEN = 5, TRUNCATE = 1);

/// 戒酒年限	
Property DryOutTime As %Numeric;

/// 地震后是否饮酒
Property bDrinkCur As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震后饮酒量	
Property DPACCur As %Numeric;

/// 地震前是否锻炼身体
Property bExerciseBefore As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震后是否锻炼身体	
Property bExerciseCur As %String(MAXLEN = 5, TRUNCATE = 1);

/// 锻炼身体的方式有无改变	
Property bExerciseTypeChange As %String(MAXLEN = 5, TRUNCATE = 1);

/// 改变原因	
Property ExerTypeChangeReason As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后锻炼身体的频率有无改变	
Property bExerRateChange As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震前生活规律是否规律
Property bLifeOrderliness As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震前规律原因
Property LifeOrderlinessReason As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后生活规律是否规律
Property bLifeOrderlinessCur As %String(MAXLEN = 5, TRUNCATE = 1);

/// 地震后规律原因
Property LifeOrderlinessCurReason As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震前睡眠状况	
Property SleepBefore As CHSS.DictSleepBefore;

/// 地震后睡眠状况	
Property SleepCur As CHSS.DictSleepCur;

/// 你的睡眠是否有变化
Property bSleepChange As %String(MAXLEN = 5, TRUNCATE = 1);

/// 睡眠变差原因	
Property SleepWorseReason As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震前后饮食结构是否改变	
Property bFoodChange As %String(MAXLEN = 5, TRUNCATE = 1);

/// 饮食结构是否适应	
Property bFoodAdapt As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否自己在板房起炉灶做饭	
Property bCookOneself As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否有通风的习惯	
Property bAiriness As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否有经常打扫卫生的习惯	
Property bClean As %String(MAXLEN = 5, TRUNCATE = 1);

/// 过有关肺结核的健康教育
Property bTBHealthEducation As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肺结核健康教育形式	
Property TBHealthEduType As CHSS.DictTBHealthEduType;

/// 有关乙肝的健康教育
Property bHBVHealthEducation As %String(MAXLEN = 5, TRUNCATE = 1);

/// 乙肝健康教育形式
Property HBVHealthEduType As CHSS.DictHBVHealthEduType;

/// 对安置点卫生状况满意程度	
Property bSaticifyToSanitation As %String(MAXLEN = 5, TRUNCATE = 1);

/// 对安置点公用设施满意程度
Property bSaticifyToEstablish As %String(MAXLEN = 5, TRUNCATE = 1);

/// 对生活饮用水食物满意程度	
Property bSaticifyToFood As %String(MAXLEN = 5, TRUNCATE = 1);

/// 对医疗服务状况满意程度
Property bSaticifyToMedical As %String(MAXLEN = 5, TRUNCATE = 1);

/// 对健康教育开展状况满意程度
Property bSaticifyToHealthEdu As %String(MAXLEN = 5, TRUNCATE = 1);

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="EarthquakePersonLiftwayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DPAC</Value>
</Value>
<Value name="3">
<Value>DPACCur</Value>
</Value>
<Value name="4">
<Value>DrinkTime</Value>
</Value>
<Value name="5">
<Value>DrinkType</Value>
</Value>
<Value name="6">
<Value>DryOutTime</Value>
</Value>
<Value name="7">
<Value>ExerTypeChangeReason</Value>
</Value>
<Value name="8">
<Value>HBVHealthEduType</Value>
</Value>
<Value name="9">
<Value>LifeOrderlinessCurReason</Value>
</Value>
<Value name="10">
<Value>LifeOrderlinessReason</Value>
</Value>
<Value name="11">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="12">
<Value>SleepBefore</Value>
</Value>
<Value name="13">
<Value>SleepCur</Value>
</Value>
<Value name="14">
<Value>SleepWorseReason</Value>
</Value>
<Value name="15">
<Value>SmokeNum</Value>
</Value>
<Value name="16">
<Value>SmokeYears</Value>
</Value>
<Value name="17">
<Value>StopSmokeTime</Value>
</Value>
<Value name="18">
<Value>TBHealthEduType</Value>
</Value>
<Value name="19">
<Value>bAiriness</Value>
</Value>
<Value name="20">
<Value>bClean</Value>
</Value>
<Value name="21">
<Value>bCookOneself</Value>
</Value>
<Value name="22">
<Value>bDrink</Value>
</Value>
<Value name="23">
<Value>bDrinkCur</Value>
</Value>
<Value name="24">
<Value>bDryOut</Value>
</Value>
<Value name="25">
<Value>bExerRateChange</Value>
</Value>
<Value name="26">
<Value>bExerciseBefore</Value>
</Value>
<Value name="27">
<Value>bExerciseCur</Value>
</Value>
<Value name="28">
<Value>bExerciseTypeChange</Value>
</Value>
<Value name="29">
<Value>bFoodAdapt</Value>
</Value>
<Value name="30">
<Value>bFoodChange</Value>
</Value>
<Value name="31">
<Value>bHBVHealthEducation</Value>
</Value>
<Value name="32">
<Value>bLifeOrderliness</Value>
</Value>
<Value name="33">
<Value>bLifeOrderlinessCur</Value>
</Value>
<Value name="34">
<Value>bSaticifyToEstablish</Value>
</Value>
<Value name="35">
<Value>bSaticifyToFood</Value>
</Value>
<Value name="36">
<Value>bSaticifyToHealthEdu</Value>
</Value>
<Value name="37">
<Value>bSaticifyToMedical</Value>
</Value>
<Value name="38">
<Value>bSaticifyToSanitation</Value>
</Value>
<Value name="39">
<Value>bSleepChange</Value>
</Value>
<Value name="40">
<Value>bSmoke</Value>
</Value>
<Value name="41">
<Value>bStopSmoke</Value>
</Value>
<Value name="42">
<Value>bTBHealthEducation</Value>
</Value>
</Data>
<DataLocation>^CHSS.EarthquakePersonLiftwayD</DataLocation>
<DefaultData>EarthquakePersonLiftwayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.EarthquakePersonLiftwayD</IdLocation>
<IndexLocation>^CHSS.EarthquakePersonLiftwayI</IndexLocation>
<StreamLocation>^CHSS.EarthquakePersonLiftwayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
