/// 名称:DHCMed.NINFService.BC.CasesSrv
/// 描述: 疑似病例筛查处置记录
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.NINFService.BC.CasesSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-12-14
/// Description:  检查处置操作与当前状态是否符合
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       类型\主题配置代码\就诊号\处置操作代码
/// Return：      返回Object
/// w ##class(DHCMed.NINFService.BC.CasesSrv).CheckCasesHandle("HA","INTCCS",12,1)
ClassMethod CheckCasesHandle(aTypeCode As %String, aSubjectCode As %String, aEpisodeID As %String, aOperation As %String)
{
	new (aTypeCode,aSubjectCode,aEpisodeID,aOperation)
	set return="0^参数错误!"
	quit:(aTypeCode="")||(aSubjectCode="")||(aEpisodeID="")||(aOperation="") return
	
	set $ZT="CheckCasesHandleError"
	
	set objCurrCases=""
	set xCasesID=""
	for {
		set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",aSubjectCode,aEpisodeID,xCasesID),-1)
		quit:xCasesID=""
		quit:$IsObject(objCurrCases)
		
		set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		continue:'$IsObject(objCases)
		set IsActive=objCases.CSIsActive
		continue:IsActive'=1
		set EndDate=objCases.CSEndDate
		continue:EndDate'=""  //此次感染结束
		
		set objCurrCases=objCases
	}
	
	//感染管理科权限控制
	if aTypeCode="HA" {
		if $IsObject(objCurrCases) {
			Set HandleAOper=objCases.CSHandleAOper
			Set HandleADate=objCases.CSHandleADate
			Set HandleATime=objCases.CSHandleATime
			Set HandleBOper=objCases.CSHandleBOper
			Set HandleBDate=objCases.CSHandleBDate
			Set HandleBTime=objCases.CSHandleBTime
			Set HandleType="A"
			If (HandleADate="")&&(HandleBDate'="") {
				Set HandleType="B"
			} ElseIf (HandleADate'="")&&(HandleBDate'="") {
				If (HandleADate<HandleBDate){
					Set HandleType="B"
				} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
					Set HandleType="B"
				} Else {}
			} Else {}
			
			Set HandleOper=HandleAOper
			Set:HandleType="B" HandleOper=HandleBOper
			
			if (HandleOper="1") {
				if (aOperation="5") {
					set return="-1^""排除""状态病例,不允许""感染结束""操作!"
					quit return
				}
			} elseif (HandleOper="2") {
				if (aOperation="5") {
					set return="-1^""疑似""状态病例,不允许""感染结束""操作!"
					quit return
				}
			} elseif (HandleOper="3") {
				if (aOperation="1")||(aOperation="2")||(aOperation="3") {
					set return="-1^""确诊""状态病例,不允许""排除"",""疑似""和""确诊""操作!"
					quit return
				}
			} elseif (HandleOper="4") {
				//
			} else {
				set return="-1^病例状态无效!"
				quit return
			}
		} else {
			if (aOperation="5") {
				set return="-1^感染管理科,""未处理""状态病例,不允许""感染结束""操作!"
				quit return
			}
		}
	}
	
	//临床科室 权限控制
	if aTypeCode="HB" {
		if (aOperation="2") {
			set return="-1^临床科室,不允许""疑似""操作!"
			quit return
		}
		if $IsObject(objCurrCases) {
			set HandleAOper=+objCurrCases.CSHandleAOper
			set HandleBOper=+objCurrCases.CSHandleBOper
			set HandleOper=HandleAOper
			set:(HandleAOper<HandleBOper) HandleOper=HandleBOper
			if (HandleOper=1)||(HandleOper=3) {
				set return="-1^临床科室,""排除""或""确诊""状态病例,不允许再进行任何操作!"
				quit return
			}
		} else {
			//set return="-1^临床科室,当前状态不允许进行任何操作!"
			//quit return
		}
	}
	
	set return=1
	quit return
	
