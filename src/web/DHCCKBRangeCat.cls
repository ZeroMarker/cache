Import SQLUser

/// Creator:sufan
/// CreateDate:2019-06-18
/// Descript:值域分类维护,附加属性维护类
Class web.DHCCKBRangeCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   查询值域分类维护
/// Input：     分类ID
/// w ##class(web.DHCCKBRangeCat).QueryRangeCat("30","1","2851")
ClassMethod QueryRangeCat(rows As %String, page As %String, CatId As %String) As %String
{
	n (rows, page, CatId)
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
	s ID=""
	for  s ID=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",$SYSTEM.Util.Collation(CatId,3),ID)) Q:ID=""  d
	.s CDCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)     //代码
	.s CDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3) 	  //描述
	.s CDType=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),4)	  //上级ID
	.s ListData=ID_"^"_CDCode_"^"_CDDesc_"^"_CDType
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryRangeCat",pid,h)=ListData
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^CDCode^CDDesc^CDType"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryRangeCat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryRangeCat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   查询值域分类树
/// Input：     分类ID
/// w ##class(web.DHCCKBRangeCat).QueryRangeCatTree("^2851")
ClassMethod QueryRangeCatTree(params)
{
	n (params)
	s ^temptets("999")=params
	s queryCode=$p(params,"^",1)
	s queryCode=$ZCVT(queryCode,"U")
	w "["
	s ID=$p(params,"^",2)
	i +ID=0 w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT","部位树根节点")_"}"
	Q:+ID=0 ""
	s count=0
	s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
  	w ##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,text,code)
  	s subID=$o(^CT.CKB.PDSS.CommonDictionD(0,"Type",ID,""))
	i subID'="" D ..GetCheckTreeLeafNote(ID,queryCode)   ///是否有叶子节点
	w "}"
	w "]"
  	q ""
}

/// Descript:  获取叶子节点
/// w ##class(web.DHCCKBRangeCat).GetCheckTreeLeafNote(1)
ClassMethod GetCheckTreeLeafNote(parrefID, queryCode) As %String
{
	n (parrefID,queryCode)
	k treeLeafNote
	///  是否存在孩子节点
	Q:'..isExistChildNote(parrefID) ""
	s count=0
	///  有孩子节点的初始化时收缩
	//w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s subID=""
	f  s subID=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",parrefID,subID)) q:subID=""  d
	.Q:$D(treeLeafNote(subID))
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),3) 
  	.s pinText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(text))
  	.q:(queryCode'="")&(text'[queryCode)&(code'[queryCode)&(pinText'[queryCode)
	.s TreeLeafNote(subID)=subID_"^"_code_"^"_text
	.
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonTreeStart(subID,text,code)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(subID,text,code)
	.d ..GetCheckTreeLeafNote(subID,queryCode)
	.w "}"
	w "]"
	Q ""
}

/// Descript: 是否有孩子节点
/// w ##class(web.DHCCKBRangeCat).isExistChildNote(1)
ClassMethod isExistChildNote(parrefID As %String) As %String
{
	n (parrefID)
	s quitFlag=0
	s sub=""
	f  s sub=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefID,sub)) Q:(sub="")||(quitFlag=1)  D
	.s lastID=+$lg($g(^CT.CKB.PDSS.CommonDictionD(sub)),4)
	.Q:lastID=0
	.s quitFlag=1
	
	q quitFlag
}

