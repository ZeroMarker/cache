Class web.CFSM Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod GetDSN() As %Library.String
{
}

Parameter SQLCODE = "SMCF_AllowDeletionFromCodeTables";

Parameter SQLDESCRIPTION = "SMCF_RowId";

Parameter SQLROWID = "SMCF_RowId";

ClassMethod GetCurrentDocumentCounter(FileExt As %String, FileType As %String) As %String
{
}

/// w ##class(web.CFSM).GetFilePaths()
ClassMethod GetFilePaths()
{
}

ClassMethod GetNextDocumentCounter(Extension As %Library.String, Type As %Library.String) As %Library.String
{
}

ClassMethod GetInvalidLoginAttempts() As %String
{
	n id, smobj, Attempts
	s id=$O(^CF("SM",0))
	Q:id="" ""
	s Attempts=""
	s smobj=##class(User.CFSM).%OpenId(id,0)
	if $IsObject(smobj) {
		s Attempts=smobj.SMCFInvalidLoginAttempts
		s smobj=""
	}
	Q Attempts
	Q ""
}

ClassMethod GetPasswordMinLength() As %Library.String
{
	; zhaocz 2011-06-21 edit
	n id, smobj, length
	
	s id=$O(^CF("SM",0))
	Q:id="" ""
	s length=""
	s smobj=##class(User.CFSM).%OpenId(id,0)
	if $IsObject(smobj) {
		s length=smobj.SMCFPasswordMinLength
		s smobj=""
	}
	Q length
	Q ""
}

}
