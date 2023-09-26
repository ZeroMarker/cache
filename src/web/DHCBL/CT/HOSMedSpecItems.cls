/// Function: HOS 医疗机构三级诊疗科目字典
/// CreateDate:2022-11-21
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSMedSpecItems Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  医疗机构三级诊疗科目信息查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-21
/// Table：     CT_BDP_CT.HOS_MedSpecItems   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSpecItems","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, specialties As %String) As %Query(ROWSPEC = "ID,MSPECICode,MSPECIDesc,MSPECIMSPECDesc,MSPECISource,MSPECIActivity,MSPECIStartDate,MSPECIEndDate,MSPECISeqNo,MSPECIPYCode,MSPECIWBCode,MSPECIMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, specialties As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s MSPECICode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),2)	//三级诊疗科目代码
	    s MSPECIDesc= $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),3)	//三级诊疗科目名称
		s MSPECIMSPECDesc=""
		s MSPECIMSPECCode = $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),4) 	//二级诊疗科目-外键
		s:MSPECIMSPECCode'="" MSPECIMSPECDesc=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(MSPECIMSPECCode)),3)
		s MSPECISource=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),5) 		//分类来源
		s MSPECIActivity=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),6) 	//是否有效(Y/N)
		s MSPECIStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),7) 		//开始日期
		s:MSPECIStartDate'="" MSPECIStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECIStartDate) 
		s MSPECIEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),8) 		//结束日期
		s:MSPECIEndDate'="" MSPECIEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECIEndDate) 
		s MSPECISeqNo=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),12) 		//系统排序号
		s MSPECIPYCode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),16) 		//拼音码
		s MSPECIWBCode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),17) 		//五笔码
		s MSPECIMark=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),18) 		//备注
	
        d OutputRow
    }
    else
    {  
    	s AuStr=##class(web.DHCBL.Authorize.HOSMedSpecItems).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		
		s AuSpecialtiesStr=##class(web.DHCBL.Authorize.HOSMedSpecialties).DHCGetDataByDefaultSession() //二级诊疗科目
		s AuSpecialtiesFlag=0
		if (AuSpecialtiesStr="")||(AuSpecialtiesStr["limited:0") s AuSpecialtiesFlag=1 
    	s:code'="" code=$zcvt(code,"U")  
  		s:desc'="" desc=$zcvt(desc,"U")
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSMedSpecItemsD(ID))
            q:ID="" 
            s MSPECICode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),2)	//三级诊疗科目代码
		    s MSPECIDesc= $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),3)	//三级诊疗科目名称
			s MSPECIMSPECDesc=""
			s MSPECIMSPECCode = $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),4) 	//二级诊疗科目-外键
			s:MSPECIMSPECCode'="" MSPECIMSPECDesc=$listget($g(^CT.BDP.CT.HOSMedSpecialtiesD(MSPECIMSPECCode)),3)
			s MSPECISource=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),5) 		//分类来源
			s MSPECIActivity=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),6) 	//是否有效(Y/N)
			s MSPECIStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),7) 		//开始日期
			s:MSPECIStartDate'="" MSPECIStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECIStartDate) 
			s MSPECIEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),8) 		//结束日期
			s:MSPECIEndDate'="" MSPECIEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(MSPECIEndDate) 
			s MSPECISeqNo=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),12) 		//系统排序号
			s MSPECIPYCode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),16) 		//拼音码
			s MSPECIWBCode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),17) 		//五笔码
			s MSPECIMark=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),18) 		//备注
			
			s strRowId = "{ID:"_ID_"}"
			s strSpecialtiesRowId = "{ID:"_MSPECIMSPECCode_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuSpecialtiesStr[strSpecialtiesRowId)||(AuSpecialtiesFlag=1)) //授权数据筛选
			{
	            if ($zcvt(MSPECICode,"U")[code)&(($zcvt(MSPECIDesc,"U")[desc)||($zcvt(MSPECIPYCode,"U")[desc))&((MSPECIMSPECCode=specialties)||(specialties=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,MSPECICode,MSPECIDesc,MSPECIMSPECDesc,MSPECISource,MSPECIActivity,MSPECIStartDate,MSPECIEndDate,MSPECISeqNo,MSPECIPYCode,MSPECIWBCode,MSPECIMark)
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
/// CreatDate:2022-11-21
/// Tables: CT_BDP_CT.HOS_MedSpecItems
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSMedSpecItems", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,MSPECICode,MSPECIDesc:%String")
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
	  	s MSPECICode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),2)	//三级诊疗科目代码
    	s MSPECIDesc= $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),3)	//三级诊疗科目名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	s AuStr=##class(web.DHCBL.Authorize.HOSMedSpecItems).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		
		s AuSpecialtiesStr=##class(web.DHCBL.Authorize.HOSMedSpecialties).DHCGetDataByDefaultSession() //二级诊疗科目
		s AuSpecialtiesFlag=0
		if (AuSpecialtiesStr="")||(AuSpecialtiesStr["limited:0") s AuSpecialtiesFlag=1 
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSMedSpecItemsD(ID))
       		q:ID="" 
       		s MSPECICode=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),2)	//三级诊疗科目代码
	    	s MSPECIDesc= $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),3)	//三级诊疗科目名称
	    	s MSPECIMSPECCode = $listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),4) 	//二级诊疗科目-外键
	    
			s MSPECIActivity=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),6) 	//是否有效(Y/N)
			continue:MSPECIActivity="N"
	    	s MSPECIStartDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),7) 		//开始日期
	    	continue:(MSPECIStartDate'="")&&(MSPECIStartDate>+$h)
			s MSPECIEndDate=$listget($g(^CT.BDP.CT.HOSMedSpecItemsD(ID)),8) 		//结束日期
	  		continue:(MSPECIEndDate'="")&&(MSPECIEndDate<+$h)
			s strRowId = "{ID:"_ID_"}"
			s strSpecialtiesRowId = "{ID:"_MSPECIMSPECCode_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuSpecialtiesStr[strSpecialtiesRowId)||(AuSpecialtiesFlag=1)) //授权数据筛选
			{
		    	if ((($ZCONVERT(MSPECIDesc,"U")[desc))&&($ZCONVERT(MSPECICode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,MSPECICode,MSPECIDesc)
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
/// CreatDate: 2022-11-21
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSMedSpecItems).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSMedSpecItems).%New()
    s pobj = ##class(CT.BDP.CT.HOSMedSpecItems).%OpenId(id)
    s eobj.ID=id
    s eobj.MSPECICode=pobj.MSPECICode	//三级诊疗科目代码
    s eobj.MSPECIDesc= pobj.MSPECIDesc	//三级诊疗科目名称
    s:$IsObject(pobj.MSPECIMSPECCode) eobj.MSPECIMSPECCode = pobj.MSPECIMSPECCode.%Id() 	//二级诊疗科目-外键 
	s eobj.MSPECISource=pobj.MSPECISource		//分类来源
	s eobj.MSPECIActivity=pobj.MSPECIActivity	//是否有效(Y/N)
	s eobj.MSPECIStartDate=pobj.MSPECIStartDate		//开始日期
	s:eobj.MSPECIStartDate'="" eobj.MSPECIStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSPECIStartDate) 
	s eobj.MSPECIEndDate=pobj.MSPECIEndDate		//结束日期
	s:eobj.MSPECIEndDate'="" eobj.MSPECIEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.MSPECIEndDate) 
	s eobj.MSPECISeqNo=pobj.MSPECISeqNo		//系统排序号
	s eobj.MSPECIPYCode=pobj.MSPECIPYCode		//拼音码
	s eobj.MSPECIWBCode=pobj.MSPECIWBCode		//五笔码
	s eobj.MSPECIMark=pobj.MSPECIMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-21
/// Table：   CT.BDP.CT.HOSMedSpecItems
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSMedSpecItems).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSMedSpecItemsI("IndexCode"," "_$zconvert(code,"u"),0))
	    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSMedSpecItemsI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if ((id="")||((id'="")&&(idd'=id)))&&(idd>0) s flag=1  //返回重复标志
    }
    
    q flag
}

