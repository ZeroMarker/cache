/// Import SQLUser
/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		导出his医嘱项默认的用法、频次等信息类
Class web.DHCCKBQueryHisOrderDetail Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		调用医生站的方法,获取开医嘱的医嘱信息
/// w ##Class(websys.Query).ToExcel("CKB_Excel001","web.DHCCKBQueryHisOrderDetail","QueryOrderDetail")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBQueryHisOrderDetail","QueryOrderDetail")
Query QueryOrderDetail() As websys.Query(ROWSPEC = "类型:%String,就诊号:%String,年龄:%String,性别:%String,患者过敏信息:%String,体重:%String,身高:%String,诊断:%String,特殊人群:%String,处方号:%String,处方上药品数量:%String,药学名称:%String,药品剂型:%String,规格:%String,最小包装:%String,发药数量:%String,单次剂量:%String,剂量单位:%String,频次:%String,服药途径:%String,疗程:%String,关联医嘱组号:%String,开方时间:%String,医嘱备注:%String")
{
}

ClassMethod QueryOrderDetailExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)
		
	Set ind=1
	s sub = 0
	f  s sub = $o(^ARCIM(sub)) q:sub=""  d
	.s ver = 0
	.f  s ver = $o(^ARCIM(sub,ver))  q:ver=""   d
	..s arciRowId = sub_"||"_ver
	..s fromDate = $p(^ARCIM(sub,ver,1),"^",13)
	..s fromDate = $p(fromDate,"Z",1)
	..s toDate = $p(^ARCIM(sub,ver,7),"^",1)
	..q:((toDate'="")&(toDate<+$h))||(fromDate>+$h)	
	..s itemCatDr="",orderType=""
	..i +sub'=0 s itemCatDr=$P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	..s orderType=""
	..i itemCatDr'="" s orderType=$P(^ARC("IC",itemCatDr),"^",7) 
	..q:orderType'="R"	
	..s arciCode = $p(^ARCIM(sub,ver,1),"^",1)
	..s arciDesc = $p(^ARCIM(sub,ver,1),"^",2)
	..// EpisodeID:就诊ID   InsType:费别,住院病人可以为空  OrderDepRowid:下医嘱科室  ArcimRowid:医嘱项RowId
	..s arciDetail = ##class(web.DHCDocOrderCommon).GetEPARCIMDetail(1,"","",arciRowId,"","10209^29^95^2")   
	..// "维生素C片[0.1g*100]^R^1^684||1^684^1^全自费
	..// ^2.9000"_$c(1)_"0.0000"_$c(1)_"0.0000"_$c(1)_"2.9000
	..// ^"_$c(1)_"瓶(100)"_$c(1)_"18^244"_$c(1)_"急诊药房"_$c(1)_"Y"_$c(1)_"3"_$c(2)_"246"_$c(1)_"住院药房"_$c(1)_"Y"_$c(1)_"^注射器"_$c(1)_"684||1"_$c(1)_"100"_$c(1,1)_"
	..// ^0.1"_$c(1)_"g"_$c(1)_"66"_$c(2)_"1"_$c(1)_"片"_$c(1)_"2^Tid"_ $c(1)_"28"_$c(1)_"3"_$c(1,1)_"N^口服"_$c(1)_"12^1天"_$c(1)_"1"_$c(1)_"1^临时医嘱"_$c(1)_"3"_$c(1,1)_"^测试"_$c(1,1,1,1)_"
	..// ^1^"_$c(1,1)_"Y^N"_$c(1)_"0"_$c(1,1)_"N"_$c(1)_"N"_$c(1,1)_"
	..// ^"_$c(1)_"1"_$c(1,3,1)_"0"_$c(1,1,1)_"0"_$c(2)_"^0"_$c(1)_"0"_$c(1,1,1,1,1,1,1)_"N"_$c(1)_"N"_$c(1,1,1)_"N^^^^^
	..// 0"_$c(1)_"维生素C片"_$c(1,1)_"0"_$c(1)_"XKF000526"_$c(1)_"1"_$c(1)_"0"_$c(2,2,1)_"Y"_$c(1)_"0"_$c(1,1)_"0"_$c(2,1,1,1,1,1,1,1)_"0"_$c(1)_"N"_$c(1)_"Y"_$c(1)_"0"_$c(1)_"N"_$c(1,1)_"N^0.1"_$c(1)_"g"_$c(1)_"66"
	..s arciDesc = $p(arciDetail,"^",1)	// 医嘱名称
	..s arciId = $p(arciDetail,"^",4)		// 医嘱项id
	..s packqtyStr =$p(arciDetail,"^",9)	// 包装及发药信息
	..s formStr = $p(arciDetail,"^",11)
	..s doseStr = $p(arciDetail,"^",12)	// 剂量相关串 0.1"_$c(1)_"g"_$c(1)_"66"_$c(2)_"1"_$c(1)_"片"_$c(1)_"2
	..s freqStr = $p(arciDetail,"^",13)   // 频次相关串 Tid"_ $c(1)_"28"_$c(1)_"3"_$c(1,1)_"N
	..s instrStr = $p(arciDetail,"^",14) //  用法相关串 口服"_$c(1)_"12
	..s durationStr =  $p(arciDetail,"^",15) // 疗程相关串 1天"_$c(1)_"1"_$c(1)_"1
	..
	..s orderForm = $p(formStr,$c(1),1)	// 剂型
	..s orderQty = $p(doseStr,$c(1),1)	// 单次剂量
	..s orderQtyUnit = $p(doseStr,$c(1),2) // 单次剂量单位
	..s orderPackqty = $p(packqtyStr,$c(1),2)	// 包装单位
	..s orderFreq = $p(freqStr,$c(1),1)	// 频次
	..s orderInstr = $p(instrStr,$c(1),1)	// 给药途径(用法)
	..s orderDrua = $p(durationStr,$c(1),1)	// 疗程
	..s orderData = $lb("",ind,"","","","","","","",ind,1)	//类型1	就诊号2	年龄3	性别4	患者过敏信息5	体重6	身高7	诊断8	特殊人群9	处方号10	处方上药品数量11
	..s $list(orderData,12)=arciDesc  // 药学名称
	..s $list(orderData,13)=orderForm // 药品剂型
	..s $list(orderData,14)=..GetSpec(arciRowId)	// 规格
	..s $list(orderData,15)=orderPackqty	// 最小包装
	..s $list(orderData,16)=""	// 发药数量
	..s $list(orderData,17)=orderQty	//单次剂量
	..s $list(orderData,18)=orderQtyUnit	// 剂量单位
	..s $list(orderData,19)=orderFreq	// 频次
	..s $list(orderData,20)=orderInstr	// 服药途径
	..s $list(orderData,21)=orderDrua	// 疗程
	..s $list(orderData,22)=1	// 关联医嘱组号
	..s $list(orderData,23)=$zd(+$h,3) // 开方时间
	..s $list(orderData,24)=""	// 医嘱备注	
	..set ^CacheTemp(repid,ind)=orderData
	..set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		获取规格
///  W ##Class(web.DHCCKBQueryHisOrderDetail).GetSpec()
ClassMethod GetSpec(arciRowId As %String) As %String
{
	n (arciRowId)
	q:arciRowId="" ""
    s inci=$o(^INCI(0,"ARCIM_DR",+arciRowId,""))
	q:$g(inci)="" ""
	s spec=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	Q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	Q spec
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		导出his中常用用法维护和医嘱套维护中的医嘱信息
/// w ##Class(websys.Query).ToExcel("CKB_Excel0001","web.DHCCKBQueryHisOrderDetail","QueryHisOrderSet")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBQueryHisOrderDetail","QueryHisOrderSet")
Query QueryHisOrderSet() As websys.Query(ROWSPEC = "类型:%String,就诊号:%String,年龄:%String,性别:%String,患者过敏信息:%String,体重:%String,身高:%String,诊断:%String,特殊人群:%String,处方号:%String,处方上药品数量:%String,药学名称:%String,药品剂型:%String,规格:%String,最小包装:%String,发药数量:%String,单次剂量:%String,剂量单位:%String,频次:%String,服药途径:%String,疗程:%String,关联医嘱组号:%String,开方时间:%String,医嘱备注:%String")
{
}

ClassMethod QueryHisOrderSetExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)		
	Set ind=1

	k TmpArr
	d ..QueryDocItmDefault(.TmpArr)	// DHC_Doc_ItemDefault 常用用法表 
	d ..QueryOrdSetsItem(.TmpArr)	// 医嘱套
	s index=""
	f  s index = $o(TmpArr("order",index)) q:index=""  d
	.s orderData = $g(TmpArr("order",index))
	.set ^CacheTemp(repid,ind)=orderData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		遍历DHC_Doc_ItemDefault 常用用法表 
///  W ##Class(web.DHCCKBQueryHisOrderDetail).QueryDocItmDefault()
ClassMethod QueryDocItmDefault(TmpArr As %String) As %String
{
	//^DHCDID(0,"ARCIM",{DID_ARCIM_DR},{DID_Rowid})
	
	n (TmpArr)
	
	s count = +$g(TmpArr("count"))
	s itmId=""
	f  s itmId=$o(^DHCDID(0,"ARCIM",itmId))  q:itmId=""  d
	.s sub = $p(itmId,"||",1)
	.s ver = $p(itmId,"||",2)
	.q:'$d(^ARCIM(sub,ver))
	.s itmCode = $p(^ARCIM(sub,ver,1),"^",1)
	.s itmDesc = $p(^ARCIM(sub,ver,1),"^",2)
	.s itemCatDr = "",orderType = ""
	.i +sub'=0 s itemCatDr = $P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	.s orderType = ""
	.i itemCatDr'="" s orderType = $P(^ARC("IC",itemCatDr),"^",7) 
	.q:orderType'="R"	// 只保留药品
	.s defaultId = ""
	.f  s defaultId=$o(^DHCDID(0,"ARCIM",itmId,defaultId))  q:defaultId=""  d
	..s dose = 	$p($g(^DHCDID(+defaultId)),"^",6) // 剂量
	..s doseUnit = 	$p($g(^DHCDID(+defaultId)),"^",7)	// 剂量单位
	..s doseUnit = $p($g(^CT("UOM",+doseUnit)),"^",2)
	..s instr = $p($g(^DHCDID(+defaultId)),"^",8)	// 用法
	..s instr = $p($g(^PHCIN(+instr)),"^",2)
	..s freq = $p($g(^DHCDID(+defaultId)),"^",9)	// 频率
	..s freq = $p($g(^PHCFR(+freq)),"^",3)			
	..s durat = $p($g(^DHCDID(+defaultId)),"^",10)	// 疗程
	..s durat = $p($g(^PHCDU(+durat)),"^",3)
	..s packQty = $p($g(^DHCDID(+defaultId)),"^",11)	// 包装数量
	..s billUOMRowid=$p($g(^ARCIM(+itmId,$p(itmId,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	..s billUomDesc =..GetUOMDesc(billUOMRowid)			// 包装单位
	..s admType =$p($g(^DHCDID(+defaultId)),"^",23)	// 类型
	..s admType = $select(admType="O":"门诊",admType="E":"急诊",admType="I":"住院",1:"")
	..s dataList = $lb(admType,count,"","","","","","","",count,1)	//类型1	就诊号2	年龄3	性别4	患者过敏信息5	体重6	身高7	诊断8	特殊人群9	处方号10	处方上药品数量11
	..s $list(dataList,12)=itmDesc  // 药学名称
	..s $list(dataList,13)=..GetDrugForm(itmId) // 药品剂型
	..s $list(dataList,14)=..GetSpec(itmId)	// 规格
	..s $list(dataList,15)=billUomDesc	// 最小包装
	..s $list(dataList,16)=packQty	// 发药数量
	..s $list(dataList,17)=dose	//单次剂量
	..s $list(dataList,18)=doseUnit	// 剂量单位
	..s $list(dataList,19)=freq	// 频次
	..s $list(dataList,20)=instr	// 服药途径
	..s $list(dataList,21)=durat	// 疗程
	..s $list(dataList,22)=1	// 关联医嘱组号
	..s $list(dataList,23)=$zd(+$h,3) // 开方时间
	..s $list(dataList,24)=""	// 医嘱备注	
	..s count = count +1
	..s TmpArr("order",count)=dataList
	
	s TmpArr("count")=count
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		单位描述
///  W ##Class(web.DHCCKBQueryHisOrderDetail).QueryDocItmDefault()
ClassMethod GetUOMDesc(UOMRowid As %String, UserLanguage As %String = "") As %String
{
	Q:UOMRowid="" ""
	if UserLanguage="EN" {
		Q $P($g(^CT("UOM",UOMRowid)),"^",3)
	}else{
		Q $P($g(^CT("UOM",UOMRowid)),"^",2)
	}
}

/// Creator:    	qunianpeng
/// CreateDate: 	2020-11-05
/// Descript:   	剂型
/// InPut:      	
/// OutPut:     	
/// w ##Class(web.DHCCKBHisBusiExp).GetDrugForm("")
ClassMethod GetDrugForm(itmmastid As %String) As %String
{
	n (itmmastid)
	s InciDr=$o(^INCI(0,"ARCIM_DR",+itmmastid,""))
	Q:InciDr="" ""
    s FormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)
    Q $p(FormStr,"^",2)
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		遍历 ARC_OrdSets ARC_OrdSetDate ARC_OrdSetDateItem  医嘱套/医嘱套明细表
///  W ##Class(web.DHCCKBQueryHisOrderDetail).QueryDocItmDefault()
ClassMethod QueryOrdSetsItem(TmpArr As %String) As %String
{
	
	n (TmpArr)
	
	//^ARCOS({ARCOS_RowId})
	s count = $g(TmpArr("count"))
	s ordSetId=""
	f  s ordSetId=$o(^ARCOS(ordSetId))  q:ordSetId=""  d
	.q:+ordSetId=0
	.s setDateSub=""	// ARC_OrdSetDate
	.f  s setDateSub=$o(^ARCOS(ordSetId,"DATE",setDateSub))  q:setDateSub=""  d
	..q:+setDateSub=0
	..s setItmSub=""
	..f  s setItmSub=$o(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub))  q:setItmSub=""  d
	...q:+setItmSub=0
	...s itmId = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",1)	// 医嘱项
	...s sub = $p(itmId,"||",1)	
	...s ver = $p(itmId,"||",2)
	...q:(+sub=0)||(+ver=0)
	...q:'$d(^ARCIM(sub,ver))
	...s itmCode = $p(^ARCIM(sub,ver,1),"^",1)
	...s itmDesc = $p(^ARCIM(sub,ver,1),"^",2)
	...s itemCatDr = "",orderType = ""
	...i +sub'=0 s itemCatDr = $P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	...s orderType = ""
	...i itemCatDr'="" s orderType = $P(^ARC("IC",itemCatDr),"^",7) 
	...q:orderType'="R"	// 只保留药品
	...
	...s dose = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",13) // 剂量
	...s doseUnit = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",10)	// 剂量单位
	...s doseUnit = $p($g(^CT("UOM",+doseUnit)),"^",2)
	...s instr = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",9)	// 用法
	...s instr = $p($g(^PHCIN(+instr)),"^",2)
	...s freq = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",8)	// 频率
	...s freq = $p($g(^PHCFR(+freq)),"^",3)			
	...s durat = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",7)	// 疗程
	...s durat = $p($g(^PHCDU(+durat)),"^",3)
	...s packQty = $p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",2)	// 包装数量
	...s packQtyUnit =$p(^ARCOS(ordSetId,"DATE",setDateSub,"ITM",setItmSub),"^",23)		// 包装单位
	...s packQtyUnit = $P($g(^CT("UOM",+packQtyUnit)),"^",2)
	...s admType =""	// 类型
	...//s admType = $select(admType="O":"门诊",admType="E":"急诊",admType="I":"住院",1:"")
	...s dataList = $lb(admType,count,"","","","","","","",count,1)	//类型1	就诊号2	年龄3	性别4	患者过敏信息5	体重6	身高7	诊断8	特殊人群9	处方号10	处方上药品数量11
	...s $list(dataList,12)=itmDesc  // 药学名称
	...s $list(dataList,13)=..GetDrugForm(itmId) // 药品剂型
	...s $list(dataList,14)=..GetSpec(itmId)	// 规格
	...s $list(dataList,15)=packQtyUnit	// 最小包装
	...s $list(dataList,16)=packQty	// 发药数量
	...s $list(dataList,17)=dose	//单次剂量
	...s $list(dataList,18)=doseUnit	// 剂量单位
	...s $list(dataList,19)=freq	// 频次
	...s $list(dataList,20)=instr	// 服药途径
	...s $list(dataList,21)=durat	// 疗程
	...s $list(dataList,22)=1	// 关联医嘱组号
	...s $list(dataList,23)=$zd(+$h,3) // 开方时间
	...s $list(dataList,24)=""	// 医嘱备注	
	...s count = count +1
	...s TmpArr("order",count)=dataList
	
	s TmpArr("count")=count
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		遍历his中的高危药品,并同步到知识库中
///  W ##Class(web.DHCCKBQueryHisOrderDetail).QueryHighDangerDrugByDrgFrom()
ClassMethod QueryHighDangerDrugByDrgFrom(TmpArr) As %String
{
	n (TmpArr)
	// ^ARCIM(0,"PHCDF",{ARCIM_PHCDF_DR},{ARCIM_Subscript},{ARCIM_Version})
	
	//^PHCD({PHCD_RowId})	//PHCDrgMast
	
	k TmpArr
	s count = 0,err = 0
	Ts
	s drgMastId = ""
	f  s drgMastId = $o(^PHCD(drgMastId))	q:(drgMastId="")||(err'=0)  d
	.q:drgMastId=0
	.s phcdfSub = ""
	.f  s phcdfSub = $o(^PHCD(drgMastId,"DF",phcdfSub))	q:(phcdfSub="")||(err'=0)  d
	..q:phcdfSub=0
	..s phcdfDr = drgMastId_"||"_phcdfSub
	..q:'$d(^ARCIM(0,"PHCDF",phcdfDr))	// 不存在医嘱项
	..s sub = ""
	..f  s sub =$o(^ARCIM(sub))	q:sub=""  d
	...q:sub=0
	...s ver=""
	...f  s ver = $o(^ARCIM(sub,ver)) q:ver=""  d
	....s ver = ""
	....q:ver=0
	....s highFlag = ##class(web.DHCSTINTERFACE).GetCriticalFlag(phcdfDr)
	....q:highFlag'="Y"
	....
	....s itmCode = $p(^ARCIM(sub,ver,1),"^",1)
	....s itmDesc = $p(^ARCIM(sub,ver,1),"^",2)
	....q:itmCode=""
	....s libID = ..GetLibIDByConst(itmCode)
	....s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),2)
	....s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),3)
	....s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),4)
	....s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	....s count = count + 1
	....s TmpArr(count)=$lb(itmCode,itmDesc,libID,libCode,libDesc,parrefDesc,"")
	....s err=0 

	i err'=0 tro
	Q:err'=0 err
		
	TC
	Q err
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		遍历his中的高危药品,并同步到知识库中
///  W ##Class(web.DHCCKBQueryHisOrderDetail).QueryDocItmDefault()
ClassMethod QueryHighDangerDrug(TmpArr) As %String
{
	n (TmpArr)
	// ^ARCIM(0,"PHCDF",{ARCIM_PHCDF_DR},{ARCIM_Subscript},{ARCIM_Version})
	
	//^PHCD({PHCD_RowId})	//PHCDrgMast
	/*
	s drgMastId = ""
	f  s drgMastId = $o(^PHCD(drgMastId))	q:drgMastId=""  d
	.q:drgMastId=0
	.s phcdfSub = ""
	.f  s phcdfSub = $o(^PHCD(drgMastId,"DF",phcdfSub))	q:phcdfSub=""  d
	..q:phcdfSub=0
	..s phcdfDr = drgMastId_"||"_phcdfSub
	..q:'$d(^ARCIM(0,"PHCDF",phcdfDr))	// 不存在医嘱项
	..s sub = ""
	..f  s sub =$o(^ARCIM(sub))	q:sub=""  d
	...q:sub=0
	...s ver=""
	...f  s ver = $o(^ARCIM(sub,ver)) q:ver=""  d
	....s ver = ""
	....
	*/
	k TmpArr
	Ts
	
	s count = 0,err = 0
	s sub = ""
	f  s sub =$o(^ARCIM(sub))	q:(sub="")||(err'=0)  d
	.q:sub=0
	.s ver=""
	.f  s ver = $o(^ARCIM(sub,ver)) q:(ver="")||(err'=0)  d
	..s ver = 0
	..q:'$d(^ARCIM(sub,ver))
	..s itemCatDr = "",orderType = ""
	..i +sub'=0 s itemCatDr = $P(^ARCIM(+sub,ver,1),"^",10)  //ARC_ItemCat
	..s orderType = ""
	..i itemCatDr'="" s orderType = $P(^ARC("IC",itemCatDr),"^",7) 
	..q:orderType'="R"	// 只保留药品
	..s stopDate =$p($g(^ARCIM(sub,ver,7)),"^",1)
	..q:(stopDate'="")&(stopDate<+$h)
	..	
	..s phcdfDr=$p($g(^ARCIM(sub,ver,1)),"^",12)
	..q:'$d(^ARCIM(0,"PHCDF",phcdfDr))	// 不存在医嘱项
	..s highFlag = ##class(web.DHCSTINTERFACE).GetCriticalFlag(phcdfDr)
	..q:highFlag'="Y"
	..
	..s itmCode = $p(^ARCIM(sub,ver,1),"^",1)
	..s itmDesc = $p(^ARCIM(sub,ver,1),"^",2)
	..q:itmCode=""
	..s libID = ..GetLibIDByConst(itmCode)
	..s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),2)
	..s libDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),3)
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libID)),4)
	..s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	..i parref = ##class(web.DHCCKBCommon).GetDrugData() d	// 西药
	...s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("HighDangerFlag",##class(web.DHCCKBCommon).GetDrugProp())
	..i parref = ##class(web.DHCCKBCommon).GetChineseDrugData() d // 中成药
	...s propId = ..GetHighDangerLinkProp()
	..s value = ##class(web.DHCCKBCommon).GetDicIdByCode("Y",##class(web.DHCCKBCommon).GetTipsData())
	..s count = count + 1
	..s TmpArr(count)=$lb(itmCode,itmDesc,libID,libCode,libDesc,parrefDesc)
	..q:(+libID="")||(+propId=0)||(+value=0)
	..s listData = ""_"^"_libID_"^"_propId_"^"_value_"^"_""_"^"_""_"^"_""
	..s err=0 //##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"")	// 保存
	..
	..

	i err'=0 tro
	Q:err'=0 err
		
	TC
	Q err
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		通过对照找到知识库的id
/// W ##Class(web.DHCCKBQueryHisOrderDetail).GetLibIDByConst()
ClassMethod GetLibIDByConst(hisCode) As %String
{
	n (hisCode)
	
	s libID=""
	s constID=""
	f  s constID=$o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),constID))  q:constID=""  d
	.q:'$d(^CKB.PDSS.ComContrastD(+constID))
	.s hospDesc = "哈尔滨医科大学第一附属医院"
	.s hosp=94 //$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospDesc),""))
	.q:'$d(^CKB.PDSS.ExtDictionI("Code",+hosp,hisCode))	// 过滤医院
	.s listData =$g(^CKB.PDSS.ComContrastD(constID))
	.s libCode = $lg(listData,2)
	.s libDesc = $lg(listData,3)
	.s type = $lg(listData,6)	// 西药和中成药字典
	.q:(type'=##class(web.DHCCKBCommon).GetDrugData())&(type'=##class(web.DHCCKBCommon).GetChineseDrugData())
	.s libID = ##class(web.DHCCKBCommon).GetDicIdByCode(libCode,type)
	
	q libID
}

