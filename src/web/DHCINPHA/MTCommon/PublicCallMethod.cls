/// Description:移动药房公共调用方法类
/// Creator:    hulihua
/// CreateDate: 2017-11-01
Class web.DHCINPHA.MTCommon.PublicCallMethod Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Description:检查该库存项的单位是包装单位还是基本单位
/// Input:库存项rowid，单位rowid
/// Table:inc_itm
/// OutPut:
/// Return:1,包装单位;0,基本单位
/// w ##class(web.DHCINPHA.MobilePHA).ReplaceBracket("盒(20)")
ClassMethod ReplaceBracket(Str) As %Library.String
{
   	s Str=$p(Str,"(",1)
    q Str
}

/// Creator:Liang Qiang  
/// CreatDate:2009-01-04
/// Description:转换成整包装数量 
/// Input: inci:inc_itmRowid   qty:基本单位数量
/// Output: XX合xx片
/// Return: XX合xx片
/// Others:
ClassMethod getPackQty(inci, qty) As %String
{
	q:+qty=0 0
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=..ReplaceBracket($p(^CT("UOM",buom),"^",2))
	s puomdesc=..ReplaceBracket($p(^CT("UOM",puom),"^",2))
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s packqty=qty\fac
	s restqty=qty-(packqty*fac)
	
	i packqty'=0 d
	. s result=packqty_""_puomdesc
	
	i (packqty<0)&(restqty<0) s restqty=-restqty
	i restqty'=0 d
	. i result'="" d
	. . s result=result_""_restqty_""_buomdesc
	. e  d
	. . s result=restqty_""_buomdesc
	
	q result
}

/// Drescript:	取货位ID
/// Creater:	zhouyg
/// CreateDate:	2016-08-01
/// Input:		科室ID,库存项ID
/// Return:		货位ID
ClassMethod GetLocIncBin(LocID As %String, IncID As %String) As %String
{
	q:LocID="" ""
	q:IncID="" ""
	s ILSub=$o(^INCI("IL_LOC",LocID,IncID,""))
	q:ILSub="" ""
	s incil=IncID_"||"_ILSub
	s incilb="",ret=""
	f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
	.s stkbindr=$p(^DHCINCILB(incilb),"^",2)
	.i ret="" d
	..s ret=stkbindr
	.e  d
	..s ret=ret_","_stkbindr
	q ret
}

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Description:检查该库存项的单位是包装单位还是基本单位
/// Input:库存项rowid，单位rowid
/// Table:inc_itm
/// OutPut:
/// Return:1,包装单位;0,基本单位
ClassMethod CheckInciUom(inci, uom) As %Library.String
{
    s ret=""
    q:inci="" ""
    s buom=$p(^INCI(inci,1),"^",10)
    s puruom=$p(^INCI(inci,3),"^",6)
    i uom=buom  d
    .s ret=0
    e  i uom=puruom  d
    .s ret=1
    q ret
}

