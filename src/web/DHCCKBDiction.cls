Import sqluser

Class web.DHCCKBDiction Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取所有的实体(combobox)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).GetDicComboboxList("","KnowType","DictionFlag")
ClassMethod GetDicComboboxList(q As %String = "", extraAttr, extraAttrValue, drugType = "") As %String
{
	n (q,extraAttr,extraAttrValue,drugType)
	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	i extraAttrDr="" w "[]"	
	q:extraAttrDr="" ""

	w "["
	s count=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID))  q:dicID=""   d
	.q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)
	.s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID))  q:linkID=""   d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	..q:attrDr=""
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),2)	// 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))
	..
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..q:1=##class(web.DHCCKBCommon).CheckDrugType(drugType,dicDesc)	// 增加药品类型过滤 qnp 2021/6/24
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..s parrefDesc=""
	..s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	..s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..s linkDesc=""
	..s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)&(dicDesc'[queryCode)&(pinDicDesc'[queryCode)
	..s listData=dicID_"^"_dicDesc
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)	

	w "]"

	q ""
}

/// Description:	查询实体字典列表
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-21	
/// Input:			代码^描述^分类
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicList(100,1,"^^")
ClassMethod QueryDicList(rows, page, params As %String = "") As %String
{
	n (rows,page,params)

	s end = page*rows
	s start=(page-1)*rows+1
	
	s queryCode = $p(params,"^",1)
	s queryDesc = $p(params,"^",2)
	s queryDesc = $zcvt(queryDesc,"U")

	s queryType = $p(params,"^",3)	// type可传id,可传代码. 传代码时转换为id
	i (+queryType = 0)&&(queryType '="") d
	.i $d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryType))) d
	..s queryType = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryType),""),-1)
	.e  d 
	..s queryType = ""
 	
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)
	s h=0
	
	// 使用代码查询
	i (queryCode'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryCode))))  d
	.s dicID = ""
	.f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryCode),dicID))  q:dicID=""  d
	..q:+dicID=0
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s dicType = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..q:(queryType'="")&&(queryType'=dicType)
	..s dicTypeDesc=""
	..s:+dicType'=0 dicTypeDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicType)),3)
	..s h = h + 1
	..s exitFlag = 1
	..s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid,h)=dicID_"^"_dicCode_"^"_dicDesc_"^"_dicType_"^"_$g(dicTypeDesc)
	
	// 使用描述查询
	i (queryDesc'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(queryDesc))))&(h=0)  d
	.s dicID = ""
	.f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(queryDesc),dicID))  q:dicID=""  d
	..q:+dicID=0
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s dicType = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..q:(queryType'="")&&(queryType'=dicType)
	..s dicTypeDesc=""
	..s:+dicType'=0 dicTypeDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicType)),3)
	..s h = h + 1
	..s exitFlag = 1
	..s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid,h)=dicID_"^"_dicCode_"^"_dicDesc_"^"_dicType_"^"_$g(dicTypeDesc)
		
	i h'=0  d writeData 
	q:h'=0 ""
		
	// 查询全部
	i (h=0) d 
	.s dicID = ""    
	.f  s dicID = $o(^CT.CKB.PDSS.CommonDictionD(dicID))  q:dicID=""  d
	..q:dicID=0
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..q:(queryCode'="")&(dicCode'[queryCode)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..q:(queryDesc'="")&(dicDesc'[queryDesc)&(pinDicDesc'[queryDesc)
	..s dicType = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..q:(queryType'="")&&(queryType'=dicType)
	..s dicTypeDesc=""
	..s:+dicType'=0 dicTypeDesc= $lg($g(^CT.CKB.PDSS.CommonDictionD(dicType)),3)
	..s h = h + 1
	..s exitFlag = 1
	..s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid,h)=dicID_"^"_dicCode_"^"_dicDesc_"^"_dicType_"^"_$g(dicTypeDesc)
	
	i h'=0  d writeData 
	q:h'=0 ""
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q ""
	
writeData
	s count=0
	s ListTitle="ID^Code^Desc^TypeDr^Type"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符
}

/// Description:	保存或修改(用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-21	
/// Input:			id^代码^描述,知识类型^实体标记
/// return:			
/// other:			w ##class(web.DHCCKBDiction).SaveUpdate("^OtherNameProp^别名^23^26947","")
ClassMethod SaveUpdate(params As %String = "", attrData As %String = "") As %String
{
	n (params,attrData)

	s len = $l(params,"&&")
	s ret = 0

	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s dicID = $p(tmpstr,"^",1)
	.s dicCode = $p(tmpstr,"^",2)
	.s dicDesc = $p(tmpstr,"^",3)
	.s parref = $p(tmpstr,"^",4)
	.s dicLinkDr =$p(tmpstr,"^",5)
	.i dicLinkDr'="" s dicCode="",dicDesc=""
	.//s flag = ..CheckRepeat(dicID,dicCode,dicDesc)
	.s flag =..CheckDictionRepeat(dicID,dicCode,dicDesc,parref)
	.s ret = flag
	.q:flag'=0
	.
	.//kml 2020-03-10
	.s catDataID=##class(web.DHCCKBCommon).GetDrugCategoryData() //药学分类字典 kml
	.s isCat=..CheckSupTree(parref, catDataID) //保存的字典是否属于药学分类
	.i isCat=1  d
	..s linkID=##class(web.DHCCKBDiction).CheckTreeRepeat(dicDesc, catDataID) //kml 重复元素的id
	..i (+linkID'=0)&&(+catDataID'=0)  d //kml
	...s $p(tmpstr,"^",5)=linkID //kml
	.
	.i $p(tmpstr,"^",1)="" d
	..s ret = ..SaveDic(tmpstr)		// ret是id
	..if (ret > 0)&(attrData'="")	 d
	...s ret=..SaveLinkAttr(ret,attrData)	// 若知识类型和实体标记不存在,则自动插入  ret是SQLCODE
	..
	.
	.e  d
	..s ret = ..UpdateDic(tmpstr)	// ret是SQLCODE
	
	q ret
}

/// Description:	保存或修改(用)
/// Creator:		kemaolin
/// CreateDate:		2020-03-09	
/// Input:			id^代码^描述,知识类型^实体标记
/// return:			0 成功，其他 失败
/// other:			w ##class(web.DHCCKBDiction).SaveUpdateNew("^B.Braun Melsungen AG^B.Braun Melsungen AG^113","","1^1^1^1^2","113.140.81.66")
ClassMethod SaveUpdateNew(params As %String = "", attrData As %String, LoginInfo = "", ClientIPAddress = "") As %String
{
	n (params,attrData,LoginInfo,ClientIPAddress)
	
	s len = $l(params,"&&")
	s ret = 0
	s LgUserID=$p($g(LoginInfo),"^",1)
	s LgHospID=$p($g(LoginInfo),"^",5)
	
	TS
	f i = 1:1:len q:(ret<0)  d
	.s tmpstr = $p(params,"&&",i)
	.s dicID = $p(tmpstr,"^",1)
	.s dicCode = $p(tmpstr,"^",2)
	.s dicDesc = $p(tmpstr,"^",3)
	.s dicCode = $replace(dicCode,"（","(")   //sufan 2020-04-23 转换括号
	.s dicCode = $replace(dicCode,"）",")")
	.s dicDesc = $replace(dicDesc,"（","(")
	.s dicDesc = $replace(dicDesc,"）",")")
	.s parref = $p(tmpstr,"^",4)
	.s dicLinkDr =$p(tmpstr,"^",5)
	.i dicLinkDr'="" s dicCode="",dicDesc=""
	.//s flag = ..CheckRepeat(dicID,dicCode,dicDesc)
	.// 根据parref判断是否需要自动生成编码(字典数据需要生成编码) qnp 20230509
	.i +dicID=0 d 
	..s dicCode = ..GetSysCodeByType(parref,dicCode) 
	..s $p(tmpstr,"^",2)=dicCode
	.s flag =..CheckDictionRepeat(dicID,dicCode,dicDesc,parref)
	.s ret = flag
	.q:flag'=0
	.//kml 2020-03-10
	.s catDataID=##class(web.DHCCKBCommon).GetDrugCategoryData() //药学分类字典 kml
	.s isCat=..CheckSupTree(parref, catDataID) //保存的字典是否属于药学分类
	.i isCat=1  d
	..s linkID=##class(web.DHCCKBDiction).CheckTreeRepeat(dicDesc, catDataID) //kml 重复元素的id
	..i (+linkID'=0)&&(+catDataID'=0)  d //kml
	...s $p(tmpstr,"^",5)=linkID //kml
	.
	.i $p(tmpstr,"^",1)="" d
	..s id = ..SaveDic(tmpstr)		// ret是id
	..i (id>0)&&(attrData'="")	d ..SaveDataMaxNo(attrData,dicCode,dicDesc)	//  根据attrData判断是不是字典。是则需要生成maxno qnp 2023-05-09
	..s ret=id
	..if (ret > 0)	 d
	...s ret=..SaveLinkAttr(ret,attrData)	// 若知识类型和实体标记不存在,则自动插入  ret是SQLCODE
	..i ret=0  d 
	...s ret=##class(web.DHCCKBWriteLog).SaveDicLog(id,LgUserID,LgHospID,"add",ClientIPAddress) // ret是SQLCODE
	..i ret=0  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", id, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"acc")
	.
	
	 
	.e  d
	..i ((parref=105)||(parref=81790)||(parref=81862)||(parref=111)||(parref=110))   d     ///西药105  中成药 81790  饮片  81862  用药频率  111  给药途径  110  为这几个字典时，才更新关联表
	...s extFlag=..CheckContrastExt(tmpstr) //ld 判断关联表内是否存在关联 2022-8-15
	...i extFlag'=0  d ///ld  extFlag为关联表内关联个数 2022-8-15
	....s ret=..UpdContrast(tmpstr) ///ld 更新关联表 2022-8-15
	..s ret = ..UpdateDic(tmpstr)	// ret是SQLCODE
	..i ret=0 d
	...s ret=##class(web.DHCCKBWriteLog).SaveDicLog(dicID,LgUserID,LgHospID,"edit",ClientIPAddress) // ret是SQLCODE
	. 
	
	i ret=0 tc
	i ret'=0 tro
	
	q ret
}

/// Description:	保存实体字典表（用）
/// Creator:		QuNianpeng 
/// CreateDate:		2016-06-20	
/// Input:			id^代码^描述^父节点id^关联id
/// return:			大于0 成功 小于0 失败
/// other:			w ##class(web.DHCCKBDiction).SaveDic("^注射用兰索拉唑30mg（武汉普生制药有限公司）^注射用兰索拉唑30mg（武汉普生制药有限公司）^81790")
ClassMethod SaveDic(params As %String) As %String
{
	
	n (params)	
	
	s dicCode = $p(params,"^",2)
	s dicDesc = $p(params,"^",3)
	s parrefDr = $p(params,"^",4)
	s dicLinkDr = $p(params,"^",5)
	s dicCode = $replace(dicCode,"（","(")   //sufan 2020-04-23 转换括号
	s dicCode = $replace(dicCode,"）",")")
	s dicDesc = $replace(dicDesc,"（","(")
	s dicDesc = $replace(dicDesc,"）",")")
	i dicLinkDr'="" d
	.s dicCode=""
	.s dicDesc=""	
	&sql(insert into CT_CKB_PDSS.CommonDiction (CD_Code,CD_Desc,CD_Parref_Dr,CD_Link_Dr) values (:dicCode,:dicDesc,:parrefDr,:dicLinkDr))

	q %ROWID	
	//q SQLCODE
}

/// Description:	更新实体字典表（用）
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-20	
/// Input:			id^代码^描述^父节点id^关联id
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).UpdateDic()
ClassMethod UpdateDic(params As %String = "") As %String
{
	
	n (params)
	
	s dicID = $p(params,"^",1)
  	s dicCode = $p(params,"^",2)
  	s dicDesc = $p(params,"^",3)
  	s dicTypeDr = $p(params,"^",4)
	s dicLinkDr = $p(params,"^",5)
	
	s dicCode = $replace(dicCode,"（","(")   //sufan 2020-04-23 转换括号
	s dicCode = $replace(dicCode,"）",")")
	s dicDesc = $replace(dicDesc,"（","(")
	s dicDesc = $replace(dicDesc,"）",")")

	&sql(update CT_CKB_PDSS.CommonDiction set CD_Code=:dicCode,CD_Desc=:dicDesc,CD_Parref_Dr=:dicTypeDr,CD_Link_Dr=:dicLinkDr where CD_RowID=:dicID )
	
	q SQLCODE
}

/// Description:	保存关联属性（用）
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-20	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).UpdateDic()
ClassMethod SaveLinkAttr(dicID As %String = "", attrData) As %String
{
	
	n (dicID,attrData)

	s extraAttr = $p(attrData,"^",1)		// 知识类型
	s extraAttrValue = $p(attrData,"^",2)	// 知识类型值
	q:(extraAttr="")&(extraAttrValue="") 0	// 没传值时则默认不插属性关联表
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr) // $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(extraAttr),""))
	s extraAttrValueDr =  ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttrValue) //$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(knowType),""))	

	s extraAttrDesc="知识类别"
	s extraAttrValueDesc=$case(extraAttrValue,"ModelFlag":"实体类别","AttrFlag":"属性类别","DictionFlag":"字典类别")

	i extraAttrDr=0 d
	.s extraAttrDr=..SaveDic("^"_extraAttr_"^"_extraAttrDesc)

	i extraAttrValueDr=0 d
	.s extraAttrValueDr=..SaveDic("^"_extraAttrValue_"^"_extraAttrValueDesc)
	

	s listData = "^"_dicID_"^"_extraAttrDr_"^"_extraAttrValueDr

	s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(listData)

	q ret
}

