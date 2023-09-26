/// Desc:查询用户
/// Creator:Candy
Class DHCEPRFS.BL.BLQueryUser Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLQueryUser).CheckAndAddHISUser("159","PrintOperator")
ClassMethod CheckAndAddHISUser(ASSUserID As %String, ARoleID As %String) As %String
{
	s ret = ""
	q:(ASSUserID = "")||(ARoleID = "") ret
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_ASSUserID,rowID))
	if (rowID = "")
	{
		TSTART
		s obj = ##Class(DHCEPRFS.META.QueryUser).%New()
		s obj.UserCode = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserCode(ASSUserID)
		s obj.UserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(ASSUserID)
		s obj.IsAvailable = "1"
		s obj.StartDate = $p($h,",",1)
		s obj.Type = "HIS"
		s obj.SSUserID = ASSUserID
		
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s hisUserID = obj.%Id()
			s result = ..AddRoleUser(ARoleID,hisUserID)
			if (result = 1)
			{
				TCOMMIT
				q hisUserID
			}
			else
			{
				TROLLBACK 
				q ""
			}
		}
	}
	else
	{
		q rowID
	}
}

/// Desc:增加用户
/// Creator:Candy
/// Input:AUser  用户信息
/// Update: 2022-11-16 yangshun 对AUser的usercode与password的解密
ClassMethod AddUser(AUser As DHCEPRFS.Entity.EQueryUser, ARoleID As %String) As %String
{
   s result = -1
   if ((AUser.ID = "")||(AUser.ID = $c(0)))
   {
	   s obj = ##Class(DHCEPRFS.META.QueryUser).%New()
	   s obj.StartDate = $p($h,",",1)
   }
   else
   {
	   q:($d(^DHCEPRFS.META.QueryUserD(AUser.ID))<=0) result
	   s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(AUser.ID)
   }
   s obj.UserCode = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(AUser.UserCode)
   s obj.UserName = AUser.UserName
   s obj.PassWord = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(AUser.PassWord)
   s:(AUser.EndDate '= "") obj.EndDate = $zdh(AUser.EndDate,3)
   s obj.IsAvailable = AUser.IsAvailable
   s obj.Type = "TEMP"
   TSTART
   s sc = obj.%Save()
   if ($$$ISOK(sc))
   {
     s result = ..AddRoleUser(ARoleID,obj.%Id())
     if (result = 1) TCOMMIT  else  TROLLBACK 
   }
   d obj.%Close()
   q result
}

/// Desc:新增临时用户，临时用户名为最大数字临时用户的数字加1，返回用户ID
/// Update:2022-11-16 yangshun 对code加密返回
ClassMethod GetTempUserCodeAuto() As %String
{
	s count = 0
	&sql(select count(*) into :count from DHCEPRFS_META.QueryUser where Type = 'TEMP')
	s count = count + 100
	s code = "LS"_count
	s code = ##class(DHCEPRFS.Util.Encryption).EncryptWithDay(code)
   	q code
}

/// Desc:增加用户角色
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddRoleUser(1,1)
ClassMethod AddRoleUser(ARoleID As %String, AUserID As %String) As %String
{
	s result = -1
	s:(ARoleID = $c(0)) ARoleID = ""
	s:(AUserID = $c(0)) AUserID = ""
	q:(AUserID = "") result
	s rowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_AUserID,""))
	if (rowID = "")
	{
		s obj = ##Class(DHCEPRFS.META.QueryUserRole).%New()
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.QueryUserRole).%OpenId(rowID)	
	}
	s obj.RoleID = ARoleID
	s obj.UserID = AUserID
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	s obj = ""
	q result
}

/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).TestBatchAddUserLoc()
ClassMethod TestBatchAddUserLoc()
{
	s count = 0
	for {
		w !,..AddUserLoc(count, "ZHYK-综合一科", "2",count)
		s count = count + 1
		q:(count = 10000)	
	}
}

/// Desc:添加用户可使用的科室
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddUserLoc(12,"ZHYK-综合一科",1,2)
ClassMethod AddUserLoc(ALocID As %String, ALocDesc As %String, AQueryUserID As %String, ASequence As %String) As %String
{
	s result = -1
	q:((AQueryUserID = "") || (ALocID = "") || (ALocDesc = "")) result

	s obj = ##Class(DHCEPRFS.META.QueryUserLoc).%New()	
	s obj.LocID = ALocID
	s obj.LocDesc = ALocDesc
    s obj.QueryUserID = AQueryUserID
	s obj.Sequence = +ASequence
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	d obj.%Close()
	s obj = ""
	q result
}

/*
/// Desc:添加查询病历目录 作废不用2015.12.25
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddUserCategory("1#1#1^1#1#2",1)
ClassMethod AddUserCategory(ACCOde As %String, AQueryUserID As %String) As %String
{
    s result = -1
    q:((AQueryUserID = "")) result
    s rowID = $o(^DHCEPRFS.META.QueryUserCateI("IdxQueryUserID"," "_AQueryUserID,""))
    if (rowID = "")
    {
	    s obj = ##Class(DHCEPRFS.META.QueryUserCate).%New()
	}
   	else
   	{
   	   s obj = ##Class(DHCEPRFS.META.QueryUserCate).%OpenId(rowID)    
   	}
    s obj.CateCode = ACCOde
	s obj.QueryUserID = AQueryUserID
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	s obj = ""
	q result
}*/
/// Desc:添加查询病历目录_明细表 2015.12.24
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddUserCategoryDetail("1#1#1^1#1#2",1)
ClassMethod AddUserCategoryDetail(ACCOde As %ListOfDataTypes, AQueryUserID As %String) As %String
{
    s result = 0
    q:((AQueryUserID = "")) result
    //先删后加
    s rowID=""
    for {
    	s rowID = $o(^DHCEPRFS.META.QueryUserCateDtI("IdxQueryUserID"," "_AQueryUserID,""))
    	q:rowID=""
    	
    	s re =##Class(DHCEPRFS.META.QueryUserCateDetail).%DeleteId(rowID)
    	if ($$$ISERR(re))
    	{
	   		s result=-1
			quit
		}
    }
    if (result=-1)
    {
	    q result
	}
	
    for i=1:1:ACCOde.Count()
    {
		s oneCode=ACCOde.GetAt(i)
		s MRCategoryID=$p(oneCode,"#",1) 
		s MRSubCateogryID=$p(oneCode,"#",2)
		s MRItemID=$p(oneCode,"#",3)
		
		s obj = ##Class(DHCEPRFS.META.QueryUserCateDetail).%New()
		s obj.QueryUserID=AQueryUserID
		s obj.MRCategoryID=MRCategoryID
		s obj.MRSubCateogryID=MRSubCateogryID
		s obj.MRItemID=MRItemID
		
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{}
		else
		{
			s result=-1
			quit
		}
	}
	q result
}

