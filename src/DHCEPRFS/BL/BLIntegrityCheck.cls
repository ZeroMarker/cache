Class DHCEPRFS.BL.BLIntegrityCheck Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 添加提交规则
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddRuleDtl("EPRRule001","新版电子病历质控","新版电子病历质控","2018-1-1","2038-1-1","Y")
ClassMethod AddRuleDtl(ARuleCode As %String, ARuleName As %String, ARuleDesc As %String, AStartDate As %String, AEndDate As %String, AIsValid As %String)
{
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s objRule = ##class(DHCEPRFS.INST.CheckRuleList).%New()
	s objRule.RuleCode = ARuleCode
	s objRule.RuleName = ARuleName
	s objRule.RuleDesc = ARuleDesc
	s objRule.StartDate = startDate
	s objRule.EndDate = endDate
	s objRule.IsValid = AIsValid
	
	s sc = objRule.%Save()
	d objRule.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objRule.%Id()
	}
}

/// Desc: 添加提交规则的事务处理
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckRule("EPRRule002","24小时出入院","24小时出入院","2017-1-1","2017-3-31","Y")
ClassMethod AddCheckRule(ARuleCode As %String, ARuleName As %String, ARuleDesc As %String, AStartDate As %String, AEndDate As %String, AIsValid As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckRuleErrorHandler"
	
	s DtlID = ..AddRuleDtl(ARuleCode,ARuleName,ARuleDesc,AStartDate,AEndDate,AIsValid)
	if (DtlID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddCheckRuleErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 根据规则编码取规则名
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).GetRuleNameByCode("EPRRule001")
ClassMethod GetRuleNameByCode(ARuleCode As %String) As %String
{
	s ruleCode = $zcvt(ARuleCode,"U")
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckRuleListI("IdxMain"," "_ruleCode,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.INST.CheckRuleList).%OpenId(rowID)
	s ruleName = obj.RuleName
	d obj.%Close()
	q ruleName
}

/// Desc: 根据就诊号取校验规则名
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).GetRuleNameByEpisodeID("597")
ClassMethod GetRuleNameByEpisodeID(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ""
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s ruleCode = objPat.RuleCode
	d objPat.%Close()
	s ruleCode = $zcvt(ruleCode,"U")
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckRuleListI("IdxMain"," "_ruleCode,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.INST.CheckRuleList).%OpenId(rowID)
	s ruleName = obj.RuleName
	d obj.%Close()
	q ruleName
}

/// Desc: 添加质控类别
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCategoryDtl("1","1","Category001","新版电子病历","新版电子病历","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType02","Y")
ClassMethod AddCategoryDtl(ARuleListID As %String, ASequence As %String, ACategoryCode As %String, ACategoryName As %String, ACategoryDesc As %String, AIsNeeded As %String, AType As %String, AClassName As %String, AMethodName As %String, AIsValid As %String)
{
	s obj = ##class(DHCEPRFS.INST.CheckCategory).%New()
	s obj.RuleListID = ARuleListID
	s obj.Sequence = ASequence
	s obj.CategoryCode = ACategoryCode
	s obj.CategoryName = ACategoryName
	s obj.CategoryDesc = ACategoryDesc
	s obj.IsNeeded = AIsNeeded
	s obj.Type = AType
	s obj.ClassName = AClassName
	s obj.MethodName = AMethodName
	s obj.IsValid = AIsValid
	
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q obj.%Id()
	}
}

