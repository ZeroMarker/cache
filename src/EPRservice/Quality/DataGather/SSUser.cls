Import SSUser

/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataGather.SSUser
/// * Description:	User related BO
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataGather.SSUser Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取安全组列表;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetSSGroupList")
Query GetSSGroupList() As %Query(ROWSPEC = "RowID:%String,Desc:%String")
{
}

ClassMethod GetSSGroupListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s (RowID,Desc) = ""
	s RowID = $o(^SSU("SSGRP",RowID))
	While(RowID '="")
	{	
		s Desc = $p($g(^SSU("SSGRP",RowID)),"^",1)
		
		// Get whether start logon security group
		s IsSSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetIsSSGroup",""))
		s IsSSGroup = $list(^DHCEPRM.QualityParamsD(+IsSSGroupRowID),2)
		if (IsSSGroup '= "Y") 
		{
			// Get default exec department security group
			s SSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","QuaSetSSGroup",""))
			s SSGroupID = $list(^DHCEPRM.QualityParamsD(+SSGroupRowID),2)
			s SSGroupID = $tr(SSGroupID," ","")
			
			// Get default MR security group
			s MRSSGroupRowID = $o(^DHCEPRM.QualityParamsI("IdxCode","MRSSGroup",""))
			s MRSSGroupRowID = $list(^DHCEPRM.QualityParamsD(+MRSSGroupRowID),2)
			s MRSSGroupRowID = $tr(MRSSGroupRowID," ","")
			
			if (RowID = SSGroupID)||(RowID = MRSSGroupRowID)
			{
				d SetOutputRow
			}
		}
		else
		{
			// Load all security groups
			d SetOutputRow
		}
		s RowID = $o(^SSU("SSGRP",RowID))
	}
	q $$$OK
	
SetOutputRow
	s Data = $lb(RowID,Desc)
	s ^CacheTemp(repid,ind) = Data
	s ind = ind+1
	q
}

ClassMethod GetSSGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSGroupListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetSSGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSGroupListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取默认登录科室下医生列表;
/// Input:	ADepartmentID为科室RowID;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetDoctorByDFDeptId","133")
Query GetDoctorByDFDeptId(FilterLocId = "", FilterUserName = "") As %Query(ROWSPEC = "ID:%String,Name:%String,CTPCPID,Desc")
{
}

ClassMethod GetDoctorByDFDeptIdExecute(ByRef qHandle As %Binary, FilterLocId As %String = "", FilterUserName = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	
	
	
	s RowID = ""
	for {
		//^SSU("SSUSR",{SSUSR_RowID})
		s RowID = $o(^SSU("SSUSR",RowID))
		q:(RowID = "")
		
		s user = $g(^SSU("SSUSR",+RowID))
		s Name = $p(user,"^",2)
		s CTPCPID = $p(user,"^",4)
	
		s Desc="无"
		if CTPCPID'=""
		{
			
			continue:(CTPCPID'=FilterLocId)&&(""'=FilterLocId)
			
			s objCtLoc = $g(^CTLOC(+CTPCPID))
			s Desc = $p(objCtLoc,"^",2)
			
			continue:($p(objCtLoc,"^",13)'="E")
			
		}else
		{
			continue
		}
		
		
		
		continue:(Name'[FilterUserName)&&(FilterUserName'="") //用户名过滤

		s Data = $lb(RowID,Name,CTPCPID,Desc)
		s ^Temp("sort",Desc,RowID)=Data	
		//根据资源表来判断用户科室  RB_Resource
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowID})
		
	}
	s Desc=""
	for
	{
		s Desc=$o(^Temp("sort",Desc))
		q:(Desc="")
		s RowID=""
		for
		{
			s RowID=$o(^Temp("sort",Desc,RowID))
			q:(RowID="")
			s Data=$g(^Temp("sort",Desc,RowID))
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1
		}
	}
	
	k ^Temp("sort")
	q $$$OK
}

ClassMethod GetDoctorByDFDeptIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorByDFDeptIdExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDoctorByDFDeptIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorByDFDeptIdExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取科室下医生列表;
/// Input:	ADepartmentID为科室RowID;
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetDoctorByDeptId","133")
Query GetDoctorByDeptId(ADepartmentID As %String, Filter = "") As %Query(ROWSPEC = "ID:%String,Name:%String")
{
}

