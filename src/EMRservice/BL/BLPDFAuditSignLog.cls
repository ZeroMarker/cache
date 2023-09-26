Class EMRservice.BL.BLPDFAuditSignLog Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc：	指定病历实例是否有对应患者签名后的PDF文档
/// Input:	AInstanceDataID : 病历实例数据ID
/// 		AEpisodeID ：就诊rowid，可以为空，为空时，根据InstanceDataID查询相应的EpisodeID
/// Return:	指定InstanceData是否有签名PDF数据，值域：
/// 			空 ：没有pdf数据
/// 			TOSIGN ：pdf数据待签名
/// 			SIGNED : pdf数据已签名
ClassMethod GetPDFStatus(AInstanceDataID As %String, AEpisodeID As %String = "") As %String
{
	q:(AInstanceDataID = "") ""
	
	if (AEpisodeID = "")
	{
		s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
		q:(obj = "") ""
		
		s AEpisodeID = ..GetRealEpisodeID(obj)
		q:(AEpisodeID = "") ""
	}
	
	s id = ""
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_AEpisodeID, " "_AInstanceDataID, 1, id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	
	q:(obj.SignStatus = "TOSIGN") "TOSIGN"
	q:(obj.SignStatus = "SIGNED") "SIGNED"
	
	q "SIGNED"
}

/// Desc：	指定病历实例是否有对应患者签名后的PDF文档
/// Input:	AInstanceDataID : 病历实例数据ID
/// 		AEpisodeID ：就诊rowid，可以为空，为空时，根据InstanceDataID查询相应的EpisodeID
/// Return:	指定InstanceData是否有患者签名的PDF数据，值域：
/// 			1 ：有患者签署的PDF数据
/// 			0 ：无患者签署的PDF数据
/// Degub:	w ##Class(EMRservice.BL.BLPDFAuditSignLog).HasPatSignedPDF("100||1")
ClassMethod HasPatSignedPDF(AInstanceDataID As %String, AEpisodeID As %String = "") As %String
{
	s flag = 0
	
	q:(AInstanceDataID = "") flag
	
	if (AEpisodeID = "")
	{
		s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
		q:(obj = "") flag
		
		s AEpisodeID = ..GetRealEpisodeID(obj)
		q:(AEpisodeID = "") flag
	}
	
	s id = ""
	for {
		s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_AEpisodeID, " "_AInstanceDataID, 1, id),-1)
		q:(id = "")
	
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
		
		continue:(obj = "")
		continue:($zcvt(obj.Action,"U") = "ORGSEALED")
		
		q:(obj.IsValid '= "1")
		q:(obj.Status '= "SIGNED")
		
		s flag = 1
		quit
	}

	q flag
}

