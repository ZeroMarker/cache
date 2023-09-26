Import SQLUSER

Class web.DHCCKBGuideEdit Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 获取知识目录tree
/// W ##class(web.DHCCKBGuideEdit).GetDrugLibraryTree("78331",0,"11863^6^1^291^2")
ClassMethod GetDrugLibraryTree(dic, rule = 0, userInfo = 0)
{
	n (dic,rule,userInfo)
	s ^temptest("4444")=$lb(dic,rule,userInfo)
	w ..GetDrugLibrary(dic,+rule,userInfo).%ToJSON()
	q ""
}

/// w ##class(web.DHCCKBGuideEdit).GetDrugLibrary("90639",0,"1^1^1^1^2").%ToJSON()
ClassMethod GetDrugLibrary(dicId = 0, rule = 0, userInfo = 0, model = "")
{
	n (dicId,rule,userInfo,model)
	s DrugLibrarys=[]
	//s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s GuideEditId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4("用药指导"),""))
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,id)) q:id=""  d
	.q:+id=0
	.q:id'=GuideEditId
	.q:(model="tmpquit")&(0=##class(web.DHCCKBRulePriority).TmpQuitDrugLibrary($lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)))
	.q:0=##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction",userInfo)	// qunianpeng 2020/3/30 是否停用
	.q:(+dicId'=0)&("N"=##class(web.DHCCKBCommon).IsExistLibaryRule(dicId,id))	//  qunianpeng 2020/8/03 过滤没有规则的目录
	.s DrugLibrary={}
	.s DrugLibrary.id=id
	.s DrugLibrary.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d
	..d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetTreeSubNode(dicId,id,rule,userInfo))
	.e  d
	..i +dicId'=0 d
	...s DrugLibrary.relation=dicId
	...//查找有的规则
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,id,rule,userInfo))
	..e  i rule'=0 d
	...d DrugLibrary.%Set("children",##class(web.DHCCKBRuleIndex).GetRuleByDic(dicId,id,rule,userInfo))
	.d DrugLibrarys.%Push(DrugLibrary)
	q DrugLibrarys
}

/// Description:	获取管理级别combox
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			
/// return:			管理级别集合
/// other:			w ##class(web.DHCCKBGuideEdit).GetLevelFlagComboxData("")
ClassMethod GetLevelFlagComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBGuideEdit","GetLevelFlagComboxData") = $lb(q)
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("LevelFlagData"),""))
	s RowID=""  
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.s LevelFlagCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),2)
	.s LevelFlagDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(LevelFlagDesc)
	.q:(queryCode'="")&&($zcvt(LevelFlagCode,"U")'[queryCode)&&(LevelFlagDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_LevelFlagDesc
	.s ^TMP("DHCCKB","web.DHCCKBGuideEdit","GetLevelFlagComboxData",pid,h)=tempstr     // 数据存储
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBGuideEdit","GetLevelFlagComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBGuideEdit","GetLevelFlagComboxData",pid,index))
	.s count = count+1
	
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取知识来源combox
/// Creator:		Lidong 
/// CreateDate:		2022-8-31	
/// Input:			
/// return:			知识来源集合
/// other:			w ##class(web.DHCCKBGuideEdit).GetKnowSourceComboxData("")
ClassMethod GetKnowSourceComboxData(q As %String = "") As %String
{
	n (q)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s ^TMP("web.DHCCKBGuideEdit","GetKnowSourceComboxData") = $lb(q)
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s Parref=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("KnowSourceData"),""))
	s RowID=""  
	f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,RowID))  q:RowID=""  d
	.s KnowSourceCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),2)
	.s KnowSourceDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	.s pinDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE(KnowSourceDesc)
	.q:(queryCode'="")&&($zcvt(KnowSourceCode,"U")'[queryCode)&&(KnowSourceDesc'[queryCode)&&(pinDesc'[queryCode)
	.s h=h+1
	.s tempstr=RowID_"^"_KnowSourceDesc
	.s ^TMP("DHCCKB","web.DHCCKBGuideEdit","GetKnowSourceComboxData",pid,h)=tempstr     // 数据存储
	q:h=0 ""
	///转换数据为Json格式
	s title="value^text" // 列title 
	w "[" 		//  输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBGuideEdit","GetKnowSourceComboxData",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","web.DHCCKBGuideEdit","GetKnowSourceComboxData",pid,index))
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
/// w ##class(web.DHCCKBGuideEdit).killTmpGlobal("199785")
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("web.DHCCKBGuideEdit","GetLevelFlagComboxData",pid)
	k ^TMP("web.DHCCKBGuideEdit","GetKnowSourceComboxData",pid)
	q ""
}

/// Description:	获取药品输出字典ID
/// Creator:		Lidong 
/// CreateDate:		2022-11-2	
/// Input:			
/// return:			药品输出字典ID
/// other:			w ##class(web.DHCCKBGuideEdit).GetDrugPrintId("")
ClassMethod GetDrugPrintId(q As %String = "") As %String
{
	s DrugPrintId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("DrugPrint"),""))
	q DrugPrintId
}

