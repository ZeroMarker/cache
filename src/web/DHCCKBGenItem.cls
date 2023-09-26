Class web.DHCCKBGenItem Extends %RegisteredObject
{

/// Creator:      guozizhu
/// CreatDate:    2019-10-09
/// Description:  查询临床知识库中所有类型数据
/// Table:        DHC_CKBCommonDiction
/// Input:        q
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetTypeList","y")
Query GetTypeList(q As %String) As %Query(ROWSPEC = "CDRowID:%String,CDCode:%String,CDDesc:%String")
{
}

ClassMethod GetTypeListExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:q'="" q = $$ALPHAUP^SSUTIL4(q)  //q转换成大写
	
	s extraAttr = "KnowType"
	s extraAttrValue = "DictionFlag"
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)  //附加属性
	s dicID=""  
	f  s dicID = $o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID)) q:dicID=""  d
	.s linkID=""
	.f  s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",extraAttrDr,dicID,linkID)) q:linkID=""  d
	..s attrDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)  // 附加属性值
	..q:attrDr=""
	..s attrCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),2)  // 附加属性值(知识类型,区分实体、属性、数据源)
	..q:(extraAttrValue'="")&($zcvt(extraAttrValue,"U")'=$zcvt(attrCode,"U"))  //过滤非字典数据
	..s CDRowID = dicID
	..s CDCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),2)  //代码
	..s NewCDCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(CDCode))  //代码大写首字母
	..s CDDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),3)  //描述
	..s NewCDDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(CDDesc))  //描述大写首字母
	..i (('((CDCode'[q)&&(NewCDCode'[q)))||('((CDDesc'[q)&&(NewCDDesc'[q)))) d  //根据搜索字过滤
	...d OutputRowType
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowType
    set Data = $lb(CDRowID,CDCode,CDDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu
/// CreatDate:    2019-10-08
/// Description:  查询临床知识库中所有实体数据
/// Table:        DHC_CKBCommonDiction
/// Input:        desc, type
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetGenList","","")
Query GetGenList(desc As %String, type As %String) As %Query(ROWSPEC = "CDRowID:%String,CDCode:%String,CDDesc:%String,CDType:%String,CDLinkDr:%String")
{
}

ClassMethod GetGenListExecute(ByRef qHandle As %Binary, desc As %String, type As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //描述转换成大写
		
	s CDRowID = ""
	f  s CDRowID = $o(^CT.CKB.PDSS.CommonDictionD(CDRowID)) q:CDRowID=""  d
	.s CDCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),2)  //代码
	.s NewCDCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(CDCode))  //代码大写首字母
	.s CDDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),3)  //描述
	.s NewCDDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(CDDesc))  //描述大写首字母
	.s CDTypeID = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),4)  //类型代码
	.s CDType = ""
	.s:CDTypeID'="" CDType = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDTypeID)),3) //类型描述
	.s CDLinkDrID = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDRowID)),5)  //关联id
	.s CDLinkDr = ""
	.s:CDLinkDrID'="" CDLinkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(CDLinkDrID)),3)  //关联描述	
	.i ((type="")||(CDType=type))&&('((CDDesc'[desc)&&(NewCDDesc'[desc))) d  //过滤条件
	..d OutputRowGen
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowGen
    set Data = $lb(CDRowID,CDCode,CDDesc,CDType,CDLinkDr)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetGenListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGenListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGenListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGenListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-10
/// Description:  查询His中的所有药品处方通用名数据
/// Table:        User.PHCGeneric
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetDrugData","")
Query GetDrugData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetDrugDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^PHCGE("GE",HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^PHCGE("GE",HisRowID)),"^",1)  //药品代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //药品代码大写首字母
	.s HisDesc = $p($g(^PHCGE("GE",HisRowID)),"^",2)  //药品描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //药品描述大写首字母
	.s PHCGEDateTo = $p($g(^PHCGE("GE",HisRowID)),"^",6)  //药品数据失效期
	.q:((PHCGEDateTo'="")&&(PHCGEDateTo<+$h))  //根据药品数据失效期过滤
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowDrugData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowDrugData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetDrugDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu
/// CreatDate:    2019-10-10
/// Description:  查询His中所有诊断数据
/// Table:        User.MRCICDDx
/// Input:        desc
/// Return:       HisRowID, HisCode, HisDesc
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetDiseaseData","")
Query GetDiseaseData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetDiseaseDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //描述转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^MRC("ID",HisRowID)) q:HisRowID=""  d	
	.s HisCode = $p($g(^MRC("ID",HisRowID)),"^",1)  //疾病代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //疾病代码大写首字母
	.s HisDesc = $p($g(^MRC("ID",HisRowID)),"^",2)  //疾病描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //疾病描述大写首字母
	.q:((HisCode="-")||(HisDesc="-")) //屏蔽垃圾数据
	.s MRCIDValid = $p($g(^MRC("ID",HisRowID)),"^",27)  //MRCID有效性
	.q:(MRCIDValid="N")  //根据MRCID有效性过滤
	.s MRCIDDateActiveTo = $p($g(^MRC("ID",HisRowID)),"^",7)  //疾病数据有效期
	.q:((MRCIDDateActiveTo'="")&&(MRCIDDateActiveTo<+$h))  //根据疾病数据有效期过滤
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowDiseaseData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowDiseaseData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetDiseaseDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseaseDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiseaseDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseaseDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-28
/// Description:  查询His中的所有性别数据
/// Table:        CT_Sex
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetSexData","")
Query GetSexData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetSexDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^CT("SEX",HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^CT("SEX",HisRowID)),"^",1)  //性别代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //性别代码大写首字母
	.s HisDesc = $p($g(^CT("SEX",HisRowID)),"^",2)  //性别描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //性别描述大写首字母
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowSexData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowSexData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetSexDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSexDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSexDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSexDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有给药途径数据
/// Table:        PHC_Instruc
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetInstrucData","")
Query GetInstrucData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetInstrucDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^PHCIN(HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^PHCIN(HisRowID)),"^",1)  //给药途径代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //给药途径代码大写首字母
	.s HisDesc = $p($g(^PHCIN(HisRowID)),"^",2)  //给药途径描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //给药途径描述大写首字母
	.s PHCINActiveFlag = $p($g(^CT("SEX",HisRowID)),"^",3)  //给药途径有效性
	.q:(PHCINActiveFlag="N")  //根据给药途径有效性过滤
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc)))  //过滤条件
	..d OutputRowInstrucData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowInstrucData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetInstrucDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrucDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstrucDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrucDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有给药频率数据
