Class DHCEPRFS.BL.BLMREpisode Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeInfo("20","Name:a,EpisodeID:b,MedRecordNo:c,RegNo:d")
ClassMethod GetMREpisodeInfo(AMREpisodeID As %String, AColumns As %String) As %String
{
	s ret = ""
	q:(AMREpisodeID = "") ret
	q:(AColumns = "") ret
	
	for index=1:1:$l(AColumns,",")
	{
		//b "s"
		s oneItem = $p($p(AColumns,",",index),":",1)
		s itemValueList = $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLQueryClassMethod",oneItem,AMREpisodeID)
		s itemValue = $lg(itemValueList,1)
		
		if (ret = "")
		{
			s ret = itemValue	
		}
		else
		{
			s ret = ret_" "_itemValue
		}
	}
	q ret
}

/// Desc: 判断一个项目是否已生成
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist()
ClassMethod CheckMRItemExist(AMREpisodeID As %String, AMRItemID As %String)
{
	//b "s"
	s mrVersionID = $O(^DHCEPRFS.INST.MRVersionI("IdxMain", " "_AMREpisodeID, 0, ""))
	q:(mrVersionID = "") "0"
	
	s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_AMRItemID, ""))
	q:(mrVerItemID = "") "0"
	
	q "1"
}

/// Desc:	注册MREpisode对象并获取其实体对象	
ClassMethod RegMREpisode(APatientID As %String, AEpisodeID As %String, ASysCode As %String) As %String
{
}

ClassMethod RegAllScan(AInputParams) As %String
{
	if (AInputParams = $c(0)) s AInputParams = ""
	q:(AInputParams = "") "0"
	s flag = "true"
	TSTART
	for i=1:1:$l(AInputParams,"#")
	{
		s aParam = $p(AInputParams,"#",i)
		s AMrEpisodeID = $p(aParam,"|",1)
		s ATypeID = $p(aParam,"|",2)
		s APrintDocID = $p(aParam,"|",3)
		s ATotalPages = $p(aParam,"|",4)
		s ALogicID = $p(aParam,"|",5)
		s ALogicPath = $p(aParam,"|",6)
	
		s mrVerItemDetailID = ..RegWholeItemWOT("","",AMrEpisodeID,ATypeID,APrintDocID,ATotalPages,ALogicID,ALogicPath)
		if (mrVerItemDetailID = "")
		{
			s flag = "false"
			q	
		}
	}
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}
}

/// debug: w ##class(DHCEPRFS.BL.BLMREpisode).RegAllSub("97|DHC|ME|S|1|77|/93/97/epr/CGME_Single_93_97_S_Sserial_1.mp3|||c:\PDFXXX\CGME_Single_93_97_S_Sserial_1.mp3_97_9220c8e40180eb9e_201802081642524597_0.pdf|mhc/vo141/1947747/20180112161955.mp3#97|DHC|ME|S|1|78|||/93/97/epr/CGME_Single_93_97_S_Sserial_2.mp3|c:\PDFXXX\CGME_Single_93_97_S_Sserial_2.mp3_97_18b89dcb6636f177_201802081643194799_1.pdf|mhc/vo141/1947747/20180112154636.mp3")
ClassMethod RegAllSub(AInputParams As %String) As %String
{
	if (AInputParams = $c(0)) s AInputParams = ""
	q:(AInputParams = "") "0"
	s flag = "true"
	s params = ""
	for i=1:1:$l(AInputParams,"#")
	{
		s aParam = $p(AInputParams,"#",i)
		s AEpisodeID = $p(aParam,"|",1)
		s ASysCode = $p(aParam,"|",2) 
		s mrEpisodeID = ""
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))

		if (mrEpisodeID = "")
		{
			s flag = "false"
			q	
		}	
		
		if (params = "")
		{
			s params = aParam_"|"_mrEpisodeID	
		}
		else
		{
			s params = params_"#"_aParam_"|"_mrEpisodeID	
		}
	}

	q:(flag = "false") "0"
	
	s $ZTRAP = "OnRegAllSubError"
	s flag = "true"
	TSTART
	for i=1:1:$l(params,"#")
	{
		s aParam = $p(params,"#",i)
		s AEpisodeID = $p(aParam,"|",1)
		s ASysCode = $p(aParam,"|",2) 
		s ATypeID = $p(aParam,"|",3)
		s APrintDocID = $p(aParam,"|",4)
		s ATotalPages = $p(aParam,"|",5)
		s ALogicID = $p(aParam,"|",6)
		s ALogicPath = $p(aParam,"|",7)
		s AVersionTypeCode = $p(aParam,"|",8)
		s AMaxDetailNum = $p(aParam,"|",9)
		s AUniqueCode = $p(aParam,"|",10)
		s ADocumentID = $p(aParam,"|",11)
		s AMrEpisodeID = $p(aParam,"|",12)

		s mrVerItemDetailID = ##class(DHCEPRFS.BL.BLMRVerSubItem).RegSubVerItemWOT(AEpisodeID,ASysCode,AMrEpisodeID,ATypeID,APrintDocID,ATotalPages,ALogicID,ALogicPath,AVersionTypeCode,AMaxDetailNum,AUniqueCode,ADocumentID)
		if (mrVerItemDetailID = "")
		{
			s flag = "false"
			q	
		}
	}
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}
OnRegAllSubError
	TROLLBACK
	q "0"
}

/// d ##class(DHCEPRFS.BL.BLMREpisode).Test()
ClassMethod Test()
{
	s a = "7691950|DHC|07|266|4|2580831|/1922830/7691950/epr/CG07_Single_1922830_7691950_24_266_0-0_0.pdf||0#7691950|DHC|07|88|2|2580832|/1922830/7691950/epr/CG07_Single_1922830_7691950_66_88_0-0_0.pdf||0#7691950|DHC|07|96|1|2580833|/1922830/7691950/epr/CG07_Multiple_1922830_7691950_68_96_0-0_0.pdf||0#7691950|DHC|07|106|1|2580834|/1922830/7691950/epr/CG07_Single_1922830_7691950_74_106_0-0_0.pdf||0#7691950|DHC|07|198|1|2580835|/1922830/7691950/epr/CG07_Single_1922830_7691950_126_198_0-0_0.pdf||0#7691950|DHC|07|292|1|2580836|/1922830/7691950/epr/CG07_Single_1922830_7691950_156_292_0-0_0.pdf||0#7691950|DHC|07|108|1|2580837|/1922830/7691950/epr/CG07_Single_1922830_7691950_75_108_0-0_0.pdf||0#7691950|DHC|07|116|1|2580838|/1922830/7691950/epr/CG07_Single_1922830_7691950_77_116_0-0_0.pdf||0#7691950|DHC|04|1|2|2580839|/1922830/7691950/epr/CG04_Single_1922830_7691950_1_1_0-0_0.pdf||0#7691950|DHC|31|1|2|2580840|/1922830/7691950/epr/CG31_Single_1922830_7691950_1_1_0-0_0.pdf||0#7691950|DHC|32|1|7|2580841|/1922830/7691950/epr/CG32_Single_1922830_7691950_1_1_0-0_0.pdf||0#7691950|DHC|06|1|4|2580842|/1922830/7691950/epr/CG06_Single_1922830_7691950_1_1_0-0_0.pdf||0#7691950|DHC|61|1|3|2580843|/1922830/7691950/epr/CG61_Single_1922830_7691950_1_1_0-0_0.pdf||0#7691950|DHC|21|1|34|2580844|/1922830/7691950/epr/CG21_Single_1922830_7691950_1_1_0-0_0.pdf||0"
	w ##class(DHCEPRFS.BL.BLMREpisode).RegAll(a)
}

