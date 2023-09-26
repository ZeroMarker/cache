Class web.DHCBL.KB.DHCAllergyKey Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-10
/// Description：查询过敏史关键字表内容
/// Table：User.DHCAllergyKey
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCAllergyKey","GetList","","","","","")
Query GetList(rowid, alf, key) As %Query(ROWSPEC = "ALKRowId,ALKALDr,ALFDesc,ALKKey,ALKSysFlag,ALKSysFlagF")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, alf, key) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCAllergyKey).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ALKRowId=rowid
		s ALKALDr=$p($g(^DHCALLGYKEY(ALKRowId)),"^",1)  //过敏史Dr
		s:ALKALDr'="" ALFDesc=$p($g(^DHCALLERGY(ALKALDr)),"^",2) //过敏史名称 
		s ALKKey=$p($g(^DHCALLGYKEY(ALKRowId)),"^",2)  //关键字
		s ALKSysFlag=$p($g(^DHCALLGYKEY(ALKRowId)),"^",3)  //是否系统标识
		s:ALKSysFlag="" ALKSysFlag="Y"
		s ALKSysFlagF=""
		
		d OutputRow
	}
	else
	{
		s:alf'="" alf=$ZCONVERT(alf,"U")
		s:key'="" key=$ZCONVERT(key,"U")
		s ALKRowId=0
		for  
		{	
			s ALKRowId=$o(^DHCALLGYKEY(ALKRowId)) q:ALKRowId="" 
			s strRowId = "{ID:"_ALKRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s ALKALDr=$p($g(^DHCALLGYKEY(ALKRowId)),"^",1)  //过敏史Dr
				s ALKALDrU=$ZCONVERT(ALKALDr,"U")
				s:ALKALDr'="" ALFDesc=$p($g(^DHCALLERGY(ALKALDr)),"^",2) //过敏史名称 
				s ALKKey=$p($g(^DHCALLGYKEY(ALKRowId)),"^",2)  //关键字
				s ALKKeyU=$ZCONVERT(ALKKey,"U")
				s ALKSysFlag=$p($g(^DHCALLGYKEY(ALKRowId)),"^",3)  //是否系统标识
				s:ALKSysFlag="" ALKSysFlag="Y"
				s ALKSysFlagF=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ALKKeyU))
				i ((ALKKeyU[key)||(PINYIN[key))&((ALKALDrU=alf)||(alf=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ALKRowId,ALKALDr,ALFDesc,ALKKey,ALKSysFlag,ALKSysFlagF)
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
/// w ##class(web.DHCBL.KB.DHCAllergyKey).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, alk As %String, key As %String) As %String
{
	s flag=""
	s flagd=""
	s:key'="" key=$ZCONVERT(key,"U") //转换成大写
	s flagd=$d(^DHCALLGYKEYi(0,"Key",alk,key))
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
		s idd=$o(^DHCALLGYKEYi(0,"Key",alk,key,0))
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
/// Table：User.DHCAllergyKey
/// Input：web.Entity.KB.DHCAllergyKey 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCAllergyKey) As %String
{
	
	s result = ""
 s flag=..FormValidate(eobj.ALKRowId,eobj.ALKALDr,eobj.ALKKey)  //调用重复验证
 if (flag=1)
  {
	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
 else{
	if $IsObject(eobj)
	{
		

			if (eobj.ALKRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCAllergyKey).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCAllergyKey).%OpenId(eobj.ALKRowId)
				s bobj = ##class(web.Entity.KB.DHCAllergyKey).%New()
				s bobj.ALKRowId = eobj.ALKRowId
				s:obj.ALKALDr'="" bobj.ALKALDr = obj.ALKALDr.%Id()
				s bobj.ALKKey=  obj.ALKKey
				s bobj.ALKSysFlag = obj.ALKSysFlag
			}
	
			d:eobj.ALKALDr'="" obj.ALKALDrSetObjectId(eobj.ALKALDr)
			d:eobj.ALKALDr="" obj.ALKALDrSetObjectId("")
			s obj.ALKKey = eobj.ALKKey
			i eobj.ALKSysFlag="Y"
			{
				s obj.ALKSysFlag = "Y"
			}
			else
			{
				s obj.ALKSysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.ALKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyKey","User.DHCAllergyKey","过敏史关键字",id,eobj.ALKKey,"A",eobj)
				d:eobj.ALKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyKey","User.DHCAllergyKey","过敏史关键字",eobj.ALKRowId,eobj.ALKKey,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏史关键字","web.DHCBL.KB.DHCAllergyKey","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
/// Table：User.DHCAllergyKey
/// Other: d ##class(web.DHCBL.KB.DHCAllergyKey).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCAllergyKey).%New()
	s pobj = ##class(User.DHCAllergyKey).%OpenId(id)
	s eobj.ALKRowId = id
	s:pobj.ALKALDr'="" eobj.ALKALDr = pobj.ALKALDr.%Id()
	s eobj.ALKKey = pobj.ALKKey
	s:pobj.ALKSysFlag="Y" eobj.ALKSysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCAllergyKey
/// Other: d ##class(web.DHCBL.KB.DHCAllergyKey).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCAllergyKey).%New()
	s pobj = ##class(User.DHCAllergyKey).%OpenId(id)
	s eobj.ALKRowId = id
	s:pobj.ALKALDr'="" eobj.ALKALDr = pobj.ALKALDr.%Id()
	s eobj.ALKKey = pobj.ALKKey
	s eobj.ALKSysFlag=pobj.ALKSysFlag
	s:pobj.ALKSysFlag="" eobj.ALKSysFlag="Y"	

	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCAllergyKey
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCAllergyKey).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCAllergyKey).%New()
		s pobj = ##class(User.DHCAllergyKey).%OpenId(id)
		s eobj.ALKRowId = id
		s:pobj.ALKALDr'="" eobj.ALKALDr = pobj.ALKALDr.%Id()
		s eobj.ALKKey = pobj.ALKKey
		s eobj.ALKSysFlag = pobj.ALKSysFlag
	
		s sc=##class(User.DHCAllergyKey).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyKey","User.DHCAllergyKey","过敏史关键字",id,eobj.ALKKey,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏史关键字","web.DHCBL.KB.DHCAllergyKey","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

}
