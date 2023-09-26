/// Description:	规则导入管理类
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
Class web.DHCCKBImportRuleManage Extends %RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Description:	导入规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			global name, 含后缀的路径, 登录信息(用户id^职称id^科室id^安全组id^医院id)
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod ImportRule(global, path, loginInfo, clientIP) As %String
{
	n (global, path, loginInfo, clientIP)
	//s $ZT="ErrMsg"
	
	Ts

	k ^TMPExportDrugRule
	/* 导入global临时文件 */
	s ret = ..ImportGlobal(global, path)
	i ret'=0 tro
	q:ret'=0 ret
	
	/* 生成规则及业务数据 */
	s ret = ..SaveBaseRule(loginInfo, clientIP)
	i ret'=0 tro
	q:ret'=0 ret

	/* 导入日志记录 */
	s userId = $p(loginInfo,"^",1)
	s upDate = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","date"))
	s stDate = $p(upDate,"^",1)
	s endDate = $p(upDate,"^",2)
	s type = "rule"
	s status = "in"
	s hosp = $p(loginInfo,"^",5)
	s hospDesc = $p($g(^CT("HOSP",+hosp)),"^",2)
	s version = ##class(web.DHCCKBExportRuleManage).GetVersion("rule",hospDesc)
	s err = ##class(web.DHCCKBUpdateManage).SaveUpdateLog(stDate, endDate, userId, path, type, status, hospDesc, version)
	i +err<=0 s ret = -1
	
	
	i ret'=0 tro
	e  tc
	
	q:ret'=0 ret
	q ret
	
ErrMsg
	Tro
	q ""
}

/// Description:	导入global文件
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-29
/// Input:			global name, 含后缀的路径
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportGlobal()
ClassMethod ImportGlobal(global, path) As %String
{
	// #Class(web.DHCCKB.Util.UtilService).ImportGlobal("TmpDDDDHHH", "D:\dthealth\app\dthis\web\temp\global\HAYIDA,65902,76620.gof")  //导出global文件
	s ret = ##Class(web.DHCCKB.Util.UtilService).ImportGlobal(global, path)  //导出global文件
	
	q ret
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			global name, 含后缀的路径
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod SaveBaseRule(loginInfo, clientIPAddress) As %String
{
	n (loginInfo,clientIPAddress)
	
	s err = 0 
	s drugId = ""
	f  s drugId = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId))  q:(drugId="")||(err'=0)  d
	.s drugInfo = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId))
	./* 判断父指向是否存在 */
	.s parrefCode = $lg(drugInfo,5)	// $lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc)
	.s parrefDesc = $lg(drugInfo,6)	
	.s parrefInfo = $lb("",parrefCode,parrefDesc,"","","")
	.s parrefId = ..SaveDic(parrefInfo,"", loginInfo, clientIPAddress)
	.i +parrefId=0 s err=-1
	.q:+parrefId=0
	./* 判断药品是否存在 */
	.s $list(drugInfo,4) = parrefId
	.s newDrugId = ..SaveDic(drugInfo,"",loginInfo,clientIPAddress)
	.i +newDrugId=0 s err=-1
	.q:+newDrugId=0 	
	./* 保存目录 */
	.s ret = ..SaveLibary(drugId, newDrugId, loginInfo, clientIPAddress)	// $lb(libaryId,libaryCode,libaryDesc,parref,parrefCode,parrefDesc)
	.i ret'=0 s err=-1
	
	q err
}

