Class DHCDoc.DHCDocConfig.Indicate Extends Common
{

Query QueryIndicate() As %SQLQuery
{
	SELECT * FROM SQLUser.CF_DOC.Indicate
}

/// w ##class(DHCDoc.DHCDocConfig.Indicate).GetDetailByCode("LocSchedule").%ToJSON()
ClassMethod GetDetailByCode(Code)
{
	s ID=""
	&SQL(SELECT ID INTO :ID FROM SQLUser.CF_DOC.Indicate WHERE Code=:Code AND Active=1)
	s:SQLCODE ID=""
	Q ##class(DHCDoc.DHCDocConfig.Common).GetRowData("CF.DOC.Indicate",ID,"OBJ")
}

ClassMethod GetDrugPercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(1000)/100+38
}

ClassMethod GetKSSUsePercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(1000)/100+3
}

ClassMethod GetKSSDrugPercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(1000)/100+3
}

ClassMethod GetKSSLabPercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(1000)/100+80
}

ClassMethod GetEmrGoodCount(LocID, UserID, SttDate, EndDate)
{
	s SttDate=..%ZDH(SttDate)
	s:SttDate="" SttDate=+$H
	s EndDate=..%ZDH(EndDate)
	s:EndDate="" EndDate=+$H
	s Days=EndDate-SttDate+1
	Q $RANDOM(Days*3)
}

ClassMethod GetEmrGoodPercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(1000)/100+70
}

ClassMethod GetBedUsePercent(LocID, UserID, SttDate, EndDate)
{
	Q $RANDOM(2000)/100+80
}

ClassMethod GetEmergLabCount(LocID, UserID)
{
	Q {"code":200,"data":($RANDOM(10)),"msg":"success","success":true}.%ToJSON()
}

ClassMethod GetWaitPatCount(LocID = "", UserID = "")
{
	set rs=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	set sc=rs.Execute(LocID , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "RegQue")
	s count=0
	while rs.Next(.sc) {
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		s PatWalkStatus=rs.GetDataByName("WalkStatus")
		continue:PatWalkStatus="到达"
		s count=count+1
	}
	Q count
}

ClassMethod GetArrivePatCount(LocID = "", UserID = "")
{
	set rs=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	set sc=rs.Execute(LocID , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "ArrivedQue")
	s count=0
	while rs.Next(.sc) {
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		s count=count+1
	}
	Q count
}

ClassMethod GetReportPatCount(LocID = "", UserID = "")
{
	set rs=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	set sc=rs.Execute(LocID , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "Report")
	s count=0
	while rs.Next(.sc) {
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		s count=count+1
	}
	Q count
}

Query QueryLocAdm(LocID = "", UserID = "") As %Query(ROWSPEC = "EpisodeID,PatientID,mradm")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryLocAdm",191,18881)
ClassMethod QueryLocAdmExecute(ByRef qHandle As %Binary, LocID = "", UserID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s Date="" for {
		s Date = $O(^PAADMi("AdmTypeCurrLoc","I",LocID,Date)) q:(Date="")
		s Time="" for {
			s Time=$O(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time)) q:(Time="")
			s EpisodeID="" for {
				s EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time,EpisodeID)) q:(EpisodeID="")
				s PatientID=$P(^PAADM(EpisodeID),"^",1)
				s mradm=$P(^PAADM(EpisodeID),"^",61)
				d rows.%Push($LB(EpisodeID,PatientID,mradm))
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryLocAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocAdmExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod GetCompletePatCount(LocID = "", UserID = "")
{
	set rs=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	set sc=rs.Execute(LocID , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "Complete")
	s count=0
	while rs.Next(.sc) {
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		s count=count+1
	}
	Q count
}

ClassMethod GetInDocPatCount(LocID = "", UserID = "")
{
	if (LocID="")&&$D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	s Count=0
	s AdmDate=0 f  s AdmDate=$O(^PAADMi("TypeLocDocDateTime","I",LocID,DoctorID,AdmDate)) Q:AdmDate=""  d
	.s AdmTime="" f  s AdmTime=$O(^PAADMi("TypeLocDocDateTime","I",LocID,DoctorID,AdmDate,AdmTime)) Q:AdmTime=""  d
	..s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("TypeLocDocDateTime","I",LocID,DoctorID,AdmDate,AdmTime,EpisodeID)) Q:EpisodeID=""  d
	...s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus'="A"
	...s Count=Count+1
	Q Count
}

