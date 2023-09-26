Import SQLUser

/// 目录优先级
/// zhouxin
/// 2019-06-21
Class web.DHCCKBRulePriority Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 查询规则里已经使用的属性
/// CT_CKB_PDSS.DicLinkAttr
/// DLA_Dic_Dr(规则目录 ##class(web.DHCCKBCommon).GetDrugLibary())
/// DLA_AttrCode(属性字典)
/// DLA_Attr_Dr(前提条件|Preconditions/是否可用|Available 的字典id)
/// DLA_Result(结果 Y/N)
/// w ##class(web.DHCCKBRulePriority).ListRuleDic(72)
ClassMethod ListRuleDic(catId = "")
{
	n (%request,catId)	
	s availableId=##class(web.DHCCKBCommon).GetAvailable()        //可用标志
	s preconditions=##class(web.DHCCKBCommon).GetPreconditions()  //前提条件
	s prop=##class(web.DHCCKBCommon).GetCheckItmListProp()		  // 项目列表属性
	s MindMsqId=##class(web.DHCCKBCommon).GetMindInfoProp()
	s RemindLevelId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag") // 提醒消息级别id
	
	s count=0
	s rows=[]
	s link=""
	s link="" f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",catId,prop,link)) q:link=""  d
	.q:link=0
	.s dic=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)	// 具体项目
	.q:+dic=0
	.s count=count+1
	.q:##class(web.DHCCKBCommonUtil).CheckCurRow(count)=0
	.s linkStatusId=##class(web.DHCCKBRulePriority).GetValueByDicAttr(catId,dic,availableId)
	.s ^qqa("ListRuleDic",catId)="" ;dic DLA_Attr_Dr
	.s linkPriorityId=##class(web.DHCCKBRulePriority).GetValueByDicAttr(catId,dic,preconditions)
	.s status="",priority=""	
	.s:+linkStatusId'=0 status=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkStatusId)),5)	// 是否可用	
	.s:+linkPriorityId'=0 priority=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkPriorityId)),5) 	// 前提条件
	.s MsgAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,MindMsqId,""))
	.s RemindMsg=""
	.s:MsgAttrId'="" RemindMsg=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(MsgAttrId)),5)
	.
	.s LevelAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,RemindLevelId,""))
	.s RemindLevel="",RemindLevelDesc=""
	.s:LevelAttrId'="" RemindLevel=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LevelAttrId)),4)
	.s:RemindLevel'="" RemindLevelDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+RemindLevel)),3)	
	.s obj={}
	.d obj.%Set("priorityDicId",preconditions).%Set("statusDicId",availableId)
	.d obj.%Set("dic",dic).%Set("dicName",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d obj.%Set("linkStatusId",linkStatusId).%Set("linkPriorityId",linkPriorityId)
	.d obj.%Set("priority",priority).%Set("status",status)
	.d obj.%Set("RemindMsg",RemindMsg)
	.d obj.%Set("link",link)
	.d obj.%Set("RemindLevel",RemindLevelDesc)
	.d obj.%Set("RemindLevelId",RemindLevel)
	.d rows.%Push(obj)
	s return={}.%Set("rows",rows).%Set("total",count)
	w return.%ToJSON()
	q ""
}

/// w ##class(web.DHCCKBRulePriority).GetValueByDicAttr(56,5,39)
ClassMethod GetValueByDicAttr(catId, dic, valueDicId)
{
	n (catId,dic,valueDicId)
	q:+catId=0 ""
	s ret=0
	s linkId="" f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",catId,dic,linkId)) q:(linkId="")||(ret'=0)  d
	.s:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),4)=valueDicId ret=linkId
	q ret
}

