Class DHCEPRFS.BL.BLPrivilege Extends %RegisteredObject [ ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLPrivilege).CheckPrintPrivilege(6,"","")
ClassMethod CheckPrintPrivilege(AMREpisodeID As %String, AEpisodeID As %String, AQueryUserID As %String = "") As %String
{
	s:(AQueryUserID = $c(0)) AQueryUserID = ""
	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," DHC"," "_AEpisodeID,rowID))
	//已存在
	q:(rowID '= "") "0"
	s ret = "1"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "BJXHYY")
	{
		//若没有病案首页不许打印
		//create
		s retCreateCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "83")
		//scan
		s retScanCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "254")
		
		if ((retCreateCheck = "0") && (retScanCheck = "0"))
		{
			q "0"	
		}
		else
		{
			q "1"
		}
		
		
		//若没有出院记录，产科出院记录，死亡记录，24小时入出院记录，24小时入院死亡记录，不许打印
		//s retCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "84")
		//q:(retCheck = "1") "1"
		//s retCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "87")
		//q:(retCheck = "1") "1"
		//s retCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "85")
		//q:(retCheck = "1") "1"
		//s retCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "90")
		//q:(retCheck = "1") "1"
		//s retCheck = ##class(DHCEPRFS.BL.BLMREpisode).CheckMRItemExist(AMREpisodeID, "91")
		//q:(retCheck = "1") "1"
	}
	elseif (hospitalFlag = "HYDYFY")
	{
		s:(AQueryUserID = $c(0)) AQueryUserID = ""
		if (AQueryUserID '= "")
		{
			//大桥分院仅能打印大桥分院的患者
			
			//获取用户的基角色，是否有大桥院区
			s ret = ##class(DHCEPRFS.BL.BLQueryRoleFunction).IsUserHasBaseRole(AQueryUserID,"AreaDaQiao")
			if (ret = "1")
			{
				//获取就诊号出院科室ID，大桥分院科室ID为1098，还可增加，以^分隔多个科室
				s disLocID = $lg(^DHCEPRFS.INST.MREpisodeD(AMREpisodeID),29)
				if (disLocID = "1098")
				{
					//大桥院区用户仅可打印大桥院区出院患者
					q "1"
				}
				else
				{
					//大桥院区用户不可打印非大桥院区出院患者
					q "0"	
				}
			}
			else
			{
				//不是大桥院区用户可打印全部
				q "1"	
			}
		}
		else
		{
			q "1"	
		}
	}
	elseif (hospitalFlag = "QYFY")
	{
		//是否是历史病案录入的可打印
		if ($e(AEpisodeID,1,2) = "VE")
		{
			q "1"
		}
	
		//是否已归档
		s ret = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMRAchiveStatus(AEpisodeID)
	}
	elseif (hospitalFlag = "DYEY")
	{
		//是否是历史病案录入的可打印
		if ($e(AEpisodeID,1,2) = "VE")
		{
			q "1"
		}
		
		//是否封存
		s retSeal = ##class(DHCWMR.IO.OutService).GetSealStatus(AEpisodeID)
		if (retSeal = "封存病案")
		{
			q "-1"
		}
		else
		{
			//是否最终结算
			s retFinalAccount = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).HasFinalAccount(AEpisodeID)
			if (retFinalAccount = "0")
			{
				q "-2"
			}
			else
			{
				//是否已归档
				s retMRAchive = ##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMRAchiveStatus(AEpisodeID)
				q ret
			}
		}
	}
	elseif (hospitalFlag = "NYFY")	//宁医总院	慈济分院与总院分开
	{
		if (AQueryUserID = "")	//未传入QueryUserID,则默认允许权限
		{
			q "1"	
		}
		s ret = ##class(DHCEPRFS.BL.BLQueryRoleFunction).IsUserHasBaseRole(AQueryUserID,"AreaCiJi")
		//获取就诊号出院科室ID，慈济分院的出院科室为
		s disLocID = $lg(^DHCEPRFS.INST.MREpisodeD(AMREpisodeID),29)
		
		//慈济分院的出院科室
		if ((disLocID = "1218")||(disLocID = "1221")||(disLocID = "1224")||(disLocID = "1227")
			||(disLocID = "1229")||(disLocID = "1232")||(disLocID = "1235")||(disLocID = "1238")
			||(disLocID = "1245")||(disLocID = "1349")||(disLocID = "1392"))
		{
			if (ret="1")	//慈济分院的操作员
			{	q "1"	}
			else			//非慈济分院
			{	q "-1"	}	
		
		}
		else
		{
			if (ret="1")	//慈济分院的操作员
			{	q "-1"	}
			else			//非慈济分院
			{	q "1"	}	
		}
	}
	q ret
}

