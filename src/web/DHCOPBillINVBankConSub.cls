Import sqluser

Class web.DHCOPBillINVBankConSub Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_INVBankConSub WHERE IBS_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT() As %String
{
	;s $ZT="ERROR^DHCSSERR"
	;d ..tb()
	k PLIST(1)
	&sql(insert into DHC_INVBankConSub Values PLIST())
	;d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVBankConSub WHERE IBS_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVBankConSub VALUES PLIST() WHERE IBS_RowID= :RowId)
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q SQLCODE			
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

Storage Default
{
<Data name="DHCOPBillINVBankConSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCOPBillINVBankConSubD</DataLocation>
<DefaultData>DHCOPBillINVBankConSubDefaultData</DefaultData>
<IdLocation>^web.DHCOPBillINVBankConSubD</IdLocation>
<IndexLocation>^web.DHCOPBillINVBankConSubI</IndexLocation>
<StreamLocation>^web.DHCOPBillINVBankConSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
