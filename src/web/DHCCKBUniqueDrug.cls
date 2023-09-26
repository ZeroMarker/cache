Class web.DHCCKBUniqueDrug Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 导出药品去重结果 
/// w ##Class(websys.Query).ToExcel("药品去重结果(all+带剂型通用名+等效单位)mark","web.DHCCKBUniqueDrug","ExportUniqueDrug","generalForm")
Query ExportUniqueDrug(type) As websys.Query(ROWSPEC = "f1:%String:id,f2:%String:药品代码,f3:%String:药品描述,f4:%String:字典,f5:%String:剂型,f6:%String:带剂型通用名,f7:%String:规格,f8:%String:等效单位,f9:%String:核实,f10:%String:医院")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBUniqueDrug","ExportUniqueDrug","generalForm") 
/// @param: pid 进程号 10619805 generalForm 带剂型通用名+等效单位,10619806 general 带剂型通用名
ClassMethod ExportUniqueDrugExecute(ByRef qHandle As %Binary, type) As %Status
{
	n (qHandle,type)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s pid = ""
	i type = "general" 	s pid=10619806
	i type = "generalForm" 	s pid=10619805
	//d ..UniqueAllDrug()
	//s pid = $order(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",""),-1)
	set id=""
	for  set id=$order(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id)) quit:id=""  do	
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(id)		//判断是否有规则 - 过滤没有规则的药品
	.q:ruleFlag=0
	.s markFlag=$g(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))
	.q:markFlag=""
	.//s itmPhCatList=##Class(web.DHCCKBCommon).GetAlonePhCat(+id,0) // 去掉溶媒类
	.//q:$listfind(itmPhCatList,"溶媒类")'=0 
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s code=$tr(code,",",".")	// 逗号会导致输出excel时换列
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s desc=$tr(desc,",",".")
	.s parref =$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s parrefCode=""
	.s:+parref'=0 parrefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),2)
	.s:+parref'=0 parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDrug="" //$g(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))
	.s linkDrug="" //$listtostring(linkDrug)
	.s formProp = ##class(web.DHCCKBCommon).GetFormProp()	// 剂型
	.s form=##class(web.DHCCKBEditProp).QueryAttrValue(id,formProp)
	.s form=$tr(form,",","，")
	.s generNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	.s generalName=##class(web.DHCCKBEditProp).QueryAttrValue(id,generNameFormProp)
	.s generalName=$tr(generalName,",","，")
	.s specificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	.s spec=##class(web.DHCCKBEditProp).QueryAttrValue(id,specificationProp)
	.s spec=$tr(spec,",","，")
	.s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位
	.s eqUnit=##class(web.DHCCKBEditProp).QueryAttrValue(id,eqUnitProp)
	.s eqUnit=$tr(eqUnit,",","，")
	.s isConfirm=..isConfirm(id)	// 是否核实
	.s isConfirm=$select(isConfirm=1:"Y",isConfirm="0":"N",1:"N")
	.s constHospList=..GetConstHosp($lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2),$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3),parrefCode)	// 通过代码和描述,获取被哪些医院进行对照过
	.s listData=$lb(id,code,desc,parref,form,generalName,spec,eqUnit,isConfirm,constHospList)
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	将去重的结果,预先存储到临时global中,解决数据量大查询慢的问题
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-22
/// Input:			type:general(以通用名方式查询),generalForm(以通用名+等效单位方式查询)
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).SetUniqueAllDrugResult("generalForm")
///  pid 进程号 10619805 带剂型通用名+等效单位,10619806 带剂型通用名
ClassMethod SetUniqueAllDrugResult(type) As %String
{
	n (type)
	
	i type = "general" 	s pid=10619806
	i type = "generalForm" 	s pid=10619805

	s listTitle="id^code^desc^parref^linkDrug^form^generalName^spec^eqUnit^ruleFlag^hospList"
	s id = ""
	f  s id=$o(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))  q:id=""  d
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(id)		//判断是否有规则 - 过滤没有规则的药品
	.q:ruleFlag=0
	.s markFlag=$g(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))
	.q:markFlag=""
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref =$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s parrefCode=""
	.s:+parref'=0 parrefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),2)
	.s:+parref'=0 parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDrug="" //$g(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))
	.s linkDrug="" //$listtostring(linkDrug)
	.s formProp = ##class(web.DHCCKBCommon).GetFormProp()	// 剂型
	.s form=##class(web.DHCCKBEditProp).QueryAttrValue(id,formProp)
	.s generNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	.s generalName=##class(web.DHCCKBEditProp).QueryAttrValue(id,generNameFormProp)
	.s specificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	.s spec=##class(web.DHCCKBEditProp).QueryAttrValue(id,specificationProp)
	.s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位
	.s eqUnit=##class(web.DHCCKBEditProp).QueryAttrValue(id,eqUnitProp)
	.s isConfirm=..isConfirm(id)	// 是否核实
	.s isConfirm=$select(isConfirm=1:"Y",isConfirm="0":"N",1:"N")
	.s constHospList=..GetConstHosp($lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2),$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3),parrefCode)	// 通过代码和描述,获取被哪些医院进行对照过
	.s listData=id_"^"_code_"^"_desc_"^"_parref_"^"_linkDrug_"^"_form_"^"_generalName_"^"_spec_"^"_eqUnit_"^"_isConfirm_"^"_constHospList
	.s ^TMPDHCCKBSetUniqueAllDrugResult(type,id)=listData
	
	q ""
}

