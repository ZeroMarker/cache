Include webimport

IncludeGenerator webimport

Class web.SSUser Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1043;

Parameter SQLCODE = "SSUSR_Initials";

Parameter SQLDATEFROM = "SSUSR_DateFrom";

Parameter SQLDESCRIPTION = "SSUSR_Name";

Parameter SQLDATETO = "SSUSR_DateTo";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "(SSUSR_Active <> 'N')";

Parameter SQLROWID = "SSUSR_RowId";

ClassMethod CanChangeDepartment(UserID As %Library.String = "") As %Library.Boolean
{
}

/// by wuqk 2011-07-30
ClassMethod CheckforDiffUserGroup(groupid As %Library.String) As %Library.Boolean
{
}

/// zhaocz copy SSUTIL2.mac
ClassMethod Encrypt(x As %Library.String) As %Library.String
{
}

/// SA   2.6.03 - Implemented for log 35979 and called from SSUser.Edit to set Bold Links
/// AJI 11.9.03 - L37591 added bold links for external system code (SSUserExtSysCodes.List)
/// if child/related table has entries.
ClassMethod GetBoldLinks(SSUserID As %String = "") As %Library.String
{
}

/// modify by wuqk 2011-06-01
ClassMethod GetDefaultCareProvider(userID As %Library.String) As %Library.String
{
}

/// by wuqk 2011-06-01
ClassMethod GetDefaultCareProviderType(userid As %Library.String = "") As %Library.String
{
}

/// SA 3.7.02 - log 23316: Method created to return the default login location for the user passed.
ClassMethod GetDefaultLocation(UserID As %Library.String = "") As %String
{
}

/// Generic method to retrieve any details required for this class.
/// Suggest adding any single fields required to this method, 
/// rather than creating a separate method for indiviual fields.
ClassMethod GetDetails(SSUserID As %Library.String = "") As %String
{
}

/// KK 16/jul/02 Log 23459  called from Logon.csp
/// 			
/// 
/// by wuqk add 2011-07-15
ClassMethod GetSystemSecurityMessage(id As %Library.String) As %Library.String
{
}

/// SA 3.7.02 - log 23316: Method created to get the User setup details to display in the user banner.
/// This is NOT the current user, but rather the user record being viewed/modified.
ClassMethod GetUserBannerDetails(SSUserID As %Library.String = "") As %String
{
}

Method GetUserGroup(userid As %Library.String) As %Library.String
{
}

/// Checks if the user is required to change their password.
/// First checks if the last time the user changed the password has exceeded the allowable number of days between changing passwords
/// This allowable number is a system parameter but is overridden by the user's security group.
/// Next checks that the user has chanhged the password since the user was first created in the code tables.
/// 超过密码时效性的也得强制修改密码
ClassMethod IsRequiredToChangePassword(userid As %Library.String, groupid As %Library.String = "")
{
}

/// by wanghc 2014-11-24
/// 
/// @param: username  用户登录名称
/// @param: password  加密码后的串 先m加密,现md5加密
/// 
/// @other: w ##class(web.SSUser).IsValidUserMd5Password("742","7DDEB10883804C0C04911262A37E420C")
/// @other: 2014-10-11 修改密码传输方式. encpassword = md5($$ENCR^SSUTIL2(srcpassword))
/// 0^UserNotFindErr         -用户不存在
/// -userid^UnActiveErr      -未激活
/// -userid^DateFromScopeErr -未到用户开启日
/// -userid^DateToScopeErr   -用户有效期已过
/// -userid^PasswordErr      -密码错误
ClassMethod IsValidUserMd5Password(username As %String, password As %String, overrideauthentication As %Library.Boolean = 0, RSID = "") As %String
{
}

/// by wuqk 2011-05-24
/// 0^PasswordErr^UserNotFindErr         0^用户或密码错误-外部提示^用户不存在-详细提示
/// -userid^UnActiveErr      -未激活
/// -userid^DateFromScopeErr -未到用户开启日
/// -userid^DateToScopeErr   -用户有效期已过
/// -userid^PasswordErr      -密码错误
ClassMethod IsValidUser(username As %String, password As %String, overrideauthentication As %Library.Boolean = 0) As %String
{
}

