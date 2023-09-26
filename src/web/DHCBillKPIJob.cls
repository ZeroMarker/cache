Import SQLUser

Class web.DHCBillKPIJob Extends BILL.COM.Abstract
{

/// Creator: wangjian
/// CreatDate: 2017-08-03
/// Description: 门诊结算生成固有指标
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillKPIJob).BuildOPHandin("64545", "72000", "64546", "72000", "2", 5, 30874)
ClassMethod BuildOPHandin(StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String, HUser As %String, HISRowId As %String) As %String
{
	set $zt="ERROR"

	set Job=$j
	set InvRoundErr=0
	kill OPHandinArr(Job,HUser)
	
	for Date=StDate:1:EndDate do
	.//门诊消费
	.set PrtRowId=0
	.for  set PrtRowId=$o(^DHCINVPRT(0,"UserDate",HUser,Date,PrtRowId)) quit:(PrtRowId="")  do
	..set PrtData=$g(^DHCINVPRT(PrtRowId))
	..set HospDR=$p(PrtData,"^",39)
	..quit:((HospId'="")&&(HospId'=HospDR))
	..set myFlag=$p(PrtData,"^",8)
	..quit:(myFlag="TP")
	..set myHandin=$p(PrtData,"^",10)
	..quit:(myHandin="Y")
	..set myFairType=$p(PrtData,"^",34)
	..quit:(" F R "'[(" "_myFairType_" "))
	..set myTime=$p(PrtData,"^",20)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set myInsTypeDR=$p(PrtData,"^",9)
	..set myAdmSource=+$p(^PAC("ADMREA",myInsTypeDR),"^",9)
 	..set myPrtAcount=$p(PrtData,"^",1)
	..set myPrintFlag=$p(PrtData,"^",3)
	..set myInitInv=$p(PrtData,"^",13)
	..set myPRTRoundErr=$p(PrtData,"^",37)
	..set InvRoundErr=InvRoundErr+myPRTRoundErr
	..do ..STATtoOPCAT(.OPHandinArr, HUser, PrtRowId, Job)              //生成门诊分类
	..do ..STATtoOPPayM(.OPHandinArr, HUser, PrtRowId, "PRT", Job)
	.//集中打印
	.set AccInv=0
	.for  set AccInv=$o(^DHCINVPRTAPi(0,"UserDate",HUser,Date,AccInv))  quit:(AccInv="")  do
	..set AccInvData=$g(^DHCINVPRTAP(AccInv))
	..set HospDR=$p(AccInvData,"^",30)                     //API_Hospital_DR
    ..quit:((HospId'="")&&(HospId'=HospDR))
    ..set myHandin=$p(AccInvData,"^",33)
    ..quit:(myHandin="Y")
    ..set myRepDr=$p(AccInvData,"^",20)
    ..quit:(+myRepDr'=0)                                    //API_INVRep_DR
	..set myTime=$p(AccInvData,"^",4)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set Flag=$p(AccInvData,"^",2)
	..set myPrtInvNo=$p(AccInvData,"^",6)
	..set myPrtAcount=$p(AccInvData,"^",1)
	..set myInitInv=$p(AccInvData,"^",10)
	..set myInsTypeDR=$p(AccInvData,"^",31)
	..set myAdmSrc=+$p(^PAC("ADMREA",myInsTypeDR),"^",9)
	..quit:(+myAdmSrc=0)                              //只取集中打印调用医保
	..set PRTInsuFlag=..CheckAPIConPRTInsu(AccInv)   //负发票关联仍为正消费记录
	..quit:(PRTInsuFlag="Y")                          //消费记录已调用医保过滤掉
	..do ..STATtoOPPayM(.OPHandinArr, HUser, AccInv, "API", Job)
	.//统计押金信息
    .set AccRowId=0
    .for  set AccRowId=$o(^DHCACDi("AccM",0,"User",HUser,Date,AccRowId)) quit:(AccRowId="")  do
    ..set ChildSub=0
    ..for  set ChildSub=$o(^DHCACDi("AccM",0,"User",HUser,Date,AccRowId,"AccPD",ChildSub)) quit:(ChildSub="")  do
    ...set AccPreDepData=$g(^DHCACD("AccM",AccRowId,"AccPD",ChildSub))
    ...set HospDR=$p(AccPreDepData,"^",15)
    ...quit:((HospId'="")&&(HospId'=HospDR))
    ...set myHandin=$p(AccPreDepData,"^",16)
	...quit:(myHandin="Y")
    ...set PrtJKDr=$p(AccPreDepData,"^",7)   //AccPD_PDFoot_DR
    ...quit:(+PrtJKDr'=0)
    ...set myTime=$p(AccPreDepData,"^",4)
    ...//quit:((Date=StDate)&&(myTime<StTime))
	...quit:((Date=EndDate)&&(myTime>EndTime))
	...set PapmiRowid=$p(^DHCACD("AccM",AccRowId),"^",2)
    ...quit:(PapmiRowid="")
    ...quit:($d(^PAPER(PapmiRowid))=0)
    ...set AcBillNo=$p(AccPreDepData,"^",6)   //AccPD_BillNum 票据号
    ...set PrtStatus=$p(AccPreDepData,"^",1)  //AccPD_Type
    ...do ..STATtoOPPayM(.OPHandinArr, HUser, AccRowId_"||"_ChildSub, "PD", Job)
	.//卡发票表
	.set CardInv=0
	.for  set CardInv=$o(^DHCCARDINVPRTi(0,"UserDate",HUser,Date,CardInv)) quit:(CardInv="")  do
	..set CardInvData=$g(^DHCCARDINVPRT(CardInv))
	..set HospDR=$p(CardInvData,"^",20)
    ..quit:((HospId'="")&&(HospDR'=HospId))
    ..set myHandin=$p(CardInvData,"^",21)
	..quit:(myHandin="Y")
	..set CardReprtDr=$p(CardInvData,"^",9)
	..quit:(+CardReprtDr'=0)
	..set myTime=$p(CardInvData,"^",5)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set myCardSum=+$p(CardInvData,"^",3)
	..do ..STATtoOPPayM(.OPHandinArr, HUser, CardInv, "CARD", Job)
	.//留观押金
	.set EPMRowId=0
	.for  set EPMRowId=$o(^DHCEPMi("EPM",0,"EPMDUserDate",HUser,"Date",Date,EPMRowId))  quit:(EPMRowId="")  do
	..set ChildSub=0
    ..for  set ChildSub=$o(^DHCEPMi("EPM",0,"EPMDUserDate",HUser,"Date",Date,EPMRowId,"EPMD",ChildSub)) quit:(ChildSub="")  do
	...set EPPMDepData=$g(^DHCEPM("EPM",EPMRowId,"EPMD",ChildSub))
	...quit:(EPPMDepData="")
    ...set HospDR=$p(EPPMDepData,"^",13)
    ...quit:((HospId'="")&&(HospId'=HospDR))
    ...set myHandin=$p(EPPMDepData,"^",21)
	...quit:(myHandin="Y")
    ...set PrtJKDr=$p(EPPMDepData,"^",7)     //EPMD_Report_DR
    ...quit:(+PrtJKDr'=0)
    ...set myTime=$p(EPPMDepData,"^",4)
    ...//quit:((Date=StDate)&&(myTime<StTime))
	...quit:((Date=EndDate)&&(myTime>EndTime))
	...set EPPMRowId=EPMRowId_"||"_ChildSub
    ...do ..STATtoOPPayM(.OPHandinArr, HUser, EPPMRowId, "EPD", Job)
	
	set rtn=0
	
	ts
	
	set ChargeType="OP"
	set rtn=..SaveReportsInfo(.OPHandinArr, Job, HUser, HISRowId, ChargeType)
	if (+rtn) tro  quit rtn
	
	&SQL(
		UPDATE DHC_INVPRTReports
		SET HIS_INVRoundSum = :InvRoundErr
		WHERE %ID = :HISRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: wangjian
/// CreatDate: 2014-08-26
/// Debug: w ##class(web.DHCOPBillDailyHandin).STATtoOPPayM(1,3068419,"PRT")
ClassMethod STATtoOPPayM(OPHandinArr, HUser, RowId, SFlag, Job)
{
	//结算
	if (SFlag="PRT") do
	.set INVInsType=$p(^DHCINVPRT(RowId),"^",9)
	.set PaySub=0
	.for  set PaySub=$o(^DHCINVPRT(RowId,"P",PaySub))  quit:(PaySub="")  do
	..set PaymDr=$p(^DHCINVPRT(RowId,"P",PaySub),"^",1)
	..quit:+PaymDr=0
	..set PaymSum=$p($g(^DHCINVPRT(RowId,"P",PaySub)),"^",3)
	..if (PaymSum'<0)  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1))+1
	
	//集中打印发票
	if (SFlag="API") do
	.set INVInsType=$p(^DHCINVPRTAP(RowId),"^",31)
	.set PaySub=0
	.for  set PaySub=$o(^DHCINVPRTAP(RowId,"P",PaySub))  quit:(PaySub="")  do
	..set PaymDr=$p($g(^DHCINVPRTAP(RowId,"P",PaySub)),"^",1)
	..quit:(+PaymDr=0)
	..set PaymSum=$p($g(^DHCINVPRTAP(RowId,"P",PaySub)),"^",3)
	..if (PaymSum'<0)  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1))+1
	
	//卡费
	if (SFlag="CARD") do
	.set PaySub=0
    .for  set PaySub=$o(^DHCCARDINVPRT(RowId,"P",PaySub))  quit:(PaySub="")  do
    ..set PaymDr=$p(^DHCCARDINVPRT(RowId,"P",PaySub),"^",1)
    ..quit:(+PaymDr=0)
    ..set PaymSum=$p($g(^DHCCARDINVPRT(RowId,"P",PaySub)),"^",3)
    ..if (PaymSum'<0)  do
    ...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	
	//门诊预交金
	if (SFlag="PD") do
	.set AccRowId=+RowId, AccSub=+$p(RowId,"||",2)
	.set PayModeChildSub=0
    .for  set PayModeChildSub=$o(^DHCACD("AccM",AccRowId,"AccPD",AccSub,"P",PayModeChildSub)) quit:(PayModeChildSub="")  do
    ..set PaymDr=$p(^DHCACD("AccM",AccRowId,"AccPD",AccSub,"P",PayModeChildSub),"^",1)
    ..quit:(+PaymDr=0)
    ..set PaymSum=+$p(^DHCACD("AccM",AccRowId,"AccPD",AccSub,"P",PayModeChildSub),"^",6)
	..if (PaymSum'<0)  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	
	//留观押金
	if (SFlag="EPD") do
	.set EPMRowId=+RowId
	.set EPMSub=+$p(RowId,"||",2)
	.set PayModeChildSub=0
    .for  set PayModeChildSub=$o(^DHCEPM("EPM",EPMRowId,"EPMD",EPMSub,"P",PayModeChildSub)) quit:(PayModeChildSub="")  do
    ..set PaymDr=$p(^DHCEPM("EPM",EPMRowId,"EPMD",EPMSub,"P",PayModeChildSub),"^",1)
    ..quit:(+PaymDr=0)
    ..set PaymSum=+$p(^DHCEPM("EPM",EPMRowId,"EPMD",EPMSub,"P",PayModeChildSub),"^",6)
	..if (PaymSum'<0)  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	
	quit
}

/// OPHandinArr(Job,HUser,"ItmCat")
/// 把一张票据累加到门诊收费大类或子类
ClassMethod STATtoOPCAT(OPHandinArr, HUser, PrtRowId, Job)
{
	set INVInsType=$p(^DHCINVPRT(PrtRowId),"^",9)
	set BillConInv=0
	for  set BillConInv=$o(^DHCBCI(0,"INV",PrtRowId,BillConInv)) quit:(BillConInv="")  do
	.set PB=$p(^DHCBCI(BillConInv),"^",2)
	.set PBO=0
	.for  set PBO=$o(^DHCPB(PB,"O",PBO)) quit:(PBO="")  do
	..quit:($d(^DHCPB(PB,"O",PBO))=10)
	..set PBD=0
	..for  set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD)) quit:(PBD="")  do
	...set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
	...set ItmDR=$p(PBDData,"^",3)
	...set TotalAmount=+$p(PBDData,"^",7)
	...set DiscAmount=+$p(PBDData,"^",8)
	...set PayorShare=+$p(PBDData,"^",9)
	...set PatientShare=+$p(PBDData,"^",10)
	...//门诊发票子类金额
	...set ItmOPSubCat=$p(^DHCTARI(ItmDR),"^",15)
	...quit:(+ItmOPSubCat=0)
	...set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...quit:(+ItmOPCat=0)
	...set MyItmOPCat=$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",1)
	...set MyChargeAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",2)					;门诊发票子类总金额
	...set MyRefAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",3)
	...set MyDiscAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",4)       			;门诊发票子类折扣金额
	...set MyPayorAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",5)       			;门诊发票子类记账金额
	...set MyPatShareAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat)),"^",6)       		;门诊发票子类自付金额
	...if (MyItmOPCat="") set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",1)=ItmOPCat
	...if (TotalAmount'<0) set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",2)=MyChargeAmt+TotalAmount 
	...else  set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",3)=MyRefAmt+TotalAmount 
	...set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",4)=MyDiscAmt+DiscAmount
	...set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",5)=MyPayorAmt+PayorShare
	...set $p(OPHandinArr(Job,HUser,"ItmCat","OP",INVInsType,ItmOPSubCat),"^",6)=MyPatShareAmt+PatientShare
	...//会计子类
	...set ItmACSubCat=$p(^DHCTARI(ItmDR),"^",5)
	...quit:(+ItmACSubCat=0)
	...set ItmACCat=$p(^DHCTarC("AC",ItmACSubCat),"^",3)
	...quit:(+ItmACCat=0)
	...set MyItmACCat=$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",1)
	...set MyChargeAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",2)					;门诊发票子类总金额
	...set MyRefAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",3)
	...set MyDiscAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",4)       			;门诊发票子类折扣金额
	...set MyPayorAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",5)       			;门诊发票子类记账金额
	...set MyPatShareAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat)),"^",6)       		;门诊发票子类自付金额
	...if (MyItmACCat="") set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",1)=ItmACCat
	...if (TotalAmount'<0) set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",2)=MyChargeAmt+TotalAmount 
	...else  set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",3)=MyRefAmt+TotalAmount
	...set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",4)=MyDiscAmt+DiscAmount
	...set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",5)=MyPayorAmt+PayorShare
	...set $p(OPHandinArr(Job,HUser,"ItmCat","AC",INVInsType,ItmACSubCat),"^",6)=MyPatShareAmt+PatientShare	
	
	quit
}

/// Creator: wangjian
/// CreatDate: 2017-08-03
/// Description: 判断消费记录是否医保分解
/// Input: 
/// Return: N:未分解, Y:已分解
/// Debug: w ##class(web.DHCBillKPIJob).CheckAPIConPRTInsu(21316)
ClassMethod CheckAPIConPRTInsu(APIRowID As %String) As %String
{
	set rtn="N"
	set AccConPrtDr=0
	for  set AccConPrtDr=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,AccConPrtDr)) quit:(AccConPrtDr="")  do
	.set InvRowID=$p(^DHCINVPRTCAP(AccConPrtDr),"^",1)
	.set InsuDivDR=$p(^DHCINVPRT(InvRowID),"^", 30)
	.if (+InsuDivDR'=0) set rtn="Y"
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-10-19
/// Description: 科室卡消费自动任务结算生成固有指标
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillKPIJob).BuildDeptAccPayHandin("64524", "0", "64527", "0", "2", 5, 30030)
ClassMethod BuildDeptAccPayHandin(stDate As %String, stTime As %String, endDate As %String, endTime As %String, hospId As %String, guser As %String, HISRowID As %String) As %String
{
	set $zt="ERROR"

	set job=$j
	kill OPHandinArr(job,guser)
	
	for date=stDate:1:endDate do
	.//门诊消费
	.set prtRowID=0
	.for  set prtRowID=$o(^DHCINVPRT(0,"Date",date,prtRowID)) quit:(prtRowID="")  do
	..set prtData=$g(^DHCINVPRT(prtRowID))
	..set hospDR=$p(prtData,"^",39)
	..quit:((hospId'="")&&(hospId'=hospDR))
	..set prtUserDR=$p(prtData,"^",21)
	..set isCashier=##class(web.UDHCJFBaseCommon).CheckISCashier(prtUserDR, hospDR)
	..quit:(+isCashier=0)                         //收费员退出
	..set prtFlag=$p(prtData,"^",8)
	..quit:(prtFlag="TP")
	..set handinFlag=$p(prtData,"^",10)
	..quit:(handinFlag="Y")
	..set prtTime=$p(prtData,"^",20)
	..//quit:((date=stDate)&&(prtTime<stTime))
	..quit:((date=endDate)&&(prtTime>endTime))
	..set myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(prtRowID)
	..set myPRTNo=$p(myCKPRTNO,"^",1)
	..quit:(myPRTNo'="")			                         	    //如果打印发票退出
	..set myPRTRoundErr=$p(prtData,"^",37)						    //分币误差
	..do ..STATtoOPCAT(.OPHandinArr, guser,prtRowID, job)           //生成门诊分类
	..do ..STATtoOPPayM(.OPHandinArr, guser, prtRowID, "PRT", job)
	
	ts
	
	set rtn=..SaveReportsInfo(.OPHandinArr, job, guser, HISRowID)
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc

	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-10-21
/// Description: 插入门诊日结账信息(将事物放到调用方法中)
/// Input: 
/// Return: 
ClassMethod SaveReportsInfo(OPHandinArr, job, guser, HISRowID, ChargeType As %String = "OP") As %String
{
	set rtn=0
	//插入门诊子类及会计子类(DHC_INVPRTReportsSub)
	set type=""
	while($o(OPHandinArr(job,guser,"ItmCat",type))'="") {
		set type=$o(OPHandinArr(job,guser,"ItmCat",type))
		set insType=0
		while($o(OPHandinArr(job,guser,"ItmCat",type,insType))) {
			set insType=$o(OPHandinArr(job,guser,"ItmCat",type,insType))
			set subCate=0
			while($o(OPHandinArr(job,guser,"ItmCat",type,insType,subCate))) {
				set subCate=$o(OPHandinArr(job,guser,"ItmCat",type,insType,subCate))
				set cateInfo=$g(OPHandinArr(job,guser,"ItmCat",type,insType,subCate))
				set cate=$p(cateInfo,"^",1)
				set payAmt=$p(cateInfo,"^",2)
				set refAmt=$p(cateInfo,"^",3)
				set discAmt=$p(cateInfo,"^",4)
				set payorShareAmt=$p(cateInfo,"^",5)
				set patShareAmt=$p(cateInfo,"^",6)
				&SQL(
					INSERT INTO DHC_INVPRTReportsSub (
						HisSub_ParRef, HisSub_Cat_DR, HisSub_InsType_DR, HisSub_SubCat_DR, HisSub_TarSubjectType,
						HisSub_PaySum, HisSub_RefundSum, HisSub_DiscSum, HisSub_PayorShareSum, HisSub_PatShareSum
					)
					VALUES (
						:HISRowID, :cate, :insType, :subCate, :type,
						ROUND(:payAmt,2), ROUND(:refAmt,2), ROUND(:discAmt,2), ROUND(:payorShareAmt,2), ROUND(:patShareAmt,2)
					)
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=SQLCODE_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	quit:(+rtn) rtn
	
	//插入支付方式子表(DHC_INVPRTReportsPaymode)
	set paymDR=0
	while($o(OPHandinArr(job,guser,"PayM",paymDR))) {
		set paymDR=$o(OPHandinArr(job,guser,"PayM",paymDR))
		set prtPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PRT","收"))
		set prtPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PRT","收",1))
		set prtRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PRT","退"))
		set prtRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PRT","退",1))
		set apiPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"API","收"))
		set apiPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"API","收",1))
		set apiRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"API","退"))
		set apiRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"API","退",1))
		set accPDPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PD","收"))
		set accPDPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PD","收",1))
		set accPDRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PD","退"))
		set accPDRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"PD","退",1))
		set cardPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"CARD","收"))
		set cardPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"CARD","收",1))
		set cardRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"CARD","退"))
		set cardRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"CARD","退",1))
		//留观押金
		set EPDPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"EPD","收"))
		set EPDPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"EPD","收",1))
		set EPDRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"EPD","退"))
		set EPDRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"EPD","退",1))
		//代金卡
		set giftCardPaySum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"GCARD","收"))
		set giftCardPayNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"GCARD","收",1))
		set giftCardRefundSum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"GCARD","退"))
		set giftCardRefundNum=+$g(OPHandinArr(job,guser,"PayM",paymDR,"GCARD","退",1))
		&SQL(
			INSERT INTO DHC_INVPRTReportsPaymode (
				HisPay_ParRef, HisPay_Paymode, HisPay_PRTPaySum, HisPay_PRTPayNum, HisPay_PRTRefundSum,
				HisPay_PRTRefundNum, HisPay_APIPaySum, HisPay_APIPayNum, HisPay_APIRefundSum, HisPay_APIRefundNum,
				HisPay_PRDGetSum, HisPay_PRDGetNum, HisPay_PRDParkSum, HisPay_PRDParkNum, HisPay_CardPaySum,
				HisPay_CardPayNum, HisPay_CardRefundSum, HisPay_CardRefundNum, HisPay_EPDGetSum, HisPay_EPDGetNum,
				HisPay_EPDParkSum, HisPay_EPDParkNum, HisPay_ChargeType, HisPay_GiftCardPaySum, HisPay_GiftCardPayNum,
				HisPay_GiftCardRefundSum, HisPay_GiftCardRefundNum
			)
			VALUES (
				:HISRowID, :paymDR, ROUND(:prtPaySum,2), :prtPayNum, ROUND(:prtRefundSum,2),
				:prtRefundNum, ROUND(:apiPaySum,2), :apiPayNum, ROUND(:apiRefundSum,2), :apiRefundNum,
				ROUND(:accPDPaySum,2), :accPDPayNum, ROUND(:accPDRefundSum,2), :accPDRefundNum, ROUND(:cardPaySum,2),
				:cardPayNum, ROUND(:cardRefundSum,2), :cardRefundNum, ROUND(:EPDPaySum,2), :EPDPayNum,
				ROUND(:EPDRefundSum,2), :EPDRefundNum, :ChargeType, ROUND(:giftCardPaySum,2), :giftCardPayNum,
				ROUND(:giftCardRefundSum,2), :giftCardRefundNum
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=SQLCODE_"^"_$g(%msg)
			quit
		}
	}
	quit:(+rtn) rtn
	
	//病人费别对应的支付方式(DHC_INVPRTReportsInsType)
	set insTypeDR=0
	while($o(OPHandinArr(job,guser,"InsPayM",insTypeDR))) {
		set insTypeDR=$o(OPHandinArr(job,guser,"InsPayM",insTypeDR))
		set paymDR=0
		while($o(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR))) {
			set paymDR=$o(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR))
			set prtPaySum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"PRT","收"))
			set prtPayNum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"PRT","收",1))
			set prtRefundSum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"PRT","退"))
			set prtRefundNum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"PRT","退",1))
			set apiPaySum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"API","收"))
			set apiPayNum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"API","收",1))
			set apiRefundSum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"API","退"))
			set apiRefundNum=+$g(OPHandinArr(job,guser,"InsPayM",insTypeDR,paymDR,"API","退",1))
			&SQL(
				INSERT INTO DHC_INVPRTReportsInsType (
					ITC_Rep_ParRef, ITC_InsType_DR, ITC_Paymode_DR, ITC_PRTPaySum, ITC_PRTPayNum,
					ITC_PRTRefundSum, ITC_PRTRefundNum, ITC_APIPaySum, ITC_APIPayNum, ITC_APIRefundSum,
					ITC_APIRefundNum, ITC_ChargeType
				)
				VALUES (
					:HISRowID, :insTypeDR, :paymDR, ROUND(:prtPaySum,2), :prtPayNum,
					ROUND(:prtRefundSum,2), :prtRefundNum, ROUND(:apiPaySum,2), :apiPayNum, ROUND(:apiRefundSum,2),
					:apiRefundNum, :ChargeType
				)
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=SQLCODE_"^"_$g(%msg)
				quit
			}
		}
	}
	quit:(+rtn) rtn
	
	quit rtn
}

