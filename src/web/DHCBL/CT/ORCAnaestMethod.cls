Import SQLUser

/// 名称:手术和过程 - 10 麻醉方法	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-7
Class web.DHCBL.CT.ORCAnaestMethod Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 麻醉方法
/// Table:User.ORCAnaestMethod
/// Input:rowid,code,desc
/// Return:ANMETRowId,ANMETCode,ANMETDesc,ANMETTypeDR,ANMETARCOSDR,ANMETDateFrom,ANMETDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestMethod","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANMETRowId:%String,ANMETCode:%String,ANMETDesc:%String,ANMETTypeDR:%String,ANMETARCOSDR:%String,ANMETDateFrom:%String,ANMETDateTo:%String ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ANMETRowId=rowid
		s ANMETCode=$p($g(^ORC("ANMET",ANMETRowId)),"^",1)
		s ANMETDesc=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
		s ANTYPERowId=$p($g(^ORC("ANMET",ANMETRowId)),"^",3)
		i ANTYPERowId'="" {
			s ANMETTypeDR=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
		}
		else {
			s ANMETTypeDR=""
		}
		s ARCOSRowId=$p($g(^ORC("ANMET",ANMETRowId)),"^",4)
		i ARCOSRowId'="" {
			s ANMETARCOSDR=$p($g(^ARCOS(ARCOSRowId)),"^",2)
		}
		else {
			s ANMETARCOSDR=""
		}
		s ANMETDateFrom=$p($g(^ORC("ANMET",ANMETRowId)),"^",5)
		s ANMETDateTo=$p($g(^ORC("ANMET",ANMETRowId)),"^",6)
		s:ANMETDateFrom'="" ANMETDateFrom=$zd(ANMETDateFrom,1)
		s:ANMETDateTo'="" ANMETDateTo=$zd(ANMETDateTo,1)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestMethod",ANMETRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestMethod).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANTYPERowIdAuStr=##class(web.DHCBL.Authorize.ORCAnaestType).DHCGetDataByDefaultSession()
		s ANTYPERowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ANTYPERowIdAuStr="")||(ANTYPERowIdAuStr["limited:0") s ANTYPERowIdAuFlag=1
		s ANMETRowId=0
		s ANMETRowId=0
		for
		{
			s ANMETRowId=$o(^ORC("ANMET",ANMETRowId)) q:ANMETRowId=""
			s ANTYPERowId=$p($g(^ORC("ANMET",ANMETRowId)),"^",3)
			s ANTYPERowIdstrRowId="{ID:"_ANTYPERowId_"}"
			s strRowId="{ID:"_ANMETRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ANTYPERowIdAuStr[ANTYPERowIdstrRowId)||(ANTYPERowIdAuFlag=1)) ;用来筛选授权数据
			{
				s ANMETCode=$p($g(^ORC("ANMET",ANMETRowId)),"^",1)
				s ANMETDesc=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
				s ANMETCode1=$ZCONVERT(ANMETCode,"U")
				s ANMETDesc1=$ZCONVERT(ANMETDesc,"U")
				
				i ANTYPERowId'="" {
					s ANMETTypeDR=$p($g(^ORC("ANTYPE",ANTYPERowId)),"^",2)
				}
				else {
					s ANMETTypeDR=""
				}
				s ARCOSRowId=$p($g(^ORC("ANMET",ANMETRowId)),"^",4)
				i ARCOSRowId'="" {
					s ANMETARCOSDR=$p($g(^ARCOS(ARCOSRowId)),"^",2)
				}
				else {
					s ANMETARCOSDR=""
				}
				s ANMETDateFrom=$p($g(^ORC("ANMET",ANMETRowId)),"^",5)
				s ANMETDateTo=$p($g(^ORC("ANMET",ANMETRowId)),"^",6)
				s:ANMETDateFrom'="" ANMETDateFrom=$zd(ANMETDateFrom,1)
				s:ANMETDateTo'="" ANMETDateTo=$zd(ANMETDateTo,1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestMethod",ANMETRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestMethod",ANMETRowId,ANMETDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANMETCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ANMETRowId,ANMETCode,ANMETDesc,ANMETTypeDR,ANMETARCOSDR,ANMETDateFrom,ANMETDateTo ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCAnaestMethod
