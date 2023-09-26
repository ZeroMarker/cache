Import SQLUser

/// 名称:收费项目查询
/// 描述:查询医嘱项与对应的库存项信息，并维护关联收费项
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-04-01
Class web.DHCBL.CT.DHCTarItemAlias Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 获取收费项别名
/// CreateDate: 2015-7-25
/// Creator:  陈莹
/// Table:User.DHCTarItemAlias
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarItemAlias","GetList","","","")
Query GetList(TARIRowId As %String, rowid As %String, desc As %String) As %Query(ROWSPEC = "TIARowId:%String,TIATARIDR:%String,TIADesc:%String,TIAAlias:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TARIRowId As %String, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") 
	{	
		s TIARowId=rowid
		s TIATARIDR=$p($g(^DHCTARAL(rowid)),"^",1)
		s TIAAlias=$p($g(^DHCTARAL(rowid)),"^",3)
		s TIADesc=$p($g(^DHCTARAL(rowid)),"^",2)
		d OutputRowALIAS
	}
	else
	{
		if (TARIRowId'="") 
		{
			s TIARowId=0
			for
			{
				s TIARowId=$o(^DHCTARAL("A",TARIRowId,TIARowId))  q:TIARowId=""
				s TIATARIDR=$p($g(^DHCTARAL(TIARowId)),"^",1)
				s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
				continue:TIAAlias=""
				s TIADesc=$p($g(^DHCTARAL(TIARowId)),"^",2)
				d OutputRowALIAS
			}
		}
	}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowALIAS
    set Data=$lb(TIARowId,TIATARIDR,TIADesc,TIAAlias)
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

/// Creator:陈莹
/// CreatDate:2016-12-13
/// Description:校验收费项目别名
/// Table:User.DHCTarItemAlias
/// Return:1 （重复）
/// Other:w ##class(web.DHCBL.CT.DHCTarItemAlias).FormValidate("","","")
ClassMethod FormValidate(id, aliastext, taridr) As %String
{
 	n (id,aliastext,taridr)	
 	q:(aliastext="")||(taridr="") 0
 	s tempr=$d(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(aliastext),taridr))
 	s tempr1=$o(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(aliastext),taridr,0))
	if ((tempr=0))||((tempr'=0)&(id=tempr1))
	{
		s flag=0
	}
	else
	{
		s flag=1
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2016-4-15
/// Description:新增或修改收费项别名
/// Table:User.DHCTarItemAlias
/// Input:id(DHCTarItemAlias的TIARowId) 
/// Return:成功返回"{success:'true',id:'55！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarItemAlias) As %String
{
	n (%session,eobj)
	s result=""
	//if $l(eobj.TIAAlias)>30 s eobj.TIAAlias=$e(eobj.TIAAlias,1,30)  ///超长时会报错，现在标准版是300，原来老版是30
	s flag=..FormValidate(eobj.TIARowId,eobj.TIAAlias,eobj.TIATARIDR)
	if flag=1 q "{success:'false',errorinfo:'该别名已经存在，请重新填写！'}"
	
	if (eobj.TIAAlias="") q "{success:'false',errorinfo:'别名不能为空，请重新填写！'}"
	if (eobj.TIATARIDR= "") q "{success:'false',errorinfo:'对应的收费项不能为空，请查看数据！'}"
	s:eobj.TIADesc="" eobj.TIADesc=$p($g(^DHCTARI(eobj.TIATARIDR)),"^",2)
	if (eobj.TIARowId="")       
	{
		s obj=##class(User.DHCTarItemAlias).%New()    	//增加
	}
	else                           
	{		
		s obj=##class(User.DHCTarItemAlias).%OpenId(eobj.TIARowId) //修改
		s bobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
		s bobj.TIADesc = obj.TIADesc
		s bobj.TIAAlias= obj.TIAAlias
		if $IsObject(obj.TIATARIDR){
			s bobj.TIATARIDR = obj.TIATARIDR.%Id() 
		}
	}
	
	s obj.TIAAlias= eobj.TIAAlias
	d:eobj.TIATARIDR'="" obj.TIATARIDRSetObjectId(eobj.TIATARIDR)
	d:eobj.TIATARIDR="" obj.TIATARIDRSetObjectId("")
	s obj.TIADesc = eobj.TIADesc
	ts
	s sc=obj.%Save()
	do obj.%Close()
	if $$$ISOK(sc){
		tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
		d:eobj.TIARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项目别名",id,eobj.TIAAlias,"A",eobj)		
		d:eobj.TIARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项目别名",id,eobj.TIAAlias,"U",eobj,bobj)
	}else{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目别名","web.DHCBL.CT.DHCTarItemAlias","SaveEntity",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}

	q result
}

/// Creator:陈莹
/// CreatDate:2016-4-15
/// Description:保存收费项别名
/// Table:User.DHCTarItemAlias
/// Input:  TIARowId^TIAAlias^TIATARIDR# TIARowId^TIAAlias^TIATARIDR
/// Return:成功返回"{success:'true',info:'保存成功！'}";失败返回"{success:'false',errorinfo:'保存失败！'}"
/// Other:d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveAll("1^ybz^1")
ClassMethod SaveAll(listData As %String) As %String
{
	n (%session,listData)
	s result="" 
	s msg=0
	s length=$length($g(listData),"&#")
	for i=1:1:length q:msg'=0  d 
	.s DataStr=$p($g(listData),"&#",i)
	.s eobj = ##class(web.Entity.CT.DHCTarItemAlias).%New()
	.s eobj.TIARowId=$p($g(DataStr),"^",1)
	.s eobj.TIAAlias=$p($g(DataStr),"^",2)
	.s eobj.TIATARIDR=$p($g(DataStr),"^",3)
	.q:(eobj.TIAAlias="")
	.q:(eobj.TIATARIDR="")
	.s eobj.TIADesc=$p($g(^DHCTARI(eobj.TIATARIDR)),"^",2)
	.s ret=..SaveEntity(eobj)
	.if (ret["false") d
	..s msg=1
	if (msg=0) d
	.s result= "{success:'true',info:'保存成功！'}"
	else  d
	.s result= "{success:'false',errorinfo:'保存失败！'}"
	
	q result
}

/// Creator:陈莹
/// CreatDate:2016-4-15
/// Description:根据id删除收费项别名
/// Table:User.DHCTarItemAlias
/// Input:id(DHCTarItemAlias的TIARowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.DHCTarItemAlias).DeleteData("1")
ClassMethod DeleteData(id) As %String
{
	n (id,%session)
	s result=""
	
	s eobj = ##class(web.Entity.CT.DHCTarItemAlias).%New()
	s eobj.TIARowId = id
	s eobj.TIATARIDR = $p($g(^DHCTARAL(id)),"^",1)
	s eobj.TIAAlias =$p($g(^DHCTARAL(id)),"^",3)
	s eobj.TIADesc = $p($g(^DHCTARAL(id)),"^",2)
	
	Tstart
	s sc=##class(User.DHCTarItemAlias).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItemAlias","User.DHCTarItemAlias","收费项目别名",id,eobj.TIAAlias,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目别名","web.DHCBL.CT.DHCTarItemAlias","DeleteData",eobj)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

}
