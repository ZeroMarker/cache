/// 门诊补打页面后台逻辑
Class EMRservice.BL.opPrintSearch Extends %RegisteredObject
{

/// 多选打印界面使用
/// w ##class(EMRservice.BL.opPrintSearch).GetOPPatAllPrintList("","测1102","","2015-05-01","2016-01-22")
ClassMethod GetOPPatAllPrintList(APapmiNo As %String, AName As %String, ACardID As %String, AStartDate As %String, AEndDate As %String, AIdCard As %String) As %String
{
	q:(APapmiNo="")&&(ACardID="")&&(AName="")&&(AIdCard="") "{""total"":0,""rows"":[]}"
	
	s StartDate = $Case(AStartDate,"":$p($h,",",1),:$zdh(AStartDate,3))
	s EndDate = $Case(AEndDate,"":$p($h,",",1),:$zdh(AEndDate,3))
	
	s count = 0, cjson = "", countflag=1
	
	// 新建一个队列，为了按照就诊日期和就诊时间排序
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	
	// 登记号不为空，按照登记号查所有就诊记录
	if (APapmiNo'=""){
		
		s PapmiNo = $O(^PAPERi("PAPMI_PatNo",APapmiNo,""))
		q:(PapmiNo="") "{""total"":0,""rows"":[]}"
		
		d GetAllEpisodeID
	}
	// 卡号不为空就按照卡号查
	elseif (ACardID'=""){
		
		s CFRowID = ""
		for {
			s CFRowID = $O(^DHCCARDi("CF",0,"CardNo",ACardID,CFRowID),-1)
			q:(CFRowID="")
			s PapmiNo = $P(^DHCCARD("CF",CFRowID),"^",4)
			q:(PapmiNo="")
			
			d GetAllEpisodeID
		}
	}
	// 姓名不为空就按照姓名查
	elseif (AName'=""){
		
		//s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
		s PapmiNo = ""
		for {
			
			s PapmiNo = $O(^PAPERi("PAPER_PatName",$zstrip($zcvt(AName,"U"),"*p"),PapmiNo),-1)
			q:(PapmiNo = "")
			
			d GetAllEpisodeID
		}
	}
    // 身份证号不为空就按照身份证号查
    elseif (AIdCard'=""){
        // 天津武清中医项目提供非标准的身份证号查询接口方法
        // d ##class(%ResultSet).RunQuery("web.Test","getAdmNoByIdCardQuery",AIdCard)
        s ds = ##Class(%ResultSet).%New("web.Test:getAdmNoByIdCardQuery")
        d ds.Execute(AIdCard)
        While (ds.Next()){
            s episodeid = ds.Data("PAADM_RowID")
            continue:(episodeid="")
            //过滤退号就诊
            s admStatus = $p($g(^PAADM(episodeid)),"^",20)
            continue:(admStatus = "C")
            // 按照时间倒叙
            s Time = "000000"_$P($G(^PAADM(episodeid)),"^",7)
            s Time = $E(Time,$L(Time)-5,$L(Time))
            s Date = $P($G(^PAADM(episodeid)),"^",6)
            s key = Date_Time
            continue:(Date < StartDate)
            continue:(Date > EndDate)
            d episodeIDs.SetAt(episodeid, key)
        }
    }
	
	d GetSortEpisode

	q "{""total"":"_count_",""rows"":["_cjson_"]}"

GetAllEpisodeID
	s AdmType = "O" , episodeid = ""
	for {
		s episodeid = $O(^PAPERdr(PapmiNo,"ADM",AdmType,episodeid),-1)
		if (episodeid="") {
		
	 		if (AdmType = "O"){ 
	 		
	 			s AdmType = "E"
	 			s episodeid=""
	 			continue
	 		} 
			else { q }
		}
        //过滤退号就诊
        s admStatus = $p($g(^PAADM(episodeid)),"^",20)
        continue:(admStatus = "C")
		// 按照时间倒叙
		s Time = "000000"_$P($G(^PAADM(episodeid)),"^",7)
		s Time = $E(Time,$L(Time)-5,$L(Time))
		s Date = $P($G(^PAADM(episodeid)),"^",6)
		s key = Date_Time
		continue:(Date < StartDate)
		continue:(Date > EndDate)
 		d episodeIDs.SetAt(episodeid, key)
 	}
	
 	q
	 	
GetSortEpisode	
	s key=""
	while (1){
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeid=episodeIDs.GetAt(key)
		q:(countflag=31)
		d outputrow(episodeid)	
	}
	
	q
		
outputrow(episodeid)

	s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo,RegNo) = ""
	
	s EpisodeID=episodeid
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
    
	//卡号
	s CardNo = ACardID //##class(EMRservice.HISInterface.PatientInfoAssist).GetCardNo(PapmiDR)
	
	//病案号
	s RegNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	
	//姓名
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	//性别
	s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
	s:(Gender'="") GenderDesc = $P(Gender,"^",3)
	
	//年龄
	s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID, "")
	s admDate = $P(admDate, ",", 1)
	s Age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,EpisodeID,"","")
	
	//就诊日期,时间
	s AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
	s AdmDate = $P(AdmDateTime,",",1)
	s AdmDate = $zd(AdmDate,3)
	
	s AdmTime = $P(AdmDateTime,",",2)
	s AdmTime = $ZT(AdmTime)
	
	//科室
	s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
	s DeptDesc = $P(tmpDisDept,"^",3)
	
	//主管医师
	s AdmDocDesc = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
	s AdmDocDesc = $P(AdmDocDesc,"^",3)
	
	//门诊诊断
	s OPDiagStringH = ""
    s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s tmpOPDiagDict = ##class(EMRservice.HISInterface.PatientInfoAssist).GetMRDiagnoseList(mradm,2,"OP")
	i tmpOPDiagDict'="" {
		s OPDiagLength = $L(tmpOPDiagDict,$C(1))
		f i = 1:1:OPDiagLength
		{
			s:(OPDiagStringH'="") OPDiagStringH = OPDiagStringH_","
			s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
		}
	}
	
	s AEpisodeID =""
	
	s flag = "N",ret = "",AStatus = "Save"
	//过滤掉未写门诊病历的记录
	s hasInstance = ##Class(EMRservice.Ajax.opInterface).getFirstInstance(EpisodeID)
	if (hasInstance '= "") {
		//循环获取保存状态下的实例ID
		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",EpisodeID," "_$zcvt(AStatus,"U"),date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",EpisodeID," "_$zcvt(AStatus,"U"),date,time))
				q:(time = "")
				s ecID = ""
				for
				{
					s ecID = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",EpisodeID," "_$zcvt(AStatus,"U"),date,time,ecID))
					q:(ecID = "")
					s insID = ""
					for
					{
						s insID = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",EpisodeID," "_$zcvt(AStatus,"U"),date,time,ecID,insID))
						q:(insID = "")

					 	s InstanceId = ecID_"||"_insID
	                    //打印次数
					 	s PrintNum=0
					 	s PrintNumID=""
					 	for {
						 	s PrintNumID=$o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_InstanceId,PrintNumID))
						 	q:(PrintNumID="")
						 	s PrintNum=PrintNum+1
					 	}
					 	
					 	//打印信息
					 	s (PrintRowId,PrintDate,PrintTime,PrintIp,PrintUserID,userName) = ""
					 	s PrintRowId = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_InstanceId,PrintRowId),-1)
				    	if (PrintRowId = "") {
					    	s PrintInfo = "未打印"
					    }else {
						 	s printobj = ##class(EMRinstance.Custom.SelfPrintLog).%OpenId(PrintRowId)
						 	s PrintDate = $Case(printobj.PrintDate,"":"",:$zd(printobj.PrintDate,3))
						 	s PrintTime = $Case(printobj.PrintTime,"":"",:$zt(printobj.PrintTime))
						 	s PrintIp = printobj.IPAddress
						 	s PrintUserID = printobj.UserID
						 	s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(printobj.UserID)
							s PrintInfo = "已打印"_PrintNum_"次|打印日期:"_PrintDate_"|打印时间:"_PrintTime_"|IP:"_PrintIp_"|打印者:"_userName
					 	}
 								 	
					 	//实例信息
					 	s InsObj = ##class(EMRinstance.InstanceData).%OpenId(InstanceId)
					 	s PageNum = InsObj.EndPageNum
				 		s InsText = InsObj.Title
				 		s:(InsText = "") InsText = InsObj.GroupItemName
				 		s CreateUser = InsObj.CreateUser
				 		s CreateUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(CreateUser)
				 						    	
			    		//是否允许多选打印标志 1允许 0不允许
				    	s IsAllowCheckPrint = ##class(EMRservice.BL.opInterface).IsAllowCheckPrint(InstanceId)
			    	
						s:(cjson '= "") cjson = cjson_","
						if (AEpisodeID = EpisodeID) {
							s cjson = cjson_"{"
							s cjson = cjson_ """PatientID"":"""_""_""""
							s cjson = cjson_ ",""EpisodeID"":"""_""_""""
							s cjson = cjson_ ",""mradm"":"""_""_""""
							s cjson = cjson_ ",""RegNo"":"""_""_""""
							s cjson = cjson_ ",""PAPMIName"":"""_""_""""
							s cjson = cjson_ ",""PAPMISex"":"""_""_""""
							s cjson = cjson_ ",""PAPMIAge"":"""_""_""""
							s cjson = cjson_ ",""PAAdmDate"":"""_""_""""
							s cjson = cjson_ ",""PAAdmTime"":"""_""_""""
							s cjson = cjson_ ",""PAAdmLoc"":"""_""_""""
							s cjson = cjson_ ",""PAAdmDoc"":"""_""_""""
							s cjson = cjson_ ",""Diagnosis"":"""_""_""""
							s cjson = cjson_ ",""EcID"":"""_ecID_""""
							s cjson = cjson_ ",""InsID"":"""_insID_""""
							s cjson = cjson_ ",""PageNum"":"""_PageNum_""""
							s cjson = cjson_ ",""IsAllowCheckPrint"":"""_IsAllowCheckPrint_""""
							s cjson = cjson_ ",""CreateUserName"":"""_CreateUserName_""""
							s cjson = cjson_ ",""Text"":"""_InsText_""""
							s cjson = cjson_ ",""PrintInfo"":"""_PrintInfo_""""
		            		s cjson = cjson_ "}"
						} else {
							s cjson = cjson_"{"
							s cjson = cjson_ """PatientID"":"""_PapmiDR_""""
							s cjson = cjson_ ",""EpisodeID"":"""_EpisodeID_""""
							s cjson = cjson_ ",""mradm"":"""_EpisodeID_""""
							s cjson = cjson_ ",""RegNo"":"""_RegNo_""""
							s cjson = cjson_ ",""PAPMIName"":"""_Name_""""
							s cjson = cjson_ ",""PAPMISex"":"""_GenderDesc_""""
							s cjson = cjson_ ",""PAPMIAge"":"""_Age_""""
							s cjson = cjson_ ",""PAAdmDate"":"""_AdmDate_""""
							s cjson = cjson_ ",""PAAdmTime"":"""_AdmTime_""""
							s cjson = cjson_ ",""PAAdmLoc"":"""_DeptDesc_""""
							s cjson = cjson_ ",""PAAdmDoc"":"""_AdmDocDesc_""""
							s cjson = cjson_ ",""Diagnosis"":"""_OPDiagStringH_""""
							s cjson = cjson_ ",""EcID"":"""_ecID_""""
							s cjson = cjson_ ",""InsID"":"""_insID_""""
							s cjson = cjson_ ",""PageNum"":"""_PageNum_""""
							s cjson = cjson_ ",""IsAllowCheckPrint"":"""_IsAllowCheckPrint_""""
							s cjson = cjson_ ",""CreateUserName"":"""_CreateUserName_""""
							s cjson = cjson_ ",""Text"":"""_InsText_""""
							s cjson = cjson_ ",""PrintInfo"":"""_PrintInfo_""""
		            		s cjson = cjson_ "}"
		            		s AEpisodeID = EpisodeID				
						}
	            		s count = count + 1
	            		s countflag = countflag + 1	         
					}
				}			    
			}
		}
	}
}

/// 单独打印界面使用
/// ///////////////	GetOPPatPrintList  //////////////////
/// w ##Class(EMRservice.BL.opPrintSearch).GetOPPatPrintList("","东测13","","2017-10-20","2017-10-26")
/// w ##Class(EMRservice.BL.opPrintSearch).GetOPPatPrintList("42045219","","","2017-10-20","2017-10-26")
/// w ##Class(EMRservice.BL.opPrintSearch).GetOPPatPrintList("","","287817030","2017-10-20","2017-10-26")
ClassMethod GetOPPatPrintList(APapmiNo As %String, AName As %String, ACardID As %String, AStartDate As %String, AEndDate As %String) As %String
{
	s SsGroup = %session.Data("LOGON.GROUPID")
	//s SsGroup="41o616CZ00" ;debugger
	q:(APapmiNo="")&&(ACardID="")&&(AName="") "{""total"":0,""rows"":[]}"
	
	s StartDate = $Case(AStartDate,"":$p($h,",",1),:$zdh(AStartDate,3))
	s EndDate = $Case(AEndDate,"":$p($h,",",1),:$zdh(AEndDate,3))
	
	s count = 0, cjson = "", countflag=1
	
	// 新建一个队列，为了按照就诊日期和就诊时间排序
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	
	// 登记号不为空，按照登记号查所有就诊记录
	if (APapmiNo'=""){
		
		s PapmiNo = $O(^PAPERi("PAPMI_PatNo",APapmiNo,""))
		q:(PapmiNo="") "{""total"":0,""rows"":[]}"
		
		d GetAllEpisodeID
	}
	// 卡号不为空就按照卡号查
	elseif (ACardID'=""){
		
		s CFRowID = ""
		for {
			s CFRowID = $O(^DHCCARDi("CF",0,"CardNo",ACardID,CFRowID),-1)
			q:(CFRowID="")
			s PapmiNo = $P(^DHCCARD("CF",CFRowID),"^",4)
			q:(PapmiNo="")
			
			d GetAllEpisodeID
		}
	}
	// 姓名不为空就按照姓名查
	elseif (AName'=""){
		
		//s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
		s PapmiNo = ""
		for {
			s PapmiNo = $O(^PAPERi("PAPER_PatName",$zstrip($zcvt(AName,"U"),"*p"),PapmiNo),-1)
			q:(PapmiNo = "")
			
			d GetAllEpisodeID
		}
	}
	
	d GetSortEpisode

	q "{""total"":"_count_",""rows"":["_cjson_"]}"

GetAllEpisodeID
	s AdmType = "O" , episodeid = ""
	for {
		s episodeid = $O(^PAPERdr(PapmiNo,"ADM",AdmType,episodeid),-1)
		if (episodeid="") {
		
	 		if (AdmType = "O"){ 
	 		
	 			s AdmType = "E"
	 			s episodeid=""
	 			continue
	 		} 
			else { q }
		}
        //过滤退号就诊
        s admStatus = $p($g(^PAADM(episodeid)),"^",20)
        continue:(admStatus = "C")
		// 按照时间倒叙
		s Time = "000000"_$P($G(^PAADM(episodeid)),"^",7)
		s Time = $E(Time,$L(Time)-5,$L(Time))
		s Date = $P($G(^PAADM(episodeid)),"^",6)
		s key = Date_Time
		continue:(Date < StartDate)
		continue:(Date > EndDate)
 		d episodeIDs.SetAt(episodeid, key)
 	}
	
 	q
	 	
GetSortEpisode	
	s key=""
	while (1){
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeid=episodeIDs.GetAt(key)
		q:(countflag=31)
		d outputrow(episodeid)	
	}
	
	q
		
outputrow(episodeid)

	s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo,RegNo) = ""
	
	s EpisodeID=episodeid
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	
    s InStanceID = ##class(EMRservice.BL.opInterface).GetSaveInstanceIDCount(EpisodeID)
    
	//卡号
	s CardNo = ACardID //##class(EMRservice.HISInterface.PatientInfoAssist).GetCardNo(PapmiDR)
	
	//病案号
	s RegNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	
	//姓名
	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	
	//性别
	s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
	s:(Gender'="") GenderDesc = $P(Gender,"^",3)
	
	// (用以计算年龄)入院日期时间	[AdmDateTime]		PAAdm_AdmDate And PAAdm_AdmTime 
	s AdmDate = "", AdmTime = ""
	s AdmDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID) //入院时间取入院分床时间
	if AdmDateTime'="" 
	{ 
			// 入院日期内部格式
			s AdmDate = $P($G(AdmDateTime),"^",1)
			s AdmDate = $zd(AdmDate,3)
			// 入院时间内部格式 
			s AdmTime = $P($G(AdmDateTime),"^",2)
			s AdmTime = $ZT(AdmTime)
	}
	//就诊日期,时间
	//s AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
	//s AdmDate = $P($G(AdmDateTime),",",1)
	//s AdmTime = $P($G(AdmDateTime),",",2)

	//年龄
	s Age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(PapmiDR,EpisodeID,AdmDate,AdmTime)
	
	//科室
	s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
	s DeptDesc = $P(tmpDisDept,"^",3)
	
	//主管医师
	s AdmDocDesc = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
	s AdmDocDesc = $P(AdmDocDesc,"^",3)
	
	//门诊诊断
	s OPDiagStringH = ""
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s tmpOPDiagDict = ##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(mradm,2,"OP")
	i tmpOPDiagDict'="" {
		s OPDiagLength = $L(tmpOPDiagDict,$C(1))
		f i = 1:1:OPDiagLength
		{
			s:(OPDiagStringH'="") OPDiagStringH = OPDiagStringH_","
			s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
		}
		
	}
	s flag = "N",ret = ""
	//过滤掉未写门诊病历的记录
	s hasInstance = ##Class(EMRservice.Ajax.opInterface).getFirstInstance(EpisodeID)
	if (hasInstance '= "") {
		s flag = "Y"
		s CategoryID = ""
		for {
			s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID, CategoryID))
			q:(CategoryID="")
			s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID, CategoryID, ""))
			s id = "" 
			for {
				s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID", CategoryID, id))
				q:(id="")
				s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
				s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
				s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
				s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
				s ecID = $tr(ecRecordID," ","")
			    s insID = ""
			    for {
					s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID))	   
			 		q:(""=insID)
				 	s InstanceId = ecID_"||"_insID
                    //打印次数
				 	s PrintNum=0
				 	s PrintNumID=""
				 	for {
					 	s PrintNumID=$o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_InstanceId,PrintNumID))
					 	q:(PrintNumID="")
					 	s PrintNum=PrintNum+1
				 	}
				 	//打印信息
				 	s (PrintRowId,PrintDate,PrintTime,PrintIp,PrintUserID,userName) = ""
				 	s PrintRowId = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_InstanceId,PrintRowId),-1)
				 	if (PrintRowId'="") {
					 	s printobj = ##class(EMRinstance.Custom.SelfPrintLog).%OpenId(PrintRowId)
					 	s PrintDate = $Case(printobj.PrintDate,"":"",:$zd(printobj.PrintDate,3))
					 	s PrintTime = $Case(printobj.PrintTime,"":"",:$zt(printobj.PrintTime))
					 	s PrintIp = printobj.IPAddress
					 	s PrintUserID = printobj.UserID
					 	s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(printobj.UserID)
				 	}
				 	//s PrintDate = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID",InstanceId,PrintDate),-1)
				 	//s:(PrintDate'="") PrintTime = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID",InstanceId,PrintDate,""),-1)
				 	//s:(PrintTime'="") PrintIp = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID",InstanceId,PrintDate,PrintTime,""),-1)
				 	s:(ret'="") ret = ret_","
					s ret = ret_"{""InstanceId"":"""_InstanceId_""","
					s ret = ret_"""Text"":"""_cateChapter.CategoryName_""","
                    s ret = ret_"""PrintNum"":"""_PrintNum_""","
					s ret = ret_"""PrintDate"":"""_PrintDate_""","
					s ret = ret_"""PrintTime"":"""_PrintTime_""","
					s ret = ret_"""PrintIp"":"""_PrintIp_""","
					s ret = ret_"""PrintUserID"":"""_PrintUserID_""","
					s ret = ret_"""PrintUserName"":"""_userName_""","
					s ret = ret_"""PrintedStatus"":"""_$Case(PrintRowId,"":"未打印",:"已打印")_"""}"
			    }
			}
		}
		if (ret '= "")
		{
            s:(cjson '= "") cjson = cjson_","
            s cjson = cjson_"{"
            s cjson = cjson_ """PatientID"":"""_PapmiDR_""""
            s cjson = cjson_ ",""EpisodeID"":"""_EpisodeID_""""
            s cjson = cjson_ ",""mradm"":"""_EpisodeID_""""
            s cjson = cjson_ ",""RegNo"":"""_RegNo_""""
            s cjson = cjson_ ",""PAPMIName"":"""_Name_""""
            s cjson = cjson_ ",""PAPMISex"":"""_GenderDesc_""""
            s cjson = cjson_ ",""PAPMIAge"":"""_Age_""""
            s cjson = cjson_ ",""PAAdmDate"":"""_AdmDate_""""
            s cjson = cjson_ ",""PAAdmTime"":"""_AdmTime_""""
            s cjson = cjson_ ",""PAAdmLoc"":"""_DeptDesc_""""
            s cjson = cjson_ ",""PAAdmDoc"":"""_AdmDocDesc_""""
            s cjson = cjson_ ",""Diagnosis"":"""_OPDiagStringH_""""
            s cjson = cjson_ ",""Flag"":"""_flag_""""
            s cjson = cjson_ ",""InsID"":"""_InStanceID_""""
            s cjson = cjson_ ",""Children"":["_ret_"]"
            s cjson = cjson_ "}"
            s count = count + 1
            s countflag = countflag +1
        }
    }
}

/// Input:        入参：登记号：      APapmiNo
///                     病案号：      AMedNo
///                     病人姓名：    AName
///                     病人身份证号：AIDCardNo
///                     病人就诊卡号：ACardNo
/// Others:       w ##class(EMRservice.BL.opPrintSearch).GetOPPatInfo("0000001338","","","","")
/// Others:       w ##class(EMRservice.BL.opPrintSearch).GetOPPatInfo("","002291","","","")
/// Others:       w ##class(EMRservice.BL.opPrintSearch).GetOPPatInfo("","","dd","","")
/// Others:       w ##class(EMRservice.BL.opPrintSearch).GetOPPatInfo("","","","123234444","")
/// Others:       w ##class(EMRservice.BL.opPrintSearch).GetOPPatInfo("","","","","000000000900")
/// Others:       d ##class(%ResultSet).RunQuery("EPRservice.DAL.GetPaAdmDetail","GetPaAdmList","","","0000001338","","","","","","O","","","all","")
ClassMethod GetOPPatInfo(APapmiNo As %String, AMedNo As %String, AName As %String, AIDCardNo As %String, ACardNo As %String) As %String
{
    s rtn = "["
    // 登记号, 病案号, 病人姓名, 病人身份证号, 病人就诊卡号
    s (PAPMINO, MedicareNo, PAPMIName, IDCardNo, CardNo) = ""
    if (APapmiNo '= "") {
        s PAPMIDR = ""
        for {
            s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",APapmiNo,PAPMIDR),-1)
            q:(PAPMIDR = "")
            s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
            continue:(PAPMINO '= APapmiNo)
            d outputrow
        }
    }elseif (AMedNo '= "") {
        s PAPMIDR = ""
        for {
			s PAPMIDR = ##class(EMRservice.HISinterface.PatientInfoAssist).GetPatientIDByMRNo(AMedNo)
            q:(PAPMIDR = "")
            d outputrow
        }
    }elseif (AName '= "") {
        s Name = $zcvt(AName,"u")
        s PAPMIDR = ""
        for {
            s PAPMIDR = $o(^PAPERi("PAPER_PatName",$zstrip(Name,"*p"),PAPMIDR),-1)
            q:(PAPMIDR = "")
            s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
            continue:(PAPMIName '= AName)
            d outputrow
        }
    }elseif (AIDCardNo '= "") {
        s PAPMIDR = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard(AIDCardNo)
        q:(PAPMIDR = "")
        s IDCardNo = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
        q:(IDCardNo '= AIDCardNo)
        d outputrow
    }elseif (ACardNo '= "") {
        s CFRowId = ""
        for {
            s CFRowId = $o(^DHCCARDi("CF",0,"CardNo",ACardNo,CFRowId),-1)
            q:(CFRowId = "")
            s PAPMIDR = $p($g(^DHCCARD("CF",CFRowId)),"^",4)
            q:(PAPMIDR = "")
            s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
            continue:(CardNo '= ACardNo)
            d outputrow
            
        }
    }
    
    q rtn_"]"
outputrow
    s PAPMINO = $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
    s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByPatientID(PAPMIDR)
    s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
    s IDCardNo = $p($g(^PAPER(PAPMIDR,"PAT",3)),"^",6)
    s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""))
    if (CFRowId '= "") {
        s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    }
    //PAPMIDR患者指针(即PatientID)
    if (rtn'="["){s rtn = rtn_","}
    s rtn = rtn_"{""PAPMIDR"":"""_PAPMIDR_""","
    s rtn = rtn_"""RegNo"":"""_PAPMINO_""","
    s rtn = rtn_"""MedNo"":"""_MedicareNo_""","
    s rtn = rtn_"""PatName"":"""_PAPMIName_""","
    s rtn = rtn_"""IDCardNo"":"""_IDCardNo_""","
    s rtn = rtn_"""CardNo"":"""_CardNo_"""}"
    q
}

}