/// debug: w ##class(DHCEPRFS.BL.BLMREpisode).RegAll("582|DHC|07|630|1|433|/202/582/epr/CG07_Single_202_582_65_630_0-0_0.pdf||0#582|DHC|07|512|1|434|/202/582/epr/CG07_Single_202_582_7_512_0-0_0.pdf||0#582|DHC|07|522|1|435|/202/582/epr/CG07_Single_202_582_4_522_0-0_0.pdf||0#582|DHC|07|505|1|436|/202/582/epr/CG07_Multiple_202_582_3_505_0-0_0.pdf||0")
ClassMethod RegAll(AInputParams As %String) As %String
{
	
	if (AInputParams = $c(0)) s AInputParams = ""
	q:(AInputParams = "") "0"
	
	s flag = "true"
	s mrEpisodeID = ""
	s lastEpisodeID = ""
	s params = ""
	for i=1:1:$l(AInputParams,"#")
	{
		s aParam = $p(AInputParams,"#",i)
		s AEpisodeID = $p(aParam,"|",1)
		s ASysCode = $p(aParam,"|",2)
		 
		if (lastEpisodeID '= AEpisodeID)
		{
			s mrEpisodeID = ..RegMREpisodeIDByAdm(AEpisodeID,ASysCode)
		}
		
		if (mrEpisodeID = "")
		{
			s flag = "false"
			q	
		}
		
		s lastEpisodeID = AEpisodeID
	
		
		if (params = "")
		{
			s params = aParam_"|"_mrEpisodeID	
		}
		else
		{
			s params = params_"#"_aParam_"|"_mrEpisodeID	
		}
	}
	
	q:(flag = "false") "0"
	
	s $ZTRAP = "OnRegAllError"
	s flag = "true"
	TSTART
	for i=1:1:$l(params,"#")
	{
		s aParam = $p(params,"#",i)
		s AEpisodeID = $p(aParam,"|",1)
		s ASysCode = $p(aParam,"|",2) 
		s ATypeID = $p(aParam,"|",3)
		s APrintDocID = $p(aParam,"|",4)
		s ATotalPages = $p(aParam,"|",5)
		s ALogicID = $p(aParam,"|",6)
		s ALogicPath = $p(aParam,"|",7)
		s AVersionTypeCode = $p(aParam,"|",8)
		s AMaxDetailNum = $p(aParam,"|",9)
		s AMrEpisodeID = $p(aParam,"|",10)
	
		s mrVerItemDetailID = ..RegWholeItemWOT(AEpisodeID,ASysCode,AMrEpisodeID,ATypeID,APrintDocID,ATotalPages,ALogicID,ALogicPath,AVersionTypeCode,AMaxDetailNum)
		if (mrVerItemDetailID = "")
		{
			s flag = "false"
			q	
		}
	}
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}
OnRegAllError
	TROLLBACK
	q "0"
}

ClassMethod RegWholeItemWOT(AEpisodeID As %String, ASysCode As %String, AMrEpisodeID As %String, ATypeID As %String, APrintDocID As %String, ATotalPages As %String, ALogicID As %String, ALogicPath As %String, AVersionTypeCode As %String = "", AMaxDetailNum As %String = "") As %String
{
	s:(AMrEpisodeID = $c(0)) AMrEpisodeID = ""
	if (AMrEpisodeID = "")
	{
		s mrEpisodeID = ..RegMREpisodeIDByAdm(AEpisodeID,ASysCode)
	}
	else
	{
		s mrEpisodeID = AMrEpisodeID
	}
	

	s:(AVersionTypeCode = $c(0)) AVersionTypeCode = ""
	if (AVersionTypeCode = "")
	{
		s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(mrEpisodeID,"0")
	}
	else
	{
		//b "s"
		if ($l(AVersionTypeCode,"_")=1)
		{
			//s length = $l(AVersionTypeCode)
			//s versionNum = (+$e(AVersionTypeCode,length-1,length))
			s versionNum = ##class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByTypeCode(AVersionTypeCode)
			s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(mrEpisodeID,versionNum)
		}
		else
		{
			//b "s"
			s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(mrEpisodeID,AVersionTypeCode)
		}
	}
	
	s emrItem = ##class(DHCEPRFS.Entity.EMRItem).%New()
	s emrItem = ##class(DHCEPRFS.BL.BLMRItem).GetItemByType(ATypeID,APrintDocID)
	
	s amrItemID = emrItem.ID
	s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).RegMRVerItemID(mrVersionID,amrItemID,ATotalPages,ALogicID,ALogicPath)

	//获取此mrVerItem下最大的detailNum
	s detailNum = ""
	s maxDetailNum = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNum(mrVerItemID)
	s:(maxDetailNum = $c(0)) maxDetailNum = ""
	//若maxDetailNum为空表示第一次生成无历史版本，则应为版本0，否则当前版本应为最大版本+1
	if (maxDetailNum = "")
	{
		s detailNum = "0"	
	}
	else
	{
		//是否需要保留历史,默认不保留历史、覆盖原来的文件
		s isOverwrite = "1"
		s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
		if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
		{
			s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(mrEpisodeID,overwriteTimePoint)
			//查看日志设定增加版本动作已经发生，则新增版本
			if (hasAction = "1")
			{
				s isOverwrite = "0"
			}
		}
	
		if (isOverwrite = "1")
		{
			//在规定动作发生前，做覆盖
			s detailNum = +maxDetailNum
		}
		else
		{
			//在规定动作发生后，做新增版本
			s detailNum = +(maxDetailNum) + 1	
		}
	}

	s mrVerItemDetailID = ##class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailIDWOT(mrVerItemID,detailNum,ALogicID,ALogicPath,ATotalPages)

	q mrVerItemDetailID
}