/// Table:        User.PHCFreq
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetFreqData","")
Query GetFreqData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetFreqDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^PHCFR(HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^PHCFR(HisRowID)),"^",1)  //给药频率代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //频率代码大写首字母
	.s HisDesc = $p($g(^PHCFR(HisRowID)),"^",3)  //给药频率描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //频率描述大写首字母
	.s PHCFRActiveFlag = $p($g(^PHCFR(HisRowID)),"^",6)  //给药频率有效性
	.q:PHCFRActiveFlag="N"  //根据频率有效性过滤
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowFreqData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowFreqData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetFreqDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFreqDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFreqDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFreqDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有科室数据
/// Table:        CT_Loc
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetLocData","")
Query GetLocData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetLocDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
		
	s HisRowID = 0
	f  s HisRowID = $o(^CTLOC(HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^CTLOC(HisRowID)),"^",1)  //科室代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //科室代码大写首字母
	.s HisDesc = $p($g(^CTLOC(HisRowID)),"^",2)  //科室描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //科室描述大写首字母
	.s CTLOCActiveFlag = $p($g(^CTLOC(HisRowID)),"^",14)  //科室有效性
	.q:CTLOCActiveFlag="N"  //根据科室有效性过滤
	.s CTLOCDateActiveFrom = $p($g(^CTLOC(HisRowID)),"^",24)  //科室有效起始日期
	.q:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)  //根据科室有效起始日期过滤
	.s CTLOCDateActiveTo = $p($g(^CTLOC(HisRowID)),"^",25)  //科室有效结束日期
	.q:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)  //根据科室结束日期过滤	
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowLocData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowLocData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有单位数据
/// Table:        CT_UOM
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetUomData","")
Query GetUomData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetUomDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
		
	s HisRowID = 0
	f  s HisRowID = $o(^CT("UOM",HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^CT("UOM",HisRowID)),"^",1)  //单位代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //单位代码大写首字母
	.s HisDesc = $p($g(^CT("UOM",HisRowID)),"^",2)  //单位描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //单位描述大写首字母
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowUomData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowUomData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetUomDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUomDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUomDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUomDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有成分数据
/// Table:        PHC_Ingredient
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetIngredientData","")
Query GetIngredientData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetIngredientDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^PHC("INGR",HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^PHC("INGR",HisRowID)),"^",1)  //成分代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //成分代码大写首字母
	.s HisDesc = $p($g(^PHC("INGR",HisRowID)),"^",2)  //成分描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //成分描述大写首字母
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowIngredientData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowIngredientData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetIngredientDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIngredientDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIngredientDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIngredientDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有剂型数据
/// Table:        User.PHCForm
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetFormData","")
Query GetFormData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetFormDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^PHCF(HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^PHCF(HisRowID)),"^",1)  //剂型代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //剂型代码大写首字母
	.s HisDesc = $p($g(^PHCF(HisRowID)),"^",2)  //剂型描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //剂型描述大写首字母
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowFormData
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowFormData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetFormDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFormDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFormDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFormDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu		
/// CreatDate:    2019-10-29
/// Description:  查询His中的所有生产厂家数据
/// Table:        DHC_Manf_History
/// Input:        desc
/// Output:       HisRowID,HisCode,HisDesc
/// Other:        w ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetManfData","")
Query GetManfData(desc As %String) As %Query(ROWSPEC = "HisRowID:%String,HisCode:%String,HisDesc:%String")
{
}

