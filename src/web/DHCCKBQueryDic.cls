Class web.DHCCKBQueryDic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJson("","106")
ClassMethod GetTreeJson(q As %String = "", parref As %String, count As %String = 0) As %String
{
	n (q,parref,count)
	s input=$zcvt(q,"U")
	i parref="" w "[]"
	q:parref="" ""
	
	w "["
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s count=count+1
	.Q:(input'="")&&(pinDicDesc_dicDesc_dicCode'[input)
	.Q:(input="")&&(count>1000)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.i subID'="" d
	..w ",""children"":"
	..D ..GetTreeJson(input,dicID,count)   ///是否有叶子节点
	.w "}"
	.//q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	
	w "]"
	
	q ""
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		kemaolin
/// CreateDate:		2020-03-05	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJsonData("因可能引起双硫仑样反应而慎用的头孢菌素类","106")
ClassMethod GetTreeJsonData(Input As %String = "", parref As %String) As %String
{
	n (Input,parref)
	//药学类字典按code排序 kml 2020-03-05
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	
	d ..SortCatByCode(parref,pid)		//数据排序
	
	d ##class(web.DHCCKBQueryDic).GetSortTreeJson(Input, parref,pid)		//树查询
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	Q ""
}

/// Description:	药学分类字典按code排序输出
/// Creator:		kemaolin
/// CreateDate:		2020-03-05	
/// other:			w ##class(web.DHCCKBQueryDic).GetSortTreeJson("","106")
ClassMethod GetSortTreeJson(Input As %String = "", parref As %String, pid) As %String
{
	n (Input,parref,pid)
	
	s input=$zcvt(Input,"U")
	i parref="" w "[]"
	q:parref="" ""
	s count=0
	w "["
	//按code排序
	q:+pid=0
	s sortCode="" f  s sortCode=$o(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode)) q:sortCode=""  d
	.q:sortCode=""
	.s dicID=$g(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode))
	.q:+dicID=0
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(dicID)
	.Q:Flag=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.;s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(dicID,input)
	.Q:(ExistFlag=0)&&(dicDesc'[input)&&(dicCode'[input)
	.;Q:(Input'="")&&(count>500)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.s subFlag=..IsDisabled(dicID, 0)
	.i (subID'="")&&(subFlag=1) d
	..i input="" w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	..w ",""children"":"
	..D ..GetSortTreeJson(input,dicID,pid)   ///是否有叶子节点
	.w "}"	
	w "]"	
	
	q ""
}

/// Description:	按照节点加载，展开时加载子节点
/// Creator:		sufan 
/// CreateDate:		2020-03-05	
/// Input:			代码^描述
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJsonDataByNode("","26938")
ClassMethod GetTreeJsonDataByNode(Input As %String = "", id As %String) As %String
{
	n (Input,id)
	s parref=id
	s ^temptest("456")=$lb(Input,parref)
	//药学类字典按code排序 kml 2020-03-05
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	
	d ..SortCatByCode(parref,pid)		//数据排序

	d ##class(web.DHCCKBQueryDic).GetSortTreeJsonByNode(Input, parref,pid)		//树查询
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	Q ""
}

/// Description:	药学分类字典按code排序输出
/// Creator:		kemaolin
/// CreateDate:		2020-03-05	
/// other:			w ##class(web.DHCCKBQueryDic).GetSortTreeJsonByNode("","106",251754)
ClassMethod GetSortTreeJsonByNode(Input As %String = "", parref As %String, pid) As %String
{
	n (Input,parref,pid)
	s input=$zcvt(Input,"U")
	i parref="" w "[]"
	q:parref="" ""
	s count=0
	w "["
	//按code排序
	q:+pid=0
	s sortCode="" f  s sortCode=$o(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode)) q:sortCode=""  d
	.q:sortCode=""
	.s dicID=$g(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode))
	.q:+dicID=0
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(dicID)
	.Q:Flag=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicCode = $replace(dicCode,"""","")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.s dicDesc = $replace(dicDesc,"\","")
	.s dicDesc = $replace(dicDesc,"""","")
	.;s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(dicID,input)
	.Q:(ExistFlag=0)&&(dicDesc'[input)&&(dicCode'[input)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(dicID,dicDesc,dicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.s subFlag=..IsDisabled(dicID, 0)
	.//s subFlagNew=..IsDisabledNew(dicID, 0)		//lidong 2022-9-20 引用数据判断是否存在下级节点
	.i ((subID'="")&&(subFlag=1)) d			//||((subID="")&&(subFlagNew=1)
	..i input="" w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	..;w ",""children"":"
	..;D ..GetSortTreeJsonnode(input,dicID,pid)   ///是否有叶子节点
	.w "}"	

	w "]"	
	
	q ""
}

/// Descript:	判断下级节点是有下级
/// Creator:	sufan
/// CrateDate:	2020-03-27
/// Input:	ParentId
/// Output:1：可用，0：不可用
/// w ##class(web.DHCCKBQueryDic).IsDisabled(261255,0)
ClassMethod IsDisabled(ParentId, Num)
{
	n (ParentId,Num)
	s EnFlag=1
	s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,""))
	Q:SubId="" EnFlag
	s Id="",Num=0
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,Id)) Q:(Id="")||(Num>0)   d
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(Id)			//是否可用
	.i Flag=1 s Num=Num+1 s EnFlag=1
	.s:Num=0 EnFlag=0
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Id))  d
	..s EnFlag=..IsDisabled(Id,.Num)
	Q EnFlag
}

