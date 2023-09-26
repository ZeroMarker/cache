Class EPRservice.Quality.Ajax.CompositeResult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s EpisodeID=$g(%request.Data("EpisodeID", 1), "")
	s Dictionary=$g(%request.Data("Dictionary", 1), "")
	s Action=$g(%request.Data("Action",1),"")
	s action=$g(%request.Data("action",1),"")
	s Input=$g(%request.Data("Input",1),"")
	s InstanceID=$g(%request.Data("InstanceID",1),"")
	if (Action="GetQualityResult")
	{
		w ..GetResultByEpisodeID(EpisodeID,Dictionary,action)
	}elseif (Action="SaveError")
	{
		//s ^tem("SaveError")=Input
		w ##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).SaveAiResult(Input)
	}
	
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			获取患者内涵及提示列表数据
/// Input:			AEpisodeID	就诊号 
/// 				ADictionary	字典代码
/// 				AAction		质控阶段
/// Output          触犯结果明细json
/// Debug:w ##Class(EPRservice.Quality.Ajax.CompositeResult).GetResultByEpisodeID("385","Intention","A")
ClassMethod GetResultByEpisodeID(AEpisodeID As %String, ADictionary As %String, AAction As %String = "")
{
	s rows = ""
	s count=0
	q:(AEpisodeID="")||(ADictionary="") ""
	for i=1:1:$l(ADictionary,"^")
	{
		s Dictionary=$p(ADictionary,"^",i)
		s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(AEpisodeID)
		s LocID = $P(ObjRet,"^",1)
		s EmployeeID = $P(ObjRet,"^",3)
		s mCurrRow = $g(^PAADM(AEpisodeID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)
		s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
		s sc = rset.Execute(AEpisodeID,"2_29_190",Dictionary)
		s Hours = "",StrDate = "",EndDate = "",FinishDate = "",OverFlag = ""
		s Button=0,ItemInDetail=0,ItemInAiResult=0,instanceid="",ResumeText=""
		if (Dictionary="Intention")
		{
			While rset.Next()
			{
				s StructName = rset.Get("StructName")_rset.Get("Resume")
				s StructName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
				s EntryScore = rset.Get("EntryScore")
				s EntryID = rset.Get("EntryID")
				s instanceInfo = rset.Get("instanceInfo")
				s instanceid=$p(instanceInfo,$c(0),1)
				s ResumeText=rset.Get("Resume")
				s Button=1
				s ItemInDetail=##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).IsAiItemInDetail(AEpisodeID,EntryID,ResumeText,AAction)
				s ItemInAiResult=##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).IsAiItemInAiResult(AEpisodeID,EntryID,StructName)
				s:(rows'="") rows=rows_"," 
				s rows = rows_"{""StructName"":"""_StructName_""",""StrDate"":"""_StrDate_""",""Name"":"""_Name_""",""EndDate"":"""_EndDate_""",""FinishDate"":"""_FinishDate_""",""OverFlag"":"""_OverFlag_""",""Hours"":"""_Hours_""",""EntryScore"":"""_EntryScore_""",""EntryID"":"""_EntryID_""",""LocID"":"""_LocID_""",""EmployeeID"":"""_EmployeeID_""",""Button"":"""_Button_""",""ItemInDetail"":"""_ItemInDetail_""",""ItemInAiResult"":"""_ItemInAiResult_""",""instanceid"":"""_instanceid_""",""ResumeText"":"""_ResumeText_"""}"
				s count=count+1	
				
			}
		}
		if (Dictionary="Prompt")
		{
			While rset.Next()
			{
				s mCurrRow = $g(^PAADM(AEpisodeID))
				s PAPMIDR = $p($g(mCurrRow),"^",1)
				s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
				s StructName = rset.Get("StructName")
				s StructName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
				s Hours = rset.Get("Hours")
				s StrDate = rset.Get("StrDate")
				s EndDate = rset.Get("EndDate")
				s FinishDate = rset.Get("FinishDate")
				s OverFlag = rset.Get("OverFlag")
				s EntryScore = rset.Get("EntryScore")
				s EntryID = rset.Get("EntryID")
				s:(Hours'="") Hours=$j(Hours,2,2)
				s:(Hours["-") Hours = $tr(Hours,"-","超")
				s:(rows'="") rows=rows_"," 
				s rows = rows_"{""StructName"":"""_StructName_""",""StrDate"":"""_StrDate_""",""Name"":"""_Name_""",""EndDate"":"""_EndDate_""",""FinishDate"":"""_FinishDate_""",""OverFlag"":"""_OverFlag_""",""Hours"":"""_Hours_""",""EntryScore"":"""_EntryScore_""",""EntryID"":"""_EntryID_""",""LocID"":"""_LocID_""",""EmployeeID"":"""_EmployeeID_""",""Button"":"""_Button_""",""ItemInDetail"":"""_ItemInDetail_""",""ItemInAiResult"":"""_ItemInAiResult_""",""instanceid"":"""_instanceid_""",""ResumeText"":"""_ResumeText_"""}"
				s count=count+1	
				
			}
		}
	}
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"
	q ret
}

}