/// Description:根据用户工号获取改用户可登录的病区列表
/// Creator:	hulihua
/// CreateDate:	2017-11-22
/// Table:      SS_User、SS_UserOtherLogonLoc、CT_LOC、SS_Group、PAC_Ward
/// Input:		usercode-用户工号
/// Output:		可登录的病区串
/// Return：
/// Others:    		 
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLogWardStrByUserId("2754")
ClassMethod GetLogWardStrByUserId(userid)
{
    q:userid="" ""
    s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
    s WardId=$o(^PAWARD(0,"WARD_LocationDR",ctloc,""))
    s WardIdStr=WardId
	s chl=""
	f  s chl=$o(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
	.s ctlocdr=$p(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
	.q:ctlocdr=""
	.s grpdr=$p(^SSU("SSUSR",userid,"OTHLL",chl),"^",2)
	.q:grpdr=""
	.s WardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocdr,""))
	.q:WardId=""
	.q:##class(web.DHCST.Common.UtilCommon).FindInList(WardIdStr,WardId,",")'=0
	.s WardIdStr=$s(WardIdStr'="":WardIdStr_","_WardId,1:WardId)
	q WardIdStr
}

/// Descript:	通过处方号获取处方审方信息
/// Creator:	hulihua
/// Table:		DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--医嘱审核子表
/// CreateDate:	2017-09-28
/// Input:		PrescNo-处方号,ResultFlag-N表示获取所有的信息，无论是否通过
/// Output:		
/// Return:     审方时间、审方人ID、审方人名称
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo("I18011806149")
ClassMethod GetPhaomInfo(PrescNo As %String, ResultFlag As %String = "") As %String
{
	s phaomid="",retstr=""
	f  s phaomid=$o(^DHCPHORDM(0,"PrescNo",PrescNo,phaomid),-1)  q:(phaomid="")||(retstr'="")  d
	.s phaomresult=$p(^DHCPHORDM(phaomid),"^",2)
	.q:(ResultFlag="")&&(phaomresult'="Y")
	.s phaomdate=$p(^DHCPHORDM(phaomid),"^",3)
	.s phaomdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaomdate)
	.s phaomtime=$p(^DHCPHORDM(phaomid),"^",4)
	.s phaomtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phaomtime)
	.s phaomdate=phaomdate_" "_phaomtime
	.s phaomuser=$p(^DHCPHORDM(phaomid),"^",1)
	.s phaomname=##class(PHA.COM.Data.Base).UserName(phaomuser)
	.s retstr=phaomdate_"^"_phaomuser_"^"_phaomname
	q retstr
}

/// Descript:	通过处方号获取处方置为可退信息
/// Creator:	hulihua
/// Table:		DHC_PHACollected-发药主表
/// CreateDate:	2019-01-09
/// Input:		PrescNo-处方号
/// Output:		
/// Return:     可退标志、置为可退人ID、置为可退人、置为可退日期、置为可退备注
/// Debug 		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhacAgreeRetInfo("I190109000009")
ClassMethod GetPhacAgreeRetInfo(PrescNo As %String) As %String
{
	q:PrescNo="" ""
	s phacId=$o(^DHCPHACi("PRESCNO",PrescNo,""),-1)
	q:phacId="" ""
	s agreeRetFlag=$p(^DHCPHAC(phacId,1),"^",2)
	s agreeRetUserDr=$p(^DHCPHAC(phacId,1),"^",3)
	s agreeRetName=$p(..GetUserInfoById(agreeRetUserDr),"^",2)
	s agreeRetDate=$p(^DHCPHAC(phacId,1),"^",4)
	s agreeRetDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(agreeRetDate)
	s agreeRetTime=$p(^DHCPHAC(phacId,1),"^",5)
	s agreeRetTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(agreeRetTime)
	s:agreeRetDate'="" agreeRetDate=agreeRetDate_" "_agreeRetTime
	s agreeRetRemark=$p(^DHCPHAC(phacId,1),"^",6)
	s retStr=agreeRetFlag_"^"_agreeRetUserDr_"^"_agreeRetName_"^"_agreeRetDate_"^"_agreeRetRemark
	q retStr
}

/// Description:判断某处方是否属于某医嘱子类的处方
/// Creator:	hulihua
/// CreateDate:	2017-12-05
/// Table:		OE_OrdItem-医嘱明细表、ARC_ItmMast-医嘱项表，ARC_ItemCat-医嘱子类表  
/// Input:		prescno-处方号		
/// Output:		
/// Return：	1-是，0-非
/// Others:		规则为处方明细中有一个药品的医嘱子类为某子类的即可为某医嘱子类的处方
/// 			目前只用于判断精细处方（医嘱子类为精包装饮片）
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckPresByItemCat("I17122100730","颗粒剂")
ClassMethod CheckPresByItemCat(prescno As %String, inputcat As %String) As %Integer
{
  	Q:prescno="" 0
  	s existflag=0
  	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(existflag'=0)  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:(itm="")||(existflag'=0)  d
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s oeori=ord_"||"_itm
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..q:dsp=""
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	..q:arcimid="" 
 	..s sub=+arcimid,ver=$p(arcimid,"||",2) 
 	..q:'$d(^ARCIM(sub,ver,1)) 
 	..s itemcat=$p(^ARCIM(sub,ver,1),"^",10)  
 	..s catdesc=$s(itemcat'="":$p(^ARC("IC",itemcat),"^",2),1:"")
 	..s:catdesc[inputcat existflag=1
	q existflag
}

/// Description:判断某处方细料类型
/// Creator:	hulihua
/// CreateDate:	2017-12-21
/// Table:		OE_OrdItem-医嘱明细表、ARC_ItmMast-医嘱项表，inci_itm-库存项表  
/// Input:		prescno-处方号		
/// Output:		
/// Return：	0-非细料处方，1-单细料处方，2-含细料处方
/// Others:		
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckPresFinesType("I17122500095")
ClassMethod CheckPresFinesType(prescno As %String) As %Integer
{
  	Q:prescno="" 0
  	s i=0,j=0
  	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:itm=""  d
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s oeori=ord_"||"_itm
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..q:dsp=""
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	..q:arcimid="" 
 	..s sub=+arcimid,ver=$p(arcimid,"||",2) 
 	..q:'$d(^ARCIM(sub,ver,1))  
    ..s inci=$o(^INCI(0,"ARCIM_DR",+arcimid,""),-1)
    ..q:inci=""
    ..s HighRiskFlag=##class(web.DHCST.Common.DrugInfoCommon).GetHighRiskFlag(inci)
    ..s:HighRiskFlag="Y" j=j+1
    ..s i=i+1
    .
    s PresFinesType=$s((j>0)&&(j<i):"2",(j>0)&&(j=i):"1",1:"0")
	q PresFinesType
}

/// Description:按照处方的第一味药品的医嘱子类划分处方类型
/// Creator:	hulihua
/// CreateDate:	2017-12-05
/// Table:		OE_OrdItem-医嘱明细表、ARC_ItmMast-医嘱项表，ARC_ItemCat-医嘱子类表  
/// Input:		prescno-处方号		
/// Output:		
/// Return：	1-是，0-非
/// Others:		规则为处方明细中第一个药品的医嘱子类为啥即改处方就为啥处方
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckPresByFItemCat("I17120500001")
ClassMethod CheckPresByFItemCat(prescno As %String) As %String
{
  	Q:prescno="" ""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" "" 
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	q:itm="" ""
	s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	q:prescno'=OEPrescNo ""
	s oeori=ord_"||"_itm
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	q:dsp="" ""
	s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	q:arcimid="" "" 
 	s sub=+arcimid,ver=$p(arcimid,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ""
 	s itemcat=$p(^ARCIM(sub,ver,1),"^",10)  
 	s catdesc=$s(itemcat'="":$p(^ARC("IC",itemcat),"^",2),1:"")
 	s PresItemCat=$s(catdesc["中药饮片":"草药",catdesc["免煎剂":"免煎",catdesc["袋装饮片":"小包装",catdesc["颗粒剂":"颗粒",1:"")
	q PresItemCat
}

/// Description:判断处方的协定方类型
/// Creator:	hulihua
/// CreateDate:	2017-12-19
/// Table:		OE_OrdItem-医嘱明细表、ARC_ItmMast-医嘱项表  
/// Input:		PrescNo-处方号		
/// Output:		
/// Return：	1-协定方和普通草药组合，2-纯普通草药处方，3-纯协定方
/// Others:		
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom("I17121800309")
ClassMethod CheckCMXDPTCom(PrescNo As %String) As %String
{
	s XDFlag="N",PTFlag="N",ComFlag="2"
	s Ord=0 
	f  s Ord=$o(^OEORD(0,"PrescNo",PrescNo,Ord)) q:Ord=""  d
	.s Itm=0 
	.f  s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,Itm)) q:Itm=""  d
	..q:'$d(^OEORD(Ord,"I",Itm))
	..s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	..q:ArcimId=""
	..s IsPreArcim=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(ArcimId)
	..i IsPreArcim=1 s XDFlag="Y"
	..i IsPreArcim=0 s PTFlag="Y"
	.
	i (XDFlag="Y")&&(PTFlag="Y") s ComFlag="1" //协定方和普通草药组合
	i (XDFlag="N")&&(PTFlag="Y") s ComFlag="2" //纯普通草药处方
	i (XDFlag="Y")&&(PTFlag="N") s ComFlag="3" //纯协定方
	Q ComFlag
}

/// Description:通过处方号获取某处方的进价金额和售价金额(已发药)
/// Creator:	hulihua
/// CreateDate:	2017-12-06
/// Table:		DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB、DHC_PHDISPEN、DHC_PHDISITEM、DHC_PHDISITMCLB  
/// Input:		prescno-处方号		
/// Output:		
/// Return：	进价金额、售价金额
/// Others:		
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoAmt("I17120500001")
ClassMethod GetPrescNoAmt(prescno As %String) As %String
{
	Q:prescno="" ""
	S Type=$s($F(prescno,"I"):"I",1:"O")
	S SumRpAmt=0,SumSpAmt=0
	I Type="I" D
	.S Phac=$o(^DHCPHAC(0,"Prescno",prescno,""),-1)
	.Q:Phac=""
	.S PhacCh=""
	.F  S PhacCh=$o(^DHCPHAC(Phac,"I",PhacCh)) Q:PhacCh=""  D
	..S PhacSub=""
	..F  S PhacSub=$O(^DHCPHAC(Phac,"I",PhacCh,"B",PhacSub)) Q:PhacSub=""  D
	...Q:'$D(^DHCPHAC(Phac,"I",PhacCh,"B",PhacSub))
	...S RpAmt=$p(^DHCPHAC(Phac,"I",PhacCh,"B",PhacSub),"^",4)
	...S SumRpAmt=SumRpAmt+RpAmt
	...S SpAmt=$p(^DHCPHAC(Phac,"I",PhacCh,"B",PhacSub),"^",6)
	...S SumSpAmt=SumSpAmt+SpAmt
	..
	.
	E  D
	.S PhdRow=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
	.Q:PhdRow=""
	.S PhdRowCh=""
	.F  S PhdRowCh=$o(^DHCPHDI(PhdRow,"PHDI",PhdRowCh))  Q:PhdRowCh=""  D
	..S PhdRowSub=""
	..F  S PhdRowSub=$o(^DHCPHDI(PhdRow,"PHDI",PhdRowCh,"INCLB",PhdRowSub))  Q:PhdRowSub=""  D
	...Q:'$D(^DHCPHDI(PhdRow,"PHDI",PhdRowCh,"INCLB",PhdRowSub))
	...S RpAmt=$p(^DHCPHDI(PhdRow,"PHDI",PhdRowCh,"INCLB",PhdRowSub),"^",6)
	...S SumRpAmt=SumRpAmt+RpAmt
	...S SpAmt=$p(^DHCPHDI(PhdRow,"PHDI",PhdRowCh,"INCLB",PhdRowSub),"^",8)
	...S SumSpAmt=SumSpAmt+SpAmt
	..
	.
	Q SumRpAmt_"^"_SumSpAmt
}

/// Description:通过处方号获取某处方的剂数（未发药）
/// Creator:	hulihua
/// CreateDate:	2018-10-19
/// Table:		Oe_orditm 
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方剂数
/// Others:		
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoUnCount("O18101905326")
ClassMethod GetPrescNoUnCount(prescno As %String) As %String
{
	Q:prescno="" ""
	s Count=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
	..q:'$d(^OEORD(ord,"I",itm,1))
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..S dspId=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_itm,""))
	..Q:dspId="" 
	..S Count=Count+1
	Q Count
}

/// Description:通过处方号获取某处方的剂数（已发药）
/// Creator:	hulihua
/// CreateDate:	2017-12-07
/// Table:		DHC_PHACollected、DHC_PHACollectItm、DHC_PHDISPEN、DHC_PHDISITEM 
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方剂数
/// Others:		
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoCount("O18090300089")
ClassMethod GetPrescNoCount(prescno As %String) As %String
{
	Q:prescno="" ""
	S Type=$s($F(prescno,"I"):"I",1:"O")
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	K ^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO")
	I Type="I" D
	.S Phac=$o(^DHCPHAC(0,"Prescno",prescno,""),-1)
	.Q:Phac=""
	.S PhacCh=""
	.F  S PhacCh=$o(^DHCPHAC(Phac,"I",PhacCh)) Q:PhacCh=""  D
	..Q:'$D(^DHCPHAC(Phac,"I",PhacCh))
	..S oeori=$p(^DHCPHAC(Phac,"I",PhacCh),"^",7)
	..S Index=prescno_","_oeori
	..Q:$D(^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO",Index))
	..S ^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO",Index)=""
	.
	E  D
	.S PhdRow=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
	.Q:PhdRow=""
	.S PhdRowCh=""
	.F  S PhdRowCh=$o(^DHCPHDI(PhdRow,"PHDI",PhdRowCh))  Q:PhdRowCh=""  D
	..Q:'$D(^DHCPHDI(PhdRow,"PHDI",PhdRowCh))
	..S oeori=$p(^DHCPHDI(PhdRow,"PHDI",PhdRowCh),"^",5)
	..S Index=prescno_","_oeori
	..Q:$D(^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO",Index))
	..S ^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO",Index)=""
	.
	S Index="",Count=0
	F  S Index=$o(^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO",Index))  Q:Index=""  D
	.S Count=Count+1
	K ^TMP("DHCINPHA",$this,"GetPrescNoCount",pid,"PRESCNO")
	Q Count
}

/// Description:获取公共揭药数据信息
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		PhmbiId-揭药子表ID
/// Output:		
/// Return：	病区ID、病区名称、装箱人、装箱日期、发放人、发放日期、配送人、病区签收人、病区签收日期    
/// Others:
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo("1||2")
ClassMethod GetMedBrothInfo(PhmbiId) As %Library.String
{
	s phmbId=+PhmbiId,phmbCh=$p(PhmbiId,"||",2)
	s WardLocDr=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",1)
	s WardLoc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(WardLocDr),"^",2)				//接收科室
	s WardAbbr=$s(WardLocDr'="":$p(^CTLOC(WardLocDr),"^",51),1:"")
	s BrothDate=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",2)
	s BrothDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(BrothDate)								//用药日期
	s BrothUserId=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",9)
	s BrothUserName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BrothUserId),"^",2)			//揭药人
	s ActUnPocNum=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",7)	
	s ActBrothDate=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",3)													//揭药袋数
	s ActBrothDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ActBrothDate)			
	s ActBrothTime=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",4)
	s ActBrothTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ActBrothTime) 
	s:ActBrothDate'="" ActBrothDate=ActBrothDate_" "_ActBrothTime
	s BrothRemark=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",8)
	s MedAllSendFlag=$p(^DHCPHAMEDB(phmbId),"^",10)
	s BrothStatue=$s((MedAllSendFlag="Y")||(BrothRemark="煎药室已送"):"当日送",1:"明日送")
	s PrescNo=$p(^DHCPHAMEDB(phmbId),"^",4)
	s AdmDr=$p(^DHCPHAMEDB(phmbId),"^",2)
	s UncovMedFlag=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",5)
	s UncovMedPocNum=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",6)
	s PatName=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(AdmDr),"^",3)
	s NurCheckUserId=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",11)										
	s NurCheckUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(NurCheckUserId),"^",2)	//接收人
	s NurCheckDate=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",12)
	s NurCheckDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(NurCheckDate)	
	s NurCheckTime=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",13)
	s NurCheckTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(NurCheckTime) 
	s:NurCheckDate'="" NurCheckDate=NurCheckDate_" "_NurCheckTime	
	s BarCode=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",15)
	s BroPhboxDr=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",16)
	s (BoxCreateName,BoxCreateDate,BoxPhHandName,BoxPhHandDate,BoxLogisticsName,BoxWardHandName,BoxWardHandDate)=""
	i BroPhboxDr'="" d
	.s BoxCreateDr=$p(^DHCPHBOX(BroPhboxDr),"^",17)
	.s BoxCreateName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BoxCreateDr),"^",2)
	.s BoxCreateDate=$p(^DHCPHBOX(BroPhboxDr),"^",18)
	.s BoxCreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(BoxCreateDate)
	.s BoxCreateTime=$p(^DHCPHBOX(BroPhboxDr),"^",19)
	.s BoxCreateTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(BoxCreateTime)
	.s:BoxCreateDate'="" BoxCreateDate=BoxCreateDate_" "_BoxCreateTime
	.s BoxPhHandDr=$p(^DHCPHBOX(BroPhboxDr),"^",3)
	.s BoxPhHandName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BoxPhHandDr),"^",2)
	.s BoxPhHandDate=$p(^DHCPHBOX(BroPhboxDr),"^",4)
	.s BoxPhHandDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(BoxPhHandDate)
	.s BoxPhHandTime=$p(^DHCPHBOX(BroPhboxDr),"^",5)
	.s BoxPhHandTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(BoxPhHandTime)
	.s:BoxPhHandDate'="" BoxPhHandDate=BoxPhHandDate_" "_BoxPhHandTime
	.s BoxLogisticsDr=$p(^DHCPHBOX(BroPhboxDr),"^",6)
	.s BoxLogisticsName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BoxLogisticsDr),"^",2)
	.s BoxWardHandDr=$p(^DHCPHBOX(BroPhboxDr),"^",7)
	.s BoxWardHandName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BoxWardHandDr),"^",2)
	.s BoxWardHandDate=$p(^DHCPHBOX(BroPhboxDr),"^",8)
	.s BoxWardHandDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(BoxWardHandDate)
	.s BoxWardHandTime=$p(^DHCPHBOX(BroPhboxDr),"^",9)
	.s BoxWardHandTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(BoxWardHandTime)
	.s:BoxWardHandDate'="" BoxWardHandDate=BoxWardHandDate_" "_BoxWardHandTime
	s BrothBatNo=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",17)
	;
	s Result1=WardLocDr_"^"_WardLoc_"^"_BrothDate_"^"_BrothUserId_"^"_BrothUserName
	s Result2=ActUnPocNum_"^"_ActBrothDate_"^"_BrothRemark_"^"_BrothStatue_"^"_PrescNo
	s Result3=PatName_"^"_BrothBatNo_"^"_AdmDr_"^"_UncovMedFlag_"^"_UncovMedPocNum
	s Result4=BarCode_"^"_NurCheckUser_"^"_NurCheckDate_"^"_$g(BoxCreateName)_"^"_$g(BoxCreateDate)
	s Result5=$g(BoxPhHandName)_"^"_$g(BoxPhHandDate)_"^"_$g(BoxLogisticsName)_"^"_$g(BoxWardHandName)_"^"_$g(BoxWardHandDate)
	s Result6=$g(WardAbbr)
	s Result=Result1_"^"_Result2_"^"_Result3_"^"_Result4_"^"_Result5_"^"_Result6
	q Result
}

