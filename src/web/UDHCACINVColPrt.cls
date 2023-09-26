Import SQLUser

Class web.UDHCACINVColPrt Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.UDHCACINVColPrt).BuildAPINVInfo()
ClassMethod BuildAPINVInfo() As %String
{
	n (ad)
	
	s $zt="ERROR^DHCSSERR"
	
	s rtn=0
	q:'$d(^TMPColPrt("IP",$j)) 100_$c(2)_""
	s myAccINVInfo=""
	
	//费别?DHC_AccPayINV 票据组  ?对应的DHC_INVPRT的RowID串
	s myInsINVInfo=""
	s myInsType=0
	f  s myInsType=$o(^TMPColPrt("IP",$j,myInsType)) q:(myInsType="")  d
	.s myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.s myINVNum=+$g(^TMPColPrt("IP",$j,myInsType))
	.s myINVPrtInfo=""
	.s myINVIdx=0
	.f  s myINVIdx=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myCurSum=+$g(^TMPColPrt("IP",$j,myInsType,myINVIdx,"PatPaySum"))
	..s myPrtStr=""
	..s mySPrtRowID=0
	..f  s mySPrtRowID=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myPrtStr=myPrtStr_"^"_mySPrtRowID
	..s myINVPrtInfo=myINVPrtInfo_$c(4)_myCurSum_$c(5)_myPrtStr		;发票信息
	.s myInsINVInfo=myInsType_"^"_myInsDesc_$c(3)_myINVPrtInfo
	
	s myAccINVInfo=rtn_$c(2)_myInsINVInfo
	
	q myAccINVInfo
}