/// Desc:增加查询日期
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddUserDate("","2013-04-01","2013-05-01",1)
ClassMethod AddUserDate(AStDate As %String, AEDate As %String, AQueryUserID As %String, ANoExpirationDate As %String) As %String
{
	s result = -1
    q:(AQueryUserID = "") result
    s rowID = $o(^DHCEPRFS.META.QueryUserDateI("IdxQueryUserID"," "_AQueryUserID,""))
    if (rowID = "")
    {
	    s obj = ##Class(DHCEPRFS.META.QueryUserDate).%New()
	}
   	else
   	{
   	   s obj = ##Class(DHCEPRFS.META.QueryUserDate).%OpenId(rowID)    
   	}
    s obj.StartDate = $zdh(AStDate,3)
	s obj.EndDate = $zdh(AEDate,3)
	s obj.QueryUserID = AQueryUserID
	s NoExpirationDate=$tr(ANoExpirationDate,$c(0),"")
	s obj.NoExpirationDate = NoExpirationDate
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	s obj = ""
	q result
}

/// Desc:增加可查询病案号
/// Debug: w ##Class(DHCEPRFS.BL.BLQueryUser).AddUserMed("",12345,1)
ClassMethod AddUserMed(AMedNo As %String, AQueryUserID As %String) As %String
{
    s result = 0
    q:((AQueryUserID = "")) result
    //先删后加
    s rowID=""
    for {
    	s rowID = $o(^DHCEPRFS.META.QueryUserMedRcdI("IdxQueryUserID"," "_AQueryUserID,""))
    	q:rowID=""
    	
    	s re =##Class(DHCEPRFS.META.QueryUserMedRecord).%DeleteId(rowID)
    	if ($$$ISERR(re))
    	{
	   		s result=-1
			quit
		}
    }
    if (result=-1)
    {
	    q result
	}
	
    for i=1:1:$l(AMedNo,"^")
    {
		s oneMedRecordNO=$p(AMedNo,"^",i)
		continue:(oneMedRecordNO="")
		s obj = ##Class(DHCEPRFS.META.QueryUserMedRecord).%New()
		s obj.QueryUserID=AQueryUserID
		s obj.MedRecordNO=oneMedRecordNO
		
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{}
		else
		{
			s result=-1
			quit
		}
	}
	q result
}

/// debug: w ##Class(DHCEPRFS.BL.BLQueryUser).Test()
ClassMethod Test() As %String
{
	s obj = ##Class(DHCEPRFS.Entity.EQueryUser).%New()
	s obj.ID = 1
	s obj.UserCode = "0001"
	s obj.UserName = "test"
	s obj.PassWord = "1"
	s obj.EndDate = "9998-12-31"
	s obj.IsAvailable = "1"
    s aa = ##Class(DHCEPRFS.BL.BLQueryUser).AddUser(obj,1)
}

/// Desc:取用户信息
/// Input:ACode 用户代码
/// debug: w ##Class(DHCEPRFS.BL.BLQueryUser).GetUserByCode("11")
ClassMethod GetUserByCode(ACode As %String) As DHCEPRFS.Entity.EQueryUser
{
	s result = ##Class(DHCEPRFS.Entity.EQueryUser).%New()
	q:((ACode = "")||(ACode = $c(0))) result
	
	//解密
	s ACode = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(ACode)
	s code = $Zcvt(ACode,"U")
	s count = 0
	&sql(select count(*) into :count from DHCEPRFS_META.QueryUser)

	if (count <= 0)
	{
		//没有任何用户，取默认admin用户
		s result.ID = 0
		s result.UserCode = ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("admin")  //加密
		s result.PassWord = ##class(DHCEPRFS.Util.Encryption).EncryptWithDay("admin")
		s result.IsAvailable = 1
		s result.EndDate = $zd($p($h,",",1))
		s result.Expire = "N"
	}
	else
	{
		s flag = "temp"
	    s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " TEMP", " "_code,""))
	    if (rowID = "")
	    {
		    //HIS用户
			s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " HIS", " "_code,""))
		    q:(rowID = "") result
		    s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
	    	s result.ID = rowID
	    	s result.UserCode = ##class(DHCEPRFS.Util.Encryption).EncryptWithDay(obj.UserCode)  //加密
	    	s result.UserName = obj.UserName 
	    	s result.PassWord = obj.PassWord
	   	 	s result.IsAvailable = obj.IsAvailable
	    	s result.StartDate = $zd(obj.StartDate,3)
	    	s result.EndDate = $zd($p($h,",",1),3)	//与老版本程序兼容
	    	s result.SSUserID = obj.SSUserID
	    	s result.Type = obj.Type
	    	s result.Expire = "N"
	    	d obj.%Close()
		}
	    else
	    {
		    //临时用户
	   		s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
	   		s endDate = obj.EndDate
	   		s nowDate = $p($h,",",1)
	   		if (nowDate > endDate)
	   		{
		   		s result.Expire = "Y"
		   	}
		   	else
		   	{
				s result.Expire = "N"   	
			}
	   		
	    	s result.ID = rowID
	    	s result.UserCode =##class(DHCEPRFS.Util.Encryption).EncryptWithDay(obj.UserCode)  //加密
	    	s result.UserName = obj.UserName 
	    	s result.PassWord =##class(DHCEPRFS.Util.Encryption).EncryptWithDay(obj.PassWord)
	   	 	s result.IsAvailable = obj.IsAvailable
	    	s result.StartDate = $zd(obj.StartDate,3)
	    	s result.EndDate = $zd(obj.EndDate,3)
	    	s result.SSUserID = obj.SSUserID
	    	s result.Type = obj.Type
	    	d obj.%Close()
	    }
	}
	q result
}

ClassMethod GetUserNameByUserID(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s obj = ##class(DHCEPRFS.META.QueryUser).%OpenId(AUserID)
	q:(obj = "") result
	s result = obj.UserName 
	d obj.%Close()
	s obj = ""
	q result
}

/// Desc:根据用户ID取Role
ClassMethod GetRoleByUserID(AUserID As %String) As %String
{
	s result = ""
	q:((AUserID = "")||(AUserID = $c(0))) result
	s rowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_AUserID,""))
	q:(rowID = "") result
	s obj = ##Class(DHCEPRFS.META.QueryUserRole).%OpenId(rowID)
	q:(obj = "") result
	s result = obj.RoleID
	d obj.%Close()
	s obj = ""
	q result
}

