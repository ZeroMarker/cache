Class DHCEPRFS.web.eprajax.AjaxCorrelationEpisode Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
    s startDate = $Get(%request.Data("StartDate",1),"")
    s endDate = $Get(%request.Data("EndDate",1),"")
    s categoryCode = $Get(%request.Data("CategoryCode",1),"")
    s subEpisodeID = $Get(%request.Data("SubEpisodeID",1),"")
    s userID = $Get(%request.Data("UserID",1),"")
    s action = $Get(%request.Data("Action",1),"-1")
	
	if (action = "GetEpisodeList")
	{
		d ..GetEpisodeListJSON(episodeID,startDate,endDate)
	}
	elseif (action = "GetCategory")
	{
		d ..GetCategoryListJSON(subEpisodeID)
	}
	elseif (action = "GetOrderList")
	{
		d ..GetOrdItemListJSON(subEpisodeID,categoryCode)
	}
	elseif (action = "Correlation")
	{
		s ret = ..Correlation(episodeID,subEpisodeID)
		w ret
	}
	elseif (action = "UnCorrelation")
	{
		s ret = ..UnCorrelation(episodeID,subEpisodeID)
		w ret
	}
	elseif (action = "Complete")
	{
		s ret = ..Complete(episodeID,userID)
		w ret
	}
	Quit $$$OK
}

