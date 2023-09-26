Class web.DHCBL.KB.DHCPHDrugGenPro Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2014-11-7
/// Description：查询通用名药品属性字典表内容
/// Table：User.DHCPHDrugGenPro
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugGenPro","GetNewList","","","","","")
Query GetNewList(rowid, gen, atc, pro, cat) As %Query(ROWSPEC = "PHGPRRowId,PHGPRGenDr,PHEGDesc,PHGPRAtc,PHGPROTC,PHGPRCatDr,PHGPRSysFlag,PHNRowId,PHNDesc,PHGPRCatDrF,PHGPRSysFlagF,PHGPROTCF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid, gen, atc, pro, cat) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHDrugGenPro).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHGPRRowId=rowid
		s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
		s:PHGPRGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHGPRGenDr)),"^",2) //通用名名称 
		s PHGPRAtc=$p($g(^DHCPHDGP(PHGPRRowId)),"^",2)  //ATC编码
		s PHGPROTC=$p($g(^DHCPHDGP(PHGPRRowId)),"^",3)  //是否处方
		s PHGPRCatDrF=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
		s:PHGPRCatDrF'="" PHGPRCatDr=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDrF)),3) //分类标识名称
		s:PHGPRCatDrF="" PHGPRCatDr="" //分类标识名称
		s PHGPRSysFlag=$p($g(^DHCPHDGP(PHGPRRowId)),"^",5)  //是否系统标识
		s:PHGPRSysFlag'="N" PHGPRSysFlag="Y"
		s PHGPRSysFlagF=""
		s PHGPROTCF=""
		s PHNRowId=""
		s PHNDesc=""
		s RowId=0
		for  
		{	
			s RowId=$o(^DHCPHPNA(0,"Gen",PHGPRGenDr,RowId)) q:RowId="" //药品商品名字典
			s PHNDesc=$p($g(^DHCPHPNA(RowId)),"^",2)
			s PHNRowId=RowId
		}
		d OutputNewRow
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:atc'="" atc=$ZCONVERT(atc,"U")
		s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s strRowId = "{ID:"_PHGPRRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
				s PHGPRGenDrU=$ZCONVERT(PHGPRGenDr,"U")
				s:PHGPRGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHGPRGenDr)),"^",2) //通用名名称 
				s PHGPRAtc=$p($g(^DHCPHDGP(PHGPRRowId)),"^",2)  //ATC编码
				s PHGPRAtcU=$ZCONVERT(PHGPRAtc,"U")
				s PHGPROTC=$p($g(^DHCPHDGP(PHGPRRowId)),"^",3)  //是否处方
				s PHGPRCatDrF=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
				s:PHGPRCatDrF'="" PHGPRCatDr=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDrF)),3) //分类标识名称
				s:PHGPRCatDrF="" PHGPRCatDr="" //分类标识名称
				s PHGPRSysFlag=$p($g(^DHCPHDGP(PHGPRRowId)),"^",5)  //是否系统标识
				s:PHGPRSysFlag'="N" PHGPRSysFlag="Y"
				s PHGPRSysFlagF=""
				s PHGPROTCF=""
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHGPRAtcU))
				s PHNRowId=""
				s PHNDesc=""
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHPNA(0,"Gen",PHGPRGenDr,RowId)) q:RowId="" //药品商品名字典
					s PHNDesc=$p($g(^DHCPHPNA(RowId)),"^",2) 
					s PHNRowId=RowId
				}
				i ((PHGPRAtcU[atc)||(PINYIN[atc))&((PHGPRGenDrU=gen)||(gen=""))&((PHNRowId=pro)||(pro=""))&((PHGPRCatDrF=cat)||(cat=""))   //条件
				{
					d OutputNewRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(PHGPRRowId,PHGPRGenDr,PHEGDesc,PHGPRAtc,PHGPROTC,PHGPRCatDr,PHGPRSysFlag,PHNRowId,PHNDesc,PHGPRCatDrF,PHGPRSysFlagF,PHGPROTCF)
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
/// Description：查询通用名药品属性字典表内容
/// Table：User.DHCPHDrugGenPro
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrugGenPro","GetList","","","")
Query GetList(rowid, gen, atc, pro, cat) As %Query(ROWSPEC = "PHGPRRowId,PHGPRGenDr,PHEGDesc,PHGPRAtc,PHGPROTC,PHGPRCatDr,PHICDesc,PHGPRSysFlag,PHNRowId,PHNDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen, atc, pro, cat) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHDrugGenPro).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHGPRRowId=rowid
		s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
		s:PHGPRGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHGPRGenDr)),"^",2) //通用名名称 
		s PHGPRAtc=$p($g(^DHCPHDGP(PHGPRRowId)),"^",2)  //ATC编码
		s PHGPROTC=$p($g(^DHCPHDGP(PHGPRRowId)),"^",3)  //是否处方
		s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
		s:PHGPRCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDr)),3) //分类标识名称
		s:PHGPRCatDr="" PHICDesc="" //分类标识名称
		s PHGPRSysFlag=$p($g(^DHCPHDGP(PHGPRRowId)),"^",5)  //是否系统标识
		s:PHGPRSysFlag'="N" PHGPRSysFlag="Y"
		s PHNRowId=""
		s PHNDesc=""
		s RowId=0
		for  
		{	
			s RowId=$o(^DHCPHPNA(0,"Gen",PHGPRGenDr,RowId)) q:RowId="" //药品商品名字典
			s PHNDesc=$p($g(^DHCPHPNA(RowId)),"^",2)
			s PHNRowId=RowId
		}
		d OutputRow
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:atc'="" atc=$ZCONVERT(atc,"U")
		s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s strRowId = "{ID:"_PHGPRRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
				s PHGPRGenDrU=$ZCONVERT(PHGPRGenDr,"U")
				s:PHGPRGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHGPRGenDr)),"^",2) //通用名名称 
				s PHGPRAtc=$p($g(^DHCPHDGP(PHGPRRowId)),"^",2)  //ATC编码
				s PHGPRAtcU=$ZCONVERT(PHGPRAtc,"U")
				s PHGPROTC=$p($g(^DHCPHDGP(PHGPRRowId)),"^",3)  //是否处方
				s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
				s:PHGPRCatDr'="" PHICDesc=$LISTGET($G(^User.DHCPHLibCatD(PHGPRCatDr)),3) //分类标识名称
				s:PHGPRCatDr="" PHICDesc="" //分类标识名称
				s PHGPRSysFlag=$p($g(^DHCPHDGP(PHGPRRowId)),"^",5)  //是否系统标识
				s:PHGPRSysFlag'="N" PHGPRSysFlag="Y"
				
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHGPRAtcU))
				s PHNRowId=""
				s PHNDesc=""
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHPNA(0,"Gen",PHGPRGenDr,RowId)) q:RowId="" //药品商品名字典
					s PHNDesc=$p($g(^DHCPHPNA(RowId)),"^",2) 
					s PHNRowId=RowId
				}
				i ((PHGPRAtcU[atc)||(PINYIN[atc))&((PHGPRGenDrU=gen)||(gen=""))&((PHNRowId=pro)||(pro=""))&((PHGPRCatDr=cat)||(cat=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHGPRRowId,PHGPRGenDr,PHEGDesc,PHGPRAtc,PHGPROTC,PHGPRCatDr,PHICDesc,PHGPRSysFlag,PHNRowId,PHNDesc)
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
/// w ##class(web.DHCBL.KB.DHCPHDrugGenPro).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, gen As %String, cat As %String) As %String
{
	s flag=""
		s flagd=""
		s flagd=$d(^DHCPHDGPi(0,"Cat",cat,gen))
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
			s idd=$o(^DHCPHDGPi(0,"Cat",cat,gen,0))
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
/// Table：User.DHCPHDrugGenPro
/// Input：web.Entity.KB.DHCPHDrugGenPro 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDrugGenPro) As %String
{
	
	s result = ""
	s flag=..FormValidate(eobj.PHGPRRowId,eobj.PHGPRGenDr,eobj.PHGPRCatDr)  //调用重复验证
    if (flag=1)
   {
	  s result = "{success:'false',errorinfo:'该记录已经存在！'}"
   }
   else{
	 if $IsObject(eobj)
	  {
		 Ts

			if (eobj.PHGPRRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHDrugGenPro).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHDrugGenPro).%OpenId(eobj.PHGPRRowId)
				s bobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
				s bobj.PHGPRRowId = eobj.PHGPRRowId
				s:obj.PHGPRGenDr'="" bobj.PHGPRGenDr = obj.PHGPRGenDr.%Id()
				s bobj.PHGPRAtc=  obj.PHGPRAtc
				s bobj.PHGPROTC=  obj.PHGPROTC
				s:obj.PHGPRCatDr'="" bobj.PHGPRCatDr = obj.PHGPRCatDr.%Id()
				s bobj.PHGPRSysFlag = obj.PHGPRSysFlag
			}
	
			d:eobj.PHGPRGenDr'="" obj.PHGPRGenDrSetObjectId(eobj.PHGPRGenDr)
			d:eobj.PHGPRGenDr="" obj.PHGPRGenDrSetObjectId("")
			s obj.PHGPRAtc = eobj.PHGPRAtc
			d:eobj.PHGPRCatDr'="" obj.PHGPRCatDrSetObjectId(eobj.PHGPRCatDr)
			d:eobj.PHGPRCatDr="" obj.PHGPRCatDrSetObjectId("")	
			i eobj.PHGPROTC="Y"
			{
				s obj.PHGPROTC = "Y"
			}
			else
			{
				s obj.PHGPROTC = "N"
			}
			i eobj.PHGPRSysFlag="Y"
			{
				s obj.PHGPRSysFlag = "Y"
			}
			else
			{
				s obj.PHGPRSysFlag = "N"
			}

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHGPRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDrugGenPro","User.DHCPHDrugGenPro","通用名药品属性",id,eobj.PHGPRAtc,"A",eobj)
				d:eobj.PHGPRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDrugGenPro","User.DHCPHDrugGenPro","通用名药品属性",eobj.PHGPRRowId,eobj.PHGPRAtc,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名药品属性","web.DHCBL.KB.DHCPHDrugGenPro","SaveData",eobj)
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
/// Table：User.DHCPHDrugGenPro
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugGenPro).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
	s pobj = ##class(User.DHCPHDrugGenPro).%OpenId(id)
	s eobj.PHGPRRowId = id
	s:pobj.PHGPRGenDr'="" eobj.PHGPRGenDr = pobj.PHGPRGenDr.%Id()
	s eobj.PHGPRAtc = pobj.PHGPRAtc
	s:pobj.PHGPROTC="Y" eobj.PHGPROTC="true"
	s:pobj.PHGPRCatDr'="" eobj.PHGPRCatDr = pobj.PHGPRCatDr.%Id()
	s:pobj.PHGPRSysFlag="Y" eobj.PHGPRSysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-07-23
/// Description：获取修改时的记录
/// Table：User.DHCPHDrugGenPro
/// Other: d ##class(web.DHCBL.KB.DHCPHDrugGenPro).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
	s pobj = ##class(User.DHCPHDrugGenPro).%OpenId(id)
	s eobj.PHGPRRowId = id
	s:pobj.PHGPRGenDr'="" eobj.PHGPRGenDr = pobj.PHGPRGenDr.%Id()
	s eobj.PHGPRAtc = pobj.PHGPRAtc
	s:pobj.PHGPROTC'="N" eobj.PHGPROTC="Y"
	s eobj.PHGPROTC=pobj.PHGPROTC
	s:pobj.PHGPRCatDr'="" eobj.PHGPRCatDr = pobj.PHGPRCatDr.%Id()
	s:pobj.PHGPRSysFlag'="N" eobj.PHGPRSysFlag="Y"
	s eobj.PHGPRSysFlag=pobj.PHGPRSysFlag

	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHDrugGenPro
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDrugGenPro).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
		s pobj = ##class(User.DHCPHDrugGenPro).%OpenId(id)
		s eobj.PHGPRRowId = id
		s:pobj.PHGPRGenDr'="" eobj.PHGPRGenDr = pobj.PHGPRGenDr.%Id()
		s eobj.PHGPRAtc = pobj.PHGPRAtc
		s eobj.PHGPROTC = pobj.PHGPROTC
		s:pobj.PHGPRCatDr'="" eobj.PHGPRCatDr = pobj.PHGPRCatDr.%Id()	
		s eobj.PHGPRSysFlag = pobj.PHGPRSysFlag
	
		s sc=##class(User.DHCPHDrugGenPro).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDrugGenPro","User.DHCPHDrugGenPro","通用名药品属性",id,eobj.PHGPRAtc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用名药品属性","web.DHCBL.KB.DHCPHDrugGenPro","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}

	q result
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:获取批量设定药品列表
/// w ##class(web.DHCBL.KB.DHCPHDrugGenPro).GetTreeJson("menuTreeRoot","10","69",0,20,"k","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000

	s myJsonStr=""
	
	s rowid=0
	s count=0
	s end=start+limit
	s desc=""
	//获取已选JSON
	s AuStr=..GetBatchJson(ObjectType,ObjectReference)
	s rowid=0
	for  
	{	
		s rowid=$o(^DHCPHEGEN(rowid)) q:rowid="" 

		s code=$p($g(^DHCPHEGEN(rowid)),"^",1)  //代码
		s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)  //描述
		s LibDr=$p($g(^DHCPHEGEN(rowid)),"^",7)  //知识库标识DR
		
		s PHNDesc=""
		s Id=0
		for  
		{	
			s Id=$o(^DHCPHPNA(0,"Gen",rowid,Id)) q:Id="" //药品商品名字典
			s PHNDesc=$p($g(^DHCPHPNA(Id)),"^",2) 
		}
		
		s:query'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(desc)
		s:query'="" PINYINPro= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHNDesc)
		//过滤已选、未选
		s AuStr2="{ID:"_rowid_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
		
		if (($ZCONVERT(desc,"U")[$ZCONVERT(query,"U"))||(PINYIN[$ZCONVERT(query,"U"))||($ZCONVERT(PHNDesc,"U")[$ZCONVERT(query,"U"))||(PINYINPro[$ZCONVERT(query,"U")))&(LibDr=ObjectType){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0) {
				s AuStr2="{ID:"_rowid_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				if (PHNDesc=""){
					s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_""","
				}else{
					s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_"("_PHNDesc_")"","
				}
				
				if (+myEnable) {
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else {
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	q myJsonStr
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:获取批量设定药品已选列表
/// Other:w ##class(web.DHCBL.KB.DHCPHDrugGenPro).GetBatchJson("","16")
ClassMethod GetBatchJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s str=""
	s PHGPRRowId=0
	for  
	{	
		s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
		s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
		s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
		if (PHGPRCatDr=ObjectReference){
			if (str=""){
				s str="{ID:"_PHGPRGenDr_"}"
			}
			else{
				s str=str_",{ID:"_PHGPRGenDr_"}"
			}
		}
	}
	s str="{IDS:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:批量设定药品保存方法
/// Other:w ##class(web.DHCBL.KB.DHCPHDrugGenPro).SaveBatchData("10","3","{IDS:[{ID:3},{ID:4},{ID:5}]}")
ClassMethod SaveBatchData(ObjectType As %String, ObjectReference As %String, Data As %String) As %String
{
	s flag=""
	;"{IDS:[{ID:1},{ID:2},{ID:3}]}"
	;{ID:1},{ID:2},{ID:3}
	s Data = $e(Data,7,*-2)
	if (Data=""){
		s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
			s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
			if (PHGPRCatDr=ObjectReference){
				s id = $o(^DHCPHDGPi(0,"Gen",PHGPRGenDr,0))
				s return = ..DeleteData(id)	
				if (return["true"){
					s flag=0	
				}
			}
		}
	
	}
	else{
		s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
			s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
			if (PHGPRCatDr=ObjectReference){
				s PHGPRGen="{ID:"_PHGPRGenDr_"}"
				if (Data[PHGPRGen){
				}
				else{
					s id = $o(^DHCPHDGPi(0,"Gen",PHGPRGenDr,0))
					s return = ..DeleteData(id)	
					if (return["true"){
						s flag=0	
					}
				}
			}
		}
	
		s len=$Length(Data,",")
		for i=1:1:len
		{
			s GenData=$p(Data,",",i)
			
			s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
			s eobj.PHGPRGenDr=$e(GenData,5,*-1)
			s eobj.PHGPRCatDr=ObjectReference
			s eobj.PHGPROTC = "Y"
			s eobj.PHGPRSysFlag = "Y"
			s return= ..SaveData(eobj)
			if (return["true"){
				s flag=0	
			}
		}
	}
	if (flag=0){
		s result = "{msg:"_flag_"}" //保存成功
	}else{
		s result = "{msg:"_flag_"}"
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-8-14
/// Description:获取批量设定药品列表
/// w ##class(web.DHCBL.KB.DHCPHDrugGenPro).NewGetTreeJson("","10","6")
ClassMethod NewGetTreeJson(ParentID As %String, DrugId As %String, CatID As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000

	s myJsonStr=""
	
	s rowid=0
	s count=0
	w "["
	s desc=""
	//获取已选JSON
	s AuStr=..GetBatchJson(DrugId,CatID)
	s rowid=0
	for  
	{	
		s rowid=$o(^DHCPHEGEN(rowid)) q:rowid="" 
		s code=$p($g(^DHCPHEGEN(rowid)),"^",1)  //代码
		s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)  //描述
		s desc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(desc)
		s LibDr=$p($g(^DHCPHEGEN(rowid)),"^",7)  //知识库标识DR
		
		s PHNDesc=""
		s Id=0
		for  
		{	
			s Id=$o(^DHCPHPNA(0,"Gen",rowid,Id)) q:Id="" //药品商品名字典
			s PHNDesc=$p($g(^DHCPHPNA(Id)),"^",2) 
		}
		
		
		if (LibDr=DrugId){
			s count=count+1	
			s AuStr2="{ID:"_rowid_"}"
			if (AuStr[AuStr2) s myEnable=1
			else  s myEnable=0
			
			if count>1 w ","
			w "{"
			if (PHNDesc=""){
				 w """id"":"""_""_rowid_""",""text"":"""_desc_""","
			}else{
				s PHNDesc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHNDesc)
				w """id"":"""_""_rowid_""",""text"":"""_desc_"("_PHNDesc_")"","
			}
			
			if (+myEnable) {
				w """checked"":true,"
			}else {
				w """checked"":false,"
			}
			//列表型 没有子节点
			w """state"":""open"""
			w "}"
		}
	}
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2018-8-14
/// Description:批量设定药品保存方法
/// Other:w ##class(web.DHCBL.KB.DHCPHDrugGenPro).NewSaveBatchData("10","3","3")
ClassMethod NewSaveBatchData(DrugId As %String, CatID As %String, Data As %String, checked) As %String
{
	s result="",flag=""
	if (Data="") { q:"请选择药品名！" }
	if ((checked="true")||(checked="1"))
	{
		/*s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
			s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
			if (PHGPRCatDr=CatID)
			{
				if (Data=PHGPRGenDr)
				{
				}
				else
				{
					s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
					s eobj.PHGPRGenDr=Data
					s eobj.PHGPRCatDr=CatID
					s eobj.PHGPROTC = "Y"
					s eobj.PHGPRSysFlag = "Y"
					s return= ..SaveData(eobj)
					if (return["true")
					{
						s flag=0	
					}
				}
			}
		}	
		
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}*/
		s eobj = ##class(web.Entity.KB.DHCPHDrugGenPro).%New()
		s eobj.PHGPRGenDr=Data
		s eobj.PHGPRCatDr=CatID
		s eobj.PHGPROTC = "Y"
		s eobj.PHGPRSysFlag = "Y"
		s return= ..SaveData(eobj)
		if (return["true")
		{
			s flag=0	
		}
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}
	}
	else
	{
		s PHGPRRowId=0
		for  
		{	
			s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:PHGPRRowId="" 
			s PHGPRGenDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",1)  //通用名Dr
			s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)  //分类标识DR
			if (PHGPRCatDr=CatID)
			{
				if (Data=PHGPRGenDr)
				{
					s id = $o(^DHCPHDGPi(0,"Gen",PHGPRGenDr,0))
					s return = ..DeleteData(id)	
					if (return["true")
					{
						s flag=0	
					}
				}
			}	
	
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}			
	  }
	}
	q result
}

}
