Import sqluser

/// Description:	审查规则忽略操作类
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
Class web.DHCCKBIgnoreManage Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description:	获取所有忽略条件
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			条件标识 D(目录) I(项目)
/// return:			条件列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetAllItm()
ClassMethod GetAllItm(flag, queryCode As %String = "") As %String
{
	n (flag,queryCode)
	
	k TmpArr
	
	i flag = "D" d		// 目录 directory 
	.d ..GetDirectory(.TmpArr)  
	e  i flag = "I"  d	// 项目 item)
	.d ..GetItem(.TmpArr)
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s title = "id^code^desc^flag"
	s index = "",count = 0
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.q:(queryCode'="")&&($p(data,"^",3)'[queryCode)
	.w $case(count,0:"",:",")
	.s count=count+1
	.w ##class(web.DHCEMJsonCommon).getJsonData(title,data)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	
	q ""
}

/// Description:	获取目录
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			
/// return:			目录列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetDirectory()
ClassMethod GetDirectory(TmpArr) As %String
{
	n (TmpArr)
	
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s globalData = ##class(web.DHCCKBCommon).GetGlobalData()	// 全局规则字典
	q:(+drugLibaryData=0)||(+globalData=0) ""
	
	s count = +$o(TmpArr(""),-1)
	s dicID = "" 
	f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",drugLibaryData,dicID))  q:dicID=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+dicID))
	.q:0=##class(web.DHCCKBCommon).IsExistRule(dicID)	// 判断目录下是否有规则
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d
	..d ..GetDicByParref(.TmpArr,dicID)
	.e  d
	..s count = count + 1
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	..s TmpArr(count)=dicID_"^"_dicCode_"^"_dicDesc_"^"_"D"
	
	// 全局规则字典 (暂时不能增加是否有规则的判断)
	s dicID = "" 
	f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",globalData,dicID))  q:dicID=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+dicID))
	.//q:0=##class(web.DHCCKBCommon).IsExistRule(dicID)	// 判断目录下是否有规则
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d
	..d ..GetDicByParref(.TmpArr,dicID)
	.e  d
	..s count = count + 1
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	..s TmpArr(count)=dicID_"^"_dicCode_"^"_dicDesc_"(全局规则)"_"^"_"D"
	
	q ""
}

/// Description:	获取目录下多层数据(递归)
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			
/// return:			目录列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetDicByParref()
ClassMethod GetDicByParref(TmpArr, parref) As %String
{
	n (TmpArr,parref)
	
	q:'$d(^CT.CKB.PDSS.CommonDictionD(+parref)) ""
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",+parref)) ""

	s count = +$o(TmpArr(""),-1)
	s dicID = "" 
	f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+dicID))
	.q:0=##class(web.DHCCKBCommon).IsExistRule(dicID)	// 判断目录下是否有规则
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d
	..d ..GetDicByParref(.TmpArr,dicID)
	.e  d
	..s count = count + 1 
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	..s TmpArr(count)=dicID_"^"_dicCode_"^"_dicDesc_"^"_"D"
	
	q ""
}

/// Description:	获取项目(实体关联的属性)
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			
/// return:			项目列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetItem()
ClassMethod GetItem(TmpArr) As %String
{
	n (TmpArr)
	
	s modelFlag = ##class(web.DHCCKBCommon).GetModelFlag()	// 实体
	s knowType = ##class(web.DHCCKBCommon).GetKnowType()	// 知识类别
	// 所有实体	 //	^CT.CKB.PDSS.DicLinkAttrI("Reverse",+{DLA_Attr_Dr},{DLA_AttrCode},{DLA_RowID})
	s h=0
	s linkID="" 
	f   s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",modelFlag,linkID))  q:linkID=""   d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrD(+linkID))
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",modelFlag,knowType))
	.s dicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)	
	.q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	 // 过滤停用
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+dicID))
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.// 实体关联的属性
	.d ..GetLinkAttrList(.TmpArr,dicID)
	
	
	q ""
}