/// Description:获取医嘱明细信息
/// Creator:	hulihua
/// CreateDate:	2017-04-06
/// Table:      OE_OrdItem
/// Input:		医嘱ID
/// Output:		
/// Return：    
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOrdInfo("")
ClassMethod GetOrdInfo(OrdItmRowid As %String)
{
	s Ord=+OrdItmRowid
	s Chl=$p(OrdItmRowid,"||",2)
	s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14)
	s CookType=##class(web.DHCSTPCHCOLLS).GetCookType(Prescno)     			//草药煎药方式
	s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2) 
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),"") )                                 ;ARCIM_RowId 
	s PhcdfDr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",12)
	s AdmDr=$p(^OEORD(Ord),"^",1) 
	s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2) 
	s Priorty=$p(^OECPR($p(^OEORD(Ord,"I",Chl,1),"^",8)),"^",2)   			//医嘱优先级
	s DoseQty=$p(^OEORD(Ord,"I",Chl,2),"^",1)       						//用药剂量
	i +DoseQty>0 d
	.s DoseUom=$p($g(^OEORD(Ord,"I",Chl,2)),"^",3)
	.i DoseUom'="" s DoseUom=$p($g(^CT("UOM",DoseUom)),"^",2)
	.s DoseQty=DoseQty_DoseUom
	s Freq=$p($g(^OEORD(Ord,"I",Chl,2)),"^",4)
	i Freq'="" s Freq=$p($g(^PHCFR(Freq)),"^",1)     						//用药频率 
	s Instru=$p(^OEORD(Ord,"I",Chl,2),"^",7)
	i Instru'="" s Instru=$p($g(^PHCIN(Instru)),"^",2)        				//用法
	s Duration=$p(^OEORD(Ord,"I",Chl,2),"^",6)
	i Duration'="" s Duration=$p($g(^PHCDU(Duration)),"^",1)         		//用药疗程
	s OrdAuditResult=$p(^OEORD(Ord,"I",Chl,7),"^",3)						//医嘱审核		
	i OrdAuditResult["SHJJ" s OrdAuditResult="审核拒绝"
	i OrdAuditResult["SHTG" s OrdAuditResult="审核通过"	
	s Generic=##class(web.DHCSTCOMMONSRV).getGeneric(Inci)					//通用名
	i $f(Generic,"-") s Generic=$p(Generic,"-",2)
	s Form=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci),"^",2) //剂型
	s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	s Manf=##class(web.DHCSTITMDESC).GetManfNameByInci(Inci)
	s StkBin=##class(web.DHCSTKUTIL).StkBin(OrdItmRowid) 					//货位
	s UserAdd=##class(web.DHCSTCOMMONSRV).getOrdDoctor(OrdItmRowid)       	//医生
	s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrdItmRowid) 			//皮试结果
	s data1=Prescno_"^"_CookType_"^"_ArcimDesc_"^"_Priorty_"^"_DoseQty
	s data2=Freq_"^"_Instru_"^"_Duration_"^"_OrdAuditResult_"^"_Generic
	s data3=Form_"^"_Spec_"^"_Manf_"^"_StkBin_"^"_UserAdd
	s data4=SkinTest_"^"_AdmDr
	s data=data1_"^"_data2_"^"_data3_"^"_data4
	q data
}

