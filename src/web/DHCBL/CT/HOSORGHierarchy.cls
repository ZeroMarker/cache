/// Function: 组织级次字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSORGHierarchy Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织级次信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_ORGHierarchy   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSORGHierarchy","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ORGHCode,ORGHDesc,ORGHHierarchyValue,ORGHActivity,ORGHStartDate,ORGHEndDate,ORGHSeqNo,ORGHPYCode,ORGHWBCode,ORGHMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGHCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),2)	//组织级次代码
	    s ORGHDesc= $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),3)	//组织级次名称
	    
		s ORGHHierarchyValue = $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),4) 	//组织层级数值
		
		s ORGHActivity=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),5) 	//是否有效(Y/N)
		s ORGHStartDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),6) 		//开始日期
		s:ORGHStartDate'="" ORGHStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGHStartDate) 
		s ORGHEndDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),7) 		//结束日期
		s:ORGHEndDate'="" ORGHEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGHEndDate) 
		
		
		s ORGHSeqNo=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),11) 		//系统排序号
		s ORGHPYCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),15) 		//拼音码
		s ORGHWBCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),16) 		//五笔码
		s ORGHMark=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),17) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSORGHierarchyD(ID))
            q:ID="" 
            s ORGHCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),2)	//组织级次代码
		    s ORGHDesc= $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),3)	//组织级次名称
		    
			s ORGHHierarchyValue = $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),4) 	//组织层级数值
			
			s ORGHActivity=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),5) 	//是否有效(Y/N)
			s ORGHStartDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),6) 		//开始日期
			s:ORGHStartDate'="" ORGHStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGHStartDate) 
			s ORGHEndDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),7) 		//结束日期
			s:ORGHEndDate'="" ORGHEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGHEndDate) 
			
			
			s ORGHSeqNo=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),11) 		//系统排序号
			s ORGHPYCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),15) 		//拼音码
			s ORGHWBCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),16) 		//五笔码
			s ORGHMark=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),17) 		//备注
		
            if (($zcvt(ORGHCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGHDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGHPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGHCode,ORGHDesc,ORGHHierarchyValue,ORGHActivity,ORGHStartDate,ORGHEndDate,ORGHSeqNo,ORGHPYCode,ORGHWBCode,ORGHMark)
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
/// Tables: CT_BDP_CT.HOS_ORGHierarchy
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSORGHierarchy", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGHCode,ORGHDesc:%String")
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
	  	s ORGHCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),2)	//组织级次代码
	    s ORGHDesc= $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),3)	//组织级次名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSORGHierarchyD(ID))
       		q:ID="" 
       		s ORGHCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),2)	//组织级次代码
		    s ORGHDesc= $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),3)	//组织级次名称
		    
			s ORGHHierarchyValue = $listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),4) 	//组织层级数值
			
			s ORGHActivity=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),5) 	//是否有效(Y/N)
			continue:ORGHActivity="N"
			s ORGHStartDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),6) 		//开始日期
			continue:(ORGHStartDate'="")&&(ORGHStartDate>+$h)
			s ORGHEndDate=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),7) 		//结束日期
			continue:(ORGHEndDate'="")&&(ORGHEndDate<+$h)
			

       		s ORGHPYCode=$listget($g(^CT.BDP.CT.HOSORGHierarchyD(ID)),15) 		//拼音码
		
            if (($zcvt(ORGHCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGHDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGHPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
	        	d OutputRowCmb
	    	}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGHCode,ORGHDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSORGHierarchy).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSORGHierarchy).%New()
    s pobj = ##class(CT.BDP.CT.HOSORGHierarchy).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGHCode=pobj.ORGHCode	//组织级次代码
    s eobj.ORGHDesc= pobj.ORGHDesc	//组织级次名称
 
	s eobj.ORGHHierarchyValue=pobj.ORGHHierarchyValue		//组织层级数值
	s eobj.ORGHActivity=pobj.ORGHActivity	//是否有效(Y/N)
	s eobj.ORGHStartDate=pobj.ORGHStartDate		//开始日期
	s:eobj.ORGHStartDate'="" eobj.ORGHStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGHStartDate) 
	s eobj.ORGHEndDate=pobj.ORGHEndDate		//结束日期
	s:eobj.ORGHEndDate'="" eobj.ORGHEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGHEndDate) 
	
	s eobj.ORGHSeqNo=pobj.ORGHSeqNo		//系统排序号
	
	s eobj.ORGHPYCode=pobj.ORGHPYCode		//拼音码
	s eobj.ORGHWBCode=pobj.ORGHWBCode		//五笔码
	s eobj.ORGHMark=pobj.ORGHMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSORGHierarchy
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSORGHierarchy).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSORGHierarchyI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSORGHierarchyI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织级次内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSORGHierarchy
/// Input：     web.Entity.CT.HOSORGHierarchy  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSORGHierarchy).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSORGHierarchy) As %String
{
 
    s result=""
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    }  
    s:eobj.ORGHStartDate'="" eobj.ORGHStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGHStartDate) 
    s:eobj.ORGHEndDate'="" eobj.ORGHEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGHEndDate)
    
    s:eobj.ORGHLastUpdateDate="" eobj.ORGHLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGHLastUpdateTime="" eobj.ORGHLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGHLastUpdateUser="" eobj.ORGHLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGHActivity="" eobj.ORGHActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGHCode,eobj.ORGHDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSORGHierarchy).%New()
            //s eobj.ORGHSeqNo=..GetSeqNo()
            s:eobj.ORGHCreateDate="" eobj.ORGHCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGHCreateTime="" eobj.ORGHCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGHCreateUser="" eobj.ORGHCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGHCreateDate=eobj.ORGHCreateDate		//系统创建日期
			s obj.ORGHCreateTime=eobj.ORGHCreateTime		//系统创建时间
			d obj.ORGHCreateUserSetObjectId(eobj.ORGHCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSORGHierarchy).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSORGHierarchy).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGHCode=obj.ORGHCode	//组织级次代码
            s bobj.ORGHDesc= obj.ORGHDesc	//组织级次名称
            s bobj.ORGHHierarchyValue=obj.ORGHHierarchyValue	//组织层级数值
			s bobj.ORGHActivity=obj.ORGHActivity	//是否有效(Y/N)
			s bobj.ORGHStartDate=obj.ORGHStartDate		//开始日期
			s bobj.ORGHEndDate=obj.ORGHEndDate		//结束日期
			s bobj.ORGHCreateDate=obj.ORGHCreateDate		//系统创建日期
			s bobj.ORGHCreateTime=obj.ORGHCreateTime		//系统创建时间
			if $IsObject(obj.ORGHCreateUser){
				s bobj.ORGHCreateUser = obj.ORGHCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGHSeqNo=obj.ORGHSeqNo		//系统排序号
			s bobj.ORGHLastUpdateDate=obj.ORGHLastUpdateDate		//系统最后更新日期
			s bobj.ORGHLastUpdateTime=obj.ORGHLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGHLastUpdateUser){
				s bobj.ORGHLastUpdateUser = obj.ORGHLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGHPYCode=obj.ORGHPYCode		//拼音码
			s bobj.ORGHWBCode=obj.ORGHWBCode		//五笔码
			s bobj.ORGHMark=obj.ORGHMark		//备注	

        }
        
        s obj.ORGHCode=eobj.ORGHCode	//组织级次代码
        s obj.ORGHDesc= eobj.ORGHDesc	//组织级次名称
		s obj.ORGHHierarchyValue=eobj.ORGHHierarchyValue		//组织层级数值
		s obj.ORGHActivity=eobj.ORGHActivity	//是否有效(Y/N)
		s obj.ORGHStartDate=eobj.ORGHStartDate		//开始日期
		s obj.ORGHEndDate=eobj.ORGHEndDate		//结束日期
		s obj.ORGHSeqNo=eobj.ORGHSeqNo		//系统排序号
		s obj.ORGHLastUpdateDate=eobj.ORGHLastUpdateDate		//系统最后更新日期
		s obj.ORGHLastUpdateTime=eobj.ORGHLastUpdateTime		//系统最后更新时间
		d obj.ORGHLastUpdateUserSetObjectId(eobj.ORGHLastUpdateUser)	//系统最新更新人
		s:eobj.ORGHPYCode="" eobj.ORGHPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGHPYCode)
		s obj.ORGHPYCode=eobj.ORGHPYCode		//拼音码
		s:eobj.ORGHWBCode="" eobj.ORGHWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGHWBCode,1)
		s obj.ORGHWBCode=eobj.ORGHWBCode		//五笔码
		s obj.ORGHMark=eobj.ORGHMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGHierarchy","CT.BDP.CT.HOSORGHierarchy","组织级次",id,eobj.ORGHDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGHierarchy","CT.BDP.CT.HOSORGHierarchy","组织级次",eobj.ID,eobj.ORGHDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织级次","web.DHCBL.CT.HOSORGHierarchy","SaveEntity",eobj)
            s ^ERRORLOGINFO(++logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSORGHierarchy
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSORGHierarchy).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSORGHierarchyI("IndexSeqNo",""),-1)
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
/// Other:w ##class(web.DHCBL.CT.HOSORGHierarchy).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGHCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织级次的内容
/// Table：CT.BDP.CT.HOSORGHierarchy
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSORGHierarchy).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSORGHierarchy).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSORGHierarchy).%New()
    s eobj.ID = id
    s eobj.ORGHCode=pobj.ORGHCode	//组织级次代码
    s eobj.ORGHDesc= pobj.ORGHDesc	//组织级次名称
 
	s eobj.ORGHHierarchyValue=pobj.ORGHHierarchyValue		//组织层级数值
	s eobj.ORGHActivity=pobj.ORGHActivity	//是否有效(Y/N)
	s eobj.ORGHStartDate=pobj.ORGHStartDate		//开始日期
	s eobj.ORGHEndDate=pobj.ORGHEndDate		//结束日期
	s eobj.ORGHSeqNo=pobj.ORGHSeqNo		//系统排序号

	s eobj.ORGHPYCode=pobj.ORGHPYCode		//拼音码
	s eobj.ORGHWBCode=pobj.ORGHWBCode		//五笔码
	s eobj.ORGHMark=pobj.ORGHMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSORGHierarchy).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_ORGHierarchy","CT.BDP.CT.HOSORGHierarchy","组织级次",id,eobj.ORGHDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织级次","web.DHCBL.CT.HOSORGHierarchy","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
