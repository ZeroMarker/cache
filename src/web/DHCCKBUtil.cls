Import sqluser

/// Description:	知识图谱工具(功能)类
/// Creator:		QuNianpeng 
/// CreateDate:		2020-04-27	
/// Input:			代码^描述
Class web.DHCCKBUtil Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	通过通用名(相同)自动生成药学分类
/// CreateDate:		2020-04-27
/// Other:			规则：A药有分类1,分类2, B药没有分类, AB的通用名相同, 给B药新增分类1,分类2, 【但凡B药有分类，不管分类是啥,都不新增】
/// w ##class(web.DHCCKBUtil).SetDrugCatByGenerName()
ClassMethod SetDrugCatByGenerName() As %String
{
	k TmpArr
	
	/// 遍历所有的西药,找到通用名的分类,商品名
	d ..QueryGernerNameCat(.TmpArr)	// TmpArr("gener",通用名id,"drugCat")=$lb(分类1,分类2)								
									// TmpArr("gener",通用名id,"proName",药品名id)=$lb(分类1,分类2)
	
	/// 给西药中没有分类的,增加分类
	d ..SetDrugCat(.TmpArr)
	
	q 1
}

/// Description:	遍历所有的西药,找到通用名的分类,商品名
/// CreateDate:		2020-04-27
/// Other:			
ClassMethod QueryGernerNameCat(TmpArr) As %String
{
	n (TmpArr)
	
	s drugDataId=##class(web.DHCCKBCommon).GetDrugData()
	q:+drugDataId=0 ""
	
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,id))	q:id=""   d
	.//q:(id'=24451)&(id'=74968)
	.s drugCatStrId=##Class(web.DHCCKBCommon).GetAlonePhCat(id,1)
	.s generNameStrID=##class(web.DHCCKBCommon).GetGeneralName(id,1)
	.q:$listtostring(generNameStrID)=""
	.f index=1:1:$listlength(generNameStrID)  d
	..s generNameID=$listget(generNameStrID,index)
	..s tmpCatList=$g(TmpArr("gener",generNameID,"drugCat"))
	..s TmpArr("gener",generNameID,"drugCat")=##Class(web.DHCCKBCommonUtil).GetUnionList(tmpCatList,drugCatStrId)
	..s TmpArr("gener",generNameID,"drugName",id)=drugCatStrId
	
	q ""
}

/// Description:	给西药中没有分类的,增加分类
/// CreateDate:		2020-04-27
/// Other:			
ClassMethod SetDrugCat(TmpArr) As %String
{
	n (TmpArr)

	s catPropId=##class(web.DHCCKBCommon).GetPhCategory()
	q:+catPropId=0 ""

	k ^TMP("DHCCKB","web.DHCCKBUtil","SetDrugCat")
	Ts	
	s existFlag=0
	s generNameID=""
	f  s generNameID=$o(TmpArr("gener",generNameID))  q:(generNameID="")||(existFlag=1)  d
	.s drugCatStr=TmpArr("gener",generNameID,"drugCat")
	.q:$listtostring(drugCatStr)=""
	.s drugId=""
	.f  s drugId=$o(TmpArr("gener",generNameID,"drugName",drugId))  q:(drugId="")||(existFlag=1)  d
	..s tmpDrugCat=TmpArr("gener",generNameID,"drugName",drugId)
	..q:$listtostring(tmpDrugCat)'=""	// 药品已经存在分类，则不修改不新增
	..f index=1:1:$listlength(drugCatStr)  q:existFlag=1  d
	...s drugcatId=$listget(drugCatStr,index)
	...s listData="^"_drugId_"^"_catPropId_"^"_"^"_drugcatId
	...s linkID=##class(web.DHCCKBDicLinkAttr).SaveDicAttr(listData) // 保存分类
	...i linkID'=0 s existFlag=1
	...q:existFlag=1	
	...s ^TMP("DHCCKB","web.DHCCKBUtil","SetDrugCat",drugId,drugcatId)=generNameID // 记录保存的内容
	i existFlag=0 tc
	e  tro

	q ""
}