/// Desc: 添加质控类别的事务处理
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckCategory("3","5","Category005","出院记录","出院记录","Y","MR","DHCEPRFS.BL.BLCommitCheckMethod","DischargeRecord","Y")
ClassMethod AddCheckCategory(ARuleListID As %String, ASequence As %String, ACategoryCode As %String, ACategoryName As %String, ACategoryDesc As %String, AIsNeeded As %String, AType As %String, AClassName As %String, AMethodName As %String, AIsValid As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckCategoryErrorHandler"
	
	s DtlID = ..AddCategoryDtl(ARuleListID,ASequence,ACategoryCode,ACategoryName,ACategoryDesc,AIsNeeded,AType,AClassName,AMethodName,AIsValid)
	if (DtlID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddCheckCategoryErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 添加病历项
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddItemDtl("1","2","Y")
ClassMethod AddItemDtl(ACategoryID As %String, AMRItemID As %String, AIsValid As %String)
{
	s objDtl = ##class(DHCEPRFS.INST.CheckItem).%New()
	s objDtl.CategoryID =ACategoryID
	s objDtl.MRItemID = AMRItemID
	s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s objDtl.MRItemCode = objMRItem.Code
	s objDtl.MRItemName = objMRItem.Name
	s objDtl.MRItemDesc = objMRItem.Description
	s objDtl.Type = objMRItem.Type
	s objDtl.TypeParams = objMRItem.TypeParams
	d objMRItem.%Close()
	s objDtl.IsValid = AIsValid
	
	s sc = objDtl.%Save()
	d objDtl.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objDtl.%Id()
	}
}

/// Desc: 添加病历项的事务处理
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckItem("1","3","Y")
ClassMethod AddCheckItem(ACategoryID As %String, AMRItemID As %String, AIsValid As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckItemErrorHandler"
	
	s DtlID = ..AddItemDtl(ACategoryID,AMRItemID,AIsValid)
	if (DtlID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddCheckItemErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 批量添加类别
/// Debug: d ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCategoryAll()
ClassMethod AddCategoryAll()
{
	s ruleListID = "1"
	s sc=$$InitCheckCategory(ruleListID,"1","Category001","病案首页","病案首页","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType01","Y","N")
	s sc=$$InitCheckCategory(ruleListID,"2","Category002","入院记录","入院记录","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType01","Y","N")
	s sc=$$InitCheckCategory(ruleListID,"3","Category003","首次病程记录","首次病程记录","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType01","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"4","Category004","一般病程记录","一般病程记录","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType02","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"5","Category005","出院记录","出院记录","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType01","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"6","Category006","诊断证明书","诊断证明书","Y","EPR","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType01","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"7","Category011","手术记录","手术记录","Y","AN","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType03","Y","N")
	s sc=$$InitCheckCategory(ruleListID,"8","Category014","麻醉记录","麻醉记录","Y","AN","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType02","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"9","Category015","手术麻醉相关","手术麻醉相关","Y","AN","DHCEPRFS.BL.BLCommitCheckMethod","MedRecordType02","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"10","Category009","电生理","电生理","Y","EKG","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"11","Category007","检查报告","检查报告","Y","RIS","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"12","Category008","检验报告","检验报告","Y","LIS","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")	
	s sc=$$InitCheckCategory(ruleListID,"13","Category010","病理报告","病理报告","Y","PIS","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")	
	s sc=$$InitCheckCategory(ruleListID,"14","Category012","医嘱单","医嘱单","Y","ORD","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")
	s sc=$$InitCheckCategory(ruleListID,"15","Category013","体温单","体温单","Y","TC","DHCEPRFS.BL.BLCommitCheckMethod","ReportType","Y","Y")
	
	
InitCheckCategory(argRuleListID,argSequence,argCategoryCode,argCategoryName,argCategoryDesc,argIsNeeded,argType,argClassName,argMethodName,argIsValid,argShowStatus)
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_INST.CheckCategory
		where RuleListID = :argRuleListID AND CategoryCode = :argCategoryCode)
	
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_INST.CheckCategory (RuleListID,Sequence,CategoryCode,CategoryName,CategoryDesc,IsNeeded,Type,ClassName,MethodName,IsValid,ShowItemsStatus) 
			values (:argRuleListID, :argSequence, :argCategoryCode, :argCategoryName, :argCategoryDesc, :argIsNeeded, :argType, :argClassName, :argMethodName, :argIsValid, :argShowStatus))
	}
	q "1"
}

