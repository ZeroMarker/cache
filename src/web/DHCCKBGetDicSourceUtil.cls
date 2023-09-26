Import SQLUser

/// Creator: 		qunianpeng
/// CreateDate: 	2020-01-02
/// Descript: 		字典数据出处查询
Class web.DHCCKBGetDicSourceUtil Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		qunianpeng
/// Description:	使用字典id,查询规则中使用到该字典的药品和目录
/// CreatDate:		2020-01-02
/// Input： 		字典id 
/// Output：		
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicSource("30","1","5336","")
ClassMethod QueryDicSource(rows = 10, page = 1, dicID As %String, hospId As %String = "") As %String
{
	n (rows,page,dicID,hospId)
	s ^temptets("dic")=$lb(rows,page,dicID,hospId)
	s end = page*rows
	s start=(page-1)*rows+1
	
	q:+dicID=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+dicID=0 ""
	
	k TmpArr
	d ..QueryDicInRuleValue(dicID,.TmpArr,hospId)	// 查询在规则中 RD_RightDic 被使用的情况
	d ..QueryDicInRuleExt(dicID,.TmpArr,hospId)	// 查询在规则中 RD_RightExt 被使用的情况
	d ..QueryDicInAttrDr(dicID,.TmpArr)		// 在属性关联表 DLA_Attr_Dr 被使用的情况
	d ..QueryDicInDicDr(dicID,.TmpArr)		// 在属性关联表 DLA_DicDr_Dr 被使用的情况
	d ..QueryDicInAttrCode(dicID,.TmpArr)	// 在属性关联表 DLA_AttrCode_Dr 被使用的情况
	
	s h=$o(TmpArr(""),-1)
	q:+h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(+h)	
	q:+h=0 ""
	
	s count=0	
	s listTitle="ruleID^drugID^drugName^libaryID^libaryDesc^left^leftDesc^ruleMark^marks"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(TmpArr(index)) q:index=""  d
	.s listData=$g(TmpArr(index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符
	
	q ""
}

/// Creator:		qunianpeng
/// Description:	判断项目在规则表中 RD_RightDic 字段被使用的情况
/// CreatDate:		2020-04-08
/// Input： 		字典id 
/// Output：		
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInRuleValue(10604,.TmpArr)
ClassMethod QueryDicInRuleValue(dicID As %String, TmpArr, hospId As %String = "") As %String
{
	n (dicID,TmpArr,hospId)
	
	s count=+$o(TmpArr(""))
	
	// 查询数据在规则明细表中 RD_RightDic 字典位置出现的情况
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  q:rightType=""  d
	.s ruleID=""
	.f  s ruleID=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID,ruleID))  q:ruleID=""   d
	..s ruleDicID="",drugID="",libaryID="",commonID=""
	..f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,ruleDicID))  q:ruleDicID=""   d
	...q:'$d(^CT.CKB.PDSS.CommonDictionD(ruleDicID))
	...s parent=$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleDicID)),4)
	...i drugLibary'=parent  s drugID=ruleDicID,commonID=ruleDicID 	// 药品
	...e  s libaryID=ruleDicID  // 目录	
	..Q:(..IsExtdic(drugID,hospId)'=1)
	..s drugParref=$case(drugID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugID)),4),:"")
	..Q:+drugParref=0 
	..s drugParrefDesc=$case(drugParref'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugParref)),3),:"")
	..s drugName=$case(drugID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugID)),3)_"("_drugParrefDesc_")",:"")
	..i libaryID="" s libaryID=commonID,drugName="全局规则"	// 全局规则/子规则
	..s libaryDesc=$case(libaryID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(libaryID)),3),:"")
	..// 寻找列(具体被使用的位置)
	..s dataID=""
	..f  s dataID=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID,ruleID,dataID))  q:dataID=""  d
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(dataID)),5)
	...s leftvalue=$lg($g(^CT.CKB.PDSS.RuleDataD(dataID)),4)
	...s left=$case(leftvalue="",1:leftDic,:leftvalue)
	...s leftDesc=$case(left'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(left)),3),:"")
	...s data=ruleID_"^"_drugID_"^"_drugName_"^"_libaryID_"^"_libaryDesc_"^"_left_"^"_leftDesc_"^"_ruleID_"(规则)"_"^"_"rule"   //sufan 新增rule节点2020-06-23
	...s count=count+1
	...s TmpArr(count)=data

	q ""
}

