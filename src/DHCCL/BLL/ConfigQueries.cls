/// 配置数据Query集合
Class DHCCL.BLL.ConfigQueries Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-6-27
/// Description： 	根据用户证书唯一标识符获取用户信息
/// Table：        	DHCCL_Config.SecureUser
/// Input:			userCertID:用户证书唯一标识符
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.ConfigQueries","FindUserByCert","SF140103196009120643")
Query FindUserByCert(userCertID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Account,
	   Password,
	   FullName,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   DefLoc,
	   CareProv,
	   Hospital,
	   DefGroup,
	   ExternalID,
	   SignCertID 
	   from DHCCL_Config.SecureUser
	   where SignCertID=:userCertID
}

/// Creator：      	陈长青
/// CreatDate：    	2018-6-27
/// Description： 	根据用户工号获取用户信息
/// Table：        	DHCCL_Config.SecureUser
/// Input:			accout:用户工号
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.ConfigQueries","FindUserByAccount","panda")
Query FindUserByAccount(account As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Account,
	   Password,
	   FullName,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   DefLoc,
	   CareProv,
	   Hospital,
	   DefGroup,
	   ExternalID,
	   SignCertID 
	   from DHCCL_Config.SecureUser
	   where Account=account
}

}
