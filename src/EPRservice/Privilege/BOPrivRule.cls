Class EPRservice.Privilege.BOPrivRule Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivRule";

ClassMethod Add(argPrivRule As EPRservice.entity.Privilege.EPrivRule) As %String [ WebMethod ]
{
	q:($d(argPrivRule)=0)||(argPrivRule="") 0
	s aPrivRule=""
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%New()
	q:(aPrivRule="") 0

	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	
	//s result=""
	//s result=aPrivRule.%Save()
	//q result
	
	if '(aPrivRule.%Save())
	{
		Quit 0
	} 
	Quit aPrivRule.%Id()
}

ClassMethod Delete(argPrivRuleID As %String) As %String [ WebMethod ]
{
	q:($d(argPrivRuleID)=0)||(argPrivRuleID="") 0
	s aPrivRule="",result=""
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%OpenId(argPrivRuleID)
	q:(aPrivRule="") 0
	s aPrivRule=""
	s result=##class(EPRmeta.Privilege.PrivRule).%DeleteId(argPrivRuleID)
	q result
}

ClassMethod Update(argPrivRule As EPRservice.entity.Privilege.EPrivRule) As %String [ WebMethod ]
{
	q:($d(argPrivRule)=0)||(argPrivRule="") 0
	s aPrivRule="",result=""
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%OpenId(argPrivRule.ID)
	q:(aPrivRule="") 0
	
	s aPrivRule.Name=argPrivRule.Name
	s aPrivRule.Code=argPrivRule.Code
	s aPrivRule.Valid=argPrivRule.Valid
	s aPrivRule.PrivRuleTypeDR=argPrivRule.PrivRuleTypeDR
	
	s result=""
	s result=aPrivRule.%Save()
	q result
}

//w ##class(EPRservice.Privilege.BOPrivRule).Test(5,"userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1")

ClassMethod Test(argRuleID As %String, argEnviromentInfo As %String) As %String [ WebMethod ]
{
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%OpenId(argRuleID)
	q:(aPrivRule="") "-1"
	s result=aPrivRule.TestPrivRule(argEnviromentInfo)
	
	s resultCode = $P(result, "^", 1)
	if (resultCode = "1")
	{
		q "1"
	}
	else
	{
		q result
	}
}

ClassMethod GetById(argPrivRuleID As %String) As EPRservice.entity.Privilege.EPrivRule [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EPRmeta_Privilege.PrivRule where ID=:argPrivRuleID)
	s result=##class(EPRservice.entity.Privilege.EPrivRule).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EPRmeta.Privilege.PrivRule).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Name=tmpResult.Name
		s result.Code=tmpResult.Code
		s result.Valid=tmpResult.Valid
		s result.PrivRuleTypeDR=tmpResult.PrivRuleTypeDR
		s result.ID=id
	}
	q result
}

ClassMethod GetAllPrivRule() As EPRservice.dataset.Privilege.EPrivRuleDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.Privilege.EPrivRuleDataset).%New()
 Quit result
}

