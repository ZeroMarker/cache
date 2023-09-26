/// 名称：		EMRservice.BL.BLPrivRuleDetail
/// 描述：		规则脚本BL层
/// 编写者：	
/// 编写时间：	2021-5-28
Class EMRservice.BL.BLPrivRuleDetail Extends %RegisteredObject
{

/// Desc:       
/// Creator:    
/// CreateDate: 
/// Input:      
/// OutPut:     
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrivRuleDetail","PrivRuleStore")
Query GetPrivRuleStore() As %SQLQuery(CONTAINID = 1, ROWSPEC = "RuleStoreID,RuleStoreName,RuleStoreCode", SELECTMODE = "RUNTIME")
{
	SELECT d.ID, d.RuleDesc, d.RuleCode
	FROM EMRmeta.PrivRuleStore d 
	Order By d.ID
}

/// Desc:       获取规则脚本
/// Creator:    
/// CreateDate: 2021-11-29
/// Input:      
/// OutPut:     返回数据 %XML.DataSet,
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrivRuleDetail","GetPrivRuleDetail")
Query GetPrivRuleDetail() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RuleStoreID,RuleStoreName,RuleStoreCode,RuleStoreIsActive,RuleTypeID, RuleType,RuleTypeDesc,HospGroupID, Sequence,RuleID", SELECTMODE = "RUNTIME")
{
	SELECT d.ID,
		   d.PrivRuleStore->ID, d.RuleDesc, d.RuleCode, d.IsActive,
		   d.PrivRuleType->ID, d.PrivRuleType->Name,d.PrivRuleType->Description,
		   d.HospGroupID,d.Sequence,d.PrivRule->ID
	FROM EMRmeta.PrivRuleDetail d 
	Order By d.Sequence
}

/// Desc:       获取权限脚本（更新规则）
/// Creator:    
/// CreateDate: 2021-11-29
/// Input:      json数据（ID为空：新增，ID有值：修改）
/// OutPut:     返回脚本数据，失败为空
/// w ##class(EMRservice.BL.BLPrivRuleConfigView).SavePrivRule(2,"ActionPrivilege","{""total"":4,""rows"":[{""id"":"""",""storeid"":""7"",""storename"":""保存"",""storecode"":""ssave=1"",""isactive"":""启用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1""},{""ID"":"""",""storeid"":""12"",""storename"":""测试"",""storecode"":""sprint=1"",""isactive"":""启用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1""},{""ID"":"""",""storeid"":""8"",""storename"":""打印"",""storecode"":""sprint=1"",""isactive"":""停用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1""},{""ID"":"""",""storeid"":""10"",""storename"":""导出"",""storecode"":""sexport=1"",""isactive"":""停用"",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1""}]}")
ClassMethod GetPrivRuleScript(APrivRuleJsonString As %String, APrivRuleID As %String, AHospGroupId As %String) As %String
{
	s resultScript=""
	
	s $zt="error"
	TSTART
	
	s json={}
	s json = json.%FromJSON(APrivRuleJsonString)
	//事务标识（1 提交，0 回滚）
	s blMark = "1"
	s total = json.total
	s rows = json.rows

	s errorInfo = ""
	
	for i=0:1:(total-1)
	{
		s ID = rows.%Get(i).id
		s ruleStoreID = rows.%Get(i).storeid
		s detailName = rows.%Get(i).storename
		s detailCode = rows.%Get(i).storecode
		s ruletypeid = rows.%Get(i).ruletypeid
		
		continue:(ruleStoreID="")
		//默认停用
		s IsActive = $case(rows.%Get(i).isactive,"启用":"1","停用":"0",:"0")
		
		//前端调用时出现因包含delete导致数据情况。
		//此处还原delete字符，delte替换为delete(前端delete替换为delte）
		s detailCode = $replace(detailCode,"delte","delete")
	
		if (ID="")
		{
			s objPrivDetail = ##class(EMRmeta.PrivRuleDetail).%New()
		}
		else
		{
			s objPrivDetail = ##class(EMRmeta.PrivRuleDetail).%OpenId(ID)
			if (objPrivDetail="")
			{
				s blMark = "0"
				TROLLBACK
				s errorInfo ="权限明细数据异常"
				q
			}
		}
		s objPrivRuleStore =##class(EMRmeta.PrivRuleStore).%OpenId(ruleStoreID)
		if (objPrivRuleStore="")
		{
			s blMark = "0"
			TROLLBACK
			s errorInfo ="权限仓库项数据异常,恢复标准数据后重试"
			q
		}
		s objRrivRuleType = ##class(EMRmeta.PrivRuleType).%OpenId(ruletypeid)
		if (objRrivRuleType="")
		{
			s blMark = "0"
			TROLLBACK
			s errorInfo ="权限类型数据异常"
			q
		}
		s objRrivRule = ##class(EMRmeta.PrivRule).%OpenId(APrivRuleID)
		if (objRrivRule="")
		{
			s blMark = "0"
			s errorInfo ="权限规则数据异常"
			TROLLBACK
			q
		}
		s objPrivDetail.PrivRuleStore = objPrivRuleStore
		s objPrivDetail.PrivRuleType = objRrivRuleType
		s objPrivDetail.RuleCode = detailCode
		s objPrivDetail.RuleDesc = detailName
		s objPrivDetail.IsActive = IsActive
		s objPrivDetail.Sequence = (i+1)
		s objPrivDetail.PrivRule = objRrivRule
		s objPrivDetail.HospGroupID =AHospGroupId
		s sc = objPrivDetail.%Save()
		
		if ($$$ISOK(sc))
		{
			if (IsActive = "1")
			{
				s resultScript = resultScript_$c(10,10)_..GenPrivRuleScript(objPrivDetail.RuleDesc,objPrivDetail.RuleCode)
			}
		}
		else
		{
			s blMark = "0"
			
			TROLLBACK
			s errorInfo = "权限脚本保存异常:"_$ze
			q
		}
		
		d objPrivRuleStore.%Close()
		d objPrivDetail.%Close()
	}
	
	
	if (blMark="1")
	{
		TCOMMIT
	}
	
	if (errorInfo'="")
	{
		q "-1^"_errorInfo
	}
	q resultScript
error
	s $zt=""
	TROLLBACK
	s errorInfo = "解析权限脚本异常:"_$ze
	q "-1^"_errorInfo
}

/// Desc:       获取规则脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      
/// OutPut:     返回数据 EMRservice.entity.EPrivRuleDetail,
/// Debug: d ##class(EMRservice.BL.BLPrivRuleDetail).GetDetailByID("1")
ClassMethod GetDetailByID(aID As %String) As EMRservice.entity.EPrivRuleDetail
{
	s objResult = ##class(EMRservice.entity.EPrivRuleDetail).%New()
	s ruleDetial = ##class(EMRmeta.PrivRuleDetail).%OpenId(aID)
	q:(ruleDetial="") objResult
	s objResult.HospGroupID = ruleDetial.HospGroupID
	s objResult.IsActive = ruleDetial.IsActive
	s objResult.PrivRule = ruleDetial.PrivRule.%Id()
	s objResult.PrivRuleStore = ruleDetial.PrivRuleStore.%Id()
	s objResult.PrivRuleType = ruleDetial.PrivRuleType.%Id()
	s objResult.RuleCode = ruleDetial.RuleCode
	s objResult.RuleDesc = ruleDetial.RuleDesc
	s objResult.Sequence = ruleDetial.Sequence
	q objResult
}

/// Desc:       删除规则脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BL.BLPrivRuleDetail).DelPrivRuleItem("1")
ClassMethod DelPrivRuleItem(rowID As %String, AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String) As %String
{
	s $zt="error"
	TSTART
	s ret = "-1"
	if (rowID="")
	{
		TROLLBACK
		q ret
	}
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.PrivRuleDetail).%OpenId(rowID)
	if (obj="")
	{
		TROLLBACK
		q ret
	}
	if (##class(EMRmeta.PrivRuleDetail).%DeleteId(rowID))
	{
		s ret = "1"
	}
	else
	{
		TROLLBACK
		q ret
	}
	s strRes = ##class(EMRservice.BL.BLPrivRuleConfigView).SavePrivRule(AHospGroupId,APrivRuleType,APrivRuleJsonString)
	if ((strRes="{}")||(strRes [ "err"))
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	q ret
error
	TROLLBACK
	q "-1"
}

/// d ##class(EMRservice.BL.BLPrivRuleDetail).GetPrivRuleScript("{""total"":3,""rows"":[{""id"":""1"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限1"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1 } "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""1"",""ruleid"":""1""},{""id"":""2"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限2"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1} "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""2"",""ruleid"":""1""},{""id"":""3"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限3"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1} "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""3"",""ruleid"":""1""}]}")
ClassMethod GetPrivRuleScriptAftDelete(APrivRuleDetailID As %String, APrivRuleID As %String)
{
	s resultScript=""
	
	s seq=""
	for
	{
		s seq=$o(^DHCEMRM.PrivRuleDetailI("IdxPrivRuleIDSeq",APrivRuleID,seq))
		q:(seq="")
		
		s tmpId=""
		for
		{
			s tmpId = $o(^DHCEMRM.PrivRuleDetailI("IdxPrivRuleIDSeq",APrivRuleID,seq,tmpId))
			q:(tmpId="")

			s objPrivDetail = ##class(EMRmeta.PrivRuleDetail).%OpenId(tmpId)
			
			if (tmpId = APrivRuleDetailID)
			{
				d ##class(EMRmeta.PrivRuleDetail).%DeleteId(tmpId)
				continue
			}
			continue:(objPrivDetail.IsActive=0)
			
			s RuleStoreName = objPrivDetail.RuleDesc
			s RuleStoreCode = objPrivDetail.RuleCode
			
			s resultScript = resultScript_$c(10,10)_"//"_RuleStoreName_$c(10)_RuleStoreCode
			
		}
	}
	
		
	q resultScript
}

/// d ##class(EMRservice.BL.BLPrivRuleDetail).GetPrivRuleScript("{""total"":3,""rows"":[{""id"":""1"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限1"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1 } "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""1"",""ruleid"":""1""},{""id"":""2"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限2"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1} "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""2"",""ruleid"":""1""},{""id"":""3"",""storeid"":""1"",""name"":""患者住院期间有保存操作权限3"",""storecode"":""if ($$AdmTimeInBedGap$$=1) {s save=1} "",""ruletype"":""ActionPrivilege"",""ruletypeid"":""1"",""sequece"":""3"",""ruleid"":""1""}]}")
ClassMethod CheckPrivRuleScript(APrivRuleJsonString As %String, APrivRuleID As %String)
{
	s quitjson=[]
	
	
	s json={}
	s json = json.%FromJSON(APrivRuleJsonString)


	s total = json.total
	s rows = json.rows

	for i=0:1:(total-1)
	{

		s ID = rows.%Get(i).id
		s RuleStoreID = rows.%Get(i).storeid
		s RuleStoreName = rows.%Get(i).storename
		s RuleStoreCode = rows.%Get(i).storecode
		
		//还原delete字符，delte替换为delete
		s RuleStoreCode = $replace(RuleStoreCode,"delte","delete")
		
		s RuleType= rows.%Get(i).ruletype
		s RuleTypeID= rows.%Get(i).ruletypeid
		s Sequence = rows.%Get(i).sequece
		s RuleID = $s(rows.%Get(i).ruleid="":APrivRuleID,1:rows.%Get(i).ruleid)
		
		
		s baseStore = ##class(EMRmeta.PrivRuleStore).%OpenId(RuleStoreID)
		continue:(baseStore ="")
		s baseStoreCode = baseStore.RuleCode
		
		if (RuleStoreCode '= baseStoreCode)
		{
			s jsonsub = {}
			
			s jsonsub.id = ID
			s jsonsub.storeid = RuleStoreID
			s jsonsub.storename = RuleStoreName
			s jsonsub.storecode = baseStoreCode
			s jsonsub.ruletype = RuleType
			s jsonsub.ruletypeid = RuleTypeID
			s jsonsub.sequece = Sequence
			s jsonsub.ruleid = RuleID
			
			d quitjson.%Push(jsonsub)
		}
		s baseStore = ""
		
		
	}
	
		
	q quitjson.%ToJSON()
}

/// d ##class(EMRservice.BL.BLPrivRuleDetail).GenPrivRuleScript("病历删除权限，需要在病历保存后才使用","s delete=0"_$c(10)_"if ($$IsSaved$$=1) { s delete=1 }")
ClassMethod GenPrivRuleScript(RuleDesc As %String, RuleCode As %String) As %String
{
	//描述信息
	//病历保存、打印没有提示信息时自动补充
	
	s tmplist=$lfs(RuleCode,",")
	
	for i=1:1:$ll(tmplist)
	{
		
		s partRuleCode=$list(tmplist,i)
	
		s keyWordList = $lb("save","print","delete","view","new")
		for kwNum=1:1:$ll(keyWordList)
		{
		
			s tmpKeyWord = $list(keyWordList,kwNum)
			if (partRuleCode[tmpKeyWord)
			{
				
				s listSub = $lfs(partRuleCode,tmpKeyWord)
				for j=1:1:$ll(listSub)
				{
					
					s subListValue = $list(listSub,j)
					continue:'(subListValue["=")
					continue:(subListValue["if")
					s subListValue=$replace(subListValue," ","*")
					s value = $e(subListValue,2)
					if (value=0)
					{
						s newSubListValue = "="""_$e(subListValue,2)_"|"_RuleDesc_""""_$e(subListValue,3,*)
					}
					else
					{
						s newSubListValue = "=" _$e(subListValue,2,*)
					}
					
					s newSubListValue=$replace(newSubListValue,"*"," ")
					s $list(listSub,j)= newSubListValue
					
				}
				
				s partRuleCode = $lts(listSub,tmpKeyWord)
				
			}
		}
		s $list(tmplist,i)= partRuleCode
	}
	//拼接脚本
	s newRuleCode = $lts(tmplist,",")
	s genScript = "//"_RuleDesc_$c(10)_newRuleCode
	q genScript
}

}
