/// Function: 组织机构自主属性字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgIndepenType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构自主属性信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgIndepenType   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgIndepenType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ORGITCode,ORGITDesc,ORGITActivity,ORGITStartDate,ORGITEndDate,ORGITSeqNo,ORGITPYCode,ORGITWBCode,ORGITMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGITCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),2)	//组织机构自主属性代码
	    s ORGITDesc= $listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),3)	//组织机构自主属性名称
	    
		s ORGITActivity=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),4) 	//是否有效(Y/N)
		s ORGITStartDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),5) 		//开始日期
		s:ORGITStartDate'="" ORGITStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGITStartDate) 
		s ORGITEndDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),6) 		//结束日期
		s:ORGITEndDate'="" ORGITEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGITEndDate) 
		
		
		s ORGITSeqNo=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),10) 		//系统排序号
		
		s ORGITPYCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),14) 		//拼音码
		s ORGITWBCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),15) 		//五笔码
		s ORGITMark=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),16) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgIndepenTypeD(ID))
            q:ID="" 
            s ORGITCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),2)	//组织机构自主属性代码
		    s ORGITDesc= $listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),3)	//组织机构自主属性名称
		    s ORGITActivity=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),4) 	//是否有效(Y/N)
			s ORGITStartDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),5) 		//开始日期
			s:ORGITStartDate'="" ORGITStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGITStartDate) 
			s ORGITEndDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),6) 		//结束日期
			s:ORGITEndDate'="" ORGITEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGITEndDate) 
			
			
			s ORGITSeqNo=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),10) 		//系统排序号
			
			s ORGITPYCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),14) 		//拼音码
			s ORGITWBCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),15) 		//五笔码
			s ORGITMark=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),16) 		//备注
		
            if (($zcvt(ORGITCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGITDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGITPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGITCode,ORGITDesc,ORGITActivity,ORGITStartDate,ORGITEndDate,ORGITSeqNo,ORGITPYCode,ORGITWBCode,ORGITMark)
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
/// Tables: CT_BDP_CT.HOS_OrgIndepenType
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgIndepenType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGITCode,ORGITDesc:%String")
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
	  	s ORGITCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),2)	//组织机构自主属性代码
    	s ORGITDesc= $listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),3)	//组织机构自主属性名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgIndepenTypeD(ID))
       		q:ID="" 
       		s ORGITCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),2)	//组织机构自主属性代码
	    	s ORGITDesc= $listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),3)	//组织机构自主属性名称
	    	
			s ORGITActivity=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),4) 	//是否有效(Y/N)
			continue:ORGITActivity="N"
	    	s ORGITStartDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),5) 		//开始日期
	    	continue:(ORGITStartDate'="")&&(ORGITStartDate>+$h)
			s ORGITEndDate=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),6) 		//结束日期
	  		continue:(ORGITEndDate'="")&&(ORGITEndDate<+$h)

       		s ORGITPYCode=$listget($g(^CT.BDP.CT.HOSOrgIndepenTypeD(ID)),14) 		//拼音码
            if (($zcvt(ORGITCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGITDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGITPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
	        	d OutputRowCmb
	    	}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGITCode,ORGITDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgIndepenType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgIndepenType).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgIndepenType).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGITCode=pobj.ORGITCode	//组织机构自主属性代码
    s eobj.ORGITDesc= pobj.ORGITDesc	//组织机构自主属性名称

	s eobj.ORGITActivity=pobj.ORGITActivity	//是否有效(Y/N)
	s eobj.ORGITStartDate=pobj.ORGITStartDate		//开始日期
	s:eobj.ORGITStartDate'="" eobj.ORGITStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGITStartDate) 
	s eobj.ORGITEndDate=pobj.ORGITEndDate		//结束日期
	s:eobj.ORGITEndDate'="" eobj.ORGITEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGITEndDate) 
	s eobj.ORGITSeqNo=pobj.ORGITSeqNo		//系统排序号
	
	s eobj.ORGITPYCode=pobj.ORGITPYCode		//拼音码
	s eobj.ORGITWBCode=pobj.ORGITWBCode		//五笔码
	s eobj.ORGITMark=pobj.ORGITMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgIndepenType
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgIndepenType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgIndepenTypeI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgIndepenTypeI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构自主属性内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgIndepenType
/// Input：     web.Entity.CT.HOSOrgIndepenType  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgIndepenType).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgIndepenType) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGITStartDate'="" eobj.ORGITStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGITStartDate) 
    s:eobj.ORGITEndDate'="" eobj.ORGITEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGITEndDate)
    
    s:eobj.ORGITLastUpdateDate="" eobj.ORGITLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGITLastUpdateTime="" eobj.ORGITLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGITLastUpdateUser="" eobj.ORGITLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGITActivity="" eobj.ORGITActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGITCode,eobj.ORGITDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgIndepenType).%New()
            //s eobj.ORGITSeqNo=..GetSeqNo()
            s:eobj.ORGITCreateDate="" eobj.ORGITCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGITCreateTime="" eobj.ORGITCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGITCreateUser="" eobj.ORGITCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGITCreateDate=eobj.ORGITCreateDate		//系统创建日期
			s obj.ORGITCreateTime=eobj.ORGITCreateTime		//系统创建时间
			d obj.ORGITCreateUserSetObjectId(eobj.ORGITCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgIndepenType).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgIndepenType).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGITCode=obj.ORGITCode	//组织机构自主属性代码
            s bobj.ORGITDesc= obj.ORGITDesc	//组织机构自主属性名称

			s bobj.ORGITActivity=obj.ORGITActivity	//是否有效(Y/N)
			s bobj.ORGITStartDate=obj.ORGITStartDate		//开始日期
			s bobj.ORGITEndDate=obj.ORGITEndDate		//结束日期
			s bobj.ORGITCreateDate=obj.ORGITCreateDate		//系统创建日期
			s bobj.ORGITCreateTime=obj.ORGITCreateTime		//系统创建时间
			if $IsObject(obj.ORGITCreateUser){
				s bobj.ORGITCreateUser = obj.ORGITCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGITSeqNo=obj.ORGITSeqNo		//系统排序号
			s bobj.ORGITLastUpdateDate=obj.ORGITLastUpdateDate		//系统最后更新日期
			s bobj.ORGITLastUpdateTime=obj.ORGITLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGITLastUpdateUser){
				s bobj.ORGITLastUpdateUser = obj.ORGITLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGITPYCode=obj.ORGITPYCode		//拼音码
			s bobj.ORGITWBCode=obj.ORGITWBCode		//五笔码
			s bobj.ORGITMark=obj.ORGITMark		//备注

        }
        
        s obj.ORGITCode=eobj.ORGITCode	//组织机构自主属性代码
        s obj.ORGITDesc= eobj.ORGITDesc	//组织机构自主属性名称

		s obj.ORGITActivity=eobj.ORGITActivity	//是否有效(Y/N)
		s obj.ORGITStartDate=eobj.ORGITStartDate		//开始日期
		s obj.ORGITEndDate=eobj.ORGITEndDate		//结束日期
		
		s obj.ORGITSeqNo=eobj.ORGITSeqNo		//系统排序号
		s obj.ORGITLastUpdateDate=eobj.ORGITLastUpdateDate		//系统最后更新日期
		s obj.ORGITLastUpdateTime=eobj.ORGITLastUpdateTime		//系统最后更新时间
		d obj.ORGITLastUpdateUserSetObjectId(eobj.ORGITLastUpdateUser)	//系统最新更新人
		s:eobj.ORGITPYCode="" eobj.ORGITPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGITDesc)
		s obj.ORGITPYCode=eobj.ORGITPYCode		//拼音码
		s:eobj.ORGITWBCode="" eobj.ORGITWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGITDesc,1)
		s obj.ORGITWBCode=eobj.ORGITWBCode		//五笔码
		s obj.ORGITMark=eobj.ORGITMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgIndepenType","CT.BDP.CT.HOSOrgIndepenType","组织机构自主属性",id,eobj.ORGITDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgIndepenType","CT.BDP.CT.HOSOrgIndepenType","组织机构自主属性",eobj.ID,eobj.ORGITDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构自主属性","web.DHCBL.CT.HOSOrgIndepenType","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgIndepenType).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGITCode",id)){
        s myInfo=myInfo_"<组织结构树>"
    } 
 
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构自主属性的内容
/// Table：CT.BDP.CT.HOSOrgIndepenType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgIndepenType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgIndepenType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgIndepenType).%New()
    s eobj.ID = id
    s eobj.ORGITCode=pobj.ORGITCode	//组织机构自主属性代码
    s eobj.ORGITDesc= pobj.ORGITDesc	//组织机构自主属性名称
	
	s eobj.ORGITActivity=pobj.ORGITActivity	//是否有效(Y/N)
	s eobj.ORGITStartDate=pobj.ORGITStartDate		//开始日期
	s eobj.ORGITEndDate=pobj.ORGITEndDate		//结束日期
	
	s eobj.ORGITSeqNo=pobj.ORGITSeqNo		//系统排序号
	
	s eobj.ORGITPYCode=pobj.ORGITPYCode		//拼音码
	s eobj.ORGITWBCode=pobj.ORGITWBCode		//五笔码
	s eobj.ORGITMark=pobj.ORGITMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgIndepenType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgIndepenType","CT.BDP.CT.HOSOrgIndepenType","组织机构自主属性",id,eobj.ORGITDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构自主属性","web.DHCBL.CT.HOSOrgIndepenType","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
