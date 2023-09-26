Class EMRservice.BL.BLPastHistory Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLPastHistory).getAdmList("8")
ClassMethod getAdmList(APatientID As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	q:(APatientID = "") ResultStream
	
	d ResultStream.Write("{""rows"":[")
	s count = 0
	s EpisodeID = ""
	for {
		s EpisodeID = $o(^PAPERdr(APatientID, "ADM", "I", EpisodeID),-1)
		q:(EpisodeID = "")
		
		s VisitStatus = $p($g(^PAADM(EpisodeID)),"^",20)
		continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息 
		
		//就诊日期、就诊时间
		s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
		s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
		
		if (count > 0)
		{
			d ResultStream.Write(",")
		}
		//d ResultStream.Write($zd(AdmDate,3))
		d ResultStream.Write("{")
		d ResultStream.Write("""EpisodeID"":"""_EpisodeID_"""")
		d ResultStream.Write(",""AdmDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)_"""")
		d ResultStream.Write("}")
		s count = count + 1
	}
	d ResultStream.Write("],""total"":"""_count_"""}")
	q ResultStream
}

/// w ##class(EMRservice.BL.BLPastHistory).getAdmListOrderByDiagnosis("8")
ClassMethod getAdmListOrderByDiagnosis(APatientID As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	q:(APatientID = "") ResultStream
	
	s key = $i(^CacheTemp)
	k ^TempEMRPastHistory(key)
	s EpisodeID = ""
	for {
		s EpisodeID = $o(^PAPERdr(APatientID, "ADM", "I", EpisodeID))
		q:(EpisodeID = "")
		
        s VisitStatus = $p($g(^PAADM(EpisodeID)),"^",20)
		continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息 
        
		//就诊日期、就诊时间
		s AdmDate = $P($G(^PAADM(EpisodeID)),"^",6)
		s AdmTime = $P($G(^PAADM(EpisodeID)),"^",7)
		/*
		s DiagnosList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDiagnos(EpisodeID)
		s Diagnos = $p($P(DiagnosList, "^", 3),"(",1)
		s:(Diagnos = "") Diagnos = "无诊断就诊" 
		*/
		s ADiagnosTypeID = ""
		s ADiaSubID = ""
		s ADiagnosName = ""
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosList")
		d result.Execute(EpisodeID,"")
		while result.%Next()
		{
			continue:(result.Data("ARowID") = "")
			continue:(result.Data("ADiagnosTypeID") = "")
			continue:(ADiagnosTypeID '= "")&&(ADiagnosTypeID < result.Data("ADiagnosTypeID"))  //取诊断类型ID最小的，优先级最高
			
			s ADiaRowID = result.Data("ARowID")
			s ADiaSubID = result.Data("ADiaSubID")
			s ADiagnosTypeID = result.Data("ADiagnosTypeID")
			s ADiagnosType = result.Data("ADiagnosType")
			s ADiagnosName = result.Data("ADiagnosName")
			s AICDID = result.Data("AICDID")
			s AICDCode = result.Data("AICDCode")
		}
		s ^TempEMRPastHistory(key,ADiagnosName,EpisodeID) = AdmDate
	}
	
	s diagnosCount = 0
	s tempDiagnos = ""
	for
	{
		s tempDiagnos = $o(^TempEMRPastHistory(key,tempDiagnos))
		q:(tempDiagnos = "")
		
		d:(diagnosCount > 0) ResultStream.Write(",")
		d ResultStream.Write("{")
		d ResultStream.Write("""Diagnos"":"""_tempDiagnos_""",")
		d ResultStream.Write("""DateList"":")
		d ResultStream.Write("[")
		
		s episodeCount = 0
		s tempEpisodeID = ""
		for
		{
			s tempEpisodeID = $o(^TempEMRPastHistory(key,tempDiagnos,tempEpisodeID))
			q:(tempEpisodeID = "")
			
			s tempAdmDate = ^TempEMRPastHistory(key,tempDiagnos,tempEpisodeID)
			
			d:(episodeCount > 0) ResultStream.Write(",")
			d ResultStream.Write("{")
			d ResultStream.Write("""EpisodeID"":"""_tempEpisodeID_""",")
			s stdAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",tempAdmDate)
			d ResultStream.Write("""AdmDate"":"""_stdAdmDate_"""")
			d ResultStream.Write("}")
			s episodeCount = episodeCount + 1
		}
		d ResultStream.Write("]")
		d ResultStream.Write("}")
		s diagnosCount = diagnosCount + 1
	}
	q ResultStream
}

/// w ##class(EMRservice.BL.BLPastHistory).getHisDataByAdm("2020")
ClassMethod getHisDataByAdm(AEpisodeID As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") ResultStream
	s PatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	
	//d ResultStream.Write("{")
	//d ResultStream.Write("""id"":""RT00"",")
	//d ResultStream.Write("""text"":""选中就诊相关信息"",")
	//d ResultStream.Write("""attributes"":{")
	//d ResultStream.Write("""type"":""RT""},")
	//d ResultStream.Write("""children"":")
	//d ResultStream.Write("[")
	//五大病史分类start
	//输出入院记录既往史
	/*
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""EMRpasthistory"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""入院记录既往史"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	s EMRpasthistoryStream = ..getEMRpasthistory(AEpisodeID)
	d:(EMRpasthistoryStream.Size '= 0) ResultStream.CopyFrom(EMRpasthistoryStream)
	
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	*/
	//输出诊断信息
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""Diagnosis"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""诊断信息"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	s Diagnosis = ..getDiagnosis(AEpisodeID)
	d:(Diagnosis.Size '= 0) ResultStream.CopyFrom(Diagnosis)
	
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	
	//输出用药信息
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""Order"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""用药信息"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	s OrderData = ..getOrderData(AEpisodeID)
	d:(OrderData.Size '= 0) ResultStream.CopyFrom(OrderData)
	
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	
	//输出手术信息
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""Operation"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""手术信息"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	//s OperationData = ..getOpeDataFromEvents(AEpisodeID)
	s OperationData = ..getOpeData(AEpisodeID)
	d:(OperationData.Size '= 0) ResultStream.CopyFrom(OperationData)
	
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	
	
	//输出输血信息
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""Blood"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""输血信息"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	s BloodData = ..getBloodDataByEvent(AEpisodeID)
	//s BloodData = ..getBloodData(AEpisodeID)
	d:(BloodData.Size '= 0) ResultStream.CopyFrom(BloodData)
	
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	
	
	//输出过敏信息
	d ResultStream.Write("{")
	d ResultStream.Write("""id"":""Allergy"",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""zdy""},")
	d ResultStream.Write("""state"":""open"",")
	d ResultStream.Write("""text"":""过敏信息"",")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")
	
	s AllergyData = ..getAllergyData(PatientID)
	d:(AllergyData.Size '= 0) ResultStream.CopyFrom(AllergyData)
	
	d ResultStream.Write("]")
	d ResultStream.Write("}")
	//五大病史分类end
	//d ResultStream.Write("]")
	//d ResultStream.Write("}")
	
	q ResultStream
}

/// 取入院记录既往史内容
/// w ##class(EMRservice.BL.BLPastHistory).getEMRpasthistory("4")
ClassMethod getEMRpasthistory(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s AItemPara = "HDSD00.13.042"
	s AGlossaryCateID = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AItemPara,""))
	s AGlossaryID =$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AItemPara,AGlossaryCateID,""))
	//有的项目维护术语集时，上面取到的GlossaryCateID就是GlossaryID，再根据GlossaryID去取，出来为空值，所以增加下面一句代码
	s:(AGlossaryID="") AGlossaryID = AGlossaryCateID
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") retStream
	
	s categoryid = objGlossary.GlossaryCategoryID
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	//通过术语集目录获取关联的模板ID
	s InstanceIDS = "",tmpInstanceID = "",templateCategoryID = "",EMRpasthistory = ""
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(categoryid)
	if (objGlossaryCategory '= "")
	{
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
		//获取InstanceID集合	
		s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID(AEpisodeID,templateCategoryID)
		if (InstanceIDS '= "")
		{
			//只取最近一个实例ID
			s tmpInstanceID = $listget(InstanceIDS,1)
			s EMRpasthistory = ##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,AGlossaryID,tmpInstanceID)
		}
	}		
	
	//s EMRpasthistory = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,"#TYPE:ISectionDesc#TID:1#SCODE:S003#VTYPE:V","")
	if (EMRpasthistory '= "")
	{
		d retStream.Write(EMRpasthistory)
	}
	
	q retStream
}

/// 取诊断内容
/// w ##class(EMRservice.BL.BLPastHistory).getDiagnosis("4")
ClassMethod getDiagnosis(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s key = $i(^CacheTemp)
	k ^TempEMRPastHistory(key)
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosList")
	d result.Execute(AEpisodeID,"")
	while result.%Next()
	{
		continue:(result.Data("ARowID") = "")
		s ADiaRowID = result.Data("ARowID")
		s ADiaSubID = result.Data("ADiaSubID")
		s ADiagnosTypeID = result.Data("ADiagnosTypeID")
		s ADiagnosType = result.Data("ADiagnosType")
		s ADiagnosName = result.Data("ADiagnosName")
		s AICDID = result.Data("AICDID")
		s AICDCode = result.Data("AICDCode")
		
		s ^TempEMRPastHistory(key,ADiagnosTypeID,ADiaSubID) = ADiagnosTypeID_"^"_ADiagnosType_"^"_ADiagnosName_"^"_AICDCode
	}
	
	s typeCount = 0
	s TypeID = ""
	for
	{
		s TypeID = $o(^TempEMRPastHistory(key,TypeID))
		q:(TypeID = "")
		
		s subCount = 0
		s SubID = ""
		for
		{
			s SubID = $o(^TempEMRPastHistory(key,TypeID,SubID))
			q:(SubID = "")
			
			s DiagnosObj = ^TempEMRPastHistory(key,TypeID,SubID)
			s Type = $p(DiagnosObj,"^",2)
			s diagnosName = $p(DiagnosObj,"^",3)
			s ICDCode = $p(DiagnosObj,"^",4)
			
			if (subCount = 0)
			{
				d:(typeCount > 0) retStream.Write(",")
				d retStream.Write("{")
				d retStream.Write("""id"":"""_TypeID_""",")
				d retStream.Write("""text"":"""_Type_""",")
				d retStream.Write("""children"":")
				d retStream.Write("[")
			}
			d:(subCount > 0) retStream.Write(",")
			d retStream.Write("{")
			d retStream.Write("""id"":"""_SubID_""",")
			d retStream.Write("""text"":"""_diagnosName_" "_ICDCode_"""")
			d retStream.Write("}")
			s subCount = subCount + 1
		}
		d retStream.Write("]")
		d retStream.Write("}")
		s typeCount = typeCount + 1
	}
	q retStream
}

/// 取医嘱里面的用药信息
/// w ##class(EMRservice.BL.BLPastHistory).getOrderData("2020")
ClassMethod getOrderData(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	//d result.Execute(AEpisodeID,"","","","","","","","Z")
	d result.Execute(AEpisodeID,"","","","","","","","")
	s count = 0
	while result.%Next()
	{
		//过滤掉非药品医嘱
		s ArcimId = result.Data("ArcimId")
		s del="^"	
		s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)	
		//continue:'$d(^ARCIM(ArcimId1,ArcimId2))
		s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
		s Code=$p(^ARC("IC",subcat),del,1) //药品代码
	    //s OrderType=$p(^ARC("IC",subcat),del,2) //药品类型
	    //s OrderTypeDr=$p(^ARC("IC",subcat),del,8) //药品类型DR
	    s OrderType=$p(^ARC("IC",subcat),del,7) //医嘱类型 R为药品
	    continue:(OrderType '= "R")
	    
		s OEItemID = result.Data("OEItemID")
		s OrdStartDate = result.Data("OrdStartDate")
		s OrdStartTime = result.Data("OrdStartTime")
		s ArcimDesc = result.Data("ArcimDesc")
		s DoseQty = result.Data("DoseQty")
		s DoseUnit = result.Data("DoseUnit")
		s Priority = result.Data("Priority")
		s PHFreq = result.Data("PHFreq")
		s Instr = result.Data("Instr")
		s stdOrdStartDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",OrdStartDate)
		s text = stdOrdStartDate_" "_ArcimDesc_" "_DoseQty_DoseUnit_" "_PHFreq_" "_Instr
		
		d:(count > 0) retStream.Write(",")
		d retStream.Write("{")
		d retStream.Write("""id"":"""_OEItemID_""",")
		d retStream.Write("""text"":"""_text_"""")
		d retStream.Write("}")
		s count = count + 1
	}
	
	q retStream
}

/// 通过手麻组接口取手术信息
/// w ##class(EMRservice.BL.BLPastHistory).getOpeData("4")
ClassMethod getOpeData(AEpisodeID) As %GlobalCharacterStream
{
	s resultStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") resultStream
	
	s retStream = ##class(web.DHCANAdaptor).GetANOperation("","",AEpisodeID,"","","","")
	q:(retStream.Size <= 220) resultStream
	
	s sc =##class(%XML.XPATH.Document).CreateFromStream(retStream,.PatInfoList)
	q:($$$ERROR(sc)) resultStream 
	
	s sc = PatInfoList.EvaluateExpression("/Response","count(PatInfo)",.PatInfoNode)
	q:($$$ERROR(sc)||(PatInfoNode.GetAt(1)="")) resultStream
	s dcount = PatInfoNode.GetAt(1).Value
	
	s OpaId = "",AnaesthesiaID = "",OPAStatus = "",OperId = "",OPAStartDateTime = ""
	for i=1:1:dcount
	{
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/OpaId","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s OpaId = result.GetAt(1).Value
		
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/AnaesthesiaID","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s AnaesthesiaID = result.GetAt(1).Value
		
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/OPAStatus","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s OPAStatus = result.GetAt(1).Value
		
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/OPAStartDateTime","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s OPAStartDateTime = result.GetAt(1).Value
		
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/OperId","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s OperId = result.GetAt(1).Value
		
		s sc = PatInfoList.EvaluateExpression("/Response/PatInfo["_i_"]/OpName","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s OpName = result.GetAt(1).Value
		
		s text = OPAStartDateTime_" "_OpName
		//s text = "测试 实测"
    	d:(i > 1) resultStream.Write(",")
    	d resultStream.Write("{")
		d resultStream.Write("""id"":"""_OpaId_""",")
		d resultStream.Write("""text"":"""_..TrimEnterAndWrite(text)_"""")
		d resultStream.Write("}")
	}
	
	q resultStream
}

/// 通过接入的event取手术信息
/// w ##class(EMRservice.BL.BLPastHistory).getOpeDataFromEvents("4")
ClassMethod getOpeDataFromEvents(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s count = 0
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag))
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date))
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time))
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.OperationI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Operation).%OpenId(rowId)
			    	continue:(obj = "")
			    	s subId = $o(^DHCEMRI.Events.OperationSubI("IdxOperRef",rowId,""))
			    	continue:(subId = "")
			    	s objSub = ##Class(EMRinstance.Events.OperationSub).%OpenId(rowId_"||"_subId)
			    	continue:(objSub = "")
					
					s OperDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$Case(obj.OperStartDate,"":obj.OperDate,:obj.OperStartDate))
			    	s OperTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$Case(obj.OperStartTime,"":"",:obj.OperStartTime))
			    	
			    	s text = OperDate_" "_OperTime_" "_objSub.Oper
			    	d:(count > 0) retStream.Write(",")
			    	d retStream.Write("{")
					d retStream.Write("""id"":"""_rowId_""",")
					d retStream.Write("""text"":"""_text_"""")
					d retStream.Write("}")
					s count = count + 1
				}
		    }
		}			
	}
	
	q retStream
}