/// Descript:	判断节点下级只有引用数据时，添加折叠标记
/// Creator:	lidong
/// CrateDate:	2022-9-20
/// Input:	ParentId
/// Output:1：有下级，0：无下级
/// w ##class(web.DHCCKBQueryDic).IsDisabledNew(261255,0)
ClassMethod IsDisabledNew(ParentId, Num)
{
	n (ParentId,Num)
	
	s TempElementId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("TempElement"),""))
	s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ParentId,TempElementId,""))
	i DLARowID'=""  d
	.s EnFlag=1
	e  d
	.s EnFlag=0
	q EnFlag
}

/// Debug d ##class(web.DHCCKBQueryDic).SortCatByCode(106,1)
ClassMethod SortCatByCode(parref, pid, num = 0)
{
	n (parref,pid,num)
	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(catID)),2)
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(catID)),5)
	.s:(dicLink'="")&&(code="") code = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2)
	.s num=num+1
	.s code=code_catID
	.s ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,code)=catID
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",catID))  d
	..d ..SortCatByCode(catID,pid,.num)
}

/// Description:	获取实体下的实例或者有父子结构的属性、字典(treeGrid结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-09	
/// Input:			父节点id,查询代码或描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).QueryDrugCatTree("38","","1","98281","2^1^1^1")
ClassMethod QueryDrugCatTree(attrID, input, chkFlag = "", EntyId = "", param = "") As %String
{
	n (attrID, input,chkFlag,EntyId,param)
	s ^temptest("3456")=$lb(attrID, input,chkFlag,EntyId,param)
	i attrID="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:attrID="" ""
	
	//通过属性id->数据源->数据集 找到属性挂载 的数据源集合
	s dataSourceID=##class(web.DHCCKBCommon).GetDataSource()
	s linkID="",parref=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,dataSourceID))  d
	.s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,dataSourceID,""),-1)
	.i linkID'="" s parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
	i parref="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:parref="" ""
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..SortByCode(parref,pid,param)			//排序
	
	d ..QueryTree(parref,pid,attrID, input, chkFlag , EntyId , param)						//2020-03-12 SUFAN 取数据
	Q ""
}