/// Description:	将去重的结果,预先存储到临时global中,解决数据量大查询慢的问题,从临时global中遍历向界面输出
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-22
/// Input:			type:general(以带剂型通用名方式查询),generalForm(以带剂型通用名+等效单位方式查询)
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).QueryUniqueAllDrug(30,1,"generalForm")
ClassMethod QueryUniqueAllDrug(rows, page, type) As %String
{
	n (rows, page,type)
	s ^Tnopp=$lb(rows,page,type)
	s end = page*rows
	s start=(page-1)*rows+1
	s count = 0
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s listTitle="index^id^code^desc^parref^linkDrug^form^generalName^spec^eqUnit^ruleFlag^hospList"
	s index = "",count = 0
	f  s index=$o(^TMPDHCCKBSetUniqueAllDrugResult(type,index))  q:index=""  d
	.s count=count + 1
	.s listData=$g(^TMPDHCCKBSetUniqueAllDrugResult(type,index))
	.s listData=index_"^"_listData
	.q:(count<start)||(count>end)
	.//i count=1 d
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	
	q ""
}

/// Description:	药品去重(规则:带剂型的通用名+规格/等效单位)相同,优先展示审核过的(药品有审核标记或规则有审核标记),修订日期靠前,厂家比较大,靠前(厂家列表),优先国外
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			type:general(以通用名方式查询),generalForm(以通用名+等效单位方式查询)
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).UniqueAllDrug(30,1,"general")
///  pid 进程号 10619805 带剂型通用名+等效单位,10619806 带剂型通用名
ClassMethod UniqueAllDrug(rows, page, type) As %String
{
	n (rows, page,type)
	//1. 遍历所有的药品,获取药品通用名,等效单位,剂型
	//2. 相同的药品记录一次,获取修订日期,厂家,比较
	
	//k ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug")
	//s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	//d ..UniqueDrug(pid,"DrugData")		// 西药
	//d ..UniqueDrug(pid,"ChinaDrugData")	// 中成药
	s end = page*rows
	s start=(page-1)*rows+1
	i type = "general" 	s pid=10619806
	i type = "generalForm" 	s pid=10619805
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s listTitle="index^id^code^desc^parref^linkDrug^form^generalName^spec^eqUnit^ruleFlag"
	s id = "",count = 0
	f  s id=$o(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))  q:id=""  d
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(id)		//判断是否有规则 - 过滤没有规则的药品
	.q:ruleFlag=0
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s parref =$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.s:+parref'=0 parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDrug=$g(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id))
	.s linkDrug=$listtostring(linkDrug)
	.s formProp = ##class(web.DHCCKBCommon).GetFormProp()	// 剂型
	.s form=##class(web.DHCCKBEditProp).QueryAttrValue(id,formProp)
	.s generNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	.s generalName=##class(web.DHCCKBEditProp).QueryAttrValue(id,generNameFormProp)
	.s specificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	.s spec=##class(web.DHCCKBEditProp).QueryAttrValue(id,specificationProp)
	.s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位
	.s eqUnit=##class(web.DHCCKBEditProp).QueryAttrValue(id,eqUnitProp)
	.s isConfirm=..isConfirm(id)	// 是否核实
	.s isConfirm=$select(isConfirm=1:"Y",isConfirm="0":"N",1:"N")
	.s listData=count_"^"_id_"^"_code_"^"_desc_"^"_parref_"^"_linkDrug_"^"_form_"^"_generalName_"^"_spec_"^"_eqUnit_"^"_isConfirm
	.s count=count + 1
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	
	q ""
}