/// Desc: 批量添加病历项
/// Input: 各个病历项的参数组成的字符串，病历项字符串之间以'#'分隔，病历项字符串内部以'^'分隔
/// Debug: d ##class(DHCEPRFS.BL.BLIntegrityCheck).AddItemAll()
ClassMethod AddItemAll()
{
	s sc = $$InitCheckItem("1","6^7^8^82^86^255^256")
	s sc = $$InitCheckItem("2","9^10^11^15^16^17^18^36^39^44^47^48^50^51^53^56^58^69^72^73^79^87^88^95^104^105^115^215^216^217^220^221^222")
	s sc = $$InitCheckItem("3","30^43")
	s sc = $$InitCheckItem("4","55^122^123^128")
	s sc = $$InitCheckItem("5","33^52^129^32^49^54^218^219")
	s sc = $$InitCheckItem("6","121")
	s sc = $$InitCheckItem("7","12^13^19^20^21^22^23^35^45^46^57^59^60^61^62^63^64^65^66^67^68^70^71^74^75^76^77^78^93^96^97^98^103^107^108^109^208^209^210^211^212^214")
	s sc = $$InitCheckItem("8","140")
	s sc = $$InitCheckItem("9","34^192^116^83^84^113^198^195")
	s sc = $$InitCheckItem("14","133^134")
	s sc = $$InitCheckItem("15","132")
	s sc = $$InitCheckItem("7","258^259^260")
	s sc = $$InitCheckItem("2","261")	
InitCheckItem(argCategoryID,argItemList)
	f i=1:1:$l(argItemList,"^")
	{
		s mrItemID = $p(argItemList,"^",i)
		s ret = ..AddCheckItem(argCategoryID,mrItemID,"Y")
		if (ret '= "1")
		{
			w argCategoryID_","_mrItemID,!
		}
	}
	q "1"
}

/// Desc: 批量添加病历项
/// Input: 各个病历项的参数组成的字符串，病历项字符串之间以'#'分隔，病历项字符串内部以'^'分隔
/// Debug: d ##class(DHCEPRFS.BL.BLIntegrityCheck).AddItemAll2()
ClassMethod AddItemAll2()
{
	b "s"
	s count = 0		
	for i=425:1:560
	{
		continue:(i = 527)
		continue:(i = 544)
		continue:(i = 550)
		continue:(i = 552)
		continue:(i = 555)
		s count =  count +1
		s ret = ..AddCheckItem("1",i,"Y")
		if (ret '= "1")
		{
			w "1"_","_i,!
		}
	}
	q count
}

/// Desc: 初始化数据
/// Debug: d ##class(DHCEPRFS.BL.BLIntegrityCheck).InitAll()
ClassMethod InitAll()
{
	d ..AddCheckRule("EPRRule001","校验列表","需要校验的所有项目","2017-1-1","2027-1-1","Y")
	d ..AddCategoryAll()
	d ..AddItemAll()
}

/// Desc: 病历文书类型模板，根据模板ID添加病历项
/// Debug: d ##class(DHCEPRFS.BL.BLIntegrityCheck).AddItemByTypeParams("2^574")
ClassMethod AddItemByTypeParams(AItemList As %String)
{
	f i=1:1:$l(AItemList,"#")
	{
		s item = $p(AItemList,"#",i)
		s categoryID = $p(item,"^",1)
		s typeParams = $p(item,"^",2)
		s mrItemID = ""
		s mrItemID = $o(^DHCEPRFS.META.MRItemI("IdxType"," 07"," "_typeParams,mrItemID))
		if (mrItemID = "")
		{
			w typeParams_"对应项目不存在！",!
			continue
		}
		//w categoryID_","_mrItemID,!
		s ret = ..AddCheckItem(categoryID,mrItemID,"Y")
		w ret,!
	}
}

/// Desc: 医生提交pdf时，保存完整性校验信息
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).SaveCheckResult("596","159","EPRRule001")
ClassMethod SaveCheckResult(AEpisodeID As %String, AUserID As %String, ARuleCode As %String) As %String
{
	s checkDate = $p($h,",",1)
	s checkTime = $p($h,",",2)
	s ret = ""
	
	s dtlResult = ..AddCheckedRetDtl(AEpisodeID,checkDate,checkTime,ARuleCode)
	if (dtlResult = "1")
	{
		s infoResult = ..AddCheckedRetList(AEpisodeID,checkDate,checkTime,ARuleCode)
		if (infoResult = "1")
		{
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
			if (rowID = "")
			{
				s patResult = ..AddCheckedPat(AEpisodeID,checkDate,checkTime,AUserID)
				if (patResult = "1")
				{
					s ret = ..UpdateCheckedPat(AEpisodeID,checkDate,checkTime,AUserID,ARuleCode)
				}
			}
			else
			{
				s ret = ..UpdateCheckedPat(AEpisodeID,checkDate,checkTime,AUserID,ARuleCode)
			}
		}
	}
	else
	{
		s ret = "0"
	}
	
	q ret
}

/// Desc: 保存提交规则的各个大类中每一个病历项的校验结果，批量添加，出现错误全部回滚
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedRetDtl("596",64359,52880,"EPRRule003")
ClassMethod AddCheckedRetDtl(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ARuleCode As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckedRetDtlErrorHandler"
	
	s code = $zcvt(ARuleCode,"U")
 	s listRowID = ""
	s listRowID = $o(^DHCEPRFS.INST.CheckRuleListI("IdxMain"," "_code,listRowID))
 	s categoryID = ""
 	f {
	 	s categoryID = $o(^DHCEPRFS.INST.CheckCategoryI("IdxRuleListID"," "_listRowID,categoryID))
	 	q:(categoryID = "")
	 	s objCategory = ##class(DHCEPRFS.INST.CheckCategory).%OpenId(categoryID)
	 	s categoryCode = objCategory.CategoryCode
	 	s categoryType = objCategory.Type
	 	d objCategory.%Close()
	 	//根据类型调用校验接口
	 	if ((categoryType = "EPR")||(categoryType = "ORD")||(categoryType = "TC"))
	 	{
	 		s flag = ..CreateRecordRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryID,categoryCode)
	 	}
	 	elseif (categoryType = "RIS")
	 	{
		 	s retStr = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetRISReport(AEpisodeID)
		 	if (retStr '= "0")
		 	{
				s flag = ..CreateReportRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryCode,retStr)
		 	}
	 	}
	 	elseif (categoryType = "LIS")
	 	{
		 	s retStr = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetLISReport(AEpisodeID)
		 	if (retStr '= "0")
		 	{
				s flag = ..CreateReportRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryCode,retStr)
		 	}
	 	}
	 	elseif (categoryType = "EKG")
	 	{
		 	s retStr = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetEKGReport(AEpisodeID)
		 	if (retStr '= "0")
		 	{
				s flag = ..CreateReportRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryCode,retStr)
		 	}
	 	}
	 	elseif (categoryType = "PIS")
	 	{
		 	s retStr = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetPISReport(AEpisodeID)
		 	if (retStr '= "0")
		 	{
				s flag = ..CreateReportRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryCode,retStr)
		 	}
	 	}
	 	elseif (categoryType = "AN")
	 	{
		 	s retStr = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).HasOperation(AEpisodeID)
		 	if (retStr '= "0")
		 	{
				s flag = ..CreateRecordRetDtl(AEpisodeID,ACheckDate,ACheckTime,categoryID,categoryCode)
		 	}
	 	}
 	}
 	
 	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}
OnAddCheckedRetDtlErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 新建病历类模板的校验结果，也适用于医嘱单、体温单
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).CreateRecordRetDtl("373",64400,63660,"12","Category012")
ClassMethod CreateRecordRetDtl(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryID As %String, ACategoryCode As %String) As %String
{
	s flag = "true"
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.CheckItemI("IdxCategoryID"," "_ACategoryID,rowID))
		q:(rowID = "")
		s objItem = ##class(DHCEPRFS.INST.CheckItem).%OpenId(rowID)
		s mrItemID = objItem.MRItemID
		s mrItemCode = objItem.MRItemCode
		s mrItemName = objItem.MRItemName
		s type = objItem.Type
		s typeParams = objItem.TypeParams
		d objItem.%Close()
		s checkResult = ..GetCheckResultByItemType(AEpisodeID,type,typeParams)
		s isNeed = ..GetIsNeededByItemType(AEpisodeID,type,typeParams)
		s ret = ..CreateCheckedRetDtl(AEpisodeID,ACheckDate,ACheckTime,ACategoryCode,mrItemID,mrItemCode,mrItemName,checkResult,isNeed)
		if (ret = "")
		{
			s flag = "false"
		}
	}
	q flag
}

/// Desc: 校验病历类模板和医嘱单、体温单时，根据类型分情况返回校验结果
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).GetCheckResultByItemType("597","07","630")
ClassMethod GetCheckResultByItemType(AEpisodeID As %String, AType As %String, ATypeParams As %String) As %String
{
	s ret = "0"
	if (AType = "07") //病历文书
	{
		s ret = ##class(DHCEPRFS.BL.HISInfo.BLEPRInfo).NeedPrint(AEpisodeID,ATypeParams)
	}
	elseif (AType = "71")
	{
		s ret = ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,ATypeParams)
	}
	elseif (AType = "31") //长期医嘱
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasCQordToPrint(AEpisodeID)
	}
	elseif (AType = "32") //临时医嘱
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasLSordToPrint(AEpisodeID)
	}
	elseif (AType = "04") //体温单
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasTemperatureToPrint(AEpisodeID)
	}
	elseif (AType = "08") //麻醉记录
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasANToPrint(AEpisodeID)
	}
	elseif (AType = "15") //手术清点单
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPCountToPrint(AEpisodeID)
	}
	
	q ret
}

/// Desc: 校验病历项时，根据类型分情况返回是否必需
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).GetIsNeededByItemType("597","07","630")
ClassMethod GetIsNeededByItemType(AEpisodeID As %String, AType As %String, ATypeParams As %String) As %String
{
	s ret = "Y"
	if (AType = "07")
	{
		if ((ATypeParams = "308")||(ATypeParams = "995")||(ATypeParams = "321")) //急诊留观、抢救记录
		{
			s ret = "N"
		}
		if ((ATypeParams = "335")||(ATypeParams = "292")||(ATypeParams = "199")||(ATypeParams = "202")||(ATypeParams = "287")||(ATypeParams = "325")||(ATypeParams = "326")) //麻醉术前访视、麻醉术后访视、麻醉知情同意书
		{
			s ret = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).HasGeneralAN(AEpisodeID)
		}
	}
	elseif (AType = "08") //麻醉记录
	{
		s ret = ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).HasGeneralAN(AEpisodeID)
	}
	elseif (AType = "71") //麻醉记录
	{
		s ret = "N"
	}
	
	q ret
}

/// Desc: 新建医技类报告的校验结果
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).CreateReportRetDtl("373",64400,63660,"Category009","9125||1^常规心电图^1")
ClassMethod CreateReportRetDtl(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String, ARetStr As %String) As %String
{
	s flag = "true"
	f i=1:1:$l(ARetStr,"!")
	{
		s itemRet = $p(ARetStr,"!",i)
		s orderID = $p(itemRet,"^",1)
		s orderDesc = $p(itemRet,"^",2)
		s checkResult = $p(itemRet,"^",3)
		s ret = ..CreateCheckedRetDtl(AEpisodeID,ACheckDate,ACheckTime,ACategoryCode,"0",orderID,orderDesc,checkResult,"Y")
		s:(ret = "") flag = "false"
	}
	q flag
}

