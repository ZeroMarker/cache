Class DHCEPRFS.ThirdParty.BL.QYFYCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport("18739117_11")
ClassMethod RegLateReportEpisode(AEpisodeID As %String, AType As %String) As %String
{
	//b "s"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if ((hospitalFlag = "QYFY") || (hospitalFlag = "NYFY"))
	{
		//判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
		s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)	
		q:(dischgdate = "") "1"
		
		//判断是否已经加入待生成队列还未生成
		s result = ##class(DHCEPRFS.BL.BLAdmMRStatus).CheckTaskQueueByEpisode(AEpisodeID)
		if (result '= "0")
		{	
			//不等于0表示待生成队列中有此次就诊,result为id，需要判断是否为此项目的迟归
			s objTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(result)
			s schemeType = objTaskQueue.SchemeType
			if (schemeType = AType)
			{
				//b "01"
				//有重复直接退出
				q "1"
			}
		}
		
	}
	
	s ret = ##class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID,AType)
	q ret
}

/// 第三方病理迟归，入参，医嘱号_
/// debug: w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLateReport("18739117_11")
ClassMethod RegLateReport(AOrdID As %String, AType As %String) As %String
{
	//b "s"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if (hospitalFlag = "QYFY")
	{
		s orderID = $p(AOrdID,"_",1)
	}
	else
	{
		s orderID = AOrdID	
	}
	
	s episodeID = ##class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetEpisodeIDByOrd(orderID)
	q:(episodeID = "") "0"
	
	if ((hospitalFlag = "QYFY") || (hospitalFlag = "NYFY"))
	{
		//判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
		s dischgdate=$P($G(^PAADM(episodeID)),"^",17)	
		q:(dischgdate = "") "1"
		
		//判断是否已经加入待生成队列还未生成
		s result = ##class(DHCEPRFS.BL.BLAdmMRStatus).CheckTaskQueueByEpisode(episodeID)
		if (result '= "0")
		{	
			//不等于0表示待生成队列中有此次就诊,result为id，需要判断是否为此项目的迟归
			s objTaskQueue = ##Class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(result)
			s schemeType = objTaskQueue.SchemeType
			if (schemeType = AType)
			{
				//b "01"
				//有重复直接退出
				q "1"
			}
		}
		
	}
	
	s ret = ##class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(episodeID,AType)
	q ret
}

/// 第三方病理迟归，入参，医嘱号前半部分	
/// debug: w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLatePISReport(6869394)
ClassMethod RegLatePISReport(AOrdID As %String) As %String
{
	s episodeID = ##class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetEpisodeIDByOrd(AOrdID)
	q:(episodeID = "") "0"
	
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(episodeID,"CREATEPIS")
	q ret
}

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInput(6869394)
/// "<Request><PatientId>0001740400</PatientId><OrdId>6463570</OrdId></Request>"
ClassMethod GetInput(AEpisodeID As %String) As %String
{
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	s regNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
	//q:(regNo = "") "-1"
	s orderRowid = $o(^OEORD(0,"Adm",AEpisodeID,""))
	q:(orderRowid = "") "-1"
	
	s ret = "<Request><PatientId>"_regNo_"</PatientId><OrdId>"_orderRowid_"</OrdId></Request>"
	q ret
}

/// debug: w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInputByTypeCode("12464426","CG63")
/// "<Request><PatientId>0001740400</PatientId><OrdId>6463570</OrdId></Request>"
ClassMethod GetInputByTypeCode(AEpisodeID As %String, ATypeCode As %String) As %String
{
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	s regNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
	//q:(regNo = "") "-1"
	s orderRowid = $o(^OEORD(0,"Adm",AEpisodeID,""))
	q:(orderRowid = "") "-1"
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	//温岭第一人民 上海杏和 检验
	if ((hospitalFlag = "WLDYRM")&&(ATypeCode = "CG94"))
	{
		s ret = "<Request><FunName>pdf</FunName><Params><Param Name=""his_id"" Value="""_orderRowid_"""/></Params></Request>"
	}
	//青医附院b超,宁医附院心电图
	elseif ((ATypeCode = "CG95")||(ATypeCode = "CG88"))
	{
		//s ret = "<Request><OrdId>"_orderRowid_"</OrdId></Request>"
		s ret = orderRowid
	}
	elseif (ATypeCode = "CG59")&&(hospitalFlag = "SDLKRMYY")
	{
		s ret = orderRowid
	}
	//青医附院病理,宁医附院内镜
	elseif ((ATypeCode = "CG59") || (ATypeCode = "CG60") || (ATypeCode = "CG64") || (ATypeCode = "CG89") || (ATypeCode = "CG90") || (ATypeCode = "CG86"))
	{
		s ret = "<Request><OrdId>"_orderRowid_"</OrdId></Request>"
	}
	elseif (ATypeCode = "CG65")
	{
		s ret = "<Request><OrdId>"_AEpisodeID_"</OrdId></Request>"
	}	
	elseif (ATypeCode = "CG63")
	{
		s ret = "<Request><PatientID>"_regNo_"</PatientID><VisitNo>"_AEpisodeID_"</VisitNo><VisitDate></VisitDate></Request>"
	}
	//东营胎心监护
	elseif (ATypeCode = "CG66")
	{
		s AdmNo = ""
		&sql(select PAADM_ADMNo into :AdmNo from SQLUser.PA_ADM where PAADM_RowID = :AEpisodeID)
		s ret = AdmNo_".pdf"
	}
	elseif (ATypeCode = "CG84")
	{
		s admDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(AEpisodeID)
		s admDate = $p(admDateTime,",",1)
		s:(admDate '= "") admDate = $zd(admDate,3)
		s admTime = $p(admDateTime,",",2)
		s:(admTime '= "") admTime = $zt(admTime,1)
		s admDateTime = admDate_" "_admTime
		s disDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID)
		s disDate = $p(disDateTime,",",1)
		s:(disDate '= "") disDate = $zd(disDate,3)
		s disTime = $p(disDateTime,",",2)
		s:(disTime '= "") disTime = $zt(disTime,1)
		s disDateTime = disDate_" "_disTime
		s nowDate = $p($h,",",1)
		s nowDateStr = $zd(nowDate,3)
		s nowTime = $p($h,",",2)
		s nowTimeStr = $zt(nowTime,1)
		s nowDateTime = nowDateStr_" "_nowTimeStr
		
		s obj = ##class(DHCEPRFS.ThirdParty.INST.ThirdMessage).%New()
		s obj.EpisodeID = AEpisodeID
		s obj.PatientID = patientID
		s obj.ActDate = nowDate
		s obj.ActTime = nowTime
		s obj.AdmDateTime = admDateTime
		s obj.DisDateTime = disDateTime
		d obj.%Save()
		s id = obj.%Id()
		s messageID = nowDateTime_"_"_id
		
		s ret = "<MESSAGE>"_
				"<ID VALUE=""HIS_REPORT_REQUEST"" />"_
				"<CREATETIME VALUE="""_nowDateTime_""" />"_
				"<SEQUENCEID VALUE="""_messageID_""" />"_
				"<RECEIVER VALUE=""ICCA""/>"_
				"<SENDER VALUE=""HIS""/>"_
				"<REQUEST>"_
				"<ROWID VALUE="""_patientID_"""/>"_
				"<STARTDATETIME VALUE="""_admDateTime_"""/>"_
				"<ENDDATETIME VALUE="""_disDateTime_"""/>"_
				"</REQUEST>"_
				"</MESSAGE>"
				
		s obj.SequeueID = messageID
		s obj.RequestXML = ret
		d obj.%Save()
	}
	elseif (ATypeCode = "CG38")
	{
		s ret = "<Request><OrdId>"_orderRowid_"</OrdId></Request>"
	}
	elseif (ATypeCode = "CG94")&&(hospitalFlag = "SDLKRMYY")
	{
		s ret = orderRowid
	}
	//青医附院检查
	elseif (ATypeCode = "CG93")
	{
		s ret = "<Request><PatientId>"_regNo_"</PatientId><OrdId>"_orderRowid_"</OrdId></Request>"
	}
	elseif ((ATypeCode = "CG02")||(ATypeCode="CG09")||(ATypeCode="CG13") ||(ATypeCode="CG53"))  //检验报告、病理报告、输血申请、发血申请单、发血单
	{
		s ret = AEpisodeID
	}
	elseif ((ATypeCode="CG08")||(ATypeCode="CG15")||(ATypeCode="CG24")||(ATypeCode="CG29")||(ATypeCode="CG25")||(ATypeCode="CG28")||(ATypeCode="CG30")||(ATypeCode="CG81")||(ATypeCode="CG55")) //手麻、重症
	{
		q AEpisodeID
	}
	elseif (ATypeCode="CG10")  //心电图
	{
		q AEpisodeID
	}
	elseif ((ATypeCode="CG01A")||(ATypeCode="CG01B")||(ATypeCode="CG01C")||(ATypeCode="CG01"))  //检查报告
	{
		q AEpisodeID
	}
	else
	{
		s ret = "<Request><AdmNo>"_AEpisodeID_"</AdmNo></Request>"
	}
	q ret
}

/// debug:w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetErrFTPPathSXML()
ClassMethod GetErrFTPPathSXML() As %String
{
	s ret = "<Response><PathCount>0</PathCount></Response>&<Response><PathCount>0</PathCount><PathList><Path><FilePath></FilePath></Path></PathList></Response>&<?xml version='1.0' encoding='UTF-8'?><Response><!--返回代码 -1：未检索到报告信息 1：成功 --><ReturnCode>-1</ReturnCode><!--返回描述 --><ReturnDesc>未检索到报告信息！</ReturnDesc></Response>"
	q ret
}

/// 记录有问题的第三方生成
/// 入参：IP - 服务器地址、FTPPathSXML - 第三方FTP路径、TypeCode - 项目编码、EpisodeID - 就诊号、PatientID - 病人号
/// 返回值 1 - 成功， 0 - 失败
/// debug w ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegErr3rdCreate("192.168.1.1","xxx","CJ07","583","500306")
ClassMethod RegErr3rdCreate(AIP As %String, AFTPPathSXML As %String, ATypeCode As %String, AEpisodeID As %String, APatientID As %String, AFTPPath As %String = "", AErrorType As %String = "") As %String
{
	
	s:(AIP = $c(0)) AIP = ""
	s:(AFTPPathSXML = $c(0)) AFTPPathSXML = ""
	s:(ATypeCode = $c(0)) ATypeCode = ""
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s:(APatientID = $c(0)) APatientID = ""
	
	s obj=##class(DHCEPRFS.ThirdParty.INST.Err3rdCreateLog).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.FTPPathSXML = AFTPPathSXML
	s obj.IP = AIP
	s obj.PatientID = APatientID
	s obj.TypeCode = ATypeCode
	s obj.OneFTPPath = AFTPPath
	s obj.ErrorType = AErrorType	
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(APatientID,"",AEpisodeID)
	s obj.MedRecordNo = medRecordNo
	
	s obj.RegDate = $p($h,",",1)
	s obj.RegTime = $p($h,",",2)
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// 获取有问题的第三方生成
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.ThirdParty.BL.QYFYCommon","GetErr3rdCreateLog","2015-1-1","2016-10-31")
Query GetErr3rdCreateLog(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "IP:%String,PatientID:%String,EpisodeID:%String,TypeDesc:%String,FTPPathSXML:%String,RegDate:%String,RegTime:%String,OneFTPPath:%String,MedRecordNo:%String,ErrorType:%String")
{
}

ClassMethod GetErr3rdCreateLogExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	
	for date = AStartDate:1:AEndDate
 	{
	 	s time = ""
	 	for {
		 	s time = $O(^DHCEPRFS.INST.Err3rdCreateLogI("IdxMain",date,time))
		 	q:(time="")
		 	s rowID = ""
		 	for {
		 		s rowID = $O(^DHCEPRFS.INST.Err3rdCreateLogI("IdxMain",date,time,rowID))
		 		q:(rowID= "")
		 		s obj = ##class(DHCEPRFS.ThirdParty.INST.Err3rdCreateLog).%OpenId(rowID)
		 		s IP = obj.IP
		 		s PatientID = obj.PatientID
		 		s EpisodeID = obj.EpisodeID
		 		//s FTPPathSXML = obj.FTPPathSXML
		 		s FTPPathSXML = ""
		 		s RegDate = obj.RegDate
				if (RegDate '= "")
				{
					s RegDate = $ZD(RegDate,3)
				}
				s RegTime = obj.RegTime
				if (RegTime '="")
				{
					s RegTime = $ZT(RegTime,3)
				}
				s OneFTPPath = obj.OneFTPPath
				s ErrorType = obj.ErrorType
				if (ErrorType = "NOTEXIST")
				{
					s ErrorType = "不存在"
				}
				elseif (ErrorType = "ERROR")
				{
					s ErrorType = "存在但报错"
				}
				s MedRecordNo = obj.MedRecordNo
				s TypeCode = obj.TypeCode
				s firstCode = $e(TypeCode,3)
				s secondCode = $e(TypeCode,4)
				s TypeCode = firstCode_secondCode
				s rowIDTypeCode = ""
				s rowIDTypeCode = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_TypeCode,rowIDTypeCode))
				q:(rowIDTypeCode="")
				s objTypeCode = ##class(DHCEPRFS.META.CTItemType).%OpenId(rowIDTypeCode)
				s TypeDesc = objTypeCode.TypeDesc
				
				s data = $lb(IP,PatientID,EpisodeID,TypeDesc,FTPPathSXML,RegDate,RegTime,OneFTPPath,MedRecordNo,ErrorType)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1
		 	}		
	 	}		 
	}
	Quit $$$OK
}

ClassMethod GetErr3rdCreateLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetErr3rdCreateLogExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetErr3rdCreateLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetErr3rdCreateLogExecute ]
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

}