CheckCasesHandleError
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2013-12-12
/// Description:  处理感染管理科处置记录(排除\疑似\确诊\消息)
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       就诊号\疑似病例筛查记录ID\操作代码\操作员登录科室\操作员
/// Return：      返回Object
/// w ##class(DHCMed.NINFService.BC.CasesSrv).ProcCasesHandle("HA","INTCCS","7","","4","22222222222","117","9","0","","")
ClassMethod ProcCasesHandle(aTypeCode As %String, aSubjectCode As %String, aEpisodeID As %String, aCasesXIDs As %String, aOperation As %String, aOpinion As %String, aLocID As %String, aUserID As %String, aAutoFlag As %String, aProDate As %String = "", aProTime As %String = "")
{
	new (aTypeCode,aSubjectCode,aEpisodeID,aCasesXIDs,aOperation,aOpinion,aLocID,aUserID,aAutoFlag,aProDate,aProTime)
	set return=0
	quit:(aTypeCode="")||(aSubjectCode="")||(aEpisodeID="")||(aOperation="") return
	
	if (aProDate="") {
		set ActDate=+$h
		set ActTime=$p($h,",",2)
	}else {
		set ActDate=aProDate
		set ActTime=aProTime
	}
	set XActDate=ActDate
	
	set $ZT="ProcCasesHandleError"
	
	TStart
	
	if (aTypeCode="HA")&&(aCasesXIDs'="") {
		set IsError=0
		for ind=1:1:$length(aCasesXIDs) {
			set xCasesXID=$p(aCasesXIDs,",",ind)
			continue:xCasesXID=""
			
			set SubjectCode=aSubjectCode
			set EpisodeID=aEpisodeID
			set TargetDept=$p($g(^PAADM(EpisodeID)),"^",4)
			set TargetWard=$p($g(^PAADM(EpisodeID)),"^",70)
			set:TargetWard'="" TargetWard=$p($g(^PAWARD(+TargetWard)),"^",5)
			set TargetDoc=$p($g(^PAADM(EpisodeID)),"^",9)
			
			set objCurrCases="",CasesHandleID=""
			set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(xCasesXID)
			continue:'$IsObject(objCasesX)
			set IsActive=objCasesX.CXIsActive
			continue:IsActive'=1
			set XActDate=objCasesX.CXActDate
			
			//首先根据疑似病例筛查记录,查找疑似病例处置记录
			set xCasesID=0
			for {
				set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexLnkCasesX",xCasesXID,xCasesID))
				quit:xCasesID=""
				
				set xSubID=0
				for {
					set xSubID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexLnkCasesX",xCasesXID,xCasesID,xSubID))
					quit:xSubID=""
					
					set objSub=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(xCasesID_"||"_xSubID)
					continue:'$IsObject(objSub)
					set IsActive=objSub.CHAIsActive
					continue:IsActive'=1
					set IsActive=objSub.ParRef.CSIsActive
					continue:IsActive'=1
					
					set objCurrCases=objSub.ParRef
					set CasesHandleID=xCasesID_"||"_xSubID
				}
			}
			//其次查找疑似病例记录
			if '$IsObject(objCurrCases) {
				set xCasesID=""
				for {
					set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",SubjectCode,EpisodeID,xCasesID),-1)
					quit:xCasesID=""
					quit:$IsObject(objCurrCases)
				
					set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
					continue:'$IsObject(objCases)
					set IsActive=objCases.CSIsActive
					continue:IsActive'=1
					set EndDate=objCases.CSEndDate
					continue:EndDate'=""  //此次感染结束
				
					set objCurrCases=objCases
				}
			}
			
			//感染管理科操作(消息\感染结束),必须有疑似病例记录
			continue:('$IsObject(objCurrCases))&&((aOperation=4)||(aOperation=5))
			
			if $IsObject(objCurrCases) {
				set CasesID=objCurrCases.%Id()
				//消息,不更新疑似病例记录状态
				set HandleAOper=objCurrCases.CSHandleAOper
				set HandleADate=objCurrCases.CSHandleADate
				set HandleATime=objCurrCases.CSHandleATime
				set HandleBOper=objCurrCases.CSHandleBOper
				set HandleBDate=objCurrCases.CSHandleBDate
				set HandleBTime=objCurrCases.CSHandleBTime
				if (aOperation=2)&&(HandleAOper=2) {
					//保持原状态不变
				} else {
					if (aOperation'=4) {
						set HandleAOper=aOperation
						set HandleADate=ActDate
						set HandleATime=ActTime
					}
				}
				
				//处理开始和结束时间
				if (aOperation=3) {
					set SttDate=XActDate
					set EndDate=""
				} elseif (aOperation=4) {
					set SttDate=objCurrCases.CSSttDate
					set EndDate=objCurrCases.CSEndDate
				} elseif (aOperation=5) {
					set SttDate=objCurrCases.CSSttDate
					set EndDate=XActDate
				} else {
					set SttDate=""
					set EndDate=""
				}
				
				set EvalOper=objCurrCases.CSEvalOper
				set EvalDate=objCurrCases.CSEvalDate
				set EvalTime=objCurrCases.CSEvalTime
			} else {
				set CasesID=""
				set HandleAOper=aOperation
				set HandleADate=ActDate
				set HandleATime=ActTime
				set HandleBOper="",HandleBDate="",HandleBTime=""
				
				//处理开始和结束时间
				if (aOperation=3) {
					set SttDate=XActDate
					set EndDate=""
				} elseif (aOperation=4) {
					set SttDate=""
					set EndDate=""
				} elseif (aOperation=5) {
					set SttDate=XActDate
					set EndDate=XActDate
				} else {
					set SttDate=""
					set EndDate=""
				}
				
				set EvalOper="",EvalDate="",EvalTime=""
			}
			
			set inputStr=CasesID
			set inputStr=inputStr_"^"_EpisodeID
			set inputStr=inputStr_"^"_SubjectCode
			set inputStr=inputStr_"^"_HandleAOper
			set inputStr=inputStr_"^"_HandleADate
			set inputStr=inputStr_"^"_HandleATime
			set inputStr=inputStr_"^"_HandleBOper
			set inputStr=inputStr_"^"_HandleBDate
			set inputStr=inputStr_"^"_HandleBTime
			set inputStr=inputStr_"^"_SttDate
			set inputStr=inputStr_"^"_EndDate
			set inputStr=inputStr_"^"_EvalOper
			set inputStr=inputStr_"^"_EvalDate
			set inputStr=inputStr_"^"_EvalTime
			set inputStr=inputStr_"^"_1
			set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.NINF.BC.Cases).Update(inputStr,"^")
			TRollBack:(+flg)<1
			set:(+flg)<1 IsError=1
			continue:(+flg)<1
			set CasesID=flg
			
			//一条疑似病例筛查记录,只能对应一条处置记录
			set SubID=""
			if (CasesHandleID'="")&&($p(CasesHandleID,"||",1)'=CasesID) {
				TRollBack
			} else {
				Set:($p(CasesHandleID,"||",1)=CasesID) SubID=$p(CasesHandleID,"||",2)
			}
			
			set inputStr=CasesID
			set inputStr=inputStr_"^"_SubID
			set inputStr=inputStr_"^"_aOperation
			set inputStr=inputStr_"^"_ActDate
			set inputStr=inputStr_"^"_ActTime
			set inputStr=inputStr_"^"_aLocID
			set inputStr=inputStr_"^"_aUserID
			set inputStr=inputStr_"^"_aOpinion
			set inputStr=inputStr_"^"_TargetDept
			set inputStr=inputStr_"^"_TargetWard
			set inputStr=inputStr_"^"_TargetDoc
			set inputStr=inputStr_"^"_+aAutoFlag
			set inputStr=inputStr_"^"_xCasesXID
			set inputStr=inputStr_"^"_1
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.NINF.BC.CasesHandleA).Update(inputStr,"^")
			TRollBack:(+flg)<1
			set:(+flg)<1 IsError=1
			continue:(+flg)<1
			
			//add by pylian 2016-02-27 院感管理科室排除/疑似/确诊消息推送
			Set HandleAID=flg
			If aOperation="1"  {//排除	
				Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleAID,"1",aEpisodeID)
			}ElseIf aOperation="2"{    //疑似
				Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleAID,"2",aEpisodeID)
			}ElseIf aOperation="3"{    //确诊
			 	Set ReportFlg=##Class(DHCMed.NINFService.BC.CasesSrv).IsReportByHandleID(HandleAID)
			    If (ReportFlg="1"){     //已报
			    	Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleAID,"4",aEpisodeID)
			    }Else{
					Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleAID,"3",aEpisodeID)
			    }
			}
		
		}
		quit:IsError>1 return
	} else {
		set SubjectCode=aSubjectCode
		set EpisodeID=aEpisodeID
		set TargetDept=$p($g(^PAADM(EpisodeID)),"^",4)
		set TargetWard=$p($g(^PAADM(EpisodeID)),"^",70)
		set:TargetWard'="" TargetWard=$p($g(^PAWARD(+TargetWard)),"^",5)
		set TargetDoc=$p($g(^PAADM(EpisodeID)),"^",9)
		
		set objCurrCases=""
		//其次查找疑似病例记录
		if '$IsObject(objCurrCases) {
			set xCasesID=""
			for {
				set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",SubjectCode,EpisodeID,xCasesID),-1)
				quit:xCasesID=""
				quit:$IsObject(objCurrCases)
				
				set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
				continue:'$IsObject(objCases)
				set IsActive=objCases.CSIsActive
				continue:IsActive'=1
				set EndDate=objCases.CSEndDate
				continue:EndDate'=""  //此次感染结束
				
				set objCurrCases=objCases
			}
		}
		//临床操作(感染结束),必须有疑似病例记录
		quit:('$IsObject(objCurrCases))&&(aOperation=5) return
		
		if $IsObject(objCurrCases) {
			set CasesID=objCurrCases.%Id()
			//消息,不更新疑似病例记录状态
			set HandleAOper=objCurrCases.CSHandleAOper
			set HandleADate=objCurrCases.CSHandleADate
			set HandleATime=objCurrCases.CSHandleATime
			set HandleBOper=objCurrCases.CSHandleBOper
			set HandleBDate=objCurrCases.CSHandleBDate
			set HandleBTime=objCurrCases.CSHandleBTime
			if (aOperation'=4) {
				if (aTypeCode="HB") {
					set HandleBOper=aOperation
					set HandleBDate=ActDate
					set HandleBTime=ActTime
				} else {
					set HandleAOper=aOperation
					set HandleADate=ActDate
					set HandleATime=ActTime
				}
			}
			
			//处理开始和结束时间
			if (aOperation=3) {
				set SttDate=XActDate
				set EndDate=""
			} elseif (aOperation=4) {
				set SttDate=objCurrCases.CSSttDate
				set EndDate=objCurrCases.CSEndDate
			} elseif (aOperation=5) {
				set SttDate=objCurrCases.CSSttDate
				set EndDate=XActDate
			} else {
				set SttDate=""
				set EndDate=""
			}
			
			set EvalOper=objCurrCases.CSEvalOper
			set EvalDate=objCurrCases.CSEvalDate
			set EvalTime=objCurrCases.CSEvalTime
		} else {
			set CasesID=""
			set HandleAOper="",HandleADate="",HandleATime=""
			set HandleBOper="",HandleBDate="",HandleBTime=""
			if (aTypeCode="HB") {
				set HandleBOper=aOperation
				set HandleBDate=ActDate
				set HandleBTime=ActTime
			} else {
				set HandleAOper=aOperation
				set HandleADate=ActDate
				set HandleATime=ActTime
			}
			
			//处理开始和结束时间
			if (aOperation=3) {
				set SttDate=XActDate
				set EndDate=""
			} elseif (aOperation=4) {
				set SttDate=""
				set EndDate=""
			} elseif (aOperation=5) {
				set SttDate=XActDate
				set EndDate=XActDate
			} else {
				set SttDate=""
				set EndDate=""
			}
			
			set EvalOper="",EvalDate="",EvalTime=""
		}
		
		set inputStr=CasesID
		set inputStr=inputStr_"^"_EpisodeID
		set inputStr=inputStr_"^"_SubjectCode
		set inputStr=inputStr_"^"_HandleAOper
		set inputStr=inputStr_"^"_HandleADate
		set inputStr=inputStr_"^"_HandleATime
		set inputStr=inputStr_"^"_HandleBOper
		set inputStr=inputStr_"^"_HandleBDate
		set inputStr=inputStr_"^"_HandleBTime
		set inputStr=inputStr_"^"_SttDate
		set inputStr=inputStr_"^"_EndDate
		set inputStr=inputStr_"^"_EvalOper
		set inputStr=inputStr_"^"_EvalDate
		set inputStr=inputStr_"^"_EvalTime
		set inputStr=inputStr_"^"_1
		set inputStr=inputStr_"^"_""
		set flg=##class(DHCMed.NINF.BC.Cases).Update(inputStr,"^")
		TRollBack:(+flg)<1
		quit:(+flg)<1 return
		set CasesID=flg
		
		if (aTypeCode="HB") {
			set inputStr=CasesID
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_aOperation
			set inputStr=inputStr_"^"_ActDate
			set inputStr=inputStr_"^"_ActTime
			set inputStr=inputStr_"^"_aLocID
			set inputStr=inputStr_"^"_aUserID
			set inputStr=inputStr_"^"_aOpinion
			set inputStr=inputStr_"^"_TargetDept
			set inputStr=inputStr_"^"_TargetWard
			set inputStr=inputStr_"^"_TargetDoc
			set inputStr=inputStr_"^"_1
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.NINF.BC.CasesHandleB).Update(inputStr,"^")
			TRollBack:(+flg)<1
			quit:(+flg)<1 return
			
			//add by pylian 2016-02-27 院感临床科室排除/确诊消息推送
			Set HandleBID=flg
			If aOperation="1"  {//排除	
				Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleBID,"1",aEpisodeID)
			}ElseIf aOperation="3"{    //确诊
			    Set ReportFlg=##Class(DHCMed.NINFService.BC.CasesSrv).IsReportByHandleID(HandleBID)
			    If (ReportFlg="1"){     //已报
			    	Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleBID,"4",aEpisodeID)
			    }Else{
					Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000041",HandleBID,"3",aEpisodeID)
			    }
			}	
		} else {
			set inputStr=CasesID
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_aOperation
			set inputStr=inputStr_"^"_ActDate
			set inputStr=inputStr_"^"_ActTime
			set inputStr=inputStr_"^"_aLocID
			set inputStr=inputStr_"^"_aUserID
			set inputStr=inputStr_"^"_aOpinion
			set inputStr=inputStr_"^"_TargetDept
			set inputStr=inputStr_"^"_TargetWard
			set inputStr=inputStr_"^"_TargetDoc
			set inputStr=inputStr_"^"_0
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_1
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.NINF.BC.CasesHandleA).Update(inputStr,"^")
			TRollBack:(+flg)<1
			quit:(+flg)<1 return
		}
	}
	
	//疑似、确诊、消息动作时，往消息平台发消息
	If (aOpinion'="")&&(aTypeCode="HA")&&((aOperation=2)||(aOperation=3)||(aOperation=4)) {
		//是否启用消息平台消息发送功能
		Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
		If (+IsSendMsg)=1 {
			Set tmpOpinion=aOpinion
			Set:aOperation=2 tmpOpinion="疑似感染："_tmpOpinion
			Set:aOperation=3 tmpOpinion="确诊感染："_tmpOpinion
			Set:aOperation=4 tmpOpinion="消息提醒："_tmpOpinion
			Set flg=##class(DHCMed.SSService.CommonCls).SendMsg(tmpOpinion,"1011",aUserID,aEpisodeID,"","")
		}
	}
	
	TCommit
	
	set return=1
	quit return
	
