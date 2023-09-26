Class User.GetDetail Extends %Persistent
{

ClassMethod GetDetail()
{
	
 s prtid=0,num=0
 f  s prtid=$o(^DHCSFPRINTDETAIL(prtid)) q:prtid=""  d
 .s date=$p(^DHCSFPRINTDETAIL(prtid),"^",2)
 .s amount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
 .s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
 .s admid=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
 .q:admid=""
 .s personid=0
 .i $d(^PAADM(admid)) s personid=$p(^PAADM(admid),"^",1)
 .q:personid="" 
 .i $d(^PAPER(personid,"ALL")) d
 ..s name=$p(^PAPER(personid,"ALL"),"^",1)
 ..s no=$p(^PAPER(personid,"PAT",1),"^",1)
 .s num=num+1
 .w !,$zd(date,3)_"^"_name_"^"_no_"^"_amount_"^"_paymode
 q num
}

Storage Default
{
<Data name="GetDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.GetDetailD</DataLocation>
<DefaultData>GetDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.GetDetailD</IdLocation>
<IndexLocation>^User.GetDetailI</IndexLocation>
<StreamLocation>^User.GetDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
