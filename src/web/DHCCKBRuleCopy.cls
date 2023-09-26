Import SQLUser

/// Author:Sunhuiyong
/// Desc:复制规则日志
/// Table：DHCCKB_RuleCopyLog
/// CreatDate:2020-12-11
Class web.DHCCKBRuleCopy Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Desc:   插入复制规则记录
/// Input:  规则来源、目标规则、唯一标识
/// Output：成功：0 失败：err
/// Debug:  w ##class(web.DHCCKBRuleCopy).InsertRuleCopyLog("20")
ClassMethod InsertRuleCopyLog(OrRuleID, ObRuleID, RuleTag) As %String
{
	n (OrRuleID,ObRuleID,RuleTag)
	&SQL(
	
	Insert into CKB_PDSS.RuleCopyLog values (:OrRuleID,:ObRuleID,:RuleTag)
	
	)
	q SQLCODE
}

/// Description:	获取所有的实体(combobox)
/// Creator:		Sunhuiyong
/// CreateDate:		2020-12-10	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBRuleCopy).GetDicComboboxList("","KnowType","DrugData","77900","158")
ClassMethod GetDicComboboxList(q As %String = "", extraAttr, extraAttrValue, mode = "", indicId = "") As %String
{
	n (q,extraAttr,extraAttrValue,mode,indicId)
	s ^temptest("extraAttr") = $lb(q,extraAttr,extraAttrValue,mode,indicId)
	Q:indicId="" ""
	s input = q
	s input = $zcvt(input,"U") // type可传id,可传代码. 传代码时转换为id
	;s drugData=##class(web.DHCCKBCommon).GetDrugData()   //西药字典id
	;s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药字典id
	;s chineseHerbalMedicineData=##class(web.DHCCKBCommon).GetChineseHMData()  //中药饮片
	;s PrescriptionCopeData=##class(web.DHCCKBCommon).PrescriptionCopeData()  //处方应付
	s PrescriptionCopeMode=##class(web.DHCCKBCommon).GetPrescriptionCopeMode()
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(indicId)),4)			//sufan 修改为根据上级获取字典，比较快
	w "["
	s dicID = "", count = 0
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:dicID=0
	.q:##class(web.DHCCKBCommon).IsEnabled(+dicID)=0
	.;q:($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'=drugData)&&($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'=chineseDrugData)&&($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'=chineseHerbalMedicineData)&&(mode'=PrescriptionCopeMode)   //过滤非药品字典数据
	.;q:($lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'=PrescriptionCopeData)&&(mode=PrescriptionCopeMode)
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicCode = $zcvt(dicCode,"U")    //代码
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)   //描述
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(input'="")&(dicCode'[input)&(dicDesc'[input)&(pinDicDesc'[input)   //过滤模糊查询
	.s listData=dicID_"^"_dicDesc
	.s count = count+1
	.;q:(q="")&&(count>50)       //强制限制数据量不要过大  不然combobox加载很卡很卡  --  shy 2021-12-2
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	w "]"

	q ""
}

/// Description:	获取所有的实体(combobox)
/// Creator:		Sunhuiyong
/// CreateDate:		2020-12-10	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBRuleCopy).GetDicComboboxList("","KnowType","DrugData")
ClassMethod GetRuleComboboxList(q As %String = "", extraAttr, extraAttrValue) As %String
{
	n (q,extraAttr,extraAttrValue)
	s input = q
	s input = $zcvt(input,"U") // type可传id,可传代码. 传代码时转换为id
	w "["
	s dicID = "", count = 0
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionD(dicID))  q:dicID=""  d
	.q:dicID=0
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)'="49551"
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicCode = $zcvt(dicCode,"U")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(input'="")&(dicCode'[input)&(dicDesc'[input)&(pinDicDesc'[input)
	.s listData=dicID_"^"_dicDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	w "]"

	q ""
}

}
