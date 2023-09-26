Class web.DHCBZTCLASS1 Extends %RegisteredObject
{

ClassMethod GetDepositDetail()
{
GetDepositDetail()   
 s prtrowid=0,num=0,adm=0  
 f  s prtrowid=$O(^DHCSFPRINTDETAIL(prtrowid)) quit:prtrowid=""  do
 .s prtdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
 .s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
 .s adm=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
 .q:adm=""
 .s temp=..GetInfo(adm)
 .s papname=$p(temp,"^",1)
 .s papno=$p(temp,"^",2)
 .s payamt=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
 .s num=num+1
 .w !,$zd(prtdate,3)_"^"_$zt(prttime,1)_"^"_papname_"^"_papno_"^"_payamt
 q num
}

ClassMethod GetInfo(adm)
{
	s papmi=""
 i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
 .q:papmi=""
 .i $d(^PAPER(papmi,"ALL")) d 
 ..s papname=$p(^PAPER(papmi,"ALL"),"^",1)
 ..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
 q papname_"^"_papno
}

}
