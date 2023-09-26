Class web.InExportApp Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.InExportApp","ExportApp")

ClassMethod ExportAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExportAppExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ExportAppExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.InExportApp","ExportApp")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	
	k ^TMPExport("Export")
	s LocDesc="",CTPcpDesc="",LocCode="",CTPcpCode="",SessDOW=""
	s ResRowId=0
	s iLoop=0
	f  s ResRowId=$o(^RB("RES",ResRowId)) q:ResRowId=""  d
	.Q:$D(^RB("RES",ResRowId))=10
	.S CTLocDR=$p(^RB("RES",ResRowId),"^",1)
	.Q:CTLocDR=""
	.s LocDesc=$p(^CTLOC(CTLocDR),"^",2)
	.s LocCode=$p(^CTLOC(CTLocDR),"^",1)
	.
	.s CTPcpDR=$p(^RB("RES",ResRowId),"^",2)
	.q:CTPcpDR=""
	.s CTPcpCode=$p(^CTPCP(CTPcpDR,1),"^",1)
	.s CTPcpDesc=$p(^CTPCP(CTPcpDR,1),"^",2)
	.s DateRowId="" f  s DateRowId=$o(^RB("RES",ResRowId,"DATE",DateRowId)) q:DateRowId=""  d
	..
	..s SessRowId=0 f  s SessRowId=$o(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:SessRowId=""  d
	...Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
	...
	...;S SessRowid=ResDateRowId_"||"_SessRowId
	...s AQRowId="" f  s AQRowId=$o(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"AQ",AQRowId))  q:AQRowId=""   d
	....s AppMethodDR=$p(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"AQ",AQRowId),"^",1)
	....s MethodDesc=$p(^RBC("APTM",AppMethodDR),"^",2)      ;预约类型名
	....s AQQty=$p(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"AQ",AQRowId),"^",2) //预约一种类型的数量
	....s AQStartNum=$p($g(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"AQ",AQRowId)),"^",3)
	....;s AQQtytmp=""
	....;i AQStartNum'="" s AQQtytmp=AQStartNum+AQQty-1
	....;s AQStartNumTmp=AQStartNum_"-"_AQQtytmp
	....;i AQStartNumTmp="-" s AQStartNumTmp=""
	....q:MethodDesc'["爱康"
	....S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
	....i SessDOWRowid'="" s SessDOW=$P(^CT("DOW",1,SessDOWRowid),"^",1)
	....S SessTimeStart=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
	....s SessTimeStartNum=SessTimeStart
	....i SessTimeStart'="" s SessTimeStart=..%ZT(SessTimeStart)
	....S SessTimeEnd=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
	....i SessTimeEnd'="" s SessTimeEnd=..%ZT(SessTimeEnd)
	....S SessSlotLength=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",7)
	....S SessLoad=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
	....S SessNoSlots=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",6)
	....S SessNoApptSlot=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
	....S SessNumberOfWeeks=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
	....S SessNoOverbookAll=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
	....s SessRoom=""
	....S SessRoomRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",19)
	....i SessRoomRowid'="" s SessRoom=$p(^CTLOC(SessRoomRowid),"^",2)
	....s SessType=""
	....S SessTypeRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",9)
	....i SessTypeRowid'="" s SessType=$P(^RBC("SESS",SessTypeRowid),"^",2)
	....s SessClinicGroup=""
	....S SessClinicGroupRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",35)
	....i SessClinicGroupRowid'="" s SessClinicGroup=$P(^RBC("CLGRP",SessClinicGroupRowid),"^",2)
	....S SessPatientType=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",11)
	....;SessNo代表上午,下午,晚上等的时间分段
	....S TRRowId=..GetTimeRangeByTime(SessTimeStartNum)
	....if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	....e  s TRDesc="其他"
	....S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",16)
	....s ^TMPExport("Export",CTLocDR,iLoop)=CTLocDR_"^"_LocDesc_"^"_CTPcpDR_"^"_CTPcpDesc_"^"_TRDesc_"^"_AQQty_"^"_AQStartNum_"^"_SessDOW
	....s iLoop=iLoop+1
	....set Data=$lb(CTLocDR,LocDesc,CTPcpDR,CTPcpDesc,TRDesc,AQQty,AQStartNum,CTLocDR,CTPcpDR,TRRowId,iLoop,SessDOW)
	....Set ^CacheTemp(repid,ind)=Data
	....Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod ExportAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportAppExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ExportApp() As %Query(ROWSPEC = "TDeptCode:%String,TDeptDesc:%String,TDocCode:%String,TDocDesc:%String,TTimeRang:%String,TAppAmount:%String,TStartNum:%String,TCTLocDR:%String,TCTPcpDR:%String,TTRRowId:%String,TNum:%String,DocAdmWeek:%String")
{
}

