Class dhc.pa.udata.Certification Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.pa.udata.Certification).Certification("admin","ceb4f32325eda6142bd65215f4c0f371")
/// Others: w ##class(dhc.pa.udata.Certification).Certification("demo","1")
ClassMethod Certification(username, password) As %String
{
	n (username,password)
	
	//同步数据库
	d ..SynchDataBase()
	//判断用户名与密码
	s flag = ..JudgeByUserInfo(username,password)
	
	q:flag="true" 0
	q:flag="false" 1
}

/// w ##class(dhc.pa.udata.Certification).SynchDataBase()
/// 操作PA.USERS
ClassMethod SynchDataBase() As %String
{
	;s sqlStr="SELECT Param_rowid,Param_code,Param_name,Param_shortcut,Param_desc,Param_value FROM dhc_pa_data.Param WHERE %ID>0"
	s sqlStr="select CCODE,CPASS FROM NETPRO.TSYSUSER WHERE USERID>0"
	;W sqlStr,!			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;W result.Next(),!
	While(result.Next())
	{
		s userName=result.Data("CCODE")
		s passwd=result.Data("CPASS")
		;W userName,!
		s rowid=..IfRepName(userName)
		i rowid=0 d // 说明没有此记录,需要添加记录
		.d ..Insert(userName,passwd)
		e  d //说明有此记录，需要修改
		.d ..Update(rowid,userName,passwd)
	}
}

/// Others: w ##class(dhc.pa.udata.Certification).IfRepName("admin")
/// 操作dhc_pa_data.Users
ClassMethod IfRepName(userName) As %String
{
	n (userName)
	
	s rowid=0
	s rowid=$o(^DHCCJXPAUSER(0,"Name",userName,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others: w ##class(dhc.pa.udata.Certification).Insert("admin","aaaaa")
/// 操作dhc_pa_data.Users
ClassMethod Insert(userName, passwd) As %String
{
	n (userName,passwd)
		
	&sql(insert into dhc_pa_data.Users(UserName,Passwd) values(:userName,:passwd))
	q SQLCODE
}

/// Others：w ##class(dhc.pa.udata.Certification).Update(1,"admin","aaaaa")
/// 操作dhc_pa_data.Users
ClassMethod Update(rowid, userName, passwd) As %String
{
	n (rowid,userName,passwd)
		
	&SQL(UPDATE dhc_pa_data.Users set UserName=:userName,Passwd=:passwd where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.Certification).JudgeByUserInfo("admin","123")
/// 操作dhc_pa_data.Users
ClassMethod JudgeByUserInfo(username, password) As %String
{
	n (username,password)
	
	s rowid=0,passwd="",flag="false"
	i $D(^DHCCJXPAUSER(0,"Name",username)) d
	.s rowid=$O(^DHCCJXPAUSER(0,"Name",username,rowid))
	.i rowid'="" d
	..s passwd=$P(^DHCCJXPAUSER(rowid),"^",2)
	..i passwd=password d // 登陆验证通过
	...s flag="true"
	
	q flag
}

/// Others: w ##class(dhc.pa.udata.Certification).Handler("ZHY","ZHY")
ClassMethod Handler(username, password) As %String
{
	n (username, password)
	
	q:username="" 1
	q:password="" 1
	
	s flag=0
	
	//1.取出当前用户的Trakcare系统的密码
	s trakcareOldPasswd = ..getPasswordByUserName(username)
	//2.对现在的原文密码进行加密
	s trakcareNewPasswd = ..getNewPassword(password)
	//3.和cache数据库中的密码进行对比
	s validValue = ..getValidValue(trakcareOldPasswd,trakcareNewPasswd)
	//4.对比结果一样,则不修改,否则对cache数据库中的密码进行修改处理
	i validValue'=0 d //表示两个密码不相等,需要修改
	.s flag = ..updatePasswd(username,trakcareNewPasswd)
	
	q flag
}

/// w ##class(dhc.pa.udata.Certification).updatePasswd("fhq","U&dDF1,"7k7k")
/// 操作SSUser
ClassMethod updatePasswd(username, trakcareNewPasswd) As %String
{
	n (username,trakcareNewPasswd)
	
	s flag=0
	
	q:username="" 1
	q:trakcareNewPasswd="" 1
	
	&SQL(update SQLUser.SS_User set SSUSR_Password=:trakcareNewPasswd where SSUSR_Initials=:username)
	s flag = SQLCODE
	
	q flag
}

/// w ##class(dhc.pa.udata.Certification).getPasswordByUserName("fhq")
/// 操作SSUser
ClassMethod getPasswordByUserName(username) As %String
{
	n (username)
	
	s password=""
	q:username="" password
	
	s sqlStr="select SSUSR_Password from SQLUser.SS_User where SSUSR_Initials='"_username_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s password=result.Data("SSUSR_Password")
	}
	
	q password
}

/// w ##class(dhc.pa.udata.Certification).getNewPassword(1)
/// 操作SSUser
ClassMethod getNewPassword(password) As %String
{
	n (password)
	
	s newPassword=""
	q:password="" newPassword
	s newPassword = ##class(web.SSUser).Encrypt(password)
	
	q newPassword
}

/// w ##class(dhc.pa.udata.Certification).getValidValue(1,2)
ClassMethod getValidValue(trakcareOldPasswd, trakcareNewPasswd) As %String
{
	n (trakcareOldPasswd,trakcareNewPasswd)
	
	q:trakcareOldPasswd="" 1
	q:trakcareNewPasswd="" 1
	
	//如果两个密码相等就返回0,不相等就返回1
	q:trakcareOldPasswd=trakcareNewPasswd 0
	q:trakcareOldPasswd'=trakcareNewPasswd 1
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.CertificationS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