/// Description:	药品去重(规则:带剂型的通用名+规格/等效单位)相同,优先展示审核过的(药品有审核标记或规则有审核标记),修订日期靠前,厂家比较大,靠前(厂家列表),优先国外
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).UniqueDrug()
ClassMethod UniqueDrug(pid, type) As %String
{
	n (pid,type)
	
	k TmpArr
	s drugDataId=""
	i type = "DrugData" d
	.s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	.d ##class(web.DHCCKBUniqueDrug).SetFactory()
	i type ="ChinaDrugData" d
	.s drugDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	.d ##class(web.DHCCKBUniqueDrug).SetChinaFactory()
	
	s id = "",count=0
	f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,id))	q:id=""  d
	.q:0=##class(web.DHCCKBCommon).IsEnabled(id)
	.q:$d(TmpArr("mark",id))
	.s count = count + 1
	.w count,!
	.s generalFromList=##class(web.DHCCKBCommon).GetGeneralFrom(id,0)	// 带剂型的通用名
	.s contrastId=id,isEqualFlag=0
	.f  s contrastId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,contrastId))	q:(contrastId="")  d
	..q:0=##class(web.DHCCKBCommon).IsEnabled(contrastId)
	..q:$d(TmpArr("mark",contrastId))
	..q:contrastId=id
	..// 带剂型的通用名比较
	..s conGeneralFromList=##class(web.DHCCKBCommon).GetGeneralFrom(contrastId,0) // 带剂型的通用名
	..s generalFlag=##class(web.DHCCKBCommonUtil).CompareBothList(generalFromList,conGeneralFromList)	// 求交集
	..q:generalFlag=0
	..// 等效单位比较
	..//k unitArr1,unitArr2
	..//d ..GetEqFactorList(id,.unitArr1)
	..//d ..GetEqFactorList(contrastId,.unitArr2)
	..//s unitFlag = ..CompareEqFactor(.unitArr1,.unitArr2)
	..//q:unitFlag=0
	..s TmpArr("mark",contrastId)=""	// 到这里时,带剂型的通用名+规格,等效单位相同.记录下此类数据
	..s isEqualFlag = 1 
	..s $list(TmpArr("group",count),*+1)=contrastId
	.
	.i $d(TmpArr("group",count))&&($listlength(TmpArr("group",count))>0) d
	..s $list(TmpArr("group",count),*+1)=id
	..s TmpArr("mark",id)=""
	.
	.s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,id)="" // 这里记录的是不能去重的数据
	
	
	s index=""
	s tmpId="",exitFlag = 0
	f  s tmpId=$o(TmpArr("group",index)) q:index=""  d
	.s drugList=$g(TmpArr("group",index))
	.q:drugList=""
	.s tmpId=""
	.f k=1:1:$listlength(drugList) q:exitFlag=1  d
	..s tmpId=$listget(drugList,k)
	..s isConfirmFlag = ..isConfirm(tmpId) // 药品审核标记
	..i isConfirmFlag=1 s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,tmpId)=drugList,exitFlag=1
	..q:exitFlag=1
	..s drugManfPropId=##class(web.DHCCKBCommon).GetDrugManf()
	..s factory = ##class(web.DHCCKBEditProp).QueryAttrValue(tmpId,drugManfPropId)
	..i type="DrugData" d
	...i $d(^TMP("DHCCKB","Factory",factory))  s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,tmpId)=drugList,exitFlag=1
	..i type="ChinaDrugData" d 
	...i $d(^TMP("DHCCKB","ChinaFactory",factory))  s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,tmpId)=drugList,exitFlag=1
	
	..q:exitFlag=1
	.// 没有按照优先级输出时,输出第一个
	.i exitFlag=0 d
	..s tmpId=$listget(TmpArr("group",index))
	..s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,tmpId)=drugList
	
	//b //1
		
	q ""
}

