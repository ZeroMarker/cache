/// Creator:gzj
/// Date:2018-11-20
/// Description:助护 学员轮转记录子表
Class DHCNMG.Train.MgNurTransPlanSub Extends %Persistent
{

Relationship Parref As DHCNMG.Train.MgNurTransPlan [ Cardinality = parent, Inverse = ChildSub ];

/// 护士【人员表ID】
Property TransNurse As %String [ SqlColumnNumber = 2, SqlFieldName = Trans_Nurse ];

/// 所在病区
Property TransDepDR As %String [ SqlColumnNumber = 3, SqlFieldName = Trans_DepDR ];

Index nurse On (Parref, TransNurse);

Storage Default
{
<Data name="MgNurTransPlanSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransNurse</Value>
</Value>
<Value name="3">
<Value>TransDepDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Train.MgNurTransPlanSubD</DataLocation>
<DefaultData>MgNurTransPlanSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Train.MgNurTransPlanSubI</IndexLocation>
<StreamLocation>^DHCNMG.Train.MgNurTransPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
