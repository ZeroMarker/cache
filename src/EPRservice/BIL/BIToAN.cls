/// 描述：开放给[临床组-手麻系统]的接口类
/// 创建者：houjian
/// 创建日期：2011-06-08
Class EPRservice.BIL.BIToAN Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Desc:	指定日期范围内的手术相关文书是否完成
/// Input：	AStartDate:起始日期
///  		AEndDate:结束日期
/// Output:	无
/// Return：1：完成，0:未完成
/// Debug:	w ##Class(EPRservice.BIL.BIToAN).IsOperRecordComplished("201764","62149","62151")
ClassMethod IsOperRecordComplished(AEpisodeID As %String, AStartDate As %String, AEndDate As %String) As %Boolean
{
	s isComplished = 1
	
	s params = ..GetOperRecordGroupInfo()
	q:(params = "") isComplished
	
	s count = $length(params,"&")
	for i = 1:1:count
	{
		s param = $P(params, "&", i)
		s isComplished = ..IsOneGroupComplished(AEpisodeID, AStartDate, AEndDate, param)
		q:(isComplished = 0)
	}
	
	q isComplished
}

/// Desc:	获取手术相关文书参数
/// 		
/// 		参数维护：
/// 		INSERT INTO EPRmeta.CustomDictionary(CtmDictAlias, CtmDictCode, CtmDictDesc, CtmDictID, CtmDictStatus,CtmDictType)
///         VALUES ('手术相关文书[给手麻系统接口]', 'M^24^术前小结&M^24^术前讨论|M^25^术前讨论', '手术相关文书[给手麻系统接口]', 'OperRecordGroup', 'Y','DHCEPRVRecordGroup')
///         或
///         update EPRmeta.CustomDictionary 
///         set CtmDictAlias = '手术相关文书[给手麻系统接口]', CtmDictCode = 'M^24^术前小结&M^24^术前讨论|M^25^术前讨论', 
///         CtmDictDesc = '手术相关文书[给手麻系统接口]', CtmDictID = 'OperRecordGroup', 
///         CtmDictStatus = 'Y', CtmDictType = 'DHCEPRVRecordGroup'
ClassMethod GetOperRecordGroupInfo() As %String
{
	s info = ""
	&sql(select top 1 CtmDictCode into :info from EPRmeta.EPRmeta.CustomDictionary
		where CtmDictType = 'DHCEPRVRecordGroup' and CtmDictID = 'OperRecordGroup' and CtmDictStatus = 'Y')
	
	if (info = $C(0)) s info = ""
	q info
}

/// Desc:	指定的一组文书是否完成[只要其中一个文书完成即可]
/// Input:	AEpisodeID：就诊指针
/// 		AStartDate：起始日期
/// 		AEndDate：	结束日期
/// 		AOneRecordGroup：指定的一组文书参数，格式：M^24^术前讨论|M^25^术前讨论
///         AOneRecordGroup 修改为 M#24#术前讨论|M#25#术前讨论|M3#56#术前讨论 ModiftyDate 2018-1-9
ClassMethod IsOneGroupComplished(AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AOneRecordGroup As %String)
{
	s isComplished = 0
	s tmpOneRecordGroup = $tr(AOneRecordGroup,"#","^")

	if ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID))>0)
	{
		s isComplished = ##Class(EMRservice.BL.BLInstanceData).IsOneGroupComplished(AEpisodeID,AStartDate,AEndDate,tmpOneRecordGroup)
		q isComplished
	}
	s tmpEpr = $e(tmpOneRecordGroup,1,$f(tmpOneRecordGroup,"M3")-4)
	s count = $length(tmpEpr,"|")
	for i = 1:1:count
	{
		s param = $P(tmpEpr, "|", i)
		s type = $p(param, "^", 1)
		s chartId = $P(param, "^", 2)
		s title = $p(param, "^", 3) 
		if (type = "M")
		{
			s isComplished = ..IsMultiRecordComplished(AEpisodeID, chartId, title, AStartDate, AEndDate)
		}
		else
		{
			s isComplished = ..IsSingleRecordComplished(AEpisodeID, chartId)
		}
		q:(isComplished = 1)
	}
	
	q isComplished
}

/// Desc:	指定可重复病历是否完成[在指定日期范围完成了指定名称的病历]
/// Input:	AEpisodeID: 就诊指针
///  		APrintDocID：指定打印模板DocID
///  		ATitle：指定病历名称
///  		AStartDate：指定起始日期
///  		AEndDate：指定结束日期
/// Output:	无
/// Return:	1:完成, 0:未完成
ClassMethod IsMultiRecordComplished(AEpisodeID As %String, APrintDocID As %String, ATitle As %String, AStartDate As %String, AEndDate As %String) As %Boolean
{
	s isComplished = 0
	
	s ecRecordID = ##Class(EPRinstance.ECRecord).GetECRecordID("", AEpisodeID, "ML"_APrintDocID)
	q:(ecRecordID = "")||(ecRecordID = $c(0)) isComplished
	
	s listNo = ""
	for {
		s listNo = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, listNo))
		q:(listNo = "")
		
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, listNo, ""))
		continue:(childSub = "")
		
		s instanceID = ecRecordID_"||"_childSub
		s isOK = ..IsInstanceOK(instanceID, AStartDate, AEndDate, ATitle)
		if (isOK)
		{
			s isComplished = 1
			q
		}
	}
	
	q isComplished
}

/// Desc:	指定InstanceData是否满足条件[日期在指定日期内，标题包含指定标题内容]
/// Input:	AInstanceDataID:指定InstanceDataID
/// 		AStartDate：指定起始日期
/// 		AEndDate：指定结束日期
/// 		ATitle：指定标题内容
/// Ouput:	无
/// Return:	1:满足条件，0：不满足条件
ClassMethod IsInstanceOK(AInstanceDataID As %String, AStartDate As %String, AEndDate As %String, ATitle As %String) As %Boolean
{
	s isOK = 0
	
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInstance = "") isOK
	
	q:(objInstance.Status = "UnSave") isOK
	q:(objInstance.HappenDate < AStartDate) isOK
	q:(objInstance.HappenDate > AEndDate) isOK
	q:($f(objInstance.Title,ATitle) = 0) isOK
	
	s isOK = 1
	q isOK
}

ClassMethod IsSingleRecordComplished(AEpisodeID As %String, ATemplateID As %String) As %Boolean
{
	s isComplished = 0
	
	s ecRecordID = ##Class(EPRinstance.ECRecord).GetECRecordID("", AEpisodeID, "CG"_ATemplateID)
	q:(ecRecordID = "")||(ecRecordID = $c(0)) isComplished
	
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " 1", ""))
	q:(childSub = "") isComplished
		
	s instanceID = ecRecordID_"||"_childSub
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceID)
	q:(objInstance = "") isComplished
	q:(objInstance.Status = "UnSave") isComplished
	
	s isComplished = 1
	q isComplished
}

}
