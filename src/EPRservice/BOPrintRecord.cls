Class EPRservice.BOPrintRecord Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

Parameter SERVICENAME = "BOPrintRecord";

/// Desc:	根据InstanceID获取打印记录
/// Input：	AEpisodeID ：就诊记录ID
/// 		AInstanceDataID ：实例数据ID
ClassMethod GetPrintRecordByInstanceID(AInstanceDataID As %String) As EPRservice.entity.EPrintRecord
{
	q:(AInstanceDataID) ""
	s retEPrintRecord = ""
	
	s printType = ..GetPrintTypeByInstanceID(AInstanceDataID)
	if (printType = "Single")
	{
		s episodeID = ..GetEpisodeIDByInstanceID(AInstanceDataID)
		q:(episodeID = "") retEPrintRecord
		
		s printTemplateID = ..GetBindPrtTplIDByInstanceID(AInstanceDataID)
		q:(printTemplateID = "") retEPrintRecord
		
		s retEPrintRecord = ..GetSinglePrtRecord(episodeID, printTemplateID)
		q retEPrintRecord
	}
	else
	{
		s retEPrintRecord = ..GetMultiPrtRecord(AInstanceDataID)
		q retEPrintRecord
	}
}

/// Desc:	根据就诊RowID和打印模板ID获取唯一模板打印记录
ClassMethod GetSinglePrtRecord(AEpisodeID As %String, APrintTemplateID As %String) As EPRservice.entity.EPrintRecord
{
	//b "s"
	q:(AEpisodeID="")||(APrintTemplateID = "") ""
	
	s episodePrintRecordID = ..GetSingleEpisodePrtRecordID(AEpisodeID, APrintTemplateID)
	q:(episodePrintRecordID = "") ""
	
	s instancePrintRecordID = ..GetSingleInstancePrtRecordID(episodePrintRecordID, APrintTemplateID)
	q:(instancePrintRecordID = "") ""
	
	s objEPrintRecord = ..GetPrintRecordByID(instancePrintRecordID)
	q objEPrintRecord
}

/// Desc:	取唯一模板的EpisodePrtRecordID
ClassMethod GetSingleEpisodePrtRecordID(AEpisodeID As %String, APrintTemplateID) As %String
{
	//b "s"
	q:(AEpisodeID="")||(APrintTemplateID = "") ""
	s retEpisodePrintRecordID = ""
	
 	s blankEpisodeID  = " "_AEpisodeID
 	s blankPrintType =  " SINGLE"
 	s blankECRecordID = " "
 	s retEpisodePrintRecordID = $O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",blankEpisodeID,blankPrintType,blankECRecordID,""))
 	
 	// 兼容旧数据
 	if (retEpisodePrintRecordID = "")
 	{
	 	s blankECRecordID = " "_$c(0)				////部分旧数据的ECRecordID值为 ""
 		s retEpisodePrintRecordID = $O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",blankEpisodeID,blankPrintType,blankECRecordID,""))
 	}
 	if (retEpisodePrintRecordID = "")
	{
		s blankECRecordID = " S"_APrintTemplateID	//部分旧数据的ECRecordID值为 "S"_PrintTemplateID
		s retEpisodePrintRecordID = $O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",blankEpisodeID,blankPrintType,blankECRecordID,""))
	}
	
 	q retEpisodePrintRecordID
}

/// Desc:	取唯一模板的InstancePrintRecordID
ClassMethod GetSingleInstancePrtRecordID(AEpisodePrintRecordID As %String, APrintTemplateID As %String) As %String
{
	q:(AEpisodePrintRecordID = "")||(APrintTemplateID = "") ""
	s retInstancePrintRecordID = ""
	
	&sql(SELECT top 1 ID into :retInstancePrintRecordID FROM EPRinstance.InstancePrintRecord
 		WHERE EpisodePrintRecordID = :AEpisodePrintRecordID and PrintTemplateID = :APrintTemplateID)
	
	q retInstancePrintRecordID
}

