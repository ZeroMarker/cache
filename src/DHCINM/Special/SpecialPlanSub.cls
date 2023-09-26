/// Creater:wangpf
/// Descriptions:专业组工作计划子表
/// Date:2020-07-21
Class DHCINM.Special.SpecialPlanSub Extends %Persistent
{

Relationship Parref As DHCINM.Special.SpecialPlan [ Cardinality = parent, Inverse = ChildSub ];

/// 开始日期
Property SubStDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Sub_StDate ];

/// 结束日期
Property SubEndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Sub_EndDate ];

/// 任务
Property SubMission As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Sub_Mission ];

/// 目标
Property SubTarget As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Sub_Target ];

/// 措施
Property SubStep As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = Sub_Step ];

/// 负责人
Property SubCharger As CF.DHCINM.HR.Persons [ SqlColumnNumber = 7, SqlFieldName = Sub_Charger ];

Index StDate On (Parref, SubStDate, SubEndDate);

Storage Default
{
<Data name="SpecialPlanSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubStDate</Value>
</Value>
<Value name="3">
<Value>SubEndDate</Value>
</Value>
<Value name="4">
<Value>SubMission</Value>
</Value>
<Value name="5">
<Value>SubTarget</Value>
</Value>
<Value name="6">
<Value>SubStep</Value>
</Value>
<Value name="7">
<Value>SubCharger</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialPlanSubD</DataLocation>
<DefaultData>SpecialPlanSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialPlanSubI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
