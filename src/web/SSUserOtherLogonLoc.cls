Class web.SSUserOtherLogonLoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84101;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OTHLL_RowId";

Parameter SQLDESCRIPTION = "OTHLL_RowId";

Parameter SQLROWID = "OTHLL_RowId";

/// KK 07/10/03 L:38430 - This method is called to check whether the loc is a valid logon location from logon.csp
/// zhaocz 2009-05-18
/// 部门名称+ 医院ID 获取 部门ID
ClassMethod CheckLoginLocation(dept As %Library.String, hosp As %Library.String) As %Library.String
{
}

/// 239 TN: not in use yet - need to fix CheckLoginLocation without affecting current logon
ClassMethod CheckLoginLocationTN(userid As %String, loc As %Library.String, hosp As %Library.String) As %Library.String
{
}

/// checks if user can logon as part of a particular group and location (switching user - web.SSUser.ValidatePIN)
/// exactLoc checks that LocationID must equal user defaultLoc or OtherLogonLoc, otherwise if allowLocationChange is "Y" then consider non matching location as valid
ClassMethod IsValidGroupLocation(UserID As %String, GroupID As %String = "", LocationID As %String = "", exactLoc As %Boolean = 0) As %Boolean
{
}

/// rqg,Log23367: Return true if there are locations associated with the username else false.
/// /  zhaocz 2011-05-26 判断用户是否指定了登陆 location 场所
ClassMethod CheckUserOtherLocation(username As %Library.String) As %Library.Boolean
{
}

/// KK 16/jul/02 Log 23459
ClassMethod GetSystemSecurityMessage(id As %Library.String) As %Library.String
{
}

ClassMethod ListAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListAllFetch ]
{
}

ClassMethod ListAllExecute(ByRef QHandle As %Library.Binary, Surname As %Library.String = "", GivenName As %Library.String = "", DefLoginLoc As %Library.String = "", NewStaffOnly As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod ListAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListAllExecute ]
{
}

/// 60188
ClassMethod LookUpLocationByUserClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpLocationByUserExecute ]
{
}

/// KK 07/10/03 L:38430
/// 用户登录校验 zhaocz 2011-06-12 add
ClassMethod LookUpSelectedUserBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %Library.String = "", hosp As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// KK 07/10/03 L:38430
/// 用户登录校验 zhaocz 2011-06-12 add
ClassMethod LookUpSelectedUserByUHDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %Library.String = "", hosp As %Library.String = "", dep As %String, depAlias As %String, val As %Library.String = "") As %Library.Boolean
{
}

/// 60188
ClassMethod LookUpLocationByUserBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", User As %String = "", val As %String = "") As %Library.Boolean
{
}

/// 60188
ClassMethod LookUpLocationByUserExecute(ByRef QHandle As %Binary, User As %String, val As %String) As %Status
{
}

/// 60188
ClassMethod LookUpLocationByUserFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpLocationByUserExecute ]
{
}

/// TN: not in use yet - need to fix LookUpSelectedUserBroker without affecting current logon broker
ClassMethod LookUpSelectedUserBrokerTN(itmjs As %Library.String = "", itmjsex As %Library.String = "", user As %Library.String = "", hosp As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpSelectedUserClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSelectedUserFetch ]
{
}