/// Description:	删除实体
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-21	
/// Input:			实体id
/// return:			0成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).DeleteDic(122)
ClassMethod DeleteDic(dicID) As %String
{
	n (dicID)
	
	s flag=..IsUsedByRule(dicID)
	q:flag'=0 "-1"
	
	&sql(delete from CT_CKB_PDSS.CommonDiction where CD_RowID=:dicID)

	q SQLCODE
}

/// Descript:	 判断节点是否被引用
/// Creator:	sufan
/// CrateDate:	2020-03-27
/// Input:	ParentId
/// Output:1：可用，0：不可用
/// w ##class(web.DHCCKBDiction).IsDicUsed(21632)
ClassMethod IsDicUsed(DicIdList)
{
	n (DicIdList)
	s Len=$l(DicIdList,"^")
	s Err=0
	for i=1:1:Len  Q:Err'=0  d
	.s DicId=$p(DicIdList,"^",i)
	.s Err=..UsedDic(DicId)
	.Q:Err'=0
	Q Err
}

/// Description:	判断实体是否被引用
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-02-04	
/// Input:			实体id
/// return:			0没引用 非0 被引用
/// other:			w ##class(web.DHCCKBDiction).UsedDic(81302)
ClassMethod UsedDic(dicID) As %String
{
	n (dicID)
	
	s flag=..IsUsedByRule(dicID)
	q:flag'=0 "-1"

	q "0"
}

/// Desc:是否被引用
/// Debug: w ##class(web.DHCCKBWriteLog).ifreference("20")
ClassMethod ifreference(dataDr) As %String
{
	n (dataDr)
	s reference=0
	q:dataDr=""
	s num=$d(^CT.CKB.PDSS.CommonDictionI("Link",dataDr))
	if (num>0){
		 s reference=1
		 q reference
	}
	q reference
}

/// Description:	删除字典做判断 w ##class(web.DHCCKBDiction).IsUsedByRule(81302)
/// 
ClassMethod IsUsedByRule(dicID)
{

	n (dicID)
	
	s reference=..ifreference(dicID)   //判断是否被引用  wangxin 2020-12-9
	q:reference=1 "-1"

	s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),4)
	s drugLibaryDataID=##class(web.DHCCKBCommon).GetDrugLibaryData()
	q:tmpParref=drugLibaryDataID 0	// 药品目录字典暂时不判断是否引用,临时使用 qnp 2020-3-31
	
	//^CT.CKB.PDSS.RuleDataI("RightDic",{RD_RightType},+{RD_RightDic},{RD_Rule},{RD_RowID})
	//^CT.CKB.PDSS.RuleDataI("RightExt",{RD_RightType},+{RD_RightExt},{RD_Rule},{RD_RowID})
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibary()
	
	s flag=0
	// 规则列
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  q:rightType=""  d
	.i $d(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,dicID))  s flag=1

	//规则中单位列
	s rightType=""
	f  s rightType=$o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  q:rightType=""  d
	.i $d(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,dicID))  s flag=2

	// 关联关系1
	// ^CT.CKB.PDSS.DicLinkAttrI("Reverse",+{DLA_Attr_Dr},{DLA_AttrCode},{DLA_RowID})
	i $d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dicID))  s flag=3

	// 关联关系2
	// ^CT.CKB.PDSS.DicLinkAttrI("LinkDic",{DLA_Dic_Dr},{DLA_RowID})
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID))  d
	.s Id=""
	.for  s Id=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,Id))  Q:(Id="")||(flag=4)  d
	..s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Id)),4)
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Id)),5)			//备注 sufan 20200415
	..Q:(AttrId="")&&(Res="")
	..s Desc=""
	..s:AttrId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	..Q:(Desc="Y")||(Desc="N")
	..s flag=4
	
	q flag
}

/// Description:	删除码表及其所有的子节点
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-28	
/// Input:			实体id
/// return:			0成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).DeleteAllDic("154")
ClassMethod DeleteAllDic(dicID) As %String
{
	n (dicID)
	
	TS
	
	s err=0
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d
	.s err=..DeleteDic(dicID)
	.q:err'=0
	.s subDicID=""  f   s subDicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,subDicID))  q:(subDicID="")||(err'=0)  d
	..q:subDicID="" 
	..q:err=..DeleteDic(subDicID)
	e  d
	.s err=..DeleteDic(dicID)
	
	i err'=0 tro
	q:err'=0 err
	
	TC
	q err
}

/// Description:	判断实体是否有子节点，子节点是否关联属性或附加属性。 
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-01	
/// Input:			实体id
/// return:			0有子节点或关联关系  1 无节点或无关联关系
/// other:			w ##class(web.DHCCKBDiction).CheckDicLink(122)
ClassMethod CheckDicLink(dicID) As %String
{
	n (dicID)
	s ret=1
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicID))  d			// 存在子节点
	.s ret=0
	
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID))  d	// 存在关联属性或附加属性
	.s ret=0
		
	q ret
}

/// Description:	通过类型id查询实体
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-21	
/// Input:			分类
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicListCombobox("")
ClassMethod QueryDicListCombobox(q As %String = "") As %String
{
	n (q)
	
	s input = q
	s input = $zcvt(input,"U")
	
	s count = 0
	w "["
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionD(dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",dicID_"^"_dicDesc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",dicID_"^"_dicDesc)

	w "]"	

	q ""
}

/// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// ////////////新///////
/// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Description:	通过附加属性和附加值 获取属性(tree)(用new)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-14	
/// Input:			代码/描述
/// return:			数据集
/// other:			w ##class(web.DHCCKBDiction).QueryProTreeListByAttrCode("","","KnowType","AttrFlag")
/// w ##class(web.DHCCKBDiction).QueryProTreeListByAttrCode("数","","KnowType","DictionFlag")
ClassMethod QueryProTreeListByAttrCode(params As %String = "", parref As %String = "", extraAttr, extraAttrValue) As %String
{
	n (params,parref,extraAttr,extraAttrValue)
	s queryCode = $p(params,"^",1)
	s queryCode = $zcvt(queryCode,"U")
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	i extraAttrDr="" w "[]"	
	q:extraAttrDr="" ""
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s count=0
	s h=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID))  q:dicID=""   d
	.s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID))  q:linkID=""   d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	..q:attrDr=""
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),2)	// 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..Q:+parref'="0"
	..s parrefDesc=""
	..s:+parref'="0" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	..s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..s linkDesc=""
	..s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..q:0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction","")
	..q:(+linkDr'=0)&(0=##class(web.DHCCKBCommon).IsShow(linkDr,"DHC_CKBCommonDiction",""))	// 授权过滤 qunianpeng 2020/4/9
	..//s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..//q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)
	..//q:(queryDesc'="")&&((dicDesc'[queryDesc)&(pinDicDesc'[queryDesc))
	..//过滤停用数据   入参新加：hospID, groupID, locID, userID
	..s count=count+1
	..s ordNum=dicID
  	..s tmpArr(ordNum)=dicID_"^"_dicDesc_"^"_dicCode

	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)
	d ..GetSortAttrData(.tmpArr,pid)			///sufan 2020-04-07存临时global排序
	d ..QueryAttrTree(.tmpArr,pid,queryCode)						///sufan 2020-04-07取数据
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)
  	q ""
}

/// Descript:属性排序
/// Creator:sufan
/// CreateDate:2020-04-07
/// Input:知识类别Id
ClassMethod GetSortAttrData(tmpArr, pid)
{
	n (tmpArr,pid)
	
	s Index=""
	for  s Index=$o(tmpArr(Index))  Q:Index=""  d
	.s ID=+$g(tmpArr(Index))
  	.q:'$d(^CT.CKB.PDSS.CommonDictionD(ID))
  	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",ID))  d
  	..d ..SortAttrByOrd(ID,pid)
  	Q ""
}

/// Descript:属性排序
/// Creator:sufan
/// CreateDate:2020-04-07
/// Input:知识类别Id
/// w ##class(web.DHCCKBDiction).SortAttrByOrd(19,1,0)
ClassMethod SortAttrByOrd(ParentId, pid, count = 0)
{
	n (ParentId,pid, count)
	s OrdNumAttrId=##class(web.DHCCKBCommon).GetOrdNumId()				//顺序号属性
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,Id)) Q:Id=""  d
	.s OrdNum=""
	.s count=count+1
	.s Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),5)
	.s:LinkId'="" Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkId)),3)
	.q:0=##class(web.DHCCKBCommon).IsShow(Id,"DHC_CKBCommonDiction","")	// qunianpeng 2020/4/9 增加过滤
	.q:(+LinkId'=0)&(0=##class(web.DHCCKBCommon).IsShow(LinkId,"DHC_CKBCommonDiction",""))
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Id,OrdNumAttrId))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Id,OrdNumAttrId,""))
	..s OrdNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)*10000+count
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.e  d
	..s OrdNum=90000000
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)+count
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.s ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,ParentId,OrdNum)=Id
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Id))  d
  	..d ..SortAttrByOrd(Id,pid,.count)
  	Q ""
}

/// Descript:按排序取数据
/// Creator:sufan
/// CreateDate:2020-04-07
/// Input：属性串，pid
ClassMethod QueryAttrTree(tmpArr, pid, queryCode)
{
	n (tmpArr,pid,queryCode)
	w "["
	s count=0
  	s index=""
  	f  s index=$o(tmpArr(index)) Q:index=""  D
  	.s ID=+$g(tmpArr(index))
  	.q:'$d(^CT.CKB.PDSS.CommonDictionD(ID))
  	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
  	.Q:'..isExistAliaOnChildnode(ID,queryCode)
  	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
    .///  是否存在孩子节点
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ID,""))
	.i subID'="" D ..GetTreeSubNote(ID,pid,queryCode)   ///是否有叶子节点
	.;w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()	
	.w "}"
	
	/// 如果分类树为空,显示默认根节点
	i count=0 w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign("ROOT","属性根节点")_"}"
	
	w "]"
}

