Class web.PAOdometer Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Parameter SQLCODE = "ODOM_RowId";

Parameter SQLDESCRIPTION = "ODOM_RowId";

Parameter SQLROWID = "ODOM_RowId";

/// returns odometer values for a ssuser and date
Query FindByUserAndDate(userid As %String, date As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ODOM_RowId:%String,ODOM_Date:%String,ODOM_User_DR:%String,ODOM_StartOdometer:%String,ODOM_EndOdometer:%String")
{
SELECT ODOM_RowId,ODOM_Date,ODOM_User_DR,ODOM_StartOdometer,ODOM_EndOdometer
FROM SQLUser.PA_Odometer
WHERE ODOM_Date = :date
AND ODOM_User_DR->SSUSR_RowId = :userid
}

}