ProcCasesHandleError
	TRollBack
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2013-12-12
/// Description:  感染结束处置操作,结束此次疑似病例筛查
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       类型\主题配置代码\就诊号\操作员登录科室\操作员
/// Return：      返回Object
/// w ##class(DHCMed.NINFService.BC.CasesSrv).CloseCasesHandle("HA","INTCCS",204,"",117,9)
ClassMethod CloseCasesHandle(aTypeCode As %String, aSubjectCode As %String, aEpisodeID As %String, aOpinion As %String, aLocID As %String, aUserID As %String)
{
	new (aTypeCode,aSubjectCode,aEpisodeID,aOpinion,aLocID,aUserID)
	set return=0
	quit:(aTypeCode="")||(aSubjectCode="")||(aEpisodeID="") return
	
	set ActDate=+$h
	set ActTime=$p($h,",",2)
	set TargetDept=$p($g(^PAADM(aEpisodeID)),"^",4)
	set TargetWard=$p($g(^PAADM(aEpisodeID)),"^",70)
	set:TargetWard'="" TargetWard=$p($g(^PAWARD(+TargetWard)),"^",5)
	set TargetDoc=$p($g(^PAADM(aEpisodeID)),"^",9)
	
	set $ZT="CloseCasesHandleError"
	
	TStart
	
	set objCurrCases=""
	set xCasesID=""
	for {
		set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",aSubjectCode,aEpisodeID,xCasesID),-1)
		quit:xCasesID=""
		quit:$IsObject(objCurrCases)
	
		set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		continue:'$IsObject(objCases)
		set IsActive=objCases.CSIsActive
		continue:IsActive'=1
		set EndDate=objCases.CSEndDate
		continue:EndDate'=""  //此次感染结束
	
		set objCurrCases=objCases
	}
	
	//感染结束,都必须有疑似病例记录
	quit:'$IsObject(objCurrCases) return
	
	//感染结束,不更新疑似病例记录状态,只设置结束日期
	set inputStr=objCurrCases.%Id()
	set inputStr=inputStr_"^"_aEpisodeID
	set inputStr=inputStr_"^"_aSubjectCode
	set inputStr=inputStr_"^"_objCurrCases.CSHandleAOper
	set inputStr=inputStr_"^"_objCurrCases.CSHandleADate
	set inputStr=inputStr_"^"_objCurrCases.CSHandleATime
	set inputStr=inputStr_"^"_objCurrCases.CSHandleBOper
	set inputStr=inputStr_"^"_objCurrCases.CSHandleBDate
	set inputStr=inputStr_"^"_objCurrCases.CSHandleBTime
	set inputStr=inputStr_"^"_objCurrCases.CSSttDate
	set inputStr=inputStr_"^"_ActDate
	set inputStr=inputStr_"^"_objCurrCases.CSEvalOper
	set inputStr=inputStr_"^"_objCurrCases.CSEvalDate
	set inputStr=inputStr_"^"_objCurrCases.CSEvalTime
	set inputStr=inputStr_"^"_1
	set inputStr=inputStr_"^"_objCurrCases.CSResume
	set flg=##class(DHCMed.NINF.BC.Cases).Update(inputStr,"^")
	TRollBack:(+flg)<1
	set CasesID=flg
	
	if aTypeCode="HA" {  //感染科结束感染
		set inputStr=CasesID
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_5
		set inputStr=inputStr_"^"_ActDate
		set inputStr=inputStr_"^"_ActTime
		set inputStr=inputStr_"^"_aLocID
		set inputStr=inputStr_"^"_aUserID
		set inputStr=inputStr_"^"_aOpinion
		set inputStr=inputStr_"^"_TargetDept
		set inputStr=inputStr_"^"_TargetWard
		set inputStr=inputStr_"^"_TargetDoc
		set inputStr=inputStr_"^"_0
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_1
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set flg=##class(DHCMed.NINF.BC.CasesHandleA).Update(inputStr,"^")
		TRollBack:(+flg)<1
	} else {  //临床科室结束感染
		set inputStr=CasesID
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_5
		set inputStr=inputStr_"^"_ActDate
		set inputStr=inputStr_"^"_ActTime
		set inputStr=inputStr_"^"_aLocID
		set inputStr=inputStr_"^"_aUserID
		set inputStr=inputStr_"^"_aOpinion
		set inputStr=inputStr_"^"_TargetDept
		set inputStr=inputStr_"^"_TargetWard
		set inputStr=inputStr_"^"_TargetDoc
		set inputStr=inputStr_"^"_1
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set inputStr=inputStr_"^"_""
		set flg=##class(DHCMed.NINF.BC.CasesHandleB).Update(inputStr,"^")
		TRollBack:(+flg)<1
	}
	
	TCommit
	
	set return=1
	quit return
	
CloseCasesHandleError
	TRollBack
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2013-12-15
/// Description:  取消处置记录
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       类型\主题配置代码\就诊号\操作员登录科室\操作员
/// Return：      返回Object
/// w ##class(DHCMed.NINFService.BC.CasesSrv).CancelCasesHandle("HA","195||9",252,3306)
ClassMethod CancelCasesHandle(aTypeCode As %String, aHandleID As %String, aLocID As %String, aUserID As %String)
{
	new (aTypeCode,aHandleID,aLocID,aUserID)
	set return=0
	quit:(aTypeCode="")||(aHandleID="") return
	
	set $ZT="CancelCasesHandleErr"
	
	Set aSubjectCode="INTCCS"
	Set CasesID=$p(aHandleID,"||",1)
	Set HandleSub=$p(aHandleID,"||",2)
	Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(CasesID)
	Quit:'$IsObject(objCases) return
	
	Set HandleAOper=objCases.CSHandleAOper
	Set HandleADate=objCases.CSHandleADate
	Set HandleATime=objCases.CSHandleATime
	Set HandleBOper=objCases.CSHandleBOper
	Set HandleBDate=objCases.CSHandleBDate
	Set HandleBTime=objCases.CSHandleBTime
	
	If (aTypeCode="HA") {
		Set objHandle=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(aHandleID)
		Quit:'$IsObject(objHandle) return
		Set IsActive=objHandle.CHAIsActive
		Quit:IsActive'=1 return
		Set HandleDate=objHandle.CHAActDate
		Set HandleTime=objHandle.CHAActTime
		Quit:(HandleDate<HandleADate) return
		Quit:(HandleDate=HandleADate)&&(HandleTime<HandleATime) return
		If HandleBDate'="" {
			Quit:(HandleDate<HandleBDate) return
			Quit:(HandleDate=HandleBDate)&&(HandleTime<HandleBTime) return
		}
		
		TStart
		
		set inputStr=CasesID
		set inputStr=inputStr_"^"_HandleSub
		set inputStr=inputStr_"^"_objHandle.CHAOperation
		set inputStr=inputStr_"^"_objHandle.CHAActDate
		set inputStr=inputStr_"^"_objHandle.CHAActTime
		set inputStr=inputStr_"^"_objHandle.CHAActDept
		set inputStr=inputStr_"^"_objHandle.CHAActUser
		set inputStr=inputStr_"^"_objHandle.CHAOpinion
		set inputStr=inputStr_"^"_objHandle.CHATargetDept
		set inputStr=inputStr_"^"_objHandle.CHATargetWard
		set inputStr=inputStr_"^"_objHandle.CHATargetDoc
		set inputStr=inputStr_"^"_objHandle.CHAAutoFlag
		set inputStr=inputStr_"^"_objHandle.CHALnkCasesX
		set inputStr=inputStr_"^"_0
		set inputStr=inputStr_"^"_aLocID
		set inputStr=inputStr_"^"_aUserID
		set inputStr=inputStr_"^"_+$h
		set inputStr=inputStr_"^"_$p($h,",",2)
		set inputStr=inputStr_"^"_objHandle.CHAResume
		set flg=##class(DHCMed.NINF.BC.CasesHandleA).Update(inputStr,"^")
		TRollBack:(+flg)<1
		
		If (HandleDate=HandleADate)&&(HandleTime=HandleATime) {
			Set (HandleOper,HandleDate,HandleTime,tmpHandleOper,tmpHandleDate,tmpHandleTime,tmpSttDate,tmpEndDate,tmpIsActive)=""
			Set xHandleSub=HandleSub
			For {
				Set xHandleSub=$o(^DHCMed.NINF.BC.CasesD(CasesID,"HA",xHandleSub),-1)
				Quit:xHandleSub=""
				
				Set objHandle=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(CasesID_"||"_xHandleSub)
				Continue:'$IsObject(objHandle)
				Set IsActive=objHandle.CHAIsActive
				Continue:IsActive'=1
				Set HandleOper=objHandle.CHAOperation
				Set HandleDate=objHandle.CHAActDate
				Set HandleTime=objHandle.CHAActTime
				Quit:HandleOper'=4
			}
			If HandleOper="" {
				Set tmpIsActive=0
				Set tmpHandleOper=objCases.CSHandleAOper
				Set tmpHandleDate=objCases.CSHandleADate
				Set tmpHandleTime=objCases.CSHandleATime
				Set tmpSttDate=objCases.CSSttDate
			} Else {
				Set tmpIsActive=1
				Set tmpHandleOper=HandleOper
				Set tmpHandleDate=HandleDate
				Set tmpHandleTime=HandleTime
				If HandleOper=3 {
					Set tmpSttDate=HandleDate
				}
				If HandleOper=5 {
					Set tmpSttDate=objCases.CSSttDate
					Set tmpEndDate=HandleDate
				}
			}
			set inputStr=CasesID
			set inputStr=inputStr_"^"_objCases.CSEpisodeID
			set inputStr=inputStr_"^"_objCases.CSSubjectCode
			set inputStr=inputStr_"^"_tmpHandleOper
			set inputStr=inputStr_"^"_tmpHandleDate
			set inputStr=inputStr_"^"_tmpHandleTime
			set inputStr=inputStr_"^"_objCases.CSHandleBOper
			set inputStr=inputStr_"^"_objCases.CSHandleBDate
			set inputStr=inputStr_"^"_objCases.CSHandleBTime
			set inputStr=inputStr_"^"_tmpSttDate
			set inputStr=inputStr_"^"_tmpEndDate
			set inputStr=inputStr_"^"_objCases.CSEvalOper
			set inputStr=inputStr_"^"_objCases.CSEvalDate
			set inputStr=inputStr_"^"_objCases.CSEvalTime
			set inputStr=inputStr_"^"_tmpIsActive
			set inputStr=inputStr_"^"_objCases.CSResume
			set flg=##class(DHCMed.NINF.BC.Cases).Update(inputStr,"^")
			TRollBack:(+flg)<1
		}
		
		TCommit
	}
	
	If (aTypeCode="HB") {
		Set objHandle=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(aHandleID)
		Quit:'$IsObject(objHandle) return
		Set IsActive=objHandle.CHBIsActive
		Quit:IsActive'=1 return
		Set HandleDate=objHandle.CHBActDate
		Set HandleTime=objHandle.CHBActTime
		Quit:(HandleDate<HandleBDate) return
		Quit:(HandleDate=HandleBDate)&&(HandleTime<HandleBTime) return
		If HandleADate'="" {
			Quit:(HandleDate<HandleADate) return
			Quit:(HandleDate=HandleADate)&&(HandleTime<HandleATime) return
		}
		
		TStart
		
		set inputStr=CasesID
		set inputStr=inputStr_"^"_HandleSub
		set inputStr=inputStr_"^"_objHandle.CHBOperation
		set inputStr=inputStr_"^"_objHandle.CHBActDate
		set inputStr=inputStr_"^"_objHandle.CHBActTime
		set inputStr=inputStr_"^"_objHandle.CHBActDept
		set inputStr=inputStr_"^"_objHandle.CHBActUser
		set inputStr=inputStr_"^"_objHandle.CHBOpinion
		set inputStr=inputStr_"^"_objHandle.CHBTargetDept
		set inputStr=inputStr_"^"_objHandle.CHBTargetWard
		set inputStr=inputStr_"^"_objHandle.CHBTargetDoc
		set inputStr=inputStr_"^"_0
		set inputStr=inputStr_"^"_aLocID
		set inputStr=inputStr_"^"_aUserID
		set inputStr=inputStr_"^"_+$h
		set inputStr=inputStr_"^"_$p($h,",",2)
		set inputStr=inputStr_"^"_objHandle.CHBResume
		set flg=##class(DHCMed.NINF.BC.CasesHandleB).Update(inputStr,"^")
		TRollBack:(+flg)<1
		
		If (HandleDate=HandleBDate)&&(HandleTime=HandleBTime) {
			Set (HandleOper,HandleDate,HandleTime,tmpHandleOper,tmpHandleDate,tmpHandleTime,tmpSttDate,tmpEndDate,tmpIsActive)=""
			Set xHandleSub=HandleSub
			For {
				Set xHandleSub=$o(^DHCMed.NINF.BC.CasesD(CasesID,"HB",xHandleSub),-1)
				Quit:xHandleSub=""
				
				Set objHandle=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(CasesID_"||"_xHandleSub)
				Continue:'$IsObject(objHandle)
				Set IsActive=objHandle.CHBIsActive
				Continue:IsActive'=1
				Set HandleOper=objHandle.CHBOperation
				Set HandleDate=objHandle.CHBActDate
				Set HandleTime=objHandle.CHBActTime
				Quit:HandleOper'=4
			}
			If HandleOper="" {
				Set tmpIsActive=0
				Set tmpHandleOper=objCases.CSHandleBOper
				Set tmpHandleDate=objCases.CSHandleBDate
				Set tmpHandleTime=objCases.CSHandleBTime
				Set tmpSttDate=objCases.CSSttDate
			} Else {
				Set tmpIsActive=1
				Set tmpHandleOper=HandleOper
				Set tmpHandleDate=HandleDate
				Set tmpHandleTime=HandleTime
				If HandleOper=3 {
					Set tmpSttDate=HandleDate
				}
				If HandleOper=5 {
					Set tmpSttDate=objCases.CSSttDate
					Set tmpEndDate=HandleDate
				}
			}
			
			set inputStr=CasesID
			set inputStr=inputStr_"^"_objCases.CSEpisodeID
			set inputStr=inputStr_"^"_objCases.CSSubjectCode
			set inputStr=inputStr_"^"_objCases.CSHandleBOper
			set inputStr=inputStr_"^"_objCases.CSHandleBDate
			set inputStr=inputStr_"^"_objCases.CSHandleBTime
			set inputStr=inputStr_"^"_tmpHandleOper
			set inputStr=inputStr_"^"_tmpHandleDate
			set inputStr=inputStr_"^"_tmpHandleTime
			set inputStr=inputStr_"^"_tmpSttDate
			set inputStr=inputStr_"^"_tmpEndDate
			set inputStr=inputStr_"^"_objCases.CSEvalOper
			set inputStr=inputStr_"^"_objCases.CSEvalDate
			set inputStr=inputStr_"^"_objCases.CSEvalTime
			set inputStr=inputStr_"^"_tmpIsActive
			set inputStr=inputStr_"^"_objCases.CSResume
			set flg=##class(DHCMed.NINF.BC.Cases).Update(inputStr,"^")
			TRollBack:(+flg)<1
		}
		
		TCommit
	}
	
	Set return=1
	Quit return
