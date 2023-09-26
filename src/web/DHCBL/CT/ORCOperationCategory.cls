Import SQLUser

/// 名称:手术和过程 - 12 手术分级
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ORCOperationCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-21
/// Description:查询 手术分级
/// Table:User.ORCOperationCategory
/// Input:rowid,code,desc
/// Return:CATEGRowId,CATEGCode,CATEGDesc,CATEGDateFrom,CATEGDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CATEGRowId:%String,CATEGCode:%String,CATEGDesc:%String,CATEGDateFrom:%String,CATEGDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CATEGRowId=rowid
		s CATEGCode=$p($g(^ORC("CATEG",CATEGRowId)),"^",1)
		s CATEGDesc=$p($g(^ORC("CATEG",CATEGRowId)),"^",2)
		s CATEGDateFrom=$p($g(^ORC("CATEG",CATEGRowId)),"^",3)
		s CATEGDateTo=$p($g(^ORC("CATEG",CATEGRowId)),"^",4)
		
		s:CATEGDateFrom'="" CATEGDateFrom=$zd(CATEGDateFrom,1)
		s:CATEGDateTo'="" CATEGDateTo=$zd(CATEGDateTo,1)
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_OperationCategory",CATEGRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CATEGRowId=0
		for
		{
			s CATEGRowId=$o(^ORC("CATEG",CATEGRowId)) q:CATEGRowId=""
			s strRowId="{ID:"_CATEGRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CATEGCode=$p($g(^ORC("CATEG",CATEGRowId)),"^",1)
				s CATEGDesc=$p($g(^ORC("CATEG",CATEGRowId)),"^",2)
				s CATEGDateFrom=$p($g(^ORC("CATEG",CATEGRowId)),"^",3)
				s CATEGDateTo=$p($g(^ORC("CATEG",CATEGRowId)),"^",4)
				s:CATEGDateFrom'="" CATEGDateFrom=$zd(CATEGDateFrom,1)
				s:CATEGDateTo'="" CATEGDateTo=$zd(CATEGDateTo,1)
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
     			s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ORC_OperationCategory",CATEGRowId)
     			s BDPInternalCode =$p($g(resultStr),"^",1)       
     			s BDPInternalDesc = $p($g(resultStr),"^",2)  
     			s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     			s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     			if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_OperationCategory",CATEGRowId,CATEGDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(CATEGCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CATEGRowId,CATEGCode,CATEGDesc,CATEGDateFrom,CATEGDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.ORCOperationCategory
/// Input:code,desc
/// Return:CATEGRowId,CATEGCode,CATEGDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationCategory","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CATEGRowId:%String,CATEGCode:%String,CATEGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s CATEGRowId=rowid
		s CATEGCode=$p($g(^ORC("CATEG",CATEGRowId)),"^",1)
		s CATEGDesc=$p($g(^ORC("CATEG",CATEGRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CATEGRowId=0
		for
		{
			s CATEGRowId=$o(^ORC("CATEG",CATEGRowId)) q:CATEGRowId=""
			s strRowId="{ID:"_CATEGRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CATEGCode=$p($g(^ORC("CATEG",CATEGRowId)),"^",1)
				s CATEGDesc=$p($g(^ORC("CATEG",CATEGRowId)),"^",2)
				s CATEGDateFrom=$p($g(^ORC("CATEG",CATEGRowId)),"^",3)
				continue:(CATEGDateFrom'="")&&(CATEGDateFrom>+$h)
				
				s CATEGDateTo=$p($g(^ORC("CATEG",CATEGRowId)),"^",4)
				continue:(CATEGDateTo'="")&&(CATEGDateTo<+$h)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ORC_OperationCategory",CATEGRowId,CATEGDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(CATEGCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CATEGRowId,CATEGCode,CATEGDesc)
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
/// Table:User.ORCOperationCategory
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.ORCOperationCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^ORC("CATEG",0,"Code",code))
	s:desc'="" flagd=$d(^ORC("CATEG",0,"Desc",desc))
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
		s:code'="" idc=$o(^ORC("CATEG",0,"Code",code,0))
		s:desc'="" idd=$o(^ORC("CATEG",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:双击修改时,从后台取数据
/// Table:User.ORCOperationCategory
/// Input:id
/// Return:Json格式的字符串str={list:[CATEGCode,CATEGDesc,CATEGDateFrom,CATEGDateTo,CATEGRowId]}
/// Other:w ##class(web.DHCBL.CT.ORCOperationCategory).OpenData("19")
ClassMethod OpenData(id As %String) As %String
{
	new (id)
	s str=""
	s pobj = ##class(User.ORCOperationCategory).%OpenId(id)
	s eobj = ##class(web.Entity.CT.ORCOperationCategory).%New()
	s eobj.CATEGRowId = id
	s eobj.CATEGCode = pobj.CATEGCode
	s eobj.CATEGDesc = pobj.CATEGDesc
	s eobj.CATEGDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CATEGDateFrom)
	s eobj.CATEGDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CATEGDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:增加/修改 手术分级
/// Table:User.ORCOperationCategory
/// Input:web.Entity.CT.ORCOperationCategory
/// Return:成功返回success:'true'和新增或修改的数据的CATEGRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperationCategory) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CATEGDateFrom'="" eobj.CATEGDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CATEGDateFrom)
		s:eobj.CATEGDateTo'="" eobj.CATEGDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CATEGDateTo)
		s:eobj.CATEGDateFrom="" eobj.CATEGDateFrom = +$h
		s flag=..FormValidate(eobj.CATEGRowId,eobj.CATEGCode,eobj.CATEGDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.CATEGRowId="")       
		{
			s obj=##class(User.ORCOperationCategory).%New()
		}
		else                           
		{
			s obj=##class(User.ORCOperationCategory).%OpenId(eobj.CATEGRowId)
			
			s bobj = ##class(web.Entity.CT.ORCOperationCategory).%New()
			s bobj.CATEGRowId = eobj.CATEGRowId
			s bobj.CATEGCode = obj.CATEGCode
			s bobj.CATEGDesc = obj.CATEGDesc
			s bobj.CATEGDateFrom=obj.CATEGDateFrom
			s bobj.CATEGDateTo=obj.CATEGDateTo
		}
		s obj.CATEGCode = eobj.CATEGCode
		s obj.CATEGDesc = eobj.CATEGDesc
		s obj.CATEGDateFrom=eobj.CATEGDateFrom
		s obj.CATEGDateTo=eobj.CATEGDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CATEGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationCategory","User.ORCOperationCategory","手术分级",id,eobj.CATEGDesc,"A",eobj)
			d:eobj.CATEGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationCategory","User.ORCOperationCategory","手术分级",id,eobj.CATEGDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术分级","web.DHCBL.CT.ORCOperationCategory","SaveEntity",eobj)
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
	s OPERRowId=0,flag=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:(OPERRowId="")||(flag=1)
		s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
		i OPERDefaultCategoryDR=id
		{
			s flag=1
			s myInfo=myInfo_"<手术/过程>"
		}
	}
	
	s OPERRowId=0,flag=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:(OPERRowId="")||(flag=1)
		s OPERClassDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",1)   //手术分级
		i OPERClassDr=id
		{
			s flag=1
			s myInfo=myInfo_"<手术/过程扩展信息表>"
		}
	}
	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2012-9-6
/// Description:根据id删除 手术分级
/// Table:User.ORCOperationCategory
/// Input:id(ORCOperationCategory的CATEGRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.ORCOperationCategory).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.ORCOperationCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.ORCOperationCategory).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCOperationCategory).%New()
		s eobj.CATEGRowId = id
		s eobj.CATEGCode = pobj.CATEGCode
		s eobj.CATEGDesc = pobj.CATEGDesc
		s eobj.CATEGDateFrom =pobj.CATEGDateFrom
		s eobj.CATEGDateTo = pobj.CATEGDateTo
		//s:pobj.CATEGDateFrom'="" eobj.CATEGDateFrom =$zd(pobj.CATEGDateFrom,1)
		//s:pobj.CATEGDateTo'="" eobj.CATEGDateTo = $zd(pobj.CATEGDateTo,1)
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.ORCOperationCategory).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationCategory","User.ORCOperationCategory","手术分级",id,eobj.CATEGDesc,"D",eobj)
		}
		else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术分级","web.DHCBL.CT.ORCOperationCategory","DeleteData",eobj)
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
