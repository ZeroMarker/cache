Import SQLUser

/// Class Name:		EPRservice.Quality.BOManualCheck
/// Description:	质控手工评分录入业务逻辑处理类
/// Author:			Zuoxiang Xie
/// Create Date:	2010-07-26
/// Version:	
Class EPRservice.Quality.BOManualCheck Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取主观评分标准的启动开关信息;
/// Input:	ASSGroupID为安全组RowID;
/// 		ACTLocID为科室RowID;
/// Return:	ret = RuleID_"^"_ControlType
/// Debug:	w ##Class(EPRservice.Quality.BOManualCheck).GetSettingBySSGroup("576","34")
ClassMethod GetSettingBySSGroup(ASSGroupID As %String, ACTLocID As %String) As %String
{
	s ret = ""
	q:(ASSGroupID = "")||(ACTLocID = "") ret
		
	s EventTypeID = $o(^DHCEPRM.QualityDicI("IdxCode","Manual",""))
	q:(EventTypeID = "") ret
	
	s IsSSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsSSGroup",""))
	s IsSSGroup = $list($g(^DHCEPRM.QualityParamsD(+IsSSGroupRowID)),2)
	if (IsSSGroup '= "Y") 
	{
		s SSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","MRSSGroup",""))
		s SSGroupID = $list($g(^DHCEPRM.QualityParamsD(+SSGroupRowID)),2)
		s SSGroupID = $tr(SSGroupID," ","")
		q:(SSGroupID = "") ret
	}
	else
	{
		s SSGroupID = $g(ASSGroupID)
	} 
	
	s HospitalID = $p($g(^CTLOC(+ACTLocID)),"^",22)
	s IsGroupHospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsGroupHosp",""))
	s IsGroupHospital = $list($g(^DHCEPRM.QualityParamsD(+IsGroupHospitalRowID)),2)
	if (IsGroupHospital '= "Y")
	{
		s HospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetHospital",""))
		s HospitalID = $list($g(^DHCEPRM.QualityParamsD(+HospitalRowID)),2)
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") ret
	}
	q:(SSGroupID = "")||(HospitalID = "") ret
	
	s QuaSettingID = $o(^DHCEPRM.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	q:(QuaSettingID = "") ret
	s objQuaSetting = $g(^DHCEPRM.QualitySettingD(QuaSettingID))
	q:(objQuaSetting = "") ret
	
	s isSettingActive = $list(objQuaSetting, 6)
	q:(isSettingActive '= "Y") ret
	
	s RuleID = $list(objQuaSetting, 5)
	q:(RuleID = "") ret

	s isRuleActive=$list($g(^DHCEPRM.QualityRuleD(+RuleID)),4)
	q:(isRuleActive '= "Y") ret

	s ControlTypeDR = $list(objQuaSetting, 4)
	s:(ControlTypeDR '= "") ControlType = $list($g(^DHCEPRM.QualityDicD(ControlTypeDR),1))
	s ret = RuleID_"^"_ControlType
	q ret
}

/// Desc:	获取患者基本信息;
/// Input:	AEpisodeID为患者登记号;
/// Output:	LocID_"^"_LocDesc_"^"_DocID_"^"_DocDesc_"^"_Name_"^"_RegNo
/// Debug:	w ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID("201865")
ClassMethod GetPatientInfoByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	s Papmi = $p(objPaAdm,"^",1)
		
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	
	s LocID = "",LocDesc = "",DocID = "",DocDesc = ""
	
	s LocID = +$p(objPaAdm,"^",4)
	s:(LocID '= 0) LocDesc = $p($g(^CTLOC(LocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	
	s DocID = +$p(objPaAdm,"^",9)
	s:(DocID '= 0) DocDesc = $p($g(^CTPCP((DocID),1)),"^",2)
	
	s ret = LocID_"^"_LocDesc_"^"_DocID_"^"_DocDesc_"^"_Name_"^"_RegNo
	q ret
}

/// Desc:	获取患者手工质控评分列表;
/// Input:	AEpisodeID为患者登记号;
/// 		ASSGroupID为安全组RowID;
/// 		ACTLocatID为科室RowID;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOManualCheck","GetManualResult","2358","305","203","A")
Query GetManualResult(AEpisodeID As %String, ASSGroupID As %String, ACTLocatID As %String, AAction As %String) As %Query(ROWSPEC = "RuleID,RuleTitle,ResultID,DetailID,SignUserDR,SignUserName,ExamineDate,ExamineTime,EntryDR,EntryTitle,EmployeeDr,EmployeeName,CtLocDr,CtLocName,ResumeText,EntryScore,InstanceId,EmrDocId,ExamCount,ResultDetailID,MessageFlag,Path,MessageID")
{
}

ClassMethod GetManualResultExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ASSGroupID As %String, ACTLocatID As %String, AAction As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	s EpisodeID = $g(AEpisodeID)
	s SSGroupID = $g(ASSGroupID)
	s CTLocatID = $g(ACTLocatID)
	s AAction = $g(AAction)
	
	//s:(EpisodeID = "") EpisodeID = $g(%request.Data("EpisodeID",1))
	//s:(SSGroupID = "") SSGroupID = $g(%session.Data("LOGON.GROUPID"))
	//s:(CTLocatID = "") CTLocatID = $g(%session.Data("LOGON.CTLOCID"))
	
	q:(EpisodeID = "")||(SSGroupID = "")||(CTLocatID = "") $$$OK
	
	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(EpisodeID)
	q:(flag < 1) $$$OK
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	
	s:(IsBSQualityEnable'="Y") EventTypeID = $o(^DHCEPRM.QualityDicI("IdxCode","Manual",""))
	s:(IsBSQualityEnable="Y") EventTypeID = $o(^CT.MA.QC.QualityDictionaryI("IdxCode","Manual",""))
	q:(EventTypeID = "") $$$OK
	
	s:(IsBSQualityEnable'="Y") IsSSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsSSGroup",""))
	s:(IsBSQualityEnable="Y") IsSSGroupRowID = $o(^CT.MA.QC.QualityParamsI("IdxCode","QuaSetIsSSGroup",""))
	s:(IsBSQualityEnable'="Y") IsSSGroup = $list(^DHCEPRM.QualityParamsD(+IsSSGroupRowID),2)
	s:(IsBSQualityEnable="Y") IsSSGroup = $list(^CT.MA.QC.QualityParamsD(+IsSSGroupRowID),4)
	if (IsSSGroup '= "Y") 
	{
		s:(IsBSQualityEnable'="Y") SSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","MRSSGroup",""))
		s:(IsBSQualityEnable="Y") SSGroupRowID = $o(^CT.MA.QC.QualityParamsI("IdxCode","MRSSGroup",""))
		s:(IsBSQualityEnable'="Y") SSGroupID = $list(^DHCEPRM.QualityParamsD(+SSGroupRowID),2)
		s:(IsBSQualityEnable="Y") SSGroupID = $list(^CT.MA.QC.QualityParamsD(+SSGroupRowID),4)
		s SSGroupID = $tr(SSGroupID," ","")
		q:(SSGroupID = "") $$$OK
	} 
	
	s HospitalID = $p($g(^CTLOC(+ACTLocatID)),"^",22)
	s:(IsBSQualityEnable'="Y") IsGroupHospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsGroupHosp",""))
	s:(IsBSQualityEnable="Y") IsGroupHospitalRowID = $o(^CT.MA.QC.QualityParamsI("IdxCode","QuaSetIsGroupHosp",""))
	s:(IsBSQualityEnable'="Y") IsGroupHospital = $list($g(^DHCEPRM.QualityParamsD(+IsGroupHospitalRowID)),2)
	s:(IsBSQualityEnable="Y") IsGroupHospital = $list($g(^CT.MA.QC.QualityParamsD(+IsGroupHospitalRowID)),4)
	if (IsGroupHospital '= "Y")
	{
		s:(IsBSQualityEnable'="Y") HospitalRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetHospital",""))
		s:(IsBSQualityEnable="Y") HospitalRowID = $o(^CT.MA.QC.QualityParamsI("IdxCode","QuaSetHospital",""))
		s:(IsBSQualityEnable'="Y") HospitalID = $list($g(^DHCEPRM.QualityParamsD(+HospitalRowID)),2)
		s:(IsBSQualityEnable="Y") HospitalID = $list($g(^CT.MA.QC.QualityParamsD(+HospitalRowID)),4)
		s HospitalID = $tr(HospitalID," ","")
		q:(HospitalID = "") $$$OK
	}
	q:(SSGroupID = "")||(HospitalID = "") $$$OK
	
	s:(IsBSQualityEnable'="Y") QuaSettingID = $o(^DHCEPRM.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	s:(IsBSQualityEnable="Y") QuaSettingID = $o(^CT.MA.QC.QualitySettingI("IdxSSGroup",SSGroupID," "_EventTypeID,HospitalID,""))
	
	q:(QuaSettingID = "") $$$OK
	s:(IsBSQualityEnable'="Y") QuaSetting = $g(^DHCEPRM.QualitySettingD(QuaSettingID))
	s:(IsBSQualityEnable="Y") QuaSetting = $g(^CT.MA.QC.QualitySettingD(QuaSettingID))
	q:(QuaSetting = "") $$$OK
	
	s:(IsBSQualityEnable'="Y") SettingIsActive = $list(QuaSetting, 6)
	s:(IsBSQualityEnable="Y") SettingIsActive = $list(QuaSetting, 7)
	q:(SettingIsActive '= "Y") $$$OK
	
	s RuleID = $list(QuaSetting, 5)
	q:(RuleID = "") $$$OK

	s:(IsBSQualityEnable'="Y") RuleIsActive = $list($g(^DHCEPRM.QualityRuleD(+RuleID)),4)
	s:(IsBSQualityEnable="Y") RuleIsActive = $list($g(^CT.MA.QC.QualitySettingD(+RuleID)),5)
	q:(RuleIsActive '= "Y") $$$OK

	s:(IsBSQualityEnable'="Y") RuleTitle = $list($g(^DHCEPRM.QualityRuleD(+RuleID)),2)
	s:(IsBSQualityEnable="Y") RuleTitle = $list($g(^CT.MA.QC.QualityRuleD(+RuleID)),3)

	s ExamineDate = ""
	for {
		s ExamineDate = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_EpisodeID," "_RuleID,ExamineDate))
		q:(ExamineDate = "")
		
		s SignUserID = ""
		for {
			s SignUserID = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_EpisodeID," "_RuleID,ExamineDate,SignUserID))
			q:(SignUserID = "")
			
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_EpisodeID," "_RuleID,ExamineDate,SignUserID,ResultID))
				q:(ResultID = "")
				
				s objResult = $g(^DHCEPRQ.QualityResultD(ResultID))
				continue:(objResult = "")
				s Action = $list(objResult,15)
				
				continue:(Action'=AAction)&&(AAction'="BS")
				continue:(Action'["S")&&(AAction="BS")
				// 报告人
				s SignUserDR = $list(objResult,13)
				s SignUserName = $p($g(^SSU("SSUSR",+SignUserDR)),"^",2)
			
				// 报告日期
				s ReportDate = $list(objResult,4)
				s ReportDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ReportDate)
				// 报告时间
				s ReportTime = $list(objResult,5)
				s ReportTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ReportTime)
				s DetailID = ""
				for {
					s DetailID = $o(^DHCEPRQ.QualityResultDetailI("IdxResult",+ResultID,DetailID))
					q:(DetailID = "")
			
					s ResultDetailID = ResultID_"||"_DetailID
					
					s MessageFlag="未发送消息"
					s MessageID=""
					s MessageID = $o(^DHCEPRQ.EPRSingleMessageI("IdxResultDetailID"," "_ResultDetailID,MessageID),-1)
					
					s:(MessageID="") MessageFlag="未发送消息"
				
					if (MessageID'="")
					{
						s ObjMessage=$g(^DHCEPRQ.EPRSingleMessageD(MessageID))
						s ReadFlag=$list(ObjMessage,14)
						s EffectiveFlag=$list(ObjMessage,13)
						s ExecuteFlag=$list(ObjMessage,20)
						s ConfirmFlag=$list(ObjMessage,29)
						if (ReadFlag="U")
						{
							s contentId= ##class(websys.DHCMessageInterface).FindContentId("1008",AEpisodeID,"",MessageID)
							s:(contentId="") contentId=##class(websys.DHCMessageInterface).FindContentId("1009",AEpisodeID,"",MessageID)
							if (contentId'="")
							{
								s result = ##Class(%ResultSet).%New("websys.DHCMessageDetailsMgr:FindByContent")
							    s sc = result.Execute(contentId,"","ALL")
							    s coulumns=result.GetColumnCount()
							    While (result.Next())
							    {
						         s DReadFlag=result.Data("DReadFlag")
						         s:(DReadFlag="Y") ReadFlag="R"
						         
							    }
							}
						}
						s:(ReadFlag="U")&&(ExecuteFlag="U") MessageFlag="未处理"
						s:(ReadFlag="R") MessageFlag="已读"
						s:(ReadFlag="R")&&(ExecuteFlag="E") MessageFlag="已处理"
						s:(ConfirmFlag="C") MessageFlag="已修复"
						s:(EffectiveFlag="T") MessageFlag="已撤回" 
						
					}
					
					s objDetail = $g(^DHCEPRQ.QualityResultD(+ResultID,"Details",DetailID))
					continue:(objDetail = "")
				
					s EntryDR = $list(objDetail,2)
				
					continue:(EntryDR = "")
					s EntryScore = $list(objDetail,4)
					s ExamCount = $list(objDetail,7)
					// 质控项目标题
					s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryDR)
				    s EntryTitle=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(EntryTitle)
					s PeopleID = $list(objDetail,8)
					continue:(PeopleID = "")
				
					s objPeople = ##Class(EPRinstance.Quality.QualityResultPeople).%OpenId(PeopleID)
				
					// 责任人
					s EmployeeDr = objPeople.EmployeeDr
					s EmployeeName = $p($g(^CTPCP((+EmployeeDr),1)),"^",2)
					//s EmployeeName = $p($g(^SSU("SSUSR",+EmployeeDr)),"^",2)
					// 责任科室
					s CtLocDr = objPeople.CtLocDr
					s CtLocName = $p($g(^CTLOC(+CtLocDr)),"^",2)
					s:(CtLocName [ "-") CtLocName = $p(CtLocName,"-",2)
					s InstanceId="",EmrDocId=""
					s ResumeText = $list(objDetail,9)
					s ResumeText=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ResumeText)
					s InstanceId = "",EmrDocId = ""
					S listlength = $listlength(objDetail)
					s:listlength>10 InstanceId = $list(objDetail,11)
					s:listlength>10 EmrDocId = $list(objDetail,12)
					s Path=""
					s:listlength>12 Path = $list(objDetail,13)
					
					
					if ( objPeople '= "")
					{
						d objPeople.%Close()
						k objPeople
					}
				
					s Data = $lb(RuleID,RuleTitle,ResultID,DetailID,SignUserDR,SignUserName,ReportDate,ReportTime,EntryDR,EntryTitle,EmployeeDr,EmployeeName,CtLocDr,CtLocName,ResumeText,EntryScore,InstanceId,EmrDocId,ExamCount,ResultDetailID,MessageFlag,Path,MessageID)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1	
				}
			}
		}
	}
	q $$$OK
}

ClassMethod GetManualResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManualResultExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetManualResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManualResultExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// yhy 2017-04-12
/// Desc:	根据就诊号获取当前患者手工评分得分
/// Input:	ASSGroupID为安全组RowID;
/// 		ACTLocID为科室RowID;
/// Debug:	w ##Class(EPRservice.Quality.BOManualCheck).GetScoreByEpisodeID("576","34")
ClassMethod GetScoreByEpisodeID(AEpisodeID As %String, ASSGroupID As %String, ACTLocID As %String, AAction As %String) As %String
{
	s ret = ""
	s ret = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
	s ret  = $p(ret,"^",1)
	s:ret="" ret=100
	s EntryScores = 0
	
	q:(ASSGroupID = "")||(ACTLocID = "")||(AEpisodeID = "") ret	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOManualCheck:GetManualResult")
	d result.Execute(AEpisodeID, ASSGroupID, ACTLocID, AAction)
	while result.Next()
	{
		
		s EntryScore = result.Data("EntryScore")
		s EntryScores = EntryScores + EntryScore
	}
	s ret = ret - EntryScores
	q ret
}

/// //////////////////////////////////////////
/// Desc:	 根据就诊号获取患者手工评分"单否"情况;
/// Creator: guanyu && whb
/// Date: 	 2020-1-8
/// Input:	 AEpisodeID为就诊号;
/// 		 AAction为病人类型,"A"环节,"D"终末;
/// Return:	 result 不是单否返回空，是单否返回单否等级;
/// Debug:	 w ##Class(EPRservice.Quality.BOManualCheck).GetManualVetoGrade("160","A")
ClassMethod GetManualVetoGrade(AEpisodeID As %String, AAction As %String) As %String
{
	s result=""
	q:(AEpisodeID="") result
	
	s RuleID=1
	s ExamineDate = ""
	for {
		s ExamineDate = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_AEpisodeID," "_RuleID,ExamineDate))
		q:(ExamineDate = "")
		
		s SignUserID = ""
		for {
			s SignUserID = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_AEpisodeID," "_RuleID,ExamineDate,SignUserID))
			q:(SignUserID = "")
			
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxCompositeUser"," "_AEpisodeID," "_RuleID,ExamineDate,SignUserID,ResultID))
				q:(ResultID = "")
				
				//s objResult = $g(^DHCEPRQ.QualityResultD(ResultID))
				// 2020-1-8 whb 修改list取值为对象取值   
				s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
				continue:(objResult = "")
				
				//s Action = $list(objResult,15)
				s Action = objResult.Action
				continue:(Action'=AAction)
			
				s DetailID = ""
				for {
					s DetailID = $o(^DHCEPRQ.QualityResultDetailI("IdxResult",+ResultID,DetailID))
					q:(DetailID = "")
				
					//s objDetail = $g(^DHCEPRQ.QualityResultD(+ResultID,"Details",DetailID))
					// 拼detail表的rowid
					s DetailID = ResultID_"||"_DetailID   
					s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(DetailID)
					continue:(objDetail = "")
				    
					//s EntryDR = $list(objDetail,2)
					s EntryDR = objDetail.EntryDR
					continue:(EntryDR = "")
					
					//s objEntry = $g(^DHCEPRM.QualityEntryD(EntryDR))
					s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryDR)
					//s VetoGrade = $list(objEntry,11)
					s VetoGrade = objEntry.VetoGrade
					s:(VetoGrade'="")&&((result="")||(result="乙级")) result=VetoGrade
				}
			}
		}
	}
	q result
}

}
