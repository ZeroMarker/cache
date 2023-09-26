Class DHCMGNUR.MgNurseSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship Parref As DHCMGNUR.MgNurse [ Cardinality = parent, Inverse = ChildSub, Required ];

Property WardLoc As %String(TRUNCATE = 1);

ClassMethod SaveWard(par, locward) As %String
{
   s a=##class(DHCMGNUR.MgNurseSub).%New()
   s a.Parref=##class(DHCMGNUR.MgNurse).%OpenId(par)
   s a.WardLoc=locward
   d a.%Save()
   q a.%Id()
}

// w ##class(DHCMGNUR.MgNurseSub).isWard("3","193")

ClassMethod isWard(par, locward) As %String
{
   q:par="" 0
   q:locward="" 0
   s ret=0
   s subrw=""   f  s subrw=$O(^DHCMGNUR.MgNurseD(par,"ChildSub",subrw))  q:subrw=""  d
   .s a=##class(DHCMGNUR.MgNurseSub).%OpenId(par_"||"_subrw)
   .i a.WardLoc=locward  s ret=1
   q ret
}

ClassMethod delitm(id) As %String
{
  d ##class(DHCMGNUR.MgNurseSub).%DeleteId(id)
  q 0
}

Storage Default
{
<Data name="MgNurseSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardLoc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgNurseSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurseSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurseSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
