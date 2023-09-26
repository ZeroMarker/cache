Class EPRservice.Privilege.BOPowerUser Extends (%RegisteredObject, %SOAP.WebService) [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.113/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.BOPowerUser";

ClassMethod Add(argPowerUser As EPRservice.entity.Privilege.EPowerUser) As %String [ WebMethod ]
{

	q:($d(argPowerUser)=0)||(argPowerUser="") 0

	s powerUserID=""
	s powerUserID=##class(EPRmeta.Privilege.PowerUser).SelectByGroupUserID(argPowerUser.SSGroupID,argPowerUser.UserID)
	s:(powerUserID'="") argPowerUser.ID=powerUserID
	q:(powerUserID'="") ##class(EPRservice.Privilege.BOPowerUser).Update(argPowerUser)
	
	s aPowerUser=""
	s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%New()
	q:(aPowerUser="") 0
	
	s aPowerUser.ChildUsers=argPowerUser.ChildUsers
	s aPowerUser.ControlByGroup=argPowerUser.ControlByGroup
	s aPowerUser.IsValid=argPowerUser.IsValid
	s aPowerUser.SSGroupID=argPowerUser.SSGroupID
	s aPowerUser.UserID=argPowerUser.UserID
	s aPowerUser.UserLevel=argPowerUser.UserLevel
	s aPowerUser.UserPos=argPowerUser.UserPos
	
	s result=""
	s result=aPowerUser.%Save()
	
	s childUsers = argPowerUser.ChildUsers
	s:(childUsers = $c(0)) childUsers = ""
	if (childUsers '= "")
	{
		for index=1:1:$l(childUsers,"^")
		{
			s childUserID = $p(childUsers,"^",index)
			s childUsersObj = ##Class(EPRmeta.Privilege.ChildUsers).%New()
			s childUsersObj.DetailNum = aPowerUser.TheChildUsers.Count() + 1
			s childUsersObj.ThePowerUser = aPowerUser
			s childUsersObj.UserID = childUserID
			s childUsersObj.SuperiorUserID = argPowerUser.UserID
			
			s result = childUsersObj.%Save()
		}
	
	}
	q result
}

/// not in use
ClassMethod Delete(argPowerUserID As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUserID)=0)||(argPowerUserID="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%OpenId(argPowerUserID)
	q:(aPowerUser="") 0
	s aPowerUser=""
	s result=##class(EPRmeta.Privilege.PowerUser).%DeleteId(argPowerUserID)
	q result
}

ClassMethod Update(argPowerUser As EPRservice.entity.Privilege.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUser)=0)||(argPowerUser="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%OpenId(argPowerUser.ID)
	q:(aPowerUser="") 0
	
	if ($g(argSkipColumn)'="ChildUsers") 
	{
		s aPowerUser.ChildUsers=argPowerUser.ChildUsers
		s childUsers = argPowerUser.ChildUsers
		s:(childUsers = $c(0)) childUsers = ""
		if (childUsers '= "")
		{
			for index=1:1:$l(childUsers,"^")
			{
				s childUserID = $p(childUsers,"^",index)
				s subID = ""
				s subID = $O(^EPRmeta.Privilege.ChildUsersI("IdxSuperiorAndSubUserID"," "_argPowerUser.ID," "_childUserID,subID))

				if (subID '= "")
				{
					s childUsersObj = ##Class(EPRmeta.Privilege.ChildUsers).%OpenId(argPowerUser.ID_"||"_subID)
				}
				else
				{
					s childUsersObj = ##Class(EPRmeta.Privilege.ChildUsers).%New()
				}
				s childUsersObj.DetailNum = aPowerUser.TheChildUsers.Count() + 1
				s childUsersObj.ThePowerUser = aPowerUser
				s childUsersObj.UserID = childUserID
				s childUsersObj.SuperiorUserID = argPowerUser.UserID
			
				s result = childUsersObj.%Save()
			}
	
		}
	}
	
	s aPowerUser.ControlByGroup=argPowerUser.ControlByGroup
	s aPowerUser.IsValid=argPowerUser.IsValid
	s aPowerUser.SSGroupID=argPowerUser.SSGroupID
	s aPowerUser.UserID=argPowerUser.UserID
	
	if ($g(argSkipColumn)'="UserLevel") {s aPowerUser.UserLevel=argPowerUser.UserLevel}
	if ($g(argSkipColumn)'="UserPos") {s aPowerUser.UserPos=argPowerUser.UserPos}
	
	s result=""
	s result=aPowerUser.%Save()
	q result
}

ClassMethod GetById(argPowerUserID As %String) As EPRservice.entity.Privilege.EPowerUser [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	;b "s"
	&sql(select ID into :id from EPRmeta_Privilege.PowerUser where UserID=:argPowerUserID)
	q:(id="") ""
	s result=##class(EPRservice.entity.Privilege.EPowerUser).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EPRmeta.Privilege.PowerUser).%OpenId(id)
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

/// Not Really Used(has been referenced in MaintainApp)
ClassMethod SelectBySSGroupAndLevel(argSSGroupID As %String, argLevel As %String) As %String [ WebMethod ]
{
	q:($d(argSSGroupID)=0)||($d(argLevel)=0)||(argSSGroupID="") 0
	q ##class(EPRmeta.Privilege.PowerUser).SelectBySSGroupAndLevel(argSSGroupID,argLevel)
}

/// argSkipColumn: because edit user level and child users both change the BOPowerUser table,
/// so when edit one property(column) should not influence the other. this argument shows which one should be kept.
ClassMethod AddOrUpdate(argPowerUser As EPRservice.entity.Privilege.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q:($d(argPowerUser)=0)||(argPowerUser="") 0
	s aPowerUser="",result=""
	if (argPowerUser.ID=0) {
		s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%New()
		q ..Add(argPowerUser)
	}
	else {
		s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%OpenId(argPowerUser.ID)
		if (aPowerUser="") {
			q ..Add(argPowerUser)
		}
		else {
			q ..Update(argPowerUser,argSkipColumn)
		}
	}
}

Query GetSSUser(argGroupName As %String) As %SQLQuery(CONTAINID = 7, ROWSPEC = "SSUSR_Group:%Integer,SSGRP_Desc,SSUSR_RowId:%Integer,SSUSR_Name,SSUSR_Initials,ChildUsers,ID:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_SSUserSub, SqlProc ]
{
   select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y'
}

/***  P8 对动态sql支持不好
ClassMethod getSSUser(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	
	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'")
		Do result.SetArgs()
		
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID "_
	 "from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like ? and a.SSUSR_Active='Y'")
		Do result.SetArgs(argGroupName)
		
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {	
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like ? or SSUSR_Initials like ?) and a.SSUSR_Active='Y'")
		Do result.SetArgs(argUserName,argUserName)

	}
	//both 2 parameters are not empty
	else {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like ? and (SSUSR_Name like ? or SSUSR_Initials like ?) and a.SSUSR_Active='Y'")
		Do result.SetArgs(argGroupName,argUserName,argUserName)

	}

	Quit result
}

ClassMethod getSSUserSub(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()

	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {	
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers, b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'")
		Do result.SetArgs()
	
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers, b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like ? and a.SSUSR_Active='Y'")
		Do result.SetArgs(argGroupName)
		
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials,b.ChildUsers, b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like ? or SSUSR_Initials like ?) and a.SSUSR_Active='Y'")
		Do result.SetArgs(argUserName,argUserName)
	}
	//both 2 parameters are not empty
	else {
		Do result.Prepare("select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers, b.ID "_
	 "from SS_User as a left join EPRmeta_Privilege.PowerUser as b "_
	 "on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like ? and (SSUSR_Name like ? or SSUSR_Initials like ?) and a.SSUSR_Active='Y'")
		Do result.SetArgs(argGroupName,argUserName,argUserName)
		
	}

	Quit result
}
***/
ClassMethod getSSUser(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	
	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelectSSUser")
		Do result.SetArgs()
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelectSSUserByGroupName")
		Do result.SetArgs(argGroupName)
		
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelectSSUserByUserName")
		Do result.SetArgs(argUserName)

	}
	//both 2 parameters are not empty
	else {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelectSSUserByName")
		Do result.SetArgs(argGroupName,argUserName)

	}

	Quit result
}

ClassMethod getSSUserSub(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()

	//both 2 parameters are empty
	if (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=0)||(argUserName="")) {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelSSUserSub")
		Do result.SetArgs()
	}
	//argGroupName is not empty
	elseif (($d(argGroupName)=1)&&(argGroupName'=""))&&(($d(argUserName)=0)||(argUserName="")) {	
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelSSUserSubByGroupName")
		Do result.SetArgs(argGroupName)
	}
	//argUserName is not empty
	elseif (($d(argGroupName)=0)||(argGroupName=""))&&(($d(argUserName)=1)||(argUserName'="")) {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelSSUserSubByUserName")
		Do result.SetArgs(argUserName)
	}
	//both 2 parameters are not empty
	else {
		Set result=##class(%XML.DataSet).%New("EPRservice.Privilege.BOPowerUser:SelSSUserSubByName")
		Do result.SetArgs(argGroupName,argUserName)
	}

	Quit result
}

ClassMethod getUserLevel() As EPRservice.dataset.EUserLevelDataset [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EUserLevelDataset).%New()
    Quit result
}

ClassMethod getUserPost() As EPRservice.dataset.EUserPostDataset [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EUserPostDataset).%New()
    Quit result
}

/// debug: w ##class(EPRservice.Privilege.BOPowerUser).GetUserSuperiorUserID(159)
ClassMethod GetUserSuperiorUserID(AUserID As %String) As %String
{
	s ret = ""
	s rowID = ""
	for {
		s rowID = $O(^EPRmeta.Privilege.ChildUsersI("IdxUserID"," "_AUserID,rowID))
		q:(rowID = "")

		s obj = ##Class(EPRmeta.Privilege.PowerUser).%OpenId(rowID)
		s superiorUserID = obj.UserID
		if (ret = "")
		{
			s ret = superiorUserID
		}
		else
		{
			s ret = ret_"^"_superiorUserID	
		}
	}
	q ret
}

/// added by houj
Query SelectSSUser() As %SQLQuery
{
	select a.SSUSR_initials, a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,
	       a.SSUSR_Name,a.SSUSR_Initials, c.Description as UserLevel,b.ID, 
	       c.Description as UserPos
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	  on (a.SSUSR_RowId=b.UserID) left join EPRmeta.UserLevel c on (b.UserLevel = c.Name)
	  left join EPRmeta.UserPost d on (b.UserPos = d.Name)
    where a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByGroupName(argGroupName As %String) As %SQLQuery
{
  select  a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos 
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByUserName(argUserName As %String) As %SQLQuery
{
  select  a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelectSSUserByName(argGroupName As %String, argUserName As %String) As %SQLQuery
{
  select  a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.UserLevel,b.ID, b.UserPos
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like :argGroupName and (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by houj
Query SelSSUserSub() As %SQLQuery
{
   select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByGroupName(argGroupName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID 
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Group->SSGRP_Desc like :argGroupName and a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByUserName(argUserName As %String) As %SQLQuery
{
  select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	 on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y'
}

/// added by houj
Query SelSSUserSubByName(argGroupName As %String, argUserName As %String) As %SQLQuery
{
	 select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_RowId,a.SSUSR_Name,a.SSUSR_Initials, b.ChildUsers,b.ID
	 from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	 on (a.SSUSR_RowId=b.UserID) where SSUSR_Group->SSGRP_Desc like :argGroupName and (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and a.SSUSR_Active='Y'
}

/// not in use
ClassMethod UpdateOld(argPowerUserID As %String, argPowerUser As EPRservice.entity.Privilege.EPowerUser) As %String
{
	q:($d(argPowerUserID)=0)||($d(argPowerUser)=0)||(argPowerUserID="")||(argPowerUser="") 0
	s aPowerUser="",result=""
	s aPowerUser=##class(EPRmeta.Privilege.PowerUser).%OpenId(argPowerUserID)
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

/// ************* 测试代码 ************
ClassMethod testadd()
{
	s a=##class(EPRservice.entity.Privilege.EPowerUser).%New()
	
	;s a.ChildUsers="8918^李涛!9297^杨京英"
	;s a.ControlByGroup=0
	;s a.IsValid=1
	s a.SSGroupID="1"
	s a.UserID="1"
	s a.UserLevel="chief"

	w ##class(EPRservice.Privilege.BOPowerUser).Add(a)
	q
}

}
