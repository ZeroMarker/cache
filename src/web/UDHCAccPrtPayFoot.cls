Import SQLUser

Class web.UDHCAccPrtPayFoot Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// APIRowID: 原发票RowID
/// sFlag=被拆分发票的作废模式S  A
/// PRTRowIDStr=PRTRowID11^PRTRowID12_$c(2)_PRTRowID21^PRTRowID22
/// 对于卡支付的发票进行拆分函数
/// 界面显示：发票号码+发票号码下面的收费小条
/// 1.作废原发票
/// 2.把原来的发票按照规律分别结成不同的发票，1拆分成多
///   2.1调用多个的分发票参数
/// Debug: w ##class(web.UDHCAccPrtPayFoot).APayColINVSplit("969",23332,"S","5700"_$c(2)_"5905","")
ClassMethod APayColINVSplit(APIRowID As %String, UserDR As %String, sFlag As %String, PRTRowIDStr As %String, ExpStr As %String) As %String
{
	new (APIRowID, UserDR, sFlag, PRTRowIDStr, ExpStr)
	
	set rtn=0

	set $zt="ERROR^DHCSSERR"
	ts
	
	set myAPIStr=""
	set PAPMIDR=$p(^DHCINVPRTAP(APIRowID),"^",11)			;PAPMI_DR
	set AccMDR=$p(^DHCINVPRTAP(APIRowID),"^",12)			;AccM_DR
	
	set myNPRTRStr=""
	set mylen=$l(PRTRowIDStr,$c(2))
	for i=1:1:mylen {
		set myNPRTRStr=myNPRTRStr_"^"_$p(PRTRowIDStr,$c(2),i)
	}
	
	set rtnValue=##class(web.UDHCAccPrtPayFoot).CancleAPayINV(APIRowID, UserDR, sFlag, "", myNPRTRStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	//Split AccPayINV
	set mylen=$l(PRTRowIDStr,$c(2))
	for i=1:1:mylen {
		set myPRTStr=$p(PRTRowIDStr,$c(2),i)
		continue:(myPRTStr="")
		set myTMPGID=$i(^DHCTMPACCColPRT)
		do ##class(web.UDHCACINVColPrt).KillINVTMP(myTMPGID)
		set myParExpStr=""
		set myAPIINVInfo=##class(web.UDHCAccPrtPayFoot).ParPrtToAPINV(myPRTStr, myTMPGID, myParExpStr)
		set rtn=$p(myAPIINVInfo,$c(2),1)
		do ##class(web.UDHCACINVColPrt).KillINVTMP(myTMPGID)
		quit:(+rtn)
		set myAPIINVInfo=$p(myAPIINVInfo,$c(2),2)
		//一个循环的发票算法
		set myINVPExpStr=""
		set rtnValue=##class(web.UDHCAccPrtPayFoot).AccINVPayInsert(myAPIINVInfo, UserDR, AccMDR, PAPMIDR, myINVPExpStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myAPIStr=myAPIStr_"^"_$p(rtnValue,"^",2)
	}
	if (+rtn)  tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn_$c(2)_myAPIStr
}

/// 1.获取发票信息;循环获取发票信息
/// 功能?统一打印中的结算信息显示汇总
/// 打印中的数据更新
/// w ##class(web.UDHCAccPrtPayFoot).APayColPrtUpdate("27.84^1^28^27.84^^0"_$c(3)_"^256"_$c(3)_"3^27.84"_$c(3)_"0^27.84^0.00^0"_$c(3)_"27.84^0^0^0"_$c(3)_"28"_$c(3)_"1^0","7","75","118","238^119^2^^^0")
ClassMethod APayColPrtUpdate(APINVInfo As %String, UserDR As %String, AccMDR As %String, PAPMIDR As %String, ExpStr As %String) As %String
{
	new (APINVInfo, UserDR, AccMDR, PAPMIDR, ExpStr)
	
	set ^TMP("APayColPrtUpdate")=$lb(APINVInfo, UserDR, AccMDR, PAPMIDR, ExpStr)

	set $zt="ERROR^DHCSSERR"
	
	set rtn=0
	
	ts
	
	set rtnValue=..AccINVPayInsert(APINVInfo, UserDR, AccMDR, PAPMIDR, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	if ($tl>0) tc
	
	quit rtnValue
}

/// APINVInfo的格式：Amt_^_费别_^_$j^_$c(3)_PrtRowID1^PrtRowID2^PrtRowID3^PrtRowID4_$c(2)_
/// _$c(3)_医保支付方式_$c(3)_医保支付额_退款额
/// 发票1_$c(2)_发票2_$c(2)
/// 医保支付额_个人自付额_退款额_现金支付额  保存在DHC_AccPayINV表中
/// 医保支付方式=方式1^12_$c(4)_方式2^12_$c(4)_方式3^12
/// 医保支付方式=APM_PayMode_DR_"^"_APM_Amt
ClassMethod AccINVPayInsert(APINVInfo As %String, UserDR As %String, AccMDR As %String, PAPMIDR As %String, ExpStr As %String = "") As %String
{
	new (APINVInfo, UserDR, AccMDR, PAPMIDR, ExpStr)
	
	set $zt="ERROR^DHCSSERR"
	
	set myAPIRStr=""
	
	set myCTLocDR=$p(ExpStr,"^",1)
	set myGroupDR=$p(ExpStr,"^",2)
	//set myHospDR=$p(ExpStr,"^",3)
	set myOldAPIRowID=$p(ExpStr,"^",4)
	set StayInvFlag=$p(ExpStr,"^",5)   //+2020-06-24 ZhYW 急诊留观标识
	set AutoYBFlag=$p(ExpStr,"^",6)    //+2014-12-05 hujunbin
	set NewInsType=$p(ExpStr,"^",7)    //+2019-05-10 ZhYW
	
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLocDR)
	set myFairType="F"
	set myRecpExp=myFairType_"^"_""_"^"_myHospDR
	set myReceipStr=##class(web.udhcOPBillIF).ReadReceiptNO(UserDR, "", myRecpExp)     //这里不传安全组， 取收费发票号
	set rtn=$p(myReceipStr,"^",1)
	quit:(+rtn) rtn_"^"_"没有可用发票，请先领取"
	
	set mylen=$l(APINVInfo,$c(2))
	for i=1:1:mylen  {
		set mySAPInfo=$p(APINVInfo,$c(2),i)
		continue:(mySAPInfo="")
		set myAInfo=$p(mySAPInfo,$c(3),1)
		set myPatientShare=$p(myAInfo,"^",1)			//患者支付额
		set myInsTypeDR=$p(myAInfo,"^",2)
		if (+NewInsType'=0) {        //+2019-05-10 ZhYW
			set myInsTypeDR=NewInsType
		}
		set myAmt=$p(myAInfo,"^",4)					//费用总额
		set myInsDivDR=$p(myAInfo,"^",5)
		set myRoundSum=+$p(myAInfo,"^",6)			//舍入额
		set myPRTRowIDStr=$p(mySAPInfo,$c(3),2)
		set myDiscAmount=0
		set myPayorShare=0
		//根据小条表rowid取折扣金额、记账金额
		set prtlen=$l(myPRTRowIDStr,"^")
		for k=1:1:prtlen {
			set myPrtRowId=$p(myPRTRowIDStr,"^",k)
			continue:(myPrtRowId="")
			set myPrtData=$g(^DHCINVPRT(myPrtRowId))
			set myPrtDiscAmt=+$p(myPrtData,"^",7)
			set myPrtPayorAmt=+$p(myPrtData,"^",18)
			set myDiscAmount=$i(myDiscAmount, myPrtDiscAmt)
			set myPayorShare=$i(myPayorShare, myPrtPayorAmt)
			if (PAPMIDR="") {
				set PAPMIDR=+$p(myPrtData,"^",15)
			}
		}
		set myAModeInfo=$p(mySAPInfo,$c(3),3)
		set myYBPayInfo=$p(mySAPInfo,$c(3),4)
		set mySelfYBPay=$p(myYBPayInfo,"^",1)
		set mySelfPatPay=$p(myYBPayInfo,"^",2)
		set myRefundSum=$p(myYBPayInfo,"^",3)
		//
		set $p(myRecpExp,"^",2)=myInsTypeDR
		set myReceipStr=##class(web.udhcOPBillIF).ReadReceiptNO(UserDR, "", myRecpExp)    //这里不传安全组， 取收费发票号
		set rtn=$p(myReceipStr,"^",1)
		quit:(+rtn)
		set ReceipNO=$p(myReceipStr,"^",2)
		set ReceiptId=$p(myReceipStr,"^",3)
		set ReceipTitle=$p(myReceipStr,"^",5)
		set ReceipNew=+ReceipNO+1
		set rtn=##class(web.udhcOPBill).UpdateReceipNO(UserDR, ReceipNew, "", myFairType, myInsTypeDR, myHospDR)
		quit:(+rtn)
		set $p(myAccPINfo,"^",1)=myAmt
		set $p(myAccPINfo,"^",2)="N"
		set $p(myAccPINfo,"^",3)=UserDR
		set $p(myAccPINfo,"^",4)=ReceipTitle_ReceipNO
		set $p(myAccPINfo,"^",5)=PAPMIDR
		set $p(myAccPINfo,"^",6)=AccMDR
		//set myPAPMIDR=$p(^DHCACD("AccM",AccMDR),"^",2)
		//set $p(myAccPINfo,"^",5)=myPAPMIDR
		set $p(myAccPINfo,"^",7)=myPatientShare
		set $p(myAccPINfo,"^",8)=myDiscAmount
		set $p(myAccPINfo,"^",9)=myPayorShare
		set $p(myAccPINfo,"^",10)=mySelfPatPay
		set $p(myAccPINfo,"^",11)=mySelfYBPay
		set $p(myAccPINfo,"^",12)=myRefundSum
		set $p(myAccPINfo,"^",13)=myInsDivDR
		set $p(myAccPINfo,"^",14)=myOldAPIRowID
		set $p(myAccPINfo,"^",15)=myRoundSum
		set $p(myAccPINfo,"^",16)=myInsTypeDR
		set $p(myAccPINfo,"^",17)=myHospDR
		set $p(myAccPINfo,"^",18)=myGroupDR
		set $p(myAccPINfo,"^",26)=AutoYBFlag
		set $p(myAccPINfo,"^",27)=StayInvFlag
		set rtnValue=##class(web.UDHCACINVColPrt).InsertAPayINV(myAccPINfo)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myAPIRowID=$p(rtnValue,"^",2)
		set myAPIRStr=$s((myAPIRStr=""):myAPIRowID,1:(myAPIRStr_"^"_myAPIRowID))
		//2021-04-08 ZhYW 保存发票扩展表数据
		set payer=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		set payerID=$p($g(^PAPER(PAPMIDR,"ALL")),"^",9)    //身份证号
		set dto=##class(BILL.INV.DTO.Entity.PrtExt).%New()
		set dto.InvType="OS"
		set dto.InvDR=myAPIRowID
		set dto.BatchNo=ReceipTitle
		set dto.InvNo=ReceipNO
		set dto.PAPMIDR=PAPMIDR
		set dto.Payer=payer
		set dto.PayerIdentifier=payerID
		set dto.UserDR=UserDR
		set dto.Reviewer=""
		set dto.InvoiceDR=ReceiptId
		set rtn=##class(BILL.INV.BL.PrtExt).Save(dto)
		quit:(+rtn)
		//写卡支付发票支付方式
		set invExpStr=AutoYBFlag_"^"_myHospDR
		set rtn=##class(web.UDHCACINVColPrt).InsertAPayINVMode(myAModeInfo, myAPIRowID, invExpStr)
		quit:(+rtn)
		//更新DHC_INVPRT表
		set rtn=##class(web.UDHCINVPRT).UpdatePrtFlag(myPRTRowIDStr, myAPIRowID)
		quit:(+rtn)
		//写入DHC_AccPINVCONPrt表,写入连接表
		set prtlen=$l(myPRTRowIDStr,"^")
		for j=1:1:prtlen {
			set myPrtRowId=$p(myPRTRowIDStr,"^",j)
			continue:(myPrtRowId="")
			set myConStr=myPrtRowId_"^"_myAPIRowID
			set rtn=##class(web.UDHCACINVColPrt).InsertAINVConPrt(myConStr)
			quit:(+rtn)
		}
	}
	quit:(+rtn) rtn
	
	quit rtn_"^"_myAPIRStr
}

