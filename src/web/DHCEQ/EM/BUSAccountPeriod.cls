Class web.DHCEQ.EM.BUSAccountPeriod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountPeriod","AccountPeriodList")
Query AccountPeriodList() As %Query(ROWSPEC = "APRowID:%String,APYear:%String,APMonth:%String,APStartDate:%String,APStartTime:%String,APEndDate:%String,APEndTime:%String,APHospitalDR:%String,APHospital:%String,APSnapID:%String,APEquipTypeIDs:%String,APUser:%String,APDate:%String,APTime:%String,APReportStat:%String,APDepreStat:%String,APRemark:%String,APHold1:%String,APHold2:%String,APHold3:%String,APHold4:%String,APHold5:%String")
{
}

ClassMethod AccountPeriodListExecute(ByRef qHandle As %Binary) As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=""
	f  s rowid=$o(^DHCEQAccountPeriod(rowid),-1)  q:rowid=0  Do
	.Do BuildDataAccountPeriodList
	Quit $$$OK
BuildDataAccountPeriodList
    Do ResetVariablesAccountPeriodList
	s Datalist=$Get(^DHCEQAccountPeriod(rowid))
	q:$p(Datalist,"^",16)="Y"
	Set APRowID=rowid
	Set APYear=$p(Datalist,"^",1)
	Set APMonth=$p(Datalist,"^",2)
	Set APStartDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",3),"date")
	Set APStartTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",4),"time")
	Set APEndDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",5),"date")
	Set APEndTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",6),"time")
	Set APHospitalDR=$p(Datalist,"^",7)
	if APHospitalDR'="" Set APHospital=$Piece($Get(^CT("HOSP",APHospitalDR)),"^",2)
	Set APSnapID=$p(Datalist,"^",8)
	Set APEquipTypeIDs=$p(Datalist,"^",9)
	Set APUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(Datalist,"^",10))
	Set APDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",11),"date")
	Set APTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",3),"time")
	Set APReportStat=$Case($p(Datalist,"^",13),0:"正常",1:"数据检查正常",2:"任务或执行异常",3:"数据检测异常","":"")	//0,正常；1.数据检查正常；2.任务或执行异常；3.数据检测异常
	Set APDepreStat=$Case($p(Datalist,"^",14),0:"正常",1:"数据检查正常",2:"任务或执行异常",3:"数据检测异常","":"")	//0,正常；1.数据检查正常；2.任务或执行异常；3.数据检测异常
	Set APRemark=$p(Datalist,"^",15)
	//Set APInvalidFlag=$p(Datalist,"^",16)
	Set APHold1=$p(Datalist,"^",17)
	Set APHold2=$p(Datalist,"^",18)
	Set APHold3=$p(Datalist,"^",19)
	Set APHold4=$p(Datalist,"^",20)
	Set APHold5=$p(Datalist,"^",21)
	d OutputRowAccountPeriodList
 	
	Quit
OutputRowAccountPeriodList
	Set Data=$ListBuild(APRowID,APYear,APMonth,APStartDate,APStartTime,APEndDate,APEndTime,APHospitalDR,APHospital,APSnapID,APEquipTypeIDs,APUser,APDate,APTime,APReportStat,APDepreStat,APRemark,APHold1,APHold2,APHold3,APHold4,APHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesAccountPeriodList
	Set (Datalist,APRowID,APYear,APMonth,APStartDate,APStartTime,APEndDate,APEndTime,APHospitalDR,APHospital,APSnapID,APEquipTypeIDs,APUser,APDate,APTime,APReportStat,APDepreStat,APRemark,APHold1,APHold2,APHold3,APHold4,APHold5)=""
	Quit
}

