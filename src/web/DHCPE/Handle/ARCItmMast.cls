/// Created by SongDeBo 2006/6/8
/// Description: 有关表ARC_ItmMast的一些基本处理,操作
Class web.DHCPE.Handle.ARCItmMast Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 计算医嘱(项目)的金额
/// ARCIMRowid == ARC_ItmMast.RowId
/// return: Price
/// test: w ##class(web.Handle.ARCItmMast).GetItmPrice("1||1")
ClassMethod GetItmPrice(ARCIMRowid, SttDate = "", PatType = "", InsType = "", PriorRowid = "", InstrRowid = "", LinkTo = "", OEPrice = "", AdmId = "", ItemFeeType = "", LocID = "")
{
	
	i SttDate="" s SttDate=+$H
 	//s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	
	//s retPrice=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMRowid,AdmId,0,ItemFeeType)
	s retPrice=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMRowid,AdmId,"",ItemFeeType,"",LocID)
	s retPrice=$p(retPrice,"^",1)
	q retPrice
}

}
