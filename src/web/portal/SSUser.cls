Import SQLUser

Class web.portal.SSUser Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod IsValidUser(username As %String, password As %String, overrideauthentication As %Library.Boolean = 0) As %String
{
	// 修改成密文比较
	;^SSU("SSUSR", 0, "SSUSR_Initials" , $$ALPHAUP({SSUSR_Initials}), {SSUSR_RowId})
	s myUserID=$o(^SSU("SSUSR", 0, "SSUSR_Initials" , $system.SQL.ALPHAUP(username), 0))
	s myUserID=+myUserID
	b
	if (myUserID>0){
		s mypwd=$p(^SSU("SSUSR",myUserID),"^",3)
		;如果密码不正确，返回id=0
		if (password'=mypwd){
			s myUserID=0
		}
	}
	
	q myUserID
}

/// SELECT %ID,SSUSR_Initials, SSUSR_Name,SSUSR_Password, SSUSR_DefaultDept_DR, SSUSR_DefaultDept_DR->CTLOC_Desc FROM SS_User
Query SelectUserInfo() As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,SSUSR_Initials, SSUSR_Name,SSUSR_Password, SSUSR_DefaultDept_DR, SSUSR_DefaultDept_DR->CTLOC_Desc, SSUSR_Group, SSUSR_Group->SSGRP_Desc FROM SS_User
}

Query ReadUserByCode(UCode As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,SSUSR_Initials, SSUSR_Name,SSUSR_Password, SSUSR_DefaultDept_DR, 
		SSUSR_DefaultDept_DR->CTLOC_Desc, SSUSR_Group, SSUSR_Group->SSGRP_Desc 
	FROM SS_User
	where %ALPHAUP SSUSR_Initials = %ALPHAUP :UCode
}

}