/// Description:	取树数据
/// Creator:		sufan 
/// CreateDate:		2020-03-12
/// Input:			父节点id,查询代码或描述
/// return:			
/// other:			w ##class(web.DHCCKBQueryDic).QueryDrugCatTree("38","","","")
ClassMethod QueryTree(Parref, pid, attrID, input, chkFlag = "", EntyId = "", param)
{
	n (Parref,pid,attrID,input,chkFlag,EntyId,param)
	i param'=""  d
	.s hospID=$p(param,"^",1)
	.s groupID=$p(param,"^",2)
	.s locID=$p(param,"^",3)
	.s userID=$p(param,"^",4)
	w "["
	s count=0
	s Index="" 
	for  s Index=$o(^TMP("web.DHCCKBQueryDic","QueryDrugCatTree",pid,Parref,Index)) q:Index=""  d
	.s ID=$g(^TMP("web.DHCCKBQueryDic","QueryDrugCatTree",pid,Parref,Index))
	.q:+ID=0
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.;q:##class(web.DHCCKBCommon).GetStopDicData(dicID,hospID,groupID,locID,userID)=1
	.s DicLinkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),5) 		//kml 2020-02-21
	.s Code = $lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	.s:(DicLinkId'="")&&(Code="") Code = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),2) 			//kml 2020-02-21
	.s Code = $tr(Code,$c(10),"")
	.s Text = $lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	.s:(DicLinkId'="")&&(Text="") Text = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3) 			//kml 2020-02-21
	.s Text = $tr(Text,$c(10),"")
	.s ExistFlag=..IsChkDrugCls(ID,EntyId,attrID)
	.Q:(chkFlag=1)&&(ExistFlag=0)
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(ID)
	.Q:Flag=0
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,Text,Code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,Text,Code)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ID,""))
	.i subID'="" d
	..w:chkFlag'=1 ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	..w ",""children"":"
	..D ..QueryTree(ID,pid,attrID,input,chkFlag,EntyId,param)   ///是否有叶子节点
	.w "}"
	
	w "]"	
	
	q ""
}

/// Description:	按照code排序
/// Creator:		sufan 
/// CreateDate:		2020-03-12
/// Input:			父节点id,查询代码或描述
ClassMethod SortByCode(Parref, pid, param)
{
	n (Parref,pid,param)
	s DicId=""
	f  s DicId= $o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,DicId)) q:DicId=""  d
	.q:+DicId="0" 
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.s DicLinkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),5)
	.s:(DicLinkId'="")&&(Code="") Code = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),2)
	.s Code=Code_DicId
	.s ^TMP("web.DHCCKBQueryDic","QueryDrugCatTree",pid,Parref,Code)=DicId
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DicId)) d
	..d ..SortByCode(DicId,pid)
}

