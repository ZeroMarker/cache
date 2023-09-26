Class BILL.EINV.BL.COM.Common Extends %RegisteredObject
{

Parameter InsuCardPayCode = "Card";

Parameter InsuTCPayCode = "TC";

Parameter InsuCardType = "TC";

Parameter CashCode = "CASH";

/// 1 明细按整包装单位 0 明细按收费项单位
Parameter PackUOMFlag = 1;

/// 功能说明：根据业务类型和发票信息获取患者基本信息及就诊信息
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> HIS发生业务发票ID
///           ObjPatBaseInfo  --> 患者基本信息
///           ObjPatBaseInfo  --> 患者就诊信息
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：董科锋 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv()
ClassMethod GetPatInfoByInv(PayAdmType As %String, HISPrtRowID As %String, ByRef ObjPatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo, ByRef ObjPatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo) As %String
{
	s RtnFlg="-1"
	
	//根据票据业务类型与发票表rowid获取病人ID与就诊号
	s PatInfo=##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId(PayAdmType,HISPrtRowID)  ;方法名修改
	s Papmi=$p(PatInfo,"^",1)  ;病人Id
	s admDr=$p(PatInfo,"^",2)  ;就诊号
	q:(Papmi="")||((admDr="")&&(PayAdmType'="CF")) RtnFlg
	
	s TmpFlg=##class(BILL.EINV.BL.COM.Common).GetPatBaseInfoByPapmiDr(Papmi, .ObjPatBaseInfo)   ;患者基本信息
	q:TmpFlg'="0" RtnFlg
	
	i (PayAdmType'="CF") {
		s TmpFlg=##class(BILL.EINV.BL.COM.Common).GetAdmInfoByAdmDr(admDr, .ObjPatAdmInfo)          ;患者就诊信息
		q:TmpFlg'="0" RtnFlg
	}else{
		s ObjPatAdmInfo=##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()
	}
	
	s RtnFlg="0"
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2019 9 17
/// Desc:		根据票据业务类型与发票表rowid获取相关发票信息
/// Table:		BILL.EINV.PO.InvUpDetails
/// Input:		ObjPatBaseInfo:病人基本信息对象
/// 			ObjPatAdmInfo:病人本次就诊信息对象
/// 			ObjInvPrt：发票信息对象
/// 			InvociePam:参数对象[出参]
/// Return:		
/// w ##class(BILL.EINV.BL.COM.Common).GetInvPrtInfo("OP","232690","","","")
ClassMethod GetInvPrtInfo(ObjPatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo, ObjPatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="-1"
	s PayAdmType=InvociePam.PayAdmType
	s HISPrtRowID=InvociePam.HISPrtRowID
	q:(PayAdmType="")||(HISPrtRowID="") RtnFlg
	
	;add by xubaobao 2020 09 07 如果体检数据存储类型为0时,从门诊发票表取数据
	s:InvociePam.PEStorageType="0" PayAdmType="OP" 
	
	s prtRtn="-1"
	//add by xubaobao 2020 08 11 将发票对象涉及金额的属性，统一保留两位小数
	if (PayAdmType="OP")||(PayAdmType="REG"){		//获取门诊/挂号发票信息对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetOPInvPrtInfoObjByPrtId(HISPrtRowID, .ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="IP"){		//获取住院发票信息对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetIPInvPrtInfoObjByPrtId(HISPrtRowID, .ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="OT")||(PayAdmType="IT"){		//获取门诊跳号/住院跳号发票对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetOTAndITPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="API"){		//获取集中打印发票对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetAPIInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="DEP"){		//获取住院预交金发票对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetDEPInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="PE"){       //获取体检发票对象
		;s prtRtn=##class(BILL.EINV.BL.COM.Common).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
		;add by xubaobao 2020 09 28 调用体检组方法获取电子发票对象
		s prtRtn=##class(BILL.EINV.BL.COM.PECommon).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
	}elseif(PayAdmType="CF"){		//获取注册建卡发票对象
		s prtRtn=##class(BILL.EINV.BL.COM.Common).GetCFInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt, .InvociePam)
	}
	;s:prtRtn'="0" InvociePam.ErrMsgInfo="获取发票信息对象失败"
	q:prtRtn'="0" RtnFlg
	
	;;;增加取或者诊断信息
	;;;;add 20220623   增加诊断信息
	s TmpFlg=##class(BILL.EINV.BL.COM.Common).GetDiseInfoByAdmDr(ObjPatAdmInfo.AdmDr,.ObjInvPrt)          ;患者诊断信息
	//q:TmpFlg'="0" RtnFlg
	
	//将病人基本信息与就诊信息对象赋给发票对象
	s ObjInvPrt.PatBaseInfo=ObjPatBaseInfo      
	s ObjInvPrt.PatAdmInfo=ObjPatAdmInfo
	
	i InvociePam.UserID="" d  ;没有传入 开票人时 用结算人
	.s InvociePam.UserID=ObjInvPrt.BusUserId
	.s InvociePam.UserCode=ObjInvPrt.BusUserCode
	.s InvociePam.UserDesc=ObjInvPrt.BusUserDesc
	
	s RtnFlg="0"
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据票据业务类型与发票表rowid获取病人ID与就诊号
/// Input:		PayAdmType:票据业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金)
/// 			PrtRowID:HIS发生业务ID
/// Return:		病人ID^就诊号
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId("","","")
ClassMethod GetPatIdAndAdmId(PayAdmType As %String, HISPrtRowID As %String) As %String
{
	s RtnFlg="^"
	q:(PayAdmType="")||(HISPrtRowID="") RtnFlg
	s Papmi="",admDr=""
	if (PayAdmType="OP")||(PayAdmType="REG"){        //门诊与挂号
		s Papmi=$p($g(^DHCINVPRT(HISPrtRowID)),"^",15)
		//默认取最后一条就诊信息ID
		s cons=$o(^DHCBCI(0,"INV",HISPrtRowID,""),-1)
		s:cons'="" admDr=$p($g(^DHCBCI(cons)),"^",3)		
	}elseif(PayAdmType="IP"){			//住院
		;s Papmi=$p($g(^DHCINVPRTZY(HISPrtRowID)),"^",18)
		s admDr=$p($g(^DHCINVPRTZY(HISPrtRowID)),"^",4)
		s Papmi=$p($g(^PAADM(admDr)),"^",1)
	}elseif(PayAdmType="API"){			//集中打印发票
		s Papmi=$p($g(^DHCINVPRTAP(HISPrtRowID)),"^",11)
		
		//默认取最后一条发票对应的最后一条就诊信息ID     ????开具前和项目核实集中打印发票就诊信息取那一条信息。
		//注：安徽省立集中打印发票按照就诊拆票，一条发票对应一次就诊信息
		s conPrt=$o(^DHCINVPRTCAPi(0,"APINVDR",HISPrtRowID,""),-1)
		s InvPrtID=$p($g(^DHCINVPRTCAP(conPrt)),"^",1)
		q:InvPrtID="" RtnFlg
		s cons=$o(^DHCBCI(0,"INV",InvPrtID,""),-1)
		s admDr=$p($g(^DHCBCI(cons)),"^",3)		
	}elseif(PayAdmType="DEP"){			//住院预交金
		s admDr=$p($g(^DHCSFPRINTDETAIL(HISPrtRowID)),"^",4) 
		s Papmi=$p($g(^PAADM(admDr)),"^",1)
	}elseif(PayAdmType="PE"){			//体检
		s admDr=$p($g(^DHCPEINVPRT(HISPrtRowID)),"^",2) 
		s Papmi=$p($g(^PAADM(admDr)),"^",1)
	}elseif(PayAdmType="CF"){			//注册建卡费
		s Papmi=$p($g(^DHCCARDINVPRT(HISPrtRowID)),"^",1) 
		s admDr=""
	}
	
	s RtnFlg=Papmi_"^"_admDr
	
	q RtnFlg
}

/// create by zhl 20190828
/// 根据门诊结算id 取门诊发票信息
/// return:就诊号^患者id^账单号^流水号^缴费日期^缴费时间^结算人id^结算人code
///        医保指针^医保金额^总金额^自付金额^医保卡费
/// 	   医保统筹金额^票据类型^发票号^支付方式id
///        结算类型^正记录id^结算人名称
ClassMethod GetOPInvInfoByInvDr(PrtRowid)
{
	quit:(+PrtRowid=0)||('$d(^DHCINVPRT(PrtRowid))) ""
	set rowid=PrtRowid
	set BusinessNo=$p(^DHCINVPRT(PrtRowid),"^",42)		;流水号
	set BusDate=$p(^DHCINVPRT(PrtRowid),"^",5)			;缴费日期
	set BusTime=$p(^DHCINVPRT(PrtRowid),"^",20)			;缴费时间
	set BusUsr=$p(^DHCINVPRT(PrtRowid),"^",21)			;结算人id
	set BusUsrCode=$p(^SSU("SSUSR",BusUsr),"^",1)		;结算人code
	set BusUsrDesc=$p(^SSU("SSUSR",BusUsr),"^",2)		;结算人名称
	set BusUsrGrp=$p(^DHCINVPRT(PrtRowid),"^",41)		;安全组
	set insType=$p(^DHCINVPRT(PrtRowid),"^",9)			;费别指针
	set fairType=$p(^DHCINVPRT(PrtRowid),"^",34)		;缴费类型(F:收费,R:挂号)
	set Papmi=$p(^DHCINVPRT(PrtRowid),"^",15)			;患者id 
	set invNo=$p(^DHCINVPRT(PrtRowid),"^",14)			;发票号
	set invSum=$p(^DHCINVPRT(PrtRowid),"^",1)			;总金额
	set patshare=$p(^DHCINVPRT(PrtRowid),"^",16)		;自付金额
	set insusum=$p(^DHCINVPRT(PrtRowid),"^",31)			;医保金额
	set invflag=$p(^DHCINVPRT(PrtRowid),"^",8)			;结算标志
	set initinv=$p(^DHCINVPRT(PrtRowid),"^",13)			;正记录id指针
	set patshare=patshare-insusum						
	set insdiv=$p(^DHCINVPRT(PrtRowid),"^",30)			;医保指针
	set invoceType=..GetOPInvoiceType(BusUsrGrp,insType,fairType)
	set paysub=$o(^DHCINVPRT(PrtRowid,"P",0))
	set paymode=$p(^DHCINVPRT(PrtRowid,"P",paysub),"^",1)	
	
	set paysub=0,insucardamt=0,insupayamt=0
	for  set paysub=$o(^DHCINVPRT(PrtRowid,"P",paysub))  quit:paysub=""  do
	.set paym=$p(^DHCINVPRT(PrtRowid,"P",paysub),"^",1)		;支付方式id
	.set payModeCode=$p(^CT("CTPM",paym),"^",1)				;支付方式code
	.if payModeCode=InsuCardPayCode  set insucardamt=insucardamt+$p(^DHCINVPRT(PrtRowid,"P",paysub),"^",3)
	.if payModeCode=InsuTCPayCode  set insupayamt=insupayamt+$p(^DHCINVPRT(PrtRowid,"P",paysub),"^",3)


	set cons=0,adm="",invbillstr=""
	for  set cons=$o(^DHCBCI(0,"INV",PrtRowid,cons))  q:cons=""  d
	.set adm=$p(^DHCBCI(cons),"^",3)		;就诊号
	.set invbill=$p(^DHCBCI(cons),"^",2)	;账单号
	.if invbillstr=""  set invbillstr=invbill
	.else  set invbillstr=invbillstr_","_invbill
	
	set PrtBillInfo=adm_"^"_Papmi_"^"_invbillstr_"^"_BusinessNo_"^"_BusDate_"^"_BusTime_"^"_BusUsr_"^"_BusUsrCode   ;;1-8
	set PrtBillInfo=PrtBillInfo_"^"_insdiv_"^"_insusum_"^"_invSum_"^"_patshare_"^"_insucardamt			;;9--13
	set PrtBillInfo=PrtBillInfo_"^"_insupayamt_"^"_invoceType_"^"_invNo_"^"_paymode		;;14--17
	set PrtBillInfo=PrtBillInfo_"^"_invflag_"^"_initinv_"^"_BusUsrDesc												;;18--20
	quit PrtBillInfo
}

/// create by zhl 20190828
/// 根据 安全组 费别  收费类型  判断门诊票据类型
/// update  guoyunlong  多院区需要传院区进来
ClassMethod GetOPInvoiceType(Group, InsType, FairType, HospDr, HospitalFlag)
{
	set myUseINVType="O"
	s myGSVal="",InsmyUseINVType="",myRegReceiptType=""
	if HospitalFlag="1" d
	.;有院区配置时传院区ID,根据是否院区配置增加
	.Set myGSVal=##class(web.UDHCOPGSConfig).ReadCFByGRowID(Group,HospDr)
	.set InsmyUseINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(InsType,"O",HospDr)
	.Set myRegReceiptType=##Class(web.udhcOPBill7).GetRegReceiptType(HospDr)
	else  d
	.Set myGSVal=##class(web.UDHCOPGSConfig).ReadCFByGRowID(Group)
	.set InsmyUseINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(InsType,"O")
	.Set myRegReceiptType=##Class(web.udhcOPBill7).GetRegReceiptType()
	Set myUseINVType=$p(myGSVal,"^",13)
	;set InsmyUseINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(InsType,"O")
	if InsmyUseINVType'="" S myUseINVType=InsmyUseINVType
	;Set myRegReceiptType=##Class(web.udhcOPBill7).GetRegReceiptType()	
	if (FairType="R")&&(myRegReceiptType'="") set myUseINVType=myRegReceiptType
	
	quit myUseINVType
}

/// create by zhl 20190828
/// 根据住院结算id 取门诊发票信息    ;作废不用
ClassMethod GetIPInvInfoByInvDr(PrtRowid)
{
	quit:(+PrtRowid=0)||('$d(^DHCINVPRTZY(PrtRowid))) ""
	set rowid=PrtRowid
	//s BusinessNo=$p(^DHCINVPRTZY(PrtRowid),"^",42)
	s BusDate=$p(^DHCINVPRTZY(PrtRowid),"^",2)
	s BusTime=$p(^DHCINVPRTZY(PrtRowid),"^",3)
	s BusUsr=$p(^DHCINVPRTZY(PrtRowid),"^",7)
	s BusUsrCode=$p(^SSU("SSUSR",BusUsr),"^",1)
	
	
	s adm=$p(^DHCINVPRTZY(PrtRowid),"^",4)
	s invbill=$p(^DHCINVPRTZY(PrtRowid),"^",5)
	s invSum=$p(^DHCINVPRTZY(PrtRowid),"^",6)
	s Papmi=$p(^DHCINVPRTZY(PrtRowid),"^",18)
	s invNo=$p(^DHCINVPRTZY(PrtRowid),"^",1)
	s deposit=$p(^DHCINVPRTZY(PrtRowid),"^",22)
	s BusinessNo="IP"_PrtRowid
	
	s invflag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
	s initinv=$p(^DHCINVPRTZY(PrtRowid),"^",13)
	
	s arrcp=$p(^DHCINVPRTZY(PrtRowid),"^",17)
	s invstype=$p(^DHCPB(+invbill),"^",4)
	s invoceType=##class(web.UDHCJFBaseCommon).GetInvTypeByAdmRea(invstype,"I")
	i $g(invoceType)="" s invoceType="I"
	
	s patshare=$p(^DHCPB(+invbill),"^",12)
	
	s paysub=0,insucardamt=0,insupayamt=0,paymode=""
	s refcash="",reftrans="",rechargecash="",rechargetrans=""
	f  s paysub=$o(^ARRCP(+arrcp,"PAYM",paysub))   q:paysub=""   d
	.s paym=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",1)
	.s payamt=$p(^ARRCP(+arrcp,"PAYM",paysub),"^",3)
	.s payModeCode=$p(^CT("CTPM",paym),"^",1)
	.i payModeCode=InsuCardPayCode  s insucardamt=insucardamt+payamt
	.e  i payModeCode=InsuTCPayCode  s insupayamt=insupayamt+payamt
	.e  d
	..s paymode=payModeCode
	..i payamt>0   d
	...i payModeCode=CashCode   s rechargecash=rechargecash+payamt
	...e  s rechargetrans=rechargetrans+payamt	
	..e  d
	...i payModeCode=CashCode   s rechargecash=rechargecash+payamt
	...e  s rechargetrans=rechargetrans+payamt	

	s insusum=insucardamt+insucardamt
	s patshare=patshare-insusum
	s insdiv=""
	
	set PrtBillInfo=adm_"^"_Papmi_"^"_invbill_"^"_BusinessNo_"^"_BusDate_"^"_BusTime_"^"_BusUsr_"^"_BusUsrCode   ;;1-8
	s PrtBillInfo=PrtBillInfo_"^"_insdiv_"^"_insusum_"^"_invSum_"^"_patshare_"^"_insucardamt			;;9--13
	s PrtBillInfo=PrtBillInfo_"^"_insupayamt_"^"_invoceType_"^"_invNo_"^"_invoceType_"^"_paymode		;;14--18
	s PrtBillInfo=PrtBillInfo_"^"_refcash_"^"_reftrans_"^"_rechargecash_"^"_rechargetrans_"^"_deposit	;;19--23
	
	s PrtBillInfo=PrtBillInfo_"^"_invflag_"^"_initinv												;;24--25
	
	quit PrtBillInfo
}

/// create by zhl 20190828
/// 根据病人id 取病人基本信息
/// 根据就诊id 取本次就诊基本信息
/// return:	登记号^姓名^身份证号^年龄^性别^卡号^卡类型^卡类型编码
/// 		电话号码
ClassMethod GetPatinfo(Papmi)
{
	s cardNO="",cardTypeDr="",cardTypeCode=""
	set patName=$p(^PAPER(Papmi,"ALL"),"^",1)
	set:patName["%" patName=$tr(patName,"%","")								;患者姓名
	set PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2)								;登记号	
   	set PatPhone=$p(^PAPER(Papmi,"PER",1),"^",11)							;电话
	if ($e(PatPhone)'=1)  do
	.set PatPhone=""
	
	//新增地址，shy
 	s Address=""
 	if $d(^PAPER(Papmi,"PER","ADD",1)) do
	.set Address=$g(^PAPER(Papmi,"PER","ADD",1))  							;地址  
	.if $f(Address,"#")'=0  do
    ..set Address=$tr(Address,"#","＃")
    
	set patSexID=$p(^PAPER(Papmi,"ALL"),"^",7)
	set Email=$p($g(^PAPER(Papmi,"PER",4)),"^",19)                          ;邮箱
	set patSex=$p(^CT("SEX",patSexID),"^",2)								;性别
	set:$g(patSex)="不定" patSex=""
	set patIDCardNo=""										
	set patIDCardNo=$p(^PAPER(Papmi,"ALL"),"^",9)							;身份证号
	set PAPMIDOB=$zd($p($g(^PAPER(Papmi,"ALL")),"^",6),3)   				;患者出生日期
 	set patAge=0
 	set patAge=$p($zd(+$h,3),"-",1)-$p(PAPMIDOB,"-",1)						;年龄
 	if patAge=0 s Age=$p($zd(+$h,3),"-",2)-$p(PAPMIDOB,"-",2)_" "_"月"
 	set PapPhone=$p($g(^PAPER(Papmi,"PER",4)),"^",18)       				;工作单位    
 	set rowid="0",cardTypeCode="",cardTypeDr=""
 	
	for  set rowid=$o(^DHCCARDi("CF",0,"PAPMIDR",Papmi,rowid)) quit:rowid=""  do
	.set status=$p(^DHCCARD("CF",rowid),"^",10) ;CF_ActiveFlag Normal||N  正常 Suspend||S  挂失 Reclaim||R  回收 Depose||D  作废	
	.quit:status'="N"
	.q:$l($p(^DHCCARD("CF",rowid),"^",2))>50
	.set cardNO=$p(^DHCCARD("CF",rowid),"^",2)
	.set cardType=$p(^DHCCARD("CF",rowid),"^",16)							;卡号
	.set cardTypeDr=$p(^DHCCARD("CF",rowid),"^",16) 			;卡类型指针
	.set cardTypeCode=$p(^DHCCARDTYPEDef(cardTypeDr),"^",1) 				;卡类型代码
	.;if InsuCardType=$p(^DHCCARDTYPEDef(cardType),"^",1)  set cardTypeDr=$p(^DHCCARD("CF",rowid),"^",16) , cardTypeCode=$p(^DHCCARDTYPEDef(cardTypeDr),"^",1) 
	.;set cardTypeDesc=$p(^DHCCARDTYPEDef(cardTypeDr),"^",2) 				;卡类型描述
	;;如果来类型为空，取母亲卡类型
	set PatMotnerDr=$p(^PAPER(Papmi,"PAT",1),"^",20)					;母亲
	
	set PAPMICardTypeDR=$p(^PAPER(Papmi,"PAT",3),"^",7)	              ;证件类型
	
	
	set patinfo=PatNo_"^"_patName_"^"_patIDCardNo_"^"_patAge_"^"_patSex_"^"_cardNO_"^"_cardTypeDr_"^"_cardTypeCode  ;;1--8
	set patinfo=patinfo_"^"_PatPhone_"^"_Email_"^"_Address_"^"_PAPMICardTypeDR	;;9-10
	quit patinfo
}

/// create 	by zhl 20190828
/// return:	就诊日期^出院日期^科室名称^床号^费别^病案号
/// 		住院天数^病区名称^科室编码
ClassMethod GetAdminfo(Adm)
{
	set LocDr=$p($g(^PAADM(Adm)),"^",4)			;科室id
	set LocCode=$p($g(^CTLOC(LocDr)),"^",1)		;科室编码
    set LocDesc=$p($g(^CTLOC(LocDr)),"^",2)		;科室名称
    set AdmDate=$p(^PAADM(Adm),"^",6)			;就诊日期
	set DisDate=$p(^PAADM(Adm),"^",17)			;出院日期
	set AdmNo=$p(^PAADM(Adm),"^",81)			;
	set RoomId=$p(^PAADM(Adm),"^",69)			;床号id
	set WardId=$p(^PAADM(Adm),"^",70)			;病区id
	set WardDesc="",BedCode="",BedNo=""
	if WardId'=""  do
	.if $d(^PAWARD(WardId)) set WardDesc=$p(^PAWARD(WardId),"^",2),WardDesc=$p(WardDesc,"-",2)
	set AdmReason="自费"
	set AdmReasonId=$p(^PAADM(Adm,1),"^",7)
	if AdmReasonId'="" do
	.if $d(^PAC("ADMREA",AdmReasonId)) s AdmReason=$p(^PAC("ADMREA",AdmReasonId),"^",2)
	set BedRowid=$p(^PAADM(Adm),"^",73)
	set BedNo=""		;add by xubaobao 2021 02 25 赋初值
	if BedRowid'="" do
	.set BedNo=$p(^PAWARD($p(BedRowid,"||",1),"BED",$p(BedRowid,"||",2)),"^",1)		;床号
	set Medicare=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(Adm)				;病案号
	 if DisDate=""   do
	 .set DisDate=+$h
	 .set StayDate=DisDate-AdmDate
	 .set DisDate=""
	 else  do
	 .set StayDate=DisDate-AdmDate													;住院天数
	 
	;add by xubaobao 2020 03 19   ;特病项目
	s SpecCode="", SpecDesc=""
	s DocID=$p(^PAADM(Adm),"^",9)
	i DocID'="" d
	.s SpecDR=$p($g(^CTPCP(DocID,1)),"^",10)
	.i SpecDR'="" d
	..s SpecCode=$p($g(^CT("SPC",SpecDR)),"^",1)
	..s SpecDesc=$p($g(^CT("SPC",SpecDR)),"^",2)
	
	;add by xubaobao 2020 11 08
	s AdmTime=$p(^PAADM(Adm),"^",7)
	s DisTime=$p(^PAADM(Adm),"^",18)			;出院时间
	///获取护理组入院时间和出院时间  guoyunlong
	/*护理接口取就诊日期和时间取值  ????这个是默认，还是直接取医保里面出院时间配置*/
	s AdmDate1=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(Adm),"^",1)	;入院日期 
	s AdmTime1=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(Adm),"^",2)	;入院时间 
	s DisDate1=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(Adm),"^",1)  ;出院日期
	s DisTime1=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(Adm),"^",2)  ;出院时间
	s:AdmDate1'="" AdmDate=AdmDate1
	s:AdmTime1'="" AdmTime=AdmTime1
	s:DisDate1'="" DisDate=DisDate1
	s:DisTime1'="" DisTime=DisTime1
    ;end 2022-06-20  
	s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	s:AdmTime'="" AdmTime=$zt(AdmTime,1)
	s:DisDate'="" DisDate=$zd(DisDate,3)
	s:DisTime'="" DisTime=$zt(DisTime,1)
	s DocID=$p(^PAADM(Adm),"^",9)
	i (DocID="") d
	.s DocCode=""
	.s DocDesc=""
	e   d
	.s DocCode=$p($g(^CTPCP(DocID,1)),"^",1) //医生号
	.s DocDesc=$p($g(^CTPCP(DocID,1)),"^",2) //医生
	
	set adminfo=AdmDate_"^"_DisDate_"^"_LocDesc_"^"_BedNo_"^"_AdmReason_"^"_Medicare	;1-6
	set adminfo=adminfo_"^"_StayDate_"^"_WardDesc_"^"_LocCode_"^"_AdmNo_"^"_SpecCode_"^"_SpecDesc	;7-12
	set adminfo=adminfo_"^^^^^"	;13->17
	set adminfo=adminfo_"^"_AdmTime_"^"_DisTime_"^"_DocCode_"^"_DocDesc_"^"_LocDesc	;18-22
	
	quit adminfo
}

/// create by zhl 20190828
/// 转换时间格式
ClassMethod TransDateTimeForLogic(DateTime)
{
  	s Date=$e(DateTime,1,8)
	s Time=$e(DateTime,9,14)
	s Date=..TransDateForLogic(Date)
	s Time=..TransTimeForLogic(Time)
	q Date_"^"_Time
}

/// create by zhl 20190828
/// 转换时间格式
ClassMethod TransDateForLogic(Date)
{
  	s Date=$e(Date,1,4)_"-"_$e(Date,5,6)_"-"_$e(Date,7,8)
  	s Date=$zdh(Date,3)
  	q Date
}

/// create by zhl 20190828
/// 转换时间格式
ClassMethod TransTimeForLogic(Time)
{
  	s Time=$e(Time,1,2)_":"_$e(Time,3,4)_":"_$e(Time,5,6)
  	s Time=$zth(Time)
  	q Time
}

/// Input:	HISPrtRowID:业务rowid,
/// 		PayAdmType:业务类型(OP:门诊,REG:挂号,OT:门诊跳号,IT:门诊跳号,API:集中打印,IP:住院结算,DEP:住院押金,PE:体检)
/// Desc:	根据业务id和就诊类型获取结算相关信息
/// Output:	金额^日期^时间^用户id^发票号^院区指针
ClassMethod SetUploadDetail(HISPrtRowID As %String, PayAdmType As %String) As %String
{
	
	If (PayAdmType="OP")!(PayAdmType="REG"){
	
		Set PrtAcount=$p(^DHCINVPRT(HISPrtRowID),"^",1)		;金额
		Set PrtDate=$p(^DHCINVPRT(HISPrtRowID),"^",5)		;日期 
		set PrtTime=$p(^DHCINVPRT(HISPrtRowID),"^",20)		;时间
		Set PrtInit=$p(^DHCINVPRT(HISPrtRowID),"^",13)		;正记录id 
		Set PrtInvNo=$p(^DHCINVPRT(HISPrtRowID),"^",14)		;发票号
		set PrtUser=$p(^DHCINVPRT(HISPrtRowID),"^",21)		;用户id
		set PrtHosp=$p(^DHCINVPRT(HISPrtRowID),"^",39) 		;院区指针
		
		
	}Elseif(PayAdmType="OT")!(PayAdmType="IT"){
		
		Set PrtAcount=0	
		Set PrtDate=$p(^DHCVoidInv(HISPrtRowID),"^",1)
		set PrtTime=$p(^DHCVoidInv(HISPrtRowID),"^",2)
		Set PrtInit=""
		Set PrtInvNo=$p(^DHCVoidInv(HISPrtRowID),"^",3)
		set PrtUser=$p(^DHCVoidInv(HISPrtRowID),"^",5)
		set PrtHosp=""
		
		
		
	}Elseif(PayAdmType="API"){
		
		Set PrtAcount=$p(^DHCINVPRTAP(HISPrtRowID),"^",1)	
		Set PrtDate=$p(^DHCINVPRTAP(HISPrtRowID),"^",3) 
		set PrtTime=$p(^DHCINVPRTAP(HISPrtRowID),"^",4)
		Set PrtInit=$p(^DHCINVPRT(HISPrtRowID),"^",10) 
		Set PrtInvNo=$p(^DHCINVPRT(HISPrtRowID),"^",6)
		set PrtUser=$p(^DHCINVPRTAP(HISPrtRowID),"^",5)
		set PrtHosp=$p(^DHCINVPRTAP(HISPrtRowID),"^",30) 		
		
	}Elseif(PayAdmType="IP"){
		
		Set PrtAcount=$p(^DHCINVPRTZY(HISPrtRowID),"^",6)	
		Set PrtDate=$p(^DHCINVPRTZY(HISPrtRowID),"^",2) 
		set PrtTime=$p(^DHCINVPRTZY(HISPrtRowID),"^",3)
		Set PrtInit=$p(^DHCINVPRTZY(HISPrtRowID),"^",13) 
		Set PrtInvNo=$p(^DHCINVPRTZY(HISPrtRowID),"^",6)
		set PrtUser=$p(^DHCINVPRTZY(HISPrtRowID),"^",7)
		set PrtHosp=$p(^DHCINVPRTZY(HISPrtRowID),"^",35)
		Set PrtAdm=$p(^DHCINVPRTZY(HISPrtRowID),"^",4)
		If PrtHosp="" Do
		.set AdmLoc=$p(^PAADM(PrtAdm),"^",4)
    	.set PrtHosp=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmLoc)
		
		
	}Elseif(PayAdmType="DEP"){
		
		Set PrtAcount=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",6)	
		Set PrtDate=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",2) 
		set PrtTime=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",3)
		Set PrtInit=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",43)
		Set PrtInvNo=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",1)
		set PrtUser=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",14)
		set PrtHosp=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",44)
		Set PrtAdm=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",4)
		If PrtHosp="" Do
		.set AdmLoc=$p(^PAADM(PrtAdm),"^",4)
    	.set PrtHosp=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmLoc)
		
	}Elseif(PayAdmType="PE"){
		Set PrtAcount=$p(^DHCPEINVPRT(HISPrtRowID),"^",7)	
		Set PrtDate=$p(^DHCPEINVPRT(HISPrtRowID),"^",11)
		set PrtTime=$p(^DHCPEINVPRT(HISPrtRowID),"^",12)
		Set PrtInit=$p(^DHCPEINVPRT(HISPrtRowID),"^",9)
		Set PrtInvNo=$p(^DHCPEINVPRT(HISPrtRowID),"^",1)
		set PrtUser=$p(^DHCPEINVPRT(HISPrtRowID),"^",10)
		set PrtHosp=$p(^DHCPEINVPRT(HISPrtRowID),"^",26)
		
	}
	Set InvInfo=PrtAcount_"^"_PrtDate_"^"_PrtTime_"^"_PrtUser_"^"_PrtInvNo_"^"_PrtHosp
	Quit InvInfo
}

/// Input:	HISPrtRowID:业务rowid,
/// 		PayAdmType:业务类型(OP:门诊,REG:挂号,OT:门诊跳号,IT:门诊跳号,API:集中打印,IP:住院结算,DEP:住院押金,PE:体检)
/// 	Desc:	根据业务id和业务类型获取原纪录id
/// Output：HISInitDR:原纪录id
ClassMethod GetPrtIDByRefID(HISPrtRowID As %String, PayAdmType As %String) As %String
{
	
	Set HISInitDR=""
	
	If (PayAdmType="OP")!(PayAdmType="REG"){
		Set HISInitDR=$p(^DHCINVPRT(HISPrtRowID),"^",13) 
		
	}Elseif(PayAdmType="API"){
		
		Set HISInitDR=$p(^DHCINVPRTAPi(HISPrtRowID),"^",10) 	
		
	}Elseif(PayAdmType="IP"){
		Set HISInitDR=$p(^DHCINVPRTZY(HISPrtRowID),"^",13)
		
	}Elseif(PayAdmType="DEP"){
		Set HISInitDR=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",43)

	}Elseif(PayAdmType="PE"){
		Set HISInitDR=$p(^DHCPEINVPRT(HISPrtRowID),"^",9)
	}
	Quit HISInitDR
}

/// Input:	HISPrtRowID:业务rowid,
/// 		PayAdmType:业务类型(OP:门诊,REG:挂号,OT:门诊跳号,IT:门诊跳号,API:集中打印,IP:住院结算,DEP:住院押金,PE:体检)
/// 	Desc:	根据业务id和业务类型获取打印发票标志
/// Output：RequisiteInvFlag:发票打印标志(Y:已打印)
ClassMethod GetRequisiteInvFlag(HISPrtRowID As %String, PayAdmType As %String) As %String
{
	
	Set RequisiteInvFlag=""
	Set PrtInvNo=""
	If (PayAdmType="OP")!(PayAdmType="REG"){
	
		Set PrtInvNo=$p(^DHCINVPRT(HISPrtRowID),"^",14)
		
		
	}Elseif(PayAdmType="API"){
		
		Set PrtInvNo=$p(^DHCINVPRT(HISPrtRowID),"^",6)
		
		
	}Elseif(PayAdmType="IP"){
		
		Set PrtInvNo=$p(^DHCINVPRTZY(HISPrtRowID),"^",6)
		
		
	}Elseif(PayAdmType="DEP"){
		
		Set PrtInvNo=$p(^DHCSFPRINTDETAIL(HISPrtRowID),"^",1)
		
	}Elseif(PayAdmType="PE"){
		
		Set PrtInvNo=$p(^DHCPEINVPRT(HISPrtRowID),"^",1)

		
	}
	
	If PrtInvNo'="" Set RequisiteInvFlag="Y"
	
	Quit RequisiteInvFlag
}

/// Creator:xubaobao 
/// CreatDate:2021-04-14
/// Description:根据发票号获取卡发票支付方式信息
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(224344,"")
ClassMethod GetCFPayModeStrByInvDr(InvDr, UserId) As %String
{
	kill CFPayList	
	set CFINVSum=$p(^DHCCARDINVPRT(InvDr),"^",3)
    set IPM="0"
	for  set IPM=$o(^DHCCARDINVPRT(InvDr,"P",IPM)) quit:IPM=""  do
	.set PayInfo=$g(^DHCCARDINVPRT(InvDr,"P",IPM))
	.set PayMId=$p(PayInfo,"^",1)
	.set PayMAmt=+$p(PayInfo,"^",3)
	.set CFPayList(PayMId)=$g(CFPayList(PayMId))+PayMAmt

    set PayMId="",PayModeStr=""
    for  set PayMId=$o(CFPayList(PayMId))  quit:PayMId=""  do
    .set PatMCode=$p(^CT("CTPM",PayMId),"^",1)
    .set PayMDesc=$p(^CT("CTPM",PayMId),"^",2)
    .set PayAmt=$g(CFPayList(PayMId))
	.if PayModeStr="" do
	..set PayModeStr=PatMCode_":"_PayMDesc_":"_PayAmt
	.else  do
	..set PayModeStr=PayModeStr_","_PatMCode_":"_PayMDesc_":"_PayAmt
	quit PayModeStr
}

/// Creator:Suhuide
/// CreatDate:2019-09-16
/// Description:根据发票号获取门诊发票支付方式信息
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(224344,"")
ClassMethod GetOPPayModeStrByInvDr(InvDr, UserId) As %String
{
	kill PayList	
	set INVSum=$p(^DHCINVPRT(InvDr),"^",1)
    set IPM="0"
	for  set IPM=$o(^DHCINVPRT(InvDr,"P",IPM)) quit:IPM=""  do
	.set PayInfo=$g(^DHCINVPRT(InvDr,"P",IPM))
	.set PayMId=$p(PayInfo,"^",1)
	.set PayMAmt=+$p(PayInfo,"^",3)
	.set PayList(PayMId)=$g(PayList(PayMId))+PayMAmt

    set PayMId="",PayModeStr=""
    for  set PayMId=$o(PayList(PayMId))  quit:PayMId=""  do
    .set PatMCode=$p(^CT("CTPM",PayMId),"^",1)
    .set PayMDesc=$p(^CT("CTPM",PayMId),"^",2)
    .set PayAmt=$g(PayList(PayMId))
	.if PayModeStr="" do
	..set PayModeStr=PatMCode_":"_PayMDesc_":"_PayAmt
	.else  do
	..set PayModeStr=PayModeStr_","_PatMCode_":"_PayMDesc_":"_PayAmt
	quit PayModeStr
}

/// Creator:guoyunlong
/// CreatDate:2020-04-09
/// Description:根据发票号获取集中打印发票支付方式信息
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(224344,"")
ClassMethod GetAPIPayModeStrByInvDr(InvDr, UserId) As %String
{
	kill PayList	
    set IPM="0"
	for  set IPM=$o(^DHCINVPRTAP(InvDr,"P",IPM)) quit:IPM=""  do
	.set PayInfo=$g(^DHCINVPRTAP(InvDr,"P",IPM))
	.set PayMId=$p(PayInfo,"^",1)      ;ct_paymode ID
	.set PayMAmt=+$p(PayInfo,"^",3)
	.set PayList(PayMId)=$g(PayList(PayMId))+PayMAmt
    set PayMId="",PayModeStr=""
    for  set PayMId=$o(PayList(PayMId))  quit:PayMId=""  do
    .set PatMCode=$p(^CT("CTPM",PayMId),"^",1)
    .set PayMDesc=$p(^CT("CTPM",PayMId),"^",2)
    .set PayAmt=$g(PayList(PayMId))
	.if PayModeStr="" do
	..set PayModeStr=PatMCode_":"_PayMDesc_":"_PayAmt
	.else  do
	..set PayModeStr=PayModeStr_","_PatMCode_":"_PayMDesc_":"_PayAmt
	quit PayModeStr
}

/// Description:根据账单号获取住院发票支付方式信息
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNo(432829,"")
ClassMethod GetIPPayModeStrByBillNo(BillNo, UserId) As %String
{
	kill PayList
	set TDeposit=##class(web.UDHCJFBaseCommon).GetPaidDeposit(BillNo)
	set ArrcpId=""
	for  set ArrcpId=$o(^ARRCP("ARPBL",BillNo,ArrcpId)) quit:(ArrcpId="")  do
	.set Arral=""
	.for  set Arral=$o(^ARRCP("ARPBL",BillNo,ArrcpId,Arral)) quit:(Arral="")  do
	..set s=^ARRCP(ArrcpId,"RAL",Arral)
	..set DepositType=$p(s,"^",9)
	..quit:(DepositType'="")    //押金记录退出
	..set Paym="0"
	..for  set Paym=$o(^ARRCP(ArrcpId,"PAYM",Paym)) quit:(Paym="")  do
	...set PayInfo=^ARRCP(ArrcpId,"PAYM",Paym)
	...set PayMode=$p(PayInfo,"^",1)
	...set PayAmt=$p(PayInfo,"^",3)
	...quit:(+PayAmt=0)
	...set PayList(PayMode)=$g(PayList(PayMode))+PayAmt
	
	set PayModeStr=""
    set PayMId=""
    for  set PayMId=$o(PayList(PayMId))  quit:(PayMId="")  do
    .set PatMCode=$p(^CT("CTPM",PayMId),"^",1)
    .set PayMDesc=$p(^CT("CTPM",PayMId),"^",2)
    .set PayAmt=$g(PayList(PayMId))
	.if (PayModeStr="") do
	..set PayModeStr=PatMCode_":"_PayMDesc_":"_PayAmt
	.else  do
	..set PayModeStr=PayModeStr_","_PatMCode_":"_PayMDesc_":"_PayAmt
	
	quit "CTYJJ"_":"_"冲退预交金"_":"_TDeposit_","_PayModeStr
}

/// 功能说明：根据账单号获取参与结算押金并从交易表中取出押金票据上传成功后的预交金凭证代码、预交金凭证号码等信息
/// 入参说明: billNo   	  	  --> HIS账单号
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：苏惠德 2019 09 17 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetIPPreDepositByBillDr("")
ClassMethod GetIPPreDepositByBillDr(billNo As %String) As %String
{
    set OutStr=""
	set yjStrs=$g(^DHCJFDepositRowID("ZYJF",billNo))		;从globle中取参与结算的押金串
	quit:(yjStrs="") OutStr
	for i=1:1:$l(yjStrs,"^") do 
	.set myYjStr=$p(yjStrs,"^",i)
	.set rcptrowid=$p(myYjStr,"!",1)						;押金rowID
	.quit:'$d(^DHCSFPRINTDETAIL(rcptrowid))
	.set depttypedr=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",13)	;押金类型，指向arc_deptype为空时代表非押金
	.quit:(depttypedr="")
	.set depttypeCode=$p($g(^ARC("ARCDT",depttypedr)),"^",1)	
	.quit:(depttypeCode'="01")
	.set PrtStatus=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",8)	;押金状态
	.quit:PrtStatus'="1"									;过滤掉非正常押金
	.set amt=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",6)			;押金金额
	.set amt=$fn(amt,"",2)
	.set IUDRowID=""
	.for  set IUDRowID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR","DEP",rcptrowid,IUDRowID))  quit:(IUDRowID="")  do
	..set uploadFlag=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDRowID),9)
	..quit:(uploadFlag'="Y")
	..set VoucherBatchCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDRowID),37)									//电子票据代码-->IUD_BillBatchCode
	..set VoucherBatchNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDRowID),38)
	..set uploadInfo=$fn(amt,"",2)_"^"_$g(VoucherBatchCode)_"^"_$g(VoucherBatchNo)
	..if (OutStr="") set OutStr=uploadInfo
	..else  do  set OutStr=OutStr_"#"_uploadInfo
	quit OutStr
}