/// Desc: 根据用户ID获取出院科室
/// Input:AUserID 用户ID
/// Creator:Candyxu
/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetDisLocByUserID",1)
Query GetDisLocByUserID(AUserID As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String")
{
}

ClassMethod GetDisLocByUserIDExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:((AUserID = "")||(AUserID = $c(0))) $$$OK
	
	s allLocDesc = "全部授权科室", allLocID = ""
	
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.QueryUserLocI("IdxUserSequence"," "_AUserID,sequence))
		q:(sequence = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.QueryUserLocI("IdxUserSequence"," "_AUserID,sequence,rowID))
		    q:(rowID = "")
		    s obj = ##Class(DHCEPRFS.META.QueryUserLoc).%OpenId(rowID)
		    continue:(obj = "")
		    s LocID = obj.LocID
		    s LocDesc = obj.LocDesc
	        s ^CacheTemp(repid,ind) = $lb(LocID,LocDesc)
	        s ind=ind+1 
	        
	        if (allLocID = "") {s allLocID = LocID}
	        else {s allLocID = allLocID_"^"_LocID}
		}
	}
	
	if (allLocID '= "")
	{
		s ^CacheTemp(repid,ind) = $lb(allLocID,allLocDesc)
	}
	
	Quit $$$OK
}

ClassMethod GetDisLocByUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisLocByUserIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDisLocByUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisLocByUserIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:根据用户ID取可查询出院科室字符串以"^"分隔
/// debug:w ##class(DHCEPRFS.BL.BLQueryUser).GetStringDisLocByUserID(132)
ClassMethod GetStringDisLocByUserID(AUserID As %String) As %String
{
	s result = ""
	q:((AUserID = "") || (AUserID = $c(0))) result
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.QueryUserLocI("IdxUserSequence"," "_AUserID,sequence))
		q:(sequence = "")
		s rowID = ""
		for	{
			s rowID = $o(^DHCEPRFS.META.QueryUserLocI("IdxUserSequence"," "_AUserID,sequence,rowID))
		    q:(rowID = "")
		    s obj = ##Class(DHCEPRFS.META.QueryUserLoc).%OpenId(rowID)
		    continue:(obj = "")
		    s result = result_"^"_obj.LocID
		}
	}
	s result = $e(result,2,$l(result))
	q result
}

/// Desc:根据用户ID返回开始结束时间
/// Input:AUserID 用户ID 
/// Debug: do ##class("DHCEPRFS.BL.BLQueryUser").GetDisDateByUserID(1)
ClassMethod GetDisDateByUserID(AUserID As %String) As %String
{
	s result = ""
	q:((AUserID = "") || (AUserID = $c(0))) result
	s rowID = $o(^DHCEPRFS.META.QueryUserDateI("IdxQueryUserID"," "_AUserID,""))
	q:(rowID = "") result
	s obj = ##Class(DHCEPRFS.META.QueryUserDate).%OpenId(rowID)
	q:(obj = "") result
	s NoExpirationDate = obj.NoExpirationDate
	s startDate =  $zd(obj.StartDate,3)
	s endDate = $zd(obj.EndDate,3)
	s NoExpirationDate=$tr(NoExpirationDate,$c(0),"")
	
	s result = startDate_"^"_endDate_"^"_NoExpirationDate
	q result
}

