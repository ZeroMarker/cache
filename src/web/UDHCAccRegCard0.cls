Import SQLUser

Class web.UDHCAccRegCard0 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 70;

/// /北京积水潭医院专用
/// /需要新写入DHC_CardRef
/// /需要新写入DHC_AccManager
ClassMethod getpatbyCardNo(cardno As %Library.String = "", cardverify As %Library.String = "")
{
	;w ##class(web.UDHCAccRegCard).getpatbyCardNo("006280","")
	;对于有PA_PatMas数据而没有DHC_CardRef数据的
	;如果当前的卡号码有效或者没有被回收此卡就不能再发；
	;得到卡号码
	;主要是验证卡而不是得到信息
	s RegNo="",Papmi="",name="",CardNo="",SecurityNO="",CardID=""
	
	;s rtn="-340"
	s rtn=0
	
	i cardno'=""  d
	.s cfrowid="0"
	.f  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cfrowid)) q:cfrowid=""  d
	..s SecurityNO=$p(^DHCCARD("CF",cfrowid),"^",3)
	..;i SecurityNO'="" s rtn="-341"
	..;q:SecurityNO'=""
	..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
	..i (ActiveFlag="N") s rtn="-341"
	..;只有被回收的卡才能使用
	..;i (ActiveFlag'="R") s rtn="-341"
	..;对于积水潭医院 只有被回收的卡才能使用
	..i (ActiveFlag="R")  s rtn=0
	..i (ActiveFlag="S")  s rtn=-351
	..i (ActiveFlag="D")  s rtn=-352
	..i ("NDSR"'[ActiveFlag) s rtn=-299
	..b
	..q:(+rtn'=0)
	..s CardID=cfrowid
	..;q:Papmi=""
	..;q:RegNo=""
	..;s rtn="0"
	..;s name=$p(^PAPER(Papmi,"ALL"),"^",1)
	..;i name="未用" s name=""
	..;s SecurityNO=##Class(web.UDHCAccCardManage).GetCardCheckNo(RegNo)
	
	s ren=rtn_"^"_RegNo_"^"_Papmi_"^"_name_"^"_CardNo_"^"_SecurityNO_"^"_CardID
	
	q ren
}

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	s (id,code,desc)=""
 	;##class(web.UDHCAccRegCard0).DocListBroker("","","00000012")
 	
	s RName=""
	s FID=val
	s PapmiRowid=0
	s PAPMFlag=2001			;无此登记号的病人
	s myAccSFlag=0			;账户状态
	;加入办理卡是，判断此登记号是否存在有效帐户
	
	f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
	.s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
	.s RBirth=$ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6),3)
	.s RIDCardNo=$p($g(^PAPER(PapmiRowid,"ALL")),"^",9)
	.s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
	.s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	.s RId=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2) ;IP_No
	.s RTelNo=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11) ;pa_person.paper_telh
	.s RInMedicare=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",22) ;pa_patmas.papmi_medicare
	.s ROpMedicare=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4) ;paper_governcardno
	.s soc=""
	.s RPatType=""
	.s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
	.i socialstatus'="" d
	..s RPatType=$p($g(^CT("SS",socialstatus)),"^",2)      ;paper_socialstatus_dr->ss_desc
    .s RCompany=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18) 
    .s RAddress=$p($g(^PAPER(PapmiRowid,"PER","ADD",1)),"^",1)
	.s myPAPMIDR=PapmiRowid
	.s PAPMFlag=0
	.s myAccRowID=0
	.;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",myPAPMIDR, myAccRowID)) q:((myAccRowID="")!(+myAccSFlag=2003))  d
	..q:($d(^DHCACD("AccM",myAccRowID))=10)
	..s myAStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..q:(myAStatus'="N")
	..s myAccSFlag=-353			;;不能重复办理账户标志
	
	;
	
	S desc=$g(RName)_"^"_$g(RBirth)_"^"_$g(RSex)_"^"_$g(RIDCardNo)_"^"_$g(RTelNo)_"^"_$g(RInMedicare)_"^"_$g(RPatType)_"^"_$g(RAddress)_"^"_$g(ROpMedicare)_"^"_$g(RCompany)
	s desc=$g(desc)_"^"_$g(myPAPMIDR)_"^"_PAPMFlag_"^"_myAccSFlag
	b
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
	&javascript<#(retval)#>
	
	q desc
}

ClassMethod NewCardAcc(PAPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String) As %String
{
	n (PAPatInfo,CardInfo,AccInfo, DepositInfo)
	s securityno="",rtn1="^^^"
	s $ZT="ERROR^DHCSSERR"
	
	s ren=0
	
	d ##Class(web.UDHCCardRef).tb()
	
	;对于积水潭基本患者基本信息不能改变
	;s ren=..UpdatePatDetail(PAPatInfo)
	
	b
	i ren=0  d
	.;需要新写入卡信息
	.s rtn=##Class(web.UDHCAccCardManage0).grantcardNEW(CardInfo)
	.s ren=$p(rtn,"^",1),securityno=$p(rtn,"^",2)
	.s myCardRowID=$p(rtn,"^",3)
	.q:(+ren'=0)
	.s $p(AccInfo,"^",11)=myCardRowID
	.s rtn=##Class(web.UDHCAccManageCLS).NewAccountAdd(AccInfo)
	.b		;AccInfo
	.s ren=$p(rtn,"!",1),tmpstr=$p(rtn,"!",2),accid=$p(tmpstr,"^",1),accno=$p(tmpstr,"^",2)
	.q:(+ren'=0)
	.s $p(DepositInfo,"^",1)=accid
	.i $p(DepositInfo,"^",2)'="" d
	..s rtn1=##Class(web.UDHCAccAddDeposit).AddDeposit(DepositInfo)
	..b			;Deposit
	..s ren=$p(rtn1,"^",1)
	
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
	
  ;
 q ren
 //}
}

}
