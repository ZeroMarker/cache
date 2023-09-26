Class EPRmeta.Privilege.PowerUser Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index GroupUserIndex On (SSGroupID, UserID) [ Unique ];

Index UserIDIndex On UserID [ Unique ];

Property SSGroupID As %String(TRUNCATE = 1);

/// 用户ID(=TrakID)
Property UserID As %String(TRUNCATE = 1);

/// resident, attending, chief doctor
Property UserLevel As %String(TRUNCATE = 1);

/// Chairman//科主任  QCDoc//质控医师  QCNurse//质控护士
Property UserPos As %String(TRUNCATE = 1);

Index UserLevelIndex On (SSGroupID, UserLevel);

/// stores the ChildUsers or UserGroups belong to the user
/// format: ID1^ID2^ID3...
Property ChildUsers As %String(MAXLEN = 20000, TRUNCATE = 1);

Relationship TheChildUsers As EPRmeta.Privilege.ChildUsers [ Cardinality = children, Inverse = ThePowerUser ];

/// if the ChildUsers column stores the UserGroups belong to the user, 
/// for convenience of priveledge configuration and control
Property ControlByGroup As %String(TRUNCATE = 1);

Property IsValid As %String(TRUNCATE = 1);

//RowID of SS_GROUP of Trak

ClassMethod SelectByGroupUserID(argGroupID As %String, argUserID As %String) As %String
{
	s tmpID=""
	&sql(SELECT ID into :tmpID FROM PowerUser
 		WHERE (UserID = :argUserID) and (SSGroupID=:argGroupID)) ;and (IsValid='1'))
 	q tmpID
}

ClassMethod SelectBySSGroupAndLevel(argSSGroupID As %String, argLevel As %String) As %String
{
	k SQLCODE
	s userid="",result=""
	&sql(DECLARE MyCursor CURSOR FOR
		SELECT UserID into :userid
		FROM EPRmeta_Privilege.PowerUser
		where SSGroupID=:argSSGroupID and UserLevel=:argLevel)
	&sql(OPEN MyCursor)
	FOR { &sql(FETCH MyCursor)
        QUIT:SQLCODE
        if (result="") {s result=userid}
        else {s result=result_"^"_userid}
      }
	&sql(CLOSE MyCursor)
	q result
}

/// Function:    IsLogonValid
/// Description: 判断输入的用户名和密码是否合法
/// Input:       parUser: 用户名, parPasswd: 密码
/// Return:      1--合法, 0--非法
/// Others:      usage: w ##class(EPRmeta.Privilege.PowerUser).IsLogonValid("00057",1)--1
///              在调用本方法前，需要先执行: k PLIST，以确保反复执行时结果的正确性
/// 在Cache2010下BS程序在zn调用dhc-medsrc下$$select^MVBSSUSR来验证用户,会导致license不释放的问题            
ClassMethod IsLogonValid(parUser As %String, parPasswd As %String) As %String
{
	s valid=##class(web.SSUser).IsValidUser(parUser,parPasswd) 
	q:(valid>0) 1 
	q 0
}

