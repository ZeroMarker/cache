Import SQLUser

Class web.DHCJFUOMSET Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCJFUOMSET).INSERT("M^月^Y")
ClassMethod INSERT(uomStr)
{
	new (uomStr)
	if (uomStr="") quit -1
	kill PLIST
	set PLIST(2)=$p(uomStr,"^",1)
	set PLIST(3)=$p(uomStr,"^",2)
	set PLIST(4)=$p(uomStr,"^",3)
	if (PLIST(2)="") quit -1
	if (PLIST(3)="") quit -1
	if (PLIST(4)="") set PLIST(4)="Y"
	
	set $ZT="ERROR^DHCSSERR" do ..tb()
	&sql(INSERT INTO DHC_JFUOMSET VALUES PLIST())
	do ..tc()
	
	set P1=$P($g(%ROWID),$C(1))
	if 'SQLCODE quit ..SELECT(%ROWID)
	quit $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_JFUOMSET WHERE JUS_RowId= :RowId) 
	set PLIST=$o(PLIST(""),-1)
	set PLIST(1)=$P(PLIST(1),$C(1))
	quit SQLCODE
}

ClassMethod tb()
{
	new (SQLCODE)
	TSTART  set SQLCODE=$zu(34)
	quit
}

ClassMethod tc()
{
	new (SQLCODE)
	if $$intp^%qartp TCOMMIT  set SQLCODE=$zu(34)
	quit
}

ClassMethod getUomCode(uomRowId) As %String
{
	set uomCode=$p(^DHCJFUOMSET(uomRowId),"^",1)
	quit uomCode
}

ClassMethod getUomId(uomDesc) As %String
{
	set uomRowId=$o(^DHCJFUOMSET(0,"Desc",uomDesc,""))
	quit uomRowId
}

/// do ##class(%ResultSet).RunQuery("web.DHCJFUOMSET","QueryUom")
Query QueryUom(langId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod QueryUomExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
	set repid=$i(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	set rowId=0
 	while($o(^DHCJFUOMSET(rowId))) {
	 	set rowId=$o(^DHCJFUOMSET(rowId))
		set data=$g(^DHCJFUOMSET(rowId))
	    set desc=$p(data,"^",2)
	    set desc=##class(User.DHCJFUOMSET).GetTranByDesc("JUSDesc", desc, langId)
	   	do OutputUom
	}
   	
	quit $$$OK
OutputUom
	set Data=$lb(rowId,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