/// Description:	药品是否有核实标记(规则:药品被打上标记,或者药品的某一条规则被打上标记,都算)
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			1 标记 0 未标记
/// other:			w ##class(web.DHCCKBUniqueDrug).isConfirm()
ClassMethod isConfirm(drugId) As %String
{
	n (drugId)
	s ret = 0
	s drugFirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",drugId,"confirm"))	// 药品核实
	s:drugFirmFlag>0 ret=1
	q:ret>0 ret
	s ruleFirmFlag = ##class(web.DHCCKBPrescTest).isConfirmByRule(drugId)	// 规则核实
	s:ruleFirmFlag=1 ret=1
	
	q ret
}

/// Description:	比较等效单位是否相同
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			等效单位数组
/// return:			1相等 0 不相等
/// other:			w ##class(web.DHCCKBUniqueDrug).CompareEqFactor()
ClassMethod CompareEqFactor(unitArr1, unitArr2) As %String
{
	n (unitArr1,unitArr2)
	s flag = 0
	s fUnit =""
	f  s fUnit=$o(unitArr1(fUnit))	q:(fUnit="")||(flag=1)  d
	.s tUnit=""
	.f  s tUnit=$o(unitArr1(fUnit,tUnit))  q:(tUnit="")||(flag=1)  d
	..q:('$d(unitArr2(fUnit,tUnit)))&('$d(unitArr2(tUnit,fUnit)))	
	..s factor=$g(unitArr1(fUnit,tUnit))
	..s factorTmp1=$g(unitArr2(fUnit,tUnit))
	..s factorTmp2=$g(unitArr2(tUnit,fUnit))
	..q:(factor'="")&(factor'=factorTmp1)&(factor'=factorTmp2)
	..s flag = 1
	
	q flag
}

/// Description:	获取药品的等效单位
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).GetEqFactorList()
ClassMethod GetEqFactorList(drugId, unitArr) As %String
{
	n (drugId,unitArr)
	
	s eqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp()	// 等效单位属性
	s linkProp=##class(web.DHCCKBCommon).GetLinkProp()			// 属性关联
	s linkAttr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",eqUnitProp,linkProp,""))	// 单位转换系数关联的属性（模板）
	s frUomProp=##class(web.DHCCKBCommon).GetEqFromUnitProp()
	s toUomProp=##class(web.DHCCKBCommon).GetEqToUnitProp()
	s facProp=##class(web.DHCCKBCommon).GetEqFactorProp()
	
	s unitChangeTemp=linkAttr		// 单位转换模板	
	k tmpUnitArr
	s childProp=""
	f  s childProp=$o(^CT.CKB.PDSS.CommonDictionI("Parref",unitChangeTemp,childProp))  q:childProp=""  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp))
	.s attrId=""
	.f  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,childProp,attrId))  q:attrId=""   d
	..s group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	..i childProp=frUomProp s $p(tmpUnitArr(group),"^",1)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=toUomProp s $p(tmpUnitArr(group),"^",2)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4),:"")
	..i childProp=facProp s $p(tmpUnitArr(group),"^",3)=$case(attrId'="",1:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5),:"")

	s index=""
	f   s index=$o(tmpUnitArr(index))  q:index=""  d
	.s fUnit=$p(tmpUnitArr(index),"^",1)
	.s tUnit=$p(tmpUnitArr(index),"^",2)
	.s num=$p(tmpUnitArr(index),"^",3)
	.q:(fUnit="")||(tUnit="")
	.s unitArr(fUnit,tUnit)=$case(+num=0,1:"",:+num)
	.s unitArr(tUnit,fUnit)=$case(+num=0,1:"",:(1/num))

	q ""
}