/// Description:	输出新增记录信息
/// CreateDate:		2020-04-27
/// Other:			
Query OutPutRecord() As websys.Query(ROWSPEC = "drugCode:%String:西药代码,drugName:%String:西药名称,generName:%String:通用名,catId:%String:分类id,catName:%String:分类")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBUtil","OutPutRecord") 
/// @param:
ClassMethod OutPutRecordExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,TmpArr)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	set drugId=""	
	for  set drugId=$order(^TMP("DHCCKB","web.DHCCKBUtil","SetDrugCat",drugId)) quit:drugId=""  do
	.s drugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	.s drugCode=$tr(drugCode,",",".")
	.s drugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.s drugDesc=$tr(drugDesc,",",".")
	.s catIdStr="",catNameStr="",generName=""
	.s catId=""
	.f  s catId=$order(^TMP("DHCCKB","web.DHCCKBUtil","SetDrugCat",drugId,catId)) quit:catId=""  do
	..s generID=$g(^TMP("DHCCKB","web.DHCCKBUtil","SetDrugCat",drugId,catId))
	..s generName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+generID)),3)
	..s generName=$tr(generName,",",".")
	..s catName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catId)),3)
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+catId)),5)
	..i linkDr'="" s catName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),5)	
	..i catNameStr="" s catNameStr=catName
	..e  s catNameStr=catNameStr_"、"_catName
	..i catIdStr=""  s catIdStr=catId
	..e  s catIdStr=catIdStr_"、"_catId
	.
	.s catName=$tr(catName,",",".")
	.set listData=drugCode_"^"_drugDesc_"^"_generName_"^"_catIdStr_"^"_catNameStr
	.set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	改变药品指向,属性,规则,日志
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeDrugData(81692,81790,"1^1^1^1^2","113.140.81.66")
ClassMethod ChangeDrugData(drugId, newParref, userInfo, clientIP) As %String
{
	n (drugId,newParref,userInfo,clientIP)
	
	set $ZT="ERROR" // 设置一个异常
	
	TS
	s ret=0,msg=""
	
	// 修改药品的指向(判断当前药品的指向和新的指向是否一致，不一致是修改) -DHC_CKBCommonDiction
	s ret=..ChangeParref(drugId,newParref)
	i ret'=0 d 
	.d  tro
	.s msg="修改药品的指向错误"
	q:ret'=0 -1_"^"_msg
		
	// 药品的属性(CT_CKB_PDSS.DicLinkAttr)
	s ret=..ChangeDicLinkAttr(drugId,newParref,clientIP)
	i ret'=0 d 
	.d  tro
	.s msg="部分药品的属性不存在,不能修改"
	q:ret'=0 -1_"^"_msg
		
    // 规则索引中使用药品的id (CT_CKB_PDSS.RuleDic)
  	s ret=..ChangeRuleDic(drugId,newParref)
   	i ret'=0 d 
	.d  tro
	.s msg="修改规则失败"
  	q:ret'=0 -1_"^"_msg
  	
  	// 日志中使用药品的id (CKB_PDSS.DicLog)
  	s ret=..SetDicLog(drugId, newParref,userInfo,clientIP)
   	i ret'=0 d 
	.d  tro
	.s msg="日志拆入失败"
	e  d 
	.s drugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.d ##Class(websys.Query).ToExcel(drugName,"web.DHCCKBUtil","ExportUpdateData",drugId)
	.d  tc
	
	i ret=0  d
		
	q ret_"^"_msg
	
ERROR
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	set ret=-1
	TROLLBACK	                      
	
	q ret_"^"_ErrorMsg
}

/// Description:	改变药品指向
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// Output:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeParref()
ClassMethod ChangeParref(drugId, newParref) As %String
{
	n (drugId,newParref)
	
	q:(+drugId=0)||(+newParref=0) -1
	s oldParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	
	q:oldParref=newParref -1
	
	&sql(update CT_CKB_PDSS.CommonDiction set CD_Parref_Dr=:newParref where CD_RowID=:drugId)

	q:SQLCODE'=0 -1
	
	q SQLCODE
}

/// Description:	修改药品的属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeDrugData()
ClassMethod ChangeDicLinkAttr(drugId, newParref, clientIP) As %String
{
	n (drugId,newParref,clientIP)

	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+drugId)) 0
	
	s ret=..GetAttrCodeList(drugId,newParref,clientIP)
	q:ret'=0 ret
	
	s ret=..UpdateAttrCode(drugId)
		
	q ret
}

