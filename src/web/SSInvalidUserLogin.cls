/// webimport
Class web.SSInvalidUserLogin Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// zhaocz 2011-05-26
ClassMethod Insert(userid As %Library.String, computer As %Library.String = "")
{
	;w ##class(web.SSInvalidUserLogin).Insert("1","127.0.0.1")
	n myiulid
	s myiulid=""
	
	s obj=##class(User.SSInvalidUserLogin).%New()
	s obj.INVLOGComputerName = computer
	d obj.INVLOGUserDRSetObjectId(userid)
	s obj.INVLOGDate = +$h
	s obj.INVLOGTime = $p($h,",",2)
	s mysc=obj.%Save()
	s myiulid=obj.%Id()
	s obj=""
	
	q myiulid
}

Parameter SQLCODE = "INVLOG_RowId";

Parameter SQLDESCRIPTION = "INVLOG_RowId";

Parameter SQLROWID = "INVLOG_RowId";

}
