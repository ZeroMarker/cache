/// Function: 组织职位
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSPosition Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织职位信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_Position   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPosition","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,POSCode,POSDesc,POSDeptCode,POSPOSCCode,POSLimitedNum,POSActivity,POSStartDate,POSEndDate,POSSeqNo,POSPYCode,POSWBCode,POSMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPosition).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
	
	s PositionDictAuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s PositionDictAuFlag=0	
	if (PositionDictAuStr="")||(PositionDictAuStr["limited:0") s PositionDictAuFlag=1
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s POSCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),2)	//组织职位代码
	    s POSDesc= $listget($g(^CT.BDP.CT.HOSPositionD(ID)),3)	//组织职位名称
	    
	    s POSDeptCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),4) 	//所属部门-外键
		s:POSDeptCode'="" POSDeptCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(POSDeptCode)),3)
		s POSPOSCCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),5) 	//职位字典-外键
		s:POSPOSCCode'="" POSPOSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(POSPOSCCode)),3)	
		
		s POSLimitedNum=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),6)		//额定人数
	
		s POSActivity=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),7) 	//是否有效(Y/N)
		s POSStartDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),8) 		//开始日期
		s:POSStartDate'="" POSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSStartDate) 
		s POSEndDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),9) 		//结束日期
		s:POSEndDate'="" POSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSEndDate) 
		
		s POSSeqNo=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),13) 		//系统排序号

		s POSPYCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),17) 		//拼音码
		s POSWBCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),18) 		//五笔码
		s POSMark=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),19) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPositionD(ID))
            q:ID="" 
            s POSDeptCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),4) 	//所属部门-外键
            s POSPOSCCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),5) 	//职位字典-外键
            s strRowId = "{ID:"_ID_"}"
            s DeptCodestrRowId = "{ID:"_POSDeptCode_"}"
            s POSCCodestrRowId = "{ID:"_POSPOSCCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((DepartmentAuStr[DeptCodestrRowId)||(DepartmentAuFlag=1))&&((PositionDictAuStr[POSCCodestrRowId)||(PositionDictAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
			
	            s POSCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),2)	//组织职位代码
			    s POSDesc= $listget($g(^CT.BDP.CT.HOSPositionD(ID)),3)	//组织职位名称
			    
			    
				s:POSDeptCode'="" POSDeptCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(POSDeptCode)),3)
				
				s:POSPOSCCode'="" POSPOSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(POSPOSCCode)),3)	
				
				s POSLimitedNum=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),6)		//额定人数
			
				s POSActivity=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),7) 	//是否有效(Y/N)
				s POSStartDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),8) 		//开始日期
				s:POSStartDate'="" POSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSStartDate) 
				s POSEndDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),9) 		//结束日期
				s:POSEndDate'="" POSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSEndDate) 
				
				s POSSeqNo=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),13) 		//系统排序号

				s POSPYCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),17) 		//拼音码
				s POSWBCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),18) 		//五笔码
				s POSMark=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),19) 		//备注
				
	            if (($zcvt(POSCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            } 
			} 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POSCode,POSDesc,POSDeptCode,POSPOSCCode,POSLimitedNum,POSActivity,POSStartDate,POSEndDate,POSSeqNo,POSPYCode,POSWBCode,POSMark)
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
/// Tables: CT_BDP_CT.HOS_Position
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPosition", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSCode,POSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSPosition).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
	
	s PositionDictAuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s PositionDictAuFlag=0	
	if (PositionDictAuStr="")||(PositionDictAuStr["limited:0") s PositionDictAuFlag=1 
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s POSCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),2)	//组织职位代码
    	s POSDesc= $listget($g(^CT.BDP.CT.HOSPositionD(ID)),3)	//组织职位名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSPositionD(ID))
       		q:ID="" 
       		s POSDeptCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),4) 	//所属部门-外键
            s POSPOSCCode =$listget($g(^CT.BDP.CT.HOSPositionD(ID)),5) 	//职位字典-外键
            s strRowId = "{ID:"_ID_"}"
            s DeptCodestrRowId = "{ID:"_POSDeptCode_"}"
            s POSCCodestrRowId = "{ID:"_POSPOSCCode_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((DepartmentAuStr[DeptCodestrRowId)||(DepartmentAuFlag=1))&&((PositionDictAuStr[POSCCodestrRowId)||(PositionDictAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{ 
	       		s POSCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),2)	//组织职位代码
		    	s POSDesc= $listget($g(^CT.BDP.CT.HOSPositionD(ID)),3)	//组织职位名称
		    	
				s POSActivity=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),7) 	//是否有效(Y/N)
				continue:POSActivity="N"
		    	s POSStartDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),8) 		//开始日期
		    	continue:(POSStartDate'="")&&(POSStartDate>+$h)
				s POSEndDate=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),9) 		//结束日期
		  		continue:(POSEndDate'="")&&(POSEndDate<+$h)

	       		s POSPYCode=$listget($g(^CT.BDP.CT.HOSPositionD(ID)),17) 		//拼音码
			
	            if (($zcvt(POSCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSCode,POSDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSPosition).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPosition).%New()
    s pobj = ##class(CT.BDP.CT.HOSPosition).%OpenId(id)
    s eobj.ID=id
    s eobj.POSCode=pobj.POSCode	//组织职位代码
    s eobj.POSDesc= pobj.POSDesc	//组织职位名称
    if $IsObject(pobj.POSDeptCode){
		s eobj.POSDeptCode = pobj.POSDeptCode.%Id() 	//直属组织代码-外键
	}
    if $IsObject(pobj.POSPOSCCode){
		s eobj.POSPOSCCode = pobj.POSPOSCCode.%Id() 	//职位字典-外键
	}
	
	  
	s eobj.POSLimitedNum=pobj.POSLimitedNum		//额定人数
	
	s eobj.POSActivity=pobj.POSActivity	//是否有效(Y/N)
		s eobj.POSStartDate=pobj.POSStartDate		//开始日期
	s:eobj.POSStartDate'="" eobj.POSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSStartDate) 
	s eobj.POSEndDate=pobj.POSEndDate		//结束日期
	s:eobj.POSEndDate'="" eobj.POSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSEndDate) 
	s eobj.POSSeqNo=pobj.POSSeqNo		//系统排序号
	
	s eobj.POSPYCode=pobj.POSPYCode		//拼音码
	s eobj.POSWBCode=pobj.POSWBCode		//五笔码
	s eobj.POSMark=pobj.POSMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPosition
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPosition).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSPositionI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSPositionI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织职位内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPosition
/// Input：     web.Entity.CT.HOSPosition  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPosition).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPosition) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 
    s:eobj.POSStartDate'="" eobj.POSStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSStartDate) 
    s:eobj.POSEndDate'="" eobj.POSEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSEndDate)
    s:eobj.POSStartDate="" eobj.POSStartDate=+$h
    s:eobj.POSLastUpdateDate="" eobj.POSLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.POSLastUpdateTime="" eobj.POSLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.POSLastUpdateUser="" eobj.POSLastUpdateUser=UserID	//系统最新更新人
    s:eobj.POSActivity="" eobj.POSActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.POSCode,eobj.POSDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPosition).%New()
            //s eobj.POSSeqNo=..GetSeqNo()
            s:eobj.POSCreateDate="" eobj.POSCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.POSCreateTime="" eobj.POSCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.POSCreateUser="" eobj.POSCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.POSCreateDate=eobj.POSCreateDate		//系统创建日期
			s obj.POSCreateTime=eobj.POSCreateTime		//系统创建时间
			d obj.POSCreateUserSetObjectId(eobj.POSCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPosition).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPosition).%New()
            s bobj.ID=eobj.ID 
            s bobj.POSCode=obj.POSCode	//组织职位代码
            s bobj.POSDesc= obj.POSDesc	//组织职位名称
			if $IsObject(obj.POSDeptCode){
				s bobj.POSDeptCode = obj.POSDeptCode.%Id() 	//所属部门-外键
			}
		    if $IsObject(obj.POSPOSCCode){
				s bobj.POSPOSCCode = obj.POSPOSCCode.%Id() 	//职位字典-外键
			}
	
			s bobj.POSLimitedNum=obj.POSLimitedNum		//额定人数
			
			s bobj.POSActivity=obj.POSActivity	//是否有效(Y/N)
			s bobj.POSStartDate=obj.POSStartDate		//开始日期
			s bobj.POSEndDate=obj.POSEndDate		//结束日期
			s bobj.POSCreateDate=obj.POSCreateDate		//系统创建日期
			s bobj.POSCreateTime=obj.POSCreateTime		//系统创建时间
			if $IsObject(obj.POSCreateUser){
				s bobj.POSCreateUser = obj.POSCreateUser.%Id() 	//系统创建人
			}
			s bobj.POSSeqNo=obj.POSSeqNo		//系统排序号
			s bobj.POSLastUpdateDate=obj.POSLastUpdateDate		//系统最后更新日期
			s bobj.POSLastUpdateTime=obj.POSLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.POSLastUpdateUser){
				s bobj.POSLastUpdateUser = obj.POSLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.POSPYCode=obj.POSPYCode		//拼音码
			s bobj.POSWBCode=obj.POSWBCode		//五笔码
			s bobj.POSMark=obj.POSMark		//备注

        }
        
        s obj.POSCode=eobj.POSCode	//组织职位代码
        s obj.POSDesc= eobj.POSDesc	//组织职位名称
        d obj.POSDeptCodeSetObjectId(eobj.POSDeptCode) 	//所属部门-外键
		
		d obj.POSPOSCCodeSetObjectId(eobj.POSPOSCCode) 	//职位字典-外键
		
		
		s obj.POSLimitedNum=eobj.POSLimitedNum		//额定人数

		s obj.POSActivity=eobj.POSActivity	//是否有效(Y/N)
		s obj.POSStartDate=eobj.POSStartDate		//开始日期
		s obj.POSEndDate=eobj.POSEndDate		//结束日期
		
		s obj.POSSeqNo=eobj.POSSeqNo		//系统排序号
		s obj.POSLastUpdateDate=eobj.POSLastUpdateDate		//系统最后更新日期
		s obj.POSLastUpdateTime=eobj.POSLastUpdateTime		//系统最后更新时间
		d obj.POSLastUpdateUserSetObjectId(eobj.POSLastUpdateUser)	//系统最新更新人
		s:eobj.POSPYCode="" eobj.POSPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.POSDesc)
		s obj.POSPYCode=eobj.POSPYCode		//拼音码
		s:eobj.POSWBCode="" eobj.POSWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.POSDesc,1)
		s obj.POSWBCode=eobj.POSWBCode		//五笔码
		s obj.POSMark=eobj.POSMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Position","CT.BDP.CT.HOSPosition","组织职位",id,eobj.POSDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Position","CT.BDP.CT.HOSPosition","组织职位",eobj.ID,eobj.POSDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织职位","web.DHCBL.CT.HOSPosition","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSPosition
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSPosition).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSPositionI("IndexSeqNo",""),-1)
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
/// Table：CT.BDP.CT.HOSPosition
/// Input：id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSPosition).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""

    if $d(^CT.BDP.CT.HOSORGEmployeeI("IndexPOSCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    if $d(^CT.BDP.CT.HOSEmpPostionI("IndexCode",id)){
        s myInfo=myInfo_"<组织人员职位>"
    }
    
      
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织职位的内容
/// Table：CT.BDP.CT.HOSPosition
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPosition).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
	     
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSPosition).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPosition).%New()
    s eobj.ID = id
    s eobj.POSCode=pobj.POSCode	//组织职位代码
    s eobj.POSDesc= pobj.POSDesc	//组织职位名称
    if $IsObject(pobj.POSDeptCode){
		s eobj.POSDeptCode = pobj.POSDeptCode.%Id() 	//直属组织代码-外键
	}
    if $IsObject(pobj.POSPOSCCode){
		s eobj.POSPOSCCode = pobj.POSPOSCCode.%Id() 	//职位字典-外键
	}
	  
	s eobj.POSLimitedNum=pobj.POSLimitedNum		//额定人数
	s eobj.POSActivity=pobj.POSActivity	//是否有效(Y/N)
	
	s eobj.POSActivity=pobj.POSActivity	//是否有效(Y/N)
	s eobj.POSStartDate=pobj.POSStartDate		//开始日期
	s eobj.POSEndDate=pobj.POSEndDate		//结束日期
	
	s eobj.POSSeqNo=pobj.POSSeqNo		//系统排序号
	
	s eobj.POSPYCode=pobj.POSPYCode		//拼音码
	s eobj.POSWBCode=pobj.POSWBCode		//五笔码
	s eobj.POSMark=pobj.POSMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPosition).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Position","CT.BDP.CT.HOSPosition","组织职位",id,eobj.POSDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织职位","web.DHCBL.CT.HOSPosition","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
