Class EPRservice.Quality.Ajax.GetEntryGrid Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s RuleID = 1 //$Get(%request.Data("RuleID",1),"-1")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s StructID = $Get(%request.Data("StructID",1),"-1")
	s SelectDec=$Get(%request.Data("SelectDec",1),"")
	s Action=$Get(%request.Data("Action",1),"")
    q:(RuleID = -1) $$$OK 
    s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(EpisodeID)
    s LocID = $P(ObjRet,"^",1)
    s EmployeeID = $P(ObjRet,"^",3)
    
	w ..GetGridJson(RuleID,LocID,EpisodeID,StructID,EmployeeID,SelectDec,Action)
	Quit $$$OK
}

/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Description:	获取json数据
/// Return:         按照规定格式拼的string类型数据串
/// Debug:  d ##class(EPRservice.Quality.Ajax.GetEntryGrid).GetGridJson(1,95,162,342,1,"","A")
ClassMethod GetGridJson(ARuleID As %String, ALocID As %String, AEpisodeID As %String, AStructID As %String, AEmployeeID As %String, Des As %String, Action As %String) As %String
{
	
	s json = ""
	s isFirstNode = 1
	s LocName = ""
	s EmployeeName = ""
	// 加载当前目录结构下当前标准的质控项目
	if (ALocID '= "")
    {
	    s LocName = $p(^CTLOC(ALocID),"^",2)
	}
	if (AEmployeeID '= "")&&(AEmployeeID'=0)
	{
		s SSUserID = ""
		s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",AEmployeeID,SSUserID))
		s EmployeeName = $p(^SSU("SSUSR",SSUserID),"^",2)
	}
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	s EntryID = "",Sequence = 1
	for {
		s:(IsBSQualityEnable'="Y") EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		s:(IsBSQualityEnable="Y") EntryID = $o(^CT.MA.QC.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		
		q:(EntryID = "")
		s:(IsBSQualityEnable'="Y") objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
		s:(IsBSQualityEnable="Y") objEntry = $g(^CT.MA.QC.QualityEntryD(EntryID))
		continue:(objEntry = "")
		
		s:(IsBSQualityEnable'="Y") EntryIsActive = $list(objEntry,8)
		s:(IsBSQualityEnable="Y") EntryIsActive = $list(objEntry,10)
		continue:(EntryIsActive '= "Y")
		s:(IsBSQualityEnable'="Y") StructID = $list(objEntry,3)
		s:(IsBSQualityEnable="Y") StructID = $list(objEntry,4)
		continue:(StructID'=AStructID)&&(AStructID'="")
		s QualityFlag=..GetQualityFlag(AEpisodeID,EntryID,ARuleID,Action)
		s Sequence = Sequence + 1
		s:(IsBSQualityEnable'="Y") PoolID = $list(objEntry,1)
		s:(IsBSQualityEnable="Y") PoolID = $list(objEntry,3)
		s:(IsBSQualityEnable'="Y") EntryScore = $list(objEntry,4)
		s:(IsBSQualityEnable="Y") EntryScore = $list(objEntry,5)
		s:(IsBSQualityEnable'="Y") objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)	
		s:(IsBSQualityEnable="Y") objPool=##class(CT.MA.QC.QualityPool).%OpenId(PoolID)	
		s DesC=objPool.Title		 
		s:(DesC[Des) ^CachePoolID("Sequence",Sequence) = PoolID_"^"_StructID_"^"_EntryID_"^"_EntryScore_"^"_QualityFlag
	}
	;b ;01
	s Sequence="",TotalCount=0
	for
	{
		s Sequence = $o(^CachePoolID("Sequence",Sequence))
		q:Sequence=""
		s obj = $g(^CachePoolID("Sequence",Sequence))
		s PoolID = $p(obj,"^",1)
		s StructID = $p(obj,"^",2)
		s EntryID = $p(obj,"^",3)
		s EntryScore = $p(obj,"^",4)
		s QualityFlag = $p(obj,"^",5)
		continue:(StructID'=AStructID)
		
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructID)
		s:(IsBSQualityEnable'="Y") EntryTitles = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		s:(IsBSQualityEnable="Y") EntryTitles = ##Class(CT.MA.QC.QualityPool).GetTitleByPoolID(PoolID)
		/*
		if (EntryTitles[".")
		{
			s EntryTitle = $p(EntryTitles,".",3)
		}
		else
		{
			s EntryTitle = EntryTitles
		}
		*/
		s EntryTitle = $tr(EntryTitles,"{","<")
		s EntryTitle = $tr(EntryTitles,"}",">")
		continue:(EntryTitle="")
		
		s TotalCount = TotalCount + 1
		
		if (isFirstNode = 0 ) {s json = json_","}
		s json = json_"{"
		s json = json_"""EprStruct"":"""_StructName_""","
		s json = json_"""EntryDesc"":"""_EntryTitle_""","
		s json = json_"""StructID"":"""_StructID_""","
		s json = json_"""EntryID"":"""_EntryID_""","
		s json = json_"""EntryScore"":"""_EntryScore_""","
		s json = json_"""LocID"":"""_ALocID_""","
		s json = json_"""LocName"":"""_LocName_""","
		s json = json_"""EmployeeID"":"""_AEmployeeID_""","
		s json = json_"""EmployeeName"":"""_EmployeeName_""","		
		s json = json_"""Remark"":"""_""_""","	
		s json = json_"""QualityFlag"":"""_QualityFlag_""","		
		s json = json_"""btnsave"":"""_"保存"_""","		
		s json = json_"""Number"":"""_1_"""}"
		s isFirstNode = 0
		k ^CachePoolID("Sequence",Sequence)
	}
	s json = "["_json_"]"
	q json
}

/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Description:	获取json数据
/// Return:         按照规定格式拼的string类型数据串
/// Debug:  w ##class(EPRservice.Quality.Ajax.GetEntryGrid).GetGridJsonNew(1,93,156,"",1,"项目","O")
ClassMethod GetGridJsonNew(ARuleID As %String, ALocID As %String, AEpisodeID As %String, AStructID As %String, AEmployeeID As %String, AContent As %String = "", Action As %String = "") As %String
{
	s ^CacheTemp("GetGridJson")=ARuleID_"^"_ALocID_"^"_AEpisodeID_"^"_AStructID_"^"_AEmployeeID_"^"_AContent_"^"_Action
	q:((AStructID="")&&(AContent="")) ""
	
	s jsonArr = ##class(%DynamicArray).%New()
	s isFirstNode = 1
	s LocName = ""
	s EmployeeName = ""
	s InpStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("InpStruct")
	s OutStruct = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("OutStruct")
	
	// 加载当前目录结构下当前标准的质控项目
	if (ALocID '= "")
    {
	    s LocName = $p(^CTLOC(ALocID),"^",2)
	}
	if (AEmployeeID '= "")&&(AEmployeeID'=0)
	{
		s SSUserID = ""
		s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",AEmployeeID,SSUserID))
		s EmployeeName = $p(^SSU("SSUSR",SSUserID),"^",2)
	}
	s EntryID = "",Sequence = 1
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:(EntryID = "")
		s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
		continue:(objEntry = "")
		
		s EntryIsActive = $list(objEntry,8)
		continue:(EntryIsActive '= "Y")
		s StructID = $list(objEntry,3)
		
		continue:((StructID'=AStructID)&&(AStructID'=""))
		
		s QualityFlag=..GetQualityFlag(AEpisodeID,EntryID,ARuleID,Action)
		s Sequence = Sequence + 1
		s PoolID = $list(objEntry,1)
		s EntryScore = $list(objEntry,4)
		
		s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)	
		s DesC=objPool.Title		 
		s ^CachePoolID("Sequence",Sequence) = PoolID_"^"_StructID_"^"_EntryID_"^"_EntryScore_"^"_QualityFlag
	}
	
	s Sequence="",TotalCount=0
	for
	{
		s Sequence = $o(^CachePoolID("Sequence",Sequence))
		q:Sequence=""
		s obj = $g(^CachePoolID("Sequence",Sequence))
		s PoolID = $p(obj,"^",1)
		s StructID = $p(obj,"^",2)
		s EntryID = $p(obj,"^",3)
		s EntryScore = $p(obj,"^",4)
		s QualityFlag = $p(obj,"^",5)
		s StructFlag = 0
		s tmpStructID = ""
		for{
			s:(Action["O") tmpStructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_InpStruct,tmpStructID))
			s:(Action'["O") tmpStructID = $O(^DHCEPRM.QualityStructI("IdxParentId"," "_OutStruct,tmpStructID))
			q:(tmpStructID="")
			s:(tmpStructID=StructID) StructFlag=1
			q:(StructFlag=1)
		}
		continue:(StructFlag=1)
		continue:((StructID'=AStructID)&&(AStructID'=""))
		
		s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructID)
		s EntryTitles = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		/*
		if (EntryTitles[".")
		{
			s EntryTitle = $p(EntryTitles,".",3)
		}
		else
		{
			s EntryTitle = EntryTitles
		}
		*/
		s EntryTitle = $tr(EntryTitles,"{","<")
		s EntryTitle = $tr(EntryTitles,"}",">")
		continue:(EntryTitle="")
		continue:((AContent'="")&&(EntryTitle'[AContent))
		
		s TotalCount = TotalCount + 1
		
		s jsonOBJ = {}
		s jsonOBJ.EprStruct = StructName
		s jsonOBJ.EntryDesc = EntryTitle
		s jsonOBJ.StructID = StructID
		s jsonOBJ.EntryID = EntryID
		s jsonOBJ.EntryScore = EntryScore
		s jsonOBJ.LocID = ALocID
		s jsonOBJ.LocName = LocName
		s jsonOBJ.EmployeeID = AEmployeeID
		s jsonOBJ.EmployeeName = EmployeeName
		s jsonOBJ.Remark = ""
		s jsonOBJ.QualityFlag = QualityFlag
		s jsonOBJ.btnsave = "保存"
		s jsonOBJ.Number = 1
		
		d jsonArr.%Push(jsonOBJ)
		k ^CachePoolID("Sequence",Sequence)
	}
	//S ^CacheTemp("0414")= jsonArr.%ToJSON()
	q jsonArr
}

ClassMethod GetQualityFlag(AEpisodeID As %String, AEntryID As %String, ARuleID As %String, Action As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AEpisodeID="")||(ARuleID="")||(Action="") ret
	s ResultID=""
    for
    {
	    s ResultID=$o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_ARuleID,ResultID))
	    q:(ResultID="")
	    s objResult=##class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	    s ResultAction=objResult.Action
	    continue:(ResultAction'=Action)
	    s flag=$d(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_AEntryID,ResultID))
	    continue:(flag'=10)
	    s ret=1
	}
	q ret
}

}