ClassMethod GetDoctorByDeptIdExecute(ByRef qHandle As %Binary, ADepartmentID As %String, Filter = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($d(ADepartmentID) = 0)||(ADepartmentID = "") $$$OK
	
	s RowID = ""
	for {
		//^SSU("SSUSR",{SSUSR_RowID})
		s RowID = $o(^SSU("SSUSR",RowID))
		q:(RowID = "")
		
		s user = $g(^SSU("SSUSR",+RowID))
		s Initials = $p(user,"^",1)
		s Name = $p(user,"^",2)
		s CTPCPID = $p(user,"^",14)
		continue:(Filter'="")&&(Name'[Filter)&&(Initials'[Filter)
		//根据资源表来判断用户科室  RB_Resource
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowID})
		if ($d(^RB("RES",0,"CTPCP",+CTPCPID,ADepartmentID)))
		{
			s Data = $lb(RowID,Name)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1	
		}
	}
	q $$$OK
}

ClassMethod GetDoctorByDeptIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorByDeptIdExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDoctorByDeptIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorByDeptIdExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetUserLocIDByUserID","22501")
ClassMethod GetUserLocIDByUserID(AUserID As %String) As %String
{
	s userLocID = ""
	&sql(select SSUSR_DefaultDept_DR into :userLocID from SQLUser.SS_User where SSUSR_RowId = :AUserID)
	q userLocID
}

ClassMethod GetUserIDByUserCode(AUserCode As %String) As %String
{
	s userID = ""
	&sql(select SSUSR_RowId into :userID from SQLUser.SS_User where SSUSR_Initials = :AUserCode)
	q userID
}

ClassMethod GetUserCodeByUserID(AUserID As %String) As %String
{
	s userCode = ""
	&sql(select SSUSR_Initials into :userCode from SQLUser.SS_User where SSUSR_RowId = :AUserID)
	q userCode
}

ClassMethod GetUserNameByUserID(AUserID As %String) As %String
{
	s userName = ""
	&sql(select SSUSR_Name into :userName from SQLUser.SS_User where SSUSR_RowId = :AUserID)
	q userName
}

/// Desc:	通过episodeID获取主管医生列表
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetMainDocList","373")
Query GetMainDocList(AEpisodeID As %String) As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserDesc:%String,LocID:%String,LocName:%String,AttendUserID:%String,AttendUserCode:%String,AttendUserDesc:%String,AttendLocID:%String,AttendLocName:%String")
{
}

