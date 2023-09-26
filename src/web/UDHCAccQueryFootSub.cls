Import SQLUser

Class web.UDHCAccQueryFootSub Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

ClassMethod INSERT() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_AccQueryFootSub Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE		;$$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_AccQueryFootSub WHERE AccQFS_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_AccQueryFootSub VALUES PLIST() WHERE AccQFS_RowID= :RowId)
	d ..tc()
	;
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE	;$$code^SSUTILSQ(SQLCODE)
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