ClassMethod GetInLocPatCount(LocID = "", UserID = "")
{
	if (LocID="")&&$D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	s Count=0
	s AdmDate=0 f  s AdmDate=$O(^PAADMi("AdmTypeCurrLoc","I",LocID,AdmDate)) Q:AdmDate=""  d
	.s AdmTime="" f  s AdmTime=$O(^PAADMi("AdmTypeCurrLoc","I",LocID,AdmDate,AdmTime)) Q:AdmTime=""  d
	..s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("AdmTypeCurrLoc","I",LocID,AdmDate,AdmTime,EpisodeID)) Q:EpisodeID=""  d
	...s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus'="A"
	...s Count=Count+1
	Q Count
}

ClassMethod GetOutPatCount(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	if (LocID="")&&$D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s SttDate=+$H
	s EndDate=+$H
	s Count=0
	for DischgDate=SttDate:1:EndDate d
	.s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DisDateDep",LocID,DischgDate,EpisodeID)) Q:EpisodeID=""  d
	..s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	..q:VisitStatus'="D"
	..s Count=Count+1
	Q Count
}

ClassMethod GetAppPercent(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(1000)/100+70
}

ClassMethod GetReAdmPercent(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(4000)/100+10
}

ClassMethod GetGoodPrescPercent(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(1000)/100+90
}

ClassMethod GetOpratePatCount(LocID = "", UserID = "")
{
	if (LocID="")&&$D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	s result = ##Class(%ResultSet).%New("web.DHCDocInPatientListNew:GetOperationPatList")
	s OperationPatCount=0
	s sc = result.Execute(LocID,UserID,+$h,+$h)
	While (result.Next()){
		 s OperationPatCount = OperationPatCount + 1
	}
	Q OperationPatCount
}

Query QueryLocInOut(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,人次")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryLocInOut",191,18881)
ClassMethod QueryLocInOutExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s AdmDate=SttDate-1 f  s AdmDate=$O(^PAADMi("DepDateTime",LocID,AdmDate)) Q:(AdmDate="")||(AdmDate>EndDate)  d
	.s DateCount=0
	.s AdmTime="" f  s AdmTime=$O(^PAADMi("DepDateTime",LocID,AdmDate,AdmTime)) Q:AdmTime=""  d
	..s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DepDateTime",LocID,AdmDate,AdmTime,EpisodeID)) Q:EpisodeID=""  d
	...s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus="C"
	...s DateCount=DateCount+1
	.s OutList(AdmDate,"入院")=DateCount
	
	s DischgDate=SttDate-1 f  s DischgDate=$O(^PAADMi("DisDateDep",LocID,DischgDate)) Q:(DischgDate="")||(DischgDate>EndDate)  d
	.s DateCount=0
	.s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DisDateDep",LocID,DischgDate,EpisodeID)) Q:EpisodeID=""  d
	..s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	..q:VisitStatus'="D"
	..s DateCount=DateCount+1
	.s OutList(DischgDate,"出院")=DateCount
	
	s Date=0 f  s Date=$O(OutList(Date)) Q:Date=""  d
	.f Type="入院","出院" d
	..s Count=+$G(OutList(Date,Type))
	..d rows.%Push($LB(..%ZD(Date),Type,Count))
	Quit $$$OK
}

ClassMethod QueryLocInOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInOutExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryOutFee(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,费用")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryOutFee",191,18881)
ClassMethod QueryOutFeeExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s DischgDate=SttDate-1 f  s DischgDate=$O(^PAADMi("DisDateDep",LocID,DischgDate)) Q:(DischgDate="")||(DischgDate>EndDate)  d
	.s TotalAmount=0
	.s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DisDateDep",LocID,DischgDate,EpisodeID)) Q:EpisodeID=""  d
	..s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	..q:VisitStatus'="D"
	..s PBRowid=0 f  s PBRowid=$O(^DHCPB(0,"ADM",EpisodeID,PBRowid)) Q:PBRowid=""  d
	...s Amount=$P(^DHCPB(PBRowid),"^",8)
	...s TotalAmount=TotalAmount+Amount
	.d rows.%Push($LB(..%ZD(DischgDate),"出院费用",TotalAmount))
	Quit $$$OK
}

ClassMethod QueryOutFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutFeeExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryDrugPercent(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,值")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryDrugPercent",191,18881)
ClassMethod QueryDrugPercentExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	f Date=SttDate:1:EndDate d
	.s Value=..GetDrugPercent(LocID,UserID,Date,Date)
	.d rows.%Push($LB(..%ZD(Date),"药占比",Value))
	.s Value=..GetKSSDrugPercent(LocID,UserID,Date,Date)
	.d rows.%Push($LB(..%ZD(Date),"抗生素药占比",Value))
	Quit $$$OK
}

