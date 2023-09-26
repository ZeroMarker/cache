/// 三方系统用户配置
/// 基础数据平台-likefan
/// 2023-03-24
Class web.DHCBL.CT.ThirdPartySystemUser Extends %RegisteredObject
{

/// Function：  第三方系统账号查询
/// Creator:    likefan
/// CreatDate:  2023-03-24
/// Table：     CF.BSP.SYS.ThirdPartySystemUser   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ThirdPartySystemUser","GetList","","")
Query GetList(rowid As %String, userdr As %String) As %Query(ROWSPEC = "TPSURowId,TPSUTPSParref,TPSUTPSDesc,TPSUUserDr,TPSUUserCode,TPSUUserName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, userdr As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	if (rowid'="") //根据rowid返回该条记录
	{
		s TPSUTPSParref=$lg($g(^CF.BSP.SYS.TPSUserD(rowid)),2)	//三方系统DR
		s TPSUTPSDesc=""
		s:TPSUTPSParref'="" TPSUTPSDesc=$p($g(^websys.ThirdPartySystemD(TPSUTPSParref)),"^",2)	//三方系统描述
		s TPSUUserDr=$lg($g(^CF.BSP.SYS.TPSUserD(rowid)),3)		//HIS用户DR
		s TPSUUserCode=$lg($g(^CF.BSP.SYS.TPSUserD(rowid)),4)		//三方系统用户代码
		s TPSUUserName=$lg($g(^CF.BSP.SYS.TPSUserD(rowid)),5)		//三方系统用户姓名
		d OutputRow
	}
	else
	{  
		s TPSURowId=0
		for 
		{
			s TPSURowId=$o(^CF.BSP.SYS.TPSUserD(TPSURowId)) q:TPSURowId=""
			s TPSUTPSParref=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),2)	//三方系统DR
			s TPSUTPSDesc=""
			s:TPSUTPSParref'="" TPSUTPSDesc=$p($g(^websys.ThirdPartySystemD(TPSUTPSParref)),"^",2)	//三方系统描述
			s TPSUUserDr=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),3)		//HIS用户DR
			s TPSUUserCode=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),4)		//三方系统用户代码
			s TPSUUserName=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),5)		//三方系统用户姓名
			continue:(userdr'="")&&(userdr'=TPSUUserDr)		//根据HIS用户查询
			d OutputRow
		}
	}
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(TPSURowId,TPSUTPSParref,TPSUTPSDesc,TPSUUserDr,TPSUUserCode,TPSUUserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Function： 修改时打开的数据
/// Creator:   likefan
/// CreatDate: 2023-03-24
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.ThirdPartySystemUser).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.ThirdPartySystemUser).%New()
	s obj = ##class(CF.BSP.SYS.ThirdPartySystemUser).%OpenId(id)
	s eobj.TPSURowId=id
	s:obj.TPSUTPSParref'="" eobj.TPSUTPSParref = obj.TPSUTPSParref.%Id()
	s eobj.TPSUUserDr= obj.TPSUUserDr
	s eobj.TPSUUserCode= obj.TPSUUserCode
	s eobj.TPSUUserName= obj.TPSUUserName
	s str = eobj.JsonS()    
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Function：数据重复验证方法 
/// Creator:  likefan
/// CreatDate:2023-03-24
/// Table：   CF.BSP.SYS.ThirdPartySystemUser
/// id	-本表rowid
/// tpsparref	-三方系统DR
/// userdr	-HIS用户DR
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    w ##class(web.DHCBL.CT.ThirdPartySystemUser).FormValidate("2","2","1")
ClassMethod FormValidate(id As %String, tpsparref As %String, userdr As %String) As %String
{
    s flag=0
    s TPSURowId=0
	for 
	{
		s TPSURowId=$o(^CF.BSP.SYS.TPSUserD(TPSURowId)) q:TPSURowId=""
		s TPSUTPSParref=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),2)	//三方系统DR
		s TPSUUserDr=$lg($g(^CF.BSP.SYS.TPSUserD(TPSURowId)),3)		//HIS用户DR
		if (tpsparref=TPSUTPSParref)&&(userdr=TPSUUserDr)
		{
			s:id'=TPSURowId flag=1
		}
	}
    q flag
}

