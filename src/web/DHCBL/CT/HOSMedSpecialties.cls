/// Function: HOS 医疗机构二级诊疗科目字典
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSMedSpecialties Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医疗机构二级诊疗科目信息查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT_BDP_CT.HOS_MedSpecialties   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSpecialties","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, subjects As %String) As %Query(ROWSPEC = "ID,MSPECCode,MSPECDesc,MSPECMSUBDesc,MSPECSource,MSPECActivity,MSPECStartDate,MSPECEndDate,MSPECSeqNo,MSPECPYCode,MSPECWBCode,MSPECMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, subjects As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s MSPECCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),2)	//二级诊疗科目代码
	    s MSPECDesc= $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),3)	//二级诊疗科目名称
		s MSPECMSUBDesc=""
		s MSPECMSUBCode = $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),4) 	//一级诊疗科目-外键
		s:MSPECMSUBCode'="" MSPECMSUBDesc=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(MSPECMSUBCode)),3)
		s MSPECSource=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),5) 		//分类来源
		s MSPECActivity=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),6) 	//是否有效(Y/N)
		s MSPECStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),7) 		//开始日期
		s:MSPECStartDate'="" MSPECStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECStartDate) 
		s MSPECEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),8) 		//结束日期
		s:MSPECEndDate'="" MSPECEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECEndDate) 
		s MSPECSeqNo=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),12) 		//系统排序号
		s MSPECPYCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),16) 		//拼音码
		s MSPECWBCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),17) 		//五笔码
		s MSPECMark=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSMedSpecialties).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		
		s AuSubjectsStr=##class(web.DHCBL.Authorize.HOSMedSubjects).DHCGetDataByDefaultSession() //一级诊疗科目
		s AuSubjectsFlag=0
		if (AuSubjectsStr="")||(AuSubjectsStr["limited:0") s AuSubjectsFlag=1 
	    s:code'="" code=$zcvt(code,"U")  
	  	s:desc'="" desc=$zcvt(desc,"U")
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSMedSpecialtiesD(ID))
            q:ID="" 
            s MSPECCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),2)	//二级诊疗科目代码
		    s MSPECDesc= $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),3)	//二级诊疗科目名称
			s MSPECMSUBDesc=""
			s MSPECMSUBCode = $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),4) 	//一级诊疗科目-外键
			s:MSPECMSUBCode'="" MSPECMSUBDesc=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(MSPECMSUBCode)),3)
			s MSPECSource=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),5) 		//分类来源
			s MSPECActivity=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),6) 	//是否有效(Y/N)
			s MSPECStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),7) 		//开始日期
			s:MSPECStartDate'="" MSPECStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECStartDate) 
			s MSPECEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),8) 		//结束日期
			s:MSPECEndDate'="" MSPECEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECEndDate) 
			s MSPECSeqNo=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),12) 		//系统排序号
			s MSPECPYCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),16) 		//拼音码
			s MSPECWBCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),17) 		//五笔码
			s MSPECMark=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),18) 		//备注
			s strRowId = "{ID:"_ID_"}"
			s strSubjectsRowId = "{ID:"_MSPECMSUBCode_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuSubjectsStr[strSubjectsRowId)||(AuSubjectsFlag=1)) //授权数据筛选
			{
	            if ($zcvt(MSPECCode,"U")[code)&(($zcvt(MSPECDesc,"U")[desc)||($zcvt(MSPECPYCode,"U")[desc))&((MSPECMSUBCode=subjects)||(subjects=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,MSPECCode,MSPECDesc,MSPECMSUBDesc,MSPECSource,MSPECActivity,MSPECStartDate,MSPECEndDate,MSPECSeqNo,MSPECPYCode,MSPECWBCode,MSPECMark)
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
/// Tables: CT_BDP_CT.HOS_MedSpecialties
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSpecialties", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,MSPECCode,MSPECDesc:%String")
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
	  	s MSPECCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),2)	//二级诊疗科目代码
    	s MSPECDesc= $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),3)	//二级诊疗科目名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSMedSpecialties).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		s AuSubjectsStr=##class(web.DHCBL.Authorize.HOSMedSubjects).DHCGetDataByDefaultSession() //一级诊疗科目
		s AuSubjectsFlag=0
		if (AuSubjectsStr="")||(AuSubjectsStr["limited:0") s AuSubjectsFlag=1 
		
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSMedSpecialtiesD(ID))
       		q:ID="" 
       		s MSPECCode=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),2)	//二级诊疗科目代码
	    	s MSPECDesc= $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),3)	//二级诊疗科目名称
	    	s MSPECMSUBCode = $listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),4) 	//一级诊疗科目-外键
	    
			s MSPECActivity=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),6) 	//是否有效(Y/N)
			continue:MSPECActivity="N"
	    	s MSPECStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),7) 		//开始日期
	    	continue:(MSPECStartDate'="")&&(MSPECStartDate>+$h)
			s MSPECEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(ID)),8) 		//结束日期
	  		continue:(MSPECEndDate'="")&&(MSPECEndDate<+$h)
			s strRowId = "{ID:"_ID_"}"
			s strSubjectsRowId = "{ID:"_MSPECMSUBCode_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuSubjectsStr[strSubjectsRowId)||(AuSubjectsFlag=1)) //授权数据筛选
			{
		    	if (($ZCONVERT(MSPECDesc,"U")[desc)&&($ZCONVERT(MSPECCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,MSPECCode,MSPECDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSMedSpecialties).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSMedSpecialties).%New()
    s pobj = ##class(CT.BDP.CT.HOSMedSpecialties).%OpenId(id)
    s eobj.ID=id
    s eobj.MSPECCode=pobj.MSPECCode	//二级诊疗科目代码
    s eobj.MSPECDesc= pobj.MSPECDesc	//二级诊疗科目名称
    s:$IsObject(pobj.MSPECMSUBCode) eobj.MSPECMSUBCode = pobj.MSPECMSUBCode.%Id() 	//一级诊疗科目-外键 
	s eobj.MSPECSource=pobj.MSPECSource		//分类来源
	s eobj.MSPECActivity=pobj.MSPECActivity	//是否有效(Y/N)
	s eobj.MSPECStartDate=pobj.MSPECStartDate		//开始日期
	s:eobj.MSPECStartDate'="" eobj.MSPECStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSPECStartDate) 
	s eobj.MSPECEndDate=pobj.MSPECEndDate		//结束日期
	s:eobj.MSPECEndDate'="" eobj.MSPECEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSPECEndDate) 
	s eobj.MSPECSeqNo=pobj.MSPECSeqNo		//系统排序号
	s eobj.MSPECPYCode=pobj.MSPECPYCode		//拼音码
	s eobj.MSPECWBCode=pobj.MSPECWBCode		//五笔码
	s eobj.MSPECMark=pobj.MSPECMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-18
/// Table：   CT.BDP.CT.HOSMedSpecialties
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSMedSpecialties).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSMedSpecialtiesI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSMedSpecialtiesI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医疗机构二级诊疗科目内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT.BDP.CT.HOSMedSpecialties
/// Input：     web.Entity.CT.HOSMedSpecialties  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSMedSpecialties).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSMedSpecialties) As %String
{
 
    s result="" 
    s UserID=""
    s:$d(%session) UserID=$g(%session.Data("LOGON.USERID"))  
     
    s:eobj.MSPECStartDate'="" eobj.MSPECStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSPECStartDate) 
    s:eobj.MSPECEndDate'="" eobj.MSPECEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSPECEndDate)
    s:eobj.MSPECStartDate="" eobj.MSPECStartDate=+$h
    
    s:eobj.MSPECLastUpdateDate="" eobj.MSPECLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.MSPECLastUpdateTime="" eobj.MSPECLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.MSPECLastUpdateUser="" eobj.MSPECLastUpdateUser=UserID	//系统最新更新人
    s:eobj.MSPECActivity="" eobj.MSPECActivity="N"		//是否有效
    
    s:eobj.MSPECPYCode="" eobj.MSPECPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.MSPECDesc,4)
    s:eobj.MSPECWBCode="" eobj.MSPECWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.MSPECDesc,1)
    
    s flag=  ..FormValidate(eobj.ID,eobj.MSPECCode,eobj.MSPECDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSMedSpecialties).%New()
            s:eobj.MSPECCreateDate="" eobj.MSPECCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.MSPECCreateTime="" eobj.MSPECCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.MSPECCreateUser="" eobj.MSPECCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.MSPECCreateDate=eobj.MSPECCreateDate		//系统创建日期
			s obj.MSPECCreateTime=eobj.MSPECCreateTime		//系统创建时间
			d obj.MSPECCreateUserSetObjectId(eobj.MSPECCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSMedSpecialties).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSMedSpecialties).%New()
            s bobj.ID=eobj.ID 
            s bobj.MSPECCode=obj.MSPECCode	//二级诊疗科目代码
            s bobj.MSPECDesc= obj.MSPECDesc	//二级诊疗科目名称
            s:$IsObject(obj.MSPECMSUBCode) bobj.MSPECMSUBCode = obj.MSPECMSUBCode.%Id() 	//一级诊疗科目-外键
			s bobj.MSPECSource=obj.MSPECSource		//分类来源
			s bobj.MSPECActivity=obj.MSPECActivity	//是否有效(Y/N)
			s bobj.MSPECStartDate=obj.MSPECStartDate		//开始日期
			s bobj.MSPECEndDate=obj.MSPECEndDate		//结束日期
			s bobj.MSPECCreateDate=obj.MSPECCreateDate		//系统创建日期
			s bobj.MSPECCreateTime=obj.MSPECCreateTime		//系统创建时间
			s:$IsObject(obj.MSPECCreateUser) bobj.MSPECCreateUser = obj.MSPECCreateUser.%Id() 	//系统创建人
			s bobj.MSPECSeqNo=obj.MSPECSeqNo		//系统排序号
			s bobj.MSPECLastUpdateDate=obj.MSPECLastUpdateDate		//系统最后更新日期
			s bobj.MSPECLastUpdateTime=obj.MSPECLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.MSPECLastUpdateUser) bobj.MSPECLastUpdateUser = obj.MSPECLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.MSPECPYCode=obj.MSPECPYCode		//拼音码
			s bobj.MSPECWBCode=obj.MSPECWBCode		//五笔码
			s bobj.MSPECMark=obj.MSPECMark		//备注

        }
        
        s obj.MSPECCode=eobj.MSPECCode	//二级诊疗科目代码
        s obj.MSPECDesc= eobj.MSPECDesc	//二级诊疗科目名称
        d obj.MSPECMSUBCodeSetObjectId(eobj.MSPECMSUBCode)	//一级诊疗科目-外键
		s obj.MSPECSource=eobj.MSPECSource		//分类来源
		s obj.MSPECActivity=eobj.MSPECActivity	//是否有效(Y/N)
		s obj.MSPECStartDate=eobj.MSPECStartDate		//开始日期
		s obj.MSPECEndDate=eobj.MSPECEndDate		//结束日期
		s obj.MSPECSeqNo=eobj.MSPECSeqNo		//系统排序号
		s obj.MSPECLastUpdateDate=eobj.MSPECLastUpdateDate		//系统最后更新日期
		s obj.MSPECLastUpdateTime=eobj.MSPECLastUpdateTime		//系统最后更新时间
		d obj.MSPECLastUpdateUserSetObjectId(eobj.MSPECLastUpdateUser)	//系统最新更新人
		s obj.MSPECPYCode=eobj.MSPECPYCode		//拼音码
		s obj.MSPECWBCode=eobj.MSPECWBCode		//五笔码
		s obj.MSPECMark=eobj.MSPECMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecialties","CT.BDP.CT.HOSMedSpecialties","医疗机构二级诊疗科目",id,eobj.MSPECDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecialties","CT.BDP.CT.HOSMedSpecialties","医疗机构二级诊疗科目",eobj.ID,eobj.MSPECDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构二级诊疗科目","web.DHCBL.CT.HOSMedSpecialties","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSMedSpecialties).GetRefFlag("6")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.HOSMedSpecItemsI("IndexMSPECCode",id))
    {
	    s myInfo=myInfo_"<医疗机构三级诊疗科目字典>"
	}
	if $d(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexMSPECCode",id))
    {
	    s myInfo=myInfo_"<医疗机构诊疗科目>"
	}
	
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description：根据ID删除医疗机构二级诊疗科目的内容
/// Table：CT.BDP.CT.HOSMedSpecialties
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSMedSpecialties).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.HOSMedSpecialties).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSMedSpecialties).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSMedSpecialties).%New()
	    s eobj.ID = id
	    s eobj.MSPECCode=pobj.MSPECCode	//二级诊疗科目代码
	    s eobj.MSPECDesc= pobj.MSPECDesc	//二级诊疗科目名称
	    s:$IsObject(pobj.MSPECMSUBCode) eobj.MSPECMSUBCode = pobj.MSPECMSUBCode.%Id() 	//一级诊疗科目-外键
		s eobj.MSPECSource=pobj.MSPECSource		//分类来源
		s eobj.MSPECActivity=pobj.MSPECActivity	//是否有效(Y/N)
		s eobj.MSPECStartDate=pobj.MSPECStartDate		//开始日期
		s eobj.MSPECEndDate=pobj.MSPECEndDate		//结束日期
		s eobj.MSPECCreateDate=pobj.MSPECCreateDate		//系统创建日期
		s eobj.MSPECCreateTime=pobj.MSPECCreateTime		//系统创建时间
		s:$IsObject(pobj.MSPECCreateUser) eobj.MSPECCreateUser = pobj.MSPECCreateUser.%Id() 	//系统创建人
		s eobj.MSPECSeqNo=pobj.MSPECSeqNo		//系统排序号
		s eobj.MSPECLastUpdateDate=pobj.MSPECLastUpdateDate		//系统最后更新日期
		s eobj.MSPECLastUpdateTime=pobj.MSPECLastUpdateTime		//系统最后更新时间
		s:$IsObject(pobj.MSPECLastUpdateUser) eobj.MSPECLastUpdateUser = pobj.MSPECLastUpdateUser.%Id() 	//系统最新更新人
		s eobj.MSPECPYCode=pobj.MSPECPYCode		//拼音码
		s eobj.MSPECWBCode=pobj.MSPECWBCode		//五笔码
		s eobj.MSPECMark=pobj.MSPECMark		//备注
		
	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSMedSpecialties).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecialties","CT.BDP.CT.HOSMedSpecialties","医疗机构二级诊疗科目",id,eobj.MSPECDesc,"D",eobj)
	        d eobj.%Close()
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构二级诊疗科目","web.DHCBL.CT.HOSMedSpecialties","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
	}
    q result
}

}
