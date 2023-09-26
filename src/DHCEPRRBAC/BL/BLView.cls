Class DHCEPRRBAC.BL.BLView Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRRBAC.BL.BLView).GetDefaultViewParam("373","1")
ClassMethod GetDefaultViewParam(AEpisodeID As %String, ASSGroupID As %String) As %String
{
	//默认浏览需检查是否已加入敏感病历列表
	s ret = ""
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckAS("DHC",AEpisodeID)
	q:(ret = "1") "-4"
	
	s roleID = ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "QYFY")
	{
		s roleDID = ""
		s roleDID = $o(^DHCEPRRBAC.META.RoleMappingI("IdxMain"," DEPTVIEW",roleDID))
		s roleID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(roleDID)
	}
	else
	{
		s roleDID = ""
		s roleDID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupID"," "_ASSGroupID,roleDID))
		if (roleDID '= "")
		{
			s objRoleD = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(roleDID)
			s roleID = objRoleD.RoleID
			d objRoleD.%Close()
			s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(roleID)
			s roleType = objRole.RoleType
			d objRole.%Close()
			if (roleType '= "FS")
			{
				s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
			}
		}
		else
		{
			s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
		}
	}
	q:(roleID = "") "-3"
	
	s operationID = $o(^DHCEPRRBAC.META.OperDFI("IdxDefaultOp"," Y",""))
	q:(operationID = "") "-3"
	
	s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(operationID)
	s operationCode = opObj.OpCode
	
	s itemIDs = ""
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence))
		q:(sequence = "")
		s itemID = ""
		for {
			s itemID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence,itemID))
			q:(itemID = "")
			
			s rowID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(itemID)
			s objRI = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
			s privacyID = objRI.PrivateDomainID
			s itemDID = objRI.ItemID
			s objID = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemDID)
			s param = objID.ItemCode
			s type = objID.ItemType
			s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(privacyID)
			s privacyLevel = objP.RPDLevel
			
			if (itemIDs = "")
			{
				s itemIDs = privacyLevel_"@"_param_"@"_type
			}
			else
			{
				s itemIDs = itemIDs_"^"_privacyLevel_"@"_param_"@"_type
			}
		}
	}
	
	s ret = AEpisodeID_"|"_operationCode_"|"_itemIDs
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLView).GetViewParam("7615361","39")
ClassMethod GetViewParam(AEpisodeID As %String, AAuthorizationID As %String) As %String
{
	q:((AAuthorizationID = "") || (AAuthorizationID = $c(0))) "-3"
	s obj = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AAuthorizationID)
	s status = obj.AppointStatus
	if (status '= "D")
	{
		//未授权或已拒绝
		q:(status '= "F") "-2"
		
		//检查是否过期
		s endDate = obj.AppointEndDate
		s endTime = obj.AppointEndTime
		
		q:((endDate = "") || (endDate = $c(0))) "-3"
		q:((endTime = "") || (endTime = $c(0))) "-3"
		q:((status = "") || (status = $c(0))) "-3"
		
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		
		///授权截止日期小于当前日期,授权已过期
		q:(endDate<date) "-1"
		
		///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
		q:(endDate=date)&&(endTime<time) "-1"
	}
	
	//有权限获取参数
	s roleID = obj.RoleID
	s operationID = obj.OperationID
	s eprAction = obj.EPRAction
	q:((roleID = "") || (roleID = $c(0))) "-3"
	q:((operationID = "") || (operationID = $c(0))) "-3"
	q:((eprAction = "") || (eprAction = $c(0))) "-3"
	
	s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(operationID)
	s operationCode = opObj.OpCode
	
	s itemIDs = ""
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence))
		q:(sequence = "")
		s itemID = ""
		for {
			s itemID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence,itemID))
			q:(itemID = "")
			
			s rowID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(itemID)
			s objRI = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
			s privacyID = objRI.PrivateDomainID
			s itemDID = objRI.ItemID
			s objID = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemDID)
			s param = objID.ItemCode
			s type = objID.ItemType
			s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(privacyID)
			s privacyLevel = objP.RPDLevel
			
			if ((type = eprAction) || (($e(type,1,2) = eprAction)))
			{
				if (itemIDs = "")
				{
					s itemIDs = privacyLevel_"@"_param_"@"_type
				}
				else
				{
					s itemIDs = itemIDs_"^"_privacyLevel_"@"_param_"@"_type
				}
			}
		}
	}
	
	s ret = AEpisodeID_"|"_eprAction_"|"_operationCode_"|"_itemIDs
	q ret
}

