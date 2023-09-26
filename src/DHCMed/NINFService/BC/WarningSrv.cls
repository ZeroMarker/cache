/// 名称:DHCMed.NINFService.BC.WarningSrv
/// 描述: 暴发预警
/// 编写者：zhufei
/// 编写日期: 2013-12-28
Class DHCMed.NINFService.BC.WarningSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-12-06
/// Description:  查询暴发预警列表
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.WarningSrv","QryWarningCnt","INFWARN","2016-04-19","")
Query QryWarningCnt(aConfigCode As %String, aWarningDate As %String, aHospID As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,LocType:%String,LocGroup:%String,DataValue:%String,Day1:%String,Day2:%String,Day3:%String,Day4:%String,Day5:%String,Day6:%String,Day7:%String,Cnt3:%String,Cnt7:%String")
{
}

ClassMethod QryWarningCntExecute(ByRef qHandle As %Binary, aConfigCode As %String, aWarningDate As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aConfigCode="")||(aWarningDate="") $$$OK
 	;Set:aWarningDate["-" aWarningDate=$zdh(aWarningDate,3)
 	Set:aWarningDate'="" aWarningDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aWarningDate)
 	Set:aWarningDate>+$h aWarningDate=+$h
 	Set aDateTo=aWarningDate
 	Set aDateFrom=aDateTo-6
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Kill arrLocWarningCnt
 	Set xDate=aDateFrom-1
 	For {
	 	Set xDate=$o(^DHCMed.NINF.BC.WarningI("IndexSubjectDate",aConfigCode,xDate))
	 	Quit:xDate=""
	 	Quit:xDate>aDateTo
	 	
	 	Set xWarningID=""
	 	For {
		 	Set xWarningID=$o(^DHCMed.NINF.BC.WarningI("IndexSubjectDate",aConfigCode,xDate,xWarningID))
		 	Quit:xWarningID=""
		 	
		 	Set objWarning=##class(DHCMed.NINF.BC.Warning).GetObjById(xWarningID)
		 	Continue:'$IsObject(objWarning)
		 	Set IsActive=objWarning.WAIsActive
	 		Continue:IsActive'=1
	 		
		 	Set EpisodeID=objWarning.WAEpisodeID
		 	Continue:EpisodeID=""
		 	Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
		 	
			//判断医院(集团化医院)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				Continue:flg<1
			}
			
			Set WAKeyWord=objWarning.WAKeyWord
			Set:WAKeyWord["同种同源" WAKeyWord=WAKeyWord_":"_objWarning.WADataValue
			Set DataValue=WAKeyWord
			Continue:DataValue=""
		 	Set ActDept=objWarning.WAActDept
		 	Set ActWard=objWarning.WAActWard
		 	Set ActDept=+ActDept
		 	Set ActWard=+ActWard
		 	
		 	If (aDateTo-xDate)=6 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day1",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day1"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day1",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=5 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day2",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day2"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day2",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=4 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day3",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day3"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day3",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=3 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day4",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day4"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day4",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=2 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day5",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day5"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day5",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=1 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day6",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day6"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day6",EpisodeID)=xWarningID
		 	}
		 	If (aDateTo-xDate)=0 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Day7",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Day7"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Day7",EpisodeID)=xWarningID
		 	}
		 	If (aDateTo-xDate)<3 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Cnt3",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Cnt3"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Cnt3",EpisodeID,xWarningID)=""
			}
			If (aDateTo-xDate)<7 {
		 		if '$d(arrLocWarningCnt(DataValue,ActDept,"Cnt7",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActDept,"Cnt7"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActDept,"Cnt7",EpisodeID,xWarningID)=""
			}
		 	
		 	If (aDateTo-xDate)=6 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day1",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day1"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day1",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=5 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day2",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day2"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day2",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=4 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day3",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day3"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day3",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=3 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day4",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day4"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day4",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=2 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day5",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day5"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day5",EpisodeID,xWarningID)=""
		 	}
		 	If (aDateTo-xDate)=1 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day6",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day6"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day6",EpisodeID)=xWarningID
		 	}
		 	If (aDateTo-xDate)=0 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Day7",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Day7"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Day7",EpisodeID)=xWarningID
		 	}
		 	If (aDateTo-xDate)<3 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Cnt3",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Cnt3"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Cnt3",EpisodeID,xWarningID)=""
			}
			If (aDateTo-xDate)<7 {
		 		if '$d(arrLocWarningCnt(DataValue,ActWard,"Cnt7",EpisodeID)) {
		 			Set num=$i(arrLocWarningCnt(DataValue,ActWard,"Cnt7"))
			 	}
		 		Set arrLocWarningCnt(DataValue,ActWard,"Cnt7",EpisodeID,xWarningID)=""
			}
	 	}
	}
	
	Set xDataValue=""
	For {
		Set xDataValue=$o(arrLocWarningCnt(xDataValue))
		Quit:xDataValue=""
		
		Set xActLoc=""
		For {
			Set xActLoc=$o(arrLocWarningCnt(xDataValue,xActLoc))
			Quit:xActLoc=""
			
			Set ActLocDesc=$p($g(^CTLOC(xActLoc)),"^",2)
			Set:$p(ActLocDesc,"-",2)'="" ActLocDesc=$p(ActLocDesc,"-",2)
			Set ActLocType=$p($g(^CTLOC(xActLoc)),"^",13)
			
			Set LocGroup=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID(ActLocType,xActLoc)
			
			Set Day1=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day1"))
			Set Day2=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day2"))
			Set Day3=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day3"))
			Set Day4=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day4"))
			Set Day5=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day5"))
			Set Day6=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day6"))
			Set Day7=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Day7"))
			Set Cnt3=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Cnt3"))
			Set Cnt7=+$g(arrLocWarningCnt(xDataValue,xActLoc,"Cnt7"))
			Continue:Cnt7<3
			Set Data=$lb(xActLoc,ActLocDesc,ActLocType,LocGroup,xDataValue,Day1,Day2,Day3,Day4,Day5,Day6,Day7,Cnt3,Cnt7)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill arrLocWarningCnt
 	
	Quit $$$OK
}

ClassMethod QryWarningCntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarningCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarningCntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarningCntExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2014-01-03
/// Description:  查询暴发预警明细列表
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.WarningSrv","QryWarningDtl","INFWARN","2013-11-02",2,"Day6",20,"大便次数>3次")
Query QryWarningDtl(aConfigCode As %String, aWarningDate As %String, aHospID As %String, aDayCode As %String, aLocID As %String, aDataValue As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,CtrlDtl:%String,RegNo:%String,PatName:%String,MrNo:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,LocID:%String,LocDesc:%String,LocGrp:%String,WardID:%String,WardDesc:%String,WardGrp:%String,RoomID:%String,Room:%String,BedID:%String,Bed:%String,BedPos:%String,DocID:%String,DocName:%String,DisDate:%String,DisTime:%String,AdmStatus:%String,InHospLocDesc:%String,InHospWardDesc:%String,InHospDays:%String,InLocDate:%String,InLocTime:%String,InWardDate:%String,InWardTime:%String,WarningDtl:%String")
{
}

ClassMethod QryWarningDtlExecute(ByRef qHandle As %Binary, aConfigCode As %String, aWarningDate As %String, aHospID As %String, aDayCode As %String, aLocID As %String, aDataValue As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aConfigCode="")||(aWarningDate="")||(aLocID="")||(aDayCode="") $$$OK
 	;Set:aWarningDate["-" aWarningDate=$zdh(aWarningDate,3)
 	Set:aWarningDate'="" aWarningDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aWarningDate)
 	Set:aWarningDate>+$h aWarningDate=+$h
 	Set:aDayCode="Day1" aDateFrom=aWarningDate-6,aDateTo=aDateFrom
 	Set:aDayCode="Day2" aDateFrom=aWarningDate-5,aDateTo=aDateFrom
 	Set:aDayCode="Day3" aDateFrom=aWarningDate-4,aDateTo=aDateFrom
 	Set:aDayCode="Day4" aDateFrom=aWarningDate-3,aDateTo=aDateFrom
 	Set:aDayCode="Day5" aDateFrom=aWarningDate-2,aDateTo=aDateFrom
 	Set:aDayCode="Day6" aDateFrom=aWarningDate-1,aDateTo=aDateFrom
 	Set:aDayCode="Day7" aDateFrom=aWarningDate-0,aDateTo=aDateFrom
 	Set:aDayCode="Cnt3" aDateFrom=aWarningDate-2,aDateTo=aWarningDate
 	Set:aDayCode="Cnt7" aDateFrom=aWarningDate-6,aDateTo=aWarningDate
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Kill arrWarningItems
 	Set xDate=aDateFrom-1
 	For {
	 	Set xDate=$o(^DHCMed.NINF.BC.WarningI("IndexSubjectDate",aConfigCode,xDate))
	 	Quit:xDate=""
	 	Quit:xDate>aDateTo
	 	
	 	Set xWarningID=""
	 	For {
		 	Set xWarningID=$o(^DHCMed.NINF.BC.WarningI("IndexSubjectDate",aConfigCode,xDate,xWarningID))
		 	Quit:xWarningID=""
		 	
		 	Set objWarning=##class(DHCMed.NINF.BC.Warning).GetObjById(xWarningID)
		 	Continue:'$IsObject(objWarning)
		 	Set IsActive=objWarning.WAIsActive
		 	Continue:IsActive'=1
		 	Set EpisodeID=objWarning.WAEpisodeID
	 		Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
			Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
			
			//判断医院(集团化医院)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				Continue:flg<1
			}
			
		 	//Set DataValue=objWarning.WADataValue
		 	Set WAKeyWord=objWarning.WAKeyWord
			Set:WAKeyWord["同种同源" WAKeyWord=WAKeyWord_":"_objWarning.WADataValue
			Set DataValue=WAKeyWord
		 	Continue:(aDataValue'="")&&(aDataValue'=DataValue)
		 	
		 	Set ActDept=objWarning.WAActDept
		 	Set ActWard=objWarning.WAActWard
		 	Set ActDept=+ActDept
		 	Set ActWard=+ActWard
		 	Continue:(aLocID'="")&&((aLocID'=ActDept)&&(aLocID'=ActWard))
		 	
		 	Set ActDept=$p($g(^CTLOC(+ActDept)),"^",2)
			Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
		 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
			Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
			
			If '$d(arrWarningItems(EpisodeID)) {
				Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:'$IsObject(objPaadm)
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(objPatient)
			
				 //统一调用年龄计算方法
				  //upadte by pylian 2016-02-18 修改入院时间取值方式
    			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Set AdmTime=$p(AdmDateTime,"^",2)
				;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
				Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
				Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
				Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
				
				Set RegNo=objPatient.PapmiNo
				Set PatName=objPatient.PatientName
				Set MrNo=objPatient.InPatientMrNo
				Set:MrNo="" MrNo=objPaadm.MrNo
				Set Sex=objPatient.Sex
				Set Age=PatAge
				Set LocID=objPaadm.DepartmentID
				Set LocDesc=objPaadm.Department
				Set tmpWardID=objPaadm.WardID
				Set WardID=$p($g(^PAWARD(+tmpWardID)),"^",5)
				Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
				Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
				Set RoomID=objPaadm.RoomID	//增加病房字段
				Set Room=objPaadm.Room
				Set BedID=objPaadm.BedID
				Set Bed=objPaadm.Bed
				Set:(Bed'="")&&(Bed'["床") Bed=Bed_"床"
				
				Set PosLeft=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",15)
				Set PosTop=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",16)
				Set PosHeight=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",17)
				Set BedWidth=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",18)
				
				Set (BedRow,BedCol)=""
				Set:PosHeight>0 BedRow=(PosTop\PosHeight)+1
				Set:BedWidth>0 BedCol=(PosLeft\BedWidth)+1
				Set BedPos=BedRow_"-"_BedCol
				
				Set DocID=objPaadm.DoctorID
				Set DocName=objPaadm.DoctorName
				 //upadte by pylian 2016-02-18 修改入院时间取值方式
    			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Set AdmTime=$p(AdmDateTime,"^",2)
				;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
				Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
				//Set AdmTime=$p(tmpDateTime,",",2)
				Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
				Set DisDate=objPaadm.DisDate
				Set DisTime=objPaadm.DisTime
				Set tmpLocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospLocWard(EpisodeID)
				Set InHospLocID=$p(tmpLocWard,",",1)
				Set InHospLocDesc=$p(tmpLocWard,",",2)
				Set InHospWardID=$p(tmpLocWard,",",3)
				Set InHospWardDesc=$p(tmpLocWard,",",4)
				;Set tmpSttDate=$zdh(AdmDate,3)
				Set tmpSttDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmDate)
				;Set tmpEndDate=$s(DisDate'="":$zdh(DisDate,3),1:+$h)
				Set tmpDisDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DisDate)
				Set tmpEndDate=$s(tmpDisDate'="":tmpDisDate,1:+$h)
				Set InHospDays=(tmpEndDate-tmpSttDate)+1
				Set AdmStatus=objPaadm.Status
				Continue:AdmStatus="C" //退院
				Set:AdmStatus="A" AdmStatus="在院"
				Set:AdmStatus="D" AdmStatus="出院"
				Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInLocDateTime(EpisodeID,"E")
				Set InLocDate=$p(tmpDateTime,",",1)
				;Set:InLocDate'="" InLocDate=$zd(InLocDate,3)
				Set:InLocDate'="" InLocDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InLocDate)
				Set InLocTime=$p(tmpDateTime,",",2)
				Set:InLocTime'="" InLocTime=$zt(InLocTime,2)
				Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInLocDateTime(EpisodeID,"W")
				Set InWardDate=$p(tmpDateTime,",",1)
				;Set:InWardDate'="" InWardDate=$zd(InWardDate,3)
				Set:InWardDate'="" InWardDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InWardDate)
				Set InWardTime=$p(tmpDateTime,",",2)
				Set:InWardTime'="" InWardTime=$zt(InWardTime,2)
				Set CtrlDtl=xWarningID
				
				Set Data=$lb(EpisodeID,PatientID,CtrlDtl)
			 	Set Data=Data_$lb(RegNo,PatName,MrNo,Sex,Age)
				Set Data=Data_$lb(AdmDate,AdmTime,LocID,LocDesc,LocGrp,WardID,WardDesc,WardGrp,RoomID,Room,BedID,Bed,BedPos,DocID,DocName,DisDate,DisTime,AdmStatus)
				Set Data=Data_$lb(InHospLocDesc,InHospWardDesc,InHospDays,InLocDate,InLocTime,InWardDate,InWardTime)
			} Else {
				Set Data=$g(arrWarningItems(EpisodeID))
				Set CtrlDtl=$list(Data,3)
				Set CtrlDtl=CtrlDtl_","_xWarningID
				Set $list(Data,3)=CtrlDtl
			}
			Set arrWarningItems(EpisodeID)=Data
	 	}
 	}
 	
	Set xEpisodeID=0
	For {
		Set xEpisodeID=$o(arrWarningItems(xEpisodeID))
		Quit:xEpisodeID=""
		
		Set Data=$g(arrWarningItems(xEpisodeID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrWarningItems
 	
	Quit $$$OK
}

ClassMethod QryWarningDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarningDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarningDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarningDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhufei
/// CreatDate：   2014-03-06
/// Description:  查询暴发预警项目列表
/// Table：       DHCMed.NINF.BC.Warning
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.WarningSrv","QryWarningCtrlDtl","")
Query QryWarningCtrlDtl(aWarningIDs As %String) As %Query(ROWSPEC = "WarningID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActDept:%String,ActWard:%String,DataValue:%String")
{
}

ClassMethod QryWarningCtrlDtlExecute(ByRef qHandle As %Binary, aWarningIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aWarningIDs="" $$$OK
 	
 	For indWarn=1:1:$l(aWarningIDs,",") {
		Set WarningID=$p(aWarningIDs,",",indWarn)
		Continue:WarningID=""
		
	 	Set objWarning=##class(DHCMed.NINF.BC.Warning).GetObjById(WarningID)
	 	Continue:'$IsObject(objWarning)
	 	Set IsActive=objWarning.WAIsActive
	 	Continue:IsActive'=1
	 	
		Set ItemID=objWarning.WAItemCode
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set ItemCatID=objItemDic.IDSubCatDr
		Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ISCDesc
		
		Set Score=objItem.Score
		Set ItemGroup=""
		Set:(Score>0)&&(Score<=50) ItemGroup="一级"
		Set:(Score>50)&&(Score<=100) ItemGroup="二级"
		Set:Score>100 ItemGroup="三级"
		Continue:ItemGroup=""
		
		Set Summary=objWarning.WADataSummary
		Set DataValue=objWarning.WADataValue
		
		Set ActDate=objWarning.WAActDate
		Set ActTime=objWarning.WAActTime
		;Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set ActDept=objWarning.WAActDept
		Set ActWard=objWarning.WAActWard
		Set ActDept=+ActDept
	 	Set ActWard=+ActWard
	 	Set ActDept=$p($g(^CTLOC(+ActDept)),"^",2)
		Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
	 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		Set Data=$lb(WarningID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActDept,ActWard,DataValue)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryWarningCtrlDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarningCtrlDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWarningCtrlDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarningCtrlDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// w ##Class(DHCMed.NINFService.BC.WarningSrv).GetWarningDays("2013-07-31")
ClassMethod GetWarningDays(aWarningDate As %String)
{
	New (aWarningDate)
	Set return=""
	Quit:aWarningDate="" return
	
	;Set:aWarningDate["-" aWarningDate=$zdh(aWarningDate,3)
	Set aWarningDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aWarningDate)
 	Set:aWarningDate>+$h aWarningDate=+$h
 	
 	Set return=$e($zd(aWarningDate-6,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-5,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-4,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-3,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-2,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-1,3),6,10)
 	Set return=return_","_$e($zd(aWarningDate-0,3),6,10)
	Quit return
}

}