ClassMethod CreateCheckedRetDtl(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ACategoryCode As %String, AMRItemID As %String, AMRItemCode As %String, AMRItemName As %String, ACheckResult As %String, AIsNeeded As %String) As %String
{
	s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.CheckDate = ACheckDate
	s obj.CheckTime = ACheckTime
	s obj.CategoryCode = ACategoryCode
	s obj.MRItemID = AMRItemID
	s obj.MRItemCode = AMRItemCode
	s obj.MRItemName = AMRItemName
	s obj.CheckResult = ACheckResult
	s obj.IsNeeded = AIsNeeded
	
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q obj.%Id()
	}
}

/// Desc: 保存提交规则的各个大类的校验结果，批量添加，出现错误全部回滚
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedRetList("596",64355,52880,"EPRRule003")
ClassMethod AddCheckedRetList(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, ARuleCode As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckedRetListErrorHandler"
	
	s code = $zcvt(ARuleCode,"U")
 	s listRowID = ""
	s listRowID = $o(^DHCEPRFS.INST.CheckRuleListI("IdxMain"," "_code,listRowID))
 	s categoryID = ""
 	f {
	 	s categoryID = $o(^DHCEPRFS.INST.CheckCategoryI("IdxRuleListID"," "_listRowID,categoryID))
	 	q:(categoryID = "")
	 	s objInfo = ##class(DHCEPRFS.INST.CheckedRetList).%New()
	 	s objInfo.EpisodeID = AEpisodeID
	 	s objInfo.CheckDate = ACheckDate
	 	s objInfo.CheckTime = ACheckTime
	 	s objCategory = ##class(DHCEPRFS.INST.CheckCategory).%OpenId(categoryID)
	 	s categoryCode = objCategory.CategoryCode
	 	s objInfo.CategoryCode = categoryCode
	 	s objInfo.CategoryName = objCategory.CategoryName
	 	s className = objCategory.ClassName
	 	s methodName = objCategory.MethodName
	 	s objInfo.IsNeeded = objCategory.IsNeeded
	 	s objInfo.ShowItemsStatus = objCategory.ShowItemsStatus
	 	d objCategory.%Close()
	 	s ret = $ZOBJCLASSMETHOD(className,methodName,AEpisodeID,ACheckDate,ACheckTime,categoryCode)
	 	s objInfo.CheckResult = ret
	 	s sc = objInfo.%Save()
		d objInfo.%Close()
		if ($$$ISERR(sc))
		{
			s flag = "false"
		}
 	}
 	
 	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}
OnAddCheckedRetListErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 添加病人信息
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPatDtl("596",64355,52880,"159")
ClassMethod AddCheckedPatDtl(AEpisodeID As %String, ACreateDate As %String, ACreateTime As %String, AUserID As %String, ARemarks As %String = "")
{
	s episodeInfo = ##class(%ArrayOfDataTypes).%New()
	s episodeInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(AEpisodeID)
	s patientID = episodeInfo.GetAt("PatientID")
	//s patientID = $p(^PAADM(AEpisodeID),"^",1)
	s patientInfo = ##class(%ArrayOfDataTypes).%New()
	s patientInfo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientInfoByPAPMI(patientID)
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%New()
	s objPat.MedRecordNo = patientInfo.GetAt("MedRecordNo")
	s objPat.RegNo = patientInfo.GetAt("RegNo")
	s objPat.EpisodeID = AEpisodeID
	s objPat.Name = patientInfo.GetAt("PAPMIName")
	s objPat.PAAdmDepID = episodeInfo.GetAt("PAAdmLocID")
	s objPat.CreateDate = ACreateDate
	s objPat.CreateTime = ACreateTime
	s objPat.CreateUserID = AUserID
	s objPat.ReviewStatus = "U"
	//s objPat.ReviewDate = ACreateDate
	//s objPat.ReviewTime = ACreateTime
	//s objPat.ReviewUserID = AUserID
	s objPat.DeptReviewStatus = "U"
	//s objPat.DeptReviewDate = ACreateDate
	//s objPat.DeptReviewTime = ACreateTime
	//s objPat.DeptReviewUserID = AUserID
	s objPat.QCReviewStatus = "U"
	//s objPat.QCReviewDate = ACreateDate
	//s objPat.QCReviewTime = ACreateTime
	//s objPat.QCReviewUserID = AUserID
	s objPat.CTMedUnitID = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetMedUnitIDByEpisode(AEpisodeID)
	s objPat.PAAdmType = episodeInfo.GetAt("PAAdmTypeValue")
	s objPat.Remarks = ARemarks
	
	s sc = objPat.%Save()
	d objPat.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objPat.%Id()
	}
}

