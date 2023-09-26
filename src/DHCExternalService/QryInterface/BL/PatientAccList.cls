/// Creator:Lid
/// CreatDate:2013-08-30
/// Desc:查询病人账户明细
Class DHCExternalService.QryInterface.BL.PatientAccList Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:Lid
/// CreatDate:2013-08-30
/// Input:<Request><CardTypeCode></CardTypeCode><CardNo>100000014420</CardNo><SecrityNo></SecrityNo></Request>
/// Return:
/// Debug:w ##class(DHCExternalService.QryInterface.BL.PatientAccList).GetPatAccList("<Request><CardTypeCode></CardTypeCode><CardNo>100000014420</CardNo><SecrityNo>6302038049</SecrityNo></Request>")
ClassMethod GetPatAccList(input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set $zt="GetPatAccListET"
	
	Set ResultCode="100",ErrorMsg="没有查询到人员信息"
	Set RpObj=##class(DHCExternalService.QryInterface.MSG.FEE.GetPatAccListRp).%New()
	Set RtObj=##Class(DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRt).%New()
	Do RtObj.XMLNodeDeserialize(.RtObj,"Request",input)
	Set CardTypeCode=RtObj.CardTypeCode
	Set CardNo=RtObj.CardNo
	Set SecrityNo=RtObj.SecrityNo
	b
	If (CardNo=""){
	    Do Output10("-101","卡号不能为空")
		Quit RpStream
	}
	Set CardTypeID=##class(DHCExternalService.QryInterface.BL.InvFeeInfo).GetHisCardTypeID(CardTypeCode)
	;w ##class(web.UDHCAccManageCLSIF).getaccinfofromcardno("100000014420","6302038049",""_$c(2)_""_$c(2)_"PatInfo")
	Set myExpStr=""_$c(2)_""_$c(2)_""
	Set Data=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,SecrityNo,myExpStr)
	Set Papmi=$p(Data,"^",8)
    if (Papmi="") {
	  	Do Output10("-102","不存在病人主索引")
		Quit RpStream
	}
    Set PatSocialStatusDR=$p(^PAPER(Papmi,"PER",1),"^",10) ;PAPER_SocialStatus_DR -> CT_SocialStatus
    Set PatSocialStatus=$p(^CT("SS",PatSocialStatusDR),"^",2)
    Set AccMRowID=$p(Data,"^",2)
    Set AccMBalance=$p(Data,"^",5)
    Set AccMBalance=AccMBalance
    Set AccMDepPrice=$p(Data,"^",6)
    Set AccMAccType=$p(Data,"^",11)
    Set AccMCardTypeDR=$p(Data,"^",13)
	Set PapNo=$p(^PAPER(Papmi,"PAT",1),"^",1)   ;登记号
	Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)   ;姓名
	Set Sex=$p(^PAPER(Papmi,"ALL"),"^",7)       ;性别
	If Sex'="" Set Sex=$p(^CT("SEX",Sex),"^",2)
	Set PatAge=""
	Set PatientDOB=$P($G(^PAPER(Papmi,"ALL")),"^",6)
	Set PatAge=..GetAgeDesc(PatientDOB,+$h)
	;
	Set ResultCode="0",ErrorMsg="成功"
	Set RpObj.PatientID=PapNo
	Set RpObj.PatName=PatName
	Set RpObj.PatAge=PatAge
	Set RpObj.PatSex=Sex
	Set RpObj.AccMRowID=AccMRowID
	Set RpObj.AccMBalance=AccMBalance
	;
	Kill ^TMPAccPatList("QueryAccList",$j)
	Set rtn=..SetPreDepositList(AccMRowID)
	Set rtn=..SetPatAccPayList(AccMRowID)
	;
	Set myADate=""
	Set myIdx=1
	For  Set myADate=$o(^TMPAccPatList("QueryAccList",$j,myADate),-1) Quit:(myADate="")  Do
	.Quit:(myADate=0)
	.Set myATime=""
	.For  Set myATime=$o(^TMPAccPatList("QueryAccList",$j,myADate, myATime),-1) Quit:(myATime="")  Do
	..Quit:(myATime=0)
	..Set mySub=""
	..For  Set mySub=$o(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),-1) Quit:(mySub="")  Do
	...Quit:(mySub=0)
	...Set No=myIdx
	...Set APDate=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",1)
	...Set APType=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",2)
	...Set AccSum=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",3)
	...Set AccUser=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",4)
	...Set ABillNo=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",5)
	...Set ALeft=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",6)
	...Set myFlag=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",7)
	...Set myPRowID=$p(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub),"^",8)
	...Set myINVNo=$p($g(^TMPAccPatList("QueryAccList",$j,myADate, myATime, mySub)),"^",9)
	...Set PrtDate=$zd(myADate,3)
	...Set PrtTime=$zt(myATime,1)
	...Set OrderDetails=""
	...Set:(myFlag="PL")&(myPRowID'="") OrderDetails=..GetOrdDetailsByPrtRowID(myPRowID)
	...Set AccListDetailObj=##class(DHCExternalService.QryInterface.MSG.FEE.AccListDetail).%New()
	...Set AccListDetailObj.Index=No
	...Set AccListDetailObj.PrtDate=PrtDate
	...Set AccListDetailObj.PrtTime=PrtTime
	...Set AccListDetailObj.Type=APType
	...Set AccListDetailObj.TypeFlag=myFlag
	...Set AccListDetailObj.Amt=AccSum
	...Set AccListDetailObj.Left=ALeft
	...Set AccListDetailObj.User=AccUser
	...Set AccListDetailObj.BillNO=ABillNo
	...Set AccListDetailObj.InvNO=myINVNo
	...Set AccListDetailObj.OrderDetails=OrderDetails
	...Set myIdx=+myIdx+1
	...Do RpObj.AccList.Insert(AccListDetailObj)
	...Do AccListDetailObj.%Close()
	;
	Do Output10(ResultCode,ErrorMsg)
	
	Kill ^TMPAccPatList("QueryAccList",$j)
	
	Quit RpStream
	
Output10(ResultCode,ErrorMsg)
	Set RpStream=""
	Set RpObj.ResultCode=ResultCode
	Set RpObj.ErrorMsg=ErrorMsg
	Set RtStream=##class(%GlobalCharacterStream).%New()
	Do RpObj.XMLExportToStream(.RpStream,"Response")
	Set OutputXML=""
	Do RpObj.XMLExportToString(.OutputXML,"Response")
	B ;OutputXML
	
	Quit
	
GetPatAccListET
	Set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	Set streamObj=##class(%GlobalCharacterStream).%New()
	Do streamObj.Write(myrtn)
	Quit streamObj
}

