Class User.DHCMGMoudleSub Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_MoudleSub ]
{

Relationship MouldParRef As User.DHCMGMoudle [ Cardinality = parent, Inverse = ChildSub, Required ];

Property subname As %String(TRUNCATE = 1);

Property subcode As %String(TRUNCATE = 1);

Property subtyp As %String(TRUNCATE = 1);

ClassMethod save(parr As %String) As %String
{
  //##class(User.DHCMGMoudleSub).save()
 // s parr="59^NurseManager.frmEmrData|WinTmpver111itm11fold1NODsdfdsfdsfdsf^意外事件"
  s par=$P(parr,"^",1)
  s row=$P(parr,"^",4)
  s name=$P(parr,"^",2)
  s code=$P(parr,"^",3)
  s typ=$P(parr,"^",5)
  if par="" q 0
  b
  s pobj=##class(User.DHCMGMoudle).%OpenId(par)
  b
  if row=""  s a=##class(User.DHCMGMoudleSub).%New()
  e  s a=##class(User.DHCMGMoudleSub).%OpenId(row)
  s a.MouldParRef=pobj
  s a.subname=name
  s a.subcode=code
  s a.subtyp=typ
  d a.%Save()
  q 0
}

ClassMethod del(rw) As %String
{
   s a=##class(User.DHCMGMoudleSub).%DeleteId(rw)
   q 0
}

Storage Default
{
<Data name="DHCMGMoudleSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>subcode</Value>
</Value>
<Value name="3">
<Value>subname</Value>
</Value>
<Value name="4">
<Value>subtyp</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGMoudleSubD</DataLocation>
<DefaultData>DHCMGMoudleSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGMoudleSubD</IdLocation>
<IndexLocation>^User.DHCMGMoudleSubI</IndexLocation>
<StreamLocation>^User.DHCMGMoudleSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
