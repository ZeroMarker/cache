/// 名称:科室用户配置
/// 描述:平台配置-科室用户配置
/// 编写者:基础数据平台-李可凡
/// 编写日期:2021-07-14
Class web.DHCBL.BDP.BDPCDSSDeptUserAut Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：提供科室用户配置科室列表查询
/// Table：User.CTLoc
/// Input：rowid,query,hospid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPCDSSDeptUserAut","GetLocList","","","","","")
Query GetLocList(rowid, query, enableflag, hospid, cdsscode) As %Query(ROWSPEC = "DeptID,DeptCode,DeptName,EnableFlag")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, rowid, query, enableflag, hospid, cdsscode) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	s:query'="" query=$ZCONVERT(query,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s DeptID=rowid
		s DeptCode=$p($g(^CTLOC(DeptID)),"^",1)		//科室代码	
		s DeptName=$p($g(^CTLOC(DeptID)),"^",2)		//科室名称
		s CTLOCHospitalDR=$p($g(^CTLOC(DeptID)),"^",22)     //医院
		s EnableFlag=..GetLocEnableFlag(DeptID,cdsscode)	//是否有权限
		d OutputLocRow
	}
	else
	{
		s DeptID=0
		for  
		{
			s DeptID=$o(^CTLOC(DeptID)) q:DeptID=""
			s DeptCode=$p($g(^CTLOC(DeptID)),"^",1)		//科室代码
			s DeptName=$p($g(^CTLOC(DeptID)),"^",2)		//科室名称
			s CTLOCHospitalDR=$p($g(^CTLOC(DeptID)),"^",22)     //医院
			s CTLOCDateActiveFrom=$p($g(^CTLOC(DeptID)),"^",24)    //开始日期
			s CTLOCDateActiveTo=$p($g(^CTLOC(DeptID)),"^",25)    //截止日期
			continue:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)
			continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
			s EnableFlag=..GetLocEnableFlag(DeptID,cdsscode)	//是否有权限
			continue:(enableflag'="")&&(EnableFlag'=enableflag)
			if (hospid'="")
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",DeptID,hospid)
	  			continue:showflag="N"
			}
			s PINYIN=""
			s:query'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DeptName)
			if (($ZCONVERT(DeptCode,"U")[query)||($ZCONVERT(DeptName,"U")[query)||($ZCONVERT(PINYIN,"U")[query))&&((hospid="")||((hospid'="")&&(CTLOCHospitalDR=hospid)))
			{
				d OutputLocRow
			}
		}
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputLocRow
    set Data=$lb(DeptID,DeptCode,DeptName,EnableFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：提供科室用户配置科室列表查询
/// Table：User.CTLoc
/// Input：rowid,query,hospid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPCDSSDeptUserAut","GetUserList","","","")
Query GetUserList(deptdr, query, enableflag, cdsscode) As %Query(ROWSPEC = "UserID,UserCode,UserDesc,EnableFlag")
{
}

ClassMethod GetUserListExecute(ByRef qHandle As %Binary, deptdr, query, enableflag, cdsscode) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	s:query'="" query=$ZCONVERT(query,"U")
	if (deptdr'="")
	{
		s UserID=0
		for  
		{
			s UserID=$o(^SSU("SSUSR",UserID)) q:UserID=""
			s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)       //人事ID
			s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)       //用户名
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",UserID)),"^",98) 	//医院
			s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",UserID)),"^",4)     //登录科室DR
			s SSUSRActive=$p($g(^SSU("SSUSR",UserID)),"^",19)      //是否激活
			s SSUSRDateFrom=$p($g(^SSU("SSUSR",UserID)),"^",96)  //开始日期
			s SSUSRDateTo=$p($g(^SSU("SSUSR",UserID)),"^",97)  //结束日期
			if (SSUSRActive="N")||((SSUSRDateFrom'="")&&(SSUSRDateFrom>+$h))||((SSUSRDateTo'="")&&(SSUSRDateTo<+$h))
			{
				continue
			}
			s outputflag=0
			if (SSUSRDefaultDeptDR=deptdr)
			{
				s outputflag=1
			}
			else
			{
				//其他登录科室权限
				s ChildSub=0
				for 
				{
					s ChildSub=$o(^SSU("SSUSR",UserID,"OTHLL",ChildSub)) q:ChildSub=""
					s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",1)
		  			s OTHLLHospitalDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",3)
		  			s OTHLLStartDate=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",4)
					s OTHLLEndDate=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",5)
					if ((OTHLLStartDate'="")&&(OTHLLStartDate>+$h))||((OTHLLEndDate'="")&&(OTHLLEndDate<+$h))
					{
						continue
					}
					if (OTHLLCTLOCDR=deptdr)
					{
						s outputflag=1
						q
					}
				}
			}
			if (outputflag=1)
			{
				s EnableFlag=..GetUserEnableFlag(deptdr,UserID,cdsscode)	//是否有权限
				continue:(enableflag'="")&&(EnableFlag'=enableflag)
				s PINYIN=""
				s:query'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserDesc)
				if ($ZCONVERT(UserCode,"U")[query)||($ZCONVERT(UserDesc,"U")[query)||($ZCONVERT(PINYIN,"U")[query)
				{
					d OutputUserRow
				}
			}
		}
	}
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputUserRow
    set Data=$lb(UserID,UserCode,UserDesc,EnableFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：判断某个科室是否授权
/// Input：deptid
/// Return：1 已授权	0 未授权
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetLocEnableFlag("","")
ClassMethod GetLocEnableFlag(deptid As %String, cdsscode) As %String
{
	q:deptid="" ""
	s flag=0
	s userid=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,""))	//从""开始，可查到-100000000000000
	s:(userid'="") flag=1
	q flag
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：判断某个科室下的某个用户是否授权
/// Input：deptid，userid
/// Return：1 已授权	0 未授权
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetUserEnableFlag("2","12308","mediway")
ClassMethod GetUserEnableFlag(deptid As %String, userid As %String, cdsscode) As %String
{
	q:deptid="" ""
	q:userid="" ""
	s flag=0
	s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,userid,0))
	if (ID'="")
	{
		s flag=1
	}
	else
	{
		s:$d(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,-100000000000000)) flag=1
	}
	q flag
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：保存 科室关联用户
/// Input: 科室字符串
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).SaveLocs("1")
ClassMethod SaveLocs(deptstr As %String, cdsscode As %String, delflag As %String = "") As %String
{
	s result="false"
	s errorflag=0
	TS
	if ($l(deptstr,"^")<=0)
	{
		s result="false"
	}
	else
	{
		for m=1:1:$l(deptstr,"^")
		{
			q:errorflag=1
			s LocID=$p(deptstr,"^",m)
			continue:LocID=""
			s UserID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),LocID,""))
			if (UserID'="")
			{
				d ..DeleteDataOfLoc(LocID,cdsscode)		//删除原先的关联
			}
			if (delflag="")		//添加权限操作
			{
				s eobj=##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
				s eobj.DeptDR = LocID	//科室DR
				s eobj.UserDR = ""	//用户DR
				s eobj.CreateDate=$ZDATETIME($HOROLOG,3)	//维护时间
				s eobj.CreateUser=$g(%session.Data("LOGON.USERID"))	//维护人员
				s eobj.CDSSServiceCode=cdsscode		//cdss服务代码
				s re= ..SaveEntity(eobj)
				
				s:re["false" errorflag=1
			}
		}
	}
	if (errorflag=1)
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：保存 科室关联用户
/// Input: deptid 科室ID,adduserstr 添加的用户字符,deluserstr 删除的用户字符串
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).SaveDatas("1","","")
ClassMethod SaveDatas(deptid As %String, adduserstr As %String, deluserstr As %String, cdsscode As %String = "") As %String
{
	q:deptid="" ""
	s result=""
	s addflag=""
	s delflag=""
	Ts
	if ((adduserstr="")&&(deluserstr=""))	//不选择用户
	{
		d ..DeleteDataOfLoc(deptid,cdsscode)		//删除原先的关联
		
		s eobj=##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
		s eobj.DeptDR = deptid	//科室DR
		s eobj.UserDR = ""		//用户DR
		s eobj.CreateDate=$ZDATETIME($HOROLOG,3)	//维护时间
		s eobj.CreateUser=$g(%session.Data("LOGON.USERID"))	//维护人员
		s eobj.CDSSServiceCode=cdsscode		//cdss服务代码
		s result= ..SaveEntity(eobj)
	}
	else
	{
		s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,-100000000000000,""))
		if (ID'="")	//删除全部关联
		{
			d ..DeleteData(ID)
		}
		if (adduserstr'="")
		{
			//保存关联
			for m=1:1:$l(adduserstr,"^")
			{
				s adduserid=$p(adduserstr,"^",m)
				q:adduserid=""
				s UserJoinDeptID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,adduserid,0))
				continue:(UserJoinDeptID'="")
				s eobj=##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
				s eobj.DeptDR = deptid	//科室DR
				s eobj.UserDR = adduserid	//用户DR
				s eobj.CreateDate=$ZDATETIME($HOROLOG,3)	//维护时间
				s eobj.CreateUser=$g(%session.Data("LOGON.USERID"))	//维护人员
				s eobj.CDSSServiceCode=cdsscode		//cdss服务代码
				s result= ..SaveEntity(eobj)		
				if (result["false")		//单条数据保存失败
				{
					s addflag=1
					q 
				}
				
			}
		}
		if (deluserstr'="")
		{
			//删除关联
			s UserID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,""))
			if (UserID'="")	//存在有权限的用户
			{
				for n=1:1:$l(deluserstr,"^")
				{
					s deluserid=$p(deluserstr,"^",n)
					q:deluserid=""
					s UserJoinDeptID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,deluserid,0))
					continue:(UserJoinDeptID="")
					s result=..DeleteData(UserJoinDeptID)
					if (result["false")		//单条数据删除失败
					{
						s delflag=1
						q 
					}
				}
			}
			else
			{
				s UserIDStr=..GetLocLinkUser(deptid)	//根据科室id获取有该科室登录权限的用户id串
				s UserID=""
				for i=1:1:$l(UserIDStr,"^")
				{
					s UserID=$p(UserIDStr,"^",i)
					//与入参id对比
					s continueflag=0
					for n=1:1:$l(deluserstr,"^")
					{
						s deluserid=$p(deluserstr,"^",n)
						q:deluserid=""
						q:continueflag=1
						s:UserID=deluserid continueflag=1
					}
					continue:continueflag=1		//过滤被删除权限的用户，将其余的用户保存
					
					s eobj=##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
					s eobj.DeptDR = deptid	//科室DR
					s eobj.UserDR = UserID	//用户DR
					s eobj.CreateDate=$ZDATETIME($HOROLOG,3)	//维护时间
					s eobj.CreateUser=$g(%session.Data("LOGON.USERID"))	//维护人员
					s eobj.CDSSServiceCode=cdsscode		//cdss服务代码
					s result=..SaveEntity(eobj)
					if (result["false")		//单条数据保存失败
					{
						s addflag=1
						q 
					}
				}
			}
		}
		if (addflag=1)||(delflag=1)	//保存失败
		{
			q result
		}
		else	//保存成功
		{
			s result="{success:'true'}"	
		}
	}
	if (result["false")
	{
		tro	
	}
	else
	{
		tc	
	}
	q result
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：重复校验
/// Input: 科室字符串
/// Return:1 重复	0 不重复
/// Other:w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).FormValidate("131","3","","")
ClassMethod FormValidate(id As %String, deptid As %String, userid As %String, cdsscode As %String = "") As %String
{
	q:deptid="" ""
	s flag=0
	if (userid="")
	{
		s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,-100000000000000,0))
		s:(ID'="")&&(ID'=id) flag=1
	}
	else
	{
		s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,userid,0))
		s:(ID'="")&&(ID'=id) flag=1
	}
	q flag
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：保存科室用户配置
/// Input: eobj As web.Entity.BDP.BDPCDSSDeptUserAut
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPCDSSDeptUserAut) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.DeptDR,eobj.UserDR,eobj.CDSSServiceCode)
		if flag=1
		{
			s result="{success:'false',errorinfo:'数据已存在！'}"
			q
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(User.BDPCDSSDeptUserAut).%New()
		}
		else	//修改
		{
			s obj=##class(User.BDPCDSSDeptUserAut).%OpenId(eobj.ID)
			s bobj = ##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
			s bobj.ID = eobj.ID
			s:obj.DeptDR'="" bobj.DeptDR = obj.DeptDR.%Id()	//科室DR
			s:obj.UserDR'="" bobj.UserDR = obj.UserDR.%Id()	//用户DR
			s bobj.CreateDate=obj.CreateDate	//维护时间
			s:obj.CreateUser'="" bobj.CreateUser=obj.CreateUser.%Id()	//维护人员
			s bobj.Remarks=obj.Remarks	//备注
			s bobj.CDSSServiceCode=obj.CDSSServiceCode	//cdss服务代码
		}
		
		d obj.DeptDRSetObjectId(eobj.DeptDR)	//科室DR
		d obj.UserDRSetObjectId(eobj.UserDR)	//用户DR
		s obj.CreateDate=eobj.CreateDate	//维护时间
		d obj.CreateUserSetObjectId(eobj.CreateUser)	//维护人员
		s obj.Remarks=eobj.Remarks	//备注
		s obj.CDSSServiceCode=eobj.CDSSServiceCode	//cdss服务代码
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPCDSSDeptUserAut","User.BDPCDSSDeptUserAut","科室用户配置",id,eobj.DeptDR_"-"_eobj.UserDR,"A",eobj)
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPCDSSDeptUserAut","User.BDPCDSSDeptUserAut","科室用户配置",id,eobj.DeptDR_"-"_eobj.UserDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室用户配置","web.DHCBL.BDP.BDPCDSSDeptUserAut","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：根据id删除 这个科室关联的所有用户
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).DeleteDataOfLoc(1)
ClassMethod DeleteDataOfLoc(locid As %String, cdsscode As %String = "") As %String
{
	s result=""
	s userid=""
	for
	{
		s userid=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),locid,userid)) q:userid=""
		s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),locid,userid,0))
		if (ID'="")
		{
			s re=..DeleteData(ID)
			if (re["false")
			{
				s result="false"
				q
			}
		}
	}
	s:result="" result="true"
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate:  2021-07-14
/// Description：根据id删除科室用户配置
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.BDPCDSSDeptUserAut).%OpenId(id)
	s eobj = ##class(web.Entity.BDP.BDPCDSSDeptUserAut).%New()
	s:pobj.DeptDR'="" eobj.DeptDR = pobj.DeptDR.%Id()	//科室DR
	s:pobj.UserDR'="" eobj.UserDR = pobj.UserDR.%Id()	//用户DR
	s eobj.CreateDate=pobj.CreateDate	//维护时间
	s eobj.CreateUser=pobj.CreateUser	//维护人员
	s eobj.Remarks=pobj.Remarks	//备注
	s eobj.CDSSServiceCode=pobj.CDSSServiceCode	//cdss服务代码
	
	d pobj.%Close()
	k pobj
	Ts
	s sc=##class(User.BDPCDSSDeptUserAut).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPCDSSDeptUserAut","User.BDPCDSSDeptUserAut","科室用户配置",id,eobj.DeptDR_"-"_eobj.UserDR,"D",eobj)
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室用户配置","web.DHCBL.BDP.BDPCDSSDeptUserAut","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

