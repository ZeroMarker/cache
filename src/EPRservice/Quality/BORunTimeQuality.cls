/// Class Name:		EPRservice.Quality.BORunTimeQuality
/// Description:	提示列表质控入口
/// Author:			Zuoxiang Xie
/// Create Date:	2010-04-26
/// Version:	
Class EPRservice.Quality.BORunTimeQuality Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.Quality.BORunTimeQuality).Test()
ClassMethod Test()
{
	s episodeID="3017845"
	s examRuleRowID=""
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
	s sc = rset.Execute(episodeID, examRuleRowID)
}

/// Desc:	获取违反提示列表质控标准的质控项目集合;	
/// Input:	AEpisodeID为当前患者就诊号;
/// 		AQualityRule为"RuleID_SSGroupID_CTLocID"格式字符串;
/// Output:	ExamEntry为质控项目RowId;
/// 		EntryDesc为质控项目描述;
/// 		ResultRowid为质控结果RowId;
/// 		DocName为患者主治医生名;
/// 		DocRowid为患者主治医生RowId;
/// 		EntryScore为质控项目分配的分数;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunTimeQuality","GetPromptList","8706","New_10_2")
Query GetPromptList(AEpisodeID As %String, AQualityRule As %String) As %Query(ROWSPEC = "ExamEntry,EntryDesc,ResultRowid,DocName,DocRowid,EntryScore,PhaseName,PhaseColor")
{
}

ClassMethod GetPromptListExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AQualityRule As %String) As %Status
{
	/* Debug  
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetPromptList","1AEpisodeID") = AEpisodeID 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetPromptList","2AQualityRule") = AQualityRule 
	*/
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s EpisodeID = $g(AEpisodeID)		
	s QualityRule = $g(AQualityRule)	
	q:(EpisodeID = "") $$$OK
	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(EpisodeID)
	q:(flag < 1) $$$OK
	
	s UniqueKey = repid
	 
	k ^CacheTemp("DHCEPRQQuality",UniqueKey)
 
	//第一步: 跑提示列表质控标准,并将结果记录在临时Global中
	//^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID)=EntryTitle
	
	s flag = ..RunQualityRule(EpisodeID, QualityRule, UniqueKey)
	 
	q:(flag < 1) $$$OK
	q:('$d(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID))) $$$OK
 
	//第二步: 从上面的临时Global中获取数据
	s RuleID=""
	for {
		s RuleID=$o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID))
		q:(RuleID="")
		s PhaseID=""
		for {
			s PhaseID = $o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID),-1)
			q:(PhaseID="")
			s EntryID=""
			for {
				s EntryID = $o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID)) 
				q:(EntryID="")
			    s Result = $g(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID))
			    s Result = $p(Result,"||",1)
			    s EntryTitle = $p(Result,"^",1)
			    s EntryTitle = $tr(EntryTitle,$c(2,1),"")
			    s PhaseName = $p(Result,"^",2)
			    s PhaseColor= $p(Result,"^",3)	
			    
			    //s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
			    s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
			    continue:(objEntry="")
			    //获取质控项目当前的分数
			    s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID)
			
			    //这里没有实际含义,因为提示列表项目不做持久化操作
			    s ResultRowID = ""
			    //取患者主治医信息
			    s DocID = $p($g(^PAADM(+EpisodeID)),"^",9),DocName = ""
			    s:(DocID '= "") DocName = $p($g(^CTPCP((DocID),1)),"^",2)
				
			    s Data = $lb(EntryID,EntryTitle,ResultRowID,DocName,DocID,EntryScore,PhaseName,PhaseColor)
			    s ^CacheTemp(repid,ind) = Data
			    s ind = ind + 1
			}
		}
	}
	k ^CacheTemp("DHCEPRQQuality",UniqueKey)
	
	q $$$OK
}

