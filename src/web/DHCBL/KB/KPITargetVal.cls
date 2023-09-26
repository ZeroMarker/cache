Class web.DHCBL.KB.KPITargetVal Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-3-25
/// Description：查询KPI目标值维护表
/// Table：%IHBI.KPITargetVal
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KPITargetVal","GetList","","","")
Query GetList(rowid, parref, name) As %Query(ROWSPEC = "KPIRowId,KPIDR,KPIName,ElementName,TargetVal,Period,TargetDate")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, parref, name) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s KPIRowId=rowid
		s ElementName=$listget($g(^IHBI.KPITargetValD(KPIRowId)),1)  //因素名称
		s KPIDR=$listget($g(^IHBI.KPITargetValD(KPIRowId)),2)  //指标条件
		s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIDR)),2)  //指标名称
		s TargetVal=$listget($g(^IHBI.KPITargetValD(KPIRowId)),3)  //目标值
		s Period=$listget($g(^IHBI.KPITargetValD(KPIRowId)),4)  //周期类型
		s TargetDate=$listget($g(^IHBI.KPITargetValD(KPIRowId)),5)  //目标值日期
		s:TargetDate'="" TargetDate=$zd(TargetDate,1) //转换日期格式
		
		d OutputRow
	}
	else
	{
		s:parref'="" parref=$ZCONVERT(parref,"U")
		s:name'="" name=$ZCONVERT(name,"U")
		s KPIRowId=0
		for  
		{	
			s KPIRowId=$o(^IHBI.KPITargetValD(KPIRowId)) q:KPIRowId="" 
				
			s ElementName=$listget($g(^IHBI.KPITargetValD(KPIRowId)),1)  //因素名称
			s ElementNameU=$ZCONVERT(ElementName,"U")
			s KPIDR=$listget($g(^IHBI.KPITargetValD(KPIRowId)),2)  //指标条件
			s KPIDRU=$ZCONVERT(KPIDR,"U")
			s KPIName=$listget($g(^IHBI.BaseKPIDefineD(KPIDR)),2)  //指标名称
			s TargetVal=$listget($g(^IHBI.KPITargetValD(KPIRowId)),3)  //目标值
			s Period=$listget($g(^IHBI.KPITargetValD(KPIRowId)),4)  //周期类型
			s TargetDate=$listget($g(^IHBI.KPITargetValD(KPIRowId)),5)  //目标值日期
			s:TargetDate'="" TargetDate=$zd(TargetDate,1) //转换日期格式
			
			i (ElementNameU[name)&((KPIDRU=parref)||(parref=""))   //条件
			{
				d OutputRow
			}	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KPIRowId,KPIDR,KPIName,ElementName,TargetVal,Period,TargetDate)
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
/// CreatDate: 2015-3-25
/// Description：保存修改内容
/// Table：%IHBI.KPITargetVal
/// Input：web.Entity.KB.KPITargetVal 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.KPITargetVal) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		/*
		s flag=..FormValidate(eobj.KPIRowId, eobj.KPIDR, eobj.ElementName)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{*/
			if (eobj.KPIRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.KPITargetVal).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.KPITargetVal).%OpenId(eobj.KPIRowId)

				s bobj = ##class(web.Entity.KB.KPITargetVal).%New()
				s bobj.KPIRowId = eobj.KPIRowId
				s:obj.KPIDR'="" bobj.KPIDR = obj.KPIDR.%Id()
				s bobj.ElementName = obj.ElementName
				s bobj.TargetVal = obj.TargetVal
				s bobj.Period = obj.Period
				s bobj.TargetDate = obj.TargetDate
				
			}
			d:eobj.KPIDR'="" obj.KPIDRSetObjectId(eobj.KPIDR)
			d:eobj.KPIDR="" obj.KPIDRSetObjectId("")
			s obj.ElementName = eobj.ElementName
			s obj.TargetVal = eobj.TargetVal
			s obj.Period = eobj.Period
			i eobj.TargetDate'=""
			{
				s obj.TargetDate = $zdh(eobj.TargetDate,15)
				s eobj.TargetDate = $zdh(eobj.TargetDate,15)
			}
			else
			{s obj.TargetDate=""}

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.KPIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KPITargetVal","%IHBI.KPITargetVal","KPI目标值维护表",id,eobj.ElementName,"A",eobj)
				d:eobj.KPIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KPITargetVal","%IHBI.KPITargetVal","KPI目标值维护表",eobj.KPIRowId,eobj.ElementName,"U",eobj,bobj)
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
/// CreatDate: 2015-3-6
/// Description：获取修改时的记录
/// Table：%IHBI.BaseKPIDefine
/// Other: d ##class(web.DHCBL.KB.KPITargetVal).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.KPITargetVal).%New()
	s pobj = ##class(%IHBI.KPITargetVal).%OpenId(id)
	s eobj.KPIRowId = id
	s eobj.KPIDR = pobj.KPIDR.%Id()
	s eobj.ElementName = pobj.ElementName
	s eobj.TargetVal = pobj.TargetVal
	s eobj.Period = pobj.Period
	s:pobj.TargetDate'="" eobj.TargetDate=$zd(pobj.TargetDate)
	s:pobj.TargetDate="" eobj.TargetDate=""

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-3-6
/// Description:根据id删除
/// Table:%IHBI.BaseKPIDefine
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.BaseKPIDefine).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.KPITargetVal).%New()
		s pobj = ##class(%IHBI.KPITargetVal).%OpenId(id)
		s eobj.KPIRowId = id
		s eobj.KPIDR = pobj.KPIDR.%Id()
		s eobj.ElementName = pobj.ElementName
		s eobj.TargetVal = pobj.TargetVal
		s eobj.Period = pobj.Period
		s eobj.TargetDate = pobj.TargetDate
	
		s sc=##class(%IHBI.KPITargetVal).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KPITargetVal","%IHBI.KPITargetVal","KPI目标值维护表",id,eobj.ElementName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