ClassMethod AccountPeriodListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccountPeriodListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AccountPeriodListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccountPeriodListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSAccountPeriod).ExecuteJob(data)
ClassMethod ExecuteJob(data)
{
	new RowID,Date,Result,SQLCODE,APRowID,Datalist
	new MonthStr,DepreTypeDR,Node,DepreStat,SnapID,ReportStat
	k PLIST,RowID
	s Date=$H
	s $ZT="ERRORAccountPeriod"
	TSTART
	s Result=##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveData(data)
	s SQLCODE=$p(Result,"^",1)
	s APRowID=$p(Result,"^",2)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"已经存在会计周期的折旧月结(ID="_APRowID_",不能重复执行!")
	}
	
	s Datalist=$Get(^DHCEQAccountPeriod(APRowID))
	Set APYear=$p(Datalist,"^",1)
	Set APMonth=$p(Datalist,"^",2)
	
	s MonthStr=APYear_"-"_APMonth
	s (Result,SnapID,ReportStat,DepreStat)=""
	
	s DepreTypeDR=1
	s Node="MonthDepre"
	i DepreTypeDR'=1 s Node="MonthDepre"_DepreTypeDR
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的月份
	//s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s Result= ##class(web.DHCEQMonthDepre).GetMonthDepre(MonthStr,"",DepreTypeDR)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
	i Result=0  d
	.s DepreStat=0
	e  d
	.s DepreStat=2
	
	i Result'=0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Result,"Depre"_DepreStat)
	}
	
	if Result=0
	{
		s Node="Snap"
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		s Result= ##Class(web.DHCEQSnapShot).Snap(MonthStr)
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
		s SnapID=$g(^DHCEQSnapShot(0,"Month",MonthStr))
		i Result'=0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Result,"Snap"_Result)
		}
	}
	if Result=0
	{
		s Node="MonthReport"
		s Result=""
		s ^DHCEQLog("Job",Node,Date,"Begin")=$H
		//s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(ReportDate)
		//实物月报
		s Result= ##class(web.DHCEQReport).SaveMonthReport(MonthStr,"","",0,APRowID)
		//财务月报
		//s Result= ##class(web.DHCEQReport).SaveMonthReport(MonthStr,"","","1")
		s ^DHCEQLog("Job",Node,Date,"Result")=Result
		s ^DHCEQLog("Job",Node,Date,"End")=$H
		i Result=0  d
		.s ReportStat=0
		e  d
		.s ReportStat=2
		i Result'=0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Result,"Report"_ReportStat)
		}
	}
	k PLIST
	s PLIST(9) = SnapID	;SnapID
	s PLIST(14) = ReportStat	;ReportStat
	s PLIST(15) = DepreStat	;DepreStat
	
	&SQL(update SQLUSER.DHC_EQAccountPeriod Values :PLIST() where AP_RowID=:APRowID)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,APRowID)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,APRowID)