/// 集中打印的步骤?
/// 1?把帐单集合表DHC_INVPRT  汇集在一起根据算法分成发票信息?1:N关系
/// 1.1把帐单集合的医嘱生成临时Global?^TMPColPrt("OrdItem",$j,)
/// 1.2根据算法写分出发票?
/// 2?把发票信息显示到界面中?
/// 3?保存DHC_AccPayINV表?同时更新DHC_INVPRT表置这张表的NotPrint为Printed?写RowID
/// 更新发票表
/// 打印发票后的退费
/// w ##class(web.UDHCACINVColPrt).GetAccPayINVData("30||3^30||4^30||5^30||6^30||21^30||22^30||23^30||24^30||25","1","1")
ClassMethod GetAccPayINVData(APLRowIDStr As %String, itemFlag As %String, reclocFlag As %String, OnToManyFlag As %String = "0", RegInvFlag As %String = "0", InvDateFlag As %String = "") As %String
{
	n (APLRowIDStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	s $zt="ERROR^DHCSSERR"
	s rtn=0
	d ..KTMP()

	s mylen=$l(APLRowIDStr,"^")
	f i=1:1:mylen q:(+rtn)  d
	.s myAccPLDR=$p(APLRowIDStr,"^",i)
	.q:(myAccPLDR="")
	.i $d(^DHCINVPRTi(0,"AccPLDR",myAccPLDR)) d
	..s myPrtRowID=0
	..f  s myPrtRowID=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLDR,myPrtRowID)) q:(myPrtRowID="")  d
	...q:('$d(^DHCINVPRT(myPrtRowID)))
	...s myInvPrtFlag=$p(^DHCINVPRT(myPrtRowID),"^",3)
	...s:(myInvPrtFlag="P") rtn=109
	...q:(myInvPrtFlag="P")	//过滤已打印发票的记录
	...s myINVFlag=$p(^DHCINVPRT(myPrtRowID),"^",8)
	...q:(myINVFlag'="N")	//只计算正常发票
	...s myPMSub=0
	...f  s myPMSub=$o(^DHCINVPRTi(0,"AccPLDR",myAccPLDR,myPrtRowID,"P",myPMSub)) q:(myPMSub="")  d
	...s myrtn=..GetINVPrtData(myPrtRowID, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	...s rtn=$p(myrtn,"^")
	...q:(+rtn)
	.e  i $d(^DHCINVPRT(myAccPLDR)) d          ;2011-11-25 tangtao 软POS和银医卡不走账户表
	..s myPrtRowID=myAccPLDR
	..s myINVFlag=$p(^DHCINVPRT(myPrtRowID),"^",8)
	..q:(myINVFlag'="N")	//只计算正常发票
	..s myrtn=..GetINVPrtData(myPrtRowID, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	..s rtn=$p(myrtn,"^")
	..q:(+rtn)

	q rtn
}

/// 支持手工的分票?
/// 主要根据传入的支付RowID的串
/// w ##class(web.UDHCACINVColPrt).GetAccPayINVData("30||3^30||4^30||5^30||6^30||21^30||22^30||23^30||24^30||25","1","1")
ClassMethod GetAccPayINVDataByPRTStr(PRTRowIDStr As %String, itemFlag As %String, reclocFlag As %String, OnToManyFlag = "", RegInvFlag = "", InvDateFlag = "") As %String
{
	n (PRTRowIDStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)

	s $zt="ERROR^DHCSSERR"
	
	s rtn=0
	
	d ..KTMP()
	
	s mylen=$l(PRTRowIDStr,"^")
	f i=1:1:mylen q:(+rtn'=0)  d
	.s myPrtRowID=$p(PRTRowIDStr,"^",i)
	.q:(myPrtRowID="")
	.s myINVFlag=$p(^DHCINVPRT(myPrtRowID),"^",8)
	.q:(myINVFlag'="N")	  //只计算正常发票
	.s rtnValue=..GetINVPrtData(myPrtRowID, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	.s rtn=$p(rtnValue,"^",1)
	.q:(+rtn)
	
	q rtn
}

/// 一张发票生成临时Global
/// 总的发票
ClassMethod GetINVPrtData(INVPrtRowID As %String, itemFlag As %String, reclocFlag As %String, OnToManyFlag As %String = "0", RegInvFlag As %String = "0", InvDateFlag As %String = "") As %String
{
	n (INVPrtRowID, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
		
	s $zt="ERROR^DHCSSERR"
	
	s myHospDR=$p($g(^DHCINVPRT(INVPrtRowID)),"^",39)
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(myHospDR)
	s rtn=$p(HerbConfig,$c(2))
	q:(rtn) 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	
	s myConStr=##class(web.DHCOPConfig).GetOPYBConfig(myHospDR)
	s YBConFlag=+$p(myConStr,"^",2)		;YBConFlag
	s FCAdmFlag=+$p(myConStr,"^",3)		;AdmFlag
	
	s myBCRowid=0
	f  s myBCRowid=$o(^DHCBCI(0,"INV",INVPrtRowID,myBCRowid)) q:(myBCRowid="")  d
	.s bill=$p(^DHCBCI(myBCRowid),"^",2)
	.;Lid 2011-12-13 发票与小条对应关系
	.s InvDR="InvID"	;默认:1:n
	.s fairType=$p(^DHCINVPRT(INVPrtRowID),"^",34)
	.i ((+OnToManyFlag=1)||((fairType="R")&&(+RegInvFlag=1))) d
	..s InvDR=INVPrtRowID	;1:1
	.;end
	.;Lid 2012-05-10 
	.s PRTDate=$p(^DHCINVPRT(INVPrtRowID),"^",5)		;PRT_Date
	.s InvDate="InvDate"
	.i (InvDateFlag=1) d
	..s InvDate=PRTDate
	.;end
	.s AdmDR=$p(^DHCPB(bill), "^", 1)			;DHC_PatientBill->PB_Adm_Dr
	.i (FCAdmFlag=0) d
	..s AdmDR="AdmID"
	.s instypenot=$p(^DHCINVPRT(INVPrtRowID),"^",9)		;费别
	.s PBO=0
	.f  s PBO=$o(^DHCPB(bill,"O",PBO)) q:(PBO="")  d
	..s PBOData=$g(^DHCPB(bill,"O",PBO))
	..q:(PBOData="")
	..s PBORowID=bill_"||"_PBO
	..s Arcim=$p(PBOData,"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s BillSubDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",9) 
	..s ORCATDesc=$p(^ARCBG($p(BillSubDR,"||",1)),"^",2)
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)
	..s ItmCatSub=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10) 	;ARC_ItmMast->ARCIM_ItemCat_DR
	..s OrderType=$p(^ARC("IC",ItmCatSub),"^",7)
	..s OEORI=$p(PBOData,"^",4)   ;DHC_PatBillOrder->PBO_OEORI_DR
	..s billflag=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",5)
	..s oederstatus=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)
	..;
	..;2015-03-24 Lid 作废医嘱按停止医嘱处理，防止收费时报“102”错误
	..s oederstatus=##class(web.DHCBillCons1).ResetOrderStatus(oederstatus)
	..;
	..s Prescno=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14) ;处方号
	..s PresIdxNo=Prescno
	..i ((PresIdxNo="")||(OrderType'="R"))  d
	...s PresIdxNo="ZOI"
	..s ordinstype=$p(^OEORD($p(OEORI,"||",1),"I",$p(OEORI,"||",2),11),"^",18)  ;OE_OrdItem->OEORI_BBExtCode
	..i (ordinstype="") s ordinstype=##class(web.DHCBillCons).ReadDefInsType(myHospDR)		;按照默认费别; instypenot
	..s mytmpordtype=$o(^OEC("OSTAT",0,"Code","D",""))	;Stop Order RID
	..;添加条件?zhaocz
	..;停止的药物医嘱和非停止的bill状态医嘱
	..s OrderBillQty=$p(PBOData,"^",5)
	..s OrdRefQty=+$p(PBOData,"^",6)
	..q:(+OrderBillQty<=0)
	..//q:(OrderType="R")&&(oederstatus=mytmpordtype)&&(+OrderBillQty=-OrdRefQty)
	..q:(+OrderBillQty=-OrdRefQty)
	..s ItemGroup=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),6)),"^",1)  ;组别
	..s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	..s recdepdesc=$p(^CTLOC(recdepcode),"^",2)
	..//按接收科室拆分
	..s reclocnot="RecID"
	..i (+reclocFlag'=0) d
	...s reclocnot=recdepcode
	..s loctype=$p(^CTLOC(recdepcode),"^",13)
	..s OrderUnitPrice=$p(PBOData,"^",7)
	..s OrdPatShare=$p(PBOData,"^",11)
	..s OrdTotalAmt=$p(PBOData,"^",8)
	..s OrderBillQty=$p(PBOData,"^",5)
	..s OrderSum=OrderUnitPrice*OrderBillQty
	..s ItmNum=0
	..s PBD=0
	..f  s PBD=$o(^DHCPB(bill,"O",PBO,"D",PBD)) q:(PBD="")  d
	...s PBDData=$g(^DHCPB(bill,"O",PBO,"D",PBD))
	...s PBDItemDR=$p(PBDData,"^",3)
	...s PBDUnitprice=$p(PBDData,"^",4)
	...s PBDPatShare=$p(PBDData,"^",10)
	...s PBDPrice=$p(PBDData,"^",7)
	...s PBDQty=$p(PBDData,"^",5)
	...s PBDItemdesc=$p(^DHCTARI(PBDItemDR),"^",2)    ;收费项目描述
	...s PBDCatsub=$p(^DHCTARI(PBDItemDR),"^",15)     ;门诊子类DHC_TarItem->TARI_OutpatCate	
	...s PBDCat=$p(^DHCTarC("OC",PBDCatsub),"^",3)    ;门诊大类DHC_TarOutpatCate->TAROC_TARTOC_DR
	...s PBCCatdesc=$p($g(^DHCTarC("TOC",PBDCat)),"^",2)
	...//按门诊收费大类拆分
	...s itemsubnot="ItemID"	//定值
	...i (+itemFlag'=0) d
	....;s itemsubnot=PBDCatsub
	....s itemsubnot=PBDCat     //yyx 2010-04-01 按门诊大类拆分发票
	...s ItmNum=ItmNum+1
	...s ^TMPColPrt("OPITEM",$j,instypenot,INVPrtRowID,PBORowID,reclocnot,itemsubnot,ItmNum)=Arcim_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBDItemDR_"^"_PBDItemdesc_"^"_PBDPrice_"^"_PBDQty_"^"_PBDCat_"^"_PBCCatdesc_"^"_PBDCatsub_"^"_PBDUnitprice_"^"_PBDPatShare
	..i ((+FCHerbFlag=1)&&(FCHerbRange[("^"_ItmCatSub_"^"))) d
	...s ^TMPColPrt("OPOI",$j,instypenot,INVPrtRowID,PBORowID,"ItmNum")=+FCHerbNum		;草药的医嘱数量
	...s FCHerbNum=0
	..e  d
	...s myOFFlag=""
	...// F:打印计费项; O:打印医嘱项
	...s myOFFlag=##class(web.DHCOPConfig).ReadOESpPrtFlag(Arcim)
	...i (myOFFlag="F") d
	....s ^TMPColPrt("OPOI",$j,instypenot,INVPrtRowID,PBORowID,"ItmNum")=ItmNum+##class(web.DHCBillCons1).%GetParameter("ITMNUM")	;费用项数量;
	...e  d
	....s ^TMPColPrt("OPOI",$j,instypenot,INVPrtRowID,PBORowID,"ItmNum")=1		;医嘱数量
	..s ^TMPColPrt("OPOI",$j,instypenot,INVPrtRowID,PBORowID)=ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBORowID_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare_"^"_AdmDR_"^"_InvDR_"^"_InvDate_"^"_OrdTotalAmt
	..s ^TMPColPrt("OPOPN",$j,instypenot,INVPrtRowID,PresIdxNo,PBORowID)=Prescno	;增加一个索引
	
	;check the Data
	i '$d(^TMPColPrt("OPOPN",$j)) d
	.d ##class(web.UDHCOPFError).BConGetBillDataErr(billstr)
	
	q 0
}

ClassMethod InsertAINVConPrt(ConStr As %String) As %String
{
	new (ConStr)
	
	set $zt="ERROR^DHCSSERR"
	
	set rtn=0
	
	kill PLIST
	set PLIST(2)=$p(ConStr,"^",1)		//ACP_INVPRT_DR
	set PLIST(3)=$p(ConStr,"^",2)		//ACP_APINV_DR
	set rtn=##class(web.UDHCAccPINVCONPRT).INSERT()
	
	quit rtn
}

/// w ##class(web.UDHCACINVColPrt).InsertAPayINV("3_$c(3)_^N^10033^3409227^^15")
ClassMethod InsertAPayINV(APINVInfo As %String) As %String
{
	new (APINVInfo)
	
	set $zt="ERROR^DHCSSERR"
	
	kill PLIST
	set PLIST(2)=$p(APINVInfo,"^",1)		//API_Amount
	set PLIST(3)=$p(APINVInfo,"^",2)		//API_Flag
	set PLIST(4)=+$h						//API_Date
	set PLIST(5)=$p($h,",",2)				//API_Time
	set PLIST(6)=$p(APINVInfo,"^",3)		//API_PUser_DR
	set PLIST(7)=$p(APINVInfo,"^",4)		//API_INVNo
	set PLIST(12)=$p(APINVInfo,"^",5)		//API_PAPMI_DR
	set PLIST(13)=$p(APINVInfo,"^",6)		//API_AccMan_DR
	set PLIST(14)=$p(APINVInfo,"^",7)		//API_PatientShare
	set PLIST(15)=$p(APINVInfo,"^",8)		//API_DiscAmount
	set PLIST(16)=$p(APINVInfo,"^",9)		//API_PayorShare
	set PLIST(17)=$p(APINVInfo,"^",10)	    //API_SelfPatPay
	set PLIST(18)=$p(APINVInfo,"^",11)	    //API_SelfYBPay
	set PLIST(19)=-$p(APINVInfo,"^",12)	    //API_RefundSum
	set PLIST(20)=$p(APINVInfo,"^",13)	    //API_InsDiv_DR
	set PLIST(23)=$p(APINVInfo,"^",14)	    //API_OldAPINV_DR
	set PLIST(24)=$p(APINVInfo,"^",15)	    //API_OPCRoundSum
	set PLIST(26)=$p(APINVInfo,"^",26)	    //API_AutoYBFlag   //自助结算标识
	set PLIST(27)=$system.Process.ClientIPAddress()    //客户端IP
	set PLIST(30)=$p(APINVInfo,"^",17)	    //API_Hospital_DR
	set PLIST(31)=$p(APINVInfo,"^",27)	    //API_StayFlag     //急诊留观标识
	set PLIST(32)=$p(APINVInfo,"^",16)	    //API_InsType_DR
	set PLIST(33)=$p(APINVInfo,"^",18)	    //API_Group_DR
	set PLIST(34)="N" 					    //API_HandIn
	set rtn=##class(web.UDHCAccPayINV).INSERT()
	quit:(+rtn) rtn_"^"_$g(%msg)
	set myAPRowID=PLIST(1)

	quit rtn_"^"_myAPRowID
}

/// modify hujunbin 添加ExpStr扩展串
/// w ##class(web.UDHCACINVColPrt).InsertAPayINVMode()
ClassMethod InsertAPayINVMode(APModeInfo As %String, APIRowID As %String, ExpStr As %String = "") As %String
{
	new (APModeInfo, APIRowID, ExpStr)
	set $zt="ERROR^DHCSSERR"
	set AutoYBFlag=$p(ExpStr,"^",1)  //+2014-12-05 hujunbin 
	set HospId=$p(ExpStr,"^",2)      //+2018-03-22 ZhYW 
	
	set rtn=0
	
	set YBSum=0
	set AccPayFlag=0

	set mylen=$l(APModeInfo,$c(4))
	for i=1:1:mylen {
		set myAPInfo=$p(APModeInfo,$c(4),i)
		continue:(myAPInfo="")
		kill PLIST
		set PayMDR=$p(myAPInfo,"^",1)		//APM_PayMode_DR
		set PayMAmt=$p(myAPInfo,"^",2)
		set PLIST(0)=APIRowID
		set PLIST(3)=PayMDR
		set PLIST(5)=PayMAmt		//APM_Amt
		set PLIST(8)=+$h
		set PLIST(9)=$p($h,",",2)
		set rtn=##class(web.UDHCAccPayINVMode).INSERT()
		quit:(+rtn)
		set PayMCode=$s((+PayMDR'=0):$p($g(^CT("CTPM",PayMDR)),"^",1),1:"")
		if (PayMCode="CPP") {
			set AccPayFlag=1
		}
		if (PayMCode["INSU") {
			set YBSum=$i(YBSum, PayMAmt)
		}
	}
	quit:(+rtn) rtn
	
	if ((AutoYBFlag'=1)&&(AccPayFlag=1)&&(YBSum'=0)) {
		set APIData=$g(^DHCINVPRTAP(APIRowID))
		set PUserId=$p(APIData,"^",5)
		set AccMRowID=$p(APIData,"^",12)
		set PreType=$s((YBSum<0):"R",1:"P")
		set YBSum=$zabs(YBSum)
		set PayMId=$o(^CT("CTPM",0,"Code","YBINSU",0))
		set BackReason=""
		set Password=""
		set Remark=""
		set InitPDRowId=""
		set DepTypeId=##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
		set PDInfo=YBSum_"^"_PUserId_"^"_BackReason_"^"_Password_"^"_PreType_"^"_Remark_"^"_HospId
		set PDInfo=PDInfo_"^"_InitPDRowId_"^"_DepTypeId_"^"_APIRowID

		set Bank=""
		set ChequeNo=""
		set BankCardType=""
		set Company=""
		set ChequeDate=""
		set PayAccNo=""
		set PDPMInfo=PayMId_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate
		set PDPMInfo=PDPMInfo_"^"_PayAccNo_"^"_YBSum
		
		set rtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccMRowID, PDInfo, PDPMInfo)
		set rtn=$p(rtnValue,"^",1)
	}
	
	quit rtn
}

ClassMethod KTMP() As %String
{
	kill ^TMPColPrt("IP",$j)
	kill ^TMPColPrt("OPOPN",$j)
	kill ^TMPColPrt("OPOI",$j)
	kill ^TMPColPrt("OPITEM",$j)
	kill ^TMPColPrt("BillINV",$j)
}

/// 临时发票 ^TMPColPrt("TP",$j)
/// 正式发票 ^TMPColPrt("IP",$j)
/// ^DHCTMPACCColPRT("IP",myTMPGID)   根据帐户RowID生成的^TMP
/// K 临时发票
/// 复制发票到临时发票
/// 把帐单集合DHC_INVPRT,验证到临时发票中查看这张发票能否容纳当前的帐单集合
/// 如果不能容纳:临时发票号码加1,进入下一张发票;
/// 把当前的临时发票复制为正式发票
/// 同时删除临时发票
/// w ##class(web.UDHCACINVColPrt).ParDataToABill(2, 3)
ClassMethod ParDataToABill(RecInvCount As %String, printCount As %String, TMPGID As %String) As %String
{
	n (RecInvCount, printCount, TMPGID)
	
	s $zt="ERROR^DHCSSERR"
	
	k ^TMPColPrt("IP",$j)
	k ^TMPColPrt("BillINV",$j)
	k ^DHCTMPACCColPRT("IP",TMPGID)
	
	s rtn=0
	s mIdx=0
	s myinstype=""
	f  s myinstype=$o(^TMPColPrt("OPOPN",$j,myinstype)) q:((myinstype="")||(+rtn))  d
	.s myFullFlag=0
	.s myPrtRowID=0
	.f  s myPrtRowID=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID)) q:((myPrtRowID="")||(+rtn))  d
	..i (myFullFlag=1) d
	...s myFullFlag=0		;设置在当前发票中未满
	..e  d
	...s myINVIdx=1		    ;任何一个帐单集合都是由第一张发票开始验证
	..s myPresNo=""
	..//i (mIdx>150) s rtn=-1			;防止设置错误的无限循环????  2021-01-07 ZhYW 注释
	..f  s myPresNo=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID,myPresNo)) q:((myPresNo="")||(+rtn))  d
	...q:(myFullFlag=1)
	...s myPBordrid=0
	...f  s myPBordrid=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID,myPresNo,myPBordrid)) q:(myPBordrid="")  d
	....;循环费用项目	;返回票据的索引数
	....q:(myFullFlag=1)
	....s mIdx=$$CheckBill(myinstype, myPBordrid, RecInvCount, printCount, myPrtRowID, myINVIdx)
	....i (myINVIdx'=mIdx) d
	.....;表示当前的实际发票放不下当前的帐单集合?故帐单集合重新在下一张发票中验证
	.....s myFullFlag=1
	....q:(myFullFlag=1)
	....s billrtn=$$BuildBillData(mIdx, myinstype, myPBordrid, RecInvCount, printCount, myPrtRowID)	
	....i (billrtn'=0) s rtn=-1
	....q:(rtn)
	...i (myFullFlag=1) d
	....s myINVIdx=+myINVIdx+1
	....s myTMPIdx=$g(^TMPColPrt("BillINV",$j,myinstype))
	....s mydd=$$CopyData(myinstype, myINVIdx)
	....i (myINVIdx>myTMPIdx) d
	.....d BuildBlankBill(myinstype)
	..s myIPCount=+$g(^TMPColPrt("IP",$j,myinstype))
	..i ((myFullFlag=1)&&(myIPCount>=(myINVIdx-1))) d
	...//如果当前处方不适合?就重新对此帐单集合进行分配
	...s myPrtRowID=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID),-1)
	..i ((myFullFlag=1)&&(myIPCount<(myINVIdx-1))) d
	...s myFullFlag=0
	...k ^TMPColPrt("BillINV",$j,myinstype,myINVIdx)
	...s myINVIdx=myINVIdx-1
	...s ^TMPColPrt("BillINV",$j,myinstype)=^TMPColPrt("BillINV",$j,myinstype)-1
	..i (myFullFlag=0) d
	...k ^TMPColPrt("IP",$j,myinstype,myINVIdx)
	...m ^TMPColPrt("IP",$j,myinstype,myINVIdx)=^TMPColPrt("BillINV",$j,myinstype,myINVIdx)
	...s ^TMPColPrt("IP",$j,myinstype)=^TMPColPrt("BillINV",$j,myinstype)
	
	k ^TMPColPrt("BillINV",$j)
	
	d BuildHISPayMode()
	
	//前面增加一个myTMPGID的锁点  Lock
	//增加一个^DHCTMPACCColPRT("IP",myTMPGID)
	s myTMPGID=TMPGID
	
	m ^DHCTMPACCColPRT("IP",myTMPGID)=^TMPColPrt("IP",$j)
	
	;k ^TMPColPrt("IP",$j)
	
	q rtn
CopyData(tmpinstype, tmpINVIdx)
	n (tmpinstype, tmpINVIdx)
	//复原前一张发票
	k ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx-1)
	
	m ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx-1)=^TMPColPrt("IP",$j,tmpinstype,tmpINVIdx-1)
	
	//复原下一张发票
	k ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx)
	
	m ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx)=^TMPColPrt("IP",$j,tmpinstype,tmpINVIdx)
	
	q 0