/// Desc:	根据InstanceDataID获取可重复模板打印记录
ClassMethod GetMultiPrtRecord(AInstanceDataID As %String) As EPRservice.entity.EPrintRecord
{
	q:(AInstanceDataID = "") ""
	
	s instancePrintRecordID = ..GetMultiInstancePrtRecordID(AInstanceDataID)
	
	s objEPrintRecord = ..GetPrintRecordByID(instancePrintRecordID)
	q objEPrintRecord
}

/// Desc:	取可重复模板的EpisodePrintRecordID
ClassMethod GetMultiEpisodePrtRecordID(AEpisodeID As %String, AInstanceDataID As %String) As %String
{
	//b "s"
	q:(AEpisodeID = "")||(AInstanceDataID = "") ""
	
	s blankEpisodeID = " "_AEpisodeID
	s blankPrintType = " MULTIPLE"
	S blankECRecordID = " "_$P(AInstanceDataID, "||", 1)

	s episodePrintRecordID = $O(^DHCEPRI.EpisodePrintRecordI("IdxEpisodeAndECRecordID",blankEpisodeID,blankPrintType,blankECRecordID,""))
 	q episodePrintRecordID
}

/// Desc:	取可重复模板的InstancePrintRecordID
ClassMethod GetMultiInstancePrtRecordID(AInstanceDataID As %String) As %String
{
	q:(AInstanceDataID = "") ""
	s instancePrintRecordID = ""
	
	s blankInstanceDataID = " "_AInstanceDataID
 	s instancePrintRecordID  = $O(^DHCEPRI.InstancePrintRecordI("IdxInstanceDataID",blankInstanceDataID,""))
	
	q instancePrintRecordID
}

/// Desc:	获取打印记录实体对象
ClassMethod GetPrintRecordByID(AInstancePrintRecordID As %String) As EPRservice.entity.EPrintRecord
{
	q:(AInstancePrintRecordID = "") ""
	
	s objInstancePrintRecord = ##Class(EPRinstance.InstancePrintRecord).%OpenId(AInstancePrintRecordID)
	q:(objInstancePrintRecord = "") ""
	
	s episodePrintRecordID = objInstancePrintRecord.EpisodePrintRecordID
	s objEpisodePrintRecord = ##Class(EPRinstance.EpisodePrintRecord).%OpenId(episodePrintRecordID)
	q:(objEpisodePrintRecord = "") ""
	
	// 初始化返回值
	s objEPrintRecord = ##Class(EPRservice.entity.EPrintRecord).%New()
	
	// 取EpisodePrintRecord信息
	s objEPrintRecord.EpisodeID = objEpisodePrintRecord.EpisodeID
	s objEPrintRecord.PrintType = objEpisodePrintRecord.PrintType
	s objEPrintRecord.CurPageNum= objEpisodePrintRecord.CurPageNum
 	s objEPrintRecord.CurRowNum= objEpisodePrintRecord.CurRowNum 
 	s objEPrintRecord.EpisodePRID= episodePrintRecordID
	
	// 取InstancePrintRecord信息
	s objEPrintRecord.InstanceDataID = objInstancePrintRecord.InstanceDataID
	s objEPrintRecord.PrintTemplateID = objInstancePrintRecord.PrintTemplateID
	s objEPrintRecord.PrintTemplateVersion = objInstancePrintRecord.PrintTemplateVersion
	s objEPrintRecord.ContinuePrint = objInstancePrintRecord.ContinuePrint
	s objEPrintRecord.StartPageNum = objInstancePrintRecord.StartPageNum
	s objEPrintRecord.StartRowNum = objInstancePrintRecord.StartRowNum
	s objEPrintRecord.EndPageNum = objInstancePrintRecord.EndPageNum
	s objEPrintRecord.EndRowNum = objInstancePrintRecord.EndRowNum
	s objEPrintRecord.CreateUserID = objInstancePrintRecord.CreateUserID
	s objEPrintRecord.CreateDate = objInstancePrintRecord.CreateDate
	s objEPrintRecord.CreateTime = objInstancePrintRecord.CreateTime
	s objEPrintRecord.UpdateUserID = objInstancePrintRecord.UpdateUserID
	s objEPrintRecord.UpdateDate = objInstancePrintRecord.UpdateDate
	s objEPrintRecord.UpdateTime = objInstancePrintRecord.UpdateTime
	s objEPrintRecord.PrintStatus = objInstancePrintRecord.PrintStatus
	s objEPrintRecord.LastRowProperty = objInstancePrintRecord.LastRowProperty
	
	q objEPrintRecord
}