/// 功能说明：根据账单号获取参与结算押金的押金rowID
/// 入参说明: billNo   	  	  --> HIS账单号
/// 返 回 值: 参与结算的押金rowID
/// 修改履历：guoyunlong
/// w ##class(BILL.EINV.BL.COM.Common).GetIPPreDepositRowIDByBillDr("")
ClassMethod GetIPPreDepositRowIDByBillDr(billNo As %String) As %String
{
	set OutStr=""
	set yjStrs=$g(^DHCJFDepositRowID("ZYJF",billNo))		;从global中取参与结算的押金串
	quit:(yjStrs="") OutStr
	for i=1:1:$l(yjStrs,"^") do 
	.set myYjStr=$p(yjStrs,"^",i)
	.set rcptrowid=$p(myYjStr,"!",1)						;押金rowID
	.quit:'$d(^DHCSFPRINTDETAIL(rcptrowid))
	.set depttypedr=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",13)	;押金类型，指向arc_deptype为空时代表非押金
	.quit:(depttypedr="")     ;非押金的过滤出去
	.set depttypeCode=$p($g(^ARC("ARCDT",depttypedr)),"^",1)
	.quit:(depttypeCode'="01")
	.set PrtStatus=$p(^DHCSFPRINTDETAIL(rcptrowid),"^",8)	;押金状态
	.quit:PrtStatus'="1"									;过滤掉非正常押金
	.if (OutStr="") set OutStr=rcptrowid
	.else  do  set OutStr=OutStr_"^"_rcptrowid
	q OutStr
}

/// Creator:Suhuide
/// CreatDate:2019-09-16
/// Description:根据发票号获取门诊大类(子分类)编码、名称和金额
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPCatFeeByInvDr(10095,"")
ClassMethod GetOPCatFeeByInvDr(InvDr, UserId) As %String
{
	 //0 给第三方传门诊子分类；1 给第三方传门诊分类
	 set CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 5)
	 //第三方电子发票不区分门诊、住院分类时，his传分类编码时需要做区分
	 set FeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 6)
	 kill CateList
	 set Condr=0
	 for  set Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  quit:(Condr="")  do
	 .set Bill=$p($g(^DHCBCI(Condr)),"^",2)
	 .set BillOrd=0
	 .for  set BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  quit:(BillOrd="")   do
	 ..set BillDetsub=0
	 ..for  set BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   quit:(BillDetsub="")   do
	 ...set tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
	 ...;set amount=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	 ...;add by xubaobao 2021 02 23 取自付金额
	 ...set amount=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",10)
	 ...quit:(+amount=0)									;费用为0的子类不做上传
	 ...quit:tarid=""
	 ...set OPSubCat=$p($g(^DHCTARI(tarid)),"^",15)      ;门诊子类
	 ...set OPCat=$p($G(^DHCTarC("OC",OPSubCat)),"^",3)  ;门诊大类
	 ...set:CatFlag="0" PayList(OPSubCat)=+$g(PayList(OPSubCat))+amount   ;按照门诊子分类统计
	 ...set:CatFlag="1" PayList(OPCat)=+$g(PayList(OPCat))+amount        ;按照门诊大类统计 add by xubaobao 2019 09 23
	 set catedr="",CatePayStr="",cateCode="",cateDesc=""
	 for  set catedr=$o(PayList(catedr)) quit:(catedr="")  do
	 .set:CatFlag="0" cateDesc=$p(^DHCTarC("OC",catedr),"^",2)        ;门诊子分类描述
	 .set:CatFlag="0" cateCode=$p(^DHCTarC("OC",catedr),"^",1)		  ;门诊子分类编码
	 .set:CatFlag="1" cateDesc=$p(^DHCTarC("TOC",catedr),"^",2)        ;门诊分类描述
	 .set:CatFlag="1" cateCode=$p(^DHCTarC("TOC",catedr),"^",1)		  ;门诊分类编码
	 .set CateFee=$g(PayList(catedr))
	 .set CateFee=$fn(CateFee,"",2)       	 ;保留两位小数
	 .if (CatePayStr="")  do
	 ..s CatePayStr=FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode  	  ;宁波鄞州使用分类Dr,其他地方根据情况改造
	 .else  do
	 ..set CatePayStr=CatePayStr_","_FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode
	 quit CatePayStr
}

/// Creator:guoyunlong
/// CreatDate:2020-04-09
/// Description:根据集中打印发票号获取门诊大类(子分类)ID、名称和金额、编码
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPCatFeeByInvDr(223519,"")
ClassMethod GetAPICatFeeByInvDr(InvDr, UserId) As %String
{
	kill ^TempCateList("CatFee")
	set conPrt="",CatePayStr=""
	for  s conPrt=$o(^DHCINVPRTCAPi(0,"APINVDR",InvDr,conPrt)) quit:(conPrt="")  d
	.set InvPrtID=$p($g(^DHCINVPRTCAP(conPrt)),"^",1)
	.set CateStr=##class(BILL.EINV.BL.COM.Common).GetOPCatFeeByInvDr(InvPrtID, UserId)
	.;合并大类
	.for index=1:1:$l(CateStr,",") d
	..set CateDr=$p($p(CateStr,",",index),"^",1)
	..set CateDesc=$p($p(CateStr,",",index),"^",2)
	..set CateFee=$p($p(CateStr,",",index),"^",3)
	..set CateCode=$p($p(CateStr,",",index),"^",4)
	..if $d(^TempCateList("CatFee",CateDr)) do
	...set ^TempCateList("CatFee",CateDr)=CateDr_"^"_CateDesc_"^"_CateCode_"^"_($p($g(^TempCateList("CatFee",CateDr)),"^",4)+CateFee)
	..else  do
	...set ^TempCateList("CatFee",CateDr)=CateDr_"^"_CateDesc_"^"_CateCode_"^"_CateFee
	
	set Id=""
	for  set Id=$o(^TempCateList("CatFee",Id)) quit:(Id="")  do
	.set CateInfo=$g(^TempCateList("CatFee",Id))
	.set CateDr=$p(CateInfo,"^",1)
	.set CateDesc=$p(CateInfo,"^",2)
	.set CateCode=$p(CateInfo,"^",3)
	.set CateFee=$p(CateInfo,"^",4)
	.if (CatePayStr="") do
	..set CatePayStr=CateDr_"^"_CateDesc_"^"_CateFee_"^"_CateCode
	.else  do
	..set CatePayStr=CatePayStr_","_CateDr_"^"_CateDesc_"^"_CateFee_"^"_CateCode
	
	quit CatePayStr
}

/// w ##class(BILL.EINV.BL.COM.Common).GetIPCatFeeByBillNo(432829,"")
ClassMethod GetIPCatFeeByBillNo(BillNo, UserId) As %String
{
	//0 给第三方传住院子分类；1 给第三方传住院分类
	set CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	//第三方电子发票不区分门诊、住院分类时，his传分类编码时需要做区分
	set FeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)  
	kill CateList
	set CatePayStr=""
	;set subcatedr="0"
	;for  set subcatedr=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",BillNo,subcatedr)) quit:subcatedr=""  d
	;.set ipsubcatid=$o(^DHCJFPATIPSUBCATFEE(0,"DHCPB",BillNo,subcatedr,""))
	;.set IPSubCatDr=$p(^DHCJFPATIPSUBCATFEE(ipsubcatid),"^",2)      ;住院子分类
	;.set IPCatDr=$p($g(^DHCTarC("IC",IPSubCatDr)),"^",3)            ;住院分类 
	;.set subfee=$p(^DHCJFPATIPSUBCATFEE(ipsubcatid),"^",3)
	;.quit:(+subfee=0)
	;.set:CatFlag="0" PayList(IPSubCatDr)=+$g(PayList(IPSubCatDr))+subfee       ;按照住院子分类统计
	;.set:CatFlag="1" PayList(IPCatDr)=+$g(PayList(IPCatDr))+subfee   	       ;按照住院分类统计
	
	s BillDr=BillNo
	s PBOSub=0
	f  s PBOSub=$o(^DHCPB(BillDr,"O",PBOSub)) q:PBOSub=""  d
	.s PresNo=""
	.q:('$d(^DHCPB(BillDr,"O",PBOSub)))||($d(^DHCPB(BillDr,"O",PBOSub))=10)
	.s PBDSub=0
	.f  s PBDSub=$o(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	..s PatBillDetailsInfo=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub))
	..s PBDTarDr=$p(PatBillDetailsInfo,"^",3)				;收费项id
	..s IPSubCatDr=$p($g(^DHCTARI(PBDTarDr)),"^",14)		;住院费用子类id
	..s IPCatDr=$p(^DHCTarC("IC",IPSubCatDr),"^",3)			;住院费用大类id
	..;金额取账单 明细表的自付金额
	..s subfee=$p(PatBillDetailsInfo,"^",10)						;金额		;add by xubaobao 2021 03 18  7-->10
	..q:(+subfee=0)
	..set:CatFlag="0" PayList(IPSubCatDr)=+$g(PayList(IPSubCatDr))+subfee       ;按照住院子分类统计
	..set:CatFlag="1" PayList(IPCatDr)=+$g(PayList(IPCatDr))+subfee   	       ;按照住院分类统计
	
	 set catedr="",CatePayStr="",cateCode="",cateDesc=""
	 for  set catedr=$o(PayList(catedr)) quit:(catedr="")  do
	 .set:CatFlag="0" cateDesc=$p(^DHCTarC("IC",catedr),"^",2)  		;住院子分类描述
	 .set:CatFlag="0" cateCode=$p(^DHCTarC("IC",catedr),"^",1)			;住院子分类编码
	 .set:CatFlag="1" cateDesc=$p(^DHCTarC("TIC",catedr),"^",2)        ;住院分类描述
	 .set:CatFlag="1" cateCode=$p(^DHCTarC("TIC",catedr),"^",1)		  ;住院分类编码
	 .set CateFee=+$g(PayList(catedr))
	 .set CateFee=$fn(CateFee,"",2)       	 ;保留两位小数
	 .if (CatePayStr="")  do
	 ..s CatePayStr=FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode		;宁波鄞州使用分类Dr,其他地方根据情况改造
	 .else  do
	 ..set CatePayStr=CatePayStr_","_FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode
	 
	 quit CatePayStr
}

/// Creator:xubaobao
/// CreatDate:2021-04-14
/// Description:根据发票号获取门诊大类(子分类)编码、名称和金额
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetOPCatFeeByInvDr(223519,"")
ClassMethod GetCFCatFeeByInvDr(InvDr, UserId) As %String
{
	 //0 给第三方传门诊子分类；1 给第三方传门诊分类
	 set cateCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "CFFeeCate_Source", 5)
	 set cateDesc=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "CFFeeCate_Source", 6)
	 set CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "CFFeeCate_Source", 7)		//门诊分类还是子类
	 
	 set CateFee=$p($g(^DHCCARDINVPRT(InvDr)),"^",3) 
	 if (CatFlag="1"){			//门诊分类
	 	s catedr=$o(^DHCTarC("TOC",0,"Code",cateCode,""),-1)
	 }else{
		 s catedr=$o(^DHCTarC("OC",0,"Code",cateCode,""),-1)
	 } 
	 s CatePayStr=catedr_"^"_cateDesc_"^"_CateFee_"^"_cateCode  	 
	 quit CatePayStr
}

