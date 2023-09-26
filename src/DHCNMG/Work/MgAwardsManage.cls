/// creator:liuning
/// createdate:2018-11-01
/// description:护理工作量管理科研成果奖列表
Class DHCNMG.Work.MgAwardsManage Extends %Persistent
{

/// 奖项来源
Property AwardsSource As %String [ SqlColumnNumber = 2, SqlFieldName = Awards_Source ];

/// 奖项名称
Property AwardsName As %String [ SqlColumnNumber = 3, SqlFieldName = Awards_Name ];

/// 获奖日期
Property AwardsDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Awards_Date ];

/// 成果等级
Property AwardsGrade As %String [ SqlColumnNumber = 5, SqlFieldName = Awards_Grade ];

/// 奖金数额
Property AwardsAmount As %String [ SqlColumnNumber = 6, SqlFieldName = Awards_Amount ];

/// 成果类型
Property AwardsType As %String [ SqlColumnNumber = 7, SqlFieldName = Awards_Type ];

/// 第一完成人
Property AwardsNurOne As %String [ SqlColumnNumber = 8, SqlFieldName = Awards_NurOne ];

/// 第一完成人职务
Property AwardsDutyOne As %String [ SqlColumnNumber = 9, SqlFieldName = Awards_DutyOne ];

/// 第一完成职称
Property AwardsTitleOne As %String [ SqlColumnNumber = 10, SqlFieldName = Awards_TitleOne ];

/// 第一完成人层级
Property AwardsHierarchyOne As %String [ SqlColumnNumber = 11, SqlFieldName = Awards_HierarchyOne ];

/// 第一完成人大科
Property AwardsAreaOne As %String [ SqlColumnNumber = 12, SqlFieldName = Awards_AreaOne ];

/// 第一完成人所在病区
Property AwardsStaAreaOne As %String [ SqlColumnNumber = 13, SqlFieldName = Awards_StaAreaOne ];

/// 第二完成人
Property AwardsNurTwo As %String [ SqlColumnNumber = 14, SqlFieldName = Awards_NurTwo ];

/// 第二完成人职务
Property AwardsDutyTwo As %String [ SqlColumnNumber = 15, SqlFieldName = Awards_DutyTwo ];

/// 第二完成职称
Property AwardsTitleTwo As %String [ SqlColumnNumber = 16, SqlFieldName = Awards_TitleTwo ];

/// 第二完成人层级
Property AwardsHierarchyTwo As %String [ SqlColumnNumber = 17, SqlFieldName = Awards_HierarchyTwo ];

/// 第二完成人大科
Property AwardsAreaTwo As %String [ SqlColumnNumber = 18, SqlFieldName = Awards_AreaTwo ];

/// 第二完成人所在病区
Property AwardsStaAreaTwo As %String [ SqlColumnNumber = 19, SqlFieldName = Awards_StaAreaTwo ];

/// 第三完成人
Property AwardsNurThree As %String [ SqlColumnNumber = 20, SqlFieldName = Awards_NurThree ];

/// 第三完成人职务
Property AwardsDutyThree As %String [ SqlColumnNumber = 21, SqlFieldName = Awards_DutyThree ];

/// 第三完成职称
Property AwardsTitleThree As %String [ SqlColumnNumber = 22, SqlFieldName = Awards_TitleThree ];

/// 第三完成人层级
Property AwardsHierarchyThree As %String [ SqlColumnNumber = 23, SqlFieldName = Awards_HierarchyThree ];

/// 第三完成人大科
Property AwardsAreaThree As %String [ SqlColumnNumber = 24, SqlFieldName = Awards_AreaThree ];

/// 第三完成人所在病区
Property AwardsStaAreaThree As %String [ SqlColumnNumber = 25, SqlFieldName = Awards_StaAreaThree ];

/// 其他完成人
Property AwardsNurOther As %String [ SqlColumnNumber = 26, SqlFieldName = Awards_NurOther ];

/// 获奖年度
Property AwardsYear As %String [ SqlColumnNumber = 27, SqlFieldName = Awards_Year ];

Index Nur On AwardsNurOne;

Index Awards On AwardsName;

Index NurYear On (AwardsYear, AwardsName, AwardsNurOne);

Storage Default
{
<Data name="MgAwardsManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AwardsSource</Value>
</Value>
<Value name="3">
<Value>AwardsName</Value>
</Value>
<Value name="4">
<Value>AwardsDate</Value>
</Value>
<Value name="5">
<Value>AwardsGrade</Value>
</Value>
<Value name="6">
<Value>AwardsAmount</Value>
</Value>
<Value name="7">
<Value>AwardsType</Value>
</Value>
<Value name="8">
<Value>AwardsNurOne</Value>
</Value>
<Value name="9">
<Value>AwardsDutyOne</Value>
</Value>
<Value name="10">
<Value>AwardsTitleOne</Value>
</Value>
<Value name="11">
<Value>AwardsHierarchyOne</Value>
</Value>
<Value name="12">
<Value>AwardsAreaOne</Value>
</Value>
<Value name="13">
<Value>AwardsStaAreaOne</Value>
</Value>
<Value name="14">
<Value>AwardsNurTwo</Value>
</Value>
<Value name="15">
<Value>AwardsDutyTwo</Value>
</Value>
<Value name="16">
<Value>AwardsTitleTwo</Value>
</Value>
<Value name="17">
<Value>AwardsHierarchyTwo</Value>
</Value>
<Value name="18">
<Value>AwardsAreaTwo</Value>
</Value>
<Value name="19">
<Value>AwardsStaAreaTwo</Value>
</Value>
<Value name="20">
<Value>AwardsNurThree</Value>
</Value>
<Value name="21">
<Value>AwardsDutyThree</Value>
</Value>
<Value name="22">
<Value>AwardsTitleThree</Value>
</Value>
<Value name="23">
<Value>AwardsHierarchyThree</Value>
</Value>
<Value name="24">
<Value>AwardsAreaThree</Value>
</Value>
<Value name="25">
<Value>AwardsStaAreaThree</Value>
</Value>
<Value name="26">
<Value>AwardsNurOther</Value>
</Value>
<Value name="27">
<Value>AwardsYear</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgAwardsManageD</DataLocation>
<DefaultData>MgAwardsManageDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgAwardsManageD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgAwardsManageI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgAwardsManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
