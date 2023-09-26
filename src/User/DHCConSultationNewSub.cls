Class User.DHCConSultationNewSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship Parref As User.DHCConSultationNew [ Cardinality = parent, Inverse = SubRecord ];

Property ConsultDep As %String;

Property RequestConDoc As %String;

Property DocGrade As %String;

/// 会诊科室 CT_Loc
Property ItmConsultDep As %String;

Index ConsultDep On (Parref, ConsultDep);

Storage Default
{
<Data name="DHCConSultationNewSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultDep</Value>
</Value>
<Value name="3">
<Value>RequestConDoc</Value>
</Value>
<Value name="4">
<Value>DocGrade</Value>
</Value>
<Value name="5">
<Value>ItmConsultDep</Value>
</Value>
</Data>
<DataLocation>^User.DHCConSultationNewSubD</DataLocation>
<DefaultData>DHCConSultationNewSubDefaultData</DefaultData>
<IdLocation>^User.DHCConSultationNewSubD</IdLocation>
<IndexLocation>^User.DHCConSultationNewSubI</IndexLocation>
<StreamLocation>^User.DHCConSultationNewSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