/// Desc:	根据实例数据ID获取对应界面模板绑定的打印模板ID
/// Input:	AInstanceID : 指定InstanceDataID
/// Output:	打印模板ID
ClassMethod GetBindPrtTplIDByInstanceID(AInstanceID As %String) As %String
{
	s bindPrintTemplateID = ""
	
	q:(AInstanceID = "") bindPrintTemplateID
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") bindPrintTemplateID
	q:(objInstance.TemplateID = "") bindPrintTemplateID
	
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(objInstance.TemplateID)
	q:(objTemplate = "") bindPrintTemplateID
	s bindPrintTemplateID = objTemplate.BindPrintTemplateID
	
	q bindPrintTemplateID
}

/// Desc: 	获取打印类型
ClassMethod GetPrintTypeByInstanceID(AInstanceID As %String) As %String
{
	q:(AInstanceID = "") ""
	s type = ""
	
	s ecRecordID = $P(AInstanceID, "||", 1)
	&sql(select ChartItemType into :type from EPRinstance.ECREcord where ID = :ecRecordID)
	
	s:(type = "Multi") type = "Multiple"
	q type
}

/// Desc:	获取EpisodeID
ClassMethod GetEpisodeIDByInstanceID(AInstanceID As %String) As %String
{
	q:(AInstanceID = "") ""
	s episodeID = ""
	
	s ecRecordID = $P(AInstanceID, "||", 1)
	&sql(select EpisodeID into :episodeID from EPRinstance.ECREcord where ID = :ecRecordID)
	
	s:(episodeID = $c(0)) episodeID = ""
	q episodeID
}

