Import sqluser

/// Creator：      zhouxin
/// CreatDate：    2019-06-17
/// Description:： 保存规则
Class web.DHCCKBRuleSave Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s json=$g(%request.Data("json",1),"")
	s ruleId=$g(%request.Data("ruleId",1),"")
	s dicStr=$g(%request.Data("dicStr",1),"")
	s LgUserId=$g(%request.Data("LgUserId",1),"")
	s status=$g(%request.Data("status",1),"")
	s loginInfo=$g(%request.Data("loginInfo",1),"")	
	s msg=""
	
	
	i +ruleId=0 d
	.s:status'="" msg="请先保存规则"
	e  d
	.i '$d(^CT.CKB.PDSS.RuleD(ruleId)) d //hxy 2020-12-10 st
	..s msg="该规则已无,不需维护保存"
	.e  d //ed
	..s ruleStatus=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)
	..s:(ruleStatus="Release")&&("CancelRelease"'=status) msg="规则已经发布,请勿重复发布"
	..s:(ruleStatus="CancelRelease")&&("CancelRelease"=status) msg="规则还未发布"
	i msg'="" d ##class(web.DHCCKBCommonUtil).R(-888,msg)
	q:msg'="" $$$OK
	
	s $zt="Err"
	
	;TS
	s ret=##class(web.DHCCKBRuleSave).save(ruleId,status,json,LgUserId,dicStr,loginInfo)	// 增加登录信息 qunianpeng 2020/3/30
	;i ret<=0 Tro
	;e  TC
	
	d ##class(web.DHCCKBCommonUtil).R(ret,ret)
	Quit $$$OK
Err
 TRo
 s obj={}.%Set("code",-999).%Set("code",$Ze)
 w obj.%ToJSON()
 Quit $$$OK
}

