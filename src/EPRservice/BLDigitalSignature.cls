/// 电子病历数字签名逻辑类
Class EPRservice.BLDigitalSignature Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// w ##Class(EPRservice.BLDigitalSignature).GetContent("105", "147", "", "72359")
ClassMethod GetContent(usrID As %String, printDocID As %String, insID As %String, episodeID As %String) As %GlobalCharacterStream
{
	if (printDocID="")
	{    
		q ##Class(EPRservice.BLDigitalSignature).GetContentByIDs(insID)
	}
	else
	{
		s IDs=##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(usrID, printDocID, episodeID) 
    	q ##Class(EPRservice.BLDigitalSignature).GetContentByIDs(IDs)
	}
}

/// w ##Class(EPRservice.BLDigitalSignature).GetContentByIDs("1||1")
ClassMethod GetContentByIDs(IDs As %String) As %GlobalCharacterStream
{
	s result=##class(%GlobalCharacterStream).%New()
	q:(IDs="") ""
	s count=$Length(IDs, "^")
	f i=1:1:count
	{
		s id = $p(IDs, "^", i)	 
		if (id="")
		{ continue }
		s data=##Class(EPRinstance.InstanceData).%OpenId(id)	
		d result.CopyFrom(data.InstanceData) 
		d result.MoveToEnd()
	} 
	
	q result
}

/// 唯一模板  可重复模板在客户端就已经得到InstanceID  id^id^id
/// id = TheECRecord||InstanceDataID 
/// w ##Class(EPRservice.BLDigitalSignature).GetInstanceIDs("105", "147", "72359")
ClassMethod GetInstanceIDs(usrID As %String, printDocID As %String, episodeID As %String) As %String
{
	s result=""
	//取出当前节点下绑定的界面模板
	s curSeq=""
	for {
		s curSeq=$o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_printDocID,curSeq))
		q:(curSeq="") 
						
		s eprTemplateId=""
		for {
			s eprTemplateId=$o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_printDocID,curSeq,eprTemplateId))
			q:(eprTemplateId = "") 
			
			s tmp=##Class(EPRmeta.EPRTemplate).%OpenId(eprTemplateId)
			s bindID=tmp.BindTemplateID
			s ruleID=tmp.PrivRuleDR
			if (ruleID'="") {
				s templateid=bindID
				s categoryid=""
				s EPRNum=""			
				s patientID=$p(^PAADM(episodeID),"^",1)
				s ctlocid=""
				s templateid=""
				s workGroupID=""
				s categoryid=""
				s parentId=""
				s EPRNum=""
				s privString = "userid^"_usrID_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_workGroupID_"!categoryid^"_categoryid_"!docid^"_parentId_"!isnewframework^1!eprnum^"_EPRNum
				s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(ruleID,privString)
				//load是规则检查约定返回值变量   guozongtao
				if (privRule.GetAt("load")="0"){
					//s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID",parentId,curTemplateId))
					continue
				}				
			} 
			s recID=""
			s recID=$O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " CG"_bindID, recID))
			q:(recID = "")
		
			s insID=""
			s insID=$O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", recID, " 1", insID))	
			if (result '= "")
			{ s result= result_"^"_recID_"||"_insID }
			else
		    { s result = recID_"||"_insID }
		}
	}
	q result
}

/// d ##Class(EPRservice.BLDigitalSignature).TestSign()
ClassMethod TestSign()
{
	w ##Class(EPRservice.BLDigitalSignature).VerifySignature("201869", "24", "3", "<NInstanceData><Code>A0000</Code><Value /><ValueCode /><BindKBCode /><SubItems><NITextDesc><Code>E0001</Code><Value /><ValueCode /><SubItems /><FormatRangeCollection /></NITextDesc><NISimple><Code>I0002</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>D0003</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>O0004</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>I0005</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0007</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>I0006</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0008</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0009</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0015</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0010</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0011</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0012</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISegment><Code>G0013</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NILink><Code>L0014</Code><Value /><ValueCode /><FormatRangeCollection /></NILink></SubItems><FormatRangeCollection /></NISegment></SubItems></NInstanceData>")
}

