/// 用户业务类
Class DHCCL.BLL.SecureUser Extends %RegisteredObject
{

/// w ##class(DHCCL.BLL.SecureUser).GetSignImageByAccount("6601")
ClassMethod GetSignImageByAccount(userAccount As %String) As %String
{
	set account=$System.SQL.UPPER(userAccount)
	set userId=$order(^DHCCL.Config.SecureUserI("Account"," "_account,0))
	set signImage=""
	//&sql(select SignImage into :signImage from dhccl_config.secureuser where rowid=:userId)
	set user=##class(DHCCL.Config.SecureUser).%OpenId(userId)
	do user.SignImage.Rewind()
	set len=1000
	w "S^"
	while(user.SignImage.AtEnd=0)
	{
		w user.SignImage.Read(.len)	
	}
	//set signImage=user.SignImage
	q ""
}

ClassMethod GetSignImageBySSUserID(SSUserID As %String) As %String [ SqlProc ]
{
	set ret=""
	if (##class(User.SSUser).%ExistsId(SSUserID)=0) 
	{
		quit ret	
	}	
	set SSUser=##class(User.SSUser).%OpenId(SSUserID)
	set account=SSUser.SSUSRInitials
	set account=$System.SQL.UPPER(account)
	set userId=$order(^DHCCL.Config.SecureUserI("Account"," "_account,0))
	set user=##class(DHCCL.Config.SecureUser).%OpenId(userId)
	set signImage=""
	&sql(select SignImage into :signImage from dhccl_config.secureuser where rowid=:userId)
	//set signImage=user.SignImage
	set:(signImage=$c(0)) signImage=""
	quit signImage
}

/// w ##class(DHCCL.BLL.SecureUser).GetSSUserIDByCertID("SF140320197501040014")
ClassMethod GetSSUserIDByCertID(certID As %String) As %String [ SqlProc ]
{
	set ret=""
	set secureUserID=$order(^DHCCL.Config.SecureUserI("SignCert"," "_certID,0))
	quit:(##class(DHCCL.Config.SecureUser).%ExistsId(secureUserID)=0) "E^不存在证书ID为"_certID_"的用户！"
	set secureUser=##class(DHCCL.Config.SecureUser).%OpenId(secureUserID)
	set ret=$order(^SSU("SSUSR",0,"SSUSR_Initials",secureUser.Account,0))
	quit:(##class(User.SSUser).%ExistsId(ret)=0) "E^不存在证书ID为"_certID_"的用户！"
	quit "S^"_ret
}

ClassMethod GetUserIDByCertID(certID As %String) As %String [ SqlProc ]
{
	quit:(certID="") ""
	set userInfo=..GetSSUserIDByCertID(certID)
	quit $piece(userInfo,"^",2)
}

ClassMethod GetUserNameByCertID(certID As %String) As %String [ SqlProc ]
{
	quit:(certID="") ""
	set userId=..GetUserIDByCertID(certID)
	set ssUser=##class(User.SSUser).%OpenId(userId)
	quit ssUser.SSUSRName
}

ClassMethod GetUserNameByCareProv(careProvID As %String) As %String
{
	set userId="",userName=""
	&sql(select %ID into :userId from SQLUser.SS_User where SSUSR_CareProv_DR=:careProvID)
	if (##class(User.SSUser).%ExistsId(userId))
	{
		set ssUser=##class(User.SSUser).%OpenId(userId)
		set userName=ssUser.SSUSRInitials	
	}	
	quit userName
}

ClassMethod GetUserIdByCareProv(careProvID As %String) As %String
{
	set userId="",userName=""
	&sql(select %ID into :userId from SQLUser.SS_User where SSUSR_CareProv_DR=:careProvID)
	if (##class(User.SSUser).%ExistsId(userId))
	{
		set ssUser=##class(User.SSUser).%OpenId(userId)
		set userName=ssUser.SSUSRInitials	
	}	
	quit userId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-12-6
/// Description： 	查询手术等级
/// Table：        	OperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperClass")
Query FindSecureUser(locId As %String, account As %String, fullName As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Account,
	   FullName,
	   SignCertID,
	   CASign,
	   %External(CASign) As CASignDesc,
	   %ODBCOUT(AccountSignStartDate) As AccountSignStartDate,
	   %ODBCOUT(AccountSignEndDate) As AccountSignEndDate,
	   DefLoc,
	   DefLoc->Description As DefLocDesc,
	   CareProv
	   from DHCCl_Config.SecureUser
	   where (DefLoc=:locId or :locId is null)
	   and (account=:account or :account is null)
	   and (FullName [ :fullName or :fullName is null)
}

ClassMethod ExistsSignImage(account As %String) As %String
{
	set userId="",userCertID=""
	&sql(select RowId,SignCertID into :userId,:userCertID from dhccl_config.secureuser where account=:account)	
	set secureUser=##class(DHCCL.Config.SecureUser).%OpenId(userId)
	set existsImage="N"
	do secureUser.SignImage.Rewind()
	set len=1000,signImage=""
	while(secureUser.SignImage.AtEnd=0)
	{
		set signImage=signImage_secureUser.SignImage.Read(.len)	
	}
	set:(signImage'="") existsImage="Y"
	quit existsImage_"^"_signImage
}

ClassMethod ValidateSignUser(account As %String, password As %String, retImage As %String = "N") As %String
{
	// 判断用户名和密码是否正确
	set valRet=##class(DHCCL.BLL.Admission).ValidateUser(account,password)
	quit:($p(valRet,"^",1)="E") valRet
	// 判断是否有签名图片
	set existsImageStr=..ExistsSignImage(account)
	set existsImage=$p(existsImageStr,"^",1)
	quit:(existsImage="N") "E^用户没有签名图片。"
	if (retImage="Y")
	{
		w valRet
		w "^"
		w $p(existsImageStr,"^",2)	
		quit ""
	}
	else
	{
		quit valRet	
	}
}

ClassMethod CanAccountSign(account As %String) As %String
{
	set userId="",caSign="",startDate="",endDate="",result="N"
	&sql(select RowId,CASign,AccountSignStartDate,AccountSignEndDate into :userId,:caSign,:startDate,:endDate from dhccl_config.secureuser where account=:account)	
	
	if (caSign="N")
	{
		set today=+$h
		if (startDate>0)&(endDate>0)&(startDate<=endDate)
		{
			
			if (today>endDate)!(today<startDate)
			{
				set result="N"	
			}	
			else
			{
				set result="Y"	
			}	
		}	
	}
	else
	{
		set result="N"	
	}
	quit result
}

}