/// Desc:	加载病历的PDF文档数据
/// Input:	AOutData : 要输出的PDF Base64编码数据
/// 		AInstanceIDs : InstanceDataID的List对象
/// 		AOutMessage : 要输出的消息数据
/// Return:	加载病历PDF文档数据的结果，值域：1 成功，0 失败
ClassMethod LoadDocument(ByRef AOutData As %GlobalBinaryStream, AInstanceIDs As %ListOfDataTypes, AOutMessage As %GlobalBinaryStream) As %String
{
	//校验入参
	if (AInstanceIDs = "")
	{
		d AOutMessage.Write($zcvt("InstanceDataID不能为空","O","UTF8"))
		q "0"
	}
	
	s instanceDataID = AInstanceIDs.GetAt(1)
	if (instanceDataID = "")
	{
		d AOutMessage.Write($zcvt("InstanceDataID不能为空","O","UTF8"))
		q "0"
	}
	
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(instanceDataID)
	if (objInst = "")
	{
		d AOutMessage.Write($zcvt("InstanceData数据对象为空","O","UTF8"))
		q "0"
	}
	
	s AEpisodeID = ..GetRealEpisodeID(objInst)
	if (AEpisodeID = "")
	{
		d AOutMessage.Write($zcvt("InstanceData数据的EpisodeID为空","O","UTF8"))
		q "0"
	}	
	
	//校验pdf数据
	s id = ""
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_AEpisodeID, " "_instanceDataID, 1, id),-1)
	if (id = ""){
		d AOutMessage.Write($zcvt("PDF数据记录为空","O","UTF8"))
		q "0"
	}	
	
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
	if (obj = ""){
		d AOutMessage.Write($zcvt("PDF数据记录为空","O","UTF8"))
		q "0"
	}
	if (obj.IsValid '= "1")
	{
		d AOutMessage.Write($zcvt("PDF数据签名已经失效","O","UTF8"))
		q "0"
	}
	if (obj.SignStatus = "TOSIGN")
	{
		d AOutMessage.Write($zcvt("PDF数据待签名","O","UTF8"))
		q "0"
	}
	if (obj.PDFBase64.IsNull())
	{
		d AOutMessage.Write($zcvt("PDF数据流为空","O","UTF8"))
		q "0"
	}
	
	//获取Base64格式的pdf数据流，base64数据Utf8编码与gb18030一致，不需转码
	s errMsg = ""
	s pdfStream = obj.PDFBase64
	s templateID = ..GetRealTemplateID(objInst)
	s isOK = ..LoadPDFDocXml(templateID, objInst.TemplateVersion, .pdfStream, .AOutData, .errMsg)
	if (isOK = "0")
	{
		d AOutMessage.Write($zcvt("获取PDF文档的纸型信息错误 "_errMsg,"O","UTF8"))
		q "0"
	}
	
	d AOutMessage.Write($zcvt("success","O","UTF8"))
	q "1"
}