/// debug: w ##class(DHCEPRRBAC.BL.BLView).CheckExpire("1","159")
ClassMethod CheckExpire(AEpisodeID As %String, AUserID As %String, AType As %String)
{
	s flag = "-1"
	s ret = ""
	
	s date = ""
	for {
		s date = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestExpire", " "_AType, " "_AUserID,date),-1)
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestExpire", " "_AType, " "_AUserID,date,time),-1)
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestExpire", " "_AType, " "_AUserID,date,time,rowID))
				q:(rowID = "")
				//因为到期时间从最远到最近，若有一个到期则其之后的所有也肯定到期
				if (AType = "F")
				{
					q:(..CheckAppointIsActive(rowID) = "0")
				}
				
				s detailNum = ""
				for {
					s detailNum = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",rowID,detailNum))
					q:(detailNum = "")
	
					s subID = ""
					for {
						s subID = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",rowID,detailNum,subID))
						q:(subID = "")
						
						s subFullID = rowID_"||"_subID
							
						s obj = ##class(DHCEPRRBAC.INST.FSAuthorization).%OpenId(subFullID)
						s EpisodeID = obj.EpisodeID
						if (EpisodeID = AEpisodeID)
						{
							s flag = "1"
							s ret = subFullID
							q	
						}
					}
					q:(flag = "1")	
				}
				q:(flag = "1")
			}
			q:(flag = "1")
		}
		q:(flag = "1")	
	}
	
	q ret
}

ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	s appoint = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AID)
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

/// Debug: w ##class(DHCEPRRBAC.BL.BLView).GetDefaultViewPermission("373","1")
ClassMethod GetDefaultViewPermission(AEpisodeID As %String, ASSGroupID As %String) As %String
{
	//默认浏览需检查是否已加入敏感病历列表
	s ret = ""
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckAS("DHC",AEpisodeID)
	q:(ret = "1") "-4"
	
	s roleID = ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "QYFY")
	{
		s roleDID = ""
		s roleDID = $o(^DHCEPRRBAC.META.RoleMappingI("IdxMain"," DEPTVIEW",roleDID))
		s roleID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(roleDID)
	}
	else
	{
		s roleDID = ""
		s roleDID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupID"," "_ASSGroupID,roleDID))
		if (roleDID '= "")
		{
			s objRoleD = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(roleDID)
			s roleID = objRoleD.RoleID
			d objRoleD.%Close()
			s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(roleID)
			s roleType = objRole.RoleType
			d objRole.%Close()
			if (roleType '= "FS")
			{
				s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
			}
		}
		else
		{
			s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
		}
	}
	q:(roleID = "") "-3"
	
	s operationID = $o(^DHCEPRRBAC.META.OperDFI("IdxDefaultOp"," Y",""))
	q:(operationID = "") "-3"
	
	s ret = roleID
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLView).GetAuthViewPermission("7615361","39")
ClassMethod GetAuthViewPermission(AEpisodeID As %String, AAuthorizationID As %String) As %String
{
	q:((AAuthorizationID = "") || (AAuthorizationID = $c(0))) "-3"
	s obj = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AAuthorizationID)
	s status = obj.AppointStatus
	if (status '= "D")
	{
		//未授权或已拒绝
		q:(status '= "F") "-2"
		
		//检查是否过期
		s endDate = obj.AppointEndDate
		s endTime = obj.AppointEndTime
		
		q:((endDate = "") || (endDate = $c(0))) "-3"
		q:((endTime = "") || (endTime = $c(0))) "-3"
		q:((status = "") || (status = $c(0))) "-3"
		
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		
		///授权截止日期小于当前日期,授权已过期
		q:(endDate<date) "-1"
		
		///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
		q:(endDate=date)&&(endTime<time) "-1"
	}
	
	//有权限获取参数
	s roleID = obj.RoleID
	s operationID = obj.OperationID
	s eprAction = obj.EPRAction
	q:((roleID = "") || (roleID = $c(0))) "-3"
	q:((operationID = "") || (operationID = $c(0))) "-3"
	q:((eprAction = "") || (eprAction = $c(0))) "-3"
	
	s ret = roleID
	q ret
}

}