/// 保存规则
/// Input:
///       ruleId   | 规则组号表id  | CT_CKB_PDSS.Rule
///       status   | 状态描述  	   | Release（发布）、CancelRelease（取消发布）
///       json 	   | 规则json字符串| {rule:{remark:"",if:{},then:{},else:{},_name:"rule"}}
///       LgUserId | 登录用户id    | ss_user
///       dicStr   | 规则实体id串  | DHC_CKBCommonDiction
/// 		  baseHosp 20210916增加标库的医院描述，用于更新规则后，区分标库和项目的规则,便于多次更新
/// Output:
///       0	    | 成功
///       其他  | 失败
/// w ##class(web.DHCCKBRuleSave).save("0","","{""rule"":{""remark"":"""",""if"":{""and"":{""and"":[{""atom"": [ {""left"": {""_varCategory"":""西医疾病"",  ""_ruleData"":""0"",""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""0"",  ""_const-category"":""201572"",  ""_const"":""201572"",  ""_const-label"":""霍乱暴发型"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""NotEquals""}, {""left"": {""_varCategory"":""西医疾病"",  ""_r    uleData"":""0"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {    ""_ruleData"":""0"",  ""_const-category"":""205988"",  ""_const"":""205988"",  ""_const-label"":""未特指的霍乱"",  ""_extconst"":"""", ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""NotEquals""}]},{""or"":{""atom"": [ {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""0"",""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",    ""_type"": ""variable""},""value"": {  ""_ruleData"":""0"",  ""_const-category"":""252121"",  ""_const"":""252121"",  ""_const-label"":""副伤寒甲"",  ""_extco    nst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""0"",  ""_varCateg    oryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",""_datatype"":""String"",""_type"": ""variable""},""value"": {""_ruleData"":""0"",""_const-category"":""188207"",""_const"":""188207"",""_const-label"":""B群沙门菌肠炎"",""_extconst"":"""",""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}]}}]}},""then"":"""",""else"":"""",""_name"":""rule""}}","11870","262295","11870^8^1^289^2")
/// w ##class(web.DHCCKBRuleSave).save("640347","CancelRelease","{""rule"":{""remark"":"""",""if"":{""and"":{""or"":{""atom"": [ {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443260"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443260"",  ""_const-category"":""185752"",  ""_const"":""185752"",  ""_const-label"":""贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443261"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443261"",  ""_const-category"":""185754"",  ""_const"":""185754"",  ""_const-label"":""婴儿贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443262"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443262"",  ""_const-category"":""185756"",  ""_const"":""185756"",  ""_const-label"":""轻度贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443263"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443263"",  ""_const-category"":""185757"",  ""_const"":""185757"",  ""_const-label"":""中度贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443264"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443264"",  ""_const-category"":""185758"",  ""_const"":""185758"",  ""_const-label"":""重度贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""西医疾病"",  ""_ruleData"":""6443265"",  ""_varCategoryId"":""6"",  ""_var"":""26983"",  ""_varLabel"":""ICD诊断"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443265"",  ""_const-category"":""185759"",  ""_const"":""185759"",  ""_const-label"":""继发性贫血"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}]},""union"":{""atom"": [ {""left"": {  ""_varCategory"":""检验指标"",  ""_ruleData"":""6443266"",  ""_varCategoryId"":"""",  ""_var"":""9"",  ""_varLabel"":"""",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443266"",  ""_const-category"":""49872"",  ""_const"":""49872"",  ""_const-label"":""内生肌酐清除率"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""Constant""},""_op"": ""Equals""}, {""left"": {  ""_varCategory"":""检验指标"",  ""_ruleData"":""6443267"",  ""_varCategoryId"":""9"",  ""_var"":""95"",  ""_varLabel"":""范围值"",  ""_datatype"": ""String"",  ""_type"": ""variable""},""value"": {  ""_ruleData"":""6443267"",  ""_content"":""15"",  ""_uom"":""13365"",  ""_extconst"":"""",  ""_extconstvar"":"""",""_type"":""InputUom""},""_op"": ""LessThen""}]}}},""then"":{""var-assign"":[{""value"":{""_ruleData"":""0"",""_content"":""满足条件的诊断集合1且内生肌酐清除率 < 15ml/min"",""_type"":""Input""},""_varCategory"":""药品输出"",""_ruleData"":""6443268"",""_varCategoryId"":""16"",""_var"":""82"",""_varLabel"":""提示信息"",""_datatype"":""undefined"",""_type"":""variable""}]},""else"":"""",""_name"":""rule""}}","11870","97569","11870^8^1^289^2")
/// "{""rule"":{""remark"":"""",""if"":{""and"":{""atom"":{""left"":{""_varCategory"":""西药"",""_ruleData"":""4214065"",""_varCategoryId"":""5"",""_var"":""49"",""_varLabel"":""单次给药剂量"",""_datatype"":""String"",""_type"":""variable""},""value"":{""_ruleData"":""4214065"",""_content"":""8"",""_uom"":""3924"",""_extconst"":"""",""_extconstvar"":"""",""_type"":""InputUom""},""_op"": ""LessThenEquals""}}},""then"":"""",""else"":{""var-assign"":[{""value"":{""_ruleData"":""4214066"",""_const-category"":""undefined"",""_const"":""142"",""_const-label"":""不通过"",""_type"":""Constant""},""_varCategory"":""药品输出"",""_ruleData"":""4214066"",""_varCategoryId"":""16"",""_var"":""80"",""_varLabel"":""通过标记"",""_datatype"":""undefined"",""_type"":""variable""},{""value"":{""_ruleData"":""4214067"",""_const-category"":""undefined"",""_const"":""138"",""_const-label"":""提醒"",""_type"":""Constant""},""_varCategory"":""药品输出"",""_ruleData"":""4214067"",""_varCategoryId"":""16"",""_var"":""81"",""_varLabel"":""管理级别"",""_datatype"":""undefined"",""_type"":""variable""},{""value"":{""_ruleData"":""0"",""_content"":""人"",""_type"":""Input""},""_varCategory"":""药品输出"",""_ruleData"":""4214068"",""_varCategoryId"":""16"",""_var"":""82"",""_varLabel"":""提示信息"",""_datatype"":""undefined"",""_type"":""variable""},{""value"":{""_ruleData"":""4214069"",""_const-category"":""undefined"",""_const"":""26852"",""_const-label"":""Y"",""_type"":""Constant""},""_varCategory"":""药品输出"",""_ruleData"":""4214069"",""_varCategoryId"":""16"",""_var"":""74698"",""_varLabel"":""消息提示标记"",""_datatype"":""undefined"",""_type"":""variable""}]},""_name"":""rule""}}"
ClassMethod save(ruleId, status, json, LgUserId, dicStr, loginInfo, baseHosp = "")
{
	n (ruleId,status,json,LgUserId,dicStr,loginInfo,baseHosp)
	s:LgUserId="" LgUserId=$p(loginInfo,"^",1)
	
	s StreamObject = ""
	i ('$IsObject(StreamObject)){
		s StreamObject=##class(%GlobalCharacterStream).%New()
	}
	
	s ruleJson = ""
	i ('$IsObject(json)){
		s ruleJson = json
	}
	
	i ($IsObject(json)){
		while('json.AtEnd){
			s jsonStr = json.Read()
			d StreamObject.Write(ruleJson)
			i ruleJson = "" s ruleJson = jsonStr
			e  s ruleJson = ruleJson_jsonStr
		}
	}
	
	s ruleJson = $replace(ruleJson,"\","")
	s obj=##class(%DynamicArray).%FromJSON(ruleJson)
	
	s rule=obj.%Get("rule")
	
	s remark=rule.%Get("remark")
	s then=rule.%Get("then")
	s else=rule.%Get("else")
	s ruleName=rule.%Get("_name")
	s identity = rule.%Get("uniqeIdentity")
	
	s ret=0
	
	///save CT_CKB_PDSS.Rule (规则主表)
	s ruleId=##class(web.DHCCKBRuleSave).SaveRule(ruleId,ruleName,remark,status,loginInfo,identity)
	
	s ^temptest("31") = ruleId
	if ruleId<0   Q ruleId
	
	///save CKB_PDSS.RuleLog (规则主表日志)
	s log=##class(web.DHCCKBRuleLog).SaveLog(ruleId,LgUserId,loginInfo,baseHosp)
	if log<0   Q log
	
	///save CT_CKB_PDSS.RuleDic (规则目录)
	s ret=##class(web.DHCCKBRuleDic).SaveRuleDic(ruleId,dicStr)
	if ret'=0   Q ret
	
	///save if	(CT_CKB_PDSS.RuleData)(CT_CKB_PDSS.RuleNode)
	s if=rule.%Get("if")
	s ret=##class(web.DHCCKBRuleSave).SaveIf(ruleId,if,dicStr)
	
	if ret'=0   Q ret
	///save then (CT_CKB_PDSS.RuleData)
	i then'="" d
	.s ret=##class(web.DHCCKBRuleSave).SaveOutAction("then",ruleId,then)
	if ret'=0   Q ret
	
	///save else (CT_CKB_PDSS.RuleData)
	i else'="" d
	.s ret=##class(web.DHCCKBRuleSave).SaveOutAction("else",ruleId,else)
	if ret'=0   Q ret
	
	///save CKB_PDSS.RuleDataLog (removed data)
	s ret=##class(web.DHCCKBRuleLog).SaveRemoveDataLog(log)
	if ret<0   Q ret
	
	///save RulePriority (CT_CKB_PDSS.DicLinkAttr) 
	s ret=##class(web.DHCCKBRulePriority).SaveRulePriority(ruleId)
	q:ret'=0 ret

	// 生成药品->目录->规则关系 2022-03-30 qnp
	d ##class(web.DHCCKBConfig).SetDrugLibaryRefByRule(ruleId)
	// 同步数据池方法
	d ##Class(web.DHCCKBPreconditionDataPool).SyncPreDataPool(ruleId)
	q ruleId
}

/// 保存规则组号
ClassMethod SaveRule(ruleId, ruleName, remark, status, loginInfo, identity = "")
{
	n (ruleId, ruleName, remark,status,loginInfo,identity)
	
	s userID=$p(loginInfo,"^",1)
	s professID=$p(loginInfo,"^",2)
	s locID=$p(loginInfo,"^",3)
	s groupID=$p(loginInfo,"^",4)
	s hospID=$p(loginInfo,"^",5)
	s hospDesc=$p($g(^CT("HOSP",+hospID)),"^",2)
	
	s:(status="")&&(+ruleId'=0) status="Edit"
	s:(status="")&&(+ruleId=0) status="Add"
	
	&sql(delete from CT_CKB_PDSS.RuleData where RD_Rule=:ruleId)
	&sql(delete from CT_CKB_PDSS.RuleNode where RN_Rule=:ruleId)
	
	s editFlag = 0
	i +ruleId=0 d
	.s ruleObj=##class(CT.CKB.PDSS.Rule).%New()
	e  d
	.s ruleObj=##class(CT.CKB.PDSS.Rule).%OpenId(ruleId)
	.s editFlag=1
	s ruleObj.RName=ruleName
	s ruleObj.RRemark=remark
	s ruleObj.RStatus=status
	i identity = ""  d
	.i ##class(web.DHCCKBConfig).SysUser()[hospDesc d	// 增加唯一标识 qnp 2002/12/16
	..s identity="dhcckb"_","_$Now()
	.e  d
	..s identity=##class(web.DHCCKBCommonUtil).GetCNCODE(hospDesc,3)_","_$Now()
	
	i editFlag=0 s ruleObj.RUniqeIdentity=identity	// 新增时才产生唯一标识	
	s sc=ruleObj.%Save()
	q:$SYSTEM.Status.IsError(sc) -10
	q ruleObj.%Id()
}

/// 保存IF
/// 2019-06-19
/// zhouxin
ClassMethod SaveIf(ruleId, ifObj, drugInfo = "")
{
	n (ruleId, ifObj,drugInfo)
	set iter = ifObj.%GetIterator()
	s ret=0
	while iter.%GetNext(.key , .value ) {
	  q:ret'=0 
	  s node=##class(web.DHCCKBRuleSave).SaveNode(key, ruleId, "if", 0)
	  s ret=##class(web.DHCCKBRuleSave).SaveCondition(key,ruleId,value,node,drugInfo)
	}
	q ret
}

/// 保存规则
/// 2019-06-19
/// zhouxin
ClassMethod SaveCondition(condition, ruleId, condObj, node, drugInfo = "")
{
	n (condition,ruleId,condObj,node,drugInfo)
	
	s condType=$CLASSNAME(condObj)

	s condIter=condObj.%GetIterator()

	s ret=0
	while condIter.%GetNext(.condKey , .condValue ) {
		  q:ret'=0
		  continue:condValue=""
		  s valueType=$CLASSNAME(condValue)
		  i condKey="atom"{

			   i $f(valueType,"DynamicArray")>0{
				   set atomIter = condValue.%GetIterator()
				   while atomIter.%GetNext(.atomKey , .atomValue ) {
					    q:ret'=0
						s ret=##class(web.DHCCKBRuleSave).SaveRuleData(atomValue,node,drugInfo)
						
				   }
			   }else{
				   s ret=##class(web.DHCCKBRuleSave).SaveRuleData(condValue,node,drugInfo)
				  
			   }
		  }else{
			 s newNode=node
			 if (condKey'="and")&&(condKey'="or")&&(condKey'["union"){	// qunianpeng 2020/4/10 增加联合条件  sufan  2020-07-07 由condKey'="union" 改为condKey'["union"
						s newCondKey=condition			 
			 }else{
				 		s:condKey["union" condKey="union"  			//sufan  2020-07-07  增加联合节点的判断
						s newCondKey=condKey	 
			 }
			 
			 i $f(valueType,"DynamicArray")=0{
				 s newNode=##class(web.DHCCKBRuleSave).SaveNode(newCondKey, ruleId, "if",node)
			 }

			 s ret=##class(web.DHCCKBRuleSave).SaveCondition(newCondKey,ruleId,condValue,newNode,drugInfo)
		  }
	   }
	   q ret
}

/// 	  保存操节点
///       condition   | 逻辑关系  	  | and·,or
///       ruleId   	  | 规则组号表id  | CT_CKB_PDSS.Rule
///       action      | 节点类型  	  | if,then,else
///       parent 	  | 父节点id	  | CT_CKB_PDSS.RuleNode
///       ##class(web.DHCCKBRuleSave).SaveNode()
ClassMethod SaveNode(condition, ruleId, action, parent = 0)
{
	  n (condition, ruleId, action,parent)
	  s nodeObj=##class(CT.CKB.PDSS.RuleNode).%New()
	  i +parent'=0 d nodeObj.RNParentSetObjectId(parent)
	  d nodeObj.RNRuleSetObjectId(ruleId)
	  s nodeObj.RNCondition=condition
	  s nodeObj.RNAction=action
	  s sc=nodeObj.%Save()
	  q:$SYSTEM.Status.IsError(sc) -20
	  q nodeObj.%Id()
}

/// 保存到表达式表
/// CT_CKB_PDSS.RuleData
/// 2019-06-19
/// zhouxin
ClassMethod SaveRuleData(atomValue, node, drugInfo = "")
{
	n (atomValue,node,drugInfo)
	
	s ruleId=$lg($g(^CT.CKB.PDSS.RuleNodeD(node)),5)
	s lastRuleData=0
	
  	s left=atomValue.%Get("left")
	s value=atomValue.%Get("value")
	s op=atomValue.%Get("_op")

	s leftType=left.%Get("_type")
  	s rightType=value.%Get("_type")
  	
	s:left.%IsDefined("_ruleData") lastRuleData=+left.%Get("_ruleData")
	s:(value.%IsDefined("_ruleData"))&&(lastRuleData=0) lastRuleData=value.%Get("_ruleData")
	
   	s ruleDataObj=##class(CT.CKB.PDSS.RuleData).%New()
   	s ruleDataObj.RDLeftType=leftType                           //左边类型
   	s ruleDataObj.RDRightType=rightType                         //右边类型
   	s ruleDataObj.RDOp=op		                                //比较运算符(<,>,=)
	d ruleDataObj.RDNodeSetObjectId(node)                       //节点id
	d ruleDataObj.RDRuleSetObjectId(ruleId)
	//表达式左边
	//先取值
   	s varCategoryId=0,var=0,content=""
   	s:left.%IsDefined("_content") content=left.%Get("_content")
   	s:left.%IsDefined("_varCategoryId") varCategoryId=left.%Get("_varCategoryId")
   	s:left.%IsDefined("_var") var=left.%Get("_var")
   	s ruleDataObj.RDLeftValue=content 
   	i var=0 d
   	.d ruleDataObj.RDLeftDicSetObjectId(varCategoryId)  //只存实体字典id
   	e  d
   	.d ruleDataObj.RDLeftDicSetObjectId(var)  //实体属性id 
   	.s ruleDataObj.RDLeftValue=varCategoryId  //存实体类的字典id


   	//表达式右边
    s isVariable=##class(web.DHCCKBRuleBase).CheckVariable(rightType)
   	s isRule=##class(web.DHCCKBRuleBase).CheckRule(rightType)
   	s isConstant=##class(web.DHCCKBRuleBase).CheckConstant(rightType)
   	
   	i (isVariable=1)||(isRule=1) d
   	.d ruleDataObj.RDRightDicSetObjectId(value.%Get("_var"))
   	e  i isConstant=1 d
   	.d ruleDataObj.RDRightDicSetObjectId(value.%Get("_const"))
   	e  d
   	.s ruleDataObj.RDRightValue=value.%Get("_content")
   	.s:value.%IsDefined("_uom") ruleDataObj.RDRightExt=value.%Get("_uom")
   	.s:value.%IsDefined("_limit") ruleDataObj.RDRightLimit=value.%Get("_limit")
   	
   	s ruleDataLevel =""
   	s:value.%IsDefined("_extconstvar") ruleDataLevel=value.%Get("_extconstvar") // 保存规则级别 2022-04-21 qnp
   	i (var'=0)&&(($lg($g(^CT.CKB.PDSS.CommonDictionD(+var)),2)="SolutionProp"))&&(+ruleDataLevel=0) d // 默认管理级别 qnp 2022-09-22 通用名上的规则：溶液默认可配伍， 药品上的规则：溶液默认适宜配伍
   	.s levelCode = "suited"
   	.s drugId=$p(drugInfo,"^",1)
   	.s drugParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
   	.s drugParrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugParref)),2)
   	.i drugParrefCode="GeneralFromData" s levelCode="passable"
   	.s ruleDataLevel = ##class(web.DHCCKBCommon).GetDicIdByCode(levelCode)
   	d ruleDataObj.RDManLevelSetObjectId(ruleDataLevel)
   	
	s sc=ruleDataObj.%Save()
	
	q:$SYSTEM.Status.IsError(sc) -30
	
	
	//保存复杂运算关系
	i left.%IsDefined("complex-arith") d
	.d ##class(web.DHCCKBRuleSave).SaveComplexArith(left.%Get("complex-arith"),ruleDataObj.%Id(),1,0)
	i value.%IsDefined("complex-arith") d
	.d ##class(web.DHCCKBRuleSave).SaveComplexArith(value.%Get("complex-arith"),ruleDataObj.%Id(),2,0)
	s ret=##class(web.DHCCKBRuleLog).SaveDataLog(ruleDataObj.%Id(),lastRuleData,ruleId)

	q:ret<0 ret	
	q 0
}

/// 保存数学运算符
/// 2019-06-19
/// zhouxin
ClassMethod SaveComplexArith(complexJson, ruleData, seq, parref)
{
	
	n (complexJson, ruleData, seq, parref)	
	s symbol=complexJson.%Get("_type")
	
	s arithObj=##class(CKB.PDSS.RuleComplexArith).%New()
	s arithObj.RCASeq=seq
	d arithObj.RCARuleDataSetObjectId(ruleData)
	s arithObj.RCASymbol=symbol
	i +parref'=0 d arithObj.RCAParrefSetObjectId(parref)
	i complexJson.%IsDefined("paren") d
	.s arithObj.RCAQuote=1
	.s parenJson=complexJson.%Get("paren")
	.s valueJson=parenJson.%Get("value")
	e  d
	.s valueJson=complexJson.%Get("value")
	
	s type=valueJson.%Get("_type")
	
	i $SYSTEM.Util.Collation(type,5)="VARIABLE" d
   	.d arithObj.RCADicSetObjectId(valueJson.%Get("_var"))
   	e  d
   	.s arithObj.RCAValue=valueJson.%Get("_content")
	s arithObj.RCAType=type
	s sc=arithObj.%Save()
	
	i valueJson.%IsDefined("complex-arith") d
	.d ##class(web.DHCCKBRuleSave).SaveComplexArith(valueJson.%Get("complex-arith"),ruleData,seq,arithObj.%Id())
}

/// 保存输出
/// 2019-06-21
/// zhouxin
/// w ##class(web.DHCCKBRuleSave).SaveOutAction()
ClassMethod SaveOutAction(action, ruleId, json)
{
	n (action, ruleId, json)
	s ret=0	
	set iter = json.%GetIterator()
	while iter.%GetNext(.key , .value ) {
		  q:ret'=0	
		  s subType=json.%GetTypeOf(key)
		  i "array"=subType{
			set iterSub = value.%GetIterator()
			while iterSub.%GetNext(.keySub , .valueSub ) {
				q:ret'=0
				s ret=##class(web.DHCCKBRuleSave).SaveAction(action, ruleId,key,valueSub)
		  	}	
		  }else{
				s ret=##class(web.DHCCKBRuleSave).SaveAction(action, ruleId,key,value)
		  }
	  
	}
	q ret
}

/// 保存那么和否则
ClassMethod SaveAction(action, ruleId, outType, jsonObj)
{
	
	n (action, ruleId, outType, jsonObj)
	s node=##class(web.DHCCKBRuleSave).SaveNode(outType, ruleId, action, 0)
	
	s leftDic=0,leftType="",leftValue="",rightDic=0,rightType="",rightValue=""
	s lastRuleData=0
	s:jsonObj.%IsDefined("_ruleData") lastRuleData=+jsonObj.%Get("_ruleData")

	
	//等号左边
	s:jsonObj.%IsDefined("_var") leftDic=jsonObj.%Get("_var")
	s:jsonObj.%IsDefined("_type") leftType=jsonObj.%Get("_type")
	s:jsonObj.%IsDefined("_varCategoryId") leftValue=jsonObj.%Get("_varCategoryId")
	//等号的右边
	i jsonObj.%IsDefined("value") d
	.s rightObj=jsonObj.%Get("value")
	.s:rightObj.%IsDefined("_content") rightValue=rightObj.%Get("_content")
	.//数据集的情况
	.s:rightObj.%IsDefined("_type") rightType=rightObj.%Get("_type")
	.s:rightObj.%IsDefined("_const") rightDic=rightObj.%Get("_const")
	.s:(rightObj.%IsDefined("_ruleData"))&&(lastRuleData=0) lastRuleData=+rightObj.%Get("_ruleData")
	
	s obj=##class(CT.CKB.PDSS.RuleData).%New()
	d obj.RDRuleSetObjectId(ruleId)
	d obj.RDNodeSetObjectId(node)
	s obj.RDLeftType=leftType
	s obj.RDLeftValue=leftValue
	i leftDic'=0 d obj.RDLeftDicSetObjectId(leftDic)
	s obj.RDRightValue=rightValue
	s obj.RDRightType=rightType
	i rightDic'=0 d obj.RDRightDicSetObjectId(rightDic)
	
	s sc=obj.%Save()
	q:$SYSTEM.Status.IsError(sc) -4
	
	s logId=##class(web.DHCCKBRuleLog).SaveDataLog(obj.%Id(),lastRuleData,ruleId)
	q 0
}

/// d ##class(web.DHCCKBRuleSave).RemoveRuleAll("68984^207260^293089")
ClassMethod RemoveRuleAll(nodeStr)
{
	n (nodeStr)
	
	f i=1:1:$length(nodeStr,"^") d
	.s ruleId = $p(nodeStr,"^",i)
	.d ..RemoveRule(ruleId)
	
	q 0
}

/// d ##class(web.DHCCKBRuleSave).RemoveRule()
ClassMethod RemoveRule(ruleId)
{
	n (ruleId)
	&sql(delete from CT_CKB_PDSS.RuleData where RD_Rule=:ruleId)
	&sql(delete from CT_CKB_PDSS.RuleDic where RD_Rule=:ruleId)
	&sql(delete from CT_CKB_PDSS.Rule where R_RowId=:ruleId)
	&sql(delete from CT_CKB_PDSS.RuleNode where RN_Rule=:ruleId)
	
	//  删除规则时需要删除药品->目录->规则关系 2022-03-30 qnp
	d ##class(web.DHCCKBConfig).DeleteDrugLibaryRefByRule(ruleId)
	q SQLCODE
}

/// Description:	批量发布/取消发布
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-22
/// Input:			规则序号字符串,登录信息,操作(Release:批量发布,CancelRelease:批量取消发布)
/// return:			0 成功 -1 失败
/// d ##class(web.DHCCKBRuleSave).ReleaseStatus("68059^96063","11863^8^1^291^2","Release")
ClassMethod ReleaseStatus(ruleIdStr, loginInfo, status)
{
	n (ruleIdStr,loginInfo,status)

	s ret=-1
	s userId = $p(loginInfo,"^",1)
	s count=0	
	TS
	
	f k=1:1:$length(ruleIdStr,"^") 	d
	.s ruleId = $p(ruleIdStr,"^",k)
	.// 修改规则主表状态 CT.CKB.PDSS.Rule 
	.s ret = ..UpdateRuleStatus(ruleId,status)
	.q:ret'=0
	.// save CKB_PDSS.RuleLog (规则主表日志)
	.s log=##class(web.DHCCKBRuleLog).SaveLog(ruleId,userId,loginInfo)
	.s count = count + 1
	
	i count'=0 s ret=0
	
	i ret=-1 tro
	e  tc 
		
	q ret
}

/// Description:	更新规则状态
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-22
/// Input:			规则序号id,操作(Release:批量发布,CancelRelease:批量取消发布)
/// return:			0 成功  -1 失败
ClassMethod UpdateRuleStatus(ruleId, status)
{
	n (ruleId,status)
	
	s ret = -1
	s oldStatus = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)
	q:oldStatus=status ret
	q:(oldStatus="CancelRelease")&(status'="Release") ret
	q:(oldStatus="Release")&(status'="CancelRelease") ret
	&sql(update CT_CKB_PDSS.Rule set R_Status=:status where R_RowId=:ruleId)
	s ret=SQLCODE
	
	q ret
}

/// Description:	发布/取消发布
/// Creator:		QuNianpeng 
/// CreateDate:		2021-3-24
/// Input:			规则id,登录信息,操作(Release:批量发布,CancelRelease:批量取消发布)
/// return:			规则id 成功 -1 失败
/// d ##class(web.DHCCKBRuleSave).ReleaseStatusAlone("68059","11863^8^1^291^2","Release")
ClassMethod ReleaseStatusAlone(ruleId, loginInfo, status)
{
	n (ruleId,loginInfo,status)

	s ret=-1
	s userId = $p(loginInfo,"^",1)

	// 修改规则主表状态 CT.CKB.PDSS.Rule 
	s ret = ..UpdateRuleStatus(ruleId,status)
	q:ret'=0 -1
	// save CKB_PDSS.RuleLog (规则主表日志)
	s log=##class(web.DHCCKBRuleLog).SaveLog(ruleId,userId,loginInfo)
	
	q log
}

/// Description:	作废规则
/// Creator:		QuNianpeng 
/// CreateDate:		2022-11-30
/// Input:			规则id,登录信息,操作(Stop作废)
/// return:			规则id 成功 -1 失败
/// d ##class(web.DHCCKBRuleSave)StopRule("68059","Release""Release""11863^8^1^291^2")
ClassMethod StopRule(ruleId, status, loginInfo)
{
	n (ruleId,status,loginInfo)

	s ret=0
	s userId = $p(loginInfo,"^",1)

	// 修改规则主表状态 CT.CKB.PDSS.Rule 
	s ret = ..StopRuleStatus(ruleId,status)
	q:ret'=0 -1
	
	// save CKB_PDSS.RuleLog (规则主表日志)
	s log=##class(web.DHCCKBRuleLog).SaveLog(ruleId,userId,loginInfo)
	
	q log
}

/// Description:	作废规则
/// Creator:		QuNianpeng 
/// CreateDate:		2022-11-30
/// Input:			规则序号id,操作(Stop作废)
/// return:			0 成功  -1 失败
ClassMethod StopRuleStatus(ruleId, status)
{
	n (ruleId,status)
	
	s ret = -1
	s oldStatus = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)
	q:oldStatus=status ret
	&sql(update CT_CKB_PDSS.Rule set R_Status=:status where R_RowId=:ruleId)
	s ret=SQLCODE
	
	q ret
}

}