/// parse the privilege rule, and return the privilege result
/// argEnviromentInfo(temporary): userid, patid, instanceid. format: userid^1!patid^22!instanceid^65||1
/// return value format: view^1!save^1!print^1!commit^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0
ClassMethod ParsePrivRule(argEnviromentInfo As %String) As %String [ WebMethod ]
{
	//b "s"
	//s ^DHCEPRDebug("EPRservice.Privilege.BOPrivRule","Input") = argEnviromentInfo
	
	//未开启权限控制，返回默认正常权限值
	s PrivControl = ##class(EPRmeta.SysOption).GetOptionValueByName("PrivControl")
	q:(PrivControl '= "Y") ##Class(EPRmeta.Privilege.PrivRule).DefaultNormalValue()
	
	//开启了权限控制但没有配置有效的操作权限脚本，返回默认异常权限值
	K SQLCODE
	s ruleID=""
	&sql(SELECT ID into:ruleID FROM EPRmeta_Privilege.PrivRule WHERE Valid='1' AND PrivRuleTypeDR=(SELECT ID FROM  EPRmeta_Privilege.PrivRuleType WHERE NAME='ActionPrivilege'))
	q:(SQLCODE'=0)||(ruleID="") ##Class(EPRmeta.Privilege.PrivRule).DefaultAbnormalValue()
	
	//获取配置的操作权限
	s aPrivRule=""
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%OpenId(ruleID)
	q:(aPrivRule="") ""
	s result=""
	s result=aPrivRule.ParsePrivRule(argEnviromentInfo)
	
	q result
}

/// parse the privilege rule, and return the privilege result
/// argEnviromentInfo(temporary): userid, patid, instanceid. format: userid^1!patid^22!instanceid^65||1
/// return value format: 
/// Creator：      guozongtao
/// CreatDate：    2010-04-29
/// Description:   依据传入规则ID,环境变量进行规则检查
/// Table：        
/// Input：        argRuleID：EPRmeta.Privilege.PrivRule.ROWID
///                argEnviromentInfo:"userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_ssgroupid_"!categoryid^"_categoryid_"!docid^"_docid_"!isnewframework^1!eprnum^"_EPRNum
/// Output：       对输出参数的说明
/// Return：       view^1!save^1!print^1!commit^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0
/// Others：       
ClassMethod ParsePrivRuleByID(argRuleID As %String, argEnviromentInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	//b "s"
	//s ^DHCEPRDebug("EPRservice.Privilege.BOPrivRule","Input1") = argRuleID
	//s ^DHCEPRDebug("EPRservice.Privilege.BOPrivRule","Input2") = argEnviromentInfo
	
	s PrivControl = ##class(EPRmeta.SysOption).GetOptionValueByName("PrivControl")
	if (PrivControl '= "Y") {
		s result = ##Class(EPRmeta.Privilege.PrivRule).DefaultNormalValue()
		q ..PrivStringToArray(result)
	}
	
	s aPrivRule=##class(EPRmeta.Privilege.PrivRule).%OpenId(argRuleID)
	if (aPrivRule="") {
		s result = ##Class(EPRmeta.Privilege.PrivRule).DefaultAbnormalValue()
		q ..PrivStringToArray(result)
	}
	
	s result=aPrivRule.ParsePrivRule(argEnviromentInfo)
	q ..PrivStringToArray(result)
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   依据传入规则ID,获取使用了这条规则的EPRmeta.EPRTemplate记录
/// Table：        
/// Input：        argRuleID：EPRmeta.Privilege.PrivRule.ROWID
/// Output：       对输出参数的说明
/// Return：       EPRservice.dataset.EPrivRuleEPRTemplate
/// Others：       
ClassMethod GetUsedPrivRule(argPrivRuleID As %String) As EPRservice.dataset.EPrivRuleEPRTemplateDataSet [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EPrivRuleEPRTemplateDataSet).%New()
 	Do result.SetArgs(argPrivRuleID)
 	Quit result
}

Query GetTemplateByPrivRuleDR(PrivRuleDR As %String) As %Query(ROWSPEC = "ID:%String,EPRTemplateName:%String,EPRCategoryName:%String")
{
}

ClassMethod GetTemplateByPrivRuleDRExecute(ByRef qHandle As %Binary, PrivRuleDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(PrivRuleDR="") $$$OK
	
	s PrivRuleDR=" "_PrivRuleDR
	
	s EPRTemplateID=""
	s EPRTemplateID = $O(^DHCEPRM.EPRTemplateI("IdxPrivRuleDR",PrivRuleDR,""))
	while EPRTemplateID'=""
	{
		s objEprTemplate=##Class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
		s EPRTemplateName=objEprTemplate.EPRTemplateName
	    s EPRCategoryID=objEprTemplate.EPRCategoryID
	    s objEprTemplateCategory=##Class(EPRmeta.EPRTemplateCategory).%OpenId(EPRCategoryID)
	    s EPRCategoryAllPathString=##class(EPRservice.BOEPRTemplate).GetTemplateAllPathString(EPRTemplateID)
		s ^CacheTemp(repid, ind) = $LB(EPRTemplateID,EPRTemplateName,EPRCategoryAllPathString)
		s ind = ind + 1
	    s EPRTemplateID = $O(^DHCEPRM.EPRTemplateI("IdxPrivRuleDR",PrivRuleDR,EPRTemplateID))
	}
	Quit $$$OK
}

ClassMethod GetTemplateByPrivRuleDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateByPrivRuleDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetTemplateByPrivRuleDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateByPrivRuleDRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPrivRuleStatus() As EPRservice.dataset.EPivRuleStatusDataSet [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EPivRuleStatusDataSet).%New()
 	Do result.SetArgs()
 	Quit result
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   获取规则数据集合,和是否使用的状态
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:w ##Class(%ResultSet).RunQuery("EPRservice.Privilege.BOPrivRule","SelectPrivRuleAll")
Query SelectPrivRuleAll() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,ValidDesc:%String,IsUsed:%String,IsUsedDesc:%String,PrivRuleTypeDR:%String,PrivRuleTypeDesc:%String")
{
}

ClassMethod SelectPrivRuleAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s RowID="",Name="",Code="",Valid="",ValidDesc="",IsUsed="",IsUsedDesc="",PrivRuleTypeDR="Null",PrivRuleTypeDesc="Null"
	s objPrivRuletype=""
	s RowID = $O(^DHCEPRM.PrivRuleD(RowID))
	while RowID'=""
	{
		s PrivRuleName=""
		s objPrivRule=##Class(EPRmeta.Privilege.PrivRule).%OpenId(RowID)
		s PrivRuleTypeDR=objPrivRule.PrivRuleTypeDR
		s ^CacheTemp("Debug",RowID)=objPrivRule.PrivRuleTypeDR_"^"_$l(PrivRuleTypeDR)
	    i (PrivRuleTypeDR'="")
	    {
	    	s objPrivRuletype=##Class(EPRmeta.Privilege.PrivRuleType).%OpenId(PrivRuleTypeDR)
	    	i (objPrivRuletype'="")
	    	{
	    		s PrivRuleTypeDesc=objPrivRuletype.Description
	    		s PrivRuleName=objPrivRuletype.Name
	    		d objPrivRuletype.%Close()
	    	}
	    }	
		s Name=objPrivRule.Name
	    s Code=objPrivRule.Code
	    s Valid=objPrivRule.Valid
	    i (Valid="1"){s ValidDesc="是"}
	    else {s ValidDesc="否"}
	    s PrivRuleDR=" "_RowID
	    if $d(^DHCEPRM.EPRTemplateI("IdxPrivRuleDR",PrivRuleDR))'=0
	    {
		    s IsUsed=1
		    s IsUsedDesc="是"
		}else 
		{
			s IsUsed=0
			s IsUsedDesc="否"
		}
		i (PrivRuleTypeDR="")
		{s PrivRuleTypeDR="Null"}
		s ^CacheTemp(repid, ind) = $LB(RowID,Name,Code,Valid,ValidDesc,IsUsed,IsUsedDesc,PrivRuleTypeDR,PrivRuleTypeDesc)
		s PrivRuleTypeDesc="Null"
		s ind = ind + 1
	    s RowID = $O(^DHCEPRM.PrivRuleD(RowID))
	}
	Quit $$$OK
}

ClassMethod SelectPrivRuleAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPrivRuleAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod SelectPrivRuleAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPrivRuleAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-13
/// Description:   依据规则类型返回规则数据集合
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:w ##Class(EPRservice.Privilege.BOPrivRule).GetPrivRuleByType("LoadTemplatePrivilege")
ClassMethod GetPrivRuleByType(PrivRuleTypeName As %String) As EPRservice.dataset.EPrivRuleByTypeDataSet [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EPrivRuleByTypeDataSet).%New()
 	Do result.SetArgs(PrivRuleTypeName)
 	Quit result
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   根据规则类型名称获取规则数据集合,和是否使用的状态
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Privilege.BOPrivRule","SelectPrivRuleByType","LoadTemplatePrivilege")
Query SelectPrivRuleByType(argRuleTypeName As %String) As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,Valid:%String,ValidDesc:%String,IsUsed:%String,IsUsedDesc:%String,PrivRuleTypeDR:%String,PrivRuleTypeDesc:%String")
{
}

ClassMethod SelectPrivRuleByTypeExecute(ByRef qHandle As %Binary, argRuleTypeName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s RowID="",PrivRuleDR="",objPrivRuletype=""
	s RowID = $O(^DHCEPRM.PrivRuleD(RowID))
	while RowID'=""
	{
		s PrivRuleTypeDesc="" ,PrivRuleName=""
		s objPrivRule=##Class(EPRmeta.Privilege.PrivRule).%OpenId(RowID)
	    s PrivRuleTypeDR=objPrivRule.PrivRuleTypeDR
	    i (PrivRuleTypeDR'="")
	    {
	    	s objPrivRuletype=##Class(EPRmeta.Privilege.PrivRuleType).%OpenId(PrivRuleTypeDR)
	    	i (objPrivRuletype'="")
	    	{
	    		s PrivRuleTypeDesc=objPrivRuletype.Description
	    		s PrivRuleName=objPrivRuletype.Name
	    		d objPrivRuletype.%Close()
	    	}
	    }	
	    	
		i (PrivRuleName'=argRuleTypeName)
		{
			d objPrivRule.%Close()
			s RowID = $O(^DHCEPRM.PrivRuleD(RowID))
			continue
		}
		s Name=objPrivRule.Name
	    s Code=objPrivRule.Code
	    s Valid=objPrivRule.Valid
	    i (Valid="1"){s ValidDesc="是"}
	    else {s ValidDesc="否"}
	    s PrivRuleDR=" "_RowID
	    if $d(^DHCEPRM.EPRTemplateI("IdxPrivRuleDR",PrivRuleDR))'=0
	    {
		    s IsUsed=1
		    s IsUsedDesc="是"
		}else 
		{
			s IsUsed=0
			s IsUsedDesc="否"
		}
		s ^CacheTemp(repid, ind) = $LB(RowID,Name,Code,Valid,ValidDesc,IsUsed,IsUsedDesc,PrivRuleTypeDR,PrivRuleTypeDesc)
		s ind = ind + 1
	    s RowID = $O(^DHCEPRM.PrivRuleD(RowID))
	}
	Quit $$$OK
}

ClassMethod SelectPrivRuleByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPrivRuleByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		k ^CacheTemp(repid) //5.2.3 以下 Caceh 通过DataSet调用的自定义Query,不能调用Close方法,所以fetch后删除
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPrivRuleByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPrivRuleByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      houj
/// CreatDate：    2010-10-28
/// Description:   获取授权权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EPRservice.Privilege.BOPrivRule).GetAppointPriv()
ClassMethod GetAppointPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	//未开启权限控制，默认取正常权限值
	s PrivControl = ##class(EPRmeta.SysOption).GetOptionValueByName("PrivControl")
	if (PrivControl '= "Y") 
	{
		s result =##Class(EPRmeta.Privilege.PrivRule).DefaultNormalValue()
		q ..PrivStringToArray(result)
	}
	
	//开启了权限控制，默认取异常权限值
	s result = ##Class(EPRmeta.Privilege.PrivRule).DefaultAbnormalValue()
	
	q:(argEnvInfo = "") ..PrivStringToArray(result)
	
	s objPrivRule = ..GetFirstValidRuleByName("AppointPrivilege")
	q:(objPrivRule = "") ..PrivStringToArray(result)
	
	s result = objPrivRule.ParsePrivRule(argEnvInfo)
	q ..PrivStringToArray(result)
}

ClassMethod PrivStringToArray(privString As %String) As %ArrayOfDataTypes
{
	s arr = ##class(%ArrayOfDataTypes).%New()
	
	if (privString '= "")
	{
		s count=$l(privString,"!")
		for i=1:1:count
		{
			d arr.SetAt($p($p(privString, "!", i), "^", 2), $p($p(privString, "!", i), "^", 1))		 
		}
	}
	
	q arr
}

ClassMethod GetFirstValidRuleByName(ruleName As %String) As EPRmeta.Privilege.PrivRule
{
	q:(ruleName="") ""
	
	s ruleID = ""
	&sql(SELECT top 1 ID into:ruleID FROM  EPRmeta_Privilege.PrivRule 
		WHERE Valid='1' AND PrivRuleTypeDR = (SELECT ID FROM  EPRmeta_Privilege.PrivRuleType WHERE NAME = :ruleName))
		
	q:(ruleID="")||(ruleID=$c(0)) ""
	
	s objPrivRule = ##class(EPRmeta.Privilege.PrivRule).%OpenId(ruleID)
	q objPrivRule
}

/// Creator：      houj
/// CreatDate：    2014-11-18
/// Description:   获取授权申请级别权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EPRservice.Privilege.BOPrivRule).GetAuthLevelPriv()
ClassMethod GetAuthLevelPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	//默认取异常授权申请级别，即所有授权申请为300(医务处审批)
	//s result = "view^1!save^1!print^1!commit^1!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!browse^1!printaftercommit^0!load^1!appoint^0!export^0!new^1!authlevel^300"
	s result = ##Class(EPRmeta.Privilege.PrivRule).DefaultAbnormalValue()
	
	q:(argEnvInfo = "") ..PrivStringToArray(result)  
	
	s objPrivRule = ..GetFirstValidRuleByName("AuthLevelPrivilege")
	q:(objPrivRule = "") ..PrivStringToArray(result)
	
	s result = objPrivRule.ParsePrivRule(argEnvInfo)
	q ..PrivStringToArray(result)
}

ClassMethod GetPrivacyLevel2(userid As %String, episodeID As %String, patientID As %String, ctlocid As %String, templateid As %String, ssgroupid As %String, categoryid As %String, docid As %String, EPRNum As %String) As %String
{
	s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_ssgroupid_"!categoryid^"_categoryid_"!docid^"_docid_"!isnewframework^1!eprnum^"_EPRNum
	q ..GetPrivacyLevel(privString)
}

/// Creator：      houj
/// CreatDate：    2014-11-18
/// Description:   获取级别隐私权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EPRservice.Privilege.BOPrivRule).GetPrivacyLevel()
ClassMethod GetPrivacyLevel(argEnvInfo As %String) As %String [ WebMethod ]
{
	//b "s"
	//默认取最高隐私级别，空值可以认为是未配置隐私级别，可以看所有数据
	q:(argEnvInfo = "") ""
	
	s objPrivRule = ..GetFirstValidRuleByName("PrivacyLevelPrivilege")
	q:(objPrivRule = "") ""
	
	s result = objPrivRule.ParsePrivRule(argEnvInfo)
	s arrResult = ..PrivStringToArray(result)
	
	s privacyLevel = arrResult.GetAt("privacylevel")
	s privacyLevel = (+privacyLevel)
	q:(privacyLevel >= "100") ""						 //100为最高级别，可以看所有信息
	
	q privacyLevel
}

/// 以下为测试代码
/// Debug: d ##Class(EPRservice.Privilege.BOPrivRule).TestParsePrivRuleByID()
ClassMethod TestParsePrivRuleByID() As %String
{
	s par1 = ^DHCEPRDebug("EPRservice.Privilege.BOPrivRule","Input1")
	s par2 = ^DHCEPRDebug("EPRservice.Privilege.BOPrivRule","Input2")
	s par1 = "3"
	s par2 = "userid^5972!admid^201764!patientid^1!userloc^34!templateid^0!ssgroupid^576!categoryid^0!docid^25!isnewframework^1!eprnum^1"
	q ..ParsePrivRuleByID(par1,par2)
}

/// Debug: d ##Class(EPRservice.Privilege.BOPrivRule).TestGetAppointPriv()
ClassMethod TestGetAppointPriv() As %String
{
	s para = "userid^!admid^201764!patientid^1!userloc^34!templateid^0!ssgroupid^576!categoryid^0!docid^!isnewframework^1!eprnum^"
	q ..GetAppointPriv(para)
}

/// Debug: w ##Class(EPRservice.Privilege.BOPrivRule).TestGetPrivacyLevel()
ClassMethod TestGetPrivacyLevel() As %String
{
	s para = "userid^!admid^201764!patientid^1!userloc^34!templateid^0!ssgroupid^576!categoryid^0!docid^!isnewframework^1!eprnum^"
	q ..GetPrivacyLevel(para)
}

}
