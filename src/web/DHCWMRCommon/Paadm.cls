Import SQLUser

Class web.DHCWMRCommon.Paadm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

ClassMethod GetPaadmByIPNo(IPNo)
{
	n (IPNo)
	s IPNo=$$ALPHAUP^SSUTIL4(IPNo)
	q:IPNo="" ""
	;^PAADMi("No",$$ALPHAUP({PAADM_ADMNo}),{PAADM_RowID})
	s ret=$o(^PAADMi("No",IPNo,0))
	q ret
}

ClassMethod GetIPNoByPaadm(Paadm)
{
	n (Paadm)
	s ret=""
	s ret=$p($g(^PAADM(+Paadm)),"^",81)
	q ret
}

}
