Class web.DHCCKBQueryHisUpdateRule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	查询项目修改过的药品列表
/// Creator:		QuNianpeng 
/// CreateDate:		2021-04-01	
/// Input:		  	医院id,药品名称
/// return:			药品列表
/// other:			w ##class(web.DHCCKBQueryHisUpdateRule).QueryHisUpdateDrug(30,1,94,"")
ClassMethod QueryHisUpdateDrug(rows = 30, page = 1, hospId = "", input = "") As %String
{
	n (rows,page,hospId,input)
	
	s ^TtmmWWW = $lb(rows,page,hospId,input)
	s drugName = input
	k TmpArr
	d ..GetHisUpdateDrugList(.TmpArr,hospId,drugName)
	
	s end = page*rows
	s start=(page-1)*rows+1
	
	s count=0	
	s listTitle="libId^libCode^libDesc^conID^hisCode^hisDesc" //QueryHisUpdateDrug	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	
	s index=""	  
	f  s index=$o(TmpArr(index)) q:index=""  d
	.s listData=$g(TmpArr(index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符	
	q ""
}

/// Description:	获取项目修改的药品列表
/// Creator:		QuNianpeng 
/// CreateDate:		2021-04-01
/// Input:			医院id,药品名称
/// return:			药品列表
/// other:			w ##class(web.DHCCKBQueryHisUpdateRule).GetHisUpdateDrugList()
ClassMethod GetHisUpdateDrugList(TmpArr, hospId, drugName) As %String
{
	n (TmpArr,hospId,drugName)
	
	k MarkArr
	s count = 0,num=0
	s uniqe = "",type = "level"
	f  s uniqe = $o(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe))  q:uniqe=""  d
	.q:'$d(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,type))
	.s data = $g(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,type))
	.// 通过规则找到药品,提示信息,级别
	.s rule = ..GetRuleByUniqe(uniqe)
	.q:+rule=0
	.s dicID = ##Class(web.DHCCKBPassNew).GetDicByRuleID(rule)
	.q:+dicID=0
	.s conData = ..GetContrastDrugList(dicID,hospId,drugName)
	.f k=1:1:$listlength(conData)  d
	..s tmpData  = $listget(conData,k)
	..q:tmpData=""
	..s conID = $p(tmpData,"^",4)
	..i '$d(MarkArr(dicID,conID)) d	
	...s MarkArr(dicID,conID)=""
	...s count = count + 1
	...s TmpArr(count) = tmpData

	q ""
}

/// Description:	获取药品对照列表
/// Creator:		QuNianpeng 
/// CreateDate:		2020-09-15	
/// Input:			知识库药品id,医院id,药品名称
/// return:			对照的药品列表
/// other:			w ##class(web.DHCCKBQueryHisUpdateRule).GetContrastDrugList()
ClassMethod GetContrastDrugList(dicID, hospId, drugName = "") As %String
{
	n (dicID,hospId,drugName)
	s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	
	s conData = ""
	s hospFlag = 1
	q:'$d(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(dicCode))) ""  
	s hisCode = ""
	f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(dicCode),hisCode)) q:hisCode=""  d
	.s conID = ""
	.f  s conID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(dicCode),hisCode,conID)) q:conID=""  d
	..s newHisCode = $lg(^CKB.PDSS.ComContrastD(conID),4)
	..s newHisDesc = $lg(^CKB.PDSS.ComContrastD(conID),5)
	..q:(drugName'="")&&(newHisDesc'[drugName)
	..i hospId'="" d
	...s hospFlag = $d(^CKB.PDSS.ExtDictionI("Code",hospId,newHisCode)) //$d(^CKB.PDSS.ExtDictionI("Desc",hospId,newHisDesc))
	..q:hospFlag<=0	// 没对照
	..s tmpData = dicID_"^"_dicCode_"^"_dicDesc_"^"_conID_"^"_newHisCode_"^"_newHisDesc
	..s $list(conData,*+1)=tmpData

	q conData
}