ClassMethod QueryDrugPercentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDrugPercentExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryBedUsePercent(LocID = "", UserID = "") As %Query(ROWSPEC = "日期,类型,值")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryBedUsePercent",191,18881)
ClassMethod QueryBedUsePercentExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	f Date=SttDate:1:EndDate d
	.s Value=..GetBedUsePercent(LocID,UserID,Date,Date)
	.d rows.%Push($LB(..%ZD(Date),"床位使用率",Value))
	Quit $$$OK
}

ClassMethod QueryBedUsePercentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBedUsePercentExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryOPAdm(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,人次")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryOPAdm",60,18881)
ClassMethod QueryOPAdmExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s AdmDate=SttDate-1 f  s AdmDate=$O(^PAADMi("DepDateTime",LocID,AdmDate)) Q:(AdmDate="")||(AdmDate>EndDate)  d
	.s Count=0,FirstAdmCnt=0,ReAdmCnt=0
	.s AdmTime="" f  s AdmTime=$O(^PAADMi("DepDateTime",LocID,AdmDate,AdmTime)) Q:AdmTime=""  d
	..s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DepDateTime",LocID,AdmDate,AdmTime,EpisodeID)) Q:EpisodeID=""  d
	...s AdmDocID=$P(^PAADM(EpisodeID),"^",9)
	...q:AdmDocID'=DocID
	...s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus="C"
	...s Count=Count+1
	...s FirstOrReadmis=$p(^PAADM(EpisodeID),"^",72)
    ...s AdmReadm=$p(^PAADM(EpisodeID),"^",56)
    ...i (FirstOrReadmis="R")||(AdmReadm="R") s ReAdmCnt=ReAdmCnt+1
    ...e  s FirstAdmCnt=FirstAdmCnt+1
	.d rows.%Push($LB(..%ZD(AdmDate),"门诊人次",Count))
	.d rows.%Push($LB(..%ZD(AdmDate),"初诊人次",FirstAdmCnt))
	.d rows.%Push($LB(..%ZD(AdmDate),"复诊人次",ReAdmCnt))
	Quit $$$OK
}

ClassMethod QueryOPAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOPAdmExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryOPFee(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,金额")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryOPFee",60,18881)
ClassMethod QueryOPFeeExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s Date=SttDate-1 f  s Date=$O(^DHCINVPRT(0,"Date",Date)) Q:(Date="")||(Date>EndDate)  d
	.s FAmount=0,RAmount=0
	.s PRTRowid=0 f  s PRTRowid=$O(^DHCINVPRT(0,"Date",Date,PRTRowid)) Q:PRTRowid=""  d
	..s FairType=$P(^DHCINVPRT(PRTRowid),"^",34)
	..s Acount=$P(^DHCINVPRT(PRTRowid),"^",1)
	..i FairType="R" s RAmount=RAmount+Acount
	..e  i FairType="F" s FAmount=FAmount+Acount
	.d rows.%Push($LB(..%ZD(Date),"挂号费用",RAmount))
	.d rows.%Push($LB(..%ZD(Date),"结算费用",FAmount))
	Quit $$$OK
}

ClassMethod QueryOPFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOPFeeExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryOPApp(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,人次")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryOPApp",60,18881)
ClassMethod QueryOPAppExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s ASDate=SttDate-1 f  s ASDate=$O(^RBAS(0,"Date",ASDate)) Q:(ASDate="")||(ASDate>EndDate)	;,{RB_Resource.RES_RowId},{AS_ChildSub}) 
	for ASDate=SttDate:1:EndDate d
	.s AppCount=0
	.k AppMethodList
	.s ResRowid=0 f  s ResRowid=$O(^RBAS(0,"Date",ASDate,ResRowid)) Q:ResRowid=""  d
	..s ASLocID=$P(^RB("RES",ResRowid),"^",1)
	..q:ASLocID'=LocID
	..s ASSub=0 f  s ASSub=$O(^RBAS(0,"Date",ASDate,ResRowid,ASSub)) Q:ASSub=""  d
	...s ASStatusID=$P($G(^RBAS(ResRowid,ASSub,"DHC")),"^",10)
	...q:ASStatusID=""
	...s ASStatusCode=$P(^DHCRBCASStatus(ASStatusID),"^",1) 
	...q:" N A R"'[(" "_ASStatusCode_" ")
	...s AppSub=0 f  s AppSub=$O(^RBAS(ResRowid,ASSub,"APPT",AppSub)) Q:AppSub=""  d
	....s Status=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",3)
	....q:Status="X"	;"J"
	....s AppMethodID=$P(^RBAS(ResRowid,ASSub,"APPT",AppSub),"^",12)
	....q:AppMethodID=""
	....s AppMethodList(AppMethodID)=$G(AppMethodList(AppMethodID))+1
	....s AppCount=AppCount+1
	.
	.s Date=..%ZD(ASDate)
	.d rows.%Push($LB(Date,"总人次",AppCount))
	.s AppMethodID=0 f  s AppMethodID=$O(AppMethodList(AppMethodID)) q:AppMethodID=""  d
	..s AppMethod=$P(^RBC("APTM",AppMethodID),"^",2)
	..d rows.%Push($LB(Date,AppMethod,AppMethodList(AppMethodID)))
	Quit $$$OK
}