/// Description:	设置西药厂家集合排序
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).SetFactory()
ClassMethod SetFactory() As %String
{
	//s ^TMP("DHCCKB","Factory",)=""
	s ^TMP("DHCCKB","Factory","江苏恒瑞医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","正大天晴药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","齐鲁制药有限公司")=""
	s ^TMP("DHCCKB","Factory","扬子江药业集团有限公司")=""
	s ^TMP("DHCCKB","Factory","百济神州")=""
	s ^TMP("DHCCKB","Factory","上海复星医药（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","东阳光药业")=""
	s ^TMP("DHCCKB","Factory","四川科伦药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏豪森药业集团有限公司")=""
	s ^TMP("DHCCKB","Factory","上海医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","人福医药集团股份公司")=""
	s ^TMP("DHCCKB","Factory","海思科医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江海正药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","和记黄埔医药（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳信立泰药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","贝达药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华东医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","健康元药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天士力医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东罗欣药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州信诺维医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","四环医药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","上海现代制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州泽璟生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄以岭药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江华海药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东步长制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","福建广生堂药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广州白云山医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都倍特药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","迪哲（江苏）医药有限公司")=""
	s ^TMP("DHCCKB","Factory","广州必贝特医药技术有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄四药有限公司")=""
	s ^TMP("DHCCKB","Factory","瑞石生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江同源康医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","石家庄智康弘仁新药开发有限公司")=""
	s ^TMP("DHCCKB","Factory","杭州三因泰医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","上海拓臻生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","山东齐都药业有限公司")=""
	s ^TMP("DHCCKB","Factory","中国医药健康产业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏恩华药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","青峰医药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","乐普医疗")=""
	s ^TMP("DHCCKB","Factory","华润双鹤药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","基石药业")=""
	s ^TMP("DHCCKB","Factory","苏州开拓药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天津红日药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都康弘药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","成都苑东生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","中国科学院上海药物研究所")=""
	s ^TMP("DHCCKB","Factory","南京圣和药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华北制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","绿叶制药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","鲁南制药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","亿帆医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏艾迪药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东新华制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","南京健友生化制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","普洛药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东金城医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","常州千红生化制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","福安药业（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江康恩贝制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","华中药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","湖南景峰医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州亚盛药业有限公司")=""
	s ^TMP("DHCCKB","Factory","上海绿谷制药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京诺诚健华医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","再鼎医药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","瑞阳制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","歌礼生物科技（杭州）有限公司")=""
	s ^TMP("DHCCKB","Factory","北京福元医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江京新药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海同联制药有限公司")=""
	s ^TMP("DHCCKB","Factory","无锡合全药业有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏艾力斯生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京加科思新药研发有限公司")=""
	s ^TMP("DHCCKB","Factory","广州领晟医疗科技有限公司")=""
	s ^TMP("DHCCKB","Factory","华润三九医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东鲁抗医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","武汉恒信源药业有限公司")=""
	s ^TMP("DHCCKB","Factory","丹诺医药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","湖南华纳大药厂股份有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江新和成股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广东众生睿创生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳艾欣达伟医药科技有限公司")=""
	s ^TMP("DHCCKB","Factory","天津市医药集团有限公司")=""
	s ^TMP("DHCCKB","Factory","南昌弘益药业有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏亚盛医药开发有限公司")=""
	s ^TMP("DHCCKB","Factory","北京硕佰医药科技有限责任公司")=""
	s ^TMP("DHCCKB","Factory","杭州和正医药有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江劲方药业有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州韬略生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","再鼎医药（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","广州南鑫药业有限公司")=""
	s ^TMP("DHCCKB","Factory","天津天药药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","广东众生药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天津尚德药缘科技股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海复星医药（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏恒瑞医药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","信达生物制药（苏州）有限公司")=""
	s ^TMP("DHCCKB","Factory","百奥泰生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海君实生物医药科技股份有限公司")=""
	s ^TMP("DHCCKB","Factory","三生国健药业（上海）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","神州细胞工程有限公司")=""
	s ^TMP("DHCCKB","Factory","齐鲁制药有限公司")=""
	s ^TMP("DHCCKB","Factory","上海生物制品研究所有限责任公司")=""
	s ^TMP("DHCCKB","Factory","百济神州")=""
	s ^TMP("DHCCKB","Factory","丽珠医药集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","荣昌生物制药（烟台）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","天境生物科技（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","安徽安科生物工程（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳信立泰药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","舒泰神（北京）生物制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","康希诺生物股份公司")=""
	s ^TMP("DHCCKB","Factory","四川百利药业有限责任公司")=""
	s ^TMP("DHCCKB","Factory","鸿运华宁（杭州）生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","宜明昂科生物医药技术（上海）有限公司")=""
	s ^TMP("DHCCKB","Factory","成都康弘药业集团股份有限公司")=""
	s ^TMP("DHCCKB","Factory","武汉生物制品研究所有限责任公司")=""
	s ^TMP("DHCCKB","Factory","重庆智飞生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海泽生制药有限公司")=""
	s ^TMP("DHCCKB","Factory","勃林格殷格翰生物药业（中国）有限公司")=""
	s ^TMP("DHCCKB","Factory","苏州康宁杰瑞生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","基石药业")=""
	s ^TMP("DHCCKB","Factory","四川三叶草生物制药有限公司")=""
	s ^TMP("DHCCKB","Factory","石药控股集团有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏金迪克生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","康立泰药业有限公司")=""
	s ^TMP("DHCCKB","Factory","重庆智翔金泰生物制药有限公司")=""
	s ^TMP("DHCCKB","Factory","天台银康生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","海口奇力制药股份有限公司")=""
	s ^TMP("DHCCKB","Factory","四川科伦药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","长春高新技术产业（集团）股份有限公司")=""
	s ^TMP("DHCCKB","Factory","四川远大蜀阳药业有限责任公司")=""
	s ^TMP("DHCCKB","Factory","北京科兴生物制品有限公司")=""
	s ^TMP("DHCCKB","Factory","浙江海正药业股份有限公司")=""
	s ^TMP("DHCCKB","Factory","山东博安生物技术有限公司")=""
	s ^TMP("DHCCKB","Factory","厦门特宝生物工程股份有限公司")=""
	s ^TMP("DHCCKB","Factory","北京天坛生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","江苏荃信生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京天广实生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","深圳康泰生物制品股份有限公司")=""
	s ^TMP("DHCCKB","Factory","中山康方生物医药有限公司")=""
	s ^TMP("DHCCKB","Factory","北京绿竹生物技术股份有限公司")=""
	s ^TMP("DHCCKB","Factory","上海爱萨尔生物科技有限公司")=""
	s ^TMP("DHCCKB","Factory","上海细胞治疗集团有限公司")=""
	s ^TMP("DHCCKB","Factory","杭州翰思生物医药有限公司")=""
}