/// Descript:  获取叶子节点
/// w ##class(web.DHCCKBDiction).GetCheckTreeLeafNote(1)
ClassMethod GetTreeSubNote(parrefID, pid, queryCode) As %String
{
	n (parrefID,pid,queryCode)
	k treeLeafNote
	///  是否存在孩子节点
	Q:'..isExistChildNote(parrefID) ""
	s count=0
	///  有孩子节点的初始化时收缩
	//w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s Index=""
	f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,parrefID,Index)) q:Index=""  d
	.s subID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,parrefID,Index))
	.Q:$D(treeLeafNote(subID))
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),3) 
  	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),5)
  	.i linkDr'="" d
  	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
  	..s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
  	.
  	.s pinText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(text))
  	.;q:(queryCode'="")&(text'[queryCode)&(QuitCode'[queryCode)&(pinText'[queryCode)
  	.q:code=""
  	.Q:'..isExistAliaOnChildnode(subID,queryCode)   //sufan 2019-11-08
	.s TreeLeafNote(subID)=subID_"^"_code_"^"_text
	.
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(subID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(subID,text,code)
	.d ..GetTreeSubNote(subID,pid,queryCode)
	.w "}"
	w "]"
	Q ""
}

/// Descript:顺序号补位 按12位处理
/// w ##class(web.DHCCKBDiction).GetOrdNum(222)
ClassMethod GetOrdNum(OrdNum)
{
	n (OrdNum)
	s Len=$l(OrdNum)
	for i=1:1:12-Len  d
	.s OrdNum=0_OrdNum
	Q OrdNum
}

/// Descript:  获取叶子节点
/// w ##class(web.DHCCKBDiction).GetCheckTreeLeafNote(1)
ClassMethod GetCheckTreeLeafNote(parrefID, queryCode, hospID, groupID, locID, userID) As %String
{
	n (parrefID,queryCode,hospID, groupID, locID, userID)
	k treeLeafNote
	///  是否存在孩子节点
	Q:'..isExistChildNote(parrefID) ""
	s count=0
	///  有孩子节点的初始化时收缩
	//w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s subID=""
	f  s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefID,subID)) q:subID=""  d
	.Q:$D(treeLeafNote(subID))
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.q:##class(web.DHCCKBCommon).GetStopDicData(subID,hospID,groupID,locID,userID)=1
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),3) 
  	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(subID)),5)
  	.i linkDr'="" d
  	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
  	..s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
  	.
  	.s pinText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(text))
  	.;q:(queryCode'="")&(text'[queryCode)&(QuitCode'[queryCode)&(pinText'[queryCode)
  	.q:code=""
  	.Q:'..isExistAliaOnChildnode(subID,queryCode)   //sufan 2019-11-08
	.s TreeLeafNote(subID)=subID_"^"_code_"^"_text
	.
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(subID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(subID,text,code)
	.d ..GetCheckTreeLeafNote(subID,queryCode,hospID, groupID, locID, userID)
	.w "}"
	w "]"
	Q ""
}

/// Descript: 是否有孩子节点
/// w ##class(web.DHCCKBDiction).isExistChildNote(1)
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

/// Description:	判断子节点是否包含检索条件
/// CreateDate:		2019-11-05	
/// Input:			id,检索条件
/// return:			1:包含,0:不包含
/// other:			w ##class(web.DHCCKBDiction).isExistAliaOnChildnode(25,"77")
ClassMethod isExistAliaOnChildnode(parrefID, queryCode)
{
	n (parrefID, queryCode)
	s isExistFlag=0
	s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefID,""))		//先判断本身
	i SubId=""  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(parrefID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(parrefID)),3) 
  	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(parrefID)),5)
  	.i linkDr'="" d
  	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
  	..s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
  	.s pinText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(text))
  	.s:(text[queryCode)||(code[queryCode)||(pinText[queryCode) isExistFlag=1
  	Q:SubId="" isExistFlag
  	s SubID=""
	f  s SubID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefID,SubID))  q:(SubID="")||(isExistFlag=1)  d
	.s isExistFlag=..isExistAliaOnChildnode(SubID,queryCode)
	.
	Q isExistFlag
}

/// Description:	查询实体字典列表（用 new）
/// Creator:		QuNianpeng 
/// CreateDate:		2018-08-21	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）    referenceFlag：未引用标记 xww 
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicByID("30","1","105","","","","")
ClassMethod QueryDicByID(rows, page, id As %String = "", parrefFlag As %String = "", parDesc = "", loginInfo = "", dataMirFlag = "", referenceFlag = "", genMatchFlag = "") As %String
{
	n (rows,page,id,parrefFlag,parDesc,loginInfo,dataMirFlag, referenceFlag, genMatchFlag)
	s end = page*rows
	s start=(page-1)*rows+1
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s HospID=$p(loginInfo,"^",5)   //xww 2021-08-23
	if parrefFlag=1  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.q:(0=##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction",loginInfo))&&(dataMirFlag'="true") //Sunhuiyong 数据映射界面显示停用数据 2020-04-09
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=desc
	.q:(linkDr'="")&(0=##class(web.DHCCKBCommon).IsShow(linkDr,"DHC_CKBCommonDiction",loginInfo))
	.s h=h+1
	.s data=id_"^"_code_"^"_desc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	.//s dicflag = $d(^CKB.PDSS.DicLogI("DLGDataDr",dicID))
	.//q:dicflag=10
	.//q:0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo)
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(parDesc'="")&($zcvt(dicCode,"U")'[$zcvt(parDesc,"U"))&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.s parref=id
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.q:(0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo))&&(dataMirFlag'="true") //Sunhuiyong 数据映射界面显示停用数据 2020-04-09
	.i linkDr'="" d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=dicDesc
	.q:(linkDr'="")&(0=##class(web.DHCCKBCommon).IsShow(linkDr,"DHC_CKBCommonDiction",loginInfo))&&(dataMirFlag'="true") //Sunhuiyong 数据映射界面显示停用数据 2020-04-09
	.q:(referenceFlag="true")&&(##class(web.DHCCKBDiction).IsReference(dicID,"")'=0)  //xww 2021-08-23
	.q:(genMatchFlag="true")&&(##class(web.DHCCKBDiction).IsGenMatch(dicCode,dicDesc,HospID)'=0)  //xww 2021-08-23 字典规则引用界面未引用
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)
	.s data=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc_"^"_ruleFlag
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^CDCode^CDDesc^CDParref^CDParrefDesc^CDLinkDr^CDLinkDesc^RuleFlag"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	d ..killTmpGlobal(pid)
	q ""
}

/// Creator:zhouxin
/// CreatDate:2019-05-29
/// 获取属性值
/// w ##class(web.DHCCKBDiction).EntityToJson("CT.CKB.PDSS.CommonDiction",1)
ClassMethod EntityToJson(entity, id)
{
	n (entity,id)
	s bean=$classmethod(entity,"%OpenId",id)
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(entity)
	
	s titleStr="",valueStr="",count=1
	i $IsObject(dcd) d
	.s cnt=dcd.Properties.Count()
	.f i=1:1:cnt  d	
	..s propObj = dcd.Properties.GetAt(i)
	..s value=""
	..s PropertyName = propObj.Name
	..q:$e(PropertyName,1)="%"
	..q:propObj.Cardinality="children"
	..set PropertyValue = $ZOBJPROPERTY(bean,PropertyName)
	..set runtimeType = propObj.RuntimeType,type=runtimeType
	..if (runtimeType="%Library.CacheObject")&&$IsObject(PropertyValue) set type=$CLASSNAME(PropertyValue) ;$classname(%String)=val

	..; 指向
	..if $e(type,1)'="%"  set value = $ZOBJMETHOD(bean,PropertyName_"GetObjectId")
	..else  d
	...if value="" s value = PropertyValue			//String , Number
	...if (type["Date")&&(value'="") s value=$zd(value, 3)
	...if (type["Time")&&(value'="") s value=$zt(value, 3)
	..
	..s count=count+1
	..s $p(titleStr,"^",count)=PropertyName
	..s $p(valueStr,"^",count)=value
	.d dcd.%Close()
	.
	.s $p(titleStr,"^",1)="ID"
	.s $p(valueStr,"^",1)=id
	.
	s dcd=""
	w ##class(web.DHCEMJsonCommon).getJsonData(titleStr,valueStr)
	q ""
}

/// Description:	通过附加属性和附加值 获取数据（实体,字典.-datagrid）(用new)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-20	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).GetDicListByAttrCode("30","1","KnowType","DictionFlag","11879","1","290","2","")
ClassMethod GetDicListByAttrCode(rows, page, extraAttr, extraAttrValue, userID, locID, groupID, hospID, params As %String = "", drugType = "") As %String
{
	n (rows, page,extraAttr, extraAttrValue,userID,locID,groupID,hospID,params,drugType) 
	s end = page*rows
	s start=(page-1)*rows+1
 	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	
	
	s queryCode = $p(params,"^",1)
	s queryDesc = $p(params,"^",2)
	s queryCode = $zcvt(queryCode,"U")
	s queryDesc = $zcvt(queryDesc,"U")
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	i extraAttrDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:extraAttrDr="" ""

	s h=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID))  q:dicID=""   d
	.q:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"stop"))
	.//s dicflag = $d(^CKB.PDSS.DicLogI("DLGDataDr",dicID))
	.//q:dicflag=10
	.s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID))  q:linkID=""   d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	..q:attrDr=""
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),2)	// 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))
	..s loginInfo=userID_"^"_""_"^"_locID_"^"_groupID_"^"_hospID
	..;b //wangxin
	..s IsStop=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo)
	..;q:flag=0
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..q:##class(web.DHCCKBCommon).CheckDrugType(drugType,dicDesc)=1 // 过滤药品类型 qnp 2021.6.24
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	..s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)&(dicDesc'[queryCode)&(pinDicDesc'[$zcvt(queryCode,"U"))
	..//q:(queryDesc'="")&&((dicDesc'[queryDesc)&(pinDicDesc'[queryDesc))
	..// 获取数据类型	
	..s dataTypeDr=##class(web.DHCCKBCommon).GetDataType()
	..s dataTypeId=..GetDataType(dataTypeDr,dicID)
	..s dataTypeCode="",dataTypeLinkDr=""
	..s:dataTypeId'="" dataTypeLinkDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,dataTypeId,""))
	..s dataType=""
	..i dataTypeLinkDr'="" s dataType=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dataTypeLinkDr)),4)
	..i dataType'="" s dataTypeCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataType)),2)
	..s h=h+1
	..s count = ..ChangeCount(dicDesc,h)
	..s ^TMP("DHCCKB","web.DHCCKBDiction","GetDicListByAttrCode",pid,count)=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_$g(linkDesc)_"^"_attrCode_"^"_dataTypeCode_"^"_IsStop
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^CDCode^CDDesc^Parref^ParrefDesc^CDLinkDr^CDLinkDesc^KnowType^DataType^IsStop"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetDicListByAttrCode",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","GetDicListByAttrCode",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	d ..killTmpGlobal(pid)
	
	q ""
}

/// Description:获取数据类型的ID,由于实体等的附加属性关联的是附加属性里的数据类型等，需要单独取出判断
/// w ##class(web.DHCCKBDiction).GetDataType(47,79)
ClassMethod GetDataType(dataTypeDr, dicID)
{
	n (dataTypeDr,dicID)
	
	s AttrCodeId="",RetTypeId=""
	for  s AttrCodeId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,AttrCodeId))  Q:(AttrCodeId="")||(RetTypeId'="")  d
	.s:AttrCodeId=dataTypeDr RetTypeId=AttrCodeId
	.Q:RetTypeId'=""
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)
	.s:LinkId=dataTypeDr RetTypeId=AttrCodeId
	Q RetTypeId
}

