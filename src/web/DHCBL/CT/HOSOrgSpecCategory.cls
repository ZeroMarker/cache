/// Function: 组织机构专业分类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgSpecCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构专业分类信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgSpecCategory   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSpecCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, orgspccode As %String) As %Query(ROWSPEC = "ID,ORGSPCCode,ORGSPCDesc,ORGSPCORGSPCCode,ORGSPCSource,ORGSPCActivity,ORGSPCStartDate,ORGSPCEndDate,ORGSPCSeqNo,ORGSPCPYCode,ORGSPCWBCode,ORGSPCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, orgspccode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),2)	//组织机构专业分类代码
	    s ORGSPCDesc= $listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),3)	//组织机构专业分类名称
	    s ORGSPCORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),4) 		//组织机构小类-外键
    	s:ORGSPCORGSPCCode'="" ORGSPCORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ORGSPCORGSPCCode)),3)			
		s ORGSPCSource=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),5) 		//分类来源
		s ORGSPCActivity=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),6) 	//是否有效(Y/N)
		s ORGSPCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),7) 		//开始日期
		s:ORGSPCStartDate'="" ORGSPCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSPCStartDate) 
		s ORGSPCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),8) 		//结束日期
		s:ORGSPCEndDate'="" ORGSPCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSPCEndDate) 
		
		
		s ORGSPCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),12) 		//系统排序号
		
		s ORGSPCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),16) 		//拼音码
		s ORGSPCWBCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),17) 		//五笔码
		s ORGSPCMark=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgSpecCategoryD(ID))
            q:ID="" 
            s ORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),2)	//组织机构专业分类代码
		    s ORGSPCDesc= $listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),3)	//组织机构专业分类名称
		    s ORGSPCORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),4) 		//组织机构小类-外键
		    continue:((orgspccode'="")&&(orgspccode'=ORGSPCORGSPCCode))
	    	s:ORGSPCORGSPCCode'="" ORGSPCORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ORGSPCORGSPCCode)),3)			
			s ORGSPCSource=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),5) 		//分类来源
			s ORGSPCActivity=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),6) 	//是否有效(Y/N)
			s ORGSPCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),7) 		//开始日期
			s:ORGSPCStartDate'="" ORGSPCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSPCStartDate) 
			s ORGSPCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),8) 		//结束日期
			s:ORGSPCEndDate'="" ORGSPCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGSPCEndDate) 
			
			
			s ORGSPCSeqNo=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),12) 		//系统排序号
			
			s ORGSPCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),16) 		//拼音码
			s ORGSPCWBCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),17) 		//五笔码
			s ORGSPCMark=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),18) 		//备注
		
            if (($zcvt(ORGSPCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGSPCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGSPCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGSPCCode,ORGSPCDesc,ORGSPCORGSPCCode,ORGSPCSource,ORGSPCActivity,ORGSPCStartDate,ORGSPCEndDate,ORGSPCSeqNo,ORGSPCPYCode,ORGSPCWBCode,ORGSPCMark)
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
/// Tables: CT_BDP_CT.HOS_OrgSpecCategory
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgSpecCategory", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGSPCCode,ORGSPCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s:code'="" code=$zcvt(code,"U")  
  	s:desc'="" desc=$zcvt(desc,"U")  
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),2)	//组织机构专业分类代码
    	s ORGSPCDesc= $listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),3)	//组织机构专业分类名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgSpecCategoryD(ID))
       		q:ID="" 
       		s ORGSPCCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),2)	//组织机构专业分类代码
	    	s ORGSPCDesc= $listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),3)	//组织机构专业分类名称
	    	
			s ORGSPCActivity=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),6) 	//是否有效(Y/N)
			continue:ORGSPCActivity="N"
	    	s ORGSPCStartDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),7) 		//开始日期
	    	continue:(ORGSPCStartDate'="")&&(ORGSPCStartDate>+$h)
			s ORGSPCEndDate=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),8) 		//结束日期
	  		continue:(ORGSPCEndDate'="")&&(ORGSPCEndDate<+$h)

       		s ORGSPCPYCode=$listget($g(^CT.BDP.CT.HOSOrgSpecCategoryD(ID)),16) 		//拼音码
		
            if (($zcvt(ORGSPCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGSPCDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGSPCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
	        	d OutputRowCmb
	    	}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGSPCCode,ORGSPCDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgSpecCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgSpecCategory).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgSpecCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGSPCCode=pobj.ORGSPCCode	//组织机构专业分类代码
    s eobj.ORGSPCDesc= pobj.ORGSPCDesc	//组织机构专业分类名称
    if $IsObject(pobj.ORGSPCORGSPCCode){
		s eobj.ORGSPCORGSPCCode = pobj.ORGSPCORGSPCCode.%Id() 	//组织机构小类-外键
	}
	s eobj.ORGSPCSource=pobj.ORGSPCSource		//分类来源
	s eobj.ORGSPCActivity=pobj.ORGSPCActivity	//是否有效(Y/N)
	s eobj.ORGSPCStartDate=pobj.ORGSPCStartDate		//开始日期
	s:eobj.ORGSPCStartDate'="" eobj.ORGSPCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGSPCStartDate) 
	s eobj.ORGSPCEndDate=pobj.ORGSPCEndDate		//结束日期
	s:eobj.ORGSPCEndDate'="" eobj.ORGSPCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGSPCEndDate) 
	s eobj.ORGSPCSeqNo=pobj.ORGSPCSeqNo		//系统排序号
	
	s eobj.ORGSPCPYCode=pobj.ORGSPCPYCode		//拼音码
	s eobj.ORGSPCWBCode=pobj.ORGSPCWBCode		//五笔码
	s eobj.ORGSPCMark=pobj.ORGSPCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgSpecCategory
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgSpecCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgSpecCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgSpecCategoryI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构专业分类内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgSpecCategory
/// Input：     web.Entity.CT.HOSOrgSpecCategory  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgSpecCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgSpecCategory) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGSPCStartDate'="" eobj.ORGSPCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGSPCStartDate) 
    s:eobj.ORGSPCEndDate'="" eobj.ORGSPCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGSPCEndDate)
    
    s:eobj.ORGSPCLastUpdateDate="" eobj.ORGSPCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGSPCLastUpdateTime="" eobj.ORGSPCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGSPCLastUpdateUser="" eobj.ORGSPCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGSPCActivity="" eobj.ORGSPCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGSPCCode,eobj.ORGSPCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgSpecCategory).%New()
            //s eobj.ORGSPCSeqNo=..GetSeqNo()
            s:eobj.ORGSPCCreateDate="" eobj.ORGSPCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGSPCCreateTime="" eobj.ORGSPCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGSPCCreateUser="" eobj.ORGSPCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGSPCCreateDate=eobj.ORGSPCCreateDate		//系统创建日期
			s obj.ORGSPCCreateTime=eobj.ORGSPCCreateTime		//系统创建时间
			d obj.ORGSPCCreateUserSetObjectId(eobj.ORGSPCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgSpecCategory).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgSpecCategory).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGSPCCode=obj.ORGSPCCode	//组织机构专业分类代码
            s bobj.ORGSPCDesc= obj.ORGSPCDesc	//组织机构专业分类名称
            if $IsObject(obj.ORGSPCORGSPCCode){
				s bobj.ORGSPCORGSPCCode = obj.ORGSPCORGSPCCode.%Id() 	//组织机构小类-外键
			}
			s bobj.ORGSPCSource=obj.ORGSPCSource		//分类来源
			s bobj.ORGSPCActivity=obj.ORGSPCActivity	//是否有效(Y/N)
			s bobj.ORGSPCStartDate=obj.ORGSPCStartDate		//开始日期
			s bobj.ORGSPCEndDate=obj.ORGSPCEndDate		//结束日期
			s bobj.ORGSPCCreateDate=obj.ORGSPCCreateDate		//系统创建日期
			s bobj.ORGSPCCreateTime=obj.ORGSPCCreateTime		//系统创建时间
			if $IsObject(obj.ORGSPCCreateUser){
				s bobj.ORGSPCCreateUser = obj.ORGSPCCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGSPCSeqNo=obj.ORGSPCSeqNo		//系统排序号
			s bobj.ORGSPCLastUpdateDate=obj.ORGSPCLastUpdateDate		//系统最后更新日期
			s bobj.ORGSPCLastUpdateTime=obj.ORGSPCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGSPCLastUpdateUser){
				s bobj.ORGSPCLastUpdateUser = obj.ORGSPCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGSPCPYCode=obj.ORGSPCPYCode		//拼音码
			s bobj.ORGSPCWBCode=obj.ORGSPCWBCode		//五笔码
			s bobj.ORGSPCMark=obj.ORGSPCMark		//备注

        }
        
        s obj.ORGSPCCode=eobj.ORGSPCCode	//组织机构专业分类代码
        s obj.ORGSPCDesc= eobj.ORGSPCDesc	//组织机构专业分类名称
		d obj.ORGSPCORGSPCCodeSetObjectId(eobj.ORGSPCORGSPCCode)	//组织机构小类-外键
		
		s obj.ORGSPCSource=eobj.ORGSPCSource		//分类来源
		s obj.ORGSPCActivity=eobj.ORGSPCActivity	//是否有效(Y/N)
		s obj.ORGSPCStartDate=eobj.ORGSPCStartDate		//开始日期
		s obj.ORGSPCEndDate=eobj.ORGSPCEndDate		//结束日期
		
		s obj.ORGSPCSeqNo=eobj.ORGSPCSeqNo		//系统排序号
		s obj.ORGSPCLastUpdateDate=eobj.ORGSPCLastUpdateDate		//系统最后更新日期
		s obj.ORGSPCLastUpdateTime=eobj.ORGSPCLastUpdateTime		//系统最后更新时间
		d obj.ORGSPCLastUpdateUserSetObjectId(eobj.ORGSPCLastUpdateUser)	//系统最新更新人
		s:eobj.ORGSPCPYCode="" eobj.ORGSPCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGSPCDesc)
		s obj.ORGSPCPYCode=eobj.ORGSPCPYCode		//拼音码
		s:eobj.ORGSPCWBCode="" eobj.ORGSPCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGSPCDesc,1)
		s obj.ORGSPCWBCode=eobj.ORGSPCWBCode		//五笔码
		s obj.ORGSPCMark=eobj.ORGSPCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSpecCategory","CT.BDP.CT.HOSOrgSpecCategory","组织机构专业分类",id,eobj.ORGSPCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSpecCategory","CT.BDP.CT.HOSOrgSpecCategory","组织机构专业分类",eobj.ID,eobj.ORGSPCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构专业分类","web.DHCBL.CT.HOSOrgSpecCategory","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgSpecCategory).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGSPCCode",id)){
        s myInfo=myInfo_"<组织结构树>"
    } 
 
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构专业分类的内容
/// Table：CT.BDP.CT.HOSOrgSpecCategory
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgSpecCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgSpecCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgSpecCategory).%New()
    s eobj.ID = id
    s eobj.ORGSPCCode=pobj.ORGSPCCode	//组织机构专业分类代码
    s eobj.ORGSPCDesc= pobj.ORGSPCDesc	//组织机构专业分类名称
	if $IsObject(pobj.ORGSPCORGSPCCode){
		s eobj.ORGSPCORGSPCCode = pobj.ORGSPCORGSPCCode.%Id() 	//组织机构小类-外键
	}	
	s eobj.ORGSPCSource=pobj.ORGSPCSource		//分类来源
	s eobj.ORGSPCActivity=pobj.ORGSPCActivity	//是否有效(Y/N)
	s eobj.ORGSPCStartDate=pobj.ORGSPCStartDate		//开始日期
	s eobj.ORGSPCEndDate=pobj.ORGSPCEndDate		//结束日期
	
	s eobj.ORGSPCSeqNo=pobj.ORGSPCSeqNo		//系统排序号
	
	s eobj.ORGSPCPYCode=pobj.ORGSPCPYCode		//拼音码
	s eobj.ORGSPCWBCode=pobj.ORGSPCWBCode		//五笔码
	s eobj.ORGSPCMark=pobj.ORGSPCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgSpecCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgSpecCategory","CT.BDP.CT.HOSOrgSpecCategory","组织机构专业分类",id,eobj.ORGSPCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构专业分类","web.DHCBL.CT.HOSOrgSpecCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
