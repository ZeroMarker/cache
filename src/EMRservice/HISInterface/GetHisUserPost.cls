Class EMRservice.HISInterface.GetHisUserPost Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是此职称
///  Input:      AUserID:用户ID
///  		     AUserPost：职务code
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos("","","")
ClassMethod IsUserPos(AUserID As %String, AUserPost As %String, AUserLoc As %String) As %String
{
	s result = "0"
	q:(AUserID = "")||(AUserPost = "")||(AUserLoc = "") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.HISInterface.GetHisUserPost||"_AUserPost) = "0") result
	s execCode = "result=##class(EMRservice.HISInterface.GetHisUserPost)."_AUserPost_"("""_AUserID_""","""_AUserLoc_""")"
    s @execCode
    s result = @"result" 
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是诊疗组组长
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).GroupLeader("","","")
ClassMethod GroupLeader(AUserID As %String, AUserLoc As %String) As %String
{
	s result = "0"
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是科主任
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).Chairman("","")
ClassMethod Chairman(AUserID As %String, AUserLoc As %String) As %String
{
	s result = "0"
	q:(AUserID = "")||(AUserLoc = "") result
	
	s isExistClass = ##class(%Dictionary.CompiledClass).%ExistsId("web.DHCBL.CT.CTLocDepHeadUser")
	s isExistMethod = ##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCBL.CT.CTLocDepHeadUser||GetDepHeadUser")
	if ((isExistClass = "1")&&(isExistMethod = "1"))
	{
		s ssuserIdList = ##class(web.DHCBL.CT.CTLocDepHeadUser).GetDepHeadUser(AUserLoc)
	    f i=1:1:$l(ssuserIdList,"^")
	    {
	          s:($p(ssuserIdList,"^",i) = AUserID) result = "1"
	          q:(result = "1")
	    }
	}
	else
	{
		s ssuserId = $p(^CTLOC(AUserLoc),"^",54) 
		s:(ssuserId = AUserID) result = "1"
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是质控医生
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).QCDoc("","","")
ClassMethod QCDoc(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是质控护士
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).QCNurse("","","")
ClassMethod QCNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是责任护士
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).ChargeNurse("","","")
ClassMethod ChargeNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是麻醉医师
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).Anesthesiologist("","","")
ClassMethod Anesthesiologist(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是麻醉护士
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).AnesthesiaNurse("","","")
ClassMethod AnesthesiaNurse(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户是否在HIS中是编码员
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).Coder("","","")
ClassMethod Coder(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2022-07-06
///  Desc:       用户是否在HIS中是主诊医师
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     result 1:是/0:不是
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).InCharge("","")
ClassMethod InCharge(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s result = ##Class(EMRservice.BOPrivAssist).UserIsDoc(AUserID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-09-16
///  Desc:       获取用户职务
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     职务代码^职务描述
///  Debug:      w ##Class(EMRservice.HISInterface.GetHisUserPost).GetUserPos("","")
ClassMethod GetUserPos(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	q:((AUserID = "")||(AUserLoc = "")) result
	
	s result = ##Class(EMRservice.BL.BLSignRole).GetDepartmentHead(AUserID,AUserLoc)	
	
	q result
}

}