/// Creator:		qunianpeng
/// Description:	判断项目在规则表- RD_RightExt 单位中被使用的情况
/// CreatDate:		2020-04-08
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInRuleExt(78206)
ClassMethod QueryDicInRuleExt(dicID As %String, TmpArr, hospId As %String = "") As %String
{
	n (dicID,TmpArr,hospId)
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()	
	s count=+$o(TmpArr(""))
	
	//单位字典
	// 查询数据在规则明细表中 RD_RightExt 字典位置出现的情况
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  q:rightType=""  d
	.s ruleID=""
	.f  s ruleID=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,dicID,ruleID))  q:ruleID=""   d	
	..s ruleDicID="",drugID="",libaryID="",commonID=""
	..f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,ruleDicID))  q:ruleDicID=""   d
	...q:'$d(^CT.CKB.PDSS.CommonDictionD(ruleDicID))
	...s parent=$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleDicID)),4)
	...i drugLibary'=parent  s drugID=ruleDicID,commonID=ruleDicID 	// 药品
	...e  s libaryID=ruleDicID  // 目录	
	..Q:(..IsExtdic(drugID,hospId)'=1)
	..s drugParref=$case(drugID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugID)),4),:"")
	..s drugParrefDesc=$case(drugParref'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugParref)),3),:"")
	..s drugName=$case(drugID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(drugID)),3)_"("_drugParrefDesc_")",:"")
	..i libaryID="" s libaryID=commonID,drugName="全局规则"	// 全局规则/子规则
	..s libaryDesc=$case(libaryID'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(libaryID)),3),:"")
	..
	..// 寻找列(具体被使用的位置)
	..s dataID=""
	..f  s dataID=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,dicID,ruleID,dataID))  q:dataID=""  d
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(dataID)),5)
	...s leftvalue=$lg($g(^CT.CKB.PDSS.RuleDataD(dataID)),4)
	...s left=$case(leftvalue="",1:leftDic,:leftvalue)
	...s leftDesc=$case(left'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(left)),3),:"")
	...s data=ruleID_"(规则明细表)"_"^"_drugID_"^"_drugName_"^"_libaryID_"^"_libaryDesc_"^"_left_"^"_leftDesc_"^"_ruleID_"(规则)"_"^"_"rule"   //sufan 新增rule节点2020-06-23
	...s count=count+1
	...s TmpArr(count)=data
	
	q ""
}

/// Creator:		sufan
/// Description:	判断是否是某医院数据
/// CreatDate:		2020-12-24
/// Input： 		药品id,医院名称 
/// Output：		1，是，0：否
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInAttrDr(81302)
ClassMethod IsExtdic(drugId, hospId)
{
	n (drugId,hospId)
	Q:(drugId="")||(hospId="") 1
	s exitFlag = 0
	s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)			//药品Code
	s hisCode = ""
	for  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(drugCode),hisCode))  Q:(hisCode="")||(exitFlag=1)  d
	.s conId = ""
	.for  s conId = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(drugCode),hisCode,conId)) Q:(conId="")||(exitFlag=1)  d  d
	..Q:exitFlag=1
	..s code = $lg(^CKB.PDSS.ComContrastD(conId),4)
	..Q:'$d(^CKB.PDSS.ExtDictionI("Code",hospId,code))
	..s exitFlag = 1
	Q exitFlag
}