/// Input:code,desc
/// Return:ANMETRowId,ANMETCode,ANMETDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestMethod","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANMETRowId:%String,ANMETCode:%String,ANMETDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ANMETRowId=rowid
		s ANMETCode=$p($g(^ORC("ANMET",ANMETRowId)),"^",1)
		s ANMETDesc=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestMethod).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANTYPERowIdAuStr=##class(web.DHCBL.Authorize.ORCAnaestType).DHCGetDataByDefaultSession()
		s ANTYPERowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ANTYPERowIdAuStr="")||(ANTYPERowIdAuStr["limited:0") s ANTYPERowIdAuFlag=1
		s ANMETRowId=0
		s ANMETRowId=0
		for
		{
			s ANMETRowId=$o(^ORC("ANMET",ANMETRowId)) q:ANMETRowId=""
			s ANTYPERowId=$p($g(^ORC("ANMET",ANMETRowId)),"^",3)
			s ANTYPERowIdstrRowId="{ID:"_ANTYPERowId_"}"
			s strRowId="{ID:"_ANMETRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ANTYPERowIdAuStr[ANTYPERowIdstrRowId)||(ANTYPERowIdAuFlag=1)) ;用来筛选授权数据
			{
				s ANMETCode=$p($g(^ORC("ANMET",ANMETRowId)),"^",1)
				s ANMETDesc=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
				s ANMETDateFrom=$p($g(^ORC("ANMET",ANMETRowId)),"^",5)
				continue:(ANMETDateFrom'="")&&(ANMETDateFrom>+$h)
				s ANMETDateTo=$p($g(^ORC("ANMET",ANMETRowId)),"^",6)
				continue:(ANMETDateTo'="")&&(ANMETDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestMethod",ANMETRowId,ANMETDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANMETCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ANMETRowId,ANMETCode,ANMETDesc)
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

// ANMET_Type_DR->ORCAnaestType

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据(医嘱套)ANMET_ARCOS_DR->ARC_OrdSets
/// (麻醉剂并发症ORCAnaestComplications)ANMET_ARCOS_DR,
/// Table:User.ARCOrdSets
/// Input:rowid,code,desc
/// Return:ARCOSRowId,ARCOSCode,ARCOSDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestMethod","GetARCOSDR","","")
/// select ARCOS_RowId as ARCOSRowId,ARCOS_Code as ARCOSCode,ARCOS_Desc as ARCOSDesc from ARC_OrdSets
Query GetARCOSDR(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ARCOSRowId:%String,ARCOSCode:%String,ARCOSDesc:%String")
{
}

ClassMethod GetARCOSDRExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ARCOSRowId=rowid
		s ARCOSCode=$p($g(^ARCOS(ARCOSRowId)),"^",1)
		s ARCOSDesc=$p($g(^ARCOS(ARCOSRowId)),"^",2)
		d OutputRowARCOS
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ARCOSRowId=0
		for
		{
			s ARCOSRowId=$o(^ARCOS(ARCOSRowId)) q:ARCOSRowId=""
			s ARCOSCode=$p($g(^ARCOS(ARCOSRowId)),"^",1)
			s ARCOSDesc=$p($g(^ARCOS(ARCOSRowId)),"^",2)
			s ARCOSCode1=$ZCONVERT(ARCOSCode,"U")
			s ARCOSDesc1=$ZCONVERT(ARCOSDesc,"U")
			s PINYIN=""
			s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ARCOSDesc1)
			i (ARCOSCode1[code)&((ARCOSDesc1[desc)||(PINYIN[desc))
			{
				d OutputRowARCOS
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowARCOS
    set Data=$lb(ARCOSRowId,ARCOSCode,ARCOSDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetARCOSDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCOSDRExecute ]
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

ClassMethod GetARCOSDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetARCOSDRExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.ORCAnaestMethod
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCAnaestMethod).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("ANMET",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("ANMET",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("ANMET",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("ANMET",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:双击修改时,从后台取数据
/// Table:User.ORCAnaestMethod
/// Input:id
/// Return:Json格式的字符串str={list:[ANMETCode,ANMETDesc,ANMETTypeDR,ANMETARCOSDR,ANMETDateFrom,ANMETDateTo,ANMETRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestMethod).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCAnaestMethod).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCAnaestMethod).%New()
	s eobj.ANMETRowId = id
	s eobj.ANMETCode = pobj.ANMETCode
	s eobj.ANMETDesc = pobj.ANMETDesc
	if $IsObject(pobj.ANMETTypeDR){
	s eobj.ANMETTypeDR = pobj.ANMETTypeDR.%Id() 
	}
	if $IsObject(pobj.ANMETARCOSDR){
	s eobj.ANMETARCOSDR = pobj.ANMETARCOSDR.%Id() 
	}	
	s eobj.ANMETDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ANMETDateFrom)
	s eobj.ANMETDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ANMETDateTo)
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:增加/修改 麻醉方法
/// Table:User.ORCAnaestMethod
/// Input:web.Entity.CT.ORCAnaestMethod
/// Return:成功返回success:'true'和新增或修改的数据的ANMETRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCAnaestMethod) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ANMETDateFrom'="" eobj.ANMETDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ANMETDateFrom)
		s:eobj.ANMETDateTo'="" eobj.ANMETDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ANMETDateTo)
		s:eobj.ANMETDateFrom="" eobj.ANMETDateFrom = +$h
		s flag=..FormValidate(eobj.ANMETRowId,eobj.ANMETCode,eobj.ANMETDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		if (eobj.ANMETRowId="")       
		{
			s obj=##class(User.ORCAnaestMethod).%New()
		}
		else                           
		{
			s obj=##class(User.ORCAnaestMethod).%OpenId(eobj.ANMETRowId)
			s bobj=##class(web.Entity.CT.ORCAnaestMethod).%New()
			s bobj.ANMETRowId = eobj.ANMETRowId
			s bobj.ANMETCode = obj.ANMETCode
			s bobj.ANMETDesc = obj.ANMETDesc
			if $IsObject(obj.ANMETTypeDR){
					s bobj.ANMETTypeDR = obj.ANMETTypeDR.%Id() 
				}
			if $IsObject(obj.ANMETARCOSDR){
					s bobj.ANMETARCOSDR = obj.ANMETARCOSDR.%Id() 
				}
			s bobj.ANMETDateFrom=obj.ANMETDateFrom
			s bobj.ANMETDateTo=obj.ANMETDateTo
		}

		s obj.ANMETCode = eobj.ANMETCode
		s obj.ANMETDesc = eobj.ANMETDesc
		d obj.ANMETTypeDRSetObjectId(eobj.ANMETTypeDR)
		d obj.ANMETARCOSDRSetObjectId(eobj.ANMETARCOSDR)
		//s obj.ANMETTypeDR = ##class(User.ORCAnaestType).%OpenId(eobj.ANMETTypeDR)
		//s obj.ANMETARCOSDR = ##class(User.ARCOrdSets).%OpenId(eobj.ANMETARCOSDR)
		
		s obj.ANMETDateFrom=eobj.ANMETDateFrom
		s obj.ANMETDateTo=eobj.ANMETDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ANMETRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestMethod","User.ORCAnaestMethod","麻醉方法",id,eobj.ANMETDesc,"A",eobj)
			d:eobj.ANMETRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestMethod","User.ORCAnaestMethod","麻醉方法",id,eobj.ANMETDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法","web.DHCBL.CT.ORCAnaestMethod","SaveEntity",eobj)
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
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s ANAGNRowId=0,flag=0
	for
	{
		s ANAGNRowId=$o(^ORC("ANAGN",ANAGNRowId)) q:(ANAGNRowId="")||(flag=1)
		s ANAGNMethodDR=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",4)
		i ANAGNMethodDR=id
		{
			s flag=1
			s myInfo=myInfo_"<麻醉剂>"
		}
		
	}
	
	s METAGRowId=0,flag=0
	for
	{
		s METAGRowId=$o(^ORC("METAG",METAGRowId)) q:(METAGRowId="")||(flag=1)
		s METAGMethodDR=$p($g(^ORC("METAG",METAGRowId)),"^",1)	
		i METAGMethodDR=id
		{
			s flag=1
			s myInfo=myInfo_"<麻醉方法关联的麻醉剂>"
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:根据id删除 麻醉方法
/// Table:User.ORCAnaestMethod
/// Input:id(ORCAnaestMethod的ANMETRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestMethod).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.ORCAnaestMethod).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCAnaestMethod).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCAnaestMethod).%New()
		s eobj.ANMETRowId = id
		s eobj.ANMETCode = pobj.ANMETCode
		s eobj.ANMETDesc = pobj.ANMETDesc
		if $IsObject(pobj.ANMETTypeDR){
		s eobj.ANMETTypeDR = pobj.ANMETTypeDR.%Id() 
		}
		if $IsObject(pobj.ANMETARCOSDR){
		s eobj.ANMETARCOSDR = pobj.ANMETARCOSDR.%Id() 
		}	
		s eobj.ANMETDateFrom =pobj.ANMETDateFrom
		s eobj.ANMETDateTo = pobj.ANMETDateTo
		//s:pobj.ANMETDateFrom'="" eobj.ANMETDateFrom =$zd(pobj.ANMETDateFrom,1)
		//s:pobj.ANMETDateTo'="" eobj.ANMETDateTo = $zd(pobj.ANMETDateTo,1)
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCAnaestMethod).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestMethod","User.ORCAnaestMethod","麻醉方法",id,eobj.ANMETDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉方法","web.DHCBL.CT.ORCAnaestMethod","DeleteData",eobj)
		    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