ClassMethod CheckDocCommitPrivilege(AEpisodeID As %String) As %String
{
	s ret = ..CheckDoc(AEpisodeID)
	if (ret = "1")
	{
		//若未进行最终结算，则不允许医生提交
		s disDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID)
		q:((disDateTime = "") || (disDateTime = $c(0))) "0"
	}
	q ret
}

/// debug: w ##class(DHCEPRFS.BL.BLPrivilege).CheckDoc(15346662)
ClassMethod CheckDoc(AEpisodeID As %String) As %String
{
	//b "s"
	//是否医生已经提交并且提交后没有退回
	//查看医生是否已经提交
	s admMRStatusID = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,admMRStatusID))
	//不存在说明没有提交过，可提交
	q:(admMRStatusID = "") "1"
	//存在，取医生是否提交
	s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
	s flagMRCompletion = objAdmMRStatus.FlagMRCompletion
	if ((flagMRCompletion = "0") || (flagMRCompletion = "") || (flagMRCompletion = $c(0)))
	{
		//医生未提交过，可提交
		q "1"
	}
	
	//医生已提交，检查提交后是否有过退回
	//取退回日志
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "1"
	s mrLogID = $O(^DHCEPRFS.INST.MRLogI("IdxMain"," "_mrEpisodeID,""))	
	q:(mrLogID = "") "1"
	
	s ret = ##class(DHCEPRFS.BL.BLMRLog).CheckTwoAction(mrEpisodeID,"DEPTQCBACK","QCBACK")
	s ret1 = $p(ret,"^",1)
	s ret2 = $p(ret,"^",2)
	s ret3 = $p(ret,"^",3)
	
	//无退回日志，并且已提交，则不可再次提交
	q:((ret1 '= "1") && (ret2 '= "1")) "0"
	
	//科室退回，且病案退回在后
	if ((ret1 = "1") && (ret3 = "1"))
	{
		s mrLogDetailID = ""
		s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," QCBACK",mrLogDetailID),-1)
	}
	else
	{
		//无科室退回
		if (ret1 = "0")
		{
			//是否有病案退回
			if (ret2 = "0")
			{
				q "0"
			}
			else
			{
				s mrLogDetailID = ""
				s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," QCBACK",mrLogDetailID),-1)
			}
		}
		//有科室退回,因为外层if已经过滤了病案退回在后的情况，所以此处表明科室退回后无病案退回
		else
		{
			s mrLogDetailID = ""
			s mrLogDetailID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," DEPTQCBACK",mrLogDetailID),-1)
		}
	}
	
	//存在退回医生日志，取最后一条退出医生的日期时间
	s objMRLogDetail = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailID)
	s qcBackDate = objMRLogDetail.ActDate
	s qcBackTime = objMRLogDetail.ActTime
	
	//医生最后提交的日期时间
	s commitDate = objAdmMRStatus.FlagMRCompletionDate
	s commitTime = objAdmMRStatus.FlagMRCompletionTime
	
	//医生提交日期小于退回日期，说明已退回，可修改
	q:(commitDate < qcBackDate) "1"
	//医生提交日期等于退回日期，医生提交时间小于退回时间，说明已退回，可修改
	q:((commitDate = qcBackDate) && (commitTime < qcBackTime)) "1"
	
	//其他情况均不可修改（医生提交过并且没有被退回医生；或退回过医生，但退回后又已提交）
	q "0"
}

