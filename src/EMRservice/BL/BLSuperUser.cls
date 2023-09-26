/// 名称:EMRservice.BL.BLSuperUser
/// 描述:用户信息BL
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BL.BLSuperUser Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,IsAdmin:%String,SupCode:%String,SupPassWord:%String,SupUserID:%String,SupUserName:%String,RoleID:%String,RoleName:%String,RoleDesc:%String") [ SqlName = SPM_SuperUser_SELECTALL, SqlProc ]
{
	SELECT A.%ID AS ID,IsAdmin,SupCode,SupPassWord,SupUserID,SupUserName, RoleID, B.RoleName AS RoleName, B.RoleDesc AS RoleDesc
 	FROM EMRmeta.SuperUser A LEFT JOIN EMRmeta.MainRole B
 	ON A.RoleID = B.ID
	ORDER BY A.SupUserID
}

ClassMethod CheckCodeUnique(argUserId As %String) As %Integer
{
	q:(($d(argUserId)=0) || argUserId = "") 0
	
	set curCount = 0
	&SQL(select count(*) into :curCount from EMRmeta.SuperUser where SupUserID=:argUserId)
	if (curCount = 0)
	{
		q 0
	}
	else
	{
		q 1
	}
}

ClassMethod CheckCodeWithIdUnique(argUserId As %String, argId As %String) As %Integer
{
	q:(($d(argUserId)=0) || argUserId = "") 0
	q:(($d(argId)=0) || argId = "") 0
	
	set curCount = 0
	&SQL(select count(*) into :curCount from EMRmeta.SuperUser where SupUserID=:argUserId and %ID <> :argId)
	if (curCount = 0)
	{
		q 0
	}
	else
	{
		q 1
	}
}

ClassMethod CreateSuperUser(argESuperUser As EMRservice.entity.ESuperUser) As %String [ WebMethod ]
{
	set objSuperUser = ##class(EMRmeta.SuperUser).%New()
 	Quit:(objSuperUser ="") "" 
 	
 	S UniqueFlag=##Class(EMRservice.BL.BLSuperUser).CheckCodeUnique(argESuperUser.SupUserID)
 	if '(UniqueFlag=0)
 	{ 
 		Quit "-1"
 	} 
 	
	s objSuperUser.IsAdmin = ""  ///argESuperUser.IsAdmin
	s objSuperUser.SupCode = argESuperUser.SupCode
	s objSuperUser.SupPassWord = argESuperUser.SupPassWord
	s objSuperUser.SupUserID = argESuperUser.SupUserID
	s objSuperUser.SupUserName = argESuperUser.SupUserName
    s objSuperUser.RoleID  = argESuperUser.RoleID  
	
 	if '(objSuperUser.%Save())
 	{
		Quit "0" 
	}
	
 	Quit objSuperUser.%Id()
}

ClassMethod UpdateSuperUser(argESuperUser As EMRservice.entity.ESuperUser) As %String [ WebMethod ]
{
 S UniqueFlag=##Class(EMRservice.BL.BLSuperUser).CheckCodeWithIdUnique(argESuperUser.SupUserID,argESuperUser.ID)
 if '(UniqueFlag=0)
 { 
 	Quit "-1"
 }
 
 set objSuperUser = ##Class(EMRmeta.SuperUser).%OpenId(argESuperUser.ID)
 Quit:(objSuperUser ="") "0" 
  
 //s objSuperUser.IsAdmin = argESuperUser.IsAdmin
 s objSuperUser.SupCode = argESuperUser.SupCode
 //s objSuperUser.SupPassWord = argESuperUser.SupPassWord
 s objSuperUser.SupUserID = argESuperUser.SupUserID
 s objSuperUser.SupUserName = argESuperUser.SupUserName
 s objSuperUser.RoleID  = argESuperUser.RoleID 
	
 if '(objSuperUser.%Save())
 {
 	Quit "0" 
 }
 Quit "1"
}

}