ClassMethod QueryOPAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOPAppExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryPatCareType(LocID = "", UserID = "") As %Query(ROWSPEC = "name,value")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryPatCareType",191,18881)
ClassMethod QueryPatCareTypeExecute(ByRef qHandle As %Binary, LocID = "", UserID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Indicate:QueryLocAdm")
	d rs.Execute(LocID)
	while rs.Next(){
		s EpisodeID=rs.GetDataByName("EpisodeID")
		s Find=0
		for CareTypeDesc="三级护理","二级护理","一级护理","特级护理"{
			if ##class(web.DHCSETIMAGE).IfCareLevelN(EpisodeID,CareTypeDesc){
				s OutList(CareTypeDesc)=$G(OutList(CareTypeDesc))+1
				s Find=1
				Q
			}
		}
		if 'Find{
			s CareTypeDesc="无"
			s OutList(CareTypeDesc)=$G(OutList(CareTypeDesc))+1
		}
	}
	for CareTypeDesc="特级护理","一级护理","二级护理","三级护理","无"{
		d rows.%Push($LB(CareTypeDesc,+$G(OutList(CareTypeDesc))))
	}
	Quit $$$OK
}

ClassMethod QueryPatCareTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatCareTypeExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryIllMsg(LocID = "", UserID = "") As %Query(ROWSPEC = "name,value")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryIllMsg",191,18881)
ClassMethod QueryIllMsgExecute(ByRef qHandle As %Binary, LocID = "", UserID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Indicate:QueryLocAdm")
	d rs.Execute(LocID)
	while rs.Next(){
		s EpisodeID=rs.GetDataByName("EpisodeID")
		if ##class(web.DHCDocMainOrderInterface).IsCriticallyIll(EpisodeID){ ;病危患者
			s OutList("病危")=$G(OutList("病危"))+1
		}elseif ##class(web.DHCDocMainOrderInterface).IsSeriouslyIll(EpisodeID){ ;病重患者
			s OutList("病重")=$G(OutList("病重"))+1
		}else{
			s OutList("普通")=$G(OutList("普通"))+1
		}
	}
	for Type="病危","病重","普通"{
		d rows.%Push($LB(Type,+$G(OutList(Type))))
	}
	Quit $$$OK
}

ClassMethod QueryIllMsgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIllMsgExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryEMRGood(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,数量")
{
}

ClassMethod QueryEMRGoodExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	f Date=SttDate:1:EndDate d
	.s Value=..GetEmrGoodCount(LocID,UserID,Date,Date)
	.d rows.%Push($LB(..%ZD(Date),"病历甲级数",Value))
	.s Value=Value+$RANDOM(5)
	.d rows.%Push($LB(..%ZD(Date),"病历数",Value))
	Quit $$$OK
}

ClassMethod QueryEMRGoodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEMRGoodExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryDischgMsg(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,人次")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Indicate","QueryDischgMsg",191,18881)
ClassMethod QueryDischgMsgExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	
	s DischgDate=SttDate-1 f  s DischgDate=$O(^PAADMi("DisDateDep",LocID,DischgDate)) Q:(DischgDate="")||(DischgDate>EndDate)  d
	.s DateCount=0
	.s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DisDateDep",LocID,DischgDate,EpisodeID)) Q:EpisodeID=""  d
	..s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	..q:VisitStatus'="D"
	..s DateCount=DateCount+1
	..s DischCondID=$P(^PAADM(EpisodeID),"^",49)
	..if DischCondID'="" d
	...s OutList(DischgDate,DischCondID)=$G(OutList(DischgDate,DischCondID))+1
	..// 住院天数			
	..s InDays=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(EpisodeID)
	..i InDays>=30 s OutList(DischgDate,"住院超30天患者")=$G(OutList(DischgDate,"住院超30天患者"))+1
	.s OutList(DischgDate)=DateCount
	
	s DischgDate=0 f  s DischgDate=$O(OutList(DischgDate)) Q:DischgDate=""  d
	.s Date=..%ZD(DischgDate)
	.s Count=+$G(OutList(DischgDate))
	.d rows.%Push($LB(Date,"出院人数",Count))
	.s DischCondID=0 f  s DischCondID=$O(^PAC("DISCON",DischCondID)) Q:DischCondID=""  d
	..s DischCond=$P($G(^PAC("DISCON",DischCondID)),"^",2)
	..s Count=+$G(OutList(DischgDate,DischCondID))
	..d rows.%Push($LB(Date,DischCond,Count))
	.s Count=+$G(OutList(DischgDate,"住院超30天患者"))
	.d rows.%Push($LB(Date,"住院超30天患者",Count))
	Quit $$$OK
}