/// Description:数据行之间的分隔符
/// Creator:	hulihua
/// CreateDate:	2017-11-25
/// Table:      
/// Input:		
/// Output:		
/// Return：	字符    
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
ClassMethod RowDataDelim() As %Library.String
{
  q "^"
}

/// Description:通过用户的ID获取用户的相关信息
/// Creator:	hulihua
/// CreateDate:	2017-11-25
/// Table:		SS_User      
/// Input:		UserId		
/// Output:		
/// Return：	用户工号^用户名称  
/// w $p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(),"^",2)
ClassMethod GetUserInfoById(UserId) As %Library.String
{
  	Q:UserId="" ""
  	Q:'$D(^SSU("SSUSR",UserId)) ""
	S UserCode=$p(^SSU("SSUSR",UserId),"^",1)
	S UserName=$p(^SSU("SSUSR",UserId),"^",2)
	S ReturnInfo=UserCode_"^"_UserName
	Q ReturnInfo
}

/// Description:通过用户的登录工号获取用户的ID
/// Creator:	hulihua
/// CreateDate:	2017-12-04
/// Table:		SS_USER     
/// Input:		LogUserCode-用户登录工号		
/// Output:		
/// Return：	用户SS_USER表ID  
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserIdByLogCode("yf01")
ClassMethod GetUserIdByLogCode(LogUserCode) As %Library.String
{
  	Q:LogUserCode="" ""
  	S LogUserCode=$$ALPHAUP^SSUTIL4(LogUserCode)
	S UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",LogUserCode,""))
	Q UserId
}