/// Description:	通过药品查询项目修改的规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-04-02
/// Input:			药品名称
/// return:			规则
/// other:			w ##class(web.DHCCKBQueryHisUpdateRule).QueryUpdateRule(542,94)
ClassMethod QueryUpdateRule(queryID, hospId) As %String
{
	n (queryID,hospId)
	s ^Tmpddqq=$lb(queryID,hospId)
	q:(queryID="")||(hospId="") ""
	s drugLibraryArr=[]
	//$g(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,"level"))
	//$lb(userName,userInfo,rule,$p(levelIDStr,"&",1),$p(levelIDStr,"&",2),clientIP,$h)
	s uniqe = "",type = "level"
	f  s uniqe = $o(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe))  q:uniqe=""  d
	.q:'$d(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,type))
	.s data = $g(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,type))
	.// 通过规则找到药品,提示信息,级别
	.s rule = ..GetRuleByUniqe(uniqe)
	.q:rule=0
	.s dicID = ##Class(web.DHCCKBPassNew).GetDicByRuleID(rule)
	.q:+dicID=0
	.q:(queryID'="")&&(dicID'=queryID)
	.s conData = ..GetContrastDrugList(dicID,hospId,"")
	.q:conData=""
	.//s labelDesc = ##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)			// 审查目录
	.s labelId = ##Class(web.DHCCKBPassNew).GetRuleLabelID(rule)
	.d ..GetDrugLibraryTree(dicID,rule,"",labelId,drugLibraryArr)
	
	q drugLibraryArr.%ToJSON()
}

/// Description:	使用唯一标识找到规则序号
/// Creator:		QuNianpeng 
/// CreateDate:		2021-04-06	
/// Input:			唯一标识
/// return:			规则序号
/// other:			w ##class(web.DHCCKBQueryHisUpdateRule).GetRuleByUniqe()
ClassMethod GetRuleByUniqe(uniqe) As %String
{
	n (uniqe)
	
	q:'$d(^CT.CKB.PDSS.RuleI("UniqeIdentity",uniqe)) ""
	
	s rule = +$o(^CT.CKB.PDSS.RuleI("UniqeIdentity",uniqe,""),-1)
	
	q rule
}

/// Description:	获取知识目录tree
/// Creator:		xiaowenwu 
/// CreateDate:		2020-01-15	
/// Input:			dic:药品的ID,rule:规则id,levels(核对界面：管理级别),useFlag:区分调用方(check:规则核对界面)
/// Other:			w ##class(web.DHCCKBQueryHisUpdateRule).GetDrugLibraryTree(23347,47935,"",72)
ClassMethod GetDrugLibraryTree(dic, rule = 0, levels = "", libary = "", drugLibraryArr)
{
	n (dic,rule,levels,libary,drugLibraryArr)

	//d ..GetDrugLibrary(dic,+rule,levels,libary).%ToJSON()
	d ..GetDrugLibrary(dic,+rule,levels,libary,.drugLibraryArr)
	b //1
	q ""
}

/// Description:	获取知识目录tree
/// Creator:		xiaowenwu 
/// CreateDate:		2020-01-15	
/// Input:			dic:药品的ID
/// Other:			w ##class(web.DHCCKBQueryHisUpdateRule).GetDrugLibrary(373).%ToJSON()
ClassMethod GetDrugLibrary(dicId = 0, rule = 0, levels = "", libary = "", drugLibraryArr)
{
	
	n (dicId,rule,levels,libary,drugLibraryArr)
	//s drugLibrarys=[]
	q:(+dicId=0)||(+rule=0)||(+libary=0) ""
	
	s drugdate=##class(web.DHCCKBDrugDetail).GetDrugDate(dicId,libary)
	q:drugdate="" ""
	s drugLibrary={}
	s drugLibrary.id=""_libary
	s drugLibrary.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(libary)),3)
	i +dicId'=0 d
	.s drugLibrary.relation=dicId
	.//查找有的规则
	.d drugLibrary.%Set("children",..GetRuleByDic(dicId,libary,rule,levels))
	
	d drugLibraryArr.%Push(drugLibrary)
	

	q ""
}

/// 判断该目录下是否有药品的输出信息
/// w ##class(web.DHCCKBQueryHisUpdateRule).GetDrugDate(21)
ClassMethod GetDrugDate(dicId = 0, id = 0)
{
	
	n (dicId,id)
	s date=""
	i +dicId'=0 d
	.s sid="" f  s sid=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,sid)) q:sid=""  d
	..s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(sid)),2)
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,id)) d
	...s date=1
	q date
}

