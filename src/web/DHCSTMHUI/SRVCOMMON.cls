Import SQLUser

Class web.DHCSTMHUI.SRVCOMMON Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// /取批次价格标志
ClassMethod GetSelBatRule(HospID As %String = "")
{
	n (HospID)
	s Param="^^^"_HospID
	s AppName=##class(web.DHCSTMHUI.Common.AppCommon).%GetParameter("AppName")
	s SelBatRule=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SelBatRule",Param)
	q SelBatRule
}

/// Descript：	取医嘱执行记录售价(批次价格使用,住院按执行取价格)
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Table：		DHC_OEDispensing,DHC_OEDispBatch
/// Input：		DspID-DHC_OEDispensing的ID
/// Output：	批次售价
/// Return：	批次售价
ClassMethod GetDspSp(DspID As %String) As %String
{
	n (DspID)
	q:DspID="" 0
	s dspBatSub="0",findflag=0,batsp=0
	f  s dspBatSub=$o(^DHCOEDISQTY(DspID,"I",dspBatSub)) q:(dspBatSub="")||(findflag=1)  d
	.q:'$D(^DHCOEDISQTY(DspID,"I",dspBatSub))
	.s batsp=+$p(^DHCOEDISQTY(DspID,"I",dspBatSub),"^",4)
	.s findflag=1
	q batsp
}

/// 价格方法移到此类中
/// Descript:	取当前售价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-18
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回售价(不带千分位)
ClassMethod GetCurSp(inclb, uomID, HospID) As %String
{
	n (inclb,uomID,HospID)
	q:inclb="" 0
	s dateh=+$h
	s timeh=$p($h,",",2)
	s RetSp=0
	s RetSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetSp(inclb,dateh,uomID,HospID,timeh)
	q RetSp
}

/// Descript:	取当前进价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-18
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回进价(不带千分位)
ClassMethod GetCurRp(inclb, uomID, HospID) As %String
{
	n (inclb,uomID,HospID)
	s dateh=+$h
	s timeh=$p($h,",",2)
	s RetRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb, uomID, HospID,timeh,dateh)
	q RetRp
}

/// Descript:	根据医嘱项RowID取库存项ID
/// Creater:	Zhouyg
/// CreateDate:	20130301
/// Input:		医嘱项RowID
/// Return：	库存项ID
/// w ##class(web.DHCSTMHUI.SRVCOMMON).GetInciID()
ClassMethod GetInciID(ArcID As %String) As %String
{
	N (ArcID)
	Q:ArcID="" ""
	s ArcIDM=$p(ArcID,"||",1)
	q:ArcIDM="" ""
	S IncID=$o(^INCI(0,"ARCIM_DR",ArcIDM,""))
	Q IncID
}

/// 根据医嘱记录取该医嘱使用的条码(仅对高值有意义)
/// Date:2015-12-10
/// Author:zhwh
/// Arguments:
///    oeori - RowId Of OE_OrdItem, RowId Of OE_OrdExec
/// Return:
///    条码串
ClassMethod GetBarcodeByOrd(oeori As %String) As %String
{
	n (oeori)
	S oeori=$P(oeori,"||",1,2)  //考虑到医嘱执行记录
	Q:oeori="" ""
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	q:(ord="")||(itm="") ""
	s BarCode=$p($G(^OEORD(ord,"I",itm,"DHC")),"^",14)
	q BarCode
}

/// Descript:	根据科室库存项ID取科室最后一个批次
/// Creater:	Zhouyg
/// CreateDate:	20141224
/// Input:		IncilDr-inc_itmloc
/// Return：	批次ID(INC_ItmLcBt的ID)
/// w ##class(web.DHCSTMHUI.SRVCOMMON).GetLastInclbByLoc()
ClassMethod GetLastInclbByLoc(IncilDr As %String) As %String
{
	N (IncilDr)
	Q:IncilDr="" ""
	s RetInclb=""
	
	s InciDr=$p(IncilDr,"||",1)
	s ILSub=$p(IncilDr,"||",2)
	q:(InciDr="")||(ILSub="") ""
	
	s ILBSub=""
	f  s ILBSub=$o(^INCI(InciDr,"IL",ILSub,"LB",ILBSub),-1) q:(ILBSub="")||(RetInclb'="")  d
	.q:+ILBSub'>0
	.s inclb=InciDr_"||"_ILSub_"||"_ILBSub
	.s active="Y"
	.s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	.i dhcinclb'="" d
	..s active=$p($g(^DHCINCLB(dhcinclb)),"^",2)
	.q:active'="Y"
	.s RetInclb=inclb
	
	i RetInclb="" d
	.s ILBSub=$o(^INCI(InciDr,"IL",ILSub,"LB",""),-1)
	.q:+ILBSub'>0
	.s RetInclb=InciDr_"||"_ILSub_"||"_ILBSub
	
	q RetInclb
}

}
