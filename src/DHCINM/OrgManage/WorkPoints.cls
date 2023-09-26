/// Creater:dhh
/// Descriptions:工作重点表
/// Date:2020-07-27
Class DHCINM.OrgManage.WorkPoints Extends %Persistent
{

/// 工作计划
Property WorkPoint As %String [ SqlColumnNumber = 2, SqlFieldName = Work_Point ];

/// 更新人
Property WorkPerson As CF.DHCINM.DB.MgUser [ SqlColumnNumber = 3, SqlFieldName = Work_Person ];

/// 更新日期
Property WorkDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Work_Date ];

/// 计划类型(年度:Y 半年:HY 季度:Q 月度:M)
Property WorkType As %String [ SqlColumnNumber = 5, SqlFieldName = Work_Type ];

/// 状态 (保存:Y,发布:N)
Property WorkStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Work_Status ];

/// 年份
Property WorkYear As %Date [ SqlColumnNumber = 7, SqlFieldName = Work_Year ];

/// 正文【弃用】
Property WorkText As %String(MAXLEN = 1000000) [ SqlColumnNumber = 8, SqlFieldName = Work_Text ];

/// 富文本
Property ContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 9, SqlFieldName = ContentExt ];

Index YearType On (WorkYear, WorkType);

Storage Default
{
<Data name="WorkPointsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkPoint</Value>
</Value>
<Value name="3">
<Value>WorkPerson</Value>
</Value>
<Value name="4">
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>WorkType</Value>
</Value>
<Value name="6">
<Value>WorkStatus</Value>
</Value>
<Value name="7">
<Value>WorkYear</Value>
</Value>
<Value name="8">
<Value>WorkText</Value>
</Value>
<Value name="9">
<Value>ContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.OrgManage.WorkPointsD</DataLocation>
<DefaultData>WorkPointsDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.WorkPointsD</IdLocation>
<IndexLocation>^DHCINM.OrgManage.WorkPointsI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.WorkPointsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