/// Function    保存内容
/// Creator:    likefan
/// CreatDate:  2023-03-24
/// Table：     CF.BSP.SYS.ThirdPartySystemUser
/// Input：     web.Entity.CT.ThirdPartySystemUser  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.ThirdPartySystemUser).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ThirdPartySystemUser) As %String
{
	s result="" 
	s flag=  ..FormValidate(eobj.TPSURowId,eobj.TPSUTPSParref,eobj.TPSUUserDr)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该用户已存在一条该系统的账号！'}"
	}
	else
	{
		if (eobj.TPSURowId="")  
		{
			s obj=##class(CF.BSP.SYS.ThirdPartySystemUser).%New()
		}
		else              
		{
			s obj=##class(CF.BSP.SYS.ThirdPartySystemUser).%OpenId(eobj.TPSURowId)
			s bobj=##class(web.Entity.CT.ThirdPartySystemUser).%New()
			s bobj.TPSURowId=eobj.TPSURowId 
			s:obj.TPSUTPSParref'="" bobj.TPSUTPSParref = obj.TPSUTPSParref.%Id()
			s bobj.TPSUUserDr= obj.TPSUUserDr
			s bobj.TPSUUserCode= obj.TPSUUserCode
			s bobj.TPSUUserName= obj.TPSUUserName
		}

		d obj.TPSUTPSParrefSetObjectId(eobj.TPSUTPSParref)
		s obj.TPSUUserDr= eobj.TPSUUserDr
		s obj.TPSUUserCode= eobj.TPSUUserCode
		s obj.TPSUUserName= eobj.TPSUUserName

		TS
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
		TC
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
			d:eobj.TPSURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BSP_SYS.ThirdPartySystemUser","CF.BSP.SYS.ThirdPartySystemUser","第三方系统账号",id,eobj.TPSUUserName,"A",eobj)
			d:eobj.TPSURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BSP_SYS.ThirdPartySystemUser","CF.BSP.SYS.ThirdPartySystemUser","第三方系统账号",eobj.TPSURowId,eobj.TPSUUserName,"U",eobj,bobj)
		}
		else
		{
			TRO
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("第三方系统账号","web.DHCBL.CT.ThirdPartySystemUser","SaveData",eobj)
			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		}
	}  
	q result
}

/// Function:保存多条第三方系统账号数据
/// CreateDate:2023-03-24
/// Creator:likefan
/// Tables: CF.BSP.SYS.ThirdPartySystemUser
/// userdr -用户rowid
/// poststr -TPSURowId^TPSUTPSParref^TPSUUserCode^TPSUUserName
/// w ##class(web.DHCBL.CT.ThirdPartySystemUser).SaveAll("1","^^^")
ClassMethod SaveAll(userdr As %String, poststr As %String) As %String
{
	s result=""
	if (poststr'="")
	{
		s postlength=$l(poststr,"*")
		for i=1:1:postlength
		{
			s eobj=##class(web.Entity.CT.ThirdPartySystemUser).%New()
			s str=$p(poststr,"*",i)
			s eobj.TPSURowId = $p(str,"^",1)
			s eobj.TPSUUserDr = userdr
			s eobj.TPSUTPSParref = $p(str,"^",2)
			s eobj.TPSUUserCode = $p(str,"^",3)
			s eobj.TPSUUserName = $p(str,"^",4)
			s result= ..SaveEntity(eobj)
		}	
	}
	q result
}

/// Creator:likefan
/// CreatDate:2023-03-24
/// Description：根据ID删除内容
/// Table：CF.BSP.SYS.ThirdPartySystemUser
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.ThirdPartySystemUser).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(CF.BSP.SYS.ThirdPartySystemUser).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ThirdPartySystemUser).%New()
	s eobj.TPSURowId = id
	s:pobj.TPSUTPSParref'="" eobj.TPSUTPSParref = pobj.TPSUTPSParref.%Id()
	s eobj.TPSUUserDr= pobj.TPSUUserDr
	s eobj.TPSUUserCode= pobj.TPSUUserCode
	s eobj.TPSUUserName= pobj.TPSUUserName
	d pobj.%Close()
	k pobj
	Ts
	s sc=##class(CF.BSP.SYS.ThirdPartySystemUser).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BSP_SYS.ThirdPartySystemUser","CF.BSP.SYS.ThirdPartySystemUser","第三方系统账号",id,eobj.TPSUUserName,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("第三方系统账号","web.DHCBL.CT.ThirdPartySystemUser","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

/// Creator: likefan
/// CreatDate: 2023-03-24
/// Description: 删除某个用户的所有关联岗位数据
/// Input: 第三方系统账号rowid串
/// Return: 1
ClassMethod DeleteSelections(idstr As %String) As %String
{
	q:idstr="" ""
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..DeleteData(id)
	}
	q 1
}

/// Function：  第三方系统查询
/// Creator:    likefan
/// CreatDate:  2023-03-24
/// Table：     websys.ThirdPartySystem
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ThirdPartySystemUser","GetTPSDataForCmb1","","")
Query GetTPSDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "SysRowId,SysCode,SysDesc")
{
}

ClassMethod GetTPSDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	if (rowid'="") //根据rowid返回该条记录
	{
		s SysRowId=rowid
		s SysCode=$p($g(^websys.ThirdPartySystemD(SysRowId)),"^",1)		//第三方系统代码
		s SysDesc=$p($g(^websys.ThirdPartySystemD(SysRowId)),"^",2)		//第三方系统描述
		d OutputCmb1
	}
	else
	{  
		s SysRowId=0
		for 
		{
			s SysRowId=$o(^websys.ThirdPartySystemD(SysRowId)) q:SysRowId=""
			s SysCode=$p($g(^websys.ThirdPartySystemD(SysRowId)),"^",1)		//第三方系统代码
			s SysDesc=$p($g(^websys.ThirdPartySystemD(SysRowId)),"^",2)		//第三方系统描述
			if (desc'="")
			{
				continue:SysDesc'[desc
			}
			d OutputCmb1
		}
	}
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputCmb1  
    set Data=$lb(SysRowId,SysCode,SysDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTPSDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTPSDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTPSDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTPSDataForCmb1Execute ]
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

}