ClassMethod SetPreDepositList(AccRowID As %String = "") As %String
{
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	;w ##class(DHCExternalService.QryInterface.BL.PatientAccList).SetPreDepositList("1")
	q:(AccRowID="") 0
	
	;用于患者的自助查询；提供一个按照时间的循序排序
	;^TMPAccPat("Acc",$j,Date,Time)=rowID
	s myPDSum=0
	s myPDSub=0
	f  s myPDSub=$o(^DHCACD("AccM",AccRowID,"AccPD", myPDSub)) q:(myPDSub="")  d
	.q:($d(^DHCACD("AccM",AccRowID,"AccPD", myPDSub))=10)
	.;序号  交易时间  交易类型  金额  操作员  单据号 余额
	.s myPDDate=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",3)
	.s myPDTime=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",4)
	.s myPreDate=$zd(myPDDate,3)_" "_$zt(myPDTime)
	.s myPDType=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",1)
	.s myPDTypeDesc=""
	.i myPDType="P" d
	..s myPDTypeDesc="缴款"
	.i myPDType="R" d
	..s myPDTypeDesc="退款"
	.i myPDType="F" d
	..s myPDTypeDesc="结算"
	.s myPDSum=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",2)
	.s myUserDesc=""
	.s myUserDR=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",5)
	.s:(myUserDR'="") myUserDesc=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s myBillNum=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",6)
	.s myPDLeft=$p(^DHCACD("AccM",AccRowID,"AccPD", myPDSub),"^",8)
	.;增加一个子节点，防止同一时间；,DHCWeb.OPCommon.js
	.s mySub=""
	.s mySub=$o(^TMPAccPatList("QueryAccList",$j,myPDDate,myPDTime,mySub),-1)
	.s mySub=+$g(mySub)+1
	.s ^TMPAccPatList("QueryAccList",$j,myPDDate,myPDTime, mySub)=myPreDate_"^"_myPDTypeDesc_"^"_myPDSum_"^"_myUserDesc_"^"_myBillNum_"^"_myPDLeft_"^PD^"_AccRowID_"||"_myPDSub
	
	q 0
}

ClassMethod SetPatAccPayList(AccRowID As %String = "") As %String
{
	;把患者的支付设置为一个^TMP ]
	;用来帮助患者自助查询/或打印
	;w ##class(DHCExternalService.QryInterface.BL.PatientAccList).SetPatAccPayList("112")
	q:(AccRowID="") 0
	
	;用于患者的自助查询；提供一个按照时间的循序排序
	;^TMPAccPat("Acc",$j,Date,Time)=rowID
	;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	s myPLSub=0
	s myPaySum=0
	f  s myPLSub=$o(^DHCACD("AccM",AccRowID,"AccPL",myPLSub)) q:(myPLSub="")  d
	.q:($d(^DHCACD("AccM",AccRowID,"AccPL",myPLSub))=10)
	.;序号  交易时间  交易类型  金额  操作员  单据号 
	.s myPLDate=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",6)
	.s myPLTime=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",7)
	.s myDate=$zd(myPLDate,3)_" "_$zt(myPLTime)
	.s myPLPayNum=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",8)
	.i (+myPLPayNum>0) d
	..s myPLTypeDesc="卡支付"
	.e  d
	..s myPLTypeDesc="卡支付退费"
	.s myUserDesc=""
	.s myUserDR=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",5)
	.s:(myUserDR'="") myUserDesc=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s myBillNo=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",4)
	.s myPLLeft=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",9)
	.s myPRTRowID=$p(^DHCACD("AccM",AccRowID,"AccPL",myPLSub),"^",2)		;AccPL_InvPrt_DR
	.s myPRTINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)			;PRT_INVPrintFlag
	.s myINVNo=""
	.i myPRTINVFlag="P" d
	..s myINVNo=$p(^DHCINVPRT(myPRTRowID),"^",14)
	..q:(myINVNo'="")
	..s myAccINVDR=$p(^DHCINVPRT(myPRTRowID),"^",4)
	..q:(myAccINVDR="")
	..s myINVNo=$p(^DHCINVPRTAP(myAccINVDR),"^",6)
	.s myPLRowID=AccRowID_"||"_myPLSub
	.s mySub=""
	.s mySub=$o(^TMPAccPatList("QueryAccList",$j,myPLDate,myPLTime,mySub),-1)
	.s mySub=+$g(mySub)+1
	.s ^TMPAccPatList("QueryAccList",$j,myPLDate,myPLTime, mySub)=myDate_"^"_myPLTypeDesc_"^"_myPLPayNum_"^"_myUserDesc_"^"_myBillNo_"^"_myPLLeft_"^PL^"_myPRTRowID_"^"_myINVNo
	
	q 0
}

ClassMethod GetOrdDetailsByPrtRowID(ReceipRowid)
{
	Set (ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum)=""
	Set selflag=0
	Set Details=""
	
	Set conRowid=0 
	For  Set conRowid=$o(^DHCBCI(0,"INV",ReceipRowid,conRowid)) Quit:conRowid=""  Do
	.Set bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.Set selflag=1
	.Set confac=""
	.Set PBOChildsub=0
	.For  Set PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) Quit:PBOChildsub=""  Do
	..Set Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..Set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	..Set OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..Set Executflag=0
	..Set OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)	;PBO_UnitPrice
	..Set Billreturnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)		;PBO_RefundQty
	..Set OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)		;PBO_BillQty
	..Set returnqty=0
	..Set confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	..If +confac=0  Set confac=1
	..Set OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	..;Set PatSum=OrderUnitPrice*OrderBillQty
	..Set PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	..Set PatSum=$fn(PatSum,"",2)
	..Set myRefSum=PatSum		;;
	..Set recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	..Set recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	..If $l(recdepdesc,"-")>1 Do  Set recdepdesc=$p(recdepdesc,"-",2)
	..Set ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..Set ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..If ARCOrdType="R"  Do
	...;在门诊药房
	...;^DHCPHRETi("NEWPRT",{PHRET_NEWPRT_DR},{PHRET_PHL_DR},{PHRET_ROWID})
	...Set returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI,ReceipRowid)
	...Set confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	...If +confac=0  s confac=1
	...Set returnqty=returnqty/confac
	...If Executflag=0 Do  
	....;药物医嘱?没有发药的
	....Set selflag=0
	...Else  Do
	....;药物医嘱?已经发药的?Executflag=1
	....Set selflag=0
	....;已经退药的
	....If +returnqty'=0 Do  
	.....If OrderBillQty=returnqty Do
	......Set selflag=1		;;全部退
	.....Else  Do
	......Set selflag=1		;;部分退
	.....Set myRefSum=$fn($fn((myRefSum/OrderBillQty),"",6)*returnqty,"",2)
	..else  Do
	...Set OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...Set OrdStatdesc=$p(^OEC("OSTAT",OrdStat),"^",2)
	...If ($p(^OEC("OSTAT",OrdStat),"^",1)="E") d
	....;被执行的非药物医嘱?
	....Set Executflag=1
	....Set selflag=0
	...Else  Do
	....;没有被执行的非药物医嘱?
	....Set Executflag=0
	....Set selflag=0
	..;selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum
	..Set tmp=ArcimDesc_"^"_PatSum_"^"_OrderBillQty_"^"_recdepdesc
	..If Details="" Do
	...Set Details=tmp
	..Else  Do
	...Set Details=Details_"!"_tmp

	Quit Details
}

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

}
