Class DHCDoc.OPAdm.Appoint Extends %RegisteredObject
{

/// 停号状态
Parameter StopStatus = 7;

/// w ##class(DHCDoc.OPAdm.Appoint).GetScheduleList(1,"","",+$H+1,238)
ClassMethod GetScheduleList(LocRowid, DocRowid, SttDate, EndDate, GroupID, AppMethodID = "", AdmReason = "", PatientID = "", ShowNoSeqNo = "", ShowStop = "", TimeRangeStr = "")
{
	s ASStatusCodeStr=" N R A AR "
	s:ShowStop=1 ASStatusCodeStr=ASStatusCodeStr_" S PS "
	s SttDate=##class(websys.Conversions).DateHtmlToLogical(SttDate)
	s:(SttDate="")!(SttDate<+$H) SttDate=+$H+1
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:(EndDate="")!(EndDate>($H+AppDaysLimit)) EndDate=+$H+AppDaysLimit
	s GroupRes="!"_##class(web.DHCOPRegConfig).GetGroupRes(GroupID)_"!"
	s GroupRegRoom="!"_##class(web.DHCOPRegConfig).GetGroupRegRoom(GroupID)_"!"
	if (LocRowid'="")&(DocRowid'=""){
		s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		d OneRes
	}elseif LocRowid'=""{
		s ResRowid=0 f  s ResRowid=$O(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) q:ResRowid=""  d
		.d OneRes
	}elseif DocRowid'=""{
		s LocRowid=0 f  s LocRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid)) q:LocRowid=""  d
		.s ResRowid=$O(^RB("RES",0,"CTPCP",DocRowid,LocRowid,0))
		.d OneRes
	}
	s RetObj=[]
	s ASDate="" f  s ASDate=$O(SchduleList(ASDate)) Q:ASDate=""  d
	.s ASDateObj={}
	.s ASDateObj.ASDate=$P($ZD(ASDate,3),"-",2,3)
	.s ASDateObj.Week=##class(web.DHCOPAdmReg).ConvertDateToWeek(ASDate)
	.s TimeRanges=[]
	.s TRRowid="" f  s TRRowid=$O(SchduleList(ASDate,TRRowid)) Q:TRRowid=""  d
	..s TRObj={}
	..s TRObj.TimeRange=$P($G(^DHCTimeRange(TRRowid)),"^",2)
	..s Schedules=[]
	..s ASRowid="" f  s ASRowid=$O(SchduleList(ASDate,TRRowid,ASRowid)) Q:ASRowid=""  d
	...d Schedules.%Push(SchduleList(ASDate,TRRowid,ASRowid))
	..s TRObj.Schedules=Schedules
	..d TimeRanges.%Push(TRObj)
	.s ASDateObj.TimeRanges=TimeRanges
	.d RetObj.%Push(ASDateObj)
	Q RetObj.%ToJSON()
OneRes
	Q:GroupRes'[("!"_ResRowid_"!")
	s ASDate=SttDate-1 f  s ASDate=$O(^RBAS(ResRowid,0,"DateSTime",ASDate)) Q:(ASDate="")!(ASDate>EndDate)  d
	.s ScheduleDate=$ZD(ASDate,3)
	.s SessSttTime="" f  s SessSttTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime)) q:(SessSttTime="")  d
	..s ASSub=0  f  s ASSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime,ASSub)) q:(ASSub="")  d
	...d OneSchedule
	Q
