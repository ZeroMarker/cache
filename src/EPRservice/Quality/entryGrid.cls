/// Class Name:		EPRservice.Quality.entryGrid
/// Description:	与前台交互的服务
/// Creator:	    YHY
/// Create Date:	2012-10-28
Class EPRservice.Quality.entryGrid Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s RuleID = 1 //$Get(%request.Data("RuleID",1),"-1")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s StructID = $Get(%request.Data("StructID",1),"-1")
    q:(RuleID = -1) $$$OK 
    s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(EpisodeID)
    s LocID = $P(ObjRet,"^",1)
  
    s EmployeeID = $P(ObjRet,"^",3)
	//s ^Tempyhy("temp")=RuleID_"^"_LocID_"^"_EpisodeID_"^"_StructID_"^"_EmployeeID
    q:(RuleID = -1) $$$OK
   
	d ..GetGridJson(RuleID,LocID,EpisodeID,StructID,EmployeeID)
	Quit $$$OK
}

/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Description:	获取json数据
/// Return:         按照规定格式拼的string类型数据串
/// Debug:  d ##class(EPRservice.Quality.entryGrid).GetGridJson("1","297","323806",388,2738)
ClassMethod GetGridJson(ARuleID As %String, ALocID As %String, AEpisodeID As %String, AStructID As %String, AEmployeeID As %String) As %String
{
	
	s json = "["
	s isFirstNode = 1
	s LocName = ""
	s EmployeeName = ""
	// 加载当前目录结构下当前标准的质控项目
	if (ALocID '= "")
    {
	    s LocName = $p(^CTLOC(ALocID),"^",2)
	}
	if (AEmployeeID '= "")
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
		//b
		continue:(StructID'=AStructID)
		s Sequence = Sequence + 1
		s PoolID = $list(objEntry,1)
		s EntryScore = $list(objEntry,4)
		
		s ^CachePoolID("Sequence",Sequence) = PoolID_"^"_StructID_"^"_EntryID_"^"_EntryScore
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
		continue:(StructID'=AStructID)
		
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
		
		s TotalCount = TotalCount + 1
		
		if (isFirstNode = 0 ) {s json = json_","}
		
		s json = json_"{EprStruct:'"_StructName_"',"
		s json = json_"EntryDesc:'"_EntryTitle_"',"
		s json = json_"StructID:'"_StructID_"',"
		s json = json_"EntryID:'"_EntryID_"',"
		s json = json_"EntryScore:'"_EntryScore_"',"
		s json = json_"LocID:'"_ALocID_"',"
		s json = json_"LocName:'"_LocName_"',"
		s json = json_"EmployeeID:'"_AEmployeeID_"',"
		s json = json_"EmployeeName:'"_EmployeeName_"',"		
		//s json = json_"DirectorDoc:'"_DirectorDoc_"',"
		//s json = json_"DeDirDoc:'"_DeDirDoc_"',"
		//s json = json_"Attend:'"_Attend_"',"
		//s json = json_"Resident:'"_Resident_"',"
		//s json = json_"DirectorDocID:'"_DirectorDocID_"',"
		//s json = json_"DeDirDocID:'"_DeDirDocID_"',"
		//s json = json_"AttendID:'"_AttendID_"',"
		//s json = json_"ResidentID:'"_ResidentID_"',"
		s json = json_"Remark:'"_""_"',"		
		s json = json_"Number:'"_1_"'}"
		s isFirstNode = 0
		k ^CachePoolID("Sequence",Sequence)
	}
	s json = json_"]"
	w "{"
    w "TotalCount:'"_TotalCount_"'"
    w ",data:"_json_"}"
}

}
