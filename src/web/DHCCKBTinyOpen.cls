Class web.DHCCKBTinyOpen Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:： 输出时间轴html
/// w ##class(web.DHCCKBTinyOpen).HTMLBODY()
ClassMethod HTMLBODY()
{
	w "<textarea id = 'tinydemo2'>"
	w "<div class='tagdisable' >"
	w "<input type='text' style='border: 0pt; font-size: 18px;color:#5BA3FD;font-family: PingFangSC-Semibold, PingFang SC;font-weight: 600;' value='信息栏'  readonly>"
	w "</div>"
	w "<div class='rowtwo rowtwo_bottom' >"
	
	s tinyId=+$g(%request.Data("ID",1))
	s dicParref=+$g(%request.Data("dicParref",1))
	//s ^Tmpliii=tinyId_"^"_dicParref
	
	s par= dicParref_"^"_tinyId_"^"_""
	//s par= 0_"^"_150_"^"_""
	//i $d(^DHCCKBTINY(0,"Parref",tinyId))=0  d
	//.s arr = ##class(web.TinySave).GetDefaultData(1)
	//e  d
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	f k=0:1:1 d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s id = obj.attrID
	.s type = obj.dataType
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.s defaultvalue = obj.AttrValue
	.s value = obj.AttrHtml
	.i value = "" d
	..s value = obj.AttrValue
	.i type = "combobox" d
	..d ##class(web.DHCCKBTinyOpen).getComboXX(id, code, desc, type, value, defaultvalue)
    .else  if type = "datagrid"  d
	..d ##class(web.DHCCKBTinyOpen).getDatagridXX(id, code, desc, type, value, defaultvalue)
    .e  d
    ..w "<div class='item-1' >"
	..w "<div class='disable' >"
	..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
	..w "</div>"
	..w "</div>"
	..w "<div class='item-2' >"
	..w "<div id='"_code_"' data-type='"_type_"'  >"
	..w "<p>"_value_"</p>"
	..w "</div>"
	..w "</div>"
	..w "<div  class='item-3' >"
	..w "<div class='add' id="_code_"btn ></div>"
	..w "</div>"
	w "</div>"
	
	
	w "<div class='line' >"
	w "</div>"
	w "<div class='tagdisable' >"
	w "<input type='text'  style='border: 0pt; font-size: 18px;color:#5BA3FD;font-family: PingFangSC-Semibold, PingFang SC;font-weight: 600;' value='正文' readonly>"
	w "</div>"
	f k=2:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s id = obj.attrID
	.s type = obj.dataType
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.s defaultvalue = obj.AttrValue
	.s value = obj.AttrHtml
	.i value = "" d
	..s value = obj.AttrValue
	.i type = "combobox"  d
	..d ##class(web.DHCCKBTinyOpen).getComboZW(id, code, desc, type, value, defaultvalue)
	.else  if type = "datagrid"  d
	..d ##class(web.DHCCKBTinyOpen).getDatagridZW(id, code, desc, type, value, defaultvalue)
	.e  d
	..w "<div class='row' >"
    ..w "<div class='item-val-2' >"
    ..w "<div class='rect' ></div>"
    ..w "<div class='disable' >"
    ..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
    ..w "</div>"
    ..w "</div>"
    ..w "<div id='"_code_"' data-type='"_type_"'  class='item-val-25'>"
    ..w "<p>"_value_"</p>"
    ..w "</div>"
    .w "</div>"
	w "</textarea>"
}

