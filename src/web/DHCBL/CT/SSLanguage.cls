/// 名称:系统配置 - 3 登录语言
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2013-7-3
Class web.DHCBL.CT.SSLanguage Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-7-3
/// Description:查询 登录语言	
/// Table:User.SSLanguage
/// Input:rowid,code,desc
/// Return:CTLANRowId,CTLANCode,CTLANDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSLanguage","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTLANRowId:%String,CTLANCode:%String,CTLANDesc:%String,CTLANActivity:%String,CTLANStartDate:%String,CTLANEndDate:%String,CTLANSeqNo:%String,CTLANPYCode:%String,CTLANWBCode:%String,CTLANMark:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CTLANRowId=rowid
		s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1) //代码
		s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2) //描述
		s CTLANActivity=$p($g(^SS("LAN",CTLANRowId)),"^",3) //是否有效
		s:CTLANActivity="" CTLANActivity="Y"
		s CTLANStartDate=$p($g(^SS("LAN",CTLANRowId)),"^",4) //开始日期
		s CTLANEndDate=$p($g(^SS("LAN",CTLANRowId)),"^",5) //结束日期
	    s:CTLANStartDate'="" CTLANStartDate=$zd(CTLANStartDate,1)  
        s:CTLANEndDate'="" CTLANEndDate=$zd(CTLANEndDate,1)
		s CTLANSeqNo=$p($g(^SS("LAN",CTLANRowId)),"^",9) //排序号
		s CTLANPYCode=$p($g(^SS("LAN",CTLANRowId)),"^",13) //拼音码
		s CTLANWBCode=$p($g(^SS("LAN",CTLANRowId)),"^",14) //五笔码
		s CTLANMark=$p($g(^SS("LAN",CTLANRowId)),"^",15) //备注		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_Language",CTLANRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTLANRowId=0
		for
		{
			s CTLANRowId=$o(^SS("LAN",CTLANRowId)) q:CTLANRowId=""
			s strRowId="{ID:"_CTLANRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1) //代码
				s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2) //描述
				s CTLANActivity=$p($g(^SS("LAN",CTLANRowId)),"^",3) //是否有效
				s:CTLANActivity="" CTLANActivity="Y"
				s CTLANStartDate=$p($g(^SS("LAN",CTLANRowId)),"^",4) //开始日期
				s CTLANEndDate=$p($g(^SS("LAN",CTLANRowId)),"^",5) //结束日期
			    s:CTLANStartDate'="" CTLANStartDate=$zd(CTLANStartDate,1)  
		        s:CTLANEndDate'="" CTLANEndDate=$zd(CTLANEndDate,1)				
				s CTLANSeqNo=$p($g(^SS("LAN",CTLANRowId)),"^",9) //排序号
				s CTLANPYCode=$p($g(^SS("LAN",CTLANRowId)),"^",13) //拼音码
				s CTLANWBCode=$p($g(^SS("LAN",CTLANRowId)),"^",14) //五笔码
				s CTLANMark=$p($g(^SS("LAN",CTLANRowId)),"^",15) //备注	
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("SS_Language",CTLANRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_Language",CTLANRowId,CTLANDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($zcvt(CTLANCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLANRowId,CTLANCode,CTLANDesc ,CTLANActivity,CTLANStartDate,CTLANEndDate,CTLANSeqNo,CTLANPYCode,CTLANWBCode,CTLANMarkBDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2013-7-3
/// Description:查询 登录语言	
/// Table:User.SSLanguage
/// Input:code,desc
/// Return:CTLANRowId,CTLANCode,CTLANDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSLanguage","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTLANRowId:%String,CTLANCode:%String,CTLANDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s CTLANRowId=rowid
		s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1)
		s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr=##class(web.DHCBL.Authorize.SSLanguage).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s CTLANRowId=0
		for
		{
			s CTLANRowId=$o(^SS("LAN",CTLANRowId)) q:CTLANRowId=""
			s CTLANActivity=$p($g(^SS("LAN",CTLANRowId)),"^",3) //是否有效
			continue:CTLANActivity="N"
			s CTLANStartDate=$p($g(^SS("LAN",CTLANRowId)),"^",4) //开始日期
			continue:(CTLANStartDate'="")&&(CTLANStartDate>+$h)
			s CTLANEndDate=$p($g(^SS("LAN",CTLANRowId)),"^",5) //结束日期
			continue:(CTLANEndDate'="")&&(CTLANEndDate<+$h) 
			s strRowId="{ID:"_CTLANRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s CTLANCode=$p($g(^SS("LAN",CTLANRowId)),"^",1)
				s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("SS_Language",CTLANRowId,CTLANDesc,desc)
				}
				else
				{
					s AliasFlag=1
				}
				i ($zcvt(CTLANCode,"U")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTLANRowId,CTLANCode,CTLANDesc)
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
/// CreatDate:2013-7-3  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.SSLanguage
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.SSLanguage).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	new (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^SS("LAN",0,"Code",code))
	s:desc'="" flagd=$d(^SS("LAN",0,"Desc",desc))
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
		s:code'="" idc=$o(^SS("LAN",0,"Code",code,0))
		s:desc'="" idd=$o(^SS("LAN",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
			
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2013-7-3
/// Description:双击修改时从后台取数据
/// Table:User.SSLanguage
/// Input:id
/// Return:Json格式的字符串str={list:[CTLANCode,CTLANDesc,CTLANRowId]}
/// Other:d ##class(web.DHCBL.CT.SSLanguage).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.SSLanguage).%New()	
	s obj = ##class(User.SSLanguage).%OpenId(id)
	s eobj.CTLANRowId = id
	s eobj.CTLANCode = obj.CTLANCode //代码
	s eobj.CTLANDesc = obj.CTLANDesc //描述
	s eobj.CTLANActivity=obj.CTLANActivity //是否有效
	s eobj.CTLANActivity=obj.CTLANActivity
	s:eobj.CTLANActivity="" eobj.CTLANActivity="Y"
	s:eobj.CTLANActivity="Y" eobj.CTLANActivity="true"	
	s eobj.CTLANStartDate=obj.CTLANStartDate //开始日期
	s eobj.CTLANEndDate=obj.CTLANEndDate //结束日期
	s eobj.CTLANSeqNo=obj.CTLANSeqNo //排序号
	s eobj.CTLANPYCode=obj.CTLANPYCode //拼音码
	s eobj.CTLANWBCode=obj.CTLANWBCode //五笔码
	s eobj.CTLANMark=obj.CTLANMark	 //备注
    s:eobj.CTLANStartDate'="" eobj.CTLANStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTLANStartDate) //转换日期格式
    s:eobj.CTLANEndDate'="" eobj.CTLANEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.CTLANEndDate)       //转换日期格式	
	s str = eobj.JsonS()
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2013-7-3
/// Description:增加/修改 登录语言
/// Table:User.SSLanguage
/// Input:web.Entity.CT.SSLanguage 实体类
/// Return:成功返回success:'true'和新增或修改的数据的CTLANRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.SSLanguage) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CTLANStartDate'="" eobj.CTLANStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLANStartDate)  //转换日期
		s:eobj.CTLANEndDate'="" eobj.CTLANEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLANEndDate)      //转换日期
		s:eobj.CTLANStartDate="" eobj.CTLANStartDate=+$h
		s:eobj.CTLANActivity="" eobj.CTLANActivity="N"
		s eobj.CTLANLastUpdateDate=$p($h,",",1) ///系统最后更新日期
  		s eobj.CTLANLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		//前台js已添加CTLANDesc空值判断、重复判断
		if $d(%session)
		{
		s USERID=$g(%session.Data("LOGON.USERID"))
		if (eobj.CTLANCreateUser="") s eobj.CTLANCreateUser=USERID   ///系统创建人
		if (eobj.CTLANLastUpdateUser="") s eobj.CTLANLastUpdateUser=USERID  ///系统最新更新人
		}  		
		s flag=..FormValidate(eobj.CTLANRowId,eobj.CTLANCode,eobj.CTLANDesc)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.CTLANRowId="")       
		{
			s obj=##class(User.SSLanguage).%New()
		    d obj.CTLANCreateUserSetObjectId(eobj.CTLANCreateUser)  ///系统创建人
			s obj.CTLANCreateDate=+$H           ///系统创建日期
			s obj.CTLANCreateTime=$p($h,",",2)  ///系统创建时间			
		}
		else                           
		{
			s obj=##class(User.SSLanguage).%OpenId(eobj.CTLANRowId)
			s bobj = ##class(web.Entity.CT.SSLanguage).%New()
			s bobj.CTLANRowId = eobj.CTLANRowId
			s bobj.CTLANCode = obj.CTLANCode
			s bobj.CTLANDesc = obj.CTLANDesc
		    s bobj.CTLANStartDate = obj.CTLANStartDate  
		    s bobj.CTLANEndDate = obj.CTLANEndDate
		    
			s bobj.CTLANCreateDate=obj.CTLANCreateDate ///系统创建日期
			s bobj.CTLANCreateTime=obj.CTLANCreateTime ///系统创建时间
			if $IsObject(obj.CTLANCreateUser)
			{   
				s bobj.CTLANCreateUser = obj.CTLANCreateUser.%Id()   ///系统创建人
			}
			s bobj.CTLANSeqNo=obj.CTLANSeqNo ///系统排序号
			
			s bobj.CTLANLastUpdateDate=obj.CTLANLastUpdateDate ///系统最后更新日期
			s bobj.CTLANLastUpdateTime=obj.CTLANLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.CTLANLastUpdateUser)
			{   
				s bobj.CTLANLastUpdateUser = obj.CTLANLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.CTLANPYCode=obj.CTLANPYCode ///拼音码
			s bobj.CTLANWBCode=obj.CTLANWBCode ///五笔码
			s bobj.CTLANMark=obj.CTLANMark ///备注			
					
		}
		s obj.CTLANCode = eobj.CTLANCode
		s obj.CTLANDesc = eobj.CTLANDesc
	   s obj.CTLANStartDate = eobj.CTLANStartDate  //修改开始日期
	   s obj.CTLANEndDate = eobj.CTLANEndDate      //修改结束日期
	   s obj.CTLANActivity=eobj.CTLANActivity		  ///是否有效

	   s obj.CTLANSeqNo=eobj.CTLANSeqNo ///系统排序号
	   s obj.CTLANLastUpdateDate=eobj.CTLANLastUpdateDate ///系统最后更新日期
	   s obj.CTLANLastUpdateDate=eobj.CTLANLastUpdateDate ///系统最后更新时间
	   d obj.CTLANLastUpdateUserSetObjectId(eobj.CTLANLastUpdateUser)  ///系统最新更新人
	   s:eobj.CTLANPYCode="" eobj.CTLANPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.CTLANDesc,4) ///自动生成拼音码
	   s obj.CTLANPYCode=eobj.CTLANPYCode ///拼音码
	   s:eobj.CTLANWBCode="" eobj.CTLANWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTLANDesc,1) ///自动生成五笔码
	   s obj.CTLANWBCode=eobj.CTLANWBCode ///五笔码
	   s obj.CTLANMark=eobj.CTLANMark ///备注		
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CTLANRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Language","User.SSLanguage","登录语言",id,eobj.CTLANDesc,"A",eobj)
			d:eobj.CTLANRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Language","User.SSLanguage","登录语言",id,eobj.CTLANDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("登录语言","web.DHCBL.CT.SSLanguage","SaveEntity",eobj)
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
	s SSUSRRowId=0,flag=0
	for
	{
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:(SSUSRRowId="")||(flag=1)  d
		s SSUSRCTLANDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",13)
		i SSUSRCTLANDR=id
		{
			s flag=1
			s myInfo=myInfo_"<用户表>"
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:陈莹
/// CreatDate:2013-7-3
/// Description:根据id删除 登录语言
/// Table:User.SSLanguage
/// Input:id(SSLanguage的CTLANRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.SSLanguage).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.SSLanguage).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){	
		s pobj = ##class(User.SSLanguage).%OpenId(id)
		s eobj = ##class(web.Entity.CT.SSLanguage).%New()
		s eobj.CTLANRowId = id
		s eobj.CTLANCode = pobj.CTLANCode
		s eobj.CTLANDesc = pobj.CTLANDesc
		s eobj.CTLANStartDate=pobj.CTLANStartDate //开始日期
		s eobj.CTLANEndDate=pobj.CTLANEndDate //结束日期
		s eobj.CTLANActivity=pobj.CTLANActivity //是否有效
		 
		s eobj.CTLANCreateDate=pobj.CTLANCreateDate ///系统创建日期
		s eobj.CTLANCreateTime=pobj.CTLANCreateTime ///系统创建时间
		if $IsObject(pobj.CTLANCreateUser)
		{   
		s eobj.CTLANCreateUser = pobj.CTLANCreateUser.%Id()   ///系统创建人
		}
		 
		s eobj.CTLANSeqNo=pobj.CTLANSeqNo  //系统排序号
		s eobj.CTLANLastUpdateDate=pobj.CTLANLastUpdateDate ///系统最后更新日期
		s eobj.CTLANLastUpdateTime=pobj.CTLANLastUpdateTime ///系统最后更新时间 
		if $IsObject(pobj.CTLANLastUpdateUser)
		{   
		s eobj.CTLANLastUpdateUser = pobj.CTLANLastUpdateUser.%Id()   ///系统最新更新人
		}
		s eobj.CTLANPYCode=pobj.CTLANPYCode //拼音码
		s eobj.CTLANWBCode=pobj.CTLANWBCode //五笔码
		s eobj.CTLANMark=pobj.CTLANMark //备注		
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.SSLanguage).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_Language","User.SSLanguage","登录语言",id,eobj.CTLANDesc,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("登录语言","web.DHCBL.CT.SSLanguage","DeleteData",eobj)
		   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	
	q result
}

/// Function:获取默认值Chinese
/// Others:w ##class(web.DHCBL.CT.SSLanguage).GetDefault()
ClassMethod GetDefault() As %String
{
	s RowId=""
	s CTLANRowId=0
	for
	{
		s CTLANRowId=$o(^SS("LAN",CTLANRowId)) q:CTLANRowId=""
		s CTLANDesc=$p($g(^SS("LAN",CTLANRowId)),"^",2)
		if (CTLANDesc="Chinese") s RowId = CTLANRowId
	}
	q RowId
}

}