ClassMethod GetManfDataExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s:desc'="" desc = $$ALPHAUP^SSUTIL4(desc)  //代码转换成大写
	
	s HisRowID = 0
	f  s HisRowID = $o(^DHCMANFH(HisRowID)) q:HisRowID=""  d
	.s HisCode = $p($g(^DHCMANFH(HisRowID)),"^",4)  //生产厂家代码
	.s NewHisCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisCode))  //生产厂家代码大写首字母
	.s HisDesc = $p($g(^DHCMANFH(HisRowID)),"^",5)  //生产厂家描述
	.s NewHisDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HisDesc))  //生产厂家描述大写首字母
	.i ('((HisDesc'[desc)&&(NewHisDesc'[desc))) d  //过滤条件
	..d OutputRowManfData
		
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowManfData
    set Data = $lb(HisRowID,HisCode,HisDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetManfDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManfDataExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetManfDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManfDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu
/// CreatDate:    2019-10-11
/// Description:  查询所有已关联的数据
/// Table:        DHC_CKBComContrast
/// Input:        libcode, hiscode, dictype
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBGenItem","GetContrastList","","","")
Query GetContrastList(libcode As %String, dictype As %String) As %Query(ROWSPEC = "CCRowID:%Integer,CCLibCode:%String,CCLibDesc:%String,CCHisCode:%String,CCHisDesc:%String,CCDicTypeDesc:%String")
{
}

ClassMethod GetContrastListExecute(ByRef qHandle As %Binary, libcode As %String, dictype As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	
	s CCRowID=0
	f  s CCRowID = $o(^CKB.PDSS.ComContrastD(CCRowID)) q:CCRowID=""  d
	.s listData = $g(^CKB.PDSS.ComContrastD(CCRowID))
	.s CCLibCode = $lg(listData,2) //知识库代码
	.s CCLibDesc = $lg(listData,3) //知识库描述
	.s CCHisCode = $lg(listData,4) //His代码
	.s CCHisDesc = $lg(listData,5) //His描述
	.s CCDicType = $lg(listData,6)  //实体类型ID
	.s:CCDicType'="" CCDicTypeDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(CCDicType)),3)  //实体类型名称
	.i ((CCLibCode=libcode)||(libcode=""))&&((CCDicType=dictype)||(dictype="")) d  //过滤条件
	..d OutputRowContrast
		
	
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRowContrast
    set Data = $lb(CCRowID,CCLibCode,CCLibDesc,CCHisCode,CCHisDesc,CCDicTypeDesc)
    set ^CacheTemp(repid,ind) = Data
    Set ind = ind+1
    quit
}

ClassMethod GetContrastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContrastListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetContrastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContrastListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	
	Set ind = $o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd = 1
		Set Row = ""
	}
	Else
	{
		Set Row = ^CacheTemp(repid,ind)
	}
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      guozizhu
/// CreatDate:    2019-10-12
/// Description:  临床知识库和His对照
/// Return:       成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:        w ##class(web.DHCCKBGenItem).SaveContrastData("101080105^红霉素软膏^TY0001^吲哚美辛巴布膏^药品字典^2")
ClassMethod SaveContrastData(contrastdata As %String) As %String
{
	s result = ""
	
	s libcode = $p(contrastdata,"^",1)  //知识库代码
    s libdesc = $p(contrastdata,"^",2)  //知识库描述
    s hiscode = $p(contrastdata,"^",3)  //His代码
    s hisdesc = $p(contrastdata,"^",4)  //His描述
    s dictype = $p(contrastdata,"^",5)  //实体类型
    s hospid = $p(contrastdata,"^",6)  //医院ID
	
	s hisexist = $o(^CKB.PDSS.ComContrastI("HisCode",hiscode,""))
	i (hisexist '= "") q "{success:'false',info:'该his通用名已对照, 不能重复对照!'}"
	
	s exist = $o(^CKB.PDSS.ComContrastI("LibCode",libcode,hiscode,""))
	i (exist '= "") q "{success:'false',info:'该记录已对照, 不能重复对照!'}"
	
	s obj=##class(CKB.PDSS.ComContrast).%New()
	s obj.CCLibCode = libcode
	s obj.CCLibDesc = libdesc
	s obj.CCHisCode = hiscode
	s obj.CCHisDesc = hisdesc
	s obj.CCDicType = dictype
	s obj.CCHospId = hospid
	//s logJson="{CCLibCode:"_$c(34)_libcode_$c(34)_",CCLibDesc:"_$c(34)_libdesc_$c(34)_",CCHisCode:"_$c(34)_hiscode_$c(34)_",CCHisDesc:"_$c(34)_hisdesc_$c(34)_",CCDicType:"_$c(34)_dictype_$c(34)_",CCHospId:"_$c(34)_hospid_$c(34)_"}"
	//这一行直接删除即可
	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	i $$$ISOK(sc) d
	.Tc		
	.s id = obj.%Id()
	.s result = "{success:'true',id:'"_id_"'}"  //返回RowId
	.//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_CKBComContrast","CKB.PDSS.ComContrast","通用名对照",id,libdesc,"A",logJson)
	.//删除后请在数据库中执行"SELECT * FROM BDP_DataChangeLog WHERE ClassName = 'CKB.PDSS.ComContrast'"，
	.//确认需要删除的信息无误后执行"DELETE FROM BDP_DataChangeLog WHERE ClassName = 'CKB.PDSS.ComContrast'"
	e  d
	.Trollback
	.s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	.//s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名对照","web.DHCCKBGenItem","SaveContrastData",logJson)
	.//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	.//这两行直接删除即可
	
	q result
}

/// Creator:      guozizhu
/// CreatDate:    2019-10-12
/// Description:  根据rowid删除对照数据
/// Return:       成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:        w ##class(web.DHCCKBGenItem).DeleteContrastData("1")
ClassMethod DeleteContrastData(rowid As %String) As %String
{
	s result=""

	Ts
	//s eobj = ##class(web.Entity.KB.DHCGenItmContrast).%New()
	//s pobj = ##class(CKB.PDSS.ComContrast).%OpenId(rowid)
	//s eobj.GICTRowId = rowid
	//s eobj.GICTCode = pobj.CCLibCode
	//s eobj.GICTDesc = pobj.CCLibDesc
	//s eobj.GICTHisCode = pobj.CCHisCode
	//s eobj.GICTHisDesc = pobj.CCHisDesc
	//这七行直接删除即可
	
	s sc=##class(CKB.PDSS.ComContrast).%DeleteId(rowid)
	if $$$ISOK(sc) d
	.Tc
	.s result="{success:'true',info:'删除成功！'}"
	.//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_CKBComContrast","CKB.PDSS.ComContrast","删除通用名对照",rowid,eobj.GICTDesc,"D",eobj)
	.//直接删除即可，前面已经把这里的一起清除了
	e  d
	.Trollback
	.s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	.//s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("删除通用名对照","web.DHCCKBGenItem","DeleteContrastData",eobj)
	.//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	.//这两行直接删除即可
	
	q result
}

}