ClassMethod ListAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListAllFetch ]
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod ListAllExecute(ByRef QHandle As %Library.Binary, Surname As %Library.String = "", GivenName As %Library.String = "", DefLoginLoc As %Library.String = "", NewStaffOnly As %Library.String = "", UserInputID As %Library.String, UserName As %Library.String, SSGRPDesc As %Library.String = "", CTCPTDesc As %Library.String = "", HOSPDesc As %Library.String = "", RUDesc As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod ListAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListAllExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBrokerInitials(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerWithInactive(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Log 60188 - 18.08.2006
ClassMethod LookUpCashiersBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Sets %session variables for the user and user groups
/// used in logon and switching user - ValidatePin method
/// zhaocz-- 201105-25
ClassMethod SetUserSessionData(userid As %Library.String, groupid As %Library.String = "")
{
}

/// zhaocz 2011-06-16 add
/// 说明：  fieldname = 密码 元素^ 用户元素
/// 
ClassMethod ValidatePIN(UserCode As %Library.String, PIN As %Library.String, compid As %Library.String = "", fieldname As %Library.String = "", ChangeSessionData As %Library.Boolean = 1) As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// wanghc 在这判定有没有权限更改
/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save
ClassMethod websysBeforeSaveSecMsg(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KK 16/jul/02 Log 23459  called by Update of  SSUser.EditsystemSecurityMsg 
ClassMethod websysSaveSecurityMsg()
{
}

/// wanghc
/// KK 11/jul/02 Log 23316  called by Update of  SSUser.Edit 
ClassMethod websysSaveUCP(id As %Library.String)
{
}

/// Log# 58919 TT Apr/2006, get default care provider's name
ClassMethod GetDefaultCareProviderDesc() As %String
{
}

/// Log 60188
ClassMethod LookUpCashiersExecute(ByRef QHandle As %Binary, desc As %String = "") As %Status
{
}

ClassMethod LookUpCashiersFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCashiersExecute ]
{
}

ClassMethod LookUpCashiersClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpCashiersExecute ]
{
}

Query FindAll() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name")
{
SELECT SSUSR_RowID,SSUSR_Name
FROM SQLUser.SS_User
}

Query FindByDefaultLoc(LocID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name")
{
SELECT SSUSR_RowID,SSUSR_Name
FROM SQLUser.SS_User
WHERE (SSUSR_DefaultDept_DR = :LocID)
}

Query FindByGroup(groupid As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name")
{
SELECT SSUSR_RowID,SSUSR_Name
FROM SQLUser.SS_User
WHERE (SSUSR_Group=:groupid AND SSUSR_Active='Y')
}

/// by wuqk 2011-05-27
Query ListAll(Surname As %String, GivenName As %String, DefLoginLoc As %String, NewStaffOnly As %String, UserInputID As %String, UserName As %String, SSGRPDesc As %String, CTCPTDesc As %String, HOSPDesc As %String, RUDesc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SSUSRRowId,SSUSRLoginID,SSUSRInitials,SSUSRName,CTLOCDesc,SSGRPDesc,SSUSRSurname,SSUSRGivenName,SSGRPSecurityLevel")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpActive(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SSUSR_Name, SSUSR_RowID, SSUSR_Initials
 FROM	SQLUser.SS_User
 WHERE	((%ALPHAUP SSUSR_Name [ %ALPHAUP :desc) OR (:desc IS NULL))
 AND	(SSUSR_Active = 'Y')
 ORDER	BY SSUSR_Name
}

/// KK 16/Oct/2002 Log 28625 Lookup query for User field in webcomon.DateFromTo.custom component
Query LookUpActiveByGroup(desc As %String, SGRP As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
 SELECT SSUSR_Name, SSUSR_RowID, SSUSR_Initials
 FROM	SQLUser.SS_User
 WHERE	((%ALPHAUP SSUSR_Name [ %ALPHAUP :desc) OR (:desc IS NULL)) 
 AND	(SSUSR_Active = 'Y')
 AND (({fn CONCAT( '^', {fn CONCAT((:SGRP),'^')})} [ {fn CONCAT( '^', {fn CONCAT((SSUSR_Group),'^')})}) OR (:SGRP IS NULL))
 ORDER	BY SSUSR_Name
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpActiveInitials(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SSUSR_Initials, SSUSR_RowID, SSUSR_Name
 FROM	SQLUser.SS_User
 WHERE	((%ALPHAUP SSUSR_Name [ %ALPHAUP :desc) OR (:desc IS NULL)) 
 AND	(SSUSR_Active = 'Y')
 ORDER	BY SSUSR_Name
}

Query LookUpWithInactive(desc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Code:%Library.String,Name:%Library.String,HIDDEN,IsActive:%Library.String")
{
SELECT SSUSR_Initials,SSUSR_Name,SSUSR_RowID,SSUSR_Active
FROM SQLUser.SS_User
WHERE (SSUSR_Initials %STARTSWITH :desc)
OR (SSUSR_Name %STARTSWITH :desc)
ORDER BY SSUSR_Initials
}

///  Log 60188 - 18.08.2006 - To find users who are tagged as Cashiers
Query LookUpCashiers(desc As %String = "") As %Query(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
}

/// Log 63799
ClassMethod ViewedDisclaimer(compref As %String)
{
}

/// 2013.1.14 更新默认登录科室,将原默认登录位置与新默认登录位置信息对调
/// 20140619 修改了SSUser.UpdateDefaultDept.js的SetGroupByDet方法.hospitalID改成hospitail
/// d ##class(web.SSUser).UpdateDefaultDept(defaultLogDept,Id, hospital, groupDesc)
ClassMethod UpdateDefaultDept(defaultLogDept As %String, ID As %String, hospital As %String, groupDesc As %String)
{
}

ClassMethod LookUpSelectedGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSelectedGroupFetch ]
{
}

Query LookUpSelectedGroup(User As %Library.String, hospital As %Library.String, groupdesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Group:%String,Loc:%String,HOSPDesc:%String")
{
}

/// 2011.12.08 查询用户可用登录科室   DHCC
ClassMethod LookUpSelectedGroupExecute(ByRef QHandle As %Library.Binary, user As %Library.String = "", hospital As %Library.String = "", groupdesc As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpSelectedGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSelectedGroupExecute ]
{
}

/// 2011.12.08 查询用户可用登录科室   DHCC
ClassMethod LookUpSelectedGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %Library.String = "", hosp As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query FindByAll(desc As %Library.String, active = "Y") As websys.Query(CONTAINID = 0, ROWSPEC = "UserName:%String,HIDDEN:%String,UserCode:%String")
{
}

ClassMethod FindByAllExecute(ByRef QHandle As %Library.Binary, desc As %Library.String = "", active = "Y") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

}
