/// 名称：		EMRservice.BL.BLSignRole
/// 描述：		签名角色业务逻辑类
/// 编写者：	Candy
/// 编写时间：	2016-7-1
Class EMRservice.BL.BLSignRole Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(EMRservice.BL.BLSignRole).IniData()
ClassMethod IniData()
{
	d ..AddSignRole("Chairman","科主任","chairmanCheck","1",50,0,0,0)
	d ..AddSignRole("QCDoc","质控医师","qcdocCheck","1",70,0,0,1)	
   	d ..AddSignRole("QCNurse","质控护士","qcnurseCheck","1",70,0,0,1)
    d ..AddSignRole("ChargeNurse","责任护士","chargenurseCheck","1",0,0,0,1)
    d ..AddSignRole("student","学生","studentCheck","1",0,1,1,0)
	d ..AddSignRole("intern","实习医师","internCheck","1",0,1,1,0)
	d ..AddSignRole("Resident","住院医师","residentCheck","1",10,0,1,0)
	d ..AddSignRole("Attending","主治医师","attendingCheck","1",20,0,1,0)
	d ..AddSignRole("ViceChief","副主任医师","viceChiefCheck","1",30,0,1,0)
	d ..AddSignRole("Chief","主任医师","chiefCheck","1",30,0,1,0)
	d ..AddSignRole("All","参与者","participantCheck","1",80,0,0,1)
	d ..AddSignRole("Check","三级审核","check","1",0,0,0,0)
	d ..AddSignRole("Refresher","进修医师","refresherCheck","1",10,0,1,0)
	d ..AddSignRole("Coder","编码员","coderCheck","1",0,0,0,0)
	d ..AddSignRole("PlanTrain","规培医师","planTrainCheck","1",10,0,1,0)
	d ..AddSignRole("TrainDoctor","规培医生","trainDoctorCheck","1",0,1,1,0)
	d ..AddSignRole("Anesthesiologist","麻醉医师","anesthesiologistCheck","1",0,0,0,0)
	d ..AddSignRole("AnesthesiaNurse","麻醉护士","anesthesiaNurseCheck","1",0,0,0,0)
	d ..AddSignRole("Patient","患者","patientSign","1",90,0,0,0)
	d ..AddSignRole("Notation","患者批注","NotationGet","1",0,0,0,0)
	d ..AddSignRole("GroupLeader","诊疗组组长","groupLeaderCheck","1",40,0,0,0)
	d ..AddSignRole("Doctor","医师","doctorCheck","1",80,0,0,0)
	d ..AddSignRole("Nurse","护士","nurseCheck","1",0,0,0,0)
	d ..AddSignRole("InCharge","主诊医师","inChargeCheck","1",70,0,0,0)
}

ClassMethod AddSignRole(AName, ADescription, AActionCode, AIsValid, ARoleLevel, ASignPrefix, ACanSignOnCheck, ANotValidate) As %String
{
	s result = 0
	s rowId = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.SignRole).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	}
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.ActionCode = AActionCode
	s obj.IsValid = AIsValid
	s obj.RoleLevel = ARoleLevel
	s obj.SignPrefix = ASignPrefix
	s obj.CanSignOnCheck = ACanSignOnCheck
	s obj.NotValidate = ANotValidate
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,ActionCode:%String,IsValid:%String,RoleLevel:%String,SignPrefix:%String,CanSignOnCheck:%String,NotValidate:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_SignRole_SELECTALL, SqlProc ]
{
	SELECT ID,Name,Description,ActionCode,IsValid,RoleLevel,SignPrefix,CanSignOnCheck,NotValidate
    FROM EMRmeta.SignRole
    WHERE IsValid = '1'
}

/// Creator:	yejian
/// CreatDate:  2020-7-29
/// Desc:		更新签名角色属性
/// Input：		aSignRole签名角色对象
/// Return：	失败：0，成功：1
ClassMethod UpdateSignRole(aSignRole As EMRservice.entity.ESignRoleData) As %String
{

	s ret = 1
	q:(aSignRole = "") 0
	s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(aSignRole.ID)
	//s objSignRole.IsValid = aSignRole.IsValid
	s objSignRole.SignPrefix =aSignRole.SignPrefix
	s objSignRole.CanSignOnCheck =aSignRole.CanSignOnCheck
	s objSignRole.NotValidate =aSignRole.NotValidate
	if (objSignRole.%Save())
	{
	    s ret=objSignRole.%Id()
	}
	else
	{
	   s ret = 0
	}		

	d objSignRole.%Close()
	q ret
}