ERRORAccountPeriod
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveData(data)
ClassMethod SaveData(data)
{
	new RowID,User,Time,JsonData,APYear,APMonth,tmp,SQLCODE
	s SQLCODE=0
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=$H
 	s Time=$Piece($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAccountPeriod",JsonData,.PLIST)
	s APYear = JsonData.APYear
	s APMonth = JsonData.APMonth
	s tmp=""
	&SQL(select AP_RowID into :tmp from SQLUSER.DHC_EQAccountPeriod where AP_Year=:APYear and AP_Month=:APMonth and AP_InvalidFlag<>'Y')
	if tmp'="" q "-9200^tmp"
	//s EquipTypeIDs = ##Class(web.DHCEQCommon).GetEquipTypesByGroup()
	//s PLIST(10)=##class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
 	s PLIST(11) = User	;UserDR
 	s PLIST(12) = +Date	;Date
	s PLIST(13) = Time	;Time
	s PLIST(17) = "N"
	&SQL(insert into SQLUSER.DHC_EQAccountPeriod Values :PLIST())
	i SQLCODE
	{
		q SQLCODE
	}
	s RowID=$g(%ROWID)
	q SQLCODE_"^"_RowID
}

/// w ##Class(web.DHCEQ.EM.BUSAccountPeriod).SaveDataList(APRowID,BussType,BussID)
ClassMethod SaveDataList(APRowID, BussType, BussID)
{
	new tmp,SQLCODE
	s SQLCODE=0
	k PLIST
	s tmp=""
	&SQL(select APL_RowID into :tmp from SQLUSER.DHC_EQAccountPeriodList where APL_AccountPeriodDR=:APRowID and APL_BussType=:BussType and APL_BussID=:BussID)
	if tmp'="" q "-9200^tmp"
 	s PLIST(2) = APRowID	;AccountPeriodDR
	s PLIST(3) = BussType	;BussType
	s PLIST(4) = BussID		;BussID
	&SQL(insert into SQLUSER.DHC_EQAccountPeriodList Values :PLIST())
	q SQLCODE
}

/// modified by ZY0298
/// 增加取消折旧的操作
/// w ##Class(web.DHCEQ.EM.BUSAccountPeriod).CancelJob(7)
ClassMethod CancelJob(APRowID)
{
	new SQLCODE,Datalist,APYear,APMonth,SnapID,MonthStr,DepreTypeDR
	s (Datalist,APYear,APMonth,SnapID,MonthStr,DepreTypeDR)=""
	s SQLCODE=0
	s $ZT="ERRORCancelAccountPeriod"
	TSTART
	&SQL(update SQLUSER.DHC_EQAccountPeriod set AP_InvalidFlag='Y' where AP_RowID=:APRowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"无效手工折旧月结记录失败!(ID="_APRowID)
	}
	
	s Datalist=$Get(^DHCEQAccountPeriod(APRowID))
	s APYear=$p(Datalist,"^",1)
	s APMonth=$p(Datalist,"^",2)
	s SnapID=$p(Datalist,"^",8)
	s MonthStr=APYear_"-"_APMonth
	
	k ^DHCEQSnapShot(SnapID)
	k ^DHCEQSnapShot(0,"Month",MonthStr)
	
	&SQL(delete from  SQLUSER.DHC_EQMonthReportList where MRL_MonthStr=:MonthStr)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"取消手工月结记录失败!(MonthStr="_MonthStr)
	}
	
	
	s DepreTypeDR=1
	s SQLCODE= ##class(web.DHCEQMonthDepre).CancelMonthDepre(MonthStr,DepreTypeDR)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"取消手工折旧记录失败!(MonthStr="_MonthStr)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,APRowID)
ERRORCancelAccountPeriod
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// modified by ZY0298
/// 用于提醒业务与会计周期是否一致,不一致时界面要增加提醒
/// w ##Class(web.DHCEQ.EM.BUSAccountPeriod).IsCurPeriod()
ClassMethod IsCurPeriod()
{
	new rowid,NewAPYear,NewAPMonth,NewMonthStr,flag
	s (rowid,NewAPYear,NewAPMonth,NewMonthStr)=""
	f  s rowid=$o(^DHCEQAccountPeriod(rowid),-1)   q:(rowid="")||(NewMonthStr'="")  Do
	.s Datalist=$Get(^DHCEQAccountPeriod(rowid))
	.q:$p(Datalist,"^",16)="Y"
	.s NewAPYear=$p(Datalist,"^",1)
	.s NewAPMonth=$p(Datalist,"^",2)+1
	.i NewAPMonth=13 d
	..s NewAPYear=NewAPYear+1
	..s NewAPMonth=1
	.i NewAPMonth<10 s NewAPMonth="0"_NewAPMonth
	.s NewMonthStr=NewAPYear_"-"_NewAPMonth
	s flag=1
	s CurMonthStr=$p($ZD(+$H,"3"),"-",1,2)
	i NewMonthStr="" s NewMonthStr=CurMonthStr	//没有做报表初始化的时候,就记当前月,保证业务可以正常审核
	i (NewMonthStr'=CurMonthStr) s flag=0
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(flag,NewMonthStr)
}

}