ClassMethod RegWholeItem(AEpisodeID As %String, ASysCode As %String, AMrEpisodeID As %String, ATypeID As %String, APrintDocID As %String, ATotalPages As %String, ALogicID As %String, ALogicPath As %String) As %String
{
	s $ZTRAP = "OnRegWholeItem"
	
	TSTART
	s:(AMrEpisodeID = $c(0)) AMrEpisodeID = ""
	if (AMrEpisodeID = "")
	{
		s mrEpisodeID = ..RegMREpisodeIDByAdm(AEpisodeID,ASysCode)
	}
	else
	{
		s mrEpisodeID = AMrEpisodeID
	}
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(mrEpisodeID,"0")
	
	s emrItem = ##class(DHCEPRFS.Entity.EMRItem).%New()
	s emrItem = ##class(DHCEPRFS.BL.BLMRItem).GetItemByType(ATypeID,APrintDocID)
	
	s amrItemID = emrItem.ID
	s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).RegMRVerItemID(mrVersionID,amrItemID,ATotalPages)

	//获取此mrVerItem下最大的detailNum
	s detailNum = ""
	s maxDetailNum = ##class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNum(mrEpisodeID,mrVerItemID)
	s:(maxDetailNum = $c(0)) maxDetailNum = ""
	//若maxDetailNum为空表示第一次生成无历史版本，则应为版本0，否则当前版本应为最大版本+1
	if (maxDetailNum = "")
	{
		s detailNum = "0"	
	}
	else
	{
		//是否需要保留历史,默认不保留历史、覆盖原来的文件
		s isOverwrite = "1"
		s overwriteTimePoint = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("OverwriteTimePoint")
		if (overwriteTimePoint'="")&&(overwriteTimePoint'=$C(0))&&(overwriteTimePoint '= "NULL")
		{
			s hasAction = ##Class(DHCEPRFS.BL.BLMRLog).CheckAction(mrEpisodeID,overwriteTimePoint)
			//查看日志设定增加版本动作已经发生，则新增版本
			if (hasAction = "1")
			{
				s isOverwrite = "0"
			}
		}
	
		if (isOverwrite = "1")
		{
			//在规定动作发生前，做覆盖
			s detailNum = +maxDetailNum
		}
		else
		{
			//在规定动作发生后，做新增版本
			s detailNum = +(maxDetailNum) + 1	
		}
	}

	s mrVerItemDetailID = ##class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailIDWOT(mrVerItemID,detailNum,ALogicID,ALogicPath)
	if (mrVerItemDetailID '= "") 
	{	TCOMMIT}
	else  
	{	TROLLBACK}
	 
	q mrVerItemDetailID
	
OnRegWholeItem
	TROLLBACK
	Q ""
}

/// Desc:	注册MREpisode对象并获取其RowID
/// Debug:	w ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm("201868","DHC")
ClassMethod RegMREpisodeIDByAdm(AEpisodeID As %String, ASysCode As %String) As %String
{
	//b "s"
	s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
	q:(patientID = "") ""
	
	d ##class(DHCEPRFS.BL.BLAdmMRStatus).UpdateErrorEpisode(AEpisodeID)
	
	s mrEpisodeID = ..RegMREpisodeID(patientID, AEpisodeID, ASysCode)
	q mrEpisodeID
}

/// Desc:	注册MREpisode对象并获取其RowID
ClassMethod RegMREpisodeID(APatientID As %String, AEpisodeID As %String, ASysCode As %String) As %String
{
	s typeCode = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("MREpisodeFPTypeCode")

	//b "s"
	//注册MRPatient
	s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMRPatientID(APatientID, ASysCode,AEpisodeID)
	q:(mrPatientID = "") ""
	
	s medRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(APatientID,"",AEpisodeID)
	//注册MRMedRecord
	s mrMedRecordID = ##Class(DHCEPRFS.BL.BLMRMedRecord).RegMRMedRecord(mrPatientID,medRecordNo,ASysCode)
	
	//获取MREpisode
	s mrEpisodeID = ..GetMREpisodeID(mrPatientID, AEpisodeID, ASysCode)
	
	//MREpisode不存在，创建
	if (mrEpisodeID = "")
	{
		s mrEpisodeID = ..CreateMREpisode(mrPatientID, AEpisodeID, ASysCode, mrMedRecordID,typeCode)
		
		//注册MREpisodePat
		s mrEpisodePatID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMREpisodePatID(APatientID, ASysCode,AEpisodeID,mrPatientID,mrMedRecordID)
		
		//注册MREpisodeFee
		d ##Class(DHCEPRFS.BL.BLMREpisodeFee).CreateMREpisodeFee(mrPatientID, AEpisodeID, ASysCode,typeCode)
		
		//注册MREpisodeFP
		d ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateMREpisodeFP(mrPatientID, AEpisodeID, ASysCode,typeCode)	
		//加入全文检索队列
		d ##class(DHCEPRSearch.BL.BLSearch).Create(mrEpisodeID,"50")
	}
	else
	{
		s mrEpisodeID = ..UpdateMREpisode(mrEpisodeID, ASysCode)	
		s mrEpisodePatID = ##Class(DHCEPRFS.BL.BLMRPatient).UpdateMREpisodePat(APatientID,ASysCode,AEpisodeID)
	}
	
	q mrEpisodeID
}

/// Desc:	注册MREpisode对象并获取其RowID
ClassMethod RegMREpisodeByMRQ(AMedRecordNo As %String, APatientID As %String, AEpisodeID As %String, ASysCode As %String) As %String
{
	s typeCode = "MRQ"
	
	//注册MRPatient
	s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMRPatientID(APatientID, ASysCode,AEpisodeID)
	q:(mrPatientID = "") ""
	
	//注册MRMedRecord
	s mrMedRecordID = ##Class(DHCEPRFS.BL.BLMRMedRecord).RegMRMedRecord(mrPatientID,AMedRecordNo,ASysCode)
	
	//获取MREpisode
	s mrEpisodeID = ..GetMREpisodeID(mrPatientID, AEpisodeID, ASysCode)
	
	//MREpisode不存在，创建
	if (mrEpisodeID = "")
	{
		s mrEpisodeID = ..CreateMREpisode(mrPatientID, AEpisodeID, ASysCode, mrMedRecordID,typeCode)
		
		//注册MREpisodePat
		s mrEpisodePatID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMREpisodePatID(APatientID, ASysCode,AEpisodeID,mrPatientID,mrMedRecordID)
		
		
		//注册MREpisodeFee
		d ##Class(DHCEPRFS.BL.BLMREpisodeFee).CreateMREpisodeFee(mrPatientID, AEpisodeID, ASysCode,typeCode)
		
		//注册MREpisodeFP
		d ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateMREpisodeFP(mrPatientID, AEpisodeID, ASysCode,typeCode)	
		//加入全文检索队列
		//d ##class(DHCEPRSearch.BL.BLSearch).Create(mrEpisodeID,"50")
	}
	else
	{
		s source =""
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s:(obj '="") source = obj.Source
		s mrEpisodeID = ..UpdateMREpisode(mrEpisodeID, source)	
	}
	
	q mrEpisodeID
}

/// Debug: w ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm("6135188","DHC")
ClassMethod GetMREpisodeIDByAdm(AEpisodeID As %String, ASysCode As %String) As %String
{
	q:(AEpisodeID ="") ""
	s flag = $e(AEpisodeID,1,2)
	if (flag = "VE")
	{
		s rowID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " "_ASysCode, " "_AEpisodeID, ""))
		q rowID
	}
	else
	{
		s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
		q:(patientID = "") ""
	
		s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).GetMRPatientID(patientID)
		q:(mrPatientID = "") ""
	
		s mrEpisodeID = ..GetMREpisodeID(mrPatientID, AEpisodeID, ASysCode)
		q mrEpisodeID
	}
}

/// Desc:	获取MREpisodeID
ClassMethod GetMREpisodeID(AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	q:(AEpisodeID="") ""
	
	s rowID = $O(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID", " "_AMRPatientID, " "_ASysCode, " "_AEpisodeID, ""))
	q rowID
}

/// Desc:	通过MREpisodeID获取病案号
ClassMethod GetMedRecordNoByMrEpisodeID(AMrEpisodeID As %String) As %String
{
	s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMrEpisodeID)
	s medRecordNo = mrEpisodeObj.MedRecordNo
	q medRecordNo
}

/// Desc:	通过MREpisodeID获取登记号
ClassMethod GetRegNoByMrEpisodeID(AMrEpisodeID As %String) As %String
{
	s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMrEpisodeID)
	s mrPatientID = mrEpisodeObj.MRPatientID
	q:(mrPatientID = "") "-1"
	s mrPatientObj = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s regNo = mrPatientObj.RegNo
	q regNo
}

/// Desc:	通过MREpisodeID获取就诊号
ClassMethod GetEpisodeIDByMrEpisodeID(AMrEpisodeID As %String) As %String
{
	s mrEpisodeObj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMrEpisodeID)
	s episodeID = mrEpisodeObj.EpisodeID
	q episodeID
}

/// Desc:	通过MREpisodeID获取病案号
/// debug:  d ##class(DHCEPRFS.BL.BLMREpisode).GetMrEpisodeInfoByMrEpisodeID("13")
ClassMethod GetMrEpisodeInfoByMrEpisodeID(AMREpisodeID As %String) As DHCEPRFS.Entity.EMREpisode
{
	q:(AMREpisodeID = "")
	//b "s"
	s obj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s entity = ##Class(DHCEPRFS.Entity.EMREpisode).%New()
	s entity.MRPatientID = obj.MRPatientID
	s entity.MRMedRecordID = obj.MRMedRecordID
	s entity.SysCode = obj.SysCode
	s entity.EpisodeID = obj.EpisodeID
	s entity.CreateDate = obj.CreateDate 
	s entity.CreateTime = obj.CreateTime
	s entity.LastModifyDate = obj.LastModifyDate
	s entity.LastModifyTime = obj.LastModifyTime
	s entity.AdmNum = obj.AdmNum
	s entity.InNum = obj.InNum
	s entity.MedRecordNo = obj.MedRecordNo
	s entity.IPRecordNo = obj.IPRecordNo
	s entity.OPRecordNo = obj.OPRecordNo
	s entity.EPRecordNo = obj.EPRecordNo
	s entity.AdmDate = obj.AdmDate
	s entity.AdmTime = obj.AdmTime
	s entity.DisDate = obj.DisDate
	s entity.DisTime = obj.DisTime
	s entity.DisDateDoc = obj.DisDateDoc
	s entity.DisTimeDoc = obj.DisTimeDoc
	s entity.DeathDate = obj.DeathDate
	s entity.DeathTime = obj.DeathTime
	s entity.AdmLoc = obj.AdmLoc
	s entity.AdmWard = obj.AdmWard
	s entity.DisLoc = obj.DisLoc
	s entity.DisWard = obj.DisWard
	s entity.MainDoctor = obj.MainDoctor
	s entity.AdmType = obj.AdmType
	s entity.AdmLocID = obj.AdmLocID
	s entity.AdmWardID = obj.AdmWardID
	s entity.DisLocID = obj.DisLocID
	s entity.DisWardID = obj.DisWardID
	s entity.MainDoctorID = obj.MainDoctorID
	s entity.AdmTypeID = obj.AdmTypeID
	s entity.TransDept = obj.TransDept
	s entity.TransDeptID = obj.TransDeptID
	s entity.HospitalDays = obj.HospitalDays
	s entity.PayMode = obj.PayMode
	s entity.AllPay = obj.AllPay
	s entity.MedQuality = obj.MedQuality
	s entity.IsCritiCal = obj.IsCritiCal
	s entity.SeniorDocID = obj.SeniorDocID
	s entity.SeniorDoc = obj.SeniorDoc
	s entity.InHospitlDocID = obj.InHospitlDocID
	s entity.InHospitlDoc = obj.InHospitlDoc
	s entity.LocManagerID = obj.LocManagerID
	s entity.LocManager = obj.LocManager
	s entity.QualityDocID = obj.QualityDocID
	s entity.QualityDoc = obj.QualityDoc	
	s entity.MotherEpisodeID = obj.MotherEpisodeID
	s entity.AttendingDocID = obj.AttendingDocID
	s entity.AttendingDoc = obj.AttendingDoc
	s entity.InsuranceType = obj.InsuranceType
	s entity.InsuranceTypeCode = obj.InsuranceTypeCode
	s entity.PayModeCode = obj.PayModeCode
	s entity.InPatientWayCode = obj.InPatientWayCode
	s entity.InPatientWayDesc = obj.InPatientWayDesc
	
	q entity
}

