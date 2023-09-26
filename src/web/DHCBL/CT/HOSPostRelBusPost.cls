/// Function: 流程岗位与业务岗位关系
/// Table：CT_BDP_CT.HOS_ProcPostRelPost
/// CreateDate:2023-2-8
/// Creator:lujunwen
Class web.DHCBL.CT.HOSPostRelBusPost Extends %RegisteredObject
{

/// Creator:lujunwen
/// CreateDate:2022-11-10
/// Description：流程岗位与业务岗位查询
/// Table：CT_BDP_CT.HOS_ProcPostRelPost
/// input id procpostcode(流程岗位代码) postcode(业务岗位代码)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostRelBusPost","GetList","","","") 
Query GetList(id As %String, procpostcode As %String, postcode As %String) As %Query(ROWSPEC = "ID:%String,PPRPProcPostCode:%String,PPRPPostCode:%String,PPRPActivity:%String,PPRPStartDate:%Date,PPRPEndDate:%Date,PPRPSeqNo:%Float,PPRPPYCode:%String,PPRPWBCode:%String,PPRPMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, procpostcode As %String, postcode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
  	/*s AuStr=##class(web.DHCBL.Authorize.HOSPostRelBusPost).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1

	s ProcAuStr=##class(web.DHCBL.Authorize.HOSProcPost).DHCGetDataByDefaultSession()
	s ProcAuFlag=0	
	if (ProcAuStr="")||(ProcAuStr["limited:0") s ProcAuFlag=1
	
	s PostAuStr=##class(web.DHCBL.Authorize.HOSPost).DHCGetDataByDefaultSession()
	s PostAuFlag=0	
	if (PostAuStr="")||(PostAuStr["limited:0") s PostAuFlag=1*/
		 
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),2) ///流程岗位代码指针
	    s:PPRPProcPostCode'="" PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostD(PPRPProcPostCode)),3) ///流程岗位代码描述
	    s PPRPPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),3) ///业务岗位代码指针
	    s:PPRPPostCode'="" PPRPPostCode=$lg($g(^CT.BDP.CT.HOSPostD(PPRPPostCode)),3) ///业务岗位代码描述 	    
		s PPRPActivity=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),4) ///是否有效
		s PPRPStartDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),5) ///开始日期
		s PPRPEndDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),6) //结束日期
	    s:PPRPStartDate'="" PPRPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPRPStartDate) ///转日期格式
	    s:PPRPEndDate'="" PPRPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPRPEndDate)	///转日期格式
		s PPRPSeqNo=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),10) ///系统排序号	
		s PPRPPYCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),14) ///拼音码
		s PPRPWBCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),15) ///五笔码
		s PPRPMark=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),16) ///备注
	    d OutputRow
	}
	else
	{
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProcPostRelPostD(ID)) q:ID=""  ///RowID
			//s strRowId = "{ID:"_ID_"}"
 		    s PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),2) ///流程岗位代码指针	    
            //s ProcstrRowId = "{ID:"_PPRPProcPostCode_"}"
		    s PPRPPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),3) ///业务岗位代码指针            
            //s PoststrRowId = "{ID:"_PPRPPostCode_"}"			
			//i ((AuStr[strRowId)||(AuFlag=1))&&((ProcAuStr[ProcstrRowId)||(ProcAuFlag=1))&&((PostAuStr[PoststrRowId)||(PostAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
			        	    
				s PPRPActivity=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),4) ///是否有效
				s PPRPStartDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),5) ///开始日期
				s PPRPEndDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),6) //结束日期
			    s:PPRPStartDate'="" PPRPStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPRPStartDate) ///转日期格式
			    s:PPRPEndDate'="" PPRPEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(PPRPEndDate)	///转日期格式
				s PPRPSeqNo=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),10) ///系统排序号	
				s PPRPPYCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),14) ///拼音码
				s PPRPWBCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),15) ///五笔码
				s PPRPMark=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),16) ///备注
		    	if (((procpostcode="")||(procpostcode=PPRPProcPostCode))&((postcode="")||(postcode=PPRPPostCode)))
		    	{
			    	s:PPRPProcPostCode'="" PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostD(PPRPProcPostCode)),3) ///流程岗位代码描述
			    	s:PPRPPostCode'="" PPRPPostCode=$lg($g(^CT.BDP.CT.HOSPostD(PPRPPostCode)),3) ///业务岗位代码描述
		            d OutputRow
		    	} 
			//}
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,PPRPProcPostCode,PPRPPostCode,PPRPActivity,PPRPStartDate,PPRPEndDate,PPRPSeqNo,PPRPPYCode,PPRPWBCode,PPRPMark)
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