/// Creator:		qunianpeng
/// Description:	判断项目在属性关联表-{DLA_Attr_Dr} 字段中被使用的情况
/// CreatDate:		2020-04-08
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInAttrDr(81302)
ClassMethod QueryDicInAttrDr(dicID As %String, TmpArr) As %String
{
	n (dicID,TmpArr)
	
	s count=+$o(TmpArr(""))
	// 查询数据在属性关联表中 DLA_Attr_Dr 字典位置出现的情况
	// ^CT.CKB.PDSS.DicLinkAttrI("Reverse",+{DLA_Attr_Dr},{DLA_AttrCode},{DLA_RowID})
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID)) ""
	
	s attrCode=""
	f  s attrCode=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID,attrCode)) q:attrCode=""  d
	.s attrCodeName=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),3)
	.s attrCodelinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),5)
	.i attrCodelinkDr'="" s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrCodelinkDr)),3)
	.s:(attrCodeName="")&&(attrCodelinkDr'="") attrCodeName=dicName   //sufan 2020-12-14
	.;q:attrCodeName=""
	.s linkID="" 
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID,attrCode,linkID)) q:linkID=""  d
	..s userDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)
	..q:userDicID=""
	..s userName=$lg($g(^CT.CKB.PDSS.CommonDictionD(userDicID)),3)
	..q:userName=""
	..s data=linkID_"^"_userDicID_"^"_userName_"^"_attrCode_"^"_attrCodeName_"^"_""_"^"_""_"^"_linkID_"(属性关联)"_"^"_"prop"  //sufan 新增rule节点2020-06-23
	..s count=count+1
	..s TmpArr(count)=data
	
	q ""
}

/// Creator:		qunianpeng
/// Description:	判断项目在属性关联表- {DLA_Dic_Dr} 字段中被使用的情况
/// CreatDate:		2020-04-08
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInDicDr(78206)
ClassMethod QueryDicInDicDr(dicID As %String, TmpArr) As %String
{
	n (dicID,TmpArr)
	
	s count=+$o(TmpArr(""))
	
	// 查询数据在属性关联表中 {DLA_Dic_Dr} 字典位置出现的情况	
	// ^CT.CKB.PDSS.DicLinkAttrI("LinkDic",{DLA_Dic_Dr},{DLA_RowID})
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID)) ""
	
	s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	q:dicName="" ""
	s linkID=""
	f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,linkID)) q:linkID=""  d
	.s attrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),3)
	.s linkDicID=""
	.s:attrCode'="" linkDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),5)
	.i linkDicID'="" s attrCode=linkDicID
	.s attrCodeName=$case(attrCode="",1:"",:$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),3))
	.q:attrCodeName=""
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),3)
	.s attrDrName=$case(attrDr="",1:"",:$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrDr)),3))
	.//q:attrDrName=""
	.s data=linkID_"^"_dicID_"^"_dicName_"^"_attrCode_"^"_attrCodeName_"^"_""_"^"_""_"^"_linkID_"(属性关联)"_"^"_"prop"  //sufan 新增rule节点2020-06-23
	.s count=count+1
	.s TmpArr(count)=data
	
	q ""
}

/// Creator:		qunianpeng
/// Description:	判断项目在属性关联表- {DLA_AttrCode} 字段中被使用的情况
/// CreatDate:		2020-04-08
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicInAttrCode(78206)
ClassMethod QueryDicInAttrCode(dicID As %String, TmpArr) As %String
{
	n (dicID,TmpArr)
	
	s count=+$o(TmpArr(""))
	
	// 查询数据在属性关联表中 {DLA_AttrCode} 字典位置出现的情况	
	// ^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",{DLA_AttrCode},{DLA_RowID})
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",dicID)) ""
	
	s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	i linkDr'="" s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	q:dicName="" ""
	s linkID=""
	f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",dicID,linkID)) q:linkID=""  d
	.s dicDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicDr)),3)
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
	.s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrDr)),3)	
	.s data=linkID_"^"_dicDr_"^"_dicDesc_"^"_dicID_"^"_dicName_"^"_attrDr_"^"_attrDesc_"^"_linkID_"(属性关联)"_"^"_"prop"  //sufan 新增rule节点2020-06-23
	.s count=count+1
	.s TmpArr(count)=data
	
	q ""
}

