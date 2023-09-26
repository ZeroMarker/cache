Import SQLUser

/// Creator: 		乔庆澳
/// CreateDate: 	2022-06-24
/// Descript: 		前置条件(优化速度)
Class web.DHCCKBPreconditionDataPool Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  提取忽略数据转换成药品相关
/// Input: SyncRRowId : ""(同步所有规则) ,非空(单条规则的数据)
/// w ##Class(web.DHCCKBPreconditionDataPool).SyncPreDataPool(421904)
ClassMethod SyncPreDataPool(SyncRRowId = "")
{
	n (SyncRRowId)
	s $zt="Err"
	
	i SyncRRowId="" &sql(DELETE CF_CKB_PDSS.PreDataPool) ;先清除数据
	i SyncRRowId'="" &sql(DELETE CF_CKB_PDSS.PreDataPool WHERE PDP_Rule_Dr=:SyncRRowId)
	
	s Pid=##Class(web.DHCAPPExaRepCom).NewPid()
	
	i SyncRRowId="" d
	.s RRowId=0
	.f  s RRowId=$o(^CT.CKB.PDSS.RuleD(RRowId)) q:RRowId=""  d
	..d InsertOne
	
	i SyncRRowId'="" d
	.s RRowId=SyncRRowId
	.d InsertOne
	q 0
	
InsertOne
	s RStatus = $lg($g(^CT.CKB.PDSS.RuleD(RRowId)),4)
	q:RStatus'="Release"	;未发布的退出
	s RuleDicInfo = ##Class(web.DHCCKBPreconditionDataPool).GetRuleDicInfo(RRowId)
	s DrugId =$p(RuleDicInfo,"^",1)
	s DirectId =$p(RuleDicInfo,"^",2)
	q:+DrugId=0
	q:+DirectId=0
	s RNParent=""
	f  s RNParent = $o(^CT.CKB.PDSS.RuleNodeI("Parent",RRowId,"if",RNParent)) q:RNParent=""  d
	.s RNRowId = 0
	.f  s RNRowId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",RRowId,"if",+RNParent,RNRowId)) q:RNRowId=""  d
	..s RDRowId=0
	..f  s RDRowId=$o(^CT.CKB.PDSS.RuleDataI("Node",RNRowId,RDRowId)) q:RDRowId=""  d
	...s LeftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(RDRowId)),4)
	...s:'$d(TMPData("IsPrecondition",DirectId,LeftDic)) TMPData("IsPrecondition",DirectId,LeftDic)=##Class(web.DHCCKBPreconditionDataPool).IsPrecondition(DirectId,LeftDic)
	...s IsPrecondition = TMPData("IsPrecondition",DirectId,LeftDic)
	...q:IsPrecondition'="Y"
	...;w DrugId_","_DirectId_","_RRowId_","_RDRowId,!
	...;RRowId 规则id
	...;RDRowId 规则明细Id
	...;b:RRowId=421901 ;100
	...K PLIST
	...s PLIST(2)=DrugId
	...s PLIST(3)=DirectId
	...s PLIST(4)=RRowId
	...s PLIST(5)=RDRowId
	...s PLIST(6)=RNRowId
	...&sql(INSERT INTO CF_CKB_PDSS.PreDataPool VALUES PLIST())
	q ""
	
Err
	s ^TMPData("web.DHCCKBIgnoreDataPool","syncIgnDataPool","SyncPreDataPool")=RDRowId ;记录中断时候的id
	q $ze
}

/// Descript:  Rule获取管理药品ID和目录Id
/// w ##Class(web.DHCCKBPreconditionDataPool).GetRuleDicInfo(421901)
ClassMethod GetRuleDicInfo(RRowId)
{
	n (RRowId)
	
	s CodeStrDrugExt = ",DrugData,ChineseDrugData,ChineseHerbalMedicineData,"
	s CodeStrDirect = ",DrugLibaryData,"
	s AllCode=CodeStrDrugExt_CodeStrDirect
	
	;b ;err
	s DrugId="",DirectId=""
	s RDDicParent=0
	f  s RDDicParent = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",RRowId,RDDicParent)) q:RDDicParent=""  d
	.s CDCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(RDDicParent)),2)
	.s RDRowId=0
	.q:AllCode'[","_CDCode_","
	.f  s RDRowId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",RRowId,RDDicParent,RDRowId)) q:RDRowId=""  d
	..s RDDic = $lg($g(^CT.CKB.PDSS.RuleDicD(RDRowId)),3)
	..;b ;errData
	..s:CodeStrDrugExt[(","_CDCode_",") DrugId=RDDic
	..s:CodeStrDirect[(","_CDCode_",") DirectId=RDDic
	q DrugId_"^"_DirectId
}

/// Descript:  Rule获取管理药品ID和目录Id
/// w ##Class(web.DHCCKBPreconditionDataPool).IsPrecondition(72,46)
ClassMethod IsPrecondition(DirectId, AttrCode)
{
	n (DirectId,AttrCode)
	s Preconditions=##class(web.DHCCKBCommon).GetPreconditions()  //前提条件
	s Ret=""
	
	s LinkPriorityId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DirectId,AttrCode,Preconditions,""))
	s Priority=""
	s:+LinkPriorityId'=0 Priority=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkPriorityId)),5) 	// 前提条件
	q Priority
}

}
