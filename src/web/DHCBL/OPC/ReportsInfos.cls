/// 操作员操作列表
/// 混合查询模型
/// A： 原始数据查询
/// B： 保存的结算数据查询
/// 1. 结算
/// 2. 未结算
/// 3. 都包含的 结算+未结算
/// 
/// 	;FootFlag="F"	;Foot
/// 	;FootFlag="U"	;UnFoot
/// 	;FootFlag="A" =""	;All
Class web.DHCBL.OPC.ReportsInfos Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 设置报表状态
ClassMethod SetReportsStatus(Arg1 As %String) As %String
{
}

/// / DHC_INVPRT
ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, ByRef RepInfos As %ObjectHandle, FootFlag As %String) As %String
{
	;FootFlag="F"	;Foot
	;FootFlag="U"	;UnFoot
	;FootFlag="A" =""	;All
	;n (stdate,sttime,EndDate,EndTime, INVObj, FootFlag)
	;w ##class(web.DHCBL.OPC.ReportsInfos).GetINVPRTRepInfo(stdate, sttime, EndDate, EndTime, INVObjs, FootFlag)
	
	s myrtn=0
	
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...;q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:((Handin="Y")&&(FootFlag="U"))		;查询未结算的
	...q:((Handin'="Y")&&(FootFlag="F"))		;查询结算的
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...d RepInfos.SetUserRepsByUser(PRTUser)
	...s INVObj=RepInfos.SelRepInfo
	...s myrtn=##class(web.DHCBL.OPC.ReportsInfo).SetINVPRTRepInfoByRowID(.INVObj,PRTrowid)
	
	quit myrtn
}

///  DHC_INVPRTReports 按照结算时间获取 报表记录   HIS_Date, HIS_Time
ClassMethod GetFootReportInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, ByRef ReportObjs As %ObjectHandle, FootFlag As %String) As %String
{
	s myrtn=0
	
	q:(FootFlag="U") myrtn
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	s myDate=0
	f myDate=stdate:1:EndDate {
		s myHISRowID=0
		f  s myHISRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHISRowID))  q:(myHISRowID="")  d
		.q:($d(^DHCOPInsFoot(myHISRowID))=10)
		.s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",7)			;HIS_Time
		.q:(myDate=stdate)&&(myTime<sttime)
		.q:((myDate=EndDate)&&(myTime>=EndTime))
		.s myobj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
		.d myobj.ReadReportByRowID(myHISRowID)
		.d ReportObjs.RepInfos.Insert(myobj)
		.d myobj.%Close()
		.
		
	}
	
	q myrtn
}

/// 	DHC_INVPRTReports 按照收入的 计算时间 HIS_IncomeDate
ClassMethod GetInComeReportInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, ByRef ReportObjs As %ObjectHandle, FootFlag As %String) As %String
{
	s myrtn=0
	
	q:(FootFlag="U") myrtn
	b	;;InReportIncome
	;^DHCOPInsFootI(0,"IncomeDate",{HIS_IncomeDate},{HIS_Rowid})
	;stdate , sttime , EndDate , EndTime , hUser As %String, ReportObjs
	s myDate=0
	f myDate=stdate:1:EndDate {
		s myHISRowID=0
		f  s myHISRowID=$o(^DHCOPInsFootI(0,"IncomeDate", myDate, myHISRowID))  q:(myHISRowID="")  d
		.q:($d(^DHCOPInsFoot(myHISRowID))=10)
		.s myobj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
		.d myobj.ReadReportByRowID(myHISRowID)
		.d ReportObjs.RepInfos.Insert(myobj)
		.d myobj.%Close()
		
	}
	
	q myrtn
}

/// 获取财务结算报表, HIS_INSFootDate, HIS_INSFootTime
ClassMethod GetINSFootReportInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, ByRef ReportObjs As %ObjectHandle, FootFlag As %String) As %String
{
	s myrtn=0
	
	q:(FootFlag="U") myrtn
	
	;^DHCOPInsFootI(0,"INSFDate",{HIS_INSFootDate},{HIS_Rowid})
	s myDate=0
	f myDate=stdate:1:EndDate {
		s myHISRowID=0
		f  s myHISRowID=$o(^DHCOPInsFootI(0,"INSFDate",myDate,myHISRowID))  q:(myHISRowID="")  d
		.q:($d(^DHCOPInsFoot(myHISRowID))=10)
		.s myTime=$p(^DHCOPInsFoot(myHISRowID),"^",14)			;IS_INSFootTime
		.q:(myDate=stdate)&&(myTime<sttime)
		.q:((myDate=EndDate)&&(myTime>=EndTime))
		.s myobj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
		.d myobj.ReadReportByRowID(myHISRowID)
		.d ReportObjs.RepInfos.Insert(myobj)
		.d myobj.%Close()
		.
		
	}
	
	q myrtn
}

///  DHC_CardINVPRT
ClassMethod GetCardINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, ByRef RepInfos As %ObjectHandle, FootFlag As %String) As %String
{
	;w ##class(web.DHCBL.OPC.ReportsInfos).GetCardINVRepInfo(stdate As %String, sttime As %String, EndDate , EndTime, hUser, RepInfos, FootFlag)
	
	s myrtn=0
	
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..;^DHCCARDINVPRTi(0,"Date",{CIP_Date},{CIP_RowID})
	..;^DHCCARDINVPRT({CIP_RowID})
	..q:$d(^DHCCARDINVPRTi(0,"Date",pdate))=0
	..s myCIPRowID=0
	..;b	;;CardINV  卡收费
	..f  s myCIPRowID=$o(^DHCCARDINVPRTi(0,"Date",pdate,myCIPRowID)) q:(myCIPRowID="")  d
	...s PRTUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)			;CIP_PUser_DR
	...;q:PRTUser'=hUser
	...s PRTTime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)			;CIP_Time
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s myReportsDR=$p(^DHCCARDINVPRT(myCIPRowID),"^",9)			;CIP_INVReports_DR
	...q:((myReportsDR'="")&&(FootFlag="U"))		;查询未结算的
	...q:((myReportsDR="")&&(FootFlag="F"))		;查询结算的
	...d RepInfos.SetUserRepsByUser(PRTUser)
	...s myCardINVObj = RepInfos.SelRepInfo
	...s myrtn=##class(web.DHCBL.OPC.ReportsInfo).SetCardINVRepInfoByRowID(.myCardINVObj, myCIPRowID)
	
	q myrtn
}

}
