Import sqluser

Class web.DHCCKBDrugDetail Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:	获取知识目录tree
/// Creator:		xiaowenwu 
/// CreateDate:		2020-01-15	
/// Input:			dic:药品的ID,rule:规则id,levels(核对界面：管理级别),useFlag:区分调用方(check:规则核对界面)
/// Other:			w ##class(web.DHCCKBDrugDetail).GetDrugLibraryTree("142",0,"禁止","check","","")
ClassMethod GetDrugLibraryTree(dic, rule = 0, levels = "", useFlag = "", input = "", catID = "")
{
	n (dic,rule,levels,useFlag,input,catID)
	w ##class(web.DHCCKBDrugDetail).GetDrugLibrary(dic,+rule,levels,useFlag,input,catID).%ToJSON()
	q ""
}

/// Description:	获取知识目录tree
/// Creator:		xiaowenwu 
/// CreateDate:		2020-01-15	
/// Input:			dic:药品的ID
/// Other:			w ##class(web.DHCCKBDrugDetail).GetDrugLibrary(373).%ToJSON()
ClassMethod GetDrugLibrary(dicId = 0, rule = 0, levels = "", useFlag, input = "", catID = "")
{
	
	n (dicId,rule,levels,useFlag,input,catID)

	s DrugLibrarys=[]
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,id)) q:id=""  d
	.q:+id=0	
	.s Drugdate=##class(web.DHCCKBDrugDetail).GetDrugDate(dicId,id)
	.q:Drugdate=""
	.s DrugLibrary={}
	.s DrugLibrary.id=id
	.q:(catID'="")&&(catID'=id)  //只显示的选择规则目录
	.s DrugLibrary.text=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.i +dicId'=0 d
	..s DrugLibrary.relation=dicId
	..//查找有的规则
	..d DrugLibrary.%Set("children",##class(web.DHCCKBDrugDetail).GetRuleByDic(dicId,id,rule,levels,useFlag,input))
	.d DrugLibrarys.%Push(DrugLibrary)
	q DrugLibrarys
}

/// 判断该目录下是否有药品的输出信息
/// w ##class(web.DHCCKBDrugDetail).GetDrugDate(21)
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

/// w ##class(web.DHCCKBDrugDetail).GetRuleByDic("142","69","0","禁止","check","").%ToJSON()
ClassMethod GetRuleByDic(dic, relation = 0, rule = 0, levels = "", useFlag, input = "")
{
	n (dic,relation,rule,levels,useFlag,input)
	s WarnMessage=##class(web.DHCCKBCommon).GetWarnMessageProp() //Descript:药品输出->提示信息属性id
	s LevelProp=##class(web.DHCCKBCommon).GetLevelFlagProp()	// 管理级别属性
	s retArr=[]
	
	s img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	s accimg = "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>"
	
	i +dic'=0 d
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDicI("Dic",dic,id)) q:id=""  d
	..s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(id)),2)
	..q:'$d(^CT.CKB.PDSS.RuleD(ruleId))
	..Q:($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)'="Release")
	..s edit=""
	..i (useFlag="check")&(1=##class(web.DHCCKBCheckRule).IsEditRule(ruleId))	s edit=img // 规则核对界面增加标记 qnp 2020/09/16
	..s warnLevelDesc="",warnLevel="",warnID="",msgID="",realstatus="",outDesc=""
	..i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,relation)) d
	...q:'$d(^CT.CKB.PDSS.RuleD(ruleId))
	...s action=""
	...f  s action=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action)) q:action=""  d
	....s parendid=""
	....f  s parendid=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action,parendid)) q:parendid=""  d
	.....s rnrowid=""
	.....f  s rnrowid=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action,parendid,rnrowid)) q:rnrowid=""  d //CT_CKB_PDSS.RuleData表的RdNode
	......s rdRowID=""
	......f  s rdRowID=$o(^CT.CKB.PDSS.RuleDataI("Node",rnrowid,rdRowID)) q:rdRowID=""  d //CT_CKB_PDSS.RuleData表的RowID
	.......s rdLeftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),4)	//表达式左边字典(CT_CKB_PDSS.RuleData表中)
	.......i rdLeftDic=LevelProp d
	........s warnLevel=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),8),warnID=rdRowID	
	........i +warnLevel'=0 s warnLevelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+warnLevel)),3)
	.......
	.......i rdLeftDic=WarnMessage d
	........s outDesc=$lg($g(^CT.CKB.PDSS.RuleDataD(rdRowID)),9)	//药品输出的提示信息
	........s msgID=rdRowID
	..
	..q:warnLevelDesc=""
	..q:(levels'="")&&(levels'[warnLevelDesc)
	..s warnLevelDesc="【"_warnLevelDesc_"】"	// qnp 2020/09/16 增加级别
	..s conFlag=..getRuleSigns(ruleId)			//sufan 2020-11-05
	..s:(($lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)="Release")&&(conFlag=1)) realstatus = accimg
	..q:(input'="")&&(input'="儿童")&&(##class(web.DHCCKBSearchDrugByRule).getRuleAc(ruleId,input)=0) //过滤查询条件  
	..q:(input="儿童")&&(##class(web.DHCCKBSearchDrugByRule).getChildrenRuleAc(ruleId,input)=0) //过滤儿童查询条件  
	..s ruleJson={}
	..d ruleJson.%Set("id",ruleId)
	..d ruleJson.%Set("ruleId",ruleId)
	..d ruleJson.%Set("text",realstatus_edit_warnLevelDesc_"("_ruleId_")"_outDesc) 
	..d ruleJson.%Set("content",outDesc) 
	..d ruleJson.%Set("warnID",warnID) 	// 增加级别对应的规则明细id和消息对应规则明细id qnp 2021/3/24
	..d ruleJson.%Set("msgID",msgID) 
	..d retArr.%Push(ruleJson)	
	q retArr
}

/// Description:	关闭规则
/// Creator:		qunianpeng 
/// CreateDate:		2020-02-20	
/// Input:			dic:药品的ID
/// return:			
/// other:			w ##class(web.DHCCKBDrugDetail).CloseRule("42971","1","CancelRelease")
/// w ##class(web.DHCCKBDrugDetail).CloseRule("61462^61463","1","CancelRelease")
ClassMethod CloseRule(ruleStr, userId, status)
{
	n (ruleStr,userId,status)
	
	s ret=0
	TS
	s len=$length(ruleStr,"^")
	f i=1:1:len  q:ret'=0  d 
	.s ruleId=$p(ruleStr,"^",i)
	.///save CKB.PDSS.RuleLog (规则主表日志)
	.s logId=+$o(^CKB.PDSS.RuleLogI("Rule",ruleId,""),-1)
	.s logObj=##class(CKB.PDSS.RuleLog).%New()
	.s logObj.RLName=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)
	.s logObj.RLRemark=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2)
	.d logObj.RLRuleSetObjectId(ruleId)
	.s logObj.RLType=status
	.s logObj.RLLastLog=logId
	.i +userId'=0 d logObj.RLUserSetObjectId(userId)
	.s sc=logObj.%Save()
	.s:$SYSTEM.Status.IsError(sc) ret=-10
	.q:$SYSTEM.Status.IsError(sc)
	.//q logObj.%Id()
	.	
	.// 修改规则组号
	.s ruleObj=##class(CT.CKB.PDSS.Rule).%OpenId(ruleId)
	.s ruleObj.RStatus=status
	.s sc=ruleObj.%Save()
	.s:$SYSTEM.Status.IsError(sc) ret=-10
	.q:$SYSTEM.Status.IsError(sc)
	.//q ruleObj.%Id()
	
	i ret'=0 tro
	q:ret'=0 ret
	
	TC
	q ret
}

