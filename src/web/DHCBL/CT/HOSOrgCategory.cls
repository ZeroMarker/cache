/// Function: 组织机构大类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构大类信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgCategory   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ORGCCode,ORGCDesc,ORGCSource,ORGCActivity,ORGCStartDate,ORGCEndDate,ORGCSeqNo,ORGCPYCode,ORGCWBCode,ORGCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOrgCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),2)	//组织机构大类代码
	    s ORGCDesc= $listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),3)	//组织机构大类名称
		s ORGCSource=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),4) 		//分类来源
		s ORGCActivity=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),5) 	//是否有效(Y/N)
		s ORGCStartDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),6) 		//开始日期
		s:ORGCStartDate'="" ORGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCStartDate) 
		s ORGCEndDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),7) 		//结束日期
		s:ORGCEndDate'="" ORGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCEndDate) 
		
		
		s ORGCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),11) 		//系统排序号
		
		s ORGCPYCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),15) 		//拼音码
		s ORGCWBCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),16) 		//五笔码
		s ORGCMark=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),17) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgCategoryD(ID))
            q:ID="" 
            s strRowId = "{ID:"_ID_"}"
			i ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	            s ORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),2)	//组织机构大类代码
			    s ORGCDesc= $listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),3)	//组织机构大类名称
			    
				s ORGCSource=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),4) 		//分类来源
				s ORGCActivity=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),5) 	//是否有效(Y/N)
				s ORGCStartDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),6) 		//开始日期
				s:ORGCStartDate'="" ORGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCStartDate) 
				s ORGCEndDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),7) 		//结束日期
				s:ORGCEndDate'="" ORGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCEndDate) 
				
				
				s ORGCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),11) 		//系统排序号
				
				s ORGCPYCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),15) 		//拼音码
				s ORGCWBCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),16) 		//五笔码
				s ORGCMark=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),17) 		//备注
			
	            if (($zcvt(ORGCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGCCode,ORGCDesc,ORGCSource,ORGCActivity,ORGCStartDate,ORGCEndDate,ORGCSeqNo,ORGCPYCode,ORGCWBCode,ORGCMark)
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
/// Tables: CT_BDP_CT.HOS_OrgCategory
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgCategory", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGCCode,ORGCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSOrgCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),2)	//组织机构大类代码
    	s ORGCDesc= $listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),3)	//组织机构大类名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgCategoryD(ID))
       		q:ID="" 
            s strRowId = "{ID:"_ID_"}"
			i ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	       		s ORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),2)	//组织机构大类代码
		    	s ORGCDesc= $listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),3)	//组织机构大类名称
		    	
				s ORGCActivity=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),5) 	//是否有效(Y/N)
				continue:ORGCActivity="N"
		    	s ORGCStartDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),6) 		//开始日期
		    	continue:(ORGCStartDate'="")&&(ORGCStartDate>+$h)
				s ORGCEndDate=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),7) 		//结束日期
		  		continue:(ORGCEndDate'="")&&(ORGCEndDate<+$h)

	       		s ORGCPYCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ID)),16) 		//拼音码
	            if (($zcvt(ORGCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGCCode,ORGCDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgCategory).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGCCode=pobj.ORGCCode	//组织机构大类代码
    s eobj.ORGCDesc= pobj.ORGCDesc	//组织机构大类名称
	s eobj.ORGCSource=pobj.ORGCSource		//分类来源
	s eobj.ORGCActivity=pobj.ORGCActivity	//是否有效(Y/N)
	s eobj.ORGCStartDate=pobj.ORGCStartDate		//开始日期
	s:eobj.ORGCStartDate'="" eobj.ORGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGCStartDate) 
	s eobj.ORGCEndDate=pobj.ORGCEndDate		//结束日期
	s:eobj.ORGCEndDate'="" eobj.ORGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGCEndDate) 
	s eobj.ORGCSeqNo=pobj.ORGCSeqNo		//系统排序号
	
	s eobj.ORGCPYCode=pobj.ORGCPYCode		//拼音码
	s eobj.ORGCWBCode=pobj.ORGCWBCode		//五笔码
	s eobj.ORGCMark=pobj.ORGCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgCategory
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgCategoryI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构大类内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgCategory
/// Input：     web.Entity.CT.HOSOrgCategory  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgCategory) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGCStartDate'="" eobj.ORGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGCStartDate) 
    s:eobj.ORGCEndDate'="" eobj.ORGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGCEndDate)
    s:eobj.ORGCStartDate="" eobj.ORGCStartDate=+$h
    s:eobj.ORGCLastUpdateDate="" eobj.ORGCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGCLastUpdateTime="" eobj.ORGCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGCLastUpdateUser="" eobj.ORGCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGCActivity="" eobj.ORGCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGCCode,eobj.ORGCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgCategory).%New()
            //s eobj.ORGCSeqNo=..GetSeqNo()
            s:eobj.ORGCCreateDate="" eobj.ORGCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGCCreateTime="" eobj.ORGCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGCCreateUser="" eobj.ORGCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGCCreateDate=eobj.ORGCCreateDate		//系统创建日期
			s obj.ORGCCreateTime=eobj.ORGCCreateTime		//系统创建时间
			d obj.ORGCCreateUserSetObjectId(eobj.ORGCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgCategory).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgCategory).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGCCode=obj.ORGCCode	//组织机构大类代码
            s bobj.ORGCDesc= obj.ORGCDesc	//组织机构大类名称
			s bobj.ORGCSource=obj.ORGCSource		//分类来源
			s bobj.ORGCActivity=obj.ORGCActivity	//是否有效(Y/N)
			s bobj.ORGCStartDate=obj.ORGCStartDate		//开始日期
			s bobj.ORGCEndDate=obj.ORGCEndDate		//结束日期
			s bobj.ORGCCreateDate=obj.ORGCCreateDate		//系统创建日期
			s bobj.ORGCCreateTime=obj.ORGCCreateTime		//系统创建时间
			if $IsObject(obj.ORGCCreateUser){
				s bobj.ORGCCreateUser = obj.ORGCCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGCSeqNo=obj.ORGCSeqNo		//系统排序号
			s bobj.ORGCLastUpdateDate=obj.ORGCLastUpdateDate		//系统最后更新日期
			s bobj.ORGCLastUpdateTime=obj.ORGCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGCLastUpdateUser){
				s bobj.ORGCLastUpdateUser = obj.ORGCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGCPYCode=obj.ORGCPYCode		//拼音码
			s bobj.ORGCWBCode=obj.ORGCWBCode		//五笔码
			s bobj.ORGCMark=obj.ORGCMark		//备注

        }
        
        s obj.ORGCCode=eobj.ORGCCode	//组织机构大类代码
        s obj.ORGCDesc= eobj.ORGCDesc	//组织机构大类名称
		
		s obj.ORGCSource=eobj.ORGCSource		//分类来源
		s obj.ORGCActivity=eobj.ORGCActivity	//是否有效(Y/N)
		s obj.ORGCStartDate=eobj.ORGCStartDate		//开始日期
		s obj.ORGCEndDate=eobj.ORGCEndDate		//结束日期
		
		s obj.ORGCSeqNo=eobj.ORGCSeqNo		//系统排序号
		s obj.ORGCLastUpdateDate=eobj.ORGCLastUpdateDate		//系统最后更新日期
		s obj.ORGCLastUpdateTime=eobj.ORGCLastUpdateTime		//系统最后更新时间
		d obj.ORGCLastUpdateUserSetObjectId(eobj.ORGCLastUpdateUser)	//系统最新更新人
		s:eobj.ORGCPYCode="" eobj.ORGCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGCDesc)
		s obj.ORGCPYCode=eobj.ORGCPYCode		//拼音码
		s:eobj.ORGCWBCode="" eobj.ORGCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGCDesc,1)
		s obj.ORGCWBCode=eobj.ORGCWBCode		//五笔码
		s obj.ORGCMark=eobj.ORGCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgCategory","CT.BDP.CT.HOSOrgCategory","组织机构大类",id,eobj.ORGCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgCategory","CT.BDP.CT.HOSOrgCategory","组织机构大类",eobj.ID,eobj.ORGCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构大类","web.DHCBL.CT.HOSOrgCategory","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgCategory).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGCCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    } 
    if $d(^CT.BDP.CT.HOSOrgSubCategoryI("IndexCategory",id)){
        s myInfo=myInfo_"<组织机构子类>"
    } 
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构大类的内容
/// Table：CT.BDP.CT.HOSOrgCategory
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgCategory).%New()
    s eobj.ID = id
    s eobj.ORGCCode=pobj.ORGCCode	//组织机构大类代码
    s eobj.ORGCDesc= pobj.ORGCDesc	//组织机构大类名称
	s eobj.ORGCSource=pobj.ORGCSource		//分类来源
	s eobj.ORGCActivity=pobj.ORGCActivity	//是否有效(Y/N)
	s eobj.ORGCStartDate=pobj.ORGCStartDate		//开始日期
	s eobj.ORGCEndDate=pobj.ORGCEndDate		//结束日期
	
	s eobj.ORGCSeqNo=pobj.ORGCSeqNo		//系统排序号
	
	s eobj.ORGCPYCode=pobj.ORGCPYCode		//拼音码
	s eobj.ORGCWBCode=pobj.ORGCWBCode		//五笔码
	s eobj.ORGCMark=pobj.ORGCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgCategory","CT.BDP.CT.HOSOrgCategory","组织机构大类",id,eobj.ORGCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构大类","web.DHCBL.CT.HOSOrgCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：由于删除了组织机构行业分类字段，导致数据错位需要恢复
