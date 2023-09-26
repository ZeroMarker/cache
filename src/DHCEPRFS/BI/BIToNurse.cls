Class DHCEPRFS.BI.BIToNurse Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	注册护士提交完成标识
/// Input:	EpisodeID - 就诊rowid, UserID - 提交用户ID, Flag - 是否欠费
/// Return:	return=1:成功, return<1:失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToNurse).SetFinalAccountFlag("3515837","")
ClassMethod SetFinalAccountFlag(AEpisodeID As %String, AUserID As %String = "", AFlag As %String = "") As %String
{
	s $zt = "OnErrorSet"
	s ret = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegFinalAccountDHC(AEpisodeID,AUserID,AFlag)
	q ret
	
OnErrorSet
	q "-100"
}

/// Desc:	撤销最终结算，回置病历状态
/// Input:	AEpisodeID 		  : 就诊rowid
/// Return:	1 成功, 0 失败, -1 指定就诊不存在
/// Debug:	w ##Class(DHCEPRFS.BI.BIToNurse)CancelFinalAccountFlag("4")
ClassMethod CancelFinalAccountFlag(AEpisodeID As %String, AUserID As %String = "") As %Boolean
{
	s $zt = "OnErrorCanel"
	s isOK = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID, "1", "0", "撤销结算", AUserID)
	q isOK
	
OnErrorCanel
	q "-100"
}

/// Desc:	病历是否都有有效数字签名
/// Input：	AEpisodeID	： 就诊RowID
/// Return:	1 都有数字签名 
///  		0 存在无效数字签名
///  		-100 程序异常码
/// Debug:	w ##Class(DHCEPRFS.BI.BIToNurse).HasValidSignEPR("4")
ClassMethod HasValidSignEPR(AEpisodeID As %String) As %String
{
	s $zt = "OnErrorHasValidSignEPR"
	
	s isValid = ##class(DHCEPRFS.BL.HISInfo.BLEPRInfo).HasValidSign(AEpisodeID)
	q isValid
	
OnErrorHasValidSignEPR
	q "-100"
}

/// Desc:	获取没有数字签名的病历列表
/// Input：	AEpisodeID	：就诊RowID
/// Return：一个%ResultSet，其列定义如下：
/// 		PrintDocID:%String,EPRNum:%String,EPRLogsID:%String,RecordName:%String,RecordStatus:%String,SignStatus:%String,PrintType:%String,HappenDate:%String,HappenTime:%String,RecordTitle:%String
/// 		
/// 		如果程序异常，则返回空值
ClassMethod GetUnvalidSignRecord(AEpisodeID As %String) As %ResultSet
{
	s $zt = "OnErrorGetUnvalid"
	
	s rs = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLEPRInfo:GetUnvalidSignRecord")
	d rs.Execute(AEpisodeID)
	q rs
	
OnErrorGetUnvalid
	q ""
}

/// Desc: 获取医生、护士的提交状态
/// Input: AEpisodeID -- 就诊RowID
/// Return: 1 - 医生、护士至少一个提交，0 - 医生、护士都未提交
/// Debug: w ##class(DHCEPRFS.BI.BIToNurse).GetCommitStatus("581")
ClassMethod GetCommitStatus(AEpisodeID As %String) As %String
{
	s ret  = "0"
	s statusFlag = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	f i=1:1:$l(statusFlag,"^")
	{
		s status = $p(statusFlag,"^",i)
		s:(status = "1") ret = "1"
	}
	q ret
}

/// Desc: 是否允许护士撤销提交, 默认PDF生成后不允许撤销提交
/// Input: EpisodeID - 就诊rowid
/// Return: return=1:允许撤销(未生成), return=0^提交日期:不允许撤销(已生成), return<0:其他
/// Debug: w ##class(DHCEPRFS.BI.BIToNurse).EnableNurseRecall("")
ClassMethod EnableNurseRecall(AEpisodeID As %String) As %String
{
	s ret = "-1"
	q:(AEpisodeID = "") ret
	s ret = "1"
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") ret
	s mrLogID = ##class(DHCEPRFS.BL.BLMRLog).GetMRLogID(mrEpisodeID)
	q:(mrLogID = "") ret
	s mrLogDtlSubID = ""
	s mrLogDtlSubID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",mrLogID," CREATE",mrLogDtlSubID))
	if (mrLogDtlSubID '= "")
	{
		s objMRLogDtl = ##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDtlSubID)
		s actDate = objMRLogDtl.ActDate
		s:(actDate '= "") ret = "0"_"^"_$zd(actDate,3)
	}
	q ret
}

}