/// Desc:	创建MREpisode
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisode).UpdateMREpisode("78757")
ClassMethod UpdateMREpisode(AMREpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	//b "s"
	//此处可通过适配器适配其他系统患者基本信息
	s obj = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s mrPatientID = obj.MRPatientID 
	s episodeID = obj.EpisodeID
	if (ASysCode = "MRQ")
	{
		s entity = ..CreateEMREpisodeMRQ("update",mrPatientID, episodeID, ASysCode)
	}
	else
	{
		s entity = ..CreateEMREpisodeDHC("update",mrPatientID, episodeID, ASysCode)
	}

	s obj.MRPatientID = entity.MRPatientID
	//s obj.MRMedRecordID = entity.MRMedRecordID
	s obj.SysCode = entity.SysCode
	s obj.EpisodeID = entity.EpisodeID
	s obj.AdmDate = entity.AdmDate
	s obj.AdmTime = entity.AdmTime
	s obj.CreateDate = entity.CreateDate
	s obj.CreateTime = entity.CreateTime 
	s obj.LastModifyDate = entity.LastModifyDate
	s obj.LastModifyTime = entity.LastModifyTime
	s obj.AdmNum = entity.AdmNum
	s obj.InNum = entity.InNum
	s obj.MedRecordNo = entity.MedRecordNo
	s obj.IPRecordNo = entity.IPRecordNo
	s obj.OPRecordNo = entity.OPRecordNo
	s obj.EPRecordNo = entity.EPRecordNo
	s obj.DisDate = entity.DisDate
	s obj.DisTime = entity.DisTime
	s obj.DisDateDoc = entity.DisDateDoc
	s obj.DisTimeDoc = entity.DisTimeDoc
	s obj.DeathDate = entity.DeathDate
	s obj.DeathTime = entity.DeathTime
	s obj.AdmLoc = entity.AdmLoc
	s obj.AdmWard = entity.AdmWard
	s obj.DisLoc = entity.DisLoc
	s obj.DisWard = entity.DisWard
	s obj.MainDoctor = entity.MainDoctor
	s obj.AdmType = entity.AdmType
	s obj.AdmLocID = entity.AdmLocID
	s obj.AdmWardID = entity.AdmWardID
	s obj.DisLocID = entity.DisLocID
	s obj.DisWardID = entity.DisWardID
	s obj.MainDoctorID = entity.MainDoctorID
	s obj.AdmTypeID = entity.AdmTypeID
	s obj.TransDept = entity.TransDept
	s obj.TransDeptID = entity.TransDeptID
	s obj.HospitalDays = entity.HospitalDays
	//2014-2-21 Add by liaowp
	s obj.PayMode = entity.PayMode
	s obj.AllPay = entity.AllPay

	s obj.MedQuality = entity.MedQuality
	s obj.IsCritiCal = entity.IsCritiCal
	s obj.SeniorDocID = entity.SeniorDocID
	s obj.SeniorDoc = entity.SeniorDoc
	s obj.InHospitlDocID = entity.InHospitlDocID
	s obj.InHospitlDoc = entity.InHospitlDoc
	s obj.LocManagerID = entity.LocManagerID
	s obj.LocManager = entity.LocManager
	s obj.QualityDocID = entity.QualityDocID
	s obj.QualityDoc = entity.QualityDoc
	//End Add
	s obj.MotherEpisodeID = entity.MotherEpisodeID
	s obj.AttendingDocID = entity.AttendingDocID
	s obj.AttendingDoc = entity.AttendingDoc
	s obj.InsuranceType = entity.InsuranceType
	s obj.InsuranceTypeCode = entity.InsuranceTypeCode
	s obj.PayModeCode = entity.PayModeCode
	s obj.FlagFinalAccountRemark = entity.FlagFinalAccountRemark
	s obj.InPatientWayCode = entity.InPatientWayCode
	s obj.InPatientWayDesc = entity.InPatientWayDesc
	
	if (hospitalFlag = "BJJYZX")
	{
		s obj.ImprisonID = ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).AddImprisonByPAAdm(episodeID)
	
	}
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	创建MREpisode
ClassMethod CreateMREpisode(AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String = "DHC", AMRMedRecordID As %String = "", ATypeCode As %String = "DHC") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	//从医政组首页数据池取信息
	if (ATypeCode = "MRQ")
	{
		s entity = ..CreateEMREpisodeMRQ("create",AMRPatientID, AEpisodeID, ASysCode,AMRMedRecordID)
	}
	//if (ATypeCode = "DHC")
	else
	{
		s entity = ..CreateEMREpisodeDHC("create",AMRPatientID, AEpisodeID, ASysCode,AMRMedRecordID)
	}
	s obj = ##Class(DHCEPRFS.INST.MREpisode).%New()
	s obj.MRPatientID = entity.MRPatientID
	s obj.MRMedRecordID = entity.MRMedRecordID
	s obj.SysCode = entity.SysCode
	s obj.EpisodeID = entity.EpisodeID
	s obj.AdmDate = entity.AdmDate
	s obj.AdmTime = entity.AdmTime
	s obj.CreateDate = entity.CreateDate
	s obj.CreateTime = entity.CreateTime 
	s obj.LastModifyDate = entity.LastModifyDate
	s obj.LastModifyTime = entity.LastModifyTime
	s obj.AdmNum = entity.AdmNum
	s obj.InNum = entity.InNum
	s obj.MedRecordNo = entity.MedRecordNo
	s obj.IPRecordNo = entity.IPRecordNo
	s obj.OPRecordNo = entity.OPRecordNo
	s obj.EPRecordNo = entity.EPRecordNo
	s obj.DisDate = entity.DisDate
	s obj.DisTime = entity.DisTime
	s obj.DisDateDoc = entity.DisDateDoc
	s obj.DisTimeDoc = entity.DisTimeDoc
	s obj.DeathDate = entity.DeathDate
	s obj.DeathTime = entity.DeathTime
	s obj.AdmLoc = entity.AdmLoc
	s obj.AdmWard = entity.AdmWard
	s obj.DisLoc = entity.DisLoc
	s obj.DisWard = entity.DisWard
	s obj.MainDoctor = entity.MainDoctor
	s obj.AdmType = entity.AdmType
	s obj.AdmLocID = entity.AdmLocID
	s obj.AdmWardID = entity.AdmWardID
	s obj.DisLocID = entity.DisLocID
	s obj.DisWardID = entity.DisWardID
	s obj.MainDoctorID = entity.MainDoctorID
	s obj.AdmTypeID = entity.AdmTypeID
	s obj.TransDept = entity.TransDept
	s obj.TransDeptID = entity.TransDeptID
	s obj.HospitalDays = entity.HospitalDays
	//2014-2-21 Add by liaowp
	s obj.PayMode = entity.PayMode
	s obj.AllPay = entity.AllPay

	s obj.MedQuality = entity.MedQuality
	s obj.IsCritiCal = entity.IsCritiCal
	s obj.SeniorDocID = entity.SeniorDocID
	s obj.SeniorDoc = entity.SeniorDoc
	s obj.InHospitlDocID = entity.InHospitlDocID
	s obj.InHospitlDoc = entity.InHospitlDoc
	s obj.LocManagerID = entity.LocManagerID
	s obj.LocManager = entity.LocManager
	s obj.QualityDocID = entity.QualityDocID
	s obj.QualityDoc = entity.QualityDoc
	//End Add
	s obj.MotherEpisodeID = entity.MotherEpisodeID
	s obj.AttendingDocID = entity.AttendingDocID
	s obj.AttendingDoc = entity.AttendingDoc
	s obj.InsuranceType = entity.InsuranceType
	s obj.InsuranceTypeCode = entity.InsuranceTypeCode
	s obj.PayModeCode = entity.PayModeCode
	s obj.FlagFinalAccountRemark = entity.FlagFinalAccountRemark
	s obj.InPatientWayCode = entity.InPatientWayCode
	s obj.InPatientWayDesc = entity.InPatientWayDesc
	s obj.Source = ATypeCode
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "BJJYZX")
	{
		s obj.ImprisonID = ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).AddImprisonByPAAdm(AEpisodeID)
	
	}
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod CreateEMREpisodeDHC(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String, AMRMedRecordID As %String = "") As DHCEPRFS.Entity.EMREpisode
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
	s PapmiDR = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPapmiDR(AEpisodeID)

	s entity = ##Class(DHCEPRFS.Entity.EMREpisode).%New()
	s entity.MRPatientID = AMRPatientID  //02
	s entity.MRMedRecordID = AMRMedRecordID
	s entity.SysCode = ASysCode
	s entity.EpisodeID = AEpisodeID
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AMRPatientID, " "_ASysCode, " "_AEpisodeID, ""))
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s entity.CreateDate = obj.CreateDate 
		s entity.CreateTime = obj.CreateTime
		d obj.%Close()	
	}
	s entity.LastModifyDate = $p($h,",",1)
	s entity.LastModifyTime = $p($h,",",2)
	s entity.AdmNum = ""
	if (hospitalFlag = "FCYY")
	{
		s entity.InNum = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).InTimesWMR(AEpisodeID)
	}
	else
	{
		s entity.InNum = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).InTimes(AEpisodeID)  //10
	}
	s patientID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
	s entity.MedRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
	s entity.IPRecordNo = ""
	s entity.OPRecordNo = ""
	s entity.EPRecordNo = ""
	s entity.AdmDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(AEpisodeID) //15
	s entity.AdmTime = $p(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(AEpisodeID),",",2)
	s DisDateTime = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID)
	s entity.DisDate = $P(DisDateTime,",",1)
	s entity.DisTime = $P(DisDateTime,",",2)
	s DeathDateTime = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(PapmiDR)
	s entity.DeathDate = $P(DeathDateTime,",",1)
	s entity.DeathTime = $P(DeathDateTime,",",2)
	s entity.AdmLoc = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(AEpisodeID,""),"^",3)  //21
	s entity.AdmWard = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmWard(AEpisodeID,""),"^",3)
	s entity.DisLoc = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(AEpisodeID,""),"^",3)
	s entity.DisWard = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisWard(AEpisodeID,""),"^",3)
	s entity.MainDoctor = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDoctor(AEpisodeID,""),"^",3)
	s AdmType = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmType(AEpisodeID)
	s entity.AdmType = $P(AdmType,"^",2)
	s entity.AdmTypeID = $P(AdmType,"^",1)
	s entity.AdmLocID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(AEpisodeID,""),"^",1)
	s entity.AdmWardID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmWard(AEpisodeID,""),"^",1)
	s entity.DisLocID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(AEpisodeID,""),"^",1)
	s entity.DisWardID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisWard(AEpisodeID,""),"^",1)  
	s entity.MainDoctorID = $P(##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDoctor(AEpisodeID,""),"^",1)  //31
	s TransDept = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).TransDeptDetail(AEpisodeID)
	s entity.TransDept = $P(TransDept,"^",2)
	s entity.TransDeptID = $P(TransDept,"^",1)
	s entity.HospitalDays = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).ResidentDaysAdm(AEpisodeID)  //35
	s entity.AllPay = $P($P(##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(AEpisodeID,""),"!",1),"^",3)
	s DisDateTimeDoc = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTimeDoctor(AEpisodeID)
	s entity.DisDateDoc = $P(DisDateTimeDoc,",",1)
	s entity.DisTimeDoc = $P(DisDateTimeDoc,",",2)

	s entity.PayMode = Glossary.GetAt("HDSD00.11.585")
	s entity.MedQuality = Glossary.GetAt("HDSD00.11.899")
	s entity.IsCritiCal = Glossary.GetAt("HDSD00.11.567")
	s entity.SeniorDocID = Glossary.GetAt("HDSD00.11.576")
	s entity.SeniorDoc = Glossary.GetAt("HDSD00.11.137")
	s entity.InHospitlDocID = Glossary.GetAt("HDSD00.11.578")
	s entity.InHospitlDoc = Glossary.GetAt("HDSD00.11.141")
	s entity.LocManagerID = Glossary.GetAt("HDSD00.11.575")
	s entity.LocManager = Glossary.GetAt("HDSD00.11.056")
	s entity.QualityDocID = Glossary.GetAt("HDSD00.11.583")
	s entity.QualityDoc = Glossary.GetAt("HDSD00.11.128")
	s entity.AttendingDocID = Glossary.GetAt("HDSD00.11.577")
	s entity.AttendingDoc = Glossary.GetAt("HDSD00.11.138")
	//End Add
	s entity.MotherEpisodeID = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetMotherAdmDR(AEpisodeID)
	 
	s entity.NoPlanAgainOp = Glossary.GetAt("HDSD00.11.823")
	s entity.InsuranceType = Glossary.GetAt("HDSD00.11.1249")
	s entity.InsuranceTypeCode = Glossary.GetAt("HDSD00.11.1248")
	s entity.PayModeCode = Glossary.GetAt("HDSD00.11.117")
	s entity.InPatientWayCode = Glossary.GetAt("HDSD00.11.086")
	//入院途径描述，1-急诊，2-门诊，3-其他医疗机构转入，9-其他
	s entity.InPatientWayDesc = ""
	if (entity.InPatientWayCode = "1")
	{
		s entity.InPatientWayDesc = "急诊"
	}
	elseif (entity.InPatientWayCode = "2")
	{
		s entity.InPatientWayDesc = "门诊"
	}
	elseif (entity.InPatientWayCode = "3")
	{
		s entity.InPatientWayDesc = "其他医疗机构转入"
	}
	elseif (entity.InPatientWayCode = "9")
	{
		s entity.InPatientWayDesc = "其他"
	}
	
	//增加对MRPatientIDCard的处理
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)
	if (objMRPatient'="")
	{
		s MRPatientIDCard=objMRPatient.IDCard	//取MRPatient的IDCard
	
		s GlossaryIDCard=Glossary.GetAt("HDSD00.11.048")	//取术语集中IDCard
	
		//术语集中的IDCard18位并且和MRPatient表中不一致的话，更新MRPatient的IDCard字段
		if (($l(GlossaryIDCard)=18)&&(MRPatientIDCard'=GlossaryIDCard))	
		{
			s objMRPatient.IDCard=GlossaryIDCard
			s sc=objMRPatient.%Save()
		}
	}
	//增加对MRPatientIDCard的处理 结束*******
	//增加护士标识，表示是否欠费，此标识来自DHCEPRFS.INST.AdmMRStatus，FlagFinalAccountRemark字段，由护士确认时传入，不会改变
	s admMRStatusID = ""
	s admMRStatusID = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetIDByEpisode(AEpisodeID, "DHC")
	if (admMRStatusID '= "")
	{
		s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
		s flag = objAdmMRStatus.FlagFinalAccountRemark
		s entity.FlagFinalAccountRemark = flag
			
	}
	q entity
}

ClassMethod CreateEMREpisodeMRQ(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String, AMRMedRecordID As %String = "") As DHCEPRFS.Entity.EMREpisode
{
	//获取就诊的首页数据
	s arr = ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm(AEpisodeID)

	s entity = ##Class(DHCEPRFS.Entity.EMREpisode).%New()
	s entity.MRPatientID = AMRPatientID  //02
	s entity.MRMedRecordID = AMRMedRecordID
	s entity.SysCode = ASysCode
	s entity.EpisodeID = AEpisodeID
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AMRPatientID, " "_ASysCode, " "_AEpisodeID, ""))
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s entity.CreateDate = obj.CreateDate 
		s entity.CreateTime = obj.CreateTime
		d obj.%Close()	
	}
	s entity.LastModifyDate = $p($h,",",1)
	s entity.LastModifyTime = $p($h,",",2)
	s entity.AdmNum = ""
	s entity.InNum = arr.GetAt("P00040000")
	s entity.MedRecordNo = arr.GetAt("P00050000")
	s entity.IPRecordNo = ""
	s entity.OPRecordNo = ""
	s entity.EPRecordNo = ""
	s entity.AdmDate = arr.GetAt("P00250000")
	s entity.AdmTime = arr.GetAt("P00250100")
	s entity.DisDate = arr.GetAt("P00290000")
	s entity.DisTime = arr.GetAt("P00290100")
	s entity.DeathDate = ""
	s entity.DeathTime = ""
	s entity.AdmLoc = arr.GetAt("P00260000")
	s entity.AdmLocID = arr.GetAt("P00260001")
	s entity.AdmWard = arr.GetAt("P00270000")
	s entity.AdmWardID = arr.GetAt("P00270001")
	s entity.DisLoc = arr.GetAt("P00300000")
	s entity.DisLocID = arr.GetAt("P00300001")
	s entity.DisWard = arr.GetAt("P00310000")
	s entity.DisWardID = arr.GetAt("P00310001") 
	s entity.MainDoctor = ""
	s entity.MainDoctorID = ""
	s entity.TransDept = arr.GetAt("P00280000") 
	s entity.TransDeptID = arr.GetAt("P00280001") 
	s entity.AdmType = ""
	s entity.AdmTypeID = ""
	s entity.HospitalDays = arr.GetAt("P00320000") 
	s entity.AllPay = ""
	s entity.DisDateDoc = arr.GetAt("P00290000")
	s entity.DisTimeDoc = arr.GetAt("P00290100")
	s entity.PayMode = arr.GetAt("P00020000")
	s entity.PayModeCode = arr.GetAt("P00020001")
	s entity.MedQuality = arr.GetAt("P00610000")
	s entity.IsCritiCal = ""
	s entity.SeniorDocID = arr.GetAt("P00600201")
	s entity.SeniorDoc = arr.GetAt("P00600200")
	s entity.InHospitlDocID = arr.GetAt("P00600401")
	s entity.InHospitlDoc = arr.GetAt("P00600400")
	s entity.LocManagerID = arr.GetAt("P00600101")
	s entity.LocManager = arr.GetAt("P00600100")
	s entity.QualityDocID = arr.GetAt("P00610101")
	s entity.QualityDoc = arr.GetAt("P00610100")
	s entity.AttendingDocID = arr.GetAt("P00600301")
	s entity.AttendingDoc = arr.GetAt("P00600300")
	//End Add
	s entity.MotherEpisodeID = ""
	 
	s entity.NoPlanAgainOp = ""
	s entity.InsuranceType = arr.GetAt("P00600300")
	s entity.InsuranceTypeCode = arr.GetAt("P00600300")

	s entity.InPatientWayCode = arr.GetAt("P00230001")
	s entity.InPatientWayDesc = arr.GetAt("P00230000")
	s entity.FlagFinalAccountRemark = ""
			
	q entity
}

/// Desc:	根据母亲的PatientID获取其新生儿子女的MRPatientID列表
/// Input:	ASysCode :  系统标识号
/// 		AEpisodeID :  患者就诊RowID
/// Return: 新生儿子女的MRPatientID列表,多个MRPatientID之间以^分割
/// Debug:	w ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByAdmID("DHC","1")
ClassMethod GetChildByAdmID(ASysCode As %String, AEpisodeID As %String) As %String
{
	s childMRAdmID = ""
	
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRFS.INST.MREpisodeI("IdxMotherEpisodeID", " "_ASysCode, " "_AEpisodeID, rowID))
		q:(rowID="")
		
		if (childMRAdmID = "")
		{	s childMRAdmID = rowID}
		else
		{	s childMRAdmID = childMRAdmID_"^"_rowID}	
	}
	
	q childMRAdmID
}

