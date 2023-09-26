Class web.DHCCKBIndexZYYP Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 药品分类树一级
/// d ##class(web.DHCCKBIndexZYYP).CatToHTML()
ClassMethod CatToHTML(Code)
{
	n (Code)
	;s DrugCategoryDataDr=##class(web.DHCCKBCommon).GetDrugCategoryData()
	
	s DrugCategoryDataDr=##class(web.DHCCKBCommon).GetDicIdByCode(Code)
	s count=0
	//一级菜单
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugCategoryDataDr,id)) q:id=""  d
	.q:+id=0
	.q:..CheckStopDic(id)=1 //kml 2020-03-05 过滤停用
	.s count=count+1
	.w "<li class='sort-list-item' > "
	.w "<div class='sort-list-title"
	.i count=1 d
	..w " sort-list-title-selected" 
	.w "' dic="_id_">"
	.;w "   <h3 onclick='goTable(this)' data-id="_id_" data-title="""_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_""">"_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_"</h3>"
	.w "   <h3 onclick='goTable(this)' data-id="_id_" data-title="""_..GetDicDesc(id)_""">"_..GetDicDesc(id)_"</h3>"  //kml 2020-03-05
	.w "</div>"
	.w "<div class='sortsub fn-clear' "
	.i count=1 d
	..w " style='display:block' "
	.e  d
	..w " style='display:none' "
	.w ">"
	.w " 	<div class='sortsub-l' style='border-right: 1px solid #D8D8D8'>"
	.d ##class(web.DHCCKBIndexZYYP).CatLev2ToHTML(id)
	.w "	</div>"
	.w "    <div class='sortsub-r' >"
	.w "    </div>"
	.w "</div>"
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 药品分类树二级
ClassMethod CatLev2ToHTML(parref)
{
	n (parref)
	w "<ul class='sort-2-list sider-list' style='height:100%'>"
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:id=""  d
	.q:+id=0
	.q:..CheckStopDic(id)=1 //kml 2020-03-05 过滤停用
	.w "<li class='sort-2-list-item' >"
	.w "	<div class='sort-2-list-title' dic="_id_">" 
	.;w "     <h3 onclick='goTable(this)' data-id="_id_" data-title="""_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_""">"_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_"</h3>"  
	.w "     <h3 onclick='goTable(this)' data-id="_id_" data-title="""_..GetDicDesc(id)_""">"_..GetDicDesc(id)_"</h3>" //kml 2020-03-05
	.w "    </div>"
	.w "</li>"
	w "</ul>"
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 药品分类树三，四，五级
/// w ##class(web.DHCCKBIndexZYYP).CatLev3ToHTML(148)
ClassMethod CatLev3ToHTML(parref)
{
	
	n (parref)
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:id=""  d
	.q:+id=0
	.q:..CheckStopDic(id)=1 //kml 2020-03-05 过滤停用
	.w "<dl class='sortsub-item'> "
	.w "	<dh>" 
	.;w "     <a style='text-decoration: none' href='javascript:void(0);' onclick='goTable(this)' data-id="_id_" data-title="""_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_""">"_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_"</a>"
	.w "     <a style='text-decoration: none' href='javascript:void(0);' onclick='goTable(this)' data-id="_id_" data-title="""_..GetDicDesc(id)_""">"_..GetDicDesc(id)_"</a>" //kml-20200305  
	.w "   </dh>"
	.w "</dl>"
	.
	.s subId="" f  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",id,subId)) q:subId=""  d
	..q:..CheckStopDic(subId)=1 //kml 2020-03-05 过滤停用
	..w "<dl class='sortsub-item'> "
	..w "	<dt>" 
	..;w "     <a style='text-decoration: none'  href='javascript:void(0);' onclick='goTable(this)' data-id="_subId_" data-title="""_$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3)_""">"_$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3)_"</a>"  
	..w "     <a style='text-decoration: none'  href='javascript:void(0);' onclick='goTable(this)' data-id="_subId_" data-title="""_..GetDicDesc(subId)_""">"_..GetDicDesc(subId)_"</a>"  //kml
	..w "   </dt>"
	..w "	<dd>"
	..s subIdItm="" f  s subIdItm=$o(^CT.CKB.PDSS.CommonDictionI("Parref",subId,subIdItm)) q:subIdItm=""  d
	...q:..CheckStopDic(subIdItm)=1 //kml 2020-03-05 过滤停用
	...;w "<em><a style='text-decoration: none' href='javascript:void(0);' onclick='goTable(this)' data-id="_subIdItm_" data-title="""_$lg($g(^CT.CKB.PDSS.CommonDictionD(subIdItm)),3)_""">"_$lg($g(^CT.CKB.PDSS.CommonDictionD(subIdItm)),3)_"</a></em>" 
	...w "<em><a style='text-decoration: none' href='javascript:void(0);' onclick='goTable(this)' data-id="_subIdItm_" data-title="""_..GetDicDesc(subIdItm)_""">"_..GetDicDesc(subIdItm)_"</a></em>" //kml
	..w "   </dd>"
	..w "</dl>"
	q ""
}

/// Creator：      kemaolin
/// CreatDate：    2020-03-05
/// Description:： 取字典、link类型字典描述
/// 	Input:			id
/// 	Output:			描述
/// w ##class(web.DHCCKBIndexZYYP).GetDicDesc(dicID)
ClassMethod GetDicDesc(dicID)
{
	n (dicID)
	q:+dicID=0
	s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	s linkID=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5) 
	s:(desc="")&&(+linkID'=0) desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkID)),3) 
	
	q desc
}

/// Creator：      kemaolin
/// CreatDate：    2020-03-05
/// Description:： 停用字典检查
/// 	Input:			id
/// 	Return:			0 未停用，1 停用
/// w ##class(web.DHCCKBIndexZYYP).CheckStopDic(dicID)
ClassMethod CheckStopDic(dicID)
{
	n (dicID)
	s flag=0
	q:+dicID=0 flag
	q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID)) flag
	q:'$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"stop")) flag
	q:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"enable")) flag
	s flag=1
	q flag
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 查询药品
/// d ##class(web.DHCCKBIndexZYYP).List()
/// Input:
///       queryType:
///                1:药品名称
///                2:适应症
///                3:禁忌症
///                4:拼音   
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","1","硝苯地平片","","","2")   //kml 2020-03-26 add 'userInfo'
ClassMethod ListOld(page = 1, rows = 10, queryType = "", queryPar = "", queryCat = "", parStr = "", userInfo = "", drugOther = "")
{
  n (page,rows,queryType,queryPar,queryCat,parStr,userInfo,drugOther,%session)
  s start=(page-1)*rows+1
  s end=page*rows

  i queryCat'="" d ..QueryDurgListByCat(queryCat,start,end,parStr,userInfo)  //kml 2020-03-26 add 'userInfo'
  q:queryCat'="" ""
  
  i (queryPar'="")&&(drugOther'="") d ..CheckDrugList(queryPar,drugOther,queryType)
  q:(queryPar'="")&&(drugOther'="") ""
  
  s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^ProName"

  
  w "{""rows"":["
  s count=0 
  s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  d GetDrugInfo
  s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  d GetDrugInfo
  s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  d GetDrugInfo
  
  w "],""total"":"_count_"}"
  q ""
  
GetDrugInfo
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.q:'..LimitByContrast(desc, DrugData,userInfo)
	.s contrastFlag=..QueryByContrast(desc, DrugData, queryPar, queryType)
	.s ASCII=$ASCII(##class(web.DHCCKBCommonUtil).Upper(queryPar))
	.i (ASCII>=65)&&(ASCII<=90) d
	..s:queryType=1 queryType=4
	.s descPY=##class(web.DHCCKBCommonUtil).Upper(##class(web.DHCCKBCommonUtil).GetPYCODE(desc))
	.s ONameflag=##class(web.DHCCKBIndexZYYP).QueryByOtherName(id, queryPar, queryType) //别名查询
	.q:(queryType=1)&&(desc'[queryPar)&&(ONameflag=0)&&(contrastFlag=0)                 //名称描述  
	.q:(queryType=4)&&(descPY'[##class(web.DHCCKBCommonUtil).Upper(queryPar))&&(ONameflag=0)&&(contrastFlag=0)   //名称拼音
	.s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	.s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
	.s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面
	.i Indication=""  d
	..s Indication=##class(web.DHCCKBDrugVO).GetFunIndicat(id)	//取功能主治 sufan 2020-07-09 
	.i Contraindication=""  d
	..s Contraindication=##class(web.DHCCKBDrugVO).GetDrugContra(id)	//取禁忌	sufan 2020-07-09
	.//s Indication=##class(web.DHCCKBDrugVO).GetIndication(id) //kml 2020-05-06
	.//s Contraindication=##class(web.DHCCKBDrugVO).GetContraindication(id) //kml
	.q:(queryType=2)&&(Indication'[queryPar)                //适应症
	.q:(queryType=3)&&(Contraindication'[queryPar)          //禁忌症  
	.
	.i queryType=2 d
	..s Indication=$replace(Indication,queryPar,"<font color='red'>"_queryPar_"</font>")
	..
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	.s tmp=id_"^"_desc_"^"_incSpec_"^"_incPackage_"^"_incManf_"^"_Indication_"^"_Contraindication_"^"_Ingredient_"^"_GenerName_"^"_ProName
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 查询药品  
/// d ##class(web.DHCCKBIndexZYYP).List()
/// Input:
///       queryType:
///                1:药品名称
///                2:适应症
///                3:禁忌症 
///                4:拼音   
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","1","硝苯地平片","","","2")   //kml 2020-03-26 add 'userInfo'
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","1","阿托伐他汀钙片","","","2")
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","5","20%甘露醇注射液","","","2","阿托伐他汀钙片")
/// w ##class(web.DHCCKBIndexZYYP).List("1","15","","","110574","","2","","")
ClassMethod ListN(page = 1, rows = 10, queryType = "", queryPar = "", queryCat = "", parStr = "", userInfo = "", drugOther = "", version = "")
{
  n (page,rows,queryType,queryPar,queryCat,parStr,userInfo,drugOther,%session,version)
  s ^tmp("desc")=$lb(page,rows,queryType,queryPar,queryCat,parStr,userInfo,drugOther,version)
  
  i (queryType=2)||(queryType=3)  d ##class(web.DHCCKBComQuery).listDrug(page,rows,queryType,queryPar)
  q:(queryType=2)||(queryType=3) ""
  s start=(page-1)*rows+1
  s end=page*rows
  i queryCat'="" d ..QueryDurgListByCat(queryCat,start,end,parStr,userInfo,version)  //kml 2020-03-26 add 'userInfo'
  q:queryCat'="" ""
  
  i (queryPar'="")&&(drugOther'="") d ..CheckDrugList(queryPar,drugOther,queryType)
  q:(queryPar'="")&&(drugOther'="") ""
  
  s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^ProName"
  
  w "{""rows"":["
  s count=0 
  s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  d GetDrugInfoNew
  s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  d GetDrugInfoNew
  s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  d GetDrugInfoNew
  s DrugData=##class(web.DHCCKBCommon).GetChinaMedPrescData() //中药经方 qnp 2021-05-19
  d GetDrugInfoNew
  
  w "],""total"":"_count_"}"
  q ""
  
GetDrugInfoNew
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.q:(version'="Dev")&&('..LimitByContrast(desc, DrugData,userInfo))	// qnp 2021/5/19 增加版本控制，Dev可不过滤对照
	.;s contrastFlag=..QueryByContrast(desc, DrugData, queryPar, queryType)
	.;s ASCII=$ASCII(##class(web.DHCCKBCommonUtil).Upper(queryPar))
	.;i (ASCII>=65)&&(ASCII<=90) d
	.;.s:queryType=1 queryType=4
	.;s descPY=##class(web.DHCCKBCommonUtil).Upper(##class(web.DHCCKBCommonUtil).GetPYCODE(desc))
	.;s ONameflag=##class(web.DHCCKBIndexZYYP).QueryByOtherName(id, queryPar, queryType) //别名查询
	.;q:(queryType=1)&&(desc'[queryPar)&&(ONameflag=0)&&(contrastFlag=0)                 //名称描述  
	.;q:(queryType=4)&&(descPY'[##class(web.DHCCKBCommonUtil).Upper(queryPar))&&(ONameflag=0)&&(contrastFlag=0)   //名称拼音
	.q:(queryType=1)&&(desc'[queryPar)            //名称描述  kml
	.s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	.s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
	.s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面
	.i Indication=""  d
	..s Indication=##class(web.DHCCKBDrugVO).GetFunIndicat(id)	//取功能主治 sufan 2020-07-09 
	.i Contraindication=""  d
	..s Contraindication=##class(web.DHCCKBDrugVO).GetDrugContra(id)	//取禁忌	sufan 2020-07-09
	.//s Indication=##class(web.DHCCKBDrugVO).GetIndication(id) //kml 2020-05-06
	.//s Contraindication=##class(web.DHCCKBDrugVO).GetContraindication(id) //kml
	.q:(queryType=2)&&(Indication'[queryPar)                //适应症
	.q:(queryType=3)&&(Contraindication'[queryPar)          //禁忌症  
	.i queryType=2 d
	..s Indication=$replace(Indication,queryPar,"<font color='red'>"_queryPar_"</font>")
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	.s tmp=id_"^"_desc_"^"_incSpec_"^"_incPackage_"^"_incManf_"^"_Indication_"^"_Contraindication_"^"_Ingredient_"^"_GenerName_"^"_ProName
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)
}

/// Description:	查询对照字典
/// Creator:		kml 
/// CreateDate:		2020-09-01
/// Input:			id,q
/// return:			对照字典列表
/// other:			w ##class(web.DHCCKBIndexZYYP).QueryContrastComgrid(20,1,"DrugData","盐酸氯丙嗪")
ClassMethod QueryContrastComgrid(rows = 10, page = 1, id As %String, q As %String = "") As %String
{
	n (rows,page,id,q)
	s ^temptest("456")=$lb(rows,page,id,q)
	s input=$zcvt(q,"U")
	s end = page*rows
	s start=(page-1)*rows+1
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  	i +DrugData'=0 d GetContrastInfo
  	s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  	i +DrugData'=0 d GetContrastInfo
  	s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  	i +DrugData'=0 d GetContrastInfo
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="hisDesc^libDesc^ProName^Ingredient^Contraindication^Indication"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,index))
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	
	k ^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid)
	q ""
	
GetContrastInfo	
	s ccID="" f  s ccID=$o(^CKB.PDSS.ComContrastI("Type",DrugData,ccID)) q:ccID=""  d
	.s listData =$g(^CKB.PDSS.ComContrastD(ccID))
	.s hisDesc = $lg(listData,5)
	.s libDesc = $lg(listData,3)
	.s libCode = $lg(listData,2) 
	.s libId=##class(web.DHCCKBRuleImport).CheckDictionExist(libCode,libDesc,DrugData)
	.q:+libId=0
	.q:##class(web.DHCCKBCommon).IsEnabled(libId)'=1
	.s DicType=$lg(listData,6)
	.s pinDesc=##class(web.DHCCKBCommonUtil).GetPYCODE(hisDesc)
	.q:(input'="")&($zcvt(hisDesc,"U")'[input)&($zcvt(libDesc,"U")'[input)&(pinDesc'[input)

	.s id = ..getCommonDiction(libCode, libDesc, DicType)
	.s ProName=""
	.s Ingredient=""
	.s Contraindication=""
	.s Indication=""
	.i id'="" d
	..s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	..s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	..s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	..s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	..s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
	..s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面

	.s data=hisDesc_"^"_libDesc_"^"_ProName_"^"_Ingredient_"^"_Contraindication_"^"_Indication
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,h)=data
}

/// d ##class(web.DHCCKBIndexZYYP).CheckDrugList("氨茶碱缓释片", "20%甘露醇注射液",5)
ClassMethod CheckDrugList(DrugOne, DrugOther, queryType)
{
	n (DrugOne,DrugOther,queryType)
	
	s DrugOneID="",DrugOtherID="",LibraryID=""
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
	s DrugDesc=DrugOne
  	d GetDrugID
  	s DrugOneID=DrugID
	s DrugDesc=DrugOther
	d GetDrugID
	s DrugOtherID=DrugID
	i DrugOneID s str = DrugOne
	i DrugOther s str = DrugOne
	s str = "未匹配到药品："_str
	i (DrugOneID="")||(DrugOtherID="")  w "{""rows"":[{""title"":"""_str_"""}],""total"":1}"
	q:(DrugOneID="")||(DrugOtherID="") ""
	i queryType=5  d
	.s LibraryID=##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")
	.w ##class(web.DHCCKBPassNew).CheckPropInRule(DrugOneID,DrugOtherID,LibraryID,"")
	i queryType=6  d
	.s LibraryID=##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")
	.w ##class(web.DHCCKBPassNew).CheckPropInRule(DrugOneID,DrugOtherID,LibraryID,"")
	
GetDrugID
	s DrugID=""
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:(id="")||(DrugID'="")   d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.//q:'..LimitByContrast(desc, DrugData,userInfo)
	.//s contrastFlag=..QueryByContrast(desc, DrugData, queryPar, queryType)
	.//s ASCII=$ASCII(##class(web.DHCCKBCommonUtil).Upper(queryPar))
	.q:(desc'=DrugDesc) //&&(contrastFlag=0)                 //名称描述  	
	.s DrugID=id
}

/// w ##class(web.DHCCKBIndexZYYP).GetDrugDataList("阿司匹林","",1)   //kml 2020-03-26 add 'userInfo'
ClassMethod GetDrugDataList(queryPar = "", userInfo = "", queryType = 1)
{
  n (queryPar,userInfo,queryType)
  
  //w "{""rows"":["
  s count=0 
  s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  d GetDrugDataList
  s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  d GetDrugDataList
  s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  d GetDrugDataList
  
  //w "],""total"":"_count_"}"
  q ""
  
GetDrugDataList
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.q:desc=""
	.//q:'..LimitByContrast(desc, DrugData,userInfo)
	.s contrastFlag=..QueryByContrast(desc, DrugData, queryPar, queryType)
	.s ASCII=$ASCII(##class(web.DHCCKBCommonUtil).Upper(queryPar))
	.i (ASCII>=65)&&(ASCII<=90) d
	..s:queryType=1 queryType=4
	.s descPY=##class(web.DHCCKBCommonUtil).Upper(##class(web.DHCCKBCommonUtil).GetPYCODE(desc))
	.s ONameflag=##class(web.DHCCKBIndexZYYP).QueryByOtherName(id, queryPar, queryType) //别名查询
	.q:(queryType=1)&&(desc'[queryPar)&&(ONameflag=0)&&(contrastFlag=0)                 //名称描述  
	.q:(queryType=4)&&(descPY'[##class(web.DHCCKBCommonUtil).Upper(queryPar))&&(ONameflag=0)&&(contrastFlag=0)   //名称拼音
	.
	.s count=count+1
	.q:count>15
	.;w $case(count,1:"",:",")
	.;w ##class(web.DHCAPPJsonCommon).getJsonData("value",desc)
	.w "<option value='"_desc_"'>"
}

/// Creator：      kemaolin
/// CreatDate：    2020-03-02
/// Description:： 根据对照限制查药品
/// 	Input:			描述，字典，用户信息
/// Return:			1 存在，0 不存在
/// w ##class(web.DHCCKBIndexZYYP).LimitByContrast("注射用青霉素钠", 150)
/// w ##class(web.DHCCKBIndexZYYP).LimitByContrast("注射用青霉素钠80万U(华北制药股份有限公司)", 105,2)
ClassMethod LimitByContrast(desc, dicType, userInfo = "")
{
	n (desc,dicType,userInfo,%session)
	s flag=0
	q:desc="" 0
	s HospDr = $p($g(userInfo),"^",1)
	s hospDesc=$p($g(^CT("HOSP",HospDr)),"^",2)
	q:hospDesc="东华标准版数字化医院[总院]" 1
	
	s hisDesc=""
	f  s hisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(desc),hisDesc)) q:(hisDesc="")||(flag=1)  d
	.s CCRowID=""
	.f  s CCRowID=$o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(desc),hisDesc,CCRowID)) q:(CCRowID="")||(flag=1)  d
	..q:+CCRowID=0
  	..q:'$d(^CKB.PDSS.ComContrastD(CCRowID))
  	..s type = $lg(^CKB.PDSS.ComContrastD(CCRowID),6)
  	..q:type'=dicType  //药品和商品名可能描述相同,区分字典
  	..s flag=1
  	q flag
}

/// Creator：      kemaolin
/// CreatDate：    2020-03-02
/// Description:： 通过医院的对照名查询
/// 	Input:			描述，字典，his描述，1文本\4拼音
/// Return:			1 存在，0 不存在
/// w ##class(web.DHCCKBIndexZYYP).QueryByContrast("注射用青霉素钠", 105, "注射用青霉素钠[80万IU]", 1)
ClassMethod QueryByContrast(desc, dicType, queryPar, queryType = 1)
{
	n (desc,dicType,queryPar, queryType)
	s flag=0
	s hisDesc=""
	f  s hisDesc=$o(^CKB.PDSS.ComContrastI("LibDesc",desc,hisDesc)) q:(hisDesc="")||(flag=1)  d
	.s CCRowID=""
	.f  s CCRowID=$o(^CKB.PDSS.ComContrastI("LibDesc",desc,hisDesc,CCRowID)) q:(CCRowID="")||(flag=1)  d
	..q:+CCRowID=0
  	..q:'$d(^CKB.PDSS.ComContrastD(CCRowID))
  	..s type=$lg(^CKB.PDSS.ComContrastD(CCRowID),6)
  	..q:type'=dicType  //药品和商品名可能描述相同,区分字典
  	..s hisDescPY=##class(web.DHCCKBCommonUtil).Upper(##class(web.DHCCKBCommonUtil).GetPYCODE(hisDesc))
  	..q:(queryType=1)&&(hisDesc'[queryPar)  //名称描述  
  	..q:(queryType=4)&&(hisDescPY'[##class(web.DHCCKBCommonUtil).Upper(queryPar))  //名称拼音
  	..s flag=1
  	q flag
}

/// Creator：      kemaolin
/// CreatDate：    2020-03-02
/// Description:： 根据别名查药品
/// 	Input:			药品id，his描述，1文本\4拼音
/// Return:			1 存在，0 不存在
/// w ##class(web.DHCCKBIndexZYYP).QueryByOtherName(150, "qms", 4)
ClassMethod QueryByOtherName(dicID, queryPar, queryType = 1)
{
	n (dicID,queryPar,queryType)
	s flag=0,attrDr=""
	s otherNameProp=##class(web.DHCCKBCommon).GetOtherNameProp()
	q:(queryType'=1)&&(queryType'=4) flag
	q:+otherNameProp=0 flag
	f  s attrDr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicID,otherNameProp,attrDr)) q:(attrDr="")||(flag=1)  d
	.q:+attrDr=0
  	.q:'$d(^CT.CKB.PDSS.CommonDictionD(attrDr))
  	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrDr)),3)
  	.s descPY=##class(web.DHCCKBCommonUtil).Upper(##class(web.DHCCKBCommonUtil).GetPYCODE(desc))
  	.q:(queryType=1)&&(desc'[queryPar)  //名称描述  
  	.q:(queryType=4)&&(descPY'[##class(web.DHCCKBCommonUtil).Upper(queryPar))  //名称拼音
  	.s flag=1
  	q flag
}

/// Creator：      zhouxin
/// CreatDate：    2019-07-02
/// Description:： 查询面包屑
/// w ##class(web.DHCCKBIndexZYYP).GetCrumb("",81885,"坤泰胶囊",1)
ClassMethod GetCrumb(queryCat = "", incId = "", input = "", inputType = "")
{
	n (queryCat,incId,input,inputType)
	s retArr=[]
	
	i +incId'=0 {
		s inc={}.%Set("id",incId).%Set("desc",$lg($g(^CT.CKB.PDSS.CommonDictionD(incId)),3)).%Set("type","inc")
		d retArr.%Push(inc)
	}
	
	i +queryCat'=0 {
		s cat={}.%Set("id",queryCat).%Set("desc",$lg($g(^CT.CKB.PDSS.CommonDictionD(queryCat)),3)).%Set("type","cat")
		d retArr.%Push(cat)
		
		s flag=1,parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(queryCat)),4)
		WHILE flag=1 {
			
			s cat={}.%Set("id",parref).%Set("desc",$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)).%Set("type","cat")
			d retArr.%Push(cat)
			//w retArr.%ToJSON()
	    	s parref=+$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),4)
	    	s:parref=0 flag=0
			//continue:parref=0
	    	i parref=0{
		    	s flag=0
		    	d retArr.%Pop()
		    } 
	  	}
	}
	
	i input'="" {
		s inputObj={}.%Set("id",input).%Set("desc",input).%Set("type","input")
		d retArr.%Push(inputObj)
	}
	
  	w retArr.%ToJSON()
  	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-05
/// Description:： 查询药品列表,通过药学分类id
/// w ##class(web.DHCCKBIndexZYYP).GetDrugList(156)
ClassMethod GetDrugList(queryCat)
{
	n (queryCat)
	s start=1
	s end=100
	s catPropId=##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")	// 药学分类属性
	
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId)) w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId)) ""
	
 	s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^FormType"
	
	w "{""rows"":["	
	s count=0 
	s linkId="" f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId,linkId)) q:linkId=""  d
	.q:+linkId=0
	.s drugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),2)
	.q:+drugId=0      ;Sunhuiyong  2020-1-20 药品信息显示不全
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.//s ASCII=$ASCII(##class(web.DHCCKBCommonUtil).Upper(queryPar))
	.s Indication=##class(web.DHCCKBDrugVO).GetIndication(drugId)
	.s Contraindication=##class(web.DHCCKBDrugVO).GetContraindication(drugId)
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(drugId)
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(drugId)
	.s tmp=drugId_"^"_desc_"^"_incSpec_"^"_incPackage_"^"_incManf_"^"_Indication_"^"_Contraindication_"^"_Ingredient_"^"_GenerName
	.s count=count+1
	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,tmp)
	w "],""total"":"_count_"}"
	
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-05
/// Description:： 查询当前分类是所有子类,并输出每个子类关联的所有药品
/// w ##class(web.DHCCKBIndexZYYP).QueryDurgListByCat("50032",1,15,"106661$106665$","2")
ClassMethod QueryDurgListByCat(queryCat, start, end, parStr = "", userInfo = "", version = "")
{
	n (queryCat,start,end,parStr,%session,userInfo,version) //kml %session //kml 2020-03-26 add 'userInfo'
	w "{""rows"":["	
	
	s total=0
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat))  d
	.d ..GetChildCat(queryCat,.total,start,end,parStr,userInfo,version) //kml 2020-03-26 add 'userInfo'
	e  d
	.d ..GetDrugByCat(queryCat,.total,start,end,parStr,userInfo,version) //kml 2020-03-26 add 'userInfo'
	
	w "],""total"":"_total_"}"
	
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-05
/// Description:： 查询当前分类是所有子类,并输出每个子类关联的所有药品
/// w ##class(web.DHCCKBIndexZYYP).GetDrugList(4316)
ClassMethod GetChildCat(queryCat, total, start, end, parStr = "", userInfo = "", version)
{
	n (queryCat,total,start,end,parStr,%session,userInfo,version) //kml %session //kml 2020-03-26 add 'userInfo'
	
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat))  d
	.s subCatId=""
	.f  s subCatId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",queryCat,subCatId))  q:subCatId=""  d
	..d ..GetChildCat(subCatId,.total,start,end,parStr,userInfo,version) //kml 2020-03-26 add 'userInfo'
	e  d
	.d ..GetDrugByCat(queryCat,.total,start,end,parStr,userInfo,version) //kml 2020-03-26 add 'userInfo'
}

/// Creator：      qunianpeng
/// CreatDate：    2019-11-05
/// Description:： 查询药品列表,通过药学分类id
/// w ##class(web.DHCCKBIndexZYYP).GetDrugList(4316)
ClassMethod GetDrugByCat(queryCat, total, start, end, parStr = "", userInfo = "", version = "")
{
	n (queryCat,total,start,end,parStr,%session,userInfo,version) //kml %session //kml 2020-03-26 add 'userInfo'
	
	s catPropId=##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")	// 药学分类属性	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId)) ""
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //kml 2020-03-13
 	s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^FormType^Manufacturer^Indication^HospUsed^AproNum"	
	s count=0 
	s linkId="" f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",queryCat,catPropId,linkId)) q:linkId=""  d
	.q:+linkId=0
	.s drugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),2)
	.q:+drugId=0    ;Shy 2020-01-09 GetDicValueByPro+9^web.DHCCKBDrugVO.1 *attrDesc 未定义
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.q:(version'="Dev")&&('..LimitByContrast(desc, DrugData,userInfo)) //kml 2020-03-13 //kml 2020-03-26 add 'userInfo'
	.s Indication=##class(web.DHCCKBDrugVO).GetIndication(drugId)
	.s Contraindication=##class(web.DHCCKBDrugVO).GetContraindication(drugId)
	.s incManf="",incSpec="",incPackage="",FormType="",Manufacturer=""
	.s FormType=##class(web.DHCCKBDrugVO).GetFormType(drugId)
	.s Manufacturer=##class(web.DHCCKBDrugVO).GetManufacturer(drugId)
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(drugId)
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(drugId)
	.s QuitFlag= ##class(web.DHCCKBIndexZYYP).ProcessInput(parStr,drugId)
	.s Prop =##class(web.DHCCKBDrugVO).GetSpecificationProp(drugId)    //规格
	.s AproNum=##class(web.DHCCKBDrugVO).GetAproNum(drugId)
	.s contrastFlag = 0  //是否对照
	.s HospUsed=""
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(drugId,userInfo)
	.s:contrastFlag=1 HospUsed="本院在用"
	.Q:QuitFlag'=1
	.s tmp=drugId_"^"_desc_"^"_incSpec_"^"_incPackage_"^"_incManf_"^"_Indication_"^"_Contraindication_"^"_Ingredient_"^"_GenerName_"^"_FormType_"^"_Manufacturer_"^"_Prop_"^"_HospUsed_"^"_AproNum
	.s count=count+1
	.s total=total+1
	.q:total<start
	.q:total>end
	.w $case(total,start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(TitleStr,tmp)
	
	q ""
}

/// Descript：	   取药品的属性
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// w ##class(web.DHCCKBIndexZYYP).QueryDrugAttr()
ClassMethod QueryDrugAttr()
{
	s DrugAttrId=##class(web.DHCCKBCommon).GetDrugProp()
	s count=0
	w "["
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugAttrId,Id))  Q:Id=""  d
	.Q:+Id=0
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Id)),3)			//描述
	.s Temstr=Id_"^"_Desc
	.s count=count+1
	.i count=1  d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Temstr)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Temstr)
	w "]"
	Q ""
}

/// Descript：	   取下拉框个属性数据
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// Input:	       属性ID
/// w ##class(web.DHCCKBIndexZYYP).QueryAttrData(38)
ClassMethod QueryAttrData(Parref, q = "")
{
	q:Parref=0 ""
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	s link=+$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Parref,DataSource,""))
	q:link=0 ""
	s Parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	q:Parref=0 ""
	s count=0
	k DataArry
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,id)) q:(id="")  d
	.s DataArry(id)=id
	.s count=count+1
	.Q:(q="")&&(count>1000)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(id,.DataArry,count,q)
    
    s Jsonobj=##class(web.DHCCKBJsonObject).%New() //代替16语法空对象 lp
	w "["
	s num=0
	s index="" f  s index=$o(DataArry(index)) q:(index="")  d
	.q:+index=0
	.;q:##class(web.DHCCKBCommon).GetStopDicData(index,%session.Get("LOGON.HOSPID"),%session.Get("LOGON.GROUPID"),%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.USERID"))=1
	.d Jsonobj.Put("value",index)
    .d Jsonobj.Put("text",$lg($g(^CT.CKB.PDSS.CommonDictionD(index)),3))
   	.s num=num+1
	.w $case(num,1:"",:",")
    .w Jsonobj.JsonNoOp()
    w "]"
    q ""
}

/// Descript：	   递归取下级元素
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// Input:	       
/// w ##class(web.DHCCKBIndexZYYP).QueryAttrData(38)
ClassMethod QuerySubItm(Parref, DataArry, count, input)
{
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
    .;q:##class(web.DHCCKBCommon).GetStopDicData(SubId,%session.Get("LOGON.HOSPID"),%session.Get("LOGON.GROUPID"),%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.USERID"))=1
   	.s DataArry(SubId)=SubId
   	.s count=count+1
   	.Q:(input="")&&(count>1000)
   	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,.DataArry)
}

/// Descript：	   组织入参
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// Input:	   
/// w ##class(web.DHCCKBIndexZYYP).ProcessInput("106661$106664$","105595")
ClassMethod ProcessInput(Input, Id)
{
		n (Input,Id)
		Q:Input="" 1
		s ret=""
		Q:Input="" ret
		s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(Id)   	//成分
		s Len=$l(Input,"^")
		s LastRelation=""
		for i=1:1:Len  d
		.s Tempstr=$p(Input,"^",i)
		.s Leftvalue=$p(Tempstr,"$",1)																															//属性
		.s Rightvalue=$p(Tempstr,"$",2)																														//属性值
		.s Relation=$p(Tempstr,"$",3)																															 //关系
		.i LastRelation'="" s MiddRelation=LastRelation
		.e  s MiddRelation=Relation
		.Q:Leftvalue=""
		.s LastRelation=Relation
		.q:(MiddRelation="and")&&(ret=0)
		.q:(MiddRelation="or")&&(ret=1)
		.s Flag=0,value=""
		.s value = ##class(web.DHCCKBDrugVO).GetDicValueByPro(Id,Leftvalue)
		.s LeftCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(Leftvalue)),2)
		.s RightDesc=""
		.s:Rightvalue'="" RightDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Rightvalue)),3)
		.Q:value="" 
		.s op="["
		.s xcode=" s Flag="""_value_""""_op_""""_RightDesc_""""
		.x xcode
		.s:Flag=0 ret=0
		.s:Flag=1 ret=1
		Q ret
}

/// Descript：	   取新编药物学分类
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// Input:
/// w ##class(web.DHCCKBIndexZYYP).getDrugCatId()
ClassMethod getDrugCatId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("NewDrugCat")		//为了获取所有药品，就先写死了
}

/// Descript：	   组织入参
/// Creator：      sufan
/// CreatDate：    2020-03-14
/// Input:	   
/// w ##class(web.DHCCKBIndexZYYP).ProcessInputNew("106661$106664$","2848")
ClassMethod ProcessInputNew(Input, Id)
{
	n (Input,Id)
	Q:Input="" 1
	s ret=""
	Q:Input="" ret
	s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(Id)   	//成分
	s Len=$l(Input,"^")
	s LastRelation=""
	for i=1:1:Len  d
	.s Tempstr=$p(Input,"^",i)
	.s Leftvalue=$p(Tempstr,"$",1)																															//属性
	.s Rightvalue=$p(Tempstr,"$",2)																														//属性值
	.s Relation=$p(Tempstr,"$",3)																															 //关系
	.i LastRelation'="" s MiddRelation=LastRelation
	.e  s MiddRelation=Relation
	.Q:Leftvalue=""
	.s LastRelation=Relation
	.q:(MiddRelation="and")&&(ret=0)
	.q:(MiddRelation="or")&&(ret=1)
	.s Flag=0,value=""
	.s value = ##class(web.DHCCKBDrugVO).GetDicValueByPro(Id,Leftvalue)
	.s LeftCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(Leftvalue)),2)
	.s RightDesc=""
	.s:Rightvalue'="" RightDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(Rightvalue)),3)
	.Q:value="" 
	.s op="["
	.s xcode=" s Flag="""_value_""""_op_""""_RightDesc_""""
	.x xcode
	.s:Flag=0 ret=0
	.s:Flag=1 ret=1
	Q ret
}

/// Descript：	   通过对照表 code desc ,确定唯一的实体
/// Creator：      yuliping
/// CreatDate：    2021-05-27
/// Input:	   
/// w ##class(web.DHCCKBIndexZYYP).getCommonDiction("020801yslbqzsy","盐酸氯丙嗪注射液25mg(上海禾丰制药有限公司)",105)
ClassMethod getCommonDiction(libCode, libDesc, DicType)
{
	
	n (libCode,libDesc,DicType)
	s DicID="",rtn=""
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode))) ""
	f  s DicID = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode),DicID)) q:DicID=""  d
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),3)
	.s dicType = $lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),4)
	.q:dicDesc'=libDesc   //描述
	.q:dicType'=DicType   //字典类型
	.s rtn = DicID
	q rtn
}

/// Description:	查询对照字典 通用名(带剂型)
/// Creator:		yuliping
/// CreateDate:		2021-06-15
/// Input:			id,q
/// return:			对照字典列表
/// other:			w ##class(web.DHCCKBIndexZYYP).QueryContrastComgridNew("阿莫","")
ClassMethod QueryContrastComgridNew(input As %String = "", drugType = "") As %String
{
	n (input,drugType)
	
	s colorInput = "<span style='color:#018EE8'>"_input_"</span>"
	s ainput = input
	s input=$zcvt(input,"U")
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	q:$l(input)<2 "[]"
	/*s DrugData = ##class(web.DHCCKBCommon).GetGeneralFromData()  //西药 中成药 取通用名带剂型
	i ##class(web.DHCCKBCommon).CheckDrugType(drugType,$lg($g(^CT.CKB.PDSS.CommonDictionD(+DrugData)),3))'=1 d
  	.i +DrugData'=0 d GetContrastInfoNew
  	*/
   	s DrugData=##class(web.DHCCKBCommon).PrescriptionCopeData()   ///中药饮片 取药品处方
  	i ##class(web.DHCCKBCommon).CheckDrugType(drugType,$lg($g(^CT.CKB.PDSS.CommonDictionD(+DrugData)),3))'=1 d
  	.i +DrugData'=0 d GetContrastInfoNew
	
	s DrugData=##class(web.DHCCKBCommon).GetChinaMedPrescData()		///中药方剂
  	i +DrugData'=0 d GetContrastInfoNew	

	q:h=0 "[]"
	w "["
	s count=0	
	s listTitle="value^text"
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,index))
	.s count=count+1
	.i count=1 D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w "]"	
	k ^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid)
	q ""
	
GetContrastInfoNew
	s ccID="" 
	f  s ccID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,ccID)) q:ccID=""  d
	.s libDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ccID)),3)
	.s:input'="" input=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(input))
	.s libDescUp=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(libDesc))
	.q:(input'="")&(libDescUp'[input)
	.s libDesc = $replace(libDesc,ainput,colorInput)
	.s data=ccID_"^"_libDesc
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBIndexZYYP","QueryContrastComgrid",pid,h)=data
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 查询药品  
/// d ##class(web.DHCCKBIndexZYYP).List()
/// Input:
///       queryType:
///                1:药品名称
///                2:适应症
///                3:禁忌症 
///                4:拼音   
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","1","注射用阿莫西林钠氟氯西林钠","","","2")   //kml 2020-03-26 add 'userInfo'
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","1","柴胡桂枝汤","","","2","","")
/// w ##class(web.DHCCKBIndexZYYP).List("1","3","5","20%甘露醇注射液","","","2","阿托伐他汀钙片")
/// w ##class(web.DHCCKBIndexZYYP).List("1","15","","","148","74532$78391$and","94","","","","")
ClassMethod List(page = 1, rows = 10, queryType = "", queryPar = "", queryCat = "", parStr = "", userInfo = "", drugOther = "", version = "", drugType = "", promptStr = "")
{
  n (page,rows,queryType,queryPar,queryCat,parStr,userInfo,drugOther,version,drugType,%session,promptStr)
  s ^temptest("33333")=$lb(page,rows,queryType,queryPar,queryCat,parStr,userInfo,drugOther,version,drugType,promptStr)
  i (queryType=2)||(queryType=3)  d ##class(web.DHCCKBComQuery).listDrug(page,rows,queryType,queryPar,userInfo)
  q:(queryType=2)||(queryType=3) ""
  s start=(page-1)*rows+1
  s end=page*rows
  
  s manfName=""  		 //厂家名称
  i queryType=1 d  
  .i $l(queryPar)>3 d   //检索内容长度大于等于4 才有可能带厂家名称
  ..s manfName = $e(queryPar,*-1,*)
  ..s manfFlag = ..getManufacturerData(manfName)   //是否属于生产企业字典
  ..i manfFlag=1 d
  ...s queryPar = $p(queryPar,manfName,1)      //如果属于厂家名称，药品名称去掉厂家
  ..e  s manfName=""

  i queryCat'="" d ..QueryDurgListByCat(queryCat,start,end,parStr,userInfo,version)  //kml 2020-03-26 add 'userInfo'
  q:queryCat'="" ""
  
  i (queryPar'="")&&(drugOther'="") d ..CheckDrugListNew(queryPar,drugOther,queryType)
  q:(queryPar'="")&&(drugOther'="") ""
  
  s TitleStr="id^incDesc^incSpec^incPackage^incManf^Indication^Contraindication^Ingredient^GenerName^HospUsed^indication^releaseDate^origin^url^shortDesc"
  s pid=##class(web.DHCCKBCommonUtil).NewPid()
  k DrugDataArr(pid)
  s count=0 
  i queryType=9  d
  .s DrugData=##class(web.DHCCKBCommon).GetLiterSupDataData()    //文献 2021-6-19  shy
  .d GetDrugBookInfoData 
  e  d
  .s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  .i ##class(web.DHCCKBCommon).CheckDrugType(drugType,$lg($g(^CT.CKB.PDSS.CommonDictionD(+DrugData)),3))'=1 d GetDrugInfoNews
  .s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  .i ##class(web.DHCCKBCommon).CheckDrugType(drugType,$lg($g(^CT.CKB.PDSS.CommonDictionD(+DrugData)),3))'=1 d GetDrugInfoNews
  .s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  .d GetDrugInfoChinese
  .s DrugData=##class(web.DHCCKBCommon).GetChinaMedPrescData() //中药经方 qnp 2021-05-19
  .d GetDrugInfoChinaMedPrescData

  w "{""rows"":["
  s consFlag = 0
  s num = 0
  s consFlag = ""
  f  s consFlag=$o(DrugDataArr(pid,consFlag),-1) q:consFlag=""  d
  .s chkTimes = ""
  .f  s chkTimes = $o(DrugDataArr(pid,consFlag,chkTimes),-1) q:chkTimes=""  d
  ..s dicId = ""
  ..f  s dicId = $o(DrugDataArr(pid,consFlag,chkTimes,dicId)) q:dicId=""  d
  ...s tmp=DrugDataArr(pid,consFlag,chkTimes,dicId)
  ...s num=num+1
  ...q:num<start
  ...q:num>end
  ...w $case(num,start:"",:",")
  ...w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)

  w "],""total"":"_count_"}"
  q ""
  
GetDrugInfoNews
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.q:(version'="Dev")&&('..LimitByContrast(desc, DrugData,userInfo))	// qnp 2021/5/19 增加版本控制，Dev可不过滤对照
	.s GenerFromName = ##class(web.DHCCKBDrugVO).GetGenerFromName(id) //通用名带剂型
	.q:(queryType=1)&&(GenerFromName'[queryPar)            //通用名带剂型
	.q:(queryType=8)&&(##class(web.DHCCKBIndexZYYP).GetRuleInfoMessage(queryPar,id,promptStr)'=1)  //xww 2021-08-11
	.s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	.s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
	.s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面
	.i Indication=""  d
	..s Indication=##class(web.DHCCKBDrugVO).GetFunIndicat(id)	//取功能主治 sufan 2020-07-09 
	.i Contraindication=""  d
	..s Contraindication=##class(web.DHCCKBDrugVO).GetDrugContra(id)	//取禁忌	sufan 2020-07-09
	.q:(queryType=2)&&(Indication'[queryPar)                //适应症
	.q:(queryType=3)&&(Contraindication'[queryPar)          //禁忌症  
	.i queryType=2 d
	..s Indication=$replace(Indication,queryPar,"<font color='red'>"_queryPar_"</font>")
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	.s Prop =##class(web.DHCCKBDrugVO).GetSpecificationProp(id)    //规格
	.s facturer=##class(web.DHCCKBDrugVO).GetManufacturer(id)
	.s HospUsed=""
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(id,userInfo)
	.s:contrastFlag=1 HospUsed="本院在用"
	.q:(manfName'="")&&(facturer'[manfName)
	.i GenerFromName="" s GenerFromName=desc
	.i contrastFlag=1 s GenerFromName = GenerFromName_"<font color='red'>【本院在用】</font>"
	.s DrugDatas = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugData)),2)
	.s tmp=id_"^"_GenerFromName_"^"_GenerName_"^"_ProName_"^"_Ingredient_"^"_Prop_"^"_Indication_"^"_facturer_"^"_DrugDatas_"^"_HospUsed_"^"_Contraindication
	.s count=count+1
	.s DrugDataArr(pid,contrastFlag,clickTimes,id)=tmp
	q ""
GetDrugInfoChinese
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.q:(queryType=1)&&(desc'[queryPar)            //名称描述  kml
	.q:(version'="Dev")&&('..LimitByContrast(desc, DrugData,userInfo))	// qnp 2021/5/19 增加版本控制，Dev可不过滤对照
	.q:(queryType=8)&&(##class(web.DHCCKBIndexZYYP).GetRuleInfoMessage(queryPar,id,promptStr)'=1)  //xww 2021-08-11
	.s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 //kml 适应症属性
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,Indic,1) //kml   sufan2020-05-11 新增参数用于区分是导航界面
	.s contr=##class(web.DHCCKBCommon).GetDrugContrNew() 				 //kml 禁忌症属性
	.s Contraindication=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,contr,1) //kml sufan2020-05-11 新增参数用于区分是导航界面
	.s Indication=##class(web.DHCCKBDrugVO).GetFunIndicatNew(id)	//取功能主治 sufan 2020-07-09 
	.q:(queryType=2)&&(Indication'[queryPar)                //适应症
	.q:(queryType=3)&&(Contraindication'[queryPar)          //禁忌症  
	.i queryType=2 d
	..s Indication=$replace(Indication,queryPar,"<font color='red'>"_queryPar_"</font>")
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(id,userInfo)
	.s HospUsed=""
	.s:contrastFlag=1 HospUsed="本院在用"
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s incManf="",incSpec="",incPackage=""
	.s Ingredient=##class(web.DHCCKBDrugVO).getLatinNameProp(id)   	//拉丁名
	.s GenerName=##class(web.DHCCKBDrugVO).GetHerbalMedName(id)			//饮片名称
	.s ProName=$lg(##class(web.DHCCKBCommon).GetPrescCopeData(id,0))   	//处方应付
	.s GenerFromName = ##class(web.DHCCKBDrugVO).GetGenerFromName(id) //通用名带剂型

	.s Prop =##class(web.DHCCKBDrugVO).GetEfficacyProp(id)    //功效
	.s facturer=##class(web.DHCCKBDrugVO).GetManufacturer(id)
	.q:(manfName'="")&&(facturer'[manfName)
	.i GenerFromName="" s GenerFromName=desc
	.i GenerName="" s GenerName=GenerFromName
	.i contrastFlag=1 s GenerFromName = GenerFromName_"<font color='red'>【本院在用】</font>"
	.s DrugDatas = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugData)),2)
	.s tmp=id_"^"_GenerFromName_"^"_GenerName_"^"_ProName_"^"_Ingredient_"^"_Prop_"^"_Indication_"^"_facturer_"^"_DrugDatas_"^"_HospUsed
	.s count=count+1
	.s DrugDataArr(pid,contrastFlag,clickTimes,id)=tmp
	q ""
GetDrugInfoChinaMedPrescData
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.q:(version'="Dev")&&('..LimitByContrast(desc, DrugData,userInfo))	// qnp 2021/5/19 增加版本控制，Dev可不过滤对照
	.q:(queryType=1)&&(desc'[queryPar)            //名称描述  kml
	.q:(queryType=8)&&(##class(web.DHCCKBIndexZYYP).GetRuleInfoMessage(queryPar,id,promptStr)'=1)  //xww 2021-08-11
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(id,userInfo)
	.s HospUsed=""
	.s:contrastFlag=1 HospUsed="本院在用"
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s Ingredient=##class(web.DHCCKBDrugVO).GetPrescTreatDisease(id)   	//主治病证
	.s ProName=##class(web.DHCCKBDrugVO).GetPrescContent(id)   //方剂组成
	.s GenerFromName=desc
	.s GenerName=""
	.i GenerName="" s GenerName=GenerFromName
	.i contrastFlag=1 s GenerFromName = GenerFromName_"<font color='red'>【本院在用】</font>"
	.s DrugDatas = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugData)),2)
	.s tmp=id_"^"_GenerFromName_"^"_GenerName_"^"_ProName_"^"_Ingredient_"^^^^"_DrugDatas_"^"_HospUsed
	.s count=count+1
	.s DrugDataArr(pid,contrastFlag,clickTimes,id)=tmp
	q ""
	
GetDrugBookInfoData
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.q:(queryType=9)&&(desc'[queryPar)            //名称描述  kml
	.s urlid=##class(web.DHCCKBCommon).GetUrlData() 				 //urlid
	.s url=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,urlid,1) // 链接
	.;q:(queryType=9)&&(Indication'[queryPar)                //适应症 
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(id,userInfo)
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s incManf="",incSpec="",incPackage="",Indication=""
	.s Ingredient="" ;##class(web.DHCCKBDrugVO).GetIngredient(id)   	//成分
	.s GenerName="" ;##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.s ProName="" ;##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	.s GenerFromName = "" ;##class(web.DHCCKBDrugVO).GetGenerFromName(id) //通用名带剂型   文献名称、出处、发布日期、简介
	.s Prop =""
	.s facturer=""
	.s HospUsed=""
	.s releaseDateid=##class(web.DHCCKBCommon).GetLiteDateData() 				
	.s releaseDate=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,releaseDateid,1) // 发布日期
	.s originid=##class(web.DHCCKBCommon).GetOriginData() 				
	.s origin=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,originid,1) //出处
	.s shortDescid=##class(web.DHCCKBCommon).GetLiteShortDescData()
	.s shortDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(id,shortDescid,1) // 简介
	.s:contrastFlag=1 HospUsed="本院在用"
	.;q:(manfName'="")&&(facturer'[manfName)
	.i GenerFromName="" s GenerFromName=desc
	.i contrastFlag=1 s GenerFromName = GenerFromName_"<font color='red'>【本院在用】</font>"
	.s DrugDatas = $lg($g(^CT.CKB.PDSS.CommonDictionD(DrugData)),2)
	.s tmp=id_"^"_GenerFromName_"^"_GenerName_"^"_ProName_"^"_Ingredient_"^"_Prop_"^"_Indication_"^"_facturer_"^"_DrugDatas_"^"_HospUsed_"^^"_releaseDate_"^"_origin_"^"_url_"^"_shortDesc
	.s count=count+1
	.s DrugDataArr(pid,contrastFlag,clickTimes,id)=tmp
	q ""
}

/// 判断文字是否属于生产企业
/// w ##class(web.DHCCKBIndexZYYP).getManufacturerData("射液")
ClassMethod getManufacturerData(input)
{
	n (input)
	s manfID = ##class(web.DHCCKBCommon).GetManufacturerData()
	s flag=0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",manfID,id)) q:(id="")||(flag=1)  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.q:id=105700  //肝素钠注射液 脏数据
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.i desc[input s flag =1 
	
	 q flag
}

/// d ##class(web.DHCCKBIndexZYYP).CheckDrugListNew("阿司匹林", "苯唑西林钠",5)
ClassMethod CheckDrugListNew(DrugOne, DrugOther, queryType)
{
	n (DrugOne,DrugOther,queryType)
	
	s DrugOneID="",DrugOtherID="",LibraryID=""
	s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
	s DrugDesc=DrugOne
  	d GetDrugIDNew
  	s DrugOneIDList=DrugID
	s DrugDesc=DrugOther
	d GetDrugIDNew
	s DrugOtherIDList=DrugID
	s LengthOne=$l(DrugOneIDList,"^")
	s LengthOther=$l(DrugOtherIDList,"^")
	i (DrugOneIDList="")||(DrugOtherIDList="")  d
	.w "{""rows"":[{""title"":"""_"不存在关联药品"""_"}],""total"":1}"
	q:(DrugOneIDList="")||(DrugOtherIDList="")
	i queryType=5  d
	.s Flag="{""rows"":[{""title"":"""_DrugOther_" 与 "_DrugOne_" 不存在相互作用"""_"}],""total"":1}"
	.s LibraryID=##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")
	.f i=1:1:LengthOne  d
	..s DrugOneID=$p(DrugOneIDList,"^",i)
	..f k=1:1:LengthOther  d
	...s DrugOtherID=$p(DrugOtherIDList,"^",k)
	...s Result=##class(web.DHCCKBPassNew).CheckPropInRule(DrugOneID,DrugOtherID,LibraryID,"")
	...q:Result["不存在"
	...s Flag=Result
	.w Flag
	i queryType=6  d
	.s LibraryID=##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")
	.w ##class(web.DHCCKBPassNew).CheckPropInRule(DrugOneID,DrugOtherID,LibraryID,"")
	
GetDrugIDNew
	s DrugID=""
	s AttrFindCode=74532 ;##class(web.DHCCKBCommon).GetGeneralFromData()
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:(id="")   d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.s GenalName=""
	.s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",id,DLARowID))  q:(DLARowID="")||(GenalName'="")  d
	..s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	..;b:AttrCode=78200
	..s:(AttrCode=78200) GenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID),4)))),3) //通用名带剂型
	.s:(DrugID'="")&&(GenalName=DrugDesc) DrugID=DrugID_"^"_id
	.s:(DrugID="")&&(GenalName=DrugDesc) DrugID=id
}

