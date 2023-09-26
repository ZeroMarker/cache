Class web.DHCBL.KB.DHCLisSpecCollCare Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2015-1-20
/// Description：查询通用名标本采集注意事项内容
/// Table：User.DHCLisSpecCollCare
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLisSpecCollCare","GetNewList","","85","")
Query GetNewList(rowid, gen, code) As %Query(ROWSPEC = "LSCRowId,LSCGenDr,PHEGDesc,LSCCollCare,LSCCatDr,LSCSysFlag,LSCCatDrF,LSCSysFlagF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid, gen, code) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LSCRowId=rowid
		s LSCGenDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",1)  //通用名Dr
		s:LSCGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LSCGenDr)),"^",2) //通用名名称 
		s LSCCatDrF=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)  //分类标识DR
		s:LSCCatDrF'="" LSCCatDr=$LISTGET($G(^User.DHCPHLibCatD(LSCCatDrF)),3) //分类标识名称
		s:LSCCatDrF="" LSCCatDr="" //分类标识名称
		s LSCCollCare=$p($g(^DHCLSCCARE(LSCRowId)),"^",3)  //采集注意事项
		s LSCSysFlag=$p($g(^DHCLSCCARE(LSCRowId)),"^",4)  //是否系统标识
		s:LSCSysFlag="" LSCSysFlag="Y"
		s LSCSysFlagF=""
		d OutputNewRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:code'="" code=$ZCONVERT(code,"U")
		s LSCRowId=0
		for  
		{	
			s LSCRowId=$o(^DHCLSCCARE(LSCRowId)) q:LSCRowId="" 
			s strRowId = "{ID:"_LSCRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s LSCGenDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",1)  //通用名Dr
				s LSCGenDrU=$ZCONVERT(LSCGenDr,"U")
				s:LSCGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LSCGenDr)),"^",2) //通用名名称 
				s LSCCatDrF=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)  //分类标识DR
				s:LSCCatDrF'="" LSCCatDr=$LISTGET($G(^User.DHCPHLibCatD(LSCCatDrF)),3) //分类标识名称
				s:LSCCatDrF="" LSCCatDr="" //分类标识名称
				s LSCCollCare=$p($g(^DHCLSCCARE(LSCRowId)),"^",3)  //采集注意事项
				s LSCCollCareU=$ZCONVERT(LSCCollCare,"U")
				s LSCSysFlag=$p($g(^DHCLSCCARE(LSCRowId)),"^",4)  //是否系统标识
				s:LSCSysFlag="" LSCSysFlag="Y"
				s LSCSysFlagF=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(LSCCollCareU))
				i ((LSCCollCareU[code)||(PINYIN[code))&((LSCGenDrU=gen)||(gen=""))   //条件
				{
					d OutputNewRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(LSCRowId,LSCGenDr,PHEGDesc,LSCCollCare,LSCCatDr,LSCSysFlag,LSCCatDrF,LSCSysFlagF)
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

/// 获取采集注意事项
/// Other: w ##class(web.DHCBL.KB.DHCLisSpecCollCare).GetCare("51","73")
ClassMethod GetCare(GenDr As %String, SpecDr As %String) As %String
{
	s LSCCollCare=""
	s LSCRowId=0
	for
	{
		s LSCRowId = $o(^DHCLSCCARE(0,"Cat",GenDr,SpecDr,LSCRowId)) q:LSCRowId=""
		s LSCCollCare = $p($g(^DHCLSCCARE(LSCRowId)),"^",3)
	}
	 q LSCCollCare
}

/// Creator：高姗姗
/// CreatDate: 2015-1-20
/// Description：查询通用名标本采集注意事项内容
/// Table：User.DHCLisSpecCollCare
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLisSpecCollCare","GetList","","","","","")
Query GetList(rowid, gen, code) As %Query(ROWSPEC = "LSCRowId,LSCGenDr,PHEGDesc,LSCCollCare,LSCCatDr,PHICDesc,LSCSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen, code) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s LSCRowId=rowid
		s LSCGenDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",1)  //通用名Dr
		s:LSCGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LSCGenDr)),"^",2) //通用名名称 
		s LSCCatDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)  //分类标识DR
		s:LSCCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(LSCCatDr)),3) //分类标识名称
		s:LSCCatDr="" PHICDesc="" //分类标识名称
		s LSCCollCare=$p($g(^DHCLSCCARE(LSCRowId)),"^",3)  //采集注意事项
		s LSCSysFlag=$p($g(^DHCLSCCARE(LSCRowId)),"^",4)  //是否系统标识
		s:LSCSysFlag="" LSCSysFlag="Y"
		d OutputRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:code'="" code=$ZCONVERT(code,"U")
		s LSCRowId=0
		for  
		{	
			s LSCRowId=$o(^DHCLSCCARE(LSCRowId)) q:LSCRowId="" 
			s strRowId = "{ID:"_LSCRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s LSCGenDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",1)  //通用名Dr
				s LSCGenDrU=$ZCONVERT(LSCGenDr,"U")
				s:LSCGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(LSCGenDr)),"^",2) //通用名名称 
				s LSCCatDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)  //分类标识DR
				s:LSCCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(LSCCatDr)),3) //分类标识名称
				s:LSCCatDr="" PHICDesc="" //分类标识名称
				s LSCCollCare=$p($g(^DHCLSCCARE(LSCRowId)),"^",3)  //采集注意事项
				s LSCCollCareU=$ZCONVERT(LSCCollCare,"U")
				s LSCSysFlag=$p($g(^DHCLSCCARE(LSCRowId)),"^",4)  //是否系统标识
				s:LSCSysFlag="" LSCSysFlag="Y"
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(LSCCollCareU))
				i ((LSCCollCareU[code)||(PINYIN[code))&((LSCGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LSCRowId,LSCGenDr,PHEGDesc,LSCCollCare,LSCCatDr,PHICDesc,LSCSysFlag)
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
/// CreatDate: 2015-1-20
/// Description：保存修改内容
/// Table：User.DHCLisSpecCollCare
/// Input：web.Entity.KB.DHCLisSpecCollCare 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCLisSpecCollCare) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		

			if (eobj.LSCRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCLisSpecCollCare).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCLisSpecCollCare).%OpenId(eobj.LSCRowId)
				s bobj = ##class(web.Entity.KB.DHCLisSpecCollCare).%New()
				s bobj.LSCRowId = eobj.LSCRowId
				s:obj.LSCGenDr'="" bobj.LSCGenDr = obj.LSCGenDr.%Id()
				s bobj.LSCCollCare=  obj.LSCCollCare
				s:obj.LSCCatDr'="" bobj.LSCCatDr = obj.LSCCatDr.%Id()
				s bobj.LSCSysFlag = obj.LSCSysFlag
			}
	
			d:eobj.LSCGenDr'="" obj.LSCGenDrSetObjectId(eobj.LSCGenDr)
			d:eobj.LSCGenDr="" obj.LSCGenDrSetObjectId("")
			s obj.LSCCollCare = eobj.LSCCollCare
			d:eobj.LSCCatDr'="" obj.LSCCatDrSetObjectId(eobj.LSCCatDr)
			d:eobj.LSCCatDr="" obj.LSCCatDrSetObjectId("")	
			i eobj.LSCSysFlag="Y"
			{
				s obj.LSCSysFlag = "Y"
			}
			else
			{
				s obj.LSCSysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.LSCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisSpecCollCare","User.DHCLisSpecCollCare","通用名标本采集注意事项",id,eobj.LSCCollCare,"A",eobj)
				d:eobj.LSCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisSpecCollCare","User.DHCLisSpecCollCare","通用名标本采集注意事项",eobj.LSCRowId,eobj.LSCCollCare,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名标本采集注意事项","web.DHCBL.KB.DHCLisSpecCollCare","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：高姗姗
/// CreatDate: 2015-1-20
/// Description：获取修改时的记录
/// Table：User.DHCLisSpecCollCare
/// Other: d ##class(web.DHCBL.KB.DHCLisSpecCollCare).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCLisSpecCollCare).%New()
	s pobj = ##class(User.DHCLisSpecCollCare).%OpenId(id)
	s eobj.LSCRowId = id
	s:pobj.LSCGenDr'="" eobj.LSCGenDr = pobj.LSCGenDr.%Id()
	s eobj.LSCCollCare = pobj.LSCCollCare
	s:pobj.LSCCatDr'="" eobj.LSCCatDr = pobj.LSCCatDr.%Id()
	s:pobj.LSCSysFlag="Y" eobj.LSCSysFlag="true"	
	
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-7-26
/// Description：获取修改时的记录
/// Table：User.DHCLisSpecCollCare
/// Other: d ##class(web.DHCBL.KB.DHCLisSpecCollCare).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCLisSpecCollCare).%New()
	s pobj = ##class(User.DHCLisSpecCollCare).%OpenId(id)
	s eobj.LSCRowId = id
	s:pobj.LSCGenDr'="" eobj.LSCGenDr = pobj.LSCGenDr.%Id()
	s eobj.LSCCollCare = pobj.LSCCollCare
	s:pobj.LSCCatDr'="" eobj.LSCCatDr = pobj.LSCCatDr.%Id()
	s:pobj.LSCSysFlag="" eobj.LSCSysFlag="Y"
	s eobj.LSCSysFlag=pobj.LSCSysFlag	
	
	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-1-20
/// Description:根据id删除
/// Table:User.DHCLisSpecCollCare
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCLisSpecCollCare).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCLisSpecCollCare).%New()
		s pobj = ##class(User.DHCLisSpecCollCare).%OpenId(id)
		s eobj.LSCRowId = id
		s:pobj.LSCGenDr'="" eobj.LSCGenDr = pobj.LSCGenDr.%Id()
		s eobj.LSCCollCare = pobj.LSCCollCare
		s:pobj.LSCCatDr'="" eobj.LSCCatDr = pobj.LSCCatDr.%Id()	
		s eobj.LSCSysFlag = pobj.LSCSysFlag
	
		s sc=##class(User.DHCLisSpecCollCare).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LisSpecCollCare","User.DHCLisSpecCollCare","通用名标本采集注意事项",id,eobj.LSCCollCare,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名标本采集注意事项","web.DHCBL.KB.DHCLisSpecCollCare","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
