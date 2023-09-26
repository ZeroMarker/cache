Class web.DHCJFOPworkstat9 Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 门诊收费工作量
/// w ##class(web.DHCJFOPworkstat9).GetMZWorkStat("",64499,64502,0,86399)
ClassMethod GetMZWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
{
	new (UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	set (PMCode,Amount,PrtFlag,PrtDate,PrtTime)=""
	
	set PrtId=0
	for  set PrtId=$o(^DHCINVPRT(0,"Date",pdate,PrtId)) quit:(PrtId="")  do
	.set PrtHospDR=$p($g(^DHCINVPRT(PrtId)),"^",39)
	.quit:(PrtHospDR'=HospId)
	.set PrtOperRowId=$p($g(^DHCINVPRT(PrtId)),"^",21)	;PRT_Usr
	.quit:(UserRowId'=PrtOperRowId)&&(UserRowId'="")	    ;操作员
	.set PrtFairType=$p($g(^DHCINVPRT(PrtId)),"^",34)	    ;PRT_FairType
	.quit:(PrtFairType'="F")	;只统计收费
	.set PrtDate=$p($g(^DHCINVPRT(PrtId)),"^",5)
	.set PrtTime=$p($g(^DHCINVPRT(PrtId)),"^",20)
	.quit:(PrtDate=StDate)&&(PrtTime<StartTime)&&(StartTime'="")
	.quit:(PrtDate=EndDate)&&(PrtTime>EndTime)&&(EndTime'="")
	.set PrtFlag=$p($g(^DHCINVPRT(PrtId)),"^",8)	;PRT_Flag
	.set Amount=$p($g(^DHCINVPRT(PrtId)),"^",1)	;PRT_Acount
	.set:(PrtFlag'="N")&&(Amount>0) PrtFlag="N"	;对退费发票 进行处理
	.set ^TMPWorkStat($j,"User",PrtOperRowId)=""
	.set ^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,PrtFlag)=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,PrtFlag))+1
	.set ^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,PrtFlag)=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,PrtFlag))+Amount
	
	quit 0
}

/// 急诊收费工作量
ClassMethod GetJZWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
{
	;DHC_AccPayINV
	new (UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	set (PMCode,Amount,PrtFlag,PrtDate,PrtTime)=""
	
	set PrtId=0
	for  set PrtId=$o(^DHCINVPRTAPi(0,"Date",pdate,PrtId)) quit:(PrtId="")  do
	.set PrtHospDR=$p($g(^DHCINVPRTAP(PrtId)),"^",30)
	.quit:(PrtHospDR'=HospId)
	.set PrtOperRowId=$p($g(^DHCINVPRTAP(PrtId)),"^",5)	;API_PUser_DR
	.quit:(UserRowId'=PrtOperRowId)&&(UserRowId'="")	;操作员
	.set PrtDate=$p($g(^DHCINVPRTAP(PrtId)),"^",3)	
	.set PrtTime=$p($g(^DHCINVPRTAP(PrtId)),"^",4)
	.quit:(PrtDate=StDate)&&(PrtTime<StartTime)&&(StartTime'="")
	.quit:(PrtDate=EndDate)&&(PrtTime>EndTime)&&(EndTime'="")
	.set PrtFlag=$p($g(^DHCINVPRTAP(PrtId)),"^",2)	;API_Flag
	.set Amount=$p($g(^DHCINVPRTAP(PrtId)),"^",1)		;PRT_Acount
	.set:(PrtFlag'="N")&&(Amount>0) PrtFlag="N" 
	.set ^TMPWorkStat($j,"User",PrtOperRowId)=""
	.set ^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,PrtFlag)=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,PrtFlag))+1
	.set ^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,PrtFlag)=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,PrtFlag))+Amount

	quit 0
}

