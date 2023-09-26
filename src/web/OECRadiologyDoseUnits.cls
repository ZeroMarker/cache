Class web.OECRadiologyDoseUnits Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 4;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RDU_Code";

Parameter SQLDESCRIPTION = "RDU_Desc";

Parameter SQLROWID = "RDU_RowId";

Query FindAll(Code As %String, Desc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Code,Desc")
{
SELECT RDU_RowId, RDU_Code, RDU_Desc
FROM SQLUser.OEC_RadiologyDoseUnits
WHERE   ((%UPPER RDU_Code %STARTSWITH %UPPER :Code) OR (:Code IS NULL))
AND     ((%UPPER RDU_Desc %STARTSWITH %UPPER :Desc) OR (:Desc IS NULL))
}

}
