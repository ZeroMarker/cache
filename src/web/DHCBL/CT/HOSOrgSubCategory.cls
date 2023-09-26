/// Function: 组织机构子类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgSubCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构子类信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgSubCategory   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSubCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, ccode As %String) As %Query(ROWSPEC = "ID,ORGSCCode,ORGSCDesc,ORGSCORGCCode,ORGSCSource,ORGSCActivity,ORGSCStartDate,ORGSCEndDate,ORGSCSeqNo,ORGSCPYCode,ORGSCWBCode,ORGSCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, ccode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOrgSubCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s OrgCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgCategory).DHCGetDataByDefaultSession()
	s OrgCategoryAuFlag=0	
	if (OrgCategoryAuStr="")||(OrgCategoryAuStr["limited:0") s OrgCategoryAuFlag=1
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGSCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),2)	//组织机构子类代码
	    s ORGSCDesc= $listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),3)	//组织机构子类名称
	    s ORGSCORGCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),4) 		//组织机构大类-外键
    	s:ORGSCORGCCode'="" ORGSCORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ORGSCORGCCode)),3)			
		s ORGSCSource=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),5) 		//分类来源
		s ORGSCActivity=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),6) 	//是否有效(Y/N)
		s ORGSCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),7) 		//开始日期
		s:ORGSCStartDate'="" ORGSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSCStartDate) 
		s ORGSCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),8) 		//结束日期
		s:ORGSCEndDate'="" ORGSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSCEndDate) 
		
		
		s ORGSCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),12) 		//系统排序号
		
		s ORGSCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),16) 		//拼音码
		s ORGSCWBCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),17) 		//五笔码
		s ORGSCMark=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgSubCategoryD(ID))
            q:ID="" 
            s ORGSCORGCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),4) 		//组织机构大类-外键
            s strRowId = "{ID:"_ID_"}"
            s SCORGCCodestrRowId = "{ID:"_ORGSCORGCCode_"}"
            
			if (((AuStr[strRowId)||(AuFlag=1))&&((OrgCategoryAuStr[SCORGCCodestrRowId)||(OrgCategoryAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	            s ORGSCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),2)	//组织机构子类代码
			    s ORGSCDesc= $listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),3)	//组织机构子类名称
			    
			    continue:((ccode'="")&&(ccode'=ORGSCORGCCode))
		    	s:ORGSCORGCCode'="" ORGSCORGCCode=$listget($g(^CT.BDP.CT.HOSOrgCategoryD(ORGSCORGCCode)),3)			
				s ORGSCSource=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),5) 		//分类来源
				s ORGSCActivity=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),6) 	//是否有效(Y/N)
				s ORGSCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),7) 		//开始日期
				s:ORGSCStartDate'="" ORGSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSCStartDate) 
				s ORGSCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),8) 		//结束日期
				s:ORGSCEndDate'="" ORGSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSCEndDate) 
				
				
				s ORGSCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),12) 		//系统排序号
				
				s ORGSCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),16) 		//拼音码
				s ORGSCWBCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),17) 		//五笔码
				s ORGSCMark=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),18) 		//备注
			
	            if (($zcvt(ORGSCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGSCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGSCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGSCCode,ORGSCDesc,ORGSCORGCCode,ORGSCSource,ORGSCActivity,ORGSCStartDate,ORGSCEndDate,ORGSCSeqNo,ORGSCPYCode,ORGSCWBCode,ORGSCMark)
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
/// Tables: CT_BDP_CT.HOS_OrgSubCategory
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSubCategory", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGSCCode,ORGSCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSOrgSubCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s OrgCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgCategory).DHCGetDataByDefaultSession()
	s OrgCategoryAuFlag=0	
	if (OrgCategoryAuStr="")||(OrgCategoryAuStr["limited:0") s OrgCategoryAuFlag=1
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGSCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),2)	//组织机构子类代码
    	s ORGSCDesc= $listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),3)	//组织机构子类名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgSubCategoryD(ID))
       		q:ID=""
       		s ORGSCORGCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),4) 		//组织机构大类-外键
            s strRowId = "{ID:"_ID_"}"
            s SCORGCCodestrRowId = "{ID:"_ORGSCORGCCode_"}"
            
			if (((AuStr[strRowId)||(AuFlag=1))&&((OrgCategoryAuStr[SCORGCCodestrRowId)||(OrgCategoryAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				
	       		s ORGSCCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),2)	//组织机构子类代码
		    	s ORGSCDesc= $listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),3)	//组织机构子类名称
		    	
				s ORGSCActivity=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),6) 	//是否有效(Y/N)
				continue:ORGSCActivity="N"
		    	s ORGSCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),7) 		//开始日期
		    	continue:(ORGSCStartDate'="")&&(ORGSCStartDate>+$h)
				s ORGSCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),8) 		//结束日期
		  		continue:(ORGSCEndDate'="")&&(ORGSCEndDate<+$h)

	       		s ORGSCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ID)),16) 		//拼音码
			
	            if (($zcvt(ORGSCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGSCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGSCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGSCCode,ORGSCDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgSubCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgSubCategory).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgSubCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGSCCode=pobj.ORGSCCode	//组织机构子类代码
    s eobj.ORGSCDesc= pobj.ORGSCDesc	//组织机构子类名称
    if $IsObject(pobj.ORGSCORGCCode){
		s eobj.ORGSCORGCCode = pobj.ORGSCORGCCode.%Id() 	//组织机构大类-外键
	}
	s eobj.ORGSCSource=pobj.ORGSCSource		//分类来源
	s eobj.ORGSCActivity=pobj.ORGSCActivity	//是否有效(Y/N)
	s eobj.ORGSCStartDate=pobj.ORGSCStartDate		//开始日期
	s:eobj.ORGSCStartDate'="" eobj.ORGSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGSCStartDate) 
	s eobj.ORGSCEndDate=pobj.ORGSCEndDate		//结束日期
	s:eobj.ORGSCEndDate'="" eobj.ORGSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGSCEndDate) 
	s eobj.ORGSCSeqNo=pobj.ORGSCSeqNo		//系统排序号
	
	s eobj.ORGSCPYCode=pobj.ORGSCPYCode		//拼音码
	s eobj.ORGSCWBCode=pobj.ORGSCWBCode		//五笔码
	s eobj.ORGSCMark=pobj.ORGSCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgSubCategory
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgSubCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgSubCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgSubCategoryI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构子类内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgSubCategory
/// Input：     web.Entity.CT.HOSOrgSubCategory  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgSubCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgSubCategory) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGSCStartDate'="" eobj.ORGSCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGSCStartDate) 
    s:eobj.ORGSCEndDate'="" eobj.ORGSCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGSCEndDate)
    s:eobj.ORGSCStartDate="" eobj.ORGSCStartDate=+$h
    s:eobj.ORGSCLastUpdateDate="" eobj.ORGSCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGSCLastUpdateTime="" eobj.ORGSCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGSCLastUpdateUser="" eobj.ORGSCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGSCActivity="" eobj.ORGSCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGSCCode,eobj.ORGSCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgSubCategory).%New()
            //s eobj.ORGSCSeqNo=..GetSeqNo()
            s:eobj.ORGSCCreateDate="" eobj.ORGSCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGSCCreateTime="" eobj.ORGSCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGSCCreateUser="" eobj.ORGSCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGSCCreateDate=eobj.ORGSCCreateDate		//系统创建日期
			s obj.ORGSCCreateTime=eobj.ORGSCCreateTime		//系统创建时间
			d obj.ORGSCCreateUserSetObjectId(eobj.ORGSCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgSubCategory).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgSubCategory).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGSCCode=obj.ORGSCCode	//组织机构子类代码
            s bobj.ORGSCDesc= obj.ORGSCDesc	//组织机构子类名称
            if $IsObject(obj.ORGSCORGCCode){
				s bobj.ORGSCORGCCode = obj.ORGSCORGCCode.%Id() 	//组织机构大类-外键
			}
			s bobj.ORGSCSource=obj.ORGSCSource		//分类来源
			s bobj.ORGSCActivity=obj.ORGSCActivity	//是否有效(Y/N)
			s bobj.ORGSCStartDate=obj.ORGSCStartDate		//开始日期
			s bobj.ORGSCEndDate=obj.ORGSCEndDate		//结束日期
			s bobj.ORGSCCreateDate=obj.ORGSCCreateDate		//系统创建日期
			s bobj.ORGSCCreateTime=obj.ORGSCCreateTime		//系统创建时间
			if $IsObject(obj.ORGSCCreateUser){
				s bobj.ORGSCCreateUser = obj.ORGSCCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGSCSeqNo=obj.ORGSCSeqNo		//系统排序号
			s bobj.ORGSCLastUpdateDate=obj.ORGSCLastUpdateDate		//系统最后更新日期
			s bobj.ORGSCLastUpdateTime=obj.ORGSCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGSCLastUpdateUser){
				s bobj.ORGSCLastUpdateUser = obj.ORGSCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGSCPYCode=obj.ORGSCPYCode		//拼音码
			s bobj.ORGSCWBCode=obj.ORGSCWBCode		//五笔码
			s bobj.ORGSCMark=obj.ORGSCMark		//备注

        }
        
        s obj.ORGSCCode=eobj.ORGSCCode	//组织机构子类代码
        s obj.ORGSCDesc= eobj.ORGSCDesc	//组织机构子类名称
		d obj.ORGSCORGCCodeSetObjectId(eobj.ORGSCORGCCode)	//组织机构大类-外键
		
		s obj.ORGSCSource=eobj.ORGSCSource		//分类来源
		s obj.ORGSCActivity=eobj.ORGSCActivity	//是否有效(Y/N)
		s obj.ORGSCStartDate=eobj.ORGSCStartDate		//开始日期
		s obj.ORGSCEndDate=eobj.ORGSCEndDate		//结束日期
		
		s obj.ORGSCSeqNo=eobj.ORGSCSeqNo		//系统排序号
		s obj.ORGSCLastUpdateDate=eobj.ORGSCLastUpdateDate		//系统最后更新日期
		s obj.ORGSCLastUpdateTime=eobj.ORGSCLastUpdateTime		//系统最后更新时间
		d obj.ORGSCLastUpdateUserSetObjectId(eobj.ORGSCLastUpdateUser)	//系统最新更新人
		s:eobj.ORGSCPYCode="" eobj.ORGSCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGSCDesc)
		s obj.ORGSCPYCode=eobj.ORGSCPYCode		//拼音码
		s:eobj.ORGSCWBCode="" eobj.ORGSCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGSCDesc,1)
		s obj.ORGSCWBCode=eobj.ORGSCWBCode		//五笔码
		s obj.ORGSCMark=eobj.ORGSCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSubCategory","CT.BDP.CT.HOSOrgSubCategory","组织机构子类",id,eobj.ORGSCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSubCategory","CT.BDP.CT.HOSOrgSubCategory","组织机构子类",eobj.ID,eobj.ORGSCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构子类","web.DHCBL.CT.HOSOrgSubCategory","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgSubCategory).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGSCCode",id)){
        s myInfo=myInfo_"<组织结构树>"
    } 
    if $d(^CT.BDP.CT.HOSOrgMinCategoryI("IndexSubCategory",id)){
        s myInfo=myInfo_"<组织结构小类>"
    }  
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构子类的内容
/// Table：CT.BDP.CT.HOSOrgSubCategory
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgSubCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgSubCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgSubCategory).%New()
    s eobj.ID = id
    s eobj.ORGSCCode=pobj.ORGSCCode	//组织机构子类代码
    s eobj.ORGSCDesc= pobj.ORGSCDesc	//组织机构子类名称
	if $IsObject(pobj.ORGSCORGCCode){
		s eobj.ORGSCORGCCode = pobj.ORGSCORGCCode.%Id() 	//组织机构大类-外键
	}	
	s eobj.ORGSCSource=pobj.ORGSCSource		//分类来源
	s eobj.ORGSCActivity=pobj.ORGSCActivity	//是否有效(Y/N)
	s eobj.ORGSCStartDate=pobj.ORGSCStartDate		//开始日期
	s eobj.ORGSCEndDate=pobj.ORGSCEndDate		//结束日期
	
	s eobj.ORGSCSeqNo=pobj.ORGSCSeqNo		//系统排序号
	
	s eobj.ORGSCPYCode=pobj.ORGSCPYCode		//拼音码
	s eobj.ORGSCWBCode=pobj.ORGSCWBCode		//五笔码
	s eobj.ORGSCMark=pobj.ORGSCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgSubCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSubCategory","CT.BDP.CT.HOSOrgSubCategory","组织机构子类",id,eobj.ORGSCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构子类","web.DHCBL.CT.HOSOrgSubCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