ClassMethod GetDataLoadRuleByUserID(AUserID As %String) As DHCEPRFS.Entity.EQueryDataLoadRule
{
	s obj = ##Class(DHCEPRFS.Entity.EQueryDataLoadRule).%New()
	q:((AUserID = "") || (AUserID = 0) || (AUserID = $c(0))) obj
	s DisLoc = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetDisLocByUserID")
    d DisLoc.SetArgs(AUserID)
	s obj.DisLoc = DisLoc
	s DisDate = ..GetDisDateByUserID(AUserID)
	if (DisDate '= "") 
	{
		s obj.DisSDate = $p(DisDate,"^",1)
		s NoExpirationDate = $p(DisDate,"^",3)
		s NoExpirationDate=$tr(NoExpirationDate,$c(0),"")
		if (NoExpirationDate = "Y")
		{
			s obj.DisEDate = $zd($h,3)
		}else
		{
			s obj.DisEDate = $p(DisDate,"^",2)
		}	
	}

	s obj.MedNos = ##Class(DHCEPRFS.BL.BLQueryUser).GetMedNoByUserID(AUserID)
    s obj.RecordCategory = ##Class(DHCEPRFS.BL.BLQueryUser).GetRecordCategoryByUserID(AUserID)
    q obj
}

/// Desc:根据用户ID返回可查询病案号
/// Input: AUserID 用户ID
/// Debug: w ##class("DHCEPRFS.BL.BLQueryUser").GetMedNoByUserID(1)
ClassMethod GetMedNoByUserID(AUserID As %String) As %String
{
	s result = ""
    q:((AUserID = "") || (AUserID = $c(0))) retsult	
    s rowID=""
    for {
    	s rowID = $o(^DHCEPRFS.META.QueryUserMedRcdI("IdxQueryUserID"," "_AUserID,rowID))
    	q:(rowID = "") 
    	s obj = ##class(DHCEPRFS.META.QueryUserMedRecord).%OpenId(rowID)
    	if (result="")
    	{
	    	s result=obj.MedRecordNO
    	}
    	else
    	{
	    	s result=result_"^"_obj.MedRecordNO
	    }
    }
    q result
}

/// Desc:获得病历浏览目录
/// Input:AUserID 用户ID
/// Debug: w ##class("DHCEPRFS.BL.BLQueryUser").GetRecordCategoryByUserID(159)
/// 修改为从明细表提取Category信息，然后组串保持接口不变。2015.12.25
ClassMethod GetRecordCategoryByUserID(AUserID As %String) As %String
{
	s result = ""
    q:((AUserID = "") || (AUserID = $c(0))) retsult	
    s rowID=""
    for {
    	s rowID = $o(^DHCEPRFS.META.QueryUserCateDtI("IdxQueryUserID"," "_AUserID,rowID))
    	q:(rowID = "") 
    	s obj = ##class(DHCEPRFS.META.QueryUserCateDetail).%OpenId(rowID)
    	if (result="")
    	{
	    	s result=obj.MRCategoryID_"#"_obj.MRSubCateogryID_"#"_obj.MRItemID
    	}
    	else
    	{
	    	s result=result_"^"_obj.MRCategoryID_"#"_obj.MRSubCateogryID_"#"_obj.MRItemID
	    }
    }
    q result
}

/// Desc：获得用户信息
/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetUsers","TEMP","Y")
Query GetUsers(AType As %String, AOnlyShowValid As %String = "Y") As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,Password:%String,StartDate:%String,EndDate:%String,IsAvailable:%String,Role:%String,DisLoc:%String,Category:%String,QueryDate:%String,MedNos:%String,SSUserID:%String,RoleName:%String,ParentQueryUserCode:%String,ParentQueryUserName:%String")
{
}

ClassMethod GetUsersExecute(ByRef qHandle As %Binary, AType As %String, AOnlyShowValid As %String = "Y") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s userCode = ""
	for	{
	    s userCode = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " "_$zcvt(AType,"U"),userCode))
	    q:(userCode = "")
	    s rowID = ""
	    for {
		    s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " "_$zcvt(AType,"U"),userCode,rowID))
	    	q:(rowID = "")
	 		s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
			s Code = obj.UserCode
			s Name = obj.UserName
			s Password = obj.PassWord
			s SDate = $Case(obj.StartDate '= "",1:$zd(obj.StartDate,3))
			s SSUserID = obj.SSUserID
			s IsAvailable = obj.IsAvailable
			if (AType = "HIS")
			{
				s EDate = $zd($p($h,",",1),3)
				if (AOnlyShowValid = "Y")
				{
					//用户失效
					continue:(IsAvailable '= "1")	
				}
			}
			else
			{
				s EDate = $Case(obj.EndDate '= "",1:$zd(obj.EndDate,3))
				if (AOnlyShowValid = "Y")
				{
					//b "s"
					//用户失效
					continue:(IsAvailable '= "1")	
					//超时
					
					continue:(obj.EndDate < $p($h,",",1))
				}
			}

			s RoleID = ..GetRoleByUserID(rowID)
			s RoleName = ""
			if ((RoleID '= "") && (RoleID '= $c(0)))
			{
				s roleObj = ##Class(DHCEPRFS.META.QueryRole).%OpenId(RoleID)
				s RoleName = roleObj.RoleDesc
			}
			s DisLoc = ..GetStringDisLocByUserID(rowID)
			s Category = ..GetRecordCategoryByUserID(rowID)
			s QueryDate = ..GetDisDateByUserID(rowID)
			s MedNos = ..GetMedNoByUserID(rowID)
			s ParentQueryUserID=""
			s ParentQueryUserName=""
			
			s QueryUserGroupID=""
			s ParentQueryUserCode=""
			s ParentQueryUserName=""
			
			s QueryUserGroupID=$o(^DHCEPRFS.META.QueryUserGroupI("IdxQueryUserID"," "_rowID,QueryUserGroupID))
			if (QueryUserGroupID="")
			{
				s ParentQueryUserCode=""
				s ParentQueryUserName=""
			}
			else
			{
				s objQueryUserGroup=##class(DHCEPRFS.META.QueryUserGroup).%OpenId(QueryUserGroupID)
				s objParentQueryUser=##class(DHCEPRFS.META.QueryUser).%OpenId(objQueryUserGroup.ParentQueryUserID)
				s ParentQueryUserCode=objParentQueryUser.UserCode
				s ParentQueryUserName=objParentQueryUser.UserName
			}
			
			s ^CacheTemp(repid,ind) = $lb(rowID,Code,Name,Password,SDate,EDate,IsAvailable,RoleID,DisLoc,Category,QueryDate,MedNos,SSUserID,RoleName,ParentQueryUserCode,ParentQueryUserName)
	    	s ind=ind+1	
	    }
   }
 	
	Quit $$$OK
}

ClassMethod GetUsersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUsersExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUsersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUsersExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:根据RoleID取权限列表
/// Creator:Candyxu
/// Debug:d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryRoleFunction","GetFuntionByUserID",1)
Query GetFuntionByUserID(AUserID As %String) As %Query(ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String")
{
}

ClassMethod GetFuntionByUserIDExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s AUserID = $Case(AUserID,$c(0):"",:AUserID)
 	q:(AUserID = "") $$$OK
 	s RoleID = ##Class(DHCEPRFS.BL.BLQueryUser).GetRoleByUserID(AUserID)
 	q:(RoleID = "") $$$OK
 	s rowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID"," "_RoleID,""))
 	q:(rowID = "") $$$OK
 	s obj = ##Class(DHCEPRFS.META.QueryRoleFun).%OpenId(rowID)
 	s Function = obj.FuncID
 	for I=1:1:$length(Function,"^")	{
	 	s tmpFuncID = $p(Function,"^",I)
	 	Continue:($D(^DHCEPRFS.META.QueryFunctionD(tmpFuncID))<=0)
	 	s objFunc = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(tmpFuncID)
	 	s FName = objFunc.FuncName
	 	s FDesc = objFunc.FuncDesc
	 	s ^CacheTemp(repid,ind)=$lb(tmpFuncID,FName,FDesc)
	    s ind=ind+1
	}
	d obj.%Close()
 	s obj = ""
	Quit $$$OK
}

ClassMethod GetFuntionByUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFuntionByUserIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFuntionByUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFuntionByUserIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:根据用户ID删除其可查询科室信息
ClassMethod DeleLocByUserID(AUserID As %String) As %String
{
	s result = 1
	s rowID = ""
	for	{
	    s rowID = $o(^DHCEPRFS.META.QueryUserLocI("IdxUserID"," "_AUserID,rowID))
	    q:(rowID = "")
	    s re = ##Class(DHCEPRFS.META.QueryUserLoc).%DeleteId(rowID)
        s:($$$ISERR(re)) result = -1
        q:(result = -1)
	}
	q result
}

Query GetAllSSGroup() As %SQLQuery
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	order by SSGRP_Desc
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	where SSGRP_Desc like :argGroupName
}

Query SelectSSUser() As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User
    where SSUSR_Active='Y' 
    order by SSUSR_name
}

Query SelectSSUserByGroupName(argGroupName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User
	where SSUSR_Group->SSGRP_Desc like :argGroupName and SSUSR_Active='Y' 
	order by SSUSR_name
}