/// 功能说明：根据门诊发票PrtRowid获取门诊发票相关信息
/// 入参说明: PrtRowid   	  --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 17 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetOPInvPrtInfoObjByPrtId("","","")
ClassMethod GetOPInvPrtInfoObjByPrtId(PrtRowid As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s RtnFlg="-1"
	s InvPrtInfo=$g(^DHCINVPRT(PrtRowid))       ;门诊发票表->DHC_INVPRT
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="门诊发票表无相关数据"
	q:InvPrtInfo="" RtnFlg
	
	;;;add 20220620 增加结算状态判断，非正常数据q掉
	set InvFlag=$p(InvPrtInfo,"^",8) 		;结算状态
	quit:(InvFlag="")||(InvFlag="TP") RtnFlg
	;end 20220620
	s BusUsrGrp=$p(InvPrtInfo,"^",41)                   ;安全组
	s admreasonId=$p(InvPrtInfo,"^",9)                  ;费别
	s admSource=$p($g(^PAC("ADMREA",admreasonId)),"^",9) 
	s fairType=$p(InvPrtInfo,"^",34)   					;缴费类型(F:收费,R:挂号,H:体检)
	;测试暂时使用  测试完删除
	;s InvPrtInfoObj=##class(BILL.EINV.DTO.COM.InvPrtInfo).%New()
	//发票主表信息对象赋值
	s InvPrtInfoObj.BusinessNo=$p(InvPrtInfo,"^",42)    ;业务流水号
	s InvPrtInfoObj.BusDate=$p(InvPrtInfo,"^",5)   	    ;缴费日期      时间格式？？需要转换
	s InvPrtInfoObj.BusTime=$p(InvPrtInfo,"^",20)       ;缴费时间
	s InvPrtInfoObj.BusUserId=$p(InvPrtInfo,"^",21)     ;结算人ID
	s InvPrtInfoObj.BusUserCode=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",1)  ;结算人编码
	s InvPrtInfoObj.BusUserDesc=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",2)  ;结算人名称
	s InvPrtInfoObj.InvAmt=$fn(+$p(InvPrtInfo,"^",1),"",2)   		;总金额
	s InvPrtInfoObj.InvShareAmt=$fn(+$p(InvPrtInfo,"^",16),"",2)    ;自付金额
	; update guoyunlong  增加院区和是否多院区标志
	s:InvociePam.HospitalID="" InvociePam.HospitalID=$p(InvPrtInfo,"^",39)
	s InvPrtInfoObj.InvoceType=##class(BILL.EINV.BL.COM.Common).GetOPInvoiceType(BusUsrGrp,admreasonId,fairType,InvociePam.HospitalID,InvociePam.HospitalFlag)  	;票据类型
	s InvPrtInfoObj.InvNo=$p(InvPrtInfo,"^",14)   		;发票号
	s InvPrtInfoObj.InvFlag=$p(InvPrtInfo,"^",8)   		;结算状态
	s InvPrtInfoObj.InvInit=$p(InvPrtInfo,"^",13)   	;正记录ID
	s InvPrtInfoObj.RecAmt=""   		;应收金额
	s InvPrtInfoObj.RefAmt=""   		;应退金额
	s InvPrtInfoObj.PrtHospDr=$p(InvPrtInfo,"^",39)     ;院区指针
	s InvPrtInfoObj.GroupDr=BusUsrGrp		;安全组指针
	s InvPrtInfoObj.InsTypeDr=admreasonId		;费别指针
	
	;add by xubaobao 2021 02 23 总金额取折扣后金额
	s InvPrtInfoObj.InvAmt=InvPrtInfoObj.InvShareAmt
	
	;add 2023-01-12  guoyunlong增加0费用上传配置    1,不上传  ，其他上传
	s ZeroFeeFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","ZeroFee_Flg",5)
	s:((ZeroFeeFlg="1")&&($fn(InvPrtInfoObj.InvShareAmt,"",2)="0.00")) InvociePam.ErrMsgInfo="0费用不上传电子发票"
	q:((ZeroFeeFlg="1")&&($fn(InvPrtInfoObj.InvShareAmt,"",2)="0.00")) RtnFlg
	//注意：挂号收费如果结算数据存在医保就诊登记表(insu_adminfo),取医保结算对象需要改造，标准版目前都是按照医保结算表取值
	//根据发票rowid获取医保结算相关信息  -->Insu_Divide(医保结算表);Insu_AdmInfo(医保登记表)
	//-xubaobao 2020 08 10 start 注释
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(PrtRowid, "", .InvPrtInfoObj)
	;s:(InvociePam.PayAdmType'="REG")&&(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvInit="") InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(InvociePam.PayAdmType'="REG")&&(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvInit="") RtnFlg
	//-xubaobao 2020 08 10 end 	注释
	//add by xubaobao 2020 08 10 结算对象赋初始值
	//如果为退费需要通过正票ID获取医保结算数据
	;s InvPrtRowid=PrtRowid
	;i InvPrtInfoObj.InvInit'="" s InvPrtRowid=InvPrtInfoObj.InvInit
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(InvPrtRowid, "", .InvPrtInfoObj,"OP")
	;s:(flag'="0")&&(+admSource>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admSource>0) RtnFlg
	//add by xubaobao 2020 09 08 
	//通过医保结算表ID获取医保结算数据
	s DivDr=$p(InvPrtInfo,"^",30)
	s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .InvPrtInfoObj, InvociePam)
	s:(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvAmt>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	q:(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvAmt>0) RtnFlg
	
	//根据门诊发票rowid获取支付方式相关信息  -->DHC_INVPayMode(支付方式表);AR_RcptPayMode(发票表的支付方式表) 
	s flag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr(PrtRowid, "", .InvPrtInfoObj,"OP")
	s:flag'="0" InvociePam.ErrMsgInfo="获取门诊发票支付方式对象失败"
	q:flag'="0" RtnFlg
	
	//根据发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr(PrtRowid, "", .InvPrtInfoObj,"OP")
	s:flag'="0" InvociePam.ErrMsgInfo="获取门诊发票收费大类对象失败"
	q:flag'="0" RtnFlg
	
	//根据发票rowid获取费用明细相关信息    -->DHC_BillConINV(门诊发票账单关联表);DHC_PatientBill;DHC_PatBillOrder;DHC_PatBillDetails  
	s flag=##class(BILL.EINV.BL.COM.Common).GetFeeDetailInfo(PrtRowid,"", .InvPrtInfoObj,"OP",.InvociePam)
	s:flag'="0" InvociePam.ErrMsgInfo="获取门诊发票费用明细对象失败"
	q:flag'="0" RtnFlg
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：根据住院发票PrtRowid获取住院发票相关信息
/// 入参说明: PrtRowid   	  --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 17 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetIPInvPrtInfoObjByPrtId("","","")
ClassMethod GetIPInvPrtInfoObjByPrtId(PrtRowid As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s RtnFlg="-1"
	s InvPrtInfo=$g(^DHCINVPRTZY(PrtRowid))       ;住院发票表->DHC_INVPRTZY
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="住院发票表无相关数据"
	q:InvPrtInfo="" RtnFlg
	
	s InvBill=$p(InvPrtInfo,"^",5)              ;账单号
	s admreasonId=$p($g(^DHCPB(+InvBill)),"^",4)   ;费别ID
	s admNationalCode=$p($g(^PAC("ADMREA",admreasonId)),"^",5) 
	s PrtHospDr=$p(InvPrtInfo,"^",35) 			;院区指针
	s PrtAdmDr=$p(InvPrtInfo,"^",4)          		;就诊号
	i PrtHospDr="" d
	.s AdmLocDr=$p(^PAADM(PrtAdmDr),"^",4)
    .s PrtHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmLocDr)
	//根据住院发票id获取出院结算后补退金额
	 s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
     i ($e(+HISVersion,1)>8) d
     .s BillAmtInfo=..GetPayFeeInfoNew(PrtRowid)
     else  d
     .s BillAmtInfo=..GetPayFeeInfo(PrtRowid)
		
	//发票主表信息对象赋值
	s InvPrtInfoObj.BillDr=InvBill				;账单号
	s InvPrtInfoObj.BusinessNo="IP"_PrtRowid    ;业务流水号
	s InvPrtInfoObj.BusDate=$p(InvPrtInfo,"^",2)   	    ;缴费日期
	s InvPrtInfoObj.BusTime=$p(InvPrtInfo,"^",3)   	    ;缴费时间
	s InvPrtInfoObj.BusUserId=$p(InvPrtInfo,"^",7)     ;结算人ID
	s InvPrtInfoObj.BusUserCode=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",1)  ;结算人编码
	s InvPrtInfoObj.BusUserDesc=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",2)  ;结算人名称
	s InvPrtInfoObj.GroupDr=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",5)  ;用户对应得安全组
	s InvPrtInfoObj.InvAmt=$fn(+$p(InvPrtInfo,"^",6),"",2)   		;总金额
	s InvPrtInfoObj.InvShareAmt=$fn(+$p($g(^DHCPB(+InvBill)),"^",12),"",2)   ;自付金额
	//该类方法不存在
	s InvPrtInfoObj.InvoceType=""     //##class(web.UDHCJFBaseCommon).GetInvTypeByAdmRea(admreasonId,"I")  	;票据类型
	s InvPrtInfoObj.InvNo=$p(InvPrtInfo,"^",1)   		;发票号
	s InvPrtInfoObj.InvFlag=$p(InvPrtInfo,"^",8)   		;结算状态
	s InvPrtInfoObj.InvInit=$p(InvPrtInfo,"^",13)   	;正记录ID
	s InvPrtInfoObj.RecAmt=$fn(+$p(BillAmtInfo,"^",1),"",2)   		;应收金额
	s InvPrtInfoObj.RefAmt=$fn(+$p(BillAmtInfo,"^",2),"",2)   		;应退金额
	s InvPrtInfoObj.DepositAmt=$fn(+$p(InvPrtInfo,"^",22),"",2)    	;预交金
	s InvPrtInfoObj.PrtHospDr=PrtHospDr    					;院区指针
	s InvPrtInfoObj.InsTypeDr=admreasonId		;费别指针
	
	;add by xubaobao 2021 03 18  取自负金额
	s InvPrtInfoObj.InvAmt=InvPrtInfoObj.InvShareAmt
	
	//根据发票rowid获取医保结算相关信息  -->Insu_Divide(医保结算表);Insu_AdmInfo(医保登记表)
	//-xubaobao 2020 08 10 start 注释
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr("", InvBill, .InvPrtInfoObj)
	;s:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvInit="") InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvInit="") RtnFlg
	//-xubaobao 2020 08 10 end 	注释
	//add by xubaobao 2020 08 10 结算对象赋初始值
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr("", InvBill, .InvPrtInfoObj,"IP")
	;s:(flag'="0")&&(+admNationalCode>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admNationalCode>0) RtnFlg
	
	//add by xubaobao 2020 09 08
	//通过医保结算表ID获取医保结算数据
	s DivDr=$p(InvPrtInfo,"^",34)
	s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .InvPrtInfoObj,.InvociePam)
	s:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvAmt>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	q:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvAmt>0) RtnFlg
	
	//根据发票rowid获取支付方式相关信息    -->AR_Receipts;Ar_rcptalloc;Ar_rcptpaymode
	s flag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr("", InvBill, .InvPrtInfoObj,"IP")
	s:flag'="0" InvociePam.ErrMsgInfo="获取住院发票支付方式对象失败"
	q:flag'="0" RtnFlg
	
	//根据账单号获取参与结算预交金明细相关信息      -->dhc_sfprintdetail(预交金明细)
	;GetDepositUpdetailByBill
	;s flag=##class(BILL.EINV.BL.COM.Common).GetIPPreDepositInfoByDr(InvBill, .InvPrtInfoObj)
	s flag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetDepositUpdetailByBill(InvBill, .InvPrtInfoObj)
	s:flag'="0" InvociePam.ErrMsgInfo="获取住院预交金明细对象失败"
	q:flag'="0" RtnFlg
	
	//根据发票rowid获取住院大类相关信息   -->DHC_TarIC(住院分类);DHC_TarInpatCate(住院子分类)
	s flag=##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr("", InvBill, .InvPrtInfoObj,"IP")
	s:flag'="0" InvociePam.ErrMsgInfo="获取住院发票收费大类对象失败"
	q:flag'="0" RtnFlg
	
	//根据账单号获取费用明细相关信息 DHC_PatientBill;DHC_PatBillOrder;DHC_PatBillDetails
	s FeeUpFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeDetail_Flg",5)  
	if (FeeUpFlg="1") {
		s flag=##class(BILL.EINV.BL.COM.Common).GetFeeDetailInfo("",InvBill, .InvPrtInfoObj,"IP",.InvociePam)
		s:flag'="0" InvociePam.ErrMsgInfo="获取住院发票费用明细对象失败"
		q:flag'="0" RtnFlg
	}
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：根据发票Rowid获取门诊跳号与住院跳号发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ##class(BILL.EINV.BL.COM.Common).GetOTAndITPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetOTAndITPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCVoidInv(HISPrtRowID))       ;跳号表->DHC_VoidInv
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="跳号发票表无相关数据"
	q:InvPrtInfo="" RtnFlag
	
	//给发票对象赋值
	s ObjInvPrt.BusinessNo=""			;流水号
	s ObjInvPrt.BusDate=$p(InvPrtInfo,"^",1)   	    ;缴费日期
	s ObjInvPrt.BusTime=$p(InvPrtInfo,"^",2)  	    ;缴费时间
	s ObjInvPrt.InvAmt="0"							;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$p(InvPrtInfo,"^",5)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=$p(InvPrtInfo,"^",3)   		;发票号
	s ObjInvPrt.InvFlag=""   		;结算状态
	s ObjInvPrt.InvInit=""   	;正记录ID
	s ObjInvPrt.PrtHospDr=""     ;院区指针
	
	s RtnFlag="0"
	
	q RtnFlag
}

/// 功能说明：根据发票Rowid获取门诊集中打印发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ##class(BILL.EINV.BL.COM.Common).GetAPIInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetAPIInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCINVPRTAP(HISPrtRowID))       ;集中打印发票表：DHC_AccPayINV
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="集中打印发票表无相关数据"
	q:InvPrtInfo="" RtnFlag
	
	//给发票对象赋值
	s ObjInvPrt.BusinessNo=""			;流水号
	s ObjInvPrt.BusDate=$p(InvPrtInfo,"^",3)   	    ;缴费日期
	s ObjInvPrt.BusTime=$p(InvPrtInfo,"^",4)  	    ;缴费时间
	s ObjInvPrt.InvAmt=$fn(+$p(InvPrtInfo,"^",1),"",2)			;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$p(InvPrtInfo,"^",5)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=$p(InvPrtInfo,"^",6)   		;发票号
	s ObjInvPrt.InvFlag=""   						;结算状态
	s ObjInvPrt.InvInit=$p(InvPrtInfo,"^",10)	   	;正记录ID
	s ObjInvPrt.PrtHospDr=$p(InvPrtInfo,"^",30)     ;院区指针
	
	;add 2020-04-09
	s ObjInvPrt.GroupDr=$p(InvPrtInfo,"^",32)		;安全组指针
	s ObjInvPrt.InsTypeDr=$p(InvPrtInfo,"^",31)		;费别指针
	;s admSource=$p($g(^PAC("ADMREA",ObjInvPrt.InsTypeDr)),"^",9)
	
	//根据发票rowid获取医保结算相关信息  -->Insu_Divide(医保结算表);Insu_AdmInfo(医保登记表)
	//-xubaobao 2020 08 10 start 注释
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(HISPrtRowID, "", .ObjInvPrt,"API")
	;s:(InvociePam.PayAdmType'="REG")&&(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvInit="") InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(InvociePam.PayAdmType'="REG")&&(flag'="0")&&(+admSource>0)&&(InvPrtInfoObj.InvInit="") RtnFlg
	//-xubaobao 2020 08 10 end 	注释
	//add by xubaobao 2020 08 10 结算对象赋初始值
	//如果为退费需要通过正票ID获取医保结算数据
	;s InvPrtRowid=HISPrtRowID
	;i ObjInvPrt.InvInit'="" s InvPrtRowid=ObjInvPrt.InvInit
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(InvPrtRowid, "", .ObjInvPrt,"API")
	;s:(flag'="0") InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0") RtnFlg
	
	//add by xubaobao 2020 09 08
	//通过医保结算表ID获取医保结算数据
	s DivDr=$p(InvPrtInfo,"^",19)
	d ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .ObjInvPrt)
	;s:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvAmt>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admNationalCode>0)&&(InvPrtInfoObj.InvAmt>0) RtnFlg
	
	//根据集中打印发票rowid获取支付方式相关信息  -->DHC_AccPayINVMode(支付方式表);
	s flag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr(HISPrtRowID, "", .ObjInvPrt,"API")
	s:flag'="0" InvociePam.ErrMsgInfo="获取集中打印发票支付方式对象失败"
	q:flag'="0" RtnFlag
	
	//根据集中打印发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr(HISPrtRowID, "", .ObjInvPrt,"API")
	s:flag'="0" InvociePam.ErrMsgInfo="获取集中打印发票收费大类对象失败"
	q:flag'="0" RtnFlag
	
	//根据集中打印发票rowid获取费用明细相关信息    -->DHC_BillConINV(门诊发票账单关联表);DHC_PatientBill;DHC_PatBillOrder;DHC_PatBillDetails  
	s flag=##class(BILL.EINV.BL.COM.Common).GetFeeDetailInfo(HISPrtRowID,"", .ObjInvPrt,"API")
	s:flag'="0" InvociePam.ErrMsgInfo="获取集中打印发票费用明细对象失败"
	q:flag'="0" RtnFlag
	
	s RtnFlag="0"
	
	q RtnFlag
}

/// 功能说明：根据发票Rowid获取住院预交金相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ##class(BILL.EINV.BL.COM.Common).GetDEPInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetDEPInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCSFPRINTDETAIL(HISPrtRowID))       ;预交金明细->dhc_sfprintdetail
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="住院预交金发票无相关数据"
	q:InvPrtInfo="" RtnFlag
	;通过就诊号查询预交金总金额		add by xubaobao 2020 10 13预交金开具用不到，先注释
	;s DepsitStr=..GetIPPreDepositInfoByDr($p(InvPrtInfo,"^",4))
	;q:$p(DepsitStr,"#",1)'="0" RtnFlag
	//给发票对象赋值
	s ObjInvPrt.BusinessNo="DEP"_HISPrtRowID			;流水号
	s ObjInvPrt.BusDate=$p(InvPrtInfo,"^",2)   	    ;缴费日期
	s ObjInvPrt.BusTime=$p(InvPrtInfo,"^",3)  	    ;缴费时间
	s ObjInvPrt.InvAmt=$fn(+$p(InvPrtInfo,"^",6),"",2)			;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$p(InvPrtInfo,"^",14)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=$p(InvPrtInfo,"^",1)   		;发票号
	s ObjInvPrt.InvFlag=""   						;结算状态
	s ObjInvPrt.InvInit=$p(InvPrtInfo,"^",43)	   	;正记录ID
	; add guoyunlong  20190920
	;s ObjInvPrt.DepositAmt=$fn(+$p(DepsitStr,"#",2),"",2)     ;预交金总金额
	s PrtHosp=$p(InvPrtInfo,"^",44)
	s PrtAdm=$p(InvPrtInfo,"^",4)
	i PrtHosp="" d
	.s AdmLoc=$p(^PAADM(PrtAdm),"^",4)
    .s PrtHosp=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmLoc)
	s ObjInvPrt.PrtHospDr=PrtHosp    				 ;院区指针
	
	//add by xubaobao 2020 10 13 增加预交金支付方式
	//根据预交金rowid获取支付方式相关信息    -->AR_Receipts;Ar_rcptalloc;Ar_rcptpaymode
	s PayMId=$p(InvPrtInfo,"^",9)    ;支付方式id
	s PayModeObj=##class(BILL.EINV.DTO.COM.InvPayModeInfo).%New()
	s PayModeObj.Code=$p(^CT("CTPM",PayMId),"^",1)    //支付方式编码
	s PayModeObj.Desc=$p(^CT("CTPM",PayMId),"^",2)      //支付方式名称
	s PayModeObj.Amt=$p(InvPrtInfo,"^",6)       //支付方式金额
	s PayModeObj.Amt=$fn(PayModeObj.Amt,"",2)
	d ObjInvPrt.PayModeInfo.Insert(PayModeObj)
	
	s RtnFlag="0"
	
	q RtnFlag
}