/// Desc:	新增EpisodePrintRecord
ClassMethod AddEpisodePrintRecord(AEPrintRecord As EPRservice.entity.EPrintRecord) As %String
{
	q:(AEPrintRecord = "") ""
	q:(AEPrintRecord.EpisodeID = "")||(AEPrintRecord.PrintType) ""
	q:(AEPrintRecord.PrintType '= "Single")&&(AEPrintRecord.InstanceDataID = "") ""
	
	s objEpisodePrintRecord = ##class(EPRinstance.EpisodePrintRecord).%New()
	s objEpisodePrintRecord.EpisodeID = AEPrintRecord.EpisodeID
	s objEpisodePrintRecord.PrintType = AEPrintRecord.PrintType
	s objEpisodePrintRecord.CurPageNum = AEPrintRecord.CurPageNum
	s objEpisodePrintRecord.CurRowNum = AEPrintRecord.CurRowNum
	if (AEPrintRecord.PrintType '= "Single")
	{
		//唯一模板不需设置EpisodePrintRecord.ECRecordID
		//不设置EpisodePrintRecord.ECRecordID, 其索引值为" "
		//设置EpisodePrintRecord.ECRecordID="", 其索引值为" "_$C(0)
		s ecRecordID = $P(AEPrintRecord.InstanceDataID, "||", 1)
		s objEpisodePrintRecord.ECRecordID = ecRecordID
	}
	s sc = objEpisodePrintRecord.%Save()
	
	q:($$$ISERR(sc)) ""
	q objEpisodePrintRecord.%Id()
}

/// Desc:	新增InstancePrintRecord
ClassMethod AddInstancePrintRecord(AEPrintRecord As EPRservice.entity.EPrintRecord) As %String
{
	//b "s"
	q:(AEPrintRecord = "") ""
	q:(AEPrintRecord.EpisodePRID = "") ""
	
 	s objInsPtRecord = ##class(EPRinstance.InstancePrintRecord).%New()
 	
	s objInsPtRecord.EpisodePrintRecordID = AEPrintRecord.EpisodePRID  	//EpisodePrintRecord.%Id()
	s objInsPtRecord.PrintType = AEPrintRecord.PrintType
	s objInsPtRecord.PrintTemplateID = AEPrintRecord.PrintTemplateID
	s objInsPtRecord.PrintTemplateVersion = AEPrintRecord.PrintTemplateVersion
	s objInsPtRecord.ContinuePrint = AEPrintRecord.ContinuePrint
	s objInsPtRecord.StartPageNum = AEPrintRecord.StartPageNum
	s objInsPtRecord.StartRowNum = AEPrintRecord.StartRowNum
	s objInsPtRecord.EndPageNum = AEPrintRecord.EndPageNum
	s objInsPtRecord.EndRowNum = AEPrintRecord.EndRowNum
	s objInsPtRecord.LastRowProperty = AEPrintRecord.LastRowProperty
	s objInsPtRecord.CreateDate = $P($H, ",", 1)
	s objInsPtRecord.CreateTime = $P($H, ",", 2)
	s objInsPtRecord.CreateUserID = AEPrintRecord.CreateUserID
	s:(objInsPtRecord.CreateUserID = "") objInsPtRecord.CreateUserID = AEPrintRecord.UpdateUserID		 
 	s objInsPtRecord.UpdateUserID = AEPrintRecord.UpdateUserID
	s objInsPtRecord.UpdateDate =  $P($H, ",", 1)
	s objInsPtRecord.UpdateTime =  $P($H, ",", 2)
	s objInsPtRecord.PrintStatus = AEPrintRecord.PrintStatus  
	if (AEPrintRecord.PrintType '= "Single")
	{
		s objInsPtRecord.InstanceDataID = AEPrintRecord.InstanceDataID 
	 	s objInsPtRecord.ECRecordID = $P(AEPrintRecord.InstanceDataID, "||", 1)
	 	s objInsPtRecord.ECRSeq = $P(AEPrintRecord.InstanceDataID, "||", 2)
	}
	 
	b "s"
	s sc = objInsPtRecord.%Save()
	q:($$$ISERR(sc)) ""
	
	q objInsPtRecord.%Id()
}

/// Desc:	更新InstancePrintRecord
ClassMethod UpdateInstancePrintRecord(AInstancePrintRecordID As %String, AEPrintRecord As EPRservice.entity.EPrintRecord) As %Boolean
{
	q:(AInstancePrintRecordID = "")||(AEPrintRecord = "") "0"
	q:(AEPrintRecord.EpisodePRID = "") "0"
	q:(AEPrintRecord.PrintType '= "Single")&&(AEPrintRecord.InstanceDataID = "") ""
	
 	s objInsPtRecord = ##class(EPRinstance.InstancePrintRecord).%OpenId(AInstancePrintRecordID)
 	q:(objInsPtRecord = "") "0"
 	
	s objInsPtRecord.EpisodePrintRecordID = AEPrintRecord.EpisodePRID  	//EpisodePrintRecord.%Id()
	s objInsPtRecord.PrintType = AEPrintRecord.PrintType
	s objInsPtRecord.PrintTemplateID = AEPrintRecord.PrintTemplateID
	s objInsPtRecord.PrintTemplateVersion = AEPrintRecord.PrintTemplateVersion
	s objInsPtRecord.ContinuePrint = AEPrintRecord.ContinuePrint
	s objInsPtRecord.StartPageNum = AEPrintRecord.StartPageNum
	s objInsPtRecord.StartRowNum = AEPrintRecord.StartRowNum
	s objInsPtRecord.EndPageNum = AEPrintRecord.EndPageNum
	s objInsPtRecord.EndRowNum = AEPrintRecord.EndRowNum
	s objInsPtRecord.LastRowProperty = AEPrintRecord.LastRowProperty
	s objInsPtRecord.UpdateUserID = AEPrintRecord.UpdateUserID
	s objInsPtRecord.UpdateDate =  $P($H, ",", 1)
	s objInsPtRecord.UpdateTime =  $P($H, ",", 2)
	s objInsPtRecord.PrintStatus = AEPrintRecord.PrintStatus  
	if (AEPrintRecord.PrintType '= "Single")
	{
		s objInsPtRecord.InstanceDataID = AEPrintRecord.InstanceDataID 
	 	s objInsPtRecord.ECRecordID = $P(AEPrintRecord.InstanceDataID, "||", 1)
	 	s objInsPtRecord.ECRSeq = $P(AEPrintRecord.InstanceDataID, "||", 2)
	}
	 
	s sc = objInsPtRecord.%Save()
	q:($$$ISERR(sc)) "0"
	
	q "1"
}

/// Desc:	作废InstancePrintRecord
ClassMethod InvalidInstancePrintRecord(AInstancePrintRecordID As %String) As %Boolean
{
	q:(AInstancePrintRecordID = "") "1"
	
	s record = ##class(EPRinstance.InstancePrintRecord).%OpenId(AInstancePrintRecordID)
	q:(record = "") "1"
	
	s record.PrintStatus = "UnPrint"
	s sc = record.%Save()
	q:($$$ISERR(sc)) "0"
	
	q "1"
}

/// Desc:	生成未打印过的EPRservice.entity.EPrintRecord实体对象
ClassMethod GenerateUnprintedEPrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String) As EPRservice.entity.EPrintRecord
{
	s objEPrintRecord = ##Class(EPRservice.entity.EPrintRecord).%New()
	
	// EpisodePrintRecord信息
	s objEPrintRecord.EpisodeID = AEpisodeID
	s objEPrintRecord.PrintType = APrintType
	s objEPrintRecord.CurPageNum = "1"
	s objEPrintRecord.CurRowNum = "1"
	
	// InstancePrintRecord信息
	s objEPrintRecord.EpisodePRID= ""
	s objEPrintRecord.InstanceDataID = AInstanceDataID
	s objEPrintRecord.PrintTemplateID = APrintTemplateID
	s objEPrintRecord.PrintTemplateVersion = ""
	s objEPrintRecord.ContinuePrint = 0
	s objEPrintRecord.StartPageNum = 1
	s objEPrintRecord.StartRowNum = 1
	s objEPrintRecord.EndPageNum = 0
	s objEPrintRecord.EndRowNum = 0
	s objEPrintRecord.CreateUserID = ""
	s objEPrintRecord.CreateDate = ""
	s objEPrintRecord.CreateTime = ""
	s objEPrintRecord.UpdateUserID = ""
	s objEPrintRecord.UpdateDate = ""
	s objEPrintRecord.UpdateTime = ""
	s objEPrintRecord.PrintStatus = "UnPrint"
	s objEPrintRecord.LastRowProperty = "0"
	
	q objEPrintRecord
}

/// Desc: 	清空唯一型模板打印记录
ClassMethod ClearSingleInstancePrintRecord(AEpisodeID As %String, APrintTemplateID As %String) As %Boolean
{
	q:(AEpisodeID = "")||(APrintTemplateID = "") "0"
	
	s episodePrintRecordID = ..GetSingleEpisodePrtRecordID(AEpisodeID, APrintTemplateID)
	q:(episodePrintRecordID = "") "1"
	
	s instancePrintRecordID = ..GetSingleInstancePrtRecordID(episodePrintRecordID, APrintTemplateID)
	q:(instancePrintRecordID = "") "1"
	
	q ..InvalidInstancePrintRecord(instancePrintRecordID)
}

}
