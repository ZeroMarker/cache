Class User.DHCMGNurWorkRelatItm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property WorkItm As User.DHCMGNurWorkItm;

Property WorkRelInstruct As %String(TRUNCATE = 1);

Property WorkRelArcim As %String(TRUNCATE = 1);

Index WorkItm On WorkItm;

Index ItmArcimInstr On WorkRelArcim;

ClassMethod SaveWorkItmRelItm(parr As %String) As %String
{
        // s b=##class(User.DHCMGNurWorkRelatItm).SaveWorkItmRelItm("10^27124||1")
		s WorkItm=$P(parr,"^",1)
		s WorkRelArcim=$P(parr,"^",2)
        s WorkRelInstruct=$P(parr,"^",3)
		s a=##class(User.DHCMGNurWorkRelatItm).%New()

        s a.WorkItm=##class(User.DHCMGNurWorkItm).%OpenId(WorkItm)
        
        s a.WorkRelArcim=WorkRelArcim
        s a.WorkRelInstruct=WorkRelInstruct
       d a.%Save()

	  
  q 0
}

ClassMethod DeleteWorkItmRelItm(rw As %String) As %String
{
        // s b=##class(User.DHCMGNurWorkRelatItm).DeleteWorkItmRelItm("33")
		d ##class(User.DHCMGNurWorkRelatItm).%DeleteId(rw)

	  
  q 0
}

Storage Default
{
<Data name="DHCMGNurWorkRelatItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItm</Value>
</Value>
<Value name="3">
<Value>WorkRelArcim</Value>
</Value>
<Value name="4">
<Value>WorkRelInstruct</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurWorkRelatItmD</DataLocation>
<DefaultData>DHCMGNurWorkRelatItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurWorkRelatItmD</IdLocation>
<IndexLocation>^User.DHCMGNurWorkRelatItmI</IndexLocation>
<StreamLocation>^User.DHCMGNurWorkRelatItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
