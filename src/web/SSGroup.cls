Include webimport

IncludeGenerator webimport

Class web.SSGroup Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 177;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SSGRP_Desc";

/// 20140326 如果安全组的描述数字开头有Bug, SSGRP_RowId改成SSGRP_Desc 
Parameter SQLDESCRIPTION = "SSGRP_Desc";

Parameter SQLROWID = "SSGRP_RowId";

Property dummy As %String(TRUNCATE = 1);

/// KK 21/Jul/2003 Log 36739 - to check duplicate entries in web.SSGroup. method called in websysBeforeSave
ClassMethod CheckDuplicates(compref As %Library.String, id As %Library.String) As %Library.Boolean
{
}

ClassMethod EnableAllAccess(groupid As %Library.String)
{
}

/// Geting the flag from RowId   
ClassMethod GetAllowEEpLgLcFrRowId(rowid As %Library.String)
{
}

ClassMethod GetAllowToActivate(GroupID As %Library.String) As %Library.String
{
}

/// by wuqk 2011-06-17
ClassMethod GetAllowViewVIP(Id As %Library.String) As %Library.String
{
}

ClassMethod GetApptPast(grpID As %Library.String) As %Library.String
{
}

/// rqg,Log27501: This broker use the security level which restricts the security group.
ClassMethod LookUpBrokerPartial(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "", level As %Library.String = "") As %Library.Boolean
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod DoNotUpdateDoctor(userId As %String = "") As %Boolean
{
}

Query Find(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SSGRPDesc")
{
SELECT SSGRP_Rowid, SSGRP_Desc
FROM SS_Group
WHERE SSGRP_Desc %STARTSWITH :desc
ORDER BY SSGRP_Desc
}

Query LookUpPartial(desc As %Library.String, level As %Library.String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "grpdesc,grpcode")
{
SELECT SSGRP_Desc, SSGRP_RowId
FROM SS_Group
WHERE (%ALPHAUP SSGRP_Desc [ %ALPHAUP :desc OR :desc IS NULL)
AND (SSGRP_SecurityLevel <= :level OR SSGRP_SecurityLevel IS NULL)
ORDER BY SSGRP_Desc
}

ClassMethod GetAllowWebLayoutManager(Id As %Library.String) As %Boolean
{
}

ClassMethod GetAllowWebColumnManager(Id As %Library.String) As %Boolean
{
}

ClassMethod DisableAllowWebManager()
{
}

ClassMethod DisableAllowWebColumn()
{
}

ClassMethod DisalbeAllowWebLayout()
{
}

}
