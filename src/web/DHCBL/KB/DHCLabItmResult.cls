Import SQLUser

/// 名称: 检验项目与结果关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2013-11-6
Class web.DHCBL.KB.DHCLabItmResult Extends %RegisteredObject
{

/// Description：查询检验项目与结果关联表的内容
/// Table：User.DHCLabItmResult
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLabItmResult","GetList","","1","","")
Query GetNewList(rowid As %String, parref As %String, gen As %String, result As %String) As %Query(ROWSPEC = "PHLFIRowId:%String,PHLFIParRefDrF:%String,PHLFIGenDr:%String,PHLFIResult:%String,PHLFIParRefDr:%String,GenRowId:%String")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, gen As %String, result As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCLabItmResult).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s PHLFIRowId=$p(rowid,",",i)
			s LabItemRowId=$p(PHLFIRowId,"||",1)
			s PHLFIChildsub=$p(PHLFIRowId,"||",2)
			s PHLFIParRefDr=LabItemRowId
			s PHLFIParRefDrF=$p($g(^DHCLABIF(LabItemRowId)),"^",2)
			s GenRowId=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",1)
			s PHLFIResult=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",2)
			i GenRowId'="" 
			{
				s PHLFIGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			}
			else 
			{
				s PHLFIGenDr=""
			}
	
			d OutputNewRow
		}
	}
	else
	{
		s:result'="" result=$ZCONVERT(result,"U") //转换成大写
		s LabItemRowId=parref,PHLFIChildsub=0
		for 
		{
			S PHLFIChildsub=$o(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)) q:PHLFIChildsub=""
			s PHLFIRowId=LabItemRowId_"||"_PHLFIChildsub
			s PHLFIParRefDr=LabItemRowId
			s PHLFIParRefDrF=$p($g(^DHCLABIF(LabItemRowId)),"^",2)
			s GenRowId=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",1)
			s PHLFIResult=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",2)
			i GenRowId'="" 
			{
				s PHLFIGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			}
			else 
			{
				s PHLFIGenDr=""
			}
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLFIResult)
			if (PHLFIChildsub>0)&((GenRowId=gen)||(gen=""))&(($ZCONVERT(PHLFIResult,"U")[result)||(PINYIN[result))
			{
				d OutputNewRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(PHLFIRowId,PHLFIParRefDrF,PHLFIGenDr,PHLFIResult,PHLFIParRefDr,GenRowId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewListExecute ]
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

/// Description：修改时打开的数据
/// Table：User.DHCLabItmResult
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCLabItmResult).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCLabItmResult).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCLabItmResult).%New()
	s eobj.PHLFIRowId=id
	s eobj.PHLFIParRefDr=$p(id,"||",1)
	s eobj.PHLFIResult = pobj.PHLFIResult
	if $IsObject(pobj.PHLFIGenDr)
	{
		s eobj.PHLFIGenDr = pobj.PHLFIGenDr.%Id() 
	}		
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCLabItmResult
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCLabItmResult).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCLabItmResult).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCLabItmResult).%New()
	s eobj.PHLFIRowId=id
	s eobj.PHLFIParRefDr=$p(id,"||",1)
	s eobj.PHLFIResult = pobj.PHLFIResult
	if $IsObject(pobj.PHLFIGenDr)
	{
		s eobj.PHLFIGenDr = pobj.PHLFIGenDr.%Id() 
	}		
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：保存检验项目与结果关联表字典的内容
/// Table：User.DHCLabItmResult
/// Input：web.Entity.KB.DHCLabItmResult 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCLabItmResult).SaveData()
ClassMethod Test() As %String
{
	s eobj =##class(web.Entity.KB.DHCLabItmResult).%New()
	s eobj.PHLFIRowId=id
}

