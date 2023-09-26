Import SQLUser

/// Lid
/// 2010-11-16
/// 门诊收费员日报业务类
Class web.DHCOPBillDailyHandin Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2010-12-03
/// Description: 收费员日报结算业务
/// Debug: w ##class(web.DHCOPBillDailyHandin).Handin(4647,2,"5","2","2022-03-20^23:59:59^2022-03-21^18:32:57^N^N")
ClassMethod Handin(guser As %String, hospDr As %String, footInfo As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("Handin")=$lb(guser, hospDr, footInfo)
	
	set stDate=$p(footInfo,"^",1)
	set stTime=$p(footInfo,"^",2)
	set endDate=$p(footInfo,"^",3)
	set endTime=$p(footInfo,"^",4)
	set autoFlag=$p(footInfo,"^",5)         //+2018-02-11 ZhYW 自动结账任务标识,(="Y":任务结账, <>"Y":手工结账)
	set preHandinFlag=$p(footInfo,"^",6)    //+2018-03-10 ZhYW 是否预结算标识,(="Y":预结账, <>"Y":结账)
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
	
	set hdate=+$h
	set htime=$p($h,",",2)
	//自动结账任务时,结账时间取结束时间
	if (autoFlag="Y") {
		set hdate=endDate
		set htime=endTime
	}
	
	set rtn=0
	
	//+2017-09-05 ZhYW 取日结结束时间配置
	set handinEndTime=..GetConfHandinEndTime(hospDr)
	if (handinEndTime'="") {
		if ((endDate>stDate)&&(stTime<handinEndTime)) {
			set endDate=stDate
			set endTime=handinEndTime
		}else {
			set endTime=$s(((+endTime)>(+handinEndTime)):handinEndTime, 1:endTime)
		}
		set rtn=..CheckIsHandedAtEndTime(guser, endDate, endTime, hospDr)    //验证该收费员此时有没有做过日结, 做过日结则不允许再结算
		quit:(+rtn) -1_"^"_"在系统配置时间已结账, 当天不能再次结账"
	}
	
	set secondDiff=$SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, endDate_","_endTime)
	quit:(secondDiff<0) -1_"^"_"开始时间不能大于结束时间"

	set secondDiff=$SYSTEM.SQL.DATEDIFF("ss", endDate_","_endTime, $h)
	quit:(secondDiff<0) -1_"^"_"结束时间不能大于当前时间"

	if (autoFlag'="Y") {              //收费员日结时验证有预结算发票时不允许结算
		set rtnValue=..GetTPInvNum(guser, stDate, stTime, endDate, endTime, hospDr)
		quit:(+rtnValue) -1_"^"_"您有"_$p(rtnValue,"^",1)_"条预结算记录，请先处理"
	}
	
	ts
	
	//+2018-03-10 ZhYW 删除预结算记录(取最后一条记录)
	set footId=""
	set myId=""
	while($o(^DHCOPInsFootI(0,"User",guser,myId),-1)&&(footId="")) {
		set myId=$o(^DHCOPInsFootI(0,"User",guser,myId),-1)
		set footData=$g(^DHCOPInsFoot(myId))
		continue:(footData="")
		set myHospDR=$p(footData,"^",66)
		continue:(myHospDR'=hospDr)
		set footId=myId
	}
	if (+footId'=0) {
		set myPreHandinFlag=$p(^DHCOPInsFoot(footId),"^",68)
		if (myPreHandinFlag="Y") {
			&SQL(DELETE FROM DHC_INVPRTReports WHERE %ID = :footId)
			set rtn=SQLCODE
			if (+rtn) tro  quit rtn_"^"_$g(%msg)
		}
	}
	
	&SQL(
		INSERT INTO DHC_INVPRTReports (
			HIS_Date, HIS_Time, HIS_StartDate, HIS_StartTime, HIS_EndDate,
			HIS_EndTime, HIS_User, HIS_ReportType, HIS_Hospital_DR, HIS_PreHandinFlag,
			HIS_ReceiveFlag
		)
		VALUES (
			:hdate, :htime, :stDate, :stTime, :endDate,
			:endTime, :guser, 'U', :hospDr, :preHandinFlag,
			'N'
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set HISParref=$g(%ROWID)
	
	//wangjian 2017-08-09 增加门诊日结指标
	set rtn=##class(web.DHCBillKPIOrder).KPIExecByTaskType("02", stDate, stTime, endDate, endTime, hospDr, guser, HISParref)
	if (+rtn) tro  quit rtn
	
	//+2018-03-10 ZhYW
	if (preHandinFlag="Y") {
		if ($tl>0) tc
		quit rtn_"^"_HISParref        //预结算时不更新明细表
	}
	
	set rtn=##class(web.DHCOPBillDailyHandin).UpdateFootForBizData(guser, HISParref, hospDr)
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn_"^"_HISParref

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-10-19
/// Description: 获取结算开始日期
/// Input: reportType:(U:门诊收费，C:建卡挂号，S:系统结算)
/// Debug: w ##class(web.DHCOPBillDailyHandin).GetStDate("5","","2","")
ClassMethod GetStDate(userId As %String, hospId As %String, reportType As %String = "U") As %String
{
	set stDate=+$h, stTime=$p($h,",",2)
		
	set flag="N"
	set reportsId=""
	while($o(^DHCOPInsFootI(0,"User",userId,reportsId),-1)&&(flag="N")) {
		set reportsId=$o(^DHCOPInsFootI(0,"User",userId,reportsId),-1)
		set reportsData=$g(^DHCOPInsFoot(reportsId))
		set preHandinFlag=$p(reportsData,"^",68)     //过滤预结算记录
		continue:(preHandinFlag="Y")
		set hospDR=$p(reportsData,"^",66)
		continue:(hospId'=hospDR)
		set myReportType=$p(reportsData,"^",60)
		continue:(reportType'=myReportType)
		set stDate=$p(reportsData,"^",3)
		set stTime=$p(reportsData,"^",4)
		set flag="Y"
	}

	if (flag="N") {
		//发票表
		set prtId=0
		while($o(^DHCINVPRT(0,"HandIn","N",userId,prtId))) {
			set prtId=$o(^DHCINVPRT(0,"HandIn","N",userId,prtId))
			set prtData=$g(^DHCINVPRT(prtId))
			set hospDR=$p(prtData,"^",39)
			continue:(hospId'=hospDR)
			set myDate=$p(prtData,"^",5)
			set myTime=$p(prtData,"^",20)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
				set stDate=myDate
				set stTime=myTime
			}
			quit
		}
		
		//集中打印发票表
		set apiId=0
		while($o(^DHCINVPRTAPi(0,"HandIn","N",userId,apiId))) {
			set apiId=$o(^DHCINVPRTAPi(0,"HandIn","N",userId,apiId))
			set apiData=$g(^DHCINVPRTAP(apiId))
			set hospDR=$p(apiData,"^",30)
			continue:(hospId'=hospDR)
			set myDate=$p(apiData,"^",3)
			set myTime=$p(apiData,"^",4)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
				set stDate=myDate
				set stTime=myTime
			}
			quit
		}
		
		//预交金表
		set accM=0
		while($o(^DHCACDi("AccM",0,"HandIn","N",userId,accM))) {
			set accM=$o(^DHCACDi("AccM",0,"HandIn","N",userId,accM))
			set mySub=0
			while($o(^DHCACDi("AccM",0,"HandIn","N",userId,accM,"AccPD",mySub))) {
				set mySub=$o(^DHCACDi("AccM",0,"HandIn","N",userId,accM,"AccPD",mySub))
				set myPDData=$g(^DHCACD("AccM",accM,"AccPD",mySub))
				set hospDR=$p(myPDData,"^",15)
				continue:(hospId'=hospDR)
				set myDate=$p(myPDData,"^",3)
				set myTime=$p(myPDData,"^",4)
				if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
					set stDate=myDate
					set stTime=myTime
				}
			}
		}
		
	    //急诊留观押金
	    set myEPM=0
	    while($o(^DHCEPMi("EPM",0,"HandIn","N",userId,myEPM))) {
			set myEPM=$o(^DHCEPMi("EPM",0,"HandIn","N",userId,myEPM))
			set mySub=0
			while($o(^DHCEPMi("EPM",0,"HandIn","N",userId,myEPM,"EPMD",mySub))) {
				set mySub=$o(^DHCEPMi("EPM",0,"HandIn","N",userId,myEPM,"EPMD",mySub))
				set myPDData=$g(^DHCEPM("EPM",myEPM,"EPMD",mySub))
			 	set myHospDR=$p(myPDData,"^",13)
	  			continue:(hospId'=myHospDR)
	  			set myDate=$p(myPDData,"^",3)
	  			set myTime=$p(myPDData,"^",4)
	  			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
					set stDate=myDate
					set stTime=myTime
				}
			}
		}
		
		//卡发票表
		set cardInvId=0
		while($o(^DHCCARDINVPRTi(0,"HandIn","N",userId,cardInvId))) {
			set cardInvId=$o(^DHCCARDINVPRTi(0,"HandIn","N",userId,cardInvId))
			set cardInvData=$g(^DHCCARDINVPRT(cardInvId))
			set myHospDR=$p(cardInvData,"^",20)
			continue:(hospId'=myHospDR)
			set myDate=$p(cardInvData,"^",4)
			set myTime=$p(cardInvData,"^",5)
			if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
				set stDate=myDate
				set stTime=myTime
			}
			quit
		}
		
		//体检发票表
		set minFlag="N"
		set PEDate=0
		while($o(^DHCPEINVPRT(0,"USER",userId,PEDate))&&(minFlag="N")) {
			set PEDate=$o(^DHCPEINVPRT(0,"USER",userId,PEDate))
			set PEIRowID=0
			while($o(^DHCPEINVPRT(0,"USER",userId,PEDate,PEIRowID))&&(minFlag="N")) {
				set PEIRowID=$o(^DHCPEINVPRT(0,"USER",userId,PEDate,PEIRowID))
				set PEIData=$g(^DHCPEINVPRT(PEIRowID))
				set PEIRepDR=$p(PEIData,"^",13)
				continue:(+PEIRepDR'=0)
				set myHospDR=$p(PEIData,"^",26)
				continue:(hospId'=myHospDR)
				set myDate=$p(PEIData,"^",11)
				set myTime=$p(PEIData,"^",12)
				if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
					set stDate=myDate
					set stTime=myTime
				}
				set minFlag="Y"
			}
		}
		
		//体检集中打印发票
		set minFlag="N"
		set PEFDate=0
		while($o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,PEFDate))&&(minFlag="N")) {
			set PEFDate=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,PEFDate))
			set PEIFRowID=0
			while($o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,PEFDate,PEIFRowID))&&(minFlag="N")) {
				set PEIFRowID=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,PEFDate,PEIFRowID))
				set PEIFData=$g(^User.DHCPEINVFocusPrtD(PEIFRowID))
				set PEIFRepDR=$lg(PEIFData,8)
				continue:(+PEIFRepDR'=0)
				set myHospDR=$lg(PEIFData,12)
				continue:(hospId'=myHospDR)
				set myDate=$lg(PEIFData,5)
				set myTime=$lg(PEIFData,6)
				if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
					set stDate=myDate
					set stTime=myTime
				}
				set minFlag="Y"
			}
		}
		
		//体检预交金表
		set minFlag="N"
		set PEADate=0
		while($o(^DHCPEAP(0,"UserDate",userId,PEADate))&&(minFlag="N")) {
			set PEADate=$o(^DHCPEAP(0,"UserDate",userId,PEADate))
			set PEAPRowID=0
			while($o(^DHCPEAP(0,"UserDate",userId,PEADate,PEAPRowID))) {
				set PEAPRowID=$o(^DHCPEAP(0,"UserDate",userId,PEADate,PEAPRowID))
				set APSub=0
				while($o(^DHCPEAP(0,"UserDate",userId,PEADate,PEAPRowID,APSub))) {
					set APSub=$o(^DHCPEAP(0,"UserDate",userId,PEADate,PEAPRowID,APSub))
					set PEAPData=$g(^DHCPEAP(PEAPRowID,"AC",APSub))
					set PEAPRepDR=$p(PEAPData,"^",9)
					continue:(+PEAPRepDR'=0)
					set myHospDR=$p(PEAPData,"^",15)
					continue:(hospId'=myHospDR)
					set PEAPType=$p(PEAPData,"^",1)
					continue:(" B R RF "'[(" "_PEAPType_" "))
					set myDate=$p(PEAPData,"^",5)
					set myTime=$p(PEAPData,"^",6)
					if ($SYSTEM.SQL.DATEDIFF("ss", stDate_","_stTime, myDate_","_myTime)<0) {
						set stDate=myDate
						set stTime=myTime
					}
					set minFlag="Y"
				}
			}
		}
	}
	
	set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
	set stTime=##class(websys.Conversions).TimeLogicalToHtml(stTime, 1)
	set endDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	set endTime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2), 1)
	
	quit stDate_"^"_stTime_"^"_endDate_"^"_endTime
}