/// Description:	复制规则
/// Creator:		qunianpeng 
/// CreateDate:		2020-03-12	
/// Input:			dic:药品的ID, userInfo:医生^科室^安全组^医院
/// return:			
/// other:			w ##class(web.DHCCKBDrugDetail).CopyDrugRule("24451","11871^8^1^289^2","113.140.81.66")
ClassMethod CopyDrugRule(dicStr, userInfo, clientIP)
{
	n (dicStr,userInfo,clientIP)
	

	s userId=$p(userInfo,"^",1)
	s hospitalID=$p(userInfo,"^",5)
	set $ZT="ERROR" // 设置一个异常
	
	Ts
	s ret=0
	
	s len=$length(dicStr,"&&")
	f i=1:1:len  q:ret'=0  d
	.s dicID=$p(dicStr,"&&",i)
	.s:dicID="" err=1
	.q:dicID=""
	.// 先插入一条药品
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.s:(code="")||(desc="") ret=-1
	.q:ret'=0
	.s code = $replace(code,"（","(")   //sufan 转换括号
	.s code = $replace(code,"）",")")
	.s desc = $replace(desc,"（","(")
	.s desc = $replace(desc,"）",")")
	.s code=code_"(复制)"
	.s desc=desc_"(复制)"
	.s newDicID=##class(web.DHCCKBCommon).GetDicIdByCode(code) //##class(web.DHCCKBDiction).CheckDictionRepeat("",newDicCode,newDicDesc,parref)
	.i newDicID=0 d // 不存在
	..s dicList="^"_code_"^"_desc_"^"_parref
	..s newDicID=##class(web.DHCCKBDiction).SaveUpdate(dicList,"")	
	..i newDicID<=0 s ret=-1
	..q:ret'=0
	..// 插入日志
	..s ret=..SaveDicLog(newDicID,userId,hospitalID,clientIP)
	..q:ret'=0
	..s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",newDicID,"grantAuth", userId, "", "", "D", hospitalID, clientIP,"acc")
	.q:ret'=0
	.q:newDicID=0
	.// 保存规则
	.s ret=..SaveRule(dicID, newDicID, userId,userInfo)
	.q:ret'=0

	i ret'=0 tro
	e  tc
		
	q ret	
	
ERROR
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	q -1_"^"_ErrorMsg
}