/// Creator:sufan
/// CreateDate:2020-02-27
/// Descript：判断子节点是否包含
/// Input:ParentId
/// OutPut:1，包含，0，不包含
/// w ##class(web.DHCCKBQueryDic).IsExistSubNode(106,"拟肾上腺素药")
ClassMethod IsExistSubNode(ParentId, input)
{
	n (ParentId,input)
	s IsExistFlag=0
	s NextId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,""))
	
	i NextId=""  d
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ParentId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ParentId)),3)
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(ParentId)),5)
	.s:dicLink'="" dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2)
	.s:dicLink'="" dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3)
	.//s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(ParentId)	
	.i (dicDesc[input)||(dicCode[input)||(Alias[input) s IsExistFlag=1
	Q:IsExistFlag=1 IsExistFlag
	Q:NextId="" IsExistFlag
	s NextId="" 
	for  s NextId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,NextId)) Q:(NextId="")||(IsExistFlag=1)  d
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(NextId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(NextId)),3)
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(NextId)),5)
	.s:dicLink'="" dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2)
	.s:dicLink'="" dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3)
	.//s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(ParentId)
	.i (dicDesc[input)||(dicCode[input)||(Alias[input) s IsExistFlag=1
	.Q:IsExistFlag=1
	.s IsExistFlag=..IsExistSubNode(NextId,input)
	
	
	Q IsExistFlag
}

/// 判断节点是否关联
/// w ##class(web.DHCCKBQueryDic).IsChkDrugCls(149,98281,38)
ClassMethod IsChkDrugCls(DicId, EntyId = "", attrID)
{
	n (DicId, EntyId,attrID)
	s IsChkFlag=0
	Q:EntyId="" 1
	s NextId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DicId,""))
	Q:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",EntyId,attrID,DicId)) 1
	Q:(NextId="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",EntyId,attrID,DicId))) 1
	s NextId=""
	for  s NextId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DicId,NextId)) Q:(NextId="")||(IsChkFlag=1)  d
	.s:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",EntyId,attrID,NextId)) IsChkFlag=1
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",DicId))  d
	..s IsChkFlag=..IsChkDrugCls(NextId,EntyId,attrID)
	Q IsChkFlag
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJson("","123")
ClassMethod GetChlidTreeJsonNew(pid, input As %String = "", parref As %String, h) As %String
{
	n (pid,input,parref,h)
	
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parentid = parref
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.;q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	.Q:'..IsExistSubNode(dicID,input)
	.s data = dicID_"^"_dicCode_"^"_dicDesc_"^"_parentid
	.s ^TMP("DHCCKB","web.DHCCKBQueryDic","GetTreeJsonNew",pid,parentid,dicID)=data
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d	// 存在子节点
	..d ..GetChlidTreeJsonNew(pid,input,dicID)
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).GetAllTreeJson("","123")
ClassMethod GetAllTreeJson(q As %String = "", parref As %String) As %String
{
	n (q,parref)
	
	s input=$zcvt(q,"U")

	k tmpTreeArr
	s tmpTreeArr=""
	i parref="" d 
	.s knowType =##class(web.DHCCKBCommon).GetKnowType()
	.q:knowType=""
	.s dicID=""
	.f  s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",knowType,dicID)) q:dicID=""  d
	..s linkDr=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",knowType,dicID,""))
	..s linkValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkDr)),4)
	..q:linkValue=""
	..s linkCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkValue)),2)	// 如果是字典，则取字典及其字典下所有数据，如果是属性，则取属性及其下面所有的内容
	..q:linkCode="ModelFlag"
	..//s tmpTreeArr(linkValue)=""
	..s tmpTreeArr(dicID)=""
	e  d
	.s tmpTreeArr(parref)=""

	i '$d(tmpTreeArr) w "[]"
	q:'$d(tmpTreeArr) ""

	w "["
	
	s start=$o(tmpTreeArr(""))
	s end=$o(tmpTreeArr(""),-1)
	s index=""
	f  s index=$o(tmpTreeArr(index))  q:index=""  d
	.d ..GetChlidTreeJson("",index)
	.i (index'=end) w ","
	
	w "]"
	q ""
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJson("","123")
ClassMethod GetChlidTreeJson(q As %String = "", parref As %String) As %String
{
	n (q,parref)
	
	s input=$zcvt(q,"U")
	i parref="" w "[]"
	q:parref="" ""
	
	//w "["
	s count=0
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.i subID'="" d
	..w ",""children"":"
	..w "["
	..D ..GetTreeJson(input,dicID)   ///是否有叶子节点
	..w "]"
	.w "}"
	.//q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	
	//w "]"
	
	q ""
}

/// Creator: 	qunianpeng
/// CreateDate: 2020-06-17
/// Descript: 	获取知识库数据信息
/// Input：		类型(带剂型的通用名)
/// w ##class(web.DHCCKBQueryDic).GetDataList()
ClassMethod GetDataListByParref(TmpArr, parref, loginInfo) As %String
{
	n (TmpArr,parref,loginInfo)
	
	s h=0
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))   q:dicID=""  d
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.q:(0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo))
	.
	.i linkDr'="" d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..q:(linkDr'="")&(0=##class(web.DHCCKBCommon).IsShow(linkDr,"DHC_CKBCommonDiction",loginInfo))
	.
	.s data=dicID_"^"_dicCode_"^"_dicDesc
	.s h=h+1	
	.s TmpArr(h)=data
	
	q ""
}