/// Description:	判断字典数据是否存在
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			需要保存的字典code,描述,父指向的code,描述
/// return:			存在返回字典数据的id, 不存在返回空
/// other:			w ##class(web.DHCCKBImportRuleManage).IsExistFlag()
ClassMethod IsExistFlag(newCode, newDesc, newParrefCode, newParrefDesc, linkDr = "") As %String
{
	n (newCode, newDesc, newParrefCode, newParrefDesc,linkDr)
	
	// 需要先判断是否存在linkDr的数据，防止重复增加	
	s existFlag = 0, dicRowId = ""
	i linkDr'="" d
	.s tmpDicID = ""
	.f  s tmpDicID = $o(^CT.CKB.PDSS.CommonDictionI("Link",linkDr,tmpDicID)) q:(tmpDicID="")||(existFlag=1)   d
	..s tmpCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpDicID)),2)
	..s tmpCode = ..ReplaceBrackets(tmpCode)
	..s tmpDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpDicID)),3)
	..s tmpDesc = ..ReplaceBrackets(tmpDesc)
	..q:(newCode'=tmpCode)||(newDesc'=tmpDesc)
	..s tmpParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpDicID)),4)
	..s tmpParrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpParref)),2)
	..s tmpParrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpParref)),3)
	..q:(tmpParrefCode'=newParrefCode)||(tmpParrefDesc'=newParrefDesc)
	..s existFlag=1
	..s dicRowId = tmpDicID
	
	q:dicRowId'="" dicRowId	
	
	s existFlag = 0, dicRowId = ""
	i (newCode'="")&&$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(newCode)))  d	// 代码存在
	.s tmpDicID = ""
	.f  s tmpDicID = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(newCode),tmpDicID))  q:(tmpDicID="")||(existFlag=1)  d
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),3)
	..s dicDesc = ..ReplaceBrackets(dicDesc)
	..s newDesc = ..ReplaceBrackets(newDesc)
	..q:dicDesc'=newDesc
	..s dicParref = $lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..s dicParrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicParref)),2)
	..s dicParrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicParref)),3)
	..q:(dicParrefCode'=newParrefCode)||(dicParrefDesc'=newParrefDesc)
	..s existFlag=1
	..s dicRowId = tmpDicID
	
	q dicRowId
}

/// Description:	保存目录
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id, 登录信息, ip
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).SaveLibary()
ClassMethod SaveLibary(drugId, newDrugId, loginInfo, clientIPAddress) As %String
{
	n (drugId, newDrugId, loginInfo, clientIPAddress)
	s ret = 0
	s libaryId = ""
	f  s libaryId = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId,libaryId)) q:(libaryId="")||(ret'=0)  d
	.s libaryInfo = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId,libaryId))
	./* 判断父指向是否存在 */
	.s parrefId = $lg(libaryInfo,4)
	.//s parrefCode = $lg(libaryInfo,5)	// $lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc)
	.//s parrefDesc = $lg(libaryInfo,6)	
	.//s parrefInfo = $lb("",parrefCode,parrefDesc,"","","")
	.//s parrefId = ..SaveDic(parrefInfo,"", loginInfo, clientIPAddress)
	.//s:+parrefId=0 ret=-1
	.//q:ret'=0 (判断药品目录的父目录有问题)
	./* 判断目录是否存在 */
	.s $list(libaryInfo,4) = parrefId
	.s newLibaryId = ..SaveDic(libaryInfo,"",loginInfo,clientIPAddress)
	.s:+newLibaryId=0 ret=-1
	.q:+ret'=0 	
	.
	./* 保存规则前删除项目的规则 */
	.s ret = ..DeleteRule(newDrugId,newLibaryId)	
	.q:ret'=0 
	.
	./* 保存规则 */
	.s ret = ..SaveDrugRule(drugId, newDrugId, libaryId, newLibaryId,loginInfo, clientIPAddress)
	
	q:ret'=0 -1
	q ret
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id, 目录id, 登陆信息
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod SaveDrugRule(drugId, newDrugId, libaryId, newLibaryId, loginInfo, clientIPAddress) As %String
{
	
	n (drugId, newDrugId, libaryId, newLibaryId, loginInfo, clientIPAddress)
	
	k TmpMsgArr
	s ret = 0
	/* 保存规则前,先保存所有的字典数据 */
	d ..SaveNewData(loginInfo, clientIPAddress, .TmpMsgArr)
	q:$g(TmpMsgArr("err"))=-1 -1
	
	
	/* 保存规则 */
	s ret = ..SaveRuleObj(.TmpMsgArr, drugId, newDrugId, libaryId, newLibaryId, loginInfo, clientIPAddress)	
	q ret
}