ClassMethod QueryDischgMsgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDischgMsgExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryCPW(LocID = "", UserID = "", SttDate = "", EndDate = "") As %Query(ROWSPEC = "日期,类型,人次")
{
}

ClassMethod QueryCPWExecute(ByRef qHandle As %Binary, LocID = "", UserID = "", SttDate = "", EndDate = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:(LocID="")&&$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s HospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
	
	s rs=##class(%ResultSet).%New("DHCMA.CPW.CPS.PathwaySrv:QryCPWByDate")
	d rs.Execute(1,SttDate,EndDate,"","","",HospID)
	while rs.Next(){
		s CPWStatus=rs.GetDataByName("CPWStatus")
		continue:CPWStatus="作废"
		s InDate=rs.GetDataByName("InDate")
		s LogicDate=..%ZDH(InDate)
		s OutList(LogicDate,"入径")=$G(OutList(LogicDate,"入径"))+1
	}
	
	s rs=##class(%ResultSet).%New("DHCMA.CPW.CPS.PathwaySrv:QryCPWByDate")
	d rs.Execute(2,SttDate,EndDate,"","","",HospID)
	while rs.Next(){
		s CPWStatus=rs.GetDataByName("CPWStatus")
		continue:CPWStatus="作废"
		s InDate=rs.GetDataByName("InDate")
		s LogicDate=..%ZDH(InDate)
		s OutList(LogicDate,"出径")=$G(OutList(LogicDate,"出径"))+1
	}
	
	s Date=0 f  s Date=$O(OutList(Date)) Q:Date=""  d
	.f Type="入径","出径" d
	..s Count=$G(OutList(Date,Type))
	..d rows.%Push($LB(..%ZD(Date),Type,Count))
	Quit $$$OK
}

ClassMethod QueryCPWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCPWExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod GetCPWPercent(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(1000)/100+3
}

ClassMethod GetINReAdmCount(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(2)
}

ClassMethod GetAvgAdmDays(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	if (LocID="")&&$D(%session) s LocID=%session.Get("LOGON.CTLOCID")
	if (UserID="")&&$D(%session) s UserID=%session.Get("LOGON.USERID")
	/*s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s:SttDate="" SttDate=+$H
	s:EndDate="" EndDate=+$H*/
	s SttDate=..%ZDH(SttDate)
	s EndDate=..%ZDH(EndDate)
	s Count=0,AdmDays=0
	for DischgDate=SttDate:1:EndDate d
	.s EpisodeID=0 f  s EpisodeID=$O(^PAADMi("DisDateDep",LocID,DischgDate,EpisodeID)) Q:EpisodeID=""  d
	..s VisitStatus=$P(^PAADM(EpisodeID),"^",20)
	..q:VisitStatus'="D"
	..s Days=$P(##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(EpisodeID),"^",3)
	..s AdmDays=AdmDays+Days
	..s Count=Count+1
	Q:Count=0 0
	Q $FN(AdmDays/Count,"N",2)
}

ClassMethod GetOperateCnt(LocID = "", UserID = "", SttDate = "", EndDate = "")
{
	Q $RANDOM(10)
}

/// w ##class(DHCDoc.DHCDocConfig.Indicate).CopyOldDataToNew()
ClassMethod CopyOldDataToNew()
{
	s rows=[]
	s ID=0 for{
		s ID=$O(^User.DocCFIndicateD(ID)) Q:ID=""
		s row=##class(DHCDoc.DHCDocConfig.Common).GetRowData("User.DocCFIndicate",ID,"OBJ")
		s row.ID=""
		d rows.%Push(row)
	}
	Q ##class(DHCDoc.DHCDocConfig.Common).SaveData("CF.DOC.Indicate",rows)
}

}
