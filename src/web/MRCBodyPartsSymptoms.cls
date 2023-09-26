Include webimport

IncludeGenerator webimport

Class web.MRCBodyPartsSymptoms Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 125;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SYM_Code";

Parameter SQLDESCRIPTION = "SYM_Desc";

Parameter SQLROWID = "SYM_RowId";

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SYMChildsub:%Float,SYMCode:%String,SYMDesc:%String,BODPDesc:%String")
{
SELECT SYM_RowId, SYM_Childsub, SYM_Code, SYM_Desc, SYM_ParRef->BODP_Desc
FROM MRC_BodyPartsSymptoms
WHERE SYM_RowId = :ID
ORDER BY SYM_Code
}

Query Find(ParRef As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SYMChildsub:%Float,SYMCode:%String,SYMDesc:%String")
{
SELECT SYM_RowId, SYM_Childsub, SYM_Code, SYM_Desc
FROM MRC_BodyPartsSymptoms
WHERE (SYM_ParRef = :ParRef)
ORDER BY SYM_Code
}

/// WHERE ((%ALPHAUP HOSP_Desc %STARTSWITH %ALPHAUP :Hospital) OR (%ALPHAUP HOSP_Code %STARTSWITH %ALPHAUP :Hospital))
/// AND ((HOSP_DateFrom <= to_date(:dateto)) OR :dateto is null )
ClassMethod LookUpByBodyPartBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "", Part As %String = "") As %Boolean
{
}

ClassMethod GetIdFromCodeOrDescWithParent(val As %String = "", val2 As %String = "") As %String
{
}

ClassMethod LookUpByBodyPartClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByBodyPartFetch ]
{
}

ClassMethod LookUpByBodyPartExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", Bodyp As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByBodyPartFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByBodyPartExecute ]
{
}

Query LookUpByBodyPart(Desc As %Library.String = "", Bodyp As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Symptom:%String,HIDDEN:%String,Body Part:%String")
{
}

}