/// Desc: 添加病人信息的事务处理
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).AddCheckedPat("596",64355,52880,"159")
ClassMethod AddCheckedPat(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, AUserID As %String, ARemarks As %String = "") As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnAddCheckedPatErrorHandler"
	
	s DtlID = ..AddCheckedPatDtl(AEpisodeID,ACheckDate,ACheckTime,AUserID,ARemarks)
	if (DtlID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnAddCheckedPatErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 更新病人校验信息
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).UpdateCheckedPatDtl("596",64320,41935,"159","EPRRule003")
ClassMethod UpdateCheckedPatDtl(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, AUserID As %String, ARuleCode As %String)
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	s objPat.RuleCode = ARuleCode
	s objPat.CheckDate = ACheckDate
	s objPat.CheckTime = ACheckTime
	s objPat.CheckUserID = AUserID
	
	s sc = objPat.%Save()
	d objPat.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objPat.%Id()
	}
}

/// Desc: 更新病人校验信息的事务处理
/// Debug: w ##class(DHCEPRFS.BL.BLIntegrityCheck).UpdateCheckedPat("596",64320,41935,"159","EPRRule003")
ClassMethod UpdateCheckedPat(AEpisodeID As %String, ACheckDate As %String, ACheckTime As %String, AUserID As %String, ARuleCode As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnUpdateCheckedPatErrorHandler"
	
	s DtlID = ..UpdateCheckedPatDtl(AEpisodeID,ACheckDate,ACheckTime,AUserID,ARuleCode)
	if (DtlID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnUpdateCheckedPatErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 查询就诊的完整性校验结果
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLIntegrityCheck","GetCheckResultByEpisode","592")
Query GetCheckResultByEpisode(AEpisodeID As %String) As %Query(ROWSPEC = "CategoryCode:%String,CategoryName:%String,CheckResult:%String,IsNeeded:%String")
{
}

ClassMethod GetCheckResultByEpisodeExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	s checkDate = ""
	s checkDate = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate))
	q:(checkDate = "") $$$OK
	s checkTime = ""
	s checkTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime))
 	s rowID = ""
 	f {
	 	s rowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime,rowID))
	 	q:(rowID = "")
	 	s obj = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(rowID)
	 	s categoryCode = obj.CategoryCode
	 	s categoryName = obj.CategoryName
	 	s checkResult = obj.CheckResult
	 	s isNeeded = obj.IsNeeded
	 	
	 	d obj.%Close()
	 	s ^CacheTemp(repid,ind) = $lb(categoryCode,categoryName,checkResult,isNeeded)
	 	s ind = ind + 1
 	}
	
 	q $$$OK
}

ClassMethod GetCheckResultByEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckResultByEpisodeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetCheckResultByEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckResultByEpisodeExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 查询质控类别中每个子项的完整性校验结果
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLIntegrityCheck","GetCheckRetDtlByCategory","588","Category001")
Query GetCheckRetDtlByCategory(AEpisodeID As %String, ACategoryCode As %String) As %Query(ROWSPEC = "MRItemName:%String,CheckResult:%String,IsNeeded:%String")
{
}

ClassMethod GetCheckRetDtlByCategoryExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ACategoryCode As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	s categoryCode = $zcvt(ACategoryCode,"U")
 	s checkDate = ""
	s checkDate = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate))
	q:(checkDate = "") $$$OK
	s checkTime = ""
	s checkTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime))
	s listRowID = ""
	s listRowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxCategoryCode"," "_AEpisodeID,checkDate,checkTime," "_categoryCode,listRowID))
	s objRet = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(listRowID)
	s showAllItems = objRet.ShowItemsStatus
	d objRet.%Close()
	if (showAllItems = "Y")
	{
 		s rowID = ""
 		f {
	 		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,checkDate,checkTime," "_categoryCode,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
	 		s mrItemName = obj.MRItemName
	 		s checkResult = obj.CheckResult
	 		s isNeeded = obj.IsNeeded
	 		
	 		d obj.%Close()
	 		s ^CacheTemp(repid,ind) = $lb(mrItemName,checkResult,isNeeded)
	 		s ind = ind + 1
 		}
	}
	elseif (showAllItems = "N")
	{
		s rowID = ""
 		f {
	 		s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxCategoryCode"," "_AEpisodeID,checkDate,checkTime," "_categoryCode,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
	 		s mrItemName = obj.MRItemName
	 		s checkResult = obj.CheckResult
	 		s isNeeded = obj.IsNeeded
	 		
	 		d obj.%Close()
	 		continue:(checkResult '= "1")
	 		s ^CacheTemp(repid,ind) = $lb(mrItemName,checkResult,isNeeded)
	 		s ind = ind + 1
 		}
	}
	
 	q $$$OK
}

