Class EPRservice.Quality.SetDepDisFlag Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	s SignUserID = $Get(%request.Data("SignUserID",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	s SSGroupID = $Get(%request.Data("SSGroupID",1),"")
	s action = $Get(%request.Data("action",1),"")
	s Ip = $Get(%request.Data("Ip",1),"")
	s InstanceIDs=$Get(%request.Data("InstanceIDs",1),"")
	s:(Action="SetPassFlag") ret = ..SetDepDisPassFlag(EpisodeID,SignUserID,action)
	s:(Action="SetPassFlagDetail") ret = ..SetDepDisPassFlagWithMesReturn(EpisodeID,SignUserID,action)
	s:(Action="CancelDoctor") ret = ..SetBackToDoctorFlag(EpisodeID,SignUserID,action,Ip,InstanceIDs)
	s:(Action="CancelNurse") ret = ..SetBackToNurseFlag(EpisodeID)
	s:(Action = "GetMDScore") ret=..GetMDQualityScore(EpisodeID,action)
    s:(Action = "SetReceiptFlag") ret=..SetDepDisReceiptFlag(EpisodeID,SignUserID,action)
	w ret
	
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取科室终末质控分数
/// Input:			就诊号 
/// Output          分数
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).GetMDQualityScore(284)
ClassMethod GetMDQualityScore(AEpisodeID As %String, Action As %String, ARuleIDs As %String = "1") As %String
{
	q:(AEpisodeID="") 0
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
	s sc= result.Execute(AEpisodeID,ARuleIDs,Action)
	While (result.Next())
	    {
	    s FinalGrade=result.Data("FinalGrade")
	    s FinalScore=result.Data("FinalScore")
	    }
	q FinalScore
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			审核通过（分数不过不可，医生未提交不可，若无纸化则科室通过才能院级通过）
/// Input:			就诊号  操作者id
/// Output          1 成功  -1 失败  DocErr 医生未提交通过失败  ScoreErr  分数不达标通过失败
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).SetDepDisPassFlag(16,9,"D")
ClassMethod SetDepDisPassFlag(AEpisodeIDs As %String, AOPUserID As %String, Action As %String) As %String
{
	s ret = -1
	q:(AEpisodeIDs = "")||(AOPUserID = "") ret
	
	s IsPDFView =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("IsPDFView")
	s IsPaperless=$e(IsPDFView,1,1)
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	
	s flag = 1
	
	TStart
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		s err=##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus(EpisodeID)
		if (err'="1")
		{
			s flag=2
			q	
		}
		//本阶段已经审核通过，则不允许再进行操作（通过、退回）
		s IsPsaaflag=..GetDisCheckView(EpisodeID,Action)
		if (IsPsaaflag="Y")
		{
			s flag=6
			q	
		}
		//如果无纸化则科室终末通过才能院级终末通过
		s IsDepflag="Y"
		S:(Action="D")&&(IsPaperless="Y") IsDepflag=..GetDisCheckView(EpisodeID,"MD")
		if (IsDepflag'="Y")
		{
			s flag=5
			q
		}
		s IsSendMes=0
		s RowID = ""
		for {
			s RowID = $o(^DHCEPRQ.EPRSingleMessageI("IdxEpisodeID"," "_EpisodeID,RowID),-1)
			q:RowID=""
			s msgObj = ##class(EPRinstance.EPRSingleMessage).%OpenId(RowID)
			s MessageTitle=msgObj.MessageTitle
			s:(Action="MD") Title="科室终末质控消息"
			s:(Action="D") Title="终末质控消息"
			continue:(MessageTitle'=Title)
			s ResultDetailID=msgObj.ResultDetailID
			continue:($d(^DHCEPRQ.QualityResultD($p(ResultDetailID,"||",1),"Details",$p(ResultDetailID,"||",2)))=0)
			s IsSendMes=1
			s ConfirmFlag = msgObj.ConfirmFlag
			s:(ConfirmFlag="U") flag=4
			q:(flag=4)
		}
		q:(flag=4)
		
		s Scoreerr=..GetMDQualityScore(EpisodeID,Action)
		
		if ((Scoreerr<"90")&&(IsSendMes=0))
		{
			s flag=3
			q	
		}
		s flag=..InsertDisCheck(EpisodeID,Action,AOPUserID,"Y")
	}
	
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	elseif (flag=2)
	{
		s ret="DocErr"
		TRollBack	
	}
	elseif (flag=3)
	{
		s ret="ScoreErr"
		TRollBack	
	}elseif (flag=4)
	{
		s ret="MesErr"
		TRollBack	
	}elseif (flag=5)
	{
		s ret="DepErr"
		TRollBack	
	}elseif (flag=6)
	{
		s ret="PassErr"
		TRollBack	
	}
	else
	{
		TRollBack	
	}
	if (ret=1)
	{
	  d ##class(EPRservice.Quality.SetDepDisFlag).UpdateSystemStatus(AEpisodeIDs,AOPUserID,"SetPassFlag",Action)
	}
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			审核通过（分数不过不可，医生未提交不可，若无纸化则科室通过才能院级通过）
/// Input:			就诊号  操作者id
/// Output          失败：-1  成功：因闭环未通过的具体消息内容
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).SetDepDisPassFlagWithMesReturn(284,10209,"D")
ClassMethod SetDepDisPassFlagWithMesReturn(AEpisodeIDs As %String, AOPUserID As %String, Action As %String) As %String
{
	s ret = -1
	q:(AEpisodeIDs = "")||(AOPUserID = "")||(Action = "") ret
	
	//不是消息闭环原因直接返回，消息闭环的返回具体情况
	s DepDisPass=##class(EPRservice.Quality.SetDepDisFlag).SetDepDisPassFlag(AEpisodeIDs,AOPUserID,Action)
	q:(DepDisPass'="MesErr") DepDisPass
	s ErrInfo=""

	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		
		s MesInfo=""
		s mCurrRow = $g(^PAADM(EpisodeID))
		s PAPMIDR = $p($g(mCurrRow),"^",1)
		s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage:GetMessagesByEpisodeID")
		s sc= result.Execute(EpisodeID)
		While (result.Next())
	    {
		    s ExecuteStatus=result.Data("ExecuteStatus")
		    s ConfirmStatus=result.Data("ConfirmStatus")
		    continue:(ExecuteStatus="已执行")&&(ConfirmStatus="已确认")
		    s ReceiverUser=result.Data("ReceiverUserDesc")
		    s MessageBody=result.Data("MessageBody")
		    //s MesInfo=MesInfo_"责任人："_ReceiverUser_"；消息："_MessageBody_"；状态："_ExecuteStatus_ConfirmStatus_"<br>"
		    s MesInfo=MesInfo_ReceiverUser_"--"_MessageBody_"--"_ExecuteStatus_ConfirmStatus_"&"
		    
	    }

	    s:(MesInfo'="") ErrInfo=ErrInfo_"【患者"_PAPMIName_"消息未走完闭环流程】"_"&"_MesInfo

	}
	
	q ErrInfo
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			医生退回（医生状态未提交不让退，提交撤销病历完成并科室置标志位退回）
/// Input:			就诊号  操作者id
/// Output          1 成功  -1 失败  DocErr 医生未提交退回失败  
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).SetBackToDoctorFlag("284^360",9)
ClassMethod SetBackToDoctorFlag(AEpisodeIDs As %String, AOPUserID As %String, Action As %String, Ip As %String, InstanceIDs As %String) As %String
{
	s ret = -1
	q:(AEpisodeIDs = "")||(AOPUserID = "") ret
	s IsPDFView =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("IsPDFView")
	s IsPaperless=$e(IsPDFView,1,1)
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	
	s flag = -1,ErrDesc=""
	
	TStart
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		s err=##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus(EpisodeID)
		if (err'="1")
		{
			s flag = 2
			q	
		}
		//本阶段已经审核通过，则不允许再进行操作（通过、退回）
		s IsPsaaflag=..GetDisCheckView(EpisodeID,Action)
		if (IsPsaaflag="Y")
		{
			s flag=4
			q	
		}
		//s flag=##Class(EMRservice.InterfaceService.AdmRecordStatus).RevokeAdmRecordStatus(EpisodeID,AOPUserID)  
		//新接口：病历组更新接口，增加退回原因和ip等
		s:(Action="MD") Reason="科室终末质控未通过"
		s:(Action="D") Reason="院级终末质控未通过"
		s:(Action="MD") Source="QualityDepartment"
		s:(Action="D") Source="QualityHospital"
		s flag=##Class(EMRservice.InterfaceService.AdmRecordStatus).RevokeAdmRecordStatus(EpisodeID,AOPUserID,Ip,Source,Reason)  
		s:(flag'="1") ErrDesc=flag		
		q:(flag'="1")
		
		//病案组：已回收科室质控不可退
		s WMRStatusinfo=##class(DHCEPRFS.BL.HISInfo.BLWMRInfo).GetMrStatusString(EpisodeID)
		s:(Action="MD")&&(WMRStatusinfo["病案回收") flag=3
		q:(flag=3)
		
		//病案组：院级终末质控点击医生退回后是否取消回收状态
		s CancelRecovery =##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("CancelRecovery")
		if (CancelRecovery="Y")
		{
			s IPMRcancelInfo=##class(MA.IPMR.IO.OutService).cancelRetrieve(EpisodeID,AOPUserID,"院级终末质控退回",.ErrMsg)
			s:($p(IPMRcancelInfo,"^",1)'=1) flag=5
			q:(flag'="1") 
		}
		
		s flag=..InsertDisCheck(EpisodeID,Action,AOPUserID,"B",InstanceIDs)
		q:(flag'="1") 

		s:(Action="D")&&(IsPaperless="Y") flag=..InsertDisCheck(EpisodeID,"MD",AOPUserID,"B")
		q:(flag'="1")  
	}
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	elseif (flag=2)
	{
		s ret="DocErr"
		TRollBack	
	}
	elseif (flag=3)
	{
		s ret="WMRErr"
		TRollBack	
	}elseif (flag=4)
	{
		s ret="PassErr"
		TRollBack	
	}elseif (flag=5)
	{
		s ret="CancelRecoveryErr"
		TRollBack	
	}
	else
	{
		s ret=ErrDesc
		TRollBack	
	}
	if (ret=1)
	{
		d ##class(EPRservice.Quality.SetDepDisFlag).UpdateSystemStatus(AEpisodeIDs,AOPUserID,"CancelDoctor",Action)
	}
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			护士退回
/// Input:			就诊号
/// Output          1 成功  0 失败
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).SetBackToNurseFlag(59)
ClassMethod SetBackToNurseFlag(AEpisodeIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeIDs = "") ret
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	s flag=1
	TStart
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		s rowid=$o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_EpisodeID,""))
		s:(rowid="") flag=-2
		q:(rowid="")
		
		s objN=##Class(DHCEPRFS.INST.AdmMRStatus).%OpenId(rowid)
		s objN.FlagFinalAccount=0
		s sc = objN.%Save()
		if ('$$$ISOK(sc))
		{
			s flag = -1
			q	
		}
	}
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	else
	{
		TRollBack	
	}
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			终末质控签收病历
/// Input:			就诊号  操作者id
/// Output          1 成功  -1 失败  DocErr 医生未提交  ReciErr 目前状态即签收
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).SetDepDisReceiptFlag(16,9,"D")
ClassMethod SetDepDisReceiptFlag(AEpisodeIDs As %String, AOPUserID As %String, Action As %String) As %String
{
	s ret = -1
	q:(AEpisodeIDs = "")||(AOPUserID = "") ret
	
	s IsPDFView = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("IsPDFView")
	s IsPaperless=$e(IsPDFView,1,1)
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	s flag = 1
	TStart
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		//获取病历是否全部完成
		s err=##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus(EpisodeID)
		if (err'="1")
		{
			s flag=2
			q	
		}
		
		s IsDepflag="Y"
		S:(Action="D")&&(IsPaperless="Y") IsDepflag=..GetDisCheck(EpisodeID,"MD")
		if (IsDepflag'="Y")
		{
			s flag=4
			q
		}
		//获取科室终末质控签收状态
		s:(Action="MD") err=..GetDepDisReciveState(EpisodeID)
		//获取终末质控签收状态
		S:(Action="D") err=..GetDisReciveState(EpisodeID)
		if (err="1")
		{
			s flag=3
			q	
		}
		//退回表增加数据
		s flag=..InsertDisCheck(EpisodeID,Action,AOPUserID,"R")
	}
	
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	elseif (flag=2)
	{
		s ret="DocErr"
		TRollBack	
	}elseif (flag=3)
	{
		s ret="ReciErr"
		TRollBack	
	}elseif (flag=4)
	{
		s ret="DepErr"
		TRollBack	
	}
	else
	{
		TRollBack	
	}
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取科室审核状态
/// Input:			就诊号
/// Output          No 未审核  Pass 审核通过  Back  退回
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).DepDisCheckState(就诊号)
ClassMethod DepDisCheckState(AEpisodID As %String) As %String
{
	s ret="No"
	q:(AEpisodID="") ret
	s pass=..GetDisCheck(AEpisodID,"MD")
	s:(pass="Y") ret="Pass"	
	s:(pass="B") ret="Back"
	//s:(pass="R") ret="Receipt"
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取科室终末质控签收状态
/// Input:			就诊号
/// Output          0 未签收  1 已签收
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).GetDepDisReciveState(284)
ClassMethod GetDepDisReciveState(AEpisodID As %String) As %String
{
	s ret=0
	q:(AEpisodID="") ret
	s pass=..GetDisCheck(AEpisodID,"MD")
	s:((pass="R")||(pass="Y")) ret=1

	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取终末质控签收状态
/// Input:			就诊号
/// Output          0 未签收  1 已签收
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).GetDisReciveState(EpisodID)
ClassMethod GetDisReciveState(AEpisodID As %String) As %String
{
	s ret=0
	q:(AEpisodID="") ret
	s pass=..GetDisCheck(AEpisodID,"D")
	s:((pass="R")||(pass="Y")) ret=1

	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			科室终末质控标志置退回
/// Input:			就诊号  操作人id
/// Output:		   	1 成功  -1 不成功
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).CancelDepFlag(1,1)
ClassMethod CancelDepFlag(EpisodeID As %String, UserID As %String)
{
	s ret=-1
	q:(EpisodeID="")||(UserID="") ret
	s ret=..InsertDisCheck(EpisodeID,"MD",UserID,"B")
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			退回表增加数据
/// Input:			就诊号  操作人id
/// Output:		   	1 成功  -1 不成功
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).CancelDepFlag(EpisodeID,UserID)
ClassMethod InsertDisCheck(EpisodeID As %String, Action As %String, UserID As %String, IsPass As %String, Resume As %String = "")
{
	s ret=-1
	s objDepDisCheck = ##Class(EPRinstance.Quality.QualityDepDisCheck).%New()
	s objDepDisCheck.EpisodeID = EpisodeID
	s objDepDisCheck.Action=Action
	s objDepDisCheck.IsPass=IsPass
	s objDepDisCheck.CreateUser=UserID
	s objDepDisCheck.CreateDate=$p($h,",",1)
	s objDepDisCheck.CreateTime=$p($h,",",2)
	if (Resume'="")
	{
		s stream = ##class(%GlobalBinaryStream).%New()
		d stream.Write(Resume)
		d objDepDisCheck.Resume.CopyFrom(stream)
	}
	s sc = objDepDisCheck.%Save()	
	if ($$$ISOK(sc))
	{
		s ret=1
	}
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			查询数据
/// Input:			就诊号  操作人id
/// Output:		   	"" 无操作 B退回 Y通过 R签收
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).GetDisCheck(59,"D")
ClassMethod GetDisCheck(EpisodeID As %String, Action As %String)
{
	s ret=""
	q:(EpisodeID="") ret
	
	s RowID = $o(^DHCEPRQ.QualityDepDisCheckI("IdxEpisodeIDAction"," "_EpisodeID," "_Action,""),-1)
	q:(RowID="") ret
	s objDepDisCheck = ##Class(EPRinstance.Quality.QualityDepDisCheck).%OpenId(RowID)
	s ret=objDepDisCheck.IsPass
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			显示质控状态 签收不算
/// Input:			就诊号  操作人id
/// Output:		   	"" 无操作 B退回 Y通过 
/// ##class(EPRservice.Quality.SetDepDisFlag).GetDisCheckView(293223,"MD")
ClassMethod GetDisCheckView(EpisodeID As %String, Action As %String)
{
	s ret=""
	q:(EpisodeID="") ret
	s RowID=""
	for {
		s RowID = $o(^DHCEPRQ.QualityDepDisCheckI("IdxEpisodeIDAction"," "_EpisodeID," "_Action,RowID),-1)
		q:(RowID="") 
		s objDepDisCheck = ##Class(EPRinstance.Quality.QualityDepDisCheck).%OpenId(RowID)
		s IsPass=objDepDisCheck.IsPass
		continue:(IsPass="R")
		s ret=IsPass
		q
	}
	q ret
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取instanceid
/// Input:			就诊号  Docid
/// Output:		   	instanceid
/// UpDate:		如果为多个DocID，以"^"隔开
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).GetInstanceDataId(139,640)
ClassMethod GetInstanceDataId(AEpisodeID As %String, ChartItemIDs As %String)
{
	s ret=""
	
	for i=1:1:$l(ChartItemIDs,"^")
	{
		s CurChartItemIDs = $p(ChartItemIDs,"^",i)
		s TheECRecord=""
		for 
		{
			 s TheECRecord=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,CurChartItemIDs,TheECRecord))
		
			q:(TheECRecord="")
			
			s id=$o(^DHCEMRI.InstanceDataI("IdxECRecord",TheECRecord,""),-1)
			
			s:($lg(^DHCEMRI.ECRecordD(TheECRecord,"Instances",id),14)="Save") ret=TheECRecord_"||"_id
		
			q:ret'=""
			
		}
		
		q:ret'=""
	}
	q ret
}

/// Creator:	    HKY
/// Create Date:	2021-02026
/// Desc:			将科室质控通过、科室质控退回、终末质控退回、终末质控通过状态写入信息平台
/// Input:			AEpisodeIDs：就诊号，AOPUserID：操作用户ID，AActionFlag：操作名称，Action:(终末质控/科室质控)
/// Output:		   	instanceid
/// Debug: ##class(EPRservice.Quality.SetDepDisFlag).UpdateSystemStatus(360,52)
ClassMethod UpdateSystemStatus(AEpisodeIDs As %String, AOPUserID As %String, AActionFlag As %String, Action As %String)
{
	
	s ret=0
	q:(AEpisodeIDs="")||(AOPUserID="")||(AActionFlag)||(Action) ret
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		//科室质控
		if (AActionFlag="SetPassFlag")&&(Action="MD")
		{
		 if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		 {
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s JsonString="[{""OEOrdItemID"":"""_EpisodeID_""","
				s JsonString=JsonString_"""Status"":""DEPQC"","
				s JsonString=JsonString_"""UserID"":"""_AOPUserID_""","
				s JsonString=JsonString_"""UserName"":"""_$p($g(^SSU("SSUSR",AOPUserID)),"^",2)_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream = ##class(%GlobalCharacterStream).%New()
				d objStream.Write(JsonString)
				
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		 }
		}
		//终末质控
		elseif (AActionFlag="SetPassFlag")&&(Action="D")
		{
		 if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		 {
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s JsonString="[{""OEOrdItemID"":"""_EpisodeID_""","
				s JsonString=JsonString_"""Status"":""FQC"","
				s JsonString=JsonString_"""UserID"":"""_AOPUserID_""","
				s JsonString=JsonString_"""UserName"":"""_$p($g(^SSU("SSUSR",AOPUserID)),"^",2)_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream = ##class(%GlobalCharacterStream).%New()
				d objStream.Write(JsonString)
				
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		  }
		}
		//科室退回
		elseif (AActionFlag="CancelDoctor")&&(Action="MD")
		{
		 if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		 {
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s JsonString="[{""OEOrdItemID"":"""_EpisodeID_""","
				s JsonString=JsonString_"""Status"":""DEPRE"","
				s JsonString=JsonString_"""UserID"":"""_AOPUserID_""","
				s JsonString=JsonString_"""UserName"":"""_$p($g(^SSU("SSUSR",AOPUserID)),"^",2)_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream = ##class(%GlobalCharacterStream).%New()
				d objStream.Write(JsonString)
				
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		 }
		}
		//终末退回
		elseif (AActionFlag="CancelDoctor")&&(Action="D")
		{
		 if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCENS.EnsHISService") '= "0")
		 {
			if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCENS.EnsHISService||DHCHisInterface") '= "0")
			{
				s JsonString="[{""OEOrdItemID"":"""_EpisodeID_""","
				s JsonString=JsonString_"""Status"":""FRE"","
				s JsonString=JsonString_"""UserID"":"""_AOPUserID_""","
				s JsonString=JsonString_"""UserName"":"""_$p($g(^SSU("SSUSR",AOPUserID)),"^",2)_""","
				s JsonString=JsonString_"""UpDateTime"":"""_$zdt($h,3,1)_""","
				s JsonString=JsonString_"""SourceSystem"":""EMR""}]"
				
				s objStream=##class(%GlobalCharacterStream).%New()
                d objStream.Write(JsonString)
                
				d ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",objStream)
			}
		 }
		}
	}
	s ret=1
	q ret
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.SetDepDisFlag","GetDepDisList","49")
Query GetDepDisList(AEpisodeID As %String) As %Query(ROWSPEC = "Action,IsPass,CreateUserName,CreateDate")
{
}

ClassMethod GetDepDisListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	k ^CacheTemp("EMRQuality","DisLog",repid)
	s rowId=""
	for{
	s rowId = $o(^DHCEPRQ.QualityDepDisCheckI("IdxEpisodeID"," "_AEpisodeID,rowId),-1)
	q:(rowId="")
	s DepDisObj=##class(EPRinstance.Quality.QualityDepDisCheck).%OpenId(rowId)
	s CreateUser=DepDisObj.CreateUser
	s CreateUserName=$p($g(^SSU("SSUSR",CreateUser)),"^",2)
	s CreateDate=DepDisObj.CreateDate
	s CreateTime=DepDisObj.CreateTime
	s CreateDateFormat=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",CreateDate)
	s CreateTimeFormat=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",CreateTime)
	s CreateDateTime=CreateDateFormat_" "_CreateTimeFormat
	s Action=DepDisObj.Action
	s:(Action="MD") Action="科室终末质控"
	s:(Action="D") Action="院级终末质控"		
	S IsPass=DepDisObj.IsPass
	continue:(IsPass="R")
	s:(IsPass="Y") IsPass="通过"
	s:(IsPass="B") IsPass="退回"
	
	s ^CacheTemp("EMRQuality","DisLog",repid,CreateDate,CreateTime)=$lb(Action,IsPass,CreateUserName,CreateDateTime)
	}

	//病历提交信息记录
	s SubmitLogDatas=..GetLogData(AEpisodeID)
	for i=1:1:$l(SubmitLogDatas,"|")
	{
		s SubmitLogData=$p(SubmitLogDatas,"|",i)
		continue:SubmitLogData=""
		s LogData=$p(SubmitLogData,"^",1)
		s LogTime=$p(SubmitLogData,"^",2)
	    s LogUser=$p(SubmitLogData,"^",3)
		s LogDataFormat = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",LogData)
	 	s LogTimeFormat = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",LogTime)
	
		
		s ^CacheTemp("EMRQuality","DisLog",repid,LogData,LogTime)=$lb("电子病历","提交",LogUser,LogDataFormat_" "_LogTimeFormat)
	}
  
	// 排序
	s data = ""
	for {
		s data = $o(^CacheTemp("EMRQuality","DisLog",repid,data))
		q:(data = "")
					
		s time = ""
		for {
			s time = $o(^CacheTemp("EMRQuality","DisLog",repid,data,time))
			q:(time = "")	
		
			s Data = $g(^CacheTemp("EMRQuality","DisLog",repid,data,time))					
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
			
		}
	}
	k ^CacheTemp("EMRQuality","DisLog",repid)	
	Quit $$$OK
}

ClassMethod GetDepDisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDisListExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepDisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDisListExecute ]
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

ClassMethod GetLogData(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,""))	
    q:(AdmRecordStatusID = "") result    
    s logID = ""
    for
    {
    	s logID = $o(^DHCEMRI.AdmRecordStatusLogI("IdxRecordStatusID"," "_AdmRecordStatusID,logID))	    	
    	q:(logID = "")
    	s objLog = ##Class(EMRinstance.AdmRecordStatusLog).%OpenId(logID)    	
	    q:(objLog = "")	    
	    s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(objLog.UserID)	    
	    s actionCode = objLog.Action	   
	    continue:(actionCode'="Confirm")	    
	    //s actionID = $O(^DHCEMRM.ConfirmActionI("IdxActionCode"," "_$zcvt(actionCode,"U"),""))
	    //continue:(actionID = "")	    
	    //s objAction = ##Class(EMRmeta.ConfirmAction).%OpenId(actionID)
	    // continue:(objAction = "")
	    //s action = objAction.ActionName
	   
	     s OperateDate=objLog.OperateDate
	     s OperateTime=objLog.OperateTime
		
		s:(result '= "") result = result_"|"_OperateDate_"^"_OperateTime_"^"_userName
		s:(result="") result = OperateDate_"^"_OperateTime_"^"_userName	
    }
  
	q result
}

/// Creator:	    qy
/// Create Date:	2022
/// Desc:			获取患者目前质控退回授权的病历instanceid
/// Input:			AEpisodeID		就诊号  
/// Output:		   	instanceid1^instanceid2
/// Debug:			s a=##class(EPRservice.Quality.SetDepDisFlag).GetGrantInstanceID(59)
/// 				w a.Read()
ClassMethod GetGrantInstanceID(AEpisodeID As %String)
{
	s ret=""
	q:(AEpisodeID="") ret
	s RowID=""
	for {
		s RowID = $o(^DHCEPRQ.QualityDepDisCheckI("IdxEpisodeID"," "_AEpisodeID,RowID),-1)
		q:(RowID="") 		
		s objDepDisCheck = ##Class(EPRinstance.Quality.QualityDepDisCheck).%OpenId(RowID)
		s IsPass=objDepDisCheck.IsPass
		continue:(IsPass="R")
		s:(IsPass="B") ret=objDepDisCheck.Resume
		q
	}
	q ret
}

}
