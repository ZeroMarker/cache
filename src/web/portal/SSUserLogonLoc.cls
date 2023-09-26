Import SQLUser

Class web.portal.SSUserLogonLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query SelectByUCode(UCode As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID, OTHLL_CTLOC_DR, OTHLL_CTLOC_DR->CTLOC_Desc, OTHLL_UserGroup_DR, OTHLL_UserGroup_DR->SSGRP_Desc
	FROM SS_UserOtherLogonLoc
	where %ALPHAUP OTHLL_ParRef->SSUSR_Initials= %ALPHAUP :UCode
}

}
