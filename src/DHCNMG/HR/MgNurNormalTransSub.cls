Class DHCNMG.HR.MgNurNormalTransSub Extends %Persistent
{

Relationship Parref As DHCNMG.HR.MgNurNormalTrans [ Cardinality = parent, Inverse = ChildSub ];

/// 行记录
Property PlanGroupDR As DHCNMG.HR.MgNurNormativeGroup [ SqlColumnNumber = 2, SqlFieldName = Plan_GroupDR ];

/// 时段 列记录
Property PlanTimeDR As DHCNMG.HR.MgNurNormativeDate [ SqlColumnNumber = 3, SqlFieldName = Plan_TimeDR ];

/// 病区
Property PlanWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Plan_WardDR ];

/// 护士
Property PlanPerDR As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Plan_PerDR ];

Index Row On (Parref, PlanGroupDR);

Index Time On (Parref, PlanTimeDR);

Index data On (Parref, PlanGroupDR, PlanTimeDR);

Storage Default
{
<Data name="MgNurNormalTransSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupDesc</Value>
</Value>
<Value name="4">
<Value>GroupMaster</Value>
</Value>
<Value name="5">
<Value>GroupMember</Value>
</Value>
<Value name="6">
<Value>RowSort</Value>
</Value>
<Value name="7">
<Value>PlanGroupDR</Value>
</Value>
<Value name="8">
<Value>PlanTimeDR</Value>
</Value>
<Value name="9">
<Value>PlanWardDR</Value>
</Value>
<Value name="10">
<Value>PlanPerDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNormalTransSubD</DataLocation>
<DefaultData>MgNurNormalTransSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNormalTransSubI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNormalTransSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