ClassMethod GetPromptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPromptListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind="") {			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPromptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPromptListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	运行质控标准并记录提示列表质控结果;
/// Input:	AEpisodeID为患者就诊号;
/// 		AQualityRule为"RuleID_SSGroupID_CTLocID"格式字符串;
/// Return:	成功返回1;否则返回0
/// Output:	记录提示列表病历质量检查结果;
/// 		^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,RuleID,EntryID) = EntryTitle
/// Debug:	w ##Class(EPRservice.Quality.BORunTimeQuality).RunQualityRule(AEpisodeID,AQualityRule,AUniqueKey)
ClassMethod RunQualityRule(AEpisodeID As %String, AQualityRule As %String, AUniqueKey As %String, AEventType As %String = "") As %String
{
	s ret = 0
	s EpisodeID = $g(AEpisodeID)
	q:(EpisodeID = "") ret
	
	s QualityRule = $g(AQualityRule)
	s SSGroupID = $p(QualityRule,"_",2)		//安全组
	s CTLocID = $p(QualityRule,"_",3)      	//登录科室
	s HospitalID = ""
	s:(CTLocID '= "") HospitalID = $p($g(^CTLOC(CTLocID)),"^",22)    //科室对应医院，不是集团化医院可能不设置
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable="Y")
	{
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunQualityRule:GetQualityResultNew")
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunQualityRule:GetQualityResult")
	}
	//[EpisodeID,TemplateID,InstanceIDs,SSGroupID,EventType,HospitalID,CheckStatus,PrintTemplateDocID,UniqueKey]
	d ds.Execute(EpisodeID,"","",SSGroupID,AEventType,HospitalID,"Save","",AUniqueKey)
	d ds.Close()
	
	s ret = 1
	q ret
}

/// Desc:	执行病历操作质控检查;
/// Input:	AEpisodeID为患者就诊号;
/// 		ATemplateID为界面模板RowID;
/// 		AEventTypew为病历操作事件类型("Print","Save"或"Commit");  
/// 		AInstanceIDs为可重复模板实例数据集合(唯一模板传空即可);
/// Return:	UniqueKey = $i(^CacheTemp)
/// Output:	记录病历质量检查结果
/// 		^CacheTemp("DHCEPRQQuality",AUniqueKey,AEpisodeID,RuleID,EntryID) = EntryTitle
/// Debug:	w ##Class(EPRservice.Quality.BORunTimeQuality).GetRunTimeQuality(AEpisodeID,ATemplateID,AEventType,AInstanceIDs,APrintTemplateDocID)
ClassMethod GetRunTimeQuality(AEpisodeID As %String, ATemplateID As %String, AEventType As %String, AInstanceIDs As %String, APrintTemplateDocID As %String) As %String
{
	/* Debug
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetRunTimeQuality","1AEpisodeID") = AEpisodeID 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetRunTimeQuality","2ATemplateID") = ATemplateID 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetRunTimeQuality","3AEventType") = AEventType 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetRunTimeQuality","4AInstanceIDs") = AInstanceIDs 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetRunTimeQuality","5APrintTemplateDocID") = APrintTemplateDocID 
	*/
	s ret = ""
	q:((AEpisodeID = "")||(AEventType = "")||((ATemplateID = "")&&'(AEventType [ "Confirm"))) ret

	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(AEpisodeID)
	q:(flag < 1) ret
	
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("DHCEPRQQuality",UniqueKey)

	s SSGroupID = $p(AEventType,"^",2)  //登录安全组
	s LocID = $p(AEventType,"^",3)      //登录科室
	s HospitalID = ""
	s:(LocID '= "") HospitalID = $p($g(^CTLOC(LocID)),"^",22)    //科室对应医院，不是集团化医院可能不设置
	s EventType = $p(AEventType,"^",1)
	s CheckStatus = ""
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable="Y")
	{
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunQualityRule:GetQualityResultNew")
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunQualityRule:GetQualityResult")
	}
	d ds.Execute(AEpisodeID,ATemplateID,AInstanceIDs,SSGroupID,EventType,HospitalID,CheckStatus,APrintTemplateDocID,UniqueKey)
	d ds.Close()
	q UniqueKey
}

/// Desc:	取病案质控控制类型
/// Input:	ATemplateID为界面模板ID;
/// 		AEventType为病历操作事件类型;
/// Return: 控制类型("ret=0"不允许通过  "ret=1"允许通过)
/// Debug:	w ##Class(EPRservice.Quality.BORunTimeQuality).GetControlType(ATemplateID,AEventType)
ClassMethod GetControlType(ATemplateID As %String, AEventType As %String) As %String
{
	s ret = 1
	s ControlTypeRet = ""
	s SSGroupID = $p(AEventType,"^",2)  //登录安全组
	s LocID = $p(AEventType,"^",3)      //登录科室
	s HospitalID = $p($g(^CTLOC(+LocID)),"^",22)    //科室对应医院，不是集团化医院可能不设置
	s EventType = $p(AEventType,"^",1)
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.BORunQualityRule:GetControlType")
	d ds.Execute(SSGroupID,EventType,HospitalID)
	While(ds.Next() && (ControlTypeRet = ""))
	{
		s ControlTypeRet = ds.Data("ControlType")
	}
	d ds.Close()

	s:(ControlTypeRet '= "") ret = ControlTypeRet
	q ret
}

/// Desc:	获取患者违反提示列表标准的质控项目个数;
/// Input:	AEpisodeID为患者就诊号;
/// 		ASSGroupID为操作者安全组;
/// 		ACTLocID为操作者所在科室;
/// 		AQualityVerFlag为质控版本信息(兼容医政组原有质控逻辑);	
/// Debug:	w ##Class(EPRservice.Quality.BORunTimeQuality).GetPromptCountByEpisodeID("201871",576,34)
ClassMethod GetPromptCountByEpisodeID(AEpisodeID As %String, ASSGroupID As %String, ACTLocID As %String, AQualityVerFlag As %String = "New") As %Integer
{
	s ret = 0
	q:(AEpisodeID = "")||(ASSGroupID = "")||(ACTLocID = "") ret
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
	s sc = result.Execute(AEpisodeID, AQualityVerFlag_"_"_ASSGroupID_"_"_ACTLocID)
	While(result.Next())
	{
		s ret = ret + 1	
	}
	d result.Close()
	q ret
}

/// Creator:Candyxu
/// Date:   2011-11-24 
/// Desc:   判断质控条目属于那个阶段
/// Input:  AEpisodeID 患者就诊号
///         AEntryID 质控项目ID
/// Debug:  do ##Class(EPRservice.Quality.BORunTimeQuality).GetQualityPhase("8706","31584")
ClassMethod GetQualityPhase(AEpisodeID As %String, AEntryID As %String) As %String
{
 	s Result=""
 	s Seq=""
 	for {
	 	s Seq=$o(^DHCEPRM.QualityPhasesModifyI("idxEntrySequence",AEntryID,Seq))
	 	q:(Seq="")
	 	s RowID=""
	 	for {
		 	s RowID = $o(^DHCEPRM.QualityPhasesModifyI("idxEntrySequence",AEntryID,Seq,RowID))
		 	q:(RowID = "")
		 	s QueryID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),4)
            s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,QueryID)
            Continue:(flag '= "1")
	        s PhaseID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),3)    // 阶段ID
	        s PhaseName = $list(^DHCEPRM.QualityPhaseStatusD(PhaseID),2) //阶段名称
	        s PhaseColor = $list(^DHCEPRM.QualityPhaseStatusD(PhaseID),4) //阶段颜色
	        s Result = PhaseID_"^"_PhaseName_"^"_PhaseColor
		}
	}
 	q Result
}

