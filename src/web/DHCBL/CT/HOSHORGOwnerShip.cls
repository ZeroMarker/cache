/// Function: HOS 医疗机构的所有制形式
/// CreateDate:2022-11-17
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSHORGOwnerShip Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医疗机构所有制形式查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-17
/// Table：     CT_BDP_CT.HOS_HORGOwnerShip   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSHORGOwnerShip","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,HORGOSCode,HORGOSDesc,HORGOSSource,HORGOSActivity,HORGOSStartDate,HORGOSEndDate,HORGOSSeqNo,HORGOSPYCode,HORGOSWBCode,HORGOSMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s HORGOSCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),2)	//所有制形式代码
	    s HORGOSDesc= $listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),3)	//所有制形式名称
		s HORGOSSource=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),4) 		//分类来源
		s HORGOSActivity=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),5) 	//是否有效(Y/N)
		s HORGOSStartDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),6) 		//开始日期
		s:HORGOSStartDate'="" HORGOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGOSStartDate) 
		s HORGOSEndDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),7) 		//结束日期
		s:HORGOSEndDate'="" HORGOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGOSEndDate) 
		s HORGOSSeqNo=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),11) 		//系统排序号
		s HORGOSPYCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),15) 		//拼音码
		s HORGOSWBCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),16) 		//五笔码
		s HORGOSMark=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),17) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSHORGOwnerShip).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	    s:code'="" code=$zcvt(code,"U")  
	  	s:desc'="" desc=$zcvt(desc,"U")  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSHORGOwnerShipD(ID))
            q:ID="" 
            s HORGOSCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),2)	//所有制形式代码
		    s HORGOSDesc= $listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),3)	//所有制形式名称
			s HORGOSSource=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),4) 		//分类来源
			s HORGOSActivity=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),5) 	//是否有效(Y/N)
			s HORGOSStartDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),6) 		//开始日期
			s:HORGOSStartDate'="" HORGOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGOSStartDate) 
			s HORGOSEndDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),7) 		//结束日期
			s:HORGOSEndDate'="" HORGOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGOSEndDate) 
			s HORGOSSeqNo=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),11) 		//系统排序号
			s HORGOSPYCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),15) 		//拼音码
			s HORGOSWBCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),16) 		//五笔码
			s HORGOSMark=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),17) 		//备注
		
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
	            if ($zcvt(HORGOSCode,"U")[code)&(($zcvt(HORGOSDesc,"U")[desc)||($zcvt(HORGOSPYCode,"U")[desc))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,HORGOSCode,HORGOSDesc,HORGOSSource,HORGOSActivity,HORGOSStartDate,HORGOSEndDate,HORGOSSeqNo,HORGOSPYCode,HORGOSWBCode,HORGOSMark)
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
/// Creator:  gaoshanshan
/// CreatDate:2022-11-17
/// Tables: CT_BDP_CT.HOS_HORGOwnerShip
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSHORGOwnerShip", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,HORGOSCode,HORGOSDesc:%String")
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
	  	s HORGOSCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),2)	//所有制形式代码
    	s HORGOSDesc= $listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),3)	//所有制形式名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSHORGOwnerShip).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSHORGOwnerShipD(ID))
       		q:ID="" 
       		s HORGOSCode=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),2)	//所有制形式代码
	    	s HORGOSDesc= $listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),3)	//所有制形式名称
			s HORGOSActivity=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),5) 	//是否有效(Y/N)
			continue:HORGOSActivity="N"
	    	s HORGOSStartDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),6) 		//开始日期
	    	continue:(HORGOSStartDate'="")&&(HORGOSStartDate>+$h)
			s HORGOSEndDate=$listget($g(^CT.BDP.CT.HOSHORGOwnerShipD(ID)),7) 		//结束日期
	  		continue:(HORGOSEndDate'="")&&(HORGOSEndDate<+$h)
			
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
		    	if (($ZCONVERT(HORGOSDesc,"U")[desc)&&($ZCONVERT(HORGOSCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,HORGOSCode,HORGOSDesc)
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
/// Creator:   gaoshanshan
/// CreatDate: 2022-11-17
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSHORGOwnerShip).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSHORGOwnerShip).%New()
    s pobj = ##class(CT.BDP.CT.HOSHORGOwnerShip).%OpenId(id)
    s eobj.ID=id
    s eobj.HORGOSCode=pobj.HORGOSCode	//所有制形式代码
    s eobj.HORGOSDesc= pobj.HORGOSDesc	//所有制形式名称
	s eobj.HORGOSSource=pobj.HORGOSSource		//分类来源
	s eobj.HORGOSActivity=pobj.HORGOSActivity	//是否有效(Y/N)
	s eobj.HORGOSStartDate=pobj.HORGOSStartDate		//开始日期
	s:eobj.HORGOSStartDate'="" eobj.HORGOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGOSStartDate) 
	s eobj.HORGOSEndDate=pobj.HORGOSEndDate		//结束日期
	s:eobj.HORGOSEndDate'="" eobj.HORGOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGOSEndDate) 
	s eobj.HORGOSSeqNo=pobj.HORGOSSeqNo		//系统排序号
	s eobj.HORGOSPYCode=pobj.HORGOSPYCode		//拼音码
	s eobj.HORGOSWBCode=pobj.HORGOSWBCode		//五笔码
	s eobj.HORGOSMark=pobj.HORGOSMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-17
/// Table：   CT.BDP.CT.HOSHORGOwnerShip
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSHORGOwnerShip).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSHORGOwnerShipI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	    
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSHORGOwnerShipI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医疗机构所有制形式内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-17
/// Table：     CT.BDP.CT.HOSHORGOwnerShip
/// Input：     web.Entity.CT.HOSHORGOwnerShip  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSHORGOwnerShip).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSHORGOwnerShip) As %String
{
 
    s result="" 
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 

    s:eobj.HORGOSStartDate'="" eobj.HORGOSStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGOSStartDate) 
    s:eobj.HORGOSEndDate'="" eobj.HORGOSEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGOSEndDate)
    s:eobj.HORGOSStartDate="" eobj.HORGOSStartDate=+$h
    
    s:eobj.HORGOSLastUpdateDate="" eobj.HORGOSLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.HORGOSLastUpdateTime="" eobj.HORGOSLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.HORGOSLastUpdateUser="" eobj.HORGOSLastUpdateUser=USERID	//系统最新更新人
    s:eobj.HORGOSActivity="" eobj.HORGOSActivity="N"		//是否有效
    
    s:eobj.HORGOSPYCode="" eobj.HORGOSPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.HORGOSDesc,4)
    s:eobj.HORGOSWBCode="" eobj.HORGOSWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.HORGOSDesc,1)
    s flag=  ..FormValidate(eobj.ID,eobj.HORGOSCode,eobj.HORGOSDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSHORGOwnerShip).%New()
            s:eobj.HORGOSCreateDate="" eobj.HORGOSCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.HORGOSCreateTime="" eobj.HORGOSCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.HORGOSCreateUser="" eobj.HORGOSCreateUser= USERID		//系统创建人默认当前登录人员
		    s obj.HORGOSCreateDate=eobj.HORGOSCreateDate		//系统创建日期
			s obj.HORGOSCreateTime=eobj.HORGOSCreateTime		//系统创建时间
			d obj.HORGOSCreateUserSetObjectId(eobj.HORGOSCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSHORGOwnerShip).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSHORGOwnerShip).%New()
            s bobj.ID=eobj.ID 
            s bobj.HORGOSCode=obj.HORGOSCode	//所有制形式代码
            s bobj.HORGOSDesc= obj.HORGOSDesc	//所有制形式名称 
			s bobj.HORGOSSource=obj.HORGOSSource		//分类来源
			s bobj.HORGOSActivity=obj.HORGOSActivity	//是否有效(Y/N)
			s bobj.HORGOSStartDate=obj.HORGOSStartDate		//开始日期
			s bobj.HORGOSEndDate=obj.HORGOSEndDate		//结束日期
			s bobj.HORGOSCreateDate=obj.HORGOSCreateDate		//系统创建日期
			s bobj.HORGOSCreateTime=obj.HORGOSCreateTime		//系统创建时间
			s:$IsObject(obj.HORGOSCreateUser) bobj.HORGOSCreateUser = obj.HORGOSCreateUser.%Id() 	//系统创建人
			s bobj.HORGOSSeqNo=obj.HORGOSSeqNo		//系统排序号
			s bobj.HORGOSLastUpdateDate=obj.HORGOSLastUpdateDate		//系统最后更新日期
			s bobj.HORGOSLastUpdateTime=obj.HORGOSLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.HORGOSLastUpdateUser) bobj.HORGOSLastUpdateUser = obj.HORGOSLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.HORGOSPYCode=obj.HORGOSPYCode		//拼音码
			s bobj.HORGOSWBCode=obj.HORGOSWBCode		//五笔码
			s bobj.HORGOSMark=obj.HORGOSMark		//备注

        }
        
        s obj.HORGOSCode=eobj.HORGOSCode	//所有制形式代码
        s obj.HORGOSDesc= eobj.HORGOSDesc	//所有制形式名称
		s obj.HORGOSSource=eobj.HORGOSSource		//分类来源
		s obj.HORGOSActivity=eobj.HORGOSActivity	//是否有效(Y/N)
		s obj.HORGOSStartDate=eobj.HORGOSStartDate		//开始日期
		s obj.HORGOSEndDate=eobj.HORGOSEndDate		//结束日期
		s obj.HORGOSSeqNo=eobj.HORGOSSeqNo		//系统排序号
		s obj.HORGOSLastUpdateDate=eobj.HORGOSLastUpdateDate		//系统最后更新日期
		s obj.HORGOSLastUpdateTime=eobj.HORGOSLastUpdateTime		//系统最后更新时间
		d obj.HORGOSLastUpdateUserSetObjectId(eobj.HORGOSLastUpdateUser)	//系统最新更新人
		s obj.HORGOSPYCode=eobj.HORGOSPYCode		//拼音码
		s obj.HORGOSWBCode=eobj.HORGOSWBCode		//五笔码
		s obj.HORGOSMark=eobj.HORGOSMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGOwnerShip","CT.BDP.CT.HOSHORGOwnerShip","医疗机构所有制形式",id,eobj.HORGOSDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGOwnerShip","CT.BDP.CT.HOSHORGOwnerShip","医疗机构所有制形式",eobj.ID,eobj.HORGOSDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构所有制形式","web.DHCBL.CT.HOSHORGOwnerShip","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-17