/// Creator:		qunianpeng
/// Description:	使用字典id,查询规则中使用到该字典的药品和目录 (只提供了循环遍历的部分)
/// CreatDate:		2020-01-02
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicSourceForRule(7917,4103)
ClassMethod QueryDicSourceForRule(dicID As %String, dicDataId As %String) As %String
{
	n (dicID,dicDataId)
	q:+dicID=0 ""
	q:+dicDataId=0 ""
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s oldValue=""
	s rightType=""
	s Result=-1
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  q:rightType=""  d
	.s ruleID=""
	.f  s ruleID=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID,ruleID))  q:ruleID=""   d	
	..// 寻找列
	..//q:'$d(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID,ruleID))
	..s dataID=""
	..f  s dataID=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID,ruleID,dataID))  q:dataID=""  d
	...// 更新这个CT_CKB_PDSS.RuleData 的这个字段{RD_RightDic}, 其中dataID是这个表的id
	...&SQL(select RD_RightDic into :oldValue from CT_CKB_PDSS.RuleData where RD_RowID=:dataID)
	...;s ^DHCCKBRDTmp("RightDic","SaveChange",dataID)=dataID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...s ^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange",dataID)=dataID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...&SQL(Update CT_CKB_PDSS.RuleData Set RD_RightDic=:dicDataId where RD_RowID=:dataID)
	...s:SQLCODE=0 Result=1
	...q:SQLCODE'=0 
	//单位字典
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  q:rightType=""  d
	.s ruleID=""
	.f  s ruleID=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,dicID,ruleID))  q:ruleID=""   d	
	..// 寻找列
	..s dataID=""
	..f  s dataID=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,dicID,ruleID,dataID))  q:dataID=""  d
	...//更新这个CT_CKB_PDSS.RuleData 的这个字段  {RD_RightExt} 其中dataID是这个表的id
	...&SQL(select RD_RightExt into :oldValue from CT_CKB_PDSS.RuleData where RD_RowID=:dataID)
	...;s ^DHCCKBRDTmp("RightExt","SaveChange",dataID)=dataID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...s ^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightExt","SaveChange",dataID)=dataID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...&SQL(Update CT_CKB_PDSS.RuleData Set RD_RightExt=:dicDataId where RD_RowID=:dataID)
	...s:SQLCODE=0 Result=1
	...q:SQLCODE'=0 
	Q Result
}

/// Creator:		qunianpeng
/// Description:	使用字典id,查询规则中使用到该字典的药品和目录（只提供了循环遍历的部分）
/// CreatDate:		2020-01-02
/// Input： 		字典id 
/// Output：		药品,字典目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicSourceForDic(49510,49512)
ClassMethod QueryDicSourceForDic(dicID As %String, dicDataId As %String) As %String
{
	n (dicID,dicDataId)
	s oldValue=""  //记录修改前的值
	s Result=-1
	// 关联关系1
	// ^CT.CKB.PDSS.DicLinkAttrI("Reverse",+{DLA_Attr_Dr},{DLA_AttrCode},{DLA_RowID})
	i $d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID))  d
	.s attrCode=""
	.f  s attrCode=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID,attrCode)) q:attrCode=""  d
	..s attrCodeName=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),3)
	..q:attrCodeName=""
	..s linkID="" 
	..f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID,attrCode,linkID)) q:linkID=""  d
	...s userDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)
	...q:userDicID=""
	...s userName=$lg($g(^CT.CKB.PDSS.CommonDictionD(userDicID)),3)
	...q:userName=""
	...//更新CT_CKB_PDSS.DicLinkAttr表的 +{DLA_Attr_Dr} 字段， linkID 是这个表的id
	...&SQL(select DLA_Attr_Dr into :oldValue from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkID)
	...;s ^DHCCKBDLATmp("DLAAttrDr","SaveChange",linkID)=linkID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...s ^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForDic","DLAAttrDr","SaveChange",linkID)=linkID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	...&SQL(Update CT_CKB_PDSS.DicLinkAttr Set DLA_Attr_Dr=:dicDataId where DLA_RowID=:linkID)
	...s:SQLCODE=0 Result=1
	...s:SQLCODE'=0 Result=SQLCODE
	// 关联关系2
	// ^CT.CKB.PDSS.DicLinkAttrI("LinkDic",{DLA_Dic_Dr},{DLA_RowID})
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID))  d
	.s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.q:dicName=""
	.s linkID=""
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,linkID)) q:linkID=""  d
	..s attrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),3)
	..s linkDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),5)
	..i linkDicID'="" s attrCode=linkDicID
	..s attrCodeName=$case(attrCode="",1:"",:$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),3))
	..q:attrCodeName=""
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),3)
	..s attrDrName=$case(attrDr="",1:"",:$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),3))
	..q:attrDrName=""
	..//  更新CT_CKB_PDSS.DicLinkAttr表的 {DLA_Dic_Dr} linkID 是这个表的id
	..&SQL(select DLA_Dic_Dr into :oldValue from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkID)
	..;s ^DHCCKBDLATmp("DLADicDr","SaveChange",linkID)=linkID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	..s ^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForDic","DLADicDr","SaveChange",linkID)=linkID_"^"_oldValue_"^"_dicDataId   //glb保存该表id、原信息、修改信息
	..&SQL(Update CT_CKB_PDSS.DicLinkAttr Set DLA_Dic_Dr=:dicDataId where DLA_RowID=:linkID)
	..s:SQLCODE=0 Result=1
	..s:SQLCODE'=0 Result=SQLCODE
	Q Result
}