ClassMethod GetTimeRangeByTime(SessTime As %String) As %String
{
	s find=0,ret=""
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")!(find=1)  d
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.i (SessTime'<StartTime)&&(SessTime'>EndTime) d
	..s find=1
	..s ret=TRRowId
	.Q:find=1
	Q ret
}

ClassMethod GetNumble()
{
	s Count=0
	s Loctmpid=""
	f  s Loctmpid=$o(^TMPExport("Export",Loctmpid)) q:Loctmpid=""  d
	.s tmpid="" f  s tmpid=$o(^TMPExport("Export",Loctmpid,tmpid)) q:tmpid=""  d
	..s Count=Count+1
	;s ^guo("Count")=$o(^TMPExport("Export",""),-1)
	q Count
}

ClassMethod GetExportValue(num)
{
	s ParTmpid=""
	s cont=0
	f  s ParTmpid=$o(^TMPExport("Export",ParTmpid)) q:ParTmpid=""  d
	.s numbleid="" f  s numbleid=$o(^TMPExport("Export",ParTmpid,numbleid)) q:numbleid=""  d
	..s ^TMPExport("ExportTMP",cont)=^TMPExport("Export",ParTmpid,numbleid)
	..s cont=cont+1
	
	s tmp=^TMPExport("ExportTMP",num)
	q:tmp=""
	Q tmp
    /*s LOCRowid=""
	f  s LOCRowid=$o(^TMPExport("Export",LOCRowid))  Q:LOCRowid=""  d
	.s DOCRowid="" f  s DOCRowid=$o(^TMPExport("Export",LOCRowid,DOCRowid)) q:DOCRowid=""  d
	..s RangRowid="" f  s RangRowid=$o(^TMPExport("Export",LOCRowid,DOCRowid,RangRowid)) q:RangRowid=""  d
	...
	*/
}

// 将JS传过来的数据导入到表中

