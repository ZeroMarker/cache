/// Function: HOS 医疗机构一级诊疗科目字典
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSMedSubjects Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医疗机构一级诊疗科目查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT_BDP_CT.HOS_MedSubjects   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSubjects","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,MSUBCode,MSUBDesc,MSUBSource,MSUBActivity,MSUBStartDate,MSUBEndDate,MSUBSeqNo,MSUBPYCode,MSUBWBCode,MSUBMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s MSUBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),2)	//一级诊疗科目代码
	    s MSUBDesc= $listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),3)	//一级诊疗科目名称
		s MSUBSource=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),4) 		//分类来源
		s MSUBActivity=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),5) 	//是否有效(Y/N)
		s MSUBStartDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),6) 		//开始日期
		s:MSUBStartDate'="" MSUBStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSUBStartDate) 
		s MSUBEndDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),7) 		//结束日期
		s:MSUBEndDate'="" MSUBEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSUBEndDate) 
		s MSUBSeqNo=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),11) 		//系统排序号
		s MSUBPYCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),15) 		//拼音码
		s MSUBWBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),16) 		//五笔码
		s MSUBMark=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),17) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSMedSubjects).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    	s:code'="" code=$zcvt(code,"U")  
  		s:desc'="" desc=$zcvt(desc,"U")
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSMedSubjectsD(ID))
            q:ID="" 
            s MSUBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),2)	//一级诊疗科目代码
		    s MSUBDesc= $listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),3)	//一级诊疗科目名称
			s MSUBSource=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),4) 		//分类来源
			s MSUBActivity=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),5) 	//是否有效(Y/N)
			s MSUBStartDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),6) 		//开始日期
			s:MSUBStartDate'="" MSUBStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSUBStartDate) 
			s MSUBEndDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),7) 		//结束日期
			s:MSUBEndDate'="" MSUBEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSUBEndDate) 
			s MSUBSeqNo=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),11) 		//系统排序号
			s MSUBPYCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),15) 		//拼音码
			s MSUBWBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),16) 		//五笔码
			s MSUBMark=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),17) 		//备注
			
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
	            if ($zcvt(MSUBCode,"U")[code)&(($zcvt(MSUBDesc,"U")[desc)||($zcvt(MSUBPYCode,"U")[desc))
	            {
	                d OutputRow
	            } 
			} 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,MSUBCode,MSUBDesc,MSUBSource,MSUBActivity,MSUBStartDate,MSUBEndDate,MSUBSeqNo,MSUBPYCode,MSUBWBCode,MSUBMark)
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
/// Tables: CT_BDP_CT.HOS_MedSubjects
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSubjects", "GetDataForCmb1","1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,MSUBCode,MSUBDesc:%String")
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
	  	s MSUBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),2)	//一级诊疗科目代码
    	s MSUBDesc= $listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),3)	//一级诊疗科目名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSMedSubjects).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSMedSubjectsD(ID))
       		q:ID="" 
       		s MSUBCode=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),2)	//一级诊疗科目代码
		    s MSUBDesc= $listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),3)	//一级诊疗科目名称
			s MSUBActivity=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),5) 	//是否有效(Y/N)
			continue:MSUBActivity="N"
	    	s MSUBStartDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),6) 		//开始日期
	    	continue:(MSUBStartDate'="")&&(MSUBStartDate>+$h)
			s MSUBEndDate=$listget($g(^CT.BDP.CT.HOSMedSubjectsD(ID)),7) 		//结束日期
	  		continue:(MSUBEndDate'="")&&(MSUBEndDate<+$h)
	  		
			s strRowId = "{ID:"_ID_"}"
			if ((AuStr[strRowId)||(AuFlag=1)) //授权数据筛选
			{
		    	if (($ZCONVERT(MSUBDesc,"U")[desc)&&($ZCONVERT(MSUBCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,MSUBCode,MSUBDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSMedSubjects).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSMedSubjects).%New()
    s pobj = ##class(CT.BDP.CT.HOSMedSubjects).%OpenId(id)
    s eobj.ID=id
    s eobj.MSUBCode=pobj.MSUBCode	//一级诊疗科目代码
    s eobj.MSUBDesc= pobj.MSUBDesc	//一级诊疗科目名称
	s eobj.MSUBSource=pobj.MSUBSource		//分类来源
	s eobj.MSUBActivity=pobj.MSUBActivity	//是否有效(Y/N)
	s eobj.MSUBStartDate=pobj.MSUBStartDate		//开始日期
	s:eobj.MSUBStartDate'="" eobj.MSUBStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSUBStartDate) 
	s eobj.MSUBEndDate=pobj.MSUBEndDate		//结束日期
	s:eobj.MSUBEndDate'="" eobj.MSUBEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSUBEndDate) 
	s eobj.MSUBSeqNo=pobj.MSUBSeqNo		//系统排序号
	s eobj.MSUBPYCode=pobj.MSUBPYCode		//拼音码
	s eobj.MSUBWBCode=pobj.MSUBWBCode		//五笔码
	s eobj.MSUBMark=pobj.MSUBMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-18
/// Table：   CT.BDP.CT.HOSMedSubjects
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSMedSubjects).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSMedSubjectsI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	    
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSMedSubjectsI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医疗机构一级诊疗科目内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-18
/// Table：     CT.BDP.CT.HOSMedSubjects
/// Input：     web.Entity.CT.HOSMedSubjects  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSMedSubjects).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSMedSubjects) As %String
{
 
    s result="" 
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 

    s:eobj.MSUBStartDate'="" eobj.MSUBStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSUBStartDate) 
    s:eobj.MSUBEndDate'="" eobj.MSUBEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSUBEndDate)
    s:eobj.MSUBStartDate="" eobj.MSUBStartDate=+$h
    
    s:eobj.MSUBLastUpdateDate="" eobj.MSUBLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.MSUBLastUpdateTime="" eobj.MSUBLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.MSUBLastUpdateUser="" eobj.MSUBLastUpdateUser=USERID	//系统最新更新人
    s:eobj.MSUBActivity="" eobj.MSUBActivity="N"		//是否有效
    
    s:eobj.MSUBPYCode="" eobj.MSUBPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.MSUBDesc,4)
    s:eobj.MSUBWBCode="" eobj.MSUBWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.MSUBDesc,1)
    s flag=  ..FormValidate(eobj.ID,eobj.MSUBCode,eobj.MSUBDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSMedSubjects).%New()
            s:eobj.MSUBCreateDate="" eobj.MSUBCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.MSUBCreateTime="" eobj.MSUBCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.MSUBCreateUser="" eobj.MSUBCreateUser= USERID		//系统创建人默认当前登录人员
		    s obj.MSUBCreateDate=eobj.MSUBCreateDate		//系统创建日期
			s obj.MSUBCreateTime=eobj.MSUBCreateTime		//系统创建时间
			d obj.MSUBCreateUserSetObjectId(eobj.MSUBCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSMedSubjects).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSMedSubjects).%New()
            s bobj.ID=eobj.ID 
            s bobj.MSUBCode=obj.MSUBCode	//一级诊疗科目代码
            s bobj.MSUBDesc= obj.MSUBDesc	//一级诊疗科目名称 
			s bobj.MSUBSource=obj.MSUBSource		//分类来源
			s bobj.MSUBActivity=obj.MSUBActivity	//是否有效(Y/N)
			s bobj.MSUBStartDate=obj.MSUBStartDate		//开始日期
			s bobj.MSUBEndDate=obj.MSUBEndDate		//结束日期
			s bobj.MSUBCreateDate=obj.MSUBCreateDate		//系统创建日期
			s bobj.MSUBCreateTime=obj.MSUBCreateTime		//系统创建时间
			s:$IsObject(obj.MSUBCreateUser) bobj.MSUBCreateUser = obj.MSUBCreateUser.%Id() 	//系统创建人
			s bobj.MSUBSeqNo=obj.MSUBSeqNo		//系统排序号
			s bobj.MSUBLastUpdateDate=obj.MSUBLastUpdateDate		//系统最后更新日期
			s bobj.MSUBLastUpdateTime=obj.MSUBLastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.MSUBLastUpdateUser) bobj.MSUBLastUpdateUser = obj.MSUBLastUpdateUser.%Id() 	//系统最新更新人
			s bobj.MSUBPYCode=obj.MSUBPYCode		//拼音码
			s bobj.MSUBWBCode=obj.MSUBWBCode		//五笔码
			s bobj.MSUBMark=obj.MSUBMark		//备注

        }
        
        s obj.MSUBCode=eobj.MSUBCode	//一级诊疗科目代码
        s obj.MSUBDesc= eobj.MSUBDesc	//一级诊疗科目名称
		s obj.MSUBSource=eobj.MSUBSource		//分类来源
		s obj.MSUBActivity=eobj.MSUBActivity	//是否有效(Y/N)
		s obj.MSUBStartDate=eobj.MSUBStartDate		//开始日期
		s obj.MSUBEndDate=eobj.MSUBEndDate		//结束日期
		s obj.MSUBSeqNo=eobj.MSUBSeqNo		//系统排序号
		s obj.MSUBLastUpdateDate=eobj.MSUBLastUpdateDate		//系统最后更新日期
		s obj.MSUBLastUpdateTime=eobj.MSUBLastUpdateTime		//系统最后更新时间
		d obj.MSUBLastUpdateUserSetObjectId(eobj.MSUBLastUpdateUser)	//系统最新更新人
		s obj.MSUBPYCode=eobj.MSUBPYCode		//拼音码
		s obj.MSUBWBCode=eobj.MSUBWBCode		//五笔码
		s obj.MSUBMark=eobj.MSUBMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSubjects","CT.BDP.CT.HOSMedSubjects","医疗机构一级诊疗科目",id,eobj.MSUBDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSubjects","CT.BDP.CT.HOSMedSubjects","医疗机构一级诊疗科目",eobj.ID,eobj.MSUBDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构一级诊疗科目","web.DHCBL.CT.HOSMedSubjects","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSMedSubjects).GetRefFlag("6")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.HOSMedSpecialtiesI("IndexMSUBCode",id))
    {
	    s myInfo=myInfo_"<医疗机构二级诊疗科目字典>"
	}
	if $d(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexMSUBCode",id))
    {
	    s myInfo=myInfo_"<医疗机构诊疗科目>"
	}
	
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-18
/// Description：根据ID删除医疗机构一级诊疗科目的内容
/// Table：CT.BDP.CT.HOSMedSubjects
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSMedSubjects).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.HOSMedSubjects).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		//new Entity对象，用于保存日志
		s pobj = ##class(CT.BDP.CT.HOSMedSubjects).%OpenId(id)
		s eobj = ##class(web.Entity.CT.HOSMedSubjects).%New()
		s eobj.ID = id
		s eobj.MSUBCode=pobj.MSUBCode	//一级诊疗科目代码
		s eobj.MSUBDesc= pobj.MSUBDesc	//一级诊疗科目名称
		s eobj.MSUBSource=pobj.MSUBSource		//分类来源
		s eobj.MSUBActivity=pobj.MSUBActivity	//是否有效(Y/N)
		s eobj.MSUBStartDate=pobj.MSUBStartDate		//开始日期
		s eobj.MSUBEndDate=pobj.MSUBEndDate		//结束日期
		s eobj.MSUBCreateDate=pobj.MSUBCreateDate		//系统创建日期
		s eobj.MSUBCreateTime=pobj.MSUBCreateTime		//系统创建时间
		s:$IsObject(pobj.MSUBCreateUser) eobj.MSUBCreateUser = pobj.MSUBCreateUser.%Id() 	//系统创建人
		s eobj.MSUBSeqNo=pobj.MSUBSeqNo		//系统排序号
		s eobj.MSUBLastUpdateDate=pobj.MSUBLastUpdateDate		//系统最后更新日期
		s eobj.MSUBLastUpdateTime=pobj.MSUBLastUpdateTime		//系统最后更新时间
		s:$IsObject(pobj.MSUBLastUpdateUser) eobj.MSUBLastUpdateUser = pobj.MSUBLastUpdateUser.%Id() 	//系统最新更新人
		s eobj.MSUBPYCode=pobj.MSUBPYCode		//拼音码
		s eobj.MSUBWBCode=pobj.MSUBWBCode		//五笔码
		s eobj.MSUBMark=pobj.MSUBMark		//备注

		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(CT.BDP.CT.HOSMedSubjects).%DeleteId(id)
		if $$$ISOK(sc)
		{
		    Tcommit
		    s result = "{success:'true',info:'删除成功！'}"  
		    //保存日志
		    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSubjects","CT.BDP.CT.HOSMedSubjects","医疗机构一级诊疗科目",id,eobj.MSUBDesc,"D",eobj)
		    d eobj.%Close()
		}
		else 
		{
		    Trollback
		    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构一级诊疗科目","web.DHCBL.CT.HOSMedSubjects","DeleteData",eobj)
		    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		} 
	}
    q result
}

}
