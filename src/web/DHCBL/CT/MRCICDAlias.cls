Import SQLUser

/// 名称: ICD诊断代码别名维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-李森
/// 编写日期: 2014-7-18
Class web.DHCBL.CT.MRCICDAlias Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：李森
/// CreatDate: 2014-7-18
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(ref As %String, id As %String, text As %String) As %String
{
	n (ref,id,text)
	s:text'="" text=$ZCONVERT(text,"U") //转换成大写
	q:text="" ""
	s flag=""
	if (id="") //添加时id为空，ref不为空
	{
		s ff=$d(^MRC("ID",0,"ALIAS",text,ref))
		if (ff>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}	
	}
	else //修改时ref不为空，id不为空
	{
		s ALIASParRef=$p(id,"||",1)
		s ALIASChildsub=$p(id,"||",2)
		s ff=$d(^MRC("ID",0,"ALIAS",text,ALIASParRef))
		s fs=$o(^MRC("ID",0,"ALIAS",text,ALIASParRef,0))
		if (ff=0)||((ff'=0)&(fs=ALIASChildsub))
		{
			s flag=0  //返回重复标志
		}
		else
		{
			s flag=1 //返回不重复标志
		}	
	}
	q flag
}

/// Creator：李森
/// CreatDate: 2014-7-18
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCICDAlias) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ALIASText'="" eobj.ALIASText=$ZCONVERT(eobj.ALIASText,"U") //转换成大写
		s flag=..FormValidate(eobj.ALIASParRef,eobj.ALIASRowId,eobj.ALIASText)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ALIASRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MRCICDAlias).%New(eobj.ALIASParRef)
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.MRCICDAlias).%OpenId(eobj.ALIASRowId)
				s bobj=##class(web.Entity.CT.MRCICDAlias).%New()
				s bobj.ALIASRowId = eobj.ALIASRowId
				s bobj.ALIASParRef=$p(eobj.ALIASRowId,"||",1)
				s bobj.ALIASText = obj.ALIASText
			}
			
			d:eobj.ALIASRowId="" obj.ALIASParRefSetObjectId(eobj.ALIASParRef)
			s obj.ALIASText = eobj.ALIASText
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.ALIASRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDAlias","User.MRCICDAlias","ICD诊断代码别名维护",id,eobj.ALIASText,"A",eobj)
				d:eobj.ALIASRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDAlias","User.MRCICDAlias","ICD诊断代码别名维护",eobj.ALIASRowId,eobj.ALIASText,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码别名维护","web.DHCBL.CT.MRCICDAlias","SaveEntity",eobj)
     			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// createdate:2015-1-14
/// RowId^ALIASText^ALIASParRef # RowId^ALIASText^ALIASParRef
ClassMethod SaveAll(listData As %String) As %String
{
	n (listData,%session)
	s result="" 
	s msg=0
	s length=$length($g(listData),"#")
	for i=1:1:length q:msg'=0  d 
	.s DataStr=$p($g(listData),"#",i)
	.s eobj = ##class(web.Entity.CT.MRCICDAlias).%New()
	.s eobj.ALIASRowId=$p($g(DataStr),"^",1)
	.s eobj.ALIASText=$p($g(DataStr),"^",2)
	.s eobj.ALIASParRef=$p($g(DataStr),"^",3)
	.s ret=..SaveEntity(eobj)
	.if (ret["false") d
	..s msg=1
	if (msg=0) d
	.s result= "{success:'true',info:'保存成功！'}"
	else  d
	.s result= "{success:'false',errorinfo:'保存失败！'}"
	
	q result
}

/// Creator：李森
/// CreatDate: 2014-7-18
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	
	s eobj = ##class(web.Entity.CT.MRCICDAlias).%New()
	s eobj.ALIASRowId = id
	s ref=$p(id,"||",1)
	s eobj.ALIASParRef=ref
	s ALIASChildsub=$p(id,"||",2)
	s eobj.ALIASText=$g(^MRC("ID",ref,"ALIAS",ALIASChildsub))
	ts
	s sc=##class(User.MRCICDAlias).%DeleteId(id)
	if $$$ISOK(sc)
	{
		tc
		s result= "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDAlias","User.MRCICDAlias","ICD诊断代码别名维护",id,eobj.ALIASText,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码别名维护","web.DHCBL.CT.MRCICDAlias","DeleteData",eobj)
     	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：李森
/// CreatDate: 2014-7-18
Query GetList(aliasparref As %String, rowid As %String) As %Query(ROWSPEC = "ALIASParRef:%String,ALIASRowId:%String,ALIASText:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, aliasparref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ALIASRowId=rowid
		s ALIASParRef=$p(rowid,"||",1)
		s ALIASChildsub=$p(rowid,"||",2)
		s ALIASText=$g(^MRC("ID",ALIASParRef,"ALIAS",ALIASChildsub))
		d OutputRow
	}
	else
	{
		s ALIASChildsub=0
		for {
			s ALIASChildsub=$o(^MRC("ID",aliasparref,"ALIAS",ALIASChildsub))
			q:ALIASChildsub=""
			s ALIASParRef=aliasparref
			s ALIASRowId=aliasparref_"||"_ALIASChildsub
			s ALIASText=$g(^MRC("ID",aliasparref,"ALIAS",ALIASChildsub))
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ALIASParRef,ALIASRowId,ALIASText)
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
