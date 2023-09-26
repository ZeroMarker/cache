/// 名称:	EMR.DOC.BL.SignRole
/// 描述:	签名角色业务类
/// 编写者:	yejian
/// 编写日期: 2022-4-21
/// 产品组：电子病历产品组
Class EMR.DOC.BL.SignRole Extends EMR.DOC.COM.ActionBase
{

/// Desc:       取签名角色
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aUser 签名对象
/// Output:     
/// Return:		成功 签名角色code^签名角色描述^签名角色范围，失败 -1^失败信息
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetSignCharacter("Check",10210,"132","170")
ClassMethod GetSignCharacter(aUser As EMR.DOC.DTO.SignUser) As %String
{
	s strRes = ""
	s signCharacter = ""
	q:(aUser.OriSignatureLevel = "")||(aUser.UserID = "")||(aUser.UserLocID = "") "-1^角色编码、用户ID、科室ID不能为空"
	s signID = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(aUser.OriSignatureLevel,"U"),""))
	q:(signID="") "-1^获取签名ID失败"
	
	if (aUser.OriSignatureLevel = "Check") //三级审核
	{
		//用户职称（签名单元为多级医师审核）
		s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUser.UserID,aUser.EpisodeID,aUser.UserLocID,aUser.Product,aUser.LangID)
		s signCharacter = $p(userLevel,"^",1)
		//判断能否在多级医师审核签名单元签名
		s signRoleID = $o(^CF.EMR.DOC.SignRoleI("IdxNameCanSignOnCheck"," "_$zcvt(signCharacter,"U")," 1",""))
		s:(signRoleID = "") signCharacter = "" 
		//兼容高级别医师可向下选择级别签名，例：主任医师选择主治医师签名角色进行签名
		s defValue = {"IsEnable":"Y","Chief":"Chief^ViceChief^Attending^Resident","ViceChief":"ViceChief^Attending^Resident","Attending":"Attending^Resident","Resident":"Resident"}
		s strRange = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("selectUserLevelRange",aUser.Product,defValue.%ToJSON())
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(strRange)
		if (objJson.IsEnable = "Y")
		{
			s rangeData = ""
			s rangeData = objJson.%Get(signCharacter)
			s signCharacter =$case(rangeData,"":signCharacter,:rangeData)
		}
		//用户职务(是否诊疗组组长、科主任等)
		s userPost = ##class(EMR.DOC.BL.SignRole).GetUserCheckPost(aUser.UserID,aUser.UserLocID)
		s:((signCharacter '= "")&&(userPost '= "")) signCharacter = signCharacter_"^" 
		s:(userPost '= "") signCharacter = signCharacter_userPost
	}
	elseif ($o(^CF.EMR.DOC.SignRoleI("IdxNameNotValidate"," "_$zcvt(aUser.OriSignatureLevel,"U")," 1","")) '= "") //不验证
	{
		//签名单元为谁都能签名（不验证用户级别和职称，如：参与者签名，质控医师，质控护士，责任护士）
		s signCharacter = aUser.OriSignatureLevel
	}
	elseif ($o(^CF.EMR.DOC.SignRoleLinkCPTI("IdxSignRoleCPT",signID,"")) '= "") //取HIS医师级别
	{
		//签名单元为级别
		s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUser.UserID,aUser.EpisodeID,aUser.UserLocID,aUser.Product,aUser.LangID)
		s levelCode = $p(userLevel,"^",1)
		s isUserLevelHigher = ##Class(EMR.DOC.BL.SignRole).IsUserLevelHigher(levelCode,aUser.OriSignatureLevel)
		s:(isUserLevelHigher = "1") signCharacter = aUser.OriSignatureLevel
	}
	else
	{
		s isOriSign = ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos(aUser.UserID,aUser.OriSignatureLevel,aUser.UserLocID)
		s:(isOriSign = "1") signCharacter = aUser.OriSignatureLevel
	}
	
	s strRes = ##Class(EMR.DOC.BL.SignRole).GetSignCharacterInfo(signCharacter,aUser.LangID)
	s strRes = $ZSTRIP(strRes,"*C")
	q strRes
}

