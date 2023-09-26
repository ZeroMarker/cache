Class EPRservice.Quality.DataAccess.BOQualityAiLog Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityAiLog";

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵自动任务增加数据 (AiLog、AiLogDetail)
/// Input:			^
/// Output          1 成功 0失败
/// Debug: ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).SaveAiLog("1^A^854^病案首页2^^R^^^^2021-08-06^12:32:48^4")
ClassMethod SaveAiLog(AInput As %String) As %String
{
	s ret=0
	q:(AInput="") ret
	
	s EpisodeID	 = $p(AInput,"^",1)					
	s Action	 = $p(AInput,"^",2)         		
	s EntryDR	 = $p(AInput,"^",3)      		
	s Title	 = $p(AInput,"^",4)     		
	s ResumeText = $p(AInput,"^",5) 			
	s Status = $p(AInput,"^",6)					
	s TriggerDate	 = $p(AInput,"^",7)      		
	s TriggerTime	 = $p(AInput,"^",8) 				
	s TriggerUserDR  = $p(AInput,"^",9)
	s TriggerLocDR	= $p(AInput,"^",10)
	s RepairDate	 = $p(AInput,"^",11)      		
	s RepairTime	 = $p(AInput,"^",12) 				
	s RepairUserDR  = $p(AInput,"^",13)
	s RepairLocDR	= $p(AInput,"^",14)                
	
	q:(EpisodeID = "")||(EntryDR = "")||(Title = "") ret
	
	TStart
	
	s InString = EpisodeID_"^"_Action
	s flag = ..CreateAiLog(InString)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	
	s AiLogID=flag
	s InString = AiLogID_"^"_EpisodeID_"^"_Action_"^"_EntryDR_"^"_Title_"^"_ResumeText_"^"_Status_"^"_TriggerDate_"^"_TriggerTime_"^"_TriggerUserDR_"^"_TriggerLocDR_"^"_RepairDate_"^"_RepairTime_"^"_RepairUserDR_"^"_RepairLocDR
	s flag = ..UpdateAiLogDeatil(InString)
	
	TRollback:(flag < 1)
	q:(flag < 1) ret
	
	s InString = AiLogID_"^"_Status
	s flag = ..UpdateAiLog(InString)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	
	TCommit
	s ret = 1
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			插入数据; (AiLog)
/// Input:			EpisodeID_"^"_Action 
/// Output          成功：AiLogID  失败：-1
/// Debug:	d ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CreateAiLog("1^A")
ClassMethod CreateAiLog(AInput As %String) As %String
{
	s EpisodeID = $p(AInput,"^",1)
	s Action = $p(AInput,"^",2)
	
	s AiLogID = $o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeID," "_Action,""))
	q:(AiLogID '= "") AiLogID
	
	s objQAiLog = ##Class(EPRinstance.Quality.QualityAiLog).%New()
	s objQAiLog.EpisodeID = EpisodeID
	s objQAiLog.Action = Action
	s objQAiLog.Num = 0
	s objQAiLog.RepairNum = 0
	s objQAiLog.ErrorNum = 0
	s sc = objQAiLog.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		s AiLogID = -1
	}
	else
	{
		s AiLogID = objQAiLog.%Id()
	}
	d objQAiLog.%Close()	
	q AiLogID
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			插入数据; (AiLogDeatil)
/// Input:			AiLogID_"^"_EpisodeID_"^"_Action_"^"_EntryDR_"^"_Title_"^"_ResumeText_"^"_Status_"^"_TriggerDate_"^"_TriggerTime_"^"_TriggerUserDR_"^"_RepairDate_"^"_RepairTime_"^"_RepairUserDR 
/// Output          成功：AiLogDeatilid  失败：-1
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).UpdateAiLogDeatil()
ClassMethod UpdateAiLogDeatil(AInput As %String) As %String
{
	s AiLogID	 = $p(AInput,"^",1)	
	s EpisodeID	 = $p(AInput,"^",2)					
	s Action	 = $p(AInput,"^",3)         		
	s EntryDR	 = $p(AInput,"^",4)      		
	s Title	 = $p(AInput,"^",5)     		
	s ResumeText = $p(AInput,"^",6) 			
	s Status = $p(AInput,"^",7)					
	s TriggerDate	 = $p(AInput,"^",8)      		
	s TriggerTime	 = $p(AInput,"^",9) 				
	s TriggerUserDR  = $p(AInput,"^",10)
	s TriggerLocDR  = $p(AInput,"^",11)
	s RepairDate	 = $p(AInput,"^",12)      		
	s RepairTime	 = $p(AInput,"^",13) 				
	s RepairUserDR  = $p(AInput,"^",14)
	s RepairLocDR  = $p(AInput,"^",15)
	
	s AiLogDeatilID=""
	for{
		s AiLogDeatilID = $o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",AiLogID," "_EntryDR," E",AiLogDeatilID))	
		q:(AiLogDeatilID="")
		s title=$lg($g(^DHCEPRQ.QualityAiLogD(AiLogID,"Details",AiLogDeatilID)),4)
		continue:(title'=Title)
		q
	}
	
	
	if (AiLogDeatilID'="")&&(Status="R")
	{
		s objQDetail = ##Class(EPRinstance.Quality.QualityAiLogDetail).%OpenId(AiLogID_"||"_AiLogDeatilID)
		s objQDetail.Status		=Status
		s objQDetail.RepairDate = RepairDate
		s objQDetail.RepairTime = RepairTime
		s objQDetail.RepairUserDR = RepairUserDR
		s objQDetail.RepairLocDR = RepairLocDR
	}elseif (AiLogDeatilID="")&&(Status="E"){
		s objQDetail = ##Class(EPRinstance.Quality.QualityAiLogDetail).%New()
		s objQDetail.EpisodeID	= EpisodeID
		s objQDetail.EntryDR	=EntryDR
		s objQDetail.Title		=Title
		s objQDetail.ResumeText	=ResumeText 
		s objQDetail.Status		=Status
		s objQDetail.TriggerDate=TriggerDate
		s objQDetail.TriggerTime=TriggerTime
		s objQDetail.TriggerUserDR=TriggerUserDR
		s objQDetail.TriggerLocDR=TriggerLocDR
		s objQAiLog = ##Class(EPRinstance.Quality.QualityAiLog).%OpenId(AiLogID)
		if $IsObject(objQAiLog)
		{
			s objQDetail.TheAiLog=objQAiLog
		}
	}else{
		q "-1"
	}
	
	set sc=objQDetail.%Save()
	if $system.Status.IsError(sc) 
	{                               
   		d $system.OBJ.DisplayError(sc)  
   		q "-1"
	}
	else
	{
		set id = objQDetail.%Id()
	}
	d objQDetail.%Close()
	q id
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			更新数量; (AiLog)
/// Input:			AiLogID_"^"_Status
/// Output          成功：AiLogid  失败：-1
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).UpdateAiLog()
ClassMethod UpdateAiLog(AInput As %String) As %String
{
	s ret = -1
	
	s AiLogID = $p(AInput,"^",1)
	s Status = $p(AInput,"^",2)
	
	s objQAiLog = ##Class(EPRinstance.Quality.QualityAiLog).%OpenId(AiLogID)
	
	s Num=objQAiLog.Num
	s ErrorNum=objQAiLog.ErrorNum
	s RepairNum=objQAiLog.RepairNum
	
	if (Status="E")
	{
		s Num=Num+1
		s ErrorNum=ErrorNum+1
		
	}elseif (Status="R")
	{
		s RepairNum=RepairNum+1
		s ErrorNum=ErrorNum-1
	}
	s objQAiLog.Num=Num
	s objQAiLog.ErrorNum = ErrorNum
	s objQAiLog.RepairNum = RepairNum

	s sc = objQAiLog.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		q ret
	}
	else
	{
		s ret = objQAiLog.%Id()
	}
	d objQAiLog.%Close()
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			对比内涵检测数据和表中数据 更新
/// Input:			EpisodeID	就诊号
/// 				Action		阶段 "A"
/// 				UserID		责任医生id
/// 				LocID		责任科室id
/// 				ARuleID		内涵质控标准Ruleid
/// 				AUniqueKey	进程号
/// Output          成功：1  失败：0
/// Debug:
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).ContrastAiLog(1,"A",4,1)
ClassMethod ContrastAiLog(EpisodeID As %String, Action As %String, UserID As %String, LocID As %String, ARuleID As %String, AUniqueKey As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Action="")||(AUniqueKey="") ret
	
	s AiLogid=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeID," "_Action,""))
	//TStart
		//以之前的数据为基准对比
		s entryDR=""
		for {
			s entryDR=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",AiLogid,entryDR))
			q:(entryDR="")
			s detailid=""
			for{
				s detailid=$o(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",AiLogid,entryDR," E",detailid))
				q:(detailid="")
				s obj=$g(^DHCEPRQ.QualityAiLogD(AiLogid,"Details",detailid))
				s title=$lg(obj,4)
				//有一样的entryDR
				if ($d(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,$tr(entryDR," ","")))=10)
				{
					s numid="",repairFlag=0
					for{
						s numid=$o(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,$tr(entryDR," ",""),numid))	
						q:(numid="")
						q:(repairFlag=1)
						s result=$g(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,$tr(entryDR," ",""),numid))
						s resulttitle=$p(result,"@",1)
						s resultInstanceId=$p(result,"@",2)
						//有一样的title
						if ($zcvt($tr(resulttitle," ",""),"U")=$tr(title," ","")) 
						{
							//b ;1
							k ^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,$tr(entryDR," ",""),numid)
							s repairFlag=1
							q
						}
						
					}
					if (repairFlag=0)
					{
						//没有就是已经修复			
						s InString =EpisodeID_"^"_Action_"^"_$tr(entryDR," ","")_"^"_title_"^"_""_"^"_"R"_"^^^^^"_$zd($p($h,",",1),3)_"^"_$zt($p($h,",",2),1)_"^"_UserID_"^"_LocID
						s flag=..SaveAiLog(InString)
						//b ;1r	
					}
				}else{
					
					//没有就是已经修复
					s InString =EpisodeID_"^"_Action_"^"_$tr(entryDR," ","")_"^"_title_"^"_""_"^"_"R"_"^^^^^"_$zd($p($h,",",1),3)_"^"_$zt($p($h,",",2),1)_"^"_UserID_"^"_LocID
					s flag=..SaveAiLog(InString)
					//b ;r
				}
			
			}
		
		
	}
	s entrydr=""
		for{
			s entrydr=$o(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,entrydr))
			q:(entrydr="")
			s num=""
			for {
				s num=$o(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,entrydr,num))
				q:(num="")
				//没有就是新触犯的
				s result=$g(^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,entrydr,num))
				s resulttitle=$p(result,"@",1)
				s resultInstanceId=$p(result,"@",2)
				s InString =EpisodeID_"^"_Action_"^"_$tr(entrydr," ","")_"^"_$tr(resulttitle,"","")_"^"_resultInstanceId_"^"_"E"_"^"_$zd($p($h,",",1),3)_"^"_$zt($p($h,",",2),1)_"^"_UserID_"^"_LocID_"^^^^"
				s flag=..SaveAiLog(InString)
				//b ;e
				k ^CacheTemp("EPRQuality","AiLog",AUniqueKey,EpisodeID,ARuleID,entrydr,num)
			}	
		}
		
	//TRollBack
	q 1
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			自动任务检查内涵病历质量
/// Input:			ACode		内涵质控标准code N
/// Output          ret<=0失败; ret>0成功;
/// Debug:			w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).AiAutoJob("N")
ClassMethod AiAutoJob(ACode As %String)
{
	s ret=0
	q:(ACode="") ret
	
	s JobDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
	s AdmitFlag = ..AiAutoJobByAdmit(ACode)
	s:(AdmitFlag'=1) ^DHCEPRQERSTLog("AiAutoJob_Admit",JobDate)=$lb("Err")
	
	s Days = 2
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AiAutoDischDays",""))
	s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	s DischFlag=..AiAutoJobByDisch(ACode,JobDate,Days)
	s:(DischFlag'=1) ^DHCEPRQERSTLog("AiAutoJob_Disch",JobDate)=$lb("Err")
	
	s ret=1
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			自动任务检查在院患者内涵病历质量
/// Input:			ACode		内涵质控标准code N
/// Output          ret<=0失败; ret>0成功;
/// Debug:			w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).AiAutoJobByAdmit("N")
ClassMethod AiAutoJobByAdmit(ACode As %String) As %String
{
	s ret = 0
	q:(ACode = "") ret
	s UniqueKey = $i(^CacheTemp)
	s ARuleID=$o(^DHCEPRM.QualityRuleI("IdxCode",ACode,""))
	q:(ARuleID="") ret
	
	s EpisodeID = ""
	for {
		s EpisodeID =$o(^PAADMi("AdmTypeCurr","I",EpisodeID))
		q:(EpisodeID = "")
		
		//检查就诊是否有效
		s Flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
		continue:(Flag < 1)
		
		s objPaAdm = $g(^PAADM(+EpisodeID))
		continue:(objPaAdm = "")
		
		s AdmLocID = $p(objPaAdm,"^",4)
		continue:(AdmLocID = "")
		
		s AdmDocID = $p(objPaAdm,"^",9)
		s:(AdmDocID="") AdmDocID="-1"
		
		//创建AiLog结果
		s RString = EpisodeID_"^"_"A"
		s ResultID = ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CreateAiLog(RString)
		//##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CreateAiLog("1^A")
		continue:(ResultID < 0)
		
		//检查内涵质控点
		s count=..CheckAiEntry(ARuleID,EpisodeID,UniqueKey)

		//对比结果存数据
		s flag=..ContrastAiLog(EpisodeID,"A",AdmDocID,AdmLocID,ARuleID,UniqueKey)
		//##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).ContrastAiLog(1,"A",4,1,9,1)
		
	}
	s ret = 1
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			自动任务检查出院患者内涵病历质量
/// Input:			ACode		内涵质控标准code N
/// Output          ret<=0失败; ret>0成功;
/// Debug:			w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).AiAutoJobByDisch("N","2019-02-15 01:00:00",1)
ClassMethod AiAutoJobByDisch(ACode As %String, AJobDate As %String, ADays As %String) As %String
{
	s ret = 0
	q:(ACode = "") ret
	s UniqueKey = $i(^CacheTemp)
	s ARuleID=$o(^DHCEPRM.QualityRuleI("IdxCode",ACode,""))
	q:(ARuleID="") ret

	s JobDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AJobDate)
	s JobDate = +$p(JobDate," ",1)
	s ADays = +$g(ADays)
	s DischDate = JobDate - ADays
	
	s EpisodeID = ""
	for {
		s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
		q:(EpisodeID = "")
		
		//检查就诊是否有效
		s Flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
		continue:(Flag < 1)
		
		s objPaAdm = $g(^PAADM(+EpisodeID))
		continue:(objPaAdm = "")
		
		s VisitStatus = $p(objPaAdm,"^",20)
		continue:(VisitStatus '= "D") 
		
		s AdmType = $p(objPaAdm,"^",2)
		continue:(AdmType '= "I")
		
		s AdmLocID = $p(objPaAdm,"^",4)
		continue:(AdmLocID = "")
		
		s AdmDocID = $p(objPaAdm,"^",9)
		s:(AdmDocID="") AdmDocID="-1"
		
		//创建AiLog结果
		s RString = EpisodeID_"^"_"D"
		s ResultID = ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CreateAiLog(RString)
		//##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CreateAiLog("59^D")
		continue:(ResultID < 0)
		
		//检查内涵质控点
		s count=..CheckAiEntry(ARuleID,EpisodeID,UniqueKey)

		//对比结果存数据
		s flag=..ContrastAiLog(EpisodeID,"D",AdmDocID,AdmLocID,ARuleID,UniqueKey)
		//##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).ContrastAiLog(59,"D",4,1,9,2)
		
	}
	s ret = 1
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			实时检测内涵缺陷情况存入global
/// Input:			ARuleID		内涵质控标准ID
/// 				AEpisodeID	就诊号
/// 				AUniqueKey	进程号
/// Output          违反条目数量（一个entryid算一个）
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).CheckAiEntry()
ClassMethod CheckAiEntry(ARuleID As %String, AEpisodeID As %String, AUniqueKey As %String)
{
	s count=0
	s EntryID=""
	for
	{
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:(EntryID = "")
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  
		continue:(objEntry = "")
		s isEntryActive = objEntry.IsActive   
		continue:(isEntryActive '= "Y")
		s poolId = objEntry.PoolDR    
		continue:(poolId = "")
		s objPool = ##Class(EPRmeta.Quality.QualityPool).%OpenId(poolId)
		continue:(objPool = "")
		continue:(objPool.IsActive '= "Y")
		s EntryTitle = objPool.Title
		s EntryConditionDR = objEntry.EntryConditionDR 
	    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
	    {
	       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,EntryConditionDR)
	       continue:(flag '= "1")
	    }
	    
	    //检查表达式
		s ExpressionResult = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,"",AUniqueKey)
		continue:(ExpressionResult >= 0)
		s count = count + 1
		
		if (ExpressionResult'["#")
		{
			s ^CacheTemp("EPRQuality","AiLog",AUniqueKey,AEpisodeID,ARuleID,EntryID,1)=EntryTitle	
		}else {
			for i=2:1:$l(ExpressionResult,"#")
			{
				s Expression=$p(ExpressionResult,"#",i)
				s resume=$p(Expression,"@",1)
				s instanceid=$p(Expression,"@",2)
				s ^CacheTemp("EPRQuality","AiLog",AUniqueKey,AEpisodeID,ARuleID,EntryID,i-1)=EntryTitle_Expression
			}
		}
	}
	q count
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			在院患者数量统计重建（用于主表数据统计和子表明细不一样时重建统计数据）
/// Input:			ARuleID		内涵质控标准ID
/// Output          1 成功
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).AiLogNumRebuild(9)
ClassMethod AiLogNumRebuild(ARuleID As %String) As %String
{
	s ret = 0
	q:(ARuleID = "") ret
	s UniqueKey = $i(^CacheTemp)
	

	s EpisodeID = ""
	for {
		s EpisodeID =$o(^PAADMi("AdmTypeCurr","I",EpisodeID))
		q:(EpisodeID = "")
		
		//检查就诊是否有效
		s Flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
		continue:(Flag < 1)
		
		s objPaAdm = $g(^PAADM(+EpisodeID))
		continue:(objPaAdm = "")
		
		s AdmLocID = $p(objPaAdm,"^",4)
		continue:(AdmLocID = "")
		
		s AdmDocID = $p(objPaAdm,"^",9)
		s:(AdmDocID="") AdmDocID="-1"
		
		s flag=..AiLogNumRebuildEpisode(EpisodeID)
	}
	s ret = 1
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			一个患者数量统计重建（用于一个患者主表数据统计和子表明细不一样时重建统计数据）
/// Input:			EpisodeId		就诊号
/// Output          1 成功   <=0失败
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).AiLogNumRebuildEpisode(9)
ClassMethod AiLogNumRebuildEpisode(EpisodeId As %String) As %String
{
	s ret=0
	q:(EpisodeId="")
	
	s RepairNum=0,ErrNum=0

	s TheAiLog= $o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeId," A",""))
	q:(TheAiLog="") ret
	s detailid=""
	for {
		s detailid=$o(^DHCEPRQ.QualityAiLogDetailI("IdxAiLog",TheAiLog,detailid))
		q:(detailid="")
		s status=$lg($g(^DHCEPRQ.QualityAiLogD(TheAiLog,"Details",detailid)),6)
		s:(status="R") RepairNum=RepairNum+1
		s:(status="E") ErrNum=ErrNum+1
	}
	s obj=##class(EPRinstance.Quality.QualityAiLog).%OpenId(TheAiLog)
	s obj.ErrorNum=ErrNum
	s obj.RepairNum=RepairNum
	s obj.Num=ErrNum+RepairNum
	s sc = obj.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		s ret = -1
	}else{
		s ret=1	
	}
	d obj.%Close()
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			清除数据（AiLog、AiLogDetail）
/// Input:			
/// Output          1 成功 
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityAiLog).clear()
ClassMethod clear()
{
	k ^DHCEPRQ.QualityAiLogD
	k ^DHCEPRQ.QualityAiLogI
	k ^DHCEPRQ.QualityAiLogS
	k ^DHCEPRQ.QualityAiLogDetailI
	k ^DHCEPRQ.QualityAiLogDetailS
	q 1
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			在院患者内涵质控触犯明细（自动任务）
/// Input:			AStartDate	入院开始时间
/// 				AEndDate	入院结束时间
/// 				ALocID		科室id
/// 				AType		E 未修复 R 修复
/// Output          
/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiLog","GetAiLogList","2018-01-01","2021-08-01","","")
Query GetAiLogList(Action As %String, AStartDate As %String, AEndDate As %String, ALocID As %String = "", AType As %String = "", AMedicareNo As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "PAADMRowID,Name,MRNo,LocDesc,DoctorDesc,EntryDR,Title,ResumeText,Status,Trigger,Repair") [ SqlProc ]
{
}

ClassMethod GetAiLogListExecute(ByRef qHandle As %Binary, Action As %String, AStartDate As %String, AEndDate As %String, ALocID As %String = "", AType As %String = "", AMedicareNo As %String = "", AHospitalID As %String = "") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((AStartDate="")||(AEndDate=""))&&(ALocID="")&&(AMedicareNo="") $$$OK
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s:(StartDate '= "") StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s:(EndDate '= "") EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)

	if (AMedicareNo '="")
	{
		//病案号查询
		s PAPMIDR=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMedicareNo,"I","",.ErrMsg)
		s PAADMRowID=""
		for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM","I",PAADMRowID))
		q:(PAADMRowID = "")
		s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
    	continue:(AHospitalID'="")&&(flag=0)
		s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
		continue:AdmType'="I"
		s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
		continue:(xse'="")
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		continue:(AdmStatus '= Action)
		s AdmComparedate = $P($g(^PAADM(PAADMRowID)),"^",6)
		s DisCompareDate= $P($g(^PAADM(PAADMRowID)),"^",17)
		s:(Action="A") CompareDate = AdmComparedate
		s:(Action="D") CompareDate = DisCompareDate
		if (StartDate '= "")
		{			
			continue:(CompareDate < StartDate)
		}
		if (EndDate '= "")
		{	
			continue:(CompareDate > EndDate)
		}
			s flag=..GetAiRepair(PAADMRowID,ALocID,Action,AType,repid)
		}
	}elseif ((StartDate'="")&&(EndDate'=""))
	{
	for i = StartDate:1:EndDate {
		s PAADMRowID = ""
		for {	
			s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",i,PAADMRowID))
			q:(PAADMRowID = "")
			s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
			continue:(AHospitalID'="")&&(flag=0)
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= Action)
			s flag=..GetAiRepair(PAADMRowID,ALocID,Action,AType,repid)
		}
	}
	}elseif(Action="A"){
	s PAADMRowID = ""
		for {
			
			s PAADMRowID = $o(^PAADMi("AdmTypeCurr","I",PAADMRowID))
			q:(PAADMRowID = "")
			s flag = ##Class(EPRservice.Quality.CommonHelper).IsCurrentHosPat(PAADMRowID,AHospitalID)
			continue:(AHospitalID'="")&&(flag=0)
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= Action)
			s flag=..GetAiRepair(PAADMRowID,ALocID,Action,AType,repid)
		}
	}
	
	s PAADMRowID = ""
	for {
		s PAADMRowID = $o(^CacheTemp("EMRQuality","AiRepair",repid,PAADMRowID))
		q:(PAADMRowID = "")
		
		s num = ""
		for {
			s num = $o(^CacheTemp("EMRQuality","AiRepair",repid,PAADMRowID,num))
			q:(num = "")
			
				s Data = $g(^CacheTemp("EMRQuality","AiRepair",repid,PAADMRowID,num))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}
	}
    k ^CacheTemp("EMRQuality","AiRepair",repid)

			
	Quit $$$OK
}

ClassMethod GetAiLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAiLogListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAiLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAiLogListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAiRepair(PAADMRowID As %String, ALocID As %String, Action As %String, AType As %String, AUniqueKey As %String)
{
	s ret="",num=0
	s objPaAdm = $g(^PAADM(PAADMRowID))
	s AdmLocID=$p($g(objPaAdm),"^",4)
	q:(ALocID'="")&&(ALocID'=AdmLocID) ret
	s Papmi = $p(objPaAdm,"^",1)
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	s MRNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s AdmDocID = $p(objPaAdm,"^",9)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	s num=0		
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiLog:GetAiResultDetail")
	s sc = result.Execute(PAADMRowID,Action,AType)
	While (result.Next())
	{
    s EntryDR=result.Data("EntryDR")
    s Title=result.Data("Title")
    s ResumeText=result.Data("ResumeText")
    s Status=result.Data("Status")
    s Trigger=result.Data("Trigger")
	s Trigger=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",Trigger)
    s Repair=result.Data("Repair")
	s Repair=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",Repair)
    s num=num+1
    s ^CacheTemp("EMRQuality","AiRepair",AUniqueKey,PAADMRowID,num)=$lb(PAADMRowID,Name,MRNo,LocDesc,DoctorDesc,EntryDR,Title,ResumeText,Status,Trigger,Repair)
	}
	q 1
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			患者内涵质控触犯明细（自动任务）
/// Input:			AEpisodeID	就诊号
/// 				AType		E 未修复 R 修复
/// Output          
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiLog","GetAiResultDetail","")
Query GetAiResultDetail(AEpisodeID As %String, Action As %String, AType As %String) As %Query(ROWSPEC = "EpisodeID,EntryDR,Title,ResumeText,Status,Trigger,Repair") [ SqlProc ]
{
}

ClassMethod GetAiResultDetailExecute(ByRef qHandle As %Binary, AEpisodeID As %String, Action As %String, AType As %String) As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	s ListType=""
	s:(AType'="") ListType = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AType,",")
	
	s TheAiLog=""
	for{
		s TheAiLog=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_AEpisodeID," "_Action,TheAiLog))
		q:(TheAiLog="")
		s TheAiLogDetailid=""
		for {
			s TheAiLogDetailid=$o(^DHCEPRQ.QualityAiLogDetailI("IdxAiLog",TheAiLog,TheAiLogDetailid))
			q:(TheAiLogDetailid="")
			s obj=##class(EPRinstance.Quality.QualityAiLogDetail).%OpenId(TheAiLog_"||"_TheAiLogDetailid)
			s EntryDR=obj.EntryDR
			s Title=obj.Title
			s ResumeText=obj.ResumeText
			s Status=obj.Status
			continue:($listlength(ListType) > 0)&&($listfind(ListType,Status) = 0)
			s TriggerDate=obj.TriggerDate
			s TriggerTime=obj.TriggerTime
			s Trigger=TriggerDate_" "_TriggerTime
			s RepairDate=obj.RepairDate
			s RepairTime=obj.RepairTime
			s Repair=RepairDate_" "_RepairTime
			
			s ^CacheTemp(repid,ind) = $lb(AEpisodeID,EntryDR,Title,ResumeText,Status,Trigger,Repair)
			s ind = ind + 1
		}
	}

	Quit $$$OK
}

ClassMethod GetAiResultDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAiResultDetailExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAiResultDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAiResultDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			在院患者科室触犯排名（自动任务）
/// Input:			ARankNum	取前几排名（10）
/// Output          
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiLog","GetAiResultRank","10")
Query GetAiResultRank(ARankNum As %String) As %Query(ROWSPEC = "LocID,LocDesc,Err,Rep") [ SqlProc ]
{
}

ClassMethod GetAiResultRankExecute(ByRef qHandle As %Binary, ARankNum As %String) As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	s PAADMRowID = ""
		for {
			
			s PAADMRowID = $o(^PAADMi("AdmTypeCurr","I",PAADMRowID))
			q:(PAADMRowID = "")
			s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
			continue:AdmType'="I"
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= "A")
			
			s objPaAdm = $g(^PAADM(PAADMRowID))
			s AdmLocID=$p($g(objPaAdm),"^",4)
			
			s numInfo=..GetNumByEpisodeid(PAADMRowID)
			s ErrorNum=$p(numInfo,"^",3)
			s RepairNum=$p(numInfo,"^",2)
			s Num=$p(numInfo,"^",1)
			s ^CacheTemp("EMRQuality","AiResultRank",repid,AdmLocID,"Err")=(+$g(^CacheTemp("EMRQuality","AiResultRank",repid,AdmLocID,"Err")))+Num
			s ^CacheTemp("EMRQuality","AiResultRank",repid,AdmLocID,"Rep")=(+$g(^CacheTemp("EMRQuality","AiResultRank",repid,AdmLocID,"Rep")))+RepairNum
		}
		
	s LocID = ""
	for {
		s LocID = $o(^CacheTemp("EMRQuality","AiResultRank",repid,LocID))
		q:(LocID = "")
		s Err=$g(^CacheTemp("EMRQuality","AiResultRank",repid,LocID,"Err"))
		s Rep=$g(^CacheTemp("EMRQuality","AiResultRank",repid,LocID,"Rep"))
		s LocDesc = $p($g(^CTLOC(+LocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		s ^CacheTemp("EMRQuality","AiResultRanking",repid,Err,Rep,LocID)=$lb(LocID,LocDesc,Err,Rep)			
			
	}
	
	s ErrNum = ""
	for {
		s ErrNum = $o(^CacheTemp("EMRQuality","AiResultRanking",repid,ErrNum),-1)
		q:(ErrNum = "")
		s RepNum=""
		for{
			s RepNum = $o(^CacheTemp("EMRQuality","AiResultRanking",repid,ErrNum,RepNum))
			q:(RepNum = "")
			s locid=""
			for{
				s locid = $o(^CacheTemp("EMRQuality","AiResultRanking",repid,ErrNum,RepNum,locid))
				q:(locid = "")
				q:(ind>ARankNum)
				s Data = $g(^CacheTemp("EMRQuality","AiResultRanking",repid,ErrNum,RepNum,locid))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			}
		}
	}
	
    k ^CacheTemp("EMRQuality","AiResultRank",repid)
    k ^CacheTemp("EMRQuality","AiResultRanking",repid)

	Quit $$$OK
}

ClassMethod GetAiResultRankClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAiResultRankExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAiResultRankFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAiResultRankExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			获取患者内涵质控数量
/// Input:			EpisodeID	就诊号
/// Output          Num_"^"_RepairNum_"^"_ErrorNum 触犯总数量 已修复数量 未修复数量
/// Debug:		w ##class(EPRservice.Quality.DataAccess.BOQualityAiLog).GetNumByEpisodeid()
ClassMethod GetNumByEpisodeid(EpisodeID As %String)
{
	s ret=""
	q:(EpisodeID="") ret
	s rowid=""
	for{
		s rowid=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_EpisodeID," A",rowid))
		q:(rowid="")
		s obj=##class(EPRinstance.Quality.QualityAiLog).%OpenId(rowid)
		s Num=obj.Num
		s RepairNum=obj.RepairNum
		s ErrorNum=obj.ErrorNum
		s ret=Num_"^"_RepairNum_"^"_ErrorNum
	}
	q ret
}

/// Creator:	    qy
/// Create Date:	2023
/// Desc:			获取患者内涵质控触犯标志
/// Input:			EpisodeID	就诊号
/// 				AAction		A\D
/// 				AEntryID	EntryID
/// Output          1 目前触犯 0 目前不触犯
/// Debug:		w ##class(EPRservice.Quality.DataAccess.BOQualityAiLog).GetAiFlagByEpisodeActionEntry(6387,"A",1041)
ClassMethod GetAiFlagByEpisodeActionEntry(AEpisodeID As %String, AAction As %String, AEntryID As %String)
{
	s ret="0"
	q:(AEpisodeID="")||(AAction="")||(AEntryID="") ret
	s TheAiLog=$o(^DHCEPRQ.QualityAiLogI("IdxEpisodeAction"," "_AEpisodeID," "_AAction,""))
	q:(TheAiLog="") ret
	s:($d(^DHCEPRQ.QualityAiLogDetailI("IdxEntryDRStatus",TheAiLog," "_AEntryID," E"))=10) ret=1
	q ret
}

}