/// modify hujunbin 14.12.5 添加ExpStr扩展参数
/// TFRIDSTR=参与退费的小票RowID=PRTRowID1^PRTRowID2^PRTRowID3
/// NPRTRStr=不参与退费的RowID=PRTRowID1^PRTRowID2^PRTRowID3
/// w ##class(web.UDHCAccPrtPayFoot).CancleAPayINV(APIRowID, rUser, sFlag, CashSum, TFRIDSTR, NPRTRStr)
ClassMethod CancleAPayINV(APIRowID As %String, rUser As %String, sFlag As %String, TFRIDSTR As %String, NPRTRStr As %String, ExpStr As %String = "") As %String
{
	n (APIRowID, rUser, sFlag, TFRIDSTR, NPRTRStr, ExpStr)
	//写原发票的废票，同时标注原发票作废
	s $zt="ERROR^DHCSSERR"
	
	s rtn=0
	s AutoFlag=$p(ExpStr,"^",6)

	k ^TMPCAPI($j)
	
	//当前的票据对应的帐户无效时，应该退返到帐户的钱，直接返钱放在退费字段中
	s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	s myCardPMDR=$o(^CT("CTPM",0,"Code","CPP",0))
	
	s CashSum=0
	
	//参与退费的小票RowID
	s mylen=$l(TFRIDSTR,"^")
	f i=1:1:mylen  d
	.s myPRTRowID=$p(TFRIDSTR,"^",i)
	.q:(myPRTRowID="")
	.s myParkRID=$o(^DHCINVPRT(0,"InitInvDR",myPRTRowID,0))
	.s rtnValue=##class(web.UDHCINVPRT).ReadINVPMStr(myParkRID)
	.s myPMDR=+$p(rtnValue,"^",1)			//这里是负账
	.s myPMSum=+$p(rtnValue,"^",2)
	.s ^TMPCAPI($j,myPMDR)=+$g(^TMPCAPI($j,myPMDR))+myPMSum
	.i (myCashPMDR=+myPMDR) d
	..s CashSum=$i(CashSum, $zabs(myPMSum))
	
	//不参与退费的RowID
	s mylen=$l(NPRTRStr,"^")
	f i=1:1:mylen  d
	.s myPRTRowID=$p(NPRTRStr,"^",i)
	.q:(myPRTRowID="")
	.s rtnValue=##class(web.UDHCINVPRT).ReadINVPMStr(myPRTRowID)
	.s myPMDR=+$p(rtnValue,"^",1)
	.s myPMSum=+$p(rtnValue,"^",2)
	.s ^TMPCAPI($j,myPMDR)=+$g(^TMPCAPI($j,myPMDR))-myPMSum

	//作废原发票
	i (+rtn=0) d
	.s rtnValue=##class(web.UDHCACINVColPrt).ParkAPayINV(APIRowID, sFlag)
	.s rtn=+rtnValue
	q:(+rtn) rtn
	
	//插入负票
	s rtnValue=##class(web.UDHCACINVColPrt).CancleAPayINV(APIRowID, rUser, sFlag, CashSum)
	s rtn=$p(rtnValue,"^",1)
	q:(+rtn) rtn
	s myPAPIRowID=$p(rtnValue,"^",2)
	//写连接表
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,myACPRowID)) q:((myACPRowID="")||(+rtn))  d
	.s myPrtRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",1)
	.s myConStr=myPrtRowID_"^"_myPAPIRowID
	.s rtn=##class(web.UDHCACINVColPrt).InsertAINVConPrt(myConStr)
	q:(+rtn) rtn
	
	//如果有医保支付模式，可能需要修改；  有Bug
	//Update by zhl 090728
	s myAModeInfo=""
	s APSub=0
	f  s APSub=$o(^DHCINVPRTAP(APIRowID,"P",APSub))  q:(APSub="")  d
	.s APPMData=$g(^DHCINVPRTAP(APIRowID,"P",APSub))
	.s PayMDR=$p(APPMData,"^",1)
	.s PayMSum=$p(APPMData,"^",3)
	.s PayMSum=-PayMSum    //将金额更新为负,以收回
	.s myAModeInfo=myAModeInfo_PayMDR_"^"_PayMSum_$c(4)
	//modify hujunbin 14.12.5添加ExpStr
	s AutoYBFlag=$p(^DHCINVPRTAP(APIRowID),"^",25)
	s myHospDR=$p(^DHCINVPRTAP(APIRowID),"^",30)
	s invExpStr=AutoYBFlag_"^"_myHospDR
	i (myAModeInfo'="")&&(myPAPIRowID'="") s rtn=##class(web.UDHCACINVColPrt).InsertAPayINVMode(myAModeInfo, myPAPIRowID, invExpStr)

	k ^TMPCAPI($j)
	
	q rtn
}

