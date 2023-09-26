Include (webimport, TRAK)

IncludeGenerator (webimport, TRAK)

Class web.SSUserDefWindowControls Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 253;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CON_Code";

Parameter SQLDESCRIPTION = "CON_Text";

Parameter SQLROWID = "CON_RowId";

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query LookupControls(QID As %String, val As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "CONText:%String,HIDDEN:%String,CONCode:%String")
{
SELECT CON_Text, CON_RowID, CON_Code
FROM SQLUser.SS_UserDefWindowControls
WHERE (CON_ParREf->WIN_RowId = :QID)
AND ((:val IS NULL) OR (%ALPHAUP CON_Text %STARTSWITH %ALPHAUP :val))
}

ClassMethod LookupControlsBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", QID As %String, val As %String = "") As %Library.Boolean
{
}

Query Find(qno As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CONText:%String,CONControlType:%String,CONValues:%String")
{
SELECT CON_RowID, CON_Text, CON_ControlType, CON_Values
FROM SS_UserDefWindowControls
WHERE (CON_ParREf = :qno)
}

/// ab 3.05.06 - usd by SSUserDefWindowControls.List
Query FindList(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CONCode:%String,CONText:%String,CONControlType:%String,CONDefaultLastQnAns:%String,CONNoLongerUsedFlag:%String,CONDisplayAnswer:%String")
{
SELECT CON_RowID, CON_Code,CON_Text,CON_ControlType,CON_DefaultLastQnAns,CON_NoLongerUsedFlag,CON_DisplayAnswer
FROM SQLUser.SS_UserDefWindowControls
WHERE (CON_ParREf->WIN_RowId = :ID)
}

ClassMethod LookUpSignifBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", ControlType As %String = "", ControlID As %String = "", PARREF As %String = "") As %String
{
}

ClassMethod LookUpSignifClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSignifFetch ]
{
}

/// ab 17.05.06 57866 - significance levels 1-6 for normal fields, 7-8 for dates - lookup on SSUserDefWindowControls.Edit
ClassMethod LookUpSignifExecute(ByRef QHandle As %Library.Binary, val As %String = "", ControlType As %String = "", ControlID As %String = "", PARREF As %String = "") As %Library.Status
{
}

ClassMethod LookUpSignifFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSignifExecute ]
{
}

Query LookUpSignif(val As %String, ControlType As %String, ControlID As %String, PARREF As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Level:%String")
{
}

ClassMethod LookUpClassNameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpClassNameFetch ]
{
}

/// ab 14.06.06 59601 - used on SSUserDefWindowControls.Edit
ClassMethod LookUpClassNameExecute(ByRef QHandle As %Library.Binary, searchclass As %String) As %Library.Status
{
}

ClassMethod LookUpClassNameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpClassNameExecute ]
{
}

/// Get a list of classnames - faster than using the system classes
Query LookUpClassName(classname As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "TableName:%String")
{
}

/// ab 14.06.06 59601 - used on SSUserDefWindowControls.Edit
ClassMethod LookUpClassNameBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", classname As %String = "") As %String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod validCalc(value As %String, error As %String) As %Boolean
{
}

ClassMethod ExeCalc(calc As %String, error As %String) As %Boolean
{
}

ClassMethod GetToken(tok As %String, error As %String) As %String
{
}

ClassMethod ValidateClassNameDescription(classname As %String)
{
}

}