/// Desc:	根据母亲的MRPatientID获取其新生儿子女的MRPatientID列表
/// Input:	AMREpisodeID : 归档患者就诊RowID
/// Return: 新生儿子女的MREpisodeID列表,多个MREpisodeID之间以^分割
/// Debug:	w ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByMRAdmID("1")
ClassMethod GetChildByMRAdmID(AMREpisodeID As %String) As %String
{
	s childMRAdmID = ""
	
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") childMRAdmID
	
	s sysCode = objMREpisode.SysCode
	s admID = objMREpisode.EpisodeID
	
	s childMRAdmID = ..GetChildByAdmID(sysCode, admID)
	
	q childMRAdmID
}

ClassMethod GetPatName(AMREpisodeID As %String) As %String
{
	s name = ""
	
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMREpisode="") name
	
	s objMRPat = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
	q:(objMRPat="") name
	
	q objMRPat.Name
}

ClassMethod GetPatNameByAdm(AEpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " "_ASysCode, " "_AEpisodeID, ""))
	q:(mrEpisodeID="") ""
	
	s name =  ..GetPatName(mrEpisodeID)
	q name
}

/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisode","GetEpisodeList","17")
Query GetEpisodeList(AMRMedRecordNo As %String) As %Query(ROWSPEC = "IsCreated:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmLoc:%String,DisLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,MREpisodeID:%String,DeathDate:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, AMRMedRecordNo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	//获取所有就诊
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID", " "_AMRMedRecordNo, mrEpisodeID))
		q:(mrEpisodeID = "")
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s PAAdm = obj.EpisodeID
		if ($e(PAAdm,1,2) = "VE")
		{
			//虚拟就诊
			//若数据没有同步，同步EpisodePat中的数据
			s mrEpisodePatID = ""
			s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxEpisodeID"," "_PAAdm,mrEpisodePatID))
			if (mrEpisodePatID '= "")
			{
				s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(mrEpisodePatID)
				s medRecordNo = objMREpisodePat.MedRecordNo
				if ((medRecordNo = "") || (medRecordNo = $c(0)))
				{
					//更新数据
					s mrPatientID = objMREpisodePat.MRPatientID
					s mrMedRecordID = objMREpisodePat.MRMedRecordID
					s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
					s medRecordNo = objMRMedRecord.MedRecordNo
					d ##class(DHCEPRFS.BL.BLMRPatient).UpdateFSMREpisodePat(mrEpisodePatID,mrPatientID,	medRecordNo)
				}
			}
			
			d OutPutRowV
		}
		else
		{
			//实际就诊
			d OutPutRow
		}
	}
	Quit $$$OK
	
OutPutRowV
	s mrPatientID = obj.MRPatientID
	s objMRPateint = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s IsCreated = "Y"
	s PAAdmType = obj.AdmType
	s PAPMIName = objMRPateint.Name
	s PAPMINO = ""
	s PAPMIDOB = ""
	s PAPMIBirthday = objMRPateint.Birthday
	s:(PAPMIBirthday '= "") PAPMIDOB = $zd(PAPMIBirthday,3)
	s PAPMIAge = objMRPateint.Age
	s PAPMISex = objMRPateint.Gender
	s PAAdmDate = obj.AdmDate
	if (PAAdmDate '= "")
	{
		s PAPMIAge = $fn((+PAAdmDate-PAPMIBirthday)/365,"",0)
		s PAAdmDate = $zd(PAAdmDate,3)
	}
	s PAAdmTime = obj.AdmTime
	s:(PAAdmTime '= "") PAAdmTime = $zd(PAAdmTime,3)
	s PAAdmDateTime = PAAdmDate
	s PAAdmWard = obj.AdmWard
	s PAAdmLoc = obj.AdmLoc
	s DisLoc = obj.DisLoc
	s PAAdmDisDate = obj.DisDate
	s:(PAAdmDisDate '= "") PAAdmDisDate = $zd(PAAdmDisDate,3)
	s PAAdmDisTime = obj.DisTime
	s:(PAAdmDisTime '= "") PAAdmDisTime = $zd(PAAdmDisTime,3)
	s PADischgeDateTime = PAAdmDisDate
	s PAAdmDoc = obj.MainDoctor
	s PayMode = obj.PayMode
	s EpisodeID = obj.EpisodeID
	s DeathDate = obj.DeathDate
	s:(DeathDate '= "") DeathDate = $zd(DeathDate,3)
	
	s data = $lb(IsCreated,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmLoc,DisLoc,PADischgeDateTime,PAAdmDoc,PayMode,EpisodeID,mrEpisodeID,DeathDate)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
OutPutRow
	s IsCreated = "N"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAAdm,"DHC")
	if (mrEpisodeID '= "")
	{
		s IsCreated = "Y"
	}
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	
	s episodeInfo = ##class(%ArrayOfDataTypes).%New()
	s episodeInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(PAAdm)
	s PatientID = episodeInfo.GetAt("PatientID")
	s PAAdmType = episodeInfo.GetAt("PAAdmType")
	s PAPMIName = episodeInfo.GetAt("PAPMIName")
	s IdCardNo = episodeInfo.GetAt("IdCardNo")
	s PAPMINO = episodeInfo.GetAt("PAPMINO")
	s PAPMIDOB = episodeInfo.GetAt("PAPMIDOB")
	s PAPMIAge = episodeInfo.GetAt("PAPMIAge") 
	s PAPMISex =  episodeInfo.GetAt("PAPMISex")
	s Marriage = episodeInfo.GetAt("Marriage")
	s CityBirth = episodeInfo.GetAt("CityBirth")
	s ProvinceBirth = episodeInfo.GetAt("ProvinceBirth")
	s Occupation = episodeInfo.GetAt("Occupation")
	s Nation = episodeInfo.GetAt("Nation")
	s MobilePhone = episodeInfo.GetAt("MobilePhone")
	s PAAdmDateTime = episodeInfo.GetAt("PAAdmDateTime")
	s PAAdmWard = episodeInfo.GetAt("PAAdmWard")
	s PAAdmRoom = episodeInfo.GetAt("PAAdmRoom")
	s PAAdmBed = episodeInfo.GetAt("PAAdmBed")
	s PAAdmLoc = episodeInfo.GetAt("PAAdmLoc")
	s DisLoc = PAAdmLoc
	s PADischgeDateTime = episodeInfo.GetAt("PADischgeDateTime")
	s PAStatusType = episodeInfo.GetAt("PAStatusTypeDesc")
	s PAAdmDoc = episodeInfo.GetAt("PAAdmDoc")
	s PayMode = episodeInfo.GetAt("PayMode")
	s DeathDate = episodeInfo.GetAt("DeathDate")
	s data = $lb(IsCreated,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmLoc, DisLoc, PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,mrEpisodeID,DeathDate)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
	/*
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
	//就诊类型
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
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
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
 	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	//职业
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	s PAAdmDate = $P($g(^PAADM(PAAdm)),"^",6)
	if (PAAdmDate '= "")&&(DobDate '= "")
	{
		s PAPMIAge = $fn((+PAAdmDate-DobDate)/365,"",0)
	}
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
	}
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	//s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	s PAAdmDateTime = PAAdmDate
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	s DisLoc = PAAdmLoc
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	//s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	s PADischgeDateTime = $zd(PADischgeDate,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	s ^CacheTemp("PAStatusType") = PADischgeDateTime_"||"_PAStatusType
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
	
	s DeathDate = $p(^PAPER(PatientID,"ALL"),"^",13)
	s:(DeathDate '= "") DeathDate = $zd(DeathDate,3)
	
 	s data = $lb(IsCreated,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmLoc, DisLoc, PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,mrEpisodeID,DeathDate)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	*/
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
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

/// debug w ##class(DHCEPRFS.BL.BLMREpisode).AssignFSMREpisode("57","44","9","内三科","4","内一科","2015-4-5","2015-9-5","")
ClassMethod AssignFSMREpisode(AMRPatientID As %String, AMRMedRecordID As %String, AAdmLocID As %String, AAdmLoc As %String, ADisLocID As %String, ADisLoc As %String, AAdmDate As %String, ADisDate As %String, ADeathDate As %String = "") As %String
{
	s $ZTRAP = "OnAssignFSMREpisodeError"
	TSTART
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)
	s patientID = objMRPatient.PatientID
	s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(AMRMedRecordID)
	s medRecordNo = objMRMedRecord.MedRecordNo
	
	s obj = ##class(DHCEPRFS.INST.MREpisode).%New()
	s obj.SysCode = "DHC"
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.AdmLocID = AAdmLocID
	s obj.AdmLoc = AAdmLoc
	s obj.DisLocID = ADisLocID
	s obj.DisLoc = ADisLoc
	s:(AAdmDate '= "") AAdmDate = $zdh(AAdmDate,3)
	s:(ADisDate '= "") ADisDate = $zdh(ADisDate,3)
	s obj.AdmDate = AAdmDate
	s obj.DisDate = ADisDate
	s obj.DisDateDoc = ADisDate
	s obj.MedRecordNo = medRecordNo
	s obj.MRMedRecordID = AMRMedRecordID
	s obj.MRPatientID = AMRPatientID
	
	if (ADeathDate '= "")
	{
		s ADeathDate = $zdh(ADeathDate,3)	
		s obj.DeathDate = ADeathDate
	}
	else
	{
		s obj.DeathDate = ""	
	}
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s id =  obj.%Id()
		s episodeID = "VE"_id
		s obj.EpisodeID = episodeID
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			s ret = ##class(DHCEPRFS.BL.BLMRPatient).CreateFSMREpisodePat(id,episodeID,AMRPatientID,AMRMedRecordID,medRecordNo)
			if ((+ret<0) || (ret = ""))
			{
				TROLLBACK
				q "-1"	
			}
			s ret = ##class(DHCEPRFS.BL.BLMREpisodeFP).CreateFSMREpisodeFP(id,AMRPatientID)
			if ((+ret<0) || (ret = ""))
			{
				TROLLBACK
				q "-1"	
			}
			TCOMMIT
			q obj.%Id()
		}
		else
		{
			TROLLBACK
			q "-1"		
		}
	}
	else
	{
		TROLLBACK
		q "-1"	
	}
OnAssignFSMREpisodeError
	TROLLBACK
	q "-1"
}

ClassMethod ModifyEpisode(AEpisodeID, AAdmLocID As %String, AAdmLoc As %String, ADisLocID As %String, ADisLoc As %String, AAdmDate As %String, ADisDate As %String, ADeathDate As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC", " "_AEpisodeID, rowID))
	q:(rowID = "")
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.AdmLocID = AAdmLocID
	s obj.AdmLoc = AAdmLoc
	s obj.DisLocID = ADisLocID
	s obj.DisLoc = ADisLoc
	s:(AAdmDate '= "") AAdmDate = $zdh(AAdmDate,3)
	s:(ADisDate '= "") ADisDate = $zdh(ADisDate,3)
	s obj.AdmDate = AAdmDate
	s obj.DisDate = ADisDate
	
	if (ADeathDate '= "")
	{
		s ADeathDate = $zdh(ADeathDate,3)	
		s obj.DeathDate = ADeathDate
	}
	else
	{
		s obj.DeathDate = ""	
	}
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"	
	}
}

/// debug: w ##class(DHCEPRFS.BL.BLMREpisode).DeleteEpisode("VE248627")
ClassMethod DeleteEpisode(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") "-1"
	
	//不是录入的就诊不允许删除
	q:($e(AEpisodeID,1,2) '= "VE") "-2"
	
	//取归档就诊号
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,""))
	q:(mrEpisodeID = "") "-1"
	
	//先删除日志
	//mrLog
	s mrLogID = $o(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))
	s DetailNum = ""
	for {
		s DetailNum = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,DetailNum))
		q:(DetailNum="")
		
		s subID = ""
		for {
			s subID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",mrLogID,DetailNum,subID))
			q:(subID="")
			
			s mrLogDetailID = mrLogID_"||"_subID			
			
			//删除MRLogDtlFinal
			s dtlFinalSubDetailNum = ""
			for {
				s dtlFinalSubDetailNum = $o(^DHCEPRFS.INST.MRLogDtlFSubI("IdxMRLogDetail"," "_mrLogDetailID,dtlFinalSubDetailNum))
				q:(dtlFinalSubDetailNum = "")
				
				s dtlFinalID = ""
				for {
					s dtlFinalID =  $o(^DHCEPRFS.INST.MRLogDtlFSubI("IdxMRLogDetail"," "_mrLogDetailID,dtlFinalSubDetailNum,dtlFinalID))
					q:(dtlFinalID = "")
					
					s dtlFinalSub = ""
					for {
						s dtlFinalSub =  $o(^DHCEPRFS.INST.MRLogDtlFSubI("IdxMRLogDetail"," "_mrLogDetailID,dtlFinalSubDetailNum,dtlFinalID,dtlFinalSub))
						q:(dtlFinalSub = "")
						
						d ##class(DHCEPRFS.INST.MRLogDtlFinalSub).%DeleteId(dtlFinalID_"||"_dtlFinalSub)	
					}
					
					d ##class(DHCEPRFS.INST.MRLogDtlFinal).%DeleteId(dtlFinalID)
				}	
			}
					
			//删除detailSub
			s DetailNumSub = ""
			for {
				s DetailNumSub = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,subID,DetailNumSub))
				q:(DetailNumSub="")
				
				s detailSubID = ""
				for {
					s detailSubID = $o(^DHCEPRFS.INST.MRLogDetailSubI("IdxMain",mrLogID,subID,DetailNumSub,detailSubID))	
					q:(detailSubID="")
					s mrLogDetailSub = mrLogDetailID_"||"_detailSubID
					
					d ##class(DHCEPRFS.INST.MRLogDetailSub).%DeleteId(mrLogDetailSub)
				}
			}
			d ##class(DHCEPRFS.INST.MRLogDetail).%DeleteId(mrLogDetailID)
		}	
		
	}
	d ##class(DHCEPRFS.INST.MRLog).%DeleteId(mrLogID)
	
	//删除历史病案日志
	s inputMedLogID = ""
	for {
		s inputMedLogID = $o(^DHCEPRFS.INST.InputMedLogI("IdxMREpisodeID"," "_mrEpisodeID,inputMedLogID))
		q:(inputMedLogID="")
		
		d ##class(DHCEPRFS.INST.InputMedLog).%DeleteId(inputMedLogID)
	}
	
	//删除归档项目
	s version = ""
	for {
		s version = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version))	
		q:(version = "")
		
		s mrVersionID = ""
		for {
			s mrVersionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version,mrVersionID))	
			q:(mrVersionID = "")
			
			s mrItemID = ""
			for {
				s mrItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID))
				q:(mrItemID="")
				
				s mrVerItemID = ""
				for {
					s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,mrItemID,mrVerItemID))
					q:(mrVerItemID="")
					
					s mrVerItemDetailNum = ""
					for {
						s mrVerItemDetailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain"," "_mrVerItemID,mrVerItemDetailNum))	
						q:(mrVerItemDetailNum="")
						
						s mrVerItemDetailSubID = ""
						for {
							s mrVerItemDetailSubID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain"," "_mrVerItemID,mrVerItemDetailNum,mrVerItemDetailSubID))	
							q:(mrVerItemDetailSubID="")
							
							d ##class(DHCEPRFS.INST.MRVerItemDetail).%DeleteId(mrVerItemID_"||"_mrVerItemDetailSubID)
						}
					}
					d ##class(DHCEPRFS.INST.MRVerItem).%DeleteId(mrVerItemID)	
				}	
			}
			d ##class(DHCEPRFS.INST.MRVersion).%DeleteId(mrVersionID)	
		}
	}
	
	//删除就诊编目诊断
	s mrEpisodeFPID = ""
	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,mrEpisodeFPID))	
	d ##class(DHCEPRFS.INST.MREpisodeFP).%DeleteId(mrEpisodeFPID)
	
	//删除就诊患者信息
	s mrEpisodePatID = ""
	s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMREpisodeID"," "_mrEpisodeID,mrEpisodePatID))	
	d ##class(DHCEPRFS.INST.MREpisodePat).%DeleteId(mrEpisodePatID)
	
	//删除就诊
	d ##class(DHCEPRFS.INST.MREpisode).%DeleteId(mrEpisodeID)
	q "1"
}

