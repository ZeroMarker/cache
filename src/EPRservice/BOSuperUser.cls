Class EPRservice.BOSuperUser Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SuperUserService";

ClassMethod SelectALLSUser() As EPRservice.dataset.ESuperUserDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ESuperUserDataset).%New()
 Quit result
}

ClassMethod CreateSuperUser(argESuperUser As EPRservice.entity.ESuperUser) As %String [ WebMethod ]
{
	set objSuperUser = ##class(EPRmeta.SuperUser).%New()
 	Quit:(objSuperUser ="") "" 
 	
 	S UniqueFlag=##class(EPRmeta.SuperUser).CheckCodeUnique(argESuperUser.SupUserID)
 	if '(UniqueFlag=0)
 	{ 
 		Quit "-1"
 	} 
 	
 	if (argESuperUser.IsAdmin="超级管理员")
 	{
	 	s objSuperUser.IsAdmin = "Y"  ///argESuperUser.IsAdmin
 	}
	else
	{
		s objSuperUser.IsAdmin = "N"
	}
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

ClassMethod UpdateSuperUser(argESuperUser As EPRservice.entity.ESuperUser) As %String [ WebMethod ]
{
 S UniqueFlag=##class(EPRmeta.SuperUser).CheckCodeWithIdUnique(argESuperUser.SupUserID,argESuperUser.ID)
 if '(UniqueFlag=0)
 { 
 	Quit "-1"
 }
 
 set objSuperUser = ##class(EPRmeta.SuperUser).%OpenId(argESuperUser.ID)
 Quit:(objSuperUser ="") "0" 
  
 	if (argESuperUser.IsAdmin="超级管理员")
 	{
	 	s objSuperUser.IsAdmin = "Y"  ///argESuperUser.IsAdmin
 	}
	else
	{
		s objSuperUser.IsAdmin = "N"
	}  
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

ClassMethod DeleteSuperUser(AID As %String) As %Boolean [ WebMethod ]
{
	q:(($d(AID) = 0)||(AID = "")) 0	
	set objSuperUser = ##class(EPRmeta.SuperUser).%OpenId(AID)
	Quit objSuperUser.%DeleteId(AID)
}

}