// ********************************对外接口**************************************/

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-14
/// Description：通过科室id获取授权的用户，查询BDPCDSSDeptUserAut表
/// Input：deptid 
/// Return：用户串
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetUsersByLocid(1)
ClassMethod GetUsersByLocid(deptid As %String, cdsscode As %String = "") As %String
{
	q:deptid="" ""
	s userstr=""
	s userid=0
	for
	{
		s userid=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,userid)) q:userid=""
		continue:userid<0
		s:userstr'="" userstr=userstr_"^"
		s userstr=userstr_userid
	}
	q userstr
}

/// Creator：基础数据平台-李可凡
/// CreatDate:  2021-07-14
/// Description：根据科室id获取有该科室登录权限的用户
/// Input：locid 
/// Return：用户id串
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetLocLinkUser(1)
ClassMethod GetLocLinkUser(locid) As %String
{
	q:locid="" ""
	s useridstr=""
	s UserID=0
	for  
	{
		s UserID=$o(^SSU("SSUSR",UserID)) q:UserID=""
		s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)       //人事ID
		s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)       //用户名
		s SSUSRHospitalDR=$p($g(^SSU("SSUSR",UserID)),"^",98) 	//医院
		s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",UserID)),"^",4)     //登录科室DR
		s SSUSRActive=$p($g(^SSU("SSUSR",UserID)),"^",19)      //是否激活
		s SSUSRDateFrom=$p($g(^SSU("SSUSR",UserID)),"^",96)  //开始日期
		s SSUSRDateTo=$p($g(^SSU("SSUSR",UserID)),"^",97)  //结束日期
		continue:SSUSRActive="N"
		continue:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$h)
		continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
		s outputflag=0
		if (SSUSRDefaultDeptDR=locid)
		{
			s outputflag=1
		}
		else
		{
			//其他登录科室权限
			s ChildSub=0
			for 
			{
				s ChildSub=$o(^SSU("SSUSR",UserID,"OTHLL",ChildSub)) q:ChildSub=""
				s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",1)
	  			s OTHLLHospitalDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",3)
	  			s OTHLLStartDate=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",4)
				s OTHLLEndDate=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",5)
				continue:(OTHLLStartDate'="")&&(OTHLLStartDate>+$h)
				continue:(OTHLLEndDate'="")&&(OTHLLEndDate<+$h)
				if (OTHLLCTLOCDR=locid)
				{
					s outputflag=1
					q
				}
			}
		}
		if (outputflag=1)
		{
			s:useridstr'="" useridstr=useridstr_"^"
			s useridstr=useridstr_UserID
		}
	}
	q useridstr
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2021-07-15
/// Description：判断某个科室下的某个用户是否授权CDSS
/// Input：deptid，userid,cdsscode(临床决策支持配置表rowid)
/// Return：1 已授权	0 未授权
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetCDSSUserAutFlag("","")
ClassMethod GetCDSSUserAutFlag(deptid As %String, userid As %String, cdsscode As %String = "") As %String
{
	s flag=0
	q:deptid="" flag
	q:userid="" flag
	s CDSSAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("CDSSAut")	//是否开启CDSS功能
	q:'((CDSSAutFlag="1")||(CDSSAutFlag="Y")) flag
	
	if (cdsscode="")
	{
		s cdsscode=$o(^CF.BSP.SYS.CDSSServiceI("CodeInd"," MEDIWAY",0))	//为空的当MEDIWAY处理
		s:cdsscode="" cdsscode="1"
	}
	
	s MedActive=$lg($g(^CF.BSP.SYS.CDSSServiceD(cdsscode)),8)	//临床决策支持配置激活状态
	q:MedActive'=1 flag
	
	s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,userid,0))
	if (ID'="")
	{
		s flag=1
	}
	else
	{
		s locflag=$d(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,-100000000000000))
		s otherID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," "_$ZCONVERT(cdsscode,"U"),deptid,-100000000000000))
		if (locflag'=0)&&(otherID="")	//该科室只有这一条索引，科室下所有用户为授权
		{
			s userstr=..GetLocLinkUser(deptid)	//判断该用户是否有该科室登录权限
			for i=1:1:$l(userstr,"^")
			{
				s UserID=$p(userstr,"^",i)
				if (UserID=userid)
				{
					s flag=1
					q
				}
			}
		}
	}
	
	if (cdsscode="1")	//为1时再找一遍CDSSServiceCode为空的权限
	{
		s ID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," ",deptid,userid,0))
		if (ID'="")
		{
			s flag=1
		}
		else
		{
			s locflag=$d(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," ",deptid,-100000000000000))
			s otherID=$o(^User.BDPCDSSDeptUserAutI("ServiceDeptUserIndex"," ",deptid,-100000000000000))
			if (locflag'=0)&&(otherID="")	//该科室只有这一条索引，科室下所有用户为授权
			{
				s userstr=..GetLocLinkUser(deptid)	//判断该用户是否有该科室登录权限
				for i=1:1:$l(userstr,"^")
				{
					s UserID=$p(userstr,"^",i)
					if (UserID=userid)
					{
						s flag=1
						q
					}
				}
			}
		}
	}
	
	q flag
}