/// Description:	导出高危药品列表
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-16
/// return:			
/// other:	 $lb(itmCode,itmDesc,libID,libCode,libDesc,parrefDesc)		
/// d ##class(%ResultSet).RunQuery("web.DHCCKBQueryHisOrderDetail","ExportHighDrugList")
/// w ##Class(websys.Query).ToExcel("CKB_Excel高危药品列表","web.DHCCKBQueryHisOrderDetail","ExportHighDrugList")
Query ExportHighDrugList() As websys.Query(ROWSPEC = "hisCode:%String:his药品代码,hisDrug:%String:his药品名称,libID:%String:知识库药品id,libCode:%String:知识库药品代码,libDesc:%String:知识库药品名称,parrefDesc:%String:字典,hosp:%String:医院")
{
}

ClassMethod ExportHighDrugListExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1

	k TmpArr
	d ..QueryHighDangerDrug(.TmpArr)
	
	set index = "",num=0
	for  set index = $o(TmpArr(index))  Q:index=""  d
	.set num=num+1
	.set drugInfo = $g(TmpArr(index))
	.set ^CacheTemp(repid,ind) = drugInfo
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-05
/// Descript: 		通过对照找到知识库的id
/// W ##Class(web.DHCCKBQueryHisOrderDetail).GetLibIDByConst()
ClassMethod GetHighDangerLinkProp() As %String
{
	s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("HighDangerFlag",##class(web.DHCCKBCommon).GetDrugProp())

	s ret = 0
	s id = ""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Link",propId,id)) q:id=""  d
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.q:parref'=##class(web.DHCCKBCommon).GetChineseDrugProp()
	.s ret = id 
	
	q ret
}

/// CreateDate: 	2020-11-05
/// Descript: 		设置高危药品标记
/// W ##Class(web.DHCCKBQueryHisOrderDetail).SetHighDangerFlag("D:\WuhanPresc05.txt")
ClassMethod SetHighDangerFlagText(filepath) As %String
{

	n (filepath)
		
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	Ts
	s hCount=0
	s end=0,err=0
	d $ZU(68,40,1)
	f  d  q:(end'=0)||(err'=0)
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s impDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.s impDataList=$tr(impDataList,$c(10),"")
	.s impDataList=$tr(impDataList,$c(10,13),"")
	.s impDataList=$tr(impDataList,$c(13),"")
	.s impDataList=$tr(impDataList," ","")
	.s impDataList=$tr(impDataList,"""","")
	.q:hCount=1 
	.s libID = $p(impDataList,"^",3) // 知识库id
	.q:libID=""
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(libID))
	.s parref=$p(impDataList,"^",6)	// 字典
	.s:parref'="" parref = ##class(web.DHCCKBCommon).GetDicIdByCode(parref)	
	.s propId=""
	.i parref = ##class(web.DHCCKBCommon).GetDrugData() d	// 西药
	..s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("HighDangerFlag",##class(web.DHCCKBCommon).GetDrugProp())
	.i parref = ##class(web.DHCCKBCommon).GetChineseDrugData() d // 中成药
	..s propId = ..GetHighDangerLinkProp()
	.
	.s value = ##class(web.DHCCKBCommon).GetDicIdByCode("Y",##class(web.DHCCKBCommon).GetTipsData())
	.q:(+libID="")||(+propId=0)||(+value=0)
	.s listData = ""_"^"_libID_"^"_propId_"^"_value_"^"_""_"^"_""_"^"_""
	.s err=##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"")	// 保存
	
	c filepath 
	
	i err'=0 tro
	Q:err'=0 err
		
	TC
	Q err
}

/// CreateDate: 	2020-11-05
/// Descript: 		设置高危药品标记
/// W ##Class(web.DHCCKBQueryHisOrderDetail).SetHighDangerFlagExcel()
ClassMethod SetHighDangerFlagExcel() As %String
{
	k ^Tmp("DHCCKB","web.DHCCKBQueryHisOrderDetail","SetHighDangerFlagExcel")
	TSTART

	s file=##class(%File).%New("C:\Users\Administrator\Desktop\新知识库\CKB_Excel高危药品列表.csv")
	d file.Open("RS")
	d file.ReadLine() //读取一行
	s count=0,h=0
	s err=0

	while 'file.AtEnd
	{
		s line=file.Read()
		continue:line=""
		s libID=$p(line,",",3)
		s hisCode=$p(line,",",1)
		s hisDesc=$p(line,",",2)
		s h = h +1
		s ^Tmp("DHCCKB","web.DHCCKBQueryHisOrderDetail","SetHighDangerFlagExcel",h)=$lb(hisCode,hisDesc)
		continue:libID=""
		q:'$d(^CT.CKB.PDSS.CommonDictionD(libID))
		s parref=$p(line,",",6)	// 字典
		s:parref'="" parref = ##class(web.DHCCKBCommon).GetDicIdByDesc($p(line,",",6))	
		s propId=""
		i parref = ##class(web.DHCCKBCommon).GetDrugData() d	// 西药
		.s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("HighDangerFlag",##class(web.DHCCKBCommon).GetDrugProp())
		i parref = ##class(web.DHCCKBCommon).GetChineseDrugData() d // 中成药
		.s propId = ..GetHighDangerLinkProp()		
		continue:$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libID,+propId))	// 已存在
		s value = ##class(web.DHCCKBCommon).GetDicIdByCode("Y",##class(web.DHCCKBCommon).GetTipsData())
		q:(+propId=0)||(+value=0)	
		s listData = ""_"^"_libID_"^"_propId_"^"_value_"^"_""_"^"_""_"^"_""
		s err=##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(listData,"")	// 保存
		s count = count + 1
	}  
	
	i err=0 tc
	i err'=0 tro

	i err=0  d
	.w ##Class(websys.Query).ToExcel("CKB_Excel高危药品失败列表"_+$h,"web.DHCCKBQueryHisOrderDetail","ExportErrHighDrug")
	.s err = count	// 成功数量
		
	q count
}

/// Description:	导出未能成功添加高危标志的药品
/// Creator:		QuNianpeng
/// CreateDate:		2020-11-16
/// return:			
/// other:	 $lb(itmCode,itmDesc,libID,libCode,libDesc,parrefDesc)		
/// d ##class(%ResultSet).RunQuery("web.DHCCKBQueryHisOrderDetail","ExportErrHighDrug")
/// w ##Class(websys.Query).ToExcel("CKB_Excel高危药品列表","web.DHCCKBQueryHisOrderDetail","ExportErrHighDrug")
Query ExportErrHighDrug() As websys.Query(ROWSPEC = "hisCode:%String:his药品代码,hisDrug:%String:his药品名称")
{
}

ClassMethod ExportErrHighDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1

	set index = "",num=0
	for  set index = $o(^Tmp("DHCCKB","web.DHCCKBQueryHisOrderDetail","SetHighDangerFlagExcel",index))  Q:index=""  d
	.set num=num+1
	.set drugInfo = $g(TmpArr(index))
	.set ^CacheTemp(repid,ind) = drugInfo
	.set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
