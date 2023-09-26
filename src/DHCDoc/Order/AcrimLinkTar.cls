Class DHCDoc.Order.AcrimLinkTar Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(%ResultSet).RunQuery("DHCDoc.Order.AcrimLinkTar","QueryArcimLinkTar","11578||1")
Query QueryArcimLinkTar(arcimrowid = "", HospID = "", LangID As %String = "") As websys.Query(ROWSPEC = "olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice")
{
}

ClassMethod QueryArcimLinkTarExecute(ByRef qHandle As %Binary, arcimrowid = "", HospID = "", LangID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:arcimrowid="" $$$OK
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ItemCatDR=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i (OrderType="R") {
		s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(arcimrowid,HospID) //草药标志
		s INCIrow=0
		f {
			s INCIrow=$o(^INCI(0,"ARCIM_DR",+arcimrowid,INCIrow))
			Q:INCIrow=""
			if (CNMedItemFlag=1){
				s INCIDesc=$p($g(^INCI(INCIrow,1)),"^",2)
				s INCIDesc=##class(User.INCItm).GetTranByDesc("INCIDesc",INCIDesc,LangID)
				s INCIDesc=..%Translate("dhcdoc.arcimlinktar.hui.csp""库存项--")_INCIDesc
				s INCICode=$p($g(^INCI(INCIrow,1)),"^",1)
				s ^CacheTemp(repid,ind)=$lb(INCIrow,INCICode,INCIDesc,"","","","","","","")
				s ind=ind+1
			}
			Set rset=##Class(%ResultSet).%New("web.DHCST.INCLINKTAR:QueryIncLinkTar")
			If rset.QueryIsValid() {
				Set Status=rset.Execute(INCIrow)
				If 'Status Quit
				Set columns = rset.GetColumnCount()
				While (rset.Next()) {
				    //lnkId,tarItmId,tarItmCode,tarItmDesc,uomDesc,qty,sp,lnkStDate,lnkEdDate
					s olttariffdr=rset.Data("tarItmId")
					s tarcode=rset.Data("tarItmCode")
					s tardesc=rset.Data("tarItmDesc")
					s tardesc=$s((tardesc'=""):##class(User.DHCTarItem).GetTranByDesc("TARIDesc",tardesc,LangID),1:"")
					s tarnum=rset.Data("qty")
					s taruom=rset.Data("uomDesc")
					s taruom=$s((taruom'=""):##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom,LangID),1:"")
					s tarDate=rset.Data("lnkStDate")
					s tarDateTo=rset.Data("lnkEdDate")
					s OLTBascPriceFlag="N"
					s OLTBillOnceFlag="N"
					s tarprice=rset.Data("sp")
					s ^CacheTemp(repid,ind)=$lb(olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice)
					s ind=ind+1
				}
			}
		}
	}else{
		Set rset=##Class(%ResultSet).%New("web.DHCBL.CT.DHCOrderLinkTar:GetList")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(arcimrowid,"Y",HospID)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s olttariffdr=rset.Data("olttariffdr")
				s tarcode=rset.Data("tarcode")
				s tardesc=rset.Data("tardesc")
				s tardesc=$s((tardesc'=""):##class(User.DHCTarItem).GetTranByDesc("TARIDesc",tardesc,LangID),1:"")
				s tarnum=rset.Data("tarnum")
				s taruom=rset.Data("taruom")
				s taruom=$s((taruom'=""):##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom,LangID),1:"")
				s tarDate=rset.Data("tarDate")
				s tarDateTo=rset.Data("tarDateTo")
				s OLTBascPriceFlag=rset.Data("OLTBascPriceFlag")
				s OLTBillOnceFlag=rset.Data("OLTBillOnceFlag")
				s tarprice=rset.Data("tarprice")
				s ^CacheTemp(repid,ind)=$lb(olttariffdr,tarcode,tardesc,tarnum,taruom,tarDate,tarDateTo,OLTBascPriceFlag,OLTBillOnceFlag,tarprice)
				s ind=ind+1
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
