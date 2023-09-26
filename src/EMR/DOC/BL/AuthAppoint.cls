/// 名称:	EMR.DOC.BL.AuthAppoint
/// 描述:	病历授权功能
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.AuthAppoint Extends %RegisteredObject
{

/// Table:EPRinstance.EPRActionAppoint
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLocID-用户所在科室,
/// 	  ArgDocID-PrintDocID,打印模板ID
/// Output:
/// Return:返回一个字符串,格式如:set save=1,print=1
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).GetAllActiveAppoint("343","359","6","933||6","")
ClassMethod GetAllActiveAppoint(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AInstanceID As %String, ADocCode As %String) As %String
{
	s returnStr=""
	if (AInstanceID = "")
	{
		s docID = ADocCode
	}
	else
	{
		s docID = AInstanceID
	}
	
	s DetailID=""
	for {
		
		s DetailID = $o(^CF.EMR.DOC.AuthAppointDetailI("IdxEpisodeCharpter"," "_AEpisodeID," "_docID,DetailID))
		q:(DetailID = "")
		
		s DetailObj = ##class(CF.EMR.DOC.AuthAppointDetail).%OpenId(DetailID)
		s AppointID = DetailObj.AppointID
		
		s flag = ..CheckAppointIsActive(AppointID)
		continue:(flag="0")
		
		s AppointObj = ##class(CF.EMR.DOC.AuthAppoint).%OpenId(AppointID)
		if (AppointObj.AppointType="0")
		{	
			continue:(AppointObj.RequestUserID'=AUserID)
		}
		elseif (AppointObj.AppointType="1")
		{	
			continue:(AppointObj.RequestDept'=AUserLocID)
		}
		else
		{	
			continue
		}
		
		//取符合条件的明细中记录的操作权限
		if (DetailObj.DetailStatus = "1")
		{
			if (returnStr="")
			{
				s returnStr = "s "_DetailObj.Action_"=1"
			}
			else
			{
				s returnStr = returnStr_","_DetailObj.Action_"=1"
			}
		}
	}
	
	q returnStr
}

/// Creator:loo
/// CreatDate:2010-09-21
/// Description:根据EpisodeID取出所有有效的授权(查看是否已授权,及授权是否有效)
/// Table:EPRinstance.EPRActionAppoint
/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others: w ##Class(EMRservice.Ajax.AuthAppoint).CheckAppointIsActive("1")
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(CF.EMR.DOC.AuthAppoint).%OpenId(AID)
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
