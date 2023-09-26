Class EMRservice.BL.BLSuperDoctor Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取上级医生
/// CreateDate: 2016-9-22
/// Creator:    Candy
/// Debug:      w ##Class(EMRservice.BL.BLSuperDoctor).GetSuperiors(6)
ClassMethod GetSuperiors(ALocID As %String) As %String
{
	s json = ""
	s count = 0
	s rowId = ""
	for
	{
		s rowId = $o(^RB("RES",0,"CTLOC",ALocID,rowId))
		q:(rowId = "")
		s userPvId = $p(^RB("RES",rowId),"^",2)
		continue:(userPvId = "")
		s carprvtpId = $p(^CTPCP(userPvId,1),"^",4)
		s usertype = $p(^CT("CPT",carprvtpId),"^",4)
		continue:(usertype '= "DOCTOR")
		s userId = $o(^SSU("SSUSR",0,"CTPCP",userPvId,""))
		continue:(userId = "")
		s userName = $p(^SSU("SSUSR",userId),"^",2)
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""userId"":"""_userId_""""
		s json = json_",""userName"":"""_userName_"""" 
		s json = json_"}"
		s count = count + 1
	}
	q "["_json_"]"
}

/// Desc:    当前设置上级医师
/// Creator: Candy
/// Input:   AUserID 用户ID
/// Debug:    w ##Class(EMRservice.BL.BLSuperDoctor).GetCurrentSuperior(105,6)
ClassMethod GetCurrentSuperior(AUserID As %String, ALocID As %String) As %String
{
	s result = ""
	q:(AUserID = "")||(ALocID = "") result
	s rowId = $o(^DHCEMRM.SuperDoctorI("IdxUser"," "_AUserID," "_ALocID,""))
	q:(rowId = "") result
	s obj =  ##Class(EMRmeta.SuperDoctor).%OpenId(rowId)
	q:(obj = "") result
	s superiorId = obj.SuperDoctorID
	s superior = $p(^SSU("SSUSR",superiorId),"^",2)
	s result =  superior
	q result
}

/// Desc:       设置上级医师
/// CreateDate: 2016-9-22
/// Creator:    Candy
/// Debug:   w ##Class(EMRservice.BL.BLSuperDoctor).SetSuperDoctor(105,359,6,100)
ClassMethod SetSuperDoctor(AUserID As %String, ASuperiorID As %String, ALocID As %String, ASSgroupID As %String) As %String
{
	s result = ""
	q:(AUserID = "")||(ASuperiorID = "")||(ALocID = "") result
	s rowId = $o(^DHCEMRM.SuperDoctorI("IdxUser"," "_AUserID," "_ALocID,""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.SuperDoctor).%New()
	}
	else
	{
		s obj =  ##Class(EMRmeta.SuperDoctor).%OpenId(rowId)
	}
	s obj.LocID = ALocID
	s obj.SSGroupID = ASSgroupID
	s obj.UserID = AUserID
	s obj.SuperDoctorID = ASuperiorID
	s userPvId = $p(^SSU("SSUSR",AUserID),"^",14)
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	s userlevelNs = $p(^CT("CPT",userCarprvtpId),"^",1)
	//s userlevel = ##Class(EMRservice.BL.BLSignRole).GetSignNameByNSCode(userlevelNs)
	//q:(userlevel = "") result
	s obj.UserLevel = userlevelNs
	s superiorPvId = $p(^SSU("SSUSR",ASuperiorID),"^",14)
	s superiorcarprvtpId = $p(^CTPCP(superiorPvId,1),"^",4)
	s superiorlevelNs = $p(^CT("CPT",superiorcarprvtpId),"^",1)
	//s superiorlevel = ##Class(EMRservice.BL.BLSignRole).GetSignNameByNSCode(superiorlevelNs)
	//q:(superiorlevel = "") result
	s obj.SuperDoctorLevel = superiorlevelNs
	s sc = obj.%Save()
	s result = $case($$$ISOK(sc),1:"1",0:"0")
	q result
}

/// Desc:       检查是否需要设置上级医师
/// Creator:    Candy
/// CreateDate: 2016-9-22
/// Input:      AUserID 用户ID
///             ALocID  科室ID
/// OutPut:     result 0 需要设置,1不需要设置
/// debug:     w ##class(EMRservice.BL.BLSuperDoctor).Check(105,6)
ClassMethod Check(AUserID As %String, ALocID As %String) As %String
{
	s result = "0"
	
	//当用户为主任、副主任医师时不设置
	s userPvId = $p(^SSU("SSUSR",AUserID),"^",14)
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	s userCarprvtpCode = $p(^CT("CPT",userCarprvtpId),"^",1)

	//检查是否需要设置,不在配置范围内不设置
	s tempresult = 0
	s userRoleCode = $o(^DHCEMRM.SignRoleLinkCarPrvTpI("IdxCarPrvTpSignRole", " "_userCarprvtpCode,""))
	s userRoleCode = $tr(userRoleCode," ","")
	s messageScheme = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SendMessage")
	s stream = ##Class(%GlobalCharacterStream).%New()
	d stream.Write(messageScheme)
	s sc =##class(%XML.XPATH.Document).CreateFromStream(stream,.documentList)
	if ($$$ISOK(sc))
	{ 
		s sc = documentList.EvaluateExpression("/event/sign/actions","count(action)",.actionNode)
		q:($$$ISERR(sc)||(actionNode.GetAt(1)="")) result
		s count = actionNode.GetAt(1).Value
		for i=1:1:count
		{
			s sc = documentList.EvaluateExpression("/event/sign/actions/action["_i_"]","text()",.action)
			continue:($$$ISERR(sc)||(action.GetAt(1)=""))
			if (userRoleCode = $zcvt(action.GetAt(1).Value,"U"))
			{
				s tempresult = 1 
				q
			}
		}
	}
	q:(tempresult = 0) "1"
	
	s rowId = $o(^DHCEMRM.SuperDoctorI("IdxUser"," "_AUserID," "_ALocID,""))
	q:(rowId = "") result
	s obj =  ##Class(EMRmeta.SuperDoctor).%OpenId(rowId)
	s superiorId = obj.SuperDoctorID
	s superiorPvId = $p(^SSU("SSUSR",superiorId),"^",14)
	s superLocId = ""
	s flag = 0
	for
	{
		s superLocId = $o(^RB("RES",0,"CTPCP",superiorPvId,superLocId))
		q:(superLocId = "")
		s:(superLocId = ALocID) flag = 1
		q:(flag = 1)
	}
	s:(flag = 1) result = "1"
	q result
}

}
