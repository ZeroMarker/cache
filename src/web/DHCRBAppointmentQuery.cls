Class web.DHCRBAppointmentQuery Extends DHCDoc.Util.RegisteredObject
{

ClassMethod AppointmentNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AppointmentNumQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegQuery","AppointmentNumQuery",62298,62298,"","","")

ClassMethod AppointmentNumQueryExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID()
	s Job=$J
	k ^TempDHCOPReg(Job)
	k ^TempDHCOPRegTotal(Job)
	i StartDate="" s StartDate=20
	i EndDate="" s EndDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'=""   s EndDate=..%ZDH(EndDate)
 	s ind=1000
 	s Date=StartDate-1
 	i (DocID'="")&&(DocDesc'="") d
 	.s CurLocID=""
 	.f  s CurLocID=$O(^RB("RES",0,"CTPCP",DocID,CurLocID)) q:CurLocID=""  d
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
 	s TLocID=""
 	f  s TLocID=$O(^TempDHCOPReg(Job,TLocID)) q:TLocID=""  d
 	.s TLoc=$P(^CTLOC(TLocID),"^",2)
 	.s LocAppNum=0
 	.s LocRegNum=0
 	.s LocCancelNum=0
 	.s LocHYNum=0
 	.k ^TempDHCOPRegLoc(Job)
 	.i $L(TLoc,"-")>1 d
 	..s TLoc=$P(TLoc,"-",2,4)
 	.s LocDesc=TLoc
 	.s TDocID=""
 	.f  s TDocID=$O(^TempDHCOPReg(Job,TLocID,TDocID)) q:TDocID=""  d
 	..s TDoc=$P(^CTPCP(TDocID,1),"^",2)
 	..s Date=""
 	..f  s Date=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date)) q:Date=""  d
 	...s TDate=..%ZD(Date) //$ZD(Date,3)
 	...s TimeRangeID=""
 	...f  s TimeRangeID=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRangeID)) q:TimeRangeID=""  d
 	....s TTimeRange=TDate_$P($G(^DHCTimeRange(TimeRangeID)),"^",2)
 	....s MethodID=""
 	....f  s MethodID=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRangeID,MethodID)) q:MethodID=""  d
 	.....s TMethodDesc=$P($G(^RBC("APTM",MethodID)),"^",2)
 	.....s patName=""
 	.....f  s patName=$O(^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRangeID,MethodID,patName)) q:patName=""  d
 	......s TPatientName=$P(patName,"^",2)
 	......s TTel=$P(patName,"^",3)
 	......s TPatNo=$P(patName,"^",4)
 	......s NumStr=$G(^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRangeID,MethodID,patName))
 	......//TAppNum,TRegNum,TCancelNum,THYNum,TTotalRegNum,TRemainNum
 	......s TAppNum=$P(NumStr,"^",1)
 	......s TRegNum=$P(NumStr,"^",2)
 	......s TCancelNum=$P(NumStr,"^",3)
 	......s THYNum=$P(NumStr,"^",4)
 	......s TTotalRegNum=$P(NumStr,"^",5)
 	......s TRemainNum=$P(NumStr,"^",6)
 	......s TPoliticalLevel=$P(NumStr,"^",7)
   	......s TSecretLevel=$P(NumStr,"^",8)
   	......s TAppTDateAndTime=$P(NumStr,"^",9)
   	......s TAppTLastStatusDateAndTime=$P(NumStr,"^",10)
   	......s TAppTSeqNo=$P(NumStr,"^",11)
   	......s TAPPTLastStatusUserDesc = $p(NumStr, "^", 12)
   	......s TAPPTStatusDesc = $p(NumStr, "^", 13)
   	......s TAppUserDesc = $p(NumStr, "^", 14)
   	......s TAdmDate = $p(NumStr, "^", 15)
   	......s TPrice = $p(NumStr, "^", 16)
 	......d:(OnlyLocTotal'="on")&&(OnlyLocTotal'="1") FindBuild
	......s TPoliticalLevel="",TSecretLevel=""
 	......s $P(^TempDHCOPRegLoc(Job,MethodID),"^",1)=$P($G(^TempDHCOPRegLoc(Job,MethodID)),"^",1)+(+TAppNum)
 	......s $P(^TempDHCOPRegLoc(Job,MethodID),"^",2)=$P($G(^TempDHCOPRegLoc(Job,MethodID)),"^",2)+(+TRegNum)
 	......s $P(^TempDHCOPRegLoc(Job,MethodID),"^",3)=$P($G(^TempDHCOPRegLoc(Job,MethodID)),"^",3)+(+TCancelNum)
 	......s $P(^TempDHCOPRegLoc(Job,MethodID),"^",4)=$P($G(^TempDHCOPRegLoc(Job,MethodID)),"^",4)+(+THYNum)
 	......s (TLoc,TDoc,TTimeRange,TMethodDesc,TPatientName,TPatNo)=""
 	.s MethodID="",TTel=""
 	.f  s MethodID=$O(^TempDHCOPRegLoc(Job,MethodID)) q:MethodID=""  d
 	..s TMethodDesc=$P($G(^RBC("APTM",MethodID)),"^",2)
 	..s TAppNum=$P(^TempDHCOPRegLoc(Job,MethodID),"^",1)
 	..s TRegNum=$P(^TempDHCOPRegLoc(Job,MethodID),"^",2)
 	..s TCancelNum=$P(^TempDHCOPRegLoc(Job,MethodID),"^",3)
 	..s THYNum=$P(^TempDHCOPRegLoc(Job,MethodID),"^",4)
 	..s TTotalRegNum=""
 	..s TRemainNum=""
 	..s TAppTDateAndTime=""
 	..s TAppTLastStatusDateAndTime=""
 	..s TAppTSeqNo=""
 	..s TAPPTLastStatusUserDesc = ""
 	..s TAPPTStatusDesc = ""
 	..s TPatNo=""
 	..s TPatientName=LocDesc_TMethodDesc_"合计"
 	..s TMethodDesc=""
 	..s (TAppUserDesc,TAdmDate,TPrice)=""
 	..d FindBuild
 	..s $P(^TempDHCOPRegTotal(Job,MethodID),"^",1)=$P($G(^TempDHCOPRegTotal(Job,MethodID)),"^",1)+(+TAppNum)
 	..s $P(^TempDHCOPRegTotal(Job,MethodID),"^",2)=$P($G(^TempDHCOPRegTotal(Job,MethodID)),"^",2)+(+TRegNum)
 	..s $P(^TempDHCOPRegTotal(Job,MethodID),"^",3)=$P($G(^TempDHCOPRegTotal(Job,MethodID)),"^",3)+(+TCancelNum)
 	..s $P(^TempDHCOPRegTotal(Job,MethodID),"^",4)=$P($G(^TempDHCOPRegTotal(Job,MethodID)),"^",4)+(+THYNum)
 	s ind=2
 	s MethodID=""
 	f  s MethodID=$O(^TempDHCOPRegTotal(Job,MethodID)) q:MethodID=""  d
 	.s TMethodDesc=$P($G(^RBC("APTM",MethodID)),"^",2)
 	.s TAppNum=$P(^TempDHCOPRegTotal(Job,MethodID),"^",1)
 	.s TRegNum=$P(^TempDHCOPRegTotal(Job,MethodID),"^",2)
 	.s TCancelNum=$P(^TempDHCOPRegTotal(Job,MethodID),"^",3)
 	.s THYNum=$P(^TempDHCOPRegTotal(Job,MethodID),"^",4)
 	.s TTotalRegNum=""
 	.s TRemainNum=""
 	.s TPatNo=""
 	.s TPatientName=TMethodDesc_"总计"
 	.s TMethodDesc=""
 	.s (TAppUserDesc,TAdmDate,TPrice)=""
 	.d FindBuild
 	.s $P(^TempDHCOPRegTotal(Job),"^",1)=$P($G(^TempDHCOPRegTotal(Job)),"^",1)+(+TAppNum)
 	.s $P(^TempDHCOPRegTotal(Job),"^",2)=$P($G(^TempDHCOPRegTotal(Job)),"^",2)+(+TRegNum)
 	.s $P(^TempDHCOPRegTotal(Job),"^",3)=$P($G(^TempDHCOPRegTotal(Job)),"^",3)+(+TCancelNum)
 	.s $P(^TempDHCOPRegTotal(Job),"^",4)=$P($G(^TempDHCOPRegTotal(Job)),"^",4)+(+THYNum)
 	i $D(^TempDHCOPRegTotal(Job)) d
 	.s ind=1
 	.s TAppNum=$P(^TempDHCOPRegTotal(Job),"^",1)
 	.s TRegNum=$P(^TempDHCOPRegTotal(Job),"^",2)
 	.s TCancelNum=$P(^TempDHCOPRegTotal(Job),"^",3)
 	.s THYNum=$P(^TempDHCOPRegTotal(Job),"^",4)
 	.s TTotalRegNum=""
 	.s TRemainNum=""
 	.s TPatNo=""
 	.s TPatientName="总计"
 	.s TMethodDesc=""
 	.s (TAppUserDesc,TAdmDate,TPrice)=""
 	.d FindBuild
 	k ^TempDHCOPRegLoc(Job)
 	k ^TempDHCOPRegTotal(Job)
 	k ^TempDHCOPReg(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneRESID(RESID)
	s TLocID=$P($G(^RB("RES",RESID)),"^",1)
	q:TLocID=""
	Q:($p($g(^CTLOC(TLocID)),"^",22)'=LogonHospId)
	s TDocID=$P($G(^RB("RES",RESID)),"^",2)
	q:TDocID=""
	s Date=StartDate-1
	f  s Date=$O(^RBAS(RESID,0,"DateSTime",Date)) q:(Date="")||(Date>EndDate)  d
	.s essStartTime=""
	.f  s essStartTime=$O(^RBAS(RESID,0,"DateSTime",Date,essStartTime)) q:(essStartTime="")  d
	..s sub=0
	..f  s sub=$O(^RBAS(RESID,0,"DateSTime",Date,essStartTime,sub)) q:(sub="")  d
	...s apptSub=0
	...s date=$P(^RBAS(RESID,sub),"^",1)
	...s time=$P(^RBAS(RESID,sub),"^",5)
	...s Status=$P(^RBAS(RESID,sub,"DHC"),"^",10)
	...s RegLoadNum=$P(^RBAS(RESID,sub),"^",8)
	...s OverbookNum=$P(^RBAS(RESID,sub,"DHC"),"^",3)
	...s RegisterNum=##class(web.DHCOPAdmRegQuery).GetRegNumByAS(RESID_"||"_sub)
	...s SessonType=$P($G(^RBAS(RESID,sub,"DHC")),"^",6)
	...q:(SessionTypeID'="")&&(SessionTypeID'=SessonType)
	...s TimeRange=$P($G(^RBAS(RESID,sub,"DHC")),"^",17)
	...q:TimeRange=""
	...q:(TimeRangeID'="")&&(TimeRangeID'=TimeRange)
	...s Status=$P(^RBAS(RESID,sub,"DHC"),"^",10)
	...s:Status'="" Status=$P(^DHCRBCASStatus(Status),"^",1)
	...i Status="S" s StopNum=(+RegLoadNum)+(+OverbookNum) //停诊
	...i Status="PS" s PStopNum=(+RegLoadNum)+(+OverbookNum)-(+RegisterNum) //中途停诊
	...i Status="R" s RNum=(+RegLoadNum)+(+OverbookNum) //替诊
	...i Status="A" s ANum=(+RegLoadNum)+(+OverbookNum) //加诊
	...i Status="AR" s ARNum=(+RegLoadNum)+(+OverbookNum) //补诊
	...i Status="TR" s TRNum=(+RegLoadNum)+(+OverbookNum) //被替诊
	...i Status="F" s FNum=(+RegLoadNum)+(+OverbookNum)-(+RegisterNum) //锁定
	...s RemainNum=+(RegLoadNum)+(+OverbookNum)-(+RegisterNum)-(+$G(StopNum))-(+$G(PStopNum))-(+$G(TRNum))-(+$G(FNum))
	...s (OneAppNum,OneRegNum,OneCancelNum,OneHYNum)=0
	...s EmployeeFunction="",SecretLevel=""
	...f  s apptSub=$O(^RBAS(RESID,sub,"APPT",apptSub)) q:apptSub=""  d
	....s (APPTSeqNo,patName,appNum,regNum,CancelNum,hyNum,totalRegNum,CurRemainNum,AppTDateAndTime,AppTLastStatusDateAndTime,APPTLastStatusUserDesc,APPTStatusDesc)=""
	....s PAPMIID=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",2)
	....i (PAPMIID'="")&&((("^"_CommonPatientID_"^")'[("^"_PAPMIID_"^"))) d
	.....s patName=RESID_"||"_sub_"||"_apptSub_"^"_$P(^PAPER(PAPMIID,"ALL"),"^",1)_"^"_$P(^PAPER(PAPMIID,"PER",1),"^",11)_"^"_$p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	.....s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIID,.ErrMsg)
	.....i PatEncryptLevel'="" d
	......s EmployeeFunction=$p(PatEncryptLevel,"^",2)
	......s SecretLevel=$p(PatEncryptLevel,"^",4)
	....e  d
	.....s patName=RESID_"||"_sub_"||"_apptSub_"^"_$P($g(^RBAS(RESID,sub,"APPT",apptSub,"DHC")),"^",1)_"^"_$P($g(^RBAS(RESID,sub,"APPT",apptSub,"DHC")),"^",5)
	....s APPTTransDate=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",8) //预约时间
	....s APPTTransDate=..%ZD(APPTTransDate) //$zd(APPTTransDate,3)
	....s APPTTransTime=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",9)
	....s APPTSeqNo=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",5)
	....s APPTTransTime=..%ZT(APPTTransTime)
	....s AppTDateAndTime=APPTTransDate_" "_APPTTransTime
	....s APPTStatus=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",3)
	....s:$g(APPTStatus)'="" APPTStatusDesc = $case(APPTStatus,"I":"预约","A":"取号","X":"取消","J":"爽约", :"未知")
	....i ((APPTStatus="A")||(APPTStatus="X")) d
	.....s APPTLastStatusChangeDate=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",63) //取号日期/取消日期
	.....s APPTLastStatusChangeDate=..%ZD(APPTLastStatusChangeDate) //$zd(APPTLastStatusChangeDate,3)
	.....s APPTLastStatusChangeTime=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",64)
	.....s APPTLastStatusChangeTime=..%ZT(APPTLastStatusChangeTime)
	.....s AppTLastStatusDateAndTime=APPTLastStatusChangeDate_" "_APPTLastStatusChangeTime
	.....s APPTLastStatusUserDR = $p($g(^RBAS(RESID,sub,"APPT",apptSub)),"^",65)	// 状态改变操作人
	.....s:APPTLastStatusUserDR'="" APPTLastStatusUserDesc = $p($g(^SSU("SSUSR",APPTLastStatusUserDR)), "^", 2)
	....s apptMethodDR=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",12)
	....i apptMethodDR="" s apptMethodDR="0"
	....s status=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",3)
	....q:status="T"
	....s Flag=0
	....s curDate=..%SysDate()
	....s:curDate>date Flag=1
	....s:(curDate=date)&&(..%SysTime()>time) Flag=1
	....s:(status="I")&&(Flag=0) appNum=1 s OneAppNum=OneAppNum+appNum
	....s:status="A" regNum=1 s OneRegNum=OneRegNum+regNum
	....s:status="X" CancelNum=1 s OneCancelNum=OneCancelNum+CancelNum
	....s:(status="I")&&(Flag=1) hyNum=1 s OneHYNum=OneHYNum+hyNum
	....s:(status="J") hyNum=1 s OneHYNum=OneHYNum+hyNum
	....s UserDR=$P(^RBAS(RESID,sub,"APPT",apptSub),"^",11)
	....s TAppUserDesc=""
	....if UserDR'="" s TAppUserDesc=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	....s AsDate=$P($G(^RBAS(RESID,sub)),"^",1) 
	....s TAdmDate=..%ZD(AsDate)
	....s PatCatDr=""
	....s:PAPMIID'="" PatCatDr=$p($G(^PAPER(PAPMIID,"PER",1)),"^",10)
	....s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	....s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(RESID_"||"_sub,AdmReason,PAPMIID,"","")
	....s RegFeeDr="",ExamFeeDr="",HoliFeeDr="",AppFeeDr=""
	....s RegFee=$p(DocResValue,"^",12)
	....s CheckFee=$p(DocResValue,"^",14)
	....s HoliFee=$p(DocResValue,"^",16)
	....s AppFee=$p(DocResValue,"^",18)
	....s ReCheckFee=$p(DocResValue,"^",15)
	....s OtherFee=$p(DocResValue,"^",20)
	....s TRDesc=$p(DocResValue,"^",21)
	....s ScheduleDate=$p(DocResValue,"^",28)
	....s Sum=HoliFee+CheckFee+RegFee+AppFee+OtherFee
	....s TPrice=$fn(Sum,"",2)
	....s ^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRange,apptMethodDR,patName)=appNum_"^"_regNum_"^"_CancelNum_"^"_hyNum_"^"_totalRegNum_"^"_CurRemainNum_"^"_EmployeeFunction_"^"_SecretLevel_"^"_AppTDateAndTime_"^"_AppTLastStatusDateAndTime_"^"_APPTSeqNo_"^"_APPTLastStatusUserDesc_"^"_APPTStatusDesc_"^"_TAppUserDesc_"^"_TAdmDate_"^"_TPrice
	...//s ^TempDHCOPReg(Job,TLocID,TDocID,Date,TimeRange,0," ")=OneAppNum_"^"_OneRegNum_"^"_OneCancelNum_"^"_OneHYNum_"^"_RegisterNum_"^"_RemainNum
	q
