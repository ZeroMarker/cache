/// 名称: DHCHAI.IO.ToDtPortalSrv
/// 描述: 与Portal相关接口
/// 编写者：zhufei
/// 编写日期: 2018-03-03
Class DHCHAI.IO.ToDtPortalSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-03-03
/// Description:  查询科室感染暴发预警患者信息
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       aLocID     : 科室ID
///               aWarnDate  : 预警日期
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetWarningPatInfo("2018-04-03",114)
/// Do $system.OBJ.Dump(arr)
ClassMethod GetWarningPatInfo(aWarnDate As %String, aLocID As %String) As %ListOfDataTypes
{
	New (aWarnDate,aLocID)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:(aWarnDate="") return
	
	Set LocDr=##class(DHCHAI.CUS.ToClinReport).GetLocDr(aLocID)
	Set:aWarnDate["-" aWarnDate=$zdh(aWarnDate,3)
	
	//实时现患||3^发热|7|3^检出同种同源菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3^入院24H内计入|1
	Set WarnItems=""
 	Set WarnIndex=0
 	Set xIndNo=""
 	For {
	 	Set xIndNo=$o(^DHCHAI.IR.CCItmWarnI("IdxofIndNo",xIndNo))
	 	Quit:xIndNo=""
	 	
	 	Set xItemID=0
	 	For {
		 	Set xItemID=$o(^DHCHAI.IR.CCItmWarnI("IdxofIndNo",xIndNo,xItemID))
		 	Quit:xItemID=""
		 	
		 	Set obj=##class(DHCHAI.IR.CCItmWarn).GetObjById(xItemID)
		 	Continue:'$IsObject(obj)
		 	Continue:obj.CCIsActive'=1
		 	Set Desc=obj.CCDesc
		 	Continue:Desc=""
		 	Set Arg1=obj.CCArg1
		 	Set Arg2=obj.CCArg2
		 	Set Arg3=obj.CCArg3
		 	Set Arg4=obj.CCArg4
		 	Set Arg5=obj.CCArg5
		 	If WarnItems'="" {
				Set WarnItems=WarnItems_"^"_Desc_"|"_Arg1_"|"_Arg2
			} Else {
				Set WarnItems=Desc_"|"_Arg1_"|"_Arg2
			}
	 	}
	}
	Quit:WarnItems="" return
	If (WarnItems'="")&&(WarnItems'["入院24H内计入") {  //默认入院24h不计入，导致数据与院感暴发预警数据不一致问题
		 Set WarnItems=WarnItems_"^入院24H内计入|1"  
	}   
	       
 	Set ZIndex=$zn,JIndex=$j,NIndex="GetWarningPatInfo"
 	
 	//判断是否存在新的暴发预警版本代码 
 	Set IsExist=##class(websys.Conversions).IsValidMethodName("DHCHAI.IRS.CCWarningNewSrv","QueryProcess")
 	If (IsExist=1) {
	 	Set flg=##class(DHCHAI.IRS.CCWarningNewSrv).QueryProcess(aWarnDate,WarnItems,"",LocDr,"W")
	 	Quit:(+flg)<1 return
	 
	 	Set xWarnLoc=""
		For {
			Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
			Quit:xWarnLoc=""
			Continue:(aLocID'="")&&(aLocID'=xWarnLoc)  //过滤科室、病区
			
			Set xEpisodeDr=""
			For {
				Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr))
				Quit:xEpisodeDr=""
				
				Set WarnBedDesc=""
				Set WarnBedDr=$g(^TMP(ZIndex,JIndex,NIndex,"WarnEpisBed",xWarnLoc,xEpisodeDr))
				Set WarnBedData=$g(^DHCHAI.BT.PACBedD(WarnBedDr))
				If WarnBedData'=""{
					Set WarnBedDesc=$li(WarnBedData,3)
				}
				Set:(WarnBedDesc'="")&&(WarnBedDesc'["床") WarnBedDesc=WarnBedDesc_"床"
				
				Set SummaryStr=""
				Set xItemDesc=""
				For {
					Set xItemDesc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc))
					Quit:xItemDesc=""
					If (xItemDesc="实时现患") {
						Set xDiagID=""
						For {
							Set xDiagID=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc,xDiagID))
							Quit:xDiagID=""				
							
							Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
							Continue:'$IsObject(objDiag)
							Set InfPos = objDiag.IRInfPosDr.BTDesc
							Set SummaryStr=SummaryStr_","_xItemDesc_":"_InfPos					
						}			
					}ElseIf (xItemDesc="检出同种同源菌") {
						Set xBacteria=""
						For {
							Set xBacteria=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc,xBacteria))
							Quit:xBacteria=""
							Set SummaryStr=SummaryStr_","_xItemDesc_":"_xBacteria	
						}				
					}ElseIf (xItemDesc="发热人数") {
						If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc)) {
							Set SummaryStr=SummaryStr_","_xItemDesc
						}
					}ElseIf (xItemDesc="发热标准差") {
						If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",xWarnLoc,xEpisodeDr,xItemDesc)) {
							Set SummaryStr=SummaryStr_","_xItemDesc
						}
					}Else{}
				
				}
				Continue:SummaryStr=""
				Set SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
				Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
				Continue:'$IsObject(objEpisode)
				Set EpisodeID=objEpisode.PAEpisodeIDx
				Set EpisodeID=$p(EpisodeID,"||",2)
				
				Set WarnLocID=""
				Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xWarnLoc)
				If $IsObject(objLoc) {
					Set LocXCode=objLoc.BTXCode
					Set WarnLocID=$p(LocXCode,"||",2)
				}
				
				Set WarningInfo=xEpisodeDr_"^"_EpisodeID_"^"_aWarnDate_"^"_SummaryStr_"^"_WarnLocID
				Do return.Insert(WarningInfo)
			}
		}
 	}Else {
	 	Set flg=##class(DHCHAI.IRS.CCWarningSrv).QueryProcess(aWarnDate,WarnItems,"",LocDr,"","W")
	 	Quit:(+flg)<1 return
	 	
		//输出科室暴发预警结果
		Set xWarnLoc=""
		For {
			Set xWarnLoc=$o(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
			Quit:xWarnLoc=""
			
			Set WarnLocData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnLoc",xWarnLoc))
			Continue:WarnLocData=""
			
			Set WarnLocDr=$listget(WarnLocData,1)
			Set WarnLocDesc=$listget(WarnLocData,2)
			
			Set xEpisodeDr=0
			For {
				Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
				Quit:xEpisodeDr=""
				
				Set WarnBedData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr))
				Continue:WarnBedData=""
				Set WarnBedDr=$listget(WarnBedData,3)
				Set WarnBedDesc=$listget(WarnBedData,4)
				Continue:WarnBedDesc=""
				Set:WarnBedDesc'["床" WarnBedDesc=WarnBedDesc_"床"
				
				Set DataStr="",SummaryStr=""
				Set xInd=0
				For {
					Set xInd=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd))
					Quit:xInd=""
					
					Set xSub=0
					For {
						Set xSub=$o(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
						Quit:xSub=""
						
						Set HeaderData=$g(^TMP(ZIndex,JIndex,NIndex,"WarnHeader",xInd,xSub))
						Continue:HeaderData=""
						Set HeaderDesc=$listget(HeaderData,1)
						Set ItemDesc=$listget(HeaderData,2)
						Continue:ItemDesc=""
						
						If ItemDesc="检出同种同源菌" {
							Set Bacteria=HeaderDesc
							Continue:Bacteria=""
							If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,Bacteria)) {
								Set DataStr=1
								Set SummaryStr=SummaryStr_","_ItemDesc_":"_Bacteria
							}
						} ElseIf ItemDesc="手术切口感染" {
							Set OperDesc=HeaderDesc
							Continue:OperDesc=""
							If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc,OperDesc)) {
								Set DataStr=1
								Set SummaryStr=SummaryStr_","_ItemDesc_":"_OperDesc
							}
						} Else {
							If $d(^TMP(ZIndex,JIndex,NIndex,"WarnEpis",WarnLocDr,xEpisodeDr,ItemDesc)) {
								Set DataStr=1
								Set SummaryStr=SummaryStr_","_ItemDesc
							}
						}
					}
				}
				Continue:DataStr=""
				Continue:SummaryStr=""
				Set SummaryStr=$e(SummaryStr,2,$l(SummaryStr))
				
				Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
				Continue:'$IsObject(objEpisode)
				Set EpisodeID=objEpisode.PAEpisodeIDx
				Set EpisodeID=$p(EpisodeID,"||",2)
				
				Set WarnLocID=""
				Set objLoc=##class(DHCHAI.BT.Location).GetObjById(WarnLocDr)
				If $IsObject(objLoc) {
					Set LocXCode=objLoc.BTXCode
					Set WarnLocID=$p(LocXCode,"||",2)
				}
				
				Set WarningInfo=xEpisodeDr_"^"_EpisodeID_"^"_aWarnDate_"^"_SummaryStr_"^"_WarnLocID
				Do return.Insert(WarningInfo)
			}
		}
 	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-03