/// Description:验证用户输入的工号是否在HIS里面存在
/// Creator:	hulihua
/// CreateDate:	2016-10-24
/// Table:		ss_user      
/// Input:		用户工号      
/// Output:			
/// Return：	非0-存在，0-不存在
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckUserCode("411")
ClassMethod CheckUserCode(usercode)
{
	s userid=""
	i usercode="" q 0
	s usercode=$ZCVT(usercode,"U")
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
	i userid="" q 0
	q userid
}

/// Description:根据登录用户工号获取用户登录信息
/// Creator:	hulihua
/// CreateDate:	2016-09-29
/// Table:		SS_USER     
/// Input:		LogUserCode-用户登录工号		
/// Output:		
/// Return：	用户ID、用户代码、用户名称、默认登录科室ID、默认登录科室  
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserDefaultInfo("dthealth")
ClassMethod GetUserDefaultInfo(logusercode)
{
   	q:logusercode="" ""
   	s logusercode=$$ALPHAUP^SSUTIL4(logusercode)
   	s usercodelen=$l(logusercode)
   	i usercodelen>20 d
    .s userid=..GetUserIdByLogCode(logusercode)
    e  d
    .s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",logusercode,""),-1)
    q:userid="" ""
    s usercode=$p(^SSU("SSUSR",userid),"^",1)
    s username=$p(^SSU("SSUSR",userid),"^",2)
	s ctloc="",ctlocdesc=""
	i userid="" q ret
	s ctloc=+$p(^SSU("SSUSR",userid),"^",4)
	s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2) 
	s result=userid_"^"_usercode_"^"_username_"^"_ctloc_"^"_ctlocdesc
	q result
}

