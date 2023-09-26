/// Desc: 		角色签名规则表Bl层 
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRservice.BL.BLRoleSignRuleList Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLRoleSignRuleList).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.RoleSignRuleList).%BuildIndices()
	
	s roleRuleCode = "1"
	s roleRuleName = "SignRoleVerify"
	s roleRuleDesc = "签名医师和标题医师验证"
	s roleRuleValue = ""
	d ..InsertRule(roleRuleCode, roleRuleName, roleRuleDesc, roleRuleValue)
	
	s roleRuleCode = "2"
	s roleRuleName = "SignRoleLoginVerify"
	s roleRuleDesc = "签名医师和登录医师验证"
	s roleRuleValue = ""
	d ..InsertRule(roleRuleCode, roleRuleName, roleRuleDesc, roleRuleValue)
	
	s roleRuleCode = "3"
	s roleRuleName = "NeedDoctorSignBefore"
	s roleRuleDesc = "医护人员签名后，患者才能签名"
	s roleRuleValue = ""
	d ..InsertRule(roleRuleCode, roleRuleName, roleRuleDesc, roleRuleValue)
}

/// Debug: d ##Class(EMRservice.BL.BLRoleSignRuleList).InsertRule("","","","")
ClassMethod InsertRule(ARoleRuleCode As %String, ARoleRuleName As %String, ARoleRuleDesc As %String, ARoleRuleValue As %String) As %String
{
	s id=$O(^DHCEMRM.RoleSignRuleListI("IdxRoleRuleCode"," "_$zcvt(ARoleRuleCode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.RoleSignRuleList).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.RoleSignRuleList).%OpenId(id)
	}
	
	s obj.RoleRuleCode = ARoleRuleCode
	s obj.RoleRuleName = ARoleRuleName
	s obj.RoleRuleDesc = ARoleRuleDesc
	s obj.RoleRuleValue = ARoleRuleValue
	d obj.%Save()
}

/// Creator:	yejian
/// CreatDate:  2019-3-20
/// Desc:		获取角色规则
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLRoleSignRuleList","SelectRoleSignRule")
Query SelectRoleSignRule() As %Query(ROWSPEC = "ID:%Integer,RoleRuleCode:%String,RoleRuleName:%String,RoleRuleDesc:%String,RoleRuleValue:%String")
{
}

ClassMethod SelectRoleSignRuleExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.RoleSignRuleListD(arowID))
		q:(arowID = "")	
		s objRoleRule = ##Class(EMRmeta.RoleSignRuleList).%OpenId(arowID)
		s RoleRuleCode = objRoleRule.RoleRuleCode
		s RoleRuleName = objRoleRule.RoleRuleName
		s RoleRuleDesc = objRoleRule.RoleRuleDesc
		s RoleRuleValue = objRoleRule.RoleRuleValue

		s Data = $lb(arowID,RoleRuleCode,RoleRuleName,RoleRuleDesc,RoleRuleValue)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
		
	}
	q $$$OK
}

