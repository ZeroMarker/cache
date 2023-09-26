Class web.DHCBL.KB.RoleSubFilterDef Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-4-2
/// Description：查询角色对照表
/// Table：%IHBI.RoleSubFilterDef
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.RoleSubFilterDef","GetList","","","")
Query GetList(rowid, parref, name) As %Query(ROWSPEC = "RoleRowId,RoleDR,ClassName,Filter")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, parref, name) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RoleRowId=rowid
		s RoleDR=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),2)  //角色名称
		s ClassName=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),3)  //表名称
		s Filter=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),4)  //过滤字符串
		
		d OutputRow
	}
	else
	{
		s:name'="" name=$ZCONVERT(name,"U")
		s RoleRowId=0
		for  
		{	
			s RoleRowId=$o(^%IHBI.RoleSubFilterDefD(RoleRowId)) q:RoleRowId="" 
			
			s RoleDR=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),2)  //角色名称
			s ClassName=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),3)  //表名称
			s ClassNameU=$ZCONVERT(ClassName,"U")
			s Filter=$listget($g(^%IHBI.RoleSubFilterDefD(RoleRowId)),4)  //过滤字符串
			
			i (ClassNameU[name)&((RoleDR=parref)||(parref=""))   //条件
			{
				d OutputRow
			}	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RoleRowId,RoleDR,ClassName,Filter)
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

/// Creator：高姗姗
/// CreatDate: 2015-4-2
/// Description：保存修改内容
/// Table：%IHBI.RoleSubFilterDef
/// Input：web.Entity.KB.RoleSubFilterDef 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.RoleSubFilterDef) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		/*
		s flag=..FormValidate(eobj.RoleRowId, eobj.RoleDR, eobj.ClassName)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{*/
			if (eobj.RoleRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.RoleSubFilterDef).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.RoleSubFilterDef).%OpenId(eobj.RoleRowId)

				s bobj = ##class(web.Entity.KB.RoleSubFilterDef).%New()
				s bobj.RoleRowId = eobj.RoleRowId
				s:obj.RoleDR'="" bobj.RoleDR = obj.RoleDR.%Id()
				s bobj.ClassName = obj.ClassName
				s bobj.Filter = obj.Filter
				
			}
			d:eobj.RoleDR'="" obj.RoleDRSetObjectId(eobj.RoleDR)
			d:eobj.RoleDR="" obj.RoleDRSetObjectId("")
			s obj.ClassName = eobj.ClassName
			s obj.Filter = eobj.Filter
	
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.RoleRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.RoleSubFilterDef","%IHBI.RoleSubFilterDef","角色对照表",id,eobj.ClassName,"A",eobj)
				d:eobj.RoleRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.RoleSubFilterDef","%IHBI.RoleSubFilterDef","角色对照表",eobj.RoleRowId,eobj.ClassName,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			}	
		//}
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：高姗姗
/// CreatDate: 2015-4-2
/// Description：获取修改时的记录
/// Table：%IHBI.RoleSubFilterDef
/// Other: d ##class(web.DHCBL.KB.RoleSubFilterDef).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.RoleSubFilterDef).%New()
	s pobj = ##class(%IHBI.RoleSubFilterDef).%OpenId(id)
	s eobj.RoleRowId = id
	s eobj.RoleDR = pobj.RoleDR.%Id()
	s eobj.ClassName = pobj.ClassName
	s eobj.Filter = pobj.Filter

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-4-2
/// Description:根据id删除
/// Table:%IHBI.RoleSubFilterDef
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.RoleSubFilterDef).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.RoleSubFilterDef).%New()
		s pobj = ##class(%IHBI.RoleSubFilterDef).%OpenId(id)
		s eobj.RoleRowId = id
		s eobj.RoleDR = pobj.RoleDR.%Id()
		s eobj.ClassName = pobj.ClassName
		s eobj.Filter = pobj.Filter
	
		s sc=##class(%IHBI.RoleSubFilterDef).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.RoleSubFilterDef","%IHBI.RoleSubFilterDef","角色对照表",id,eobj.ClassName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