/// Desc:	加载PDF的Base64数据, 有两种处理方式：
/// 		1、直接加载PDF的Base64数据
/// 		2、加载Abiword的xml数据(页面设置信息+PDF的Base64数据)
/// Input:	templateID 界面模板ID
/// 		version 界面模板版本
/// 		APDFBase64Stream pdf的Base64流数据
/// 		AOutData 返回给编辑器的流数据
/// Debug：	s s1=##Class(%GlobalBinaryStream).%New()
/// 		s o1=##Class(%GlobalBinaryStream).%New()
/// 		w ##Class(EMRservice.BL.BLPDFAuditSignLog).LoadPDFDocXml(1,5,.s1,.o1)
/// 		w ##Class(EMRservice.BL.BLPDFAuditSignLog).LoadPDFDocXml(1,5,.##Class(%GlobalBinaryStream).%New(),.##Class(%GlobalBinaryStream).%New())
ClassMethod LoadPDFDocXml(templateID As %String, version As %String, ByRef APDFBase64Stream As %Stream, ByRef AOutData As %Stream, ByRef errMsg = "") As %Boolean
{
	s loadFormat = ##Class(EMRservice.SystemParameter).PDFLoadFormat()
	
	//1、直接返回PDF的Base64数据
	if (loadFormat = "Base64")
	{
		while (APDFBase64Stream.AtEnd = 0) { d AOutData.Write(APDFBase64Stream.Read(24000)) }
		q "1"
	}
	
	//2、将PDF的Base64数据处理为Abiword的xml数据
	//2.1 首先获取纸型信息
	s ps = ..GetPageSizeInfo(templateID, version, .errMsg)
	q:(ps = "") "0"
	s pagetype = $p(ps,"^",1)
	s orientation = $p(ps,"^",2)
	s width = $p(ps,"^",3)
	s height = $p(ps,"^",4)
	s units = $p(ps,"^",5)
	
	//2.2 根据纸型信息生成Abiword的xml数据
	s xmlStart = "<?xml version='1.0' encoding='utf-8'?><Template><StructuredBody><MetaData Version='1' Editor='iEditor' Lang='zh-CN'></MetaData><PresentationData>"
	s xmlStart = xmlStart_"<abiword template='false' xmlns:fo='http://www.w3.org/1999/XSL/Format' xmlns:svg='http://www.w3.org/2000/svg'  xmlns:dc='http://purl.org/dc/elements/1.1/' fileformat='1.1' xmlns:math='http://www.w3.org/1998/Math/MathML' xmlns:awml='http://www.abisource.com/awml.dtd' xmlns='http://www.abisource.com/awml.dtd' xmlns:xlink='http://www.w3.org/1999/xlink' version='2.8.6' xml:space='preserve'>"
	s xmlStart = xmlStart_"<pagesize pagetype='"_pagetype_"' orientation='"_orientation_"' width='"_width_"' height='"_height_"' units='"_units_"' page-scale='1' />"
	s xmlStart = xmlStart_"<pdfbase64>"
	s xmlStart = $replace(xmlStart,"'","""")
	
	s xmlEnd = "</pdfbase64></abiword></PresentationData></StructuredBody></Template>"
	s xmlEnd = $replace(xmlEnd,"'","""")
	
	d AOutData.Write(xmlStart)
	while (APDFBase64Stream.AtEnd = 0) { d AOutData.Write(APDFBase64Stream.Read(24000)) }
	d AOutData.Write(xmlEnd)
	
	q "1"
}

/// Desc:	获取指定病历模板版本的纸张设置信息，包括纸型、是否横向、宽度、高度、单位
/// Input:	templateID 病历模板ID
/// 		version 病历模板版本号
/// 		errMsg 错误提示
/// Output: errMsg 错误提示
/// Return: 纸张设置信息，格式为：纸型^是否横向^宽度^高度^单位
/// Debug:	w ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPageSizeInfo(11,6,err)
ClassMethod GetPageSizeInfo(templateID, version, ByRef errMsg As %String = "") As %String
{
	if (templateID = "")||(version = "") 
	{
		s errMsg = "模板ID或模板版本号不能为空"
		q ""
	}
	
	s id = $O(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateID, version,""))
	if (id = "")
	{
		s errMsg = "未找到指定病历模板版本"
		q ""
	}
	
	s obj = ##class(EMRmeta.TemplateVersion).%OpenId(id)
	if (obj = "")
	{
		s errMsg = "指定病历模板版本数据为空"
		q ""
	}
	if (obj.PresentationData.IsNull())
	{
		s errMsg = "指定病历模板版本PresentationData数据为空"
		q ""
	}
	
	s objTpl = ##class(EMRmeta.Template).%OpenId(obj.TemplateID)
	if (objTpl = "")
	{
		s errMsg = "指定病历模板数据为空"
		q ""
	}
	s sc = ##class(%XML.XPATH.Document).CreateFromStream(obj.PresentationData,.doc)
	if ($$$ISERR(sc))
	{
		s errMsg = "解析PresentationData失败，错误的xml数据"
		q ""
	}
	
	s sc = doc.EvaluateExpression("/PresentationData","*",.result)
	if ($$$ISERR(sc)) 
	{
		s errMsg = "解析PresentationData失败，错误的xml数据"
		q ""
	}
	if (result.Count() = 0) 
	{
		s errMsg = "解析PresentationData失败，未找到PresentationData节点数据"
		q ""
	}
	
	s pagetype = "", orientation = "", width = "", height = "", units = ""
	
	if (objTpl.DocumentType = "DOC")
	{
		// Word模板
		// PresentationData/abiword/pagesize
		
		//获取纸型信息
		//s pagetype = "A4", orientation = "portrait", width = "210.000000", height = "297.000000", units = "mm"
		//s pagetype = "A5", orientation = "portrait", width = "148.000000", height = "210.000000", units = "mm"
		//s pagetype = "A5", orientation = "landscape", width = "210.000000", height = "148.000000", units = "mm"
		//s pagetype = "A5", orientation = "landscape", width = "8.267717", height = "5.826772", units = "in"
		
		s xmlDom = result.GetAt(1)
		while (xmlDom.Read())
		{
			//w !, xmlDom.NodeType_" | "_xmlDom.Name_" | "_xmlDom.Path_" | "_xmlDom.HasValue_" | "_xmlDom.Value
			if (xmlDom.Path = "abiword\pagesize\")&&(xmlDom.NodeType = "element")
			{
				quit:('xmlDom.HasAttributes)
				for j = 1:1:xmlDom.AttributeCount
	            {
	                d xmlDom.MoveToAttributeIndex(j)
	                //w !,"nodeType:"_xmlDom.NodeType_" | nodeName:"_xmlDom.Name_" | nodeValue:"_xmlDom.Value
	                s:(xmlDom.Name="pagetype") pagetype = xmlDom.Value
	                s:(xmlDom.Name="orientation") orientation = xmlDom.Value
	                s:(xmlDom.Name="width") width = xmlDom.Value
	                s:(xmlDom.Name="height") height = xmlDom.Value
	                s:(xmlDom.Name="units") units = xmlDom.Value
	            }
			}
			
		}
		if (pagetype = "")||(orientation = "")||(width = "")||(height = "")||(units = "")
		{
			s errMsg = "PageSize信息不完整，有空项数据"
			q ""
		}
	}
	else
	{
		//Grid模板
		// PresentationData/iEditor/PrintSetup
		s xmlDom = result.GetAt(1)
		while (xmlDom.Read())
		{
			//w !, xmlDom.NodeType_" | "_xmlDom.Name_" | "_xmlDom.Path_" | "_xmlDom.HasValue_" | "_xmlDom.Value
			if (xmlDom.Path = "iEditor\PrintSetup\")&&(xmlDom.NodeType = "element")
			{
				quit:('xmlDom.HasAttributes)
				for j = 1:1:xmlDom.AttributeCount
	            {
	                d xmlDom.MoveToAttributeIndex(j)
	                //w !,"nodeType:"_xmlDom.NodeType_" | nodeName:"_xmlDom.Name_" | nodeValue:"_xmlDom.Value
	                //s:(xmlDom.Name="pagetype") pagetype = xmlDom.Value		//没有pagetype信息，需要根据宽高转化为对应纸型
	                s:(xmlDom.Name="Orient") orientation = xmlDom.Value
	                s:(xmlDom.Name="PageWidth") width = xmlDom.Value
	                s:(xmlDom.Name="PageHeight") height = xmlDom.Value
	                s:(xmlDom.Name="Unit") units = xmlDom.Value
	            }
			}
			
		}
		if (orientation = "")||(width = "")||(height = "")||(units = "")
		{
			s errMsg = "PageSize信息不完整，有空项数据"
			q ""
		}
		
		s pagetype = ..GetGridPageType(orientation, width, height, units)
		if (pagetype = "")
		{
			s errMsg = "通过Grid模板纸型大小获取对应纸型失败"
			q ""
		}
	}
	
	q pagetype_"^"_orientation_"^"_width_"^"_height_"^"_units
}

/// Desc:	获取Grid模板的纸型
/// Input:	orientation 纸张方向
/// 		width 宽度
/// 		height 高度
/// 		unit 单位
/// Output: 
/// Return: 纸型
/// Debug:	w ##Class(EMRservice.BL.BLPDFAuditSignLog).GetGridPageType("portrait","210.00","297.00","mm")
ClassMethod GetGridPageType(orientation, width, height, unit) As %String
{
	//是否横向  PORTRAIT landscape
	//A4纸型尺寸 210.00mm 297.00mm 或 8.27in   11.69in
	//A5纸型尺寸 148.00mm 210.00mm 或 5.83in   8.27in
	//B5纸型尺寸 176.00mm 250.00mm 或 6.93in   9.84in
   	s orientation = $zcvt(orientation,"L")
   	s unit = $zcvt(unit,"L")
   	s width = $fn(width,"",1)
   	s height = $fn(height,"",1)
   	if (orientation = "portrait")
   	{
	   	if (unit = "mm")
	   	{
		   	q:(width = "210.0")||(height = "297.0") "A4"
		   	q:(width = "148.0")||(height = "210.0") "A5"
		   	q:(width = "176.0")||(height = "250.0") "B5"
	   	}
	   	elseif (unit = "in")
	   	{
		   	q:(width = "8.3")||(height = "11.7") "A4"
		   	q:(width = "5.8")||(height = "8.3") "A5"
		   	q:(width = "6.9")||(height = "9.8") "B5"
	   	}
   	}
	else
	{
		if (unit = "mm")
	   	{
		   	q:(width = "297.0")||(height = "210.0") "A4"
		   	q:(width = "210.0")||(height = "148.0") "A5"
		   	q:(width = "250.0")||(height = "176.0") "B5"
	   	}
	   	elseif (unit = "in")
	   	{
		   	q:(width = "11.7")||(height = "8.3") "A4"
		   	q:(width = "8.3")||(height = "5.8") "A5"
		   	q:(width = "9.8")||(height = "6.9") "B5"
	   	}
	}
	
	q ""
}

/// Debug:	s ret = ##Class(EMRservice.BL.BLPDFAuditSignLog).PushToSignPDF(APDFBase64, AKeyWord, AInstanceID, AEpisodeID, AUserID)
ClassMethod PushToSignPDF(APDFBase64 As %GlobalCharacterStream, AKeyWord, AInstanceID, AEpisodeID, AUserID, ASignType = "") As %String
{
	//b "s"
	
	//s $zt = "OnPushToSignPDFError"
	
	s businessIndex = AInstanceID
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s docName = objInst.Title
	
	s ret = ##class(CA.PatSignService).PushToSignPDF("",APDFBase64,"EMR", businessIndex, docName, AKeyWord, AEpisodeID, AUserID, ASignType)
	s ^CacheTemp("CADebugger",1)= ret
	s json = ##class(CA.Util.Json).FromJson(ret)
	
	if (json.GetAt("retCode") '= "0")
	{
		q "0^"_json.GetAt("retMsg")
	}
	
	s patPushResult = json.GetAt("signResult")
	s patPushSignID = $p(patPushResult,"#",2)
	s caBusinessGUID = $p(patPushResult,"#",3)
	s businessGUID = $P(patPushResult,"#",4)
	
	s ret = ..CreatePushSign(patPushSignID, patPushResult, businessGUID, caBusinessGUID, AUserID, AInstanceID, AEpisodeID, AKeyWord, APDFBase64)
	q ret
	
OnPushToSignPDFError
	s $zt = ""
	q "0^程序异常 "_$zerror
}

ClassMethod CreatePushSign(APushSignID, APushSignIDStr, ABusinessGUID, ACABusinessGUID, AUserID, AInstanceID, AEpisodeID, AKeyWord, APDFBase64) As %String
{
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%New()
	s obj.Action = "patsigned"
	s obj.StoreType = "db"
	s obj.SignStatus = "TOSIGN"
	S obj.IsValid = "1"
	s obj.InstanceID = AInstanceID
	s obj.EpisodeID = AEpisodeID
	s obj.KeyWord = AKeyWord
	d APDFBase64.Rewind()
	d obj.OriginalPDFBase64.CopyFrom(APDFBase64)
	d APDFBase64.Rewind()
	s obj.PatPushSignID = APushSignID
	s obj.UniqueDocID = ABusinessGUID
	s obj.CABusinessGUID = ACABusinessGUID
	s obj.UsrID = AUserID
	s obj.Code = ""
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s sc = obj.%Save()
	if $$$ISOK(sc)
	{
		q "1^"_obj.%Id()
	}
	else
	{
		q "0^"_sc
	}
}

/// Desc:	按照InstanceDataID取消推送签名记录
/// 		该操作由HIS发起
/// Debug:	w ##Class(EMRservice.BL.BLPDFAuditSignLog).CancelPatPushSign("8806927||3",1000)
ClassMethod CancelPatPushSign(AInstanceDataID As %String, hisUserID As %String, ipAddress As %String = "") As %String
{
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInst = "") "-1^指定实例不存在"
	
	s episodeID = ..GetRealEpisodeID(objInst)
	
	s idList = ""
	s id = ""
	for {
		s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_AInstanceDataID, 1, id),-1)
		q:(id = "")
		
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
		continue:(obj = "")
		continue:(obj.SignStatus '= "TOSIGN")
		
		if (idList = "")
		{	s idList = id}
		else
		{	s idList = idList_"^"_id}
	}
	q:(idList = "") "1^未找到待签的推送签名记录"
	
	s cancelStatus = "1", cacelMsg = ""
	for j = 1:1:$L(idList)
	{
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId($p(idList,"^",j))
		continue:(obj = "")
		
		s ret = ##Class(CA.BL.DigitalSignPatPush).CancelPushSign(obj.PatPushSignID,hisUserID)
		if ($p(ret,"^",1) '= "1")
		{
			s cancelStatus = "0"
			s cancelMsg = $p(ret,"^",2)
			quit
		}
		
		s obj.SignStatus = "CANCEL"
		s obj.IsValid = "0"
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			s cancelStatus = "0"
			s cancelMsg = sc
			quit
		}
	}
	
	if (cancelStatus = "0")
	{
		q "0^"_cancelMsg
	}
	
	//完成保存签名操作
	s action = "revokePatPushSign"
	s instanceID = obj.InstanceID
	s userID = hisUserID 
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,userID,ipAddress,"","","EMR")
    if ($p(logStatus,"^",1) = "0")
	{
		q "0^添加操作日志失败 "_logStatus
	} 
	
	q "1^取消推送签名记录成功"
}

/// Desc:	注册CA回调签名数据，有三种情况：完成签名、拒签、超时
/// 		该操作由CA发起
/// 
/// 		该操作也可以由HIS的数据库任务发起，数据库任务轮询所有待签记录，获取CA签名数据，然后调用该方法注册CA签名数据
/// 		由HIS数据库任务发起时，有四种情况：完成签名、拒签、超时、HIS端取消，需要考虑能够兼容多次重复执行
ClassMethod RegSignedPDF(businessIndex, episodeID, signStatus, APDFBase64Stream As %GlobalCharacterStream, pushSignID, cancelUserID As %String = "") As %String
{
	q:(pushSignID = "") "0^推送签名记录ID不能为空"
	q:(APDFBase64Stream = "")||(APDFBase64Stream.Size < 100) "0^文档内容为空 推送记录ID["_pushSignID_"]"
	
	//修改为使用【患者推送签名记录ID】查找对应电子病历记录
	//s id = ..GetIDByDocGUID(businessGUID)
	s id = ..GetIDByPatPushSignID(pushSignID)
	q:(id = "") "0^未找到对应的电子病历推送签名记录"
	
	if (signStatus = "FINISH")
	{
		s ret = ..FinishEMRPushSign(id, signStatus, APDFBase64Stream, "")
	}
	elseif (signStatus = "REFUSE")||(signStatus = "EXPIRE")
	{
		s ret = ..RevokeEMRPushSign(id, signStatus, "", "")
	}
	elseif (signStatus = "CANCEL")
	{
		s ret = ..RevokeEMRPushSign(id, signStatus, "", cancelUserID)
	}
	else
	{
		s ret = "0^未知签名状态["_signStatus_"] 无法处理CA回调的签名数据"
	}
	
	q ret
}

/// Desc：	完成签名
ClassMethod FinishEMRPushSign(auditSignLogID As %String, signStatus As %String, APDFBase64Stream As %GlobalCharacterStream, hisUserID As %String = "") As %String
{
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(auditSignLogID)
	q:(obj = "") "-1^打开电子病历患者推送签名记录失败 id["_id_"]"
	q:(obj.IsValid '= "1") "0^已设置为无效-不能再更新推送签名状态"
	q:(obj.SignStatus = "SIGNED")||(obj.SignStatus = "FINISH") "0^签名已完成-不能再更新推送签名状态"
	q:(obj.SignStatus = "REFUSE") "0^签名已拒绝-不能再更新推送签名状态"
	q:(obj.SignStatus = "CANCEL") "0^签名已取消-不能再更新推送签名状态"
	q:(obj.SignStatus = "EXPIRE") "0^签名已超时-不能再更新推送签名状态"
	
	//完成保存签名操作	
	s obj.SignStatus = "SIGNED"   //"FINISH"
	s obj.UpdateDate = $p($h,",",1)
	s obj.UpdateTime = $p($h,",",2)
	if ($isobject(APDFBase64Stream))
	{
		d obj.PDFBase64.CopyFrom(APDFBase64Stream)
	}
	s sc = obj.%Save()
	if ($$$ISERR(sc))
	{
		q "0^更新电子病历患者签名记录状态失败 id["_auditSignLogID_"]"
	}
	
	//完成保存签名操作
	s action = "finishPatPushSign"
	s instanceID = obj.InstanceID
	s userID = hisUserID
	s ipAddress = "127.0.0.1"
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,userID,ipAddress,"","","EMR")
    if ($p(logStatus,"^",1) = "0")
	{
		q "0^添加操作日志失败 "_logStatus
	} 
	
	q "1^注册签名后PDF成功"
}

/// Desc: 回滚签名，包括上级医师拒签、签名任务超时、HIS端医生主动取消
ClassMethod RevokeEMRPushSign(auditSignLogID As %String, signStatus As %String, cancelUserID As %String = "", ipAddress As %String = "") As %String
{
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(auditSignLogID)
	q:(obj = "") "-1^打开电子病历患者推送签名记录失败 id["_id_"]"
	q:(obj.IsValid '= "1") "0^已设置为无效-不能再更新推送签名状态"
	q:(obj.SignStatus = "SIGNED")||(obj.SignStatus = "FINISH") "0^签名已完成-不能再更新推送签名状态"
	q:(obj.SignStatus = "REFUSE") "0^签名已拒绝-不能再更新推送签名状态"
	q:(obj.SignStatus = "CANCEL") "0^签名已取消-不能再更新推送签名状态"
	q:(obj.SignStatus = "EXPIRE") "0^签名已超时-不能再更新推送签名状态"
	

	//完成保存签名操作
	if (ipAddress = "")&&(%request '= "")
	{	s ipAddress = %request.CgiEnvs("SERVER_NAME") }
	s action = "revokePatPushSign"
	s instanceID = obj.InstanceID
	s userID = cancelUserID
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,userID,ipAddress,"","","EMR")
    if ($p(logStatus,"^",1) = "0")
	{
		q "0^添加操作日志失败 "_logStatus
	} 
	
	s obj.SignStatus = signStatus
	s obj.IsValid = "0"
	s sc = obj.%Save()
	if ($$$ISERR(sc))
	{
		q "0^更新推送签名记录状态失败"
	}
	
	q "1^success"
}

ClassMethod GetIDByDocGUID(ADocGUID As %String) As %String
{
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxUniqueDocID"," "_$zcvt(ADocGUID,"u"), ""))
	q id
}

ClassMethod GetIDByPatPushSignID(APatPushSignID As %String) As %String
{
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxPatPushSignID"," "_$zcvt(APatPushSignID,"u"), ""))
	q id
}

/// w ##Class(EMRservice.BL.BLPDFAuditSignLog).GetToSignPatPushSignIDWithQR("1897832||1","")
ClassMethod GetToSignPatPushSignIDWithQR(AInstanceDataID, AEpisodeID = "") As %String
{
	b "s"
	if (AEpisodeID = "")
	{
		s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
		q:(obj = "") ""
		
		s AEpisodeID = ..GetRealEpisodeID(obj)
		q:(AEpisodeID = "")
	}
	
	s id = ""
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_AEpisodeID, " "_AInstanceDataID, "1", id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus '= "TOSIGN") ""
	
	q:(obj.PatPushSignID = "") ""
	
	s objPush = ##class(CA.DigitalSignPatPush).%OpenId(obj.PatPushSignID)
	q:(objPush = "") ""
	
	q:(objPush.QRCode = "") obj.PatPushSignID_"^0"
	q obj.PatPushSignID_"^1"
}

/// w ##Class(EMRservice.BL.BLPDFAuditSignLog).GetToSignPatPushSignID("1897832||1","")
ClassMethod GetToSignPatPushSignID(AInstanceDataID, AEpisodeID = "") As %String
{
	b "s"
	if (AEpisodeID = "")
	{
		s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
		q:(obj = "") ""
		
		s AEpisodeID = ..GetRealEpisodeID(obj)
		q:(AEpisodeID = "")
	}
	
	s id = ""
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_AEpisodeID, " "_AInstanceDataID, "1", id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus '= "TOSIGN") ""
	q obj.PatPushSignID
}

/// w ##Class(EMRservice.BL.BLPDFAuditSignLog).FetchSignResult("1873473||3","168")
ClassMethod FetchSignResult(AInstanceDataID, AHisUserID) As %String
{
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInst = "") "-1^指定实例不存在"
	
	s episodeID = ..GetRealEpisodeID(objInst)
	q:(episodeID = "") "-1^指定实例EpisodeID为空"
	
	s id = "", toSignID = ""
	for {
		s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_AInstanceDataID, 1, id),-1)
		q:(id = "")
		
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
		continue:(obj = "")
		continue:(obj.SignStatus '= "TOSIGN")
		
		s toSignID = id
		quit
	}
	q:(toSignID = "") "0^未找到待签的推送签名记录"
	

	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(toSignID)
	q:(obj = "") "-1^打开推送签名记录失败"
	
	s entity = ""
	s ret = ##Class(CA.BL.DigitalSignPatPush).GetPushSignResult(obj.PatPushSignID,AHisUserID,.entity)
	s sc = $p(ret,"^",1)
	if (sc = "-1")
	{
		q ret
	}
	
	
	if (entity = "")
	{
		q "-1^返回签名记录实体对象为空"
	}
	s signStatus = entity.Status
	
	
	if (signStatus = "FINISH")
	{
		s ret = ..FinishEMRPushSign(toSignID, signStatus, entity.SignedData)
	}
	elseif (signStatus = "REFUSE")||(signStatus = "EXPIRE")
	{
		s ret = ..RevokeEMRPushSign(id, signStatus, "", "")
	}
	elseif (signStatus = "CANCEL")
	{
		s ret = ..RevokeEMRPushSign(id, signStatus, "", cancelUserID)
	}
	elseif (signStatus = "TOSIGN")
	{
		s ret = "0^患者还未签署病历"
	}
	elseif (signStatus = "")
	{
		s ret = "0^文档签署状态异常【签署状态为空】"
	}
	else
	{
		s ret = "0^未知签名状态["_signStatus_"] 无法处理CA回调的签名数据"
	}
	
	q ret
}

/// Desc:	按照InstanceDataID取消推送签名记录
/// 		该操作由HIS发起
/// Debug:	w ##Class(EMRservice.BL.BLPDFAuditSignLog).InvalidSignedPDF("1889697||2","8593","127.0.0.1")
ClassMethod InvalidSignedPDF(AInstanceDataID As %String, hisUserID As %String, ipAddress As %String = "") As %String
{
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInst = "") "-1^指定病历实例["_AInstanceDataID_"]不存在"
	
	s episodeID = ..GetRealEpisodeID(objInst)
	q:(episodeID = "") "-1^指定实例["_AInstanceDataID_"]的EpisodeID为空"
	
	s idList = ""
	s id = ""
	for {
		s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_AInstanceDataID, 1, id),-1)
		q:(id = "")
		
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
		continue:(obj = "")
		//continue:(obj.SignStatus '= "TOSIGN")
		
		if (idList = "")
		{	s idList = id}
		else
		{	s idList = idList_"^"_id}
	}
	q:(idList = "") "0^未找到有效的推送签名记录"
	
	b "s"
	s cancelStatus = "1", cacelMsg = ""
	for j = 1:1:$L(idList)
	{
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId($p(idList,"^",j))
		continue:(obj = "")
		
		if (obj.PatPushSignID '= "")
		{
			s ret = ##Class(CA.BL.DigitalSignPatPush).CancelPushSign(obj.PatPushSignID,hisUserID)
			if ($p(ret,"^",1) '= "1")
			{
				s cancelStatus = "0"
				s cancelMsg = $p(ret,"^",2)
				quit
			}
		}
		
		//s obj.SignStatus = "CANCEL"
		s obj.IsValid = "0"
		s sc = obj.%Save()
		if ($$$ISERR(sc))
		{
			s cancelStatus = "0"
			s cancelMsg = sc
			quit
		}
	}
	
	if (cancelStatus = "0")
	{
		q "-1^"_cancelMsg
	}
	
	//完成保存签名操作
	s action = "revokePatPushSign"
	s userID = hisUserID 
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,AInstanceDataID,userID,userID,ipAddress,"","","EMR")
    if ($p(logStatus,"^",1) = "0")
	{
		q "-1^添加操作日志失败 "_logStatus
	} 
	
	q "1^作废患者推送签名成功"
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

}