/// Description:	设置中药厂家集合排序
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).SetChinaFactory()
ClassMethod SetChinaFactory() As %String
{

	s ^TMP("DHCCKB","ChinaFactory","江苏康缘药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","扬子江药业集团有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","石家庄以岭药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","北京同仁堂股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","天士力医药集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","广州市香雪制药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","广州市康源药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","昆明邦宇制药有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","陕西省万寿制药有限责任公司")=""
	s ^TMP("DHCCKB","ChinaFactory","湖北济川药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","上海医药集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","华润三九医药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","深圳市海王生物工程股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","葵花药业集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","北京白花檵木生物科技有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","上海绿谷生命园医药有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","湖南新汇制药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","桂林三金药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","石家庄御和堂药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","漳州片仔癀药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","湖南景峰医药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","朗致集团双人药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","山西万辉制药有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","天津天中医药科技有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","山东沃华医药科技股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","安徽誉隆亚东药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","广州博济医药生物技术股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","安徽安科余良卿药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","金陵药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","江苏苏中药业集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","湖北惠海希康制药有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","河南省奥林特药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","广西邦琪药业集团有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","黑龙江省济仁药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","威海人生药业集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","江西京通美联药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","蓬莱金创药业有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","广州白云山医药集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","云南白药集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","上海延安药业（湖北）有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","江西心正药业有限责任公司")=""
	s ^TMP("DHCCKB","ChinaFactory","四川绵德堂制药有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","人福医药集团股份公司")=""
	s ^TMP("DHCCKB","ChinaFactory","仁和药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","昆明龙津药业股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","浙江康恩贝制药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","天圣制药集团股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","山东步长制药股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","重庆太极实业（集团）股份有限公司")=""
	s ^TMP("DHCCKB","ChinaFactory","江西杏林白马药业股份有限公司")=""
}

