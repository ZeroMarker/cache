/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityEntry
/// * Description:	质控项目Web服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityEntry Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityEntryInfo";

ClassMethod GetEntriesByRuleStructID(ARuleID As %String, AStructID As %String) As EPRservice.dataset.Quality.EQualityEntryDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EQualityEntryDataset).%New()
	d result.SetArgs(ARuleID, AStructID)
	q result
}

///  *****************************************************
///  功能：创建质控项目
///  结论：创建成功返回其RowID
///  *****************************************************
ClassMethod CreateQualityEntry(AEntry As EPRservice.entity.Quality.EQualityEntry) As %String [ WebMethod ]
{
	TStart
	s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%New()
	q:(objEntry = "") "ERROR"
	
	s objEntry.RuleDR = AEntry.RuleDR
	s objEntry.PoolDR = AEntry.PoolDR
	s objEntry.StructDR = AEntry.StructDR
	s objEntry.Score = AEntry.Score
	s objEntry.Sequence = AEntry.Sequence
	s objEntry.IsMultiErr = AEntry.IsMultiErr
	s objEntry.IsVeto = AEntry.IsVeto
	s objEntry.IsActive = AEntry.IsActive
	s objEntry.ResumeText = AEntry.ResumeText
	
	//判断待添加的质控规则是否已经存在于所选质控标准中
	if ($o(^DHCEPRM.QualityEntryI("IdxRulePool"," "_AEntry.RuleDR," "_AEntry.PoolDR,0))'="")
	{
		TRollBack
		q "-1"	
	}
 	if '(objEntry.%Save())
 	{
 		TRollBack
 		q "0"
 	} 
 	TCommit
 	q objEntry.%Id()
}

///  *****************************************************
///  功能：批量创建质控项目
///  结论：创建成功返回其RowID
///  Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).BatchCreateQualityEntrys("9^U102^11^0^37^N^N^Y|")
///  *****************************************************
ClassMethod BatchCreateQualityEntrys(AEntryString As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($d(AEntryString) = 0)||(AEntryString = "") ret
	
	s flag = 1
	TStart
	s entrys = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryString,"|")
	for Ind=1:1:$listlength(entrys) 
	{
		s entry = $listget(entrys,Ind)
		continue:(entry = "")

		s PoolDR = $p(entry,"^",2)
		s StructDR = $p(entry,"^",3)
		if (+StructDR = 0)
		{
			s objPool = $g(^DHCEPRM.QualityPoolD(PoolDR))
			s PoolType = $list(objPool,5)
			if (PoolType = "E")
			{
				s UnitID = $ZSTRIP(PoolDR,"*A")	
				continue:(UnitID = "")
				s objUnit=$g(^DHCEPRM.QualityTemplateD(+UnitID))		
				s TemplateID=$list(objUnit,1)
				continue:(TemplateID = "")
				
				s objTemplate = $g(^DHCEPRM.TemplateD(TemplateID))
				s TemplateCategoryID = $list(objTemplate,7)
				continue:(TemplateCategoryID = "")
		
				s StructDR = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_TemplateCategoryID,""))
				continue:(StructDR = "")
			}	
		} 
				
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%New()
		s objEntry.RuleDR = $p(entry,"^",1)
		s objEntry.PoolDR = PoolDR
		s objEntry.StructDR = StructDR
		s objEntry.Score = $p(entry,"^",4)
		s objEntry.Sequence = $p(entry,"^",5)
		s objEntry.IsMultiErr = $p(entry,"^",6)
		s objEntry.IsVeto = $p(entry,"^",7)
		s objEntry.IsActive = $p(entry,"^",8)
		s objEntry.ResumeText = $C(0)
		s objEntry.ChkConditionDR = 0
		s objEntry.EntryConditionDR = 0
		s objEntry.MaxScore = 0
		//根据唯一索引IdxRulePool判断该质控项目是否已存在
		s IsEntryExist = $d(^DHCEPRM.QualityEntryI("IdxRulePool"," "_objEntry.RuleDR," "_objEntry.PoolDR))
		if (IsEntryExist)
		{
			continue
		}
		else
		{
			if '(objEntry.%Save())
	 		{
	 			s flag = 0
	 			q
	 		}
		}
	}
	
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	else
	{
		TRollBack	
	}
	q ret
}