// 根据就诊号获取就诊类型

ClassMethod GetEpisodeTypeByIds(AEpisodeIDs As %String) As %String
{
	q:(AEpisodeIDs="") ""
	s len = $L(AEpisodeIDs,"^")
	s ret = ""
	f i=1:1:len
	{
		s PAAdm = $P(AEpisodeIDs,"^",i)
		s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)
		i (ret="")
		{
			s ret = PAAdmType
		}
		else
		{
			s ret = ret_"^"_PAAdmType
		}
		
	}
	q ret
}

// 根据医院来配置，默认直接授权

ClassMethod CheckScanPrivilege(AMREpisodeID As %String, AQueryUserID As %String = "") As %String
{
	s:(AQueryUserID = $c(0)) AQueryUserID = ""
	
	s ret = "1"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if (hospitalFlag = "NYFY")	//宁医总院	慈济分院与总院分开
	{
		if (AQueryUserID = "")	//未传入QueryUserID,则默认允许权限
		{
			q "1"	
		}
		s ret = ##class(DHCEPRFS.BL.BLQueryRoleFunction).IsUserHasBaseRole(AQueryUserID,"AreaCiJi")
		//获取就诊号出院科室ID，慈济分院的出院科室为
		s disLocID = $lg(^DHCEPRFS.INST.MREpisodeD(AMREpisodeID),29)
		
		//慈济分院的出院科室
		if ((disLocID = "1218")||(disLocID = "1221")||(disLocID = "1224")||(disLocID = "1227")
			||(disLocID = "1229")||(disLocID = "1232")||(disLocID = "1235")||(disLocID = "1238")
			||(disLocID = "1245")||(disLocID = "1349")||(disLocID = "1392"))
		{
			if (ret="1")	//慈济分院的操作员
			{	q "1"	}
			else			//非慈济分院
			{	q "-1"	}	
		
		}
		else
		{
			if (ret="1")	//慈济分院的操作员
			{	q "-1"	}
			else			//非慈济分院
			{	q "1"	}	
		}
	}
	elseif (hospitalFlag = "SDLKRMYY")
	{
		s episodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
		if (episodeID '= "")
		{
			s paAdmType = $p($g(^PAADM(episodeID)),"^",2)
			s:(paAdmType '= "I") ret = "-1"
		}
	}
	elseif (hospitalFlag = "YKYZLYYLFYQ")
	{
		s episodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
		if (episodeID '= "")
		{
			s flagAS = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckAS("DHC",episodeID)
			s:(flagAS = "1") ret = "0"
		}
	}
	
	q ret
}

/// Create: 2023-3-4 yangshun
/// Desc: 根据患者的科室判断是哪个院区，有些pa_adm的院区字段为空，所以使用这种方法
/// Input: 就诊号
/// Debug: w ##class(DHCEPRFS.BL.BLMREpisode).GetHosAreaIDByAdm("")
ClassMethod GetHosAreaIDByAdm(AEpisodeID As %String) As %String
{
	s locID = $P(^PAADM(AEpisodeID),"^",4)
	q:(locID="") "0"
	s hospid = $P(^CTLOC(locID),"^",22)
	q hospid
}

}
