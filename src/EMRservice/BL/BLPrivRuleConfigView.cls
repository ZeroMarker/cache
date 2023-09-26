Class EMRservice.BL.BLPrivRuleConfigView Extends %RegisteredObject
{

/// 获取病历权限类型
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetPrivRuleType()
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

/// 获取当前类型规则
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetPrivRule(2,"ActionPrivilege")
ClassMethod GetPrivRule(AHospGroupId As %String, APrivRuleType As %String = "") As %String
{
	
	s json = {}
	s quitJson = json.%ToJSON()
	q:((AHospGroupId="")||(APrivRuleType="")) quitJson
	
	
	s uid=$i(^CacheTemp)
	
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
		s jsonsub.isactive = $case(result.Data("RuleStoreIsActive"),"Y":"启用","N":"停用",:"停用")
		s jsonsub.ruletype = result.Data("RuleType")
		s jsonsub.ruletypeid = result.Data("RuleTypeID")
		s jsonsub.sequece = result.Data("Sequence")
		s jsonsub.privruleid = result.Data("RuleID")
		
		s total=total+1
		d json.%Push(jsonsub)
		s uniArry(uid,result.Data("RuleStoreID"))=""
	}

	s resultStore = ##Class(%ResultSet).%New("EMRservice.BL.BLPrivRuleDetail:GetPrivRuleStore")
	d resultStore.%Execute()
	while(resultStore.%Next())
	{
		s RuleType = resultStore.Data("RuleType")
		continue:(RuleType'=APrivRuleType)
		
		s HospGroupIds = resultStore.Data("HospGroupIds")
		continue:(HospGroupIds '[ AHospGroupId)
		
		continue:($d(uniArry(uid,resultStore.Data("RuleStoreID")))'=0)
		
		s jsonsub = {}
		s jsonsub.storeid = resultStore.Data("RuleStoreID")
		s jsonsub.storename = resultStore.Data("RuleStoreName")
		s jsonsub.storecode = resultStore.Data("RuleStoreCode")
		s jsonsub.isactive = $case(resultStore.Data("RuleStoreIsActive"),"Y":"启用","N":"停用",:"停用")
		s jsonsub.ruletype = resultStore.Data("RuleType")
		s jsonsub.ruletypeid = resultStore.Data("RuleTypeID")
		
		s total=total+1
		d json.%Push(jsonsub)
	
	}
	k uniArry(uid)
	
	q json.%ToJSON()
}

/// 存储当前类型权限规则
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).SavePrivRule(2,"ActionPrivilege","{""total"":2,""rows"":[{""storeid"":""1"",""storename"":""初始化权限"",""storecode"":""s save=1,print=1,delte=1"",""isactive"":""启用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":1},{""storeid"":""2"",""storename"":""初始化权限"",""storecode"":""if ($$BelongToLoc$$) {s save=1,delte=1}"",""isactive"":""启用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":1}]}")
ClassMethod SavePrivRule(AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String)
{
	s json = {}
	s quitJson = json.%ToJSON()


	q:((APrivRuleType="")||(AHospGroupId="")) quitJson
		
		
	s privRuleID = ..GetPrivRuleID(AHospGroupId,APrivRuleType)

	if (privRuleID="")
	{
		s json.status = "err"
		s json.message="privRuleID为空"
		q json.%ToJSON()
		
	}
	//存储Detail数据,生成脚本原文
	s privRuleScript= ##class(EMRservice.BL.BLPrivRuleDetail).GetPrivRuleScript(APrivRuleJsonString,privRuleID,AHospGroupId)
	
	
	if (privRuleScript="")
	{
	
		s json.status = "err"
		s json.message="privRuleScript为空"
		q json.%ToJSON()
		
	}
	
	if (+privRuleScript="-1")
	{
	
		s json.status = "err"
		s json.message=$p(privRuleScript,"^",2)
		q json.%ToJSON()
		
	}
	
	
	//生成PrivRule数据
	s objPrivRule = ##class(EMRmeta.PrivRule).%OpenId(privRuleID)
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

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetHospGroupID()
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
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).CheckPrivRuleStore(2,"ActionPrivilege","{""total"":3,""rows"":[{""id"":""20"",""storeid"":""120"",""storename"":""初始删除权限为0"",""storecode"":""s delete=0"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""9"",""privruleid"":""1""},{""id"":""21"",""storeid"":""120"",""storename"":""初始删除权限为0"",""storecode"":""s delete=0"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""10"",""privruleid"":""1""},{""id"":""22"",""storeid"":""126"",""storename"":""病历删除权限，需要在病历保存后才可"",""storecode"":""if ($$IsSaved$$=1) { s delete=1 }"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""11"",""privruleid"":""1""},{""id"":""23"",""storeid"":""134"",""storename"":"""",""storecode"":""$$GetAppoint$$"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""12"",""privruleid"":""1""}]}")
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
/// debugger:##class(EMRservice.BL.BLPrivRuleConfigView).GetPrivRuleID("2","ActionPrivilege")
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
			s privRuleId =objPrivRuleHosp.PrivRule.%Id()
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

ClassMethod GetPrivRuleTypeID(APrivRuleType As %String)
{
	s PrivRuleTypeID = ""
	
	s PrivRuleTypeID = $o(^DHCEMRM.PrivRuleTypeI("IdxName"," "_$zcvt(APrivRuleType,"U"),""))
	
	q PrivRuleTypeID
}

/// 获取用户信息
/// /d ##class(EMRservice.BL.BLPrivRuleConfigView).GetUserInfo()
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
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetUserLogonInfo(10209)
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

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetEnvParameter(string)
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

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).Test(2,"ActionPrivilege","{""userid"":3928,""admid"":11,""patientid"":1,""userloc"":34,""templateid"":822,""ssgroupid"":576,""categoryid"":642,""docid"":67,""isnewframework"":1,""eprnum"":1}")
ClassMethod Test(AHospGroupId As %String, APrivRuleType As %String, argEnviromentInfo As %String) As %String [ WebMethod ]
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
	s result=##Class(EMRservice.BL.BLPrivRule).TestPrivRule(stringEnviromentInfo,aPrivRuleType.Name)
	b ;1
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
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).FormatStringToJson(string)
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

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).JsonToFormatString("{""userid"":3928,""admid"":11,""patientid"":1,""userloc"":34,""templateid"":822,""ssgroupid"":576,""categoryid"":642,""docid"":67,""isnewframework"":1,""eprnum"":1}")
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

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetEMRDocument(2,"","")
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
/// d ##class(EMRservice.BL.BLPrivRuleConfigView).GetEMRDocumentCateByParentId(0,json)
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
			if (AParentID'=0)
			{
				d jsonsub.%Set("_parentId",AParentID)
			}
			d AJson.%Push(jsonsub)
			
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
			d jsonsub.%Set("_parentId",AParentID)
			d AJson.%Push(jsonsub)
			
		}
	}
}

/// w ##class(EMRservice.BL.BLPrivRuleConfigView).GetUserLocEpisode(95)
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

}
