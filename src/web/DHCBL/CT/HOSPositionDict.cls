/// Function: 职位字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSPositionDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  职位字典信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_PositionDict   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPositionDict","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,POSCCode,POSCDesc,POSCActivity,POSCStartDate,POSCEndDate,POSCSeqNo,POSCPYCode,POSCWBCode,POSCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s POSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),2)	//职位字典代码
	    s POSCDesc= $lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),3)	//职位字典名称
		
		s POSCActivity=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),4) 	//是否有效(Y/N)
		s POSCStartDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),5)		//开始日期
		s:POSCStartDate'="" POSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSCStartDate) 
		s POSCEndDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),6) 		//结束日期
		s:POSCEndDate'="" POSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSCEndDate) 
		
		s POSCSeqNo=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),10) 		//系统排序号

		s POSCPYCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),14)  		//拼音码
		s POSCWBCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),15)  		//五笔码
		s POSCMark=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),16)  		//备注
        d OutputRow
    }
    else
    {
	    s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPositionDictD(ID))
            q:ID=""
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
	            s POSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),2)	//职位字典代码
			    s POSCDesc= $lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),3)	//职位字典名称
				
				s POSCActivity=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),4) 	//是否有效(Y/N)
				s POSCStartDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),5)		//开始日期
				s:POSCStartDate'="" POSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSCStartDate) 
				s POSCEndDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),6) 		//结束日期
				s:POSCEndDate'="" POSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSCEndDate) 
				
				s POSCSeqNo=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),10) 		//系统排序号

				s POSCPYCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),14)  		//拼音码
				s POSCWBCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),15)  		//五笔码
				s POSCMark=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),16)  		//备注
	            if (($zcvt(POSCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSCDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }
			}
        }
    }
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POSCCode,POSCDesc,POSCActivity,POSCStartDate,POSCEndDate,POSCSeqNo,POSCPYCode,POSCWBCode,POSCMark)
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

