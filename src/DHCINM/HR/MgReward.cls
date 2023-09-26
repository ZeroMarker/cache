Class DHCINM.HR.MgReward Extends %Persistent
{

/// 人员档案id
Property RewardNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Reward_Nurse ];

/// 病区
Property RewardWard As %String [ SqlColumnNumber = 3, SqlFieldName = Reward_Ward ];

/// 获奖内容
Property RewardContent As %String [ SqlColumnNumber = 4, SqlFieldName = Reward_Content ];

/// 颁奖单位
Property RewardUnit As %String [ SqlColumnNumber = 5, SqlFieldName = Reward_Unit ];

/// 获奖成绩
Property RewardResult As %String [ SqlColumnNumber = 6, SqlFieldName = Reward_Result ];

/// 获奖级别
Property RewardLevel As %String [ SqlColumnNumber = 7, SqlFieldName = Reward_Level ];

/// 获奖日期
Property RewardDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Reward_Date ];

/// 指导老师
Property RewardTeacher As %String [ SqlColumnNumber = 9, SqlFieldName = Reward_Teacher ];

/// 证明人
Property Certifier As %String [ SqlColumnNumber = 10, SqlFieldName = Certifier ];

/// 备注
Property RewardMark As %String [ SqlColumnNumber = 11, SqlFieldName = Reward_Mark ];

/// 证书图片
Property CertPic As list Of %String [ SqlColumnNumber = 12, SqlFieldName = CertPic ];

Index ssid On (RewardDate, RewardNurse);

Storage Default
{
<Data name="MgRewardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RewardNurse</Value>
</Value>
<Value name="3">
<Value>RewardWard</Value>
</Value>
<Value name="4">
<Value>RewardContent</Value>
</Value>
<Value name="5">
<Value>RewardUnit</Value>
</Value>
<Value name="6">
<Value>RewardResult</Value>
</Value>
<Value name="7">
<Value>RewardLevel</Value>
</Value>
<Value name="8">
<Value>RewardDate</Value>
</Value>
<Value name="9">
<Value>RewardTeacher</Value>
</Value>
<Value name="10">
<Value>Certifier</Value>
</Value>
<Value name="11">
<Value>RewardMark</Value>
</Value>
<Value name="12">
<Value>CertPic</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgRewardD</DataLocation>
<DefaultData>MgRewardDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgRewardD</IdLocation>
<IndexLocation>^DHCINM.HR.MgRewardI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgRewardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