/// Description:  查询当前病区病人信息（接口MD12.01.01、MD12.01.02相关）
/// Table：       DHCHAI.IR.CCScreenAct
/// Input：       aFromDate  : 开始日期
///               aToDate    : 结束日期
///               aDateType  : 日期类型（update 2020-03-13 修改与疑似病例筛查一致查询方式）
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningPatInfo("2018-04-03","2018-04-03","A")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetScreeningPatInfo(aFromDate As %String, aToDate As %String, aDateType As %String = "A") As %ListOfDataTypes
{
	New (aFromDate,aToDate,aDateType)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:(aDateType'="A")&&((aFromDate="")||(aToDate="")) return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
		
	If (aDateType="A") {		
		Set xDays=-1
		Set xAdmType="",Count=0
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
					Continue:'$IsObject(objEpisode)
					Set EpisodeDr=objEpisode.%Id()
					Set EpisodeIDx=objEpisode.PAEpisodeIDx
					Set EpisodeID=$p(EpisodeIDx,"||",2)
					
					Set SCode = $p(EpisodeIDx,"||",1)
					Set VisitStatus=objEpisode.PAVisitStatus
					Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
					If VisitStatusInfo'="" {
						Set VisitStatus=$p(VisitStatusInfo,"^",2)
					}
					Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
					
					Set ScreeningInfo=EpisodeDr_"^"_EpisodeID
					Do return.Insert(ScreeningInfo)
					//Set ScreeningInfo=..GetScreenStatusByAdm(EpisodeDr)
					//Continue:ScreeningInfo=""
					//Do return.Insert(ScreeningInfo)
				}
			}
		}
	} ElseIf (aDateType="D") {				
		Set xAdmType="",Count=0
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=aFromDate-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aToDate
				
				Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""	
						
						Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
						Continue:'$IsObject(objEpisode)
						Set EpisodeDr=objEpisode.%Id()
						Set EpisodeIDx=objEpisode.PAEpisodeIDx
						Set EpisodeID=$p(EpisodeIDx,"||",2)
						
						Set SCode = $p(EpisodeIDx,"||",1)
						Set VisitStatus=objEpisode.PAVisitStatus
						Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
						If VisitStatusInfo'="" {
							Set VisitStatus=$p(VisitStatusInfo,"^",2)
						}
						Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
						
				        Set ScreeningInfo=EpisodeDr_"^"_EpisodeID
						Do return.Insert(ScreeningInfo)
						//Set ScreeningInfo=..GetScreenStatusByAdm(EpisodeDr)
						//Continue:ScreeningInfo=""
						//Do return.Insert(ScreeningInfo)
					}
				}
			}
		}
	}
		
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询就诊疑似未处置和确诊未报及报告感染病人信息
/// Table：       DHCHAI.IR.CCScreenAct
/// Input：       aEpisodeDr : 就诊ID
/// w ##class(DHCHAI.IO.ToDtPortalSrv).GetScreenStatusByAdm(4795)
ClassMethod GetScreenStatusByAdm(aEpisodeDr As %String)
{
	New (aEpisodeDr)
	Set return=""
	Quit:aEpisodeDr="" return
	
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeDr)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)
	Quit:IsSusInf'=1 return //疑似标志
			
	If ('$d(^DHCHAI.IR.CCScreeningI("Dtl")))  {   //以此作为新版疑似病例筛查判断的标准（对于从不做确诊排除工作的不适用）
		Quit:(IsSuspend'=0)&&(IsSuspend'=1) return //0疑似未确诊、1确诊未上报	
		Set IsConfirmed=0
		Set:IsSuspend=1 IsConfirmed=1
	} Else {  //2019年10月新版疑似病例筛查
		Set IsConfirmed =0
		Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(aEpisodeDr)
		Set ConfCnt = $p(ConfRepCnt,"^",1)	//患者确诊数量
		Set RepCnt = $p(ConfRepCnt,"^",2)	//确诊已报数量
		Set:(ConfCnt-RepCnt)>0 IsConfirmed=1   //确诊未报	
	}
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set EpisodeID=objEpisode.PAEpisodeIDx
	Set EpisodeID=$p(EpisodeID,"||",2)
	Set AdmLocDr=$p(objEpisode.PAAdmLocDr.BTXCode,"||",2)
	Set return=aEpisodeDr_"^"_EpisodeID_"^"_IsSuspend_"^"_IsConfirmed_"^"_AdmLocDr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-03