/// Creator:    qunianpeng
/// CreateDate: 2019-06-18
/// Descript:   获取实体的属性列表
/// Input：     实体id,关联属性代码(LinkProp)
/// w ##class(web.DHCCKBRangeCat).QueryDicAttr("30","1","5^LinkProp")
ClassMethod QueryDicAttr(rows As %String = 150, page As %String = 1, params As %String)
{
	n (rows, page, params)
	s end = page*rows
	s start=(page-1)*rows+1
	
	s queryDicID = $p(params,"^",1)	// 实体id
	Q:queryDicID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s extraAttr=$p(params,"^",2)    // 关联属性代码(LinkProp)
					
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    //取附加属性的属性关联
    s h=0,count=0
    s extraAttrDr=..GetAttrLink(queryDicID,extraAttr)			//$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(extraAttr),""))
 	i extraAttrDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:extraAttrDr="" ""
	
  	// 找到关联的属性列表，展现属性列表
   	s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,extraAttrDr,""))	// 关联表id
  	i linkID=""  w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
  	q:linkID="" ""

  	s parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 属性值(表，集合) 
  	i parref="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
  	q:parref="" ""
  	
	s attrID=""
	for  s attrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,attrID)) Q:attrID=""  d	
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.i $g(linkDr)'="" d 
	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.s listData=attrID_"^"_code_"^"_desc
	.q:##class(web.DHCCKBCommon).IsEnabled(+attrID)=0     //qunianpeng 20200420  过滤停用数据
	.q:##class(web.DHCCKBCommon).IsEnabled(+linkDr)=0     //qunianpeng 20200420  过滤停用数据
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryDicAttr",pid,h)=listData
		
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^code^desc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryDicAttr",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryDicAttr",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   附加属性维护
/// Input：     属性ID
/// w ##class(web.DHCCKBRangeCat).QueryAddLinkAttr(30,1,"74^KnowType^ExtraProp")
ClassMethod QueryAddLinkAttr(rows As %String, page As %String, params As %String)
{
	n (rows, page, params)

	s End = page*rows
	s Start=(page-1)*rows+1
	s EntyId=$p(params,"^",1)		  		  	//实体ID 
	s extraAttr=$p(params,"^",2)			  	//知识类别代码
	s AddAttrCode=$p(params,"^",3)			  	//属性代码
	s queryCode=$p(params,"^",4)			  	//查询的描述
	s queryCode = $zcvt(queryCode,"U")
	Q:EntyId="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)				
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s Id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AddAttrCode),""))  // 附加属性id
  	
  	///取公共附加属性
	s AttrID=""
	for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),AttrID)) Q:AttrID=""  d
	.s DLADicDr=EntyId		// 关联表实体id  药品->附加属性->知识类型
	.s DLAAttrCodeDr=AttrID	// 关联表AttrCode
	.s DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),2)
	.s DLAAttrCodeCDDesc=""
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),5)
	.s:DLAAttrCodeDr'="" DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),3) 	  //描述
	.s:(DLAAttrCodeCDDesc="")&&(LinkId'="") DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.s pinAttrDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DLAAttrCodeCDDesc))   // wxj 2021-05-20 拼音码检索
	.q:(queryCode'="")&($zcvt(DLAAttrCodeCDDesc,"U")'[queryCode)&(pinAttrDesc'[$zcvt(queryCode,"U"))
	.//取附加属性值  可能有多个
	.s DLAAttrDr="",DLAResult="",DLAAttrDesc=""
	.s ID=""
	.
	.for  s ID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrID,ID))	  Q:ID=""   d	//关联表id
	..s AttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ID)),4) 
	..b ;1111
	..s DLAResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ID)),5)	
	..s AttrDesc=""
	..i +AttrDr'="0" s AttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrDr)),3)
	..s AttrDesc=$s(AttrDesc="Y":"是",AttrDesc="N":"否",1:AttrDesc)
	..q:(+AttrDr'="0")&(AttrDesc="")
	..i +AttrDr="0" s AttrDesc=$s(DLAResult="Y":"是",DLAResult="N":"否",1:DLAResult)
	..i DLAAttrDr="" s DLAAttrDr=AttrDr
	..e  s DLAAttrDr=DLAAttrDr_","_AttrDr
	..i DLAAttrDesc="" s DLAAttrDesc=AttrDesc
	..e  s DLAAttrDesc=DLAAttrDesc_","_AttrDesc
	.s ListData=ID_"^"_DLADicDr_"^"_DLAAttrCodeDr_"^"_DLAAttrCodeCDDesc_"^"_DLAAttrDr_"^"_DLAAttrDesc_"^"_DLAResult_"^"_DLAAttrCode
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryAddLinkAttr",pid,h)=ListData
	
	

	///取特有附加属性 走附加属性的模板关联
	s LinkTempId=##class(web.DHCCKBCommon).GetTempLinkId()			//取模板关联Id  
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,LinkTempId))   d
	.s DlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,LinkTempId,""))
	.s Id=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DlaRowId)),4)
	.s AttrID=""
	.for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(Id,3),AttrID)) Q:AttrID=""  d
	..s DLADicDr=EntyId		// 关联表实体id  药品->附加属性->知识类型
	..s DLAAttrCodeDr=AttrID	// 关联表AttrCode
	..s DLAAttrCodeCDDesc=""
	..s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),5)
	..s:DLAAttrCodeDr'="" DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),3) 	  //描述
	..s:(DLAAttrCodeCDDesc="")&&(LinkId'="") DLAAttrCodeCDDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..s pinAttrDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DLAAttrCodeCDDesc))   // wxj 2021-05-20 拼音码检索
	..q:(queryCode'="")&($zcvt(DLAAttrCodeCDDesc,"U")'[queryCode)&(pinAttrDesc'[$zcvt(queryCode,"U"))
	..s:DLAAttrCodeDr'="" DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrCodeDr)),2)
	..s:(DLAAttrCode="")&&(LinkId'="") DLAAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	..//取附加属性值  可能有多个
	..s DLAAttrDr="",DLAResult="",DLAAttrDesc=""
	..s ID=""
	..for  s ID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrID,ID))	  Q:ID=""   d	//关联表id
	...s AttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ID)),4) 
	...s DLAResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ID)),5)		
	...i +AttrDr'="0" s AttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrDr)),3)
	...i +AttrDr="0" s AttrDesc=$s(DLAResult="Y":"是",DLAResult="N":"否",1:DLAResult)
	...i DLAAttrDr="" s DLAAttrDr=AttrDr
	...e  s DLAAttrDr=DLAAttrDr_","_AttrDr
	...i DLAAttrDesc="" s DLAAttrDesc=AttrDesc
	...e  s DLAAttrDesc=DLAAttrDesc_","_AttrDesc
	..s ListData=ID_"^"_DLADicDr_"^"_DLAAttrCodeDr_"^"_DLAAttrCodeCDDesc_"^"_DLAAttrDr_"^"_DLAAttrDesc_"^"_DLAResult_"^"_DLAAttrCode
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryAddLinkAttr",pid,h)=ListData
	
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult^DLAAttr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryAddLinkAttr",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBRangeCat","QueryAddLinkAttr",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   获取末级分类ID
/// Input：     属性ID
/// w ##class(web.DHCCKBRangeCat).GetLastClass(5303)
ClassMethod GetLastClass(AddAttrID As %String) As %String
{
	n (AddAttrID)
	s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(AddAttrID,3),""))  /// 上一级ID
	Q:+ID=0 AddAttrID
	
	s LastID=..GetLastClass(ID)
	Q LastID
}

