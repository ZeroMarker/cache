Class CHSS.EarthquakeArchive Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = EarthquakeArchive ]
{

/// ﻿社区编码
Property CommunityCode As %String(MAXLEN = 60, TRUNCATE = 1) [ Required ];

/// 地震前降雨
Property RainBef As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震前空气湿度
Property AirHumidityBef As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震前平均气温
Property AverageTemperatureBef As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震前空气污染指数
Property AirPollutionIndexBef As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后降雨
Property RainAfter As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后空气湿度
Property AirHumidityAfter As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后平均气温
Property AverageTemperAfter As %String(MAXLEN = 50, TRUNCATE = 1);

/// 地震后空气污染指数
Property AirPollutionIndexAfter As %String(MAXLEN = 50, TRUNCATE = 1);

/// 2005~2007交通建设投入
Property TrafficInvest07 As %Float;

/// 辖区内公路里程
Property HighwayMileage07 As %Float;

/// 高速公路
Property SuperHighway07 As %Float;

/// 一级公路
Property FirstClass07 As %Float;

/// 已通公路的行政村
Property VillageHaveHighway07 As %Numeric;

/// 震后辖区内公路里程
Property HighwayMileageAfter As %Float;

/// 震后高速公路
Property SuperHighwayAfter As %Float;

/// 震后一级公路
Property FirstClassAfter As %Float;

/// 震后已通公路的行政村
Property VillageHaveHighwayAfter As %Numeric;

/// 2005-2007年通信建设及广播电视投入
Property Communication07 As %Float;

/// 2007年固定电话
Property FixedTelphone07 As %Numeric;

/// 移动电话
Property MobilePhone07 As %Numeric;

/// 广播覆盖率
Property Broadcast07 As %Float;

/// 电视覆盖率
Property TV2007 As %Float;

/// 地震后通信是否受损
Property bCommImpairment As %String(MAXLEN = 5, TRUNCATE = 1);

/// 中断时间
Property TimeOfCommDisruption As %Float;

/// 2005-2007年卫生事业经费
Property HealthCareInvest07 As %Float;

/// 2007年总床位
Property AllBedNum07 As %Numeric;

/// 2007年卫生技术人员
Property MedicalPersonnel07 As %Numeric;

/// 医生
Property Doctor07 As %Numeric;

/// 护士
Property Nurse07 As %Numeric;

/// 其他技术人员
Property OtherMedicalPersonel07 As %Numeric;

/// 卫生技术人员大专及以上学历
Property CollNum07 As %Numeric;

/// 卫生技术人员中级及以上职称
Property MiddleTitelNum07 As %Numeric;

/// 卫生技术人员中专及以上学历
Property TechnicalSecNum07 As %Numeric;

/// 村医
Property DoctorNumOfVillage07 As %Numeric;

/// 其中持证上岗
Property DoctorNumHaveCer07 As %Numeric;

/// 小学
Property PrimarySchLevelNum07 As %Numeric;

/// 初中
Property JuniorMiddleLevelNum07 As %Numeric;

/// 中专及以上
Property EducationalLevelNum07 As %Numeric;

/// 2008年卫生事业经费
Property HealthCareInvest08 As %Float;

/// 2008年总床位
Property AllBedNum2008 As %Numeric;

/// 2008年卫生技术人员
Property MedicalPersonnel08 As %Numeric;

/// 医生2
Property Doctor2008 As %Numeric;

/// 护士2
Property Nurse2008 As %Numeric;

/// 其他技术人员2
Property OtherMedicalPersonel08 As %Numeric;

/// 卫生技术人员大专及以上学历2
Property CollNum2008 As %Numeric;

/// 卫生技术人员中级及以上职称2
Property MiddleTitelNum08 As %Numeric;

/// 卫生技术人员中专及以上学历2
Property TechnicalSecNum08 As %Numeric;

/// 村医2
Property DoctorNumOfVillage08 As %Numeric;

/// 其中持证上岗2
Property DoctorNumHaveCer08 As %Numeric;

/// 小学2
Property PrimarySchLevelNum08 As %Numeric;

/// 初中2
Property JuniorMiddleLevelNum08 As %Numeric;

/// 中专及以上2
Property EducationalLevelNum08 As %Numeric;

/// 受灾人口
Property DisasterAffectedNum As %Numeric;

/// 地震导致死亡
Property DeathInEQ As %Numeric;

/// 地震导致受伤
Property DamageInEQ As %Numeric;

/// 毁损房屋
Property HouseDestroyedNum As %Numeric;

/// 毁损房屋面积
Property HouseDestroyedArea As %Float;

/// 卫生技术人员死亡
Property DeathOfMedicalPersonel As %Numeric;

/// 卫生技术人员受伤
Property DamageOfMedicalPersonel As %Numeric;

/// 设备损失
Property LossOfEquipment As %Numeric;

/// 目前卫生技术人员
Property CurMedicalPersonel As %Numeric;

/// 用房在地震中受损情
Property HousingDamage As CHSS.DictHouseDamage;

/// 目前办公地点
Property CurHousing As %String(MAXLEN = 80, TRUNCATE = 1);

/// 到达县城的道路是否中断
Property bBreakToCountry As %String(MAXLEN = 5, TRUNCATE = 1);

/// 中断天数
Property BreakDays As %Numeric;

/// 肺结核病人免费治疗项目是否中断
Property bTBFreeBreak As %String(MAXLEN = 5, TRUNCATE = 1);

/// 免费治疗项目中断天数
Property TBFreeBreakDays As %Numeric;

/// 地震后用水中断天数
Property WaterBreakDays As %Numeric;

/// 地震后食物中断天数_
Property FoodBreakDays As %Numeric;

/// 通讯中断天数
Property CommunicationBreakDays As %Numeric;

/// 地形地貌
Property Landform As CHSS.DictLandform;

/// 2007年总户数
Property TotalHousehold07 As %Numeric;

/// 2007年劳动力
Property LabourForce07 As %Numeric;

/// 2007年登记失业率
Property RegisteredJoblessRate07 As %Float;

/// 2007年外出务工
Property OutWork07 As %Numeric;

/// 2007年外来务工
Property InWork07 As %Numeric;

/// 2008年总户数
Property TotalHousehold08 As %Numeric;

/// 2008年劳动力
Property LabourForce08 As %Numeric;

/// 2008年登记失业率
Property RegisteredJoblessRate08 As %Float;

/// 2008年外出务工
Property OutWork2008 As %Numeric;

/// 2008年外来务工
Property InWork2008 As %Numeric;

/// 2005-2007年教育经费
Property EducationInvest07 As %Float;

/// 2007年各类教师
Property TeacherNum07 As %Numeric;

/// 2007年15岁以上文盲和半文盲
Property UntaughtTeacher07 As %Numeric;

/// 2007年小学
Property PrimaryTeacher07 As %Numeric;

/// 2007年中学或中专
Property EducationalTeacher07 As %Numeric;

/// 2007年大专及以上
Property CollTeacher07 As %Numeric;

/// 2008年教育经费
Property EducationInvest08 As %Float;

/// 2008年各类教师
Property TeacherNum08 As %Numeric;

/// 2008年15岁以上文盲和半文盲
Property UntaughtTeacher08 As %Numeric;

/// 2008年小学
Property PrimaryTeacher08 As %Numeric;

/// 2008年中学或中专
Property EducationlTeacher08 As %Numeric;

/// 2008年大专及以上
Property CollTeacher08 As %Numeric;

/// 录入日期
Property DateInput As %Date;

/// 建档人员
Property OperatorInput As User.SSUser;

/// 面积
Property Area As %Float;

/// 灾前人口
Property PopulationBefore As %Numeric;

/// 人口密度
Property PopuDensityBefore As %Float;

/// 城镇化率
Property URB As %Float;

/// 地震烈度
Property SeismicIntensity As %String(MAXLEN = 20, TRUNCATE = 1);

/// 地震加速度峰值
Property EqAcceler As %String(MAXLEN = 20, TRUNCATE = 1);

/// 坡度大于25°比例
Property Scale25 As %Float;

/// 道路损毁比例
Property RoadDamageScale As %Float;

/// 失踪人数
Property MissingNum As %Numeric;

/// 震亡率
Property EqDeathNum As %Float;

/// 受伤率
Property EqHurtNum As %Float;

/// 房屋倒塌率
Property HouseCollapse As %Float;

/// 2007年人均收入
Property PerIncome2007 As %Float;

/// 2008年人均收入
Property PerIncome2008 As %Float;

Index CommunityCodeIndex On CommunityCode [ Unique ];

Storage Default
{
<Data name="EarthquakeArchiveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AirHumidityAfter</Value>
</Value>
<Value name="3">
<Value>AirHumidityBef</Value>
</Value>
<Value name="4">
<Value>AirPollutionIndexAfter</Value>
</Value>
<Value name="5">
<Value>AirPollutionIndexBef</Value>
</Value>
<Value name="6">
<Value>AllBedNum07</Value>
</Value>
<Value name="7">
<Value>AllBedNum2008</Value>
</Value>
<Value name="8">
<Value>AverageTemperAfter</Value>
</Value>
<Value name="9">
<Value>AverageTemperatureBef</Value>
</Value>
<Value name="10">
<Value>BreakDays</Value>
</Value>
<Value name="11">
<Value>Broadcast07</Value>
</Value>
<Value name="12">
<Value>CollNum07</Value>
</Value>
<Value name="13">
<Value>CollNum2008</Value>
</Value>
<Value name="14">
<Value>CollTeacher07</Value>
</Value>
<Value name="15">
<Value>CollTeacher08</Value>
</Value>
<Value name="16">
<Value>Communication07</Value>
</Value>
<Value name="17">
<Value>CommunicationBreakDays</Value>
</Value>
<Value name="18">
<Value>CommunityCode</Value>
</Value>
<Value name="19">
<Value>CurHousing</Value>
</Value>
<Value name="20">
<Value>CurMedicalPersonel</Value>
</Value>
<Value name="21">
<Value>DamageInEQ</Value>
</Value>
<Value name="22">
<Value>DamageOfMedicalPersonel</Value>
</Value>
<Value name="23">
<Value>DateInput</Value>
</Value>
<Value name="24">
<Value>DeathInEQ</Value>
</Value>
<Value name="25">
<Value>DeathOfMedicalPersonel</Value>
</Value>
<Value name="26">
<Value>DisasterAffectedNum</Value>
</Value>
<Value name="27">
<Value>Doctor07</Value>
</Value>
<Value name="28">
<Value>Doctor2008</Value>
</Value>
<Value name="29">
<Value>DoctorNumHaveCer07</Value>
</Value>
<Value name="30">
<Value>DoctorNumHaveCer08</Value>
</Value>
<Value name="31">
<Value>DoctorNumOfVillage07</Value>
</Value>
<Value name="32">
<Value>DoctorNumOfVillage08</Value>
</Value>
<Value name="33">
<Value>EducationInvest07</Value>
</Value>
<Value name="34">
<Value>EducationalLevelNum07</Value>
</Value>
<Value name="35">
<Value>EducationalLevelNum08</Value>
</Value>
<Value name="36">
<Value>EducationalTeacher07</Value>
</Value>
<Value name="37">
<Value>EducationlTeacher08</Value>
</Value>
<Value name="38">
<Value>FirstClass07</Value>
</Value>
<Value name="39">
<Value>FirstClassAfter</Value>
</Value>
<Value name="40">
<Value>FixedTelphone07</Value>
</Value>
<Value name="41">
<Value>FoodBreakDays</Value>
</Value>
<Value name="42">
<Value>HealthCareInvest07</Value>
</Value>
<Value name="43">
<Value>HealthCareInvest08</Value>
</Value>
<Value name="44">
<Value>HighwayMileage07</Value>
</Value>
<Value name="45">
<Value>HighwayMileageAfter</Value>
</Value>
<Value name="46">
<Value>HouseDestroyedArea</Value>
</Value>
<Value name="47">
<Value>HouseDestroyedNum</Value>
</Value>
<Value name="48">
<Value>HousingDamage</Value>
</Value>
<Value name="49">
<Value>InWork07</Value>
</Value>
<Value name="50">
<Value>InWork2008</Value>
</Value>
<Value name="51">
<Value>JuniorMiddleLevelNum07</Value>
</Value>
<Value name="52">
<Value>JuniorMiddleLevelNum08</Value>
</Value>
<Value name="53">
<Value>LabourForce07</Value>
</Value>
<Value name="54">
<Value>LabourForce08</Value>
</Value>
<Value name="55">
<Value>Landform</Value>
</Value>
<Value name="56">
<Value>LossOfEquipment</Value>
</Value>
<Value name="57">
<Value>MedicalPersonnel07</Value>
</Value>
<Value name="58">
<Value>MedicalPersonnel08</Value>
</Value>
<Value name="59">
<Value>MiddleTitelNum07</Value>
</Value>
<Value name="60">
<Value>MiddleTitelNum08</Value>
</Value>
<Value name="61">
<Value>MobilePhone07</Value>
</Value>
<Value name="62">
<Value>Nurse07</Value>
</Value>
<Value name="63">
<Value>Nurse2008</Value>
</Value>
<Value name="64">
<Value>OperatorInput</Value>
</Value>
<Value name="65">
<Value>OtherMedicalPersonel07</Value>
</Value>
<Value name="66">
<Value>OtherMedicalPersonel08</Value>
</Value>
<Value name="67">
<Value>OutWork07</Value>
</Value>
<Value name="68">
<Value>OutWork2008</Value>
</Value>
<Value name="69">
<Value>PrimarySchLevelNum07</Value>
</Value>
<Value name="70">
<Value>PrimarySchLevelNum08</Value>
</Value>
<Value name="71">
<Value>PrimaryTeacher07</Value>
</Value>
<Value name="72">
<Value>PrimaryTeacher08</Value>
</Value>
<Value name="73">
<Value>RainAfter</Value>
</Value>
<Value name="74">
<Value>RainBef</Value>
</Value>
<Value name="75">
<Value>RegisteredJoblessRate07</Value>
</Value>
<Value name="76">
<Value>RegisteredJoblessRate08</Value>
</Value>
<Value name="77">
<Value>SuperHighway07</Value>
</Value>
<Value name="78">
<Value>SuperHighwayAfter</Value>
</Value>
<Value name="79">
<Value>TBFreeBreakDays</Value>
</Value>
<Value name="80">
<Value>TV2007</Value>
</Value>
<Value name="81">
<Value>TeacherNum07</Value>
</Value>
<Value name="82">
<Value>TeacherNum08</Value>
</Value>
<Value name="83">
<Value>TechnicalSecNum07</Value>
</Value>
<Value name="84">
<Value>TechnicalSecNum08</Value>
</Value>
<Value name="85">
<Value>TimeOfCommDisruption</Value>
</Value>
<Value name="86">
<Value>TotalHousehold07</Value>
</Value>
<Value name="87">
<Value>TotalHousehold08</Value>
</Value>
<Value name="88">
<Value>TrafficInvest07</Value>
</Value>
<Value name="89">
<Value>UntaughtTeacher07</Value>
</Value>
<Value name="90">
<Value>UntaughtTeacher08</Value>
</Value>
<Value name="91">
<Value>VillageHaveHighway07</Value>
</Value>
<Value name="92">
<Value>VillageHaveHighwayAfter</Value>
</Value>
<Value name="93">
<Value>WaterBreakDays</Value>
</Value>
<Value name="94">
<Value>bBreakToCountry</Value>
</Value>
<Value name="95">
<Value>bCommImpairment</Value>
</Value>
<Value name="96">
<Value>bTBFreeBreak</Value>
</Value>
<Value name="97">
<Value>EducationInvest08</Value>
</Value>
<Value name="98">
<Value>Area</Value>
</Value>
<Value name="99">
<Value>EqAcceler</Value>
</Value>
<Value name="100">
<Value>EqDeathNum</Value>
</Value>
<Value name="101">
<Value>EqHurtNum</Value>
</Value>
<Value name="102">
<Value>HouseCollapse</Value>
</Value>
<Value name="103">
<Value>MissingNum</Value>
</Value>
<Value name="104">
<Value>PerIncome2007</Value>
</Value>
<Value name="105">
<Value>PerIncome2008</Value>
</Value>
<Value name="106">
<Value>PopuDensityBefore</Value>
</Value>
<Value name="107">
<Value>PopulationBefore</Value>
</Value>
<Value name="108">
<Value>RoadDamageScale</Value>
</Value>
<Value name="109">
<Value>Scale25</Value>
</Value>
<Value name="110">
<Value>SeismicIntensity</Value>
</Value>
<Value name="111">
<Value>URB</Value>
</Value>
</Data>
<DataLocation>^CHSS.EarthquakeArchiveD</DataLocation>
<DefaultData>EarthquakeArchiveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.EarthquakeArchiveD</IdLocation>
<IndexLocation>^CHSS.EarthquakeArchiveI</IndexLocation>
<StreamLocation>^CHSS.EarthquakeArchiveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
