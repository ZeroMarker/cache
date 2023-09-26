/// 名称: 		DHCMA.CPW.BTS.ApplyExamRecSrv
/// 描述: 		表单发布审核服务类
/// 编写者：	yankai
/// 编写日期: 	2021-11-29
Class DHCMA.CPW.BTS.ApplyExamRecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yankai
/// CreatDate：   2021-11-29
/// Description:  获取表单最新一次发布申请的最终结果
/// Table：       DHCMA.CPW.BT.ApplyExamRec
/// Input：       表单id
/// Return：      通过：1，未通过：0，申请中：-1，未申请:-2，其他：-9
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetLastExamResult("")  
ClassMethod GetLastExamResult(aPathFormID As %String) As %String
{
	New (aPathFormID)
	Set return=-9
	Quit:aPathFormID="" return
	
	Set objPathForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objPathForm) -9
	Quit:objPathForm.FormVersion="" -9
	Set ExamType=$s(objPathForm.FormVersion=1:"N",1:"M")
	Set ExamRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("IdxofFormDr",aPathFormID,""),-1)
	Set objExamRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(ExamRecID)
	Quit:'$IsObject(objExamRec) -2											//未发现申请记录，返回-2
	Set return = objExamRec.BTExamFinResult
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-11-30
/// Description:  提交申请
/// Table：       DHCMA.CPW.BT.ApplyExamRec、DHCMA.CPW.BT.ApplyExamRecDtl
/// Input：       表单id,申请人ID，申请科室ID
/// Return：      
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).CommitPubApply("12","203!!1","9!!1","2!!1") 
ClassMethod CommitPubApply(aPathFormID As %String, aLocID As %String, aUserID As %String, aHospID As %String) As %String
{
	New (aPathFormID,aLocID,aUserID,aHospID)
	Set return=""
	Quit:(aPathFormID="")||(aLocID="")||(aUserID="")||(aHospID="") return
	
	//Set ^TEMPYK("CommitPubApply")=$lb(aPathFormID,aLocID,aUserID,aHospID)
	//Quit return
	
	Set objPathForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(aPathFormID)
	Quit:'$IsObject(objPathForm) -1
	Set ExamType=$s(objPathForm.FormVersion=1:"N",1:"M")
	
	Set $ZT="CommitPubApplyError"
	TStart

	Set InputStr="^"_aPathFormID_"^"_ExamType_"^-1^"_aLocID_"^"_aUserID_"^^^^"_aHospID
	Set RecID=##class(DHCMA.CPW.BT.ApplyExamRec).Update(InputStr,"^")
	If +RecID<=0{
		TRollBack
		Quit -2	
	} 
	
	Set PreRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("IdxofFormDr",aPathFormID,RecID),-1)		//获取最新一次申请
	If PreRecID=""{						//从未发送过申请
		Set topPriNo=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,aHospID,""))	//按优先级发送审核申请，此处只发消息给首次审核的角色（优先级最高）		
		Set xRoleID=""
		For {
			Set xRoleID=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,aHospID,topPriNo,xRoleID))
			Quit:xRoleID=""
			
			Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xRoleID)
			Continue:'$IsObject(objRole)
			Continue:objRole.BTIsActive'=1
			//b ;00
			Set retMsg=..SendApplyMsg(aPathFormID,RecID,aUserID,xRoleID,aLocID)
			//b ;01
			If +retMsg<=0{
				TRollBack
				Set return=-3
				Quit	
			}				
		}
		Quit:return<0 return 	
	}Else{							//已发送过申请，再次申请时向同级别下未通过的角色再次发送			
		Set objPreRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(PreRecID)
		If '$IsObject(objPreRec){
			TRollBack
			Quit -4
		}
		
		Set RolePrior=objPreRec.BTRolePrior	
		Set xRoleID=""
		For{
			Set xRoleID=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,aHospID,RolePrior,xRoleID))
			Quit:xRoleID=""
			
			Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xRoleID)
			Continue:'$IsObject(objRole)
			Continue:objRole.BTIsActive'=1			//只检查历次申请中未审核通过的角色

			Set tmpRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",aPathFormID,xRoleID,""),-1)
			Set tmpDtlID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",aPathFormID,xRoleID,tmpRecID,""),-1)
			Set objTmpDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(tmpRecID_"||"_tmpDtlID)
			Continue:objTmpDtl.BTExamResult'=0

			Set retMsg=..SendApplyMsg(aPathFormID,RecID,aUserID,xRoleID,aLocID)
			If +retMsg<=0{
				TRollBack
				Set return=-4
				Quit	
			}	
		}
		Quit:return<0
	}
	Quit:return<0 return
	
	If $TLevel>0 TCommit
	Quit RecID
	