/// creator:yhy
/// date:   2017-07-27
/// Desc:	获取违反提示列表质控标准的质控项目集合;	
/// Input:	AEpisodeID为当前患者就诊号;
/// 		AQualityRule为"RuleID_SSGroupID_CTLocID"格式字符串;
/// Output:	ExamEntry为质控项目RowId;
/// 		EntryDesc为质控项目描述;
/// 		ResultRowid为质控结果RowId;
/// 		DocName为患者主治医生名;
/// 		DocRowid为患者主治医生RowId;
/// 		EntryScore为质控项目分配的分数;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunTimeQuality","GetQualityResultList","321013","2_29_190")
Query GetQualityResultList(AEpisodeID As %String, AQualityRule As %String, AEventType As %String = "Prompt") As %Query(ROWSPEC = "StructName,StrDate,EndDate,Hours:%Float,FinishDate,OverFlag,EntryScore,EntryID,instanceInfo,Resume,DocId")
{
}

ClassMethod GetQualityResultListExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AQualityRule As %String, AEventType As %String = "Prompt") As %Status
{
	/* Debug  
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetPromptList","1AEpisodeID") = AEpisodeID 
	s ^CacheTemp("EPRQuality","BORunTimeQuality","GetPromptList","2AQualityRule") = AQualityRule 
	*/
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s EpisodeID = $g(AEpisodeID)		
	s QualityRule = $g(AQualityRule)	
	q:(EpisodeID = "") $$$OK
	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(EpisodeID)
	q:(flag < 1) $$$OK
	
	s UniqueKey = repid
	 
	k ^CacheTemp("DHCEPRQQuality",UniqueKey)
 
	//第一步: 跑提示列表质控标准,并将结果记录在临时Global中
	//^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID)=EntryTitle
	
	s flag = ..RunQualityRule(EpisodeID, QualityRule, UniqueKey, AEventType)
	 
	q:(flag < 1) $$$OK
	q:('$d(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID))) $$$OK
	Set langid=20
    if ($d(%session))
    {
		set langid=+$g(%session.Data("LOGON.LANGID"))
    }
	//第二步: 从上面的临时Global中获取数据
	s RuleID=""
	for {
		s RuleID=$o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID))
		q:(RuleID="")
		s PhaseID=""
		for {
			s PhaseID = $o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID),-1)
			q:(PhaseID="")
			s EntryID=""
			for {
				s EntryID = $o(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID)) 
				q:(EntryID="")
			    s Result = $g(^CacheTemp("DHCEPRQQuality",UniqueKey,EpisodeID,RuleID,PhaseID,EntryID))
			    
				if (AEventType="Intention")
			    {
				    s EntryTitle = $p(Result,"||",1)
				    s EntryTitle = $p(EntryTitle,"^",1)
				    s EntryTitle = $tr(EntryTitle,$c(2,1),"")
				    //多语种
				    s EntryTitle = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title",EntryTitle)
				    s Result = $p(Result,"||",2,*)
				    for i=1:1:$l(Result,"#")
				    {
					    s Results = $p(Result,"#",i)
					    continue:(Results="-1")&&(Result["#")
					    s StructName = EntryTitle
					    s StructName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
					    //s flag = $p(Results,"^",1)
					    s StrDate = ""
					    s EndDate= ""
					    s Hours = ""
					    s FinishDate = ""
					    s OverFlag = ""
					    s:(Hours["-") OverFlag = "是"
					    
		                s:(OverFlag = "是") OverFlag = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title",OverFlag,langid)
					    s:(Hours'="") Hours=$j(Hours,2,2)
					    s:(Hours'="") Hours=Hours_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title","小时",langid)
						//获取质控项目当前的分数
				    	s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID)
				    	s Resume="",instanceInfo=""
                        s:(Result["#") Resume=$p(Results,"@",1)
                       	s:(Result["@") instanceInfo=$p(Results,"@",2)
				    	s Data = $lb(EntryTitle,StrDate,EndDate,Hours,FinishDate,OverFlag,EntryScore,EntryID,instanceInfo,Resume,"")
			    		s ^CacheTemp(repid,ind) = Data
			    		s ind = ind + 1	
				    }
			    }
			    else
			    {
					s EntryTitle = $p(Result,"||",1)
					s EntryTitle = $p(EntryTitle,"^",1)
					s EntryTitle = $tr(EntryTitle,$c(2,1),"")
					//多语种
				    s EntryTitle = ##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title",EntryTitle)
					s Result = $p(Result,"||",2)
					s:($l(Result,";")'=0) Length = $l(Result,";")
					s:($l(Result,";")=0) Length = 1
					for i=1:1:Length
					{
						s Results = $p(Result,";",i)
						//s StructName = $p(Results,"^",2)
						//s StructName = $tr(StructName,"\"," ")
						s StructName = EntryTitle
						s StructName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(StructName)
						s flag = $p(Results,"^",1)
						s StrDate = $p(Results,"^",3)
						s:($p(StrDate," ",2)="") StrDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",StrDate)
						s:($p(StrDate," ",2)'="") StrDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",StrDate)
						s EndDate= $p(Results,"^",4)
						s:($p(EndDate," ",2)="") EndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",EndDate)
						s:($p(EndDate," ",2)'="") EndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",EndDate)					
						s Hours = $p(Results,"^",5)
						s FinishDate = $p(Results,"^",6)
						s:($p(FinishDate," ",2)="") FinishDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",FinishDate)
						s:($p(FinishDate," ",2)'="") FinishDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",FinishDate)
						s OverFlag = ""
						s:(Hours["-") OverFlag = "是"
						s:(OverFlag = "是") OverFlag = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title",OverFlag,langid)
						s:(Hours'="") Hours=$j(Hours,2,2)
						s:(Hours'="") Hours=Hours_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Quality.QualityPool","Title","小时",langid)
						//获取质控项目当前的分数
						s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID)
						s StructID=##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetStructIDByEntry(EntryID)
						s DocId=##Class(EPRservice.Quality.DataAccess.BOQualityStruct).GetDocIDByStructID(StructID)
						s Data = $lb(EntryTitle,StrDate,EndDate,Hours,FinishDate,OverFlag,EntryScore,EntryID,"","",DocId)
						s ^CacheTemp(repid,ind) = Data
						s ind = ind + 1
					}
			    }
			}
		}
	}
	
	q $$$OK
}

ClassMethod GetQualityResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityResultListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind="") {			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityResultListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// creator:HKY
/// date:   2019-12-04
/// Desc:	实时获取病历分数与等级
///         (AEpisodeID,1,"A")环节手工评价分数与等级
///         (AEpisodeID,"1^6","A")环节手工+自动评价分数与等级
///         (AEpisodeID,"1","D")终末手工评价分数与等级
///         (AEpisodeID,"1^7","D")终末手工+自动评价分数与等级        
/// Input:	AEpisodeID为当前患者就诊号;
/// 		ARuleIDs质控标准ID字符串用"^"分隔
///         AAction:环节质控"A",终末质控"D"
///         AStartDate:质控起始日期
///         AEndDate:质控截止日期
/// Output:	ExamEntry为质控项目RowId;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BORunTimeQuality","GetDocQualityScore","5541","1^6","A")
Query GetDocQualityScore(AEpisodeID As %String, ARuleIDs As %String, AAction As %String = "", AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "FinalGrade,FinalScore,BCount,CCount,TempDeScore")
{
}

ClassMethod GetDocQualityScoreExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ARuleIDs As %String, AAction As %String = "", AStartDate As %String = "", AEndDate As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(AEpisodeID = "")||(ARuleIDs="") $$$OK
	
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	s FinalGrade = "甲", FinalScore = 100, BCount = 0, CCount = 0
	s ret = FinalGrade_"^"_FinalScore

	
	//获得级别分数参数
	s:(IsBSQualityEnable'="Y") QPID = $o(^DHCEPRM.QualityParamsI("IdxCode","ScoreStandard",""))
	s:(IsBSQualityEnable="Y") QPID = $o(^CT.MA.QC.QualityParamsI("IdxCode","ScoreStandard",""))
	if (QPID = "")
	{ 
		s GreadScore = "90^70"
	}
	else
	{
		s:(IsBSQualityEnable'="Y") GreadScore = $li(^DHCEPRM.QualityParamsD(QPID),2)
		s:(IsBSQualityEnable="Y") GreadScore = $li(^CT.MA.QC.QualityParamsD(QPID),4)
	}

    s GreadA = $p($g(GreadScore),"^",1) if (GreadA = ""){s GreadA = 90}
    s GreadB = $p($g(GreadScore),"^",2) if (GreadB = ""){s GreadB = 70}
    s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"^")
	for Ind = 1:1:$listlength(RuleIDs)
	{
	s ARuleID = $listget(RuleIDs,Ind)
	continue:(ARuleID = "")
    s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,ResultID))
		q:(ResultID = "")
		
		s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID) 
		s Action = objResult.Action
		continue:(ARuleID=1)&&(AAction'="")&&(Action'=AAction)
		s ExamineDate = objResult.ExamineDate
		continue:(ExamineDate = "")
		s ExamineDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ExamineDate)," ",1)
		continue:(AStartDate '= "")&&(ExamineDate < AStartDate)
		continue:(AEndDate '= "")&&(ExamineDate > AEndDate)	
	    s ChildSub = ""
        for {
		       s ChildSub = $o(^DHCEPRQ.QualityResultDetailI("IdxResult",ResultID,ChildSub))
		       q:(ChildSub = "")
		       s DetailID = ResultID_"||"_ChildSub
		       s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(DetailID)
				
		       s EntryID = objDetail.EntryDR
		       // 如果这个条目被删除了，则不参与计分
		       continue:(IsBSQualityEnable'="Y")&&($g(^DHCEPRM.QualityEntryD(+EntryID)) = "")
		       continue:(IsBSQualityEnable="Y")&&($g(^CT.MA.QC.QualityEntryD(+EntryID)) = "")
		       s:(IsBSQualityEnable'="Y") objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(+EntryID)
		       s:(IsBSQualityEnable="Y") objEntry = ##Class(CT.MA.QC.QualityEntry).%OpenId(+EntryID)
		       continue:(objEntry = "")
		       s StructID = objEntry.StructDR
		       s:(IsBSQualityEnable'="Y") objStruct = ##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
		       s:(IsBSQualityEnable="Y") objStruct = ##Class(CT.MA.QC.QualityStruct).%OpenId(StructID)
		       continue:(objStruct = "")
			   s RuleDR=objEntry.RuleDR
			   s EntryScore = objEntry.Score	
			   s EntryGrade = objEntry.VetoGrade
			   s EntryIsVeto=objEntry.IsVeto
			   s ExamCount=objDetail.ExamCount
			   s IsMultiErr = objEntry.IsMultiErr
			   s TotalScore = (+EntryScore) * (+ExamCount)	
				
			   if (EntryGrade = "乙级")&&(EntryIsVeto="Y")
			   {	
					s BCount = BCount + 1	
			   }
			   elseif (EntryGrade = "丙级")&&(EntryIsVeto="Y")
			   {
					s CCount = CCount + 1	
			   }	
	
			   s StructID = objEntry.StructDR
			   s CategoryID = objStruct.CategoryDR
			   continue:(CategoryID = "")
				
			   s objCategory = $g(^DHCEPRM.QualityCategoryD(+CategoryID))
			   s:(IsBSQualityEnable="Y") objCategory = $g(^CT.MA.QC.QualityCategoryD(+CategoryID))
			   continue:(objCategory = "")
									
			   s ParentCategoryID = $list(objCategory,2)
			   continue:(ParentCategoryID = "")
		 					
			   s ^CacheTemp("EPRQuality","EPRGradeScore",repid,ParentCategoryID,CategoryID) = (+$g(^CacheTemp("EPRQuality","EPRGradeScore",repid,ParentCategoryID,CategoryID))) + TotalScore
        }
      }
	 
	}
	s Score = ##Class(EPRservice.Quality.BOQualityReport).GetFinalScore(repid)
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
	
    s Data = $lb(FinalGrade,FinalScore,BCount,CCount,TempDeScore)
    s ^CacheTemp(repid,ind) = Data
    s ind = ind + 1
    k ^CacheTemp("EPRQuality","EPRGradeScore",repid)
    Quit $$$OK
}

ClassMethod GetDocQualityScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocQualityScoreExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocQualityScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocQualityScoreExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind="") {			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// add ：  yhy
///         2019-03-21
/// Desc:	获取违反编目质控标准的质控项目集合;	
/// Input:	AEpisodeID为当前患者就诊号;
/// Output:	EntryDesc为质控项目描述;
/// debug:	d ##Class(EPRservice.Quality.BORunTimeQuality).GetCodingQuality(59)
ClassMethod GetCodingQuality(aEpisodeID As %String, aRuleCode As %String = "I") As %String
{
	Set return=""
	Quit:(aEpisodeID="")||(aRuleCode="") return
	Set RuleID	=$o(^DHCEPRM.QualityRuleI("IdxCode",aRuleCode,""))
	Quit:RuleID="" return
	
	Set EntryID		= ""
	Set EntryTitles	= ""
	For{
		Set EntryID	= $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_RuleID,EntryID))
		Quit:EntryID=""
		
		Set objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  
		Continue:'$IsObject(objEntry)
		Set isEntryActive	= objEntry.IsActive   
		Continue:isEntryActive'="Y"
		Set poolId			= objEntry.PoolDR    
		Continue:poolId=""
		
		Set objPool			= ##Class(EPRmeta.Quality.QualityPool).%OpenId(poolId)
		Continue:'$IsObject(objPool)
		Continue:objPool.IsActive'="Y"
		Set EntryTitle = objPool.Title
		
		; 检查表达式
		Set ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(aEpisodeID,EntryID,"")
		
		If ($p(ExpressionResult,"^",2)'="") {
			Set EntryTitle	= $p(ExpressionResult,"^",2)
		}
		
		If (+ExpressionResult<0) {
			If (EntryTitles'=""){
				Set EntryTitles = EntryTitles_"^"_EntryTitle
			}Else{
				Set EntryTitles =EntryTitle
			}
		}
		
		Continue:ExpressionResult>=0
	}
	
	Quit EntryTitles
}

}