ClassMethod InExportValue(str)
{
	;w ##class(web.InExportApp).InExportValue("2008-03-27^上午^陈静^000000000282^0010000000821860^110103197509231226^1975-09-23^女^13911156267^1442^CKDMZ-产科东门诊^黄醒华^2^21977")
	//k ^TMPInExport("InExport")
	
	s PatAdmDate=$p(str,"^",1)
	S ASDate=$zdh(PatAdmDate,3)
	s PatAdmTime=$p(str,"^",2)	
	s PatName=$p(str,"^",3)
	s PatAdmCardNo=$p(str,"^",4)
	q:'$d(^DHCCARDi("CF",0,"CardNo",PatAdmCardNo)) "200系统中没有此卡号!"
	s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",PatAdmCardNo,""))
	s PatientID=$p(^DHCCARD("CF",CardRowid),"^",4)
	s CheckName=$p(^PAPER(PatientID,"ALL"),"^",1)   //用于与传入的病人姓名作比较
	q:PatName'=CheckName "201病人姓名与卡号不符!"                     
	s AaiKangCardNo=$p(str,"^",5)
	s CredNo=$p(str,"^",6)
	s PatBirth=$p(str,"^",7)
	s Sex=$p(str,"^",8)
	s PatTel=$p(str,"^",9)
	s LocCode=$p(str,"^",10)
	s LocName=$p(str,"^",11)
	s DocName=$p(str,"^",12)
	s SeqNo=$p(str,"^",13)
	s QueueNo=SeqNo
	s DocCode=$p(str,"^",14)
	s RESRowid=$o(^RB("RES",0,"CTPCP",DocCode,LocCode,0))
	//q:RESRowid=""
	//取开始时间
	s TRDesc="",StartTime=""
	s TRRowid="" f  s TRRowid=$o(^DHCTimeRange(TRRowid)) q:(TRRowid="")||(TRDesc=PatAdmTime)  d
	.s StartTime=$p(^DHCTimeRange(TRRowid),"^",3)
	.s TRDesc=$p(^DHCTimeRange(TRRowid),"^",2)
	.q:TRDesc=PatAdmTime
	s ^guo("inExportaaa",PatientID)=PatientID_"^"_RESRowid_"^"_TRDesc
	s RoomID=""
	s ASRowId=$o(^RBAS(RESRowid,0,"DateSTime",ASDate,StartTime,0))
	s ASRowId=RESRowid_"||"_ASRowId
	;s rtn=##Class(web.DHCRBResourceRule).CheckSchedule(RESRowid, ASDate, RoomID, StartTime, ASRowId)
	s rtn=##class(web.DHCRBApptSchedule).CheckScheduleFull(ASRowId)
	q:rtn'=0 +rtn
	s ^TMPInExport("InExport",LocCode,DocCode,SeqNo)=PatAdmDate_"^"_PatAdmTime_"^"_PatName_"^"_PatAdmCardNo_"^"_AaiKangCardNo_"^"_CredNo_"^"_PatBirth_"^"_Sex_"^"_PatTel_"^"_LocCode_"^"_LocName_"^"_DocCode_"^"_DocName_"^"_SeqNo
	s UserRowId=""
	s ret=##Class(web.DHCOPAdmReg).OPAppAiKangBroker("","", PatientID, ASRowId, QueueNo, UserRowId)
	s retcode=$P(ret,"^",1)
	s ^rong("guorongyong")=retcode_"^"_PatAdmDate
	q retcode
}

// 实现导入数据展示

ClassMethod InExportAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InExportAppExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InExportAppExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.InExportApp","ExportApp")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s LocRowid=""
	f  s LocRowid=$o(^TMPInExport("InExport",LocRowid)) q:LocRowid=""  d
	.s DocRowid="" f  s DocRowid=$o(^TMPInExport("InExport",LocRowid,DocRowid)) q:DocRowid=""  d
	..s SeqNoid="" f  s SeqNoid=$o(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid)) q:SeqNoid=""  d
	...s PatAdmDate=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",1)
	...s PatAdmTime=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",2)
	...s PatName=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",3)
	...s PatAdmCardNo=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",4)
	...s AaiKangCardNo=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",5)
	...s CredNo=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",6)
	...s PatBirth=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",7)
	...s Sex=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",8)
	...s PatTel=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",9)
	...s LocCode=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",10)
	...s LocName=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",11)
	...s DocCode=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",12)
	...s DocName=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",13)
	...s SeqNo=$p(^TMPInExport("InExport",LocRowid,DocRowid,SeqNoid),"^",14)
	...set Data=$lb(PatAdmDate,PatAdmTime,PatName,PatAdmCardNo,AaiKangCardNo,CredNo,PatBirth,Sex,PatTel,LocCode,LocName,DocCode,DocName,SeqNo)
	...Set ^CacheTemp(repid,ind)=Data
	...Set ind=ind+1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod InExportAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InExportAppExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query InExportApp() As %Query(ROWSPEC = "PatAdmDate:%String,PatAdmTime:%String,PatName:%String,PatAdmCardNo:%String,AaiKangCardNo:%String,CredNo:%String,PatBirth:%String,Sex:%String,PatTel:%String,LocCode:%String,LocName:%String,DocCode:%String,DocName:%String,SeqNo:%String")
{
}