/// w ##class(web.DHCOPInvFRep.WorkStat).GetMZWorkStat("",60669,60669,60670,0,86399)
ClassMethod GetYJJWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
{
	new (UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	
	;DHC_AccPreDeposit
	set AccId=0
	for  set AccId=$o(^DHCACDi("AccM",0,"FD",pdate,AccId)) quit:(AccId="")  do
	.set AccPDSub=0
	.for  set AccPDSub=$o(^DHCACDi("AccM",0,"FD",pdate,AccId,"AccPD",AccPDSub)) quit:(AccPDSub="")  do
	..set PreHospDR=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",15)
	..quit:(PreHospDR'=HospId)
	..set PreDate=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",3)	
	..set PreTime=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",4)	
	..quit:(PreDate=StDate)&&(PreTime<StartTime)&&(StartTime'="")
	..quit:(PreDate=EndDate)&&(PreTime>EndTime)&&(EndTime'="")
	..set PrtOperRowId=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",5)	;AccPD_User_DR 操作员
	..quit:((UserRowId'=PrtOperRowId)&&(UserRowId'=""))	;操作员
	..set Amount=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",2)	;AccPD_PreSum
	..set PDType=$p($g(^DHCACD("AccM",AccId,"AccPD",AccPDSub)),"^",1)	;AccPD_Type
	..quit:(PDType="")
	..set ^TMPWorkStat($j,"User",PrtOperRowId)=""	
	..set ^TMPWorkStat($j,"JZ_YJJNum",PrtOperRowId,PDType)=+$g(^TMPWorkStat($j,"JZ_YJJNum",PrtOperRowId,PDType))+1
	..set ^TMPWorkStat($j,"JZ_YJJSum",PrtOperRowId,PDType)=+$g(^TMPWorkStat($j,"JZ_YJJSum",PrtOperRowId,PDType))+Amount

	quit 0
}

ClassMethod GetCardWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
{
	new (UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
    
    ;DHC_CardStatusChange
	set CSCId=0
	for  set CSCId=$o(^DHCCARDi("CF",0,"CSDate",pdate,CSCId)) quit:(CSCId="")  do
	.set CSCSub=0
	.for  set CSCSub=$o(^DHCCARDi("CF",0,"CSDate",pdate,CSCId,"CSC",CSCSub))  quit:(CSCSub="")  do
	..set CSCHospDR=$p($g(^DHCCARD("CF",CSCId,"CSC",CSCSub)),"^",18)	;CSC_Hosp_DR
	..quit:(CSCHospDR'=HospId)
	..set PrtOperRowId=$p($g(^DHCCARD("CF",CSCId,"CSC",CSCSub)),"^",4)	;CSC_User_DR 操作员
	..quit:(UserRowId'=PrtOperRowId)&&(UserRowId'="")	;操作员
	..set CSCDate=$p($g(^DHCCARD("CF",CSCId,"CSC",CSCSub)),"^",1)	;CSC_Date
	..set CSCTime=$p($g(^DHCCARD("CF",CSCId,"CSC",CSCSub)),"^",2)	;CSC_Time
	..quit:(CSCDate=StDate)&&(CSCTime<StartTime)&&(StartTime'="")
	..quit:(CSCDate=EndDate)&&(CSCTime>EndTime)&&(EndTime'="")
	..set CStatus=$p($g(^DHCCARD("CF",CSCId,"CSC",CSCSub)),"^",3)	;CSC_CurStatus
	..set ^TMPWorkStat($j,"User",PrtOperRowId)=""
	..set ^TMPWorkStat($j,"JZ_CardNum",PrtOperRowId,CStatus)=+$g(^TMPWorkStat($j,"JZ_CardNum",PrtOperRowId,CStatus))+1

	quit 0
}

/// 提供门急诊工作量统计
/// do ##class(%ResultSet).RunQuery("web.DHCJFOPworkstat9","QueryMJZWorkStat","","2020-06-12","2020-06-12","00:00:00","23:59:59","","3")
Query QueryMJZWorkStat(UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, InvStat As %String, HospId As %String) As websys.Query(ROWSPEC = "TNo:%String,TUserCode:%String,TUserName:%String,TGetNum:%Float,TGetSum:%Float,TGiveNum:%Float,TGiveSum:%Float,TRefundNum:%Float,TRefundSum:%Float,TAbortNum:%Float,TAbortSum:%Float,TCreateCardNum:%Float,TCardRefundNum:%Float,TCardReissueNum:%Float,TCardExchangeNum:%Float,TCardRptLossNum:%Float,TAllCardNum:%Float,TPrepayGetNum:%Float,TPrepayGetSum:%Float,TPrepayGiveNum:%Float,TPrepayGiveSum:%Float,TCardFootNum:%Float,TCardFootSum:%Float,Thjnum:%Float,Thjsum:%Float") [ SqlProc ]
{
}

ClassMethod QueryMJZWorkStatExecute(ByRef qHandle As %Binary, UserRowId As %String, StDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, InvStat As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((StDate="")||(EndDate="")) quit $$$OK
	set ^TMP("QueryMJZWorkStat")=$lb(UserRowId, StDate, EndDate, StartTime, EndTime, InvStat, HospId)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate) 
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	set StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
	kill ^TMPWorkStat($j)
	
	for pdate=StDate:1:EndDate do
	.if (InvStat'="CPP") do ..GetMZWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	.if (InvStat'="INV") do ..GetJZWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	.if (InvStat'="INV") do ..GetYJJWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	.if (InvStat'="INV") do ..GetCardWorkStat(UserRowId, pdate, StDate, EndDate, StartTime, EndTime, HospId)
	
	set (TUserCode,TUserName,TGetNum,TGetSum,TGiveNum,TGiveSum,TRefundNum,TRefundSum,TAbortNum,TAbortSum,TCreateCardNum,TCardRefundNum,TCardReissueNum,TCardExchangeNum,TCardRptLossNum,TAllCardNum,TPrepayGetNum,TPrepayGetSum,TPrepayGiveNum,TPrepayGiveSum,TCardFootNum,TCardFootSum)=""
	set (TGetNumHJ,TGetSumHJ,TGiveNumHJ,TGiveSumHJ,TRefundNumHJ,TRefundSumHJ,TAbortNumHJ,TAbortSumHJ,TCreateCardNumHJ,TCardRefundNumHJ,TCardReissueNumHJ,TCardExchangeNumHJ,TCardRptLossNumHJ,TAllCardNumHJ,TPrepayGetNumHJ,TPrepayGetSumHJ,TPrepayGiveNumHJ,TPrepayGiveSumHJ,TCardFootNumHJ,TCardFootSumHJ)=0
	
	set PrtOperRowId=0
	for  set PrtOperRowId=$o(^TMPWorkStat($j,"User",PrtOperRowId)) quit:(PrtOperRowId="")  do
	.quit:(##class(web.UDHCJFBaseCommon).CheckISCashierBytype(PrtOperRowId, "O", 3)=1)   //非收费员不显示  add zhangli  17.6.13
	.set TUserCode=$p($g(^SSU("SSUSR",PrtOperRowId)),"^",1)	;SSUSR_Name
	.set TUserName=$p($g(^SSU("SSUSR",PrtOperRowId)),"^",2)	;SSUSR_Name
	.set TGetNum=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,"N"))
	.set TGetSum=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,"N"))
	.set TGiveNum=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,"S"))+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,"A"))
	.set TGiveSum=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,"S"))+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,"A"))
	.set TRefundNum=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,"S"))
	.set TRefundSum=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,"S"))
	.set TAbortNum=+$g(^TMPWorkStat($j,"MZ_InvNum",PrtOperRowId,"A"))
	.set TAbortSum=+$g(^TMPWorkStat($j,"MZ_InvSum",PrtOperRowId,"A"))
	.set TCreateCardNum=$g(^TMPWorkStat($j,"JZ_CardNum",PrtOperRowId,"N"))
	.;set TCardRefundNum=
	.;set TCardReissueNum=补卡
	.;set TCardExchangeNum=换卡
	.set TCardRptLossNum=+$g(^TMPWorkStat($j,"JZ_CardNum",PrtOperRowId,"S"))
	.set TAllCardNum=+$g(TCreateCardNum)+$g(TCardRefundNum)+$g(TCardReissueNum)+$g(TCardExchangeNum)+$g(TCardRptLossNum)
	.set TPrepayGetNum=+$g(^TMPWorkStat($j,"JZ_YJJNum",PrtOperRowId,"P"))
	.set TPrepayGetSum=+$g(^TMPWorkStat($j,"JZ_YJJSum",PrtOperRowId,"P"))
	.set TPrepayGiveNum=+$g(^TMPWorkStat($j,"JZ_YJJNum",PrtOperRowId,"R"))
	.set TPrepayGiveSum=+$g(^TMPWorkStat($j,"JZ_YJJSum",PrtOperRowId,"R"))
	.set TCardFootNum=+$g(^TMPWorkStat($j,"JZ_YJJNum",PrtOperRowId,"F"))
	.set TCardFootSum=+$g(^TMPWorkStat($j,"JZ_YJJSum",PrtOperRowId,"F"))
	.;合计
	.set TGetNumHJ=TGetNumHJ+TGetNum
	.set TGetSumHJ=TGetSumHJ+TGetSum
	.set TGiveNumHJ=TGiveNumHJ+TGiveNum
	.set TGiveSumHJ=TGiveSumHJ+TGiveSum
	.set TRefundNumHJ=TRefundNumHJ+TRefundNum
	.set TRefundSumHJ=TRefundSumHJ+TRefundSum 
	.set TAbortNumHJ=TAbortNumHJ+TAbortNum
	.set TAbortSumHJ=TAbortSumHJ+TAbortSum
	.set TCreateCardNumHJ=TCreateCardNumHJ+TCreateCardNum 
	.set TCardRefundNumHJ=TCardRefundNumHJ+TCardRefundNum
	.set TCardReissueNumHJ=TCardReissueNumHJ+TCardReissueNum 
	.set TCardExchangeNumHJ=TCardExchangeNumHJ+TCardExchangeNum 
	.set TCardRptLossNumHJ=TCardRptLossNumHJ+TCardRptLossNum
	.set TAllCardNumHJ=TAllCardNumHJ+TAllCardNum
	.set TPrepayGetNumHJ=TPrepayGetNumHJ+TPrepayGetNum
	.set TPrepayGetSumHJ=TPrepayGetSumHJ+TPrepayGetSum
	.set TPrepayGiveNumHJ=TPrepayGiveNum+TPrepayGiveNumHJ 
	.set TPrepayGiveSumHJ=TPrepayGiveSumHJ+TPrepayGiveSum
	.set TCardFootNumHJ=TCardFootNumHJ+TCardFootNum
	.set TCardFootSumHJ=TCardFootSumHJ+TCardFootSum
	.do OutPutWorkStat
	
	//合计
	set TUserCode="合计"
	set TUserName=""
	set TGetNum=TGetNumHJ
	set TGetSum=TGetSumHJ
	set TGiveNum=TGiveNumHJ
	set TGiveSum=TGiveSumHJ
	set TRefundNum=TRefundNumHJ
	set TRefundSum=TRefundSumHJ 
	set TAbortNum=TAbortNumHJ
	set TAbortSum=TAbortSumHJ
	set TCreateCardNum=TCreateCardNumHJ 
	set TCardRefundNum=TCardRefundNumHJ
	set TCardReissueNum=TCardReissueNumHJ
	set TCardExchangeNum=TCardExchangeNumHJ
	set TCardRptLossNum=TCardRptLossNumHJ
	set TAllCardNum=TAllCardNumHJ
	set TPrepayGetNum=TPrepayGetNumHJ
	set TPrepayGetSum=TPrepayGetSumHJ
	set TPrepayGiveNum=TPrepayGiveNum 
	set TPrepayGiveSum=TPrepayGiveSumHJ
	set TCardFootNum=TCardFootNumHJ
	set TCardFootSum=TCardFootSumHJ
	do OutPutWorkStat
	
	kill ^TMPWorkStat($j)
	quit $$$OK