///  Desc:       用户可在多级医师审核单元签名的职务集合
/// Creator:    yejian
/// CreateDate: 2022-9-14
///  Input:      AUserID:用户ID
///  		     AUserLoc：科室ID
///  return:     该用户的职务代码，多个以^分隔，没有职务返回空（例：Chairman^GroupLeader）
///  Debug:      w ##Class(EMR.DOC.BL.SignRole).GetUserCheckPost("10209","3")
ClassMethod GetUserCheckPost(AUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""

	//取HIS
	s name = ""
	for
	{
		s name = $o(^CF.EMR.DOC.SignRoleI("IdxNameCanSignOnCheck",name))
		q:(name = "")
		s rowID = $o(^CF.EMR.DOC.SignRoleI("IdxNameCanSignOnCheck",name," 1",""))
		continue:(rowID = "")
		
		//签名单元是职称调过
		s cptCode = $o(^CF.EMR.DOC.SignRoleLinkCPTI("IdxSignRoleCPT",rowID,""))
		continue:(cptCode '= "")
		
		s oriObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowID)
		continue:(oriObj = "")
		
		//用户不是该职务退出
		s isPost = ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos(AUserID,oriObj.Name,AUserLoc)
		continue:(isPost '= "1")
		
		s:(strRes '= "") strRes = strRes_"^"
		s strRes = strRes_oriObj.Name
	}
	
	q strRes
}

/// Desc:		判断签名单元的最高级
/// Creator:    yejian
/// CreateDate: 2022-9-14
/// Input:      aSignLevels 签名单元上所有签名的角色(json数组) [{"signLevel":"Resident","signUserID":"6"}]
/// Output:     签名单元的最高级别
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).getHighestSignLevel("")
ClassMethod GetHighSignLevel(aSignLevels As %DynamicArray) As %String
{
	s strRes = ""
	q:(aSignLevels = "")||(aSignLevels.%Size()<=0) strRes
	s tmpLevel=""
	s iter = aSignLevels.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s objitem = item
        continue:(objitem="")
		s nowLevel = objitem.signLevel
		s nowSignUserID = objitem.signUserID
		if (tmpLevel = "")
		{
			s tmpLevel = nowLevel
			s strRes = nowLevel_"^"_nowSignUserID
		}
		else
		{
			if (##Class(EMR.DOC.BL.SignRole).IsUserLevelHigher(nowLevel,tmpLevel) = "1")
			{
				s strRes = nowLevel_"^"_nowSignUserID
			}
		}
	}
	q strRes
}

/// Desc:  		判断用户级别是否大于等于签名单元级别(判断第一个入参级别是否大于等于第二个入参级别)
/// Creator:    yejian
/// CreateDate: 2020-7-16
/// Input:      AUserLevel EMRmeta.SignRole表的Name
/// 		    AOriSignatureLevel EMRmeta.SignRole表的Name
/// Output:     1 第一个入参在EMRmeta.SignRole表的RoleLevel大于等于第二个入参的/0 第一个入参小于第二个
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).IsUserLevelHigher("Attending","Resident")
ClassMethod IsUserLevelHigher(AUserLevel As %String, AOriSignatureLevel As %String) As %String
{
	s strRes = "0"
	q:(AUserLevel = "")||(AOriSignatureLevel = "") strRes
	s userRoleId = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AUserLevel,"U"),""))
	q:(userRoleId = "") strRes
	s userObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(userRoleId)
	q:(userObj = "")
	s userLevelNum = userObj.RoleLevel
	s oriRoleId = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AOriSignatureLevel,"U"),""))
	q:(oriRoleId = "") strRes
	s oriObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(oriRoleId)
	q:(oriObj = "")
	s oriLevelNum = oriObj.RoleLevel
	s:(userLevelNum >= oriLevelNum) strRes = "1"
	q strRes
}

