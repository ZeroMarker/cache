Class web.SSUserGroups Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerValidGroup(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %Library.String = "", val As %Library.String = "", today As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "GRP_RowId";

Parameter SQLDATEFROM = "GRP_DateFrom";

Parameter SQLDATETO = "GRP_DateTo";

Parameter SQLDESCRIPTION = "GRP_RowId";

Parameter SQLROWID = "GRP_RowId";

Query FindUserGroup(UserID As %Library.String, GroupDesc As %String, Today As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,SSGRPDesc:%String")
{
SELECT DISTINCT BY (Grp_Group_DR) Grp_Group_DR,Grp_Group_DR->SSGRP_Desc
FROM SQLUser.SS_UserGroups
WHERE (Grp_ParRef= :UserID) AND (Grp_Group_DR->SSGRP_Desc  %STARTSWITH :GroupDesc) AND (Grp_DateFrom <= :Today) AND ((Grp_DateTo >= :Today) OR (Grp_DateTo IS  NULL))
ORDER BY Grp_Group_DR->SSGRP_Desc
}

}