CancelCasesHandleErr
	quit "-999"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2013-12-11
/// Description:  查询疑似病例处置列表
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesSrv","QryHandleDtl","INTCCS","304843")
Query QryHandleDtl(aSubjectCode As %String, aEpisodeID As %String) As %Query(ROWSPEC = "CasesID:%String,HandleType:%String,SubID:%String,Operation:%String,CurrFlag:%String,ActDate:%String,ActTime:%String,ActDept:%String,ActUser:%String,Opinion:%String,TargetDept:%String,TargetWard:%String,TargetDoc:%String,LnkCasesX:%String,CasesXDate:%String,AutoFlag:%String,InfDays:%String")
{
}

ClassMethod QryHandleDtlExecute(ByRef qHandle As %Binary, aSubjectCode As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aSubjectCode="")||(aEpisodeID="") $$$OK
	
	Kill ArrData
	Set CurrData=""
	Set xCasesID=0
	For {
		Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",aSubjectCode,aEpisodeID,xCasesID))
		Quit:xCasesID=""
		
		Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		Continue:'$IsObject(objCases)
		Set IsActive=objCases.CSIsActive
		Continue:IsActive'=1
		
		Set HandleAOper=objCases.CSHandleAOper
		Set HandleAOper=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleAOper)
		Set HandleADate=objCases.CSHandleADate
		;Set:HandleADate'="" HandleADate=$zd(HandleADate,3)
		Set:HandleADate'="" HandleADate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HandleADate)
		Set HandleATime=objCases.CSHandleATime
		Set:HandleATime'="" HandleATime=$zt(HandleATime,1)
		Set HandleBOper=objCases.CSHandleBOper
		Set HandleBOper=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleBOper)
		Set HandleBDate=objCases.CSHandleBDate
		;Set:HandleBDate'="" HandleBDate=$zd(HandleBDate,3)
		Set:HandleBDate'="" HandleBDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HandleBDate)
		Set HandleBTime=objCases.CSHandleBTime
		Set:HandleBTime'="" HandleBTime=$zt(HandleBTime,1)
		Set SttDate=objCases.CSSttDate
		;Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:SttDate'="" SttDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SttDate)
		Set EndDate=objCases.CSEndDate
		;Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)
		
		Set HandleType="A"
		If (HandleADate="")&&(HandleBDate'="") {
			Set HandleType="B"
		} ElseIf (HandleADate'="")&&(HandleBDate'="") {
			If (HandleADate<HandleBDate){
				Set HandleType="B"
			} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
				Set HandleType="B"
			} Else {}
		} Else {}
		
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HA",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(xCasesID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			Set IsActive=objSub.CHAIsActive
			Continue:IsActive'=1
			
			Set Operation=objSub.CHAOperation
			Set InfDays=""
			Set:Operation="3" InfDays="↓"_SttDate  //确诊 确诊日期
			Set:Operation="5" InfDays="↑"_EndDate  //感染结束 结束日期
			Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
			Set ActDate=objSub.CHAActDate
			;Set:ActDate'="" ActDate=$zd(ActDate,3)
			Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
			Set ActTime=objSub.CHAActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set CurrFlag=0
			If (HandleAOper=Operation)&&(HandleADate=ActDate)
			&&(HandleATime=ActTime)&&(HandleType="A") {
				Set CurrFlag=1
			}
			Set ActDept=objSub.CHAActDept
			Set:ActDept'="" ActDept=$p($g(^CTLOC(ActDept)),"^",2)
			Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
			Set ActUser=objSub.CHAActUser
			Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
			Set Opinion=objSub.CHAOpinion
			Set TargetDept=objSub.CHATargetDept
			Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
			Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
			Set TargetWard=objSub.CHATargetWard
			Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
			Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
			Set TargetDoc=objSub.CHATargetDoc
			Set:TargetDoc'="" TargetDoc=$p($g(^CTPCP(TargetDoc,1)),"^",2)
			Set AutoFlag=objSub.CHAAutoFlag
			Set LnkCasesX=objSub.CHALnkCasesX
			Set CasesXDate=""
			Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(LnkCasesX)
			If $IsObject(objCasesX) {
				Set CasesXDate=objCasesX.CXActDate
				;Set:CasesXDate'="" CasesXDate=$zd(CasesXDate,3)
				Set:CasesXDate'="" CasesXDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CasesXDate)
			}
			Set Resume=objSub.CHAResume
			
			Set:Opinion="" Opinion="*"
			
			Set Data=$lb(xCasesID,"HA",xSubID,Operation,CurrFlag,ActDate,ActTime,ActDept,ActUser,Opinion,TargetDept,TargetWard,TargetDoc,LnkCasesX,CasesXDate,AutoFlag,InfDays)
		 	Set:CurrFlag=1 CurrData=Data
		 	Set num=$i(ArrData(ActDate_" "_ActTime))
		 	Set ArrData(ActDate_" "_ActTime,num)=Data
		}
		
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HB",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(xCasesID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			Set IsActive=objSub.CHBIsActive
			Continue:IsActive'=1
			
			Set Operation=objSub.CHBOperation
			Set InfDays=""
			Set:Operation="3" InfDays="↓"_SttDate  //确诊 确诊日期
			Set:Operation="5" InfDays="↑"_EndDate  //感染结束 结束日期
			Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
			Set ActDate=objSub.CHBActDate
			;Set:ActDate'="" ActDate=$zd(ActDate,3)
			Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
			Set ActTime=objSub.CHBActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set CurrFlag=0
			If (HandleBOper=Operation)&&(HandleBDate=ActDate)
			&&(HandleBTime=ActTime)&&(HandleType="B") {
				Set CurrFlag=1
			}
			Set ActDept=objSub.CHBActDept
			Set:ActDept'="" ActDept=$p($g(^CTLOC(ActDept)),"^",2)
			Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
			Set ActUser=objSub.CHBActUser
			Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
			Set Opinion=objSub.CHBOpinion
			Set TargetDept=objSub.CHBTargetDept
			Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
			Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
			Set TargetWard=objSub.CHBTargetWard
			Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
			Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
			Set TargetDoc=objSub.CHBTargetDoc
			Set:TargetDoc'="" TargetDoc=$p($g(^CTPCP(TargetDoc,1)),"^",2)
			Set Resume=objSub.CHBResume
			
			Set:Opinion="" Opinion="*"
			
			Set Data=$lb(xCasesID,"HB",xSubID,Operation,CurrFlag,ActDate,ActTime,ActDept,ActUser,Opinion,TargetDept,TargetWard,TargetDoc,"","","",InfDays)
		 	Set:CurrFlag=1 CurrData=Data
		 	Set num=$i(ArrData(ActDate_" "_ActTime))
		 	Set ArrData(ActDate_" "_ActTime,num)=Data
		}
	}
	
	Set xActTime="",Count=0
	For {
		Set xActTime=$o(ArrData(xActTime))
		Quit:xActTime=""
		
		Set xNum=""
		For {
			Set xNum=$o(ArrData(xActTime,xNum))
			Quit:xNum=""
			
			Set Count=Count+1
			Set Data=$g(ArrData(xActTime,xNum))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	/*
	If (CurrData'="")&&(Count>1) {
		Set ^CacheTemp(repid,ind)=CurrData
		Set ind=ind+1
	}
	*/
	Quit $$$OK
}

ClassMethod QryHandleDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandleDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHandleDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandleDtlExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2014-01-24
/// Description:  获取疑似记录对应处置操作
/// Table：       DHCMed.NINF.BC.CasesHandleA
/// Input：       疑似记录ID
/// Return：      
/// w ##Class(DHCMed.NINFService.BC.CasesSrv).GetHandleGrade(4)
ClassMethod GetHandleGrade(aCasesXID As %String)
{
	New (aCasesXID)
	Set return=""
	Quit:aCasesXID="" return
	
	Set HandleGrade=""
	Set xCasesID=""
	For {
		Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexLnkCasesX",aCasesXID,xCasesID))
		Quit:xCasesID=""
		Quit:HandleGrade'=""
		
		Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		Continue:'$IsObject(objCases)
		Set IsActive=objCases.CSIsActive
		Continue:IsActive'=1
		
		Set xHASub=""
		For {
			Set xHASub=$o(^DHCMed.NINF.BC.CasesI("HA","IndexLnkCasesX",aCasesXID,xCasesID,xHASub))
			Quit:xHASub=""
			Quit:HandleGrade'=""
			
			Set objCasesHA=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(xCasesID_"||"_xHASub)
			Continue:'$IsObject(objCasesHA)
			Set IsActive=objCasesHA.CHAIsActive
			Continue:IsActive'=1
			Set HandleGrade=objCasesHA.CHAOperation  //处置等级(1排除\2确诊\3报告)
		}
	}
	
	Set return=HandleGrade
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-06
/// Description:  获取疑似记录对应处置操作
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       SubjectCode,EpisodeID
/// Return：      
/// w ##Class(DHCMed.NINFService.BC.CasesSrv).GetCasesHandleStatus("INTCCS","579037")
ClassMethod GetCasesHandleStatus(aSubjectCode As %String, aEpisodeID As %String)
{
	New (aSubjectCode,aEpisodeID)
	Set return=""
	Quit:(aSubjectCode="")||(aEpisodeID="") return
	
	Set xCasesID=""
	For {
		Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",aSubjectCode,aEpisodeID,xCasesID),-1)
		Quit:xCasesID=""
		Quit:return'=""
		
		Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		Continue:'$IsObject(objCases)
		Set IsActive=objCases.CSIsActive
		Continue:IsActive'=1
		
		Set HandleAOper=objCases.CSHandleAOper
		Set HandleADate=objCases.CSHandleADate
		Set HandleATime=objCases.CSHandleATime
		Set HandleBOper=objCases.CSHandleBOper
		Set HandleBDate=objCases.CSHandleBDate
		Set HandleBTime=objCases.CSHandleBTime
		Set SttDate=objCases.CSSttDate
		Set EndDate=objCases.CSEndDate
		
		Set HandleType="A"
		If (HandleADate="")&&(HandleBDate'="") {
			Set HandleType="B"
		} ElseIf (HandleADate'="")&&(HandleBDate'="") {
			If (HandleADate<HandleBDate){
				Set HandleType="B"
			} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
				Set HandleType="B"
			} Else {}
		} Else {}
		
		If HandleType="A" {
			Set HandleOper=HandleAOper
			Set HandleDate=HandleADate
			Set HandleTime=HandleATime
		}
		
		If HandleType="B" {
			Set HandleOper=HandleBOper
			Set HandleDate=HandleBDate
			Set HandleTime=HandleBTime
		}
		;Set:HandleDate'="" HandleDate=$zd(HandleDate,3)
		Set:HandleDate'="" HandleDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HandleDate)
		Set:HandleTime'="" HandleTime=$zt(HandleTime,1)
		;Set:SttDate'="" SttDate=$zd(SttDate,3)
		;Set:EndDate'="" EndDate=$zd(EndDate,4)
		Set:SttDate'="" SttDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SttDate)
		Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)
		
		Set HandleOperDesc=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleOper)
		
		Set return=HandleOper_","_HandleOperDesc_","_HandleDate_","_HandleTime_","_SttDate_","_EndDate
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-02-11
/// Description:  临床疑似病例处置记录展示
/// Table：       DHCMed.NINF.BC.Cases
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesSrv","QryClinCasesMain","INTCCS","12")
Query QryClinCasesMain(aSubjectCode As %String, aEpisodeID As %String) As %Query(ROWSPEC = "CasesID:%String,HandleType:%String,HandleOper:%String,HandleDate:%String,HandleTime:%String,SttDate:%String,EndDate:%String,ActDept:%String,ActUser:%String,Opinion:%String,TargetDept:%String,TargetWard:%String,TargetDoc:%String")
{
}

ClassMethod QryClinCasesMainExecute(ByRef qHandle As %Binary, aSubjectCode As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aSubjectCode="")||(aEpisodeID="") $$$OK
	
	Set xCasesID=0
	For {
		Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID",aSubjectCode,aEpisodeID,xCasesID))
		Quit:xCasesID=""
		
		Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		Continue:'$IsObject(objCases)
		Set IsActive=objCases.CSIsActive
		Continue:IsActive'=1
		
		Set HandleAOper=objCases.CSHandleAOper
		Set HandleAOper=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleAOper)
		Set HandleADate=objCases.CSHandleADate
		Set HandleATime=objCases.CSHandleATime
		Set HandleBOper=objCases.CSHandleBOper
		Set HandleBOper=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(HandleBOper)
		Set HandleBDate=objCases.CSHandleBDate
		Set HandleBTime=objCases.CSHandleBTime
		Set SttDate=objCases.CSSttDate
		Set EndDate=objCases.CSEndDate
		
		Set HandleType="A"
		If (HandleADate="")&&(HandleBDate'="") {
			Set HandleType="B"
		} ElseIf (HandleADate'="")&&(HandleBDate'="") {
			If (HandleADate<HandleBDate){
				Set HandleType="B"
			} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
				Set HandleType="B"
			} Else {}
		} Else {}
		
		If HandleType="A" {
			Set HandleOper=HandleAOper
			Set HandleDate=HandleADate
			Set HandleTime=HandleATime
			
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HA",xSubID),-1)
				Quit:xSubID=""
				
				Set objSub=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(xCasesID_"||"_xSubID)
				Continue:'$IsObject(objSub)
				Set IsActive=objSub.CHAIsActive
				Continue:IsActive'=1
				
				Set Operation=objSub.CHAOperation
				Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
				Continue:HandleOper'=Operation
				Set ActDate=objSub.CHAActDate
				Continue:HandleDate'=ActDate
				Set ActTime=objSub.CHAActTime
				Continue:HandleTime'=ActTime
				
				Set ActDept=objSub.CHAActDept
				Set:ActDept'="" ActDept=$p($g(^CTLOC(ActDept)),"^",2)
				Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
				Set ActUser=objSub.CHAActUser
				Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
				Set Opinion=objSub.CHAOpinion
				Set TargetDept=objSub.CHATargetDept
				Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
				Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
				Set TargetWard=objSub.CHATargetWard
				Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
				Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
				Set TargetDoc=objSub.CHATargetDoc
				Set:TargetDoc'="" TargetDoc=$p($g(^CTPCP(TargetDoc,1)),"^",2)
				Quit //退出循环
			}
		} Else {
			Set HandleOper=HandleBOper
			Set HandleDate=HandleBDate
			Set HandleTime=HandleBTime
			
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HB",xSubID),-1)
				Quit:xSubID=""
				
				Set objSub=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(xCasesID_"||"_xSubID)
				Continue:'$IsObject(objSub)
				Set IsActive=objSub.CHBIsActive
				Continue:IsActive'=1
				
				Set Operation=objSub.CHBOperation
				Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
				Continue:HandleOper'=Operation
				Set ActDate=objSub.CHBActDate
				Continue:HandleDate'=ActDate
				Set ActTime=objSub.CHBActTime
				Continue:HandleTime'=ActTime
				
				Set ActDept=objSub.CHBActDept
				Set:ActDept'="" ActDept=$p($g(^CTLOC(ActDept)),"^",2)
				Set:$p(ActDept,"-",2)'="" ActDept=$p(ActDept,"-",2)
				Set ActUser=objSub.CHBActUser
				Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
				Set Opinion=objSub.CHBOpinion
				Set TargetDept=objSub.CHBTargetDept
				Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
				Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
				Set TargetWard=objSub.CHBTargetWard
				Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
				Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
				Set TargetDoc=objSub.CHBTargetDoc
				Set:TargetDoc'="" TargetDoc=$p($g(^CTPCP(TargetDoc,1)),"^",2)
				Quit //退出循环
			}
		}
		
		Set:HandleDate'="" HandleDate=$zd(HandleDate,3)
		Set:HandleTime'="" HandleTime=$zt(HandleTime,2)
		Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set Data=$lb(xCasesID,HandleType,HandleOper,HandleDate,HandleTime,SttDate,EndDate,ActDept,ActUser,Opinion,TargetDept,TargetWard,TargetDoc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryClinCasesMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryClinCasesMainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryClinCasesMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryClinCasesMainExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2016-02-27
/// Description:  根据推送确诊消息ID（处置操作ID）判断确诊病例是否上报院感报告
/// Table：       DHCMed.NINF.BC.CasesHandleA,DHCMed.NINF.BC.CasesHandleB 
/// Input：       处置操作ID
/// Return：      上报院感报告（感染日期、感染部位、感染诊断）,是，"",否
/// w ##Class(DHCMed.NINFService.BC.CasesSrv).GetIsReportByHandleID("12||1")
ClassMethod GetIsReportByHandleID(HandleID As %String)
{
	New (HandleID)
	Set return=""
	Quit:HandleID="" return
	
	Set InfDates="",InfPosDescs="",InfDiagDescs=""
	Set xCasesID=$p(HandleID,"||",1)
	
	Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
	Quit:'$IsObject(objCases) return
	Set IsActive=objCases.CSIsActive
	Quit:IsActive'=1 return
	Set EpisodeID=objCases.CSEpisodeID
	Quit:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) return  //无报告退出
	Set HandleAOper=objCases.CSHandleAOper
	Set HandleBOper=objCases.CSHandleBOper

	If (HandleAOper'="")&&(HandleAOper=3){
		Set objHandleA=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(HandleID)
		Quit:'$IsObject(objHandleA) return
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
			Quit:xRepID=""
		
			Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			
			s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportInfPos:QrySubRec")
	        d ds.Execute(xRepID,EpisodeID)
		  
		    Set InfDates=InfDates_","_InfDate
		    Set InfPosDescs=InfPosDescs_","_InfPosDesc  
		    Set InfDiagDescs=InfDiagDescs_","_InfDiagDesc
		}
		Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
		Set:InfPosDescs'="" InfPosDescs=$e(InfPosDescs,2,$l(InfPosDescs))
		Set:InfDiagDescs'="" InfDiagDescs=$e(InfDiagDescs,2,$l(InfDiagDescs))
	
		Set return=InfDates_"^"_InfPosDescs_"^"_InfDiagDescs

	}ElseIf (HandleBOper'="")&&(HandleBOper=3){
		Set objHandleB=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(HandleID)
		Quit:'$IsObject(objHandleB) return
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
			Quit:xRepID=""
		
			Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			
			s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportInfPos:QrySubRec")
	        d ds.Execute(xRepID,EpisodeID)
		  
		    Set InfDates=InfDates_","_InfDate
		    Set InfPosDescs=InfPosDescs_","_InfPosDesc  
		    Set InfDiagDescs=InfDiagDescs_","_InfDiagDesc
		}
		Set:InfDates'="" InfDates=$e(InfDates,2,$l(InfDates))
		Set:InfPosDescs'="" InfPosDescs=$e(InfPosDescs,2,$l(InfPosDescs))
		Set:InfDiagDescs'="" InfDiagDescs=$e(InfDiagDescs,2,$l(InfDiagDescs))
	
		Set return=InfDates_"^"_InfPosDescs_"^"_InfDiagDescs
	}

	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-30