ClassMethod SelectRoleSignRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectRoleSignRuleExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectRoleSignRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectRoleSignRuleExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:       判断配置了维护程序签名顺序的模板是否可签名
/// Creator:    Donglulu
/// CreateDate: 2019-3-19
/// Input：     AUserID 签名用户ID  AInstanceID 实例ID ASignLevel 签名级别 ALoginUser登录用户ID
/// Output:     1可签名 0不可签名
/// Debug:      w ##Class(EMRservice.BL.BLRoleSignRuleList).CheckTemplateSign(1647,"157742||63","Resident","1800")
ClassMethod CheckTemplateSign(AUserID As %String, AInstanceID As %String, ASignLevel As %String, ALoginUser As %String) As %String
{
	s result = 1
	q:(AUserID = "")||(AInstanceID = "")||(ASignLevel = "")||(ALoginUser = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s templateID = objInstance.RealTemplateID
	q:(templateID = "") result
	s titleCode = objInstance.TitleCode
	s:((titleCode = "")||(titleCode = $c(0))) titleCode = $zcvt(objInstance.TheECRecord.ChartItemType,"U")
	s templateVersion = objInstance.TemplateVersion
	if ((ASignLevel = "patientSign")||(ASignLevel = "Patient"))
	{
		s userType = "PATIENT"
	}
	else
	{
		s userType = "MEDICAL"
	}
	
	s result = ##Class(EMRservice.BL.BLRoleSignRuleList).CheckSignRoleRule(AUserID,AInstanceID,ASignLevel,templateID,titleCode,templateVersion,userType,ALoginUser)
	q:(result '= 1) result
	
	s signSeqType =  ##Class(EMRservice.BL.BLRoleSignRuleList).GetSignSeqType(AUserID,AInstanceID,ASignLevel,templateID,titleCode,templateVersion)
	if (signSeqType = "1")
	{
		s result = ##Class(EMRservice.BL.BLRoleSignRuleList).CheckSeqSignPriv(AUserID,AInstanceID,ASignLevel,templateID,titleCode,templateVersion,userType)
	}
	q result
}

/// Desc:       判断当前签名级别是否满足所配置的角色规则
/// Creator:    donglulu
/// CreateDate: 2019-4-20
/// Input:      AUserID 用户ID  AInstanceID 实例ID AUserType医患类型 ALoginUser登陆用户
/// Output:     1 满足  0 不满足
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).CheckSignRoleRule(1800,"562||31","Attending","","","","")
ClassMethod CheckSignRoleRule(AUserID As %String, AInstanceID As %String, ASignLevel As %String, ATemplateID As %String, ATitleCode As %String, ATemplateVersion As %String, AUserType As %String, ALoginUser As %String) As %String
{
	s result = 1
	q:(AUserID = "")||(AInstanceID = "")||(ASignLevel = "")||(ATemplateID = "")||(ATitleCode = "")||(ATemplateVersion = "")||(AUserType = "") result
	s roleID = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(ASignLevel,"U"),""))
	q:(roleID = "") result
	s objRole = ##Class(EMRmeta.SignRole).%OpenId(roleID)
	s action = objRole.ActionCode
	
	s signRowID = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," "_$zcvt(action,"U"),""))
	q:(signRowID = "") result
	s objTemplateSign = ##Class(EMRmeta.TemplateSign).%OpenId(signRowID)
	q:(objTemplateSign = "") result
	s ruleAll = objTemplateSign.RoleRuleCode
	q:((ruleAll = "")||(ruleAll = $c(0))) result
	
	s length = $l(ruleAll,"^")
	for I=1:1:length
	{
		s rule = $p(ruleAll,"^",I)
		if (rule = "1")
		{
			 s result = ##Class(EMRservice.BL.BLRoleSignRuleList).CheckTitleDoctor(AUserID,AInstanceID)
		}
		elseif (rule = "2")
		{
			s result = ##Class(EMRservice.BL.BLRoleSignRuleList).IsLoginUser(AUserID,ALoginUser)
		}
		elseif (rule = "3")
		{
			s result = ##Class(EMRservice.BL.BLRoleSignRuleList).IsDoctorSignBefore(AInstanceID)
		}
		q:(result '= 1)
	}
	q result
}

/// Desc:       判断当前签名规则是否是逐级签名（必须下级签完名，上级才能签名）
/// Creator:    donglulu
/// CreateDate: 2019-4-20
/// Input:      AUserID 用户ID  AInstanceID 实例ID 
/// Output:     1 是  0 否
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).GetSignSeqType(1800,"562||31","Attending","","","")
ClassMethod GetSignSeqType(AUserID As %String, AInstanceID As %String, ASignLevel As %String, ATemplateID As %String, ATitleCode As %String, ATemplateVersion As %String) As %String
{
    s result = 0
	q:(AUserID = "")||(AInstanceID = "")||(ASignLevel = "")||(ATemplateID = "")||(ATitleCode = "")||(ATemplateVersion = "") result

	s signSeqType = $o(^DHCEMRM.TemplateSignRuleListI("IdxTemplateIDTitleRuleCodeValue"," "_ATemplateID," "_ATitleCode," SIGNSEQUENCETYPE",""))
	q:(signSeqType = "") result
    s signSeqType = $e(signSeqType,2,$l(signSeqType))
    s:(signSeqType = "1") result = 1
    q result
}