/// Description:  查询当前患者处置（确诊）信息
/// Table：       DHCHAI.IR.CCScreening
/// Input：       aEpisodeDr : 就诊ID
///               aStatus    : 状态代码
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningInfo(94,1)
/// Do $system.OBJ.Dump(arr)
ClassMethod GetScreeningInfo(aEpisodeDr As %String, aStatus As %String = "") As %ListOfDataTypes
{
	New (aEpisodeDr,aStatus)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:aEpisodeDr="" return
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeDr,xID))
		Quit:xID=""
		Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
		Continue:'$IsObject(objScreening)
		Continue:(aStatus'="")&(aStatus'=objScreening.CSStatus)  //1确诊、2排除
		Set ActDate=objScreening.CSActDate
		Set ActTime=objScreening.CSActTime
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserID=""
		If $IsObject(objScreening.CSActUserDr){
			Set ActUserXCode=objScreening.CSActUserDr.BTXCode
			Set ActUserID=$p(ActUserXCode,"||",2)
		}
		Set Opinion=objScreening.CSOpinion
		
		Set ScreeningInfo=xID_"^"_ActDate_"^"_ActTime_"^"_ActUserID_"^"_Opinion
		Do return.Insert(ScreeningInfo)
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-03-13
/// Description:  查询患者感染信息（确诊已报、确诊未报、主动报告都记为感染人数，接口MD12.0.01,MD12.01.02 相关）
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos
/// w ##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnosByAdm(4795)
ClassMethod GetInfDiagnosByAdm(aEpisodeDr As %String)
{
	New (aEpisodeDr)
	Set return=""
	Quit:aEpisodeDr="" return
	Set (IsInf,InfCnt,InfRepCnt)=0
	If ('$d(^DHCHAI.IR.CCScreeningI("Dtl")))  {   //以此作为新版疑似病例筛查判断的标准（对于从不做确诊排除工作的不适用）
		//老版本疑似病例筛查，确诊与感染诊断没有关联，主动报告、确诊未报记为感染人数
		Set xRepType = ""
		For {
			Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'=1)
		
		    Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
				Quit:xRepID=""			

				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4	
				
				Set LinkDiagID = objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			    Continue:LinkDiagID=""
			   
			    // 感染诊断信息
				Set (InfPos,InfPosCode,InfPosDesc)=""
				For indx = 1:1:$l(LinkDiagID,","){
					Set xDiagID = $p(LinkDiagID,",",indx)
					Continue:xDiagID=""
					
					Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
					Continue:'$IsObject(objDiags)
					// 感染部位/感染诊断
					Set objInfPos = objDiags.IRInfPosDr
					If $IsObject(objInfPos){
						Set InfPosCode= objInfPos.BTCode
						Set InfPosDesc= objInfPos.BTDesc
					}
					Continue:InfPosDesc=""
					Set InfRepCnt = InfRepCnt+1	
				}				
			}
		}
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeDr)
		Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
		Set IsSusInf=+$p(ScreenAttInfo,"^",2) //疑似标志
		Set IsSuspend=+$p(ScreenAttInfo,"^",3) //0疑似未确诊、1确诊未上报	
		Set:IsSuspend=1 InfCnt = InfRepCnt+1
		Set:InfCnt>0 IsInf =1
	
	}Else {  //新版疑似病例筛查
		//主动报告数
		Set xRepType = ""
		For {
			Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'=1)
		
		    Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
				Quit:xRepID=""			

				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4	
				
				Set LinkDiagID = objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			    Continue:LinkDiagID=""
			    
			    Continue:$d(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",LinkDiagID))   //确诊的感染诊断不计入
			    Set InfRepCnt = InfRepCnt+1	
			} 	
		}			
		
		Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(aEpisodeDr)
		Set ConfCnt = $p(ConfRepCnt,"^",1)	//患者确诊数量
		Set InfCnt = ConfCnt+InfRepCnt
		Set:InfCnt>0 IsInf =1
	}
	Set return=IsInf_"^"_InfCnt    // 是否感染、感染例次
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询感染诊断信息
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos
/// Input：       aFromDate  : 开始日期
///               aToDate    : 结束日期
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnosEpis("2018-03-28","2018-03-28")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetInfDiagnosEpis(aFromDate As %String, aToDate As %String) As %ListOfDataTypes
{
	New (aFromDate,aToDate)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)

	Set xInfDate=aFromDate-1
	For {
		Set xInfDate=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xInfDate))
		Quit:xInfDate=""
		Quit:xInfDate>aToDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xInfDate,xID))
			Quit:xID=""
			
			Set objInfDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(objInfDiagnos)
	 		Continue:'$IsObject(objInfDiagnos.IREpisodeDr)
	 		
	 		Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
			Continue:arrInfRep.Count()<1
			Do return.Insert(objInfDiagnos)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询医院感染报告列表
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos
/// Input：       aEpisodeDr : 就诊ID
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetInfReports(76)
/// Do $system.OBJ.Dump(arr)
ClassMethod GetInfReports(aEpisodeDr As %String) As %ListOfDataTypes
{
	New (aEpisodeDr)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:aEpisodeDr="" return
	
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1) //1医院感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode="4"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			Do return.Insert(objInfRep)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询医院感染报告日志列表
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFRepLog
/// Input：       aEpisodeDr : 就诊ID
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetInfRepLogs(76,"")
/// Do $system.OBJ.Dump(arr)
ClassMethod GetInfRepLogs(aReportDr As %String, aStatusCode As %String = "") As %ListOfDataTypes
{
	New (aReportDr,aStatusCode)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:aReportDr="" return
	
	Set xLogDr=0
	For {
		Set xLogDr=$o(^DHCHAI.IR.INFReportD(aReportDr,"LOG",xLogDr))
		Quit:xLogDr=""
		
		Set objLog=##class(DHCHAI.IR.INFRepLog).GetObjById(aReportDr_"||"_xLogDr)
		Continue:'$IsObject(objLog)
		Continue:'$IsObject(objLog.IRStatusDr)
		Set StatusCode=objLog.IRStatusDr.BTCode
		Continue:(aStatusCode'="")&(aStatusCode'=StatusCode)
		Do return.Insert(objLog)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询医院感染报告诊断列表
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt,DHCHAI.IR.INFDiagnos
/// Input：       aEpisodeDr : 就诊ID
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetInfDiagnos(26)
/// Do $system.OBJ.Dump(arr)
ClassMethod GetInfDiagnos(aReportDr As %String) As %ListOfDataTypes
{
	New (aReportDr)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:aReportDr="" return
	
	Set DataType="DHCHAI.IR.INFDiagnos"
	Set xExtDr=0
	For {
		Set xExtDr=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(DataType,"U"),aReportDr,xExtDr))
		Quit:xExtDr=""
		Set objExt=##class(DHCHAI.IR.INFRepExt).GetObjById(aReportDr_"||"_xExtDr)
		Continue:'$IsObject(objExt)
		Set InfDiagnosDr=objExt.IRObjectID
		Continue:InfDiagnosDr=""
		Set objInfDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(InfDiagnosDr)
		Continue:'$IsObject(objInfDiagnos)
		Do return.Insert(objInfDiagnos)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-20
/// Description:  查询监控明细列表
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊ID
/// Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetCCResults(21)
/// Do $system.OBJ.Dump(arr)
ClassMethod GetCCResults(aEpisodeDr As %String, aFromDate As %String = "", aToDate As %String = "") As %ListOfDataTypes
{
	New (aEpisodeDr,aFromDate,aToDate)
	Set return=##class(%ListOfDataTypes).%New()
	Quit:aEpisodeDr="" return
	
	Set xItemDr=0
	For {
		Set xItemDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemDr))
		Quit:xItemDr=""
		
		Set xActDate=$s(aFromDate'="":aFromDate-1,1:0)
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemDr,xActDate))
			Quit:xActDate=""
			Quit:(aToDate'="")&&(xActDate>aToDate)
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemDr,xActDate,xID))
				Quit:xID=""
				
				Set objResult=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(objResult)
				Continue:objResult.CCIsActive'=1
				Do return.Insert(objResult)
			}
		}
	}
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-03-20
/// Description:  查询患者感染诊断、感染筛查指标、感染因素
/// Table：       DHCHAI.IR.CCScreenAct
/// Input：       aEpisodeDr : 就诊ID
/// w ##class(DHCHAI.IO.ToDtPortalSrv).GetScreenItemByAdm(6)
ClassMethod GetScreenItemByAdm(aEpisodeDr As %String)
{
	New (aEpisodeDr)
	Set return=""
	Quit:aEpisodeDr="" return
	
	Kill ^TMP($zn,$j,"SuRuleResult")
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h 
	
	Set (InfPosList,ItmScreenList,ResultDateList)=""
	Set arrAdmFeverDates=##class(DHCHAI.IRS.CCScreeningSrv).GetAdmFeverDates(aEpisodeDr)       //取发热日期列表
  	Set arrAdmTSAbDates=##class(DHCHAI.IRS.CCScreeningSrv).GetAdmTSAbDates(aEpisodeDr)         //取血常规异常日期列表
 	Set arrAdmOEIntuDates=##class(DHCHAI.IRS.CCScreeningSrv).GetAdmOEIntuDates(aEpisodeDr)     //取器械相关治疗日期列表
    
    If ('$d(^DHCHAI.IR.CCScreeningI("Dtl")))  {   //以此作为新版疑似病例筛查判断的标准（对于从不做确诊排除工作的不适用）    
    	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(aEpisodeDr)
	 	Quit:arrResult.Count()<1 return
	 	Set Count=arrResult.Count()
	 	For indArr=1:1:Count {
			Set obj=arrResult.GetAt(indArr)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CSItmScreenDr)
			Continue:obj.CSIsActive'=1 //增加是否有效标志
			Set ItmScreenID   = obj.CSItmScreenDr.%Id()
			Set ItmScreenTxt  = obj.CSItmScreenTxt
			Set ResultNote    = obj.CSResultNote
			Set ResultDate    = obj.CSResultDate
			If ($listfind(ResultDateList,ResultDate)<1) {
	 	   		Set ResultDateList=ResultDateList_$lb(ResultDate)
	 	   	}
	 	   	If ($listfind(ItmScreenList,ResultNote)<1) {
	 	   		Set ItmScreenList=ItmScreenList_$lb(ResultNote)
	 	   	}
						
			Set RstStatus     = obj.CSRstStatus
			Set OprStatus     = obj.CSOprStatus
			Set InfDiagnosDr  = obj.CSInfDiagnosDr  //感染诊断记录指针
			Set InfPosDr      = obj.CSInfPosDr      //感染诊断ID
			Set InfPosDesc    = obj.CSInfPosDesc    //感染诊断名称
			If ($listfind(InfPosList,InfPosDesc)<1) {
 	   			Set InfPosList=InfPosList_$lb(InfPosDesc)
 	   		}
			
	 	}
	 	Set ItmScreenList=$LTS(ItmScreenList)
	 	Set InfPosList=$LTS(InfPosList)
    }Else {
	    //主动报告数
	    Set InfPosDesc=""
		Set xRepType = ""
		For {
			Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'=1)
		
		    Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xRepID))
				Quit:xRepID=""			

				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4	
				
				Set LinkDiagID = objReport.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			    Continue:LinkDiagID=""
			    
			    Continue:$d(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",LinkDiagID))   //确诊的感染诊断不计入
			
			    Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(LinkDiagID)
				Continue:'$IsObject(objINFDiagnos) 
		
				Set objInfPos = objINFDiagnos.IRInfPosDr
				Set (InfPosID,InfPos)=""
				If $IsObject(objInfPos){
					Set InfPosID = objInfPos.%Id()
					Set InfPos = objInfPos.BTDesc
				}
				Set InfPosDesc=InfPosDesc_"###"_InfPos
			}
		}
		Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,4,$l(InfPosDesc))
		
	    Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeDr,DateFrom,DateTo)
	 	//Quit:arrResult.Count()<1 return  直接填报报告poratl查不到诊断修改
	 	Set Count=arrResult.Count()
	 	For indArr=1:1:Count {
			Set obj=arrResult.GetAt(indArr)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CSItmScreenDr)
			Continue:obj.CSIsActive'=1 //增加是否有效标志
			
			Set ItmScreenID   = obj.CSItmScreenDr.%Id()
			Set ItmScreenTxt  = obj.CSItmScreenTxt
			Set ResultNote    = obj.CSResultNote
			Set ResultDate    = obj.CSResultDate	
			Set InfSuRuleDr   = obj.CSInfSuRuleDr   //(新增)规则ID（多值#分隔)
			Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(InfSuRuleDr)
			Continue:'$IsObject(objRule)

			Set ItmTxt=ItmScreenTxt
			Set:ItmTxt="" ItmTxt="*"
			Set ^TMP($zn,$j,"SuRuleResult",InfSuRuleDr,ItmScreenID,ItmTxt,indArr) = $lb(InfSuRuleDr,ResultDate,ResultNote,ItmScreenTxt)
	 	}	
	 	
	    Set xInfSuRuleID=""
	 	For{
		 	Set xInfSuRuleID=$o(^TMP($zn,$j,"SuRuleResult",xInfSuRuleID))
		 	Quit:xInfSuRuleID=""
		 	Set xItmScreenID=""
		 	For{
			 	Set xItmScreenID=$o(^TMP($zn,$j,"SuRuleResult",xInfSuRuleID,xItmScreenID))
			 	Quit:xItmScreenID=""
			 	
			 	Set ResultCount=0
			 	Set xItmScreenTxt=""	 	
			 	For{
			 		Set xItmScreenTxt=$o(^TMP($zn,$j,"SuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt))
			 		Quit:xItmScreenTxt=""	
	                
	                Set ResultNote=""
				 	Set xindArr=""
				 	For{
				 		Set xindArr=$o(^TMP($zn,$j,"SuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
				 		Quit:xindArr=""
				 		
				 		Set SuRuleInfo = $g(^TMP($zn,$j,"SuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
				 	    Continue:SuRuleInfo=""
				 	    Set InfSuRuleDr  = $lg(SuRuleInfo,1)
				 	    Set ResultDate   = $lg(SuRuleInfo,2)
				 	    Set ResultNote   = $lg(SuRuleInfo,3)
				 	    Set ItmScreenTxt  = $lg(SuRuleInfo,4)
				 	  
				 	   	If ($listfind(ResultDateList,ResultDate)<1) {
				 	   		Set ResultDateList=ResultDateList_$lb(ResultDate)
				 	   	}
				 	}
			 		If ($listfind(ItmScreenList,ResultNote)<1) {
			 	   		Set ItmScreenList=ItmScreenList_$lb(ResultNote)
			 	   	}
				 	   	
				 	Set InfRepPos=""	
				   	Set xScreenID=""
				   	For {
					   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,xItmScreenID," "_$zcvt(ItmScreenTxt,"U"),xScreenID))
					   	Quit:xScreenID=""
					   
					    Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
						Continue:'$IsObject(objScreen)
						Set Status=objScreen.CSStatus
					
						Set xSubID = ""
					   	For {
					   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
					   		Quit:xSubID=""
					   		
					   		Set xID =xScreenID_"||"_xSubID
					   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
							Continue:'$IsObject(objScreenDtl)
							Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
							Continue:objScreenDtl.CSStatus=2
							Set InfRepDiagID=objScreenDtl.CSInfRepPosDr.%Id()	              //项目确诊感染诊断信息ID
							Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
							Continue:IsActive'=1
			                Set (InfRepPosID,InfRepPos)=""
							If $IsObject(objScreenDtl.CSInfRepPosDr.IRInfPosDr) {
								Set InfRepPosID=objScreenDtl.CSInfRepPosDr.IRInfPosDr.%Id()
								Set InfRepPos=objScreenDtl.CSInfRepPosDr.IRInfPosDr.BTDesc   //项目确诊感染部位描述
							}
							If ($listfind(InfPosList,InfRepPos)<1) {
				 	   			Set InfPosList=InfPosList_$lb(InfRepPos)
				 	   		}
					   	}	  
				   	}
			 	}
		 	}
	 	}
	 	
	 	Set ItmScreenList=$LTS(ItmScreenList)
	 	Set InfPosList=$LTS(InfPosList,"###")
    }
   
    Set:InfPosDesc'="" InfPosList =InfPosList_"###"_InfPosDesc
    Set:$e(InfPosList,1)="#" InfPosList=$e(InfPosList,4,$l(InfPosList))
   
 	Set (IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC)=0
 	Set (IsFeverDesc,IsTSAbDesc,IsOEUCDesc,IsOEVAPDesc,IsOEPICCDesc)=""
	For indDate=1:1:$ll(ResultDateList) {
		Set RstDate = $lg(ResultDateList,indDate)
		Continue:RstDate=""
		For indDatex=(RstDate-3):1:(RstDate+3) {  //感染前后3天是否有发热、血常规异常
			Set Times=arrAdmFeverDates.GetAt(indDatex)
			If (+Times)>0 {
				Set IsFever=1
				Set IsFeverDesc="发热"
			}

			Set Times=arrAdmTSAbDates.GetAt(indDatex)
			If (+Times)>0 {
				Set IsTSAb=1
				Set IsTSAbDesc="血常规异常"
			}
		}
		
		For indDatey=(RstDate-7):1:RstDate {  //感染前7天是否使用器械相关医嘱	
			Set Times=arrAdmOEIntuDates.GetAt(indDatey_":导尿管")
			If (+Times)>0 {
				Set IsOEUC=1
				Set IsOEUCDesc="导尿管"
			}
			Set Times=arrAdmOEIntuDates.GetAt(indDatey_":呼吸机")
			If (+Times)>0 {
				Set IsOEVAP=1
				Set IsOEVAPDesc="呼吸机"
			}
			Set Times=arrAdmOEIntuDates.GetAt(indDatey_":中心静脉置管")
			If (+Times)>0 {
				Set IsOEPICC=1
				Set IsOEPICCDesc="中心静脉置管"
			}
		}
		Continue:IsFever=1
		Continue:IsTSAb=1
		Continue:IsOEUC=1
		Continue:IsOEVAP=1
		Continue:IsOEPICC=1	
	}
   	
   	Kill ^TMP($zn,$j,"SuRuleResult")
   		
	Set return=InfPosList_"^"_ItmScreenList_"^"_IsFeverDesc_","_IsTSAbDesc_","_IsOEUCDesc_","_IsOEVAPDesc_","_IsOEPICCDesc
	Quit return
}

}