/// w ##class(web.DHCCKBRulePriority).GetDrugLibraryTree()
ClassMethod GetDrugLibraryTree(model = "")
{

	n (model)
	//w ##class(web.DHCCKBRuleIndex).GetDrugLibrary().%ToJSON()
	//q ""
	s OutPutArr=##class(web.DHCCKBRuleIndex).GetDrugLibrary(0,0,0,model)
	
	s globalData=##class(web.DHCCKBCommon).GetGlobalData()
	i ##class(web.DHCCKBCommon).IsEnabled(globalData)=0 w OutPutArr.%ToJSON()
	
	s globalObj={}
	d globalObj.%Set("id",globalData)
	d globalObj.%Set("code",$case(globalData'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(globalData)),2),:""))
	d globalObj.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(globalData)),3))
	
	s tmpArr=[]
	s dic=""
	f  s dic=$o(^CT.CKB.PDSS.CommonDictionI("Parref",globalData,dic))	q:dic=""   d
	.q:##class(web.DHCCKBCommon).IsEnabled(dic)=0
	.q:0=..TmpQuitDrugLibrary($lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.s isRule=##class(web.DHCCKBCommon).IsExistRule(dic)
	.q:isRule=0
	.s ruleJson={}
	.d ruleJson.%Set("id",dic)
	.d ruleJson.%Set("code",$case(dic'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),2),:""))
	.d ruleJson.%Set("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3))
	.d tmpArr.%Push(ruleJson)
	
	d globalObj.%Set("children",tmpArr)
	d OutPutArr.%Push(globalObj)
	w OutPutArr.%ToJSON()
	
	q ""
}

/// 判断是否是数据集合
/// w ##class(web.DHCCKBRulePriority).CheckDictionFlag(22)
ClassMethod CheckDictionFlag(dic)
{
	n (dic)
	s DictionFlag=##class(web.DHCCKBCommon).GetDictionFlag()
	s parrf=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),4)
	q:+parrf=0 0

	s linkId=+$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",parrf,""))
	q:linkId=0 0
	s attrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),4)
	q:DictionFlag=attrCode 1
	q 0
}

/// Creator:	qunianpeng
/// CreatDate:	2019-11-13
/// Description:： 用于手动生成规则中的前提条件项目
/// Input:
/// Other:	w ##class(web.DHCCKBRulePriority).SaveALLRulePrioItm()
ClassMethod SaveALLRulePrioItm()
{
 
	s rule=""	
	f  s rule=$o(^CT.CKB.PDSS.RuleD(rule))  q:rule=""  d
	.d ..SaveRulePriority(rule)
	
	q 0
}

/// Creator:	qunianpeng
/// CreatDate:	2019-11-13
/// Description: 保存规则中目录所拥有的审查项目列表.(如用法用量下审查项目有年龄,性别,,,)
/// Input:
/// w ##class(web.DHCCKBRulePriority).SaveRulePriority(445746)
ClassMethod SaveRulePriority(rule)
{
	n (rule)
	
	s libary=0
	//s drugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	s drugLibaryData=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s drugEduProp=##class(web.DHCCKBCommon).GetDrugEduProp()
	s globalData = ##class(web.DHCCKBCommon).GetGlobalData()
	
	//判断规则中是否有目录
	s dic="" f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dic)) q:dic=""  d
	.s dicParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dic)),4)
	.s:(dicParef=drugLibaryData)||(dicParef=drugEduProp)||(dicParef=globalData) libary=dic

	q:libary=0 0	// 目录
	
	s checkItmListProp=##class(web.DHCCKBCommon).GetCheckItmListProp()
	s ret=0
	
	s parent=""
	f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent))  q:parent=""   d  
	.s node=""
	.f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent,node))  q:node=""   d  
	..q:node=0
	..s rulDataID=""
	..f  s rulDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,rulDataID))  q:rulDataID=""   d
	...q:rulDataID=0
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(rulDataID)),4)	// 实体/属性
	...s leftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(rulDataID)),5)	// 属性
	...s valueDicId=leftDic
	...s link=+##class(web.DHCCKBRulePriority).GetValueByDicAttr(libary,checkItmListProp,valueDicId)
	...//w "link:"_link,!
	...q:link'=0
	...s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	...d obj.DLADicDrSetObjectId(libary)
	...d obj.DLAAttrCodeSetObjectId(checkItmListProp)	
	...d obj.DLAAttrDrSetObjectId(valueDicId)
	...//s obj.DLAResult="Y"
	...s sc=obj.%Save()
	...s:$SYSTEM.Status.IsError(sc) ret=-6	
	
	q ret
}