/// Desc:       判断当前签名级别在逐级签名情况下是否有权限签名（配置的下级已签名，上级未签名才有权限签名）
/// Creator:    donglulu
/// CreateDate: 2019-4-20
/// Input:      AUserID 用户ID  AInstanceID 实例ID  AUserType医患类型
/// Output:     1 有权限  0 无权限
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).CheckSeqSignPriv(1800,"562||31","Attending","","","","")
ClassMethod CheckSeqSignPriv(AUserID As %String, AInstanceID As %String, ASignLevel As %String, ATemplateID As %String, ATitleCode As %String, ATemplateVersion As %String, AUserType As %String) As %String
{
	s result = 1
	q:(AUserID = "")||(AInstanceID = "")||(ASignLevel = "")||(ATemplateID = "")||(ATitleCode = "")||(ATemplateVersion = "")||(AUserType = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s roleID = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(ASignLevel,"U"),""))
	q:(roleID = "") result
	s objRole = ##Class(EMRmeta.SignRole).%OpenId(roleID)
	s action = objRole.ActionCode
	s roleLevel = objRole.RoleLevel
	s signRowID = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," "_$zcvt(action,"U"),""))
	q:(signRowID = "") result
	s objTemplateSign = ##Class(EMRmeta.TemplateSign).%OpenId(signRowID)
	q:(objTemplateSign = "") result
	s signSeq = objTemplateSign.Sequence
	q:(signSeq = "") result
	s ecrecordID = $p(AInstanceID,"||",1)
	s subID = $p(AInstanceID,"||",2)
	s docId = objInstance.TheECRecord.RealChartItemID
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	
	if (roleLevel > 1)
	{
		s seq = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceSeqAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," Y",roleLevel),-1)
		if (seq '= "")
		{
			s seqAction = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceSeqAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," Y",seq,""))
			q:(seqAction = "") result
			
			s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_objInstance.RealEpisodeID," "_docId," "_subID,seqAction,""))
			if (sign = "")
			{
				s result = "0^低级别还未签名，无权限签名"
				q result
			}
			else
			{
				if (revokeSign = "Y")
				{
					s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
					q:(objSign = "")
					if (objSign.isSignValid '= "1")
					{
						s result = "0^低级别还未签名，无权限签名"
						q result
					}
				}
			}
		}
	}
	q:(result '= 1) result
	
	s seq = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceSeqAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," Y",roleLevel))
	if (seq > 1)
	{
		s seqAction = $o(^DHCEMRM.TemplateSignI("IdxTIDVTitleTypeForceSeqAction"," "_ATemplateID,ATemplateVersion," "_ATitleCode," "_AUserType," Y",seq,""))
		q:(seqAction = "") result
		s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_objInstance.RealEpisodeID," "_docId," "_subID,seqAction,""))
		if (sign '= "")
		{
			if (revokeSign = "Y")
			{
				s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
				q:(objSign = "")
				if (objSign.isSignValid = "1")
				{
					s result = "0^高级别已签名，无权限签名"
					q result
				}
			}
			else
			{
				s result = "0^高级别已签名，无权限签名"
				q result
			}
		}
	}
	q result
}

/// Desc:       判断当前用户和病程中选择的用户是否一致
/// Creator:    donglulu
/// CreateDate: 2019-3-20
/// Input:      AUserID 用户ID  AInstanceID 实例ID 
/// Output:     1 一致  0 不一致
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).CheckTitleDoctor("1647","562||26")
ClassMethod CheckTitleDoctor(AUserID As %String, AInstanceID As %String) As %String
{
	s result = "1"
	q:(AUserID = "")||(AInstanceID = "") result
	s title = $o(^DHCEMRI.TitleDoctorI("IdxInstanceIDUserID"," "_AInstanceID,""))
	q:(title = "") result
	s titleDoctor = $o(^DHCEMRI.TitleDoctorI("IdxInstanceIDUserID"," "_AInstanceID," "_AUserID,""))
	s:(titleDoctor = "") result = "0^该用户与标题中所选用户不一致"
	q result
}

/// Desc:       判断当前签名用户和登录用户是否一致
/// Creator:    donglulu
/// CreateDate: 2019-4-26
/// Input:      AUserID 签名用户ID  ALoginUser 登录用户ID 
/// Output:     1 一致  0 不一致
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).IsLoginUser("1647","562")
ClassMethod IsLoginUser(AUserID As %String, ALoginUser As %String) As %String
{
	s result = "0^该用户与登录用户不一致"
	q:(AUserID = "")||(ALoginUser = "") result
	s:(AUserID = ALoginUser) result = "1"
	q result
}

/// Desc:       判断患者签名前是否有医生签名
/// Creator:    donglulu
/// CreateDate: 2019-6-14
/// Input:      AInstanceID 实例ID
/// Output:     1 有  0 无
/// w ##Class(EMRservice.BL.BLRoleSignRuleList).IsDoctorSignBefore("")
ClassMethod IsDoctorSignBefore(AInstanceID As %String) As %String
{
	s result = "0^医护人员签名后，患者才能签名"
	q:(AInstanceID = "") "1"
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") "1"
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s ret = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(epsiodeId,docId,num)
	s:(ret = "1") result = "1"
	q result
}

}