ClassMethod KTMP()
{
	k ^TMPInExport
	q
}

// ---------------------------------预约黑名单begin-------------------------------

Query BlackList(SttDate As %String, EndDate As %String, CardNo1 As %String, RegNo1 As %String, Name As %String, PatIDCard As %String = "", Blacktype As %String = "", BlackIsActive As %String = "") As %Query(ROWSPEC = "ApptPatName:%String,CardNo:%String,RegNo:%String,StDate:%String,TEndDate:%String,InfoFlag:%String,update:%String,PBRowId:%String,PatientID:%String,IDCardNo:%String,TPAPMICardType:%String,AddUser:%String,TBlackType:%String,TBlackNote:%String")
{
}

ClassMethod BlackListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BlackListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BlackListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BlackListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BlackListExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String, CardNo1 As %String, RegNo1 As %String, Name As %String, PatIDCard As %String = "", Blacktype As %String = "", BlackIsActive As %String = "") As %Status
{
	s ^scl("mmmm")=SttDate_","_EndDate_","_CardNo1_","_RegNo1_","_PatIDCard_","_Blacktype
	;d ##class(%ResultSet).RunQuery("web.InExportApp","BlackList","","","","","")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	//d ..CreatBlackList(SttDate)
	if SttDate'="" S SttDate=..%ZDH(SttDate)
	if EndDate'="" S EndDate=..%ZDH(EndDate)
	s PBRowId=0
	Set CardNo="",RegNo=""
	if PatIDCard=""{
	f  s PBRowId=$o(^DHCPBL(PBRowId)) q:PBRowId=""  d
		.d GetPBInfo
	}else{
		s PatIDCard=$zcvt(PatIDCard,"U")
		f  s PBRowId=$o(^DHCPBL(0,"IDCardNo",PatIDCard,PBRowId)) q:PBRowId=""  d
		.d GetPBInfo
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPBInfo
	s StDate=$p(^DHCPBL(PBRowId),"^",14)
	if StDate="" s StDate=$p(^DHCPBL(PBRowId),"^",4)
    s PatientID=$p(^DHCPBL(PBRowId),"^",2)
    s CardNo=""
    if PatientID'=""  do
    .s ApptPatName=$p(^PAPER(PatientID,"ALL"),"^",1)
    .s RegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
    .Set IDCardNo=$p(^PAPER(PatientID,"PAT",3),"^",6) //$p(^PAPER(PatientID,"ALL"),"^",9)
    .s TPAPMICardType="" //i IDCardNo'=""
	.set TPAPMICardType=$s(+$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(PatientID,"PAT",3)),"^",7))),"^",2),1:"")
    .q:((RegNo1'="")&&(RegNo'=RegNo1))
    .q:((Name'="")&&(Name'=ApptPatName))
    .s BlackTypeDr=$p(^DHCPBL(PBRowId),"^",12)
    .q:(Blacktype'="")&&(BlackTypeDr'=Blacktype)
    .s CFRowID=0
    .f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID)) q:CFRowID=""  d
    ..s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
    ..q:ActiveFlag'="N"
    ..s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
    .q:((CardNo1'="")&&(CardNo'=CardNo1))
    .d OutputRow
    else  do
    .Set IDCardNo=$p(^DHCPBL(PBRowId),"^",9)
    .Set ApptPatName=$p(^DHCPBL(PBRowId),"^",10)
    .d OutputRow
    quit