/// Creator: yyx
/// CreateDate: 2012-09-04
/// Description: 取收费员预结算数据
ClassMethod GetTPInvNum(UserDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	set TPPrtNum=0
	set TPPEINum=0
	
	for myDate=StDate:1:EndDate {
		//门诊收费
		set myPrtRowID=0
		while($o(^DHCINVPRT(0,"UserDate",UserDR,myDate,myPrtRowID))) {
			set myPrtRowID=$o(^DHCINVPRT(0,"UserDate",UserDR,myDate,myPrtRowID))
			set myPrtData=$g(^DHCINVPRT(myPrtRowID))
			set myPrtFlag=$p(myPrtData,"^",8)
			continue:(myPrtFlag'="TP")
			set myReportsDR=$p(myPrtData,"^",6)
			continue:(+myReportsDR'=0)
			set myHospDR=$p(myPrtData,"^",39)
			continue:(HospId'=myHospDR)
			set myTime=$p(myPrtData,"^",20)
			continue:((myDate=StDate)&&(myTime<StTime))
			continue:((myDate=EndDate)&&(myTime>EndTime))
			set TPPrtNum=$i(TPPrtNum)
		}

		//体检收费
		set myPEIRowID=0
		while($o(^DHCPEINVPRT(0,"USER",UserDR,myDate,myPEIRowID))) {
			set myPEIRowID=$o(^DHCPEINVPRT(0,"USER",UserDR,myDate,myPEIRowID))
			set myPEIData=$g(^DHCPEINVPRT(myPEIRowID))
			set myPEIInvNo=$p(myPEIData,"^",1)
			continue:(myPEIInvNo'["DHCPEYJS")     //过滤非预结算记录
			set myPEIRepDR=$p(myPEIData,"^",13)
			continue:(+myPEIRepDR'=0)
			set myHospDR=$p(myPEIData,"^",26)
			continue:(HospId'=myHospDR)
			set myPEITime=$p(myPEIData,"^",12)
			continue:((myDate=StDate)&&(myPEITime<StTime))
			continue:((myDate=EndDate)&&(myPEITime>EndTime))
			set TPPEINum=$i(TPPEINum)
		}
	}
	
	set TPInvNum=TPPrtNum+TPPEINum

	quit TPInvNum
}

/// Creator: ZhYW
/// CreatDate: 2017-09-05
/// Description: 判断在此时间是否做过日结
/// Input: userId:SS_User.RowID, endDate: 结束日期, endTime:结束时间, hospId:CT_Hospital.RowID
/// Return: flag 0:未日结, 1:日结
/// Debug: w ##class(web.DHCOPBillDailyHandin).CheckIsHandedAtEndTime(1207, 64396, 86399, 2)
ClassMethod CheckIsHandedAtEndTime(userId As %String, endDate As %String, endTime As %String, hospId As %String) As %String
{
	set flag=0
	quit:(+userId=0) flag
	
	set myEndDate=endDate
	
	set rowId=""
	for  set rowId=$o(^DHCOPInsFootI(0,"User",userId,rowId),-1) quit:((rowId="")||(myEndDate<endDate)||(flag'=0))  do
	.set data=$g(^DHCOPInsFoot(rowId))
	.quit:(data="")
	.set myHospDR=$p(data,"^",66)
	.quit:(myHospDR'=hospId)
	.set myPreHandinFlag=$p(data,"^",68)
	.quit:(myPreHandinFlag="Y")
	.set myEndDate=$p(data,"^",3)
	.quit:(myEndDate'=endDate)
	.set myEndTime=$p(data,"^",4)
	.quit:(myEndTime'=endTime)
	.set flag=1
	
	quit flag
}

/// Creator: ZhYW 
/// CreatDate: 2018-03-10
/// Description: 取收费员最后一次日结信息
/// Input: guser:SS_User.RowID, hospId: CT_Hospital.HOSP_RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyHandin).GetLastHandinInfo(5)
ClassMethod GetLastHandinInfo(guser As %String, hospId As %String) As %String
{
	set footId=""
    set footDate="", footTime="", receFlag="N"
    
	set myId=""
	while($o(^DHCOPInsFootI(0,"User",guser,myId),-1)) {
		set myId=$o(^DHCOPInsFootI(0,"User",guser,myId),-1)
		set footData=$g(^DHCOPInsFoot(myId))
		set hospDR=$p(footData,"^",66)
		continue:(hospDR'=hospId)
		set footId=myId
		set footDate=$p(footData,"^",2)
		set footTime=$p(footData,"^",7)
		set receFlag=$p(footData,"^",69)
		quit
	}
	
	set todayFlag=$case(footDate,+$h:"Y",:"N")
	set footDate=##class(websys.Conversions).DateLogicalToHtml(footDate)
	set footTime=##class(websys.Conversions).TimeLogicalToHtml(footTime, 1)

	set rtn=footId_"^"_footDate_"^"_footTime_"^"_receFlag_"^"_todayFlag
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-03-10
/// Descripiton: 收费员取消日结
/// Input: rowId:DHC_INVPRTReports.HIS_Rowid
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyHandin).CancelHandin(835)
ClassMethod CancelHandin(footId As %String) As %String
{
	set $zt="ERROR"
	
	set json=##class(%DynamicObject).%New()
	
	ts
	
	&SQL(DELETE FROM DHC_INVPRTReports WHERE %ID = :footId)
    set rtn=SQLCODE
	if (+rtn) {
		tro
		set json.success=+rtn
		set json.msg=$g(%msg)
		quit json.%ToJSON()
	}
		
	set rtnValue=##class(web.DHCOPBillDailyHandin).CancelFootForBizData(footId)
	set rtn=$p(rtnValue,"^",1)
	set json.success=+rtn
	if (+rtn) {
		tro
		set json.msg=$p(rtnValue,"^",2)
		quit json.%ToJSON()
	}
	if ($tl>0) tc
	set json.msg="取消成功"
 	
	quit json.%ToJSON()

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-12-06
/// Description: 生成日结记录树
/// Input: 
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyHandin).BuildReportsTree(12173, 2)
ClassMethod BuildReportsTree(guser As %String, hospDR As %String, langId As %String = "") As %String
{
	set lastDate=""
	kill footList
	set footId=0
	while($o(^DHCOPInsFootI(0,"User",guser,footId))) {
		set footId=$o(^DHCOPInsFootI(0,"User",guser,footId))
		set footData=$g(^DHCOPInsFoot(footId))
		set preHandinFlag=$p(footData,"^",68)     //过滤预结算记录
		continue:(preHandinFlag="Y")
		set myHospDR=$p(footData,"^",66)
		continue:(hospDR'=myHospDR)
		set footDate=$p(footData,"^",2)
		if (+footDate>+lastDate) {
			set lastDate=footDate
		}
		set year=$SYSTEM.SQL.YEAR(footDate)
		set month=$SYSTEM.SQL.MONTH(footDate)
		set day=$SYSTEM.SQL.DAYOFMONTH(footDate)
		set footList(year,month,day,footId)=""
	}
	if (+lastDate=0) {
		set lastDate=+$h
	}
	set lastYear=$SYSTEM.SQL.YEAR(lastDate)
	set lastMonth=$SYSTEM.SQL.MONTH(lastDate)
	set lastDay=$SYSTEM.SQL.DAYOFMONTH(lastDate)

	set o=[]
	set year=0
	while($o(footList(year))) {
		set year=$o(footList(year))
		set y={}
		set y.text=year_##class(websys.Translation).Get("", "年", langId)
		set y.state=$s((year=lastYear):"open",1:"closed")
		set yc=[]
		set month=0
		while($o(footList(year,month))) {
			set month=$o(footList(year,month))
			set m={}
			set m.text=month_##class(websys.Translation).Get("", "月", langId)
			set m.state=$s(((year_month)=(lastYear_lastMonth)):"open",1:"closed")
			do yc.%Push(m)
			set mc=[]
			set day=0
			while($o(footList(year,month,day))) {
				set day=$o(footList(year,month,day))
				set d={}
				set d.text=day_##class(websys.Translation).Get("", "日", langId)
				//set d.state=$s(((year_month_day)=(lastYear_lastMonth_lastDay)):"open",1:"closed")
				set d.state="closed"
				do mc.%Push(d)
				set dc=[]
				set footId=0
				while($o(footList(year,month,day,footId))) {
					set footId=$o(footList(year,month,day,footId))
					set footData=$g(^DHCOPInsFoot(footId))
					set stDate=$p(footData,"^",5)
					set stTime=$p(footData,"^",6)
					set endDate=$p(footData,"^",3)
					set endTime=$p(footData,"^",4)
					set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
					set stTime=##class(websys.Conversions).TimeLogicalToHtml(stTime)
					set endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
					set endTime=##class(websys.Conversions).TimeLogicalToHtml(endTime)
					set f={}
					set f.id=footId
					set f.text=##class(websys.Translation).Get("dhcbill.opbill.dailyhand.csp", "结账号：", langId)_footId
					set p={}
					set p.stDateTime=stDate_" "_stTime
					set p.endDateTime=endDate_" "_endTime
					set f.attributes=p
					do dc.%Push(f)
				}
				set d.children=dc
			}
			set m.children=mc
		}
		set y.children=yc
		do o.%Push(y)
	}
	
	set stream=##class(%GlobalCharacterStream).%New()
	do o.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2019-12-11
/// Description: 取配置的日结结束时间
/// Input: hospId: CT_Hospital.RowId
/// Return: handinEndTime
/// Debug: w ##class(web.DHCOPBillDailyHandin).GetConfHandinEndTime()
ClassMethod GetConfHandinEndTime(hospId As %String) As %String
{
	set handinEndTime=##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.opbill.dailyhand.csp", "HANDENDTIME", "", hospId)
	if (handinEndTime'=""){
		set handinEndTime=##class(websys.Conversions).TimeHtmlToLogical(handinEndTime)
	}
	quit handinEndTime
}

/// Creator: ZhYW
/// CreatDate: 2022-03-21
/// Description: 结算业务表
/// Input: userId:SS_User.RowId, footId:DHC_INVPRTReports.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyHandin).UpdateFootForBizData()
ClassMethod UpdateFootForBizData(userId As %String, footId As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	if ((+userId=0)||(+footId=0)) -1_"^"_"参数错误"
	
	set rtn=0
	
	set footData=$g(^DHCOPInsFoot(footId))
	set hdate=$p(footData,"^",2)
	set htime=$p(footData,"^",7)
	set stDate=$p(footData,"^",5)
	set stTime=$p(footData,"^",6)
	set endDate=$p(footData,"^",3)
	set endTime=$p(footData,"^",4)
	
	ts
	
	for date=stDate:1:endDate {
		//门诊发票表
		set prtRowId=0
		while($o(^DHCINVPRT(0,"UserDate",userId,date,prtRowId))) {
			set prtRowId=$o(^DHCINVPRT(0,"UserDate",userId,date,prtRowId))
			set prtData=$g(^DHCINVPRT(prtRowId))
			set prtFlag=$p(prtData,"^",8)
			continue:(prtFlag="TP")        //过滤预结算记录
			set hospDR=$p(prtData,"^",39)
			continue:(hospDR'=hospId)
			set reportsDR=$p(prtData,"^",6)
			continue:(+reportsDR'=0)
			set myTime=$p(prtData,"^",20)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_INVPRT
				SET PRT_DHCINVPRTR_DR = :footId, PRT_Handin = 'Y', PRT_HandinDate = :hdate, PRT_HandinTime = :htime
				WHERE %ID = :prtRowId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		
		//集中打印发票表
		set ApiRowID=0
		while($o(^DHCINVPRTAPi(0,"UserDate",userId,date,ApiRowID))) {
			set ApiRowID=$o(^DHCINVPRTAPi(0,"UserDate",userId,date,ApiRowID))
			set ApiData=$g(^DHCINVPRTAP(ApiRowID))
			set reportsDR=$p(ApiData,"^",20)
			continue:(+reportsDR'=0)
			set hospDR=$p(ApiData,"^",30)
			continue:(hospDR'=hospId)
			set myTime=$p(ApiData,"^",4)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_AccPayINV
				SET API_INVRep_DR = :footId, API_Handin = 'Y', API_CheckDate = :hdate, API_CheckTime = :htime,
					API_CheckUser_DR = :userId
				WHERE %ID = :ApiRowID)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新预交金表
		set AccRowID=0
		while($o(^DHCACDi("AccM",0,"User",userId,date,AccRowID))) {
			set AccRowID=$o(^DHCACDi("AccM",0,"User",userId,date,AccRowID))
			set sub=0
			while($o(^DHCACDi("AccM",0,"User",userId,date,AccRowID,"AccPD",sub))) {
				set sub=$o(^DHCACDi("AccM",0,"User",userId,date,AccRowID,"AccPD",sub))
				set PDData=$g(^DHCACD("AccM",AccRowID,"AccPD",sub))
				set reportsDR=$p(PDData,"^",7)
				continue:(+reportsDR'=0)
				set hospDR=$p(PDData,"^",15)
			 	continue:(hospDR'=hospId)
				set myTime=$p(PDData,"^",4)
				continue:((date=endDate)&&(myTime>endTime))
				set IPRowID=AccRowID_"||"_sub
				&SQL(
					UPDATE DHC_AccPreDeposit
					SET AccPD_PDFoot_DR = :footId, AccPD_Handin = 'Y', AccPD_FootDate = :hdate, AccPD_FootTime = :htime,
						AccPD_FootUser_DR = :userId
					WHERE %ID = :IPRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
		
		//更新账户结算表，为了方便押金回收
		set AccRowID=0
		while($o(^DHCACDi("AccM",0,"FIDate",date,AccRowID))) {
			set AccRowID=$o(^DHCACDi("AccM",0,"FIDate",date,AccRowID))
			set sub=0
			while($o(^DHCACDi("AccM",0,"FIDate",date,AccRowID,"AccFI",sub))) {
				set sub=$o(^DHCACDi("AccM",0,"FIDate",date,AccRowID,"AccFI",sub))
				set FIData=$g(^DHCACD("AccM",AccRowID,"AccFI",sub))
				set reportsDR=$p(FIData,"^",9)
				continue:(+reportsDR'=0)
				set userDR=$p(FIData,"^",8)
				continue:(userDR'=userId)
				set myTime=$p(FIData,"^",7)
				continue:((date=endDate)&&(myTime>endTime))
				set FIRowID=AccRowID_"||"_sub
				&SQL(
					UPDATE DHC_AccFootInfo
					SET AccFI_IPRep_DR = :footId
					WHERE %ID = :FIRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
		
		//更新卡发票表
		set CIPRowID=0
		while($o(^DHCCARDINVPRTi(0,"UserDate",userId,date,CIPRowID))) {
			set CIPRowID=$o(^DHCCARDINVPRTi(0,"UserDate",userId,date,CIPRowID))
			set CIPData=$g(^DHCCARDINVPRT(CIPRowID))
			set reportsDR=$p(CIPData,"^",9)
			continue:(+reportsDR'=0)
			set hospDR=$p(CIPData,"^",20)
		    continue:(hospDR'=hospId)
			set myTime=$p(CIPData,"^",5)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_CardINVPRT
				SET CIP_INVReports_DR = :footId, CIP_Handin = 'Y', CIP_HandinDate = :hdate, CIP_HandinTime = :htime
				WHERE %ID = :CIPRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新作废发票表
		set voidID=0
		while($o(^DHCVoidInv(0,"UserDate",userId,date,voidID))) {
			set voidID=$o(^DHCVoidInv(0,"UserDate",userId,date,voidID))
			set voidData=$g(^DHCVoidInv(voidID))
			set reportsDR=$p(voidData,"^",6)
			continue:(+reportsDR'=0)
			set hospDR=$p(voidData,"^",12)
			continue:(hospDR'=hospId)
			set voidType=$p(voidData,"^",11)    //VOI_Type
			continue:(voidType'["O")            //过滤非门诊跳号发票记
			set myTime=$p(voidData,"^",2)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_VoidInv
				SET VOI_Report_DR = :footId, VOI_Handin = 'Y', VOI_HandDate = :hdate, VOI_handTime = :htime
				WHERE %ID = :voidID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新急诊留观押金表
		set EccRowID=0
		while($o(^DHCEPMi("EPM",0,"EPMDUserDate",userId,"Date",date,EccRowID))) {
			set EccRowID=$o(^DHCEPMi("EPM",0,"EPMDUserDate",userId,"Date",date,EccRowID))
			set sub=0
			while($o(^DHCEPMi("EPM",0,"EPMDUserDate",userId,"Date",date,EccRowID,"EPMD",sub))) {
				set sub=$o(^DHCEPMi("EPM",0,"EPMDUserDate",userId,"Date",date,EccRowID,"EPMD",sub))
				set EPData=$g(^DHCEPM("EPM",EccRowID,"EPMD",sub))
				set reportsDR=$p(EPData,"^",7)
				continue:(+reportsDR'=0)
				set hospDR=$p(EPData,"^",13)
			    continue:(hospDR'=hospId)
				set myTime=$p(EPData,"^",4)
				continue:((date=endDate)&&(myTime>endTime))
				set IPRowID=EccRowID_"||"_sub
				&SQL(
					UPDATE DHC_EPPreDeposit
					SET EPMD_Report_DR = :footId, EPMD_Handin = 'Y', EPMD_FootDate = :hdate, EPMD_FootTime = :htime,
						EPMD_FootUser_DR = :userId
					WHERE %ID = :IPRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
		
		//更新体检发票表
		set PEIRowID=0
		while($o(^DHCPEINVPRT(0,"USER",userId,date,PEIRowID))) {
			set PEIRowID=$o(^DHCPEINVPRT(0,"USER",userId,date,PEIRowID))
			set PEIData=$g(^DHCPEINVPRT(PEIRowID))
			set myPEIInvNo=$p(PEIData,"^",1)
			continue:(myPEIInvNo["DHCPEYJS")    //过滤预结算记录
			set reportsDR=$p(PEIData,"^",13)
			continue:(+reportsDR'=0)
			set hospDR=$p(PEIData,"^",26)
			continue:(hospDR'=hospId)
			set myTime=$p(PEIData,"^",12)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_PE_INVPRT
				SET PRT_REPORT_DR = :footId, PRT_RPFLAG='Y', PRT_RPDATE = :hdate, PRT_RPTIME = :htime,
					PRT_RPUSER_DR=:userId
				WHERE %ID = :PEIRowID)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新体检集中打印发票表
		set PEIFRowID=0
		while($o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,date,PEIFRowID))) {
			set PEIFRowID=$o(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",userId,date,PEIFRowID))
			set PEIFData=$g(^User.DHCPEINVFocusPrtD(PEIFRowID))
			set reportsDR=$lg(PEIFData,8)
			continue:(+reportsDR'=0)
			set hospDR=$lg(PEIFData,12)
			continue:(hospDR'=hospId)
			set myTime=$lg(PEIFData,6)
			continue:((date=endDate)&&(myTime>endTime))
			&SQL(
				UPDATE DHC_PE_INVFocusprt
				SET IFP_Report_DR = :footId, IFP_ReportFlag = 'Y', IFP_RPDate = :hdate, IFP_RPTime = :htime,
					IFP_RPUser = :userId
				WHERE %ID = :PEIFRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		
		//更新体检充值表
		set PEAPRowID=0
		while($o(^DHCPEAP(0,"UserDate",userId,date,PEAPRowID))) {
			set PEAPRowID=$o(^DHCPEAP(0,"UserDate",userId,date,PEAPRowID))
			set APSub=0
			while($o(^DHCPEAP(0,"UserDate",userId,date,PEAPRowID,APSub))) {
				set APSub=$o(^DHCPEAP(0,"UserDate",userId,date,PEAPRowID,APSub))
				set PEAPData=$g(^DHCPEAP(PEAPRowID,"AC",APSub))
				set reportsDR=$p(PEAPData,"^",9)
				continue:(+reportsDR'=0)
				set hospDR=$p(PEAPData,"^",15)
				continue:(hospDR'=hospId)
				set PEAPType=$p(PEAPData,"^",1)
				continue:(" B R RF "'[(" "_PEAPType_" "))
				set myTime=$p(PEAPData,"^",6)
				continue:((date=endDate)&&(myTime>endTime))
				set APACRowID=PEAPRowID_"||"_APSub
				&SQL(
					UPDATE DHC_PE_APAmountChange
					SET APAC_Report_DR = :footId, APAC_1 = 'Y', APAC_RPDate = :hdate, APAC_RPTime = :htime,
						APAC_RPUser = :userId
					WHERE %ID = :APACRowID
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-03-21
/// Description: 结算业务表
/// Input: footId:DHC_INVPRTReports.RowId
/// Return:
/// Debug: w ##class(web.DHCOPBillDailyHandin).CancelFootForBizData()
ClassMethod CancelFootForBizData(footId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	ts
	
	//更新小条表
    &SQL(SELECT count(*) INTO :num FROM DHC_INVPRT WHERE PRT_DHCINVPRTR_DR = :footId)
    if (num>0) {
		&SQL(
			UPDATE DHC_INVPRT
			SET PRT_DHCINVPRTR_DR = NULL, PRT_Handin = 'N', PRT_HandinDate = NULL, PRT_HandinTime = NULL
			WHERE PRT_DHCINVPRTR_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新集中打印发票表
	&SQL(SELECT count(*) INTO :num FROM DHC_AccPayINV WHERE API_INVRep_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_AccPayINV
			SET API_INVRep_DR = NULL, API_Handin = 'N', API_CheckDate = NULL, API_CheckTime = NULL,
				API_CheckUser_DR = NULL
	   		WHERE API_INVRep_DR = :footId
	   	)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新门诊预交金表
	&SQL(SELECT count(*) INTO :num FROM DHC_AccPreDeposit WHERE AccPD_PDFoot_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_AccPreDeposit
			SET AccPD_PDFoot_DR = NULL, AccPD_Handin = 'N', AccPD_FootDate = NULL, AccPD_FootTime = NULL,
				AccPD_FootUser_DR = NULL
			WHERE AccPD_PDFoot_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新卡发票表
	&SQL(SELECT count(*) INTO :num FROM DHC_CardINVPRT WHERE CIP_INVReports_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_CardINVPRT
			SET CIP_INVReports_DR = NULL, CIP_Handin = 'N', CIP_HandinDate = NULL, CIP_HandinTime = NULL 
			WHERE CIP_INVReports_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新预交金账表
	&SQL(SELECT count(*) INTO :num FROM DHC_AccFootInfo WHERE AccFI_IPRep_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_AccFootInfo
			SET AccFI_IPRep_DR = NULL
			WHERE AccFI_IPRep_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新跳号表
	&SQL(SELECT count(*) INTO :num FROM DHC_VoidInv WHERE VOI_Report_DR = :footId AND VOI_Type IN ('OP', 'OD'))
	if (num>0) {
		&SQL(
			UPDATE DHC_VoidInv
			SET VOI_Report_DR = NULL, VOI_Handin = 'N', VOI_HandDate = NULL, VOI_handTime = NULL
	 		WHERE VOI_Report_DR = :footId AND VOI_Type IN ('OP', 'OD')
	 	)
	 	set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}

	//更新急诊留观押金表
	&SQL(SELECT count(*) INTO :num FROM DHC_EPPreDeposit WHERE EPMD_Report_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_EPPreDeposit
			SET EPMD_Report_DR = NULL, EPMD_Handin = 'N', EPMD_FootDate = NULL, EPMD_FootTime = NULL,
				EPMD_FootUser_DR = NULL
			WHERE EPMD_Report_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新体检发票表
	&SQL(SELECT count(*) INTO :num FROM DHC_PE_INVPRT WHERE PRT_REPORT_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_PE_INVPRT
			SET PRT_REPORT_DR = NULL, PRT_RPFLAG = 'N', PRT_RPDATE = NULL, PRT_RPTIME = NULL, PRT_RPUSER_DR = NULL
			WHERE PRT_REPORT_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新体检集中打印发票表
	&SQL(SELECT count(*) INTO :num FROM DHC_PE_INVFocusprt WHERE IFP_Report_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_PE_INVFocusprt
			SET IFP_Report_DR = NULL, IFP_ReportFlag = 'N', IFP_RPDate = NULL, IFP_RPTime = NULL,
				IFP_RPUser = NULL
			WHERE IFP_Report_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	//更新体检账户表
	&SQL(SELECT count(*) INTO :num FROM DHC_PE_APAmountChange WHERE APAC_Report_DR = :footId)
	if (num>0) {
		&SQL(
			UPDATE DHC_PE_APAmountChange
			SET APAC_Report_DR = NULL, APAC_1 = 'N', APAC_RPDate = NULL, APAC_RPTime = NULL, APAC_RPUser = NULL
			WHERE APAC_Report_DR = :footId
		)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
		
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreatDate: 2018-11-23
/// Modify: ZhYW 2022-03-21
/// Descripiton: 重新生成日结数据(按原日结记录)
/// Input: footId:DHC_INVPRTReports.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillDailyHandin).ReHandin(224)
ClassMethod ReHandin(footId As %String) As %String
{
	set $zt="ERROR"
	set rtn=0
	quit:(footId="") rtn
	quit:'$d(^DHCOPInsFoot(footId)) rtn

	ts

	//删除日报子表
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReportsSub WHERE HisSub_ParRef = :footId)
	if (num>0){
		&SQL(DELETE DHC_INVPRTReportsSub WHERE HisSub_ParRef = :footId)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReportsPaymode WHERE HisPay_ParRef = :footId)
	if (num>0){
		&SQL(DELETE DHC_INVPRTReportsPaymode WHERE HisPay_ParRef = :footId)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReportsInsType WHERE ITC_Rep_ParRef = :footId)
	if (num>0){
		&SQL(DELETE DHC_INVPRTReportsInsType WHERE ITC_Rep_ParRef = :footId)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReportsBalanceSub WHERE HBS_ParRef = :footId)
	if (num>0){
		&SQL(DELETE DHC_INVPRTReportsBalanceSub WHERE HBS_ParRef = :footId)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	&SQL(SELECT count(*) INTO :num FROM DHC_INVPRTReportsINSUType WHERE HisInsu_ParRef = :footId)
	if (num>0){
		&SQL(DELETE DHC_INVPRTReportsINSUType WHERE HisInsu_ParRef = :footId)
		set rtn=SQLCODE
		if (+rtn) tro  quit rtn_"^"_$g(%msg)
	}
	
	set rtn=##class(web.DHCOPBillDailyHandin).CancelFootForBizData(footId)
	if (+rtn) tro  quit rtn
	
	//重新按原条件日结
	set footData=$g(^DHCOPInsFoot(footId))
	set stDate=$p(footData,"^",5)
	set stTime=$p(footData,"^",6)
	set endDate=$p(footData,"^",3)
	set endTime=$p(footData,"^",4)
	set hospDR=$p(footData,"^",66)
	set userDR=$p(footData,"^",8)

	set rtn=##class(web.DHCBillKPIOrder).KPIExecByTaskType("02", stDate, stTime, endDate, endTime, hospDR, userDR, footId)
	if (+rtn) tro  quit rtn
	
	set rtn=##class(web.DHCOPBillDailyHandin).UpdateFootForBizData(userDR, footId, hospDR)
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

}