/// 功能说明：根据发票Rowid获取体检发票相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2019 09 19 新做成
/// ##class(BILL.EINV.BL.COM.Common).GetPEInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetPEInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCPEINVPRT(HISPrtRowID))       ; 体检表->DHC_PE_INVPRT
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="体检发票表无相关数据"
	q:InvPrtInfo="" RtnFlag
	
	//给发票对象赋值
	s ObjInvPrt.BusinessNo=""						;流水号
	s ObjInvPrt.BusDate=$p(InvPrtInfo,"^",11)   	;缴费日期
	s ObjInvPrt.BusTime=$p(InvPrtInfo,"^",12)  	    ;缴费时间
	s ObjInvPrt.InvAmt=$fn(+$p(InvPrtInfo,"^",7),"",2)			;总金额
	s ObjInvPrt.InvShareAmt="0"						;自付金额
	s ObjInvPrt.BusUserId=$p(InvPrtInfo,"^",10)		;结算人ID	
	s ObjInvPrt.BusUserCode=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",1)  ;结算人编码
	s ObjInvPrt.BusUserDesc=$p($g(^SSU("SSUSR",ObjInvPrt.BusUserId)),"^",2)  ;结算人名称
	s ObjInvPrt.InvNo=$p(InvPrtInfo,"^",1)   		;发票号
	s ObjInvPrt.InvFlag=$p(InvPrtInfo,"^",8)   		;结算状态
	s ObjInvPrt.InvInit=$p(InvPrtInfo,"^",9)   		;正记录ID
	s ObjInvPrt.PrtHospDr=$p(InvPrtInfo,"^",26)    ;院区指针
	s ObjInvPrt.InvoceType="EH"
	
	s ObjInvPrt.GroupDr=""
	;s ObjInvPrt.InsTypeDr=$p($g(^DHCPEOEITEM(HISPrtRowID)),"^",4)
	;s:ObjInvPrt.InsTypeDr="" ObjInvPrt.InsTypeDr="1"
	
	//根据发票rowid获取医保结算相关信息  -->Insu_Divide(医保结算表);Insu_AdmInfo(医保登记表)
	//add by xubaobao 2020 08 10 结算对象赋初始值
	//如果为退费需要通过正票ID获取医保结算数据
	;s InvPrtRowid=HISPrtRowID
	;i ObjInvPrt.InvInit'="" s InvPrtRowid=ObjInvPrt.InvInit
	;s flag=##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(InvPrtRowid, "", .ObjInvPrt,"PE")
	;s:(flag'="0")&&($d(^DHCINDIV("0","DHCInvPrt",HISPrtRowID))) InvociePam.ErrMsgInfo="获取体检医保结算信息对象失败"
	;q:(flag'="0")&&($d(^DHCINDIV("0","DHCInvPrt",HISPrtRowID))) RtnFlg
	
	//add by xubaobao 2020 09 08
	//通过医保结算表ID获取医保结算数据
	s DivDr=$p($g(^DHCPEOEITEM(HISPrtRowID)),"^",4)
	d ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .ObjInvPrt)
	;s:(flag'="0")&&(+admNationalCode>0)&&(ObjInvPrt.InvAmt>0) InvociePam.ErrMsgInfo="获取医保结算信息对象失败"
	;q:(flag'="0")&&(+admNationalCode>0)&&(ObjInvPrt.InvAmt>0) RtnFlg
	
	//根据门诊发票rowid获取支付方式相关信息  -->DHC_INVPayMode(支付方式表);AR_RcptPayMode(发票表的支付方式表) 
	s flag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr(HISPrtRowID, "", .ObjInvPrt,"PE")
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票支付方式对象失败"
	q:flag'="0" RtnFlag
	
	//根据发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr(HISPrtRowID, "", .ObjInvPrt,"PE")
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票收费大类对象失败"
	q:flag'="0" RtnFlag
	
	//根据发票rowid获取费用明细相关信息    -->DHC_PE_Invprt  ^DHCPEOEITEM
	s flag=##class(BILL.EINV.BL.COM.Common).GetFeeDetailInfo(HISPrtRowID,"", .ObjInvPrt,"PE")
	s:flag'="0" InvociePam.ErrMsgInfo="获取体检发票费用明细对象失败"
	q:flag'="0" RtnFlag
	
	
	s RtnFlag="0"
	
	q RtnFlag
}

/// 功能说明：根据发票Rowid获取注册建卡相关信息
/// 入参说明: HISPrtRowID     --> HIS发生业务发票ID
///           ObjInvPrt 	  --> 发票信息对象
///           InvociePam	  --> 参数对象[出参]
/// 返 回 值: 0 成功 其他值代表失败
/// 修改履历：徐保保 2021 04 12 新做成
/// ##class(BILL.EINV.BL.COM.Common).GetCFInvPrtInfoObjByPrtId(HISPrtRowID,.ObjInvPrt,.InvociePam)
ClassMethod GetCFInvPrtInfoObjByPrtId(HISPrtRowID As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, ByRef InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InvPrtInfo=$g(^DHCCARDINVPRT(HISPrtRowID))       ;卡发票表->DHC_CardINVPRT
	s:InvPrtInfo="" InvociePam.ErrMsgInfo="住院预交金发票无相关数据"
	q:InvPrtInfo="" RtnFlag
	
	//发票主表信息对象赋值
	s InvPrtInfoObj.BusinessNo="CF"_HISPrtRowID    ;业务流水号
	s InvPrtInfoObj.BusDate=$p(InvPrtInfo,"^",4)   	    ;缴费日期      时间格式？？需要转换
	s InvPrtInfoObj.BusTime=$p(InvPrtInfo,"^",5)       ;缴费时间
	s InvPrtInfoObj.BusUserId=$p(InvPrtInfo,"^",6)     ;结算人ID
	s InvPrtInfoObj.BusUserCode=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",1)  ;结算人编码
	s InvPrtInfoObj.BusUserDesc=$p($g(^SSU("SSUSR",InvPrtInfoObj.BusUserId)),"^",2)  ;结算人名称
	s InvPrtInfoObj.InvAmt=$fn(+$p(InvPrtInfo,"^",3),"",2)   		;总金额
	s InvPrtInfoObj.InvShareAmt=$fn(+$p(InvPrtInfo,"^",3),"",2)    ;自付金额
	s InvPrtInfoObj.InvoceType="CF"  	;票据类型
	s InvPrtInfoObj.InvNo=$p(InvPrtInfo,"^",7)   		;发票号
	s InvPrtInfoObj.InvFlag=$p(InvPrtInfo,"^",2)   		;结算状态
	s InvPrtInfoObj.InvInit=$p(InvPrtInfo,"^",8)   	;正记录ID
	s InvPrtInfoObj.RecAmt=""   		;应收金额
	s InvPrtInfoObj.RefAmt=""   		;应退金额
	s InvPrtInfoObj.PrtHospDr=$p(InvPrtInfo,"^",20)     ;院区指针
	s InvPrtInfoObj.InsTypeDr="1"		;费别指针
	
	s DivDr=""
	d ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr(DivDr, .InvPrtInfoObj)
	
	//根据门诊发票rowid获取支付方式相关信息  -->DHC_INVPayMode(支付方式表);DHC_CardINVPRTPayMode(卡发票表的支付方式表) 
	s flag=##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr(HISPrtRowID, "", .InvPrtInfoObj,"CF")
	s:flag'="0" InvociePam.ErrMsgInfo="获取门诊发票支付方式对象失败"
	q:flag'="0" RtnFlag
	
	//根据发票rowid获取门诊大类相关信息     -->DHC_TarOC(门诊分类)
	s flag=##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr(HISPrtRowID, "", .InvPrtInfoObj,"CF")
	s:flag'="0" InvociePam.ErrMsgInfo="获取门诊发票收费大类对象失败"
	q:flag'="0" RtnFlag
	
	s RtnFlag="0"
	
	q RtnFlag
}

/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid或者住院账单号获取医保结算相关信息
/// Input:		PrtRowid:门诊发票rowid
/// 		    PBDr:住院账单号
///             AdmType:就诊类型
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr("","278431","")
ClassMethod GetInsuDivInfoByDrOLd(InvPrtDr As %String, PBDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String = "") As %String
{
	s RtnFlg="-1"
	//初始化对象赋值	add by xubaobao 2020 08 10
	s InsuDivInfoObj=##class(BILL.EINV.DTO.COM.InsuDivideInfo).%New()
	s InsuDivInfoObj.INPAYjjzfe0=0
	s InsuDivInfoObj.INPAYzhzfe0=0         ;医保账户支付
	s InsuDivInfoObj.INPAYgrzfe0=$fn(InvPrtInfoObj.InvAmt,"",2)    ;个人现金支付
	s InsuDivInfoObj.INPAYInsuPay1=0       ;统筹基金支付
	s InsuDivInfoObj.INPAYInsuPay2=0       ;大病基金支付
	s InsuDivInfoObj.INPAYInsuPay3=0       ;公务员基金支付
	s InsuDivInfoObj.INPAYInsuPay4=0       ;民政救助基金支付
	s InsuDivInfoObj.INPAYInsuPay5=0       ;离休基金支付
	s InsuDivInfoObj.INPAYInsuPay6=0       ;自费补充支付
	s InsuDivInfoObj.INPAYInsuPay7=0       ;二乙基金支付
	s InsuDivInfoObj.INPAYInsuPay8=0       ;军转基金支付
	s InsuDivInfoObj.INPAYInsuPay9=0       ;医院垫付
	s InsuDivInfoObj.INPAYInsuPay10=0      ;医保误差
	s InsuDivInfoObj.INPAYZstr23=0         ;个人账户余额
	s InsuDivInfoObj.INPAYdjlsh0=""        ;结算编号
	s InsuDivInfoObj.InsuId=""      	   ;个人编号
	s InsuDivInfoObj.InsuTypeCode=""       ;医保类型
	s InsuDivInfoObj.InsuTypeDesc=""	   ;医保类型名称
	s InsuDivInfoObj.PatType=""			   ;医保类型名称
	s InsuDivInfoObj.HospitalType=""
	s InsuDivInfoObj.HospitalNo=""
	s InvPrtInfoObj.InsuDivInfo=InsuDivInfoObj
	
	q:(InvPrtDr="")&&(PBDr="") RtnFlg
	//住院根据账单号获取医保结算信息
	s DivDr=""
	i (InvPrtDr="")&&(AdmType="IP")&&($d(^DHCINDIV("0","DHCPB",PBDr))) d
	.s DivDr=$o(^DHCINDIV("0","DHCPB",PBDr,""),-1)
	
	//门诊根据发票表rowid获取结算信息
	i (PBDr="")&&(AdmType="OP")&&($d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) d
	.s rowid=""
	.f  s rowid=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,rowid)) q:rowid=""  d
	..s InsuDivInfo=$g(^DHCINDIV(rowid))
	..s AdmDr=$p(InsuDivInfo,"^",1)
	..s Type=$p($g(^PAADM(AdmDr)),"^",2)
	..q:(Type="H")
	..s DivDr=rowid	
	
	//集中打印发票ID获取结算信息 add  2020-04-09
	;i (PBDr="")&&(AdmType="API")&&($d(^DHCINVPRTAPi(0,"APIDR",InvPrtDr))) d
	i (PBDr="")&&(AdmType="API")&&($d(^DHCINVPRTAPi(0,"APIINVDR",InvPrtDr))) d  ;add by xubaobao 2020 08 17
    .s DivDr=$p($g(^DHCINVPRTCAP(InvPrtDr)),"^",19)
    
    //add by xubaobao 2020 08 07
    //体检门诊根据体检发票表rowid获取结算信息
	i (PBDr="")&&(AdmType="PE")&&($d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) d
	.s rowid=""
	.f  s rowid=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,rowid)) q:rowid=""  d
	..s InsuDivInfo=$g(^DHCINDIV(rowid))
	..s AdmDr=$p(InsuDivInfo,"^",1)
	..s Type=$p($g(^PAADM(AdmDr)),"^",2)
	..q:Type'="H"
	..s DivDr=rowid	
	
	
	q:(DivDr="")||('$d(^DHCINDIV(DivDr))) RtnFlg
	
	//医保结算信息对象赋值
	s InsuDivInfo=$g(^DHCINDIV(DivDr))
	;q:$p(InsuDivInfo,"^",5)'="I" RtnFlg	
	;s InsuDivInfoObj=##class(BILL.EINV.DTO.COM.InsuDivideInfo).%New()
	;各项目根据医保结算实际保存值更改下面取值方式
	s InsuDivInfoObj.INPAYjjzfe0=$fn(+$p(InsuDivInfo,"^",19),"",2)         ;医保基金支付
	s InsuDivInfoObj.INPAYzhzfe0=$fn(+$p(InsuDivInfo,"^",28),"",2)         ;医保账户支付
	s InsuDivInfoObj.INPAYgrzfe0=$fn(+$p(InsuDivInfo,"^",15),"",2)         ;个人现金支付
	s InsuDivInfoObj.INPAYInsuPay1=$fn(+$p(InsuDivInfo,"^",31),"",2)       ;统筹基金支付
	s InsuDivInfoObj.INPAYInsuPay2=$fn(+$p(InsuDivInfo,"^",32),"",2)       ;大病基金支付
	s InsuDivInfoObj.INPAYInsuPay3=$fn(+$p(InsuDivInfo,"^",33),"",2)       ;公务员基金支付
	s InsuDivInfoObj.INPAYInsuPay4=$fn(+$p(InsuDivInfo,"^",34),"",2)       ;民政救助基金支付
	s InsuDivInfoObj.INPAYInsuPay5=$fn(+$p(InsuDivInfo,"^",35),"",2)       ;离休基金支付
	s InsuDivInfoObj.INPAYInsuPay6=$fn(+$p(InsuDivInfo,"^",46),"",2)       ;自费补充支付
	s InsuDivInfoObj.INPAYInsuPay7=$fn(+$p(InsuDivInfo,"^",47),"",2)       ;二乙基金支付
	s InsuDivInfoObj.INPAYInsuPay8=$fn(+$p(InsuDivInfo,"^",48),"",2)       ;军转基金支付
	s InsuDivInfoObj.INPAYInsuPay9=$fn(+$p(InsuDivInfo,"^",49),"",2)       ;医院垫付
	s InsuDivInfoObj.INPAYInsuPay10=$fn(+$p(InsuDivInfo,"^",50),"",2)      ;医保误差
	s InsuDivInfoObj.INPAYZstr23=$fn(+$p(InsuDivInfo,"^",63),"",2)        ;个人账户余额
	s InsuDivInfoObj.INPAYdjlsh0=$p(InsuDivInfo,"^",8)      	 ;结算编号
	;s InsuDivInfoObj.INPAYFlag=$p(InsuDivInfo,"^",5)      	 ;结算状态
	s InAdmDr=$p(InsuDivInfo,"^",2)                ;Insu_adminfo指针
	s InAdmInfo=$g(^DHCINADM(InAdmDr))	
	q:InAdmInfo="" RtnFlg	
	s InsuDivInfoObj.InsuId=$p(InAdmInfo,"^",2)      		 ;个人编号
	s InsuDivInfoObj.InsuTypeCode=$p(InAdmInfo,"^",18)      	 ;医保类型
	s InsuDivInfoObj.InsuTypeDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("DLLType",$p(InAdmInfo,"^",18),4)      	 ;医保类型名称
	s InsuDivInfoObj.PatType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AKC021"_$p(InAdmInfo,"^",18),$p(InAdmInfo,"^",4),4)      	 ;医保类型名称
	s InsuDivInfoObj.HospitalType=""
	s InsuDivInfoObj.HospitalNo=""
	s InvPrtInfoObj.InsuDivInfo=InsuDivInfoObj
	;d InvPrtInfoObj.InsuDivInfo.Insert(InsuDivInfoObj)
	;.d InsuDivInfoObj.%Close()
	s RtnFlg="0"
	
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2020-09-08
/// Desc:		根据门诊发票表rowid或者住院账单号获取医保结算相关信息
/// Input:		DivDr:医保结算表ID
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetInsuDivInfoByDr("","278431","")
ClassMethod GetInsuDivInfoByDr(DivDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="-1"
	//初始化对象赋值	add by xubaobao 2020 08 10
	s InsuDivInfoObj=##class(BILL.EINV.DTO.COM.InsuDivideInfo).%New()
	s InsuDivInfoObj.INPAYjjzfe0=0
	s InsuDivInfoObj.INPAYzhzfe0=0         ;医保账户支付
	s InsuDivInfoObj.INPAYgrzfe0=$fn(InvPrtInfoObj.InvAmt,"",2)    ;个人现金支付
	s InsuDivInfoObj.INPAYInsuPay1=0       ;统筹基金支付
	s InsuDivInfoObj.INPAYInsuPay2=0       ;大病基金支付
	s InsuDivInfoObj.INPAYInsuPay3=0       ;公务员基金支付
	s InsuDivInfoObj.INPAYInsuPay4=0       ;民政救助基金支付
	s InsuDivInfoObj.INPAYInsuPay5=0       ;离休基金支付
	s InsuDivInfoObj.INPAYInsuPay6=0       ;自费补充支付
	s InsuDivInfoObj.INPAYInsuPay7=0       ;二乙基金支付
	s InsuDivInfoObj.INPAYInsuPay8=0       ;军转基金支付
	s InsuDivInfoObj.INPAYInsuPay9=0       ;医院垫付
	s InsuDivInfoObj.INPAYInsuPay10=0      ;医保误差
	s InsuDivInfoObj.INPAYZstr23=0         ;个人账户余额
	s InsuDivInfoObj.INPAYdjlsh0=""        ;结算编号
	s InsuDivInfoObj.InsuId=""      	   ;个人编号
	s InsuDivInfoObj.InsuTypeCode=""       ;医保类型
	s InsuDivInfoObj.InsuTypeDesc="自费"	   ;医保类型名称
	s InsuDivInfoObj.PatType=""			   ;医保类型名称
	s InsuDivInfoObj.HospitalType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("HospitalInfo","HosType",4)
	s InsuDivInfoObj.HospitalNo=""
	s InsuDivInfoObj.CenterNo=""			;参保地区
	s InsuDivInfoObj.SelfAmt=$fn(InvPrtInfoObj.InvShareAmt,"",2) 	;自费金额
	s InsuDivInfoObj.selfPayAmt=0			;个人自付
	s InsuDivInfoObj.INPAYZstr26=""  ;符合政策范围金额:
	s InsuDivInfoObj.qfx="" ;起付金额
	s InsuDivInfoObj.INPAYZstr13="" ;先行自付金额:
	s InsuDivInfoObj.INPAYZstr14="" ;超限价自费费用:
	s InsuDivInfoObj.INPAYZstr24="" ;基本医疗保险统筹基金支付比例:
	s InvPrtInfoObj.InsuDivInfo=InsuDivInfoObj
	
	q:(DivDr="")||('$d(^DHCINDIV(DivDr))) "0"
	
	//医保结算信息对象赋值
	s InsuDivInfo=$g(^DHCINDIV(DivDr))
	q:($p(InsuDivInfo,"^",5)="S")||($p(InsuDivInfo,"^",5)="D") "0"	
	s InAdmDr=$p(InsuDivInfo,"^",2)                ;Insu_adminfo指针
	s InAdmInfo=$g(^DHCINADM(InAdmDr))	
	q:InAdmInfo="" RtnFlg	
	s InsuDivInfoObj.InsuId=$p(InAdmInfo,"^",2)      		 	;个人编号
	s InsuDivInfoObj.InsuTypeCode=$p(InAdmInfo,"^",18)      	 ;医保类型
	if (InsuDivInfoObj.InsuTypeCode["00"){
		//医保类型为"00A"或为"00B"时为国家医保
		s InsuDivInfoObj.INPAYjjzfe0=$fn(+$p(InsuDivInfo,"^",19),"",2)         ;医保基金支付
		s InsuDivInfoObj.INPAYzhzfe0=$fn(+$p(InsuDivInfo,"^",28),"",2)         ;医保账户支付
		s InsuDivInfoObj.INPAYgrzfe0=$fn(+$p(InsuDivInfo,"^",15),"",2)         ;个人现金支付
		s InsuDivInfoObj.INPAYInsuPay1=$fn(+$p(InsuDivInfo,"^",31),"",2)       ;统筹基金支付
		s InsuDivInfoObj.INPAYInsuPay2=$fn(+$p(InsuDivInfo,"^",32),"",2)       ;大额医疗补助基金
		s InsuDivInfoObj.INPAYInsuPay3=$fn(+$p(InsuDivInfo,"^",33),"",2)       ;公务员医疗补助基金
		s InsuDivInfoObj.INPAYInsuPay4=$fn(+$p(InsuDivInfo,"^",34),"",2)       ;民政救助基金支付
		s InsuDivInfoObj.INPAYInsuPay5=$fn(+$p(InsuDivInfo,"^",35),"",2)       ;离休基金支付
		s InsuDivInfoObj.INPAYInsuPay6=$fn(+$p(InsuDivInfo,"^",46),"",2)       ;大病补充医疗保险基金
		s InsuDivInfoObj.INPAYInsuPay7=$fn(+$p(InsuDivInfo,"^",47),"",2)       ;公务员大病医疗补助部分
		s InsuDivInfoObj.INPAYInsuPay8=$fn(+$p(InsuDivInfo,"^",48),"",2)       ;保健对象支付
		s InsuDivInfoObj.INPAYInsuPay9=$fn(+$p(InsuDivInfo,"^",49),"",2)       ;医院垫付(单病种垫付)
		s InsuDivInfoObj.INPAYInsuPay10=$fn(+$p(InsuDivInfo,"^",50),"",2)      ;HIS总费用与医保返回数据的误差
		s InsuDivInfoObj.INPAYZstr21=$fn(+$p(InsuDivInfo,"^",61),"",2) 			;个人账户共济支付金额
		s InsuDivInfoObj.INPAYZstr22=$fn(+$p(InsuDivInfo,"^",62),"",2) 			;个人负担总金额
		s InsuDivInfoObj.INPAYZstr23=$fn(+$p(InsuDivInfo,"^",63),"",2)        	;个人账户支出后余额
		s InsuDivInfoObj.INPAYZstr26=$fn(+$p(InsuDivInfo,"^",66),"",2)  ;符合政策范围金额:
	    s InsuDivInfoObj.qfx=$fn(+$p(InsuDivInfo,"^",44),"",2)          ;起付金额
	    s InsuDivInfoObj.INPAYZstr13=$fn(+$p(InsuDivInfo,"^",53),"",2) ;先行自付金额:
	    s InsuDivInfoObj.INPAYZstr14=$fn(+$p(InsuDivInfo,"^",54),"",2) ;超限价自费费用:
	    s InsuDivInfoObj.INPAYZstr24=$fn(+$p(InsuDivInfo,"^",64),"",2) ;基本医疗保险统筹基金支付比例:

	}else{
		//非国家医保(各项目根据医保结算实际保存值更改取值方式)
		s InsuDivInfoObj.INPAYjjzfe0=$fn(+$p(InsuDivInfo,"^",19),"",2)         ;医保基金支付
		s InsuDivInfoObj.INPAYzhzfe0=$fn(+$p(InsuDivInfo,"^",28),"",2)         ;医保账户支付
		s InsuDivInfoObj.INPAYgrzfe0=$fn(+$p(InsuDivInfo,"^",15),"",2)         ;个人现金支付
		s InsuDivInfoObj.INPAYInsuPay1=$fn(+$p(InsuDivInfo,"^",31),"",2)       ;统筹基金支付
		s InsuDivInfoObj.INPAYInsuPay2=$fn(+$p(InsuDivInfo,"^",32),"",2)       ;大病基金支付
		s InsuDivInfoObj.INPAYInsuPay3=$fn(+$p(InsuDivInfo,"^",33),"",2)       ;公务员基金支付
		s InsuDivInfoObj.INPAYInsuPay4=$fn(+$p(InsuDivInfo,"^",34),"",2)       ;民政救助基金支付
		s InsuDivInfoObj.INPAYInsuPay5=$fn(+$p(InsuDivInfo,"^",35),"",2)       ;离休基金支付
		s InsuDivInfoObj.INPAYInsuPay6=$fn(+$p(InsuDivInfo,"^",46),"",2)       ;自费补充支付
		s InsuDivInfoObj.INPAYInsuPay7=$fn(+$p(InsuDivInfo,"^",47),"",2)       ;二乙基金支付
		s InsuDivInfoObj.INPAYInsuPay8=$fn(+$p(InsuDivInfo,"^",48),"",2)       ;军转基金支付
		s InsuDivInfoObj.INPAYInsuPay9=$fn(+$p(InsuDivInfo,"^",49),"",2)       ;医院垫付
		s InsuDivInfoObj.INPAYInsuPay10=$fn(+$p(InsuDivInfo,"^",50),"",2)      ;医保误差
		s InsuDivInfoObj.INPAYZstr23=$fn(+$p(InsuDivInfo,"^",63),"",2)        ;个人账户余额
	}

	s InsuDivInfoObj.INPAYdjlsh0=$p(InsuDivInfo,"^",8)      	 ;结算编号
	;s InsuDivInfoObj.INPAYFlag=$p(InsuDivInfo,"^",5)      	 ;结算状态
	if InvociePam.HospitalFlag="1"  d
	.s InsuDivInfoObj.InsuTypeDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("DLLType",$p(InAdmInfo,"^",18),4,InvociePam.HospitalID) 
	.s InsuDivInfoObj.PatType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AKC021"_$p(InAdmInfo,"^",18),$p(InAdmInfo,"^",4),4,InvociePam.HospitalID)      	 ;医保类型名称
	else  d
	.s InsuDivInfoObj.InsuTypeDesc=##class(web.DHCINSUPort).GetDicByCodeAndInd("DLLType",$p(InAdmInfo,"^",18),4)      	 ;医保类型名称
	.s InsuDivInfoObj.PatType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AKC021"_$p(InAdmInfo,"^",18),$p(InAdmInfo,"^",4),4)      	 ;医保类型名称
	;s InsuDivInfoObj.HospitalType=""
	s InsuDivInfoObj.HospitalNo=""
	s InsuDivInfoObj.CenterNo=$p(InAdmInfo,"^",8) 			;参保地区	add by xubaobao 2020 11 08
	s InsuDivInfoObj.SelfAmt=$fn(+$p(InsuDivInfo,"^",15),"",2)  	;自费金额
	s InsuDivInfoObj.selfPayAmt=0			;个人自付
	s InvPrtInfoObj.InsuDivInfo=InsuDivInfoObj
	s RtnFlg="0"
	
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid或者住院账单号获取支付方式相关信息
/// Input:		InvPrtDr:门诊发票rowid
/// 			PBDr:住院账单号
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType :就诊类型       ;区分集中打印发票和门诊发票ID，，，后续可能还会有体检发票
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByDr("","232690","")
ClassMethod GetPayModeInfoByDr(InvPrtDr As %String, PBDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String) As %String
{
	s RtnFlg="-1"
	q:(InvPrtDr="")&&(PBDr="") RtnFlg
	s PayModeStr=""
	s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
	//获取住院发票支付方式
	;i InvPrtDr="" d
	i AdmType="IP" d
	.i ($e(+HISVersion,1)>8) d
	..s InvPrtDr=$o(^DHCINVPRTZY(0,"AR",PBDr,""),-1)
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNoNew(InvPrtDr,"")   ;add guoyunlong  用于9.0版本
    .else  d
	..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNo(PBDr,"")
	
	;update   2020-04-09   guoyunlong
	//获取门诊发票支付方式
	i (AdmType="OP") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(InvPrtDr, "")
	//获取集中打印发票支付方式
	i (AdmType="API") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetAPIPayModeStrByInvDr(InvPrtDr, "")
	
	;add by xubaobao 2020 08 07 增加获取体检支付方式
	;体检暂时注释
	;add guoyunlong  2023-01-04增加配置，适用于9.0版本
    s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
    i (AdmType="PE")  d
    .i ($e(+HISVersion,1)>8) d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDrNew(InvPrtDr, "")
    .else  d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr(InvPrtDr, "")
	
	//卡发票支付方式表
	i AdmType="CF" d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetCFPayModeStrByInvDr(InvPrtDr, "")
	
	q:PayModeStr="" RtnFlg
	
	//支付方式信息对象赋值
	f num=1:1:$l(PayModeStr,",") d
	.s PayModeInfo=$p(PayModeStr,",",num)
	.s PayModeObj=##class(BILL.EINV.DTO.COM.InvPayModeInfo).%New()
	.s PayModeObj.Code=$p(PayModeInfo,":",1)      //支付方式编码
	.s PayModeObj.Desc=$p(PayModeInfo,":",2)      //支付方式名称
	.s PayModeObj.Amt=$p(PayModeInfo,":",3)       //支付方式金额
	.q:(+PayModeObj.Amt)=0		;add by xubaobao 2020 08 10 支付方式金额为空或者为0时补上传(包括当住院结算除了冲退预交金在没有支付方式时)
	.s:(PayModeObj.Code="CASH")&&(InvPrtDr'="")&&(AdmType="OP") PayModeObj.Amt=$p(PayModeInfo,":",3)-($p($g(^DHCINVPRT(InvPrtDr)),"^",37))   //现金支付方式时，需要考虑分币误差值
	.s PayModeObj.Amt=$fn(PayModeObj.Amt,"",2)
	.//add 2022-11-27 配置支付方式和发票流通关系对照
	.s ExitFlag=##class(%Dictionary.MethodDefinition).%ExistsId("BILL.CFG.COM.GeneralCfg||GetResultByRelaCode")
	.if +ExitFlag>0 d
	..s CfgJsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("INVMNGM.OPBill.ZFFSLTBZDZ",PayModeObj.Code,"1","2")
	..s JsonStr=##class(%DynamicAbstractObject).%FromJSON(CfgJsonStr)
	..s data=JsonStr.data
	..s isArrearsFlag=$p(data,"^",1)
	..s:isArrearsFlag'="" InvPrtInfoObj.isArrearsFlag=$p(data,"^",1)
	.d InvPrtInfoObj.PayModeInfo.Insert(PayModeObj)
	.;d PayModeObj.%Close()
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid获取门诊收费大类信息或者根据账单号获取住院收费大类信息
/// Input:		InvPrtDr:门诊发票rowid
/// 			PBDr:住院账单号
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType  就诊类型    add  guoyunlong   区分门诊收费、集中打印发票、体检业务 
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetCatFeeInfoByDr("232690","","")
ClassMethod GetCatFeeInfoByDr(InvPrtDr As %String, PBDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String) As %String
{
	s RtnFlg="-1"
	q:(InvPrtDr="")&&(PBDr="") RtnFlg
	s CatFeeStr=""
	
	i AdmType="IP" d	//获取住院收费大类信息
	.s CatFeeStr=##class(BILL.EINV.BL.COM.Common).GetIPCatFeeByBillNo(PBDr,"")
	
	i AdmType="OP" d	//获取门诊收费大类信息
	.s CatFeeStr=##class(BILL.EINV.BL.COM.Common).GetOPCatFeeByInvDr(InvPrtDr,"")
	
	i AdmType="API" d	//获取集中打印发票收费大类信息
	.s CatFeeStr=##class(BILL.EINV.BL.COM.Common).GetAPICatFeeByInvDr(InvPrtDr,"")
	
	i AdmType="PE" d	//获取门诊体检收费大类信息
	.s CatFeeStr=##class(BILL.EINV.BL.COM.Common).GetPECatFeeByInvDr(InvPrtDr,"")
	
	i AdmType="CF" d	//获取门诊收费大类信息
	.s CatFeeStr=##class(BILL.EINV.BL.COM.Common).GetCFCatFeeByInvDr(InvPrtDr,"")
	q:CatFeeStr="" RtnFlg
	//;add 2022-10-17 增加，是否过滤0费用金额 1 是，0或其他否
	set ZeroFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","ZeroFlag",6) 
	
	//支付方式信息对象赋值
	f num=1:1:$l(CatFeeStr,",") d
	.s CatFeeInfo=$p(CatFeeStr,",",num)
	.s CatFeeObj=##class(BILL.EINV.DTO.COM.InvCateInfo).%New()
	.s CatFeeObj.Code=$p(CatFeeInfo,"^",4)      //分类编码--默认取分类编码
	.s CatFeeObj.Desc=$p(CatFeeInfo,"^",2)      //分类名称
	.s CatFeeObj.Amt=$fn(+$p(CatFeeInfo,"^",3),"",2)       //分类总金额
	.q:(ZeroFlag="1")&&($fn(+$p(CatFeeInfo,"^",3),"",2)="0.00")
	.d InvPrtInfoObj.InvCateInfo.Insert(CatFeeObj)
	.;d CatFeeObj.%Close()
	
	s RtnFlg="0"
	q RtnFlg
}

/*
/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid或者住院账单号获取费用明细信息
/// Input:		PrtRowid:门诊发票rowid
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType  就诊类型      区分门诊收费、集中打印、体检业务
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetFeeInfoByPrtRowid("232021","","")
ClassMethod GetFeeDetailInfoOld(InvPrtDr As %String, BillNo As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String) As %String
{
	s RtnFlg="-1"
	q:((InvPrtDr="")&&(BillNo=""))||(AdmType="") RtnFlg
	
	i AdmType="IP" d	//获取住院费用明细信息
	.s FeeDetailStr=##class(BILL.EINV.BL.COM.Common).GetFeeDetailByBillNo(BillNo,"")
	
	i AdmType="OP" d	//获取门诊费用明细信息
	.s FeeDetailStr=##class(BILL.EINV.BL.COM.Common).GetFeeDetailByBillNo("",InvPrtDr)
	
	i AdmType="API" d	//获取集中打印发票明细信息
	.s FeeDetailStr=##class(BILL.EINV.BL.COM.Common).GetAPIFeeDetailByBillNo(InvPrtDr)
	q:FeeDetailStr="" RtnFlg
	
	;给费用明细对象赋值
	f num=1:1:$l(FeeDetailStr,",") d
	.s FeeInfo=$p(FeeDetailStr,",",num)
	.s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	.s InvItmObj.DetailNo=$p(FeeInfo,"^",1)   ;明细流水号
	.s InvItmObj.CateCode=$p(FeeInfo,"^",2)   	;子分类编码
	.s InvItmObj.CateCode=$p(FeeInfo,"^",3)   	;大类编码
	.s InvItmObj.PresNo=$p(FeeInfo,"^",4)				   ;处方编码
	.s InvItmObj.DrugTypeCode=""              ;药品类别编码
	.s InvItmObj.DrugTypeDesc=""              ;药品类别名称
	.s InvItmObj.TarCode=$p(FeeInfo,"^",5)          ;项目编码
	.s InvItmObj.TarDesc=$p(FeeInfo,"^",6)          ;项目名称
	.s InvItmObj.Form=$p(FeeInfo,"^",7)       				    ;剂型
	.s InvItmObj.Spec=$p(FeeInfo,"^",8)       				    ;规格
	.s InvItmObj.Unit=$p(FeeInfo,"^",9)										;计量单位
	.s InvItmObj.Price=$fn($p(FeeInfo,"^",10),"",6)				;单价
	.s InvItmObj.Qty=$fn($p(FeeInfo,"^",11),"",2)					;数量
	.s InvItmObj.Amt=$fn($p(FeeInfo,"^",12),"",2)					;金额
	.s InvItmObj.SelfAmt=$fn($p(FeeInfo,"^",13)*(1-(+$p(FeeInfo,"^",16))),"",2)									;自费金额								;自费金额
	.s InvItmObj.RecAmt=""											;应收费用
	.s InvItmObj.SortNo=num									;序号
	.s InvItmObj.Insutjdm=$p(FeeInfo,"^",14)									;医保药品分类
	.s InvItmObj.Insuxmlb=$p(FeeInfo,"^",15)									;医保项目类型
	.s InvItmObj.InsuScale=$p(FeeInfo,"^",16)								;医保报销比例
	.s InvItmObj.Remark=$p(FeeInfo,"^",17)										;备注
	.s InvItmObj.ChrgType=InvItmObj.CateDesc						;费用类型
	.d InvPrtInfoObj.InvItmDetInfo.Insert(InvItmObj)
  
	s RtnFlg="0"
	q RtnFlg
}
*/
/// Creator：	徐保保
/// CreatDate：	2020 08 07
/// Desc:		根据门诊发票表rowid或者住院账单号获取费用明细信息
/// Input:		InvPrtDr:门诊发票rowid
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType  就诊类型      区分门诊收费、集中打印、体检业务
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetFeeInfoByPrtRowid("232021","","")
ClassMethod GetFeeDetailInfo(InvPrtDr As %String, BillNo As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="-1"
	q:((InvPrtDr="")&&(BillNo=""))||(AdmType="") RtnFlg
	
	i AdmType="API" d      //集中打印发票时获取发票ID串
	.s conPrt="",InvPrtStr=""	
  	.for  s conPrt=$o(^DHCINVPRTCAPi(0,"APINVDR",InvPrtDr,conPrt)) q:conPrt=""  d
  	..s InvPrtID=$p($g(^DHCINVPRTCAP(conPrt)),"^",1)
  	..s:InvPrtStr'="" InvPrtStr=InvPrtStr_"^"_InvPrtID
  	..s:InvPrtStr="" InvPrtStr=InvPrtID
  	e  d
  	.s InvPrtStr=InvPrtDr
  	
  	//获取费用明细信息
	s FeeRtn=##class(BILL.EINV.BL.COM.Common).GetFeeDetailByBillNo(BillNo,InvPrtStr,AdmType,.InvociePam)
	q:FeeRtn="" RtnFlg
	
	//住院账单明细：""或0,取收费明细，"1"：按照收费项合并明细 add by xubaobao 2020 05 15
	s IPEINVMerges=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IP_EINVMerges",5) 
	s:IPEINVMerges="" IPEINVMerges="0"		//默认为0(取收费明细)，各个项目不得私自更改 2020 08 07
	s EINVPID=FeeRtn
	q:EINVPID="" RtnFlg
	
	;取费用明细信息赋值给发票对象
	i ((AdmType="IP")&&(IPEINVMerges="1"))||(AdmType="API") d
	.s TarID=""
	.f  s TarID=$o(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,TarID)) q:TarID=""  d
    ..s Price=""
    ..f  s Price=$o(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,TarID,Price)) q:Price=""  d
    ...s FeeInfo=$g(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,TarID,Price))
    ...d ..SetInvPrtDetailInfo(FeeInfo, .InvPrtInfoObj)
    e  d
    .s num=""
    .f  s num=$o(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)) q:num=""  d
    ..s FeeInfo=$g(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num))
    ..d ..SetInvPrtDetailInfo(FeeInfo, .InvPrtInfoObj)
     
    k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	s RtnFlg="0"
	q RtnFlg
}

/// Creator：	xubaobao
/// CreatDate：	2020 08 07
/// Desc:		将费用明细信息赋值给发票对象
/// Input:		FeeInfo:费用明细串
/// Return:		成功标志(0代表成功，其他代表失败)
ClassMethod SetInvPrtDetailInfo(FeeInfo As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	q:FeeInfo="" "-1"
	//;add 2022-10-17 增加，是否过滤0费用金额
	s ZeroFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","ZeroFlag",6)
	s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	s InvItmObj.DetailNo=$p(FeeInfo,"^",2)		    ;明细流水号
	s InvItmObj.CateCode=$p(FeeInfo,"^",3)		   	;子分类编码
	s InvItmObj.CateDesc=$p(FeeInfo,"^",4)   		;大类编码
	s InvItmObj.PresNo=$p(FeeInfo,"^",5)			;处方编码
	s InvItmObj.DrugTypeCode=""           		   ;药品类别编码
	s InvItmObj.DrugTypeDesc=""           		   ;药品类别名称
	s InvItmObj.TarCode=$p(FeeInfo,"^",6)          ;项目编码
	s InvItmObj.TarDesc=$p(FeeInfo,"^",7)          ;项目名称
	s InvItmObj.Form=$p(FeeInfo,"^",8)       				    ;剂型
	s InvItmObj.Spec=$p(FeeInfo,"^",9)       				    ;规格
	s InvItmObj.Unit=$p(FeeInfo,"^",10)							;计量单位
	s InvItmObj.Price=$fn($p(FeeInfo,"^",11),"N")				;单价
	s InvItmObj.Qty=$fn($p(FeeInfo,"^",12),"N")				;数量
	s InvItmObj.Amt=$fn($p(FeeInfo,"^",13),"N")				;金额
	q:(ZeroFlag'="")&&($fn($p(FeeInfo,"^",13),"",2)=0.00) "0"       //add 2022-10-17
	s InvItmObj.SelfAmt=$fn($p(FeeInfo,"^",14),"N")			;自费金额								;自费金额
	s InvItmObj.RecAmt=""										;应收费用
	s InvItmObj.SortNo=$p(FeeInfo,"^",1) 						;序号
	s InvItmObj.Insutjdm=$p(FeeInfo,"^",15)						;医保药品分类
	s InvItmObj.Insuxmlb=$p(FeeInfo,"^",16)						;医保项目类型
	s InvItmObj.InsuScale=$p(FeeInfo,"^",17)					;医保报销比例
	s InvItmObj.Remark=$p(FeeInfo,"^",18)						;备注
	s InvItmObj.ChrgType=InvItmObj.CateDesc						;费用类型
	d InvPrtInfoObj.InvItmDetInfo.Insert(InvItmObj)
	
	q "0"
}

/// 功能：根据集中打印发票ID获取集中打印发票明细,根据大类编码合并
/// input ：InvPrt   -集中打印发票表ID
/// Creator:guoyunlong
/// Date:2020-04-09 
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetAPIFeeDetailByBillNo("232021")      
ClassMethod GetAPIFeeDetailByBillNo(InvPrt As %String) As %String
{
   k ^TempDetailInfo("Detail")
  s conPrt="",Rtn="" 		
  for  s conPrt=$o(^DHCINVPRTCAPi(0,"APINVDR",InvPrt,conPrt)) q:conPrt=""  d
  .s InvPrtID=$p($g(^DHCINVPRTCAP(conPrt)),"^",1)
  .s FeeDetailStr=##class(BILL.EINV.BL.COM.Common).GetFeeDetailByBillNo("",InvPrtID) ;通过发票ID获取费用明细信息
  .for i=1:1:$l(FeeDetailStr,",") d
  ..s DetailNo=$p($p(FeeDetailStr,",",i),"^",1)
  ..s CateCode=$p($p(FeeDetailStr,",",i),"^",2)
  ..s CateDesc=$p($p(FeeDetailStr,",",i),"^",3)
  ..s PresNo=$p($p(FeeDetailStr,",",i),"^",4)
  ..s TarCode=$p($p(FeeDetailStr,",",i),"^",5)
  ..s TarDesc=$p($p(FeeDetailStr,",",i),"^",6)
  ..s Form=$p($p(FeeDetailStr,",",i),"^",7)
  ..s Spec=$p($p(FeeDetailStr,",",i),"^",8)
  ..s ItemUom=$p($p(FeeDetailStr,",",i),"^",9)
  ..s Price=$p($p(FeeDetailStr,",",i),"^",10)
  ..s Qty=$p($p(FeeDetailStr,",",i),"^",11)
  ..s Amt=$p($p(FeeDetailStr,",",i),"^",12)
  ..s SelfAmt=$p($p(FeeDetailStr,",",i),"^",13)
  ..s Insutjdm=$p($p(FeeDetailStr,",",i),"^",14)
  ..s Insuxmlb=$p($p(FeeDetailStr,",",i),"^",15)
  ..s InsuScale=$p($p(FeeDetailStr,",",i),"^",16)
  ..s Remark=$p($p(FeeDetailStr,",",i),"^",17)  
  ..i $d(^TempDetailInfo("Detail",CateCode)) d
  ...s ^TempDetailInfo("Detail",CateCode)=DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_($p($g(^TempDetailInfo("Detail",CateCode)),"^",11)+Qty)_"^"_($p($g(^TempDetailInfo("Detail",CateCode)),"^",12)+Amt)_"^"_($p($g(^TempDetailInfo("Detail",CateCode)),"^",13)+SelfAmt)_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
  ..else  d 
  ...s ^TempDetailInfo("Detail",CateCode)=DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
 
  ;获取明细
  s Id=""
  for  s Id=$o(^TempDetailInfo("Detail",Id)) q:Id=""  d
  .s FeeInfo=$g(^TempDetailInfo("Detail",Id))
  .s DetailNo=$p($p(FeeInfo,",",i),"^",1)
  .s CateCode=$p($p(FeeInfo,",",i),"^",2)
  .s CateDesc=$p($p(FeeInfo,",",i),"^",3)
  .s PresNo=$p($p(FeeInfo,",",i),"^",4)
  .s TarCode=$p($p(FeeInfo,",",i),"^",5)
  .s TarDesc=$p($p(FeeInfo,",",i),"^",6)
  .s Form=$p($p(FeeInfo,",",i),"^",7)
  .s Spec=$p($p(FeeInfo,",",i),"^",8)
  .s ItemUom=$p($p(FeeInfo,",",i),"^",9)
  .s Price=$p($p(FeeInfo,",",i),"^",10)
  .s Qty=$p($p(FeeInfo,",",i),"^",11)
  .s Amt=$p($p(FeeInfo,",",i),"^",12)
  .s SelfAmt=$p($p(FeeInfo,",",i),"^",13)
  .s Insutjdm=$p($p(FeeInfo,",",i),"^",14)
  .s Insuxmlb=$p($p(FeeInfo,",",i),"^",15)
  .s InsuScale=$p($p(FeeInfo,",",i),"^",16)
  .s Remark=$p($p(FeeInfo,",",i),"^",17)  
  .i Rtn=""  d
  ..s Rtn=DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
  .else   d
  ..s Rtn=Rtn_","_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
  q Rtn
}

/*
/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid或者住院账单号获取费用明细信息
/// Input:		PrtRowid:门诊发票rowid
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType  就诊类型      区分门诊收费、集中打印、体检业务
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetFeeInfoByPrtRowid("232021","","")

ClassMethod GetFeeDetailInfoOld(InvPrtDr As %String, BillNo As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo, AdmType As %String) As %String
{
	s RtnFlg="-1"
	q:(InvPrtDr="")&&(BillNo="") RtnFlg
	i (BillNo="")&&(InvPrtDr'="") d
	.q:(InvPrtDr="")||('$d(^DHCBCI(0,"INV",InvPrtDr))) 
	.//根据发票账单关联表的发票ID获取账单表ID
	.s BCInvDr=$o(^DHCBCI(0,"INV",InvPrtDr,""),-1)
	.s BillDr=$p(^DHCBCI(BCInvDr),"^",2)  				;账单号
	.s admreasonId=$p($g(^DHCINVPRT(InvPrtDr)),"^",9)    ;费别
	.;s admSource=$p($g(^PAC("ADMREA",admreasonId)),"^",9) 
	e  i (BillNo'="")&&(InvPrtDr="")  d
	.s BillDr=BillNo    ;账单号
	.q:'$d(^DHCPB(BillDr))
	.s admreasonId=$p(^DHCPB(BillDr),"^",4)    ;费别
	
	q:BillDr="" RtnFlg
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
	
	//获取账单明细信息
	s PBOSub=0
	f  s PBOSub=$o(^DHCPB(BillDr,"O",PBOSub)) q:PBOSub=""  d
	.s PresNo=""
	.q:('$d(^DHCPB(BillDr,"O",PBOSub)))||($d(^DHCPB(BillDr,"O",PBOSub))=10)
	.s OEORI=$p(^DHCPB(BillDr,"O",PBOSub),"^",4)			;医嘱id
	.s Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		;医嘱项id
	.s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR  医嘱子类id
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType  医嘱类型
	.i OrderType["R" d
	..s PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)		;处方号
	.s PBDSub=0,No=1
	.f  s PBDSub=$o(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	..s PatBillDetailsInfo=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub))
	..s PBDTarDr=$p(PatBillDetailsInfo,"^",3)				;收费项id
	..s ItemSubCat=$p($g(^DHCTARI(PBDTarDr)),"^",15)		;费用子类id
	..s ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)			;门诊费用大类id
	..s UomID=$p(^DHCTARI(PBDTarDr),"^",3)					;单位id
	..s ItemUom=$p(^CT("UOM",UomID),"^",2)					;单位名称
	..;//医嘱结构改造后需要从药房接口取
	..s OeTraFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Drug_INCI_Flg",5)      ;医嘱改造标志，改造传"1"，未改造传其他，默认传"1"
	..s DrugInfo=##class(BILL.EINV.BL.COM.Common).GetDrugInfo(Arcim,PBDTarDr,OeTraFlag)   
	..s:DrugInfo="" DrugInfo="^^^^^^^^^"  ;规格^基本单位^入库单位^剂型dr^剂型^厂家^每次用量(等效单位)^频次^剂量单位^批准文号 
	..;add by xubaobao 2020 03 31 药品按照基本单位上传，不在取整包装单位,此处注释 
	..;i OrderType["R" d 
	..;.s ItemUom=$p(DrugInfo,"^",9)    ;计量单位
	..s InsuDr=""
	..s TarConDr="",InsuScale="",Insutjdm="",Remark="",ChrgType="",Insuxmlb=""
	..i InsuType'="" d
	...f  s TarConDr=$o(^DHCINTCT("0","DHCTID",PBDTarDr,TarConDr)) q:TarConDr=""  d
	....s DicType=$p($g(^DHCINTCT(TarConDr)),"^",12)  ;医保目录类型
	....q:InsuType'=DicType
	....s InsuDr=$p($g(^DHCINTCT(TarConDr)),"^",4)    	;医保目录表指针
	....s InsuScale=1-$p($g(^DHCINTIM(InsuDr)),"^",18)		;报销比例
	....s Insutjdm=$p($g(^DHCINTIM(InsuDr)),"^",23)		;项目等级
	....s Remark=$p($g(^DHCINTIM(InsuDr)),"^",22)		;备注
	....s ChrgType=$p($g(^DHCINTIM(InsuDr)),"^",1)		;费用类型
	....s InsuxmlbDr=$p($g(^DHCINTIM(InsuDr)),"^",7)		;项目类型
	....s Insuxmlb=$Case(InsuxmlbDr,"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型
	...;
	
	..;给费用明细对象赋值
	..s InvItmObj=##class(BILL.EINV.DTO.COM.InvItmDetailInfo).%New()
	..s InvItmObj.DetailNo=BillDr_"||"_PBOSub_"||"_PBDSub   ;明细流水号
	..;s InvItmObj.CateCode=$p($g(^DHCTarC("OC",ItemCat)),"^",1)   	;子分类编码
	..;s InvItmObj.CateCode=$p($g(^DHCTarC("OC",ItemSubCat)),"^",3)   	;大类编码
	..i BillNo="" d
	...s:OPCatFlag="1" InvItmObj.CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	...s:OPCatFlag="1" InvItmObj.CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  	;门诊分类名称
	...s:OPCatFlag="0" InvItmObj.CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  	;门诊子分类编码
	...s:OPCatFlag="0" InvItmObj.CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  	;门诊子分类名称
	..i InvPrtDr="" d
	...s:IPCatFlag="1" InvItmObj.CateCode=IPFeeType_$p($g(^DHCTarC("TIC",ItemCat)),"^",1)  	;住院分类编码
	...s:IPCatFlag="1" InvItmObj.CateDesc=$p($g(^DHCTarC("TIC",ItemCat)),"^",2)  	;住院分类名称
	...s:IPCatFlag="0" InvItmObj.CateCode=IPFeeType_$p($g(^DHCTarC("IC",ItemSubCat)),"^",1)  	;住院子分类编码
	...s:IPCatFlag="0" InvItmObj.CateDesc=$p($g(^DHCTarC("IC",ItemSubCat)),"^",2)  	;住院子分类名称
	..s InvItmObj.PresNo=PresNo				   ;处方编码
	..s InvItmObj.DrugTypeCode=""              ;药品类别编码
	..s InvItmObj.DrugTypeDesc=""              ;药品类别名称
	..s InvItmObj.TarCode=$p($g(^DHCTARI(PBDTarDr)),"^",1)          ;项目编码
	..s InvItmObj.TarDesc=$p($g(^DHCTARI(PBDTarDr)),"^",2)          ;项目名称
	..s InvItmObj.Form=$p(DrugInfo,"^",5)       				    ;剂型
	..s InvItmObj.Spec=$p(DrugInfo,"^",1)       				    ;规格
	..s InvItmObj.Unit=ItemUom										;计量单位
	..s InvItmObj.Price=$fn($p(PatBillDetailsInfo,"^",4),"",6)				;单价
	..s InvItmObj.Qty=$fn($p(PatBillDetailsInfo,"^",5),"",2)					;数量
	..s InvItmObj.Amt=$fn($p(PatBillDetailsInfo,"^",7),"",2)					;金额
	..s InvItmObj.SelfAmt=$fn($p(PatBillDetailsInfo,"^",7)*(1-(+InsuScale)),"",2)									;自费金额								;自费金额
	..s InvItmObj.RecAmt=""											;应收费用
	..s InvItmObj.SortNo=No									;序号
	..s InvItmObj.Insutjdm=Insutjdm									;医保药品分类
	..s InvItmObj.Insuxmlb=Insuxmlb									;医保项目类型
	..s InvItmObj.InsuScale=InsuScale								;医保报销比例
	..s InvItmObj.Remark=Remark										;备注
	..s InvItmObj.ChrgType=InvItmObj.CateDesc						;费用类型
	..s No=No+1
	..d InvPrtInfoObj.InvItmDetInfo.Insert(InvItmObj)
  
	s RtnFlg="0"
	q RtnFlg
}*/
/// /通过账单号、发票表ID获取费用明细
/// guoyunlong
/// 2020-04-09
/// Input:BillNo   -账单号 
///       InvPrtDr -发票ID
/// 返回值 
ClassMethod GetFeeDetailByBillNoOld(BillNo As %String, InvPrtDr As %String)
{
	s Rtn="",RtnFlg="-1"
	i (BillNo="")&&(InvPrtDr'="") d
	.q:(InvPrtDr="")||('$d(^DHCBCI(0,"INV",InvPrtDr))) 
	.//根据发票账单关联表的发票ID获取账单表ID
	.s BCInvDr=$o(^DHCBCI(0,"INV",InvPrtDr,""),-1)
	.s BillDr=$p(^DHCBCI(BCInvDr),"^",2)  				;账单号
	.s admreasonId=$p($g(^DHCINVPRT(InvPrtDr)),"^",9)    ;费别
	.;s admSource=$p($g(^PAC("ADMREA",admreasonId)),"^",9) 
	e  i (BillNo'="")&&(InvPrtDr="")  d
	.s BillDr=BillNo    ;账单号
	.q:'$d(^DHCPB(BillDr))
	.s admreasonId=$p(^DHCPB(BillDr),"^",4)    ;费别
	
	q:BillDr="" RtnFlg
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
	
	//获取账单明细信息
	s PBOSub=0
	f  s PBOSub=$o(^DHCPB(BillDr,"O",PBOSub)) q:PBOSub=""  d
	.s PresNo=""
	.q:('$d(^DHCPB(BillDr,"O",PBOSub)))||($d(^DHCPB(BillDr,"O",PBOSub))=10)
	.s OEORI=$p(^DHCPB(BillDr,"O",PBOSub),"^",4)			;医嘱id
	.s Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		;医嘱项id
	.s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR  医嘱子类id
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType  医嘱类型
	.i OrderType["R" d
	..s PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)		;处方号
	.s PBDSub=0,No=1
	.f  s PBDSub=$o(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	..s PatBillDetailsInfo=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub))
	..s PBDTarDr=$p(PatBillDetailsInfo,"^",3)				;收费项id
	..s ItemSubCat=$p($g(^DHCTARI(PBDTarDr)),"^",15)		;费用子类id
	..s ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)			;门诊费用大类id
	..s UomID=$p(^DHCTARI(PBDTarDr),"^",3)					;单位id
	..s ItemUom=$p(^CT("UOM",UomID),"^",2)					;单位名称
	..;//医嘱结构改造后需要从药房接口取
	..s OeTraFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Drug_INCI_Flg",5)      ;医嘱改造标志，改造传"1"，未改造传其他，默认传"1"
	..s DrugInfo=##class(BILL.EINV.BL.COM.Common).GetDrugInfo(Arcim,PBDTarDr,OeTraFlag)   
	..s:DrugInfo="" DrugInfo="^^^^^^^^^"  ;规格^基本单位^入库单位^剂型dr^剂型^厂家^每次用量(等效单位)^频次^剂量单位^批准文号 
    ..;获取门诊分类编码,分类名称
    ..s CateCode="",CateDesc=""
    ..i BillNo="" d
	...s:OPCatFlag="1" CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	...s:OPCatFlag="1" CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  	;门诊分类名称
	...s:OPCatFlag="0" CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  	;门诊子分类编码
	...s:OPCatFlag="0" CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  	;门诊子分类名称
	..i InvPrtDr="" d
	...s:IPCatFlag="1" CateCode=IPFeeType_$p($g(^DHCTarC("TIC",ItemCat)),"^",1)  	;住院分类编码
	...s:IPCatFlag="1" CateDesc=$p($g(^DHCTarC("TIC",ItemCat)),"^",2)  	;住院分类名称
	...s:IPCatFlag="0" CateCode=IPFeeType_$p($g(^DHCTarC("IC",ItemSubCat)),"^",1)  	;住院子分类编码
	...s:IPCatFlag="0" CateDesc=$p($g(^DHCTarC("IC",ItemSubCat)),"^",2)  	;住院子分类名称
    ..;获取目录对照关系
	..s InsuDr=""
	..s TarConDr="",InsuScale="",Insutjdm="",Remark="",ChrgType="",Insuxmlb="",InsuScale="",Insutjdm="",Remark="",ChrgType="",InsuxmlbDr="",SelfAmt=""
	..s DetailNo= BillDr_"||"_PBOSub_"||"_PBDSub              ;流水号
	..s TarCode=$p($g(^DHCTARI(PBDTarDr)),"^",1)              ;项目编码
	..s TarDesc=$p($g(^DHCTARI(PBDTarDr)),"^",2)              ;项目名称
	..s Form=$p(DrugInfo,"^",5)       				    ;剂型
	..s Spec=$p(DrugInfo,"^",1)       				    ;规格
	..s Price=$fn($p(PatBillDetailsInfo,"^",4),"",6)				;单价
	..s Qty=$fn($p(PatBillDetailsInfo,"^",5),"",2)					;数量
	..;金额取账单 明细表的自付金额
	..s Amt=$fn($p(PatBillDetailsInfo,"^",7),"",2)					;金额
	..;s Amt=$fn($p(PatBillDetailsInfo,"^",10),"",2)					;自付金额
	..i InsuType'="" d
	...f  s TarConDr=$o(^DHCINTCT("0","DHCTID",PBDTarDr,TarConDr)) q:TarConDr=""  d
	....s DicType=$p($g(^DHCINTCT(TarConDr)),"^",12)  ;医保目录类型
	....q:InsuType'=DicType
	....s InsuDr=$p($g(^DHCINTCT(TarConDr)),"^",4)    	;医保目录表指针
	....s InsuScale=1-$p($g(^DHCINTIM(InsuDr)),"^",18)		;报销比例
	....s Insutjdm=$p($g(^DHCINTIM(InsuDr)),"^",23)		;项目等级
	....s Remark=$p($g(^DHCINTIM(InsuDr)),"^",22)		;备注
	....s ChrgType=$p($g(^DHCINTIM(InsuDr)),"^",1)		;费用类型
	....s InsuxmlbDr=$p($g(^DHCINTIM(InsuDr)),"^",7)		;项目类型
	....s Insuxmlb=$Case(InsuxmlbDr,"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型
	....s SelfAmt=$fn($p(PatBillDetailsInfo,"^",7)*(1-(+InsuScale)),"",2)	;自费金额
	..i Rtn=""  d
	...s Rtn=DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
	..else   d
	...s Rtn=Rtn_","_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
	q Rtn
}

/// 通过账单号、发票表ID获取费用明细
/// 徐保保
/// 2020 08 07
/// Input:BillNo   -账单号 
///       InvPrtDr -发票ID
/// 返回值  ：成功：进程号,""：失败
ClassMethod GetFeeDetailByBillNo(BillNo As %String, InvPrtStr As %String, AdmType As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s BillStr=""
	i (AdmType="OP")||(AdmType="REG") d		//门诊收费、门诊挂号
	.q:'$d(^DHCBCI(0,"INV",InvPrtStr)) 
	.//根据发票账单关联表的发票ID获取账单表ID
	.s BCInvDr=""
	.f  s BCInvDr=$o(^DHCBCI(0,"INV",InvPrtStr,BCInvDr)) q:BCInvDr=""  d
	..s BillDr=$p(^DHCBCI(BCInvDr),"^",2)  				;账单号
	..s:BillStr'="" BillStr=BillStr_"^"_BillDr
	..s:BillStr="" BillStr=BillDr
	.s admreasonId=$p($g(^DHCINVPRT(InvPrtStr)),"^",9)  ;费别
	i (AdmType="IP") d						//住院收费
	.s BillStr=BillNo    ;账单号
	.q:'$d(^DHCPB(BillStr))
	.s admreasonId=$p(^DHCPB(BillStr),"^",4)    		;费别
	i (AdmType="API") d           			//集中打印发票
	.f i=1:1:$l(InvPrtStr,"^") d
	..s InvPrtDr=$p(InvPrtStr,"^",i)
	..q:'$d(^DHCBCI(0,"INV",InvPrtDr)) 
	..//根据发票账单关联表的发票ID获取账单表ID
	..s BCInvDr=""
	..f  s BCInvDr=$o(^DHCBCI(0,"INV",InvPrtDr,BCInvDr)) q:BCInvDr=""  d
	...s BillDr=$p(^DHCBCI(BCInvDr),"^",2)  				;账单号
	...s:BillStr'="" BillStr=BillStr_"^"_BillDr
	...s:BillStr="" BillStr=BillDr
	..s admreasonId=$p($g(^DHCINVPRT(InvPrtDr)),"^",9)    ;费别
	//add by xubaobao 2020 08 07 获取体检发票明细信息
	i (AdmType="PE") {		//体检收费
		q ##class(BILL.EINV.BL.COM.Common).GetPEFeeDetailByPrtId(InvPrtStr)
	}
	q:BillStr="" ""
	if InvociePam.HospitalFlag="1" d
	.s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6,InvociePam.HospitalID)  ;获取医保类型
	else  d
	.s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
	
	//add by xubaobao 2020 05 15    账单明细存入到临时global
	s EINVPID=$I(^CacheTemp("BILLEINV","GetFeeDetailSum"))
	k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	//""或0,取收费明细，"1"：按照收费项合并明细 
	s IPEINVMerges=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IP_EINVMerges",5) 
	
	//;add 2022-10-17 增加，是否过滤0费用金额 1 是，0或其他否
	set ZeroFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","ZeroFlag",6) 
	//获取账单明细信息
	s num=1
	f BillIndex=1:1:$l(BillStr,"^") d
	.s BillDr=$p(BillStr,"^",BillIndex)
	.s PBOSub=0
	.f  s PBOSub=$o(^DHCPB(BillDr,"O",PBOSub)) q:PBOSub=""  d
	..s PresNo=""
	..q:('$d(^DHCPB(BillDr,"O",PBOSub)))||($d(^DHCPB(BillDr,"O",PBOSub))=10)
	..s OEORI=$p(^DHCPB(BillDr,"O",PBOSub),"^",4)			;医嘱id
	..s Arcim=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		;医嘱项id
	..s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR  医嘱子类id
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType  医嘱类型
	..i OrderType["R" d
	...s PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)		;处方号
	..s PBDSub=0,No=1
	..f  s PBDSub=$o(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	...s PatBillDetailsInfo=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub))
	...s BillDate=$zd($p(PatBillDetailsInfo,"^",11),3)	
    ...s BillTime=$zt($p(PatBillDetailsInfo,"^",12))   
	...s PBDTarDr=$p(PatBillDetailsInfo,"^",3)				;收费项id
	...;s ItemSubCat=$p($g(^DHCTARI(PBDTarDr)),"^",15)		;费用子类id
	...;s ItemCat=$p(^DHCTarC("SC",ItemSubCat),"^",3)		;门诊费用大类id
	...s UomID=$p(^DHCTARI(PBDTarDr),"^",3)					;单位id
	...s ItemUom=$p(^CT("UOM",UomID),"^",2)					;单位名称
	...;//医嘱结构改造后需要从药房接口取
	...s OeTraFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Drug_INCI_Flg",5)      ;医嘱改造标志，改造传"1"，未改造传其他，默认传"1"
	...s DrugInfo=##class(BILL.EINV.BL.COM.Common).GetDrugInfo(Arcim,PBDTarDr,OeTraFlag)   
	...s:DrugInfo="" DrugInfo="^^^^^^^^^"  ;规格^基本单位^入库单位^剂型dr^剂型^厂家^每次用量(等效单位)^频次^剂量单位^批准文号 
    ...;获取门诊分类编码,分类名称
    ...s CateCode="",CateDesc=""
    ...i (AdmType="OP")||(AdmType="REG")||(AdmType="API") d
    ....s ItemSubCat=$p($g(^DHCTARI(PBDTarDr)),"^",15)		;门诊费用子类id
	....s ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)		;门诊费用大类id
	....s:OPCatFlag="1" CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	....s:OPCatFlag="1" CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  			;门诊分类名称
	....s:OPCatFlag="0" CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  ;门诊子分类编码
	....s:OPCatFlag="0" CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  			;门诊子分类名称
	...i AdmType="IP" d
	....s ItemSubCat=$p($g(^DHCTARI(PBDTarDr)),"^",14)		;住院费用子类id
	....s ItemCat=$p(^DHCTarC("IC",ItemSubCat),"^",3)		;门诊费用大类id
	....s:IPCatFlag="1" CateCode=IPFeeType_$p($g(^DHCTarC("TIC",ItemCat)),"^",1)  	;住院分类编码
	....s:IPCatFlag="1" CateDesc=$p($g(^DHCTarC("TIC",ItemCat)),"^",2)  			;住院分类名称
	....s:IPCatFlag="0" CateCode=IPFeeType_$p($g(^DHCTarC("IC",ItemSubCat)),"^",1)  ;住院子分类编码
	....s:IPCatFlag="0" CateDesc=$p($g(^DHCTarC("IC",ItemSubCat)),"^",2)  			;住院子分类名称
    ...;获取目录对照关系
    ...s TarItemInsuInfo=""
    ...i InsuType'="" d
    ....if InvociePam.HospitalFlag="1" d
    .....s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,InvociePam.HospitalID),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	.....s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(PBDTarDr,InsuType,BillDate,TariInsuFlag,InvociePam.HospitalID)
    ....else  d
    .....s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	.....s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(PBDTarDr,InsuType,BillDate,TariInsuFlag)
    ...s InsuScale=1-(+$p(TarItemInsuInfo,"^",18))	;报销比例
 	...s:TarItemInsuInfo="" InsuScale="0"
 	...s Insutjdm=$p(TarItemInsuInfo,"^",23)			;项目等级
 	...s Remark=$p(TarItemInsuInfo,"^",22)			;备注
 	...s ChrgType=$p(TarItemInsuInfo,"^",1)			;费用类型
 	...s Insuxmlb=$Case($p(TarItemInsuInfo,"^",7),"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型				
	...s SelfAmt=$fn($p(PatBillDetailsInfo,"^",7)*(1-(+InsuScale)),"",2)		;自费金额
    ...s DetailNo= BillDr_"||"_PBOSub_"||"_PBDSub              ;流水号
	...s TarCode=$p($g(^DHCTARI(PBDTarDr)),"^",1)              ;项目编码
	...s TarDesc=$p($g(^DHCTARI(PBDTarDr)),"^",2)              ;项目名称
	...s Form=$p(DrugInfo,"^",5)       				    		;剂型
	...s Spec=$p(DrugInfo,"^",1)       				   			;规格
	...;s Price=$p(PatBillDetailsInfo,"^",4)						;单价
	...s Price=$p(PatBillDetailsInfo,"^",20)                    ;取实际价格，有可能有折扣
	...s Qty=$p(PatBillDetailsInfo,"^",5)						;数量
	...;金额取账单 明细表的自付金额
	...;s Amt=$p(PatBillDetailsInfo,"^",7)						;金额
	...;add by xubaobao 2021 02 23 取自付金额
	...s Amt=$p(PatBillDetailsInfo,"^",10)						;自付金额
	...q:(ZeroFlag="1")&&((+Qty=0)||(+Amt=0))   //add by xubaobao 2021 01 29  无费用数据不做上传
	...s SelfAmt=$p(PatBillDetailsInfo,"^",10)*(1-(+InsuScale))   ;自费金额
    ...s BillDetailsRow=num_"^"_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
    ...;
    ...i ((AdmType="IP")&&(IPEINVMerges="1"))||(AdmType="API") d	//按照收费项合并账单明细
    ....i $d(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,PBDTarDr,Price))=0 d
	.....s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,PBDTarDr,Price)=BillDetailsRow
	....e  d
	.....s BillDetailsRow=$g(^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,PBDTarDr,Price))
    .....s $p(BillDetailsRow,"^",12)=+$p(BillDetailsRow,"^",12)+Qty
    .....s $p(BillDetailsRow,"^",13)=+$p(BillDetailsRow,"^",13)+Amt
    .....s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,PBDTarDr,Price)=BillDetailsRow
    ...e  d
    ....s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)=BillDetailsRow
    ...s num=num+1
    
	q EINVPID
}

