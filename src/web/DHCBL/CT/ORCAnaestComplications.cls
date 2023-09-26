Import SQLUser

/// 名称:手术和过程 - 11 麻醉剂并发症	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-7
Class web.DHCBL.CT.ORCAnaestComplications Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 麻醉剂并发症
/// Table:User.ORCAnaestComplications
/// Input:rowid,code,desc
/// Return:ANACOMRowId,ANACOMCode,ANACOMDesc,ANACOMARCOSDR
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestComplications","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANACOMRowId:%String,ANACOMCode:%String,ANACOMDesc:%String,ANACOMARCOSDR:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ANACOMRowId=rowid
		s ANACOMCode=$p($g(^ORC("COMP",ANACOMRowId)),"^",1)
		s ANACOMDesc=$p($g(^ORC("COMP",ANACOMRowId)),"^",2)
		s ARCOSRowId=$p($g(^ORC("COMP",ANACOMRowId)),"^",3)
		i ARCOSRowId'="" {
			s ANACOMARCOSDR=$p($g(^ARCOS(ARCOSRowId)),"^",2)
		}
		else {
			s ANACOMARCOSDR=""
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_Anaest_Complications",ANACOMRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestComplications).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANACOMRowId=0
		for
		{
			s ANACOMRowId=$o(^ORC("COMP",ANACOMRowId)) q:ANACOMRowId=""
			s strRowId="{ID:"_ANACOMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ANACOMCode=$p($g(^ORC("COMP",ANACOMRowId)),"^",1)
				s ANACOMDesc=$p($g(^ORC("COMP",ANACOMRowId)),"^",2)
				s ARCOSRowId=$p($g(^ORC("COMP",ANACOMRowId)),"^",3)
				i ARCOSRowId'="" {
					s ANACOMARCOSDR=$p($g(^ARCOS(ARCOSRowId)),"^",2)
				}
				else {
					s ANACOMARCOSDR=""
				}
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_Anaest_Complications",ANACOMRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
    			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_Anaest_Complications",ANACOMRowId,ANACOMDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANACOMCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ANACOMRowId,ANACOMCode,ANACOMDesc,ANACOMARCOSDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCAnaestComplications
/// Input:code,desc
/// Return:ANACOMRowId,ANACOMCode,ANACOMDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestComplications","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANACOMRowId:%String,ANACOMCode:%String,ANACOMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ANACOMRowId=rowid
		s ANACOMCode=$p($g(^ORC("COMP",ANACOMRowId)),"^",1)
		s ANACOMDesc=$p($g(^ORC("COMP",ANACOMRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestComplications).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANACOMRowId=0
		for
		{
			s ANACOMRowId=$o(^ORC("COMP",ANACOMRowId)) q:ANACOMRowId=""
			s strRowId="{ID:"_ANACOMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ANACOMCode=$p($g(^ORC("COMP",ANACOMRowId)),"^",1)
				s ANACOMDesc=$p($g(^ORC("COMP",ANACOMRowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_Anaest_Complications",ANACOMRowId,ANACOMDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANACOMCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ANACOMRowId,ANACOMCode,ANACOMDesc)
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

/// (医嘱套)ANMET_ARCOS_DR->ARC_OrdSets
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestMethod","GetARCOSDR","","")
/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.ORCAnaestComplications
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// d ##class(web.DHCBL.CT.ORCAnaestComplications).FormValidate("","01","ANACOMCode")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("COMP",0,code))   //这个索引比较怪异- -
	s:desc'="" flagd=$d(^ORC("COMP",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("COMP",0,code,0))
		s:desc'="" idd=$o(^ORC("COMP",0,"Desc",desc,0))
		
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:双击修改时从后台取数据
/// Table:User.ORCAnaestComplications
/// Input:id
/// Return:Json格式的字符串str={list:[ANACOMCode,ANACOMDesc,ANACOMARCOSDR,ANACOMRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestComplications).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCAnaestComplications).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCAnaestComplications).%New()
	s eobj.ANACOMRowId = id
	s eobj.ANACOMCode = pobj.ANACOMCode
	s eobj.ANACOMDesc = pobj.ANACOMDesc
	if $IsObject(pobj.ANACOMARCOSDR){
		s eobj.ANACOMARCOSDR = pobj.ANACOMARCOSDR.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:增加/修改 麻醉剂并发症
/// Table:User.ORCAnaestComplications
/// Input:web.Entity.CT.ORCAnaestComplications 实体类
/// Return:成功返回success:'true'和新增或修改的数据的ANACOMRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCAnaestComplications) As %String
{
    new (eobj,%session)
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		s flag=..FormValidate(eobj.ANACOMRowId,eobj.ANACOMCode,eobj.ANACOMDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ANACOMRowId="")       
		{
			s obj=##class(User.ORCAnaestComplications).%New()
		}
		else                           
		{
			s obj=##class(User.ORCAnaestComplications).%OpenId(eobj.ANACOMRowId)
			s bobj=##class(web.Entity.CT.ORCAnaestComplications).%New()
			s bobj.ANACOMRowId=eobj.ANACOMRowId
			s bobj.ANACOMCode = obj.ANACOMCode
			s bobj.ANACOMDesc = obj.ANACOMDesc
			if $IsObject(obj.ANACOMARCOSDR){
					s bobj.ANACOMARCOSDR = obj.ANACOMARCOSDR.%Id() 
				}
		}	

		s obj.ANACOMCode = eobj.ANACOMCode
		s obj.ANACOMDesc = eobj.ANACOMDesc
		d obj.ANACOMARCOSDRSetObjectId(eobj.ANACOMARCOSDR)
		//s obj.ANACOMARCOSDR=##class(User.ARCOrdSets).%OpenId(eobj.ANACOMARCOSDR)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ANACOMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Anaest_Complications","User.ORCAnaestComplications","麻醉剂并发症",id,eobj.ANACOMDesc,"A",eobj)
			d:eobj.ANACOMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Anaest_Complications","User.ORCAnaestComplications","麻醉剂并发症",id,eobj.ANACOMDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉剂并发症","web.DHCBL.CT.ORCAnaestComplications","SaveEntity",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉剂并发症","web.DHCBL.CT.ORCAnaestComplications","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:根据id删除 麻醉剂并发症
/// Table:User.ORCAnaestComplications
/// Input:id(ORCAnaestComplications的ANACOMRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestComplications).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.ORCAnaestComplications).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCAnaestComplications).%New()
	s eobj.ANACOMRowId = id
	s eobj.ANACOMCode = pobj.ANACOMCode
	s eobj.ANACOMDesc = pobj.ANACOMDesc
	if $IsObject(pobj.ANACOMARCOSDR){
		s eobj.ANACOMARCOSDR = pobj.ANACOMARCOSDR.%Id() 
		}
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.ORCAnaestComplications).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Anaest_Complications","User.ORCAnaestComplications","麻醉剂并发症",id,eobj.ANACOMDesc,"D",eobj)
	}
	else{
		Trollback
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉剂并发症","web.DHCBL.CT.ORCAnaestComplications","DeleteData",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
