Import SQLUSER

/// Description:	知识导入管理类
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-12
Class web.DHCCKBImportKnowManage Extends %RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Description:	导入知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-09
/// Input:			global name, 含后缀的路径, 登录信息(用户id^职称id^科室id^安全组id^医院id)
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).ImportKnow()
ClassMethod ImportKnow(global, path, loginInfo, clientIP) As %String
{
	n (global, path, loginInfo, clientIP)
	s $ZT="ErrMsg"
	Ts

	k ^TMPExportDrugKnow
	/* 导入global临时文件 */
	s ret = ##class(web.DHCCKBImportRuleManage).ImportGlobal(global, path)
	i ret'=0 tro
	q:ret'=0 ret

	/* 生成知识数据 */
	s ret = ..SaveKnow(loginInfo, clientIP)
	i ret'=0 tro
	q:ret'=0 ret

	/* 导入日志记录 */
	s userId = $p(loginInfo,"^",1)
	s type = "rule"
	s status = "in"
	s hosp = $p(loginInfo,"^",5)
	s hospDesc = $p($g(^CT("HOSP",+hosp)),"^",2)
	s stDate="",endDate=""
	s version = ##class(web.DHCCKBExportRuleManage).GetVersion("know",hospDesc)
	s err = ##class(web.DHCCKBUpdateManage).SaveUpdateLog(stDate, endDate, userId, path, type, status, hospDesc, version)
	i +err<=0 s ret = -1
	
	i ret'=0 tro
	e  tc
	
	q:ret'=0 ret
	q ret
	
ErrMsg
	Tro
	q $ze
}

/// Description:	保存知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			登录信息,ip
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveKnow()
ClassMethod SaveKnow(loginInfo, clientIP) As %String
{
	n (loginInfo,clientIP)
	
	s err = 0 
	k TmpMsgArr
	s drugId = ""
	f  s drugId = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId)) q:(drugId="")||(err'=0)  d
	.i $d(TmpMsgArr(+drugId,"new")) s newDrugId = $o(TmpMsgArr(+drugId,"new",""))
	.e  s newDrugId = ..SaveParrefNewData(drugId, loginInfo, clientIP, .TmpMsgArr)
	.s:newDrugId="" err=-1
	.q:newDrugId=""
	.s attrCode = ""
	.f  s attrCode = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode)) q:(attrCode="")||(err'=0)  d
	..i $d(TmpMsgArr(+attrCode,"new")) s newAttrCode = $o(TmpMsgArr(+attrCode,"new",""))
	..e  s newAttrCode = ..SaveParrefNewData(attrCode,loginInfo, clientIP, .TmpMsgArr)
	..s:newAttrCode="" err=-1
	..q:newAttrCode=""
	..q:$d(TmpMsgArr("group",attrCode)) // 一组的数据，只需要存一次即可 
	../* 先删除项目的属性值 */ // 无法区别项目上是否修改
	..s ret = ..DeleteDicAttr(newDrugId,newAttrCode)
	..q:ret'=0
	..s ret = ..SaveLinkData(drugId,newDrugId,attrCode,newAttrCode,loginInfo, clientIP, .TmpMsgArr)	
	..s:ret'=0 err=-1
	 
	q err
}

/// Description:	保存知识前,先保存需要新增字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 登陆信息, ip
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveParrefNewData()
ClassMethod SaveParrefNewData(dicID, loginInfo, clientIP, TmpMsgArr) As %String
{
	n (dicID,loginInfo,clientIP,TmpMsgArr)
	//字典信息串$lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc), 知识类型标记, 登录信息(用户id^职称id^科室id^安全组id^医院id),ip
	q:$g(TmpMsgArr("err"))=-1 ""
	
	s newParref = ""
	i $d(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dataType",dicID))=1 d
	.s tmpInfo = $g(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dic",dicID))
	.s dicInfo = $lb("",$p(tmpInfo,"^",2),$p(tmpInfo,"^",3),"","","")
	.s newParref = ##class(web.DHCCKBImportRuleManage).SaveDic(dicInfo,"",loginInfo,clientIP)
	.i +newParref=0 s TmpMsgArr("err")="-1" 
	.q:$g(TmpMsgArr("err"))=-1
	.s TmpMsgArr(dicID,"new",newParref)=""
	e  d
	.s parref = ""
	.f  s parref = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","parref",dicID,parref)) q:(parref="")||($g(TmpMsgArr("err"))=-1)  d
	..s newParref = ..SaveParrefNewData(parref, loginInfo, clientIP, .TmpMsgArr)
	..q:$g(TmpMsgArr("err"))=-1
	..s tmpInfo = $g(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dic",dicID))
	..s newParrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+newParref)),2)
	..s newParrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+newParref)),3)
	..s dicInfo = $lb("",$p(tmpInfo,"^",2),$p(tmpInfo,"^",3),newParref,newParrefCode,newParrefDesc)
	..s ttt = newParref
	..i $d(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","linkDr",dicID))  d	// linkDr形式需要先存link的数据
	...s linkDr = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","linkDr",dicID,""))
	...s linkDrStr = $g(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dic",linkDr))
	...s newLinkDr = ..SaveParrefNewData(linkDr, loginInfo, clientIP, .TmpMsgArr)
	...s $list(dicInfo,7)=newLinkDr
	..
	..s newParref = ##class(web.DHCCKBImportRuleManage).SaveDic(dicInfo,"",loginInfo,clientIP)
	..i +newParref=0 s TmpMsgArr("err")="-1" 
	..s TmpMsgArr(dicID,"new",newParref)=ttt

	q:$g(TmpMsgArr("err"))=-1 ""
	q newParref
}

/// Description:	保存关联的属性值
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 新字典数据id, 属性id, 新属性id, 登陆信息, ip
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveLinkData()
ClassMethod SaveLinkData(drugId, newDrugId, attrCode, newAttrCode, loginInfo, clientIP, TmpMsgArr) As %String
{
	n (drugId,newDrugId,attrCode,newAttrCode, loginInfo, clientIP, TmpMsgArr)	
	s ret = 0
	i '$d(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode,"value")) d	// 不存在
	.s listData = newDrugId_"^"_newAttrCode_"^"_""
	.s ret = ..SaveDicAttrCode(newDrugId,newAttrCode,listData, loginInfo, clientIP)	
	e  d
	.s index = ""
	.f  s index = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode,"value",index))  q:(index="")||(ret'=0)  d
	..s valueList = $g(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode,"value",index)) 
	..s group = $lg(valueList,3)
	..i group=""  d
	...s ret = ..SaveDicAttr(valueList,newDrugId,newAttrCode,loginInfo, clientIP,.TmpMsgArr)
	..e  d //group不空
	...s ret = ..SaveGroupDicAttr(drugId,newDrugId,group,loginInfo, clientIP,.TmpMsgArr)

	q ret
}