OutputRow
     s BlackConfig=$g(^BlackDateAndCountConfig("Config"))
    s BlackDate=$p(BlackConfig,"^",1)
    s:StDate="" StDate=..%SysDate()
    q:((SttDate'="")&&(StDate<SttDate)&&(RegNo1="")&&(PatIDCard=""))
    if (+BlackDate>0) s BlackDate=BlackDate-1
    s TEndDate=$p(^DHCPBL(PBRowId),"^",15)
    if TEndDate="" s TEndDate=StDate+BlackDate
	q:(EndDate'="")&&(StDate>EndDate)&&(RegNo1="")&&(PatIDCard="")
    s ActiveFlag=$p(^DHCPBL(PBRowId),"^",8)
    i ActiveFlag="" s ActiveFlag=1
    i TEndDate<+$h s ActiveFlag=0
    
    q:(ActiveFlag=0)&&(BlackIsActive="Y")
	q:(ActiveFlag'=0)&&(BlackIsActive="N")
    s AddUserDr=$p(^DHCPBL(PBRowId),"^",11)
    s AddUser=""
    if AddUserDr'="" s AddUser=$p(^SSU("SSUSR",AddUserDr),"^",2)
	s TEndDate=..%ZD(TEndDate) //$zd(TEndDate,3)
    s:StDate'="" StDate=..%ZD(StDate) //$zd(StDate,3)
	s:StDate="" StDate=..%ZD(+$h) //$zd(+$h,3)
	
    s InfoFlag=ActiveFlag
    s BlackType=""
    s BlackTypeDr=$p(^DHCPBL(PBRowId),"^",12)
    if BlackTypeDr'="" s BlackType=$P($G(^DHCBlackType("DHCBlackType",BlackTypeDr)),"^",2)
    s BlackNote=$p(^DHCPBL(PBRowId),"^",13)
	set Data=$lb(ApptPatName,CardNo,RegNo,StDate,TEndDate,InfoFlag,update,PBRowId,PatientID,IDCardNo,TPAPMICardType,AddUser,BlackType,BlackNote)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

// 更新黑名单的状态

ClassMethod SetBlackStatus(PBRowId As %String) As %String
{
	Set object = ##class(User.DHCPAPersonBlackList).%OpenId(PBRowId)
	s object.PBActiveFlag=0
	s object.PBLastUpdateDate=..%SysDate()
	s object.PBLastUpdateTime=..%SysTime()
	s object.PBActiveEndDate=..%SysDate()
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Tro
		Do $System.Status.DisplayError()
		Q 100
	}
	d object.%Close()
	Q 0
}

// 黑名单日期和次数配置

// Date:黑名单的有效日期(如:生成黑名单后二个月内不允许预约挂号,维护60)  Count：爽约次数  SYDate:统计爽约次数的时间范围(如:一个月内爽约3次写入黑名单，维护30)

ClassMethod UpdateConfig(Date As %String, Count As %String, SYDate As %String) As %String
{
	s ^BlackDateAndCountConfig("Config")=Date_"^"_Count_"^"_SYDate
	q 0
}

// 查找到的病人违约信息

Query FindApptInfo(PatientID As %String, PatName As %String, RegNo As %String, IDCardNo As %String = "") As %Query(ROWSPEC = "PatName:%String,RegNo:%String,Loc:%String,Doc:%String,SYDate:%String")
{
}

ClassMethod FindApptInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApptInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApptInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApptInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindApptInfoExecute(ByRef qHandle As %Binary, PatientID As %String, PatName As %String, RegNo As %String, IDCardNo As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.InExportApp","BlackList","","")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	Set PatientId=PatientID
	if PatientId'=""{
		Set BlackListDate=##class(web.DHCRBAppointment).GetBlackListEndDate(PatientId,"")
		Set ResRowid=0
		for  Set ResRowid=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid)) Quit:ResRowid=""  do
		.Set ASChild=0
		.For  Set ASChild=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid,ASChild)) Quit:ASChild=""  do
		..Set ASDate=$p(^RBAS(ResRowid,ASChild),"^",1)
		..Quit:ASDate>BlackListDate
		..Set APPChild=0
		..for  Set APPChild=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid,ASChild,APPChild)) Quit:APPChild=""  do
		...Set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
		...Set RegNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
		...s DocID=$P(^RB("RES",ResRowid),"^",2)
		...Quit:DocID=""
		...s Doc=$P($g(^CTPCP(DocID,1)),"^",2)
		...s DepRowId=$P(^RB("RES",ResRowid),"^",1)
		...s Loc=$p($g(^CTLOC(DepRowId)),"^",2)
		...s SYDate=$p($g(^RBAS(ResRowid,ASChild)),"^",1)
		...s SYDate=..%ZD(SYDate)
		...set Data=$lb(PatName,RegNo,Loc,Doc,SYDate)
		...Set ^CacheTemp(repid,ind)=Data
		...Set ind=ind+1
	}
	if IDCardNo'="" {
		Set BlackListDate=##class(web.DHCRBAppointment).GetBlackListEndDate("",IDCardNo)
		Set RESRowId=0
		for  Set RESRowId=$o(^RBAS("CredNo",IDCardNo,RESRowId)) Quit:RESRowId=""  do
		.Set ASChildSub=0
		.for  Set ASChildSub=$o(^RBAS("CredNo",IDCardNo,RESRowId,ASChildSub)) Quit:ASChildSub=""  do
		..s ASDate=$P($G(^RBAS(RESRowId,ASChildSub)),"^",1)
		..Quit:ASDate>BlackListDate	
		..Set APPTChildSub=0
		..for  s APPTChildSub=$o(^RBAS("CredNo",IDCardNo,RESRowId,ASChildSub,APPTChildSub)) Quit:APPTChildSub=""  do
		...Set AdmStatus=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3)
		...Quit:AdmStatus'="J"	
		...s DocID=$P(^RB("RES",RESRowId),"^",2)
		...Quit:DocID=""
		...s Doc=$P($g(^CTPCP(DocID,1)),"^",2)
		...s DepRowId=$P(^RB("RES",RESRowId),"^",1)
		...s Loc=$p($g(^CTLOC(DepRowId)),"^",2)
		...s SYDate=$p($g(^RBAS(RESRowId,ASChildSub)),"^",1)
		...s SYDate=..%ZD(SYDate)
		...set Data=$lb(PatName,RegNo,Loc,Doc,SYDate)
		...Set ^CacheTemp(repid,ind)=Data
		...Set ind=ind+1
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetBlackConfig() As %String
{
	q $g(^BlackDateAndCountConfig("Config"))
}

