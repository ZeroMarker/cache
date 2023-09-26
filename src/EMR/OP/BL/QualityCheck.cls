/// 名称:	EMR.OP.BL.QualityCheck
/// 描述:	病历数据质控
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.OP.BL.QualityCheck Extends EMR.OP.COM.ActionBase
{

/// Desc:       病历数据质控
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"QUALITY_CHECK","params":{"episodeID":"1117","documentID":["33","34"],"eventType":"Save^149^60"}}
/// 			episodeID 就诊号，documentID 实例ID集合，eventType 事件类型”Save^ssgroupID^userLocID、Commit^ssgroupID^userLocID、Print^ssgroupID^userLocID”
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod QualityCheck(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
	s documentID = argInJson.params.documentID
	s eventType = argInJson.params.eventType
    s strRes = ##Class(EMR.OP.BL.QualityCheck).QualityCheckJson(episodeID,documentID,eventType,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       病历数据质控
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aEpisodeID：就诊号，aDocumentID:文档ID集合，aSSGroupID：安全组ID
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.QualityCheck).GetUserDataJson("10209",.obj)
ClassMethod QualityCheckJson(aEpisodeID As %String, aDocumentID As %DynamicArray, aEventType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^获取CA服务信息失败"
	q:((aEpisodeID="")||((aEventType="")&&'(aEventType [ "Confirm"))) "-1^就诊、事件类型不能为空"
    q:((aDocumentID="")||(aDocumentID.%Size()=0)) "-1^实例ID不能为空"
    s jsonItem  = ##class(%DynamicObject).%New()
	
	//预住院患者不需要进行质控
	s objPaAdm = $g(^PAADM(+aEpisodeID))
	q:(objPaAdm = "") "-1^获取就诊信息失败"
	s VisitStatus=$p(objPaAdm,"^",20)
	q:(VisitStatus="P") "-1^预住院患者不需要进行质控"
	s templateID=""
	s resQuality = ""
	s jsonArr = ##class(%DynamicArray).%New()
	set iter = aDocumentID.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s documentID = item
        continue:(documentID = "")
        s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
		if (objDocument ="")||(objDocument.TemplateID="")
		{
			s strRes ="-1^"_documentID_"获取实例失败"	
			q
		}
		s templateID = objDocument.TemplateID.%Id()
		s QualityData= ""
		//新的病历质控接口 返回格式("{""ControlType"":"_ControlType_",""total"":"_count_",""key"":"_UniqueKey_"}")
		;s resQuality = ##Class(EMRservice.HISInterface.QualityInterface).GetOutpatientCheckResult(aEpisodeID,aEventType,templateID,documentID)
		;d argOutData.CopyFrom(resQuality)
		s job = ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(aEpisodeID,templateID,aEventType,documentID,"")
		if (job'="")
		{
			s RuleDR = $O(^CacheTemp("DHCEPRQQuality",job,aEpisodeID,""))
			q:(RuleDR = "")
			s RuleInfo = ^CacheTemp("DHCEPRQQuality",job,aEpisodeID,RuleDR)
		    s ControlType = $p(RuleInfo,"^",1)
		    s QualityData = ControlType_"^"
			s PhaseID = ""
			for {
				s PhaseID = $O(^CacheTemp("DHCEPRQQuality",job,aEpisodeID,RuleDR,PhaseID))
				q:(PhaseID = "")
				s EntryDR = ""
			    for 
			    {
				    s EntryDR = $O(^CacheTemp("DHCEPRQQuality",job,aEpisodeID,RuleDR,PhaseID,EntryDR))
				    q:(EntryDR = "")
				    s EntryName = $p($g(^CacheTemp("DHCEPRQQuality",job,aEpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
				    s QualityData = QualityData_EntryName_";"
			    }
			}
			k ^CacheTemp("DHCEPRQQuality",job)
		}
		s resQuality= resQuality_QualityData
	}
	s resQuality=""""""
	d argOutData.Write(resQuality)
	q "1"
}

}
