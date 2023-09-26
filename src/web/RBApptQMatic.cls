Class web.RBApptQMatic Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "QM_RowId";

Parameter SQLDESCRIPTION = "QM_RowId";

Parameter SQLROWID = "QM_RowId";

ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

Query FindQMatic(ApptID As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "QMRowId:%String,QMNumber:%String,QMStatus:%String,QMCreateDate:%Date,QMCreateTime:%Time")
{
SELECT QM_RowId,QM_Number,QM_Status,QM_CreateDate,QM_CreateTime 
FROM SQLUser.RB_ApptQMatic
WHERE QM_ParRef=:ApptID
ORDER BY QM_Status,QM_CreateDate,QM_CreateTime DESC
}

}