/// Desc:       取所有签名角色
/// Crator:     Candy
/// CreateDate: 2016-7-27
/// Input:
/// Output:     json数据
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetAllSignRole()
ClassMethod GetAllSignRole() As %String
{
	s json = ""
	s name = ""
	s count = 0
	for
	{
		s name = $o(^DHCEMRM.SignRoleI("NameIndex",name))
		q:(name = "")
		s rowId = $o(^DHCEMRM.SignRoleI("NameIndex",name,""))
		continue:(rowId = "")
		s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
		continue:(obj = "")
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""Name"":"""_obj.Name_""""
		s json = json_",""Description"":"""_$zcvt(obj.Description,"O","UTF8")_""""
		s json = json_",""Level"":"""_obj.RoleLevel_""""
		s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// Desc:根据操作代码取name
/// Debug: w ##Class(EMRservice.BL.BLSignRole).GetSignName("RESIDENT")
ClassMethod GetSignName(AActionCode As %String) As %String
{
	s result = ""
	q:(AActionCode = "") result
	s rowId  = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(AActionCode,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	q:(obj = "") result
	s result = obj.Name
	q result
}

/// Desc:   根据name取操作代码
/// Debug: w ##Class(EMRservice.BL.BLSignRole).GetSignCode("chief")
ClassMethod GetSignCode(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s rowId  = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	q:(obj = "") result
	s result = obj.ActionCode
	q result
}

/// Desc: 取签名角色的级别
ClassMethod GetSignLevel(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s rowId  = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	q:(obj = "") result
	s result = obj.RoleLevel
	q result
}

/// Desc:   根据name取描述
/// Debug: w ##Class(EMRservice.BL.BLSignRole).GetSignDesc("RESIDENT")
ClassMethod GetSignDesc(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s rowId  = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	q:(obj = "") result
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s result = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.SignRole","Description",obj.Description,langid)
	q result
}

/// Desc:       通过HIS取用户级别
/// Creator:    Candy
/// CreateDate: 2016-12-6
/// Input:      parUserID 用户ID
/// Output:     result 用户级别^级别描述
ClassMethod GetUserLevelbyHis(parUserID As %String) As %String
{
	s result = ""
	q:(parUserID = "") result
	s userPvId = $p(^SSU("SSUSR",parUserID),"^",14)
	q:(userPvId = "") result
	q:('$d(^CTPCP(userPvId,1))) result
	s userCarprvtpId = $p(^CTPCP(userPvId,1),"^",4)
	q:(userCarprvtpId = "") result
	q:(($p(^CTPCP(userPvId,1),"^",9) '= "Y")&&($p(^CTPCP(userPvId,1),"^",9) '= "true")) result
	q:('$d(^CT("CPT",userCarprvtpId))) result
	s userCarprvtpCode = $p($g(^CT("CPT",userCarprvtpId)),"^",1)
	q:(userCarprvtpCode = "") result
	s level = ##Class(EMRservice.BL.BLSignRoleLinkCarPrvTp).GetSignRoleByCarPrvTp(userCarprvtpCode)
	s desc = ..GetSignDesc(level)
	s result = level_"^"_desc
	q result
}

/// Desc:       医师是否为科主任
/// Creator:    Candy
/// CreateDate: 2016-12-6
/// Input:      parUserID 用户ID
///            parLocID 用户所在科室
/// Output:     result 是则返回 科主任信息,否则返回""
ClassMethod GetDepartmentHead(parUserID As %String, parLocID As %String) As %String
{
	s result = ""
	
	s isExistClass = ##class(%Dictionary.CompiledClass).%ExistsId("web.DHCBL.CT.CTLocDepHeadUser")
	s isExistMethod = ##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCBL.CT.CTLocDepHeadUser||GetDepHeadUser")
	if ((isExistClass = "1")&&(isExistMethod = "1"))
	{
		s ssuserIdList = ##class(web.DHCBL.CT.CTLocDepHeadUser).GetDepHeadUser(parLocID)
	    f i=1:1:$l(ssuserIdList,"^")
	    {
	          s:($p(ssuserIdList,"^",i) = parUserID) result = "Chairman^科主任"
	          q:(result'="")
	    }
	}
	else
	{
		s ssuserId = $p(^CTLOC(parLocID),"^",54) 
		s:(ssuserId = parUserID) result = "Chairman^科主任"
	}
	q result
}

/// Desc:		取用户级别
/// Creator:		Candy
/// CreateDate:	2017-8-17
/// Input:     	parUserID 用户ID
/// Output:      级别代码^级别描述
/// Debug:       w ##Class(EMRservice.BL.BLSignRole).GetUserLevel(105)
ClassMethod GetUserLevel(parUserID As %String, parEpisodeID As %String = "", parLocID As %String = "") As %String
{
		s result = ""
	q:(parUserID = "") result
	s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	
	if ($zcvt(levelSource,"U") = "HIS")
	{
		s userLevel = ..GetUserLevelbyHis(parUserID)
		s levelCode = $p(userLevel,"^",1)
		s levelDesc = $p(userLevel,"^",2)
	}
	elseif (($zcvt(levelSource,"U") = "EPISODEID")&&(parEpisodeID '="") )
	{
		s result = ..GetUserLevelByEpisode(parUserID,parEpisodeID,parLocID)
		if (result = "")
		{
			s userLevel = ..GetUserLevelbyHis(parUserID)
			s levelCode = $p(userLevel,"^",1)
			s levelDesc = $p(userLevel,"^",2)
		}
	}
	else
	{
	    s levelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(parUserID)
	    //兼容清除维护程序配置医生级别存储的特殊值$c(0)
	    s:(levelCode=$c(0)) levelCode=""
	    s levelDesc = ##Class(EMRservice.BL.BLUserLevel).GetDesc(levelCode)
	}
	
	s:(result = "") result = levelCode_"^"_levelDesc
	q result
}

/// Desc:		取用户职务
/// Creator:		Candy
/// CreateDate:	2017-8-17
/// Input:     	parUserID 用户ID
///             parLocID 科室ID
/// Output:      职务代码^职务描述
/// Debug:       w ##Class(EMRservice.BL.BLSignRole).GetUserPosition(105,6)
ClassMethod GetUserPosition(parUserID As %String, parLocID As %String) As %String
{
	s result = ""
	q:(parUserID = "") result	
	s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	if ($zcvt(levelSource,"U") = "HIS")
	{
		s userPos = ##Class(EMRservice.HISInterface.GetHisUserPost).GetUserPos(parUserID,parLocID)	
	    s posCode = $p(userPos,"^",1)
	    s posDesc = $p(userPos,"^",2)
	}
	else
	{
	    s posCode = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(parUserID)
	    s posDesc = ##Class(EMRservice.BL.BLUserPost).GetDesc(posCode)
	}
	s result = posCode_"^"_posDesc
	q result
}

/// Desc:取签名是否加前缀
/// Input:用户级别
ClassMethod GetSignPrefixFlag(parLevelName As %String) As %String
{
	s result = ""
	q:(parLevelName = "") result
	s rowId  = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(parLevelName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	q:(obj = "") result
	s result = obj.SignPrefix
	q result
}

/// Desc:		取医生设置给患者的用户级别
/// Creator:	Candy
/// CreateDate:	2018-3-16
/// Input:     	parUserID 用户ID
///             parEpisodeID 就诊号
/// Output:     级别代码
/// debug   ##Class(EMRservice.BL.BLSignRole).GetUserLevelByEpisode()
ClassMethod GetUserLevelByEpisode(parUserID As %String, parEpisodeID As %String, parLocID As %String = "") As %String
{
	s result = ""
	s result = ..GetUserLevelByEpisodeStandard(parEpisodeID,parUserID,parLocID)
	s:(result = "") result = ..GetUserLevelByEpisodeOld(parUserID,parEpisodeID)
	s:(result = "") result = ..GetUserLevelByEpisodeEMR(parUserID,parEpisodeID)
	q result
}

/// Desc:		取医生设置给患者的用户级别
/// Creator:	Candy
/// CreateDate:	2018-3-16
/// Input:     	parUserID 用户ID
///             parEpisodeID 就诊号
/// Output:     级别代码
/// debug   ##Class(EMRservice.BL.BLSignRole).GetUserLevelByEpisodeOld()
ClassMethod GetUserLevelByEpisodeOld(parUserID As %String, parEpisodeID As %String) As %String
{
	s result = ""
	q:(parUserID = "")||(parEpisodeID = "") result
	s rowId = $o(^DHCPAAdm(0,"PAAdm",parEpisodeID,""))
	q:(rowId = "") result
	s doctorId = $p(^PAADM(parEpisodeID),"^",9)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "Resident^住院医师"
		q:(result '= "") result		
	}
	s doctorId = $P(^DHCPAAdm(rowId),"^",23)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "Attending^主治医师"
		q:(result '= "") result
	}
	s doctorId = $P(^DHCPAAdm(rowId),"^",24)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "Chief^主任医师"
		q:(result '= "") result
	}	
	s doctorId = $P(^DHCPAAdm(rowId),"^",25)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "student^实习医生"
		q:(result '= "") result
	}	
	s doctorId = $P(^DHCPAAdm(rowId),"^",26)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "student^实习医生"
		q:(result '= "") result
	}	
	s doctorId = $P(^DHCPAAdm(rowId),"^",27)
	if (doctorId '= "")
	{
		s userId = $o(^SSU("SSUSR",0,"CTPCP",doctorId))
		s:(parUserID = userId) result = "student^实习医生"
		q:(result '= "") result
	}	
	q result
}

/// Desc:      标版取医生设置给患者的用户级别
/// Creator:   董璐璐
/// CreateDate:2019-10-30
/// Input:	   AEpisodeID 就诊ID
///  		   AUserID  用户ID
///            ALocID 科室ID   
/// Output:    result 上级医师ID
/// Debug:     w ##Class(EMRservice.BL.BLSignRole).GetUserLevelByEpisodeStandard("1","001","1")
ClassMethod GetUserLevelByEpisodeStandard(AEpisodeID As %String, AUserID As %String, ALocID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ALocID = "")||(AUserID = "") result
	
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCDoc.Interface.Inside.Service") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCDoc.Interface.Inside.Service||GetAdmThreeCheckDoc") = "0") result
	
	s docs = ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("",ALocID,AEpisodeID)
	//s docs = "[{""UserID"":""001"",""UserDesc"":""qq"",""Type"":""1"",""TypeDesc"":""管床医师""},{""UserID"":""002"",""UserDesc"":"""",""Type"":""2"",""TypeDesc"":""ee""}]"
	q:(docs = "") result
	s stream =##class(%FileBinaryStream).%New()
	d stream.Write(docs)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s arrDocs = objJson.Deserialize(stream)
	s userType = ""
	s count = arrDocs.Count()
	for i=1:1:count
	{
		s type = arrDocs.GetAt(i).GetAt("Type")
		s userId = arrDocs.GetAt(i).GetAt("UserID")
		s:(AUserID = userId) userType = type
	}
	q:(userType = "") result
	if (userType = "1") 
	{
		s result = "Resident^住院医师"
	}
	elseif (userType = "2") 
	{
		s result = "Attending^主治医师"
	}
	elseif (userType = "3") 
	{
		s result = "Chief^主任医师"
	}
	q result
}

/// Desc:      电子病历取医生设置给患者的用户级别
/// Creator:   董璐璐
/// CreateDate:2019-10-30
/// Input:	   AEpisodeID 就诊ID
///  		   AUserID  用户ID 
/// Output:    result 上级医师ID
/// Debug:     w ##Class(EMRservice.BL.BLSignRole).GetUserLevelByEpisodeEMR("22","362")
ClassMethod GetUserLevelByEpisodeEMR(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AUserID = "") result
	
	s rowId = $o(^DHCEMRI.PatientDoctorI("IdxEpisodeIDDoctorID"," "_AEpisodeID," "_AUserID,""))
	q:(rowId = "") result
	
	s obj = ##Class(EMRinstance.PatientDoctor).%OpenId(rowId)
	q:(obj = "") result
	s levelCode = obj.DoctorLevelCode
	s metaID = $O(^DHCEMRM.PatientDoctorI("IdxLevelCode"," "_$zcvt(levelCode,"U"),""))
	q:(metaID = "") result
	s objMeta = ##Class(EMRmeta.PatientDoctor).%OpenId(metaID)
	q:(objMeta = "") result
	s levelDesc = objMeta.LevelDesc
	s result = levelCode_"^"_levelDesc
	q result
}

