Class EMRservice.BL.BLSDOPRecordSample Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EMRservice.BL.BLSDOPRecordSample).GenOPRecord("621")
ClassMethod GenOPRecord(EpisodeID As %String, UserID As %String, Action As %String, UsrCertCode As %String = "", Token As %String = "", CertNo As %String = "", ContainerName As %String = "") As %String
{
	s DocID = "611"
	s Title = "在线诊疗病历"
	s TitleCode = ""
	s DateTime = $zdt($h,3,1)
	
	s TemplateID = "387"
	s TemplateVersion = "4"
	s PatientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	
	//01 获取InstanceDataID
	s InstanceID = ..GetSavedInstID(EpisodeID, DocID, TemplateID)
	if (InstanceID = "")
	{
		s argOutData = ##Class(%GlobalBinaryStream).%New()
		s InstanceID = ##Class(EMRservice.BL.BLInstanceData).CreateDocument(DocID,EpisodeID,PatientID,Title,TitleCode,DateTime,argOutData)
	}
	
	//02 获取后台自动生成的xml数据
	s metadata = ##Class(%GlobalBinaryStream).%New()
	s instdata = ##Class(%GlobalBinaryStream).%New()
	s medidata = ##Class(%GlobalBinaryStream).%New()
	s scridata = ##Class(%GlobalBinaryStream).%New()
	s initdata = ##Class(%GlobalBinaryStream).%New()
	s sc = ..GetSampleStream(.metadata, .instdata, .medidata, .scridata, .initdata, InstanceID, TemplateID, TemplateVersion, EpisodeID, PatientID)
	if ($p(sc,"^",1) '= "1")
	{
		q sc
	}
	
	//03 保存实例数据
	s AStream = ##Class(%GlobalBinaryStream).%New()
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID) 
	//172版本无initialData
	//d AStream.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.TemplateID,"Document",objInstance.Title,objInstance.TitleCode,metadata,scridata,instdata,medidata,initdata))
	d AStream.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.TemplateID,"Document",objInstance.Title,objInstance.TitleCode,metadata,scridata,instdata,medidata))
	s status = ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(InstanceID,UserID,AStream, Title,TitleCode,"")
	q:(status '= "1") "0^保存门诊病历数据失败"
	
	
	//04 生成操作日志
	s action = "Save"
	s ipAddress = "127.0.0.1"
	s userLocId = ""
	//172版本无参数
	//s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,InstanceID,UserID,UserID,ipAddress,"",userLocId)
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,InstanceID,UserID,UserID,ipAddress,"")
    q:($p(logStatus,"^",1) = "0") logStatus
    
    if ((Action="Sign")&&(UsrCertCode'="")&&(UsrCertCode'="")&&(UsrCertCode'="")&&(ContainerName'=""))
    {
	    //+05生成签名数据
	    //+05-01 生成签名摘要
		s digest = ##class(%SYSTEM.Encryption).MD5HashStream(AStream,.sc)
		q:($$$ISERR(sc)) "-1^对病历数据做摘要失败"
	
		s signmd5 = ##class(web.Util.Encryption).Byte2Hex(digest)
		s signmd5 = $zcvt(signmd5,"L")
		q:(signmd5 = "") "-1^病历摘要为空"
	
		//+05-02 生成签名验证数据
		//userCertCode,certNo,Token,ContainerName
	
		s userCertCode = $Get(UsrCertCode,"")
		s token = $Get(Token,"")
		s contentHash = digest
		s certNo = $Get(CertNo,"")	
		s containerName = $Get(ContainerName,"")
		
		
		//签名结果
		//s:(containerName="") containerName = userCertCode_"-"_certNo
		s jsonSignResult=##Class(CA.Ajax.DS).GetData("AuthSignOnline","BJCA","PHONE",contentHash,containerName,token,EpisodeID,"")
		s obj = ##Class(CA.Util.Json).FromJson(jsonSignResult)
		s flag = obj.GetAt("retCode")
		q:(flag '= "0") "-1^"_obj.GetAt("retMsg")
		
		s signResult = obj.GetAt("signResult")
		
		
		// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
		s ret=##Class(CA.DigitalSignatureService).Sign(userCertCode, "EMR", contentHash, signResult, certNo)
		q:(0=$p(ret,"^",1)) "-1^文档数字签名失败"
	
		s signID = $p(ret,"^",2)
		
		//+05-03 生成签名日志
	
		s signUserID=UserID
		s signLevel = ..GetUserTopSignLevel(signUserID, EpisodeID)
		s action = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
		s path = "S011_V001_V002_L009"
		s actionType = "Append"
	
		s signStatus = ##Class(EMRservice.BL.BLEMRSign).SetMERSign(EpisodeID,InstanceID,signUserID,signID,action,contentHash,"CA",AStream,path,actionType)
	    s EMRSignId = $p(signStatus,"^",2)
     
		s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,InstanceID,userID,signUserID,ipAddress,EMRSignId)
    }
	
    //05 添加生成病历图片的队列
    //	 添加归档生成pdf的队列
    s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(PatientID,EpisodeID,InstanceID,ipAddress)
	//门诊签名后调用这个方法加入归档生成队列--20190904
	//172无此内容
	//d ##class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",EpisodeID,50)
	
    q "1"
}