/// Description:	通过类型id查询实体
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-18	
/// Input:			分类
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicListByTypeNew(10,1,"^^1")
ClassMethod QueryDicListByTypeNew(rows, page, params As %String = "") As %String
{
	n (rows, page, params)
	
	s end = page*rows
	s start=(page-1)*rows+1
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s dicTypeDr=-100000000000000 	
	s queryCode = $p(params,"^",1)
	s queryDesc = $p(params,"^",2)
	s queryCode = $zcvt(queryCode,"U")
	s queryDesc = $zcvt(queryDesc,"U")
	s dicTypeDr = $p(params,"^",3)
	q:dicTypeDr="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:dicTypeDr="" ""
	
	s ID = "", h = 0
	f  s ID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicTypeDr,ID))  q:ID=""  d
	.s dicID = ID
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.//s dicCode = $zcvt(dicCode,"U")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)
	.q:(queryDesc'="")&&((dicDesc'[queryDesc)&(pinDicDesc'[queryDesc))
	.//q:(input'="")&(dicCode'[input)&(dicDesc'[input)&(pinDicDesc'[input)
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBDiction","GetParRefTypeList",pid,h)=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_linkDr
		
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0
	s listTitle="ID^Code^Desc^TypeDr^LinkDr"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetParRefTypeList",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","GetParRefTypeList",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	d ..killTmpGlobal(pid)
	
	q ""
}

/// w ##class(web.DHCCKBDiction).QueryAttrTreeForDialog("","")
ClassMethod QueryAttrTreeForDialog(params As %String = "", parref As %String = "") As %String
{
	n (params,parref)
	
	s queryCode=$p(params,"^",1)
	s queryCode=$ZCVT(queryCode,"U")
	
	
	i parref="" s typeID=-100000000000000
	i parref'="" s typeID=parref
	w "["
	s count=0 k tmpArr
	s ID=0
  	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",typeID,ID)) q:ID=""  d
  	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)  
  	.s pinText=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(text))
  	.//q:(queryCode'="")&(text'[queryCode)&(code'[queryCode)&(pinText'[queryCode)
  	.s ordNum=ID
  	.s tmpArr(ordNum)=ID_"^"_text_"^"_code

  	s index=""
  	f  s index=$o(tmpArr(index)) Q:index=""  D
  	.s ID=+$g(tmpArr(index))
  	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
  	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
    .///  是否存在孩子节点
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",ID,""))
	.i subID'="" D ..GetCheckTreeLeafNote(ID,queryCode)   ///是否有叶子节点
	.//w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()	
	.w "}"
	
	/// 如果分类树为空,显示默认根节点
	//i count=0 w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign("ROOT","数据集节点")_"}"
	
	w "]"
  	q ""
}

/// Description:	判断代码和描述是否存在
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-18	
/// Input:			代码，描述
/// return:			存在则返回id，不存在则返回0
/// other:			w ##class(web.DHCCKBDiction).CheckRepeat("","LinkProp","属性关联")
ClassMethod CheckRepeat(dicID, dicCode, dicDesc) As %String
{
	n (dicID,dicCode,dicDesc)

	s ret=0  // 代码和描述存在时，是否需要考虑父节点是什么(索引是否加父节点->代码索引)
	
	/// 新记录
	if dicID=""  d
	.i (dicCode'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode))))  d	// 代码存在（代码是唯一项）
	..s codeDr=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode),""),-1)
	..s ret=-98
	.
	.
	.i (dicDesc'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc))))  d	// 描述存在
	..s descDr=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc),""),-1)
	..s ret=-99	

	else  d		/// 修改记录
	.s oldDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)    //代码
	.s oldDicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)    //描述
	.i (dicCode'="")&&(dicCode'=oldDicCode)&($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode))))  d
	..s ret=-98
	.
	.i (dicDesc'="")&&(dicDesc'=oldDicDesc)&($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc))))  d
	..s ret=-99	
	
	q ret
}

/// Description:	判断字典级别下的代码和描述是否存在
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-18	
/// Input:			代码，描述，字典id
/// return:			存在则返回id，不存在则返回0
/// other:			w ##class(web.DHCCKBDiction).CheckDictionRepeat("","LinkProp","属性关联")
ClassMethod CheckDictionRepeat(dicID, dicCode, dicDesc, parref = "") As %String
{
	n (dicID,dicCode,dicDesc,parref)

	s ret=0  // 代码和描述存在时，是否需要考虑父节点是什么(索引是否加父节点->代码索引)
	
	s codeExistFlag=0,descExistFlag=0,codeDr="",descDr=""	
	i (dicCode'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode))))  d	// 代码存在（代码是唯一项）
	.s tmpDicID=""
	.q:(dicID'="")&&(dicCode'=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2))  //shy  只修改括号
	.f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode),tmpDicID))  q:(tmpDicID="")||(codeExistFlag=1)  d
	..q:0=##class(web.DHCCKBCommon).IsEnabled(tmpDicID) //	重复性判断去掉停用数据 2023-02-06 qnp
	..s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..//q:(parref'="")&(parref'=tmpParref)
	..q:(parref'=tmpParref)
	..s codeExistFlag=1
	..s codeDr=tmpDicID
	..s ret=-98	
	.
	i (ret=0)&(dicDesc'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc))))  d	// 描述存在
	.s tmpDicID=""
	.q:(dicID'="")&&(dicDesc'=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3))  //shy  只修改括号
	.f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc),tmpDicID))  q:(tmpDicID="")||(descExistFlag=1)  d
	..q:0=##class(web.DHCCKBCommon).IsEnabled(tmpDicID) //	重复性判断去掉停用数据 2023-02-06 qnp
	..s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..//q:(parref'="")&(parref'=tmpParref)
	..q:(parref'=tmpParref)
	..s descExistFlag=1
	..s descDr=tmpDicID
	..s ret=-99	
	
	q:(dicID="") ret	// 新记录
	
	/// 修改记录
	s oldDicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)    //代码
	s oldDicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)    //描述

	q:(dicCode'="")&&(dicCode'=oldDicCode)&&(ret=-98) ret
	q:(dicDesc'="")&&(dicDesc'=oldDicDesc)&&(ret=-99) ret
			
	q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	
	
	k ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicList",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetDicListByAttrCode",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid)
}

/// Description:	字典加载（适用于字典类型数据的加载）
/// CreateDate:		2019-11-08
/// Creator:		sufan
/// Input:			知识类比代码,字典类型代码
/// return:			所有字典类型数据
/// other:			w ##class(web.DHCCKBDiction).QueryDicTree()
/// w ##class(web.DHCCKBDiction).QueryDicTree("0","KnowType","DictionFlag")
ClassMethod QueryDicTree(id, extraAttr, extraAttrValue, queryCode = "")
{
	n (id,extraAttr, extraAttrValue,queryCode)

	i +id=0  d
	.d ..QueryDicTreeAll(extraAttr,extraAttrValue,queryCode)
	e  d
	.d ..QueryDicTreeByNodeId(id,queryCode)
	q ""
}

/// Description:	字典加载（适用于字典类型数据的加载）cu~T10)K
/// CreateDate:		2019-11-08
/// Input:			知识类比代码,字典类型代码
/// return:			所有字典类型数据
/// other:			w ##class(web.DHCCKBDiction).QueryDicTree("KnowType","DictionFlag")
/// w ##class(web.DHCCKBDiction).QueryDicTree("KnowType","AttrFlag")
ClassMethod QueryDicTreeAll(extraAttr, extraAttrValue, queryCode = "") As %String
{
	n (extraAttr,extraAttrValue,queryCode)

	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	i extraAttrDr="" w "[]"	
	q:extraAttrDr="" ""

	w "["
	s h=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID))  q:dicID=""   d
	.s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID))  q:linkID=""   d
	..s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	..q:attrDr=""
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),2)	// 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s descPin = ##class(web.DHCCKBCommonUtil).GetPYCODE(dicDesc)
	..q:(queryCode'="")&&(dicDesc'[queryCode)&&(descPin'[$zcvt(queryCode,"U"))
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	..s parrefDesc=""
	..s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	..s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..s linkDesc=""
	..s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s ordNum=dicID
  	..s tmpArr(ordNum)=dicID_"^"_dicDesc_"^"_dicCode
	
	s count=0
  	s index=""
  	f  s index=$o(tmpArr(index)) Q:index=""  D
  	.s ID=+$g(tmpArr(index))
  	.q:'$d(^CT.CKB.PDSS.CommonDictionD(ID))
  	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
  	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
    .///  是否存在孩子节点
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ID,""))
	.;i subID'="" D ..GetCheckTreeLeafNote(ID,queryCode)   ///是否有叶子节点
	.w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()	
	.w "}"
	w "]"
  	q ""
}

/// Description:	字典加载（适用于字典类型数据的加载）
/// CreateDate:		2019-11-08
/// Creator:		sufan
/// Input:			知识类比代码,字典类型代码
/// return:			所有字典类型数据
/// other:			w ##class(web.DHCCKBDiction).QueryDicTreeByNodeId()
/// w ##class(web.DHCCKBDiction).QueryDicTreeByNodeId(51)
ClassMethod QueryDicTreeByNodeId(NodeId, queryCode = "") As %String
{
	n (NodeId,queryCode)

	q:+NodeId="0" "[]"
	s count=0
	w "["
  	s ID=""
  	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",NodeId,ID)) Q:ID=""  D
  	.q:'$d(^CT.CKB.PDSS.CommonDictionD(ID))
  	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
  	.s text=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
  	.s textPin = ##class(web.DHCCKBCommonUtil).GetPYCODE(text)
	.q:(queryCode'="")&&(text'[queryCode)&&(textPin'[$zcvt(queryCode,"U"))
  	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(ID,text,code)
    .///  是否存在孩子节点
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ID,""))
	.i subID'="" D 
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	.i subID="" d ..GetCheckTreeLeafNote(ID)   ///是否有叶子节点	
	.w "}"
	w "]"
  	q ""
}