/// Description:通过科室ID获取科室的相关信息
/// Creator:	hulihua
/// CreateDate:	2017-11-25
/// Table:		CT_LOC     
/// Input:		LocId		
/// Output:		
/// Return：	科室代码、科室名称  
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById()
ClassMethod GetLocInfoById(LocId) As %Library.String
{
  	Q:LocId="" ""
  	Q:'$D(^CTLOC(LocId)) ""
  	S LocCode=$p(^CTLOC(LocId),"^",1)
  	S LocDesc=$p(^CTLOC(LocId),"^",2)
    S:$F(LocDesc,"-") LocDesc=$p(LocDesc,"-",2)
    s LocType=$p(^CTLOC(LocId),"^",13)
	S ReturnInfo=LocCode_"^"_LocDesc_"^"_LocType
	Q ReturnInfo
}

/// Description:通过打包主表ID获取该主表下的子表的进价和售价总金额
/// Creator:	hulihua
/// CreateDate:	2017-11-28
/// Table:		DHC_OEDispensing、DHC_OEDispBatch    
/// Input:		dspId-打包主表的ID		
/// Output:		
/// Return：	进价总金额、售价总金额
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetDspAmtByDsp()
ClassMethod GetDspAmtByDsp(dspId) As %Library.String
{
  	Q:dspId="" ""
  	q:'$D(^DHCOEDISQTY(dspId)) ""
  	S RecLoc=$p($g(^DHCOEDISQTY(dspId)),"^",24)
  	S HospID=$p(^CTLOC(RecLoc),"^",22)
  	S Perv="^^^^"_HospID_"^DHC"
  	s SumRpAmt=0,SumSpAmt=0
	s dspBatId=0
	f  s dspBatId=$o(^DHCOEDISQTY(dspId,"I",dspBatId)) q:dspBatId=""  d
	.s dspQty=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",2)
	.s dspRp=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",3)
	.s dspSp=$p(^DHCOEDISQTY(dspId,"I",dspBatId),"^",4)
	.s RpAmt=dspQty*dspRp
	.s RpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
	.s SumRpAmt=SumRpAmt+RpAmt
	.s SpAmt=dspQty*dspSp
	.s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
	.s SumSpAmt=SumSpAmt+SpAmt
	q SumRpAmt_"^"_SumSpAmt
}

/// Description:计算今天离月初有多少天
/// Creator:	hulihua
/// CreateDate:	2017-12-07
/// Table:		   
/// Input:				
/// Output:		
/// Return：	离月初的间隔天数
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetFatalDay()
ClassMethod GetFatalDay() As %Library.String
{
	s NowDay=+$h
	s NowDayF=$zd(NowDay,3)
	s BeginMonthF=$p(NowDayF,"-",1)_"-"_$p(NowDayF,"-",2)_"-01"
	s BeginMonth=$zdh(BeginMonthF,3)
	s FatalDay=BeginMonth-NowDay
	q FatalDay
}