/// Desc:		保存字典日志
/// Creator：   qunianpeng
/// CreatDate： 2020-03-13
ClassMethod SaveDicLog(dicID, LgUserID, LgHospitalID, clientIP)
{
	//表ID 记录ID 功能 操作人 操作日期 作用域 作用域值
	
	n (dicID,LgUserID,LgHospitalID,clientIP)
	q:+dicID=0
	s DicDr="DHC_CKBCommonDiction"
	s DataId=dicID
	s Function="add"
	s Operator=LgUserID
	s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	s Scope=""
	s ScopeValue="" //LgHospitalID
	
	&SQL(INSERT INTO CKB_PDSS.DicLog VALUES (:DicDr,:DataId,:Function,:Operator,:OperateDate,:OperateTime,:Scope,:ScopeValue,:clientIP))

    Quit SQLCODE
}

/// Desc:		保存规则
/// Creator：   qunianpeng
/// CreatDate： 2020-03-13
ClassMethod SaveRule(dicID, newDicID, LgUserId, userInfo)
{
	n (dicID,newDicID,LgUserId,userInfo)
	
	// 遍历所有的规则,插入规则表,日志表
	s err=0
	s ruleDicID=""
	f   s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))	q:(ruleDicID="")||(err=1)  d
	.s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	.q:rule=""	
	.///save CT_CKB_PDSS.Rule (规则主表)
	.s ruleName = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),3)
	.s:ruleName="" ruleName="rule"
	.s remark= "复制规则"_$lg($g(^CT.CKB.PDSS.RuleD(+rule)),2)
	.s newRuleId=0,status=""
	.s newRuleId=##class(web.DHCCKBRuleSave).SaveRule(newRuleId,ruleName,remark,status,userInfo)
	.if newRuleId<0 s err=1
	.q:err=1
	.///save CKB.PDSS.RuleLog (规则主表日志)
	.s log=##class(web.DHCCKBRuleLog).SaveLog(newRuleId,LgUserId,userInfo)
	.if log<0 s err=1
	.q:err=1
	.///save CT_CKB_PDSS.RuleDic (规则目录)
	.s dicStr=..GetRuleLabel(rule,dicID)
	.s:dicStr'="" dicStr=newDicID_"^"_dicStr
	.s err=##class(web.DHCCKBRuleDic).SaveRuleDic(newRuleId,dicStr)
	.if err'=0 s err=1
	.q:err=1
	.///save if	(CT_CKB_PDSS.RuleData)(CT_CKB_PDSS.RuleNode)
	.k TmpArr
	.s err=..SaveNode(rule, newRuleId, "if",0,"",.TmpArr)	
	.q:err=1
	.///save then (CT_CKB_PDSS.RuleData)
	.k TmpArr
	.s err=..SaveNode(rule, newRuleId, "then",0,"",.TmpArr)	
	.q:err=1
	.///save else (CT_CKB_PDSS.RuleData)
	.k TmpArr
	.s err=..SaveNode(rule, newRuleId, "else",0,"",.TmpArr)	
	.q:err=1
	.///save CKB.PDSS.RuleDataLog (removed data)
	.s ret=##class(web.DHCCKBRuleLog).SaveRemoveDataLog(log)
	.if ret<0  s err=1
	.q:err=1
	.i +newRuleId'=0  d // 生成药品->目录->规则关系 2022-03-30 qnp
	..d ##class(web.DHCCKBConfig).SetDrugLibaryRefByRule(newRuleId)

	q err
}

/// Desc:		获取规则目录
/// Creator：   qunianpeng
/// CreatDate： 2020-03-13
ClassMethod GetRuleLabel(rule, dicID)
{
	n (rule,dicID)
	
	s str=""
	s tmpDicID=""
	f  s tmpDicID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,tmpDicID))	q:(tmpDicID="")  d
	.q:tmpDicID=""
	.q:tmpDicID=dicID
	.i str=""  s str=tmpDicID
	.e  s str=str_"^"_tmpDicID
	
	q str
}

/// Desc:		保存节点
/// Creator：   qunianpeng
/// CreatDate： 2020-03-13
ClassMethod SaveNode(rule, newRuleId, action, parent, newParent, TmpArr)
{
	n (rule,newRuleId, action,parent,newParent,TmpArr)
	
	s err=0
	q:'$d(^CT.CKB.PDSS.RuleNodeI("Parent",rule,action,parent)) 0 
	
	s rowid=""
	f  s rowid=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,action,parent,rowid))	q:(rowid="")||(err=1)  d
	.s condition=$lg($g(^CT.CKB.PDSS.RuleNodeD(rowid)),3)
	.i $d(TmpArr(+parent)) s newParent = $o(TmpArr(+parent,""))
	.s newnode=##class(web.DHCCKBRuleSave).SaveNode(condition, newRuleId, action, newParent)	// 保存节点的同时，需要保存规则
	.s TmpArr(rowid,newnode)=""
	.i newnode<0 s err=1
	.q:newnode<0
	.s err=..SaveRuleData(rowid,newnode,newRuleId)
	.q:err=1
	.i $d(^CT.CKB.PDSS.RuleNodeI("Parent",rule,action,rowid)) d
	..s newParent=newnode
	..s err=..SaveNode(rule, newRuleId, action,rowid,newParent,.TmpArr)

	q err
}