// ---------------------------------预约黑名单end-------------------------------

/// 根据卡号或登记号或身份证号和类型查询是否是黑名单患者
/// 是：1，否：0
ClassMethod CheckforBlackList(Type As %String, CardNo As %String = "", CardType As %String = "", PatientNo As %String = "", IDCardNo As %String = "")
{
	q:Type="" 0
	q:((CardNo="")&&(PatientNo="")&&(IDCardNo="")) 0
	Set LimitAppDays=$p($g(^BlackDateAndCountConfig("Config")),"^",1)
	s rtn=0
	s PatientID=""
	if ((CardNo'="")&&(CardType'="")){
		s cardid=0 f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardid)) q:(cardid="")  d
		.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
		.q:ActiveFlag'="N"
		.s CFCardTypeDR=$p(^DHCCARD("CF",cardid),"^",16)
		.q:CFCardTypeDR'=CardType
		.s PatientID=$p(^DHCCARD("CF",cardid),"^",4)
	}elseif(PatientNo'=""){
		s PatientID=$o(^PAPERi("PAPMI_PatNo",PatientNo,""))
	}
	s PBRowId=""
	if (PatientID'=""){
		for{
			s PBRowId=$O(^DHCPBL("0","PAPMI",PatientID,PBRowId)) 
			q:PBRowId=""
			q:rtn'=0
			s PBType=$p(^DHCPBL(PBRowId),"^",12)
			continue:PBType'=Type
			Set EndDate=$p(^DHCPBL(PBRowId),"^",4)
			s ActiveFlag=$p(^DHCPBL(PBRowId),"^",8)
		    i ActiveFlag="" s ActiveFlag=1
		    if ((+LimitAppDays=0))||((EndDate+(+LimitAppDays))<=(+$h))  {
			    s ActiveFlag=0
			}
		    //i (EndDate'="")&&(EndDate<=..%SysDate()) s ActiveFlag=0
		    i ActiveFlag=1 s rtn=1_"^"_PBRowId
		}
	}elseif(IDCardNo'=""){
		for{
			s PBRowId=$O(^DHCPBL("0","IDCardNo",IDCardNo,PBRowId)) 
			q:PBRowId=""
			q:rtn'=0
			s PBType=$p(^DHCPBL(PBRowId),"^",12)
			continue:PBType'=Type
			Set EndDate=$p(^DHCPBL(PBRowId),"^",4)
			s ActiveFlag=$p(^DHCPBL(PBRowId),"^",8)
		    i ActiveFlag="" s ActiveFlag=1
		    if ((+LimitAppDays=0))||((EndDate+(+LimitAppDays))<=(+$h))  {
			    s ActiveFlag=0
			}
		    //i (EndDate'="")&&(EndDate<=..%SysDate()) s ActiveFlag=0
		    i ActiveFlag=1 s rtn=1_"^"_PBRowId
		}
	}
	q rtn
}