/// Description:	保存关联的属性值
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 属性id
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveDicAttrCode()
ClassMethod SaveDicAttrCode(drugId, attrCode, listData, loginInfo, clientIP) As %String
{
	n (drugId,attrCode,listData,loginInfo, clientIP)
	
	
	/* 新增知识 */
	s ret = ..InsDicAttr(listData)
	q:+ret<=0 -1
	
	/* 日志 */
	s userId = $p(loginInfo,"^",1)
	s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicLinkAttr", ret, "add", userId, "", "", "", "", clientIP,"log")
	q:ret'=0 -1
	
	q ret
}

/// Description:	删除原有的知识数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 属性id
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).DeleteDicAttr()
ClassMethod DeleteDicAttr(drugId, attrCode) As %String
{
	n (drugId, attrCode)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+drugId,+attrCode)) 0
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:drugId and DLA_AttrCode=:attrCode)
	
	q SQLCODE
}

/// Description:	新增知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 属性id
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).InsDicAttr()
ClassMethod InsDicAttr(listData) As %String
{
	n (listData)
	
	s dicDr=$p(listData,"^",1)			//实例ID
	s attrCode=$p(listData,"^",2)		//属性Code
	s attrDr=$p(listData,"^",3) 		//属性ID
	s result=$p(listData,"^",4) 		//备注
	s groupFlag=$p(listData,"^",5) 		//同组标识

	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_GroupFlag)
	     values (:dicDr,:attrCode,:attrDr,:result,:groupFlag))
	Q %ROWID
}

/// Description:	根据值域不同保存知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 属性id
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveDicAttr()
ClassMethod SaveDicAttr(valueList, drugId, attrCode, loginInfo, clientIP, TmpMsgArr, newGroup = "") As %String
{
	n (valueList,drugId,attrCode,loginInfo, clientIP,newGroup)
	s valueType = $lg(valueList,1)
	s value = $lg(valueList,2)
	s listData = ""
	
	s ret = 0
	i (valueType="diction") d
	.s newValue = ""
	.i $d(TmpMsgArr(+value,"new")) d 
	..s newValue = $o(TmpMsgArr(+value,"new",""))
	.e  s newValue = ..SaveParrefNewData(value, loginInfo, clientIP, .TmpMsgArr)
	.s:newValue="" ret = -1
	.q:newValue=""
	.s listData = drugId_"^"_attrCode_"^"_newValue_"^"_""_"^"_newGroup
	e  d
	.s listData = drugId_"^"_attrCode_"^"_""_"^"_value_"^"_newGroup
	
	s ret = ..SaveDicAttrCode(drugId,attrCode,listData,loginInfo, clientIP)

	q ret
}

/// Description:	保存一组知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			字典数据id, 属性id
/// return:			
/// other:			w ##class(web.DHCCKBImportKnowManage).SaveGroupDicAttr()
ClassMethod SaveGroupDicAttr(drugId, newDrugId, group, loginInfo, clientIP, TmpMsgArr) As %String
{
	n (drugId,newDrugId,group,loginInfo, clientIP,TmpMsgArr)
	
	s ret = 0
	s newGroup = ##class(web.DHCCKBCommonUtil).NewPid()
	s attrCode = ""
	f  s attrCode = $o(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","group",drugId,group,attrCode))  q:(attrCode="")||(ret'=0)  d
	.s valueList = $g(^TMPExportDrugKnow("web.DHCCKBExportKnowManage","group",drugId,group,attrCode)) 
	.i $d(TmpMsgArr(attrCode,"new")) s newAttrCode = $o(TmpMsgArr(attrCode,"new",""))
	.e  s newAttrCode = ..SaveParrefNewData(attrCode, loginInfo, clientIP, .TmpMsgArr)
	.s:newAttrCode="" ret = -1
	.q:newAttrCode="" 
	.i '$d(TmpMsgArr("group",newAttrCode)) d
	..d ..DeleteDicAttr(newDrugId,newAttrCode)
	.s TmpMsgArr("group",attrCode,group)="" // 记录一组数据，防止一组多次存储
	.s ret = ..SaveDicAttr(valueList,newDrugId,newAttrCode,loginInfo, clientIP,.TmpMsgArr,newGroup)
	
	q ret
}

}