/// INVPrtStr:传入DHC_INVPRT 表的RowID   =RowID1^RowID2^RowID3
/// TMPGID:  = $i(^DHCTMPACCColPRT)
/// 退费过程中，生成解析的Global
/// 这个临时的唯一ID被传入
/// w ##class(web.UDHCAccPrtPayFoot).ParPrtToAPINV("1928^1929","120","")
ClassMethod ParPrtToAPINV(INVPrtStr As %String, TMPGID As %String, ExpStr As %String) As %String
{
	n (INVPrtStr, TMPGID, ExpStr)
	s $zt="ERROR^DHCSSERR"
	
	d ##class(web.UDHCACINVColPrt).KTMP()
	
	//取出基本配置?
	s CTLoc=$p(ExpStr,"^",1)
	s Group=$p(ExpStr,"^",2)
	s stayInvFlag=$p(ExpStr,"^",5)
	s AutoYBFlag=$p(ExpStr,"^",6)
	
	s myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLoc)
	s myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(Group, myHospDR)
	s rtn=$p(myBCInfo,"^")
	q:(+rtn) 104_$c(2)
	
	s itemFlag=$p(myBCInfo,"^",5)		;1			;;这个一定设置为1   不能改变?
	s reclocFlag=$p(myBCInfo,"^",6)		;1
	s PresNoFlag=$p(myBCInfo,"^",7)		;1
	s RecInvCount=$p(myBCInfo,"^",8)	;0
	s printCount=$p(myBCInfo,"^",9)		;21
	s OnToManyFlag=$p(myBCInfo,"^",32)
	s RegInvFlag=$p(myBCInfo,"^",33)
	i ((stayInvFlag="Y")||(AutoYBFlag=1)) set OnToManyFlag=1   //急诊留观和医保已结算的1:1
	s rtnValue=##class(web.UDHCACINVColPrt).GetAccPayINVDataByPRTStr(INVPrtStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag)	
	s rtn=$p(rtnValue,"^")
	q:(+rtn) +rtn
	
	s rtn=##class(web.UDHCACINVColPrt).ParDataToABill(RecInvCount, printCount, TMPGID)
	q:(+rtn) +rtn
	
	s myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		    //卡支付DR
	s myYBAccPayDR=$o(^CT("CTPM",0,"Code","INSUZHZF",0))	//医保卡支付DR
	s myYBTCPayDR=$o(^CT("CTPM",0,"Code","YBINSU",0))		//医保统筹支付DR
	s myYBDBPayDR=$o(^CT("CTPM",0,"Code","YBDBPAY",0))		//医保大病支付DR

	s myvIdx=0
	s myFlag=0
	s myINVPrtValue=""
	s myInsType=0
	f  s myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) q:((myInsType="")||(+myFlag'=0))  d
	.s myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.s myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.s myINVIdx=0
	.s myINVPrtInfo=""
	.s myINVPrtDesc=""
	.f  s myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myvIdx=$i(myvIdx)
	..s myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..s myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..s myTolSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"TotSum"))
	..s myAPMInfo=""
	..s myCashPaySum=0
	..s myCardPaySum=0
	..s myYBAccPaySum=0
	..s myYBTCPaySum=0
	..s myYBDBPaySum=0
	..s myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
	..i $d(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY")) d
	...//start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	...s myPrtStr="", singleCardPayDR=""
	...s mySPrtRowID=0
	...f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	....s myPrtStr=myPrtStr_"^"_mySPrtRowID
	....i ((singleCardPayDR="")&&(mySPrtRowID'=""))  d
	.....//2020-06-22 ZhYW 改为取自费的支付方式
	.....s singleCardPayDR=##class(web.UDHCAccPrtPayFoot).GetFstSelfPaymId(mySPrtRowID)
	.....s myCardPayDR=singleCardPayDR
	...//end
	...s myPMStr=myCardPayDR_"^"_myYBAccPayDR_"^"_myYBTCPayDR_"^"_myYBDBPayDR
	...;HIS支付节点
	...;s myCardPaySum=$fn(+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatShare")),"",2)
	...s myPMDR=""
	...f  s myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY",myPMDR)) q:(myPMDR="")  d
	....s myHISPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY",myPMDR))
	....s myAPMInfo=myAPMInfo_myPMDR_"^"_myHISPay_$c(4)
	....i (myPMDR=myCardPayDR) d
	.....s myCardPaySum=$fn(myHISPay,"",2)
	....i (myPMDR=myYBAccPayDR) d
	.....s myYBAccPaySum=$fn(myHISPay,"",2)
	....i (myPMDR=myYBTCPayDR) d
	.....s myYBTCPaySum=$fn(myHISPay,"",2)
	....i (myPMDR=myYBDBPayDR) d
	.....s myYBDBPaySum=$fn(myHISPay,"",2)
	....i (myPMStr'[myPMDR) d
	.....s myCashPaySum=myCashPaySum+$fn(myHISPay,"",2)
	..e  d
	...//不存在医保节点
	...s myPrtStr="", singleCardPayDR=""
	...s mySPrtRowID=0
	...f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	....s myPrtStr=myPrtStr_"^"_mySPrtRowID
	....i ((singleCardPayDR="")&&(mySPrtRowID'=""))  d
	.....//2020-06-22 ZhYW 改为取自费的支付方式
	.....s singleCardPayDR=##class(web.UDHCAccPrtPayFoot).GetFstSelfPaymId(mySPrtRowID)
	.....s myCardPayDR=singleCardPayDR
	...s myPMDR=myCardPayDR
	...s myCardPaySum=$fn((myCurSum+myRoundSum),"",2)
	...s myAPMInfo=myPMDR_"^"_myCardPaySum
	..s myINVPrtInfo=myInsType_" "_myInsDesc_" 第"_myvIdx_"张发票金额: "_$fn((myCurSum+myRoundSum),"",2)
	..s myINVPrtDesc=myINVPrtInfo
	..s myYBSum=myYBAccPaySum+myYBTCPaySum+myYBDBPaySum
	..s myTmpSum=myCardPaySum+myYBSum
	..i (+myTmpSum'=+myCurSum) d
	...s myFlag=1
	..s myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^"_myTolSum_"^"_myIDRowID_"^"_myRoundSum
	..s myINVPrtValue=myINVPrtValue_$c(3)_myPrtStr
	..s myINVPrtValue=myINVPrtValue_$c(3)_myAPMInfo	        ;为DHC_AccPayINVMode提供支付信息加医保留出空间
	..s myYBSum=$fn(myYBSum,"",2)
	..s myPersonSum=$fn(myCardPaySum,"",2)
	..s myRefSum=$fn(+myYBSum,"",2)
	..s myCashSum=$fn(myCashPaySum,"",2)					;现金支付方式
	..s myINVPrtValue=myINVPrtValue_$c(3)_myYBSum_"^"_myPersonSum_"^"_myRefSum_"^"_myCashSum			;为DHC_AccPay医保字段，和返钱字段   医保支付额_个人自付额_退款额
	..s myINVPrtValue=myINVPrtValue_$c(3)_myCardPaySum_"^"_myYBAccPaySum_"^"_myYBTCPaySum_"^"_myYBDBPaySum		;分解的明细值
	..s myINVPrtValue=myINVPrtValue_$c(3)_TMPGID			;返回进程ID
	..s myINVPrtInfo=myINVPrtInfo_$c(2)_myPrtStr		    ;发票信息
	
	d ##class(web.UDHCACINVColPrt).KTMP()
	
	i (myvIdx=0) d
	.s rtn="108"_$c(2)_""
	
	q +rtn_$c(2)_myINVPrtValue
}

/// 账户中没有打印发票的正单集合打印发票
/// 用于账户结算打印发票
/// w ##class(web.UDHCAccPrtPayFoot).BuildAccINVPay("864","10033","100")
ClassMethod BuildAccINVPay(AccRowID As %String, UserDR As %String, TMPGID As %String, ExpStr As %String) As %String
{
	n (AccRowID, UserDR, TMPGID, ExpStr)
		
	s $zt="ERROR^DHCSSERR"
	
	d ##class(web.UDHCACINVColPrt).KTMP()
	d ##class(web.UDHCACINVColPrt).KillINVTMP(TMPGID)
	
	s CTLocDR=$p(ExpStr,"^",1)
	s Group=$p(ExpStr,"^",2)

	q:('$d(^DHCACD("AccM",AccRowID))) 107
	
	s myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	
	//+2017-06-27 ZhYW 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	s APISavePRTInsDivFlag=##class(web.DHCBillParamConfig).%GetParameter("APISavePRTInsDivFlag")
	s AutoFlag=0
	
	s myPLRIDStr=""
	s mySub=0
	f  s mySub=$o(^DHCACD("AccM",AccRowID,"AccPL",mySub)) q:(mySub="")  d
	.s myPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",mySub))
	.q:(myPLData="")
	.s myPLRowID=AccRowID_"||"_mySub
	.s myBusiType=$p(myPLData,"^",11)
	.q:(myBusiType'="OP")
	.s myPLHospDR=$p(myPLData,"^",16)
	.q:(myHospDR'=myPLHospDR)
	.s myPRTRowID=$p(myPLData,"^",2)
	.s myINVFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",8)
	.q:(myINVFlag'="N")										    //只打印正常的发票集合
	.s myINVPrtFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",3)		//发票的打印标志
	.q:(myINVPrtFlag'="N")
	.//+2017-06-27
	.s insuDivDR=$p($g(^DHCINVPRT(myPRTRowID)),"^",30)
	.i (insuDivDR'="") s AutoFlag=1
	.s myPLRIDStr=myPLRIDStr_"^"_myPLRowID

	//获取基本配置
	s myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(Group, myHospDR)
	s rtn=$p(myBCInfo,"^")
	q:(+rtn) 104_$c(2)
	
	s itemFlag=$p(myBCInfo,"^",5)		        ;1		;这个一定设置为1   不能改变?
	s reclocFlag=$p(myBCInfo,"^",6)		        ;1
	s PresNoFlag=$p(myBCInfo,"^",7)		        ;1
	s RecInvCount=$p(myBCInfo,"^",8)			;0
	s printCount=$p(myBCInfo,"^",9)				;21
	s OnToManyFlag=$p(myBCInfo,"^",32)
	s RegInvFlag=$p(myBCInfo,"^",33)
	
	//+2017-06-27 ZhYW 
	i (AutoFlag=1) s OnToManyFlag=1

	s rtnValue=##class(web.UDHCACINVColPrt).GetAccPayINVData(myPLRIDStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag)
	s rtn=$p(rtnValue,"^")
	q:(+rtn) +rtn
	
	s rtn=##class(web.UDHCACINVColPrt).ParDataToABill(RecInvCount, printCount, TMPGID)
	q:(+rtn) +rtn
	
	//把生成的发票信息写到表中同时，更新DHC_INVPRT表
	s myINVPrtInfo=""
	s myInsType=0
	f  s myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) q:(myInsType="")  d
	.s myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.s myINVIdx=0
	.f  s myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..s myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..s myTolSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"TotSum"))
	..//s myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
	..s myAPMInfo=..GetFootPMInfo(TMPGID, myInsType, myINVIdx)
	..s myPrtStr=""
	..s mySPrtRowID=0
	..f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myPrtStr=myPrtStr_"^"_mySPrtRowID
	...//+2017-06-27 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	...i (APISavePRTInsDivFlag=1) d
	....s insuDivDR=$o(^DHCINDIV("0","DHCInvPrt",mySPrtRowID,0))
	....i (insuDivDR'="") s ^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",insuDivDR)=""
    ..s myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
    ..//
	..s myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^"_myTolSum_"^"_myIDRowID_"^"_myRoundSum_$c(3)_myPrtStr		;一张发票的信息
	..s myINVPrtValue=myINVPrtValue_$c(3)_myAPMInfo
	..//myYBSum_"^"_myPersonSum_"^"_myRefSum_"^"_myCashSum   为DHC_AccPay医保字段，和返钱字段   医保支付额_个人自付额_退款额 
	..s myINVPrtValue=myINVPrtValue_$c(3)_"0^"_myCurSum_"^0^0^"
	..i (myINVPrtInfo="") d
	...s myINVPrtInfo=myINVPrtValue
	..e  d
	...s myINVPrtInfo=myINVPrtInfo_$c(2)_myINVPrtValue		;发票信息
	
	//生成Global
	s PAPMIDR=""
	s myExpStr=$p(ExpStr,"^",1)_"^"_$p(ExpStr,"^",2)_"^^^^1"   //账户结算集中打印发票不进行医保分解,故不往账户返钱
	s APINVInfo=myINVPrtInfo
	s myAPrtRStr=""
	i (APINVInfo'="") d
	.s rtnValue=..AccINVPayInsert(APINVInfo, UserDR, AccRowID, PAPMIDR, myExpStr)
	.s rtn=$p(rtnValue,"^")
	.s mylen=$l(rtnValue,"^")
	.f i=2:1:mylen d
	..s $p(myAPrtRStr,"^",i-1)=$p(rtnValue,"^",i)
	
	//发票生成完毕
	d ##class(web.UDHCACINVColPrt).KTMP()
	d ##class(web.UDHCACINVColPrt).KillINVTMP(TMPGID)
	
	q +rtn_"^"_myAPrtRStr
}

/// 收费过程中用此函数
/// 生成一个唯一的ID值
/// w ##class(web.UDHCAccPrtPayFoot).ParPrtToINV("DHCWeb_AddToList","INVInfo","234241^","238^122^5^2^^0")
ClassMethod ParPrtToINV(itmjs As %String = "", itmjsex As %String = "", INVPrtStr As %String, ExpStr As %String = "") As %String
{
	n (itmjs, itmjsex, INVPrtStr, ExpStr)

	s ^TMP("ParPrtToINV")=$lb(itmjs, itmjsex, INVPrtStr, ExpStr)
	
	s Group=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",4)
	s AutoYBFlag=$p(ExpStr,"^",6)  ;add hujunbin 2014.12.05
	
	d ##class(web.UDHCACINVColPrt).KTMP()
	
	s TMPGID=$i(^DHCTMPACCColPRT)
	
	//+2017-06-27 ZhYW 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	s APISavePRTInsDivFlag=##class(web.DHCBillParamConfig).%GetParameter("APISavePRTInsDivFlag")

	;获取基本配置
	s myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(Group, HospDR)
	s rtn=$p(myBCInfo,"^")
	q:rtn 104_$c(2)

	s itemFlag=$p(myBCInfo,"^",5)		;1			;这个一定设置为1   不能改变?
	s reclocFlag=$p(myBCInfo,"^",6)		;1
	s PresNoFlag=$p(myBCInfo,"^",7)		;1
	s RecInvCount=$p(myBCInfo,"^",8)	    ;0
	s printCount=$p(myBCInfo,"^",9)				;21
	s OnToManyFlag=$p(myBCInfo,"^",32)
	s RegInvFlag=$p(myBCInfo,"^",33)
	s InvDateFlag=$p(myBCInfo,"^",34)
	i (+AutoYBFlag=1) s OnToManyFlag=1   //wangjian 2017-04-12
	s rtnValue=##class(web.UDHCACINVColPrt).GetAccPayINVData(INVPrtStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	s rtn=$p(rtnValue,"^")
	q:(+rtn) +rtn
	
	s rtn=##class(web.UDHCACINVColPrt).ParDataToABill(RecInvCount, printCount, TMPGID)
	q:(+rtn) +rtn
	
	//利用帐户RowID把进程替换掉
	
	//利用JS传出数据
	//中间用$c(2)分开
	//一张发票一张发票的传出
	
	s myvIdx=0
	
	s myInsType=0
	f  s myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) q:(myInsType="")  d
	.s myAdmSource=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.s myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.s myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.s myINVPrtInfo=""
	.s myINVPrtDesc=""
	.s myINVIdx=0
	.f  s myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myvIdx=$i(myvIdx)
	..s myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		//卡支付DR
	..s myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..s myCurSum=$fn(myCurSum,"",2)
	..s myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..s myRoundSum=$fn(myRoundSum,"",2)
	..s mySPrtRowID=0
	..//start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	..s myPrtStr="", singleCardPayDR=""
	..f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myPrtStr=myPrtStr_"^"_mySPrtRowID
	...i ((singleCardPayDR="")&&(mySPrtRowID'=""))  d
	....s singleCardPayDR=##class(web.UDHCAccPrtPayFoot).GetFstSelfPaymId(mySPrtRowID)
	....s myCardPayDR=singleCardPayDR
	...//add hujunbin 2014-12-05
    ...i (AutoYBFlag=1) d
    ....//+2017-06-27 ZhYW 门诊收费医保实时结算时,DHC_AccPayINV是否保存小条表医保结算信息走配置
    ....i (APISavePRTInsDivFlag=1) d
    .....s insuDivDR=$o(^DHCINDIV("0","DHCInvPrt",mySPrtRowID,0))
    .....i (insuDivDR'="") s ^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",insuDivDR)=""
    ....m ^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM")=^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY")
	..//end
	..s myINVPrtInfo=myInsType_" "_myInsDesc_" 第"_myvIdx_"张发票金额: "_$fn((myCurSum+myRoundSum),"",2)
	..s myINVPrtDesc=myINVPrtInfo
	..s myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^^^"_myRoundSum
	..s myINVPrtValue=myINVPrtValue_$c(3)_myPrtStr
	..s myINVPrtValue=myINVPrtValue_$c(3)_myCardPayDR_"^"_$fn((myCurSum+myRoundSum),"",2)	;为DHC_AccPayINVMode提供支付信息加医保留出空间
	..s myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^^^"		;为DHC_AccPay医保字段, 和返钱字段
	..s myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^"		;分解的明细值
	..s myINVPrtValue=myINVPrtValue_$c(3)_TMPGID		;返回进程ID
	..s myINVPrtValue=myINVPrtValue_$c(3)_myInsType_"^"_myAdmSource				;返回收费类别的类型
	..s myINVPrtInfo=myINVPrtInfo_$c(2)_myPrtStr		;发票信息
	..s retval=itmjs_"('"_$zcvt(itmjsex,"O","JS")_"','"_$zcvt(myINVPrtDesc,"O","JS")_"','"
	..s retval=retval_$zcvt(myINVPrtValue,"O","JS")_"','"
	..s retval=retval_$zcvt(+myvIdx-1,"O","JS")_"');"
	..&javascript<#(retval)#>
	
	;屏蔽删除Global
	//d ##class(web.UDHCACINVColPrt).KTMP()
	if (myvIdx=0) d
	.s rtn=108
	
	q +rtn
}

/// 调用医保接口后，重新获取的发票信息的函数
/// 在前一步拆解完医保后，调用的接口
/// modify hujunbin 添加扩展串
/// w ##class(web.UDHCAccPrtPayFoot).ReadAccPayYBInfo("", "", "2303", "^^^^^1")
ClassMethod ReadAccPayYBInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", TMPGID As %Library.String, ExpStr As %String = "") As %String
{
	n (itmjs, itmjsex, TMPGID, ExpStr)
	
	s $zt="ERROR^DHCSSERR"
	s ^TMP("ReadAccPayYBInfo")=$lb(itmjs, itmjsex, TMPGID, ExpStr)
	
	s AutoYBFlag=$p($g(ExpStr),"^",6)  //hujunbin 2014-12-05

	//+2017-06-27 ZhYW 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	s APISavePRTInsDivFlag=##class(web.DHCBillParamConfig).%GetParameter("APISavePRTInsDivFlag")
	
	s myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		    //卡支付DR
	s myYBAccPayDR=$o(^CT("CTPM",0,"Code","INSUZHZF",0))	//医保卡支付DR
	s myYBTCPayDR=$o(^CT("CTPM",0,"Code","YBINSU",0))		//医保统筹支付DR
	s myYBDBPayDR=$o(^CT("CTPM",0,"Code","BZCJINSU",0))	    //医保大病支付DR(病种差价)

	s myTmpSum=0
	
	s myFlag=0
	s myvIdx=0
	s myInsType=0
	f  s myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) q:((myInsType="")||(+myFlag'=0))  d
	.s myAdmSource=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.s myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.s myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.s myINVIdx=0
	.s myINVPrtInfo=""
	.s myINVPrtDesc=""
	.f  s myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myvIdx=$i(myvIdx)
	..s mySPrtRowID=0
	..s myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..s myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..s myTolSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"TotSum"))
	..s myAPMInfo=""
	..s myCardPaySum=0
	..s myYBAccPaySum=0
	..s myYBTCPaySum=0
	..s myYBDBPaySum=0
	..s myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
	..//start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	..s myPrtStr="",singleCardPayDR=""
	..f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myPrtStr=myPrtStr_"^"_mySPrtRowID
	...i ((singleCardPayDR="")&&(mySPrtRowID'=""))  d
	....s IPMSub=$o(^DHCINVPRT(mySPrtRowID,"P","0"))   ;Lid 2011-03-26 根据支付小条重新指定支付方式（此处有点问题）
	....s singleCardPayDR=$p(^DHCINVPRT(mySPrtRowID,"P",IPMSub),"^",1)
	....s myCardPayDR=singleCardPayDR
	..i $d(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM")) d
	...//存在医保节点
	...s myCardPaySum=$fn(+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatShare")),"",2)
	...s myCardPaySum=myCardPaySum+myRoundSum
	...s myPMDR=""
	...f  s myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR)) q:(myPMDR="")  d
	....s myYBPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))
	....s myYBPay=$fn(myYBPay,"",2)
	....s myAPMInfo=myAPMInfo_myPMDR_"^"_myYBPay_$c(4)
	....i (myPMDR=myCardPayDR) d
	.....s myCardPaySum=myYBPay
	....i (myPMDR=myYBAccPayDR) d
	.....s myYBAccPaySum=myYBPay
	....i (myPMDR=myYBTCPayDR) d
	.....s myYBTCPaySum=myYBPay
	....i (myPMDR=myYBDBPayDR) d
	.....s myYBDBPaySum=myYBPay
	...;s myAPMInfo=myAPMInfo_myCardPayDR_"^"_$fn(myCardPaySum,"",2)_$c(4)
	...//modify hujunbin 14.12.5
	...i (+AutoYBFlag=1) d
	....s myAPMInfo=myAPMInfo_$c(4)
	...e  d
	....s myAPMInfo=myAPMInfo_myCardPayDR_"^"_$fn(myCardPaySum,"",2)_$c(4)
	....s myTmpSum=myTmpSum+myRoundSum
	...//end
	..e  d
	...//不存在医保节点
	...s myPMDR=myCardPayDR
	...s myCardPaySum=$fn((myCurSum+myRoundSum),"",2)
	...s myAPMInfo=myPMDR_"^"_myCardPaySum
	..s myINVPrtInfo=myInsType_" "_myInsDesc_" 第"_myvIdx_"张发票金额: "_$fn((myCurSum+myRoundSum),"",2)
	..s myINVPrtDesc=myINVPrtInfo
	..;
	..s myTmpSum=myCardPaySum+myYBAccPaySum+myYBTCPaySum+myYBDBPaySum
	..i (+myTmpSum'=+(myCurSum+myRoundSum)) d
	...s myFlag=1
	..s myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^"_myTolSum_"^"_myIDRowID_"^"_myRoundSum
	..s myINVPrtValue=myINVPrtValue_$c(3)_myPrtStr
	..s myINVPrtValue=myINVPrtValue_$c(3)_myAPMInfo	  ;为DHC_AccPayINVMode提供支付信息加医保留出空间
	..s myYBSum=$fn(+myYBAccPaySum+myYBTCPaySum+myYBDBPaySum,"",2)
	..s myPersonSum=$fn(myCardPaySum,"",2)
	..//+2017-6-27 ZhYW 医保结算指针为空时, DHC_AccPayINV.API_SelfYBPay、DHC_AccPayINVAPI_RefundSum 为0
	..i (myIDRowID="") d
	...s myYBSum=0
	...s myPersonSum=myCurSum
	..//
	..s myRefSum=$fn(+myYBSum,"",2)
	..s myCashSum=0			 ;现金支付方式
	..s myINVPrtValue=myINVPrtValue_$c(3)_myYBSum_"^"_myPersonSum_"^"_myRefSum_"^"_myCashSum			        ;为DHC_AccPay医保字段，和返钱字段   医保支付额_个人自付额_退款额
	..s myINVPrtValue=myINVPrtValue_$c(3)_myCardPaySum_"^"_myYBAccPaySum_"^"_myYBTCPaySum_"^"_myYBDBPaySum		;分解的明细值
	..s myINVPrtValue=myINVPrtValue_$c(3)_TMPGID			                     ;返回进程ID
	..s myINVPrtValue=myINVPrtValue_$c(3)_myInsType_"^"_myAdmSource			     ;返回收费类别的类型
	..s myINVPrtInfo=myINVPrtInfo_$c(2)_myPrtStr		                         ;发票信息
	..s retval=itmjs_"('"_$zcvt(itmjsex,"O","JS")_"','"_$zcvt(myINVPrtDesc,"O","JS")_"','"
	..s retval=retval_$zcvt(myINVPrtValue,"O","JS")_"','"
	..s retval=retval_$zcvt(+myvIdx-1,"O","JS")_"');"
	..&javascript<#(retval)#>
	
	q myFlag
}

/// 获取支付模式
ClassMethod GetFootPMInfo(TMPGID As %String, myInsType As %String, myINVIdx As %String) As %String
{
	n (TMPGID, myInsType, myINVIdx)
	
	s myAPMInfo=""
	
	//HIS支付节点
	s myPMDR=""
	f  s myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY",myPMDR)) q:(myPMDR="")  d
	.s myHISPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY",myPMDR))
	.s myAPMInfo=myAPMInfo_myPMDR_"^"_myHISPay_$c(4)
	
	q myAPMInfo
}

/// HIS结算完毕后，再次上传数据后保留的数据
/// s ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"PrtRowID",myPRTRowID)=myPRTRowID
/// w ##class(web.UDHCAccPrtPayFoot).UpdateAPIForYBDiv("4","")
ClassMethod UpdateAPIForYBDiv(TMPGID As %String, ExpStr As %String) As %String
{
	new (TMPGID, ExpStr)
	
	quit:('$d(^DHCTMPACCColPRT("IP",TMPGID))) 0_"^"_0
	
	set myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,0))
	set myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,0))
	
	set APIRowID=$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"APIRowID"))
	quit:(APIRowID="") 0_"^"_0

	set rtn=0
	
	set myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
	quit:(myIDRowID="") 2605_"^"_"医保结算表ID为空"

	ts
	
	set myYBPaySum=0
	set myRefundSum=0
	//更新支付模式
	set myCardPaySum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatShare"))
	set mySub=$o(^DHCINVPRTAP(APIRowID,"P",0))
	
	set myAccPayMRowID=APIRowID_"||"_mySub
	&SQL(
		UPDATE DHC_AccPayINVMode 
		SET APM_Amt = :myCardPaySum
		WHERE %ID = :myAccPayMRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//更新医保的支付模式
	set myPMDR=0
	while($o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))) {
		set myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))
		set myYBPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))
		set myYBPaySum=$i(myYBPaySum, myYBPay)
		&SQL(
			INSERT DHC_AccPayINVMode (
				APM_API_ParRef, APM_PayMode_DR, APM_Amt, APM_Date, APM_Time
			)
			VALUES (
				:APIRowID, :myPMDR, :myYBPay, CONVERT(DATE, NOW()), CONVERT(TIME, NOW())
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	do ##class(web.UDHCACINVColPrt).KillINVTMP(TMPGID)   //删除临时Global

	//更新DHC_AccPayINV
	&SQL(
		UPDATE DHC_AccPayINV
		SET API_SelfPatPay = (API_SelfPatPay - :myYBPaySum), API_SelfYBPay = (API_SelfYBPay + :myYBPaySum),
			API_RefundSum = (API_RefundSum - :myYBPaySum), API_InsDiv_DR = :myIDRowID
		WHERE %ID = APIRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//返回医保账户的钱
	if (+myYBPaySum'=0) {
		set PayMId=$o(^CT("CTPM",0,"Code","YBINSU",0))
		set UserDR=$p($g(^DHCINVPRTAP(APIRowID)),"^",5)
		set AccMRowId=$p($g(^DHCINVPRTAP(APIRowID)),"^",12)
		set HospId=$p($g(^DHCINVPRTAP(APIRowID)),"^",30)
		set PreType=$s((myYBPaySum<0):"R",1:"P")
		set myYBPaySum=$zabs(myYBPaySum)
		
		set BackReason=""
		set Password=""
		set Remark=""
		set InitPDRowId=""
		set DepTypeId=##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
		set PDInfo=myYBPaySum_"^"_UserDR_"^"_BackReason_"^"_Password_"^"_PreType_"^"_Remark_"^"_HospId
		set PDInfo=PDInfo_"^"_InitPDRowId_"^"_DepTypeId_"^"_APIRowID
		
		set Bank=""
		set ChequeNo=""
		set BankCardType=""
		set Company=""
		set ChequeDate=""
		set PayAccNo=""
		set PDPMInfo=PayMId_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate
		set PDPMInfo=PDPMInfo_"^"_PayAccNo_"^"_myYBPaySum
		
		set rtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccMRowId, PDInfo, PDPMInfo)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_myYBPaySum_"^"_myIDRowID
}

/// 收费过程中用此函数
/// 生成一个唯一的ID值
/// copy hujunbin 14.12.5
/// w ##class(web.UDHCAccPrtPayFoot).ColPrtByInvDate("DHCWeb_AddToList","INVInfo","81604||113^","1")
ClassMethod ColPrtByInvDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPrtStr As %String, ExpStr As %String, AutoYBFlag As %String = "") As %String
{
	n (itmjs, itmjsex, INVPrtStr, ExpStr, AutoYBFlag)
		
	//s $zt="ERROR^DHCSSERR"
	
	d ##class(web.UDHCACINVColPrt).KTMP()
	
	//取出基本配置?
	s myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfig()
	s rtn=$p(myBCInfo,"^",1)
	q:(+rtn) 104_$c(2)
	
	s itemFlag=$p(myBCInfo,"^",5)		;1			;;这个一定设置为1   不能改变?
	s reclocFlag=$p(myBCInfo,"^",6)		;1
	s PresNoFlag=$p(myBCInfo,"^",7)		;1
	s RecInvCount=$p(myBCInfo,"^",8)			;0
	s printCount=$p(myBCInfo,"^",9)				;21
	
	s rtn=0
	s mylen=$l(INVPrtStr,"^")
	s TMPGID=$i(^DHCTMPACCColPRT)
	s prtRowid=""
	k ^TMP("DHCOPBill","ColPrtByInvDate",TMPGID)
	
	//+2017-06-27 ZhYW 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	s APISavePRTInsDivFlag=##class(web.DHCBillParamConfig).%GetParameter("APISavePRTInsDivFlag")
	
	f i=1:1:mylen  d
	.s myAccPLDR=$p(INVPrtStr,"^",i)
	.q:(myAccPLDR="")
	.s PayDate=$p($g(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2))),"^",6)
	.s InvDr=$p($g(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2))),"^",2)
	.s prtRowid=InvDr
	.s:(InvDr'="") FairType=$p($g(^DHCINVPRT(InvDr)),"^",34)
	.i ($g(FairType)'["R")  s ^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PayDate,1)=$g(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PayDate,1))_myAccPLDR_"^"
	.e  d
	..s sub=$o(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PayDate,""),-1)
	..i (sub>1) s sub=sub+1
	..e  s sub=2
	..s ^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PayDate,sub)=myAccPLDR

	i $d(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID))  d
	.s PDate=""
	.f  s PDate=$o(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PDate))  q:((PDate="")||(+rtn))  d
	..s Psub=""
	..f  s Psub=$o(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PDate,Psub))  q:((Psub="")||(+rtn))  d
	...s AccPLStr=$g(^TMP("DHCOPBill","ColPrtByInvDate",TMPGID,PDate,Psub))
	...d ##class(web.UDHCACINVColPrt).KTMP()
    ...s rtnValue=##class(web.UDHCACINVColPrt).GetAccPayINVData(AccPLStr, itemFlag, reclocFlag)
	...s rtn=$p(rtnValue,"^")
	...q:(+rtn)
	...s rtnValue=##class(web.UDHCAccPrtPayFoot).ParDataToABillByDate(RecInvCount, printCount, TMPGID)
	...;modify tangtao 2011-06-15 PresNoFlag为0时不按科室拆分。
	...;s rtnValue=##class(web.UDHCAccPrtPayFoot).ParDataToABillByDate(PresNoFlag, printCount, TMPGID)
	...q:(+rtn)
	...s myInsType=0
	...f  s myInsType=$o(^DHCTMPACCColPRTDate("IP",TMPGID,myInsType)) q:(myInsType="")  d
	....s myINVIdx=0
    ....f  s myINVIdx=$o(^DHCTMPACCColPRTDate("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
    .....s CurIdx=$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))+1
    .....m ^DHCTMPACCColPRT("IP",TMPGID,myInsType,CurIdx)=^DHCTMPACCColPRTDate("IP",TMPGID,myInsType,myINVIdx)
    .....s ^DHCTMPACCColPRT("IP",TMPGID,myInsType)=$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))+1
    ....i (+AutoYBFlag=1)  d   ;zhho自助发票的支付方式
    .....//+2017-06-27 ZhYW 门诊收费医保实时结算时,DHC_AccPayINV是否保存小条表医保结算信息走配置
    .....i (APISavePRTInsDivFlag=1) d
    ......s insuDivDR=$o(^DHCINDIV("0","DHCInvPrt",prtRowid,0))
    ......i (insuDivDR'="") s ^DHCTMPACCColPRT("IP",TMPGID,myInsType,1,"YBRowID",insuDivDR)=""
    .....//
    .....s msub=""
    .....f  s msub=$o(^DHCINVPRT(prtRowid,"P",msub))  q:(msub="")  d
    ......s myPMDR=$p(^DHCINVPRT(prtRowid,"P",msub),"^",1)
    ......q:$d(^DHCTMPACCColPRT("IP",TMPGID,myInsType,1,"YBPM",myPMDR))
    ......s myAmt=$p(^DHCINVPRT(prtRowid,"P",msub),"^",3)
    ......s ^DHCTMPACCColPRT("IP",TMPGID,myInsType,1,"YBPM",myPMDR)=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,1,"YBPM",myPMDR))+myAmt
	...k ^DHCTMPACCColPRTDate("IP",TMPGID)
    
	s myvIdx=0
	
	s myInsType=0
	f  s myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) q:(myInsType="")  d
	.s myAdmSource=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.s myInsDesc=$p(^PAC("ADMREA",myInsType),"^",2)
	.s myINVNum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType))
	.s myINVIdx=0
	.s myINVPrtInfo=""
	.s myINVPrtDesc=""
	.f  s myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s myvIdx=$i(myvIdx)
	..s mySPrtRowID=0
	..s myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		;;卡支付DR
	..;zhho
	..s myYBAccPayDR=$o(^CT("CTPM",0,"Code","YB",0))		;;医保卡支付DR
	..s myYBAccPaySum=0
	..s myYBTCPayDR=$o(^CT("CTPM",0,"Code","CCP",0))		;;医保统筹支付DR
	..s myYBTCPaySum=0
	..s myYBZHPayDR=$o(^CT("CTPM",0,"Code","YBZH",0))		;;医保大病支付DR
	..s myYBZHPaySum=0
	..s myYBMZBZPayDR=$o(^CT("CTPM",0,"Code","MZBZ",0))		;;医保大病支付DR
	..s myYBMZBZPaySum=0
	..s myYBCSBZPayDR=$o(^CT("CTPM",0,"Code","CSBZ",0))		;;医保大病支付DR
	..s myYBCSBZPaySum=0
	..;zhho
	..s myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..s myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..s myPrtStr=""
	..f  s mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myPrtStr=myPrtStr_"^"_mySPrtRowID
	..s myINVPrtInfo=myInsType_" "_myInsDesc_" 第"_myvIdx_"张发票金额: "_(myCurSum+myRoundSum)
	..;zhho
	..s myAPMInfo=""
	..s myPMDR=""
	..i $d(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM")) d
	...f  s myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR)) q:(myPMDR="")  d
	....s myYBPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))
	....s myYBPay=$fn(myYBPay,"",2)
	....s myAPMInfo=myAPMInfo_myPMDR_"^"_myYBPay_$c(4)
	..;zhho
	..s myINVPrtDesc=myINVPrtInfo
	..s myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^^^"_myRoundSum
	..s myINVPrtValue=myINVPrtValue_$c(3)_myPrtStr
	..s myINVPrtValue=myINVPrtValue_$c(3)_myAPMInfo     ;myCardPayDR_"^"_(myCurSum+myRoundSum)	;为DHC_AccPayINVMode提供支付信息加医保留出空间
	..s myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^^^"		;为DHC_AccPay医保字段，和返钱字段
	..s myINVPrtValue=myINVPrtValue_$c(3)_"^^^^^"		;分解的明细值
	..s myINVPrtValue=myINVPrtValue_$c(3)_TMPGID		;返回进程ID
	..s myINVPrtValue=myINVPrtValue_$c(3)_myInsType_"^"_myAdmSource			;返回收费类别的类型
	..s myINVPrtInfo=myINVPrtInfo_$c(2)_myPrtStr		;发票信息
	..s retval=itmjs_"('"_$zcvt(itmjsex,"O","JS")_"','"_$zcvt(myINVPrtDesc,"O","JS")_"','"
	..s retval=retval_$zcvt(myINVPrtValue,"O","JS")_"','"
	..s retval=retval_$zcvt(+myvIdx-1,"O","JS")_"');"
	..&javascript<#(retval)#>
	
	//屏蔽删除Global
	d ##class(web.UDHCACINVColPrt).KTMP()
	
	if (myvIdx=0) d
	.s rtn=108
	
	q +rtn
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
/// w ##class(web.UDHCACINVColPrt).ParDataToABillByDate(2, 3)
ClassMethod ParDataToABillByDate(RecInvCount As %String, printCount As %String, TMPGID As %String) As %String
{
	n (RecInvCount, printCount, TMPGID)
	
	s $zt="ERROR^DHCSSERR"
	
	k ^TMPColPrt("IP",$j)
	k ^TMPColPrt("BillINV",$j)
	k ^DHCTMPACCColPRTDate("IP",TMPGID)
	
	s rtn=0
	s mIdx=0
	s myinstype=""
	f  s myinstype=$o(^TMPColPrt("OPOPN",$j,myinstype)) q:((myinstype="")&&(rtn=0))  d
	.s myPrtRowID=0
	.s myFullFlag=0
	.f  s myPrtRowID=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID)) q:((myPrtRowID="")&&(rtn=0))  d
	..i (myFullFlag=1) d
	...s myFullFlag=0		;设置在当前发票中未满
	..e  d
	...s myINVIdx=1		    ;任何一个帐单集合都是由第一张发票开始验证
	..i (mIdx>150) s rtn=-1			;防止设置错误的无限循环
	..s myPresNo=""
	..f  s myPresNo=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID,myPresNo)) q:((myPresNo="")&&(rtn=0))  d
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
	....q:(billrtn'=0)
	...i (myFullFlag=1) d
	....s myINVIdx=+myINVIdx+1
	....s myTMPIdx=$g(^TMPColPrt("BillINV",$j,myinstype))
	....d CopyData(myinstype, myINVIdx)
	....i (myINVIdx>myTMPIdx) d
	.....d BuildBlankBill(myinstype)
	..s myIPCount=+$g(^TMPColPrt("IP",$j,myinstype))
	..i ((myFullFlag=1)&&(myIPCount>=(myINVIdx-1))) d
	...;如果当前处方不适合?就重新对此帐单集合进行分配
	...s myPrtRowID=$o(^TMPColPrt("OPOPN",$j,myinstype,myPrtRowID),-1)
	..i ((myFullFlag=1)&&(myIPCount<(myINVIdx-1))) d
	...s myFullFlag=0
	...k ^TMPColPrt("BillINV",$j,myinstype,myINVIdx)
	...s myINVIdx=myINVIdx-1
	...s ^TMPColPrt("BillINV",$j,myinstype)=^TMPColPrt("BillINV",$j,myinstype)-1
	..i (myFullFlag=0) d
	...k ^TMPColPrt("IP",$j, myinstype,myINVIdx)
	...m ^TMPColPrt("IP",$j, myinstype,myINVIdx)=^TMPColPrt("BillINV",$j,myinstype,myINVIdx)
	...s ^TMPColPrt("IP",$j, myinstype)=^TMPColPrt("BillINV",$j,myinstype)
	
	k ^TMPColPrt("BillINV",$j)
	
	d BuildHISPayMode()
	
	;前面增加一个myTMPGID的锁点  Lock
	;增加一个^DHCTMPACCColPRT("IP",myTMPGID)
	s myTMPGID=TMPGID
	m ^DHCTMPACCColPRTDate("IP",myTMPGID)=^TMPColPrt("IP",$j)
	;k ^TMPColPrt("IP",$j)
	
	q rtn
CopyData(tmpinstype,tmpINVIdx)
	n (tmpinstype, tmpINVIdx)
	;复原前一张发票
	k ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx-1)
	
	m ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx-1)=^TMPColPrt("IP",$j,tmpinstype,tmpINVIdx-1)
	
	;复原下一张发票
	k ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx)
	
	m ^TMPColPrt("BillINV",$j,tmpinstype,tmpINVIdx)=^TMPColPrt("IP",$j,tmpinstype,tmpINVIdx)

	q 0	