/// w ##class(EMRservice.BL.BLSignRole).InitSignInfo("规培医师","PlanTrain","UserLevel",0,1,1,0)
/// w ##class(EMRservice.BL.BLSignRole).InitSignInfo("规培医生","TrainDoctor","UserLevel",0,1,1,0)
/// w ##class(EMRservice.BL.BLSignRole).InitSignInfo("麻醉医师","AnaDoc","UserPost")
/// w ##class(EMRservice.BL.BLSignRole).InitSignInfo("麻醉护士","AnaNurse","UserPost")
ClassMethod InitSignInfo(role As %String, roleCode As %String, roleType As %String = "UserLevel", ARoleLevel As %String = "0", ASignPrefix As %String = "", ACanSignOnCheck As %String = "", ANotValidate As %String = "")
{
	
	s littleRoleCode =$zcvt($e(roleCode,1),"L")_$e(roleCode,2,*)
	
	s rowId = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(roleCode,"U"),""))
	q:(rowId'="") "<waring>已存在签名角色，查验后再初始化！"
	
	s objSignRole = ##class(EMRmeta.SignRole).%New()
	s objSignRole.ActionCode=littleRoleCode_"Check"
	s objSignRole.Description=role
	s objSignRole.IsValid="1"
	s objSignRole.Name=roleCode
	s objSignRole.RoleLevel=ARoleLevel
	s objSignRole.SignPrefix=ASignPrefix
	s objSignRole.CanSignOnCheck=ACanSignOnCheck
	s objSignRole.NotValidate=ANotValidate
	d objSignRole.%Save()
	d objSignRole.%Close()
	
	
	s objEMRAction = ##class(EMRmeta.EMRAction).%New()
	s objEMRAction.ActionCode =littleRoleCode_"Check"
	s objEMRAction.ActionName = role_"签名"
	d objEMRAction.%Save()
	d objEMRAction.%Close()
	
	
	s objEMRStatus=##class(EMRmeta.EMRStatus).%New()
	s objEMRStatus.StatusCode=littleRoleCode_"Checked"
	s objEMRStatus.StatusName=role_"签名"
	d objEMRStatus.%Save()
	d objEMRStatus.%Close()
	
	if (roleType="UserLevel")
	{
		s objUserLevel=##class(EMRmeta.UserLevel).%New()
		s objUserLevel.Description = role
		s objUserLevel.IsValid = "1"
		s objUserLevel.Name = roleCode
		d objUserLevel.%Save()
		d objUserLevel.%Close()
	}
	elseif (roleType="UserPost")
	{
	
		s objUserPost=##class(EMRmeta.UserPost).%New()
		s objUserPost.Description = role
		s objUserPost.IsValid = "1"
		s objUserPost.Name = roleCode
		s objUserPost.OperAction = littleRoleCode_"Check"
		d objUserPost.%Save()
		d objUserPost.%Close()
	}
	else
	{
		q "未选择角色定义类型"
	}
	
	
	s PreStatusList = ""
	
	s emrStatusID=""
	for {
		s emrStatusID = $o(^DHCEMRM.EMRStatusD(emrStatusID))
		q:(emrStatusID="")
		s objEMRStatus = ##class(EMRmeta.EMRStatus).%OpenId(emrStatusID)
		continue:(objEMRStatus="")
		s tmpStatus = objEMRStatus.StatusCode
		continue:(tmpStatus = "deleted")
		s PreStatusList=PreStatusList_$lb(tmpStatus)
	}

	for i=1:1:$ll(PreStatusList)
	{
		s tmpPreStatus = $list(PreStatusList,i)
		s objActStatusCfg = ##class(EMRmeta.EMRActStatusCfg).%New()
		s objActStatusCfg.EMRAction=littleRoleCode_"Check"
		s objActStatusCfg.PostStatus=littleRoleCode_"Checked"
		s objActStatusCfg.PreStatus=tmpPreStatus
		d objActStatusCfg.%Save()
		d objActStatusCfg.%Close()
	}
	
	s PostStatusList = ""
	
	s emrActionID=""
	for {
		s emrActionID = $o(^DHCEMRM.EMRActionD(emrActionID))
		q:(emrActionID="")
		s objEMRAction = ##class(EMRmeta.EMRAction).%OpenId(emrActionID)
		continue:(objEMRAction="")
		s tmpAct = objEMRAction.ActionCode
		if (tmpAct = "save")
		{
			s PostStatusList=PostStatusList_$lb("save^checkedRevision")
		}
		elseif(tmpAct = "delete")
		{
			s PostStatusList=PostStatusList_$lb("delete^deleted")
		}
		elseif(tmpAct = "print")
		{
			s PostStatusList=PostStatusList_$lb("print^"_littleRoleCode_"Checked")
		}
		elseif(tmpAct = "reference")
		{
			continue
		}
		else
		{
			s PostStatusList=PostStatusList_$lb(tmpAct_"^"_tmpAct_"ed")
		}
	}
	
	for j=1:1:$ll(PostStatusList)
	{
		s tmpPostStatusData = $list(PostStatusList,j)
		s tmpAction = $p(tmpPostStatusData,"^",1)
		s tmpPostStatus = $p(tmpPostStatusData,"^",2)
		
		s objActStatusCfg = ##class(EMRmeta.EMRActStatusCfg).%New()
		s objActStatusCfg.EMRAction=tmpAction
		s objActStatusCfg.PostStatus=tmpPostStatus
		s objActStatusCfg.PreStatus=littleRoleCode_"Checked"
		d objActStatusCfg.%Save()
		d objActStatusCfg.%Close()
	}
	
	q role_"相关初始化完成"
}

