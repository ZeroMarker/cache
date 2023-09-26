Import sqluser

/// Creator:      qunianpeng
/// CreatDate:    2020-09-15
/// Description:  规则核对操作类
Class web.DHCCKBCheckRule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	根据医院查询his药品列表
/// Creator:					QuNianpeng 
/// CreateDate:		2020-09-15	
/// Input:							医院id,分类id,药品条件
/// return:						药品列表
/// other:			w ##class(web.DHCCKBCheckRule).QueryDrugList("30","1","100","","YP00000005","","105")
ClassMethod QueryDrugList(rows, page, hospID, catID = "", input = "", levels = "", dicType = "DrugData", searchRuleCode = "", rulePar = "") As %String
{
	
	n (rows,page,hospID,catID,input,levels,dicType,searchRuleCode,rulePar)	
	
	i +dicType'=0 s dicType=$lg(^CT.CKB.PDSS.CommonDictionD(+dicType),2)
	e  s dicType="DrugData"
	
	s end = page*rows
	s start=(page-1)*rows+1
	
	k TmpArr	
	d ..QueryDrugDataByHosp(.TmpArr,hospID,catID,input,levels,dicType,searchRuleCode,rulePar)

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

/// Description:	 根据医院查询药品列表
/// Creator:					QuNianpeng 
/// CreateDate:		2020-09-15	
/// Input:							医院id,分类id,药品条件
/// return:						药品列表
/// other:			w ##class(web.DHCCKBCheckRule).QueryDrugDataByHosp("","","","","","","")
ClassMethod QueryDrugDataByHosp(TmpArr, hospID, catID, input, levels = "", dicType = "DrugData", searchRuleCode = "", rulePar = "") As %String
{
	n (TmpArr,hospID,catID,input,levels,dicType,searchRuleCode,rulePar)
	s type = dicType
	b
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
	.q:(input'="")&(extCode'[input)&(extDesc'[input)	// 药品名称检索
	.// 找到对照的药品名称
	.s contrID=""
	.f  s contrID=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode),contrID))		q:contrID=""  d
	..s listData = $g(^CKB.PDSS.ComContrastD(contrID))
	..s libCode = $lg(listData,2) 
	..s libDesc = $lg(listData,3)
	..s libCode=$replace(libCode,"）",")")
	..s libCode=$replace(libCode,"（","(")
	..s libID=##class(web.DHCCKBCommon).GetDicIdByCode(libCode,parrefData)
	..s:+libID=0 libID=##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,parrefData)
	..q:+libID=0
	..q:0=##class(web.DHCCKBCommon).IsExistRule(libID)
	..q:##class(web.DHCCKBCommon).IsEnabled(libID)=0 // 停用
	..q:1'=##class(web.DHCCKBCommon).IsExistWarnRule(libID,levels)
	..s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",libID,"confirm"))	// 药品核实 2021/2/4 sufan
	..s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	..s confirmImg=$case(drugConfirmFlag>0,1:confirmImg,:"")
	..//s drugLinkCat=##class(web.DHCCKBCommon).GetPhCatAlone(libID,1)
	..//s drugLinkCat=##Class(web.DHCCKBCommon).GetAlonePhCat(libID,1)
	..//过滤规则条件
	..i searchRuleCode="儿童"  d
	...q:##class(web.DHCCKBCheckRule).IsChildrenDrug(libID)=0
	...s drugLinkCat=##Class(web.DHCCKBCommon).GetPhCatWithParent(libID,1)
	...//q:(catID'="")&($listfind(drugLinkCat,catID)=0)	// 过滤分类
	...q:(catID'="")&(0=##Class(web.DHCCKBCommonUtil).CompareBothList(catID,drugLinkCat))
	...s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	...s TmpArr(libID)=listData
	..e  d	
	...//获取规则目录，规则条件
	...i +rulePar=0  d
	....s drugLinkCat=##Class(web.DHCCKBCommon).GetPhCatWithParent(libID,1)
	....//q:(catID'="")&($listfind(drugLinkCat,catID)=0)	// 过滤分类
	....q:(catID'="")&(0=##Class(web.DHCCKBCommonUtil).CompareBothList(catID,drugLinkCat))
	....s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	....s TmpArr(libID)=listData
	...q:+rulePar=0
	...q:..IsRuleSearchDrug(libID,rulePar,searchRuleCode)=0
	...s drugLinkCat=##Class(web.DHCCKBCommon).GetPhCatWithParent(libID,1)
	...//q:(catID'="")&($listfind(drugLinkCat,catID)=0)	// 过滤分类
	...q:(catID'="")&(0=##Class(web.DHCCKBCommonUtil).CompareBothList(catID,drugLinkCat))
	...s listData=$lb(extId,extCode,extDesc,libID,libCode,libDesc_confirmImg)
	...s TmpArr(libID)=listData

	q ""
}

/// Description:	暂时记录需要修改的规则描述
/// Creator:		QuNianpeng 
/// CreateDate:		2020-09-15	
/// Input:			规则id,修改文本,登录信息,ip地址
/// return:			0失败 1 成功
/// other:			w ##class(web.DHCCKBCheckRule).SaveRuleTemp()
ClassMethod SaveRuleTemp(ruleID, input, userInfo, clientIP) As %String
{
		n (ruleID, input, userInfo, clientIP)
		q:(+ruleID=0)||(input="") 0
		
		s ^Tmp("DHCCKB","web.DHCCKBCheckRule","SaveRuleTemp",ruleID,$i(Tmp("ruleNum")))=$lb(input,userInfo,clientIP)
		
		q 1
}

/// Description:	 加载修改的规则内容
/// Creator:					QuNianpeng 
/// CreateDate:		2020-09-16	
/// Input:							规则id
/// return:						0失败 1 成功
/// other:			w ##class(web.DHCCKBCheckRule).GetTextByRule(42198)
ClassMethod GetTextByRule(ruleID) As %String
{
		n (ruleID)
		q:(+ruleID=0) ""
		
		q:'$d(^Tmp("DHCCKB","web.DHCCKBCheckRule","SaveRuleTemp",ruleID)) ""
		s num=$o(^Tmp("DHCCKB","web.DHCCKBCheckRule","SaveRuleTemp",ruleID,""))
		s text = $g(^Tmp("DHCCKB","web.DHCCKBCheckRule","SaveRuleTemp",ruleID,num))
		q $listget(text)
}

/// Description:	是否进行规则修改标记
/// Creator:		QuNianpeng 
/// CreateDate:		2020-09-16	
/// Input:			规则id
/// return:			1修改过 0 未修改
/// other:			w ##class(web.DHCCKBCheckRule).IsEditRule(42198)
ClassMethod IsEditRule(ruleID) As %String
{
	 n (ruleID)
	 q:$d(^Tmp("DHCCKB","web.DHCCKBCheckRule","SaveRuleTemp",ruleID)) 1
		
	 q 0
}

/// Description:	修改规则级别,消息提醒内容
/// Creator:		QuNianpeng 
/// CreateDate:		2021-03-24	
/// Input:			级别对应的RuleDataID,消息对应的RuleDataID,用户id,IP
/// return:			0 修改成功 非0 修改失败
/// other:			w ##class(web.DHCCKBCheckRule).UpdateRule("42198","1897173&137","","11871^8^1^289^2","192.168.50.76")
ClassMethod UpdateRule(rule, levelIDStr, msgIDStr, userInfo, clientIP) As %String
{
	n (rule,levelIDStr,msgIDStr,userInfo, clientIP)	
	q:(rule="")||((levelIDStr="")&(msgIDStr="")) -1
	
	s ret = 0 
	Ts
	
	// 取消发布,记录日志
	s log = ##class(web.DHCCKBRuleSave).ReleaseStatusAlone(rule,userInfo,"CancelRelease")
	s:log<=0 ret=-1
	q:ret'=0 -1
	
	// 修改级别
	i levelIDStr'="" d
	.s ret = ..UpdateRuleLevel(levelIDStr)
	.s userId = $p(userInfo,"^",1)
	.s userName = $p($g(^SSU("SSUSR",+userId)),"^",2)
	.s data=$lb(userName,userInfo,rule,$p(levelIDStr,"&",1),$p(levelIDStr,"&",2),clientIP,$h)
	.d ..MarkUpdeRule(rule,"level",data)
	q:ret'=0 -1
	
	// 修改消息内容
	i msgIDStr'="" d
	.s ret = ..UpdateRuleMsg(msgIDStr)
	q:ret'=0 -1
	
	// 修改消息提醒标记
	//s ret = ..UpdateRuleMsgFlag()
	//q:ret'=0 -1
	
	// 规则修改日志
	s ruleDataLog=##class(web.DHCCKBRuleLog).SaveRemoveDataLog(log,"update")
	s:ruleDataLog<0 ret=-1
	q:ret'=0 -1
	
	// 发布,记录日志
	s log = ##class(web.DHCCKBRuleSave).ReleaseStatusAlone(rule,userInfo,"Release")
	s:log<=0 ret=-1
	
	i ret'=0 tro
	e  tc
	
	q ret
}

/// Description:	修改规则级别
/// Creator:		QuNianpeng 
/// CreateDate:		2021-03-24	
/// Input:			级别对应的RuleDataID
/// return:			0 修改成功 非0 修改失败
/// other:			w ##class(web.DHCCKBCheckRule).UpdateRule(42198)
ClassMethod UpdateRuleLevel(levelIDStr) As %String
{
	n (levelIDStr)
	
	s ruleDataID = $p(levelIDStr,"&",1)
	s levelID = $p(levelIDStr,"&",2)
	
	q:(ruleDataID="")||(levelID="") 0
	
	&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:levelID where RD_RowID=:ruleDataID )
	
	q SQLCODE
}

/// Description:	修改规则消息
/// Creator:		QuNianpeng 
/// CreateDate:		2021-03-24	
/// Input:			消息对应的RuleDataID
/// return:			0 修改成功 非0 修改失败
/// other:			w ##class(web.DHCCKBCheckRule).UpdateRuleMsg(42198)
ClassMethod UpdateRuleMsg(msgIDStr) As %String
{
	n (msgIDStr)
	
	s ruleDataID = $p(msgIDStr,"&",1)
	s msg = $p(msgIDStr,"&",2)
	
	q:(ruleDataID="")||(msg="") 0
	
	&sql(update CT_CKB_PDSS.RuleData set RD_RightValue=:msg where RD_RowID=:ruleDataID )
	
	q SQLCODE
}

/// Description:	管理级别字典
/// Creator:		QuNianpeng 
/// CreateDate:		2021-03-24	
/// Input:			消息对应的RuleDataID
/// return:			0 修改成功 非0 修改失败
/// other:			w ##class(web.DHCCKBCheckRule).GetLevelFlagData()
ClassMethod GetLevelFlagData() As %String
{
	s parref = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlagData")
	q:+parref=0 ""
	w "["
	s count = 0 
	s id = ""
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:id=""  d
	.s desc = $lg(^CT.CKB.PDSS.CommonDictionD(+id),3)
	.q:desc=""
	.q:0=##class(web.DHCCKBCommon).IsEnabled(id)
	.s listData = id_"^"_desc 
	.s count = count + 1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",listData)	

	w "]"
	q ""
}

/// Description:	记录修改的规则及修改内容
/// Creator:		QuNianpeng 
/// CreateDate:		2021-03-24	
/// Input:			
/// return:			0 修改成功 非0 修改失败
/// other:			w ##class(web.DHCCKBCheckRule).GetLevelFlagData()
ClassMethod MarkUpdeRule(rule, type, dataList) As %String
{
	n (rule,type,dataList)
	
	s uniqeIdentity=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),5)
	s ^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqeIdentity,type)=dataList
}