/// 功能说明：通过Papatmas表ID获取患者基本信息,并将值赋给ObjPatBaseInfo对象
/// 入参说明：PapmiDr——>基本信息表ID ，ObjPatBaseInfo->存放基本信息对象 
/// 出参说明：0 成功   -1 失败
/// 创建：  guoyunlong
ClassMethod GetPatBaseInfoByPapmiDr(PapmiDr As %String, ObjPatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo) As %String
{
	;获取基本信息
    q:PapmiDr="" "-1"
	set PapmiInfo=##class(BILL.EINV.BL.COM.Common).GetPatinfo(PapmiDr)
	q:PapmiInfo="" "-1"
	i $isObject(ObjPatBaseInfo)=0  d
	.set ObjPatBaseInfo=##class(BILL.EINV.DTO.COM.PatBaseInfo).%New() 
	s ObjPatBaseInfo.PAPMINO=$p(PapmiInfo,"^",1)     ;登记号
	s ObjPatBaseInfo.PatName=$p(PapmiInfo,"^",2)     ;姓名
	s ObjPatBaseInfo.PatID=$p(PapmiInfo,"^",3)       ;身份证号
	s ObjPatBaseInfo.Sex=$p(PapmiInfo,"^",5)         ;性别
	s ObjPatBaseInfo.Age=$p(PapmiInfo,"^",4)         ;年龄
	s ObjPatBaseInfo.Mobphone=$p(PapmiInfo,"^",9)    ;电话
	s ObjPatBaseInfo.PatEmail=$p(PapmiInfo,"^",10)    ;邮箱
	s ObjPatBaseInfo.CardType=$p(PapmiInfo,"^",8)    ;卡类型
	s ObjPatBaseInfo.CardNo=$p(PapmiInfo,"^",6)      ;卡号
	s ObjPatBaseInfo.Address=$p(PapmiInfo,"^",11)      ;地址
	s ObjPatBaseInfo.PaPmiDr=PapmiDr    ;add guoyunlong  增加基本信息ID 
	;b ;d ObjPatBaseInfo.%Close()
    q "0"
}

/// 功能说明：通过AdmDr获取患者就诊信息，并将值赋给ObjPatAdmInfo对象
/// 入参说明：PapmiDr——>基本信息表ID ，ObjPatBaseInfo->存放基本信息对象 
/// 出参说明：0 成功   -1 失败
/// 创建：  guoyunlong
ClassMethod GetAdmInfoByAdmDr(AdmDr As %String, ObjPatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo) As %String
{
   
    ;获取基本信息
    q:AdmDr="" "-1"
	set PaadmInfo=##class(BILL.EINV.BL.COM.Common).GetAdminfo(AdmDr)
	q:PaadmInfo="" "-1" 
	i $isObject(ObjPatAdmInfo)=0  d
	.s ObjPatAdmInfo=##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()
	s ObjPatAdmInfo.AdmDr=AdmDr     			    ;住院就诊编号
	s ObjPatAdmInfo.AdmNo=$p(PaadmInfo,"^",10)      ;患者就诊编号
	s ObjPatAdmInfo.AdmDate=$p(PaadmInfo,"^",1)    ;就诊日期(住院日期)(格式:yyyy-MM-dd) 
	s ObjPatAdmInfo.DepCode=$p(PaadmInfo,"^",9)    ;就诊科室编码
	s ObjPatAdmInfo.DepDesc=$p(PaadmInfo,"^",3)    ;就诊科室名称
	s ObjPatAdmInfo.IPNo=$p(PaadmInfo,"^",10)       ;患者住院号
	s ObjPatAdmInfo.MedicalCode=$p(PaadmInfo,"^",6)  ;病历号
	s ObjPatAdmInfo.OutDate=$p(PaadmInfo,"^",2)     ;出院日期
	s ObjPatAdmInfo.OutDepCode=$p(PaadmInfo,"^",9)   ;出院科室编码
	s ObjPatAdmInfo.OutDepDesc=$p(PaadmInfo,"^",3)   ;出院科室名称
	s ObjPatAdmInfo.SpecDesc=$p(PaadmInfo,"^",12)     ;特殊病种名称
	s ObjPatAdmInfo.WardDesc=$p(PaadmInfo,"^",8)     ;病区
	s ObjPatAdmInfo.IPDays=$p(PaadmInfo,"^",7)       ;住院天数
	s ObjPatAdmInfo.BedCode=$p(PaadmInfo,"^",4)      ;床号
	
	;add by xubaobao 2020 11 08
	s ObjPatAdmInfo.AdmTime=$p(PaadmInfo,"^",18)	;就诊时间
	s ObjPatAdmInfo.OutTime=$p(PaadmInfo,"^",19)	;出院时间
	s ObjPatAdmInfo.DocCode=$p(PaadmInfo,"^",20)	;就诊医生编码
	s ObjPatAdmInfo.DocDesc=$p(PaadmInfo,"^",21)	;就诊医生名称
	
	;b ;d ObjPatAdmInfo.%Close()
	q "0"
}

