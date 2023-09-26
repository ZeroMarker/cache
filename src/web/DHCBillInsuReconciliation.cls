Class web.DHCBillInsuReconciliation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 16;

Query InsuCheckErr(stDate As %String, endDate As %String) As %Query(ROWSPEC = "patname:%String,sex:%String,patID:%String,regno:%String,pusr:%String,pdate:%String,ptime:%String,invno:%String,hisamt:%String,hisinsu:%String,insamt:%String,inspay:%String,invDr:%String,insuDr:%String,errnote:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCBillInsuReconciliation","InsuCheckErr",64496, 64530)
ClassMethod InsuCheckErrExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	if (stDate="")  set qHandle=$lb(0,repid,0)  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set job=$i(^DHCBillInsuCheck("InvInsuErr"))
	/*
	s INPAYRowid="" 
	f iDate=stDate:1:endDate  d
	.//医保端核对
	.s insuId="",n=0	
	.f  s insuId=$o(^DHCINDIV("0","IDate",iDate,insuId)) q:insuId=""  d
	..s admid=$p(^DHCINDIV(insuId),"^",1)
	..q:+admid=0
	..s admtype=$p(^PAADM(admid),"^",2)
	..q:admtype="I"
	..s insuPAYFlag=$p(^DHCINDIV(insuId),"^",5)
	..q:insuPAYFlag'="I"
	..s invdr=$p(^DHCINDIV(insuId),"^",4)
	..s insuSum=$p(^DHCINDIV(insuId),"^",52)
	..s regflag=$p(^DHCINDIV(insuId),"^",36)
	..s Adminfodr=$p(^DHCINDIV(insuId),"^",2)
	..s InsuType=""
	..s:Adminfodr'="" InsuType=$p(^DHCINADM(Adminfodr),"^",18)
    ..i regflag="R" d
    ...s BillFlag=..CheckInvInsu(Adminfodr)
    ...s:(InsuType="WLE")&&(+BillFlag'=1) BillFlag=..CheckInvInsu(INPAYRowid)
    ..e  s BillFlag=..CheckInvInsu(INPAYRowid)
    ..q:+BillFlag=1
	..s n=n+1
	..s ^DHCBillInsuCheck("InvInsuErr",job,"insu",n)=INPAYRowid 
	*/
	
	s insuInfo=##class(web.INSUCollating).GetDivDrbyDate(stDate,endDate)
	s insuTMPID="" //$p(insuInfo,"&",2)
    f iDate=stDate:1:endDate  d
    .//his端核对
    .s invdr=""
    .f  s invdr=$o(^DHCINVPRT(0,"Date",iDate,invdr))   q:invdr=""   d
    ..s insdr=$p(^DHCINVPRT(invdr),"^",30)
    ..s flag=$p(^DHCINVPRT(invdr),"^",8)
    ..s initinv=$p(^DHCINVPRT(invdr),"^",13)
    ..s instype=$p(^DHCINVPRT(invdr),"^",9)
    ..s hisamt=$p(^DHCINVPRT(invdr),"^",16)
	..s hisinsu=$p(^DHCINVPRT(invdr),"^",31)
    ..i (insdr="")&(initinv'="")   s insdr=$p(^DHCINVPRT(initinv),"^",30),hisamt=$p(^DHCINVPRT(initinv),"^",16),hisinsu=$p(^DHCINVPRT(initinv),"^",31)
    ..q:+insdr=0
    ..i (flag'="N")&(insdr'="")   d
    ...s lastinv=$o(^DHCINVPRT(0,"INSDIV",insdr,""),-1)
    ...q:+lastinv=(+invdr)
    ...s fairtype=$p(^DHCINVPRT(lastinv),"^",34)
    ...q:fairtype="R"
    ...s flag=$p(^DHCINVPRT(lastinv),"^",8)
    ...s hisamt=$p(^DHCINVPRT(lastinv),"^",16)
	...s hisinsu=$p(^DHCINVPRT(lastinv),"^",31)
    ..i flag="N"   s insflag="+"
    ..e  s insflag="-"
    ..s fairtype=$p(^DHCINVPRT(invdr),"^",34)
    ..q:fairtype="R"
	..q:+insdr=0
    ..s insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	..i +insuerr'=1  s ^DHCBillInsuCheck("InvInsuErr",job,"Inv",invdr)=insuerr_"@@"_flag
    .s api=""
    .f  s api=$o(^DHCINVPRTAPi(0,"Date",iDate,api))   q:api=""  d
    ..s insdr=$p(^DHCINVPRTAP(api),"^",19)
    ..s flag=$p(^DHCINVPRTAP(api),"^",2)
    ..s initinv=$p(^DHCINVPRTAP(api),"^",10)
    ..s hisamt=$p(^DHCINVPRTAP(api),"^",13)
	..s hisinsu=$p(^DHCINVPRTAP(api),"^",17)
    ..i (insdr="")&(initinv'="")   s insdr=$p(^DHCINVPRTAP(initinv),"^",19),hisamt=$p(^DHCINVPRTAP(initinv),"^",13),hisinsu=$p(^DHCINVPRTAP(initinv),"^",17)
    ..i (flag'="N")&(insdr'="")   d
    ...s lastinv=$o(^DHCINVPRTAPi(0,"InsDR",insdr,""),-1)
    ...q:+lastinv=(+invdr)
    ...s flag=$p(^DHCINVPRTAP(lastinv),"^",2)
    ...s hisamt=$p(^DHCINVPRTAP(lastinv),"^",13)
	...s hisinsu=$p(^DHCINVPRTAP(lastinv),"^",17)
    ..i flag="N"   s insflag="+"
    ..e  s insflag="-"
    ..q:(+insdr=0)
    ..s insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	..i +insuerr'=1  s ^DHCBillInsuCheck("InvInsuErr",job,"API",api)=insuerr_"@@"_flag
	
	//体检
	f iDate=stDate:1:endDate  d
    .s peinvdr=""
    .f  s peinvdr=$o(^DHCPEINVPRT(0,"DATE",iDate,peinvdr))   q:peinvdr=""   d
    ..s flag=$p(^DHCPEINVPRT(peinvdr),"^",8)
    ..s realinv=peinvdr
    ..i flag'="N" s realinv=$p(^DHCPEINVPRT(peinvdr),"^",9)
    ..s hisamt=$p(^DHCPEINVPRT(realinv),"^",7)
    ..s insdr=$p(^DHCPEOEITEM(realinv),"^",4)
	..s hisinsu=$p(^DHCPEOEITEM(realinv),"^",5)
    ..i flag="N"   s insflag="+"
    ..e  s insflag="-"
    ..q:+insdr=0
    ..s insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	..i +insuerr'=1  s ^DHCBillInsuCheck("InvInsuErr",job,"PEInv",realinv)=insuerr_"@@"_flag

	i $d(^DHCBillInsuCheck("InvInsuErr",job))   d
	.s invid=""
	.f  s invid=$o(^DHCBillInsuCheck("InvInsuErr",job,"Inv",invid))  q:invid=""   d
	..s papmi=$p(^DHCINVPRT(invid),"^",15)
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s sex=$p(^PAPER(papmi,"ALL"),"^",7)
	..s:sex'="" sex=$p(^CT("SEX",sex),"^",2)
	..s patID=$p(^PAPER(papmi,"ALL"),"^",9)
	..s regno=$p(^PAPER(papmi,"PAT",1),"^",2)
	..s pdate=$p(^DHCINVPRT(invid),"^",5)
	..s ptime=$p(^DHCINVPRT(invid),"^",20)
	..s pdate=##class(websys.Conversions).DateLogicalToHtml(pdate)
	..s ptime=##class(websys.Conversions).TimeLogicalToHtml(ptime,1)
	..s pusr=$p(^DHCINVPRT(invid),"^",21) 
	..s:pusr'="" pusr=$p(^SSU("SSUSR",pusr),"^",2)
	..s invno=$p(^DHCINVPRT(invid),"^",14)
	..s hisamt=$p(^DHCINVPRT(invid),"^",1)
	..s hisamt=$j(hisamt,3,2)
	..s hisinsu=$p(^DHCINVPRT(invid),"^",31)
	..s hisinsu=$j(hisinsu,3,2)
	..s insamt=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"Inv",invid)),"^",2)
	..s insamt=$j(insamt,3,2)
	..s inspay=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"Inv",invid)),"^",3)
	..s inspay=$j(inspay,3,2)
	..s errnote=+$p(^DHCBillInsuCheck("InvInsuErr",job,"Inv",invid),"^",1)
	..s errnote=..GetErrDescByCode(errnote)
	..s invDr="INV"_invid
	..s insuDr=$p(^DHCINVPRT(invid),"^",30)
	..d OutputRow1
	.s api=""
	.f  s api=$o(^DHCBillInsuCheck("InvInsuErr",job,"API",api))  q:api=""   d
	..s papmi=$p(^DHCINVPRTAP(api),"^",11)
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s sex=$p(^PAPER(papmi,"ALL"),"^",7)
	..s:sex'="" sex=$p(^CT("SEX",sex),"^",2)
	..s patID=$p(^PAPER(papmi,"ALL"),"^",9)
	..s regno=$p(^PAPER(papmi,"PAT",1),"^",2)
	..s pdate=$p(^DHCINVPRTAP(api),"^",3)
	..s ptime=$p(^DHCINVPRTAP(api),"^",4)
	..s pdate=##class(websys.Conversions).DateLogicalToHtml(pdate)
	..s ptime=##class(websys.Conversions).TimeLogicalToHtml(ptime,1)
	..s pusr=$p(^DHCINVPRTAP(api),"^",5) 
	..s:pusr'="" pusr=$p(^SSU("SSUSR",pusr),"^",2)
	..s invno=$p(^DHCINVPRTAP(api),"^",6)
	..s hisamt=$p(^DHCINVPRTAP(api),"^",1)
	..s hisamt=$j(hisamt,3,2)
	..s hisinsu=$p(^DHCINVPRTAP(api),"^",17)
	..s insamt=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"API",api)),"^",2)
	..s insamt=$j(insamt,3,2)
	..s inspay=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"API",api)),"^",3)
	..s inspay=$j(inspay,3,2)
	..s errnote=+$p(^DHCBillInsuCheck("InvInsuErr",job,"API",api),"^",1)
	..s errnote=..GetErrDescByCode(errnote)
	..s invDr="API"_api
	..s insuDr=$p(^DHCINVPRTAP(api),"^",19)
	..d OutputRow1
	.
	.s invid=""
	.f  s invid=$o(^DHCBillInsuCheck("InvInsuErr",job,"PEInv",invid))  q:invid=""   d
	..s paadm=$p(^DHCPEINVPRT(invid),"^",2)
	..s papmi=$p(^PAADM(paadm),"^",1)
	..q:papmi=""
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	..s sex=$p(^PAPER(papmi,"ALL"),"^",7)
	..s:sex'="" sex=$p(^CT("SEX",sex),"^",2)
	..s patID=$p(^PAPER(papmi,"ALL"),"^",9)
	..s regno=$p(^PAPER(papmi,"PAT",1),"^",2)
	..s pdate=$p(^DHCPEINVPRT(invid),"^",11)
	..s ptime=$p(^DHCPEINVPRT(invid),"^",12)
	..s pdate=##class(websys.Conversions).DateLogicalToHtml(pdate)
	..s ptime=##class(websys.Conversions).TimeLogicalToHtml(ptime,1)
	..s pusr=$p(^DHCPEINVPRT(invid),"^",10) 
	..s:pusr'="" pusr=$p(^SSU("SSUSR",pusr),"^",2)
	..s invno=$p(^DHCPEINVPRT(invid),"^",1)
	..s hisamt=$p(^DHCPEINVPRT(invid),"^",7)
	..s hisinsu=$p(^DHCPEOEITEM(invid),"^",5)
	..s insamt=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"PEInv",invid)),"^",2)
	..s inspay=+$p($g(^DHCBillInsuCheck("InvInsuErr",job,"PEInv",invid)),"^",3)
	..s errnote=+$p(^DHCBillInsuCheck("InvInsuErr",job,"PEInv",invid),"^",1)
	..s errnote=..GetErrDescByCode(errnote)
	..s invDr="PEINV"_invid
	..s insuDr=$p(^DHCPEOEITEM(invid),"^",4)
	..d OutputRow1

	i (insuTMPID'="")&&($d(^CacheTemp("Detail",+insuTMPID)))   d
	.s insuid=""
	.f  s insuid=$o(^CacheTemp("Detail",insuTMPID,insuid))   q:insuid=""   d
	..s data=$g(^CacheTemp("Detail",insuTMPID,insuid))
	..s adm=$p(data,"^",2)
	..s (patname,sex,patID,regno)=""
	..i adm'=""   d
	...s papmi=$p($g(^PAADM(+adm)),"^",1)
	...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	...s sex=$p(^PAPER(papmi,"ALL"),"^",7)
	...s:sex'="" sex=$p(^CT("SEX",sex),"^",2)
	...s patID=$p(^PAPER(papmi,"ALL"),"^",9)
	...s regno=$p(^PAPER(papmi,"PAT",1),"^",2)
	..s pdate=$p(data,"^",3)
	..s ptime=$p(data,"^",4)
	..s pdate=##class(websys.Conversions).DateLogicalToHtml(pdate)
    ..s ptime=##class(websys.Conversions).TimeLogicalToHtml(ptime,1)
    ..s pusr=$p(data,"^",5)
    ..s hisamt=$p(data,"^",7)
    ..s hisinsu=$p(data,"^",8)
    ..s insamt=$p(data,"^",9)
    ..s inspay=$p(data,"^",10)
    ..s errnote=$p(data,"^",11)
    ..s errnote=..GetErrDescByCode(errnote)
    ..s invDr=""
    ..s insuDr=insuid
    ..s insuDr=$p(data,"^",1)
    ..d OutputRow1
    ;i insuTMPID'=""  k ^CacheTemp("Detail",insuTMPID)
    k ^DHCBillInsuCheck("InvInsuErr",job)
    
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow1
	set Data=$lb(patname,sex,patID,regno,pusr,pdate,ptime,invno,hisamt,hisinsu,insamt,inspay,invDr,insuDr,errnote)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod InsuCheckErrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InsuCheckErrExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InsuCheckErrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InsuCheckErrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// create by zhl 20150429
/// descript: 根据医保结算id核对其与his端数据一致性
/// other  :  w ##class(web.DHCBillInsuReconciliation).CheckInvInsu("29530","302.40^302.4^S")
/// input :  { insdiv : 医保结算id;expStr:扩展串 :"医保发票总额^医保支付总额^医保结算状态"}
/// output:  myErrCode {1:正常;-102:his医保数据状态不一致;-103:his医保数据状态不一致;-104:his没有相应记录;-105:his医保数据金额不一致}
ClassMethod CheckInvInsu(insdiv, expStr)
{
	s invdr=""
	s insamt=$p(expStr,"^",1)
	s inspay=$p(expStr,"^",2)
	s insflag=$p(expStr,"^",3)
	s (invamt,invinsu)=""
	s rtn=-1,err=""
	s myErrCode=""
	f  s invdr=$o(^DHCINVPRT(0,"INSDIV",insdiv,invdr))   q:invdr=""  d
	.s rtn=0
	.s flag=$p(^DHCINVPRT(invdr),"^",8)
	.s apidr=$p(^DHCINVPRT(invdr),"^",4)
	.s apiins=""
	.s:apidr'="" apiins=$p(^DHCINVPRTAP(apidr),"^",19)
	.q:+apiins'=0
	.i flag="N"  s rtn=rtn+1
	.s invamt=+$p(^DHCINVPRT(invdr),"^",1)
	.s invinsu=+$p(^DHCINVPRT(invdr),"^",31)
	.i ((insflag="I")&(flag="N"))||(((insflag="B")||(insflag="S"))&(flag'="N"))  d
	..;i (+insamt=invamt)&(+inspay=invinsu)  d
	..i (+insamt=invamt)   d
	...s err=1
	..e    d
	...s err=-1
	.e    d
	..s myErrCode=-102
	s apidr=""
	f  s apidr=$o(^DHCINVPRTAPi(0,"InsDR",insdiv,apidr))   q:apidr=""   d
	.i +rtn<0  s rtn=0
	.s flag=$p(^DHCINVPRTAP(apidr),"^",2)
	.i flag="N"  s rtn=rtn+1
	.s invamt=$p(^DHCINVPRTAP(apidr),"^",1)
	.s invinsu=$p(^DHCINVPRTAP(apidr),"^",17)
 	.i ((insflag="I")&(flag="N"))||((insflag="B")&(flag'="N"))  d
	..i (+insamt=invamt)&(+inspay=invinsu)  s err=1
	..e  s err=-1
	.e  s myErrCode=-102
    
   
    i err=1  d
    .i ((insflag="B")||(insflag="S"))&(+rtn=0)  s myErrCode=1
    .i ((insflag="B")||(insflag="S"))&(+rtn'=0)  s myErrCode=-102
    .i (insflag="I")&(+rtn=1)  s myErrCode=1
    .i (insflag="I")&(+rtn'=1)  s myErrCode=-103
    i (err="")&(myErrCode="")  d
    .s myErrCode=-104
    i err=-1   d
    .s myErrCode=-105

	q myErrCode
}

/// Creator: ZhYW
/// CreatDate: 2017-09-04
/// Description: 取医保计费对账差错描述
/// Input: errCode: 代码
/// Output: errDesc: 描述
/// Debug: w ##class(web.DHCBillInsuReconciliation).GetErrDescByCode(3)
ClassMethod GetErrDescByCode(errCode As %String) As %String
{
	new (errCode)
	set errDesc = ""
	quit:(errCode = "") errDesc
	set errDesc = $case(+errCode, 1:"正常", -202:"his医保数据状态不一致",  -203:"医保无此记录", -204:"his没有相应记录", -205:"his医保数据金额不一致", :"")
	quit errDesc
}

}