OneSchedule
	s TRRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
	Q:(TimeRangeStr'="")&(("^"_TimeRangeStr_"^")'[("^"_TRRowid_"^"))
	s StatusDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(StatusDR),"^",1)
	Q:ASStatusCodeStr'[(" "_ASStatusCode_" ")
	s RoomDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",5)
	Q:(RoomDR'="")&(GroupRegRoom'[("!"_RoomDR_"!"))
	s ASRowid=ResRowid_"||"_ASSub
	s ScheduleObj=..GetScheduleInfo(ASRowid,AppMethodID,AdmReason,PatientID)
	Q:(ShowNoSeqNo'=1)&(ScheduleObj.可用数量<=0)
	s SchduleList(ASDate,TRRowid,ASRowid)=ScheduleObj
	Q
}

ClassMethod GetScheduleInfo(ASRowid, AppMethodID = "", AdmReason = "", PatientID = "") As %DynamicObject
{
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASDate=$P(^RBAS(ResRowid,ASSub),"^",1)
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	s ASLoad=$P(^RBAS(ResRowid,ASSub),"^",8)
	s SessTypeDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",6)
	s SessType=$P($G(^RBC("SESS",+SessTypeDR)),"^",2)
	s RoomDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",5)
	s Room=$P($G(^CTLOC(+RoomDR)),"^",2)
	s:Room["-" Room=$P(Room,"-",2)
	s CGRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",7)
	s CGDesc=$P($G(^RBC("CLGRP",+CGRowid)),"^",2)
	s StatusDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(StatusDR),"^",1)
	s ASStatus=$P(^DHCRBCASStatus(StatusDR),"^",2)
	s RBASDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",12)
	if ASDate>+$H{
		s AvailAppSeqNoStr=##class(DHCDoc.OPAdm.Appoint).GetAppAvailSeqNo(ASRowid,AppMethodID,"","",.AvailQty)
	}else{
		s AvailAppSeqNoStr="",AvailQty=0
	}
	s obj={}
	s obj.ASRowid=ASRowid
	s obj.ASStatusCode=ASStatusCode
	s obj.医生=ResDesc
	if (ASStatusCode["S")!(ASStatusCode="TR"){
		s StopReasonDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",11)
		s StopReason=$P(^RBC("NA",StopReasonDR),"^",2)
		if $L(StopReason)>5 s StopReason=$E(StopReason,1,5)_"..."
		s obj.医生=obj.医生_"("_StopReason_")"
	}
	s obj.正号限额=ASLoad
	s obj.可用数量=AvailQty
	s obj.可用号串=..FormatQueueNoStr(AvailAppSeqNoStr)
	s obj.诊室=Room
	s obj.亚专业=CGDesc
	s obj.出诊级别=SessType
	s obj.费用=##class(web.DHCOPAdmReg).GetScheduleFee(ASRowid,AdmReason,ASDate,"1||1||1||1",PatientID)
	Q obj
}

ClassMethod FormatQueueNoStr(QueueNoStr As %String) As %String
{
	Q:QueueNoStr="" ""
	s RetStr="",QueueNo="",StartNo=""
	s len=$L(QueueNoStr,",")
	for i=1:1:len{
		s Type="",NextType=""
		s QueueNo=$P(QueueNoStr,",",i)
		s:QueueNo["+" QueueNo=$P(QueueNo,"+",2),Type="+"
		s NextNo=$P(QueueNoStr,",",i+1)
		s:NextNo["+" NextNo=$P(NextNo,"+",2),NextType="+"
		s:StartNo="" StartNo=QueueNo
		if ((NextNo-QueueNo)'=1)!(Type'=NextType){
			if QueueNo=StartNo s str=QueueNo
			e  s str=StartNo_"-"_QueueNo
			s str=Type_str
			if RetStr="" s RetStr=str
			e  s RetStr=RetStr_","_str
			s StartNo=""
		}
	}
	Q RetStr
}

/// w ##class(DHCDoc.OPAdm.Appoint).GetASTimeRangeJSON("1||1267")
ClassMethod GetASTimeRangeJSON(ASRowid, MethodID = "")
{
	s retJson={}
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s ASDate=$P(^RBAS(ResRowid,ASSub),"^",1)
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	s TRRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
	s TRDesc=$P(^DHCTimeRange(TRRowid),"^",2)
	s StatusDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(StatusDR),"^",1)
	s CurrTime=$P($H,",",2)
	s retJson.Doctor=ResDesc
	s retJson.ASDate=$P($ZD(ASDate,3),"-",2,3)
	s retJson.TimeRange=TRDesc
	s retJson.ASStatusCode=ASStatusCode
	s TRArr=[]
	s ResRowid=$P(ASRowid,"||",1),ASSub=$P(ASRowid,"||",2)
	s TRFlag=$p(^RBAS(ResRowid,ASSub,"DHC"),"^",19)
	if (TRFlag="Y")&&(ASDate>+$H){
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
			s SttTime=$ZT($P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1),2)
			s EndTime=$ZT($P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2),2)
			s Load=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
			d OneTR
		}
	}else{
		s SttTime=$ZT($P(^RBAS(ResRowid,ASSub),"^",4),2)
		s EndTime=$ZT($P(^RBAS(ResRowid,ASSub),"^",5),2)
		s Load=$P(^RBAS(ResRowid,ASSub),"^",8)
		d OneTR
	}
	s retJson.TRInfos=TRArr
	Q retJson.%ToJSON()
OneTR
	s obj={"SttTime":(SttTime),"EndTime":(EndTime),"Load":(Load)}
	if ASDate>+$H{
		s AvailAppSeqNoStr=##class(DHCDoc.OPAdm.Appoint).GetAppAvailSeqNo(ASRowid,MethodID,SttTime,EndTime,.AvailQty)
	}elseif (ASDate=+$H)&&(CurrTime<$ZTH(EndTime,2)){
		s AvailAppSeqNoStr=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowid,"ADD",MethodID,"Y")
		s AvailQty=$CASE(AvailAppSeqNoStr,"":0,:$L(AvailAppSeqNoStr,","))
	}else{
		s AvailAppSeqNoStr="",AvailQty=""
	}
	s obj.AvailAppSeqNoStr=AvailAppSeqNoStr
	s obj.AvailQty=AvailQty
	d TRArr.%Push(obj)
	Q
}