ClassMethod BatchRemoveEntriesByRuleID(ARuleID As %String) As %String
{
	s ret=0
	q:(ARuleID="")||($d(ARuleID)=0) ret
	
	s flag=1
	TStart
	s EntryID=""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:EntryID=""
		
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
		continue:objEntry=""
		
		if '(objEntry.%DeleteId(EntryID))
		{
			s flag=0
			q 
		}	
	}
	if (flag=1)
	{
		s ret=1
		TCommit
	}
	else
	{
		TRollBack	
	}
	q ret
}

ClassMethod GetQualityEntryByID(AEntryID As %String) As EPRservice.entity.Quality.EQualityEntry [ WebMethod ]
{
	s objEntry = ##class(EPRmeta.Quality.QualityEntry).%OpenId(AEntryID)
	q:(objEntry = "") ""
	
	s entry = ##class(EPRservice.entity.Quality.EQualityEntry).%New()
	s entry.ID = objEntry.%Id()
	s entry.RuleDR = objEntry.RuleDR
	s entry.PoolDR = objEntry.PoolDR
	s entry.StructDR = objEntry.StructDR
	s entry.Score = objEntry.Score
	s entry.VetoGrade = objEntry.VetoGrade
	s entry.Sequence = objEntry.Sequence
	s entry.IsMultiErr = objEntry.IsMultiErr
	s entry.IsVeto = objEntry.IsVeto
	s entry.IsActive = objEntry.IsActive
	s entry.ResumeText = objEntry.ResumeText
	s entry.MaxScore = objEntry.MaxScore
	
 	q entry
}

ClassMethod UpdateQualityEntry(AEntry As EPRservice.entity.Quality.EQualityEntry) As %String [ WebMethod ]
{
	TSTART
	s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(AEntry.ID)
	q:(objEntry = "") "ERROR"
	
	s objEntry.RuleDR = AEntry.RuleDR
	s objEntry.PoolDR = AEntry.PoolDR
	s objEntry.StructDR = AEntry.StructDR
	s objEntry.Score = AEntry.Score
	s objEntry.Sequence = AEntry.Sequence
	s objEntry.IsMultiErr = AEntry.IsMultiErr
	s objEntry.IsVeto = AEntry.IsVeto
	s:(objEntry.IsVeto="N") objEntry.VetoGrade = ""
	s:(objEntry.IsVeto="Y") objEntry.VetoGrade = AEntry.VetoGrade
	//s objEntry.VetoGrade = AEntry.VetoGrade
	s objEntry.IsActive = AEntry.IsActive
	s objEntry.ResumeText = AEntry.ResumeText
	s objEntry.ChkConditionDR = AEntry.ChkConditionDR
	s objEntry.EntryConditionDR = AEntry.EntryConditionDR
	s objEntry.MaxScore = AEntry.MaxScore
	
 	if '(objEntry.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objEntry.%Id()
}

ClassMethod BatchUpdateQualityEntrys(AEntryIDs As %String, AProperty As %String) As %String [ WebMethod ]
{
	s ret=0
	q:(AEntryIDs="" || AProperty="") ret
	
	s (IsActive,IsMultiErr,IsVeto,Score,Sequence)=""
	s EntryIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"|")
	s IsActive	= $p(AProperty,"^",1)
	s IsMultiErr= $p(AProperty,"^",2)
	s IsVeto	= $p(AProperty,"^",3)
	s Score		= $p(AProperty,"^",4)
	s Sequence	= $p(AProperty,"^",5)
	s VetoGrade	= $p(AProperty,"^",6)
	
	/*
	if ($p(AProperty,"^",7)="")
	{
		s ResumeText = $C(0)	
	}
	else
	{
		s ResumeText=$p(AProperty,"^",6)
	}
	*/
	
	TStart	
	for Ind=1:1:$listlength(EntryIDs)
	{
		s EntryID = $listget(EntryIDs,Ind)
		Continue:(EntryID="")
		
		s objEntry = ##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
		s objEntry.IsActive = IsActive
		s objEntry.IsMultiErr = IsMultiErr
		s objEntry.IsVeto = IsVeto
		s objEntry.Score = Score
		s objEntry.Sequence = Sequence
		s objEntry.VetoGrade = VetoGrade
		//s objEntry.ResumeText = ResumeText
		
		if '(objEntry.%Save())
	 	{
	 		TRollBack
	 	} 
	}
	TCommit
	s ret=1
	q ret
}

