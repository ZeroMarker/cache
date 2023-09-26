Class web.DHCOPItemMast7 Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCOPItemMast7).RecalculateIMInfoBroker("WrtOEOtherInfo","3","10468||1","","1","R","","ARCIM","176")
ClassMethod RecalculateIMInfoBroker(JSFunName As %String, bPAAdmRowID As %String, bItmMastRowid As %String, bPatType As %String, bInsType As %String, bOrderType As %String, bOEPrice As %String, bARCType As %String, bOERecLocDR As %String) As %String
{
	;重新计算加载医嘱信息
	;Set rset = ##class(%ResultSet).%New("web.DHCOPItemMast:OEItmInfo")
	;Set columns = rset.GetColumnCount()
	;//bPAAdmRowID as %String, bItmMastRowid as %String, bPatType as %String, bInsType as %String
	;//bOEPrice as %Float,bARCType as %String
	;Set rs = rset.Execute(bPAAdmRowID, bItmMastRowid,bPatType,bInsType,bOEPrice,bARCType)
	;Set rs = rset.Execute("2","8586||1","","","","ARCIM")
	;s myIdx=0
	
	;s ^TMPRecalculateIMInfoBroker=$lb(JSFunName , bPAAdmRowID , bItmMastRowid , bPatType , bInsType , bOrderType , bOEPrice , bARCType , bOERecLocDR)
	if (bInsType="")&&(bPAAdmRowID'="")
	{
		s bInsType= $p($g(^PAADM(bPAAdmRowID,1)),"^",7)
	}
	;;各种价格?
	;PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice
	;d ResetVariablesInfo
	s myRowVal=""
	if bARCType="ARCIM" {
		s myExpStr=""
		s retPrice=..ReCalculateOrdPrice(bPatType,bInsType,bItmMastRowid,+$h,"","","",bOEPrice,bOERecLocDR)
		s myPrice=$p(retPrice,"^",1)
		s myDiscPrice=$p(retPrice,"^",2)
		s myInsPrice=$p(retPrice,"^",3)
		s myPatPrice=$p(retPrice,"^",4)
		;s myConFac=$p(retPrice,"^",5)
		;s myPrice=$fn(myPrice*myConFac,"",6)	;4--->6
		;s myDiscPrice=$fn(myDiscPrice*myConFac,"",6)	;4--->6
		;s myInsPrice=$fn(myInsPrice*myConFac,"",6)		;4--->6
		;s myPatPrice=$fn(myPatPrice*myConFac,"",6)		;4--->6
	}else{
		s retPrice=##class(web.DHCOPItemMast).GetOrderSetPrice(bPatType,bInsType,bItmMastRowid,+$h,"","","","")
		s myPrice=    $fn($p(retPrice,"^",1),"",6)		;4--->6
		s myDiscPrice=$fn($p(retPrice,"^",2),"",6)		;4--->6
		s myInsPrice= $fn($p(retPrice,"^",3),"",6)		;4--->6
		s myPatPrice= $fn($p(retPrice,"^",4),"",6)		;4--->6
	}
	;myPrice,myDiscPrice,myInsPrice,myPatPrice
	s myRowVal=$g(myRowVal)_$g(myPrice)_$C(2)_$g(myDiscPrice)_$c(2)_myInsPrice_$c(2)_myPatPrice
	s myval=$g(myRowVal)
	s rtnval=JSFunName_"('"_$g(myval)_"');"
	&javascript<#(rtnval)#>
	
	q 0
}

/// w ##class(web.DHCOPItemMast7).ReCalculateOrdPrice("","","205||1",+$h,"","","","")
ClassMethod ReCalculateOrdPrice(PatType As %String, InsType As %String, ARCIMRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String, bOERecLocDR As %String) As %String
{
	;医嘱价格?
	;n (PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice, bOERecLocDR)
	
	s ARCIMSub=$p(ARCIMRowid,"||",1)
	if SttDate="" s SttDate=+$h
	s retPrice=##class(web.udhcOPBillIF).ReCalculateOrdPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,bOERecLocDR, "")
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s INCIRowid=##class(web.DHCOPItemMast).GetINCI(ARCIMSub)
	s ConFac=1
	if INCIRowid'="" {
		s ConFac=##class(web.DHCOPItemMast).GetConFac(ARCIMRowid,INCIRowid)
		s Price=$fn(Price*ConFac,"",6)		;4--->6
		s DiscPrice=$fn(DiscPrice*ConFac,"",6)	;4--->6
		s InsPrice=$fn(InsPrice*ConFac,"",6)	;4--->6
		s PatPrice=$fn(PatPrice*ConFac,"",6)	;4--->6
	}
	Q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ConFac
}

}