/// 返回序号就诊时间段:如果没有分时段或者加号,则返回排班出诊开始时间结束时间
/// w ##class(DHCDoc.OPAdm.Appoint).GetSeqNoTimeRange("1||1267",1)
ClassMethod GetSeqNoTimeRange(ASRowid, SeqNo)
{
	s ResRowid=$P(ASRowid,"||",1),ASSub=$P(ASRowid,"||",2)
	s TRFlag=$p(^RBAS(ResRowid,ASSub,"DHC"),"^",19)
	s SttTime="",EndTime=""
	if (TRFlag="Y")&(+SeqNo=SeqNo){
		s TotalTRLoad=0
		s ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
			s TotalTRLoad=TotalTRLoad+TRLoad
			if TotalTRLoad>=SeqNo{
				s SttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
				s EndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
				Q
			}
		}
	}
	if (SttTime="")!(EndTime=""){
		s SttTime=$P(^RBAS(ResRowid,ASSub),"^",4)
		s EndTime=$P(^RBAS(ResRowid,ASSub),"^",5)
	}
	s SttTime=$ZT(SttTime,2),EndTime=$ZT(EndTime,2)
	Q SttTime_"-"_EndTime
}

Query QueryDept(GroupID) As %Query(ROWSPEC = "LocRowid,LocDesc")
{
}

ClassMethod QueryDeptExecute(ByRef qHandle As %Binary, GroupID) As %Status
{
	s GroupRes=##class(web.DHCOPRegConfig).GetGroupRes(GroupID)
	s Len=$L(GroupRes,"!")
	for i=1:1:Len{
		s ResRowid=$P(GroupRes,"!",i)
		continue:ResRowid=""
		s LocRowid=$P($G(^RB("RES",ResRowid)),"^",1)
		continue:LocRowid=""
		continue:$D(LocList(LocRowid))
		s LocList(LocRowid)=""
		s LocDesc=$P(^CTLOC(LocRowid),"^",2)
		s LocRCode=$P(^CTLOC(LocRowid),"^",43)
		s:LocRCode'="" LocDesc=LocDesc_"-"_LocRCode
		s qHandle($I(ind))=$LB(LocRowid,LocDesc)
	}
	Quit $$$OK
}

ClassMethod QueryDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDeptExecute ]
{
	k qHandle
	Quit $$$OK
}

ClassMethod QueryDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDeptExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query QueryDoctor(LocRowid = "", GroupID = "") As %Query(ROWSPEC = "DocRowid,DocDesc")
{
}

ClassMethod QueryDoctorExecute(ByRef qHandle As %Binary, LocRowid = "", GroupID = "") As %Status
{
	if LocRowid'=""{
		s GroupRes="!"_##class(web.DHCOPRegConfig).GetGroupRes(GroupID)_"!"
		s ind=0
		s ResRowid=0 f  s ResRowid=$O(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) q:ResRowid=""  d
		.q:'$D(^RB("RES",ResRowid))
		.q:(GroupRes'[("!"_ResRowid_"!"))
		.s DateActiveTo=$P(^RB("RES",ResRowid),"^",23)
		.q:(DateActiveTo'="")&(DateActiveTo'>+$H)
		.s DocRowid=$P(^RB("RES",ResRowid),"^",2)
		.q:DocRowid=""
		.q:'$D(^CTPCP(DocRowid))
		.s Active=$P($G(^CTPCP(DocRowid,1)),"^",9)
		.q:Active'="Y"
		.s DateActiveTo=$P($G(^CTPCP(DocRowid,2)),"^",15)
		.q:(DateActiveTo'="")&(DateActiveTo'>+$H)
		.s DocDesc=$P($G(^CTPCP(DocRowid,1)),"^",2)
		.s DocRCode=$P($G(^CTPCP(DocRowid,3)),"^",28)
		.s:DocRCode'="" DocDesc=DocDesc_"-"_DocRCode
		.s qHandle($I(ind))=$LB(DocRowid,DocDesc)
	}
	Quit $$$OK
}

ClassMethod QueryDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
	k qHandle
	Quit $$$OK
}

ClassMethod QueryDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query QueryCardType() As %Query(ROWSPEC = "val,desc,selected:%Boolean")
{
}

ClassMethod QueryCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s ind=0,myTypeID=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s val=myTypeID_"^"_^DHCCARDTYPEDef(myTypeID)
	.s desc=$P(^DHCCARDTYPEDef(myTypeID),"^",2)
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" s selected=1
	.e  s selected=0
	.s qHandle($I(ind))=$LB(val,desc,selected)
	Quit $$$OK
}