/// Description:	获取管理级别字典ID
/// Creator:		Lidong 
/// CreateDate:		2022-11-2
/// Input:			
/// return:			管理级别字典ID
/// other:			w ##class(web.DHCCKBGuideEdit).GetLevelFlagId("")
ClassMethod GetLevelFlagId(q As %String = "") As %String
{
	s LevelFlagId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("LevelFlag"),""))
	q LevelFlagId
}

/// Description:	获取提示信息字典ID
/// Creator:		Lidong 
/// CreateDate:		2022-11-2	
/// Input:			
/// return:			提示信息字典ID
/// other:			w ##class(web.DHCCKBGuideEdit).GetWarnMessageId("")
ClassMethod GetWarnMessageId(q As %String = "") As %String
{
	s WarnMessageId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("WarnMessage"),""))
	q WarnMessageId
}

/// Description:	获取知识来源字典ID
/// Creator:		Lidong 
/// CreateDate:		2022-11-2	
/// Input:			
/// return:			知识来源字典ID
/// other:			w ##class(web.DHCCKBGuideEdit).GetKnowSourceId("")
ClassMethod GetKnowSourceId(q As %String = "") As %String
{
	s KnowSourceId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("KnowSource"),""))
	q KnowSourceId
}

/// Description:	获取用药指导字典ID
/// Creator:		Lidong 
/// CreateDate:		2022-11-2	
/// Input:			
/// return:			用药指导字典ID
/// other:			w ##class(web.DHCCKBGuideEdit).GetGuideEditId("")
ClassMethod GetGuideEditId(q As %String = "") As %String
{
	s GuideEditId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4("用药指导"),""))
	q GuideEditId
}

/// Description:	获取规则是否启用
/// Creator:		Lidong 
/// CreateDate:		2022-11-3	
/// Input:			
/// return:			是否启用
/// other:			w ##class(web.DHCCKBGuideEdit).GetRuleData(642939)
ClassMethod GetRuleData(RuleId) As %String
{
	n (RuleId)
	s ResultList=""
	s ^Tmp("GetRuleData")=RuleId
	s IsEnable=$lg($g(^CT.CKB.PDSS.RuleD(RuleId)),4)
	i ResultList="" d
	.s ResultList="IsEnable"_"&"_"Value"_"&"_IsEnable
	e  d
	.s ResultList=ResultList_"^"_"IsEnable"_"&"_"Value"_"&"_IsEnable
	s RuleDataId=""
	f  s RuleDataId=$o(^CT.CKB.PDSS.RuleDataI("Rule",RuleId,RuleDataId)) q:RuleDataId=""  d
	.s Type=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),10)
	
	.i Type="Input" d
	
	..s DataTypeId=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),4)
	..q:DataTypeId=""
	..s RuleDataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(DataTypeId)),2)
	..s Descript=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),9)
	..s RuleData=RuleDataType_"&"_"Value"_"&"_Descript
	
	..i ResultList="" d
	...s ResultList=RuleData
	..e  d
	...s ResultList=ResultList_"^"_RuleData
	
	.i Type="Constant" d
	..s DataTypeId=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),4)
	..q:DataTypeId=""
	..s RuleDataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(DataTypeId)),2)
	..s DescriptId=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),8)
	..i DescriptId'=""  d
	...s Descript=$lg($g(^CT.CKB.PDSS.CommonDictionD(DescriptId)),3)
	..e  d
	...s Descript=""
	..s RuleData=RuleDataType_"&"_DescriptId_"&"_Descript
	
	..i ResultList="" d
	...s ResultList=RuleData
	..e  d
	...s ResultList=ResultList_"^"_RuleData
	
	q ResultList
}

