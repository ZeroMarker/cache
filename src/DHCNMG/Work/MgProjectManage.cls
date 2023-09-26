/// creator:liuning
/// createdate:2018-11-05
/// description:护理工作量管理科研立项列表
Class DHCNMG.Work.MgProjectManage Extends %Persistent
{

/// 立项日期
Property ProjectSetDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Project_SetDat ];

/// 立项等级
Property ProjectGrade As %String [ SqlColumnNumber = 3, SqlFieldName = Project_Grade ];

/// 立项名称
Property ProjectName As %String [ SqlColumnNumber = 4, SqlFieldName = Project_Name ];

/// 预计完成时间日期
Property ProjectEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Project_EndDate ];

/// 项目类型
Property ProjectType As %String [ SqlColumnNumber = 6, SqlFieldName = Project_Type ];

/// 获批科研经费
Property ProjectMoney As %String [ SqlColumnNumber = 7, SqlFieldName = Project_Money ];

/// 总负责人
Property ProjectNurOne As %String [ SqlColumnNumber = 8, SqlFieldName = Project_NurOne ];

/// 总负责人职务
Property ProjectDutyOne As %String [ SqlColumnNumber = 9, SqlFieldName = Project_DutyOne ];

/// 总负责人职称
Property ProjectTitleOne As %String [ SqlColumnNumber = 10, SqlFieldName = Project_TitleOne ];

/// 总负责人层级
Property ProjectHierarchyOne As %String [ SqlColumnNumber = 11, SqlFieldName = Project_HierarchyOne ];

/// 总负责人所在片区
Property ProjectAreaOne As %String [ SqlColumnNumber = 12, SqlFieldName = Project_AreaOne ];

/// 总负责人所在病区
Property ProjectStaAreaOne As %String [ SqlColumnNumber = 13, SqlFieldName = Project_StaAreaOne ];

/// 第二负责人
Property ProjectNurTwo As %String [ SqlColumnNumber = 14, SqlFieldName = Project_NurTwo ];

/// 第二负责人职务
Property ProjectDutyTwo As %String [ SqlColumnNumber = 15, SqlFieldName = Project_DutyTwo ];

/// 第二负责人职称
Property ProjectTitleTwo As %String [ SqlColumnNumber = 16, SqlFieldName = Project_TitleTwo ];

/// 第二负责人层级
Property ProjectHierarchyTwo As %String [ SqlColumnNumber = 17, SqlFieldName = Project_HierarchyTwo ];

/// 第二负责人所在片区
Property ProjectAreaTwo As %String [ SqlColumnNumber = 18, SqlFieldName = Project_AreaTwo ];

/// 第二负责人所在病区
Property ProjectStaAreaTwo As %String [ SqlColumnNumber = 19, SqlFieldName = Project_StaAreaTwo ];

/// 第三负责人
Property ProjectNurThree As %String [ SqlColumnNumber = 20, SqlFieldName = Project_NurThree ];

/// 其他参与者
Property ProjectNurOther As %String [ SqlColumnNumber = 21, SqlFieldName = Project_NurOther ];

/// 结题日期
Property ProjectOverDate As %Date [ SqlColumnNumber = 22, SqlFieldName = Project_OverDate ];

/// 备注
Property ProjectComment As %String [ SqlColumnNumber = 23, SqlFieldName = Project_Comment ];

/// 获奖年度
Property ProjectYear As %String [ SqlColumnNumber = 24, SqlFieldName = Project_Year ];

Index Nur On ProjectNurOne;

Index Project On ProjectName;

Index NurYear On (ProjectYear, ProjectName, ProjectNurOne);

Storage Default
{
<Data name="MgProjectManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProjectSetDate</Value>
</Value>
<Value name="3">
<Value>ProjectGrade</Value>
</Value>
<Value name="4">
<Value>ProjectName</Value>
</Value>
<Value name="5">
<Value>ProjectEndDate</Value>
</Value>
<Value name="6">
<Value>ProjectType</Value>
</Value>
<Value name="7">
<Value>ProjectMoney</Value>
</Value>
<Value name="8">
<Value>ProjectNurOne</Value>
</Value>
<Value name="9">
<Value>ProjectDutyOne</Value>
</Value>
<Value name="10">
<Value>ProjectTitleOne</Value>
</Value>
<Value name="11">
<Value>ProjectHierarchyOne</Value>
</Value>
<Value name="12">
<Value>ProjectAreaOne</Value>
</Value>
<Value name="13">
<Value>ProjectStaAreaOne</Value>
</Value>
<Value name="14">
<Value>ProjectNurTwo</Value>
</Value>
<Value name="15">
<Value>ProjectDutyTwo</Value>
</Value>
<Value name="16">
<Value>ProjectTitleTwo</Value>
</Value>
<Value name="17">
<Value>ProjectHierarchyTwo</Value>
</Value>
<Value name="18">
<Value>ProjectAreaTwo</Value>
</Value>
<Value name="19">
<Value>ProjectStaAreaTwo</Value>
</Value>
<Value name="20">
<Value>ProjectNurThree</Value>
</Value>
<Value name="21">
<Value>ProjectNurOther</Value>
</Value>
<Value name="22">
<Value>ProjectOverDate</Value>
</Value>
<Value name="23">
<Value>ProjectComment</Value>
</Value>
<Value name="24">
<Value>ProjectYear</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Work.MgProjectManageD</DataLocation>
<DefaultData>MgProjectManageDefaultData</DefaultData>
<IdLocation>^DHCNMG.Work.MgProjectManageD</IdLocation>
<IndexLocation>^DHCNMG.Work.MgProjectManageI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgProjectManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