/// Description:	获取实体关联的属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			
/// return:			属性列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetLinkAttrList()
ClassMethod GetLinkAttrList(TmpArr, queryDicID) As %String
{
	n (TmpArr,queryDicID)
	q:queryDicID="" ""
	//取附加属性的属性关联
	s extraAttr = "LinkProp"
    s extraAttrDr=##class(web.DHCCKBRangeCat).GetAttrLink(queryDicID,extraAttr)			//$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(extraAttr),""))
 	q:extraAttrDr="" ""
	
  	// 找到关联的属性列表，展现属性列表
   	s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,extraAttrDr,""))	// 关联表id
   	q:linkID="" ""
  	s parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 属性值(表，集合) 
   	q:parref="" ""
  	
  	s count = $o(TmpArr(""),-1)
	s attrID = ""
	for  s attrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,attrID)) Q:attrID=""  d	
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.i $g(linkDr)'="" d 
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.s queryDicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+queryDicID)),3)
	.s listData = attrID_"^"_code_"^"_desc_"("_queryDicDesc_")"_"^"_"I"
	.q:##class(web.DHCCKBCommon).IsEnabled(+attrID)=0     //qunianpeng 20200420  过滤停用数据
	.q:##class(web.DHCCKBCommon).IsEnabled(+linkDr)=0     //qunianpeng 20200420  过滤停用数据
	.s count = count + 1
	.//s TmpArr(attrID)=listData
	.s TmpArr(count) = listData
	
	q ""
}

/// Description:	保存忽略规则
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:			Params:以字符"&&"分割,格式为:dicID&&dicID
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBIgnoreManage).SaveReview("ChineseDrugData","24451","D","72")
ClassMethod SaveReview(dataTypeStr As %String, dataValueStr As %String, flag As %String, params As %String) As %String
{
	N (dataTypeStr,dataValueStr,flag,params)
	S err=0
	ts
	
	S len=$L(params,"&&")
	F i=1:1:len D
	.S item=$p(params,"&&",i)
	.S err=..InsReview(dataTypeStr,dataValueStr,flag,item)
	
	i err'=0 tro
	i err=0 tc
	
	Q err
}

/// Description: 	增加忽略规则
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:  	 
/// Return: 	 	保存成功 0,保存失败 非0
/// Others:		 	w ##class(web.DHCCKBIgnoreManage).InsReview()
ClassMethod InsReview(dataType, dataValue, flag, item) As %String
{
	N (dataType,dataValue,flag,item)

 	&SQL(INSERT INTO CF_CKB_PDSS.IgnoreManage(IM_Type, IM_Value,IM_Flag,IM_Item)
 		 VALUES(:dataType,:dataValue,:flag,:item))
 	q:SQLCODE'=0 SQLCODE
 	
 	s imRowId = %ROWID
 	s err = ##Class(web.DHCCKBIgnoreDataPool).syncIgnDataPool(imRowId)
 	q err
}

/// Description: 	删除管理规则
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:  	 
/// Return: 	 	保存成功 0,保存失败 非0
/// Others:		 	w ##class(web.DHCCKBIgnoreManage).DelReview(DelReview)
ClassMethod DelReview(params)
{
	n (params)
	q:params="" "Params没有给值"
	s paramLen = $l(params,"&&")
	ts
	s ret = 0
	f i=1:1:paramLen q:ret'=0  d
	.s rmRowID = $p(params,"&&",i)
	.s ret = ..DelReviewData(rmRowID)
	i ret'=0 tro
	i ret=0 tc
	q ret
}

/// 删除数据
ClassMethod DelReviewData(rmRowID)
{
	n (rmRowID)
	q:rmRowID="" 0
	&sql(DELETE FROM CF_CKB_PDSS.IgnoreManage WHERE IM_RowID = :rmRowID)
	q:SQLCODE'=0 SQLCODE
	
	s err = ##Class(web.DHCCKBIgnoreDataPool).syncIgnDataPool(rmRowID)
 	q err
}