/// Description：根据ID删除医疗机构所有制形式的内容
/// Table：CT.BDP.CT.HOSHORGOwnerShip
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSHORGOwnerShip).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSHORGOwnerShip).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSHORGOwnerShip).%New()
    s eobj.ID = id
    s eobj.HORGOSCode=pobj.HORGOSCode	//所有制形式代码
    s eobj.HORGOSDesc= pobj.HORGOSDesc	//所有制形式名称
	s eobj.HORGOSSource=pobj.HORGOSSource		//分类来源
	s eobj.HORGOSActivity=pobj.HORGOSActivity	//是否有效(Y/N)
	s eobj.HORGOSStartDate=pobj.HORGOSStartDate		//开始日期
	s eobj.HORGOSEndDate=pobj.HORGOSEndDate		//结束日期
	s eobj.HORGOSCreateDate=pobj.HORGOSCreateDate		//系统创建日期
	s eobj.HORGOSCreateTime=pobj.HORGOSCreateTime		//系统创建时间
	s:$IsObject(pobj.HORGOSCreateUser) eobj.HORGOSCreateUser = pobj.HORGOSCreateUser.%Id() 	//系统创建人
	s eobj.HORGOSSeqNo=pobj.HORGOSSeqNo		//系统排序号
	s eobj.HORGOSLastUpdateDate=pobj.HORGOSLastUpdateDate		//系统最后更新日期
	s eobj.HORGOSLastUpdateTime=pobj.HORGOSLastUpdateTime		//系统最后更新时间
	s:$IsObject(pobj.HORGOSLastUpdateUser) eobj.HORGOSLastUpdateUser = pobj.HORGOSLastUpdateUser.%Id() 	//系统最新更新人
	s eobj.HORGOSPYCode=pobj.HORGOSPYCode		//拼音码
	s eobj.HORGOSWBCode=pobj.HORGOSWBCode		//五笔码
	s eobj.HORGOSMark=pobj.HORGOSMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSHORGOwnerShip).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGOwnerShip","CT.BDP.CT.HOSHORGOwnerShip","医疗机构所有制形式",id,eobj.HORGOSDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构所有制形式","web.DHCBL.CT.HOSHORGOwnerShip","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