CommitPubApplyError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2021-11-30
/// Description:  发送申请消息
/// Table：       
/// Input：      角色ID,科室ID
/// Return：     符合要求的用户ID串,"^"分隔
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).SendApplyMsg(393,5,"9!!1",1,"320!!1")
ClassMethod SendApplyMsg(aFormID As %String, aApplyRecID As %String, aFromUserID As %String, aToRoleID As %String, aFromLocID As %String) As %String
{
	New (aFormID,aApplyRecID,aFromUserID,aToRoleID,aFromLocID)
	Set return=""
	Quit:(aFormID="")||(aApplyRecID="")||(aFromUserID="")||(aToRoleID="")||(aFromLocID="") return
	
	Set objApplyRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(aApplyRecID)
	Quit:'$IsObject(objApplyRec) -1
	Set ApplyHosp=objApplyRec.BTApplyHosp
	
	Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(aToRoleID)
	Quit:'$IsObject(objRole) -2
	Set RoleType=objRole.BTType			//用户U,安全组G,科室L
	
	Set $ZE="SendApplyMsgError"
	TStart
	
	Set InputDtlStr=aApplyRecID_"^^"_aToRoleID_"^-1^^^^^"_aFormID
	Set RecDtlID=##class(DHCMA.CPW.BT.ApplyExamRecDtl).Update(InputDtlStr,"^")
	If +RecDtlID<=0{
		TRollBack
		Quit -4	
	}
	
	Set IsSendMsg=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWIsSendMsgToChkRole",ApplyHosp)
	If IsSendMsg="Y"{
		Set PriorNo=objRole.BTPriority
		Set aContext="有新发布的临床路径表单，需要您审核，请点击【须处理】进行操作！"
		Set aActTypeCode=1261						//此参数视项目配置值而定
		Set aLnkJson="{""linkParam"":""PathFormID="_aFormID_"&PriorNo="_PriorNo_"&RecDtlID="_RecDtlID_""",""BizObjId"":"""_RecDtlID_"""}"  //,""dialogWidth"":""95%"",""dialogHeight"":""90%""
		If (RoleType="L")||(RoleType="U") {			//科室或用户调用老的消息方法
			If RoleType="L"{						//全科发送
				Set aToUser=""
				Set aToLocRowId=$p(objRole.BTValue,"!!",1)_"|Logon"
			}Else{									//指定用户发送
				Set aToUser=+objRole.BTValue
				Set aToLocRowId=""
			}
			Set return=##class(DHCMA.Util.IO.FromHisSrv).SendMsg(aContext,aActTypeCode,+aFromUserID,"",aToUser,aLnkJson,aToLocRowId)
			If +return<0{
				TRollBack
				Quit -5
			}	
		}Else{
			TRollBack
			Quit -6	
		}	
	}Else{
		Set return=RecDtlID	
	}
	
	
	If $TLevel>0 TCommit
	Quit return
	 
SendApplyMsgError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2021-12-13
/// Description:  消息处置动作
/// Table：       
/// Input：      aFormID:审核表单；aExamDtlID：回复记录；aIsPass：是否通过；aPriorVal：当前角色优先级；aUserID：用户ID；aOptinion：审核意见
/// Return：     
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).HandleFormExamMsg("15","5||2","1","1","9!!1","2")
ClassMethod HandleFormExamMsg(aFormID As %String, aExamDtlID As %String, aIsPass As %String, aPriorVal As %String, aUserID As %String, aOpinion As %String = "") As %String
{
	New (aFormID,aExamDtlID,aIsPass,aPriorVal,aUserID,aOpinion)
	Set return = ""
	Quit:(aIsPass'=1)&&(aIsPass'=0) return
	Quit:(aFormID="")||(aExamDtlID="")||(aPriorVal="")||(aUserID="") return
	
	//Set ^TEMPYK("HandleFormExamMsg")=$LB(aFormID,aExamDtlID,aIsPass,aPriorVal,aUserID,aOpinion)
	
	Set $ZE="HandleFormExamMsgError"
	TStart
	
	Set objExamDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).%OpenId(aExamDtlID)
	Quit:'$IsObject(objExamDtl) -1	
	Set objExamDtl.BTExamResult		= aIsPass
	Set objExamDtl.BTExamOpinion	= aOpinion
	Set objExamDtl.BTExamUser		= aUserID
	Set objExamDtl.BTExamDate		= +$h
	Set objExamDtl.BTExamTime		= $p($h,",",2)
	Set sc=objExamDtl.%Save()
	If $system.Status.IsError(sc) {        //保存出错回滚
   		//Do $system.OBJ.DisplayError(sc) 
   		TRollBack
   		Quit -1
	}
	
	/*
	*处理消息申请结果：
	*1.不管本次是否通过都检查当前申请下各角色审核情况，如都已审且存在不通过则更新本次申请结果为不通过
	*2.若本次回复为通过，则检查本次申请下所有同级别回复
	*（1）同级别下无不通过结果，且无未审核结果，则发送消息到下一级审核，如无下一级直接更新申请最终结果为通过；
	*（2）其他情况无需处理
	*/
	Set ApplyID=objExamDtl.Parref.%Id()
	Set FromLocID=objExamDtl.Parref.BTApplyLoc
	Set ApplyHosp=objExamDtl.Parref.BTApplyHosp
	
	//不管本次是否通过都要检查当前申请下各角色审核情况，及时更新申请结果
	Set retChk=##class(DHCMA.CPW.BTS.ApplyExamRecSrv).ChkEveRoleResult(aFormID)		//检查最新申请下各角色是否都已处理
	If retChk="0^1"{
		Set ret=##class(DHCMA.CPW.BT.ApplyExamRec).SetFinResult(ApplyID,0,aPriorVal)
		If +ret<=0 {        //保存出错回滚
   			TRollBack
   			Quit -2
		}
	}
		
	If aIsPass=1{
		Set xRoleID="",tmpApplyResult=1,tmpIsExistNull=0
		For {
			Set xRoleID=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,ApplyHosp,aPriorVal,xRoleID))
			Quit:xRoleID=""
			
			Continue:objExamDtl.BTExamRoleDr.%Id()=xRoleID
			Set tmpRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",aFormID,xRoleID,""),-1)
			Set tmpDtlID=$o(^DHCMA.CPW.BT.ApplyExamRecI("DTL","IdxofFormRole",aFormID,xRoleID,tmpRecID,""),-1)
			Set objTmpDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(tmpRecID_"||"_tmpDtlID)
			Set:objTmpDtl.BTExamResult=0 tmpApplyResult=0			//同级别下存在未通过结果，申请结果标志置为0
			Set:objTmpDtl.BTExamResult=-1 tmpIsExistNull=1 			//同级别存在未审核结果，为空标志设置为1
		}
		
		If (tmpApplyResult'=0)&&(tmpIsExistNull'=1) {				//不存在未通过结果，也不存在未审核结果，则自动传递消息到下一级，如无下一级则直接更新申请最终结果为通过
			Set nextPriNo=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,ApplyHosp,aPriorVal))
			If nextPriNo=""{
				Set ret=##class(DHCMA.CPW.BT.ApplyExamRec).SetFinResult(ApplyID,1,aPriorVal)
				If +ret<=0 {        	//保存出错回滚
	   				TRollBack
	   				Quit -4
				}
			}Else{
				Set ExamType=objExamDtl.Parref.BTExamType
				Set aFromUser=objExamDtl.Parref.BTApplyUser
				Set xRoleID=""
				For {
					Set xRoleID=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofPriority",1,ApplyHosp,nextPriNo,xRoleID))
					Quit:xRoleID=""
					
					Set objRole=##class(DHCMA.CPW.BT.PathExamRole).GetObjById(xRoleID)
					Continue:'$IsObject(objRole)
					Continue:objRole.BTIsActive'=1
					
					Set retMsg=..SendApplyMsg(aFormID,ApplyID,$p(aFromUser,"!!",1),xRoleID,FromLocID)
					If +retMsg<=0{
						TRollBack
						Set return=-5
						Quit	
					}				
				}
				Quit:+return<0 return	
			}
		}Else{		//其他情况，无需处理
		}
	}	

	//以上操作正常执行后，调用接口进行消息处置操作
	Set return=##class(websys.DHCMessageInterface).Exec("","1261","","",aExamDtlID,$p(aUserID,"!!",1))
	Set:(return=-3)||(return=-102) return = 1			// -3为没有对应消息记录；-102为消息已处理过，此两种情况直接跳过
	If +return<=0{			
		TRollBack
		Quit -6	
	}
	
	If $TLevel>0 TCommit
	Quit return
	
HandleFormExamMsgError
	If $TLevel>0 TRollBack 		//如果存在事务，回滚事务
	Set $ZT="" 					//去除错误方法关联，此句必须写
	Quit "-999"_$ZE 			//返回错误消息
}

/// Creator：     yankai
/// CreatDate：   2021-11-30
/// Description:  获取指定表单最新一次申请的各角色审核意见
/// Table：       
/// Input：       aFormID:表单ID
/// Return：      拼接JSON输出
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetMsgOpinion(4)
ClassMethod GetMsgOpinion(aApplyRecID As %String) As %String
{
	New (aApplyRecID)
	Set return=""
	Quit:aApplyRecID="" return
	
	Set objApplyRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(aApplyRecID)
	Quit:'$IsObject(objApplyRec) return
	
	Set ApplyLoc="",ApplyUser=""
	Set objApplyLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(objApplyRec.BTApplyLoc)
	Set:$IsObject(objApplyLoc) ApplyLoc=objApplyLoc.BTDesc
	Set objApplyUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(objApplyRec.BTApplyUser)
	Set:$IsObject(objApplyUser) ApplyUser=objApplyUser.BTDesc
	
	Set xDtlID="",retJson="["
	For {
		Set xDtlID=$o(^DHCMA.CPW.BT.ApplyExamRecD(aApplyRecID,"DTL",xDtlID))
		Quit:xDtlID=""
		
		Set objDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(aApplyRecID_"||"_xDtlID)
		Continue:'$IsObject(objDtl)
		Set RoleName=objDtl.BTExamRoleDr.BTDesc			//角色描述
		Set ExamUserID=objDtl.BTExamUser
		//Continue:ExamUserID=""
		
		Set UserName="",ExamDate="",ExamTime=""
		Set txtOpinion=objDtl.BTExamOpinion
		Set:txtOpinion'="" txtOpinion=##class(DHCMA.Util.IO.FromHisSrv).ReplaceSpecialChar(txtOpinion)
		Set ExamResult=objDtl.BTExamResult
		Set ExamResultDesc=$case(ExamResult,1:"通过",0:"未通过",-1:"待审核")
		If ExamResult'="-1"{
			Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ExamUserID)
			Set:$IsObject(objUser) UserName=objUser.BTDesc
			Set ExamDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objDtl.BTExamDate)
			Set ExamTime=$zt(objDtl.BTExamTime,1)
		}
		
		Set tmpJson="{""RoleName"":"""_RoleName_""",""UserName"":"""_UserName_""",""txtOpinion"":"""_txtOpinion
		Set tmpJson=tmpJson_""",""ExamDate"":"""_ExamDate_""",""ExamTime"":"""_ExamTime_""",""ExamResult"":"""_ExamResultDesc
		Set tmpJson=tmpJson_""",""ApplyLoc"":"""_ApplyLoc_""",""ApplyUser"":"""_ApplyUser_"""},"
		Set retJson=retJson_tmpJson
	}
	Set:retJson'="[" retJson=$e(retJson,1,$l(retJson)-1)
	Set retJson=retJson_"]"
	Quit retJson
}

/// Creator：     yankai
/// CreatDate：   2022-03-16
/// Description:  根据FormID获取所有申请记录信息,含每次申请时未通过角色回复信息
/// Table：       
/// Input：       aFormID:表单ID
/// Return：      拼接JSON输出
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).GetAllApplyRec(84)
ClassMethod GetAllApplyRec(aFomrID As %String) As %String
{
	New (aFomrID)
	Set return=""
	Quit:aFomrID="" return
	
	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aFomrID)
	Quit:'$IsObject(objForm) return
	Quit:objForm.FormVersion="" return
	Set ApplyType=$s(objForm.FormVersion=1:"N",1:"M")
	
	Set ApplyArr="["												//申请记录数组
	Set xApplyRecID=""
	For {
		Set xApplyRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("IdxofFormDrType",aFomrID,ApplyType,xApplyRecID))
		Quit:xApplyRecID=""
		
		Set objApplyRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(xApplyRecID)
		Continue:'$IsObject(objApplyRec)

		Set isFinPass=$case(objApplyRec.BTExamFinResult,1:"申请通过",0:"申请未通过",-1:"申请中")
		Set (applyUser,applyLoc)=""
		Set objApplyUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(objApplyRec.BTApplyUser)
		Set:$IsObject(objApplyUser) applyUser=objApplyUser.BTDesc
		Set objApplyLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(objApplyRec.BTApplyLoc)
		Set:$IsObject(objApplyLoc) applyLoc=objApplyLoc.BTDesc
		Set ApplyDate=##class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(objApplyRec.BTApplyDate)
		Set ApplyTime=$zt(objApplyRec.BTApplyTime,1)
		
		Set tmpJson="{""RecID"":"""_xApplyRecID_""",""ApplyUser"":"""_applyUser_""",""ApplyLoc"":"""_applyLoc
		Set tmpJson=tmpJson_""",""ApplyDate"":"""_ApplyDate_""",""ApplyTime"":"""_ApplyTime_""",""IsFinPass"":"""_isFinPass_"""},"
		Set ApplyArr=ApplyArr_tmpJson
	}
	
	Set:ApplyArr'="[" ApplyArr=$e(ApplyArr,1,$l(ApplyArr)-1)
	Set ApplyArr=ApplyArr_"]"
	Quit ApplyArr
}

/// Creator:	yankai
/// Description:检查最新一次申请下所有角色审核是否已处理
/// Inputs:		aFormID:表单ID
/// Return:		是否存在未审核（1：是；0：否）^是否存在未通过（1：是；0：否）
/// w ##class(DHCMA.CPW.BTS.ApplyExamRecSrv).ChkEveRoleResult(635)
ClassMethod ChkEveRoleResult(aFormID As %String) As %String
{
	New (aFormID)
	Set return=""
	Quit:aFormID="" return
	
	Set objForm = ##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(objForm) -1
	Quit:objForm.FormVersion="" -2
	
	Set isExistNoExam=0			//0：所有角色都已审核；1：存在角色未审核
	Set isExistNoPass=0			//0：所有角色都通过；1：存在角色未通过
	Set ApplyRecID=$o(^DHCMA.CPW.BT.ApplyExamRecI("IdxofFormDr",aFormID,""),-1)		//取最新一次申请记录
	If ApplyRecID=""{			//没有申请过
		Set return=-3
	}Else{
		Set objApplyRec=##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(ApplyRecID)
		Quit:'$IsObject(objApplyRec) -4
		
		Set xDtlID=""
		For {
			Set xDtlID=$o(^DHCMA.CPW.BT.ApplyExamRecD(ApplyRecID,"DTL",xDtlID))
			Quit:xDtlID=""
			
			Set objDtl=##class(DHCMA.CPW.BT.ApplyExamRecDtl).GetObjById(ApplyRecID_"||"_xDtlID)
			Continue:'$IsObject(objDtl)
			Set ExamResult=objDtl.BTExamResult
			Set:ExamResult=-1 isExistNoExam=1
			Set:ExamResult=0 isExistNoPass=1
		}
		Set return=isExistNoExam_"^"_isExistNoPass
	}
	
	Quit return
}

}
