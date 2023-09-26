Class web.MRCICDStat Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "MRCIS_Code";

Parameter SQLDESCRIPTION = "MRCIS_Desc";

Parameter SQLROWID = "MRCIS_RowId";

}
