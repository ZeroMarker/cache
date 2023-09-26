Import SQLUser

Class web.UDHCJFADMTOTALAMT Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod INSERT(adm, amt, TotDisc, TotIns, TotPat)
{
    K PLIST
 	S PLIST(2)=$g(adm),PLIST(3)=$g(amt),PLIST(4)=TotDisc,PLIST(5)=TotIns,PLIST(6)=TotPat     
	S $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_AdmTotalAmt VALUES PLIST())
	i SQLCODE'=0 TROLLBACK
	d ..tc()
	Q 0
}

ClassMethod SELECT(RowID)
{
    K PLIST
	q:'$d(^DHCATA(RowID)) 100
	s PLIST(1)=RowID
	s PLIST(2)=$p(^DHCATA(RowID),"^",1)
	s PLIST(3)=$p(^DHCATA(RowID),"^",2)
	s PLIST(4)=$p(^DHCATA(RowID),"^",3)
	s PLIST(5)=$p(^DHCATA(RowID),"^",4)
	s PLIST(6)=$p(^DHCATA(RowID),"^",5)
	s PLIST=$o(PLIST(""),-1)
	q 0
}

ClassMethod UPDATE(RowID, amt, TotDisc, TotIns, TotPat)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AdmTotalAmt SET ATA_TotalAmt=:amt,ATA_TotDisc=:TotDisc,ATA_TotIns=:TotIns,ATA_TotPat=:TotPat WHERE ATA_ROWID=:RowID)
	d ..tc()
	;i 'SQLCODE q $$SELECT(RowID)
	q 0
}

ClassMethod BillUPD(adm, amt, TotDisc, TotIns, TotPat)
{
	n (adm,amt,TotDisc,TotIns,TotPat)
	s adm=$g(adm),amt=$g(amt)
	q:adm=""
	s atadr=$o(^DHCATA(0,"ADM",adm,""))

	i atadr="" s err=..INSERT(adm,amt,TotDisc,TotIns,TotPat)
	e  s err=..UPDATE(atadr,amt,TotDisc,TotIns,TotPat)
	q err
}

ClassMethod tb()
{
    n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
