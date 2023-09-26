Class DHCEPRFS.web.eprajax.AjaxEpisodeView Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s langid = 20
	s Languages = "CH"
	if ($d(%session))
	{
		set langid=+$g(%session.Data("LOGON.LANGID"))
        s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	s action = $Get(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s idCard = $Get(%request.Data("IDCard",1),"")
	s locDepDR = $Get(%request.Data("LocDepDR",1),"")
	s startDate = ##class(DHCEPRFS.Util.StringHelper).DateboxToNormal($g(%request.Data("StartDate",1),""))
	s endDate = ##class(DHCEPRFS.Util.StringHelper).DateboxToNormal($g(%request.Data("EndDate",1),""))
	s locID = $Get(%request.Data("LocID",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s medRecordNo = $Get(%request.Data("MedRecordNo",1),"")
	s patName = $Get(%request.Data("PatName",1),"")
	s admStatus = $g(%request.Data("AdmStatus",1),"")
	
	s wardid =$G(%request.Data("WardID",1),"")
	s nurSubmitFlag = $G(%request.Data("NurSubmitFlag",1),"")
	
	if (action = "episodelist")
	{
		d ..GetEPREpisodeListJSON(episodeID,"","","")
	}
	elseif (action = "mrepisodeinfolist")
	{
		d ..GetMREpisodeInfoListJSON(episodeID,idCard,langid,Languages)
	}
	elseif (action = "loclist")
	{
		d ..GetLocListByDepDRJSON(locDepDR)
	}
	elseif (action = "episodeinfolist")
	{
		d ..GetEpisodeInfoListJSON(startDate,endDate,locID,regNo,medRecordNo,patName,startRow,endRow)
	}
	elseif (action = "scanepisodelist")
	{
		d ..GetScanEpisodeListJSON(admStatus,startDate,endDate,locID,regNo,medRecordNo,patName,startRow,endRow)
	}
	elseif (action="nursubmitepisodeinfolist")
	{
		d ..GetNurSubmitEpisodeInfoListJSON(startDate,endDate,locID,wardid,regNo,medRecordNo,patName,startRow,endRow,nurSubmitFlag,langid,Languages)
	}
	elseif (action="scanepisodelist4out")
	{
		d ..GetScanEpisodeList4OutJSON(startDate,endDate,locID,regNo,medRecordNo,patName,startRow,endRow)
	}
	Quit $$$OK
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetMREpisodeInfoListJSON("612")
ClassMethod GetMREpisodeInfoListJSON(AEpisodeID As %String, AIDCard As %String = "", langid As %String = "20", Languages As %String = "CH")
{
	if ((AIDCard="")||(AIDCard=$c(0)))
	{
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetMREpisodeInfoList")
		s sc = result.Execute(AEpisodeID)
	}
	else
	{
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetMREpisodeListByIDCard")
		s sc = result.Execute(AIDCard)
	}
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""MREpisodeID"":"""_$g(result.Data("MREpisodeID"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
		w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
		w ..TrimEnter("""PatName"":"""_$g(result.Data("PatName"))_""",")			
		w ..TrimEnter("""AdmDate"":"""_##class(DHCEPRFS.Util.StringHelper).CacheDateToDatebox($g(result.Data("AdmDate")))_""",")
		//w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
		
		w ..TrimEnter("""DischDate"":"""_##class(DHCEPRFS.Util.StringHelper).CacheDateToDatebox($g(result.Data("DischDate")))_""",")
		//w ..TrimEnter("""DischDate"":"""_$g(result.Data("DischDate"))_""",")
		w ..TrimEnter("""AdmType"":"""_$g(result.Data("AdmType"))_""",")
		w ..TrimEnter("""AdmTypeDesc"":"""_##class(websys.Translation).Get("",$g(result.Data("AdmTypeDesc")))_""",")
		w ..TrimEnter("""DischLocID"":"""_$g(result.Data("DischLocID"))_""",")
		w ..TrimEnter("""DischLoc"":"""_##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$g(result.Data("DischLoc")),langid)_""",")		
		w ..TrimEnter("""MainDoctor"":"""_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,$g(result.Data("MainDoctor")))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetLocListByDepDRJSON("2")
ClassMethod GetLocListByDepDRJSON(ALocDepDR As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLDeptList:GetLocListByDepDR")
	s sc = result.Execute(ALocDepDR)
	
	s count = 0
	s first = 1
	w "["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""LocID"":"""_$g(result.Data("LocID"))_""",")
		w ..TrimEnter("""LocCode"":"""_$g(result.Data("LocCode"))_""",")
		w ..TrimEnter("""LocDesc"":"""_$g(result.Data("LocDesc"))_""",")
		w ..TrimEnter("""LocContactName"":"""_$g(result.Data("LocContactName"))_"""")
		w "}"
		s first = 0
	}
	w "]"
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetEpisodeInfoListJSON("","","","000000202","","500307",1,20)
ClassMethod GetEpisodeInfoListJSON(AStartDate As %String, AEndDate As %String, ALocID As %String, ARegNo As %String, AMedRecordNo As %String, APatName As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s param = "^"_APatName_"^"_AMedRecordNo_"^"_"^"_ARegNo_"^"_AStartDate_"^"_AEndDate_"^"_ALocID
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetEpisodeInfoList")
	s sc = result.Execute(param)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
			w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
			w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
			w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")
			w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")
			w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
			w ..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// debug: w ##class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetEPREpisodeListJSON("18344564","","","")
ClassMethod GetEPREpisodeListJSON(AAdmNo As %String, ARegNo As %String, AName As %String, AmedRecordID As %String) As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxEpisodeView:GetPatientList")
	s sc = result.Execute(AAdmNo)
		
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1	

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""",")
		w ..TrimEnter("""PADischgeDate"":"""_$g(result.Data("PADischgeDate"))_""",")
		w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
		w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")
		w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")					
		w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")
		w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
		w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
		w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
		w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_"""")					
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetScanEpisodeListJSON("A","2019-11-01","2019-11-01","301","","","","1","20")
ClassMethod GetScanEpisodeListJSON(AAdmStatus As %String, AStartDate As %String, AEndDate As %String, ACTLocID As %String, ARegNo As %String, AMedRecordNo As %String, APatName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetScanEpisodeList")
	s sc = result.Execute(AAdmStatus,AStartDate,AEndDate,ACTLocID,ARegNo,AMedRecordNo,APatName)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
	 	s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PatName"":"""_$g(result.Data("PatName"))_""",")
			w ..TrimEnter("""PatDOB"":"""_$g(result.Data("PatDOB"))_""",")
			w ..TrimEnter("""PatSex"":"""_$g(result.Data("PatSex"))_""",")
			w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
			w ..TrimEnter("""AdmTime"":"""_$g(result.Data("AdmTime"))_""",")
			w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
			w ..TrimEnter("""DisTime"":"""_$g(result.Data("DisTime"))_""",")
			w ..TrimEnter("""AdmLocDesc"":"""_$g(result.Data("AdmLocDesc"))_""",")
			w ..TrimEnter("""AdmWardDesc"":"""_$g(result.Data("AdmWardDesc"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""PAADMReason"":"""_$g(result.Data("PAADMReason"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Desc: 2022-10-31 yangshun 门诊扫描查询，参照住院扫描查询，去掉admStatus这个参数
/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetScanEpisodeList4OutJSON("2019-11-01","2022-11-01","50","0001681818","","","1","20")
ClassMethod GetScanEpisodeList4OutJSON(AStartDate As %String, AEndDate As %String, ACTLocID As %String, ARegNo As %String, AMedRecordNo As %String, APatName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetScanEpisodeList4Out")
	s sc = result.Execute(AStartDate,AEndDate,ACTLocID,ARegNo,AMedRecordNo,APatName)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PatName"":"""_$g(result.Data("PatName"))_""",")
			w ..TrimEnter("""PatDOB"":"""_$g(result.Data("PatDOB"))_""",")
			w ..TrimEnter("""PatSex"":"""_$g(result.Data("PatSex"))_""",")
			w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
			w ..TrimEnter("""AdmTime"":"""_$g(result.Data("AdmTime"))_""",")
			w ..TrimEnter("""AdmLocDesc"":"""_$g(result.Data("AdmLocDesc"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""PAADMReason"":"""_$g(result.Data("PAADMReason"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// Debug:w ##class(%ResultSet).RunQuery("DHCEPRFS.web.eprajax.AjaxEpisodeView","GetPatientList","11513982")
Query GetPatientList(AEpisodeID As %String) As %Query(ROWSPEC = "IsCreated:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDate:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList")
 	
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
				q:(IsCancel = "1")

				s IsCreated = "N"
				s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAAdm,"DHC")
				if (mrEpisodeID '= "")
				{
					s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
					s MRMedRecordID = objMREpisode.MRMedRecordID
					s IsCreated = "Y"	
				}
	
				s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
				s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
				s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
				//就诊类型 "住院"--inpatient "门诊"--outpatient "急诊"--emergency
				if (PAAdmType = "I")
				{
					s PAAdmType = "住院"
				}
				elseif PAAdmType = "O"
				{
					s PAAdmType = "门诊"
				}
				elseif PAAdmType = "E"
				{
					s PAAdmType = "急诊"
				}
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
			
				s ^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",PAAdm) = IsCreated_"|"_PAStatusType_"|"_PAAdmType_"|"_PAPMIName_"|"_PAPMINO_"|"_PAPMIDOB_"|"_PAPMIAge_"|"_PAPMISex_"|"_PAAdmDate_"|"_PAAdmWard_"|"_PAAdmRoom_"|"_PAAdmBed_"|"_PAAdmLoc_"|"_PADischgeDate_"|"_PAAdmDoc_"|"_PayMode_"|"_PAAdm_"|"_PatientID				     
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
			
			if ('$d(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID)))
			{
				s PAAdmType = objMRE.AdmType
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
				
				s ^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID) = "Y"_"|"_"出院"_"|"_PAAdmType_"|"_PAPMIName_"|"_PAPMINO_"|"_PAPMIDOB_"|"_PAPMIAge_"|"_PAPMISex_"|"_PAAdmDate_"|"_PAAdmWard_"|"_PAAdmRoom_"|"_PAAdmBed_"|"_PAAdmLoc_"|"_PADischgeDate_"|"_PAAdmDoc_"|"_PayMode_"|"_episodeID_"|"_PatientID
			}
		}
	}
	
	s episodeID = ""
	for {
		s episodeID = $o(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID))
		q:(episodeID = "")
		s IsCreated =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",1)
		s PAStatusType =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",2)
		s PAAdmType = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",3)
		s PAPMIName = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",4)
		s PAPMINO =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",5)
		s PAPMIDOB = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",6)
		s PAPMIAge = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",7)
		s PAPMISex = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",8)
		s PAAdmDate =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",9)
		s PAAdmWard =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",10)
		s PAAdmRoom =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",11)
		s PAAdmBed =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",12)
		s PAAdmLoc =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",13)
		s PADischgeDate =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",14)
		s PAAdmDoc = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",15)
		s PayMode = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",16)
		s PAAdm =$p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",17)
		s PatientID = $p(^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList",episodeID),"|",18)
		
		s data = $lb(IsCreated,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDate,PAAdmDoc,PayMode,PAAdm,PatientID)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1	
	}

    k ^CacheTemp("DHCEPRFS","web","eprajax","AjaxEpisodeView","GetPatientList")
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

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxEpisodeView).GetNurSubmitEpisodeInfoListJSON("","","","000000202","","500307",1,20)
ClassMethod GetNurSubmitEpisodeInfoListJSON(AStartDate As %String, AEndDate As %String, ALocID As %String, AWardID As %String, ARegNo As %String, AMedRecordNo As %String, APatName As %String, AIdxStart As %Integer, AIdxLast As %Integer, ANurseSubmitFlag As %String, langid As %String = "20", Languages As %String = "CH") As %String
{
	s param = "^"_APatName_"^"_AMedRecordNo_"^"_"^"_ARegNo_"^"_AStartDate_"^"_AEndDate_"^"_ALocID_"^"_AWardID
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMREpisodeView:GetNurSubEpisodeInfoList")
	s sc = result.Execute(param)
	
	s count = 0
	s first = 1

	w "{""rows"":["
	While (result.Next())
	{
		continue:((ANurseSubmitFlag'="A")&&(ANurseSubmitFlag'=$g(result.Data("NurSubmit"))))
		s NurFlag = "是"
		if ($g(result.Data("NurSubmit"))="N")
		{
			s NurFlag = "否"
		}
		elseif ($g(result.Data("NurSubmit"))="B")
		{
			s NurFlag = "退回"
		}
		s DocFlag = "是"
		if ($g(result.Data("DocSubmit"))="N")
		{
			s DocFlag = "否"
		}
		elseif ($g(result.Data("DocSubmit"))="B")
		{
			s DocFlag = "退回"
		}
		s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_##class(User.CTSex).GetTranByDesc("CTSEXDesc",$g(result.Data("PAPMISex")),langid)_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("PAAdm"))_""",")
			w ..TrimEnter("""PAAdmType"":"""_##class(websys.Translation).Get("",$g(result.Data("PAAdmType")))_""",")
			w ..TrimEnter("""PAAdmLoc"":"""_##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$g(result.Data("PAAdmLoc")),langid)_""",")
			
			w ..TrimEnter("""PAAdmDateTime"":"""_##class(DHCEPRFS.Util.StringHelper).CacheDateTimeToDateBox($g(result.Data("PAAdmDateTime")))_""",")
			//w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
			w ..TrimEnter("""PADischgeDateTime"":"""_##class(DHCEPRFS.Util.StringHelper).CacheDateTimeToDateBox($g(result.Data("PADischgeDateTime")))_""",")
			//w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")	
				
			w ..TrimEnter("""PAAdmWard"":"""_##class(User.PACWard).GetTranByDesc("WARDDesc",$g(result.Data("PAAdmWard")),langid)_""",")
			w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
			w ..TrimEnter("""PAAdmDoc"":"""_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,$g(result.Data("PAAdmDoc")))_""",")
			w ..TrimEnter("""DeathFlag"":"""_##class(websys.Translation).Get("",$g(result.Data("DeathFlag")))_""",")
			w ..TrimEnter("""NurSubmit"":"""_##class(websys.Translation).Get("",NurFlag)_""",")
			w ..TrimEnter("""DocSubmit"":"""_##class(websys.Translation).Get("",DocFlag)_""",")
			w ..TrimEnter("""ScanFlag"":"""_##class(websys.Translation).Get("",$g(result.Data("ScanFlag")))_""",")
			s timeliness = $g(result.Data("SubmitTime"))
			if (timeliness'="")
			{
				s timeliness = $REPLACE(timeliness,"超期",##class(websys.Translation).Get("","超期"))
				s timeliness = $REPLACE(timeliness,"出院",##class(websys.Translation).Get("","出院"))
				s timeliness = $REPLACE(timeliness,"天",##class(websys.Translation).Get("","天"))
			}
			w ..TrimEnter("""SubmitTime"":"""_timeliness_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}