/// Desc:		保存规则
/// Creator：   qunianpeng
/// CreatDate： 2020-03-13
ClassMethod SaveRuleData(node, newnode, newrule)
{
	n (node,newnode,newrule)

	s err=0
	s ruleDataID=""
	f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,ruleDataID))	q:(ruleDataID="")||(err=1)  d
	.s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	.k oldDataObj,newDataObj
	.s oldDataObj=##class(CT.CKB.PDSS.RuleData).%OpenId(ruleDataID)
	.s newDataObj=##class(CT.CKB.PDSS.RuleData).%New()
   	.d newDataObj.RDLeftDicSetObjectId(oldDataObj.RDLeftDic.%Id())
   	.s newDataObj.RDLeftValue=oldDataObj.RDLeftValue
   	.s newDataObj.RDLeftType=oldDataObj.RDLeftType
   	.s newDataObj.RDOp=oldDataObj.RDOp
   	.d newDataObj.RDRightDicSetObjectId(rightDic)
   	.s newDataObj.RDRightValue=oldDataObj.RDRightValue
   	.s newDataObj.RDRightType=oldDataObj.RDRightType
   	.s newDataObj.RDRightExt=oldDataObj.RDRightExt
   	.s newDataObj.RDRightLimit=oldDataObj.RDRightLimit
   	.d newDataObj.RDNodeSetObjectId(newnode)
   	.d newDataObj.RDRuleSetObjectId(newrule)
   	.d newDataObj.RDManLevelSetObjectId($case(oldDataObj.RDManLevel'="",1:oldDataObj.RDManLevel.%Id(),:""))   	
   	.s sc=newDataObj.%Save()
   	
   	.i $SYSTEM.Status.IsError(sc) s err=1
   	.q:err=1
	.d newDataObj.%Close()
	.d oldDataObj.%Close()
	.s lastRuleData=0
	.s ret=##class(web.DHCCKBRuleLog).SaveDataLog(newDataObj.%Id(),lastRuleData,newrule)
	.i ret<0 s err=1
		
	q err
}

/// Description:	存储选择的属性
/// Creator:		qunianpeng 
/// CreateDate:		2020-04-20	
/// Input:			dicStr:药品的ID串,propListID串
/// Other:			w ##class(web.DHCCKBDrugDetail).SaveDicLinkProp("150","38^39")
/// w ##class(web.DHCCKBDrugDetail).SaveDicLinkProp("112511","81818^81819^81820^81821^81822^81824^81825^81826^81827^81828^81829^81830^81831^81832^81833^81834^81835^81836^81837^81842^81955^81956^81957^81958^81959^81960^81961^81962^81963^81965^81966^81967^81968^81969^81970^81971^81976^82164^90971^90975^96688^96689^96690^96691^96693^96694^96696^96697^96699^96700^96701^96703^96704^97891^106662^111066^111074^111633^111634")
ClassMethod SaveDicLinkProp(dicStr, propList)
{
	
	n (dicStr,propList)

	s num=0
	s len=$length(dicStr,"^")
	f index=1:1:len  d
	.s dicID=$p(dicStr,"^",index)
	.q:+dicID=0
	.s propLen=$length(propList,"^")
	.f indexProp=1:1:propLen  d
	..s prop=$p(propList,"^",indexProp)
	..q:prop=""
	..s ^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",dicID,prop)=""	// 使用临时global存储实体选择要复制的属性
	..s num=num+1	
	..s listData = ..GetLinkTempProp(prop)
	..f i=1:1:$listlength(listData)  d
	...s tmpProp = $list(listData,i)
	...q:tmpProp=""
	...s ^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",dicID,tmpProp)=""	// 使用临时global存储实体选择要复制的属性
	...s num=num+1
	..s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(prop)),5)
	..q:linkDr=""
	..s listData = ..GetLinkTempProp(linkDr)
	..f i=1:1:$listlength(listData)  d
	...s tmpProp = $list(listData,i)
	...q:tmpProp=""
	...s ^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",dicID,tmpProp)=""	// 使用临时global存储实体选择要复制的属性
	...s num=num+1
		
	q:num>0 1
	
	q num
}

/// Description:	查询药品选择的属性
/// Creator:		qunianpeng 
/// CreateDate:		2020-04-20	
/// Input:			dicStr:药品的ID串,propListID串
/// Other:			w ##class(web.DHCCKBDrugDetail).QueryDicLinkProp("150")
ClassMethod QueryDicLinkProp(dicID)
{
	n (dicID)
	
	s title="propID^propCode^propDesc"
	
	w "["
	s count=0
	s propID=""
	f  s propID=$o(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,propID))  q:propID=""  d
	.s propCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+propID)),2)
	.s propDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+propID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+propID)),5)
	.i +linkDr'=0 d
	..s propCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),2)
	..s propDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.s listData=propID_"^"_propCode_"^"_propDesc
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,listData)
	w "]"
	q ""
}

