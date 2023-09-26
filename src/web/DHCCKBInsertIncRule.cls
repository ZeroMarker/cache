Import sqluser

/// Creator: 		wangxin
/// CreateDate: 	2021-2-27
/// Descript: 		知识图谱规则导入存储临时表数据
Class web.DHCCKBInsertIncRule Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		wangxin
/// CreateDate: 	2021-02-23
/// Descript:		插入临时规则表
/// W ##Class(web.DHCCKBRuleUpdCompareToLibrary).InsertIncRuleByruleDesc("硝苯地平控释片30mg(上海现代制药股份有限公司)","dhcckb,65736,80828.792328","rule","1")
ClassMethod InsertIncRuleByrule(ItemDesc As %String, ruleDesc As %String, ruleCode As %String, loginInfo) As %String
{
	n (ItemDesc,ruleDesc,ruleCode,loginInfo)
	
	
	//存入DHC_CKBInsRule表
	s rdRule=..InsDhcIncRule(ruleCode,ruleDesc)
	i rdRule=-1 tro 
	q:rdRule=-1 rdRule 
	
	//存入CKB.PDSS.RuleLog表
    s rdLogRule=..InsDhcIncRuleLog(rdRule,loginInfo,"Add")
	i rdLogRule=-1 tro 
	q:rdLogRule=-1 rdLogRule
	
	//存入DHC_CKBInsRuleNode表
	s ruleNode=..InsDhcIncRuleNode(ItemDesc,ruleDesc,rdRule)
	i ruleNode=-1 tro
	q:ruleNode=-1 ruleNode
	
	s count=""
	f  s count=$o(^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc",ruleDesc,count)) Q:count=""  D
	.s data=^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc",ruleDesc,count)
	.s Err=..InsDhcIncRuleDic(data,rdRule)   //存入DHC_CKBInsRuleDic表
	.i Err=-1 tro
	.q:Err=-1
	.s ruleData=..InsDhcIncRuleData(data,rdRule,ruleNode)  //存入DHC_CKBInsRuleData表
	.i ruleData=-1 tro
	.q:ruleData
	.s incruleData=..InsDhcIncRuleDataLog(data, rdRule, ruleNode, rdLogRule, ruleData) //存入DHC_CKBIncRuleDataLog表
	.i incruleData=-1 tro
	.q:incruleData=-1
	
	Q 0
}

/// Creator: wangxin 
/// CreateDate: 2021-02-23 
/// function: 插入DHC_CKBIncRule   临时规则表
/// others: d ##class(web.DHCCKBRuleUpdCompareToLibrary).InsDhcIncRule("rule","dhcckb,65736,80828.792328") 
ClassMethod InsDhcIncRule(ruleCode As %String, ruleDesc As %String) As %String
{
	n (ruleCode,ruleDesc)
    &SQL(INSERT INTO DHC_CKBIncRule (I_Name, I_Status, I_UniqeIdentity) VALUES (:ruleCode,"Add",:ruleDesc))
    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-26
/// function:  插入 DHC_CKBIncRuleLog  临时规则日志表
/// others: d ##class(web.DHCCKBIncRuleUpdCompare).InsDhcIncRuleLog("rule","dhcckb,65736,80828.792328") 
ClassMethod InsDhcIncRuleLog(ruleId, loginInfo, type) As %String
{
    n (ruleId,loginInfo,type)
    
	s hospital=$p(loginInfo,"^",5)
	s hospital=$p($g(^CT("HOSP",+hospital)),"^",2)    //医院
    s logId=+$o(^DHCCKBIncRULELOG(0,"Rule",ruleId,""),-1)
    s date=$zdate(+$h,3)
    s time=$zt($p($h,",",2),1)
    s ruleCode=$p(^DHCCKBINCRULE(ruleId),"^",2)
    
    &SQL(INSERT INTO SQLUser.DHC_CKBIncRuleLog (I_Rule,  I_Type, I_Name, I_LastLog, I_Hospital)
VALUES (:ruleId,   :type, :ruleCode, :logId, :hospital))
    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-23      临时规则逻辑表
/// function: 插入DHC_CKBIncRuleNode
/// others: d ##class(web.DHCCKBRuleUpdCompareToLibrary).InsDhcIncRuleNode() 
ClassMethod InsDhcIncRuleNode(ItemDesc As %String, ruleDesc As %String, rdRule) As %String
{
	n (ItemDesc,ruleDesc,rdRule)
	s data=^DHCCKBRULEDIC("web.DHCCKBRuleUpdate","GetRuleNode",ItemDesc,ruleDesc)
	s rnCondition=$p(data,"^",1)
	s rnAction=$p(data,"^",2)
    &SQL(INSERT INTO DHC_CKBIncRuleNode (IN_Condition, IN_Action, IN_Rule)VALUES (:rnCondition,:rnAction,:rdRule))
    i SQLCODE'=0 q:-1
	q %ROWID
}

/// Creator: wangxin 
/// CreateDate: 2021-02-23 
/// function: 插入DHC_CKBIncRuleDic      临时规则关联表
/// others: d ##class(web.DHCCKBRuleUpdCompareToLibrary).InsDhcRuleDic() 
ClassMethod InsDhcIncRuleDic(data As %String, rdRule) As %String
{
	n (data,rdRule)
	s leftDesc=$p(data,"^",1)  //父节点id
	s rightDesc=$p(data,"^",8) //子节点id   91^特殊人群^7^患者^variable^Equals^=^3921^成人^^Constant^^^^Equals
	i rightDesc="" D
	.s rightDesc=$p(data,"^",12) //子节点id
    &SQL(INSERT INTO SQLUser.DHC_CKBIncRuleDic (ID_Rule, ID_Dic, ID_DicParent)VALUES (:rdRule, :leftDesc, :rightDesc))
    i SQLCODE'=0 q:-1
    q SQLCODE
}

/// Creator: wangxin 
/// CreateDate: 2021-02-23 
/// function: 插入DHC_CKBIncRuleData     临时规则内容表
/// others: d ##class(web.DHCCKBRuleUpdCompareToLibrary).InsDhcIncRuleData() 
ClassMethod InsDhcIncRuleData(data As %String, rdRule, ruleNode) As %String
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

    &SQL(INSERT INTO SQLUser.DHC_CKBIncRuleData (ID_LeftDic, ID_LeftValue, ID_LeftType, ID_Op, ID_RightDic, ID_RightValue, ID_RightType, ID_RightExt, ID_RightLimit, ID_Rule, ID_Node)
    VALUES (:rdLeftDic, :rdLeftValue, :rdLeftType, :rdOp, :rdRightDic, :rdRightValue, :rdRightType, :rdRightExt, :rdRightLimit, :rdRule, :ruleNode))
    i SQLCODE'=0 q:-1
    q SQLCODE
}

/// Creator: wangxin 
/// CreateDate: 2021-02-26 
/// function: 插入DHC_CKBIncRuleDataLog     临时规则内容日志表
/// others: d ##class(web.DHCCKBRuleUpdCompare).InsDhcIncRuleData() 
ClassMethod InsDhcIncRuleDataLog(data As %String, rdRule, ruleNode, rdLogRule, ruleData) As %String
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

   &SQL( INSERT INTO DHC_CKBIncRuleDataLog (I_LeftDic, I_LeftValue, I_LeftType, I_Op, I_RightDic, I_RightValue, I_RightType,  I_Rule, I_Level,I_RightExt, I_RightLimit, I_Action, I_Log, I_Type, I_RuleData)
VALUES (:rdLeftDic, :rdLeftValue, :rdLeftType, :rdOp, :rdRightDic, :rdRightValue, :rdRightType,  :rdRule,  :ruleLev, :rdRightExt, :rdRightLimit, :type, :rdLogRule, 'Add', :ruleData))

    i SQLCODE'=0 q:-1
    q SQLCODE
}

}