/// Description:	修改按钮dialog初始化combobox
/// Creator:		Sunhuiyong
/// CreateDate:		2020-02-06	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicComboboxByID("","112","0","2^289^1^11870")
/// w ##class(web.DHCCKBDiction).QueryDicComboboxByID("","102","0")
ClassMethod QueryDicComboboxByID(q As %String = "", id As %String = "", parrefFlag As %String = "", parDesc = "", params = "") As %String
{
	n (q,id,parrefFlag,parDesc,params)
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	s hospID="",groupID="",locID="",userID=""
	i params'=""  d
	.s hospID=$p(params,"^",1)
	.s groupID=$p(params,"^",2)
	.s locID=$p(params,"^",3)
	.s userID=$p(params,"^",4)
	s parDesc = q
	s parDesc = $zcvt(parDesc,"U")
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	if parrefFlag=1  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=desc
	.
	.s h=h+1
	.s data=id_"^"_code_"^"_desc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	.//s dicflag = $d(^CKB.PDSS.DicLogI("DLGDataDr",dicID))
	.//q:dicflag=10	
	.q:0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction","")
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(parDesc'="")&($zcvt(dicCode,"U")'[parDesc)&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.//q:(parDesc'="")&&(dicDesc'[parDesc)
	.;Q:(params'="")&&(##class(web.DHCCKBCommon).GetStopDicData(dicID,hospID,groupID,locID,userID)=1)
	.s parref=id
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=dicDesc
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)
	.s data=dicID_"^"_dicDesc
	.s h=h+1
	.q:(parDesc="")&&(h>100)	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="id^text"
	w "["
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index))
	.s count=count+1
	.i count=1 D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w "]"
	d ..killTmpGlobal(pid)
	q ""
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		Sunhuiyong 
/// CreateDate:		2020-03-05	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).GetTreeCombobox("","106","")
ClassMethod GetTreeCombobox(q As %String = "", parref As %String, params As %String = "") As %String
{
	n (q,parref,params)

	w "["
	d ..GetTreeComboboxJson(q,parref,params)
	w "]"
	q ""
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).GetTreeComboboxJson("","106")
ClassMethod GetTreeComboboxJson(q As %String = "", parref As %String, params As %String = "") As %String
{
	n (q,parref,params)
	;b  //33
	s parDesc=$zcvt(q,"U")
	i parref="" w "[]"
	q:parref="" ""
	s hospID="",groupID="",locID="",userID=""
	i params'=""  d
	.s hospID=$p(params,"^",1)
	.s groupID=$p(params,"^",2)
	.s locID=$p(params,"^",3)
	.s userID=$p(params,"^",4)
	s count=0
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21 link节点显示
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:((parDesc'="")&($zcvt(dicCode,"U")'[parDesc)&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U")))&('..GetTreeComboboxSonJson(parDesc,dicID,params,.count))
	.Q:(params'="")&&(##class(web.DHCCKBCommon).IsEnabled(dicID)=0)
	.s count=count+1
	.q:(parDesc="")&&(count>100)  //sufan 默认加载100条
	.s levCat = ##class(web.DHCCKBDiction).GetEveCat(dicID)
	.s outDesc = dicDesc
	.i levCat'=""  d
	..s outDesc = levCat_"/"_dicDesc
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,outDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,outDesc,dicCode)
	.w "}"
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.i subID'="" d
	..;.w ",""children"":"
	..D ..GetTreeComboboxSonJson(parDesc,dicID,params,.count)   ///是否有叶子节点
	.//q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	q ""
}

/// Description:	获取实体下的实例(tree结构,treegrid,tree,combotree均可用)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-09	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDiction).GetTreeComboboxSonJson("","106")
ClassMethod GetTreeComboboxSonJson(q As %String = "", parref As %String, params = "", count = 0) As %String
{
	n (q,parref,params,count)
	s parDesc=$zcvt(q,"U")
	i parref="" w "[]"
	q:parref="" ""
	i params'=""  d
	.s hospID=$p(params,"^",1)
	.s groupID=$p(params,"^",2)
	.s locID=$p(params,"^",3)
	.s userID=$p(params,"^",4)
	;s count=0
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) //kml 2020-02-21 link节点显示
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s:(dicLink'="")&&(dicCode="") dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),2) //kml 2020-02-21
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),"^",2)
	.s:(dicLink'="")&&(dicDesc="") dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicLink)),3) //kml 2020-02-21
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:((parDesc'="")&($zcvt(dicCode,"U")'[parDesc)&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U")))&('..GetTreeComboboxSonJson(parDesc,dicID,params,.count))
	.;b:dicID=8985			//11
	.;b:dicID=70889			//22
	.Q:(params'="")&&(##class(web.DHCCKBCommon).IsEnabled(dicID)=0)
	.s count=count+1
	.s levCat = ##class(web.DHCCKBDiction).GetEveCat(dicID)
	.s outDesc = dicDesc
	.i levCat'=""  d
	..s outDesc = levCat_"/"_dicDesc
	.q:(parDesc="")&&(count>100)		//sufan 默认加载100条
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,outDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,outDesc,dicCode)
	.w "}"
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.i subID'="" d
	..;.w ",""children"":"
	..D ..GetTreeComboboxSonJson(parDesc,dicID,params,.count)   ///是否有叶子节点
	.//q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	q ""
}

/// Descript:修改归属字典
/// Creator:sufan
/// CreateDate:20200212
/// Input:dicId,dictionId
/// w ##class(web.DHCCKBDiction).UdpDiction("146472","146460")
ClassMethod UdpDiction(DicId, DictionId)
{
	n (DicId, DictionId)
	s ret=0
	s ExistFlag=..IsDicQuote(DicId)			///判断是否引用
	Q:ExistFlag="Y" "-1"
	s DicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)	///code
	s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)	///Desc
	s ret=..CheckDictionRepeat(DicId, DicCode, DicDesc, DictionId) 
	Q:ret'=0 ret
	&sql(update CT_CKB_PDSS.CommonDiction set CD_Parref_Dr=:DictionId where CD_RowID=:DicId)
	s ret=SQLCODE
	Q ret
}

/// Descript:修改归属字典
/// Creator:sufan
/// CreateDate:20200212
/// Input:dicId,dictionId
/// w ##class(web.DHCCKBDiction).UdpDictionStr("4407","129810")
ClassMethod UdpDictionStr(DicIdStr, DictionId)
{
    n (DicIdStr, DictionId)
	ts
	s DicIdStrLength=$l(DicIdStr,"^")
	s ret=0
	f i=1:1:DicIdStrLength  q:ret'=0  d
	.s DicId=$p(DicIdStr,"^",i)
	.q:DicId=""
	.s ExistFlag=..UpDicQuote(DicId,DictionId)			///修改引用分支   sunhuiyong   2021-9-1
	.s:ExistFlag'=0 ret=-1
	.Q:ExistFlag'=0 
	.s DicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)	///code
	.s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)	///Desc
	.s ret=..CheckDictionRepeat(DicId, DicCode, DicDesc, DictionId) 
	.Q:ret'=0
	.&sql(update CT_CKB_PDSS.CommonDiction set CD_Parref_Dr=:DictionId where CD_RowID=:DicId)
	.s ret=SQLCODE
	.q:ret'=0
	tro:ret'=0
	tc:ret=0
	Q ret
}

// Descript:修改归属字典

ClassMethod UdpDictions(DicId, DictionId)
{
	n (DicId, DictionId)
	s ExistFlag=..IsDicQuote(DicId)			///判断是否引用
	Q:ExistFlag="Y" "-1"
	s EDType=$lg(^CKB.PDSS.ExtDictionD(DictionId),2)
	&sql(update CKB_PDSS.ExtDiction set ED_Type=:EDType where ED_RowID=:DicId)
	Q SQLCODE
}

/// Descript:判断字典是否在规则中引用
ClassMethod IsDicQuote(DicId)
{
	n (DicId)
	s ExistFlag="N"
	s RightType=""
	for  s RightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType))  Q:(RightType="")||(ExistFlag="Y")  d
	.Q:'$d(^CT.CKB.PDSS.RuleDataI("RightDic",RightType,DicId))
	.s ExistFlag="Y"
	Q ExistFlag
}

/// Author:   sunhuiyong
/// Descript: 修改字典指向 将规则中引用做出修改
/// Date:     2021-9-1
ClassMethod UpDicQuoteOld(DicId, DictionId)
{
	n (DicId,DictionId)
	s Symptom=##class(web.DHCCKBCommon).GetSymptom()  //症状
	s Drug= ##class(web.DHCCKBCommon).GetDrug()       //西药
	s ExistFlag=0
	s RightType=""
	f  s RightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType))  Q:(RightType="")||(ExistFlag="Y")  d
	.s RuleCop="" f  s RuleCop=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType,DicId,RuleCop)) q:RuleCop=""  d
	..s RuleDataId="" f  s RuleDataId=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType,DicId,RuleCop,RuleDataId)) q:RuleDataId=""  d
	...;leftValue不存在的情况下（没有“的”）
	...i $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),5)=""  d
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),4)=DictionId
	...;;leftValue存在的情况下（有“的”）
	...e  d
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),5)=DictionId
	...;完成后检测：症状 改为 西医的症状
	...i ($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),4)=Symptom)&&($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),5)="")  d
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),4)=Drug
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),5)=Symptom
	q ExistFlag
}

/// Author:   sunhuiyong
/// Descript: 修改字典指向 将规则中引用做出修改
/// Date:     2021-9-1
ClassMethod UpDicQuote(DicId, DictionId)
{
	n (DicId,DictionId)
	s Symptom=##class(web.DHCCKBCommon).GetSymptom()  //症状
	s Drug= ##class(web.DHCCKBCommon).GetDrug()       //西药
	s ErrFlag=0
	s RightType=""
	f  s RightType=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType))  Q:(RightType="")||(ErrFlag=1)  d
	.s RuleCop="" f  s RuleCop=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType,DicId,RuleCop)) q:RuleCop=""  d
	..s RuleDataId="" f  s RuleDataId=$o(^CT.CKB.PDSS.RuleDataI("RightDic",RightType,DicId,RuleCop,RuleDataId)) q:(RuleDataId="")||(ErrFlag=1)  d
	...s EntityID=""
	...s EntityLinkID=""
	...f  s EntityLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",DictionId,EntityLinkID))  q:(EntityLinkID="")||(ErrFlag=1)||(EntityID'="")  d
	....s ID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(EntityLinkID)),2)
	....q:'$d(^CT.CKB.PDSS.CommonDictionD(ID))
	....q:ID=""
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	....q:Desc=""
	....s:Desc="检验指标" Desc="检验项"
	....q:$lg($g(^CT.CKB.PDSS.CommonDictionD(DictionId)),3)'[Desc
	....s EntityID=ID
	...s:EntityID="" ErrFlag=1
	...q:EntityID=""
	...b ;start
	...;leftValue不存在的情况下（没有“的”）
	...i $lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),5)=""  d
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),4)=EntityID
	...;;leftValue存在的情况下（有“的”）
	...e  d
	....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),4)=EntityID
	....s Item=$lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),5)
	....i ..CheckDicAttr(EntityID,"LinkProp",Item)=1  d
	.....s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),5)=""
	...;完成后检测：症状 改为 西医的症状
	...;i ($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),4)=Symptom)&&($lg($g(^CT.CKB.PDSS.RuleDataD(RuleDataId)),5)="")  d
	...;.s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),4)=Drug
	...;.s $list(^CT.CKB.PDSS.RuleDataD(RuleDataId),5)=Symptom
	q ErrFlag
}

/// Creator:    Shy
/// CreateDate: 2019-06-18
/// Descript:   是否包含属性
/// Input：     实体id,关联属性代码(LinkProp)  0包含   1 不包含
/// w ##class(web.DHCCKBDiction).CheckDicAttr("5","LinkProp","38")
ClassMethod CheckDicAttr(queryDicID, extraAttr, checkID)
{
	n (queryDicID,extraAttr,checkID)
	
	Q:queryDicID="" 1
    
    //取附加属性的属性关联
    s h=0,count=0
    s extraAttrDr=##class(web.DHCCKBRangeCat).GetAttrLink(queryDicID,extraAttr)			
	q:extraAttrDr="" 1
  	// 找到关联的属性列表，展现属性列表
   	s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",queryDicID,extraAttrDr,""))	// 关联表id
  	q:linkID="" 1
  	s parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 属性值(表，集合) 
  	q:parref="" 1
  	s successFlag=1
	s attrID=""
	for  s attrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,attrID)) Q:(attrID="")||(successFlag=0)  d	
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.i $g(linkDr)'="" d 
	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	.q:##class(web.DHCCKBCommon).IsEnabled(+attrID)=0     //qunianpeng 20200420  过滤停用数据
	.q:##class(web.DHCCKBCommon).IsEnabled(+linkDr)=0     //qunianpeng 20200420  过滤停用数据
    .s:attrID=checkID successFlag=0
	q successFlag
}