/// Function: combox查询提供接口 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Tables: CT_BDP_CT.HOS_PositionDict
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPositionDict", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSCCode,POSCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s POSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),2)	//职位字典代码
		s POSCDesc= $lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),3)	//职位字典名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSPositionDictD(ID))
       		q:ID=""
       		s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{  
	       		s POSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),2)	//职位字典代码
			    s POSCDesc= $lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),3)	//职位字典名称
		    	
		    	s POSCActivity=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),4) 	//是否有效(Y/N)
				continue:POSCActivity="N"
				s POSCStartDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),5)		//开始日期
				continue:(POSCStartDate'="")&&(POSCStartDate>+$h) 
				s POSCEndDate=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),6) 		//结束日期
				continue:(POSCEndDate'="")&&(POSCEndDate<+$h)
				s POSCPYCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(ID)),14)  		//拼音码
				 			
				if (($zcvt(POSCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSCDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	}
  	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSCCode,POSCDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
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
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function： 修改时打开的数据
/// Creator:   钟荣枫
/// CreatDate: 2020-07-08
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSPositionDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPositionDict).%New()
    s pobj = ##class(CT.BDP.CT.HOSPositionDict).%OpenId(id)
    s eobj.ID=id
			
    s eobj.POSCCode=pobj.POSCCode	//职位字典代码
    s eobj.POSCDesc= pobj.POSCDesc	//职位字典名称
 
	s eobj.POSCActivity=pobj.POSCActivity	//是否有效(Y/N)
	s eobj.POSCStartDate=pobj.POSCStartDate		//开始日期
	s:eobj.POSCStartDate'="" eobj.POSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSCStartDate) 
	s eobj.POSCEndDate=pobj.POSCEndDate		//结束日期
	s:eobj.POSCEndDate'="" eobj.POSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSCEndDate) 
	s eobj.POSCSeqNo=pobj.POSCSeqNo		//系统排序号
	
	s eobj.POSCPYCode=pobj.POSCPYCode		//拼音码
	s eobj.POSCWBCode=pobj.POSCWBCode		//五笔码
	s eobj.POSCMark=pobj.POSCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPositionDict
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPositionDict).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSPositionDictI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSPositionDictI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存职位字典内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPositionDict
/// Input：     web.Entity.CT.HOSPositionDict  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPositionDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPositionDict) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.POSCStartDate'="" eobj.POSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSCStartDate) 
    s:eobj.POSCEndDate'="" eobj.POSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSCEndDate)
    s:eobj.POSCStartDate="" eobj.POSCStartDate=+$h
    s:eobj.POSCLastUpdateDate="" eobj.POSCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.POSCLastUpdateTime="" eobj.POSCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.POSCLastUpdateUser="" eobj.POSCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.POSCActivity="" eobj.POSCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.POSCCode,eobj.POSCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPositionDict).%New()
            //s eobj.POSCSeqNo=..GetSeqNo()
            s:eobj.POSCCreateDate="" eobj.POSCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.POSCCreateTime="" eobj.POSCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.POSCCreateUser="" eobj.POSCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.POSCCreateDate=eobj.POSCCreateDate		//系统创建日期
			s obj.POSCCreateTime=eobj.POSCCreateTime		//系统创建时间
			d obj.POSCCreateUserSetObjectId(eobj.POSCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPositionDict).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPositionDict).%New()
            s bobj.ID=eobj.ID 
            s bobj.POSCCode=obj.POSCCode	//职位字典代码
            s bobj.POSCDesc= obj.POSCDesc	//职位字典名称
 
			s bobj.POSCActivity=obj.POSCActivity	//是否有效(Y/N)
			s bobj.POSCStartDate=obj.POSCStartDate		//开始日期
			s bobj.POSCEndDate=obj.POSCEndDate		//结束日期
			s bobj.POSCCreateDate=obj.POSCCreateDate		//系统创建日期
			s bobj.POSCCreateTime=obj.POSCCreateTime		//系统创建时间
			if $IsObject(obj.POSCCreateUser){
				s bobj.POSCCreateUser = obj.POSCCreateUser.%Id() 	//系统创建人
			}
			s bobj.POSCSeqNo=obj.POSCSeqNo		//系统排序号
			s bobj.POSCLastUpdateDate=obj.POSCLastUpdateDate		//系统最后更新日期
			s bobj.POSCLastUpdateTime=obj.POSCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.POSCLastUpdateUser){
				s bobj.POSCLastUpdateUser = obj.POSCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.POSCPYCode=obj.POSCPYCode		//拼音码
			s bobj.POSCWBCode=obj.POSCWBCode		//五笔码
			s bobj.POSCMark=obj.POSCMark		//备注

        }
        s obj.POSCCode=eobj.POSCCode	//职位字典代码
        s obj.POSCDesc= eobj.POSCDesc	//职位字典名称
		s obj.POSCActivity=eobj.POSCActivity	//是否有效(Y/N)
		s obj.POSCStartDate=eobj.POSCStartDate		//开始日期
		s obj.POSCEndDate=eobj.POSCEndDate		//结束日期
		s obj.POSCSeqNo=eobj.POSCSeqNo		//系统排序号
		s obj.POSCLastUpdateDate=eobj.POSCLastUpdateDate		//系统最后更新日期
		s obj.POSCLastUpdateTime=eobj.POSCLastUpdateTime		//系统最后更新时间
		d obj.POSCLastUpdateUserSetObjectId(eobj.POSCLastUpdateUser)	//系统最新更新人
		s:eobj.POSCPYCode="" eobj.POSCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.POSCDesc)
		s obj.POSCPYCode=eobj.POSCPYCode		//拼音码
		s:eobj.POSCWBCode="" eobj.POSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.POSCDesc,1)
		s obj.POSCWBCode=eobj.POSCWBCode		//五笔码
		s obj.POSCMark=eobj.POSCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PositionDict","CT.BDP.CT.HOSPositionDict","职位字典",id,eobj.POSCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PositionDict","CT.BDP.CT.HOSPositionDict","职位字典",eobj.ID,eobj.POSCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职位字典","web.DHCBL.CT.HOSPositionDict","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：删除限制
/// Table：CT.BDP.CT.HOSPost
/// Input：id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSPositionDict).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    if $d(^CT.BDP.CT.HOSEmpPostionI("IndexPOSCode",id)){
        s myInfo=myInfo_"<人员职位>"
    }
    
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除职位字典的内容
/// Table：CT.BDP.CT.HOSPositionDict
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPositionDict).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSPositionDict).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPositionDict).%New()
    s eobj.ID = id
    s eobj.POSCCode=pobj.POSCCode	//职位字典代码
    s eobj.POSCDesc= pobj.POSCDesc	//职位字典名称
 
	s eobj.POSCActivity=pobj.POSCActivity	//是否有效(Y/N)
	s eobj.POSCStartDate=pobj.POSCStartDate		//开始日期
	s eobj.POSCEndDate=pobj.POSCEndDate		//结束日期
	s eobj.POSCSeqNo=pobj.POSCSeqNo		//系统排序号
	
	s eobj.POSCPYCode=pobj.POSCPYCode		//拼音码
	s eobj.POSCWBCode=pobj.POSCWBCode		//五笔码
	s eobj.POSCMark=pobj.POSCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPositionDict).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PositionDict","CT.BDP.CT.HOSPositionDict","职位字典",id,eobj.POSCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职位字典","web.DHCBL.CT.HOSPositionDict","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