/// Creator:    sufan
/// CreateDate: 2019-06-18
/// Descript:   获取末级分类ID
/// Input：     属性ID
/// w ##class(web.DHCCKBRangeCat).QueryAttrValue(5303)
ClassMethod QueryAttrValue(AddAttrID As %String) As %String
{
	n (AddAttrID)
	s count=0
	w "["
	s AttrID=""
	for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",$SYSTEM.Util.Collation(AddAttrID,3),AttrID))  Q:AttrID=""  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	.s tmp=AttrID_"^"_Desc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryRangeCat",pid)
	k ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryAddLinkAttr",pid)
	k ^TMP("DHCCKB","web.DHCCKBRangeCat","QueryDicAttr",pid)
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	取属性关联
/// Input：     实体ID,属性关联CODE
/// Return:		属性关联ID
/// w ##class(web.DHCCKBRangeCat).GetAttrLink(105,"LinkProp")
ClassMethod GetAttrLink(queryDicID, AttrLinkCode)
{
	n (queryDicID,AttrLinkCode)
	s extraAttrDr=""
	s AttrId=""
	for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,AttrId)) Q:(AttrId="")||(extraAttrDr'="")  d
	.s AttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)
	.i AttrLinkCode=AttrCode s extraAttrDr=AttrId
	.Q:extraAttrDr'=""
	.s LinkAttr=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),5)
	.Q:LinkAttr=""
	.s LinkAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttr)),2)
	.I AttrLinkCode=LinkAttrCode s extraAttrDr=AttrId
	Q extraAttrDr
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	取属性关联
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBRangeCat).GetAddAttrCode("77954","LinkProp","49")
ClassMethod GetAddAttrCode(queryDicID, AttrLinkCode, AttrId = "")
{
	n (queryDicID,AttrLinkCode,AttrId)
	s ^temptest("12345")=$lb(queryDicID,AttrLinkCode,AttrId)
	s queryId=""
	i AttrId'=""  d
	.s queryId=..GetFirstLev(AttrId)
	Q:(queryId'="")&&($lg($g(^CT.CKB.PDSS.CommonDictionD(queryId)),2)["ExtraProp") ""    //如果是附加属性，统一弹窗
	
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID))  d			  ///取属性关联
	.s queryDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),5)
	Q:queryDicID="" ""
	
	s TypeId=##class(web.DHCCKBCommon).GetDataType()
	s LinkAttrCode=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",queryDicID,TypeId))  d
	.s dicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,TypeId,""))
	.Q:dicAttrId=""
	.s DataTypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicAttrId)),4)
	.Q:DataTypeId=""
	.s LinkAttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DataTypeId)),2)
	Q LinkAttrCode
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	获取附加属性的源
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","","dicGroupFlag")
ClassMethod GetAddAttrSource(queryDicID, AttrLinkCode, AttrId = "", queryDicCode = "")
{
	n (queryDicID,AttrLinkCode,AttrId,queryDicCode)
	s ^temptest("111")=$lb(queryDicID,AttrLinkCode,AttrId,queryDicCode)
	s queryId=""
	i AttrId'=""  d
	.s queryId=..GetFirstLev(AttrId)
	Q:(queryId'="")&&($lg($g(^CT.CKB.PDSS.CommonDictionD(queryId)),2)["ExtraProp") ""
	i queryDicID="" s queryDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryDicCode),""))
	Q:queryDicID="" ""
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID))  d			  ///取属性关联
	.s queryDicID=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),5)
	
	Q:queryDicID="" ""
	s SourceList=""
	s LinkAttrId=""
	for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,LinkAttrId)) Q:(LinkAttrId="")  d
	.s AttrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),2)
	.Q:AttrLinkCode'=AttrCode
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,LinkAttrId,AttrId))  Q:AttrId=""  d
	..
	..Q:AttrId=""
	..s SourceId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..i SourceList="" s SourceList=SourceId
	..e  s SourceList=SourceList_","_SourceId
	Q SourceList
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	获取附加属性的源
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBRangeCat).GetFirstLev(146460)
ClassMethod GetFirstLev(queryDicID)
{
	n (queryDicID)
	Q:queryDicID="" ""
	s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),4)
	Q:Parref="" queryDicID
	Q:$lg($g(^CT.CKB.PDSS.CommonDictionD(queryDicID)),2)["ExtraProp" queryDicID
	s FistLev=..GetFirstLev(Parref)
	Q FistLev
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBRangeCat).SaveUpdate("39^35^144^144","1")
ClassMethod SaveUpdate(params, flag)
{
	n (params,flag)

	s $ZT="ErrMsg"
	TS
	s Err=0
	s Len=$l(params,"&&")
	for i=1:1:Len  Q:Err'=0  d
	.s TempStr=$p(params,"&&",i)
	.s AttrId=$p(TempStr,"^",1)			//属性ID
	.s AddAttrId=$p(TempStr,"^",2)		//附加属性ID
	.s DataId=$p(TempStr,"^",3)
	.s AddAttrCode=$p(TempStr,"^",5)
	.i flag=1  d
	..s:AddAttrCode'="DataSource" LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,AddAttrId,""))
	..s:AddAttrCode="DataSource" LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",AttrId,AddAttrId,DataId,""))
	.e  d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",AttrId,AddAttrId,DataId,""))
	.i LinkAttrId=""  d
	..s Err=..InsAttrLink(TempStr)
	.e   d
	..s Err=..UpdAttrLink(LinkAttrId,TempStr)
	.Q:Err'=0
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
ErrMsg
	tro
	q -1
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBRangeCat).InsAttrLink()
ClassMethod InsAttrLink(ListData)
{
	n (ListData)
	s AttrId=$p(ListData,"^",1)
	s AddAttrId=$p(ListData,"^",2)
	s DataId=$p(ListData,"^",3)
	s:+DataId=0 DataId=""
	s Text=$p(ListData,"^",4)
	s:+DataId'=0 Text=""
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result) values(:AttrId,:AddAttrId,:DataId,:Text))
	Q SQLCODE
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	保存可编辑附加属性
/// Input：     实体ID,附加属性ID,属性值
/// Return:		0：成功，其他：失败
/// w ##class(web.DHCCKBRangeCat).UpdAttrLink()
ClassMethod UpdAttrLink(LinkAttrId, ListData)
{
	n (LinkAttrId,ListData)
	s AttrId=$p(ListData,"^",1)
	s AddAttrId=$p(ListData,"^",2)
	s DataId=$p(ListData,"^",3)
	s:+DataId=0 DataId=""
	s Text=$p(ListData,"^",4)
	s:+DataId'=0 Text=""
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Dic_Dr=:AttrId,DLA_AttrCode=:AddAttrId,DLA_Attr_Dr=:DataId,DLA_Result=:Text where DLA_RowID=:LinkAttrId)
	Q SQLCODE
}

