Import SQLUser

Class web.UDHCAccRegCard1 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

ClassMethod getpatbyCardNo(cardno As %Library.String = "", cardverify As %Library.String = "")
{
	;w ##class(web.UDHCAccRegCard).getpatbyCardNo("00005844","")
	s RegNo="",Papmi="",name="",CardNo="",SecurityNO="",CardID=""
	
	s rtn="-340"
	
	i cardno'=""  d
	.s cfrowid="0"
	.f  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cfrowid)) q:cfrowid=""  d
	..s SecurityNO=$p(^DHCCARD("CF",cfrowid),"^",3)
	..i SecurityNO'="" s rtn="-341"
	..q:SecurityNO'=""
	..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
	..i ActiveFlag'="" s rtn="-341"
	..q:ActiveFlag'=""
	..s CardID=cfrowid
	..s CardNo=$p(^DHCCARD("CF",cfrowid),"^",2)
	..s Papmi=$p(^DHCCARD("CF",cfrowid),"^",4)
	..s RegNo=$p(^DHCCARD("CF",cfrowid),"^",6)
	..q:Papmi=""
	..q:RegNo=""
	..s rtn="0"
	..s name=$p(^PAPER(Papmi,"ALL"),"^",1)
	..i name="未用" s name=""
	..s SecurityNO=##Class(web.UDHCAccCardManage).GetCardCheckNo(RegNo)
	
	s ren=rtn_"^"_RegNo_"^"_Papmi_"^"_name_"^"_CardNo_"^"_SecurityNO_"^"_CardID
	
	q ren
}

ClassMethod NewCardAcc(str1 As %String, str2 As %String, str3 As %String, str4 As %String) As %String
{
	n (str1,str2,str3,str4)
	s securityno="",rtn1="^^^"
	s $ZT="ERROR^DHCSSERR"
	
	d ##Class(web.UDHCCardRef).tb()
	
	s ren=..UpdatePatDetail(str1)
	i ren=0  d
	.s rtn=##Class(web.UDHCAccCardManage).grantcardUpdate(str2)
	.s ren=$p(rtn,"^",1),securityno=$p(rtn,"^",2)
	.i ren=0  d
	..;s no=1
	..s rtn=##Class(web.UDHCAccManageCLS).NewAccountAdd(str3)
	..s ren=$p(rtn,"!",1),tmpstr=$p(rtn,"!",2),accid=$p(tmpstr,"^",1),accno=$p(tmpstr,"^",2)
	..i ren=0  d
	...;s no=2
	...s $p(str4,"^",1)=accid
	...i $p(str4,"^",2)'="" d
	....s rtn1=##Class(web.UDHCAccAddDeposit).AddDeposit(str4)
	....s ren=$p(rtn1,"^",1)
	....;s no=3
	i ren=0  d ##Class(web.UDHCCardRef).tc()
 	e  TROLLBACK
 	
	q ren_"^"_securityno_"^"_rtn1
}

ClassMethod regnocon(regno1 As %String) As %String
{
	q:regno1=""
	s reglen=$l(regno1)
	f i=reglen:1:7  d
	.s regno1="0"_regno1
    q regno1
}

ClassMethod UpdatePatDetail(val As %Library.String = "")
{
 n (val)
 ; Try and find a matching code
 ;取参数
 s ID=$p($g(val),"^",1)
 s Namepar=$p($g(val),"^",2)
 s Sexpar=$p($g(val),"^",3)
 s Birthpar=$p($g(val),"^",4)
 s TelNopar=$p($g(val),"^",5)
 s OpMedicare=$p($g(val),"^",6)
 s InMedicare=$p($g(val),"^",7)
 s PatType=$p($g(val),"^",8)
 s IDCardNo1=$p($g(val),"^",9)
 s Vocation=$p($g(val),"^",10)
 s Company=$p($g(val),"^",11)
 s Address=$p($g(val),"^",12)
 
  //s SexDr=0
  //s SexDr=$o(^CT("SEX",0,"Desc",Sexpar,SexDr))
  
  //s PatTypeDr=0
  //s PatTypeDr=$o(^CT("SS",0,"Desc",$g(PatType),PatTypeDr))
  
  i Birthpar["/" s Birthpar=$ZDH(Birthpar,4)
  i Birthpar["-" s Birthpar=$ZDH(Birthpar,3)
  //s =$p($g(val),"^",4)
  //S IDrowid=0
  //s IDrowid=$o(^PAPERi("PAPMI_PatNo",IDpar,IDrowid))

 //s ^DHCApp=Company_"^"_Address
 //&sql(update sqluser.pa_person set paper_name =:Namepar,
 //                                  paper_sex_dr =:SexDr,
 //                                  paper_dob =:Birthpar,
 //                                  paper_id=:IDCardNo1,
 //                                  paper_governcardno=:OpMedicare,
 //                                   paper_socialstatus_dr =:PatTypeDr,    
 //                                  paper_telh=:TelNopar,
 //                                  paper_secondphone=:Company
 //	where paper_rowid=:IDrowid)   
 //UpdatePatInfo(IDrowid,Namepar,SexDr,Birthpar,IDCardNo1,OpMedicare,PatTypeDr,TelNopar,Company)
 

 //Set Config=##Class(websys.Configuration).%OpenId(1)
 //Set MEDDATA=Config.DataNamespace            
 //Set LABDATA=Config.LabDataNamespace         
 //Set CurrentNS=$ZNSPACE                     
 //ZN MEDDATA                                 
 //d UpdatePatInfo^DHCOPUpdatePatInfo(IDrowid,Namepar,SexDr,Birthpar,IDCardNo1,OpMedicare,PatTypeDr,TelNopar,Company) 
 //ZN CurrentNS  
 k PLIST
 s PLIST(4)=Namepar
 s PLIST(15)=Sexpar
 s PLIST(11)=Birthpar
 s PLIST(3)=IDCardNo1
 s PLIST(119)=OpMedicare
 s PLIST(37)=PatType
 s PLIST(38)=TelNopar
 s PLIST(133)=Company

 s ren=##Class(web.UDHCPaPerson).UPDATE(ID)
 i ren=0  d
 .S ^PAPER(ID,"PER","ADD",0)=1
 .S ^PAPER(ID,"PER","ADD",1)=Address
 .k PLIST
 .q:InMedicare=""
 .s PLIST(98)=InMedicare
 .s ren=##Class(web.UDHCPaPatmas).UPDATE(ID)
 //&sql(update sqluser.pa_patmas set papmi_medicare =:InMedicare
 //  	where papmi_rowid=:ID)
  ;
 q ren
 //}
}

}