/// 病案相关动作调用ajax方法插入队列
/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxCorrelationEpisode).GetEpisodeListJSON("620","2018-5-1","2018-5-10")
ClassMethod GetEpisodeListJSON(AEpisodeID As %String, AStartDate As %String, AEndDate As %String)
{
	q:((AEpisodeID = "") || (AEpisodeID = $c(0)))
	q:((AStartDate = "") || (AStartDate = $c(0)))
	q:((AEndDate = "") || (AEndDate = $c(0)))
	
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	
	s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxCorrelationEpisode:GetPatientList")
	s sc = result.Execute(AEpisodeID)
	
	s count = 0
	s first = 1
 	w "{""rows"":["
	
	while(result.Next())
	{
		s date = $g(result.Data("PAAdmDate"))
		s:(date '="") date=$zdh(date,3)
		s admType = $g(result.Data("PAAdmType"))
		s:(admType '="") admType=$ZCVT(admType,"U")
		continue:(admType '= "O")&&(admType '= "E")
		if (date>startDate)&&(date<endDate)
		{
			s count = count + 1		
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")
			w ..TrimEnter("""IsCreated"":"""_$g(result.Data("IsCreated"))_""",")
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
			w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""IsCorrelation"":"""_$g(result.Data("IsCorrelation"))_"""")
			w "}"
			s first = 0
		}
	}
	
	w "],""total"":"_count_"}"
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxCorrelationEpisode).GetCategoryListJSON("620")
ClassMethod GetCategoryListJSON(AEpisodeID As %String)
{
	w "{""rows"":["
	w "{""CategoryCode"":""PACS"",""CategoryName"":""检查""},"
	w "{""CategoryCode"":""LIS"",""CategoryName"":""检验""}"
	w "],""total"":2}"
	/*
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLIntegrityCheck:GetCheckResultByEpisode")
	s sc = result.Execute(AEpisodeID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
		
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""CategoryCode"":"""_$g(result.Data("CategoryCode"))_""",")
		w ..TrimEnter("""CategoryName"":"""_$g(result.Data("CategoryName"))_""",")
		w ..TrimEnter("""CheckResult"":"""_$g(result.Data("CheckResult"))_""",")
		w ..TrimEnter("""IsNeeded"":"""_$g(result.Data("IsNeeded"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
	*/
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxCorrelationEpisode).GetOrdItemListJSON("620","PACS")
ClassMethod GetOrdItemListJSON(AEpisodeID As %String, ACategoryCode As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxCorrelationEpisode:GetOrdItemListByEpisode")
	s sc = result.Execute(AEpisodeID,ACategoryCode)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
		
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""OrderID"":"""_$g(result.Data("OrderID"))_""",")
		w ..TrimEnter("""OrderDesc"":"""_$g(result.Data("OrderDesc"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

Query GetPatientList(AEpisodeID As %String) As %Query(ROWSPEC = "IsCreated:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDate:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String,IsCorrelation:%String,IsCorrelation:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList")
 	
 	q:(AEpisodeID = "") $$$OK
 	s PAPMI = $p($g(^PAADM(AEpisodeID)),"^",1)
	//q:(PAPMI = "") $$$OK
	
	s MRMedRecordID = ""
	if (PAPMI '= "")
	{
		s AdmType = ""
		for {
	    	s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    	q:(AdmType = "")
	    	s PAAdm = ""
	    	for {
		    	s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     	q:(PAAdm = "")
		     
		        //检查就诊是否已取消，取消的就诊不显示
				s IsCancel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).CheckEpisodeCancel(PAAdm)
				continue:(IsCancel = "1")

				s IsCreated = "N"
				s IsCorrelation = "N"
				s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAAdm,"DHC")
				if (mrEpisodeID '= "")
				{
					s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					s MRMedRecordID = objMREpisode.MRMedRecordID
					s IsCreated = "Y"
					s originEpisodeID = objMREpisode.OriginEpisodeID
					for i =1:1:$l(originEpisodeID,"^")
					{
						s oneOrigin = $p(originEpisodeID,"^",i)
						if (oneOrigin =AEpisodeID)
						{
							s IsCorrelation = "Y"
						}
					}	
				}
	
				s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
				s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
				s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
				//就诊类型 "住院"--inpatient "门诊"--outpatient "急诊"--emergency
				//病人姓名
				s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
				//身份证号
				s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
				//登记号
				s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

				//出生日期,年龄
				s PAPMIDOB = "" ,PAPMIAge = ""  
				s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
				if (DobDate '= "")
				{
					s PAPMIDOB = $ZD(DobDate,3)
					s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
				}
				//性别
				s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
				s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
				//婚姻
 				s tmpMarriage= ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMarriage(PatientID)
 				if (tmpMarriage '= "")
 				{
	 				s Marriage= $p($g(tmpMarriage),"^",3)
				}
				//出生地
				s tmpNative= ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).Native(PatientID,Hospital)
 				if (tmpNative '= "")
 				{
   					//出生地城市 
   					s CityBirth = $p($g(tmpNative),"!",2)
   					s CityBirth = $p($g(CityBirth),"^",2)
 
   					//出生地省份 
   					s ProvinceBirth = $p($g(tmpNative),"!",1)
   					s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 				}
 				//职业
 				s tmpOccupation = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetOccupation(PatientID,Hospital)
 				if (tmpOccupation '= "")
 				{
   					s Occupation = $p($g(tmpOccupation),"^",2)
 				}
				//民族
				s tmpNation=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetNation(PatientID,Hospital)
				if (tmpNation '= "")
 				{
   					s Nation = $p($g(tmpNation),"^",2)
 				}
 				//手机
				s MobilePhone=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPhoneNo(PatientID,Hospital)
	
				s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
				//若存在开始和结束日期，则需判断就诊日期是否在范围内

				s PAAdmTime = $P($g(^PAADM(PAAdm)),"^",7)
				s PAAdmTime = $ZT(PAAdmTime,3)  //入院时间
	
				s PAAdmDateTime = PAAdmDate_","_PAAdmTime
				s:(PAAdmDateTime = ",") PAAdmDateTime = ""
				//病区
				s PAAdmWard = ""  
				s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
				s:(WardDr '= "") PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
				s PAAdmRoom = "" //病房
				s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
				s:(RoomDr '= "") PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
				s PAAdmBed = ""  //病床
				s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
				s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
				//当前科室
				s PAAdmLoc = ""    
				s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
				s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
				//出院日期时间
				s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
				s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
				s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
			
				if (PADischgeDate '= "")
				{
					s PADischgeDate = $zd(PADischgeDate,3)
				}
			
				//在院状态
				if (PAAdmType ="I")
				{
					s PAStatusType = "A"
					s:(PADischgeDate = "") PADischgeDateTime = "" 
					s:(PADischgeDateTime '= "") PAStatusType = "D"

					if (PAStatusType = "A")
					{
						s PAStatusType = "在院"
						continue
					}
					elseif (PAStatusType = "D")
					{
						s PAStatusType = "出院"
					}
				}
				else
				{
					s PAStatusType = "门诊"
				}
				//医生 
				s PAAdmDoc = ""  
				s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
				s:(Doctor '= "") PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
				//付费方式
				s PayMode = "" 
				s prtRowID = ""
				for {
					s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
					q:(prtRowID = "")
					s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
					s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
					s:($f(PayMode,pmDesc) = 0) PayMode = PayMode_pmDesc_" "
				}
				

			
				s ^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",PAAdm) = IsCreated_"|"_PAStatusType_"|"_PAAdmType_"|"_PAPMIName_"|"_PAPMINO_"|"_PAPMIDOB_"|"_PAPMIAge_"|"_PAPMISex_"|"_PAAdmDate_"|"_PAAdmWard_"|"_PAAdmRoom_"|"_PAAdmBed_"|"_PAAdmLoc_"|"_PADischgeDate_"|"_PAAdmDoc_"|"_PayMode_"|"_PAAdm_"|"_PatientID_"|"_IsCorrelation			     
			}
		}
	}
	else
	{
		//b "s"
		s mrEpisodeID = ""
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
		if (mrEpisodeID '= "")
		{
			s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
			s MRMedRecordID = objMREpisode.MRMedRecordID
		}
	}

	if (MRMedRecordID '= "")
	{
		s rowIDMREpisode =""
		for {
			s rowIDMREpisode = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_MRMedRecordID,rowIDMREpisode))
			q:(rowIDMREpisode = "")
			//b "s"
			s objMRE = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowIDMREpisode)
			s mrPatientID = objMRE.MRPatientID
			s episodeID = objMRE.EpisodeID
			
			if ('$d(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID)))
			{
				s PAAdmType = objMRE.AdmTypeID
				s PAAdmDate = objMRE.AdmDate
				if (PAAdmDate '= "")
				{
					s PAAdmDate = $zd(PAAdmDate,3)
				}
				s PAAdmWard = objMRE.AdmWard
				s PAAdmRoom = ""
				s PAAdmBed = ""
				s PAAdmLoc = objMRE.AdmLoc
				s PADischgeDate = objMRE.DisDate
				if (PADischgeDate '= "")
				{
					s PADischgeDate = $zd(PADischgeDate,3)
				}
				s PAAdmDoc = objMRE.MainDoctor
				s PayMode = objMRE.PayMode
				s PAAdm = objMRE.EpisodeID
				
				
				s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
				s PAPMIName = objMRPatient.Name
				s PAPMINO = objMRPatient.RegNo
				s PAPMIDOB = objMRPatient.Birthday
				if (PAPMIDOB '="")
				{
					s PAPMIAge = $fn((+$H-PAPMIDOB)/365,"",0)
					s PAPMIDOB = $zd(PAPMIDOB,3)
				}
				s PAPMISex = objMRPatient.Gender
				s PatientID = objMRPatient.PatientID
				
				s IsCorrelation = "N"
				s originEpisodeID = objMRE.OriginEpisodeID
				for i =1:1:$l(originEpisodeID,"^")
				{
					s oneOrigin = $p(originEpisodeID,"^",i)
					if (oneOrigin =AEpisodeID)
					{
						s IsCorrelation = "Y"
					}
				}
				
				s ^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID) = "Y"_"|"_"出院"_"|"_PAAdmType_"|"_PAPMIName_"|"_PAPMINO_"|"_PAPMIDOB_"|"_PAPMIAge_"|"_PAPMISex_"|"_PAAdmDate_"|"_PAAdmWard_"|"_PAAdmRoom_"|"_PAAdmBed_"|"_PAAdmLoc_"|"_PADischgeDate_"|"_PAAdmDoc_"|"_PayMode_"|"_episodeID_"|"_PatientID_"|"_IsCorrelation
			}
		}
	}
	
	s episodeID = ""
	for {
		s episodeID = $o(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID))
		q:(episodeID = "")
		s IsCreated =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",1)
		s PAStatusType =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",2)
		s PAAdmType = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",3)
		s PAPMIName = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",4)
		s PAPMINO =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",5)
		s PAPMIDOB = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",6)
		s PAPMIAge = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",7)
		s PAPMISex = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",8)
		s PAAdmDate =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",9)
		s PAAdmWard =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",10)
		s PAAdmRoom =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",11)
		s PAAdmBed =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",12)
		s PAAdmLoc =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",13)
		s PADischgeDate =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",14)
		s PAAdmDoc = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",15)
		s PayMode = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",16)
		s PAAdm =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",17)
		s PatientID = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",18)
		s IsCorrelation = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList",episodeID),"|",19)
		
		s data = $lb(IsCreated,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDate,PAAdmDoc,PayMode,PAAdm,PatientID,IsCorrelation)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1	
	}

    k ^CacheTemp("DHCEPRFS","web","eprajax","AjaxCorrelationEpisode","GetPatientList")
	Quit $$$OK
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc: 获取就诊指定类别的所有医嘱项目
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.web.eprajax.AjaxCorrelationEpisode","GetOrdItemListByEpisode","620","PACS")
Query GetOrdItemListByEpisode(AEpisodeID As %String, ACategoryCode As %String) As %Query(ROWSPEC = "OrderID:%String,OrderDesc:%String")
{
}

ClassMethod GetOrdItemListByEpisodeExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ACategoryCode As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	if (ACategoryCode = "PACS")
 	{
	 	s startDate = $p($g(^PAADM(AEpisodeID)),"^",6)
	 	s endDate = $p($g(^PAADM(AEpisodeID)),"^",17)
	 	s:(endDate = "") endDate = $p($h,",",1)
	 	s ds = ##Class(%ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
		s sc = ds.Execute(AEpisodeID,startDate,endDate)

		while(ds.Next())
		{
			s orderID = $g(ds.Data("RptRowID"))
			s orderDesc = $g(ds.Data("ItemName"))
			s ^CacheTemp(repid,ind) = $lb(orderID,orderDesc)
	 		s ind = ind + 1
		}
 	}
 	elseif (ACategoryCode = "LIS")
 	{
	 	s startDate = $p($g(^PAADM(AEpisodeID)),"^",6)
	 	s endDate = $p($g(^PAADM(AEpisodeID)),"^",17)
	 	s:(endDate = "") endDate = $p($h,",",1)
	 	s ds = ##Class(%ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
		s sc = ds.Execute(AEpisodeID,startDate,endDate)

		while(ds.Next())
		{
			s orderID = $g(ds.Data("OEordItemRowID"))
			s orderDesc = $g(ds.Data("OEordItemDesc"))
			s ^CacheTemp(repid,ind) = $lb(orderID,orderDesc)
	 		s ind = ind + 1
		}
 	}
 	q $$$OK
}

ClassMethod GetOrdItemListByEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdItemListByEpisodeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetOrdItemListByEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdItemListByEpisodeExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

ClassMethod Correlation(AEpisodeID As %String, ASubEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") "0"
	q:(ASubEpisodeID = "") "0"
	s flag = "1"
	s mrEpisodeID = ""
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID ,"DHC")
	q:(mrEpisodeID ="") "0"
	//s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
		
	s subMREpisodeID = ""
	s subMREpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(ASubEpisodeID ,"DHC")
	q:(subMREpisodeID ="") "0"
	//s subMREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_ASubEpisodeID,subMREpisodeID))
	
	if (subMREpisodeID '= "")
	{
		s objSubMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(subMREpisodeID)
		if (objSubMREpisode.OriginEpisodeID = "")
		{
			s objSubMREpisode.OriginEpisodeID = AEpisodeID
		}
		else
		{
			s flagExist = "N"
			for i =1:1:$l(objSubMREpisode.OriginEpisodeID,"^")
			{
				if ($p(objSubMREpisode.OriginEpisodeID,"^",i) = AEpisodeID)
				{
					s flagExist = "Y"
				}
			}
			if (flagExist '= "Y")
			{
				s objSubMREpisode.OriginEpisodeID = objSubMREpisode.OriginEpisodeID_"^"_AEpisodeID
			}
		}
		
		if (objSubMREpisode.OriginMREpisodeID ="")
		{
			s objSubMREpisode.OriginMREpisodeID = mrEpisodeID
		}
		else
		{
			s flagExist = "N"
			for i =1:1:$l(objSubMREpisode.OriginMREpisodeID,"^")
			{
				if ($p(objSubMREpisode.OriginMREpisodeID,"^",i) = mrEpisodeID)
				{
					s flagExist = "Y"
				}
			}
			if (flagExist '= "Y")
			{
				s objSubMREpisode.OriginMREpisodeID = objSubMREpisode.OriginMREpisodeID_"^"_mrEpisodeID
			}
		}
		
		s scSub = objSubMREpisode.%Save()
		if ($$$ISOK(scSub))
		{
		}
		else
		{
			s flag = "0"
		}
	}
	
	if (mrEpisodeID '= "")
	{
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		if (objMREpisode.ExtendEpisodeID = "")
		{
			s objMREpisode.ExtendEpisodeID = ASubEpisodeID
		}
		else
		{
			s flagExist = "N"
			for i =1:1:$l(objMREpisode.ExtendEpisodeID,"^")
			{
				if ($p(objMREpisode.ExtendEpisodeID,"^",i) = ASubEpisodeID)
				{
					s flagExist = "Y"
				}
			}
			if (flagExist '= "Y")
			{
				s objMREpisode.ExtendEpisodeID = objMREpisode.ExtendEpisodeID_"^"_ASubEpisodeID
			}		
		}
		
		if (objMREpisode.ExtendMREpisodeID = "")
		{
			s objMREpisode.ExtendMREpisodeID = subMREpisodeID
		}
		else
		{
			s flagExist = "N"
			for i =1:1:$l(objMREpisode.ExtendMREpisodeID,"^")
			{				
				if ($p(objMREpisode.ExtendMREpisodeID,"^",i) = subMREpisodeID)
				{
					s flagExist = "Y"
				}				
			}
			if (flagExist '= "Y")
			{
				s objMREpisode.ExtendMREpisodeID = objMREpisode.ExtendMREpisodeID_"^"_subMREpisodeID
			}
		}
		s sc = objMREpisode.%Save()
		if ($$$ISOK(sc))
		{
		}
		else
		{
			s flag = "0"
		}
	}
	
	q flag
}

ClassMethod UnCorrelation(AEpisodeID As %String, ASubEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") "0"
	q:(ASubEpisodeID = "") "0"
	s flag = "1"
	s mrEpisodeID = ""
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
		
	s subMREpisodeID = ""
	s subMREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_ASubEpisodeID,subMREpisodeID))
	if (subMREpisodeID '="")
	{
		s objMREpisodeID = ##class(DHCEPRFS.INST.MREpisode).%OpenId(subMREpisodeID)
		if (objMREpisodeID.OriginEpisodeID '="")
		{
			s fullOriginEpisodeID = ""
			for i=1:1:$l(objMREpisodeID.OriginEpisodeID,"^")
			{
				if ($p(objMREpisodeID.OriginEpisodeID,"^",i) '= AEpisodeID)
				{
					if (fullOriginEpisodeID = "")
					{
						s fullOriginEpisodeID = $p(objMREpisodeID.OriginEpisodeID,"^",i)
					}
					else
					{
						s fullOriginEpisodeID =fullOriginEpisodeID_"^"_$p(objMREpisodeID.OriginEpisodeID,"^",i)
					}
				}
			}
			s objMREpisodeID.OriginEpisodeID = fullOriginEpisodeID
		}
		
		if (objMREpisodeID.OriginMREpisodeID '="")
		{
			s fullOriginMREpisodeID = ""
			for i=1:1:$l(objMREpisodeID.OriginMREpisodeID,"^")
			{
				if ($p(objMREpisodeID.OriginMREpisodeID,"^",i) '= mrEpisodeID)
				{
					if (fullOriginMREpisodeID = "")
					{
						s fullOriginMREpisodeID = $p(objMREpisodeID.OriginMREpisodeID,"^",i)
					}
					else
					{
						s fullOriginMREpisodeID =fullOriginMREpisodeID_"^"_$p(objMREpisodeID.OriginMREpisodeID,"^",i)
					}
				}
			}
			s objMREpisodeID.OriginMREpisodeID = fullOriginMREpisodeID
		}
		s scSub = objMREpisodeID.%Save()
		if ($$$ISOK(scSub))
		{			
		}
		else
		{
			s flag = "0"
		}
	}
	
	if (mrEpisodeID '="")
	{
		s objEpisodeID = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		if (objEpisodeID.ExtendEpisodeID '= "")
		{
			s fullExtendEpisodeID = ""
			for i=1:1:$l(objEpisodeID.ExtendEpisodeID,"^")
			{
				if ($p(objEpisodeID.ExtendEpisodeID,"^",i) '= ASubEpisodeID)
				{
					if (fullExtendEpisodeID ="")
					{
						s fullExtendEpisodeID = $p(objEpisodeID.ExtendEpisodeID,"^",i)
					}
					else
					{
						s fullExtendEpisodeID = fullExtendEpisodeID_"^"_$p(objEpisodeID.ExtendEpisodeID,"^",i)
					}
				}
			}
			s objEpisodeID.ExtendEpisodeID = fullExtendEpisodeID
		}
		
		if (objEpisodeID.ExtendMREpisodeID '="")
		{
			s fullExtendMREpisodeID = ""
			for i=1:1:$l(objEpisodeID.ExtendMREpisodeID,"^")
			{
				if ($p(objEpisodeID.ExtendMREpisodeID,"^",i)'=subMREpisodeID)
				{
					if (fullExtendMREpisodeID = "")
					{
						s fullExtendMREpisodeID = $p(objEpisodeID.ExtendMREpisodeID,"^",i)
					}
					else
					{
						s fullExtendMREpisodeID = fullExtendMREpisodeID_"^"_$p(objEpisodeID.ExtendMREpisodeID,"^",i)
					}
				}
			}
			s objEpisodeID.ExtendMREpisodeID = fullExtendMREpisodeID		
		}
		
		s sc = objEpisodeID.%Save()
		if ($$$ISOK(sc))
		{
		}
		else
		{
			s flag = "0"
		}		
	}
	q flag
}

ClassMethod Complete(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret ="0"
	s ret =##Class(DHCEPRFS.web.eprajax.AdmMRStatusMgr).UpdateAdmMRStatus(AEpisodeID,AUserID)
	if (ret="1")
	{
		s mrEpisodeID = ""
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
		if (mrEpisodeID '="")
		{
			s obj=##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
			s extendEpisodeID = obj.ExtendEpisodeID
			if (extendEpisodeID '="")
			{
				for i=1:1:$l(extendEpisodeID,"^")
				{
					s oneExtendEpisodeID = $p(extendEpisodeID,"^",i)
					d ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC", oneExtendEpisodeID, "50")
				}
			}
		}
	}
	q ret
}

}
