/// Function: 职位类型
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSPOSType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  职位类型信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_POSType   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPOSType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,POSKCode,POSKDesc,DomainParentCode,DomainLevel,POSKActivity,POSKStartDate,POSKEndDate,POSKSeqNo,POSKPYCode,POSKWBCode,POSKMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s POSKCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),2)	//职位类型代码
	    s POSKDesc= $listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),3)	//职位类型名称
		
		s POSKActivity=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),4) 	//是否有效(Y/N)
		s POSKStartDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),5) 		//开始日期
		s:POSKStartDate'="" POSKStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSKStartDate) 
		s POSKEndDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),6) 		//结束日期
		s:POSKEndDate'="" POSKEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSKEndDate) 
		
		s POSKSeqNo=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),10) 		//系统排序号

		s POSKPYCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),14) 		//拼音码
		s POSKWBCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),15) 		//五笔码
		s POSKMark=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),16) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPOSTypeD(ID))
            q:ID="" 
            s POSKCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),2)	//职位类型代码
		    s POSKDesc= $listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),3)	//职位类型名称
			
			s POSKActivity=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),4) 	//是否有效(Y/N)
			s POSKStartDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),5) 		//开始日期
			s:POSKStartDate'="" POSKStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSKStartDate) 
			s POSKEndDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),6) 		//结束日期
			s:POSKEndDate'="" POSKEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSKEndDate) 
			
			s POSKSeqNo=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),10) 		//系统排序号

			s POSKPYCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),14) 		//拼音码
			s POSKWBCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),15) 		//五笔码
			s POSKMark=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),16) 		//备注
		
            if (($zcvt(POSKCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSKDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSKPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POSKCode,POSKDesc,DomainParentCode,DomainLevel,POSKActivity,POSKStartDate,POSKEndDate,POSKSeqNo,POSKPYCode,POSKWBCode,POSKMark)
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
/// Tables: CT_BDP_CT.HOS_POSType
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPOSType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSKCode,POSKDesc:%String")
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
	  	s POSKCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),2)	//职位类型代码
    	s POSKDesc= $listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),3)	//职位类型名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSPOSTypeD(ID))
       		q:ID="" 
       		s POSKCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),2)	//职位类型代码
	    	s POSKDesc= $listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),3)	//职位类型名称
	    
			
			s POSKActivity=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),4) 	//是否有效(Y/N)
			continue:POSKActivity="N"
			s POSKStartDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),5) 		//开始日期
			continue:(POSKStartDate'="")&&(POSKStartDate>+$h)
			s POSKEndDate=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),6) 		//结束日期
			continue:(POSKEndDate'="")&&(POSKEndDate<+$h)
			
       		s POSKPYCode=$listget($g(^CT.BDP.CT.HOSPOSTypeD(ID)),14) 		//拼音码
		
            if (($zcvt(POSKCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSKDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSKPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
	        	d OutputRowCmb
	    	}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSKCode,POSKDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSPOSType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPOSType).%New()
    s pobj = ##class(CT.BDP.CT.HOSPOSType).%OpenId(id)
    s eobj.ID=id
    s eobj.POSKCode=pobj.POSKCode	//职位类型代码
    s eobj.POSKDesc= pobj.POSKDesc	//职位类型名称
    
	s eobj.POSKActivity=pobj.POSKActivity	//是否有效(Y/N)
	s eobj.POSKStartDate=pobj.POSKStartDate		//开始日期
	s:eobj.POSKStartDate'="" eobj.POSKStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSKStartDate) 
	s eobj.POSKEndDate=pobj.POSKEndDate		//结束日期
	s:eobj.POSKEndDate'="" eobj.POSKEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSKEndDate) 
	s eobj.POSKSeqNo=pobj.POSKSeqNo		//系统排序号
	
	s eobj.POSKPYCode=pobj.POSKPYCode		//拼音码
	s eobj.POSKWBCode=pobj.POSKWBCode		//五笔码
	s eobj.POSKMark=pobj.POSKMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPOSType
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPOSType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSPOSTypeI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSPOSTypeI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存职位类型内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPOSType
/// Input：     web.Entity.CT.HOSPOSType  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPOSType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPOSType) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.POSKStartDate'="" eobj.POSKStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSKStartDate) 
    s:eobj.POSKEndDate'="" eobj.POSKEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSKEndDate)
    
    s:eobj.POSKLastUpdateDate="" eobj.POSKLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.POSKLastUpdateTime="" eobj.POSKLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.POSKLastUpdateUser="" eobj.POSKLastUpdateUser=UserID	//系统最新更新人
    s:eobj.POSKActivity="" eobj.POSKActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.POSKCode,eobj.POSKDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPOSType).%New()
            //s eobj.POSKSeqNo=..GetSeqNo()
            s:eobj.POSKCreateDate="" eobj.POSKCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.POSKCreateTime="" eobj.POSKCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.POSKCreateUser="" eobj.POSKCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.POSKCreateDate=eobj.POSKCreateDate		//系统创建日期
			s obj.POSKCreateTime=eobj.POSKCreateTime		//系统创建时间
			d obj.POSKCreateUserSetObjectId(eobj.POSKCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPOSType).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPOSType).%New()
            s bobj.ID=eobj.ID 
            s bobj.POSKCode=obj.POSKCode	//职位类型代码
            s bobj.POSKDesc= obj.POSKDesc	//职位类型名称

			s bobj.POSKActivity=obj.POSKActivity	//是否有效(Y/N)
			s bobj.POSKStartDate=obj.POSKStartDate		//开始日期
			s bobj.POSKEndDate=obj.POSKEndDate		//结束日期
			s bobj.POSKCreateDate=obj.POSKCreateDate		//系统创建日期
			s bobj.POSKCreateTime=obj.POSKCreateTime		//系统创建时间
			if $IsObject(obj.POSKCreateUser){
				s bobj.POSKCreateUser = obj.POSKCreateUser.%Id() 	//系统创建人
			}
			s bobj.POSKSeqNo=obj.POSKSeqNo		//系统排序号
			s bobj.POSKLastUpdateDate=obj.POSKLastUpdateDate		//系统最后更新日期
			s bobj.POSKLastUpdateTime=obj.POSKLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.POSKLastUpdateUser){
				s bobj.POSKLastUpdateUser = obj.POSKLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.POSKPYCode=obj.POSKPYCode		//拼音码
			s bobj.POSKWBCode=obj.POSKWBCode		//五笔码
			s bobj.POSKMark=obj.POSKMark		//备注

        }
        
        s obj.POSKCode=eobj.POSKCode	//职位类型代码
        s obj.POSKDesc= eobj.POSKDesc	//职位类型名称
		s obj.POSKActivity=eobj.POSKActivity	//是否有效(Y/N)
		s obj.POSKStartDate=eobj.POSKStartDate		//开始日期
		s obj.POSKEndDate=eobj.POSKEndDate		//结束日期
		
		s obj.POSKSeqNo=eobj.POSKSeqNo		//系统排序号
		s obj.POSKLastUpdateDate=eobj.POSKLastUpdateDate		//系统最后更新日期
		s obj.POSKLastUpdateTime=eobj.POSKLastUpdateTime		//系统最后更新时间
		d obj.POSKLastUpdateUserSetObjectId(eobj.POSKLastUpdateUser)	//系统最新更新人
		s:eobj.POSKPYCode="" eobj.POSKPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.POSKDesc)
		s obj.POSKPYCode=eobj.POSKPYCode		//拼音码
		s:eobj.POSKWBCode="" eobj.POSKWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.POSKDesc,1)
		s obj.POSKWBCode=eobj.POSKWBCode		//五笔码
		s obj.POSKMark=eobj.POSKMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_POSType","CT.BDP.CT.HOSPOSType","职位类型",id,eobj.POSKDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_POSType","CT.BDP.CT.HOSPOSType","职位类型",eobj.ID,eobj.POSKDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职位类型","web.DHCBL.CT.HOSPOSType","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSPOSType
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSPOSType).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSPOSTypeI("IndexSeqNo",""),-1)
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
/// Other:w ##class(web.DHCBL.CT.HOSPOSType).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    if $d(^CT.BDP.CT.HOSPositionDictI("IndexPOSKCode",id)){
        s myInfo=myInfo_"<职位字典>"
    }
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除职位类型的内容
/// Table：CT.BDP.CT.HOSPOSType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPOSType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSPOSType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPOSType).%New()
    s eobj.ID = id
    s eobj.POSKCode=pobj.POSKCode	//职位类型代码
    s eobj.POSKDesc= pobj.POSKDesc	//职位类型名称
    
	s eobj.POSKActivity=pobj.POSKActivity	//是否有效(Y/N)
	s eobj.POSKStartDate=pobj.POSKStartDate		//开始日期
	s eobj.POSKEndDate=pobj.POSKEndDate		//结束日期

	s eobj.POSKSeqNo=pobj.POSKSeqNo		//系统排序号

	s eobj.POSKPYCode=pobj.POSKPYCode		//拼音码
	s eobj.POSKWBCode=pobj.POSKWBCode		//五笔码
	s eobj.POSKMark=pobj.POSKMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPOSType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_POSType","CT.BDP.CT.HOSPOSType","职位类型",id,eobj.POSKDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("职位类型","web.DHCBL.CT.HOSPOSType","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