/// Descript:根据返回的数据源串取对应的下拉框值
/// w ##class(web.DHCCKBRangeCat).GetDataCombo("19,18,22,23,24,21183,22364,22829,22812,26854,17,20,21,20860,22607,26940","LinkProp")
ClassMethod GetDataCombo(DataSource, dicCode)
{
	n (DataSource,dicCode)

	Q:dicCode="" ""
	s count=0
	w "["
	s Len=$l(DataSource,",")
	s dicId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode),""))
	i dicId'=##class(web.DHCCKBCommon).GetDataType() d
	.for i=1:1:Len  d
	..s AttrID=$p(DataSource,",",i)
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	..Q:Desc=""
	..s tmp=AttrID_"^"_Desc
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	e  d
	.for i=1:1:Len  d
	..s SourceId=$p(DataSource,",",i)
	..Q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",SourceId))
	..s AttrID=""
	..for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",SourceId,AttrID)) Q:AttrID=""  d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	...s tmp=AttrID_"^"_Desc
	...s count = count+1
	...i count=1 d
	....w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	是否可用取值
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	删除附加属性
/// Input:		属性ID,附加属性串
/// w ##class(web.DHCCKBRangeCat).CancelAddAttr(10,12)
ClassMethod CancelAddAttr(EntyId, AddAttrList)
{
	n (EntyId,AddAttrList)

	s Err=0
	TS
	s Len=$l(AddAttrList,",")
	for i=1:1:Len  Q:Err'=0  d
	.s AddAttrId=$p(AddAttrList,"^",i)
	.&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:EntyId and DLA_AttrCode=:AddAttrId)
	.s Err=SQLCODE
	.Q:Err'=0
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	根据描述获取id
/// Input:		数据,附加属性
/// 
/// w ##class(web.DHCCKBRangeCat).GetAttrIdList("",35)
ClassMethod GetAttrIdList(ItmList, AddAttr)
{
	n (ItmList,AddAttr)
	Q:ItmList="" "^"
	s DataTypeId=##class(web.DHCCKBCommon).GetDataType()
	s AtrrId="",DataType=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AddAttr,DataTypeId))  d
	.s AtrrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AddAttr,DataTypeId,""))
	.s TypeId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AtrrId)),4)
	.s DataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(TypeId)),2)
	Q:(AtrrId="")||(DataType="textarea") ""_"^"_ItmList
	s IdList=""
	s Len=$l(ItmList,",")
	for i=1:1:Len  d
	.s TempItm=$p(ItmList,",",i)
	.s ItmDesc=TempItm
	.i +ItmDesc=0 s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(TempItm),""))
	.e  s DicId=TempItm
	.i IdList="" s IdList=DicId
	.e  s IdList=IdList_","_DicId
	Q IdList_"^"_IdList
}

}
