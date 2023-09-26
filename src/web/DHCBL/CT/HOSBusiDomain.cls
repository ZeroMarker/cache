/// Function: 业务域
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSBusiDomain Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  业务域信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_Busi_Domain   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSBusiDomain","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, parentid) As %Query(ROWSPEC = "ID,DomainCode,DomainDesc,DomainParentCode,DomainLevel,DomainActivity,DomainStartDate,DomainEndDate,DomainSeqNo,DomainPYCode,DomainWBCode,DomainMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, parentid) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s AuFlag=0	
	s ParAuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s ParAuFlag=1
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s DomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),2)	//业务域代码
	    s DomainDesc= $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),3)	//业务域名称
	    
		s DomainParentCode = $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),4) 	//父级业务域代码-外键
		s:DomainParentCode'="" DomainParentCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(DomainParentCode)),3)
		
		s DomainLevel=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),5) 		//业务域层级
		s DomainActivity=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),6) 	//是否有效(Y/N)
		s DomainStartDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),7) 		//开始日期
		s:DomainStartDate'="" DomainStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DomainStartDate) 
		s DomainEndDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),8) 		//结束日期
		s:DomainEndDate'="" DomainEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DomainEndDate) 
		
		s DomainSeqNo=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),12) 		//系统排序号

		s DomainPYCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),16) 		//拼音码
		s DomainWBCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),17) 		//五笔码
		s DomainMark=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSBusiDomainD(ID))
            q:ID=""
            s DomainParentCode = $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),4) 	//父级业务域代码-外键
            s strRowId = "{ID:"_ID_"}"
            s ParentCodestrRowId=""
            s:DomainParentCode'="" ParentCodestrRowId = "{ID:"_DomainParentCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((AuStr[ParentCodestrRowId)||(ParAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
	            s DomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),2)	//业务域代码
			    s DomainDesc= $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),3)	//业务域名称
			    
				
				continue:((parentid'="")&&(parentid'=DomainParentCode))
				s:DomainParentCode'="" DomainParentCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(DomainParentCode)),3)
				
				s DomainLevel=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),5) 		//业务域层级
				s DomainActivity=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),6) 	//是否有效(Y/N)
				s DomainStartDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),7) 		//开始日期
				s:DomainStartDate'="" DomainStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DomainStartDate) 
				s DomainEndDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),8) 		//结束日期
				s:DomainEndDate'="" DomainEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DomainEndDate) 
				
				
				s DomainSeqNo=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),12) 		//系统排序号
				
				s DomainPYCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),16) 		//拼音码
				s DomainWBCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),17) 		//五笔码
				s DomainMark=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),18) 		//备注
			
	            if (($zcvt(DomainCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(DomainDesc,"U")[$zcvt(desc,"U"))||($zcvt(DomainPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            } 
			} 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,DomainCode,DomainDesc,DomainParentCode,DomainLevel,DomainActivity,DomainStartDate,DomainEndDate,DomainSeqNo,DomainPYCode,DomainWBCode,DomainMark)
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
/// Tables: CT_BDP_CT.HOS_Busi_Domain
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSBusiDomain", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,DomainCode,DomainDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s AuFlag=0	
	s ParAuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s ParAuFlag=1
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s DomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),2)	//业务域代码
    	s DomainDesc= $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),3)	//业务域名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSBusiDomainD(ID))
       		q:ID="" 
       		s DomainParentCode = $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),4) 	//父级业务域代码-外键
            s strRowId = "{ID:"_ID_"}"
            s ParentCodestrRowId=""
            s:DomainParentCode'="" ParentCodestrRowId = "{ID:"_DomainParentCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[ParentCodestrRowId)||(ParAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
	       		s DomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),2)	//业务域代码
		    	s DomainDesc= $listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),3)	//业务域名称
		    
				s DomainActivity=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),6) 	//是否有效(Y/N)
				continue:DomainActivity="N"
		    	s DomainStartDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),7) 		//开始日期
		    	continue:(DomainStartDate'="")&&(DomainStartDate>+$h)
				s DomainEndDate=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),8) 		//结束日期
		  		continue:(DomainEndDate'="")&&(DomainEndDate<+$h)
				s DomainPYCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(ID)),16)
		    	if (($zcvt(DomainCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(DomainDesc,"U")[$zcvt(desc,"U"))||($zcvt(DomainPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,DomainCode,DomainDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSBusiDomain).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSBusiDomain).%New()
    s pobj = ##class(CT.BDP.CT.HOSBusiDomain).%OpenId(id)
    s eobj.ID=id
    s eobj.DomainCode=pobj.DomainCode	//业务域代码
    s eobj.DomainDesc= pobj.DomainDesc	//业务域名称
    if $IsObject(pobj.DomainParentCode){
		s eobj.DomainParentCode = pobj.DomainParentCode.%Id() 	//父级业务域代码-外键
	}  
	s eobj.DomainLevel=pobj.DomainLevel		//业务域层级
	s eobj.DomainActivity=pobj.DomainActivity	//是否有效(Y/N)
	s eobj.DomainStartDate=pobj.DomainStartDate		//开始日期
	s:eobj.DomainStartDate'="" eobj.DomainStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DomainStartDate) 
	s eobj.DomainEndDate=pobj.DomainEndDate		//结束日期
	s:eobj.DomainEndDate'="" eobj.DomainEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DomainEndDate) 
	s eobj.DomainSeqNo=pobj.DomainSeqNo		//系统排序号
	
	s eobj.DomainPYCode=pobj.DomainPYCode		//拼音码
	s eobj.DomainWBCode=pobj.DomainWBCode		//五笔码
	s eobj.DomainMark=pobj.DomainMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSBusiDomain
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSBusiDomain).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, parentcode) As %String
{
    s flag=0
    s:parentcode="" parentcode="-100000000000000"
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSBusiDomainI("IndexParCode",parentcode,code,0))
	    if ((idc'="")&&(idc'=id))
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSBusiDomainI("IndexParDesc",parentcode,desc,0)) 
		if ((idd'="")&&(idd'=id))
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存业务域内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSBusiDomain
/// Input：     web.Entity.CT.HOSBusiDomain  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSBusiDomain).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSBusiDomain) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.DomainStartDate'="" eobj.DomainStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DomainStartDate) 
    s:eobj.DomainEndDate'="" eobj.DomainEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DomainEndDate)
    s:eobj.DomainStartDate="" eobj.DomainStartDate=+$h
    s:eobj.DomainLastUpdateDate="" eobj.DomainLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.DomainLastUpdateTime="" eobj.DomainLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.DomainLastUpdateUser="" eobj.DomainLastUpdateUser=UserID	//系统最新更新人
    s:eobj.DomainActivity="" eobj.DomainActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.DomainCode,eobj.DomainDesc,eobj.DomainParentCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSBusiDomain).%New()
            //s eobj.DomainSeqNo=..GetSeqNo()
            s:eobj.DomainCreateDate="" eobj.DomainCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.DomainCreateTime="" eobj.DomainCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.DomainCreateUser="" eobj.DomainCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.DomainCreateDate=eobj.DomainCreateDate		//系统创建日期
			s obj.DomainCreateTime=eobj.DomainCreateTime		//系统创建时间
			d obj.DomainCreateUserSetObjectId(eobj.DomainCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSBusiDomain).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSBusiDomain).%New()
            s bobj.ID=eobj.ID 
            s bobj.DomainCode=obj.DomainCode	//业务域代码
            s bobj.DomainDesc= obj.DomainDesc	//业务域名称
            if $IsObject(obj.DomainParentCode){
				s bobj.DomainParentCode = obj.DomainParentCode.%Id() 	//父级业务域代码-外键
			}  
			s bobj.DomainLevel=obj.DomainLevel		//业务域层级
			s bobj.DomainActivity=obj.DomainActivity	//是否有效(Y/N)
			s bobj.DomainStartDate=obj.DomainStartDate		//开始日期
			s bobj.DomainEndDate=obj.DomainEndDate		//结束日期
			s bobj.DomainCreateDate=obj.DomainCreateDate		//系统创建日期
			s bobj.DomainCreateTime=obj.DomainCreateTime		//系统创建时间
			if $IsObject(obj.DomainCreateUser){
				s bobj.DomainCreateUser = obj.DomainCreateUser.%Id() 	//系统创建人
			}
			s bobj.DomainSeqNo=obj.DomainSeqNo		//系统排序号
			s bobj.DomainLastUpdateDate=obj.DomainLastUpdateDate		//系统最后更新日期
			s bobj.DomainLastUpdateTime=obj.DomainLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.DomainLastUpdateUser){
				s bobj.DomainLastUpdateUser = obj.DomainLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.DomainPYCode=obj.DomainPYCode		//拼音码
			s bobj.DomainWBCode=obj.DomainWBCode		//五笔码
			s bobj.DomainMark=obj.DomainMark		//备注

        }
        
        s obj.DomainCode=eobj.DomainCode	//业务域代码
        s obj.DomainDesc= eobj.DomainDesc	//业务域名称
        d obj.DomainParentCodeSetObjectId(eobj.DomainParentCode)	//父级业务域代码-外键
		s obj.DomainLevel=eobj.DomainLevel		//业务域层级
		s obj.DomainActivity=eobj.DomainActivity	//是否有效(Y/N)
		s obj.DomainStartDate=eobj.DomainStartDate		//开始日期
		s obj.DomainEndDate=eobj.DomainEndDate		//结束日期
		
		s obj.DomainSeqNo=eobj.DomainSeqNo		//系统排序号
		s obj.DomainLastUpdateDate=eobj.DomainLastUpdateDate		//系统最后更新日期
		s obj.DomainLastUpdateTime=eobj.DomainLastUpdateTime		//系统最后更新时间
		d obj.DomainLastUpdateUserSetObjectId(eobj.DomainLastUpdateUser)	//系统最新更新人
		s:eobj.DomainPYCode="" eobj.DomainPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.DomainDesc)
		s obj.DomainPYCode=eobj.DomainPYCode		//拼音码
		s:eobj.DomainWBCode="" eobj.DomainWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.DomainDesc,1)
		s obj.DomainWBCode=eobj.DomainWBCode		//五笔码
		s obj.DomainMark=eobj.DomainMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Busi_Domain","CT.BDP.CT.HOSBusiDomain","业务域",id,eobj.DomainDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Busi_Domain","CT.BDP.CT.HOSBusiDomain","业务域",eobj.ID,eobj.DomainDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("业务域","web.DHCBL.CT.HOSBusiDomain","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSBusiDomain
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSBusiDomain).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSBusiDomainI("IndexSeqNo",""),-1)
	if (seq="")
	{
		s seq=1
	}
	else
	{
		s seq=seq+1
	}
	q seq
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：删除限制
/// Table：CT.BDP.CT.HOSPost
/// Input：id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSBusiDomain).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.HOSBusiDomainI("IndexParentCode",id)){
        s myInfo=myInfo_"<业务域>"
    }   
    if $d(^CTLOC(0,"DomainCode",id)){
        s myInfo=myInfo_"<组织业务单元>"
    }
	if $d(^CT.BDP.CT.HOSPostDictI("IndexDomainCode",id)){
        s myInfo=myInfo_"<岗位字典>"
    }
    
    if $d(^CT.BDP.CT.HOSPostHeadWordI("IndexDomainCode",id)){
        s myInfo=myInfo_"<岗位中心词>"
    }

    if $d(^CT.BDP.CT.HOSFlowHeadWordI("IndexDomainCode",id)){
        s myInfo=myInfo_"<流程中心词>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除业务域的内容
/// Table：CT.BDP.CT.HOSBusiDomain
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSBusiDomain).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSBusiDomain).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSBusiDomain).%New()
    s eobj.ID = id
    s eobj.DomainCode=pobj.DomainCode	//业务域代码
    s eobj.DomainDesc= pobj.DomainDesc	//业务域名称
    if $IsObject(pobj.DomainParentCode){
		s eobj.DomainParentCode = pobj.DomainParentCode.%Id() 	//父级业务域代码-外键
	}  
	s eobj.DomainLevel=pobj.DomainLevel		//业务域层级
	s eobj.DomainActivity=pobj.DomainActivity	//是否有效(Y/N)
	s eobj.DomainStartDate=pobj.DomainStartDate		//开始日期
	s eobj.DomainEndDate=pobj.DomainEndDate		//结束日期
	
	s eobj.DomainSeqNo=pobj.DomainSeqNo		//系统排序号
	
	s eobj.DomainPYCode=pobj.DomainPYCode		//拼音码
	s eobj.DomainWBCode=pobj.DomainWBCode		//五笔码
	s eobj.DomainMark=pobj.DomainMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSBusiDomain).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Busi_Domain","CT.BDP.CT.HOSBusiDomain","业务域",id,eobj.DomainDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("业务域","web.DHCBL.CT.HOSBusiDomain","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