/// Description:	移除药品选择的属性
/// Creator:		qunianpeng 
/// CreateDate:		2020-04-20	
/// Input:			dicStr:药品的ID串,propListID串
/// Other:			w ##class(web.DHCCKBDrugDetail).QueryDicLinkProp("150")
ClassMethod DelDicLinkProp(dicID, propList)
{
	
	n (dicID,propList)

	s dicID=+dicID
	
	s len=$length(propList,"^")
	f index=1:1:len  d
	.s propID=$p(propList,"^",index)
	.q:'$d(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,+propID))
	.k ^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,+propID)
	
	
	q 1
}

/// Description:	查询药品选择的属性
/// Creator:		qunianpeng 
/// CreateDate:		2020-04-20	
/// Input:			dicStr:药品的ID串,propListID串
/// Other:			w ##class(web.DHCCKBDrugDetail).CopyPropValue("145","11863^8^1^291^2","127.0.0.1")
ClassMethod CopyPropValue(dicStr, userInfo, clientIP)
{
	n (dicStr,userInfo,clientIP)
	s userId=$p(userInfo,"^",1)
	s hospitalID=$p(userInfo,"^",5)
	//s $ZT="ERRORMSG"
	Ts
	s len=$length(dicStr)
	s existFlag=0
	f index=1:1:len  q:existFlag=1  d
	.s dicID=$p(dicStr,"^",index)
	.q:+dicID=0
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.q:(dicCode="")||(dicDesc="")
	.s dicCode = $replace(dicCode,"（","(")   //sufan 转换括号
	.s dicCode = $replace(dicCode,"）",")")
	.s dicDesc = $replace(dicDesc,"（","(")
	.s dicDesc = $replace(dicDesc,"）",")")
	.//s newDicCode=dicCode_"(复制)"
	.s newDicCode=##class(web.DHCCKBDiction).GetSysCodeByType(parref,dicCode_"(复制)")  // 根据parref判断是否需要自动生成编码(字典数据需要生成编码) qnp 20230509
	.s newDicDesc=dicDesc_"(复制)"	
	.s newDicID=""
	.s newDicID=##class(web.DHCCKBCommon).GetDicIdByDesc(newDicDesc) //##class(web.DHCCKBDiction).CheckDictionRepeat("",newDicCode,newDicDesc,parref)
	.i newDicID=0 d // 不存在
	..s dicList="^"_newDicCode_"^"_newDicDesc_"^"_parref
	..s ret=##class(web.DHCCKBDiction).SaveUpdate(dicList,"")
	..i ret<=0 s existFlag=1
	..q:ret<=0
	..s newDicID=ret
	..// 插入日志
	..s ret=..SaveDicLog(ret,userId,hospitalID,clientIP)
	..i ret'=0 s existFlag=1
	..q:ret'=0
	..// 授权
	..s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction",newDicID,"grantAuth", userId, "", "", "D", hospitalID, clientIP,"acc")
	..i ret'=0 s existFlag=1
	..q:ret'=0
	.
	.q:newDicID=""
	.// 复制属性值
	.s ret=..CopyValue(dicID,newDicID)
	.i ret=0 s existFlag=1
		
	i existFlag=1 tro
	e  tc
	
	q existFlag
	

ERRORMSG
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	
	q 1
}

/// Description:	复制具体的属性值
/// Creator:		qunianpeng 
/// CreateDate:		2020-04-20	
/// Input:			dicID原字典id,newDicID新字典id
/// Other:			w ##class(web.DHCCKBDrugDetail).CopyValue("24451","81646")
ClassMethod CopyValueN(dicID, newDicID)
{
	n (dicID,newDicID)
	
	s exitFlag=1
	s propID=""
	f  s propID=$o(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,propID))  q:(propID="")||(exitFlag=0)  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,propID))
	.s linkID=""
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,+propID,linkID))  q:(linkID="")||(exitFlag=0)  d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	..s result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),5)
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),6)
	..&SQL(INSERT INTO CT_CKB_PDSS.DicLinkAttr VALUES (:newDicID,:propID,:attrDr,:result,:group,""))
	..i SQLCODE'=0 s exitFlag=0
	..//s existFlag=..SavePropLinkPropValue(dicID,newDicID,propID) // 将属性的属性加入到了模板的选择中了,屏蔽次数 qnp 201/1/27
	q exitFlag
}