/// Creator:	qunianpeng
/// CreatDate:	2019-11-13
/// Description:： 保存规则配置中的前提条件和是否可用
/// Input:
/// Other:	w ##class(web.DHCCKBRulePriority).SaveConfigPriority("13358^72^91^31^Y$$13359^72^91^36^Y","72^91^111^RemindMsg")
/// 插入规则目录/属性字典/前提条件、是否可用 的关系
/// DLA_Dic_Dr(规则目录 ##class(web.DHCCKBCommon).GetDrugLibary())
/// DLA_AttrCode(属性字典)(特殊人群,年龄等)
/// DLA_Attr_Dr(前提条件|Preconditions/  是否可用|Available 的字典id)
/// DLA_Result(结果 Y/N)
ClassMethod SaveConfigPriority(str, MindInfoList)
{
	n (str,MindInfoList)
	s ^tempsufan("mind")=$lb(str,MindInfoList)
	s Err=0
	TS
	
	///保存项目
	s Err=..SavePriority(str)
	i Err'=0 tro
	Q:Err'=0 Err
	
	///保存提醒消息
	s Err=..SaveMindInfo(MindInfoList)
	i Err'=0 tro
	Q:Err'=0 Err
	
	///保存消息提醒级别  2022-03-27
	s Err=..SaveMindLevel(MindInfoList)
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q Err
}

/// 保存项目
ClassMethod SavePriority(str)
{
	n (str,MindInfoList)
	
	s ret=0
	
	f i=1:1:$l(str,"$$")  d
	.s tmpstr=$p(str,"$$",i)
	.s linkID=$p(tmpstr,"^",1)
	.s libary=$p(tmpstr,"^",2)	// 目录id存在备注中,表达所属关系
	.i +linkID'=0 d 
	..s linkObj=##class(CT.CKB.PDSS.DicLinkAttr).%OpenId(linkID) 
	.e  d
	..s linkObj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	.
	.s dicID=$p(tmpstr,"^",3)
	.s prop=$p(tmpstr,"^",4)
	.q:(+dicID=0)||(+prop=0)
	.s linkResult=$p(tmpstr,"^",5)
	.s linkObj.DLADicDr=##class(CT.CKB.PDSS.CommonDiction).%OpenId(libary) 
	.s linkObj.DLAAttrCode=##class(CT.CKB.PDSS.CommonDiction).%OpenId(dicID) 
	.s linkObj.DLAAttrDr=##class(CT.CKB.PDSS.CommonDiction).%OpenId(prop)
	.s linkObj.DLAResult=linkResult 	
	.d linkObj.%Save()
	
	k linkObj
	
	q ret
}

/// 保存提醒消息
ClassMethod SaveMindInfo(MindInfoList)
{
	n (MindInfoList)
	s Err=0
	TS
	s Len=$l(MindInfoList,"$$")
	for i=1:1:Len Q:Err'=0  d
	.s TempList=$p(MindInfoList,"$$",i)
	.s MindInfo=$p(TempList,"^",3)		///提醒消息
	.//q:MindInfo=""
	.s MsgAttrId=..GetRlationId(TempList)
	.i +MsgAttrId=0  d
	..s Err=..InsMindInfo(TempList)
	.e  d
	..s Err=..UpdMindInfo(MsgAttrId,TempList)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// 获取目录，项目的关系id
ClassMethod GetRlationId(ListData)
{
	n (ListData)
	s CatId=$p(ListData,"^",1)			///目录Id
	s ProgramId=$p(ListData,"^",2)		///项目Id
	s MindCode=$p(ListData,"^",4)		///提醒消息Code
	s CheckAttrId=##class(web.DHCCKBCommon).GetCheckItmListProp()			//审查项目管理属性
	s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatId,CheckAttrId,ProgramId,""))		//目录项目关系
	s MindMsgId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(MindCode),""))		//提醒消息ID
	s MsgAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,MindMsgId,""))
	Q MsgAttrId
}

ClassMethod InsMindInfo(ListData)
{
	n (ListData)
	s CatId=$p(ListData,"^",1)			///目录Id
	s ProgramId=$p(ListData,"^",2)		///项目Id
	s MindInfo=$p(ListData,"^",3)		///提醒消息
	s MindCode=$p(ListData,"^",4)		///提醒消息Code
	s CheckAttrId=##class(web.DHCCKBCommon).GetCheckItmListProp()			//审查项目管理属性
	s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatId,CheckAttrId,ProgramId,""))		//目录项目关系
	s MindMsgId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(MindCode),""))		//提醒消息ID
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Result) values(:AttrId,:MindMsgId,:MindInfo))
	Q SQLCODE
}