/// Desc:		取用户级别
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:     	aUserID 用户ID，aEpisodeID 就诊号，aLocID 科室ID,aProduct 项目标识
/// Output:      级别代码^级别描述
/// Debug:       w ##Class(EMR.DOC.BL.SignRole).GetUserLevel(105)
ClassMethod GetUserLevel(aUserID As %String, aEpisodeID As %String = "", aLocID As %String = "", aProduct As %String, aLangID As %String = "20") As %String
{
	s strRes = ""
	q:(aUserID = "") strRes
	s levelSource = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("levelSource",aProduct,"HIS")
	
	if ($zcvt(levelSource,"U") = "HIS")
	{
		s userLevel = ##class(EMR.DOC.BL.UserData).GetUserDatalevel(aUserID,aLangID)
		s levelCode = $p(userLevel,"^",1)
		s levelDesc = $p(userLevel,"^",2)
		s signLevel = $p(userLevel,"^",3)
	}
	elseif (($zcvt(levelSource,"U") = "EPISODEID")&&(aEpisodeID '="") )
	{
		s strRes = ##Class(EMR.DOC.BL.UserData).GetUserLevelByEpisode(aUserID,aEpisodeID,aLocID)
		if (strRes = "")
		{
			s userLevel =  ##class(EMR.DOC.BL.UserData).GetUserDatalevel(aUserID,aLangID)
			s levelCode = $p(userLevel,"^",1)
			s levelDesc = $p(userLevel,"^",2)
			s signLevel = $p(userLevel,"^",3)
		}
	}
	s:(strRes = "") strRes = levelCode_"^"_levelDesc_"^"_signLevel
	q strRes
}

/// Desc:       获取弹出签名框时，获取签名角色范围
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:      签名角色（多个以"^"分隔）
/// Output:     最高级别签名角色code^最高级别签名角色描述^签名角色范围json
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetSignCharacterInfo("Chief")
ClassMethod GetSignCharacterInfo(ARole As %String, aLangID As %String = "20") As %String
{
	s strRes = ""
	q:(ARole = "") "-1^无权限,请维护用户级别" 
	s code = ""
	s level="-1"
	s arrJson = ##class(%DynamicArray).%New()
	s count=$l(ARole, "^")
	for i=1:1:count 
	{
		s levelCode = $p(ARole, "^", i)
		q:(levelCode = "")
		s levelDesc = ##Class(EMR.DOC.BL.SignRole).GetSignDesc(levelCode,aLangID)
		s roleLevel = ##Class(EMR.DOC.BL.SignRole).GetSignLevel(levelCode)
		//默认选中最高级别
		if (roleLevel > level)
		{
			s level = roleLevel
			s code = levelCode
		}
		s objJson = ##class(%DynamicObject).%New()
		s objJson.signLevel = levelCode
		s objJson.levelName = levelDesc
		s objJson.roleLevel = roleLevel
    	d arrJson.%Push(objJson)
	}
	//设置最高级别选中
	set iter = arrJson.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s objitem = item
        if (objitem.signLevel =code)
        {
	        d item.%Set("selected","true")
	        q
        }
	}
	s strRes = arrJson.%ToJSON()
	s strRes = $ZSTRIP(strRes,"*C")
	q strRes
}

/// Desc:       根据InstanceID取签名角色
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:      aUser 签名对象
/// Output:     签名角色code^签名角色描述
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetDocSignCharacter("33","10210","3","170")
ClassMethod GetDocSignCharacter(aUser As EMR.DOC.DTO.SignUser) As %String
{
	s strRes = ""
	q:(aUser.DocumentID = "")||(aUser.UserID = "")||(aUser.EpisodeID = "") strRes
	s strRes = ##Class(EMR.DOC.BL.SignRole).GetSignedCharacter(aUser)
	q:(strRes '= "") strRes
	s strRes = ##Class(EMR.DOC.BL.SignRole).GetUserCharacter(aUser)
	q strRes
}

/// Desc:       取该用户在此InstanceID上签过名的最高级别的签名角色
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:      aDocumentID 病历ID
///            aUserID 用户ID
/// Output:     该用户在此InstanceID上签过名的签名角色code^desc
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetSignedCharacter("","")
ClassMethod GetSignedCharacter(aUser As EMR.DOC.DTO.SignUser) As %String
{
	s strRes = ""
	q:(aUser.DocumentID = "")||(aUser.UserID = "")||(aUser.EpisodeID = "") strRes
	s characterCode = ""
	s characterLevel = ""
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(aUser.EpisodeID)
	s signID = ""
	for
	{
		s signID = $o(@TILEMRSign@("IdxDocument",aUser.DocumentID,signID))
		q:(signID = "")
		s signObj = ##Class(EMR.DAO.EMRSign).doOpenByID(aUser.EpisodeID,signID)
		q:(signObj = "")
		s signUserID = signObj.UsrID.%Id()
		continue:(signUserID '= aUser.UserID)
		continue:(signObj.isValid '= "1")
		s action = signObj.Action
		continue:(action = "")
		s roleID = $o(^CF.EMR.DOC.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(roleID = "")
		s roleObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(roleID)
		continue:(roleObj = "")
		s tmpLevel = roleObj.RoleLevel
		if (tmpLevel > characterLevel)
		{
			s characterLevel = tmpLevel
			s characterCode = roleObj.Name
		}
	}
	q:(characterCode = "") strRes
	s characterDesc = ##Class(EMR.DOC.BL.SignRole).GetSignDesc(characterCode,aUser.LangID)
	s strRes = characterCode_"^"_characterDesc_"^"_characterLevel
	q strRes
}

/// Desc:       取用户级别和职称的最高级
/// Creator:	yejian
/// CreateDate:	2022-9-14
/// Input:      aUserID 用户ID
///             aUserLocID 科室ID
///             aEpisodeID 就诊号
/// Output:     最高级别签名角色code（对应EMRmeta.SignRole表的Name字段）^最高级别签名角色描述
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetUserCharacter(10210,3,"170")
ClassMethod GetUserCharacter(aUser As EMR.DOC.DTO.SignUser) As %String
{
	s strRes = ""
	q:(aUser.UserID = "")||(aUser.UserLocID = "")||(aUser.EpisodeID = "") strRes
	s characterCode = ""
	s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUser.UserID,aUser.EpisodeID,aUser.UserLocID,aUser.Product,aUser.LangID)
	s characterCode = $p(userLevel,"^",1)
	s userPost = ##class(EMR.DOC.BL.SignRole).GetUserHighestPost(aUser.UserID,aUser.UserLocID)
	s isUserLevelHigher = ##Class(EMR.DOC.BL.SignRole).IsUserLevelHigher(userPost,characterCode)
	s:(isUserLevelHigher = "1") characterCode = userPost
	s characterDesc = ##Class(EMR.DOC.BL.SignRole).GetSignDesc(characterCode,aUser.LangID)
	s signLevel = ##Class(EMR.DOC.BL.SignRole).GetSignLevel(characterCode)
	s strRes = characterCode_"^"_characterDesc_"^"_signLevel
	q strRes
}

///  Desc:       取用户EMRmeta.SignRole的RoleLevel最高的职称
/// Creator:	yejian
/// CreateDate:	2022-9-14
///  Input:      aUserID:用户ID
///  		     AUserLoc：用户科室
///  return:     strRes 用户最高EMRmeta.SignRole的Name
///  Debug:      w ##Class(EMR.DOC.BL.SignRole).GetUserHighestPost("","")
ClassMethod GetUserHighestPost(aUserID As %String, AUserLoc As %String) As %String
{
	s strRes = ""

	//是否是质控医师
	s isQCDoctor = ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos(aUserID,"QCDoc",AUserLoc)
	q:(isQCDoctor = "1") "QCDoc"
	
	//是否是科主任
	s isChairman = ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos(aUserID,"Chairman",AUserLoc)
	q:(isChairman = "1") "Chairman"
	
	//是否是诊疗组组长
	s isGroupLeader = ##Class(EMR.DOC.HISInterface.HISUserPostSrv).IsUserPos(aUserID,"GroupLeader",AUserLoc)
	q:(isGroupLeader = "1") "GroupLeader"
	
	q strRes
}

/// Desc:  		获取EMRmeta.SignRole的RoleLevel相同的action集合，以^分隔
/// Creator:    董璐璐
/// CreateDate: 2020-8-10
/// Input:      AAction:签名动作代码
/// Output:     EMRmeta.SignRole的RoleLevel相同的action集合，以^分隔
/// Debug:      w ##Class(EMR.DOC.BL.SignRole).GetSameRoleLevelAction("chairmanCheck")
ClassMethod GetSameRoleLevelAction(AAction As %String) As %String
{
	s result = ""
	q:(AAction = "") result
	
	s rowID = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(AAction,"U"),""))
	q:(rowID = "") result
	s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(rowID)
	q:(objSignRole = "") result
	s level = objSignRole.RoleLevel
	q:(level = "") result
	
	s id = ""
	for
	{
		s id = $o(^DHCEMRM.SignRoleI("IdxRoleLevel",level,id))
		q:(id = "")
		s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(id)
		continue:(objSignRole = "")
		continue:(objSignRole.ActionCode = "")
		s:(result '= "") result = result_"^"
		s result = result_objSignRole.ActionCode
	}
	
	q result
}

/// Desc:       根据角色Name取名称
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      AName 名称
/// Return:     名称
/// Debug: w ##Class(EMR.DOC.BL.SignRole).GetSignDesc("RESIDENT")
ClassMethod GetSignDesc(AName As %String, aLangID As %String = "20") As %String
{
	s strRes = ""
	q:(AName = "") strRes
	s rowId  = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") strRes
	s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	q:(obj = "") strRes
	s strRes = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.SignRole","Description",obj.Description,aLangID)
	q strRes
}

/// Desc:       根据角色Name取级别
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      AName 名称
/// Return:     名称
/// Debug: w ##Class(EMR.DOC.BL.SignRole).GetSignLevel("RESIDENT")
ClassMethod GetSignLevel(AName As %String) As %String
{
	s strRes = ""
	q:(AName = "") strRes
	s rowId  = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") strRes
	s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	q:(obj = "") strRes
	s strRes = obj.RoleLevel
	q strRes
}

/// Desc:       根据操作代码取名称
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      AActionCode 操作代码
/// Return:     名称
/// Debug: w ##Class(EMR.DOC.BL.SignRole).GetSignName("RESIDENT")
ClassMethod GetSignName(AActionCode As %String) As %String
{
	s strRes = ""
	q:(AActionCode = "") strRes
	s rowId  = $o(^CF.EMR.DOC.SignRoleI("IdxActionCode"," "_$zcvt(AActionCode,"U"),""))
	q:(rowId = "") strRes
	s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	q:(obj = "") strRes
	s strRes = obj.Name
	q strRes
}

/// Desc:       根据name取操作代码
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      AName 角色编码
/// Return:     名称
/// Debug: w ##Class(EMR.DOC.BL.SignRole).GetSignCode("chief")
ClassMethod GetSignCode(AName As %String) As %String
{
	s strRes = ""
	q:(AName = "") strRes
	s rowId  = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") strRes
	s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
	q:(obj = "") strRes
	s strRes = obj.ActionCode
	q strRes
}

/// 初始化数据
/// d ##Class(EMR.DOC.BL.BLSignRole).IniData()
ClassMethod IniData()
{
		k ^CF.EMR.DOC.SignRoleI,^CF.EMR.DOC.SignRoleD
	d ..AddSignRole("Chairman","科主任","chairmanCheck","1",50,0,0,0)
	d ..AddSignRole("QCDoc","质控医师","qcdocCheck","1",70,0,0,1)	
   	d ..AddSignRole("QCNurse","质控护士","qcnurseCheck","1",70,0,0,1)
    d ..AddSignRole("ChargeNurse","责任护士","chargenurseCheck","1",0,0,0,1)
    d ..AddSignRole("student","学生","studentCheck","1",0,1,1,0)
	d ..AddSignRole("intern","实习医师","internCheck","1",0,1,1,0)
	d ..AddSignRole("Resident","住院医师","residentCheck","1",10,0,1,0)
	d ..AddSignRole("Attending","主治医师","attendingCheck","1",20,0,1,0)
	d ..AddSignRole("ViceChief","副主任医师","viceChiefCheck","1",30,0,1,0)
	d ..AddSignRole("Chief","主任","chiefCheck","1",30,0,1,0)
	d ..AddSignRole("All","医师","participantCheck","1",80,0,0,1)
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
	d ..AddSignRole("Doctor","医生","doctorCheck","1",80,0,0,0)
	d ..AddSignRole("Nurse","护士","nurseCheck","1",0,0,0,0)
}

ClassMethod AddSignRole(AName, ADescription, AActionCode, AIsValid, ARoleLevel, ASignPrefix, ACanSignOnCheck, ANotValidate) As %String
{
	s result = 0
	s rowId = $o(^CF.EMR.DOC.SignRoleI("NameIndex"," "_$zcvt(AName,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(CF.EMR.DOC.SignRole).%New()
	}
	else
	{
		s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
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

/// Creator:	huhao
/// CreatDate:  
/// Desc:		获取签名角色（含查询）
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod SelectSignRole(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Name=argInJson.params.name
	s Desc=argInJson.params.desc
    s strRes = ##class(EMR.DOC.BL.SignRole).SelectRole(Name,Desc,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到签名角色信息",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod SelectRole(Name As %String, Desc As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s name = ""
	s count= 1
	s resJsonArray=##class(%DynamicArray).%New()
	for i=1:1:23
	{
		s name = $o(^CF.EMR.DOC.SignRoleI("NameIndex",name))
		q:(name = "")
		s rowId = $o(^CF.EMR.DOC.SignRoleI("NameIndex",name,""))
		continue:(rowId = "")
		s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
		continue:(obj = "")
		;q:Name=""&&Desc=""
		if ((Name="") && (Desc'=""))
		{
			if ($find(obj.Description,Desc)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name'="") && (Desc=""))
		{
			if ($find(obj.Name,Name)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name'="") && (Desc'=""))
		{
			if ($find(obj.Description,Desc)'=0 && $find(obj.Name,Name)'=0)
			{
				d setJson
			}	
			else
			{
				break
			}
		}
		elseif ((Name="") && (Desc=""))
		{
			d setJson
		}
	}
	d resJsonArray.%ToJSON(argOutData)
	q "1"
setJson
	s resultJson=##class(%DynamicObject).%New()
	s resultJson.key=count
	s resultJson.name=obj.Name
	s resultJson.desc=obj.Description
	s resultJson.actioncode=obj.ActionCode
	s resultJson.rolelevel=obj.RoleLevel
	s:(obj.SignPrefix="1") resultJson.signprefix=1
	s:(obj.SignPrefix="0") resultJson.signprefix=0
	s:(obj.CanSignOnCheck="1") resultJson.cansignoncheck=1
	s:(obj.CanSignOnCheck="0") resultJson.cansignoncheck=0
	s:(obj.NotValidate="1") resultJson.notvalidate=1
	s:(obj.NotValidate="0") resultJson.notvalidate=0
	d resJsonArray.%Push(resultJson)
	s count =count+1
}

/// Creator:	huhao
/// CreatDate:  
/// Desc:		修改签名角色权限
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod UpdateRoleRoot(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorMsg"
	s Name=argInJson.params.name
	s PrefixFlag=argInJson.params.signprefix
	s SignCheckFlag=argInJson.params.cansignoncheck
	s NotValidateFlag=argInJson.params.notvalidate
    s strRes = ##class(EMR.DOC.BL.SignRole).UpdateRole(Name,PrefixFlag,SignCheckFlag,NotValidateFlag)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","修改失败",2)
	}
ErrorMsg
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Creator:	huhao
/// CreatDate:  2021/11/1
/// Desc:		签名角色权限修改
/// Input：		
ClassMethod UpdateRole(Name As %String, PrefixFlag As %String, SignCheckFlag As %String, NotValidateFlag As %String) As %String
{
	s result=""
	q:Name="" "Name不能为空"
	s SName=Name,rowkey=""
	&sql(select ID INTO :rowkey from CF_EMR_DOC.SignRole where Name=:SName)
	s Rowkey=rowkey
	s obj=##class(CF.EMR.DOC.SignRole).%OpenId(Rowkey)
	s obj.SignPrefix=PrefixFlag
	s obj.CanSignOnCheck=SignCheckFlag
	s obj.NotValidate=NotValidateFlag
	s sc=obj.%Save()
	q "1"
}

}
