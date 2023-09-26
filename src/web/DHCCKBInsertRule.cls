Import sqluser

/// Creator: 		wangxin
/// CreateDate: 	2021-2-27
/// Descript: 		知识图谱规则导入存储表数据
Class web.DHCCKBInsertRule Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		插入导入规则
/// W ##Class(web.DHCCKBRuleUpdCompare).InsertRuleByrule()
ClassMethod InsertRuleByrule(ItemDesc As %String, ruleDesc As %String, ruleCode As %String, loginInfo) As %String
{
	n (ItemDesc,ruleDesc,ruleCode,loginInfo)
	
	//存入CT_CKB_PDSS.Rule表
    s rdRule=..InsDhcRule(ruleCode,ruleDesc,loginInfo)
	i rdRule=-1 tro 
	q:rdRule=-1 rdRule 
	
	//存入CKB.PDSS.RuleLog表
    s rdLogRule=..InsDhcRuleLog(rdRule,loginInfo,"Add")
	i rdLogRule=-1 tro 
	q:rdLogRule=-1 rdLogRule 
	
	//存入CT_CKB_PDSS.RuleNode表
	s ruleNode=..InsDhcRuleNode(ItemDesc,ruleDesc,rdRule)
	i ruleNode=-1 tro
	q:ruleNode=-1 ruleNode
	
	s count=""
	f  s count=$o(^tmp("web.DHCCKBRuleUpdCompare","GetImportRuleByruleDesc",ruleDesc,count)) Q:count=""  D
	.s data=^tmp("web.DHCCKBRuleUpdCompare","GetImportRuleByruleDesc",ruleDesc,count)
	.s Err=..InsDhcRuleDic(data,rdRule)   //存入CT_CKB_PDSS.RuleDic表
	.i Err=-1 tro
	.q:Err=-1
	.s ruleData=..InsDhcRuleData(data,rdRule,ruleNode)  //存入CT_CKB_PDSS.RuleData表
	.i ruleData=-1 tro
	.q:ruleData=-1
	.s ruleDataLog=..InsDhcRuleDataLog(data,rdRule,ruleNode,rdLogRule,ruleData)
	.i ruleDataLog=-1 tro
	.q:ruleDataLog=-1
	
	Q 0
}

