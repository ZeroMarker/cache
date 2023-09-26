Class CHSSWeb.HISInterface.CommunityHSInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 健康档案建档户数
Property FamilyArcNum As %Numeric;

/// 健康档案建档人数
Property PersonArcNum As %Numeric;

/// 妇女保健期内活产数
Property WomenFetusNum As %Numeric;

/// 妇女保健建立孕产妇保健手册人数
Property WomenArcNum As %Numeric;

/// 妇女保健规范产前检查人数
Property WomenCheckArcNum As %Numeric;

/// 妇女保健产后访视人数
Property WomenAfterCheckArcNum As %Numeric;

/// 老年人保健登记管理人数
Property ElderArcNum As %Numeric;

/// 老年人保健免费体格检查人数
Property ElderCheckArcNum As %Numeric;

/// 老年人保健免费空腹血糖检查人数
Property ElderBloodSurgeLimosisArcNum As %Numeric;

/// 老年人保健指导人次数
Property ElderCheckCountNum As %Numeric;

/// 康复指导与训练人次数
Property TrainingCountNum As %Numeric;

/// 重性精神疾病管理患者登记人数
Property SchizoArcNum As %Numeric;

/// 重性精神疾病管理患者显好人数
Property SchizoRecoverArcNum As %Numeric;

/// 重性精神疾病管理规范管理人数
Property SchizoManageArcNum As %Numeric;

/// 设置宣传栏栏数
Property HealthBroad As %Numeric;

/// 举办健康知识讲座次数
Property HealthEducationLecture As %Numeric;

/// 儿童预防接种证(卡)建立数
Property ChildImmuCardNum As %Numeric;

/// 接种人次数
Property ImmunityBacterinRecord As %Numeric;

/// 建立婴幼儿保健手册人数
Property ChildBaseInfo As %Numeric;

/// 新生儿访视人数
Property ChildFirstCheckNum As %Numeric;

/// 3岁以下儿童保健覆盖人数
Property ChildCheckRecordNum As %Numeric;

/// 高血压患者规范管理人数
Property HBPCheckNum As %Numeric;

/// 高血压患者管理人数
Property HbpCheckManageNum As %Numeric;

/// 糖尿病患者管理人数
Property DiabteNum As %Numeric;

/// 糖尿病患者规范管理人数
Property DiabteManageNum As %Numeric;

/// 其它慢病服务人次数
Property OtherChornicNum As %Numeric;

Storage Default
{
<Data name="CommunityHSInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElderArcNum</Value>
</Value>
<Value name="3">
<Value>ElderBloodSurgeLimosisArcNum</Value>
</Value>
<Value name="4">
<Value>ElderCheckArcNum</Value>
</Value>
<Value name="5">
<Value>ElderCheckCountNum</Value>
</Value>
<Value name="6">
<Value>FamilyArcNum</Value>
</Value>
<Value name="7">
<Value>PersonArcNum</Value>
</Value>
<Value name="8">
<Value>SchizoArcNum</Value>
</Value>
<Value name="9">
<Value>SchizoManageArcNum</Value>
</Value>
<Value name="10">
<Value>SchizoRecoverArcNum</Value>
</Value>
<Value name="11">
<Value>TrainingCountNum</Value>
</Value>
<Value name="12">
<Value>WomenAfterCheckArcNum</Value>
</Value>
<Value name="13">
<Value>WomenArcNum</Value>
</Value>
<Value name="14">
<Value>WomenCheckArcNum</Value>
</Value>
<Value name="15">
<Value>WomenFetusNum</Value>
</Value>
<Value name="16">
<Value>ChildBaseInfo</Value>
</Value>
<Value name="17">
<Value>ChildCheckManageNum</Value>
</Value>
<Value name="18">
<Value>ChildCheckRecordNum</Value>
</Value>
<Value name="19">
<Value>ChildFirstCheckNum</Value>
</Value>
<Value name="20">
<Value>ChildImmuCardNum</Value>
</Value>
<Value name="21">
<Value>DiabteManageNum</Value>
</Value>
<Value name="22">
<Value>DiabteNum</Value>
</Value>
<Value name="23">
<Value>HBPCheckNum</Value>
</Value>
<Value name="24">
<Value>HbpCheckManageNum</Value>
</Value>
<Value name="25">
<Value>HealthBroad</Value>
</Value>
<Value name="26">
<Value>HealthEducationLecture</Value>
</Value>
<Value name="27">
<Value>ImmunityBacterinRecord</Value>
</Value>
<Value name="28">
<Value>OtherChornicNum</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.CommunityHSI5ECD</DataLocation>
<DefaultData>CommunityHSInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.CommunityHSI5ECD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.CommunityHSI5ECI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.CommunityHSI5ECS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
