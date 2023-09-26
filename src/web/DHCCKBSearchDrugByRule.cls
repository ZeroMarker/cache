Import sqluser

/// Creator:      sunhuiyong
/// CreatDate:    2022-08-24
/// Description:  项目药品查询类（根据规则）
Class web.DHCCKBSearchDrugByRule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	根据医院查询his药品列表
/// Creator:		Shy
/// CreateDate:		2022-08-24	
/// Input:			医院id,规则条件
/// return:			药品列表
/// other:			w ##class(web.DHCCKBSearchDrugByRule).QueryDrugList("30","1","96","","","105")
ClassMethod QueryDrugList(rows, page, hospID, catID = "", input = "", dicType = "DrugData") As %String
{
	
	n (rows,page,hospID,catID,input,dicType)	
	
	i +dicType'=0 s dicType=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicType)),2)
	e  s dicType="DrugData"
	
	s end = page*rows
	s start=(page-1)*rows+1
	
	k TmpArr	
	d ..QueryDrugDataByHosp(.TmpArr,hospID,catID,input,dicType)
	b ;shy
	q:$o(TmpArr(""))="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
	s count=0	
	s listTitle="hisId^hisCode^hisDesc^libId^libCode^libDesc"	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s index=""	  
	f  s index=$o(TmpArr(index)) q:index=""  d
	.s listData=$g(TmpArr(index))
	.s listData=$listtoString(listData,"^")
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符	
	q ""
}

/// Description:	根据医院查询药品列表
/// Creator:		Shy
/// CreateDate:		2022-08-124	
/// Input:			医院id,规则条件
/// return:			药品列表
/// other:			w ##class(web.DHCCKBSearchDrugByRule).QueryDrugDataByHosp()
ClassMethod QueryDrugDataByHosp(TmpArr, hospID, catID, input, dicType = "DrugData") As %String
{
	n (TmpArr,hospID,catID,input,dicType)
	s type = dicType
	q:'$d(^CKB.PDSS.ExtDictionI("Type",+hospID,type)) ""
	s parrefData = $select(
					type="DrugData":##class(web.DHCCKBCommon).GetDrugData(),
					type="ChineseDrugData":##class(web.DHCCKBCommon).GetChineseDrugData(),
					type="ChineseHerbalMedicineData":##class(web.DHCCKBCommon).GetChineseHMData()
	)	

	s extId=""
	s tmpCount = 0
	f  s extId=$o(^CKB.PDSS.ExtDictionI("Type",+hospID,type,extId))		q:extId=""   d
	.s tmpCount = tmpCount +1
	.s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	.s extCode= $lg(extData,2)
	.s extDesc= $lg(extData,3)
	.;q:(input'="")&(extCode'[input)&(extDesc'[input)	// 药品名称检索
	.// 找到对照的药品名称
	.s contrID=""
	.f  s contrID=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode),contrID))		q:contrID=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(contrID))
	..s libCode = $lg(conData,2) 
	..s libDesc = $lg(conData,3)
	..s libCode=$replace(libCode,"）",")")
	..s libCode=$replace(libCode,"（","(")
	..s libID=##class(web.DHCCKBCommon).GetDicIdByCode(libCode,parrefData)
	..s:+libID=0 libID=##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,parrefData)
	..q:+libID=0
	..q:0=##class(web.DHCCKBCommon).IsExistRule(libID)
	..q:##class(web.DHCCKBCommon).IsEnabled(libID)=0 // 停用
	..;q:1'=##class(web.DHCCKBCommon).IsExistWarnRule(libID,levels)
	..s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",libID,"confirm"))	// 药品核实 2021/2/4 sufan
	..s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	..s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	..//过滤规则条件
	..i input="儿童"  d
	...q:##class(web.DHCCKBSearchDrugByRule).IsChildrenDrug(libID)=0
	...s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	...s TmpArr(libID)=listData
	..e  d	
	...//获取规则目录，规则条件
	...i +catID=0  d
	....s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	....s TmpArr(libID)=listData
	...q:+catID=0
	...q:..IsRuleSearchDrug(libID,catID,input)=0
	...s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	...s TmpArr(libID)=listData

	q ""
}