ClassMethod SaveData(eobj As web.Entity.KB.DHCLabItmResult) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.PHLFIGenDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.PHLFIGenDr=$p(args,",",i)	
			if (eobj.PHLFIRowId="")  //如果RowId未赋值则增加
			{
				s genLength=$d(^DHCLABIF(0,"RESULT",eobj.PHLFIGenDr,eobj.PHLFIParRefDr))
				if (genLength=0)
				{
					s obj=##class(User.DHCLabItmResult).%New(eobj.PHLFIParRefDr)
					d obj.PHLFIParRefDrSetObjectId(eobj.PHLFIParRefDr)
					d obj.PHLFIGenDrSetObjectId(eobj.PHLFIGenDr)
					s obj.PHLFIResult=eobj.PHLFIResult
					s genDesc=$p($g(^DHCPHEGEN(eobj.PHLFIGenDr)),"^",2)
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc)
					{
						Tcommit
						s id = obj.%Id()
						if (ids="")
						{
						    s ids = id
						}
						else
						{
							s ids = ids_","_id
						}
						s result = "{success:'true',id:'"_ids_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmResult","User.DHCLabItmResult","检验项目与结果关联表",id,genDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验项目与结果关联表","web.DHCBL.KB.DHCLabItmResult","SaveData",eobj)
     					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
				
			}
			else                     //如果RowId已赋值则修改
			{
				s genLength=$d(^DHCLABIF(0,"RESULT",eobj.PHLFIGenDr,eobj.PHLFIParRefDr))
				s PHLFIChildsub=$p(eobj.PHLFIRowId,"||",2)
				s TempChildsub=$o(^DHCLABIF(0,"RESULT",eobj.PHLFIGenDr,eobj.PHLFIParRefDr,0))
				if (genLength=0)||((genLength'=0)&(PHLFIChildsub=TempChildsub))
				{
					s obj=##class(User.DHCLabItmResult).%OpenId(eobj.PHLFIRowId)
					s bobj=##class(web.Entity.KB.DHCLabItmResult).%New()
					s bobj.PHLFIRowId=eobj.PHLFIRowId
					s bobj.PHLFIParRefDr=$p(eobj.PHLFIRowId,"||",1)
					if $IsObject(obj.PHLFIGenDr)
					{
						s bobj.PHLFIGenDr = obj.PHLFIGenDr.%Id() 
					}
					s bobj.PHLFIResult = obj.PHLFIResult          
			
					d obj.PHLFIGenDrSetObjectId(eobj.PHLFIGenDr)
					d obj.PHLFIParRefDrSetObjectId(eobj.PHLFIParRefDr)
					s obj.PHLFIResult = eobj.PHLFIResult   
					
					s genDesc=$p($g(^DHCPHEGEN(eobj.PHLFIGenDr)),"^",2)      	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId						//修改时，日志
						d:eobj.PHLFIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmResult","User.DHCLabItmResult","检验项目与结果关联表",eobj.PHLFIRowId,genDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验项目与结果关联表","web.DHCBL.KB.DHCLabItmResult","SaveData",eobj)
     					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}	
		}			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验项目与结果关联表","web.DHCBL.KB.DHCLabItmResult","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除检验项目与结果关联表的内容
/// Table：User.DHCLabItmResult
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCLabItmResult).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCLabItmResult).%New()
	s eobj.PHLFIRowId = id
	s eobj.PHLFIParRefDr=$p(id,"||",1)
	if $IsObject(pobj.PHLFIGenDr)
	{
		s eobj.PHLFIGenDr=pobj.PHLFIGenDr.%Id()
	}
	s eobj.PHLFIResult=pobj.PHLFIResult	
	s genDesc=$p($g(^DHCPHEGEN(eobj.PHLFIGenDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCLabItmResult).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmResult","User.DHCLabItmResult","检验项目与结果关联表",id,genDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验项目与结果关联表","web.DHCBL.KB.DHCLabItmResult","DeleteData",eobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询检验项目与结果关联表的内容
/// Table：User.DHCLabItmResult
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLabItmResult","GetList","","1","","")
Query GetList(rowid As %String, parref As %String, gen As %String, result As %String) As %Query(ROWSPEC = "PHLFIRowId:%String,PHLFIGenDr:%String,PHLFIResult:%String,PHLFIParRefDr:%String,GenRowId:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, gen As %String, result As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCLabItmResult).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s PHLFIRowId=$p(rowid,",",i)
			s LabItemRowId=$p(PHLFIRowId,"||",1)
			s PHLFIChildsub=$p(PHLFIRowId,"||",2)
			//s PHLFIParRefDr=LabItemRowId
			s PHLFIParRefDr=$p($g(^DHCLABIF(LabItemRowId)),"^",2)
			s GenRowId=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",1)
			s PHLFIResult=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",2)
			i GenRowId'="" 
			{
				s PHLFIGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			}
			else 
			{
				s PHLFIGenDr=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s:result'="" result=$ZCONVERT(result,"U") //转换成大写
		s LabItemRowId=parref,PHLFIChildsub=0
		for 
		{
			S PHLFIChildsub=$o(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)) q:PHLFIChildsub=""
			s PHLFIRowId=LabItemRowId_"||"_PHLFIChildsub
			//s PHLFIParRefDr=LabItemRowId
			s PHLFIParRefDr=$p($g(^DHCLABIF(LabItemRowId)),"^",2)
			s GenRowId=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",1)
			s PHLFIResult=$p($g(^DHCLABIF(LabItemRowId,"RESULT",PHLFIChildsub)),"^",2)
			i GenRowId'="" 
			{
				s PHLFIGenDr=$p($g(^DHCPHEGEN(GenRowId)),"^",2)
			}
			else 
			{
				s PHLFIGenDr=""
			}
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLFIResult)
			if (PHLFIChildsub>0)&((GenRowId=gen)||(gen=""))&(($ZCONVERT(PHLFIResult,"U")[result)||(PINYIN[result))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHLFIRowId,PHLFIGenDr,PHLFIResult,PHLFIParRefDr,GenRowId)
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
