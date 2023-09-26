Class EMRservice.BL.BLPrivRuleView Extends %RegisteredObject
{

/// 获取病历权限类型
/// w ##class(EMRservice.BL.BLPrivRuleView).GetPrivRuleType()
ClassMethod GetPrivRuleType() As %String
{
	s json=[]
	s total=0
	s tmpID=""
	for
	{
		s tmpID = $o(^DHCEMRM.PrivRuleTypeD(tmpID))
		q:(tmpID="")
		s obj = ##class(EMRmeta.PrivRuleType).%OpenId(tmpID)
		continue:(obj="")
		
		s jsonsub = {}
		s jsonsub.id = obj.%Id()
		s jsonsub.name = obj.Name
		s jsonsub.description = obj.Description
		s total=total+1
		
		d json.%Push(jsonsub)
	}
	q json.%ToJSON()
}

/// d ##class(EMRservice.BL.BLPrivRuleView).GetPrivRuleStore("","")
ClassMethod GetPrivRuleStore(APrivRuleType As %String, AHospGroupID As %String = "2") As %String
{
	s json=[]
	s total=0
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLPrivRuleStore:GetPrivRuleStore")
	d result.Execute()
	
	while(result.%Next())
	{
		
		s jsonsub = {}
		s jsonsub.storeid = result.Data("ID")
		s jsonsub.storename = result.Data("RuleDesc")
		s jsonsub.storecode = result.Data("RuleCode")
		
		s total=total+1
		d json.%Push(jsonsub)
	}
	
	
	
	q json.%ToJSON()
}

/// 获取当前类型规则
/// w ##class(EMRservice.BL.BLPrivRuleView).GetPrivRule(2,"ActionPrivilege")
ClassMethod GetPrivRule(AHospGroupId As %String, APrivRuleType As %String = "") As %String
{
	
	s json = {}
	s quitJson = json.%ToJSON()
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLPrivRuleDetail:GetPrivRuleDetail")
	d result.%Execute()

	s json=[]
	s total=0
	
	while(result.%Next())
	{
		s RuleType = result.Data("RuleType")
		continue:(RuleType'=APrivRuleType)
		
		s RuleId = result.Data("RuleID")
		continue:(privRuleId '= RuleId)
		
		s jsonsub = {}
		s jsonsub.id = result.Data("ID")
		s jsonsub.storeid = result.Data("RuleStoreID")
		s jsonsub.storename = result.Data("RuleStoreName")
		s jsonsub.storecode = result.Data("RuleStoreCode")
		s jsonsub.isactive = $case(result.Data("RuleStoreIsActive"),"1":"启用","0":"停用",:"停用")
		s jsonsub.ruletype = result.Data("RuleType")
		s jsonsub.ruletypeid = result.Data("RuleTypeID")
		s jsonsub.sequece = result.Data("Sequence")
		s jsonsub.privruleid = result.Data("RuleID")
		
		s total=total+1
		d json.%Push(jsonsub)
	}

	q json.%ToJSON()
}

ClassMethod DeletePrivRule(AHospGroupId As %String, APrivRuleType As %String, APrivRuleDetailID As %String)
{
	s json = {}
	s quitJson = json.%ToJSON()

	q:(APrivRuleDetailID="") quitJson
		
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	//存储Detail数据,生成脚本原文
	s privRuleScript= ##class(EMRservice.BL.BLPrivRuleDetail).GetPrivRuleScriptAftDelete(APrivRuleDetailID,privRuleId)
	
	//生成PrivRule数据
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	s objPrivRule.Code = privRuleScript
	s sc = objPrivRule.%Save()
	
	if ($$$ISOK(sc))
	{
		s json.status = "suc"
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// 存储当前类型权限规则
/// w ##class(EMRservice.BL.BLPrivRuleView).SavePrivRule(2,"ActionPrivilege","{""total"":3,""rows"":[{""storeid"":""126"",""storename"":""病历删除权限，需要在病历保存后才可"",""storecode"":""if ($$IsSaved$$=1) { s delte=1 }""},{""storeid"":""128"",""storename"":"" 非本科室医师不可创建、修改病历等。"",""storecode"":""if ('$$BelongToLoc$$) { s save=0,print=0,delte=0,check=0,recheck=0,export=0,copypaste=0,reference=0,view=0}""},{""storeid"":""129"",""storename"":""确认病历全部完成的病历，可以通过权限脚本控制，使其不能保存删除等"",""storecode"":""if ($$IsRecordCompleted$$) {s delte=0,save=0}""}]}")
ClassMethod SavePrivRule(AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String)
{
	s json = {}
	s quitJson = json.%ToJSON()

	q:((APrivRuleType="")||(AHospGroupId="")) quitJson
		
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	//存储Detail数据,生成脚本原文
	s privRuleScript= ##class(EMRservice.BL.BLPrivRuleDetail).GetPrivRuleScript(APrivRuleJsonString,privRuleId,AHospGroupId)
	
	//生成PrivRule数据
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	s objPrivRule.Code = privRuleScript
	s sc = objPrivRule.%Save()
	
	if ($$$ISOK(sc))
	{
		s json.status = "suc"
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).GetPrivRuleConfig(2,"ActionPrivilege")
ClassMethod GetPrivRuleConfig(AHospGroupId As %String, APrivRuleType As %String)
{
	s json = {}
	s quitJson = json.%ToJSON()
	
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	
	s data = $case(objPrivRule.Valid,1:"true",0:"false",:"false")
	
	d objPrivRule.%Close()
	s objPrivRule=""
	

	s json.status = "suc"
	s json.data = data
	
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).GetHospGroupID()
ClassMethod GetHospGroupID(AHospID As %String) As %String
{
	q:(AHospID="") ""
	s CTHospital = $g(^CT("HOSP",AHospID))
	s GroupDr = $p(CTHospital,"^",41)
	q GroupDr
}

/// privstore存储的为医院id，需要进行医院组验证
ClassMethod CheckHospGroup(AHospGroupID As %String = "", AHospitalIDs As %String = "") As %String
{
	//debugger//
	q "Y"
	//debugger//
	
	s ret="N"
	q:((AHospGroupID="")||(AHospitalIDs="")) ret
	
	s length= $l(AHospitalIDs,"^")
	
	for num=1:1:length
	{
		s hospitalId = $p(AHospitalIDs,"^",num)
		
		s objHosp = ##class(User.CTHospital).%OpenId(hospitalId)
		s hospGroup = objHosp.HOSPDefaultHospitalDR
		continue:(hospGroup '=AHospGroupID)
		s ret="Y"
		q
	}
	
	q ret
}

/// 说明：将现有项目脚本转化为脚本仓库数据。供后续整理工作开展
/// Creater:lifengbo
/// Date:2021-12-01
/// 入参：AHospGroupId院组ID，APrivRuleType权限类型。
/// 返回值：json数据，记录成功失败状态。
/// debugger:d ##class()
ClassMethod MoveScriptToStore(AHospGroupId As %String, APrivRuleType As %String)
{
	s json = {}
	s quitJson = json.%ToJSON()

	
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	
	s privRuleScript = objPrivRule.Code
	
	s privRuleScriptList = $lfs(privRuleScript,$c(10))
	s dataReady = $lb("","")
	for i=1:1:$ll(privRuleScriptList)
	{
		s value = $list(privRuleScriptList,i)
		
		if ($e(value,1,2)= "//")
		{
			s:($zstrip(value,"*NPLU")="") value=""
			s $list(dataReady,1) = value
		}
		else
		{
			s $list(dataReady,2) = value
		}
		
		if ($list(dataReady,2)'="")
		{
		
			s objPrivRuleStore = ##class(EMRmeta.PrivRuleStore).%New()
			s objPrivRuleStore.DefaultRule=1
			s objPrivRuleStore.HospitalIDs=AHospGroupId
			s objPrivRuleStore.RuleCode = $list(dataReady,2)
			s objPrivRuleStore.RuleDesc = $e($list(dataReady,1),3,*)
			s objPrivRuleStore.RuleTypeID = ..GetPrivRuleTypeID(APrivRuleType)
			
			s sc = objPrivRuleStore.%Save()
			if ($$$ISERR(sc))
			{
				q
			}
			else
			{
				s dataReady = $lb("","")
			}
		}
		
		
	}
	
	if ($$$ISOK(sc))
	{
		s json.status = "suc"
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

ClassMethod CheckScript(AHospGroupId As %String, APrivRuleType As %String) As %String
{
	s json = {}
	s quitJson = json.%ToJSON()

	
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	
	s data = ##Class(EMRservice.BL.BLPrivRule).Test(privRuleId,"userid^3928!admid^201871!patientid^1!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1")
	
	s logdata = "权限脚本出错！"
	s:(data=1) logdata = "权限脚本正确！"
	s:(data=-1) logdata = "权限脚本不存在"
	
	s json.status = "suc"
	
	s json.data = logdata

	q json.%ToJSON()
}

/// 存储当前类型权限规则
/// w ##class(EMRservice.BL.BLPrivRuleView).CheckPrivRuleStore(2,"ActionPrivilege","{""total"":3,""rows"":[{""id"":""20"",""storeid"":""120"",""storename"":""初始删除权限为0"",""storecode"":""s delete=0"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""9"",""privruleid"":""1""},{""id"":""21"",""storeid"":""120"",""storename"":""初始删除权限为0"",""storecode"":""s delete=0"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""10"",""privruleid"":""1""},{""id"":""22"",""storeid"":""126"",""storename"":""病历删除权限，需要在病历保存后才可"",""storecode"":""if ($$IsSaved$$=1) { s delete=1 }"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""11"",""privruleid"":""1""},{""id"":""23"",""storeid"":""134"",""storename"":"""",""storecode"":""$$GetAppoint$$"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""12"",""privruleid"":""1""}]}")
ClassMethod CheckPrivRuleStore(AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String) As %String
{
	
	s json = {}
	s quitJson = json.%ToJSON()

	q:((APrivRuleType="")||(AHospGroupId="")) quitJson
		
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
		
	//存储Detail数据,生成脚本原文
	s checkPrivRuleScript= ##class(EMRservice.BL.BLPrivRuleDetail).CheckPrivRuleScript(APrivRuleJsonString,privRuleId)

	//输出结果
	s checkResultJson = {}.%FromJSON(checkPrivRuleScript)
	
	
	if (checkResultJson.%Size()>0)
	{
		s json.status = "suc"
		s json.data = checkResultJson
	}
	elseif (checkResultJson.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// ///////////////////////////////////////
/// Interface Method
/// ///////////////////////////////////////
/// 20210830
/// lifengbo
/// 依据医院GroupID、权限类型，获取EMRmeta.PrivRule数据的ID
/// 兼容未配置hospGroup
/// debugger:##class(EMRservice.BL.BLPrivRuleView).GetPrivRuleID("2","ActionPrivilege")
ClassMethod GetPrivRuleID(AHospGroupId As %String, APrivRuleType As %String) As %String
{
	s privRuleId = ""
	
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	s privRuleId=""
	s privRuleHosp=""
	if ($d(^DHCEMRM.PrivRuleHospitalD)'=0)
	{
		for
		{
			s privRuleHosp = $o(^DHCEMRM.PrivRuleHospitalI("IdxHosGroup"," "_AHospGroupId,privRuleHosp))
			q:(privRuleHosp="")
			
			s objPrivRuleHosp = ##class(EMRmeta.PrivRuleHospital).%OpenId(privRuleHosp)
			s privRuleTypeDr = objPrivRuleHosp.PrivRule.PrivRuleTypeDR
			
			continue:(PrivRuleTypeID '=privRuleTypeDr)
			s privRuleId =objPrivRuleHosp.PrivRule
			q
		}
	}
	else
	{
		s tmpPrivRuleId = ""
		for
		{
			s tmpPrivRuleId = $o(^DHCEMRM.PrivRuleD(tmpPrivRuleId))
			q:(tmpPrivRuleId="")
			
			s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(tmpPrivRuleId)
			
			continue:(PrivRuleTypeID '=objPrivRule.PrivRuleTypeDR)
			s privRuleId = tmpPrivRuleId
			q
		}
	
	}
	
	q privRuleId
}

ClassMethod GetRuleTypeByID(ARuleTypeID As %String) As %String
{
	q:(ARuleTypeID="") ""
	s obj=##class(EMRmeta.PrivRuleType).%OpenId(ARuleTypeID)
	q:(obj="") ""
	s ret= obj.Name
	q ret
}

ClassMethod GetPrivRuleTypeID(APrivRuleType As %String) As %String
{
	s PrivRuleTypeID = ""
	
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	q PrivRuleTypeID
}

/// 获取用户信息
/// /d ##class(EMRservice.BL.BLPrivRuleView).GetUserInfo()
ClassMethod GetUserInfo(AFilterText As %String = "") As %String
{
	s json = {}
	s quitJson = json.%ToJSON()

	s jsonUserData=[]
	s id=""
	for
	{
		s id=$o(^SSU("SSUSR",id))
		q:(id="")
		
		s userdata = $g(^SSU("SSUSR",id))
		s UserID=id
		s UserCode = $p(userdata,"^",1)
		s UserName = $p(userdata,"^",2)
		
		if (AFilterText'="")
		{
			continue:'((UserCode[AFilterText)||(UserName[AFilterText))
		}
		s jsonsub={}
		s jsonsub.userid = UserID
		s jsonsub.usercode = UserCode
		s jsonsub.username = UserName
		
		d jsonUserData.%Push(jsonsub)	
	}
	//输出结果
	
	if (jsonUserData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsonUserData
	}
	elseif (jsonUserData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// 获取用户登录信息
/// w ##class(EMRservice.BL.BLPrivRuleView).GetUserLogonInfo(10209)
ClassMethod GetUserLogonInfo(AUserID As %String = "", ACTLocDesc As %String = "") As %String
{
	s json = {}
	s quitJson = json.%ToJSON()
	q:(AUserID="") quitJson

	s jsonLogonData=[]
		
	s objUser = ##class(User.SSUser).%OpenId(AUserID,0)
	
	s DefaultLoc=objUser.SSUSRDefaultDeptDR.CTLOCDesc
	s DefaultGrp = $s($IsObject(objUser.SSUSRGroup):objUser.SSUSRGroup.SSGRPDesc,1:"")
	s DefaultHosp = $s($IsObject(objUser.SSUSRHospitalDR):objUser.SSUSRHospitalDR.HOSPDesc,1:"")
	
	s jsonsub={}
	s jsonsub.ctlocid = objUser.SSUSRDefaultDeptDR.%Id()
	s jsonsub.ctlocdesc = DefaultLoc
	
	s jsonsub.ssgroupid = objUser.SSUSRGroup.%Id()
	s jsonsub.ssgroupdesc	 = DefaultGrp
	
	s jsonsub.hospid = objUser.SSUSRHospitalDR.%Id()
	s jsonsub.hospdesc	 = DefaultHosp
	
	d jsonLogonData.%Push(jsonsub)	
	
	s myCount = objUser.ChildSSUserOtherLogonLoc.Count()
	f myIdx=1:1:myCount
	{
		s objUserLoc = objUser.ChildSSUserOtherLogonLoc.GetAt(myIdx)
		s DefaultLoc = objUserLoc.OTHLLCTLOCDR.CTLOCDesc
		s DefaultGrp = $s($IsObject(objUserLoc.OTHLLUserGroupDR):objUserLoc.OTHLLUserGroupDR.SSGRPDesc, 1:"")
		s DefaultHosp = $s($IsObject(objUserLoc.OTHLLHospitalDR):objUserLoc.OTHLLHospitalDR.HOSPDesc, 1:"")
		
	
		s jsonsub={}
		
		s jsonsub.ctlocid = objUserLoc.OTHLLCTLOCDR.%Id()
		s jsonsub.ctlocdesc = DefaultLoc
		
		s jsonsub.ssgroupid = objUserLoc.OTHLLUserGroupDR.%Id()
		s jsonsub.ssgroupdesc	 = DefaultGrp
		
		s jsonsub.hospid = objUserLoc.OTHLLHospitalDR.%Id()
		s jsonsub.hospdesc	 = DefaultHosp
		
		d jsonLogonData.%Push(jsonsub)
		s objUserLoc = ""
		
	}
	
	s objUser = ""
	//输出结果

	if (jsonLogonData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsonLogonData
	}
	elseif (jsonLogonData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).GetEnvParameter(string)
ClassMethod GetEnvParameter(AEnviromentInfo As %String = "")
{
	s json = {}
	s quitJson = json.%ToJSON()
	q:(AEnviromentInfo="") quitJson
	
	s jsonEnvIn={}.%FromJSON(AEnviromentInfo)
	
	s jsonEnvData=jsonEnvIn
	
	s jsonEnvData.patientid = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(jsonEnvData.admid)

	if (jsonEnvData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsonEnvData
	}
	elseif (jsonEnvData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).Test(2,"ActionPrivilege","{""userid"":""10209"",""admid"":""4"",""userloc"":""95"",""templateid"":""38"",""ssgroupid"":""29"",""categoryid"":""53"",""docid"":""52"",""patientid"":""8""}")
ClassMethod Test(AHospGroupId As %String, APrivRuleType As %String, argEnviromentInfo As %String, ACurPrivRuleDetailString As %String = "") As %String [ WebMethod ]
{
	s json = {}
	s quitJson = json.%ToJSON()

	q:((APrivRuleType="")||(AHospGroupId="")) quitJson
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)

	
	s aPrivRule=##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	q:(aPrivRule="") quitJson

	s aPrivRuleType=##class(EMRmeta.PrivRuleType).%OpenId(aPrivRule.PrivRuleTypeDR)
	q:(aPrivRuleType="") quitJson
	
	s stringEnviromentInfo = ..JsonToFormatString(argEnviromentInfo)
	
	if (ACurPrivRuleDetailString = "")
	{
		s result=##Class(EMRservice.BL.BLPrivRule).TestPrivRule(stringEnviromentInfo,aPrivRuleType.Name)
	}
	else
	{
		
		s result=..ParsePrivRule(stringEnviromentInfo,ACurPrivRuleDetailString)
			
	}
	s resultCode = $P(result, "^", 1)
	if (resultCode = "1")
	{
		s json.status = "suc"
		s jsondata = {}.%FromJSON(..FormatStringToJson($P(result, "^", 2,*)))
		s json.data = jsondata
	}
	else
	{
		s json.status = "err"
		s json.message = "脚本异常，无法正常解析,异常："_ $P(result, "^", 2)
	}
	
	q json.%ToJSON()
}

/// 解析字符串
/// s string="save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0"
/// w ##class(EMRservice.BL.BLPrivRuleView).FormatStringToJson(string)
ClassMethod FormatStringToJson(AFormatJSON As %String, Split As %String = "!,^", Property As %String = "code,value") As %String
{
	
	s json=[]
	s length=$l(AFormatJSON,$p(Split,",",1))
	for i=1:1:length
	{
		s substring = $p(AFormatJSON,$p(Split,",",1),i)
		
		s code = $p(substring,$p(Split,",",2),1)
		s value =  $p(substring,$p(Split,",",2),2)
		
		s jsonsub={}
		d jsonsub.%Set($p(Property,",",1),code)
		d jsonsub.%Set($p(Property,",",2),value)
		d json.%Push(jsonsub)
	}
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).JsonToFormatString("{""userid"":3928,""admid"":11,""patientid"":1,""userloc"":34,""templateid"":822,""ssgroupid"":576,""categoryid"":642,""docid"":67,""isnewframework"":1,""eprnum"":1}")
ClassMethod JsonToFormatString(AJsonString As %String, Split As %String = "!,^", Property As %String = "code,value") As %String
{
	s ret = ""
	s json = [].%FromJSON(AJsonString)

	set iter = json.%GetIterator()
   	while iter.%GetNext(.key, .value) 
   	{ 
   
		s:(ret'="") ret = ret_$p(Split,",",1)_key_$p(Split,",",2)_value
		s:(ret="") ret = key_$p(Split,",",2)_value
	}
	q ret
}

/// w ##class(EMRservice.BL.BLPrivRuleView).GetEMRDocument(2,"","")
ClassMethod GetEMRDocument(AHospID As %String, AUserLocID As %String, AEpisodeID As %String) As %String
{
	s json = {}
	s quitJson = json.%ToJSON()
	q:(AHospID="") quitJson

	s jsonDocData=[]
	d ..GetEMRDocumentCateByParentId(0,.jsonDocData)

	s jsondata={}
	s jsondata.total = jsonDocData.%Size()
	s jsondata.rows = jsonDocData
	if (jsonDocData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsondata
	}
	elseif (jsonDocData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// s json=[]
/// d ##class(EMRservice.BL.BLPrivRuleView).GetEMRDocumentCateByParentId(0,json)
/// w json.%ToJSON()
ClassMethod GetEMRDocumentCateByParentId(AParentID As %String, ByRef AJson As %DynamicObject)
{
	s seq=""
	for
	{
		s seq=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq))
		q:(seq="")
		
		s emrcateid=""
		for
		{
			s emrcateid=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq,emrcateid))
			q:(emrcateid="")
			s objemrcate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrcateid)
			s emrcateName = objemrcate.CategoryName
			s emrcateType = objemrcate.CategoryType
			
			s jsonsub = {}
			s jsonsub.id = emrcateid
			s jsonsub.templatename=emrcateName
			s jsonsub.categoryid = ""
			s jsonsub.templateid = ""
			s jsonsub.docid = ""
			s jsonsub.instanceid = ""
			//优化逻辑，精简输出
			/*
			if (AParentID'=0)
			{
				d jsonsub.%Set("_parentId",AParentID)
			}
			d AJson.%Push(jsonsub)
			*/
			if (AParentID=0)
			{
				d AJson.%Push(jsonsub)
			}
			
			if (emrcateType '= "TempCate")
			{
				d ..GetEMRDocumentCateByParentId(emrcateid,.AJson)	
			}
			else
			{
				d ..GetEMRDocumentByParentId(emrcateid,.AJson)	
			}
			
		}
	}
}

ClassMethod GetEMRDocumentByParentId(AParentID As %String, ByRef AJson As %DynamicObject)
{
	s seq=""
	for
	{
		s seq=$o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq"," "_AParentID,seq))
		q:(seq="")
		
		s emrtemplateid=""
		for
		{
			s emrtemplateid=$o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq"," "_AParentID,seq,emrtemplateid))
			q:(emrtemplateid="")
			s objemrtemplate = ##class(EMRmeta.EMRTemplate).%OpenId(emrtemplateid)
			s emrcateName = objemrtemplate.TemplateName
			
			s categoryid = objemrtemplate.BindTemplateCategoryID
			s templateid = objemrtemplate.BindTemplateID
			s docid = emrtemplateid
			s instanceid = ""
			
			s jsonsub = {}
			s jsonsub.id = "t"_emrtemplateid
			s jsonsub.templatename=emrcateName
			s jsonsub.categoryid = categoryid
			s jsonsub.templateid = templateid
			
			s jsonsub.docid = AParentID
		
			s jsonsub.instanceid = ""
			//优化逻辑，精简输出
			/*
			d jsonsub.%Set("_parentId",AParentID)
			*/
			
			d jsonsub.%Set("_parentId",..GetEMRTpltCateParentID(AParentID))
			d AJson.%Push(jsonsub)
			
		}
	}
}

ClassMethod GetEMRTpltCateParentID(AEMRTemplateCategoryID As %String) As %String
{
	//固定的层级结构降低理解难度，未用递归
	s objEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(AEMRTemplateCategoryID)
	s pCateID = objEMRTemplateCate.ParentCategoryID
	
	s objParEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(pCateID)
	s ppCateID = objParEMRTemplateCate.ParentCategoryID
	
	q ppCateID
}

/// w ##class(EMRservice.BL.BLPrivRuleView).GetUserLocEpisode(95)
ClassMethod GetUserLocEpisode(AUserLocID As %String)
{
	
	s json = {}
	s quitJson = json.%ToJSON()
	q:(AUserLocID="") quitJson
	
	//^PAADMi("CurrLoc",{PAADM_DepCode_DR},{PAADM_AdmDate},{PAADM_AdmTime},{PAADM_RowID})
	s jsonData=[]
	s admdate=""
	for
	{
		s admdate = $o(^PAADMi("CurrLoc",AUserLocID,admdate))
		q:(admdate="")
		s admtime=""
		for
		{
			s admtime = $o(^PAADMi("CurrLoc",AUserLocID,admdate,admtime))
			q:(admtime="")
			s episodeId=""
			for
			{
				s episodeId = $o(^PAADMi("CurrLoc",AUserLocID,admdate,admtime,episodeId))
				q:(episodeId="")
				
				s patientId = +$g(^PAADM(episodeId))
				s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
				s admdatetime = $zdt(admdate_","_admtime,3,1)
				s ctlocdesc = $p(^CTLOC(AUserLocID),"^",2)
				s bedno = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(episodeId)
				
				s jsonsub={}
				s jsonsub.bedno = bedno
				s jsonsub.episodeid = episodeId
				s jsonsub.name = name
				s jsonsub.ctlocdesc = ctlocdesc
				s jsonsub.admdatetime = admdatetime
				
				d jsonData.%Push(jsonsub)
			}	
		}
	
	}

	if (jsonData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsonData
	}
	elseif (jsonData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

ClassMethod GetPrivRuleIDForSave(AHospGroupId As %String, APrivRuleType As %String) As %String
{
	s privRuleId = ""
	
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	s privRuleId=""
	s privRuleHosp=""
	
	for
	{
		s privRuleHosp = $o(^DHCEMRM.PrivRuleHospitalI("IdxHosGroup"," "_AHospGroupId,privRuleHosp))
		q:(privRuleHosp="")
		
		s objPrivRuleHosp = ##class(EMRmeta.PrivRuleHospital).%OpenId(privRuleHosp)
		s privRuleTypeDr = objPrivRuleHosp.PrivRule.PrivRuleTypeDR
		
		continue:(PrivRuleTypeID '=privRuleTypeDr)
		s privRuleId =objPrivRuleHosp.PrivRule.%Id()
		q
	}
	
	
	q privRuleId
}

ClassMethod GetHospGroupName(AHospGroupId As %String) As %String
{
	s objHosp = ##class(User.CTHospital).%OpenId(AHospGroupId)
	q:(objHosp="") ""
	s hospGroupDesc = objHosp.HOSPDesc
	q hospGroupDesc
}

ClassMethod GetPrivRuleDescByRuleType(APrivRuleType As %String) As %String
{
		q:(APrivRuleType="") ""
	s PrivRuleTypeID = ""
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	s obj=##class(EMRmeta.PrivRuleType).%OpenId(PrivRuleTypeID)
	q:(obj="") ""
	
	s PrivRuleDesc= obj.Description
	
	q PrivRuleDesc
}

ClassMethod SavePrivRuleConfig(AHospGroupId As %String, APrivRuleType As %String, ASwitchPrivRuleValue As %String) As %String
{
	s json = {}
	s quitJson = json.%ToJSON()

	
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s privRuleId = ..GetPrivRuleID(AHospGroupId,APrivRuleType)
	
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleId)
	s objPrivRule.Valid = $case(ASwitchPrivRuleValue,"true":1,"false":0,:0)
	s sc = objPrivRule.%Save()
	
	
	if ($$$ISOK(sc))
	{
		s json.status = "suc"
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// Desc:           运行权限脚本
/// Modifier:       Candy
/// ModifyDateDime: 2015-3-9
/// InPut:          argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:         view^1!save^1!print^1!check^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!revise^0!commit^1
ClassMethod ParsePrivRule(argEnviromentInfo As %String, APrivRuleJsonString As %String) As %String
{
	
	s result = "save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0"
	s PrivControl = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PrivControl")
	q:(PrivControl '= "Y") result
	///解析传入json
	s json={}
	s json = json.%FromJSON(APrivRuleJsonString)
	
	s total = json.total
	s rows = json.rows

	s resultScript=""
	for i=0:1:(total-1)
	{
		s RuleStoreName = rows.%Get(i).storename
		s RuleStoreCode = rows.%Get(i).storecode
		s IsActive = rows.%Get(i).isactive
		//还原delete字符，delte替换为delete
		s RuleStoreCode = $replace(RuleStoreCode,"delte","delete")

		if (IsActive = "启用")
		{
			s resultScript = resultScript_$c(10,10)_"//"_RuleStoreName_$c(10)_RuleStoreCode
		}
	
	}
	//json解析后作为脚本内容赋值
	s PrivRuleCode = resultScript
	s operators = "save=1"	                       //保存
	s operators = operators_",print=1"		       //打印
	s operators = operators_",delete=1"		       //删除
	s operators = operators_",check=1"	           //医师审核
	s operators = operators_",recheck=0"		   //改签
	s operators = operators_",revokcheck=0"		   //撤销签名
	s operators = operators_",reference=1"         //文档对照
	s operators = operators_",export=1"            //导出文档
	s operators = operators_",view=1"              //查看病历
	s operators = operators_",new=1"               //创建病历
	s operators = operators_",copypaste=1"         //复制粘贴
	s operators = operators_",revise=-1"           //留痕
	s operators = operators_",viewrevise=1"        //显示留痕
	s operators = operators_",appoint=1"           //病历授权
	s operators = operators_",authlevel=300"       //病历授权级别
	s operators = operators_",commit=1"			   //送病案室
	s operators = operators_",applyedit=0"		   //自动审批
	s operators = operators_",unlock=1"		   	   //手工解锁
	s operators = operators_",transfer=1"          //病历转移
    s operators = operators_",quote=0"             //门诊历史病历引用
    s operators = operators_",autoapply=0"		   //门诊自动审批功能
    
    s $zt="errhandle2"
   
	s result = ##class(EMRservice.BL.BLPrivRule).ParsePrivRuleLogic(operators,argEnviromentInfo,PrivRuleCode)
	
	q "1^"_result
	
errhandle2
	s $zt=""
	s ^DHCEMRMTest("common",30)=""
	q "0^"_$zerror
}

ClassMethod SavePrivStoreItem(argStoreItemDesc As %String, argStoreItemCode As %String, argStoreItemID As %String = "") As %String
{
	
	s json = {}
	s quitJson = json.%ToJSON()

	q:((argStoreItemDesc="")||(argStoreItemCode="")) quitJson
	
	//还原delete字符，delte替换为delete
	s argStoreItemCode = $replace(argStoreItemCode,"delte","delete")
	
	if (argStoreItemID'="")
	{
		s objPrivRuleItem = ##Class(EMRmeta.PrivRuleStore).%OpenId(argStoreItemID)
	}
	else
	{
		s objPrivRuleItem = ##Class(EMRmeta.PrivRuleStore).%New()
		s objPrivRuleItem.Sequence = +($g(^DHCEMRM.PrivRuleStoreD))+1
	}

	s objPrivRuleItem.RuleCode =argStoreItemCode
	s objPrivRuleItem.RuleDesc =argStoreItemDesc
	
	s $zt="Error"
	d objPrivRuleItem.%Save()
	d objPrivRuleItem.%Close()
	s json.status = "suc"

	
	q json.%ToJSON()
Error
	s $zt=""
	s json.status = "err"
	s json.message = "代码异常："_$system.OBJ.DisplayError($ze)
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLPrivRuleView).CheckPrivStoreItem("if ($$admid$$=100) {s save=1}")
ClassMethod CheckPrivStoreItem(argCheckStoreItemCode As %String) As %String
{
	s json = {}
	s quitJson = json.%ToJSON()

	q:(argCheckStoreItemCode="") quitJson
	
	//还原delete字符，delte替换为delete
	s argCheckStoreItemCode = $replace(argCheckStoreItemCode,"delte","delete")
	s errorMessage=""
	
	s pos1="",pos2="",pos3="",pos4=""
	//初步校验是否存在中文字符
	s pos1 = $find(argCheckStoreItemCode,"（")
	if (pos1>0)
	{
		s tmpErrorMsg = "在位置"_pos1_",存在中文""（""请替换为英文""(""再次校验。"
		s errorMessage= errorMessage_$lb(tmpErrorMsg)
	}
	s pos2 = $find(argCheckStoreItemCode,"）")
	if (pos2>0)
	{
		s tmpErrorMsg = "在位置"_pos2_",存在中文""）""请替换为英文"")""再次校验。"
		s errorMessage= errorMessage_$lb(tmpErrorMsg)
	}
	s pos3 = $find(argCheckStoreItemCode,"，")
	if (pos3>0)
	{
		s tmpErrorMsg = "在位置"_pos3_",存在中文""，""请替换为英文"",""再次校验。"
		s errorMessage= errorMessage_$lb(tmpErrorMsg)
	}
	s pos4 = $find(argCheckStoreItemCode,"if(")
	if (pos4>0)
	{
		s tmpErrorMsg = "在位置"_pos4_",存在书写错误""if(""请修改为""if (""再次校验。"
		s errorMessage= errorMessage_$lb(tmpErrorMsg)
	}
	
	//详细校验1，维护的函数关键字是否支持
	if (argCheckStoreItemCode["$$")
	{
		s listKeyWord=""
		s listKeyWord = listKeyWord_$lb("BelongToMe","BelongToSubdoc","BelongToLoc","BelongToLinkLoc","BelongTransLoc","BelongToWard","IsDisCharge","PatNeedDoc","UserIsDoc")
		s listKeyWord = listKeyWord_$lb("OutPatient","EPatient","RecBelongToMe","IsSaved","IsPrinted","Is24Printed","IsRecordCompleted","IsResidentChecked","IsAttendingChecked")
		s listKeyWord = listKeyWord_$lb("IsChiefChecked","IsUpUser","IsUpLevelUser","IsCreatorUpUserByGroup","IsOperateorUpUserByGroup","IsCreatorUpUserByHISGroup","IsOperaterUpUserByHISGroup")
		s listKeyWord = listKeyWord_$lb("TemplateID","TitileCode","IsDischargedTwoDay","IsDischargedThreeDay","IsDischargedFiveDay","IsDischargedSevenDay","IsDisFiveWorkDay","IsDisSevenWorkDay")
		s listKeyWord = listKeyWord_$lb("EPLeaveOver48Hours","IsRecordRetrieve","IsRecordArchived","IsCopy","DisDateByDoctor","DisDateByNurse","AdmTimeGap","DisTimeGap","AdmTimeInBedGap","InhsAdmTimeGap")
		s listKeyWord = listKeyWord_$lb("IsPatientDischarge","CreaterGroupID","LastModifierGroupID","GetAppoint","userid","ssgroupid","userloc","patientid","admid","instanceid","docid","CTCTP","titleCode")
		s listKeyWord = listKeyWord_$lb("CanCopyPaste","GetCurrentDept","userUnit","BefTransToICUMainDocUnit","LocBefTransToICU","GetOperationUser","GetOperationAssistFirst","OrdHasLocked","IsRecordOverRan")
		s listKeyWord = listKeyWord_$lb("IsDocCommit","MRstatus","HasValidSign","TransCTLOCGap","IsTransPreviousCTLOC","IsOperateor","IsOperaterHISGroupLeader","IsAdmRecDep","IscoustUser","IsEpdReport")
		s listKeyWord = listKeyWord_$lb("IsAdmConsultDep","IsAdmOperInfo","IsFinalNurseFlag","IsOPVisitDoctor","IsLatestVersion","OpHistoryAdmTimeGap","CanCreateByFisrtRecord","IsCreateDocQuality")
		s listKeyWord = listKeyWord_$lb("RecentAdmBelongToLoc","GetMessageFlagByEpisodeID","RecCreator","IsRecSignUser","IsCreatorUpUserByHISAY","AutoApplyCount","IsSameUserLocTypeWithSelEpisode")
		s listKeyWord = listKeyWord_$lb("getActionOperUserSSGroupID","IsSealed","IsBelongToCurrentAdmType","IsLinkBlood","HasAboveResidentLevelSign","IsCreatorUpUserByHIS","HasValidAnySign")
		s listKeyWord = listKeyWord_$lb("IsSameLocInstanceWithUser","LocIDAtInstanceFinish","IsCrossDay","IsPatientBrowse","GetGrantInstanceID","ISDisNurse","CheckIsXGFluByAdm","IsCreaterAndUpUser")
		s listKeyWord = listKeyWord_$lb("IsCreator","IsCanViewRecord","IsPractice","IsTransPreDept","IsZQRecordCategory","GetAdmOutStatus","IsDischargedNWordHours","TransApprovePass","CreateOPRecordByUser")
		s listKeyWord = listKeyWord_$lb("IsPatDeath","CreateOPRecordByUser","ISEMRJZLC","ISCheckAccessLevel","ISEmConsEmrAut","Template2ParentID","IsEmerPatient","IsOutPatientReal","ISCurUserSign","IsChecked")
		s listKeyWord = listKeyWord_$lb("IsPatBelongSubDocsNew","ISEMRLXBXS","Template1ParentID","CheckIPPay","IsRecordToCatalog","ISYWControl","HasModDiag1","IsMan","Islock","IsCommitSY","HasOPPrintByZZJ")
		s listKeyWord = listKeyWord_$lb("IsCreatorLowUserBySignRoleLevel","IsHasSignByUp","IsSignTopLevl","IsOStayStatus","IsInBed","IsSameLocInstanceWithUser","LocIDAtInstanceFinish","IsDeadTwoDay","SSEndTwoDay")
		s listKeyWord = listKeyWord_$lb("SSAPPLYHours","QJYZHours","CTPCPUnit","HasVaildOAAppoint","IsAEpisodeInBed","IsPrintedByInstanceID","VisitStatus","IsPowerDoc","HasHighDocLevel","HasCommited","HasCompleteDthRep")
		s listKeyWord = listKeyWord_$lb("IsBianMu","HasTemSaved","IsRegDoctor","IsHasPower","HasConsult","AdmDateTime","IsUnifyScore","IsOtherLoc","HasOPRecordSigned","IsCAloc","IsSignedOut","IsCurrentVisit")
		s listKeyWord = listKeyWord_$lb("TemplateCategory","CurAdmLoc","ProofCheckStatus","IsSigned","IsWardRound","IsBelongPlat","IsExamplCALoc","LastSingLevel","UserLevel","IsComplate","CanCreateRescueRecord")
		s listKeyWord = listKeyWord_$lb("isCanCarryOn","isReceive","IsRecordArchivedByPlat","IsAdmOperationUser","IsOperationAdm","IsSameForLoc","IsGoldCardForAdm","IsAdmPersionalDoc","LoginUserlevel","SignUserLevel")
		s listKeyWord = listKeyWord_$lb("IsSignUserUper","OutRecordSaved","DeathRecordSaved","IsLastSigner","IsPatSign","IsApproval","BelongToInfect","IsNGS","IsDisMedRecordDup","IsCDRGSubmit","BelongToCaption")
		s listKeyWord = listKeyWord_$lb("LinkOperation","NSOutpatOver24","IsAllSuperSing","IsNurseJS","IsRecordOverRanOP","IsTransDept","InhsTransTimeGap","IsoeordNHours","IsOperaNHours","IsDeadNHours")
		s listKeyWord = listKeyWord_$lb("IsDischargedThreeDayUnHoliday","IsDischargedSevenDayUnHoliday","IsDischargedTenDayUnHoliday","IsDead","IsTransPrevious48Hours","IsTheSameCTloc","IsConsultDept")
		s listKeyWord = listKeyWord_$lb("IsCXRecordRetrieve","IsHaveBed","IsAdmDoc","IsFstDiagDoc","GetFZZLStatus","GetCZZLStatus","RecCreateDateTime","IsDistreeWorkingDay","HasPatSignedPDF","IsCreaterLoc","IsToday")
		s listKeyWord = listKeyWord_$lb("IsDisSevenDay","IsFinishChecked","IsGetAdmDate","ZZYYXXGBS","LastIPDeptID","HasVaildAdmInCTLoc","IsAdmDep","IsSXDoc","IsSign","FinishStatus","HasCreateSampleTypeTemplate")
		s listKeyWord = listKeyWord_$lb("HasCreateSampleTypeTemplate2","CstCurStatQR","HasSignPriv","OPDiagRecordStatus","CanPrint","IsTranToFSS","EmrMark","HasSeal","Appointed","EmrMarkNew","HasSaveFirstPageOld")
		s listKeyWord = listKeyWord_$lb("HasSaveFirstPageNew","IsAdmDoctor","categoryid","IsDepartmentHeader","GetUserLocType","IsCurrAdm","BelongToZKQLoc","IscoustUserNew","IsTransDept","DisLocID","DisDateByNurNew")
		s listKeyWord = listKeyWord_$lb("RecordSignCount","IsDisOut","GetMRStatus","IsRecordCatalogued","IsGetUpStatus","IsUpUserHasChecked","DocLevel","CreatorLevel","LastSignerLevel","AdmLocID","IsGreenRec","IsTransOver24Hours")
		s listKeyWord = listKeyWord_$lb("IsAdmTypeH","InPatient","EnsPatient","IsCreate24Hours","IsOver0Hours","BelongAdmToLoc","AdmBelongToMe","IsSinUserid","IsHaveValidCon","IsSpecialLocGroup1","TitleName","IsFinishFirstDispatchBed")
		s listKeyWord = listKeyWord_$lb("IsCurAdmBelongToLocForBrowse","GetLastConHours","IsSameLocLogUserAndInstance","registerNo","OPInValidityPeriod","IsInformedConsentForm","IsPushOrSignedPDF")
		s listKeyWord = listKeyWord_$lb("GetSSEndHours","IsPushOrSignedPDF")
		
	
		s ruleSegmentsCount = $l(argCheckStoreItemCode,"$$")		

		for j=1:1:ruleSegmentsCount 
		{
			if ((j#2)=0) 
			{
				s keyWord = $p(argCheckStoreItemCode,"$$",j)
				if ($listfind(listKeyWord,keyWord) =0)
				{
					s tmpErrorMsg = "权限关键字"_keyWord_",当前服务器代码不支持，请核对代码版本"
					s errorMessage= errorMessage_$lb(tmpErrorMsg)
				}	
			}
		}
	}	
		
	//详细校验2，维护的函数是否可以正常解析
	s $zt="Error"
	s checkEnviromentInfo = "userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1"
	//d ##class(EMRservice.BL.BLPrivRule).ReplaceFunction(argCheckStoreItemCode,checkEnviromentInfo)
	
	
	if (errorMessage = "")
	{
		s json.status  = "suc"
		s json.message=""
	}
	else
	{
		s json.status  = "error"
		s message = $lts(errorMessage,",")
		s json.message = message
	}
	
	q json.%ToJSON()
Error
	s $zt=""
	s json.status  = "error"
	s message = $lts(errorMessage,",")
	s json.message = message_"|程序异常信息："_$ze
	q json.%ToJSON()
}

}