ClassMethod QueryCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCardTypeExecute ]
{
	k qHandle
	Quit $$$OK
}

ClassMethod QueryCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCardTypeExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetPatDetail(PatientID, PatientNo = "", CardTypeRowid = "", CardNo = "", CredNo = "")
{
	if PatientID=""{
		if PatientNo'="" s PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
		else  if (CardTypeRowid'="")&(CardNo'="") s PatientID=..GetPatientIDByCardNo(CardTypeRowid, CardNo)
		else  if (CredNo'="") s PatientID=..GetPatientIDByCredNo(CredNo)
	}
	s PatObj={}
	if PatientID'=""{
		s PatObj.PatientID=PatientID
		s PatObj.Name=$p(^PAPER(PatientID,"ALL"),"^",1)
		s PatObj.PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
		s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId()
		s PatObj.Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",HospId)
		s PatObj.Sex=$p(^CT("SEX",$p(^PAPER(PatientID,"ALL"),"^",7)),"^",2)
		s PatObj.TelH=$p($G(^PAPER(PatientID,"PER",1)),"^",11)
		s:PatientNo="" PatientNo=$p($G(^PAPER(PatientID,"PAT",1)),"^",1)
		s PatObj.PatientNo=PatientNo
		s CardNoStr=..GetPatientCard(PatientID)
		s PatObj.DefCardTypeRowid=$P(CardNoStr,"^",1)
		s PatObj.DefCardType=$P(^DHCCARDTYPEDef(+PatObj.DefCardTypeRowid),"^",2)
		s PatObj.DefCardNo=$P(CardNoStr,"^",2)
		s:CardNo="" CredNo=..GetPatIDCardNo(PatientID)
		s PatObj.CredNo=CredNo
		s PatObj.warning=""
		s BlackRet=##class(web.DHCRBAppointment).GetLimitAppFlag(PatientID,CredNo)
		if $P(BlackRet,"^")=1{
			s PatObj.warning="患者存在违约记录,已经记入黑名单。不允许预约!"
		}
		if (PatObj.warning="")&&(CardNo'=""){
			s TempCardFlag=##class(web.DHCBL.CARD.UCardRefInfo).GetTemporaryCardFlag(CardTypeRowid,CardNo)
			if TempCardFlag="Y"{
				s PatObj.warning="临时卡不允许预约"
			}
		}
	}
	Q PatObj.%ToJSON()
}

ClassMethod GetPatientIDByCardNo(CardType, CardNo)
{
	s PatientID=""
	s CFRowid=0
	for{
		s CFRowid=$O(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo,CFRowid))
		Quit:CFRowid=""
		s ActiveFlag=$P(^DHCCARD("CF",CFRowid),"^",10)
		continue:ActiveFlag'="N"
		s PatientID=$P(^DHCCARD("CF",CFRowid),"^",4)
		Quit
	}
	if PatientID=""{
		s CFRowid=0
		for{
			s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowid)) Q:CFRowid=""
			s ActiveFlag=$P(^DHCCARD("CF",CFRowid),"^",10)
			continue:ActiveFlag'="N"
			s PatientID=$P(^DHCCARD("CF",CFRowid),"^",4)
			Quit
		}
	}
	Q PatientID
}

ClassMethod GetPatientCard(PatientID)
{
	s CardType="",CardNo=""
	s CFRowid=0
	for{
		s CFRowid=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowid))
		Quit:CFRowid=""
		s ActiveFlag=$P(^DHCCARD("CF",CFRowid),"^",10)
		continue:ActiveFlag'="N"
		s CardType=$P(^DHCCARD("CF",CFRowid),"^",16)
		s CardNo=$P(^DHCCARD("CF",CFRowid),"^",2)
		s DefCardType=$P(^DHCCARDTYPEDef(CardType),"^",8)
		Q:DefCardType="Y"
	}
	Q CardType_"^"_CardNo
}

ClassMethod GetPatIDCardNo(PatientID)
{
	Q:PatientID="" ""
	s IDCardNo=$P(^PAPER(PatientID,"ALL"),"^",9)
	if IDCardNo=""{
		s CardTypeId=$P(^PAPER(PatientID,"PAT",3),"^",7)
		if CardTypeId'=""{
			s CardTypeCode=$P(^PAC("CARD",CardTypeId),"^",1)
			if CardTypeCode="01"{
				s IDCardNo=$P(^PAPER(PatientID,"PAT",3),"^",6)
			}
		}
	}
	Q IDCardNo
}

ClassMethod GetPatientIDByCredNo(CredNo)
{
	Q:CredNo="" ""
	s PatientID=$O(^PAPERi("PAPMI_ICPPBC",CredNo_"Z",0))
	if PatientID="" s PatientID=$O(^PAPERi("DVA",CredNo,0))
	Q PatientID
}

