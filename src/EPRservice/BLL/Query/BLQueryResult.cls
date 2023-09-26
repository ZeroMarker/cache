/// 名称：EPRservice.BLL.Query.BLQueryResult
/// 描述：查询结果业务逻辑对象
/// 创建者：houjian
/// 创建日期：2011-06-03
Class EPRservice.BLL.Query.BLQueryResult Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Property GUID As %String(TRUNCATE = 1);

Property ColumnList As %ListOfDataTypes;

Property BLTempGlobalMgr As EPRservice.BLL.Query.BLQueryGlobalMgr;

Property BLHISInfo As EPRservice.BLL.Query.BLHISInfo;

Property BLEPRInfo As EPRservice.BLL.Query.BLEPRInfo;

Property BLLISInfo As EPRservice.BLL.Query.BLLISInfo;

Property BLGlossary As EPRservice.BLL.Query.BLGlossaryInfo;

/// Desc:	实例化查询结果业务逻辑对象
ClassMethod CreateInstance(AGUID As %String, AColumnList As %List) As EPRservice.BLL.Query.BLQueryResult
{
	s obj = ##Class(EPRservice.BLL.Query.BLQueryResult).%New()
	s obj.GUID = AGUID
	s obj.ColumnList = AColumnList
	s obj.BLTempGlobalMgr = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).CreateInstance(AGUID)
	q obj
}

/// Desc:	实例化查询结果业务逻辑对象
ClassMethod CreateInstanceByColText(AGUID As %String, AColumnText As %List) As EPRservice.BLL.Query.BLQueryResult
{
	s list = ..ColumnStrToList(AColumnText)
	q ..CreateInstance(AGUID, list)
}

ClassMethod ColumnStrToList(AColumnStr As %String) As %ListOfDataTypes
{
	s count = $L(AColumnStr, "&")
	s list = ##Class(%ListOfDataTypes).%New()
	for i = 1:1:count
	{
		d list.Insert($P(AColumnStr, "&", i))
	}
	q list
}

/// Desc:	获取查询结果
Method GetResultByKey(AKey) As %List
{
	s result = ""
	
	s totCount = %this.BLTempGlobalMgr.GetEpisodeCount()
	q:(AKey > totCount) result
	
	if (%this.BLTempGlobalMgr.IsResultExistedAt(AKey))
	{
		s result = %this.BLTempGlobalMgr.GetResultAt(AKey)
	}
	else
	{
		s episodeID = %this.BLTempGlobalMgr.GetEpisodeIDAt(AKey)
		s result = ..GetQueryResult(episodeID)
		d %this.BLTempGlobalMgr.SetResultAt(result, AKey)
	}
	q result
}

/// Desc:	清空存储查询结果的临时Global
Method ClearResultGlobal(AGUID As %String)
{
	d %this.BLTempGlobalMgr.ClearGlobal()
}

Method GetQueryResult(AEpisodeID As %String) As %List
{
	s result = ""
	
	//检查入参
	q:(AEpisodeID = "") result
	
	//初始化查询业务逻辑对象
	d ..InitBLObject(AEpisodeID)
	
	//获取查询结果
	s count = %this.ColumnList.Count()
	for i = 1:1:count
	{
		s item = %this.ColumnList.GetAt(i)
		s type = $p(item, "^", 1)
		s colName = $p(item, "^", 2)
		s code = $p(item, "^", 3)
		s itemResult = ""
		if (type = "HIS")
		{
			s itemResult = $ZOBJMETHOD(%this.BLHISInfo, code)
		}
		elseif (type = "EPR")
		{
			S itemResult = %this.BLEPRInfo.GetEPRData(code)
		}
		elseif (type = "LIS")
		{
			s itemResult = %this.BLLISInfo.GetLISData(code)
		}
		elseif (type = "Glossary")
		{
			s itemResult = %this.BLGlossary.GetGlossaryData(code) 
		}
		
		s result = result_$LB(itemResult)
	}
	q result
}

Method InitBLObject(AEpisodeID As %String)
{
	if (%this.BLHISInfo = "") 
	{
		s %this.BLHISInfo = ##Class(EPRservice.BLL.Query.BLHISInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLHISInfo.SetEpisodeID(AEpisodeID)
	
	if (%this.BLEPRInfo = "")
	{
		s %this.BLEPRInfo = ##Class(EPRservice.BLL.Query.BLEPRInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLEPRInfo.SetEpisodeID(AEpisodeID)
	
	if (%this.BLLISInfo = "")
	{
		s %this.BLLISInfo = ##Class(EPRservice.BLL.Query.BLLISInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLLISInfo.SetEpisodeID(AEpisodeID)
	
	if (%this.BLGlossary = "")
	{
		s %this.BLGlossary = ##Class(EPRservice.BLL.Query.BLGlossaryInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLGlossary.SetEpisodeID(AEpisodeID)
}

/// Desc:	测试方法
/// Debug:	d ##Class(EPRservice.BLL.Query.BLQueryResult).Test()
ClassMethod Test()
{
	s AStartAdmDate = "2010-10-9"
	s AEndAdmDate = "2010-10-9"
	s AStartAdmDate = $zdh(AStartAdmDate,3)
	s AEndAdmDate = $zdh(AEndAdmDate,3)
	s AAdmNo = "", APatNo = "", AName= ""
	
	s AColumnsStr = "HIS^Name^Name"
	s AColumnsStr = AColumnsStr_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V"
	s AColumnsStr = AColumnsStr_"&EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V"
	/*
	s colCount = $L(AColumnsStr, ",")
	s columnList = ##Class(%ListOfDataTypes).%New()
	for i = 1:1:colCount
	{
		d columnList.Insert($P(AColumnsStr, ",", i))
	}
	*/
	
	s guid = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).GetGUID()
	
	s blBasicQuery = ##Class(EPRservice.BLL.Query.BLQueryBasic).CreateInstance(guid)
	s count = blBasicQuery.SetAdmListIntoGlobal("","","",AStartAdmDate,AEndAdmDate,"","")
	
	s blItemResult = ##Class(EPRservice.BLL.Query.BLQueryResult).CreateInstanceByColText(guid,AColumnsStr)
	for i = 1:1:count
	{
		s dataList = blItemResult.GetResultByKey(i)
		//s dataList = blItemResult.GetQueryResult("201869")
		if dataList = "" 
		{
			w !, "result "_i_" is null"
		}
		else
		{
			w !, "result "_i_" :"
			s length = $LL(dataList)
			for j = 1:1:length
			{
				w !, $ListGet(dataList,j)
			}
		}
	}
	
	w !,"Test is OK"
}

}