/// Description:	保存规则前,先保存所有的新增字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id, 目录id, 登陆信息
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod SaveNewData(loginInfo, clientIP, TmpMsgArr) As %String
{
	n (loginInfo, clientIP, TmpMsgArr)
	// s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dataType",dicId) = dicCode_"^"_dicDesc_"^"_parrefDr_"^"_knowCode_"^"_knowDesc
	// s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",dicId) = dicCode_"^"_dicDesc_"^"_parrefDr
	// s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","parref",dicId,parrefDr) = "" 
	// s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","linkDr",dicId,dicLinkDr) = "" 	
	s dicID = ""
	f  s dicID = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",dicID)) q:dicID=""  d
	.q:$d(TmpMsgArr(dicID,"new"))	//已经存储过则不存储了
	.d ..SaveParrefNewData(dicID,loginInfo, clientIP, .TmpMsgArr)
	
	q ""
}

/// Description:	保存规则前,先保存所有的新增字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			字典数据id, 登陆信息, ip
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).GetParrefNewData()
ClassMethod SaveParrefNewData(dicID, loginInfo, clientIP, TmpMsgArr) As %String
{
	n (dicID,loginInfo,clientIP,TmpMsgArr)
	//字典信息串$lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc), 知识类型标记, 登录信息(用户id^职称id^科室id^安全组id^医院id),ip
	//q:'$d(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","parref",dicID))||('$d(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dataType",dicID))) ""
	q:$g(TmpMsgArr("err"))=-1 ""
	
	s newParref = ""
	//i $d(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","parref",dicID))=1 d
	i $d(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dataType",dicID))=1 d
	.s tmpInfo = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",dicID))
	.s dicInfo = $lb("",$p(tmpInfo,"^",2),$p(tmpInfo,"^",3),"","","")
	.s newParref = ..SaveDic(dicInfo,"",loginInfo,clientIP)
	.i +newParref=0 s TmpMsgArr("err")="-1" 
	.q:$g(TmpMsgArr("err"))=-1
	.s TmpMsgArr(dicID,"new",newParref)=""
	e  d
	.s parref = ""
	.f  s parref = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","parref",dicID,parref)) q:(parref="")||($g(TmpMsgArr("err"))=-1)  d
	..s newParref = ..SaveParrefNewData(parref, loginInfo, clientIP, .TmpMsgArr)
	..q:$g(TmpMsgArr("err"))=-1
	..s tmpInfo = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",dicID))
	..s newParrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+newParref)),2)
	..s newParrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+newParref)),3)
	..s dicInfo = $lb("",$p(tmpInfo,"^",2),$p(tmpInfo,"^",3),newParref,newParrefCode,newParrefDesc)
	..s ttt = newParref
	..i $d(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","linkDr",dicID))  d	// linkDr形式需要先存link的数据
	...s linkDr = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","linkDr",dicID,""))
	...s linkDrStr = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",linkDr))
	...s newLinkDr = ..SaveParrefNewData(linkDr, loginInfo, clientIP, .TmpMsgArr)
	...s $list(dicInfo,7)=newLinkDr
	..
	..s newParref = ..SaveDic(dicInfo,"",loginInfo,clientIP)
	..i +newParref=0 s TmpMsgArr("err")="-1" 
	..s TmpMsgArr(dicID,"new",newParref)=ttt

	q:$g(TmpMsgArr("err"))=-1 ""
	q newParref
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id, 目录id, 登陆信息
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod SaveRuleObj(TmpMsgArr, drugId, newDrugId, libaryId, newLibaryId, loginInfo, clientIP) As %String
{
	n (TmpMsgArr,drugId, newDrugId, libaryId, newLibaryId,loginInfo, clientIP)

	s ret = 0
	s ruleId = ""
	f  s ruleId = $o(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug", drugId, libaryId, ruleId)) q:(ruleId="")||(ret'=0)  d
	.s ruleInfo = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug", drugId,libaryId,ruleId))
	.s ruleObj = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId,libaryId,ruleId,"value"))
	./* 替换规则json串中的id为新id */
	.s ruleObj = ##class(DHCNewPro.COM.Object).FromJSON(ruleObj)
	.d ..ChangeRuleObjValue(.TmpMsgArr,ruleObj)
	.s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId,libaryId,ruleId,"value")=ruleObj.ToJSON()
	./* 保存规则 */
	.s ret = ..SaveRuleData(drugId, newDrugId, libaryId, newLibaryId, ruleInfo, loginInfo)
	q ret
}