/// 数字签名
/// 返回错误信息
/// w ##Class(EPRservice.BLDigitalSignature).Sign("", "104", "3||1", "", "105")
ClassMethod Sign(UsrCertCode As %String, episodeID As %String, printDocID As %String, eprNum As %String, insIDs As %String, signValue As %String, contentHash As %String) As %String
{
	// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
	s ret=##Class(CA.DigitalSignatureService).Sign(UsrCertCode, "EPR", contentHash, signValue)
	q:0=$p(ret,"^",1) $p(ret,"^",2)

	// 电子病历签名日志类
	s log=##Class(EPRinstance.DigitalSignLog).%New()
	s log.SignID=$p(ret,"^",2)  
	s usrID=##Class(CA.UsrSignatureInfo).GetUsrIdByKey(UsrCertCode)
    s log.UsrID=usrID
    s log.EpisodeID=episodeID
    s log.PrintDocID=printDocID 
    s log.EPRNum=eprNum 
    //s ^CacheTemp("insIDs")=insIDs
    if ((""=insIDs)||($C(0)=insIDs)) 
    {
	    s insIDs=##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(usrID, printDocID, episodeID) 
	}
    s log.InsIDs=insIDs 
    s log.ContentHash=contentHash 
    s log.IsValid=1
    d log.%Save()	
	q ""
}

ClassMethod GetUserSignImage(usrID As %String) As %String
{
	s id = ##Class(CA.UsrSignatureInfo).GetInUseID(usrID)
	q:""=id ""
	s info=##Class(CA.UsrSignatureInfo).%OpenId(id)	
	q info.SignImage
}

/// w ##Class(EPRservice.BLDigitalSignature).GetSignImage("105", "77182", "104", "1", "")
ClassMethod GetSignImage(episodeID As %String, printDocID As %String, instanceID As %String, printType As %String) As %String
{
	if (printType="Single")
	{
		s eprNum="1"
	}
	else
	{
		s obj=##Class(EPRinstance.InstanceData).%OpenId(instanceID)
		s eprNum=obj.ListNo 
	}
	
	s id=""
	s id=##Class(EPRinstance.DigitalSignLog).GetLastSign(episodeID, printDocID, eprNum)
	q:(id="") ""
	s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
	q:(log.IsValid=0) ""
	s Sign=##Class(CA.DigitalSignature).%OpenId(log.SignID) 
	s info=##Class(CA.UsrSignatureInfo).%OpenId(Sign.UsrSignInfoID)	
	q info.SignImage
}

/// 获取签名图片
ClassMethod GetSignatureImage(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	s id=""
	s id=##Class(EPRinstance.DigitalSignLog).GetLastSign(argEpisodeID, argPrintDocID, argEPRNum)
	q:(id="") ""
	s log=##Class(EPRinstance.DigitalSignLog).%OpenId(id)
	q:(log.IsValid=0) ""
	s Sign=##Class(CA.DigitalSignature).%OpenId(log.SignID) 
	s info=##Class(CA.UsrSignatureInfo).%OpenId(Sign.UsrSignInfoID)	
	q info.SignImage
}

/// Desc: 		获取上级医师签名图
/// Debug:		
ClassMethod GetSuperiorImage(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	q:""=..CheckValidSign(argEpisodeID,argPrintDocID,argEPRNum) ""	
	
	s chkUser = ##Class(EPRservice.BOEPRLogs).GetCheckerID(argEpisodeID, argPrintDocID, argEPRNum)
	q:""=chkUser ""
	q ..GetUserSignImage(chkUser)
}

/// Desc: 		获取创建者签名图
/// Debug:
ClassMethod GetCreaterImage(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	q:""=..CheckValidSign(argEpisodeID,argPrintDocID,argEPRNum) ""
 
	s usrID=##class(EPRservice.BOEPRLogs).GetCreaterID(argEpisodeID,argPrintDocID,argEPRNum)
	q:""=usrID ""
	q ..GetUserSignImage(usrID)
}

/// Desc: 检查当前病历数字签名是否有效
/// Return：为空则无效
ClassMethod CheckValidSign(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	
    if "Y"=##class(EPRmeta.SysOption).GetOptionValueByName2("CheckValidSign","")
	{
		q:""=##Class(EPRinstance.DigitalSignLog).GetValidSign(argEpisodeID,argPrintDocID,argEPRNum) ""
	}
	
	q "1"
}

/// Description:   获取服务状态
/// w ##Class(EPRservice.BLDigitalSignature).GetCAServiceStatus("1")
ClassMethod GetCAServiceStatus(CTLocID As %String) As %String
{
    q ##Class(CA.DigitalSignatureService).GetCAServiceStatus(CTLocID)
}

