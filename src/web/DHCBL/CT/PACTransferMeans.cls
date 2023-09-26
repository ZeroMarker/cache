/// 名称:结算菜单 -  来院途径
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-25
Class web.DHCBL.CT.PACTransferMeans Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:查询 来院途径
/// Table:User.PACTransferMeans
/// Input:rowid,code,desc
/// Return:TRANSMRowId,TRANSMCode,TRANSMDesc,TRANSMDateFrom,TRANSMDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACTransferMeans","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TRANSMRowId:%String,TRANSMCode:%String,TRANSMDesc:%String,TRANSMDateFrom:%String,TRANSMDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s TRANSMRowId=rowid
		s TRANSMCode=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",1)
		s TRANSMDesc=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",2)
		s TRANSMDateFrom=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",5)
		s TRANSMDateTo=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",6)
		s:TRANSMDateFrom'="" TRANSMDateFrom=$zd(TRANSMDateFrom,1)
		s:TRANSMDateTo'="" TRANSMDateTo=$zd(TRANSMDateTo,1)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_TransferMeans",TRANSMRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PACTransferMeans).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s TRANSMRowId=0
		for
		{
			s TRANSMRowId=$o(^PAC("TRANSM",TRANSMRowId)) q:TRANSMRowId=""
			s strRowId="{ID:"_TRANSMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s TRANSMCode=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",1)
				s TRANSMDesc=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",2)
				s TRANSMDateFrom=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",5)
				s TRANSMDateTo=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",6)
				s:TRANSMDateFrom'="" TRANSMDateFrom=$zd(TRANSMDateFrom,1)
				s:TRANSMDateTo'="" TRANSMDateTo=$zd(TRANSMDateTo,1)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_TransferMeans",TRANSMRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				//别名查询		         
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_TransferMeans",TRANSMRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TRANSMDesc)

				i ($ZCONVERT(TRANSMCode,"U")[code)&(($ZCONVERT(TRANSMDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_TransferMeans",TRANSMRowId,TRANSMDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(TRANSMCode,"U")[code) &(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TRANSMRowId,TRANSMCode,TRANSMDesc,TRANSMDateFrom,TRANSMDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2014-6-25
/// Description:为combobox查询取数据
/// Table:User.PACTransferMeans
/// Input:code,desc
/// Return:TRANSMRowId,TRANSMCode,TRANSMDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACTransferMeans","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TRANSMRowId:%String,TRANSMCode:%String,TRANSMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s TRANSMRowId=rowid
		s TRANSMCode=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",1)
		s TRANSMDesc=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PACTransferMeans).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s TRANSMRowId=0
		for
		{
			s TRANSMRowId=$o(^PAC("TRANSM",TRANSMRowId)) q:TRANSMRowId=""
			s strRowId="{ID:"_TRANSMRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s TRANSMCode=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",1)
				s TRANSMDesc=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",2)
				s TRANSMDateFrom=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",5)
				continue:(TRANSMDateFrom'="")&&(TRANSMDateFrom>+$h)
				s TRANSMDateTo=$p($g(^PAC("TRANSM",TRANSMRowId)),"^",6)
				continue:(TRANSMDateTo'="")&&(TRANSMDateTo<+$h)
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_TransferMeans",TRANSMRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TRANSMDesc)
				i ($ZCONVERT(TRANSMCode,"U")[code)&(($ZCONVERT(TRANSMDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_TransferMeans",TRANSMRowId,TRANSMDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(TRANSMCode,"U")[code) &(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(TRANSMRowId,TRANSMCode,TRANSMDesc)
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
/// CreatDate:2014-6-25
/// Description:数据重复验证方法,js调用
/// Table:User.PACTransferMeans
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACTransferMeans).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PAC("TRANSM",0,"Code",code))
	s:desc'="" flagd=$d(^PAC("TRANSM",0,"Desc",desc))
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
		s:code'="" idc=$o(^PAC("TRANSM",0,"Code",code,0))
		s:desc'="" idd=$o(^PAC("TRANSM",0,"Desc",desc,0))
		if (desc="")
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

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:双击修改时,从后台取数据
/// Table:User.PACTransferMeans
/// Input:id
/// Return:Json格式的字符串str={list:[TRANSMCode,TRANSMDesc,TRANSMDateFrom,TRANSMDateTo,TRANSMRowId]}
/// Other:d ##class(web.DHCBL.CT.PACTransferMeans).OpenData("1")
/// RetFlag=""或"Y"时，用于EXT, =JSON时，RetFlag="N"时用于HISUI，不输出 "{list:["_str_"]}"  //2019-12-24 钟荣枫
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	new (id,RetFlag)
	s str=""
	s pobj = ##class(User.PACTransferMeans).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACTransferMeans).%New()
	s eobj.TRANSMRowId = id
	s eobj.TRANSMCode = pobj.TRANSMCode
	s eobj.TRANSMDesc = pobj.TRANSMDesc
	s eobj.TRANSMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TRANSMDateFrom)
	s eobj.TRANSMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TRANSMDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	if (RetFlag="")||(RetFlag="Y")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:增加/修改 来院途径
/// Table:User.PACTransferMeans
/// Input:web.Entity.CT.PACTransferMeans
/// Return:成功返回success:'true'和新增或修改的数据的TRANSMRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACTransferMeans) As %String
{
    new (eobj,%session)
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//前台js已添加空值判断、重复判断、开始日期是否小于结束日期
		s:eobj.TRANSMDateFrom'="" eobj.TRANSMDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TRANSMDateFrom)
		s:eobj.TRANSMDateTo'="" eobj.TRANSMDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TRANSMDateTo)
		s:eobj.TRANSMDateFrom="" eobj.TRANSMDateFrom=+$h
		
		if (eobj.TRANSMRowId="")       
		{
			s obj=##class(User.PACTransferMeans).%New()
		}
		else                           
		{
			s obj=##class(User.PACTransferMeans).%OpenId(eobj.TRANSMRowId)
			s bobj = ##class(web.Entity.CT.PACTransferMeans).%New()
			s bobj.TRANSMRowId = eobj.TRANSMRowId
			s bobj.TRANSMCode = obj.TRANSMCode
			s bobj.TRANSMDesc = obj.TRANSMDesc
			s bobj.TRANSMDateFrom=obj.TRANSMDateFrom
			s bobj.TRANSMDateTo=obj.TRANSMDateTo
		}

		s obj.TRANSMCode = eobj.TRANSMCode
		s obj.TRANSMDesc = eobj.TRANSMDesc
		s obj.TRANSMDateFrom=eobj.TRANSMDateFrom
		s obj.TRANSMDateTo=eobj.TRANSMDateTo
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.TRANSMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TransferMeans","User.PACTransferMeans","来院途径",id,eobj.TRANSMDesc,"A",eobj)
			d:eobj.TRANSMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TransferMeans","User.PACTransferMeans","来院途径",id,eobj.TRANSMDesc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("来院途径","web.DHCBL.CT.PACTransferMeans","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
					
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("来院途径","web.DHCBL.CT.PACTransferMeans","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:根据id删除 来院途径
/// Table:User.PACTransferMeans
/// Input:id(PACTransferMeans的TRANSMRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACTransferMeans).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.PACTransferMeans).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACTransferMeans).%New()
	s eobj.TRANSMRowId = id
	s eobj.TRANSMCode = pobj.TRANSMCode
	s eobj.TRANSMDesc = pobj.TRANSMDesc
	s eobj.TRANSMDateFrom = pobj.TRANSMDateFrom 
	s eobj.TRANSMDateTo = pobj.TRANSMDateTo 
	//s:pobj.TRANSMDateFrom'="" eobj.TRANSMDateFrom =$zd(pobj.TRANSMDateFrom,1)
	//s:pobj.TRANSMDateTo'="" eobj.TRANSMDateTo = $zd(pobj.TRANSMDateTo,1)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PACTransferMeans).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_TransferMeans","User.PACTransferMeans","来院途径",id,eobj.TRANSMDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("来院途径","web.DHCBL.CT.PACTransferMeans","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
