Class DHCEPRRBAC.Tool.BaseDataMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).Init()
ClassMethod Init()
{
	//d ..InitElementDefinition()
	d ..InitItemDefinition()
	d ..InitOperationDefinition()
	d ..InitRoleDefinition()
	d ..InitResourcePrivateDomain("0")
	//d ..InitResourcePrivateDomain("1")
	d ..InitResourceItem()
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitElementDefinition()
ClassMethod InitElementDefinition()
{
	s sc = $$InitOneResourceElement("HDSD00.11.110 姓名", "HDSD00.11.110", "V","患者本人在公安户籍管理部门正式登记注册的姓氏和名称", "GLOSSARY", "Y")
	s sc = $$InitOneResourceElement("HDSD00.11.048 患者身份证件号码", "HDSD00.11.048", "V","患者的身份证件上的唯一法定标识符", "GLOSSARY", "Y")
	s sc = $$InitOneResourceElement("HDSD00.11.024 出院诊断-主要诊断名称", "HDSD00.11.024", "V", "患者住院过程中对身体健康危害最大，花费医疗资源最多，住院时间最长的疾病诊断。外科的主要诊断指患者住院接受手术进行治疗的疾病；产科的主要诊断指产科的主要并发症或伴随疾病", "GLOSSARY", "Y")
	
InitOneResourceElement(argElementName, argElementCode, argElementCodeType, argElementDesc, argElementType, argElementActive)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRRBAC_META.ElementDefinition
		where ElementName = :argElementName and ElementCodeType = :argElementCodeType and ElementCode = :argElementCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRRBAC_META.ElementDefinition (ElementName, ElementCode, ElementCodeType, ElementDesc, ElementType, ElementActive) 
			values (:argElementName, :argElementCode, :argElementCodeType, :argElementDesc, :argElementType, :argElementActive))
	}
	
	q "1"
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitItemDefinition()
ClassMethod InitItemDefinition()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.MRItemD(rowID))
		q:(rowID = "")
		//判断是否存在
		s checkRet = ##class(DHCEPRRBAC.BL.BLItemDefinition).CheckItemDefinitionCode("FS",rowID)
		if (checkRet '= "")	//已经存在 跳过
		{
			continue
		}
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
		
		s objItem = ##class(DHCEPRRBAC.META.ItemDefinition).%New()
		s objItem.ItemActive = "Y"
		s objItem.ItemCode = rowID
		s objItem.ItemName = obj.Name
		s objItem.ItemDesc = obj.Description
		s objItem.ItemType = "FS"
		w !,"Insert:"_obj.Name
		s sc = objItem.%Save()
		if ($$$ISOK(sc))
		{
			w !,objItem.%Id()
		}
		else
		{
			w "-1"
		}
	}
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitResourceItem()
ClassMethod InitResourceItem()
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.META.PrivDDFD(rowID))
		q:(rowID = "")
		s objPDD = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(rowID)
		s pddType = objPDD.RPDType
		d objPDD.%Close()
		continue:(pddType '= "FS")
		s itemID = ""
		for {
			s itemID = $o(^DHCEPRRBAC.META.ItemDFD(itemID))
			q:(itemID = "")
			
			s objItem = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemID)
			s itemType = objItem.ItemType
			continue:(itemType '= "FS")
			//判断是否存在
			s checkRet=##class(DHCEPRRBAC.BL.BLResourceItem).CheckResourceItem(rowID,itemID)
			continue:(checkRet'="")
			
			s obj = ##class(DHCEPRRBAC.INST.ResourceItem).%New()
			s obj.IsActive = "Y"
			s obj.ItemID = itemID
			s obj.PrivateDomainID = rowID
			w !,"Insert:"_rowID_","_itemID
			s sc = obj.%Save()
			w !,obj.%Id()
		}
	}
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitOperationDefinition()
ClassMethod InitOperationDefinition()
{
	s sc = $$InitOneOperation("VIEW", "VIEW", "浏览", "Y", "Y")
	
InitOneOperation(argOpName, argOpCode, argOpDesc, argOpActive, argDefaultOp)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRRBAC_META.OperationDefinition
		where OpName = :argOpName and OpCode = :argOpCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRRBAC_META.OperationDefinition (OpName, OpCode, OpDesc, OpActive, DefaultOp) 
			values (:argOpName, :argOpCode, :argOpDesc, :argOpActive, :argDefaultOp))
	}
	
	q "1"
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitRoleDefinition()
ClassMethod InitRoleDefinition()
{
	s sc = $$InitOneRole("NormalViewer", "nv001", "普通浏览", "Y", "FS")
	
InitOneRole(argRoleName, argRoleCode, argRoleDesc, argRoleActive, argRoleType)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRRBAC_META.RoleDefinition
		where RoleName = :argRoleName and RoleCode = :argRoleCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRRBAC_META.RoleDefinition (RoleName, RoleCode, RoleDesc, RoleActive, RoleType) 
			values (:argRoleName, :argRoleCode, :argRoleDesc, :argRoleActive, :argRoleType))
	}
	
	q "1"
}