/// Description:	查询实体字典列表（用 new）-过滤停用数据、核实数据
/// Creator:		Sunhuiyong
/// CreateDate:		2020-02-18	
/// Input:			id,parrefFlag（1则显示父节点，0则只显示子节点）
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicByIDWhitinStop("30","1","115","0","心功能不全","2","289","1","11870")
ClassMethod QueryDicByIDWhitinStop(rows, page, id As %String = "", parrefFlag As %String = "", hospID = "", groupID = "", locID = "", userID = "", parDesc = "") As %String
{
	n (rows,page,id,parrefFlag,hospID,groupID,locID,userID,parDesc)

	s end = page*rows
	s start=(page-1)*rows+1
	q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:+id=0 ""
	
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	if parrefFlag=1  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=desc
	.
	.s h=h+1
	.s data=id_"^"_code_"^"_desc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
	.//过滤停用数据   入参新加：hospID, groupID, locID, userID
	.//q:##class(web.DHCCKBCommon).GetStopDicData(dicID,hospID,groupID,locID,userID)=1
	.b:dicID="23959"   ;1
	.s loginInfo=userID_"^"_""_"^"_locID_"^"_groupID_"^"_hospID
	.s flag=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo)
	.q:flag=0
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(parDesc'="")&($zcvt(dicCode,"U")'[parDesc)&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.//q:(parDesc'="")&&(dicDesc'[parDesc)
	.s parref=id
	.s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.i linkDr'="" d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc=dicDesc
	.s confirmFlag=""         //空为未核实
	.;s:##class(web.DHCCKBCommon).GetAcceptDicData(dicID,hospID,groupID,locID,userID)=1 dicDesc=dicDesc_"    <img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' style='border:0px;cursor:pointer'>"
	.s retFlag=##class(web.DHCCKBCommon).GetConfirmFlag(dicID) 
	.s:retFlag=1 confirmFlag="已审核"    // wangxuejian 2021-05-19 增加核实列 1为核实
	.s:retFlag=2 confirmFlag="未审核"      //2 为取消核实
	.s retPerson=##class(web.DHCCKBCommon).GetConfirmPerson(dicID) 
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)
	.s data=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_linkDesc_"^"_ruleFlag_"^"_confirmFlag_"^"_retPerson
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,h)=data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^CDCode^CDDesc^CDParref^CDParrefDesc^CDLinkDr^CDLinkDesc^RuleFlag^ConfirmFlag^ConfirmPerson"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicByID",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	d ..killTmpGlobal(pid)
	q ""
}

/// Description:	查询实体字典列表或实体属性（一个datagrid中显示）
/// Creator:		kemaolin
/// CreateDate:		2020-02-21	
/// Input:			listType 0字典 1实体属性，id 字典ID，params 实体id^附加属性
/// return:			实体字典列表
/// other:			w ##class(web.DHCCKBDiction).QueryDicAndAttrList("30","1",1,"26938","","")
ClassMethod QueryDicAndAttrList(rows, page, listType = "", id = "", params = "", query = "") As %String
{
	n (rows,page,listType,id,params,query)
	s end = page*rows
	s start=(page-1)*rows+1
	q:listType="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	s input = $zcvt(query,"U")
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()

	//字典列表
	if (listType=0){
		q:+id=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
		
		s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicID))   q:dicID=""  d
		.;s dicflag = $d(^CKB.PDSS.DicLogI("DLGDataDr",dicID))
		.;q:dicflag=10
		.q:##class(web.DHCCKKBIndex).CheckStopDic(dicID)=1 //停用
		.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
		.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
		.;s parref=id
		.;s:parref'="" parrefDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),"^",2)
		.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
		.;s linkDesc=""
		.i linkDr'="" d
		..s:dicCode="" dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
		..s:dicDesc="" dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
		..;s linkDesc=dicDesc
		.
		.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
		.q:(input'="")&($$ALPHAUP^SSUTIL4(dicCode)'[input)&(dicDesc'[input)&(pinDicDesc'[input)
		.s data=dicID_"^"_dicCode_"^"_dicDesc
		.s h=h+1	
		.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicAndAttrList",pid,h)=data
	}
	
	//实体的属性
	if (listType=1){
		s queryDicID = $p(params,"^",1)	// 实体id
		Q:queryDicID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
		s extraAttr=$p(params,"^",2)    // 关联属性代码(LinkProp)
	    s extraAttrDr=##class(web.DHCCKBRangeCat).GetAttrLink(queryDicID,extraAttr)
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
		.;i $g(DLAAttrDr)'="" s DLAAttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DLAAttrDr),"^",2)
		.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
		.;s linkDesc=""
		.i linkDr'="" d
		..s:code="" code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
		..s:desc="" desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
		.;.s linkDesc=dicDesc
		.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(desc))
		.q:(input'="")&($$ALPHAUP^SSUTIL4(code)'[input)&(desc'[input)&(pinDicDesc'[input)
		.s listData=attrID_"^"_code_"^"_desc
		.s h=h+1
		.s ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicAndAttrList",pid,h)=listData
	}
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="ID^code^desc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicAndAttrList",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryDicAndAttrList",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	;d ..killTmpGlobal(pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","QueryDicAndAttrList",pid)
	q ""
}

/// Description:	查询通用名的关联信息列表
/// Creator:		kemaolin
/// CreateDate:		2020-02-21	
/// Input:			GenNameID
/// Output:			json字符串
/// other:			w ##class(web.DHCCKBDiction).QueryByGeneralNameID("30","1",49704)
ClassMethod QueryByGeneralNameID(rows, page, GenNameID) As %String
{
	n (rows,page,GenNameID)
	s end = page*rows
	s start=(page-1)*rows+1
	q:GenNameID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:GenNameID="" ""
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()	
	s GeneralNameProp=##class(web.DHCCKBCommon).GetDrugGenerName() //通用名属性
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp() //商品名属性 
	s drugManf=##class(web.DHCCKBCommon).GetDrugManf()	//生产厂家属性

	//s formGenAttrID="" f  s formGenAttrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",GenNameID,formGenProp,formGenAttrID)) q:formGenAttrID=""  d
	s formGenAttrID="" f  s formGenAttrID=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",GenNameID,GeneralNameProp,formGenAttrID)) q:formGenAttrID=""  d
	.s formGenID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(formGenAttrID)),2)
	.q:+formGenID=0
	.s formGenDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(formGenID)),3)
	.s pFlag=0 //商品名是否存在
	.s proNameAttrID="" f  s proNameAttrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",formGenID,proNameProp,proNameAttrID)) q:proNameAttrID=""  d
	..s proNameID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(proNameAttrID)),4)
	..q:+proNameID=0
	..s pFlag=1 ,mFlag=0
	..s proNameDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(proNameID)),3)
	..s manfAttrID="" f  s manfAttrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",proNameID,drugManf,manfAttrID)) q:manfAttrID=""  d
	...s manfID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(manfAttrID)),4)
	...q:+manfID=0
	...s mFlag=1
	...s manfDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(manfID)),3)
	...s data=formGenDesc_"^"_proNameDesc_"^"_manfDesc
	...s h=h+1	
	...s ^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid,h)=data
	..
	..i mFlag=0  d
	...s data=formGenDesc_"^"_proNameDesc_"^"_""
	...s ^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid,h)=data
	...s h=h+1
	.
	.i pFlag=0  d
	..s data=formGenDesc_"^"_""_"^"_""
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid,h)=data
			
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="formGenDesc^proNameDesc^manfDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	;d ..killTmpGlobal(pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","QueryByGeneralNameID",pid)
	q ""
}

/// Description:	判断元素是否属于树型字典
/// Creator:		kemaolin
/// CreateDate:		2020-03-10	
/// return:			0 不属于 1属于
/// other:			w ##class(web.DHCCKBDiction).CheckSupTree(148, 106)
ClassMethod CheckSupTree(parref, drugCatData)
{
	
	n (parref, drugCatData)
	q:+parref=0 0
	q:parref=drugCatData 1
	s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),4)	
	q ..CheckSupTree(parref,drugCatData)
}

/// Description:	树型字典重复性判断
/// Creator:		kemaolin
/// CreateDate:		2020-03-10	
/// return:			0 不存在 ,id
/// other:			w ##class(web.DHCCKBDiction).CheckTreeRepeat("", 106)
ClassMethod CheckTreeRepeat(desc, drugCatData)
{
	
	n (desc, drugCatData)
	
	q:desc="" 0
	s linkID=0,tmpDicID=""
	f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),tmpDicID))  q:(tmpDicID="")||(linkID'=0)  d
	.q:tmpDicID=""
	.q:##class(web.DHCCKBDiction).CheckSupTree(tmpDicID, drugCatData)=0
	.s linkID=tmpDicID
	q linkID
}

/// Description:	查询分类药品关联数据
/// Creator:		sufan
/// CreateDate:		2020-03-16	
/// return:			分类ID
/// other:			w ##class(web.DHCCKBDiction).QueryCatLinkDrug("30","1","139^^2^","")
ClassMethod QueryCatLinkDrug(rows As %String = 100, page As %String = 1, params As %String, drugType = "")
{
	n (rows,page,params,drugType)
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  			//结束行
	s StPage=((page-1)*rows)+1      //开始行
	Q:params="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)
	s DrugCatId=$p(params,"^",1)		//分类ID
	s Drug=$p(params,"^",2)				//药品描述
	s ChkValue=$p(params,"^",3)			//是否
	s SecCatId=$p(params,"^",4)			//弹框下拉分类
	s DrugCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugCatId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugCatId)),2) //shy 添加code 2021-6-7
	s linkId= $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugCatId)),5)
	s:DrugCat="^" DrugCat="" 
	i (DrugCat="")&&(linkId'="") s DrugCat=DrugCatId_"^"_DrugCatId
	//i (DrugCat="")&&(linkId'="") s DrugCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),2)   //shy 添加code   2021-6-7
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	s DrugCatId=$p(params,"^",1)				//药学分类id
	i drugType'="" s DrugDictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugType) // qnp 2021/5/15
	e  s DrugDictionId=##class(web.DHCCKBCommon).GetDrugData()			//默认是西药药品字典
	s DrugCatAttrId=##class(web.DHCCKBCommon).GetPhCategory()		//药学分类属性
	s count=0
	w "{""rows"":["
	s Id="",num=0
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugDictionId,Id)) Q:Id=""  d
	.s Link=0
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),2)   		//药品代码
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)   		//药品描述
	.Q:##class(web.DHCCKBCommon).IsEnabled(Id)=0
	.s QuitList=Code_Desc
	.s CatDesc=##class(web.DHCCKBEditProp).QueryAttrValueNew(Id,DrugCatAttrId)
	.s CatDescShow=..DealStr(CatDesc)
	.//s CatDescShow=##class(web.DHCCKBEditProp).QueryAttrValue(Id,DrugCatAttrId)
	.s includeFlag = ..IsInclude(CatDesc,DrugCat)
	.i includeFlag=1 s Link=1
	.//s:..IsInclude(CatDesc,DrugCat) Link=1
	.Q:(Drug'="")&&(QuitList'[Drug)			//按药品过滤
	.Q:((ChkValue=1)||(ChkValue=""))&&(SecCatId="")&&('includeFlag)  //已选
	.Q:(ChkValue=2)&&(Link="1")
	.Q:(SecCatId'="")&&('..IsIncludCat(CatDesc,SecCatId))
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.Id=Id
	.s tmpObj.Code=Code
	.s tmpObj.Desc=Desc
	.s tmpObj.CatDesc=CatDescShow
	.s tmpObj.DrugCatAttrId=DrugCatAttrId
	.s tmpObj.Link=Link
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Description:	是否包含分类
/// Creator:		sufan
/// CreateDate:		2020-03-16	
/// Input:			分类串，单个分类
/// return:			0：不包含，1包含
/// w ##class(web.DHCCKBDiction).IsInclude("电解质平衡调节药,钙盐","钙盐")
ClassMethod IsInclude(CatDesc, DrugCat)
{
	n (CatDesc,DrugCat)
	Q:CatDesc="" 0
	s Len=$l(CatDesc,",")
	s ExistFlag=0
	for i=1:1:Len  Q:ExistFlag=1  d
	.Q:ExistFlag=1
	.s Cat=$p(CatDesc,",",i)
	.Q:Cat'=DrugCat
	.s ExistFlag=1
	Q ExistFlag
}

/// Description:	是否包含分类
/// Creator:		sufan
/// CreateDate:		2020-03-16	
/// Input:			分类串，单个分类
/// return:			0：不包含，1包含
/// w ##class(web.DHCCKBDiction).IsIncludCat("α1-肾上腺素受体激动药,中枢DA受体激动剂,多巴胺D2受体拮抗药",1251)
ClassMethod IsIncludCat(DrugCat, SecCatId)
{
	n (DrugCat,SecCatId)
	//s SelCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(SecCatId)),3)
	//s RetList=SelCat
	//s Id=""
	//for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",SecCatId,Id)) Q:Id=""  d
	//.s CatDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	//.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),5)
	//.s:LinkId'="" CatDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	//.s RetList=RetList_","_CatDesc
	s RetList=""
	s Ret=""
	s Ret=##Class(web.DHCCKBCommon).GetChildCat(.RetList,SecCatId,0)
	s IsInFlag=0
	s Len=$listlength(RetList)
	for i=1:1:Len  Q:IsInFlag=1  d
	.s TempCat=$list(RetList,i)
	.s IsInFlag=##class(web.DHCCKBDiction).IsInclude(DrugCat,TempCat)
	.Q:IsInFlag=0
	Q IsInFlag
}

/// Description:	是否包含分类
/// Creator:		sufan
/// CreateDate:		2020-03-16	
/// Input:			分类及属性串
/// return:			0成功，其他失败
/// w ##class(web.DHCCKBDiction).revRelation()
ClassMethod revMulRelation(listData, loginInfo, ClientIP)
{
	n (listData,loginInfo, ClientIP)
	s Err = 0
	s len = $l(listData,"&&")
	TS
	for i=1:1:len  Q:Err<0   d
	.s tempList = $p(listData,"&&",i)
	.s Err = ..revRelation(tempList,loginInfo, ClientIP)
	.Q:Err<0 
	i Err<0 TRO
	Q:Err<0 Err
	TC
	Q Err
}

/// Description:	是否包含分类
/// Creator:		sufan
/// CreateDate:		2020-03-16	
/// Input:			分类及属性串
/// return:			0成功，其他失败
/// w ##class(web.DHCCKBDiction).revRelation()
ClassMethod revRelation(ListData, loginInfo, ClientIP)
{
	n (ListData, loginInfo, ClientIP)
	s userID = $p(loginInfo,"^",1)
	s hospID = $p(loginInfo,"^",5)
	
	s Err=0
	s DrugId=$p(ListData,"^",1)
	s DrugCatAttrId=$p(ListData,"^",2)
	s DrugCatId=$p(ListData,"^",3)
	s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DrugId,DrugCatAttrId,DrugCatId,""))
	Q:AttrId="" -1
	s Err=##class(web.DHCCKBDicLinkAttr).DelDicAttr(AttrId,"ROWID")
	s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicLinkAttr", Err, "delete", userID, "", "", "D", hospID, ClientIP,"log") // 增加日志 qnp 2021/5/13
	
	Q Err
}