/// Description:	按照节点加载，展开时加载子节点
/// Creator:		ld 
/// CreateDate:		2022-9-21	
/// Input:			代码^描述 235526
/// other:			w ##class(web.DHCCKBQueryDic).GetTreeJsonDataByNode("","147333")
ClassMethod GetTreeJsonDataByNodeDefRule(Input As %String = "", id As %String) As %String
{
	n (Input,id)
	s parref=id

	//药学类字典按code排序 kml 2020-03-05
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	
	d ..SortCatByCode(parref,pid)		//数据排序

	d ##class(web.DHCCKBQueryDic).GetSortTreeJsonByNodeDefRule(Input, parref,pid)		//树查询
	
	k ^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid)
	Q ""
}

/// Description:	药学分类字典按code排序输出
/// Creator:		ld
/// CreateDate:		2022-9-21	
/// other:			w ##class(web.DHCCKBQueryDic).GetSortTreeJsonByNode("成人","260743",251692)
ClassMethod GetSortTreeJsonByNodeDefRule(Input As %String = "", parref As %String, pid) As %String
{
	n (Input,parref,pid)

	s input=$zcvt(Input,"U")
	i parref="" w "[]"
	q:parref="" ""
	s count=0
	w "["
	//按code排序
	q:+pid=0
	s sortCode="" f  s sortCode=$o(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode)) q:sortCode=""  d
	.s flag=0
	.q:sortCode=""
	.s dicID=$g(^TMP("web.DHCCKBQueryDic","GetTreeJsonData",pid,parref,sortCode))
	.q:+dicID=0
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(dicID)
	.Q:Flag=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.;s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(dicID,input)
	.Q:(ExistFlag=0)&&(dicDesc'[input)&&(dicCode'[input)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(dicID,dicDesc,dicCode,flag)
	.e  d
	..w ","_##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(dicID,dicDesc,dicCode,flag)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.s subFlag=..IsDisabled(dicID, 0)
	.s subFlagNew=..IsDisabledNew(dicID, 0)		//lidong 2022-9-20 引用数据判断是否存在下级节点
	.i (((subID'="")&&(subFlag=1))||(subFlagNew=1)) d
	..i input="" w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	..w ",""children"":"
	..D ..GetSortTreeJsonByNodeDefRule(input,dicID,pid)   ///是否有叶子节点
	.w "}"	
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",parref))  d
	.s DLARowID=""
	.s TempElementId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("TempElement"),""))
	.f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parref,TempElementId,DLARowID)) q:DLARowID=""  d
	..s dicFlag=1
	..s DicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4)
	..s DicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),5) 
	..s DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),2)
	..s:(DicLink'="")&&(DicCode="") DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),2) //kml 2020-02-21
	..s DicCode = $tr(DicCode,$c(10),"")
	..s DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),3)
	..s:(DicLink'="")&&(DicDesc="") DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),3) //kml 2020-02-21
	..s DicDesc = $tr(DicDesc,$c(10),"")
	..Q:(DicDesc'[input)&&(DicCode'[input)
	..s count=count+1
	..i count=1  d
	...w ##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(DicID,DicDesc,DicCode,dicFlag)
	..e  d
	...w ","_##class(web.DHCCKBCommonUtil).getJsonTreeStartNew(DicID,DicDesc,DicCode,dicFlag)
	..w "}"
	w "]"	
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	k ^TMP("DHCCKB","web.DHCCKBQueryDic","GetTreeJsonNew",pid)
}

}
