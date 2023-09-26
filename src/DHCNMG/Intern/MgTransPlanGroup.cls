Class DHCNMG.Intern.MgTransPlanGroup Extends %Persistent
{

/// 转科计划记录
Property PlanDR As DHCNMG.Intern.MgTransPlan [ SqlColumnNumber = 2, SqlFieldName = Plan_DR ];

/// 代码
Property GroupCode As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Code ];

/// 描述
Property GroupDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Desc ];

/// 组长
Property GroupMaster As DHCNMG.HR.MgPersons [ SqlColumnNumber = 5, SqlFieldName = Group_Master ];

/// 组员
Property GroupMember As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Group_Member ];

/// 显示顺序
Property RowSort As %Integer [ SqlColumnNumber = 7, SqlFieldName = Row_Sort ];

Index Plan On PlanDR;

Storage Default
{
<Data name="MgTransPlanGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>GroupCode</Value>
</Value>
<Value name="4">
<Value>GroupDesc</Value>
</Value>
<Value name="5">
<Value>GroupMaster</Value>
</Value>
<Value name="6">
<Value>GroupMember</Value>
</Value>
<Value name="7">
<Value>RowSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgTransPlanGroupD</DataLocation>
<DefaultData>MgTransPlanGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgTransPlanGroupD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgTransPlanGroupI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgTransPlanGF40S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
