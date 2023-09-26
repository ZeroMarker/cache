Class web.DHCBL.KB.DHCPHExtGenAlias Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-7
/// Description：查询通用名别名字典表内容
/// Table：User.DHCPHExtGenAlias
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGenAlias","GetList","","","","","")
Query GetList(rowid, gen, text, lib) As %Query(ROWSPEC = "PHEGAlRowId,PHEGAlGenDr,PHEGDesc,PHEGAlText,PHEGAlLibDr,PHLIDesc,PHEGAlSysFlag,PHEGAlSysFlagF")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen, text, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGenAlias).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGAlRowId=rowid
		s PHEGAlGenDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",1)  //通用名Dr
		s:PHEGAlGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGAlGenDr)),"^",2) //通用名名称 
		s PHEGAlText=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)  //别名
		s PHEGAlLibDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",3)  //知识库标识DR
		s PHEGAlSysFlagF=""
		s:PHEGAlLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGAlLibDr)),"^",2) //知识库标识名称
		s PHEGAlSysFlag=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",4)  //是否系统标识
		s:PHEGAlSysFlag'="N" PHEGAlSysFlag="Y"
		d OutputRow
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:text'="" text=$ZCONVERT(text,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGAlRowId=0
		for  
		{	
			s PHEGAlRowId=$o(^DHCPHEGAL(PHEGAlRowId)) q:PHEGAlRowId="" 
			s strRowId = "{ID:"_PHEGAlRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHEGAlGenDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",1)  //通用名Dr
				s PHEGAlGenDrU=$ZCONVERT(PHEGAlGenDr,"U")
				s:PHEGAlGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGAlGenDr)),"^",2) //通用名名称 
				s PHEGAlText=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)  //别名
				s PHEGAlTextU=$ZCONVERT(PHEGAlText,"U")
				s PHEGAlLibDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",3)  //知识库标识DR
				s PHEGAlLibDrU=$ZCONVERT(PHEGAlLibDr,"U")
				s:PHEGAlLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGAlLibDr)),"^",2) //知识库标识名称
				s PHEGAlSysFlag=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",4)  //是否系统标识
				s:PHEGAlSysFlag'="N" PHEGAlSysFlag="Y"
				s PHEGAlSysFlagF=""
				
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGAlTextU))
				i ((PHEGAlTextU[text)||(PINYIN[text))&((PHEGAlGenDrU=gen)||(gen=""))&((PHEGAlLibDrU=lib)||(lib=""))  //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHEGAlRowId,PHEGAlGenDr,PHEGDesc,PHEGAlText,PHEGAlLibDr,PHLIDesc,PHEGAlSysFlag,PHEGAlSysFlagF)
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
/// w ##class(web.DHCBL.KB.DHCPHExtGenAlias).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, gen As %String, text As %String) As %String
{
	s flag=""
	s flagd=""
	s:text'="" text=$ZCONVERT(text,"U") //转换成大写
	s flagd=$d(^DHCPHEGALi(0,"GenText",gen,text))
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
		s idd=$o(^DHCPHEGALi(0,"GenText",gen,text,0))
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
/// Table：User.DHCPHExtGenAlias
/// Input：web.Entity.KB.DHCPHExtGenAlias 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtGenAlias) As %String
{
	
 s result = ""
 s flag=..FormValidate(eobj.PHEGAlRowId,eobj.PHEGAlGenDr,eobj.PHEGAlText)  //调用重复验证
 if (flag=1)
  {
	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
 else{
	if $IsObject(eobj)
	{
		

			if (eobj.PHEGAlRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHExtGenAlias).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHExtGenAlias).%OpenId(eobj.PHEGAlRowId)
				s bobj = ##class(web.Entity.KB.DHCPHExtGenAlias).%New()
				s bobj.PHEGAlRowId = eobj.PHEGAlRowId
				s:obj.PHEGAlGenDr'="" bobj.PHEGAlGenDr = obj.PHEGAlGenDr.%Id()
				s bobj.PHEGAlText=  obj.PHEGAlText
				s:obj.PHEGAlLibDr'="" bobj.PHEGAlLibDr = obj.PHEGAlLibDr.%Id()
				s bobj.PHEGAlSysFlag = obj.PHEGAlSysFlag
			}
	
			d:eobj.PHEGAlGenDr'="" obj.PHEGAlGenDrSetObjectId(eobj.PHEGAlGenDr)
			d:eobj.PHEGAlGenDr="" obj.PHEGAlGenDrSetObjectId("")
			s obj.PHEGAlText = eobj.PHEGAlText
			s:eobj.PHEGAlGenDr'="" PHEGLibDr=$p($g(^DHCPHEGEN(eobj.PHEGAlGenDr)),"^",7) //知识库标识DR
			d:PHEGLibDr'="" obj.PHEGAlLibDrSetObjectId(PHEGLibDr)
			d:PHEGLibDr="" obj.PHEGAlLibDrSetObjectId("")	
			i eobj.PHEGAlSysFlag="Y"
			{
				s obj.PHEGAlSysFlag = "Y"
			}
			else
			{
				s obj.PHEGAlSysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHEGAlRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenAlias","User.DHCPHExtGenAlias","通用名别名字典",id,eobj.PHEGAlText,"A",eobj)
				d:eobj.PHEGAlRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenAlias","User.DHCPHExtGenAlias","通用名别名字典",eobj.PHEGAlRowId,eobj.PHEGAlText,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名别名字典","web.DHCBL.KB.DHCPHExtGenAlias","SaveData",eobj)
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
/// Table：User.DHCPHExtGenAlias
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGenAlias).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHExtGenAlias).%New()
	s pobj = ##class(User.DHCPHExtGenAlias).%OpenId(id)
	s eobj.PHEGAlRowId = id
	s:pobj.PHEGAlGenDr'="" eobj.PHEGAlGenDr = pobj.PHEGAlGenDr.%Id()
	s eobj.PHEGAlText = pobj.PHEGAlText
	s:pobj.PHEGAlLibDr'="" eobj.PHEGAlLibDr = pobj.PHEGAlLibDr.%Id()
	s:pobj.PHEGAlSysFlag="Y" eobj.PHEGAlSysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：高姗姗
/// CreatDate: 2018-07-19
/// Description：获取修改时的记录
/// Table：User.DHCPHExtGenAlias
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGenAlias).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHExtGenAlias).%New()
	s pobj = ##class(User.DHCPHExtGenAlias).%OpenId(id)
	s eobj.PHEGAlRowId = id
	s:pobj.PHEGAlGenDr'="" eobj.PHEGAlGenDr = pobj.PHEGAlGenDr.%Id()
	s eobj.PHEGAlText = pobj.PHEGAlText
	s:pobj.PHEGAlLibDr'="" eobj.PHEGAlLibDr = pobj.PHEGAlLibDr.%Id()
	s:pobj.PHEGAlSysFlag'="N" eobj.PHEGAlSysFlag="Y"
	//s eobj.PHEGAlSysFlag=pobj.PHEGAlSysFlag	

	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtGenAlias
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtGenAlias).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHExtGenAlias).%New()
		s pobj = ##class(User.DHCPHExtGenAlias).%OpenId(id)
		s eobj.PHEGAlRowId = id
		s:pobj.PHEGAlGenDr'="" eobj.PHEGAlGenDr = pobj.PHEGAlGenDr.%Id()
		s eobj.PHEGAlText = pobj.PHEGAlText
		s:pobj.PHEGAlLibDr'="" eobj.PHEGAlLibDr = pobj.PHEGAlLibDr.%Id()	
		s eobj.PHEGAlSysFlag = pobj.PHEGAlSysFlag
	
		s sc=##class(User.DHCPHExtGenAlias).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenAlias","User.DHCPHExtGenAlias","通用名别名字典",id,eobj.PHEGAlText,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名别名字典","web.DHCBL.KB.DHCPHExtGenAlias","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
