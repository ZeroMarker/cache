Class EMRservice.Ajax.anySign Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action", 1), "")
	
	if (action="SaveSignInfo")
	{
		d ..SaveSignInfo()
	} 
	elseif (action="GetSequenceId") 
	{
		d ..GetSequenceId()
	} 
	elseif (action="GetAnySignLocation") 
	{
		d ..GetAnySignLocation()
	}
	elseif (action="CheckPDFSign") 
	{
	    //根据CA厂商服务实现
	    s episodeId = $g(%request.Data("episodeID", 1), "")
	    s instanceId = $g(%request.Data("instanceId", 1), "")
	    s pdfInfId = ##Class(EMRinstance.PDF.AuditSignLog).GetLastValidPDFInfo(episodeId, instanceId)
	    if (pdfInfId = "") {
	    	w "-1" 
	    } else {
	    	w "1"
	    }
	}
	elseif(action="setPDFBase64") 
	{ 
		//存储PDF
	    s pdfIdN = $g(%request.Data("pdfName", 1), "")
	    s pdfB64 = $g(%request.Data("pdfB64", 1), "")
	    s pdfB64Stream = ##Class(%Library.GlobalCharacterStream).%New()
	    s isStream = $e(pdfB64,1,50)
	    if ($f(isStream,"CharacterStream")>1) {
	        d pdfB64Stream.CopyFrom(pdfB64)
	    } else {
	        d pdfB64Stream.Write(pdfB64)
	    }
	    s asLog = ##Class(EMRinstance.PDF.AuditSignLog).%New()
	    s asLog.EpisodeID = $p(pdfIdN,"-",2)
	    //s ^tmpaslog("deb") = $p(pdfIdN,"-",3)
	    s asLog.InstanceID = $REPLACE($p(pdfIdN,"-",3),"@","||")
	    s asLog.Action = "patsigned"
	    s asLog.StoreType = "db"
	    s asLog.IsValid = 1
	    d asLog.PDFBase64.CopyFrom(pdfB64Stream)
	    s stat = asLog.%Save()
	    if (stat){
	        w "1^"_ asLog.%Id()
	    } else { w "0^0" }
	}
	elseif(action="getPDFBase64") 
	{ 
		//读取PDF Base64
	    s episodeId = $g(%request.Data("episodeId", 1), "")
	    s instanceId = $g(%request.Data("instanceId", 1), "")
	    s pdfInfId = ##Class(EMRinstance.PDF.AuditSignLog).GetLastValidPDFInfo(episodeId, instanceId)
	    if (pdfInfId '= "")
	    {
		    s pdfB64 = ##Class(EMRinstance.PDF.AuditSignLog).%OpenId(pdfInfId).PDFBase64
		    while('pdfB64.AtEnd) {
		        w pdfB64.Read(3200)
		    }
	    }
		
		q $$$OK
	}
	elseif(action="pushToSignPDFBase64") 
	{ 
		//存储PDF
	    s pdfIdN = $g(%request.Data("pdfName", 1), "")
	    s pdfB64 = $g(%request.Data("pdfB64", 1), "")
	    s keyWord = $g(%request.Data("keyWord", 1), "")
	    s userID = $g(%request.Data("userID", 1), "")
	    s signType = $g(%request.Data("signType", 1), "")
	    
	    if (userID = "") s userID = %session.Get("LOGON.USERID")
	    //if ($e(keyWord,1,1) '= "[") s keyWord = "["_keyWord_"]"
	    
	    s episodeID = $p(pdfIdN,"-",2)
	    s instanceID = $REPLACE($p(pdfIdN,"-",3),"@","||")
	    
	    s pdfB64Stream = ##Class(%Library.GlobalCharacterStream).%New()
	    s isStream = $isobject(pdfB64)
	    if (isStream) {
	        d pdfB64Stream.CopyFrom(pdfB64)
	    } else {
	        d pdfB64Stream.Write(pdfB64)
	    }
	    if (pdfB64Stream.Size < 100)
	    {
		    w "0^推送PDF错误,PDF不能为空"
		    q $$$OK
	    }
	    
	    
	    //推送待签名pdf
	    s ret = ..PushToSignPDF(pdfB64Stream, keyWord, instanceID, episodeID, userID, signType)
	    if ($p(ret,"^",1) = "0")
	   	{
		   	w "0^推送pdf错误,"_$p(ret,"^",2)
	   	}
	    else
	    {
		    w "1^"_$p(ret,"^",2)
	    }
	    
	    q $$$OK
	}
	elseif (action="GetBatchSignInfo"){
		//s patientId = $g(%request.Data("patientID", 1), "")
		//s episodeId = $g(%request.Data("episodeID", 1), "")
		s instanceId= $g(%request.Data("instanceId", 1), "")
		w ##Class(EMRservice.XmlParser.XML2JSON).GetMetaSignInfoJson(instanceId)
	}
	elseif (action="CanDoPDFSign"){
		//s episodeId = $g(%request.Data("episodeID", 1), "")
		s instanceId= $g(%request.Data("instanceId", 1), "")
		w ..CanDoPDFSign(instanceId)
	}
	elseif (action="LogError"){
		s ErrorInfo = $g(%request.Data("ErrorInfo", 1), "")
		d ##Class(CA.DigitalSignTrace).AddError("EPRservice.Ajax.anySign",ErrorInfo)
	}
	elseif (action = "getPatPushSignID") {
		s InstanceID= $g(%request.Data("InstanceID", 1), "")
		w ..GetToSignPatPushSignID(InstanceID)
	}
	elseif (action = "getPatPushSignIDWithQR") {
		s InstanceID= $g(%request.Data("InstanceID", 1), "")
		w ..GetToSignPatPushSignIDWithQR(InstanceID)
	}
	elseif (action = "getHandSignType") {
		s instanceID= $g(%request.Data("instanceID", 1), "")
		s episodeID= $g(%request.Data("episodeID", 1), "")
		w ..GetHandSignType(episodeID,instanceID)
	}
	else 
	{
		w ""
	}
	
	Quit $$$OK
}