/// Description:判断口服摆药类的药品是发往摆药机还是移动药房
/// Creator:	hulihua
/// CreateDate:	2017-12-08
/// Table:      OE_OrdItem-医嘱明细表,OE_OrdItemExt-医嘱扩展表,DHCStkDrugGroup-发药类别,DHCStkDrugGrpItm-发药类别和医嘱子类关联表
/// Input:		DspId-打包表ID
/// Output:
/// Return：	0-走移动药房，1-走摆药机   
/// Others:		KFBY的类别如果是整包装发往移动药房，仅散包装的长期医嘱是发往摆药机！
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckSendKFBY("31||43")
ClassMethod CheckSendKFBY(Oeori As %String) As %String
{
	Q:Oeori="" 0
	S OrdID=$p(Oeori,"||",1)
	S OrdSub=$p(Oeori,"||",2)
	Q:'$D(^OEORD(OrdID,"I",OrdSub,1)) 0
	S ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)                                    
	S ArcCatID=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),1),"^",10)        
	S CatCode=$p(^ARC("IC",ArcCatID),"^",1)                         
	S Cat=##class(web.DHCSTPCHCOLLS).GetCat(CatCode)
	Q:Cat'["KFBY" 0
	S PriorDr=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
	Q:PriorDr="" 0
	S Priority=$p(^OECPR(PriorDr),"^",1)
	Q:Priority'="S" 0
	s QtyPackUom=$p(^OEORD(OrdID,"I",OrdSub,9),"^",4)
	Q:QtyPackUom="" 1
	S PackUomDr=$p(^OEORD(OrdID,"I",OrdSub,"DHC"),"^",13)
	S Inci=##class(web.DHCSTCOMINC).GetInciID(ArcimID)
	S PurUomId=$p(^INCI(Inci,3),"^",6)
	Q:PackUomDr=PurUomId 0
	S BUomId=$p(^INCI(Inci,1),"^",10)
	S Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(PackUomDr,BUomId)
	S Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	S QtyPack=(QtyPackUom*Fac1)/Fac2
	Q:$F(QtyPack,".") 1
	Q 0
}

