Class web.DHCBL.KB.BasePivotFilter Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-3-12
/// Description：查询明细主题指标
/// Table：Data.BasePivotFilter
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.BasePivotFilter","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "KPIRowId,KPICode,KPIName,SubjectName,PivotFilter")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s KPIRowId=rowid
		s KPICode=$listget($g(^Data.BasePivotFilterD(KPIRowId)),2)  //指标代码
		s KPIName=$listget($g(^Data.BasePivotFilterD(KPIRowId)),3)  //指标名称
		s SubjectName=$listget($g(^Data.BasePivotFilterD(KPIRowId)),5)  //主题名称
		s PivotFilter=$listget($g(^Data.BasePivotFilterD(KPIRowId)),4)  //过滤条件
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s KPIRowId=0
		for  
		{	
			s KPIRowId=$o(^Data.BasePivotFilterD(KPIRowId)) q:KPIRowId="" 
			s KPICode=$listget($g(^Data.BasePivotFilterD(KPIRowId)),2)  //指标代码
			s KPICodeU=$ZCONVERT(KPICode,"U")
			s KPIName=$listget($g(^Data.BasePivotFilterD(KPIRowId)),3)  //指标名称
			s KPINameU=$ZCONVERT(KPIName,"U")
			s SubjectName=$listget($g(^Data.BasePivotFilterD(KPIRowId)),5)  //主题名称
			s PivotFilter=$listget($g(^Data.BasePivotFilterD(KPIRowId)),4)  //过滤条件
			
			i (KPICodeU[code)&(KPINameU[desc)   //条件
			{
				d OutputRow
			}		

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KPIRowId,KPICode,KPIName,SubjectName,PivotFilter)
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
/// CreateDate:2015-3-12    
/// w ##class(web.DHCBL.KB.BasePivotFilter).FormValidate("","Material")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=""
	s flagd=""
	s flagd=$d(^Data.BasePivotFilterI("UqKPICodeIdx"," "_code))
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
		s idd=$o(^Data.BasePivotFilterI("UqKPICodeIdx"," "_code,0))
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
/// CreatDate: 2015-3-12
/// Description：保存修改内容
/// Table：Data.BasePivotFilter
/// Input：web.Entity.KB.BasePivotFilter 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.BasePivotFilter) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		
		s flag=..FormValidate(eobj.KPIRowId, eobj.KPICode)  //调用重复验证
		if (flag=1)
		{
			//s result = "{success:'false',errorinfo:'该记录已经存在'}"
			s result = "{success:'false',errorinfo:'暂且只能维护一条'}"
		}
		else
		{
			if (eobj.KPIRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(Data.BasePivotFilter).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(Data.BasePivotFilter).%OpenId(eobj.KPIRowId)

				s bobj = ##class(web.Entity.KB.BasePivotFilter).%New()
				s bobj.KPIRowId = eobj.KPIRowId
				s bobj.KPICode = obj.KPICode
				s bobj.KPIName = obj.KPIName
				s bobj.SubjectName = obj.SubjectName
				s bobj.PivotFilter = obj.PivotFilter
			}
			s obj.KPICode = eobj.KPICode
			s obj.KPIName = eobj.KPIName
			s obj.SubjectName = eobj.SubjectName
			s obj.PivotFilter = eobj.PivotFilter

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.KPIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("Data.BasePivotFilter","Data.BasePivotFilter","明细主题指标表",id,eobj.KPIName,"A",eobj)
				d:eobj.KPIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("Data.BasePivotFilter","Data.BasePivotFilter","明细主题指标表",eobj.KPIRowId,eobj.KPIName,"U",eobj,bobj)
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
/// CreatDate: 2015-3-12
/// Description：获取修改时的记录
/// Table：Data.BasePivotFilter
/// Other: d ##class(web.DHCBL.KB.BasePivotFilter).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.BasePivotFilter).%New()
	s pobj = ##class(Data.BasePivotFilter).%OpenId(id)
	s eobj.KPIRowId = id
	s eobj.KPICode = pobj.KPICode
	s eobj.KPIName = pobj.KPIName
	s eobj.SubjectName = pobj.SubjectName
	s eobj.PivotFilter = pobj.PivotFilter

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-3-12
/// Description:根据id删除
/// Table:Data.BasePivotFilter
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.BasePivotFilter).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.BasePivotFilter).%New()
		s pobj = ##class(Data.BasePivotFilter).%OpenId(id)
		s eobj.KPIRowId = id
		s eobj.KPICode = pobj.KPICode
		s eobj.KPIName = pobj.KPIName
		s eobj.SubjectName = pobj.SubjectName
		s eobj.PivotFilter = pobj.PivotFilter
	
		s sc=##class(Data.BasePivotFilter).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("Data.BasePivotFilter","Data.BasePivotFilter","明细主题指标表",id,eobj.KPIName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