/// 签名验证
/// 返回错误信息
ClassMethod VerifySignature(episodeID As %String, printDocID As %String, eprNum As %String, contentHash As %String) As %String
{
	s result=""
	s logID=##Class(EPRinstance.DigitalSignLog).GetLastSign(episodeID, printDocID, eprNum)
    q:""=logID "未找到签名记录！"    
    s log=##Class(EPRinstance.DigitalSignLog).%OpenId(logID)
    
    //if (log.IsValid=0) 
    //{
	//    s result="签名失效"
    //}
    if (contentHash'=log.ContentHash)
    {
	    s result="原文内容发生改变！"
	}
	else
	{
		//s ^CacheTemp("VerifySign")=log.SignID_"^"_contentHash
		// 签名验证
	    s ret=##Class(CA.DigitalSignatureService).VerifySign(log.SignID, contentHash)
        //q:ret'="" ret
        if (ret'="")
        { s result="签名验证失败！"}
	}
    s usr=log.UsrID
    s usr = $g(^SSU("SSUSR",+usr))
	s usr = $p(usr,"^",2)

    s sign=##Class(CA.DigitalSignature).%OpenId(log.SignID)
    s date=$zd(sign.CreateDate, 3) 
    s time=$zt(sign.CreateTime, 1)
    q result_" 最后签名者："_usr_" 签名时间："_date_" "_time
}

/// 取有效签名日志信息
ClassMethod GetSignLog(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	s result=""
	s logID=##Class(EPRinstance.DigitalSignLog).GetLastSign(episodeID, printDocID, eprNum)
    if (""'=logID) //无签名信息
    {
	    s log=##Class(EPRinstance.DigitalSignLog).%OpenId(logID)
    
        s usr=log.UsrID
        s usr = $g(^SSU("SSUSR",+usr))
    	s usr = $p(usr,"^",2)

        s sign=##Class(CA.DigitalSignature).%OpenId(log.SignID)
        s date=$zd(sign.CreateDate, 3) 
        s time=$zt(sign.CreateTime, 1)
        s signValid = "已签名"
        if (log.IsValid=0) {s signValid = "签名失效"}
        s result= usr_" "_signValid  //_" "_date_" "_time
    }
    s HandSigner = ##Class(EPRservice.BLHandWrittenSign).GetLastValidSign(episodeID, printDocID, eprNum)
	if (HandSigner '= "")
	{
		s result = result_" 患者已签名"
	}    
    q result
}

/// 取最后一个有效签名的签名者姓名
ClassMethod GetLastValidSigner(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
    s logID=##Class(EPRinstance.DigitalSignLog).GetValidSign(episodeID, printDocID, eprNum)
    q:""=logID "" //无签名信息
    s log=##Class(EPRinstance.DigitalSignLog).%OpenId(logID)
    
    s usr=log.UsrID
    s usr = $g(^SSU("SSUSR",+usr))
	s usr = $p(usr,"^",2)
	q usr
}

ClassMethod OutPutHtml()
{
	d ##Class(CA.DigitalSignatureService).OutPutSecXKeyExist()

    w "<script type='text/javascript' src='../scripts/epr/js/caaudit.js'>",!
    w "</script>",!
}

ClassMethod OutPutJSRefHtml()
{
	d ##Class(CA.DigitalSignatureService).OutPutSecXCommon()

    w "<script type='text/javascript' src='../scripts/epr/js/caaudit.js'>",!
    w "</script>",!
}

ClassMethod OutPutHtmlForXieHe()
{
	w "<script type='text/javascript' src='../scripts/epr/js/DHCAdAuthInterface.js'>",!
    w "</script>",!
}

/// Desc 某些医院需要使用身份进行数字签名，
/// 此函数决定，数字签名窗口，是否会有身份选择框
/// w ##Class(EPRservice.BLDigitalSignature).IsSignByUserPos()
ClassMethod IsSignByUserPos() As %String
{
	s hisName=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
 	q:("DTSY"=hisName)||("ZHSRMYY"=hisName) "1"
 	
 	q "0"
}

/// 获取审核者的最后一次签名时间
ClassMethod GetCheckerSignedDateTime(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	s chkUser = ##Class(EPRservice.BOEPRLogs).GetCheckerID(argEpisodeID, argPrintDocID, argEPRNum)
	q:""=chkUser ""	
	q ##Class(EPRinstance.DigitalSignLog).GetUsrLastSignedDateTime(argEpisodeID, argPrintDocID, argEPRNum, chkUser)
}

/// 获取创建者的最后一次签名时间
ClassMethod GetCreaterSignedDateTime(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	s usrID=##class(EPRservice.BOEPRLogs).GetCreaterID(argEpisodeID,argPrintDocID,argEPRNum)
	q:""=usrID ""
	s re= ##Class(EPRinstance.DigitalSignLog).GetUsrLastSignedDateTime(argEpisodeID, argPrintDocID, argEPRNum, usrID)
    q re
}

}