CheckBill(tmpinstype, tmpPBordrid,tmpRecInvCount, tmpprintCount, tmpPrtRowID, tmpINVIdx)
	n (tmpinstype, tmpPBordrid, tmpRecInvCount, tmpprintCount, tmpPrtRowID, tmpINVIdx)
	s $zt="ERROR^DHCSSERR"
	
	s CBIPNum=$g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,"ItmNum"))   ;需要打印的明细数量
	s PrintFlag=0
	s RecpFlag=0
	s CBIIviFlag=0
	s CBICurIdx=""
	//分票算法;
	//说明:  1:表示此医嘱可以放在此票据内; 0 表示不能放在此票据内;
	s myCurAdmDR=$p($g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)),"^",16)
	s CBIinvidx=tmpINVIdx-1
	k ^TMPColPrt("TMPLI",$j)
	f  s CBIinvidx=$o(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx)) q:((CBIinvidx="")||((PrintFlag=1)&(RecpFlag=1)&&(myAdmFlag=1)))  d
	.k ^TMPColPrt("TMPLI",$j)
	.s CBICurIdx=CBIinvidx		;记录下当前的票据编号;1,2,3,等等与原始票据无关;
	.s cbitmnum=""
	.s INVPNum=CBIPNum+^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"PrintCount")		;记录数
	.;判断是否有条件参数;
	.i (tmpprintCount=0) d
	..s PrintFlag=1
	.e  d
	..s PrintFlag=0
	.i (tmpRecInvCount=0) d
	..s RecpFlag=1
	.e  d
	..s RecpFlag=0
	.s myAdmFlag=0
	.s INVRecNum=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount")			;回执
	.s cbrecloc=""
	.f  s cbrecloc=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc)) q:(cbrecloc="")  d
	..q:(tmpRecInvCount=0)		;不再判断
	..s cbitmsub=""
	..f  s cbitmsub=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub)) q:(cbitmsub="")  d
	...s CBIitmnum=""
	...f  s CBIitmnum=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:(CBIitmnum="")  d
	....s rtn=0
	....;在当前票据下循环回执联
	....s tmprec=""
	....s tmpINVrec=""
	....f  s tmpINVrec=$o(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)) q:((tmpINVrec="")||(rtn=1))  d
 	.....s INVRecLoc=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","RecLoc",tmpINVrec)
	.....s INVItem=^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"RecInvCount","ItemSub",tmpINVrec)
	.....s mytmpli=$g(^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub))
	.....i (((INVRecLoc=cbrecloc)&&(INVItem=cbitmsub))||(mytmpli'="")) d
	......s rtn=1
	.....q:(rtn=1)			//rtn=1说明存在这个科目退回上个循环?
	....i (rtn=0) d
	.....q:$d(^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub))     //add  by  zhl  2010.05.06   xy
	.....s INVRecNum=INVRecNum+1		;使科目加一?  同时增加临时科目；
	.....s ^TMPColPrt("TMPLI",$j,cbrecloc,cbitmsub)=cbrecloc	;这个必需存在，否则不能判断
	.;;验证当前票据能否放下
	.i (RecpFlag=0) d
	..i (INVRecNum<=tmpRecInvCount) s RecpFlag=1
	.i (PrintFlag=0) d
	..i (INVPNum<=tmpprintCount) s PrintFlag=1
	.i ($g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR"))="") d
	..s ^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR")=myCurAdmDR		;对于空发票先添加属性
	.s myINVAdmDR=$g(^TMPColPrt("BillINV",$j,tmpinstype,CBIinvidx,"AdmDR"))			;;property
	.i (myCurAdmDR=myINVAdmDR) d
	..s myAdmFlag=1
	.i ((PrintFlag=1)&&(RecpFlag=1)&&(myAdmFlag=1)) s CBIIviFlag=1
	
	i (CBIIviFlag=0) s CBICurIdx=CBICurIdx+1		;没有合适票据,加一
	
	k ^TMPColPrt("TMPLI",$j)
	
	q CBICurIdx
BuildBillData(invIdx, tmpinstype, tmpPBordrid, tmpRecInvCount,tmpprintCount, tmpPrtRowID)
	;把医嘱装载在票据中;
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
	
	i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"AdmDR"))="") d
	.s ^TMPColPrt("BillINV", $j,tmpinstype, myIdx,"AdmDR")=myAdmDR
	i ($g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PresNo"))="") d
	.s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PresNo")=myPresNo
	
	;验证数据
	;加打印条数
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PrintCount")=myPCount+$g(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,"ItmNum"))		;已经分配打印条数?
	;票据钱数?患者支付?
	s myordpay=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",15)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PatPaySum")=+myordpay+$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PatPaySum"))
	s mytopay=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",15)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"TotSum")=+mytopay+$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"TotSum"))
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"PrtRowID",tmpPrtRowID)=tmpPrtRowID
	
	;新增
	s cbrecloc=""
	f  s cbrecloc=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc)) q:(cbrecloc="")  d
	.q:tmpRecInvCount=0
	.s cbitmsub=""
	.f  s cbitmsub=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub)) q:(cbitmsub="")  d
	..s CBIitmnum=""
	..f  s CBIitmnum=$o(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum)) q:(CBIitmnum="")  d
	...s myItemSum=$p(^TMPColPrt("OPITEM",$j,tmpinstype,tmpPrtRowID,tmpPBordrid,cbrecloc,cbitmsub,CBIitmnum),"^",13)
	...s rtn=0
	...;在当前票据下循环回执联
	...s tmprec=""
	...s tmpCurRecIdx=0
	...s tmpINVrec=""
	...f  s tmpINVrec=$o(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpINVrec)) q:(tmpINVrec="")  d
	....s tmpCurRecIdx=tmpINVrec
	....s INVRecLoc=^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpINVrec)
	....s INVItem=^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItemSub",tmpINVrec)
	....i (INVRecLoc=cbrecloc)&&(INVItem=cbitmsub) d
	.....s rtn=1
	.....s mydepSum=$g(^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpINVrec))
	.....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpINVrec)=mydepSum+myItemSum
	....q:rtn=1			//rtn=1说明存在这个科目退回上个循环?
	...i (rtn=0) d  		;;增加科目
	....;写数据
	....s tmpCurRecIdx=tmpCurRecIdx+1		;使科目加一?
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount")=tmpCurRecIdx
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","RecLoc",tmpCurRecIdx)=cbrecloc
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItemSub",tmpCurRecIdx)=cbitmsub
	....s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"RecInvCount","ItmMoney",tmpCurRecIdx)=myItemSum

	;票据结算数据
	s ordrid=$p(^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid),"^",2)
	;这里保存中途结算的需要参数?	票据数据;
	;;节点:费别,账单RowID,医嘱RowID(OE_OrdItem)
	s ^TMPColPrt("BillINV",$j,tmpinstype,myIdx,"INT",tmpinstype,"BR",+tmpPBordrid,"ORD",tmpPBordrid)=^TMPColPrt("OPOI",$j,tmpinstype,tmpPrtRowID,tmpPBordrid)
	q 0
