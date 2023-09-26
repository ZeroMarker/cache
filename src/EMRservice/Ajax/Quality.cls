/// Desc:个性化方法汇总
/// Creator:yangkang
/// Add at 2017-6-14
Class EMRservice.Ajax.Quality Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	s EpisodeID=$g(%request.Data("EpisodeID", 1), "")
	s RuleID=$g(%request.Data("RuleID", 1), "")
	s CTLocatID = $g(%request.Data("CTLocatID", 1), "")
	s userID = $g(%request.Data("userID", 1), "")
	s Action=$g(%request.Data("Action",1),"")
	s action=$g(%request.Data("action",1),"")
	s:userID'="" UserID = $P(^SSU("SSUSR",userID),"^",14)
	s:userID="" UserID = userID
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (Action="GetQualityResult")
	{
		if (IsBSQualityEnable'="Y")
		{
			w ..GetQualityResult(CTLocatID,UserID,EpisodeID,RuleID)
		}
		else
		{
			w ..GetQualityResultNew(CTLocatID,UserID,EpisodeID,RuleID)
		}
	}				
	elseif (Action="GetProfilerList")
	{
		w ..GetProfilerList(CTLocatID,UserID,EpisodeID,action)
	}
	elseif (Action="GetSYQualityResult")
	{
		w ..GetSYQualityResult(EpisodeID,RuleID)
	}
	Quit $$$OK
	
ErrorHandler
   w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.Quality).GetQualityResult(190,4730,"",2)
