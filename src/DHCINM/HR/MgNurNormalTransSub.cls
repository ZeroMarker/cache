Class DHCINM.HR.MgNurNormalTransSub Extends %Persistent
{

Relationship Parref As DHCINM.HR.MgNurNormalTrans [ Cardinality = parent, Inverse = ChildSub ];

/// 行记录
Property PlanGroupDR As DHCINM.HR.MgNurNormativeGroup [ SqlColumnNumber = 2, SqlFieldName = Plan_GroupDR ];

/// 时段 列记录
Property PlanTimeDR As DHCINM.HR.MgNurNormativeDate [ SqlColumnNumber = 3, SqlFieldName = Plan_TimeDR ];

/// 病区
Property PlanWardDR As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Plan_WardDR ];

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
<Value>PlanGroupDR</Value>
</Value>
<Value name="3">
<Value>PlanTimeDR</Value>
</Value>
<Value name="4">
<Value>PlanWardDR</Value>
</Value>
<Value name="5">
<Value>PlanPerDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgNurNormalTransSubDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurNormalTransC("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurNormalTransSubI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurNormalTransSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
