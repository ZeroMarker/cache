/// Creater:王聪聪
/// Descriptions:考核项目父表
/// Date:2019-09-07
Class DHCNMG.DB.MgAssessModel Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgAssessModelSub [ Cardinality = children, Inverse = Parref ];

/// 被评病区
Property AssessWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Assess_Ward ];

/// 考核者
Property AssessUser As %String [ SqlColumnNumber = 3, SqlFieldName = Assess_User ];

/// 被考核者
Property AssessedUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Assessed_User ];

/// 得分
Property AssessScore As %String [ SqlColumnNumber = 5, SqlFieldName = Assess_Score ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = Create_Date ];

/// 状态 【S:提交 N:未提交】
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

/// 考核评分表id
Property AssessItem As DHCNMG.DB.MgAssessItem [ SqlColumnNumber = 8, SqlFieldName = AssessItem_DR ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Submit_Date ];

/// 年份
Property AssessYear As %String [ SqlColumnNumber = 11, SqlFieldName = Assess_Year ];

/// 考核时段
Property AssessTime As %String [ SqlColumnNumber = 12, SqlFieldName = Assess_Time ];

/// 考核日期
Property AssessDate As %Date [ SqlColumnNumber = 16, SqlFieldName = Assess_Date ];

/// 考核类型
Property AssessType As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 13, SqlFieldName = Assess_Type ];

/// 相关科室
Property AssessWardLoc As DHCNMG.DB.MgWardLoc [ SqlColumnNumber = 14, SqlFieldName = Assess_WardLoc ];

Property Remark As %String [ SqlColumnNumber = 15, SqlFieldName = Remark ];

Index type On AssessItem;

Index wardloc On AssessWardLoc;

Index ward On AssessWard;

Index user On AssessUser;

Index assessed On (AssessYear, AssessTime, AssessType, AssessUser, AssessedUser, AssessScore);

Index summary On (AssessYear, AssessTime, AssessedUser, AssessScore);

Index count On (AssessYear, AssessTime, AssessedUser);

Index score On (AssessedUser, Status, AssessScore);

Index year On AssessYear;

Storage Default
{
<Data name="MgAssessModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreWard</Value>
</Value>
<Value name="3">
<Value>AssessUser</Value>
</Value>
<Value name="4">
<Value>AssessedUser</Value>
</Value>
<Value name="5">
<Value>AssessScore</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>AssessTypeDR</Value>
</Value>
<Value name="9">
<Value>SubmitDate</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>AssessWard</Value>
</Value>
<Value name="12">
<Value>AssessYear</Value>
</Value>
<Value name="13">
<Value>AssessTime</Value>
</Value>
<Value name="14">
<Value>AssessRole</Value>
</Value>
<Value name="15">
<Value>AssessItemDR</Value>
</Value>
<Value name="16">
<Value>AssessType</Value>
</Value>
<Value name="17">
<Value>AssessWardLoc</Value>
</Value>
<Value name="18">
<Value>AssessItem</Value>
</Value>
<Value name="19">
<Value>AssessDate</Value>
</Value>
<Value name="20">
<Value>Flag</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgAssessModelD</DataLocation>
<DefaultData>MgAssessModelDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgAssessModelD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgAssessModelI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgAssessModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
