/// 名称:结算菜单 -  出院条件	
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-24
Class web.DHCBL.CT.PACDischCondit Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-6-24
/// Description:查询 出院条件
/// Table:User.PACDischCondit
/// Input:rowid,code,desc
/// Return:DISCONRowId,DISCONCode,DISCONDesc,DISCONDateFrom,DISCONDateTo,DISCONDeadFlag,DISCONNationalCode,DISCONEpisodeType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACDischCondit","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DISCONRowId:%String,DISCONCode:%String,DISCONDesc:%String,DISCONDeadFlag:%String,DISCONNationalCode:%String,DISCONEpisodeType:%String,DISCONDateFrom:%String,DISCONDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s DISCONRowId=rowid
		s DISCONCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",1)
		s DISCONDesc=$p($g(^PAC("DISCON",DISCONRowId)),"^",2)
		s DISCONDeadFlag=$p($g(^PAC("DISCON",DISCONRowId)),"^",3)
		s DISCONNationalCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",6)
		s DISCONEpisodeType=$p($g(^PAC("DISCON",DISCONRowId)),"^",7)
		
		s DISCONDateFrom=$p($g(^PAC("DISCON",DISCONRowId)),"^",4)
		s DISCONDateTo=$p($g(^PAC("DISCON",DISCONRowId)),"^",5)
		s:DISCONDateFrom'="" DISCONDateFrom=$zd(DISCONDateFrom,1)
		s:DISCONDateTo'="" DISCONDateTo=$zd(DISCONDateTo,1)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_DischCondit",DISCONRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PACDischCondit).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s DISCONRowId=0
		for
		{
			s DISCONRowId=$o(^PAC("DISCON",DISCONRowId)) q:DISCONRowId=""
			s strRowId="{ID:"_DISCONRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s DISCONCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",1)
				s DISCONDesc=$p($g(^PAC("DISCON",DISCONRowId)),"^",2)
				s DISCONDeadFlag=$p($g(^PAC("DISCON",DISCONRowId)),"^",3)
				s DISCONNationalCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",6)
				s DISCONEpisodeType=$p($g(^PAC("DISCON",DISCONRowId)),"^",7)
				s DISCONDateFrom=$p($g(^PAC("DISCON",DISCONRowId)),"^",4)
				s DISCONDateTo=$p($g(^PAC("DISCON",DISCONRowId)),"^",5)
				s:DISCONDateFrom'="" DISCONDateFrom=$zd(DISCONDateFrom,1)
				s:DISCONDateTo'="" DISCONDateTo=$zd(DISCONDateTo,1)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_DischCondit",DISCONRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_DischCondit",DISCONRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DISCONDesc)
				i ($ZCONVERT(DISCONCode,"U")[code)&(($ZCONVERT(DISCONDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_DischCondit",DISCONRowId,DISCONDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(DISCONCode,"U")[code) &(AliasFlag=1)						
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DISCONRowId,DISCONCode,DISCONDesc,DISCONDeadFlag,DISCONNationalCode,DISCONEpisodeType,DISCONDateFrom,DISCONDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2014-6-24
/// Description:为combobox查询取数据
/// Table:User.PACDischCondit
/// Input:code,desc
/// Return:DISCONRowId,DISCONCode,DISCONDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACDischCondit","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DISCONRowId:%String,DISCONCode:%String,DISCONDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s DISCONRowId=rowid
		s DISCONCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",1)
		s DISCONDesc=$p($g(^PAC("DISCON",DISCONRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PACDischCondit).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s DISCONRowId=0
		for
		{
			s DISCONRowId=$o(^PAC("DISCON",DISCONRowId)) q:DISCONRowId=""
			s strRowId="{ID:"_DISCONRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s DISCONCode=$p($g(^PAC("DISCON",DISCONRowId)),"^",1)
				s DISCONDesc=$p($g(^PAC("DISCON",DISCONRowId)),"^",2)
				s DISCONDateFrom=$p($g(^PAC("DISCON",DISCONRowId)),"^",4)
				continue:(DISCONDateFrom'="")&&(DISCONDateFrom>+$h)
				s DISCONDateTo=$p($g(^PAC("DISCON",DISCONRowId)),"^",5)
				continue:(DISCONDateTo'="")&&(DISCONDateTo<+$h)
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_DischCondit",DISCONRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DISCONDesc)
				i ($ZCONVERT(DISCONCode,"U")[code)&(($ZCONVERT(DISCONDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_DischCondit",DISCONRowId,DISCONDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(DISCONCode,"U")[code) &(AliasFlag=1)					
		        {
					d OutputRowCmb
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(DISCONRowId,DISCONCode,DISCONDesc)
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
/// CreatDate:2014-6-24
/// Description:数据重复验证方法,js调用
/// Table:User.PACDischCondit
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACDischCondit).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PAC("DISCON",0,"Code",code))
	s:desc'="" flagd=$d(^PAC("DISCON",0,"Desc",desc))
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
		s:code'="" idc=$o(^PAC("DISCON",0,"Code",code,0))
		s:desc'="" idd=$o(^PAC("DISCON",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2014-6-24
/// Description:双击修改时,从后台取数据
/// Table:User.PACDischCondit
/// Input:id
/// Return:Json格式的字符串str={list:[DISCONCode,DISCONDesc,DISCONDateFrom,DISCONDateTo,DISCONRowId]}
/// Other:d ##class(web.DHCBL.CT.PACDischCondit).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.PACDischCondit).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACDischCondit).%New()
	s eobj.DISCONRowId = id
	s eobj.DISCONCode = pobj.DISCONCode
	s eobj.DISCONDesc = pobj.DISCONDesc
	s eobj.DISCONDeadFlag = pobj.DISCONDeadFlag
	s eobj.DISCONNationalCode = pobj.DISCONNationalCode
	s eobj.DISCONEpisodeType = pobj.DISCONEpisodeType
	
	s eobj.DISCONDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DISCONDateFrom)
	s eobj.DISCONDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DISCONDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2014-6-24
/// Description:增加/修改 出院条件
/// Table:User.PACDischCondit
/// Input:web.Entity.CT.PACDischCondit
/// Return:成功返回success:'true'和新增或修改的数据的DISCONRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACDischCondit) As %String
{
    new (eobj,%session)
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断、开始日期是否小于结束日期
		s:eobj.DISCONDateFrom'="" eobj.DISCONDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DISCONDateFrom)
		s:eobj.DISCONDateTo'="" eobj.DISCONDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DISCONDateTo)
		s:eobj.DISCONDateFrom="" eobj.DISCONDateFrom=+$h
		if (eobj.DISCONRowId="")       
		{
			s obj=##class(User.PACDischCondit).%New()
		}
		else                           
		{
			s obj=##class(User.PACDischCondit).%OpenId(eobj.DISCONRowId)
			s bobj = ##class(web.Entity.CT.PACDischCondit).%New()
			s bobj.DISCONRowId = eobj.DISCONRowId
			s bobj.DISCONCode = obj.DISCONCode
			s bobj.DISCONDesc = obj.DISCONDesc
			
			s bobj.DISCONDeadFlag = obj.DISCONDeadFlag
			s bobj.DISCONNationalCode = obj.DISCONNationalCode
			s bobj.DISCONEpisodeType = obj.DISCONEpisodeType
			
			s bobj.DISCONDateFrom=obj.DISCONDateFrom
			s bobj.DISCONDateTo=obj.DISCONDateTo
			
		}

		s obj.DISCONCode = eobj.DISCONCode
		s obj.DISCONDesc = eobj.DISCONDesc
		s obj.DISCONDeadFlag = eobj.DISCONDeadFlag
		s obj.DISCONNationalCode = eobj.DISCONNationalCode
		s obj.DISCONEpisodeType = eobj.DISCONEpisodeType
		s obj.DISCONDateFrom=eobj.DISCONDateFrom
		s obj.DISCONDateTo=eobj.DISCONDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.DISCONRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DischCondit","User.PACDischCondit","出院条件",id,eobj.DISCONDesc,"A",eobj)
			d:eobj.DISCONRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DischCondit","User.PACDischCondit","出院条件",id,eobj.DISCONDesc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("出院条件","web.DHCBL.CT.PACDischCondit","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
					
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
  	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("出院条件","web.DHCBL.CT.PACDischCondit","SaveEntity",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2014-6-24
/// Description:根据id删除 出院条件
/// Table:User.PACDischCondit
/// Input:id(PACDischCondit的DISCONRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACDischCondit).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.PACDischCondit).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACDischCondit).%New()
	s eobj.DISCONRowId = id
	s eobj.DISCONCode = pobj.DISCONCode
	s eobj.DISCONDesc = pobj.DISCONDesc
	s eobj.DISCONDeadFlag = pobj.DISCONDeadFlag
	s eobj.DISCONNationalCode = pobj.DISCONNationalCode
	s eobj.DISCONEpisodeType = pobj.DISCONEpisodeType
	s eobj.DISCONDateFrom = pobj.DISCONDateFrom 
	s eobj.DISCONDateTo = pobj.DISCONDateTo 
	//s:pobj.DISCONDateFrom'="" eobj.DISCONDateFrom =$zd(pobj.DISCONDateFrom,1)
	//s:pobj.DISCONDateTo'="" eobj.DISCONDateTo = $zd(pobj.DISCONDateTo,1)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PACDischCondit).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_DischCondit","User.PACDischCondit","出院条件",id,eobj.DISCONDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("出院条件","web.DHCBL.CT.PACDischCondit","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
