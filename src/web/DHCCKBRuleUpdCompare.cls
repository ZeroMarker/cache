Import sqluser

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript: 		知识图谱规则导入项目相关
Class web.DHCCKBRuleUpdCompare Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		wangxin
/// CreateDate: 	2021-02-23
/// Descript:		导出修改规则
/// W ##Class(web.DHCCKBRuleUpdCompare).QueryAllDrug("2019-10-06^2019-11-07")
ClassMethod QueryAllDrug(Params) As %String
{
	 n (Params)
	 s startDate=$zdh($p(Params,"^",1),3)
	 s:startDate'="" startDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(startDate) 
	 s endDate=$zdh($p(Params,"^",2),3)
	 s:endDate'="" endDate=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(endDate) 
	 k TmpArr
	 k ^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp")
	 k ^TMPExportDrugRule("web.DHCCKBRuleUpdate","Drug") 
	 
	 f stDate=startDate:1:endDate  d 
  	 .s rlRowId=""    
 	 .f  s rlRowId=$o(^CKB.PDSS.RuleLogI("Date",stDate,rlRowId))   Q:rlRowId=""  D
 	 ..s rlRule=$lg(^CKB.PDSS.RuleLogD(rlRowId),2)            //规则id   
 	 ..s rdRowID="",exitflag=0
 	 ..f rdRowID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rlRule,rdRowID))  Q:(rdRowID="")||(exitflag=1)  D
 	 ...s rdlRowId=""
 	 ...f rdlRowId=$o(^CKB.PDSS.RuleDataLogI("RuleData",rdRowID,rdlRowId))  Q:(rdlRowId="")||(exitflag=1)  D
 	 ....s rdlType=$lg(^CKB.PDSS.RuleDataLogD(rdlRowId),17)  //规则变更类型
 	 ....q:rdlType="Unchanged" 
 	 ....s exitflag=1
 	 ..i exitflag=1  D ##class(web.DHCCKBRuleUpdate).ExportRulesById(rlRule)
 	 //w ##Class(web.DHCCKB.Util.UtilService).ExportGlobal("TMPExportDrugRule", "D:\TMPExportDrugRule.gof")  //导出global文件
 	 q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-02