/// Descript：	   取药品目录字典
/// Creator：      xww
/// CreatDate：    2021-08-10
/// w ##class(web.DHCCKBIndexZYYP).QueryDrugLibaryData()
ClassMethod QueryDrugLibaryData()
{
	s DrugAttrId=##class(web.DHCCKBCommon).GetDicIdByCode("DrugLibaryData")
	s count=0
	w "["
	s Id=""
	for  s Id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugAttrId,Id))  Q:Id=""  d
	.Q:+Id=0
	.s Desc=$lg(^CT.CKB.PDSS.CommonDictionD(Id),3)			//描述
	.s Temstr=Id_"^"_Desc
	.s count=count+1
	.i count=1  d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Temstr)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Temstr)
	w "]"
	Q ""
}

/// Descript：	   判断药品目录里的提示信息
/// Creator：      xww
/// CreatDate：    2021-08-10
/// w ##class(web.DHCCKBIndexZYYP).GetRuleInfoMessage("本品开封后，应避光、避湿保存",119826,"75038$$开封$$>$$^75038$$开封1$$>$$")
/// w ##class(web.DHCCKBIndexZYYP).GetRuleInfoMessage("本品开封后，应避光、避湿保存",119826,"75038$$避光$$>=$$^74537$$过敏史$$>$$")
ClassMethod GetRuleInfoMessage(OutputMessage, dicID, promptStr)
{
 	
  	n (OutputMessage,dicID,promptStr)
  	s warnMessageID=##class(web.DHCCKBCommon).GetDicIdByCode("WarnMessage")  //提示信息ID
  	s isExistFlag=0
  	s:OutputMessage="" isExistFlag=1
  	s ruleDicID=""
	f   s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))  q:(ruleDicID="")||(isExistFlag=1)||(OutputMessage="")  d
	.s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),2)
	.s DicParrentID=$lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),4)
	.q:+rule=0
	.q:'$d(^CT.CKB.PDSS.RuleDataI("Rule",rule))
	.s ruleDataID=""
	.f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID)) q:(ruleDataID="")||(isExistFlag=1)  d
	..q:'$d(^CT.CKB.PDSS.RuleDataD(ruleDataID))
	..s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)
	..q:leftDic'=warnMessageID
	..s ruleID=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),2)      // 规则Id
	..s rightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),9)  // 提示信息
	..q:(OutputMessage'="")&&(rightValue'[OutputMessage)
	..s isExistFlag=1

	q:isExistFlag'=1 "0"	
	
	s ret=1
	f i=1:1:$l(promptStr,"^") d
	.s dicStr=$p(promptStr,"^",i)
	.//列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
	.s column=$p(dicStr,"$$",1)
	.s columnValue=$p(dicStr,"$$",2)
	.s columnOp=$p(dicStr,"$$",3)
	.s columnCondition=$p(dicStr,"$$",4)
	.s:columnOp="" columnOp=">="
	.s:columnCondition="" columnCondition="and"
	.q:(column="")
	.q:(columnCondition="and")&&(ret=0)
	.s:i=1 ret=0
	.q:(columnCondition="or")&&(ret=1)
	.s Flag=0
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))  q:(ruleDicID="")||(Flag=1)  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),2)
	..q:+rule=0
	
	..s DicParrentID=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,column,""))
	..s:DicParrentID="" DicParrentID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,column,""))
	..q:(DicParrentID="")
	..q:'$d(^CT.CKB.PDSS.RuleDataI("Rule",rule))
	..s ruleDataID=""
	..f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID)) q:(ruleDataID="")||(Flag=1)  d
	...q:'$d(^CT.CKB.PDSS.RuleDataD(ruleDataID))
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)
	...q:leftDic'=warnMessageID
	...s ruleID=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),2)      // 规则Id
	...s value=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),9)  // 提示信息 
	...s value = ##Class(ext.util.String).Replace(value,"""", "")
	...s columnOp=$S(columnOp="=":"=",columnOp=">":"[",columnOp=">=":"[",columnOp="<=":"]",columnOp="<":"]",1:"")
	...s xcode=" s Flag="_""""_value_""""_columnOp_""""_columnValue_""""
	...x xcode
	
	
	.s:Flag=0 ret=0
	.s:Flag=1 ret=1
	
	
	q ret
}

}