/// 功能说明：通过AdmDr获取患者诊断信息，并将值赋给ObjDiseInfo对象
/// 入参说明：AdmDr——>就诊表ID ，ObjDiseInfo->存放基本信息对象 
/// 出参说明：0 成功   -1 失败
/// 创建：  guoyunlong
ClassMethod GetDiseInfoByAdmDr(AdmDr As %String, ByRef ObjInvPrt As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	 q:AdmDr="" "-1"
	s AdmReasonDR=$p(^PAADM(AdmDr,1),"^",7) //病人计费类别
	s InsuType=""
	s:(AdmReasonDR'="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6)
	s PatDiagAll=##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(AdmDr,"","^"_InsuType)
	for index=1:1:$l(PatDiagAll,"$")  d
	.s ObjDiseInfo=##class(BILL.EINV.DTO.COM.DiagnosisInfo).%New()
	.s ObjDiseInfo.DiagnosValue=$p($p(PatDiagAll,"$",index),"^",1)
	.s ObjDiseInfo.DiagnosCodeRowid=$p($p(PatDiagAll,"$",index),"^",2)
	.s ObjDiseInfo.DiagnosICDCode=$p($p(PatDiagAll,"$",index),"^",3)
	.s ObjDiseInfo.DiagnosDesc=$p($p(PatDiagAll,"$",index),"^",4)
	.s ObjDiseInfo.DiagnosMRDesc=$p($p(PatDiagAll,"$",index),"^",5)
	.s ObjDiseInfo.DiagnosType=$p($p(PatDiagAll,"$",index),"^",6)
	.s ObjDiseInfo.DiagnosDate=$p($p(PatDiagAll,"$",index),"^",1)
	.s ObjDiseInfo.DiagnosOnsetDate=$p($p(PatDiagAll,"$",index),"^",7)
	.s ObjDiseInfo.DiagStat=$p($p(PatDiagAll,"$",index),"^",8)
	.s ObjDiseInfo.DiagnosLeavel=$p($p(PatDiagAll,"$",index),"^",9)
	.s ObjDiseInfo.InsuDiagCode=$p($p(PatDiagAll,"$",index),"^",10)
	.s ObjDiseInfo.InsuDiagDesc=$p($p(PatDiagAll,"$",index),"^",11)
	.s ObjDiseInfo.MainDiagFlag=$p($p(PatDiagAll,"$",index),"^",12)
	.d ObjInvPrt.DiagnosisInfo.Insert(ObjDiseInfo)
	
	q 0
}

/// Creator：	guoyunlong
/// CreatDate：	2019-09-18
/// Desc:		根据住院账单号获取预交金相关信息
/// Input:		PBDr:住院账单号
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetIPPreDepositInfoByDr("213131","")
ClassMethod GetIPPreDepositInfoByDr(PBDr As %String, ByRef InvPrtInfoObj As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s rtn="-1"
	q:(PBDr="") rtn
	s IPPreDepositStr=""
	//通过账单号获取住院预交金
	s IPPreDepositStr=##class(BILL.EINV.BL.COM.Common).GetIPPreDepositByBillDr(PBDr)
	q:IPPreDepositStr="" rtn
	
	//预交金对象信息赋值
	f num=1:1:$l(IPPreDepositStr,"#") d
	.s PreDepositInfo=$p(IPPreDepositStr,",",num)
	.s PreDepositObj=##class(BILL.EINV.DTO.COM.IPPreDepositInfo).%New()
	.s PreDepositObj.voucherAmt=$fn(+$p(PreDepositInfo,"^",1),"",2)             //预交金凭证消费金额
	.s PreDepositObj.voucherBatchCode=$p(PreDepositInfo,"^",2)       //预交金凭证代码
	.s PreDepositObj.voucherNo=$p(PreDepositInfo,"^",3)              //预交金凭证号码
	.d InvPrtInfoObj.PreDepositObj.Insert(PreDepositObj)
	s rtn="0"
	q rtn
}

/// 功能说明：根据医嘱项Id或者收费项Id获取药品相关信息
/// 入参说明: strArcimDr      --> 医嘱项Id
/// 			  TarId			  --> 收费项Id
/// 		  OeTraFlag       --> 医嘱改造标识
/// 返 回 值: 药品相关信息串
/// 修改履历：徐保保 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetDrugInfo()
ClassMethod GetDrugInfo(strArcimDr As %String, TarId As %String, OeTraFlag As %String) As %String
{
	s DrugInfo="^^^^^^^^^"
	
	if (OeTraFlag="1")&&(TarId'="") {
		s DrugInfo=##class(web.DHCSTINTERFACE).GetDrugInfoByTar(TarId)
		q:DrugInfo="" DrugInfo
	}else{
		q:strArcimDr="" DrugInfo
		s FormStr=$$GetjxbyArcDr^DHCINSUFacade(strArcimDr)
		s Form=$p(FormStr,"^",2)           ;剂型
		s Spec=##class(web.DHCINSUPortUse).GetInciGGByARCIMDr(strArcimDr)    ;规格方法不存在时放开下面方法
		//s Spec=$p(##class(web.DHCINSUPortUse).GetDrugInfoByTar(TarId,strArcimDr,""),"^",7)
		s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(strArcimDr)
		s ItemUom=""
		if DrugFlag="1" {
			//
			s PackUOMRowid=$p($g(^ARCIM(+strArcimDr,1,8)),"^",14)     ;整包装单位
			If PackUOMRowid'=""  s ItemUom=$p(^CT("UOM",PackUOMRowid),"^",2) ;药品门诊是整包装单位
		} 
		
		s DrugInfo=Spec_"^^^^"_Form_"^^^^"_ItemUom_"^" 
	}
	
	q DrugInfo
}

/// 功能说明：根据就诊ID取患者预交金金额
/// 入参说明: AdmDr      --> 就诊Id
/// 返 回 值: 本次就诊下的预交金总金额
/// 编写者：  guoyunlong
/// w ##class(BILL.EINV.BL.COM.Common).GetPreDepositAmtByAdmDr()
ClassMethod GetPreDepositAmtByAdmDr(AdmDr As %String) As %String
{
	s rtn="-1"
	s Amtsum=0
	q:AdmDr="" rtn
	q:'$d(^DHCSFPRINTDETAIL(0,"adm",AdmDr)) rtn
	s predepositID=""
	for predepositID=$o(^DHCSFPRINTDETAIL(0,"adm",AdmDr,predepositID)) q:predepositID=""  d
	 .s predepositInfo=$g(^DHCSFPRINTDETAIL(predepositID))
	 .q:$p(predepositInfo,"^",8)="2"              ;过滤预交金状态为2 的
	 .s PreDopsitAmt=$p(predepositInfo,"^",6)      ;预交金缴费金额
	 .s PreDopsitPayModeDr=$p(predepositInfo,"^",9)      ;预交金缴费支付方式
	 .s Amtsum=Amtsum+PreDopsitAmt
	s rtn="0"
	q rtn_"#"_Amtsum
}

/// 功能说明:	根据门诊发票ID门诊就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^院区^科室^票据金额^结算日期^结算时间)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：苏惠德 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetOPINVInfo(232064)
ClassMethod GetOPINVInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	
	//add by xubaobao 2020 08 03 start   判断结算状态是否正常状态，TP或者""的不上传。
	set InvFlag=$p($g(^DHCINVPRT(prtrowid)),"^",8)		;结算状态
	quit:(InvFlag="")||(InvFlag="TP") ""
	//add by xubaobao 2020 08 03 end
	
	s ACCINV=$p($g(^DHCINVPRT(prtrowid)),"^",4)
	q:ACCINV'="" ""   ;add by xubaobao 2021 01 15过滤集中打印发票的数据 
	set PRTInsTypeDR=$p($g(^DHCINVPRT(prtrowid)),"^",9)   ;费别
	set fairType=$p($g(^DHCINVPRT(prtrowid)),"^",34)
	set:(fairType="R") PayAdmType="REG"				;挂号类型
	set:(fairType="F") PayAdmType="OP"				;结算类型
	s:(fairType="H") PayAdmType="OP"                ;保存到门诊发票表中的结算数据 认为是门诊数据 不认为是体检数据	
	;注释；负发票需要传对应正记录发票ID
	;if $d(^DHCINVPRT(0,"InitInvDR",prtrowid))  	d   ;判断负记录数据
	set InitRowid=$p($g(^DHCINVPRT(prtrowid)),"^",13)
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set prtUser=$p($g(^DHCINVPRT(prtrowid)),"^",21)	;操作员ID
	set prtGroup=$p($g(^DHCINVPRT(prtrowid)),"^",41)	;安全组ID
	set prtHosp=$p($g(^DHCINVPRT(prtrowid)),"^",39)	;院区ID
	set PrtAmount=$p($g(^DHCINVPRT(prtrowid)),"^",1)   ;金额
	set PrtDate=$p($g(^DHCINVPRT(prtrowid)),"^",5)		;结算日期
	set PrtTime=$p($g(^DHCINVPRT(prtrowid)),"^",20)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=..GetINVAdmLocDr(prtrowid)		;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType_"&"_PRTInsTypeDR_"&"_InvFlag
	quit InvStr
}

/// 功能说明:	根据集中打印发票ID获取集中打印就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^科室^院区)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：苏惠德 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetAPIINVInfo()
ClassMethod GetAPIINVInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	;if $d(^DHCINVPRTAPi(0,"APIDR",prtrowid))  d    	;判断负记录数据
	set InitRowid=$p($g(^DHCINVPRTAP(prtrowid)),"^",10)
	set InvFlag=$p($g(^DHCINVPRTAP(prtrowid)),"^",2)
	set PayAdmType="API"							;集中打印发票
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set prtUser=$p($g(^DHCINVPRTAP(prtrowid)),"^",5)		;操作员ID
	set prtGroup=$p($g(^DHCINVPRTAP(prtrowid)),"^",32)	;安全组ID
	set prtHosp=$p($g(^DHCINVPRTAP(prtrowid)),"^",30)	;院区ID
	set PrtAmount=$p($g(^DHCINVPRTAP(prtrowid)),"^",1)   ;金额
	set PrtDate=$p($g(^DHCINVPRTAP(prtrowid)),"^",3)		;结算日期
	set PrtTime=$p($g(^DHCINVPRTAP(prtrowid)),"^",4)		;结算时间
	set APIInsTypeDR=$p($g(^DHCINVPRTAP(prtrowid)),"^",31)		;费别
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=..GetAPIAdmLocDr(prtrowid)			;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType_"&"_APIInsTypeDR_"&"_InvFlag
	quit InvStr
}

/// 功能说明:	根据体检发票ID获取体检就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^科室^院区)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：苏惠德 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetPEINVInfo()
ClassMethod GetPEINVInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	;if $d(^DHCPEINVPRT(0,"REF",prtrowid))  	d	;;判断负记录数据
	set InitRowid=$p($g(^DHCPEINVPRT(prtrowid)),"^",9)
	set InvFlag=$p($g(^DHCPEINVPRT(prtrowid)),"^",8)
	set PayAdmType="PE"							;体检发票
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set prtUser=$p($g(^DHCPEINVPRT(prtrowid)),"^",10)		;操作员ID
	set prtGroup=""	;安全组ID
	set prtHosp=$p($g(^DHCPEINVPRT(prtrowid)),"^",26)		;院区ID
	set PrtAmount=$p($g(^DHCPEINVPRT(prtrowid)),"^",7)   ;金额
	set PrtDate=$p($g(^DHCPEINVPRT(prtrowid)),"^",11)		;结算日期
	set PrtTime=$p($g(^DHCPEINVPRT(prtrowid)),"^",12)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=""			;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType_"^^"_InvFlag
	quit InvStr
}

/// 功能说明:	根据卡发票ID获取就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^科室^院区)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：xubaobao 2021 04 15
/// w ##class(BILL.EINV.BL.COM.Common).GetCFINVInfo()
ClassMethod GetCFINVInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	
	set InitRowid=$p($g(^DHCCARDINVPRT(prtrowid)),"^",8)
	set InvFlag=$p($g(^DHCCARDINVPRT(prtrowid)),"^",2)
	set PayAdmType="CF"							;卡发票
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set prtUser=$p($g(^DHCCARDINVPRT(prtrowid)),"^",6)		;操作员ID
	set prtGroup=""	;安全组ID
	set prtHosp=$p($g(^DHCCARDINVPRT(prtrowid)),"^",20)		;院区ID
	set PrtAmount=$p($g(^DHCCARDINVPRT(prtrowid)),"^",3)   ;金额
	set PrtDate=$p($g(^DHCCARDINVPRT(prtrowid)),"^",4)		;结算日期
	set PrtTime=$p($g(^DHCCARDINVPRT(prtrowid)),"^",5)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=""			;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType_"^^"_InvFlag
	quit InvStr
}

/// 功能说明:	根据住院押金ID获取押金就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^科室^院区)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：苏惠德 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetDEPDepInfo()
ClassMethod GetDEPDepInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	;if $d(^DHCSFPRINTDETAIL(0,"RefundRcpt",prtrowid))	d	;判断负记录数据据
	;add by xubaobao 2020 05 13
	;set InitRowid=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",43)
	s InitRowid=""
	s refundrcpt=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",7)  //被冲红的押金收据
	s:refundrcpt'="" InitRowid=$o(^DHCSFPRINTDETAIL(0,"RcptNo",refundrcpt,""),-1)
	set PayAdmType="DEP"										;住院押金
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set prtUser=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",14)		;操作员ID
	set prtGroup=""		;安全组ID
	set prtHosp=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",44)		;院区ID
	set PrtAmount=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",6)   ;金额
	set PrtDate=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",2)		;结算日期
	set PrtTime=$p($g(^DHCSFPRINTDETAIL(prtrowid)),"^",3)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=""				;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType
	quit InvStr
}

/// 功能说明:	根据住院发票ID获取住院发票就诊类型和扩展串信息
/// ExpStr      --> 扩展字符串(操作员ID^安全组^科室^院区)
/// PayAdmType	--> 票据业务类型 
/// InitRowid   -->原纪录ID
/// 修改履历：苏惠德 2019 09 18 新做成
/// w ##class(BILL.EINV.BL.COM.Common).GetIPINVInfo()
ClassMethod GetIPINVInfo(prtrowid As %String, UPFlag As %String = "") As %String
{
	set InvStr=""
	set PayAdmType=""     	;票据业务类型
	set InitRowid=""		;原纪录ID
	;if $d(^DHCINVPRTZY(0,"InitInv",prtrowid))  d	;;判断负记录数据
	set InitRowid=$p($g(^DHCINVPRTZY(prtrowid)),"^",13)
	set PayAdmType="IP"								;住院发票
	//根据发票号和就诊类型判断票据上传标志
	if (UPFlag'="Y"){			//add by xubaobao 2020 08 03  增加判断是否过滤已上传数据
		set uploadFlag=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetTradeUplodeFlag(PayAdmType,prtrowid)
		quit:(uploadFlag="Y") ""			;过滤已经上传成功
	}
	set PRTPatType=$p($g(^DHCINVPRTZY(prtrowid)),"^",9)		;费别
	set prtUser=$p($g(^DHCINVPRTZY(prtrowid)),"^",7)		;操作员ID
	set prtGroup=""				;安全组ID
	set prtHosp=$p($g(^DHCINVPRTZY(prtrowid)),"^",35)		;院区ID
	set PrtAmount=$p($g(^DHCINVPRTZY(prtrowid)),"^",6)   	;金额
	set PrtDate=$p($g(^DHCINVPRTZY(prtrowid)),"^",2)		;结算日期
	set PrtTime=$p($g(^DHCINVPRTZY(prtrowid)),"^",3)		;结算时间
	set:(PrtDate'="") PrtDate=$zd(PrtDate,3)
	set:(PrtTime'="") PrtTime=$zt(PrtTime,1)
	set prtLocDr=""				;科室ID
	set ExpStr=prtUser_"^"_prtGroup_"^"_prtHosp_"^"_prtLocDr_"^"_PrtAmount_"^"_PrtDate_"^"_PrtTime
	set InvStr=ExpStr_"&"_InitRowid_"&"_PayAdmType_"&"_PRTPatType
	quit InvStr
}

/// 功能说明:	根据门诊发票ID获取科室指针
ClassMethod GetINVAdmLocDr(prtrowid) As %String
{
	set LocDr=""
    set prtrowid=$g(prtrowid)
    set bci=""
    for  set bci=$o(^DHCBCI(0,"INV",prtrowid,bci))  quit:bci=""  do
    .set adm=$p($g(^DHCBCI(bci)),"^",3)
    .quit:(adm="")
    .set LocDr=$p($g(^PAADM(adm)),"^",4)
    quit LocDr
}

/// 功能说明:	根据集中打印发票ID获取科室指针
ClassMethod GetAPIAdmLocDr(prtrowid) As %String
{
	set LocDr=""
	set myAccPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR", prtrowid, ""))
	if myAccPRowID'="" {
		set SelectPrtDr=$p($g(^DHCINVPRTCAP(myAccPRowID)),"^",1)
		set LocDr=..GetINVAdmLocDr(SelectPrtDr)
	}
	quit LocDr
}

/// 根据病人ID与票据类型获取病人相关发票表ID
/// 格式：发票ID1^发票ID2^发票ID3...
ClassMethod GetPrtRowidByPapmi(Papmi As %String, PrtInvType As %String) As %String
{
	s PrtRowid="",PrtRowidStr=""
	if (PrtInvType="PI") {       //住院结算记录
		s admdr=""
		f  s admdr=$o(^PAPERdr(Papmi,"ADM","I",admdr,PrtRowid)) q:admdr=""  d
		.f  s PrtRowid=$o(^DHCINVPRTZY(0,"ADM",admdr,PrtRowid)) q:PrtRowid=""  d
		..s:PrtRowidStr'="" PrtRowidStr=PrtRowidStr_"^"_PrtRowid
		..s:PrtRowidStr="" PrtRowidStr=PrtRowid	
	}ElseIf(PrtInvType="PD"){	 //住院预交金结算
		//待补充
	}Else{    					 //门诊、挂号结算
		f  s PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid)) q:PrtRowid=""  d
		.s:PrtRowidStr'="" PrtRowidStr=PrtRowidStr_"^"_PrtRowid
		.s:PrtRowidStr="" PrtRowidStr=PrtRowid
	}
	q PrtRowidStr
}

/// 根据身份证号/卡号获取病人信息ID
ClassMethod GetPapmiByIDOrCardNo(PatID As %String, CardNo As %String) As %String
{
	s RtnFlg=""
	If (CardNo'=""){
		q:'$d(^DHCCARDi("CF",0,"CardNo",CardNo)) RtnFlg
		s rowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
		s Papmi=$p(^DHCCARD("CF",rowid),"^",4)
	}else{   
		s PatID=$$ALPHAUP^SSUTIL4(PatID)
		q:'$d(^PAPERi("DVA",PatID)) RtnFlg
		s Papmi=$o(^PAPERi("DVA",PatID,""),-1)
	}
	
	q Papmi
}

/// 根据票据类型获取一段时间内的发票信息对象
ClassMethod GetInvDetailInfo(ObjReq As BILL.EINV.DTO.ZZJ.EInvDetailInfoReq, ObjRes As BILL.EINV.DTO.ZZJ.EInvDetailInfoRes, RtnMsg As %String) As %String
{
	s RtnFlg="0"
	s StaDate=ObjReq.StaDate        ;发生业务的开始日期
	s EndDate=ObjReq.EndDate		;发生业务的结束日期
	s PatID=ObjReq.PatID
	s CardNo=ObjReq.CardNo
	s BillBatchCode=ObjReq.BillBatchCode
	s BillBatchNo=ObjReq.BillBatchNo
	s PrtInvType=ObjReq.PrtInvType
	s Type=ObjReq.Type
	
	;s:(StaDate="")||(EndDate="")||(PrtInvType="")||(Type="") RtnFlg="-1",RtnMsg="入参错误"
	;s:(PrtInvType="")||(Type="") RtnFlg="-1",RtnMsg="入参错误"		;add by xubaobao 2020 07 21
	s:(Type="") RtnFlg="-1",RtnMsg="入参错误"		;add by xubaobao 2020 09 29
	q:RtnFlg="-1" "-1"
	 
	s ObjRes.EInvList=##class(BILL.EINV.DTO.ZZJ.EInvListRow).%New()
	s ObjRes.EInvNum="0"
	s ObjRes.EInvAmt="0"
	 
    if (BillBatchCode'="")&&(BillBatchNo'=""){
	    s:'$d(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",BillBatchCode,BillBatchNo)) RtnFlg="-1",RtnMsg="根据票据代码与票据号码未查到票据信息."
		q:RtnFlg="-1" "-1"
	    s id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",BillBatchCode,BillBatchNo,""),-1)
    	s objEInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(id)
    	s:objEInv.EInvFlg="I" RtnFlg="-1",RtnMsg="入参错误"
    	q:RtnFlg="-1" "-1"
    	d ..ObjInvToObjPatInvDetail(objEInv, .ObjPatInvDetail)
    	d ObjRes.EInvList.row.Insert(ObjPatInvDetail)
    	s ObjRes.EInvNum=+1
		s ObjRes.EInvAmt=ObjRes.CreatAmt
    }elseif ((PatID'="")||(CardNo'="")) { 		//根据病人信息获取发票信息对象 add by xubaobao  2020 07 21
	    
	    //根据身份证号或卡号获取病人信息ID
   		s Papmi=..GetPapmiByIDOrCardNo(PatID,CardNo)
	    s:Papmi="" RtnFlg="-1",RtnMsg="根据身份证号或者卡号获取病人信息失败."
	    q:RtnFlg="-1" RtnFlg
	    s RtnStr=..GetInvDetailsInfoByPapmi(Papmi,PrtInvType, StaDate, EndDate)
	    s pid=$p(RtnStr,"^",1)
	    s num=$p(RtnStr,"^",2)
	    s:+num<1 RtnFlg="-1",RtnMsg="没有查询到票据信息."
	    q:RtnFlg="-1" RtnFlg
	    
	    //获取发票信息对象
	    f i=1:1:num d
		.s Info=$g(^TMP("BILLEINV","InvDetails",pid,i))
		.i $o(^TMP("BILLEINV","InvDetails",pid,""),-1)=i d		;add by xubaobao 2020 06 30
  	 	..k ^TMP("BILLEINV","InvDetails",pid)
		.s PrtRowid=$p(Info,"^",2)
		.s PayAdmType=$p(Info,"^",3)
		.s Flag=$p(Info,"^",4)   		 ;结算类型
		.;q:Flag'="N"          			 ;非正记录过滤
		.d ..GetInvDetailInfoByTypeAndId(PayAdmType,PrtRowid,Type, .ObjRes)
	 }else{
    	//查询一段时间内的发票信息
	    s RtnStr=..GetInvDetailsInfoByDate(StaDate,EndDate,PrtInvType)
	    s pid=$p(RtnStr,"^",1)
	    s num=$p(RtnStr,"^",2)
	    s:+num<1 RtnFlg="-1",RtnMsg="没有查询到票据信息."
	    q:RtnFlg="-1" RtnFlg
	    
		f i=1:1:num d
		.s Info=$g(^TMP("BILLEINV","InvDetails",pid,i))
		.i $o(^TMP("BILLEINV","InvDetails",pid,""),-1)=i d		;add by xubaobao 2020 06 30
  	 	..k ^TMP("BILLEINV","InvDetails",pid)
		.;s papmiTmp=$p(Info,"^",1)    ;病人ID			;add by xubaobao 2020 07 08
		.;q:papmiTmp'=Papmi
		.s PrtRowid=$p(Info,"^",2)
		.s PayAdmType=$p(Info,"^",3)
		.;s PrtTypeTmp=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType",$e(PrtInvType,1)_"_"_PayAdmType,5)		;add by xubaobao 2020 07 08
		.;q:(PrtTypeTmp'=PrtInvType)&&(PrtInvType'="")
		.s Flag=$p(Info,"^",4)   		 //结算类型
		.;q:Flag'="N"          			  ;非正记录过滤
		.d ..GetInvDetailInfoByTypeAndId(PayAdmType,PrtRowid,Type, .ObjRes)
	 }
    
     k ^TMP("BILLEINV","InvDetails",pid)
    /*else{
    
    	//根据身份证号/卡号获取病人信息ID
   		s Papmi=..GetPapmiByIDOrCardNo(PatID,CardNo)
	    s:Papmi="" RtnFlg="-1",RtnMsg="根据身份证号或者卡号获取病人信息失败."
	    q:RtnFlg="-1" "-1"
	    s RtnStr=..GetInvDetailsInfoByDate(StaDate,EndDate)
	    s pid=$p(RtnStr,"^",1)
	    s num=$p(RtnStr,"^",2)
	    s:+num<1 RtnFlg="-1",RtnMsg="没有查询到票据信息."
	    q:RtnFlg="-1" "-1"
	    
		f i=1:1:num d
		.s Info=$g(^TMP("BILLEINV","InvDetails",pid,i))
		.i $o(^TMP("BILLEINV","InvDetails",pid,""),-1)=i d		;add by xubaobao 2020 06 30
  	 	..k ^TMP("BILLEINV","InvDetails",pid)
		.s papmiTmp=$p(Info,"^",1)    ;病人ID
		.q:papmiTmp'=Papmi
		.s PrtRowid=$p(Info,"^",2)
		.s PayAdmType=$p(Info,"^",3)
		.s PrtTypeTmp=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType",$e(PrtInvType,1)_"_"_PayAdmType,5)
		.q:(PrtTypeTmp'=PrtInvType)&&(PrtInvType'="")
		.s Flag=$p(Info,"^",4)   		 //结算类型
		.q:Flag'="N"          			  ;非正记录过滤
		.d ..GetInvDetailInfoByTypeAndId(PayAdmType,PrtRowid,Type, .ObjRes)
		
    }*/
	
	s:ObjRes.EInvNum="0" RtnFlg="-1",RtnMsg="没有查询到票据信息." 
	
	q RtnFlg
}

/// 根据业务类型与发票ID获取门诊发票信息对象
ClassMethod GetInvDetailInfoByTypeAndId(PayAdmType As %String, PrtRowid As %String, Type As %String, ObjRes As BILL.EINV.DTO.ZZJ.EInvDetailInfoRes) As %String
{
	s rtnFlag="-1"
	q:(PayAdmType="")||(PrtRowid="")||(Type="") rtnFlag
	
	//根据票据业务类型与发票表rowid获取病人ID与就诊号
	s PatInfo=##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId(PayAdmType,PrtRowid)  ;方法名修改
	s Papmi=$p(PatInfo,"^",1)  ;病人Id
	s admDr=$p(PatInfo,"^",2)  ;就诊号
	s PaadmInfo=##class(BILL.EINV.BL.COM.Common).GetAdminfo(admDr)
	s PapmiInfo=##class(BILL.EINV.BL.COM.Common).GetPatinfo(Papmi)
    s DeptDesc=$p(PaadmInfo,"^",22)  /// 就诊科室			DeptDesc
    s AdmDate=$p(PaadmInfo,"^",1)  /// 就诊日期			AdmDate
    s Doctor=$p(PaadmInfo,"^",20)  /// 就诊医生			Doctor

	
	if '$d(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,PrtRowid))&&(Type["1"){
		s ObjPatInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
		if (PayAdmType="OP")||(PayAdmType="REG"){ 
			s InvPrtInfo=$g(^DHCINVPRT(PrtRowid))       ;门诊发票表->DHC_INVPRT
			q:InvPrtInfo="" "-1"
			q:$p(InvPrtInfo,"^",8)'="N" "-1"      ;滤过非正常结算记录
			s ObjPatInvDetail.HISPrtRowID=PrtRowid     //发票ID
			s ObjPatInvDetail.PayAdmType=PayAdmType
			s ObjPatInvDetail.CreatAmt=$p(InvPrtInfo,"^",1)  //开票金额
			s ObjPatInvDetail.PrtDate=$zd($p(InvPrtInfo,"^",5),3)   //业务发生日期
			s ObjPatInvDetail.PrtTime=$zt($p(InvPrtInfo,"^",20),1)	//业务发生时间
		}ElseIf(PayAdmType="IP"){
			s InvPrtInfo=$g(^DHCINVPRTZY(PrtRowid))       ;住院发票表->DHC_INVPRTZY
			q:InvPrtInfo="" "-1"
			q:$p(InvPrtInfo,"^",8)'="N" "-1"      ;滤过非正常结算记录
			s ObjPatInvDetail.HISPrtRowID=PrtRowid     //发票ID
			s ObjPatInvDetail.PayAdmType=PayAdmType
			s ObjPatInvDetail.CreatAmt=$p(InvPrtInfo,"^",6)   //开票金额
			s ObjPatInvDetail.PrtDate=$zd($p(InvPrtInfo,"^",2),3)     //业务发生日期
			s ObjPatInvDetail.PrtTime=$zt($p(InvPrtInfo,"^",3),1)	  //业务发生时间
		}
		s ObjPatInvDetail.AdmDate=$zd(AdmDate,3)
		s ObjPatInvDetail.DeptDesc=DeptDesc
		s ObjPatInvDetail.Doctor=Doctor
		
		d ObjRes.EInvList.row.Insert(ObjPatInvDetail)
		s ObjRes.EInvNum=+ObjRes.EInvNum+1
		s ObjRes.EInvAmt=+ObjRes.EInvAmt+(+ObjPatInvDetail.CreatAmt)
	}else{
		s id=""
		//取未开具成功的票据信息
		if (Type["1"){
			f  s id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,PrtRowid,id)) q:id=""  d
			.s ObjPatInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
			.s objEInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(id)
			.q:(objEInv.EInvFlg="I")					;||(objEInv.IUDPrintType'="E") 
			.d ..ObjInvToObjPatInvDetail(objEInv, .ObjPatInvDetail)
			.s ObjPatInvDetail.AdmDate=$zd(AdmDate,3)
		    .s ObjPatInvDetail.DeptDesc=DeptDesc
		    .s ObjPatInvDetail.Doctor=Doctor
			.d ObjRes.EInvList.row.Insert(ObjPatInvDetail)
			.s ObjRes.EInvNum=+ObjRes.EInvNum+1
			.s ObjRes.EInvAmt=+ObjRes.EInvAmt+(+ObjPatInvDetail.CreatAmt)
		}
	
		//取已成功开具的电子票据信息
		if (Type["2"){
			f  s id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,PrtRowid,id)) q:id=""  d
			.s ObjPatInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
			.s objEInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(id)
			.q:(objEInv.EInvFlg'="I")||(objEInv.IUDPrintType'="E")
			.d ..ObjInvToObjPatInvDetail(objEInv, .ObjPatInvDetail)
			.s ObjPatInvDetail.AdmDate=$zd(AdmDate,3)
		    .s ObjPatInvDetail.DeptDesc=DeptDesc
		    .s ObjPatInvDetail.Doctor=Doctor
			.d ObjRes.EInvList.row.Insert(ObjPatInvDetail)
			.s ObjRes.EInvNum=+ObjRes.EInvNum+1
			.s ObjRes.EInvAmt=+ObjRes.EInvAmt+(+ObjPatInvDetail.CreatAmt)
		}
	
		//取已经换开成功的纸质票据信息与原电子票据信息
		if (Type["3"){
			f  s id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",PayAdmType,PrtRowid,id)) q:id=""  d
			.s ObjPatInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
			.s objEInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(id)
			.q:("H|I"'[objEInv.EInvFlg)
			.d ..ObjInvToObjPatInvDetail(objEInv, .ObjPatInvDetail)
			.s ObjPatInvDetail.AdmDate=$zd(AdmDate,3)
		    .s ObjPatInvDetail.DeptDesc=DeptDesc
		    .s ObjPatInvDetail.Doctor=Doctor
			.d ObjRes.EInvList.row.Insert(ObjPatInvDetail)
			.s ObjRes.EInvNum=+ObjRes.EInvNum+1
			.s ObjRes.EInvAmt=+ObjRes.EInvAmt+(+ObjPatInvDetail.CreatAmt)
		}
	
	}

	q "0"
}