/// Debug:##Class(EPRservice.Quality.DataAccess.BOQualityEntry).DeleteEntryOrRelatedPool("46^U002|47^U004|","N")
ClassMethod DeleteEntryOrRelatedPool(AEntryPoolIDs As %String, ATogetherFlag As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:(AEntryPoolIDs = "") ret
	
	s:($g(ATogetherFlag) = "")||($g(ATogetherFlag) = $C(0)) ATogetherFlag = "N"
	s EntryPoolIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryPoolIDs,"|")
	for Ind = 1:1:$listlength(EntryPoolIDs) {
		s EntryPoolID = $listget(EntryPoolIDs,Ind)
		q:(EntryPoolID="")
		
		s EntryID = $p(EntryPoolID,"^",1)
		s PoolID = $p(EntryPoolID,"^",2)

		if (ATogetherFlag = "Y")
		{
			if (PoolID '= "" && PoolID '= $C(0))
			{
				//先删除与该质控规则相关的所有质控项目
				s RowId = $o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
				While(RowId '= "")
				{
					d ..DeleteQualityEntry(RowId)
					
					s RowId=$O(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,RowId))	
				}
				
				//同步删除质控规则
				d ##Class(EPRservice.Quality.DataAccess.BOQualityPool).DeleteQualityPool(PoolID)
				
				// 如果是完整性检查点，还需要将其模板单元信息删除
				s Type = $zcvt($e(PoolID,1),"U")
				if (Type = "E")
				{
					s UnitID = $ZSTRIP(PoolID,"*A")
					d ##Class(EPRmeta.Quality.QualityTemplate).DeleteQuaTemplateUnit(UnitID)
				}
			}
		}
		else
		{
			//只删除质控项目
			d ..DeleteQualityEntry(EntryID)	
		}
	}
	s ret=1
	q ret
}

ClassMethod DeleteQualityEntry(AEntryID As %String) As %Boolean
{
	TStart
	s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(AEntryID)
	q:(objEntry = "") 0
	
	if '(objEntry.%DeleteId(AEntryID))
 	{
	 	TRollBack
	 	q 0	
	}
	TCommit
	q 1
}

/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(1)
ClassMethod GetTitleByEntryID(AEntryID As %String) As %String
{
	s ret=""
	q:AEntryID="" ret
	
	s PoolID=$list($g(^DHCEPRM.QualityEntryD(AEntryID)),1)
	q:PoolID="" ret
	
	s ret=##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
	q ret
}

/// *************************************************************************************************************
/// ************************************QualityEntryScore related operations*************************************
/// *************************************************************************************************************
ClassMethod CreateEntryScore(AEntryScore As EPRservice.entity.Quality.EQualityEntryScore) As %String [ WebMethod ]
{
	TStart
	s objScore = ##Class(EPRmeta.Quality.QualityEntryScore).%New()
	q:(objScore = "") "ERROR"
	
	s objScore.EntryID 	  = AEntryScore.EntryID
	s objScore.EntryScore = AEntryScore.EntryScore
	s objScore.StartDate  = AEntryScore.StartDate
	s objScore.EndDate 	  = AEntryScore.EndDate
	s objScore.IsActive   = AEntryScore.IsActive
	s objScore.ResumeText = AEntryScore.ResumeText
	
 	if '(objScore.%Save())
 	{
 		TRollBack
 		q "0"
 	} 
 	TCommit
 	q objScore.%Id()
}