ClassMethod GetSampleStream(ByRef metadata As %GlobalBinaryStream, ByRef instdata As %GlobalBinaryStream, ByRef medidata As %GlobalBinaryStream, ByRef scridata As %GlobalBinaryStream, ByRef initdata As %GlobalBinaryStream, instanceDataID As %String, templateID, templateVersion, admID, patID)
{
	//b "s"
	
	s sampleID = ##Class(EMRmeta.SDOPRecordSample).GetID(templateID, templateVersion)
	quit:(sampleID = "") "0^未找到配置数据"
	
	s objSample = ##class(EMRmeta.SDOPRecordSample).%OpenId(sampleID)
	quit:(objSample = "") "0^未找到配置数据"
	
	s oprecordID = ##class(EMRinstance.SDOPRecord).GetID(admID)
	quit:(oprecordID = "") "0^未找到线上问诊数据"
	
	s objSD = ##class(EMRinstance.SDOPRecord).%OpenId(oprecordID)
 	quit:(objSD = "") "0^未找到线上问诊数据"
 	
	
 	s metastr = objSample.MetaData.Read()
 	//s inststr = objSample.InstanceData.Read()
 	s medistr = objSample.MediasData.Read()
 	s scristr = objSample.ScriptData.Read()
 	
 	s admDT = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(admID)
 	s admDateTmp = $p(admDT,",",1)
 	s admTimeTmp = $p(admDT,",",2)
 	
 	s patname = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patID)
 	s patgenderDict =  ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patID)
 	s patgenderID = $p(patgenderDict,"^",1)
 	s patgenderCode = $p(patgenderDict,"^",2)
 	s patgenderDesc = $p(patgenderDict,"^",3)
 	
 	//s age = ##class(web.DHCBillInterface).GetPapmiAge(patID,admID,admDateTmp,admTimeTmp)
 	s Birthday=##Class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patID)
	s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(admID,Birthday,admDateTmp,1)
	
	s regno = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patID)
	
 	s printDate = $zd($p($h,",",1),3)
 	s printDate = $p(printDate,"-",1)_"年"_$p(printDate,"-",2)_"月"_$p(printDate,"-",3)_"日"
	s printDateTime = $zdt($h,3,2)
 	
 	s admDate = ""
 	s:(admDateTmp '= "") admDate = $zd(admDateTmp,3) 
 	s admDateTime = ""
 	s admDateTimeEndMin = ""
 	s:(admDT '= "") admDateTime = $zdt(admDT,3,1) 
 	s:(admDT '= "") admDateTimeEndMin = $zdt(admDT,3,2)
 	
 	s admDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(admID)
 	s admDeptID = $p(admDept,"^",1)
 	s admDeptCode = $p(admDept,"^",2)
	s admDeptDesc =$p(admDept,"^",3)
	
 	// 手机				[MobilePhone]		PA_Person.PAPER_MobPhone
	s MobilePhone=##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(patID,"")
	 // 身份证号			[IDCard]			PA_Person.PAPER_ID
 	s IDCard=##Class(EMRservice.HISInterface.PatientInfoAssist).IDCard(patID)

 	s signDate = objSD.RecordDate
 	s signDoc = objSD.DoctorUserName
 	s signDocUserID = objSD.DoctorUserID
 	
 	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
 	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(admID,"")
 	
 	s MRNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(patID,"")
 	
 	///展现数据stream 替换
 	s instStream=##class(%GlobalBinaryStream).%New()
 	s newinstStream = ##class(%GlobalBinaryStream).%New()
 	d instStream.CopyFrom(objSample.InstanceData)
 	
 	while (instStream.AtEnd = 0)
   	{
	   	s inststr=""
   	 	s inststr =instStream.Read(20000)
   	 	
	 	s inststr = ..ReplaceXml(inststr, "{instanceDataID}", instanceDataID)
	 	s inststr = ..ReplaceXml(inststr, "{姓名}", patname)
	 	s inststr = ..ReplaceXml(inststr, "{性别ID}", patgenderID)
	 	s inststr = ..ReplaceXml(inststr, "{性别Code}", patgenderCode)
	 	s inststr = ..ReplaceXml(inststr, "{性别}", patgenderDesc)
	 	s inststr = ..ReplaceXml(inststr, "{年龄}", age)
	 	s inststr = ..ReplaceXml(inststr, "{登记号}", regno)
	 	s inststr = ..ReplaceXml(inststr, "{联系方式}", MobilePhone)
	 	s inststr = ..ReplaceXml(inststr, "{身份证号}", IDCard)
	 	s inststr = ..ReplaceXml(inststr, "{现住址}", IDCard)
 	
 	
	 	s inststr = ..ReplaceXml(inststr, "{打印日期-年月日}", printDate)
		s inststr = ..ReplaceXml(inststr, "{打印日期时间}", printDateTime)
	 	s inststr = ..ReplaceXml(inststr, "{就诊日期}", admDate)
	 	s inststr = ..ReplaceXml(inststr, "{就诊日期时间}", admDateTimeEndMin)
	 	s inststr = ..ReplaceXml(inststr, "{就诊科室RowID}", admDeptID)
	 	s inststr = ..ReplaceXml(inststr, "{就诊科室Code}", admDeptCode)
	 	s inststr = ..ReplaceXml(inststr, "{就诊科室}", admDeptDesc)
 	
 	
	 	s inststr = ..ReplaceXml(inststr, "{医师签名}", signDoc)
	 	s inststr = ..ReplaceXml(inststr, "{签名日期-年月日}", signDate)
 	
	 	s inststr = ..ReplaceXml(inststr, "{主诉}", objSD.MainSuit)
	 	s inststr = ..ReplaceXml(inststr, "{现病史}", objSD.PresentIllness)
	
	 	s inststr = ..ReplaceXml(inststr, "{既往史}", objSD.PastHistory)
		//家族史
		s inststr = ..ReplaceXml(inststr, "{家族史}", objSD.PastHistory)
	
	 	s inststr = ..ReplaceXml(inststr, "{过敏史}", objSD.AllergyHistory)
	 	s inststr = ..ReplaceXml(inststr, "{体格检查}", objSD.PhyExam)
	 	s inststr = ..ReplaceXml(inststr, "{辅助检查}", objSD.AssistExam)
	 	s inststr = ..ReplaceXml(inststr, "{BP信息}", objSD.BPInfo)
	 	s inststr = ..ReplaceXml(inststr, "{诊断}", objSD.Diagnos)
	 	s inststr = ..ReplaceXml(inststr, "{处理}", objSD.Treatment)
	 	s inststr = ..ReplaceXml(inststr, "{病情变化}", objSD.DiseaseProgress)
	 	s inststr = ..ReplaceXml(inststr, "{治疗意见}", objSD.Suggest)
 	
	 	s order = objSD.Treatment
	 	s:(order = "") order = "[双击录入医嘱]"
	 	s inststr = ..ReplaceXml(inststr, "{医嘱}", order)
 	
	 	///20220816新增
	 	s inststr = ..ReplaceXml(inststr, "{病案号}", IPRecordNo)
	 	s inststr = ..ReplaceXml(inststr, "{HappenDateTime}", $zdt($h,3,1))
	 	s inststr = ..ReplaceXml(inststr, "{TimeStamp}", (+$h - $zdh("1970-01-01",3)*86400+$p($h,",",2)))
 		
	 	//签名数据
	 	s caUserSignatureInfo = ##class(CA.UsrSignatureInfo).GetInUseInfo(signDocUserID)
	 	//s info = ##Class(CA.UsrSignatureInfo).GetActiveBindInfoByCert(UsrCertCode,CertNo)
	 	s signImage = caUserSignatureInfo.SignImage
	 	
	 	s inststr = ..ReplaceXml(inststr, "{SignImageBase64}", signImage)
	 	
	 	d newinstStream.Write(inststr)
	 	
   	}
   
   	
 	d metadata.Write(metastr)
 	d metadata.Rewind()
 	
 	//d instdata.Write(inststr)
 	d instdata.CopyFrom(newinstStream)
 	d instdata.Rewind()
 	
 	d medidata.Write(medistr)
 	d medidata.Rewind()
 	d scridata.Write(scristr)
 	d scridata.Rewind()
 	
 	//老项目不存在initialData字段
 	/*
 	s TemplateVersionID = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateID,templateVersion,""))
	q:(TemplateVersionID = "")
	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(TemplateVersionID)
	
	d initdata.CopyFrom(objTemplateVersion.InitialData)
	d initdata.Rewind()
	*/
	d initdata.Write("")
	d initdata.Rewind()
	q "1"
}

ClassMethod ReplaceXml(str As %String, from, to) As %String
{
	s to = ..CharsText(to, .overflow)
	q $replace(str, $zcvt(from,"o","UTF8"), $zcvt(to,"o","UTF8"))
}

/// Desc:	做xml特殊字符转义
ClassMethod CharsText(text As %String, Output overflow) As %String
{
	try {
		Set overflow=""
		Set text=$zcvt(text,"O","XMLC",overflow)

	} catch {
		// In case new translate tables are not installed.
		Set text=$zcvt(text,"O","XML")
		Set pos=1
		while pos'=0 {
			set pos=$find(text,$c(13),pos)
			if pos'=0 set $extract(text,pos-1)="&#xD;"
		}
		Set pos=1
		while pos'=0 {
			set pos=$find(text,"&apos;",pos)
			if pos'=0 set $extract(text,pos-6,pos-1)="'"
		}
		Set pos=1
		while pos'=0 {
			set pos=$find(text,"&quot;",pos)
			if pos'=0 set $extract(text,pos-6,pos-1)=""""
		}
	}
	
	Quit text
}