FindBuild
																						
	set Data=$lb(TLoc,TDoc,TDate,TTimeRange,TMethodDesc,TPatientName,TAppNum,TRegNum,TCancelNum,THYNum,TTotalRegNum,TRemainNum,TPoliticalLevel,TSecretLevel,TAppTDateAndTime,TAppTLastStatusDateAndTime,TAppTSeqNo,$g(TTel),TAPPTLastStatusUserDesc,TAPPTStatusDesc,$G(TPatNo),TAppUserDesc,TAdmDate,TPrice)
																						
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod AppointmentNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AppointmentNumQueryExecute ]
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

Query AppointmentNumQuery(StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Query(ROWSPEC = "TLoc:%String,TDoc:%String,TDate:%String,TTimeRange:%String,TMethodDesc:%String,TPatientName:%String,TAppNum:%String,TRegNum:%String,TCancelNum:%String,THYNum:%String,TTotalRegNum:%String,TRemainNum:%String,TPoliticalLevel:%String,TSecretLevel:%String,TAppTDateAndTime:%String,TAppTLastStatusDateAndTime:%String,TAppTSeqNo:%String,TTel:%String,TAPPTLastStatusUserDesc:%String,TAPPTStatusDesc:%String,TPatNo:%String,TAppUserDesc:%String,TAdmDate:%String,TPrice:%String")
{
}

// w ##class(web.DHCRBAppointmentQuery).GetAppRegNum("625||8","DOCADD")

ClassMethod GetAppRegNum(ASID, AppType)
{
	//n (ASID,AppType)
	s ApptNum=0
	s NoRegApptNum=0
	s RSRowID=+ASID
	s ASSub=$P(ASID,"||",2)
	s APPTSub=0
	//User.RBAppointment
	f  s APPTSub=$O(^RBAS(RSRowID,ASSub,"APPT",APPTSub)) q:APPTSub=""  d
	.s Status=$P(^RBAS(RSRowID,ASSub,"APPT",APPTSub),"^",3) //预约状态 x：取消
	.q:Status="X"
	.s MethodID=$P(^RBAS(RSRowID,ASSub,"APPT",APPTSub),"^",12)
	.s MethodCode=$P($G(^RBC("APTM",MethodID)),"^",1)
	.q:(MethodCode'=AppType)&&(AppType'="")
	.q:(MethodCode="DOCADD")&&(AppType="")
	.s ApptNum=ApptNum+1
	.s Adm=$P(^RBAS(RSRowID,ASSub,"APPT",APPTSub),"^",4) //就诊Rowid,预约取号后更新
	.q:Adm'=""
	.s NoRegApptNum=NoRegApptNum+1
	q ApptNum_"^"_NoRegApptNum
}

// w ##class(web.DHCRBAppointmentQuery).GetTotayAppRegNum("69000","NORN")

ClassMethod GetTotayAppRegNum(Date, ApptTypeCode)
{
	s ApptNum=0
	s ApptTypeID=##class(web.DHCRBAppointment).GetApptTypeByCode(ApptTypeCode)
	q:ApptTypeID="" ApptNum
	s RSID=0
	f  s RSID=$O(^RBAS("ATTransDate",ApptTypeID,Date,RSID)) q:RSID=""  d
	.s ASSub=0
	.f  s ASSub=$O(^RBAS("ATTransDate",ApptTypeID,Date,RSID,ASSub)) q:ASSub=""  d
	..s APPTSub=0
	..f  s APPTSub=$O(^RBAS("ATTransDate",ApptTypeID,Date,RSID,ASSub,APPTSub)) q:APPTSub=""  d
	...s Status=$P(^RBAS(RSID,ASSub,"APPT",APPTSub),"^",3)
	...q:Status="X"
	...s ApptNum=ApptNum+1
	q ApptNum
}

Query AppointmentNumQueryExport(StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Library.Query(ROWSPEC = "TLoc:%String:科室,TDoc:%String:医生,TTimeRange:%String:时间段,TPatNo:%String:登记号,TPatientName:%String:患者姓名,TAppNum:%String:预约,TRegNum:%String:取号,TCancelNum:%String:取消,THYNum:%String:爽约,TAppTDateAndTime:%String:预约日期,TAPPTStatusDesc:%String:状态,TAppTLastStatusDateAndTime:%String:取号/取消预约日期,TAPPTLastStatusUserDesc:%String:取号/取消预约操作员,TAppTSeqNo:%String:预约序号,TPoliticalLevel:%String:患者级别,TSecretLevel:%String:患者密级,TTel:%String:联系电话,TAppUserDesc:%String:预约操作人,TAdmDate:%String:就诊日期,TPrice:%String:价格")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QueryBookByDateLocExport","2020-10-12","2020-10-12","","","","",10209,2,"")
ClassMethod AppointmentNumQueryExportExecute(ByRef qHandle As %Library.Binary, StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", TimeRangeID As %String = "", SessionTypeID As %String = "", OnlyLocTotal As %String = "", DocDesc As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCRBAppointmentQuery:AppointmentNumQuery")
	d rset.Execute(StartDate,EndDate,LocID,DocID,TimeRangeID,SessionTypeID,OnlyLocTotal,DocDesc)
	While (rset.Next()) {
		s TLoc=rset.Data("TLoc")
		s TDoc=rset.Data("TDoc")
		s TTimeRange=rset.Data("TTimeRange")
		s TPatientName=rset.Data("TPatientName")
		s TAppNum=rset.Data("TAppNum")
		s TRegNum=rset.Data("TRegNum")
		s TCancelNum=rset.Data("TCancelNum")
		s THYNum=rset.Data("THYNum")
		s TAppTDateAndTime=rset.Data("TAppTDateAndTime")
		s TAppTLastStatusDateAndTime=rset.Data("TAppTLastStatusDateAndTime")
		s TAppTSeqNo=rset.Data("TAppTSeqNo")
		s TPoliticalLevel=rset.Data("TPoliticalLevel")
		s TSecretLevel=rset.Data("TSecretLevel")
		s TTel=rset.Data("TTel")
		s TAPPTStatusDesc=rset.Data("TAPPTStatusDesc")
		s TAPPTLastStatusUserDesc=rset.Data("TAPPTLastStatusUserDesc")
		s TPatNo=rset.Data("TPatNo")
		s TAppUserDesc=rset.Data("TAppUserDesc")
		s TAdmDate=rset.Data("TAdmDate")
		s TPrice=rset.Data("TPrice")
		s OutputList=$lb(TLoc,TDoc,TTimeRange,TPatNo,TPatientName,TAppNum,TRegNum,TCancelNum,THYNum,TAppTDateAndTime,TAPPTStatusDesc,TAppTLastStatusDateAndTime,TAPPTLastStatusUserDesc,TAppTSeqNo,TPoliticalLevel,TSecretLevel,TTel,TAppUserDesc,TAdmDate,TPrice)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod AppointmentNumQueryExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = AppointmentNumQueryExportExecute ]
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

ClassMethod AppointmentNumQueryExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = AppointmentNumQueryExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
