/// 签名服务类
Class CIS.AN.CA.SignService Extends (%RegisteredObject, %CSP.Page)
{

ClassMethod OnPage() As %Status
{
	try
	{
		set VenderCode=$g(%request.Data("VenderCode", 1), "")
		set SignType=$g(%request.Data("SignType", 1), "")
		set Action = $g(%request.Data("Action", 1), "")
		set Params = $g(%request.Data("Params", 1), "")
		if (Action="GetConfig")
		{
			write ##class(CIS.AN.CA.SignService).GetConfigJson(VenderCode,SignType)
		} 
		else 
		{
			write ##class(CIS.AN.CA.SignService).GetData(VenderCode,SignType,Action,Params)
		}
	}
	catch exp
	{
		set errorMsg=$ZERROR
		write "{ErrorMsg:"""_errorMsg_"""}"
	}
	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.CA.SignService","FindCASignConfig")
Query FindCASignConfig() As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       VenderCode,
       SignType,
       SignDesc,
       IsDefault,
       %External(IsDefault) As IsDefaultDesc
       from CF_AN.CASignConfig
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.CA.SignService","FindCASignConfigOption",1)
Query FindCASignConfigOption(signConfigId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       CASignConfig,
       Key,
       Value
       from CF_AN.CASignConfigOption
       where (CASignConfig=:signConfigId)
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.CA.SignService","FindCASignScript",1)
Query FindCASignScript(signConfigId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       CASignConfig,
       JScriptPath,
       Note
       from CF_AN.CASignScript
       where (CASignConfig=:signConfigId)
}

/// w ##class(CIS.AN.CA.SignService).SaveDefaultSignConfig(2)
ClassMethod SaveDefaultSignConfig(configId As %String) As %String
{
	quit:'##class(CF.AN.CASignConfig).%ExistsId(configId) "E^configId不存在"
	
	&sql(update SQLUser.CF_AN.CASignConfig set IsDefault="Y" where RowId=:configId)
	&sql(update SQLUser.CF_AN.CASignConfig set IsDefault="N" where RowId<>:configId)
	
	quit "S^"
}

/// w ##class(CIS.AN.CA.SignService).GetDefaultSignConfigId()
ClassMethod GetDefaultSignConfigId()
{
	set configId=""
	&sql(select RowId into :configId from SQLUser.CF_AN.CASignConfig where IsDefault="Y")
	quit configId
}

/// w ##class(CIS.AN.CA.SignService).GetConfigJson("YXQ","Phone")
ClassMethod GetConfigJson(venderCode As %String, signType As %String) As %String
{
	set result="{"
	
	set configId=""
	&sql(select RowId into :configId from SQLUser.CF_AN.CASignConfig where VenderCode=:venderCode and SignType=:signType)
	if (##class(CF.AN.CASignConfig).%ExistsId(configId))
	{
		set i=0
		set query=##class(%ResultSet).%New("CIS.AN.CA.SignService:FindCASignConfigOption")
        set sc=query.Execute(configId)
        while(query.%Next())
        {
            set Key=query.Get("Key")
            set Value=query.Get("Value")
            if (i=0)
            {
	            set result=result_""""_Key_""":"""_Value_""""
	        }
	        else
	        {
		        set result=result_","""_Key_""":"""_Value_""""
		    }
            set i=i+1
        }
	}
	set result=result_"}"
	quit result
}

ClassMethod GetData(VenderCode As %String, SignType As %String, Action As %String, Params As %String) As %String
{
	set $zt="Error"
	set result=""
	set className= "CIS.AN.CA."_VenderCode_"."_SignType_"Service"
	if (##class(%ClassDefinition).%ExistsId(className))
	{
		set service=$classmethod(className,"%New")
		if (Action="GetLoginQR")
		{
			set sc=##class(CIS.AN.COM.String).ToArray(Params,.array)
			m firstData=array(1)
			set result=service.GetLoginQR(firstData("token"))
		}
	}
	quit "{""resultCode"":0,""resultContent"":"""_result_"""}"

Error
	set $zt=""
	quit "{""resultCode"":0,""resultContent"":"""_$ze_"""}"
}

ClassMethod OutputCASignTestJsPath(VenderCode As %String, SignType As %String)
{
	set configId=""
	&sql(select RowId into :configId from SQLUser.CF_AN.CASignConfig where VenderCode=:VenderCode and SignType=:SignType)
	if (##class(CF.AN.CASignConfig).%ExistsId(configId))
	{
		set query=##class(%ResultSet).%New("CIS.AN.CA.SignService:FindCASignScript")
        set sc=query.Execute(configId)
        while(query.%Next())
        {
            set JScriptPath=query.Get("JScriptPath")
            write !,"<script type=""text/javascript"" src="""_JScriptPath_"""></script>"
        }
        write !,"<script type=""text/javascript"" src=""../service/dhcanop/js/CA/CIS.AN.CA."_VenderCode_"."_SignType_".js""></script>"
	}
}

/// w ##class(CIS.AN.CA.SignService).GetSignImageByUserCode("ys01")
ClassMethod GetSignImageByUserCode(userCode As %String) As %String
{
	//quit "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"

	quit:userCode="" ""
	set signImage=""
	set userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	if (userId'="")
	{
		set signInfo=##class(CIS.AN.CA.UsrSignatureInfo).GetInUseInfo(userId)
		if signInfo'="" set signImage=signInfo.SignImage
	}
	quit signImage
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.CA.SignService","FindUsrSignatureInfo","")
Query FindUsrSignatureInfo(userID) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,
   UsrID,
   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",UsrID) As UsrName,
   IdentityID,
   Certificate,
   CertificateNo,
   UKeyNo,
   SignImage,
   UsrCertCode,
   CertName,
   %ODBCOUT(CreateDate),
   %ODBCOUT(CreateTime),
   InUse
   from CIS_AN.CA.UsrSignatureInfo
   where (UsrID = :userID) or (:userID is null)
}

}