/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).InitResourcePrivateDomain("0")
ClassMethod InitResourcePrivateDomain(ALevel As %String) As %String
{
	s obj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%New()
	s obj.RPDActive = "Y"
	s obj.RPDCode = "PD"_ALevel
	//数字越大级别越高，所屏蔽的信息越少
	s obj.RPDDesc = "隐私域级别"_ALevel
	s obj.RPDLevel = ALevel
	s obj.RPDName = "PD"_ALevel
	s obj.RPDType = "FS"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc: 升级AdvancedSecurity表,更新SysCode和MREpisodeID
/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).UpgradeAdvSecuritySysCode()
ClassMethod UpgradeAdvSecuritySysCode() As %String
{
	&sql(update DHCEPRRBAC_META.AdvancedSecurity  Set SysCode="DHC",
		MREpisodeID=(select ID from DHCEPRFS_INST.MREPISODE 
				WHERE DHCEPRFS_INST.MREPISODE.EpisodeID=DHCEPRRBAC_META.AdvancedSecurity.EpisodeID ))
	q "1"
}

/// Desc: 升级AdvancedSecurityLog表,更新SysCode和MREpisodeID
/// d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).UpgradeAdvSecurityLogSysCode()
ClassMethod UpgradeAdvSecurityLogSysCode() As %String
{
	&sql(update DHCEPRRBAC_INST.AdvancedSecurityLog  Set SysCode="DHC",
		MREpisodeID=(select ID from DHCEPRFS_INST.MREPISODE 
				WHERE DHCEPRFS_INST.MREPISODE.EpisodeID=DHCEPRRBAC_INST.AdvancedSecurityLog.EpisodeID ))
	q "1"
}

/// Desc: 更新隐私域级别表RPDType
/// Debug: d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).UpdatePrivateDomainType()
ClassMethod UpdatePrivateDomainType() As %String
{
	s ret = "1"
	s PDRowID = ""
	for {
		s PDRowID = $o(^DHCEPRRBAC.META.PrivDDFD(PDRowID))
		q:(PDRowID = "")
		s objPD = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(PDRowID)
		continue:(objPD.RPDLevel = "N")||(objPD.RPDLevel = "R")||(objPD.RPDLevel = "V")
		s objPD.RPDType = "FS"
		s sc = objPD.%Save()
		s:($$$ISERR(sc)) ret = "0"
	}
	q ret
}

/// Desc: 更新角色表RoleType
/// Debug: d ##Class(DHCEPRRBAC.Tool.BaseDataMgr).UpdateRoleType()
ClassMethod UpdateRoleType() As %String
{
	s ret = "1"
	s roleID = ""
	for {
		s roleID = $o(^DHCEPRRBAC.META.RoleDFD(roleID))
		q:(roleID = "")
		s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(roleID)
		continue:(objRole.RoleCode = "N")||(objRole.RoleCode = "R")||(objRole.RoleCode = "V")
		s objRole.RoleType = "FS"
		s sc = objRole.%Save()
		s:($$$ISERR(sc)) ret = "0"
	}
	q ret
}

}
