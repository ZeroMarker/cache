Class CHSS.EarthquakePersonLivingInfo Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = EarthquakePersonLivingInfo ]
{

/// 外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 家庭年收入	
Property FamilyIncome As %Numeric;

/// 地震前住房类型
Property HouseBefore As CHSS.DictHouseTypeBefore;

/// 地震前居住面积	
Property AreaBefore As %Numeric;

/// 地震前居住人数	
Property PersonNumBefore As %Numeric;

/// 地震前距离最近卫生机构距离	
Property HospitalDistanceBefore As %Numeric;

/// 地震前距离最近卫生机构时间	
Property HospitalTimeBefore As %Numeric;

/// 目前住房类型
Property HouseCur As CHSS.DictHouseTypeBefore;

/// 目前居住面积
Property AreaCur As %Numeric;

/// 目前居住人数 
Property PersonNumCur As %Numeric;

/// 目前距离最近卫生机构距离
Property HospitalDistanceCur As %Numeric;

/// 目前距离最近卫生机构时间	
Property HospitalTimeCur As %Numeric;

/// 地震后是否住帐篷
Property bLiveTent As %String(MAXLEN = 5, TRUNCATE = 1);

/// 帐篷居住时间	
Property TimeOfLiveTent As %Numeric;

/// 帐篷面积	
Property AreaOfTent As %Numeric;

/// 帐篷居住人数
Property PersonNumOfTent As %Numeric;

/// 地震后是否住平房	
Property bLiveBungalow As %String(MAXLEN = 5, TRUNCATE = 1);

/// 平房居住时间	
Property TimeOfLiveBungalow As %Numeric;

/// 平房面积
Property AreaOfBungalow As %Numeric;

/// 平房居住人数	
Property PersonNumOfBungalow As %Numeric;

/// 居住板房区安置人数	
Property FrameHousePersonNum As %Numeric;

/// 居住板房区面积	
Property FrameHouseArea As %Numeric;

/// 居住板房区公共厕所	
Property FrameHouseTolit As %Numeric;

/// 每个厕所蹲坑数量	
Property FrameHouseUrinalNum As %Numeric;

/// 公共浴室	
Property PublicBalnearyNum As %Numeric;

/// 公共厨房	
Property PublicKitchenNum As %Numeric;

/// 每个厨房灶台	
Property HearthNum As %Numeric;

/// 每人每天供应洁净水数量	
Property WaterQuality As %Numeric;

/// 板房区卫生清洁人数 
Property DustmanNum As %Numeric;

/// 清洁频率	
Property CleanRate As %Numeric;

/// 板房区卫生消毒人数	
Property IndispositionNum As %Numeric;

/// 消毒频率	
Property IndispositionRate As %Numeric;

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="EarthquakePersonLivingInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AreaBefore</Value>
</Value>
<Value name="3">
<Value>AreaCur</Value>
</Value>
<Value name="4">
<Value>AreaOfBungalow</Value>
</Value>
<Value name="5">
<Value>AreaOfTent</Value>
</Value>
<Value name="6">
<Value>CleanRate</Value>
</Value>
<Value name="7">
<Value>DustmanNum</Value>
</Value>
<Value name="8">
<Value>FamilyIncome</Value>
</Value>
<Value name="9">
<Value>FrameHouseArea</Value>
</Value>
<Value name="10">
<Value>FrameHousePersonNum</Value>
</Value>
<Value name="11">
<Value>FrameHouseTolit</Value>
</Value>
<Value name="12">
<Value>FrameHouseUrinalNum</Value>
</Value>
<Value name="13">
<Value>HearthNum</Value>
</Value>
<Value name="14">
<Value>HospitalDistanceBefore</Value>
</Value>
<Value name="15">
<Value>HospitalDistanceCur</Value>
</Value>
<Value name="16">
<Value>HospitalTimeBefore</Value>
</Value>
<Value name="17">
<Value>HospitalTimeCur</Value>
</Value>
<Value name="18">
<Value>HouseBefore</Value>
</Value>
<Value name="19">
<Value>HouseCur</Value>
</Value>
<Value name="20">
<Value>IndispositionNum</Value>
</Value>
<Value name="21">
<Value>IndispositionRate</Value>
</Value>
<Value name="22">
<Value>PersonNumBefore</Value>
</Value>
<Value name="23">
<Value>PersonNumCur</Value>
</Value>
<Value name="24">
<Value>PersonNumOfBungalow</Value>
</Value>
<Value name="25">
<Value>PersonNumOfTent</Value>
</Value>
<Value name="26">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="27">
<Value>PublicBalnearyNum</Value>
</Value>
<Value name="28">
<Value>PublicKitchenNum</Value>
</Value>
<Value name="29">
<Value>TimeOfLiveBungalow</Value>
</Value>
<Value name="30">
<Value>TimeOfLiveTent</Value>
</Value>
<Value name="31">
<Value>WaterQuality</Value>
</Value>
<Value name="32">
<Value>bLiveBungalow</Value>
</Value>
<Value name="33">
<Value>bLiveTent</Value>
</Value>
</Data>
<DataLocation>^CHSS.EarthquakePeA77D</DataLocation>
<DefaultData>EarthquakePersonLivingInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.EarthquakePeA77D</IdLocation>
<IndexLocation>^CHSS.EarthquakePeA77I</IndexLocation>
<StreamLocation>^CHSS.EarthquakePeA77S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
