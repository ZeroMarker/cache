Import SQLUser

Class web.DHCCKBSearchconDic Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: 	sufan
/// CreateDate: 2021-06-17
/// Descript: 	查询药品列表
/// w ##class(web.DHCCKBSearchconDic).QueryDrugList(30,1,"drug^3")
ClassMethod QueryDrugList(rows As %String, page As %String, params As %String)
{
	s ^temptest("333")=$lb(rows,page,params)
	;q:params="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) //输出json结尾符
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows 			 //结束行
	s StPage=((page-1)*rows)+1       //开始行
	s dictype = $p(params,"^",1)
	s hospId = $p(params,"^",2)
	
	s count = 0
	w "{""rows"":["
	s itmCatId = ""
	for  s itmCatId = $o(^ARC("IC",0,"OrderType","R",itmCatId))  Q:itmCatId=""  d
	.s subscript = ""
	.for  s subscript = $o(^ARCIM(0,"ARCIC_DR",itmCatId,subscript))  Q:subscript=""  d
	..s version = ""
	..for  s version = $o(^ARCIM(0,"ARCIC_DR",itmCatId,subscript,version))  Q:version=""  d
	...s itmmastId = subscript_"||"_version
	...s ARCIMEnable=##class(web.DHCBL.CT.ARCItmMast).GetARCIMEnable(itmmastId) //判断医嘱是否可用
	...q:ARCIMEnable'="Y"
	...s drugCode = $p(^ARCIM(subscript,version,1),"^",1)					//药品代码
	...Q:(hospId'="")&&(##class(web.DHCCKBSearchconDic).IsHospDrug(drugCode,hospId)=1)
	...s drugDesc = $p(^ARCIM(subscript,version,1),"^",2)					//药品名称
	...s dosform = ##class(web.DHCCKBSearchconDic).GetForm(itmmastId)		//剂型
	...s manufact = ##class(web.DHCCKBSearchconDic).GetManf(itmmastId)	//厂家
	...s manufact= $p(manufact,"^",3)
	...s specificat = ##class(web.DHCCKBSearchconDic).GetSpec(itmmastId)	//规格
	...s commonname = ##class(web.DHCCKBSearchconDic).GetCommonname(itmmastId)		//通用名
	...s remark = ##class(web.DHCCKBSearchconDic).GetInciRemark(itmmastId)	//批准文号
	...s type = ##Class(web.DHCCKBSearchconDic).GetRecipType(drugCode)	//类型
	...Q:(dictype'="")&&(dictype'=type)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...s tmpObj={}
	...s tmpObj.itmmastId = itmmastId
	...s tmpObj.drugCode = drugCode
	...s tmpObj.drugDesc = drugDesc
	...s tmpObj.dosform = dosform
	...s tmpObj.manufact = manufact
	...s tmpObj.specificat = specificat
	...s tmpObj.commonname = commonname
	...s tmpObj.remark = remark
	...s tmpObj.type = type
	...w tmpObj.%ToJSON()
	
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:根据医嘱项获取剂型
/// w ##class(web.DHCCKBSearchconDic).GetForm()
ClassMethod GetForm(itmmastId As %String)
{
	s inciId = $o(^INCI(0,"ARCIM_DR",+itmmastId,""))
	Q:inciId="" ""
    s formStr = ##Class(web.DHCST.Common.DrugInfoCommon).GetForm(inciId)
    Q $p(formStr,"^",2)
}

/// Descript:规格
/// w ##class(web.DHCCKBSearchconDic).GetSpec("2322||1")
ClassMethod GetSpec(itmmastId As %String) As %String
{
	s inciId = $o(^INCI(0,"ARCIM_DR",+itmmastId,""))
	Q:$g(inciId)="" ""
	s spec = ""
	s add = $o(^DHCITMINFO(0,"INCI",inciId,"")) 
	Q:add="" ""
	s spec = $p($G(^DHCITMINFO(add)),"^",27)
	Q spec
}

/// Descript:通用名
/// w ##class(web.DHCCKBSearchconDic).GetCommonname()
ClassMethod GetCommonname(itmmastId As %String) As %String
{
	s inciId = $p($g(^ARCIM(+itmmastId,1,1)),"^",12)
 	q:+$g(inciId)=0 ""
 	s genericId = $p(^PHCD(+inciId,4),"^",1) 
 	q:$g(genericId)="" ""
 	s geneName = $p($g(^PHCGE("GE",genericId)),"^",2) 
 	q $g(geneName)
}

/// Descript:厂家
/// w ##class(web.DHCCKBSearchconDic).GetManufact("2322||1")
ClassMethod GetManufact(itmmastId As %String) As %String
{
  	s inciId = $p($g(^ARCIM(+itmmastId,1,1)),"^",12)
 	Q:inciId="" ""
 	Q:'$D(^PHCD(inciId)) ""
 	S manfId = $P(^PHCD(inciId,2),"^",4)
 	Q:manfId="" ""
 	Q:'$D(^PHMNF(manfId)) ""
 	S manfCode = $P(^PHMNF(manfId),"^",1)
 	S manfName = $P(^PHMNF(manfId),"^",2)
 	Q manfId_"^"_manfCode_"^"_manfName
}

/// Descript:医疗机构
/// w ##class(web.DHCCKBSearchconDic).GetHosp()
ClassMethod GetHosp()
{
	
	s count = 0
	w "["
	s hospId = ""
	for  s hospId = $o(^CT("HOSP",hospId))  Q:hospId=""  d
	.s code = $p(^CT("HOSP",hospId),"^",1)
	.s desc = $p(^CT("HOSP",hospId),"^",2)
	.Q:desc=""
	.s count = count+1
	.w $case(count,1:"",:",")
	.s tmpObj={}
	.s tmpObj.value = hospId
	.s tmpObj.text = desc
	.w tmpObj.%ToJSON()
	w "]"
	Q ""
}

/// Descript:判断是否是本院医嘱
/// w ##class(web.DHCCKBSearchconDic).IsHospDrug("Y007954000",2)
ClassMethod IsHospDrug(drugCode, hosp)
{
	s isFlag = 0
	s conId = ""
	for  s conId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(drugCode),conId))  Q:conId=""  d
	.s hisCode = $lg(^CKB.PDSS.ComContrastD(conId),4)
	.Q:'$d(^CKB.PDSS.ExtDictionI("Code",hosp,hisCode))
	.s isFlag = 1
	Q isFlag
}

