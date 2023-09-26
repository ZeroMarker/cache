Import SQLUser

Class web.UDHCJFQfDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

ClassMethod getpatinfo(adm As %Library.String = "")
{
 ;d ##class(web.UDHCJFZYFTZDs).getpatinfo("","","18292")
 s adm=$g(adm)
 q:(adm="") ""
 s rstr=""
 s admreason=$p(^PAADM(adm,1),"^",7)
 i admreason'=""  s admreason=$p(^PAC("ADMREA",admreason),"^",2)
 s admdate=$p(^PAADM(adm),"^",6)
 s dischdate=$p(^PAADM(adm),"^",59)
 s enddate=dischdate
 i enddate=""  s enddate=$h
 s days=+enddate-(+admdate)
 i admdate'=""  s admdate=$zd(admdate,3)
 i dischdate'=""  s dischdate=$zd(dischdate,3)
 s doc=$p($p(^PAADM(adm),"^",9),$c(1))
 i doc'=""  d
 .i $d(^CTPCP(doc))=0  s doc=""
 .i $d(^CTPCP(doc))'=0  d
 ..s doc=$p($g(^CTPCP(doc,1)),"^",2)
 s ward=$p($p(^PAADM(adm),"^",70),$c(1))
 i ward'=""  d
 .i $d(^PAWARD(ward))=0  s ward=""
 .i $d(^PAWARD(ward))'=0  d
 ..s ward=$p($p($g(^PAWARD(ward)),"^",2),"-",2)
 s admks=$p(^PAADM(adm),"^",4)
 i admks=""  s admdeptdesc=""
 i admks'=""  d
 .i $d(^CTLOC(admks))=0  s admdeptdesc=""
 .i $d(^CTLOC(admks))'=0  d
 ..s admdeptdesc=$p(^CTLOC(admks),"^",2)
 ..i admdeptdesc'=""  d
 ...i $f(admdeptdesc,"-")'=0  s admdeptdesc=$p(admdeptdesc,"-",2)
 s bed=$p(^PAADM(adm),"^",73)
 i bed'=""  d
 .q:($d(^PAWARD($p(bed,"||",1),"BED",$p(bed,"||",2)))=0)
 .s bed=$p(^PAWARD($p(bed,"||",1),"BED",$p(bed,"||",2)),"^",1)
 s papmidr=$p($p(^PAADM(adm),"^",1),$c(1))
 i papmidr'=""  d
 .s name=$p(^PAPER(papmidr,"ALL"),"^",1)
 .s regno=$p(^PAPER(papmidr,"PAT",1),"^",1)
 .&sql(select PAPMI_PAPER_DR into:paperdr from pa_patmas where papmi_rowid=:papmidr)
 .&sql(select paper_foreignaddress into :workst from pa_person where paper_rowid=:paperdr)	
 .s admnum=0
 .s admno=""
 .f  s admno=$o(^PAPERdr(papmidr,"ADM","I",admno)) q:admno=""  d
 ..i $d(^PAADM(admno))'=0  d
 ...s admnum=admnum+1
 .i $d(^PAPER(papmidr,"PAT",3))=0  d
 ..s Medicare=""
 .e  i $d(^PAPER(papmidr,"PAT",3))=10  d       
 ..s Medicare=""
 .e  d
 ..s Medicare=$p(^PAPER(papmidr,"PAT",3),"^",4)
 .s sex=$p($p(^PAPER(papmidr,"ALL"),"^",7),$c(1))
 .i sex'=""  d
 ..i $d(^CT("SEX",sex))'=0  d
 ...s sex=$p(^CT("SEX",sex),"^",2)
 .s idcard=$p(^PAPER(papmidr,"ALL"),"^",9)
 .s paperdr=$p(paperdr,$c(1))
 .&sql(select paper_dob,paper_ageyr,paper_agemth,paper_ageday into :patdob,:patageyr,:patagemth,:patageday 
	       from pa_person where paper_rowid=:paperdr)
 .i patdob'=""  s patdob=$zd(patdob,3)
 .i patageyr=""  s patageyr=0
 .i patagemth=""  s patagemth=0
 .i patageday=""  s patageday=0
 .i patageyr=0  d
 ..i patagemth=0  d
 ...i patageday=0  d
 ....s agedesc=""
 ...e  d
 ....s agedesc=patageday_"天"
 ..e  d
 ...s agedesc=patagemth_"月"
 .e  d
 ..s agedesc=patageyr
 .s (mardr,mardesc,rlgdr,rlgdesc,nationdr,nationdesc,str,foreignid)=""
 .i $d(^PAPER(paperdr,"PER",2))'=0 
 ..s str=$g(^PAPER(paperdr,"PER",2))
 ..i str'=""  d
 ...s mardr=$p(str,"^",3)
 ...s rlgdr=$p(str,"^",2)
 ...s nationdr=$p(str,"^",1)
 ...s foreignid=$p(str,"^",13)
 ...i ((mardr'="")&&($d(^CT("MAR",mardr))'=0))  d
 ....s mardesc=$p(^CT("MAR",mardr),"^",2)
 ...i ((rlgdr'="")&&($d(^CT("RLG",rlgdr))'=0))  d
 ....s rlgdesc=$p(^CT("RLG",rlgdr),"^",2)
 ...i ((nationdr'="")&&($d(^CT("NAT",nationdr))'=0))  d
 ....s nationdesc=$p(^CT("NAT",nationdr),"^",2)
 .s (mobpone,email,company,provincedr,provincedesc,str)=""
 .i $d(^PAPER(paperdr,"PER",4))'=0  d
 ..s str=$g(^PAPER(paperdr,"PER",4))
 ..i str'=""  d
 ...s provincedr=$p($p(str,"^",2),$c(1))
 ...s mobpone=$p(str,"^",21)
 ...s email=$p(str,"^",19)
 ...s company=$p(str,"^",18)
 ...i ((provincedr'="")&&($d(^CT("PROV",provincedr))'=0))  d
 ....s provincedesc=$p(^CT("PROV",provincedr),"^",2)
 .s (citydr,citydesc,zipdr,zipdesc,hometel,worktel,SocSatdr,SocSatdesc,str)=""
 .i $d(^PAPER(paperdr,"PER",1))'=0  d
 ..s str=$g(^PAPER(paperdr,"PER",1))
 ..i str'="" d
 ...s citydr=$p(str,"^",5)
 ...s zipdr=$p(str,"^",7)
 ...s hometel=$p(str,"^",11)
 ...s worktel=$p(str,"^",9)
 ...s SocSatdr=$p(str,"^",10)
 ...i ((SocSatdr'="")&&($d(^CT("SS",SocSatdr))'=0)&&($d(^CT("SS",SocSatdr))'=10))  d
 ....s SocSatdesc=$p(^CT("SS",SocSatdr),"^",2)
 ...i ((zipdr'="")&&($d(^CT("ZIP",zipdr))'=0))  d
 ....s zipdesc=$p(^CT("ZIP",zipdr),"^",1)
 ...i ((citydr'="")&&($d(^CT("CIT",citydr))'=0)&&($d(^CT("CIT",citydr))'=10)) d
 ....s citydesc=$p(^CT("CIT",citydr),"^",2)
 ....i $f(citydesc,"-")'=0  d
 .....s citydesc=$p(citydesc,"-",2)
 .i $d(^PAPER(paperdr,"PER","ADD"))=0  d
 ..s address=""
 .e  d
 ..s address=$g(^PAPER(paperdr,"PER","ADD",1))

 s rstr=admdate_"^"_dischdate_"^"_admdeptdesc_"^"_workst_"^"_bed_"^"_name_"^"_regno_"^"_admreason_"^"_days
 s rstr=rstr_"^"_mobpone_"^"_email_"^"_company_"^"_provincedesc_"^"_mardesc_"^"_rlgdesc_"^"_nationdesc_"^"_agedesc_"^"_patdob
 s rstr=rstr_"^"_Medicare_"^"_sex_"^"_idcard_"^"_admnum_"^"_ward_"^"_doc_"^"_citydesc_"^"_zipdesc_"^"_hometel_"^"_worktel
 s rstr=rstr_"^"_SocSatdesc_"^"_address_"^"_foreignid
 q rstr
}

ClassMethod getqfpatcate(billNo As %Library.String = "")
{
 ;取DHC_TAREC 核算分类
 k ^tmpincate("qfat",$j),P9,mPLIST
 q:(billNo="") ""
 s stdate=0
 s enddate=+$h
 s tmpstr=""
 s n=1
 s rowid="0"
 f  s rowid=$o(^DHCTarC("TIC",rowid))  q:rowid=""  d
 .i $g(^tmpincate($j))="" s ^tmpincate($j)=0
 .s icdesc=$p(^DHCTarC("TIC",rowid),"^",2)
 .s ^tmpincate($j,n)=$p(rowid,$c(1))_"^"_icdesc
 .s mPLIST(n)=$p(rowid,$c(1))_"^"_icdesc
 .s ^tmpincate($j)=n
 .s n=n+1
 s P9=n-1
 s qfrowid=""
 s qfsum=0
 f  s qfrowid=$o(^DHCJFQFTOTAL(0,"Pbdr",billNo,qfrowid)) q:qfrowid=""  d
 .q:($d(^DHCJFQFTOTAL(qfrowid))=0)
 .s status=$p($g(^DHCJFQFTOTAL(qfrowid)),"^",8)
 .q:status=""
 .s amt=+$p($g(^DHCJFQFTOTAL(qfrowid)),"^",4)
 .s flag=$p($g(^DHCJFQFTOTAL(qfrowid)),"^",5)
 .i flag="Q"  s qfsum=+qfsum+amt
 .i falg="B"  s qfsum=+qfsum-amt
 q:$d(^DHCPB(billNo))=0
 i $d(^DHCPB(billNo))'=0  d
 .s pbpayflag=$p($g(^DHCPB(billNo)),"^",16)
 .s adm=$p($g(^DHCPB(billNo)),"^",1)
 i pbpayflag="P"  d
 .s patdeposit=##class(web.UDHCJFBaseCommon).arpbldeposit(billNo)
 i ((pbpayflag="B")&&(adm'=""))  d
 .s patdeposit=##class(web.UDHCJFBaseCommon).deposit(adm)
 i patdeposit=""  s patdeposit=0.00
 s tmpstr=..geticfee(billNo,stdate,enddate)
 s yeamt=0
 i ((tmpstr'="")&&(+qfsum=0))  d
 .s totalsum=$p(tmpstr,"##",2)
 .i totalsum=""  s totalsum=0
 .s qfsum=totalsum-patdeposit
 s tmpstr=tmpstr_"##"_$j(patdeposit,3,2)_"##"_$j(qfsum,3,2)_"##"_P9
 k ^tmpincate($j)
 q tmpstr
}

ClassMethod add(val1 As %Library.String = "", val2 As %Library.String = "", adm)
{
  q:((val1="")&&(val2="")) 0
   s remain1=$g(val1)
   s remain2=$g(val2)
   s ^tmpzl("qfremain",adm)=remain1_"^"_remain2	
   q 1_"^"_$j
}

ClassMethod getnote(Adm)
{
  s job=$g(job)
   q:job="" ""
   s str=""
   s str=$g(^tmpzl("qfremain",Adm))
   kill ^tmpzl("qfremain",Adm)
   q str
}

ClassMethod geticfee(billNo, stdate, enddate)
{
	   s ordsub=""
	   s incate=""
	   s test=0
	   k P1,P2
	   k mPLIST,PLIST
	   k ^TMPCACHE("PB",$j)
	   k ^TMP("ZYJF",$j)
	   s billNo=$g(billNo)
	   q:billNo=""
	   s totalsum=0
	   f i=1:1:$g(^tmpincate($j)) d
	   .s itmfee(i)=0
	   f  s ordsub=$o(^DHCPB(billNo,"O",ordsub)) q:ordsub=""  d
	   .q:ordsub=0
	   .s oerowid=$p(^DHCPB(billNo,"O",ordsub),"^",4)
	   .q:'$d(^OEORD($p(oerowid,"||",1),"I",$p(oerowid,"||",2)))
	   .s detsub="0"
	   .f  s detsub=$o(^DHCPB(billNo,"O",ordsub,"D",detsub))  q:detsub=""  d
	   ..s billdate=$p(^DHCPB(billNo,"O",ordsub,"D",detsub),"^",11)    ;收费日期
	   ..q:(billdate<stdate)
	   ..q:(billdate>enddate)
	   ..s taritem=$p(^DHCPB(billNo,"O",ordsub,"D",detsub),"^",3)     ;收费项目
	   ..s unitprice=$p(^DHCPB(billNo,"O",ordsub,"D",detsub),"^",4)   ;单价
	   ..s qty=$p(^DHCPB(billNo,"O",ordsub,"D",detsub),"^",5)         ;数量
	   ..s totalamount=$p(^DHCPB(billNo,"O",ordsub,"D",detsub),"^",7) ;总额
	   ..i totalamount=""  s totalamount=0
	   ..s totalsum=totalsum+totalamount
	   ..i taritem'="" s inpatcate=$p(^DHCTARI(taritem),"^",14)     ;住院费用子分类         
	   ..s icate=$p(^DHCTarC("IC",inpatcate),"^",3)                 ;住院费用大类
	   ..f i=1:1:$g(^tmpincate($j)) d
	   ...i $p(icate,$c(1))=$p($p(^tmpincate($j,i),"^",1),$c(1)) d
	   ....s itmfee(i)=totalamount+itmfee(i)
	   ...e  s test=totalamount
	   s tmpstr=""
	   f i=1:1:$g(^tmpincate($j)) d
	   .s mPLIST(i)=$p(^tmpincate($j,i),"^",1)_"^"_$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)
	   .s PLIST(i)=$p(^tmpincate($j,i),"^",2)_"^"_$j(itmfee(i),3,2)_"^"_$p(^tmpincate($j,i),"^",1)
	   .s ^TMP("ZYJF",$j,i)=PLIST(i)
	   .s tmpstr=tmpstr_"&"_PLIST(i)
	   s P1=$g(^tmpincate($j))
	   s tmpstr=tmpstr_"##"_totalsum
	   q tmpstr
}

ClassMethod getadm(papno)
{
    i papno'="" s papno=$g(papno)
    s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	s papmi=""
	s str=""
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",papno,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus="A"
	..s str=name_"^"_Adm
   i str=""  s str="^"
   q str
}

ClassMethod findqfdetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findqfdetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findqfdetailExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s pb=$g(BillNo)
	s qfsum=0
	q:pb=""
	n date,amt,invno,user,qfsum,flag,status
	s qfid=""
	f  s qfid=$o(^DHCJFQFTOTAL(0,"Pbdr",pb,qfid)) q:qfid=""  d
	.q:$d(^DHCJFQFTOTAL(qfid))=0
	.s flag=$p($g(^DHCJFQFTOTAL(qfid)),"^",5)
	.s status=$p($g(^DHCJFQFTOTAL(qfid)),"^",8)
	.q:status=""
	.i flag="Q"  s qfsum=$p($g(^DHCJFQFTOTAL(qfid)),"^",4)
	.i flag="B"  d
	..s amt=$p($g(^DHCJFQFTOTAL(qfid)),"^",4)
	..s date=$p($g(^DHCJFQFTOTAL(qfid)),"^",2)
	..i date'=""  s date=$zd(date,3)
	..s user=$p($g(^DHCJFQFTOTAL(qfid)),"^",6)
	..i ((user'="")&&($d(^SSU("SSUSR",user))'=0))  s user=$p($g(^SSU("SSUSR",user)),"^",2)
	..s prtid=$p($g(^DHCJFQFTOTAL(qfid)),"^",9)
	..i ((prtid'="")&&($d(^DHCINVPRTZY(prtid))'=0))  s invno=$p($g(^DHCINVPRTZY(prtid)),"^",1)
	..i qfsum'=""  s qfsum=+qfsum-(+amt)
 	d outputrow3
 	s qHandle=$lb(0,repid,0)
  	quit $$$OK
outputrow3
	set Data=$lb(date,amt,invno,user,qfsum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findqfdetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findqfdetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query findqfdetail(BillNo As %String) As %Query(ROWSPEC = "Trefdate:%String,Trefamt:%String,Trcptno:%String,Tuser:%String,Tqfye:%String")
{
}

ClassMethod findadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findadmExecute(ByRef qHandle As %Binary, regno As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	
	s regno=$g(regno)
	q:regno="" 
	s papmi=""
    f  s papmi=$o(^PAPERi("PAPMI_PatNo",regno,papmi)) q:papmi=""  d
    .q:$d(^PAPER(papmi))=0
    s adm=""
    f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm)) q:adm=""  d
    .q:$d(^PAADM(adm))=0
    .d outputrow1 
 	s qHandle=$lb(0,repid,0)
  	quit $$$OK
outputrow1
	set Data=$lb(adm,ind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findadmExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query findadm(regno As %String) As %Query(ROWSPEC = "adm:%String,ind:%String")
{
}

ClassMethod findbillClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findbillExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findbillExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	
	s adm=$g(adm)
	q:adm="" 
	s pb=""
    f  s pb=$o(^DHCPB(0,"ADM",adm,pb)) q:pb=""  d
    .q:$d(^DHCPB(pb))=0
    .s reflag=$p($g(^DHCPB(pb)),"^",17)
    .q:((reflag="R")||(reflag="B"))
    .d outputrow2 
 	s qHandle=$lb(0,repid,0)
  	quit $$$OK
outputrow2
	set Data=$lb(pb,ind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findbillFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findbillExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query findbill(adm As %String) As %Query(ROWSPEC = "pb:%String,ind:%String")
{
}

ClassMethod findqfdjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findqfdjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findqfdjExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, locid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s stdate=$g(StDate)
	s enddate=$g(EndDate)
	i stdate=""  s stdate=$h
	i enddate=""  s enddate=$h
	s (dept,name,papno,admdate,chgdate,prtdate,rcptno,pay,feeamt,remain,job)=""
	s stloc=$g(locid)
	s job=$j
	s resum="",remain=""
	for disdate=stdate:1:enddate   d
	.s prtrowid=""
	.f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",disdate,prtrowid))  q:prtrowid=""   d
	..s admid=$p(^DHCINVPRTZY(prtrowid),"^",4)
	..s paysum=0,feeamt=0
	..s pay=0,feeamt="",reamt=""
	..s qfid=$o(^DHCJFQFTOTAL(0,"Adm",admid,""))
	..q:(qfid="")
	..i $d(^DHCJFQFTOTAL(qfid))  s qfflag=$p($g(^DHCJFQFTOTAL(qfid)),"^",5)
	..q:$g(qfflag)'["Q"
	..s papmi=$p($g(^PAADM(admid)),"^",1)
	..s admdate=$p($g(^PAADM(admid)),"^",6)
	..i admdate'=""  s admdate=$zd(admdate,3)
	..s chgdate=$p($g(^PAADM(admid)),"^",17)
	..i chgdate'=""  s chgdate=$zd(chgdate,3)
	..s dept=$p($g(^PAADM(admid)),"^",4)
	..i ((dept'="")&&($d(^CTLOC(dept))))  s dept=$p($g(^CTLOC(dept)),"^",2)
	..i ((papmi'="")&&($d(^PAPER(papmi))))  d
	...s name=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...s papno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	..s prtid=""
	..s n=0
	..f  s prtid=$o(^DHCSFPRINTDETAIL(0,"adm",admid,prtid))  q:prtid=""   d
	...s rcptno=$p($g(^DHCSFPRINTDETAIL(prtid)),"^",1)
	...s prtdate=$p($g(^DHCSFPRINTDETAIL(prtid)),"^",2)
	...s prttime=$p($g(^DHCSFPRINTDETAIL(prtid)),"^",3)
	...i prtdate'=""  s prtdate=$zd(prtdate,3)_" "_$zt(prttime,1)
	...s payamt=$p($g(^DHCSFPRINTDETAIL(prtid)),"^",6)
	...s paysum=paysum+payamt
	...s pay=+payamt
	...s n=n+1
    ...s remain=""
    ...d outputrow4 
    ..s prtdate=$p(^DHCINVPRTZY(prtrowid),"^",2)
    ..s prttime=$p(^DHCINVPRTZY(prtrowid),"^",3)
    ..s prtdate=$zd(prtdate,3)_" "_$zt(prttime,1)
    ..s pb=""
    ..f  s pb=$o(^DHCPB(0,"ADM",admid,pb)) q:pb=""  d
    ...q:'($d(^DHCPB(pb)))
    ...s fee=$p($g(^DHCPB(pb)),"^",8)
    ...s feeamt=+feeamt+fee 
    ..if +feeamt+(+paysum)'=0   d
    ...s reamt=+paysum-(+feeamt)
    ...s remain=+reamt
    ...s resum=+resum+(+reamt)
    ...s pay=+paysum
    ...d outputrow4
    s dept="合计"
    s n=0
    s (name,papno,admdate,chgdate,rcptno,pay,feeamt,prtdate)=""
    s remain=+resum
    d outputrow4
    set ^tmp("qfdjzl",$j)=ind-1
 	s qHandle=$lb(0,repid,0)
  	quit $$$OK
outputrow4
    if n>1  s (dept,name,papno,admdate,chgdate)=""
	set Data=$lb(dept,name,papno,admdate,chgdate,prtdate,"","",rcptno,pay,feeamt,remain,"",job)
 	set ^tmp("qfdjzl",$j,ind)=dept_"^"_name_"^"_papno_"^"_admdate_"^"_chgdate_"^"_prtdate_"^"_""_"^"_""_"^"_rcptno_"^"_pay_"^"_feeamt_"^"_remain_"^"_""_"^"_job
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findqfdjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findqfdjExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query findqfdj(StDate As %String, EndDate As %String, locid As %String) As %Query(ROWSPEC = "Tloc:%String,Tname:%String,Tregno:%String,Tadmdate:%String,Tdisdate:%String,Tjkdate:%String,Tjktype:%String,Tinvno:%String,Trepno:%String,Tdepamt:%String,Tfeeamt:%String,Tqfamt:%String,Tnote:%String,Tjob:%String")
{
}

ClassMethod getqfnum(job)
{
	s job=$g(job)
	s num=0
	q:'$d(^tmp("qfdjzl",job))
	s num=$g(^tmp("qfdjzl",job))
	q num
}

ClassMethod getqfdata(job, i)
{
	s job=$g(job)
	s i=$g(i)
	s data=""
	q:'$d(^tmp("qfdjzl",job))
	
	s data=$g(^tmp("qfdjzl",job,i))
	q data
}

ClassMethod clearqf(job)
{
	s job=$g(job)
	q:job="" 
	kill ^tmp("qfdjzl",job)
	q 0
}

}
