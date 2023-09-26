Class web.MRCDiagnosType Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 106;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DTYP_Code";

Parameter SQLDESCRIPTION = "DTYP_Desc";

Parameter SQLROWID = "DTYP_RowId";

/// Log 46428 - AI - 17-11-2004 : Broker called from MRDiagnos.Edit - MRDiagType item.
///   Restrict by Security Group -> Diagnosis Type Restrictions if applicable.
ClassMethod LookUpWithGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", DiagType As %Library.String = "") As %Library.Boolean
{
	n obj
	Set obj=##class(%ResultSet).%New("web.MRCDiagnosType:LookUpWithGroup")
	d obj.Execute(DiagType)
	For  Quit:'obj.Next()  Do
	.s Description=obj.Data("Description")
	.s Code=obj.Data("Code")
    .s retval=itmjs_"('"_$ZCVT(Description,"O","JS")_"','"_$ZCVT(Code,"O","JS")_"');"
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod LookUpWithGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithGroupFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Log 46428 - AI - 17-11-2004 : Called from MRDiagnos.Edit - MRDiagType item.
///   Restrict by Security Group -> Diagnosis Type Restrictions if applicable.
/// d ##class(%ResultSet).RunQuery("web.MRCDiagnosType","LookUpWithGroup","出院")
ClassMethod LookUpWithGroupExecute(ByRef QHandle As %Library.Binary, DiagTypeDesc As %String = "") As %Library.Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i (DiagTypeDesc=""){
		s DiagTypeRowId=0
		f  s DiagTypeRowId=$o(^MRC("DTYP",DiagTypeRowId)) q:DiagTypeRowId=""  d
		.s Description=$p($g(^MRC("DTYP",DiagTypeRowId)),"^",2)
		.s Code=$p($g(^MRC("DTYP",DiagTypeRowId)),"^",1)
		.d OutPutDiagnosType
	}else{		
		s DTDesc="",DiagTypeRowId="",DiagTypeDesc=$$ALPHAUP^SSUTIL4(DiagTypeDesc)
		f  s DTDesc=$o(^MRC("DTYP",0,"Desc",DTDesc)) q:DTDesc=""  d
		.s DiagTypeRowId=$o(^MRC("DTYP",0,"Desc",DTDesc,"")) 
		.s Description=$p($g(^MRC("DTYP",DiagTypeRowId)),"^",2)
		.s Code=$p($g(^MRC("DTYP",DiagTypeRowId)),"^",1)
		.q:Description'[DiagTypeDesc
		.d OutPutDiagnosType			
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutDiagnosType
	set Data=$lb(Description,Code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod LookUpWithGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithGroupExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
	Set repid=$LIST(QHandle,2)
	Set ind=$LIST(QHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Log 46428 - AI - 17-11-2004 : Called from MRDiagnos.Edit - MRDiagType item.
///   Restrict by Security Group -> Diagnosis Type Restrictions if applicable.
Query LookUpWithGroup(DiagTypeDesc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
}

}