/// Description:	查询模板树
/// Creator:		sufan
/// CreateDate:		2020-03-27	
/// Input:			
/// return:			模板数据
/// w ##class(web.DHCCKBDiction).QueryTempTree(26,"")
ClassMethod QueryTempTree(ParentId, Input = "")
{
	n (ParentId,Input)
	s count=0
	w "["
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,Id)) Q:Id=""  d
	.s DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),2)
	.s DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)
	.s DicLink = $lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),5) 
	.s:(DicLink'="")&&(DicCode="") DicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),2) 
	.s:(DicLink'="")&&(DicDesc="") DicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicLink)),3) 
	.s ExistFlag=##class(web.DHCCKBQueryDic).IsExistSubNode(Id,Input)
	.Q:ExistFlag=0
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(Id,DicDesc,DicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(Id,DicDesc,DicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Id,""))
	.i subID'="" d
	..w ",""children"":"
	..D ..QueryTempTree(Id)   ///是否有叶子节点
	.w "}"
	w "]"	
	Q ""
}

/// Description:	获取上级节点
/// Creator:		sufan
/// CreateDate:		2020-03-30	
/// Input:			本级Id
/// return:			id^text
/// w ##class(web.DHCCKBDiction).GetLastList(24872)
ClassMethod GetLastList(Id)
{
	n (Id)
	s LastId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),4)
	Q:LastId="" "^"
	s LastDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LastId)),3)
	Q LastId_"^"_LastDesc
}

/// Description:	获取上级节点
/// Creator:		sufan
/// CreateDate:		2020-03-30	
/// Input:			本级Id
/// return:			0:成功，其他：失败
/// w ##class(web.DHCCKBDiction).DeleTree(24872)
ClassMethod DeleTree(dicID) As %String
{
	n (dicID)
	
	s Err=0
	s Err=..IsSureDel(dicID)
	Q:Err=1 "-1"
	&sql(delete from CT_CKB_PDSS.CommonDiction where CD_RowID=:dicID)
	s Err=SQLCODE
	Q:Err'=0 Err
	s Id="" 
	for   s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,Id)) Q:(Id="")||(Err'=0)  d
	.&sql(delete from CT_CKB_PDSS.CommonDiction where CD_RowID=:Id)
	.s Err=SQLCODE
	
	q Err
}

/// Description:	判断下级节点能否删除
/// Creator:		sufan
/// CreateDate:		2020-03-30	
/// Input:			节点ID
/// return：		1:可以，0：不可以
/// w ##class(web.DHCCKBDiction).IsSureDel(77897)
ClassMethod IsSureDel(dicID)
{
	n (dicID)
	s IsFlag=0
	s NextId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	s:(NextId="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID))) IsFlag=1
	Q:NextId="" IsFlag
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,Id))  Q:(Id="")||(IsFlag=1)  d
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",Id)) s IsFlag=1
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Id))  d
	..s IsFlag=..IsSureDel(Id)
	Q IsFlag
}

/// Description:	旧成分数据处理
/// Creator:		sufan
/// CreateDate:		2020-04-08	
/// Input:			
/// return：		0：成功，其他，失败
/// w ##class(web.DHCCKBDiction).DealIngData()
ClassMethod DealIngData()
{
	S result = ##class(%Library.ResultSet).%New()
	s Err=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBDiction","DealIngData",pid)
	s SqlStr="SELECT DLA_RowID as AttrId FROM CT_CKB_PDSS.DicLinkAttr where DLA_AttrCode=39 and DLA_Attr_Dr!='' and DLA_Dic_Dr->CD_Parref_Dr=105 and DLA_Attr_Dr->CD_Parref_Dr=108"
	D result.Prepare(SqlStr)
	D result.Execute()
	s count=0
	While(result.Next())
	{	
		s AttrId = result.Data("AttrId")
		s count=count+1
		;continue:count>10
		s ^TMP("DHCCKB","web.DHCCKBDiction","DealIngData",pid,AttrId)=AttrId
	}
	s Err=..InsInGredData(pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","DealIngData",pid)
	Q Err
}

/// Description:	旧成分数据处理
/// Creator:		sufan
/// CreateDate:		2020-04-08	
/// Input:			
/// return：		0：成功，其他，失败
ClassMethod InsInGredData(pid)
{
	n (pid)
	s IngreId=##class(web.DHCCKBCommon).GetDicIdByCode("IngredientPropTemp")
	s IngreCodeId=##class(web.DHCCKBCommon).GetDicIdByCode("IngredientCode")
	s IngreMeteId=##class(web.DHCCKBCommon).GetDicIdByCode("IngredientMete")
	s IngreUnitId=##class(web.DHCCKBCommon).GetDicIdByCode("IngredientUnit")
	s Err=0
	TS
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","DealIngData",pid,Index)) Q:(Index="")||(Err'=0)  d
	.s repid=##class(web.DHCCKBCommonUtil).NewPid()
	.s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Index)),2)    			//药品Id
	.s IngreId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(Index)),4)    			//成分Id
	.s Id=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DrugId,IngreCodeId,IngreId)) d
	..s Attr=""
	..&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:Attr where DLA_RowID=:Index )
	..s Err=SQLCODE
	.Q:Err'=0
	.Q:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",DrugId,IngreCodeId,IngreId))		//如果改成分已维护，不重复维护
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_GroupFlag) values(:DrugId,:IngreCodeId,:IngreId,:repid))
	.s Err=SQLCODE
	.Q:Err'=0
	.s MeteId=""
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_GroupFlag) values(:DrugId,:IngreMeteId,:MeteId,:repid))
	.s Err=SQLCODE
	.Q:Err'=0
	.s UnitId=""
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_GroupFlag) values(:DrugId,:IngreUnitId,:UnitId,:repid))
	.s Err=SQLCODE
	.Q:Err'=0
	i Err'="0" TRO
	Q:Err'="0" Err_"%%"_Index
	TC
	Q Err
}

/// Creator:		Sunhuiyong
/// CreateDate:		2020-04-09	
/// Input:			对照数据ID、数据库描述text	
/// return：		0：成功，其他，失败
/// w ##class(web.DHCCKBDiction).ResetCompareData("2255","测试01")
ClassMethod ResetCompareData(CompareDataID = "", ResetData As %String = "") As %String
{
	n (CompareDataID,ResetData)
	&SQL(
		UPDATE CKB_PDSS.ComContrast SET CC_LibCode =:ResetData,CC_LibDesc =:ResetData WHERE CC_RowID =:CompareDataID
	)
	q SQLCODE
}

/// Creator:		Sunhuiyong
/// CreateDate:		2021-6-30	
/// Input:			params	
/// return：		0：成功，其他，失败
/// w ##class(web.DHCCKBDiction).InsertComDrug("^注射用青霉素钠20万U(华北制药股份有限公司)^注射用青霉素钠20万U(华北制药股份有限公司)^105","20万U&&ceshi&&777",150)
ClassMethod InsertComDrug(params As %String = "", property = "", dicID = "", LgUserID, LgHospID, ClientIPAddress, paref = "") As %String
{
	n (params,property,dicID,LgUserID,LgHospID,ClientIPAddress,paref)
	s result=0
	ts
	s code = $p(params,"^",2)	
	s code = ##class(web.DHCCKBDiction).GetSysCodeByType(paref,code) 	 // 根据parref判断是否需要自动生成编码(字典数据需要生成编码) qnp 20230509
	s $p(params,"^",2)=code
	s id = ..SaveDic(params)
	s ret=id
	i ret>0  d 
	.s ret=##class(web.DHCCKBWriteLog).SaveDicLog(id,LgUserID,LgHospID,"add",ClientIPAddress) // ret是SQLCODE
	i ret=0  d
	.s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBCommonDiction", id, "grantAuth", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"acc")
	s drugDataXY= ##class(web.DHCCKBCommon).GetDrugData()
	i $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)=drugDataXY d
	.s comOrigin=##class(web.DHCCKBCommon).GetComOrignDrugDataXY()
	e  d
	.s comOrigin=##class(web.DHCCKBCommon).GetComOrignDrugData()
	
	s flag=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_dicID_"^"_comOrigin_"^"_id)
	q:flag'=0 "关联同源药品失败！"	
	// 获取属性	
	s drugDataID = ##class(web.DHCCKBCommon).GetDrugData()
	s drugZDataID = ##class(web.DHCCKBCommon).GetChineseDrugData()
	i (id > 0)&(property'="")	 d
	.s comDrugEqunitid= ##class(web.DHCCKBCommon).GetDicIdByCode("EqFactorProp")    //等效数量
	.s comDrugEqunitAid=##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")  //从  dr
	.s comDrugEqunitBid=##class(web.DHCCKBCommon).GetDicIdByCode("EqToUnitProp")    //到  dr
	.s:paref=drugDataID comDrugSpecid= ##class(web.DHCCKBCommon).GetSpecificationProp()
	.s:paref=drugDataID comDrugAppNumid= ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	.s:paref=drugZDataID comDrugSpecid= ##class(web.DHCCKBCommon).GetChineseSpecData()  
	.s:paref=drugZDataID comDrugAppNumid= ##class(web.DHCCKBCommon).GetChineseAppData()
	.//  获取属性值
	.s comDrugSpec=$p(property,"^",1)
	.s comDrugAppNum=$p(property,"^",2)
	.s comDrugEqunit=$p(property,"^",3)
	.s comDrugEqunitA=$p(property,"^",4)
	.s comDrugEqunitB=$p(property,"^",5)
	.s repId=##class(web.DHCCKBCommonUtil).NewPid()
	.s retComDrugSpec=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_id_"^"_comDrugSpecid_"^^"_comDrugSpec)
	.s retComDrugAppNum=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_id_"^"_comDrugAppNumid_"^^"_comDrugAppNum)
	.s retComDrugEqunit=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_id_"^"_comDrugEqunitid_"^^"_comDrugEqunit_"^"_repId)
	.s retComDrugEqunitA=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_id_"^"_comDrugEqunitAid_"^"_comDrugEqunitA_"^^"_repId)  //从
	.s retComDrugEqunitB=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew("^"_id_"^"_comDrugEqunitBid_"^"_comDrugEqunitB_"^^"_repId)  //到	
	.s result=retComDrugSpec||retComDrugAppNum||retComDrugEqunit
	tc:result=0
	tro:result'=0
	q result
}

