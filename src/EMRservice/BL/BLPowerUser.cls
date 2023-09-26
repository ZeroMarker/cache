Class EMRservice.BL.BLPowerUser Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod SelectByGroupUserID(argGroupID As %String, argUserID As %String) As %String
{
	s tmpID=""
	&sql(SELECT ID into :tmpID FROM EMRmeta.PowerUser
 		WHERE (UserID = :argUserID) and (SSGroupID=:argGroupID)) ;and (IsValid='1'))
 	q tmpID
}

ClassMethod SelectBySSGroupAndLevel(argSSGroupID As %String, argLevel As %String) As %String
{
	q:($d(argSSGroupID)=0)||($d(argLevel)=0)||(argSSGroupID="") 0
	k SQLCODE
	s userid="",result=""
	&sql(DECLARE MyCursor CURSOR FOR
		SELECT UserID into :userid
		FROM EMRmeta.PowerUser
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
/// Input:       parUser: 用户名, parPasswd: 密码，hospitalID：院区ID
/// Return:      1--合法, 0--非法
/// Others:      usage: w ##class(EMRmeta.PowerUser).IsLogonValid("00057",1)--1
///              在调用本方法前，需要先执行: k PLIST，以确保反复执行时结果的正确性
/// 在Cache2010下BS程序在zn调用dhc-medsrc下$$select^MVBSSUSR来验证用户,会导致license不释放的问题        
ClassMethod IsLogonValid(parUser As %String, parPasswd As %String, hospitalID As %String = "") As %String
{
    //前端对密码做base64编码
	s parPasswd = ##class(%SYSTEM.Encryption).Base64Decode(parPasswd)
    
	//签名时校验密码，当配置“SIGN”时，与签名密码校验；否则与登录密码校验
	s signCheckWay = ##Class(EMRservice.SystemParameter).getSignCheckObj(hospitalID)
	if (signCheckWay = "SIGN")
	{
		s userID = $o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(parUser,"U"),""))
		s valid = ##Class(EMRservice.BL.BLPowerUser).IsSignValid(userID,parPasswd)
		q valid
	}
	else
	{
		s valid=##class(web.SSUser).IsValidUser(parUser,parPasswd) 
		q:(valid>0) 1 
		q 0
	}
}

/// Desc: 		 用户UserId的签名密码与输入签名密码是否相同
/// Input:       UserId： 用户id, parPasswd: 签名密码
/// Return:      1--相同, 0--不同
/// Others:      w ##Class(EMRservice.BL.BLPowerUser).IsSignValid("10209",1)         
ClassMethod IsSignValid(UserId As %String, Password As %String) As %String
{
	s sureEncryPasswd = $p(^SSU("SSUSR",UserId),"^",15)
	s noSureEncryPasswd = ##class(web.SSUser).Encrypt(Password)
	q:(sureEncryPasswd = noSureEncryPasswd) 1
	q 0
}

