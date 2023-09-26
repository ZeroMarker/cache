/// 挂号相关统计
Class web.DHCFAPPOINT Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 根据日期查找科室挂号收入
ClassMethod GetLocByDate(FromDate, StopDate As %String)
{
	q:FromDate=""
	q:StopDate=""
	s del="^"
	k ^FHQTEMP($J)
	s FromDate=$zdh(FromDate,3)-1,StopDate=$zdh(StopDate,3)
	f  s FromDate=$o(^User.DHCRegistrationFeeI("IndexDateDepDoc",FromDate)) q:((FromDate="")!(FromDate>StopDate))  d
	.s LocDr=0
	.f  s LocDr=$o(^User.DHCRegistrationFeeI("IndexDateDepDoc",FromDate,LocDr)) q:(LocDr="")  d
	..s DocDr=""
	..s TmpLoc=$tr(LocDr," ","")
	..S LocDesc=$p(^CTLOC(TmpLoc),del,2)
	..if '$d(^FHQTEMP($J,LocDesc)) s ^FHQTEMP($J,LocDesc)="0^"_"0^"_"0^"
	..f  s DocDr=$o(^User.DHCRegistrationFeeI("IndexDateDepDoc",FromDate,LocDr,DocDr)) q:(DocDr="")  d
	...s RegId=""
	...f  s RegId=$o(^User.DHCRegistrationFeeI("IndexDateDepDoc",FromDate,LocDr,DocDr,RegId)) q:(RegId="")  d
	....s AdmId=$li(^User.DHCRegistrationFeeD(RegId),2)
	....s InvId=$li(^User.DHCRegistrationFeeD(RegId),11)
	....q:AdmId=""
	....q:InvId=""
	....s AdmStatus=$p(^PAADM(AdmId),del,20)
	....;W RegId_"^"
	....q:(AdmStatus="C")
	....;W AdmStatus
	....S BillConInvId=0
	....s BillConInvId=$O(^DHCBCI(0,"INV",InvId,BillConInvId))
	....q:BillConInvId=""
	....s BillId=$p(^DHCBCI(BillConInvId),del,2)
	....q:BillId=""
	....s PboId=0
	....f  s PboId=$o(^DHCPB(BillId,"O",PboId)) q:PboId=""  d
	.....S OrdId=$p(^DHCPB(BillId,"O",PboId),del,4)
	.....q:$p(^OEORD($p(OrdId,"||",1),"I",$p(OrdId,"||",2),1),del,13)="4"
	.....s Total=$p(^DHCPB(BillId,"O",PboId),del,8)
	.....s ArcimId=$p(^DHCPB(BillId,"O",PboId),del,3)
	.....q:ArcimId=""
	.....s ArcimId1=$p(ArcimId,"||"),ArcimId2=$p(ArcimId,"||",2)
	.....S BillGroupSubId=$p(^ARCIM(ArcimId1,ArcimId2,1),del,9)
	.....if ((BillGroupSubId=$g(^DHCOPRegConfig("RegFeeBillSub")))!(BillGroupSubId=$g(^DHCOPRegConfig("AppFeeBillSub")))!(BillGroupSubId=$g(^DHCOPRegConfig("CheckFeeBillSub"))))  d
	......IF $g(^DHCOPRegConfig("RegFeeBillSub"))=BillGroupSubId s $p(^FHQTEMP($J,LocDesc),del,1)=$p(^FHQTEMP($J,LocDesc),del,1)+Total
	......IF $g(^DHCOPRegConfig("AppFeeBillSub"))=BillGroupSubId s $p(^FHQTEMP($J,LocDesc),del,2)=$p(^FHQTEMP($J,LocDesc),del,2)+Total
	......IF $g(^DHCOPRegConfig("CheckFeeBillSub"))=BillGroupSubId s $p(^FHQTEMP($J,LocDesc),del,1)=$p(^FHQTEMP($J,LocDesc),del,1)+Total
	.....else  d 
	......s $p(^FHQTEMP($J,LocDesc),del,3)=$p(^FHQTEMP($J,LocDesc),del,3)+Total
	s LocDesc=""
	f  s LocDesc=$o(^FHQTEMP($J,LocDesc)) q:LocDesc=""  d
	.w LocDesc_"^"_$g(^FHQTEMP($J,LocDesc)),!
}

}
