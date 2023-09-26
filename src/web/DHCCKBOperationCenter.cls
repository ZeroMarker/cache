Import sqluser

Class web.DHCCKBOperationCenter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	药品类型分布统计图
/// Creator:		xww
/// CreateDate:		2021-10-19	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryDrugNumByType()
ClassMethod QueryDrugNumByType()
{
	k TmpArr
	s del=""""
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s chineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s chineseHMDataID=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片
	s chinaMedPrescID=##class(web.DHCCKBCommon).GetChinaMedPrescData()  // 中药经方字典
	s drugCount=0,chineseDrugCount=0,chineseHMCount=0,chinaMedPrescCount=0
	// 获取西药数量
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataID,dicID))   q:dicID=""  d
	.s flag=##class(web.DHCCKBCommon).IsEnabled(dicID)   //过滤已停用
	.q:flag=0
	.s drugCount=drugCount+1	
	// 获取中成药数量
	s chinesedicID=""   f  s chinesedicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",chineseDrugDataID,chinesedicID))   q:chinesedicID=""  d
	.s flag=##class(web.DHCCKBCommon).IsEnabled(chinesedicID)   //过滤已停用
	.q:flag=0
	.s chineseDrugCount=chineseDrugCount+1
	// 获取中药饮片
	s chineseHMdicID=""   f  s chineseHMdicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",chineseHMDataID,chineseHMdicID))   q:chineseHMdicID=""  d
	.s flag=##class(web.DHCCKBCommon).IsEnabled(chineseHMdicID)   //过滤已停用
	.q:flag=0
	.s chineseHMCount=chineseHMCount+1
	// 中药经方字典
	s chinaMedPrescDicID=""   f  s chinaMedPrescDicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",chinaMedPrescID,chinaMedPrescDicID))   q:chinaMedPrescDicID=""  d
	.s flag=##class(web.DHCCKBCommon).IsEnabled(chinaMedPrescDicID)   //过滤已停用
	.q:flag=0
	.s chinaMedPrescCount=chinaMedPrescCount+1
	s total=drugCount+chineseDrugCount+chineseHMCount+chinaMedPrescCount
	s listTitle="name^value^group"
	w "{""drugstat"":["
	w ##class(web.DHCEMJsonCommon).getJsonDataEcharts(listTitle,"西药^"_drugCount_"^数量")
	w ","_##class(web.DHCEMJsonCommon).getJsonDataEcharts(listTitle,"中成药^"_chineseDrugCount_"^数量")
	w ","_##class(web.DHCEMJsonCommon).getJsonDataEcharts(listTitle,"中药饮片^"_chineseHMCount_"^数量")
	w ","_##class(web.DHCEMJsonCommon).getJsonDataEcharts(listTitle,"经典名方^"_chinaMedPrescCount_"^数量")
	w "],""total"":"_total_","
	w del_"drugCount"_del_":"_drugCount_","
	w del_"chineseHMCount"_del_":"_chineseHMCount_","
	w del_"chinaMedPrescCount"_del_":"_chinaMedPrescCount_","
	w del_"chineseDrugCount"_del_":"_chineseDrugCount_"}"
	q ""
}

/// Creator：      xww
/// CreatDate：    2021-10-09
/// Description:： 查询当前分类是所有子类,并输出每个子类关联的所有药品(获取总数total)
/// w ##class(web.DHCCKBOperationCenter).QueryDurgListByCat(147)
ClassMethod QueryDurgListByCat(queryCat)
{
	n (queryCat) //kml %session //kml 2020-03-26 add 'userInfo'
	s total=0
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat))  d
	.d ..GetChildCat(queryCat,.total) //kml 2020-03-26 add 'userInfo'
	e  d
	.d ..GetDrugByCat(queryCat,.total) //kml 2020-03-26 add 'userInfo'
	
	
	q total
}

/// Creator：      xww
/// CreatDate：    2021-10-09
/// Description:： 查询当前分类是所有子类,并输出每个子类关联的所有药品
/// w ##class(web.DHCCKKBIndex).GetDrugList(4316)
ClassMethod GetChildCat(queryCat, total, start, end, parStr = "", userInfo = "", version)
{
	n (queryCat,total) //kml %session //kml 2020-03-26 add 'userInfo'
	
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat))  d
	.s subCatId=""
	.f  s subCatId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat,subCatId))  q:subCatId=""  d
	..d ..GetChildCat(subCatId,.total) //kml 2020-03-26 add 'userInfo'
	e  d
	.d ..GetDrugByCat(queryCat,.total) //kml 2020-03-26 add 'userInfo'
}

/// Creator：      xww
/// CreatDate：    2021-10-09
/// Description:： 查询药品列表,通过药学分类id
/// w ##class(web.DHCCKKBIndex).GetDrugList(4316)
ClassMethod GetDrugByCat(queryCat, total, parStr = "")
{
	n (queryCat,total) //kml %session //kml 2020-03-26 add 'userInfo'
	
	s catPropId=##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")	// 药学分类属性	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId)) ""
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //kml 2020-03-13 
	s linkId="" f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId,linkId)) q:linkId=""  d
	.q:+linkId=0
	.s drugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),2)
	.q:+drugId=0    ;Shy 2020-01-09 GetDicValueByPro+9^web.DHCCKBDrugVO.1 *attrDesc 未定义
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.s total=total+1	
	q ""
}

/// Description:	中成药或西药数量按分类统计图
/// Creator:		xww
/// CreateDate:		2021-10-19	
/// Input:			Type
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryChineseDrugByType("NewDrugCat")
ClassMethod QueryChineseDrugByType(code)
{
	n (code)
	k TmpArr
	s DrugCategoryDataDr=##class(web.DHCCKBCommon).GetDicIdByCode(code)
	s count=0
	//一级菜单
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugCategoryDataDr,id)) q:id=""  d
	.q:+id=0
	.q:##class(web.DHCCKKBIndex).CheckStopDic(id)=1 
	.s count=..QueryDurgListByCat(id)
	.s TmpArr(id)=count
	s ListTitle="name^value^group"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s desc=##class(web.DHCCKKBIndex).GetDicDesc(index)
	.s ListData=desc_"^"_$g(TmpArr(index))_"^单位：种"
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	q ""
}

/// Description:	获取服务机构个数
/// Creator:		xww
/// CreateDate:		2021-10-19	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryHospNum()
ClassMethod QueryHospNum()
{
	s num=""
	&sql(select count(distinct(CC_Hospital)) into :num from CKB_PDSS.ComContrast)
	q num
}

/// Description:	获取最新发布药品（5个）
/// Creator:		xww 
/// CreateDate:		2021-10-20
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryNewReleaseDrug(5,1)
ClassMethod QueryNewReleaseDrug(rows = 10, page = 1) As %String
{
	n (rows,page)
	s ^temptest("QueryNewReleaseDrug")=$lb(rows,page)
	s end = page*rows
	s start=(page-1)*rows+1
	s count=0
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s chineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s chineseHMDataID=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片
	s chinaMedPrescID=##class(web.DHCCKBCommon).GetChinaMedPrescData()  // 中药经方字典
	s listTitle="dicDrugDesc^dicUser^dicDateTime"
	w "{""rows"":["
	s dlgId=""
	f  s dlgId=$o(^CKB.PDSS.DicLogD(dlgId),-1) q:(dlgId="")||(count>7)  d
	.s listData = $g(^CKB.PDSS.DicLogD(dlgId))
	.s dicDr= $lg(listData,2) 
	.q:dicDr'="DHC_CKBCommonDiction"
	.s dicFunction= $lg(listData,4)
	.;q:dicFunction'="confirm"
	.q:dicFunction'="grantAuth"
	.s dicDrugId= $lg(listData,3) 
	.s parrf=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicDrugId)),4)
	.q:(parrf'=drugDataID)&&(parrf'=chineseDrugDataID)&&(parrf'=chineseHMDataID)&&(parrf'=chinaMedPrescID)
	.s dicDrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicDrugId)),3)
	.s dicUser=$lg(listData,5)
	.s:dicUser'="" dicUser=$p(^SSU("SSUSR",dicUser),"^",2)
	.s dicDate= $lg(listData,6)
	.s:dicDate'="" dicDate=$zd(dicDate,3)
	.s dicTime= $lg(listData,7) 
	.s:dicTime'="" dicTime=$zt(dicTime,1)
	.s dicDateTime=dicDate_" "_dicTime
	.s listData=dicDrugDesc_"^"_dicUser_"^"_dicDateTime
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	w "],""total"":"_count_"}"
	q ""
}

/// Description: 每月新增规则数量
/// Creator:     xww
/// CreateDate:  2021-10-20
/// Input:  	 "
/// Output:   	 月份^数量^总数量
/// Others:		 d ##class(web.DHCCKBOperationCenter).StatAllRuleByMon()
ClassMethod StatAllRuleByMon() As %String
{
	s curYear=$SYSTEM.SQL.YEAR(+$h)
	s lastYear=curYear-1
	s yearstr=lastYear_","_curYear
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid)
	s (YearStr,DataStr)=""
	f i=1:1:$l(yearstr,",") d
	.s year=$p(yearstr,",",i)
	.s ^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid,"YEAR",year)=year
	.s stDate=$zdh(year_"-01-01",3)
	.s endDate=$zdh(year_"-12-31",3)
	.f date=stDate:1:endDate d
	..s rlLogID=""
	..f  s rlLogID=$o(^CKB.PDSS.RuleLogI("Date",date,rlLogID)) q:rlLogID=""  d
	...s logData = $g(^CKB.PDSS.RuleLogD(rlLogID))
	...s rlType=	$lg(logData,6)
	...q:rlType'="Add"
	...s rlLastLog=	$lg(logData,9)
	...q:rlLastLog'=0
	...s month=$SYSTEM.SQL.MONTH(date)
	...s ^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid,"MONTH",year,month)=$g(^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid,"MONTH",year,month))+1
	
	s year=""
	f  s year=$o(^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid,"YEAR",year)) q:year=""  d
	.s YearStr=$s(YearStr="":year,1:YearStr_"^"_year)
	.s yeardata=""
	.f month=1:1:12 d
	..s monthdata=$g(^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid,"MONTH",year,month))
	..s:monthdata="" monthdata="0"
	..s yeardata=$s(yeardata="":monthdata,1:yeardata_","_monthdata)
	.s yeardata=yeardata
	.s DataStr=$s(DataStr="":yeardata,1:DataStr_"^"_yeardata)
	k ^TMP("web.DHCCKBOperationCenter","StatAllRuleByMon",pid)
	w ##class(web.DHCAPPJsonCommon).getJsonData(YearStr,DataStr)
	q ""
}

/// Description:	本月药品发布情况
/// Creator:		xww 
/// CreateDate:		2021-10-20
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryConfirmDrug("2023-05-19")
ClassMethod QueryConfirmDrug(params) As %String
{
	n (params)

	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s chineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s chineseHMDataID=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片
	s chinaMedPrescID=##class(web.DHCCKBCommon).GetChinaMedPrescData()  // 中药经方字典
	s curDate=params
	s stDate=$e(curDate,0,7)_"-01"
	s stDate=$zdh(stDate,3)
	s curDate=$zdh(curDate,3)
	k TmpArr
	s confirmNum=0,unconfirmNum=0
	
	f date=stDate:1:curDate d
	.s dlgId=""
	.f  s dlgId=$o(^CKB.PDSS.DicLogI("Date",date,dlgId)) q:(dlgId="")  d
	..s listData = $g(^CKB.PDSS.DicLogD(dlgId))
	..s dicDr= $lg(listData,2)
	..q:dicDr'="DHC_CKBCommonDiction"
	..s dataDr= $lg(listData,3)
	..q:dataDr=""
	..;s parrf= $lg(listData,4)
	..s parrf=$lg(^CT.CKB.PDSS.CommonDictionD(dataDr),4)
	..q:(parrf'=drugDataID)&&(parrf'=chineseDrugDataID)&&(parrf'=chineseHMDataID)&&(parrf'=chinaMedPrescID)
	..s confirmFlag=##class(web.DHCCKBCommon).GetConfirmFlag(dataDr)
	..i confirmFlag=1 d
	...q:$d(TmpArr("confirmNum",dataDr))
	...s TmpArr("confirmNum",dataDr)=""
	...s confirmNum=confirmNum+1
	..e  d
	...q:$d(TmpArr("unconfirmNum",dataDr))
	...s TmpArr("unconfirmNum",dataDr)=""
	...s unconfirmNum=unconfirmNum+1
	q confirmNum_"^"_unconfirmNum
}

/// Description:	获取药品发布总数
/// Creator:		xww 
/// CreateDate:		2021-10-20
/// Input:			
/// return:			已发布总数^未发布总数
/// other:			w ##class(web.DHCCKBOperationCenter).QueryTotalConfirmDrug()
ClassMethod QueryTotalConfirmDrug() As %String
{
	k TmpArr
	s drugDataID=##class(web.DHCCKBCommon).GetDrugData()  				// 西药
	s chineseDrugDataID=##class(web.DHCCKBCommon).GetChineseDrugData()  // 中成药
	s chineseHMDataID=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片
	s chinaMedPrescID=##class(web.DHCCKBCommon).GetChinaMedPrescData()  // 中药经方字典
	s confirmNum=0,unconfirmNum=0
	s dataDr=""
	f  s dataDr=$o(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dataDr)) q:(dataDr="")  d
	.s parrf=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataDr)),4)
	.q:(parrf'=drugDataID)&&(parrf'=chineseDrugDataID)&&(parrf'=chineseHMDataID)&&(parrf'=chinaMedPrescID)
	.s confirmFlag=##class(web.DHCCKBCommon).GetConfirmFlag(dataDr)
	.i confirmFlag=1 d
	..q:$d(TmpArr("confirmNum",dataDr))
	..s TmpArr("confirmNum",dataDr)=""
	..s confirmNum=confirmNum+1
	.e  d
	..q:$d(TmpArr("unconfirmNum",dataDr))
	..s TmpArr("unconfirmNum",dataDr)=""
	..s unconfirmNum=unconfirmNum+1
	q confirmNum_"^"_unconfirmNum
}

/// Description:	查询规则里已经使用的属性
/// Creator:		xww 
/// CreateDate:		2021-10-20
/// Table:			CT_CKB_PDSS.DicLinkAttr
/// 				DLA_Dic_Dr(规则目录 ##class(web.DHCCKBCommon).GetDrugLibary())
/// 				DLA_AttrCode(属性字典)
/// 				DLA_Attr_Dr(前提条件|Preconditions/是否可用|Available 的字典id)
/// 				DLA_Result(结果 Y/N)
/// Others：		w ##class(web.DHCCKBOperationCenter).ListRuleDic(102)
ClassMethod ListRuleDic(TmpArr, catId = "")
{
	n (TmpArr,catId)
	s prop=##class(web.DHCCKBCommon).GetCheckItmListProp()		  // 项目列表属性
	s link=""
	s link="" f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",catId,prop,link)) q:link=""  d
	.q:link=0
	.s dic=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)	// 具体项目
	.q:+dic=0
	.q:$d(TmpArr(dic))
	.q:$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)=""
	.s TmpArr(dic)=""
	.i '$d(TmpArr("Count")) s TmpArr("Count")=1
	.e  s TmpArr("Count")=TmpArr("Count")+1
	.s TmpArr("desc",dic)=""
	q ""
}

/// Description:	获取审核项目数量
/// Creator:		xww 
/// CreateDate:		2021-10-20
/// Input:			
/// return:			审核项目数量
/// other:			w ##class(web.DHCCKBOperationCenter).GetAuditProjectNum()
ClassMethod GetAuditProjectNum()
{
	k TmpArr
	s DrugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugLibary,id)) q:id=""  d
	.q:+id=0
	.d ##class(web.DHCCKBOperationCenter).ListRuleDic(.TmpArr,id)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d
	..d ##class(web.DHCCKBOperationCenter).GetTreeSubNode(.TmpArr,id)

	s OutPutArr=##class(web.DHCCKBRuleIndex).GetDrugLibrary()	
	s globalData=##class(web.DHCCKBCommon).GetGlobalData()
	i ##class(web.DHCCKBCommon).IsEnabled(globalData)=0 q TmpArr("Count")
	
	d ##class(web.DHCCKBOperationCenter).ListRuleDic(.TmpArr,globalData)
	s dic=""
	f  s dic=$o(^CT.CKB.PDSS.CommonDictionI("Parref",globalData,dic))	q:dic=""   d
	.q:##class(web.DHCCKBCommon).IsEnabled(dic)=0
	.d ##class(web.DHCCKBOperationCenter).ListRuleDic(.TmpArr,dic)
	b ;22
	q TmpArr("Count")
}

/// Descript:目录多级查询子节点及规则
/// Creator:sufan
/// CreateDate:2020-05-25
/// Input:药品Id,上级，规则，登录信息
ClassMethod GetTreeSubNode(TmpArr, parentId)
{
	n (TmpArr,parentId)
	s subId = ""
	for  s subId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parentId,subId)) Q:subId=""  d
	.d ##class(web.DHCCKBOperationCenter).ListRuleDic(.TmpArr,subId)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subId))  d
  	..d ##class(web.DHCCKBOperationCenter).GetTreeSubNode(.TmpArr,subId)
    Q ""
}

/// Description:	获取规则数量
/// Creator:		xww
/// CreateDate:		2021-10-19	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBOperationCenter).QueryRuleNum()
ClassMethod QueryRuleNum()
{
	s num=""
	&sql(SELECT count(1) into :num FROM CT_CKB_PDSS.Rule )
	q num
}

}
