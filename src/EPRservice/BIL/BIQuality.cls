/// Creator: Candyxu
/// Date:    2012-02-15
/// Desc:	 指控接口
Class EPRservice.BIL.BIQuality Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator: Candyxu
/// Date:    2012-02-15
/// Desc:    指控列表
/// Input:   AEpisodeID 就诊号
/// Output:	 ExamEntry为质控项目RowId;
/// 		 EntryDesc为质控项目描述;
/// 		 ResultRowid为质控结果RowId;
/// 		 DocName为患者主治医生名;
/// 		 DocRowid为患者主治医生RowId;
/// 		 EntryScore为质控项目分配的分数;
/// Debug:   d ##Class(%ResultSet).RunQuery("EPRservice.BIL.BIQuality","GetBIPromptList","50729")
Query GetBIPromptList(AEpisodeID As %String) As %Query(ROWSPEC = "ExamEntry,EntryDesc,ResultRowid,DocName,DocRowid,EntryScore")
{
}

ClassMethod GetBIPromptListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
 	Do ds.Execute(AEpisodeID,"")
 	While(ds.Next())
	{
		Set ExamEntry = ds.Data("ExamEntry")
		Set EntryDesc = ds.Data("EntryDesc")
		Set ResultRowid = ds.Data("ResultRowid")
		Set DocName = ds.Data("DocName")
		Set DocRowid = ds.Data("DocRowid")
		Set EntryScore = ds.Data("EntryScore")
		
	    Set Data = $lb(ExamEntry,EntryDesc,ResultRowid,DocName,DocRowid,EntryScore)
	    Set ^CacheTemp(repid,ind)=Data
	    Set ind = ind + 1 
	}
	Do ds.Close()
	Quit $$$OK
}

ClassMethod GetBIPromptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBIPromptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBIPromptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBIPromptListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// desc:接口：根据就诊号返回分数
/// Input:AEpisodeID 就诊号
/// Output: 分数
/// Debug: w ##Class(EPRservice.BIL.BIQuality).GetResultScore()
ClassMethod GetResultScore(AEpisodeID As %String) As %String
{
	if ($d(^DHCEPRM.QualityParamsI("IdxCode","EvaluationType"))>0)
	{
	   s ResultObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	   q ResultObj.GetLastEvaluation(AEpisodeID)
	}else
	{
		q ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
	}
}

/// Desc:接口：根据就诊号返回所有触犯条目明细
/// Input:AEpisodeID 就诊号
/// Output:	 ExamEntry为质控项目RowId;
/// 		 EntryDesc为质控项目描述;
/// 		 ResultRowid为质控结果RowId;
/// 		 DocName为患者主治医生名;
/// 		 DocRowid为患者主治医生RowId;
/// 		 EntryScore为质控项目分配的分数;
/// d ##Class(%ResultSet).RunQuery("EPRservice.BIL.BIQuality","GetResultDetailList","4")
Query GetResultDetailList(AEpisodeID As %String) As %Query(ROWSPEC = "ExamEntry,EntryDesc,DocName,DocRowid,EntryScore")
{
}

ClassMethod GetResultDetailListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(AEpisodeID = "") $$$OK
	s RuleIDs = ##Class(EPRservice.Quality.BOQualityReport).GetRuleIDsByRuleCodes("A^G")
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")
	s sc = rset.Execute(AEpisodeID,RuleIDs)
    While (rset.Next()){
	 s ExamEntry = rset.Data("EntryID") 
	 s EntryDesc = rset.Data("EntryTitle")
	 s DocName = rset.Data("EmployeeName")
	 s DocRowid = rset.Data("EmployeeID")
	 s EntryScore = rset.Data("EntryScore")
	 Set Data = $lb(ExamEntry,EntryDesc,DocName,DocRowid,EntryScore)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind = ind + 1 
    }
	Quit $$$OK
}

ClassMethod GetResultDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResultDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultDetailListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