/// Description:	替换规则json串中的id为当前系统 id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ChangeRuleObjValue()
ClassMethod ChangeRuleObjValue(TmpMsgArr, ruleObj) As %String
{
	n (TmpMsgArr,ruleObj)
	//s rootObj = ##class(web.DHCCKBExportRuleManage).GetRuleObj("add",61462)
	s rootObj = ruleObj //##class(DHCNewPro.COM.Object).FromJSON(ruleObj)
	s ruleObj = rootObj.rule
	s ifObj = ruleObj.if
	
	/* 替换if */
	if (ifObj'=""){
		while ifObj.Next(.key , .value ) {
		  d ..ChangeCondition(key,value,.TmpMsgArr)
		}
	}

	/* 替换else */
	s elseObj = ruleObj.else
	i elseObj'="" d ##class(web.DHCCKBImportRuleManage).ChangeOutAction("else", elseObj, .TmpMsgArr)

	/* 替换then */
	s thenObj = ruleObj.then
	i thenObj'="" d ##class(web.DHCCKBImportRuleManage).ChangeOutAction("then", thenObj, .TmpMsgArr)

	q ""
}

/// Description:	替换规则json串中if部分的id为当前系统 id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ChangeCondition()
ClassMethod ChangeCondition(condition, condObj, TmpMsgArr) As %String
{
	n (condition,condObj,TmpMsgArr)	
	s condType=condObj.%ClassName()
	while condObj.Next(.condKey , .condValue ) {
		  continue:condValue=""
		  s valueType=condValue.%ClassName()
		  i condKey="atom"{
			   i $f(valueType,"Array")>0{
				   while condValue.Next(.atomKey , .atomValue ) {
					   	d ..ChangeRuleData(atomValue, .TmpMsgArr)
				   }
			   }else{
				   d ..ChangeRuleData(condValue, .TmpMsgArr)				  
			   }
		  }else{
			 if (condKey'="and")&&(condKey'="or")&&(condKey'["union"){	// qunianpeng 2020/4/10 增加联合条件  sufan  2020-07-07 由condKey'="union" 改为condKey'["union"
				s newCondKey=condition			 
			 }else{
				s:condKey["union" condKey="union"  			//sufan  2020-07-07  增加联合节点的判断
				s newCondKey=condKey	 
			 }					 
			 d ..ChangeCondition(newCondKey,condValue,.TmpMsgArr)
		  }
	   }
	q ""
}

/// Description:	替换规则json串中if部分的id为当前系统 id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ChangeRuleData()
ClassMethod ChangeRuleData(atomValue, TmpMsgArr) As %String
{
	n (atomValue,TmpMsgArr)
	
  	s leftObj=atomValue.Get("left")
	s valueObj=atomValue.Get("value")
	
	i (leftObj."_varCategoryId"'="")&&$d(TmpMsgArr(leftObj."_varCategoryId","new")) d
	.s leftObj."_varCategoryId" = $o(TmpMsgArr(leftObj."_varCategoryId","new",""))
	i (leftObj."_var"'="")&&$d(TmpMsgArr(leftObj."_var","new")) d
	.s leftObj."_var" = $o(TmpMsgArr(leftObj."_var","new",""))

	i (valueObj."_uom"'="")&&$d(TmpMsgArr(valueObj."_uom","new")) d
	.s valueObj."_uom" = $o(TmpMsgArr(valueObj."_uom","new",""))
	
	i (leftObj."_const"'="")&&$d(TmpMsgArr(leftObj."_const","new")) d
	.s leftObj."_const" = $o(TmpMsgArr(leftObj."_const","new",""))
	
	i (leftObj."_const-category"'="")&&$d(TmpMsgArr(leftObj."_const-category","new")) d
	.s leftObj."_const-category" = $o(TmpMsgArr(leftObj."_const-category","new",""))
	
	i (valueObj."_type"'="")&&(valueObj."_type"="Constant")&&(valueObj."_uom"'="")&&($d(TmpMsgArr(valueObj."_uom","new"))) d
	.s valueObj."_const" = $o(TmpMsgArr(valueObj."_const","new",""))
	.s valueObj."_const-category" = $o(TmpMsgArr(valueObj."_const-category","new",""))
	
	i (valueObj."_const"'="")&&($d(TmpMsgArr(valueObj."_const","new"))) d
	.s valueObj."_const" = $o(TmpMsgArr(valueObj."_const","new",""))

	i (valueObj."_const-category"'="")&&$d(TmpMsgArr(valueObj."_const-category","new")) d
	.s valueObj."_const-category" = $o(TmpMsgArr(valueObj."_const-category","new",""))

   q ""
}

/// Description:	替换规则json串中输出部分的id为当前系统 id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ChangeOutAction()
ClassMethod ChangeOutAction(action, json, TmpMsgArr)
{
	n (action, json, TmpMsgArr)

	while json.Next(.key , .value ) {

	  s subType=value.%ClassName()
	  i "Array"=subType{
		while value.Next(.keySub , .valueSub ) {
			d ..ChangeAction(valueSub, .TmpMsgArr)
	  	}	
	  }else{
			d ..ChangeAction(value, .TmpMsgArr)
	  }
	  
	}
	q ""
}

/// Description:	替换规则json串中输出部分的id为当前系统 id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ChangeOutAction()
ClassMethod ChangeAction(jsonObj, TmpMsgArr)
{
	n (jsonObj, TmpMsgArr)	

	//等号左边
	i (jsonObj."_varCategoryId"'="")&&$d(TmpMsgArr(jsonObj."_varCategoryId","new")) d
	.s jsonObj."_varCategoryId" = $o(TmpMsgArr(jsonObj."_varCategoryId","new",""))
	i (jsonObj."_var"'="")&&$d(TmpMsgArr(jsonObj."_var","new")) d
	.s jsonObj."_var" = $o(TmpMsgArr(jsonObj."_var","new",""))

	//等号的右边
	s valueObj=jsonObj.Get("value")
	i (valueObj."_type"'="")&&(valueObj."_type"="Constant")&&($d(TmpMsgArr(valueObj."_const","new"))) d
	.s valueObj."_const" = $o(TmpMsgArr(valueObj."_const","new",""))
	.s valueObj."_const-category" = $o(TmpMsgArr(valueObj."_const-category","new",""))
	
	q ""
}

/// Description:	保存规则明细
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id, 目录id, 登陆信息
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ImportRule()
ClassMethod SaveRuleData(drugId, newDrugId, libaryId, newLibaryId, ruleInfo, loginInfo) As %String
{
	n (drugId, newDrugId, libaryId, newLibaryId, ruleInfo, loginInfo)
	
	//q:newFlag="Y" ""	// 新增药品或目录时,不需要删除规则
	s ruleId = $listGet(ruleInfo,1)
	s ruleStatus = $listGet(ruleInfo,4)
	s unique = $listGet(ruleInfo,5)
	s ruleObj = $g(^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",drugId,libaryId,ruleId,"value"))

	q:unique'["dhcckb" 0 // 非标库生成规则不动
	s userId = $p(loginInfo,"^",1)
	s ret = 0
	/* 标库新增的规则,且不是由该项目产生的,则直接新增规则 */	
	i '$d(^CT.CKB.PDSS.RuleI("UniqeIdentity",unique))  d
	.s isExistFlag = ..CheckRuleSource(unique) // 判断是否由项目新增的规则,不是由项目生成的则直接增加 
	.q:isExistFlag="Y"
	.s dicStr = newDrugId_"^"_newLibaryId
	.s userId = $p(loginInfo,"^",1)
	.s newruleId= ..AddNewRule(dicStr, ruleObj, userId, loginInfo, ruleStatus)	// 新增规则
	.i newruleId<=0 s ret = -1
	e  d
	./* 项目取消发布的规则保持不动 */
	.s ruleStatus = ..GetRuleStatus(unique)
	.q:ruleStatus="CancelRelease"
	./* 项目修改过的规则不能删除(有修改日志) */
	.s isExistFlag = ..CheckRuleUpdateFlag(unique)
	.q:isExistFlag="Y"	
	.s dicStr = newDrugId_"^"_newLibaryId
	.s newruleId = ..AddNewRule(dicStr, ruleObj, userId, loginInfo, ruleStatus)	// 新增规则
	.i newruleId<=0 s ret = -1
	
	q ret
}

/// Description:	新增新规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			药品id^目录规则, 规则json串, 用户id, 用户id^职称id^科室id^安全组id^医院id
/// return:			规则id
/// other:			w ##class(web.DHCCKBImportRuleManage).AddNewRule()
ClassMethod AddNewRule(dicStr, ruleObj, userId, loginInfo, ruleStatus) As %String
{
	n (dicStr, ruleObj, userId, loginInfo,ruleStatus)

	s status = ""
	s ret = ##class(web.DHCCKBRuleSave).save(0,status,ruleObj,userId,dicStr,loginInfo,"东华标准版数字化医院[总院]")
	q:ruleStatus'="Release" ret // 未发布的规则更新到项目后依然不发布
	
	i ret>0 d	
	.s status = "Release"
	.s opStatus = ""
	.s root = ##class(web.DHCCKBExportRuleManage).GetRuleObj(opStatus,ret)
	.s ret = ##class(web.DHCCKBRuleSave).save(ret,status,root,userId,dicStr,loginInfo,"东华标准版数字化医院[总院]")

	q ret
}

/// Description:	保存字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-05
/// Input:			字典信息串$lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc), 知识类型标记, 登录信息(用户id^职称id^科室id^安全组id^医院id),ip
/// return:			成功:新增的字典数据id, 失败 0
/// other:			w ##class(web.DHCCKBImportRuleManage).SaveDic($lb("","DrugLibaryData","药品目录字典","","Prop","属性"),"","","")
ClassMethod SaveDic(dicInfo, attrData, loginInfo, clientIPAddress)
{
	n (dicInfo,attrData,loginInfo,clientIPAddress)

	s dicCode = $lg(dicInfo,2)
	s dicDesc = $lg(dicInfo,3)
	s parrefId =  $lg(dicInfo,4)
	s parrefCode = $lg(dicInfo,5)
	s parrefDesc = $lg(dicInfo,6)
	s linkDr = $lg(dicInfo,7)
	// 通用名和带剂型的通用名 描述改变了
	s dicId=0
	i dicCode="GenerNameFormProp" s dicId=##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFormProp")
	i dicCode="GenerNameProp" s dicId=##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameProp")
	q:+dicId'=0 dicId	// 存在
	s dicId = ..IsExistFlag(dicCode,dicDesc,parrefCode,parrefDesc,linkDr) 
	q:+dicId'=0 dicId	// 存在
		
	s ret = 0
	s lgUserID=$p($g(loginInfo),"^",1)
	s lgHospID=$p($g(loginInfo),"^",5)
	
	s newDicID = 0
	s params = "^"_dicCode_"^"_dicDesc_"^"_parrefId_"^"_linkDr // id^code^desc^parref^linkDr
	s id = ##class(web.DHCCKBDiction).SaveDic(params)		// ret是id
	q:+id<=0 newDicID
	s newDicID = id
	i attrData'="" s ret = ##class(web.DHCCKBDiction).SaveLinkAttr(ret,attrData)	// 若知识类型和实体标记不存在,则自动插入  ret是SQLCODE
	q:ret'=0 newDicID
	s ret=##class(web.DHCCKBWriteLog).SaveDicLog(id,lgUserID,lgHospID,"add",clientIPAddress) // ret是SQLCODE 日志
	q:ret'=0 newDicID
	s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", id, "grantAuth", lgUserID, "", "", "D", lgHospID, clientIPAddress,"acc")  //授权
	q:ret'=0 newDicID
	
	q newDicID
}

/// Description:	获取规则的状态
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-05
/// Input:			唯一标识
/// return:			状态
/// other:			w ##class(web.DHCCKBImportRuleManage).GetRuleStatus()
ClassMethod GetRuleStatus(unique)
{
	n (unique)
	s ruleId = $o(^CT.CKB.PDSS.RuleI("UniqeIdentity",+unique,""))
	s status =$lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),4)
	q status
}

/// Description:	判断规则项目是否修改过
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-12
/// Input:			唯一标识
/// return:			Y 修改过  N 未修改 (存在规则再标库多次修改，且项目上和标库一致，导致再次更新不准确,所以需要判断医院)
/// other:			w ##class(web.DHCCKBImportRuleManage).CheckRuleUpdateFlag("dhcckb,65853,62650.797175")
ClassMethod CheckRuleUpdateFlag(unique)
{
	n (unique)
	
	s ruleId = $o(^CT.CKB.PDSS.RuleI("UniqeIdentity",unique,""))

	q:ruleId="" "N"
	
	s count = 0, firstLog = "", secondLog = ""
	s ruleLogId=""	// 兜底规则修改过的不能删除
	f  s ruleLogId=$o(^CKB.PDSS.RuleLogI("Rule",ruleId,ruleLogId))  q:(ruleLogId="")||(count>2)  d
	.s hospDesc = $lg(^CKB.PDSS.RuleLogD(ruleLogId),10)
	.//q:hospDesc="东华标准版数字化医院[总院]"
	.s count = count + 1
	.q:count>2	
	.

	q:count>2 "Y"
	
	q "N"
}

/// Description:	判断规则是否是由当前项目生成
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-12
/// Input:			唯一标识
/// return:			Y 修改过  N 未修改
/// other:			w ##class(web.DHCCKBImportRuleManage).CheckRuleUpdateFlag()
ClassMethod CheckRuleSource(unique, hospDesc = "")
{
	n (unique,hospDesc)
	
	s isExistFlag = "N"
	// CKB.PDSS.RuleCopyLog表中记录的数据有问题,唯一标识应该记录来源规则的标识
	q isExistFlag
}

/// Description:	删除项目规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-12
/// Input:			药品id,目录id
/// return:			0 删除成功 非零 删除失败
/// other:			w ##class(web.DHCCKBImportRuleManage).DeleteRule()
ClassMethod DeleteRule(drugId, libaryId) As %String
{
	n (drugId, libaryId)
	
	q:('$d(^CT.CKB.PDSS.RuleDicI("Dic",+drugId)))||('$d(^CT.CKB.PDSS.RuleDicI("Dic",+libaryId))) 0
	
	s ret = 0
	s ruleDicRowID = ""
	f  s ruleDicRowID = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicRowID)) q:(ruleDicRowID="")||(ret'=0)  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicRowID)),2)
	.s tmpLibaryId = ##Class(web.DHCCKBPassNew).GetRuleLabelID(ruleId)
	.q:libaryId'=tmpLibaryId
	./* 项目取消发布的规则保持不动 */
	.s unique = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),5)
	.q:unique'["dhcckb"
	.s ruleStatus = ..GetRuleStatus(unique)
	.q:ruleStatus="CancelRelease"
	./* 项目修改过的规则不能删除(有修改日志) */
	.s isExistFlag = ..CheckRuleUpdateFlag(unique)
	.q:isExistFlag="Y"	
	.s ret=##class(web.DHCCKBRuleSave).RemoveRule(ruleId)
	
	q:ret'=0 -1
	
	q 0
}

/// Description:	替换字典数据中的括号
/// Creator:		QuNianpeng 
/// CreateDate:		2021-11-10
/// Input:			字典描述
/// return:			
/// other:			w ##class(web.DHCCKBImportRuleManage).ReplaceBrackets()
ClassMethod ReplaceBrackets(desc) As %String
{
	n (desc)
	s desc =$replace(desc,"（","(")
	s desc =$replace(desc,"）",")")
	
	q desc
}

}
