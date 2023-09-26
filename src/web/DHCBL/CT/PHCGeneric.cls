Import SQLUser

/// 名称:药学 4药品处方通用名	
/// 描述:药品处方通用名维护，包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期:  2012-8-30
Class web.DHCBL.CT.PHCGeneric Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 		
/// CreatDate:2012-8-29
/// Description:查询 药品处方通用名
/// Table:User.PHCGeneric
/// Input:rowid, code, name
/// Output:PHCGERowId,PHCGECode,PHCGEName,PHCGEDateFrom,PHCGEDateTo
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCGeneric","GetList","","","")
Query GetList(rowid As %String, code As %String, name As %String) As %Query(ROWSPEC = "PHCGERowId:%String,PHCGECode:%String,PHCGEName:%String,PHCGEDateFrom:%String,PHCGEDateTo:%String ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCGERowId=rowid
		s PHCGECode= $p($g(^PHCGE("GE",PHCGERowId)),"^",1)
		s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
		s PHCGEDateFrom = $p($g(^PHCGE("GE",PHCGERowId)),"^",5)
		s:PHCGEDateFrom'="" PHCGEDateFrom = $zd(PHCGEDateFrom,1)
		s PHCGEDateTo = $p($g(^PHCGE("GE",PHCGERowId)),"^",6)
		s:PHCGEDateTo'="" PHCGEDateTo = $zd(PHCGEDateTo,1)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Generic",PHCGERowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)

		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:name'="" name=$ZCONVERT(name,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCGeneric).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCGERowId=0
		for
		{
			s PHCGERowId=$o(^PHCGE("GE",PHCGERowId)) q:PHCGERowId=""
			s strRowId="{ID:"_PHCGERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCGECode=$p($g(^PHCGE("GE",PHCGERowId)),"^",1)
				s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
				s PHCGEDateFrom = $p($g(^PHCGE("GE",PHCGERowId)),"^",5)
				s:PHCGEDateFrom'="" PHCGEDateFrom = $zd(PHCGEDateFrom,1)
				s PHCGEDateTo = $p($g(^PHCGE("GE",PHCGERowId)),"^",6)
				s:PHCGEDateTo'="" PHCGEDateTo = $zd(PHCGEDateTo,1)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Generic",PHCGERowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				
				if (name'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Generic",PHCGERowId,PHCGEName,name)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCGECode,"U")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCGERowId,PHCGECode,PHCGEName,PHCGEDateFrom,PHCGEDateTo ,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator:陈莹 		
/// CreatDate:2012-8-29
/// Description:查询 药品处方通用名
/// Table:User.PHCGeneric
/// Input: code, desc(name)
/// Output:PHCGERowId,PHCGECode,PHCGEName
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCGeneric","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHCGERowId:%String,PHCGECode:%String,PHCGEName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s PHCGERowId=rowid
		s PHCGECode= $p($g(^PHCGE("GE",PHCGERowId)),"^",1)
		s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.PHCGeneric).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCGERowId=0
		for
		{
			s PHCGERowId=$o(^PHCGE("GE",PHCGERowId)) q:PHCGERowId=""
			s strRowId="{ID:"_PHCGERowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCGECode=$p($g(^PHCGE("GE",PHCGERowId)),"^",1)
				s PHCGEName = $p($g(^PHCGE("GE",PHCGERowId)),"^",2)
				s PHCGEDateTo = $p($g(^PHCGE("GE",PHCGERowId)),"^",6)
				continue:(PHCGEDateTo'="")&&(PHCGEDateTo<+$h)
				if (name'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Generic",PHCGERowId,PHCGEName,name)
				}
				else
				{
					s AliasFlag=1
				}
				i ($ZCONVERT(PHCGECode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHCGERowId,PHCGECode,PHCGEName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:陈莹 
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.PHCGeneric
/// Input:id, code, name
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PHCGeneric).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, name As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:name'="" name=$$ALPHAUP^SSUTIL4(name) //$ZCONVERT(name,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PHCGE("GE",0,"Code",code))
	s:name'="" flagd=$d(^PHCGE("GE",0,"Name",name))
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
		s:code'="" idc=$o(^PHCGE("GE",0,"Code",code,0))
		s:name'="" idd=$o(^PHCGE("GE",0,"Name",name,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：User.PHCPHCGeneric
/// Return：Json格式的字符串(即：form表单中对应的数据项)
/// Input：PHCGERowId
/// Other: w ##class(web.DHCBL.CT.PHCGeneric).OpenData(1)
ClassMethod OpenData(PHCGERowId As %String) As %String
{
	n (PHCGERowId)
    s str = ""
	s pobj = ##class(User.PHCGeneric).%OpenId(PHCGERowId)
	s eobj = ##class(web.Entity.CT.PHCGeneric).%New()
	s eobj.PHCGERowId = PHCGERowId
	s eobj.PHCGECode  = pobj.PHCGECode
	s eobj.PHCGEName = pobj.PHCGEName
	s eobj.PHCGEDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCGEDateFrom)
	s eobj.PHCGEDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PHCGEDateTo)
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：保存 药品处方通用名
/// Table：User.PHCGeneric
/// Return:成功返回true，失败返回false
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCGeneric) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.PHCGEDateFrom'="" eobj.PHCGEDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCGEDateFrom)
		s:eobj.PHCGEDateTo'="" eobj.PHCGEDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCGEDateTo)
	 	if eobj.PHCGEDateFrom="" s eobj.PHCGEDateFrom=+$h
	 	
	 	s flag=..FormValidate(eobj.PHCGERowId,eobj.PHCGECode,eobj.PHCGEName)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PHCGERowId="")
		{	
	        s obj=##class(User.PHCGeneric).%New()
		}
		else
		{
			s obj=##class(User.PHCGeneric).%OpenId(eobj.PHCGERowId)
			
			s bobj = ##class(web.Entity.CT.PHCGeneric).%New()
			s bobj.PHCGERowId = eobj.PHCGERowId
			s bobj.PHCGECode = obj.PHCGECode
			s bobj.PHCGEName = obj.PHCGEName
	    	s bobj.PHCGEDateFrom = obj.PHCGEDateFrom
	    	s bobj.PHCGEDateTo = obj.PHCGEDateTo
		}
		
			
		s obj.PHCGECode = eobj.PHCGECode
		s obj.PHCGEName = eobj.PHCGEName
	   
	    s obj.PHCGEDateFrom = eobj.PHCGEDateFrom
	    s obj.PHCGEDateTo = eobj.PHCGEDateTo
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PHCGERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Generic","User.PHCGeneric","药品处方通用名",id,eobj.PHCGEName,"A",eobj)
			d:eobj.PHCGERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Generic","User.PHCGeneric","药品处方通用名",id,eobj.PHCGEName,"U",eobj,bobj)
			if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
			{
				s length=$l(eobj.DataAlias,"/")
				for aliasi=1:1:length
				{
					s alias=$p(eobj.DataAlias,"/",aliasi)
					s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Generic",alias,id)
				}
			}
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品处方通用名","web.DHCBL.CT.PHCGeneric","SaveEntity",eobj)
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
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.PHCGeneric).GetRefFlag(1391)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	i ($d(^PHCD(0,"Poison",+id))'=0)
	{
		s myInfo=myInfo_"<药学项>"
	}
	i ($d(^ARCIM(0,"ARCSG_DR",+id))'=0)
	{
		s myInfo=myInfo_"<医嘱项>"
	}
	
	s PHCGECode = $p($g(^PHCGE("GE",id)),"^",1)
	i ($o(^DHCPHGENCON(0,"HisCode",PHCGECode,"")))
	{
		s myInfo=myInfo_"<药品通用名与HIS项目对照表>"
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Description：根据id删除 药品处方通用名
/// Table：User.PHCGeneric
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// Other: d ##class(web.DHCBL.CT.PHCGeneric).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCGeneric).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
	
		s pobj = ##class(User.PHCGeneric).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCGeneric).%New()
		s eobj.PHCGERowId = id
		s eobj.PHCGECode  = pobj.PHCGECode
		s eobj.PHCGEName = pobj.PHCGEName
		s eobj.PHCGEDateFrom = pobj.PHCGEDateFrom
		s eobj.PHCGEDateTo = pobj.PHCGEDateTo
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.PHCGeneric).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Generic","User.PHCGeneric","药品处方通用名",id,eobj.PHCGEName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品处方通用名","web.DHCBL.CT.PHCGeneric","DeleteData",eobj)
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
