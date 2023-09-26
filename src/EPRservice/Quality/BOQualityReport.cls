/// Class Name:		EPRservice.Quality.BOQualityReport
/// Description:	质控查询与相关报表
/// Author:			Zuoxiang Xie
/// Create Date:	2010-08-10
/// Last Modify:	2011-07-06
/// Version: 		Add some report queries	
Class EPRservice.Quality.BOQualityReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-14
/// Description:	在院质控查询(数据来源为每天的在院质控自动任务);
/// 				先根据登记号和患者姓名快速检索,再根据科室病区和患者入院起始截止日期检索;
/// Table:       	EPRinstance_Quality.QualityResult和EPRinstance_Quality.QualityResultDetail
/// Input:			ALocID为科室RowID;
/// 				AWardID为病区RowID(注意该RowID为病区在Ct_Loc表中的RowID);
/// 				ADoctorID为主治医RowID;
/// 				ARegNo为患者登记号;
/// 				APatientName为患者姓名;
/// 				ARuleCode为在院质控标准代码;
/// Output: 		在院质控查询结果集;
/// Return:			column = (RuleID,EpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,LocID,LocDesc,WardID,WardDesc,DoctorID,DoctorDesc,AdmitDate,DischDate,PatientID)
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetAdmitQualityList","","","","00000001","","F")				
Query GetAdmitQualityList(ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, ARuleCode As %String, AIsPopbox As %String = "") As %Query(ROWSPEC = "RuleID,EpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,LocID,LocDesc,WardID,WardDesc,DoctorID,DoctorDesc,AdmitDate,DischDate,CurrentBed,PatientID") [ SqlProc ]
{
}

ClassMethod GetAdmitQualityListExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, ARuleCode As %String, AIsPopbox As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	/* Debug
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","1ALocID") = ALocID
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","2AWardID") = AWardID
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","3ADoctorID") = ADoctorID
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","4ARegNo") = ARegNo
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","5APatientName") = APatientName
	s ^CacheTemp("EPRQuality","BOQualityReport","GetAdmitQualityList","6ARuleCode") = ARuleCode
	*/
	
	q:(ARuleCode = "") $$$OK
	
	s ruleID = $o(^DHCEPRM.QualityRuleI("IdxCode",ARuleCode,""))
	q:(ruleID = "") $$$OK
	
	// 开辟一个临时Global用于排序
	k ^CacheTemp("EPRQuality","AdmitSearch",repid)
	
	// 先根据登记号，再根据患者姓名，最后再根据科室、病区和就诊日期等条件查询
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s patientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(patientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s episodeID = ""
		for {
			s episodeID = $o(^PAPERdr(patientID,"ADM","I",episodeID))
			q:(episodeID = "")
			
			s existed = ..CheckExistInResultByID(episodeID, ruleID)
			continue:(existed <= 0) 
	
			// BuildAdmitSearchData(LocID,WardID,DoctorID,RuleID,EpisodeID,UniqueKey)
			s flag = ..BuildAdmitSearchData("","","",ruleID,episodeID,repid)
			continue:(flag < 0)
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s patientID = ""
		for {
			s patientID = $o(^PAPERi("PAPER_PatName",APatientName,patientID))
			q:(patientID = "")	
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s episodeID = ""
			for {
				s episodeID = $o(^PAPERdr(patientID,"ADM","I",episodeID))
				q:(episodeID = "")
				
				s existed = ..CheckExistInResultByID(episodeID, ruleID)
				continue:(existed <= 0) 
				
				// BuildAdmitSearchData(LocID,WardID,DoctorID,RuleID,EpisodeID,UniqueKey)
				s flag = ..BuildAdmitSearchData("","","",ruleID,episodeID,repid)
				continue:(flag < 0)
			}
		}	
	}
	else
	{
		s wardID = $g(AWardID)
		s:((wardID '= "")&&(AIsPopbox '= "1")) wardID = ..GetRealWardID(wardID)		
		s blankEpisodeID = ""
		for {
			s blankEpisodeID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ruleID,blankEpisodeID))
			q:(blankEpisodeID = "")
			
			// Trim the blank of BlankEpisodeID
			s episodeID = $tr(blankEpisodeID," ","")
			
			// BuildAdmitSearchData(LocID,WardID,DoctorID,RuleID,EpisodeID,UniqueKey)
			s flag = ..BuildAdmitSearchData(ALocID,wardID,ADoctorID,ruleID,episodeID,repid)
			continue:(flag < 0)
		}
	}
	
	// 按病区、医生排序
	s tmpWard = ""
	for {
		s tmpWard = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard))
		q:(tmpWard = "")
		
		s tmpDoctor = ""
		for {
			s tmpDoctor = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpDoctor))
			q:(tmpDoctor = "")
			
			s tmpAdmID = ""
			for {
				s tmpAdmID = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpDoctor,tmpAdmID))
				q:(tmpAdmID = "")
				
				s Data = $g(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpDoctor,tmpAdmID))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}
		}
	}
	
	k ^CacheTemp("EPRQuality","AdmitSearch",repid)
	
	q $$$OK
}

ClassMethod BuildAdmitSearchData(ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String) As %String
{
	s ret = -1
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	// Only process patient that allocate department
	s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret

	s AdmWardID = $p(objPaAdm,"^",70)				
	q:(AWardID '= "")&&(AdmWardID '= AWardID) ret
		
	// Only process patient that allocate physician
	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret
				
	s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	q:(ResultID = "") ret
	
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret
	//Modify by Candyxu 读持久化类里面的终末分数
    s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
    s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	
	// 以下取患者基本信息和就诊信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3),Birthday = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",Birthday)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s AdmitDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmitDate)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3),DischDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	s BedDR = $p(objPaAdm,"^",73)
	s CurrentBed = $s(BedDR '= "":$P($g(^PAWARD(+BedDR,"BED",$P(BedDR,"||",2))),"^",1),1:"")
	
	// Write data to assigned temp global
	s ^CacheTemp("EPRQuality","AdmitSearch",AUniqueKey,WardDesc,DoctorDesc,AEpisodeID) = $lb(ARuleID,AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,CurrentBed,Papmi)
	
	s ret = 1
	q ret
}

ClassMethod GetAdmitQualityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmitQualityListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmitQualityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmitQualityListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取病区RowID;
/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetRealWardID()
ClassMethod GetRealWardID(ALocID As %String) As %Integer
{
	s ret = 0	
	q:(ALocID = "") ret
	
	s ret = $o(^PAWARD(0,"WARD_LocationDR",ALocID,""))
	q ret
}

/// Desc:	获取患者病历分数与等级;
/// 		等级评定规则为: 
/// 		1)先根据分数评级(>=90分以上为甲,>=70分以上为乙,剩下为丙);
/// 		2)再根据违反质控项目等级评级,如果触犯丙级项目,则病历判定为丙级;如果违反三个以上乙级项目,则判定为乙级;
/// Input:	AEpisodeID为患者就诊号;
/// 		ARuleCodes为质控标准代码字符串,多个以"^"分隔(只能为自动任务标准和手工评分标准代码组合);
/// Output:	ret = 等级^分数
/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetMRScoreAndGrade("2419520","A^G")
/// Edit by Candyxu( 分数段使用参数)
ClassMethod GetMRScoreAndGrade(AEpisodeID As %String, ARuleCodes As %String, AAction As %String = "") As %String
{
	s ruleIDs = ""
	s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
	for i = 1:1:$listlength(RuleCodes) 
	{
		s RuleCode = $listget(RuleCodes,i)
		continue:(RuleCode = "")
		
		s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		continue:(RuleID = "")
		
		if (ruleIDs = "")
		{
			s ruleIDs = RuleID
		}
		else
		{
			s ruleIDs = ruleIDs_"^"_RuleID
		}
	}
	
	s result = ..GetMRScoreAndGradeByID(AEpisodeID,ruleIDs,AAction)
	q result
}

ClassMethod SetScore(AUniqueKey As %String, ACid As %String, AScore As %String)
{
	q:(AUniqueKey="")||(ACid="")||(AScore="")
	
	q:($g(^CacheTemp("EPRQuality","EPRScore",AUniqueKey,ACid,"maxflag")) = 1) 
	
	s MaxFlag = 0, MaxCidScore = 0
	if (ACid = 0)
	{
		s MaxCidScore = 100	
	}
	else
	{
		s MaxCidScore = $list($g(^DHCEPRM.QualityCategoryD(+ACid)),4)
	}
	
	s orgScore = $g(^CacheTemp("EPRQuality","EPRScore",AUniqueKey,ACid,"score"))
	
	//actualScore是往上级目录中添加的实际分数值
	s actualScore = 0
	s tmpScore = +MaxCidScore - orgScore
	if (AScore < tmpScore) 
	{	
		s actualScore = AScore
		s MaxFlag = 0
	}
	else
	{	
		s actualScore = tmpScore
		s MaxFlag = 1
	}
	s:(actualScore<0) actualScore = 0
	s totScore = orgScore + actualScore
	
	s ^CacheTemp("EPRQuality","EPRScore",AUniqueKey,ACid,"score") = totScore
	s ^CacheTemp("EPRQuality","EPRScore",AUniqueKey,ACid,"maxflag") = MaxFlag
	
	q:(ACid = "0") 
	
	s objCategory = $g(^DHCEPRM.QualityCategoryD(+ACid))
	s Pid = $list(objCategory,2)
	q:(Pid = "")
	
	d ..SetScore(AUniqueKey,Pid,actualScore)
}

/// Desc:	获取患者病历分数与等级;
/// 		等级评定规则为: 
/// 		1)先根据分数评级
/// 		2)再根据违反质控项目等级评级,如果触犯丙级项目,则病历判定为丙级;如果违反三个以上乙级项目,则判定为乙级;
/// Input:	AEpisodeID为患者就诊号;
/// 		ARuleIDs为质控标准ID字符串,多个以"^"分隔(只能为自动任务标准和手工评分标准代码组合);
/// Output:	ret = 等级^分数
/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetMRScoreAndGrade("2419520","A^G")
ClassMethod GetMRScoreAndGradeByID(AEpisodeID As %String, ARuleIDs As %String, AAction As %String = "") As %String
{
	s FinalGrade = "甲", FinalScore = 100, BCount = 0, CCount = 0
	s ret = FinalGrade_"^"_FinalScore
	q:(AEpisodeID = "")||(ARuleIDs = "") ret
	
	//获得级别分数参数
	s QPID = $o(^DHCEPRM.QualityParamsI("IdxCode","ScoreStandard",""))
	if (QPID = ""){ s GreadScore = "90^70"}
	else{s GreadScore = $li(^DHCEPRM.QualityParamsD(QPID),2)}

    s GreadA = $p($g(GreadScore),"^",1) if (GreadA = ""){s GreadA = 90}
    s GreadB = $p($g(GreadScore),"^",2) if (GreadB = ""){s GreadB = 70}	

	s UniqueKey = $i(^CacheTemp)
	
	k ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey)
	
	s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for i = 1:1:$listlength(RuleIDs) 
	{
		s RuleID = $listget(RuleIDs,i)
		continue:(RuleID = "")
					
		s ResultID = ""
		for {
			s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_RuleID,ResultID))
			q:(ResultID = "")
			s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
			s Action = objResult.Action
			continue:(Action'=AAction)&&(AAction'="")&&(Action'="")
			s ChildSub = ""
			for {
				s ChildSub = $o(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,ChildSub))
				q:(ChildSub = "")
				
				s DetailID = ResultID_"||"_ChildSub
				s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(DetailID)
				
				s EntryID = objDetail.EntryDR
				
				// 如果这个条目被删除了，则不参与计分
				continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
				
				s EntryScore = objDetail.EntryScore	
				s EntryGrade = objDetail.EntryGrade
				s ExamCount = objDetail.ExamCount
				s IsMultiErr = $list($g(^DHCEPRM.QualityEntryD(+EntryID)),6)
				if (IsMultiErr = "Y")
				{
					s TotalScore = (+EntryScore) * (+ExamCount)	
				}
				else
				{
					s TotalScore = 	EntryScore
				}
				
				if (EntryGrade = "乙级")
				{
					s BCount = BCount + 1	
				}
				elseif (EntryGrade = "丙级")
				{
					s CCount = CCount + 1	
				}	
	
				s StructID = $list($g(^DHCEPRM.QualityEntryD(+EntryID)),3)
				s CategoryID = $list($g(^DHCEPRM.QualityStructD(+StructID)),11)
				continue:(CategoryID = "")
				
				s objCategory = $g(^DHCEPRM.QualityCategoryD(+CategoryID))
				continue:(objCategory = "")
									
				s ParentCategoryID = $list(objCategory,2)
				continue:(ParentCategoryID = "")
								
				s ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,ParentCategoryID,CategoryID) = (+$g(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,ParentCategoryID,CategoryID))) + TotalScore
				
				if (objDetail '= "")
				{
					d objDetail.%Close()
					k objDetail
				}
			}
		} 				
	}
	s Score = ..GetFinalScore(UniqueKey)
	s FinalScore = $p($g(Score),"^",1)
	s TempDeScore = $p($g(Score),"^",2)	
	s:(FinalScore >= GreadA) FinalGrade = "甲"
	s:(FinalScore < GreadA)&&(FinalScore >= GreadB) FinalGrade = "乙"
	s:(FinalScore < GreadB) FinalGrade = "丙"

	if ((CCount > 0) || (BCount > 2))
	{
		s FinalGrade = "丙"	
	}
	elseif ((BCount > 0)&& (FinalGrade '= "丙"))
	{
		s FinalGrade = "乙"
	}
	
	s ret = FinalGrade_"^"_FinalScore_"^"_BCount_"^"_CCount_"^"_TempDeScore
	q ret
}

/// Creator: candyxu
/// CreatDate: 2012-07-13
/// Desc: 遍历获得最终分数
/// output: 返回最终分数^扣分总数
ClassMethod GetFinalScore(UniqueKey As %String) As %Numeric
{
	k ^CacheTemp("EPRQuality","EPRScore",UniqueKey)
	
	s Pid = ""
	for {
		s Pid = $o(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,Pid))
		q:(Pid = "")
		
		s Cid = ""
		for {
			s Cid =  $o(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,Pid,Cid))
			q:(Cid = "")
			
			s Score = $g(^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey,Pid,Cid))
			
			d ..SetScore(UniqueKey,Cid,Score)			
		}
	}
	s TempDeScore = $g(^CacheTemp("EPRQuality","EPRScore",UniqueKey,"0","score"))
	s FinalScore = 100 - TempDeScore
	k ^CacheTemp("EPRQuality","EPRScore",UniqueKey)
	k ^CacheTemp("EPRQuality","EPRGradeScore",UniqueKey)
	q FinalScore_"^"_TempDeScore
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-14
/// Description:	查询质控结果明细;
/// Table:       	无;
/// Input:			AEpisodeID为患者就诊号;
/// 				ARuleIDs为质控标准RowID字符串,多个以"^"分隔;
/// Output: 		违反的质控项目明细结果集
/// Return:			column = (RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto)
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetEPRQualityDetail","201863","10^11")					
Query GetEPRQualityDetail(AEpisodeID As %String, ARuleIDs As %String, AAction As %String = "") As %Query(ROWSPEC = "RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto,ErrInfo,SignUserDR,ExamineDate") [ SqlProc ]
{
}

ClassMethod GetEPRQualityDetailExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ARuleIDs As %String, AAction As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	/* Debug
	s ^CacheTemp("EPRQuality","GetEPRQualityDetail","Params","AEpisodeID") = AEpisodeID
	s ^CacheTemp("EPRQuality","GetEPRQualityDetail","Params","ARuleIDs") 	 = ARuleIDs
	*/
	
	if (ARuleIDs '= "")
	{
		s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
		for i = 1:1:$listlength(RuleIDs)
		{
			s RuleID = $listget(RuleIDs,i)
			continue:(RuleID = "")
			
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_RuleID,ResultID))
				q:(ResultID = "")
                s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 
                s Action=objResult.Action
                continue:(RuleID=1)&&(AAction'="")&&(AAction'=Action)
				d GetQualityDetails(ResultID)
			}
		}	
	}
	else
	{
		s RuleID = ""
		for {
			s RuleID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID,RuleID))
			q:(RuleID = "")
			
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID,RuleID,ResultID))
				q:(ResultID = "")

				d GetQualityDetails(ResultID)
			}
		}		
	}
	q $$$OK
	
GetQualityDetails(ParResultID)
	s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ParResultID) 	
	s EpisodeID = objResult.EpisodeID
	s RuleDR = objResult.RuleDR
	s RuleDesc = $list($g(^DHCEPRM.QualityRuleD(+RuleDR)),2)
	s SignUserDR=objResult.SignUserDR
	s ExamineDate=objResult.ExamineDate
	s key = ""
	do {
		s objDetail = objResult.Details.GetNext(.key)
	  	if (objDetail '= "")
	  	{ 
	  		s EntryID = objDetail.EntryDR
	  		
	  		s objEntry = $g(^DHCEPRM.QualityEntryD(+EntryID))
	  		continue:(objEntry = "")		// 如果这个条目被删除了，则不参与计分
	  		
	  		s StructID = $list(objEntry,3)
	  		s StructName = $list($g(^DHCEPRM.QualityStructD(+StructID)),1)
	  		s IsMultiErr = $list(objEntry,6)
	  		s MultiErrInfo = $s(IsMultiErr = "Y":"是",1:"否")
	  		s IsVeto = $list(objEntry,7)
	  		s VetoGrade = $list(objEntry,11)
	  		s VetoInfo = $s(IsVeto = "Y":VetoGrade,1:"否")
	  		s ExamCount = objDetail.ExamCount
	  		//modify by Candyxu
	  		s obj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	  		s EntryScore = obj.GetEvaluationValue(objDetail.EntryScore)
	  		d obj.%Close()
	  		s obj = ""
	  		s People = objDetail.People
	  		s CtLocID = People.CtLocDr
	  		s CTLocDesc = $p($g(^CTLOC(+CtLocID)),"^",2)
	  		s:(CTLocDesc [ "-") CTLocDes = $p(CTLocDesc,"-",2)
	  		s EmployeeID = People.EmployeeDr
	  		//s EmployeeDesc = $p($g(^CTPCP(+EmployeeID)),"^",2)
	  		s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+EmployeeID,0))
			s EmployeeDesc = $s(SSUserID '= "":$p($g(^SSU("SSUSR",+SSUserID)),"^",2),1:"未指定")
			
			s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
			s ErrInfo=objDetail.ErrInfo
			s Data = $lb(RuleID,RuleDesc,StructID,StructName,EntryID,EntryTitle,ExamCount,EntryScore,CtLocID,CTLocDesc,EmployeeID,EmployeeDesc,MultiErrInfo,VetoInfo,ErrInfo,SignUserDR,ExamineDate)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
	  	}
	} while(key '= "")
	
	d objResult.%Close()
	q
}

ClassMethod GetEPRQualityDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRQualityDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEPRQualityDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRQualityDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-14
/// Description:	出院质控查询; modify by Candy 2013-03-05 增加输出主任、主治医师
/// Add:            为了兼顾质控条目级别模式,修改了此方法,加入两列返回值,MRFourth,MRFifth
/// Table:       	无
/// Input:			ALocID为科室RowID;
/// 				AWardID为病区RowID;
/// 				ADoctorID为主治医RowID;
/// 				ARegNo为患者登记号;
/// 				AStartDate and AEndDate分别为入院起始和截止日期;
/// 				ARuleCodes为出院质控标准代码;
/// Output: 		出院质控结果集;
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetEPRQualityReport","1","","48","","","","00000005","61959","61997","R001^R003")		
Query GetEPRQualityReport(ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsAllLocs As %String, AIsMultiSummary As %String, AIsFinalList As %String = "Y") As %Query(ROWSPEC = "LocDesc,WardDesc,DoctorDesc,AttendDoctor,SeniorDoctor,MRFirst,MRSecond,MRThird,MRFourth,MRFifth,MRCount,DisLocID,DisWardID,DoctorID,StartDate,EndDate,RuleIDs,RegNo") [ SqlProc ]
{
}

ClassMethod GetEPRQualityReportExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsAllLocs As %String, AIsMultiSummary As %String, AIsFinalList As %String = "Y") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,uid,"")
	
	/* Debug
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","1ALocID") = ALocID
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","2AWardID") = AWardID
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","3ADoctorID") = ADoctorID
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","4ARegNo") = ARegNo
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","5AStartDate") = AStartDate
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","6AEndDate") = AEndDate
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","7ARuleCodes") = ARuleCodes
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","8AIsAllLocs") = AIsAllLocs
	s ^CacheTemp("EPRQuality","GetEPRQualityReport","9AIsMultiSummary") = AIsMultiSummary
	*/

	// Must assign start date and end date at first
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s:(StartDate = "") StartDate = $h - 7
	s:(EndDate = "") EndDate = $p($h,",",1)
	k ^CacheTemp("EPRQuality","DischSearch",uid)
	s RuleID = ..GetRuleIDsByRuleCodes(ARuleCodes)
	s Number = 0
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			s flag = ..GetQualityReportResult("","","",RuleID,EpisodeID,uid,"DischSearch",AIsFinalList)
			continue:(flag < 0)	
			
			s Number = Number + 1
		}	
	}
	else
	{
		s WardID = $g(AWardID)
		s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))

		//if you want query all data just by start date and end date, pls. cancel comment for the below line
		q:(ALocID = "")&&(WardID = "")&&(AIsAllLocs '= "Y") $$$OK
		
		if (AIsAllLocs = "Y")
		{
			s ALocID = ""
			s WardID = ""
			s ADoctorID = ""
		}
		
		// 自动任务出院处理天数
		s Days = 5
		s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
		s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
		
		s StartDate = StartDate - Days
		s EndDate	= EndDate - Days
		
		for DischDate = StartDate:1:EndDate {
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
				q:(EpisodeID = "")
				
				s flag = ..GetQualityReportResult(ALocID,WardID,ADoctorID,RuleID,EpisodeID,uid,"DischSearch",AIsFinalList)
				continue:(flag < 0)
				
				s Number = Number + 1
			}
		}
	}
	
	s (Count, First, Second, Third, Fourth, Fifth) = 0
	
	
	// Process not find any episode by given query condition
	if (Number = 0)
	{
		// 加上第一栏统计
		s Data = $lb("合计","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,StartDate,EndDate,RuleID,ARegNo)
		s ^CacheTemp(uid,1) = Data
		
		k ^CacheTemp("EPRQuality","DischSearch",uid)
		
		q $$$OK	
	}
		
	s curLocID = ""
	for	{ 
		s curLocID = $o(^CacheTemp("EPRQuality","DischSearch",uid,curLocID)) 
		q:(curLocID = "")
		
		s LocDesc = $p($g(^CTLOC(curLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocCount, LocFirst, LocSecond, LocThird, LocFourth, LocFifth) = 0
		
		s curWardID = ""
		for {
			s curWardID = $o(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID)) 
			q:(curWardID = "")
			
			s WardDesc = $p($g(^PAWARD(curWardID)),"^",2)
			s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
			
			s (WardCount, WardFirst, WardSecond, WardThird,WardFourth,WardFifth) = 0
			
			s curDocID = ""
			for { 
				s curDocID = $o(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID)) 
				q:(curDocID = "") 
				
				if (curDocID '= -1)
				{
					s DoctorDesc = $p($g(^CTPCP(+curDocID)),"^",2)    			//CT_CareProv
					s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+curDocID,0))  		//SS_User
					s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
				}
				else
				{
					s DoctorDesc = "未指定"
				}
				
				//主治医师
				s AttendDoctor = $g(^CacheTemp("SuperDoctors","EPRQuality","DischSearch",uid,curDocID,"AttendDoctor")) 
				//主任医师
				s SeniorDoctor = $g(^CacheTemp("SuperDoctors","EPRQuality","DischSearch",uid,curDocID,"SeniorDoctor"))
				
				s (DocCount, DocFirst, DocSecond, DocThird, DocFourth, DocFifth) = 0
				
				s DocCount  = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"Count"))
				s DocFirst  = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"First"))
				s DocSecond = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"Second"))
				s DocThird  = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"Third"))
				s DocFourth = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"Fourth"))
				s DocFifth = +$g(^CacheTemp("EPRQuality","DischSearch",uid,curLocID,curWardID,curDocID,"Fifth"))
				// 医生总计
				s Data = $lb("------","------",DoctorDesc,AttendDoctor,SeniorDoctor,DocFirst,DocSecond,DocThird,DocFourth,DocFifth,DocCount,curLocID,curWardID,curDocID,StartDate,EndDate,RuleID,ARegNo)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1
				
				s WardCount = WardCount + DocCount, WardFirst = WardFirst + DocFirst, WardSecond = WardSecond + DocSecond, WardThird = WardThird + DocThird,WardFourth = WardFourth + DocFourth,WardFifth = WardFifth + DocFifth
			}
			// 病区总计
			s Data = $lb("------",WardDesc,"------","------","------",WardFirst,WardSecond,WardThird,WardFourth,WardFifth,WardCount,curLocID,curWardID,"",StartDate,EndDate,RuleID,ARegNo)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
			
			s LocCount = LocCount + WardCount, LocFirst = LocFirst + WardFirst, LocSecond = LocSecond + WardSecond, LocThird = LocThird + WardThird,LocFourth = LocFourth + WardFourth,LocFifth = LocFifth + WardFifth
		}
		
		// 科室总计
		s Data = $lb(LocDesc,"------","------","------","------",LocFirst,LocSecond,LocThird,LocFourth,LocFifth,LocCount,curLocID,"","",StartDate,EndDate,RuleID,ARegNo)
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1
		
		s Count = Count + LocCount, First = First + LocFirst, Second = Second + LocSecond, Third = Third + LocThird,Fourth = Fourth + LocFourth,Fifth = Fifth + LocFifth
	}
	
	if (AIsAllLocs = "Y")
	{
		// 最后一栏的统计		
		s Data = $lb("合计","------","------","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,StartDate,EndDate,RuleID,ARegNo)
		s ^CacheTemp(uid,ind) = Data
		
		// 加上第一栏统计
		if ($zcvt(AIsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data = $lb("合计","------","------","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,StartDate,EndDate,RuleID,ARegNo)
			s ^CacheTemp(uid,1) = Data
		}
	}
	
	k ^CacheTemp("EPRQuality","DischSearch",uid)
	k ^CacheTemp("SuperDoctors","EPRQuality","DischSearch",uid)
	q $$$OK
}

/// Desc:出院质控结果查询
/// Modify by Candyxu 2012-07-12  分数从结果表中取，不必再计算
/// Modify by Candyxu 2012-12-04  缺陷等级或分数统计写入临时global
ClassMethod GetQualityReportResult(ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AQualityType As %String, AIsFinalResult As %String = "Y") As %String
{
	s ret = -1
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	q:((AQualityType = "DischSearch")&&($p(objPaAdm,"^",20) '= "D")) ret //就诊状态
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	
	s DisLocID = $p(objPaAdm,"^",4)					//出院科室
	q:(DisLocID = "") ret
	q:(ALocID '= "")&&(DisLocID '= ALocID) ret
	
	s DisWardID = $p(objPaAdm,"^",70)				//出院病区
	q:((DisWardID = "")&&(AQualityType = "DischSearch")) ret
	q:(AWardID '= "")&&(DisWardID '= AWardID) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	q:(ADoctorID '= "")&&(AdmDoctorID '= ADoctorID) ret
	s AttendDoctor = "" //主治医师
	if (AQualityType = "DischSearch")
	{
		s AttendElement = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("AttendDoctor")	
		s:(AttendElement '= "") AttendDoctor = $p(##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AttendElement,""),"^",2)
	}else
	{
		s AttendDoctor = ##Class(web.DHCCTLocMedUnitCareProv).GetLeaderDocId(AEpisodeID) 
	}
	
    s SeniorDoctor = "" //主任医师
	s SeniorElement = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("SeniorDoctor")
	s:(SeniorElement '= "") SeniorDoctor = $p(##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,SeniorElement,""),"^",2) 
		
	// 取分数、等级 结果
	if ($zcvt(AIsFinalResult,"U") = "Y")
	{
   	   s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
	}else
	{
	   s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetActualScore(AEpisodeID,ARuleID)	
	}
	q:(ScoreGrade = "") ret
	s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	
	s ^CacheTemp("EPRQuality",AQualityType,AUniqueKey,DisLocID,DisWardID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality",AQualityType,AUniqueKey,DisLocID,DisWardID,AdmDoctorID,"Count"))) + 1
	s:($g(^CacheTemp("SuperDoctors","EPRQuality",AQualityType,AUniqueKey,AdmDoctorID,"AttendDoctor")) = "") ^CacheTemp("SuperDoctors","EPRQuality",AQualityType,AUniqueKey,AdmDoctorID,"AttendDoctor") = AttendDoctor
	s:($g(^CacheTemp("SuperDoctors","EPRQuality",AQualityType,AUniqueKey,AdmDoctorID,"SeniorDoctor")) = "") ^CacheTemp("SuperDoctors","EPRQuality",AQualityType,AUniqueKey,AdmDoctorID,"SeniorDoctor") = SeniorDoctor
	//modify by Candyxu 缺陷等级或分数统计
	s objEResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	d objEResult.GetSearchReport(Grade,AUniqueKey,DisLocID,DisWardID,AdmDoctorID,AQualityType)
	d objEResult.%Close()
	s objEResult = ""
	s ret = 1
	q ret
}

ClassMethod GetEPRQualityReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRQualityReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)

 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEPRQualityReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRQualityReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetRuleIDsByRuleCodes("R001^R002")
ClassMethod GetRuleIDsByRuleCodes(ARuleCodes As %String) As %String
{
	s RuleIDs = "", IsFirstRuleID = 1
	q:(ARuleCodes = "") RuleIDs
	
	s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
	for i = 1:1:$listlength(RuleCodes)
	{
		s RuleCode = $listget(RuleCodes,i)
		continue:(RuleCode="")
		
		s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		
		if (IsFirstRuleID = 1)
		{
			s RuleIDs = RuleIDs_RuleID
			s IsFirstRuleID = 0	
		}
		else
		{
			s RuleIDs = RuleIDs_"^"_RuleID	
		}
	}
	q RuleIDs
}

/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetRuleCodesByRuleIDs("10^11")
ClassMethod GetRuleCodesByRuleIDs(ARuleIDs As %String) As %String
{
	s RuleCodes = "", IsFirstRuleID = 1
	q:(ARuleIDs = "") RuleCodes
	
	s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for i = 1:1:$listlength(RuleIDs)
	{
		s RuleID = $listget(RuleIDs,i)
		continue:(RuleID="")
		
		s RuleCode = $list($g(^DHCEPRM.QualityRuleD(RuleID)),1)
		
		if (IsFirstRuleID = 1)
		{
			s RuleCodes = RuleCodes_RuleCode
			s IsFirstRuleID = 0	
		}
		else
		{
			s RuleCodes = RuleCodes_"^"_RuleCode	
		}
	}
	q RuleCodes
}

/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).CheckExistInResultByCode(201863,"R001^R003")
ClassMethod CheckExistInResultByCode(AEpisodeID As %String, ARuleCodes As %String)
{
	s ret = -1
	q:(AEpisodeID = "")||(ARuleCodes = "") ret
	s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
	for Ind = 1:1:$listlength(RuleCodes)
	{
		s RuleCode = $listget(RuleCodes,Ind)
		continue:(RuleCode = "")
		
		s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		continue:(RuleID = "")
		
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_RuleID,""))
		if (+ResultID > 0)
		{
			s ret = 1 
			q
		}
	}
	q ret
}

/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).GetRuleIDsByCode("A^G")
ClassMethod GetRuleIDsByCode(ARuleCodes As %String)
{
	s ret ="",RuleIDs=""
	q:(ARuleCodes = "") ret
	s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
	for Ind = 1:1:$listlength(RuleCodes)
	{
		s RuleCode = $listget(RuleCodes,Ind)
		continue:(RuleCode = "")
		
		s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		continue:(RuleID = "")
		s:(RuleIDs'="") RuleIDs=RuleIDs_"^"_RuleID
		s:(RuleIDs="") RuleIDs=RuleID
	}
	s:(RuleIDs'="") ret=RuleIDs
	q ret
}

/// Debug:	w ##Class(EPRservice.Quality.BOQualityReport).CheckExistInResultByID(201863,"10^11")
ClassMethod CheckExistInResultByID(AEpisodeID As %String, ARuleIDs As %String)
{
	s ret = 0
	q:(AEpisodeID = "")||(ARuleIDs = "") ret
	
	s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for Ind = 1:1:$listlength(RuleIDs)
	{
		s RuleID = $listget(RuleIDs,Ind)
		continue:(RuleID = "")
				
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_RuleID,""))
		if (+ResultID > 0)
		{
			s ret = 1 
			q
		}
	}
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-14
/// Description:	查询病历质量统计明细;
/// 				如果没有指定登记号,则根据科室,病区,医生和出院日期去查询;否则直接走登记号；
/// Table:       	
/// Input:			ALocID为科室RowID;
/// 				AWardID为病区RowID;
/// 				ADoctorID为主治医RowID;
/// 				ARegNo为患者登记号;
/// 				AStartDate and AEndDate分别为出院起始和截止日期;
/// 				ARuleIDs为质控标准RowID字符串,多个"^"以分隔;
/// Output: 		
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetEPRReportDetail","","","","00000005","61988","61998","10^11")				
Query GetEPRReportDetail(ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, AStartDate As %Integer, AEndDate As %Integer, ARuleIDs As %String) As %Query(ROWSPEC = "Grade,Score,EpisodeID,PatientID,RegNo,MRNo,PatientName,Sex,Birthday,LocID,LocDesc,WardID,WardDesc,DoctorID,DoctorDesc,AdmitDate,DischDate,RuleIDs") [ SqlProc ]
{
}

ClassMethod GetEPRReportDetailExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, AStartDate As %Integer, AEndDate As %Integer, ARuleIDs As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	/* if you want some debug infomation, just open this closure notes
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","ALocID")		= ALocID
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","AWardID")	= AWardID
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","ADoctorID")	= ADoctorID
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","ARegNo")		= ARegNo
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","AStartDate")	= AStartDate
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","AEndDate")	= AEndDate
	s ^CacheTempXZX("EPRQuality","GetEPRReportDetail","ARuleIDs")	= ARuleIDs
	*/
		
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	q:(StartDate = "")||(EndDate = "") $$$OK
		
	k ^CacheTemp("EPRQuality","ReportDetail",repid)
	
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "")
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			// GetReportDetailResult(LocID,WardID,DoctorID,RuleIDs,EpisodeID,UniqueKey)
			s flag = ..GetReportDetailResult("","","",ARuleIDs,EpisodeID,repid)
			continue:(flag < 0)
		}	
	}
	else
	{
		for DischDate = StartDate:1:EndDate 
		{
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
				q:(EpisodeID = "")
				
				// GetReportDetailResult(LocID,WardID,DoctorID,RuleIDs,EpisodeID,UniqueKey)
				s flag = ..GetReportDetailResult(ALocID,AWardID,ADoctorID,ARuleIDs,EpisodeID,repid)
				continue:(flag < 0)
			}
		}
	}
		
	s PaAdmID = ""
	for {
		s PaAdmID = $o(^CacheTemp("EPRQuality","ReportDetail",repid,PaAdmID))
		q:(PaAdmID = "")
		
		s Data = $g(^CacheTemp("EPRQuality","ReportDetail",repid,PaAdmID))
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	k ^CacheTemp("EPRQuality","ReportDetail",repid)
	
	q $$$OK
}

/// ^CacheTemp("EPRQuality","ReportDetail",AUniqueKey,AEpisodeID) = $lb(Grade,Score,AEpisodeID,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,ARuleIDs)
/// w ##Class(EPRservice.Quality.BOQualityReport).GetReportDetailResult("","","","10^11","201863")
ClassMethod GetReportDetailResult(ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleIDs As %String, AEpisodeID As %String, AUniqueKey As %String)
{
	s ret = -1
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	q:($p(objPaAdm,"^",20) '= "D") ret			//就诊状态
	
	s AdmLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(AdmLocID = "") ret
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret
	
	s AdmWardID = $p(objPaAdm,"^",70)				//出院病区
	q:(AdmWardID = "") ret
	q:(AWardID '= "")&&(AdmWardID '= AWardID) ret
	
	s flag = ..CheckExistInResultByID(AEpisodeID, ARuleIDs)
	q:(flag <= 0) ret 
	
	s AdmDoctorID = $p(objPaAdm,"^",9)
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	q:(ADoctorID '= "")&&(AdmDoctorID '= ADoctorID) ret
	
	s Result = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
	s Score = $p(Result,"^",1)
	s Grade = $p(Result,"^",2)
	
	// 患者基本信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3),Birthday=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",Birthday)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3),AdmitDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmitDate)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3),DischDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)			//PAC_Ward
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDoctorID '= "-1":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
	
	s ^CacheTemp("EPRQuality","ReportDetail",AUniqueKey,AEpisodeID) = $lb(Grade,Score,AEpisodeID,Papmi,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,ARuleIDs)
	
	s ret = 1
	q ret
}

ClassMethod GetEPRReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRReportDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEPRReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRReportDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-28
/// Description:	Query quality detail by reference rule 
/// Table:       	
/// Input:			ALocID means
/// 				AWardID means 
/// 				ARuleID means
/// 				ARegNo means
/// 				APatientName means
/// 				AStartDate and AEndDate means
/// Output: 		
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityProfilerList","","","1","","","2019-01-01","2021-01-01","","A")						
Query GetQualityProfilerList(ALocIDs As %Text, ADoctorID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AMedicareNo As %String, AActions As %Text, AHospitalID As %String = "", LocType As %String = "", ASignUserName As %String = "") As %Query(ROWSPEC = "EpisodeID,DisLocID,LocDesc,DisWardID,WardDesc,AdmDoctorID,DoctorDesc,RuleID,RuleDesc,StructID,StructName,EntryID,EntryTitle,RegNo,Name,AdmitDate,DischDate,Recorder,MRNo,ExamCount,ResumeText,MessageID,MessageStatus,ZRLocDesc,ZRDoctorDesc") [ SqlProc ]
{
}

ClassMethod GetQualityProfilerListExecute(ByRef qHandle As %Binary, ALocIDs As %Text, ADoctorID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AMedicareNo As %String, AActions As %Text, AHospitalID As %String = "", LocType As %String = "", ASignUserName As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	s RuleID = $g(ARuleID)
	q:(RuleID = "") $$$OK
	q:(AStartDate="")||(AEndDate="") $$$OK	
	
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	

	k ^CacheTemp("EPRQuality","Profiler",repid)
	
	if (ARegNo '= "")
	{
		
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s existed = ..CheckExistInResultByID(EpisodeID, ARuleID)
			continue:(existed <= 0) 
			
			// BuildProfilerData(LocID,WardID,RuleID,EpisodeID,StartDate,EndDate,UniqueKey)
			s flag = ..BuildProfilerData("","",ADoctorID,ARuleID,EpisodeID,"","",AActions,LocType,ASignUserName,repid)
			continue:(flag < 0)
		}	
	}
	elseif (AMedicareNo '= "")
	{
		
		s PatientID=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMedicareNo,"I","",.ErrMsg)
		q:(PatientID="") $$$OK
		
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s existed = ..CheckExistInResultByID(EpisodeID, ARuleID)
			continue:(existed <= 0) 
			
			s flag = ..BuildProfilerData("","",ADoctorID,ARuleID,EpisodeID,"","",AActions,LocType,ASignUserName,repid)
			continue:(flag < 0)
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s PatientID = ""
		for {
			s PatientID = $o(^PAPERi("PAPER_PatName",APatientName,PatientID))
			q:(PatientID = "")	
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
				q:(EpisodeID = "")
				s objPaAdm = $g(^PAADM(+EpisodeID))
			    s AdmLocID = $p(objPaAdm,"^",4)		
			    s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		        continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
				s existed = ..CheckExistInResultByID(EpisodeID, ARuleID)
				continue:(existed <= 0) 
		
				// BuildProfilerData(LocID,WardID,RuleID,EpisodeID,StartDate,EndDate,UniqueKey)
				s flag = ..BuildProfilerData("","",ADoctorID,ARuleID,EpisodeID,"","",AActions,LocType,ASignUserName,repid)
				continue:(flag < 0)
			}
		}	
	}
	else
	{
		for ExamineDate = StartDate:1:EndDate
	    {
		 s ResultID = ""
		 for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxExamineDate"," "_$zd(ExamineDate,3),ResultID))
				q:(ResultID = "")
	            s ObjResult=##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	            continue:(ObjResult="")
	            continue:(ObjResult.RuleDR'=ARuleID)
				s EpisodeID = ObjResult.EpisodeID
				s objPaAdm = $g(^PAADM(+EpisodeID))
				s AdmLocID = $p(objPaAdm,"^",4)		
				s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
			
			    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)	
				s flag = ..BuildProfilerData(ListLocID,ADoctorID,ARuleID,EpisodeID,"","",AActions,LocType,ASignUserName,repid)
				continue:(flag < 0)
		    }
		}
	}
	
	s EpisodeID = ""
	for {
	    s EpisodeID = $o(^CacheTemp("EPRQuality","Profiler",repid,EpisodeID))
	    q:(	EpisodeID = "")
	    s Key = ""
	    for {
		   s Key = $o(^CacheTemp("EPRQuality","Profiler",repid,EpisodeID,Key))
		   q:(Key = "")
		   s EntryID = ""
		   for {
		       s EntryID = $o(^CacheTemp("EPRQuality","Profiler",repid,EpisodeID,Key,EntryID))
		       q:(EntryID = "")
		       s Data = $g(^CacheTemp("EPRQuality","Profiler",repid,EpisodeID,Key,EntryID))
		       s ^CacheTemp(repid,ind) = Data
		       s ind = ind + 1
		   }		   
		}
	}
	k ^CacheTemp("EPRQuality","Profiler",repid)
	
	q $$$OK
}

ClassMethod BuildProfilerData(AListLocID As %String, ADoctorID As %String, ARuleID As %String, AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AActions As %String, LocType As %String, ASignUserName As %String, AUniqueKey As %String) As %String
{
	s ret = -1

	s RuleDesc = $list($g(^DHCEPRM.QualityRuleD(+ARuleID)),2)
	
	s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,ResultID))
		q:(ResultID = "")
		
		s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 

		s ExamineDate = objResult.ExamineDate
		continue:(ExamineDate = "")
		s ExamineDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)
		continue:(AStartDate '= "")&&(ExamineDate < AStartDate)
		continue:(AEndDate '= "")&&(ExamineDate > AEndDate)
		
		 s Action=objResult.Action
		 continue:(AActions'="")&&(AActions'[Action) 
		  	  
		// 报告人
		s RecorderID = objResult.SignUserDR
		s Recorder = $s($g(RecorderID)'="-1":$p($g(^SSU("SSUSR",+RecorderID)),"^",2),1:"自动任务")
		continue:(ASignUserName'="")&&(Recorder'[ASignUserName)		
		s objPaAdm = $g(^PAADM(+AEpisodeID))	
		
		s DisLocID = $p(objPaAdm,"^",4)					//出院科室
		continue:(DisLocID = "")
		continue:(LocType="Dis")&&(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) 
		
		s DisWardID = $p(objPaAdm,"^",70)				//出院病区
		continue:(DisWardID = "")
		
		s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生
		continue:(ADoctorID '= "")&&(AdmDoctorID '= ADoctorID)

		s Papmi = $p(objPaAdm,"^",1)
		s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		//continue:(ARegNo '= "")&&(RegNo '= ARegNo)
		
		s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
		//continue:(APatientName '= "")&&(Name '[ APatientName)
				
		//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
		s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
		s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
		s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
		s:(Birthday '= "") Birthday = $zd(Birthday,3)
		s AdmitDate = $zd($p(objPaAdm,"^",6),3)
		s DischDate = $p(objPaAdm,"^",17)
		s:(DischDate '= "") DischDate = $zd(DischDate,3)
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)			
		s WLocID = $p($g(^PAWARD(+DisWardID)),"^",5)
		s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
		s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
		s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		s DetailID=""
		for
		{
			s DetailID=$O(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,DetailID))
			q:DetailID=""
			s ResultDetail=ResultID_"||"_DetailID
	
			s objDetail = ##class(EPRinstance.Quality.QualityResultDetail).%OpenId(ResultDetail)
		  	continue:(objDetail="")
		  	
		  	s EntryID = objDetail.EntryDR
		  		
		  	// 如果这个条目被删除了，则不参与计分
		    continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
		  		
		  	s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
		  		
		  	s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(+EntryID)
		  	continue:(objEntry = "")
		  	s StructID = objEntry.StructDR
		  	s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		  	continue:(objStruct = "")
		  	s StructName = objStruct.StandardName
		  	s ExamCount =  objDetail.ExamCount
		  	s ResumeText = objDetail.ResumeText	
		  	s CtLocID=objDetail.People.CtLocDr
		  	s EmployeeDr =objDetail.People.EmployeeDr
		  	continue:(LocType="ZR")&&(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,CtLocID) = 0)
		  	s ZRLocDesc = $p($g(^CTLOC(+CtLocID)),"^",2)
		    s:(ZRLocDesc [ "-") ZRLocDesc = $p(ZRLocDesc,"-",2)
		    s ZRDoctorDesc = $s(EmployeeDr '= "":$p($g(^CTPCP((+EmployeeDr),1)),"^",2),1:"未指定") 
		  	s MessageID=$O(^DHCEPRQ.EPRSingleMessageI("IdxResultDetailID"," "_ResultDetail,""))
		  	s MessageStatus="未发送消息"
		  		
		  	if (MessageID'="")
		  	{
			  	s objMessage=##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
			  	continue:(objMessage="")
			  	s ReadFlag=objMessage.ReadFlag
				s:(ReadFlag="U") MessageStatus="未读未执行"
				s:(ReadFlag="R") MessageStatus="已读"
				s:(ReadFlag="E") MessageStatus="已处理" 
				
				s ExecuteFlag=objMessage.EffectiveFlag
				s:(ExecuteFlag="E" ) MessageStatus="已处理"	
				s ConfirmFlag=objMessage.ConfirmFlag
				s:(ConfirmFlag="C") MessageStatus="确认已修复"
			}
		  	else 
		  	{
			  	s MessageStatus="未发送消息"
			}		
			s ^CacheTemp("EPRQuality","Profiler",AUniqueKey,AEpisodeID,ResultDetail,EntryID) = $lb(AEpisodeID,DisLocID,LocDesc,DisWardID,WardDesc,AdmDoctorID,DoctorDesc,ARuleID,RuleDesc,StructID,StructName,EntryID,EntryTitle,RegNo,Name,AdmitDate,DischDate,Recorder,MRNo,ExamCount,ResumeText,MessageID,MessageStatus,ZRLocDesc,ZRDoctorDesc)
		  	
		} 
		
		
	}
	
	s ret = 1
	q ret
}

ClassMethod GetQualityProfilerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityProfilerListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityProfilerListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityProfilerListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-28
/// Description:	病历质量统计报表，数据来源为出院患者自动任务结果集；
/// Table:       	
/// Input:			AStartDate means 
/// 				AEndDate means 
/// 				ARuleCode means
/// Output: 		Query result by your assigned condtion
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualitySummaryList","","2018-09-01","2022-09-28","A^G","Y","Y","2")	
Query GetQualitySummaryList(ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsMultiSummary As %String = "Y", AIsDocSummary As %String = "Y", AHospitalID As %String = "") As %Query(ROWSPEC = "Department,Doctor,AvgScore,Count,FirstCount,FirstPercent,SecondCount,SecondPercent,ThirdCount,ThirdPercent,FourthCount,FourthPercent,FifthCount,FifthPercent,DisLocID,DocID") [ SqlProc ]
{
}

ClassMethod GetQualitySummaryListExecute(ByRef qHandle As %Binary, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsMultiSummary As %String, AIsDocSummary As %String = "Y", AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2  //从2开始，防止被合计行覆盖
	s qHandle = $lb(0,uid,"")

	q:(ARuleCodes = "") $$$OK	
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	
	/* Debug
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","1ALocIDs") = ALocIDs
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","2AStartDate")	= AStartDate
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","3AEndDate") = AEndDate
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","4ARuleCodes") = ARuleCodes
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","5AIsMultiSummary") = AIsMultiSummary
	s ^CacheTemp("EPRQuality","GetQualitySummaryList","6AIsDocSummary") = AIsDocSummary
	*/
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
	//s StartDate = StartDate - Days
	//s EndDate	= EndDate - Days
	
	k ^CacheTemp("EPRQuality","Summary",uid)
	
	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1)
			
			// BuildSummaryList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildSummaryList(EpisodeID,ListLocID,ARuleCodes,uid)
			continue:(flag < 0)	                                                                                         
		}	
	}
	
	q:('$d(^CacheTemp("EPRQuality","Summary",uid))) $$$OK
	
	s (Score, Count, First, Second, Third, Fourth, Fifth) = 0
	
	s DisLocID = "" 
	for	{ 
		s DisLocID = $o(^CacheTemp("EPRQuality","Summary",uid,DisLocID)) 
		q:(DisLocID = "")
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocScore,LocCount,LocFirst,LocSecond, LocThird, LocFourth, LocFifth) = 0
		
		s DocID = ""
		for { 
			s DocID = $o(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID)) 
			q:(DocID = "") 
			
			s (DocScore,DocCount,DocFirst,DocSecond, DocThird, DocFourth ,DocFifth) = 0
			
			if (DocID '= "-1")
			{
				s DoctorDesc = $p($g(^CTPCP(+DocID)),"^",2)    			//CT_CareProv
				s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+DocID,0))  		//SS_User
				s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
			}
			else
			{
				s DoctorDesc = "未指定"	
			}
			
			s DocScore  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Score"))
			s DocCount  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Count"))
			s DocFirst  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"First"))
			s DocSecond = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Second"))
			s DocThird  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Third"))
			s DocFourth  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Fourth"))
			s DocFifth  = +$g(^CacheTemp("EPRQuality","Summary",uid,DisLocID,DocID,"Fifth"))
			// 医生总计
			if ($ZCVT(AIsDocSummary,"U") = "Y")
			{
			   s DocAvgScore = $s(DocScore#DocCount=0:DocScore/DocCount,1:$j(DocScore/DocCount,2,1))
			   s DocFirstPercent = $s(DocFirst*100#DocCount=0:DocFirst*100/DocCount,1:$j(DocFirst*100/DocCount,2,1))
			   s DocSecondPercent = $s(DocSecond*100#DocCount=0:DocSecond*100/DocCount,1:$j(DocSecond*100/DocCount,2,1))
			   s DocThirdPercent = $s(DocThird*100#DocCount=0:DocThird*100/DocCount,1:$j(DocThird*100/DocCount,2,1))
			   s DocFourthPercent = $s(DocFourth*100#DocCount=0:DocFourth*100/DocCount,1:$j(DocFourth*100/DocCount,2,1))
			   s DocFifthPercent = $s(DocFifth*100#DocCount=0:DocFifth*100/DocCount,1:$j(DocFifth*100/DocCount,2,1))
			
			   s Data = $lb("------",DoctorDesc,DocAvgScore,DocCount,DocFirst,DocFirstPercent_"%",DocSecond,DocSecondPercent_"%",DocThird,DocThirdPercent_"%",DocFourth,DocFourthPercent_"%",DocFifth,DocFourthPercent_"%",DisLocID,DocID)
			   s ^CacheTemp(uid,ind) = Data
			}
			s ind = ind + 1
			
			s LocScore = LocScore + DocScore, LocCount = LocCount + DocCount, LocFirst = LocFirst + DocFirst, LocSecond = LocSecond + DocSecond, LocThird = LocThird + DocThird, LocFourth = LocFourth + DocFourth, LocFifth = LocFifth + DocFifth
		}
		
		// 科室总计
		s LocAvgScore = $s(LocScore#LocCount=0:LocScore/LocCount,1:$j(LocScore/LocCount,2,1))
		s LocFirstPercent = $s(LocFirst*100#LocCount=0:LocFirst*100/LocCount,1:$j(LocFirst*100/LocCount,2,1))
		s LocSecondPercent = $s(LocSecond*100#LocCount=0:LocSecond*100/LocCount,1:$j(LocSecond*100/LocCount,2,1))
		s LocThirdPercent = $s(LocThird*100#LocCount=0:LocThird*100/LocCount,1:$j(LocThird*100/LocCount,2,1))
		s LocFourthPercent = $s(LocFourth*100#LocCount=0:LocFourth*100/LocCount,1:$j(LocFourth*100/LocCount,2,1))
		s LocFifthPercent = $s(LocFifth*100#LocCount=0:LocFifth*100/LocCount,1:$j(LocFifth*100/LocCount,2,1))
		
		s Data = $lb(LocDesc,"小计",LocAvgScore,LocCount,LocFirst,LocFirstPercent_"%",LocSecond,LocSecondPercent_"%",LocThird,LocThirdPercent_"%",LocFourth,LocFourthPercent_"%",LocFifth,LocFifthPercent_"%",DisLocID,"")
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1
		
		s Score = Score + LocScore, Count = Count + LocCount, First = First + LocFirst, Second = Second + LocSecond, Third = Third + LocThird, Fourth = Fourth + LocFourth, Fifth = Fifth + LocFifth
	}
	
	// 最后一栏的统计
	s AvgScore = $s(Score#Count=0:Score/Count,1:$j(Score/Count,2,1))
	s FirstPercent = $s(First*100#Count=0:First*100/Count,1:$j(First*100/Count,2,1))
	s SecondPercent = $s(Second*100#Count=0:Second*100/Count,1:$j(Second*100/Count,2,1))
	s ThirdPercent = $s(Third*100#Count=0:Third*100/Count,1:$j(Third*100/Count,2,1))
	s FourthPercent = $s(Fourth*100#Count=0:Fourth*100/Count,1:$j(Fourth*100/Count,2,1))
	s FifthPercent = $s(Fifth*100#Count=0:Fifth*100/Count,1:$j(Fifth*100/Count,2,1))
	
	s Data = $lb("合计","------",AvgScore,Count,First,FirstPercent_"%",Second,SecondPercent_"%",Third,ThirdPercent_"%",Fourth,FourthPercent_"%",Fifth,FifthPercent_"%","","")
	s ^CacheTemp(uid,ind) = Data
	
	// 增加第一栏的统计
	if ($zcvt(AIsMultiSummary,"U") = "Y")&&(ind > 26)
	{
		s Data = $lb("合计","------",AvgScore,Count,First,FirstPercent_"%",Second,SecondPercent_"%",Third,ThirdPercent_"%",Fourth,FourthPercent_"%",Fifth,FifthPercent_"%","","")
		s ^CacheTemp(uid,1) = Data	
	}
	
	k ^CacheTemp("EPRQuality","Summary",uid)
	
	q $$$OK
}

ClassMethod BuildSummaryList(AEpisodeID As %String, AListLocID As %List, ARuleCodes As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(ARuleCodes = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret			//就诊状态
	
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	
	s DisLocID = $p(objPaAdm,"^",4)					//出院科室
	q:(DisLocID = "") ret
	q:(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	//s existed = ..CheckExistInResultByCode(AEpisodeID, ARuleCodes)
	//q:(existed <= 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	s ARuleIDs=..GetRuleIDsByCode(ARuleCodes)
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 	s sc = result.Execute(AEpisodeID,ARuleIDs,"D")
	While (result.Next())
	{
		s Grade = result.Data("FinalGrade")
		s Score = result.Data("FinalScore")
	}
		
	s ^CacheTemp("EPRQuality","Summary",AUniqueKey,DisLocID,AdmDoctorID,"Score") = (+$g(^CacheTemp("EPRQuality","Summary",AUniqueKey,DisLocID,AdmDoctorID,"Score"))) + Score
	s ^CacheTemp("EPRQuality","Summary",AUniqueKey,DisLocID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality","Summary",AUniqueKey,DisLocID,AdmDoctorID,"Count"))) + 1
	s objResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	d objResult.GetQualityReportGloable(Grade,"Summary",AUniqueKey,DisLocID,AdmDoctorID)
	d objResult.%Close()
	s objResult = ""
	
	s ret = 1
	q ret
}

ClassMethod GetQualitySummaryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualitySummaryListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualitySummaryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualitySummaryListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Others:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualitySummaryDetail","","","2019-01-01","2022-09-28","A^G","","")
Query GetQualitySummaryDetail(ALocID As %String, ADocID As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AGrade As %String = "", ASummaryLocIDs As %Text = "", AHospitalID As %String = "") As %Query(ROWSPEC = "LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,Grade,Score,EntryTitle,EntryScore") [ SqlProc ]
{
}

ClassMethod GetQualitySummaryDetailExecute(ByRef qHandle As %Binary, ALocID As %String, ADocID As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AGrade As %String = "", ASummaryLocIDs As %Text = "", AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,"")
	
	q:(AStartDate = "")||(AEndDate = "") $$$OK	
    s:(AGrade="First") AGrade="甲"
    s:(AGrade="Second") AGrade="乙"
    s:(AGrade="Third") AGrade="丙"
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	s ListLocID=""
	s:(ASummaryLocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ASummaryLocIDs,",")
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
	//s StartDate = StartDate - Days
	//s EndDate	= EndDate - Days
	k ^CacheTemp("QualitySummaryDetail",uid)
	
	s Number = 0

	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
		
			s flag1= ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag1< 1) 
		    s objPaAdm = $g(^PAADM(+EpisodeID))
			s LocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+LocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s flag2= ..BuildQualitySummaryDetail(EpisodeID,ALocID,ADocID,ARuleCodes,AGrade,ListLocID,uid)
			continue:(flag2 < 0)	
			s Number = Number + 1                                                                                         
		}	
	
	
  }
 
  s tmpadmid="" 
  for {                          
	  s tmpadmid= $o(^CacheTemp("QualitySummaryDetail",uid,tmpadmid))
	  q:tmpadmid=""
	  
	  s tmpEntryID=""
	  for {
		  s tmpEntryID= $o(^CacheTemp("QualitySummaryDetail",uid,tmpadmid,tmpEntryID))
		  q:tmpEntryID=""
		  
		  s Data = ^CacheTemp("QualitySummaryDetail",uid,tmpadmid,tmpEntryID)
		  s ^CacheTemp(uid,ind) = Data
		  s ind = ind + 1
		  }
	
	}
  k ^CacheTemp("QualitySummaryDetail")
	
	Quit $$$OK
}

ClassMethod BuildQualitySummaryDetail(AEpisodeID As %String, ALocID As %String, ADocID As %String, ARuleCodes As %String, AGrade As %String, AListLocID As %List, AUniqueKey As %String) As %String
{
	
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret		//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	 
	s ARuleIDs=..GetRuleIDsByCode(ARuleCodes)
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 	s sc = result.Execute(AEpisodeID,ARuleIDs,"D")
	While (result.Next())
	{
		s Grade = result.Data("FinalGrade")
		s Score = result.Data("FinalScore")
	}
	
    q:(AGrade'="")&&(AGrade'=Grade) ret
   
	q:((ALocID'="")&&($ZCVT(ALocID,"U")'="NULL")&&(DisLocID'=ALocID)) ret
	
	q:(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	q:(ADocID'="")&&(AdmDoctorID'=ADocID) ret
	s DetailFlag=0
    s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
    s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
    //s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
    s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
    s existed = ..CheckExistInResultByCode(AEpisodeID, ARuleCodes)
    if (existed=1)
    {
		s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
		for Ind = 1:1:$listlength(RuleCodes)
		{
		  s RuleCode = $listget(RuleCodes,Ind)
		  continue:(RuleCode = "")
			
		  s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		  continue:(RuleID = "")
		  s ResultID = ""
		  for {
			  
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_RuleID," "_AEpisodeID,ResultID))
				q:(ResultID = "")
				s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
				s Action=objResult.Action
				continue:(RuleID=1)&&(Action'="D")
				s key = ""
				do {
					
					s objDetail = objResult.Details.GetNext(.key)
				  	if (objDetail '= "")
			  	    { 
				  	   
				  		s EntryID = objDetail.EntryDR
				  		
				  		// 如果这个条目被删除了，则不参与计分
						continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
						s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(+EntryID)
				  		continue:(objEntry = "")
				  		s StructID = objEntry.StructDR
				  		s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
				  		continue:(objStruct = "")
				  		s StructName = objStruct.StandardName
				  		s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
				  		s ExamCount =  objDetail.ExamCount
				  		s EntryScore = objDetail.EntryScore
				  		s ResumeText = objDetail.ResumeText
			  		    s DetailFlag=1
			        	s ^CacheTemp("QualitySummaryDetail",AUniqueKey,AEpisodeID,$i(^CacheTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,Grade,Score,EntryTitle,EntryScore)
		        	}
				} while(key '= "")
			
				d objResult.%Close()
			
	     }
	}

		if (DetailFlag=0)
		{
			
			s EntryTitle=""
			s EntryScore=""
			s ^CacheTemp("QualitySummaryDetail",AUniqueKey,AEpisodeID,$i(^CacheTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,Grade,Score,EntryTitle,EntryScore)
		}
    }
	else
	{
		s EntryTitle=""
		s EntryScore=""
		s ^CacheTemp("QualitySummaryDetail",AUniqueKey,AEpisodeID,$i(^CacheTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,Grade,Score,EntryTitle,EntryScore)
	}	

		
	s ret=1
	q ret
}

ClassMethod GetQualitySummaryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualitySummaryDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQualitySummaryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualitySummaryDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(EPRservice.Quality.BOQualityReport).ExportSummaryReport(AItemJS,AParameters)
ClassMethod ExportSummaryReport(AItemJS As %Library.String = "", AParameters As %String) As %Status
{
	s LocIDs = $p(AParameters,"#",1)
	s StartDate = $p(AParameters,"#",2)
	s EndDate = $p(AParameters,"#",3)
	s RuleCodes = $p(AParameters,"#",4)
	
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BOQualityReport:GetQualitySummaryList")
	d ds.Execute(LocIDs,StartDate,EndDate,RuleCodes,"N")
	s StartRow = 8
	while(ds.Next())
	{
		s Department = ds.Data("Department")
		s Doctor = ds.Data("Doctor")
		s AvgScore = ds.Data("AvgScore")
		s Count = ds.Data("Count")
		s FirstCount = ds.Data("FirstCount")
		s FirstPercent = ds.Data("FirstPercent")
		s SecondCount = ds.Data("SecondCount")
		s SecondPercent =ds.Data("SecondPercent")
		s ThirdCount = ds.Data("ThirdCount")
		s ThirdPercent = ds.Data("ThirdPercent")
		
		//登记号,病案号,姓名,出院日期,科室,病区,床号,医生
		s valCells = Department_$c(1)_Doctor_$c(1)_AvgScore_$c(1)_Count_$c(1)_FirstCount_$c(1)_FirstPercent_$c(1)_SecondCount_$c(1)_SecondPercent_$c(1)_ThirdCount_$c(1)_ThirdPercent
	 	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count = Count + 1
		s StartRow = StartRow + 1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	s valCells = "统计日期："_StartDate_" 至 "_EndDate
	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',5,1);"
	&javascript<#(retval)#>
}

/// Creator:		HKY
/// CreatDate:		2019-05-31
/// Description:	单项否决统计报表,数据来源为出院患者自动任务结果集；
/// Table:       	无;
/// Input:			ALocIDs为科室RowID;
/// 				AStartDate为统计开始日期;
/// 				AEndDate为统计截止日期;
/// 				ARuleCode为质控标准代码;
/// Output: 		Query result by your assigned condtion
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityVetoReport","221","2022-10-20","2022-10-22","A^G","Y","")				
Query GetQualityVetoReport(ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsMultiSummary As %String = "Y", AHospitalID As %String = "") As %Query(ROWSPEC = "Department,Doctor,Count,VetoBCount,VetoBPercent,VetoCCount,VetoCPercent,DisLocID,DocID") [ SqlProc ]
{
}

ClassMethod GetQualityVetoReportExecute(ByRef qHandle As %Binary, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AIsMultiSummary As %String = "Y", AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,uid,"")
	
	q:(ARuleCodes = "") $$$OK	
	q:(AStartDate = "")||(AEndDate = "") $$$OK	
	
	/* Debug
	s ^CacheTemp("EPRQuality","GetQualityVetoReport","ALocIDs")		= ALocIDs
	s ^CacheTemp("EPRQuality","GetQualityVetoReport","AStartDate")	= AStartDate
	s ^CacheTemp("EPRQuality","GetQualityVetoReport","AEndDate")		= AEndDate
	s ^CacheTemp("EPRQuality","GetQualityVetoReport","ARuleCodes")	= ARuleCodes
	*/
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
	//s StartDate = StartDate - Days
	//s EndDate	= EndDate - Days
		
	k ^CacheTemp("EPRQuality","VetoReport",uid)
	
	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1)
			
			// BuildSummaryList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildVetoReportList(EpisodeID,ListLocID,ARuleCodes,uid)
			continue:(flag < 0)	                                                                                         
		}	
	}
	
	q:('$d(^CacheTemp("EPRQuality","VetoReport",uid))) $$$OK
	
	s DisLocID = "", Count = 0, BCount = 0, CCount = 0
	for	{ 
		s DisLocID = $o(^CacheTemp("EPRQuality","VetoReport",uid,DisLocID)) 
		q:(DisLocID = "")
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocCount, LocBCount, LocCCount) = 0
				
		s DocID = ""
		for { 
			s DocID = $o(^CacheTemp("EPRQuality","VetoReport",uid,DisLocID,DocID)) 
			q:(DocID = "") 
			
			if (DocID '= -1)
			{
				s DoctorDesc = $p($g(^CTPCP(+DocID)),"^",2)    			//CT_CareProv
				s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+DocID,0))  		//SS_User
				s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
			}
			else
			{
				s DoctorDesc = "未指定"	
			}
			
			s (DocCount, DocBCount, DocCount) = 0
			
			s DocCount  = +$g(^CacheTemp("EPRQuality","VetoReport",uid,DisLocID,DocID,"Count"))
			s DocBCount = +$g(^CacheTemp("EPRQuality","VetoReport",uid,DisLocID,DocID,"BCount"))
			s DocCCount = +$g(^CacheTemp("EPRQuality","VetoReport",uid,DisLocID,DocID,"CCount"))
			
			// 医生总计
			s DocBPercent = $s(DocBCount*100#DocCount=0:DocBCount*100/DocCount,1:$j(DocBCount*100/DocCount,2,1))
			s DocCPercent = $s(DocCCount*100#DocCount=0:DocCCount*100/DocCount,1:$j(DocCCount*100/DocCount,2,1))
			
			s Data = $lb("------",DoctorDesc,DocCount,DocBCount,DocBPercent_"%",DocCCount,DocCPercent_"%",DisLocID,DocID)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
			
			s LocCount = LocCount + DocCount, LocBCount = LocBCount + DocBCount, LocCCount = LocCCount + DocCCount
		}
		
		// 科室总计
		s LocBPercent = $s(LocBCount*100#LocCount=0:LocBCount*100/LocCount,1:$j(LocBCount*100/LocCount,2,1))
		s LocCPercent = $s(LocCCount*100#LocCount=0:LocCCount*100/LocCount,1:$j(LocCCount*100/LocCount,2,1))
		
		s Data = $lb(LocDesc,"小计",LocCount,LocBCount,LocBPercent_"%",LocCCount,LocCPercent_"%",DisLocID,"")
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1
		
		s Count = Count + LocCount, BCount = BCount + LocBCount, CCount = CCount + LocCCount
	}
	
	// 最后一栏的统计
	s BPercent = $s(BCount*100#Count=0:BCount*100/Count,1:$j(BCount*100/Count,2,1))
	s CPercent = $s(CCount*100#Count=0:CCount*100/Count,1:$j(CCount*100/Count,2,1))
	
	if ($zcvt(AIsMultiSummary,"U") = "Y")&&(ind > 25)
	{
		s Data = $lb("合计","------",Count,BCount,BPercent_"%",CCount,CPercent_"%","","")
		s ^CacheTemp(uid,ind) = Data
	}
	
	// 增加第一栏的统计
	s Data = $lb("合计","------",Count,BCount,BPercent_"%",CCount,CPercent_"%","","")
	s ^CacheTemp(uid,1) = Data	
	
	k ^CacheTemp("EPRQuality","VetoReport",uid)
	
	q $$$OK
}

ClassMethod BuildVetoReportList(AEpisodeID As %String, AListLocID As %List, ARuleCodes As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(ARuleCodes = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret			//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret

	//s existed = ..CheckExistInResultByCode(AEpisodeID, ARuleCodes)
	//q:(existed <= 0) ret

	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"

	s ARuleIDs=..GetRuleIDsByCode(ARuleCodes)
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 	s sc = result.Execute(AEpisodeID,ARuleIDs,"D")
	While (result.Next())
	{
		s BCount = result.Data("BCount")
		s CCount = result.Data("CCount")
	}
	
	s ^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"Count"))) + 1
	if (CCount > 0)
	{
		s ^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"CCount") = (+$g(^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"CCount"))) + 1
	}
	elseif (BCount > 0)
	{
		s ^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"BCount") = (+$g(^CacheTemp("EPRQuality","VetoReport",AUniqueKey,DisLocID,AdmDoctorID,"BCount"))) + 1
	}
	
	s ret = 1
	q ret
}

ClassMethod GetQualityVetoReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityVetoReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityVetoReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityVetoReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Others:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityVetoReportDetail",97,"","2020-04-01","2020-04-17","A^G","Y")				
Query GetQualityVetoReportDetail(ALocID As %String, ADoctorID As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AGradeFlag As %String = "", AVetoLocIDs As %Text = "", AHospitalID As %String = "") As %Query(ROWSPEC = "LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,EntryTitle,EntryScore,VetoGrade") [ SqlProc ]
{
}

ClassMethod GetQualityVetoReportDetailExecute(ByRef qHandle As %Binary, ALocID As %String, ADoctorID As %String, AStartDate As %String, AEndDate As %String, ARuleCodes As %String, AGradeFlag As %String = "", AVetoLocIDs As %Text = "", AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,"")
	
	q:(AStartDate = "")||(AEndDate = "") $$$OK	
    q:(ARuleCodes="") $$$OK
    
    s ListLocID=""
	s:(AVetoLocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AVetoLocIDs,",")
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
	//s StartDate = StartDate - Days
	//s EndDate	= EndDate - Days
	k ^CacheTemp("QualityVetoReportDetail",uid)
	
	s Number = 0

	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
		
			s flag1= ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag1< 1) 
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s LocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+LocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s flag2= ..BuildQualityVetoReportDetail(EpisodeID,ALocID,ADoctorID,ARuleCodes,AGradeFlag,ListLocID,uid)
			continue:(flag2 < 0)	
			s Number = Number + 1                                                                                         
		}	
	
	
  }
 s tmpadmid="" 
  for {
	  s tmpadmid= $o(^CacheTemp("QualityVetoReportDetail",uid,tmpadmid))
	  q:tmpadmid=""
	  if ($d(^CacheTemp("QualityVetoReportDetail",uid,tmpadmid))=10)
	  {
		  s tmpEntryID=""
		  for
		  {
			  s tmpEntryID=$o(^CacheTemp("QualityVetoReportDetail",uid,tmpadmid,tmpEntryID))
			  q:tmpEntryID=""
			  s Data = ^CacheTemp("QualityVetoReportDetail",uid,tmpadmid,tmpEntryID)
	          s ^CacheTemp(uid,ind) = Data
	          s ind = ind + 1
		   }
	  }
	  else
	  {
  	  s Data = ^CacheTemp("QualityVetoReportDetail",uid,tmpadmid)
	  s ^CacheTemp(uid,ind) = Data
	  s ind = ind + 1
	  }
  }
  k ^CacheTemp("QualityVetoReportDetail",uid)
	Quit $$$OK
}

ClassMethod GetQualityVetoReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityVetoReportDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod GetQualityVetoReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityVetoReportDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildQualityVetoReportDetail(AEpisodeID As %String, ALocID As %String, ADocID As %String, ARuleCodes As %String, ACondition As %String, AListLocID As %List, AUniqueKey As %String) As %String
{
	
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
   
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret		//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:(((ALocID'="")&&(ALocID'="NULL")&&(ALocID'="null"))&&(DisLocID'=ALocID)) ret
	q:(AListLocID'="")&&($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	q:(ADocID'="")&&(AdmDoctorID'=ADocID) ret
	s:(AdmDoctorID = "") AdmDoctorID = "Other"
	
	s ARuleIDs=..GetRuleIDsByCode(ARuleCodes)
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 	s sc = result.Execute(AEpisodeID,ARuleIDs,"D")
	While (result.Next())
	{
		s BCount = result.Data("BCount")
		s CCount = result.Data("CCount")
		s Score = result.Data("FinalScore")
		s Grade = result.Data("FinalGrade")
	}
	

	q:((ACondition="B")&&(BCount<=0)) ret
	q:((ACondition="C")&&(CCount<=0)) ret
	
    s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
    s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
    //s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
    s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
	s existed = ..CheckExistInResultByCode(AEpisodeID, ARuleCodes)
	if (existed=1)
	{
		s RuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
		for Ind = 1:1:$listlength(RuleCodes)
		{
		  s RuleCode = $listget(RuleCodes,Ind)
		  continue:(RuleCode = "")
			
		  s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		  continue:(RuleID = "")
		  s ResultID = ""
		  for {
			  
			s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_RuleID," "_AEpisodeID,ResultID))
			q:(ResultID = "")
			
			s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
			s flag=$d(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID))
		
			if (flag=10)
			{
				s DetailID=""
				    for
				    {
					   
					  s DetailID=$o(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,DetailID))
					  q:(DetailID="")
					  s ResultDetailID=ResultID_"||"_DetailID
					  s objResultDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(ResultDetailID)
					  s EntryID = objResultDetail.EntryDR
			  		  // 如果这个条目被删除了，则不参与计分
					  continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
					  s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(+EntryID)
			  		  continue:(objEntry = "")
			  		  s StructID = objEntry.StructDR
			  		  s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
			  		  continue:(objStruct = "")
			  		  s IsVeto=objEntry.IsVeto
			  		  s VetoGrade=""
			  		  s:(IsVeto="Y") VetoGrade=objEntry.VetoGrade
			  		  s StructName = objStruct.StandardName
			  		  s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
			  		  s ExamCount =  objResultDetail.ExamCount
			  		  s EntryScore = objResultDetail.EntryScore
			  		  s ResumeText = objResultDetail.ResumeText
			  		
			          s ^CacheTemp("QualityVetoReportDetail",AUniqueKey,AEpisodeID,$i(^CahceTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,EntryTitle,EntryScore,VetoGrade)
			    }		 
			}
			else
			{
			
				s ^CacheTemp("QualityVetoReportDetail",AUniqueKey,AEpisodeID,$i(^CahceTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,"","","")
			}	
     	 }
	   }
    }
	else
	{
			s ^CacheTemp("QualityVetoReportDetail",AUniqueKey,AEpisodeID,$i(^CahceTemp))=$lb(LocDesc,DoctorDesc,Name,RegNo,MRNo,AEpisodeID,Gender,AdmitDate,DischDate,"","","")
	}
	
	
		

	
	s ret=1
	q ret
}

/// w ##Class(EPRservice.Quality.BOQualityReport).ExportSummaryReport(AItemJS,AParameters)
ClassMethod ExportVetoReport(AItemJS As %Library.String = "", AParameters As %String) As %Status
{
	s LocIDs = $p(AParameters,"#",1)
	s StartDate = $p(AParameters,"#",2)
	s EndDate = $p(AParameters,"#",3)
	s RuleCodes = $p(AParameters,"#",4)
	
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BOQualityReport:GetQualityVetoReport")
	d ds.Execute(LocIDs,StartDate,EndDate,RuleCodes,"N")
	s StartRow = 8
	while(ds.Next())
	{
		s Department = ds.Data("Department")
		s Doctor = ds.Data("Doctor")
		s Count = ds.Data("Count")
		s VetoBCount = ds.Data("VetoBCount")
		s VetoBPercent = ds.Data("VetoBPercent")
		s VetoCCount = ds.Data("VetoCCount")
		s VetoCPercent =ds.Data("VetoCPercent")
		
		//登记号,病案号,姓名,出院日期,科室,病区,床号,医生
		s valCells = Department_$c(1)_Doctor_$c(1)_Count_$c(1)_VetoBCount_$c(1)_VetoBPercent_$c(1)_VetoCCount_$c(1)_VetoCPercent
	 	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count = Count + 1
		s StartRow = StartRow + 1
	}
	d ds.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	s valCells = "统计日期："_StartDate_" 至 "_EndDate
	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',5,1);"
	&javascript<#(retval)#>
}

/// Desc:导出手工评价明细
/// Creator:Candyxu
/// Createdate:2013-08-30
/// Input:AItemJS:"fillxlSheet",AParameters 查询明细所需参数
/// Output:excel列表
/// w ##Class(EPRservice.Quality.BOQualityReport).ExportQualityProfilerList("fillxlSheet","6##1###16/08/2012#22/08/2013#")
ClassMethod ExportQualityProfilerList(AItemJS As %Library.String = "", AParameters As %String) As %Status
{
	s LocID = $p(AParameters,"#",1)
	s WardID = $p(AParameters,"#",2)
	s RuleID = $p(AParameters,"#",3)
	s RegNo = $p(AParameters,"#",4)
	s APatientName = $p(AParameters,"#",5)
	s StartDate = $p(AParameters,"#",6)
	s EndDate = $p(AParameters,"#",7)
	s MedicareNo =  $p(AParameters,"#",8)
	
	s rs = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetQualityProfilerList")
	
	d rs.Execute(LocID,WardID,RuleID,RegNo,APatientName,StartDate,EndDate,MedicareNo)
	s StartRow = 4
	s count = 0
	s:($$$ISOK(rs)) count = 0
	While rs.Next()
	{
		s DisLocID = rs.Data("DisLocID")
		s LocDesc = rs.Data("LocDesc")  //出院科室
		s DisWardID = rs.Data("DisWardID")
		s WardDesc = rs.Data("WardDesc") // 出院病区
		s AdmDoctorID = rs.Data("AdmDoctorID")
		s DoctorDesc = rs.Data("DoctorDesc") //医生
		s RuleID = rs.Data("RuleID")
		s RuleDesc =rs.Data("RuleDesc")     //质控标准
		s StructID = rs.Data("StructID")
		s StructName = rs.Data("StructName")  //结构名称
		s EntryID = rs.Data("EntryID")
		s RegNo = rs.Data("RegNo")     //登记号
		s Name = rs.Data("Name")        //姓名
		s AdmitDate = rs.Data("AdmitDate")   //入院日期
		s DischDate = rs.Data("DischDate")   //出院日期
		s Recorder = rs.Data("Recorder")
		s MRNo = rs.Data("MRNo")          //病案号
		s ExamCount = rs.Data("ExamCount")  //触发次数
		s ResumeText = rs.Data("ResumeText")  //备注
		s valCells = Name_$c(1)_RegNo_$c(1)_MRNo_$c(1)_LocDesc_$c(1)_WardDesc_$c(1)_AdmitDate_$c(1)_DischDate_$c(1)_DoctorDesc_$c(1)_StructName_$c(1)_ExamCount_$c(1)_ResumeText
		s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s count = count +1
		s StartRow = StartRow + 1
	}
	d rs.Close()
	
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells = "统计日期："_StartDate_" 至 "_EndDate_"   合计:"_count_"份"
	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q 1
}

/// Creator:		Zuoxiang Xie  Modify by Candyxu 当科室为空时查所有科室记录
/// CreatDate:		2011-01-05
/// Description:	关于指定质控条目的统计查询报表，数据来源为出院患者自动任务结果集；
/// Table:       	
/// Input:			ALocIDs means current loc for query
/// 				AStartDate means the beginning of discharge date
/// 				AEndDate means the ending of discharge date
/// 				AEntryIDs means assigned entries, format like 1^2|3|4^5|6^7^8
/// 				AAnalysisFlag means whether with multi summary and percent
/// Output: 		Query result by your assigned condition
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetEntryCompositeReport","5^6^7^8^9^10^22^23^38","12/01/2011","18/01/2011","31604^31605^31606^42680^42678^31609^1000001^42679^31602^31603^31607^31608^43315^1000002^43302^42965^43303^31426|31427|31428|31429|31430|31431|42850^43323^31432","Y^Y")				
Query GetEntryCompositeReport(ALocIDs As %String, AStartDate As %String, AEndDate As %String, AEntryIDs As %String, AAnalysisFlag As %String = "") As %Query(ROWSPEC = "EntryIDs,LocID,Department,DocID,Doctor,StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Summary") [ SqlProc ]
{
}

ClassMethod GetEntryCompositeReportExecute(ByRef qHandle As %Binary, ALocIDs As %String, AStartDate As %String, AEndDate As %String, AEntryIDs As %String, AAnalysisFlag As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,uid,"")
	
	/* If you want some debug infomation, just open this closure notes, you should know where the ^CacheTempXZX stored at first
	s ^CacheTemp("EPRQuality","GetEntryCompositeReport","1ALocIDs")	 = ALocIDs
	s ^CacheTemp("EPRQuality","GetEntryCompositeReport","2AStartDate") = AStartDate
	s ^CacheTemp("EPRQuality","GetEntryCompositeReport","3AEndDate")	 = AEndDate
	s ^CacheTemp("EPRQuality","GetEntryCompositeReport","4AEntryIDs")	 = AEntryIDs
	s ^CacheTemp("EPRQuality","GetEntryCompositeReport","5AAnalysisFlag") = AAnalysisFlag
	*/
	
	// Just exit with no query condition
	q:(AStartDate = "")||(AEndDate = "")||(AEntryIDs = "") $$$OK	
	
	// Get loc list without empty elements  
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	// Get entrys list with empty elements
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"^","N")
	q:($listlength(lstEntryID) = 0) $$$OK
	
	s IsMultiSummary = $s($p(AAnalysisFlag,"^",1)'="":$p(AAnalysisFlag,"^",1),1:"N")
	s IsWithPercent	 = $s($p(AAnalysisFlag,"^",2)'="":$p(AAnalysisFlag,"^",2),1:"N")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
	s StartDate = StartDate - Days
	s EndDate	= EndDate - Days
	
	k ^CacheTemp("EPRQuality","EntryComposite",uid)
	
	s Number = 0
	s (Count,Summary) = 0
	s (Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20) = 0
	s (Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40) = 0
	
	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1) 
			
			// BuildSummaryList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildEntryCompositeList(EpisodeID,lstLocID,lstEntryID,uid)
			continue:(flag < 0)	
			s Number = Number + 1                                                                                         
		}	
	}
	
	if (Number = 0)
	{
		// 加一栏统计
		s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Summary)
		s ^CacheTemp(uid,1) = Data
		
		k ^CacheTemp("EPRQuality","EntryComposite",uid)
		
		q $$$OK	
	}
		
	s DisLocID = ""
	for	{ 
		s DisLocID = $o(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID)) 
		q:(DisLocID = "")
		
		
		s DocID = 0
		for { 
			s DocID = $o(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID)) 
			q:(DocID = "") 
			
			if (DocID '= "Other")
			{
				s DoctorDesc = $p($g(^CTPCP(+DocID)),"^",2)    			//CT_CareProv
				s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+DocID,0))  		//SS_User
				s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
			}
			else
			{
				s DoctorDesc = "未指定"	
			}
			
			// 初始化数据
			s (DocCount,DocSummary) = 0
			s (DocCount1,DocCount2,DocCount3,DocCount4,DocCount5,DocCount6,DocCount7,DocCount8,DocCount9,DocCount10,DocCount11,DocCount12,DocCount13,DocCount14,DocCount15,DocCount16,DocCount17,DocCount18,DocCount19,DocCount20) = 0
			s (DocCount21,DocCount22,DocCount23,DocCount24,DocCount25,DocCount26,DocCount27,DocCount28,DocCount29,DocCount30,DocCount31,DocCount32,DocCount33,DocCount34,DocCount35,DocCount36,DocCount37,DocCount38,DocCount39,DocCount40) = 0
		
			s DocCount = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,"Count"))		
			s:($listget(lstEntryID,1) '= "") DocCount1 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,1),"Count"))
			s:($listget(lstEntryID,2) '= "") DocCount2 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,2),"Count"))
			s:($listget(lstEntryID,3) '= "") DocCount3 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,3),"Count"))
			s:($listget(lstEntryID,4) '= "") DocCount4 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,4),"Count"))
			s:($listget(lstEntryID,5) '= "") DocCount5 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,5),"Count"))
			s:($listget(lstEntryID,6) '= "") DocCount6 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,6),"Count"))
			s:($listget(lstEntryID,7) '= "") DocCount7 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,7),"Count"))
			s:($listget(lstEntryID,8) '= "") DocCount8 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,8),"Count"))
			s:($listget(lstEntryID,9) '= "") DocCount9 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,9),"Count"))
			s:($listget(lstEntryID,10) '= "") DocCount10 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,10),"Count"))
			s:($listget(lstEntryID,11) '= "") DocCount11 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,11),"Count"))
			s:($listget(lstEntryID,12) '= "") DocCount12 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,12),"Count"))
			s:($listget(lstEntryID,13) '= "") DocCount13 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,13),"Count"))
			s:($listget(lstEntryID,14) '= "") DocCount14 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,14),"Count"))
			s:($listget(lstEntryID,15) '= "") DocCount15 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,15),"Count"))
			s:($listget(lstEntryID,16) '= "") DocCount16 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,16),"Count"))
			s:($listget(lstEntryID,17) '= "") DocCount17 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,17),"Count"))
			s:($listget(lstEntryID,18) '= "") DocCount18 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,18),"Count"))
			s:($listget(lstEntryID,19) '= "") DocCount18 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,19),"Count"))
			s:($listget(lstEntryID,20) '= "") DocCount20 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,20),"Count"))
			s:($listget(lstEntryID,21) '= "") DocCount21 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,21),"Count"))
			s:($listget(lstEntryID,22) '= "") DocCount22 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,22),"Count"))
			s:($listget(lstEntryID,23) '= "") DocCount23 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,23),"Count"))
			s:($listget(lstEntryID,24) '= "") DocCount24 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,24),"Count"))
			s:($listget(lstEntryID,25) '= "") DocCount25 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,25),"Count"))
			s:($listget(lstEntryID,26) '= "") DocCount26 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,26),"Count"))
			s:($listget(lstEntryID,27) '= "") DocCount27 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,27),"Count"))
			s:($listget(lstEntryID,28) '= "") DocCount28 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,28),"Count"))
			s:($listget(lstEntryID,29) '= "") DocCount29 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,29),"Count"))
			s:($listget(lstEntryID,30) '= "") DocCount30 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,30),"Count"))
			s:($listget(lstEntryID,31) '= "") DocCount31 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,31),"Count"))
			s:($listget(lstEntryID,32) '= "") DocCount32 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,32),"Count"))
			s:($listget(lstEntryID,33) '= "") DocCount33 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,33),"Count"))
			s:($listget(lstEntryID,34) '= "") DocCount34 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,34),"Count"))
			s:($listget(lstEntryID,35) '= "") DocCount35 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,35),"Count"))
			s:($listget(lstEntryID,36) '= "") DocCount36 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,36),"Count"))
			s:($listget(lstEntryID,37) '= "") DocCount37 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,37),"Count"))
			s:($listget(lstEntryID,38) '= "") DocCount38 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,38),"Count"))
			s:($listget(lstEntryID,39) '= "") DocCount39 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,39),"Count"))
			s:($listget(lstEntryID,40) '= "") DocCount40 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,DocID,$listget(lstEntryID,40),"Count"))
			s DocSummary = DocCount1+DocCount2+DocCount3+DocCount4+DocCount5+DocCount6+DocCount7+DocCount8+DocCount9+DocCount10+DocCount11+DocCount12+DocCount13+DocCount14+DocCount15+DocCount16+DocCount17+DocCount18+DocCount19+DocCount20+DocCount21+DocCount22+DocCount23+DocCount24+DocCount25+DocCount26+DocCount27+DocCount28+DocCount29+DocCount30+DocCount31+DocCount32+DocCount33+DocCount34+DocCount35+DocCount36+DocCount37+DocCount38+DocCount39+DocCount40
			
			if (IsWithPercent = "Y")
			{
				// 百分比计算
				s Doc1Percent = $s(DocCount1*100#DocCount=0:DocCount1*100/DocCount,1:$s(DocCount1*100/DocCount>=0.1:$j(DocCount1*100/DocCount,2,1),1:"<0.1"))
				s Doc2Percent = $s(DocCount2*100#DocCount=0:DocCount2*100/DocCount,1:$s(DocCount2*100/DocCount>=0.1:$j(DocCount2*100/DocCount,2,1),1:"<0.1"))
				s Doc3Percent = $s(DocCount3*100#DocCount=0:DocCount3*100/DocCount,1:$s(DocCount3*100/DocCount>=0.1:$j(DocCount3*100/DocCount,2,1),1:"<0.1"))
				s Doc4Percent = $s(DocCount4*100#DocCount=0:DocCount4*100/DocCount,1:$s(DocCount4*100/DocCount>=0.1:$j(DocCount4*100/DocCount,2,1),1:"<0.1"))
				s Doc5Percent = $s(DocCount5*100#DocCount=0:DocCount5*100/DocCount,1:$s(DocCount5*100/DocCount>=0.1:$j(DocCount5*100/DocCount,2,1),1:"<0.1"))
				s Doc6Percent = $s(DocCount6*100#DocCount=0:DocCount6*100/DocCount,1:$s(DocCount6*100/DocCount>=0.1:$j(DocCount6*100/DocCount,2,1),1:"<0.1"))
				s Doc7Percent = $s(DocCount7*100#DocCount=0:DocCount7*100/DocCount,1:$s(DocCount7*100/DocCount>=0.1:$j(DocCount7*100/DocCount,2,1),1:"<0.1"))
				s Doc8Percent = $s(DocCount8*100#DocCount=0:DocCount8*100/DocCount,1:$s(DocCount8*100/DocCount>=0.1:$j(DocCount8*100/DocCount,2,1),1:"<0.1"))
				s Doc9Percent = $s(DocCount9*100#DocCount=0:DocCount9*100/DocCount,1:$s(DocCount9*100/DocCount>=0.1:$j(DocCount9*100/DocCount,2,1),1:"<0.1"))
				s Doc10Percent = $s(DocCount10*100#DocCount=0:DocCount10*100/DocCount,1:$s(DocCount10*100/DocCount>=0.1:$j(DocCount10*100/DocCount,2,1),1:"<0.1"))
				s Doc11Percent = $s(DocCount11*100#DocCount=0:DocCount11*100/DocCount,1:$s(DocCount11*100/DocCount>=0.1:$j(DocCount11*100/DocCount,2,1),1:"<0.1"))
				s Doc12Percent = $s(DocCount12*100#DocCount=0:DocCount12*100/DocCount,1:$s(DocCount12*100/DocCount>=0.1:$j(DocCount12*100/DocCount,2,1),1:"<0.1"))
				s Doc13Percent = $s(DocCount13*100#DocCount=0:DocCount13*100/DocCount,1:$s(DocCount13*100/DocCount>=0.1:$j(DocCount13*100/DocCount,2,1),1:"<0.1"))
				s Doc14Percent = $s(DocCount14*100#DocCount=0:DocCount14*100/DocCount,1:$s(DocCount14*100/DocCount>=0.1:$j(DocCount14*100/DocCount,2,1),1:"<0.1"))
				s Doc15Percent = $s(DocCount15*100#DocCount=0:DocCount15*100/DocCount,1:$s(DocCount15*100/DocCount>=0.1:$j(DocCount15*100/DocCount,2,1),1:"<0.1"))
				s Doc16Percent = $s(DocCount16*100#DocCount=0:DocCount16*100/DocCount,1:$s(DocCount16*100/DocCount>=0.1:$j(DocCount16*100/DocCount,2,1),1:"<0.1"))
				s Doc17Percent = $s(DocCount17*100#DocCount=0:DocCount17*100/DocCount,1:$s(DocCount17*100/DocCount>=0.1:$j(DocCount17*100/DocCount,2,1),1:"<0.1"))
				s Doc18Percent = $s(DocCount18*100#DocCount=0:DocCount18*100/DocCount,1:$s(DocCount18*100/DocCount>=0.1:$j(DocCount18*100/DocCount,2,1),1:"<0.1"))
				s Doc19Percent = $s(DocCount19*100#DocCount=0:DocCount19*100/DocCount,1:$s(DocCount19*100/DocCount>=0.1:$j(DocCount19*100/DocCount,2,1),1:"<0.1"))
				s Doc20Percent = $s(DocCount20*100#DocCount=0:DocCount20*100/DocCount,1:$s(DocCount20*100/DocCount>=0.1:$j(DocCount20*100/DocCount,2,1),1:"<0.1"))
				s Doc21Percent = $s(DocCount21*100#DocCount=0:DocCount21*100/DocCount,1:$s(DocCount21*100/DocCount>=0.1:$j(DocCount21*100/DocCount,2,1),1:"<0.1"))
				s Doc22Percent = $s(DocCount22*100#DocCount=0:DocCount22*100/DocCount,1:$s(DocCount22*100/DocCount>=0.1:$j(DocCount22*100/DocCount,2,1),1:"<0.1"))
				s Doc23Percent = $s(DocCount23*100#DocCount=0:DocCount23*100/DocCount,1:$s(DocCount23*100/DocCount>=0.1:$j(DocCount23*100/DocCount,2,1),1:"<0.1"))
				s Doc24Percent = $s(DocCount24*100#DocCount=0:DocCount24*100/DocCount,1:$s(DocCount24*100/DocCount>=0.1:$j(DocCount24*100/DocCount,2,1),1:"<0.1"))
				s Doc25Percent = $s(DocCount25*100#DocCount=0:DocCount25*100/DocCount,1:$s(DocCount25*100/DocCount>=0.1:$j(DocCount25*100/DocCount,2,1),1:"<0.1"))
				s Doc26Percent = $s(DocCount26*100#DocCount=0:DocCount26*100/DocCount,1:$s(DocCount26*100/DocCount>=0.1:$j(DocCount26*100/DocCount,2,1),1:"<0.1"))
				s Doc27Percent = $s(DocCount27*100#DocCount=0:DocCount27*100/DocCount,1:$s(DocCount27*100/DocCount>=0.1:$j(DocCount27*100/DocCount,2,1),1:"<0.1"))
				s Doc28Percent = $s(DocCount28*100#DocCount=0:DocCount28*100/DocCount,1:$s(DocCount28*100/DocCount>=0.1:$j(DocCount28*100/DocCount,2,1),1:"<0.1"))
				s Doc29Percent = $s(DocCount29*100#DocCount=0:DocCount29*100/DocCount,1:$s(DocCount29*100/DocCount>=0.1:$j(DocCount29*100/DocCount,2,1),1:"<0.1"))
				s Doc30Percent = $s(DocCount30*100#DocCount=0:DocCount30*100/DocCount,1:$s(DocCount30*100/DocCount>=0.1:$j(DocCount30*100/DocCount,2,1),1:"<0.1"))
				s Doc31Percent = $s(DocCount31*100#DocCount=0:DocCount31*100/DocCount,1:$s(DocCount31*100/DocCount>=0.1:$j(DocCount31*100/DocCount,2,1),1:"<0.1"))
				s Doc32Percent = $s(DocCount32*100#DocCount=0:DocCount32*100/DocCount,1:$s(DocCount32*100/DocCount>=0.1:$j(DocCount32*100/DocCount,2,1),1:"<0.1"))
				s Doc33Percent = $s(DocCount33*100#DocCount=0:DocCount33*100/DocCount,1:$s(DocCount33*100/DocCount>=0.1:$j(DocCount33*100/DocCount,2,1),1:"<0.1"))
				s Doc34Percent = $s(DocCount34*100#DocCount=0:DocCount34*100/DocCount,1:$s(DocCount34*100/DocCount>=0.1:$j(DocCount34*100/DocCount,2,1),1:"<0.1"))
				s Doc35Percent = $s(DocCount35*100#DocCount=0:DocCount35*100/DocCount,1:$s(DocCount35*100/DocCount>=0.1:$j(DocCount35*100/DocCount,2,1),1:"<0.1"))
				s Doc36Percent = $s(DocCount36*100#DocCount=0:DocCount36*100/DocCount,1:$s(DocCount36*100/DocCount>=0.1:$j(DocCount36*100/DocCount,2,1),1:"<0.1"))
				s Doc37Percent = $s(DocCount37*100#DocCount=0:DocCount37*100/DocCount,1:$s(DocCount37*100/DocCount>=0.1:$j(DocCount37*100/DocCount,2,1),1:"<0.1"))
				s Doc38Percent = $s(DocCount38*100#DocCount=0:DocCount38*100/DocCount,1:$s(DocCount38*100/DocCount>=0.1:$j(DocCount38*100/DocCount,2,1),1:"<0.1"))
				s Doc39Percent = $s(DocCount39*100#DocCount=0:DocCount39*100/DocCount,1:$s(DocCount39*100/DocCount>=0.1:$j(DocCount39*100/DocCount,2,1),1:"<0.1"))
				s Doc40Percent = $s(DocCount40*100#DocCount=0:DocCount40*100/DocCount,1:$s(DocCount40*100/DocCount>=0.1:$j(DocCount40*100/DocCount,2,1),1:"<0.1"))
				
				s Doc1Result = DocCount1_" - "_Doc1Percent_"%",Doc2Result = DocCount2_" - "_Doc2Percent_"%",Doc3Result = DocCount3_" - "_Doc3Percent_"%",Doc4Result = DocCount4_" - "_Doc4Percent_"%"
				s Doc5Result = DocCount5_" - "_Doc5Percent_"%",Doc6Result = DocCount6_" - "_Doc6Percent_"%",Doc7Result = DocCount7_" - "_Doc7Percent_"%",Doc8Result = DocCount8_" - "_Doc8Percent_"%"
				s Doc9Result = DocCount9_" - "_Doc9Percent_"%",Doc10Result = DocCount10_" - "_Doc10Percent_"%",Doc11Result = DocCount11_" - "_Doc11Percent_"%",Doc12Result = DocCount12_" - "_Doc12Percent_"%"
				s Doc13Result = DocCount13_" - "_Doc13Percent_"%",Doc14Result = DocCount14_" - "_Doc14Percent_"%",Doc15Result = DocCount15_" - "_Doc15Percent_"%",Doc16Result = DocCount16_" - "_Doc16Percent_"%"
				s Doc17Result = DocCount17_" - "_Doc17Percent_"%",Doc18Result = DocCount18_" - "_Doc18Percent_"%",Doc19Result = DocCount19_" - "_Doc19Percent_"%",Doc20Result = DocCount20_" - "_Doc20Percent_"%"
				s Doc21Result = DocCount21_" - "_Doc21Percent_"%",Doc22Result = DocCount22_" - "_Doc22Percent_"%",Doc23Result = DocCount23_" - "_Doc23Percent_"%",Doc24Result = DocCount24_" - "_Doc24Percent_"%"
				s Doc25Result = DocCount25_" - "_Doc25Percent_"%",Doc26Result = DocCount26_" - "_Doc26Percent_"%",Doc27Result = DocCount27_" - "_Doc27Percent_"%",Doc28Result = DocCount28_" - "_Doc28Percent_"%"
				s Doc29Result = DocCount29_" - "_Doc29Percent_"%",Doc30Result = DocCount30_" - "_Doc30Percent_"%",Doc31Result = DocCount31_" - "_Doc31Percent_"%",Doc32Result = DocCount32_" - "_Doc32Percent_"%"
				s Doc33Result = DocCount33_" - "_Doc33Percent_"%",Doc34Result = DocCount34_" - "_Doc34Percent_"%",Doc35Result = DocCount35_" - "_Doc35Percent_"%",Doc36Result = DocCount36_" - "_Doc36Percent_"%"
				s Doc37Result = DocCount37_" - "_Doc37Percent_"%",Doc38Result = DocCount38_" - "_Doc38Percent_"%",Doc39Result = DocCount39_" - "_Doc39Percent_"%",Doc40Result = DocCount40_" - "_Doc40Percent_"%"
					
				// 医生总计
				s Data = $lb(AEntryIDs,DisLocID,"------",DocID,DoctorDesc,StartDate,EndDate,DocCount,Doc1Result,Doc2Result,Doc3Result,Doc4Result,Doc5Result,Doc6Result,Doc7Result,Doc8Result,Doc9Result,Doc10Result,Doc11Result,Doc12Result,Doc13Result,Doc14Result,Doc15Result,Doc16Result,Doc17Result,Doc18Result,Doc19Result,Doc20Result,Doc21Result,Doc22Result,Doc23Result,Doc24Result,Doc25Result,Doc26Result,Doc27Result,Doc28Result,Doc29Result,Doc30Result,Doc31Result,Doc32Result,Doc33Result,Doc34Result,Doc35Result,Doc36Result,Doc37Result,Doc38Result,Doc39Result,Doc40Result,DocSummary)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1
			}
			else
			{
				// 医生总计
				s Data = $lb(AEntryIDs,DisLocID,"------",DocID,DoctorDesc,StartDate,EndDate,DocCount,DocCount1,DocCount2,DocCount3,DocCount4,DocCount5,DocCount6,DocCount7,DocCount8,DocCount9,DocCount10,DocCount11,DocCount12,DocCount13,DocCount14,DocCount15,DocCount16,DocCount17,DocCount18,DocCount19,DocCount20,DocCount21,DocCount22,DocCount23,DocCount24,DocCount25,DocCount26,DocCount27,DocCount28,DocCount29,DocCount30,DocCount31,DocCount32,DocCount33,DocCount34,DocCount35,DocCount36,DocCount37,DocCount38,DocCount39,DocCount40,DocSummary)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1
			}
		}
		
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		// 初始化数据
		s (LocCount,LocSummary) = 0
		s (LocCount1,LocCount2,LocCount3,LocCount4,LocCount5,LocCount6,LocCount7,LocCount8,LocCount9,LocCount10,LocCount11,LocCount12,LocCount13,LocCount14,LocCount15,LocCount16,LocCount17,LocCount18,LocCount19,LocCount20) = 0
		s (LocCount21,LocCount22,LocCount23,LocCount24,LocCount25,LocCount26,LocCount27,LocCount28,LocCount29,LocCount30,LocCount31,LocCount32,LocCount33,LocCount34,LocCount35,LocCount36,LocCount37,LocCount38,LocCount39,LocCount40) = 0
		
		s LocCount = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,"Count"))
		s:($listget(lstEntryID,1) '= "") LocCount1 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,1),"Count"))
		s:($listget(lstEntryID,2) '= "") LocCount2 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,2),"Count"))
		s:($listget(lstEntryID,3) '= "") LocCount3 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,3),"Count"))
		s:($listget(lstEntryID,4) '= "") LocCount4 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,4),"Count"))
		s:($listget(lstEntryID,5) '= "") LocCount5 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,5),"Count"))
		s:($listget(lstEntryID,6) '= "") LocCount6 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,6),"Count"))
		s:($listget(lstEntryID,7) '= "") LocCount7 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,7),"Count"))
		s:($listget(lstEntryID,8) '= "") LocCount8 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,8),"Count"))
		s:($listget(lstEntryID,9) '= "") LocCount9 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,9),"Count"))
		s:($listget(lstEntryID,10) '= "") LocCount10 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,10),"Count"))
		s:($listget(lstEntryID,11) '= "") LocCount11 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,11),"Count"))
		s:($listget(lstEntryID,12) '= "") LocCount12 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,12),"Count"))
		s:($listget(lstEntryID,13) '= "") LocCount13 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,13),"Count"))
		s:($listget(lstEntryID,14) '= "") LocCount14 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,14),"Count"))
		s:($listget(lstEntryID,15) '= "") LocCount15 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,15),"Count"))
		s:($listget(lstEntryID,16) '= "") LocCount16 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,16),"Count"))
		s:($listget(lstEntryID,17) '= "") LocCount17 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,17),"Count"))
		s:($listget(lstEntryID,18) '= "") LocCount18 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,18),"Count"))
		s:($listget(lstEntryID,19) '= "") LocCount19 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,19),"Count"))
		s:($listget(lstEntryID,20) '= "") LocCount20 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,20),"Count"))
		s:($listget(lstEntryID,21) '= "") LocCount21 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,21),"Count"))
		s:($listget(lstEntryID,22) '= "") LocCount22 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,22),"Count"))
		s:($listget(lstEntryID,23) '= "") LocCount23 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,23),"Count"))
		s:($listget(lstEntryID,24) '= "") LocCount24 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,24),"Count"))
		s:($listget(lstEntryID,25) '= "") LocCount25 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,25),"Count"))
		s:($listget(lstEntryID,26) '= "") LocCount26 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,26),"Count"))
		s:($listget(lstEntryID,27) '= "") LocCount27 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,27),"Count"))
		s:($listget(lstEntryID,28) '= "") LocCount28 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,28),"Count"))
		s:($listget(lstEntryID,29) '= "") LocCount29 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,29),"Count"))
		s:($listget(lstEntryID,30) '= "") LocCount30 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,30),"Count"))
		s:($listget(lstEntryID,31) '= "") LocCount31 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,31),"Count"))
		s:($listget(lstEntryID,32) '= "") LocCount32 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,32),"Count"))
		s:($listget(lstEntryID,33) '= "") LocCount33 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,33),"Count"))
		s:($listget(lstEntryID,34) '= "") LocCount34 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,34),"Count"))
		s:($listget(lstEntryID,35) '= "") LocCount35 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,35),"Count"))
		s:($listget(lstEntryID,36) '= "") LocCount36 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,36),"Count"))
		s:($listget(lstEntryID,37) '= "") LocCount37 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,37),"Count"))
		s:($listget(lstEntryID,38) '= "") LocCount38 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,38),"Count"))
		s:($listget(lstEntryID,39) '= "") LocCount39 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,39),"Count"))
		s:($listget(lstEntryID,40) '= "") LocCount40 = +$g(^CacheTemp("EPRQuality","EntryComposite",uid,DisLocID,0,$listget(lstEntryID,40),"Count"))
		s LocSummary = LocCount1+LocCount2+LocCount3+LocCount4+LocCount5+LocCount6+LocCount7+LocCount8+LocCount9+LocCount10+LocCount11+LocCount12+LocCount13+LocCount14+LocCount15+LocCount16+LocCount17+LocCount18+LocCount19+LocCount20+LocCount21+LocCount22+LocCount23+LocCount24+LocCount25+LocCount26+LocCount27+LocCount28+LocCount29+LocCount30+LocCount31+LocCount32+LocCount33+LocCount34+LocCount35+LocCount36+LocCount37+LocCount38+LocCount39+LocCount40
		
		if (IsWithPercent = "Y")
		{
			// 百分比计算
			s Loc1Percent = $s(LocCount1*100#LocCount=0:LocCount1*100/LocCount,1:$s(LocCount1*100/LocCount>=0.1:$j(LocCount1*100/LocCount,2,1),1:"<0.1"))
			s Loc2Percent = $s(LocCount2*100#LocCount=0:LocCount2*100/LocCount,1:$s(LocCount2*100/LocCount>=0.1:$j(LocCount2*100/LocCount,2,1),1:"<0.1"))
			s Loc3Percent = $s(LocCount3*100#LocCount=0:LocCount3*100/LocCount,1:$s(LocCount3*100/LocCount>=0.1:$j(LocCount3*100/LocCount,2,1),1:"<0.1"))
			s Loc4Percent = $s(LocCount4*100#LocCount=0:LocCount4*100/LocCount,1:$s(LocCount4*100/LocCount>=0.1:$j(LocCount4*100/LocCount,2,1),1:"<0.1"))
			s Loc5Percent = $s(LocCount5*100#LocCount=0:LocCount5*100/LocCount,1:$s(LocCount5*100/LocCount>=0.1:$j(LocCount5*100/LocCount,2,1),1:"<0.1"))
			s Loc6Percent = $s(LocCount6*100#LocCount=0:LocCount6*100/LocCount,1:$s(LocCount6*100/LocCount>=0.1:$j(LocCount6*100/LocCount,2,1),1:"<0.1"))
			s Loc7Percent = $s(LocCount7*100#LocCount=0:LocCount7*100/LocCount,1:$s(LocCount7*100/LocCount>=0.1:$j(LocCount7*100/LocCount,2,1),1:"<0.1"))
			s Loc8Percent = $s(LocCount8*100#LocCount=0:LocCount8*100/LocCount,1:$s(LocCount8*100/LocCount>=0.1:$j(LocCount8*100/LocCount,2,1),1:"<0.1"))
			s Loc9Percent = $s(LocCount9*100#LocCount=0:LocCount9*100/LocCount,1:$s(LocCount9*100/LocCount>=0.1:$j(LocCount9*100/LocCount,2,1),1:"<0.1"))
			s Loc10Percent = $s(LocCount10*100#LocCount=0:LocCount10*100/LocCount,1:$s(LocCount10*100/LocCount>=0.1:$j(LocCount10*100/LocCount,2,1),1:"<0.1"))
			s Loc11Percent = $s(LocCount11*100#LocCount=0:LocCount11*100/LocCount,1:$s(LocCount11*100/LocCount>=0.1:$j(LocCount11*100/LocCount,2,1),1:"<0.1"))
			s Loc12Percent = $s(LocCount12*100#LocCount=0:LocCount12*100/LocCount,1:$s(LocCount12*100/LocCount>=0.1:$j(LocCount12*100/LocCount,2,1),1:"<0.1"))
			s Loc13Percent = $s(LocCount13*100#LocCount=0:LocCount13*100/LocCount,1:$s(LocCount13*100/LocCount>=0.1:$j(LocCount13*100/LocCount,2,1),1:"<0.1"))
			s Loc14Percent = $s(LocCount14*100#LocCount=0:LocCount14*100/LocCount,1:$s(LocCount14*100/LocCount>=0.1:$j(LocCount14*100/LocCount,2,1),1:"<0.1"))
			s Loc15Percent = $s(LocCount15*100#LocCount=0:LocCount15*100/LocCount,1:$s(LocCount15*100/LocCount>=0.1:$j(LocCount15*100/LocCount,2,1),1:"<0.1"))
			s Loc16Percent = $s(LocCount16*100#LocCount=0:LocCount16*100/LocCount,1:$s(LocCount16*100/LocCount>=0.1:$j(LocCount16*100/LocCount,2,1),1:"<0.1"))
			s Loc17Percent = $s(LocCount17*100#LocCount=0:LocCount17*100/LocCount,1:$s(LocCount17*100/LocCount>=0.1:$j(LocCount17*100/LocCount,2,1),1:"<0.1"))
			s Loc18Percent = $s(LocCount18*100#LocCount=0:LocCount18*100/LocCount,1:$s(LocCount18*100/LocCount>=0.1:$j(LocCount18*100/LocCount,2,1),1:"<0.1"))
			s Loc19Percent = $s(LocCount19*100#LocCount=0:LocCount19*100/LocCount,1:$s(LocCount19*100/LocCount>=0.1:$j(LocCount19*100/LocCount,2,1),1:"<0.1"))
			s Loc20Percent = $s(LocCount20*100#LocCount=0:LocCount20*100/LocCount,1:$s(LocCount20*100/LocCount>=0.1:$j(LocCount20*100/LocCount,2,1),1:"<0.1"))
			s Loc21Percent = $s(LocCount21*100#LocCount=0:LocCount21*100/LocCount,1:$s(LocCount21*100/LocCount>=0.1:$j(LocCount21*100/LocCount,2,1),1:"<0.1"))
			s Loc22Percent = $s(LocCount22*100#LocCount=0:LocCount22*100/LocCount,1:$s(LocCount22*100/LocCount>=0.1:$j(LocCount22*100/LocCount,2,1),1:"<0.1"))
			s Loc23Percent = $s(LocCount23*100#LocCount=0:LocCount23*100/LocCount,1:$s(LocCount23*100/LocCount>=0.1:$j(LocCount23*100/LocCount,2,1),1:"<0.1"))
			s Loc24Percent = $s(LocCount24*100#LocCount=0:LocCount24*100/LocCount,1:$s(LocCount24*100/LocCount>=0.1:$j(LocCount24*100/LocCount,2,1),1:"<0.1"))
			s Loc25Percent = $s(LocCount25*100#LocCount=0:LocCount25*100/LocCount,1:$s(LocCount25*100/LocCount>=0.1:$j(LocCount25*100/LocCount,2,1),1:"<0.1"))
			s Loc26Percent = $s(LocCount26*100#LocCount=0:LocCount26*100/LocCount,1:$s(LocCount26*100/LocCount>=0.1:$j(LocCount26*100/LocCount,2,1),1:"<0.1"))
			s Loc27Percent = $s(LocCount27*100#LocCount=0:LocCount27*100/LocCount,1:$s(LocCount27*100/LocCount>=0.1:$j(LocCount27*100/LocCount,2,1),1:"<0.1"))
			s Loc28Percent = $s(LocCount28*100#LocCount=0:LocCount28*100/LocCount,1:$s(LocCount28*100/LocCount>=0.1:$j(LocCount28*100/LocCount,2,1),1:"<0.1"))
			s Loc29Percent = $s(LocCount29*100#LocCount=0:LocCount29*100/LocCount,1:$s(LocCount29*100/LocCount>=0.1:$j(LocCount29*100/LocCount,2,1),1:"<0.1"))
			s Loc30Percent = $s(LocCount30*100#LocCount=0:LocCount30*100/LocCount,1:$s(LocCount30*100/LocCount>=0.1:$j(LocCount30*100/LocCount,2,1),1:"<0.1"))
			s Loc31Percent = $s(LocCount31*100#LocCount=0:LocCount31*100/LocCount,1:$s(LocCount31*100/LocCount>=0.1:$j(LocCount31*100/LocCount,2,1),1:"<0.1"))
			s Loc32Percent = $s(LocCount32*100#LocCount=0:LocCount32*100/LocCount,1:$s(LocCount32*100/LocCount>=0.1:$j(LocCount32*100/LocCount,2,1),1:"<0.1"))
			s Loc33Percent = $s(LocCount33*100#LocCount=0:LocCount33*100/LocCount,1:$s(LocCount33*100/LocCount>=0.1:$j(LocCount33*100/LocCount,2,1),1:"<0.1"))
			s Loc34Percent = $s(LocCount34*100#LocCount=0:LocCount34*100/LocCount,1:$s(LocCount34*100/LocCount>=0.1:$j(LocCount34*100/LocCount,2,1),1:"<0.1"))
			s Loc35Percent = $s(LocCount35*100#LocCount=0:LocCount35*100/LocCount,1:$s(LocCount35*100/LocCount>=0.1:$j(LocCount35*100/LocCount,2,1),1:"<0.1"))
			s Loc36Percent = $s(LocCount36*100#LocCount=0:LocCount36*100/LocCount,1:$s(LocCount36*100/LocCount>=0.1:$j(LocCount36*100/LocCount,2,1),1:"<0.1"))
			s Loc37Percent = $s(LocCount37*100#LocCount=0:LocCount37*100/LocCount,1:$s(LocCount37*100/LocCount>=0.1:$j(LocCount37*100/LocCount,2,1),1:"<0.1"))
			s Loc38Percent = $s(LocCount38*100#LocCount=0:LocCount38*100/LocCount,1:$s(LocCount38*100/LocCount>=0.1:$j(LocCount38*100/LocCount,2,1),1:"<0.1"))
			s Loc39Percent = $s(LocCount39*100#LocCount=0:LocCount39*100/LocCount,1:$s(LocCount39*100/LocCount>=0.1:$j(LocCount39*100/LocCount,2,1),1:"<0.1"))
			s Loc40Percent = $s(LocCount40*100#LocCount=0:LocCount40*100/LocCount,1:$s(LocCount40*100/LocCount>=0.1:$j(LocCount40*100/LocCount,2,1),1:"<0.1"))
			
			s Loc1Result = LocCount1_" - "_Loc1Percent_"%",Loc2Result = LocCount2_" - "_Loc2Percent_"%",Loc3Result = LocCount3_" - "_Loc3Percent_"%",Loc4Result = LocCount4_" - "_Loc4Percent_"%"
			s Loc5Result = LocCount5_" - "_Loc5Percent_"%",Loc6Result = LocCount6_" - "_Loc6Percent_"%",Loc7Result = LocCount7_" - "_Loc7Percent_"%",Loc8Result = LocCount8_" - "_Loc8Percent_"%"
			s Loc9Result = LocCount9_" - "_Loc9Percent_"%",Loc10Result = LocCount10_" - "_Loc10Percent_"%",Loc11Result = LocCount11_" - "_Loc11Percent_"%",Loc12Result = LocCount12_" - "_Loc12Percent_"%"
			s Loc13Result = LocCount13_" - "_Loc13Percent_"%",Loc14Result = LocCount14_" - "_Loc14Percent_"%",Loc15Result = LocCount15_" - "_Loc15Percent_"%",Loc16Result = LocCount16_" - "_Loc16Percent_"%"
			s Loc17Result = LocCount17_" - "_Loc17Percent_"%",Loc18Result = LocCount18_" - "_Loc18Percent_"%",Loc19Result = LocCount19_" - "_Loc19Percent_"%",Loc20Result = LocCount20_" - "_Loc20Percent_"%"
			s Loc21Result = LocCount21_" - "_Loc21Percent_"%",Loc22Result = LocCount22_" - "_Loc22Percent_"%",Loc23Result = LocCount23_" - "_Loc23Percent_"%",Loc24Result = LocCount24_" - "_Loc24Percent_"%"
			s Loc25Result = LocCount25_" - "_Loc25Percent_"%",Loc26Result = LocCount26_" - "_Loc26Percent_"%",Loc27Result = LocCount27_" - "_Loc27Percent_"%",Loc28Result = LocCount28_" - "_Loc28Percent_"%"
			s Loc29Result = LocCount29_" - "_Loc29Percent_"%",Loc30Result = LocCount30_" - "_Loc30Percent_"%",Loc31Result = LocCount31_" - "_Loc31Percent_"%",Loc32Result = LocCount32_" - "_Loc32Percent_"%"
			s Loc33Result = LocCount33_" - "_Loc33Percent_"%",Loc34Result = LocCount34_" - "_Loc34Percent_"%",Loc35Result = LocCount35_" - "_Loc35Percent_"%",Loc36Result = LocCount36_" - "_Loc36Percent_"%"
			s Loc37Result = LocCount37_" - "_Loc37Percent_"%",Loc38Result = LocCount38_" - "_Loc38Percent_"%",Loc39Result = LocCount39_" - "_Loc39Percent_"%",Loc40Result = LocCount40_" - "_Loc40Percent_"%"
			
			// 科室总计
			s Data = $lb(AEntryIDs,DisLocID,LocDesc,"","小计",StartDate,EndDate,LocCount,Loc1Result,Loc2Result,Loc3Result,Loc4Result,Loc5Result,Loc6Result,Loc7Result,Loc8Result,Loc9Result,Loc10Result,Loc11Result,Loc12Result,Loc13Result,Loc14Result,Loc15Result,Loc16Result,Loc17Result,Loc18Result,Loc19Result,Loc20Result,Loc21Result,Loc22Result,Loc23Result,Loc24Result,Loc25Result,Loc26Result,Loc27Result,Loc28Result,Loc29Result,Loc30Result,Loc31Result,Loc32Result,Loc33Result,Loc34Result,Loc35Result,Loc36Result,Loc37Result,Loc38Result,Loc39Result,Loc40Result,LocSummary)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
		}
		else
		{
			// 科室总计
			s Data = $lb(AEntryIDs,DisLocID,LocDesc,"","小计",StartDate,EndDate,LocCount,LocCount1,LocCount2,LocCount3,LocCount4,LocCount5,LocCount6,LocCount7,LocCount8,LocCount9,LocCount10,LocCount11,LocCount12,LocCount13,LocCount14,LocCount15,LocCount16,LocCount17,LocCount18,LocCount19,LocCount20,LocCount21,LocCount22,LocCount23,LocCount24,LocCount25,LocCount26,LocCount27,LocCount28,LocCount29,LocCount30,LocCount31,LocCount32,LocCount33,LocCount34,LocCount35,LocCount36,LocCount37,LocCount38,LocCount39,LocCount40,LocSummary)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
		}
		

		
		s Count = Count + LocCount
		s Count1 = Count1 + LocCount1, Count2 = Count2 + LocCount2, Count3 = Count3 + LocCount3, Count4 = Count4 + LocCount4, Count5 = Count5 + LocCount5
		s Count6 = Count6 + LocCount6, Count7 = Count7 + LocCount7, Count8 = Count8 + LocCount8, Count9 = Count9 + LocCount9, Count10 = Count10 + LocCount10
		s Count11 = Count11 + LocCount11, Count12 = Count12 + LocCount12, Count13 = Count13 + LocCount13, Count14 = Count14 + LocCount14, Count15 = Count15 + LocCount15
		s Count16 = Count16 + LocCount16, Count17 = Count17 + LocCount17, Count18 = Count18 + LocCount18, Count19 = Count19 + LocCount19, Count20 = Count20 + LocCount20
		s Count21 = Count21 + LocCount21, Count22 = Count22 + LocCount22, Count23 = Count23 + LocCount23, Count24 = Count24 + LocCount24, Count25 = Count25 + LocCount25
		s Count26 = Count26 + LocCount26, Count27 = Count27 + LocCount27, Count28 = Count28 + LocCount28, Count29 = Count29 + LocCount29, Count30 = Count30 + LocCount30
		s Count31 = Count31 + LocCount31, Count32 = Count32 + LocCount32, Count33 = Count33 + LocCount33, Count34 = Count34 + LocCount34, Count35 = Count35 + LocCount35
		s Count36 = Count36 + LocCount36, Count37 = Count37 + LocCount37, Count38 = Count38 + LocCount38, Count39 = Count39 + LocCount39, Count40 = Count40 + LocCount40
		s Summary = Count1+Count2+Count3+Count4+Count5+Count6+Count7+Count8+Count9+Count10+Count11+Count12+Count13+Count14+Count15+Count16+Count17+Count18+Count19+Count20+Count21+Count22+Count23+Count24+Count25+Count26+Count27+Count28+Count29+Count30+Count31+Count32+Count33+Count34+Count35+Count36+Count37+Count38+Count39+Count40
	}
	
	if (IsWithPercent = "Y")
	{
		// 百分比计算
		s Count1Percent = $s(Count1*100#Count=0:Count1*100/Count,1:$s(Count1*100/Count>=0.1:$j(Count1*100/Count,2,1),1:"<0.1"))
		s Count2Percent = $s(Count2*100#Count=0:Count2*100/Count,1:$s(Count2*100/Count>=0.1:$j(Count2*100/Count,2,1),1:"<0.1"))
		s Count3Percent = $s(Count3*100#Count=0:Count3*100/Count,1:$s(Count3*100/Count>=0.1:$j(Count3*100/Count,2,1),1:"<0.1"))
		s Count4Percent = $s(Count4*100#Count=0:Count4*100/Count,1:$s(Count4*100/Count>=0.1:$j(Count4*100/Count,2,1),1:"<0.1"))
		s Count5Percent = $s(Count5*100#Count=0:Count5*100/Count,1:$s(Count5*100/Count>=0.1:$j(Count5*100/Count,2,1),1:"<0.1"))
		s Count6Percent = $s(Count6*100#Count=0:Count6*100/Count,1:$s(Count6*100/Count>=0.1:$j(Count6*100/Count,2,1),1:"<0.1"))
		s Count7Percent = $s(Count7*100#Count=0:Count7*100/Count,1:$s(Count7*100/Count>=0.1:$j(Count7*100/Count,2,1),1:"<0.1"))
		s Count8Percent = $s(Count8*100#Count=0:Count8*100/Count,1:$s(Count8*100/Count>=0.1:$j(Count8*100/Count,2,1),1:"<0.1"))
		s Count9Percent = $s(Count9*100#Count=0:Count9*100/Count,1:$s(Count9*100/Count>=0.1:$j(Count9*100/Count,2,1),1:"<0.1"))
		s Count10Percent = $s(Count10*100#Count=0:Count10*100/Count,1:$s(Count10*100/Count>=0.1:$j(Count10*100/Count,2,1),1:"<0.1"))
		s Count11Percent = $s(Count11*100#Count=0:Count11*100/Count,1:$s(Count11*100/Count>=0.1:$j(Count11*100/Count,2,1),1:"<0.1"))
		s Count12Percent = $s(Count12*100#Count=0:Count12*100/Count,1:$s(Count12*100/Count>=0.1:$j(Count12*100/Count,2,1),1:"<0.1"))
		s Count13Percent = $s(Count13*100#Count=0:Count13*100/Count,1:$s(Count13*100/Count>=0.1:$j(Count13*100/Count,2,1),1:"<0.1"))
		s Count14Percent = $s(Count14*100#Count=0:Count14*100/Count,1:$s(Count14*100/Count>=0.1:$j(Count14*100/Count,2,1),1:"<0.1"))
		s Count15Percent = $s(Count15*100#Count=0:Count15*100/Count,1:$s(Count15*100/Count>=0.1:$j(Count15*100/Count,2,1),1:"<0.1"))
		s Count16Percent = $s(Count16*100#Count=0:Count16*100/Count,1:$s(Count16*100/Count>=0.1:$j(Count16*100/Count,2,1),1:"<0.1"))
		s Count17Percent = $s(Count17*100#Count=0:Count17*100/Count,1:$s(Count17*100/Count>=0.1:$j(Count17*100/Count,2,1),1:"<0.1"))
		s Count18Percent = $s(Count18*100#Count=0:Count18*100/Count,1:$s(Count18*100/Count>=0.1:$j(Count18*100/Count,2,1),1:"<0.1"))
		s Count19Percent = $s(Count19*100#Count=0:Count19*100/Count,1:$s(Count19*100/Count>=0.1:$j(Count19*100/Count,2,1),1:"<0.1"))
		s Count20Percent = $s(Count20*100#Count=0:Count20*100/Count,1:$s(Count20*100/Count>=0.1:$j(Count20*100/Count,2,1),1:"<0.1"))
		s Count21Percent = $s(Count21*100#Count=0:Count21*100/Count,1:$s(Count21*100/Count>=0.1:$j(Count21*100/Count,2,1),1:"<0.1"))
		s Count22Percent = $s(Count22*100#Count=0:Count22*100/Count,1:$s(Count22*100/Count>=0.1:$j(Count22*100/Count,2,1),1:"<0.1"))
		s Count23Percent = $s(Count23*100#Count=0:Count23*100/Count,1:$s(Count23*100/Count>=0.1:$j(Count23*100/Count,2,1),1:"<0.1"))
		s Count24Percent = $s(Count24*100#Count=0:Count24*100/Count,1:$s(Count24*100/Count>=0.1:$j(Count24*100/Count,2,1),1:"<0.1"))
		s Count25Percent = $s(Count25*100#Count=0:Count25*100/Count,1:$s(Count25*100/Count>=0.1:$j(Count25*100/Count,2,1),1:"<0.1"))
		s Count26Percent = $s(Count26*100#Count=0:Count26*100/Count,1:$s(Count26*100/Count>=0.1:$j(Count26*100/Count,2,1),1:"<0.1"))
		s Count27Percent = $s(Count27*100#Count=0:Count27*100/Count,1:$s(Count27*100/Count>=0.1:$j(Count27*100/Count,2,1),1:"<0.1"))
		s Count28Percent = $s(Count28*100#Count=0:Count28*100/Count,1:$s(Count28*100/Count>=0.1:$j(Count28*100/Count,2,1),1:"<0.1"))
		s Count29Percent = $s(Count29*100#Count=0:Count29*100/Count,1:$s(Count29*100/Count>=0.1:$j(Count29*100/Count,2,1),1:"<0.1"))
		s Count30Percent = $s(Count30*100#Count=0:Count30*100/Count,1:$s(Count30*100/Count>=0.1:$j(Count30*100/Count,2,1),1:"<0.1"))
		s Count31Percent = $s(Count31*100#Count=0:Count31*100/Count,1:$s(Count31*100/Count>=0.1:$j(Count31*100/Count,2,1),1:"<0.1"))
		s Count32Percent = $s(Count32*100#Count=0:Count32*100/Count,1:$s(Count32*100/Count>=0.1:$j(Count32*100/Count,2,1),1:"<0.1"))
		s Count33Percent = $s(Count33*100#Count=0:Count33*100/Count,1:$s(Count33*100/Count>=0.1:$j(Count33*100/Count,2,1),1:"<0.1"))
		s Count34Percent = $s(Count34*100#Count=0:Count34*100/Count,1:$s(Count34*100/Count>=0.1:$j(Count34*100/Count,2,1),1:"<0.1"))
		s Count35Percent = $s(Count35*100#Count=0:Count35*100/Count,1:$s(Count35*100/Count>=0.1:$j(Count35*100/Count,2,1),1:"<0.1"))
		s Count36Percent = $s(Count36*100#Count=0:Count36*100/Count,1:$s(Count36*100/Count>=0.1:$j(Count36*100/Count,2,1),1:"<0.1"))
		s Count37Percent = $s(Count37*100#Count=0:Count37*100/Count,1:$s(Count37*100/Count>=0.1:$j(Count37*100/Count,2,1),1:"<0.1"))
		s Count38Percent = $s(Count38*100#Count=0:Count38*100/Count,1:$s(Count38*100/Count>=0.1:$j(Count38*100/Count,2,1),1:"<0.1"))
		s Count39Percent = $s(Count39*100#Count=0:Count39*100/Count,1:$s(Count39*100/Count>=0.1:$j(Count39*100/Count,2,1),1:"<0.1"))
		s Count40Percent = $s(Count40*100#Count=0:Count40*100/Count,1:$s(Count40*100/Count>=0.1:$j(Count40*100/Count,2,1),1:"<0.1"))
		
		s Count1Result = Count1_" - "_Count1Percent_"%",Count2Result = Count2_" - "_Count2Percent_"%",Count3Result = Count3_" - "_Count3Percent_"%",Count4Result = Count4_" - "_Count4Percent_"%"
		s Count5Result = Count5_" - "_Count5Percent_"%",Count6Result = Count6_" - "_Count6Percent_"%",Count7Result = Count7_" - "_Count7Percent_"%",Count8Result = Count8_" - "_Count8Percent_"%"
		s Count9Result = Count9_" - "_Count9Percent_"%",Count10Result = Count10_" - "_Count10Percent_"%",Count11Result = Count11_" - "_Count11Percent_"%",Count12Result = Count12_" - "_Count12Percent_"%"
		s Count13Result = Count13_" - "_Count13Percent_"%",Count14Result = Count14_" - "_Count14Percent_"%",Count15Result = Count15_" - "_Count15Percent_"%",Count16Result = Count16_" - "_Count16Percent_"%"
		s Count17Result = Count17_" - "_Count17Percent_"%",Count18Result = Count18_" - "_Count18Percent_"%",Count19Result = Count19_" - "_Count19Percent_"%",Count20Result = Count20_" - "_Count20Percent_"%"
		s Count21Result = Count21_" - "_Count21Percent_"%",Count22Result = Count22_" - "_Count22Percent_"%",Count23Result = Count23_" - "_Count23Percent_"%",Count24Result = Count24_" - "_Count24Percent_"%"
		s Count25Result = Count25_" - "_Count25Percent_"%",Count26Result = Count26_" - "_Count26Percent_"%",Count27Result = Count27_" - "_Count27Percent_"%",Count28Result = Count28_" - "_Count28Percent_"%"
		s Count29Result = Count29_" - "_Count29Percent_"%",Count30Result = Count30_" - "_Count30Percent_"%",Count31Result = Count31_" - "_Count31Percent_"%",Count32Result = Count32_" - "_Count32Percent_"%"
		s Count33Result = Count33_" - "_Count33Percent_"%",Count34Result = Count34_" - "_Count34Percent_"%",Count35Result = Count35_" - "_Count35Percent_"%",Count36Result = Count36_" - "_Count36Percent_"%"
		s Count37Result = Count37_" - "_Count37Percent_"%",Count38Result = Count38_" - "_Count38Percent_"%",Count39Result = Count39_" - "_Count39Percent_"%",Count40Result = Count40_" - "_Count40Percent_"%"
		
		// 最后一栏的统计
		if ($zcvt(IsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data =  $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1Result,Count2Result,Count3Result,Count4Result,Count5Result,Count6Result,Count7Result,Count8Result,Count9Result,Count10Result,Count11Result,Count12Result,Count13Result,Count14Result,Count15Result,Count16Result,Count17Result,Count18Result,Count19Result,Count20Result,Count21Result,Count22Result,Count23Result,Count24Result,Count25Result,Count26Result,Count27Result,Count28Result,Count29Result,Count30Result,Count31Result,Count32Result,Count33Result,Count34Result,Count35Result,Count36Result,Count37Result,Count38Result,Count39Result,Count40Result,Summary)
			s ^CacheTemp(uid,ind) = Data
		}
		
		// 给第一栏也加上合计栏
		s Data =  $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1Result,Count2Result,Count3Result,Count4Result,Count5Result,Count6Result,Count7Result,Count8Result,Count9Result,Count10Result,Count11Result,Count12Result,Count13Result,Count14Result,Count15Result,Count16Result,Count17Result,Count18Result,Count19Result,Count20Result,Count21Result,Count22Result,Count23Result,Count24Result,Count25Result,Count26Result,Count27Result,Count28Result,Count29Result,Count30Result,Count31Result,Count32Result,Count33Result,Count34Result,Count35Result,Count36Result,Count37Result,Count38Result,Count39Result,Count40Result,Summary)
		s ^CacheTemp(uid,1) = Data
	}
	else
	{		
		// 最后一栏的统计
		if ($zcvt(IsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Summary)
			s ^CacheTemp(uid,ind) = Data
		}
		
		// 给第一栏也加上合计栏
		s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Summary)
		s ^CacheTemp(uid,1) = Data
	}
	
	k ^CacheTemp("EPRQuality","EntryComposite",uid)
	
	q $$$OK
}

ClassMethod BuildEntryCompositeList(AEpisodeID As %String, AListLocID As %List, AListEntryID As %List, AUniqueKey As %String) As %Integer
{
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret		//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "Other"
	
	// 记录科室总病历分数
	s ^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,0,"Count") = (+$g(^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,0,"Count"))) + 1
	
	// 记录医生总病历分数
	s ^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,AdmDoctorID,"Count"))) + 1
	
	for i = 1:1:$listlength(AListEntryID)
	{
		//每一列有可能还是一组Entry
		s EntrySet = $listget(AListEntryID,i)
		continue:(EntrySet = "")	
		
		s lstEntries = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntrySet,"|")
		for j = 1:1:$listlength(lstEntries)
		{
			s EntryID = $listget(lstEntries,j)
			continue:(EntryID = "")

			s ResultID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,""))
			if (+ResultID > 0)
			{
				// 记录科室各质控项目份数
				s ^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,0,EntrySet,"Count") = (+$g(^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,0,EntrySet,"Count"))) + 1	
				
				// 记录医生各质控项目份数
				s ^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,AdmDoctorID,EntrySet,"Count") = (+$g(^CacheTemp("EPRQuality","EntryComposite",AUniqueKey,DisLocID,AdmDoctorID,EntrySet,"Count"))) + 1				
				
				// 一个项目组合只记录一次
				q
			}
		}
	}
	
	s ret = 1
	q ret
}

ClassMethod GetEntryCompositeReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEntryCompositeReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEntryCompositeReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEntryCompositeReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##Class(EPRservice.Quality.BOQualityReport).ExportSummaryReport(AItemJS,AParameters)
ClassMethod ExportEntryCompositeReport(AItemJS As %String = "", AParameters As %String) As %Status
{
	s LocIDs = $p(AParameters,"#",1)
	s StartDate = $p(AParameters,"#",2)
	s EndDate = $p(AParameters,"#",3)
	s EntryIDs = $p(AParameters,"#",4)
	s AnalysisFlag = $p(AParameters,"#",5)
	
	//s IsMultiSummary = $p(AnalysisFlag,"^",1)
	s IsWithPercent = $p(AnalysisFlag,"^",2)
	s:(IsWithPercent = "") IsWithPercent = "N"
	s ExportPrintFlag = "N^"_IsWithPercent
	
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntryIDs,"^","N")
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEntryCompositeReport")
	d ds.Execute(LocIDs,StartDate,EndDate,EntryIDs,ExportPrintFlag)
	
	s StartRow = 8
	while(ds.Next())
	{
		s Department = ds.Data("Department")
		s Doctor = ds.Data("Doctor")
		s Count = ds.Data("Count")
		
		s valCells = Department_$c(1)_Doctor_$c(1)_Count
		
		s Count1 = ds.Data("Count1")
		s:($listget(lstEntryID,1) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count1,1:valCells_$c(1)_$tr($p(Count1,"-",1)," ","")_$c(1)_$tr($p(Count1,"-",2)," ",""))
		s Count2 = ds.Data("Count2")
		s:($listget(lstEntryID,2) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count2,1:valCells_$c(1)_$tr($p(Count2,"-",1)," ","")_$c(1)_$tr($p(Count2,"-",2)," ",""))
		s Count3 = ds.Data("Count3")
		s:($listget(lstEntryID,3) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count3,1:valCells_$c(1)_$tr($p(Count3,"-",1)," ","")_$c(1)_$tr($p(Count3,"-",2)," ",""))
		s Count4 = ds.Data("Count4")
		s:($listget(lstEntryID,4) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count4,1:valCells_$c(1)_$tr($p(Count4,"-",1)," ","")_$c(1)_$tr($p(Count4,"-",2)," ",""))
		s Count5 = ds.Data("Count5")
		s:($listget(lstEntryID,5) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count5,1:valCells_$c(1)_$tr($p(Count5,"-",1)," ","")_$c(1)_$tr($p(Count5,"-",2)," ",""))
		s Count6 = ds.Data("Count6")
		s:($listget(lstEntryID,6) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count6,1:valCells_$c(1)_$tr($p(Count6,"-",1)," ","")_$c(1)_$tr($p(Count6,"-",2)," ",""))
		s Count7 = ds.Data("Count7")
		s:($listget(lstEntryID,7) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count7,1:valCells_$c(1)_$tr($p(Count7,"-",1)," ","")_$c(1)_$tr($p(Count7,"-",2)," ",""))
		s Count8 = ds.Data("Count8")
		s:($listget(lstEntryID,8) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count8,1:valCells_$c(1)_$tr($p(Count8,"-",1)," ","")_$c(1)_$tr($p(Count8,"-",2)," ",""))
		s Count9 = ds.Data("Count9")
		s:($listget(lstEntryID,9) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count9,1:valCells_$c(1)_$tr($p(Count9,"-",1)," ","")_$c(1)_$tr($p(Count9,"-",2)," ",""))
		s Count10 = ds.Data("Count10")
		s:($listget(lstEntryID,10) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count10,1:valCells_$c(1)_$tr($p(Count10,"-",1)," ","")_$c(1)_$tr($p(Count10,"-",2)," ",""))
		s Count11 = ds.Data("Count11")
		s:($listget(lstEntryID,11) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count11,1:valCells_$c(1)_$tr($p(Count11,"-",1)," ","")_$c(1)_$tr($p(Count11,"-",2)," ",""))
		s Count12 = ds.Data("Count12")
		s:($listget(lstEntryID,12) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count12,1:valCells_$c(1)_$tr($p(Count12,"-",1)," ","")_$c(1)_$tr($p(Count12,"-",2)," ",""))
		s Count13 = ds.Data("Count13")
		s:($listget(lstEntryID,13) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count13,1:valCells_$c(1)_$tr($p(Count13,"-",1)," ","")_$c(1)_$tr($p(Count13,"-",2)," ",""))
		s Count14 = ds.Data("Count14")
		s:($listget(lstEntryID,14) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count14,1:valCells_$c(1)_$tr($p(Count14,"-",1)," ","")_$c(1)_$tr($p(Count14,"-",2)," ",""))
		s Count15 = ds.Data("Count15")
		s:($listget(lstEntryID,15) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count15,1:valCells_$c(1)_$tr($p(Count15,"-",1)," ","")_$c(1)_$tr($p(Count15,"-",2)," ",""))
		s Count16 = ds.Data("Count16")
		s:($listget(lstEntryID,16) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count16,1:valCells_$c(1)_$tr($p(Count16,"-",1)," ","")_$c(1)_$tr($p(Count16,"-",2)," ",""))
		s Count17 = ds.Data("Count17")
		s:($listget(lstEntryID,17) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count17,1:valCells_$c(1)_$tr($p(Count17,"-",1)," ","")_$c(1)_$tr($p(Count17,"-",2)," ",""))
		s Count18 = ds.Data("Count18")
		s:($listget(lstEntryID,18) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count18,1:valCells_$c(1)_$tr($p(Count18,"-",1)," ","")_$c(1)_$tr($p(Count18,"-",2)," ",""))
		s Count19 = ds.Data("Count19")
		s:($listget(lstEntryID,19) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count19,1:valCells_$c(1)_$tr($p(Count19,"-",1)," ","")_$c(1)_$tr($p(Count19,"-",2)," ",""))
		s Count20 = ds.Data("Count20")
		s:($listget(lstEntryID,20) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count20,1:valCells_$c(1)_$tr($p(Count20,"-",1)," ","")_$c(1)_$tr($p(Count20,"-",2)," ",""))
		s Count21 = ds.Data("Count21")
		s:($listget(lstEntryID,21) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count21,1:valCells_$c(1)_$tr($p(Count21,"-",1)," ","")_$c(1)_$tr($p(Count21,"-",2)," ",""))
		s Count22 = ds.Data("Count22")
		s:($listget(lstEntryID,22) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count22,1:valCells_$c(1)_$tr($p(Count22,"-",1)," ","")_$c(1)_$tr($p(Count22,"-",2)," ",""))
		s Count23 = ds.Data("Count23")
		s:($listget(lstEntryID,23) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count23,1:valCells_$c(1)_$tr($p(Count23,"-",1)," ","")_$c(1)_$tr($p(Count23,"-",2)," ",""))
		s Count24 = ds.Data("Count24")
		s:($listget(lstEntryID,24) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count24,1:valCells_$c(1)_$tr($p(Count24,"-",1)," ","")_$c(1)_$tr($p(Count24,"-",2)," ",""))
		s Count25 = ds.Data("Count25")
		s:($listget(lstEntryID,25) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count25,1:valCells_$c(1)_$tr($p(Count25,"-",1)," ","")_$c(1)_$tr($p(Count25,"-",2)," ",""))
		s Count26 = ds.Data("Count26")
		s:($listget(lstEntryID,26) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count26,1:valCells_$c(1)_$tr($p(Count26,"-",1)," ","")_$c(1)_$tr($p(Count26,"-",2)," ",""))
		s Count27 = ds.Data("Count27")
		s:($listget(lstEntryID,27) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count27,1:valCells_$c(1)_$tr($p(Count27,"-",1)," ","")_$c(1)_$tr($p(Count27,"-",2)," ",""))
		s Count28 = ds.Data("Count28")
		s:($listget(lstEntryID,28) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count28,1:valCells_$c(1)_$tr($p(Count28,"-",1)," ","")_$c(1)_$tr($p(Count28,"-",2)," ",""))
		s Count29 = ds.Data("Count29")
		s:($listget(lstEntryID,29) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count29,1:valCells_$c(1)_$tr($p(Count29,"-",1)," ","")_$c(1)_$tr($p(Count29,"-",2)," ",""))
		s Count30 = ds.Data("Count30")
		s:($listget(lstEntryID,30) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count30,1:valCells_$c(1)_$tr($p(Count30,"-",1)," ","")_$c(1)_$tr($p(Count30,"-",2)," ",""))
		s Count31 = ds.Data("Count31")
		s:($listget(lstEntryID,31) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count31,1:valCells_$c(1)_$tr($p(Count31,"-",1)," ","")_$c(1)_$tr($p(Count31,"-",2)," ",""))
		s Count32 = ds.Data("Count32")
		s:($listget(lstEntryID,32) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count32,1:valCells_$c(1)_$tr($p(Count32,"-",1)," ","")_$c(1)_$tr($p(Count32,"-",2)," ",""))
		s Count33 = ds.Data("Count33")
		s:($listget(lstEntryID,33) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count33,1:valCells_$c(1)_$tr($p(Count33,"-",1)," ","")_$c(1)_$tr($p(Count33,"-",2)," ",""))
		s Count34 = ds.Data("Count34")
		s:($listget(lstEntryID,34) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count34,1:valCells_$c(1)_$tr($p(Count34,"-",1)," ","")_$c(1)_$tr($p(Count34,"-",2)," ",""))
		s Count35 = ds.Data("Count35")
		s:($listget(lstEntryID,35) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count35,1:valCells_$c(1)_$tr($p(Count35,"-",1)," ","")_$c(1)_$tr($p(Count35,"-",2)," ",""))
		s Count36 = ds.Data("Count36")
		s:($listget(lstEntryID,36) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count36,1:valCells_$c(1)_$tr($p(Count36,"-",1)," ","")_$c(1)_$tr($p(Count36,"-",2)," ",""))
		s Count37 = ds.Data("Count37")
		s:($listget(lstEntryID,37) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count37,1:valCells_$c(1)_$tr($p(Count37,"-",1)," ","")_$c(1)_$tr($p(Count37,"-",2)," ",""))
		s Count38 = ds.Data("Count38")
		s:($listget(lstEntryID,38) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count38,1:valCells_$c(1)_$tr($p(Count38,"-",1)," ","")_$c(1)_$tr($p(Count38,"-",2)," ",""))
		s Count39 = ds.Data("Count39")
		s:($listget(lstEntryID,39) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count39,1:valCells_$c(1)_$tr($p(Count39,"-",1)," ","")_$c(1)_$tr($p(Count39,"-",2)," ",""))
		s Count40 = ds.Data("Count40")
		s:($listget(lstEntryID,40) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count40,1:valCells_$c(1)_$tr($p(Count40,"-",1)," ","")_$c(1)_$tr($p(Count40,"-",2)," ",""))
		
	 	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		//s ^CacheTempXZX("EPRQuality","ExportEntryCompositeReport","retval",StartRow) = retval
		&javascript<#(retval)#>
		
		s Count = Count + 1
		s StartRow = StartRow + 1
	}
	d ds.Close()
	
	//打印“统计日期：2008-12-01 至 2008-12-21”
	s valCells = "统计日期："_StartDate_" 至 "_EndDate
	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',5,1);"
	//s ^CacheTempXZX("EPRQuality","ExportEntryCompositeReport","retval") = retval
	&javascript<#(retval)#>
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2011-01-17
/// Description:	关于指定质控条目的统计查询报表明细内容；
/// Table:       	
/// Input:			ALocIDs为科室RowID字符串,多个以"^"分隔;
/// 				ADocID为主治医RowID;
/// 				AStartDate为出院起始日期;
/// 				AEndDate为出院截止日期;
/// 				AEntryIDs为指定的质控项目RowID字符串,格式为1^2|3|4^5|6^7^8.
/// Output: 		质控查询报表
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetCompositeDetails","","","","01/12/2008","31/12/2008")				
Query GetCompositeDetails(ALocIDs As %String, ADocID As %String, AEntryIDs As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "RegNo,EpisodeID,PatientName,Gender,LocDesc,WardDesc,AdmitDate,DischDate,EntryTitle,EntryScore,MultiErrInfo,VetoInfo") [ SqlProc ]
{
}

ClassMethod GetCompositeDetailsExecute(ByRef qHandle As %Binary, ALocIDs As %String, ADocID As %String, AEntryIDs As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,0)
	
	q:(AEntryIDs = "")||(AStartDate = "")||(AEndDate = "") $$$OK
	
	// Get loc list without empty elements
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	q:($listlength(lstLocID) = 0) $$$OK
	
	// Get entrys list with empty elements
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"^","N")
	q:($listlength(lstEntryID) = 0) $$$OK
	
	k ^CacheTemp("EPRQuality","CompositeDetail",uid)
	
	for DischDate = AStartDate:1:AEndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1) 
			
			// BuildSummaryList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildCompositeDetailList(EpisodeID,lstLocID,ADocID,lstEntryID,uid)
			continue:(flag < 0)	
		}	
	}
	
	s DetailKey = ""
	for {
		s DetailKey = $o(^CacheTemp("EPRQuality","CompositeDetail",uid,DetailKey))
		q:(DetailKey = "")
		
		s Data = $g(^CacheTemp("EPRQuality","CompositeDetail",uid,DetailKey))
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1	
	}
	
	k ^CacheTemp("EPRQuality","CompositeDetail",uid)
	
	q $$$OK
}

ClassMethod BuildCompositeDetailList(AEpisodeID As %String, AListLocID As %List, ADocID As %String, AListEntryID As %List, AUniqueKey As %String) As %Integer
{
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret		//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "Other"
	q:(ADocID '= "")&&(AdmDoctorID '= ADocID) ret
	
	s AdmWardID = $p(objPaAdm,"^",70)				//出院病区
	
	// 患者基本信息
	s Papmi = $p(objPaAdm,"^",1)
	s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDoctorID '= "Other":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		
	for i = 1:1:$listlength(AListEntryID)
	{
		//每一列有可能还是一组Entry
		s EntrySet = $listget(AListEntryID,i)
		continue:(EntrySet = "")	
		
		s lstEntries = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntrySet,"|")
		for j = 1:1:$listlength(lstEntries)
		{
			s EntryID = $listget(lstEntries,j)
			continue:(EntryID = "")
			
			s objEntry = $g(^DHCEPRM.QualityEntryD(+EntryID))
	  		continue:(objEntry = "")		// 如果这个条目被删除了，则不参与计分

			s ResultID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,""))
			if (+ResultID > 0)
			{
				s DetailID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,ResultID,""))
				continue:(DetailID = "")
				
				s RowID = ResultID_"||"_DetailID
				s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(RowID)
				
				s EntryScore = objDetail.EntryScore
				
				s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
	  		
		  		s IsMultiErr = $list(objEntry,6)
		  		s MultiErrInfo = $s(IsMultiErr = "Y":"是",1:"否")
		  		s IsVeto = $list(objEntry,7)
		  		s VetoGrade = $list(objEntry,11)
		  		s VetoInfo = $s(IsVeto = "Y":VetoGrade,1:"否")
				
				s DetailKey = DisLocID_"||"_AdmDoctorID_"||"_AEpisodeID_"||"_EntryID
				s ^CacheTemp("EPRQuality","CompositeDetail",AUniqueKey,DetailKey) = $lb(RegNo,AEpisodeID,PatientName,Gender,LocDesc,WardDesc,AdmitDate,DischDate,EntryTitle,EntryScore,MultiErrInfo,VetoInfo)
			
				if (objDetail '= "")
				{
					d objDetail.%Close()
					k objDetail
				}
			}
		}
	}
	
	s ret = 1
	q ret
}

ClassMethod GetCompositeDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCompositeDetailsExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetCompositeDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCompositeDetailsExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Add by HKY
/// Creator:		HKY
/// CreatDate:		2012-08-17
/// Description:	根据科室，病区或登记号查询手工评分统计内容
/// Table:       	
/// Input:			ALocIDs为科室RowID字符串,多个以"^"分隔;
/// 				AWardID为病区RowID;
/// 				ARuleID为质控标准;RowID
/// 				
/// Output: 		手工评分统计报表（缺陷报表）
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityProfilerListRQ","8","","1","","","")
Query GetQualityProfilerListRQ(ALocID As %String, AWardID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MRNo,DisLocID,LocDesc,DisWardID,WardDesc,AdmDoctorID,DoctorDesc,ARuleID,RuleDesc,RegNo,Name,AdmitDate,DischDate,Recorder,RQResult,FinalScore")
{
}

ClassMethod GetQualityProfilerListRQExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	/* Debug
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","ALocID")		  = ALocID
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","AWardID")	  = AWardID
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","ARuleID")	  = ARuleID
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","ARegNo")		  = ARegNo
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","APatientName") = APatientName
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","AStartDate")	  = AStartDate
	s ^CacheTemp("EPRQuality","GetQualityProfilerList","AEndDate")	  = AEndDate
	*/
	
	s RuleID = $g(ARuleID)
	q:(RuleID = "") $$$OK
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s:(StartDate = "") StartDate = $p($h,",",1) - 7
	s:(EndDate = "") EndDate = $p($h,",",1)
	

	k ^CacheTemp("EPRQuality","Profiler",repid)
	k ^TEMPRQReportResultCell   //删除拼字符串用的Global

	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			
			s existed = ..CheckExistInResultByID(EpisodeID, ARuleID)
			continue:(existed <= 0) 
			
			// BuildProfilerData(LocID,WardID,RuleID,EpisodeID,StartDate,EndDate,UniqueKey)
			s flag = ..BuildProfilerDataRQ("","",ARuleID,EpisodeID,"","",repid)
			continue:(flag < 0)
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s PatientID = ""
		for {
			s PatientID = $o(^PAPERi("PAPER_PatName",APatientName,PatientID))
			q:(PatientID = "")	
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
				q:(EpisodeID = "")
				
				s existed = ..CheckExistInResultByID(EpisodeID, ARuleID)
				continue:(existed <= 0) 
		
				// BuildProfilerData(LocID,WardID,RuleID,EpisodeID,StartDate,EndDate,UniqueKey)
				s flag = ..BuildProfilerDataRQ("","",ARuleID,EpisodeID,"","",repid)
				continue:(flag < 0)
			}
		}	
	}
	else
	{
		s WardID = $g(AWardID)
		s:(WardID '= "") WardID = ..GetRealWardID(WardID)
		q:(ALocID = "")&&(WardID = "") $$$OK
		
		s BlankEpisodeID = ""
		for {
			s BlankEpisodeID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID,BlankEpisodeID))
			q:(BlankEpisodeID = "")
			
			s EpisodeID = $tr(BlankEpisodeID," ","")
				
			s flag = ..BuildProfilerDataRQ(ALocID,WardID,ARuleID,EpisodeID,StartDate,EndDate,repid)
			continue:(flag < 0)
		}
	}
	
	s ResultID = ""
	for {
		s ResultID = $o(^CacheTemp("EPRQuality","Profiler",repid,ResultID))
		q:(ResultID = "")
		
		s Data = $g(^CacheTemp("EPRQuality","Profiler",repid,ResultID))
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	k ^CacheTemp("EPRQuality","Profiler",repid)
	
	q $$$OK
}

ClassMethod BuildProfilerDataRQ(ALocID As %String, AWardID As %String, ARuleID As %String, AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AUniqueKey As %String) As %String
{
	s ret = -1

	s RuleDesc = $list($g(^DHCEPRM.QualityRuleD(+ARuleID)),2)
	
	s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,ResultID))
		q:(ResultID = "")
	
		s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 

		s ExamineDate = objResult.ExamineDate
		continue:(ExamineDate = "")
		s ExamineDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)
		continue:(AStartDate '= "")&&(ExamineDate < AStartDate)
		continue:(AEndDate '= "")&&(ExamineDate > AEndDate)
		
		// 报告人
		s RecorderID = objResult.SignUserDR
		s Recorder = $s($g(RecorderID)'="-1":$p($g(^SSU("SSUSR",+RecorderID)),"^",2),1:"自动任务")
				
		s objPaAdm = $g(^PAADM(+AEpisodeID))	
		
		s DisLocID = $p(objPaAdm,"^",4)					//出院科室
		continue:(DisLocID = "")
		continue:(ALocID '= "")&&(DisLocID '= ALocID)
		
		s DisWardID = $p(objPaAdm,"^",70)				//出院病区
		continue:(DisWardID = "")
		continue:(AWardID '= "")&&(DisWardID '= AWardID)
		
		s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生

		s Papmi = $p(objPaAdm,"^",1)
		s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		//continue:(ARegNo '= "")&&(RegNo '= ARegNo)
		
		s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
		//continue:(APatientName '= "")&&(Name '[ APatientName)
				
		//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
		s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
		s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
		s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
		s:(Birthday '= "") Birthday = $zd(Birthday,3)
		s AdmitDate = $zd($p(objPaAdm,"^",6),3)
		s DischDate = $p(objPaAdm,"^",17)
		
		
		continue:(DischDate = "")&&(DischDate > AEndDate)
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)			
		s WLocID = $p($g(^PAWARD(+DisWardID)),"^",5)
		s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
		s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
		s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		//s FinalScore=objResult.ActualScore


		
		s RQReportResultStr=""
		s Sum=0
		s key = ""
		
		do {
			s objDetail = objResult.Details.GetNext(.key)
		  	if (objDetail '= "")
		  	{   
		  		s EntryID = objDetail.EntryDR
		  		
		  		// 如果这个条目被删除了，则不参与计分
				continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
		  		
		  		s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
		  		
		  		s objEntry = $g(^DHCEPRM.QualityEntryD(+EntryID))
		  		s StructID = $list(objEntry,3)
		  		s StructName = $list($g(^DHCEPRM.QualityStructD(StructID)),1)
		  		s Score=..GetScoreByEntryID(+EntryID)
		  		s Sum=Sum+Score
		  	 
		  		s ^TEMPRQReportResultCell(StructName)=$g(^TEMPRQReportResultCell(StructName))_EntryTitle_",-"_Score_"分;#" //生成拼字符串用的Global
		  		
			}
		} while(key '= "")
		s RQResult=..GetRQReportResult()
		k ^TEMPRQReportResultCell
		s FinalScore=100-Sum
		s ^CacheTemp("EPRQuality","Profiler",AUniqueKey,ResultID) = $lb(MRNo,DisLocID,LocDesc,DisWardID,WardDesc,AdmDoctorID,DoctorDesc,ARuleID,RuleDesc,RegNo,Name,AdmitDate,DischDate,Recorder,RQResult,FinalScore)
		d objResult.%Close()
	}
	
	s ret = 1
	q ret
}

ClassMethod GetQualityProfilerListRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityProfilerListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityProfilerListRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityProfilerListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetScoreByEntryID(AEntryID As %String) As %String
{
	//获取Entry-Title 对应的score
	s ret=""
	q:AEntryID="" ret
	s ret=$list($g(^DHCEPRM.QualityEntryD(AEntryID)),4)
	
	
	q ret
}

ClassMethod GetRQReportResult() As %String
{
 
	s ret=""	
	s StructName=""
	s num=1
	f  s StructName=$o(^TEMPRQReportResultCell(StructName)) q:StructName=""  d
	.s numlength=$l(^TEMPRQReportResultCell(StructName),"#")-1
	.s retDet=""
	.f i=1:1:numlength d
	..s retDet=retDet_$c(10)_$c(13)_i_")."_$p(^TEMPRQReportResultCell(StructName),"#",i)_$c(10)_$c(13)
	
	.s ret=ret_num_"、"_StructName_":"_retDet

	.s ret=$EXTRACT(ret,1,$l(ret)-1)_"."
	.s num=num+1
	q ret
}

/// new added by HKY
/// modify by candy  
/// 查询质控条目
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","getPatientInfoByEntryID","15","01/07/2008","20/07/2013")
Query getPatientInfoByEntryID(AEntryID As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "ARuleID,AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,CreateUserName") [ SqlProc ]
{
}

ClassMethod getPatientInfoByEntryIDExecute(ByRef qHandle As %Binary, AEntryID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	//函数主要部分，主要功能是依据给出的EntryID 取出来符合EntryId的患者基本信息
	/*
	s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(AEntryID)
	q:objEntry="" $$$OK
	s PoolDR=objEntry.PoolDR
	*/
	s PoolDR = AEntryID
	s EntryID = ""
	s:((AStartDate=$c(0))||(AStartDate="")) AStartDate=0
	S:((AEndDate=$c(0))||(AEndDate="")) AEndDate=+$h

	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	
	s Flag2=0
	for {
		s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolDR,EntryID))
		q:EntryID=""
		s objEntrynew=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
		s objStructDR=objEntrynew.StructDR
		
		s RuleDR=objEntrynew.RuleDR
		s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(RuleDR)
		Continue:'((objRule.Code = "F")||(objRule.Code = "G"))
	
		q:Flag2>=1
		s Flag2=Flag2+1
		s ParRef=""
		
		for {
		
			s ParRef=$o(^DHCEPRQ.QualityResultDetailI("IdxEntryID"," "_EntryID,ParRef))
			q:ParRef=""
			s Childsub=""
			for {

				s Childsub=$o(^DHCEPRQ.QualityResultDetailI("IdxEntryID"," "_EntryID,ParRef,Childsub))
				q:Childsub=""
				s objResultDet=$g(^DHCEPRQ.QualityResultD(ParRef,"Details",Childsub))
				continue:objResultDet=""
				
				s EpisodeID=$list(objResultDet,5)
				
				s flag = ..EpisodeIDRuleSearchData(RuleDR,EpisodeID,repid,StartDate,EndDate,objStructDR)
				
				k ^CreateUserQualityStruct
				continue:(flag < 0)
			}
		
		}
	}

	// 按病区、医生排序
	s tmpWard = ""
	for {
		
		s tmpWard = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard))
		q:(tmpWard = "")
		
		s tmpDoctor = ""
		for {
			s tmpDoctor = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor))
			q:(tmpDoctor = "")
			
			s tmpAdmID = ""
			for {
				s tmpAdmID = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID))
				q:(tmpAdmID = "")
				
				s tmpCreateUserName=""
				for {
					s tmpCreateUserName = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID,tmpCreateUserName))
					q:(tmpCreateUserName = "")
					s Data = $g(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID,tmpCreateUserName))
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1	
				}
			}
		}
	}
	
	k ^CacheTempPatInfoSByEntry("EPRQuality","AdmitSearch",repid)
	
	q $$$OK
	
	Quit $$$OK
}

ClassMethod getPatientInfoByEntryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getPatientInfoByEntryIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod getPatientInfoByEntryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getPatientInfoByEntryIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(EPRservice.Quality.BOQualityReport).EpisodeIDRuleSearchData(8,77128,1,2008-08-08,2013-08-08,105)
ClassMethod EpisodeIDRuleSearchData(ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AStartDate As %String, AEndDate As %String, AStructID As %String) As %String
{
	s ret = -1
	
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	// Only process patient that allocate department
	s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret

	s AdmWardID = $p(objPaAdm,"^",70)				
	q:(AdmWardID="") ret
	
	// Only process patient that allocate physician
	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	
				
	s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	q:(ResultID = "") ret
	
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret
	
    s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
    s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	//s Grade = $p($list(objResult,8),"@",1)
	//s Score = 100 - (+$list(objResult,2))

	
	s AdmitDate = $p($g(objPaAdm),"^",6)


	q:(AEndDate<AStartDate) ret

    q:'((AdmitDate>AStartDate)&&(AdmitDate<AEndDate)) ret
    
    
    // 以下取患者基本信息和就诊信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	
	
	
	s CreateUserFlag=..GetCreatUserbyStructID(AEpisodeID,AStructID)
	s ChildStructDR="",CreateUserID=""
	for {
		q:(CreateUserFlag=-1)
		s ChildStructDR=$o(^CreateUserQualityStruct(AEpisodeID,ChildStructDR))
		q:ChildStructDR=""
		s InstanceID=""
		for {
			s InstanceID=$o(^CreateUserQualityStruct(AEpisodeID,ChildStructDR,InstanceID))
			q:InstanceID=""
						
			//需要修改目前只取最后一个值
			s CreateUserID=$g(^CreateUserQualityStruct(AEpisodeID,ChildStructDR,InstanceID))
			continue:CreateUserID=""
			q:CreateUserID'=""
		}
	}

	s CreateUserName="无"
	s:CreateUserID'="" CreateUserName=$p($g(^SSU("SSUSR",CreateUserID)),"^",2)
	// Write data to assigned temp global
	s ^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",AUniqueKey,WardDesc,DoctorDesc,AEpisodeID,CreateUserName) = $lb(ARuleID,AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,CreateUserName)
	
	s ret = 1
	q ret
}

/// new add 用于取病历创建者
/// d ##class(EPRservice.Quality.BOQualityReport).GetCreatUserbyStructID(73323,125)
ClassMethod GetCreatUserbyStructID(EpisodeID As %String, StructID As %String) As %String
{
	s ret = 1
	
	s objQualityStruct=##class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
	q:(objQualityStruct="") ""
	s BindCategoryId=objQualityStruct.BindCategoryId
	if BindCategoryId="" { 
		s StructIDChild=""
		for {
			s StructIDChild=$o(^DHCEPRM.QualityStructI("IdxParentId"," "_StructID,StructIDChild))
			q:StructIDChild=""
			s ret= ..GetCreatUserbyStructID(EpisodeID,StructIDChild)
		}
	}
	else {
		s ECRecordID=""
		for {
			s ECRecordID=$o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_BindCategoryId,ECRecordID))
			q:ECRecordID=""
			s objECRecord=##class(EPRinstance.ECRecord).%OpenId(ECRecordID)
			s Count=objECRecord.InstanceCount
			s CreatUser="" 
				
			for num=1:1:Count {		
				s instancedataID=ECRecordID_"||"_num
				s objInstancedata=##class(EPRinstance.InstanceData).%OpenId(instancedataID)
				q:objInstancedata=""
				s ^CreateUserQualityStruct(EpisodeID,StructID,instancedataID)=objInstancedata.CreateUser
				
			}
				
		}
	s:$d(^CreateUserQualityStruct)=0 ret=-1	
	}
	
	q ret
}

/// Added By HKY 
/// 质控消息统计报表
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetMessageReport","2022-09-01","2023-01-29")
Query GetMessageReport(AStartDate As %String, AEndDate As %String, ALocIDs As %Text = "", AHospitalID As %String = "") As %Query(ROWSPEC = "MessageBody,CreateDate,CreateTime,CreateUserDesc,ReadDate,ReadTime,ReadUserDesc,ReadStatus,LocDesc,Name,RegNo,DoctorDesc") [ SqlProc ]
{
}

ClassMethod GetMessageReportExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocIDs As %Text = "", AHospitalID As %String = "") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	/*
	//二版病历质控消息查询启用本段代码
	for IdxCreateDate = StartDate:1:EndDate
	{   
		s MessageID = ""
		for {
			s MessageID = $o(^DHCEPRQ.QualityMessageI("IdxCreateDate",IdxCreateDate,MessageID))
			
			q:(MessageID = "") 
			
			
			
			s objMessage = $g(^DHCEPRQ.QualityMessageD(MessageID))
			continue:(objMessage = "")
			
			s CreateDate = $list(objMessage,2)
			s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
			
			s CreateTime = $list(objMessage,3)
			s:(CreateTime '= "") CreateTime = $zt(CreateTime,1)
			s CreateUserDR = $list(objMessage,4)
			s CreateUserDesc = ""
			s:(CreateUserDR '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+CreateUserDR)),"^",2)
			s MessageBody = $list(objMessage,5)
			s MessageDR=MessageID
			
			
			s MessageRecipientID=""
			s ReadStatus="未读"
			for {
				s MessageRecipientID=$o(^DHCEPRQ.QualityMsgRecI("IdxMessageDR"," "_MessageDR,MessageRecipientID))
				q:MessageRecipientID=""
				
				
				
				s objRecipient = $g(^DHCEPRQ.QualityMsgRecD(MessageRecipientID))
				s EpisodeID = $list(objRecipient,2)
				
				
				s ReadDate=$zd($list(objRecipient,4),3)
				s ReadTime=$zt($list(objRecipient,5),3)
				s ReadUserDR=$list(objRecipient,6)
				s:(ReadUserDR '= "") ReadStatus="已读"
				s ReadUserDesc = ""
			    s:(ReadUserDR '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUserDR)),"^",2)
			    s objPaAdm = $g(^PAADM(+EpisodeID))
			    s AdmLocID = $p(objPaAdm,"^",4)
	            q:(AdmLocID = "") 
	            q:(ALocID '= "")&&(AdmLocID '= ALocID)
			    s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生

		        s Papmi = $p(objPaAdm,"^",1)
		        s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		
		        s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
				
		        s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
		        s AdmitDate = $zd($p(objPaAdm,"^",6),3)
		        s DischDate = $p(objPaAdm,"^",17)
		        s:(DischDate '= "") DischDate = $zd(DischDate,3)
		        s LocDesc = $p($g(^CTLOC(AdmLocID)),"^",2)
		        s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		        s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		        s Data=$lb(MessageBody,CreateDate,CreateTime,CreateUserDesc,ReadDate,ReadTime,ReadUserDesc,ReadStatus,LocDesc,Name,RegNo,DoctorDesc)
			    s ^CacheTemp(repid,ind) = Data
		        s ind = ind + 1	
			   
				}
		    }
			
	  }	
	*/
	for IdxCreateDate = StartDate:1:EndDate
	{   
		s CreateTime1 = ""
		for {
			s CreateTime1 = $o(^DHCEPRQ.EPRSingleMessageI("IdxCreateDateTime",IdxCreateDate,CreateTime1))
			q:(CreateTime1="")
			s MessageID = ""
			for {
				
			s MessageID = $o(^DHCEPRQ.EPRSingleMessageI("IdxCreateDateTime",IdxCreateDate,CreateTime1,MessageID))
			q:(MessageID = "") 
			s objMessage = $g(^DHCEPRQ.EPRSingleMessageD(MessageID))
			s ObjMessage=##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
			s EpisodeID= $list(objMessage,23)
			continue:(objMessage = "")
			
			s CreateDate = $list(objMessage,2)
			s:(CreateDate '= "") CreateDate = $zd(CreateDate,3)
			//modify by lifb 20170823
			s CreateDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
			s CreateTime = $list(objMessage,3)
			s:(CreateTime '= "") CreateTime = $zt(CreateTime,1)
			//modify by lifb 20170823
			s CreateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",CreateTime)
			s CreateUserDR = $list(objMessage,4)
			s CreateUserDesc = ""
			s:(CreateUserDR '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+CreateUserDR)),"^",2)
			s MessageBody = $list(objMessage,10)
			s MessageDR=MessageID
			s ReadStatus=$list(objMessage,14)
			s:(ReadStatus="U") ReadStatus="未读未执行"
			s:(ReadStatus="R") ReadStatus="已读"
			s:(ObjMessage.ExecuteFlag="E") ReadStatus="已执行" 
			//modify by lifb 20170823
			s ReadDate=$list(objMessage,15)
			s ReadDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ReadDate)
			//modify by lifb 20170823
			s ReadTime=$list(objMessage,16)
			s ReadTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ReadTime)
			s ReadUserDR=$list(objMessage,7)
			s ReadUserDesc = ""
			s:(ReadUserDR '= "") ReadUserDesc = $p($g(^SSU("SSUSR",+ReadUserDR)),"^",2)
			s CreateUserDR=$list(objMessage,6)
			s CreateUserDesc = ""
			s:(CreateUserDR '= "") CreateUserDesc = $p($g(^SSU("SSUSR",+CreateUserDR)),"^",2)
			
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)
	        q:(AdmLocID = "") 
	        q:($listlength(ListLocID) > 0)&&($listfind(ListLocID,AdmLocID) = 0)
	        s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生

		    s Papmi = $p(objPaAdm,"^",1)
		    s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		
		    s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
				
		    //s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
			s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I",.ErrMsg)
		    //modify by lifb 20170823
		    //s AdmitDate = $zd($p(objPaAdm,"^",6),3)
		    s AdmitDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
		    s AdmitDate=$p(AdmitDateTime,",",1)
		    s AdmitDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmitDate)
		    
		    //modify by lifb 20170823
		    s DischDate = $p(objPaAdm,"^",17)
		    s:(DischDate '= "") DischDate = $zd(DischDate,3)
		    s DischDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
		    
		    s LocDesc = $p($g(^CTLOC(AdmLocID)),"^",2)
		    s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		       
		        s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		        s Data=$lb(MessageBody,CreateDate,CreateTime,CreateUserDesc,ReadDate,ReadTime,ReadUserDesc,ReadStatus,LocDesc,Name,RegNo,DoctorDesc)
			    s ^CacheTemp(repid,ind) = Data
		        s ind = ind + 1	
			   
				
		    }
		}	
	  }	
	Quit $$$OK
}

ClassMethod GetMessageReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMessageReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:在院信息查询(按科室、病区、医生汇总在院自动任务信息，并按权限展现，非质控科，只能查本科室信息)
/// Creator:Candyxu
/// Createdate:2013-2-26
/// Input:ALocID:科室ID,AWardID:病区ID,ADoctorID:医生ID,ARegNo:登记号,APatientName:患者姓名
///       ARuleCode:质控标准,AIsMultiSummary:是否合计,AIsFinalList:是否查终末结果
/// OutPut:LocDesc:科室,WardDesc:病区,DoctorDesc:医生,AttendDoctor:主治医师,SeniorDoctor:主任医师
///       MRFirst:等级1,MRSecond:等级2,MRThird:等级3,MRFourth:等级4,MRFifth:等级5,MRCount:等级数量
///       LocID:科室ID,WardID:病区ID,DoctorID医生ID,RuleIDs:质控标准,RegNo:登记号
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetAdmSearchbyRight","","","","0000000042","","F","Y","Y")
Query GetAdmSearchbyRight(ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, ARuleCode As %String, AIsMultiSummary As %String, AIsFinalList As %String = "Y", AIsAllLocs As %String) As %Query(ROWSPEC = "LocDesc,WardDesc,DoctorDesc,AttendDoctor,SeniorDoctor,MRFirst,MRSecond,MRThird,MRFourth,MRFifth,MRCount,LocID,WardID,DoctorID,RuleIDs,RegNo")
{
}

ClassMethod GetAdmSearchbyRightExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARegNo As %String, APatientName As %String, ARuleCode As %String, AIsMultiSummary As %String, AIsFinalList As %String = "Y", AIsAllLocs As %String) As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,uid,"")

	q:(ARuleCode = "") $$$OK
    s RuleID = ..GetRuleIDsByRuleCodes(ARuleCode)
	// 开辟一个临时Global用于排序
	k ^CacheTemp("EPRQuality","AdmSearchbyRight",uid)
	s Number = 0	
	// 先根据登记号，再根据患者姓名，最后再根据科室、病区和就诊日期等条件查询
	if (ARegNo '= "")
	{
		// Table:	PA_PatMas
		// Global:	^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		s patientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(patientID = "") $$$OK
		
		// Table:	PA_Adm
		// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		s episodeID = ""
		for {
			s episodeID = $o(^PAPERdr(patientID,"ADM","I",episodeID))
			q:(episodeID = "")
			s flag = ..GetQualityReportResult("","","",RuleID,episodeID,uid,"AdmSearchbyRight",AIsFinalList)
			continue:(flag < 0)
			s Number = Number + 1
		}	
	}
	elseif (APatientName '= "")
	{
		// Table: 	PA_PatMas
		// Global:	^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		s patientID = ""
		for {
			s patientID = $o(^PAPERi("PAPER_PatName",APatientName,patientID))
			q:(patientID = "")	
			
			// Table:	PA_Adm
			// Global:	^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
			s episodeID = ""
			for {
				s episodeID = $o(^PAPERdr(patientID,"ADM","I",episodeID))
				q:(episodeID = "")
				s flag = ..GetQualityReportResult("","","",RuleID,episodeID,uid,"AdmSearchbyRight",AIsFinalList)
				continue:(flag < 0)
				s Number = Number + 1
			}
		}	
	}
	else
	{
		s wardID = $g(AWardID)
		s:(wardID '= "") wardID = ..GetRealWardID(wardID)
		q:(ALocID = "")&&(wardID = "")&&($zcvt(AIsAllLocs,"U") = "N") $$$OK
		
		s:($zcvt(AIsAllLocs,"U") = "Y") wardID = "", ALocID = "",ADoctorID = ""

		
		s blankEpisodeID = ""
		for {
			s blankEpisodeID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_RuleID,blankEpisodeID))
			q:(blankEpisodeID = "")
			
			// Trim the blank of BlankEpisodeID
			s episodeID = $tr(blankEpisodeID," ","")
			
			// BuildAdmitSearchData(LocID,WardID,DoctorID,RuleID,EpisodeID,UniqueKey)
			s flag = ..GetQualityReportResult(ALocID,wardID,ADoctorID,RuleID,episodeID,uid,"AdmSearchbyRight",AIsFinalList)
			continue:(flag < 0)
			s Number = Number + 1
		}
	}
	s (Count, First, Second, Third, Fourth, Fifth) = 0	
	
	// Process not find any episode by given query condition
	if (Number = 0)
	{
		// 加上第一栏统计
		s Data = $lb("合计","------","------","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,ARuleCode,ARegNo)
		s ^CacheTemp(uid,1) = Data
		
		k ^CacheTemp("EPRQuality","AdmSearchbyRight",uid)
		
		q $$$OK	
	}	
	s curLocID = ""
	for	{ 
		s curLocID = $o(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID)) 
		q:(curLocID = "")
		
		s LocDesc = $p($g(^CTLOC(curLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocCount, LocFirst, LocSecond, LocThird, LocFourth, LocFifth) = 0
		
		s curWardID = ""
		for {
			s curWardID = $o(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID)) 
			q:(curWardID = "")
			
			s WardDesc = $p($g(^PAWARD(curWardID)),"^",2)
			s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
			
			s (WardCount, WardFirst, WardSecond, WardThird,WardFourth,WardFifth) = 0
			
			s curDocID = ""
			for { 
				s curDocID = $o(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID)) 
				q:(curDocID = "") 
				
				if (curDocID '= -1)
				{
					s DoctorDesc = $p($g(^CTPCP(+curDocID)),"^",2)    			//CT_CareProv
					s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+curDocID,0))  		//SS_User
					s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
				}
				else
				{
					s DoctorDesc = "未指定"
				}
				//主治医师
				s AttendDoctor = "" 
				s AttendDoctorID = $g(^CacheTemp("SuperDoctors","EPRQuality","AdmSearchbyRight",uid,curDocID,"AttendDoctor"))
				if (AttendDoctorID '= "")
				{
					s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+AttendDoctorID,0))
					s:(SSUserID '= "") AttendDoctor = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
				} 
				//主任医师
				s SeniorDoctor = $g(^CacheTemp("SuperDoctors","EPRQuality","AdmSearchbyRight",uid,curDocID,"SeniorDoctor"))
				
				s (DocCount, DocFirst, DocSecond, DocThird, DocFourth, DocFifth) = 0
				
				s DocCount  = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"Count"))
				s DocFirst  = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"First"))
				s DocSecond = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"Second"))
				s DocThird  = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"Third"))
				s DocFourth = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"Fourth"))
				s DocFifth = +$g(^CacheTemp("EPRQuality","AdmSearchbyRight",uid,curLocID,curWardID,curDocID,"Fifth"))
				// 医生总计
				s Data = $lb("------","------",DoctorDesc,AttendDoctor,SeniorDoctor,DocFirst,DocSecond,DocThird,DocFourth,DocFifth,DocCount,curLocID,curWardID,curDocID,ARuleCode,ARegNo)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1
				
				s WardCount = WardCount + DocCount, WardFirst = WardFirst + DocFirst, WardSecond = WardSecond + DocSecond, WardThird = WardThird + DocThird,WardFourth = WardFourth + DocFourth,WardFifth = WardFifth + DocFifth
			}
			// 病区总计
			s Data = $lb("------",WardDesc,"------","------","------",WardFirst,WardSecond,WardThird,WardFourth,WardFifth,WardCount,curLocID,curWardID,"",ARuleCode,ARegNo)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
			
			s LocCount = LocCount + WardCount, LocFirst = LocFirst + WardFirst, LocSecond = LocSecond + WardSecond, LocThird = LocThird + WardThird,LocFourth = LocFourth + WardFourth,LocFifth = LocFifth + WardFifth
		}
		
		// 科室总计
		s Data = $lb(LocDesc,"------","------","------","------",LocFirst,LocSecond,LocThird,LocFourth,LocFifth,LocCount,curLocID,"","",ARuleCode,ARegNo)
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1
		
		s Count = Count + LocCount, First = First + LocFirst, Second = Second + LocSecond, Third = Third + LocThird,Fourth = Fourth + LocFourth,Fifth = Fifth + LocFifth
	}
	if (AIsAllLocs = "Y")
	{
		// 最后一栏的统计		
		s Data = $lb("合计","------","------","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,ARuleCode,ARegNo)
		s ^CacheTemp(uid,ind) = Data
		
		// 加上第一栏统计
		if ($zcvt(AIsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data = $lb("合计","------","------","------","------",First,Second,Third,Fourth,Fifth,Count,ALocID,WardID,ADoctorID,ARuleCode,ARegNo)
			s ^CacheTemp(uid,1) = Data
		}
	}
	k ^CacheTemp("EPRQuality","AdmSearchbyRight",uid)
	k ^CacheTemp("SuperDoctors","EPRQuality","AdmSearchbyRight",uid)

	Quit $$$OK
}

ClassMethod GetAdmSearchbyRightFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmSearchbyRightExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmSearchbyRightClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmSearchbyRightExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 2013-02-21
/// Added By HKY 
/// 出院质控明细报表
/// d ##class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetEPRQDetReport","","","2020-04-01","2020-04-17","Y",7)
Query GetEPRQDetReport(ALocID As %String, AWardID As %String, AStartDate As %String, AEndDate As %String, AIsAllLocs As %String, ARuleIDs As %String, AHospitalID As %String = "", DocName As %String = "") As %Query(ROWSPEC = "AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto") [ SqlProc ]
{
}

ClassMethod GetEPRQDetReportExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, AStartDate As %String, AEndDate As %String, AIsAllLocs As %String, ARuleIDs As %String, AHospitalID As %String = "", DocName As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s:(StartDate = "") StartDate = $h - 7
	s:(EndDate = "") EndDate = $p($h,",",1)
	
	s Number = 0
	
	s WardID = $g(AWardID)
	s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))

	//if you want query all data just by start date and end date, pls. cancel comment for the below line
	q:(ALocID = "")&&(WardID = "")&&(AIsAllLocs '= "Y") $$$OK	
	if (AIsAllLocs = "Y")
	{
		s ALocID = ""
		s WardID = ""
		
	}
		
	// 自动任务出院处理天数
	s Days = 5
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
		
	//s StartDate = StartDate - Days
	//s EndDate	= EndDate - Days
		
	for DischDate = StartDate:1:EndDate {
		s EpisodeID = ""
		s num=1
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			s objPaAdm = $g(^PAADM(+EpisodeID))
			s AdmLocID = $p(objPaAdm,"^",4)		
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)			
			s flag = ..GetEPRQDetReportResult(ALocID,WardID,ARuleIDs,EpisodeID,DocName,repid,num)
			
			continue:(flag < 0)
			s num=num+1
			
		}
	}
	
			
	// 按病区排序
	s tmpWard = ""
	for {
		
		s tmpWard = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard))
		q:(tmpWard = "")
		s tmpAdmID = ""
		for {
			 s tmpAdmID = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID))
			 q:(tmpAdmID = "")
			 s indnum=""
			 for {
			 	s indnum = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID,"Det",indnum))
			 	q:(indnum = "")	
			 	s Data = $g(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID,"Det",indnum))
			 	s ^CacheTemp(repid,ind) = Data
			 	s ind = ind + 1	
			 }
			}
		} 
	
	
  k ^CacheTemp("EPRQuality","AdmitSearch",repid)
	
	
	Quit $$$OK
}

ClassMethod GetEPRQDetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEPRQDetReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEPRQDetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEPRQDetReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)

	Quit $$$OK
}

/// 出院质控结果明细查询
/// Added By HKY
/// d ##class(EPRservice.Quality.BOQualityReport).GetEPRQDetReportResult("","","7","152","")
ClassMethod GetEPRQDetReportResult(ALocID As %String, AWardID As %String, ARuleIDs As %String, AEpisodeID As %String, DocName As %String, AUniqueKey As %String, ItemNum As %String) As %String
{
	
  	s ret = -1
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret			//就诊状态
	
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	//q:(ARegNo '= "")&&(RegNo '= ARegNo) ret
	
	s DisLocID = $p(objPaAdm,"^",4)					//出院科室
	q:(DisLocID = "") ret
	q:(ALocID '= "")&&(DisLocID '= ALocID) ret
	
	s DisWardID = $p(objPaAdm,"^",70)				//出院病区
	q:(DisWardID = "") ret
	q:(AWardID '= "")&&(DisWardID '= AWardID) ret
	
	
	// Only process patient that allocate physician
	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	//q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret
	
	 s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for i = 1:1:$listlength(RuleIDs) 
	{
	 s flag=0	
	 s ARuleID=$p(ARuleIDs,"^",i)			
	 s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	 continue:(ResultID = "") 
	 s flag=1
	}
	q:(flag=0) ret
	
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret
	
	q:($d(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_AEpisodeID))<0) ret
	s qresRowID = $o(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_AEpisodeID,""))
	q:(qresRowID = "") ret
               //s Grade = $li(^DHCEPRQ.QualityResultEndD(qresRowID),4)
              //s Score = $li(^DHCEPRQ.QualityResultEndD(qresRowID),6)
              // s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
              //s Score = $p(ScoreGrade,"^",1)
	//s Grade = $p(ScoreGrade,"^",2)
   	s Score="",Grade=""
  	s ScoreResult = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
	d ScoreResult.Execute(AEpisodeID,ARuleIDs,"D")
	while ScoreResult.Next()
	{
		s Score = ScoreResult.Data("FinalScore")
		s Grade = ScoreResult.Data("FinalGrade")
	}
	
	// 以下取患者基本信息和就诊信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+DisWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+DisWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)

	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	q:(DocName'="")&&(DoctorDesc'[DocName) ret
    
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")
	
	s sc = result.Execute(AEpisodeID,ARuleIDs,"D")
	
	s coulumns=result.GetColumnCount()
	
	While (result.Next())
    {

    s RuleID=result.Data("RuleID")
    s RuleTitle=result.Data("RuleTitle")
    s StructID=result.Data("StructID")
    s StructTitle=result.Data("StructTitle")
    s EntryID=result.Data("EntryID")
    s EntryTitle=result.Data("EntryTitle")
    s TriggerNumber=result.Data("TriggerNumber")
    s EntryScore=result.Data("EntryScore")
    s DepartmentID=result.Data("DepartmentID")
    s DepartmentName=result.Data("DepartmentName")
    s EmployeeID=result.Data("EmployeeID")
    s EmployeeName=result.Data("EmployeeName")
    s IsMultiErr=result.Data("IsMultiErr")
    s IsVeto=result.Data("IsVeto")
    s len=$l(DepartmentID,",")
    for i=1:1:len {
    s tmpDepID=$p(DepartmentID,",",i)
    s tmpDepName=$p(DepartmentName,",",i)
   //s tmpLocDesc=$s(tmpDepName'="":tmpDepName,1:LocDesc)
    s tmpLocDesc = result.Data("DepartmentName")
    s ^CacheTemp("EPRQuality","AdmitSearch",AUniqueKey,WardDesc,AEpisodeID,"Det",$i(^CahceTemp)) = $lb(AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto)	
	// Write data to assigned temp global
    }
    }
	s ret = 1
	q ret
}

/// Desc:在院质控明细报表
/// Creator:GanLL
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetAdmDetResult","","","Y","6","","","2022-02-02","2022-02-10")
Query GetAdmDetResult(ALocID As %String, AWardID As %String, AIsAllLocs As %String, ARuleIDs As %String, AHospitalID As %String = "", DocName As %String = "", AExamineStaDate As %String = "", AExamineEndDate As %String = "") As %Query(ROWSPEC = "AEpisodeID,Grade,Score,Name,LocDesc,WardDesc,RegNo,MRNo,Gender,DoctorDesc,AdmitDateTime,RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto,StrDate,EndDate,Hours,FinishDate,OverFlag,FinishFlag,SignUser") [ SqlProc ]
{
}

ClassMethod GetAdmDetResultExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, AIsAllLocs As %String, ARuleIDs As %String, AHospitalID As %String = "", DocName As %String = "", AExamineStaDate As %String = "", AExamineEndDate As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,"")

	s Number = 0
	
	s WardID = $g(AWardID)
	s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))

	//if you want query all data just by start date and end date, pls. cancel comment for the below line
	q:(ALocID = "")&&(WardID = "")&&(AIsAllLocs '= "Y") $$$OK
	q:(ARuleIDs="") $$$OK	
	if (AIsAllLocs = "Y")
	{
		s ALocID = ""
		s WardID = ""
		s ADoctorID = ""
	
     }
	s:(AExamineStaDate'="") AExamineStaDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AExamineStaDate)," ",1)
	s:(AExamineEndDate'="") AExamineEndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AExamineEndDate)," ",1)
	s EpisodeID = ""
	for {
		  s EpisodeID = $o(^PAADMi("AdmTypeCurr","I",EpisodeID))
		  q:(EpisodeID = "")
	
		  s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
	      continue:(flag < 1) 
	      s objAdm = $g(^PAADM(+EpisodeID))
	      s AdmType = $p(objAdm,"^",2)
	      continue:(AdmType '= "I") 
		  s AdmLocID = $p(objAdm,"^",4)		
		s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)	
		s flag = ..GetAdmResult(ALocID,WardID,ARuleIDs,EpisodeID,DocName,AExamineStaDate,AExamineEndDate,repid)
		continue:(flag < 0)
		s Number = Number + 1
	     }
	
	// 按病区排序
	s tmpWard = ""
	for {
		s tmpWard = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard))
		q:(tmpWard = "")
		s tmpAdmID = ""
		for {
			 s tmpAdmID = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID))
			 q:(tmpAdmID = "")
			 s ind2=""
			 for {
			 	s ind2 = $o(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID,ind2))
			 	q:(ind2 = "")	
			 	s Data = $g(^CacheTemp("EPRQuality","AdmitSearch",repid,tmpWard,tmpAdmID,ind2))
			 	s ^CacheTemp(repid,ind) = Data
			 	s ind = ind + 1	
			 }
		     } 
		} 
	
        k ^CacheTemp("EPRQuality","AdmitSearch",repid)
		
	Quit $$$OK
}

ClassMethod GetAdmDetResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmDetResultExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmDetResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmDetResultExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 在院质控结果明细查询
/// Added By GanLL
/// d ##class(EPRservice.Quality.BOQualityReport).GetAdmResult("","","6","269924","")
ClassMethod GetAdmResult(ALocID As %String, AWardID As %String, ARuleIDs As %String, AEpisodeID As %String, DocName As %String, AExamineStaDate As %String, AExamineEndDate As %String, AUniqueKey As %String) As %String
{
	
  	s ret = -1
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	
	s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret

	s AdmWardID = $p(objPaAdm,"^",70)				
	q:(AWardID '= "")&&(AdmWardID '= AWardID) ret
		
	// Only process patient that allocate physician
	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	//q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret
	s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for i = 1:1:$listlength(RuleIDs) 
	{
	 s flag=0	
	 s ARuleID=$p(ARuleIDs,"^",i)			
	 s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	 continue:(ResultID = "") 
	 s flag=1
	}
	q:(flag=0) ret			
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret
	
    s Scoreresult = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 	s sc = Scoreresult.Execute(AEpisodeID,ARuleIDs,"A")
	While (Scoreresult.Next())
	{
		s Grade = Scoreresult.Data("FinalGrade")
		s Score = Scoreresult.Data("FinalScore")
	}
	 
	// 以下取患者基本信息和就诊信息
	s PatientID = $p(objPaAdm,"^",1)
	s Papmi=PatientID
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s AdmitDate = $p(objPaAdm,"^",6)
	s AdmitTime = $p(objPaAdm,"^",7)
	s AdmitDateTime=AdmitDate_" "_AdmitTime
	//s AdmDateTime=$zd(AdmitDate,3)_" "_$zt(AdmitTime,1)
	s AdmitDateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",AdmitDateTime)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
                q:(DocName'="")&&(DoctorDesc'[DocName) ret
	s BedDR = $p(objPaAdm,"^",73)
	s CurrentBed = $s(BedDR '= "":$P($g(^PAWARD(+BedDR,"BED",$P(BedDR,"||",2))),"^",1),1:"")
	
	//(若想查询出所有的包括100分的在院病历，请将下面的判断的注释去掉；若要过滤满分病历，只显示有缺陷的则不用修改)
	/*if (Score=100)
	{
	 s RuleID=""
     s RuleTitle=""
     s StructID=""
     s StructTitle=""
     s EntryID=""
     s EntryTitle=""
     s TriggerNumber=""
     s EntryScore=""
     s DepartmentID=""
     s EmployeeID=""
     s EmployeeName=""
     s IsMultiErr=""
     s IsVeto=""
     s (StrDate,EndDate,Hours,FinishDate,OverFlag,FinishFlag)=""
     s ^CacheTemp("EPRQuality","AdmitSearch",AUniqueKey,WardDesc,AEpisodeID,$i(^CahceTemp)) = $lb(AEpisodeID,Grade,Score,Name,LocDesc,WardDesc,RegNo,MRNo,Gender,DoctorDesc,AdmitDateTime,RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto,StrDate,EndDate,Hours,FinishDate,OverFlag,FinishFlag)
 		}*/
	//else
	//{
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")
	
	s sc = result.Execute(AEpisodeID,ARuleIDs,"A")
	
	s coulumns=result.GetColumnCount()
	While (result.Next())
	{

	s RuleID=result.Data("RuleID")
    s RuleTitle=result.Data("RuleTitle")
    s StructID=result.Data("StructID")
    s StructTitle=result.Data("StructTitle")
    s EntryID=result.Data("EntryID")
    s EntryTitle=result.Data("EntryTitle")
    s TriggerNumber=result.Data("TriggerNumber")
    s EntryScore=result.Data("EntryScore")
    s DepartmentID=result.Data("DepartmentID")
    s EmployeeID=result.Data("EmployeeID")
    s EmployeeName=result.Data("EmployeeName")
    s IsMultiErr=result.Data("IsMultiErr")
    s IsVeto=result.Data("IsVeto")
    s ErrInfos=result.Data("ErrInfo")
    s SignUserDR=result.Data("SignUserDR")
    s ExamineDate=result.Data("ExamineDate")
    s TmpExamineDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)

    continue:(AExamineStaDate'="")&&(TmpExamineDate<AExamineStaDate)
    continue:(AExamineEndDate'="")&&(TmpExamineDate>AExamineEndDate)
    s SignUser = $s($g(SignUserDR)'="-1":$p($g(^SSU("SSUSR",+SignUserDR)),"^",2),1:"自动任务")
    s:($l(ErrInfos,";")'=0) Length = $l(ErrInfos,";")
	s:($l(ErrInfos,";")=0) Length = 1
	for i=1:1:Length
	{
		s ErrInfo = $p(ErrInfos,";",i)
	    s EntryTitle = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(EntryTitle)
		s StrDate = $p(ErrInfo,"^",3)
		s:($p(StrDate," ",2)="") StrDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",StrDate)
		s:($p(StrDate," ",2)'="") StrDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",StrDate)
		s EndDate= $p(ErrInfo,"^",4)
		s:($p(EndDate," ",2)="") EndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",EndDate)
		s:($p(EndDate," ",2)'="") EndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",EndDate)					
		s Hours = $p(ErrInfo,"^",5)
		s FinishDate = $p(ErrInfo,"^",6)
		s:($p(FinishDate," ",2)="") FinishDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",FinishDate)
		s:($p(FinishDate," ",2)'="") FinishDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",FinishDate)
	    s OverFlag = ""
		s:(Hours["-") OverFlag = "是"
		s:(Hours'="") Hours=$j(Hours,2,2)
		s FinishFlag="否"
		s:(FinishDate'="") FinishFlag="是"
		s ^CacheTemp("EPRQuality","AdmitSearch",AUniqueKey,WardDesc,AEpisodeID,$i(^CahceTemp)) = $lb(AEpisodeID,Grade,Score,Name,LocDesc,WardDesc,RegNo,MRNo,Gender,DoctorDesc,AdmitDateTime,RuleID,RuleTitle,StructID,StructTitle,EntryID,EntryTitle,TriggerNumber,EntryScore,DepartmentID,DepartmentName,EmployeeID,EmployeeName,IsMultiErr,IsVeto,StrDate,EndDate,Hours,FinishDate,OverFlag,FinishFlag,SignUser)
 		
	}
	
}	
	s ret = 1
	q ret
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","getPatientInfoByEntryIDNew","F","2008-01-01","2016-01-01","","U001,U002,U004,U006")
Query getPatientInfoByEntryIDNew(AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %String = "", APoolDRs As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "ARuleID,AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,PoolID,EntryID,Title") [ SqlProc ]
{
}

ClassMethod getPatientInfoByEntryIDNewExecute(ByRef qHandle As %Binary, AdmFlag As %String, AStartDate As %String, AEndDate As %String, AlocID As %String = "", APoolDRs As %String = "", AHospitalID As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(APoolDRs="") $$$OK
	
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	
	s:(AdmFlag="") AdmFlag="F"
	
	
	s ListPoolDR = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(APoolDRs,",")
	q:($listlength(ListPoolDR) = 0) 
	for Tmpdate=StartDate:1:EndDate{
		s EpisodeID=""
		for {
			s:(AdmFlag="F") EpisodeID= $o(^PAADMi("PAADM_AdmDate",Tmpdate,EpisodeID))
			s:(AdmFlag="G") EpisodeID=$o(^PAADMi("DischDate",Tmpdate,EpisodeID) )
			q:(EpisodeID="")
			s TmpobjPaAdm = $g(^PAADM(+EpisodeID))
	        continue:(TmpobjPaAdm = "") 
			s TmpAdmLocID = $p(TmpobjPaAdm,"^",4)
	        continue:(TmpAdmLocID = "") 
	        continue:((AlocID '= "")&&(TmpAdmLocID '= AlocID)) 
	     	s HospitalDR = $p(^CTLOC(+TmpAdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			for i = 1:1:$listlength(ListPoolDR)
			{
	          
			   s PoolDR = $listget(ListPoolDR,i)
			   q:(PoolDR = "")
			   
			   
			  
			   s objPool=##class(EPRmeta.Quality.QualityPool).%OpenId(PoolDR)
			   q:objPool=""
			   s Title=objPool.Title
			   s EntryID = ""
			   s Flag2=0
			   for {
		             
				    s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolDR,EntryID))
				    q:EntryID=""
			        s objEntrynew=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
				    s objStructDR=objEntrynew.StructDR
		
				    s RuleDR=objEntrynew.RuleDR
				    s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(RuleDR)
				    Continue:((objRule.Code '= AdmFlag)&&(objRule.Code'="A"))
	        
				    continue:Flag2>=1
				    s Flag2=Flag2+1
				    s ParRef=""
				    for {
		     
					s ParRef=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID," "_EntryID,ParRef))
					q:ParRef=""
					s Childsub=""
					for {
			
		                s Childsub=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID," "_EntryID,ParRef,Childsub))
						q:Childsub=""
						s objResultDet=$g(^DHCEPRQ.QualityResultD(ParRef,"Details",Childsub))
						continue:objResultDet=""
				
						
		              
						s flag = ..EpisodeIDRuleSearchDataNew(RuleDR,EpisodeID,repid,StartDate,EndDate,objStructDR,AdmFlag,PoolDR,EntryID,Title)
			   	
					    k ^CreateUserQualityStruct
						continue:(flag < 0)
				      }
					}
		
				}
			}
		}
	}
	// 按病区、医生排序
	s tmpWard = ""
	for {
		
		s tmpWard = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard))
		q:(tmpWard = "")
		
		s tmpDoctor = ""
		for {
			s tmpDoctor = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor))
			q:(tmpDoctor = "")
			
			s tmpAdmID = ""
			for {
				s tmpAdmID = $o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID))
				q:(tmpAdmID = "")
				s temEntryID=""
				for{
					s temEntryID=$o(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID,temEntryID))
					q:(temEntryID="")
				   	     
					     s Data = $g(^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",repid,tmpWard,tmpDoctor,tmpAdmID,temEntryID))
					     s ^CacheTemp(repid,ind) = Data
					     s ind = ind + 1	
				
				}
			}
		}
	}
	
	k ^CacheTempPatInfoSByEntry("EPRQuality","AdmitSearch",repid)
	
	
	Quit $$$OK
}

ClassMethod getPatientInfoByEntryIDNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getPatientInfoByEntryIDNewExecute ]
{
    Set uid=$LIST(qHandle,2)
 	Kill ^CacheTemp(uid) 	

	Quit $$$OK
}

ClassMethod getPatientInfoByEntryIDNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getPatientInfoByEntryIDNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)

	Quit $$$OK
}

/// new added by HKY
/// 查询质控条目(新)
/// w ##class(EPRservice.Quality.BOQualityReport).EpisodeIDRuleSearchDataNew(6,95,122,61178,63023,547,"F",6,18,"住院患者至少30天1次阶段小结(2天宽限),请及时书写!")
ClassMethod EpisodeIDRuleSearchDataNew(ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String, AStartDate As %String, AEndDate As %String, AStructID As %String, AdmFlag As %String, APoolID As %String, AEntryID As %String, ATitle As %String) As %String
{
	s ret = -1
	

	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	// Only process patient that allocate departmentl
    s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	
	s AdmWardID = $p(objPaAdm,"^",70)				
	q:(AdmWardID="") ret
	
	// Only process patient that allocate physician
	s AdmDocID = $p(objPaAdm,"^",9)
	s:((AdmDocID = "")||(AdmDocID="0")) AdmDocID = "-1"
	
				
	s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	q:(ResultID = "") ret
	
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret
	
    s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
    s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	//s Grade = $p($list(objResult,8),"@",1)
	//s Score = 100 - (+$list(objResult,2))

    s AdmitDate = $p($g(objPaAdm),"^",6)
    s DischDate = $p($g(objPaAdm),"^",17)

     // 以下取患者基本信息和就诊信息
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s Birthday = $p($g(^PAPER(+Papmi,"ALL")),"^",6)
	s:(Birthday '= "") Birthday = $zd(Birthday,3)
	s:(AdmitDate'="") AdmitDate = $zd(AdmitDate,3)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WardDesc = $p($g(^PAWARD(+AdmWardID)),"^",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	

	// Write data to assigned temp global
	s ^CacheTempPatInfoSByEntry("EPRQuality","PatientInfoSearchByEntryID",AUniqueKey,WardDesc,DoctorDesc,AEpisodeID,AEntryID) = $lb(ARuleID,AEpisodeID,Grade,Score,RegNo,MRNo,Name,Gender,Birthday,AdmLocID,LocDesc,AdmWardID,WardDesc,AdmDoctorID,DoctorDesc,AdmitDate,DischDate,Papmi,APoolID,AEntryID,ATitle)
	
	s ret = 1
	q ret
}

/// add by yhy
/// 质控医生工作量报表
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetWorkloadByQualityDate","2017-11-01","2017-11-11")						
Query GetWorkloadByQualityDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "CreateUserID,CreateUser,WorkCount:%Float,WorkNum:%Float,Num:%Float") [ SqlProc ]
{
}

ClassMethod GetWorkloadByQualityDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	//s ^tempyhy("GetWorkloadByQualityDate")=AStartDate_"^"_AEndDate
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetCreateUserList")
 	s sc = result.Execute(AStartDate,AEndDate)
	While (result.Next())
	{
		s CreateUserID = result.Data("CreateUserID")
		s CreateUser = result.Data("CreateUser")
		s ret = ..GetWorkCount(AStartDate,AEndDate,CreateUserID)
		s WorkCount = $p(ret,"^",1)
		s WorkNum = $p(ret,"^",2)
		s Num = $p(ret,"^",3)
		s Data=$lb(CreateUserID,CreateUser,WorkCount,WorkNum,Num)
		s ^CacheTemp(repid,ind) = Data
	    s ind = ind + 1	
	}
	q $$$OK
}

ClassMethod GetWorkloadByQualityDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkloadByQualityDateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetWorkloadByQualityDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkloadByQualityDateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// new added by yhy
/// 查询指定时间内的质控医生列表
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetCreateUserList","2017-11-01","2017-11-11")						
Query GetCreateUserList(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "CreateUserID,CreateUser")
{
}

ClassMethod GetCreateUserListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	for Tmpdate=StartDate:1:EndDate{
		s CreateUserId = ""
		for {
			s CreateUserId = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate,CreateUserId))
			q:CreateUserId=""
			s CreateUserID = $tr(CreateUserId," ","")
			s CreateUser = $p($g(^SSU("SSUSR",CreateUserID)),"^",2)
			s Data=$lb(CreateUserID,CreateUser)
			s ^CacheTemp(repid,ind) = Data
		    s ind = ind + 1	
		}
	}
	q $$$OK
}

ClassMethod GetCreateUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCreateUserListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetCreateUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCreateUserListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// new added by yhy
/// 查询指定时间内医生质控的病历数,质控总次数,质控问题个数
/// w ##class(EPRservice.Quality.BOQualityReport).GetWorkCount("2017-11-11","2017-11-16",1977)
ClassMethod GetWorkCount(AStartDate As %String, AEndDate As %String, AUserID As %String) As %String
{
	s ret = ""
	q:(AStartDate="")||(AEndDate="")||(AUserID="")
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s WorkCount = 0
	s WorkNum = 0
	s Num = 0
	for Tmpdate=StartDate:1:EndDate{
		s SpotCheckID = ""
		for {
			s SpotCheckID = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate," "_AUserID,SpotCheckID))
			q:SpotCheckID=""
			s WorkCount = WorkCount + 1
			s ObjSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(SpotCheckID)
			s EpisodeID = ObjSpotCheck.EpisodeID
			
			s TheSpotCheck = ""
			for {
				s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate," "_AUserID,SpotCheckID,TheSpotCheck))
				q:TheSpotCheck=""
				s WorkNum = WorkNum + 1
			}
		}
		
		s MessageID = ""
		for {
			s MessageID = $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateSenderUserID",Tmpdate," "_AUserID,MessageID))
			q:MessageID=""
			
			s ObjMessage = ##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
			s EpisodeID = ObjMessage.EpisodeID 
			continue:(EpisodeID="")
			s Num = Num + 1
		}
	}
	s ret = WorkCount_"^"_WorkNum_"^"_Num
	q ret
}

/// new added by yhy
/// 查询指定时间内的质控医生问题清单
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetProByCreateUser","2017-11-01","2017-11-11")						
Query GetProByCreateUser(AStartDate As %String, AEndDate As %String, AUserID As %String, ALocID As %String, AIsAllLocs As %String) As %Query(ROWSPEC = "Name,RegNo,EpisodeID,Message,ReceiverUser,CreateDate,ExecuteDate,PAAdmDepCodeDR,Doctor,UpDoc,MasDoc,Intern,SenderUser,EntryScore") [ SqlProc ]
{
}

ClassMethod GetProByCreateUserExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, ALocID As %String, AIsAllLocs As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	//s ^tempyhy("AlocID")=AlocID_"^"_AIsAllLocs
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	if (AUserID'="")
	{
		for Tmpdate=StartDate:1:EndDate{
			s MessageID = ""
			for {
				s MessageID = $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateSenderUserID",Tmpdate," "_AUserID,MessageID))
				q:MessageID=""
				s ObjMessage = ##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
				s EpisodeID = ObjMessage.EpisodeID
				continue:(EpisodeID="")
				s mCurrRow = $g(^PAADM(EpisodeID))
				s PAPMIDR = $p($g(mCurrRow),"^",1)
				continue:(PAPMIDR="")
				s RegNo = $p($g(^PAPER(+PAPMIDR,"PAT",1)),"^",1)
				s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
				s PAADMDepCode=$p($g(mCurrRow),"^",4)
				if (PAADMDepCode '= "")
				{
					s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
					s PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
				}
				///取三级医师接口
				s MainDocs = ##class(web.DHCDocMain).GetMainDoc(EpisodeID)
				s Doctor = $P(MainDocs,"^",3)   //一级
				s UpDoc = $P(MainDocs,"^",5)   //二级
				s MasDoc = $P(MainDocs,"^",7)  //三级
				s Intern = $P(MainDocs,"^",9)  //实习
				s Message = ObjMessage.Message
				s ResumeText = ObjMessage.ResumeText
				s CreateDate = ObjMessage.CreateDate
				s:(CreateDate'="") CreateDate = $zd(CreateDate,3)
				s CreateTime = ObjMessage.CreateTime
				s ExecuteDate = ObjMessage.ExecuteDate
				s:(ExecuteDate'="") ExecuteDate = $zd(ExecuteDate,3)
				s ExecuteTime = ObjMessage.ExecuteTime
				s ReceiverUserID = ObjMessage.ReceiverUserID
				s ReceiverUser = $p($g(^SSU("SSUSR",ReceiverUserID)),"^",2)	
				s SenderUserID = ObjMessage.SenderUserID
				s SenderUser = $p($g(^SSU("SSUSR",SenderUserID)),"^",2)	
				s EntryScore = ObjMessage.EntryScore
				s Data=$lb(Name,RegNo,EpisodeID,Message,ReceiverUser,CreateDate,ExecuteDate,PAAdmDepCodeDR,Doctor,UpDoc,MasDoc,Intern,SenderUser,EntryScore)
				s ^CacheTemp(repid,ind) = Data
			    s ind = ind + 1	
			}
		}	
	}
	else
	{
		for Tmpdate=StartDate:1:EndDate{
			s CreateTime = ""
			for {
				s CreateTime = $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateTime",Tmpdate,CreateTime))
				q:CreateTime=""
				s MessageID = ""
				for {
					s MessageID = $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateTime",Tmpdate,CreateTime,MessageID))
					q:MessageID=""
					s ObjMessage = ##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
					s EpisodeID = ObjMessage.EpisodeID 
					continue:(EpisodeID="")
					s mCurrRow = $g(^PAADM(EpisodeID))
					s PAPMIDR = $p($g(mCurrRow),"^",1)
					continue:(PAPMIDR="")
					s RegNo = $p($g(^PAPER(+PAPMIDR,"PAT",1)),"^",1)
					s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
					s PAADMDepCode=$p($g(mCurrRow),"^",4)
					continue:(AIsAllLocs'="Y")&&(ALocID'="")&&(ALocID'=PAADMDepCode)
					if (PAADMDepCode '= "")
					{
						s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
						s PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
					}
					///取三级医师接口
					s MainDocs = ##class(web.DHCDocMain).GetMainDoc(EpisodeID)
					s Doctor = $P(MainDocs,"^",3)   //一级
					s UpDoc = $P(MainDocs,"^",5)   //二级
					s MasDoc = $P(MainDocs,"^",7)  //三级
					s Intern = $P(MainDocs,"^",9)  //实习
					s Message = ObjMessage.Message
					s CreateDate = ObjMessage.CreateDate
					s:(CreateDate'="") CreateDate = $zd(CreateDate,3)
					s CreateTime = ObjMessage.CreateTime
					s ExecuteDate = ObjMessage.ExecuteDate
					s:(ExecuteDate'="") ExecuteDate = $zd(ExecuteDate,3)
					s ExecuteTime = ObjMessage.ExecuteTime
					s ReceiverUserID = ObjMessage.ReceiverUserID
					s ReceiverUser = $p($g(^SSU("SSUSR",ReceiverUserID)),"^",2)	
					s SenderUserID = ObjMessage.SenderUserID
					s SenderUser = $p($g(^SSU("SSUSR",SenderUserID)),"^",2)
					s EntryScore = ObjMessage.EntryScore
					s Data=$lb(Name,RegNo,EpisodeID,Message,ReceiverUser,CreateDate,ExecuteDate,PAAdmDepCodeDR,Doctor,UpDoc,MasDoc,Intern,SenderUser,EntryScore)
					s ^CacheTemp(repid,ind) = Data
				    s ind = ind + 1	
				}
			}
		}
	}
	q $$$OK
}

ClassMethod GetProByCreateUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProByCreateUserExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetProByCreateUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProByCreateUserExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// add by yhy  全院质控类型统计报表
/// 2017-01-19
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityCountByEntryID","2017-03-10","2017-03-10","1","")
Query GetQualityCountByEntryID(AStartDate As %String, AEndDate As %String, ARuleID As %String, AStructID As %String, AAction As %String) As %Query(ROWSPEC = "count:%Float,DischCount,percent,EntryTitle,StructName,Score,CountScore,SYCount,SYpercent,CategoryScore,CategoryName") [ SqlProc ]
{
}

ClassMethod GetQualityCountByEntryIDExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ARuleID As %String, AStructID As %String, AAction As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStartDate="")||(AEndDate="") $$$OK
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s SYCount = 0
	s DischCount = 0
	s counts1 = 0
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s DischCount = 0  //..GetDischCountByDischDate(AStartDate,AEndDate)
	s SYCount = 0 //..GetSYCount(AStartDate,AEndDate)
	
	//s ^CacheTemp("GetQualityCountByEntryID")=StartDate_"^"_EndDate_"^"_DischCount_"^"_SYCount_"!"_ARuleID_"!"_AStructID
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetQualityEntryIDByRuleID")
	s sc = result.Execute(ARuleID,AStructID)
	While (result.Next())
	{
		s EntryID = result.Data("EntryID")
		s EntryTitle = result.Data("EntryTitle")
		s StructName = result.Data("StructName")
		s StructID = result.Data("StructID")
		s EntryScore = result.Data("EntryScore")
		s count = 0
		
		s percent = 0
		s SYpercent = 0
		s DischDate = ""
		s EpisodeID = ""
		s CountScore = 0
		s CategoryScore = 0
		for {
			s EpisodeID = $o(^DHCEPRQ.QualityResultDetailI("IdxEntryEpisodeID"," "_EntryID,EpisodeID))
			q:(EpisodeID="")
			
			continue:(EpisodeID = " ")
			s EpisodeId = $TR(EpisodeID," ","")
			//s DischDate = $p($g(^PAADM(EpisodeId)),"^",17)
			
			//continue:((DischDate<StartDate)||(DischDate>EndDate))
			//s count1 = 0
			s num=""
			s num = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeId," "_EntryID,num))
			s ObjQualityResult = ##class(EPRinstance.Quality.QualityResult).%OpenId(num)
			s Action = ObjQualityResult.Action
			continue:Action'=AAction
			s num1=""
			for {
				s num1 = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeId," "_EntryID,num,num1))
				q:num1=""
				
				s ResultDetailID = num_"||"_num1
				s objResultDetail=##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(ResultDetailID)
				s EntryScore = objResultDetail.EntryScore
				s ExamCount = objResultDetail.ExamCount
				s TriggerDate = objResultDetail.TriggerDate
				continue:((TriggerDate<StartDate)||(TriggerDate>EndDate))
			
				s count1 = count1 + ExamCount
			}
			s count = count + 1
			s counts1 = counts1 + count 
		}
		continue:(count=0)
		s Score = counts1*EntryScore
		s objStruct = $g(^DHCEPRM.QualityStructD(StructID))
		s CategoryID = $list(objStruct,11)
		s objCategory = $g(^DHCEPRM.QualityCategoryD(CategoryID))
		s CategoryScore = "" //$list(objCategory,4)
		s CategoryName = "" //$list(objCategory,3)
		//s CountScore = CategoryScore*DischCount
		//s:DischCount'=0 percent = $s(count*100#DischCount=0:count*100/DischCount,1:$j(count*100/DischCount,2,2))
		s:SYCount'=0 SYpercent = $s(count*100#SYCount=0:count*100/SYCount,1:$j(count*100/SYCount,2,2))
		s percent = $s(count*100#counts1=0:count*100/counts1,1:$j(count*100/counts1,2,2))
		
		s Data = $lb(count,DischCount,percent,EntryTitle,StructName,Score,CountScore,SYCount,SYpercent,CategoryScore,CategoryName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1		
	}
	
	
	
	Quit $$$OK
}

ClassMethod GetQualityCountByEntryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityCountByEntryIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityCountByEntryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityCountByEntryIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// add by yhy
/// 2017-01-20
/// 手工条目统计报表（南方医院）
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetQualityEntryIDByRuleID","1","")
Query GetQualityEntryIDByRuleID(ARuleID As %String, AStructID As %String) As %Query(ROWSPEC = "EntryID,EntryTitle,StructName,EntryScore,StructID") [ SqlProc ]
{
}

ClassMethod GetQualityEntryIDByRuleIDExecute(ByRef qHandle As %Binary, ARuleID As %String, AStructID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	q:ARuleID="" $$$OK
	s EntryID = ""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:(EntryID = "")
		s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
		continue:(objEntry = "")
		s EntryIsActive = $list(objEntry,8)
		s EntryScore = $list(objEntry,4)
		continue:(EntryIsActive '= "Y")
		s StructID = $list(objEntry,3)
		continue:((StructID'=AStructID)&&(AStructID'=""))
		s PoolID = $list(objEntry,1)
		s EntryTitle = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		s StructName = ##Class(EPRmeta.Quality.QualityPool).GetStructByStructID(StructID)
		s Data = $lb(EntryID,EntryTitle,StructName,EntryScore,StructID)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	Quit $$$OK
}

ClassMethod GetQualityEntryIDByRuleIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityEntryIDByRuleIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityEntryIDByRuleIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityEntryIDByRuleIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

/// new added by yhy
/// 环节病案质量统计数据
/// w ##class(EPRservice.Quality.BOQualityReport).GetWorkCountByCreateDate("2017-11-11","2017-11-16",1977)
ClassMethod GetWorkCountByCreateDate(AStartDate As %String, AEndDate As %String) As %String
{
	s ret = ""
	q:(AStartDate="")||(AEndDate="")
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s WorkCount = 0  //指定时间内质控例数
	s WorkNum = 0  //指定时间内质控缺陷例数
	s Num = 0  //缺陷条目数
	for Tmpdate=StartDate:1:EndDate{
		s SpotCheckID = ""
		for {
			s SpotCheckID = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDate",Tmpdate,SpotCheckID))
			q:SpotCheckID=""
			s WorkCount = WorkCount + 1
			s ObjSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(SpotCheckID)
			s EpisodeID = ObjSpotCheck.EpisodeID
			s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(EpisodeID)
    		s LocID = $p(ObjRet,"^",1)
    		s UserID = $p(ObjRet,"^",3)
    		s ReceiverUserID = $o(^SSU("SSUSR",0,"CTPCP",UserID,""))
			s ^CacheTemp("WorkCount",LocID,"Count")=(+$g(^CacheTemp("WorkCount",LocID,"Count"))+1)
			s ^CacheTemp("DoctorWorkCount",LocID,ReceiverUserID,"Count")=(+$g(^CacheTemp("DoctorWorkCount",LocID,ReceiverUserID,"Count"))+1)
		}
		
		s CreateTime = ""
		for {
			s CreateTime = $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateTime",Tmpdate,CreateTime))
			q:CreateTime=""
			s MessageID = ""
			for {
				s MessageID =  $o(^EPRinstance.EPRSingleMessageI("IdxCreateDateTime",Tmpdate,CreateTime,MessageID))
				q:MessageID=""
				s ObjMessage = ##class(EPRinstance.EPRSingleMessage).%OpenId(MessageID)
				s EpisodeID = ObjMessage.EpisodeID 
				continue:(EpisodeID="")
				s mCurrRow = $g(^PAADM(EpisodeID))
				s LocID=$p($g(mCurrRow),"^",4)
				s EntryScore = ObjMessage.EntryScore
				s ExamCount = ObjMessage.ExamCount
				s Score = EntryScore*ExamCount
				s ReceiverUserID = ObjMessage.ReceiverUserID
				//s ReceiverUser = $p($g(^SSU("SSUSR",ReceiverUserID)),"^",2)
				s ^CacheTemp("EpisodeID",LocID,EpisodeID)=EpisodeID
				s ^CacheTemp("LocNum",LocID,"Count")=(+$g(^CacheTemp("LocNum",LocID,"Count"))+1)
				s ^CacheTemp("LocNum",LocID,"Score")=(+$g(^CacheTemp("LocNum",LocID,"Score"))+Score)
				s ^CacheTemp("DoctorNum",LocID,ReceiverUserID,"Count")=(+$g(^CacheTemp("DoctorNum",LocID,ReceiverUserID,"Count"))+1)
				s ^CacheTemp("DoctorNum",LocID,ReceiverUserID,"Score")=(+$g(^CacheTemp("DoctorNum",LocID,ReceiverUserID,"Score"))+Score)
			}
		}
	}
	s LocID = ""
	for {
		s LocID = $o(^CacheTemp("EpisodeID",LocID))
		q:LocID=""
		s ^CacheTemp("EPRQuality",LocID,"Count")=(+$g(^CacheTemp("EPRQuality",LocID,"Count"))+1)
		s EpisodeID=""
		for {
			s EpisodeID = $o(^CacheTemp("EpisodeID",LocID,EpisodeID))
			q:EpisodeID=""
			s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(EpisodeID)
    		s UserID = $p(ObjRet,"^",3)
    		s:UserID'="" ReceiverUserID = $o(^SSU("SSUSR",0,"CTPCP",UserID,""))
    		continue:ReceiverUserID=""
			s ^CacheTemp("EPRQualityDoctor",LocID,ReceiverUserID,"Count")=(+$g(^CacheTemp("EPRQualityDoctor",LocID,ReceiverUserID,"Count"))+1)

		}
	}
	k ^CacheTemp("EpisodeID")
	s ret = WorkCount
	q ret
}

/// add by yhy
/// 全院各科室环节病案质量统计表
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetLocWorkByQualityDate","2017-11-01","2017-11-11")						
Query GetLocWorkByQualityDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "LocName,WorkCount,WorkNum,Num,Score") [ SqlProc ]
{
}

ClassMethod GetLocWorkByQualityDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	//s ^tempyhy("GetWorkloadByQualityDate")=AStartDate_"^"_AEndDate
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	k ^CacheTemp("WorkCount")
	k ^CacheTemp("EPRQuality")
	k ^CacheTemp("LocNum")
	s result = ..GetWorkCountByCreateDate(AStartDate,AEndDate)
	s LocID = ""
	for {
		s LocID = $o(^CacheTemp("WorkCount",LocID))
		q:LocID=""
		s LocName = $p($g(^CTLOC(LocID)),"^",2)
		s LocName = $p(LocName,"-",2)
		s WorkCount=0,WorkNum=0,Num=0,Score=0
		s WorkCount = $g(^CacheTemp("WorkCount",LocID,"Count"))
		s WorkNum = $g(^CacheTemp("EPRQuality",LocID,"Count"))
		s Num = $g(^CacheTemp("LocNum",LocID,"Count"))
		s Score = $g(^CacheTemp("LocNum",LocID,"Score"))
		s Data=$lb(LocName,WorkCount,WorkNum,Num,Score)
		s ^CacheTemp(repid,ind) = Data
	    s ind = ind + 1	
	}
	q $$$OK
}

ClassMethod GetLocWorkByQualityDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocWorkByQualityDateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetLocWorkByQualityDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocWorkByQualityDateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// add by yhy
/// 医生环节病案质量统计表
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetLocWorkByQualityDate","2017-11-01","2017-11-11")						
Query GetDoctorWorkByQualityDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "LocName,DoctorName,WorkCount,WorkNum,Num,Score") [ SqlProc ]
{
}

ClassMethod GetDoctorWorkByQualityDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	//s ^tempyhy("GetWorkloadByQualityDate")=AStartDate_"^"_AEndDate
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	k ^CacheTemp("DoctorWorkCount")
	k ^CacheTemp("EPRQualityDoctor")
	k ^CacheTemp("DoctorNum")
	s result = ..GetWorkCountByCreateDate(AStartDate,AEndDate)
	s LocID = ""
	for {
		s LocID = $o(^CacheTemp("DoctorWorkCount",LocID))
		q:LocID=""
		s DoctorID = ""
		for {
			s DoctorID = $o(^CacheTemp("DoctorWorkCount",LocID,DoctorID))
			q:DoctorID=""
			s LocName = $p($g(^CTLOC(LocID)),"^",2)
			s LocName = $p(LocName,"-",2)
			s DoctorName = $p($g(^SSU("SSUSR",DoctorID)),"^",2)
			s WorkCount=0,WorkNum=0,Num=0,Score=0
			s WorkCount = $g(^CacheTemp("DoctorWorkCount",LocID,DoctorID,"Count"))
			s WorkNum = $g(^CacheTemp("EPRQualityDoctor",LocID,DoctorID,"Count"))
			s Num = $g(^CacheTemp("DoctorNum",LocID,DoctorID,"Count"))
			s Score = $g(^CacheTemp("DoctorNum",LocID,DoctorID,"Score"))
			s Data=$lb(LocName,DoctorName,WorkCount,WorkNum,Num,Score)
			s ^CacheTemp(repid,ind) = Data
		    s ind = ind + 1
		}	
	}
	q $$$OK
}

ClassMethod GetDoctorWorkByQualityDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorWorkByQualityDateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDoctorWorkByQualityDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorWorkByQualityDateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// new added by yhy
/// 终末质控明细报表（南方医院）
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetDisQualityDetail","2017-11-01","2017-11-11")						
Query GetDisQualityDetail(AStartDate As %String, AEndDate As %String, ALocID As %String, AIsAllLocs As %String) As %Query(ROWSPEC = "Name,RegNo,EpisodeID,Message,ReceiverUser,CreateDate,PAAdmDepCodeDR,Doctor,UpDoc,MasDoc,Intern,SenderUser,EntryScore,StructName") [ SqlProc ]
{
}

ClassMethod GetDisQualityDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, AIsAllLocs As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)

	s BlankEpisodeID = ""
	for {
		s BlankEpisodeID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_1,BlankEpisodeID))
		q:(BlankEpisodeID = "")
		s EpisodeID = $tr(BlankEpisodeID," ","")
		s flag = ..DisQualityDetailData(ALocID,AIsAllLocs,1,EpisodeID,StartDate,EndDate,repid)
		continue:(flag < 0)
	}
	
	s EpisodeID = ""
	for {
	    s EpisodeID = $o(^CacheTemp("EPRQuality","DisQualityDetail",repid,EpisodeID))
	    q:(	EpisodeID = "")
	    s Key = ""
	    for {
		   s Key = $o(^CacheTemp("EPRQuality","DisQualityDetail",repid,EpisodeID,Key))
		   q:(Key = "")
		   s EntryID = ""
		   for {
		       s EntryID = $o(^CacheTemp("EPRQuality","DisQualityDetail",repid,EpisodeID,Key,EntryID))
		       q:(EntryID = "")
		       s Data = $g(^CacheTemp("EPRQuality","DisQualityDetail",repid,EpisodeID,Key,EntryID))
		       s ^CacheTemp(repid,ind) = Data
		       s ind = ind + 1
		   }		   
		}
	}
	k ^CacheTemp("EPRQuality","DisQualityDetail",repid)
	q $$$OK
}

ClassMethod GetDisQualityDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisQualityDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDisQualityDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisQualityDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod DisQualityDetailData(ALocID As %String, AIsAllLocs As %String, ARuleID As %String, AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AUniqueKey As %String) As %String
{
	s ret = -1

	s RuleDesc = $list($g(^DHCEPRM.QualityRuleD(+ARuleID)),2)
	
	s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,ResultID))
		q:(ResultID = "")
		
		s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 
		s Action = objResult.Action
		continue:Action'="D"
		s ExamineDate = objResult.ExamineDate
		continue:(ExamineDate = "")
		s ExamineDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)
		continue:(AStartDate '= "")&&(ExamineDate < AStartDate)
		continue:(AEndDate '= "")&&(ExamineDate > AEndDate)
		// 报告人
		s RecorderID = objResult.SignUserDR
		s Recorder = $s($g(RecorderID)'="-1":$p($g(^SSU("SSUSR",+RecorderID)),"^",2),1:"自动任务")
				
		s objPaAdm = $g(^PAADM(+AEpisodeID))	
		
		s DisLocID = $p(objPaAdm,"^",4)					//出院科室
		continue:(DisLocID = "")
		continue:((ALocID '= "")&&(DisLocID '= ALocID)&&(AIsAllLocs'="Y"))
		
		s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生

		s Papmi = $p(objPaAdm,"^",1)
		s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
		//continue:(ARegNo '= "")&&(RegNo '= ARegNo)
		
		s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)	
		//continue:(APatientName '= "")&&(Name '[ APatientName)
		///取三级医师接口
		s MainDocs = ##class(web.DHCDocMain).GetMainDoc(AEpisodeID)
		s Doctor = $P(MainDocs,"^",3)   //一级
		s UpDoc = $P(MainDocs,"^",5)   //二级
		s MasDoc = $P(MainDocs,"^",7)  //三级
		s Intern = $P(MainDocs,"^",9)  //实习		
		//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
		s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,"I",.ErrMsg)
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		s DoctorDesc = $s(AdmDoctorID '= "":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
		
		s key = ""
		do {
			s objDetail = objResult.Details.GetNext(.key)
		  	if (objDetail '= "")
		  	{ 
		  		s EntryID = objDetail.EntryDR
		  		
		  		// 如果这个条目被删除了，则不参与计分
				continue:($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
				s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(+EntryID)
		  		continue:(objEntry = "")
		  		s StructID = objEntry.StructDR
		  		s objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		  		continue:(objStruct = "")
		  		s StructName = objStruct.StandardName
		  		s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
		  		s ExamCount =  objDetail.ExamCount
		  		s EntryScore = objDetail.EntryScore
		  		s ResumeText = objDetail.ResumeText				
				s ^CacheTemp("EPRQuality","DisQualityDetail",AUniqueKey,AEpisodeID,key,EntryID) = $lb(Name,RegNo,AEpisodeID,EntryTitle,DoctorDesc,$zd(ExamineDate,3),LocDesc,Doctor,UpDoc,MasDoc,Intern,Recorder,EntryScore,StructName)
		  	}
		} while(key '= "")
		
		d objResult.%Close()
	}
	
	s ret = 1
	q ret
}

/// 医政临床运营接口：根据指标编码获取不合格患者信息
/// 入参：指标编码 EMRCode
/// 返回值：指标编码 EMRCode，患者就诊号 EpisodeID，起始时间 StartDT、截止时间 EndDT、完成时间 FinishDT、当前科室 CurrentDT
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetAutoQRByEMRCode","EMR-U001")
Query GetAutoQRByEMRCode(EMRCode, RuleDR = 6) As %Query(ROWSPEC = "EMRCode,EpisodeID,StartDT,EndDT,FinishDT,CurrentLocName")
{
}

ClassMethod GetAutoQRByEMRCodeExecute(ByRef qHandle As %Binary, EMRCode, RuleDR = 6) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(EMRCode="") $$$OK
	
	s Code=..EMRCodeMaping(EMRCode)
	
	///获取指定规则质控结果详细Id 列表  (EPRinstance.Quality.QualityResultDetail),返回字符串形式的detailId, 分割符"^" 例(2048||1^2048||2)
	s detailList=##class(EPRservice.Quality.DataAccess.BOQualityResult).GetAdmAutoTaskResultDetailID(RuleDR)
	
	s nums=$l(detailList)
	
	for index=1:1:nums
	{
		s detailId=$p(detailList,"^",index)
		
		s objDetail=##class(EPRinstance.Quality.QualityResultDetail).%OpenId(detailId)
		
		q:(objDetail="")
		
		s EpisodeID=objDetail.EpisodeID
		
		s locInfo=..GetLocInfoByEpisodeID(EpisodeID)
		
		s locName=$p(locInfo,"^",2)
		
		s locId=$p(locInfo,"^",1)
		
		s EntryID=objDetail.EntryDR
		
		s ErrorInfo=..ErrorInfoParse(objDetail.ErrorInfo)  //解析错误信息
		
		s PoolDR=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID).PoolDR
		
		continue:(PoolDR'=Code)
		
		s Title=##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
		
		s length=$l(ErrorInfo,"/")
		for i=1:1:length
		{
			s DTInfo=$p(ErrorInfo,"/",i)
			
			s startDT=$p(DTInfo,"^",1)
			
			s endDT=$p(DTInfo,"^",2)
			
			s finishDT=$p(DTInfo,"^",3)
			s:(finishDT="") finishDT="未书写"
			
			s Data=$lb(Title,EpisodeID,startDT,endDT,finishDT,locName)
		
			s ^CacheTemp(repid,ind)=Data
		
			s ind=ind+1
		}
		
	}
	

	
	
	
	
	Quit $$$OK
}

ClassMethod GetAutoQRByEMRCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAutoQRByEMRCodeExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetAutoQRByEMRCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAutoQRByEMRCodeExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 质控条目映射
/// debug:w ##class(EPRservice.Quality.BOQualityReport).EMRCodeMaping()
ClassMethod EMRCodeMaping(Code)
{
	q $o(^DHCEPRM.QualityPoolI("IdxEMRCode"," "_Code,""))
}

/// 解析Resultdetail里的errorInfo
/// 返回"startDT^endDT" 多条以“/” 分隔
/// debug:w ##class(EPRservice.Quality.BOQualityReport).EMRCodeMaping()
ClassMethod ErrorInfoParse(errorInfo)
{
	s ret="参数错误"
	
	q:(errorInfo="") ret
	
	s ret=""
	
	
	//只有一条错误信息的情况
	if errorInfo'[";"
	{
		//$p(errorInfo,"^",2,3) 为起止时间 ,$p(errorInfo,"^",5) 为完成时间（如果完成了）
		s ret=$p(errorInfo,"^",2,3)_"^"_$p(errorInfo,"^",5)
		q ret
	}
	
	
	//多条以“/” 分隔
	s length=$l(errorInfo,";")
	
	for i=1:1:length
	{
		s DTInfo=$p(errorInfo,";",i)
		s ErrorDT=$p(DTInfo,"^",2,3)_"^"_$p(errorInfo,"^",5)
		s ret=ret_ErrorDT_"/"
	}
	
	s ret=$e(ret,1,*-1)
	
	q ret
}

/// 通过就诊号获取患者科室信息
/// 返回 科室Id^科室名
/// debug:w ##class(EPRservice.Quality.BOQualityReport).GetLocInfoByEpisodeID(1)
ClassMethod GetLocInfoByEpisodeID(EpisodeID)
{
	s ret=""
	
	q:(EpisodeID="") ret=""
	
	s admInfo = $g(^PAADM(EpisodeID))
	s locId=$p($g(admInfo),"^",4)
	
	s locDesc = "无"
	if (locId '= "")
	{
		s locDesc = $p($g(^CTLOC(locId)),"^",2)
		s:locDesc["-" locDesc=$p(locDesc,"-",2)
	}
	
	s ret=locId_"^"_locDesc
	
	q ret
}

/// KPI Query
/// 入院记录24小时完成率报表
/// 21年10月8号10点53分
/// 入参：起始时间 StartDate 结束时间：EndDate 科室ID LocID (时间为出院时间)
/// 结果：LocID、LocDesc、PatCount、FinOnTimeCount、FinOnTimeRate、UnFinOnTimeCount
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","FinOnTimeReport1","2019-02-01","2021-09-30","")
Query FinOnTimeReport1(StartDate As %String, EndDate As %String, LocID As %String, PoolCode As %String = "U073", DeathFlag = 0) As %Query(ROWSPEC = "LocID,LocDesc,PatCount,FinOnTimeCount,UnFinTimeCount,FinOnTimeRate")
{
}

ClassMethod FinOnTimeReport1Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, PoolCode As %String = "U073", DeathFlag = 0) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(StartDate="")||(EndDate="") $$$OK
	
	///根据就诊表数据统计查询时间段触犯的“24小时入院记录”未完成数据
	
	//日期格式转换
	s startDate=$zdh(StartDate,3)
	
	s endDate=$zdh(EndDate,3)
	
	//统计数据初始化
	s (PatCount,FinOnTimeCount,FinOnTimeRate,UnFinOnTimeCount)=0
	
	for date=startDate:1:endDate
	{
		s episodeId=""
		for
		{
			s episodeId=$o(^PAADMi("DischDate",date,episodeId))	//就诊号
			q:episodeId=""
			
			if DeathFlag=1
			{
				s DeathDT=##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(episodeId,"11365||1",1)
			}
			
			//患者科室信息
			s admInfo=$g(^PAADM(episodeId))
			
			s locId=$p(admInfo,"^",4)
			
			continue:(LocID'="")&&(locId'=LocID)
			
			s PatCount=PatCount+1  //统计科室出院总人数
			//检查是否触犯指定条目
			s ErrorFlag=..GetCheckResultByEpisodeID(episodeId,PoolCode)
	
			s:ErrorFlag="1" UnFinOnTimeCount=UnFinOnTimeCount+1 //统计触犯该条目患者数量
			
			//临时global记录各个科室的数据
			s ^tempLocData("locData","locID",locId)=$g(^tempLocData("locData","locID",locId))+1 //科室患者数
			
			s:(ErrorFlag="1") ^tempLocData("locData","locID",locId,"UnFinCount")=$g(^tempLocData("locData","locID",locId,"UnFinCount"))+1  //科室未完成数
			
		}
		
	}
	
	//如果该段时间患者总数为0
	q:(PatCount=0) $$$OK
	
	///输出第一行总计内容：
	///查询时间段内该规则完成数
	s FinOnTimeCount=PatCount-UnFinOnTimeCount
	
	s Data=$lb(0,"合计",PatCount,FinOnTimeCount,UnFinOnTimeCount,(FinOnTimeCount/PatCount)*100_"%")

	s ^CacheTemp(repid,ind)=Data

	s ind=ind+1
	
	
	///输出其余科室统计数据
	s locID=""
	
	for
	{
		s locID=$o(^tempLocData("locData","locID",locID))
		q:(locID="")
		
		s (DischNums,FinNums,UnFinNums,FinRate)=0
		
		s LocDesc = $p($g(^CTLOC(locID)),"^",2)
		
		//科室出院人数
		s DischNums=$g(^tempLocData("locData","locID",locID))
		
		continue:DischNums=0
		
		s UnFinNums=$g(^tempLocData("locData","locID",locID,"UnFinCount"))
		
		s:(UnFinNums="") UnFinNums=0
		
		s FinNums=DischNums-UnFinNums
		
		s FinRate=(FinNums/DischNums)*100
	
		s Data=$lb(locID,LocDesc,DischNums,FinNums,UnFinNums,FinRate_"%")

		s ^CacheTemp(repid,ind)=Data

		s ind=ind+1
	} 
	
	k ^tempLocData("locData","locDesc")
	
	Quit $$$OK
}

ClassMethod FinOnTimeReport1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinOnTimeReport1Execute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod FinOnTimeReport1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinOnTimeReport1Execute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
 	
	Quit $$$OK
}

/// KPI Query
/// 入院记录24小时完成率明细报表
/// 21年10月8号17点17分
/// 入参：科室ID LocID 起始时间 StartDate 结束时间：EndDate FinType 查询类型 PatCount 即查询全部数据，FinOnTimeCount 查询已完成患者数据、 UnFinOnTimeCount 查询未完成患者数据
/// 结果：LocID、LocDesc、PatCount、FinOnTimeCount、FinOnTimeRate、UnFinOnTimeCount
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","ShowFinReportDetail","","2019-02-01","2021-09-30","PatCount")
Query ShowFinReportDetail(LocID As %String, StartDate As %String, EndDate As %String, FinType As %String = "PatCount", PoolCode As %String = "U073") As %Query(ROWSPEC = "EpisodeID,LocID,LocDesc,Name,MRNo,RegNo,Gender,Age,AdmDateTime,DisDateTime")
{
}

ClassMethod ShowFinReportDetailExecute(ByRef qHandle As %Binary, LocID As %String, StartDate As %String, EndDate As %String, FinType As %String = "PatCount", PoolCode As %String = "U073") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(StartDate="")||(EndDate="") $$$OK
	
	//日期格式转换
	s startDate=$zdh(StartDate,3)
	
	s endDate=$zdh(EndDate,3)
	
	for date=startDate:1:endDate
	{
		s EpisodeID=""
		for
		{
			s EpisodeID=$o(^PAADMi("DischDate",date,EpisodeID))	//就诊号
			q:EpisodeID=""
			
			//患者科室信息
			s admInfo=$g(^PAADM(EpisodeID))
			
			s locId=$p(admInfo,"^",4)
			
			continue:(LocID'="")&&(locId'=LocID)
			
			//检查是否触犯指定条目
			s ErrorFlag=..GetCheckResultByEpisodeID(EpisodeID,PoolCode)
			
			continue:(FinType="FinOnTimeCount")&&(ErrorFlag="1")
			
			continue:(FinType="UnFinOnTimeCount")&&(ErrorFlag'="1")
			
			//科室
			s LocDesc = $p($g(^CTLOC(locId)),"^",2)
			
			s PAPMIDR = $p($g(admInfo),"^",1)   //登记号  患者基本信息表rowid
			//姓名
			s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
			
			//病案号
			s MRNo=$P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22) 
			
			//登记号
			s OBJPat=##class(User.PAPatMas).%OpenId(PAPMIDR)
			s RegNo=OBJPat.PAPMINo //登记号
			
			//性别
			s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
			s Gender = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
			
			//年龄
			s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,EpisodeID,"","")
			
			//入院日期
			s PAAdmDate = $p($g(admInfo),"^",6)
			s PAAdmTime = $p($g(admInfo),"^",7)
			
			s AdmDateTime=$zd(PAAdmDate,3)_" "_$zt(PAAdmTime,1)
			
			//出院日期
			s DischDate = $p($g(admInfo),"^",17)
			s DischTime = $p($g(admInfo),"^",18)
			
			s DisDateTime=$zd(DischDate,3)_" "_$zt(DischTime,1)
			
			s Data=$lb(EpisodeID,locId,LocDesc,Name,MRNo,RegNo,Gender,Age,AdmDateTime,DisDateTime)
			
			s ^CacheTemp(repid,ind)=Data
			
			s ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

ClassMethod ShowFinReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShowFinReportDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ShowFinReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShowFinReportDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过就诊号以及entryId是否触犯某条质控条目
/// EpisodeID 就诊号 PoolId 质控条目ID 
/// ret=0 未触犯,ret=1 触犯
/// debug: w ##Class(EPRservice.Quality.BOQualityReport).GetCheckResultByEpisodeID("389","S086")
ClassMethod GetCheckResultByEpisodeID(EpisodeID, PoolId)
{
	s ret=0
	
	q:(EpisodeID="")||(PoolId="") ret
	
	s EntryId=""
	
	for
	{
		s EntryId=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID,EntryId))
		q:(EntryId="")
		s Id=$tr(EntryId," ","")
		
		s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(Id)
		continue:(objEntry="")
		continue:(PoolId'=objEntry.PoolDR)
		
		s resultId=""
		for
		{
			s resultId=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID,EntryId,resultId))
			q:(resultId="")
			s ret=1
			q:(ret=1)
		}
	}
	
	q ret
}

Query GetOPCheckData(LocID, StartDate, EndDate) As %Query(ROWSPEC = "locDesc:%String,locNums:%Integer,checkNums:%Integer,checkRate:%Integer")
{
}

ClassMethod GetOPCheckDataExecute(ByRef qHandle As %Binary, LocID, StartDate, EndDate) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s:(LocID=$c(0)) LocID=""
	s:(StartDate=$c(0)) StartDate=""
	s:(EndDate=$c(0)) EndDate=""
	
	q:(StartDate="")||(EndDate="") $$$OK
	s StDate = $zdh(StartDate,3),endDate=$zdh(EndDate,3)
	//^PAADMi("TypeDate"
	
	
	for i = StDate:1:endDate 
	{
		s AdmTime = ""
		for {	
			s AdmTime = $o(^PAADMi("TypeDate","O",i,AdmTime))
			
			q:(AdmTime="")
			
			s PAADMRowID=""
			
			for
			{
				s PAADMRowID=$o(^PAADMi("TypeDate","O",i,AdmTime,PAADMRowID))
				
				q:(PAADMRowID="")
				
				s locId=$p(^PAADM(PAADMRowID),"^",4)
				continue:(LocID'="")&&(locId'=LocID)
				s ^temp("LocData",locId)=$g(^temp("LocData",locId))+1  //科室数量统计
				
				//是否质控
				s checkFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(PAADMRowID,"AO")
				s:(checkFlag>0) ^temp("LocData",locId,"checked")=$g(^temp("LocData",locId,"checked"))+1
				
				
			}
			
			
			
		}
		
		for {	
			s AdmTime = $o(^PAADMi("TypeDate","E",i,AdmTime))
			
			q:(AdmTime="")
			
			s PAADMRowID=""
			
			for
			{
				s PAADMRowID=$o(^PAADMi("TypeDate","E",i,AdmTime,PAADMRowID))
				
				q:(PAADMRowID="")
				
				s locId=$p(^PAADM(PAADMRowID),"^",4)
				continue:(LocID'="")&&(locId'=LocID)
				s ^temp("LocData",locId)=$g(^temp("LocData",locId))+1  //科室数量统计
				
				//是否质控
				s checkFlag=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(PAADMRowID,"AO")
				s:(checkFlag>0) ^temp("LocData",locId,"checked")=$g(^temp("LocData",locId,"checked"))+1
			}
			
			
			
		}
	}
	s locId=""
	for
	{
		s locId=$o(^temp("LocData",locId))
		q:(locId="")
		
		s locDesc=$p($g(^CTLOC(locId)),"^",2)
		
		//科室病历数
		s locNums=$g(^temp("LocData",locId))
		s:(locNums="") locNums=0
		continue:(locNums=0)
		//质控数
		s checkNums=$g(^temp("LocData",locId,"checked"))
		s:(checkNums="") checkNums=0
		//质控率
		s checkRate=0
		
		s:(locNums'=0) checkRate=$j((checkNums/locNums)*100,1,0)
		
		s Data=$lb(locDesc,locNums,checkNums,checkRate)
			
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
	}
	
	k ^temp("LocData")
	
	Quit $$$OK
}

ClassMethod GetOPCheckDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPCheckDataExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPCheckDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPCheckDataExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// KPI Query
/// 入院记录24小时完成率报表
/// 21年10月8号10点53分
/// 入参：起始时间 StartDate 结束时间：EndDate 科室ID LocID (时间为出院时间)
/// 结果：LocID、LocDesc、PatCount、FinOnTimeCount、FinOnTimeRate、UnFinOnTimeCount
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","FinOnTimeReport1","2021-09-01","2021-10-25","","Z007",1)
Query FinOnTimeReport2(StartDate As %String, EndDate As %String, LocID As %String, PoolCode As %String = "U073", DeathFlag = 0) As %Query(ROWSPEC = "LocID,LocDesc:%String,PatCount:%Integer,FinOnTimeCount:%Integer,UnFinTimeCount:%Integer,FinOnTimeRate:%String") [ SqlProc ]
{
}

ClassMethod FinOnTimeReport2Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, PoolCode As %String = "U073", DeathFlag = 0) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s:(StartDate=$c(0)) StartDate=""
	s:(EndDate=$c(0)) EndDate=""
	s:(LocID=$c(0)) LocID=""
	s:(DeathFlag=$c(0)) DeathFlag=""
	s:(PoolCode=$c(0)) PoolCode=""
	
	
	q:(StartDate="")||(EndDate="") $$$OK
	
	///根据就诊表数据统计查询时间段触犯的“24小时入院记录”未完成数据
	
	//日期格式转换
	s startDate=$zdh(StartDate,3)
	
	s endDate=$zdh(EndDate,3)
	
	//统计数据初始化
	s (PatCount,FinOnTimeCount,FinOnTimeRate,UnFinOnTimeCount)=0
	
	for date=startDate:1:endDate
	{
		s episodeId=""
		for
		{
			s episodeId=$o(^PAADMi("DischDate",date,episodeId))	//就诊号
			q:episodeId=""
			
			if DeathFlag=1
			{
				s DeathDT=##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(episodeId,"5139||1",1)
				continue:(DeathDT="")
			}
			
			//患者科室信息
			s admInfo=$g(^PAADM(episodeId))
			
			s locId=$p(admInfo,"^",4)
			
			continue:(LocID'="")&&(locId'=LocID)
			
			s PatCount=PatCount+1  //统计科室出院总人数
			//检查是否触犯指定条目
			s ErrorFlag=..GetCheckResultByEpisodeID2(episodeId,PoolCode)
			s entryId=$tr($p(ErrorFlag,"^",2)," ","")
			s ErrorFlag=$p(ErrorFlag,"^",1)
		
			s TimeInfo=##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(episodeId,entryId,"")
			s eflag=$p(TimeInfo,"^",1)
			
			
			s:(ErrorFlag="1")&&(eflag=-1) UnFinOnTimeCount=UnFinOnTimeCount+1 //统计触犯该条目患者数量
			
			//临时global记录各个科室的数据
			s ^tempLocData("locData","locID",locId)=$g(^tempLocData("locData","locID",locId))+1 //科室患者数
			
			s:(ErrorFlag="1")&&(eflag=-1) ^tempLocData("locData","locID",locId,"UnFinCount")=$g(^tempLocData("locData","locID",locId,"UnFinCount"))+1  //科室未完成数
			
		}
		
	}
	
	//如果该段时间患者总数为0
	q:(PatCount=0) $$$OK
	
	///输出第一行总计内容：
	///查询时间段内该规则完成数
	s FinOnTimeCount=PatCount-UnFinOnTimeCount
	
	/*s Data=$lb(0,"合计",PatCount,FinOnTimeCount,UnFinOnTimeCount,(FinOnTimeCount/PatCount)*100_"%")

	s ^CacheTemp(repid,ind)=Data

	s ind=ind+1*/
	
	
	///输出其余科室统计数据
	s locID=""
	
	for
	{
		s locID=$o(^tempLocData("locData","locID",locID))
		q:(locID="")
		
		s (DischNums,FinNums,UnFinNums,FinRate)=0
		
		s LocDesc = $p($g(^CTLOC(locID)),"^",2)
		
		//科室出院人数
		s DischNums=$g(^tempLocData("locData","locID",locID))
		
		continue:DischNums=0
		
		s UnFinNums=$g(^tempLocData("locData","locID",locID,"UnFinCount"))
		
		s:(UnFinNums="") UnFinNums=0
		
		s FinNums=DischNums-UnFinNums
		
		s FinRate=$j((FinNums/DischNums)*100,1,0)
	
		s Data=$lb(locID,LocDesc,DischNums,FinNums,UnFinNums,FinRate_"%")

		s ^CacheTemp(repid,ind)=Data

		s ind=ind+1
	} 
	k ^tempLocData("locData")
	
	Quit $$$OK
}

ClassMethod FinOnTimeReport2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinOnTimeReport2Execute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod FinOnTimeReport2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinOnTimeReport2Execute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
 	
	Quit $$$OK
}

/// KPI Query
/// 入院记录24小时完成率明细报表
/// 21年10月8号17点17分
/// 入参：科室ID LocID 起始时间 StartDate 结束时间：EndDate FinType 查询类型 PatCount 即查询全部数据，FinOnTimeCount 查询已完成患者数据、 UnFinOnTimeCount 查询未完成患者数据
/// 结果：LocID、LocDesc、PatCount、FinOnTimeCount、FinOnTimeRate、UnFinOnTimeCount
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","ShowFinReportDetail","67","2021-09-01","2021-09-30","UnFinOnTimeCount","Z007")
Query ShowFinReportDetail2(LocID As %String, StartDate As %String, EndDate As %String, FinType As %String = "PatCount", PoolCode As %String = "U073") As %Query(ROWSPEC = "EpisodeID:%String,LocID:%Integer,LocDesc:%String,Name:%String,MRNo:%String,RegNo:%String,Gender:%String,Age:%String,AdmDateTime:%String,DisDateTime:%String,DT1:%String,DT2:%String") [ SqlProc ]
{
}

ClassMethod ShowFinReportDetail2Execute(ByRef qHandle As %Binary, LocID As %String, StartDate As %String, EndDate As %String, FinType As %String = "PatCount", PoolCode As %String = "U073") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s:(LocID=$c(0)) LocID=""
	s:(StartDate=$c(0)) StartDate=""
	s:(EndDate=$c(0)) EndDate=""
	s:(FinType=$c(0)) FinType=""
	s:(PoolCode=$c(0)) PoolCode=""
	
	q:(StartDate="")||(EndDate="") $$$OK
	
	//日期格式转换
	s startDate=$zdh(StartDate,3)
	
	s endDate=$zdh(EndDate,3)
	
	for date=startDate:1:endDate
	{
		s EpisodeID=""
		for
		{
			s EpisodeID=$o(^PAADMi("DischDate",date,EpisodeID))	//就诊号
			q:EpisodeID=""
			
			//患者科室信息
			s admInfo=$g(^PAADM(EpisodeID))
			
			s locId=$p(admInfo,"^",4)
			
			continue:(LocID'="")&&(locId'=LocID)
			
			//检查是否触犯指定条目
			s ErrorFlag=..GetCheckResultByEpisodeID2(EpisodeID,PoolCode)
			
			continue:(FinType="FinOnTimeCount")&&($p(ErrorFlag,"^",1)="1")
			
			continue:(FinType="UnFinOnTimeCount")&&($p(ErrorFlag,"^",1)'="1")
			
			//科室
			s LocDesc = $p($g(^CTLOC(locId)),"^",2)
			
			s PAPMIDR = $p($g(admInfo),"^",1)   //登记号  患者基本信息表rowid
			//姓名
			s Name = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
			
			//病案号
			s MRNo=$P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22) 
			
			//登记号
			s OBJPat=##class(User.PAPatMas).%OpenId(PAPMIDR)
			s RegNo=OBJPat.PAPMINo //登记号
			
			//性别
			s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
			s Gender = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
			
			//年龄
			s Age  = ##Class(EPRservice.Quality.DataGather.AdmInfo).Age(PAPMIDR,EpisodeID,"","")
			
			//入院日期
			
			s AdmDateTime=##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(EpisodeID)
	
			
			//出院日期
			s DisDateTime=##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(EpisodeID)
			
			s entryId=$tr($p(ErrorFlag,"^",2)," ","")
			//截止时间和实际完成时间
			;s TimeInfo=..GetRuleTimeInfo(EpisodeID,PoolCode)
			s TimeInfo=##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(EpisodeID,entryId,"")
			
			continue:($p(TimeInfo,"^",1)'=-1)
			
			s DT1=$p(TimeInfo,"^",4)
			
			s DT2=$p(TimeInfo,"^",6)
			
			s Data=$lb(EpisodeID,locId,LocDesc,Name,MRNo,RegNo,Gender,Age,AdmDateTime,DisDateTime,DT1,DT2)
			
			s ^CacheTemp(repid,ind)=Data
			
			s ind=ind+1
		}
		
	}
	
	Quit $$$OK
}

ClassMethod ShowFinReportDetail2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShowFinReportDetail2Execute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ShowFinReportDetail2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShowFinReportDetail2Execute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过就诊号以及entryId是否触犯某条质控条目
/// EpisodeID 就诊号 PoolId 质控条目ID 
/// ret=0 未触犯,ret=1 触犯
/// debug: w ##Class(EPRservice.Quality.BOQualityReport).GetCheckResultByEpisodeID("389","S086")
ClassMethod GetCheckResultByEpisodeID2(EpisodeID, PoolId)
{
	s ret=0
	
	q:(EpisodeID="")||(PoolId="") ret
	
	s EntryId=""
	
	for
	{
		s EntryId=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID,EntryId))
		q:(EntryId="")
		s Id=$tr(EntryId," ","")
		
		s objEntry=##class(EPRmeta.Quality.QualityEntry).%OpenId(Id)
		continue:(objEntry="")
		continue:(PoolId'=objEntry.PoolDR)
		
		s resultId=""
		for
		{
			s resultId=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID,EntryId,resultId))
			q:(resultId="")
			s ret=1_"^"_EntryId
			q:(ret'=0)
		}
	}
	
	q ret
}

/// 门诊病历质控医生工作量报表
/// StartDate 开始时间（质控时间） EndDate 结束时间 SSGroup 医师安全组
/// UserName 医师名字 Nums 质控病历份数
/// WZL:2021年11月25日17:22:18
/// debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetOPWorkLoad","2021-11-25","2021-11-25")	
Query GetOPWorkLoad(StartDate As %String, EndDate As %String, SSGroup = "310") As %Query(ROWSPEC = "UserName:%String,Nums:%String") [ SqlProc ]
{
}

ClassMethod GetOPWorkLoadExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, SSGroup = "310") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(StartDate="")||(EndDate="") $$$OK
	k ^tempWorkLoad("workLoad")
	s st=$zdh(StartDate,3)
	s et=$zdh(EndDate,3)
	
	for date=st:1:et
	{
		s userId=""
		for
		{
			s userId=$o(^SSU("SSUSR",0,"Group",SSGroup,userId))
			q:(userId="")
		
			s resultId=""
			for
			{
				s resultId=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",date," "_userId,resultId))
				q:(resultId="")
				
				s ^tempWorkLoad("workLoad",userId)=$g(^tempWorkLoad("workLoad",userId))+1
			}
		}
		
	}
	
	s userId=""
	for
	{
		s userId=$o(^tempWorkLoad("workLoad",userId))
		q:(userId="")
		s nums=$g(^tempWorkLoad("workLoad",userId))
		s:(nums="") nums=0
		s userName=$p(^SSU("SSUSR",userId),"^",2)
		
		s Data=$lb(userName,nums)
			
		s ^CacheTemp(repid,ind)=Data
		
		s ind=ind+1
	}
	
	k ^tempWorkLoad("workLoad")
	
	Quit $$$OK
}

ClassMethod GetOPWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPWorkLoadExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPWorkLoadExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 质控员工作统计报表
/// Others:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetCheckDoctorWorkByQualityDate","2022-03-01","2022-03-28","A")						
Query GetCheckDoctorWorkByQualityDate(AStartDate As %String, AEndDate As %String, Action As %String = "", CheckCreater As %String = "") As %Query(ROWSPEC = "CreaterUserid,CreaterUser,CreaterDate,PAADMDepCode,PAAdmDepCodeDR,PAPMIName,MedicareNo,PAAdmDate,PADischgeTime,PAAdmDocCodeDR,actionDesc") [ SqlProc ]
{
}

ClassMethod GetCheckDoctorWorkByQualityDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, Action As %String = "", CheckCreater As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s actions=Action
	s:Action="" actions="A^D^KS"
	s qHandle = $lb(0,repid,0)
	k ^CacheTemp("EPRQuality","CheckDoctorWorkData",repid)
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	for i=1:1:$l(actions,"^")
  	{
		s action=$p(actions,"^",i)
		q:action=""
	for temDate=StartDate:1:EndDate
		{
			
		    s SpotCheck = ""
		    for {
			s SpotCheck=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDate",temDate,SpotCheck))
		    s SpotCheck=$tr(SpotCheck," ","")
		    q:SpotCheck=""
		    s sublist=""
		    for
		    {
			    s sublist=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDate",temDate,SpotCheck,sublist))
		        s sublist=$tr(sublist," ","")
		        q:sublist=""
		        s objspotdetail=##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(SpotCheck_"||"_sublist)
		        s EpisodeID=objspotdetail.EpisodeID
		        s AdmType=$P($g(^PAADM(EpisodeID)),"^",2)
			    continue:AdmType'="I"
			    s xse = $P($g(^PAADM(EpisodeID)),"^",75)
			    continue:(xse'="")
			    s AdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
			    continue:(AdmStatus="C"  )
			    s flag=..GetWorkDataByCreateDate(EpisodeID,StartDate,EndDate,action,CheckCreater,repid)
			    continue:(flag < 0)
		    }
		    }
	}	
	}
	
	
	s userid=""
	for
	{
		s userid=$o(^CacheTemp("EPRQuality","CheckDoctorWorkData",repid,userid))
		q:userid=""
		s episodeid="",enum=0,usernum=0
			for
			{
				s episodeid=$o(^CacheTemp("EPRQuality","CheckDoctorWorkData",repid,userid,episodeid))
		        q:episodeid=""
		        s enum=enum+1
				s Data=$g(^CacheTemp("EPRQuality","CheckDoctorWorkData",repid,userid,episodeid))
				s ^CacheTemp(repid,ind) = Data
		        s ind = ind + 1
				}
			s usernum=usernum+enum	
           s Data=$lb("","--------","","","小计","",usernum,"","","","","","")
		   s ^CacheTemp(repid,ind) = Data
		   s ind = ind + 1
		 
		}
		
	k ^CacheTemp("EPRQuality","CheckDoctorWorkData",repid)
	q $$$OK
}

ClassMethod GetCheckDoctorWorkByQualityDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorWorkByQualityDateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetCheckDoctorWorkByQualityDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorWorkByQualityDateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##class(EPRservice.Quality.BOQualityReport).GetWorkCountByCreateDate("2017-11-11","2017-11-16",1977)
ClassMethod GetWorkDataByCreateDate(EpisodeID As %String, AStartDate As %String, AEndDate As %String, Action As %String = "", CheckCreater As %String = "", AUniqueKey As %String) As %String
{
	s ret = -1
	s actionDesc=""
	
	s ResultInfo=..GetCreateUserAndDateByEpisodeID(EpisodeID,Action)
	q:ResultInfo="" ret 
	s CreaterDate=$p(ResultInfo,"^",1)
	s CreaterDate=$zd(CreaterDate,3)
	s CreaterUserid=$p(ResultInfo,"^",2)
	s CreaterUser=$p(ResultInfo,"^",3)
	q:(CheckCreater'="")&&(CreaterUser'[CheckCreater) ret
	s:Action="A" actionDesc="环节质控"
	s:Action="D" actionDesc="终末质控"
	s:Action="KS" actionDesc="首页质控"
	s mCurrRow = $g(^PAADM(EpisodeID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	if (PAADMDepCode '= "") 
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
		s:PAAdmDepCodeDR["-" PAAdmDepCodeDR = $p(PAAdmDepCodeDR,"-",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	s MedicareNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIDR,"I","",.ErrMsg)
	//s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "") 
	{
		s PAAdmTime = $zt(PAAdmTime,3)
		s PAAdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PAAdmTime)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6) 
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
		s PAAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PAAdmDate)
	}
	s PADischgeDate=$P($g(^PAADM(EpisodeID)),"^",17)
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
		s PADischgeDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
	}
	s PADischgeTime=$P($g(^PAADM(EpisodeID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
		s PADischgeTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PADischgeTime)
	}
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	s:(PAADMDocCode'="") DocCode = $o(^SSU("SSUSR",0,"CTPCP",PAADMDocCode,""))
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	s ^CacheTemp("EPRQuality","CheckDoctorWorkData",AUniqueKey,CreaterUserid,EpisodeID) = $LB(CreaterUserid,CreaterUser,CreaterDate,PAADMDepCode,PAAdmDepCodeDR,PAPMIName,MedicareNo,PAAdmDate,PADischgeDate,PAAdmDocCodeDR,actionDesc)
	s ret=1
	q ret
}

/// 得到质控员和质控时间 Date_"^"_UserID_"^"_User
/// 返回：质控时间^质控员用户ID^质控员名称
ClassMethod GetCreateUserAndDateByEpisodeID(AEpisodeID As %String, Action As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s SpotCheck = "",Date="",UserID="",User=""
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s TheSpotCheck = ""
	for {
		s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",RowID,TheSpotCheck),-1)
		q:TheSpotCheck=""
		s DetailID = RowID_"||"_TheSpotCheck
		s objSpotCheckDetail = ##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(DetailID)
		s action=objSpotCheckDetail.Action
		continue:(Action'=action)&&(Action'="")
		s UserID= objSpotCheckDetail.CreateUser
		s Date=objSpotCheckDetail.CreateDate
		s SpotCheck = TheSpotCheck
		q:(Action=action)&&(Action'="")
	}
	q:SpotCheck="" ret
	if (UserID'="")
	{
		if ($g(^SSU("SSUSR",UserID))="")
		{
			s ssuerid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserID,""))
			q:ssuerid=""
			s UserID=ssuerid
			s User = $p($g(^SSU("SSUSR",UserID)),"^",2)
			}
		else
		{
		s User = $p($g(^SSU("SSUSR",UserID)),"^",2)
		}
		}
	s:SpotCheck'="" ret=Date_"^"_UserID_"^"_User
	 
	q ret
}

/// 时效性指标统计报表
/// 统计24小时入院记录完成率，24小时手术记录完成率，24小时病案首页完成率
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","SXFinishRate","2022-04-01","2022-04-14","")
Query SXFinishRate(AStartDate As %String, AEndDate As %String, ALocID As %String) As %Query(ROWSPEC = "LocDesc:%String,DocId:%String,DocDesc:%String,InpNum:%Integer,DischNum:%Integer,FinNum1:%Integer,UnFinNum1:%Integer,FinNum2:%Integer,UnFinNum2:%Integer,FinNum3:%Integer,UnFinNum3:%Integer,FinNum4:%Integer,UnFinNum4:%Integer") [ SqlProc ]
{
}

ClassMethod SXFinishRateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	
	s startDate=$zdh(AStartDate,3),endDate=$zdh(AEndDate,3)
	
	k ^templocdoc
	
	k ^tempSXDetailInfo
	
	///入院24小时、手术24小时未完成率统计,时间按入院时间，统计医生住院患者总数
	for date1=startDate:1:endDate
	{
		s PAADMRowID = ""
		for {	
			s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",date1,PAADMRowID))
			q:(PAADMRowID = "")
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			
			//获取科室
			
			s admInfo=$g(^PAADM(PAADMRowID))
			s locId=$p(admInfo,"^",4)
			continue:(ALocID'="")&&(locId'=ALocID)
			
			//获取医生
			s docId=$p($g(admInfo),"^",9)
			continue:(docId="")
			s ^templocdoc(locId,docId,"inp")=$g(^templocdoc(locId,docId,"inp"))+1
			
			s checkFlag=##Class(EPRservice.Quality.DataGather.AdmInfo).RecordFilter(PAADMRowID,"60|2\62|3")
			if (checkFlag)
			{
				//获取入院时间
				s regDT=##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(PAADMRowID)
				s f1=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsDoneInTime(PAADMRowID,"13^14^15",regDT,"",24,"","F","N")
				
				s flag1=$p(f1,"^",1)
				
				s:(flag1="-1") ^templocdoc(locId,docId,"f1")=$g(^templocdoc(locId,docId,"f1"))+1,^tempSXDetailInfo(docId,"f1",PAADMRowID)=""
			}
			
			
			
			//获取手术时间
			s opDT=##Class(EPRservice.Quality.DataGather.AdmInfo).GetOPArrangesEnd(PAADMRowID)
			s f2=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHMultiIsDoneInTime2(PAADMRowID,"18|手术记录",opDT,"",24,"","F","C","N")
			
			s flag2=$p(f2,"^",1)			
			
			s:(flag2="-1") ^templocdoc(locId,docId,"f2")=$g(^templocdoc(locId,docId,"f2"))+1,^tempSXDetailInfo(docId,"f2",PAADMRowID)=""
		} 
	}
	
	
	///出院24小时、病案首页24小时未完成率，时间按出院时间
	for date2=startDate:1:endDate
	{
		s PAADMRowID = ""
		for {	
			s PAADMRowID = $o(^PAADMi("DischDate",date2,PAADMRowID))
			q:(PAADMRowID = "")
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= "D")
			
			//获取科室
			s admInfo=$g(^PAADM(PAADMRowID))
			s locId=$p(admInfo,"^",4)
			continue:(ALocID'="")&&(locId'=ALocID)
			
			
			//获取医生
			s docId=$p($g(admInfo),"^",9)
			continue:(docId="")
			s dischDT=##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(PAADMRowID)
			
			s ^templocdoc(locId,docId,"disch")=$g(^templocdoc(locId,docId,"disch"))+1
			
			//出院24小时未完成率统计
			s f3=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsDoneInTime(PAADMRowID,"14^15^23^24^25",dischDT,"",24,"","F","N")
			
			s flag3=$p(f3,"^",1)
			
			s:(flag3="-1") ^templocdoc(locId,docId,"f3")=$g(^templocdoc(locId,docId,"f3"))+1,^tempSXDetailInfo(docId,"f3",PAADMRowID)=""
			
			//病案首页24小时未完成率
			s f4=##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).RHSingleIsDoneInTime(PAADMRowID,"5",dischDT,"",24,"","F","N")
			
			s flag4=$p(f4,"^",1)
			
			s:(flag4="-1") ^templocdoc(locId,docId,"f4")=$g(^templocdoc(locId,docId,"f4"))+1,^tempSXDetailInfo(docId,"f4",PAADMRowID)=""
			
		} 
	}
	
	s locId=""
	
	for
	{
		s locId=$o(^templocdoc(locId))
		q:(locId="")
		
		s locDesc=$p($g(^CTLOC(locId)),"^",2)
		
		s docId=""
		for
		{
			s docId=$o(^templocdoc(locId,docId))
			q:(docId="")
			
			s docDesc=$p($g(^CTPCP(docId,1)),"^",2)
			
			s inpNum=$g(^templocdoc(locId,docId,"inp")) //入院患者数量
			s dischNum=$g(^templocdoc(locId,docId,"disch"))  //出院患者数
			
			s:(inpNum="") inpNum=0
			s:(dischNum="") dischNum=0
			
			s unfinNum1=$g(^templocdoc(locId,docId,"f1"))  //入院患者24小时入院记录未完成数
			s unfinNum2=$g(^templocdoc(locId,docId,"f2"))  //入院患者24小时手术记录未完成数
			
			s:(unfinNum1="") unfinNum1=0
			s:(unfinNum2="") unfinNum2=0
			
			s finNum1=inpNum-unfinNum1
			s finNum2=inpNum-unfinNum2
			
			s unfinNum3=$g(^templocdoc(locId,docId,"f3"))  //出院患者24小时出院记录未完成数
			s unfinNum4=$g(^templocdoc(locId,docId,"f4"))  //出院患者24小时病案首页未完成数
			
			s:(unfinNum3="") unfinNum3=0
			s:(unfinNum4="") unfinNum4=0
			
			s finNum3=dischNum-unfinNum3
			s finNum4=dischNum-unfinNum4
			
			s Data=$lb(locDesc,docId,docDesc,inpNum,dischNum,finNum1,unfinNum1,finNum2,unfinNum2,finNum3,unfinNum3,finNum4,unfinNum4)
			
			s ^CacheTemp(repid,ind) = Data
		   	s ind = ind + 1
			
		}
	}
	
	q $$$OK
	
	k ^templocdoc
}

ClassMethod SXFinishRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SXFinishRateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SXFinishRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SXFinishRateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","SXDetailInfo","368","f1")
Query SXDetailInfo(DocId As %String, ACheckCondition As %String) As %Query(ROWSPEC = "Name:%String,RegNo:%String,MedicalNo:%String,Gender:%String,Age:%String,admType:%String,LocDesc:%String,DIschLocDesc:%String,DocDesc:%String,RegDT:%String,RegFinishDT:%String") [ SqlProc ]
{
}

ClassMethod SXDetailInfoExecute(ByRef qHandle As %Binary, DocId As %String, ACheckCondition As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	
	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	
	s PAADMRowID=""
	for{
	
		s PAADMRowID=$o(^tempSXDetailInfo(DocId,ACheckCondition,PAADMRowID))
		q:(PAADMRowID="")
		
		s docDesc=$p($g(^CTPCP(DocId,1)),"^",2)  //经管医师
		
		s PAPMIDR=$p($g(^PAADM(PAADMRowID)),"^",1)
		
		s RegNo= $p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1) //登记号
		
		s MedicareNo =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIDR,"I","",.ErrMsg)  //住院号
		
		s Name=##Class(EMRservice.SystemData).GetEpisodeInfoByItemName("Name",PAADMRowID)  //姓名
		
		;s Age=##Class(EMRservice.SystemData).GetEpisodeInfoByItemName("Age",PAADMRowID)  //年龄
		s Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,"",2)
		
		s Gender=##Class(EMRservice.SystemData).GetEpisodeInfoByItemName("Gender",PAADMRowID)  //性别
		
		s PayType=##Class(EMRservice.SystemData).GetEpisodeInfoByItemName("PayType",PAADMRowID)  //支付方式
		
		s AdmDept=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(PAADMRowID,Hospital)  //入院科室
		
		s AdmDeptDesc=""
		s:(AdmDept'="") AdmDeptDesc = $p($g(AdmDept),"^",3)
		
		s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(PAADMRowID,Hospital) //出院科室
		s DisDeptDesc=""
	   	s DisDeptDesc = $p($g(tmpDisDept),"^",3)
	   	
	   	//入院时间
	   	s regDT=##Class(EPRservice.Quality.DataGather.AdmInfo).GetRegTime1(PAADMRowID)
	   	
	   	//入院记录书写时间
	   	s finDT=##Class(EPRservice.Quality.EmrCheckRule.Template).GetSingleTempalteInfo(PAADMRowID,55,"保存")
	   	
	   	s finDT=$p(finDT,$c(1),2,3)
	   	
	   	s finDT=$tr(finDT,$c(1)," ")
	   	
	   	s Data=$lb(Name,RegNo,MedicareNo,Gender,Age,PayType,AdmDeptDesc,DisDeptDesc,docDesc,regDT,finDT)
	   	
	   	s ^CacheTemp(repid,ind) = Data
	   	s ind = ind + 1
			
	}		
		
	
	
	
	
	Quit $$$OK
}

ClassMethod SXDetailInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SXDetailInfoExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SXDetailInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SXDetailInfoExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// 理法用药一致性报表
/// 科室、质控数、一致数、一致性
/// 入参：出院开始时间、结束时间、科室
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetLFQualityInfo","2022-02-01","2022-02-28","") 
Query GetLFQualityInfo(AStartDate As %String, AEndDate As %String, ALocID As %String, AState As %String = "D") As %Query(ROWSPEC = "LocDesc:%String,LocID:%String,CheckNum:%Integer,Num:%Integer,Rate:%Float") [ SqlProc ]
{
}

ClassMethod GetLFQualityInfoExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, AState As %String = "D") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStartDate="")||(AEndDate="") $$$OK
	
	;s ^temp("GetLFQualityInfo_params")=AStartDate_":"_AEndDate_":"_ALocID_":"_AState
	
	K ^tempLFQualityData
	
	s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
	
	s MethodName="GetEpisodeDisManualFlag",dateNode="DischDate"
	
	s:(AState="A") MethodName="GetEpisodeAdmManualFlag",dateNode="PAADM_AdmDate"
	
	
	for i = StDate:1:EndDate {
		s PAADMRowID = ""
		for {
			s PAADMRowID = $o(^PAADMi(dateNode,i,PAADMRowID))
			q:(PAADMRowID = "")
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AState '= AdmStatus)
			
			
			s mCurrRow = $g(^PAADM(PAADMRowID))
			s LocID=$p($g(mCurrRow),"^",4)
			continue:(ALocID'="")&&(ALocID'=LocID)
			
			//统计科室质控数
			s flag=$CLASSMETHOD("EPRservice.Quality.DataAccess.BOQualitySpotCheck",MethodName,PAADMRowID)
			s flag1=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(PAADMRowID,"CQC")
			s:(AState="D")&&((flag="Y")||(flag1>0)) ^tempLFQualityData(LocID,"checkNum")=$g(^tempLFQualityData(LocID,"checkNum"))+1
			s:(AState="A")&&(flag'="") ^tempLFQualityData(LocID,"checkNum")=$g(^tempLFQualityData(LocID,"checkNum"))+1
			
			s lfFlag=##Class(EPRservice.Quality.Ajax.GetQualityResult).GetCheckResultByEpisodeID2(PAADMRowID,"S240")
			
			s:($p(lfFlag,"^",1)="1") ^tempLFQualityData(LocID,"Num")=$g(^tempLFQualityData(LocID,"Num"))+1
		}
	}
	
	s locID=""
	
	for
	{
		s locID=$o(^tempLFQualityData(locID))
		q:(locID="")
		
		s checkNum=$g(^tempLFQualityData(locID,"checkNum"))
		s num=$g(^tempLFQualityData(locID,"Num"))
		
		
		s:(checkNum="") checkNum=0
		s:(num="") num=0
		continue:(checkNum=0)
		
		s rate=$j(num/checkNum,1,2)*100
		
		s locDesc = $p($g(^CTLOC(locID)),"^",2)
		
		
		
		s Data=$lb(locDesc,locID,checkNum,num,rate)
		s ^CacheTemp(repid,ind) = Data
		s ind=ind+1
	}
	
	k ^tempLFQualityData
	
	Quit $$$OK
}

ClassMethod GetLFQualityInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLFQualityInfoExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetLFQualityInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLFQualityInfoExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetLFQualityDetail","2022-02-01","2022-02-28","84")
Query GetLFQualityDetail(AStartDate As %String, AEndDate As %String, ALocID As %String, AState As %String = "D") As %Query(ROWSPEC = "DischDate,LocDesc,MedicalNo,DocName,LfFlag") [ SqlProc ]
{
}

ClassMethod GetLFQualityDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, AState As %String = "D") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStartDate="")||(AEndDate="") $$$OK
	
	
	
	s MethodName="GetEpisodeDisManualFlag",dateNode="DischDate"
	
	s:(AState="A") MethodName="GetEpisodeAdmManualFlag",dateNode="PAADM_AdmDate"
	
	s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
	
	for i = StDate:1:EndDate {
		s PAADMRowID = ""
		for {
			s PAADMRowID = $o(^PAADMi(dateNode,i,PAADMRowID))
			q:(PAADMRowID = "")
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AState '= AdmStatus)
			
			
			s mCurrRow = $g(^PAADM(PAADMRowID))
			s LocID=$p($g(mCurrRow),"^",4)
			continue:(ALocID'="")&&(ALocID'=LocID)
			
			s flag=$CLASSMETHOD("EPRservice.Quality.DataAccess.BOQualitySpotCheck",MethodName,PAADMRowID)
			s flag1=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeCrossManualFlag(PAADMRowID,"CQC")
			continue:(AState="D")&&(flag'="Y")&&(flag1<1)
			continue:(AState="A")&&(flag="")
			
			//出院时间
			s PADischgeDate = $zd(i,3)
			s PADischgeDate = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
			
			//科室
			s locDesc = $p($g(^CTLOC(LocID)),"^",2)
			
			
			//住院号
			s medicalNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(PAADMRowID,"I")
			
			//主治医师
			s PAADMDocCode=$p($g(mCurrRow),"^",9)
			s docName = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
			
			s lfFlag=##Class(EPRservice.Quality.Ajax.GetQualityResult).GetCheckResultByEpisodeID2(PAADMRowID,"S240")
			
			s flag="否"
			s:($p(lfFlag,"^",1)="1") flag="是" 
			continue:(flag'="是")
			s Data=$lb(PADischgeDate,locDesc,medicalNo,docName,flag)
			s ^CacheTemp(repid,ind) = Data
			s ind=ind+1
			
		}
	}
	Quit $$$OK
}

ClassMethod GetLFQualityDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLFQualityDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetLFQualityDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLFQualityDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// Desc:手工质控报表
/// Input:StartDate 开始时间、EndDate 结束时间 LocID 科室 AdmType 患者类型 O 门(急)诊
/// OutPut:LocDesc:LocID:RegNo:Name:Gender:AdmDate:Doctor:Title:CheckDoctor
/// Creator:WZL 2022年6月29日
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetManualReport","2022-06-01","2022-06-01","","O")
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetManualReport","2022-02-01","2022-02-28","84")
Query GetManualReport(AStartDate As %String, AEndDate As %String, ALocID As %Text, AdmType As %String = "I", Action As %String = "A", AHospitalID As %String = "") As %Query(ROWSPEC = "EpisodeID,Name,Gender,LocID,LocDesc,MedicalNo,RegNo,DoctorID,DoctorDesc,AdmDate,DischDate,CheckDoctor,Title,ResumeText,Score,Count") [ SqlProc ]
{
}

ClassMethod GetManualReportExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %Text, AdmType As %String = "I", Action As %String = "A", AHospitalID As %String = "") As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AStartDate="")||(AEndDate="") $$$OK
	
	;s ^temp("shdjkad")=AStartDate_":"_AEndDate_":"_ALocID_":"_AdmType_":"_Action
	
	s:(ALocID=$c(0)) ALocID=""
	
	s StartDate=$zdh(AStartDate,3)
	s EndDate=$zdh(AEndDate,3)
	//门诊质控手工评分
	//住院手工评分
	//环节手工评分
	//终末手工评分
	//数据来源于质控结果表
	
	k ^Temp("EPRQualityAdm")
	//^DHCEPRQ.QualityResultI("IdxRuleEpisodeID",RuleDR,EpisodeID,ID)
	
	s BKEpisodeID=""
	
	for
	{
		s BKEpisodeID=$o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," 1",BKEpisodeID))
		q:(BKEpisodeID="")
		
		s EpisodeID=$tr(BKEpisodeID," ","")
		s objPaAdm = $g(^PAADM(+EpisodeID))
		s AdmLocID = $p(objPaAdm,"^",4)		
		s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
		//过滤时间、过滤退号的、以及和Action不同的，AdmType 不同的患者 LocID 科室
		s FitterResult=##class(EPRservice.Quality.DataGather.AdmInfo).AdmFitter(EpisodeID,ALocID,StartDate,EndDate,Action,AdmType)
		
		continue:(FitterResult=-1)
		s ^Temp("EPRQualityAdm",EpisodeID)=EpisodeID
		//获取患者信息
		s AdmBaseInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetAdmBaseInfo(EpisodeID)
		
		//获取质控医师、
		
		s CheckUser=""
		
		if (AdmType="I")
		{
			s CheckUser=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateAdmUserByEpisodeID(EpisodeID)
		}else
		{
			s CheckUser=##class(EPRservice.Quality.DataAccess.BOQualityResult).GetOPCheckUser(EpisodeID)
		}
		
		s $list(AdmBaseInfo,*+1)=CheckUser
		
		s ResultID=""
		
		for
		{
			s ResultID=$o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," 1",BKEpisodeID,ResultID))
			q:(ResultID="")
			
			//获取质控问题
			s detailID=""
			
			for
			{
				s detailID=$o(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,detailID))
				q:(detailID="")
				
				s ID=ResultID_"||"_detailID
				
				//s Entry=$tr(BKEntry," ","")
				s Detail=##class(EPRinstance.Quality.QualityResultDetail).%OpenId(ID)
				continue:(Detail="")
				
				s Entry=Detail.EntryDR
				
				s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(Entry)
				
				s info=AdmBaseInfo
				
				s $list(info,*+1)=EntryTitle
				
				s ResumeText=Detail.ResumeText
				s Score=##class(EPRmeta.Quality.QualityEntry).%OpenId(Entry).Score
				s Count=Detail.ExamCount
				s $list(info,*+1)=ResumeText
				s $list(info,*+1)=Score
				s $list(info,*+1)=Count
				s Data=info
				
				s ^CacheTemp(repid,ind) = Data
				
		   		s ind = ind + 1
			}
		}
		
	}
	
	///增加质控满分数据
    //^DHCEPRQ.QualitySpotCheckI
    //IdxEpisodeID
	 s bkEpisodeID=""
	 for
	 {
		 s bkEpisodeID=$o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID",bkEpisodeID))
		 q:(bkEpisodeID="")
		 
		 s EpisodeID=$tr(bkEpisodeID," ","")
		 
	  	 s FitterResult=##class(EPRservice.Quality.DataGather.AdmInfo).AdmFitter(EpisodeID,ALocID,StartDate,EndDate,Action,AdmType)
	  	 
	  	 continue:(FitterResult=-1)
		 
		 continue:$g(^Temp("EPRQualityAdm",EpisodeID))'=""
	  	 
	  	 s BaseInfo=##class(EPRservice.Quality.DataGather.AdmInfo).GetAdmBaseInfo(EpisodeID)
	  	 
	  	 s CheckUser=""
	  
		 s CheckUser=##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetCreateAdmUserByEpisodeID(EpisodeID)
		  
		 s $list(BaseInfo,*+1)=CheckUser
		 
		 s $list(BaseInfo,*+1)=""
		  
		 s $list(BaseInfo,*+1)=""
	      
	     s ^CacheTemp(repid,ind) = BaseInfo
	   
	     s ind = ind + 1
		 
	 }
 
 	k ^Temp("EPRQualityAdm")
	
	Quit $$$OK
}

ClassMethod GetManualReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManualReportExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetManualReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManualReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// 门诊质控医生工作量统计
/// AActions=""或AActions="AdmDate"按就诊日期统计;AActions="QualityDate"按质控日期统计
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetMZDoctorWorkload","2022-06-09","2022-06-19","")
Query GetMZDoctorWorkload(AStartDate As %String, AEndDate As %String, AActions As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "SignUserDR,SignUserName,count") [ SqlProc ]
{
}

ClassMethod GetMZDoctorWorkloadExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AActions As %String = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	k ^CacheTemp("GetMZDoctorWorkload",repid)
	// 空字符串或"AdmDate"->就诊日期统计
	if (AActions="AdmDate")||(AActions="")
	{
		s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
		for AdmDateCurr = StDate:1:EndDate 
		{
			s LocID=""
			for
			{
				s LocID = $o(^PAADMi("AdmTypeCurrLoc","O",LocID))
				s objCtLoc = $g(^CTLOC(+LocID))
		        s HspID = $P(objCtLoc,"^",22)
		        continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)
				q:(LocID="")
				s time = ""
				for 
				{
					s time = $o(^PAADMi("AdmTypeCurrLoc","O",LocID,AdmDateCurr,time))
					q:(time = "")
					s PAADMRowID = ""
					for 
					{
						s PAADMRowID =  $o(^PAADMi("AdmTypeCurrLoc","O",LocID,AdmDateCurr,time,PAADMRowID))
						q:(PAADMRowID = "")
						s flag=0
						s ResultID="",SignUserDRS=""
						for
						{
							s ResultID=$o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_PAADMRowID," 1",ResultID))
							q:(ResultID="")
							s objResult=##class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
							continue:(objResult.Action'="O")
							s flag=1
							s SignUserDR = objResult.SignUserDR
							s ^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR)=$g(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))+1
						}
						if (flag=0)
						{
							//唯一索引
							s SpotID=$o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_PAADMRowID,""))
							continue:(SpotID="")
							s objSpot=##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(SpotID)
							continue:(objSpot.IsOutActive'="Y")
							s SpotDetailID=""
							for
							{
								s SpotDetailID=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",SpotID,SpotDetailID))	
								q:(SpotDetailID="")
								s objSpotDetail=##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(SpotID_"||"_SpotDetailID)
								s SignUserDR = objSpotDetail.CreateUser
								continue:objSpotDetail.Action'="O"
								//一个质控医生质控同一份病历质控多次，只算作一个工作量
								continue:($listfind(SignUserDRS,SignUserDR))
								s SignUserDRS=SignUserDRS_$lb(SignUserDR)
								s ^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR)=$g(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))+1
							}
						}
						
					}
				}
			}
		}
	}
	// 2->质控日期统计
	if (AActions="QualityDate")
	{
		s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
		for AdmDateCurr = StDate:1:EndDate 
		{
			s ResultID="",EpisodeIDSignUsers=""
			for
			{
				s ResultID=$o(^DHCEPRQ.QualityResultI("IdxExamineDate"," "_$zd(AdmDateCurr,3),ResultID))
				q:(ResultID="")
				s objResult=##class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
				continue:(objResult.Action'="O")||(objResult.RuleDR'=1)
				s EpisodeID=objResult.EpisodeID
				s objPaAdm = $g(^PAADM(+EpisodeID))
		        s AdmLocID = $p(objPaAdm,"^",4)		
				s objCtLoc = $g(^CTLOC(+AdmLocID))
		        s HspID = $P(objCtLoc,"^",22)
		        continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)
				s SignUserDR = objResult.SignUserDR
				/// 不同日期质控员对同一份进行质控会产生多条记录，根据医院要求，这种情况不用过滤
				/// “EpisodeIDSignUsers=EpisodeIDSignUsers_$lb(EpisodeID_"^"_SignUserDR)”目的是评分过的再次点击确认质控无缺陷不算做新的工作量(同一个质控员)
				s EpisodeIDSignUsers=EpisodeIDSignUsers_$lb(EpisodeID_"^"_SignUserDR)
				s ^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR)=$g(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))+1
			}
			s SpotID=""
			for
			{
				s SpotID=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDate",AdmDateCurr,SpotID))	
				q:(SpotID="")
				s SpotDetailID=""
				for
				{
					s SpotDetailID=$o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDate",AdmDateCurr,SpotID,SpotDetailID))
					q:(SpotDetailID="")
					s objSpotDetail=##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(SpotID_"||"_SpotDetailID)
					continue:(objSpotDetail.Action'="O")
					s EpisodeID=objSpotDetail.EpisodeID
					s SignUserDR=objSpotDetail.CreateUser
					///评分过的再次点击确认质控无缺陷不算做新的工作量(同一个人)
					continue:($listfind(EpisodeIDSignUsers,(EpisodeID_"^"_SignUserDR)))
					/// 同一个质控员对同一份病历多次点击确认质控无缺陷的情况也要过滤掉
					s EpisodeIDSignUsers=EpisodeIDSignUsers_$lb(EpisodeID_"^"_SignUserDR)
					s ^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR)=$g(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))+1
				}
			}
		}
	}
	s SignUserDR=""
	for
	{
		s SignUserDR=$o(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))
		q:(SignUserDR="")
		s count=$g(^CacheTemp("GetMZDoctorWorkload",repid,SignUserDR))
		s SignUserName = $p($g(^SSU("SSUSR",+SignUserDR)),"^",2)
		s ^CacheTemp(repid,ind)=$lb(SignUserDR,SignUserName,count)
		s ind=ind+1
	}
	k ^CacheTemp("GetMZDoctorWorkload",repid)
	Quit $$$OK
}

ClassMethod GetMZDoctorWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZDoctorWorkloadExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMZDoctorWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZDoctorWorkloadExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		HKY
/// CreatDate:		2022-07-11
/// Description:	运行病历等级统计报表
/// Table:       	
/// Input:			AStartDate 入院起始日期 
/// 				AEndDate 入院截止日期 
/// 				ARuleIDs 查询扣分标准范围，多个用"^"分隔
///                 AIsMultiSummary: 是否显示合计(Y:显示)
///                 AIsDocSummary：是否显示医生合计(Y:显示)
/// Output: 		Query result by your assigned condtion
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetAdmQualitySummaryList","","2017-01-01","2017-05-01","F")				
Query GetAdmQualitySummaryList(ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleIDs As %String, AIsMultiSummary As %String = "Y", AIsDocSummary As %String = "Y") As %Query(ROWSPEC = "Department,Doctor,AvgScore,Count,FirstCount,FirstPercent,SecondCount,SecondPercent,ThirdCount,ThirdPercent,FourthCount,FourthPercent,FifthCount,FifthPercent") [ SqlProc ]
{
}

ClassMethod GetAdmQualitySummaryListExecute(ByRef qHandle As %Binary, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ARuleIDs As %String, AIsMultiSummary As %String = "Y", AIsDocSummary As %String = "Y") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,"")

	q:(ARuleIDs = "") $$$OK	
	q:(((AStartDate = "")||(AEndDate = ""))&&(ALocIDs="")) $$$OK	
	
	/* Debug
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","1ALocIDs") = ALocIDs
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","2AStartDate")	= AStartDate
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","3AEndDate") = AEndDate
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","4ARuleCodes") = ARuleCodes
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","5AIsMultiSummary") = AIsMultiSummary
	s ^CacheTemp("EPRQuality","GetAdmQualitySummaryList","6AIsDocSummary") = AIsDocSummary
	*/
	
	s ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate'="") StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate'="") EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	
	k ^CacheTemp("EPRQuality","AdmSummary",uid)
	if ((StartDate'="")&&(EndDate'=""))
	{
		for AdmDate = StartDate:1:EndDate
		{
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("PAADM_AdmDate",AdmDate,EpisodeID))
				q:(EpisodeID = "")
			    s Admflag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
				continue:(Admflag < 1)
				s objAdm = $g(^PAADM(+EpisodeID))
	      		s AdmType = $p(objAdm,"^",2)
	      		continue:(AdmType '= "I")
	      		  
				s flag = ..BuildAdmSummaryList(EpisodeID,ListLocID,ARuleIDs,uid)
				
				continue:(flag < 0)	                                                                                         
			}	
		}
	}
	else
	{
			s EpisodeID = ""
			for {
				  s EpisodeID = $o(^PAADMi("AdmTypeCurr","I",EpisodeID))
				  q:(EpisodeID = "")
			      s Admflag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			      continue:(Admflag < 1) 
			     
	      		  s flag = ..BuildAdmSummaryList(EpisodeID,ListLocID,ARuleIDs,uid)
			      continue:(flag < 0)		
			}
	}		
	
	q:('$d(^CacheTemp("EPRQuality","AdmSummary",uid))) $$$OK
	
	s (Score, Count, First, Second, Third, Fourth, Fifth) = 0
	
	s DisLocID = "" 
	for	{ 
		s DisLocID = $o(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID)) 
		q:(DisLocID = "")
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocScore,LocCount,LocFirst,LocSecond, LocThird, LocFourth, LocFifth) = 0
		
		s DocID = ""
		for { 
			s DocID = $o(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID)) 
			q:(DocID = "") 
			
			s (DocScore,DocCount,DocFirst,DocSecond, DocThird, DocFourth ,DocFifth) = 0
			
			if (DocID '= "-1")
			{
				s DoctorDesc = $p($g(^CTPCP(+DocID)),"^",2)    			//CT_CareProv
				s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+DocID,0))  		//SS_User
				s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
			}
			else
			{
				s DoctorDesc = "未指定"	
			}
			
			s DocScore  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Score"))
			s DocCount  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Count"))
			s DocFirst  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"First"))
			s DocSecond = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Second"))
			s DocThird  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Third"))
			s DocFourth  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Fourth"))
			s DocFifth  = +$g(^CacheTemp("EPRQuality","AdmSummary",uid,DisLocID,DocID,"Fifth"))
			// 医生总计
			if ($ZCVT(AIsDocSummary,"U") = "Y")
			{
			   s DocAvgScore = $s(DocScore#DocCount=0:DocScore/DocCount,1:$j(DocScore/DocCount,2,1))
			   s DocFirstPercent = $s(DocFirst*100#DocCount=0:DocFirst*100/DocCount,1:$j(DocFirst*100/DocCount,2,1))
			   s DocSecondPercent = $s(DocSecond*100#DocCount=0:DocSecond*100/DocCount,1:$j(DocSecond*100/DocCount,2,1))
			   s DocThirdPercent = $s(DocThird*100#DocCount=0:DocThird*100/DocCount,1:$j(DocThird*100/DocCount,2,1))
			   s DocFourthPercent = $s(DocFourth*100#DocCount=0:DocFourth*100/DocCount,1:$j(DocFourth*100/DocCount,2,1))
			   s DocFifthPercent = $s(DocFifth*100#DocCount=0:DocFifth*100/DocCount,1:$j(DocFifth*100/DocCount,2,1))
			
			   s Data = $lb("------",DoctorDesc,DocAvgScore,DocCount,DocFirst,DocFirstPercent_"%",DocSecond,DocSecondPercent_"%",DocThird,DocThirdPercent_"%",DocFourth,DocFourthPercent_"%",DocFifth,DocFourthPercent_"%")
			   s ^CacheTemp(uid,ind) = Data
			}
			s ind = ind + 1
			
			s LocScore = LocScore + DocScore, LocCount = LocCount + DocCount, LocFirst = LocFirst + DocFirst, LocSecond = LocSecond + DocSecond, LocThird = LocThird + DocThird, LocFourth = LocFourth + DocFourth, LocFifth = LocFifth + DocFifth
		}
		
		// 科室总计
		s LocAvgScore = $s(LocScore#LocCount=0:LocScore/LocCount,1:$j(LocScore/LocCount,2,1))
		s LocFirstPercent = $s(LocFirst*100#LocCount=0:LocFirst*100/LocCount,1:$j(LocFirst*100/LocCount,2,1))
		s LocSecondPercent = $s(LocSecond*100#LocCount=0:LocSecond*100/LocCount,1:$j(LocSecond*100/LocCount,2,1))
		s LocThirdPercent = $s(LocThird*100#LocCount=0:LocThird*100/LocCount,1:$j(LocThird*100/LocCount,2,1))
		s LocFourthPercent = $s(LocFourth*100#LocCount=0:LocFourth*100/LocCount,1:$j(LocFourth*100/LocCount,2,1))
		s LocFifthPercent = $s(LocFifth*100#LocCount=0:LocFifth*100/LocCount,1:$j(LocFifth*100/LocCount,2,1))
		
		s Data = $lb(LocDesc,"小计",LocAvgScore,LocCount,LocFirst,LocFirstPercent_"%",LocSecond,LocSecondPercent_"%",LocThird,LocThirdPercent_"%",LocFourth,LocFourthPercent_"%",LocFifth,LocFifthPercent_"%")
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1
		
		s Score = Score + LocScore, Count = Count + LocCount, First = First + LocFirst, Second = Second + LocSecond, Third = Third + LocThird, Fourth = Fourth + LocFourth, Fifth = Fifth + LocFifth
	}
	
	// 最后一栏的统计
	s AvgScore = $s(Score#Count=0:Score/Count,1:$j(Score/Count,2,1))
	s FirstPercent = $s(First*100#Count=0:First*100/Count,1:$j(First*100/Count,2,1))
	s SecondPercent = $s(Second*100#Count=0:Second*100/Count,1:$j(Second*100/Count,2,1))
	s ThirdPercent = $s(Third*100#Count=0:Third*100/Count,1:$j(Third*100/Count,2,1))
	s FourthPercent = $s(Fourth*100#Count=0:Fourth*100/Count,1:$j(Fourth*100/Count,2,1))
	s FifthPercent = $s(Fifth*100#Count=0:Fifth*100/Count,1:$j(Fifth*100/Count,2,1))
	
	s Data = $lb("合计","------",AvgScore,Count,First,FirstPercent_"%",Second,SecondPercent_"%",Third,ThirdPercent_"%",Fourth,FourthPercent_"%",Fifth,FifthPercent_"%")
	s ^CacheTemp(uid,ind) = Data
	
	// 增加第一栏的统计
	if ($zcvt(AIsMultiSummary,"U") = "Y")&&(ind > 26)
	{
		s Data = $lb("合计","------",AvgScore,Count,First,FirstPercent_"%",Second,SecondPercent_"%",Third,ThirdPercent_"%",Fourth,FourthPercent_"%",Fifth,FifthPercent_"%")
		s ^CacheTemp(uid,1) = Data	
	}
	
	k ^CacheTemp("EPRQuality","AdmSummary",uid)
	
	q $$$OK
}

/// w ##Class(EPRservice.Quality.BOQualityReport).BuildAdmSummaryList(65,"","F",65)
ClassMethod BuildAdmSummaryList(AEpisodeID As %String, AListLocID As %List, ARuleIDs As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(ARuleIDs = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	q:($p(objPaAdm,"^",20) '= "D") ret			//就诊状态
	
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	
	s DisLocID = $p(objPaAdm,"^",4)					//入院科室
	q:(DisLocID = "") ret
	q:($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)				//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	
	/*
	//modify by Candyxu 将取结果改为从结果表中取
	s Result = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
	q:(Result = "") ret
	
	s Score = $p(Result,"^",1)
	s Grade = $p(Result,"^",2)
	*/
	 s Score=##Class(EPRservice.Quality.BOManualCheck).GetAdmScoreByEpisodeID(AEpisodeID,"A","IsContainVolun")
    	 s:(Score>=90) Grade="甲"
         s:((Score>=75)&&(Score<90)) Grade="乙"
         s:(Score<75) Grade="丙"

	s ^CacheTemp("EPRQuality","AdmSummary",AUniqueKey,DisLocID,AdmDoctorID,"Score") = (+$g(^CacheTemp("EPRQuality","AdmSummary",AUniqueKey,DisLocID,AdmDoctorID,"Score"))) + Score
	s ^CacheTemp("EPRQuality","AdmSummary",AUniqueKey,DisLocID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality","AdmSummary",AUniqueKey,DisLocID,AdmDoctorID,"Count"))) + 1
	s objResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	d objResult.GetQualityReportGloable(Grade,"AdmSummary",AUniqueKey,DisLocID,AdmDoctorID)
	d objResult.%Close()
	s objResult = ""
	
	s ret = 1
	q ret
}

ClassMethod GetAdmQualitySummaryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmQualitySummaryListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAdmQualitySummaryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmQualitySummaryListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:获取入院记录、手术记录、出院记录、病案首页的总完整率	
/// 	 ADisStartDate 出院开始时间
/// 	 ADisEndDate 出院结束时间
///      ALocIDs 科室ID	
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetDocCompleteRate","2022-06-20","2022-06-23")
Query GetDocCompleteRate(ADisStartDate As %String, ADisEndDate As %String, ALocIDs As %Text = "", AHospitalID As %String = "") As %Query(ROWSPEC = "LocID,LocDesc,DisPatCount,OPPeopleCount,BreakRule1Rate,BreakRule2Rate,BreakRule3Rate,BreakRule4Rate") [ SqlProc ]
{
}

ClassMethod GetDocCompleteRateExecute(ByRef qHandle As %Binary, ADisStartDate As %String, ADisEndDate As %String, ALocIDs As %Text = "", AHospitalID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,"")

	
	q:(ADisStartDate = "")||(ADisEndDate = "") $$$OK
	k ^CacheTemp("EPRQuality","CompletionLocRate",repid)
   
	// 出院总人数
	s DischPeopleCount=0
	
	//超时完成入院记录人数
	s BreakRule1=0 
	//手术记录不符合要求人数
	s BreakRule2=0
	//出院记录不符合要求人数
	s BreakRule3=0
	//病案首页不符合要求人数
	s BreakRule4=0
	
    
    
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
     
	s StartDate	= $g(ADisStartDate)
	s EndDate	= $g(ADisEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	
	for TmpDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			
			s EpisodeID = $o(^PAADMi("DischDate",TmpDate,EpisodeID))
			q:(EpisodeID = "")
			//s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
	      	//continue:(flag < 1) 
	      	
	      	s objAdm = $g(^PAADM(+EpisodeID))
	      	s AdmType = $p(objAdm,"^",2)
	      	continue:(AdmType '= "I")
	       
	      	s LocID=$p($g(objAdm),"^",4)
			continue:($listlength(ListLocID) > 0)&&($listfind(ListLocID,LocID) = 0)
			s objCtLoc = $g(^CTLOC(+LocID))
			s HspID = $P(objCtLoc,"^",22)
			continue:(HspID'="")&&(AHospitalID'="")&&(AHospitalID'=HspID)
            s LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			
			
			
			//手术申请单时间
			s HISOPDateTime=##Class(EPRservice.Quality.DataGather.AdmInfo).GetOperDateTime(EpisodeID)
			
			//取标准出院时间接口
			s HISDischTime2=##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(EpisodeID)
			
		
        
			
            // 入院记录触犯标志
			s BreakRule1flag=..GetEntryFlag(EpisodeID,449)
			//手术记录记录触犯标志
			s BreakRule2flag=0
			s:(HISOPDateTime'="") BreakRule2flag=..GetEntryFlag(EpisodeID,468)
			//出院记录记录触犯标志
			s BreakRule3flag=..GetEntryFlag(EpisodeID,455)
			//病案首页记录触犯标志
			s BreakRule4flag=..GetEntryFlag(EpisodeID,482)
		    
			s ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"DischPeopleCount")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"DischPeopleCount"))+1
			s:(HISOPDateTime'="") ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"OPPeopleCount")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"OPPeopleCount"))+1 
			 
			s:($p(BreakRule1flag,"^",1)="-1") ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule1")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule1"))+1
			s:((HISOPDateTime'="")&&($p(BreakRule2flag,"^",1)="-1")) ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule2")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule2"))+1 
			s:($p(BreakRule3flag,"^",1)="-1") ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule3")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule3"))+1
			s:($p(BreakRule4flag,"^",1)="-1") ^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule4")=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,LocID,"BreakRule4"))+1
			
			
			
		}
	}
	
    s (TotalBreakRule1,TotalBreakRule2,TotalBreakRule3,TotalBreakRule4,TotalDisPatCount,TotalOPPeopleCount)=0
    s TmpLocID=""
	for
    {
    s TmpLocID=$o(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID))
	q:TmpLocID=""
	s LocDesc = $p($g(^CTLOC(TmpLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	
  	s BreakRule1=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"BreakRule1"))
	s BreakRule2=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"BreakRule2"))
	s BreakRule3=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"BreakRule3"))
	s BreakRule4=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"BreakRule4"))
	
	

	s DisPatCount=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"DischPeopleCount"))
	s OPPeopleCount=+$g(^CacheTemp("EPRQuality","CompletionLocRate",repid,TmpLocID,"OPPeopleCount"))
	
	
	s TotalBreakRule1=TotalBreakRule1+BreakRule1
	s TotalBreakRule2=TotalBreakRule2+BreakRule2
	s TotalBreakRule3=TotalBreakRule3+BreakRule3
	s TotalBreakRule4=TotalBreakRule4+BreakRule4
	s TotalDisPatCount=TotalDisPatCount+DisPatCount
	s TotalOPPeopleCount=TotalOPPeopleCount+OPPeopleCount
	
	
		
	s:(DisPatCount'=0) BreakRule1Rate=$e((DisPatCount-BreakRule1)/DisPatCount,1,5)*100_"%"	
	s:(OPPeopleCount'=0) BreakRule2Rate=$e((OPPeopleCount-BreakRule2)/OPPeopleCount,1,5)*100_"%"
    s:(DisPatCount'=0) BreakRule3Rate=$e((DisPatCount-BreakRule3)/DisPatCount,1,5)*100_"%"
	s:(DisPatCount'=0) BreakRule4Rate=$e((DisPatCount-BreakRule4)/DisPatCount,1,5)*100_"%"
	
	
   	s:(OPPeopleCount=0) BreakRule2Rate="-"
  
	set Data=$lb(TmpLocID,LocDesc,DisPatCount,OPPeopleCount,BreakRule1Rate,BreakRule2Rate,BreakRule3Rate,BreakRule4Rate)
	s ^CacheTemp(repid,ind) = Data
	s ind = ind + 1
	
 	}
 	if ($listlength(ListLocID)'=1)
 	{
	 	s:(TotalDisPatCount'=0) TotalBreakRule1Rate=$e((TotalDisPatCount-TotalBreakRule1)/TotalDisPatCount,1,5)*100_"%"	
		s:(TotalOPPeopleCount'=0) TotalBreakRule2Rate=$e((TotalOPPeopleCount-TotalBreakRule2)/TotalOPPeopleCount,1,5)*100_"%"
	    s:(TotalDisPatCount'=0) TotalBreakRule3Rate=$e((TotalDisPatCount-TotalBreakRule3)/TotalDisPatCount,1,5)*100_"%"
		s:(TotalDisPatCount'=0) TotalBreakRule4Rate=$e((TotalDisPatCount-TotalBreakRule4)/TotalDisPatCount,1,5)*100_"%"
		
		
		
		s:(TotalOPPeopleCount=0) TotalBreakRule2Rate="-"
	   
		set Data=$lb("","合计",TotalDisPatCount,TotalOPPeopleCount,TotalBreakRule1Rate,TotalBreakRule2Rate,TotalBreakRule3Rate,TotalBreakRule4Rate)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
 	}
   k ^CacheTemp("EPRQuality","CompletionLocRate",repid)
	Quit $$$OK
}

ClassMethod GetDocCompleteRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocCompleteRateExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocCompleteRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocCompleteRateExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ##Class(EPRservice.Quality.BOQualityReport).GetEntryFlag(AEpisodeID,1)
ClassMethod GetEntryFlag(AEpisodeID As %String, AEntryIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AEntryIDs="") ret
	s EntryIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"^")
	for Ind = 1:1:$listlength(EntryIDs)
	{
		s EntryID = $listget(EntryIDs,Ind)
		continue:(EntryID = "")
	    s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  
        continue:(objEntry = "") 
    
	    s flag=$d(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID)) 
	    s:(flag=10) ret=-1
	    q:(ret=-1)
	}
    q ret
}

/// 2017-04-05
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetCompleteByLoc","2021-04-23","2021-04-23","1")
Query GetCompleteByLoc(AStartDate As %String, AEndDate As %String, ALocID As %String) As %Query(ROWSPEC = "LocDesc,LocID,DoctorName,userID,Number1,Number2,Number3,Number4,OPCount,percent1,percent2,percent3,percent4,FirstAdm,RepeatAdm") [ SqlProc ]
{
}

ClassMethod GetCompleteByLocExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	s LocID=$g(ALocID)
	q:($d(LocID) = 0)||(LocID = "") $$$OK
	
	s LocType="O"
	s IsOPLoc=$d(^PAC("ADMLOC",0,"AdmType",LocType,LocID))
	s:(IsOPLoc'=10) LocType="E"
	
	s rs = ##class(%ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetUserDataList")
	d rs.Execute("",LocID)
	while rs.Next() 
	{
		s (Number1,Number2,Number3,Number4,Number5,Number6,Number7,FirstAdm,RepeatAdm) = 0
		s (percent1,percent2,percent3,percent4,percent5,percent6,percent7)=0
		s (usrID,resultId)=""
		///就诊量
		s OPCount=0
    	s userID = rs.Data("ProvID")
    	for AdmDate = StartDate:1:EndDate
		{
			s Time = ""
			for {
				s Time = $o(^PAADMi("TypeLocDocDateTime",LocType,ALocID,userID,AdmDate,Time))
				q:Time=""
				s EpisodeID = ""
				for {
					s EpisodeID = $o(^PAADMi("TypeLocDocDateTime",LocType,ALocID,userID,AdmDate,Time,EpisodeID))
					//s EpisodeID =$o(^PAADMi("PAADM_AdmDate",AdmDate,EpisodeID))
					q:(EpisodeID = "")
					
					s DoctorID = $p($g(^PAADM(EpisodeID)),"^",9)
					s resrowid=$o(^RB("RES",0,"CTPCP",DoctorID,ALocID,""))
					s resObj=##class(User.RBResource).%OpenId(resrowid)
					s ctpcpdr=resObj.RESCode
					s DoctorName = $p($g(^CTPCP(DoctorID,1)),"^",2)
					//continue:((DoctorName["普通")||(DoctorName["专家")||(DoctorName["上午")||(DoctorName["下午"))
					
					s OPCount=OPCount+1
					///科室
					s LocDesc = $p($g(^CTLOC(+ALocID)),"^",2)
				    s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
				    	
					s array = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.03.01")
					///主诉
					s ElementData1=$TR(array.GetAt("HDSD00.03.057")," ","")
					s:(ElementData1'="") Number1 = Number1 + 1 
			
			    	///现病史
					s ElementData2 = $TR(array.GetAt("HDSD00.03.038")," ","")
					s:(ElementData2'="") Number2 = Number2 + 1
			
					///诊断
					s ElementData3 = $TR(array.GetAt("HDSD00.03.005")," ","")
					s:(ElementData3'="") Number3 = Number3 + 1  
			
					///医生签名
			        s ElementData4=$TR(array.GetAt("HDSD00.03.041")," ","")
					s:(ElementData4'="") Number4 = Number4 + 1 
					
					//初诊复诊
					s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
					s AdmStatus = ##Class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(PapmiDR,EpisodeID)
					s:(AdmStatus["初诊") FirstAdm = FirstAdm + 1
					s:(AdmStatus["复诊") RepeatAdm = RepeatAdm + 1
				
				}	
			}
		}
		
		continue:OPCount=0
		//医生完成率
		s:OPCount'=0 percent1 = $FN($s(Number1*100#OPCount=0:Number1*100/OPCount,1:$j(Number1*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent2 = $FN($s(Number2*100#OPCount=0:Number2*100/OPCount,1:$j(Number2*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent3 = $FN($s(Number3*100#OPCount=0:Number3*100/OPCount,1:$j(Number3*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent4 = $FN($s(Number4*100#OPCount=0:Number4*100/OPCount,1:$j(Number4*100/OPCount,2,2)),"",2)
		
	    s Data = $lb(LocDesc,LocID,DoctorName,userID,Number1,Number2,Number3,Number4,OPCount,percent1,percent2,percent3,percent4,FirstAdm,RepeatAdm)
	    s ^CacheTemp(repid,ind) = Data
	    s ind = ind + 1
	    
	}
	
	Quit $$$OK
}

ClassMethod GetCompleteByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCompleteByLocExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCompleteByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCompleteByLocExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

/// 2017-04-05
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetCompleteDetailByLoc","2021-04-23","2021-04-23","1","")
Query GetCompleteDetailByLoc(AStartDate As %String, AEndDate As %String, ALocID As %String, ADoctorID As %String) As %Query(ROWSPEC = "LocDesc,LocID,DoctorName,userID,EpisodeID,Name,RegNo,Number1,Number2,Number3,Number4,FirstAdm") [ SqlProc ]
{
}

ClassMethod GetCompleteDetailByLocExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, ADoctorID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((AStartDate="")||(AEndDate="")) $$$OK
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	
	s LocType="O"
	s IsOPLoc=$d(^PAC("ADMLOC",0,"AdmType",LocType,ALocID))
	s:(IsOPLoc'=10) LocType="E"
	
	for AdmDate = StartDate:1:EndDate
	{
		s Time = ""
		for {
			s Time = $o(^PAADMi("TypeLocDocDateTime",LocType,ALocID,ADoctorID,AdmDate,Time))
			q:Time=""
			s (Number1,Number2,Number3,Number4) = "0"
			s FirstAdm = "Y"
			s (usrID,resultId)=""
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("TypeLocDocDateTime",LocType,ALocID,ADoctorID,AdmDate,Time,EpisodeID))
				q:(EpisodeID = "")
				
				s objPaAdm = $g(^PAADM(+EpisodeID))
				q:(objPaAdm = "")
				s Papmi = $p(objPaAdm,"^",1)
				s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
				s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
				
				s DoctorID = ADoctorID
				s DoctorName = $p($g(^CTPCP(DoctorID,1)),"^",2)
				///科室
				s LocDesc = $p($g(^CTLOC(+ALocID)),"^",2)
			    s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			    
				s array = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.03.01")
				///主诉
				s ElementData1=$TR(array.GetAt("HDSD00.03.057")," ","")
				s:(ElementData1'="") Number1 = Number1 + 1 
		
		    	///现病史
				s ElementData2 = $TR(array.GetAt("HDSD00.03.038")," ","")
				s:(ElementData2'="") Number2 = Number2 + 1
		
				///诊断
				s ElementData3 = $TR(array.GetAt("HDSD00.03.005")," ","")
				s:(ElementData3'="") Number3 = Number3 + 1  
		
				///医生签名
		        s ElementData4=$TR(array.GetAt("HDSD00.03.041")," ","")
				s:(ElementData4'="") Number4 = Number4 + 1 
				
				//初诊复诊
				s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
				s AdmStatus = ##Class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(PapmiDR,EpisodeID)
				s:(AdmStatus["初诊") FirstAdm = "Y"
				s:(AdmStatus["复诊") FirstAdm = "N"
				
				s Data = $lb(LocDesc,LocID,DoctorName,DoctorID,EpisodeID,Name,RegNo,Number1,Number2,Number3,Number4,FirstAdm)
			    s ^CacheTemp(repid,ind) = Data
			    s ind = ind + 1
			}	
		}
	}
	
	Quit $$$OK
}

ClassMethod GetCompleteDetailByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCompleteByLocExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCompleteDetailByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCompleteByLocExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////////
/// CreatDate:		2016-12-21 YHY
/// Description:	查询门诊病历内容完成率  	
/// Input:			ALocIDs  科室
/// 				AStartDate 开始时间
/// 				AEndDate 结束时间
/// Output: 		完成数量-完成率
/// Return:			
/// Test:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetOPRecordPCReport","","2019-01-01","2019-01-30",2)
Query GetOPRecordPCReport(ALocID As %String, AStartDate As %String, AEndDate As %String, hosId As %String = "") As %Query(ROWSPEC = "LocDesc,LocID,Number1,Number2,Number3,Number4,OPCount,percent1,percent2,percent3,percent4,FirstAdm,RepeatAdm") [ SqlProc ]
{
}

ClassMethod GetOPRecordPCReportExecute(ByRef qHandle As %Binary, ALocID As %String, AStartDate As %String, AEndDate As %String, hosId As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")
	
	q:(AStartDate = "")||(AEndDate = "") $$$OK	
	q:((ALocID="")&&(hosId="")) $$$OK
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	if (hosId'="")
	{
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataGather.Location:GetOPLocationList")
		s sc = result.Execute("O^E","","")
		While (result.Next())
		{
			s (Number1,Number2,Number3,Number4,FirstAdm,RepeatAdm) = 0
			s (percent1,percent2,percent3,percent4)=0
			s (usrID,resultId)=""
			///就诊量
			s OPCount=0
			s LocID = result.Data("ID")
			continue:(ALocID'="")&&(ALocID'=LocID)
			///科室
			s LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			s HospitalCode=$p(^CTLOC(LocID),"^",22)
			continue:(HospitalCode'=hosId)
			
			//^PAADMi("TypeLocDocDateTime","O",ALocID,userID,AdmDate,Time,EpisodeID)
			for AdmDate = StartDate:1:EndDate
			{
				s EpisodeID = ""
				for {
					s EpisodeID = $o(^PAADMi("NNLoc",LocID,AdmDate,EpisodeID))
					q:(EpisodeID = "")
					s Status = $p($g(^PAADM(EpisodeID)),"^",20)
					continue:Status'="A"
					
					s OPCount=OPCount+1
					s array = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.03.01")
					///主诉
					s ElementData1=$TR(array.GetAt("HDSD00.03.057")," ","")
					s:(ElementData1'="") Number1 = Number1 + 1 
			
			    	///现病史
					s ElementData2 = $TR(array.GetAt("HDSD00.03.038")," ","")
					s:(ElementData2'="") Number2 = Number2 + 1
			
					///诊断
					s ElementData3 = $TR(array.GetAt("HDSD00.03.005")," ","")
					s:(ElementData3'="") Number3 = Number3 + 1  
			
					///医生签名
			        s ElementData4=$TR(array.GetAt("HDSD00.03.041")," ","")
					s:(ElementData4'="") Number4 = Number4 + 1 
					
					//初诊复诊
					s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
					s AdmStatus = ##Class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(PapmiDR,EpisodeID)
					s:(AdmStatus["初诊") FirstAdm = FirstAdm + 1
					s:(AdmStatus["复诊") RepeatAdm = RepeatAdm + 1
				}
			}
			
			continue:OPCount=0	
			s:OPCount'=0 percent1 = $FN($s(Number1*100#OPCount=0:Number1*100/OPCount,1:$j(Number1*100/OPCount,2,2)),"",2)
			s:OPCount'=0 percent2 = $FN($s(Number2*100#OPCount=0:Number2*100/OPCount,1:$j(Number2*100/OPCount,2,2)),"",2)
			s:OPCount'=0 percent3 = $FN($s(Number3*100#OPCount=0:Number3*100/OPCount,1:$j(Number3*100/OPCount,2,2)),"",2)
			s:OPCount'=0 percent4 = $FN($s(Number4*100#OPCount=0:Number4*100/OPCount,1:$j(Number4*100/OPCount,2,2)),"",2)
			
			s Data = $lb(LocDesc,LocID,Number1,Number2,Number3,Number4,OPCount,percent1,percent2,percent3,percent4,FirstAdm,RepeatAdm)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
	}
	else
	{
		s (Number1,Number2,Number3,Number4,FirstAdm,RepeatAdm) = 0
		s (percent1,percent2,percent3,percent4)=0
		s (usrID,resultId)=""
		///就诊量
		s OPCount=0
		for AdmDate = StartDate:1:EndDate
		{
			s EpisodeID = ""
			for 
			{
				s EpisodeID = $o(^PAADMi("NNLoc",ALocID,AdmDate,EpisodeID))
				//s EpisodeID =$o(^PAADMi("PAADM_AdmDate",AdmDate,EpisodeID))
				q:(EpisodeID = "")
				s Status = $p($g(^PAADM(EpisodeID)),"^",20)
				continue:(Status'="A")
				
				s OPCount=OPCount+1
				///科室
				s LocDesc = $p($g(^CTLOC(+ALocID)),"^",2)
			    s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			    
				s array = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.03.01")
				///主诉
				s ElementData1=$TR(array.GetAt("HDSD00.03.057")," ","")
				s:(ElementData1'="") Number1 = Number1 + 1 
		
		    	///现病史
				s ElementData2 = $TR(array.GetAt("HDSD00.03.038")," ","")
				s:(ElementData2'="") Number2 = Number2 + 1
		
				///诊断
				s ElementData3 = $TR(array.GetAt("HDSD00.03.005")," ","")
				s:(ElementData3'="") Number3 = Number3 + 1  
		
				///医生签名
		        s ElementData4=$TR(array.GetAt("HDSD00.03.041")," ","")
				s:(ElementData4'="") Number4 = Number4 + 1 
				
				//初诊复诊
				s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
				s AdmStatus = ##Class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(PapmiDR,EpisodeID)
				s:(AdmStatus["初诊") FirstAdm = FirstAdm + 1
				s:(AdmStatus["复诊") RepeatAdm = RepeatAdm + 1
			}
		}
		
		//科室完成率
		s:OPCount'=0 percent1 = $FN($s(Number1*100#OPCount=0:Number1*100/OPCount,1:$j(Number1*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent2 = $FN($s(Number2*100#OPCount=0:Number2*100/OPCount,1:$j(Number2*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent3 = $FN($s(Number3*100#OPCount=0:Number3*100/OPCount,1:$j(Number3*100/OPCount,2,2)),"",2)
		s:OPCount'=0 percent4 = $FN($s(Number4*100#OPCount=0:Number4*100/OPCount,1:$j(Number4*100/OPCount,2,2)),"",2)
		
		s Data = $lb(LocDesc,ALocID,Number1,Number2,Number3,Number4,OPCount,percent1,percent2,percent3,percent4,FirstAdm,RepeatAdm)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
		
	}
	   Quit $$$OK
}

ClassMethod GetOPRecordPCReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPRecordPCReportExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)

	Quit $$$OK
}

ClassMethod GetOPRecordPCReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPRecordPCReportExecute ]
{
 	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:		ZXY
/// CreatDate:		2021-08-24
/// Description:	病历模板统计报表
/// Table:       	
/// Input:			AStartDate means 
/// 				AEndDate means 
/// 				ARuleCode means
/// Output: 		Query result by your assigned condtion
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetDisscuRecordList","191,192","2022-08-01","2022-11-01","634#584#术前讨论记录","2")	
Query GetDisscuRecordList(ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ChartItemIDs As %String, AHospitalID As %String = "") As %Query(ROWSPEC = "LocDesc,WardDesc,RegNo,Name,Age,AdmitDate,DischDate,AdmDiagnos,DoctorDesc,DisLocID,AEpisodeID,Papmi,BedNo,CteaterDate,Cteater,RecordTitle,MRNo,SingUserID,SingUser,SingDate,MianDiagno,MainOper") [ SqlProc ]
{
}

ClassMethod GetDisscuRecordListExecute(ByRef qHandle As %Binary, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, ChartItemIDs As %String, AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,"")
	

	q:((AStartDate = "")||(AEndDate = "")) $$$OK	
	q:ChartItemIDs="" $$$OK
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	k ^CacheTemp("EPRQuality","DisscuRecord",uid)
	//s lstLocID=""
	//s:(ALocIDs'="") lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	s ChartItemIDinfos=ChartItemIDs
	
	//s:ChartItemIDs="" ChartItemIDinfos="86#20#死亡病历讨论记录!84#7#疑难病例讨论记录!74#16#术前讨论记录!"
	
	for i=1:1:$l(ChartItemIDinfos,"!")
	{
		s Chartinfo=$p(ChartItemIDinfos,"!",i)
		
		q:Chartinfo=""
		
		s ChartItemID=$p(Chartinfo,"#",1)
		s TemplateID=$p(Chartinfo,"#",2)
		s TemplateID="^"_TemplateID_"^"
		
	
	for o = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {	
			s EpisodeID = $o(^PAADMi("PAADM_AdmDate",o,EpisodeID))
			q:(EpisodeID = "")
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1)
			s objPaAdm = $g(^PAADM(+EpisodeID))
			//continue:($p(objPaAdm,"^",2) '= "I") 			//就诊类别
	        continue:($p(objPaAdm,"^",75) '= "") 			//婴儿不建档案
	        //continue:($p(objPaAdm,"^",20) '= "D") 			//就诊状态
			s AdmLocID = $p(objPaAdm,"^",4)	
			
			continue:(ListLocID'="")&&($listlength(ListLocID) > 0)&&($listfind(ListLocID,AdmLocID) = 0)
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
		    for i=1:1:$l(ChartItemID,"^")
		    {
			s temChartItemID=$p(ChartItemID,"^",i)
			q:temChartItemID=""
		    
			s RecordID="" 
			for 
			{
				s RecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,temChartItemID,RecordID))
				
			    q:(RecordID = "")
			   
			    s sublist=""
				for
				{
					s sublist=$o(^DHCEMRI.InstanceDataI("IdxECRecord",RecordID,sublist))
					q:sublist=""
				
					s instanceid=RecordID_"||"_sublist
					s Objinstance = $g(^DHCEMRI.ECRecordD(RecordID,"Instances",sublist)) 
					s temTemplateID=$list(Objinstance,15)
					
					s temTemplateID="^"_temTemplateID_"^"
					continue:TemplateID'[temTemplateID
					continue:$list(Objinstance,14)'="Save"
				
					s flag = ..DisscuRecordList(EpisodeID,instanceid,StartDate,EndDate,uid)
			        continue:(flag < 0)	
					}
					
				}                                                                                         
		}	
	
		} 
	}
	
	
	}

	q:('$d(^CacheTemp("EPRQuality","DisscuRecord",uid))) $$$OK
	
	s locid=""
	for
	{
		s locid=$o(^CacheTemp("EPRQuality","DisscuRecord",uid,locid))
		q:locid=""
		s episodeID=""
		for
		{
			s episodeID=$o(^CacheTemp("EPRQuality","DisscuRecord",uid,locid,episodeID))
			q:episodeID=""
		    s tmpinstanceID=""
		    for
		    {
			    
			   s tmpinstanceID=$o(^CacheTemp("EPRQuality","DisscuRecord",uid,locid,episodeID,tmpinstanceID))
			   q:tmpinstanceID=""
			   s Data = $g(^CacheTemp("EPRQuality","DisscuRecord",uid,locid,episodeID,tmpinstanceID))
			   s ^CacheTemp(uid,ind) = Data
			   s ind = ind + 1	
			}
		}
		}
	
	k ^CacheTemp("EPRQuality","DisscuRecord",uid)
	
	q $$$OK
}

ClassMethod DisscuRecordList(AEpisodeID As %String, InstanceIDS As %String, StartDate As %String, EndDate As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s Age=##Class(EPRservice.Quality.DataGather.AdmInfo).GetAge(AEpisodeID)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s DisLocID = $p(objPaAdm,"^",4)					//出院科室
	s:(MRNo="") MRNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	q:(DisLocID = "") ret
	s AdmDiagnos=##Class(EPRservice.Quality.DataGather.AdmInfo).MainDiagnos(AEpisodeID)
	s AdmWardID = $p(objPaAdm,"^",70)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s WardDesc=""
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s BedNo=##Class(EPRservice.Quality.DataGather.AdmInfo).DisBed(AEpisodeID)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "Other"
	s DoctorDesc = $s(AdmDoctorID '= "Other":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s AdmitDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmitDate)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3),DischDate =##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DischDate)
	s InstanceID=InstanceIDS 
	s Objinstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s Title=Objinstance.Title
	s MianDiagno=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.11.024",InstanceID)
	s MainOper=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.11.090",InstanceID)
	//签名时间
	s SingUser="" 
	s SingDate=""
	s SingUserID=""
	s CteaterDate=Objinstance.CreateDate
	s CteaterDate=$zd(CteaterDate,3)
    s Cteater=Objinstance.CreateUser
    s Cteater=$p($g(^SSU("SSUSR",Cteater)),"^",2)
    s:SingUser'="" SingUser=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
    s RecordTitle=Objinstance.Title
    s ^CacheTemp("EPRQuality","DisscuRecord",AUniqueKey,DisLocID,AEpisodeID,InstanceID)=$lb(LocDesc,WardDesc,RegNo,Name,Age,AdmitDate,DischDate,AdmDiagnos,DoctorDesc,DisLocID,AEpisodeID,Papmi,BedNo,CteaterDate,Cteater,RecordTitle,MRNo,SingUserID,SingUser,SingDate,MianDiagno,MainOper)
		
	
     
	s ret = 1
	q ret
}

ClassMethod GetDisscuRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnHosDetailListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDisscuRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnHosDetailListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Others:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetOutQualityDetail","","","","1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264")
/// Creator:		ZXY
/// CreatDate:		2021-08-24
/// Description:	出院/在院患者住院天数超过30天的患者
/// Table:       	
/// Input:			AStartDate means 
/// 				AEndDate means 
/// 				ARuleCode means
/// Output: 		Query result by your assigned condtion
/// Return:			
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetLiveHosOverList","191","2022-10-01","2022-10-26","D",2)	
Query GetLiveHosOverList(ALocIDs As %Text, AStartDate As %String, AEndDate As %String, DateType As %String, AHospitalID As %String = "") As %Query(ROWSPEC = "LocDesc,WardDesc,RegNo,Name,Age,AdmitDate,DischDate,LiveDays,MainDiagnos,DoctorDesc,IsIMedOver,IsIDicussOver,DisLocID,EpisodeID,Papmi") [ SqlProc ]
{
}

ClassMethod GetLiveHosOverListExecute(ByRef qHandle As %Binary, ALocIDs As %Text, AStartDate As %String, AEndDate As %String, DateType As %String, AHospitalID As %String = "") As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,"")
	
	q:((AStartDate = "")||(AEndDate = ""))&&(DateType="D") $$$OK
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	q:DateType="" $$$OK
	
	k ^CacheTemp("EPRQuality","LiveHosOverList",uid)
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
  
	if (DateType="D")
	{
	
	for DischDate = StartDate:1:EndDate
	{
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
			q:(EpisodeID = "")
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1)
			s objPaAdm = $g(^PAADM(+EpisodeID))
			continue:($p(objPaAdm,"^",2) '= "I") 			//就诊类别
	        continue:($p(objPaAdm,"^",75) '= "") 			//婴儿不建档案
	        continue:($p(objPaAdm,"^",20) '= "D") 			//就诊状态
			s AdmLocID = $p(objPaAdm,"^",4)	
			continue:(ListLocID'="")&&($listlength(ListLocID) > 0)&&($listfind(ListLocID,AdmLocID) = 0)	
			s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		    continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
			s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
			continue:(flag < 1)
			
			s flag = ..BuildLiveHosOverList(EpisodeID,uid)
		
			continue:(flag < 0)	                                                                                         
		}	
	
	   
	}
	}
	elseif(DateType="A")
	{
		s EpisodeID = ""
	    for {
		     s EpisodeID = $o(^PAADMi("AdmTypeCurr","I",EpisodeID))
		     q:(EpisodeID = "")
		     s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
	         continue:(flag < 1) 
	         s objAdm = $g(^PAADM(+EpisodeID))
	         s AdmType = $p(objAdm,"^",2)
	         continue:(AdmType '= "I") 	
	         s AdmLocID = $p(objAdm,"^",4)	
	         continue:(ListLocID'="")&&($listlength(ListLocID) > 0)&&($listfind(ListLocID,AdmLocID) = 0)	
		     s HospitalDR = $p(^CTLOC(+AdmLocID),"^",22)
		     continue:(AHospitalID'="")&&(HospitalDR'=AHospitalID)
		     s AdmitDate = $p(objAdm,"^",6)
		     continue:($p(objAdm,"^",20) '= "A") 
		     continue:(StartDate '= "")&&(AdmitDate < StartDate)
		     continue:(EndDate '= "")&&(AdmitDate > EndDate)
			 s flag = ..BuildLiveHosOverList(EpisodeID,uid)
			 continue:(flag < 0)	
		    }
		
		}
	
	q:('$d(^CacheTemp("EPRQuality","LiveHosOverList",uid))) $$$OK
	
	s locid=""
	for
	{
		s locid=$o(^CacheTemp("EPRQuality","LiveHosOverList",uid,locid))
		q:locid=""
		s patient=""
		for
		{
			s patient=$o(^CacheTemp("EPRQuality","LiveHosOverList",uid,locid,patient))
			q:patient=""
		    s episodeID=""
		    for
		    {
			    
			   s episodeID=$o(^CacheTemp("EPRQuality","LiveHosOverList",uid,locid,patient,episodeID))
			   q:episodeID=""
			   s Data = $g(^CacheTemp("EPRQuality","LiveHosOverList",uid,locid,patient,episodeID))
			   s ^CacheTemp(uid,ind) = Data
			   s ind = ind + 1	
			}
		}
		}
	
	k ^CacheTemp("EPRQuality","LiveHosOverList",uid)
	
	q $$$OK
}

ClassMethod BuildLiveHosOverList(AEpisodeID As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	s Papmi = $p(objPaAdm,"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s Age=##Class(EPRservice.Quality.DataGather.AdmInfo).GetAge(AEpisodeID)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s DisLocID = $p(objPaAdm,"^",4)					//出院科室
	q:(DisLocID = "") ret
	
	s AdmWardID = $p(objPaAdm,"^",70)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s WardDesc=""
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "Other"
	s DoctorDesc = $s(AdmDoctorID '= "Other":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
	s PTAdmDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(AEpisodeID)
	s AdmitDate=$p(PTAdmDateTime,"^",1)
	s:(AdmitDate="") AdmitDate=$P($g(^PAADM(AEpisodeID)),"^",6)
	s DischDate=""
	s DischDate = $P($g(^PAADM(AEpisodeID)),"^",17)
	s Dischgdate=DischDate
	if (Dischgdate = "")
	{
		s Systemdatetime = $HOROLOG
		s Dischgdate = $p(Systemdatetime,",",1)
	}
	s LiveDays = ##class(EMRservice.DAL.GetPaAdmDetail).ResidentDays(AdmitDate,Dischgdate)
	q:(LiveDays<=30) ret
	//主要诊断
	s MainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(AEpisodeID)
	if (MainDiagnos = "")
    {
        s MainDiagnos = ##class(EMRservice.Ajax.patientInfo).getOPdiagnosis(AEpisodeID)
        //s MainDiagnos = $P(MainDiagnos,"^",3)
    }
	if (MainDiagnos '= "")
	{	
		s MainDiagnos = $P(MainDiagnos,"^",3)
		s MainDiagnos = $tr(MainDiagnos,"'","\'")
	}
	s MainDiagnos=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MainDiagnos)
	//##Class(EPRservice.Quality.DataGather.AdmInfo).GetMainDiagnos(AEpisodeID)
	///是否有30天大查房记录
	s Result1=..IsWriteMultiIsDoc(AEpisodeID,"59|在院患者住院超30天大查房记录")
	s IsIMedOver="否"
	s:Result1=1 IsIMedOver="是"
	//////住院时间超过30天患者评估表
	s Result2=..IsWriteMultiIsDoc(AEpisodeID,"58|住院时间超过30天患者评估表")
	s IsIDicussOver="否"
	s:Result2=1 IsIDicussOver="是"
	s AdmitDate=$zd(AdmitDate,3)
	s:(DischDate'="") DischDate=$zd(DischDate,3)
	s ^CacheTemp("EPRQuality","LiveHosOverList",AUniqueKey,DisLocID,Papmi,AEpisodeID)=$lb(LocDesc,WardDesc,RegNo,Name,Age,AdmitDate,DischDate,LiveDays,MainDiagnos,DoctorDesc,IsIMedOver,IsIDicussOver,DisLocID,AEpisodeID,Papmi)
     
	s ret = 1
	q ret
}

ClassMethod GetLiveHosOverListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnHosDetailListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetLiveHosOverListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnHosDetailListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 判定是否写了指定可重复模板
/// Debug:  ##class(EPRservice.Quality.BOQualityReport).IsWriteMultiIsDoc(EpisodeID,"365|记录\阶段小结")                           
ClassMethod IsWriteMultiIsDoc(AEpisodeID As %String, ATitles As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="") ret
	s result1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result1,1,2) = "0^") ret
	s dateTimes1 = $e(result1,3,$l(result1))
	s:dateTimes1'="" ret=1
	q ret
}

/// 质控医生工作量统计报表
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetDoctorProCount","2022-09-01","2022-09-20","","","D")
Query GetDoctorProCount(AStartDate As %String, AEndDate As %String, ALocIDs As %Text, ARuleID As %String, AAction As %String) As %Query(ROWSPEC = "CreateUserId,CreateUser,DoctorProCount") [ SqlProc ]
{
}

ClassMethod GetDoctorProCountExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocIDs As %Text, ARuleID As %String, AAction As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	k ^CacheTemp("EPRQuality","DoctorProCount",repid)	
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	for Tmpdate=StartDate:1:EndDate
	{
		s CreateUser = ""
		for {
			s CreateUser = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate,CreateUser))
			q:CreateUser=""
			s CreateUserId = $tr(CreateUser," ","")
			
			s SpotCheckID = ""
		    for {
			    
			     s SpotCheckID = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate," "_CreateUserId,SpotCheckID))
			     q:SpotCheckID=""
			
			     s ObjSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(SpotCheckID)
			     continue:((AAction="D")&&(ObjSpotCheck.IsActive'="Y"))
			     continue:((AAction="A")&&((ObjSpotCheck.IsAdmActive="")||(ObjSpotCheck.IsAdmActive="NULL")||(ObjSpotCheck.IsAdmActive=0)))
			     s EpisodeID = ObjSpotCheck.EpisodeID
			     s objPaAdm = $g(^PAADM(+EpisodeID))
				 continue:(objPaAdm = "") 
				 s DisLocID = $p(objPaAdm,"^",4)
			     continue:($listlength(ListLocID) > 0)&&($listfind(ListLocID,DisLocID) = 0)
			     continue:($d(^CacheTemp("EPRQuality","DoctorProCount",repid,CreateUserId,EpisodeID))=1)
			     s ^CacheTemp("EPRQuality","DoctorProCount",repid,CreateUserId,EpisodeID)=EpisodeID
		    }
		}
	}

	s TmpCreateUserId=""
	for
	{
		s TmpCreateUserId=$o(^CacheTemp("EPRQuality","DoctorProCount",repid,TmpCreateUserId))
		q:(TmpCreateUserId="")
		s TmpCreateUser = $p($g(^SSU("SSUSR",TmpCreateUserId)),"^",2)
		s DoctorProCount=0
		s AdmID=""
		for
		{
			s AdmID=$o(^CacheTemp("EPRQuality","DoctorProCount",repid,TmpCreateUserId,AdmID))
			q:(AdmID="")
			s DoctorProCount=DoctorProCount+1
			
		}
		s Data = $lb(TmpCreateUserId,TmpCreateUser,DoctorProCount)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	k ^CacheTemp("EPRQuality","DoctorProCount",repid)
	Quit $$$OK
}

ClassMethod GetDoctorProCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorProCountExecute ]
{
	
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDoctorProCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorProCountExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 质控医生工作量明细统计报表
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityReport","GetDoctorProDocDetail","2022-08-01","2022-09-20","","1","D","")
Query GetDoctorProDocDetail(AStartDate As %String, AEndDate As %String, ALocIDs As %Text, ARuleID As %String, AAction As %String, ACreatUserID As %String) As %Query(ROWSPEC = "CreateUserId,CreateUser,EpisodeID,Name,RegNo,MRNo,AdmitDate,DisDate,DisLocID,LocDesc,AdmDocID,DoctorDesc,Grade,Score") [ SqlProc ]
{
}

ClassMethod GetDoctorProDocDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocIDs As %Text, ARuleID As %String, AAction As %String, ACreatUserID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	k ^CacheTemp("EPRQuality","DoctorProDocDetail",repid)	
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s ListLocID=""
	s:(ALocIDs'="") ListLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	for Tmpdate=StartDate:1:EndDate
	{
		s CreateUser = ""
		for {
			s CreateUser = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate,CreateUser))
			q:CreateUser=""
			s CreateUserId = $tr(CreateUser," ","")
			continue:(ACreatUserID'="")&&(ACreatUserID'=CreateUserId)
			s SpotCheckID = ""
		    for {
			    
			     s SpotCheckID = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxCreateDateCreateUser",Tmpdate," "_CreateUserId,SpotCheckID))
			     q:SpotCheckID=""
			
			     s ObjSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(SpotCheckID)
			     continue:((AAction="D")&&(ObjSpotCheck.IsActive'="Y"))
			     continue:((AAction="A")&&((ObjSpotCheck.IsAdmActive="")||(ObjSpotCheck.IsAdmActive="NULL")||(ObjSpotCheck.IsAdmActive=0)))
			     s EpisodeID = ObjSpotCheck.EpisodeID
			     s objPaAdm = $g(^PAADM(+EpisodeID))
				 continue:(objPaAdm = "") 
				 s DisLocID = $p(objPaAdm,"^",4)
			     continue:($listlength(ListLocID) > 0)&&($listfind(ListLocID,DisLocID) = 0)
			     continue:($d(^CacheTemp("EPRQuality","DoctorProDocDetail",repid,CreateUserId,EpisodeID))=1)
			     s ^CacheTemp("EPRQuality","DoctorProDocDetail",repid,CreateUserId,EpisodeID)=EpisodeID
		    }
		}
	}
	s TmpCreateUserId=""
	for
	{
		s TmpCreateUserId=$o(^CacheTemp("EPRQuality","DoctorProDocDetail",repid,TmpCreateUserId))
		q:(TmpCreateUserId="")
		s TmpCreateUser = $p($g(^SSU("SSUSR",TmpCreateUserId)),"^",2)
		s AdmID=""
		for
		{
			s AdmID=$o(^CacheTemp("EPRQuality","DoctorProDocDetail",repid,TmpCreateUserId,AdmID))
			q:(AdmID="")
			s TmpobjPaAdm = $g(^PAADM(+AdmID))
			continue:(TmpobjPaAdm = "") 
			s PatientID = $p(TmpobjPaAdm,"^",1)
			s Papmi=PatientID
			s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
			//s MRNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",22)
			s MRNo =##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AdmID,"I",.ErrMsg)
			s AdmitDate = $p(TmpobjPaAdm,"^",6)
			s:(AdmitDate'="") AdmitDate=$zd(AdmitDate,3)
			s DisDate=$p(TmpobjPaAdm,"^",17)
			s:(DisDate'="") DisDate=$zd(DisDate,3)
			s DisLocID = $p(TmpobjPaAdm,"^",4)
			s AdmDocID = $p(TmpobjPaAdm,"^",9)
			s:(AdmDocID = "") AdmDocID = "-1"
			s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
			s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
 			s sc = result.Execute(AdmID,ARuleID,AAction)
			While (result.Next())
			{
				s Grade = result.Data("FinalGrade")
				s Score = result.Data("FinalScore")
			}
			s Data = $lb(TmpCreateUserId,TmpCreateUser,AdmID,Name,RegNo,MRNo,AdmitDate,DisDate,DisLocID,LocDesc,AdmDocID,DoctorDesc,Grade,Score)
		    s ^CacheTemp(repid,ind) = Data
		    s ind = ind + 1	
			
		}
	}
	k ^CacheTemp("EPRQuality","DoctorProDocDetail",repid)
	Quit $$$OK
}

ClassMethod GetDoctorProDocDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorProDocDetailExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDoctorProDocDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorProDocDetailExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
