Class web.DHCBL.KB.DHCLisGenPro Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2014-11-7
/// Description：查询通用名检验属性字典表内容
/// Table：User.DHCLisGenPro
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLisGenPro","GetList","","","","","")
Query GetNewList(rowid, gen, code) As %Query(ROWSPEC = "LGPRowId,LGPGenDr,PHEGDesc,LGPStCode,LGPCatDr,LGPSysFlag,LGPOTFlag,LGPCatDrF,LGPSysFlagF,LGPOTFlagF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid, gen, code) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCLisGenPro).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LGPRowId=rowid
		s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)  //通用名Dr
		s:LGPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LGPGenDr)),"^",2) //通用名名称 
		s LGPStCode=$p($g(^DHCLISGP(LGPRowId)),"^",2)  //标准码
		//s LGPCatDr=$p($g(^DHCLISGP(LGPRowId)),"^",3)  //分类标识DR
		//s:LGPCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(LGPCatDr)),3) //分类标识名称
		//s:LGPCatDr="" PHICDesc="" //分类标识名称
		s LGPCatDrF=$p($g(^DHCLISGP(LGPRowId)),"^",3)  //分类标识DR
		s:LGPCatDrF'="" LGPCatDr=$LISTGET($G(^User.DHCPHLibCatD(LGPCatDrF)),3) //分类标识名称
		s:LGPCatDrF="" LGPCatDr="" //分类标识名称
		s LGPSysFlag=$p($g(^DHCLISGP(LGPRowId)),"^",4)  //是否系统标识
		s:LGPSysFlag'="N" LGPSysFlag="Y"
		s LGPOTFlag=$p($g(^DHCLISGP(LGPRowId)),"^",5)  //医嘱类型标识
		s LGPSysFlagF="" 
		s LGPOTFlagF=""
		d OutputNewRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:code'="" code=$ZCONVERT(code,"U")
		s LGPRowId=0
		for  
		{	
			s LGPRowId=$o(^DHCLISGP(LGPRowId)) q:LGPRowId="" 
			s strRowId = "{ID:"_LGPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)  //通用名Dr
				s LGPGenDrU=$ZCONVERT(LGPGenDr,"U")
				s:LGPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LGPGenDr)),"^",2) //通用名名称 
				s LGPStCode=$p($g(^DHCLISGP(LGPRowId)),"^",2)  //标准码
				s LGPStCodeU=$ZCONVERT(LGPStCode,"U")
				s LGPCatDrF=$p($g(^DHCLISGP(LGPRowId)),"^",3)  //分类标识DR
				s:LGPCatDrF'="" LGPCatDr=$LISTGET($G(^User.DHCPHLibCatD(LGPCatDrF)),3) //分类标识名称
				s:LGPCatDrF="" LGPCatDr="" //分类标识名称
				s LGPSysFlag=$p($g(^DHCLISGP(LGPRowId)),"^",4)  //是否系统标识
				s:LGPSysFlag'="N" LGPSysFlag="Y"
				s LGPOTFlag=$p($g(^DHCLISGP(LGPRowId)),"^",5)  //医嘱类型标识
				s LGPSysFlagF="" 
				s LGPOTFlagF=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(LGPStCodeU))
				i ((LGPStCodeU[code)||(PINYIN[code))&((LGPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputNewRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(LGPRowId,LGPGenDr,PHEGDesc,LGPStCode,LGPCatDr,LGPSysFlag,LGPOTFlag,LGPCatDrF,LGPSysFlagF,LGPOTFlagF)
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

/// Creator：高姗姗
/// CreatDate: 2014-11-7
/// Description：查询通用名检验属性字典表内容
/// Table：User.DHCLisGenPro
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLisGenPro","GetList","","","","","")
Query GetList(rowid, gen, code) As %Query(ROWSPEC = "LGPRowId,LGPGenDr,PHEGDesc,LGPStCode,LGPCatDr,PHICDesc,LGPSysFlag,LGPOTFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen, code) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCLisGenPro).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LGPRowId=rowid
		s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)  //通用名Dr
		s:LGPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LGPGenDr)),"^",2) //通用名名称 
		s LGPStCode=$p($g(^DHCLISGP(LGPRowId)),"^",2)  //标准码
		s LGPCatDr=$p($g(^DHCLISGP(LGPRowId)),"^",3)  //分类标识DR
		s:LGPCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(LGPCatDr)),3) //分类标识名称
		s:LGPCatDr="" PHICDesc="" //分类标识名称
		s LGPSysFlag=$p($g(^DHCLISGP(LGPRowId)),"^",4)  //是否系统标识
		s:LGPSysFlag'="N" LGPSysFlag="Y"
		s LGPOTFlag=$p($g(^DHCLISGP(LGPRowId)),"^",5)  //医嘱类型标识
		d OutputRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:code'="" code=$ZCONVERT(code,"U")
		s LGPRowId=0
		for  
		{	
			s LGPRowId=$o(^DHCLISGP(LGPRowId)) q:LGPRowId="" 
			s strRowId = "{ID:"_LGPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s LGPGenDr=$p($g(^DHCLISGP(LGPRowId)),"^",1)  //通用名Dr
				s LGPGenDrU=$ZCONVERT(LGPGenDr,"U")
				s:LGPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LGPGenDr)),"^",2) //通用名名称 
				s LGPStCode=$p($g(^DHCLISGP(LGPRowId)),"^",2)  //标准码
				s LGPStCodeU=$ZCONVERT(LGPStCode,"U")
				s LGPCatDr=$p($g(^DHCLISGP(LGPRowId)),"^",3)  //分类标识DR
				s:LGPCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(LGPCatDr)),3) //分类标识名称
				s:LGPCatDr="" PHICDesc="" //分类标识名称
				s LGPSysFlag=$p($g(^DHCLISGP(LGPRowId)),"^",4)  //是否系统标识
				s:LGPSysFlag'="N" LGPSysFlag="Y"
				s LGPOTFlag=$p($g(^DHCLISGP(LGPRowId)),"^",5)  //医嘱类型标识
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(LGPStCodeU))
				i ((LGPStCodeU[code)||(PINYIN[code))&((LGPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LGPRowId,LGPGenDr,PHEGDesc,LGPStCode,LGPCatDr,PHICDesc,LGPSysFlag,LGPOTFlag)
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
/// w ##class(web.DHCBL.KB.DHCLisGenPro).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, gen As %String, stcode As %String) As %String
{
	s:stcode'="" stcode=$ZCONVERT(stcode,"U") //转换成大写
 	s flag=""
	s flagd=""
	s:stcode="" stcode=-100000000000000
	s flagd=$d(^DHCLISGPi(0,"StCode",stcode,gen))
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
		s:stcode'="" idd=$o(^DHCLISGPi(0,"StCode",stcode,gen,0))
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
/// Table：User.DHCLisGenPro
/// Input：web.Entity.KB.DHCLisGenPro 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCLisGenPro) As %String
{
	
 s result = ""
 s flag=..FormValidate(eobj.LGPRowId,eobj.LGPGenDr,eobj.LGPStCode)  //调用重复验证
 if (flag=1)
  {
	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
 else{
	if $IsObject(eobj)
	{
		

			if (eobj.LGPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCLisGenPro).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCLisGenPro).%OpenId(eobj.LGPRowId)
				s bobj = ##class(web.Entity.KB.DHCLisGenPro).%New()
				s bobj.LGPRowId = eobj.LGPRowId
				s:obj.LGPGenDr'="" bobj.LGPGenDr = obj.LGPGenDr.%Id()
				s bobj.LGPStCode=  obj.LGPStCode
				s:obj.LGPCatDr'="" bobj.LGPCatDr = obj.LGPCatDr.%Id()
				s bobj.LGPSysFlag = obj.LGPSysFlag
				s bobj.LGPOTFlag = obj.LGPOTFlag
			}
	
			d:eobj.LGPGenDr'="" obj.LGPGenDrSetObjectId(eobj.LGPGenDr)
			d:eobj.LGPGenDr="" obj.LGPGenDrSetObjectId("")
			s obj.LGPStCode = eobj.LGPStCode
			d:eobj.LGPCatDr'="" obj.LGPCatDrSetObjectId(eobj.LGPCatDr)
			d:eobj.LGPCatDr="" obj.LGPCatDrSetObjectId("")	
			i eobj.LGPSysFlag="Y"
			{
				s obj.LGPSysFlag = "Y"
			}
			else
			{
				s obj.LGPSysFlag = "N"
			}
			s obj.LGPOTFlag = eobj.LGPOTFlag
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.LGPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisGenPro","User.DHCLisGenPro","通用名检验属性",id,eobj.LGPStCode,"A",eobj)
				d:eobj.LGPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisGenPro","User.DHCLisGenPro","通用名检验属性",eobj.LGPRowId,eobj.LGPStCode,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名检验属性","web.DHCBL.KB.DHCLisGenPro","SaveData",eobj)
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
/// Table：User.DHCLisGenPro
/// Other: d ##class(web.DHCBL.KB.DHCLisGenPro).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCLisGenPro).%New()
	s pobj = ##class(User.DHCLisGenPro).%OpenId(id)
	s eobj.LGPRowId = id
	s:pobj.LGPGenDr'="" eobj.LGPGenDr = pobj.LGPGenDr.%Id()
	s eobj.LGPStCode = pobj.LGPStCode
	s:pobj.LGPCatDr'="" eobj.LGPCatDr = pobj.LGPCatDr.%Id()
	s:pobj.LGPSysFlag="Y" eobj.LGPSysFlag="true"	
	s eobj.LGPOTFlag = pobj.LGPOTFlag
	
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-07-24
/// Description：获取修改时的记录
/// Table：User.DHCLisGenPro
/// Other: d ##class(web.DHCBL.KB.DHCLisGenPro).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCLisGenPro).%New()
	s pobj = ##class(User.DHCLisGenPro).%OpenId(id)
	s eobj.LGPRowId = id
	s:pobj.LGPGenDr'="" eobj.LGPGenDr = pobj.LGPGenDr.%Id()
	s eobj.LGPStCode = pobj.LGPStCode
	s:pobj.LGPCatDr'="" eobj.LGPCatDr = pobj.LGPCatDr.%Id()	
	s eobj.LGPSysFlag=pobj.LGPSysFlag
	s:pobj.LGPSysFlag'="N" eobj.LGPSysFlag="Y"	
	s eobj.LGPOTFlag = pobj.LGPOTFlag
	
	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCLisGenPro
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCLisGenPro).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCLisGenPro).%New()
		s pobj = ##class(User.DHCLisGenPro).%OpenId(id)
		s eobj.LGPRowId = id
		s:pobj.LGPGenDr'="" eobj.LGPGenDr = pobj.LGPGenDr.%Id()
		s eobj.LGPStCode = pobj.LGPStCode
		s:pobj.LGPCatDr'="" eobj.LGPCatDr = pobj.LGPCatDr.%Id()	
		s eobj.LGPSysFlag = pobj.LGPSysFlag
		s eobj.LGPOTFlag = pobj.LGPOTFlag
	
		s sc=##class(User.DHCLisGenPro).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisGenPro","User.DHCLisGenPro","通用名检验属性",id,eobj.LGPStCode,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名检验属性","web.DHCBL.KB.DHCLisGenPro","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
