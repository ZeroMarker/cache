Import SQLUser

/// 名称:手术和过程 - 6 切口类型	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-5
Class web.DHCBL.CT.ORCBladeType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 切口类型
/// Table:User.ORCBladeType
/// Input:rowid,code,desc
/// Return:BLDTPRowId,BLDTPCode,BLDTPDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCBladeType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BLDTPRowId:%String,BLDTPCode:%String,BLDTPDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s BLDTPRowId=rowid
		s BLDTPCode=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",1)
		s BLDTPDesc=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",2)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_BladeType",BLDTPRowId)
     	s BDPInternalCode =$p($g(resultStr),"^",1)       
     	s BDPInternalDesc = $p($g(resultStr),"^",2)  
     	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCBladeType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s BLDTPRowId=0
		for
		{
			s BLDTPRowId=$o(^ORC("BLDTP",BLDTPRowId)) q:BLDTPRowId=""
			s strRowId="{ID:"_BLDTPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s BLDTPCode=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",1)
				s BLDTPDesc=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_BladeType",BLDTPRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_BladeType",BLDTPRowId,BLDTPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(BLDTPCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BLDTPRowId,BLDTPCode,BLDTPDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.ORCBladeType
/// Input:code,desc
/// Return:BLDTPRowId,BLDTPCode,BLDTPDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCBladeType","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BLDTPRowId:%String,BLDTPCode:%String,BLDTPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s BLDTPRowId=rowid
		s BLDTPCode=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",1)
		s BLDTPDesc=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCBladeType).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s BLDTPRowId=0
		for
		{
			s BLDTPRowId=$o(^ORC("BLDTP",BLDTPRowId)) q:BLDTPRowId=""
			s strRowId="{ID:"_BLDTPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s BLDTPCode=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",1)
				s BLDTPDesc=$p($g(^ORC("BLDTP",BLDTPRowId)),"^",2)
				s BLDTPCode1=$ZCONVERT(BLDTPCode,"U")
				s BLDTPDesc1=$ZCONVERT(BLDTPDesc,"U")
				
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_BladeType",BLDTPRowId,BLDTPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(BLDTPCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BLDTPRowId,BLDTPCode,BLDTPDesc)
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

/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.ORCBladeType
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCBladeType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("BLDTP",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("BLDTP",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0))
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
		s:code'="" idc=$o(^ORC("BLDTP",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("BLDTP",0,"Desc",desc,0))
	
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
		
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:双击修改时从后台取数据
/// Table:User.ORCBladeType
/// Input:id
/// Return:Json格式的字符串str={list:[BLDTPCode,BLDTPDesc,BLDTPRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCBladeType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCBladeType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCBladeType).%New()
	s eobj.BLDTPRowId = id
	s eobj.BLDTPCode = pobj.BLDTPCode
	s eobj.BLDTPDesc = pobj.BLDTPDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:增加/修改 切口类型
/// Table:User.ORCBladeType
/// Input:web.Entity.CT.ORCBladeType
/// Return:成功返回success:'true'和新增或修改的数据的BLDTPRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCBladeType) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		s flag=..FormValidate(eobj.BLDTPRowId,eobj.BLDTPCode,eobj.BLDTPDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.BLDTPRowId="")       
		{
			s obj=##class(User.ORCBladeType).%New()
		}
		else                           
		{
			s obj=##class(User.ORCBladeType).%OpenId(eobj.BLDTPRowId)
			s bobj=##class(web.Entity.CT.ORCBladeType).%New()
			s bobj.BLDTPRowId = eobj.BLDTPRowId
			s bobj.BLDTPCode = obj.BLDTPCode
			s bobj.BLDTPDesc = obj.BLDTPDesc
		}

		s obj.BLDTPCode = eobj.BLDTPCode
		s obj.BLDTPDesc = eobj.BLDTPDesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.BLDTPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_BladeType","User.ORCBladeType","切口类型",id,eobj.BLDTPDesc,"A",eobj)
			d:eobj.BLDTPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_BladeType","User.ORCBladeType","切口类型",id,eobj.BLDTPDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("切口类型","web.DHCBL.CT.ORCBladeType","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈莹
/// CreatDate:2012-9-5
/// Description:根据id删除 切口类型
/// Table:User.ORCBladeType
/// Input:id(ORCBladeType的BLDTPRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCBladeType).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	new (id,%session)
	s result=""
	s re=##class(web.DHCBL.CT.ORCBladeType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCBladeType).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCBladeType).%New()
		s eobj.BLDTPRowId = id
		s eobj.BLDTPCode = pobj.BLDTPCode
		s eobj.BLDTPDesc = pobj.BLDTPDesc
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCBladeType).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_BladeType","User.ORCBladeType","切口类型",id,eobj.BLDTPDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("切口类型","web.DHCBL.CT.ORCBladeType","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2016-8-10
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""

	s OPERRowId=0,flag=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:(OPERRowId="")||(flag=1)
		s OPERBladeDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",3)   //手术切口类型
		i OPERBladeDr=id
		{
			s flag=1
			s myInfo=myInfo_"<手术/过程扩展信息表>"
		}
	}
	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

}