/// Creator: 	sunhuiyong
/// CreateDate: 2022-08-29
/// Descript: 	查询药品规则目录列表
/// w ##class(web.DHCCKBCheckRule).QueryDrugLibList()
ClassMethod QueryDrugLibList(q = "") As %String
{
  
	n (q)
	s parref=##class(web.DHCCKBCommon).GetDrugLibaryData()
  	s count=0
  	s DicID=0
  	w "["
  	f  s DicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,DicID)) q:DicID=""  d
	.s Desc = $lg(^CT.CKB.PDSS.CommonDictionD(+DicID),3)
  	.s Code= $lg(^CT.CKB.PDSS.CommonDictionD(+DicID),2)
  	.s QuitStr = Code_Desc
  	.Q:(q'="")&&(QuitStr'[q)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",DicID_"^"_Desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",DicID_"^"_Desc)
 	w "]"
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
	..s:AgeUni'="" AgeUni=$lg(^CT.CKB.PDSS.CommonDictionD(+AgeUni),3)
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
	.s:AgeUni'="" AgeUni=$lg(^CT.CKB.PDSS.CommonDictionD(+AgeUni),3)
	.q:(Age="")||(AgeAction="")
	.s:'((Age>=18)&&((AgeUni="岁")||(AgeUni="年"))&&((AgeAction="GreaterThen")||(AgeAction="GreaterThenEquals"))) ret=1
	.q:ret=1
	q ret
}

}