ClassMethod UpdMindInfo(MsgAttrId, ListData)
{
	n (MsgAttrId,ListData)
	s MindInfo=$p(ListData,"^",3)		///提醒消息
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:MindInfo where DLA_RowID=:MsgAttrId )
	Q SQLCODE
}

/// Creator:		qunianpeng
/// CreateDate:		2021-10-22	
/// Input:			字典描述,序号
/// return：		
/// w ##class(web.DHCCKBRulePriority).TmpQuitDrugLibrary()
ClassMethod TmpQuitDrugLibrary(desc) As %String
{
	n (desc)
	s dataList= $lb("用法用量","适应症","禁忌症","配伍禁忌","相互作用","注意事项","不良反应","禁忌证","禁忌","药物过敏")
	s $list(dataList,*+1) = "用法"
	s $list(dataList,*+1) = "功能主治"
	s $list(dataList,*+1) = "液体配置"
	s $list(dataList,*+1) = "皮试用药"
	s $list(dataList,*+1) = "十八反"
	s $list(dataList,*+1) = "十九畏"
	s $list(dataList,*+1) = "门诊处方天数"
	s $list(dataList,*+1) = "急诊处方天数"
	s $list(dataList,*+1) = "特殊制剂超量"
	s $list(dataList,*+1) = "给药途径不符"
	s $list(dataList,*+1) = "男性给药途径"
	s $list(dataList,*+1) = "哺乳期妇女禁用"
	s $list(dataList,*+1) = "高危药品"
	s $list(dataList,*+1) = "成年使用儿科用药的控制"
	s $list(dataList,*+1) = "糖尿病人慎开葡萄糖类药品"
	s $list(dataList,*+1) = "需要水化"
	s $list(dataList,*+1) = "需要冲管"
	s $list(dataList,*+1) = "特殊制剂超量"
	s $list(dataList,*+1) = "皮试药品"		
	s $list(dataList,*+1) = "不可溶配药品"	
		
	s ret = 0
	i $listfind(dataList,desc)>0 s ret = 1

	q ret
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description:： 保存消息提醒级别
/// Input:
/// Other:	w ##class(web.DHCCKBRulePriority).SaveMindLevel
ClassMethod SaveMindLevel(MindInfoList)
{
	n (MindInfoList)
	s Err=0
	TS
	s Len=$l(MindInfoList,"$$")
	for i=1:1:Len Q:Err'=0  d
	.s TempList=$p(MindInfoList,"$$",i)
	.s RemindLevelId = $p(TempList,"^",5) /// 项目提示消息级别id
	.q:RemindLevelId=""
	.s $p(TempList,"^",4)="LevelFlag" //替换属性code
	.s MsgAttrId=..GetRlationId(TempList)
	.i +MsgAttrId=0  d
	..s Err=..InsMindLevel(TempList)
	.e  d
	..s Err=..UpdMindLevel(MsgAttrId,TempList)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description:： 保存消息提醒级别
/// Input:
ClassMethod InsMindLevel(ListData)
{
	n (ListData)
	s CatId=$p(ListData,"^",1)			///目录Id
	s ProgramId=$p(ListData,"^",2)		///项目Id
	s MindInfo=$p(ListData,"^",3)		///提醒消息
	//s MindCode=$p(ListData,"^",4)		///提醒消息Code
	s RemindLevelId = $p(ListData,"^",5) /// 项目提示消息级别id
	s CheckAttrId=##class(web.DHCCKBCommon).GetCheckItmListProp()			//审查项目管理属性
	s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",CatId,CheckAttrId,ProgramId,""))		//目录项目关系
	//s MindMsgId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(MindCode),""))		//提醒消息ID
	s LevelFlag = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr) values(:AttrId,:LevelFlag,:RemindLevelId))
	Q SQLCODE
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description:： 保存消息提醒级别
/// Input:
ClassMethod UpdMindLevel(MsgAttrId, ListData)
{
	n (MsgAttrId,ListData)
	s RemindLevelId=$p(ListData,"^",5)		///提醒消息级别
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:RemindLevelId where DLA_RowID=:MsgAttrId )
	Q SQLCODE
}

}