/// 黑名单类型插入
/// w ##class(web.InExportApp).InsertBlackType("","App","预约")
ClassMethod InsertBlackType(ID As %String = "", Code As %String = "", Desc As %String = "", ExecuteCode As %String = "", HospID = "")
{
	q:((Code="")||(Desc="")) ""
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_BlackListType",HospID)
	s rtn=""
	if (ID=""){
		&SQL(insert into SQLUser.DHC_BlackListType (DHCBlackCode,DHCBlackDesc,DHCBlackExecuteCode) Values(:Code,:Desc,:ExecuteCode))
		s rtn=SQLCODE
		if 'rtn{
			d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_BlackListType",$p(%ROWID,$c(1)),HospID)
		}
	}else{
		&SQL(Update SQLUser.DHC_BlackListType set DHCBlackCode=:Code,DHCBlackDesc=:Desc,DHCBlackExecuteCode=:ExecuteCode where DHCBlackType_RowId=:ID)
		s rtn=SQLCODE
	}
	q rtn
}

/// 黑名单类型删除
ClassMethod DelectBlackType(ID As %String = "")
{
	q:ID="" ""
	s rtn=""
	&SQL(DELETE SQLUser.DHC_BlackListType where DHCBlackType_RowId=:ID)
	s rtn=SQLCODE
	d ##class(DHCDoc.Common.Hospital).DeleteHospitals("DHC_BlackListType",ID)
	q rtn
}

/// 查询黑名单类型
Query FindBlackListType(HospID = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,RowId:%String,ExecuteCode:%String")
{
}

ClassMethod FindBlackListTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBlackListTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBlackListTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBlackListTypeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBlackListTypeExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.InExportApp","FindBlackListType")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s Rowid=""
	for {
		s Rowid=$O(^DHCBlackType("DHCBlackType",Rowid))
		q:Rowid=""
		;黑名单类型维护页面、黑名单维护-黑名单类型 共用此query，但维护页面需显示所有维护数据
		continue:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_BlackListType",Rowid,HospID))
		s Code=$P(^DHCBlackType("DHCBlackType",Rowid),"^",1)
		s Desc=$P(^DHCBlackType("DHCBlackType",Rowid),"^",2)
		s ExecuteCode=$P(^DHCBlackType("DHCBlackType",Rowid),"^",3)
		set Data=$lb(Code,Desc,Rowid,ExecuteCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
