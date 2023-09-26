Import SQLUser

Class web.DHCBL.CT.CTLocSimilarDepartment Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：李森
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.CTLocSimilarDepartment
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(DEPParRef As %String, DEPRowId As %String, DEPCTLOCDR As %String) As %String
{
	s flag="",flagc=""
	
	if (DEPRowId="")&(DEPParRef'="") //如果为空,增加时的重复判断
	{
		s flagc=$d(^CTLOC(DEPParRef,"DEP",0,"LOC",DEPCTLOCDR))
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：李森
/// CreatDate: 2012-8-29
/// Description：保存修改相似部门的内容
/// Table：User.CTLocSimilarDepartment
/// Input：web.Entity.CT.CTLocSimilarDepartment 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTLocSimilarDepartment).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocSimilarDepartment) As %String
{
	;s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..Validate(eobj.DEPParRef,eobj.DEPRowId,eobj.DEPCTLOCDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			Ts
			s obj=##class(User.CTLocSimilarDepartment).%New(eobj.DEPParRef)
			
			d:eobj.DEPParRef'="" obj.DEPParRefSetObjectId(eobj.DEPParRef)
			d obj.DEPCTLOCDRSetObjectId(eobj.DEPCTLOCDR)
			
			s CTLOCDesc1=$p($g(^CTLOC(eobj.DEPParRef)),"^",2)	
			s CTLOCDesc2=$p($g(^CTLOC(eobj.DEPCTLOCDR)),"^",2)	
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				d:eobj.DEPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc_SimilarDepartment","User.CTLocSimilarDepartment","相似部门",id,CTLOCDesc1_"->"_CTLOCDesc2,"A",eobj)
				d:eobj.DEPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc_SimilarDepartment","User.CTLocSimilarDepartment","相似部门",eobj.DEPRowId,CTLOCDesc1_"->"_CTLOCDesc2,"U",eobj)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("相似部门","web.DHCBL.CT.CTLocSimilarDepartment","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
	;ERROE
	;q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：李森
/// CreatDate: 2012-8-29
/// Description：根据ID删除相似部门的内容
/// Table：User.CTLocSimilarDepartment
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
	s result=""
	s eobj = ##class(web.Entity.CT.CTLocSimilarDepartment).%New()
	s pobj = ##class(User.CTLocSimilarDepartment).%OpenId(id)
	s eobj.DEPParRef = pobj.DEPParRef.%Id()
	s eobj.DEPCTLOCDR = pobj.DEPCTLOCDR.%Id()
	s CTLOCDesc1=$p($g(^CTLOC(eobj.DEPParRef)),"^",2)	
	s CTLOCDesc2=$p($g(^CTLOC(eobj.DEPCTLOCDR)),"^",2)
	s sc=##class(User.CTLocSimilarDepartment).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result= "{success:'true',info:'删除成功！'}"	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc_SimilarDepartment","User.CTLocSimilarDepartment","相似部门",id,CTLOCDesc1_"->"_CTLOCDesc2,"D",eobj)

	}
	else 
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("相似部门","web.DHCBL.CT.CTLocSimilarDepartment","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：李森
/// CreatDate: 2012-8-29
/// Description：查询相似部门的内容
/// Table：User.CTLocSimilarDepartment
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocSimilarDepartment","GetList","314","")
Query GetList(DEPParRef As %String, rowid As %String, DEPDesc As %String) As %Query(ROWSPEC = "DEPRowId,DEPCTLOCDRCode,DEPCTLOCDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DEPParRef As %String, rowid As %String, DEPDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s DEPRowId=rowid
		s DEPParRef=$p(rowid,"||",1)
		s Id=$p(rowid,"||",2)
		s DEPCTLOCDR=$p($g(^CTLOC(DEPParRef,"DEP",Id)),"^",1)
		s DEPCTLOCDRCode=""
		s:DEPCTLOCDR'="" DEPCTLOCDRCode=$p($g(^CTLOC(DEPCTLOCDR)),"^",1)
		s:DEPCTLOCDR'="" DEPCTLOCDR=$p($g(^CTLOC(DEPCTLOCDR)),"^",2)
		d OutputRow
	}
	else
	{
		s:DEPDesc'="" DEPDesc=$$ALPHAUP^SSUTIL4(DEPDesc) //转换成大写
		s Id=0
		f  s Id=$o(^CTLOC(DEPParRef,"DEP",Id)) q:Id=""  d
		.s DEPRowId=DEPParRef_"||"_Id
		.s DEPCTLOCDR=$p($g(^CTLOC(DEPParRef,"DEP",Id)),"^",1)
		.s DEPCTLOCDRCode=""
		.s:DEPCTLOCDR'="" DEPCTLOCDRCode=$p($g(^CTLOC(DEPCTLOCDR)),"^",1)
		.s:DEPCTLOCDR'="" DEPCTLOCDR=$p($g(^CTLOC(DEPCTLOCDR)),"^",2)
		.i ($$ALPHAUP^SSUTIL4(DEPCTLOCDR)[DEPDesc) d
		..d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DEPRowId,DEPCTLOCDRCode,DEPCTLOCDR)
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

}