/// 批量修改cdss服务代码(仅修改空数据)
/// w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).UpdateCDSSServiceCode("mediway")
ClassMethod UpdateCDSSServiceCode(cdsscode As %String) As %String
{
	q:cdsscode="" ""
	s ID=""
	for
	{
		s ID=$o(^User.BDPCDSSDeptUserAutD(ID)) q:ID=""
		s CDSSServiceCode=$lg($g(^User.BDPCDSSDeptUserAutD(ID)),7)
		//w CDSSServiceCode,!
		if (CDSSServiceCode="")
		{
			s obj=##class(User.BDPCDSSDeptUserAut).%OpenId(ID)
			s obj.CDSSServiceCode=cdsscode	//cdss服务代码
			s sc=obj.%Save()
			d obj.%Close()
		}
	}
	q "ok"
}

/// Creator:基础数据平台-李可凡
/// CreatDate: 2022-06-29
/// Description：判断某个科室下的某个用户是否授权CDSS，返回CDSS代码
/// Input：deptid，userid
/// Return：CDSSCode
/// Other: w ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetCDSSCodeByDeptUser("","")
ClassMethod GetCDSSCodeByDeptUser(deptid As %String, userid As %String) As %String
{
	q:deptid="" ""
	q:userid="" ""
	s result=""
	s CodeArr=""	//定义数组筛选重复代码
	if $d(^User.BDPCDSSDeptUserAutI("DeptUserAutIndex",deptid,userid))
	{
		s ID=0
		for
		{
			s ID=$o(^User.BDPCDSSDeptUserAutI("DeptUserAutIndex",deptid,userid,ID))	q:ID=""
			s CDSSCode=$lg($g(^User.BDPCDSSDeptUserAutD(ID)),7)		//CDSS代码
			s:CDSSCode="" CDSSCode="1"
			s CodeArr(CDSSCode)=""
		}
	}
	if $d(^User.BDPCDSSDeptUserAutI("DeptUserAutIndex",deptid,-100000000000000))	//该科室下所有有权登录用户，都授权CDSS
	{
		s IncludeFlag=0
		s userstr=..GetLocLinkUser(deptid)	//判断该用户是否有该科室登录权限
		for i=1:1:$l(userstr,"^")
		{
			s UserID=$p(userstr,"^",i)
			if (UserID=userid)
			{
				s IncludeFlag=1
				q
			}
		}
		if (IncludeFlag=1)
		{
			s ID=0
			for
			{
				s ID=$o(^User.BDPCDSSDeptUserAutI("DeptUserAutIndex",deptid,-100000000000000,ID))	q:ID=""
				s CDSSCode=$lg($g(^User.BDPCDSSDeptUserAutD(ID)),7)		//CDSS代码
				s:CDSSCode="" CDSSCode="1"
				s CodeArr(CDSSCode)=""
			}
		}
	}
	s code=0
	for
	{
		s code=$o(CodeArr(code)) q:code=""
		s:result'="" result=result_"^"
		s result=result_code
	}
	q result
}

}
