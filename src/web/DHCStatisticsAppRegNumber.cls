Class web.DHCStatisticsAppRegNumber Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query StatisticsAppRegNumber(StartDate As %String, EndDate As %String, TimeRangeID As %String = "", LocID As %String = "", ExaborID As %String = "", Aviable As %String = "", Calforloc As %String = "", HospitalID As %String = "") As %Query(ROWSPEC = "id:%String:序号,TDate:%String:出诊日期,TTimeRange:%String:时段,LocDesc:%String:科室,DocDesc:%String:号别,RBASStatusdesc:%String:状态,TStatisticsReg:%String:挂号数,TStatisticsApp:%String:剩号数,TStatisticsArrive:%String:已就诊数,TStatisticsUnArrive:%String:未就诊数") [ SqlProc ]
{
}

ClassMethod StatisticsAppRegNumberClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = StatisticsAppRegNumberExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StatisticsAppRegNumberExecute(ByRef QHandle As %Binary, StartDate As %String, EndDate As %String, TimeRangeID As %String = "", LocID As %String = "", ExaborID As %String = "", Aviable As %String = "", Calforloc As %String = "", HospitalID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	///d ##class(%ResultSet).RunQuery("web.DHCStatisticsAppRegNumber","StatisticsAppRegNumber","2022-06-27","2022-06-27","","","","","","2")
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	i StartDate="" s StartDate=..%SysDate()
 	i EndDate="" s EndDate=..%SysDate()
    if (HospitalID=""){
	    set HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode("")
		if (HospitalCode'="") s HospitalID=$o(^CT("HOSP",0,"Code",HospitalCode,""))
	}
	s ReturnNotAllowReg=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowReg",HospitalID)
	for Date=StartDate:1:EndDate{
		s ResRowid=""
		if LocID'=""{
			s ResRowid="" for{
				s ResRowid=$O(^RB("RES",0,"CTLOC",LocID,ResRowid))
				q:ResRowid=""
				s AsChildSub=""
				for{
					s AsChildSub=$o(^RBAS(0,"Date",Date,ResRowid,AsChildSub))
					q:AsChildSub=""
					continue:'$d(^RBAS(ResRowid,AsChildSub))
					d StatisticsNum
				}
			}
		}else{
			s ResRowid=""
			for{
				s ResRowid=$O(^RBAS(0,"Date",Date,ResRowid))
				q:ResRowid=""
				s locDr=$P(^RB("RES",ResRowid),"^",1)
				s LocHospitalID=$p($g(^CTLOC(locDr)),"^",22)
				continue:LocHospitalID'=HospitalID
				s AsChildSub="" for{
					s AsChildSub=$O(^RBAS(0,"Date",Date,ResRowid,AsChildSub))
					q:AsChildSub=""
					continue:'$d(^RBAS(ResRowid,AsChildSub))
					d StatisticsNum
				}
			}
		}
	}
	///输出按照日期时段科室输出
	s SDate=""
	for{
		s SDate=$O(StatisticsReg(SDate))
		q:SDate=""
		s TDate=..%ZD(SDate)
		s STimeRange="" for{
			s STimeRange=$O(StatisticsReg(SDate,STimeRange))
			q:STimeRange=""
			s TTimeRange=$p($g(^DHCTimeRange(STimeRange)),"^",2)
			s ctlocdr="" for{
				s ctlocdr=$O(StatisticsReg(SDate,STimeRange,ctlocdr))
				q:ctlocdr=""
				s LocDesc=$p(^CTLOC(ctlocdr),"^",2)
				s SumlocReg=0,SumlocApp=0,SumlocArrive=0,SumlocUnArr=0
				s ResRowid="" for{
					s ResRowid=$O(StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid))
					q:ResRowid=""
					s DocDr=$P(^RB("RES",ResRowid),"^",2)
					s DocDesc=$p(^CTPCP(DocDr,1),"^",2)
					s AsChild="" for {
						s AsChild=$O(StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid,AsChild))
						q:AsChild=""
						s TStatisticsReg=StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
						s TStatisticsApp=StatisticsApp(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
						s TStatisticsArrive=StatisticsArrive(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
						s TStatisticsUnArrive=StatisticsUnArrive(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
						s SumlocReg=SumlocReg+TStatisticsReg
						s SumlocApp=SumlocApp+TStatisticsApp
						s SumlocArrive=SumlocArrive+TStatisticsArrive
						s SumlocUnArr=SumlocUnArr+TStatisticsUnArrive
						//set Data=$lb(TDate,TTimeRange,LocDesc,DocDesc,TStatisticsReg,TStatisticsApp,TStatisticsArrive,TStatisticsUnArrive,"",ind)
						//Set ^CacheTemp(repid,ind)=Data	
						//Set ind=ind+1
					}
				}
				set Data=$lb(ind,TDate,TTimeRange,LocDesc,"","",SumlocReg,SumlocApp,SumlocArrive,SumlocUnArr)
				Set ^CacheTemp(repid,ind)=Data	
				Set ind=ind+1
				if Calforloc=""{
					s ResRowid="" for{
						s ResRowid=$O(StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid))
						q:ResRowid=""
						s DocDr=$P(^RB("RES",ResRowid),"^",2)
						s DocDesc=$p(^CTPCP(DocDr,1),"^",2)
						s AsChild="" for {
							s AsChild=$O(StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid,AsChild))
							q:AsChild=""
							s TStatisticsReg=StatisticsReg(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
							s TStatisticsApp=StatisticsApp(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
							s TStatisticsArrive=StatisticsArrive(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
							s TStatisticsUnArrive=StatisticsUnArrive(SDate,STimeRange,ctlocdr,ResRowid,AsChild)
							s RBASStatus=$p(^RBAS(ResRowid,AsChild,"DHC"),"^",10)
							s RBASStatusdesc=$P(^DHCRBCASStatus(RBASStatus),"^",2)
							set Data=$lb(ind,TDate,TTimeRange,LocDesc,DocDesc,RBASStatusdesc,TStatisticsReg,TStatisticsApp,TStatisticsArrive,TStatisticsUnArrive)
							Set ^CacheTemp(repid,ind)=Data	
							Set ind=ind+1
						}
					}
				}
			}
			}
		}
		b ; 
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
StatisticsNum
	;先计算有效排班里的挂号数，已就诊和未就诊数
	s RBASStatus=$p(^RBAS(ResRowid,AsChildSub,"DHC"),"^",10)
	q:(Aviable="Y")&&((RBASStatus=2)||(RBASStatus=4)||(RBASStatus=8)||(RBASStatus=18))
	s TImeRangID=$p(^RBAS(ResRowid,AsChildSub,"DHC"),"^",17)
	q:((TimeRangeID'="")&&(TImeRangID'=TimeRangeID))
	s CTLocID=$P(^RB("RES",ResRowid),"^",1)
	s StatisticsReg(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=0
	s StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=0
	s StatisticsArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=0
	s StatisticsUnArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=0
	if (((RBASStatus=2)||(RBASStatus=4)||(RBASStatus=8)||(RBASStatus=18))) q 
	s RegFeeRowid=""
	for{
		s RegFeeRowid=$O(^User.DHCRegistrationFeeI("RBASDr",ResRowid_"||"_AsChildSub,RegFeeRowid))
		q:RegFeeRowid=""
		s object=##class(User.DHCRegistrationFee).%OpenId(RegFeeRowid)
		s AdmDr=object.RegfeeAdmDr.%Id()
		s VisitStatus=$p($g(^PAADM(AdmDr)),"^",20)
		continue:VisitStatus'="A"
		s StatisticsReg(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsReg(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
		s QueRowid=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmDr,""))
		continue:QueRowid=""
		Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowid)
		Set QueStatus=QueObj.QueStateDr.PersName
		Set QueNo=QueObj.QueNo
		//continue:QueNo=""
		Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(AdmDr)
		s AdmType=$P(^PAADM(AdmDr),"^",2)
		if (AdmType="E"){
			if (WalkStatus'=""){
				s StatisticsArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
			}else{
				s StatisticsUnArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsUnArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
			}
		}else{
			if ((QueStatus="复诊")||(QueStatus="到达")) {
				s StatisticsArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
			}
			if ((QueStatus="等候")||(QueStatus="过号")||(QueStatus="报到")||(QueStatus="未分配")) {
				s StatisticsUnArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsUnArrive(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
			}
		}
	}
	;再计算预约里预约还没取号数
	s APPTChildSub="0"
	for{
		s APPTChildSub=$O(^RBAS(ResRowid,AsChildSub,"APPT",APPTChildSub))
		q:APPTChildSub=""
		s APPTRowId=ResRowid_"||"_AsChildSub_"||"_APPTChildSub
		Set APPTRowIdobjec =##class(User.RBAppointment).%OpenId(APPTRowId)
		s APPTStatus=APPTRowIdobjec.APPTStatus
		if APPTStatus="I"{
			s StatisticsReg(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsReg(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
		}
	}
	;再计算可以挂的正号和加号数
	s ASQueueNo=$P(^RBAS(ResRowid,AsChildSub,"DHC"),"^",4)
 	;正号串与加号串
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
 	s AppReturnTime=0
 	s TRRowId=$P($G(^RBAS(ResRowid,AsChildSub,"DHC")),"^",17)
 	s StopRegNoFlag=$P($G(^RBAS(ResRowid,AsChildSub,"DHC")),"^",27) //停正号
 	s RBASId=ResRowid_"||"_AsChildSub
 	s NoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(RBASId)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	if NoLimitLoadFlag="Y"{
		s AvailableNum=##class(web.DHCRBAppointment).GetAvailableNumIfNoLimitLoad(RBASId, "NOR", "", HospitalID)	
		s StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=AvailableNum
	}else{
		if (StopRegNoFlag'="Y"){
			for i=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
				Set AppReturnTime2=AppReturnTime
				i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))||(('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus,"Y"))&&(CurrentTime>AppReturnTime2))){
					s StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
				}
			}
		}
		for i=1:1:$l(AddQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	continue:QueueNo=""
		 	;未取号和已退号的可用
		 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
				s StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub)=$G(StatisticsApp(Date,TImeRangID,CTLocID,ResRowid,AsChildSub))+1
		 	}
	 	}
	}
}

ClassMethod StatisticsAppRegNumberFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatisticsAppRegNumberExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