CheckBill(tmpinstype, tmpPBordrid, tmpRecInvCount, tmpprintCount, tmpPrtRowID, tmpINVIdx)
	n (tmpinstype, tmpPBordrid, tmpRecInvCount, tmpprintCount, tmpPrtRowID, tmpINVIdx)
	s $ZT="ERROR^DHCSSERR"
	
	s CBIPNum=$g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,"ItmNum"))   //需要打印的明细数量
	s PrintFlag=0
	s RecpFlag=0
	s CBIIviFlag=0
	s CBICurIdx=""
	//分票算法;
	//说明:  1:表示此医嘱可以放在此票据内;0 表示不能放在此票据内;
	s myCurAdmDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",16)
	s myCurInvDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",17)  	    ;Lid 2011-12-13
	s myCurInvDate=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",18)		;Lid 2012-05-10
	k ^TMPColPrt("TMPLI",$j)
	
	s CBIinvidx=tmpINVIdx-1
	f  s CBIinvidx=$o(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx)) q:((CBIinvidx="")||(CBIIviFlag=1))  d
	.k ^TMPColPrt("TMPLI",$j)
	.s CBICurIdx=CBIinvidx		;记录下当前的票据编号;1,2,3,等等与原始票据无关;
	.s INVPNum=CBIPNum+^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"PrintCount")		;记录数
	.;判断是否有条件参数
	.i (tmpprintCount=0) d
	..s PrintFlag=1
	.e  d
	..s PrintFlag=0
	.i (tmpRecInvCount=0) d
	..s RecpFlag=1
	.e  d
	..s RecpFlag=0
	.s myAdmFlag=0
	.s myInvFlag=0        ;Lid 2011-12-13
	.s myInvDateFlag=0    ;Lid 2012-05-10
	.s INVRecNum=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount")			;回执
	.s cbrecloc=""
	.f  s cbrecloc=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc)) q:((cbrecloc="")||(tmpRecInvCount=0))  d
	..s cbitmsub=""
	..f  s cbitmsub=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub)) q:(cbitmsub="")  d
	...s CBIitmnum=""
	...f  s CBIitmnum=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:(CBIitmnum="")  d
	....s rtn=0
	....;在当前票据下循环回执联
	....s tmpINVrec=""
	....f  s tmpINVrec=$o(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)) q:((tmpINVrec="")||(rtn))  d
	.....s INVRecLoc=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)
	.....s INVItem=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","ItemSub",tmpINVrec)
	.....s mytmpli=$g(^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub))
	.....i (((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub))||(mytmpli'="")) d
	......s rtn=1
	.....q:(rtn=1)			//rtn=1说明存在这个科目退回上个循环?
	....i (rtn=0)&&($d(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","RecLoc"))) d
	.....s INVRecNum=INVRecNum+1		;使科目加一?  同时增加临时科目
	.....s ^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub)=cbrecloc	;这个必需存在，否则不能判断
	.;验证当前票据能否放下
	.i (RecpFlag=0) d
	..i (INVRecNum<=tmpRecInvCount) s RecpFlag=1
	.i (PrintFlag=0) d
	..i (INVPNum<=tmpprintCount) s PrintFlag=1
	.i ($g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR"))="") d
	..s ^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR")=myCurAdmDR		;对于空发票先添加属性
	.s myINVAdmDR=$g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR"))
	.i (myCurAdmDR=myINVAdmDR) d
	..s myAdmFlag=1
	.;InvDR Lid 2011-12-13
	.i ($g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDR"))="") d
	..s ^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDR")=myCurInvDR
	.s myINVDR=$g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDR"))
	.i (myINVDR=myCurInvDR) d
	..s myInvFlag=1
	.;end
	.;InvDate Lid 2012-05-10
	.i ($g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDate"))="") d
	..s ^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDate")=myCurInvDate
	.s myINVDate=$g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"InvDate"))
	.i (myINVDate=myCurInvDate) d
	..s myInvDateFlag=1
	.;end
	.i ((PrintFlag=1)&&(RecpFlag=1)&&(myAdmFlag=1)&&(myInvFlag=1)&&(myInvDateFlag=1)) s CBIIviFlag=1
	
	i (CBIIviFlag=0) s CBICurIdx=$i(CBICurIdx)		  //没有合适票据,加一
	
	k ^TMPColPrt("TMPLI",$j)
	
	q CBICurIdx
	
BuildBillData(invIdx, tmpinstype, tmpPBordrid, tmpRecInvCount, tmpprintCount, tmpPrtRowID)
	//把医嘱装载在票据中
	n (invIdx, tmpinstype, tmpPBordrid, tmpRecInvCount, tmpprintCount, tmpPrtRowID)
	s $zt="ERROR^DHCSSERR"
	
	s myIdx=+$g(^TMPColPrt("BillINV",$j,tmpinstype))
	i (invIdx>myIdx) {
		d BuildBlankBill(tmpinstype)
	}
	s myIdx=invIdx
	
	s myPCount=$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PrintCount"))
	s myAdmDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",16)
	s myPresNo=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",10)
	s myInvDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",17)      ;Lid 2011-12-13 小条指针
	s myInvDateDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",18)  ;Lid 2012-05-10 发票打印日期
	
	i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"AdmDR"))="") d
	.s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"AdmDR")=myAdmDR
	
	i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PresNo"))="") d
	.s ^TMPColPrt("BillINV", $j,tmpinstype,myIdx,"PresNo")=myPresNo
	
	;Lid 2011-12-13 发票与小条对应关系
    i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"InvDR"))="") d
	.s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"InvDR")=myInvDR
	
	;Lid 2012-05-10 发票日期
    i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"InvDate"))="") d
	.s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"InvDate")=myInvDateDR
	
	;验证数据
	;加打印条数
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PrintCount")=myPCount+$g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,"ItmNum"))		;已经分配打印条数?
	;票据钱数?患者支付?
	s myordpay=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",15)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PatPaySum")=+myordpay+$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PatPaySum"))
	s mytopay=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",19)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"TotSum")=+mytopay+$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"TotSum"))
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PrtRowID",tmpPrtRowID)=tmpPrtRowID
	
	//新增
	s cbrecloc=""
	f  s cbrecloc=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc)) q:((cbrecloc="")||(tmpRecInvCount=0))  d
	.s cbitmsub=""
	.f  s cbitmsub=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub)) q:(cbitmsub="")  d
	..s CBIitmnum=""
	..f  s CBIitmnum=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:(CBIitmnum="")  d
	...s myItemSum=$p(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",13)
	...s rtn=0
	...;在当前票据下循环回执联
	...s tmpCurRecIdx=0
	...s tmpINVrec=""
	...f  s tmpINVrec=$o(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpINVrec)) q:(tmpINVrec="")  d
	....s tmpCurRecIdx=tmpINVrec
	....s INVRecLoc=^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpINVrec)
	....s INVItem=^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItemSub",tmpINVrec)
	....i ((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub)) d
	.....s rtn=1
	.....s mydepSum=$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpINVrec))
	.....s ^TMPColPrt("BillINV",$j, tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpINVrec)=mydepSum+myItemSum
	....q:(rtn=1)			//rtn=1说明存在这个科目退回上个循环?
	...i (rtn=0) d  		//增加科目
	....//写数据
	....s tmpCurRecIdx=$i(tmpCurRecIdx)		//使科目加一?
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount")=tmpCurRecIdx
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpCurRecIdx)=cbrecloc
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItemSub",tmpCurRecIdx)=cbitmsub
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpCurRecIdx)=myItemSum
	
	//票据结算数据
	s ordrid=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",2)
	//这里保存中途结算的需要参数?	票据数据;
	//节点:费别,账单RowID,医嘱RowID(OE_OrdItem)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"INT",tmpinstype,"BR",+tmpPBordrid,"ORD",tmpPBordrid)=^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)
	q 0
