/// Desc:       身份验证
/// Creator:    Candy
/// CreateDate: 2014-7-14
Class EMRservice.Ajax.verification Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s userCode = $Get(%request.Data("UserCode", 1), "-1")
	s pwd = $Get(%request.Data("Password", 1), "-1")
	w ..GetUserInfo(userCode,pwd)
	Quit $$$OK
}

/// Desc:       验证用户,返回用户信息
/// Creator:    Candy
/// CreateDate: 2014-8-20
/// Input:      AUserCode 用户工号
///             APassword 用户密码   
/// Output:     UserID,UserName,level
/// Debug:      w ##Class(EMRservice.Ajax.verification).GetUserInfo(337,"")
ClassMethod GetUserInfo(AUserCode As %String, APassword As %String) As %String
{
	s $zt = "ErrorHandler"	
	s json = ""
	q:(AUserCode = "") json
	
	k PLIST	
	///验证用户
	if (APassword '= "")
	{
		s loginValid = ##class(EMRservice.BL.BLPowerUser).IsLogonValid(AUserCode,APassword)	
	   	q:(loginValid = 0) json
	}
    s userID = ##class(EMRservice.BL.BLPowerUser).GetUserId(AUserCode)
	q:(userID = "") json
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userID)
    s levelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(userID)
    s levelDesc = ""
    s levelRowId = $o(^DHCEMRM.UserLevelI("NameIndex"," "_$zcvt(levelCode,"U"),""))
    if (levelRowId '= "")
    {
   		s objUserLevel = ##Class(EMRmeta.UserLevel).%OpenId(levelRowId)
   		s:(objUserLevel '= "") levelDesc = objUserLevel.Description
    }
   	s json = "{'UserID':'"_userID_"','UserName':'"_userName_"','UserLevel':'"_levelCode_"','LevelDesc':'"_levelDesc_"'}"
   	q json
ErrorHandler 
    q ""
}

}
