/// 超级用户信息
Class EPRmeta.SuperUser Extends %Library.Persistent [ Not Abstract, ClassType = persistent, Not Final, ProcedureBlock ]
{

Property IsAdmin As %String(TRUNCATE = 1);

/// 标识编号
Property SupCode As %String(TRUNCATE = 1);

/// 密码
Property SupPassWord As %String(TRUNCATE = 1);

/// 用户编号
Property SupUserID As %Library.String(TRUNCATE = 1);

Property SupUserName As %Library.String(TRUNCATE = 1);

/// 角色表：EPRMeta.MainRole
Property RoleID As %String(TRUNCATE = 1);

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,IsAdmin:%String,SupCode:%String,SupPassWord:%String,SupUserID:%String,SupUserName:%String,RoleID:%String,RoleName:%String,RoleDesc:%String") [ SqlName = SP_SuperUser_SELECTALL, SqlProc ]
{
	SELECT A.%ID AS ID,IsAdmin,SupCode,SupPassWord,SupUserID,SupUserName, RoleID, B.RoleName AS RoleName, B.RoleDesc AS RoleDesc
 	FROM EPRmeta.SuperUser A LEFT JOIN EPRMeta.MainRole B
 	ON A.RoleID = B.ID
	ORDER BY A.SupUserID
}

ClassMethod CheckCodeUnique(argUserId As %String) As %Integer
{
	q:(($d(argUserId)=0) || argUserId = "") 0
	
	set curCount = 0
	&SQL(select count(*) into :curCount from EPRmeta.SuperUser where SupUserID=:argUserId)
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
	&SQL(select count(*) into :curCount from EPRmeta.SuperUser where SupUserID=:argUserId and %ID <> :argId)
	if (curCount = 0)
	{
		q 0
	}
	else
	{
		q 1
	}
}

Storage Default
{
<Data name="SuperUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Sup1</Value>
</Value>
<Value name="3">
<Value>Sup2</Value>
</Value>
<Value name="4">
<Value>Sup3</Value>
</Value>
<Value name="5">
<Value>Sup4</Value>
</Value>
<Value name="6">
<Value>Sup5</Value>
</Value>
<Value name="7">
<Value>SupCode</Value>
</Value>
<Value name="8">
<Value>SupPassWord</Value>
</Value>
<Value name="9">
<Value>SupUserID</Value>
</Value>
<Value name="10">
<Value>SupUserName</Value>
</Value>
<Value name="11">
<Value>IsAdmin</Value>
</Value>
<Value name="12">
<Value>RoleID</Value>
</Value>
<Value name="13">
<Value>RoleName</Value>
</Value>
<Value name="14">
<Value>RoleDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SuperUserD</DataLocation>
<DefaultData>SuperUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.SuperUserD</IdLocation>
<IndexLocation>^DHCEPRM.SuperUserI</IndexLocation>
<StreamLocation>^DHCEPRM.SuperUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
