Include webimport

IncludeGenerator webimport

Class web.DHCRBCASStatus Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindRBCASStatus() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tid:%String")
{
	SELECT ASS_Code,ASS_Desc,ASS_Rowid
 	From SQLUser.DHC_RBCASStatus
}

ClassMethod DelRBCASStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 	&sql(delete From SQLUser.DHC_RBCASStatus where ASS_Rowid=:rid)
 	i itmjsex'=""{
	 	s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 		&javascript<#(retval)#>
 		q SQLCODE
 	}else{
		q SQLCODE
 	}
}

ClassMethod UpdateRBCASStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", code As %Library.String = "", name As %Library.String = "")
{
	s ccode = ""
	&sql(SELECT ASS_Rowid into :ccode FROM SQLUser.DHC_RBCASStatus where ASS_Code=:code and ASS_Rowid <>:rowid)
	if ccode="" d update
	s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	if (itmjs'=""){
		s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
		i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
		&javascript<#(retval)#>
		q 1
	}else{
		Q:ccode'="" ccode
		Q SQLCODE
	}
update
	&sql(update SQLUser.DHC_RBCASStatus
	 set ASS_Code=:code,ASS_Desc=:name
	 where ASS_Rowid=:rowid)
}

ClassMethod InsertRBCASStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "")
{
	s ccode = ""
	&sql(SELECT ASS_Rowid into :ccode FROM SQLUser.DHC_RBCASStatus where ASS_Code=:code)
	if ccode="" d insert
	if (itmjs'=""){
		s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
		i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
		&javascript<#(retval)#>
		q 1
	}else{
		Q:ccode'="" ccode
		Q SQLCODE
	}
insert
	&sql(insert into SQLUser.DHC_RBCASStatus
	 (ASS_Code,ASS_Desc)
	 values(:code,:name))
}

}
