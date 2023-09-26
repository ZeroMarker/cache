Class EMRservice.DAL.GetPaAdmDetail Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetInPatList","6","105","currentUser","all","","")
/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetInPatList","6","105","currentGroup","all","","")
/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetInPatList","6","105","currentLoc","all","","")
Query GetInPatList(ALocID As %String, AUserID As %String, ARadioValue As %String, AWardID As %String, AMedicareNo As %String = "", APAPMIName As %String = "", ADiagnosis As %String = "") As %Query(ROWSPEC = "mradm:%String,PatientID:%String,EpisodeID:%String,PAPMINO:%String,PAPMIName:%String,PAPMISex:%String,PAPMIDOB:%String,PAPMIAge:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmType:%String,Diagnosis:%String,PAAdmDocCodeDR:%String,HeadUniteDoc:%String,ChiefDoc:%String,PAAdmBedNO:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmReason:%String,ResidentDays:%String,InTimes:%String,MedicareNo:%String")
{
}

ClassMethod GetInPatListExecute(ByRef qHandle As %Binary, ALocID As %String, AUserID As %String, ARadioValue As %String, AWardID As %String, AMedicareNo As %String = "", APAPMIName As %String = "", ADiagnosis As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s DocId=$p($g(^SSU("SSUSR",AUserID)),"^",14)
	s locID = ALocID
	
	if (locID'="") {
		s CTLOCType = $p($g(^CTLOC(ALocID)),"^",13)
		if (CTLOCType="W") {
			s locIDStr = ..CurDeptLinkLocByDept(ALocID)
			s locIDCount = $L(locIDStr,"^")
			for i=3:1:locIDCount-1
			{
				s locID = $p(locIDStr,"^",i)
				d currentLocOut
			}
		}
		else
		{
			d currentLocOut
		}
	}
	Quit $$$OK
	
currentLocOut
	s Date=""
	for {
		s Date = $O(^PAADMi("AdmTypeCurrLoc","I",locID,Date))
		q:(Date="")
		
		s Time=""
		for {
			s Time=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time))
			q:(Time="")
			
			s PAADMRowID=""
			for {
				s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time,PAADMRowID))
				q:(PAADMRowID="")
				s PatientID=$P(^PAADM(PAADMRowID),"^",1)
				//患者姓名
				s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
				//病案号
				s MedicareNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(PAADMRowID)	   
				
				//按“本人病人”查询
				if (ARadioValue = "currentUser")
				{
					s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
					continue:(PatDoc '= DocId)
					if (AWardID '="all")
					{
						s WardDr=$P($g(^PAADM(PAADMRowID)),"^",70)
						s WardCTLocID = $P($g(^PAWARD(WardDr)),"^",5)
						continue:(WardCTLocID '= AWardID)
					}
					if (AMedicareNo '= ""){
						continue:(MedicareNo '= AMedicareNo)
					}
					if (APAPMIName '= ""){
						continue:(PAPMIName '= APAPMIName)
					}
					if (ADiagnosis '= ""){
						s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
						if (Diagnosis '= "")
						{	
							s Diagnosis = $P(Diagnosis,"^",3)
						}
						else
						{
							s Diagnosis = "无"
						}
						continue:(Diagnosis'[ADiagnosis)
					}
					d outputrow
				}
				//按“本组病人”查询，即“本单元病人”查询
				elseif (ARadioValue = "currentGroup")
				{
					//修正本单元判定 modify by lifb 20170828
					//s isOK = ..CheckCTLocMedUnit(PAADMRowID,DocId,locID)
					s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
					s isOK = ..CheckCTLocMedUnit(PatDoc,DocId,locID)
					continue:(isOK '=1)
					if (AWardID '="all")
					{
						s WardDr=$P($g(^PAADM(PAADMRowID)),"^",70)
						s WardCTLocID = $P($g(^PAWARD(WardDr)),"^",5)
						continue:(WardCTLocID '= AWardID)
					}
					if (AMedicareNo '= ""){
						continue:(MedicareNo '= AMedicareNo)
					}
					if (APAPMIName '= ""){
						continue:(PAPMIName '= APAPMIName)
					}
					if (ADiagnosis '= ""){
						s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
						if (Diagnosis '= "")
						{	
							s Diagnosis = $P(Diagnosis,"^",3)
						}
						else
						{
							s Diagnosis = "无"
						}
						continue:(Diagnosis'[ADiagnosis)
					}
					d outputrow
				}
				//按“本科室病人”查询
				else
				{
					if (AWardID '="all")
					{
						if (CTLOCType="W")
						{
							//此时AWardID是科室ID
							continue:(locID '= AWardID)
						}
						else
						{
							//此时AWardID是病区ID
							s WardDr=$P($g(^PAADM(PAADMRowID)),"^",70)
							s WardCTLocID = $P($g(^PAWARD(WardDr)),"^",5)
							continue:(WardCTLocID '= AWardID)
						}
					}
					if (AMedicareNo '= ""){
						continue:(MedicareNo '= AMedicareNo)
					}
					if (APAPMIName '= ""){
						continue:(PAPMIName '= APAPMIName)
					}
					if (ADiagnosis '= ""){
						s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
						if (Diagnosis '= "")
						{	
							s Diagnosis = $P(Diagnosis,"^",3)
						}
						else
						{
							s Diagnosis = "无"
						}
						continue:(Diagnosis'[ADiagnosis)
					}
					d outputrow
				}
			}
		}
	}
	Quit $$$OK
	
outputrow
	s EpisodeID=PAADMRowID
	s mradm=$P(^PAADM(PAADMRowID),"^",61)
	
	s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	//性别
	s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//出生日期和年龄
	s PAPMIDOB=""
	s PAPMIAge=""
	s DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	if (DobDate'="")
	{
		s PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
		//add by lifb 20170828 标准化日期显示格式
		s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
		s PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		if (PAPMIAge = "0")
		{
			s birthday = ..Birthday(PatientID)
			s admDate = ..AdmDateTime(PAADMRowID, "")
			s admDate = $P(admDate, ",", 1)
			s age = ..Age(PAADMRowID,birthday,admDate,4)
			//s age = ""
			s PAPMIAge=age
		}
	}
	
	//入院日期
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(PAADMRowID)
	
	s PAAdmDate=$P(admDateTime,",",1)
	s PAAdmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	
	s PAAdmTime=$P(admDateTime,",",2)
	s PAAdmTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	
	s PAAdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
	s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (Diagnosis '= "")
	{	
		s Diagnosis = $P(Diagnosis,"^",3)
		//s Diagnosis = $tr(Diagnosis,"'","\'")
	}
	else
	{
		s Diagnosis = "无"
	}
	s PAADMDocCode=$p($g(^PAADM(PAADMRowID)),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
		s HeadUniteDocStr = ..GetHadeUniteDoc(PAADMDocCode,locID)
		s HeadUniteDoc = $p(HeadUniteDocStr,"^",3)
		if (HeadUniteDoc = "")
		{
			s HeadUniteDoc = "无"
		}
		s ChiefDocStr = ..GetChiefDoc(PAADMDocCode)
		s ChiefDocCode = $p(ChiefDocStr,"^",1)
		s ChiefDocDesc = $p(ChiefDocStr,"^",2)
		if (ChiefDocDesc = "")
		{
			s ChiefDocDesc = "无"
		}
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		// 病房
		s PAAdmRoom = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmRoom = "无"
		s PAAdmBedNO = "无"
	}
	//病区
	s WardDr=$P($g(^PAADM(PAADMRowID)),"^",70)
	if (WardDr'="")
	{
		s PAAdmWardStr = $P($g(^PAWARD(WardDr)),"^",2)
		s PAAdmWard = $P(PAAdmWardStr,"-",2)
		if (PAAdmWard'="")
		{
			s PAAdmWard = PAAdmWard
		}
		else
		{
			s PAAdmWard = PAAdmWardStr
		}
	}
	else
	{
		s PAAdmWard="无"
	}
	
	s AdmReason = $P($g(^PAADM(PAADMRowID,1)),"^",7)
	if (AdmReason'="")
	{
		s PAAdmReason = $P($g(^PAC("ADMREA",AdmReason)),"^",2)
		s PAAdmReasonCode = $P($g(^PAC("ADMREA",AdmReason)),"^",5)
	}
	else
	{
		s PAAdmReason=""
		s PAAdmReasonCode=""
	}
	
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	// 住院天数			
	s ResidentDays=..ResidentDaysAdm(PAADMRowID,Hospital)
	// 入院次数			
	s InTimes=..InTimes(PAADMRowID,Hospital)
	
	set ^CacheTemp(repid,ind) = $LB(mradm,PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMISex,PAPMIDOB,PAPMIAge,PAAdmDate,PAAdmTime,PAAdmType,Diagnosis,PAAdmDocCodeDR,HeadUniteDoc,ChiefDocDesc,PAAdmBedNO,PAAdmWard,PAAdmRoom,PAAdmReason,ResidentDays,InTimes,MedicareNo)
	set ind = ind + 1
	Quit
}

ClassMethod GetInPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInPatListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInPatListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断一条就诊记录是否属于“本组(本单元)”的就诊记录；
ClassMethod CheckCTLocMedUnit(ATransCTCPDR As %String, ADocId As %String, ALocId As %String) As %Status
{
	//s PatDoc=$P($g(^PAADM(APAADMRowID)),"^",9)
	//修正逻辑，科室专科前医师 和 当前登录医生是否一个同一个治疗组。 
	//而不是取患者当前的主管医师
	//lifb 20170818 
	s PatDoc=ATransCTCPDR
	s Allow=0
	s MedUnitDocStr=""
	s CurMedUnitRowid=""
	s ret=##class(web.DHCCTLocMedUnit).getMedUnit(ALocId,ADocId)
	if ret'="" s CurMedUnitRowid=$p(ret,"^",1)
	Q:CurMedUnitRowid="" Allow

	s CTLOCID=$p(CurMedUnitRowid,"||",1)
	s MUChildID=$p(CurMedUnitRowid,"||",2)
	s MUCPChildsub=0
	for {
		s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub))
		Q:MUCPChildsub=""
		s DoctorId=$p(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub),"^",1)
		s MUCDateFrom=$P($G(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub)),"^",5)
		s MUCDateTo=$P($G(^CTLOC(CTLOCID,"MU",MUChildID,"CP",MUCPChildsub)),"^",6)
		if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
		if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
		
		i MedUnitDocStr="" {
			s MedUnitDocStr="^"_DoctorId_"^"
		}else{
			s MedUnitDocStr=MedUnitDocStr_"!"_"^"_DoctorId_"^"
		}
	}
	
	s PatDoc="^"_PatDoc_"^"
	i MedUnitDocStr[PatDoc s Allow=1
	
	Q Allow
}

/// 获取出院患者信息
/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetOutPatList","6","105","currentUser")
Query GetOutPatList(ALocID As %String, AUserID As %String, ARadioValue As %String, AStartDate As %String, AEndDate As %String, APAPMINo As %String = "", AMedicareNo As %String = "", APAPMIName As %String = "", AUserCode As %String = "") As %Query(ROWSPEC = "mradm:%String,PatientID:%String,EpisodeID:%String,PAPMINO:%String,PAPMIName:%String,PAPMISex:%String,PAPMIDOB:%String,PAPMIAge:%String,PAAdmDocCodeDR:%String,PAAdmBedNO:%String,PAAdmDischgeDate:%String,PAAdmDischgeTime:%String,ResidentDays:%String,OutDays:%String,InTimes:%String,HomepageURL:%String,IsRecordCompleted:%String,MedicareNo:%String,DisDiagnosDesc:%String,PAAdmWard:%String,PAAdmDate:%String,PAAdmTime:%String")
{
}

ClassMethod GetOutPatListExecute(ByRef qHandle As %Binary, ALocID As %String, AUserID As %String, ARadioValue As %String, AStartDate As %String, AEndDate As %String, APAPMINo As %String = "", AMedicareNo As %String = "", APAPMIName As %String = "", AUserCode As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s DocId=$p($g(^SSU("SSUSR",AUserID)),"^",14)
	s locID = ALocID
	
	if (locID'="") {
		s CTLOCType = $p($g(^CTLOC(locID)),"^",13)
		if (CTLOCType="W") {
			s locIDStr = ..CurDeptLinkLocByDept(ALocID)
			s locIDCount = $L(locIDStr,"^")
			for i=3:1:locIDCount-1
			{
				s locID = $p(locIDStr,"^",i)
				d currentLocOut
			}
		}
		else
		{
			d currentLocOut
		}
	}
	
	Quit $$$OK
currentLocOut
	for date=AStartDate:1:AEndDate
	{
		s PAADMRowID = ""
		for {
			s PAADMRowID = $O(^PAADMi("DischDate",date,PAADMRowID))
			q:PAADMRowID=""
			s PatientID=$P(^PAADM(PAADMRowID),"^",1)
			//登记号
			s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
			//患者姓名
			s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
			//病案号
			s MedicareNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(PAADMRowID)
	
			//主管医师Code
			s PAADMDocCode=$p($g(^PAADM(PAADMRowID)),"^",9)
			s CTPCPCode = ""
			s:(PAADMDocCode'="") CTPCPCode = $p($g(^CTPCP(PAADMDocCode,1)),"^",1)
			//按“本人病人”查询
			if (ARadioValue = "currentUser")
			{
				s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
				continue:(PatDoc '= DocId)
				s dischgDeptDR=$P($g(^PAADM(PAADMRowID)),"^",4)
				continue:dischgDeptDR'=locID
				if (APAPMINo '= ""){
					continue:(PAPMINO '= APAPMINo)
				}
				if (AMedicareNo '= ""){
					continue:(MedicareNo '= AMedicareNo)
				}
				if (APAPMIName '= ""){
					continue:(PAPMIName '= APAPMIName)
				}
				if (AUserCode '= ""){
					continue:(CTPCPCode '= AUserCode)
				}
				d outputrowOut
			}
			//按“本组病人”查询，即“本单元病人”查询
			elseif (ARadioValue = "currentGroup")
			{
				//修正本单元判定 modify by lifb 20170828
				//s isOK = ..CheckCTLocMedUnit(PAADMRowID,DocId,locID)
				s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
				s isOK = ..CheckCTLocMedUnit(PatDoc,DocId,locID)
				continue:(isOK '=1)
				s dischgDeptDR=$P($g(^PAADM(PAADMRowID)),"^",4)
				continue:dischgDeptDR'=locID
				if (APAPMINo '= ""){
					continue:(PAPMINO '= APAPMINo)
				}
				if (AMedicareNo '= ""){
					continue:(MedicareNo '= AMedicareNo)
				}
				if (APAPMIName '= ""){
					continue:(PAPMIName '= APAPMIName)
				}
				if (AUserCode '= ""){
					continue:(CTPCPCode '= AUserCode)
				}
				d outputrowOut
			}
			//按“本科室病人”查询
			elseif (ARadioValue = "currentLoc")
			{
				s dischgDeptDR=$P($g(^PAADM(PAADMRowID)),"^",4)
				continue:dischgDeptDR'=locID
				if (APAPMINo '= ""){
					continue:(PAPMINO '= APAPMINo)
				}
				if (AMedicareNo '= ""){
					continue:(MedicareNo '= AMedicareNo)
				}
				if (APAPMIName '= ""){
					continue:(PAPMIName '= APAPMIName)
				}
				if (AUserCode '= ""){
					continue:(CTPCPCode '= AUserCode)
				}
				d outputrowOut
			}
		}
	}
	
	Quit $$$OK
outputrowOut
	s EpisodeID=PAADMRowID
	s mradm=$P(^PAADM(PAADMRowID),"^",61)
	
	//性别
	s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//出生日期和年龄
	s PAPMIDOB=""
	s PAPMIAge=""
	s DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	if (DobDate'="")
	{
		s PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
		//modify by lifb 20180828 标准化显示日期格式
		s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
		s PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		if (PAPMIAge = "0")
		{
			s birthday = ..Birthday(PatientID)
			s admDate = ..AdmDateTime(PAADMRowID, "")
			s admDate = $P(admDate, ",", 1)
			s age = ..Age(PAADMRowID,birthday,admDate,4)
			//s age = ""
			s PAPMIAge=age
		}
	}
	
	if (PAADMDocCode '= "")
	{
		//主管医师描述
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
		//修改成我们自己写的
		s HeadUniteDoc = ..GetHadeUniteDoc(PAADMDocCode,locID)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmWard = "无"
		s PAAdmBedNO = "无"
	}
	//入院日期
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(PAADMRowID)
	s PAAdmDate=$P(admDateTime,",",1)
	s PAAdmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	
	s PAAdmTime=$P(admDateTime,",",2)
	s PAAdmTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	//出院日期
	s PAAdmDischgeDateSys=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PAAdmDischgeDateSys '= "")
	{
		s PAAdmDischgeDate = $zd(PAAdmDischgeDateSys,3)
		s PAAdmDischgeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDischgeDate)
	
	}
	//出院时间
	s PAAdmDischgeTimeSys=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PAAdmDischgeTimeSys '= "")
	{
		s PAAdmDischgeTime = $zt(PAAdmDischgeTimeSys,3)
		s PAAdmDischgeTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmDischgeTime)
	
	}
	//出院天数
	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s OutDays = Systemdateint-PAAdmDischgeDateSys
	
	//出院诊断
	s DisDiagnosInfo = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	s DisDiagnosDesc = $p(DisDiagnosInfo,"^",3)
	
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	// 住院天数			
	s ResidentDays=..ResidentDaysAdm(PAADMRowID,Hospital)
	// 入院次数			
	s InTimes=..InTimes(PAADMRowID,Hospital)
	
	//判断此次就诊是否已写“病案首页”——是：输出浏览链接；否：输出空
	//15%90#20^7%91^7#2%92&1%93&20^15%94^15
	//s PatListTemplateIDStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PatListTemplateIDStr")
	//s HomepageTemplateIDStr = $p(PatListTemplateIDStr,"#",1)
	s HomepageTemplateIDStr = ..GetTemplateInfo("HomePage")
	s HomepageURL = ..GetEMRURL(PAADMRowID,HomepageTemplateIDStr)
	
	//判断就诊病历是否全部完成，若完成输出1，否则输出0
	s IsRecordCompleted = ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(EpisodeID)
	
	set ^CacheTemp(repid,ind) = $LB(mradm,PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMISex,PAPMIDOB,PAPMIAge,PAAdmDocCodeDR,PAAdmBedNO,PAAdmDischgeDate,PAAdmDischgeTime,ResidentDays,OutDays,InTimes,HomepageURL,IsRecordCompleted,MedicareNo,DisDiagnosDesc,PAAdmWard,PAAdmDate,PAAdmTime)
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetOutPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutPatListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOutPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutPatListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取在院转科患者信息
/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetChangeDeptPatList","6","105","","")
Query GetChangeDeptPatList(ALocID As %String, AUserID As %String, ARadioValue As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "mradm:%String,PatientID:%String,EpisodeID:%String,PAPMINO:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,PAPMIDOB:%String,PAAdmDocCodeDR:%String,PAAdmDepCodeDR:%String,PAAdmBedNO:%String,TransStartDate:%String,TransStartTime:%String,TransRoom:%String,TransBedNO:%String,TransURL:%String")
{
}

ClassMethod GetChangeDeptPatListExecute(ByRef qHandle As %Binary, ALocID As %String, AUserID As %String, ARadioValue As %String, StartDate As %String, EndDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s CTLOCType = $p($g(^CTLOC(ALocID)),"^",13)
	s DocId=$p($g(^SSU("SSUSR",AUserID)),"^",14)
	
	s PAADMRowID = 0
	for
	{
		s PAADMRowID = $o(^PAADMi("AdmTypeCurr","I",PAADMRowID))
		q:PAADMRowID=""
		continue:$p(^PAADM(PAADMRowID),"^",20)'="A"	 ;VisitStatus

		s PAPMI = $p(^PAADM(PAADMRowID),"^",1)
		
		if (CTLOCType="W") 
		{
			s WardID = $O(^PAWARD(0,"WARD_LocationDR",ALocID,""))
			if ($d(^PAPER(PAPMI,"PAT",1)))&&($$findAdmTransWard(PAADMRowID,WardID))&&($p(^PAADM(PAADMRowID),"^",70)'=WardID)
			{
				//过滤掉非本人转出患者
				&sql(SELECT TRANS_CTCP_DR into :TransCTCPDR FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef = :PAADMRowID and TRANS_CTLOC_DR = :ALocID and TRANS_Status_DR->REQST_Code <> 'J')
				//按“本人病人”查询
				if (ARadioValue = "currentUser"){
					continue:(TransCTCPDR '= DocId)
				}
				//按“本组病人”查询，即“本单元病人”查询
				elseif(ARadioValue = "currentGroup"){
					s isOK = ..CheckCTLocMedUnit(TransCTCPDR,DocId,ALocID)
					continue:(isOK '=1)
					continue:(TransCTCPDR '= DocId)
				}
				//转出日期和转出时间
				s PAADMDepCode=$p($g(^PAADM(PAADMRowID)),"^",4)
				&sql(SELECT TRANS_StartDate,TRANS_StartTime into :TransStartDate,:TransStartTime FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef = :PAADMRowID and TRANS_CTLOC_DR = :PAADMDepCode and TRANS_Status_DR->REQST_Code <> 'J')
				continue:(TransStartDate < StartDate)
				continue:(TransStartDate > EndDate)
				
				d OutputRow
			}
		}
		else
		{
			if ($d(^PAPER(PAPMI,"PAT",1)))&&($d(^PAADMi("TransLoc",PAADMRowID,ALocID)))&&($p(^PAADM(PAADMRowID),"^",4)'=ALocID)
			{
				//过滤掉非本人转出患者
				&sql(SELECT TRANS_CTCP_DR into :TransCTCPDR FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef = :PAADMRowID and TRANS_CTLOC_DR = :ALocID and TRANS_Status_DR->REQST_Code <> 'J')
				//按“本人病人”查询
				if (ARadioValue = "currentUser"){
					continue:(TransCTCPDR '= DocId)
				}
				//按“本组病人”查询，即“本单元病人”查询
				elseif(ARadioValue = "currentGroup"){
					s isOK = ..CheckCTLocMedUnit(TransCTCPDR,DocId,ALocID)
					continue:(isOK '=1)
					continue:(TransCTCPDR '= DocId)
				}
				//转出日期和转出时间
				s PAADMDepCode=$p($g(^PAADM(PAADMRowID)),"^",4)
				&sql(SELECT TRANS_StartDate,TRANS_StartTime into :TransStartDate,:TransStartTime FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef = :PAADMRowID and TRANS_CTLOC_DR = :PAADMDepCode and TRANS_Status_DR->REQST_Code <> 'J')
				continue:(TransStartDate < StartDate)
				continue:(TransStartDate > EndDate)

				d OutputRow
			}
		}
	}
	Quit $$$OK
	
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find

OutputRow
	s PatientID=$P(^PAADM(PAADMRowID),"^",1)
	s EpisodeID=PAADMRowID
	s mradm=$P(^PAADM(PAADMRowID),"^",61)
	
	s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	//性别
	s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//性别翻译
	s PAPMISex = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTSex","CTSEXDesc",PAPMISex)
	
	//出生日期和年龄
	s PAPMIDOB=""
	s PAPMIAge=""
	s DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	if (DobDate'="")
	{
		s PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
		//modify by lifb 20170828 标准化日期格式
		s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
		s PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		if (PAPMIAge = "0")
		{
			s birthday = ..Birthday(PatientID)
			s admDate = ..AdmDateTime(PAADMRowID, "")
			s admDate = $P(admDate, ",", 1)
			s age = ..Age(PAADMRowID,birthday,admDate,4)
			//s age = ""
			s PAPMIAge=age
		}
	}
	//当前主管医生
	s PAADMDocCode=$p($g(^PAADM(PAADMRowID)),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	//当前科室
	s PAADMDepCode=$p($g(^PAADM(PAADMRowID)),"^",4)
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
		//科室翻译
		s PAAdmDepCodeDR = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTLoc","CTLOCDesc",PAAdmDepCodeDR)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	//当前病区和床位
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmWard = "无"
		s PAAdmBedNO = "无"
	}
	//转出日期和转出时间
	s TransStartDate = $ZD(TransStartDate,3)
	
	s TransStartDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",TransStartDate)
	s TransStartTime = $ZT(TransStartTime,3)
	s TransStartTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",TransStartTime)
	//转出病房和转出床位
	s TransBedDR = ""
	&sql(SELECT TRANS_Bed_DR into :TransBedDR FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef = :PAADMRowID and TRANS_CTLOC_DR=:ALocID )
	if (TransBedDR '= "")
	{
		s WARDRowID = $p(TransBedDR,"||",1)
		s BEDChildsub = $p(TransBedDR,"||",2)
		s TransRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s TransRoom = $p($g(^PAROOM(TransRoomDR)),"^",2)
		s TransBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s TransRoom = "无"
		s TransBedNO = "无"
	}
	
	//判断此次就诊是否已写“转出记录”——是：输出浏览链接；否：输出空
	//15%90#20^7%91^7#2%92&1%93&20^15%94^15
	//s PatListTemplateIDStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PatListTemplateIDStr")
	//s TransTemplateIDStr = $p(PatListTemplateIDStr,"#",2)
	
	s TransTemplateIDStr = ..GetTemplateInfo("Transfer")
	s TransURL = ..GetEMRURL(PAADMRowID,TransTemplateIDStr)
	
	set ^CacheTemp(repid,ind) = $LB(mradm,PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMISex,PAPMIAge,PAPMIDOB,PAAdmDocCodeDR,PAAdmDepCodeDR,PAAdmBedNO,TransStartDate,TransStartTime,TransRoom,TransBedNO,TransURL)
	set ind = ind + 1
	
	Quit $$$OK
}

ClassMethod GetChangeDeptPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeDeptPatListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChangeDeptPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeDeptPatListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询本人当天手术患者
Query GetOperationPatList(ALocID As %String, AUserID As %String, ARadioValue As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "mradm:%String,PatientID:%String,EpisodeID:%String,PAPMINO:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,PAPMIDOB:%String,PAAdmBedNO:%String,opdes:%String,OPCategory:%String,opdatestr:%String,PreOPConferURL:%String,OPRecordURL:%String,AfterOPFirstURL:%String")
{
}

ClassMethod GetOperationPatListExecute(ByRef qHandle As %Binary, ALocID As %String, AUserID As %String, ARadioValue As %String, StartDate As %String, EndDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s DocId=$p($g(^SSU("SSUSR",AUserID)),"^",14)
	s OPCategory=""
	s OPCategoryId=""
	s opdatestr=""
	
	s SubNode="SDate"
	s opaId = ""
	s DocId=$p($g(^SSU("SSUSR",AUserID)),"^",14)
	for date=StartDate:1:EndDate
	{
		for 
		{
			s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId))
			q:opaId=""
			
			s opdes = ""
			s adm=$P(^DHCANOPArrange(opaId),"^",1)
			s PAADMRowID = adm
			s PatDoc=$P($g(^PAADM(adm)),"^",9)
			
			//按“本人病人”查询
			if (ARadioValue = "currentUser")
			{
				continue:(PatDoc '= DocId)
			}
			//按“本组病人”查询，即“本单元病人”查询
			elseif (ARadioValue = "currentGroup")
			{
				s isOK = ..CheckCTLocMedUnit(adm,DocId,ALocID)
				continue:(isOK '=1)
			}
			//按“本科室病人”查询
			elseif (ARadioValue = "currentLoc")
			{
				s operateDeptDR=$P($g(^PAADM(adm)),"^",4)
				continue:operateDeptDR'=ALocID
			}
			
			//手术名称		
			s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
			s subchl=0
			for 
			{
				s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl))
				q:(subchl="")
				s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)
				if (opdr'="")
				{
					if ($P($g(^ORC("OPER",+opdr)),"^",2)'="")
					{
						//修改取手术名称的方法 modify by niucaicai 2016-10-27
						//s opdes = $P($g(^ORC("OPER",+opdr)),"^",2)
						//手术名称未取全 modify by lina 2017-08-08
						s:(opdes '= "") opdes = opdes_";"_$P($g(^ORC("OPER",+opdr)),"^",2)
						s:(opdes = "") opdes = $P($g(^ORC("OPER",+opdr)),"^",2)
					}
					//手术级别
					s OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7)
					if (OPCategoryId'="")
					{
						s OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
					}
				}
				else
				{
					if ($g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="")
					{
						//修改取手术名称的方法 modify by niucaicai 2016-10-27
						//s opdes = $G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
						//手术名称未取全 modify by lina 2017-08-08
						s:(opdes '= "") opdes = opdes_";"_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
						s:(opdes = "") opdes = $G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
					}
				}
			}
			//手术时间
			s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
			s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
			s openddate=$P(^DHCANOPArrange(opaId),"^",16)
			s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
			if (openddate<=opstdate)
			{
				s openddate=""
			}
			if (openddate'="")
			{
				s openddate=$ZD(openddate,3)
				s openddate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",openddate)	
				s openddate=openddate_" "
			}
			if (opendtime'="")
			{
				s opendtime=$ZT(opendtime,2)
				s opendtime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",opendtime)
	
			}
			if (opsttime'="")
			{
				s opsttime=$ZT(opsttime,2)
				s opsttime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",opsttime)
	
			}
			s opstdate=$ZD(opstdate,3)
			s opstdate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",opstdate)
	
			s opdatestr=opstdate_" "_opsttime_"~"_openddate_opendtime
			
			
			//患者信息
			s PatientID=$P(^PAADM(PAADMRowID),"^",1)
			s EpisodeID=PAADMRowID
			s mradm=$P(^PAADM(PAADMRowID),"^",61)
	
			s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
			s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
			//性别
			s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
			s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
			//性别翻译
			s PAPMISex = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTSex","CTSEXDesc",PAPMISex)
	
			
			//出生日期和年龄
			s PAPMIDOB=""
			s PAPMIAge=""
			s DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
			if (DobDate'="")
			{
				s PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
				//modify by lifb 20170828 标准化日期格式
				s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
				s PAPMIAge=$fn((+$H-DobDate)/365,"",0)
				if (PAPMIAge = "0")
				{
					s birthday = ..Birthday(PatientID)
					s admDate = ..AdmDateTime(PAADMRowID, "")
					s admDate = $P(admDate, ",", 1)
					s age = ..Age(PAADMRowID,birthday,admDate,4)
					//s age = ""
					s PAPMIAge=age
				}
			}
			//当前病区和床位
			s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
			if (PAADMBedDR '= "")
			{
				s WARDRowID = $p(PAADMBedDR,"||",1)
				s BEDChildsub = $p(PAADMBedDR,"||",2)
				s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
				s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
				s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
			}
			else
			{
				s PAAdmWard = "无"
				s PAAdmBedNO = "无"
			}
			
			//判断此次就诊是否已写“术前讨论”、“手术记录”、“术后首次病程记录”——是：输出浏览链接；否：输出空
			//s PatListTemplateIDStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PatListTemplateIDStr")
			//s OPTemplateIDStr = $p(PatListTemplateIDStr,"#",3)
			//15%90#20^7%91^7#2%92&1%93&20^15%94^15
			
			//s PreOPConferTempIDStr = $p(OPTemplateIDStr,"&",1)
			s PreOPConferTempIDStr = ..GetTemplateInfo("BeforeOperation")
			s PreOPConferURL = ..GetEMRURL(PAADMRowID,PreOPConferTempIDStr)
			
			//s OPRecordTempIDStr = $p(OPTemplateIDStr,"&",2)
			s OPRecordTempIDStr = ..GetTemplateInfo("Operation")
			s OPRecordURL = ..GetEMRURL(PAADMRowID,OPRecordTempIDStr)
			
			//s AfterOPFirstTempIDStr = $p(OPTemplateIDStr,"&",3)
			s AfterOPFirstTempIDStr = ..GetTemplateInfo("AfterOperation")
			s AfterOPFirstURL = ..GetEMRURL(PAADMRowID,AfterOPFirstTempIDStr)
			
			set ^CacheTemp(repid,ind) = $LB(mradm,PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMISex,PAPMIAge,PAPMIDOB,PAAdmBedNO,opdes,OPCategory,opdatestr,PreOPConferURL,OPRecordURL,AfterOPFirstURL)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetOperationPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationPatListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationPatListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取危重患者列表
/// d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetCriticallyPatList","6","","","")
Query GetCriticallyPatList(ALocID As %String, AUserID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "mradm:%String,PatientID:%String,EpisodeID:%String,PAPMINO:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,PAPMIDOB:%String,PAAdmBedNO:%String,PAAdmDocCodeDR:%String,HeadUniteDoc:%String,ChiefDoc:%String,Diagnosis:%String,ItemMastDesc:%String,CareClass:%String,Vitalsigns:%String")
{
}

ClassMethod GetCriticallyPatListExecute(ByRef qHandle As %Binary, ALocID As %String, AUserID As %String, StartDate As %String = "", EndDate As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	//根据病危病重医嘱的状态，判断患者是否是危重病人，将是危重病人的医嘱状态维护到CriticallyOrdStatus中，以"^"分隔；
	s CriticallyOrdStatus = "V^E"
	s CriticallyOrdObjs = ..GetCriticallyOrdObjs()
	
	if (ALocID'="") {
		s CTLOCType = $p($g(^CTLOC(ALocID)),"^",13)
		if (CTLOCType="W") {
			s locIDStr = ..CurDeptLinkLocByDept(ALocID)
			s locIDCount = $L(locIDStr,"^")
			for i=3:1:locIDCount-1
			{
				s locID = $p(locIDStr,"^",i)
				d curLocAdm
			}
		}
		else
		{
			s locID = ALocID
			d curLocAdm
		}
	}
	Quit $$$OK
curLocAdm
	s PAADMRowID = ""
	for {
		s PAADMRowID = $o(^PAADMi("PAADM_Type","I",PAADMRowID))
		q:(PAADMRowID = "")
		
		s AdmCurLocID=$P($g(^PAADM(PAADMRowID)),"^",4)
		continue:(AdmCurLocID '= locID)
		 
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		continue:(AdmStatus '= "A")
		
		d curLocAdmCritical
	}
	Quit $$$OK
curLocAdmCritical
	//s CriticallyOrdRowIDStr = ##Class(EMRservice.BOSysOption).GetValueByName("CriticallyOrdRowIDStr")
	//s CriticallyOrdStatus = ##Class(EMRservice.BOSysOption).GetValueByName("CriticallyOrdStatus")
	//s CriticallyOrdRowIDStr = "12110||1^病危#12111||1^病重"
	
	s flag = 0
	s OrderID = 0
	for {  
		s OrderID = $o(^OEORD(0,"Adm",PAADMRowID,OrderID)) 
		q:(OrderID = "")||(flag = 1)
		
		//for Ind = 1:1:$L(CriticallyOrdRowIDStr,"#")
		for Ind = 1:1:CriticallyOrdObjs.Count()
		{
			q:(flag = 1)
			//s ARCItmMast = $p($P(CriticallyOrdRowIDStr,"#",Ind),"^",1)
			s ARCItmMast = CriticallyOrdObjs.GetAt(Ind).OrdRowID
			continue:(ARCItmMast = "")
		
			//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
			continue:('$d(^OEORDi(0,"ARCIM",OrderID,ARCItmMast)))
		
			s SttDat = 0
			for {
				s SttDat = $o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat)) 
				q:(SttDat="")
			
				s ChildSub = 0
				for {
					s ChildSub = $o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat,ChildSub)) 
					q:(ChildSub="")
				
					s OeordItemID = OrderID_"||"_ChildSub
					s FillerNo = $p($g(^OEORD(OrderID,"I",ChildSub,9)),"^",12)
					//只取手工下的医嘱，不取滚的医嘱
					/*
					if ($ZCVT(IsManualOrdItem,"U") = "Y")
					{
					   continue:(FillerNo '= "")	
					}
					*/
					s CurrStatus = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",13)
					s CurrStatusCode = $p(^OEC("OSTAT",CurrStatus),"^",1)
					
					if (CriticallyOrdStatus [ CurrStatusCode ) 
					{
						s flag = 1
						
						s IDate = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",9)      //开医嘱时间  OEORI_SttDat
						s ITime = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",10)
						s VDate = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",7)      //核实时间   OEORI_Date
						s VTime = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",15)
						s:(VTime = "") VTime = ITime
						s EDate = $p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",2)      //执行时间   OEORI_DateExecuted
						s ETime = $p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",3)	
						s DDate = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",34)     //停止时间   OEORI_XDate
						s DTime = $p($g(^OEORD(OrderID,"I",ChildSub,2)),"^",15)
						s ItemMastID = ARCItmMast
						s ItemMastDesc = $p($g(^ARCIM(+$p(ARCItmMast,"||",1),+$p(ARCItmMast,"||",2),1)),"^",2)
						d OutputRow
					}
				}
			}
		}
		
	}
	Quit $$$OK
OutputRow
	//患者信息
	s PatientID=$P(^PAADM(PAADMRowID),"^",1)
	s EpisodeID=PAADMRowID
	s mradm=$P(^PAADM(PAADMRowID),"^",61)

	s PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	s PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	//性别
	s Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//性别翻译
	s PAPMISex = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTSex","CTSEXDesc",PAPMISex)
	
	//出生日期和年龄
	s PAPMIDOB=""
	s PAPMIAge=""
	s DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	if (DobDate'="")
	{
		s PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
		//modify by lifb 20170828 标准化日期格式
		s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAPMIDOB)
		
		s PAPMIAge=$fn((+$H-DobDate)/365,"",0)
		if (PAPMIAge = "0")
		{
			s birthday = ..Birthday(PatientID)
			s admDate = ..AdmDateTime(PAADMRowID, "")
			s admDate = $P(admDate, ",", 1)
			s age = ..Age(PAADMRowID,birthday,admDate,4)
			//s age = ""
			s PAPMIAge=age
		}
	}
	s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (Diagnosis '= "")
	{	
		s Diagnosis = $P(Diagnosis,"^",3)
		s Diagnosis = $tr(Diagnosis,"'","\'")
	}
	else
	{
		s Diagnosis = "无"
	}
	s PAADMDocCode=$p($g(^PAADM(PAADMRowID)),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
		s HeadUniteDocStr = ..GetHadeUniteDoc(PAADMDocCode,ALocID)
		s HeadUniteDoc = $p(HeadUniteDocStr,"^",3)
		if (HeadUniteDoc = "")
		{
			s HeadUniteDoc = "无"
		}
		s ChiefDocStr = ..GetChiefDoc(PAADMDocCode)
		s ChiefDocCode = $p(ChiefDocStr,"^",1)
		s ChiefDocDesc = $p(ChiefDocStr,"^",2)
		if (ChiefDocDesc = "")
		{
			s ChiefDocDesc = "无"
		}
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	//当前病区和床位
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmWard = "无"
		s PAAdmBedNO = "无"
	}
	
	//取当前护理级别
	//CareOrdArcimRowIDStr = ##Class(EMRservice.BOSysOption).GetValueByName("CareOrdArcimRowIDStr")
	//s CareOrdArcimRowIDStr = "^10337||1^10338||1^10339||1^10340||1^10341||1^10342||1^12878||1^12879||1^13102||1^13103||1^13104||1^"
	s CareOrdArcimRowIDStr = ..GetCareOrdArcimRowIDStrs()
	s CareClass = ..CareClass(PAADMRowID,CareOrdArcimRowIDStr)
	
	//取生命体征
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLVitalsigns:GetVitalsignsData")
	//d ds.Execute(EpisodeID,"^^^ITEM1^ITEM7^ITEM4^ITEM5^ITEM6^ITEM28","","")
	//护理组更换生命体征编码
	/*
	^MRC("OBITM",67)="pulse^脉搏（次/分）^^^^^^N^^^^^60^100^^^^3^^^^^"
	^MRC("OBITM",68)="breath^呼吸（次/分）^^^^^^N^^^^^12^24^^^^4^^^^^"
	^MRC("OBITM",69)="temperature^腋温（℃）^^^^^^N^^^^^35.99^37.41^^^^1^34^43^^^"
	^MRC("OBITM",70)="sysPressure^收缩压（mmHg）^^^^^2^N^^^^^90^140^^^^6^^^^^"
	^MRC("OBITM",71)="diaPressure^舒张压（mmHg）^^^^^2^N^^^^^60^90^^^^7^^^^^"
	^MRC("OBITM",72)="defFreq^大便次数（次）^^^^^1^N^※"_$c(129)_"/E^^^^^^^^^12^^^^^        "
	^MRC("OBITM",73)="weight^体重（KG）^^^^^1^N^平车"_$c(129)_"卧床"_$c(129)_"轮椅^^          ^^^^^^^14^^^^^"
	^MRC("OBITM",74)="height^身高(cm)^^^^^1^N^平车"_$c(129)_"卧床"_$c(129)_"轮椅^^^^        ^^^^^13^^^^^"
	^MRC("OBITM",75)="liquidln^总入量^^^^^1^N^^^^^^^^^^15^^^^^"
	^MRC("OBITM",76)="uriVolume^尿量^^^^^1^N^^^^^^^^^^16^^^^^"
	^MRC("OBITM",77)="phyCooling^物理降温(℃)^^^^^^N^^^^^^^^^^10^^^^^"
	^MRC("OBITM",78)="Reason^未测原因^^^^^6^N^^^^^^^拒测@外出@请假@血透@检查^^^28^^^              ^^"
	^MRC("OBITM",79)="heartbeat^心率（次/分）^^^^^6^N^^^^^^^^^^9^^^^^"
	^MRC("OBITM",80)="degrBlood^血氧饱和度^^^^^^N^^^^^^^^^^8^^^^^"
	^MRC("OBITM",81)="Barthel^Barthel评分^^^^^1^N^^^^^^^^^^17^^^^^"
	^MRC("OBITM",82)="Bedsore^压疮风险评估^^^^^1^N^^^^^^^^^^18^^^^^"
	^MRC("OBITM",83)="Fallrisk^跌倒风险评估^^^^^1^N^^^^^^^^^^19^^^^^"
	^MRC("OBITM",84)="Fallbed^坠床风险评估^^^^^1^N^^^^^^^有@无^^^20^^^^^"
	^MRC("OBITM",85)="painInten^疼痛评分^^^^^^N^^^^^^^^^^11^^^^^"
	^MRC("OBITM",86)="rectemperature^肛温（℃）^^^^^6^N^^^^^36.3^37.2^^^^2^^^^^"
		
	*/
	d ds.Execute(EpisodeID,"^^^temperature^pulse^breath^sysPressure^diaPressure^liquidln","","")
	
	While (ds.Next())
	{
		s TW = ds.Data("ITEM1")
		s MB = ds.Data("ITEM2")
		s HX = ds.Data("ITEM3")
		s SZY = ds.Data("ITEM4")
		s SSY = ds.Data("ITEM5")
		s Vitalsigns = "T:"_TW_"°C P:"_MB_"次/分 R:"_HX_"次/分 BP:"_SZY_"/"_SSY_" mmHg"
	}
	
	set ^CacheTemp(repid,ind) = $LB(mradm,PatientID,EpisodeID,PAPMINO,PAPMIName,PAPMISex,PAPMIAge,PAPMIDOB,PAAdmBedNO,PAAdmDocCodeDR,HeadUniteDoc,ChiefDocDesc,Diagnosis,ItemMastDesc,CareClass,Vitalsigns)
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetCriticallyPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCriticallyPatListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCriticallyPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCriticallyPatListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据EpisodeID和系统参数，判断该就诊的某个病历是否已写，是的话返回病历URL，否的话返回空
/// w ##Class(EMRservice.DAL.GetPaAdmDetail).GetEMRURL("43","2%92")
ClassMethod GetEMRURL(PAADMRowID As %String, ATemplateIDStr As %String) As %String
{
	//2%92&1%93&20^15%94^15
	//s PAADMRowID = "43"
	//s ATemplateIDStr = "1"
	s URL = ""
	s HappenDate = 0
	for
	{
		s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",PAADMRowID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",PAADMRowID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s TheECRecord = ""
			for
			{
				s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",PAADMRowID," SAVE",HappenDate,HappenTime,TheECRecord))
				q:(TheECRecord = "")
				
				s ListNo = ""
				for
				{
					s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",PAADMRowID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
					q:(ListNo = "")
					
					s InstanceDataID = TheECRecord_"||"_ListNo
					s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
					s TemplateID = InstanceObj.RealTemplateID
					//2%98&1%97&20^15%99^15
					//continue:(ATemplateIDStr '[ TemplateID)
					
					for i=1:1:$L(ATemplateIDStr,"%")
					{
						s TemIDAndTitleCodeStr = $p(ATemplateIDStr,"%",i)
						
						continue:(TemplateID '= $p(TemIDAndTitleCodeStr,"^",1))
						if ($p(TemIDAndTitleCodeStr,"^",2) '= "")
						{
							continue:(InstanceObj.TitleCode '= $p(TemIDAndTitleCodeStr,"^",2))
						}
						s ECRecordObj = ##Class(EMRinstance.ECRecord).%OpenId(TheECRecord)
						s ChartItemID = ECRecordObj.RealChartItemID
						s ChartItemType = ECRecordObj.ChartItemType
						s DocumentType = ECRecordObj.DocumentType
						if (InstanceObj.Title '= "")
						{
							s Title = InstanceObj.Title
						}
						else
						{
							s Title = InstanceObj.GroupItemName
						}
						
						s Title = ##Class(EMRservice.HISInterface.Translation).Get("EMRTrans",Title)
						 
						s URL = "<a href='#' onclick=BrowserRecord('"_InstanceDataID_"','"_DocumentType_"','"_ChartItemType_"','"_ChartItemID_"')>"_Title_"</a>"
					
						do ECRecordObj.%Close()
						s ECRecordObj = ""
					}
					do InstanceObj.%Close()
					s InstanceObj = ""
				}
			}
		}
	}
	q URL
}

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
ClassMethod GetPapmiDR(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(argAdmId)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Desc:	入院日期时间(分床时间)【Cache内部格式】
/// Table：
/// Output：date_","_time
ClassMethod AdmDateTimeInBed(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",bed="",admdatetime="",admdate="",admtime=""
	s admdatetimeinbed=""

	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.q:(bed="")
	.s admdate=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",1)
	.s admtime=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",2)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetimeinbed=admdate_","_admtime
	}
	
	q admdatetimeinbed
}

/// Desc：	死亡日期时间
/// Ouput：	date，time【内部格式】
/// Others：not different from hospitals
ClassMethod DeathDateTime(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	
	s deathdate="",deathtime=""
	s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
	s deathtime=$p(^PAPER(argPapmiDR,"ALL"),"^",8)
	q:((deathdate="")||(deathtime="")) ""
	q deathdate_","_deathtime
}

/// Desc:	出院日期时间【统计组.工作量】
/// Other:  ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR("7","DiTan")
ClassMethod DisDateTimeMR(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argMeddata)=0)||(argMeddata="") ""
	//q:($d(argWebsrc)=0)||(argWebsrc="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	//取命名空间
	//s NAMESPACES=##class(EPRmeta.SysOption).GetOptionValueByName("NAMESPACES")
	s NAMESPACES=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NamespaceHIS")
	if NAMESPACES'=""
	{
		s MEDDATA = $p($g(NAMESPACES),"^",1)
		s WEBSRC  = $p($g(NAMESPACES),"^",2)
	    //s LABDATA = $p($g(NAMESPACES),"^",3)
	    //s LABSRC  = $p($g(NAMESPACES),"^",3)
	}
	
	//转命名空间 调用统计组接口
	d $zu(5,MEDDATA)
	s dischgdatetime=""
    s dischgdatetime=$$GetDisAdmDate^DHCMRIPday(argAdmId)
    d $zu(5,WEBSRC)
    
    //转换为标准格式
    if (dischgdatetime'="^")&&(dischgdatetime'="")
    {
	    s dischgdatetime=$tr(dischgdatetime,"^",",")
    }
    else
    {
	    s dischgdatetime=""
	}

    q dischgdatetime
}

/// Desc: 	出院日期时间(护士结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",18)
	q:((dischgdate="")||(dischgtime="")) ""

	s dischgdatetime=dischgdate_","_dischgtime
	q dischgdatetime
}

/// Desc:	住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	s papmidr="",DeathDateTime="",AdmDateTime="",DisDateTimeMR="",DisDateTime=""
	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s papmidr = ..GetPapmiDR(argAdmId)
	
	
	//取入院日期(护士分床)
	//s AdmDateTimeInBed=..AdmDateTimeInBed(argAdmId)
	//if AdmDateTimeInBed'="" 
	//{
	//	s admdate=$p($g(AdmDateTimeInBed),",",1)
	//}
	//modify by lifb 20170817 修正入院时间取值 走标准接口
	s AdmDateTimeInBed=##class(web.DHCDischargeHistory).GetAdminDateTime(argAdmId)
	if AdmDateTimeInBed'="^" 
	{
		s admdate=$p($g(AdmDateTimeInBed),"^",1)
	}
	//出院日期取值判断  死亡日期->出院日期(统计组)->出院日期(护士结算)
	

	//取死亡日期
	s DeathDateTime=..DeathDateTime(papmidr)
	if DeathDateTime'=""
	{
		s dischgdate=$p($g(DeathDateTime),",",1)
	}
		
	if dischgdate=""
	{
		//取出院日期(统计组)
		s DisDateTimeMR=..DisDateTimeMR(argAdmId)
		if DisDateTimeMR'="" 
		{
			s dischgdate=$p($g(DisDateTimeMR),",",1)
		}
		
		if dischgdate=""
		{
			//取出院日期(护士结算)
			s DisDateTime=..DisDateTime(argAdmId)
			if DisDateTime'="" 
			{
				s dischgdate=$p($g(DisDateTime),",",1)
			}
		}
	}
	
	q:(admdate="") ""
	
	//出院时间为空，默认计算截止当前系统日期的住院天数
	if (dischgdate = "")
	{
		s Systemdatetime = $HOROLOG
		s dischgdate = $p(Systemdatetime,",",1)
	}
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Desc:	住院天数
/// Input:	argAdmDate: 入院日期(Cache内部格式)，argDischgDate:出院日期(Cache内部格式)
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDays(argAdmDate As %String, argDischgDate As %String) As %String
{
	q:($d(argAdmDate)=0)||($d(argDischgDate)=0)||(argAdmDate="")||(argDischgDate="") ""
	s residentdays=""
	
	s residentdays=argDischgDate - argAdmDate
	q:(residentdays<0) ""
 	//不足1天按1天计算
 	q:(residentdays=0) "1"
 	
 	q residentdays
}

/// Desc:	入院次数(Trak中入院病人状态不是Cancel的个数)
/// Others:	not different from hospitals 
ClassMethod InTimes(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""	
	
	s admid=0,times=0,papmiDR=""
	
	//PAADM_InPatNo
	s times= $p($g(^PAADM(argAdmId)),"^",29)
	q:(times '="")&&(times '= $C(0)) times
	
	s times = 0
	s papmiDR =..GetPapmiDR(argAdmId)
	q:($d(^PAPERdr(papmiDR,"ADM","I"))'=10) "1"
	for {
		s admid=$o(^PAPERdr(papmiDR,"ADM","I",admid))
		q:((admid="")||(admid>argAdmId))
		// Trak中入院病人状态不是Cancel的个数
		if $d(^PAADMi("PAADM_VisitStatus","C",admid))=0 {s times=times+1}
	}
		
	q times
}

/// creator:李相宗
/// date:2011-11-30
/// desc:得到病人就诊医生的所在组的组长
/// input:CTLOCRowId就诊科室ID	DoctorID就诊医生ID
/// outPut:DocMessage 就诊医生所在组的组长和DocID
/// debug:w ##class(web.DHCDocInPatientList).GetHadeUniteDoc("810","1595")
ClassMethod GetHadeUniteDoc(DoctorID As %String, CTLOCID As %String) As %String
{
	s date=+$P($H,",",1)
 	s Str=""
	s SSUSRCareProvDR=DoctorID
    s CTMUChildsub=0  f  s CTMUChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub)) q:(CTMUChildsub="")||(Str'="")  d
    .s CTMUActiveFlag=$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",3)
    .q:CTMUActiveFlag'="Y"  //单元是激活状态
    .s DateFrom1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",4) //单元没有过期，有效状态
    .q:((date<DateFrom1)&&(DateFrom1'=0))
    .s DateTo1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",5)
    .q:(date>DateTo1)&&(DateTo1'=0)
    .s IsExist=0,LeaderDoctorDR=""
 	.s MUCPChildsub=0 f  s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  d
 	..s MUCPDoctorDR=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1) 
	..if (MUCPDoctorDR=SSUSRCareProvDR) s IsExist=1
	..s MUCPLeaderFlag=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",2) //取组长标志
	..s DateFrom2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",5)
	..q:((date<DateFrom2)&&(DateFrom2'=0)) //单元中的用户没有超出有效期
	..s DateTo2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",6)
	..q:((date>DateTo2)&&(DateTo2'=0))
	..if (MUCPLeaderFlag="Y") s LeaderDoctorDR=MUCPDoctorDR
	.i (IsExist=1)&&(LeaderDoctorDR'="") s Str=CTLOCID_"||"_CTMUChildsub_"^"_LeaderDoctorDR //_"^"_MUCPDoctorDR_"^"_SSUSRCareProvDR
	if (Str="") s Docdesc=DoctorID_"^"_$P($g(^CTPCP(DoctorID,1)),"^",1)_"^"_$P($g(^CTPCP(DoctorID,1)),"^",2)
	else  s Docdesc=$P(Str,"^",2)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",1)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",2)
	q Docdesc
}

/// Desc: 当前护理级别
/// Input: argItmMastDRStr 格式为 ^ItmMastDR1^ItmMastDR2^ItmMastDR3^...^
/// Example:     w ##Class(EPRservice.TestAndTools.EPRTest).CareClass(171380)
ClassMethod CareClass(argAdmId As %String, argItmMastDRStr As %String, argHospital As %String = "") As %String
{
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItmMastDRStr)=0)||(argItmMastDRStr="") ""

	s CareClass=""
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CareClass'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CareClass'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] 
	  .. q:($f(argItmMastDRStr,"^"_OEORIItmMastDR_"^")=0)
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CareClass=ARCIMDesc
	  
	q CareClass
}

/// Desc: 根据医生的CTPCPRowID取其主任医师
/// Input: CTPCPRowID 
/// Example: w ##Class(EMRservice.HISInterface.PatientInfoAssist).GetChiefDoc(180)
ClassMethod GetChiefDoc(CTPCPRowID As %String) As %String
{
	s ChiefUserID = ""
	s ChiefUserName = ""
	s AUserID = ""
	for 
	{
		s AUserID = $O(^SSU("SSUSR",0,"CTPCP",CTPCPRowID,AUserID))
		q:(AUserID = "")
		
		s PowerUserID = ""
		&sql(select ParRef into:PowerUserID from EMRmeta.ChildUsers where UserID = :AUserID)
		if (PowerUserID '= "")
		{
			s PowerUserObj = ##Class(EMRmeta.PowerUser).%OpenId(PowerUserID)
			continue:(PowerUserObj = "")
			s UserLevel = PowerUserObj.UserLevel
			if (UserLevel = "Chief")
			{
				s ChiefUserID = PowerUserObj.UserID
				s UserObj = ##class(User.SSUser).%OpenId(ChiefUserID)
				continue:(UserObj = "")
				s ChiefUserName = UserObj.SSUSRName
				do UserObj.%Close()
				s UserObj = ""
			}
			do PowerUserObj.%Close()
			s PowerUserObj = ""
		}
		
	}
	q ChiefUserID_"^"_ChiefUserName
}

/// Desc:	通过患者所在科室的RowID,取 CT_LocLinkLocation 科室与病区的对应关系
/// Input:	
/// Output:	
/// Others:	Table CT_LocLinkLocation / Global ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
/// Test:	d ##class(EMRservice.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(argDeptId)
ClassMethod CurDeptLinkLocByDept(argDeptId As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(argDeptId)=0)||(argDeptId="") ""

	//定义变量
	s CurrentDeptLinkLoc=""
	s CurrentDept="",CurrentDeptDR="",VarLocDR="",VarLocString=""
	s CurrentDeptDR=argDeptId

	//程序处理
	f  s VarLocDR=$o(^CTLOC(CurrentDeptDR,"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
	. s VarLocString=VarLocString_"^"_VarLocDR

	s CurrentDeptLinkLoc="^"_CurrentDeptDR_VarLocString_"^"

	q CurrentDeptLinkLoc
}

/// Desc:	出生日期【内部格式】
/// Others：not different from hospitals 
ClassMethod Birthday(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	s Birthday=""
	
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	s Birthday=$P($G(^PAPER(argPapmiDR,"ALL")),"^",6)
	
	q Birthday
}

/// Desc:	入院日期时间【Cache内部格式】
/// Table：	PA_Adm.PAADM_AdmDate，PA_Adm.PAADM_AdmTime
/// Output: date_","_time
ClassMethod AdmDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s admdatetime="",admdate="",admtime=""
	
	// not different from hospitals
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s admdate=$P($G(^PAADM(argAdmId)),"^",6)
	s admtime=$P($G(^PAADM(argAdmId)),"^",7)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetime=admdate_","_admtime
	}
	
	q admdatetime
}

/// Creator:	wangwentao
/// CreatDate:	20091211
/// Description:获取患者年龄
/// Table:		/
/// Input:		argAdmId:就诊号, argBirthday:出生日期, argAdmDate:入院日期, argMeddata:命名空间, argWebsrc:命名空间
/// 			argType:返回类型(1:TrakAge|2:RecordAge_"^"_RecordAgeUnit|3:BabyAge|4:ClinicAge),argCondition:临床区间条件默认14岁,argDetail:是否显示时分秒默认否
/// Output:		/
/// Others:				
/// Example:	w ##Class(EMRservice.HISInterface.PatientInfoAssist).Age(AdmId,Birthday,AdmDate,Meddata,Websrc,Type)
ClassMethod Age(argAdmId As %String, argBirthday As %String, argAdmDate As %String, argType As %String, argCondition As %String = "14", argDetail As %String = "N") As %String
{
	//入参检查
	q:(argBirthday>argAdmDate) ""
	
	//定义返回值
	s RetAge=""

	//定义变量
	s tmpAge=""
	
	// 取系统参数
  	s MEDDATA = ""
  	s SpaceHIS=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	q:(SpaceHIS = "") ""
	s MEDDATA = $p($g(SpaceHIS),"^",1)
	
	//获取HIS年龄信息
	s curSpace = $zu(5)
	d $zu(5,MEDDATA)
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	d $zu(5,curSpace)
	
	//b "s"
	q:(tmpAge="")&&($l(tmpAge,"|")'<14) "" 

	s PapmiDR = ..GetPapmiDR(argAdmId)
	s ClinicAge = ##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,argAdmId)
	//年龄类型处理
	//s RetAge=$CASE(argType,1:..GetTrakAge(tmpAge),2:..GetRecordAge(tmpAge),3:..GetBabyAge(tmpAge,argBirthday,argAdmDate),4:..GetClinicAge(tmpAge,argBirthday,argAdmDate,argCondition,argDetail))
	s RetAge=$CASE(argType,1:..GetTrakAge(tmpAge),2:..GetRecordAge(tmpAge),3:..GetBabyAge(tmpAge,argBirthday,argAdmDate),4:ClinicAge)
	
	q RetAge
}

/// Desc: 病案年龄 
/// Input: $$CalAge^at182的返回值
/// Output: 	age>1岁，返回：N_"^"_岁
/// 			age<1岁，返回：1^岁
/// Others: Belong to ClassMethod Age
ClassMethod GetRecordAge(tmpAge As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""

	//定义变量
	s RecordAge="",RecordAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{		
		//病案年龄(岁)
		s RecordAge=tmpAgeYear ,RecordAgeUnit="岁"
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{			
			//病案年龄(岁)
			s RecordAge=1 ,RecordAgeUnit="岁"
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			} 
			elseif (tmpAgeDay=0)
			{
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			}  
		}
	}
	else
	{
		q ""
	}
	s RecordAge=RecordAge_"^"_RecordAgeUnit
	
	q RecordAge
}

/// Desc: 	新生儿年龄 
/// Input:	tmpAge: $$CalAge^at182的返回值
/// 	 	argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// Output:  age>1岁，返回：空值
/// 			age<1岁，返回：N天
/// Others: Belong to ClassMethod Age
ClassMethod GetBabyAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""

	//定义变量
	s BabyAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		/*s BabyAge=(argAdmDate-argBirthday)
		
		//校验ClinicAge
		if BabyAge=0
		{
			s BabyAge=BabyAge+1
		}
		s BabyAge=BabyAge_"天"*/
		if (tmpAgeMonth>0)
		{			
			if (tmpAgeDay>0)
			{		
				//新生儿年龄(月 日/30)		
				s BabyAge=tmpAgeMonth_" "_tmpAgeDay_"/30"
			} 
			elseif (tmpAgeDay=0)
			{
				//新生儿年龄(月 日/30)
				s BabyAge=tmpAgeMonth
			} 
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//新生儿年龄(岁)
				s BabyAge=tmpAgeDay
			} 
			elseif (tmpAgeDay=0)
			{
				q ""
			}  
		}		
	}
	else
	{
		q ""
	}
	
	q BabyAge
}

/// Desc: 	临床年龄 / 自然年龄
/// Input：	tmpAge：$$CalAge^at182的返回值
/// 			argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// 	 	argCondition: 一般为14岁
/// 	 	argDetail：
/// Output： age>argCondition，返回：N岁 
/// 			1<=age<argCondition, 返回：N岁N月 
/// 			age<1岁，返回：N天
/// Others:	Belong to ClassMethod Age   
ClassMethod GetClinicAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String, argCondition As %String = "14", argDetail As %String = "N") As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""
	q:(argCondition<0)||(argCondition>200) ""

	//定义变量  argDetail  argCondition  argFormat
	s ClinicAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
			
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		if (tmpAgeYear<argCondition)
		{
		 	if (tmpAgeMonth'=0)
			{
				s ClinicAge=tmpAgeYear_"岁"_tmpAgeMonth_"月"
			}
			elseif (tmpAgeMonth=0)
			{
				s ClinicAge=tmpAgeYear_"岁"
			}
		}
		elseif (tmpAgeYear>=argCondition)
		{
			s ClinicAge=tmpAgeYear_"岁"
		}
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		s ClinicAge=(argAdmDate-argBirthday)
	
		//校验ClinicAge
		if ClinicAge=0
		{
			s ClinicAge=ClinicAge+1
		}
		s ClinicAge=ClinicAge_"天"
	}
	else
	{
		q ""
	}
	
	q ClinicAge
}

/// Desc: Trakcare年龄 
/// Intput：$$CalAge^at182的返回值
/// Output：	age>1岁，返回：N岁
/// 			1月<age<1岁，返回：N月 
/// 			age<1月，返回：N天
/// Others：Belong to ClassMethod Age
ClassMethod GetTrakAge(tmpAge As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	
	//定义变量
	s TrakAge="",TrakAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		//Trak年龄(N岁)
		s TrakAge=tmpAgeYear ,TrakAgeUnit="岁"
		s TrakAge=TrakAge_TrakAgeUnit
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{
			//Trak年龄(N月)
			s TrakAge=tmpAgeMonth ,TrakAgeUnit="月"
			s TrakAge=TrakAge_TrakAgeUnit
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{
				//Trak年龄(N日)
				s TrakAge=tmpAgeDay ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			} 
			elseif (tmpAgeDay=0)
			{
				//Trak年龄(N日)
				s TrakAge=1 ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			}  
		}
	}
	else
	{
		q ""
	}
	
	q TrakAge
}

/// d ##Class(EMRservice.DAL.GetPaAdmDetail).GetCriticallyOrdObjs()
ClassMethod GetCriticallyOrdObjs()
{
	//12110||1^病危#12111||1^病重
	s CriticallyOrdRowIDStr = ##Class(EMRservice.BOSysOption).GetValueByName("CriticallyOrdRowIDStr")
	
	s SysOptionStream = ##class(%FileCharacterStream).%New()
	d SysOptionStream.Write(CriticallyOrdRowIDStr)
	
	s listObj = ##Class(%ListOfObjects).%New()
	s CriticallyOrdList = ##Class(EMRservice.Obj.CriticallyOrdInfo).%New()
	
	S reader = ##class(%XML.Reader).%New()
	S sc=reader.OpenStream(SysOptionStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("CriticallyOrdInfo","EMRservice.Obj.CriticallyOrdInfo")
	
	Set Count=0
	While reader.Next(.CriticallyOrdList,.sc) {
		
	    s Count=Count+1
	    d listObj.Insert(CriticallyOrdList)
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	//Write Count_"数量"
	q listObj
}

/// d ##Class(EMRservice.DAL.GetPaAdmDetail).GetCareOrdArcimRowIDStrs()
ClassMethod GetCareOrdArcimRowIDStrs()
{
 	s CareOrdArcimRowIDStr = ##Class(EMRservice.BOSysOption).GetValueByName("CareOrdArcimRowIDStr")
 	
 	s SysOptionStream = ##class(%FileCharacterStream).%New()
	d SysOptionStream.Write(CareOrdArcimRowIDStr)
	
	s listObj = ##Class(%ListOfObjects).%New()
	s CareOrdArcimList = ##Class(EMRservice.Obj.CareOrdArcimInfo).%New()
	
	S reader = ##class(%XML.Reader).%New()
	S sc=reader.OpenStream(SysOptionStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Item","EMRservice.Obj.CareOrdArcimInfo")
	
	s RowIDStrs = "^"
	Set Count=0
	While reader.Next(.CareOrdArcimList,.sc) {
		
	    s Count=Count+1
	    d listObj.Insert(CareOrdArcimList)
	    s RowIDStrs = RowIDStrs_CareOrdArcimList.OrdRowID_"^"
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	//Write Count_"数量"
	q RowIDStrs
}

/// d ##Class(EMRservice.DAL.GetPaAdmDetail).GetTemplateInfo()
ClassMethod GetTemplateInfo(ATemplateCode As %String)
{
 	s PatListTemplateIDStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PatListTemplateIDStr")
 	
 	s SysOptionStream = ##class(%FileCharacterStream).%New()
	d SysOptionStream.Write(PatListTemplateIDStr)
	
	s listObj = ##Class(%ListOfObjects).%New()
	s TemplateList = ##Class(EMRservice.Obj.TemplateInfo).%New()
	
	S reader = ##class(%XML.Reader).%New()
	S sc=reader.OpenStream(SysOptionStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Type","EMRservice.Obj.TemplateInfo")
	
	s TempStr = ""
	Set Count=0
	While reader.Next(.TemplateList,.sc) {
		
	    s Count=Count+1
	    d listObj.Insert(TemplateList)
	    if (TemplateList.Template.Code = ATemplateCode)
	    {
		    if (TempStr '= "")
		    {
		    	s TempStr = TempStr_"%"
		    }
		    s TempStr = TempStr_TemplateList.Template.ID
		    if (TemplateList.Template.TitleCode '= "null")
		    {
			    s TempStr = TempStr_"^"_TemplateList.Template.TitleCode
			}
		}
	    
	    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) q  
	//Write TempStr
	q TempStr
}

/// Desc:     取主管医师为AdmDocCode的所有就诊状态不是C的患者就诊号
/// creator:  yn
/// Input: 
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetPAADMIDByDocID","95")
Query GetPAADMIDByDocID(AdmDocCode As %String) As %SQLQuery
{
	SELECT PAADM_RowID As ID FROM SQLUser.PA_Adm WHERE PAADM_AdmDocCodeDR = :AdmDocCode and PAADM_VisitStatus <> "C"
}

/// Desc:     取患者列表
/// creator:  Candy
/// Input: 
///           ALocID 科室
///           AIsArrivedQue 是否到达
/// Debug:    d ##class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetPaAdmList","95,off,,,2020-01-08,2020-02-10,,,,,95,all,,,,,10209,,")
Query GetPaAdmList(Aparam As %String) As %Query(ROWSPEC = "mradm:%String,PAPMIDR:%String,PAPMINO:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,IDCard:%String,CFCardNo:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmAdmDate:%String,PAAdmAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,PAAdmWard:%String,Diagnosis:%String,PAADMReason:%String,PAADMBedNO:%String,PADischgeDate:%String,PADischgeTime:%String,Warddesc:%String,PatIllness:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Aparam As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s ALocID = $p(Aparam,",",1),AIsArrivedQue = $p(Aparam,",",2), APAPMINo = $p(Aparam,",",3),AMedicareNo=$p(Aparam,",",4)
	s Stdate = $p(Aparam,",",5),Enddate = $p(Aparam,",",6),APAPMIName = $p(Aparam,",",7),ACFCardNo = $p(Aparam,",",8)
	s APAAdmType = $p(Aparam,",",9),AIDCard = $p(Aparam,",",10),AexpectedLocID = $p(Aparam,",",11)
	s APAAdmStatus = $p(Aparam,",",12),AMedicalInsuranceNo = $p(Aparam,",",13),OutStdate = $p(Aparam,",",14)
	s OutEnddate = $p(Aparam,",",15),WardId = $p(Aparam,",",16),UserId = $p(Aparam,",",17),AMRN = $p(Aparam,",",18),ADiagnosis = $p(Aparam,",",19),nurUserId = $p(Aparam,",",20)
	s Illness = $p(Aparam,",",21)
	s HospitalName = ##Class(EMRservice.BOSysOption).GetValueByName("HospitalName")
	
	s sysStdate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",Stdate)
	s sysEnddate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",Enddate)
	s sysOutStdate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutStdate)
	s sysOutEnddate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",OutEnddate)
	
	
	if (APAPMINo '= "")
	{
		s PAPMIDR = ""
		for
		{
			s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",APAPMINo,PAPMIDR))
			q:(PAPMIDR = "")
			d GetPAADMRowID
			
		}
	}
	elseif (AMedicareNo '= "")
	{
		s PAPMIDR = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(AMedicareNo)
		q:(PAPMIDR = "") $$$OK
		d GetPAADMRowID

	}
	elseif (ACFCardNo '= "")
	{
		//按健康卡号和就诊类型查询    add by lina 2014-11-26
		s CFRowId = $o(^DHCCARDi("CF",0,"CardNo",ACFCardNo,""))
		s PAPMIDR = $p($g(^DHCCARD("CF",CFRowId)),"^",4)
		d GetPAADMRowID
	}
	elseif (AMedicalInsuranceNo '= "")
	{
		//按医保号查询
		s PapmiDRStr = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDRByInsuranceNo(AMedicalInsuranceNo,HospitalName)
		s count = $l(PapmiDRStr,"^")
		for i=1:1:$l(PapmiDRStr,"^")
		{
			s PAPMIDR = $p(PapmiDRStr,"^",i)
			d GetPAADMRowID
		}
	}
	elseif (AIDCard '= "")
	{
		// "按身份证号查询",!
		s PAPMIDR = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard(AIDCard)
		if (PAPMIDR '= "") d GetPAADMRowID
	}
	elseif (APAPMIName '= "")
	{	
		s PAPMIDR=""
		s strPaName =""
		//w "按姓名和就诊类型查询",! (修改为模糊查询 by yejian)
		for {
			//s PAPMIDR = $o(^PAPERi("PAPER_PatName",$zcvt(APAPMIName,"u"),PAPMIDR))
			s strPaName = $o(^PAPERi("PAPER_PatName",strPaName))
			q:(strPaName="")
			continue:((strPaName [ $zcvt($zstrip(APAPMIName,"*p"),"u"))=0)
			s PAPMIDR=""
			for {
				s PAPMIDR = $o(^PAPERi("PAPER_PatName",strPaName,PAPMIDR))
				q:(PAPMIDR = "")
				d GetPAADMRowID	
			}
		}
	}
	elseif (AMRN '= "")
	{	
		//w "按MRN查询",!
		s PatStr = ##class(web.DHCOPAdmApp).GetPatientByMRN(AMRN)
		s PAPMIDR = $p(PatStr,"^",5)
		if (PAPMIDR '= "") 
		{
			d GetPAADMRowID
		}
	}
	elseif (sysStdate '= "")&(sysEnddate '= "")
	{
		for AdmDate = sysStdate:1:sysEnddate 
		{
			s PAADMRowID = ""
			if (APAAdmType '=  "") 
			{
				//w "按时间段和就诊类型查询",!
				for {
					s PAADMRowID = $o(^PAADMi("NNType",APAAdmType,AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
			else
			{
				//w "按时间段查询",!
				for {	
					s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",AdmDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
		}	
	}
	elseif (sysOutStdate '= "")&&(sysOutEnddate '= "")
	{
		for DischgDate = sysOutStdate:1:sysOutEnddate 
		{
			s PAADMRowID = ""
			if (APAAdmType '=  "") 
			{
				//w "按时间段和就诊类型查询",!
				for {
					s PAADMRowID = $o(^PAADMi("DisDateT",APAAdmType,DischgDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
			else
			{
				//w "按时间段查询",!
				for {	
					s PAADMRowID = $o(^PAADMi("DischDate",DischgDate,PAADMRowID))
					q:(PAADMRowID = "")
					d outputrow
				}
			}
		}			
	}
	elseif (WardId '= "")
	{
		s tmpWardId = WardId ;$o(^PAWARD(0,"WARD_LocationDR",WardId,""))
		s room = ""
		for
		{
			s room = $o(^PAADMi("CurrWard",tmpWardId,room))
			q:(room = "")
			s PAADMRowID = ""
			for
			{
				s PAADMRowID = $o(^PAADMi("CurrWard",tmpWardId,room,PAADMRowID))
				q:(PAADMRowID = "")
				d outputrow
			}
		}
	}
	elseif (AexpectedLocID '= "")||(AIsArrivedQue = "on")
	{
		s locID = $case(AIsArrivedQue,"on":ALocID,:AexpectedLocID)		
		if (locID = ""){
			if (UserId'=""){
				s DocId = $p($g(^SSU("SSUSR",UserId)),"^",14)
				s rset = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetPAADMIDByDocID")
				s sc = rset.Execute(DocId)				
				while (rset.Next())
				{
					s PAADMRowID = rset.Data("ID")
					continue:PAADMRowID=""
					s mCurrRow = $g(^PAADM(PAADMRowID))
					s ALocID = $p($g(mCurrRow),"^",9)
					d outputrow					
					}				
			}else{
			for{
				s locID = $O(^PAADMi("CurrLoc",locID))
				q:(locID)=""
				s ALocID = locID
				s AdmDate = ""
				for
				{
					s AdmDate = $o(^PAADMi("CurrLoc",locID,AdmDate))
					q:(AdmDate = "")
					s AdmTime = ""
					for
					{
						s AdmTime = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime))
						q:(AdmTime = "")
						s PAADMRowID = ""
							for
							{
								s PAADMRowID = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime,PAADMRowID))
								q:(PAADMRowID = "")
								d outputrow
							}
						}
					}
				}				
			}
		}else{
			s AdmDate = ""
			for
			{
				s AdmDate = $o(^PAADMi("CurrLoc",locID,AdmDate))
				q:(AdmDate = "")
				s AdmTime = ""
				for
				{
					s AdmTime = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime))
					q:(AdmTime = "")
					s PAADMRowID = ""
					for
					{
						s PAADMRowID = $o(^PAADMi("CurrLoc",locID,AdmDate,AdmTime,PAADMRowID))
						q:(PAADMRowID = "")
						d outputrow
					}
				}
			}
		}
	}elseif((AIsArrivedQue = "chkGroup")&&(AexpectedLocID="")){
		//本医疗组的查询
		s CTLOCType = $p($g(^CTLOC(ALocID)),"^",13)
		if (CTLOCType="W") {
			s locIDStr = ..CurDeptLinkLocByDept(ALocID)
			s locIDCount = $L(locIDStr,"^")
			for i=3:1:locIDCount-1
			{
				s locID = $p(locIDStr,"^",i)
				d currentLocOut
			}
		}
		else
		{
			s locID = ALocID
			d currentLocOut
		}
	}
	elseif((AIsArrivedQue = "off")&&(UserId'=""))
	{
		s locID = ALocID
		d currentLocOut	
	}
	Quit $$$OK
currentLocOut
	s Date=""
	for {
		s Date = $O(^PAADMi("AdmTypeCurrLoc","I",locID,Date))
		q:(Date="")
		
		s Time=""
		for {
			s Time=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time))
			q:(Time="")
			
			s PAADMRowID=""
			for {
				s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time,PAADMRowID))
				q:(PAADMRowID="")
				//修正本单元判定 modify by lifb 20170828
				//s isOK = ..CheckCTLocMedUnit(PAADMRowID,DocId,locID)
				s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
				s DocId=$p($g(^SSU("SSUSR",UserId)),"^",14)
				s isOK = ..CheckCTLocMedUnit(PatDoc,DocId,locID)
				continue:(isOK '=1)

				d outputrow
			}
		}
	}
	Quit
GetPAADMRowID
	s PAADMRowID = ""
	if (APAAdmType'="")
	{
    	for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
		d outputrow
		}
	}
	else
	{
		s APAAdmType = ""
		for {
		s APAAdmType = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType))
		q:(APAAdmType ="")
		continue:((APAAdmType '="O")&&(APAAdmType '="E")&&(APAAdmType '="I"))
		s PAADMRowID=""
		for {
				s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType,PAADMRowID))
				q:(PAADMRowID = "")
				d outputrow
			}
		}
	}
	Quit
outputrow
    //过滤掉已退号的就诊信息
    s VisitStatus = $p($g(^PAADM(PAADMRowID)),"^",20)
    q:(VisitStatus = "C")
    
	s mCurrRow = $g(^PAADM(PAADMRowID))	
	s TmpPAAdmTypeDR = $p($g(mCurrRow),"^",2)
	//只查询门诊，急诊和住院
	q:((TmpPAAdmTypeDR'="O")&&(TmpPAAdmTypeDR'="E")&&(TmpPAAdmTypeDR'="I"))
	s TmpPAAdmType = $case(TmpPAAdmTypeDR,"O":"门诊","E":"急诊","I":"住院","H":"体检")
	q:((APAAdmType '= "")&&(APAAdmType '= "all")&&(TmpPAAdmTypeDR '= APAAdmType))
	
	s DischgDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(PAADMRowID,HospitalName)
	s PADischgeDate =  $p(DischgDateTime,",",1)  //$P($g(^PAADM(PAADMRowID)),"^",17)
	q:((APAAdmStatus = "A")&&(PADischgeDate '= ""))
	q:((APAAdmStatus = "D")&&(PADischgeDate = ""))	
	q:((sysOutStdate '= "")&&(sysOutEnddate '="")&&((PADischgeDate>sysOutEnddate)||(PADischgeDate<sysOutStdate)))	
    //院区共库判断
	s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
	if (hospitalId '= "")
	{
		s showShareHospital= ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
		//根据就诊号取患者所在的科室ID
		s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(PAADMRowID)
	 	s currentDeptId = $P(currentDept,"^",1)
	 	s locHospitalId = $p($g(^CTLOC(currentDeptId)),"^",22)
	 	q:((locHospitalId '= hospitalId)&&(showShareHospital="N"))
	}
	s PatIllness=..GetStateForDisPat(PAADMRowID)
	q:((Illness'="")&&(PatIllness=""))
	q:(Illness'[PatIllness)&&(Illness'="")
	s PatIllness=$case(PatIllness,"C":"病危","S":"病重","D":"死亡",:"")
 
	
	s mradm = $p(^PAADM(PAADMRowID),"^",61)
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	//健康卡号
	s CFCardNo = ""   
	s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""))
	s:(CFRowId '= "") CFCardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    q:((ACFCardNo '= "")&&(CFCardNo '= ACFCardNo))
	s IDCard = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
	q:((AIDCard '= "")&&(IDCard '= AIDCard))
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	//q:((APAPMIName '= "")&&(PAPMIName '= APAPMIName))
	s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
	q:((APAPMINo '= "")&&(PAPMINO '= APAPMINo))
	
    s MedicareNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(PAADMRowID)
	q:((AMedicareNo '= "")&&(MedicareNo '= AMedicareNo))
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	//性别翻译
	s PAPMISex = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTSex","CTSEXDesc",PAPMISex)
	

	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	s:(PAPMIDOB '= "") PAPMIDOB = $zd(PAPMIDOB,3)
	
	//就诊时间
	s PAAdmDiagDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).GetDiagAdmDate(PAADMRowID)
	s PAAdmDate = $p(PAAdmDiagDateTime,",",1) 
	q:((sysStdate '= "")&&(sysEnddate '="")&&((PAAdmDate>sysEnddate)||(PAAdmDate<sysStdate)))	
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
		s PAAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	}
	s PAAdmTime = $p(PAAdmDiagDateTime,",",2)  //$p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
		s PAAdmTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	}
	
	//入院时间
	s PAAdmAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).GetAdmDate(PAADMRowID)
	s PAAdmAdmDate = $p(PAAdmAdmDateTime,",",1)
	if (PAAdmAdmDate '= "")
	{
		s PAAdmAdmDate = $zd(PAAdmAdmDate,3)
		s PAAdmAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmAdmDate)
	}
	s PAAdmAdmTime = $p(PAAdmAdmDateTime,",",2)
	if (PAAdmAdmTime '= "")
	{
		s PAAdmAdmTime = $zt(PAAdmAdmTime,3)
		s PAAdmAdmTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmAdmTime)
	}
	
	
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
		s PADischgeDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
	}
	s PADischgeTime = $p(DischgDateTime,",",2) //$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
		s PADischgeTime= ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PADischgeTime)
	}
	s PAADMReasonDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	s PAADMReason = "无"
	s:(PAADMReasonDR '= "") PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	s PAADMDepCode = $p($g(mCurrRow),"^",4)
	if ((PAADMDepCode '="")&&(AexpectedLocID '=""))
	{
		q:(PAADMDepCode '= AexpectedLocID)
	}	
	s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	s PAAdmDepCodeDR = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTLoc","CTLOCDesc",PAAdmDepCodeDR)
	
	q:((AIsArrivedQue = "on")&&(ALocID'="")&&(PAADMDepCode '= ALocID))	
	q:(((AIsArrivedQue = "off") && (AexpectedLocID '= ""))&&(PAADMDepCode '= AexpectedLocID))
	s PAADMDocCode = $p($g(mCurrRow),"^",9)
	s DocId = ""
	//s UserId = ""
	//s:(UserId '= "") UserId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"),""))
	s:(UserId'="") DocId = $p($g(^SSU("SSUSR",UserId)),"^",14)
	q:((DocId '= "")&&(PAADMDocCode '= DocId)&&(AIsArrivedQue '="chkGroup"))
	
    if (nurUserId'=""){
        s mainNurseId = ""
        s admNurse = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmNurse(PAADMRowID,HospitalName)  //根据就诊号取患者的管床护士
        s admNurseRowId = $p(admNurse,"^",1)
        s:(admNurseRowId'="") mainNurseId = $O(^SSU("SSUSR",0,"CTPCP",admNurseRowId,""))
        q:(mainNurseId '= nurUserId)
    }
	s PAAdmDocCodeDR = "无"
	s:(PAADMDocCode '= "") PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	s PAADMBedDR = $p($g(^PAADM(PAADMRowID)),"^",73)
	if (PAADMBedDR '= "")
	{
		s WARDRowID = $p(PAADMBedDR,"||",1)
		s BEDChildsub = $p(PAADMBedDR,"||",2)
		s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
		s PAAdmWard = $p($g(^PAROOM(BEDRoomDR)),"^",2)
		s PAADMBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
	}
	else
	{
		s PAAdmWard = "无"
		s PAADMBedNO = "无"
	}
	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (WardId '= "")
	{
		//^PAWARD(0,"WARD_LocationDR") 这个索引数据结构是 依据CTLoc表ID获取PACWard表ID
		//现有代码传入wardId数据来源为PacWard，通常不需要通过索引转换。
		//考虑数据ID重复问题，依据实际情况项目情况使用。
		
		//有关联数据的病区过滤代码
		//s tmpwarddr = $o(^PAWARD(0,"WARD_LocationDR",WardId,""))
	    //q:(disWardDR '= tmpwarddr)
	    //无关联数据的病区过滤代码
	    q:(disWardDR '= WardId)
	}
	
	if (disWardDR '= "")
	{
		s Wardcode =$p($g(^PAWARD(disWardDR)),"^",1)
		s Warddesc =$p($g(^PAWARD(disWardDR)),"^",2) 
		//翻译病区
		s Warddesc = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.PACWard","WARDDesc",Warddesc)
		
	}
	else
	{
		s Wardcode = "无"
		s Warddesc = "无"
	}
	s Diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(PAADMRowID)
	if (Diagnosis '= "")
	{	
		//处理多个诊断显示第一个
		s Diagnosis = $p(Diagnosis,"$",1)
		
		s Diagnosis = $P(Diagnosis,"^",3)
		s Diagnosis = $tr(Diagnosis,"'","\'")
	}
	else
	{
		s Diagnosis = "无"
	}
	q:((ADiagnosis '="")&&(Diagnosis'[ADiagnosis))
	set ^CacheTemp(repid,ind) = $LB(mradm,PAPMIDR,PAPMINO,MedicareNo,PAADMRowID,PAPMIName,IDCard,CFCardNo,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmAdmDate,PAAdmAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,TmpPAAdmType,PAAdmWard,Diagnosis,PAADMReason,PAADMBedNO,PADischgeDate,PADischgeTime,Warddesc,PatIllness)
	set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据就诊指针和模板ID信息，判断本次就诊的某个病历模板是否写过
/// InPut: AEpisodeID:就诊指针; ATemplateIDStr: (唯一模板:模板ID)、(二版病历可重复模板：模板ID或模板ID^标题描述)、(三版病历可重复模板：模板ID或模板ID^标题Code)
/// OutPut: 1:写过 ; 0:未写过
/// 给医政组写的接口方法;
/// w ##Class(EMRservice.DAL.GetPaAdmDetail).IsWritedTemplate("53","20^1")
ClassMethod IsWritedTemplate(AEpisodeID As %String, ATemplateIDStr As %String)
{
	//根据episodeID判断该患者写的是二版病历还是三版病历
	s DHCEMR = 0
	s EPRCategoryID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,""))
	if (EPRCategoryID = "") //没有二版病历数据
	{
		s EMRChartItemID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ""))
		if (EMRChartItemID '= "") //有三版病历数据
		{
			s DHCEMR = 1
		}
		else  //既没有二版数据也没有三版数据，患者未写病历，需判断当前系统是否有三版病历环境，有则去写三版病历，没有则写二版病历；
		{
			s SysOptionData = $g(^DHCEMRM.SysOptionD)   //判断三版系统参数数据，来确定是否有三版病历环境
			if (SysOptionData > 0)   //有三版系统参数数据，说明有三版病历环境，至于部分科室是三版病历，部分科室是二版病历，有需要再进一步判断患者所在科室；
			{
				s DHCEMR = 1
			}
		}
	}
	
	//初始化输出标记
	s Flag = 0
	
	//三版病历患者
	if (DHCEMR = 1)
	{
		s HappenDate = 0
		for
		{
			s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HappenDate))
			q:(HappenDate = "")
		
			s HappenTime = ""
			for
			{
				s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HappenDate,HappenTime))
				q:(HappenTime = "")
			
				s TheECRecord = ""
				for
				{
					s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord))
					q:(TheECRecord = "")
				
					s ListNo = ""
					for
					{
						s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
						q:(ListNo = "")
					
						s InstanceDataID = TheECRecord_"||"_ListNo
						s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
						s TemplateID = InstanceObj.RealTemplateID
					
						continue:(TemplateID '= $p(ATemplateIDStr,"^",1))
						if ($p(ATemplateIDStr,"^",2) '= "")
						{
							continue:(InstanceObj.TitleCode '= $p(ATemplateIDStr,"^",2))
						}
					
						s Flag = 1
					
						do InstanceObj.%Close()
						s InstanceObj = ""
					}
				}
			}
		}
	}
	//二版病历患者
	else
	{
		s ChartItemID = ""
		for 
		{
			s ChartItemID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ChartItemID))
			q:(ChartItemID = "")
			
			s length = $L(ChartItemID)
			s TemplateID = $E(ChartItemID,4,length)
			
			continue:(TemplateID '= $p(ATemplateIDStr,"^",1))
			if ($p(ATemplateIDStr,"^",2) '= "")
			{
				s ECRecordID = ""
				for
				{
					s ECRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ChartItemID,ECRecordID))
					q:(ECRecordID="")
					
					s SubID = ""
					for
					{
						s SubID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,SubID))
						q:(SubID="")
						
						s InstanceDataID = ECRecordID_"||"_SubID
						s InstanceQObj = ##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
						
						continue:(InstanceQObj.Title '= $p(ATemplateIDStr,"^",2))
						
						s Flag = 1
						
						do InstanceObj.%Close()
						s InstanceObj = ""
					}
				}
			}
			else
			{
				s Flag = 1
			}
		}
		
	}
	q Flag
}

/// Desc:	通过科室查询用户列表
/// 来自EPRservice.Quality.DataGather.SSUser:GetUserDataList
/// Move by：Lina
/// modify by: niucaicai 2016-10-14
/// Input:	ALocID--科室查询
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.DAL.GetPaAdmDetail","GetUserDataList","","1")
Query GetUserDataList(AUserName As %String, ALocID As %String) As %Query(ROWSPEC = "ProvID:%String,UserID:%String,UserCode:%String,UserDesc:%String,Location:%String")
{
}

ClassMethod GetUserDataListExecute(ByRef qHandle As %Binary, AUserName As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s UserName = $$ALPHAUP^SSUTIL4(AUserName)
	s LocID = $g(ALocID)
	q:(LocID = "") $$$OK
	
	s CTLOCType = $p($g(^CTLOC(ALocID)),"^",13)
	if (CTLOCType="W") 
	{
		s locIDStr = ..CurDeptLinkLocByDept(ALocID)
		s locIDCount = $L(locIDStr,"^")
		for i=3:1:locIDCount-1
		{
			s LocID = $p(locIDStr,"^",i)
			d currentLocOut
		}
	}
	else
	{
		d currentLocOut
	}
	q $$$OK
	
currentLocOut
	s RowID = 0
	for {
		s RowID = $o(^RB("RES",0,"CTLOC",LocID,RowID)) 
		q:(RowID = "")
		s CareProvID = $p(^RB("RES",RowID),"^",2)
		continue:(CareProvID = "")
		continue:($d(^CTPCP(CareProvID)) = 0)
		s userId = $o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
		s CareProvCode = $p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc = $p($g(^CTPCP(+CareProvID,1)),"^",2)
    	s CareProvOtherName = $p($g(^CTPCP(+CareProvID,3)),"^",28)
    	continue:(UserName '= "")&&(( CareProvDesc '[ UserName)&&( $zcvt(CareProvOtherName,"U") '[ $zcvt(UserName,"U")))
		s Location = $p(^CTLOC(LocID),"^",2)
		s:(Location [ "-") Location = $p(Location,"-",2)
    	s Data = $lb(CareProvID,userId,CareProvCode,CareProvDesc,Location)
    	s ^CacheTemp(repid,ind) = Data
    	s ind = ind+1
	}
	q $$$OK
}

ClassMethod GetUserDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetUserDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetStateForDisPat(AdmId As %String) As %String
{
	s Checked=""
	s PatId=$p(^PAADM(AdmId),"^",1)
	s DeathFlag=$p($g(^PAPER(PatId,"ALL")),"^",12)
	if DeathFlag="Y" {
		q "D"
	}
 	
 	s CIllCode=##class(Nur.ImageSet).GetArcCode("CRITICALLY")
 	s SIllCode=##class(Nur.ImageSet).GetArcCode("SERIOUSLY")
 	s CIllArcimID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(CIllCode),""))_"||1"
 	s SIllArcimID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(SIllCode),""))_"||1"
 	s HasCIll=0, HasSIll=0
	s oeord=$o(^OEORD(0,"Adm",AdmId,""))
	q:oeord="" Checked
	s OEORISttDat="" 
	f  s OEORISttDat=$o(^OEORDi(0,"ARCIM",+oeord,CIllArcimID,OEORISttDat),-1) q:(OEORISttDat="")!(HasCIll=1)  d
	.s oeordSub="" f  s oeordSub=$o(^OEORDi(0,"ARCIM",+oeord,CIllArcimID,OEORISttDat,oeordSub),-1) q:(oeordSub="")!(HasCIll=1)  d
	..s ordStatId=$p(^OEORD(+oeord,"I",oeordSub,1),"^",13)
	..s ordStat=$p($g(^OEC("OSTAT",ordStatId)),"^",1)
	..q:(ordStat="U")!(ordStat="C")
	..s HasCIll=1
	if HasCIll=1 {
		q "C"
	}
	
	s OEORISttDat="" 
	f  s OEORISttDat=$o(^OEORDi(0,"ARCIM",+oeord,SIllArcimID,OEORISttDat),-1) q:(OEORISttDat="")!(HasSIll=1)  d
	.s oeordSub="" f  s oeordSub=$o(^OEORDi(0,"ARCIM",+oeord,SIllArcimID,OEORISttDat,oeordSub),-1) q:(oeordSub="")!(HasSIll=1)  d
	..s ordStatId=$p(^OEORD(+oeord,"I",oeordSub,1),"^",13)
	..s ordStat=$p($g(^OEC("OSTAT",ordStatId)),"^",1)
	..q:(ordStat="U")!(ordStat="C")
	..s HasSIll=1
	if HasSIll=1 {
		q "S"
	}
 	q Checked
}

}
