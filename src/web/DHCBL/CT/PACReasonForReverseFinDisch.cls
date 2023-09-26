/// 名称:结算菜单 - 撤销最终结算原因
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-25
Class web.DHCBL.CT.PACReasonForReverseFinDisch Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:查询 撤销最终结算原因
/// Table:User.PACReasonForReverseFinDisch
/// Input:rowid,code,desc
/// Return:RFDRowId,RFDCode,RFDDesc,RFDCheckBed
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonForReverseFinDisch","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFDRowId:%String,RFDCode:%String,RFDDesc:%String,RFDCheckBed:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s RFDRowId=rowid
		s RFDCode=$p($g(^PAC("RFD",RFDRowId)),"^",1)
		s RFDDesc=$p($g(^PAC("RFD",RFDRowId)),"^",2)
		s RFDCheckBed=$p($g(^PAC("RFD",RFDRowId)),"^",3)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReasonForReverseFinDisch",RFDRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.PACReasonForReverseFinDisch).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RFDRowId=0
		for
		{	
			s RFDRowId=$o(^PAC("RFD",RFDRowId)) q:RFDRowId=""
			s strRowId="{ID:"_RFDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RFDCode=$p($g(^PAC("RFD",RFDRowId)),"^",1)
				s RFDDesc=$p($g(^PAC("RFD",RFDRowId)),"^",2)
				s RFDCode1=$ZCONVERT(RFDCode,"U")
				s RFDDesc1=$ZCONVERT(RFDDesc,"U")
				s RFDCheckBed=$p($g(^PAC("RFD",RFDRowId)),"^",3)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_ReasonForReverseFinDisch",RFDRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_ReasonForReverseFinDisch",RFDRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(RFDDesc1)
				i (RFDCode1[code)&((RFDDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReasonForReverseFinDisch",RFDRowId,RFDDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(RFDCode,"U")[code) &(AliasFlag=1)						
		        {
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RFDRowId,RFDCode,RFDDesc,RFDCheckBed,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.PACReasonForReverseFinDisch
/// Input:code,desc
/// Return:RFDRowId,RFDCode,RFDDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACReasonForReverseFinDisch","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RFDRowId:%String,RFDCode:%String,RFDDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s RFDRowId=rowid
		s RFDCode=$p($g(^PAC("RFD",RFDRowId)),"^",1)
		s RFDDesc=$p($g(^PAC("RFD",RFDRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.PACReasonForReverseFinDisch).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s RFDRowId=0
		for
		{	
			s RFDRowId=$o(^PAC("RFD",RFDRowId)) q:RFDRowId=""
			s strRowId="{ID:"_RFDRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s RFDCode=$p($g(^PAC("RFD",RFDRowId)),"^",1)
				s RFDDesc=$p($g(^PAC("RFD",RFDRowId)),"^",2)
				s RFDCode1=$ZCONVERT(RFDCode,"U")
				s RFDDesc1=$ZCONVERT(RFDDesc,"U")
				
				//别名查询
				/*s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_ReasonForReverseFinDisch",RFDRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
					
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(RFDDesc1)
				i (RFDCode1[code)&((RFDDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_ReasonForReverseFinDisch",RFDRowId,RFDDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        }  
		        if ($ZCONVERT(RFDCode,"U")[code) &(AliasFlag=1)					
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RFDRowId,RFDCode,RFDDesc)
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
/// Table:User.PACReasonForReverseFinDisch
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACReasonForReverseFinDisch).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^PAC("RFD",0,"Code",code))
	s:desc'="" flagd=$d(^PAC("RFD",0,"Desc",desc))
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
		s:code'="" idc=$o(^PAC("RFD",0,"Code",code,0))
		s:desc'="" idd=$o(^PAC("RFD",0,"Desc",desc,0))
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
/// Table:User.PACReasonForReverseFinDisch
/// Input:id
/// Return:Json格式的字符串str={list:[RFDCode,RFDDesc,RFDCheckBed,RFDDateActiveFrom,RFDDateActiveTo,RFDRowId]}
/// Other:d ##class(web.DHCBL.CT.PACReasonForReverseFinDisch).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""
	s pobj = ##class(User.PACReasonForReverseFinDisch).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACReasonForReverseFinDisch).%New()
	s eobj.RFDRowId = id
	s eobj.RFDCode = pobj.RFDCode
	s eobj.RFDDesc = pobj.RFDDesc
	//s eobj.RFDCheckBed = pobj.RFDCheckBed  //radio
	s:pobj.RFDCheckBed="Y" eobj.RFDCheckBed="true" // checkox
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:增加/修改撤销最终结算原因的内容
/// Table:User.PACReasonForReverseFinDisch
/// Input:web.Entity.CT.PACReasonForReverseFinDisch
/// Return:成功返回success:'true'和新增或修改的数据的RFDRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACReasonForReverseFinDisch) As %String
{
    new (eobj,%session)
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.RFDCheckBed="" eobj.RFDCheckBed="N" //checkbox
		//前台js已添加空值判断、重复判断、开始日期是否小于结束日期
		
		if (eobj.RFDRowId="")       
		{
			s obj=##class(User.PACReasonForReverseFinDisch).%New()
		}
		else                           
		{
			s obj=##class(User.PACReasonForReverseFinDisch).%OpenId(eobj.RFDRowId)
			s bobj = ##class(web.Entity.CT.PACReasonForReverseFinDisch).%New()
			s bobj.RFDRowId = eobj.RFDRowId
			s bobj.RFDCode = obj.RFDCode
			s bobj.RFDDesc = obj.RFDDesc
			s bobj.RFDCheckBed = obj.RFDCheckBed
		}
		s obj.RFDCode = eobj.RFDCode
		s obj.RFDDesc = eobj.RFDDesc
		s obj.RFDCheckBed = eobj.RFDCheckBed
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RFDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForReverseFinDisch","User.PACReasonForReverseFinDisch","撤销最终结算原因",id,eobj.RFDDesc,"A",eobj)
			d:eobj.RFDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForReverseFinDisch","User.PACReasonForReverseFinDisch","撤销最终结算原因",id,eobj.RFDDesc,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("撤销最终结算原因","web.DHCBL.CT.PACReasonForReverseFinDisch","SaveEntity",eobj)
	     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("撤销最终结算原因","web.DHCBL.CT.PACReasonForReverseFinDisch","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2014-6-25
/// Description:根据id删除 撤销最终结算原因
/// Table:User.PACReasonForReverseFinDisch
/// Input:id(PACReasonForReverseFinDisch的RFDRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.PACReasonForReverseFinDisch).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	
	s pobj = ##class(User.PACReasonForReverseFinDisch).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACReasonForReverseFinDisch).%New()
	s eobj.RFDRowId = id
	s eobj.RFDCode = pobj.RFDCode
	s eobj.RFDDesc = pobj.RFDDesc
	s eobj.RFDCheckBed = pobj.RFDCheckBed
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.PACReasonForReverseFinDisch).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_ReasonForReverseFinDisch","User.PACReasonForReverseFinDisch","撤销最终结算原因",id,eobj.RFDDesc,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("撤销最终结算原因","web.DHCBL.CT.PACReasonForReverseFinDisch","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	
	q result
}

}