ClassMethod IsLogonValidOld(parUser As %String, parPasswd As %String) As %String
{
	s $zt="finally"
	s meddata="",websrc=""
	s meddata=##class(EPRmeta.SysOption).GetOptionValueByName("NameSpaceHIS")
	s websrc=$p(meddata,"^",2)
	s meddata=$p(meddata,"^",1)
	q:(meddata="") 0
	q:(websrc="") 0
	
	s valid=-1
	s EnsembleLoginVersion = ##class(EPRmeta.SysOption).GetOptionValueByName("EnsembleLoginVersion")
	if (EnsembleLoginVersion="") 
	{
	   d $ZU(5,meddata)
       s valid=$$select^MVBSSUSR(parUser,parPasswd)
       d $ZU(5,websrc)
	}  
	i (EnsembleLoginVersion="EnsembleOther") {s valid=$$select^MVBSSUSR(parUser,parPasswd)}
	i (EnsembleLoginVersion="Ensemble2010") {s valid=##class(web.SSUser).IsValidUser(parUser,parPasswd,1)}
	q:(valid=0) 1
	q 0
	
finally
	q 0
}

/// Function:    GetUserLevel
/// Description: 取得用户的级别
/// Input:       parUserID: 用户ID
/// Return:      用户级别（Resident, Attending, Chief, ""）
/// Others:      usage: w ##class(EPRmeta.Privilege.PowerUser).GetUserLevel("848")--Resident
///              UserID没有重复记录
ClassMethod GetUserLevel(parUserID As %String) As %String
{
	s level=""
	&sql(SELECT UserLevel into :level FROM EPRmeta_Privilege.PowerUser
 		WHERE (UserID = :parUserID))
 	q level
}

ClassMethod GetUserPos(parUserID As %String) As %String
{
	s pos=""
	&sql(SELECT UserPos into :pos FROM EPRmeta_Privilege.PowerUser
 		WHERE (UserID = :parUserID))
 	q pos
}

ClassMethod CheckUserLevel(parUserID As %String, usrLevel As %String) As %String
{
	s ret="0"
	s level=""
	if (parUserID="") || (usrLevel="") { q "0" }
	&sql(SELECT UserLevel into :level FROM EPRmeta_Privilege.PowerUser
 		WHERE (UserID = :parUserID))
	//主任、副主任看成一个级别
	if (level="ViceChief")
	{
		q:((usrLevel="ViceChief")||(usrLevel="Chief")) "1" 
	}
 
	if ("Y"=##Class(EPRmeta.SysOption).GetOptionValueByName2("HighLevelOperate","N"))
	{		
		q:((level="ViceChief")||(level="Chief")) "1"  // 主任
	}
		
	q:(usrLevel=level) "1"
	
	q "0"
}

/// Function: GetUserLevelNew
/// Description: 取得用户的级别
/// Input: parUserID: 用户ID
/// Return: 用户级别（Resident=1, Attending=2, Chief=3, ""）
/// Others: usage: w ##class(EPRmeta.Privilege.PowerUser).GetUserLevel("15")--2  ////(1037)--3///(1178)--1
/// UserID没有重复记录
ClassMethod GetUserLevelNew(parUserID As %String) As %String
{
	s level="",UserLevel=""
	s UserID=parUserID
	&sql(SELECT UserLevel into :level FROM PowerUser
	WHERE (UserID = :parUserID))
	if level="Resident" { set UserLevel= 1}
	elseif level="Attending" {set UserLevel=2 }
	elseif level="Chief" {set UserLevel=3 }
	elseif level="ViceChief" {set UserLevel=3 } //加入副主任级别
	else {set UserLevel=0 } //+<added by houj, supposed by liaowp on 2010-02-22>
	;s level=orgUserLevel
	q UserLevel
}

/// 删除某个组下面的某个用户 not in use
ClassMethod DelUser(argGroupID As %String, argUserID As %String) As %String
{
	k SQLCODE
	&sql(delete from PowerUser
	where SSGroupID=:argGroupID and UserID=:argUserID)
	q SQLCODE
}

/// not in use
ClassMethod FindAllChildUsers(argUserID As %String) As %List
{
	/*,argSSGroupID as %String*/
	/*s tmpChildUsers=""
	&sql(SELECT ChildUsers into :tmpChildUsers FROM DHC_EPR.PowerUser where UserID=:argUserID and SSGroupID=:argSSGroupID)
	q tmpChildUsers*/
	
	k %msql
	s result=""
	Set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
	If rs.QueryIsValid()
	{	
		Do rs.Prepare("SELECT ChildUsers FROM DHC_EPR.PowerUser where UserID=? and SSGroupID=?")
		Set status=rs.Execute(argUserID,argSSGroupID) // no parameters required
		If 'status Quit ""
		WHILE rs.Next()
		{
			s result=result_rs.Data("ChildUsers")
		}
	}
	q result
}

/// not in use
ClassMethod FindChildUsers(argGroupID As %String, argUserID As %String, ByRef argResult As %List) As %String
{
	;s argResult=$lb("")
	s tmpID=""
	
	q:'$d(argGroupID)||(argGroupID="") "100"
	q:'$d(argUserID)||(argUserID="") "100"
	
	k SQLCODE
	
	&sql(select ID into :tmpID from PowerUser 
	where SSGroupID=:argGroupID and UserID=:argUserID and IsValid='1')
	
	q:(SQLCODE'=0) "100"
	q:'$d(tmpID)||(tmpID="") "100"
	
	s tmpUser=##class(DHC.EPR.PowerUser).%OpenId(tmpID)
	i tmpUser="" s result=0
	e  d
	.s argResult=tmpUser.ChildUsers
	.s result=1
	
	q:(result=1) tmpUser.ControlByGroup
	q "100"
}

/// not in use
ClassMethod GetUserCTPCPID(argUserID As %String) As %String
{
	;b "S"
	s ssuser=""
	Set ssuser=##class(DHC.SSUser).%OpenId(argUserID)
	q:(ssuser="") ""
	q ssuser.SSUSRCareProvDR.CTPCPRowId ;SSUSRCTPCPDR????
}

/// 取出用户所在科室名称
/// used by epr.newfw.actionauthorize.csp
ClassMethod GetUserLoc(argUserID As %String) As %String
{
	q:(argUserID = "") ""
	s ssuser = ##Class(User.SSUser).%OpenId(argUserID)
	q:(ssuser="") ""
	s locDesc = ""
	s locDesc = ssuser.SSUSRDefaultDeptDR.CTLOCDesc
	s:(locDesc [ "-") locDesc = $p(locDesc,"-",2)
	q locDesc
}

/// 取出用户所在科室RowID
/// used by epr.newfw.actionauthorize.csp
ClassMethod GetUserLocID(argUserID As %String) As %String
{
	q:(argUserID = "") ""
	s locID = ""
	&sql(SELECT ssusr_defaultdept_dr INTO :locID FROM sqluser.ss_user WHERE ssusr_rowid = :argUserID) 
	q locID
}

/// 从SSUser中取出用户名字
/// used by ##class(EPRinstance.EPRLogs).GetCurrStatus
ClassMethod GetUserName(argUserID As %String) As %String
{
	s ssuser=""
	Set ssuser=##class(User.SSUser).%OpenId(argUserID)
	q:(ssuser="") ""
	q ssuser.SSUSRName
}

/// 通过用户名取得用户ID
ClassMethod GetUserId(argUserInitials As %String) As %String
{
	q:(argUserInitials="") ""
	s id = ""
	s id = $O(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(argUserInitials,"U"),""))
	q id
}

/// 更新用户的子用户 not in use
ClassMethod UpdateUser(argGroupID As %String, argUserID As %String, argChildUser As %String, argControlByGroup As %String) As %String
{
	k SQLCODE
	&sql(update PowerUser set ChildUsers=:argChildUser, ControlByGroup=:argControlByGroup
	where SSGroupID=:argGroupID and UserID=:argUserID)
	q SQLCODE
}

Storage Default
{
<Data name="PowerUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChildUsers</Value>
</Value>
<Value name="3">
<Value>ControlByGroup</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>SSGroupID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>UserLevel</Value>
</Value>
<Value name="8">
<Value>UserPos</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PowerUserD</DataLocation>
<DefaultData>PowerUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PowerUserD</IdLocation>
<IndexLocation>^DHCEPRM.PowerUserI</IndexLocation>
<StreamLocation>^DHCEPRM.PowerUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
