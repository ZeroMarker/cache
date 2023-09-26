/// Description:公共取医嘱信息类
/// Creator: 	wxj
/// CreateDate: 2022-10-13
Class web.DHCSTMHUI.Common.OrderInfo Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Description: 医嘱频次,标库默认PHCFR_Desc1
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriFreq("53||134")
ClassMethod OeoriFreq(Oeori As %String) As %String
{
	n (Oeori)
	s freqId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),2)),"^",4)
	q:freqId="" ""
	s PHCFR=^PHCFR(freqId)
	s freqCode=$P($g(PHCFR),"^",1)	 	// PHCFR_Code	
	s freqDesc2=$P($g(PHCFR),"^",4) 	// PHCFR_Desc2
	s freqDesc1=$P($g(PHCFR),"^",3)		// PHCFR_Desc1
	s freqWeek=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"DHC")),"^",55)
	i freqWeek'="" s freqDesc1=freqDesc1_"-"_$replace(freqWeek,"|","")
	q freqId_"^"_freqCode_"^"_freqDesc1_"^"_freqDesc1
}

/// Description: 医嘱用法
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriInstruc("53||134")
ClassMethod OeoriInstruc(Oeori As %String) As %String
{
	n (Oeori)
	s instrucId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),2)),"^",7)
	q:instrucId="" ""
	s instrucDesc=$p($g(^PHCIN(instrucId)),"^",2)
	q instrucId_"^"_instrucDesc
}

/// Description: 医嘱疗程
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriDuration("53||134")
ClassMethod OeoriDuration(Oeori As %String) As %String
{
	n (Oeori)
	s duratId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),2)),"^",6)
	q:duratId="" ""
	s durationDesc=$P($g(^PHCDU(duratId)),"^",1)
	q duratId_"^"_durationDesc
}

/// Description: 医嘱备注
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriRemark()
ClassMethod OeoriRemark(Oeori As %String) As %String
{
	n (Oeori)
	s ordId=+$p(Oeori,"||",1)
	s ordItm=+$p(Oeori,"||",2)
	s (num,memo)=""
	s num="0" f  s num=$o(^OEORD(ordId,"I",ordItm,"DEP",num)) q:num=""  d
	.s memo=memo_$g(^OEORD(ordId,"I",ordItm,"DEP",num))
	q memo
}

/// Description: 医嘱状态
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriStat("53||134")
ClassMethod OeoriStat(Oeori As %String) As %String
{
	n (Oeori)
	s oeStateId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)),"^",13)
	q:oeStateId="" ""
	s oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
	s oeStateDesc=$P($g(^OEC("OSTAT",+oeStateId)),"^",2)
	q oeStateCode_"^"_oeStateDesc
}

/// Description: 医嘱剂量
/// Input:		 Oeori(医嘱id)
/// Debug:		 w ##class(web.DHCSTMHUI.Common.OrderInfo).OeoriDosage("53||134")
ClassMethod OeoriDosage(Oeori As %String) As %String
{
	n (Oeori)
	s ordId=+Oeori
	s ordItm=+$p(Oeori,"||",2)
	s doseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(Oeori)
	S doseUom=$P($g(^OEORD(ordId,"I",ordItm,2)),"^",3)
	q:(doseQty="") ""
	s doseUomDesc=$P($g(^CT("UOM",+doseUom)),"^",2)
	i doseQty["-" s doseQty="("_doseQty_")"
	q doseQty_doseUomDesc
}

}
