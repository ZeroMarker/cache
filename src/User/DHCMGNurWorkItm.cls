Class User.DHCMGNurWorkItm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property WorkItm As %String(TRUNCATE = 1);

Property WorkCode As %String(TRUNCATE = 1);

Property WorkDistill As %Library.String(DISPLAYLIST = ",WorkLoad,Attention,OutIn,Qt", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",W,A,O,Q");

Property WorkRelItm As %Library.String(DISPLAYLIST = ",Instruct,Hours,Days,Persons,Num", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,H,D,P,N");

Property WorkPercent As %String(TRUNCATE = 1);

Property WorkMeth As %String(TRUNCATE = 1);

Property CurrFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index TYP On WorkDistill;

ClassMethod gettypitm(typ)
{
   s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI(typ,rw)) q:rw=""  d
   .s a=^User.DHCMGNurWorkItmD(rw)
   .s itm=$listget(a,4)
}

ClassMethod save(parr As %String) As %String
{
   	s id=$P(parr,"^",1)
   	s WorkItm=$P(parr,"^",2)
   	s WorkCode=$P(parr,"^",3)
   	s WorkDistill=$P(parr,"^",4)
   	s WorkRelItm=$P(parr,"^",5)
   	s WorkMeth=$P(parr,"^",6)
  	s WorkPercent=$P(parr,"^",7)
   	s CurrFlag=$P(parr,"^",8)
   	if id="" s a=##class(User.DHCMGNurWorkItm).%New()
   	e  s a=##class(User.DHCMGNurWorkItm).%OpenId(id)
   	s a.WorkItm=WorkItm
   	s a.WorkCode=WorkCode
   	s a.WorkDistill=WorkDistill
   	s a.WorkRelItm=WorkRelItm
   	s a.WorkMeth=WorkMeth
   	s a.WorkPercent=WorkPercent
   	s a.CurrFlag=CurrFlag
   	d a.%Save()

   q 0
}

Storage Default
{
<Data name="DHCMGNurWorkItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkCode</Value>
</Value>
<Value name="3">
<Value>WorkDistill</Value>
</Value>
<Value name="4">
<Value>WorkItm</Value>
</Value>
<Value name="5">
<Value>WorkPercent</Value>
</Value>
<Value name="6">
<Value>WorkRelItm</Value>
</Value>
<Value name="7">
<Value>CurrFlag</Value>
</Value>
<Value name="8">
<Value>WorkMeth</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurWorkItmD</DataLocation>
<DefaultData>DHCMGNurWorkItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurWorkItmD</IdLocation>
<IndexLocation>^User.DHCMGNurWorkItmI</IndexLocation>
<StreamLocation>^User.DHCMGNurWorkItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
