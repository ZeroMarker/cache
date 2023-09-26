/// Function: HOS 学位代码
/// CreateDate:2023-02-07
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSDegree Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  学位代码查询
/// Creator:    gaoshanshan
/// CreatDate:  2023-02-07
/// Table：     CT_BDP_CT.HOS_Degree   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSDegree","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,DEGCode,DEGDesc,DEGActivity,DEGStartDate,DEGEndDate,DEGSeqNo,DEGPYCode,DEGWBCode,DEGMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s DEGCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),2)	//学位代码
	    s DEGDesc= $listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)	//学位名称
		s DEGActivity=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),4) 	//是否有效(Y/N)
		s DEGStartDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),5) 		//开始日期
		s:DEGStartDate'="" DEGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEGStartDate) 
		s DEGEndDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),6) 		//结束日期
		s:DEGEndDate'="" DEGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEGEndDate) 
		s DEGSeqNo=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),10) 		//系统排序号
		s DEGPYCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),14) 		//拼音码
		s DEGWBCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),15) 		//五笔码
		s DEGMark=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),16) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSDegree).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	    s:code'="" code=$zcvt(code,"U")  
	  	s:desc'="" desc=$zcvt(desc,"U")  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSDegreeD(ID))
            q:ID="" 
            s DEGCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),2)	//学位代码
		    s DEGDesc= $listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)	//学位名称
			s DEGActivity=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),4) 	//是否有效(Y/N)
			s DEGStartDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),5) 		//开始日期
			s:DEGStartDate'="" DEGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEGStartDate) 
			s DEGEndDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),6) 		//结束日期
			s:DEGEndDate'="" DEGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEGEndDate) 
			s DEGSeqNo=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),10) 		//系统排序号
			s DEGPYCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),14) 		//拼音码
			s DEGWBCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),15) 		//五笔码
			s DEGMark=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),16) 		//备注
			
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
	            if ($zcvt(DEGCode,"U")[code)&(($zcvt(DEGDesc,"U")[desc)||($zcvt(DEGPYCode,"U")[desc))
	            {
	                d OutputRow
	            } 
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,DEGCode,DEGDesc,DEGActivity,DEGStartDate,DEGEndDate,DEGSeqNo,DEGPYCode,DEGWBCode,DEGMark)
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
/// CreatDate:2023-02-07
/// Tables: CT_BDP_CT.HOS_Degree
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSDegree", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,DEGCode,DEGDesc:%String")
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
	  	s DEGCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),2)	//学位代码
    	s DEGDesc= $listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)	//学位名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSDegree).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSDegreeD(ID))
       		q:ID="" 
       		s DEGCode=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),2)	//学位代码
	    	s DEGDesc= $listget($g(^CT.BDP.CT.HOSDegreeD(ID)),3)	//学位名称
			s DEGActivity=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),4) 	//是否有效(Y/N)
			continue:DEGActivity="N"
	    	s DEGStartDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),5) 		//开始日期
	    	continue:(DEGStartDate'="")&&(DEGStartDate>+$h)
			s DEGEndDate=$listget($g(^CT.BDP.CT.HOSDegreeD(ID)),6) 		//结束日期
	  		continue:(DEGEndDate'="")&&(DEGEndDate<+$h)
	  		
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
		    	if (($ZCONVERT(DEGDesc,"U")[desc)&&($ZCONVERT(DEGCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,DEGCode,DEGDesc)
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
/// CreatDate: 2023-02-07
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSDegree).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSDegree).%New()
    s pobj = ##class(CT.BDP.CT.HOSDegree).%OpenId(id)
    s eobj.ID=id
    s eobj.DEGCode=pobj.DEGCode	//学位代码
    s eobj.DEGDesc= pobj.DEGDesc	//学位名称
	s eobj.DEGActivity=pobj.DEGActivity	//是否有效(Y/N)
	s eobj.DEGStartDate=pobj.DEGStartDate		//开始日期
	s:eobj.DEGStartDate'="" eobj.DEGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEGStartDate) 
	s eobj.DEGEndDate=pobj.DEGEndDate		//结束日期
	s:eobj.DEGEndDate'="" eobj.DEGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEGEndDate) 
	s eobj.DEGSeqNo=pobj.DEGSeqNo		//系统排序号
	s eobj.DEGPYCode=pobj.DEGPYCode		//拼音码
	s eobj.DEGWBCode=pobj.DEGWBCode		//五笔码
	s eobj.DEGMark=pobj.DEGMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2023-02-07
/// Table：   CT.BDP.CT.HOSDegree
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSDegree).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSDegreeI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	    
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSDegreeI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存学位代码内容
/// Creator:    gaoshanshan
/// CreatDate:  2023-02-07
/// Table：     CT.BDP.CT.HOSDegree
/// Input：     web.Entity.CT.HOSDegree  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSDegree).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSDegree) As %String
{
 
    s result="" 
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 

    s:eobj.DEGStartDate'="" eobj.DEGStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEGStartDate) 
    s:eobj.DEGEndDate'="" eobj.DEGEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEGEndDate)
    s:eobj.DEGStartDate="" eobj.DEGStartDate=+$h
    
    s:eobj.DEGLastUpdateDate="" eobj.DEGLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.DEGLastUpdateTime="" eobj.DEGLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.DEGLastUpdateUser="" eobj.DEGLastUpdateUser=USERID	//系统最新更新人
    s:eobj.DEGActivity="" eobj.DEGActivity="N"		//是否有效
    
    s:eobj.DEGPYCode="" eobj.DEGPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.DEGDesc,4)
    s:eobj.DEGWBCode="" eobj.DEGWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.DEGDesc,1)
    s flag=  ..FormValidate(eobj.ID,eobj.DEGCode,eobj.DEGDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSDegree).%New()
            s:eobj.DEGCreateDate="" eobj.DEGCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.DEGCreateTime="" eobj.DEGCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.DEGCreateUser="" eobj.DEGCreateUser= USERID		//系统创建人默认当前登录人员
		    s obj.DEGCreateDate=eobj.DEGCreateDate		//系统创建日期
			s obj.DEGCreateTime=eobj.DEGCreateTime		//系统创建时间
			d obj.DEGCreateUserSetObjectId(eobj.DEGCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSDegree).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSDegree).%New()
            s bobj.ID=eobj.ID 
            s bobj.DEGCode=obj.DEGCode	//学位代码
            s bobj.DEGDesc= obj.DEGDesc	//学位名称 
			s bobj.DEGActivity=obj.DEGActivity	//是否有效(Y/N)
			s bobj.DEGStartDate=obj.DEGStartDate		//开始日期
			s bobj.DEGEndDate=obj.DEGEndDate		//结束日期
			s bobj.DEGCreateDate=obj.DEGCreateDate		//系统创建日期
			s bobj.DEGCreateTime=obj.DEGCreateTime		//系统创建时间
			s:$IsObject(obj.DEGCreateUser) bobj.DEGCreateUser = obj.DEGCreateUser.%Id() 	//系统创建人
			s bobj.DEGSeqNo=obj.DEGSeqNo		//系统排序号
			s bobj.DEGLastUpdateDate=obj.DEGLastUpdateDate		//系统最后更新日期
			s bobj.DEGLastUpdateTime=obj.DEGLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.DEGLastUpdateUser) bobj.DEGLastUpdateUser = obj.DEGLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.DEGPYCode=obj.DEGPYCode		//拼音码
			s bobj.DEGWBCode=obj.DEGWBCode		//五笔码
			s bobj.DEGMark=obj.DEGMark		//备注

        }
        
        s obj.DEGCode=eobj.DEGCode	//学位代码
        s obj.DEGDesc= eobj.DEGDesc	//学位名称
		s obj.DEGActivity=eobj.DEGActivity	//是否有效(Y/N)
		s obj.DEGStartDate=eobj.DEGStartDate		//开始日期
		s obj.DEGEndDate=eobj.DEGEndDate		//结束日期
		s obj.DEGSeqNo=eobj.DEGSeqNo		//系统排序号
		s obj.DEGLastUpdateDate=eobj.DEGLastUpdateDate		//系统最后更新日期
		s obj.DEGLastUpdateTime=eobj.DEGLastUpdateTime		//系统最后更新时间
		d obj.DEGLastUpdateUserSetObjectId(eobj.DEGLastUpdateUser)	//系统最新更新人
		s obj.DEGPYCode=eobj.DEGPYCode		//拼音码
		s obj.DEGWBCode=eobj.DEGWBCode		//五笔码
		s obj.DEGMark=eobj.DEGMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Degree","CT.BDP.CT.HOSDegree","学位代码",id,eobj.DEGDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Degree","CT.BDP.CT.HOSDegree","学位代码",eobj.ID,eobj.DEGDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("学位代码","web.DHCBL.CT.HOSDegree","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2023-02-07
/// Description：根据ID删除学位代码的内容
/// Table：CT.BDP.CT.HOSDegree
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSDegree).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSDegree).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSDegree).%New()
    s eobj.ID = id
    s eobj.DEGCode=pobj.DEGCode	//学位代码
    s eobj.DEGDesc= pobj.DEGDesc	//学位名称
	s eobj.DEGActivity=pobj.DEGActivity	//是否有效(Y/N)
	s eobj.DEGStartDate=pobj.DEGStartDate		//开始日期
	s eobj.DEGEndDate=pobj.DEGEndDate		//结束日期
	s eobj.DEGCreateDate=pobj.DEGCreateDate		//系统创建日期
	s eobj.DEGCreateTime=pobj.DEGCreateTime		//系统创建时间
	s:$IsObject(pobj.DEGCreateUser) eobj.DEGCreateUser = pobj.DEGCreateUser.%Id() 	//系统创建人
	s eobj.DEGSeqNo=pobj.DEGSeqNo		//系统排序号
	s eobj.DEGLastUpdateDate=pobj.DEGLastUpdateDate		//系统最后更新日期
	s eobj.DEGLastUpdateTime=pobj.DEGLastUpdateTime		//系统最后更新时间
	s:$IsObject(pobj.DEGLastUpdateUser) eobj.DEGLastUpdateUser = pobj.DEGLastUpdateUser.%Id() 	//系统最新更新人
	s eobj.DEGPYCode=pobj.DEGPYCode		//拼音码
	s eobj.DEGWBCode=pobj.DEGWBCode		//五笔码
	s eobj.DEGMark=pobj.DEGMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSDegree).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Degree","CT.BDP.CT.HOSDegree","学位代码",id,eobj.DEGDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("学位代码","web.DHCBL.CT.HOSDegree","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