/// Desc:		取用户职称描述
/// Creator:	DongLulu
/// CreateDate:	2020-7-1
/// Input:     	parUserID 用户ID
/// Output:      职称描述
/// Debug:       w ##Class(EMRservice.BL.BLSignRole).GetUserCTPCPDesc(105)
ClassMethod GetUserCTPCPDesc(parUserID As %String) As %String
{
	s result = ""
	q:(parUserID = "") result
	
	if (##Class(EMRservice.SystemParameter).GetSignCTPCPDescType() = "HisCTPCP")
	{
		//直接取HIS职称
		s userLevel = ..GetUserLevelbyHis(parUserID)
		s levelDesc = $p(userLevel,"^",2)
	}
	else
	{
		s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	
		if (($zcvt(levelSource,"U") = "HIS")||($zcvt(levelSource,"U") = "EPISODEID"))
		{
			s userLevel = ..GetUserLevelbyHis(parUserID)
			s levelDesc = $p(userLevel,"^",2)
		}
		else
		{
		    s levelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(parUserID)
		    s levelDesc = ##Class(EMRservice.BL.BLUserLevel).GetDesc(levelCode)
		}
	}
	
	s result = levelDesc
	q result
}

/// Desc:       取签名角色
/// Creator:    Donglulu
/// CreateDate: 2020-7-16
/// Input:      AOriSignatureLevel 签名单元code
///            AUserID 用户ID
///            AUserLocID 科室ID
///            AEpisodeID 就诊号
/// Output:     签名角色code^签名角色描述^签名角色范围
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetSignCharacter("Check",10210,"132","170")
ClassMethod GetSignCharacter(AOriSignatureLevel As %String, AUserID As %String, AUserLocID As %String, AEpisodeID As %String) As %String
{
	s result = ""
	s signCharacter = ""
	q:(AOriSignatureLevel = "")||(AUserID = "")||(AUserLocID = "") result
	s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	if (AOriSignatureLevel = "Check")
	{
		//签名单元为多级医师审核
		s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(AUserID,AEpisodeID,AUserLocID)
		s signCharacter = $p(userLevel,"^",1)
		//判断能否在多级医师审核签名单元签名
		s signRoleID = $o(^DHCEMRM.SignRoleI("IdxNameCanSignOnCheck"," "_$zcvt(signCharacter,"U")," 1",""))
		s:(signRoleID = "") signCharacter = "" 
		//兼容高级别医师可向下选择级别签名，例：主任医师选择主治医师签名角色进行签名
		if (##Class(EMRservice.SystemParameter).IsEnableSelectUserLevel() = "Y")
		{
			s signCharacter = ##Class(EMRservice.SystemParameter).GetUserLevelRange(signCharacter)
		}
		//用户是否是诊疗组组长、科主任
		s userPost = ##class(EMRservice.BL.BLSignRole).GetUserCheckPost(AUserID,AUserLocID)
		s:((signCharacter '= "")&&(userPost '= "")) signCharacter = signCharacter_"^" 
		s:(userPost '= "") signCharacter = signCharacter_userPost
	}
	elseif ($o(^DHCEMRM.SignRoleI("IdxNameNotValidate"," "_$zcvt(AOriSignatureLevel,"U")," 1","")) '= "")
	{
		//签名单元为谁都能签名（不验证用户级别和职称，如：参与者签名，质控医师，质控护士，责任护士）
		s signCharacter = AOriSignatureLevel
	}
	elseif (AOriSignatureLevel = "Doctor")
	{
		//签名单元为医生
		if (levelSource = "EMR")
		{
			s LevelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(AUserID)
			s:(AOriSignatureLevel = LevelCode) signCharacter = AOriSignatureLevel
		}
		else
		{
			s isDoctor = ##Class(EMRservice.BOPrivAssist).UserIsDoc(AUserID)
			s:(isDoctor = "1") signCharacter = AOriSignatureLevel
		}	
	}
	elseif (AOriSignatureLevel = "Nurse")
	{
		//签名单元为护士
		if (levelSource = "EMR")
		{
			s LevelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(AUserID)
			s:(AOriSignatureLevel = LevelCode) signCharacter = AOriSignatureLevel
		}
		else
		{
			s isNurse = ##Class(EMRservice.BOPrivAssist).UserIsNur(AUserID)
			s:(isNurse = "1") signCharacter = AOriSignatureLevel
		}	
	}
	elseif ($o(^DHCEMRM.UserPostI("NameIndex"," "_$zcvt(AOriSignatureLevel,"U"),"")) '= "")
	{
		//签名单元为职务
		if (levelSource = "EMR")
		{
			s posCode = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(AUserID)
			s:(AOriSignatureLevel = posCode) signCharacter = AOriSignatureLevel
		}
		else
		{
			s isOriSign = ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos(AUserID,AOriSignatureLevel,AUserLocID)
			s:(isOriSign = "1") signCharacter = AOriSignatureLevel
		}
		
	}
	else
	{
		//签名单元为级别
		s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(AUserID,AEpisodeID,AUserLocID)
		s levelCode = $p(userLevel,"^",1)
		s isUserLevelHigher = ##Class(EMRservice.BL.BLSignRole).IsUserLevelHigher(levelCode,AOriSignatureLevel)
		s:(isUserLevelHigher = "1") signCharacter = AOriSignatureLevel
	}
	s result = ##Class(EMRservice.BL.BLSignRole).GetSignCharacterInfo(signCharacter)
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:  		判断用户级别是否大于等于签名单元级别(判断第一个入参级别是否大于等于第二个入参级别)
/// Creator:    董璐璐
/// CreateDate: 2020-7-16
/// Input:      AUserLevel EMRmeta.SignRole表的Name
/// 		    AOriSignatureLevel EMRmeta.SignRole表的Name
/// Output:     1 第一个入参在EMRmeta.SignRole表的RoleLevel大于等于第二个入参的/0 第一个入参小于第二个
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).IsUserLevelHigher("Attending","Resident")
ClassMethod IsUserLevelHigher(AUserLevel As %String, AOriSignatureLevel As %String) As %String
{
	s result = "0"
	q:(AUserLevel = "")||(AOriSignatureLevel = "") result
	s userRoleId = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AUserLevel,"U"),""))
	q:(userRoleId = "") result
	s userObj = ##Class(EMRmeta.SignRole).%OpenId(userRoleId)
	q:(userObj = "")
	s userLevelNum = userObj.RoleLevel
	s oriRoleId = $o(^DHCEMRM.SignRoleI("NameIndex"," "_$zcvt(AOriSignatureLevel,"U"),""))
	q:(oriRoleId = "") result
	s oriObj = ##Class(EMRmeta.SignRole).%OpenId(oriRoleId)
	q:(oriObj = "")
	s oriLevelNum = oriObj.RoleLevel
	s:(userLevelNum >= oriLevelNum) result = "1"
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       用户可在多级医师审核单元签名的职务集合
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     该用户的职务代码，多个以^分隔，没有职务返回空（例：Chairman^GroupLeader）
///  Debug:      w ##Class(EMRservice.BL.BLSignRole).GetUserCheckPost("10209","3")
ClassMethod GetUserCheckPost(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	if (levelSource = "EMR")
	{
		//取电子病历
		s posCode = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(AUserID)
		q:(posCode = "") result
		if ($o(^DHCEMRM.SignRoleI("IdxNameCanSignOnCheck"," "_$zcvt(posCode,"U")," 1","")) '= "")
		{
			s result = posCode
		}
	}
	else
	{
		//取HIS
		s name = ""
		for
		{
			s name = $o(^DHCEMRM.SignRoleI("IdxNameCanSignOnCheck",name))
			q:(name = "")
			s rowID = $o(^DHCEMRM.SignRoleI("IdxNameCanSignOnCheck",name," 1",""))
			continue:(rowID = "")
			
			//签名单元不是职务则退出
			s postID = $o(^DHCEMRM.UserPostI("NameIndex",name,""))
			continue:(postID = "")
			
			s oriObj = ##Class(EMRmeta.SignRole).%OpenId(rowID)
			continue:(oriObj = "")
			
			//用户不是该职务退出
			s isPost = ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos(AUserID,oriObj.Name,AUserLoc)
			continue:(isPost '= "1")
			
			s:(result '= "") result = result_"^"
			s result = result_oriObj.Name
		}
	}
	
	q result
}

/// Desc:       获取弹出签名框时，获取签名角色范围
/// Creator:    董璐璐
/// CreateDate: 2020-7-17
/// Input:      签名角色（多个以"^"分隔）
/// Output:     最高级别签名角色code^最高级别签名角色描述^签名角色范围json
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetSignCharacterInfo("Chief")
ClassMethod GetSignCharacterInfo(ARole As %String) As %String
{
	s result = ""
	q:(ARole = "") "^无权限^[{""LevelCode"":"""",""LevelDesc"":""无权限""}]" 
	s code = ""
	s desc = ""
	s range = "["	
	
	s count=$l(ARole, "^")
	f i=1:1:count 
	{
		s levelCode = $p(ARole, "^", i)
		q:(levelCode = "")
		s levelDesc = ##Class(EMRservice.BL.BLSignRole).GetSignDesc(levelCode)
		
		if (i = "1")
		{
			s code = levelCode
			s desc = levelDesc
			s level = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(levelCode)
		}
		else
		{
			//默认签名角色为roleLevel最高的
			s tmpLevel = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(levelCode)
			if (tmpLevel > level)
			{
				s level = tmpLevel
				s code = levelCode
				s desc = levelDesc
			}
		}	
		
		s:(range '= "[") range =range_","
		s range = range_"{"
		s range = range_"""LevelCode"":"""_levelCode_""","
		s range = range_"""LevelDesc"":"""_levelDesc_""""
    	s range = range_"}"
	}
	s range = range_"]"
	s result = code_"^"_desc_"^"_range
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       根据InstanceID取签名角色
/// Creator:    Donglulu
/// CreateDate: 2020-7-16
/// Input:      AInstanceID 病历ID
///            AUserID 用户ID
///            AUserLocID 科室ID
///            AEpisodeID 就诊号
/// Output:     签名角色code^签名角色描述
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetInstanceSignCharacter("274||23","10210","3","170")
ClassMethod GetInstanceSignCharacter(AInstanceID As %String, AUserID As %String, AUserLocID As %String, AEpisodeID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "")||(AUserID = "") result
	s result = ##Class(EMRservice.BL.BLSignRole).GetSignedCharacter(AInstanceID,AUserID)
	q:(result '= "") result
	s result = ##Class(EMRservice.BL.BLSignRole).GetUserCharacter(AUserID,AUserLocID,AEpisodeID)
	q result
}

/// Desc:       取该用户在此InstanceID上签过名的最高级别的签名角色
/// Creator:    Donglulu
/// CreateDate: 2020-7-16
/// Input:      AInstanceID 病历ID
///            AUserID 用户ID
/// Output:     该用户在此InstanceID上签过名的签名角色code^desc
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetSignedCharacter("","")
ClassMethod GetSignedCharacter(AInstanceID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "")||(AUserID = "") result
	s characterCode = ""
	s characterLevel = ""
	s signID = ""
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_$zcvt(AInstanceID,"U"),signID))
		q:(signID = "")
		s signObj = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(signObj = "")
		continue:(signObj.UsrID '= AUserID)
		continue:(signObj.isSignValid '= "1")
		s action = signObj.Action
		continue:(action = "")
		s roleID = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(roleID = "")
		s roleObj = ##Class(EMRmeta.SignRole).%OpenId(roleID)
		continue:(roleObj = "")
		s tmpLevel = roleObj.RoleLevel
		if (tmpLevel > characterLevel)
		{
			s characterLevel = tmpLevel
			s characterCode = roleObj.Name
		}
	}
	q:(characterCode = "") result
	s characterDesc = ##Class(EMRservice.BL.BLSignRole).GetSignDesc(characterCode)
	s result = characterCode_"^"_characterDesc
	q result
}

/// Desc:       取用户级别和职称的最高级
/// Creator:    Donglulu
/// CreateDate: 2020-7-16
/// Input:      AUserID 用户ID
///             AUserLocID 科室ID
///             AEpisodeID 就诊号
/// Output:     最高级别签名角色code（对应EMRmeta.SignRole表的Name字段）^最高级别签名角色描述
/// Debug:      w ##Class(EMRservice.BL.BLSignRole).GetUserCharacter(10210,3,"170")
ClassMethod GetUserCharacter(AUserID As %String, AUserLocID As %String, AEpisodeID As %String) As %String
{
	s result = ""
	q:(AUserID = "")||(AUserLocID = "")||(AEpisodeID = "") result
	s characterCode = ""
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(AUserID,AEpisodeID,AUserLocID)
	s characterCode = $p(userLevel,"^",1)
	s userPost = ##class(EMRservice.BL.BLSignRole).GetUserHighestPost(AUserID,AUserLocID)
	s isUserLevelHigher = ##Class(EMRservice.BL.BLSignRole).IsUserLevelHigher(userPost,characterCode)
	s:(isUserLevelHigher = "1") characterCode = userPost
	s characterDesc = ##Class(EMRservice.BL.BLSignRole).GetSignDesc(characterCode)
	s result = characterCode_"^"_characterDesc
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       取用户EMRmeta.SignRole的RoleLevel最高的职称
///  Input:      AUserID:用户ID
///  		     AUserLoc：用户科室
///  return:     result 用户最高EMRmeta.SignRole的Name
///  Debug:      w ##Class(EMRservice.BL.BLSignRole).GetUserHighestPost("","")
ClassMethod GetUserHighestPost(AUserID As %String, AUserLoc As %String) As %String
{
	s result = ""
	s levelSource = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("LevelSource","EMR")
	if (levelSource = "EMR")
	{
		//取电子病历
		s result = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(AUserID)
	}
	else
	{
		//取HIS,以下代码按照EMRmeta.SignRole的RoleLevel由高到低写
		
		//是否是质控医师
		s isQCDoctor = ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos(AUserID,"QCDoc",AUserLoc)
		q:(isQCDoctor = "1") "QCDoc"
		
		//是否是科主任
		s isChairman = ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos(AUserID,"Chairman",AUserLoc)
		q:(isChairman = "1") "Chairman"
		
		//是否是诊疗组组长
		s isGroupLeader = ##Class(EMRservice.HISInterface.GetHisUserPost).IsUserPos(AUserID,"GroupLeader",AUserLoc)
		q:(isGroupLeader = "1") "GroupLeader"
		
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-07-16
///  Desc:       获取不需要验证，任何人都可签名的签名单元（EMRmeta.SignRole的NotValidate为1）
///  Input:      
///  return:     result 任何人都可签名的签名单元EMRmeta.SignRole的Name(例:^QCDoc^All^)
///  Debug:      w ##Class(EMRservice.BL.BLSignRole).GetNotValidateOriSign()
ClassMethod GetNotValidateOriSign() As %String
{
	s result = ""
	s id = ""
	for
	{
		s id = $o(^DHCEMRM.SignRoleI("IdxNotValidate"," 1",id))
		q:(id = "")
		s roleObj = ##Class(EMRmeta.SignRole).%OpenId(id)
		continue:(roleObj = "")
		continue:(roleObj.Name = "")
		s result = result_"^"_roleObj.Name
	}
	s:(result '= "") result = result_"^"
	q result
}

}
