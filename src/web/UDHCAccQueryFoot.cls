Import SQLUser

Class web.UDHCAccQueryFoot Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 15;

ClassMethod INSERT() As %String
{
	;;w ##class(web.UDHCAccQueryFoot).Insert()
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_AccQueryFoot Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccQueryFoot WHERE AccQF_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	&sql(UPDATE DHC_AccQueryFoot VALUES PLIST() WHERE AccQF_RowID= :RowId)
	d ..tc()
	;q SQLCODE
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
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
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
