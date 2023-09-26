Import SQLUser

Class web.DHCCKBExtDictionary Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取外部代码表字典类型
/// Creator:		Shy
/// CreateDate:		2020-07-28	
/// Input:			代码^描述		
/// other:			w ##class(web.DHCCKBExtDictionary).GetExtDicList("30","1","2","","")
ClassMethod GetExtDicList(rows = 30, page = 1, HospID, params, drugType = "") As %String
{
	s queryCode = $p(params,"^",1)
	s queryDesc = $p(params,"^",2)
	s queryCode = $zcvt(queryCode,"U")
	s queryDesc = $zcvt(queryDesc,"U")
    s count=0
    s ListTitle="dicID^EDCode^EDDesc^EDType^EDHospID^EDRowID^DataType"
    w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s dicID = ""    
	f  s dicID = $o(^CKB.PDSS.ExtDictionD(dicID))  q:dicID=""  d
	.q:dicID=0
	.s extData = $g(^CKB.PDSS.ExtDictionD(dicID))
	.s EDCode = $lg(extData,2) 
	.//q:EDCode'["Data"
	.s EDDesc = $lg(extData,3)
	.q:(EDCode="")||(EDDesc="")
	.s parref = $lg(extData,6)
	.q:(parref'="")||((parref="")&&($lg(extData,4)="DiseaseData"))
	.q:1=##class(web.DHCCKBCommon).CheckDrugType(drugType,EDDesc) // 过滤药品类型 qnp 2021.06.24
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(EDDesc))
	.q:(queryCode'="")&($zcvt(EDCode,"U")'[queryCode)&(EDDesc'[queryCode)&(pinDicDesc'[$zcvt(queryCode,"U"))
	.s EDType = $lg(extData,4)
	.s EDHospID = $lg(extData,5)
	.s EDRowID = dicID
	.s dataTypeDr=##class(web.DHCCKBCommon).GetDataType()	// 数据显示格式(数据类型)
	.s dataTypeCode="",dataTypeLinkDr=""
	.s dataTypeLinkDr=$o(^CKB.PDSS.DicExtLinkAttrI("LinkDicAttrCode",dicID,dataTypeDr,""))
	.s dataType=""
	.i dataTypeLinkDr'="" s dataType=$lg(^CKB.PDSS.DicExtLinkAttrD(dataTypeLinkDr),4)
	.i dataType'="" s dataTypeCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataType)),2)
	.s ListData=dicID_"^"_EDCode_"^"_EDDesc_"^"_EDType_"^"_EDHospID_"^"_EDRowID_"^"_dataTypeCode
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Description:	获取外部代码表数据
/// Creator:		Shy
/// CreateDate:		2020-07-28	
/// Input:			代码^描述		
/// other:			d ##class(web.DHCCKBExtDictionary).GetExtDicListData(30,1,"","","")
ClassMethod GetExtDicListData(rows = 30, page = 1, HospID, Type = "", params) As %String
{
	s End = page*rows

	s Start=(page-1)*rows+1
	s queryCode = $p(params,"^",1)
	s queryDesc = $p(params,"^",2)
	s queryCode = $zcvt(queryCode,"U")
	s queryDesc = $zcvt(queryDesc,"U")
	q:Type="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
    s count=0
    s ListTitle="EDCode^EDDesc^EDType^EDHospID^EDRowID"
    w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s dicID = ""    
	f  s dicID = $o(^CKB.PDSS.ExtDictionD(dicID))  q:dicID=""  d
	.q:dicID=0
	.s ExtData = $g(^CKB.PDSS.ExtDictionD(dicID))
	.s EDCode = $lg(ExtData,2)
	.s EDDesc = $lg(ExtData,3)
	.s EDType = $lg(ExtData,4)
	.s EDRowID = dicID
	.q:Type'=EDType
	.q:EDCode=EDType   //区分字典名 Code与Type一致
	.s EDHospID = $lg(ExtData,5)
	.q:(HospID'="")&&(HospID'=EDHospID)
	.s HospDesc=$p($g(^CT("HOSP",+EDHospID)),"^",2)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(EDDesc))
	.q:(queryCode'="")&($zcvt(EDCode,"U")'[queryCode)&(EDDesc'[queryCode)&(pinDicDesc'[$zcvt(queryCode,"U"))
	.s ListData=EDCode_"^"_EDDesc_"^"_EDType_"^"_HospDesc_"^"_EDRowID
	.s count=count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Description:	插入外部代码表
/// Creator:		Shy
/// CreateDate:		2020-07-28		
/// other:			w ##class(web.DHCCKBExtDictionary).InsertExtDic("DrugFreqData","用药频率字典","DrugFreqData","2")
ClassMethod InsertExtDic(Code, Desc, Type, HospID) As %String
{
	s QuitFlag=0
    &SQL(Insert Into CKB_PDSS.ExtDiction(ED_Code,ED_Desc,ED_Type,ED_Hospital)
		Values(:Code,:Desc,:Type,:HospID))	
		
	s:SQLCODE'=0 QuitFlag=1
	Q QuitFlag
}

/// Description:	插入外部代码表
/// Creator:		Shy
/// CreateDate:		2020-07-28		
/// other:			w ##class(web.DHCCKBExtDictionary).InsertExtDics("TestData^测试字典","11874^9^1^290^2","2")
ClassMethod InsertExtDics(params, Type, HospID) As %String
{
	
	s len = $l(params,"&&")
	TS
	f i = 1:1:len   d
	.s tmpstr = $p(params,"&&",i)
	.s Code = $p(tmpstr,"^",1)
	.s Desc = $p(tmpstr,"^",2)
	.s Code = $replace(Code,"（","(")   
	.s Code = $replace(Code,"）",")")
	.s Desc = $replace(Desc,"（","(")
	.s Desc = $replace(Desc,"（","(")
	.s Type=Code
	.s QuitFlag=0
    .&SQL(Insert Into CKB_PDSS.ExtDiction(ED_Code,ED_Desc,ED_Type,ED_Hospital) Values(:Code,:Desc,:Type,:HospID))
    .i SQLCODE=0  d
    ..tc	
	.i SQLCODE'=0  d
	..s QuitFlag=1
	..tro
	q QuitFlag
}

/// Description:	插入外部代码表-sub
/// Creator:		Shy
/// CreateDate:		2020-07-28		
/// other:			w ##class(web.DHCCKBExtDictionary).InsertExtDics("TestData^测试字典","11874^9^1^290^2","2")
ClassMethod InsertExtsubDics(params, Type, HospID) As %String
{
	
	s len = $l(params,"&&")
	TS
	f i = 1:1:len   d
	.s tmpstr = $p(params,"&&",i)
	.s Code = $p(tmpstr,"^",1)
	.s Desc = $p(tmpstr,"^",2)
	.s Code = $replace(Code,"（","(")   
	.s Code = $replace(Code,"）",")")
	.s Desc = $replace(Desc,"（","(")
	.s Desc = $replace(Desc,"（","(")
	.s QuitFlag=0
    .&SQL(Insert Into CKB_PDSS.ExtDiction(ED_Code,ED_Desc,ED_Type,ED_Hospital) Values(:Code,:Desc,:Type,:HospID))
    .i SQLCODE=0  d
    ..tc	
	.i SQLCODE'=0  d
	..s QuitFlag=1
	..tro
	q QuitFlag
}

/// Descript:修改归属字典
/// Creator:wangxin
/// CreateDate:20201022
/// Input:dicId,dictionId
/// w ##class(web.DHCCKBExtDictionary).UdpDiction("","0")
ClassMethod UdpDiction(RowId, DictionId)
{
	n (RowId, DictionId)
	s ret=1
	if (RowId="")||(DictionId=""){
	
	}else{
	 &sql(update CKB_PDSS.ExtDiction set  ED_Type=:DictionId where ED_RowID=:RowId)
	 s ret=SQLCODE
	}
	Q ret
}

/// Description:	插入外部代码表
/// Creator:		qunianpeng
/// CreateDate:		2021-04-23	
/// other:			w ##class(web.DHCCKBExtDictionary).SaveUpdateExtDics("^测试^测试","DrugFreqData","99")
ClassMethod SaveUpdateExtDics(params, Type, HospID, Parref) As %String
{
	
	s len = $l(params,"&&")
	TS
	s ret = 0
	f i = 1:1:len  q:ret'=0  d
	.s tmpstr = $p(params,"&&",i)
	.s ID = $p(tmpstr,"^",1)
	.s Code = $p(tmpstr,"^",2)
	.s Desc = $p(tmpstr,"^",3)
	.s Code = $replace(Code,"（","(")   
	.s Code = $replace(Code,"）",")")
	.s Desc = $replace(Desc,"（","(")
	.s Desc = $replace(Desc,"（","(")	
	.i ID=""  d
	..s ret = ..CheckRepeat(ID,Code,Desc,Type,HospID)
	..q:ret<0
	..s ret = ..InsertExtDicsNew(Code,Desc,Type,HospID,Parref)
	
	
	
	.e  d
	
	..i ((Type="DrugData")||(Type="ChineseDrugData")||(Type="ChineseHerbalMedicineData")||(Type="DrugFreqData")||(Type="DrugPreMetData"))   d
	...s extFlag=..CheckContrastExt(tmpstr) ///是否存在对照数据
	...i extFlag'=0  d 
	....s ret=..UpdContrast(tmpstr) ///存在对照则更新对照表
	...q:ret'=0
		
	..s ret = ..UpdateExtDicsNew(ID,Code,Desc,Type,HospID,Parref)
	
	i ret=0 tc
	e  tro 
	
	q ret
}

/// Description:	插入更新外部代码表
/// Creator:		qunianpeng
/// CreateDate:		2021-04-23		
/// other:			w ##class(web.DHCCKBExtDictionary).InsertExtDicsNew)
ClassMethod InsertExtDicsNew(Code, Desc, Type, HospID, Parref) As %String
{
	n (Code,Desc,Type,HospID,Parref)
	
	&SQL(Insert Into CKB_PDSS.ExtDiction(ED_Code,ED_Desc,ED_Type,ED_Hospital,ED_Parref_Dr) Values(:Code,:Desc,:Type,:HospID,:Parref))
   	
   	q SQLCODE
}

/// Description:	更新外部代码表
/// Creator:		qunianpeng
/// CreateDate:		2021-04-23		
/// other:			w ##class(web.DHCCKBExtDictionary).UpdateExtDicsNew()
ClassMethod UpdateExtDicsNew(ID, Code, Desc, Type, HospID, Parref) As %String
{
	n (ID,Code,Desc,Type,HospID,Parref)
	
	&sql(update CKB_PDSS.ExtDiction set ED_Code=:Code,ED_Desc=:Desc,ED_Type=:Type,ED_Hospital=:HospID,ED_Parref_Dr=:Parref where ED_RowID=:ID )
	
	q SQLCODE
}

/// Description:	检查外部代码是否重复
/// Creator:		qunianpeng
/// CreateDate:		2021-04-23		
/// Input:			代码，描述，字典id
/// return:			存在则返回id，不存在则返回0
/// other:			w ##class(web.DHCCKBDiction).CheckDictionRepeat("","LinkProp","属性关联")
ClassMethod CheckRepeat(ID, Code, Desc, Type, HospID) As %String
{
	n (ID,Code,Desc,Type,HospID)
	s HospID=+HospID
	s ret=0  
	s codeExistFlag=0,descExistFlag=0,codeDr="",descDr=""	
	i (Code'="")&&($d(^CKB.PDSS.ExtDictionI("Code",HospID,Code)))  d	// 代码存在（代码是唯一项）
	.s tmpDicID=""
	.f  s tmpDicID=$o(^CKB.PDSS.ExtDictionI("Code",HospID,Code,tmpDicID))  q:(tmpDicID="")||(codeExistFlag=1)  d
	..s tmpType=$lg(^CKB.PDSS.ExtDictionD(tmpDicID),4)
	..q:(Type'="")&(Type'=tmpType)
	..s codeExistFlag=1
	..s codeDr=tmpDicID
	..s ret=-98	
	.
	i (ret=0)&(Desc'="")&&($d(^CKB.PDSS.ExtDictionI("Desc",HospID,Desc)))  d	// 描述存在
	.s tmpDicID=""
	.f  s tmpDicID=$o(^CKB.PDSS.ExtDictionI("Desc",HospID,Desc,tmpDicID))  q:(tmpDicID="")||(descExistFlag=1)  d
	..s tmpType=$lg(^CKB.PDSS.ExtDictionD(tmpDicID),4)
	..q:(Type'="")&(Type'=tmpType)
	..s descExistFlag=1
	..s descDr=tmpDicID
	..s ret=-99	
	q:ID="" ret
	s oldCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)    //代码
	s oldDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)    //描述

	q:(Code'="")&&(Code'=oldCode)&&(ret=-98) ret
	q:(Desc'="")&&(Desc'=oldDesc)&&(ret=-99) ret
			
	q 0
}

/// Description:	按照节点加载，展开时加载子节点(复制自:##class(web.DHCCKBQueryDic).GetTreeJsonDataByNode)
/// Creator:		qunianpeng 
/// CreateDate:		201-11-18	
/// Input:			代码^描述
/// other:			w ##class(web.DHCCKBExtDictionary).GetTreeJsonDataByNode("","146442","N")
ClassMethod GetTreeJsonDataByNode(Input As %String = "", id As %String, matchFlag = "") As %String
{
	n (Input,id,matchFlag)

	s parref=id
	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	
	k ^TMP("web.DHCCKBExtDictionary","GetTreeJsonDataByNode",pid)
	
	d ..SortCatByCode(parref,pid,0,matchFlag)		//数据排序

	d ##class(web.DHCCKBExtDictionary).GetSortTreeJsonByNode(Input, parref,pid)		//树查询
	
	k ^TMP("web.DHCCKBExtDictionary","GetTreeJsonDataByNode",pid)
	Q ""
}

/// Description:	按照按code排序 (复制自:##class(web.DHCCKBQueryDic).SortCatByCode)
/// Creator:		qunianpeng 
/// CreateDate:		201-11-18	
/// Debug d ##class(web.DHCCKBExtDictionary).SortCatByCode(106,1)
ClassMethod SortCatByCode(parref, pid, num = 0, matchFlag = "")
{
	n (parref,pid,num,matchFlag)
	s catID=""
	f  s catID= $o(^CKB.PDSS.ExtDictionI("Parref",parref,catID)) q:catID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(catID))
	.q:$lg(extData,5)="-1"   //要删除数据先暂时不删,将HospDr置为-1   此处过滤 shy 2011-11-29
	.s code=$lg(extData,2)
	.s constrastFlag=$d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(code)))
	.s childFlag='$d(^CKB.PDSS.ExtDictionI("Parref",catID))
	.b:code="A01.000x004"
	.q:(matchFlag'="")&&((matchFlag="N")&(constrastFlag)&(childFlag))	// 未匹配 且无子节点不展示
	.s num=num+1
	.s code=code_catID
	.s ^TMP("web.DHCCKBExtDictionary","GetTreeJsonDataByNode",pid,parref,code)=catID
	.i $d(^CKB.PDSS.ExtDictionI("Parref",catID))  d
	..d ..SortCatByCode(catID,pid,.num,matchFlag)
}

/// Description:	分类字典按code排序输出(复制自:##class(web.DHCCKBQueryDic).GetSortTreeJsonByNode)
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// other:			w ##class(web.DHCCKBExtDictionary).GetSortTreeJsonByNode("","106")
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
	s sortCode="" f  s sortCode=$o(^TMP("web.DHCCKBExtDictionary","GetTreeJsonDataByNode",pid,parref,sortCode)) q:sortCode=""  d
	.q:sortCode=""
	.s dicID=$g(^TMP("web.DHCCKBExtDictionary","GetTreeJsonDataByNode",pid,parref,sortCode))
	.q:+dicID=0
	.s extData = $g(^CKB.PDSS.ExtDictionD(dicID))	
	.s dicCode = $lg(extData,2) 
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg(extData,3) 
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.//q:count>100
	.;s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s ExistFlag=##class(web.DHCCKBExtDictionary).IsExistSubNode(dicID,input)
	.Q:(ExistFlag=0)&&(dicDesc'[input)&&(dicCode'[input)
	.s dicDesc=$replace(dicDesc,"\","")    //替换/Json解决格式错误 shy 2021-11-29
	.s dicDesc=$replace(dicDesc,"""","")    //替换/Json解决格式错误 shy 2021-11-29
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.s subID=$o(^CKB.PDSS.ExtDictionI("Parref",dicID,""))
	.s subFlag=..IsDisabled(dicID, 0)
	.i (subID'="")&&(subFlag=1) d
	..i input="" w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	..w ",""children"":"
	..D ..GetSortTreeJsonByNode(input,dicID,pid)   ///是否有叶子节点
	.w "}"	
	w "]"	
	
	q ""
}

/// Description:	判断子节点是否包含(复制自:##class(web.DHCCKBQueryDic).IsExistSubNode)
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// Input:ParentId
/// OutPut:1，包含，0，不包含
/// other:			w ##class(web.DHCCKBExtDictionary).GetSortTreeJsonByNode("","106")
ClassMethod IsExistSubNode(ParentId, input)
{
	n (ParentId,input)
	s IsExistFlag=0
	s NextId=$o(^CKB.PDSS.ExtDictionI("Parref",ParentId,""))
	
	i NextId=""  d
	.s ExtData = $g(^CKB.PDSS.ExtDictionD(ParentId))	
	.s dicCode = $lg(ExtData,2)
	.s dicDesc = $lg(ExtData,3) 
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(ParentId)	
	.i (dicDesc[input)||(dicCode[input)||(Alias[input) s IsExistFlag=1
	
	Q:NextId="" IsExistFlag
	s NextId="" 
	for  s NextId=$o(^CKB.PDSS.ExtDictionI("Parref",ParentId,NextId)) Q:(NextId="")||(IsExistFlag=1)  d
	.s ExtData = $g(^CKB.PDSS.ExtDictionD(NextId))		
	.s dicCode = $lg(ExtData,2)
	.s dicDesc = $lg(ExtData,3)
	.s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(ParentId)
	.i (dicDesc[input)||(dicCode[input)||(Alias[input) s IsExistFlag=1
	.Q:IsExistFlag=1
	.s IsExistFlag=..IsExistSubNode(NextId,input)	
	
	Q IsExistFlag
}

/// Description:	判断下级节点是有下级(复制自:##class(web.DHCCKBQueryDic).IsDisabled)
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// Input:			ParentId
/// Output:			1：可用，0：不可用
/// other:			w ##class(web.DHCCKBExtDictionary).IsDisabled("87855","0")
ClassMethod IsDisabled(ParentId, Num)
{
	n (ParentId,Num)
	s EnFlag=1
	s SubId=$o(^CKB.PDSS.ExtDictionI("Parref",ParentId,""))
	Q:SubId="" EnFlag
	s Id="",Num=0
	for  s Id=$o(^CKB.PDSS.ExtDictionI("Parref",ParentId,Id)) Q:(Id="")||(Num>0)   d
	.s Flag=##class(web.DHCCKBCommon).IsEnabled(Id)			//是否可用
	.i Flag=1 s Num=Num+1 s EnFlag=1
	.s:Num=0 EnFlag=0
	.i $d(^CKB.PDSS.ExtDictionI("Parref",Id))  d
	..s EnFlag=..IsDisabled(Id,.Num)
	Q EnFlag
}

/// Description:	删除数据
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// Input:			id
/// Output:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBExtDictionary).DeleteData(DeleteData)
ClassMethod DeleteData(idStr) As %String
{
	n (idStr)
	
	s isQuoteFlag = 0,ret = 0
	s len = $l(idStr,"^")
	
	f i=1:1:len  q:isQuoteFlag=1  d
	.s rowID = $p(idStr,"^",i)
	.s isQuoteFlag = ..CheckQuote(rowID)
	.i isQuoteFlag=1 s ret=-1
	.q:isQuoteFlag=1
	.s ret = ..DeleteExtDation(rowID)
   	
   	q ret
}

/// Description:	删除数据
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// Input:			id
/// Output:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBExtDictionary).DeleteExtDation(216915)
ClassMethod DeleteExtDation(rowID) As %String
{
	n (rowID)
	
	&SQL(delete from CKB_PDSS.ExtDiction where ED_RowID = :rowID)
   	
   	q SQLCODE
}

/// Description:	判断外部项目字典是否被引用
/// Creator:		qunianpeng
/// CreateDate:		2021-11-18	
/// Input:			rowID
/// Output:			1 引用 0 未引用
/// other:			w ##class(web.DHCCKBExtDictionary).CheckQuote()
ClassMethod CheckQuote(rowID) As %String
{
	n (rowID)
	s extData = $g(^CKB.PDSS.ExtDictionD(rowID))	
	s extCode = $lg(extData,2)
	s extDesc = $lg(extData,3) 
	s ret = 0
	
	i $d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode)))&&$d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(extDesc)))  s ret = 1
	
	q ret
}

/// Description:	删除字典数据
/// Creator:		ld
/// CreateDate:		2022-8-15		
/// Input:			字典数据ID^字典数据代码^字典数据描述^字典类型
/// return:			删除成功返回0
/// other:			w ##class(web.DHCCKBExtDictionary).DeleteDic("279406^测试3^测试3^DrugPreMetData")
ClassMethod DeleteDic(ListData)
{
	n (ListData)
	s ^TMP("DHCCKBExtDictionary","DeleteDic")=ListData
	TS
	s RowID=$p(ListData,"^",1)
	s Code=$p(ListData,"^",2)
	s Desc=$p(ListData,"^",3)
	s Type=$p(ListData,"^",4)
	i ((Type="DrugData")||(Type="ChineseDrugData")||(Type="ChineseHerbalMedicineData")||(Type="DrugFreqData")||(Type="DrugPreMetData"))   d
	.s ret=0
	.s extFlag=..CheckContrastExt(ListData) ///是否存在对照数据
	.i extFlag'=0  d
	..s ret=..DetContrast(ListData) ///存在对照数据就删除对照数据
	.q:ret'=0 
	.s ret=..DeleteExtDiction(ListData) ///删除字典数据
	.;.i ret=0 d
	.;..s ret=..DeleteExtDiction(ListData) ///删除字典数据
	.;e  d
	.;.s ret=..DeleteExtDiction(ListData) ///删除字典数据
	e  d
	.s ret=..DeleteExtDiction(ListData) ///非五个字典的其他字典，直接删除字典数据
	i ret=0 TC
	i ret'=0 TRO
	q ret
}

/// Description:	检查对照关系表是否存在对应数据
/// Creator:		ld
/// Table:		 	DHC_CKBComContrast
/// CreateDate:		2022-8-16		
/// Input:			字典ID
/// return:			
/// other:			w ##class(web.DHCCKBExtDictionary).CheckContrastExt("279406^测试3^测试3^DrugPreMetData")
ClassMethod CheckContrastExt(params)
{
	n (params)

	s ID = $p(params,"^",1)
	&SQL(
	SELECT ED_Code,ED_Desc,ED_Hospital
	INTO :befCode,:befDesc,:Hospital
	FROM CKB_PDSS.ExtDiction
	WHERE ED_RowID=:ID
	)
	&SQL(
	SELECT Count(*) INTO :Ret 
	FROM CKB_PDSS.ComContrast 
	WHERE CC_HisCode=:befCode AND CC_HisDesc=:befDesc AND CC_Hospital=:Hospital
	)
	q Ret
}

/// Description:	删除对照数据
/// Creator:		ld
/// Table:		 	DHC_CKBComContrast
/// CreateDate:		2022-8-16		
/// Input:			字典ID
/// return:			删除成功返回0,失败为1
/// other:			w ##class(web.DHCCKBExtDictionary).DetContrast("279398^测试11^测试11^ICDSourceData")
ClassMethod DetContrast(params)
{
	n (params)

	s ID = $p(params,"^",1)
	s Code = $p(params,"^",2)
	s Desc = $p(params,"^",3)
	s parref = $p(params,"^",4)
	&SQL(
	SELECT ED_Code,ED_Desc,ED_Hospital
	INTO :befCode,:befDesc,:Hospital
	FROM CKB_PDSS.ExtDiction
	WHERE ED_RowID=:ID
	)
	&SQL(
	DELETE FROM CKB_PDSS.ComContrast 
	WHERE CC_HisCode=:befCode AND CC_HisDesc=:befDesc AND CC_Hospital=:Hospital
	)
	q SQLCODE
}

/// Description:	删除字典数据
/// Creator:		ld
/// Table:		 	DHC_CKBExtDiction
/// CreateDate:		2022-8-16		
/// Input:			字典ID
/// return:			删除成功返回0,失败为SQlCode
/// other:			w ##class(web.DHCCKBExtDictionary).DeleteExtDiction("279398^测试11^测试11^ICDSourceData")
ClassMethod DeleteExtDiction(params)
{
	n (params)
	s ^TMP("DHCCKBExtDictionary","DeleteExtDiction")=params
	s ID = $p(params,"^",1)
	&SQL(
	DELETE FROM CKB_PDSS.ExtDiction 
	WHERE ED_RowID=:ID
	)
	q SQLCODE
}

/// Description:	更新对照数据
/// Creator:		ld
/// Table:		 	DHC_CKBComContrast
/// CreateDate:		2022-8-16		
/// Input:			字典ID
/// return:			
/// other:			w ##class(web.DHCCKBExtDictionary).UpdContrast("279407^测试44^测试44")
ClassMethod UpdContrast(params)
{
	n (params)

	s ID = $p(params,"^",1)
	s Code=$p(params,"^",2)
	s Desc=$p(params,"^",3)
	&SQL(
	SELECT ED_Code,ED_Desc,ED_Hospital
	INTO :befCode,:befDesc,:Hospital
	FROM CKB_PDSS.ExtDiction
	WHERE ED_RowID=:ID
	)

	&SQL(
	UPDATE CKB_PDSS.ComContrast SET CC_HisCode=:Code,CC_HisDesc=:Desc
	WHERE CC_HisCode=:befCode AND CC_HisDesc=:befDesc AND CC_Hospital=:Hospital
	)
	q SQLCODE
}

}