/// 将电子票据交易对象赋给病人发票明细信息对象
ClassMethod ObjInvToObjPatInvDetail(objEInv As BILL.EINV.PO.InvUpDetails, ObjPatInvDetail As BILL.EINV.DTO.ZZJ.EInvListData) As %String
{
	i $isObject(ObjPatInvDetail)=0  d
	.s ObjPatInvDetail=##class(BILL.EINV.DTO.ZZJ.EInvListData).%New()
	
	s ObjPatInvDetail.ID=objEInv.%Id() 					 ;票据ID
	s ObjPatInvDetail.BillBatchCode=objEInv.IUDBillBatchCode 	   ;电子票据代码
	s ObjPatInvDetail.BillBatchNo=objEInv.IUDBillBatchNo   	   ;电子发票号码
	s ObjPatInvDetail.PrtInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType",objEInv.IUDPrintType_"_"_objEInv.IUDPayAdmType,5)  ;票据类型
	s ObjPatInvDetail.CreatDate=$zd(objEInv.IUDCreatDate,3)_" "_$zt(objEInv.IUDCreatTime,1)   	;电子票据开具时间
	s ObjPatInvDetail.Status=objEInv.IUDBillBatchStatus 	   ;票据状态
	s ObjPatInvDetail.CheckCode=objEInv.IUDCheckCode   	   ;电子校验码
	s ObjPatInvDetail.BillQRCode=objEInv.IUDBillQRCode 	   ;电子票据二维码图片数据
	s ObjPatInvDetail.Date=$zd(objEInv.IUDDate,3)   	   ;上传日期
	s ObjPatInvDetail.Time=$zt(objEInv.IUDTime,1)    	   ;上传时间
	s ObjPatInvDetail.UserID=objEInv.IUDUser   	   ;结算操作员
	s ObjPatInvDetail.BusNo=objEInv.IUDBusNo 	   ;业务流水号
	s ObjPatInvDetail.EInvFlg=objEInv.EInvFlg	//业务发生时间
	
	s ObjPatInvDetail.HISPrtRowID=objEInv.IUDInvDr     //发票ID
	s ObjPatInvDetail.PayAdmType=objEInv.IUDPayAdmType
	s ObjPatInvDetail.CreatAmt=objEInv.IUDCreatAmt	  //开票金额
	s ObjPatInvDetail.PrtDate=$zd(objEInv.IUDPrtDate,3)    //业务发生日期
	s ObjPatInvDetail.PrtTime=$zt(objEInv.IUDPrtTime,1)	//业务发生时间
	
	s ObjPatInvDetail.PictureUrl=objEInv.Xstr2
	
	q "0"
}

/// 功能说明获取一段时间内的票据相关信息
/// 入参：StaDate	开始日期
/// 	  EndDate	结束日期
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.Common).GetInvDetailsInfo("2019-01-30","2019-01-31")
ClassMethod GetInvDetailsInfoByDateOld(StaDate, EndDate) As %String
{
	s:EndDate="" EndDate=+$h
	s:StaDate="" StaDate=+$h-1
	
	set StaDate=##class(websys.Conversions).DateHtmlToLogical(StaDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	s InvPID=$i(^TMP("BILLEINV","InvDetails"))
	k ^TMP("BILLEINV","InvDetails",InvPID)
	
	s num="0"
	f date=StaDate:1:EndDate {
	
		// 获取门诊、挂号票据信息
		s PrtRowid=""
		f  s PrtRowid=$o(^DHCINVPRT(0,"Date",date,PrtRowid)) q:PrtRowid=""  d
		.s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
		.q:PrtInvInfo=""
		.s Flag=$p(PrtInvInfo,"^",8)			;结算状态
		.s fairType=$p(PrtInvInfo,"^",34)
		.s:(fairType="R") PayAdmType="REG"				;业务类型
		.s:(fairType="F") PayAdmType="OP"				;
		.s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)
		.q:PapmiStr=""
		.s Papmi=$p(PapmiStr,"^",1)      //病人ID
		.s num=num+1
		.s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取住院票据信息
		s PrtRowid=""
		f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATE",date,PrtRowid)) q:PrtRowid=""  d
		.s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
		.q:PrtInvInfo=""
		.s Flag=$p(PrtInvInfo,"^",8)			;结算状态
		.s Papmi=$p(PrtInvInfo,"^",15)
		.s PayAdmType="IP"				;业务类型
		.s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)
		.q:PapmiStr=""
		.s Papmi=$p(PapmiStr,"^",1)      //病人ID
		.s num=num+1
		.s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取住院预交金票据信息
		s PrtRowid=""
		f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,PrtRowid)) quit:(PrtRowid="")   do
		.s PrtInvInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
		.q:PrtInvInfo=""
		.s Flag="N"			;结算状态
		.s:+$p(PrtInvInfo,"^",6)<0 Flag="S"	
		.s PayAdmType="DEP"				;业务类型
		.s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)
		.q:PapmiStr=""
		.s Papmi=$p(PapmiStr,"^",1)      //病人ID
		.s num=num+1
		.s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取体检票据信息
		s PrtRowid=""
		f  s PrtRowid=$o(^DHCPEINVPRT(0,"DATE",date,PrtRowid)) quit:(PrtRowid="")   do
		.s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
		.q:PrtInvInfo=""
		.s Flag=$p(PrtInvInfo,"^",8)	;结算状态
		.s PayAdmType="PE"				;业务类型
		.s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)
		.q:PapmiStr=""
		.s Papmi=$p(PapmiStr,"^",1)      //病人ID
		.s num=num+1
		.s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
	}
	
	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// add by xubaobao 2020 07 21
/// 功能说明获取一段时间内的票据相关信息(3天内的数据)
/// 入参：StaDate	开始日期
/// 	  EndDate	结束日期
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.Common).GetInvDetailsInfo("2019-01-30","2019-01-31")
ClassMethod GetInvDetailsInfoByDate(StaDate, EndDate) As %String
{
	s:EndDate="" EndDate=+$h
	s:StaDate="" StaDate=+$h-3
	
	s StaDate=##class(websys.Conversions).DateHtmlToLogical(StaDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:EndDate-StaDate>3 StaDate=EndDate-3			;获取3天内的数据
	
	s InvPID=$i(^TMP("BILLEINV","InvDetails"))
	
	s num="0"
	s Papmi=""  		;add by xubaobao 2020 07 08
	
	f date=StaDate:1:EndDate {
		// 获取门诊、挂号票据信息
		i (PrtInvType="PO")||(PrtInvType="PR")||(PrtInvType="EO")||(PrtInvType="ER")||(PrtInvType="") d
		.s PrtRowid="",PayAdmType=""
		.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",date,PrtRowid)) q:PrtRowid=""  d
		..s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
		..q:PrtInvInfo=""
		..s Flag=$p(PrtInvInfo,"^",8)			;结算状态
		..s fairType=$p(PrtInvInfo,"^",34)
		..s:(fairType="R") PayAdmType="REG"				;业务类型
		..s:(fairType="F") PayAdmType="OP"				;
		..;s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)	;add by xubaobao 2020 07 08
		..;q:PapmiStr=""
		..;s Papmi=$p(PapmiStr,"^",1)      //病人ID
		..s num=num+1
		..s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取住院票据信息
		i (PrtInvType="PI")||(PrtInvType="EI")||(PrtInvType="") d
		.s PrtRowid="",PayAdmType=""
		.f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATE",date,PrtRowid)) q:PrtRowid=""  d
		..s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
		..q:PrtInvInfo=""
		..s Flag=$p(PrtInvInfo,"^",8)			;结算状态
		..s PayAdmType="IP"				;业务类型
		.;s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)	;add by xubaobao 2020 07 08
		.;q:PapmiStr=""
		.;s Papmi=$p(PapmiStr,"^",1)      //病人ID
		..s num=num+1
		..s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取住院预交金票据信息
		i (PrtInvType="PD")||(PrtInvType="ED")||(PrtInvType="") d
		.s PrtRowid="",PayAdmType=""
		.f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,PrtRowid)) quit:(PrtRowid="")   do
		..s PrtInvInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
		..q:PrtInvInfo=""
		..s Flag="N"			;结算状态
		..s:+$p(PrtInvInfo,"^",6)<0 Flag="S"	
		..s PayAdmType="DEP"				;业务类型
		..;s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)	;add by xubaobao 2020 07 08
		..;q:PapmiStr=""
		..;s Papmi=$p(PapmiStr,"^",1)      //病人ID
		..s num=num+1
		..s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
		
		// 获取体检票据信息
		i (PrtInvType="PH")||(PrtInvType="EH")||(PrtInvType="") d
		.s PrtRowid="",PayAdmType=""
		.f  s PrtRowid=$o(^DHCPEINVPRT(0,"DATE",date,PrtRowid)) quit:(PrtRowid="")   do
		..s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
		..q:PrtInvInfo=""
		..s Flag=$p(PrtInvInfo,"^",8)	;结算状态
		..s PayAdmType="PE"				;业务类型
		..;s PapmiStr=..GetPatIdAndAdmId(PayAdmType,PrtRowid)	;add by xubaobao 2020 07 08
		..;q:PapmiStr=""
		..;s Papmi=$p(PapmiStr,"^",1)      //病人ID
		..s num=num+1
		..s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
	}
	
	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// 功能说明：根据业务类型和发票ID获取打印二维码图片所需信息
/// w ##class(BILL.EINV.BL.COM.Common).GetQRCodeByPrtRowid("REG","6839158")
ClassMethod GetQRCodeByPrtRowid(PayAdmType As %String, PrtRowid As %String) As %String
{
	set QRCodeStr=""
	//s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg", PayAdmType, OrgHISPrtRowID, "P", "I", ""), -1)
	set rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", PayAdmType, PrtRowid, ""), -1)
	quit:(rowid="") QRCodeStr 
	set uplodeFlag=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),8)
	quit:(uplodeFlag'="Y")
	set printType=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),30)
	quit:(printType="P") QRCodeStr			//过滤掉纸质发票
	set checkCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),21)
	set creatDate=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),15)
	set creatDate=$zd(creatDate,8)
	set creatAmt=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),17) 
	set billBatchCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),12) 
	set billBatchNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(rowid),13)
	set Prefix="CZ-EI-44,1.0.0"
	set QRCodeStr=Prefix_","_billBatchCode_","_billBatchNo_","_checkCode_","_creatDate_","_$fn(creatAmt,"",2)
	quit QRCodeStr
}

/// 功能说明：获取票据的代码和号码
/// w ##class(BILL.EINV.BL.COM.Common).GetEInvCodeAndNo("OP", "3786133")
ClassMethod GetEInvCodeAndNo(PayAdmType As %String, PrtRowid As %String, PrintType As %String = "") As %String
{
	s RtnInfo=""
	
	s IUDPrintTypeTmp=""
	f  s IUDPrintTypeTmp=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, PrtRowid, PrintType), -1) q:((IUDPrintTypeTmp="")||(RtnInfo'=""))  d
	.q:((PrintType'="")&&(PrintType'=IUDPrintTypeTmp))
	.s rowid=""
	.f  s rowid=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, PrtRowid, PrintType, rowid), -1) q:((rowid="")||(RtnInfo'=""))  d
	..s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(rowid)
	..s InvCode=objUpDetail.IUDBillBatchCode  ;票据代码
	..s InvNo=objUpDetail.IUDBillBatchNo      ;票据号码
	..q:(InvCode="")||(InvNo="")
	..s RtnInfo=InvCode_" "_InvNo
	
	q RtnInfo
}

/// w ##class(BILL.EINV.BL.COM.Common).GetIUDBillQRCodeByIUDInitDr("REG","6839158")
ClassMethod GetIUDBillQRCodeByIUDInitDr(PayAdmType As %String, IUDInitDr As %String) As %String
{
	q:(IUDInitDr="") "发票ID为空请检查！"
	s IUDID=""
	s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxEInvFlg",PayAdmType,IUDInitDr,"E","I",IUDID))  
	q:IUDID="" "交易表不存在记录"
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	s uplodeFlag=objUpDetail.IUDUplodeFlag				//上传标志
	q:(uplodeFlag'="Y") "不存在已上传记录"
	;s IUDBillQRCode=objUpDetail.IUDBillQRCode
	s Prefix="CZ-EI-44,1.0.0"
	S IUDBillBatchCode=objUpDetail.IUDBillBatchCode		//票据代码
	s IUDBillBatchNo=objUpDetail.IUDBillBatchNo			//票据号码
	S IUDCheckCode=objUpDetail.IUDCheckCode				//校验码
	S IUDCreatDate=$zd(objUpDetail.IUDCreatDate,8)		//日期
	s IUDCreatAmt=objUpDetail.IUDCreatAmt				//交易金额
	i ($number(IUDCreatAmt)'="") do
	.s IUDCreatAmt=$fn(IUDCreatAmt,"",2)
	s IUDBillQRCode=Prefix_","_IUDBillBatchCode_","_IUDBillBatchNo_","_IUDCheckCode_","_IUDCreatDate_","_IUDCreatAmt
	;;w ##class(ext.util.String).Base642Img(IUDBillQRCode,"d:IUDBillQRCode.jpg")
	q IUDBillQRCode
}

/// 通过发票ID，就诊类型获取发票号 
/// 入参：PrtRowID->发票ID
///       AdmType->就诊类型
///       Flag-> 模式    ""->普通模式      1->电子票据模式
/// 出参：成功 InvNo->发票号   失败 InvNo->-1
ClassMethod GetInvNoByPrtId(PrtRowID As %String, AdmType As %String, Flag As %String = "") As %String
{
	s rtn="-1"
	q:(PrtRowID="")||(AdmType="") rtn
	;门诊发票号
	if ((AdmType="OP") && (Flag="")) d 
	.s PrtRowInfo=$g(^DHCINVPRT(PrtRowID))
	.s InvNo=$p(PrtRowInfo,"^",14)   ;发票号
	;住院发票号
	if ((AdmType="IP") && (Flag="")) d
	.s PrtRowInfo=$g(^DHCINVPRTZY(PrtRowID))
	.s InvNo=$p(PrtRowInfo,"^",1)   ;发票号
	;走电子发票模式
	if Flag="1" d
	.s InvUpDetailID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",AdmType,PrtRowID,""))
	.s ObjInvUpDetail=##class(BILL.EINV.PO.InvUpDetails).%Open(InvUpDetailID)
	.s InvNo=ObjInvUpDetail.IUDBatchNo
	s rtn=InvNo
	q rtn
}

/// 获取HIS当前纸质票据可用号码(DHC_INVOICE)
/// 入参说明：InputData -->  操作员^票据类型^安全组^费别^院区…… 
///           OutMsg      -->  错误信息
/// 返 回 值：票据号码
/// w ##class(BILL.EINV.BL.COM.Common).GetPaperBillNo("6179^PO")
ClassMethod GetPaperBillNo(InputData As %String) As %String
{
	s rtnFlag="-1^^"
	s UserID=$p(InputData,"^",1)			;操作员ID
	s PrtInvType=$p(InputData,"^",2)		;票据类型
	s GroupDr=$p(InputData,"^",3)			;安全组
	s AdmreasonDr=$p(InputData,"^",4)		;费别
	s HospitalDr=$p(InputData,"^",5)		;院区	
	q:(UserID="")||(PrtInvType="") "-1^入参错误,请检查^"	
	s (rowid,DHCinvoiceId,LastNum,EndInv)=""
	f  s rowid=$o(^DHCINVOICE(0,"USER",UserID,rowid)) q:rowid=""  d
	.;s StartInv=$p(^DHCINVOICE(rowid),"^",1)     //起始号段
	.s Finalflag=$p(^DHCINVOICE(rowid),"^",7)    //启用标识
	.s Type=$p(^DHCINVOICE(rowid),"^",8) 		 //票据类型
	.s hosDr=$p(^DHCINVOICE(rowid),"^",19)       //院区指针
	.q:Finalflag'="Y"             //过滤未启用号段
	.q:Type'=PrtInvType
	.q:(hosDr'=HospitalDr)&&(HospitalDr'="")
	.s EndInv=$p(^DHCINVOICE(rowid),"^",2)     //终止号段
	.s LastNum=$p(^DHCINVOICE(rowid),"^",6)      //可用号码
	.s PbatchBillNO=$p(^DHCINVOICE(rowid),"^",17)      //票据代码
	.s DHCinvoiceId=rowid
	q:LastNum="" "-1^该操作员无可用票号^"
	s rtnFlag=LastNum_"^"_DHCinvoiceId_"^"_EndInv_"^"_PbatchBillNO
	q rtnFlag
}

/// 功能说明：判断当前业务是否需要走号，需要走号的情况下获取当前号码
/// 入参说明：InvociePam      --> 入参对象
///           ObjInvPrtInfo   --> 票据信息对象
/// 返 回 值：0 成功 -1 失败
/// 修改履历：董科锋 2020 01 03 新做成
/// w ##class(BILL.EINV.BL.COM.Common).SetInvCodeAndNo
ClassMethod SetInvCodeAndNo(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="0"
	
	i InvociePam.UserID="" d             ;入参操作员为空的时候 使用发票表中的操作员
	.s UserID=ObjInvPrtInfo.BusUserId     
	.q:UserID=""
	.s InvociePam.UserID=UserID
	.s userInfo=$g(^SSU("SSUSR",UserID))
	.s InvociePam.UserCode=$p(userInfo, "^", 1)  ;操作员编码
	.s InvociePam.UserDesc=$p(userInfo, "^", 2)  ;操作员名称
	
	s:InvociePam.GroupID="" InvociePam.GroupID=ObjInvPrtInfo.GroupDr               ;安全组
	s:InvociePam.AdmreasonDr="" InvociePam.AdmreasonDr=ObjInvPrtInfo.InsTypeDr     ;费别
	s:InvociePam.HospitalID="" InvociePam.HospitalID=ObjInvPrtInfo.PrtHospDr       ;院区
	
	//当前业务是否需要走号
	s JumpNoType=""   ;走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
	s JumpEnvNoFlg=..GetJumpEnvNoFlg(InvociePam, .JumpNoType)  ;当前业务是否需要走号 1 走号 0 不走号
	s InvociePam.JumpEnvNoFlg=JumpEnvNoFlg
	s InvociePam.JumpNoType=JumpNoType
	b ;SetInvCodeAndNo 1
	q:InvociePam.JumpEnvNoFlg'="1" RtnFlg         ;不需要走号直接退出
	b ;SetInvCodeAndNo 2
	
	//设置票据代码 票据号码
	s BillBatchCode= InvociePam.pBillBatchCode  ;票据代码
	s BillNo=InvociePam.pBillNo                 ;票据号码	
	if ((BillBatchCode="")&&(BillNo="")){       ;页面传入的话，就不需要再次获取当前票据代码和号码
		s PayAdmType=InvociePam.PayAdmType  ;业务类型	
		s PrtInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("EInvTypeAndAdmTypeCon",PayAdmType,5)   ;获取对照的票据种类
		
		s InputData=InvociePam.UserID_"^"_PrtInvType_"^"_InvociePam.GroupID_"^"_InvociePam.AdmreasonDr_"^"_InvociePam.HospitalID
		//返回值格式 当前号码^发放表id^结束号码^票据代码
		s OutStr=##class(BILL.EINV.BL.COM.Common).GetPaperBillNo(InputData)
	
		s BillBatchCode=$p(OutStr,"^",4)  	;票据代码
		s BillNo=$p(OutStr,"^",1)		    ;票据号码
	}
	
	if ((BillBatchCode="")&&(BillNo="")) {  //验证票据代码 票据号码是否已经取到
		s InvociePam.ErrMsgInfo="票据代码、票据号码不能为空!"
		s RtnFlg="-1"
	}
	q:RtnFlg="-1" RtnFlg
	
	s InvociePam.pBillBatchCode=BillBatchCode  	;票据代码
	s InvociePam.pBillNo=BillNo		            ;票据号码
	b ;SetInvCodeAndNo 3
	q RtnFlg
}

/// 功能说明：开票成功后走号
/// 入参说明：InvociePam --> 入参对象
/// 返 回 值：0 走号成功 -1 走号失败
/// 修改履历：董科锋 2020 01 03 新做成
/// w ##class(BILL.EINV.BL.COM.Common).JumpEnvCodeAndNo
ClassMethod JumpEnvCodeAndNo(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"
	s JumpEnvNoFlg=InvociePam.JumpEnvNoFlg   ;走号标志 1 走号 0 不走号
	q:JumpEnvNoFlg'="1" RtnFlg   ;不需要走号直接退出
	s JumpNoType=InvociePam.JumpNoType       ;走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
	q:JumpNoType'="1" RtnFlg     ;调用第三方服务前就走号的情况下，这里不再走号
	
	s RtnFlg=..JumpEnvCodeAndNoDo(InvociePam)  ;走号
	
	q RtnFlg
}

/// 功能说明：走号方法
/// 入参说明：InvociePam --> 入参对象
/// 返 回 值：0 走号成功 -1 走号失败
/// 修改履历：董科锋 2020 01 06 新做成
/// w ##class(BILL.EINV.BL.COM.Common).JumpEnvCodeAndNoDo
ClassMethod JumpEnvCodeAndNoDo(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="0"
	s PayAdmType=InvociePam.PayAdmType       ;业务类型
	s IUDPrintType=InvociePam.IUDPrintType   ;票据模式 E-电子票据 P-纸质发票
	s DicCode=IUDPrintType_"_"_PayAdmType
	s PrtInvType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType",DicCode,5)   ;根据业务类型获取 对照的票据类型
	//收费员ID^当前电子票据号^票据类型
	s InputData=InvociePam.UserID_"^"_InvociePam.pBillNo_"^"_PrtInvType
	s rtnTmp=##class(BILL.EINV.BL.EInvoiceLogic).UpdateINVoice(InputData)	;走号
	s:(rtnTmp<0) RtnFlg="-1"
	
	q RtnFlg
}

/// 功能说明：判断当前业务是否需要走号
/// 入参说明：InvociePam --> 开票的入参对象
///           JumpNoType --> 走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
/// 返 回 值：1 走号 0 不走号
/// s InvociePam= ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
/// s InvociePam.PathCode="PrintPaper1"
/// w ##class(BILL.EINV.BL.COM.Common).GetJumpEnvNoFlg(InvociePam)
ClassMethod GetJumpEnvNoFlg(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef JumpNoType As %String) As %String
{
	s JumpNoFlg=""
	
	s PathCode=InvociePam.PathCode   ;业务类型
	s HospitalNo=""
	
	s DicInfo=""
	s DicTypeBase="JUMPEINVNO_PathCodes"
	s DictypeOfHospital=""
	s:HospitalNo'="" DictypeOfHospital=DicTypeBase_"_"_HospitalNo
	if (DictypeOfHospital'=""){
		s DicInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd(DictypeOfHospital, PathCode, 0)  ;当前业务是否走号
		if (DicInfo'=""){
			s JumpNoFlg=$p(DicInfo, "^", 5)    ;走号标记 1 走号 0 不走号
			s JumpNoType=$p(DicInfo, "^", 7)   ;走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
		} 
	}
	
	if (DicInfo="") { //特定院区没有配置的时候从通用配置中获取
		s DicInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd(DicTypeBase, PathCode, 0)  ;当前业务是否走号
		if (DicInfo'=""){
			s JumpNoFlg=$p(DicInfo, "^", 5)    ;走号标记 1 走号 0 不走号
			s JumpNoType=$p(DicInfo, "^", 7)   ;走号类型 1 第三方服务成功后走号 0 第三方服务成功前就走号
		} 
	}
	s:JumpNoFlg="" JumpNoFlg="0"     ;默认不走号
	s:JumpNoType="" JumpNoType="1"   ;默认第三方服务成功后走号
	
	q JumpNoFlg
}

/// 功能说明：通过业务类型，发票ID获取配置参数
/// 入参说明：AdmType --> 业务类型
///           PrtRowid --> 发票ID
/// 返 回 值：配置参数
///            费别^就诊类型^院区^安全组^用户Code^科室^支付方式 
/// w ##class(BILL.EINV.BL.COM.Common).GetConfigInfoById("OP","232694")
ClassMethod GetConfigInfoById(AdmType As %String, PrtRowid As %String) As %String
{
	s Rtn="-1"
	q:(AdmType="")||(PrtRowid="") Rtn
	i (AdmType="OP")||(AdmType="REG") do
	.s InvPrtInfo=$g(^DHCINVPRT(PrtRowid))
	.s AdmReasonInfo=$p(InvPrtInfo,"^",9)       ;费别
	.s PatInfo=##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId(AdmType,PrtRowid)  ;方法名修改
	.s AdmDr=$p(PatInfo,"^",2)  ;就诊号
	.s AdmTypeInfo=$p($g(^PAADM(AdmDr)),"^",2)    ;挂号、门诊都是O 就诊类型 paadm_type
	.s HospitalInfo=$p(InvPrtInfo,"^",39)         ;院区
	.s UserGrpInfo=$p(InvPrtInfo,"^",41)          ;用户登录安全组
    .s UserInfo=$p($g(^SSU("SSUSR",$p(InvPrtInfo,"^",21))),"^",1)            ;用户Code
    .s PaadmInfo=##class(BILL.EINV.BL.COM.Common).GetAdminfo(AdmDr)
    .s DepartMent=$p(PaadmInfo,"^",3)            ;科室   ？？？取就诊科室还是
    .s PaymodeInfo=""                           ;支付方式
	else  if (AdmType="IP")  do
	.s InvPrtzyInfo=$g(^DHCINVPRTZY(PrtRowid))
	.s AdmReasonInfo=$p(InvPrtzyInfo,"^",9)       ;费别
	.s AdmDr=$p(InvPrtzyInfo,"^",4)  ;就诊号
	.s AdmTypeInfo=$p($g(^PAADM(AdmDr)),"^",2)     ;挂号、门诊都是O 就诊类型 paadm_type
	.s HospitalInfo=$p($g(^PAADM(AdmDr,2)),"^",85)        ;院区
	.s UserGrpInfo=""                      ;用户登录安全组    建议这个从界面session获取
    .s UserInfo=$p($g(^SSU("SSUSR",$p(InvPrtzyInfo,"^",7) )),"^",1)            ;用户Code
    .s PaadmInfo=##class(BILL.EINV.BL.COM.Common).GetAdminfo(AdmDr)
    .s DepartMent=$p(PaadmInfo,"^",3)            ;科室   ？？？取就诊科室还是
    .s PaymodeInfo=""
    else  if (AdmType="API") do
    .s InvPrtzyApiInfo=$g(^DHCINVPRTAP(PrtRowid))   ;集中打印发票信息
    .s PatInfo=##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId(AdmType,PrtRowid)  ;方法名修改
	.s AdmDr=$p(PatInfo,"^",2)                  ;就诊号 ;集中打印发票默认取最后一次就诊
	.s AdmReasonInfo=$p(InvPrtzyApiInfo,"^",31)       ;费别
	.s AdmTypeInfo=$p($g(^PAADM(AdmDr)),"^",2)     ;挂号、门诊都是O 就诊类型 paadm_type
	.s HospitalInfo=$p(InvPrtzyApiInfo,"^",30)        ;院区
	.s UserGrpInfo=$p(InvPrtzyApiInfo,"^",32)       ;用户登录安全组    建议这个从界面session获取
    .s UserInfo=$p($g(^SSU("SSUSR",$p(InvPrtzyApiInfo,"^",5))),"^",1)            ;用户Code
    .s PaadmInfo=##class(BILL.EINV.BL.COM.Common).GetAdminfo(AdmDr)
    .s DepartMent=$p(PaadmInfo,"^",3)               ;科室   ？？？取就诊科室还是
    .s PaymodeInfo=""
    
    s Rtn=AdmReasonInfo_"^"_AdmTypeInfo_"^"_HospitalInfo_"^"_UserGrpInfo_"^"_UserInfo_"^"_DepartMent_"^"_PaymodeInfo
    q Rtn
}

/// 功能说明：通过业务类型，发票ID获取配置对象
/// 入参说明：AdmType --> 业务类型
///           PrtRowid --> 发票ID
///           ConfigObj -->配置参数对象
/// 返 回 值：配置参数  XML字符串
///            
/// w ##class(BILL.EINV.BL.COM.Common).GetConfigObjById("OP","232694","")
ClassMethod GetConfigObjById(AdmType As %String, PrtRowid As %String, ConfigObj As BILL.EINV.DTO.COM.InvConfigCom) As %String
{
	s InputPamStream=""
	s Rtn=##class(BILL.EINV.BL.COM.Common).GetConfigInfoById(AdmType,PrtRowid)
	q:Rtn="-1"
	i $Isobject(ConfigObj)=0 d
	.s ConfigObj=##class(BILL.EINV.DTO.COM.InvConfigCom).%New()
	s ConfigObj.AdmReasonInfo=$p(Rtn,"^",1)
	s ConfigObj.AdmTypeInfo=$p(Rtn,"^",2)
	s ConfigObj.HospitalInfo=$p(Rtn,"^",3)
	s ConfigObj.UserGrpInfo=$p(Rtn,"^",4)
	s ConfigObj.UserInfo=$p(Rtn,"^",5)
	s ConfigObj.DepartMent=$p(Rtn,"^",6)
	s ConfigObj.PaymodeInfo=$p(Rtn,"^",7)
	d ConfigObj.XMLExportToString(.InputPamStream)     ;生成xml字符串
	q InputPamStream
}

/// 功能说明：通过发票ID获取结算后补退金额
/// 入参说明：PrtRowid --> 发票ID
/// 返 回 值：补收金额^退款金额
///            
/// w ##class(BILL.EINV.BL.COM.Common).GetPayFeeInfo(6176)
ClassMethod GetPayFeeInfo(PrtRowid As %String) As %String
{
	
	set Rtn="-1"
	quit:(PrtRowid="") Rtn
	set RecAmount=0,RefAmount=0
	set ARRcpDr=$p(^DHCINVPRTZY(PrtRowid),"^",17)
	quit:ARRcpDr=""
	set ARPMSub="0"
	for  set ARPMSub=$o(^ARRCP(ARRcpDr,"PAYM",ARPMSub)) quit:ARPMSub=""  do
	.quit:'$d(^ARRCP(ARRcpDr,"PAYM",ARPMSub))
	.set PaymodeDr=$p(^ARRCP(ARRcpDr,"PAYM",ARPMSub),"^",1)
	.quit:(+PaymodeDr=0)
	.set PaymodeAmt=$p(^ARRCP(ARRcpDr,"PAYM",ARPMSub),"^",3)
	.if (+PaymodeAmt>0) do
	..set RecAmount=RecAmount+PaymodeAmt			//应收金额
	.else  if (+PaymodeAmt<0) do
	..set RefAmount=RefAmount+PaymodeAmt			//应退金额
	.else  do
	..//
	set Rtn=$fn(RecAmount,"",2)_"^"_$fn(RefAmount,"",2)
	quit Rtn
}

/// 功能说明根据病人ID获取发票信息
/// add by xubaobao 2020 07 21
/// 入参：Papmi		病人ID
/// 	  PrtInvType  票据类型(PI：住院票据,PO：门诊票据,PR：挂号票据,PD：押金票据,PH:体检票据)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.Common).GetInvDetailsInfoByPapmi("1")
ClassMethod GetInvDetailsInfoByPapmi(Papmi, PrtInvType, StaDate, EndDate) As %String
{
	
	s InvPID=$i(^TMP("BILLEINV","InvDetails"))
	s num="0"
	
	s:StaDate'="" StaDate=##class(websys.Conversions).DateHtmlToLogical(StaDate)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	// 获取门诊、挂号票据信息
	i (PrtInvType="PO")||(PrtInvType="PR")||(PrtInvType="EO")||(PrtInvType="ER")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid)) q:PrtRowid=""  d
	..s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
	..q:PrtInvInfo=""
	..s PrtDate=$p(PrtInvInfo,"^",5)			;结算日期
	..q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))
	..s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	..s fairType=$p(PrtInvInfo,"^",34)
	..s:(fairType="R") PayAdmType="REG"				;业务类型
	..s:(fairType="F") PayAdmType="OP"				;
	..s num=num+1
	..s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
	// 获取住院票据信息
	i (PrtInvType="PI")||(PrtInvType="EI")||(PrtInvType="") d
	.s AdmDr="",PayAdmType=""
	.f  s AdmDr=$o(^PAPERdr(Papmi,"ADM","I",AdmDr)) q:AdmDr=""  d
	..s PrtRowid=""
	..f  s PrtRowid=$o(^DHCINVPRTZY(0,"ADM",AdmDr,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
	...q:PrtInvInfo=""
	...s PrtDate=$p(PrtInvInfo,"^",2)			;结算日期
	...q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s PayAdmType="IP"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取体检票据信息
	i (PrtInvType="PH")||(PrtInvType="EH")||(PrtInvType="") d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAPERdr(Papmi,"ADM","H",AdmDr)) q:AdmDr=""  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCPEINVPRT(0,"ADM",AdmDr,PrtRowid)) q:(PrtRowid="")   d
	...s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)		;结算状态
	...s PrtDate=$p(PrtInvInfo,"^",11)		;结算日期
	...q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))	
	...s PayAdmType="PE"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINV","InvDetails",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag

	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// yandong
