Class web.ARCItemMessage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 51;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindMessIDByAgeAndSexClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMessIDByAgeAndSexFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMessIDByAgeAndSexExecute(ByRef QHandle As %Library.Binary, ParRef As %String, age As %Library.String, sexid As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMessIDByAgeAndSexFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMessIDByAgeAndSexExecute ]
{
}

Parameter SQLCODE = "MESS_RowId";

Parameter SQLDESCRIPTION = "MESS_RowId";

Parameter SQLROWID = "MESS_RowId";

/// To find and override message for and Order Item by age and sex
Query FindMessIDByAgeAndSex(ParRef As %Library.String, age As %Library.String, sexid As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "messageid")
{
SELECT MESS_RowId
FROM SQLUser.ARC_ItemMessage
WHERE (MESS_ParRef = :ParRef)
AND (MESS_AgeFrom <= :age)
AND (MESS_AgeTo >= :age)
AND ((MESS_Sex_DR = :sexid) OR (MESS_Sex_DR is null))
}

}