/// w ##class(DHCDoc.OPAdm.Appoint).GetCalendarSchedule(1316,"2019-07-29","2019-09-01",1)
ClassMethod GetCalendarSchedule(ResRowid, SttDate, EndDate, AppMethodID)
{
	s RetObj=[]
	s SttDate=##class(websys.Conversions).DateHtmlToLogical(SttDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s LocID=$p($g(^RB("RES",ResRowid)),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
	s AppDaysLimit=+##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit",HospID)
	if (AppDaysLimit>0){
		s MaxDate=+$H+AppDaysLimit
		s:EndDate>MaxDate EndDate=MaxDate
	}
	for ASDate=SttDate:1:EndDate d
	.s TimeRanges=[]
	.s SessSttTime="" f  s SessSttTime=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime)) q:(SessSttTime="")  d
	..k TimeRangeList
	..s ASSub=0  f  s ASSub=$O(^RBAS(ResRowid,0,"DateSTime",ASDate,SessSttTime,ASSub)) q:(ASSub="")  d
	...s StatusDR=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",10)
	...s ASStatusCode=$P(^DHCRBCASStatus(StatusDR),"^",1)
	...q:ASStatusCode="TR"
	...s TRRowid=$P(^RBAS(ResRowid,ASSub,"DHC"),"^",17)
	...s TimeRange=$P(^DHCTimeRange(TRRowid),"^",2)
	...s ASRowid=ResRowid_"||"_ASSub
	...s AvailAppSeqNoStr="",AvailQty=0
	...if ASDate>+$H d
	....s AvailAppSeqNoStr=##class(DHCDoc.OPAdm.Appoint).GetAppAvailSeqNo(ASRowid,AppMethodID,"","",.AvailQty)
	...e  i '..IsOverTimeSchedule(ASRowid) d
	....s AvailAppSeqNoStr=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowid,"ADD",AppMethodID,"Y")
	....s AvailQty=$CASE(AvailAppSeqNoStr,"":0,:$L(AvailAppSeqNoStr,","))
	...s TimeRangeList(TRRowid)={"ASRowid":(ASRowid),"TimeRange":(TimeRange),"ASStatusCode":(ASStatusCode),"AvailQty":(AvailQty)}
	..s TRRowid=0 f  s TRRowid=$O(TimeRangeList(TRRowid)) Q:TRRowid=""  d
	...d TimeRanges.%Push(TimeRangeList(TRRowid))
	.d RetObj.%Push(TimeRanges)
	Q RetObj.%ToJSON()
}

Query QueryDocMark(LogonResId) As %Query(ROWSPEC = "ResRowid,ResDesc")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.Appoint","QueryDocMark",1316)
ClassMethod QueryDocMarkExecute(ByRef qHandle As %Binary, LogonResId) As %Status
{
	s LogonLocID=$P(^RB("RES",LogonResId),"^",1)
	s LogonDocID=$P(^RB("RES",LogonResId),"^",2)
	s ResDesc=$P(^RB("RES",LogonResId),"^",17)
	s qHandle($I(ind))=$LB(LogonResId,ResDesc)
	s MarkDr=0 f  s MarkDr=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",LogonDocID,MarkDr)) q:MarkDr=""  d
	.q:MarkDr=LogonDocID
	.s ID=0 f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",LogonDocID,MarkDr,ID)) q:ID=""  d
	..s DepDr=$LG(^User.DHCMarkDocD(ID),4)
	..q:DepDr'=LogonLocID
	..s ResRowid=$O(^RB("RES",0,"CTPCP",MarkDr,DepDr,0))
	..q:ResRowid=""
	..s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	..s qHandle($I(ind))=$LB(ResRowid,ResDesc)
	Quit $$$OK
}

ClassMethod QueryDocMarkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocMarkExecute ]
{
	k qHandle
	Quit $$$OK
}

ClassMethod QueryDocMarkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocMarkExecute ]
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

Query QueryAppInfo(ASRowid, PatientID = "") As %Query(ROWSPEC = "AppRowid:%String,PatNo:%String,PatName:%String,PatAge:%String,Phone:%String,AppMethod:%String,AppUserID:%String,AppUser:%String,AppDate:%String,AppTime:%String,AppStatus:%String,QueueNo:%String,ASDate:%String,AdmTimeRange:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.Appoint","QueryAppInfo","","")
ClassMethod QueryAppInfoExecute(ByRef qHandle As %Binary, ASRowid, PatientID = "") As %Status
{
	s ind=0
	if PatientID'=""{
		f Status="I","A" d
		.s ResRowid=0
		.f  s ResRowid=$O(^PAPERDR(PatientID,"RB_Appt",Status,ResRowid)) q:ResRowid=""  d
		..s ASSub=0
		..f  s ASSub=$O(^PAPERDR(PatientID,"RB_Appt",Status,ResRowid,ASSub)) q:ASSub=""  d
		...s ASDate=$P(^RBAS(ResRowid,ASSub),"^",1)
		...q:ASDate<+$H
		...s AppSub=0
		...f  s AppSub=$O(^PAPERDR(PatientID,"RB_Appt",Status,ResRowid,ASSub,AppSub)) q:AppSub=""  d
		....d GetInfo
	}elseif ASRowid'=""{
		s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
		s AppSub=0
		f  s AppSub=$O(^RBAS(ResRowid,ASSub,"APPT",AppSub)) q:AppSub=""  d
		.s Status=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",3)
		.q:(Status'="I")&(Status'="A")
		.d GetInfo
	}
    Quit $$$OK