/// Description:	复制具体的属性值
/// Creator:		Sunhuiyong
/// Input:			dicID原字典id,newDicID新字典id
/// Other:			w ##class(web.DHCCKBDrugDetail).CopyValue("123450","126756")
ClassMethod CopyValue(dicID, newDicID)
{
	n (dicID,newDicID)
	
	s dataType=##class(web.DHCCKBCommon).GetDataType()
	s textArea=##class(web.DHCCKBCommon).GetTextArea()  //文本域
	s combobox=##class(web.DHCCKBCommon).GetCombobox()  //下拉框
	s exitFlag=1
	s propID=""
	f  s propID=$o(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,propID))  q:(propID="")||(exitFlag=0)  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,propID))
	.s linkID=""
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,+propID,linkID))  q:(linkID="")||(exitFlag=0)  d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	..s result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),5)
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),6)
	..s propDataTypeId=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,dataType))  d
	...s id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,dataType,""))
	...s propDataTypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(id)),4) 
	..i ($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+newDicID,+propID)))&&((propDataTypeId'="")&&((propDataTypeId=textArea)&&(propDataTypeId=combobox))&&(group=""))  d
	...&SQL(UPDATE CT_CKB_PDSS.DicLinkAttr SET DLA_Attr_Dr=:attrDr,DLA_Result=:result,DLA_GroupFlag=:group  WHERE DLA_Dic_Dr=:newDicID AND DLA_AttrCode=:propID)
	..e  d
	...&SQL(INSERT INTO CT_CKB_PDSS.DicLinkAttr VALUES (:newDicID,:propID,:attrDr,:result,:group,""))
	..i SQLCODE'=0 s exitFlag=0
	..//s existFlag=..SavePropLinkPropValue(dicID,newDicID,propID) // 将属性的属性加入到了模板的选择中了,屏蔽次数 qnp 201/1/27
	q exitFlag
}

/// Description:	复制具体的属性值
/// Creator:		Sunhuiyong
/// Input:			dicID原字典id,newDicID新字典id
/// Other:			w ##class(web.DHCCKBDrugDetail).CopyValue2("127727","129322")
ClassMethod CopyValue2(dicID, newDicID)
{
	n (dicID,newDicID)
	s dataType=##class(web.DHCCKBCommon).GetDataSource() ;##class(web.DHCCKBCommon).GetDataType()
	s textArea=##class(web.DHCCKBCommon).GetTextArea()  //文本域
	s combobox=##class(web.DHCCKBCommon).GetCombobox()  //下拉框
	s exitFlag=1
	s propID=""
	f  s propID=$o(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,propID))  q:(propID="")||(exitFlag=0)  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,propID))
	.s linkID=""
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,+propID,linkID))  q:(linkID="")||(exitFlag=0)  d
	..q:propID'=81976
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	..s result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),5)
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),6)
	..s propDataTypeId="",id=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,dataType))  d
	...s id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,dataType,""))
	...;s propDataTypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(id)),4) 
	..b ;err
	..i ($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+newDicID,+propID)))&&((id="")&&(group="")) d     ;&&((propDataTypeId'="")&&((propDataTypeId=textArea)&&(propDataTypeId=combobox))&&(group=""))  d
	...b ;1
	...&SQL(UPDATE CT_CKB_PDSS.DicLinkAttr SET DLA_Attr_Dr=:attrDr,DLA_Result=:result,DLA_GroupFlag=:group  WHERE DLA_Dic_Dr=:newDicID AND DLA_AttrCode=:propID)
	..e  d
	...b ;2
	...&SQL(INSERT INTO CT_CKB_PDSS.DicLinkAttr VALUES (:newDicID,:propID,:attrDr,:result,:group,""))
	..i SQLCODE'=0 s exitFlag=0
	..//s existFlag=..SavePropLinkPropValue(dicID,newDicID,propID) // 将属性的属性加入到了模板的选择中了,屏蔽次数 qnp 201/1/27
	q exitFlag
}

/// Description:	复制具体的属性值
/// Creator:		Sunhuiyong
/// Input:			dicID原字典id,newDicID新字典id
/// Other:			w ##class(web.DHCCKBDrugDetail).CopyValueTest("127727","129322")
ClassMethod CopyValueTest(dicID, newDicID)
{
	n (dicID,newDicID)
	s dataType=##class(web.DHCCKBCommon).GetDataType()
	s textArea=##class(web.DHCCKBCommon).GetTextArea()  //文本域
	s combobox=##class(web.DHCCKBCommon).GetCombobox()  //下拉框
	s exitFlag=1
	s propID=""
	f  s propID=$o(^DHCCKBTempDicLinkProp("DHCCKB","web.DHCCKBDrugDetail","Temp",+dicID,propID))  q:(propID="")||(exitFlag=0)  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,propID))
	.s linkID=""
	.f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,+propID,linkID))  q:(linkID="")||(exitFlag=0)  d
	..q:propID'=81976
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	..s result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),5)
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),6)
	..s propDataTypeId="",id=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,28))  d
	...s id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+propID,28,""))
	...s propDataTypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(id)),4) 
	..b:propID=81832 ;err
	..i ($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+newDicID,+propID)))&&((id="")&&(group=""))  d
	...w "update"
	..e  d
	...w "insert"
	..;i SQLCODE'=0 s exitFlag=0
	..//s existFlag=..SavePropLinkPropValue(dicID,newDicID,propID) // 将属性的属性加入到了模板的选择中了,屏蔽次数 qnp 201/1/27
	q exitFlag
}

