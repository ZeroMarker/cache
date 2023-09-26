Class web.DHCCKBDataDeal Extends %RegisteredObject
{

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description:： 	业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DataMigration()
ClassMethod DataMigration() As %String
{
	/* 清除global改造后新表的数据 */
	d ##class(web.DHCCKBCleanData).CleanCKBBaseData() // 基础数据
	d ##class(web.DHCCKBCleanData).CleanCKBConfigData() // 配置数据
	d ##class(web.DHCCKBCleanData).CleanCKBBusinessData() // 业务数据
	
	/* 清除记录迁移数据的global */	
	k ^CKB.PDSS.DataMove 
	
	/* 基础数据码表 */
	d ..CommonDictionMove()
	w "CommonDictionMove",!
	
	/* 基础数据码表更新parref和linkDr */	
	d ..CommonDictionUpdate()
	w "CommonDictionUpdate",!
	
	/* 属性关联表 (依赖基础数据码表 User.DHCCKBCommonDiction) */
	d ..DicLinkAttrMove()	
	w "DicLinkAttrMove",!
	
	/* 规则序号表 */
	d ..RuleMove()
	w "RuleMove",!
	 
	/* 规则索引表 依赖 规则序号表User.DHCCKBRule, 基础数据码表User.DHCCKBCommonDiction */
	d ..RuleDicMove()
	w "RuleDicMove",!
		
	/* 规则节点表 依赖 规则序号表User.DHCCKBRule*/
	d ..RuleNodeMove()
	w "RuleNodeMove",!
	
	/* 规则节点表更新parent */
	d ..RuleNodeUpdate()
	w "RuleNodeUpdate",!
	
	/* 规则明细表 依赖基础数据码表 User.DHCCKBCommonDiction,规则序号表 User.DHCCKBRule,规则节点表 User.DHCCKBRuleNode */
	d ..RuleDataMove()
	w "RuleDataMove",! 
	
	/* 规则目录关联表 依赖基础数据码表 User.DHCCKBCommonDiction,规则序号表 User.DHCCKBRule*/
	d ..DrugLibaryRefMove()
	w "DrugLibaryRefMove",! 
	
	/* 审核忽略配置表 依赖 基础数据码表 User.DHCCKBCommonDiction */
	d ..IgnoreManageMove()
	w "IgnoreManageMove",! 
	
	/* 审核忽略配置数据池表 依赖 基础数据码表 User.DHCCKBCommonDiction 审核忽略配置表 User.DHCCKBIgnoreManage,*/
	d ..IgnoreDataPoolMove()
	w "IgnoreDataPoolMove",! 
	
	/* 前提条件数据池表 依赖 基础数据码表 User.DHCCKBCommonDiction,User.DHCCKBRule,User.DHCCKBRuleData,User.DHCCKBRuleNode */
	d ..PreDataPoolMove()
	w "PreDataPoolMove",! 
		
	/* 数据映射表 依赖基础字典码表 */
	d ..ComContrastMove()
	w "ComContrastMove",! 
	
	/* 疾病病症关系表 依赖 基础数据码表 User.DHCCKBCommonDiction User.DHCCKBComContrast,*/
	d ..DiagRelationMove()
	w "DiagRelationMove",! 
		
	/* 基础数据码表扩展表 用于编码,简拼,通用名等存储, 暂时未启用,无数据,不需要迁移*/
	//d ..ComDictionExtMove()
	
	/* 外部项目字典表 */
	d ..ExtDictionMove()
	w "ExtDictionMove",! 
	
	/* 外部项目字典表 更新parent */
	d ..ExtDictionUpdate()
	w "ExtDictionUpdate",! 
		
	/* 外部项目字典属性关联表（依赖外部项目字典表 User.DHCCKBExtDiction,基础数据码表User.DHCCKBCommonDiction 需要先完成依赖表的数据迁移） */
	d ..DicExtLinkAttrMove()
	w "DicExtLinkAttrMove",! 
	
	/* 字典日志表 依赖 基础数据码表，属性关联表，规则序号表，规则明细表，数据对照表，外部项目字典属性关联表 */
	d ..DicLogMove()
	w "DicLogMove",! 

	/* 知识日志详情表（依赖字典日志表,需要先完成依赖表的数据迁移）*/
	d ..DicDataLogMove()
	w "DicDataLogMove",! 
	
	/* 知识日志详情表更新parent */
	d ..DicDataLogUpdate()	
	w "DicDataLogUpdate",! 
	
	/* 药品检索日志表(业务数据 不需要迁移，迁移方法未修改，存在指向问题) */
	//d ..DrugSearchLogMove()
	
	/* 数据更新日志表(业务数据 不需要迁移，迁移方法未修改，存在指向问题) */
	//d ..KnowUpdateLogMove()

	/* 审核日志主表(业务数据 不需要迁移，迁移方法未修改，存在指向问题) */
	//d ..MonMasterMove()
	
	/* 审核问题明细日志表（依赖审核日志主表,需要先完成依赖表的数据迁移，迁移方法未修改，存在指向问题）(业务数据 不需要迁移) */
	//d ..MonQueListMove()	
	
	/* 审核问题规则明细日志表（依赖审核日志主表,需要先完成依赖表的数据迁移，迁移方法未修改，存在指向问题）(业务数据 不需要迁移) */
	//d ..MonRuleListMove()	
	
	/* 强制审核反馈表（依赖审核日志主表,需要先完成依赖表的数据迁移，迁移方法未修改，存在指向问题） (业务数据 不需要迁移)*/
	//d ..FeedBackMove()
	
	/* 规则日志表 （依赖规则序号表） */
	d ..RuleLogMove()
	w "RuleLogMove",! 
	
	/* 规则日志表 更新RLLastLog */
	d ..RuleLogUpdate()
	w "RuleLogUpdate",! 
	
	/* 规则明细日志表（依赖基础数据码表，规则序号表，规则明细表，规则日志表） */
	d ..RuleDataLogMove()
	w "RuleDataLogMove",! 
	
	/* 规则明细日志表 更新 RDLLastDataLog */
	d ..RuleDataLogUpdate()
	w "RuleDataLogUpdate",! 
	
	/* 规则复制记录表 （依赖规则序号表） */
	d ..RuleCopyLogMove()
	w "RuleCopyLogMove",! 
	q:'$d(^CKB.PDSS.DataMove("MoveErr")) "数据全部迁移成功!"
	
	s type = ""
	f  s type = $o(^CKB.PDSS.DataMove("MoveErr",type)) q:type=""  d
	.s errmsg = $g(^CKB.PDSS.DataMove("MoveErr",type))
	.w errmsg,!
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	基础数据码表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).CommonDictionMove()
ClassMethod CommonDictionMove() As %String
{
	// ^DHCCKBCD({CD_RowID})
	// &SQL(INSERT INTO CT_CKB_PDSS.CommonDiction VALUES (?))
	s rowId = ""
	f  s rowId = $o(^DHCCKBCD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s code = $p(^DHCCKBCD(rowId),"^",1)
	.s desc = $p(^DHCCKBCD(rowId),"^",2)
	.s parref = $p(^DHCCKBCD(rowId),"^",3)
	.s linkdr = $p(^DHCCKBCD(rowId),"^",4)
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%New()
	.s obj.CDCode = code
	.s obj.CDDesc = desc
	.d obj.CDParrefDrSetObjectId(parref) //$case(parref'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",parref,"")),:"") 
	.d obj.CDLinkDrSetObjectId(linkdr) //$case(lindr'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",linkdr,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("CommonDiction",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	基础数据码表更新parref和linkDr  --业务数据迁移(表名global改造后)  放在User.DHCCKBCommonDiction之后
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).CommonDictionUpdate()
ClassMethod CommonDictionUpdate() As %String
{
	// ^CT.CKB.PDSS.CommonDictionD(ID)=$LB(%%CLASSNAME,CDCode,CDDesc,CDParrefDr,CDLinkDr)
	// &SQL(INSERT INTO CT_CKB_PDSS.CommonDiction VALUES (?))
	s rowId = ""
	f  s rowId = $o(^CT.CKB.PDSS.CommonDictionD(rowId))  q:rowId=""  d
	.q:rowId=0 
	.s data = $g(^CT.CKB.PDSS.CommonDictionD(rowId))
	.s parref = $lg(data,4) 
	.s linkdr = $lg(data,5)
	.q:(parref="")&&(linkdr="")
	.s obj=##class(CT.CKB.PDSS.CommonDiction).%OpenId(rowId)
	.d obj.CDParrefDrSetObjectId($case(parref'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",parref,"")),:"") )
	.d obj.CDLinkDrSetObjectId($case(linkdr'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",linkdr,"")),:"")) 
	.s sc=obj.%Save()
	.d obj.%Close()
	.//s ^CKB.PDSS.DataMove("CommonDictionUpdte",rowId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	属性关联表 --业务数据迁移(表名global改造后) 放在User.DHCCKBCommonDiction之后
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicLinkAttrMove()
ClassMethod DicLinkAttrMove() As %String
{
	// ^DHCCKBDLA({DLA_RowID})
	// &SQL(INSERT INTO CT_CKB_PDSS.DicLinkAttr VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DicLinkAttr")="属性关联表 User.DHCCKBDicLinkAttr 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBDLA(rowId))  q:rowId=""  d
	.q:rowId=0
	.s dicDr = $p(^DHCCKBDLA(rowId),"^",1)
	.s attrCode = $p(^DHCCKBDLA(rowId),"^",2)	
	.s attrDr = $p(^DHCCKBDLA(rowId),"^",3)
	.s result = $p(^DHCCKBDLA(rowId),"^",4)
	.s group = $p(^DHCCKBDLA(rowId),"^",5)
	.s tinyTag = $p(^DHCCKBDLA(rowId),"^",6)
	.
	.s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	.d obj.DLADicDrSetObjectId($case(dicDr'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",dicDr,"")),:"")) 
	.d obj.DLAAttrCodeSetObjectId($case(attrCode'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",attrCode,"")),:"")) 
	.d obj.DLAAttrDrSetObjectId($case(attrDr'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",attrDr,"")),:"")) 
	.s obj.DLAResult = result
	.s obj.DLAGroupFlag = group
	.s obj.DLATinyTag = tinyTag	
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("DicLinkAttr",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则序号表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleMove()
ClassMethod RuleMove() As %String
{
	// ^DHCCKBRULE({R_RowId})
	// &SQL(INSERT INTO CT_CKB_PDSS.Rule VALUES (?))
	s rowId = ""
	f  s rowId = $o(^DHCCKBRULE(rowId))  q:rowId=""  d
	.q:rowId=0
	.s mark = $p(^DHCCKBRULE(rowId),"^",1)
	.s name = $p(^DHCCKBRULE(rowId),"^",2)
	.s status = $p(^DHCCKBRULE(rowId),"^",3)
	.s identity = $p(^DHCCKBRULE(rowId),"^",4)
	.s obj=##class(CT.CKB.PDSS.Rule).%New()
	.s obj.RRemark = mark
	.s obj.RName = name
	.s obj.RStatus = status
	.s obj.RUniqeIdentity = identity
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("Rule",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则明细表 --业务数据迁移(表名global改造后) 放在User.DHCCKBCommonDiction,User.DHCCKBRule,User.DHCCKBRuleNode 之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleDataMove()
ClassMethod RuleDataMove() As %String
{
	// ^DHCCKBRD({RD_RowID})
	// &SQL(INSERT INTO CT_CKB_PDSS.RuleData VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","RuleData")="规则明细表 User.DHCCKBRuleData 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleData")="规则明细表 User.DHCCKBRuleData 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleNode")) s ^CKB.PDSS.DataMove("MoveErr","RuleData")="规则明细表 User.DHCCKBRuleData 迁移失败。原因：规则节点表 User.DHCCKBRuleNode 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleNode")) ""		
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBRD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s rule = $p(^DHCCKBRD(rowId),"^",1) // User.DHCCKBRule
	.s node = $p(^DHCCKBRD(rowId),"^",2) // User.DHCCKBRuleNode
	.s leftDic = $p(^DHCCKBRD(rowId),"^",3) // User.DHCCKBCommonDiction
	.s leftValue =	$p(^DHCCKBRD(rowId),"^",4)
	.s leftType =	$p(^DHCCKBRD(rowId),"^",5)
	.s op =	$p(^DHCCKBRD(rowId),"^",6)
	.s rightDic = $p(^DHCCKBRD(rowId),"^",7) // User.DHCCKBCommonDiction
	.s rightValue = $p(^DHCCKBRD(rowId),"^",8) 
	.s rightType = $p(^DHCCKBRD(rowId),"^",9) 
	.s rightExt = $p(^DHCCKBRD(rowId),"^",12) 
	.s rightLimit = $p(^DHCCKBRD(rowId),"^",13) 
	.s manlevel = $p(^DHCCKBRD(rowId),"^",14)  // User.DHCCKBCommonDiction	
	.
	.s obj=##class(CT.CKB.PDSS.RuleData).%New()
	.d obj.RDRuleSetObjectId($case(rule'="",1:$o(^CKB.PDSS.DataMove("Rule",rule,"")),:"")) 
	.d obj.RDNodeSetObjectId($case(node'="",1:$o(^CKB.PDSS.DataMove("RuleNode",node,"")),:""))
	.d obj.RDLeftDicSetObjectId($case(leftDic'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",leftDic,"")),:""))
	.s obj.RDLeftValue = leftValue
	.s obj.RDLeftType = leftType
	.s obj.RDOp = op
	.d obj.RDRightDicSetObjectId($case(rightDic'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",rightDic,"")),:""))
	.s obj.RDRightValue = rightValue
	.s obj.RDRightType = rightType
	.s obj.RDRightExt = $case(rightExt'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",rightExt,"")),:"") 
	.s obj.RDRightLimit = rightLimit
	.d obj.RDManLevelSetObjectId($case(manlevel'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",manlevel,"")),:"")) 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("RuleData",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则索引表 --业务数据迁移(表名global改造后) 放在User.DHCCKBRule,User.DHCCKBCommonDiction之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleDicMove()
ClassMethod RuleDicMove() As %String
{
	// ^DHCCKBRULEDIC({RD_RowId})
	// &SQL(INSERT INTO CT_CKB_PDSS.RuleDic VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","RuleDic")="规则索引表 User.DHCCKBRuleDic 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleDic")="规则索引表 User.DHCCKBRuleDic 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBRULEDIC(rowId))  q:rowId=""  d
	.q:rowId=0
	.s rule = $p(^DHCCKBRULEDIC(rowId),"^",1) // User.DHCCKBRule
	.s dic = $p(^DHCCKBRULEDIC(rowId),"^",2)  // User.DHCCKBCommonDiction
	.s dicParref = $p(^DHCCKBRULEDIC(rowId),"^",3) // User.DHCCKBCommonDiction
	.
	.s obj=##class(CT.CKB.PDSS.RuleDic).%New()
	.d obj.RDRuleSetObjectId($case(rule'="",1:$o(^CKB.PDSS.DataMove("Rule",rule,"")),:""))
	.d obj.RDDicSetObjectId($case(dic'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",dic,"")),:""))
	.d obj.RDDicParentSetObjectId($case(dicParref'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",dicParref,"")),:""))
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("RuleDic",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则节点表 --业务数据迁移(表名global改造后) 放在User.DHCCKBRule之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleNodeMove()
ClassMethod RuleNodeMove() As %String
{
	// 	^DHCCKBRULENODE({RN_RowId})
	// &SQL(INSERT INTO CT_CKB_PDSS.RuleNode VALUES (?))
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleNode")="规则节点表 User.DHCCKBRuleNode 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBRULENODE(rowId))  q:rowId=""  d
	.q:rowId=0
	.s parent = $p(^DHCCKBRULENODE(rowId),"^",1) // User.DHCCKBRuleNode
	.s conditon = $p(^DHCCKBRULENODE(rowId),"^",2)
	.s action = $p(^DHCCKBRULENODE(rowId),"^",3)
	.s rule = $p(^DHCCKBRULENODE(rowId),"^",4) // User.DHCCKBRule
	.
	.s obj=##class(CT.CKB.PDSS.RuleNode).%New()
	.d obj.RNParentSetObjectId(parent) 
	.s obj.RNCondition = conditon
	.s obj.RNAction = action
	.d obj.RNRuleSetObjectId($case(rule'="",1:$o(^CKB.PDSS.DataMove("Rule",rule,"")),:""))
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.s ^CKB.PDSS.DataMove("RuleNode",rowId,newId)=""	
	.
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则节点表更新parent --业务数据迁移(表名global改造后)  放在User.DHCCKBRule之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleNodeUpdate()
ClassMethod RuleNodeUpdate() As %String
{
	// ^CT.CKB.PDSS.RuleNodeD(ID)=$LB(%%CLASSNAME,RNParent,RNCondition,RNAction,RNRule)
	// &SQL(INSERT INTO CT_CKB_PDSS.RuleNode VALUES (?))
	s rowId = ""
	f  s rowId = $o(^CT.CKB.PDSS.RuleNodeD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s data = $g(^CT.CKB.PDSS.RuleNodeD(rowId))
	.s parent = $lg(data,2) 
	.q:(parent="")
	.s obj=##class(CT.CKB.PDSS.RuleNode).%OpenId(rowId)
	.d obj.RNParentSetObjectId($case(parent'="",1:$o(^CKB.PDSS.DataMove("RuleNode",parent,"")),:"")) 
	.s sc=obj.%Save()
	.d obj.%Close()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	疾病病症关系表 --业务数据迁移(表名global改造后) 放在User.DHCCKBComContrast,User.DHCCKBCommonDiction之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DiagRelationMove()
ClassMethod DiagRelationMove() As %String
{
	// ^User.DHCCKBDiagnosisRelationD(ID)=$LB(%%CLASSNAME,DRContrastDr,DRRelationDr,DRType)
	// &SQL(INSERT INTO CF_CKB_PDSS.DiagRelation VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DiagRelation")="疾病病症关系表 User.DHCCKBDiagnosisRelation 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("ComContrast")) s ^CKB.PDSS.DataMove("MoveErr","DiagRelation")="疾病病症关系表 User.DHCCKBDiagnosisRelation 迁移失败。原因: 数据映射表 User.DHCCKBComContrast 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("ComContrast")) ""
	
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBDiagnosisRelationD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s contrastDr = $lg(^User.DHCCKBDiagnosisRelationD(rowId),2) // User.DHCCKBComContrast
	.s relatoinDr = $lg(^User.DHCCKBDiagnosisRelationD(rowId),3) // User.DHCCKBCommonDiction
	.s type = $lg(^User.DHCCKBDiagnosisRelationD(rowId),4)	
	.
	.s obj=##class(CF.CKB.PDSS.DiagRelation).%New()
	.s obj.DRContrastDr = $case(contrastDr'="",1:$o(^CKB.PDSS.DataMove("ComContrast",contrastDr,"")),:"") 
	.s obj.DRRelationDr = $case(relatoinDr'="",1:$o(^CKB.PDSS.DataMove("CommonDiction",relatoinDr,"")),:"") 
	.s obj.DRType = type	
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.s ^CKB.PDSS.DataMove("DiagRelation",rowId,newId)=""	
	.
		
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	审核忽略配置数据池表 --业务数据迁移(表名global改造后) 放在CommonDiction,User.DHCCKBIgnoreManage之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).IgnoreDataPoolMove()
ClassMethod IgnoreDataPoolMove() As %String
{
	// ^User.DHCCKBIgnoreDataPoolD(ID)=$LB(%%CLASSNAME,IDPValue,IDPItem,IDPFlag,IDPCategory,IDPIMType,IDPIMVaule,IDPIMDr)
	// &SQL(INSERT INTO CF_CKB_PDSS.IgnoreDataPool VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","IgnoreDataPool")="审核忽略配置数据池表 User.DHCCKBIgnoreDataPool 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("IgnoreManage")) s ^CKB.PDSS.DataMove("MoveErr","IgnoreDataPool")="审核忽略配置数据池表 User.DHCCKBIgnoreDataPool 迁移失败。原因: 审核忽略配置表 User.DHCCKBIgnoreManage 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("IgnoreManage")) ""
		
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBIgnoreDataPoolD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s IDPValue = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),2) /// 药品id或者ALL
	.s IDPItem = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),3)  /// 管理 目录/项目
	.s IDPFlag = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),4)
	.s IDPCategory = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),5)
	.s IDPIMType = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),6) 
	.s IDPIMVaule = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),7) // CommonDiction
	.s IDPIMDr = $lg(^User.DHCCKBIgnoreDataPoolD(rowId),8) // User.DHCCKBIgnoreManage
	.
	.s obj=##class(CF.CKB.PDSS.IgnoreDataPool).%New()	
	.s obj.IDPValue = $case(+IDPValue'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",IDPValue,"")),:"") 
	.s obj.IDPItem = $case(+IDPItem'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",IDPItem,"")),:"")
	.s obj.IDPFlag = IDPFlag
	.s obj.IDPCategory = IDPCategory
	.s obj.IDPIMType = IDPIMType
	.s obj.IDPIMVaule =  $case(+IDPIMVaule'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",IDPIMVaule,"")),:"")
	.d obj.IDPIMDrSetObjectId($case(+IDPIMDr'=0,1:$o(^CKB.PDSS.DataMove("IgnoreManage",IDPIMDr,"")),:""))
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.s ^CKB.PDSS.DataMove("IgnoreDataPool",rowId,newId)=""	
	.
		
	q ""
}

/// Creator:		qunianpeng 
/// CreatDate:		2023-02-17
/// Description: 	审核忽略配置表 --业务数据迁移(表名global改造后) 放在CommonDiction之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).IgnoreManageMove()
ClassMethod IgnoreManageMove() As %String
{
	// ^DHCCKBIGMAN({IM_RowID})
	// &SQL(INSERT INTO CF_CKB_PDSS.IgnoreManage VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","IgnoreManage")="审核忽略配置表 User.DHCCKBIgnoreManage 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBIGMAN(rowId))  q:rowId=""  d
	.q:rowId=0	
	.s IMType = $p(^DHCCKBIGMAN(rowId),"^",1) 
	.s IMValue = $p(^DHCCKBIGMAN(rowId),"^",2) 	// User.DHCCKBCommonDiction
	.s IMItem = $p(^DHCCKBIGMAN(rowId),"^",3)	// User.DHCCKBCommonDiction
	.s IMFlag = $p(^DHCCKBIGMAN(rowId),"^",4)	
	.
	.s obj=##class(CF.CKB.PDSS.IgnoreManage).%New()	
	.s obj.IMType = IMType
	.d obj.IMValueSetObjectId($case(+IMValue'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",IMValue,"")),:"")) 
	.d obj.IMItemSetObjectId($case(+IMItem'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",IMItem,"")),:"")) 
	.s obj.IMFlag = IMFlag	
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.s ^CKB.PDSS.DataMove("IgnoreManage",rowId,newId)=""	
	.
		
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	前提条件数据池表 --业务数据迁移(表名global改造后) 放在CommonDiction,User.DHCCKBRule,User.DHCCKBRuleData,User.DHCCKBRuleNode之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).PreDataPoolMove()
ClassMethod PreDataPoolMove() As %String
{
	// ^User.DHCCKBPreconditionDataPoolD(ID)=$LB(%%CLASSNAME,PDPDrugDr,PDPDirectDr,PDPRuleDr,PDPRuleDataDr,PDPRuleNoteDr)
	// &SQL(INSERT INTO CF_CKB_PDSS.PreDataPool VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","PreDataPool")="前提条件数据池表 User.DHCCKBPreconditionDataPool 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","PreDataPool")="前提条件数据池表 User.DHCCKBPreconditionDataPool 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleNode")) s ^CKB.PDSS.DataMove("MoveErr","PreDataPool")="前提条件数据池表 User.DHCCKBPreconditionDataPool 迁移失败。原因：规则节点表 User.DHCCKBRuleNode 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleData")) s ^CKB.PDSS.DataMove("MoveErr","PreDataPool")="前提条件数据池表 User.DHCCKBPreconditionDataPool 迁移失败。原因：规则明细表 User.DHCCKBRuleData 未迁移"
	
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleNode")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleData")) ""
	
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBPreconditionDataPoolD(rowId))  q:rowId=""  d
	.q:rowId=0	
	.s PDPDrugDr = $lg(^User.DHCCKBPreconditionDataPoolD(rowId),2)	// 	User.DHCCKBCommonDiction
	.s PDPDirectDr = $lg(^User.DHCCKBPreconditionDataPoolD(rowId),3) // User.DHCCKBCommonDiction
	.s PDPRuleDr = $lg(^User.DHCCKBPreconditionDataPoolD(rowId),4)	// 	User.DHCCKBRule
	.s PDPRuleDataDr = $lg(^User.DHCCKBPreconditionDataPoolD(rowId),5) // User.DHCCKBRuleData
	.s PDPRuleNoteDr = $lg(^User.DHCCKBPreconditionDataPoolD(rowId),6) // User.DHCCKBRuleNode
	.
	.s obj=##class(CF.CKB.PDSS.PreDataPool).%New()
	.d obj.PDPDrugDrSetObjectId($case(+PDPDrugDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",PDPDrugDr,"")),:"")) 
	.d obj.PDPDirectDrSetObjectId($case(+PDPDirectDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",PDPDirectDr,"")),:"")) 
	.d obj.PDPRuleDrSetObjectId($case(+PDPRuleDr'=0,1:$o(^CKB.PDSS.DataMove("Rule",PDPRuleDr,"")),:"")) 
	.d obj.PDPRuleDataDrSetObjectId($case(+PDPRuleDataDr'=0,1:$o(^CKB.PDSS.DataMove("RuleData",PDPRuleDataDr,"")),:"")) 
	.d obj.PDPRuleNoteDrSetObjectId($case(+PDPRuleNoteDr'=0,1:$o(^CKB.PDSS.DataMove("RuleNode",PDPRuleNoteDr,"")),:"")) 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.s ^CKB.PDSS.DataMove("PreDataPool",rowId,newId)=""	
	.
		
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则目录关联表 --业务数据迁移(表名global改造后) 放在CommonDiction,User.DHCCKBRule之后迁移
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DrugLibaryRefMove()
ClassMethod DrugLibaryRefMove() As %String
{
	// ^User.DHCCKBDrugLibaryRefD(ID)=$LB(%%CLASSNAME,DLRDrugDr,DLRLibaryDr,DLRRuleDr,DLRDicParrefDr,DLROrderNum)
	// &SQL(INSERT INTO CT_CKB_PDSS.DrugLibaryRef VALUES (?))
	
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DrugLibaryRef")="规则目录关联表 User.DHCCKBDrugLibaryRef 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","DrugLibaryRef")="规则目录关联表 User.DHCCKBDrugLibaryRef 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBDrugLibaryRefD(rowId))  q:rowId=""  d
	.q:rowId=0	
	.s data = $g(^User.DHCCKBDrugLibaryRefD(rowId))
	.s DLRDrugDr = $lg(data,2) // User.DHCCKBCommonDiction
	.s DLRRuleDr = $lg(data,4) // User.DHCCKBRule	
	.s DLRDicParrefDr = $lg(data,5) // User.DHCCKBCommonDiction	
	.s DLRLibaryDr = $lg(data,3) //	User.DHCCKBCommonDiction
	.s DLROrderNum = $lg(data,6) 
	.	
	.s obj=##class(CT.CKB.PDSS.DrugLibaryRef).%New()
	.d obj.DLRDrugDrSetObjectId($case(+DLRDrugDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",DLRDrugDr,"")),:"")) 
	.d obj.DLRRuleDrSetObjectId($case(+DLRRuleDr'=0,1:$o(^CKB.PDSS.DataMove("Rule",DLRRuleDr,"")),:""))
	.d obj.DLRDicParrefDrSetObjectId($case(+DLRDicParrefDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",DLRDicParrefDr,"")),:"")) 
	.d obj.DLRLibaryDrSetObjectId($case(+DLRLibaryDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",DLRLibaryDr,"")),:"")) 
	.s obj.DLROrderNum = DLROrderNum 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()	
	.//q:newId=""
	.s ^CKB.PDSS.DataMove("DrugLibaryRef",rowId,newId)=""	
	.
		
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	数据映射表 依赖基础字典码表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).ComContrastMove()
ClassMethod ComContrastMove() As %String
{
	//^DHCCKBCC({CC_RowID})
	//SQL(INSERT INTO CKB_PDSS.ComContrast VALUES (:libCode,:libDesc,:extCode,:extDesc,:typeId,:hospId))

	s rowId = ""
	f  s rowId = $o(^DHCCKBCC(rowId))  q:rowId=""  d
	.q:rowId=0
	.s libCode = $p(^DHCCKBCC(rowId),"^",1)
	.s libDesc = $p(^DHCCKBCC(rowId),"^",2)
	.s hisCode = $p(^DHCCKBCC(rowId),"^",3)
	.s hisDesc = $p(^DHCCKBCC(rowId),"^",4)
	.s type = $p(^DHCCKBCC(rowId),"^",5)
	.s hosp = $p(^DHCCKBCC(rowId),"^",6)
	.
	.s obj=##class(CKB.PDSS.ComContrast).%New()
	.s obj.CCLibCode=libCode                                    
	.s obj.CCLibDesc=libDesc                                   
	.s obj.CCHisCode=hisCode
	.s obj.CCHisDesc=hisDesc                      
	.s obj.CCDicType= $case(+type'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",type,"")),:"") 
	.s obj.CCHospital=hosp
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("ComContrast",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	字典日志表 --业务数据迁移(表名global改造后) 放在基础数据码表，属性关联表，规则序号表，规则明细表，数据对照表，外部项目字典属性关联表 之后
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicLogMove()
ClassMethod DicLogMove() As %String
{
	// ^DHCCKBDLG({DLG_RowID})
	// SQL(INSERT INTO CKB_PDSS.DicLog VALUES (?))

	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("DicLinkAttr")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因: 属性关联表 User.DHCCKBDicLinkAttr 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleData")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因：规则明细表 User.DHCCKBRuleData 未迁移"
	i '$d(^CKB.PDSS.DataMove("ComContrast")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因：数据对照表 User.DHCCKBComContrast 未迁移"
	i '$d(^CKB.PDSS.DataMove("DicExtLinkAttr")) s ^CKB.PDSS.DataMove("MoveErr","DicLog")="字典日志表 User.DHCCKBDicLog 迁移失败。原因：外部项目字典属性关联表 User.DHCCKBDicExtLinkAttr 未迁移"

	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("DicLinkAttr")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleData")) ""
	q:'$d(^CKB.PDSS.DataMove("ComContrast")) ""
	q:'$d(^CKB.PDSS.DataMove("DicExtLinkAttr")) ""
	
	s TmpDataArr("DHC_CKBCommonDiction")=""
	s TmpDataArr("DHC_CKBDicLinkAttr")=""
	s TmpDataArr("DHC_CKBRule")=""
	s TmpDataArr("DHC_CKBRuleData")=""
	s TmpDataArr("DHC_CKBComContrast")=""
	s TmpDataArr("DHC_CKBDicExtLinkAttr")=""

	s rowId = ""
	f  s rowId = $o(^DHCCKBDLG(rowId))  q:rowId=""  d
	.q:rowId=0
	.s dic = $p(^DHCCKBDLG(rowId),"^",1)
	.q:dic=""
	.q:'$d(TmpDataArr(dic))
	.s dataDr = $p(^DHCCKBDLG(rowId),"^",2)
	.s fun = $p(^DHCCKBDLG(rowId),"^",3)
	.s operator = $p(^DHCCKBDLG(rowId),"^",4)
	.s date = $p(^DHCCKBDLG(rowId),"^",5)
	.s time = $p(^DHCCKBDLG(rowId),"^",6)
	.s scope = $p(^DHCCKBDLG(rowId),"^",7)
	.s scopeValue = $p(^DHCCKBDLG(rowId),"^",8)
	.s clientIP = $p(^DHCCKBDLG(rowId),"^",9)
	.
	.s obj=##class(CKB.PDSS.DicLog).%New()
	.s obj.DLGDicDr = dic                                    
	.s obj.DLGDataDr = ..GetDicLogType(dataDr)                                   
	.s obj.DLGFunction = fun
	.s obj.DLGOperator = operator                      
	.s obj.DLGDate = date
	.s obj.DLGTime = time
	.s obj.DLGScope = scope
	.s obj.DLGScopeValue = scopeValue
	.s obj.DLGClientIPAddress = clientIP
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("DicLog",rowId,newId)=""
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-2-18
/// Description: 	获取字典日志表类型 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).GetDicLogType()
ClassMethod GetDicLogType(type, datadr) As %String
{
	
	q $select(type="DHC_CKBCommonDiction":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",datadr,"")),:""),
			type="DHC_CKBDicLinkAttr":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("DicLinkAttr",datadr,"")),:""),
			type="DHC_CKBRule":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("Rule",datadr,"")),:""),
			type="DHC_CKBRuleData":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("RuleData",datadr,"")),:""),
			type="DHC_CKBComContrast":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("ComContrast",datadr,"")),:""),
			type="DHC_CKBDicExtLinkAttr":$case(+datadr'=0,1:$o(^CKB.PDSS.DataMove("DicExtLinkAttr",datadr,"")),:""),
			1:"")
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	知识日志详情表（依赖字典日志表,基础数据码表,需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicDataLogMove()
ClassMethod DicDataLogMove() As %String
{
	// 	^User.DHCCKBDicDataLogD(ID)
	// SQL(INSERT INTO CKB_PDSS.DicDataLog VALUES (?))
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DicDataLog")="知识日志详情表User.DHCCKBDicDataLog 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("DicLog")) s ^CKB.PDSS.DataMove("MoveErr","DicDataLog")="知识日志详情表User.DHCCKBDicDataLog 迁移失败。原因：字典日志表User.DHCCKBDicLog未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("DicLog")) ""
	
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBDicDataLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s dataList = $g(^User.DHCCKBDicDataLogD(rowId))
	.s dicLog = $lg(dataList,2)
	.s entyID = $lg(dataList,3)
	.s attrID = $lg(dataList,4)
	.s dicValue = $lg(dataList,5)
	.s lastDataLog = $lg(dataList,6)

	.s obj=##class(CKB.PDSS.DicDataLog).%New()
	.s obj.DDLLog = $case(+dicLog'=0,1:$o(^CKB.PDSS.DataMove("DicLog",dicLog,"")),:"") 
	.s obj.DDLEntyID = $case(+entyID'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",entyID,"")),:"") 
	.s obj.DDLAttrID = $case(+attrID'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",attrID,"")),:"")  
	.s obj.DDLDicValue = dicValue
	.s obj.DDLLastDataLog = lastDataLog
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("DicDataLog",rowId,newId)=""
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	知识日志详情表更新parent --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicDataLogUpdate()
ClassMethod DicDataLogUpdate() As %String
{
	// ^CKB.PDSS.DicDataLogD(ID)=$LB(%%CLASSNAME,DDLLog,DDLEntyID,DDLAttrID,DDLDicValue,DDLLastDataLog)
	s rowId = ""
	f  s rowId = $o(^CKB.PDSS.DicDataLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s data = $g(^CKB.PDSS.DicDataLogD(rowId))
	.s DDLLastDataLog = $lg(data,6) 
	.q:(+DDLLastDataLog=0)
	.s obj=##class(CKB.PDSS.DicDataLog).%OpenId(rowId)
	.s obj.DDLLastDataLog = $case(+DDLLastDataLog'=0,1:$o(^CKB.PDSS.DataMove("DicDataLog",DDLLastDataLog,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	基础数据码表扩展表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).ComDictionExtMove()
ClassMethod ComDictionExtMove() As %String
{
	// ^User.DHCCKBComDictionExtD(ID)
	// SQL(INSERT INTO CKB_PDSS.ComDictionExt VALUES (?))
	
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBComDictionExtD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s dataList = $g(^User.DHCCKBComDictionExtD(rowId))
	.s identity = $lg(dataList,2)
	.s extCDDr = $lg(dataList,3)
	.s obj=##class(CKB.PDSS.ComDictionExt).%New()
	.s obj.CDExtIdentity = identity
	.s obj.CDExtCDDr = $case(+extCDDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",extCDDr,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.//s ^CKB.PDSS.DataMove("ComDictionExt",rowId,newId)=""
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	外部项目字典表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicExtLinkAttrMove()
ClassMethod ExtDictionMove() As %String
{
	// 	^DHCCKBEXD(ID)
	// SQL(INSERT INTO CKB_PDSS.ExtDiction VALUES (?))

	s rowId = ""
	f  s rowId = $o(^DHCCKBEXD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s code = $p(^DHCCKBEXD(rowId),"^",1)
	.s desc = $p(^DHCCKBEXD(rowId),"^",2)
	.s type = $p(^DHCCKBEXD(rowId),"^",3)
	.s hosp = $p(^DHCCKBEXD(rowId),"^",4)
	.s parrefDr = $p(^DHCCKBEXD(rowId),"^",5)
	.
	.s obj=##class(CKB.PDSS.ExtDiction).%New()	
	.s obj.EDCode = code
	.s obj.EDDesc = desc
	.s obj.EDType = type
	.s obj.EDHospital = hosp
	.s obj.EDParrefDr = parrefDr
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("ExtDiction",rowId,newId)=""
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	外部项目字典表 更新parent --业务数据迁移(表名global改造后) 
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).ExtDictionUpdate()
ClassMethod ExtDictionUpdate() As %String
{
	// ^CKB.PDSS.ExtDictionD(ID)=$LB(%%CLASSNAME,EDCode,EDDesc,EDType,EDHospital,EDParrefDr,EDExtDesc)
	s rowId = ""
	f  s rowId = $o(^CKB.PDSS.ExtDictionD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s data = $g(^CKB.PDSS.ExtDictionD(rowId))
	.s EDParrefDr = $lg(data,6) 
	.q:(EDParrefDr="")
	.s obj=##class(CKB.PDSS.ExtDiction).%OpenId(rowId)
	.s obj.EDParrefDr = $case(+EDParrefDr'=0,1:$o(^CKB.PDSS.DataMove("ExtDiction",EDParrefDr,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	外部项目字典属性关联表（依赖外部项目字典表,基础数据码表 需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DicExtLinkAttrMove()
ClassMethod DicExtLinkAttrMove() As %String
{
	// ^DHCCKBDLAEXT(ID)
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","DicExtLinkAttr")="外部项目字典属性关联表 User.DHCCKBDicExtLinkAttr 迁移失败原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("ExtDiction")) s ^CKB.PDSS.DataMove("MoveErr","DicExtLinkAttr")="外部项目字典属性关联表 User.DHCCKBDicExtLinkAttr 迁移失败。原因：外部项目字典表User.DHCCKBExtDiction未迁移"
	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("ExtDiction")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBDLAEXT(rowId))  q:rowId=""  d
	.q:rowId=0
	.s dicExtDr = $lg($g(^CKB.PDSS.DicExtLinkAttrD(rowId)),2)
	.s attrCode = $lg($g(^CKB.PDSS.DicExtLinkAttrD(rowId)),3)
	.s attrDr = $lg($g(^CKB.PDSS.DicExtLinkAttrD(rowId)),4)
	.s result = $lg($g(^CKB.PDSS.DicExtLinkAttrD(rowId)),5)
	.s groupFlag = $lg($g(^CKB.PDSS.DicExtLinkAttrD(rowId)),6)
	.
	.s obj=##class(CKB.PDSS.DicExtLinkAttr).%New()	
	.s obj.DLADicExtDr = $case(+dicExtDr'=0,1:$o(^CKB.PDSS.DataMove("ExtDiction",dicExtDr,"")),:"") 
	.d obj.DLAAttrCodeSetObjectId($case(+attrCode'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",attrCode,"")),:"")) 
	.d obj.DLAAttrDrSetObjectId($case(+attrDr'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",attrDr,"")),:"")) 
	.s obj.DLAResult = result
	.s obj.DLAGroupFlag = groupFlag
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("DicExtLinkAttr",rowId,newId)=""
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	药品检索日志表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).DrugSearchLogMove()
ClassMethod DrugSearchLogMove() As %String
{
	//^User.DHCCKBDrugSearchLogD(ID) 
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBDrugSearchLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s listData = $g(^User.DHCCKBDrugSearchLogD(rowId)) 
	.s dicID = $lg(listData,2)
	.s date = $lg(listData,3)
	.s time = $lg(listData,4)
	.s operator = $lg(listDta,5)
	.s loc = $lg(listData,6)
	.s hospId =  $lg(listData,7)
	.
	.s obj=##class(CKB.PDSS.DrugSearchLog).%New()	
	.s obj.DSLDicID = dicID
	.s obj.DSLDate = date
	.s obj.DSLTime = time
	.s obj.DSLOperator = operator
	.s obj.DSLLoc = loc
	.s obj.DSLHospID = hospId
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.//s ^CKB.PDSS.DataMove("DrugSearchLog",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-20
/// Description: 	强制审核反馈表（依赖审核日志主表,需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).FeedBackMove()
ClassMethod FeedBackMove() As %String
{
	//^DHCCKBFB

	i '$d(^CKB.PDSS.DataMove("MonMaster")) s ^CKB.PDSS.DataMove("MoveErr","FeedBack")="强制审核反馈表User.DHCCKBFeedBack迁移失败。原因：审核日志主表User.DHCCKBMonMaster未迁移"
	q:'$d(^CKB.PDSS.DataMove("MonMaster")) ""

	s rowId = ""
	f  s rowId = $o(^DHCCKBFB(rowId))  q:rowId=""  d
	.q:rowId=0
	.s msgID = $p(^DHCCKBFB(rowId),"^",1)
	.s userID = $p(^DHCCKBFB(rowId),"^",2)
	.s date = $p(^DHCCKBFB(rowId),"^",3)
	.s time = $p(^DHCCKBFB(rowId),"^",4)
	.s orditem = $p(^DHCCKBFB(rowId),"^",5)
	.s status = $p(^DHCCKBFB(rowId),"^",6)
	.s userType = $p(^DHCCKBFB(rowId),"^",7)
	.s notes = $p(^DHCCKBFB(rowId),"^",8)
	.s reason = $p(^DHCCKBFB(rowId),"^",9)
	.s level = $p(^DHCCKBFB(rowId),"^",10)
	.s unique = $p(^DHCCKBFB(rowId),"^",11)
	.s arciId = $p(^DHCCKBFB(rowId),"^",12)
	.s arciName = $p(^DHCCKBFB(rowId),"^",13)
	.s seqNo = $p(^DHCCKBFB(rowId),"^",14)
	.s passFlag = $p(^DHCCKBFB(rowId),"^",15)
	.s params = $p(^DHCCKBFB(rowId),"^",16)
	.s lastId = $p(^DHCCKBFB(rowId),"^",17)
	.s reasonCombo = $p(^DHCCKBFB(rowId),"^",18)
	.s obj=##class(CKB.PDSS.FeedBack).%New()	
	.s obj.FBMsgID = $case(msgID="",1:"",:$o(^CKB.PDSS.DataMove("MonMaster",msgID,""))) 
	.s obj.FBUser =  ##class(User.SSUser).%OpenId(userID) 
	.s obj.FBDate = date	
	.s obj.FBTime = time
	.s obj.FBOrdItemDr =##class(User.OEOrdItem).%OpenId(orditem) 
	.s obj.FBStatus = status
	.s obj.FBUserType = userType
	.s obj.FBNotes = notes
	.s obj.FBReason = reason
	.s obj.FBLevel = level
	.s obj.FBUnique = unique
	.s obj.FBArciId = arciId
	.s obj.FBArciName = arciName
	.s obj.FBSeqNo = seqNo
	.s obj.FBPassFlag = passFlag
	.s obj.FBParams = params
	.s obj.FBLastId = lastId
	.s obj.FBReasonCombo = ##class(User.DHCCKBReasTemp).%OpenId(reasonCombo)  	
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.//s ^CKB.PDSS.DataMove("FeedBack",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	数据更新日志表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).KnowUpdateLogMove()
ClassMethod KnowUpdateLogMove() As %String
{
	// ^User.DHCCKBKnowUpdateLogD
	s rowId = ""
	f  s rowId = $o(^User.DHCCKBKnowUpdateLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s listData = $g(^User.DHCCKBKnowUpdateLogD(rowId))
	.s fromDate = $lg(listData,2)
	.s toDate = $lg(listData,3)
	.s userName = $lg(listData,4)
	.s upDate = $lg(listData,5)
	.s upTime = $lg(listData,6)
	.s path = $lg(listData,7)
	.s type = $lg(listData,8)
	.s status = $lg(listData,9)
	.s version = $lg(listData,10)
	.s hosp = $lg(listData,11)
	.s obj=##class(CKB.PDSS.KnowUpdateLog).%New()	
	.s obj.KULFromDate = fromDate 
	.s obj.KULToDate = toDate 
	.s obj.KULUserName = userName 
	.s obj.KULUpDate = upDate 
	.s obj.KULUpTime = upTime 
	.s obj.KULPath = path 
	.s obj.KULType = type
	.s obj.KULStatus = status
	.s obj.KULHosp = hosp 
	.s obj.KULVersion = version 
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.//s ^CKB.PDSS.DataMove("KnowUpdateLog",rowId,newId)=""
			
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	审核日志主表 --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).MonMasterMove()
ClassMethod MonMasterMove() As %String
{
	// ^DHCCKBMM
	s rowId = ""
	f  s rowId = $o(^DHCCKBMM(rowId))  q:rowId=""  d
	.q:rowId=0
	.s admdr = $p(^DHCCKBMM(rowId),"^",1)
	.s createDate = $p(^DHCCKBMM(rowId),"^",2)
	.s createTime = $p(^DHCCKBMM(rowId),"^",3)
	.s createUser = $p(^DHCCKBMM(rowId),"^",4)
	.s locDesc = $p(^DHCCKBMM(rowId),"^",5)
	.s passFlag = $p(^DHCCKBMM(rowId),"^",6)
	.s manLevDr = $p(^DHCCKBMM(rowId),"^",7)
	.s param = $p(^DHCCKBMM(rowId),"^",8)
	.s res = $p(^DHCCKBMM(rowId),"^",9)
	.s ip = $p(^DHCCKBMM(rowId),"^",10)
	.s hosp = $p(^DHCCKBMM(rowId),"^",11)
	.s source = $p(^DHCCKBMM(rowId),"^",12)
	.s userType = $p(^DHCCKBMM(rowId),"^",13)
	.s passType = $p(^DHCCKBMM(rowId),"^",14)
	.s prescFlag = $p(^DHCCKBMM(rowId),"^",15)
	.s auditReason = $p(^DHCCKBMM(rowId),"^",16)
	.s lastId = $p(^DHCCKBMM(rowId),"^",17)
	.s auditNotes = $p(^DHCCKBMM(rowId),"^",18)
	.
	.s obj=##class(CKB.PDSS.MonMaster).%New()	
	.s obj.CMAdmDr = admdr
	.s obj.CMCreateDate = createDate
	.s obj.CMCreateTime = createTime
	.s obj.CMCreateUser = createUser
	.s obj.CMLocDesc = locDesc
	.s obj.CMPassFlag = passFlag
	.s obj.CMManLevDr = manLevDr
	.s obj.CMExaParam = param
	.s obj.CMExaRes = res
	.s obj.CMIp = ip
	.s obj.CMHosp = hosp
	.s obj.CMSource = source
	.s obj.CMUserType = userType
	.s obj.CMPassType = passType
	.s obj.CMPrescFlag = prescFlag
	.s obj.CMAduitReason = auditReason
	.s obj.CMLastId = lastId
	.s obj.CMAduitNotes = auditNotes
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("MonMaster",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	审核问题明细日志表（依赖审核日志主表,需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).MonQueListMove()
ClassMethod MonQueListMove() As %String
{
	// ^DHCCKBMQL
	i '$d(^CKB.PDSS.DataMove("MonMaster")) s ^CKB.PDSS.DataMove("MoveErr","MonQueList")="审核问题明细日志表User.DHCCKBMonQueList迁移失败。原因：审核日志主表User.DHCCKBMonMaster未迁移"
	q:'$d(^CKB.PDSS.DataMove("MonMaster")) ""

	s rowId = ""
	f  s rowId = $o(^DHCCKBMQL(rowId))  q:rowId=""  d
	.q:rowId=0
	.s parref = $p(^DHCCKBMQL(rowId),"^",1)
	.s parrefNew = $case(parref="",1:"",:$o(^CKB.PDSS.DataMove("MonMaster",parref,""))) 
	.s itemDr = $p(^DHCCKBMQL(rowId),"^",2)
	.s proDr = $p(^DHCCKBMQL(rowId),"^",3)
	.s funDr = $p(^DHCCKBMQL(rowId),"^",4)
	.s tipsMsg = $p(^DHCCKBMQL(rowId),"^",5)
	.s manLevDr = $p(^DHCCKBMQL(rowId),"^",6)
	.s orderDr = $p(^DHCCKBMQL(rowId),"^",7)
	.s remarks = $p(^DHCCKBMQL(rowId),"^",8)
	.s sings = $p(^DHCCKBMQL(rowId),"^",9)
	.
	.s obj=##class(CKB.PDSS.MonQueList).%New()	
	.s obj.CMParrfDr = ##class(CKB.PDSS.MonMaster).%OpenId(parrefNew)
	.s obj.CMItemDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(itemDr)
	.s obj.CMProDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(proDr)
	.s obj.CMFunDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(funDr)
	.s obj.CMTipsMsg = tipsMsg
	.s obj.CMManLevDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(manLevDr)
	.s obj.CMOrderDr = orderDr
	.s obj.CMRemarks = remarks
	.s obj.CMSings = sings
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("MonQueList",rowId,newId)=""

	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	审核问题规则明细日志表（依赖审核日志主表,需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).MonRuleListMove()
ClassMethod MonRuleListMove() As %String
{
	// ^DHCCKBMRL
	i '$d(^CKB.PDSS.DataMove("MonMaster")) s ^CKB.PDSS.DataMove("MoveErr","MonRuleList")="审核问题规则明细日志表User.DHCCKBMonRuleList迁移失败。原因：审核日志主表User.DHCCKBMonMaster未迁移"
	q:'$d(^CKB.PDSS.DataMove("MonMaster")) ""

	s rowId = ""
	f  s rowId = $o(^DHCCKBMRL(rowId))  q:rowId=""  d
	.q:rowId=0
	.s parref = $p(^DHCCKBMRL(rowId),"^",1)
	.s parrefNew = $case(parref="",1:"",:$o(^CKB.PDSS.DataMove("MonMaster",parref,"")))
	.s ruleDr = $p(^DHCCKBMRL(rowId),"^",2)
	.s manLevDr = $p(^DHCCKBMRL(rowId),"^",3)
	.s itemDr = $p(^DHCCKBMRL(rowId),"^",4)	
	.
	.s obj=##class(CKB.PDSS.MonRuleList).%New()	
	.s obj.CMParrfDr = ##class(CKB.PDSS.MonMaster).%OpenId(parrefNew)
	.s obj.CMRuleDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(ruleDr)
	.s obj.CMManLevDr = ##class(CT.CKB.PDSS.CommonDiction).%OpenId(manLevDr)
	.s obj.CMItemDr = itemDr
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("MonRuleList",rowId,newId)=""

	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	规则日志表 依赖规则序号表） --业务数据迁移(表名global改造后) 
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleLogMove()
ClassMethod RuleLogMove() As %String
{

	// ^DHCCKBDLG({DLG_RowID})
	// SQL(INSERT INTO CKB_PDSS.RuleLog VALUES (?))
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleLog")="规则日志表 User.DHCCKBRuleLog 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""

	s rowId = ""
	f  s rowId = $o(^DHCCKBRULELOG(rowId))  q:rowId=""  d
	.q:rowId=0
	.s rule = $p(^DHCCKBRULELOG(rowId),"^",1)
	.s user = $p(^DHCCKBRULELOG(rowId),"^",2)
	.s date = $p(^DHCCKBRULELOG(rowId),"^",3)
	.s time = $p(^DHCCKBRULELOG(rowId),"^",4)
	.s type = $p(^DHCCKBRULELOG(rowId),"^",5)
	.s name = $p(^DHCCKBRULELOG(rowId),"^",6)
	.s remark = $p(^DHCCKBRULELOG(rowId),"^",7)
	.s lastLog = $p(^DHCCKBRULELOG(rowId),"^",8)
	.s hosp = $p(^DHCCKBRULELOG(rowId),"^",9)
	.
	.s obj=##class(CKB.PDSS.RuleLog).%New()	
	.d obj.RLRuleSetObjectId($case(+rule'=0,1:$o(^CKB.PDSS.DataMove("Rule",rule,"")),:"")) //##class(CT.CKB.PDSS.Rule).%OpenId(rule)
	.d obj.RLUserSetObjectId(user) //##class(User.SSUser).%OpenId(user)
	.s obj.RLDate = date
	.s obj.RLTime = time
	.s obj.RLType = type
	.s obj.RLName = name
	.s obj.RLRemark = remark
	.s obj.RLLastLog = lastLog
	.s obj.RLHospital = hosp
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("RuleLog",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则日志表 更新RLLastLog --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleLogUpdate()
ClassMethod RuleLogUpdate() As %String
{
	// ^CKB.PDSS.RuleLogD(ID)=$LB(%%CLASSNAME,RLRule,RLUser,RLDate,RLTime,RLType,RLName,RLRemark,RLLastLog,RLHospital)
	
	s rowId = ""
	f  s rowId = $o(^CKB.PDSS.RuleLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s data = $g(^CKB.PDSS.RuleLogD(rowId))
	.s RLLastLog = $lg(data,9) 
	.q:(+RLLastLog=0)
	.s obj=##class(CKB.PDSS.RuleLog).%OpenId(rowId)
	.s obj.RLLastLog = $case(+RLLastLog'=0,1:$o(^CKB.PDSS.DataMove("RuleLog",RLLastLog,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	规则明细日志表（依赖基础数据码表，规则序号表，规则明细表，规则日志表,需要先完成依赖表的数据迁移） --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleDataLogMove()
ClassMethod RuleDataLogMove() As %String
{
	// ^DHCCKBRULEDATALOG({RDL_RowId})
	i '$d(^CKB.PDSS.DataMove("CommonDiction")) s ^CKB.PDSS.DataMove("MoveErr","RuleDataLog")="规则明细日志表 User.DHCCKBRuleDataLog 迁移失败。原因：基础数据码表 User.DHCCKBCommonDiction 未迁移"
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleDataLog")="规则明细日志表 User.DHCCKBRuleDataLog 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleData")) s ^CKB.PDSS.DataMove("MoveErr","RuleDataLog")="规则明细日志表 User.DHCCKBRuleDataLog 迁移失败。原因：规则明细表 User.DHCCKBRuleData 未迁移"
	i '$d(^CKB.PDSS.DataMove("RuleLog")) s ^CKB.PDSS.DataMove("MoveErr","RuleDataLog")="规则明细日志表 User.DHCCKBRuleDataLog 迁移失败。原因：规则日志表 User.DHCCKBRuleLog 未迁移"

	q:'$d(^CKB.PDSS.DataMove("CommonDiction")) ""
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleData")) ""
	q:'$d(^CKB.PDSS.DataMove("RuleLog")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBRULEDATALOG(rowId))  q:rowId=""  d
	.q:rowId=0
	.s rule = $p(^DHCCKBRULEDATALOG(rowId),"^",1)
	.s condition = $p(^DHCCKBRULEDATALOG(rowId),"^",2)
	.s leftDic = $p(^DHCCKBRULEDATALOG(rowId),"^",3)
	.s leftValue = $p(^DHCCKBRULEDATALOG(rowId),"^",4)
	.s leftType = $p(^DHCCKBRULEDATALOG(rowId),"^",5)
	.s op = $p(^DHCCKBRULEDATALOG(rowId),"^",6)	
	.s rightDic = $p(^DHCCKBRULEDATALOG(rowId),"^",7)
	.s rightValue = $p(^DHCCKBRULEDATALOG(rowId),"^",8)
	.s rightType = $p(^DHCCKBRULEDATALOG(rowId),"^",9)
	.s prentLev = $p(^DHCCKBRULEDATALOG(rowId),"^",10)
	.s level = $p(^DHCCKBRULEDATALOG(rowId),"^",11)
	.s rightExt = $p(^DHCCKBRULEDATALOG(rowId),"^",12)
	.s rightLimit = $p(^DHCCKBRULEDATALOG(rowId),"^",13)
	.s action = $p(^DHCCKBRULEDATALOG(rowId),"^",14)
	.s log = $p(^DHCCKBRULEDATALOG(rowId),"^",15)
	.s type = $p(^DHCCKBRULEDATALOG(rowId),"^",16)
	.s lastDataLog = $p(^DHCCKBRULEDATALOG(rowId),"^",17)
	.s ruleData = $p(^DHCCKBRULEDATALOG(rowId),"^",18)
	.	
	.s obj=##class(CKB.PDSS.RuleDataLog).%New()	
	.d obj.RDLLeftDicSetObjectId($case(+leftDic'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",leftDic,"")),:""))  //$case(leftDic="",1:"",:##class(CT.CKB.PDSS.CommonDiction).%OpenId(leftDic))
	.s obj.RDLLeftValue = $case(+leftValue'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",leftValue,"")),:"") 
	.s obj.RDLLeftType = leftType
	.s obj.RDLOp = op
	.d obj.RDLRightDicSetObjectId($case(+rightDic'=0,1:$o(^CKB.PDSS.DataMove("CommonDiction",rightDic,"")),:"")) //$case(rightDic="",1:"",:##class(CT.CKB.PDSS.CommonDiction).%OpenId(rightDic))
	.s obj.RDLRightValue = rightValue
	.s obj.RDLRightType = rightType
	.s obj.RDLRightExt = rightType
	.s obj.RDLRightLimit = rightLimit
	.s obj.RDLCondition = condition
	.d obj.RDLRuleSetObjectId($case(+rule'=0,1:$o(^CKB.PDSS.DataMove("Rule",rule,"")),:"")) // $case(rule="",1:"",:##class(CT.CKB.PDSS.Rule).%OpenId(rule))
	.s obj.RDLPrentLev = prentLev
	.s obj.RDLLevel = level
	.s obj.RDLAction = action
	.d obj.RDLLogSetObjectId($case(+log'=0,1:$o(^CKB.PDSS.DataMove("RuleLog",log,"")),:"")) //$case(log="",1:"",:##class(CKB.PDSS.RuleLog).%OpenId($o(^CKB.PDSS.DataMove("RuleLog",log,""))))
	.s obj.RDLType = type
	.s obj.RDLLastDataLog = lastDataLog //$case(lastDataLog="",1:"",:$o(^CKB.PDSS.DataMove("RuleDataLog",lastDataLog,"")))
	.d obj.RDLRuleDataSetObjectId($case(+ruleData'=0,1:$o(^CKB.PDSS.DataMove("RuleData",ruleData,"")),:"")) //$case(ruleData="",1:"",:##class(CT.CKB.PDSS.RuleData).%OpenId(ruleData))
	.s sc=obj.%Save()
	.d obj.%Close()
	.s newId= obj.%Id()
	.s ^CKB.PDSS.DataMove("RuleDataLog",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2023-02-17
/// Description: 	规则明细日志表 更新 RDLLastDataLog --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleDataLogUpdate()
ClassMethod RuleDataLogUpdate() As %String
{
	// ^CKB.PDSS.RuleDataLogD(ID)=$LB(%%CLASSNAME,RDLRule,RDLCondition,RDLLeftDic,RDLLeftValue,RDLLeftType,RDLOp,RDLRightDic,RDLRightValue,RDLRightType,RDLPrentLev,RDLLevel,RDLRightExt,RDLRightLimit,RDLAction,RDLLog,RDLType,RDLLastDataLog,RDLRuleData)

	s rowId = ""
	f  s rowId = $o(^CKB.PDSS.RuleDataLogD(rowId))  q:rowId=""  d
	.q:rowId=0
	.s data = $g(^CKB.PDSS.RuleDataLogD(rowId))
	.s RDLLastDataLog = $lg(data,18) 
	.q:(+RDLLastDataLog=0)
	.s obj=##class(CKB.PDSS.RuleDataLog).%OpenId(rowId)
	.s obj.RDLLastDataLog = $case(+RDLLastDataLog'=0,1:$o(^CKB.PDSS.DataMove("RuleDataLog",RDLLastDataLog,"")),:"") 
	.s sc=obj.%Save()
	.d obj.%Close()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	规则复制记录表  依赖规则序号表  --业务数据迁移(表名global改造后)
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).RuleCopyLogMove()
ClassMethod RuleCopyLogMove() As %String
{
	// ^DHCCKBRCL({DRCL_RowID})
	// CKB_PDSS.RuleCopyLog
	i '$d(^CKB.PDSS.DataMove("Rule")) s ^CKB.PDSS.DataMove("MoveErr","RuleCopyLog")="规则复制记录表 User.DHCCKBRuleCopyLog 迁移失败。原因: 规则序号表 User.DHCCKBRule 未迁移"
	q:'$d(^CKB.PDSS.DataMove("Rule")) ""
	
	s rowId = ""
	f  s rowId = $o(^DHCCKBRCL(rowId))  q:rowId=""  d
	.q:rowId=0
	.s ruleSource = $p(^DHCCKBRCL(rowId),"^",1)
	.s rulePurpose = $p(^DHCCKBRCL(rowId),"^",2) 
	.s ruleTag = $p(^DHCCKBRCL(rowId),"^",3) 
	.
	.s obj=##class(CKB.PDSS.RuleCopyLog).%New()	
	.s obj.DRCLRuleSource = $case(+ruleSource'=0,1:$o(^CKB.PDSS.DataMove("Rule",ruleSource,"")),:"") 
	.s obj.DRCLRulePurpose = $case(+rulePurpose'=0,1:$o(^CKB.PDSS.DataMove("Rule",rulePurpose,"")),:"")  
	.s obj.DRCLRuleTag = ruleTag
	.s sc=obj.%Save()
	.d obj.%Close()
	.//s newId= obj.%Id()
	.//s ^CKB.PDSS.DataMove("RuleCopyLogMove",rowId,newId)=""
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2022-12-21
/// Description: 	
/// Input:			
/// Other:	w ##class(web.DHCCKBDataDeal).GetOldRule(216001)
ClassMethod GetOldRule(newRowId) As %String
{
	s oldRowId = ""
	s rowId = ""
	f  s rowId = $o(^CKB.PDSS.DataMove("Rule",rowId))  q:rowId=""  d
	.q:'$d(^CKB.PDSS.DataMove("Rule",rowId,newRowId))
	.s oldRowId = rowId
	
	q oldRowId
}

}