/// Descript: 批准文号
/// w ##class(web.DHCCKBSearchconDic).GetInciRemark("2322||1")
ClassMethod GetInciRemark(itmmastId As %String) As %String
{
	s inciId = ##Class(web.DHCCKBSearchconDic).GetInciByArcim(itmmastId)
	q:inciId="" "-"
	s info=$o(^DHCITMINFO(0,"INCI",inciId,0))
	q:info="" "-"
	s remark=$p(^DHCITMINFO(info),"^",10)
	i $p(remark,"-",2)="undefined" s remark="-"
	i remark="" s remark="-"
	i remark'["-" s remark=remark_"-"
	q remark
}

/// Descript:取处方类型
/// Creator:sufan
/// CreateDate:2021-05-23
/// Input:医嘱项代码
/// w ##Class(web.DHCCKBSearchconDic).GetRecipType("KQXY000011")
ClassMethod GetRecipType(arcCode)
{
	Q:arcCode="" ""
	s subscript = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcCode),""))
	s version = $o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcCode),subscript,""))
	s itmmastId = subscript_"||"_version
	Q:subscript="" ""
	s ordCatId = $p(^ARCIM(subscript,version,1),"^",10)			//医嘱子类
	s ordCatgloryId = $p(^ARC("IC",ordCatId),"^",8)				//医嘱大类Id
	s catDesc = $p(^OEC("ORCAT",ordCatgloryId),"^",2)			//医嘱大类
	Q:(catDesc["西药") "西药"
	Q:(catDesc["中成药") "中成药"
	Q:(catDesc["草药颗粒")||(catDesc["草药饮片")||(catDesc["中草药") "草药"
	Q ""
}

/// Descript:根据医嘱项取库存项
/// w ##Class(web.DHCCKBSearchconDic).GetInciByArcim("2322||1")
ClassMethod GetInciByArcim(itmmastId)
{
 	s arcimSub = $p(itmmastId,"||",1)
 	q:arcimSub=""
 	s inciId = $o(^INCI(0,"ARCIM_DR",arcimSub,""))
 	q inciId
}

/// Descript:	根据库存项的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
/// w ##class(web.DHCCKBSearchconDic).GetManf("269||1")
ClassMethod GetManf(itmmastId)
{
	
	q:itmmastId="" ""
	s ArcimSub=$p(itmmastId,"||",1)
 	q:ArcimSub=""
 	s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSub,""))
 	
 	S Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciID)
	Q:Phcdf="" ""
	s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManfByPhcd(+Phcdf)
	q ManfInfo
 //s InciDr = ..GetInciByArcim(itmmastId)
 //Q:InciDr="" ""
 //s scgType=$P(..GetIncStkCatGrp(InciDr),"^",3)
 //if scgType="M"   //物资用的取厂家的方法
 //{
 //	s Add=$o(^DHCITMINFO(0,"INCI",InciDr,"")) 
 //	q:Add="" ""
 //	s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
 //	s:ManfId'="" ManfCode=$P(^PHMNF(ManfId),"^",1)
 //	s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
 //	q ManfId_"^"_$G(ManfCode)_"^"_$g(ManfDesc)
 // }
 //else
 //{
 //	s Add=$o(^DHCITMINFO(0,"INCI",InciDr,"")) 
 //	q:Add="" ""
 //	s ManfId=$p($G(^DHCITMINFO(Add)),"^",48)
 //	s:ManfId'="" ManfCode=$P(^PHMNF(ManfId),"^",1)
 //	s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
 //	q ManfId_"^"_$G(ManfCode)_"^"_$g(ManfDesc)
 // }
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci) As %Library.String
{
	Q:inci="" ""
	Q:'$d(^INCI(inci,2)) ""
	s inccat=$p(^INCI(inci,2),"^",2)
	q:inccat="" ""
	s scg=$o(^DHCSCG("STKCAT",inccat,""))
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=""
	S scgtypeDesc=..stktypeDesc(scgtype)
	s scgset=$p(^DHCSCG(scg),"^",5)
	s scgstrumodeflag=$p(^DHCSCG(scg),"^",7)
	q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc_"^"_scg_"^"_scgset_"^"_$g(scgstrumodeflag)
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String
{
	I scgtype="G" q "Drug"
	I scgtype="M" q "Material"
	q "Other"
}

/// Creator: 	sunhuiyong
/// CreateDate: 2022-04-27
/// Descript: 	查询原研药品列表
/// w ##class(web.DHCCKBSearchconDic).QueryHCDrugList(999999,1,"drug^3")
ClassMethod QueryHCDrugList(rows As %String, page As %String, params As %String)
{
	s rows=999
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows 			 //结束行
	s StPage=((page-1)*rows)+1       //开始行
	s dictype = $p(params,"^",1)
	s hospId = $p(params,"^",2)
	
	s count = 0
	w "{""rows"":["
	s itmCatId = ""
	for  s itmCatId = $o(^CT.CKB.PDSS.DicLinkAttrD(itmCatId)) Q:itmCatId=""  d
	.q:itmCatId=0
	.q:($e($lg($g(^CT.CKB.PDSS.DicLinkAttrD(itmCatId)),5),1,6)'="国药准字SJ")&&($e($lg($g(^CT.CKB.PDSS.DicLinkAttrD(itmCatId)),5),1,5)'="国药准字J")
	.s DicDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(itmCatId)),2)
	.q:DicDr=""
	.s libFactory="",libGenalName="",Name=""
	.s Name=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicDr)),3)       //名称
	.s DLA="" f  s DLA=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",DicDr,DLA))  q:DLA=""  d
	..s LinkCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),3)
	..s:LinkCode="44" libFactory=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //厂家
	..s:LinkCode="74532" libGenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //通用名
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.itmmastId = Name
	.s tmpObj.drugCode = libFactory
	.s tmpObj.drugDesc = libGenalName
	.s tmpObj.dosform = Name
	.s tmpObj.manufact = libFactory
	.s tmpObj.specificat = libGenalName
	.s tmpObj.commonname = libGenalName
	.s tmpObj.remark = Name
	.s tmpObj.type = Name
	.w tmpObj.%ToJSON()
	
	w "],""total"":"_count_"}"
	q ""
}