/// Description:判断是否是全送的揭药记录（揭药室）
/// Creator:	hulihua
/// CreateDate:	2017-11-27
/// Table: 		  
/// Input:		PrescNo-处方号,PhLocId-药房科室ID
/// Output:		
/// Return： 	""-否，1-是   
/// Others:		a.测菜单维护的病区全送配置(1000);
/// 			b.参数设置维护的非全送草药用法;
/// 			c.处方剂型配置的处方;
/// 			d.处方付数不大于测菜单维护的病区付数;
///             e.出院病人（护士预结算病人）;
/// 			d.出院带药类型的处方;
/// w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckIfAllSend("I190121000048","310")
ClassMethod CheckIfAllSend(PrescNo As %String, PhLocId As %String) As %String
{
	q:PrescNo="" ""
	s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
    s AdmDr=$p(^OEORD(Ord),"^",1)
    s AdmWard=$p(^PAADM(AdmDr),"^",70)
	s WardLocId=$p(^PAWARD(AdmWard),"^",5)
	s phsi=$o(^DHCPHSLi("PHLOC",PhLocId,WardLocId,""),-1)
	s SendFreqFactor=$s(phsi'="":$p(^DHCPHSL(phsi),"^",5),1:"")
	q:SendFreqFactor="1000" 1
	s prescNoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
	s prescUsageCode=$p(prescNoStr,"^",24)
	s paramPropStr=..GetParamProp("",PhLocId,"")
	s allSendUsageCode=$p(paramPropStr,"^",1)
	q:prescUsageCode'=allSendUsageCode 1
	s prescConfigSatr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetHMPrescConfig(PrescNo)
	s presAllSendFlag=$p(prescConfigSatr,"^",8)
	q:presAllSendFlag="Y" 1
	s PrescFactor=$p(prescNoStr,"^",2)
	s SendFactor=$s(phsi'="":$p(^DHCPHSL(phsi),"^",6),1:"")
	q:(SendFactor'="")&&(PrescFactor'>SendFactor) 1
    s ret=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(AdmDr)	
	q:ret=0 1 
	s Chl=$o(^OEORD(0,"PrescNo",PrescNo,Ord,""),-1)
	s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
	q:PriorDr="" ""  										
 	s Priority=$p(^OECPR(PriorDr),"^",1)
 	q:Priority["OUT" 1
 	q ""
}

/// Description:获取膏方的罐数（揭药室）
/// Creator:	hulihua
/// CreateDate:	2018-01-21
/// Table: 		  
/// Input:		PrescNo-处方号
/// Output:		
/// Return： 	罐数
/// Others:		有糖膏方3罐，无糖膏方2罐
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOralPasteJarNum("I18011702486")
ClassMethod GetOralPasteJarNum(PrescNo As %String) As %String
{
	q:PrescNo="" 0
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
	s PreFormType=$p(prescStr,"^",8)
	q:PreFormType'["膏方" 0
	s PrescConfig=$p(prescStr,"^",10)	
	//s JarNum=$s(PrescConfig["有糖":3,PrescConfig["无糖":2,1:1)
	// MaYuqiang 20200720 此配置为项目个性化需求，标库上并未添加，现修改成0
	s JarNum=$s(PrescConfig["有糖":3,PrescConfig["无糖":2,1:0)
	q JarNum
}

/// Description:判断草药处方的处方类型
/// Creator:	hulihua
/// CreateDate:	2018-04-18
/// Table:		
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方类型
/// Others:		如果处方中有一个药品为特殊药品则该处方是这类型的处方
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetCYPrescTitle("O210205000106")
ClassMethod GetCYPrescTitle(prescno As %String) As %Integer
{
	
  	Q:prescno="" "普通"
  	S PrescTitle=""
  	S ord=""
	F  S ord=$O(^OEORD(0,"PrescNo",prescno,ord))  Q:(ord="")||(PrescTitle'="")  D
	.S itm=""
	.F  S itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  Q:(itm="")||(PrescTitle'="")  D
	..S OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..Q:prescno'=OEPrescNo
	..S oeori=ord_"||"_itm
	..S dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..Q:dsp=""
	..S arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	..Q:arcimid="" 
 	..S sub=+arcimid,ver=$p(arcimid,"||",2) 
 	..Q:'$d(^ARCIM(sub,ver,1)) 
 	..S Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)  
 	..;S PoisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",2)
 	..S poisonDr=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",1)
 	..q:poisonDr=""
 	..i $d(^CF.PHA.OP.PrescTypeI("Poison",poisonDr)) d
	...s ptId=$o(^CF.PHA.OP.PrescTypeI("Poison",poisonDr,""))
	...s prescType=$lg($g(^CF.PHA.OP.PrescTypeD(ptId)),2)
	...s PrescTitle=$p($g(^DHCSTSCDI(+prescType)),"^",2)
 	Q:PrescTitle'="" PrescTitle
	q ##class(PHA.OP.COM.Method).GetPrescTitle(prescno)
}

/// Description:得到处方类型(医保,自费)
/// Creator:Liang Qiang
/// CreatDate:2011-08-31
ClassMethod GetPrescType(prescno)
{
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
   s dhcprescrow=$o(^DHCPAQPT(0,"PrescNo",prescno,""))
   i dhcprescrow'=""  d
   .s psonrow="",pson="",psoncode=""
   .s psonrow=+$p(^DHCPAQPT(dhcprescrow),"^",2)
   .s pson=+$p(^DHCPAADMPrescType(psonrow),"^",2)
   .s PrescTypeCode=pson
   e  d
   .s PrescTypeCode=preason
   q:PrescTypeCode="" "自费"
   s mrowid=$o(^DHCOutPrescTypeSub("sub",PrescTypeCode,""))
   q:mrowid="" ""
   s presctypedesc=^DHCOutPrescType(mrowid)
   q presctypedesc
}

/// Description:通过处方号获取草药处方关联的诊断
/// Creator:	hulihua
/// CreateDate:	2018-07-18
/// Table:		
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方关联的诊断
/// Others:		
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescDiagnos("I18071800003")
ClassMethod GetPrescDiagnos(prescno As %String) As %String
{
  	q:prescno="" ""
  	q ##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescno,",")
  	/*
	s queid=$o(^PAQUE1(0,"PrescNo",prescno,""),-1)
	q:queid="" "" 
	q:'$d(^PAQUE1(queid,"DHC")) ""
	s PrescDiagnosID=$P(^PAQUE1(queid,"DHC"),"^",33)
	q:PrescDiagnosID="" ""
	s PrescDiagICDDR=$p($g(^MR(+PrescDiagnosID,"DIA",$p(PrescDiagnosID,"||",2))),"^",1)
	s PrescDiagnos=$s(PrescDiagICDDR'="":$p($g(^MRC("ID",PrescDiagICDDR)),"^",2),1:"")
	s PrescZXDesc=""
	s PrescDiagnosSub=0 
	f  s PrescDiagnosSub=$o(^MR(+PrescDiagnosID,"DIA",0,"Link",PrescDiagnosID,PrescDiagnosSub)) q:PrescDiagnosSub=""  d
	.s PrescDiagSubICDDR=$p($g(^MR(+PrescDiagnosID,"DIA",PrescDiagnosSub)),"^",1)
	.s PrescDiagSubICDDesc=$s(PrescDiagSubICDDR'="":$p($g(^MRC("ID",PrescDiagSubICDDR)),"^",2),1:"")
	.i PrescZXDesc="" s PrescZXDesc=PrescDiagSubICDDesc
	.e  s PrescZXDesc=PrescZXDesc_","_PrescDiagSubICDDesc
	i PrescZXDesc'="" s PrescDiagnos=PrescDiagnos_"("_PrescZXDesc_")"
	Q PrescDiagnos
	*/
}

/// Description:通过处方号获取慢病诊断
/// Creator:	hulihua
/// CreateDate:	2018-09-27
/// Table:		
/// Input:		prescno-处方号		
/// Output:		
/// Return：	处方慢病诊断诊断
/// Others:		
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescMBDiagnos("O18092800029")
ClassMethod GetPrescMBDiagnos(prescno As %String) As %String
{
  	q:prescno="" ""
	s queid=$o(^PAQUE1(0,"PrescNo",prescno,""),-1)
	s MBDiagICDDR=""
	i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d
	.s MBDiagICDDR=$P(^PAQUE1(queid,"DHC"),"^",28) 
	e  d
	.s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
	.s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""),-1)
	.s MBDiagICDDR=$p(^OEORD(ord,"I",itm,"DHC"),"^",47)
	s MBDiagnos=$s(MBDiagICDDR'="":$p($g(^DHCMBDC(MBDiagICDDR)),"^",2),1:"")
	Q MBDiagnos
}

/// Description:获取住院药房公共配置 
/// Creator:	hulihua
/// CreateDate:	2019-01-14
/// Table:      DHC_StkSysAProp
/// Input:		安全组ID、科室ID、用户ID
/// Output:		
/// Return：	全送处方用法	 
/// Others:		
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetParamProp("","310","")
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName="HDD.COMMON"
    s AllSendPrescUsage=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllSendPrescUsage",Param)
    s Data1=AllSendPrescUsage
    s Data=Data1
    q Data
}

Storage Default
{
<Data name="PublicCallMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINP1332.PublicCallMDC1FD</DataLocation>
<DefaultData>PublicCallMethodDefaultData</DefaultData>
<IdLocation>^web.DHCINP1332.PublicCallMDC1FD</IdLocation>
<IndexLocation>^web.DHCINP1332.PublicCallMDC1FI</IndexLocation>
<StreamLocation>^web.DHCINP1332.PublicCallMDC1FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