/// zhaocz 2011-06-13 add d ##class(%ResultSet).RunQuery("web.SSUserOtherLogonLoc","LookUpSelectedUserExecute","doctor")
ClassMethod LookUpSelectedUserExecute(ByRef QHandle As %Library.Binary, user As %Library.String = "", hospital As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpSelectedUserFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSelectedUserExecute ]
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSaveSecMsg(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KK 16/jul/02 Log 23459  called by Update of  SSUser.EditsystemSecurityMsg 
ClassMethod websysSaveSecurityMsg()
{
}

/// 判断有没有权限更改 wanghc	
/// modified by zhouzq 2012.05.14
/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// wanghc
ClassMethod websysSaveUserOtherLogonLoc(compref As %Library.String, id As %Library.String, PARREF As %Library.String)
{
}

/// KK 29/Oct/2002 Log 29266 
/// Loc:%String
Query FindLocByCareProv(CareProvID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Location,ScheduleRequired,MRRequest,DateTo,AdmittingRights,DateActiveFrom,Hospital,ProviderNo")
{
SELECT RES_RowId,RES_CTLOC_DR->CTLOC_Desc,RES_ScheduleRequired,
RES_MRRequest,RES_DateTo, RES_AdmittingRights,RES_DateActiveFrom,RES_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc,RES_CPLocationNo
FROM SQLUser.RB_Resource
WHERE (RES_CTPCP_DR=:CareProvID)
ORDER BY RES_CTLOC_DR->CTLOC_Desc ASC
}

Query FindUser(PARREF As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "id,loc,group,hosp")
{
SELECT OTHLL_RowId,OTHLL_CTLOC_DR->CTLOC_Desc,OTHLL_UserGroup_DR->SSGRP_Desc,OTHLL_Hospital_DR->HOSP_Desc
FROM SQLUser.SS_UserOtherLogonLoc
WHERE OTHLL_ParRef=:PARREF
ORDER BY OTHLL_CTLOC_DR->CTLOC_Desc
}

Query ListAll(Surname As %String, GivenName As %String, DefLoginLoc As %String, NewStaffOnly As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SSUSRRowId,SSUSRLoginID,SSUSRInitials,SSUSRName,CTLOCDesc,SSGRPDesc,SSUSRSurname,SSUSRGivenName,SSGRPSecurityLevel")
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

/// 60188
Query LookUpLocationByUser(User As %String, val As %String) As %Query(ROWSPEC = "Location:%String,Hospital:%String")
{
}

/// rqg,Log23367: Query to select location and Group using Username
Query LookUpSelectedUser(User As %Library.String, hospital As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Loc:%String,Group:%String,HOSPDesc:%String,HospInsuCode:%String")
{
	
SELECT  OTHLL_CTLOC_DR->CTLOC_Desc, OTHLL_UserGroup_DR->SSGRP_Desc
FROM  SQLUser.SS_UserOtherLogonLoc
WHERE  (%ALPHAUP OTHLL_ParRef->SSUSR_Name [ %ALPHAUP :User) 
ORDER BY OTHLL_CTLOC_DR->CTLOC_Desc
}

ClassMethod FindSSUserOtherPost(UserID, ReqUser = "", hospital = "", ReqLoc = "", ReqGroup = "", IP, ILRLocRowIds, ILRLocDepsIds, ReqPost, ByRef repid, ByRef index)
{
}

ClassMethod FindSSUserOtherLoc(UserID, ReqUser, hospital, Department, Group, IP, ILRLocRowIds, ILRLocDepsIds, ReqPost, ByRef repid, ByRef index)
{
}

/// 不通过返回0, 否则返回1
ClassMethod ValidGroup(GroupId, IP)
{
}

/// 不通过返回0, 否则返回1
ClassMethod ValidLoc(ILRLocRowIds, ILRLocDepsIds, LocId)
{
}

/// 1 有权显示
/// 0 无权显示
ClassMethod GetHasGrantData(LocId, GroupId, PostId, reqLoc, reqGroup, reqPost, SplitDepDescDash)
{
}

/// debug:d ##class(%ResultSet).RunQuery("BSP.SYS.BL.SSUserOtherPost","LookUpSelectedUserByUHD","ys02","","")
Query LookUpSelectedUserByUHD(User As %Library.String, hospital As %Library.String, Department As %Library.String, Group As %Library.String, IP As %String = "", ReqPost = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Loc:%String:科室,Group:%String:安全组,HOSPDesc:%String:医院,LocAlias:%String:别名,HospInsuCode:%String:机构编码,HospDescShort1:%String:医院简称1,AccPost:%String:岗位,AccPostId:%String:岗位ID")
{
}

ClassMethod LookUpSelectedUserByUHDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSelectedUserByUHDFetch ]
{
}

ClassMethod LookUpSelectedUserByUHDExecute(ByRef QHandle As %Library.Binary, user As %Library.String = "", hospital As %Library.String = "", Department As %Library.String = "", Group As %Library.String = "", IP As %String = "", ReqPost = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpSelectedUserByUHDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSelectedUserByUHDExecute ]
{
}

}