/// Description:  根据推送确诊消息ID（处置操作ID）判断确诊病例是否上报院感报告
/// Table：       DHCMed.NINF.BC.CasesHandleA,DHCMed.NINF.BC.CasesHandleB 
/// Input：       处置操作ID
/// Return：      是:1,否:0
/// w ##Class(DHCMed.NINFService.BC.CasesSrv).IsReportByHandleID("2||1")
ClassMethod IsReportByHandleID(HandleID As %String)
{
	New (HandleID)
	Set return=0
	Quit:HandleID="" return
	
	Set InfDates="",InfPosDescs="",InfDiagDescs=""
	Set xCasesID=$p(HandleID,"||",1)
	
	Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
	Quit:'$IsObject(objCases) return
	Set IsActive=objCases.CSIsActive
	Quit:IsActive'=1 return
	Set EpisodeID=objCases.CSEpisodeID
	Quit:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) return  //无报告退出
	Set HandleAOper=objCases.CSHandleAOper
	Set HandleBOper=objCases.CSHandleBOper

	If (HandleAOper'="")&&(HandleAOper=3){
		Set objHandleA=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(HandleID)
		Quit:'$IsObject(objHandleA) return
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
			Quit:xRepID=""
		    Quit:return=1
		    
			Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.ReportStatus)
			Set RepStatus=objReport.ReportStatus.Description
			Set RepStatusCode=objReport.ReportStatus.Code
		    Continue:RepStatusCode=0
		
			Continue:'$IsObject(objReport.ReportType)
			Set RepTypeCode=objReport.ReportType.Code
			Continue:(RepTypeCode'="COMP")&&(RepTypeCode'="NCOM")
			Set return=1
		}
	

	}ElseIf (HandleBOper'="")&&(HandleBOper=3){
		Set objHandleB=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(HandleID)
		Quit:'$IsObject(objHandleB) return
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
			Quit:xRepID=""
		     Quit:return=1
		     
			Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.ReportStatus)
			Set RepStatus=objReport.ReportStatus.Description
			Set RepStatusCode=objReport.ReportStatus.Code
		    Continue:RepStatusCode=0
		
			Continue:'$IsObject(objReport.ReportType)
			Set RepTypeCode=objReport.ReportType.Code
			Continue:(RepTypeCode'="COMP")&&(RepTypeCode'="NCOM")
			Set return=1	
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-30
/// Description:  院感上报时检查是否有确诊处置记录
/// Input：       ReportID
/// Return：      是:1,否:0
/// w ##class(DHCMed.NINFService.BC.CasesSrv).IsHandleByReportID(13)
ClassMethod IsHandleByReportID(aReportID As %String)
{
	new (aReportID)
	Set return=0
	Quit:(aReportID="") return
	
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Quit:'$IsObject(objReport.ReportStatus) return
	Set RepStatus=objReport.ReportStatus.Description
	Set RepStatusCode=objReport.ReportStatus.Code
	Quit:RepStatusCode=0 return                      //删除状态退出
		
	Quit:'$IsObject(objReport.ReportType)
	Set RepTypeCode=objReport.ReportType.Code
	Quit:(RepTypeCode'="COMP")&&(RepTypeCode'="NCOM") return
 
    Set EpisodeID=objReport.EpisodeID                  //就诊号
    Quit:'$d(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID","INTCCS",EpisodeID)) return  //无处置记录退出
 	
	Set xCasesID=0
	For {
		Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("IndexSubjectEpisodeID","INTCCS",EpisodeID,xCasesID))
		Quit:xCasesID=""
		
		Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
		Continue:'$IsObject(objCases)
		Set IsActive=objCases.CSIsActive
		Continue:IsActive'=1
		
		Set HandleAOper=objCases.CSHandleAOper
		Set HandleBOper=objCases.CSHandleBOper
		If (HandleAOper'="")&&(HandleAOper=3){
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HA",xSubID),-1)
				Quit:xSubID=""
				Quit:$p(return,"^",1)=1
				
				Set HandleID=xCasesID_"||"_xSubID
				Set objSub=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(HandleID)
				Continue:'$IsObject(objSub)
				Set IsActive=objSub.CHAIsActive
				Continue:IsActive'=1
				Set Operation=objSub.CHAOperation
				Set return =1_"^"_HandleID
			}

		}ElseIf (HandleBOper'="")&&(HandleBOper=3){
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCMed.NINF.BC.CasesD(xCasesID,"HB",xSubID),-1)
				Quit:xSubID=""
				Quit:$p(return,"^",1)=1
				
				Set HandleID=xCasesID_"||"_xSubID
				Set objSub=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(HandleID)
				Continue:'$IsObject(objSub)
				Set IsActive=objSub.CHBIsActive
				Continue:IsActive'=1
				Set Operation=objSub.CHBOperation
				Set return =1_"^"_HandleID
			}
		}
	}
	Quit return
}

}