/// Descript:		
/// Input:          GlobalName - global名字, FilePath - D:\\EEEE.gbl  
/// W ##Class(web.DHCCKBRuleUpdCompare).ImportGlobal("TMPExportDrugRule", "D:\\TMPExportDrugRule.gof")
ClassMethod ImportGlobal(Global As %String, FilePath As %String, loginInfo As %String) As %String
{
	n (Global, FilePath,loginInfo)
	k ^TMPExportDrugRule
	D ##Class(%Library.Global).Import("", Global, FilePath)
	Q ..GetImportIncRuleByruleDesc(loginInfo)      //规则插入表
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		规则导入项目
/// W ##Class(web.DHCCKBRuleUpdCompare).GetImportIncRuleByruleDesc()
ClassMethod GetImportIncRuleByruleDesc(loginInfo As %String) As %String
{
   n (ItemDesc,ruleDesc,loginInfo)
   
   k ^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc")
   s ^tmp("DIFF")=0
   TS  //开启事务
   
   s del=""""
   s count=0,total=0
   s sqlCode=""
   s ItemDesc=""
   f  s ItemDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc)) Q:ItemDesc=""  D
   .s ruleCode=""
   .f  s ruleCode=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode)) Q:ruleCode=""  D
   ..s catId=""
   ..f  s catId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId)) Q:catId=""  D
   ...s ruleDesc=""
   ...f  s ruleDesc=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc))  Q:ruleDesc=""  D
   ....                                                                        //根据CopyLog表,使用唯一标识判断该规则是否是由项目上获取,若是从项目上获取到的,则不进行添加
   ....s rRowid=$o(^CT.CKB.PDSS.RuleI("UniqeIdentity",ruleDesc,""))                 //根据唯一标识获取到规则id,若rRowid为空,则说明该规则id为新增规则,项目库没有
   ....s total=total+1
   ....i rRowid'="" D ..JudgeStateById(rRowid,loginInfo)
   ....s rowId=""
   ....f  s rowId=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId))  Q:rowId=""  D
   .....s ruleLev=""
   .....f  s ruleLev=$o(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))  Q:ruleLev=""  D
   ......s data=$g(^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",ItemDesc,ruleCode,catId,ruleDesc,rowId,ruleLev))
   ......s count=count+1
   ......s ^tmp("web.DHCCKBRuleUpdCompare","GetImportIncRuleByruleDesc",ruleDesc,count)=data
   ....s sqlCode=..InsertRuleByruleDesc(ItemDesc,ruleDesc,ruleCode,loginInfo)  //插入规则表
   
   TC   //关闭事务
   s DIFF=^tmp("DIFF")
   s ADD=total-DIFF
    W "[" //输出json前缀串
    w "{" 
	w del_"ALL"_del_":"_total_","_del_"DIFF"_del_":"_DIFF_","_del_"ADD"_del_":"_ADD_","_del_"sqlCode"_del_":"_sqlCode
	w "}"
	W "]"
   q ""
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		根据规则id判断规则状态--
/// W ##Class(web.DHCCKBRuleUpdCompare).JudgeStateById("123563")
ClassMethod JudgeStateById(RowId As %String, loginInfo As %String) As %String
{
	n (RowId,loginInfo)
	s state=$lg($g(^CT.CKB.PDSS.RuleD(RowId)),4)
	q:state="CancelRelease"    //如果该规则处于未发布状态,则不需要更新
	i state="Release" d          //如果该规则处于发布状态,则修改为未发布状态
	.D ..UpDhcRuleState(RowId,loginInfo)
	.s ^tmp("DIFF")=^tmp("DIFF")+1      //记录规则差异条数
	Q ""
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		修改发布状态为未发布
/// W ##Class(web.DHCCKBRuleUpdCompare).UpDhcRuleState("")
ClassMethod UpDhcRuleState(RowId As %String, loginInfo) As %String
{
	n (RowId)
	s RName=$lg($g(^CT.CKB.PDSS.RuleD(RowId)),3)
    s RRemark=$lg($g(^CT.CKB.PDSS.RuleD(RowId)),2)		
    s RUniqeIdentity=$lg($g(^CT.CKB.PDSS.RuleD(RowId)),5)
    
    //&SQL(UPDATE SQLUser.CT_CKB_PDSS.Rule SET R_Remark = :RRemark , R_Name = :RName, R_Status = "CancelRelease" , R_UniqeIdentity = :RUniqeIdentity )
    //i SQLCODE'=0 q:-1
	//q SQLCODE
	
	//s ruleNode=..InsDhcRuleLog(RowId,loginInfo,"Edit")
	//i ruleNode=-1 tro
	//q:ruleNode=-1 ruleNode
	
	q ""
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:		插入导入规则
/// W ##Class(web.DHCCKBRuleUpdCompare).InsertRuleByruleDesc()
ClassMethod InsertRuleByruleDesc(ItemDesc As %String, ruleDesc As %String, ruleCode As %String, loginInfo) As %String
{
	n (ItemDesc,ruleDesc,ruleCode,loginInfo)
	
	//存入CT_CKB_PDSS.Rule表
    s rdRule=..InsDhcRule(ruleCode,ruleDesc)
	i rdRule=-1 tro 
	q:rdRule=-1 rdRule 
	
	//存入CKB_PDSS.RuleLog表
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
ClassMethod InsDhcRule(ruleCode As %String, ruleDesc As %String) As %String
{
	n (ruleCode,ruleDesc,loginInfo)    
    &SQL(INSERT INTO CT_CKB_PDSS.Rule (R_Name, R_Status, R_UniqeIdentity) VALUES (:ruleCode,"Add",:ruleDesc))
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
	s rightDesc=$p(data,"^",8) //子节点id   91^特殊人群^7^患者^variable^Equals^=^3921^成人^^Constant^^^^Equals
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
