/// Function: 业务岗位
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSPost Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  业务岗位信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_Post   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPost","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,POSTCode,POSTDesc,POSTBUCode,POSTPOSTCCode,POSTActivity,POSTStartDate,POSTEndDate,POSTSeqNo,POSTPYCode,POSTWBCode,POSTMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPost).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s POSTCCodeAuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s POSTCCodeAuFlag=0	
	if (POSTCCodeAuStr="")||(POSTCCodeAuStr["limited:0") s POSTCCodeAuFlag=1
	s BUCodeAuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	s BUCodeAuFlag=0	
	if (BUCodeAuStr="")||(BUCodeAuStr["limited:0") s BUCodeAuFlag=1
	
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//业务岗位代码
	    s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//业务岗位名称
	    
		s POSTBUCode = $listget($g(^CT.BDP.CT.HOSPostD(ID)),4) 	//业务单元代码-外键
		s:POSTBUCode'="" POSTBUCode=$p($g(^CTLOC(POSTBUCode)),"^",2)
		s POSTPOSTCCode =$listget($g(^CT.BDP.CT.HOSPostD(ID)),5) 	//岗位字典代码-外键
		s:POSTPOSTCCode'="" POSTPOSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(POSTPOSTCCode)),3)	//岗位名称
		
	
		s POSTActivity=$listget($g(^CT.BDP.CT.HOSPostD(ID)),6) 	//是否有效(Y/N)
		s POSTStartDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),7) 		//开始日期
		s:POSTStartDate'="" POSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTStartDate) 
		s POSTEndDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),8) 		//结束日期
		s:POSTEndDate'="" POSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTEndDate) 
		
		s POSTSeqNo=$listget($g(^CT.BDP.CT.HOSPostD(ID)),12) 		//系统排序号

		s POSTPYCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),16) 		//拼音码
		s POSTWBCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),17) 		//五笔码
		s POSTMark=$listget($g(^CT.BDP.CT.HOSPostD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=""
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPostD(ID))
            q:ID="" 
            s POSTBUCode = $listget($g(^CT.BDP.CT.HOSPostD(ID)),4) 	//业务单元代码-外键
            s POSTPOSTCCode =$listget($g(^CT.BDP.CT.HOSPostD(ID)),5) 	//岗位字典代码-外键
            s strRowId = "{ID:"_ID_"}"
            s BUCodestrRowId = "{ID:"_POSTBUCode_"}"
            s POSTCCodestrRowId = "{ID:"_POSTPOSTCCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((BUCodeAuStr[BUCodestrRowId)||(BUCodeAuFlag=1))&&((POSTCCodeAuStr[POSTCCodestrRowId)||(POSTCCodeAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
	            s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//业务岗位代码
			    s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//业务岗位名称
			    
				
				s:POSTBUCode'="" POSTBUCode=$p($g(^CTLOC(POSTBUCode)),"^",2)
				
				s:POSTPOSTCCode'="" POSTPOSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(POSTPOSTCCode)),3)	//岗位名称
				
			
				s POSTActivity=$listget($g(^CT.BDP.CT.HOSPostD(ID)),6) 	//是否有效(Y/N)
				s POSTStartDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),7) 		//开始日期
				s:POSTStartDate'="" POSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTStartDate) 
				s POSTEndDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),8) 		//结束日期
				s:POSTEndDate'="" POSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTEndDate) 
				
				s POSTSeqNo=$listget($g(^CT.BDP.CT.HOSPostD(ID)),12) 		//系统排序号

				s POSTPYCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),16) 		//拼音码
				s POSTWBCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),17) 		//五笔码
				s POSTMark=$listget($g(^CT.BDP.CT.HOSPostD(ID)),18) 		//备注
	            if (($zcvt(POSTCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSTDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSTPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POSTCode,POSTDesc,POSTBUCode,POSTPOSTCCode,POSTActivity,POSTStartDate,POSTEndDate,POSTSeqNo,POSTPYCode,POSTWBCode,POSTMark)
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
/// Tables: CT_BDP_CT.HOS_Post
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPost", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSTCode,POSTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSPost).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s POSTCCodeAuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s POSTCCodeAuFlag=0	
	if (POSTCCodeAuStr="")||(POSTCCodeAuStr["limited:0") s POSTCCodeAuFlag=1
	s BUCodeAuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
	s BUCodeAuFlag=0	
	if (BUCodeAuStr="")||(BUCodeAuStr["limited:0") s BUCodeAuFlag=1
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//业务岗位代码
    	s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//业务岗位名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSPostD(ID))
       		q:ID=""
       		s POSTBUCode = $listget($g(^CT.BDP.CT.HOSPostD(ID)),4) 	//业务单元代码-外键
            s POSTPOSTCCode =$listget($g(^CT.BDP.CT.HOSPostD(ID)),5) 	//岗位字典代码-外键
            s strRowId = "{ID:"_ID_"}"
            s BUCodestrRowId = "{ID:"_POSTBUCode_"}"
            s POSTCCodestrRowId = "{ID:"_POSTPOSTCCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((BUCodeAuStr[BUCodestrRowId)||(BUCodeAuFlag=1))&&((POSTCCodeAuStr[POSTCCodestrRowId)||(POSTCCodeAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{  
	       		s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//业务岗位代码
		    	s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//业务岗位名称
		    
				s POSTActivity=$listget($g(^CT.BDP.CT.HOSPostD(ID)),6) 	//是否有效(Y/N)
				continue:POSTActivity="N"
		    	s POSTStartDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),7) 		//开始日期
		    	continue:(POSTStartDate'="")&&(POSTStartDate>+$h)
				s POSTEndDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),8) 		//结束日期
		  		continue:(POSTEndDate'="")&&(POSTEndDate<+$h)
				s POSTPYCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),16) 		//拼音码
				
	       		if (($zcvt(POSTCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSTDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSTPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSTCode,POSTDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSPost).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPost).%New()
    s pobj = ##class(CT.BDP.CT.HOSPost).%OpenId(id)
    s eobj.ID=id
    s eobj.POSTCode=pobj.POSTCode	//业务岗位代码
    s eobj.POSTDesc= pobj.POSTDesc	//业务岗位名称
    if $IsObject(pobj.POSTBUCode){
		s eobj.POSTBUCode = pobj.POSTBUCode.%Id() 	//业务单元代码-外键
	}
	if $IsObject(pobj.POSTPOSTCCode){
		s eobj.POSTPOSTCCode = pobj.POSTPOSTCCode.%Id() 	//岗位字典代码-外键
	}  
	
	s eobj.POSTActivity=pobj.POSTActivity	//是否有效(Y/N)
	s eobj.POSTStartDate=pobj.POSTStartDate		//开始日期
	s:eobj.POSTStartDate'="" eobj.POSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSTStartDate) 
	s eobj.POSTEndDate=pobj.POSTEndDate		//结束日期
	s:eobj.POSTEndDate'="" eobj.POSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSTEndDate) 
	s eobj.POSTSeqNo=pobj.POSTSeqNo		//系统排序号
	
	s eobj.POSTPYCode=pobj.POSTPYCode		//拼音码
	s eobj.POSTWBCode=pobj.POSTWBCode		//五笔码
	s eobj.POSTMark=pobj.POSTMark		//备注
	s eobj.POROROLECode=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTROLE",id,""))	//取第一个
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPost
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPost).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSPostI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存业务岗位内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPost
/// Input：     web.Entity.CT.HOSPost  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPost).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPost) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.POSTStartDate'="" eobj.POSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSTStartDate) 
    s:eobj.POSTEndDate'="" eobj.POSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSTEndDate)
    s:eobj.POSTStartDate="" eobj.POSTStartDate=+$h
    s:eobj.POSTLastUpdateDate="" eobj.POSTLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.POSTLastUpdateTime="" eobj.POSTLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.POSTLastUpdateUser="" eobj.POSTLastUpdateUser=UserID	//系统最新更新人
    s:eobj.POSTActivity="" eobj.POSTActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.POSTCode,eobj.POSTDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPost).%New()
            //s eobj.POSTSeqNo=..GetSeqNo()
            s:eobj.POSTCreateDate="" eobj.POSTCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.POSTCreateTime="" eobj.POSTCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.POSTCreateUser="" eobj.POSTCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.POSTCreateDate=eobj.POSTCreateDate		//系统创建日期
			s obj.POSTCreateTime=eobj.POSTCreateTime		//系统创建时间
			d obj.POSTCreateUserSetObjectId(eobj.POSTCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPost).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPost).%New()
            s bobj.ID=eobj.ID 
            s bobj.POSTCode=obj.POSTCode	//业务岗位代码
            s bobj.POSTDesc= obj.POSTDesc	//业务岗位名称
            if $IsObject(obj.POSTBUCode){
				s bobj.POSTBUCode = obj.POSTBUCode.%Id() 	//业务单元代码-外键
			}
			if $IsObject(obj.POSTPOSTCCode){
				s bobj.POSTPOSTCCode = obj.POSTPOSTCCode.%Id() 	//岗位字典代码-外键
			}  
			s bobj.POSTActivity=obj.POSTActivity	//是否有效(Y/N)
			s bobj.POSTStartDate=obj.POSTStartDate		//开始日期
			s bobj.POSTEndDate=obj.POSTEndDate		//结束日期
			s bobj.POSTCreateDate=obj.POSTCreateDate		//系统创建日期
			s bobj.POSTCreateTime=obj.POSTCreateTime		//系统创建时间
			if $IsObject(obj.POSTCreateUser){
				s bobj.POSTCreateUser = obj.POSTCreateUser.%Id() 	//系统创建人
			}
			s bobj.POSTSeqNo=obj.POSTSeqNo		//系统排序号
			s bobj.POSTLastUpdateDate=obj.POSTLastUpdateDate		//系统最后更新日期
			s bobj.POSTLastUpdateTime=obj.POSTLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.POSTLastUpdateUser){
				s bobj.POSTLastUpdateUser = obj.POSTLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.POSTPYCode=obj.POSTPYCode		//拼音码
			s bobj.POSTWBCode=obj.POSTWBCode		//五笔码
			s bobj.POSTMark=obj.POSTMark		//备注

        }
        
        s obj.POSTCode=eobj.POSTCode	//业务岗位代码
        s obj.POSTDesc= eobj.POSTDesc	//业务岗位名称
		d obj.POSTBUCodeSetObjectId(eobj.POSTBUCode) 	//业务单元代码-外键
		d obj.POSTPOSTCCodeSetObjectId(eobj.POSTPOSTCCode) 	//岗位字典代码-外键
		s obj.POSTActivity=eobj.POSTActivity	//是否有效(Y/N)
		s obj.POSTStartDate=eobj.POSTStartDate		//开始日期
		s obj.POSTEndDate=eobj.POSTEndDate		//结束日期
		
		s obj.POSTSeqNo=eobj.POSTSeqNo		//系统排序号
		s obj.POSTLastUpdateDate=eobj.POSTLastUpdateDate		//系统最后更新日期
		s obj.POSTLastUpdateTime=eobj.POSTLastUpdateTime		//系统最后更新时间
		d obj.POSTLastUpdateUserSetObjectId(eobj.POSTLastUpdateUser)	//系统最新更新人
		s:eobj.POSTPYCode="" eobj.POSTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.POSTDesc)
		s obj.POSTPYCode=eobj.POSTPYCode		//拼音码
		s:eobj.POSTWBCode="" eobj.POSTWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.POSTDesc,1)
		s obj.POSTWBCode=eobj.POSTWBCode		//五笔码
		s obj.POSTMark=eobj.POSTMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Post","CT.BDP.CT.HOSPost","业务岗位",id,eobj.POSTDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Post","CT.BDP.CT.HOSPost","业务岗位",eobj.ID,eobj.POSTDesc,"U",eobj,bobj)
        	if (eobj.POROROLECode'="")
        	{
	        	s reobj=##class(web.Entity.CT.HOSPostRole).%New()
	            s reobj.ID=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTCode",id,""))
			    s reobj.POROPOSTCode = id
			    s reobj.POROROLECode = eobj.POROROLECode
			    s reobj.POROActivity = "Y" 
			    s reobj.POROStartDate= +$h 
		    	d ##class(web.DHCBL.CT.HOSPostRole).SaveEntity(reobj)
        	}
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("业务岗位","web.DHCBL.CT.HOSPost","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSPost
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSPost).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSPostI("IndexSeqNo",""),-1)
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
/// Other:w ##class(web.DHCBL.CT.HOSPost).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
     if $d(^CT.BDP.CT.HOSPostRelBusPostI("IndexPPRPPostCode",id)){
        s myInfo=myInfo_"<流程岗位与业务岗位关系>"
    }
    if $d(^CT.BDP.CT.HOSEmpPostI("IndexPOSCode",id)){
        s myInfo=myInfo_"<人员岗位>"
    }
    if $d(^User.HOSUserAccountPostI("IndexPostCode",id)){
        s myInfo=myInfo_"<系统账户岗位>"
    }
    if $d(^CT.BDP.CT.HOSPostRoleI("IndexPOSTCode",id)){
        s myInfo=myInfo_"<岗位关联角色>"
    }
    
      
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除业务岗位的内容
/// Table：CT.BDP.CT.HOSPost
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPost).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
	    /*
	    //删除岗位关联角色
	     s ID=""
	     for
	     {
		  	s ID= $o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTCode",id,ID))  
		  	q:ID=""
		  	d ##class(web.DHCBL.CT.HOSPostRole).DeleteData(ID)
	     }
	   */
	     
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSPost).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPost).%New()
    s eobj.ID = id
    s eobj.POSTCode=pobj.POSTCode	//业务岗位代码
    s eobj.POSTDesc= pobj.POSTDesc	//业务岗位名称
    if $IsObject(pobj.POSTBUCode){
		s eobj.POSTBUCode = pobj.POSTBUCode.%Id() 	//业务单元代码-外键
	}
	if $IsObject(pobj.POSTPOSTCCode){
		s eobj.POSTPOSTCCode = pobj.POSTPOSTCCode.%Id() 	//岗位字典代码-外键
	}  
	
	s eobj.POSTActivity=pobj.POSTActivity	//是否有效(Y/N)
	
	s eobj.POSTActivity=pobj.POSTActivity	//是否有效(Y/N)
	s eobj.POSTStartDate=pobj.POSTStartDate		//开始日期
	s eobj.POSTEndDate=pobj.POSTEndDate		//结束日期

	s eobj.POSTSeqNo=pobj.POSTSeqNo		//系统排序号

	s eobj.POSTPYCode=pobj.POSTPYCode		//拼音码
	s eobj.POSTWBCode=pobj.POSTWBCode		//五笔码
	s eobj.POSTMark=pobj.POSTMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPost).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Post","CT.BDP.CT.HOSPost","业务岗位",id,eobj.POSTDesc,"D",eobj)
        d eobj.%Close()
        
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("业务岗位","web.DHCBL.CT.HOSPost","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