/// Description:	修改属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeDrugData()
ClassMethod GetAttrCodeList(drugId, newParref, clientIP) As %String
{
	
	n (drugId,newParref,clientIP)
	
	s linkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s chineseProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	s drugProp=##class(web.DHCCKBCommon).GetDrugProp()
	s libaryProp=##class(web.DHCCKBCommon).GetDrugLibaryData()
	
	s ret=0,existFlag=0
	s attrCode=""
	f  s attrCode=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+drugId,attrCode))  q:(attrCode="")||(ret'=0)  d
	.s attrCodeParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrCode)),4)
	.q:(attrCodeParref'=chineseProp)&(attrCodeParref'=drugProp)&(attrCodeParref'=libaryProp)
	.q:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrCode,linkPropId))	// attrCode绑定有模板,则不进行修改,如成分link成分属性模板,因为就是直接存储在成分属性上的
	.
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrCode)),5)
	.s linkParref=""
	.i linkDr'="" s linkParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),4)
	.// 西药->中药，中药->西药  前者的属性是药品目录的link形式,后者也是link形式，则直接进行修改
	.i (linkDr'="") d				// 是以link形式生成的属性
	..i (linkParref=libaryProp)  d	// 是目录字典属性的link形式
	...s ret=..GetAttrCodeByLinkDr(drugId,attrCode,linkDr,newParref,clientIP)
	..e  i (linkParref=drugProp) d	// 中药-> 西药 （中药引用了西药的属性）
	...s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode)=linkDr_"^"_$zd($h,3)_"^"_$zt($p($h,",",2))_"^"_clientIP
	..e  i (linkParref=chineseProp) d	// 西药-> 中药（西药引用了中药的属性）
	...s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode)=linkDr_"^"_$zd($h,3)_"^"_$zt($p($h,",",2))_"^"_clientIP
	.
	.e  d	 // 自有属性,如西药的贮藏, 需要再中药中找到link的形式,则返回-1,表示是西药的属性，不能修改
	..s ret=..GetAttrCodeByLinkDr(drugId,attrCode,attrCode,newParref,clientIP)
	
	q ret
}

/// Description:	修改属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeDrugData()
ClassMethod GetAttrCodeByLinkDr(drugId, attrCode, linkDr, newParref, clientIP) As %String
{
	
	n (drugId,attrCode,linkDr,newParref,clientIP)
	q:+linkDr=0 -1
	
	s checkProp=""
	i newParref=##class(web.DHCCKBCommon).GetChineseDrugData()	d
	.s checkProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	e  i newParref=##class(web.DHCCKBCommon).GetDrugData()	d
	.s checkProp=##class(web.DHCCKBCommon).GetDrugProp()	
	
	s newAttrCode=""
	s tmpAttrCode=""
	f  s tmpAttrCode=$o(^CT.CKB.PDSS.CommonDictionI("Link",linkDr,tmpAttrCode))  q:tmpAttrCode=""  d
	.s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpAttrCode)),4)
	.q:(tmpParref'=checkProp)
	.s newAttrCode=tmpAttrCode
	
	q:+newAttrCode=0 -1
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode)=newAttrCode_"^"_$zd($h,3)_"^"_$zt($p($h,",",2))_"^"_clientIP
	q 0
}

/// Description:	修改属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).UpdateAttrCode()
ClassMethod UpdateAttrCode(drugId) As %String
{
	
	n (drugId)
	q:+drugId=0 -1
	
	s ret=0
	s attrCode="" 
	f  s attrCode=$o(^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode))  q:(attrCode="")||(ret=-1)  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode))
	.s newAttrCode=$p(listData,"^",1)
	.&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_AttrCode=:newAttrCode where DLA_Dic_Dr=:drugId and DLA_AttrCode=:attrCode )
	.s:SQLCODE'=0 ret=-1
	
	q ret
}