GetInfo	
	s AdmID=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",4)
	if AdmID'=""{
		s VisitStatus=$P(^PAADM(AdmID),"^",20)
		Q:VisitStatus'="A"
	}
	s StatusCode=Status
	s ASDate=$P(^RBAS(ResRowid,ASSub),"^",1)
	s QueueNo=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",5)
	if (StatusCode="I")&&(ASDate=+$H)&&(QueueNo'["+") {
		s AppReturnTime=0
		s TRRowId=$P($G(^RBAS(ResRowid,ASSub,"DHC")),"^",17)
		if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
		Set AppTimeRangeReturnTime=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(ResRowid_"||"_ASSub,QueueNo)
		if (AppTimeRangeReturnTime'="") s AppReturnTime=AppTimeRangeReturnTime
		if ($P($H,",",2)>AppReturnTime) s StatusCode="J"
	}
	s AppStatus=$CASE(StatusCode,"I":"未取号","A":"已取号","J":"违约",:"")
	s AppUserID=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",11)
	s AppUser=$P(^SSU("SSUSR",AppUserID),"^",2)
	s AppDate=##class(websys.Conversions).DateLogicalToHtml($P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",8))
	s AppTime=##class(websys.Conversions).TimeLogicalToHtml($P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",9))
	s mPatientID=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",2)
	s AppMethod=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",12)
	s AppMethod=$P($G(^RBC("APTM",+AppMethod)),"^",2)
	s:AppMethod="" AppMethod="窗口"
	s ASDate=##class(websys.Conversions).DateLogicalToHtml($P(^RBAS(ResRowid,ASSub),"^",1))
	s AdmTimeRange=..GetSeqNoTimeRange(ResRowid_"||"_ASSub,QueueNo)
	s (PatNo,PatName,PatAge,Phone)=""
	i mPatientID'="" d
	.s PatNo=$P($G(^PAPER(mPatientID,"PAT",1)),"^",1)
	.s PatName=$P($G(^PAPER(mPatientID,"ALL")),"^",1)
	.s LocID=$P(^RB("RES",ResRowid),"^",1)
	.s HospId=$P(^CTLOC(LocID),"^",22)
	.s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",mPatientID,"",HospId)
	.s Phone=$P($G(^PAPER(mPatientID,"PER",1)),"^",11)
	.s:+Phone=0 Phone=$P($G(^PAPER(mPatientID,"PER",4)),"^",21)
	.s:+Phone=0 Phone=""
	e  d
	.s PatName=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub,"DHC"),"^",1)
	.s DOB=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub,"DHC"),"^",2)
	.s:DOB'="" PatAge=##class(web.UDHCJFCOMMON).DispPatAge($ZD(DOB,3),$ZD(+$H,3),"","")
	.s Phone=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub,"DHC"),"^",4)
	s AppRowid=ResRowid_"||"_ASSub_"||"_AppSub
    s qHandle($I(ind))=$lb(AppRowid,PatNo,PatName,PatAge,Phone,AppMethod,AppUserID,AppUser,AppDate,AppTime,AppStatus,QueueNo,ASDate,AdmTimeRange)
    Q
}

ClassMethod QueryAppInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppInfoExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod QueryAppInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppInfoFetch ]
{
	k qHandle
	Quit $$$OK
}

