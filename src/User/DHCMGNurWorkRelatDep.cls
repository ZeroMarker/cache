Class User.DHCMGNurWorkRelatDep Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property WorkItm As User.DHCMGNurWorkItm;

Property WorkRelDep As %String(TRUNCATE = 1);

Property WorkRelDepPercent As %String(TRUNCATE = 1);

Index WorkItm On WorkItm;

Index ItmRelatDep On WorkRelDep;

ClassMethod SaveRelDep(para As %String) As %String
{
  	// s parr="1^211^3"
  	s ItmId=$P(para,"^",1)
  	s dep=$P(para,"^",2)
  	s percent=$P(para,"^",3)
  	i $D(^User.DHCMGNurWorkRelatDepI(" "_dep))>0 q ""
	s a=##class(User.DHCMGNurWorkRelatDep).%New()
   	s a.WorkItm=##class(User.DHCMGNurWorkItm).%OpenId(ItmId)
   	s a.WorkRelDep=dep //##class(User.CTLoc).%OpenId(dep)
   	s a.WorkRelDepPercent=percent
   	d a.%Save()
   	q 0
}

ClassMethod DelRelDep(id As %String) As %String
{
	d ##class(User.DHCMGNurWorkRelatDep).%DeleteId(id)
	q 0
}

Storage Default
{
<Data name="DHCMGNurWorkRelatDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItm</Value>
</Value>
<Value name="3">
<Value>WorkRelDep</Value>
</Value>
<Value name="4">
<Value>WorkRelDepPercent</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurWorkRelatDepD</DataLocation>
<DefaultData>DHCMGNurWorkRelatDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurWorkRelatDepD</IdLocation>
<IndexLocation>^User.DHCMGNurWorkRelatDepI</IndexLocation>
<StreamLocation>^User.DHCMGNurWorkRelatDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