ClassMethod GetQualityResult(ACTLocatID As %String, AUserID As %String, AEpisodeID As %String, ARuleID As %String)
{
	s rows = ""
	//s rows = ##class(%GlobalCharacterStream).%New()

	s count=0
	q:((AEpisodeID="")&&(ACTLocatID="")) ""
	Set langid=20
    if ($d(%session))
    {
		set langid=+$g(%session.Data("LOGON.LANGID"))
    }
	//s ^tempyhy("GetQualityResult") = AEpisodeID_"^"_ARuleID
	if (AEpisodeID'="")
	{
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
	s sc = rset.Execute(AEpisodeID,"2_29_190")
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
		s HoursDisplay=##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title","超",langid)
		s:(Hours["-") Hours = HoursDisplay_$tr(Hours,"-","")
		//s:(Hours["-") Hours = $tr(Hours,"-",HoursDisplay)
		//d rows.Write("{""StructName"":"""_StructName_"""")
		//d rows.Write(",""StrDate"":"""_rset.Get("StrDate")_"""")
		//d rows.Write(",""Name"":"""_Name_"""")
		//d rows.Write(",""EndDate"":"""_rset.Get("EndDate")_"""")
		//d rows.Write(",""FinishDate"":"""_rset.Get("FinishDate")_"""")
		//d rows.Write(",""OverFlag"":"""_rset.Get("OverFlag")_"""")
		//d rows.Write(",""Hours"":"""_Hours_"""}")
		s:(rows'="") rows=rows_"," 
		s rows = rows_"{""StructName"":"""_StructName_""",""StrDate"":"""_StrDate_""",""Name"":"""_Name_""",""EndDate"":"""_EndDate_""",""FinishDate"":"""_FinishDate_""",""OverFlag"":"""_OverFlag_""",""Hours"":"""_Hours_"""}"
		s count=count+1	
		
		}
	}
	else
	{
		s Date=""
		for {
			s Date = $O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date))
			q:(Date="")
		
			s Time=""
			for {
				s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time))
				q:(Time="")
			
				s PAADMRowID=""
				s PatDoc = ""
				for {
					
					s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time,PAADMRowID))
					q:(PAADMRowID="")
					s PatientID=$P(^PAADM(PAADMRowID),"^",1)
					//患者姓名
					s Name=$P(^PAPER(PatientID,"ALL"),"^",1)	   
					s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
					//s UserID=$P($g(^SSU("SSUSR",AUserID)),"",14)
					continue:(PatDoc '= AUserID)
					
					s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
					s sc = rset.Execute(PAADMRowID,"2_29_190")
					While rset.Next()
					{
						s StructName = rset.Get("StructName")
						s StructName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
						s Hours = rset.Get("Hours")
						s StrDate = rset.Get("StrDate")
						s EndDate = rset.Get("EndDate")
						s FinishDate = rset.Get("FinishDate")
						s OverFlag = rset.Get("OverFlag")
						s HoursDisplay=##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title","超",langid)
						s:(Hours["-") Hours = HoursDisplay_$tr(Hours,"-","")
						
						/*
						d rows.Write("{""StructName"":"""_StructName_"""")
						d rows.Write(",""StrDate"":"""_rset.Get("StrDate")_"""")
						d rows.Write(",""Name"":"""_Name_"""")
						d rows.Write(",""EndDate"":"""_rset.Get("EndDate")_"""")
						d rows.Write(",""FinishDate"":"""_rset.Get("FinishDate")_"""")
						d rows.Write(",""OverFlag"":"""_rset.Get("OverFlag")_"""")
						d rows.Write(",""Hours"":"""_Hours_"""}")*/
						s:(rows'="") rows=rows_"," 
						s rows = rows_"{""StructName"":"""_StructName_""",""StrDate"":"""_StrDate_""",""Name"":"""_Name_""",""EndDate"":"""_EndDate_""",""FinishDate"":"""_FinishDate_""",""OverFlag"":"""_OverFlag_""",""Hours"":"""_Hours_"""}"
						s count=count+1	
						
					}
				}
			}
		}
		
	}
	//d rows.Write("{""total"":"_count_",""rows"":["_rows_"]}")
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"
	q ret
}

/// w ##Class(EMRservice.Ajax.Quality).GetQualityResultNew(334,"","156",1)
ClassMethod GetQualityResultNew(ACTLocatID As %String, AUserID As %String, AEpisodeID As %String, ARuleID As %String)
{
	s rows = ""
	s jsonArr = ##class(%DynamicArray).%New()
	s count=0
	q:((AEpisodeID="")&&(ACTLocatID="")) ""
	if (AEpisodeID'="")
	{
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
	s sc = rset.Execute(AEpisodeID,"2_29_190")
	While rset.Next()
	{
		s jsonOBJ = {}
		s mCurrRow = $g(^PAADM(AEpisodeID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)
		s jsonOBJ.Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		s StructName = rset.Get("StructName")
		s jsonOBJ.EntryName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
		s Hours = rset.Get("Hours")
		s jsonOBJ.StrDate = rset.Get("StrDate")
		s jsonOBJ.EndDate = rset.Get("EndDate")
		s jsonOBJ.FinishDate = rset.Get("FinishDate")
		s jsonOBJ.OverFlag = rset.Get("OverFlag")
		s:(Hours'="") jsonOBJ.Hours=$j(Hours,2,2)
		s:(Hours["-") jsonOBJ.Hours = $tr(Hours,"-","超")
		d jsonArr.%Push(jsonOBJ)	
		
		}
	}
	else
	{
		s Date=""
		for {
			s Date = $O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date))
			q:(Date="")
		
			s Time=""
			for {
				s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time))
				q:(Time="")
			
				s PAADMRowID=""
				s PatDoc = ""
				for {
					
					s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time,PAADMRowID))
					q:(PAADMRowID="")
					s PatientID=$P(^PAADM(PAADMRowID),"^",1)
					//患者姓名
					s Name=$P(^PAPER(PatientID,"ALL"),"^",1)	   
					s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
					//s UserID=$P($g(^SSU("SSUSR",AUserID)),"",14)
					continue:(PatDoc '= AUserID)
					
					s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetQualityResultList")
					s sc = rset.Execute(PAADMRowID,"2_29_190")
					While rset.Next()
					{
						s jsonOBJ = {}
						s StructName = rset.Get("StructName")
						s jsonOBJ.EntryName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
						s Hours = rset.Get("Hours")
						s jsonOBJ.StrDate = rset.Get("StrDate")
						s jsonOBJ.EndDate = rset.Get("EndDate")
						s jsonOBJ.FinishDate = rset.Get("FinishDate")
						s jsonOBJ.OverFlag = rset.Get("OverFlag")
						s:(Hours'="") jsonOBJ.Hours=$j(Hours,2,2)
						s:(Hours["-") jsonOBJ.Hours = $tr(Hours,"-","超")
						d jsonArr.%Push(jsonOBJ)
						
					}
				}
			}
		}
		
	}
	q jsonArr
}

/// w ##Class(EMRservice.Ajax.Quality).GetSYQualityResult(1365,5)
ClassMethod GetSYQualityResult(AEpisodeID As %String, ARuleID As %String)
{
	q:AEpisodeID="" ""
	s rows = ""
	s count=0,result=""
	s AUniqueKey=$i(^CacheTemp)
	s count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(342,ARuleID,AEpisodeID,AUniqueKey,"GetProblemList","")
	
	q:count=0 result
	
	s EntryDR = ""
    for 
    {
	    s EntryDR = $O(^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID,EntryDR))
	    q:(EntryDR = "")
	    s EntryName = $g(^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID,EntryDR))
	    s EntryName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(EntryName)
	    s EntryName=$tr(EntryName,"\")
	    s EntryName=$tr(EntryName,":")
	    //s EntryName=$tr(EntryName,".")
		s mCurrRow = $g(^PAADM(AEpisodeID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)
		s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	    s:(rows'="") rows=rows_"," 
	 	s rows = rows_"{""StructName"":"""_EntryName_""",""Name"":"""_Name_"""}"
		s count=count+1	
    }
	
	k ^CacheTemp("EPRQuality",AUniqueKey)
	
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"
	q ret
}

/// w ##Class(EMRservice.Ajax.Quality).GetProfilerList(1154030)
ClassMethod GetProfilerList(ACTLocatID As %String, AUserID As %String, AEpisodeID As %String, Action As %String) As %String
{
	s rows=""
	s count=0
	q:((AEpisodeID="")&&(ACTLocatID="")) ""
	if (AEpisodeID'="")
	{
		s rset = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage:GetMessagesByEpisodeID")
		//s columns = rset.GetColumnCount()
		s sc = rset.Execute(AEpisodeID,"","A")
		While rset.Next()
		{
			s mCurrRow = $g(^PAADM(AEpisodeID))
			s PAPMIDR = $p($g(mCurrRow),"^",1)
			s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
			s MessageTitle = rset.Get("MessageTitle")
			continue:(Action="A")&&(MessageTitle'="环节质控消息")
			s MessageBody = rset.Get("MessageBody")
			s MessageBody = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MessageBody)
			s ResumeText = rset.Get("ResumeText")
			s:(MessageBody'["备注") MessageBody= MessageBody_" 备注："_ResumeText
			s CreateDate = rset.Get("CreateDate")
			s CreateTime = rset.Get("CreateTime")
			s CreateDateTime = CreateDate_" "_CreateTime
			s CreateUserDesc = rset.Get("CreateUserDesc")
			s ExecuteStatus = rset.Get("ExecuteStatus")
			//continue:ExecuteStatus="已执行"
			s MessageID = rset.Get("RowID")
			s ExecuteDate = rset.Get("ExecuteDate")
			s ExecuteTime = rset.Get("ExecuteTime")
			s ExecuteDateTime = ExecuteDate_" "_ExecuteTime
			s EntryID = rset.Get("EntryID")
			s StructID = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructByID(EntryID)
			s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructID)
			s EntryScore = rset.Get("EntryScore")
			s ExamCount = rset.Get("ExamCount")
			s Score = ""
			s:(ExamCount'="") Score = EntryScore*ExamCount
		
			s:(rows'="") rows=rows_"," 
			s rows = rows_"{""MessageBody"":"""_MessageBody_""",""CreateDateTime"":"""_CreateDateTime_""",""Name"":"""_Name_""",""CreateUserDesc"":"""_CreateUserDesc_""",""ExecuteStatus"":"""_ExecuteStatus_""",""MessageID"":"""_MessageID_""",""ExecuteDateTime"":"""_ExecuteDateTime_""",""StructName"":"""_StructName_""",""EntryScore"":"""_EntryScore_""",""ExamCount"":"""_ExamCount_""",""Score"":"""_Score_""",""ResumeText"":"""_ResumeText_"""}"
			s count=count+1	
		}
	}
	else
	{
		s Date=""
		for {
			s Date = $O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date))
			q:(Date="")
		
			s Time=""
			for {
				s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time))
				q:(Time="")
			
				s PAADMRowID=""
				s PatDoc = ""
				for {
					
					s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",ACTLocatID,Date,Time,PAADMRowID))
					q:(PAADMRowID="")
					s PatientID=$P(^PAADM(PAADMRowID),"^",1)
					//患者姓名
					s Name=$P(^PAPER(PatientID,"ALL"),"^",1)	   
					s PatDoc=$P($g(^PAADM(PAADMRowID)),"^",9)
					continue:(PatDoc '= AUserID)
					s rset = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage:GetMessagesByEpisodeID")
					s sc = rset.Execute(PAADMRowID)
					While rset.Next()
					{
						s MessageBody = rset.Get("MessageBody")
						s MessageBody = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MessageBody)
						s ResumeText = rset.Get("ResumeText")
						s:(MessageBody'["备注") MessageBody= MessageBody_" 备注："_ResumeText
						s CreateDate = rset.Get("CreateDate")
						s CreateTime = rset.Get("CreateTime")
						s CreateDateTime = CreateDate_" "_CreateTime
						s CreateUserDesc = rset.Get("CreateUserDesc")
						s ExecuteStatus = rset.Get("ExecuteStatus")
						//continue:ExecuteStatus="已执行"
						s MessageID = rset.Get("RowID")
						s ExecuteDate = rset.Get("ExecuteDate")
						s ExecuteTime = rset.Get("ExecuteTime")
						s ExecuteDateTime = ExecuteDate_" "_ExecuteTime
						s EntryID = rset.Get("EntryID")
						s StructID = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructByID(EntryID)
						s StructName = ##Class(EPRservice.Quality.GetStructResult).GetStructByStructID(StructID)
						s EntryScore = rset.Get("EntryScore")
						s ExamCount = rset.Get("ExamCount")
						s Score = ""
						s:(ExamCount'="") Score = EntryScore*ExamCount
						s:(rows'="") rows=rows_"," 
						s rows = rows_"{""MessageBody"":"""_MessageBody_""",""CreateDateTime"":"""_CreateDateTime_""",""Name"":"""_Name_""",""CreateUserDesc"":"""_CreateUserDesc_""",""ExecuteStatus"":"""_ExecuteStatus_""",""MessageID"":"""_MessageID_""",""ExecuteDateTime"":"""_ExecuteDateTime_""",""StructName"":"""_StructName_""",""EntryScore"":"""_EntryScore_""",""ExamCount"":"""_ExamCount_""",""Score"":"""_Score_""",""ResumeText"":"""_ResumeText_"""}"
						s count=count+1	
					}
				}
			}
		}
		
	}
	
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"
	q ret
}

/// yhy
/// 2019-07-20
/// 保存打印操作数据
/// w ##Class(EMRservice.Ajax.Quality).GetRunTimeQuality(398286,"","ConfirmRecord^1^22","")
ClassMethod GetRunTimeQuality(AEpisodeID As %String, ATemplateID As %String, AEventType As %String = "", AInstanceIDs As %String) As %GlobalCharacterStream
{
	
	s row = ""
	s rows = ##class(%GlobalCharacterStream).%New()
	s count=0
	q:((AEpisodeID="")||(AEventType="")||((ATemplateID="")&&'(AEventType [ "Confirm"))) ""
	s AdmType=$P($g(^PAADM(AEpisodeID)),"^",2)
	q:AdmType'="I" ""
	s job = ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(AEpisodeID,ATemplateID,AEventType,AInstanceIDs,"")
	q:job="" ""
	s RuleDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,""))
	q:(RuleDR = "") ""
	s RuleDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,""))
	q:(RuleDR = "") ""
	
	s RuleInfo = ^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR)
    s ControlType = $p(RuleInfo,"^",1)
    
	s RuleInfo = ^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR)
	s PhaseID = ""
	for {
		s PhaseID = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID))
		q:(PhaseID = "")
		s EntryDR = ""
	    for 
	    {
		    s EntryDR = $O(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR))
		    q:(EntryDR = "")
		    s EntryName = $p($g(^CacheTemp("DHCEPRQQuality",job,AEpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
		    s EntryName = $tr(EntryName,"\","/")
		    s:(row'="") row=row_"," 
			s row = row_"{""EntryName"":"""_EntryName_"""}"
			s count=count+1	
	    }
	}
	
	
	d rows.Write("{""ControlType"":"_ControlType_",""total"":"_count_",""key"":"_job_"}")
	q rows
}

/// yhy
/// 2019-07-20
/// 保存打印操作质控数据
/// w ##Class(EMRservice.Ajax.Quality).GetRunTimeQualityList()
ClassMethod GetRunTimeQualityList(AEpisodeID As %String, AKey As %String) As %String
{
	s result=""
	q:(AKey="")||(AEpisodeID="") result
	s RuleDR = $O(^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,""))
	q:(RuleDR = "") result
	
	s RuleInfo = ^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,RuleDR)
    s ControlType = $p(RuleInfo,"^",1)
	s PhaseID = ""
	for {
		s PhaseID = $O(^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,RuleDR,PhaseID))
		q:(PhaseID = "")
		s EntryDR = ""
	    for 
	    {
		    s EntryDR = $O(^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,RuleDR,PhaseID,EntryDR))
		    q:(EntryDR = "")
		    s EntryName = $p($g(^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,RuleDR,PhaseID,EntryDR)),"^",1)
		    //s result = result_EntryName_";"
			s ExpressionResult = $p($g(^CacheTemp("DHCEPRQQuality",AKey,AEpisodeID,RuleDR,PhaseID,EntryDR)),"||",2,*)
			
			if (($e(ExpressionResult,3)'="#"))  
		    {
				s Info=$p(ExpressionResult,"^",2)
				s tips=$p(Info,"@",1)
				s setredcode = $p(ExpressionResult,"@",2)
				 s:tips'="" EntryName=EntryName_"("_tips_")"
				s EntryName=$tr(EntryName,";","；") // 描述中带有英文;的转换为中文，避免一个条目分行显示
				s result = result_EntryName_"#"_setredcode_";"
			}
			else
			{ 	// 内涵质控条目返回值拼接具体原因
				for m=2:1:$l(ExpressionResult,"#")
				{
					s exptext=$p($p(ExpressionResult,"#",m),"@",1)
					s setredcode = $p($p(ExpressionResult,"#",m),"@",2)
					s result = result_EntryName_exptext_"#"_$TR(setredcode,$c(0),"^")_";"		
				}
			}
	    }
	}
	k ^CacheTemp("DHCEPRQQuality",AKey)
	q result
}

}