Query SelectSSUserByUserName(argUserName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User
	where (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and SSUSR_Active='Y' 
	order by SSUSR_name
}

Query SelectSSUserByName(argGroupName As %String, argUserName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User
	where SSUSR_Group->SSGRP_Desc like :argGroupName and (SSUSR_Name like :argUserName or SSUSR_Initials like :argUserName) and SSUSR_Active='Y' 
	order by SSUSR_name
}

Query GetAllCTLoc() As %SQLQuery
{
	select CTLOC_RowID,CTLOC_Code,CTLOC_Desc 
	from SQLUser.CT_Loc 
	order by CTLOC_RowID
}

Query GetCTLocByName(CTLocName As %String) As %SQLQuery
{
	select CTLOC_RowID,CTLOC_Code,CTLOC_Desc 
	from SQLUser.CT_Loc 
	where CTLOC_Desc like :CTLocName
}

Query SelectCTLocUserByCTLocName(CTLocName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User  
	where SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and SSUSR_Active='Y' 
	order by SSUSR_name
}

Query SelectCTLocUserByUserName(CTLocUser As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
	from SQLUser.SS_User
	where (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and SSUSR_Active='Y' 
	order by SSUSR_name
}

Query SelectCTLocUserByName(CTLocName As %String, CTLocUser As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_Password as Password
  	from SQLUser.SS_User 
	where SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and SSUSR_Active='Y' 
	order by SSUSR_name
}

/// Desc：获得用户信息
/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetHISUser","","","NSK-内三科","")
Query GetHISUser(AUserName As %String, AGroupName As %String, CTLocName As %String, CTLocUser As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,Password:%String,StartDate:%String,EndDate:%String,IsAvailable:%String,Role:%String,DisLoc:%String,Category:%String,QueryDate:%String,MedNos:%String,SSUserID:%String,RoleName:%String")
{
}

ClassMethod GetHISUserExecute(ByRef qHandle As %Binary, AUserName As %String, AGroupName As %String, CTLocName As %String, CTLocUser As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AUserName = $c(0)) AUserName = ""
	s:(CTLocName = $c(0)) CTLocName = ""
	s:(CTLocUser = $c(0)) CTLocUser = ""
	
	if ((AUserName '= "") && (AGroupName =""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectSSUserByUserName")
		s sc = rset.Execute(AUserName)
	}
	elseif ((AUserName '= "") && (AGroupName '=""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectSSUserByName")
		s sc = rset.Execute(AGroupName, AUserName)
	}
	elseif ((AUserName = "") && (AGroupName '= ""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectSSUserByGroupName")
		s sc = rset.Execute(AGroupName)	
	}
	elseif ((CTLocName '= "") && (CTLocUser '=""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectCTLocUserByName")
		s sc = rset.Execute(CTLocName,CTLocUser)
	}
	elseif ((CTLocName = "") && (CTLocUser '=""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectCTLocUserByUserName")
		s sc = rset.Execute(CTLocUser)
	}
	elseif ((CTLocName '= "") && (CTLocUser =""))
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectCTLocUserByCTLocName")
		s sc = rset.Execute(CTLocName)
	}
	else
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryUser:SelectSSUser")
		s sc = rset.Execute()		
	}
	
	while (rset.Next())
	{
		s ssUserID = rset.Data("ID")
		s Name = rset.Data("Name")
		s Code = rset.Data("Code")
		s Password = rset.Data("Password")
		s SDate = ""
		s EDate = ""
		s IsAvailable = ""
		s RoleID = ""
		s RoleName = ""
		s DisLoc = ""
		s Category = ""
		s QueryDate = ""
		s MedNos = ""
		
		s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " HIS"," "_$zcvt(Code,"U"),""))
		if (rowID '= "")
		{
			s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
			s SDate = $Case(obj.StartDate '= "",1:$zd(obj.StartDate,3))
			s IsAvailable = obj.IsAvailable
			s EDate = $zd($p($h,1),3)
			s RoleID = ..GetRoleByUserID(rowID)
			
			if ((RoleID '= "") && (RoleID '= $c(0)))
			{
				s roleObj = ##Class(DHCEPRFS.META.QueryRole).%OpenId(RoleID)
				s RoleName = roleObj.RoleDesc
			}
			s DisLoc = ..GetStringDisLocByUserID(rowID)
			s Category = ..GetRecordCategoryByUserID(rowID)
			s QueryDate = ..GetDisDateByUserID(rowID)
			s MedNos = ..GetMedNoByUserID(rowID)
		}
		else
		{
			s SDate = ""
			s EDate = ""
			s IsAvailable = ""
			s RoleID = ""
			s RoleName = ""
			s DisLoc = ""
			s Category = ""
			s QueryDate = ""
			s MedNos = ""
		}
		s ^CacheTemp(repid,ind) = $lb(ssUserID,Code,Name,Password,SDate,EDate,IsAvailable,RoleID,DisLoc,Category,QueryDate,MedNos,ssUserID,RoleName)
	    s ind=ind+1	
   }	
   Quit $$$OK
}

ClassMethod GetHISUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHISUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHISUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHISUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc：获得用户信息
/// Debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetTempUser")
Query GetTempUser(AUserCode As %String, AUserName As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,Password:%String,StartDate:%String,EndDate:%String,IsAvailable:%String,Role:%String,DisLoc:%String,Category:%String,QueryDate:%String,MedNos:%String")
{
}

ClassMethod GetTempUserExecute(ByRef qHandle As %Binary, AUserCode As %String, AUserName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	q:((AUserCode = "") && (AUserName = "")) 
	s rowID = ""
		
	if (AUserCode '= "")
	{
		for {
			s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode", " TEMP"," "_AUserCode,rowID))
	   	 	q:(rowID = "")
	    	d OUTPUT(rowID)
		}		
	}
	elseif (AUserName '= "")
	{
		for {
			s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserName", " TEMP"," "_AUserName,rowID))
	   	 	q:(rowID = "")
	    	d OUTPUT(rowID)
		}	
	}
 	
	Quit $$$OK
	
OUTPUT(rowID)
	s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
	s Code = obj.UserCode
	s Name = obj.UserName
	s Password = obj.PassWord
	s SDate = $Case(obj.StartDate '= "",1:$zd(obj.StartDate,3))
	s EDate = $Case(obj.EndDate '= "",1:$zd(obj.EndDate,3))
	s IsAvailable = obj.IsAvailable
	s RoleID = ..GetRoleByUserID(rowID)
	s DisLoc = ..GetStringDisLocByUserID(rowID)
	s Category = ..GetRecordCategoryByUserID(rowID)
	s QueryDate = ..GetDisDateByUserID(rowID)
	s MedNos = ..GetMedNoByUserID(rowID)
	s ^CacheTemp(repid,ind) = $lb(rowID,Code,Name,Password,SDate,EDate,IsAvailable,RoleID,DisLoc,Category,QueryDate,MedNos)
	s ind=ind+1
}

ClassMethod GetTempUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTempUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Update:2022-11-16 yangshun 保存用户权限的时候，对加密的usercode与password解密
ClassMethod GetUserIDBySSUserID(SSUserRowID As %String, SSUserPassword As %String, SSUserInitial As %String, SSUserName As %String, ARoleID As %String, AIsAvailable As %String) As %String
{
	
	s rowID = $o(^DHCEPRFS.META.QueryUserI("IdxSSUserID", " "_SSUserRowID,""))
	
	
	//没有此用户信息，新建
	if ((rowID = "") || (rowID = $c(0)))
	{
   		s result = -1
	    s obj = ##Class(DHCEPRFS.META.QueryUser).%New()
	    s obj.StartDate = $p($h,",",1)
   		s obj.UserCode = ##class(DHCEPRFS.Util.Encryption).DecryptWithDay(SSUserInitial)
   		s obj.UserName = SSUserName
   		s obj.PassWord = SSUserPassword
   		s obj.IsAvailable = AIsAvailable
   		s obj.Type = "HIS"
   		s obj.SSUserID = SSUserRowID
   		TSTART
   			s sc = obj.%Save()
   			if ($$$ISOK(sc))
   			{
     			s result = ..AddRoleUser(ARoleID,obj.%Id())
     			if (result = 1) TCOMMIT  else  TROLLBACK 
   			}
   		d obj.%Close()
   		q obj.%Id()		
	}	
	else
	{
		s obj = ##Class(DHCEPRFS.META.QueryUser).%OpenId(rowID)
		s obj.IsAvailable = AIsAvailable
		s sc = obj.%Save()
		d obj.%Close()
		TSTART
     		s result = ..AddRoleUser(ARoleID,rowID)
     		if (result = 1) TCOMMIT  else  TROLLBACK 
		q rowID
	}
}

/// Desc:判断类中是否有某字段
/// Creator:yangpeng	2016.5.4
/// Input:className 类名
/// 		  fieldName 字段名
/// Output: 0=没有 1=有
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).CheckFieldExist("DHCEPRFS.META.QueryUser","UserCode")
ClassMethod CheckFieldExist(className As %String, fieldName As %String) As %String
{
	q:(($d(className)=0)||(className="")||($d(fieldName)=0)||(fieldName="")) "0"
	s ExistedTable=##class(%Dictionary.ClassDefinition).%OpenId(className)
	q:(ExistedTable="") "0"
	
	s fieldName = $tr(fieldName,"_","")
	s isExist="0"
	for i=1:1:ExistedTable.Properties.Count() 
	{
		s ExistedProperty=ExistedTable.Properties.GetAt(i)
		//w ExistedProperty.Name,!
		if $zcvt(ExistedProperty.Name,"U") = $zcvt(fieldName,"U")
		{
			s isExist="1"
			q 
		}
	}
	q isExist
}

/// Desc:	查询用户登录名对应的角色
/// Creator:yangpeng	2016.5.4
/// Input：	AUserCode 登录编码
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetRoleByUserCode","742")
Query GetRoleByUserCode(AUserCode As %String) As %Query(ROWSPEC = "Id:%String,RoleName:%String,RoleDesc:%String")
{
}

ClassMethod GetRoleByUserCodeExecute(ByRef qHandle As %Binary, AUserCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	s QueryUserRowID=""
 	for {
 		s QueryUserRowID=$o(^DHCEPRFS.META.QueryUserD(QueryUserRowID))
 		q:(QueryUserRowID="")
 		
 		s objQueryUser=##class(DHCEPRFS.META.QueryUser).%OpenId(QueryUserRowID)
 		if $zcvt(objQueryUser.UserCode,"U")=$zcvt(AUserCode,"U")
 		{
	 		s QueryUserRoleID=""
	 		s QueryUserRoleID=$o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_objQueryUser.%Id(),QueryUserRoleID))
	 		
	 		if (QueryUserRoleID'="")
	 		{
		 		s objQueryUserRole=##class(DHCEPRFS.META.QueryUserRole).%OpenId(QueryUserRoleID)
		 		s objQueryRole=##class(DHCEPRFS.META.QueryRole).%OpenId(objQueryUserRole.RoleID)
		 		s ^CacheTemp(repid,ind) = $lb(objQueryRole.%Id(),objQueryRole.RoleName,objQueryRole.RoleDesc )
				s ind = ind + 1
		 	}
	 	}
 	}

	quit $$$OK
}

ClassMethod GetRoleByUserCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleByUserCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetRoleByUserCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleByUserCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:根据现有用户复制一个临时子用户
/// Creator:yangpeng	2016.5.6
/// Input:AQueryUserID 父UserID
/// Output: “” 成功，非空报错内容
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).Copy2NewChildUser("128")
ClassMethod Copy2NewChildUser(AQueryUserID As %String) As %String
{
	s objQueryUser=##class(DHCEPRFS.META.QueryUser).%OpenId(AQueryUserID)
	
	s QueryUserGroupID=""
	s QueryUserGroupID=$o(^DHCEPRFS.META.QueryUserGroupI("IdxQueryUserID"," "_AQueryUserID,QueryUserGroupID))
	
	if (QueryUserGroupID'="")
	{
		q "该用户为子用户，不允许再生成子用户!"	
	}
	
	s newUserCodePostfix=""
	s QueryUserGroupID=""
	s LastQueryUserGroupID=""
	for {
		s QueryUserGroupID=$o(^DHCEPRFS.META.QueryUserGroupI("IdxParentQueryUserID"," "_AQueryUserID,QueryUserGroupID))
		q:(QueryUserGroupID="")
		s LastQueryUserGroupID=QueryUserGroupID
	}
	
	if (LastQueryUserGroupID="")
	{
		s newUserCodePostfix="01"
	}
	else
	{
		s objLastQueryUserGroup=##class(DHCEPRFS.META.QueryUserGroup).%OpenId(LastQueryUserGroupID)
		s objLastChildUser=##class(DHCEPRFS.META.QueryUser).%OpenId(objLastQueryUserGroup.QueryUserID)
		s newUserCodePostfix=$EXTRACT(objLastChildUser.UserCode,$l(objLastChildUser.UserCode)-1,$l(objLastChildUser.UserCode))
		s newUserCodePostfix=(+newUserCodePostfix)
		s newUserCodePostfix=newUserCodePostfix+1
		if ($l(newUserCodePostfix)=1)
		{
			s newUserCodePostfix="0"_newUserCodePostfix
		}
	}
	
	TSTART
	s $zt = "OnCopyChildEHandler"
	s objChildQueryUser=##class(DHCEPRFS.META.QueryUser).%New()
	
	s objChildQueryUser.UserCode=objQueryUser.UserCode_"_"_newUserCodePostfix
	s objChildQueryUser.UserName=objQueryUser.UserName
	s objChildQueryUser.PassWord=""
	s objChildQueryUser.StartDate=objQueryUser.StartDate
	s objChildQueryUser.EndDate=78527
	s objChildQueryUser.Type="TEMP"
	s objChildQueryUser.SSUserID=""
	s objChildQueryUser.IsAvailable=objQueryUser.IsAvailable
	
	s sc=objChildQueryUser.%Save()
	
	if $$$ISERR(sc)
	{
		TROLLBACK
		q "生成子用户出错"
	}
	
	s objQueryUserGroup=##class(DHCEPRFS.META.QueryUserGroup).%New()
	
	s objQueryUserGroup.QueryUserID=objChildQueryUser.%Id()
	s objQueryUserGroup.ParentQueryUserID=AQueryUserID
	
	s sc=objQueryUserGroup.%Save()
	
	if $$$ISERR(sc)
	{
		TROLLBACK
		q "生成子用户出错"
	}
	else
	{
		TCOMMIT
		q ""
	}
OnCopyChildEHandler
	TROLLBACK
	q "生成子用户出错!"
}

/// Desc:	查询用户下属的子用户
/// Creator:yangpeng	2016.5.11
/// Input：	AQueryUserID 用户ID
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetChildUsers","101")
Query GetChildUsers(AQueryUserID As %String) As %Query(ROWSPEC = "QueryUserId:%String,QueryUserCode:%String,QueryUserName:%String,RoleID:%String,RoleName:%String,RoleDesc:%String")
{
}

ClassMethod GetChildUsersExecute(ByRef qHandle As %Binary, AQueryUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	
 	d AddOneRow(AQueryUserID)	//添加自身
 	s QueryUserGroupID=""		//遍历QueryUserGroup表，查询所有child user
 	for {
 		s QueryUserGroupID=$o(^DHCEPRFS.META.QueryUserGroupI("IdxParentQueryUserID"," "_AQueryUserID,QueryUserGroupID))
 		q:(QueryUserGroupID="")
 		s objQueryUserGroup=##class(DHCEPRFS.META.QueryUserGroup).%OpenId(QueryUserGroupID)
 		//控制主界面只显示有效的用户
 		s objQueryUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(objQueryUserGroup.QueryUserID)
 		if (objQueryUser.IsAvailable)
 		{
			d AddOneRow(objQueryUserGroup.QueryUserID)
 		}
 	}
	quit $$$OK
AddOneRow(QueryUserID)
	if (QueryUserID = "0")
	{
		s RoleID=""
		s RoleName=""
		s RoleDesc=""
		s QueryUserRoleID=""	
		s UserCode = "admin"
		s UserName = "admin"
	}
	else
	{
		s objChildUser=##class(DHCEPRFS.META.QueryUser).%OpenId(QueryUserID)
	
		s RoleID=""
		s RoleName=""
		s RoleDesc=""
		s QueryUserRoleID=""
		s QueryUserRoleID=$o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_QueryUserID,QueryUserRoleID))
		if (QueryUserRoleID'="")
		{
 			s objUserRole=##class(DHCEPRFS.META.QueryUserRole).%OpenId(QueryUserRoleID)
 			s objRole=##class(DHCEPRFS.META.QueryRole).%OpenId(objUserRole.RoleID)
 			s RoleID=objRole.%Id()
			s RoleName=objRole.RoleName
			s RoleDesc=objRole.RoleDesc
 		}
 		s UserCode = objChildUser.UserCode
 		s UserName = objChildUser.UserName
	}
 	s ^CacheTemp(repid,ind) = $lb(QueryUserID,UserCode,UserName,RoleID,RoleName,RoleDesc )
	s ind = ind + 1
}

ClassMethod GetChildUsersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChildUsersExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetChildUsersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChildUsersExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:获取用户的角色名称
/// Creator:yangpeng	2016.5.17
/// Input:AQueryUserID 
/// Output: 角色名称
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).GetUserRoleName("128")
ClassMethod GetUserRoleName(AQueryUserID As %String) As %String
{
	s QueryUserRoleID=""		//通过User查找Role
	s QueryUserRoleID=$o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_AQueryUserID,QueryUserRoleID))
	
	s objQueryUserRole=##class(DHCEPRFS.META.QueryUserRole).%OpenId(QueryUserRoleID)
	
	if (objQueryUserRole="")
	{
		q ""
	}
	
	s objQueryRole=##class(DHCEPRFS.META.QueryRole).%OpenId(objQueryUserRole.RoleID)
	
	if (objQueryRole="")
	{
		q ""
	}
	else
	{
		q objQueryRole.RoleDesc
	}
}

/// Desc: 查找用户同院区的用户（本用户的角色必须有两个以上的父角色）
/// Output:
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetDistrictOperators("87")
ClassMethod GetDistrictOperators(AUserID As %String) As %ArrayOfDataTypes
{
	s arrUsers=##class(%ArrayOfDataTypes).%New() //符合条件的用户
	s QueryUserID=""
	if ($p(AUserID ,"^",1) = "TEMP")	//temp操作员
	{
		s QueryUserID=$p(AUserID ,"^",2)
	}
	else
	{
		s QueryUserID=$o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_AUserID,QueryUserID))
	}
	s objTempQueryUser=##class(DHCEPRFS.META.QueryUser).%OpenId(QueryUserID)
	
	if (objTempQueryUser="")	//未找到用户，则业务逻辑部分不需要判断是否本区
	{
		d arrUsers.SetAt("","ALLUSERS")
		q arrUsers
	}
	
	s QueryUserRoleID=""		//通过User查找Role
	s QueryUserRoleID=$o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_QueryUserID,QueryUserRoleID))
	
	s objQueryUserRole=##class(DHCEPRFS.META.QueryUserRole).%OpenId(QueryUserRoleID)
	s objRole=##class(DHCEPRFS.META.QueryRole).%OpenId(objQueryUserRole.RoleID)
	
	//检查是否存在DHCEPRFS.META.QueryRole.ParnetID字段
	s isExistParentID=##class(DHCEPRFS.BL.BLQueryUser).CheckFieldExist("DHCEPRFS.META.QueryRole","ParentID")
	s RoleParentID=""
	if (isExistParentID="1")
	{
		s RoleParentID=objRole.ParentID
	}
	
	if (RoleParentID="")	//如果角色表没有ParentID字段或ParentID字段为空，则业务逻辑部分不需要判断是否本区
	{
		d arrUsers.SetAt("","ALLUSERS")
		q arrUsers
	}
	s DistrictRoleID=""
	if ($l(RoleParentID,"^")>=2)	//小于两个ParentRole
	{
		s DistrictRoleID=$p(RoleParentID,"^",1)
	}
	else	//如果角色的父角色为1个，则业务逻辑部分不需要判断是否本区
	{
		d arrUsers.SetAt("","ALLUSERS")
		q arrUsers
	}
	
	s arrRoles=##class(%ArrayOfDataTypes).%New() 	//查找在同一分区的角色
	s QueryRoleID=""
	for {
		s QueryRoleID=$o(^DHCEPRFS.META.QueryRoleD(QueryRoleID))
		q:(QueryRoleID="")
		s objLoopRole=##class(DHCEPRFS.META.QueryRole).%OpenId(QueryRoleID)
		if (($p(objLoopRole.ParentID,"^",1)=DistrictRoleID)||(objLoopRole.%Id()=DistrictRoleID)) //父编码有分区角色的、自身就是分区角色
		{
			d arrRoles.SetAt(objLoopRole.%Id(),objLoopRole.%Id())
		}
	}
	
	
	s oneKey=""
	for {		//循环遍历Roles 
		s oneKey=arrRoles.Next(oneKey)
	 	q:(oneKey="")
	 	s oneQueryUserRoleID=""
	 	for { 	//查找Role下面的User
		 	s oneQueryUserRoleID=$o(^DHCEPRFS.META.QueryUserRoleI("IdxRoleID"," "_oneKey,oneQueryUserRoleID))
		 	q:(oneQueryUserRoleID="")
		 	s oneObjQueryUserRole=##class(DHCEPRFS.META.QueryUserRole).%OpenId(oneQueryUserRoleID)
		 	s oneObjQueryUser=##class(DHCEPRFS.META.QueryUser).%OpenId(oneObjQueryUserRole.UserID)
		 	if (oneObjQueryUser.Type="TEMP")
		 	{
			 	d arrUsers.SetAt(oneObjQueryUser.%Id(),"TEMP^"_oneObjQueryUser.%Id())
			}
			else
			{
				d arrUsers.SetAt(oneObjQueryUser.%Id(),oneObjQueryUser.SSUserID)	
			}
		}
	}
	q arrUsers
}

/// Desc: 查找用户同院区的用户
/// Output:
/// Debug: w ##class(DHCEPRFS.BL.BLQueryUser).TestGetDistrictOperators("87")
ClassMethod TestGetDistrictOperators(AUserID As %String) As %String
{
	s obj=..GetDistrictOperators(AUserID)
	s oneKey=""
	for {		//循环遍历Roles
		s oneKey=obj.Next(oneKey)
		q:(oneKey="")
		w oneKey,!
	}
	q ""
}

ClassMethod GetQueryUserID(AUserID As %String)
{
	s QueryUserID=""
	if ($p(AUserID ,"^",1) = "TEMP")	//temp操作员
	{
		s QueryUserID=$p(AUserID ,"^",2)
	}
	else
	{
		s QueryUserID=$o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_AUserID,QueryUserID))
	}
	
	q QueryUserID
}

