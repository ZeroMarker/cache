Include webimport

IncludeGenerator webimport

Class web.PHCGenericRtForms Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "RTF_Ident";

Parameter SQLDESCRIPTION = "RTF_Ident";

Parameter SQLROWID = "RTF_RowId";

//log59784 TedT

ClassMethod GetARCIMFromGRFID(GenRtFormDR As %String) As %String
{
}

/*ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
 	s (id,desc,code,retval)=""
	&sql(SELECT RTF_RowId,RTF_Ident,RTF_Ident INTO :id,:desc,:code FROM SQLUser.PHC_GenericRtForms WHERE RTF_Ident=:val)
	i ('SQLCODE)!(val="") d  q 1
	. s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	. i itmjsex'="" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
	. Write (retval),!
	&sql(SELECT RTF_RowId,RTF_Ident,RTF_Ident INTO :id,:desc,:code FROM SQLUser.PHC_GenericRtForms WHERE RTF_Ident=:val)
	i 'SQLCODE d  q 1
	. s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	. i itmjsex'="" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
	. Write (retval),! 
	q 0
}
*/
ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status
{
}

ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

ClassMethod LookUpBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Generic:%String,Route:%String,Form:%String,Strength:%String")
{
}

}
