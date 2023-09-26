Class web.DHCOPAdmRegQuery Extends DHCDoc.Util.RegisteredObject
{

ClassMethod RegNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegNumQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegQuery","RegNumQuery",62298,62298,"","","")

ClassMethod RegNumQueryExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	//w "<table><tr><td><font color = red>剩余号数如果为负就是额外加号数量</font></td></tr></table>"
	s Job=$J
	k ^TempDHCOPReg(Job)
	s LogonHospId=%session.Get("LOGON.HOSPID")
	i StartDate="" s StartDate=20
	i EndDate="" s EndDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
 	s ind=2
 	s Date=StartDate-1
 	i (DocID'="")&&(DocDesc'="") d
 	.s CurLocID=""
 	.f  s CurLocID=$O(^RB("RES",0,"CTPCP",DocID,CurLocID)) q:CurLocID=""  d
 	..
 	..q:(LocID'="")&&(LocID'=CurLocID)
 	..s RESID=""
 	..f  s RESID=$O(^RB("RES",0,"CTPCP",DocID,CurLocID,RESID)) q:RESID=""  d
 	...d OneRESID(RESID)
 	e  i LocID'="" d
 	.s RESID=""
 	.f  s RESID=$O(^RB("RES",0,"CTLOC",LocID,RESID)) q:RESID=""  d
 	..s CurDocID=$P(^RB("RES",RESID),"^",2)
 	..d OneRESID(RESID)
 	e  d
 	.s RESID=""
 	.f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	..d OneRESID(RESID)
 	//^TempDHCOPReg(Job,TLocID,TDocID,TimeRange,Sort)
 	s TotalRegLoadNum=0
 	s TotalOverbookNum=0
 	s TotalRegNum=0
 	s TotalPRemainNum=0  //大于0剩余号
 	s TotalNRemainNum=0  //小于0额外加号的
 	s TotalSNum=0
 	s TotalPSNum=0
 	s TotalRNum=0
 	s TotalANum=0
 	s TotalARNum=0
 	s TotalTRNum=0
 	s TotalFNum=0
 	s TLocID=""
 	f  s TLocID=$O(^TempDHCOPReg(Job,TLocID)) q:TLocID=""  d
 	.s TLoc=$P(^CTLOC(TLocID),"^",2)
 	.i $L(TLoc,"-")>1 d
 	..s TLoc=$P(TLoc,"-",2,4)
 	.s LocDesc=TLoc
 	.s OneTotalRegLoadNum=0
 	.s OneTotalOverbookNum=0
 	.s OneTotalRegNum=0
 	.s OneTotalPRemainNum=0  //大于0剩余号
 	.s OneTotalNRemainNum=0  //小于0额外加号的
 	.s OneTotalSNum=0
 	.s OneTotalPSNum=0
 	.s OneTotalRNum=0
 	.s OneTotalANum=0
 	.s OneTotalARNum=0
 	.s OneTotalTRNum=0
 	.s OneTotalFNum=0
 	.s TDocID=""
 	.f  s TDocID=$O(^TempDHCOPReg(Job,TLocID,TDocID)) q:TDocID=""  d
 	..s TDoc=$P(^CTPCP(TDocID,1),"^",2)
 	..s Date=""
 	..f  s Date=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date)) q:Date=""  d
 	...s TDate=..%ZD(Date) //$ZD(Date,3)
 	...s TTimeRangeID=""
 	...f  s TTimeRangeID=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date,TTimeRangeID)) q:TTimeRangeID=""  d
 	....s TTimeRange=$P(^DHCTimeRange(TTimeRangeID),"^",2)
 	....s NumStr=$G(^TempDHCOPReg(Job,TLocID,TDocID,Date,TTimeRangeID))
 	....//1正号^2加号^3挂出号^4剩余号^5停号^6中途停号^7替诊^8加号^9补诊^10被替诊^11锁定
 	....s TRegLoadNum=$P(NumStr,"^",1)
 	....s OneTotalRegLoadNum=OneTotalRegLoadNum+(+TRegLoadNum)
 	....s TOverbookNum=$P(NumStr,"^",2)
 	....s OneTotalOverbookNum=OneTotalOverbookNum+(+TOverbookNum)
 	....s TRegNum=$P(NumStr,"^",3)
 	....s:TRegNum=0 TRegNum=""
 	....s OneTotalRegNum=OneTotalRegNum+(+TRegNum)
 	....s TRemainNum=$P(NumStr,"^",4)
 	....i +TRemainNum>0 d
 	.....s OneTotalPRemainNum=OneTotalPRemainNum+(+TRemainNum)
 	....e  d
 	.....s OneTotalNRemainNum=OneTotalNRemainNum+(+TRemainNum)
 	....s TSNum=$P(NumStr,"^",5)
 	....s OneTotalSNum=OneTotalSNum+(+TSNum)
 	....s:TSNum=0 TSNum=""
 	....s TPSNum=$P(NumStr,"^",6)
 	....s OneTotalPSNum=OneTotalPSNum+(+TPSNum)
 	....s:TPSNum=0 TPSNum=""
 	....s TRNum=$P(NumStr,"^",7)
 	....s OneTotalRNum=OneTotalRNum+(+TRNum)
 	....s:TRNum=0 TRNum=""
 	....s TANum=$P(NumStr,"^",8)
 	....s OneTotalANum=OneTotalANum+(+TANum)
 	....s:TANum=0 TANum=""
 	....s TARNum=$P(NumStr,"^",9)
 	....s OneTotalARNum=OneTotalARNum+(+TARNum)
 	....s:TARNum=0 TARNum=""
 	....s TTRNum=$P(NumStr,"^",10)
 	....s OneTotalTRNum=OneTotalTRNum+(+TTRNum)
 	....s:TTRNum=0 TTRNum=""
 	....s TFNum=$P(NumStr,"^",11)
 	....s OneTotalFNum=OneTotalFNum+(+TFNum)
 	....s:TFNum=0 TFNum=""
 	....d:(OnlyLocTotal'="on")&&(OnlyLocTotal'="1") FindBuild
 	....s TLoc=""
 	....s TDoc=""
 	....s TDate=""
 	.//总计求值
 	.s TotalRegLoadNum=TotalRegLoadNum+OneTotalRegLoadNum
 	.s TotalOverbookNum=TotalOverbookNum+OneTotalOverbookNum
 	.s TotalRegNum=TotalRegNum+OneTotalRegNum
 	.s TotalPRemainNum=TotalPRemainNum+OneTotalPRemainNum
 	.s TotalNRemainNum=TotalNRemainNum+OneTotalNRemainNum
 	.s TotalSNum=TotalSNum+OneTotalSNum
 	.s TotalPSNum=TotalPSNum+OneTotalPSNum
 	.s TotalRNum=TotalRNum+OneTotalRNum
 	.s TotalANum=TotalANum+OneTotalANum
 	.s TotalARNum=TotalARNum+OneTotalARNum
 	.s TotalTRNum=TotalTRNum+OneTotalTRNum
 	.s TotalFNum=TotalFNum+OneTotalFNum
 	.//输出科室合计
 	.s TTimeRange=LocDesc_"合计"
 	.s TRegLoadNum=OneTotalRegLoadNum
 	.s:TRegLoadNum=0 TRegLoadNum=""
 	.s TRegNum=OneTotalRegNum
 	.s:TRegNum=0 TRegNum=""
 	.s TOverbookNum=OneTotalOverbookNum
 	.s:TOverbookNum=0 TOverbookNum=""
 	.s TRemainNum=""
 	.i OneTotalPRemainNum'=0 s TRemainNum=OneTotalPRemainNum
 	.i OneTotalNRemainNum'=0 d
 	..s:TRemainNum'="" TRemainNum=TRemainNum_"("_OneTotalNRemainNum_")"
 	..s:TRemainNum="" TRemainNum=OneTotalNRemainNum
 	.s TSNum=OneTotalSNum
 	.s:TSNum=0 TSNum=""
 	.s TPSNum=OneTotalPSNum
 	.s:TPSNum=0 TPSNum=""
 	.s TRNum=OneTotalRNum
 	.s:TRNum=0 TRNum=""
 	.s TANum=OneTotalANum
 	.s:TANum=0 TANum=""
 	.s TARNum=OneTotalARNum
 	.s:TARNum=0 TARNum=""
 	.s TTRNum=OneTotalTRNum
 	.s:TTRNum=0 TTRNum=""
 	.s TFNum=OneTotalFNum
 	.s:TFNum=0 TFNum=""
 	.d FindBuild
 	s ind=1
 	//总计
 	s TLoc=""
 	s TDoc=""
 	s TDate=""
 	s TTimeRange="总计"
 	s TRegLoadNum=TotalRegLoadNum
 	s:TRegLoadNum=0 TRegLoadNum=""
 	s TRegNum=TotalRegNum
 	s:TRegNum=0 TRegNum=""
 	s TOverbookNum=TotalOverbookNum
 	s:TOverbookNum=0 TOverbookNum=""
 	s TRemainNum=""
 	i TotalPRemainNum'=0 s TRemainNum=TotalPRemainNum
 	i TotalNRemainNum'=0 d
 	.s:TRemainNum'="" TRemainNum=TRemainNum_"("_TotalNRemainNum_")"
 	.s:TRemainNum="" TRemainNum=TotalNRemainNum
 	s TSNum=TotalSNum
 	s:TSNum=0 TSNum=""
 	s TPSNum=TotalPSNum
 	s:TPSNum=0 TPSNum=""
 	s TRNum=TotalRNum
 	s:TRNum=0 TRNum=""
 	s TANum=TotalANum
 	s:TANum=0 TANum=""
 	s TARNum=TotalARNum
 	s:TARNum=0 TARNum=""
 	s TTRNum=TotalTRNum
 	s:TTRNum=0 TTRNum=""
 	s TFNum=TotalFNum
 	s:TFNum=0 TFNum=""
 	d FindBuild
 	k ^TempDHCOPReg(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneRESID(RESID)
	s TLocID=$P($G(^RB("RES",RESID)),"^",1)
	q:TLocID=""
	s CTLocHospDr=$p($g(^CTLOC(TLocID)),"^",22)
	q:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
	s TDocID=$P($G(^RB("RES",RESID)),"^",2)
	q:TDocID=""
	s Date=StartDate-1
	f  s Date=$O(^RBAS(RESID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)  d
	.s essStartTime=0
	.f  s essStartTime=$O(^RBAS(RESID,0,"DateSTime",Date,essStartTime)) q:(essStartTime="")  d
	..s sub=0
	..f  s sub=$O(^RBAS(RESID,0,"DateSTime",Date,essStartTime,sub)) q:(sub="")  d
	...s SessonType=$P($G(^RBAS(RESID,sub,"DHC")),"^",6)
	...q:(SessionTypeID'="")&&(SessionTypeID'=SessonType)
	...s TimeRange=$P($G(^RBAS(RESID,sub,"DHC")),"^",17)
	...q:TimeRange=""
	...q:(TimeRangeID'="")&&(TimeRangeID'=TimeRange)
	...s AddRegNum=+$P($G(^RBAS(RESID,sub,"DHC")),"^",26)
	...s Status=$P(^RBAS(RESID,sub,"DHC"),"^",10)
	...s:Status'="" Status=$P(^DHCRBCASStatus(Status),"^",1)
	...Q:(Status="AUD")
	...s (StopNum,PStopNum,RNum,ANum,ARNum,TRNum,FNum,RemainNum,RegLoadNum,OverbookNum,RegisterNum)=0
	...;i '((Status="S")||(Status="TR")||(Status="PS")) d
	...s RegLoadNum=$P(^RBAS(RESID,sub),"^",8)
	...s StopRegNoFlag=$P($G(^RBAS(+RESID,sub,"DHC")),"^",27) //停正号标识
	...i StopRegNoFlag="Y" s RegLoadNum=0
	...s OverbookNum=$P(^RBAS(RESID,sub,"DHC"),"^",3)
	...//s QueueNO=$P(^RBAS(RESID,sub,"DHC"),"^",4)
	...//s retnum=##class(web.DHCRBResourceRule).GetRegisterNum(QueueNO)
	...s RegisterNum=..GetRegNumByAS(RESID_"||"_sub)
	...//s RegisterNum=$P(retnum,"^",1) //挂出号
	...//s AppedNum=$P(retnum,"^",2)
	...//s AppedArriveNum=$P(retnum,"^",3)
	...
	...//s Sort=+$O(^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRange,""),-1)
	...//s Sort=Sort+1
	...//s ^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRange,Sort)=RegLoadNum_"^"_OverbookNum_"^"_RegisterNum_"^"_RemainNum
	...
	...i Status="S" s StopNum=(+RegLoadNum)+(+OverbookNum) //停诊
	...i Status="PS" s PStopNum=(+RegLoadNum)+(+OverbookNum)-(+RegisterNum) //中途停诊
	...i Status="R" s RNum=(+RegLoadNum)+(+OverbookNum) //替诊
	...i Status="A" s ANum=(+RegLoadNum)+(+OverbookNum) //加诊
	...i (Status'="A")&&(Status'="S")&&(Status'="PS")&&(Status'="TR") d
	....s ANum=ANum+AddRegNum
	...i Status="AR" s ARNum=(+RegLoadNum)+(+OverbookNum) //补诊
	...i Status="TR" s TRNum=(+RegLoadNum)+(+OverbookNum) //被替诊
	...i Status="F" s FNum=(+RegLoadNum)+(+OverbookNum)-(+RegisterNum) //锁定
	...s RemainNum=##class(web.DHCRBAppointment).GetAvailableNum(RESID_"||"_sub,"NOR","WIN","") //+(RegLoadNum)+(+OverbookNum)-(+RegisterNum)-(+$G(StopNum))-(+$G(PStopNum))-(+$G(TRNum))-(+$G(FNum))
	...i (Status="S")||(Status="TR") s RemainNum=0
	...s ^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRange)=RegLoadNum_"^"_OverbookNum_"^"_RegisterNum_"^"_RemainNum_"^"_$G(StopNum)_"^"_$G(PStopNum)_"^"_$G(RNum)_"^"_$G(ANum)_"^"_$G(ARNum)_"^"_$G(TRNum)_"^"_$G(FNum)
	q
FindBuild
																						
	set Data=$lb(TLoc,TDoc,TDate,TTimeRange,TRegLoadNum,TRegNum,TRemainNum,TOverbookNum,TSNum,TPSNum,TRNum,TANum,TARNum,TTRNum,TFNum)
																						
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RegNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegNumQueryExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query RegNumQuery(StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Query(ROWSPEC = "TLoc:%String,TDoc:%String,TDate:%String,TTimeRange:%String,TRegLoadNum:%String,TRegNum:%String,TRemainNum:%String,TOverbookNum:%String,TStopNum:%String,TPStopNum:%String,TReplaceNum:%String,TAddRegNum:%String,TRepairNum:%String,TTRNum:%String,TFNum:%String")
{
}

/*Query SearchTimeRange(TimeRange As %String="") As %SQLQuery(ROWSPEC = "HIDDEN:%String,Code:%String, Desc:%String")
{
 select TR_RowId,TR_Code,TR_Desc from Sqluser.DHC_TimeRange 
 where ((%ALPHAUP TR_Code [ %ALPHAUP :TimeRange) or (:TimeRange is null))
 or ((%ALPHAUP TR_Desc [ %ALPHAUP :TimeRange) or (:TimeRange is null))
}*/
Query SearchTimeRange(TimeRange As %String = "", HospID As %String = "") As %Query(ROWSPEC = "HIDDEN:%String,Code:%String, Desc:%String")
{
}

ClassMethod SearchTimeRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegNumQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod SearchTimeRangeExecute(ByRef qHandle As %Binary, TimeRange As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	if $g(ind) = "" set ind = 1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s TRRowid=0
 	f  s TRRowid=$o(^DHCTimeRange(TRRowid)) q:TRRowid=""  d
 	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TRRowid,HospID)
 	.s TRCode=$p(^DHCTimeRange(TRRowid),"^",1)
 	.s TRDesc=$p(^DHCTimeRange(TRRowid),"^",2)
 	.q:(TimeRange'="")&&($$ALPHAUP^SSUTIL4(TRCode)'[$$ALPHAUP^SSUTIL4(TimeRange))&&($$ALPHAUP^SSUTIL4(TRDesc)'[$$ALPHAUP^SSUTIL4(TimeRange))
 	.s StartDate=$p(^DHCTimeRange(TRRowid),"^",7)
 	.q:(StartDate'="")&&(StartDate>+$h)
 	.s EndDate=$p(^DHCTimeRange(TRRowid),"^",8)
 	.q:(EndDate'="")&&(EndDate<=..%SysDate())
 	.set Data=$lb(TRRowid,TRCode,TRDesc)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SearchTimeRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegNumQueryExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query SearchSessionTypeOld(Desc As %String = "") As %SQLQuery(ROWSPEC = "HIDDEN:%String,Code:%String, Desc:%String")
{
 select SESS_RowId,SESS_Code,SESS_Desc from Sqluser.RBC_SessionType where SESS_Desc %STARTSWITH :Desc
}

Query SearchSessionType(Desc = "", HospID = "") As %Query(ROWSPEC = "HIDDEN:%String,Code:%String, Desc:%String")
{
}

ClassMethod SearchSessionTypeExecute(ByRef qHandle As %Binary, Desc = "", HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ID=0 f  s ID=$O(^RBC("SESS",ID)) Q:ID=""  d
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",ID,HospID)
	.s DateTo=$P(^RBC("SESS",ID),"^",7)
	.q:(DateTo'="")&&(DateTo<=..%SysDate())
	.s DateFrom=$P(^RBC("SESS",ID),"^",6)
	.q:(DateFrom>+$H)||(DateFrom="")
	.s Code=$P(^RBC("SESS",ID),"^",1)
	.s SessDesc=$P(^RBC("SESS",ID),"^",2)
	.s qHandle($I(ind))=$LB(ID,Code,SessDesc)
	Quit $$$OK
}

ClassMethod SearchSessionTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSessionTypeExecute ]
{
	s ind=$O(qHandle(""))
	if ind'=""{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

// ##class(web.DHCOPAdmRegQuery).GetDefaultTimeRange()

ClassMethod GetDefaultTimeRange(Type)
{
	s Time=..%SysTime()
	;多时段重叠的时候不适用；lxz
	;s TimeRangeID=##class(web.DHCOPAdmReg).GetTimeRangeByTime(Time)
	s TimeRangeID=##class(web.DHCRBResSession).GetTimeRangeByTime(Time)
	q:Type="ID" TimeRangeID
	i TimeRangeID'="" q $P(^DHCTimeRange(TimeRangeID),"^",2)
	q ""
}

// w ##class(web.DHCOPAdmRegQuery).GetRegNumByAS("3226||20")

ClassMethod GetRegNumByAS(AsID As %String = "") As %String
{
	q:AsID="" ""
	s Num=""
	s ID=""
	f  s ID=$O(^User.DHCRegistrationFeeI("RBASDr",AsID,ID)) q:ID=""  d
	.s obj=##class(User.DHCRegistrationFee).%OpenId(ID)
	.s ADM=obj.RegfeeAdmDr.%Id()
	.s Status=$P(^PAADM(ADM),"^",20)
	.q:Status="C"
	.s Num=+Num+1
	q Num
}

// w ##class(web.DHCOPAdmRegQuery).GetResRowIdStr("","")

ClassMethod GetResRowIdStr(QRoomID, QClinicGroup)
{
	s ResRowIdStr=""
	s RESID=""
 	f  s RESID=$O(^RB("RES",RESID)) q:RESID=""  d
 	.i ResRowIdStr="" s ResRowIdStr=RESID
	.e  s ResRowIdStr=ResRowIdStr_"^"_RESID
	q ResRowIdStr
}

ClassMethod RBASRequestQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBASRequestQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegQuery","RBASRequestQuery",62298,62298,"","","")

ClassMethod RBASRequestQueryExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", ChkAudit As %String = "", ChkHadAudit As %String = "", ChkRefuse As %String = "", ChkDelete As %String = "", FindType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	if (StartDate="")&&(EndDate="")&&(LocID="")&&(DocID="")&&(TimeRangeID="")&&(SessionTypeID="")&&(ChkAudit="")&&(ChkHadAudit="")&&(ChkRefuse="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i StartDate="" s StartDate=1
	i EndDate="" s EndDate=..%SysDate()+200
	s CurUserID=%session.Get("LOGON.USERID")
	//s Date=StartDate-1
	i (ChkAudit="")&&(ChkHadAudit="")&&(ChkRefuse="")&&(ChkDelete=""){
		s RequestType=""
		f  s RequestType=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType)) q:RequestType=""  d
		.s Result=""
		.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
		..d OneTypeResult
	}else{
		s RequestType=""
		f  s RequestType=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType)) q:RequestType=""  d
		.i ChkAudit'="" d
		..s Result=" N"
		..d OneTypeResult
		.i ChkHadAudit'="" d
		..s Result=" A"
		..d OneTypeResult
		.i ChkRefuse'="" d
		..s Result=" R"
		..d OneTypeResult
		.i ChkDelete'="" d
		..s Result=" D"
		..d OneTypeResult
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneTypeResult
	s Date=StartDate-1
	f  s Date=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result,Date)) q:(Date="")||(Date>EndDate)  d
	.s ID=0
	.f  s ID=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result,Date,ID)) q:ID=""  d
	..d OneInfoOut
	q
	