/// Description:	通过代码和描述,类型获取被哪些医院引用过
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-22
/// Input:			code,desc,parref
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).GetConstHosp("维莫非尼片240mg(Roche S.p.A.)","维莫非尼片240mg(Roche S.p.A.)",1)
ClassMethod GetConstHosp(code, desc, parref) As %String
{
	n (code,desc,parref)
	
	q:'$d(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(code))) ""
	
	s hospstr=""
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()
	s chinaData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s tmpHisCode=""
	f  s tmpHisCode=$o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(code),tmpHisCode))  q:tmpHisCode=""  d
	.s constId=""
	.f  s constId=$o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(code),tmpHisCode,constId))	q:constId=""  d
	..s conData = $g(^CKB.PDSS.ComContrastD(constId)) 
	..s hisCode = $lg(conData,4)
	..s type= $lg(conData,6)
	..q:(type'=drugData)&(type'=chinaData)
	..s hosp=""
	..f  s hosp=$o(^CKB.PDSS.ExtDictionI("Code",hosp))	q:hosp=""  d
	...i $d(^CKB.PDSS.ExtDictionI("Code",hosp,hisCode)) d
	....s hospDesc=$p(^CT("HOSP",+hosp),"^",2)
	....q:hospDesc=""
	....i hospstr="" d 
	.....s hospstr=hospDesc
	....e  d
	.....s hospstr=hospDesc_";"_hospstr
	
	q hospstr
}

/// Description:	读取文件,是否被标价
/// Creator:		QuNianpeng 
/// CreateDate:		2021-2-19
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUniqueDrug).UpdateUniqueData()
ClassMethod UpdateUniqueData() As %String
{

	s file=##class(%File).%New("D:\知识图谱\药品去重结果(all+带剂型通用名+等效单位)新.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0
	s Err=0
	while 'file.AtEnd
	{
		s line=file.Read()
		continue:line=""
		s dicId=$p(line,",",1)
		s dataType=$p(line,",",4)	// 西药字典/中成药字典
		continue:dicId=""
		s pid=10619805
		i $d(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",10619805,dicId)) d
		.s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,dicId)="Y"
		e  d
		.s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",pid,dicId)=""

	}
	
	d file.%Close()
	
	q ""
}

/// /w ##class(web.DHCCKBUniqueDrug).UpdateUniqueData11()
ClassMethod UpdateUniqueData11() As %String
{
	s id=""
	f  s id=$o(^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",10619805,id))  q:id=""  d
	.s ^TMP("DHCCKB","web.DHCCKBUniqueDrug","UniqueAllDrug",10619805,id)=""
}

}