/// Description:	复制属性的属性值
/// Creator:		qunianpeng 
/// CreateDate:		2020-05-14	
/// Input:			dicID原字典id,newDicID新字典id
/// Other:			w ##class(web.DHCCKBDrugDetail)CopyValue("150")
ClassMethod SavePropLinkPropValue(dicID, newDicID, propID)
{
	n (dicID,newDicID,propID)
	
	s linkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",propID,linkPropId)) 1

	s exitFlag=1
	s linkPropValue=""
	f  s linkPropValue=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",propID,linkPropId,linkPropValue))  q:(linkPropValue="")||(exitFlag=0)  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+linkPropValue))
	.q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",+linkPropValue))
	.s subPropID=""
	.f  s subPropID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",+linkPropValue,subPropID)) q:(subPropID="")||(exitFlag=0)  d
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,+subPropID))
	..s linkID=""
	..f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicID,+subPropID,linkID))  q:(linkID="")||(exitFlag=0)  d
	...s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	...s result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),5)
	...s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),6)
	...&SQL(INSERT INTO CT_CKB_PDSS.DicLinkAttr VALUES (:newDicID,:subPropID,:attrDr,:result,:group,""))
	...i SQLCODE'=0 s exitFlag=0

	q exitFlag
}

/// Desc:		保存指定规则
/// Creator：   qunianpeng	  -Sunhuiyong
/// CreatDate： 2020-03-13     2020-11-16
ClassMethod SaveSingleRule(dicID, newDicID, LgUserId, userInfo, rule)
{
	n (dicID,newDicID,LgUserId,userInfo,rule)
	
	// 
	s err=0
	q:rule="" "-11"    //未指定复制规则
	
	TS	
	///save CT_CKB_PDSS.Rule (规则主表)
	s newRuleId=0,remark="复制规则",ruleName="rule",status=""
	s newRuleId=##class(web.DHCCKBRuleSave).SaveRule(newRuleId,ruleName,remark,status)
	if newRuleId<0 s err=1
	tro:err=1
	q:err=1 "-12"
	///save CKB.PDSS.RuleLog (规则主表日志)
	s log=##class(web.DHCCKBRuleLog).SaveLog(newRuleId,LgUserId,userInfo)
	if log<0 s err=1
	tro:err=1
	q:err=1 "-13"
	///save CT_CKB_PDSS.RuleDic (规则目录)
	s dicStr=..GetRuleLabel(rule,dicID)
	s:dicStr'="" dicStr=newDicID_"^"_dicStr
	s err=##class(web.DHCCKBRuleDic).SaveRuleDic(newRuleId,dicStr)
	if err'=0 s err=1
	tro:err=1
	q:err=1 "-14"
	///save if	(CT_CKB_PDSS.RuleData)(CT_CKB_PDSS.RuleNode)
	s err=..SaveNode(rule, newRuleId, "if",0,"")
	tro:err=1	
	q:err=1 "-15"
	///save then (CT_CKB_PDSS.RuleData)
	s err=..SaveNode(rule, newRuleId, "then",0,"")
	tro:err=1	
	q:err=1 "-16"
	///save else (CT_CKB_PDSS.RuleData)
	s err=..SaveNode(rule, newRuleId, "else",0,"")
	tro:err=1	
	q:err=1 "-17"
	///save CKB.PDSS.RuleDataLog (removed data)
	s ret=##class(web.DHCCKBRuleLog).SaveRemoveDataLog(log)
	if ret<0  s err=1
	tro:err=1
	q:err=1 "-18"
	
	TC
	q err
}

