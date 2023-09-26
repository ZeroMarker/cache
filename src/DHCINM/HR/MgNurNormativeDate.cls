/// Creator:gzj
/// Date:2018-11-12
/// Description:规培生的轮转日期
Class DHCINM.HR.MgNurNormativeDate Extends %Persistent
{

Relationship DateParref As DHCINM.HR.MgNurNormalTrans [ Cardinality = parent, Inverse = DateSub ];

/// 开始日期
Property PlanStDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Plan_StDate ];

/// 结束日期
Property PlanEndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Plan_EndDate ];

Index Plan On (DateParref, PlanStDate);

Storage Default
{
<Data name="MgNurNormativeDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanStDate</Value>
</Value>
<Value name="3">
<Value>PlanEndDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DateSub")</DataLocation>
<DefaultData>MgNurNormativeDateDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurNormalTransC("DateSub")</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurNormativeDateI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurNormativeDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