/// w ##class(web.DHCCKBQueryHisUpdateRule).GetRuleByDic(23347,72,47935,"").%ToJSON()
ClassMethod GetRuleByDic(dic, relation = 0, ruleId = 0, levels = "")
{
	n (dic,relation,ruleId,levels)
	s retArr=[]
	
	q:(+dic=0)||(+relation=0)||(+ruleId=0) retArr
	s WarnMessage=##class(web.DHCCKBCommon).GetWarnMessageProp() //Descript:药品输出->提示信息属性id
	s LevelProp=##class(web.DHCCKBCommon).GetLevelFlagProp()	// 管理级别属性		
	s img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	s accimg = "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>"
	
	Q:($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)'="Release") retArr
	s edit=""
	i (1=##class(web.DHCCKBCheckRule).IsEditRule(ruleId)) s edit=img // 规则核对界面增加标记 qnp 2020/09/16
	s warnLevelDesc="",warnLevel="",warnID="",msgID=""
	q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,relation)) retArr
	q:'$d(^CT.CKB.PDSS.RuleD(ruleId)) retArr
	s uniqe = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),5)
	q:uniqe="" ""
	s levelStr = $g(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,"level"))
	s newLevel = $listget(levelStr,5)
	s:newLevel'="" newLevel=$lg($g(^CT.CKB.PDSS.CommonDictionD(+newLevel)),3)

	s action=""
	f  s action=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action)) q:action=""  d
	.s parendid=""
	.f  s parendid=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action,parendid)) q:parendid=""  d
	..s rnrowid=""
	..f  s rnrowid=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action,parendid,rnrowid)) q:rnrowid=""  d //CT_CKB_PDSS.RuleData表的RdNode
	...s rdRowID=""
	...f  s rdRowID=$o(^CT.CKB.PDSS.RuleDataI("Node",rnrowid,rdRowID)) q:rdRowID=""  d //CT_CKB_PDSS.RuleData表的RowID
	....s rdLeftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),4)	//表达式左边字典(CT_CKB_PDSS.RuleData表中)
	....i rdLeftDic=LevelProp s warnLevel=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),8),warnID=rdRowID	
	....i +warnLevel'=0 s warnLevelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+warnLevel)),3)
	....q:(levels'="")&(levels'[warnLevelDesc)
	....s:warnLevelDesc'="" warnLevelDesc="【"_warnLevelDesc_"->"_newLevel_"】"	// qnp 2020/09/16 增加级别
	....q:rdLeftDic'=WarnMessage
	....s outDesc=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),9)	//药品输出的提示信息
	....s msgID=rdRowID
	....s realstatus = ""
	....s conFlag=..getRuleSigns(ruleId)			//sufan 2020-11-05
	....s:(($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release")&&(conFlag=1)) realstatus = accimg
	....s ruleJson={}
	....d ruleJson.%Set("id",""_ruleId)
	....d ruleJson.%Set("ruleId",""_ruleId)
	....d ruleJson.%Set("text",realstatus_edit_warnLevelDesc_"("_ruleId_")"_outDesc) 
	....d ruleJson.%Set("content",outDesc) 
	....d ruleJson.%Set("warnID",warnID) 	// 增加级别对应的规则明细id和消息对应规则明细id qnp 2021/3/24
	....d ruleJson.%Set("msgID",msgID) 	
	....d retArr.%Push(ruleJson)	

	q retArr
}

/// Descript:取规则核查标志
/// Creator:sufan 
/// CreateDate:2020-11-05
ClassMethod getRuleSigns(ruleId)
{
	n (ruleId)
	Q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId)) 0
	s funCode = $o(^CKB.PDSS.DicLogI("Function","DHC_CKBRule",ruleId,""),-1)
	Q:funCode="confirm" 1
	Q 0
}

/// Descript:取规则核查标志
/// Creator:sufan 
/// CreateDate:2020-11-05
/// s w ##class(web.DHCCKBQueryHisUpdateRule).test()
ClassMethod test()
{
	s uniqe = "",count = 0
	f  s uniqe=$o(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe))  q:uniqe=""  d
	.i $d(^DHCCKBDHCCKBCheckRuleBaseData("MarkUpdeRule","uniqeIdentity",uniqe,"level"))  d
	..s count = count + 1
	..w count,!
	
	q ""
}

}