ClassMethod CheckScanPrivilege(AMREpisodeID As %String, AQueryUserID As %String = "") As %String
{
	s:(AQueryUserID = $c(0)) AQueryUserID = ""
	
	s ret = "1"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	
	if (hospitalFlag = "NYFY")	//宁医总院	慈济分院与总院分开
	{
		if (AQueryUserID = "")	//未传入QueryUserID,则默认允许权限
		{
			q "1"	
		}
		s ret = ##class(DHCEPRFS.BL.BLQueryRoleFunction).IsUserHasBaseRole(AQueryUserID,"AreaCiJi")
		//获取就诊号出院科室ID，慈济分院的出院科室为
		s disLocID = $lg(^DHCEPRFS.INST.MREpisodeD(AMREpisodeID),29)
		
		//慈济分院的出院科室
		if ((disLocID = "1218")||(disLocID = "1221")||(disLocID = "1224")||(disLocID = "1227")
			||(disLocID = "1229")||(disLocID = "1232")||(disLocID = "1235")||(disLocID = "1238")
			||(disLocID = "1245")||(disLocID = "1349")||(disLocID = "1392"))
		{
			if (ret="1")	//慈济分院的操作员
			{	q "1"	}
			else			//非慈济分院
			{	q "-1"	}	
		
		}
		else
		{
			if (ret="1")	//慈济分院的操作员
			{	q "-1"	}
			else			//非慈济分院
			{	q "1"	}	
		}
	}
	elseif (hospitalFlag = "SDLKRMYY")
	{
		s episodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(AMREpisodeID)
		if (episodeID '= "")
		{
			s paAdmType = $p($g(^PAADM(episodeID)),"^",2)
			s:(paAdmType '= "I") ret = "-1"
		}
	}
	
	q ret
}

/// Debug: w ##class(DHCEPRFS.BL.BLPrivilege).CheckReviewPassPrivilege(577,159,1)
ClassMethod CheckReviewPassPrivilege(AEpisodeID As %String, AUserID As %String, AActionCode As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s ret = ""
	if (hospitalFlag = "WLDYRM")
	{
		if (AActionCode = "2")
		{
			s qcSignRet = ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).IsClinicFPFQCDocChecked(AEpisodeID)
			if (qcSignRet = "1")
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
			}
			else
			{
				s ret = "-10"
			}
		}
		else
		{
			s reviewMode = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ReviewMode")
			if (reviewMode = "1")
			{
				if (AActionCode = "1")
				{
					s qcStatus = "U"
					s patRowID = ""
					s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
					if (patRowID '= "")
					{
						s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
						s qcStatus = objPat.QCReviewStatus
						d objPat.%Close()
					}
					if (qcStatus '= "F")
					{
						s ret = "-10"
					}
					else
					{
						s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
					}
				}
				else
				{
					s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
				}
			}
			elseif (reviewMode = "2")
			{
				if (AActionCode = "3")
				{
					s mrStatus = "U"
					s patRowID = ""
					s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
					if (patRowID '= "")
					{
						s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
						s mrStatus = objPat.ReviewStatus
						d objPat.%Close()
					}
					if (mrStatus '= "F")
					{
						s ret = "-10"
					}
					else
					{
						s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
					}
				}
				else
				{
					s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
				}
			}
			else
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
			}
		}
	}
	else
	{
		if (AActionCode = "2")
		{
			s admMRStatus = ##Class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
			s docSubmitStatus = $p(admMRStatus,"^",2)
			s nurSubmitStatus = $p(admMRStatus,"^",1)
			if (docSubmitStatus = "1")&&(nurSubmitStatus = "1")
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
			}
			else
			{
				s ret = "-10"
			}
		}
		else
		{
			s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).SaveReviewedStatus(AEpisodeID,AUserID,AActionCode)
		}
	}
	q ret
}

/// Debug: w ##class(DHCEPRFS.BL.BLPrivilege).CheckQCBackPrivilege("577","159","0","1","缺少病历","1")
ClassMethod CheckQCBackPrivilege(AEpisodeID As %String, AUserID As %String, ABack2Nur As %String, ABack2Doc As %String, AReason As %String, AActionCode As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s ret = ""
	if (hospitalFlag = "WLDYRM")
	{
		s reviewMode = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ReviewMode")
		if (reviewMode = "1")
		{
			if (AActionCode = "1")
			{
				s qcStatus = "U"
				s patRowID = ""
				s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
				if (patRowID '= "")
				{
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
					s qcStatus = objPat.QCReviewStatus
					d objPat.%Close()
				}
				if (qcStatus '= "F")
				{
					s ret = "-10"
				}
				else
				{
					s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
				}
			}
			else
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
			}
		}
		elseif (reviewMode = "2")
		{
			if (AActionCode = "3")
			{
				s mrStatus = "U"
				s patRowID = ""
				s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
				if (patRowID '= "")
				{
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
					s mrStatus = objPat.ReviewStatus
					d objPat.%Close()
				}
				if (mrStatus '= "F")
				{
					s ret = "-10"
				}
				else
				{
					s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
				}
			}
			else
			{
				s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
			}
		}
		else
		{
			s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
		}
	}
	else
	{
		s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,ABack2Nur,ABack2Doc,"",AUserID,AReason,AActionCode)
	}
	q ret
}

/// 在扫描环节中判断指定就诊是否能被扫描
/// input:AMREpisodeID 归档就诊号
/// output:0--不能被扫描，1--能被扫描
/// debug:w ##class(DHCEPRFS.BL.BLPrivilege).GetScanSatusByMREpisode()
ClassMethod GetScanSatusByMREpisode(AMREpisodeID As %String) As %String
{
	s flag = "0"
	q:(AMREpisodeID = "") "0"
	s HospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (HospitalFlag ="WLDYRM")
	{
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
		q:(obj = "") "1"
		s episodeID = obj.EpisodeID
		s flag = ##class(DHCEPRFS.BI.BIAdmMRStatus).EnableSubmitByReview(episodeID)
		s rowID = $o(^DHCEPRFS.INST.AuthorizationI("IdxMREpisodeID"," "_AMREpisodeID,""))
		q:(rowID = "") flag
		s obj= ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(rowID)
		if (obj.AppointStatus = "F")
		{
			s flag = "1"
		}
	}
	else
	{
		s flag ="1"
	}
	q flag
}

}