BuildHISPayMode()
	n (ad)
	//一张发票的不同支付模式
	s myInsType=0
	f  s myInsType=$o(^TMPColPrt("IP",$j,myInsType)) q:(myInsType="")  d
	.s myINVIdx=0
	.f  s myINVIdx=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s mySPrtRowID=0
	..f  s mySPrtRowID=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myRoundSum=+$p(^DHCINVPRT(mySPrtRowID),"^",37)
	...s ^TMPColPrt("IP",$j,myInsType,myINVIdx,"RoundSum")=$g(^TMPColPrt("IP",$j,myInsType,myINVIdx,"RoundSum"))+myRoundSum
	...s myIPMSub=0
	...f  s myIPMSub=$o(^DHCINVPRT(mySPrtRowID,"P",myIPMSub)) q:(myIPMSub="")  d
	....s myPMData=$g(^DHCINVPRT(mySPrtRowID,"P",myIPMSub))
	....s myPMDR=$p(myPMData,"^",1)
	....s myPMSum=$p(myPMData,"^",3)
	....s ^TMPColPrt("IP",$j,myInsType,myINVIdx,"HISPAY",myPMDR)=$g(^TMPColPrt("IP",$j,myInsType,myINVIdx,"HISPAY",myPMDR))+myPMSum
	
	q 0