/// Function    保存医疗机构三级诊疗科目内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-21
/// Table：     CT.BDP.CT.HOSMedSpecItems
/// Input：     web.Entity.CT.HOSMedSpecItems  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSMedSpecItems).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSMedSpecItems) As %String
{
 
    s result="" 
    s UserID=""
    s:$d(%session) UserID=$g(%session.Data("LOGON.USERID"))  
     
    s:eobj.MSPECIStartDate'="" eobj.MSPECIStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSPECIStartDate) 
    s:eobj.MSPECIEndDate'="" eobj.MSPECIEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.MSPECIEndDate)
    s:eobj.MSPECIStartDate="" eobj.MSPECIStartDate=+$h
    
    s:eobj.MSPECILastUpdateDate="" eobj.MSPECILastUpdateDate=+$h		//系统最后更新日期
    s:eobj.MSPECILastUpdateTime="" eobj.MSPECILastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.MSPECILastUpdateUser="" eobj.MSPECILastUpdateUser=UserID	//系统最新更新人
    s:eobj.MSPECIActivity="" eobj.MSPECIActivity="N"		//是否有效
    
    s:eobj.MSPECIPYCode="" eobj.MSPECIPYCode=##class(web.DHCBL.BDP.FunLib).GetDBCCNCODE(eobj.MSPECIDesc,4)
    s:eobj.MSPECIWBCode="" eobj.MSPECIWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.MSPECIDesc,1)
    
    s flag=  ..FormValidate(eobj.ID,eobj.MSPECICode,eobj.MSPECIDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSMedSpecItems).%New()
            s:eobj.MSPECICreateDate="" eobj.MSPECICreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.MSPECICreateTime="" eobj.MSPECICreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.MSPECICreateUser="" eobj.MSPECICreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.MSPECICreateDate=eobj.MSPECICreateDate		//系统创建日期
			s obj.MSPECICreateTime=eobj.MSPECICreateTime		//系统创建时间
			d obj.MSPECICreateUserSetObjectId(eobj.MSPECICreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSMedSpecItems).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSMedSpecItems).%New()
            s bobj.ID=eobj.ID 
            s bobj.MSPECICode=obj.MSPECICode	//三级诊疗科目代码
            s bobj.MSPECIDesc= obj.MSPECIDesc	//三级诊疗科目名称
            s:$IsObject(obj.MSPECIMSPECCode) bobj.MSPECIMSPECCode = obj.MSPECIMSPECCode.%Id() 	//二级诊疗科目-外键
			s bobj.MSPECISource=obj.MSPECISource		//分类来源
			s bobj.MSPECIActivity=obj.MSPECIActivity	//是否有效(Y/N)
			s bobj.MSPECIStartDate=obj.MSPECIStartDate		//开始日期
			s bobj.MSPECIEndDate=obj.MSPECIEndDate		//结束日期
			s bobj.MSPECICreateDate=obj.MSPECICreateDate		//系统创建日期
			s bobj.MSPECICreateTime=obj.MSPECICreateTime		//系统创建时间
			s:$IsObject(obj.MSPECICreateUser) bobj.MSPECICreateUser = obj.MSPECICreateUser.%Id() 	//系统创建人
			s bobj.MSPECISeqNo=obj.MSPECISeqNo		//系统排序号
			s bobj.MSPECILastUpdateDate=obj.MSPECILastUpdateDate		//系统最后更新日期
			s bobj.MSPECILastUpdateTime=obj.MSPECILastUpdateTime		//系统最后更新时间
			s:$IsObject(obj.MSPECILastUpdateUser) bobj.MSPECILastUpdateUser = obj.MSPECILastUpdateUser.%Id() 	//系统最新更新人
			s bobj.MSPECIPYCode=obj.MSPECIPYCode		//拼音码
			s bobj.MSPECIWBCode=obj.MSPECIWBCode		//五笔码
			s bobj.MSPECIMark=obj.MSPECIMark		//备注

        }
        
        s obj.MSPECICode=eobj.MSPECICode	//三级诊疗科目代码
        s obj.MSPECIDesc= eobj.MSPECIDesc	//三级诊疗科目名称
        d obj.MSPECIMSPECCodeSetObjectId(eobj.MSPECIMSPECCode)	//二级诊疗科目-外键
		s obj.MSPECISource=eobj.MSPECISource		//分类来源
		s obj.MSPECIActivity=eobj.MSPECIActivity	//是否有效(Y/N)
		s obj.MSPECIStartDate=eobj.MSPECIStartDate		//开始日期
		s obj.MSPECIEndDate=eobj.MSPECIEndDate		//结束日期
		s obj.MSPECISeqNo=eobj.MSPECISeqNo		//系统排序号
		s obj.MSPECILastUpdateDate=eobj.MSPECILastUpdateDate		//系统最后更新日期
		s obj.MSPECILastUpdateTime=eobj.MSPECILastUpdateTime		//系统最后更新时间
		d obj.MSPECILastUpdateUserSetObjectId(eobj.MSPECILastUpdateUser)	//系统最新更新人
		s obj.MSPECIPYCode=eobj.MSPECIPYCode		//拼音码
		s obj.MSPECIWBCode=eobj.MSPECIWBCode		//五笔码
		s obj.MSPECIMark=eobj.MSPECIMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecItems","CT.BDP.CT.HOSMedSpecItems","医疗机构三级诊疗科目",id,eobj.MSPECIDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecItems","CT.BDP.CT.HOSMedSpecItems","医疗机构三级诊疗科目",eobj.ID,eobj.MSPECIDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构三级诊疗科目","web.DHCBL.CT.HOSMedSpecItems","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSMedSpecItems).GetRefFlag("6")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
	if $d(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexMSPECICode",id))
    {
	    s myInfo=myInfo_"<医疗机构诊疗科目>"
	}
	
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-21
/// Description：根据ID删除医疗机构三级诊疗科目的内容
/// Table：CT.BDP.CT.HOSMedSpecItems
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSMedSpecItems).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.CT.HOSMedSpecItems).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0)
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSMedSpecItems).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSMedSpecItems).%New()
	    s eobj.ID = id
	    s eobj.MSPECICode=pobj.MSPECICode	//三级诊疗科目代码
	    s eobj.MSPECIDesc= pobj.MSPECIDesc	//三级诊疗科目名称
	    s:$IsObject(pobj.MSPECIMSPECCode) eobj.MSPECIMSPECCode = pobj.MSPECIMSPECCode.%Id() 	//二级诊疗科目-外键
		s eobj.MSPECISource=pobj.MSPECISource		//分类来源
		s eobj.MSPECIActivity=pobj.MSPECIActivity	//是否有效(Y/N)
		s eobj.MSPECIStartDate=pobj.MSPECIStartDate		//开始日期
		s eobj.MSPECIEndDate=pobj.MSPECIEndDate		//结束日期
		s eobj.MSPECICreateDate=pobj.MSPECICreateDate		//系统创建日期
		s eobj.MSPECICreateTime=pobj.MSPECICreateTime		//系统创建时间
		s:$IsObject(pobj.MSPECICreateUser) eobj.MSPECICreateUser = pobj.MSPECICreateUser.%Id() 	//系统创建人
		s eobj.MSPECISeqNo=pobj.MSPECISeqNo		//系统排序号
		s eobj.MSPECILastUpdateDate=pobj.MSPECILastUpdateDate		//系统最后更新日期
		s eobj.MSPECILastUpdateTime=pobj.MSPECILastUpdateTime		//系统最后更新时间
		s:$IsObject(pobj.MSPECILastUpdateUser) eobj.MSPECILastUpdateUser = pobj.MSPECILastUpdateUser.%Id() 	//系统最新更新人
		s eobj.MSPECIPYCode=pobj.MSPECIPYCode		//拼音码
		s eobj.MSPECIWBCode=pobj.MSPECIWBCode		//五笔码
		s eobj.MSPECIMark=pobj.MSPECIMark		//备注
		
	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSMedSpecItems).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_MedSpecItems","CT.BDP.CT.HOSMedSpecItems","医疗机构三级诊疗科目",id,eobj.MSPECIDesc,"D",eobj)
	        d eobj.%Close()
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构三级诊疗科目","web.DHCBL.CT.HOSMedSpecItems","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
	}
    q result
}

}