/// Creator: 	quniannpeng
/// CreateDate: 2022-07-28
/// Descript: 	查询新增的字典数据
/// w ##class(web.DHCCKBSearchconDic).QueryNewDicList(30,1,"DrugPreMetData^2")
/// w ##class(web.DHCCKBSearchconDic).QueryNewDicList(30,1,"DrugFreqData^2")
ClassMethod QueryNewDicList(rows As %String, page As %String, params As %String)
{
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows 			 //结束行
	s StPage=((page-1)*rows)+1       //开始行
	s dictype = $p(params,"^",1)
	s dictypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(dictype)
	s hospId = $p(params,"^",2)
	
	k TmpArr
	s count = 0
	// 频次
	i dictype = "DrugFreqData" d
	.s id = ""
	.f  s id = $o(^PHCFR(id))  q:id=""  d
	..s code = $p($g(^PHCFR(+id)),"^",1)
	..s desc = $p($g(^PHCFR(+id)),"^",3)
	..q:code=""||(desc="")
	..s activeFlag = $p($g(^PHCFR(+id)),"^",6)
	..q:activeFlag="N"
	..q:""'=##class(web.DHCCKBComContrast).GetSysConst(code,desc,dictypeId,hospId)	// 没有对照
	..s count = count + 1
	..s TmpArr(count) = $lb(id,code,desc)	
	
	// 途径
	i dictype = "DrugPreMetData" d
	.s id = ""
	.f  s id = $o(^PHCIN(id))  q:id=""  d
	..s code = $p($g(^PHCIN(+id)),"^",1)
	..s desc = $p($g(^PHCIN(+id)),"^",2)
	..q:code=""||(desc="")
	..s activeFlag = $p($g(^PHCIN(+id)),"^",4)
	..q:activeFlag="N"
	..q:""'=##class(web.DHCCKBComContrast).GetSysConst(code,desc,dictypeId,hospId)	// 没有对照
	..s count = count + 1
	..s TmpArr(count) = $lb(id,code,desc)
	
	w "{""rows"":["
	s count = 0 
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.q:data=""
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.id = $lg(data,1)
	.s tmpObj.code = $lg(data,2)
	.s tmpObj.desc = $lg(data,3) 
	.s tmpObj.type = $s(dictype="DrugPreMetData":"给药途径字典",dictype="DrugFreqData":"用药频率字典",1:"")
	.w tmpObj.%ToJSON()
	
	w "],""total"":"_count_"}"
	q ""
}

