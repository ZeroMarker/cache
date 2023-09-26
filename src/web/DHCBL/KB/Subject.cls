Class web.DHCBL.KB.Subject Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-3-20
/// Description：查询cube模型主题表内容
/// Table：%IHBI.CUBE.Subject
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.Subject","GetList","","","","","")
Query GetList(rowid, desc) As %Query(ROWSPEC = "SubjectRowId,SubjectCode,SubjectName,ClassName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s SubjectRowId=rowid
		s SubjectCode=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),1)  //代码
		s SubjectName=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),2)  //名称
		s ClassName=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),3)  //类名称
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s SubjectRowId=0
		for  
		{	
			s SubjectRowId=$o(^IHBI.CUBE.SubjectD(SubjectRowId)) q:SubjectRowId="" 
			
			s SubjectCode=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),1)  //代码
			s SubjectName=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),2)  //名称
			s SubjectNameU=$ZCONVERT(SubjectName,"U")
			s ClassName=$listget($g(^IHBI.CUBE.SubjectD(SubjectRowId)),3)  //类名称
		
				i (SubjectNameU[desc)   //条件
				{
					d OutputRow
				}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SubjectRowId,SubjectCode,SubjectName,ClassName)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-3-20    
/// w ##class(web.DHCBL.KB.Subject).FormValidate("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=""
	s flagd=""
	s flagd=$d(^IHBI.CUBE.SubjectI("SubjectCodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""	
		s idd=$o(^IHBI.CUBE.SubjectI("SubjectCodeIndex",code,0))
		if ((idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2015-3-20
/// Description：保存修改内容
/// Table：%IHBI.CUBE.Subject
/// Input：web.Entity.KB.Subject 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.Subject) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		s flag=..FormValidate(eobj.SubjectRowId, eobj.SubjectCode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.SubjectRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.CUBE.Subject).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.CUBE.Subject).%OpenId(eobj.SubjectRowId)

				s bobj = ##class(web.Entity.KB.Subject).%New()
				s bobj.SubjectRowId = eobj.SubjectRowId
				s bobj.SubjectCode = obj.SubjectCode
				s bobj.SubjectName = obj.SubjectName
				s bobj.ClassName = obj.ClassName
			}
	
			s obj.SubjectCode = eobj.SubjectCode
			s obj.SubjectName = eobj.SubjectName
			s obj.ClassName = eobj.ClassName

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.SubjectRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.Subject","%IHBI.CUBE.Subject","Cube模型主题表",id,eobj.SubjectName,"A",eobj)
				d:eobj.SubjectRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.Subject","%IHBI.CUBE.Subject","Cube模型主题表",eobj.SubjectRowId,eobj.SubjectName,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			}	
		}
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：获取修改时的记录
/// Table：%IHBI.CUBE.Subject
/// Other: d ##class(web.DHCBL.KB.Subject).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.Subject).%New()
	s pobj = ##class(%IHBI.CUBE.Subject).%OpenId(id)
	s eobj.SubjectRowId = id
	s eobj.SubjectCode = pobj.SubjectCode
	s eobj.SubjectName = pobj.SubjectName
	s eobj.ClassName = pobj.ClassName	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-2-26
/// Description:根据id删除
/// Table:%IHBI.CUBE.Subject
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.Subject).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.Subject).%New()
		s pobj = ##class(%IHBI.CUBE.Subject).%OpenId(id)
		s eobj.SubjectRowId = id
		s eobj.SubjectCode = pobj.SubjectCode
		s eobj.SubjectName = pobj.SubjectName
		s eobj.ClassName = pobj.ClassName
	
		s sc=##class(%IHBI.CUBE.Subject).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.Subject","%IHBI.CUBE.Subject","Cube模型主题表",id,eobj.SubjectName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