BuildHISPayMode()
	n (ad)
	;一张发票的不同支付模式
	;"HISPay"  节点
	
	s myInsType=0
	f  s myInsType=$o(^TMPColPrt("IP",$j,myInsType)) q:(myInsType="")  d
	.s myINVIdx=0
	.f  s myINVIdx=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx)) q:(myINVIdx="")  d
	..s mySPrtRowID=0
	..f  s mySPrtRowID=$o(^TMPColPrt("IP",$j,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) q:(mySPrtRowID="")  d
	...s myRoundSum=+$p(^DHCINVPRT(mySPrtRowID),"^",37)		  //RoundErr
	...s ^TMPColPrt("IP",$j,myInsType,myINVIdx,"RoundSum")=myRoundSum+$g(^TMPColPrt("IP",$j,myInsType,myINVIdx,"RoundSum"))
	...s myIPMSub=0
	...f  s myIPMSub=$o(^DHCINVPRT(mySPrtRowID,"P",myIPMSub)) q:(myIPMSub="")  d
	....s myPMDR=$p(^DHCINVPRT(mySPrtRowID,"P",myIPMSub),"^",1)
	....s myPMSum=$p(^DHCINVPRT(mySPrtRowID,"P",myIPMSub),"^",3)
	....s ^TMPColPrt("IP",$j,myInsType,myINVIdx,"HISPAY",myPMDR)=myPMSum+$g(^TMPColPrt("IP",$j,myInsType,myINVIdx,"HISPAY",myPMDR))
	
	q 0
BuildBlankBill(tmpinstype)
	n (ab, tmpinstype)
	s ^TMPColPrt("BillINV",$j,tmpinstype)=$g(^TMPColPrt("BillINV",$j,tmpinstype))+1
	s bbIdx=$g(^TMPColPrt("BillINV",$j,tmpinstype))
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PrintCount")=0		;已经分配打印条数?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"RecInvCount")=0		;已经分配回执数量?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PatPaySum")=0		;票据中患者支付额	
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"TotSum")=0			;票据总额?
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"RoundSum")=0		;分币误差额
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"AdmDR")=""
	s ^TMPColPrt("BillINV",$j,tmpinstype,bbIdx,"PresNo")=""
	// 账单RowID? 医嘱RowID?费别?
	q bbIdx
}

