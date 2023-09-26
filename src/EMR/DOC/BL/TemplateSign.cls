/// 名称:	EMR.DOC.BL.TemplateSign
/// 描述:	模板待签操业务类
/// 编写者：yejian
/// 编写日期: 2022-9-18
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateSign Extends EMR.DOC.COM.ActionBase
{

/// Desc:     	判断待签状态
/// Creator:   	yejian
/// CreateDate:	2023-5-12
/// Input:     	ATemplateId 		模板ID
///           	ATemplateVersion 	模板版本号
///           	aDOCCode			titleCode
///           	ASignType 			(医务人员待签：MEDICAL，患者待签：PATIENT)
///           	AHasSign  			是否有签名
///           	AEpsiodeId			就诊号
///           	ADocId				
///           	AListNo
///           	ARevokeSign			系统参数IsRevokeSign
/// Output:    	0 不显示待签  1 显示待签
/// debug:     	w ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(96,31,"","MEDICAL",1,456449,879,11,"Y")
ClassMethod GetSignWaitStatus(ATemplateId As %String, ATemplateVersion As %String, aDOCCode As %String, ASignType As %String, AHasSign As %String, AEpsiodeId As %String, ADocId As %String, AListNo As %String, ARevokeSign As %String) As %String
{
	s result = "0",intMark=0
	q:(ATemplateId = "")||(ATemplateVersion = "")||(ASignType = "")||(AHasSign = "")||(AEpsiodeId = "")||(ADocId = "")||(AListNo = "")||(aDOCCode = "") -1
	
	//无签名单元，不显示待签
	s temHasSign = $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVersionHS",ATemplateId,ATemplateVersion," 0",""))
	q:(temHasSign>0) result
	s TILEMRSign = ##class(EMR.DAO.EMRSign).GetTureIndexLocation(AEpsiodeId)
	s signCode = ""
	for
	{
	 	s signCode =  $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVTCodeSCode",ATemplateId,ATemplateVersion," "_aDOCCode,signCode))
		q:(signCode="")
		s temSignID = $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVTCodeSCode",ATemplateId,ATemplateVersion," "_aDOCCode,signCode,""))
		continue:(temSignID="")

		//同一个签名单元，必签的个数
		s signRole = "",actionCodes = ""
		s waitSignCount = 0
		for
		{
			s signRole = $o(^CF.EMR.DOC.TemplateSignSRTI("IndexSignTypeForceRole",temSignID," "_ASignType," Y",signRole))
			q:(signRole = "")
			s objSignRole = ##class(CF.EMR.DOC.SignRole).%OpenId(signRole)
			continue:(objSignRole="")
			s actionCodes = $case(objSignRole,"":objSignRole.ActionCode,:actionCodes_"/"_objSignRole.ActionCode)
			s intMark = 1
			s waitSignCount = waitSignCount + 1
		}
		//判断该份病历同一个签名单元，actionCode实际有几个签名
		s signCount = 0
		s length = $l(actionCodes,"/")
		for I=1:1:length
		{
			s curAction = $p(actionCodes,"/",I)
			q:(curAction = "")
			s curAction = " "_$zcvt(curAction,"U")
			s sign = ""
			for
			{
				s sign = $o(@TILEMRSign@("IdxMain",AEpsiodeId," "_aDOCCode," "_AListNo,signCode,curAction,sign))
				q:(sign = "")
				if (ARevokeSign = "N")
				{
					s signCount = signCount + 1
				}
				else
				{
					s objSign = ##Class(EMR.DAO.EMRSign).doOpenByID(AEpsiodeId,sign)
					continue:(objSign = "")
					continue:(objSign.isValid '= "1")
					s signCount = signCount + 1
				}
			}
		}
		//实际签名小于配置签名个数退出，需待签
		if (signCount < waitSignCount)
		{
			s result = "1"
			q
		}
	}
	s:(intMark = 0)&&(ASignType = "MEDICAL")&&(AHasSign = "0") result = "1"	
		
	q result
}

/// Desc:       判断配置了维护程序签名顺序的模板是否可签名
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input：     aSignCheck:签名检查对象
/// Output:     1可签名 0不可签名
/// Debug:      w ##Class(EMR.DOC.BL.TemplateSign).CheckTemplateSign(1647,"157742||63","Resident","1800")
ClassMethod CheckTemplateSign(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = 1
	q:(aSignCheck.UserID = "")||(aSignCheck.DocumentID = "")||(aSignCheck.SignLevel = "")||(aSignCheck.UserID = "") strRes
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aSignCheck.DocumentID)
	s aSignCheck.TemplateID = objDoc.TemplateID.%Id()
	q:(aSignCheck.TemplateID = "") strRes
	s aSignCheck.EpisodeID = objDoc.EpisodeID.%Id()
	s aSignCheck.DOCCode = objDoc.DOCCode
	s aSignCheck.ListNo = objDoc.ListNo
	s aSignCheck.TemplateVersion = objDoc.TemplateVersion
	if ((aSignCheck.SignLevel = "patientSign")||(aSignCheck.SignLevel = "Patient"))
	{
		s aSignCheck.UserType = "PATIENT"
	}
	else
	{
		s aSignCheck.UserType = "MEDICAL"
	}
	
	//判断模板待签的角色规则
	s strRes = ##Class(EMR.DOC.BL.TemplateSign).CheckSignRoleRule(aSignCheck)
	q:(strRes '= 1) strRes
	//判断逐级签名的规则
	s signSeqType =  ##Class(EMR.DOC.BL.TemplateSign).GetSignSeqType(aSignCheck)
	if (signSeqType = "1")
	{
		s strRes = ##Class(EMR.DOC.BL.TemplateSign).CheckSeqSignPriv(aSignCheck)
	}
	q strRes
}

/// Desc:       判断当前签名级别是否满足所配置的角色规则
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aSignCheck 检查对象 
/// Output:     1 满足  0 不满足
/// w ##Class(EMR.DOC.BL.TemplateSign).CheckSignRoleRule(1800,"562||31","Attending","","","","")
ClassMethod CheckSignRoleRule(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = 1
	q:(aSignCheck.UserID = "")||(aSignCheck.DocumentID = "")||(aSignCheck.SignLevel = "")||(aSignCheck.DOCCode = "")||(aSignCheck.TemplateVersion = "")||(aSignCheck.UserType = "")||(aSignCheck.ElementCode = "") strRes
	s roleID = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(aSignCheck.SignLevel,"U"),""))
	q:(roleID = "") strRes
	s objRole = ##Class(CF.EMR.DOC.SignRole).%OpenId(roleID)
	s action = objRole.ActionCode
	
	s signRowID = $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVTCodeSCode",aSignCheck.TemplateID,aSignCheck.TemplateVersion," "_$zcvt(aSignCheck.DOCCode,"U")," "_$zcvt(aSignCheck.ElementCode,"U"),""))
	q:(signRowID = "") strRes
	//获取待签规则
	s signSRTRowID = $o(^CF.EMR.DOC.TemplateSignSRTI("IndexSignUnitCode",signRowID," "_$zcvt(aSignCheck.ElementCode,"U"),roleID,""))
	q:(signSRTRowID = "") strRes
	s objTemplateSignSRS = ##Class(CF.EMR.DOC.TemplateSignRuleSet).%OpenId(signSRTRowID)
	q:(objTemplateSignSRS = "") strRes
	s ruleAll = objTemplateSignSRS.RoleRuleCode
	q:((ruleAll = "")||(ruleAll = $c(0))) strRes
	
	s length = $l(ruleAll,"^")
	for I=1:1:length
	{
		s rule = $p(ruleAll,"^",I)
		continue:(rule="")
		s ruleID = $o(^CF.EMR.DOC.TemplateSignRTI("IdxCode"," "_$zcvt(rule,"U"),""))
		continue:(ruleID="")
		s objRuleType = ##class(CF.EMR.DOC.TemplateSignRuleType).%OpenId(ruleID)
		s ruleName = objRuleType.Name
		if (ruleName = "SignRoleVerify")
		{
			 s strRes = ##Class(EMR.DOC.BL.TemplateSign).CheckTitleDoctor(aSignCheck)
		}
		elseif (ruleName = "SignRoleLoginVerify")
		{
			s strRes = ##Class(EMR.DOC.BL.TemplateSign).IsLoginUser(aSignCheck)
		}
		elseif (ruleName = "NeedDoctorSignBefore")
		{
			s strRes = ##Class(EMR.DOC.BL.TemplateSign).IsDoctorSignBefore(aSignCheck)
		}
		q:(strRes '= 1)
	}
	q strRes
}

/// Desc:       判断当前用户和病程中选择的用户是否一致
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aSignCheck.SignUserID 用户ID  aDocumentID 实例ID 
/// Output:     1 一致  0 不一致
/// w ##Class(EMR.DOC.BL.TemplateSign).CheckTitleDoctor("1647","562||26")
ClassMethod CheckTitleDoctor(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = "1"
	q:(aSignCheck.UserID = "")||(aSignCheck.DocumentID = "") strRes
	s title = $o(^EMR.DB.DocumentTitleDoctorI("IdxDocumentIDUserID"," "_aSignCheck.DocumentID,""))
	q:(title = "") strRes
	s titleDoctor = $o(^EMR.DB.DocumentTitleDoctorI("IdxDocumentIDUserID"," "_aSignCheck.DocumentID," "_aSignCheck.UserID,""))
	s:(titleDoctor = "") strRes = "0^该用户与标题中所选用户不一致"
	q strRes
}

/// Desc:       判断当前签名用户和登录用户是否一致
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aSignCheck.SignUserID 签名用户ID  aLoginUser 登录用户ID 
/// Output:     1 一致  0 不一致
/// w ##Class(EMR.DOC.BL.TemplateSign).IsLoginUser("1647","562")
ClassMethod IsLoginUser(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = "0^该用户与登录用户不一致"
	q:(aSignCheck.LogonUserID = "")||(aSignCheck.UserID = "") strRes
	s:(aSignCheck.LogonUserID = aSignCheck.UserID) strRes = "1"
	q strRes
}

/// Desc:       判断患者签名前是否有医生签名
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aDocumentID 实例ID
/// Output:     1 有  0 无
/// w ##Class(EMR.DOC.BL.TemplateSign).IsDoctorSignBefore("")
ClassMethod IsDoctorSignBefore(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = "0^医护人员签名后，患者才能签名"
	q:(aSignCheck.DocumentID = "") "1"
	s ret = ##Class(EMR.DOC.BL.TemplateSign).HasRecordSign(aSignCheck.EpisodeID,aSignCheck.DOCCode,aSignCheck.ListNo,aSignCheck.Product)
	s:(ret = "1") strRes = "1"
	q strRes
}

/// Desc:		病历是否签名
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:       pEpisodeID 就诊科室
///             pEmrDocID 目录ID
///             pNum 病历序号
/// Debug:       w ##Class(EMR.DOC.BL.TemplateSign).HasRecordSign(11983760,375,1)
ClassMethod HasRecordSign(aEpisodeID As %String, aDocCode As %String, aNum As %String, aProduct As %String) As %String
{
	s strRes = "0"
	s revokeSign = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isRevokeSign",aProduct,"Y")
	s actionCode = ""
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aEpisodeID)
	for
	{
		s actionCode = $o(@TILEMRSign@("IdxMain",aEpisodeID," "_aDocCode," "_aNum,actionCode))
		q:(actionCode = "")
		continue:(actionCode = " PATIENTSIGN")
		s sign = ""
		for
		{
			s sign = $o(@TILEMRSign@("IdxMain",aEpisodeID," "_aDocCode," "_aNum,actionCode,sign))
			q:(sign = "")
			if (revokeSign = "N")
			{
				s strRes = "1"
				q
			}
			else
			{
				s objSign = ##Class(EMR.DAO.EMRSign).doOpenByID(aEpisodeID,sign)
				continue:(objSign = "")
				continue:(objSign.isValid '= "1")
				s strRes = "1"
				q
			}
		}
	}
	q strRes
}

/// Desc:       判断当前签名级别在逐级签名情况下是否有权限签名（配置的下级已签名，上级未签名才有权限签名）
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aSignCheck.SignUserID 用户ID  aDocumentID 实例ID  AUserType医患类型
/// Output:     1 有权限  0 无权限
/// w ##Class(EMR.DOC.BL.TemplateSign).CheckSeqSignPriv(1800,"562||31","Attending","","","","")
ClassMethod CheckSeqSignPriv(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
	s strRes = 1
	q:(aSignCheck.ElementCode = "")||(aSignCheck.DocumentID = "")||(aSignCheck.SignLevel = "")||(aSignCheck.TemplateID = "")||(aSignCheck.DOCCode = "")||(aSignCheck.TemplateVersion = "")||(aSignCheck.UserType = "") strRes
	s roleID = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(aSignCheck.SignLevel,"U"),""))
	q:(roleID = "") strRes
	s objRole = ##Class(CF.EMR.DOC.SignRole).%OpenId(roleID)
	s action = objRole.ActionCode
	s roleLevel = objRole.RoleLevel
	s signRowID = $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVTCodeSCode",aSignCheck.TemplateID,aSignCheck.TemplateVersion," "_$zcvt(aSignCheck.DOCCode,"U")," "_$zcvt(aSignCheck.ElementCode,"U"),""))
	q:(signRowID = "") strRes
	//获取待签规则
	s signSRTRowID = $o(^CF.EMR.DOC.TemplateSignSRTI("IndexSignUnitCode",signRowID," "_$zcvt(aSignCheck.ElementCode,"U"),roleID,""))
	q:(signSRTRowID = "") strRes
	s objTemplateSignSet = ##Class(CF.EMR.DOC.TemplateSignRuleSet).%OpenId(signSRTRowID)
	q:(objTemplateSignSet = "") strRes
	s signSeq = objTemplateSignSet.RoleLevel
	q:(signSeq = "") strRes
	s revokeSign = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isRevokeSign",aSignCheck.Product,"Y")
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aSignCheck.EpisodeID)
	if (roleLevel > 1)
	{
		s seqLevel = $o(^CF.EMR.DOC.TemplateSignSRTI("IdxSignUnitTypeForcelevelRole",signRowID," "_aSignCheck.UserType," Y",roleLevel),-1)
		if (seqLevel '= "")
		{
			s seqRoleID = $o(^CF.EMR.DOC.TemplateSignSRTI("IdxSignUnitTypeForcelevelRole",signRowID," "_aSignCheck.UserType," Y",seqLevel,""))
			q:(seqRoleID = "") strRes
			s seqObjRole = ##Class(CF.EMR.DOC.SignRole).%OpenId(seqRoleID)
			s seqAction = seqObjRole.ActionCode
			s sign = "",hasValid="0"
			for
			{
				s sign = $o(@TILEMRSign@("IdxMain",aSignCheck.EpisodeID," "_aSignCheck.DOCCode," "_aSignCheck.ListNo," "_$zcvt(seqAction,"U"),sign),-1)
				q:(sign = "")
				s objSign = ##Class(EMR.DAO.EMRSign).doOpenByID(aSignCheck.EpisodeID,sign)
				q:(objSign = "")
				//对应级别有有效签名
				if (objSign.isValid = "1")
				{
					s hasValid = "1"
					q
				}
			}
			if (hasValid = "0")
			{
				s strRes = "0^低级别还未签名，无权限签名"
				q strRes
			}
		}
	}
	q:(strRes '= 1) strRes
	
	s seqLevel = $o(^CF.EMR.DOC.TemplateSignSRTI("IdxSignUnitTypeForcelevelRole",signRowID," "_aSignCheck.UserType," Y",roleLevel))
	if (seqLevel '= "")
	{
		s seqRoleID = $o(^CF.EMR.DOC.TemplateSignSRTI("IdxSignUnitTypeForcelevelRole",signRowID," "_aSignCheck.UserType," Y",seqLevel,""))
		q:(seqRoleID = "") strRes
		s seqObjRole = ##Class(CF.EMR.DOC.SignRole).%OpenId(seqRoleID)
		s seqAction = seqObjRole.ActionCode
		s sign = "",hasValid="0"
		for
		{
			s sign = $o(@TILEMRSign@("IdxMain",aSignCheck.EpisodeID," "_aSignCheck.DOCCode," "_aSignCheck.ListNo," "_$zcvt(seqAction,"U"),sign),-1)
			q:(sign = "")
			s objSign = ##Class(EMR.DAO.EMRSign).doOpenByID(aSignCheck.EpisodeID,sign)
			q:(objSign = "")
			//对应级别有有效签名
			if (objSign.isValid = "1")
			{
				s hasValid = "1"
				q
			}
		}
		if (hasValid = "1")
		{
			s strRes = "0^高级别已签名，无权限签名"
			q strRes
		}
	}
	q strRes
}

/// Desc:       判断当前签名规则是否是逐级签名（必须下级签完名，上级才能签名）
/// Creator:    yejian
/// CreateDate: 2022-9-18
/// Input:      aSignCheck.SignUserID 用户ID  aDocumentID 实例ID 
/// Output:     1 是  0 否
/// w ##Class(EMR.DOC.BL.TemplateSign).GetSignSeqType(1800,"562||31","Attending","","","")
ClassMethod GetSignSeqType(aSignCheck As EMR.DOC.DTO.SignCheck) As %String
{
    s strRes = 0
	
	s strRowID = $o(^CF.EMR.DOC.TemplateSignI("IndexTIDVersion",aSignCheck.TemplateID,aSignCheck.TemplateVersion,""))
	q:(strRowID = "") strRes
	s objTemSign = ##class(CF.EMR.DOC.TemplateSign).%OpenId(strRowID)
    s HasSignLevel = objTemSign.HasSignLevel
    s:(HasSignLevel = "1") strRes = 1
    q strRes
}

/// Desc:       获取待签维护列表
/// Creator:    huhao
/// CreateDate: 2022/09/20
/// Table:		CF.EMR.DOC.TemplateSign
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetSignList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.TemplateSign).GetSignJson(id,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取出错",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetSignJson(id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.TemplateSignSRTD(rowid))
		q:rowid=""
		s obj=##class(CF.EMR.DOC.TemplateSignRuleSet).%OpenId(rowid)
		continue:(obj.SignUnit.TemplateVersion.%Id()'=id)
		
		s resObj.key=rowid
		s resObj.SignUnit=obj.SignUnit.SignRole.Description
		s resObj.DOCCode=obj.SignUnit.DOCCode
		s resObj.DOCName=obj.SignUnit.DOCName
		s resObj.SignCode=obj.SignCode
		s resObj.IsForce=obj.IsForce
		s resObj.RoleLevel=obj.SignRole.RoleLevel
		s resObj.RoleRuleCode=##class(EMR.DOC.BL.TemplateSign).getRule(obj.RoleRuleCode)
		s resObj.RuleCode=obj.RoleRuleCode
		s resObj.SignRole=obj.SignRole.Description
		s resObj.SignType=obj.SignType
		s resObj.TemplateID=obj.SignUnit.TemplateID.%Id()
		s resObj.TemplateVersion=obj.SignUnit.TemplateVersion.%Id()
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       根据签名规则编码获取签名规则描述
/// Creator:    huhao
/// CreateDate: 2022/09/21
/// Table:		CF.EMR.DOC.TemplateSignRuleType
/// Input:      %String  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:		d ##class(EMR.DOC.BL.TemplateSign).getRule("1^2^3")
ClassMethod getRule(rule As %String) As %String
{
	s res=""
	s count=$length(rule,"^")
	for i=1:1:count
	{
		s rowid=""
		s code=$piece(rule,"^",i)
		s rowid=$o(^CF.EMR.DOC.TemplateSignRTI("IdxCode"," "_code,rowid))
		q:rowid=""
		s desc=##class(CF.EMR.DOC.TemplateSignRuleType).%OpenId(rowid).Description
		if (res="")
		{
			s res=desc
		}
		else
		{
			s res=res_"^"_desc
		}
	}
	q res
}

/// Desc:       获取版本签名属性
/// Creator:    huhao
/// CreateDate: 2022/09/20
/// Table:		CF.EMR.DOC.TemplateSignConfig
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetVersionSign(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.TemplateSign).GetSignatrr(id,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetSignatrr(id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.TemplateSignD(rowid))
		q:rowid=""
		s obj=##class(CF.EMR.DOC.TemplateSign).%OpenId(rowid)
		continue:(obj.TemplateVersion.%Id()'=id)
		s resObj.key=rowid
		s resObj.HasSign=obj.HasSign
		s resObj.HasSignLevel=obj.HasSignLevel
		s resObj.TemplateID=obj.TemplateID.%Id()
		s resObj.TemplateVersion=obj.TemplateVersion.%Id()
		d resJson.%Push(resObj)
		s strRes="1"
		q
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取角色规则
/// Creator:    huhao
/// CreateDate: 2022/09/21
/// Table:		CF.EMR.DOC.TemplateSignRuleType
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetSignRuleList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##class(EMR.DOC.BL.TemplateSign).getsignrule(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod getsignrule(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.TemplateSignRTD(rowid))
		s obj=##class(CF.EMR.DOC.TemplateSignRuleType).%OpenId(rowid)
		q:obj=""
		s resObj.key=rowid
		s resObj.Code=obj.Code
		s resObj.Description=obj.Description
		s resObj.Name=obj.Name
		s resObj.Value=obj.Value
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       更新模板代签属性
/// Creator:    huhao
/// CreateDate: 2022/09/21
/// Table:		CF.EMR.DOC.TemplateSignConfig,CF.EMR.DOC.TemplateSign
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateTemplateSignAttribute(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Tmpid=argInJson.params.TemplateVersionId
	s hasSignLevel=argInJson.params.hasSignLevel
	s hasSign=argInJson.params.hasSign
	s signList=argInJson.params.signList //数组对象
	s strRes = ##class(EMR.DOC.BL.TemplateSign).UpdateArrtibute(Tmpid,hasSignLevel,hasSign,signList,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod UpdateArrtibute(tempid As %String, haSignLevel As %String, hasSign As %String, signList As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:tempid="" "-1^版本id不能为空"
	TSTART
	//修改模板代签属性（是否逐级签名，是否可签）
	s tpmscId=""
	for
	{
		s tpmscId=$o(^CF.EMR.DOC.TemplateSignD(tpmscId))
		q:tpmscId=""
		s obj=##class(CF.EMR.DOC.TemplateSign).%OpenId(tpmscId)
		continue:(obj.TemplateVersion.%Id()'=tempid)
		s obj.HasSign=hasSign
		s obj.HasSignLevel=haSignLevel
		s sc=obj.%Save()
		if ('$$$ISOK(sc))
		{
			s strRes="-1^保存模板签名属性失败"
			TROLLBACK
		}
	}
	//修改角色签名规则
	s count=signList.%Size()
	s:(count=0) strRes=1
	for i=0:1:(count-1)
	{
		s ruleObj=signList.%Get(i)
		s RoleruleObj=##class(CF.EMR.DOC.TemplateSignRuleSet).%OpenId(ruleObj.RoleID)
		s RoleruleObj.IsForce=ruleObj.isForce
		s RoleruleObj.RoleRuleCode=ruleObj.signRule
		s SC=RoleruleObj.%Save()
		if ('$$$ISOK(SC))
		{
			s strRes="-1^待签角色规则保存失败"
			TROLLBACK
		}
		s strRes="1"
	}
	TCOMMIT
	q strRes
}

/// Desc:       模板待签数据保存
/// Creator:    huhao
/// CreateDate: 2022/11/02
/// Table:		CF.EMR.DOC.TemplateSign
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod SaveSignData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=..GetIDByKey(argInJson.params.id)
	s SignArray=argInJson.params.signData
	s strRes = ##class(EMR.DOC.BL.TemplateSign).savedata(id,SignArray,.argOutData) 
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       模板待签数据保存
/// Creator:    huhao
/// CreateDate: 2022/11/02
/// Table:		CF.EMR.DOC.TemplateSign
/// Input:      id:版本id
/// 				signArray：签名单元角色数组  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod savedata(id As %String, signArray As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s signroleNum="",flag="",deleteflag="",strRes=""
	s versionObj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(id)
	q:versionObj="" "-1^版本不存在"
	s tmpId=versionObj.Template.%Id()
	
	//取三级审核下所有基础签名角色
	s SignRoleList=##class(%DynamicArray).%New()
	s signroleName=""
	for
	{
		s signroleName=$o(^CF.EMR.DOC.SignRoleI("IdxNameCanSignOnCheck",signroleName))
		q:signroleName=""
		s signroleId=$o(^CF.EMR.DOC.SignRoleI("IdxNameCanSignOnCheck",signroleName," 1",""))
		if (signroleId="") {continue}
		s signObj=##class(CF.EMR.DOC.SignRole).%OpenId(signroleId)
		q:signObj=""
		d SignRoleList.%Push(signObj.Name)
	}


	TSTART
	//删除TemplateSign表多余内容
	s result=##class(%ResultSet).%New("EMR.DOC.BL.TemplateSign:SelectTmpSignName")
	d result.Execute(id)
	While result.Next()
	{
		s SignName=result.GetDataByName("Name")
		s SignUnitId=result.GetDataByName("ID")
		s SignCode=result.GetDataByName("SignCode")
		s count=signArray.%Size()
		q:count=0
		for i=0:1:(count-1)
		{
			//新添加签名单元
			s AddsignObj=signArray.%Get(i)
			if ((SignName=AddsignObj.signRole)&&(SignCode=AddsignObj.signCode))
			{
				s deleteflag=""
				q
			}
			else
			{
				s deleteflag=1
			}
		}
		if (deleteflag=1)
		{
			//删除TemplateSign表内容
			&sql(Delete from CF_EMR_DOC.TemplateSign where ID=:SignUnitId)
			//删除TemplateSignRuleSet表对应内容
			d ##class(EMR.DOC.BL.TemplateSign).deleteTmpsignRule(SignUnitId)
		}
		s strRes="1"
	}
	//添加TemplateSign表新增内容
	s count = signArray.%Size()
	s:count=0 strRes="1"
	for i=0:1:(count-1)
	{
		s NewSignObj=signArray.%Get(i)
		s signRoleId=""
		&sql(select id into :signRoleId from CF_EMR_DOC.SignRole where Name=:NewSignObj.signRole)
		s templateSignId=$O(^CF.EMR.DOC.TemplateSignI("IndexRoleCode",signRoleId," "_$zcvt(NewSignObj.signCode,"U"),id,""))
		if (templateSignId'="")
		{
			continue
		}
		//签名角色在表中不存在，添加新角色
		else
		{
			//添加TemplateSign表内容
			s TmpSignObj=##class(CF.EMR.DOC.TemplateSign).%New()
			s TmpSignObj.SignRole=##class(CF.EMR.DOC.SignRole).%OpenId(signRoleId)
			s TmpSignObj.SignCode=NewSignObj.signCode
			s TmpSignObj.TemplateID=##class(CF.EMR.DOC.Template).%OpenId(tmpId)
			s TmpSignObj.TemplateVersion=##class(CF.EMR.DOC.TemplateVersion).%OpenId(id)
			s TmpSignObj.DOCCode=##class(CF.EMR.DOC.Template).%OpenId(tmpId).TemplateCategory.Code
			s TmpSignObj.DOCName=##class(CF.EMR.DOC.Template).%OpenId(tmpId).TemplateCategory.Name
			s getSignId=$o(^CF.EMR.DOC.TemplateSignD(""))
			if (getSignId="")
			{
				s TmpSignObj.HasSign="0"
				s TmpSignObj.HasSignLevel="0"
			}
			else
			{
				s TmpSignObj.HasSign=##class(CF.EMR.DOC.TemplateSign).%OpenId(getSignId).HasSign
				s TmpSignObj.HasSignLevel=##class(CF.EMR.DOC.TemplateSign).%OpenId(getSignId).HasSignLevel
			}
			s sc = TmpSignObj.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				s strRes="-1^保存失败"
			}
			//添加TemplateSignRuleSet表内容
			if (TmpSignObj.SignRole.Name'="Check")
			{
				//非三级签签名单元下签名角色的添加
				d ##class(EMR.DOC.BL.TemplateSign).AddcommonSignRole(NewSignObj.signRole,NewSignObj.signCode,TmpSignObj.%Id())
			}
			else
			{
				//三级签签名单元下签名角色添加
				d ##class(EMR.DOC.BL.TemplateSign).UpdatecheckSignRole(SignRoleList,NewSignObj.signRole,NewSignObj.signCode,TmpSignObj.%Id())
			}
		}
		s strRes="1"
	}
	if (strRes="1")
	{
		TCOMMIT
	}
	else
	{
		s strRes="-1^保存失败"
		TROLLBACK
	}
	q strRes
}

Query SelectTmpSignName(id As %String) As %SQLQuery
{
	SELECT ID,SignRole->Name,SignCode FROM CF_EMR_DOC.TemplateSign WHERE TemplateVersion=:id
}

// 删除templatesignruleset表内容

ClassMethod deleteTmpsignRule(UnitId As %String)
{
	&sql(Delete from CF_EMR_DOC.TemplateSignRuleSet where SignUnit=:UnitId )
}

// 新增templatesignruleset表内容/非三级签

/// Input: signRole：角色编码
/// 		  signCode：签名编码
/// 		  signUnit：签名单元（CF.EMR.DOC.TemplateSign）
ClassMethod AddcommonSignRole(signRole As %String, signCode As %String, signUnit As %String)
{
	s roleId=$o(^CF.EMR.DOC.TemplateSignSRTI("IndexSignUnitCode",signUnit," "_$zcvt(signCode,"U"),signRole,""))
	q:roleId'="" 1
	s obj=##class(CF.EMR.DOC.TemplateSignRuleSet).%New()
	s obj.IsForce=""
	s rowId=""
	&sql(select id into rowId from CF_EMR_DOC.SignRole where Name=:signRole)
	s signObj=##class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	s obj.RoleLevel=signObj.RoleLevel
	s obj.RoleRuleCode=""
	s obj.SignCode=signCode
	s obj.SignRole=signObj
	if ((signObj.Name="Patient")||(signObj.Name="Notation"))
	{
		s obj.SignType="PATIENT"
	}
	else
	{
		s obj.SignType="MEDICAL"
	}
	s obj.SignUnit=##class(CF.EMR.DOC.TemplateSign).%OpenId(signUnit)
	s sc=obj.%Save()
	q sc
}

ClassMethod UpdatecheckSignRole(signRoleList As %DynamicArray, signRole As %String, signCode As %String, signUnit As %String)
{
	s flag="",deleteflag="",strRes=""
	s resArr=##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.TemplateSign:SelectTmpSignSetName")
	d result.Execute(signUnit,signCode)
	While result.Next()
	{
		s signrole=result.GetDataByName("Name")
		s count=signRoleList.%Size()
		for i=0:1:(count-1)
		{
			s signrole1= signRoleList.%Get(i)
			if (signrole1=signrole)
			{
				d resArr.%Push(signrole)
				s deleteflag=""
				q
			}
			else
			{
				s deleteflag=1
			}
		}
		if (deleteflag=1)
		{
			&sql(delete from CF_EMR_DOC.TemplateSignRuleSet where SignCode=:signCode and SignRole->Name=:signrole)
		}
	}
	for i=0:1:(signRoleList.%Size()-1)
	{
		s newSign=signRoleList.%Get(i)
		s countc=resArr.%Size()
		s:countc=0 flag=1 
		for j=0:1:(countc-1)
		{
			s oldsign=resArr.%Get(j)
			if (newSign=oldsign)
			{
				s flag="" 
				q
			}
			else{s flag=1}
		}
		if (flag=1)
		{
			s roleId=""
			s obj=##class(CF.EMR.DOC.TemplateSignRuleSet).%New()
			s obj.IsForce=""
			&sql(select ID into :roleId from CF_EMR_DOC.SignRole where Name=:newSign)
			s signroleObj=##class(CF.EMR.DOC.SignRole).%OpenId(roleId)
			s obj.RoleLevel=signroleObj.RoleLevel
			s obj.RoleRuleCode=""
			s obj.SignCode=signCode
			s obj.SignRole=signroleObj
			if ((signroleObj.Name="Patient")||(signroleObj.Name="Notation"))
			{
				s obj.SignType="PATIENT"
			}
			else
			{
				s obj.SignType="MEDICAL"
			}
			s obj.SignUnit=##class(CF.EMR.DOC.TemplateSign).%OpenId(signUnit)
			s strRes=obj.%Save()
		}
	}
	q
}

Query SelectTmpSignSetName(id As %String, signCode As %String) As %SQLQuery
{
	SELECT SignRole->Name FROM CF_EMR_DOC.TemplateSignRuleSet WHERE SignUnit=:id and SignCode=:signCode
}

}
