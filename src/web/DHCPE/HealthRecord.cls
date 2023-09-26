Class web.DHCPE.HealthRecord Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s rowid=$p(InString,"^",1)
	s code=$p(InString,"^",2)
    s cname=$p(InString,"^",3)
	s chname=$p(InString,"^",4)
	&sql(insert into sqluser.DHC_PE_HealthRecord (HR_RowId,HR_Code,HR_ComponentName,HR_Desc)values(:rowid,:code,:cname,:chname))
	q
}

ClassMethod Delete(string)
{
   s irowid=$p(string,"^",1)
   &sql(delete from sqluser.DHC_PE_HealthRecord where HR_RowId=:irowid)
   q
}

Query Search() As %SQLQuery(ROWSPEC = "TRowId:%String,TCode:%String,THealthName:%String,TCName:%String")
{
	select  HR_RowId,HR_Code,HR_Desc,HR_ComponentName
	from sqluser.DHC_PE_HealthRecord
}

}