/// 取输血信息
/// w ##class(EMRservice.BL.BLPastHistory).getBloodDataByEvent("4")
ClassMethod getBloodDataByEvent(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s count = 0
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.BloodTransfusion).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s TransDate = ##Class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",obj.TransDate)
			    	s TransTime = ##Class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Time",obj.TransTime)
			    	
			    	s text = TransDate_" "_TransTime_" 因"_obj.Content_"输血 "_obj.BloodTypeabo_" "_obj.BloodTyperh
			    	d:(count > 0) retStream.Write(",")
			    	d retStream.Write("{")
					d retStream.Write("""id"":"""_rowId_""",")
					d retStream.Write("""text"":"""_text_"""")
					d retStream.Write("}")
					s count = count + 1
			
				}
		    }
		}			
	}
	
	q retStream
}

/// 取输血信息
/// w ##class(EMRservice.BL.BLPastHistory).getBloodData("4")
ClassMethod getBloodData(AEpisodeID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "") retStream
	
	s BloodData = ##Class(DHCLIS.DHCBloodInterface).GetPatCompontsByAdmNo(AEpisodeID)
	//s BloodData = "全血^quanxue^300^毫升^1$$血清^xueqing^200^毫升^2$$红细胞^hongxibao^100^毫升^3"
	s count = $l(BloodData,"$$")
	for i=1,i+1,count
	{
		s CompontName = $p($p(BloodData,"$$",i),"^",1)
		s CompontCode = $p($p(BloodData,"$$",i),"^",2)
		s PackVolumn = $p($p(BloodData,"$$",i),"^",3)
		s Unit = $p($p(BloodData,"$$",i),"^",4)
		s BloodComponentsDR = $p($p(BloodData,"$$",i),"^",5)
		
		s text = CompontName_PackVolumn_Unit
    	d:(i > 1) retStream.Write(",")
    	d retStream.Write("{")
		d retStream.Write("""id"":"""_BloodComponentsDR_""",")
		d retStream.Write("""text"":"""_text_"""")
		d retStream.Write("}")
	}
	
	q retStream
}

