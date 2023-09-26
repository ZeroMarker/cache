Import SQLUser

/// 名称:手术和过程 - 9 麻醉剂
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:  2012-9-7
Class web.DHCBL.CT.ORCAnaestAgent Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 麻醉剂
/// Table:User.ORCAnaestAgent
/// Input:rowid,code,desc
/// Return:ANAGNRowId,ANAGNCode,ANAGNDesc,ANAGNARCIMDR,ANAGNMethodDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestAgent","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANAGNRowId:%String,ANAGNCode:%String,ANAGNDesc:%String,ANAGNARCIMDR:%String,ANAGNMethodDR:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s ANAGNRowId=rowid
		s ANAGNCode=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",1)
		s ANAGNDesc=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
		s ARCIMRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",3)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
		s ARCIMSubscript=$p(ARCIMRowId,"||",1)
		s ARCIMVersion=$p(ARCIMRowId,"||",2)
		i ARCIMRowId'="" {
			s ANAGNARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		}
		else {
			s ANAGNARCIMDR=""
		}
		s ANMETRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",4)
		i ANMETRowId'="" {
			s ANAGNMethodDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
		}
		else {
			s ANAGNMethodDR=""
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestAgent",ANAGNRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestAgent).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
			{
				s Limited=0
				s AutBit=""
			}
			elseif ($l(ARCIMRowIdAuStr,"#")=2) 
			{
				s Limited=$p(ARCIMRowIdAuStr,"#",1)
				s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 			}
			s ARCIMRowIdAuFlag=0
			if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示

		s ANMETRowIdAuStr=##class(web.DHCBL.Authorize.ORCAnaestMethod).DHCGetDataByDefaultSession()
		s ANMETRowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ANMETRowIdAuStr="")||(ANMETRowIdAuStr["limited:0") s ANMETRowIdAuFlag=1
		s ANAGNRowId=0
		for
		{
			s ANAGNRowId=$o(^ORC("ANAGN",ANAGNRowId)) q:ANAGNRowId=""
			s ARCIMRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",3)
			s ANMETRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",4)
			S ARCIMSubscript=$P(ARCIMRowId,"||",1)
			s strRowId="{ID:"_ANAGNRowId_"}"
			s ANMETRowIdstrRowId="{ID:"_ANMETRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ANMETRowIdAuStr[ANMETRowIdstrRowId)||(ANMETRowIdAuFlag=1))&&(($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s ANAGNCode=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",1)
				s ANAGNDesc=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
				s ARCIMRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",3)  //ARCIMRowId=ARCIMSubscript||ARCIMVersion
				s ARCIMSubscript=$p(ARCIMRowId,"||",1)
				s ARCIMVersion=$p(ARCIMRowId,"||",2)
				i ARCIMRowId'="" {
					s ANAGNARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
				}
				else {
					s ANAGNARCIMDR=""
				}
				s ANMETRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",4)
				i ANMETRowId'="" {
					s ANAGNMethodDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
				}
				else {
					s ANAGNMethodDR=""
				}
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_AnaestAgent",ANAGNRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestAgent",ANAGNRowId,ANAGNDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANAGNCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ANAGNRowId,ANAGNCode,ANAGNDesc,ANAGNARCIMDR,ANAGNMethodDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCAnaestAgent
/// Input:code,desc
/// Return:ANAGNRowId,ANAGNCode,ANAGNDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCAnaestAgent","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANAGNRowId:%String,ANAGNCode:%String,ANAGNDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ANAGNRowId=rowid
		s ANAGNCode=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",1)
		s ANAGNDesc=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCAnaestAgent).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ARCIMRowIdAuStr=##class(web.DHCBL.Authorize.ARCItmMast).DHCGetDataByDefaultSession()
		if ($l(ARCIMRowIdAuStr,"#")=1) 
		{
			s Limited=0
			s AutBit=""
		}
		elseif ($l(ARCIMRowIdAuStr,"#")=2) 
		{
			s Limited=$p(ARCIMRowIdAuStr,"#",1)
			s AutBit=$p(ARCIMRowIdAuStr,"#",2)
 		}
		s ARCIMRowIdAuFlag=0
		if (ARCIMRowIdAuStr="")||((ARCIMRowIdAuStr'="")&(Limited=0)) s ARCIMRowIdAuFlag=1 //判断是否有授权,如果没有则全部显示

		s ANMETRowIdAuStr=##class(web.DHCBL.Authorize.ORCAnaestMethod).DHCGetDataByDefaultSession()
		s ANMETRowIdAuFlag=0
		;未授权情况下，默认显示全部数据
		if (ANMETRowIdAuStr="")||(ANMETRowIdAuStr["limited:0") s ANMETRowIdAuFlag=1
		s ANAGNRowId=0
		for
		{
			s ANAGNRowId=$o(^ORC("ANAGN",ANAGNRowId)) q:ANAGNRowId=""
			s ARCIMRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",3)
			s ANMETRowId=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",4)
			S ARCIMSubscript=$P(ARCIMRowId,"||",1)
			s strRowId="{ID:"_ANAGNRowId_"}"
			s ANMETRowIdstrRowId="{ID:"_ANMETRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ANMETRowIdAuStr[ANMETRowIdstrRowId)||(ANMETRowIdAuFlag=1))&&(($bit(AutBit,ARCIMSubscript)=1)||(ARCIMRowIdAuFlag=1)) ;用来筛选授权数据
			{
				s ANAGNCode=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",1)
				s ANAGNDesc=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_AnaestAgent",ANAGNRowId,ANAGNDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(ANAGNCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ANAGNRowId,ANAGNCode,ANAGNDesc)
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

/// ANAGN_ARCIM_DR->ARC_ItmMast
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperation","GetARCIMDR","","")
/// ANAGN_Method_DR->ORC_AnaestMethod
/// Creator:陈莹
/// CreatDate:2012-12-24  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.ORCAnaestAgent
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCAnaestAgent).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("ANAGN",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("ANAGN",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("ANAGN",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("ANAGN",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:双击修改时从后台取数据
/// Table:User.ORCAnaestAgent
/// Input:id
/// Return:Json格式的字符串str={list:[ANAGNCode,ANAGNDesc,ANAGNARCIMDR,ANAGNMethodDR,ANAGNRowId]}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestAgent).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCAnaestAgent).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCAnaestAgent).%New()
	s eobj.ANAGNRowId = id
	s eobj.ANAGNCode = pobj.ANAGNCode
	s eobj.ANAGNDesc = pobj.ANAGNDesc
	if $IsObject(pobj.ANAGNARCIMDR){
		s eobj.ANAGNARCIMDR = pobj.ANAGNARCIMDR.%Id() 
		}
	if $IsObject(pobj.ANAGNMethodDR){
		s eobj.ANAGNMethodDR = pobj.ANAGNMethodDR.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:增加/修改 麻醉剂
/// Table:User.ORCAnaestAgent
/// Input:web.Entity.CT.ORCAnaestAgent
/// Return:成功返回success:'true'和新增或修改的数据的ANAGNRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCAnaestAgent) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断
		s flag=..FormValidate(eobj.ANAGNRowId,eobj.ANAGNCode,eobj.ANAGNDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		if (eobj.ANAGNRowId="")       
		{
			s obj=##class(User.ORCAnaestAgent).%New()
		}
		else                           
		{
			s obj=##class(User.ORCAnaestAgent).%OpenId(eobj.ANAGNRowId)
			s bobj=##class(web.Entity.CT.ORCAnaestAgent).%New()
			s bobj.ANAGNRowId = eobj.ANAGNRowId  
			s bobj.ANAGNCode = obj.ANAGNCode                      
			s bobj.ANAGNDesc = obj.ANAGNDesc
			if $IsObject(obj.ANAGNARCIMDR){
					s bobj.ANAGNARCIMDR = obj.ANAGNARCIMDR.%Id() 
				}
			if $IsObject(obj.ANAGNMethodDR){
					s bobj.ANAGNMethodDR = obj.ANAGNMethodDR.%Id() 
				}
		}
		s obj.ANAGNCode = eobj.ANAGNCode                      
		s obj.ANAGNDesc = eobj.ANAGNDesc
		d obj.ANAGNARCIMDRSetObjectId(eobj.ANAGNARCIMDR)
		d obj.ANAGNMethodDRSetObjectId(eobj.ANAGNMethodDR)                    
		//s obj.ANAGNARCIMDR=##class(User.ARCItmMast).%OpenId(eobj.ANAGNARCIMDR)
		//s obj.ANAGNMethodDR=##class(User.ORCAnaestMethod).%OpenId(eobj.ANAGNMethodDR)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ANAGNRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestAgent","User.ORCAnaestAgent","麻醉剂",id,eobj.ANAGNDesc,"A",eobj)
			d:eobj.ANAGNRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestAgent","User.ORCAnaestAgent","麻醉剂",id,eobj.ANAGNDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉剂","web.DHCBL.CT.ORCAnaestAgent","SaveEntity",eobj)
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
	
	s METAGRowId=0,flag=0
	for
	{
		s METAGRowId=$o(^ORC("METAG",METAGRowId)) q:(METAGRowId="")||(flag=1)
		s METAGAgentDR=$p($g(^ORC("METAG",METAGRowId)),"^",2)
		i METAGAgentDR=id
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
/// Description:根据id删除 麻醉剂
/// Table:User.ORCAnaestAgent
/// Input:id(ORCAnaestAgent的ANAGNRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCAnaestAgent).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.ORCAnaestAgent).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCAnaestAgent).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCAnaestAgent).%New()
		s eobj.ANAGNRowId = id
		s eobj.ANAGNCode = pobj.ANAGNCode
		s eobj.ANAGNDesc = pobj.ANAGNDesc
		if $IsObject(pobj.ANAGNARCIMDR){
			s eobj.ANAGNARCIMDR = pobj.ANAGNARCIMDR.%Id() 
			}
		if $IsObject(pobj.ANAGNMethodDR){
			s eobj.ANAGNMethodDR = pobj.ANAGNMethodDR.%Id() 
			}
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCAnaestAgent).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_AnaestAgent","User.ORCAnaestAgent","麻醉剂",id,eobj.ANAGNDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("麻醉剂","web.DHCBL.CT.ORCAnaestAgent","DeleteData",eobj)
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