/// Description:	查询是否为儿童药品
/// Creator:		Shy
/// CreateDate:		2022-08-124	
/// Input:			DicID
/// return:			0：不是,1：是
/// other:			w ##class(web.DHCCKBSearchDrugByRule).IsChildrenDrug("150")
ClassMethod IsChildrenDrug(DicId) As %String
{
	n (DicId)
	q:DicId="" 0
	s errFlag=0
	s RDID=""
	f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:(RDID="")||(errFlag=1)  d
	.s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	.q:+Rule=0
	.s Node="",ret=0
	.s NodeCheck=""
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,"74"))   //只判断禁忌证
	.s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")||(ret=1)  d
	..s SpecialPeople="",SpecialValue="",ret=0,Age=""
	..;
	..s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="91" SpecialPeople = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)
	..s:(",3930,3937,4001,4016,5842,5952,9318,13760,22136,26634,85310,")[(","_($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)_",")) SpecialValue = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)
	..s:(SpecialPeople'="")&&(SpecialValue'="") ret=1
	..;年龄
	..s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" Age = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),9)
	..s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" AgeAction = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),7)
	..s AgeUni=""
	..s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" AgeUni = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),11)
	..s:AgeUni'="" AgeUni=$lg($g(^CT.CKB.PDSS.CommonDictionD(AgeUni)),3)
	..q:(Age="")||(AgeAction="")
	..s:'((Age>=18)&&((AgeUni="岁")||(AgeUni="年"))&&((AgeAction="GreaterThen")||(AgeAction="GreaterThenEquals"))) ret=1
	..q:ret=1
	.s:ret=1 errFlag=1
	q errFlag
}

/// Description:	查询是否包含规则目录下该规则
/// Creator:		Shy
/// CreateDate:		2022-08-124	
/// Input:			DicID
/// return:			0：不是,1：是
/// other:			w ##class(web.DHCCKBSearchDrugByRule).IsRuleSearchDrug("","")
ClassMethod IsRuleSearchDrug(DicId, RulePar, Input) As %String
{
	n (DicId,RulePar,Input)
	q:RulePar="" 1
	s errFlag=0
	s RDID=""
	f  s RDID=$o(^CT.CKB.PDSS.RuleDicI("Dic",DicId,RDID)) q:(RDID="")||(errFlag=1)  d
	.s Rule=$lg($g(^CT.CKB.PDSS.RuleDicD(RDID)),2)
	.q:+Rule=0
	.s Node="",ret=0
	.s NodeCheck=""
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",Rule,RulePar))   //只判断选中目录下的规则
	.s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")||(ret=1)  d
	..s ruletip=""
	..s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="82" ruletip = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),9)
	..s:ruletip[Input ret=1
	..q:ret=1
	.s:ret=1 errFlag=1
	q errFlag
}

/// Description:	查询是否包含规则目录下该规则
/// Creator:		Shy
/// CreateDate:		2022-08-124	
/// Input:			DicID
/// return:			0：不是,1：是
/// other:			w ##class(web.DHCCKBSearchDrugByRule).getRuleAc("","")
ClassMethod getRuleAc(Rule, Input) As %String
{
	n (Rule,Input)
	q:Rule="" 0
	s ret=0
	s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")||(ret=1)  d
	.s ruletip=""
	.s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="82" ruletip = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),9)
	.s:ruletip[Input ret=1
	.q:ret=1
	q ret
}

/// Description:	查询是否包含规则目录下该规则(儿童规则特殊处理)
/// Creator:		Shy
/// CreateDate:		2022-08-124	
/// Input:			DicID
/// return:			0：不是,1：是
/// other:			w ##class(web.DHCCKBSearchDrugByRule).getChildrenRuleAc("","")
ClassMethod getChildrenRuleAc(Rule, Input) As %String
{
	n (Rule,Input)
	q:Rule="" 0
	s ret=0
	s RuleDataID=""	f  s RuleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",Rule,RuleDataID))  q:(RuleDataID="")||(ret=1)  d
	.s SpecialPeople="",SpecialValue="",Age=""
	.s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="91" SpecialPeople = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)
	.s:(",3930,3937,4001,4016,5842,5952,9318,13760,22136,26634,85310,")[(","_($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)_",")) SpecialValue = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),8)
	.s:(SpecialPeople'="")&&(SpecialValue'="") ret=1
	.;年龄
	.s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" Age = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),9)
	.s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" AgeAction = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),7)
	.s AgeUni=""
	.s:$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),4)="85" AgeUni = $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataID)),11)
	.s:AgeUni'="" AgeUni=$lg($g(^CT.CKB.PDSS.CommonDictionD(AgeUni)),3)
	.q:(Age="")||(AgeAction="")
	.s:'((Age>=18)&&((AgeUni="岁")||(AgeUni="年"))&&((AgeAction="GreaterThen")||(AgeAction="GreaterThenEquals"))) ret=1
	.q:ret=1
	q ret
}

}