/// s ^CF("CA","AnySignLocation")= "14.18.158.147:20943"
/// d ##Class(EMRservice.Ajax.anySign).GetAnySignLocation()
ClassMethod GetAnySignLocation()
{
	w "{""Value"":"""_$G(^CF("CA","AnySignLocation"))_"""}"
	q
}

/// d ##Class(EMRservice.Ajax.anySign).GetSequenceId()
ClassMethod GetSequenceId()
{
	s $zt = "Error"
	s ret = 1
	if $d(^CF("CA","HandSignSequenceId"))
	{
		s ret = ^CF("CA","HandSignSequenceId") + 1
		s ^CF("CA","HandSignSequenceId") = ret
	} 
	else
	{
		s ^CF("CA","HandSignSequenceId") = 1
	}
	w "{""Value"":"""_ret_"""}"
	q	
Error	
	w "{""Err"":"""_$zerror_"""}"
	q
}

ClassMethod SaveSignInfo()
{
	 
	s $zt = "Error"
	
	s insID = $g(%request.Data("InsID", 1), "")
	s algorithm = $g(%request.Data("Algorithm", 1), "")
	s bioFeature = ..getReqStream("BioFeature")
	s eventCert = $g(%request.Data("EventCert", 1), "")
	s sigValue = $g(%request.Data("SigValue", 1), "")
	s tsValue = $g(%request.Data("TSValue", 1), "")
	s version = $g(%request.Data("Version", 1), "")
 
	s signScript = ..getReqStream("SignScript")
	s headerImage = ..getReqStream("HeaderImage")
	s fingerprint = ..getReqStream("Fingerprint")
	
	s signData = ..getReqStream("SignData")
	s plainText = $g(%request.Data("PlainText", 1), "")
	s ret = ##Class(EMRservice.BL.AnySignLog).SaveSignInfo(insID, 
			algorithm, eventCert, sigValue, tsValue, version, bioFeature , 
			signScript, headerImage, fingerprint, plainText,signData)
			
	if (ret = "-1") {
		w "{""Err"":""SaveSignInfo ERROR""}"
	}else{
		w "{""Value"":"""_ret_"""}"
	}
	q
Error	
	w "{""Err"":"""_$zerror_"""}"
	q
}

ClassMethod getReqStream(reqParamName) As %String
{
	s reqValue = $g(%request.Data(reqParamName,1),"")
	s reqStream = ##Class(%Library.GlobalCharacterStream).%New()
	q:(reqValue="") reqStream
	
	s clsReq = $e(reqValue,1,50)
	if ($f(clsReq,"CharacterStream")>1)
	{
		d reqStream.CopyFrom(reqValue)
	}
	else
	{
		d reqStream.Write(reqValue)
	}	
	q reqStream
}

/// Desc:	输出患者签名js
/// Input:	userLocID : 科室ID
/// Return:	无
/// d ##Class(EMRservice.Ajax.anySign).OutPutHandSignJS(113)
ClassMethod OutPutHandSignJS(userLocID As %String = "", userID As %String = "", ssgroupID As %String = "", model As %String = "")
{
	/*
    s version = ##Class(EMRservice.SystemParameter).CAVersion()
	if ("2"=version) {
		s HandSign=##Class(CA.DigitalSignatureService).IsHandSignCAON()
		q:("1"'=HandSign)
		
		s caCompany=##Class(CA.DigitalSignatureService).GetHandSignCACompany()	
	}else{
		s HandSign=$g(^CF("CA","HandSign"))
		q:("Y"'=HandSign)	
		
		s caCompany = $g(^CF("CA","CAHandSignCompany"))
		s:(caCompany = "") caCompany=##Class(CA.DigitalSignatureService).GetCACompany()	
	}
    
	w "<script type='text/javascript' src='../scripts/emr/js/handSign_"_caCompany_".js'>",!
    w "</script>",!
	*/
	s handSignOption = ##Class(EMRservice.BL.BLPatSign).GetHandSignOption(userLocID)
	s isHandSignOn = $p(handSignOption,"^",1)
	s caCompany = $p(handSignOption,"^",2)
	s supportPDF = $p(handSignOption,"^",3)
	s showQR = $p(handSignOption,"^",4)
	if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.DigitalSignatureService||GetPatCAServiceStatus") = 1)
	{
		s isHandSignOn = ##Class(CA.DigitalSignatureService).GetPatCAServiceStatus(userLocID,userID,ssgroupID,model)
		s isHandSignOn = $p(isHandSignOn,"^",1)
	}
	q:(isHandSignOn '= "1")
	
	w !,"<script type='text/javascript' src='../scripts/emr/js/handSign_"_caCompany_".js'></script>",!
}

/// Desc:	推送待签署PDF
/// Input:	PDFBase64Stream : 待签署PDF的Base64字符流
/// 			signKeyWord : PDF上的所有签名关键字
/// 			instanceDataID : 病历实例数据ID
/// 			episodeID : 就诊rowid
/// 			userID : 发起签名的userID
/// Return:	0^失败提示信息
/// 			1^EMRinstance.PDF.AuditSignLog.ID
ClassMethod PushToSignPDF(PDFBase64Stream As %Stream, signKeyWord As %String, instanceDataID As %String, episodeID As %String, userID As %String, signType As %String) As %String
{
	s ret = ##Class(EMRservice.BL.BLPDFAuditSignLog).PushToSignPDF(PDFBase64Stream, signKeyWord, instanceDataID, episodeID, userID, signType)
	q ret
}

/// Desc:	指定实例数据是否可以做患者端PDF签名
/// Input:	instanceID : 病历实例数据ID
/// Return:	0^不能做患者端PDF签名的提示信息
///         1
/// Debug：	w ##Class(EMRservice.Ajax.anySign).CanDoPDFSign("1873473||3")
ClassMethod CanDoPDFSign(instanceID) As %String
{
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
	q:(obj = "") "0^待签实例数据不存在["_instanceID_"]"
	
	s episodeID = ..GetRealEpisodeID(obj)
	s templateID = ..GetRealTemplateID(obj)
	
	q:(obj.TheECRecord.ChartItemType = "Multiple")&&(obj.TheECRecord.DocumentCharacteristic '= "0") "0^不能对连续显示的病历文档做患者签名"
	
	s sc = ##class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceID, episodeID)
	q:(sc = "SIGNED") "0^该文档已签名,请点击[患者重签]后,再次发起签名操作!"

	s tosignid = ##class(EMRservice.BL.BLPDFAuditSignLog).GetToSignPatPushSignID(instanceID, episodeID)
	if (tosignid '= "")
	{
		q "0^已推送患者待签文档, 请完成患者签署, 或点击[患者重签]后, 再次发起签名操作!"
	}
	
	s docWaitSign = ..IsInstWaitDocSign(instanceID, episodeID, obj.TheECRecord.RealChartItemID, obj.ListNo, templateID, obj.TemplateVersion, obj.TitleCode, obj.TheECRecord.DocumentCharacteristic, obj.TheECRecord.ChartItemType)
	if (docWaitSign = "1")
	{
		q "0^请先完成医生签名"
	}
		
	q "1"
}

ClassMethod IsInstWaitDocSign(instanceID, episodeID, docID, emrNum, templateID, templateVersion, titleCode, characteristic, chartItemType) As %String
{
	s doctorwait = 0
	
	//是否有医师签名单元
	s signItemCount = 0
	s docSignJson =  ##Class(EMRservice.XmlParser.XML2JSON).GetDocSignInfoJson(instanceID, .signItemCount)
	if (signItemCount = 0)
	{
		q doctorwait
	}
	
	
	//s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(episodeID,docID,emrNum)
	//q:(hasSign = "1") doctorwait
	
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
	q:(objCategoryDoc = "") doctorwait
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") doctorwait
	
	s isWaitsign = objCategoryDoc.IsWaitsign    // 待签，0或空：显示待签，1：不显示待签.
	q:(isWaitsign = "1") doctorwait
	
	s categoryId = objChapter.ParentCategoryID
	s categoryName = objChapter.CategoryName
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(episodeID, docID, emrNum)
	s statusCode = $p(log,"^",10)
	s status = $p(log,"^",11)
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(episodeID, docID, emrNum)
	s:(($p(log,"^",10)="finished")||($p(log,"^",10)="checkedRevision")) hasSign = "0"
	s waitTitleCode = titleCode
	s:(characteristic = "0") waitTitleCode = $zcvt(chartItemType,"U")
	
	s doctorwait = ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(templateID,templateVersion,waitTitleCode,"MEDICAL",hasSign,episodeID, docID, emrNum,revokeSign)
	q doctorwait
}

/// Desc:	获取待签署的[患者推送签名记录表]ID
/// Input:	instanceID : 病历实例数据ID
/// Return:	1^患者推送签名记录表ID
///         0^
ClassMethod GetToSignPatPushSignID(instanceID As %String) As %String
{
	s id = ##class(EMRservice.BL.BLPDFAuditSignLog).GetToSignPatPushSignID(instanceID)
	q:(id = "") "0^"
	q "1^"_id
}

ClassMethod GetToSignPatPushSignIDWithQR(instanceID) As %String
{
	s ret = ##class(EMRservice.BL.BLPDFAuditSignLog).GetToSignPatPushSignIDWithQR(instanceID)
	q:(ret = "") "1^"
	
	q "1^"_ret
}

/// w ##Class(EMRservice.Ajax.anySign).GetIDInfo("860808")
ClassMethod GetIDInfo(episodeID = "") As %String
{
	q:(episodeID = "") ""
	
	s patientID =  $p($g(^PAADM(episodeID)),"^",1)
	q:(patientID = "") ""

    s Name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
	
	//s CardNumber = $P($g(^PAPER(patientID,"PAT",3)),"^",6)  //[SQLUSER.PA_PatMas]PAPMI_DVAnumber
	s CardNumber = $P($g(^PAPER(patientID,"ALL")),"^",9)      //[SQLUSER.PA_PatMas]PAPMI_ID
	s CardType = $P($g(^PAPER(patientID,"PAT",3)),"^",7)      //[SQLUSER.PA_PatMas]PAPMI_CardType_DR
	
	//居民身份证
	//居民户口簿
	//护照
	//军官证
	//驾驶证
	//港澳居民来往内地通行证
	//台湾居民来往内地通行证
	//监护人证件号
	//患者无法提供任何有效证件
	//患者登记号
	s:(CardType '= "") CardType = $p($g(^PAC("CARD",CardType)),"^",2)   //PAC_CardType
	if (CardType [ "身份证")
	{	s CardType = "居民身份证"}
	elseif (CardType [ "户口簿")
	{	s CardType = "居民户口簿"}
	elseif (CardType [ "护照")
	{	s CardType = "护照"}
	elseif (CardType [ "军官证")
	{	s CardType = "军官证"}
	elseif (CardType [ "驾驶证")
	{	s CardType = "驾驶证"}
	elseif ("港澳居民来往内地通行证" [ CardType)
	{	s CardType = "港澳居民来往内地通行证"}
	elseif ("台湾居民来往内地通行证" [ CardType)
	{	s CardType = "台湾居民来往内地通行证"}
	elseif ("监护人证件号" [ CardType)
	{	s CardType = "监护人证件号"}
	elseif ("其他法定有效证件" [ CardType)
	{	s CardType = "其他法定有效证件"}
	elseif ("患者无法提供任何有效证件" [ CardType)
	{	s CardType = "患者无法提供任何有效证件"}
	else
	{	s CardType = ""}
	
	if (CardType = "患者无法提供任何有效证件")
	{
		s CardNumber = $p($g(^PAPER(patientID,"PAT",1)),"^",1)
		s CardType = "患者登记号" 
	}
	
	q:(CardNumber = "") ""
	q:(CardType = "") ""
	
	q CardNumber_"^"_CardType_"^"_Name
}

/// Desc:	获取可用患者签名方式列表
/// Input:	episodeID : 就诊ID
/// 			instanceID : 病历实例数据ID
/// Return:	{"err":"","DataBoard":"1","PDFBoard":"1","PDFPad":"1","PDFWeChat":"1"}
/// Debug:	w ##Class(EMRservice.Ajax.anySign).GetHandSignType("100","200||1")
ClassMethod GetHandSignType(episodeID, instanceID) As %String
{
	
	s $zt = "GetHandSignTypeErr"
	
	//q ##class(EMRservice.Util.Json).Instance().Put("err","").Put("DataBoard","1").Put("PDFBoard","1").Put("PDFPad","1").Put("PDFWeChat","1").ToJson()
	q ##class(EMRservice.Util.Json).Instance().Put("err","").Put("DataBoard","0").Put("PDFBoard","0").Put("PDFPad","1").Put("PDFWeChat","0").ToJson()
	
GetHandSignTypeErr
	s $zt = ""
	q ##class(EMRservice.Util.Json).Instance().Put("err",$zerror).ToJson()
}

ClassMethod GetRealEpisodeID(obj As EMRinstance.InstanceData) As %String
{
	q:(obj = "") ""
	q:(obj.EpisodeID = "") ""
	q:($isobject(obj.EpisodeID)) obj.EpisodeID.%Id()
	q obj.EpisodeID
}

ClassMethod GetRealTemplateID(obj As EMRinstance.InstanceData) As %String
{
	q:(obj = "") ""
	q:(obj.TemplateID = "") ""
	q:($isobject(obj.TemplateID)) obj.TemplateID.%Id()
	q obj.TemplateID
}

/// Desc:	获取是否有新版判断患者CA开启接口，并返回是否开启，前端判断是否显示患者待签列数据
/// Input:	userLocID : 科室ID
/// 		userID : 用户ID 
/// 			ssgroupID : 安全组ID
/// 			model : 模块code
/// Return:	1或0
/// Debug:	w ##Class(EMRservice.Ajax.anySign).IsPatCAOn("12","11","11","IPEMR")
ClassMethod IsPatCAOn(userLocID, userID, ssgroupID, model) As %String
{
	s isHandSignOn = ""
	if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.DigitalSignatureService||GetPatCAServiceStatus") = 1)
	{
		s isHandSignOn = ##Class(CA.DigitalSignatureService).GetPatCAServiceStatus(userLocID,userID,ssgroupID,model)
	}
	
	if (isHandSignOn = "") 
	{
		s hospID = ##Class(CA.BL.HospitalMgr).GetHospitIDByLocID(userLocID)
	    if (hospID = "")
	    {
	    	s hospID = $O(^CT("HOSP",0))   //默认第一个院区
	    }	
	    s isHandSignOn = ##Class(EMRservice.SystemParameter).CAHandSign()
	    s:(isHandSignOn = "0") isHandSignOn = isHandSignOn_"^系统"
	}
	q isHandSignOn
}

}