BuildBlankBill(tmpinstype)
	n (tmpinstype)
	s ^TMPColPrt("BillINV",$j,tmpinstype)=$g(^TMPColPrt("BillINV",$j,tmpinstype))+1
	s bbIdx=$g(^TMPColPrt("BillINV",$j,tmpinstype))
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PrintCount")=0		;已经分配打印条数?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"RecInvCount")=0		;已经分配回执数量?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PatPaySum")=0		;票据中患者支付额	
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"TotSum")=0			;票据总额?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"RoundSum")=0		;分币误差额
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"AdmDR")=""
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PresNo")=""
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"InvDR")=""          ;发票与小条对应关系 Lid 2011-11-13 
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"InvDate")=""        ;按时间拆分 Lid 2012-05-10
	q bbIdx
}

/// 作废原发票
/// APayINVRowID  旧发票的RowID
/// w ##class(web.UDHCACINVColPrt).CancleAPayINV(APayINVRowID, sUser, sFlag, CardPaySum, CashSum, RefundSum, ParkInsDivDR)
ClassMethod CancleAPayINV(APayINVRowID As %String, sUser As %String, sFlag As %String, CashSum As %String) As %String
{
	new (APayINVRowID, sUser, sFlag, CashSum)
	set $zt="ERROR^DHCSSERR"
	
	kill PLIST, mPLIST
	
	set myrtn=##class(web.UDHCAccPayINV).SELECT(APayINVRowID)
	set rtn=$p(myrtn,"^")
	set papmi=PLIST(12)
	merge mPLIST=PLIST
	quit:(+rtn) rtn
	
	kill PLIST
	set PLIST(2)=-mPLIST(2)
	set PLIST(3)=sFlag
	set PLIST(4)=+$h
	set PLIST(5)=$p($h,",",2)
	set PLIST(6)=sUser
	set PLIST(11)=APayINVRowID
	set PLIST(12)=mPLIST(12)
	set PLIST(13)=mPLIST(13)
	set PLIST(14)=-mPLIST(14)
	set PLIST(15)=-mPLIST(15)
	set PLIST(16)=-mPLIST(16)
	set CardPaySum=mPLIST(17)
	set CardPaySum=CardPaySum-CashSum
	set PLIST(17)=-CardPaySum
	set PLIST(18)=-mPLIST(18)			//医保费用全部退完
	//退款额为负表示退款，退款额为正表示收款
	//如果退现金，则加上现金，否则是收回医保支付额
	set PLIST(19)=-$g(mPLIST(19))-CashSum				//API_RefundSum  退款额度(医保+直接退现金)
	set PLIST(22)=-CashSum
	set PLIST(24)=-mPLIST(24)							//API_OPCRoundSum
	set PLIST(26)=mPLIST(26)							//API_AutoYBFlag
	set PLIST(27)=$system.Process.ClientIPAddress()		//API_IPAddress
	set PLIST(30)=mPLIST(30)
	set PLIST(31)=mPLIST(31)                            //API_StayFlag
	set PLIST(32)=mPLIST(32)
	set PLIST(33)=mPLIST(33)                            //API_Group_DR
	set PLIST(34)="N"                                   //API_Handin
	set rtnValue=##class(web.UDHCAccPayINV).INSERT()
	set rtn=+$p(rtnValue,"^",1)
	quit:(+rtn) rtn_"^"_$g(%msg)
	set myRowID=PLIST(1)
	
	//2021-04-08 ZhYW 保存发票扩展表数据
	set payer=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set payerID=$p($g(^PAPER(papmi,"ALL")),"^",9)    //身份证号
	set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
	set dto.InvType="OS"
	set dto.InvDR=myRowID
	set dto.BatchNo=""
	set dto.InvNo=""
	set dto.PAPMIDR=papmi
	set dto.Payer=payer
	set dto.PayerIdentifier=payerID
	set dto.UserDR=sUser
	set dto.Reviewer=""
	set dto.InvoiceDR=""
	set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
	quit:(+rtn) rtn
	
	quit rtn_"^"_myRowID
}

/// w ##class(web.UDHCACINVColPrt).KillINVTMP("")
ClassMethod KillINVTMP(ID As %String) As %String
{
	n (ID)
	
	q:(ID="")
	k ^DHCTMPACCColPRT("IP",ID)
	
	q ""
}

/// w ##class(web.UDHCACINVColPrt).ParkAPayINV(AccPayInvId, sFlag)
ClassMethod ParkAPayINV(AccPayInvId As %String, sFlag As %String) As %String
{
	new (AccPayInvId, sFlag)
	&SQL(
		UPDATE DHC_AccPayINV
		SET API_Flag = :sFlag
		WHERE %ID = :AccPayInvId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

/// Lid
/// 2011-04-02
/// 判断是否为医保支付方式（建议定义支付方式Code时，有个规则）
/// 0:医保支付方式，1:非医保支付
/// w ##class(web.UDHCACINVColPrt).CheckYBPayMode(14)
ClassMethod CheckYBPayMode(payMDr)
{
	n (payMDr)
	s rtn=1
	s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	i ((payMCode="YBINSU")||(payMCode="BZCJINSU")) s rtn=0
	q rtn
}

}
