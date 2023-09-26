Class DHCEPRFS.BL.BLWaterMarkReplace Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLWaterMarkReplace).GetText("","")
ClassMethod GetText(AMREpisodeID As %String, AMRUserID As %String)
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")	
	s ret = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ViewWaterMarkText")
	
	q:(AMRUserID = "") ret
	
	if (hospitalFlag = "HYDYFY")
	{
		s userName = ..UserName(AMRUserID)
		s nowDateTime = ..NowDateTime()
		s ret = "仅供参考  "_userName_"  "_nowDateTime
	}
	else
	{
		
	}
	q ret
}

/// Desc: 登录用户名
ClassMethod UserName(AMRUserID As %String) As %String
{
	//对三单一致和编目的用户，因为在归档系统中没有维护用户，所以直接传用户名，例如UserName|张三
	s userName = ""
	if ($l(AMRUserID,"|") >1)
	{
		s userName = $p(AMRUserID,"|",2)	
	}
	else
	{
		s obj = ##class(DHCEPRFS.META.QueryUser).%OpenId(AMRUserID)
		if (obj = "")
		{
			s userName = ""	
		}
		else
		{
			s userName = obj.UserName
		}
	}
	q userName
}

/// Desc: 当前日期时间
ClassMethod NowDateTime() As %String
{
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	s dateStr = $zd(date,3)	
	s timeStr = $zt(time,3)
	q dateStr_" "_timeStr
}

/// Desc: 当前日期
ClassMethod NowDate() As %String
{
	s date = $p($h,",",1)
	s dateStr = $zd(date,3)	
	q dateStr
}

}
