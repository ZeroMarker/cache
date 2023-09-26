Class web.SSAuditRules Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AUDR_TableName";

Parameter SQLDESCRIPTION = "AUDR_TableName";

Parameter SQLROWID = "AUDR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// zhaocz 2011-06-17 
ClassMethod LookupAuditSecGrpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", table As %Library.String = "", restrict As %String = "") As %Library.Boolean
{
	n id,code,desc
	;
	s (id,code,desc)=""
	;
	; Try and find a matching code
	&sql(SELECT AUDR_TableName, AUDR_RowId  INTO :desc, :id FROM SQLUser.SS_AuditRules 
			WHERE ((%ALPHAUP AUDR_TableName = %ALPHAUP :table)) )
	
	;
	i ('SQLCODE){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"');"
		&javascript<#(retval)#>
	}
	
	i SQLCODE q 0
	
	q 1
}

/// zhaocz 2011-06-17 
ClassMethod LookupAuditSecGrpExecute(ByRef QHandle As %Library.Binary, table As %String = "", restrict As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	n mydescription,myid
	;WHERE ((%ALPHAUP PPDesc %STARTSWITH %ALPHAUP :desc)) AND ((PPTypeDR = :PPType))
	&sql( DECLARE LOOKUP CURSOR FOR SELECT AUDR_TableName, AUDR_RowId 
		FROM SQLUser.SS_AuditRules 
		WHERE ((%ALPHAUP AUDR_TableName %STARTSWITH %ALPHAUP :table)) 
		  ORDER BY AUDR_TableName )
	&sql(Open LOOKUP)
	
	&SQL(FETCH LOOKUP INTO :mydescription,:myid)
	
	while (SQLCODE=0){
		d OutputRowLookUpAuditSecGrp
		&SQL(FETCH LOOKUP INTO :mydescription,:myid)
	}
	&SQL(Close LOOKUP)
	
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLookUpAuditSecGrp
	set Data=$lb(mydescription,myid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesLookUpAuditSecGrp
	
	q
}

ClassMethod LookupAuditSecGrpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupAuditSecGrpExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else{
		Set Row=^CacheTemp(repid,ind)
	}
	
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookupAuditSecGrpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupAuditSecGrpFetch ]
{
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LookupAuditSecGrp(table As %String, restrict As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String")
{
}

Query LookUpAudit(desc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String")
{
 SELECT AUDR_TableName, AUDR_Rowid
 FROM SQLUser.SS_AuditRules
 WHERE (AUDR_TableName %STARTSWITH :desc)
 ORDER BY AUDR_TableName
}

}