/// Creator:		xww
/// CreateDate:		2021-08-23	
/// Input:			判断有无引用	
/// return：		0：没有，1有
/// w ##class(web.DHCCKBDiction).IsReference(dicID,HospID)
ClassMethod IsReference(dicID, hospId) As %String
{
	n (dicID,hospId)
	s hospId=""
	k TmpArr
	d ##class(web.DHCCKBGetDicSourceUtil).QueryDicInRuleValue(dicID,.TmpArr,hospId)	// 查询在规则中 RD_RightDic 被使用的情况
	s h=$o(TmpArr(""),-1)
	q:+h'=0 "1"
	d ##class(web.DHCCKBGetDicSourceUtil).QueryDicInRuleExt(dicID,.TmpArr,hospId)	// 查询在规则中 RD_RightExt 被使用的情况
	s h=$o(TmpArr(""),-1)
	q:+h'=0 "1"
	d ##class(web.DHCCKBGetDicSourceUtil).QueryDicInAttrDr(dicID,.TmpArr)		// 在属性关联表 DLA_Attr_Dr 被使用的情况
	s h=$o(TmpArr(""),-1)
	q:+h'=0 "1"
	d ##class(web.DHCCKBGetDicSourceUtil).QueryDicInDicDr(dicID,.TmpArr)		// 在属性关联表 DLA_DicDr_Dr 被使用的情况
	s h=$o(TmpArr(""),-1)
	q:+h'=0 "1"
	d ##class(web.DHCCKBGetDicSourceUtil).QueryDicInAttrCode(dicID,.TmpArr)	// 在属性关联表 DLA_AttrCode_Dr 被使用的情况
	s h=$o(TmpArr(""),-1)
	q:+h'=0 "1"
	q "0"
}

/// Creator:		xww
/// CreateDate:		2021-08-26	
/// Input:			判断有无匹配（数据映射界面安全用药药品库）	
/// return：		0：没有，1有
/// w ##class(web.DHCCKBDiction).IsGenMatch("st","st",2)
ClassMethod IsGenMatch(genCode, genDesc, hospId) As %String
{
	n (genCode,genDesc,hospId)
	
	s matchFlag=0
	i $d(^CKB.PDSS.ComContrastI("LibCode",$zcvt(genCode,"U")))&($d(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(genDesc,"U")))) d
	.s hisDesc=""
	.f  s hisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(genDesc,"U"),hisDesc)) q:(hisDesc="")||(matchFlag=1)   d
	..s conID = ""
	..f  s conID=$o(^CKB.PDSS.ComContrastI("LibDesc",$zcvt(genDesc,"U"),hisDesc,conID))  q:(conID="")||(matchFlag=1)   d
	...s listData =$g(^CKB.PDSS.ComContrastD(conID))
	...s libCode = $lg(listData,2) 
	...s libHosp =$lg(listData,7) //有存在医院id为空的情况
	...s:(libCode=genCode)&&((libHosp=hospId)||(libHosp="")) matchFlag=1 

	Q matchFlag
}

/// Creator:		qunianpeng
/// CreateDate:		2021-10-22	
/// Input:			字典描述,序号
/// return：		
/// w ##class(web.DHCCKBDiction).ChangeCount()
ClassMethod ChangeCount(desc As %String, seqno) As %String
{
	n (desc,seqno)
	s len = $length(seqno)
	s total = "8"

	f i=len:1:total d
	.s seqno = "0"_seqno 

	if (desc="西药字典") d
	.s seqno = "10"_seqno
	else  if (desc="中成药字典") d
	.s seqno = "11"_seqno
	else  if (desc="中药饮片字典") d
	.s seqno = "12"_seqno
	else  if (desc="中药方剂字典") d
	.s seqno = "13"_seqno
	else  if (desc="化学名字典") d
	.s seqno = "14"_seqno
	else  if (desc="处方应付字典") d
	.s seqno = "15"_seqno
	else  if (desc="通用名字典") d
	.s seqno = "16"_seqno
	else  if (desc="药品商品名字典") d
	.s seqno = "17"_seqno	
	else  if (desc="药学分类字典") d
	.s seqno = "18"_seqno
	else  if (desc="成分字典") d
	.s seqno = "19"_seqno
	else  if (desc="辅料字典") d
	.s seqno = "20"_seqno
	else  if (desc="西医疾病字典") d
	.s seqno = "21"_seqno
	else  if (desc="中医疾病字典") d
	.s seqno = "22"_seqno
	else  if (desc="症状字典") d
	.s seqno = "23"_seqno
	else  if (desc="给药途径字典") d
	.s seqno = "24"_seqno
	else  if (desc="用药频率字典") d
	.s seqno = "25"_seqno
	else  if (desc="剂型字典") d
	.s seqno = "26"_seqno
	else  if (desc="生产企业字典") d
	.s seqno = "27"_seqno
	else  if (desc="特殊人群字典") d
	.s seqno = "28"_seqno
	else  if (desc="职业字典") d
	.s seqno = "29"_seqno
	else  if (desc="单位字典") d
	.s seqno = "30"_seqno
	else  if (desc="药品目录字典") d
	.s seqno = "31"_seqno
	else  if (desc="专科分类字典") d
	.s seqno = "32"_seqno
	else  if (desc="药嘱信息字典") d
	.s seqno = "33"_seqno
	else  if (desc="文献字典") d
	.s seqno = "34"_seqno
	else  if (desc="检验项字典") d
	.s seqno = "35"_seqno
	else  if (desc="细菌字典") d
	.s seqno = "36"_seqno
	else  if (desc="菌属字典") d
	.s seqno = "37"_seqno
	else  if (desc="环境因素字典") d
	.s seqno = "38"_seqno
	else  if (desc="ICD诊断字典") d
	.s seqno = "39"_seqno
	
	else
	.s seqno = "99"_seqno

	q seqno
}

/// Description: 检查对照关系表是否存在对应数据
/// Creator:     LiDong
/// CreateDate:  2022-08-12 
/// Table:		 DHC_CKBComContrast
/// Input:  	 input:libCode^libDesc
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).CheckContrastExt("81646^测试通用名(复制11)^测试通用名(复制)^105")
ClassMethod CheckContrastExt(params)
{
	n (params)

	s ID = $p(params,"^",1)
	&SQL(
	SELECT CD_Code,CD_Desc
	INTO :befCode,:befDesc
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_RowID=:ID
	)
	&SQL(
	SELECT Count(*) INTO :Ret 
	FROM CKB_PDSS.ComContrast 
	WHERE CC_LibCode=:befCode AND CC_LibDesc=:befDesc)
	q Ret
}

/// Description: 更新对照表
/// Creator:     LiDong
/// CreateDate:  2022-08-15 
/// Table:		 DHC_CKBComContrast
/// Input:  	 input:libCode^libDesc
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).UpdExpFieldNum("1||2^1^1||1^2")
ClassMethod UpdContrast(params)
{
	n (params)

	s ID = $p(params,"^",1)
	s Code = $p(params,"^",2)
	s Desc = $p(params,"^",3)
	s parref = $p(params,"^",4)
	&SQL(
	SELECT CD_Code,CD_Desc
	INTO :befCode,:befDesc
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_RowID=:ID
	)
	&SQL(
	UPDATE CKB_PDSS.ComContrast SET CC_LibCode=:Code,CC_LibDesc=:Desc
	WHERE CC_LibCode=:befCode AND CC_LibDesc=:befDesc
	)
	q SQLCODE
}

/// Descript:获取各级分类
/// Creator:     sufan
/// CreateDate:  2022-08-29 
/// Table:		 
/// Input:  	 分类id
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).GetEveCat("122260")
ClassMethod GetEveCat(catId)
{
	n (catId)
	s flag=1
	s drugCatDataId = ##class(web.DHCCKBCommon).GetDrugCategoryData()
	s list = ""
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),4)
	Q:+parref="0" list
	while flag=1 {
		
		s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
		s:desc="新编药物学分类" desc="新编"
		s:desc="其他分类" desc="其他"
    	s parref = +$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),4)
    	s:parref=0 flag=0
    	i list = ""  s list = desc
    	e  s list = desc_"/"_list
    	i (parref=0)||(drugCatDataId=parref){
	    	s flag=0
	    } 
  	}
  	
  	Q $p(list,"/",2,$l(list,"/"))
}

/// Description: 处理字符串
/// Creator:     qunianpeng
/// CreateDate:  2023-04-25 
/// Table:		 
/// Input:  	 
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).DealStr()
ClassMethod DealStr(str)
{
	n (str)
	q:str="" ""
	s ret = ""
	s len = $length(str,",")
	f k=1:1:len  d
	.s tmpstr = $p(str,",",k)
	.s value = $P(tmpstr,"^",1)
	.i ret="" s ret=value
	.e  s ret=ret_","_value
	
	q ret
}

/// Descript:	根据attrData判断是不是字典。是则需要生成maxno
/// Creator:    qunianpeng
/// CreateDate: 2023-05-09 
/// Input:  	
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).SaveDataMaxNo()
ClassMethod SaveDataMaxNo(attrData, dicCode, dicDesc)
{
	n (attrData,dicCode,dicDesc)
	s type = $p(attrData,"^",2)
	q:type'="DictionFlag" ""
	
	s ret = ##class(web.DHCCKBDictionExt).SetMaxNoByDiction(dicCode,dicDesc)
	
	q ret
}

/// Descript:	根据parref判断是否需要自动生成编码(字典数据需要生成编码)
/// Creator:    qunianpeng
/// CreateDate: 2023-05-09 
/// Input:  	
/// Return: 	 
/// Others:		 w ##class(web.DHCCKBDiction).GetSysCodeByType()
ClassMethod GetSysCodeByType(parref, dicCode)
{
	n (parref,dicCode)
	s newCode = dicCode
	q:parref="" newCode
	s parrefCode =$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	s parrefDesc =$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	s rootParref = ##class(web.DHCCKBCommon).GetParref(parref)
	i rootParref="" d // parref是跟节点
	.s exitFlag = ##class(web.DHCCKBCommon).CheckDictionFlag(parref)
	.q:exitFlag=0 	// parref不是字典,则退出
	.q:parrefCode=""
	.s newCode = ##class(web.DHCCKBDictionExt).GetSysCodeByType(parrefCode,parrefDesc)
	e  d
	.s exitFlag=##class(web.DHCCKBCommon).CheckDictionFlag(rootParref) 
	.q:exitFlag=0 //rootParref 不是字典,则退出
	.s count = 1
	.s lastSub = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,""),-1) // 当前节点下没有子数据,则从1开始编码
	.i lastSub="" s count = 1
	.e  d
	..s lastSubCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+lastSub)),2)  // 当前节点下没有有数据,则用最大子编码+1
	..s lastSubCode = $p(lastSubCode,".",$l(lastSubCode,".")) 
	..s count = ##class(web.DHCCKBCommonUtil).GetNum(lastSubCode)+1
	.s newCode = parrefCode_"."_##class(web.DHCCKBCommonUtil).AddZero("prev",5,count)	
	
	q newCode
}

}
