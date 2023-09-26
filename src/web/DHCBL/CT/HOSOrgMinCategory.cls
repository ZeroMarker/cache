/// Function: 组织机构小类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgMinCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构小类信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgMinCategory   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgMinCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, orgscode As %String) As %Query(ROWSPEC = "ID,ORGMCCode,ORGMCDesc,ORGMCORGSCode,ORGMCSource,ORGMCActivity,ORGMCStartDate,ORGMCEndDate,ORGMCSeqNo,ORGMCPYCode,ORGMCWBCode,ORGMCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, orgscode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOrgMinCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s OrgSubCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgSubCategory).DHCGetDataByDefaultSession()
	s OrgSubCategoryAuFlag=0	
	if (OrgSubCategoryAuStr="")||(OrgSubCategoryAuStr["limited:0") s OrgSubCategoryAuFlag=1
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),2)	//组织机构小类代码
	    s ORGMCDesc= $listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),3)	//组织机构小类名称
	    s ORGMCORGSCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),4) 		//组织机构子类-外键
    	s:ORGMCORGSCode'="" ORGMCORGSCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ORGMCORGSCode)),3)			
		s ORGMCSource=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),5) 		//分类来源
		s ORGMCActivity=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),6) 	//是否有效(Y/N)
		s ORGMCStartDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),7) 		//开始日期
		s:ORGMCStartDate'="" ORGMCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGMCStartDate) 
		s ORGMCEndDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),8) 		//结束日期
		s:ORGMCEndDate'="" ORGMCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGMCEndDate) 
		
		
		s ORGMCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),12) 		//系统排序号
		
		s ORGMCPYCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),16) 		//拼音码
		s ORGMCWBCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),17) 		//五笔码
		s ORGMCMark=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgMinCategoryD(ID))
            q:ID="" 
            s ORGMCORGSCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),4) 		//组织机构子类-外键
            s strRowId = "{ID:"_ID_"}"
            s MCORGSCodestrRowId = "{ID:"_ORGMCORGSCode_"}"
            
			i (((AuStr[strRowId)||(AuFlag=1))&&((OrgSubCategoryAuStr[MCORGSCodestrRowId)||(OrgSubCategoryAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	            s ORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),2)	//组织机构小类代码
			    s ORGMCDesc= $listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),3)	//组织机构小类名称
			    
			    continue:((orgscode'="")&&(orgscode'=ORGMCORGSCode))
		    	s:ORGMCORGSCode'="" ORGMCORGSCode=$listget($g(^CT.BDP.CT.HOSOrgSubCategoryD(ORGMCORGSCode)),3)			
				s ORGMCSource=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),5) 		//分类来源
				s ORGMCActivity=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),6) 	//是否有效(Y/N)
				s ORGMCStartDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),7) 		//开始日期
				s:ORGMCStartDate'="" ORGMCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGMCStartDate) 
				s ORGMCEndDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),8) 		//结束日期
				s:ORGMCEndDate'="" ORGMCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGMCEndDate) 
				
				
				s ORGMCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),12) 		//系统排序号
				
				s ORGMCPYCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),16) 		//拼音码
				s ORGMCWBCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),17) 		//五笔码
				s ORGMCMark=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),18) 		//备注
			
	            if (($zcvt(ORGMCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGMCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGMCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGMCCode,ORGMCDesc,ORGMCORGSCode,ORGMCSource,ORGMCActivity,ORGMCStartDate,ORGMCEndDate,ORGMCSeqNo,ORGMCPYCode,ORGMCWBCode,ORGMCMark)
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
/// Tables: CT_BDP_CT.HOS_OrgMinCategory
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgMinCategory", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGMCCode,ORGMCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSOrgMinCategory).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s OrgSubCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgSubCategory).DHCGetDataByDefaultSession()
	s OrgSubCategoryAuFlag=0	
	if (OrgSubCategoryAuStr="")||(OrgSubCategoryAuStr["limited:0") s OrgSubCategoryAuFlag=1
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),2)	//组织机构小类代码
    	s ORGMCDesc= $listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),3)	//组织机构小类名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgMinCategoryD(ID))
       		q:ID="" 
       		s ORGMCORGSCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),4) 		//组织机构子类-外键
            s strRowId = "{ID:"_ID_"}"
            s MCORGSCodestrRowId = "{ID:"_ORGMCORGSCode_"}"
            
			i (((AuStr[strRowId)||(AuFlag=1))&&((OrgSubCategoryAuStr[MCORGSCodestrRowId)||(OrgSubCategoryAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	       		s ORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),2)	//组织机构小类代码
		    	s ORGMCDesc= $listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),3)	//组织机构小类名称
		    	
				s ORGMCActivity=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),6) 	//是否有效(Y/N)
				continue:ORGMCActivity="N"
		    	s ORGMCStartDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),7) 		//开始日期
		    	continue:(ORGMCStartDate'="")&&(ORGMCStartDate>+$h)
				s ORGMCEndDate=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),8) 		//结束日期
		  		continue:(ORGMCEndDate'="")&&(ORGMCEndDate<+$h)

	       		s ORGMCPYCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ID)),16) 		//拼音码
			
	            if (($zcvt(ORGMCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGMCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGMCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGMCCode,ORGMCDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgMinCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgMinCategory).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgMinCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGMCCode=pobj.ORGMCCode	//组织机构小类代码
    s eobj.ORGMCDesc= pobj.ORGMCDesc	//组织机构小类名称
    if $IsObject(pobj.ORGMCORGSCode){
		s eobj.ORGMCORGSCode = pobj.ORGMCORGSCode.%Id() 	//组织机构子类-外键
	}
	s eobj.ORGMCSource=pobj.ORGMCSource		//分类来源
	s eobj.ORGMCActivity=pobj.ORGMCActivity	//是否有效(Y/N)
	s eobj.ORGMCStartDate=pobj.ORGMCStartDate		//开始日期
	s:eobj.ORGMCStartDate'="" eobj.ORGMCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGMCStartDate) 
	s eobj.ORGMCEndDate=pobj.ORGMCEndDate		//结束日期
	s:eobj.ORGMCEndDate'="" eobj.ORGMCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGMCEndDate) 
	s eobj.ORGMCSeqNo=pobj.ORGMCSeqNo		//系统排序号
	
	s eobj.ORGMCPYCode=pobj.ORGMCPYCode		//拼音码
	s eobj.ORGMCWBCode=pobj.ORGMCWBCode		//五笔码
	s eobj.ORGMCMark=pobj.ORGMCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgMinCategory
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgMinCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgMinCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgMinCategoryI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构小类内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgMinCategory
/// Input：     web.Entity.CT.HOSOrgMinCategory  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgMinCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgMinCategory) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGMCStartDate'="" eobj.ORGMCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGMCStartDate) 
    s:eobj.ORGMCEndDate'="" eobj.ORGMCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGMCEndDate)
    s:eobj.ORGMCStartDate="" eobj.ORGMCStartDate=+$h	
    s:eobj.ORGMCLastUpdateDate="" eobj.ORGMCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGMCLastUpdateTime="" eobj.ORGMCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGMCLastUpdateUser="" eobj.ORGMCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGMCActivity="" eobj.ORGMCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGMCCode,eobj.ORGMCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgMinCategory).%New()
            //s eobj.ORGMCSeqNo=..GetSeqNo()
            s:eobj.ORGMCCreateDate="" eobj.ORGMCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGMCCreateTime="" eobj.ORGMCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGMCCreateUser="" eobj.ORGMCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGMCCreateDate=eobj.ORGMCCreateDate		//系统创建日期
			s obj.ORGMCCreateTime=eobj.ORGMCCreateTime		//系统创建时间
			d obj.ORGMCCreateUserSetObjectId(eobj.ORGMCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgMinCategory).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgMinCategory).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGMCCode=obj.ORGMCCode	//组织机构小类代码
            s bobj.ORGMCDesc= obj.ORGMCDesc	//组织机构小类名称
            if $IsObject(obj.ORGMCORGSCode){
				s bobj.ORGMCORGSCode = obj.ORGMCORGSCode.%Id() 	//组织机构子类-外键
			}
			s bobj.ORGMCSource=obj.ORGMCSource		//分类来源
			s bobj.ORGMCActivity=obj.ORGMCActivity	//是否有效(Y/N)
			s bobj.ORGMCStartDate=obj.ORGMCStartDate		//开始日期
			s bobj.ORGMCEndDate=obj.ORGMCEndDate		//结束日期
			s bobj.ORGMCCreateDate=obj.ORGMCCreateDate		//系统创建日期
			s bobj.ORGMCCreateTime=obj.ORGMCCreateTime		//系统创建时间
			if $IsObject(obj.ORGMCCreateUser){
				s bobj.ORGMCCreateUser = obj.ORGMCCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGMCSeqNo=obj.ORGMCSeqNo		//系统排序号
			s bobj.ORGMCLastUpdateDate=obj.ORGMCLastUpdateDate		//系统最后更新日期
			s bobj.ORGMCLastUpdateTime=obj.ORGMCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGMCLastUpdateUser){
				s bobj.ORGMCLastUpdateUser = obj.ORGMCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGMCPYCode=obj.ORGMCPYCode		//拼音码
			s bobj.ORGMCWBCode=obj.ORGMCWBCode		//五笔码
			s bobj.ORGMCMark=obj.ORGMCMark		//备注

        }
        
        s obj.ORGMCCode=eobj.ORGMCCode	//组织机构小类代码
        s obj.ORGMCDesc= eobj.ORGMCDesc	//组织机构小类名称
		d obj.ORGMCORGSCodeSetObjectId(eobj.ORGMCORGSCode)	//组织机构子类-外键
		
		s obj.ORGMCSource=eobj.ORGMCSource		//分类来源
		s obj.ORGMCActivity=eobj.ORGMCActivity	//是否有效(Y/N)
		s obj.ORGMCStartDate=eobj.ORGMCStartDate		//开始日期
		s obj.ORGMCEndDate=eobj.ORGMCEndDate		//结束日期
		
		s obj.ORGMCSeqNo=eobj.ORGMCSeqNo		//系统排序号
		s obj.ORGMCLastUpdateDate=eobj.ORGMCLastUpdateDate		//系统最后更新日期
		s obj.ORGMCLastUpdateTime=eobj.ORGMCLastUpdateTime		//系统最后更新时间
		d obj.ORGMCLastUpdateUserSetObjectId(eobj.ORGMCLastUpdateUser)	//系统最新更新人
		s:eobj.ORGMCPYCode="" eobj.ORGMCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGMCDesc)
		s obj.ORGMCPYCode=eobj.ORGMCPYCode		//拼音码
		s:eobj.ORGMCWBCode="" eobj.ORGMCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGMCDesc,1)
		s obj.ORGMCWBCode=eobj.ORGMCWBCode		//五笔码
		s obj.ORGMCMark=eobj.ORGMCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgMinCategory","CT.BDP.CT.HOSOrgMinCategory","组织机构小类",id,eobj.ORGMCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgMinCategory","CT.BDP.CT.HOSOrgMinCategory","组织机构小类",eobj.ID,eobj.ORGMCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构小类","web.DHCBL.CT.HOSOrgMinCategory","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgMinCategory).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGMCCode",id)){
        s myInfo=myInfo_"<组织结构树>"
    } 
    if $d(^CT.BDP.CT.HOSOrgSpecCategoryI("IndexMinCategory",id)){
        s myInfo=myInfo_"<组织机构专业分类>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构小类的内容
/// Table：CT.BDP.CT.HOSOrgMinCategory
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgMinCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgMinCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgMinCategory).%New()
    s eobj.ID = id
    s eobj.ORGMCCode=pobj.ORGMCCode	//组织机构小类代码
    s eobj.ORGMCDesc= pobj.ORGMCDesc	//组织机构小类名称
	if $IsObject(pobj.ORGMCORGSCode){
		s eobj.ORGMCORGSCode = pobj.ORGMCORGSCode.%Id() 	//组织机构子类-外键
	}	
	s eobj.ORGMCSource=pobj.ORGMCSource		//分类来源
	s eobj.ORGMCActivity=pobj.ORGMCActivity	//是否有效(Y/N)
	s eobj.ORGMCStartDate=pobj.ORGMCStartDate		//开始日期
	s eobj.ORGMCEndDate=pobj.ORGMCEndDate		//结束日期
	
	s eobj.ORGMCSeqNo=pobj.ORGMCSeqNo		//系统排序号
	
	s eobj.ORGMCPYCode=pobj.ORGMCPYCode		//拼音码
	s eobj.ORGMCWBCode=pobj.ORGMCWBCode		//五笔码
	s eobj.ORGMCMark=pobj.ORGMCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgMinCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgMinCategory","CT.BDP.CT.HOSOrgMinCategory","组织机构小类",id,eobj.ORGMCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构小类","web.DHCBL.CT.HOSOrgMinCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