/// Description:	修改属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).UpdateAttrCodeByLinkDr()
ClassMethod UpdateAttrCodeByLinkDr(drugId, attrCode, linkDr, newParref) As %String
{
	
	n (drugId,attrCode,linkDr,newParref)
	q:+linkDr=0 -1
	
	s checkProp=""
	i newParref=##class(web.DHCCKBCommon).GetChineseDrugData()	d
	.s checkProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	e  i newParref=##class(web.DHCCKBCommon).GetDrugData()	d
	.s checkProp=##class(web.DHCCKBCommon).GetDrugProp()	
	
	s newAttrCode=""
	s tmpAttrCode=""
	f  s tmpAttrCode=$o(^CT.CKB.PDSS.CommonDictionI("Link",linkDr,tmpAttrCode))  q:tmpAttrCode=""  d
	.s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpAttrCode)),4)
	.q:(tmpParref'=checkProp)
	.s newAttrCode=tmpAttrCode
	
	q:+newAttrCode=0 -1

	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_AttrCode=:newAttrCode where DLA_Dic_Dr=:drugId and DLA_AttrCode=:attrCode )

	q:SQLCODE'=0 -1
	
	q SQLCODE
}

/// Description:	修改规则索引中使用药品的id 
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 更新失败  0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).ChangeRuleDic()
ClassMethod ChangeRuleDic(drugId, newParref) As %String
{
	n (drugId,newParref)
	
	q:(+drugId=0)||(+newParref=0) -1
	s oldParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)

	//q:oldParref=newParref -1
	&sql(update CT_CKB_PDSS.RuleDic set RD_DicParent=:newParref where RD_Dic=:drugId)
	
	q:SQLCODE'=0 -1
	
	q SQLCODE
}

/// Description:	更新修改日志
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-06
/// Input:			
/// OutPut:			-1 日志更新成功 0 更新成功
/// Other:			
/// w ##class(web.DHCCKBUtil).SetDicLog()
ClassMethod SetDicLog(drugId, newParref, userInfo, clientIP) As %String
{
	n (drugId,newParref,userInfo,clientIP)
	
	s ret=0
	s dic="DHC_CKBCommonDiction"
	s userID=$p(userInfo,"^",1)
	s ret=##class(web.DHCCKBWriteLog).InsertDicLog(dic,drugId,"edit",userID,"","","","",clientIP,"log")
	
	q:ret'=0 -1
	
	q ret
}

/// Description:	导出修改的属性关联数据
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-07
/// Other:			d ##Class(websys.Query).ToExcel("银片0.32g(黑龙江福和华星制药集团股份有限公司)","web.DHCCKBUtil","ExportUpdateData","81692")
/// w ##Class(websys.Query).ToExcel("CKB_Excel","web.DHCCKBUtil","ExportUpdateData")
Query ExportUpdateData(drugId As %String) As websys.Query(ROWSPEC = "drugId:%String:药品id,drugName:%String:药品名称,attrCode:%String:原属性,newAttrCode:%String:修改后的属性,UpdDate:%String:操作日期,UpdDate:%String:操作时间,IP:%String:IP地址")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBUtil","ExportUpdateData","81692") 
/// @param: 
ClassMethod ExportUpdateDataExecute(ByRef qHandle As %Binary, drugId As %String) As %Status
{
	n (qHandle,drugId)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s qHandle=$lb(0,repid,0)
	k TmpArr

	/// 准备数据
	D ##Class(web.DHCCKBUtil).GetUpdataData(drugId,.TmpArr)
	b //1
	/// 输出数据
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D 
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING($g(TmpArr(index)),"^")
	.s ind=ind+1

	Quit $$$OK
}

/// Description:	导出修改的属性关联数据
/// Creator:		QuNianpeng 
/// CreateDate:		2020-05-07
/// Other:
ClassMethod GetUpdataData(drugId, TmpArr) As %Status
{
	
	n (drugId,TmpArr)
	
	s h=0
	s attrCode=""
	f  s attrCode=$o(^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode))  q:attrCode=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId,attrCode))
	.s $p(listData,"^",3)=""
	.s h=h+1
	.s TmpArr(h)=drugId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)_"^"_attrCode_"^"_listData
	
	k ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",drugId)
	q ""
}

/// w ##class(web.DHCCKBUtil).test()
ClassMethod test()
{
	
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,40)="81836^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,44)="81835^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,3909)="81955^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,3920)="81956^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,3934)="81957^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,3941)="81960^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,4004)="81959^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,26955)="81828^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,74532)="81818^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,77980)="81824^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,78005)="81821^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,78012)="81829^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,78013)="81830^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,78014)="81831^2020-05-07^15:13:34^113.140.81.66"
	s ^TMP("DHCCKB","web.DHCCKBUtil","GetAttrCodeList",81692,78015)="81832^2020-05-07^15:13:34^113.140.81.66"
}

}