/// Creator: Lid
/// CreatDate: 2015-03-04
/// Description: 判断集中打印发票时，参与医保分解的支付小条是否已经医保分解
/// Input: YBPayFlag:集中打印发票时是否医保分解，0：医保分解，1：已经分解不再分解
/// 			CID:要打印的发票集合ID
/// Return: 0:所有的小条都没有做医保分解，1：部分小条已经医保分解。
/// Other: 返回1时，不能进行集中打印发票，需要查原因。
/// Debug: w ##class(web.UDHCAccPrtPayFoot).CheckPrtInvYBPay(0,1111)
ClassMethod CheckPrtInvYBPay(YBFlag, CID)
{
	new (YBFlag, CID)
	set TMPGID=CID
	set rtn=0
	set myInsType=0
	for  set myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) quit:((myInsType="")||(+rtn))  do
	.set myINVIdx=0
	.for  set myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) quit:((myINVIdx="")||(+rtn))  do
	..set myPrtRowID=""
	..for  set myPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",myPrtRowID)) quit:((myPrtRowID="")||(+rtn))  d
	...set myInsuDivDr=$p(^DHCINVPRT(myPrtRowID),"^",30)
	...if ((myInsuDivDr'="")&&(YBFlag=0)) set rtn=1
	
	quit rtn
}

/// w ##class(web.UDHCAccPrtPayFoot).CheckUnPrintINV(1612, 2)
ClassMethod CheckUnPrintINV(AccRowID As %String, HospId As %String) As %String
{
	New (AccRowID, HospId)
	Set rtn=0
	Quit:(AccRowID="") 0
	
	Set mySub=0
	For  Set mySub=$o(^DHCACD("AccM",AccRowID,"AccPL",mySub)) Quit:((mySub="")||(+rtn))  Do
	.Set myAccPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",mySub))
	.Quit:(myAccPLData="")
	.Set myBusiType=$p(myAccPLData,"^",11)
	.Quit:(myBusiType'="OP")
	.Set myPLHospDR=$p(myAccPLData,"^",16)
	.Quit:(HospId'=myPLHospDR)
	.Set myPRTRowID=$p(myAccPLData,"^",2)
	.Quit:(+myPRTRowID=0)
	.Set myINVFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",8)
	.Quit:(myINVFlag'="N")
	.Set myINVPrtFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",3)		//发票的打印标识
	.Quit:(myINVPrtFlag'="N")
	.Set rtn=1
	
	Quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-02-12
/// Description: 集中打印拆分发票Query数据集输出
/// Input:
/// Output: errCode:错误代码,insTypeDR:费别RowId,insTypeDesc:费别描述,invAmt:金额,invPrtValue:发票信息串
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccPrtPayFoot","ParPrtToINVList","87","3^239^17275^2^N^0^20")
Query ParPrtToINVList(INVPrtStr As %String, ExpStr As %String) As websys.Query(ROWSPEC = "errCode:%String,insTypeDR:%String,insTypeDesc:%String,invAmt:%Float,invPrtValue:%String")
{
}

ClassMethod ParPrtToINVListExecute(ByRef qHandle As %Binary, INVPrtStr As %String, ExpStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ParPrtToINVList")=$lb(INVPrtStr, ExpStr)

	set ctLocDR=$p(ExpStr,"^",1)
	set groupDR=$p(ExpStr,"^",2)
	set userDR=$p(ExpStr,"^",3)
	set hospDR=$p(ExpStr,"^",4)
	set stayInvFlag=$p(ExpStr,"^",5)
	set AutoYBFlag=$p(ExpStr,"^",6)
	set langId=$p(ExpStr,"^",7)
	
	do InitOutput
	
	do ##class(web.UDHCACINVColPrt).KTMP()
	
	set TMPGID=$i(^DHCTMPACCColPRT)
	
	//+2017-06-27 ZhYW 门诊收费医保实时结算时，DHC_AccPayINV是否保存小条表医保结算信息走配置
	set APISavePRTInsDivFlag=##class(web.DHCBillParamConfig).%GetParameter("APISavePRTInsDivFlag")

	//获取基本配置
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(groupDR, hospDR)
	set rtn=$p(myBCInfo,"^")
	if (+rtn) {
		set errCode=104
		do OutputINVList
		quit $$$OK
	}
	
	set itemFlag=$p(myBCInfo,"^",5)		     ;1			;;这个一定设置为1   不能改变?
	set reclocFlag=$p(myBCInfo,"^",6)		 ;1
	set PresNoFlag=$p(myBCInfo,"^",7)		 ;1
	set RecInvCount=$p(myBCInfo,"^",8)		 ;0
	set printCount=$p(myBCInfo,"^",9)		 ;21
	set OnToManyFlag=$p(myBCInfo,"^",32)
	set RegInvFlag=$p(myBCInfo,"^",33)
	set InvDateFlag=$p(myBCInfo,"^",34)
	if ((stayInvFlag="Y")||(AutoYBFlag=1)) set OnToManyFlag=1   //急诊留观和医保已结算的1:1
	set rtnValue=##class(web.UDHCACINVColPrt).GetAccPayINVData(INVPrtStr, itemFlag, reclocFlag, OnToManyFlag, RegInvFlag, InvDateFlag)
	set rtn=$p(rtnValue,"^")
	if (+rtn) {
		set errCode=+rtn
		do OutputINVList
		quit $$$OK
	}
	
	set rtn=##class(web.UDHCACINVColPrt).ParDataToABill(RecInvCount, printCount, TMPGID)
	if (+rtn) {
		set errCode=+rtn
		do OutputINVList
		quit $$$OK
	}
	
	kill ListAry

	set myvIdx=0
	set myInsType=0
	for  set myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) quit:(myInsType="")  do
	.set myAdmSource=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.set myINVIdx=0
	.for  set myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) quit:(myINVIdx="")  do
	..set myvIdx=$i(myvIdx)
	..set myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		//卡支付DR
	..set myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..set myCurSum=$fn(myCurSum,"",2)
	..set myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..set myRoundSum=$fn(myRoundSum,"",2)
	..//start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	..set myPrtStr="", singleCardPayDR=""
	..set mySPrtRowID=0
	..for  set mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) quit:(mySPrtRowID="")  do
	...set myPrtStr=myPrtStr_"^"_mySPrtRowID
	...if ((singleCardPayDR="")&&(mySPrtRowID'=""))  do
	....//2020-06-22 ZhYW 改为取自费的支付方式
	....set IPMSub=""
	....for  set IPMSub=$o(^DHCINVPRT(mySPrtRowID,"P",IPMSub),-1)  quit:((IPMSub="")||(singleCardPayDR'=""))  do
	.....set IPMData=$g(^DHCINVPRT(mySPrtRowID,"P",IPMSub))
	.....quit:(IPMData="")
	.....set IPMIsSelfPay=$p(IPMData,"^",12)
	.....quit:(+IPMIsSelfPay'=1)   //过滤医保支付方式
	.....set singleCardPayDR=$p(IPMData,"^",1)
	.....set myCardPayDR=singleCardPayDR
	...//2014-12-05 hujunbin
    ...if (AutoYBFlag=1) do
    ....//+2017-06-27 ZhYW 门诊收费医保实时结算时,DHC_AccPayINV是否保存小条表医保结算信息走配置
    ....if (APISavePRTInsDivFlag=1) do
    .....set insuDivDR=$o(^DHCINDIV("0","DHCInvPrt",mySPrtRowID,0))
    .....if (insuDivDR'="") set ^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",insuDivDR)=""
    ....m ^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM")=^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"HISPAY")
	..set myInvPatAmt=myCurSum+myRoundSum
	..set myInvPatAmt=$fn(myInvPatAmt,"",2)
	..set myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^^^"_myRoundSum
	..set myINVPrtValue=myINVPrtValue_"|"_myPrtStr
	..set myINVPrtValue=myINVPrtValue_"|"_myCardPayDR_"^"_myInvPatAmt	//为DHC_AccPayINVMode提供支付信息加医保留出空间
	..set myINVPrtValue=myINVPrtValue_"|"_"^^^^^^^"		//为DHC_AccPay医保字段, 和返钱字段
	..set myINVPrtValue=myINVPrtValue_"|"_"^^^^^"		    //分解的明细值
	..set myINVPrtValue=myINVPrtValue_"|"_TMPGID		    //返回进程ID
	..set myINVPrtValue=myINVPrtValue_"|"_myInsType_"^"_myAdmSource				//收费类别的类型
	..set ListAry(myvIdx)=$lb(myInsType,myInvPatAmt,myINVPrtValue)
	
	if (myvIdx=0) do
	.set errCode=108
	
	set invIdx=0
	for  set invIdx=$o(ListAry(invIdx)) quit:(invIdx="")  do
	.set data=$g(ListAry(invIdx))
	.set insTypeDR=$lg(data,1)
	.set insTypeDesc=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	.set insTypeDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", insTypeDesc, langId)
	.set invAmt=$lg(data,2)
	.set invAmt=$fn(invAmt,"",2)
	.set invPrtValue=$lg(data,3)
	.do OutputINVList
		
	quit $$$OK

InitOutput
	set errCode=0
	set invAmt=0
	set (insTypeDR, insTypeDesc, invPrtValue)=""
	quit
OutputINVList
	set Data=$lb(errCode,insTypeDR,insTypeDesc,invAmt,invPrtValue)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-02-12
/// Description: 集中打印拆分发票Query数据集输出
///              调用医保接口后，重新获取的发票信息的函数
///              在前一步拆解完医保后，调用的接口
/// Input: 
/// Output: errCode:错误代码,insTypeDR:费别RowId,insTypeDesc:费别描述,invAmt:金额,invPrtValue:发票信息串
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccPrtPayFoot","ReadInvListForYB","127","238^122^5^2^^0")
Query ReadInvListForYB(TMPGID As %String, ExpStr As %String) As websys.Query(ROWSPEC = "errCode:%String,insTypeDR:%String,insTypeDesc:%String,invAmt:%Float,invPrtValue:%String")
{
}

ClassMethod ReadInvListForYBExecute(ByRef qHandle As %Binary, TMPGID As %String, ExpStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	set AutoYBFlag=$p(ExpStr,"^",6)
	
	set myCardPayDR=$o(^CT("CTPM",0,"Code","CPP",0))		  //卡支付DR
	set myYBAccPayDR=$o(^CT("CTPM",0,"Code","INSUZHZF",0))	  //医保卡支付DR
	set myYBTCPayDR=$o(^CT("CTPM",0,"Code","YBINSU",0))		  //医保统筹支付DR
	set myYBDBPayDR=$o(^CT("CTPM",0,"Code","BZCJINSU",0))	  //医保大病支付DR(病种差价)

	kill ListForYBAry

	set myTmpSum=0
	
	set myvIdx=0
	set myFlag=0
	set myInsType=0
	for  set myInsType=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType)) quit:((myInsType="")||(+myFlag'=0))  do
	.set myAdmSource=##class(web.DHCOPConfig).ReadYBFlagByINS(myInsType)
	.set myINVIdx=0
	.for  set myINVIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx)) quit:(myINVIdx="")  do
	..set myvIdx=$i(myvIdx)
	..set myCurSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatPaySum"))
	..set myCurSum=$fn(myCurSum,"",2)
	..set myRoundSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"RoundSum"))
	..set myRoundSum=$fn(myRoundSum,"",2)
	..set myTolSum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"TotSum"))
	..set myTolSum=$fn(myTolSum,"",2)
	..set myAPMInfo=""
	..set myCardPaySum=0
	..set myYBAccPaySum=0
	..set myYBTCPaySum=0
	..set myYBDBPaySum=0
	..set myIDRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBRowID",0))
	..//start Lid 2012-02-09  根据支付小条重新指定支付方式（此处有点问题）
	..set myPrtStr="", singleCardPayDR=""
	..set mySPrtRowID=0
	..for  set mySPrtRowID=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PrtRowID",mySPrtRowID)) quit:(mySPrtRowID="")  do
	...set myPrtStr=myPrtStr_"^"_mySPrtRowID
	...if ((singleCardPayDR="")&&(mySPrtRowID'=""))  do
	....//2020-06-22 ZhYW 改为取自费的支付方式
	....set singleCardPayDR=##class(web.UDHCAccPrtPayFoot).GetFstSelfPaymId(mySPrtRowID)
	....set myCardPayDR=singleCardPayDR
	..if $d(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM")) do
	...//存在医保节点
	...set myCardPaySum=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"PatShare"))
	...set myCardPaySum=$fn(myCardPaySum,"",2)
	...set myCardPaySum=myCardPaySum+myRoundSum
	...set myPMDR=""
	...for  set myPMDR=$o(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR)) quit:(myPMDR="")  do
	....set myYBPay=+$g(^DHCTMPACCColPRT("IP",TMPGID,myInsType,myINVIdx,"YBPM",myPMDR))
	....set myYBPay=$fn(myYBPay,"",2)
	....set myAPMInfo=myAPMInfo_myPMDR_"^"_myYBPay_"#"
	....if (myPMDR=myCardPayDR) do
	.....set myCardPaySum=myYBPay
	....if (myPMDR=myYBAccPayDR) do
	.....set myYBAccPaySum=myYBPay
	....if (myPMDR=myYBTCPayDR) do
	.....set myYBTCPaySum=myYBPay
	....if (myPMDR=myYBDBPayDR) do
	.....set myYBDBPaySum=myYBPay
	...if (AutoYBFlag=1) do
	....set myAPMInfo=myAPMInfo_"#"
	...else  do
	....set myAPMInfo=myAPMInfo_myCardPayDR_"^"_$fn(myCardPaySum,"",2)_"#"
	....set myTmpSum=myTmpSum+myRoundSum
	..else  do
	...//不存在医保节点
	...set myPMDR=myCardPayDR
	...set myCardPaySum=$fn((myCurSum+myRoundSum),"",2)
	...set myAPMInfo=myPMDR_"^"_myCardPaySum
	..set myTmpSum=myCardPaySum+myYBAccPaySum+myYBTCPaySum+myYBDBPaySum
	..set myTmpSum=$fn(myTmpSum,"",2)
	..set myInvPatAmt=myCurSum+myRoundSum
	..set myInvPatAmt=$fn(myInvPatAmt,"",2)
	..if (+myTmpSum'=+myInvPatAmt) do
	...set myFlag=1
	..set myINVPrtValue=myCurSum_"^"_myInsType_"^"_TMPGID_"^"_myTolSum_"^"_myIDRowID_"^"_myRoundSum
	..set myINVPrtValue=myINVPrtValue_"|"_myPrtStr
	..set myINVPrtValue=myINVPrtValue_"|"_myAPMInfo	     //为DHC_AccPayINVMode提供支付信息加医保留出空间
	..set myYBSum=$fn(+myYBAccPaySum+myYBTCPaySum+myYBDBPaySum,"",2)
	..set myPersonSum=$fn(myCardPaySum,"",2)
	..//+2017-6-27 ZhYW 医保结算指针为空时, DHC_AccPayINV.API_SelfYBPay、DHC_AccPayINVAPI_RefundSum 为0
	..if (myIDRowID="") do
	...set myYBSum=0
	...set myPersonSum=myCurSum
	..//
	..set myRefSum=$fn(+myYBSum,"",2)
	..set myCashSum=0			 //现金支付方式
	..set myINVPrtValue=myINVPrtValue_"|"_myYBSum_"^"_myPersonSum_"^"_myRefSum_"^"_myCashSum			        ;为DHC_AccPay医保字段，和返钱字段   医保支付额_个人自付额_退款额
	..set myINVPrtValue=myINVPrtValue_"|"_myCardPaySum_"^"_myYBAccPaySum_"^"_myYBTCPaySum_"^"_myYBDBPaySum		;分解的明细值
	..set myINVPrtValue=myINVPrtValue_"|"_TMPGID			                     //返回进程ID
	..set myINVPrtValue=myINVPrtValue_"|"_myInsType_"^"_myAdmSource			 //返回收费类别的类型
	..set ListForYBAry(myvIdx)=$lb(myInsType,myInvPatAmt,myINVPrtValue)
	
	set errCode=myFlag
	set invIdx=0
	for  set invIdx=$o(ListForYBAry(invIdx)) quit:(invIdx="")  do
	.set data=$g(ListForYBAry(invIdx))
	.set insTypeDR=$lg(data,1)
	.set insTypeDesc=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	.set invAmt=$lg(data,2)
	.set invAmt=$fn(invAmt,"",2)
	.set invPrtValue=$lg(data,3)
	.do OutputINVListForYB
	
	quit $$$OK
	
OutputINVListForYB
	set Data=$lb(errCode,insTypeDR,insTypeDesc,invAmt,invPrtValue)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-23
/// Description: 根据结算记录获取第一个自费支付的支付方式Id
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: CT_PayMode.RowId
/// Debug: w ##class(web.UDHCAccPrtPayFoot).GetFstSelfPaymId(5)
ClassMethod GetFstSelfPaymId(prtRowId As %String) As %String
{
	new (prtRowId)
	
	set paymId=""
	
	set paymSub=""
	while($o(^DHCINVPRT(prtRowId,"P",paymSub),-1)) {
		set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub),-1)
		set subData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
		continue:(subData="")
		set isSelf=$p(subData,"^",12)
		continue:(+isSelf'=1)      //过滤医保支付方式
		set paymDR=$p(subData,"^",1)
		set paymId=paymDR
		quit
	}
	
	quit paymId
}

}