OneInfoOut
	s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
	s curLoc=obj.ASRRBASID.ASRESParRef.RESCTLOCDRGetObjectId()
	q:(LocID'="")&&(LocID'=curLoc)
	s curDoc=obj.ASRRBASID.ASRESParRef.RESCTPCPDRGetObjectId()
	q:(DocID'="")&&(DocID'=curDoc)
	q:(CurUserID'="")&&('##class(web.DHCUserGroup).UserCanDo(CurUserID,curLoc,curDoc))
	s TDate=obj.ASRRBASID.ASDate
	s RBASID=obj.ASRRBASIDGetObjectId()
	s DHCRBASObj=##class(User.RBApptSchedule).%OpenId(RBASID)
	s curSessionType=obj.ASRRBASID.ASSessionTypeDRGetObjectId()
	q:(SessionTypeID'="")&&(curSessionType'=SessionType)
	s curTimeRange=obj.ASRRBASID.ASTimeRangeDRGetObjectId()
	q:(TimeRangeID'="")&&(curTimeRange'=TimeRangeID)
	s TResult=obj.ASRRequestResult
	s TSelect="0"
	s:TResult="N" TSelect="1"
	s TResult=..GetRequestResultDesc(TResult)
	s TID=ID
	s TLocDesc=obj.ASRRBASID.ASRESParRef.RESCTLOCDR.CTLOCDesc
	s TDocDesc=obj.ASRRBASID.ASRESParRef.RESCTPCPDR.CTPCPDesc
	s:TDate'="" TDate=$ZD(TDate,3)
	s TTimeRange=obj.ASRRBASID.ASTimeRangeDR.TRDesc
	s TSessionType=obj.ASRRBASID.ASSessionTypeDR.SESSDesc
	s TRegNum=DHCRBASObj.ASLoad
	s TReason=obj.ASRReasonDR.RNAVDesc
	s TRLocDesc=obj.ASRLocDR.CTLOCDesc
	s TRDocDesc=obj.ASRDoctorDR.CTPCPDesc
	s TRSessionType=obj.ASRSessionTypeDR.SESSDesc
	d FindRBASRequestBuild
	q
FindRBASRequestBuild
	set Data=$lb(TSelect,TID,TLocDesc,TDocDesc,TDate,TTimeRange,TSessionType,TRegNum,TReason,TRLocDesc,TRDocDesc,TRSessionType,TResult)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RBASRequestQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBASRequestQueryExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query RBASRequestQuery(StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", ChkAudit As %String = "", ChkHadAudit As %String = "", ChkRefuse As %String = "", ChkDelete As %String = "", FindType As %String = "") As %Query(ROWSPEC = "TSelect:%String,TID:%String,TLocDesc:%String,TDocDesc:%String,TDate:%String,TTimeRange:%String,TSessionType:%String,TRegNum:%String,TReason:%String,TRLocDesc:%String,TRDocDesc:%String,TRSessionType:%String,TResult:%String")
{
}

ClassMethod ResourceQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResourceQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegQuery","ResourceQuery",62298,62298,"","","")

ClassMethod ResourceQueryExecute(ByRef qHandle As %Binary, DepartID As %String = "", HadSubmit As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=100
	if Type="" s Type="REG"
	if (DepartID="")
	{
		s UserID=%session.Get("LOGON.USERID")
		s Type=" "_Type ;护士加号权限与排班权限使用同一存储结构，以类型字段区分
		s LocID=" "
		f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc",Type," "_UserID,LocID)) q:LocID=""  d
		.s DepartID=$P(LocID," ",2)
		.s SubmitInfo=$G(^CTLOC(DepartID,"RBSSubmit")) //Flag_"^"_Date,Time_"^"_User
		.s Flag=$P(SubmitInfo,"^",1)
		.q:(HadSubmit="Y")&&(Flag'="S")
		.d OneDepart(DepartID)
	}else{
		d OneDepart(DepartID)
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	q
OneDepart(DepartID)
	k ^TempDHCOPRBResource($J)
	s LocDesc=$P(^CTLOC(DepartID),"^",2)
	i $L(LocDesc,"-")>1 d
	.s LocDesc=$P(LocDesc,"-",2,4)
	s SubmitInfo=$G(^CTLOC(DepartID,"RBSSubmit")) //Flag_"^"_Date,Time_"^"_User
	s Flag=$P(SubmitInfo,"^",1)
	s Info=LocDesc_"未提交;"
	i Flag="S" s Info=LocDesc_"已提交;"
	w "<font color = red>"_Info_"</font>"
	
	s RBID=0
	f  s RBID=$O(^RB("RES",0,"CTLOC",DepartID,RBID)) q:RBID=""  d
	.s ScheSt=$p(^RB("RES",RBID),"^",6)
	.q:ScheSt'="Y"
	.;s ScheType=$p(^RB("RES",RBID),"^",6)
	.;q:ScheType'="Care Provider"
	.s DocDR=$p(^RB("RES",RBID),"^",2)
	.s REDSub=""
	.f  s REDSub=$O(^RB("RES",RBID,"DATE",REDSub),-1) q:REDSub=""  d
	..s REDSSub=0
	..f  s REDSSub=$O(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub)) q:REDSSub=""  d
	...s DowDR=$P($G(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub)),"^",2)
	...q:DowDR=""
	...s SessionTypeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",9)
	...q:SessionTypeDR=""
	...s SessionTypeCode=$P(^RBC("SESS",SessionTypeDR),"^",1)
	...i SessionTypeCode="" s SessionTypeCode="99999"
	...s TimeRangeDR=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",3)
	...q:TimeRangeDR=""
	...s LoadNum=$P(^RB("RES",RBID,"DATE",REDSub,"SESS",REDSSub),"^",8)
	...s ^TempDHCOPRBResource($J,SessionTypeCode,SessionTypeDR,DocDR,DowDR,TimeRangeDR)=LoadNum_"^"_RBID
	s (Total(1,1),Total(1,2),Total(1,3),Total(1,4),Total(2,1),Total(2,2),Total(2,3),Total(2,4),Total(3,1),Total(3,2),Total(3,3),Total(3,4),Total(4,1),Total(4,2),Total(4,3),Total(4,4),Total(5,1),Total(5,2),Total(5,3),Total(5,4),Total(6,1),Total(6,2),Total(6,3),Total(6,4),Total(7,1),Total(7,2),Total(7,3),Total(7,4),Total(8,1),Total(8,2),Total(8,3),Total(8,4))=""
	s TDepartDesc=LocDesc
	s total=0
	s TypeCode=""
	f  s TypeCode=$O(^TempDHCOPRBResource($J,TypeCode)) q:TypeCode=""  d
	.s SessionTypeDR=0
	.f  s SessionTypeDR=$O(^TempDHCOPRBResource($J,TypeCode,SessionTypeDR)) q:SessionTypeDR=""  d
	..s SessionType=$P(^RBC("SESS",SessionTypeDR),"^",2)
	..s (SessionTotal(1,1),SessionTotal(1,2),SessionTotal(1,3),SessionTotal(1,4),SessionTotal(2,1),SessionTotal(2,2),SessionTotal(2,3),SessionTotal(2,4),SessionTotal(3,1),SessionTotal(3,2),SessionTotal(3,3),SessionTotal(3,4),SessionTotal(4,1),SessionTotal(4,2),SessionTotal(4,3),SessionTotal(4,4),SessionTotal(5,1),SessionTotal(5,2),SessionTotal(5,3),SessionTotal(5,4),SessionTotal(6,1),SessionTotal(6,2),SessionTotal(6,3),SessionTotal(6,4),SessionTotal(7,1),SessionTotal(7,2),SessionTotal(7,3),SessionTotal(7,4),SessionTotal(8,1),SessionTotal(8,2),SessionTotal(8,3),SessionTotal(8,4))=""
	..s SessionTotal=0
	..s DocDR=0
	..f  s DocDR=$O(^TempDHCOPRBResource($J,TypeCode,SessionTypeDR,DocDR)) q:DocDR=""  d
	...s total=total+1
	...s SessionTotal=SessionTotal+1
	...d clearvar
	
	...s DocDesc=$P(^CTPCP(DocDR,1),"^",2)
	...s TDocDesc=DocDesc
	...s TSessionType=SessionType
	...s DowDR=0
	...f  s DowDR=$O(^TempDHCOPRBResource($J,TypeCode,SessionTypeDR,DocDR,DowDR)) q:DowDR=""  d
	....s TimeRangeDR=0
	....f  s TimeRangeDR=$O(^TempDHCOPRBResource($J,TypeCode,SessionTypeDR,DocDR,DowDR,TimeRangeDR)) q:TimeRangeDR=""  d
	.....s Info=$G(^TempDHCOPRBResource($J,TypeCode,SessionTypeDR,DocDR,DowDR,TimeRangeDR))
	.....s RBResID=$P(Info,"^",2)
	.....s PLIST(DowDR,TimeRangeDR)=+Info
	.....s PLIST(DowDR,4)=PLIST(DowDR,4)+PLIST(DowDR,TimeRangeDR)
	...f i=1:1:7 d
	....f j=1:1:4 d
	.....s PLIST(8,j)=PLIST(8,j)+PLIST(i,j)
	...d FindResourceBuild
	...s TDepartDesc=""
	...f i=1:1:8 d
	....f j=1:1:4 d
	.....s Total(i,j)=Total(i,j)+PLIST(i,j)
	.....s SessionTotal(i,j)=SessionTotal(i,j)+PLIST(i,j)
	...s SessionType=""
	..i SessionTotal>1 d
	...d clearvar
	...s TDocDesc="合计"
	...m PLIST=SessionTotal
	...d FindResourceBuild
	i total>1 d
	.d clearvar
	.s ind=ind+1
	.;s TSessionType=LocDesc
	.s TDocDesc="总计"
	.m PLIST=Total
	.d FindResourceBuild
	q
	

clearvar
	s (TSessionType,TDocDesc,PLIST(1,1),PLIST(1,2),PLIST(1,3),PLIST(1,4),PLIST(2,1),PLIST(2,2),PLIST(2,3),PLIST(2,4),PLIST(3,1),PLIST(3,2),PLIST(3,3),PLIST(3,4),PLIST(4,1),PLIST(4,2),PLIST(4,3),PLIST(4,4),PLIST(5,1),PLIST(5,2),PLIST(5,3),PLIST(5,4),PLIST(6,1),PLIST(6,2),PLIST(6,3),PLIST(6,4),PLIST(7,1),PLIST(7,2),PLIST(7,3),PLIST(7,4),PLIST(8,1),PLIST(8,2),PLIST(8,3),PLIST(8,4),RBResID)=""
	q
FindResourceBuild
	f i=1:1:8 d
	.f j=1:1:4 d
	..s:PLIST(i,j)=0 PLIST(i,j)=""
	set Data=$lb(TSessionType,TDocDesc,PLIST(1,1),PLIST(1,2),PLIST(1,3),PLIST(1,4),PLIST(2,1),PLIST(2,2),PLIST(2,3),PLIST(2,4),PLIST(3,1),PLIST(3,2),PLIST(3,3),PLIST(3,4),PLIST(4,1),PLIST(4,2),PLIST(4,3),PLIST(4,4),PLIST(5,1),PLIST(5,2),PLIST(5,3),PLIST(5,4),PLIST(6,1),PLIST(6,2),PLIST(6,3),PLIST(6,4),PLIST(7,1),PLIST(7,2),PLIST(7,3),PLIST(7,4),PLIST(8,1),PLIST(8,2),PLIST(8,3),PLIST(8,4),RBResID,TDepartDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ResourceQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResourceQueryExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query ResourceQuery(DepartID As %String = "", HadSubmit As %String = "", Type As %String = "") As %Query(ROWSPEC = "TSessionType:%String,TDocDesc:%String,TMon1:%String,TMon2:%String,TMon3:%String,TMon4:%String,TTues1:%String,TTues2:%String,TTues3:%String,TTues4:%String,TWed1:%String,TWed2:%String,TWed3:%String,TWed4:%String,TThurs1:%String,TThurs2:%String,TThurs3:%String,TThurs4:%String,TFriday1:%String,TFriday2:%String,TFriday3:%String,TFriday4:%String,TSat1:%String,TSat2:%String,TSat3:%String,TSat4:%String,TSun1:%String,TSun2:%String,TSun3:%String,TSun4:%String,TTotal1:%String,TTotal2:%String,TTotal3:%String,TTotal4:%String,RBResID:%String,TDepartDesc:%String")
{
}

// w ##class(web.DHCOPAdmRegQuery).GetTreeLocStr("0^0")

ClassMethod GetTreeLocStr(LocID, hospitalId)
{
	//--select * from CT_LocationList
	//select * from CT_LocationList_Locations
	//q "[{'id': '1','text':'科室1','leaf':true},{'id': '2','text':'科室2','leaf':false}]"
	s OneStr="{'id': 'LocID','text':'LocDesc','leaf':TrueOrFalse}"
	s RetStr=""
	s ID=$P(LocID,"^",1)
	s Type=$P(LocID,"^",2)
	i Type=0{
		s id=0
		f  s id=$O(^CT("LL",id)) q:id=""  d
		.q:$O(^CT("LL",id,"LOC",0))=""
		.s Desc=$P(^CT("LL",id),"^",2)
		.s Str=..Replace(OneStr,"LocID",id_"^1")
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","false")
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	}
	i Type=1{
		s Sub=0
		f  s Sub=$O(^CT("LL",ID,"LOC",Sub)) q:Sub=""  d
		.s id=$P(^CT("LL",ID,"LOC",Sub),"^",1)
		.s Flag="false"
		.s:$O(^DHCLocSubject(0,"LOC",id,0))="" Flag="true"
		.s curHospital=$P(^CTLOC(id),"^",22)
		.q:curHospital'=hospitalId
		.s Desc=$P(^CTLOC(id),"^",2)
		.s Length=$L(Desc,"-")
		.s Desc=$P(Desc,"-",2,Length)
		.s Str=..Replace(OneStr,"LocID",id_"^2")
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse",Flag)
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	}
	i Type=2{
		s LocSubID=0
		f  s LocSubID=$O(^DHCLocSubject(0,"LOC",ID,LocSubID)) q:LocSubID=""  d
		.s id=$P(^DHCLocSubject(LocSubID),"^",2)
		.s Desc=$P(^RBC("CLGRP",id),"^",2)
		.s Str=..Replace(OneStr,"LocID",id_"^3^"_ID)
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","true")
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	}
	i RetStr'="" s RetStr="["_RetStr_"]"
	q RetStr
}

ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

ClassMethod GetRequestResultDesc(TResult)
{
	q:TResult="N" "待审核"
	q:TResult="A" "已审核"
	q:TResult="D" "已撤销"
	q:TResult="R" "已拒绝"
}

// 科室排班提交S;取消提交C

ClassMethod LocSubmit(LocID As %String = "", Type As %String = "S", User As %String = "1")
{
	s SubmitInfo=$G(^CTLOC(LocID,"RBSSubmit")) //Flag_"^"_Date,Time_"^"_User
	s Flag=$P(SubmitInfo,"^",1)
	q:(Type="S")&&(Flag="S") "已经提交不能再次提交"
	q:(Type="C")&&(Flag'="S") "还未提交不需要取消提交"
	s DateInfo=$H
	//s User=%session.Get("LOGON.USERID")
	s ^CTLOC(LocID,"RBSSubmit")=Type_"^"_DateInfo_"^"_User
	q ""
}

}
