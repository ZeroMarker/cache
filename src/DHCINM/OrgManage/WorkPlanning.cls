/// Creater:dhh
/// Descriptions:工作规划表
/// Date:2020-07-27
Class DHCINM.OrgManage.WorkPlanning Extends %Persistent
{

/// 工作规划
Property WorkPlanning As %String [ SqlColumnNumber = 2, SqlFieldName = Work_Planning ];

/// 更新人
Property WorkPerson As CF.DHCINM.DB.MgUser [ SqlColumnNumber = 3, SqlFieldName = Work_Person ];

/// 更新日期
Property WorkDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Work_Date ];

/// 更新时间
Property WorkTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Work_Time ];

/// 状态 (保存:Y,发布:N)
Property WorkStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Work_Status ];

/// 正文【弃用】
Property WorkText As %String(MAXLEN = 1000000) [ SqlColumnNumber = 7, SqlFieldName = Work_Text ];

/// 富文本
Property ContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 8, SqlFieldName = ContentExt ];

Storage Default
{
<Data name="WorkPlanningDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkPlanning</Value>
</Value>
<Value name="3">
<Value>WorkPerson</Value>
</Value>
<Value name="4">
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>WorkTime</Value>
</Value>
<Value name="6">
<Value>WorkStatus</Value>
</Value>
<Value name="7">
<Value>WorkText</Value>
</Value>
<Value name="8">
<Value>ContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.OrgManage.WorkPlanningD</DataLocation>
<DefaultData>WorkPlanningDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.WorkPlanningD</IdLocation>
<IndexLocation>^DHCINM.OrgManage.WorkPlanningI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.WorkPlanningS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