/// Creator:lujunwen
/// CreateDate:2022-11-18
/// Description：流程岗位与业务岗位查询
/// Table：CT_BDP_CT.HOS_ProcPostRelPost
/// input id procpostcode(流程岗位代码) postcode(业务岗位代码)
/// debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOccuSubCate","GetDataForCmb1","1","","") 
Query GetDataForCmb1(id As %String) As %Query(ROWSPEC = "ID:%String,OCCUSCCode:%String,OCCUSCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1	  
	if (id'="") //根据rowid返回该条记录
	{
		
		s ID=id
	    s PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),2) ///流程岗位代码指针
	    s:PPRPProcPostCode'="" PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostD(PPRPProcPostCode)),3) ///流程岗位代码描述
	    s PPRPPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),3) ///业务岗位代码指针
	    s:PPRPPostCode'="" PPRPPostCode=$lg($g(^CT.BDP.CT.HOSPostD(PPRPPostCode)),3) ///业务岗位代码描述 	    
		s PPRPActivity=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),4) ///是否有效
		s PPRPStartDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),5) ///开始日期
		s PPRPEndDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),6) //结束日期

	    d OutputRowCmb
	}
	else
	{

    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSProcPostRelPostD(ID)) q:ID=""  ///RowID
			s strRowId = "{ID:"_ID_"}"	
		    s PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),2) ///流程岗位代码指针
			s ProcstrRowId = "{ID:"_PPRPProcPostCode_"}"		    
		    s PPRPPostCode=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),3) ///业务岗位代码指针
			s PoststrRowId = "{ID:"_PPRPPostCode_"}"			    		    
			    s:PPRPProcPostCode'="" PPRPProcPostCode=$lg($g(^CT.BDP.CT.HOSProcPostD(PPRPProcPostCode)),3) ///流程岗位代码描述
			    s:PPRPPostCode'="" PPRPPostCode=$lg($g(^CT.BDP.CT.HOSPostD(PPRPPostCode)),3) ///业务岗位代码描述 	    
				s PPRPActivity=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),4) ///是否有效
				continue:PPRPActivity="N"
				s PPRPStartDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),5) ///开始日期
				continue:(PPRPStartDate'="")&&(PPRPStartDate>+$h)
				s PPRPEndDate=$lg($g(^CT.BDP.CT.HOSProcPostRelPostD(ID)),6) //结束日期		
				continue:(PPRPEndDate'="")&&(PPRPEndDate<+$h)			
		        	d OutputRowCmb

		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,OCCUSCCode,OCCUSCDesc)
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

/// Creator:鲁俊文
/// CreatDate:  2022-10-18
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSPostRelBusPost).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSProcPostRelPost).%New()
    s obj = ##class(CT.BDP.CT.HOSProcPostRelPost).%OpenId(id)
    s eobj.ID=id ///RowId
	if $IsObject(obj.PPRPProcPostCode)
	{
		s eobj.PPRPProcPostCode = obj.PPRPProcPostCode.%Id()   //流程岗位代码
	}
	if $IsObject(obj.PPRPPostCode)
	{
		s eobj.PPRPPostCode = obj.PPRPPostCode.%Id()   //业务岗位代码
	}
		
    s eobj.PPRPActivity=obj.PPRPActivity  ///是否有效
    s eobj.PPRPStartDate=obj.PPRPStartDate  ///开始日期
    s eobj.PPRPEndDate=obj.PPRPEndDate  ///结束日期
    s:obj.PPRPStartDate'="" eobj.PPRPStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PPRPStartDate) ///开始日期(转格式)
    s:obj.PPRPEndDate'="" eobj.PPRPEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.PPRPEndDate) ///结束日期(转格式) 
    s eobj.PPRPPYCode=obj.PPRPPYCode  ///拼音码
    s eobj.PPRPWBCode=obj.PPRPWBCode ///五笔码
    s eobj.PPRPMark=obj.PPRPMark  ///备注   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-2-8
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_CountryLinkLan
/// Input：id procpostcode(流程岗位代码) postcode(业务岗位代码)
/// Others：w ##class(web.DHCBL.CT.HOSPostRelBusPost).FormValidate("","2","1")
ClassMethod FormValidate(id As %String, procpostcode As %String, postcode As %String) As %String
{
	s flag=0
	if (procpostcode'="")&&(postcode'="")
	{
		s ID=$o(^CT.BDP.CT.HOSProcPostRelPostI("IndexProcPostCode",procpostcode,postcode,0)) 	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2023-2-8
/// Description：保存流程岗位与业务岗位关系
/// Table：Table：CT_BDP_CT.HOS_ProcPostRelPost
/// Others：w ##class(web.DHCBL.CT.HOSPostRelBusPost).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSProcPostRelPost) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PPRPStartDate'="" eobj.PPRPStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PPRPStartDate)	//开始日期
	    s:eobj.PPRPEndDate'="" eobj.PPRPEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PPRPEndDate)	//结束日期
		s:eobj.PPRPStartDate="" eobj.PPRPStartDate=+$h
		s:eobj.PPRPActivity="" eobj.PPRPActivity="N"
		s eobj.PPRPLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.PPRPLastUpdateTime=$p($h,",",2) ///系统最后更新时间
	    s flag=..FormValidate(eobj.ID,eobj.PPRPProcPostCode,eobj.PPRPPostCode)
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID"))
			if (eobj.PPRPCreateUser="") s eobj.PPRPCreateUser=USERID   ///系统创建人
			if (eobj.PPRPLastUpdateUser="") s eobj.PPRPLastUpdateUser=USERID  ///系统最新更新人
		}
	    if (flag=1)
	    {
		    q "{success:'false',errorinfo:'该记录已经存在！'}" 
	    }   
	     
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSProcPostRelPost).%New()
			d obj.PPRPLastUpdateUserSetObjectId(eobj.PPRPLastUpdateUser)  ///系统创建人
			s obj.PPRPCreateDate=+$H           ///系统创建日期
			s obj.PPRPCreateTime=$p($h,",",2)  ///系统创建时间				
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSProcPostRelPost).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSProcPostRelPost).%New()
			if $IsObject(obj.PPRPProcPostCode){
			s bobj.PPRPProcPostCode = obj.PPRPProcPostCode.%Id()   //流程岗位
			}
			if $IsObject(obj.PPRPPostCode){
			s bobj.PPRPPostCode = obj.PPRPPostCode.%Id()   //业务岗位
			}			
			s bobj.PPRPActivity=obj.PPRPActivity ///是否有效	
			s bobj.PPRPStartDate=obj.PPRPStartDate ///开始日期
			s bobj.PPRPEndDate=obj.PPRPEndDate ///结束日期
			s bobj.PPRPCreateDate=obj.PPRPCreateDate ///系统创建日期
			s bobj.PPRPCreateTime=obj.PPRPCreateTime ///系统创建时间
			if $IsObject(obj.PPRPCreateUser)
			{   
				s bobj.PPRPCreateUser = obj.PPRPCreateUser.%Id()   ///系统创建人
			}
			s bobj.PPRPSeqNo=obj.PPRPSeqNo ///系统排序号
			
			s bobj.PPRPLastUpdateDate=obj.PPRPLastUpdateDate ///系统最后更新日期
			s bobj.PPRPLastUpdateTime=obj.PPRPLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.PPRPLastUpdateUser)
			{   
				s bobj.PPRPLastUpdateUser = obj.PPRPLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.PPRPPYCode=obj.PPRPPYCode ///拼音码
			s bobj.PPRPWBCode=obj.PPRPWBCode ///五笔码
			s bobj.PPRPMark=obj.PPRPMark ///备注
		}

		d obj.PPRPProcPostCodeSetObjectId(eobj.PPRPProcPostCode) ///流程岗位
		d obj.PPRPPostCodeSetObjectId(eobj.PPRPPostCode) ///业务岗位
		s obj.PPRPActivity=eobj.PPRPActivity	///是否有效
		s obj.PPRPStartDate= eobj.PPRPStartDate    ///开始日期
	    s obj.PPRPEndDate= eobj.PPRPEndDate 	///结束日期
		s obj.PPRPSeqNo=eobj.PPRPSeqNo ///系统排序号
		s obj.PPRPLastUpdateDate=eobj.PPRPLastUpdateDate ///系统最后更新日期
		s obj.PPRPLastUpdateTime=eobj.PPRPLastUpdateTime ///系统最后更新时间
		d obj.PPRPLastUpdateUserSetObjectId(eobj.PPRPLastUpdateUser)  ///系统最新更新人		
		s:eobj.PPRPPYCode="" eobj.PPRPPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE($lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPProcPostCode)),3),4) ///自动生成拼音码
		s obj.PPRPPYCode=eobj.PPRPPYCode ///拼音码
		s:eobj.PPRPWBCode="" eobj.PPRPWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE($lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPProcPostCode)),3),1) ///自动生成五笔码
		s obj.PPRPWBCode=eobj.PPRPWBCode ///五笔码
		s obj.PPRPMark=eobj.PPRPMark ///备注
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s Desc=$lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPProcPostCode)),3)_"-"_$lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPPostCode)),3)
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPostRelPost","CT.BDP.CT.HOSProcPostRelPost","流程岗位与业务岗位关系",eobj.ID,Desc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPostRelPost","CT.BDP.CT.HOSProcPostRelPost","流程岗位与业务岗位关系",id,Desc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程岗位与业务岗位关系","web.DHCBL.CT.HOSPostRelBusPost","DeleteData",eobj)
	    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)		
		}
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:鲁俊文
/// CreatDate:2022-10-12
/// Description：根据ID流程岗位与业务岗位的关系
/// Table：CT.BDP.CT.HOSProcPostRelPost
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPostRelBusPost).DeleteData("3")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s pobj = ##class(CT.BDP.CT.HOSProcPostRelPost).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSProcPostRelPost).%New()
	s eobj.ID = id ///RowId
	if $IsObject(pobj.PPRPProcPostCode){
		s eobj.PPRPProcPostCode = pobj.PPRPProcPostCode.%Id()   //流程岗位代码
	}
	if $IsObject(pobj.PPRPPostCode){
		s eobj.PPRPPostCode = pobj.PPRPPostCode.%Id()    //业务岗位代码
	}
	s eobj.PPRPActivity=pobj.PPRPActivity ///是否有效	
	s eobj.PPRPStartDate=pobj.PPRPStartDate ///开始日期
	s eobj.PPRPEndDate=pobj.PPRPEndDate ///结束日期
	s eobj.PPRPCreateDate=pobj.PPRPCreateDate ///系统创建日期
	s eobj.PPRPCreateTime=pobj.PPRPCreateTime ///系统创建时间
	if $IsObject(pobj.PPRPCreateUser)
	{   
		s eobj.PPRPCreateUser = pobj.PPRPCreateUser.%Id()   ///系统创建人
	}
	s eobj.PPRPSeqNo=pobj.PPRPSeqNo ///系统排序号
	s eobj.PPRPLastUpdateDate=pobj.PPRPLastUpdateDate ///系统最后更新日期
	s eobj.PPRPLastUpdateTime=pobj.PPRPLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.PPRPLastUpdateUser)
	{   
		s eobj.PPRPLastUpdateUser = pobj.PPRPLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.PPRPPYCode=pobj.PPRPPYCode ///拼音码
	s eobj.PPRPWBCode=pobj.PPRPWBCode ///五笔码
	s eobj.PPRPMark=pobj.PPRPMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSProcPostRelPost).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		s Desc=$lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPProcPostCode)),3)_"-"_$lg($g(^CT.BDP.CT.HOSPostD(eobj.PPRPPostCode)),3)  
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ProcPostRelPost","CT.BDP.CT.HOSProcPostRelPost","流程岗位与业务岗位关系",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("流程岗位与业务岗位关系","web.DHCBL.CT.HOSPostRelBusPost","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}
