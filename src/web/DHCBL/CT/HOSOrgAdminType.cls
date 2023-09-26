/// Function: 组织机构行政属性字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgAdminType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构行政属性信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgAdminType   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgAdminType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ORGACCode,ORGACDesc,ORGACActivity,ORGACStartDate,ORGACEndDate,ORGACSeqNo,ORGACPYCode,ORGACWBCode,ORGACMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOrgAdminType).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),2)	//组织机构行政属性代码
	    s ORGACDesc= $listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),3)	//组织机构行政属性名称
	    
		s ORGACActivity=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),4) 	//是否有效(Y/N)
		s ORGACStartDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),5) 		//开始日期
		s:ORGACStartDate'="" ORGACStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGACStartDate) 
		s ORGACEndDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),6) 		//结束日期
		s:ORGACEndDate'="" ORGACEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGACEndDate) 
		
		
		s ORGACSeqNo=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),10) 		//系统排序号
		
		s ORGACPYCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),14) 		//拼音码
		s ORGACWBCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),15) 		//五笔码
		s ORGACMark=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),16) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgAdminTypeD(ID))
            q:ID="" 
            s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	            s ORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),2)	//组织机构行政属性代码
			    s ORGACDesc= $listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),3)	//组织机构行政属性名称
			    s ORGACActivity=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),4) 	//是否有效(Y/N)
				s ORGACStartDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),5) 		//开始日期
				s:ORGACStartDate'="" ORGACStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGACStartDate) 
				s ORGACEndDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),6) 		//结束日期
				s:ORGACEndDate'="" ORGACEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGACEndDate) 
				
				
				s ORGACSeqNo=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),10) 		//系统排序号
				
				s ORGACPYCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),14) 		//拼音码
				s ORGACWBCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),15) 		//五笔码
				s ORGACMark=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),16) 		//备注
			
	            if (($zcvt(ORGACCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGACDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGACPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }
			}  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGACCode,ORGACDesc,ORGACActivity,ORGACStartDate,ORGACEndDate,ORGACSeqNo,ORGACPYCode,ORGACWBCode,ORGACMark)
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
/// Tables: CT_BDP_CT.HOS_OrgAdminType
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgAdminType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGACCode,ORGACDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSOrgAdminType).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),2)	//组织机构行政属性代码
    	s ORGACDesc= $listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),3)	//组织机构行政属性名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgAdminTypeD(ID))
       		q:ID="" 
       		s strRowId = "{ID:"_ID_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	       		s ORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),2)	//组织机构行政属性代码
		    	s ORGACDesc= $listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),3)	//组织机构行政属性名称
		    	
				s ORGACActivity=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),4) 	//是否有效(Y/N)
				continue:ORGACActivity="N"
		    	s ORGACStartDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),5) 		//开始日期
		    	continue:(ORGACStartDate'="")&&(ORGACStartDate>+$h)
				s ORGACEndDate=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),6) 		//结束日期
		  		continue:(ORGACEndDate'="")&&(ORGACEndDate<+$h)

	       		s ORGACPYCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(ID)),14) 		//拼音码
			
	            if (($zcvt(ORGACCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGACDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGACPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGACCode,ORGACDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgAdminType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgAdminType).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgAdminType).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGACCode=pobj.ORGACCode	//组织机构行政属性代码
    s eobj.ORGACDesc= pobj.ORGACDesc	//组织机构行政属性名称

	s eobj.ORGACActivity=pobj.ORGACActivity	//是否有效(Y/N)
	s eobj.ORGACStartDate=pobj.ORGACStartDate		//开始日期
	s:eobj.ORGACStartDate'="" eobj.ORGACStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGACStartDate) 
	s eobj.ORGACEndDate=pobj.ORGACEndDate		//结束日期
	s:eobj.ORGACEndDate'="" eobj.ORGACEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGACEndDate) 
	s eobj.ORGACSeqNo=pobj.ORGACSeqNo		//系统排序号
	
	s eobj.ORGACPYCode=pobj.ORGACPYCode		//拼音码
	s eobj.ORGACWBCode=pobj.ORGACWBCode		//五笔码
	s eobj.ORGACMark=pobj.ORGACMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgAdminType
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgAdminType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgAdminTypeI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgAdminTypeI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构行政属性内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgAdminType
/// Input：     web.Entity.CT.HOSOrgAdminType  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgAdminType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgAdminType) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGACStartDate'="" eobj.ORGACStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGACStartDate) 
    s:eobj.ORGACEndDate'="" eobj.ORGACEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGACEndDate)
    s:eobj.ORGACStartDate="" eobj.ORGACStartDate=+$h
    s:eobj.ORGACLastUpdateDate="" eobj.ORGACLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGACLastUpdateTime="" eobj.ORGACLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGACLastUpdateUser="" eobj.ORGACLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGACActivity="" eobj.ORGACActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGACCode,eobj.ORGACDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgAdminType).%New()
            //s eobj.ORGACSeqNo=..GetSeqNo()
            s:eobj.ORGACCreateDate="" eobj.ORGACCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGACCreateTime="" eobj.ORGACCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGACCreateUser="" eobj.ORGACCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGACCreateDate=eobj.ORGACCreateDate		//系统创建日期
			s obj.ORGACCreateTime=eobj.ORGACCreateTime		//系统创建时间
			d obj.ORGACCreateUserSetObjectId(eobj.ORGACCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgAdminType).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgAdminType).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGACCode=obj.ORGACCode	//组织机构行政属性代码
            s bobj.ORGACDesc= obj.ORGACDesc	//组织机构行政属性名称

			s bobj.ORGACActivity=obj.ORGACActivity	//是否有效(Y/N)
			s bobj.ORGACStartDate=obj.ORGACStartDate		//开始日期
			s bobj.ORGACEndDate=obj.ORGACEndDate		//结束日期
			s bobj.ORGACCreateDate=obj.ORGACCreateDate		//系统创建日期
			s bobj.ORGACCreateTime=obj.ORGACCreateTime		//系统创建时间
			if $IsObject(obj.ORGACCreateUser){
				s bobj.ORGACCreateUser = obj.ORGACCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGACSeqNo=obj.ORGACSeqNo		//系统排序号
			s bobj.ORGACLastUpdateDate=obj.ORGACLastUpdateDate		//系统最后更新日期
			s bobj.ORGACLastUpdateTime=obj.ORGACLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGACLastUpdateUser){
				s bobj.ORGACLastUpdateUser = obj.ORGACLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGACPYCode=obj.ORGACPYCode		//拼音码
			s bobj.ORGACWBCode=obj.ORGACWBCode		//五笔码
			s bobj.ORGACMark=obj.ORGACMark		//备注

        }
        
        s obj.ORGACCode=eobj.ORGACCode	//组织机构行政属性代码
        s obj.ORGACDesc= eobj.ORGACDesc	//组织机构行政属性名称

		s obj.ORGACActivity=eobj.ORGACActivity	//是否有效(Y/N)
		s obj.ORGACStartDate=eobj.ORGACStartDate		//开始日期
		s obj.ORGACEndDate=eobj.ORGACEndDate		//结束日期
		
		s obj.ORGACSeqNo=eobj.ORGACSeqNo		//系统排序号
		s obj.ORGACLastUpdateDate=eobj.ORGACLastUpdateDate		//系统最后更新日期
		s obj.ORGACLastUpdateTime=eobj.ORGACLastUpdateTime		//系统最后更新时间
		d obj.ORGACLastUpdateUserSetObjectId(eobj.ORGACLastUpdateUser)	//系统最新更新人
		s:eobj.ORGACPYCode="" eobj.ORGACPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGACDesc)
		s obj.ORGACPYCode=eobj.ORGACPYCode		//拼音码
		s:eobj.ORGACWBCode="" eobj.ORGACWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGACDesc,1)
		s obj.ORGACWBCode=eobj.ORGACWBCode		//五笔码
		s obj.ORGACMark=eobj.ORGACMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgAdminType","CT.BDP.CT.HOSOrgAdminType","组织机构行政属性",id,eobj.ORGACDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgAdminType","CT.BDP.CT.HOSOrgAdminType","组织机构行政属性",eobj.ID,eobj.ORGACDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构行政属性","web.DHCBL.CT.HOSOrgAdminType","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgAdminType).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGACCode",id)){
        s myInfo=myInfo_"<组织结构树>"
    } 
 
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构行政属性的内容
/// Table：CT.BDP.CT.HOSOrgAdminType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgAdminType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgAdminType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgAdminType).%New()
    s eobj.ID = id
    s eobj.ORGACCode=pobj.ORGACCode	//组织机构行政属性代码
    s eobj.ORGACDesc= pobj.ORGACDesc	//组织机构行政属性名称
	
	s eobj.ORGACActivity=pobj.ORGACActivity	//是否有效(Y/N)
	s eobj.ORGACStartDate=pobj.ORGACStartDate		//开始日期
	s eobj.ORGACEndDate=pobj.ORGACEndDate		//结束日期
	
	s eobj.ORGACSeqNo=pobj.ORGACSeqNo		//系统排序号
	
	s eobj.ORGACPYCode=pobj.ORGACPYCode		//拼音码
	s eobj.ORGACWBCode=pobj.ORGACWBCode		//五笔码
	s eobj.ORGACMark=pobj.ORGACMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgAdminType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgAdminType","CT.BDP.CT.HOSOrgAdminType","组织机构行政属性",id,eobj.ORGACDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构行政属性","web.DHCBL.CT.HOSOrgAdminType","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