/// Table：CT.BDP.CT.HOSOrgCategory
/// Input：
/// Return：
/// Other:w ##class(web.DHCBL.CT.HOSOrgCategory).RecoverData()
ClassMethod RecoverData()
{
	merge ^TempData=^CT.BDP.CT.HOSOrgCategoryD
	
	s result="true"
	ts
	k ^CT.BDP.CT.HOSOrgCategoryD
	k ^CT.BDP.CT.HOSOrgCategoryI
	s ID=0
    for 
    {
        s ID=$o(^TempData(ID))
        q:ID="" 
       	
       	s ORGCCode=$listget($g(^TempData(ID)),2)	//组织机构大类代码
	    s ORGCDesc= $listget($g(^TempData(ID)),3)	//组织机构大类名称
	    
		s ORGCSource="" 		//分类来源
		s ORGCActivity=$listget($g(^TempData(ID)),4) 	//是否有效(Y/N)
		s ORGCStartDate=$listget($g(^TempData(ID)),5) 		//开始日期
		s ORGCEndDate=$listget($g(^TempData(ID)),6) 		//结束日期
		s ORGCCreateDate=$listget($g(^TempData(ID)),7) 
		s ORGCCreateTime=$listget($g(^TempData(ID)),8) 
		s ORGCCreateUser=$listget($g(^TempData(ID)),9) 
		s ORGCSeqNo=$listget($g(^TempData(ID)),10) 		//系统排序号
		s ORGCLastUpdateDate=$listget($g(^TempData(ID)),11) 		
		s ORGCLastUpdateTime=$listget($g(^TempData(ID)),12) 		
		s ORGCLastUpdateUser=$listget($g(^TempData(ID)),13) 		
		
		s ORGCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ORGCDesc)  		//拼音码
		s ORGCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(ORGCDesc,1) 		//五笔码
		s ORGCMark=$listget($g(^TempData(ID)),16) 		//备注	
			
		s obj=##class(CT.BDP.CT.HOSOrgCategory).%New()	
		
		s obj.ORGCCode=ORGCCode	//组织机构大类代码
        s obj.ORGCDesc= ORGCDesc	//组织机构大类名称
		
		s obj.ORGCSource=ORGCSource		//分类来源
		s obj.ORGCActivity=ORGCActivity	//是否有效(Y/N)
		s obj.ORGCStartDate=ORGCStartDate		//开始日期
		s obj.ORGCEndDate=ORGCEndDate		//结束日期
		s obj.ORGCCreateDate=ORGCCreateDate		//系统创建日期
		s obj.ORGCCreateTime=ORGCCreateTime		//系统创建时间
		d obj.ORGCCreateUserSetObjectId(ORGCCreateUser)	//系统创建人
		
		s obj.ORGCSeqNo=ORGCSeqNo		//系统排序号
		s obj.ORGCLastUpdateDate=ORGCLastUpdateDate		//系统最后更新日期
		s obj.ORGCLastUpdateTime=ORGCLastUpdateTime		//系统最后更新时间
		d obj.ORGCLastUpdateUserSetObjectId(ORGCLastUpdateUser)	//系统最新更新人
		s obj.ORGCPYCode=ORGCPYCode		//拼音码
		s obj.ORGCWBCode=ORGCWBCode		//五笔码
		s obj.ORGCMark=ORGCMark		//备注
		s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
	         
        }
        else
        {
	     	s result="false"   
        }
    }
    if (result="true")
    {
	    k ^TempData
	 	tc   
    }
    else
    {
	 	tro   
    }
    q result
}

}