/// Description:	加载已设置的忽略列表
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:			类型(药品、分类..),类型值(阿莫西林、溶媒类)
/// return:			忽略列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetReviewList("DrugData","88598")
ClassMethod GetReviewList(dataType As %String = "", dataValue As %String = "", queryCode As %String = "") As %String
{
	n (dataType,dataValue,queryCode)

	k TmpArr
	i dataType '= "" d
	.d ..GetReviewByType(.TmpArr,dataType,dataValue)
	e  d
	.//d ..GerReviewAll()
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s title = "rmRowID^dataType^dataValueDr^dataValue^item^itemDesc^flag"
	s index = "",count = 0
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.q:(queryCode'="")&&($p(data,"^",6)'[queryCode)
	.w $case(count,0:"",:",")
	.s count=count+1
	.w ##class(web.DHCEMJsonCommon).getJsonData(title,data)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	
	q ""
}

/// Description:	加载已设置的忽略列表(通过类型)
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:			类型(药品、分类..),类型值(阿莫西林、溶媒类)
/// return:			忽略列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetReviewByType()
ClassMethod GetReviewByType(TmpArr, dataType As %String, dataValue As %String) As %String
{
	n (TmpArr,dataType,dataValue)

	q:(dataType="")||(dataValue="") ""
	q:'$d(^CF.CKB.PDSS.IgnoreManageI("TypeValue",dataType,dataValue)) ""

	s dataValueDesc = ""
	s dataValueLinkDr = +$lg($g(^CT.CKB.PDSS.CommonDictionD(+dataValue)),5) 
	i dataValueLinkDr=0 s dataValueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dataValue)),3)
	e  s dataValueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dataValueLinkDr)),3)

	s rmRowID = "",count = 0
	f  s rmRowID = $o(^CF.CKB.PDSS.IgnoreManageI("TypeValue",dataType,dataValue,rmRowID))  q:rmRowID=""   d
	.s item = +$lg($g(^CF.CKB.PDSS.IgnoreManageD(+rmRowID)),4)
	.s linkDr = +$lg($g(^CT.CKB.PDSS.CommonDictionD(+item)),5) 
	.s itemDesc = "",parrefDesc="",parrefID=""
	.i linkDr=0 s itemDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+item)),3),parrefID= $lg($g(^CT.CKB.PDSS.CommonDictionD(+item)),4)
	.e  s itemDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3),parrefID= $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),4)
	.s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parrefID)),2)
	.i parrefDesc["GlobalData" s itemDesc=itemDesc_"("_"全局规则"_")"
	.s flag = $lg($g(^CF.CKB.PDSS.IgnoreManageD(+rmRowID)),5)
	.s flag = $select(flag="D":"目录",flag="I":"项目",1:"")
	.s count = count + 1
	.s TmpArr(count) = rmRowID_"^"_dataType_"^"_dataValue_"^"_dataValueDesc_"^"_item_"^"_itemDesc_"^"_flag

	q ""
}

/// Description:	通过数据源反向找到属性
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-28
/// Input:			字典类型
/// return:			属性列别
/// other:			w ##class(web.DHCCKBIgnoreManage).GetPropByDataSource("DrugData")
ClassMethod GetPropByDataSource(dataType As %String) As %String
{
	n (dataType)
	
	s dataTypeDr = ##class(web.DHCCKBCommon).GetDicIdByCode(dataType)
	s dataSource = ##class(web.DHCCKBCommon).GetDataSource()
	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dataTypeDr,dataSource)) ""
	s attrList = ""
	s linkRowID = ""	// 通过数据源属性关联的数据字典,反向找到该属性
	f  s linkRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dataTypeDr,dataSource,linkRowID))	q:linkRowID=""  d
	.s dicDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkRowID)),2)
	.q:+dicDr=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(dicDr))
	.s $list(attrList,*+1) = dicDr
	
	q attrList
}

/// Description:	加载已设置的忽略列表
/// Creator:		Shy
/// CreateDate:		2022-6-29
/// Table:		 	CF_CKB_PDSS.IgnoreManage
/// Input:			
/// return:			忽略列表
/// other:			w ##class(web.DHCCKBIgnoreManage).GetIgnoreData(20,1,"溶媒")
ClassMethod GetIgnoreData(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s title="Type^Code^Desc^Dosform"
	s imRowId=0
	s count=0
	f  s imRowId=$o(^CF.CKB.PDSS.IgnoreManageD(imRowId)) q:imRowId=""  d
	.s imItem = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),4)
	.q:+imItem=0 		;没有指向的
	.s imType = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),2)
	.s imValue = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),3)
	.s imValue = $lg($g(^CT.CKB.PDSS.CommonDictionD(imValue)),3)
	.s imItem = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),4)
	.s imFlag = $lg($g(^CF.CKB.PDSS.IgnoreManageD(imRowId)),5)
	.s imFlag = $select(imFlag="D":"目录",imFlag="I":"项目",1:"")
	.s linkDr = +$lg($g(^CT.CKB.PDSS.CommonDictionD(+imItem)),5) 
	.s itemDesc = ""
	.i linkDr=0 s itemDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+imItem)),3)
	.e  s itemDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(imRowId))
	.s:imValue="" imValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(imRowId)),3)
	.q:imValue'[params
	.s data=imType_"^"_imValue_"^"_itemDesc_"^"_imFlag
	.s count=count+1
	.q:(count<Start)||(count>End)
	.i count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,data)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,data)
	
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)

	q ""
}

}