/// Description:	通过实体id获取实例数据
/// Creator:		QuNianpeng 
/// CreateDate:		2022-11-25	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBEditProp).GetDicInstanceByParref("30","1","DataSource","","","","","drugType")
/// other:			w ##class(web.DHCCKBGuideEdit).GetDicInstanceByParref("30","1","5","头孢氨苄胶囊","","")
ClassMethod GetDicInstanceByParref(rows, page, parref, params As %String = "", hospId As %String = "", existGuide = "") As %String
{
	n (rows, page,parref, params,hospId,existGuide) 

	s end = page*rows
	s start=(page-1)*rows+1
	
	s parrefDataId =  ##class(web.DHCCKBCommon).GetDrugData()
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	//i parrefCode="Drug" s parrefDataId = ##class(web.DHCCKBCommon).GetDrugData()
	i parrefCode="ChineseDrug" s parrefDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	i parrefCode="ChineseHerbalMedicine" s parrefDataId = ##class(web.DHCCKBCommon).GetChineseHMData()
	s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parrefDataId)),3)
	 
	s pid=##class(web.DHCCKBCommonUtil).NewPid()	
	s queryCode = $p(params,"^",1)	
	s queryCode = $replace(queryCode,"(","")
	s queryCode = $replace(queryCode,")","")
	s queryCode = $replace(queryCode,"（","")
	s queryCode = $replace(queryCode,"）","")
	s queryCode = $zcvt(queryCode,"U")									  
	
	s h=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefDataId,dicID))  q:dicID=""   d
	.q:##class(web.DHCCKBCommon).IsEnabled(dicID)=0     //sufan 20200415  过滤停用数据	
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.s parrefDesc=""
	.s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.s pinDicDesc = dicDesc //##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s pinDicDesc = $replace(pinDicDesc," ","")
	.s pinDicDesc = $replace(pinDicDesc,"(","")
	.s pinDicDesc = $replace(pinDicDesc,")","")
	.s pinDicDesc = $replace(pinDicDesc,"（","")
	.s pinDicDesc = $replace(pinDicDesc,"）","")
	.q:dicDesc'[queryCode
	.q:(hospId'="")&&(0=##class(web.DHCCKBComContrast).IsSysContrast(dicID,hospId))	// 2021/7/3 增加医院过滤 qnp
	.q:(existGuide'="")&&(0=##class(web.DHCCKBCommon).IsExistGuideRule(dicID))
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,h)=dicID_"^"_dicCode_"^"_dicDesc_"^"_parrefDataId_"^"_parrefDesc_"^"_linkDr_"^"_$g(linkDesc)
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""

	s count=0	
	s listTitle="dicID^dicCode^dicDesc^parref^parrefDesc^linkDr^linkDesc^idList"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	d ..killTmpGlobal(pid)
	
	q ""
}

/// Description:	获取用药指导信息
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-28	
/// Input:			药品/通用名id
/// return:			所有的用药指导信息
/// other:			w ##class(web.DHCCKBGuideEdit).GetGuideInfo(193)
ClassMethod GetGuideInfo(drugId) As %String
{
	n (drugId)

	k TmpArr
	s guideId = ##class(web.DHCCKBCommon).GetDrugEduProp()
	d ##class(web.DHCCKBRuleIndex).QueryAllCatDic(.TmpArr,guideId)
	s drugPrint = ##class(web.DHCCKBCommon).GetDrugPrint()
	s msgProp = ##class(web.DHCCKBCommon).GetWarnMessageProp()

	s outMsg = ""
	// 修改过用药指导,则从用药指导中取汇总消息，否则从规则中汇总
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,guideId))  d
	.s linkDr = ""
	.f  s linkDr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,guideId,linkDr))  q:(linkDr="")||(outMsg'="")  d
	..s outMsg = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkDr)),5)
	
	q:outMsg'="" outMsg	
	
	s index = ""
	f  s index = $o(TmpArr(index))  q:(index="")  d
	.q:'$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,index))
	.s libName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+index)),3)
	.q:libName=""
	.s rule="",libmsg = "",count = 0
	.f  s rule = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,index,rule))  q:rule=""  d
	..s status = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..q:status'="Release"
	..q:'$d(^CT.CKB.PDSS.RuleDataI("Rule",rule))
	..s count = count + 1
	..s ruleDataId = "", msg = ""
	..f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataId)) q:(ruleDataId="")||(msg'="")   d
	...s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),4)
	...s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),5) 
	...q:leftDic'=msgProp
	...q:leftValue'=drugPrint
	...s msg = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),9)
	..q:msg=""
	..s msg = "("_count_")"_msg
	..i libmsg="" s libmsg = msg
	..e  s libmsg = libmsg_";"_msg
	.q:libmsg=""
	.s libmsg = libName_":"_libmsg
	.i outMsg="" s outMsg = libmsg
	.e  s outMsg =libmsg_"."_ $c(10)_outMsg
	
	q outMsg
}

/// Description:	保存用药指导信息
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-28	
/// Input:			药品/通用名id,用药指导信息
/// return:			0 成功, 非0 失败
/// other:			w ##class(web.DHCCKBGuideEdit).SaveGuideInfo(193)
ClassMethod SaveGuideInfo(drugId, msg, userInfo, ip) As %String
{
	
	n (drugId,msg,userInfo,ip)
	
	s libDr = ##class(web.DHCCKBCommon).GetDrugEduProp()
	s listData = "^"_drugId_"^"_libDr_"^^"_msg_"^^"
	s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"text",userInfo,ip)

	q ret
}

}