ClassMethod UpdateEntryScore(AEntryScore As EPRservice.entity.Quality.EQualityEntryScore) As %String [ WebMethod ]
{
	TStart
	s objScore = ##Class(EPRmeta.Quality.QualityEntryScore).%OpenId(AEntryScore.ID)
	q:(objScore = "") "ERROR"
	
	//s objScore.EntryID 	  = AEntryScore.EntryID
	s objScore.EntryScore = AEntryScore.EntryScore
	s objScore.StartDate  = AEntryScore.StartDate
	s objScore.EndDate 	  = AEntryScore.EndDate
	s objScore.IsActive   = AEntryScore.IsActive
	s objScore.ResumeText = AEntryScore.ResumeText
	
 	if '(objScore.%Save())
 	{
 		TRollBack
 		q "0"
 	} 
 	TCommit
 	q objScore.%Id()
}

ClassMethod DeleteEntryScore(AScoreID As %String) As %String [ WebMethod ]
{
	s objScore = ##Class(EPRmeta.Quality.QualityEntryScore).%OpenId(AScoreID)
 	q objScore.%DeleteId(AScoreID)
}

ClassMethod GetScoresByEntryID(AEntryID As %String) As EPRservice.dataset.Quality.EQualityScoreDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EQualityScoreDataset).%New()
	d result.SetArgs(AEntryID)
	q result
}

/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).AutoUpdateEntryScore()
ClassMethod AutoUpdateEntryScore() As %String
{
	s ret=0,flag=1
	TStart
	s RowID=""
	for {
		s RowID=$o(^DHCEPRM.QualityEntryD(RowID))
		q:RowID=""
		
		s CurrentScore=..GetEntryScoreByID(RowID,$h)
						
		s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(RowID)
		s objEntry.Score=CurrentScore
		
		s Status = objEntry.%Save()
		if $SYSTEM.Status.IsError(Status) 
		{                               
			s flag=0
			q 
		}
		d objEntry.%Close()		
	}
	if (flag=0)
	{
		TRollback	
	}
	else
	{
		TCommit
		s ret=1	
	}
	q ret
}

/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(54,"2010-09-25")
ClassMethod GetEntryScoreByID(AEntryID As %String, ARefDate As %String = "") As %String [ WebMethod ]
{
	s ret = 0
	q:(AEntryID = "") ret
	
	// 当EPRmeta_Quality.QualityEntryScore没有数据，也就是说不用时间段分数时取EPRmeta_Quality.QualityEntry中分数
	if $d(^DHCEPRM.QualityEntryScoreI("IdxEntry"," "_AEntryID)) = 0
	{
		if ($d(^DHCEPRM.QualityEntryD(AEntryID)) '= 0) s ret = $li(^DHCEPRM.QualityEntryD(AEntryID),4)
		q ret
	}
	
	s RefDate = ""
	if (ARefDate = "")
	{
		s RefDate = +$h
	}
	else
	{
		s RefDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARefDate)
		s RefDate = $p(RefDate," ",1)
	}
	
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRM.QualityEntryScoreI("IdxEntry"," "_AEntryID,RowID))
		q:(RowID = "")
		s objScore = $g(^DHCEPRM.QualityEntryScoreD(RowID))
		continue:($ZCVT($list(objScore,6),"U") '=  "Y")  // Add by Candyxu 当无效是不检查
		s StartDate = $list(objScore,4)
		s StartDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)
		s StartDate = $p(StartDate," ",1)
		s EndDate = $list(objScore,5)	
		s EndDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)
		s EndDate = $p(EndDate," ",1)
		
		if (RefDate >= StartDate) && (RefDate <= EndDate)
		{
			s ret = $list(objScore,3)
			q	
		}
	}
	q ret
}