ClassMethod GetQueryUserName(AUserID As %String)
{
	s QueryUserID=""
	if ($p(AUserID ,"^",1) = "TEMP")	//temp操作员
	{
		s QueryUserID=$p(AUserID ,"^",2)
	}
	else
	{
		s QueryUserID=$o(^DHCEPRFS.META.QueryUserI("IdxSSUserID"," "_AUserID,QueryUserID))
	}
	
	s obj = ##class(DHCEPRFS.META.QueryUser).%OpenId(QueryUserID)
	q obj.UserName
}

/// Desc：通过科室类型返回科室信息
/// Debug w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetAllLocByType","E")
Query GetAllLocByType(ACTLocType As %String) As %Query(ROWSPEC = "rowid:%String,Desc:%String,Name:%String,Alias:%String,DateActiveFrom:%String,DateActiveTo:%String,HospitalAreaID:%String")
{
}

ClassMethod GetAllLocByTypeExecute(ByRef qHandle As %Binary, ACTLocType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	if (ACTLocType = "")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.B.DepartmentD(rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.META.B.Department).%OpenId(rowID)
			s rowid = obj.DepartmentID
			s Desc = obj.Description
			s Name = obj.Name
			s Alias = obj.AliasNameInitial
			s DateActiveFrom = obj.DateActiveFrom
			if (DateActiveFrom '= "")
			{
				s DateActiveFrom = $zd(DateActiveFrom,3)
			}
			s DateActiveTo = obj.DateActiveTo
			if (DateActiveTo '= "")
			{
				s DateActiveTo = $zd(DateActiveTo,3)
			}
			s HospitalAreaID = obj.HospitalAreaID
			s ^CacheTemp(repid,ind) = $lb(rowid,Desc,Name,Alias,DateActiveFrom,DateActiveTo,HospitalAreaID)
			s ind=ind+1
		}
	}
	else
	{
		for i=1:1:$l(ACTLocType,"^")
		{
     		s ctLocType = $p(ACTLocType,"^",i)
     		
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRFS.META.B.DepartmentI("IdxCTLocType"," "_ctLocType,rowID))
				q:(rowID="")
				s obj = ##class(DHCEPRFS.META.B.Department).%OpenId(rowID)
				s rowid = obj.DepartmentID
				s Desc = obj.Description
				s Name = obj.Name
				s Alias = obj.AliasNameInitial
				s DateActiveFrom = obj.DateActiveFrom
				if (DateActiveFrom '= "")
				{
					s DateActiveFrom = $zd(DateActiveFrom,3)
				}
				s DateActiveTo = obj.DateActiveTo
				if (DateActiveTo '= "")
				{
					s DateActiveTo = $zd(DateActiveTo,3)
				}
				s HospitalAreaID = obj.HospitalAreaID
				s ^CacheTemp(repid,ind) = $lb(rowid,Desc,Name,Alias,DateActiveFrom,DateActiveTo,HospitalAreaID)
				s ind=ind+1			
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetAllLocByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllLocByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllLocByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllLocByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc：返回院区信息
/// Debug w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryUser","GetHospitalArea")
Query GetHospitalArea() As %Query(ROWSPEC = "rowid:%String,Desc:%String,Name:%String,Alias:%String,DateActiveFrom:%String,DateActiveTo:%String")
{
}

ClassMethod GetHospitalAreaExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	

	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.META.B.HospitalAreaD(rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.META.B.HospitalArea).%OpenId(rowID)
		s rowid = obj.HospitalAreaID
		s Desc = obj.Description
		s Name = obj.Name
		s Alias = obj.AliasNameInitial
		s DateActiveFrom = obj.DateActiveFrom
		if (DateActiveFrom '= "")
		{
			s DateActiveFrom = $zd(DateActiveFrom,3)
		}
		s DateActiveTo = obj.DateActiveTo
		if (DateActiveTo '= "")
		{
			s DateActiveTo = $zd(DateActiveTo,3)
		}

		s ^CacheTemp(repid,ind) = $lb(rowid,Desc,Name,Alias,DateActiveFrom,DateActiveTo)
		s ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetHospitalAreaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalAreaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospitalAreaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalAreaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

}