/// Creator:		qunianpeng
/// Description:	获取字典的数据类型呢
/// CreatDate:		2020-01-03
/// Input： 		字典id 
/// Output：		w ##class(web.DHCCKBGetDicSourceUtil).GetDicDataType(69)
ClassMethod GetDicDataType(dicID As %String) As %String
{
	n (dicID)
	
	q:dicID="" ""
	s datasource=##class(web.DHCCKBCommon).GetDataType()
	q:datasource="" ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,datasource)) ""
	s datatypeId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,datasource,""),-1)
	
	q $lg($g(^CT.CKB.PDSS.CommonDictionD(datatypeId)),2)
}

/// Description:  寻找规则中被删除的字典对应的药品和目录
/// w ##class(web.DHCCKBGetDicSourceUtil).QueryDicByDelete()
ClassMethod QueryDicByDelete()
{
	s ruleDataID=170790
	f   s ruleDataID=$o(^CT.CKB.PDSS.RuleDataD(ruleDataID))  q:ruleDataID=""   d
	.s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	.s dicFlag=0
	.i rightDic'="" s dicFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	.s rightDicExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),11)
	.s extFlag=0
	.i rightDicExt'=""  s extFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	.q:(dicFlag>0)&(extFlag>0)
	.s ruleID=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),2)
	.s dicParref=##class(web.DHCCKBCommon).GetDrugData()
	.s ruleDicID="",dicName=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleID,dicParref,ruleDicID))  q:ruleDicID=""  d
	..s dicID=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),3)
	..s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.
	.q:dicName=""
	.s tmpData=dicName_"^"_ruleID	
	
	/*
	s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	s dicFlag=0
	i rightDic'="" s dicFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	s rightDicExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),11)
	s extFlag=0
	i rightDicExt'=""  s extFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDicExt))
	b //1
	q:(dicFlag>0)&(extFlag>0) ""
	s ruleID=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),2)
	s dicParref=##class(web.DHCCKBCommon).GetDrugData()
	s ruleDicID="",dicName=""
	f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleID,dicParref,ruleDicID))  q:ruleDicID=""  d
	.s dicID=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),3)
	.s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	b //22
	q:dicName="" ""
	s tmpData=dicName_"^"_ruleID
	*/
	q tmpData
}