/// Creator: wangxin 
/// CreateDate: 2021-02-24
/// function: 插入CT_CKB_PDSS.Rule  规则表
/// others: d ##class(web.DHCCKBIncRuleUpdCompare).InsDhcRule("rule","dhcckb,65736,80828.792328") 
ClassMethod InsDhcRule(ruleCode As %String, ruleDesc As %String, loginInfo) As %String
{
	n (ruleCode,ruleDesc,loginInfo)  
	s hospID=$p(loginInfo,"^",5)
	s hospDesc=$p($g(^CT("HOSP",+hospID)),"^",2)
	s ruleDescNew=##class(web.DHCCKBCommonUtil).GetCNCODE(hospDesc,3)_","_$Now()   //项目上重新生成唯一标识   将生成的唯一标识和之前的唯一标识做绑定关系
    
    //留绑定接口
    
    &SQL(INSERT INTO CT_CKB_PDSS.Rule (R_Name, R_Status, R_UniqeIdentity) VALUES (:ruleCode,"Add",:ruleDescNew))
    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-26
/// function:  插入 CKB_PDSS.RuleLog  规则日志表
/// others: d ##class(web.DHCCKBIncRuleUpdCompare).InsDhcRule("rule","dhcckb,65736,80828.792328") 
ClassMethod InsDhcRuleLog(ruleId, loginInfo, type) As %String
{
    n (ruleId,loginInfo,type)
    
	s hospital=$p(loginInfo,"^",5)
	s hospital=$p($g(^CT("HOSP",+hospital)),"^",2)    //医院
    s logId=+$o(^CKB.PDSS.RuleLogI("Rule",ruleId,""),-1)
    s date=$zdate(+$h,3)
    s time=$zt($p($h,",",2),1)
    s ruleCode=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)
    
    &SQL(INSERT INTO CKB_PDSS.RuleLog (RL_Rule,  RL_Date, RL_Time, RL_Type, RL_Name, RL_LastLog, RL_Hospital)
VALUES (:ruleId,  :date, :time, :type, :ruleCode, :logId, :hospital))

    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-24      规则逻辑表
/// function: 插入CT_CKB_PDSS.RuleNode
/// others: d ##class(web.DHCCKBIncRuleUpdCompare).InsDhcRuleNode() 
ClassMethod InsDhcRuleNode(ItemDesc As %String, ruleDesc As %String, ruleLev, rdRule) As %String
{
	n (ItemDesc,ruleDesc,rdRule)
	q:ruleLev="" -1
	s data=^DHCCKBRULEDIC("web.DHCCKBRuleUpdate","GetRuleNode",ItemDesc,ruleDesc)
	s rnCondition=$p(data,"^",1)
	s rnAction=$p(data,"^",2)   
    &SQL(INSERT INTO CT_CKB_PDSS.RuleNode (RN_Condition, RN_Action, RN_Rule)VALUES (:rnCondition,:rnAction,:rdRule))
    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-24
/// function: 插入CT_CKB_PDSS.RuleDic      规则关联表
/// others: d ##class(web.DHCCKBRuleUpdCompare).InsDhcRuleDic() 
ClassMethod InsDhcRuleDic(data As %String, rdRule) As %String
{
	n (data,rdRule)
	s leftDesc=$p(data,"^",1)  //父节点id
	s rightDesc=$p(data,"^",8) //子节点id  
	i rightDesc="" D
	.s rightDesc=$p(data,"^",12) //子节点id  
    &SQL(INSERT INTO CT_CKB_PDSS.RuleDic (RD_Rule, RD_Dic, RD_DicParent)VALUES (:rdRule, :leftDesc, :rightDesc))
    i SQLCODE'=0 q:-1
    q SQLCODE
}

/// Creator: wangxin 
/// CreateDate: 2021-02-24 
/// function: 插入CT_CKB_PDSS.RuleData     规则内容表
/// others: d ##class(web.DHCCKBRuleUpdCompare).InsDhcRuleData() 
ClassMethod InsDhcRuleData(data As %String, rdRule, ruleNode) As %String
{
	n (data,rdRule,ruleNode)
	
	s rdLeftDic=$p(data,"^",1)
	s rdLeftValue=$p(data,"^",3)
	s rdLeftType=$p(data,"^",5)
	s rdOp=$p(data,"^",15)
	s rdRightDic=$p(data,"^",8)
	s rdRightValue=$p(data,"^",10)
	s rdRightType=$p(data,"^",11)
	s rdRightExt=$p(data,"^",12)
	s rdRightLimit=$p(data,"^",14)
    &SQL(INSERT INTO CT_CKB_PDSS.RuleData (RD_LeftDic, RD_LeftValue, RD_LeftType, RD_Op, RD_RightDic, RD_RightValue, RD_RightType, RD_RightExt, RD_RightLimit, RD_Rule, RD_Node)
VALUES (:rdLeftDic, :rdLeftValue, :rdLeftType, :rdOp, :rdRightDic, :rdRightValue, :rdRightType, :rdRightExt, :rdRightLimit, :rdRule, :ruleNode))
    i SQLCODE'=0 q:-1
    q SQLCODE
}

/// Creator: wangxin 
/// CreateDate: 2021-02-26 
/// function: 插入CT_CKB_PDSS.RuleDataLog     规则内容日志表
/// others: d ##class(web.DHCCKBRuleUpdCompare).InsDhcRuleData() 
ClassMethod InsDhcRuleDataLog(data As %String, rdRule, ruleNode, rdLogRule, ruleData) As %String
{
	n (data,rdRule,ruleNode,rdLogRule,ruleData)
	
	s rdLeftDic=$p(data,"^",1)
	s rdLeftValue=$p(data,"^",3)
	s rdLeftType=$p(data,"^",5)
	s rdOp=$p(data,"^",15)
	s rdRightDic=$p(data,"^",8)
	s rdRightValue=$p(data,"^",10)
	s rdRightType=$p(data,"^",11)
	s rdRightExt=$p(data,"^",12)
	s rdRightLimit=$p(data,"^",14)
    s type=$p(data,"^",15)
    s ruleLev=$p(data,"^",16)

   &SQL( INSERT INTO CKB_PDSS.RuleDataLog (RDL_LeftDic, RDL_LeftValue, RDL_LeftType, RDL_Op, RDL_RightDic, RDL_RightValue, RDL_RightType,  RDL_Rule, RDL_Level, RDL_RightExt, RDL_RightLimit, RDL_Action, RDL_Log, RDL_Type, RDL_RuleData)
VALUES (:rdLeftDic, :rdLeftValue, :rdLeftType, :rdOp, :rdRightDic, :rdRightValue, :rdRightType,  :rdRule,  :ruleLev, :rdRightExt, :rdRightLimit, :type, :rdLogRule, 'Add', :ruleData))

    i SQLCODE'=0 q:-1
    q SQLCODE
}

}