/// 取过敏信息
/// w ##class(EMRservice.BL.BLPastHistory).getAllergyData("8")
ClassMethod getAllergyData(APatientID) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	q:(APatientID = "") retStream
	
	s result = ##class(%ResultSet).%New("web.PAAllergy:Allergies")
	d result.Execute(APatientID)
	
	s count = 0
	while result.%Next()
	{
		//Status: "Active,Resolved,Inactive,ToBeConfirmed"  "A,R,I,C"
		s Status = result.Data("Status")
		continue:(Status = "I")  //过滤掉未激活的过敏记录
		
		s RowID = result.Data("RowID")
		s Allergen = result.Data("Allergen")
		s OnsetDateText = result.Data("OnsetDateText")
		s Comments = result.Data("Comments")
		s text = OnsetDateText_" 过敏源："_Allergen_" "_Comments
		
		d:(count > 0) retStream.Write(",")
		d retStream.Write("{")
		d retStream.Write("""id"":"""_RowID_""",")
		d retStream.Write("""text"":"""_text_"""")
		d retStream.Write("}")
		s count = count + 1
	}
	
	q retStream
}

ClassMethod savePastHistory(AEpisodeID As %String, APatientID As %String, AUserID As %String, ADeptID As %String, ADMOBStr As %String, AallergyStr As %String) As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	if ((AEpisodeID = "")||(APatientID = "")||(AUserID = "")||(ADeptID = ""))
	{
		d ResultStream.Write("-1")
		q ResultStream
	}
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	TStart
	s phRowID = $O(^DHCEMRI.PastHistoryI("IdxEpisode"," "_AEpisodeID,""))
	if (phRowID = "")
	{
		s PastHistoryObj = ##class(EMRinstance.PastHistory).%New()
		if (PastHistoryObj = "")
		{
			TRollback
			d ResultStream.Write("-2")
			q ResultStream
		}
		
		s PastHistoryObj.EpisodeID = AEpisodeID
		s PastHistoryObj.PatientID = APatientID
		s PastHistoryObj.CreatDate = date
		s PastHistoryObj.CreatTime = time
		s PastHistoryObj.CreatUserID = AUserID
		s PastHistoryObj.CreatDeptID = ADeptID
		s PastHistoryObj.DMOB = ADMOBStr
		s PastHistoryObj.Allergy = AallergyStr
		
		s phSC = PastHistoryObj.%Save()
		if ('$$$ISOK(phSC))
		{
			TRollback
			d ResultStream.Write("-3")
			q ResultStream
		}
	}
	else
	{
		s PastHistoryObj = ##class(EMRinstance.PastHistory).%OpenId(phRowID)
		s PastHistoryObj.ModifyDate = date
		s PastHistoryObj.ModifyTime = time
		s PastHistoryObj.ModifyUserID = AUserID
		s PastHistoryObj.ModifyDeptID = ADeptID
		s PastHistoryObj.DMOB = ADMOBStr
		s PastHistoryObj.Allergy = AallergyStr
		
		s phSC = PastHistoryObj.%Save()
		if ('$$$ISOK(phSC))
		{
			TRollback
			d ResultStream.Write("-3")
			q ResultStream
		}
		d PastHistoryObj.%Close()
	}
	TCommit
	d ResultStream.Write("1")
	q ResultStream
}

/// w ##class(EMRservice.BL.BLPastHistory).getLastPastHistory("8")
ClassMethod getLastPastHistory(APatientID As %String) As %GlobalCharacterStream
{
	s retStream = ##Class(%GlobalCharacterStream).%New()
	if (APatientID = "")
	{
		d retStream.Write("-1")
		q retStream
	}
	
	//取患者最近一次就诊时在既往史编辑页面编辑的内容
	s DMOBStr = ""
	s AallergyStr = ""
	s episodeID = ""
	s phRowID = ""
	s episodeID = $O(^DHCEMRI.PastHistoryI("IdxPatientIDEpisode"," "_APatientID,""),-1)
	s:(episodeID '= "") phRowID = $O(^DHCEMRI.PastHistoryI("IdxEpisode",episodeID,""))
	
	if (phRowID '= "")
	{
		s phObj = ##class(EMRinstance.PastHistory).%OpenId(phRowID)
		if (phObj = "")
		{
			d retStream.Write("-2")
			q ResultStream
		}
		s DMOBStr = phObj.DMOB
		s AallergyStr = phObj.Allergy
		d retStream.Write(DMOBStr)
		d retStream.Write("^^^")
		d retStream.Write(AallergyStr)
		
		d phObj.%Close()
	}
	
	q retStream
}

ClassMethod TrimEnterAndWrite(input As %String)
{
	s input = $TR(input,$C(13),"")
	s input = $TR(input,$C(10),"")
	s input = $TR(input,$C(0),"")
	//替换单引号
	for {
		s count = $f(input,"'")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"@@@"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换斜杠
	for {
		s count = $f(input,"\")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"xiegangxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换反斜杠
	for {
		s count = $f(input,"/")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"fanxiegangfanxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文逗号
	for {
		s count = $f(input,",")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文逗号
	for {
		s count = $f(input,"，")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文叹号
	for {
		s count = $f(input,"!")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文叹号
	for {
		s count = $f(input,"！")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文句号
	for {
		s count = $f(input,"。")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"juhaojuhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文左单引号
	for {
		s count = $f(input,"‘")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"zuodanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文右单引号
	for {
		s count = $f(input,"’")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"youdanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//s input = $TR(input,"'","@@@")
	q input
}

}