ClassMethod GetSavedInstID(AEpisodeID, ADocID, templateID)
{
	s rowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ADocID,""))
	q:(rowID = "") ""
	
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(rowID)
	q:(objECRecord = "") ""
	
	s objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
	s subId = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",rowID," "_templateID," SAVE",""),-1)
	if ((subId '= ""))
	{
		s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(rowID_"||"_subId)
		q:(objInstanceData '= "") rowID_"||"_subId
	}
	
	s subId = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",rowID," "_templateID," UNSAVE",""),-1)
	if ((objTemplate.ChartItemType = "Single")&&(subId = objECRecord.InstanceCount))
	{
		s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(rowID_"||"_subId)
		q:(objInstanceData '= "") rowID_"||"_subId
	}
	
	q ""
}

ClassMethod GetUserTopSignLevel(AUserID As %String, AEpisodeID As %String) As %String
{
	s ret=""
	q:((AUserID="")||(AEpisodeID="")) ret
	
	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
 	s curDeptID = $p(curDept,"^",1)
	
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(AUserID,AEpisodeID,curDeptID)
	s userLevelCode = $p(userLevel,"^",1)
	q userLevelCode
}

/// w ##Class(EMRservice.BL.BLSDOPRecordSample).GenOPRecord("216404","1499","门诊互联网病历","515","1","6")
ClassMethod DeleteOPRecord(EpisodeID, DocID, TemplateID, UserID) As %String
{
	s DateTime = $zdt($h,3,1)
	s PatientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	
	//01 获取InstanceDataID
	s InstanceID = ..GetSavedInstID(EpisodeID, DocID, TemplateID)
	if (InstanceID = "")
	{
		q "0^患者无需要删除的病历"
	}
	
	s docStatus = ##Class(EMRservice.BL.BLInstanceData).DeleteDocument(InstanceID,UserID)
	if (docStatus '= "1")
	{
		q "0^病历删除异常"
	}
	//04 生成操作日志
	s ipAddress = "127.0.0.1"
	s userLocId = ""
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog("delete",InstanceID,UserID,UserID,ipAddress,"",userLocId)
	if ($p(logStatus,"^",1) = "0")
	{
		q "0^日志信息异常"	
	}

	
    q "1"
}

}
