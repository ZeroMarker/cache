Class web.DHCBL.KB.SubMeasure Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate: 2015-3-23
/// Description：查询主题维护明细
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.SubMeasure","GetList","3")
Query GetList(rowid As %String, parref As %String, desc As %String) As %Query(ROWSPEC = "SubRowId,SubParRef,MeasureDR,CatName,Definition")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'=""){
		s SubRowId=rowid
		s SubParRef=$p(SubRowId,"||",1)
		s Childsub=$p(SubRowId,"||",2)	
		s MeasureDR = $listget($g(^IHBI.CUBE.SubjectD(SubParRef,"ChildMeasure",Childsub)),1)
		s CatName = $listget($g(^BI.MeasureD(MeasureDR)),3)
		s Definition = $listget($g(^IHBI.CUBE.SubjectD(SubParRef,"ChildMeasure",Childsub)),2)
	
		d OutputRow	
	}else{
		if (parref'=""){
			s Childsub=0
			for {
				s Childsub=$o(^IHBI.CUBE.SubjectD(parref,"ChildMeasure",Childsub))  q:Childsub=""
				s SubRowId=parref_"||"_Childsub
				s MeasureDR = $listget($g(^IHBI.CUBE.SubjectD(parref,"ChildMeasure",Childsub)),1)
				s CatName = $listget($g(^BI.MeasureD(MeasureDR)),3)
				s Definition = $listget($g(^IHBI.CUBE.SubjectD(parref,"ChildMeasure",Childsub)),2)
				if (Childsub>0)&(Definition[desc)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SubRowId,SubParRef,MeasureDR,CatName,Definition)
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
/// CreatDate: 2015-3-23
/// Description：保存修改内容
/// Table：%IHBI.CUBE.SubMeasure
/// Input：web.Entity.KB.SubMeasure 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.SubMeasure) As %String
{
	
 s result = ""
 /*
 if ( )
  {
	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
 else{*/
	if $IsObject(eobj)
	{
		Ts

			if (eobj.SubRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.CUBE.SubMeasure).%New(eobj.SubParRef)
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.CUBE.SubMeasure).%OpenId(eobj.SubRowId)
				s bobj = ##class(web.Entity.KB.SubMeasure).%New()
				s bobj.SubRowId = eobj.SubRowId
				s bobj.SubParRef=$p(eobj.SubRowId,"||",1)
				s:obj.MeasureDR'="" bobj.MeasureDR = obj.MeasureDR.%Id()
				s bobj.Definition=  obj.Definition
			}
			d obj.SubParRefSetObjectId(eobj.SubParRef)
			d:eobj.MeasureDR'="" obj.MeasureDRSetObjectId(eobj.MeasureDR)
			d:eobj.MeasureDR="" obj.MeasureDRSetObjectId("")
			s:eobj.MeasureDR'="" CatName=$listget($g(^BI.MeasureD(eobj.MeasureDR)),3)
			s obj.Definition = eobj.Definition

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.SubRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.SubMeasure","%IHBI.CUBE.SubMeasure","主题维护明细",id,CatName,"A",eobj)
				d:eobj.SubRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.SubMeasure","%IHBI.CUBE.SubMeasure","主题维护明细",eobj.SubRowId,CatName,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
 //}
	q result
}

/// Description：修改时打开的数据
/// Table：%IHBI.CUBE.SubMeasure
/// Input：id
/// Other: w ##class(web.DHCBL.KB.SubMeasure).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(%IHBI.CUBE.SubMeasure).%OpenId(id)
	s eobj = ##class(web.Entity.KB.SubMeasure).%New()
	s eobj.SubRowId=id
	s eobj.SubParRef=$p(id,"||",1)
	s:pobj.MeasureDR'="" eobj.MeasureDR=pobj.MeasureDR.%Id()	
	s eobj.Definition = pobj.Definition
	
	d pobj.%Close()
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Description：根据ID删除
/// Table：%IHBI.CUBE.SubMeasure
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	s pobj=##class(%IHBI.CUBE.SubMeasure).%OpenId(id)
	s eobj = ##class(web.Entity.KB.SubMeasure).%New()
	s eobj.SubRowId = id
	s eobj.SubParRef=$p(id,"||",1)
	s:pobj.MeasureDR'="" eobj.MeasureDR=pobj.MeasureDR
	s:pobj.MeasureDR'="" CatName=$listget($g(^BI.MeasureD(pobj.MeasureDR)),3)
	s eobj.Definition=pobj.Definition
	
	d pobj.%Close()
	Tstart
	s sc=##class(%IHBI.CUBE.SubMeasure).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.CUBE.SubMeasure","%IHBI.CUBE.SubMeasure","主题维护明细",id,CatName,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

/// w ##class(web.DHCBL.KB.SubMeasure).SubjectGenerator("StatDoctorKPI","医生级指标汇总主题")
ClassMethod SubjectGenerator(Code As %String, Name As %String) As %String
{
	s result=""
	s sc= ##class(%IHBI.CUBE.CodeGen).SubjectGenerator(Code,Name)
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'生成成功！'}"	
	}
	else 
	{
		//s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		s result = "{success:'false',info:'生成失败！'}"
	}
	q result
}

}