OutPutWorkStat
	set (hjnum, hjsum)=0
	set TGetSum=$fn($zabs(TGetSum),"",2)
	set TGiveSum=$fn($zabs(TGiveSum),"",2)
	set TRefundSum=$fn($zabs(TRefundSum),"",2)
	set TAbortSum=$fn($zabs(TAbortSum),"",2)
	set hjnum=TGetNum+TRefundNum+TAbortNum
	set hjsum=TGetSum-TRefundSum-TAbortSum
	set Data=$lb(ind,TUserCode,TUserName,TGetNum,TGetSum,TGiveNum,TGiveSum,TRefundNum,TRefundSum,TAbortNum,TAbortSum,TCreateCardNum,TCardRefundNum,TCardReissueNum,TCardExchangeNum,TCardRptLossNum,TAllCardNum,TPrepayGetNum,TPrepayGetSum,TPrepayGiveNum,TPrepayGiveSum,TCardFootNum,TCardFootSum,hjnum,$fn(hjsum,"",2))
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.DHCJFOPworkstat9","FindOPCashier",2)
Query FindOPCashier(hospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindOPCashierExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	 	
	set rowId=$o(^DHCJFRcptGroupSet(0,"Type","O",3,""))
	if (rowId="") quit $$$OK
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_RcptGroupUser", hospId)

	set sub=0
	for  set sub=$o(^DHCJFRcptGroupSet(rowId,"Sub",sub)) quit:(sub="")  do
	.set data=$g(^DHCJFRcptGroupSet(rowId,"Sub",sub))
	.quit:(data="")
	.set userDR=$p(data,"^",4)
	.set hospDR=$p(data,"^",5)
	.quit:(hospDR'=defHospId)
	.set userName=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2),1:"")
	.do OutputOPCashier
 
 	quit $$$OK
 	
OutputOPCashier
	set Data=$lb(userDR,userName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

}