/// Creator: wangjian
/// CreatDate: 2018-05-28
/// Description: 体检结算指标
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillKPIJob).BuildOPHandin("64545", "72000", "64546", "72000", "2", 5, 30874)
ClassMethod BuildPEHandin(StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String, HUser As %String, HISRowId As %String) As %String
{
	set $zt="ERROR"

	set Job=$j
	set InvRoundErr=0
	set InvRoundIntSum=0
	kill OPHandinArr(Job,HUser)

	for Date=StDate:1:EndDate do
	.//体检发票
	.set PEIRowID=0
	.for  set PEIRowID=$o(^DHCPEINVPRT(0,"USER",HUser,Date,PEIRowID)) quit:(PEIRowID="")  do
	..set PEIData=$g(^DHCPEINVPRT(PEIRowID))
	..set PEIRepDR=$p(PEIData,"^",13)
	..quit:(+PEIRepDR'=0)
	..set HospDR=$p(PEIData,"^",26)
	..quit:((HospId'="")&&(HospId'=HospDR))
	..set PEITime=$p(PEIData,"^",12)
	..quit:((Date=EndDate)&&(PEITime>EndTime))
	..set PEBill=$p(PEIData,"^",3)
	..set PEAdm=$p(PEIData,"^",2)
	..set myInitInv=$p(PEIData,"^",9)
	..if (myInitInv'="") do  //体检发票负记录
	...set myInsTypeDR=$p($g(^DHCPEOEITEM(myInitInv)),"^",6)
	..else  do
	...set myInsTypeDR=$p($g(^DHCPEOEITEM(PEIRowID)),"^",6)
	..if (myInsTypeDR="") set myInsTypeDR=##class(web.DHCBillCons).ReadDefInsType(HospDR)
	..set myAdmSource=+$p(^PAC("ADMREA",myInsTypeDR),"^",9)
 	..set myPrtAcount=$p(PEIData,"^",7)
	..set myPRTRoundErr=$p(PEIData,"^",21)
	..set InvRoundErr=$i(InvRoundErr, myPRTRoundErr)
	..set myPrtInvNo=$p(PEIData,"^",1)
	..quit:(myPrtInvNo["DHCPEYJS")    //过滤预结算记录
	..set myFlag=$p(PEIData,"^",8)
	..do ..STATtoPECAT(.OPHandinArr, HUser, PEIRowID, Job)               //生成门诊分类
	..do ..STATtoPEPayM(.OPHandinArr, HUser, PEIRowID, "PRT", Job)
	..set InvRoundIntSum=InvRoundIntSum+(##class(web.DHCPE.DHCPEToOPBillInterface).GetRoundingFeeByInvPrt(PEIRowID))
	.//体检集中打印
	.//set PEIFRowID=0
	.//for  set PEIFRowID=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",HUser,Date,PEIFRowID)) quit:(PEIFRowID="")  do
	.//.set PEIFData=$g(^User.DHCPEINVFocusPrtD(PEIFRowID))
	.//.set PEIFRepDR=$lg(PEIFData,8)
	.//.quit:(+PEIFRepDR'=0)
	.//.set PEIFHospDR=$lg(PEIFData,12)
	.//.quit:((HospId'="")&&(HospId'=PEIFHospDR))
	.//.set PEIFDate=$lg(PEIFData,5)
	.//.set PEIFTime=$lg(PEIFData,6)
	.//.quit:((PEIFDate=EndDate)&&(PEIFTime>EndTime))
	.//.set myPrtInvNo=$lg(PEIFData,3)
	.//体检账户表
	.set PEAPRowID=0
	.for  set PEAPRowID=$o(^DHCPEAP(0,"UserDate",HUser,Date,PEAPRowID)) quit:(PEAPRowID="")  do
	..set APType=$p(^DHCPEAP(PEAPRowID),"^",3)   //("R":预缴金，"I":贵宾卡，"O":折扣卡，"C":代金卡)
	..set SFlag=$case(APType,"R":"PD","C":"GCARD",:"")
	..quit:(SFlag="")      //标准版目前只使用预缴金和代金卡
	..set APSub=0
	..for  set APSub=$o(^DHCPEAP(0,"UserDate",HUser,Date,PEAPRowID,APSub)) quit:(APSub="")  do
	...set PEAPData=$g(^DHCPEAP(PEAPRowID,"AC",APSub))
	...set APACRowID=PEAPRowID_"||"_APSub
	...set PEAPRepDR=$p(PEAPData,"^",9)
	...quit:(+PEAPRepDR'=0)
	...set HospDR=$p(PEAPData,"^",15)
	...quit:((HospId'="")&&(HospId'=HospDR))
	...set PEAPType=$p(PEAPData,"^",1)
	...quit:(" B R RF "'[(" "_PEAPType_" "))
	...set PEAPDate=$p(PEAPData,"^",5)
	...set PEAPTime=$p(PEAPData,"^",6)
	...quit:((PEAPDate=EndDate)&&(PEAPTime>EndTime))
	...do ..STATtoPEPayM(.OPHandinArr, HUser, APACRowID, SFlag, Job)
	
	ts
	
	set rtn=..SaveReportsInfo(.OPHandinArr, Job, HUser, HISRowId, "PE")
	if (+rtn) tro  quit rtn
	
	&SQL(
		UPDATE DHC_INVPRTReports
		SET HIS_PEINVRoundSum = :InvRoundErr, HIS_PEINVRoundIntSum = :InvRoundIntSum
		WHERE %ID = :HISRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// wangjian
/// 2014-08-26
/// w ##class(web.DHCOPBillDailyHandin).STATtoOPPayM(1,3068419,"PRT")
ClassMethod STATtoPEPayM(OPHandinArr, HUser, RowId, SFlag, Job)
{
	//体检发票
	if (SFlag="PRT") do
	.set PEBill=$p(^DHCPEINVPRT(RowId),"^",3)
	.//set INVInsType=$p(^DHCPB(PEBill),"^",4)  //取就诊or账单费别?
	.set HospDR=$p(^DHCPEINVPRT(RowId),"^",26)
	.set myInitInv=$p(^DHCPEINVPRT(RowId),"^",9)
	.if (myInitInv'="") do   //体检发票负记录
	..set INVInsType=$p($g(^DHCPEOEITEM(myInitInv)),"^",6)
	.else  do
	..set INVInsType=$p($g(^DHCPEOEITEM(RowId)),"^",6)
	.if (INVInsType="") set INVInsType=##class(web.DHCBillCons).ReadDefInsType(HospDR)
	.set ARRCPDR=$p(^DHCPEINVPRT(RowId),"^",4)
	.set PaySub=0
	.for  set PaySub=$o(^ARRCP(ARRCPDR,"PAYM",PaySub)) quit:(PaySub="")  do
	..set PaymData=$g(^ARRCP(ARRCPDR,"PAYM",PaySub))
	..set PaymDr=$p(PaymData,"^",1)
	..set PaymSum=$p(PaymData,"^",3)
	..if (PaymSum'<0)  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"收",1))+1
	..else  do
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退"))+PaymSum
	...set OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"InsPayM",INVInsType,PaymDr,SFlag,"退",1))+1
	
	//体检预交金
	if (" PD GCARD "[(" "_SFlag_" ")) do
	.set PEAPRowID=+RowId, APSub=+$p(RowId,"||",2)
	.set PaymDr=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",10)
    .quit:(+PaymDr=0)
    .set PaymSum=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",2)
	.if (PaymSum'<0)  do
	..set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收"))+PaymSum
	..set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"收",1))+1
	.else  do
	..set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退")=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退"))+PaymSum
	..set OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1)=$g(OPHandinArr(Job,HUser,"PayM",PaymDr,SFlag,"退",1))+1
	
	quit
}

ClassMethod STATtoPECAT(OPHandinArr, HUser, PRTRowID, Job)
{
	set PEBill=$p(^DHCPEINVPRT(PRTRowID),"^",3)
	//set INVInsType=$p(^DHCPB(PEBill),"^",4)    //取就诊or账单费别?
	set HospDR=$p(^DHCPEINVPRT(PRTRowID),"^",26)
	set myInitInv=$p(^DHCPEINVPRT(PRTRowID),"^",9)
	if (myInitInv'="") do   //体检发票负记录
	.set INVInsType=$p($g(^DHCPEOEITEM(myInitInv)),"^",6)
	else  do
	.set INVInsType=$p($g(^DHCPEOEITEM(PRTRowID)),"^",6)
	if (INVInsType="") set INVInsType=##class(web.DHCBillCons).ReadDefInsType(HospDR)
	
	set Rate=1, TMPPRTRowID=PRTRowID
	set InitID=$p(^DHCPEINVPRT(PRTRowID),"^",9)
	if (InitID'="") do 
	.set Rate=-1
	.set TMPPRTRowID=InitID
	
	set PreItemID=0
	for  set PreItemID=$o(^DHCPEOEITEM(TMPPRTRowID,"OEITEM",PreItemID)) quit:(PreItemID="")  do
	.set TARITEMSub=0
	.for  set TARITEMSub=$o(^DHCPEOEITEM(TMPPRTRowID,"OEITEM",PreItemID,"TARITEM",TARITEMSub)) quit:(TARITEMSub="")  do
	..set Info=$g(^DHCPEOEITEM(TMPPRTRowID,"OEITEM",PreItemID,"TARITEM",TARITEMSub))
	..set ItmDR=$p(Info,"^",1)
	..//set Qty=$p(Info,"^",3)
	..//set Price=$p(Info,"^",2)*Rate
	..set TotalAmount=$p(Info,"^",4)*Rate
	..set DiscAmount=0
	..set PayorShare=0
	..set PatientShare=TotalAmount
	..//门诊发票子类金额
	..set ItmOPSubCat=$p(^DHCTARI(ItmDR),"^",15)
	..quit:(+ItmOPSubCat=0)
	..set ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	..quit:(+ItmOPCat=0)
	..set MyItmOPCat=$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",1)
	..set MyChargeAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",2)					;门诊发票子类总金额
	..set MyRefAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",3)
	..set MyDiscAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",4)       			;门诊发票子类折扣金额
	..set MyPayorAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",5)       			;门诊发票子类记账金额
	..set MyPatShareAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat)),"^",6)       		;门诊发票子类自付金额
	..if (MyItmOPCat="") set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",1)=ItmOPCat
	..if (Rate=1) set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",2)=MyChargeAmt+TotalAmount 
	..else  set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",3)=MyRefAmt+TotalAmount 
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",4)=MyDiscAmt+DiscAmount
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",5)=MyPayorAmt+PayorShare
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEOP",INVInsType,ItmOPSubCat),"^",6)=MyPatShareAmt+PatientShare
	..//会计子类
	..set ItmACSubCat=$p(^DHCTARI(ItmDR),"^",5)
	..quit:(+ItmACSubCat=0)
	..set ItmACCat=$p(^DHCTarC("AC",ItmACSubCat),"^",3)
	..quit:(+ItmACCat=0)
	..set MyItmACCat=$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",1)
	..set MyChargeAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",2)					;门诊发票子类总金额
	..set MyRefAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",3)
	..set MyDiscAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",4)       			;门诊发票子类折扣金额
	..set MyPayorAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",5)       			;门诊发票子类记账金额
	..set MyPatShareAmt=+$p($g(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat)),"^",6)       		;门诊发票子类自付金额
	..if (MyItmACCat="") set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",1)=ItmACCat
	..if (Rate=1) set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",2)=MyChargeAmt+TotalAmount 
	..else  set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",3)=MyRefAmt+TotalAmount
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",4)=MyDiscAmt+DiscAmount
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",5)=MyPayorAmt+PayorShare
	..set $p(OPHandinArr(Job,HUser,"ItmCat","PEAC",INVInsType,ItmACSubCat),"^",6)=MyPatShareAmt+PatientShare
	
	quit
}

ClassMethod BuildInvNoInfo(StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String, HUser As %String, HISRowId As %String) As %String
{
	set $zt="ERROR"
	
	set Job=$j
	do KillTMP
	
	for Date=StDate:1:EndDate do
	.//门诊消费
	.set PrtRowId=0
	.for  set PrtRowId=$o(^DHCINVPRT(0,"UserDate",HUser,Date,PrtRowId)) quit:(PrtRowId="")  do
	..set PrtData=$g(^DHCINVPRT(PrtRowId))
	..set HospDR=$p(PrtData,"^",39)
	..quit:((HospId'="")&&(HospId'=HospDR))
	..set myFlag=$p(PrtData,"^",8)
	..quit:(myFlag="TP")
	..set myHandin=$p(PrtData,"^",10)
	..quit:(myHandin="Y")
	..set myTime=$p(PrtData,"^",20)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set myPrintFlag=$p(PrtData,"^",3)
    ..//quit:(myPrintFlag'="P")   									//卡消费时是否打印发票
	..set myInitInv=$p(PrtData,"^",13)
	..set myPrtInvNo=$p(PrtData,"^",14)
	..if (myPrtInvNo'="") do
	...set ^TMP("OPBILL","INVNO",HUser,Job,myPrtInvNo)=""
	...set ^TMP("OPBILL","INVNUM",HUser,Job)=$g(^TMP("OPBILL","INVNUM",HUser,Job))+1
	..if (myInitInv'="")  do
	...set InitInvNo=$p(^DHCINVPRT(myInitInv),"^",14)
	...if (myFlag="A") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=myPrtInvNo
	.....else  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=$g(^TMP("OPBILL","PARKINV",HUser,Job))_","_myPrtInvNo //负记录有票号
	.....set ^TMP("OPBILL","PARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PARKINV",HUser,Job,1))+1
	....if (InitInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=$g(^TMP("OPBILL","PARKINV",HUser,Job))_","_InitInvNo //退费收回的发票
	.....set ^TMP("OPBILL","PARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PARKINV",HUser,Job,1))+1
	...if (myFlag="S") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","RefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=myPrtInvNo
	.....else  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=$g(^TMP("OPBILL","RefINV",HUser,Job))_","_myPrtInvNo //负记录有票号
	.....set ^TMP("OPBILL","RefINV",HUser,Job,1)=$g(^TMP("OPBILL","RefINV",HUser,Job,1))+1
	....if (InitInvNo'="") do
	.....if ('$d(^TMP("OPBILL","RefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=$g(^TMP("OPBILL","RefINV",HUser,Job))_","_InitInvNo  //退费收回的发票
	.....set ^TMP("OPBILL","RefINV",HUser,Job,1)=$g(^TMP("OPBILL","RefINV",HUser,Job,1))+1
	.//集中打印
	.set AccInv=0
	.for  set AccInv=$o(^DHCINVPRTAPi(0,"UserDate",HUser,Date,AccInv))  quit:(AccInv="")  do
	..set AccInvData=$g(^DHCINVPRTAP(AccInv))
	..set HospDR=$p(AccInvData,"^",30)                                            //API_Hospital_DR
    ..quit:((HospId'="")&&(HospId'=HospDR))
    ..set myHandin=$p(AccInvData,"^",33)
    ..quit:(myHandin="Y")
    ..set myRepDr=$p(AccInvData,"^",20)
    ..quit:(+myRepDr'=0)                                                                         //API_INVRep_DR
	..set myTime=$p(AccInvData,"^",4)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set Flag=$p(AccInvData,"^",2)
	..set myPrtInvNo=$p(AccInvData,"^",6)
	..set myPrtAcount=$p(AccInvData,"^",1)
	..set myInitInv=$p(AccInvData,"^",10)
	..if (myPrtInvNo'="") do
	...set ^TMP("OPBILL","INVNO",HUser,Job,myPrtInvNo)=""
	...set ^TMP("OPBILL","INVNUM",HUser,Job)=$g(^TMP("OPBILL","INVNUM",HUser,Job))+1
	..if (myInitInv'="")  do
	...set InitInvNo=$p(^DHCINVPRTAP(myInitInv),"^",6)
	...if (Flag="A") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=myPrtInvNo                                        //负记录有票号
	.....else  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=$g(^TMP("OPBILL","PARKINV",HUser,Job))_","_myPrtInvNo 
	.....set ^TMP("OPBILL","PARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PARKINV",HUser,Job,1))+1
	....if (InitInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","PARKINV",HUser,Job)=$g(^TMP("OPBILL","PARKINV",HUser,Job))_","_InitInvNo  //退费收回的发票
	.....set ^TMP("OPBILL","PARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PARKINV",HUser,Job,1))+1
	...if (Flag="S") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","RefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=myPrtInvNo
	.....else  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=$g(^TMP("OPBILL","RefINV",HUser,Job))_","_myPrtInvNo    //负记录有票号
	.....set ^TMP("OPBILL","RefINV",HUser,Job,1)=$g(^TMP("OPBILL","RefINV",HUser,Job,1))+1
	....if (InitInvNo'="") do
	.....if ('$d(^TMP("OPBILL","RefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","RefINV",HUser,Job)=$g(^TMP("OPBILL","RefINV",HUser,Job))_","_InitInvNo     //退费收回的发票
	.....set ^TMP("OPBILL","RefINV",HUser,Job,1)=$g(^TMP("OPBILL","RefINV",HUser,Job,1))+1
	.//门诊跳号发票
	.set voidInvId=0
	.for  set voidInvId=$o(^DHCVoidInv(0,"UserDate",HUser,Date,voidInvId)) quit:(voidInvId="")  do
	..set voidInvInfo=$g(^DHCVoidInv(voidInvId))
	..quit:(voidInvInfo="")
	..set HospDR=$p(voidInvInfo,"^",12)
	..quit:((HospId'="")&&(HospId'=HospDR))
	..set myHandin=$p(voidInvInfo,"^",10)
	..quit:(myHandin="Y")
	..set myRepDR=$p(voidInvInfo,"^",6)
	..quit:(+myRepDR'=0)
	..set myTime=$p(voidInvInfo,"^",2)
	..//quit:((Date=StDate)&&(myTime<StTime))
	..quit:((Date=EndDate)&&(myTime>EndTime))
	..set myInvType=$p(voidInvInfo,"^",11)    //VOI_Type
	..quit:(myInvType'["O")                    //过滤非门诊跳号发票记录
	..set invNo=$p(voidInvInfo,"^",3)
	..if ('$d(^TMP("OPBILL","VOIDINV",HUser,Job)))  do
	...set ^TMP("OPBILL","VOIDINV",HUser,Job)=invNo
	..else  do
	...set ^TMP("OPBILL","VOIDINV",HUser,Job)=$g(^TMP("OPBILL","VOIDINV",HUser,Job))_","_invNo
	.//体检发票
	.set PEIRowID=0
	.for  set PEIRowID=$o(^DHCPEINVPRT(0,"USER",HUser,Date,PEIRowID)) quit:(PEIRowID="")  do
	..set PEIData=$g(^DHCPEINVPRT(PEIRowID))
	..set PEIRepDR=$p(PEIData,"^",13)
	..quit:(+PEIRepDR'=0)
	..set HospDR=$p(PEIData,"^",26)
	..quit:((HospId'="")&&(HospId'=HospDR))
	..set PEITime=$p(PEIData,"^",12)
	..quit:((Date=EndDate)&&(PEITime>EndTime))
	..set PEBill=$p(PEIData,"^",3)
	..set PEAdm=$p(PEIData,"^",2)
 	..set myPrtAcount=$p(PEIData,"^",7)
	..set myInitInv=$p(PEIData,"^",9)
	..set myPrtInvNo=$p(PEIData,"^",1)
	..quit:(myPrtInvNo["DHCPEYJS")    //过滤预结算记录
	..set myFlag=$p(PEIData,"^",8)
	..if (myPrtInvNo'="") do
	...set ^TMP("OPBILL","INVNO",HUser,Job,myPrtInvNo)=""
	...set ^TMP("OPBILL","INVNUM",HUser,Job)=$g(^TMP("OPBILL","INVNUM",HUser,Job))+1
	..if (myInitInv'="")  do
	...//先判断原票集中打印否
	...if $d(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",myInitInv)) do
	....set PEIFDr=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",myInitInv,0))
	....set InitInvNo=$lg(^User.DHCPEINVFocusPrtD(PEIFDr),3)
	...else  do
	...set InitInvNo=$p(^DHCPEINVPRT(myInitInv),"^",1)
	...if (myFlag="A") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PEPARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PEPARKINV",HUser,Job)=myPrtInvNo
	.....else  do
	......set ^TMP("OPBILL","PEPARKINV",HUser,Job)=$g(^TMP("OPBILL","PEPARKINV",HUser,Job))_","_myPrtInvNo  //负记录有票号
	.....set ^TMP("OPBILL","PEPARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PEPARKINV",HUser,Job,1))+1
	....if (InitInvNo'="")&&(InitInvNo'["DHCPEYJS") do
	.....if ('$d(^TMP("OPBILL","PEPARKINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PEPARKINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","PEPARKINV",HUser,Job)=$g(^TMP("OPBILL","PEPARKINV",HUser,Job))_","_InitInvNo  //退费收回的发票
	.....set ^TMP("OPBILL","PEPARKINV",HUser,Job,1)=$g(^TMP("OPBILL","PEPARKINV",HUser,Job,1))+1
	...if (myFlag="S") do
	....if (myPrtInvNo'="") do
	.....if ('$d(^TMP("OPBILL","PERefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PERefINV",HUser,Job)=myPrtInvNo
	.....else  do
	......set ^TMP("OPBILL","PERefINV",HUser,Job)=$g(^TMP("OPBILL","PERefINV",HUser,Job))_","_myPrtInvNo   //负记录有票号
	.....set ^TMP("OPBILL","PERefINV",HUser,Job,1)=$g(^TMP("OPBILL","PERefINV",HUser,Job,1))+1
	....if (InitInvNo'="")&&(InitInvNo'["DHCPEYJS") do
	.....if ('$d(^TMP("OPBILL","PERefINV",HUser,Job)))  do
	......set ^TMP("OPBILL","PERefINV",HUser,Job)=InitInvNo
	.....else  do
	......set ^TMP("OPBILL","PERefINV",HUser,Job)=$g(^TMP("OPBILL","PERefINV",HUser,Job))_","_InitInvNo   //退费收回的发票
	.....set ^TMP("OPBILL","PERefINV",HUser,Job,1)=$g(^TMP("OPBILL","PERefINV",HUser,Job,1))+1
	.//体检集中打印
	.set PEIFRowID=0
	.for  set PEIFRowID=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",HUser,Date,PEIFRowID)) quit:(PEIFRowID="")  do
	..set PEIFData=$g(^User.DHCPEINVFocusPrtD(PEIFRowID))
	..set PEIFRepDR=$lg(PEIFData,8)
	..quit:(+PEIFRepDR'=0)
	..set PEIFHospDR=$lg(PEIFData,12)
	..quit:((HospId'="")&&(HospId'=PEIFHospDR))
	..set PEIFDate=$lg(PEIFData,5)
	..set PEIFTime=$lg(PEIFData,6)
	..quit:((PEIFDate=EndDate)&&(PEIFTime>EndTime))
	..set myPrtInvNo=$lg(PEIFData,3)
	..if (myPrtInvNo'="") do
	...set ^TMP("OPBILL","INVNO",HUser,Job,myPrtInvNo)=""
	...set ^TMP("OPBILL","INVNUM",HUser,Job)=$g(^TMP("OPBILL","INVNUM",HUser,Job))+1
	.//体检账户表
	.set PEAPRowID=0
	.for  set PEAPRowID=$o(^DHCPEAP(0,"UserDate",HUser,Date,PEAPRowID)) quit:(PEAPRowID="")  do
	..set APSub=0
	..for  set APSub=$o(^DHCPEAP(0,"UserDate",HUser,Date,PEAPRowID,APSub)) quit:(APSub="")  do
	...set PEAPRepDR=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",9)
	...quit:(+PEAPRepDR'=0)
	...set HospDR=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",15)
	...quit:((HospId'="")&&(HospId'=HospDR))
	...set PEAPType=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",1)
	...quit:(" B R RF "'[(" "_PEAPType_" "))
	...set PEAPDate=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",5)
	...set PEAPTime=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",6)
	...quit:((PEAPDate=EndDate)&&(PEAPTime>EndTime))
	...set SourceID=$p(^DHCPEAP(PEAPRowID,"AC",APSub),"^",4)
	...//充值直接打印发票
	...if (SourceID'="")&&((PEAPType="B")||(PEAPType="R"))&&($e(SourceID,1,3)'="DHC") do
	....set myPrtInvNo=SourceID
	....set ^TMP("OPBILL","INVNO",HUser,Job,myPrtInvNo)=""
	....set ^TMP("OPBILL","INVNUM",HUser,Job)=$g(^TMP("OPBILL","INVNUM",HUser,Job))+1
	...//充值作废集中发票
	...set InitInvNo=""
	...if (SourceID'="")&&(PEAPType="RF") do
	....if $d(^User.DHCPEINVFocusPrtI("IFPINVDRIndex",SourceID)) do
	.....set PEIFDr=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_SourceID,""))
	.....set InitInvNo=$lg(^User.DHCPEINVFocusPrtD(PEIFDr),3)
	...if (InitInvNo'="") do
	....if ('$d(^TMP("OPBILL","PERefINV",HUser,Job)))  do
	.....set ^TMP("OPBILL","PERefINV",HUser,Job)=InitInvNo
	....else  do
	.....set ^TMP("OPBILL","PERefINV",HUser,Job)=$g(^TMP("OPBILL","PERefINV",HUser,Job))_","_InitInvNo //退费收回的发票
	....set ^TMP("OPBILL","PERefINV",HUser,Job,1)=$g(^TMP("OPBILL","PERefINV",HUser,Job,1))+1
	
	//发票号段信息
	set rtn=0
	
	ts
	
	set INVInfo=##class(web.DHCBillCommon).GetInvNoInfo("^TMP", "OPBILL", "INVNO", HUser, Job)
	set INVNum=+$g(^TMP("OPBILL","INVNUM",HUser,Job))
	set RefundINVInfo=$g(^TMP("OPBILL","RefINV",HUser,Job))
	set RefoundNum=+$g(^TMP("OPBILL","RefINV",HUser,Job,1))
	set ParkINVInfo=$g(^TMP("OPBILL","PARKINV",HUser,Job))
	set ParkNum=+$g(^TMP("OPBILL","PARKINV",HUser,Job,1))
	set VoidINVInfo=$g(^TMP("OPBILL","VOIDINV",HUser,Job))
	set PEParkINVInfo=$g(^TMP("OPBILL","PEPARKINV",HUser,Job))
	set PERefundINVInfo=$g(^TMP("OPBILL","PERefINV",HUser,Job))
	do KillTMP
	
	&SQL(
		UPDATE DHC_INVPRTReports
		SET HIS_Num = :INVNum, HIS_RcptNO = :INVInfo, HIS_RefundNum = :RefoundNum, HIS_ParkNum = :ParkNum, HIS_ParkINVInfo = :ParkINVInfo,
			HIS_RefundINVInfo = :RefundINVInfo, HIS_PEParkINV = :PEParkINVInfo, HIS_PERefundINV = :PERefundINVInfo, HIS_VoidINVInfo = :VoidINVInfo
		WHERE %ID = :HISRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn

KillTMP
	kill ^TMP("OPBILL","INVNO",HUser,Job)
	kill ^TMP("OPBILL","INVNUM",HUser,Job)
	kill ^TMP("OPBILL","PARKINV",HUser,Job)
	kill ^TMP("OPBILL","RefINV",HUser,Job)
	kill ^TMP("OPBILL","VOIDINV",HUser,Job)
	kill ^TMP("OPBILL","PEPARKINV",HUser,Job)
	kill ^TMP("OPBILL","PERefINV",HUser,Job)
	
	quit 0

ERROR
	quit ..AppException()
}

}
