Class web.DHCOPChargeAddByOther Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAccLeftByRegNo(RegNo As %String, PapmiRowid As %String) As %String
{
	n (RegNo,PapmiRowid)
	s myAccLeft=""
	if PapmiRowid="" {
		s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	}
	
	q:PapmiRowid="" "-100"
	
	s AccRowid=$O(^DHCACDi("AccM",0,"PAPMI",PapmiRowid,0))
	
	q:AccRowid="" "-101"
	
	s Balance=$p($g(^DHCACD("AccM",AccRowid)),"^",8)
	
	s myAccLeft=Balance
	
	Q "0^"_myAccLeft
}

}
