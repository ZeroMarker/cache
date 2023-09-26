Class web.DHCBL.KB.DHCDisHistoryKey Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-10
/// Description：查询既往史关键字表内容
/// Table：User.DHCDisHistoryKey
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCDisHistoryKey","GetList","","","","","")
Query GetList(rowid, alf, key) As %Query(ROWSPEC = "DHKRowId,DHKDHDr,DHIDesc,DHKKey,DHKSysFlag,DHKSysFlagF")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, alf, key) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCDisHistoryKey).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s DHKRowId=rowid
		s DHKDHDr=$p($g(^DHCDISHISK(DHKRowId)),"^",1)  //既往史Dr
		s:DHKDHDr'="" DHIDesc=$p($g(^DHCDISHISF(DHKDHDr)),"^",2) //既往史名称 
		s DHKKey=$p($g(^DHCDISHISK(DHKRowId)),"^",2)  //关键字
		s DHKSysFlag=$p($g(^DHCDISHISK(DHKRowId)),"^",3)  //是否系统标识
		s:DHKSysFlag="" DHKSysFlag="Y"
		s DHKSysFlagF=""
		
		d OutputRow
	}
	else
	{
		s:alf'="" alf=$ZCONVERT(alf,"U")
		s:key'="" key=$ZCONVERT(key,"U")
		s DHKRowId=0
		for  
		{	
			s DHKRowId=$o(^DHCDISHISK(DHKRowId)) q:DHKRowId="" 
			s strRowId = "{ID:"_DHKRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s DHKDHDr=$p($g(^DHCDISHISK(DHKRowId)),"^",1)  //既往史Dr
				s DHKDHDrU=$ZCONVERT(DHKDHDr,"U")
				s:DHKDHDr'="" DHIDesc=$p($g(^DHCDISHISF(DHKDHDr)),"^",2) //既往史名称 
				s DHKKey=$p($g(^DHCDISHISK(DHKRowId)),"^",2)  //关键字
				s DHKKeyU=$ZCONVERT(DHKKey,"U")
				s DHKSysFlag=$p($g(^DHCDISHISK(DHKRowId)),"^",3)  //是否系统标识
				s:DHKSysFlag="" DHKSysFlag="Y"
				s DHKSysFlagF=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DHKKeyU))
				i ((DHKKeyU[key)||(PINYIN[key))&((DHKDHDrU=alf)||(alf=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DHKRowId,DHKDHDr,DHIDesc,DHKKey,DHKSysFlag,DHKSysFlagF)
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
/// CreateDate:2015-2-8 
/// w ##class(web.DHCBL.KB.DHCDisHistoryKey).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, dhk As %String, key As %String) As %String
{
	s flag=""
	s flagd=""
	s:key'="" key=$ZCONVERT(key,"U") //转换成大写
	s flagd=$d(^DHCDISHISKi(0,"Key",dhk,key))
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
		s idd=$o(^DHCDISHISKi(0,"Key",dhk,key,0))
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
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCDisHistoryKey
/// Input：web.Entity.KB.DHCDisHistoryKey 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCDisHistoryKey) As %String
{
	
	s result = ""
 s flag=..FormValidate(eobj.DHKRowId,eobj.DHKDHDr,eobj.DHKKey)  //调用重复验证
 if (flag=1)
  {
	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
 else{
	if $IsObject(eobj)
	{
		

			if (eobj.DHKRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCDisHistoryKey).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCDisHistoryKey).%OpenId(eobj.DHKRowId)
				s bobj = ##class(web.Entity.KB.DHCDisHistoryKey).%New()
				s bobj.DHKRowId = eobj.DHKRowId
				s:obj.DHKDHDr'="" bobj.DHKDHDr = obj.DHKDHDr.%Id()
				s bobj.DHKKey=  obj.DHKKey
				s bobj.DHKSysFlag = obj.DHKSysFlag
			}
	
			d:eobj.DHKDHDr'="" obj.DHKDHDrSetObjectId(eobj.DHKDHDr)
			d:eobj.DHKDHDr="" obj.DHKDHDrSetObjectId("")
			s obj.DHKKey = eobj.DHKKey
			i eobj.DHKSysFlag="Y"
			{
				s obj.DHKSysFlag = "Y"
			}
			else
			{
				s obj.DHKSysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.DHKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryKey","User.DHCDisHistoryKey","既往史关键字",id,eobj.DHKKey,"A",eobj)
				d:eobj.DHKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryKey","User.DHCDisHistoryKey","既往史关键字",eobj.DHKRowId,eobj.DHKKey,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("既往史关键字","web.DHCBL.KB.DHCDisHistoryKey","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
 }
	q result
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCDisHistoryKey
/// Other: d ##class(web.DHCBL.KB.DHCDisHistoryKey).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCDisHistoryKey).%New()
	s pobj = ##class(User.DHCDisHistoryKey).%OpenId(id)
	s eobj.DHKRowId = id
	s:pobj.DHKDHDr'="" eobj.DHKDHDr = pobj.DHKDHDr.%Id()
	s eobj.DHKKey = pobj.DHKKey
	s:pobj.DHKSysFlag="Y" eobj.DHKSysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCDisHistoryKey
/// Other: d ##class(web.DHCBL.KB.DHCDisHistoryKey).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCDisHistoryKey).%New()
	s pobj = ##class(User.DHCDisHistoryKey).%OpenId(id)
	s eobj.DHKRowId = id
	s:pobj.DHKDHDr'="" eobj.DHKDHDr = pobj.DHKDHDr.%Id()
	s eobj.DHKKey = pobj.DHKKey
	s eobj.DHKSysFlag=pobj.DHKSysFlag	
	s:pobj.DHKSysFlag="" eobj.DHKSysFlag="Y"
	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCDisHistoryKey
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCDisHistoryKey).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCDisHistoryKey).%New()
		s pobj = ##class(User.DHCDisHistoryKey).%OpenId(id)
		s eobj.DHKRowId = id
		s:pobj.DHKDHDr'="" eobj.DHKDHDr = pobj.DHKDHDr.%Id()
		s eobj.DHKKey = pobj.DHKKey
		s eobj.DHKSysFlag = pobj.DHKSysFlag
	
		s sc=##class(User.DHCDisHistoryKey).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryKey","User.DHCDisHistoryKey","既往史关键字",id,eobj.DHKKey,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("既往史关键字","web.DHCBL.KB.DHCDisHistoryKey","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