/// w ##class(DHCDoc.OPAdm.Appoint).GetAppAvailSeqNo("5249||653",68,"08:00","08:30",.AvailQty,.AppMaxQty)
ClassMethod GetAppAvailSeqNo(ASRowid, AppMethodID = "", SttTime = "", EndTime = "", ByRef AvailQty = "", ByRef TotalAppMaxQty = "")
{
	s AvailQty=0
	s ResRowid=$P(ASRowid,"||",1),ASSub=$P(ASRowid,"||",2)
	s TRFlag=$p(^RBAS(ResRowid,ASSub,"DHC"),"^",19)	
	s:AppMethodID="" AppMethodID=$O(^RBC("APTM",0,"Code","WIN",0))
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) Q:ASQSub=""
		s MethodID=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",1)
		continue:MethodID=""
		s ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
		s MaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",7)
		s:MaxQty<ReserveQty MaxQty=ReserveQty
		s AppMethodList(MethodID)=ReserveQty_"^"_MaxQty
	}
	s AppQty=$p(^RBAS(ResRowid,ASSub),"^",2)
	s TotalAppMaxQty=..RebuildMethodList(.AppMethodList,AppMethodID,AppQty)
	Q:TotalAppMaxQty<=0 "" 
	s AppMaxQty=TotalAppMaxQty
	s AppStartNo=$p(^RBAS(ResRowid,ASSub),"^",10)
	s:AppStartNo="" AppStartNo=1
	s AppEndNo=AppStartNo+AppQty-1
	s SttTime=##class(websys.Conversions).TimeHtmlToLogical(SttTime)
	s EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	s:SttTime="" SttTime=$P(^RBAS(ResRowid,ASSub),"^",4)
	s:EndTime="" EndTime=$P(^RBAS(ResRowid,ASSub),"^",5)
	
	s MethodUsedQty=0
	s NormalQueueNoStr=$P($P(^RBAS(ResRowid,ASSub,"DHC"),"^",4),$C(1))
	s len=$l(NormalQueueNoStr,",")
	f i=1:1:len{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s QueueNo=$P(SingleQueueNoStr,":",1)
		continue:(QueueNo<AppStartNo)!(QueueNo>AppEndNo)
		s QueueStatus=$P(SingleQueueNoStr,":",2)
		s MethodID=$P(SingleQueueNoStr,":",3)
		if ("1234"[QueueStatus){
			if (MethodID=AppMethodID){
				Q:$I(MethodUsedQty)>=AppMaxQty
			}elseif (MethodID="")||('$D(AppMethodList(MethodID))&&'$D(AppMethodList(AppMethodID))){
				s AppMaxQty=AppMaxQty-1
			}
		}
		s QueueNoList(QueueNo)=$P(SingleQueueNoStr,":",2,3)
	}
	Q:MethodUsedQty>=AppMaxQty ""
	if TRFlag="Y"{
		s EndNo=0,ASTRSub=0 for{
			s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
			s TRLoad=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
			s SttNo=EndNo+1,EndNo=EndNo+TRLoad
			s TRSttNo=$CASE(SttNo<AppStartNo,1:AppStartNo,:SttNo)
			s TREndNo=$CASE(EndNo>AppEndNo,1:AppEndNo,:EndNo)
			s TRLoad=TREndNo-TRSttNo+1
			continue:TRLoad<=0
			k TRMethodList
			s TRAMSub=0 for{
				s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub)) Q:TRAMSub=""
				s TRAMAppMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
				continue:TRAMAppMethodID=""
				s TRAMMaxQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
				s TRAMReserveQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
				s TRMethodList(TRAMAppMethodID)=TRAMReserveQty_"^"_TRAMMaxQty
			}
			s TRAMMaxQty=..RebuildMethodList(.TRMethodList,AppMethodID,TRLoad)
			continue:TRAMMaxQty<=0
			s TRSttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
			s TREndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
			s TRContainFlag=(TRSttTime>=SttTime)&&(TREndTime<=EndTime)
			s MethodExistFlag=$D(TRMethodList(AppMethodID))
			s TRAMReserveQty=+$P($G(TRMethodList(AppMethodID)),"^",1)
			s TRAvailSeqNoStr=..GetOneTRAvailStr(TRSttNo, TREndNo,.QueueNoList, .TRMethodList, AppMethodID,.TRAvailQty,.TRAMMaxQty,.TRUsedQty)
			s TRList(MethodExistFlag,$I(TRList(MethodExistFlag)))=TRAMReserveQty_"^"_TRAMMaxQty_"^"_TRAvailQty_"^"_TRUsedQty_"^"_TRContainFlag_"^"_TRAvailSeqNoStr
		}
		for MethodExistFlag=0,1{
			s node=0 for{
				s node=$O(TRList(MethodExistFlag,node)) Q:node=""
				s TRAMReserveQty=$P(TRList(MethodExistFlag,node),"^",1)
				s TRUsedQty=$P(TRList(MethodExistFlag,node),"^",4)
				s AppMaxQty=AppMaxQty-TRUsedQty
				if MethodExistFlag&&(TRAMReserveQty>TRUsedQty){
					s AppMaxQty=AppMaxQty-TRAMReserveQty+TRUsedQty
				}elseif 'MethodExistFlag{
					;s AvailQty=AvailQty-TRUsedQty
				}
				
			}
		}
		if AppMaxQty<=0 k TRList(0)
		s AvailSeqNoStr="",AppMaxQty=0
		k SeqNoStrList
		for MethodExistFlag=0,1{
			s node=0 for{
				s node=$O(TRList(MethodExistFlag,node)) Q:node=""
				s TRContainFlag=$P(TRList(MethodExistFlag,node),"^",5)
				if TRContainFlag{
					s TRAvailSeqNoStr=$P(TRList(MethodExistFlag,node),"^",6)
					continue:TRAvailSeqNoStr=""
					s TRAMMaxQty=$P(TRList(MethodExistFlag,node),"^",2)
					s AppMaxQty=AppMaxQty+TRAMMaxQty
					s TRAvailQty=$P(TRList(MethodExistFlag,node),"^",3)
					s AvailQty=AvailQty+TRAvailQty
					s SeqNoStrList($P(TRAvailSeqNoStr,","))=TRAvailSeqNoStr
				}
			}
		}
		s i=0 for{
			s i=$O(SeqNoStrList(i)) Q:i=""
			s TRAvailSeqNoStr=SeqNoStrList(i)
			if AvailSeqNoStr="" s AvailSeqNoStr=TRAvailSeqNoStr
			e  s AvailSeqNoStr=AvailSeqNoStr_","_TRAvailSeqNoStr
		}
	}else{
		s AvailSeqNoStr=..GetOneTRAvailStr(AppStartNo, AppEndNo,.QueueNoList, .AppMethodList, AppMethodID,.AvailQty, .AppMaxQty)
	}
	s:AvailQty>AppMaxQty AvailQty=AppMaxQty
	s:AvailQty<=0 AvailQty=0,AvailSeqNoStr=""
	Q AvailSeqNoStr
}

