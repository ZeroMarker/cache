/// 名称:病人管理-患者来源
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-4-3
Class web.DHCBL.CT.PACPatientSource Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:查询 患者来源
/// Table:User.PACPatientSource
/// Input:rowid,code,desc
/// Return: PSRowId,PSCode,PSDesc,PSDateFrom,PSDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPatientSource","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PSRowId,PSCode,PSDesc,PSDateFrom,PSDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="")	//rowid不为空
	{
		s PSRowId=rowid
		s PSCode=$p($g(^PAC("Source",PSRowId)),"^",1)	//代码
		s PSDesc=$p($g(^PAC("Source",PSRowId)),"^",2)		//描述
		s PSDateFrom=$p($g(^PAC("Source",PSRowId)),"^",3)	//开始日期
		s PSDateTo=$p($g(^PAC("Source",PSRowId)),"^",4)		//结束日期
		s:PSDateFrom'="" PSDateFrom=$zd(PSDateFrom,1) //转换日期格式
		s:PSDateTo'="" PSDateTo=$zd(PSDateTo,1) //转换日期格式
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		s PSRowId=0
		for
		{
			s PSRowId=$o(^PAC("Source",PSRowId)) q:PSRowId=""
			if (AuStr[PSRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PSCode=$p($g(^PAC("Source",PSRowId)),"^",1)	//代码
				s PSDesc=$p($g(^PAC("Source",PSRowId)),"^",2)		//描述
				s PSDateFrom=$p($g(^PAC("Source",PSRowId)),"^",3)	//开始日期
				s PSDateTo=$p($g(^PAC("Source",PSRowId)),"^",4)		//结束日期
				s:PSDateFrom'="" PSDateFrom=$zd(PSDateFrom,1) //转换日期格式
				s:PSDateTo'="" PSDateTo=$zd(PSDateTo,1) //转换日期格式
				if (desc'="")	//过滤描述
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PatientSource",PSRowId,PSDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(PSCode,"U")[code) &(AliasFlag=1)	//过滤代码
				{
					d OutputRow
				}
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PSRowId,PSCode,PSDesc,PSDateFrom,PSDateTo)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:为combobox查询取数据
/// Table:User.PACPatientSource
/// Input:code,desc
/// Return: PSRowId,PSCode,PSDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACPatientSource","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PSRowId:%String,PSCode:%String,PSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="")		//rowid不为空
	{
		s PSRowId=rowid
		s PSCode=$p($g(^PAC("Source",PSRowId)),"^",1)	//代码
		s PSDesc=$p($g(^PAC("Source",PSRowId)),"^",2)		//描述
		d OutputRowCmb
	}
	else	//循环查找
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		
		s PSRowId=0
		for
		{
			s PSRowId=$o(^PAC("Source",PSRowId)) q:PSRowId=""
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PSCode=$p($g(^PAC("Source",PSRowId)),"^",1)	//代码
				s PSDesc=$p($g(^PAC("Source",PSRowId)),"^",2)		//描述
				s PSDateFrom=$p($g(^PAC("Source",PSRowId)),"^",3)	//开始日期
				s PSDateTo=$p($g(^PAC("Source",PSRowId)),"^",4)		//结束日期
				continue:(PSDateTo'="")&&(PSDateTo<+$h)
				if (desc'="")		//过滤描述
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_PatientSource",PSRowId,PSDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(PSCode,"U")[code) &(AliasFlag=1)	//过滤代码
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PSRowId,PSCode,PSDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:数据重复验证方法,js调用
/// Table:User.PACPatientSource
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACPatientSource).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PAC("Source",0,"Code",code))
	s:desc'="" flagd=$d(^PAC("Source",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))	//代码/描述重复
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
		s idc=""
		s idd=""
		s:code'="" idc=$o(^PAC("Source",0,"Code",code,0))
		s:desc'="" idd=$o(^PAC("Source",0,"Desc",desc,0))
		if (desc="")	//查询代码为空
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:双击修改时,从后台取数据
/// Table:User.PACPatientSource
/// Input:id
/// Return:Json格式的字符串str 如 {list:[{"PSCode":"1","PSDateFrom":"04/21/2020","PSDateTo":"","PSDesc":"报纸","PS  RowId":"2"}]}
/// Other:w ##class(web.DHCBL.CT.PACPatientSource).OpenData("1","")
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	s str=""
	s pobj = ##class(User.PACPatientSource).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACPatientSource).%New()
	s eobj.PSRowId = id
	s eobj.PSCode = pobj.PSCode		//代码
	s eobj.PSDesc = pobj.PSDesc		//描述
	s:pobj.PSDateFrom'="" eobj.PSDateFrom =$zd(pobj.PSDateFrom,1)	//开始日期
	s:pobj.PSDateTo'="" eobj.PSDateTo = $zd(pobj.PSDateTo,1)		//结束日期
	//s eobj.PSDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PSDateFrom)
	//s eobj.PSDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PSDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	if (RetFlag="")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:增加/修改 患者来源
/// Table:User.PACPatientSource	患者来源
/// Input:web.Entity.CT.PACPatientSource
/// Return:成功返回success:'true'和新增或修改的数据的PSRowId;失败返回success:'false'和失败原因
/// Other:d ##class(web.DHCBL.CT.PACPatientSource).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACPatientSource) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断、开始日期是否小于结束日期
		s:eobj.PSDateFrom'="" eobj.PSDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PSDateFrom)
		s:eobj.PSDateTo'="" eobj.PSDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PSDateTo)
		s:eobj.PSDateFrom="" eobj.PSDateFrom=+$h
		
		if (eobj.PSRowId="")       //新增
		{
			s obj=##class(User.PACPatientSource).%New()
		}
		else                     //修改
		{
			s obj=##class(User.PACPatientSource).%OpenId(eobj.PSRowId)
			s bobj = ##class(web.Entity.CT.PACPatientSource).%New()
			s bobj.PSRowId = eobj.PSRowId	
			s bobj.PSCode = obj.PSCode		//代码
			s bobj.PSDesc = obj.PSDesc		//描述
			s bobj.PSDateFrom=obj.PSDateFrom	//开始日期
			s bobj.PSDateTo=obj.PSDateTo		//结束日期
		}

		s obj.PSCode = eobj.PSCode	//代码
		s obj.PSDesc = eobj.PSDesc	//描述
		s obj.PSDateFrom=eobj.PSDateFrom	//开始日期
		s obj.PSDateTo=eobj.PSDateTo	//结束日期
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc)		//保存成功
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PatientSource","User.PACPatientSource","患者来源",id,eobj.PSDesc,"A",eobj)
			d:eobj.PSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PatientSource","User.PACPatientSource","患者来源",id,eobj.PSDesc,"U",eobj,bobj)
		}
		else	//保存失败
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者来源","web.DHCBL.CT.PACPatientSource","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
					
	}
	else	//对象不存在
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-4-3
/// Description:根据id删除 患者来源
/// Table:User.PACPatientSource
/// Input:id
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACPatientSource).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.PACPatientSource).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACPatientSource).%New()
	s eobj.PSRowId = id
	s eobj.PSCode = pobj.PSCode	//代码
	s eobj.PSDesc = pobj.PSDesc		//描述
	s eobj.PSDateFrom = pobj.PSDateFrom 	//开始日期
	s eobj.PSDateTo = pobj.PSDateTo 	//结束日期
	
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PACPatientSource).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_PatientSource","User.PACPatientSource","患者来源",id,eobj.PSDesc,"D",eobj)
	}
	else
	{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者来源","web.DHCBL.CT.PACPatientSource","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
