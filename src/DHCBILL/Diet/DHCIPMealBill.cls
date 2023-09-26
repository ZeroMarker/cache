Import sqluser

Class DHCBILL.Diet.DHCIPMealBill Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO dhc_ipmealbill Values PLIST())
	d ..tc()
	q SQLCODE
	;
}

ClassMethod DELETE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM dhc_ipmealbill WHERE DHCMB_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM dhc_ipmealbill WHERE DHCMB_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE dhc_ipmealbill VALUES PLIST() WHERE DHCMB_RowId= :RowId)
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
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

ClassMethod PBINS(adm, user)
{
	n (adm,user)
	k PLIST(1)
	s PLIST(2)=adm
	s PLIST(3)=+$h
	s PLIST(4)=+$h
	s PLIST(6)=+$h
	s PLIST(7)=+$h
	s PLIST(8)=$p($h,",",2)
	s PLIST(9)="N"
	s PLIST(7)=$g(user)
	s err=..INSERT()
	i 'err q err_"^"_$g(%ROWID)
	q err
}

}