ClassMethod RebuildMethodList(ByRef MethodList, AppMethodID, AppQty) [ Private ]
{
	s MethodID=0 for{
		s MethodID=$O(MethodList(MethodID)) Q:MethodID=""
		if AppMethodID'=MethodID{
			s ReserveQty=$P(MethodList(MethodID),"^",1)
			s AppQty=AppQty-ReserveQty
		}
	}
	s MethodList(0)=0_"^"_AppQty
	if $D(MethodList(AppMethodID)){
		s MaxQty=$P(MethodList(AppMethodID),"^",2)
		if AppQty<MaxQty{
			s $P(MethodList(AppMethodID),"^",2)=AppQty
		}
		s AppMaxQty=$P(MethodList(AppMethodID),"^",2)
	}else{
		s AppMaxQty=$P(MethodList(0),"^",2)
	}
	Q AppMaxQty
}

ClassMethod GetOneTRAvailStr(TRSttNo, TREndNo, QueueNoList, TRMethodList, AppMethodID, ByRef AvailQty = "", ByRef AppMaxQty = "", ByRef TRUsedQty = 0) [ Private ]
{
	s AvailQty=AppMaxQty,TRUsedQty=0
	s AvailSeqNoStr=""
	s QueueNo=TRSttNo-1 for{
		s QueueNo=$O(QueueNoList(QueueNo)) Q:(QueueNo>TREndNo)!(QueueNo="")
		s QueueStatus=$P(QueueNoList(QueueNo),":",1)
		if (QueueStatus=0)!('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueStatus)){
			if AvailSeqNoStr="" s AvailSeqNoStr=QueueNo
			e  s AvailSeqNoStr=AvailSeqNoStr_","_QueueNo
		}else{
			s MethodID=$P(QueueNoList(QueueNo),":",2)
			if (MethodID="")||(QueueStatus=..#StopStatus){
				s AvailQty=AvailQty-1,AppMaxQty=AppMaxQty-1
			}elseif MethodID=AppMethodID{
				s AvailQty=AvailQty-1,TRUsedQty=TRUsedQty+1
			}elseif '$D(TRMethodList(AppMethodID))&&('$D(TRMethodList(MethodID))){
				s AvailQty=AvailQty-1
			}
		}
	}
	if +AvailQty<=0 s AvailSeqNoStr=""
	Q AvailSeqNoStr
}

ClassMethod IsOverTimeSchedule(ASRowid) As %Boolean
{
	s ASDate=$P(^RBAS(+ASRowid,$p(ASRowid,"||",2)),"^",1)
	Q:ASDate<+$H 1
	Q:ASDate>+$H 0
	s ASEndTime=$P($G(^RBAS(+ASRowid,$p(ASRowid,"||",2))),"^",5) 
	s ASTRRowId=$P($G(^RBAS(+ASRowid,$p(ASRowid,"||",2),"DHC")),"^",17)
	s TRRegEndTime=$P($G(^DHCTimeRange(ASTRRowId)),"^",10)
	if TRRegEndTime'="" s ASEndTime=TRRegEndTime
	s CurrTime=$P($H,",",2)
	Q:(CurrTime>ASEndTime) 1
	Q 0
}

}