ClassMethod GetEntryGradeByID(AEntryID As %String) As %String
{
	s ret=""
	q:(AEntryID="") ret
	
	s objEntry=$g(^DHCEPRM.QualityEntryD(+AEntryID))
	q:(objEntry="") ret
	
	s IsVeto=$list(objEntry,7)
	if (IsVeto="Y")
	{
		s VetoGrade=$list(objEntry,11)
		s ret=VetoGrade
	}	
	q ret
}

/// Desc: 根据entryId修改，entry的状态
/// Creator:WZL
/// CreateDate:21年10月12号10点06分
/// Input：entryId,isActive
/// Debug:w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).ChangeStateByEntryId("202","N")
ClassMethod ChangeStateByEntryId(entryId, isActive)
{
	s ret=0
	s ^temp("params")=entryId_":"_isActive
	q:(entryId="")||(isActive="") ret
	
	s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(entryId)
	
	s objEntry.IsActive=isActive
	
	q objEntry.%Save()
}

/// Desc: 		检查质控结构下质控条目
/// Creator:	Candy
/// CreateDate:	2014-9-23
/// Input:		AStructID 质控结构ID
/// 			ARuleID 质控标准ID
/// 			AEpisodeID 就诊号
///             AActionType 操作类型
/// 			AOtherParam 不同操作类型使用的参数
/// OutPut:     count 触犯条目数
/// Debug:		d ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntry(13,2,76,"2014","GetQualityResult","")
ClassMethod CheckEntry(AStructID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AActionType As %String, AOtherParam As %ArrayOfDataTypes, ATemplateID As %String) As %String
{
	s count = 0
	q:(AStructID = "")||(ARuleID ="")||(AEpisodeID ="") count
	s ^CacheTempResponseFlag(AUniqueKey)=1
	s EntryID = ""
	for
	{
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID,EntryID))
		q:(EntryID = "")
		
		///判断质控条目是否复合模板版本
		s EntryList="",EntryVersionList=""
		s EntryVersionList=##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("EntryVersion")
		s EntryList=##Class(EPRservice.Quality.CommonHelper).GetListFromString($p(EntryVersionList,"&",1),"^","Y")
		s Count=$listfind(EntryList,EntryID)
		if (Count>0)
		{
			s EntryVersion = $p($p(EntryVersionList,"&",2),"^",Count)
			
			s objInstance="",Version=""
			s:(AOtherParam'="") objInstance=##class(EMRinstance.InstanceData).%OpenId(AOtherParam)
			s:(objInstance'="") Version=objInstance.TemplateVersion  ///模板版本号
			
			continue:(Version'="")&&(Version<EntryVersion)
		}
		
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  
		continue:(objEntry = "")
		s isEntryActive = objEntry.IsActive   
		continue:(isEntryActive '= "Y")
		s poolId = objEntry.PoolDR    
		continue:(poolId = "")
		s objPool = ##Class(EPRmeta.Quality.QualityPool).%OpenId(poolId)
		continue:(objPool = "")
		continue:(objPool.IsActive '= "Y")
		///完整性范围检查
		s itemType = $e(poolId,1,1)
		if ((itemType = "M")||(itemType = "E"))
		{
			s qulaitTemplateId = $e(poolId,2,$l(poolId))
			s objQulaitTemplate = ##class(EPRmeta.Quality.QualityTemplate).%OpenId(qulaitTemplateId)
			continue:(objQulaitTemplate = "")
			continue:(objQulaitTemplate.IsActive '= "Y")
			continue:(ATemplateID '= objQulaitTemplate.TemplateId)
		}
		s EntryTitle = objPool.Title
		//检查条目过滤条件
	    s EntryConditionDR = objEntry.EntryConditionDR 
	    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
	    {
	       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,EntryConditionDR)
	       continue:(flag '= "1")
	    }
	    
	    //检查表达式
		s ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,AOtherParam,AUniqueKey)
		continue:(ExpressionResult >= 0)
		s ErrInfo=ExpressionResult
	    s ErrInfo=$p(ErrInfo,";",1,10)
		
		
		s count = count + 1
		
		if (AActionType = "AutoJob") 
		{
			s ExamCount = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetExamCount(objEntry,ExpressionResult)
			s JobDate = AOtherParam.GetAt("JobDate")
			s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID,JobDate)
			s EntryGrade = objEntry.VetoGrade  
			s DString = AOtherParam.GetAt("ResultID")_"^"_AEpisodeID_"^"_AOtherParam.GetAt("Employee")_"^"_EntryID_"^"_EntryScore_"^"_EntryGrade_"^"_JobDate_"^"_AOtherParam.GetAt("LocID")_"^"_ExamCount
			s RetID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SaveAutoResult(DString,ErrInfo)
		}
		elseif (AActionType = "GetQualityResult")	
		{
			//预警线
			s ChkConditionDR = objEntry.ChkConditionDR
			if ((ChkConditionDR '= "")&&(ChkConditionDR '= $c(0))&&(ChkConditionDR '="0"))    
			{
		     	s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,ChkConditionDR)
			    continue:(flag '= 1)      
			}
			//判断在那个阶段
			s PhaseColor = "#FFFFFF",PhaseName = "",PhaseId = 0
			s Phases = ##Class(EPRservice.Quality.DataAccess.BOQualityPhaseModify).GetQualityPhase(AEpisodeID,EntryID)
			s:(Phases '= "") PhaseId = $p(Phases,"^",1),PhaseName = $p(Phases,"^",2),PhaseColor = $p(Phases,"^",3)
			s EntryTitle = EntryTitle_"^"_PhaseName_"^"_PhaseColor
			s ^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,ARuleID,PhaseId,EntryID) = EntryTitle_"||"_ExpressionResult

		}
		elseif (AActionType = "GetProblemList")
		{
			s RuleTitle = ""
			s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(ARuleID)
			s:(objRule '= "") RuleTitle = objRule.Name
			//将违反规则的质控项目写入临时Global
			s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID) = RuleTitle
			s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID,EntryID) = EntryTitle
			k objRule
		}
		k objEntry,objPool			
	}
	k ^CacheTempResponseFlag(AUniqueKey)
	q count
}

/// Desc: 		检查质控结构下质控条目
/// Creator:	Candy
/// CreateDate:	2014-9-23
/// Input:		AStructID 质控结构ID
/// 			ARuleID 质控标准ID
/// 			AEpisodeID 就诊号
///             AActionType 操作类型
/// 			AOtherParam 不同操作类型使用的参数
/// OutPut:     count 触犯条目数
/// Debug:		d ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).CheckEntryNew(13,2,76,"2014","GetQualityResult","")
ClassMethod CheckEntryNew(AStructID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AActionType As %String, AOtherParam As %ArrayOfDataTypes, ATemplateID As %String) As %String
{
	s count = 0
	q:(AStructID = "")||(ARuleID ="")||(AEpisodeID ="") count
	s ^CacheTempResponseFlag(AUniqueKey)=1
	s ATemplateID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATemplateID,"^","Y")
	s EntryID = ""
	for
	{
		s EntryID = $o(^CT.MA.QC.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID,EntryID))
		q:(EntryID = "")
		s objEntry = ##Class(CT.MA.QC.QualityEntry).%OpenId(EntryID) 
		continue:(objEntry = "")
		s isEntryActive = objEntry.IsActive   
		continue:(isEntryActive '= "Y")
		s poolId = objEntry.PoolDR   
		continue:(poolId = "")
		s objPool = ##Class(CT.MA.QC.QualityPool).%OpenId(poolId)
		continue:(objPool = "")
		///完整性范围检查
		s itemType = $e(poolId,1,1)
		if ((itemType = "M")||(itemType = "E"))
		{
			s qulaitTemplateId = $e(poolId,2,$l(poolId))
			s objQulaitTemplate = ##class(CT.MA.QC.QualityTemplate).%OpenId(qulaitTemplateId)
			continue:(objQulaitTemplate = "")
			s GlossaryInternalID=objQulaitTemplate.GlossaryInternalID
			s ElementCode=GlossaryInternalID
			s TemplateID=$p($p(ElementCode,"#",3),":",2)
		    continue:($listfind(ATemplateID,TemplateId) <= 0) 
			
		}
		s EntryTitle = objPool.Title
		//检查条目过滤条件
	    s EntryConditionDR = objEntry.EntryConditionDR
	    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
	    {
	       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValueNew(AEpisodeID,EntryConditionDR)
	       continue:(flag '= "1")
	    }
	    
	    //检查表达式
		s ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainValNew(AEpisodeID,EntryID,AOtherParam,AUniqueKey)
		continue:(ExpressionResult >= 0)
		s ErrInfo=ExpressionResult
	    s ErrInfo=$p(ErrInfo,";",1,10)
		
		
		s count = count + 1
		if (AActionType = "AutoJob") 
		{
			s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
			s:(IsBSQualityEnable'="Y") ExamCount = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetExamCount(objEntry,ExpressionResult)
			s:(IsBSQualityEnable="Y") ExamCount = 1
			s JobDate = AOtherParam.GetAt("JobDate")
			s EntryScore = objEntry.Score
			s EntryGrade = objEntry.VetoGrade  
			s DString = AOtherParam.GetAt("ResultID")_"^"_AEpisodeID_"^"_AOtherParam.GetAt("Employee")_"^"_EntryID_"^"_EntryScore_"^"_EntryGrade_"^"_JobDate_"^"_AOtherParam.GetAt("LocID")_"^"_ExamCount
			s RetID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SaveAutoResult(DString,ErrInfo)
		}
		elseif (AActionType = "GetQualityResult")	
		{
			//预警线
			s ChkConditionDR = objEntry.EntryConditionDR
			if ((ChkConditionDR '= "")&&(ChkConditionDR '= $c(0))&&(ChkConditionDR '="0"))    
			{
		     	s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValueNew(AEpisodeID,ChkConditionDR)
			    continue:(flag '= 1)      
			}
			//判断在那个阶段
			s PhaseColor = "#FFFFFF",PhaseName = "",PhaseId = 0
			//s Phases = ##Class(EPRservice.Quality.DataAccess.BOQualityPhaseModify).GetQualityPhase(AEpisodeID,EntryID)
			//s:(Phases '= "") PhaseId = $p(Phases,"^",1),PhaseName = $p(Phases,"^",2),PhaseColor = $p(Phases,"^",3)
			s EntryTitle = EntryTitle_"^"_PhaseName_"^"_PhaseColor
			s ^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,ARuleID,PhaseId,EntryID) = EntryTitle_"||"_ExpressionResult

		}
		elseif (AActionType = "GetProblemList")
		{
			s RuleTitle = ""
			s objRule = ##Class(CT.MA.QC.QualityRule).%OpenId(ARuleID)
			s:(objRule '= "") RuleTitle = objRule.Name
			//将违反规则的质控项目写入临时Global
			s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID) = RuleTitle
			s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID,EntryID) = EntryTitle
			k objRule
		}
		k objEntry,objPool			
	}
	k ^CacheTempResponseFlag(AUniqueKey)
	q count
}

/// 通过EntryID获取StructID
/// input entryID
/// output structid
/// wei
/// w ##class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructByID(2)
ClassMethod GetStructByID(EntryID As %String) As %String
{
	s ret=""
	q:(EntryID="") ret
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable'="Y")
	{
		s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
	}
	else
	{
		s objEntry=##class(CT.MA.QC.QualityEntry).%OpenId(EntryID)
	}
	q:(objEntry="") ret
	s StructID=objEntry.StructDR
	d objEntry.%Close()
	s ret=StructID
	q ret
}

/// Debug:w ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructIDByEntry()
ClassMethod GetStructIDByEntry(AEntryID)
{
	s ret=""
	q:(AEntryID="") ret
	s obj=##class(EPRmeta.Quality.QualityEntry).%OpenId(AEntryID)
	S StructID=obj.StructDR
	s ret=StructID
	q ret
}

}
