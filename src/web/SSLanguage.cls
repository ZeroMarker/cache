Include webimport

IncludeGenerator webimport

Class web.SSLanguage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 99;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// wanghc
/// Get Langauge Description from ID
ClassMethod GetDescription(id As %Library.String) As %Library.String
{
	s obj = ##class(User.SSLanguage).%OpenId(id)
	q:'$IsObject(obj) ""
	q obj.CTLANDesc
}

Parameter SQLCODE = "CTLAN_Code";

Parameter SQLDESCRIPTION = "CTLAN_Desc";

Parameter SQLROWID = "CTLAN_RowId";

}