/// Author:        Shy
/// Description:： 输出时间轴html
/// Date:          2022-09-07
/// w ##class(web.DHCCKBTinyOpen).HTMLBODYNEW()
ClassMethod HTMLBODYNEW()
{
	w "<textarea id = 'tinydemo2'>"
	w "<div class='tagdisable'>"
	w "<input type='text' style='border: 0pt; font-size: 18px;color:#5BA3FD;font-family: PingFangSC-Semibold, PingFang SC;font-weight: 600;' value='信息栏'  readonly>"
	w "</div>"
	w "<div class='rowtwo rowtwo_bottom' >"
	
	s tinyId=+$g(%request.Data("ID",1))
	s dicParref=+$g(%request.Data("dicParref",1))
	s par= dicParref_"^"_tinyId_"^"_""
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	;s infoList="通用名^商品名^剂型^英文名称^规格"
	
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s id = obj.attrID
	.s type = obj.dataType
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.s dicid = obj.attrID
	.q:..getInstruTitlePropStatus(dicid)'="Y"
	.;q:infoList'[desc
	.s defaultvalue = obj.AttrValue
	.s value = obj.AttrHtml
	.i value = "" d
	..s value = obj.AttrValue
	.i type = "combobox" d
	..d ##class(web.DHCCKBTinyOpen).getComboXX(id, code, desc, type, value, defaultvalue)
    .else  if type = "datagrid"  d
	..d ##class(web.DHCCKBTinyOpen).getDatagridXX(id, code, desc, type, value, defaultvalue)
    .e  d
    ..w "<div class='xxrow' >"
    ..w "<div class='item-1' >"
	..w "<div class='disable' >"
	..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
	..w "</div>"
	..w "</div>"
	..w "<div class='item-2' >"
	..w "<div id='"_code_"' data-type='"_type_"' contenteditable='true' >"
	..w "<p>"_value_"</p>"
	..w "</div>"
	..w "</div>"
	..;w "<div  class='item-3' >"
	..;w "<div class='add' id="_code_"btn ></div>"
	..;w "</div>"
	..w "</div>"
	w "</div>"
	
	w "<div class='line' >"
	w "</div>"
	w "<div class='tagdisablezw' >"
	w "<input type='text'  style='border: 0pt; font-size: 18px;color:#5BA3FD;font-family: PingFangSC-Semibold, PingFang SC;font-weight: 600;' value='正文' readonly>"
	w "</div>"

	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s id = obj.attrID
	.s type = obj.dataType
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.s dicid = obj.attrID
	.q:..getInstruTitlePropStatus(dicid)="Y"    //过滤信息栏已展示属性
	.q:..getInstruPropStatus(dicid)'="Y"        
	.;q:infoList[desc
	.s defaultvalue = obj.AttrValue
	.s value = obj.AttrHtml
	.i value = "" d
	..s value = obj.AttrValue
	.i type = "combobox"  d
	..d ##class(web.DHCCKBTinyOpen).getComboZW(id, code, desc, type, value, defaultvalue)
	.else  if type = "datagrid"  d
	..d ##class(web.DHCCKBTinyOpen).getDatagridZW(id, code, desc, type, value, defaultvalue)
	.e  d
	..w "<div class='row'>"
    ..w "<div class='item-val-2' >"
    ..w "<div class='rect' ></div>"
    ..w "<div class='disable' >"
    ..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
    ..w "</div>"
    ..w "</div>"
    ..w "<div id='"_code_"' data-type='"_type_"'  class='item-val-25'>"
    ..s value=$replace(value,"\n","<br>")
    ..w "<div style='min-height:31px;margin-top:15px;' contenteditable='true'><p>"_value_"</p></div>"   ;"<p>"_value_"</p>"   
    ..w "</div>"
    ..i desc="药学分类"  d
	...w "<div  class='item-3' style='margin-top:15px;padding-left:12px;'>"
	...w "<div  id='DrugCategoryBtn'>"
	...w "<div class='add' id="_code_"btn ></div>"
	...w "</div>"
	...w "</div>"
    .w "</div>"
	w "</textarea>"
}

/// Description:： 输出时间轴html
/// w ##class(web.DHCCKBTinyOpen).HTMLCAT()
ClassMethod HTMLCAT()
{
	w "<div class='catalog'>"
	
	w "<span class='catalog-title'>目录</span>"
	
	
	w "<ul>"
	s tinyId=+$g(%request.Data("ID",1))
	//s tinyId=3913
	s dicParref=+$g(%request.Data("dicParref",1))
	
	//s dicParref = 6
	s ^Tmpliii=tinyId_"^"_dicParref
	
	s par= dicParref_"^"_tinyId_"^"_""
	//i $d(^DHCCKBTINY(0,"Parref",tinyId))=0  d
	//.s arr = ##class(web.TinySave).GetDefaultData(1)
	//e  d
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	b ; //1
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.s dicid = obj.attrID
	.q:..getInstruPropStatus(dicid)'="Y"
	.//q:obj.AttrValue=""   //没有维护值不显示在目录列表中 shy 2022-8-31 
	.;s:desc="通用名" ^shy("test","44")=obj.AttrValue
	.w "<li> <div class='circle'></div><a herf='#' onclick='javascript:tinymce.activeEditor.dom.get(&#039" _  code  _  "&#039).scrollIntoView({behavior: &#039smooth&#039, block: &#039center&#039, inline: &#039nearest&#039});'>" _ desc _"</a></li>"
    w "</ul>"
    w "</div>"
}

/// w ##class(web.DHCCKBTinyOpen).CorrelateJson("{""total"":513,""success"":true}")
/// w ##class(web.DHCCKBTinyOpen).CorrelateJson("{""gUserId"":""6423"",""gLocId"":""6"",""gGroupId"":""277"",""gHospId"":""2"",""CardType"":"""",""RecLoc"":""6"",""Status"":""N"",""StartDate"":""2019-06-05"",""CardNo"":"""",""EndDate"":""2020-06-05"",""PatNo"":""""}")
ClassMethod CorrelateJson(params As %String) As %String
{
	// [{"a":"111","b":"222"},{"a":"11ss","b":"22ss"},{"a":"11dd","b":"22dd"}]
	//w ##class(web.DHCCKBDicLinkAttr).GetDataCombo("112","","")
	// {{},{}}
	/*
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(params)
	
	s sc=##class(Ens.Util.JSON).JSONStreamToObjectArray(stream,.arr,,)
	b ;arr
    f i=1:1:arr {
		s object=arr(i)
	    s AA=object.AA
    	;s AA=object.%Get("AA")
    	b ;AA
    }
    q 1*/
    
    //s params="[{""a"":""111"",""b"":""222""},{""a"":""11ss"",""b"":""22ss""},{""a"":""11dd"",""b"":""22dd""}]"
    ;s params="{""ExeLoc"":[""259"",""262""],""gUserId"":""6423"",""gLocId"":""6"",""gGroupId"":""277"",""gHospId"":""2"",""CardType"":"""",""RecLoc"":""6"",""Status"":""N"",""StartDate"":""2019-06-05"",""CardNo"":"""",""EndDate"":""2020-06-05"",""PatNo"":""""}"
	s object=##class(%Library.DynamicObject).%FromJSON(params)
	b ;0000
	s gUserId=object.gUserId   //取json对象字段
	s ExeLoc=object.ExeLoc     //取json科室数组
	s Size=ExeLoc.%Size()
	f i=0:1:(Size-1) {
		s ExeLocId=ExeLoc.%Get(i)   //循环取到每个科室id
		b ;00   
		}
	b ;end
}

/// 获取动态加载串
/// w ##class(web.DHCCKBEditProp).GetAttrListData("30","1","6^3913^","")
/// w ##class(web.DHCCKBTinyOpen).GetAttrList()
ClassMethod GetAttrList()
{
	w "<ul class='anchor-list'>"
	//s tinyId=+$g(%request.Data("ID",1))
	//s ^Tmpliii=tinyId
	s tinyId=125613
	s par= ""_"^"_tinyId_"^"_"" 
	s arr = ##class(web.DHCCKBTinyOpen).GetAttrListData("1000","1",par,"")
	s json = ##class(%Library.DynamicObject).%FromJSON(arr)
	s len = json.%Size()
	b ; //1
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s code = obj.attrCode
	.s desc = obj.attrDesc
	.w "<li>"
    .w "<a herf='#' onclick='javascript:tinymce.activeEditor.dom.get(&#039" _  code  _  "&#039).scrollIntoView({behavior: &#039smooth&#039, block: &#039center&#039, inline: &#039nearest&#039});'>" _ desc _"</a>"
    .w "</li>"
    
    w "</ul>"
}

/// Description:	获取实体的属性列表
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-10	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBTinyOpen).GetAttrListData("100","1","0^150^","")
ClassMethod GetAttrListData(rows, page, params, drugType = "") As %String
{
	n (rows, page, params,drugType)

	s end = page*rows
	s start=(page-1)*rows+1
	s dicID=$p(params,"^",1)		  	//实体ID
	s:dicID=0 dicID=""
	s EntyId=$p(params,"^",2)
	//+$g(%request.Data("ID",1))
	s property=$p(params,"^",3)
	if (drugType="Herbal")&(dicID="")  s dicID=##class(web.DHCCKBCommon).GetChineseHerbalMedicine()		// 默认显示药品字典数据
	if dicID=""  s dicID=##class(web.DHCCKBCommon).GetDrug()		// 默认显示药品字典数据
	i dicID="" 	q ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:dicID="" ""
	
	
				
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时globalD
    
    s linkPropID=##class(web.DHCCKBRangeCat).GetAttrLink(dicID,"LinkProp")  //##class(web.DHCCKBCommon).GetLinkProp()	// 属性关联id
   
    s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()		// 是否需要维护属性值
    s dataTypeID=##class(web.DHCCKBCommon).GetDataType()					// 数据展现类型
	Q:linkPropID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
   	s h=0,linkRowID="" 
	for  s linkRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,linkPropID,linkRowID)) Q:linkRowID=""  d
	.s attrparref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性集合
	.d ##class(web.DHCCKBDiction).SortAttrByOrd(attrparref,pid,0)			//sufan 2020-04-08 排序
	.s Index=""
	.f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))  q:Index=""  d
	..s attrID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))
	..s tmpAttrID=attrID
	..s attrLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	..i attrLinkDr'="" s tmpAttrID=attrLinkDr	// 没有属性值，属性值link其他属性 
	..// 判断是否需要维护属性值
	..s tmpLinkID="",AddValueId="",AddValueFlag=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID,""))
	..i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	..q:$g(AddValueFlag)="N"
	..//数据展现形式
	..s tmpLinkID=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID))  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID,""))
	..s dataTypeDr=""
	..i tmpLinkID'="" s dataTypeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s dataType=""
	..i dataTypeDr'="" s dataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataTypeDr)),2)	// 具体属性的数据类型
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),2)
	..q:(property'="")&&(property'=attrCode)
	..s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),3)
	..//取维护的属性值
	..//q:(attrID=3920) //||(attrID=3934) //$lb(3934,)
	..s AttrValue=..QueryAttrValue(EntyId,attrID)
	..s AttrValue = $Replace(AttrValue,$c(2),"")
	..//取带html格式的属性值
	..s AttrHtml = ..QueryAttrHtml(EntyId,attrID)
	..///取值结束
	..s h=h+1
	..s data=attrID_"^"_attrCode_"^"_attrDesc_"^"_dataType_"^"_AttrValue_"^"_AttrHtml
	..s ^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,h)=data

	i h=0 q ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S listTitle="attrID^attrCode^attrDesc^dataType^AttrValue^AttrHtml"
	//w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	//w "["
	s count=0,index="",a="",b=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..s a = ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..s b =b_ ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.s c = a_b
	//w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	//w "]"
	d ..killTmpGlobal(pid) //k掉临时global
	s d = "["_c_"]"
	//q "[" _""_c_""_"]"
	q d
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	

	k ^TMP("DHCCKB","web.DHCCKBEditProp","GetLinkAttrListData",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetAttrListData",pid)
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).QueryAttrValue(150,74527)
ClassMethod QueryAttrValue(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	s Ret=..GetAttrValue(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrValue(EntyId,LinkId)			//取本身
	Q Ret
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBTinyOpen).GetAttrValue(150,74527)
ClassMethod GetAttrValue(EntyId, AttrCodeId)
{
	s LinkFlag=##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")  //从单位
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId),-1)  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId),-1)  Q:AttrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	...s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:DicLinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3)
	
	....s:dicAttrCode=LinkFlag Desc="/"_Desc
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s GroupArr(GroupFlag)=GroupArr(GroupFlag)_"$$"_ListData  //添加分隔符，拆分多个文本框(下拉框)
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)	
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:LinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_","_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_","_data
	k GroupArr
	Q QuitList
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBTinyOpen).QueryAttrHtml(81646,74532)
ClassMethod QueryAttrHtml(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	s Ret=..GetAttrHtml(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrHtml(EntyId,LinkId)			//取本身
	Q Ret
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBTinyOpen).GetAttrHtml(81646,74532)
ClassMethod GetAttrHtml(EntyId, AttrCodeId)
{
	s LinkFlag=##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")  //从单位
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId),-1)  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId),-1)  Q:AttrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),7)
	...i dicRes = "" d
	....s dicRes = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	...s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),7)
	....i Desc = ""  d
	.....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:DicLinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3)
	
	....s:dicAttrCode=LinkFlag Desc="/"_Desc
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s GroupArr(GroupFlag)=GroupArr(GroupFlag)_ListData
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.s Flag = ""
	.s Res=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId)) Q:((AttrId="")||(Flag=1))  d
	
	
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	
	..i LinkAttrId = ""  d
	...s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),7)
	...i Res '="" d
	....s Flag=1
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:LinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_","_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_","_data
	k GroupArr
	Q QuitList
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 取数据源下的所有数据
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// w ##class(web.DHCCKBTinyOpen).GetDataCombo("105,81790","ComOriginDrug","")
ClassMethod GetDataCombo(DataSource, filed = "", q = "")
{
	n (DataSource,filed,q)
	s DataSource=+DataSource
	s ^temptest("333")=$lb(DataSource,filed,q)
	s q=$zcvt(q,"U")
	s count=0,a="",b=""
	//w "["
	s AttrID=""
	for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataSource,AttrID)) Q:AttrID=""  d
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	.s Alias=""
	.i q'="" d
	..s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(AttrID,q)
	.i Alias'="" s Desc=Desc_"("_Alias_")"
	.s QueDesc=$zcvt(Desc,"U")
	.s QueCode="" //##class(web.DHCCKBCommonUtil).GetPYCODE(Desc)	// qunianpeng 取拼音码导致前台查询慢,暂时注释 2020-04-28
	.s QueCode=QueDesc_QueCode
	.Q:(q'="")&&(QueCode'[q)
	.s tmp=AttrID_"^"_Desc_"^"_filed
	.s count = count+1
	.Q:(q="")&&(count>200)
	.i count=1 d
	..s a= ##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	.e  d
	..s b= b_","_##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	.s c = a_b
	i c="" d
	.s d=""
	e  d
	.s d = "["_c_"]"
	//w "]"
	Q d
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 取配置的datagrid列
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// w ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("","Ingredient")
ClassMethod GetColumnsByDicCode(AttrcodeId, DicCode)
{
	n (AttrcodeId,DicCode)
	//先判断属性关联，若未关联属性，取本身
	//取属性关联数据
	s ^temp("lidong")=$lb(AttrcodeId,DicCode)
	i AttrcodeId="" s AttrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode),""))
	Q:AttrcodeId="" ""
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()

	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId))  d
	.s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId,""))
	.s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	
	.s list= ##class(web.DHCCKBTinyOpen).QueryCloByLink(AttrId)
	e  d
	.s AttrId=AttrcodeId
	
	.s list= ##class(web.DHCCKBTinyOpen).QueryCloByDic(AttrId)
	Q list
}

/// 取属性关联的列数据
/// w ##class(web.DHCCKBTinyOpen).QueryCloByLink("22364")
ClassMethod QueryCloByLink(AttrId)
{
	n (AttrId)
	s count=1
	
	s tmpObj={}
	//初始化Id串
	d tmpObj.%Set("Code","Id") d tmpObj.%Set("Desc","Id") d tmpObj.%Set("hidden","true") d tmpObj.%Set("edtstr","") d tmpObj.%Set("datatype","") 
	s list =  tmpObj.%ToJSON()
	
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",AttrId,DicId))  Q:DicId=""  d
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),5)
	.s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	.s:(Desc="")&&(LinkId'="") Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.s hidden="false"
	.//取数据源
	.s Datasource=##class(web.DHCCKBRangeCat).GetAddAttrSource(DicId,"DataSource")
	.s Datatype=##class(web.DHCCKBRangeCat).GetAddAttrCode(DicId,"DataTypeProp")
	.s edtstr=..GeteditData(Datasource,Datatype)
	.s count=count+1
	.//w $case(count,1:",",:",")
	
	.i Datatype="combobox"  d
	..d tmpObj.%Set("Code",Code_"Id") 
	..d tmpObj.%Set("Desc",Code_"Id") 
	..d tmpObj.%Set("hidden","true") 
	..d tmpObj.%Set("edtstr","") 
	..d tmpObj.%Set("datatype","")
	..s a =  tmpObj.%ToJSON()
	..s list = list_","_a
	
	..//w ","
	..s count=count+1
	.s tmpObj.Code=Code
	.s tmpObj.Desc=Desc
	.s tmpObj.hidden="false"
	.s tmpObj.edtstr=edtstr
	.s tmpObj.datatype=Datatype
	.s b = tmpObj.%ToJSON()
	.s list = list_","_b
	
	///输出组表示
	//w ","
	s tmpObj.Code="dicGroupFlag"
	s tmpObj.Desc="dicGroupFlag"
	s tmpObj.hidden="false"
	s tmpObj.edtstr=""
	s tmpObj.datatype=""
	s c = tmpObj.%ToJSON()
	s list = list_","_c
	
	s count=count+1 
	s listdel = "["_list_"]"
	q listdel
}

/// 取本身列数据
/// w ##class(web.DHCCKBTinyOpen).QueryCloByDic("22364")
ClassMethod QueryCloByDic(AttrId)
{
	n (AttrId)
	
	s count=1
	s tmpObj={}
	//初始化Id串
	d tmpObj.%Set("Code","Id") d tmpObj.%Set("Desc","Id") d tmpObj.%Set("hidden","true") d tmpObj.%Set("edtstr","") d tmpObj.%Set("datatype","") 
	s list = tmpObj.%ToJSON()
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	s hidden="false"
	//取数据源
	
	s Datasource=##class(web.DHCCKBRangeCat).GetAddAttrSource(AttrId,"DataSource")
	s Datatype=##class(web.DHCCKBRangeCat).GetAddAttrCode(AttrId,"DataTypeProp")
	s:Datasource'="" Datatype="combobox"    //对于没有属性关联的,若维护了数据源，按照下拉框格式走
	s edtstr=..GeteditData(Datasource,Datatype)
	i (Datatype="combobox")  d
	.d tmpObj.%Set("Code",Code_"Id") 
	.d tmpObj.%Set("Desc",Code_"Id") 
	.d tmpObj.%Set("hidden","true") 
	.d tmpObj.%Set("edtstr","") 
	.d tmpObj.%Set("datatype","")
	.s a= tmpObj.%ToJSON()
	.s list = list_","_a
	.s count=count+1
	
	s tmpObj.Code=Code
	s tmpObj.Desc=Desc
	s tmpObj.hidden="false"
	s tmpObj.edtstr=edtstr
	s tmpObj.datatype=Datatype
	s b= tmpObj.%ToJSON()
	s list = list_","_b
	s count=count+1
	///输出组表示
	
	s tmpObj.Code="dicGroupFlag"
	s tmpObj.Desc="dicGroupFlag"
	s tmpObj.hidden="false"
	s tmpObj.edtstr=""
	s tmpObj.datatype=""
	s c= tmpObj.%ToJSON()
	s list = list_","_c
	s count=count+1
	s listdel = "["_list_"]"
	q listdel
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 每列的数据类型
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// w ##class(web.DHCCKBDicLinkAttr).GeteditData(7,"OtherName")
ClassMethod GeteditData(Datasource, Datatype)
{
	n (Datasource,Datatype)
	Q ""
	s str=""
	i Datasource'=""  d
	.s type=Datatype
	.s valueField="value"
	.s textField="text"
	.s editable="false"
	.s panelHeight="160"
	.s url="ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource="_Datasource
	.s str=type_"@"_valueField_"@"_textField_"@"_editable_"@"_panelHeight_"@"_url
	Q str
}

/// Description：获取各列的编辑格式
/// w ##class(web.DHCCKBTinyOpen).getEditors("Id&&IngredientCodeId&&IngredientCode&&IngredientMete&&IngredientUnitId&&IngredientUnit&&dicGroupFlag")
ClassMethod getEditors(FiledList)
{
	n (FiledList)
	s columns=[]
	s Len=$l(FiledList,"&&")
	for i=1:1:Len  d
	.s Filed=$p(FiledList,"&&",i)
	.s editors=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(Filed,"","DataTypeProp")
	.s column={}
	.s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",Filed)  
	.s column.source=source
	.s column.Filed=Filed
	.s:source'="" editors="combobox"   //这里指定数据源不为空的为下拉框格式，因为不走属性关联的，默认取本身，本身的格式和实际列的格式不一致
	.s column.editors=editors
	.d columns.%Push(column)
	s a= columns.%ToJSON()
	Q a
}

/// combo类型输出下拉框
/// w ##class(web.DHCCKBTinyOpen).getCombo("110581","SkinTestDrugProp","皮试药品","combobox","","Y")
ClassMethod getComboXX(id, code, desc, type, value, defaultvalue)
{
	n (id, code, desc, type ,value ,defaultvalue)
	;w "<div class='row' >"
	w "<div class='item-1' >"
	w "<div class='disable' >"
	w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
	w "</div>"
	w "</div>"
	w "<div class='item-2' >"
	w "<div style='margin-top: 36px;margin-left:-20px;' contenteditable='true'>"
	w "<select id='"_code_"' data-type='"_type_"'class='item-2'>"
	s DataSource = ##class(web.DHCCKBRangeCat).GetAddAttrSource(id,"DataSource","","")
	s combolist = ##class(web.DHCCKBTinyOpen).GetDataCombo(DataSource,"","")
	s combojson = ##class(%Library.DynamicObject).%FromJSON(combolist)
	s combolen = combojson.%Size()
	f l=0:1:(combolen-1) d
	.s comboparams = combojson.%Get(l).%ToJSON()
	.s comboobj = ##class(%Library.DynamicObject).%FromJSON(comboparams)
	.s combovalue = comboobj.value
	.s combotext = comboobj.text
	.i combotext = defaultvalue  d
	..w "<option value='"_combovalue_"' class='combo' selected = 'selected'>"_combotext_"</option>"
	.e  d
	..w "<option value='"_combovalue_"' class='combo' >"_combotext_"</option>"
	w "</select>"
	w "</div>"
	w "</div>"
	;w "</div>"
}

/// combo类型输出下拉框
/// w ##class(web.DHCCKBTinyOpen).getCombo("110581","SkinTestDrugProp","皮试药品","combobox","","Y")
ClassMethod getComboZW(id, code, desc, type, value, defaultvalue)
{
	n (id, code, desc, type ,value ,defaultvalue)
	w "<div class='row' >"
    w "<div class='item-val-2' >"
    w "<div class='rect' ></div>"
    w "<div class='disable' >"
    w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
    w "</div>"
    w "</div>"
	
	
	w "<select id='"_code_"' data-type='"_type_"'   class='comb-1'>"
	w " <option style='display: none'></option>"    //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	s DataSource = ##class(web.DHCCKBRangeCat).GetAddAttrSource(id,"DataSource","","")
	s combolist = ##class(web.DHCCKBTinyOpen).GetDataCombo(DataSource,"","")
	s combojson = ##class(%Library.DynamicObject).%FromJSON(combolist)
	s combolen = combojson.%Size()
	f l=0:1:(combolen-1) d
	.s comboparams = combojson.%Get(l).%ToJSON()
	.s comboobj = ##class(%Library.DynamicObject).%FromJSON(comboparams)
	.s combovalue = comboobj.value
	.s combotext = comboobj.text
	.i combotext = defaultvalue  d
	..w "<option value='"_combovalue_"' class='combo' selected = 'selected'>"_combotext_"</option>"
	.e  d
	..w "<option value='"_combovalue_"' class='combo' >"_combotext_"</option>"
	w "</select>"
	w "</div>"
}

/// datagrid获取下拉框
/// w ##class(web.DHCCKBTinyOpen).getDatagridXX("47","ExcipientProp","辅料","datagrid","","")
/// w ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("","ExcipientProp")
/// w ##class(web.DHCCKBTinyOpen).getEditors("ExcipientProp")
/// w ##class(web.DHCCKBTinyOpen).GetDataCombo("108","IngredientCode","")
ClassMethod getDatagridXX(id, code, desc, type, value, defaultvalue)
{
	n (id, code, desc, type ,value ,defaultvalue)
	s editorparam = "",desclist = ""
	s columnlist = ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("",code)
	s columnjson = ##class(%Library.DynamicObject).%FromJSON(columnlist)
	s columnlen = columnjson.%Size()
	f l=0:1:(columnlen-1) d
	.s columnparams = columnjson.%Get(l).%ToJSON()
	.s columnobj = ##class(%Library.DynamicObject).%FromJSON(columnparams)
	.s columnhidden = columnobj.hidden
	.i columnhidden="false"  d
	..s columncode = columnobj.Code
	..i columncode'="dicGroupFlag"  d
	...s columncode = columnobj.Code
	...s columndesc = columnobj.Desc
	...i editorparam="" d
	....s editorparam = columncode
	....s desclist = columndesc
	...e  d
	....s editorparam = editorparam_"&&"_columncode
	....s desclist = desclist_"&&"_columndesc
	
	
	s editorlist=##class(web.DHCCKBTinyOpen).getEditors(editorparam)
	s editorjson = ##class(%Library.DynamicObject).%FromJSON(editorlist)
	s editorlen = editorjson.%Size()
	f l=0:1:(editorlen-1) d
	.s editorparams = editorjson.%Get(l).%ToJSON()
	.s editorobj = ##class(%Library.DynamicObject).%FromJSON(editorparams)
	.s editorsource = editorobj.source
	.s editorFiled = editorobj.Filed
	.s editoreditors = editorobj.editors
	.s editordesc = $p(desclist,"&&",l+1)
	
	.i editorsource=""  d
	..w "<div class='item-1' >"
	..w "<div class='disable' >"
	..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	..w "</div>"
	..w "</div>"
	..w "<div class='item-2' >"
	..w "<div id='"_editorFiled_"' data-type='"_editoreditors_"' contenteditable='true'  >"
	..w "<p>"_value_"</p>"
	..w "</div>"
	..w "</div>"
	.e  d
	..w "<div class='item-1' >"
	..w "<div class='disable' >"
	..w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	..w "</div>"
	..w "</div>"
	..w "<div class='item-2'>"
	..w:(desc="通用名") "<div id='GenDiv'>"
	..w:(desc="商品名") "<div id='ProNamePropDiv'>"
	
	..s length=1
	..i (desc="通用名")||(desc="商品名") d
	...s length=$l(value,",")

	..f index=1:1:length  d
	...s defaultvalueItem=$p(defaultvalue,",",index)
	...w "<select id='"_editorFiled_"' data-type='"_editoreditors_"'   class='sel-grid-xx' contenteditable='true'>"
	...w " <option style='display: none'></option>"     //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	...s datagridlist =##class(web.DHCCKBTinyOpen).GetDataCombo(editorsource,editorFiled,"")
	...s datagridjson = ##class(%Library.DynamicObject).%FromJSON(datagridlist)
	...s datagridlen = datagridjson.%Size()
	...f m=0:1:(datagridlen-1) d
	....s datagridparams = datagridjson.%Get(m).%ToJSON()
	....s datagridobj = ##class(%Library.DynamicObject).%FromJSON(datagridparams)
	....s datagridvalue = datagridobj.value
	....s datagridtext = datagridobj.text
	....i datagridtext = defaultvalueItem  d
	.....w "<option value='"_datagridvalue_"' class='combo' selected = 'selected'>"_datagridtext_"</option>"
	....e  d
	.....w "<option value='"_datagridvalue_"' class='combo' >"_datagridtext_"</option>"
	...w "</select>"
	..w "</div>"
	..w:((desc="通用名")||(desc="商品名")) "</div>"
	
	..i (desc="通用名")  d
	...w "<div  class='item-3' >"
	...w "<div  id='GenBtns' >"
	...w "<div class='add' id="_code_"btn></div>"
	
	...f m=1:1:length  d
	....i m>1  d
	.....w "<div class='' id="_code_"minbtn style='margin-top:34px;'></div>"
	
	...w "</div>"
	...w "</div>"
	..i (desc="商品名")  d
	...w "<div  class='item-3' >"
	...w "<div  id='ProNamePropBtns'>"
	...w "<div class='add' id="_code_"btn ></div>"
	...w "</div>"
	...w "</div>"
}

/// datagrid获取下拉框
/// w ##class(web.DHCCKBTinyOpen).getDatagridZW("39","Ingredient","成分","datagrid","","")
/// w ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("","Ingredient")
/// w ##class(web.DHCCKBTinyOpen).getEditors("ID&&IngredientCode&&IngredientMete&&IngredientUnit")
/// w ##class(web.DHCCKBTinyOpen).GetDataCombo("108","IngredientCode","")
ClassMethod getDatagridZWO(id, code, desc, type, value, defaultvalue)
{
	n (id, code, desc, type ,value ,defaultvalue)
	w "<div class='row' id='"_code_"' data-type='"_type_"' >"
    w "<div class='item-val-2' >"
    w "<div class='rect' ></div>"
    w "<div class='disable' >"
    w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
    w "</div>"
    w "</div>"
	
	s editorparam = "",desclist = ""
	s columnlist = ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("",code)
	s columnjson = ##class(%Library.DynamicObject).%FromJSON(columnlist)
	s columnlen = columnjson.%Size()
	f l=0:1:(columnlen-1) d
	.s columnparams = columnjson.%Get(l).%ToJSON()
	.s columnobj = ##class(%Library.DynamicObject).%FromJSON(columnparams)
	.s columnhidden = columnobj.hidden
	.i columnhidden="false"  d
	..s columncode = columnobj.Code
	..i columncode'="dicGroupFlag"  d
	...s columncode = columnobj.Code
	...s columndesc = columnobj.Desc
	...i editorparam="" d
	....s editorparam = columncode
	....s desclist = columndesc
	...e  d
	....s editorparam = editorparam_"&&"_columncode
	....s desclist = desclist_"&&"_columndesc
	
	s editorlist=##class(web.DHCCKBTinyOpen).getEditors(editorparam)
	s editorjson = ##class(%Library.DynamicObject).%FromJSON(editorlist)
	s editorlen = editorjson.%Size()
	f l=0:1:(editorlen-1) d
	.s editorparams = editorjson.%Get(l).%ToJSON()
	.s editorobj = ##class(%Library.DynamicObject).%FromJSON(editorparams)
	.s editorsource = editorobj.source
	.s editorFiled = editorobj.Filed
	.s editoreditors = editorobj.editors
	.s editordesc = $p(desclist,"&&",l+1)
	.b ; //1
	
	.i editorlen = "1"  d
	..w "<select id='"_editorFiled_"det' data-type='"_editoreditors_"'   class='grid-5'>"
	..w " <option style='display: none'></option>"  //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	..s datagridlist =##class(web.DHCCKBTinyOpen).GetDataCombo(editorsource,editorFiled,"")
	..s datagridjson = ##class(%Library.DynamicObject).%FromJSON(datagridlist)
	..s datagridlen = datagridjson.%Size()
	..f m=0:1:(datagridlen-1) d
	...s datagridparams = datagridjson.%Get(m).%ToJSON()
	...s datagridobj = ##class(%Library.DynamicObject).%FromJSON(datagridparams)
	...s datagridvalue = datagridobj.value
	...s datagridtext = datagridobj.text
	
	...i datagridtext = defaultvalue  d
	....w "<option value='"_datagridvalue_"' class='combo' selected = 'selected'>"_datagridtext_"</option>"
	...e  d
	....w "<option value='"_datagridvalue_"' class='combo' >"_datagridtext_"</option>"
	..w "</select>"
	
	.e  d
	..i editorsource=""  d
	...w "<div class='grid-1' >"
	...w "<div class='disable' >"
	...w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	...w "</div>"
	...w "</div>"
	...w "<div class='grid-2' >"
	...w "<div id='"_editorFiled_"' data-type='"_editoreditors_"'  >"
	...w "<p>"_value_"</p>"
	...w "</div>"
	...w "</div>"
	
	..e  d
	
	...w "<div class='grid-3' >"
	...w "<div class='disable' >"
	...w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	...w "</div>"
	...w "</div>"
	...w "<select id='"_editorFiled_"' data-type='"_editoreditors_"'   class='grid-4'>"
	...w " <option style='display: none'></option>"    //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	...s datagridlist =##class(web.DHCCKBTinyOpen).GetDataCombo(editorsource,editorFiled,"")
	...s datagridjson = ##class(%Library.DynamicObject).%FromJSON(datagridlist)
	...s datagridlen = datagridjson.%Size()
	...f m=0:1:(datagridlen-1) d
	....s datagridparams = datagridjson.%Get(m).%ToJSON()
	....s datagridobj = ##class(%Library.DynamicObject).%FromJSON(datagridparams)
	....s datagridvalue = datagridobj.value
	....s datagridtext = datagridobj.text
	
	....i datagridtext = defaultvalue  d
	.....w "<option value='"_datagridvalue_"' class='combo' selected = 'selected'>"_datagridtext_"</option>"
	....e  d
	.....w "<option value='"_datagridvalue_"' class='combo' >"_datagridtext_"</option>"
	...w "</select>"
	w "</div>"
}

/// datagrid获取下拉框
/// w ##class(web.DHCCKBTinyOpen).getDatagridList("Ingredient")
/// w ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("","Ingredient")
ClassMethod getDatagridList(code)
{
	n (code)
	
    s editorparam = "",desclist = ""
	s columnlist = ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("",code)
	s columnjson = ##class(%Library.DynamicObject).%FromJSON(columnlist)
	s columnlen = columnjson.%Size()
	f l=0:1:(columnlen-1) d
	.s columnparams = columnjson.%Get(l).%ToJSON()
	.s columnobj = ##class(%Library.DynamicObject).%FromJSON(columnparams)
	.s columnhidden = columnobj.hidden
	.i columnhidden="false"  d
	..s columncode = columnobj.Code
	..i columncode'="dicGroupFlag"  d
	...s columncode = columnobj.Code
	...s columndesc = columnobj.Desc
	...i editorparam="" d
	....s editorparam = columncode
	...e  d
	....s editorparam = editorparam_"&&"_columncode
	q editorparam
}

/// datagrid获取下拉框
/// w ##class(web.DHCCKBTinyOpen).getDatagridZWO("39","Ingredient","成分","datagrid","g1氯唑西林钠,g22丙磺舒","g1氯唑西林钠,g22丙磺舒")
/// w ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("","Ingredient")
/// w ##class(web.DHCCKBTinyOpen).getEditors("ID&&IngredientCode&&IngredientMete&&IngredientUnit")
/// w ##class(web.DHCCKBTinyOpen).GetDataCombo("108","IngredientCode","")
ClassMethod getDatagridZW(id, code, desc, type, value, defaultvalue)
{
	n (id, code, desc, type ,value ,defaultvalue)
	w "<div class='row' id='"_code_"' data-type='"_type_"' >"
    w "<div class='item-val-2' >"
    w "<div class='rect' ></div>"
    w "<div class='disable' >"
    w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ desc _"'  readonly>"
    w "</div>"
    w "</div>"
	
	
	s length=1
	i (desc="成分")||(desc="等效单位")  d
	.s length=$l(value,",")
	
	f index=1:1:length  d
	.s valueItem=$p(value,",",index)
	.s defaultvalueItem=$p(defaultvalue,",",index)
	.s defaultvalueItemOut=""
	.s editorparam = "",desclist = ""
	.s columnlist = ##class(web.DHCCKBTinyOpen).GetColumnsByDicCode("",code)
	.s columnjson = ##class(%Library.DynamicObject).%FromJSON(columnlist)
	.s columnlen = columnjson.%Size()
	.f l=0:1:(columnlen-1) d
	..s columnparams = columnjson.%Get(l).%ToJSON()
	..s columnobj = ##class(%Library.DynamicObject).%FromJSON(columnparams)
	..s columnhidden = columnobj.hidden
	..i columnhidden="false"  d
	...s columncode = columnobj.Code
	...i columncode'="dicGroupFlag"  d
	....s columncode = columnobj.Code
	....s columndesc = columnobj.Desc
	....i editorparam="" d
	.....s editorparam = columncode
	.....s desclist = columndesc
	....e  d
	.....s editorparam = editorparam_"&&"_columncode
	.....s desclist = desclist_"&&"_columndesc
	.s editorlist=##class(web.DHCCKBTinyOpen).getEditors(editorparam)
	.s editorjson = ##class(%Library.DynamicObject).%FromJSON(editorlist)
	.s editorlen = editorjson.%Size()
	
	.i index>1  d
	..w "<div style='width:190px;float:left;'></div>"
	
	.f l=0:1:(editorlen-1) d
	..s editorparams = editorjson.%Get(l).%ToJSON()
	..s editorobj = ##class(%Library.DynamicObject).%FromJSON(editorparams)
	..s editorsource = editorobj.source
	..s editorFiled = editorobj.Filed
	..s editoreditors = editorobj.editors
	..s editordesc = $p(desclist,"&&",l+1)
	..b ; //1
	..i editorlen = "1"  d
	...w "<select id='"_editorFiled_"det' data-type='"_editoreditors_"'   class='grid-5' contenteditable='true'>"
	...w " <option style='display: none'></option>"  //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	...s datagridlist =##class(web.DHCCKBTinyOpen).GetDataCombo(editorsource,editorFiled,"")
	...s datagridjson = ##class(%Library.DynamicObject).%FromJSON(datagridlist)
	...s datagridlen = datagridjson.%Size()
	...f m=0:1:(datagridlen-1) d
	....s datagridparams = datagridjson.%Get(m).%ToJSON()
	....s datagridobj = ##class(%Library.DynamicObject).%FromJSON(datagridparams)
	....s datagridvalue = datagridobj.value
	....s datagridtext = datagridobj.text
	....i datagridtext = defaultvalueItem  d
	.....w "<option value='"_datagridvalue_"' class='combo' selected = 'selected'>"_datagridtext_"</option>"
	....e  d
	.....w "<option value='"_datagridvalue_"' class='combo' >"_datagridtext_"</option>"
	...w "</select>"
	..e  d
	...b ;2
	...i editorsource=""  d
	....w "<div class='grid-1' >"
	....w "<div class='disable' >"
	....w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	....w "</div>"
	....w "</div>"
	....w "<div class='grid-2' >"
	....w "<div id='"_editorFiled_"' data-type='"_editoreditors_"' contenteditable='true'>"
	....//成分 等效单位做特殊处理
	....s:(desc="成分")&&(editordesc="成分剂量") valueItem=$p(defaultvalueItem,"$$",2)
	....s:(desc="等效单位")&&(editordesc="系数") valueItem=$p(defaultvalueItem,"$$",1)	
	....w "<p>"_valueItem_"</p>"
	....w "</div>"
	....w "</div>"
	...e  d
	....w "<div class='grid-3'>"
	....w "<div class='disable' >"
	....w "<input type='text'  style='border: 0pt; font-size: 15px; font-family: PingFangSC-Regular, PingFang SC;font-weight: 400;color: #333333;width: 100%;' value='"_ editordesc _"'  readonly>"
	....w "</div>"
	....w "</div>"
	....w "<select id='"_editorFiled_"' data-type='"_editoreditors_"'   class='grid-4'>"
	....w " <option style='display: none'></option>"    //添加一个空option 防止选中第一个加载的值 shy 2022-8-31
	....s datagridlist =##class(web.DHCCKBTinyOpen).GetDataCombo(editorsource,editorFiled,"")
	....s datagridjson = ##class(%Library.DynamicObject).%FromJSON(datagridlist)
	....s datagridlen = datagridjson.%Size()
	....b ;err
	....f m=0:1:(datagridlen-1) d
	.....s datagridparams = datagridjson.%Get(m).%ToJSON()
	.....s datagridobj = ##class(%Library.DynamicObject).%FromJSON(datagridparams)
	.....s datagridvalue = datagridobj.value
	.....s datagridtext = datagridobj.text
	.....b ;errerr
	.....//成分 等效单位特殊处理 shy 2022-09-07
	.....s:(desc="成分")&&(editordesc="成分代码") defaultvalueItemOut=$p(defaultvalueItem,"$$",3)
	.....s:(desc="成分")&&(editordesc="成分剂量") defaultvalueItemOut=$p(defaultvalueItem,"$$",2)
	.....s:(desc="成分")&&(editordesc="成分单位") defaultvalueItemOut=$p(defaultvalueItem,"$$",1)
	
	.....s:desc="等效单位" defaultvalueItem=$replace(defaultvalueItem,"/","")
	.....s:(desc="等效单位")&&(editordesc="从单位") defaultvalueItemOut=$p(defaultvalueItem,"$$",3)
	.....s:(desc="等效单位")&&(editordesc="到单位") defaultvalueItemOut=$p(defaultvalueItem,"$$",2)
	.....s:(desc="等效单位")&&(editordesc="系数") defaultvalueItemOut=$p(defaultvalueItem,"$$",1)
	
	.....i datagridtext = defaultvalueItemOut  d
	......w "<option value='"_datagridvalue_"' class='combo' selected = 'selected'>"_datagridtext_"</option>"
	.....e  d
	......w "<option value='"_datagridvalue_"' class='combo' >"_datagridtext_"</option>"
	....w "</select>"
	
	.i desc="成分"  d
	..w "<div  class='item-3' style='margin-top:15px;'>"
	..w "<div  id='IngredientBtn'>"
	..i index=1  d
	...w "<div class='add' id="_code_"btn ></div>"
	..w "</div>"
	..w "</div>"
	.i desc="等效单位"  d
	..w "<div  class='item-3' style='margin-top:15px;'>"
	..w "<div  id='EqUnitPropBtn'>"
	..i index=1  d
	...w "<div class='add' id="_code_"btn ></div>"
	..w "</div>"
	..w "</div>"
	.w "</div>"
	
	
	q ""
}

/// author:sunhuiyong
/// 2022-12-2
/// 属性的知识浏览属性是否为Y
/// w ##class(web.DHCCKBTinyOpen).getInstruPropStatus("43")
ClassMethod getInstruPropStatus(DicDr)
{
	n (DicDr)
	s InstruProp=##class(web.DHCCKBCommon).GetInstruProp()
	//^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",{DLA_Dic_Dr},{DLA_AttrCode},{DLA_RowID})
    q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,InstruProp)) "N"
    s DlaID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,InstruProp,""))
    s InstruPropStatus=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DlaID)),4)
    q:+InstruPropStatus=0 "N"
    s InstruPropStatus=$lg($g(^CT.CKB.PDSS.CommonDictionD(InstruPropStatus)),3)
    q InstruPropStatus
}

/// author:sunhuiyong
/// 2022-12-2
/// 属性的知识浏览信息栏属性是否为Y
/// w ##class(web.DHCCKBTinyOpen).getInstruTitlePropStatus("42")
ClassMethod getInstruTitlePropStatus(DicDr)
{
	n (DicDr)
	s InstruTitleProp=##class(web.DHCCKBCommon).GetInstruTitleProp()
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,InstruTitleProp)) "N"
    s DlaID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicDr,InstruTitleProp,""))
    s InstruTitlePropStatus=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DlaID)),4)
    q:+InstruTitlePropStatus=0 "N"
    s InstruTitlePropStatus=$lg($g(^CT.CKB.PDSS.CommonDictionD(InstruTitlePropStatus)),3)
    q InstruTitlePropStatus
}

}