ClassMethod IsLogonValidOld(parUser As %String, parPasswd As %String) As %String
{
	s $zt="finally"
	s meddata="",websrc=""
	s meddata=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("NameSpaceHIS")
	s websrc=$p(meddata,"^",2)
	s meddata=$p(meddata,"^",1)
	q:(meddata="") 0
	q:(websrc="") 0
	
	s valid=-1
	s EnsembleLoginVersion = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("EnsembleLoginVersion")
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
/// Others:      usage: w ##class(EMRmeta.PowerUser).GetUserLevel("848")--Resident
///              UserID没有重复记录
ClassMethod GetUserLevel(parUserID As %String) As %String
{
	s level=""
	&sql(SELECT UserLevel into :level FROM EMRmeta.PowerUser
 		WHERE (UserID = :parUserID))
 	q level
}

ClassMethod GetUserPos(parUserID As %String) As %String
{
	s pos=""
	&sql(SELECT UserPos into :pos FROM EMRmeta.PowerUser
 		WHERE (UserID = :parUserID))
 	q pos
}

ClassMethod CheckUserLevel(parUserID As %String, usrLevel As %String) As %String
{
	s ret="0"
	if (parUserID="") || (usrLevel="") { q "0" }
	&sql(SELECT UserLevel into :level FROM EMRmeta.PowerUser
 		WHERE (UserID = :parUserID))	
	
	//主任、副主任看成一个级别
	if (level="ViceChief")
	{
		q:((usrLevel="ViceChief")||(usrLevel="Chief")) "1" 
	}
	
	q:(usrLevel=level) "1"
	
	q "0"
}

/// Function: GetUserLevelNew
/// Description: 取得用户的级别
/// Input: parUserID: 用户ID
/// Return: 用户级别（Resident=1, Attending=2, Chief=3, ""）
/// Others: usage: w ##class(EMRmeta.PowerUser).GetUserLevel("15")--2  ////(1037)--3///(1178)--1
/// UserID没有重复记录
ClassMethod GetUserLevelNew(parUserID As %String) As %String
{
	s level="",UserLevel=""
	s UserID=parUserID
	&sql(SELECT UserLevel into :level FROM EMRmeta.PowerUser
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
	&sql(delete from EMRmeta.PowerUser
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
	
	&sql(select ID into :tmpID from EMRmeta.PowerUser 
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
/// w ##Class(EMRservice.BL.BLPowerUser).GetUserId("demo")
ClassMethod GetUserId(argUserInitials As %String, AHospitalID As %String = "") As %String
{
	s result = ""
	q:(argUserInitials="") result
	&sql(select SSUSR_RowId into :id from SQLUser.SS_USER where SSUSR_Initials=:argUserInitials)
    
	s userPvId = $o(^CTPCP(0,"Code",$zcvt(argUserInitials,"U"),""))
    q:(userPvId = "") result
    q:($p(^CTPCP(userPvId,1),"^",9) '= "Y") result
	
	s showShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
	if ((AHospitalID '= "")&&(showShareHospital = "N"))
	{
		q:(($d(^CTPCP(userPvId,"HOSP",0,"Hosp")) > 0)&&($o(^CTPCP(userPvId,"HOSP",0,"Hosp",AHospitalID,"")) = "")) result
	}
	
    s result = id
	q result
}

/// 更新用户的子用户 not in use
ClassMethod UpdateUser(argGroupID As %String, argUserID As %String, argChildUser As %String, argControlByGroup As %String) As %String
{
	k SQLCODE
	&sql(update EMRmeta.PowerUser set ChildUsers=:argChildUser, ControlByGroup=:argControlByGroup
	where SSGroupID=:argGroupID and UserID=:argUserID)
	q SQLCODE
}

ClassMethod Add(argPowerUser As EMRservice.entity.EPowerUser) As %String [ WebMethod ]
{

	q:($d(argPowerUser)=0)||(argPowerUser="") 0
	TSTART
	s powerUserID=""
	s powerUserID=##class(EMRservice.BL.BLPowerUser).SelectByGroupUserID(argPowerUser.SSGroupID,argPowerUser.UserID)
	s:(powerUserID'="") argPowerUser.ID=powerUserID
	q:(powerUserID'="") ##class(EMRservice.BL.BLPowerUser).Update(argPowerUser)
	
	s aPowerUser=""
	s aPowerUser=##class(EMRmeta.PowerUser).%New()
	q:(aPowerUser="") 0
	s strUserIDGrops = argPowerUser.ChildUsers
	
	if (strUserIDGrops'="")
	{
		s strsize = $l(strUserIDGrops,"^")
	}
	
	s aPowerUser.ChildUsers=argPowerUser.ChildUsers
	s aPowerUser.ControlByGroup=argPowerUser.ControlByGroup
	s aPowerUser.IsValid=argPowerUser.IsValid
	s aPowerUser.SSGroupID=argPowerUser.SSGroupID
	s aPowerUser.UserID=argPowerUser.UserID
	s aPowerUser.UserLevel=argPowerUser.UserLevel
	s aPowerUser.UserPos=argPowerUser.UserPos
	
	s result=""
	s result=aPowerUser.%Save()
	if ($$$ISOK(result))
	{
		if (argPowerUser.SubUserIDGroupID'="")
		{
			s strUserGroupS = argPowerUser.SubUserIDGroupID
			S strSize = $l(strUserGroupS,"^")
			for i=1:1:strSize
			{
				s objChildUse = ##Class(EMRmeta.ChildUsers).%New()
				s objChildUse.ParRef = aPowerUser
				s objChildUse.UserID = $p($p(strUserGroupS,"^",i),"|",1)
				s objChildUse.SSGroupID = $p($p(strUserGroupS,"^",i),"|",2)
				s sc = objChildUse.%Save()
				if ('$$$ISOK(sc))
				{
				 	s result = "-1"
				}
			}
		}
	}
	if (result ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q result
	}
}

/// not in use
ClassMethod Delete(argPowerUserID As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUserID)=0)||(argPowerUserID="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(argPowerUserID)
	q:(aPowerUser="") 0
	s aPowerUser=""
	s result=##class(EMRmeta.PowerUser).%DeleteId(argPowerUserID)
	q result
}

ClassMethod Update(argPowerUser As EMRservice.entity.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUser)=0)||(argPowerUser="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(argPowerUser.ID)
	q:(aPowerUser="") 0
	TSTART
	s strChildUseOld = aPowerUser.ChildUsers
	if ($g(argSkipColumn)'="ChildUsers") {s aPowerUser.ChildUsers=argPowerUser.ChildUsers}
	
	s aPowerUser.ControlByGroup=argPowerUser.ControlByGroup
	s aPowerUser.IsValid=argPowerUser.IsValid
	s aPowerUser.SSGroupID=argPowerUser.SSGroupID
	s aPowerUser.UserID=argPowerUser.UserID
	
	if ($g(argSkipColumn)'="UserLevel") {s aPowerUser.UserLevel=argPowerUser.UserLevel}
	if ($g(argSkipColumn)'="UserPos") {s aPowerUser.UserPos=argPowerUser.UserPos}
	
	s result=""
	s result=aPowerUser.%Save()
	if ($$$ISOK(result))
	{
		if (argPowerUser.SubUserIDGroupID'="")
		{
			s strUserGroupS = argPowerUser.SubUserIDGroupID
			//更新添加关联字表
			S strSize = $l(strUserGroupS,"^")
			s objChildUse =""
			for i=1:1:strSize
			{
				s strChildRowID = ""
				s strUserID = $p($p(strUserGroupS,"^",i),"|",1)
				s strChildRowID = 	$o(^DHCEMRM.ChildUsersI("IdxParRef",argPowerUser.ID," "_strUserID,strChildRowID))
				if (strChildRowID = "")
				{
					s objChildUse = ##Class(EMRmeta.ChildUsers).%New()
				}
				else
				{
					S strChildUserId = argPowerUser.ID _"||"_strChildRowID
					s objChildUse = ##Class(EMRmeta.ChildUsers).%OpenId(strChildUserId)
				}
				s objChildUse.ParRef = aPowerUser
				s objChildUse.UserID = strUserID
				s objChildUse.SSGroupID = $p($p(strUserGroupS,"^",i),"|",2)
				s sc = objChildUse.%Save()
				if ('$$$ISOK(sc))
				{
				 	s result = "-1"
				}
			}
			//删除关联字表数据
			s strOldSize = $l(strChildUseOld,"^")
			for j=1:1:strOldSize
			{
				s strChildRowID = ""
				s strOldUserID = $p(strChildUseOld,"^",j)
				if '(strUserGroupS [ (strOldUserID_"|"))
				{
					s strChildRowID = 	$o(^DHCEMRM.ChildUsersI("IdxParRef",argPowerUser.ID," "_strOldUserID,strChildRowID))
					if (strChildRowID="")
					{
						continue	
					}
					S strChildUserId = argPowerUser.ID _"||"_strChildRowID
					s sc = ##class(EMRmeta.ChildUsers).%DeleteId(strChildUserId)
					if ('$$$ISOK(sc))
					{
					 	s result = "-1"
					}
				}
			}
		}
	}
	if (result ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q result
	}
}

ClassMethod GetById(argPowerUserID As %String) As EMRservice.entity.EPowerUser [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	;b "s"
	&sql(select ID into :id from EMRmeta.PowerUser where UserID=:argPowerUserID)
	q:(id="") ""
	s result=##class(EMRservice.entity.EPowerUser).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EMRmeta.PowerUser).%OpenId(id)
		q:(tmpResult="") result
		s result.ID=id
		s result.ChildUsers=tmpResult.ChildUsers
		s result.ControlByGroup=tmpResult.ControlByGroup
		s result.IsValid=tmpResult.IsValid
		s result.SSGroupID=tmpResult.SSGroupID
		s result.UserID=tmpResult.UserID
		s result.UserLevel=tmpResult.UserLevel
		s result.UserPos=tmpResult.UserPos		
	}
	q result
}

/// argSkipColumn: because edit user level and child users both change the BOPowerUser table,
/// so when edit one property(column) should not influence the other. this argument shows which one should be kept.
ClassMethod AddOrUpdate(argPowerUser As EMRservice.entity.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUser)=0)||(argPowerUser="") 0
	s aPowerUser="",result=""
	if (argPowerUser.ID=0) {
		s aPowerUser=##class(EMRmeta.PowerUser).%New()
		q ..Add(argPowerUser)
	}
	else {
		s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(argPowerUser.ID)
		if (aPowerUser="") {
			q ..Add(argPowerUser)
		}
		else {
			q ..Update(argPowerUser,argSkipColumn)
		}
	}
}

ClassMethod SetPowerUserInter(aSSGroupID As %String, aUserID As %String, aUserLevel As %String, aUserPos As %String) As %String
{
	s result = "-1"
	q:($d(aSSGroupID)=0)||(aUserID="")||((aUserLevel="")&&(aUserPos="")) "-1"
	TSTART
	s powerUserID=$o(^DHCEMRM.PowerUserI("UserID"," "_aUserID,""))
	if (powerUserID="") 
	{
		s aPowerUser=##class(EMRmeta.PowerUser).%New()
		s aPowerUser.SSGroupID=aSSGroupID
		s aPowerUser.UserID=aUserID
		s aPowerUser.UserLevel=aUserLevel
		s aPowerUser.UserPos=aUserPos
		if (aPowerUser.%Save())
		{
			s result = "1"
		}
	}
	else
	{
		s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(powerUserID)
		s aPowerUser.SSGroupID=aSSGroupID
		s aPowerUser.UserID=aUserID
		s aPowerUser.UserLevel=aUserLevel
		s aPowerUser.UserPos=aUserPos
		if (aPowerUser.%Save())
		{
			s result = "1"
		}
	}

	if (result ="-1")
	{
		 TROLLBACK
	}
	else
	{
		TCOMMIT
	}
	q result
}

Query GetSSUser(argGroupName As %String) As %SQLQuery(CONTAINID = 7, ROWSPEC = "SSUSR_Group:%Integer,SSGRP_Desc,SSUSR_RowId:%Integer,SSUSR_Name,SSUSR_Initials,ChildUsers,ID:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_SSUserSub, SqlProc ]
{
   select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y'
}

ClassMethod getSSUser(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	
	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelectSSUser")
		Do result.SetArgs()
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelectSSUserByGroupName")
		Do result.SetArgs(argGroupName)
		
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelectSSUserByUserName")
		Do result.SetArgs(argUserName)

	}
	//both 2 parameters are not empty
	else {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelectSSUserByName")
		Do result.SetArgs(argGroupName,argUserName)

	}

	Quit result
}

ClassMethod getSSUserSub(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()

	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelSSUserSub")
		Do result.SetArgs()
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {	
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelSSUserSubByGroupName")
		Do result.SetArgs(argGroupName)
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelSSUserSubByUserName")
		Do result.SetArgs(argUserName)
	}
	//both 2 parameters are not empty
	else {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:SelSSUserSubByName")
		Do result.SetArgs(argGroupName,argUserName)
	}

	Quit result
}

/// added by houj
Query SelectSSUser() As %SQLQuery
{
	select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,
	       a.SSUSR_Name,a.SSUSR_Initials, c.Description as UserLevel,b.ID, 
	       c.Description as UserPos
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	  on (a.SSUSR_RowId=b.UserID) left join EMRmeta.UserLevel c on (b.UserLevel = c.Name)
	  left join EMRmeta.UserPost d on (b.UserPos = d.Name)
    where a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByGroupName(argGroupName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos 
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByUserName(argUserName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByName(argGroupName As %String, argUserName As %String) As %SQLQuery
{
  select  a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like :argGroupName and (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelSSUserSub() As %SQLQuery
{
   select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByGroupName(argGroupName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID 
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByUserName(argUserName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByName(argGroupName As %String, argUserName As %String) As %SQLQuery
{
	 select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like :argGroupName and (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y'
}

/// not in use
ClassMethod UpdateOld(argPowerUserID As %String, argPowerUser As EMRservice.entity.EPowerUser) As %String
{
	q:($d(argPowerUserID)=0)||($d(argPowerUser)=0)||(argPowerUserID="")||(argPowerUser="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(argPowerUserID)
	q:(aPowerUser="") 0
	s aPowerUser.ChildUsers=argPowerUser.ChildUsers
	s aPowerUser.ControlByGroup=argPowerUser.ControlByGroup
	s aPowerUser.IsValid=argPowerUser.IsValid
	s aPowerUser.SSGroupID=argPowerUser.SSGroupID
	s aPowerUser.UserID=argPowerUser.UserID
	s aPowerUser.UserLevel=argPowerUser.UserLevel
	s result=""
	s result=aPowerUser.%Save()
	q result
}

/// Desc:       取科室中主治、主任级别医师
/// Creator:    Candy
/// CreateDate: 2015-12-18
/// Input:      ALocID 科室ID 
/// Debug:      d ##Class(EMRservice.BL.BLPowerUser).GetSuperiorDoctors(1)
ClassMethod GetSuperiorDoctors(ALocID As %String) As %GlobalBinaryStream
{
	s $zt = "Error"
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(ALocID = "") result
	d result.Write("<Doctors>")
	s rowId = "0"
	for
	{	
		s rowId = $o(^SSU("SSUSR",rowId))
		q:(rowId = "")
		s tmploc = $p($g(^SSU("SSUSR",rowId)),"^",4)
		continue:(tmploc = "")
		s userName = $p($g(^SSU("SSUSR",rowId)),"^",2) 
		if (tmploc '= ALocID)
		{
			s subId = "0"
			for
			{
				s subId = $o(^SSU("SSUSR",rowId,"OTHLL",subId))
				q:(subId = "")
				s endDate = $p($g(^SSU("SSUSR",rowId,"OTHLL",subId)),"^",5)
				continue:((endDate '="")&&(endDate <= $p($h,",",1)))
				s tmploc = $p($g(^SSU("SSUSR",rowId,"OTHLL",subId)),"^",1)
				q:(tmploc = ALocID)
			}
		}
		continue:(tmploc '= ALocID)				
		s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(rowId,"")
        s userLevel = $ZSTRIP(userLevel,"*C")
		continue:($l(userLevel)=1)
		s doctorCode = $p(userLevel,"^",1)
		s ctparprvtpDesc = $p(userLevel,"^",2)
        d result.Write("<Doctor>")
        d result.Write("<DoctorID>"_rowId_"</DoctorID>")
        d result.Write("<DoctorName>"_$zcvt(userName,"O","UTF8")_"</DoctorName>")
        d result.Write("<DoctorLevelCode>"_doctorCode_"</DoctorLevelCode>")
        d result.Write("<DoctorLevelDescription>"_$zcvt(ctparprvtpDesc,"O","UTF8")_"</DoctorLevelDescription>")
        d result.Write("</Doctor>")
	}
	d result.Write("</Doctors>")
	q result
Error
    q result
}

/// Desc: 取医师级别
/// Creaotr:    Candy
/// CreateDate: 2016-8-15
/// Debug: w ##Class(EMRservice.BL.BLPowerUser).GetHisUserLevel(180)
ClassMethod GetHisUserLevel(AUserPvID As %String) As %String
{
	s result = ""
	q:(AUserPvID = "") result
	s levelId = $p($g(^CTPCP(AUserPvID,1)),"^",4)
	q:(levelId = "") result
	s levelCode = $p($g(^CT("CPT",levelId)),"^",1)
	/*
	s rowId = $o(^DHCEMRM.SignRoleI("IdxNSCode"," "_levelCode,""))
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	s result = obj.ActionCode
	*/
	s result = levelCode
	q result
}

/// Desc: 		更改医师级别
/// Creaotr:    董璐璐
/// CreateDate: 2018-2-27
/// Input:      AUserID
///             AUserLevel：医师级别  Resident（住院医师） Attending（主治医师）
///             					  Chief（主任医师） ViceChief（副主任医师）intern（实习医师）
/// Output      result 1成功 0失败
/// Debug: 		w ##Class(EMRservice.BL.BLPowerUser).UpdateUserLevel(180,"Resident")
ClassMethod UpdateUserLevel(AUserID As %String, AUserLevel As %String) As %String
{
	s result = 0
	q:(AUserID = "")||(AUserLevel = "") result
	s aPowerUser=""
	s powerUserID = $o(^DHCEMRM.PowerUserI("UserIDIndex"," "_AUserID,""))
	q:(powerUserID="") result
	s aPowerUser=##class(EMRmeta.PowerUser).%OpenId(powerUserID)
	q:(aPowerUser="") result
	s aPowerUser.UserLevel = AUserLevel
	s sc = aPowerUser.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Desc: 		 获取医生信息
/// Creator:     董璐璐
/// CreateDate:  2018-5-23
/// Input:       ALocID 科室ID
/// Output:      rowID,Code,Desc,Type
/// Debug:       w ##Class(EMRservice.BL.BLPowerUser).GetDoctorsCTLoc(95,"DoctorName^DoctorLevel^Title","DoctorLevel:Attending") 
ClassMethod GetDoctorsCTLoc(ALocID As %String, AColFormat As %String, AColParams As %String, AEpisodeID As %String = "", AUserID As %String = "") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(ALocID = "") result
	d result.Write("[")
	s rowId = "0"
	for
	{	
		s rowId = $o(^SSU("SSUSR",rowId))
		q:(rowId = "")
		s tmploc = $p($g(^SSU("SSUSR",rowId)),"^",4)
		continue:(tmploc = "")
		s userName = $p($g(^SSU("SSUSR",rowId)),"^",2) 
		if (tmploc '= ALocID)
		{
			s subId = "0"
			for
			{
				s subId = $o(^SSU("SSUSR",rowId,"OTHLL",subId))
				q:(subId = "")
				s tmploc = $p($g(^SSU("SSUSR",rowId,"OTHLL",subId)),"^",1)
				q:(tmploc = ALocID)
			}
		}
		continue:(tmploc '= ALocID)
		
		s isActive = ##class(EMRservice.BL.BLPowerUser).GetRBDataFlag(rowId,ALocID)
		continue:(isActive = 0)

		s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(rowId,"")
		continue:($l(userLevel)=1)
		s doctorCode = $p(userLevel,"^",1)
		s ctparprvtpDesc = $p(userLevel,"^",2)
		if (AColParams '= "")
		{
			s containLevel = 0
			s levelRange = $e(AColParams,13,$l(AColParams))
			s levelCount=$l(levelRange, "^")
			f i=1:1:levelCount 
			{
				s level = $p(levelRange, "^", i)
				q:(level = "")
			    s:(doctorCode = level) containLevel = 1
			    continue:(doctorCode '= level)
			}
			continue:(containLevel '= 1)
		}
		if (AColFormat [ "DoctorLevel")
		{
			s ctnameparprvtpDesc = userName_ctparprvtpDesc
		}
		else
		{
			s ctnameparprvtpDesc = userName
		}
		//支持首拼检索
		s ctnameparprvtpCode = ##class(web.DHCINSUPort).GetCNCODE(ctnameparprvtpDesc,4,"")
        d:(result.Size>2) result.Write(",")
        d result.Write("{")
		d result.Write("""RowID"":"""_rowId_"""")
		d result.Write(",""Code"":"""_ctnameparprvtpCode_"""")
		d result.Write(",""Desc"":"""_ctnameparprvtpDesc_"""")
		d result.Write("}")
	}
	d result.Write("]")
	
	s defaultDoc = ##Class(EMRservice.BL.BLPowerUser).GetDefaultDoctor(ALocID,AColParams,AEpisodeID,AUserID) 
	d json.Write("{")
	d json.Write("""DefaultDoc"":"""_defaultDoc_""",")
	d json.Write("""DocData"":")
	d json.CopyFrom(result)	
	d json.Write("}")
	q json
}

/// 根据用户id，科室id，返回指定科室数据是否停用
/// 基础数据平台-likefan
/// output: 1(有效，未停用)		0(已停用)
/// 入参为空、用户无关联医护人员、无指定科室数据等情况均返回空
/// w ##class(EMRservice.BL.BLPowerUser).GetRBDataFlag("10209","95")
ClassMethod GetRBDataFlag(userid As %String, locid As %String) As %String
{
	q:(userid="") ""
	q:(locid="") ""
	s CareProvDR=$p($g(^SSU("SSUSR",userid)),"^",14)      //医护人员DR
	q:(CareProvDR="") ""
	s RBRowId=$o(^RB("RES",0,"CTPCP",CareProvDR,locid,0))
	q:(RBRowId="") ""
	s ActiveFlag=1
	s RESDateActiveTo=$p($g(^RB("RES",RBRowId)),"^",23)		//结束日期
	s:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h) ActiveFlag=0
	q ActiveFlag
}

/// Desc: 		 获取默认选择的医生
/// Creator:     董璐璐
/// CreateDate:  2020-3-31
/// Input:       ALocID 科室ID
/// 	         AColParams EMRmeta.TitleColConfig的Params字段
/// 	         AEpisodeID 就诊号
/// 	         AUserID 登录用户userID
/// Output:      默认选择的医生userID
/// Debug:       w ##Class(EMRservice.BL.BLPowerUser).GetDefaultDoctor(95,"DoctorLevel:Attending",1,10209) 
ClassMethod GetDefaultDoctor(ALocID As %String, AColParams As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s result = AUserID
	q:((ALocID = "")||(AColParams = "")||(AEpisodeID = "")) result
	q:((AColParams '= "DoctorLevel:Attending")&&(AColParams '= "DoctorLevel:Chief")&&(AColParams '= "DoctorLevel:ViceChief")&&(AColParams '= "DoctorLevel:ViceChief^Chief")) result
	
	if (AColParams = "DoctorLevel:Attending")
	{
		s userType = "2"
	}
	else
	{
		s userType = "3"
	}
	
	s docs = ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("",ALocID,AEpisodeID)
	//s docs = "[{""UserID"":""001"",""UserDesc"":""qq"",""Type"":""1"",""TypeDesc"":""管床医师""},{""UserID"":""002"",""UserDesc"":"""",""Type"":""2"",""TypeDesc"":""ee""},{""UserID"":""003"",""UserDesc"":"""",""Type"":""3"",""TypeDesc"":""ff""}]"
	q:(docs = "") result
	s stream =##class(%FileBinaryStream).%New()
	d stream.Write(docs)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s arrDocs = objJson.Deserialize(stream)
	s count = arrDocs.Count()
	for i=1:1:count
	{
		s type = arrDocs.GetAt(i).GetAt("Type")
		continue:(type '= userType)
		s result = arrDocs.GetAt(i).GetAt("UserID")
	}
	q result
}

}
