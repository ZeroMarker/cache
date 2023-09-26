Class EMRservice.BL.BLPrivAssist Extends (%RegisteredObject, %XML.Adaptor)
{

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId,SSGRP_Desc,HosID:%String,HosName:%String", SELECTMODE = "RUNTIME") [ SqlName = GetAllSSGroup, SqlProc ]
{
	select g.SSGRP_RowId,g.SSGRP_Desc,h.HOSP_RowId,h.HOSP_Desc from SQLUser.SS_Group g left JOIN SQLUser.ss_grouphospitals gh ON g.SSGRP_RowId =gh.HOSP_ParRef 
	left JOIN SQLUser.CT_Hospital h ON gh.HOSP_Hospital_DR = h.HOSP_RowId
	order by SSGRP_Desc
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId,SSGRP_Desc,HosID:%String,HosName:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSSGroupByName, SqlProc ]
{
	select g.SSGRP_RowId,g.SSGRP_Desc,h.HOSP_RowId,h.HOSP_Desc from SQLUser.SS_Group g left JOIN SQLUser.ss_grouphospitals gh ON g.SSGRP_RowId =gh.HOSP_ParRef 
	left JOIN SQLUser.CT_Hospital h ON gh.HOSP_Hospital_DR = h.HOSP_RowId where g.SSGRP_Desc like :argGroupName
}

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:
/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLocID-用户所在科室,
/// 	  ArgDocID-PrintDocID,打印模板ID
/// Output:
/// Return:返回一个字符串,格式如:set browse=1,print=1
/// Others:此方法已经移植到EMRservice.Ajax.Appoint.cls或者EMRservice.Ajax.AuthAppoint.cls中  add by 牛才才 2017-11-30
ClassMethod GetAllActiveAppoint(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, ArgDocID As %String) As %String
{
	s ArgCateCharpterID=##class(EMRservice.BL.BLPrivAssist).GetParentIDByDocID(ArgDocID)
	
	s returnStr=""
	s RowID=""
	for {
		s RowID = $o(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeID, RowID))
		q:(RowID="")
		
		s flag = ..CheckAppointIsActive(RowID)
		continue:(flag="0")
		
		s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(RowID)
		if (appoint.AppointType="0")
		{	continue:(appoint.RequestUserID'=AUserID)}
		elseif (appoint.AppointType="1")
		{	continue:(appoint.RequestDept'=AUserLocID)}
		else
		{	continue}
		
		continue:($find("^"_appoint.AppointCateCharpter_"^","^"_ArgCateCharpterID_"^")=0)
		
		if (returnStr="")
		{
			s returnStr = "s "_appoint.EPRAction_"=1"
		}
		else
		{
			s returnStr = returnStr_","_appoint.EPRAction_"=1"
		}
	}
	
	q returnStr
}

/// CreateTime: 2009-09-21
/// CreateUser: gaojb
/// Desc: 根据节点ID取父节点ID
/// Input: parDocID：节点Id
/// Return：父节点ID，如果没有父节点或者参数错误等返回空串
ClassMethod GetParentIDByDocID(parDocID As %String) As %String
{
	q:(($d(parDocID)=0)||(parDocID="")) ""
	
	s instance=""
	s instance=##class(EMRmeta.TemplateCategory).%OpenId(parDocID)
	q:(instance="") ""
	
	s result=instance.ParentID
	d instance.%Close()
	s instance=""
	
	///如果是最上一层节点，会返回0，这里也转为空串处理
	q:(result=0) ""	
	q result
}

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:根据EpisodeID取出所有有效的授权(查看是否已授权,及授权是否有效)
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others:
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint = "") "0"
	
	///授权日期或者授权时间为空,即没有授权
	q:(appoint.AppointDate = "" || appoint.AppointTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(appoint.AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(appoint.AppointEndDate=date)&&(appoint.AppointEndTime<time) "0"
	
	q "1"
}

}