ClassMethod GetCheckRetDtlByCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckRetDtlByCategoryExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetCheckRetDtlByCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckRetDtlByCategoryExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 查询科室内有手术申请但未提交手术记录的就诊
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLIntegrityCheck","GetEpisodeListByCode","9","2017-3-1","2017-6-30")
Query GetEpisodeListByCode(ACTLocID As %String, AStartDate As %String, AEndDate As %String, ACategoryCode As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,DisDateTime:%String,PAAdmDepCodeDR:%String,CheckDateTime:%String,PAAdmDocCodeDR:%String")
{
}

ClassMethod GetEpisodeListByCodeExecute(ByRef qHandle As %Binary, ACTLocID As %String, AStartDate As %String, AEndDate As %String, ACategoryCode As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
	s:(ACTLocID = $c(0)) ACTLocID = ""
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
    s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
    s ACategoryCode = "Category011"
    s categoryCode = $zcvt(ACategoryCode,"U")
    
    if (ACTLocID '= "")
    {
    	s admRowID = ""
    	f {
	    	s admRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID"," "_ACTLocID,admRowID))
	    	q:(admRowID = "")
	    	s date = ""
			s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID"," "_ACTLocID,admRowID,date))
			q:(date = "")
			continue:((date < startDate)||(date > endDate))
			s time = ""
			s time = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID"," "_ACTLocID,admRowID,date,time))
			s listRowID = ""
			s listRowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxCategoryCode",admRowID,date,time," "_categoryCode,listRowID))
			q:(listRowID = "")
			s objRet = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(listRowID)
			s checkResult = objRet.CheckResult
			d objRet.%Close()
			continue:(checkResult '= "0")
			s rowID = ""
			s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID"," "_ACTLocID,admRowID,date,time,rowID))
			s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
			s episodeID = objPat.EpisodeID
			s medRecordNo = objPat.MedRecordNo
			s regNo = objPat.RegNo
			s name = objPat.Name
			s paAdmDepID = objPat.PAAdmDepID
			d objPat.%Close()
			
			s epiaodeInfo = ##class(%ArrayOfDataTypes).%New()
			s episodeInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(episodeID)
			s admStatus = episodeInfo.GetAt("PAStatusType") 
			//s admStatus = $p(^PAADM(episodeID),"^",20)
			//q:(admStatus '= "D")
			s patientID = episodeInfo.GetAt("PatientID") 
			//s patientID = $p(^PAADM(episodeID),"^",1)
			s disDateTime = episodeInfo.GetAt("PADischgeDateTime")
			//s paDisDate = $p(^PAADM(episodeID),"^",17)
			//s:(paDisDate '= "") disDate = $zd(paDisDate,3)
			//s paDisTime = $p(^PAADM(episodeID),"^",18)
			//s:(paDisTime '= "") disTime = $zt(paDisTime)
			//s disDateTime = disDate_" "_disTime
			if (paAdmDepID '= "")
			{
				s ctLocInfo = ##class(%ArrayOfDataTypes).%New()
				s ctLocInfo = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID(paAdmDepID)
				s paAdmDepCodeDR = ctLocInfo.GetAt("CTLocDesc")
				//s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
				if ($l(paAdmDepCodeDR,"-")>1)
				{
					s paAdmDepCodeDR =$p(paAdmDepCodeDR,"-",2)
				}
			}
			else
			{
				s paAdmDepCodeDR = "无"
			}
			s paAdmDocCodeDR = episodeInfo.GetAt("PAAdmDoc")
			s:(paAdmDocCodeDR = "") paAdmDocCodeDR = "无"
			//s paAdmDocCode=$p(^PAADM(episodeID),"^",9)
			//if (paAdmDocCode '= "")
			//{
				//s paAdmDocCodeDR = $p(^CTPCP(paAdmDocCode,1),"^",2)
			//}
			//else
			//{
				//s paAdmDocCodeDR = "无"
			//}
			s checkDate = $zd(date,3)
			s checkTime = $zt(time)
			s checkDateTime = checkDate_" "_checkTime
			
			s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,disDateTime,paAdmDepCodeDR,paAdmDocCodeDR,checkDateTime)
			s ind = ind + 1
    	}
    }
    else
    {
	    s admDepID = ""
	    f {
		    s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID",admDepID))
		    q:(admDepID = "")
	    	s admRowID = ""
    		f {
	    		s admRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID",admDepID,admRowID))
	    		q:(admRowID = "")
	    		s date = ""
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID",admDepID,admRowID,date))
				q:(date = "")
				continue:((date < startDate)||(date > endDate))
				s time = ""
				s time = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID",admDepID,admRowID,date,time))
				s listRowID = ""
				s listRowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxCategoryCode",admRowID,date,time," "_categoryCode,listRowID))
				q:(listRowID = "")
				s objRet = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(listRowID)
				s checkResult = objRet.CheckResult
				d objRet.%Close()
				continue:(checkResult '= "0")
				s rowID = ""
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxPAAdmDepID",admDepID,admRowID,date,time,rowID))
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
				s episodeID = objPat.EpisodeID
				s medRecordNo = objPat.MedRecordNo
				s regNo = objPat.RegNo
				s name = objPat.Name
				s paAdmDepID = objPat.PAAdmDepID
				d objPat.%Close()
				
				s epiaodeInfo = ##class(%ArrayOfDataTypes).%New()
				s episodeInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(episodeID)
				s admStatus = episodeInfo.GetAt("PAStatusType") 
				//s admStatus = $p(^PAADM(episodeID),"^",20)
				//q:(admStatus '= "D")
				s patientID = episodeInfo.GetAt("PatientID") 
				//s patientID = $p(^PAADM(episodeID),"^",1)
				s disDateTime = episodeInfo.GetAt("PADischgeDateTime")
				//s paDisDate = $p(^PAADM(episodeID),"^",17)
				//s:(paDisDate '= "") disDate = $zd(paDisDate,3)
				//s paDisTime = $p(^PAADM(episodeID),"^",18)
				//s:(paDisTime '= "") disTime = $zt(paDisTime)
				//s disDateTime = disDate_" "_disTime
				if (paAdmDepID '= "")
				{
					s ctLocInfo = ##class(%ArrayOfDataTypes).%New()
					s ctLocInfo = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID(paAdmDepID)
					s paAdmDepCodeDR = ctLocInfo.GetAt("CTLocDesc")
					//s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
					if ($l(paAdmDepCodeDR,"-")>1)
					{
						s paAdmDepCodeDR =$p(paAdmDepCodeDR,"-",2)
					}
				}
				else
				{
					s paAdmDepCodeDR = "无"
				}
				s paAdmDocCodeDR = episodeInfo.GetAt("PAAdmDoc")
				s:(paAdmDocCodeDR = "") paAdmDocCodeDR = "无"
				//s paAdmDocCode=$p(^PAADM(episodeID),"^",9)
				//if (paAdmDocCode '= "")
				//{
					//s paAdmDocCodeDR = $p(^CTPCP(paAdmDocCode,1),"^",2)
				//}
				//else
				//{
					//s paAdmDocCodeDR = "无"
				//}
				s checkDate = $zd(date,3)
				s checkTime = $zt(time)
				s checkDateTime = checkDate_" "_checkTime
				
				s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,disDateTime,paAdmDepCodeDR,paAdmDocCodeDR,checkDateTime)
				s ind = ind + 1
    		}
	    }
    }
	q $$$OK
}

ClassMethod GetEpisodeListByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListByCodeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeListByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListByCodeExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug:w ##class(DHCEPRFS.BL.BLIntegrityCheck).GetCheckResultByMRItem()
ClassMethod GetCheckResultByEpisodeAndItem(AEpisodeID As %String, AMRItemID As %String) As %String
{
	q:(AEpisodeID = "") ""
	q:(AMRItemID = "") ""
		
	s checkDate = ""
	s checkDate = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate))
	q:(checkDate = "") ""
	s checkTime = ""
	s checkTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime))
	q:(checkTime = "") ""
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedRetDtlI("IdxMRItemID"," "_AEpisodeID,checkDate,checkTime," "_AMRItemID,rowID))
	q:(rowID = "") ""
	s obj = ##class(DHCEPRFS.INST.CheckedRetDtl).%OpenId(rowID)
	s result =  obj.CheckResult
	q result
}

ClassMethod UpdateMRVerItem(ASysCode As %String, AEpisodeID As %String) As %String
{
	s count = 0
	q:(AEpisodeID = "") ""
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," "_ASysCode," "_AEpisodeID,""))
	q:(mrEpisodeID = "") ""
	s mrVersion = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0","")
	q:(mrVersion = "") ""
	s mrItemID = ""
	for {
		s mrItemID = $o(^DHCEPRFS.INST.MRVerItem("IdxMain"," "_mrVersion,mrItemID))
		q:(mrItemID = "")
		
		s rowID = ""
		s rowID = $o(^DHCEPRFS.INST.MRVerItem("IdxMain"," "_mrVersion,mrItemID,rowID))
		continue:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(rowID)
		s itemID = obj.MRItemID
		
		s ret = ..GetCheckResultByEpisodeAndItem(AEpisodeID,itemID)
		continue:(ret = "")
		if (ret = "0")
		{
			s obj.DeleteFlag = "Y"
		}
		elseif (ret = "1")
		{
			s obj.DeleteFlag = "N"
		}
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s count = count +1
		}	
	}
	q count
}

}