/// Desc:		保存选中规则
/// Creator：   qunianpeng	  -Sunhuiyong
/// CreatDate： 2020-03-13     2020-12-14
/// w ##class(web.DHCCKBDrugDetail).SaveSingleRules("128968","128968","11871","11871^1^8^289^2","329216","11871^8^1^289^2")
ClassMethod SaveSingleRules(dicID, newDicStr, LgUserId, userInfo, rulestr, loginInfo)
{
	n (dicID,newDicStr,LgUserId,userInfo,rulestr,loginInfo)
	
	s err=0
	q:rulestr="" "-11"    //未指定复制规则
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()  //药品字典目录 防止全选选中目录复制
	TS	
	s newDicLength=$l(newDicStr,"^")
	f k=1:1:newDicLength  d
	.s newDicID=$p(newDicStr,"^",k)
	.s length=$l(rulestr,",")
	.f i=1:1:length  d
	..s rule=$p(rulestr,",",i)
	..q:$lg($g(^CT.CKB.PDSS.CommonDictionD(rule)),4)=drugLibaryData
	..///save CT_CKB_PDSS.Rule (规则主表)
	..s ruleName = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),3)
	..s:ruleName="" ruleName="rule"
	..s remark= "复制规则"_$lg($g(^CT.CKB.PDSS.RuleD(+rule)),2)
	..s newRuleId=0,status=""
	..s newRuleId=##class(web.DHCCKBRuleSave).SaveRule(newRuleId,ruleName,remark,status,loginInfo)
	..if newRuleId<0 s err=1
	..tro:err=1
	..q:err=1 
	..///save CKB.PDSS.RuleLog (规则主表日志)
	..s log=##class(web.DHCCKBRuleLog).SaveLog(newRuleId,LgUserId,userInfo)
	..if log<0 s err=1
	..tro:err=1
	..q:err=1 
	..///save CT_CKB_PDSS.RuleDic (规则目录)
	..s dicStr=..GetRuleLabel(rule,dicID)
	..s:dicStr'="" dicStr=newDicID_"^"_dicStr
	..s err=##class(web.DHCCKBRuleDic).SaveRuleDic(newRuleId,dicStr)
	..if err'=0 s err=1
	..tro:err=1
	..q:err=1 
	..///save if	(CT_CKB_PDSS.RuleData)(CT_CKB_PDSS.RuleNode)
	..k TmpArr
	..s err=..SaveNode(rule, newRuleId, "if",0,"",.TmpArr)
	..tro:err=1	
	...q:err=1 
	..///save then (CT_CKB_PDSS.RuleData)
	..k TmpArr
	..s err=..SaveNode(rule, newRuleId, "then",0,"",.TmpArr)
	..tro:err=1	
	..q:err=1 
	..///save else (CT_CKB_PDSS.RuleData)
	..k TmpArr
	..s err=..SaveNode(rule, newRuleId, "else",0,"",.TmpArr)
	..tro:err=1	
	..q:err=1 
	..s uniqeIdentity=$lg($g(^CT.CKB.PDSS.RuleD(newRuleId)),5)
	..s err=##class(web.DHCCKBRuleCopy).InsertRuleCopyLog(rule,newRuleId,uniqeIdentity)
	..tro:err'=0
	..q:err'=0
	..///save CKB.PDSS.RuleDataLog (removed data)
	..s ret=##class(web.DHCCKBRuleLog).SaveRemoveDataLog(log)
	..if ret<0  s err=1
	..tro:err=1
	..q:err=1 
	..i +newRuleId'=0 d  // 生成药品->目录->规则关系 2022-03-30 qnp
	...d ##class(web.DHCCKBConfig).SetDrugLibaryRefByRule(newRuleId)
	TC
	q err
}

/// Desc:		获取属性模板下的属性
/// Creator：   qunianpeng	 
/// CreatDate： 2021-01-21   
/// w ##class(web.DHCCKBDrugDetail).GetLinkTempProp(39)
ClassMethod GetLinkTempProp(prop)
{
	n (prop)
	
	s linkProp = ##class(web.DHCCKBCommon).GetLinkProp()
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",prop,linkProp)) ""
	s dicAttrDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",prop,linkProp,""))
	q:dicAttrDr="" ""
	s attrDr=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicAttrDr)),4)
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",attrDr)) ""
	
	s listData = ""
	s rowID = ""
	f  s rowID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",attrDr,rowID)) q:rowID=""  d
	.s $list(listData,*+1) = rowID
	
	q listData
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

/// Descript:取药品属性[西药、中药、草药等]
/// Creator:sufan 
/// CreateDate:2020-12-17
/// w ##class(web.DHCCKBDrugDetail).GetDrugAttr("5^LinkProp")
ClassMethod GetDrugAttr(params, q = "")
{
	n (params,q)
	s queryDicId = $p(params,"^",1)	// 实体id
	Q:queryDicId="" "[]"
	s extraAttr = $p(params,"^",2)    // 关联属性代码(LinkProp)
	s h = 0,count = 0
    s extraAttrId = ##class(web.DHCCKBRangeCat).GetAttrLink(queryDicId,extraAttr)			
 	i extraAttrId = "" w "[]"
	q:extraAttrId="" "[]"
	
  	// 找到关联的属性列表，展现属性列表
   	s linkId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicId,extraAttrId,""))	// 关联表id
  	i linkId = ""  w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
  	q:linkId="" ""

  	s parref = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),4)	// 属性值(表，集合) 
  	i parref = "" w "[]"
  	q:parref="" ""
  	
  	s count = 0
  	w "["
	s attrId =""
	for  s attrId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,attrId)) Q:attrId=""  d	
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrId)),2)
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrId)),3)
	.s linkDicId = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrId)),5)
	.i $g(linkDicId)'="" d 
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDicId)),2)
	..s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDicId)),3)
	.Q:(q'="")&&(desc'[q)
	.Q:##class(web.DHCCKBCommon).IsEnabled(+attrId)=0     
	.Q:##class(web.DHCCKBCommon).IsEnabled(+linkDicId)=0  
	.s listData = attrId _"^"_ desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	w "]"
	q ""
}

}
