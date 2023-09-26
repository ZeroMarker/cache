/// Function: 组织机构行业分类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrgInduCategory Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构行业分类信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_OrgInduCategory   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgInduCategory","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, parentid) As %Query(ROWSPEC = "ID,ORGICCode,ORGICDesc,ORGICSource,ORGICActivity,ORGICStartDate,ORGICEndDate,ORGICSeqNo,ORGICPYCode,ORGICWBCode,ORGICMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, parentid) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s ORGICCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),2)	//组织机构行业分类代码
	    s ORGICDesc= $listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),3)	//组织机构行业分类名称
	    			
		s ORGICSource=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),4) 		//分类来源
		s ORGICActivity=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),5) 	//是否有效(Y/N)
		s ORGICStartDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),6) 		//开始日期
		s:ORGICStartDate'="" ORGICStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGICStartDate) 
		s ORGICEndDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),7) 		//结束日期
		s:ORGICEndDate'="" ORGICEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGICEndDate) 
		
		
		s ORGICSeqNo=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),11) 		//系统排序号
		
		s ORGICPYCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),15) 		//拼音码
		s ORGICWBCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),16) 		//五笔码
		s ORGICMark=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),17) 		//备注
	
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrgInduCategoryD(ID))
            q:ID="" 
            s ORGICCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),2)	//组织机构行业分类代码
		    s ORGICDesc= $listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),3)	//组织机构行业分类名称
		    			
			s ORGICSource=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),4) 		//分类来源
			s ORGICActivity=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),5) 	//是否有效(Y/N)
			s ORGICStartDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),6) 		//开始日期
			s:ORGICStartDate'="" ORGICStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGICStartDate) 
			s ORGICEndDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),7) 		//结束日期
			s:ORGICEndDate'="" ORGICEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGICEndDate) 
			
			
			s ORGICSeqNo=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),11) 		//系统排序号
			
			s ORGICPYCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),15) 		//拼音码
			s ORGICWBCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),16) 		//五笔码
			s ORGICMark=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),17) 		//备注
		
            if (($zcvt(ORGICCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGICDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGICPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGICCode,ORGICDesc,ORGICSource,ORGICActivity,ORGICStartDate,ORGICEndDate,ORGICSeqNo,ORGICPYCode,ORGICWBCode,ORGICMark)
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
/// Tables: CT_BDP_CT.HOS_OrgInduCategory
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrgInduCategory", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGICCode,ORGICDesc:%String")
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
	  	s ORGICCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),2)	//组织机构行业分类代码
    	s ORGICDesc= $listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),3)	//组织机构行业分类名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrgInduCategoryD(ID))
       		q:ID="" 
       		s ORGICCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),2)	//组织机构行业分类代码
	    	s ORGICDesc= $listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),3)	//组织机构行业分类名称
	    	
			s ORGICActivity=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),5) 	//是否有效(Y/N)
			continue:ORGICActivity="N"
	    	s ORGICStartDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),6) 		//开始日期
	    	continue:(ORGICStartDate'="")&&(ORGICStartDate>+$h)
			s ORGICEndDate=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),7) 		//结束日期
	  		continue:(ORGICEndDate'="")&&(ORGICEndDate<+$h)

       		s ORGICPYCode=$listget($g(^CT.BDP.CT.HOSOrgInduCategoryD(ID)),15) 		//拼音码
            if (($zcvt(ORGICCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGICDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGICPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
            {
	        	d OutputRowCmb
	    	}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGICCode,ORGICDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrgInduCategory).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrgInduCategory).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrgInduCategory).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGICCode=pobj.ORGICCode	//组织机构行业分类代码
    s eobj.ORGICDesc= pobj.ORGICDesc	//组织机构行业分类名称
	s eobj.ORGICSource=pobj.ORGICSource		//分类来源
	s eobj.ORGICActivity=pobj.ORGICActivity	//是否有效(Y/N)
	s eobj.ORGICStartDate=pobj.ORGICStartDate		//开始日期
	s:eobj.ORGICStartDate'="" eobj.ORGICStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGICStartDate) 
	s eobj.ORGICEndDate=pobj.ORGICEndDate		//结束日期
	s:eobj.ORGICEndDate'="" eobj.ORGICEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGICEndDate) 
	s eobj.ORGICSeqNo=pobj.ORGICSeqNo		//系统排序号
	
	s eobj.ORGICPYCode=pobj.ORGICPYCode		//拼音码
	s eobj.ORGICWBCode=pobj.ORGICWBCode		//五笔码
	s eobj.ORGICMark=pobj.ORGICMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrgInduCategory
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrgInduCategory).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrgInduCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrgInduCategoryI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织机构行业分类内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrgInduCategory
/// Input：     web.Entity.CT.HOSOrgInduCategory  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrgInduCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrgInduCategory) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGICStartDate'="" eobj.ORGICStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGICStartDate) 
    s:eobj.ORGICEndDate'="" eobj.ORGICEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGICEndDate)
    
    s:eobj.ORGICLastUpdateDate="" eobj.ORGICLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGICLastUpdateTime="" eobj.ORGICLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGICLastUpdateUser="" eobj.ORGICLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGICActivity="" eobj.ORGICActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGICCode,eobj.ORGICDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrgInduCategory).%New()
            //s eobj.ORGICSeqNo=..GetSeqNo()
            s:eobj.ORGICCreateDate="" eobj.ORGICCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGICCreateTime="" eobj.ORGICCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGICCreateUser="" eobj.ORGICCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGICCreateDate=eobj.ORGICCreateDate		//系统创建日期
			s obj.ORGICCreateTime=eobj.ORGICCreateTime		//系统创建时间
			d obj.ORGICCreateUserSetObjectId(eobj.ORGICCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrgInduCategory).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrgInduCategory).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGICCode=obj.ORGICCode	//组织机构行业分类代码
            s bobj.ORGICDesc= obj.ORGICDesc	//组织机构行业分类名称
			s bobj.ORGICSource=obj.ORGICSource		//分类来源
			s bobj.ORGICActivity=obj.ORGICActivity	//是否有效(Y/N)
			s bobj.ORGICStartDate=obj.ORGICStartDate		//开始日期
			s bobj.ORGICEndDate=obj.ORGICEndDate		//结束日期
			s bobj.ORGICCreateDate=obj.ORGICCreateDate		//系统创建日期
			s bobj.ORGICCreateTime=obj.ORGICCreateTime		//系统创建时间
			if $IsObject(obj.ORGICCreateUser){
				s bobj.ORGICCreateUser = obj.ORGICCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGICSeqNo=obj.ORGICSeqNo		//系统排序号
			s bobj.ORGICLastUpdateDate=obj.ORGICLastUpdateDate		//系统最后更新日期
			s bobj.ORGICLastUpdateTime=obj.ORGICLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGICLastUpdateUser){
				s bobj.ORGICLastUpdateUser = obj.ORGICLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGICPYCode=obj.ORGICPYCode		//拼音码
			s bobj.ORGICWBCode=obj.ORGICWBCode		//五笔码
			s bobj.ORGICMark=obj.ORGICMark		//备注

        }
        
        s obj.ORGICCode=eobj.ORGICCode	//组织机构行业分类代码
        s obj.ORGICDesc= eobj.ORGICDesc	//组织机构行业分类名称

		s obj.ORGICSource=eobj.ORGICSource		//分类来源
		s obj.ORGICActivity=eobj.ORGICActivity	//是否有效(Y/N)
		s obj.ORGICStartDate=eobj.ORGICStartDate		//开始日期
		s obj.ORGICEndDate=eobj.ORGICEndDate		//结束日期
		
		s obj.ORGICSeqNo=eobj.ORGICSeqNo		//系统排序号
		s obj.ORGICLastUpdateDate=eobj.ORGICLastUpdateDate		//系统最后更新日期
		s obj.ORGICLastUpdateTime=eobj.ORGICLastUpdateTime		//系统最后更新时间
		d obj.ORGICLastUpdateUserSetObjectId(eobj.ORGICLastUpdateUser)	//系统最新更新人
		s:eobj.ORGICPYCode="" eobj.ORGICPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGICDesc)
		s obj.ORGICPYCode=eobj.ORGICPYCode		//拼音码
		s:eobj.ORGICWBCode="" eobj.ORGICWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGICDesc,1)
		s obj.ORGICWBCode=eobj.ORGICWBCode		//五笔码
		s obj.ORGICMark=eobj.ORGICMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgInduCategory","CT.BDP.CT.HOSOrgInduCategory","组织机构行业分类",id,eobj.ORGICDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgInduCategory","CT.BDP.CT.HOSOrgInduCategory","组织机构行业分类",eobj.ID,eobj.ORGICDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构行业分类","web.DHCBL.CT.HOSOrgInduCategory","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrgInduCategory).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
	if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGICCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    } 
    if $d(^CT.BDP.CT.HOSOrgCategoryI("IndexInduCategory",id)){
        s myInfo=myInfo_"<组织机构大类>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构行业分类的内容
/// Table：CT.BDP.CT.HOSOrgInduCategory
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrgInduCategory).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){ 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSOrgInduCategory).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSOrgInduCategory).%New()
    s eobj.ID = id
    s eobj.ORGICCode=pobj.ORGICCode	//组织机构行业分类代码
    s eobj.ORGICDesc= pobj.ORGICDesc	//组织机构行业分类名称
 
	s eobj.ORGICSource=pobj.ORGICSource		//分类来源
	s eobj.ORGICActivity=pobj.ORGICActivity	//是否有效(Y/N)
	s eobj.ORGICStartDate=pobj.ORGICStartDate		//开始日期
	s eobj.ORGICEndDate=pobj.ORGICEndDate		//结束日期
	
	s eobj.ORGICSeqNo=pobj.ORGICSeqNo		//系统排序号
	
	s eobj.ORGICPYCode=pobj.ORGICPYCode		//拼音码
	s eobj.ORGICWBCode=pobj.ORGICWBCode		//五笔码
	s eobj.ORGICMark=pobj.ORGICMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSOrgInduCategory).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_OrgInduCategory","CT.BDP.CT.HOSOrgInduCategory","组织机构行业分类",id,eobj.ORGICDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构行业分类","web.DHCBL.CT.HOSOrgInduCategory","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
