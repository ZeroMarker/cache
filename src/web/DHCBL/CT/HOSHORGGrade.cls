/// Function: HOS 医院等级
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSHORGGrade Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医院等级查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT_BDP_CT.HOS_HORGGrade   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSHORGGrade","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,HORGGCCode,HORGGCDesc,HORGGCGrade,HORGGCGradeClass,HORGGCSource,HORGGCActivity,HORGGCStartDate,HORGGCEndDate,HORGGCSeqNo,HORGGCPYCode,HORGGCWBCode,HORGGCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s HORGGCCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),2)	//医院等级代码
	    s HORGGCDesc= $listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),3)	//医院等级名称
	    s HORGGCGrade=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),4) 		//医院级别代码 
	    s HORGGCGradeClass=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),5) 		//医院子级代码 
		s HORGGCSource=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),6) 		//分类来源
		s HORGGCActivity=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),7) 	//是否有效(Y/N)
		s HORGGCStartDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),8) 		//开始日期
		s:HORGGCStartDate'="" HORGGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGGCStartDate) 
		s HORGGCEndDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),9) 		//结束日期
		s:HORGGCEndDate'="" HORGGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGGCEndDate) 
		s HORGGCSeqNo=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),13) 		//系统排序号
		s HORGGCPYCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),17) 		//拼音码
		s HORGGCWBCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),18) 		//五笔码
		s HORGGCMark=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),19) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s:code'="" code=$zcvt(code,"U")  
  		s:desc'="" desc=$zcvt(desc,"U")  
  		s AuStr=##class(web.DHCBL.Authorize.HOSHORGGrade).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSHORGGradeD(ID))
            q:ID="" 
            s HORGGCCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),2)	//医院等级代码
		    s HORGGCDesc= $listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),3)	//医院等级名称
		    s HORGGCGrade=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),4) 		//医院级别代码 
			s HORGGCGradeClass=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),5) 		//医院子级代码 
			s HORGGCSource=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),6) 		//分类来源
			s HORGGCActivity=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),7) 	//是否有效(Y/N)
			s HORGGCStartDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),8) 		//开始日期
			s:HORGGCStartDate'="" HORGGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGGCStartDate) 
			s HORGGCEndDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),9) 		//结束日期
			s:HORGGCEndDate'="" HORGGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HORGGCEndDate) 
			s HORGGCSeqNo=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),13) 		//系统排序号
			s HORGGCPYCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),17) 		//拼音码
			s HORGGCWBCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),18) 		//五笔码
			s HORGGCMark=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),19) 		//备注
			
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
	            if ($zcvt(HORGGCCode,"U")[code)&(($zcvt(HORGGCDesc,"U")[desc)||($zcvt(HORGGCPYCode,"U")[desc))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,HORGGCCode,HORGGCDesc,HORGGCGrade,HORGGCGradeClass,HORGGCSource,HORGGCActivity,HORGGCStartDate,HORGGCEndDate,HORGGCSeqNo,HORGGCPYCode,HORGGCWBCode,HORGGCMark)
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
/// CreatDate:2022-11-18
/// Tables: CT_BDP_CT.HOS_HORGGrade
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSHORGGrade", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,HORGGCCode,HORGGCDesc:%String")
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
	  	s HORGGCCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),2)	//医院等级代码
    	s HORGGCDesc= $listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),3)	//医院等级名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSHORGGrade).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSHORGGradeD(ID))
       		q:ID="" 
       		s HORGGCCode=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),2)	//医院等级代码
	    	s HORGGCDesc= $listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),3)	//医院等级名称
			s HORGGCActivity=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),7) 	//是否有效(Y/N)
			continue:HORGGCActivity="N"
	    	s HORGGCStartDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),8) 		//开始日期
	    	continue:(HORGGCStartDate'="")&&(HORGGCStartDate>+$h)
			s HORGGCEndDate=$listget($g(^CT.BDP.CT.HOSHORGGradeD(ID)),9) 		//结束日期
	  		continue:(HORGGCEndDate'="")&&(HORGGCEndDate<+$h)
	  		
	  		s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
		    	if (($ZCONVERT(HORGGCDesc,"U")[desc)&&($ZCONVERT(HORGGCCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,HORGGCCode,HORGGCDesc)
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
/// CreatDate: 2022-11-18
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSHORGGrade).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSHORGGrade).%New()
    s pobj = ##class(CT.BDP.CT.HOSHORGGrade).%OpenId(id)
    s eobj.ID=id
    s eobj.HORGGCCode=pobj.HORGGCCode	//医院等级代码
    s eobj.HORGGCDesc= pobj.HORGGCDesc	//医院等级名称
    s eobj.HORGGCGrade=pobj.HORGGCGrade  //医院级别代码 
    s eobj.HORGGCGradeClass=pobj.HORGGCGradeClass  //医院子级代码 
	s eobj.HORGGCSource=pobj.HORGGCSource		//分类来源
	s eobj.HORGGCActivity=pobj.HORGGCActivity	//是否有效(Y/N)
	s eobj.HORGGCStartDate=pobj.HORGGCStartDate		//开始日期
	s:eobj.HORGGCStartDate'="" eobj.HORGGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGGCStartDate) 
	s eobj.HORGGCEndDate=pobj.HORGGCEndDate		//结束日期
	s:eobj.HORGGCEndDate'="" eobj.HORGGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.HORGGCEndDate) 
	s eobj.HORGGCSeqNo=pobj.HORGGCSeqNo		//系统排序号
	s eobj.HORGGCPYCode=pobj.HORGGCPYCode		//拼音码
	s eobj.HORGGCWBCode=pobj.HORGGCWBCode		//五笔码
	s eobj.HORGGCMark=pobj.HORGGCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-18
/// Table：   CT.BDP.CT.HOSHORGGrade
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSHORGGrade).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSHORGGradeI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	    
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSHORGGradeI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医院等级内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT.BDP.CT.HOSHORGGrade
/// Input：     web.Entity.CT.HOSHORGGrade  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSHORGGrade).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSHORGGrade) As %String
{
 
    s result="" 
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 

    s:eobj.HORGGCStartDate'="" eobj.HORGGCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGGCStartDate) 
    s:eobj.HORGGCEndDate'="" eobj.HORGGCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HORGGCEndDate)
    s:eobj.HORGGCStartDate="" eobj.HORGGCStartDate=+$h
    
    s:eobj.HORGGCLastUpdateDate="" eobj.HORGGCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.HORGGCLastUpdateTime="" eobj.HORGGCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.HORGGCLastUpdateUser="" eobj.HORGGCLastUpdateUser=USERID	//系统最新更新人
    s:eobj.HORGGCActivity="" eobj.HORGGCActivity="N"		//是否有效
    
    s:eobj.HORGGCPYCode="" eobj.HORGGCPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.HORGGCDesc,4)
    s:eobj.HORGGCWBCode="" eobj.HORGGCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.HORGGCDesc,1)
    s flag=  ..FormValidate(eobj.ID,eobj.HORGGCCode,eobj.HORGGCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSHORGGrade).%New()
            s:eobj.HORGGCCreateDate="" eobj.HORGGCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.HORGGCCreateTime="" eobj.HORGGCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.HORGGCCreateUser="" eobj.HORGGCCreateUser= USERID		//系统创建人默认当前登录人员
		    s obj.HORGGCCreateDate=eobj.HORGGCCreateDate		//系统创建日期
			s obj.HORGGCCreateTime=eobj.HORGGCCreateTime		//系统创建时间
			d obj.HORGGCCreateUserSetObjectId(eobj.HORGGCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSHORGGrade).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSHORGGrade).%New()
            s bobj.ID=eobj.ID 
            s bobj.HORGGCCode=obj.HORGGCCode	//医院等级代码
            s bobj.HORGGCDesc= obj.HORGGCDesc	//医院等级名称 
            s bobj.HORGGCGrade=obj.HORGGCGrade  //医院级别代码
			s bobj.HORGGCGradeClass=obj.HORGGCGradeClass  //医院子级代码 
			s bobj.HORGGCSource=obj.HORGGCSource		//分类来源
			s bobj.HORGGCActivity=obj.HORGGCActivity	//是否有效(Y/N)
			s bobj.HORGGCStartDate=obj.HORGGCStartDate		//开始日期
			s bobj.HORGGCEndDate=obj.HORGGCEndDate		//结束日期
			s bobj.HORGGCCreateDate=obj.HORGGCCreateDate		//系统创建日期
			s bobj.HORGGCCreateTime=obj.HORGGCCreateTime		//系统创建时间
			s:$IsObject(obj.HORGGCCreateUser) bobj.HORGGCCreateUser = obj.HORGGCCreateUser.%Id() 	//系统创建人
			s bobj.HORGGCSeqNo=obj.HORGGCSeqNo		//系统排序号
			s bobj.HORGGCLastUpdateDate=obj.HORGGCLastUpdateDate		//系统最后更新日期
			s bobj.HORGGCLastUpdateTime=obj.HORGGCLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.HORGGCLastUpdateUser) bobj.HORGGCLastUpdateUser = obj.HORGGCLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.HORGGCPYCode=obj.HORGGCPYCode		//拼音码
			s bobj.HORGGCWBCode=obj.HORGGCWBCode		//五笔码
			s bobj.HORGGCMark=obj.HORGGCMark		//备注

        }
        
        s obj.HORGGCCode=eobj.HORGGCCode	//医院等级代码
        s obj.HORGGCDesc= eobj.HORGGCDesc	//医院等级名称
        s obj.HORGGCGrade=eobj.HORGGCGrade  //医院级别代码 
		s obj.HORGGCGradeClass=eobj.HORGGCGradeClass  //医院子级代码 
		s obj.HORGGCSource=eobj.HORGGCSource		//分类来源
		s obj.HORGGCActivity=eobj.HORGGCActivity	//是否有效(Y/N)
		s obj.HORGGCStartDate=eobj.HORGGCStartDate		//开始日期
		s obj.HORGGCEndDate=eobj.HORGGCEndDate		//结束日期
		s obj.HORGGCSeqNo=eobj.HORGGCSeqNo		//系统排序号
		s obj.HORGGCLastUpdateDate=eobj.HORGGCLastUpdateDate		//系统最后更新日期
		s obj.HORGGCLastUpdateTime=eobj.HORGGCLastUpdateTime		//系统最后更新时间
		d obj.HORGGCLastUpdateUserSetObjectId(eobj.HORGGCLastUpdateUser)	//系统最新更新人
		s obj.HORGGCPYCode=eobj.HORGGCPYCode		//拼音码
		s obj.HORGGCWBCode=eobj.HORGGCWBCode		//五笔码
		s obj.HORGGCMark=eobj.HORGGCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGGrade","CT.BDP.CT.HOSHORGGrade","医院等级",id,eobj.HORGGCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGGrade","CT.BDP.CT.HOSHORGGrade","医院等级",eobj.ID,eobj.HORGGCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院等级","web.DHCBL.CT.HOSHORGGrade","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSHORGGrade).GetRefFlag("6")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT("RFC",0,"OrgGrade",id))
    {
	    s myInfo=myInfo_"<医疗机构>"
	}
	
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description：根据ID删除医院等级的内容
/// Table：CT.BDP.CT.HOSHORGGrade
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSHORGGrade).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.HOSHORGGrade).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSHORGGrade).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSHORGGrade).%New()
	    s eobj.ID = id
	    s eobj.HORGGCCode=pobj.HORGGCCode	//医院等级代码
	    s eobj.HORGGCDesc= pobj.HORGGCDesc	//医院等级名称
	    s eobj.HORGGCGrade=pobj.HORGGCGrade  //医院级别代码 
		s eobj.HORGGCGradeClass=pobj.HORGGCGradeClass  //医院子级代码 
		s eobj.HORGGCSource=pobj.HORGGCSource		//分类来源
		s eobj.HORGGCActivity=pobj.HORGGCActivity	//是否有效(Y/N)
		s eobj.HORGGCStartDate=pobj.HORGGCStartDate		//开始日期
		s eobj.HORGGCEndDate=pobj.HORGGCEndDate		//结束日期
		s eobj.HORGGCCreateDate=pobj.HORGGCCreateDate		//系统创建日期
		s eobj.HORGGCCreateTime=pobj.HORGGCCreateTime		//系统创建时间
		s:$IsObject(pobj.HORGGCCreateUser) eobj.HORGGCCreateUser = pobj.HORGGCCreateUser.%Id() 	//系统创建人
		s eobj.HORGGCSeqNo=pobj.HORGGCSeqNo		//系统排序号
		s eobj.HORGGCLastUpdateDate=pobj.HORGGCLastUpdateDate		//系统最后更新日期
		s eobj.HORGGCLastUpdateTime=pobj.HORGGCLastUpdateTime		//系统最后更新时间
		s:$IsObject(pobj.HORGGCLastUpdateUser) eobj.HORGGCLastUpdateUser = pobj.HORGGCLastUpdateUser.%Id() 	//系统最新更新人
		s eobj.HORGGCPYCode=pobj.HORGGCPYCode		//拼音码
		s eobj.HORGGCWBCode=pobj.HORGGCWBCode		//五笔码
		s eobj.HORGGCMark=pobj.HORGGCMark		//备注
		
	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSHORGGrade).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_HORGGrade","CT.BDP.CT.HOSHORGGrade","医院等级",id,eobj.HORGGCDesc,"D",eobj)
	        d eobj.%Close()
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院等级","web.DHCBL.CT.HOSHORGGrade","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
	}
    q result
}

}