/// 导出与适应症不明确列相关内容
Query ExportNewDicList(params) As websys.Query(ROWSPEC = "f1:%String:项目代码,f2:%String,项目描述,f3:%String:药品类型")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBSearchconDic","ExportNewDicList","DrugFreqData^2") 
ClassMethod ExportNewDicListExecute(ByRef qHandle As %Binary, params) As %Status
{

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s dictype = $p(params,"^",1)
	s dictypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(dictype)
	s hospId = $p(params,"^",2)
	
	k TmpArr
	s count = 0
	// 频次
	i dictype = "DrugFreqData" d
	.s id = ""
	.f  s id = $o(^PHCFR(id))  q:id=""  d
	..s code = $p($g(^PHCFR(+id)),"^",1)
	..s desc = $p($g(^PHCFR(+id)),"^",3)
	..q:code=""||(desc="")
	..s activeFlag = $p($g(^PHCFR(+id)),"^",6)
	..q:activeFlag="N"
	..q:""'=##class(web.DHCCKBComContrast).GetSysConst(code,desc,dictypeId,hospId)	// 没有对照
	..s count = count + 1
	..s TmpArr(count) = $lb(id,code,desc)	
	
	// 途径
	i dictype = "DrugPreMetData" d
	.s id = ""
	.f  s id = $o(^PHCIN(id))  q:id=""  d
	..s code = $p($g(^PHCIN(+id)),"^",1)
	..s desc = $p($g(^PHCIN(+id)),"^",2)
	..q:code=""||(desc="")
	..s activeFlag = $p($g(^PHCIN(+id)),"^",4)
	..q:activeFlag="N"
	..q:""'=##class(web.DHCCKBComContrast).GetSysConst(code,desc,dictypeId,hospId)	// 没有对照
	..s count = count + 1
	..s TmpArr(count) = $lb(id,code,desc)
	
	s count = 0 
	s index = ""
	f  s index = $o(TmpArr(index))  q:index=""  d
	.s data = $g(TmpArr(index))
	.q:data=""
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