/// 寻找规则中被删除的字典对应的药品和目录
Query QueryDicByDeleteMsg() As websys.Query(ROWSPEC = "f1:%String:药品名称,f2:%String:规则序号")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBGetDicSourceUtil","QueryDicByDeleteMsg")
ClassMethod QueryDicByDeleteMsgExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1	
	s ruleDataID=""
	f   s ruleDataID=$o(^CT.CKB.PDSS.RuleDataD(ruleDataID))  q:ruleDataID=""   d
	.q:+ruleDataID=0
	.s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	.s dicFlag=0
	.i rightDic'="" s dicFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	.q:dicFlag>0
	.s rightDicExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),11)
	.s extFlag=0
	.i rightDicExt'=""  s extFlag=$d(^CT.CKB.PDSS.CommonDictionD(rightDicExt))
	.q:extFlag>0
	.q:(rightDic="")&(rightDicExt="")
	.s ruleID=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),2)
	.s dicParref=##class(web.DHCCKBCommon).GetDrugData()
	.s ruleDicID="",dicName=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleID,dicParref,ruleDicID))  q:ruleDicID=""  d
	..s dicID=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),3)
	..s dicName=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.
	.q:dicName=""
	.s tmpData=dicName_"^"_ruleID	
	.
	.set ^CacheTemp(repid,ind)=$listfromstring(tmpData,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:将修改的内容加入已修改的别名
/// DateTime:2020-02-10
/// Creator:Sunhuiyong
/// Input:修改别名的记录^别名属性ID^加入的别名
/// Debug:
ClassMethod joinOtherName(ListData)
{
	TS
	s DicId=$p(ListData,"^",1)
	s AttrId=$p(ListData,"^",2)
	s otherName=$p(ListData,"^",3)
	s firstListData="0^"_DicId_"^"_AttrId_"^^"
	s lastListData="^"_DicId_"^"_AttrId_"^"_otherName_"^"_"OtherNameProp^0^"
	s mListData=firstListData_lastListData
	s Result= ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(mListData,"datagrid")
	TC:Result=0
	TRO:Result'=0
	q:Result
}

/// Descript: 引用出处界面修改引用名称、加入别名
/// DateTime: 2020-02-07
/// Author: Sunhuiyong
/// Debug: w ##class(web.DHCCKBGetDicSourceUtil).SaveResetAction("7917","4103","8小时一次")
/// Input: 要修改的记录id、改成的记录id、加入的别名
ClassMethod SaveResetAction(dicID As %String, dicDataId As %String, otherName As %String) As %String
{
	q:+dicDataId=0 "-4^请选择指向的字典!"
	q:+dicID=0 "-3"
	s ^TMP("web.DHCCKBGetDicSourceUtil","SaveResetAction","STARTDATA",dicID,dicDataId)=$h    //记录修改操作
	s success=1  //成功标识
	s ruleresult=..QueryDicSourceForDic(dicID,dicDataId)    //修改药品属性列表
	s:ruleresult'=1 success=-1
	b ;err1
	s dicresult=..QueryDicSourceForRule(dicID,dicDataId)    //修改药品规则列表
	s:dicresult'=1 success=-2
	b ;err2
	q success
}

/// Descript:更改规则中字典数据
/// Creator:sufan
/// CreateDate:2020-06-23
/// Input:规则Id^类型&...&...&,元素Id
/// w ##class(web.DHCCKBGetDicSourceUtil).ChangeRuleDic("44571^rule","4140","20218")
ClassMethod ChangeRuleDic(listData, dicId, preDicId, dicProp)
{
	n (listData,dicId,preDicId,dicProp)
	s ^temptest("dicId")=$lb(listData,dicId,preDicId,dicProp)
	s ret = 0
	TS
	s length = $l(listData,"&")
	for i=1:1:length  Q:ret'=0  d
	.s tmpStr = $p(listData,"&",i)				
	.s linkId = $p(tmpStr,"^",1)
	.s type = $p(tmpStr,"^",2)				//类型
	.i type = "prop"  d
	..s ret = ..updDicLinkAttr(linkId,dicId,preDicId,dicProp)		 	//更新关系
	.e  d
	..s ret = ..updRuleLinkDic(linkId,dicId,preDicId,dicProp)			//更新规则
	.Q:ret'=0
	i ret'=0 tro
	Q:ret'=0 ret
	TC
	Q ret
}

/// Descript:更改字典关系数据
/// Creator:sufan
/// CreateDate:2020-06-23
/// Input:关系Id,字典Id
ClassMethod updDicLinkAttr(attrId, dicId, preDicId, dicProp)
{
	n (attrId,dicId,preDicId,dicProp)
	&SQL(Update CT_CKB_PDSS.DicLinkAttr Set DLA_Attr_Dr=:dicId WHERE DLA_RowID=:attrId)
	Q SQLCODE
}

/// Descript:更改规则字典引用
/// Creator:sufan
/// CreateDate:2020-06-23
/// Input:规则Id,字典Id
ClassMethod updRuleLinkDic(ruleId, dicId, preDicId, dicProp)
{
	n (ruleId,dicId,preDicId,dicProp)
	s ret = 0
	TS
	s ret = ..updRuleWithoutUnit(ruleId,dicId,preDicId,dicProp)		//无单位
	
	i ret'=0 tro
	Q:ret'=0 ret
	
	s ret = ..updRuleWithUnit(ruleId,dicId,preDicId,dicProp)		//有单位
	
	i ret'=0 tro
	Q:ret'=0 ret
	TC
	Q ret
}

/// Descript:更改规则字典引用非单位
/// Creator:sufan
/// CreateDate:2020-06-23
/// Input:规则Id,字典Id
ClassMethod updRuleWithoutUnit(ruleId, dicId, preDicId, dicProp)
{
	n (ruleId,dicId,preDicId,dicProp)
	s ret = 0
	TS
	s rightType = ""
	for  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  q:(rightType="")||(ret'=0)  d
	.s ruleDataId = ""
	.for  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,preDicId,ruleId,ruleDataId))  q:(ruleDataId="")||(ret'=0)  d
	..s ruleProp = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	..i dicProp = "" s dicProp = ruleProp
	..s ^TMP("RightDic","updRuleLinkDic",ruleDataId,$h)=ruleDataId_"^"_preDicId_"^"_dicId   //glb保存该表id、原信息、修改信息
	..&SQL(Update CT_CKB_PDSS.RuleData Set RD_RightDic=:dicId ,RD_LeftDic=:dicProp where RD_RowID=:ruleDataId)
	..s ret = SQLCODE
	..q:ret'=0 
	i ret'=0 tro
	Q:ret'=0 ret
	TC
	Q ret
}

/// Descript:更改规则字典引用：单位
/// Creator:sufan
/// CreateDate:2020-06-23
/// Input:规则Id,字典Id
ClassMethod updRuleWithUnit(ruleId, dicId, preDicId, dicProp)
{
	n (ruleId,dicId,preDicId,dicProp)
	s ret = 0
	TS
	//单位字典
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  q:(rightType="")||(ret'=0)  d
	.s ruleDataId=""
	.f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,preDicId,ruleId,ruleDataId))  q:(ruleDataId="")||(ret'=0)   d	
	..s ruleProp = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	..i dicProp = "" s dicProp = ruleProp
	..s ^TMP("RightExt","updRuleLinkDic",ruleDataId,$h)=ruleDataId_"^"_preDicId_"^"_dicId   	//glb保存该表id、原信息、修改信息
	..&SQL(Update CT_CKB_PDSS.RuleData Set RD_RightExt=:dicId ,RD_LeftDic=:dicProp where RD_RowID=:ruleDataId)
	..s ret = SQLCODE
	..q:ret'=0
	i ret'=0 tro
	Q:ret'=0 ret
	TC
	Q ret
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	k ^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSource",pid)
}

/// Descript:k掉临时global
/// w ##class(web.DHCCKBGetDicSourceUtil).ResetTmpGlobal()
ClassMethod ResetTmpGlobal() As %String
{
	
	
	//^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange")
	
	
	s index=0
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange",index))  q:index=""  d
	.s old=$p($g(^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange",index)),"^",2)
	.s id=$p($g(^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange",index)),"^",1)
	.s new=$p($g(^TMP("DHCCKB","web.DHCCKBGetDicSourceUtil","QueryDicSourceForRule","RightDic","SaveChange",index)),"^",3)
	.i old=10753  d
	..&SQL(Update CT_CKB_PDSS.RuleData Set RD_RightDic=:old where RD_RowID=:id)
	..;b ;1
	..w "Yes:"_id_"^"_old_"^"_new
	q 0
}

}
