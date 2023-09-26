Class DHCLIS.DHCDataUtil Extends %RegisteredObject
{

/// 名称:     DHCLIS.DHCDataUtil
/// 描述:     导入检验医嘱
/// 编写者：  liuzf
/// 编写日期: 20160302
/// w ##Class(DHCLIS.DHCDataUtil).BTCostItem()
ClassMethod BTCostItem()
{
	s serviceGroupRowid="",serviceGroup="",ItemCatRowId="",itemCat="", EffDateTo=""
	s ARCIMSubscript=0 for  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=0 for  s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s ItemCatRowId=ARCIMSubscript_"||"_ARCIMVersion
	..s ARCRowid=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
	..s OrderType=""
	..i ARCRowid'="" s OrderType=$P(^ARC("IC",ARCRowid),"^",7)
	..Q:OrderType'="L"
	..s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
	..s desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    ..s orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,+$h,"","","","","","")
    ..s orderprice=$p(orderprice,"^",1)	
	..s objCostItem=##Class(dbo.BTCostItem).%New()
	..s objCostItem.Code=code
	..s objCostItem.CName=desc
	..s objCostItem.Price=+orderprice
	..s objCostItem.Active=1
	..s sc=objCostItem.%Save()
	..w !,sc_"^"_code_"^"_desc
	q 0
}

/// 名称:     DHCLIS.DHCDataUtil
/// 描述:     导入子类医嘱
/// 编写者：  liuzf
/// 编写日期: 20160302
/// w ##Class(DHCLIS.DHCDataUtil).BDBTCostItem(医嘱子类ID)
/// tARCIMItemCatDR: ^ARC("IC",tARCIMItemCatDR)  ///医嘱子类ID
ClassMethod BDBTCostItem(tARCIMItemCatDR, HospitalCode = "")
{
	s HospID=""
	I $l(HospitalCode) s HospID=$o(^CT("HOSP",0,"Code",$zcvt(HospitalCode,"U"),""))
	s tARCIMItemCatDR=$g(tARCIMItemCatDR)
	i '$l(tARCIMItemCatDR) q
	s serviceGroupRowid="",serviceGroup="",ItemCatRowId="",itemCat="", EffDateTo=""
	s ARCIMSubscript=0 for  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=0 for  s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s ItemCatRowId=ARCIMSubscript_"||"_ARCIMVersion
	..s ARCRowid=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
	..s OrderType="",ARCDesc=""
	..i ARCRowid'="" s OrderType=$P(^ARC("IC",ARCRowid),"^",7)
	..i ARCRowid'="" s ARCDesc=$P(^ARC("IC",ARCRowid),"^",2)
	..//Q:OrderType'="L"
	..s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)     ; 医嘱子分类
	..Q:ARCIMItemCatDR'=tARCIMItemCatDR
	..s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)
	..Q:($l(ARCIMEffDateTo)&&(ARCIMEffDateTo<$p($h,",",1)))
	..s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
	..s desc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    ..s orderprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ItemCatRowId,+$h,"","","","",HospID,"")
    ..s orderprice=$p(orderprice,"^",1)	
    ..s tCode=##Class(DHCLIS.DHCCommon).UPPER(code)
	..i $d(^dbo.BTCostItemI("IndexCode",##Class(LIS.Util.Common).IndexData(tCode))) d
	...s RowID=$O(^dbo.BTCostItemI("IndexCode",##Class(LIS.Util.Common).IndexData(tCode),""))
	...s objCostItem=##Class(dbo.BTCostItem).%OpenId(RowID)
	..e  d  
	...s objCostItem=##Class(dbo.BTCostItem).%New()
	..s objCostItem.Code=code
	..s objCostItem.CName=desc
	..s objCostItem.Price=+orderprice
	..s objCostItem.ItemType=ARCDesc
	..s objCostItem.Active=1
	..s sc=objCostItem.%Save()
	..i $SYSTEM.Status.IsOK(sc) d ..SysCostItemQuatityInfo(ARCIMSubscript, ARCIMVersion, objCostItem.RowID)
	..w !,sc_"^"_code_"^"_desc
	q 0
}

/// Creator：      baoguotao
/// CreatDate：    20150908
/// Description:： 查询血袋入库记录
/// Input：        
/// Output：       满足条件的血袋入库记录
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCDataUtil","QryHisBLDData","20150905","20150908","","","","","","","","","","","","","1^^1^^1")	
Query QryHisBLDData(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "ARCDesc,OrderType")
{
}

ClassMethod QryHisBLDDataExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0
    s ARCDesc="" f  s ARCDesc=$o(^ARC("IC",0,"Code",ARCDesc)) q:ARCDesc=""  d
    .s OrderType=$o(^ARC("IC",0,"Code",ARCDesc,""))
    .d OutPut   
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPut
	Set Data=$lb(ARCDesc,OrderType)
 	Set ColFields="ARCDesc,OrderType"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryHisBLDDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHisBLDDataExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHisBLDDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHisBLDDataExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 同步医嘱的收费项目的数量信息

ClassMethod SysCostItemQuatityInfo(ARCIMSubscript, ARCIMVersion, CostItemDR)
{
	s OLTTariffDR= ""
	i '$l(CostItemDR) q ""
	for {
	 s OLTTariffDR = $O(^DHCOLT(0,"ARTTA",ARCIMSubscript_"||"_ARCIMVersion,OLTTariffDR))
	 q:OLTTariffDR=""
	 s SttDate =""
	 for {
		 s SttDate = $o(^DHCOLT(0,"ARTTA",ARCIMSubscript_"||"_ARCIMVersion,OLTTariffDR,SttDate))
		 q:SttDate=""
		 s OLTRowId = $o(^DHCOLT(0,"ARTTA",ARCIMSubscript_"||"_ARCIMVersion,OLTTariffDR,SttDate,""))
	 	 s OLTData = $g(^DHCOLT(OLTRowId))
	 	 s EndDate = $p(OLTData,"^",5)
	 	 i $l(EndDate) continue
	 	 s ItemQuantity = $p(OLTData,"^",3)
	 	 //此医嘱的收费项目数据
	 	 //默认HospitalDR为1
	 	 s HospitalDR=1
	 	 i $d(^dbo.BTCostItemLinkI("IndexMaster",CostItemDR,HospitalDR,##Class(LIS.Util.Common).IndexData(OLTRowId))) {
		 	 s CostItemLinkRowID = $o(^dbo.BTCostItemLinkI("IndexMaster",CostItemDR,HospitalDR,##Class(LIS.Util.Common).IndexData(OLTRowId),""))
		 	 s CostItemLinkObj = ##Class(dbo.BTCostItemLink).%OpenId(CostItemLinkRowID)
	 	 } else {
		 	 s CostItemLinkObj = ##Class(dbo.BTCostItemLink).%New()
	 	 }
	 	 s CostItemLinkObj.CostItemDR = CostItemDR
	 	 s CostItemLinkObj.HISCostItemID = OLTRowId
	 	 s CostItemLinkObj.HISCostItemQuantity = ItemQuantity
	 	 s CostItemLinkObj.HospitalDR = HospitalDR
	 	 s CostItemLinkObj.IsDefalult = 1
	 	 s sc = CostItemLinkObj.%Save()
	 	 
	 	 w $SYSTEM.Status.GetErrorText(sc),!
	 	 i $l($SYSTEM.Status.GetErrorText(sc)) b
	 }
 
	}
	q ""
}

}
