Import SQLUser

/// 名称:医护人员维护 - 2 医生专长维护
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 蔡昊哲
/// 编写日期:2012-9-10
Class web.DHCBL.CT.CTSpec Extends %RegisteredObject
{

/// Creator:蔡昊哲
/// CreatDate:2013-5-14
/// Description:双击修改时,从后台取数据
/// Table:User.CTSpec
/// Input:id
/// Return:Json格式的字符串str={list:[CTSPCCode,CTSPCDesc,CTSPCRowId,CTSPCDateFrom,CTSPCDateTo]}
/// Other:w ##class(web.DHCBL.CT.CTSpec).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTSpec).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTSpec).%New()
	s eobj.CTSPCRowId = id
	s eobj.CTSPCCode = pobj.CTSPCCode
	s eobj.CTSPCDesc = pobj.CTSPCDesc
	;s:pobj.CTSPCDateFrom'="" eobj.CTSPCDateFrom=$zd(pobj.CTSPCDateFrom,1)
	;s:pobj.CTSPCDateTo'="" eobj.CTSPCDateTo=$zd(pobj.CTSPCDateTo,1)
	s:pobj.CTSPCDateFrom'="" eobj.CTSPCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTSPCDateFrom)
	s:pobj.CTSPCDateTo'="" eobj.CTSPCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTSPCDateTo)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2012-12-27    
/// w ##class(web.DHCBL.CT.CTSpec).Validate("58","mxb","慢性病")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^CT("SPC",0,"Code",code))
	s:desc'="" flagd=$d(^CT("SPC",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT("SPC",0,"Code",code,0))
		s:desc'="" idd=$o(^CT("SPC",0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-27
/// Description：保存修改
ClassMethod SaveEntity(eobj As web.Entity.CT.CTSpec) As %String
{
	;s $zt="EEROE"
	
	s result=""
	;s flag=0
    s flag=..Validate(eobj.CTSPCRowId,eobj.CTSPCCode,eobj.CTSPCDesc)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		Ts
		s:eobj.CTSPCDateFrom="" eobj.CTSPCDateFrom=+$h
		//增加
		if (eobj.CTSPCRowId="")
		{	
			s obj=##class(User.CTSpec).%New()
		}
		//修改
		else 
		{
	    	s obj=##class(User.CTSpec).%OpenId(eobj.CTSPCRowId)
	    	
	    	; bobj创建一个对象，用于记录原始数据
			s bobj=##class(web.Entity.CT.CTSpec).%New()
			s bobj.CTSPCRowId = eobj.CTSPCRowId
			s bobj.CTSPCCode=obj.CTSPCCode
			s bobj.CTSPCDesc=obj.CTSPCDesc
			s bobj.CTSPCDateFrom=obj.CTSPCDateFrom
			s bobj.CTSPCDateTo=obj.CTSPCDateTo
		}
		
		
		s obj.CTSPCCode=eobj.CTSPCCode
		s obj.CTSPCDesc=eobj.CTSPCDesc
		;s:eobj.CTSPCDateFrom'="" eobj.CTSPCDateFrom=$zdh(eobj.CTSPCDateFrom,15)
		;s:eobj.CTSPCDateTo'="" eobj.CTSPCDateTo=$zdh(eobj.CTSPCDateTo,15)
		s:eobj.CTSPCDateFrom'="" eobj.CTSPCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTSPCDateFrom)
		s:eobj.CTSPCDateTo'="" eobj.CTSPCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTSPCDateTo)
		s obj.CTSPCDateFrom=eobj.CTSPCDateFrom
		s obj.CTSPCDateTo=eobj.CTSPCDateTo
		
		
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"         //返回RowId
			if (eobj.CTSPCRowId'="")
			{
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Spec","User.CTSpec","医生专长",id,eobj.CTSPCDesc,"U",eobj,bobj)
			}
			else
			{
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Spec","User.CTSpec","医生专长",id,eobj.CTSPCDesc,"A",eobj)
			}
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医生专长","web.DHCBL.CT.CTSpec","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}	
	}
	q result
	;EEROE
	;q "{success:'false',info:'error'}"
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="0^未被引用可删除！"
    
    s CTPCPRowId1=0
	f  s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""  d
	.s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
	.i CTPCPSpecDR=id s return="1^在医护人员里被引用,不能删除！"   ; CTCareProv
    		
	q return
}

ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.CTSpec).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.CT.CTSpec).%New()
		s pobj = ##class(User.CTSpec).%OpenId(id)	
		s eobj.CTSPCRowId = id
		s eobj.CTSPCCode = pobj.CTSPCCode
		s eobj.CTSPCDesc = pobj.CTSPCDesc
		s sc = ##class(User.CTSpec).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result= ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Spec","User.CTSpec","医生专长",eobj.CTSPCRowId,eobj.CTSPCDesc,"D",eobj)
			s result = "{success:'true',info:'删除成功！'}"	
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医生专长","web.DHCBL.CT.CTSpec","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：蔡昊哲
/// CreatDate: 2013-2-22
/// Description：查询医生专长的内容
/// Table：User.CTSpec
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpec","GetList","","","")
Query GetList(rowid, Code, Desc, query) As %Query(ROWSPEC = "CTSPCRowId,CTSPCCode,CTSPCDesc,CTSPCDateFrom,CTSPCDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, Code, Desc, query) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	s Code=$ZCONVERT(Code,"U")
	s Desc=$ZCONVERT(Desc,"U")

	;假设未授权情况下默认全部显示数据
	
	
	;这地方加个方法---获取该角色的授权标志（是否受限），其他都不用改。
	s AuStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTSPCRowId=rowid
		s CTSPCCode=$p($g(^CT("SPC",CTSPCRowId)),"^",1)
		s CTSPCDesc=$p($g(^CT("SPC",CTSPCRowId)),"^",2)
		s CTSPCDateFrom=$p($g(^CT("SPC",CTSPCRowId)),"^",3)
		s CTSPCDateTo=$p($g(^CT("SPC",CTSPCRowId)),"^",4)
		s:CTSPCDateTo'="" CTSPCDateTo=$zd(CTSPCDateTo,1) //转换日期格式
		s:CTSPCDateFrom'="" CTSPCDateFrom=$zd(CTSPCDateFrom,1) //转换日期格式
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Spec",CTSPCRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s:Code'="" code=$$ALPHAUP^SSUTIL4(Code) //转换成大写
		s:Desc'="" desc=$$ALPHAUP^SSUTIL4(Desc) //转换成大写
		s:query'="" query=$ZCONVERT(query,"U")
		s CTSPCRowId=0	
		for  
		{	
			s CTSPCRowId=$o(^CT("SPC",CTSPCRowId)) q:CTSPCRowId=""
			s strRowId = "{ID:"_CTSPCRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTSPCCode=$p($g(^CT("SPC",CTSPCRowId)),"^",1)
				s CTSPCDesc=$p($g(^CT("SPC",CTSPCRowId)),"^",2)
				s CTSPCCode1=$ZCONVERT(CTSPCCode,"U")
				s CTSPCDesc1=$ZCONVERT(CTSPCDesc,"U")
				s CTSPCDateFrom=$p($g(^CT("SPC",CTSPCRowId)),"^",3)
				s CTSPCDateTo=$p($g(^CT("SPC",CTSPCRowId)),"^",4)
				s:CTSPCDateFrom'="" CTSPCDateFrom=$zd(CTSPCDateFrom,1) //转换日期格式
				s:CTSPCDateTo'="" CTSPCDateTo=$zd(CTSPCDateTo,1) //转换日期格式
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
	            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Spec",CTSPCRowId)
	            s BDPInternalCode =$p($g(resultStr),"^",1)       
	            s BDPInternalDesc = $p($g(resultStr),"^",2)  
	            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
	            s BDPHospNationalDesc = $p($g(resultStr),"^",4)
	            /*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Spec",CTSPCRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTSPCDesc1)
				*/
				if (Desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Spec",CTSPCRowId,CTSPCDesc,Desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (CTSPCCode1[Code)&(AliasFlag=1) &(CTSPCDesc1[query)
				/*((CTSPCDesc1[Desc)||(PINYIN[Desc)||(ALIASText1[Desc))*/
				{
					d OutputRow
				}
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTSPCRowId,CTSPCCode,CTSPCDesc,CTSPCDateFrom,CTSPCDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：蔡昊哲
/// CreatDate: 2013-2-22
/// Description：查询医生专长的内容
/// Table：User.CTSpec
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpec","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid, Code, Desc, query) As %Query(ROWSPEC = "CTSPCRowId,CTSPCCode,CTSPCDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid, Code, Desc, query) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	s Code=$ZCONVERT(Code,"U")
	s Desc=$ZCONVERT(Desc,"U")

	;假设未授权情况下默认全部显示数据
	
	
	;这地方加个方法---获取该角色的授权标志（是否受限），其他都不用改。
	s AuStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTSPCRowId=rowid
		s CTSPCCode=$p($g(^CT("SPC",CTSPCRowId)),"^",1)
		s CTSPCDesc=$p($g(^CT("SPC",CTSPCRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:Code'="" code=$$ALPHAUP^SSUTIL4(Code) //转换成大写
		s:Desc'="" desc=$$ALPHAUP^SSUTIL4(Desc) //转换成大写
		s:query'="" query=$ZCONVERT(query,"U")
		s CTSPCRowId=0	
		for  
		{	
			s CTSPCRowId=$o(^CT("SPC",CTSPCRowId)) q:CTSPCRowId=""
			s strRowId = "{ID:"_CTSPCRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTSPCCode=$p($g(^CT("SPC",CTSPCRowId)),"^",1)
				s CTSPCDesc=$p($g(^CT("SPC",CTSPCRowId)),"^",2)
				s CTSPCCode1=$ZCONVERT(CTSPCCode,"U")
				s CTSPCDesc1=$ZCONVERT(CTSPCDesc,"U")
				s CTSPCDateFrom=$p($g(^CT("SPC",CTSPCRowId)),"^",3)
				s CTSPCDateTo=$p($g(^CT("SPC",CTSPCRowId)),"^",4)
				continue:(CTSPCDateFrom'="")&&(CTSPCDateFrom>+$h)
				continue:(CTSPCDateTo'="")&&(CTSPCDateTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Spec",CTSPCRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTSPCDesc1)
				*/
				if (Desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Spec",CTSPCRowId,CTSPCDesc,Desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				
				i (CTSPCCode1[Code)&(AliasFlag=1)&(CTSPCDesc1[query)
				//((CTSPCDesc1[Desc)||(PINYIN[Desc)||(ALIASText1[Desc))
				{
					d OutputRowCmb
				}
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTSPCRowId,CTSPCCode,CTSPCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

}