/// 2020-6-23
/// 获取体检支付方式信息
/// 修改履历：徐保保 2020 08 07 新加
/// w ##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr("2246","")
ClassMethod GetPEPayModeStrByInvDr(InvDr, UserId) As %String
{
	s PayModeStr=""
	s ARRCPID=$P(^DHCPEINVPRT(InvDr),"^",4)
	s PAADM=$P(^DHCPEINVPRT(InvDr),"^",2)
	s PapmiID=$P(^PAADM(PAADM),"^",1)
	q:ARRCPID="" PayModeStr
	s PAYMSub=0
	f  s PAYMSub=$O(^ARRCP(ARRCPID,"PAYM",PAYMSub)) q:PAYMSub=""  d
	.s PayModeID=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",1)
	.s PayMode=$P(^CT("CTPM",PayModeID),"^",1)
	.s PayModeDesc=$P(^CT("CTPM",PayModeID),"^",2)
	.s Amt=$P(^ARRCP(ARRCPID,"PAYM",PAYMSub),"^",3)
	.q:+Amt=0
	.
	.i PayModeStr="" d
	..s PayModeStr=PayMode_":"_PayModeDesc_":"_Amt
	.e  d
	..s PayModeStr=PayModeStr_","_PayMode_":"_PayModeDesc_":"_Amt
	q PayModeStr
}

/// 功能说明：根据发票ID获大类(子分类)ID、名称和金额、编码
/// 修改履历：徐保保 2020 08 07 新加
/// 入参：Papmi		病人ID
/// 	  PrtInvType  票据类型(PI：住院票据,PO：门诊票据,PR：挂号票据,PD：押金票据,PH:体检票据)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.Common).GetInvDetailsInfoByPapmi("1")
ClassMethod GetPECatFeeByInvDr(InvDr, UserId) As %String
{
	//0 给第三方传门诊子分类；1 给第三方传门诊分类
	s CatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 5)
	//第三方电子发票不区分门诊、住院分类时，his传分类编码时需要做区分
	s FeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "OPFeeCate_Source", 6)
	k PECateList	 
	s FH=1
	s RefundId=$P(^DHCPEINVPRT(InvDr),"^",9)	//退费ID
	i RefundId'="" d
	.s InvDr=RefundId,FH=-1
	
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID)) q:PreItemID=""  d			 //,"TARITEM",itmsub)
	.s TARITEMSub=""
	.f  s TARITEMSub=$O(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s InvDetailInfo=$G(^DHCPEOEITEM(InvDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..s TarId=$P(InvDetailInfo,"^",1)
	..s amount=(+$P(InvDetailInfo,"^",4))*FH
	..q:(TarId="")||(+amount=0)
	..s OPSubCat=$P(^DHCTARI(TarId),"^",15)			//门诊收费子分类
	..s OPCat=$P(^DHCTarC("OC",OPSubCat),"^",3)		//门诊收费大类
	..s:CatFlag="0" PECateList(OPSubCat)=+$g(PECateList(OPSubCat))+amount   ;按照门诊子分类统计
	..s:CatFlag="1" PECateList(OPCat)=+$g(PECateList(OPCat))+amount         ;按照门诊大类统计
	
	s catedr="",CatePayStr="",cateCode="",cateDesc=""
	f  s catedr=$o(PECateList(catedr)) q:(catedr="")  d
	.s:CatFlag="0" cateDesc=$p(^DHCTarC("OC",catedr),"^",2)        ;门诊子分类描述
	.s:CatFlag="0" cateCode=$p(^DHCTarC("OC",catedr),"^",1)		   ;门诊子分类编码
	.s:CatFlag="1" cateDesc=$p(^DHCTarC("TOC",catedr),"^",2)       ;门诊分类描述
	.s:CatFlag="1" cateCode=$p(^DHCTarC("TOC",catedr),"^",1)	   ;门诊分类编码
	.s CateFee=$g(PECateList(catedr))
	.s CateFee=$fn(CateFee,"",2)       	 ;保留两位小数
	.i (CatePayStr="") d
	..s CatePayStr=FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode  
	.e  d
	..s CatePayStr=CatePayStr_","_FeeType_catedr_"^"_cateDesc_"^"_CateFee_"^"_FeeType_cateCode
	
	q CatePayStr
}

/// 通过体检发票表ID获取体检费用明细信息
/// 徐保保
/// 2020 08 07
/// Input:InvPrtDr -发票ID
/// 返回值  ：成功：进程号,""：失败  
/// w ##class(BILL.EINV.BL.COM.Common).GetPEFeeDetailByPrtId("2111")
ClassMethod GetPEFeeDetailByPrtId(InvPrtDr As %String)
{
	q:InvPrtDr="" "" 
	
	//体检费用明细信息存入到临时global
	s EINVPID=$I(^CacheTemp("BILLEINV","GetFeeDetailSum"))
	k ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID)
	
	s RefundId=$p($g(^DHCPEINVPRT(InvPrtDr)),"^",9)
	i RefundId'="" s InvPrtDr=RefundId
	s admreasonId=$p($g(^DHCPEOEITEM(InvPrtDr)),"^",4)
	s:admreasonId="" admreasonId="1" 	;跟体检组沟通，如果为空,为自费
	
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonId,6)  ;获取医保类型
	
	//取门诊大类标记(1：取门诊大类,0：取门诊子分类)
	s OPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",5)
	s OPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","OPFeeCate_Source",6)
	//取住院大类标记(1：取住院大类,0：取住院子分类)
	s IPCatFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",5)
	s IPFeeType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","IPFeeCate_Source",6)
	
	s num=1
	s PreItemID=""
  	f  s PreItemID=$O(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)) q:PreItemID=""  d //,"TARITEM",itmsub)
	.s PresNo=""
	.s OEORI=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",1)	;医嘱id
	.s Arcim=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",5)	;医嘱项id
	.s BillDate=$p($g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID)),"^",7)	;体检项目预约日期
	.s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR  医嘱子类id
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType  医嘱类型
	.i OrderType["R" d
	..s PresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)		;处方号
	.s TARITEMSub=""
	.f  s TARITEMSub=$o(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) q:TARITEMSub=""  d
	..s InvDetailInfo=$g(^DHCPEOEITEM(InvPrtDr,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..q:InvDetailInfo="" 
	..s tarid=$p(InvDetailInfo,"^",1)
	..s amount=+$p(InvDetailInfo,"^",4)
	..q:amount=0 ;金额为0的不上传
	..s ItemSubCat=$p($g(^DHCTARI(tarid)),"^",15)		;费用子类id
	..s ItemCat=$p(^DHCTarC("OC",ItemSubCat),"^",3)		;门诊费用大类id
	..s UomID=$p(^DHCTARI(tarid),"^",3)					;单位id
	..s ItemUom=$p(^CT("UOM",UomID),"^",2)				;单位名称
	...;//医嘱结构改造后需要从药房接口取
	..s OeTraFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Drug_INCI_Flg",5)      ;医嘱改造标志，改造传"1"，未改造传其他，默认传"1"
	..s DrugInfo=##class(BILL.EINV.BL.COM.Common).GetDrugInfo(Arcim,tarid,OeTraFlag)   
	..s:DrugInfo="" DrugInfo="^^^^^^^^^"  ;规格^基本单位^入库单位^剂型dr^剂型^厂家^每次用量(等效单位)^频次^剂量单位^批准文号 
	..;获取门诊分类编码,分类名称
    ..s CateCode="",CateDesc=""
    ..i OPCatFlag="1" d
	...s CateCode=OPFeeType_$p($g(^DHCTarC("TOC",ItemCat)),"^",1)  	;门诊分类编码
	...s CateDesc=$p($g(^DHCTarC("TOC",ItemCat)),"^",2)  			;门诊分类名称
	..e  d
	...s CateCode=OPFeeType_$p($g(^DHCTarC("OC",ItemSubCat)),"^",1)  ;门诊子分类编码
	...s CateDesc=$p($g(^DHCTarC("OC",ItemSubCat)),"^",2)  			;门诊子分类名称
	..;获取目录对照关系
    ..s TarItemInsuInfo=""
    ..i InsuType'="" d
    ...s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	...s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(tarid,InsuType,BillDate,TariInsuFlag)
    ..s InsuScale=1-(+$p(TarItemInsuInfo,"^",18))	;报销比例
    ..s:TarItemInsuInfo="" InsuScale="0"
 	..s Insutjdm=$p(TarItemInsuInfo,"^",23)			;项目等级
 	..s Remark=$p(TarItemInsuInfo,"^",22)			;备注
 	..s ChrgType=$p(TarItemInsuInfo,"^",1)			;费用类型
 	..s Insuxmlb=$Case($p(TarItemInsuInfo,"^",7),"1":"药品","2":"诊疗项目","3":"服务设施",:"")	;项目类型				
	..s SelfAmt=$fn(amount*(1-(+InsuScale)),"",2)	;自费金额
    ..s DetailNo=TARITEMSub              			;流水号
	..s TarCode=$p($g(^DHCTARI(tarid)),"^",1)       ;项目编码
	..s TarDesc=$p($g(^DHCTARI(tarid)),"^",2)       ;项目名称
	..s Form=$p(DrugInfo,"^",5)       				;剂型
	..s Spec=$p(DrugInfo,"^",1)       				;规格
	..s Price=$p(InvDetailInfo,"^",2)				;单价
	..s Qty=$p(InvDetailInfo,"^",3)					;数量
	..s Amt=amount									;金额
	..s SelfAmt=amount*(1-(+InsuScale))   			;自费金额
    ..s BillDetailsRow=num_"^"_DetailNo_"^"_CateCode_"^"_CateDesc_"^"_PresNo_"^"_TarCode_"^"_TarDesc_"^"_Form_"^"_Spec_"^"_ItemUom_"^"_Price_"^"_Qty_"^"_Amt_"^"_SelfAmt_"^"_Insutjdm_"^"_Insuxmlb_"^"_InsuScale_"^"_Remark
    ..s ^CacheTemp("BILLEINV","GetFeeDetailSum",EINVPID,num)=BillDetailsRow
    ..s num=num+1
    
    q EINVPID
}

/// 取第三方接口交易订单号(新版)
/// w ##class(BILL.EINV.BL.COM.Common).GetExTradeNo(18)
ClassMethod GetExTradeNo(PrtRowid) As %String
{
	q:'$d(^DHCBILLETPi(0,"TTypePRT","OP","PRT",PrtRowid)) ""
	s RTPID=$o(^DHCBILLETPi(0,"TTypePRT","OP","PRT",PrtRowid,""),-1)
	q:RTPID="" ""
	s ExtTradeNo=$p(^DHCBILLETP(RTPID),"^",47)
	q ExtTradeNo
}

/// / w ##Class(web.PXTianZj).CheckUserFlag(10207)
/// Creator: TianZJ
/// CreatDate: 2021-05-27
/// Description: 判断是否为收费员（1：是收费员，0：不是）
ClassMethod CheckUserFlag(UserDr)
{
	Set UserFlag=0
	s rowid=$o(^DHCJFRcptGroupSet(0,"Type","O","3",""))
    i (rowid'="") d
    .s sub=0
    .f  s sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) q:(sub="")  d
    ..s usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..Quit:(usrrowid'=UserDr)
    ..Set UserFlag=1
    Quit UserFlag
}

/// 通过患者ID获取住院就诊ID记录
/// 苏惠德
/// 2021 12 27
/// Input:papmi -患者ID
/// 返回值  ：episodeId -就诊ID
/// w ##class(BILL.EINV.BL.COM.Common).GetAdmByPapmi("2111")
ClassMethod GetAdmByPapmi(papmi As %String) As %String
{
	set episodeId=""
	quit:(papmi="") episodeId
	set adm=""
	while($o(^PAPERdr(papmi,"ADM","I",adm),-1)&&(episodeId="")) {
		set adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:((" C P")[(" "_visitStatus_" "))
		set episodeId=adm
	}
	
    quit episodeId
}

/// desc: 按字节截取字符串
/// w ##class(BILL.EINV.BL.COM.Common).GetStringSplit("abcd你好",6)
ClassMethod GetStringSplit(str, num)
{
	s len = "0", j = ""
	for i = 1 : 1 : $l(str) {
		s word = $e(str, i)
		if ($ziswide(word)) {
			s len = len + 2
		} else {
			s len = len + 1
		}
		;i (len = num)||(len - num = 1)  s j = i
		i (len = num)  s j = i
		i (len - num=1)  s j = i-1
		
		q:(j '= "")
	}
	q:(j = "") str
	s target = $e(str, 1, j)	
	q target
}

/// Creator：	xubaobao
/// CreatDate：	2019-09-17
/// Desc:		根据门诊发票表rowid或者住院账单号获取支付方式相关信息
/// Input:		InvPrtDr:门诊发票rowid
/// 			PBDr:住院账单号
/// 			InvPrtInfoObj:BILL.EINV.DTO.COM.InvPrtInfo  发票信息对象
///             AdmType :就诊类型       ;区分集中打印发票和门诊发票ID，，，后续可能还会有体检发票
/// Return:		成功标志(0代表成功，其他代表失败)
/// Debug: w ##class(BILL.EINV.BL.COM.Common).GetPayModeInfoByInvPrtr("","232690")
ClassMethod GetPayModeInfoByInvPrt(AdmType As %String, InvPrtDr As %String) As %String
{
	s RtnFlg=""
	q:InvPrtDr="" RtnFlg
	s PayModeStr=""
	s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
	//获取住院发票支付方式
	;i InvPrtDr="" d
	i AdmType="IP" d
	.s InvPrtInfo=$g(^DHCINVPRTZY(InvPrtDr))       ;住院发票表->DHC_INVPRTZY
	.q:InvPrtInfo="" 
	.s PBDr=$p(InvPrtInfo,"^",5)              ;账单号
	.;add 2023-01-04 
    .i ($e(+HISVersion,1)>8) d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNoNew(InvPrtDr,"")
    .else  d
	..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNo(PBDr,"")
	;update   2020-04-09   guoyunlong
	//获取门诊发票支付方式
	i (AdmType="OP")||(AdmType="REG") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(InvPrtDr, "")
	//获取集中打印发票支付方式
	i (AdmType="API") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetAPIPayModeStrByInvDr(InvPrtDr, "")
	
	;add by xubaobao 2020 08 07 增加获取体检支付方式
	;体检暂时注释
    ;i AdmType="PE" d
	;.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr(InvPrtDr, "")
	;add guoyunlong  2023-01-04增加配置，适用于9.0版本
    s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
    i (AdmType="PE")  d
    .i ($e(+HISVersion,1)>8) d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDrNew(InvPrtDr, "")
    .else  d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr(InvPrtDr, "")
	
	
	
	//卡发票支付方式表
	i AdmType="CF" d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetCFPayModeStrByInvDr(InvPrtDr, "")
	
	q:PayModeStr="" RtnFlg
	
	//支付方式信息对象赋值
	f num=1:1:$l(PayModeStr,",") q:(RtnFlg="-1")  d
	.s PayModeInfo=$p(PayModeStr,",",num)
	.s PayModeObj=##class(BILL.EINV.DTO.COM.InvPayModeInfo).%New()
	.s PayModeObj.Code=$p(PayModeInfo,":",1)      //支付方式编码
	.s PayModeObj.Desc=$p(PayModeInfo,":",2)      //支付方式名称
	.s PayModeObj.Amt=$p(PayModeInfo,":",3)       //支付方式金额
	.q:(+PayModeObj.Amt)=0		
	.s PayModeObj.Amt=$fn(PayModeObj.Amt,"",2)
	.;s DHCPayModeStr=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","Pay_Mode",6)
	.i (PayModeObj.Code)="QF" d      ///自行添加需要过滤的支付方式
	..s RtnFlg="-1"
	.else  d
	..s RtnFlg="0"
	q RtnFlg
}

/// 判断支付方式在对应的发票或者账单里面存在
/// input :AdmType  就诊类型 （OP,IP..）
///       InvPrtDr 发票ID
///       PBDr  账单号
///       PayModeStr 支付方式串（多个用|拼接）
/// return: 空 -不存在  1存在
/// 2022-03-16
/// w ##class(BILL.EINV.BL.EInvoiceLogic).JudgePayModeById("IP","","6486148","ZP|QF|QFGZ")
ClassMethod JudgePayModeById(AdmType, InvPrtDr, PBDr, PayMode) As %String
{
	s RtnFlg="",PayModeStr=""
	q:AdmType="" RtnFlg
	q:((InvPrtDr="")&&(PBDr="")) RtnFlg
	s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
	//获取住院发票支付方式
	;i InvPrtDr="" d
	i AdmType="IP" d
	.i ($e(+HISVersion,1)>8) d
	..s InvPrtDr=$o(^DHCINVPRTZY(0,"AR",PBDr,""),-1)
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNoNew(InvPrtDr,"")   ;add guoyunlong  用于9.0版本
    .else  d
	..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNo(PBDr,"")
	
	b //获取门诊发票支付方式
	i (AdmType="OP") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetOPPayModeStrByInvDr(InvPrtDr, "")
	//获取集中打印发票支付方式
	i (AdmType="API") d
	.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetAPIPayModeStrByInvDr(InvPrtDr, "")
	;体检暂时注释
    ;i AdmType="PE" d
	;.s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr(InvPrtDr, "")
	;add guoyunlong  2023-01-04增加配置，适用于9.0版本
    s HISVersion=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","HIS_Version",6)
    i (AdmType="PE")  d
    .i ($e(+HISVersion,1)>8) d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDrNew(InvPrtDr, "")
    .else  d
    ..s PayModeStr=##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr(InvPrtDr, "")
	
	q:PayModeStr="" RtnFlg
	//支付方式信息对象赋值
	f num=1:1:$l(PayModeStr,",") d
	.s PayModeInfo=$p(PayModeStr,",",num)
	.s PayModeObj=##class(BILL.EINV.DTO.COM.InvPayModeInfo).%New()
	.s PayModeObj.Code=$p(PayModeInfo,":",1)      //支付方式编码
	.s PayModeObj.Desc=$p(PayModeInfo,":",2)      //支付方式名称
	.s PayModeObj.Amt=$p(PayModeInfo,":",3)       //支付方式金额
	.q:$fn(PayModeObj.Amt,"",2)="0.00"	
	.i ("|"_PayMode_"|")[("|"_PayModeObj.Code_"|") d
	..s RtnFlg="1"
	q RtnFlg
}

/// Description: 通过发票ID获取参与结算的押金Rowid  (适用于9.0版本)
/// input: PrtRowid    -住院发票表ID
/// output:DepositStr  -住院参与结算的押金ID
/// Creator: guoyunlong
/// Date: 2023-01-04
/// w ##class(BILL.EINV.BL.COM.Common).GetDepositStrByPrtRowid("")
ClassMethod GetDepositStrByPrtRowid(PrtRowid As %String, billId As %String) As %String
{
	q:(PrtRowid="")&&(billId="") ""
	if PrtRowid="" s PrtRowid=$o(^DHCINVPRTZY(0,"AR",billId,""),-1)
	s PrtZyConId="",DepositStr=""
	for  s PrtZyConId=$o(^DHCINVPRTZYCONDEP("IdxInvDR",PrtRowid,PrtZyConId)) q:PrtZyConId=""   d
	.s PrtZyConInfo=$g(^DHCINVPRTZYCONDEP(PrtZyConId))
	.s ICDDepDR=$p(PrtZyConInfo,"^",3)
	.i DepositStr="" d
	..s DepositStr=	ICDDepDR
	.else  d
	.s DepositStr=DepositStr_"^"_ICDDepDR	
	q DepositStr
}

/// Description:根据发票ID获取住院发票支付方式信息
/// Debug:w ##class(BILL.EINV.BL.COM.Common).GetIPPayModeStrByBillNoNew(432829,"")
ClassMethod GetIPPayModeStrByBillNoNew(PrtRowid, UserId) As %String
{
	kill PayList
	s BillNo=$p(^DHCINVPRTZY(PrtRowid),"^",3)
	set TDeposit=##class(web.UDHCJFBaseCommon).GetPaidDeposit(BillNo)
	set IPMSub=""
    for  set IPMSub=$o(^DHCINVPRTZY(PrtRowid,"P",IPMSub)) quit:IPMSub=""  do
	.set PaymodeDr=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",2)
	.quit:(+PaymodeDr=0)
	.set PayAmt=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",4)
	.set PayMode=$P(^CT("CTPM",PaymodeDr),"^",1)
	.set PayModeDesc=$P(^CT("CTPM",PaymodeDr),"^",2)
	.quit:(+PayAmt=0)
	.set PayList(PayMode)=$g(PayList(PayMode))+PayAmt
	
	set PayModeStr=""
    set PayMId=""
    for  set PayMId=$o(PayList(PayMId))  quit:(PayMId="")  do
    .set PatMCode=$p(^CT("CTPM",PayMId),"^",1)
    .set PayMDesc=$p(^CT("CTPM",PayMId),"^",2)
    .set PayAmt=$g(PayList(PayMId))
	.if (PayModeStr="") do
	..set PayModeStr=PatMCode_":"_PayMDesc_":"_PayAmt
	.else  do
	..set PayModeStr=PayModeStr_","_PatMCode_":"_PayMDesc_":"_PayAmt
	
	quit "CTYJJ"_":"_"冲退预交金"_":"_TDeposit_","_PayModeStr
}

/// yandong
/// 2020-6-23
/// 获取体检支付方式信息
/// 修改履历：徐保保 2020 08 07 新加
/// w ##class(BILL.EINV.BL.COM.Common).GetPEPayModeStrByInvDr("2246","")
ClassMethod GetPEPayModeStrByInvDrNew(PrtRowid, UserId) As %String
{
	s PayModeStr=""
	s ARRCPID=$P(^DHCPEINVPRT(PrtRowid),"^",4)
	s PAADM=$P(^DHCPEINVPRT(PrtRowid),"^",2)
	s PapmiID=$P(^PAADM(PAADM),"^",1)
	q:ARRCPID="" PayModeStr
	s IPMSub=0
	for  set IPMSub=$o(^DHCINVPRTZY(PrtRowid,"P",IPMSub)) quit:IPMSub=""  do
	.set PaymodeDr=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",2)
	.quit:(+PaymodeDr=0)
	.set PaymodeAmt=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",4)
	.set PayMode=$P(^CT("CTPM",PaymodeDr),"^",1)
	.set PayModeDesc=$P(^CT("CTPM",PaymodeDr),"^",2)
	.q:+PaymodeAmt=0
	.i PayModeStr="" d
	..s PayModeStr=PayMode_":"_PayModeDesc_":"_PaymodeAmt
	.e  d
	..s PayModeStr=PayModeStr_","_PayMode_":"_PayModeDesc_":"_PaymodeAmt
	q PayModeStr
}

/// Description：通过发票ID获取结算后补退金额
/// Input：PrtRowid --> 发票ID
/// output：补收金额^退款金额
/// Date:2023-01-04
/// 补充说明：适用于9.0版本           
/// w ##class(BILL.EINV.BL.COM.Common).GetPayFeeInfoNew(6176)
ClassMethod GetPayFeeInfoNew(PrtRowid As %String) As %String
{
	set Rtn="-1"
	quit:(PrtRowid="") Rtn
	set RecAmount=0,RefAmount=0
	set IPMSub="0"
	for  set IPMSub=$o(^DHCINVPRTZY(PrtRowid,"P",IPMSub)) quit:IPMSub=""  do
	.set PaymodeDr=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",2)
	.quit:(+PaymodeDr=0)
	.set PaymodeAmt=$p(^DHCINVPRTZY(PrtRowid,"P",IPMSub),"^",4)
	.if (+PaymodeAmt>0) do
	..set RecAmount=RecAmount+PaymodeAmt			//应收金额
	.else  if (+PaymodeAmt<0) do
	..set RefAmount=RefAmount+PaymodeAmt			//应退金额
	set Rtn=$fn(RecAmount,"",2)_"^"_$fn(RefAmount,"",2)
	quit Rtn
}

/// 生成纯数字的字符串
/// w ##class(BILL.EINV.COM.Common).CreateCheckeCode("6") 
/// input :OutLen  ;字符串的长度
/// output:OutInfo   ;输出字符串
ClassMethod CreateCheckeCode(OutLen As %Integer = 6) As %String
{
                       
	s OutInfo=""
	f index=1:1:OutLen d
	.s RandomIndex=$Random(10)  ;获取随机字符的索引
	.s OutInfo=OutInfo_RandomIndex
	q OutInfo
}

}
