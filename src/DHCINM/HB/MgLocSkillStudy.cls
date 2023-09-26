/// Creater:wangpf
/// Descriptions:科室技能学习记录
/// Date:2020-08-19
Class DHCINM.HB.MgLocSkillStudy Extends %Persistent
{

/// 科室
Property SkillLoc As CF.DHCINM.DB.MgWardLoc [ SqlColumnNumber = 2, SqlFieldName = Bus_Loc ];

/// 日期
Property SkillDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Bus_Date ];

/// 主题
Property SkillTopic As %String [ SqlColumnNumber = 4, SqlFieldName = Bus_Topic ];

/// 主讲人
Property SkillHost As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Bus_Host ];

/// 参与人
Property SkillNurse As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Bus_Nurse ];

/// 备注
Property SkillRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Bus_Remark ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 8, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Create_Time ];

Index ToolIndex On (SkillDate, SkillLoc);

Storage Default
{
<Data name="MgLocSkillStudyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SkillLoc</Value>
</Value>
<Value name="3">
<Value>SkillDate</Value>
</Value>
<Value name="4">
<Value>SkillTopic</Value>
</Value>
<Value name="5">
<Value>SkillHost</Value>
</Value>
<Value name="6">
<Value>SkillNurse</Value>
</Value>
<Value name="7">
<Value>SkillRemark</Value>
</Value>
<Value name="8">
<Value>Creator</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgLocSkillStudyD</DataLocation>
<DefaultData>MgLocSkillStudyDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgLocSkillStudyD</IdLocation>
<IndexLocation>^DHCINM.HB.MgLocSkillStudyI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgLocSkillStudyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