ClassMethod GetMainDocListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	q:(AEpisodeID = "") $$$OK
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
		
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s MainDoc = ##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
	s MainDocID = $p(MainDoc,"^",1)
	
	s UserCode = $p(MainDoc,"^",2)
	s UserDesc = $p(MainDoc,"^",3)
	s UserID = ..GetUserIDByUserCode(UserCode) 
	s LocID = ..GetUserLocIDByUserID(UserID)
	s LocName = ""
	s:(LocID = "") LocName=$p($p($g(^CTLOC(LocID)),"^",2),"-",2)
	
	s AttendDocID = ##class(EPRservice.Privilege.BOPowerUser).GetUserSuperiorUserID(UserID)
	s:(AttendDocID '= "") AttendDocID = $p(AttendDocID,"^",1)

	s AttendUserCode = ..GetUserCodeByUserID(AttendDocID)
	s AttendUserDesc = ..GetUserNameByUserID(AttendDocID)

	s AttendLocID = ..GetUserLocIDByUserID(AttendDocID)
	s AttendLocName = ""
	s:(AttendLocID '= "") AttendLocName=$p($p($g(^CTLOC(AttendLocID)),"^",2),"-",2)
	
	s Data = $lb(UserID,UserCode,UserDesc,LocID,LocName,AttendUserID,AttendUserCode,AttendUserDesc,AttendLocID,AttendLocName)
	s ^CacheTemp(repid,ind) = Data
	s ind = ind+1
	
	s ret = ##class(EPRservice.HISInterface.PatientInfoAssist).TransDeptIDMainDocIDDetail(AEpisodeID)
	s length = $l(ret,"->")
	
	for index=1:1:length 
	{
		//b "s"
		if (index '= length)
		{
			s one = $p(ret,"->",index)
			s MainDocID = $p(one,"^",5) 
			s UserCode = $p(one,"^",6) 
			s UserDesc = $p(one,"^",7) 
			s UserID = ..GetUserIDByUserCode(UserCode) 
			s LocID = $p(one,"^",1) 
			s LocName=$p(one,"^",2) 
			
			s AttendDocID = ##class(EPRservice.Privilege.BOPowerUser).GetUserSuperiorUserID(UserID)
			s:(AttendDocID '= "") AttendDocID = $p(AttendDocID,"^",1)

			s AttendUserCode = ..GetUserCodeByUserID(AttendDocID)
			s AttendUserDesc = ..GetUserNameByUserID(AttendDocID)

			s AttendLocID = ..GetUserLocIDByUserID(AttendDocID)
			s AttendLocName = ""
			s:(AttendLocID '= "") AttendLocName=$p($p($g(^CTLOC(AttendLocID)),"^",2),"-",2)

			
			s Data = $lb(UserID,UserCode,UserDesc,LocID,LocName,AttendUserID,AttendUserCode,AttendUserDesc,AttendLocID,AttendLocName)
	    	s ^CacheTemp(repid,ind) = Data
	    	s ind = ind+1
		}
	}
	q $$$OK
}

ClassMethod GetMainDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMainDocListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetMainDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMainDocListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	通过工号/姓名、科室查询用户列表
/// Input:	AUserName(允许为空)--工号/姓名;
/// 		ALocID(允许为空)--科室查询
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetUserList","","1")
Query GetUserList(AUserName As %String, ALocID As %String) As %Query(ROWSPEC = "UserID:%String,UserCode:%String,UserDesc:%String,Location:%String")
{
}

ClassMethod GetUserListExecute(ByRef qHandle As %Binary, AUserName As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
		
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s UserName = $$ALPHAUP^SSUTIL4(AUserName)
	s LocID = $g(ALocID)
	
	q:(LocID = "") $$$OK
	
	s RowID = 0
	for {
		s RowID = $o(^RB("RES",0,"CTLOC",ALocID,RowID)) 
		q:(RowID = "")
		
		s CareProvID = $p(^RB("RES",RowID),"^",2)
		continue:(CareProvID = "")
		continue:($d(^CTPCP(CareProvID)) = 0)
		
		s CareProvCode = $p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc = $p($g(^CTPCP(+CareProvID,1)),"^",2)
    	s CareProvOtherName = $p($g(^CTPCP(+CareProvID,3)),"^",28)

    	continue:(UserName '= "")&&(( CareProvDesc '[ UserName)&&( $zcvt(CareProvOtherName,"U") '[ $zcvt(UserName,"U")))
		
		s Location = $p(^CTLOC(LocID),"^",2)
		s:(Location [ "-") Location = $p(Location,"-",2)
		
    	s Data = $lb(CareProvID,CareProvCode,CareProvDesc,Location)
    	s ^CacheTemp(repid,ind) = Data
    	s ind = ind+1
	}
	q $$$OK
}

ClassMethod GetUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	通过工号/姓名、科室查询医护人员列表
/// Input:	AUserName(允许为空)--工号/姓名;
/// 		ALocID(允许为空)--科室ID
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetCareProviderList","梁","988")
Query GetCareProviderList(AUserName As %String, ALocID As %String) As %Query(ROWSPEC = "CareProvID:%String,CareProvCode:%String,CareProvDesc:%String")
{
}

ClassMethod GetCareProviderListExecute(ByRef qHandle As %Binary, AUserName As %String, ALocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	;^SSU("SSUSR",{SSUSR_RowId})
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s UserName=$$ALPHAUP^SSUTIL4(AUserName)
	s LocID=$g(ALocID)
	
	s RowID=0
	for {
		s RowID=$o(^SSU("SSUSR",RowID)) 
		q:RowID="" 
		
		s objSSUser=$g(^SSU("SSUSR",+RowID))
		continue:objSSUser=""
		
		s CareProvID=$p(objSSUser,"^",14)
		continue:CareProvID=""
		
		s UserCode=$p(objSSUser,"^",1)
		s UserDesc=$p(objSSUser,"^",2)
		
    	s CareProvCode=$p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc=$p($g(^CTPCP(+CareProvID,1)),"^",2)
    	
    	continue:(UserName'="")&&(($$ALPHAUP^SSUTIL4(UserDesc)'[UserName)&&($$ALPHAUP^SSUTIL4(UserCode)'[UserName))
   	 	continue:(LocID'="")&&('$d(^RB("RES",0,"CTPCP",+CareProvID,LocID)))  //根据资源表来判断用户科室  RB_Resource
    
    	s Data=$lb(CareProvID,CareProvCode,CareProvDesc)
    	s ^CacheTemp(repid,ind)=Data
    	s ind=ind+1
	}
	q $$$OK
}

ClassMethod GetCareProviderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareProviderListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetCareProviderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareProviderListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// Desc:	通过科室查询用户列表

/// Input:	ALocID--科室查询
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetUserDataList","","1")
Query GetUserDataList(AUserName As %String, ALocID As %String) As %Query(ROWSPEC = "ProvID:%String,UserID:%String,UserCode:%String,UserDesc:%String,Location:%String")
{
}

ClassMethod GetUserDataListExecute(ByRef qHandle As %Binary, AUserName As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s UserName = $$ALPHAUP^SSUTIL4(AUserName)
	s LocID = $g(ALocID)
	q:(LocID = "") $$$OK
	s RowID = 0
	for {
		s RowID = $o(^RB("RES",0,"CTLOC",ALocID,RowID)) 
		q:(RowID = "")
		s CareProvID = $p(^RB("RES",RowID),"^",2)
		continue:(CareProvID = "")
		continue:($d(^CTPCP(CareProvID)) = 0)

		s DateActiveTo=$p(^RB("RES",RowID),"^",23)
		s DateActiveFrom=$p(^RB("RES",RowID),"^",22)
		continue:(DateActiveTo'= "")&&(DateActiveTo<+$h)
		continue:(DateActiveFrom'= "")&&(DateActiveFrom>+$h)
		
		s userId = $o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
		s CareProvCode = $p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc = $p($g(^CTPCP(+CareProvID,1)),"^",2)
    	s CareProvOtherName = $p($g(^CTPCP(+CareProvID,3)),"^",28)
    	continue:(UserName '= "")&&(( CareProvDesc '[ UserName)&&( $zcvt(CareProvOtherName,"U") '[ $zcvt(UserName,"U")))
		s Location = $p(^CTLOC(LocID),"^",2)
		s:(Location [ "-") Location = $p(Location,"-",2)
    	s Data = $lb(CareProvID,userId,CareProvCode,CareProvDesc,Location)
    	s ^CacheTemp(repid,ind) = Data
    	s ind = ind+1
	}
	q $$$OK
}

ClassMethod GetUserDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetUserDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取所有用户
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetAllUser","")
Query GetAllUser(Filtter = "") As %Query(ROWSPEC = "UserName,UserId,SSUSRInitials")
{
}

ClassMethod GetAllUserExecute(ByRef qHandle As %Binary, Filtter = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	s UserName=""
	for
	{
		//^SSU("SSUSR","0","SSUSR_Name","绩效")
		s UserName=$o(^SSU("SSUSR","0","SSUSR_Name",UserName))
		q:(UserName="")
		
		s RowId=""
		for
		{
			s RowId=$o(^SSU("SSUSR","0","SSUSR_Name",UserName,RowId))
			q:(RowId="")
			s UserInfo=##class(User.SSUser).%OpenId(RowId)
			q:(UserInfo="")
			//s UserName=UserInfo.SSUSRName
			
			s groupName=UserInfo.SSUSRGroup.SSGRPDesc
			//continue:(groupName'="病历质控")
			
			continue:(Filtter'="")&&(UserName'[Filtter)
			s UserId=RowId
			s SSUSRInitials=UserInfo.SSUSRInitials
			s Data=$lb(UserName,UserId,SSUSRInitials)
			s ^CacheTemp(repid,ind) = Data
    		s ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetAllUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllUserExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	
	Quit $$$OK
}

ClassMethod GetAllUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllUserExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取所有用户
/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.SSUser","GetAllUserByLocId","2","")
Query GetAllUserByLocId(LocId = "", Filter = "") As %Query(ROWSPEC = "UserName,UserId,SSUSRInitials")
{
}

ClassMethod GetAllUserByLocIdExecute(ByRef qHandle As %Binary, LocId = "", Filter = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	s UserName=""
	for
	{
		//^SSU("SSUSR","0","SSUSR_Name","绩效")
		s UserName=$o(^SSU("SSUSR","0","SSUSR_Name",UserName))
		q:(UserName="")
		
		s RowId=""
		for
		{
			s RowId=$o(^SSU("SSUSR","0","SSUSR_Name",UserName,RowId))
			q:(RowId="")
			s UserInfo=##class(User.SSUser).%OpenId(RowId)
			q:(UserInfo="")
			//s UserName=UserInfo.SSUSRName
			
			s locId=UserInfo.SSUSRDefaultDeptDR.%Id() //默认登录科室id
			
			s defaultDeptId=""
			if (LocId'="")
			{
				s defaultDeptId=$p(^CTLOC(LocId),"^",19)	
			}
			
			//continue:(groupName'="病历质控")
			
			continue:(defaultDeptId'=locId)&&(LocId'="")&&(defaultDeptId'="")
			continue:(Filter'="")&&(UserName'[Filter)
			s UserId=RowId
			s SSUSRInitials=UserInfo.SSUSRInitials
			s Data=$lb(UserName,UserId,SSUSRInitials)
			s ^CacheTemp(repid,ind) = Data
    		s ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetAllUserByLocIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllUserByLocIdExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	
	Quit $$$OK
}

ClassMethod GetAllUserByLocIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllUserByLocIdExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
