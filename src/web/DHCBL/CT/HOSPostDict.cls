/// Function: 岗位字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSPostDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  岗位字典信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_PostDict   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostDict","GetList","","","")
Query GetList(rowid, code As %String, desc As %String) As %Query(ROWSPEC = "ID,POSTCCode,POSTCDesc,POSTCDomainCode,POSTCPOSCCode,POSTCPROFTCode,POSTCPHWCode,POSTCFHWCode,POSTCShortDesc,POSTCType,POSTCActivity,POSTCStartDate,POSTCEndDate,POSTCSeqNo,POSTCPYCode,POSTCWBCode,POSTCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	s PositionDictAuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s PositionDictAuFlag=0	
	if (PositionDictAuStr="")||(PositionDictAuStr["limited:0") s PositionDictAuFlag=1
	s ProfTitleDictAuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s ProfTitleDictAuFlag=0	
	if (ProfTitleDictAuStr="")||(ProfTitleDictAuStr["limited:0") s ProfTitleDictAuFlag=1
	s PHWCodeAuStr=##class(web.DHCBL.Authorize.HOSPostHeadWord).DHCGetDataByDefaultSession()
	s PHWCodeAuFlag=0	
	if (PHWCodeAuStr="")||(PHWCodeAuStr["limited:0") s PHWCodeAuFlag=1
	s FHWCodeAuStr=##class(web.DHCBL.Authorize.HOSFlowHeadWord).DHCGetDataByDefaultSession()
	s FHWCodeAuFlag=0	
	if (FHWCodeAuStr="")||(FHWCodeAuStr["limited:0") s FHWCodeAuFlag=1
	s TypeAuStr=##class(web.DHCBL.Authorize.HOSPostType).DHCGetDataByDefaultSession()
	s TypeAuFlag=0	
	if (TypeAuStr="")||(TypeAuStr["limited:0") s TypeAuFlag=1
	
	
				
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s POSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),2)	//岗位代码
	    s POSTCDesc= $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),3)	//岗位名称
	    

		s POSTCDomainCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),4) 	//业务域代码
		s:POSTCDomainCode'="" POSTCDomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(POSTCDomainCode)),3)
		s POSTCPOSCCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),5) 	//职位字典代码
		s:POSTCPOSCCode'="" POSTCPOSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(POSTCPOSCCode)),3)
		s POSTCPROFTCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),6) 	//职务字典代码
		s:POSTCPROFTCode'="" POSTCPROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(POSTCPROFTCode)),3)
		s POSTCPHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),7) 	//岗位中心词
		s:POSTCPHWCode'="" POSTCPHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(POSTCPHWCode)),3)
		s POSTCFHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),8) 	//流程中心词
		s:POSTCFHWCode'="" POSTCFHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(POSTCFHWCode)),3)
		s POSTCShortDesc=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),9) 	//岗位简称
		s POSTCType = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),10) 	//岗位类型
		s:POSTCType'="" POSTCType=$lg($g(^CT.BDP.CT.HOSPostTypeD(POSTCType)),3)
		
		s POSTCActivity=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),11) 	//是否有效(Y/N)
		s POSTCStartDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),12)		//开始日期
		s:POSTCStartDate'="" POSTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTCStartDate) 
		s POSTCEndDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),13) 		//结束日期
		s:POSTCEndDate'="" POSTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTCEndDate) 
		
		s POSTCSeqNo=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),17) 		//系统排序号

		s POSTCPYCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),21)  		//拼音码
		s POSTCWBCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),22)  		//五笔码
		s POSTCMark=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),23)  		//备注
		
        d OutputRow
        
        
    }
    else
    {
	    s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSPostDictD(ID))
            q:ID="" 
            s POSTCDomainCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),4) 	//业务域代码
            s POSTCPOSCCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),5) 	//职位字典代码
            s POSTCPROFTCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),6) 	//职务字典代码
            s POSTCPHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),7) 	//岗位中心词
            s POSTCFHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),8) 	//流程中心词
            s POSTCType = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),10) 	//岗位类型
            
            s strRowId = "{ID:"_ID_"}"
            s DomainCodestrRowId = "{ID:"_POSTCDomainCode_"}"
            s POSCCodestrRowId = "{ID:"_POSTCPOSCCode_"}"
            s PROFTCodestrRowId = "{ID:"_POSTCPROFTCode_"}"
            s PHWCodestrRowId = "{ID:"_POSTCPHWCode_"}"
            s FHWCodestrRowId = "{ID:"_POSTCFHWCode_"}"
            s TypestrRowId = "{ID:"_POSTCType_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((BusiDomainAuStr[DomainCodestrRowId)||(BusiDomainAuFlag=1))&&((PositionDictAuStr[POSCCodestrRowId)||(PositionDictAuFlag=1))&&((ProfTitleDictAuStr[PROFTCodestrRowId)||(ProfTitleDictAuFlag=1))&&((PHWCodeAuStr[PHWCodestrRowId)||(PHWCodeAuFlag=1))&&((FHWCodeAuStr[FHWCodestrRowId)||(FHWCodeAuFlag=1))&&((TypeAuStr[TypestrRowId)||(TypeAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				
		    	s POSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),2)	//岗位代码
			    s POSTCDesc= $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),3)	//岗位名称
			    

				
				s:POSTCDomainCode'="" POSTCDomainCode=$listget($g(^CT.BDP.CT.HOSBusiDomainD(POSTCDomainCode)),3)
				
				s:POSTCPOSCCode'="" POSTCPOSCCode=$lg($g(^CT.BDP.CT.HOSPositionDictD(POSTCPOSCCode)),3)
				
				s:POSTCPROFTCode'="" POSTCPROFTCode=$lg($g(^CT.BDP.CT.HOSProfTitleDictD(POSTCPROFTCode)),3)
				
				s:POSTCPHWCode'="" POSTCPHWCode=$lg($g(^CT.BDP.CT.HOSPostHeadWordD(POSTCPHWCode)),3)
				
				s:POSTCFHWCode'="" POSTCFHWCode=$lg($g(^CT.BDP.CT.HOSFlowHeadWordD(POSTCFHWCode)),3)
				s POSTCShortDesc=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),9) 	//岗位简称
				
				s:POSTCType'="" POSTCType=$lg($g(^CT.BDP.CT.HOSPostTypeD(POSTCType)),3)
				
				s POSTCActivity=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),11) 	//是否有效(Y/N)
				s POSTCStartDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),12)		//开始日期
				s:POSTCStartDate'="" POSTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTCStartDate) 
				s POSTCEndDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),13) 		//结束日期
				s:POSTCEndDate'="" POSTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(POSTCEndDate) 
				
				s POSTCSeqNo=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),17) 		//系统排序号

				s POSTCPYCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),21)  		//拼音码
				s POSTCWBCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),22)  		//五笔码
				s POSTCMark=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),23)  		//备注
				if (($zcvt(POSTCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSTCDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSTCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }
			}
        }
    }
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,POSTCCode,POSTCDesc,POSTCDomainCode,POSTCPOSCCode,POSTCPROFTCode,POSTCPHWCode,POSTCFHWCode,POSTCShortDesc,POSTCType,POSTCActivity,POSTCStartDate,POSTCEndDate,POSTCSeqNo,POSTCPYCode,POSTCWBCode,POSTCMark)
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
/// Tables: CT_BDP_CT.HOS_PostDict
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSPostDict", "GetDataForCmb1","1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSTCCode,POSTCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSPostDict).DHCGetDataByDefaultSession()
	s AuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	s PositionDictAuStr=##class(web.DHCBL.Authorize.HOSPositionDict).DHCGetDataByDefaultSession()
	s PositionDictAuFlag=0	
	if (PositionDictAuStr="")||(PositionDictAuStr["limited:0") s PositionDictAuFlag=1
	s ProfTitleDictAuStr=##class(web.DHCBL.Authorize.HOSProfTitleDict).DHCGetDataByDefaultSession()
	s ProfTitleDictAuFlag=0	
	if (ProfTitleDictAuStr="")||(ProfTitleDictAuStr["limited:0") s ProfTitleDictAuFlag=1
	s PHWCodeAuStr=##class(web.DHCBL.Authorize.HOSPostHeadWord).DHCGetDataByDefaultSession()
	s PHWCodeAuFlag=0	
	if (PHWCodeAuStr="")||(PHWCodeAuStr["limited:0") s PHWCodeAuFlag=1
	s FHWCodeAuStr=##class(web.DHCBL.Authorize.HOSFlowHeadWord).DHCGetDataByDefaultSession()
	s FHWCodeAuFlag=0	
	if (FHWCodeAuStr="")||(FHWCodeAuStr["limited:0") s FHWCodeAuFlag=1
	s TypeAuStr=##class(web.DHCBL.Authorize.HOSPostType).DHCGetDataByDefaultSession()
	s TypeAuFlag=0	
	if (TypeAuStr="")||(TypeAuStr["limited:0") s TypeAuFlag=1
	
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s POSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),2)	//岗位代码
		s POSTCDesc= $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),3)	//岗位名称
    	d OutputRowCmb
  	}
  	else
  	{
	  		
			
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSPostDictD(ID))
       		q:ID="" 
       		s POSTCDomainCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),4) 	//业务域代码
            s POSTCPOSCCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),5) 	//职位字典代码
            s POSTCPROFTCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),6) 	//职务字典代码
            s POSTCPHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),7) 	//岗位中心词
            s POSTCFHWCode = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),8) 	//流程中心词
            s POSTCType = $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),10) 	//岗位类型
            
            s strRowId = "{ID:"_ID_"}"
            s DomainCodestrRowId = "{ID:"_POSTCDomainCode_"}"
            s POSCCodestrRowId = "{ID:"_POSTCPOSCCode_"}"
            s PROFTCodestrRowId = "{ID:"_POSTCPROFTCode_"}"
            s PHWCodestrRowId = "{ID:"_POSTCPHWCode_"}"
            s FHWCodestrRowId = "{ID:"_POSTCFHWCode_"}"
            s TypestrRowId = "{ID:"_POSTCType_"}"
			i (((AuStr[strRowId)||(AuFlag=1))&&((BusiDomainAuStr[DomainCodestrRowId)||(BusiDomainAuFlag=1))&&((PositionDictAuStr[POSCCodestrRowId)||(PositionDictAuFlag=1))&&((ProfTitleDictAuStr[PROFTCodestrRowId)||(ProfTitleDictAuFlag=1))&&((PHWCodeAuStr[PHWCodestrRowId)||(PHWCodeAuFlag=1))&&((FHWCodeAuStr[FHWCodestrRowId)||(FHWCodeAuFlag=1))&&((TypeAuStr[TypestrRowId)||(TypeAuFlag=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				
	       		s POSTCCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),2)	//岗位代码
			    s POSTCDesc= $lg($g(^CT.BDP.CT.HOSPostDictD(ID)),3)	//岗位名称
		    	
				s POSTCActivity=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),11) 	//是否有效(Y/N)
				continue:POSTCActivity="N"
		    	s POSTCStartDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),12)		//开始日期
		    	continue:(POSTCStartDate'="")&&(POSTCStartDate>+$h)
				s POSTCEndDate=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),13) 		//结束日期
		  		continue:(POSTCEndDate'="")&&(POSTCEndDate<+$h)

	       		s POSTCPYCode=$lg($g(^CT.BDP.CT.HOSPostDictD(ID)),21)  		//拼音码
				
	            if (($zcvt(POSTCCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(POSTCDesc,"U")[$zcvt(desc,"U"))||($zcvt(POSTCPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
  	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSTCCode,POSTCDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSPostDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSPostDict).%New()
    s pobj = ##class(CT.BDP.CT.HOSPostDict).%OpenId(id)
    s eobj.ID=id
			
    s eobj.POSTCCode=pobj.POSTCCode	//岗位代码
    s eobj.POSTCDesc= pobj.POSTCDesc	//岗位名称
    if $IsObject(pobj.POSTCDomainCode){
		s eobj.POSTCDomainCode = pobj.POSTCDomainCode.%Id() 	//业务域代码
	}
	if $IsObject(pobj.POSTCPOSCCode){
		s eobj.POSTCPOSCCode = pobj.POSTCPOSCCode.%Id() 	//职位代码
	} 
	if $IsObject(pobj.POSTCPROFTCode){
		s eobj.POSTCPROFTCode = pobj.POSTCPROFTCode.%Id() 	//职务字典代码
	}
	if $IsObject(pobj.POSTCPHWCode){
		s eobj.POSTCPHWCode = pobj.POSTCPHWCode.%Id() 	//岗位中心词
	}
	if $IsObject(pobj.POSTCFHWCode){
		s eobj.POSTCFHWCode = pobj.POSTCFHWCode.%Id() 	//流程中心词
	}
	s eobj.POSTCShortDesc=pobj.POSTCShortDesc	//岗位简称   
	if $IsObject(pobj.POSTCType){
		s eobj.POSTCType = pobj.POSTCType.%Id() 	//岗位类型
	}
			 
	s eobj.POSTCActivity=pobj.POSTCActivity	//是否有效(Y/N)
	s eobj.POSTCStartDate=pobj.POSTCStartDate		//开始日期
	s:eobj.POSTCStartDate'="" eobj.POSTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSTCStartDate) 
	s eobj.POSTCEndDate=pobj.POSTCEndDate		//结束日期
	s:eobj.POSTCEndDate'="" eobj.POSTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.POSTCEndDate) 
	s eobj.POSTCSeqNo=pobj.POSTCSeqNo		//系统排序号
	
	s eobj.POSTCPYCode=pobj.POSTCPYCode		//拼音码
	s eobj.POSTCWBCode=pobj.POSTCWBCode		//五笔码
	s eobj.POSTCMark=pobj.POSTCMark		//备注
	
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSPostDict
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSPostDict).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSPostDictI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSPostDictI("IndexDesc"," "_$zconvert(desc,"u"),0))
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存岗位字典内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSPostDict
/// Input：     web.Entity.CT.HOSPostDict  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSPostDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSPostDict) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.POSTCStartDate'="" eobj.POSTCStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSTCStartDate) 
    s:eobj.POSTCEndDate'="" eobj.POSTCEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.POSTCEndDate)
    s:eobj.POSTCStartDate="" eobj.POSTCStartDate=+$h
    s:eobj.POSTCLastUpdateDate="" eobj.POSTCLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.POSTCLastUpdateTime="" eobj.POSTCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.POSTCLastUpdateUser="" eobj.POSTCLastUpdateUser=UserID	//系统最新更新人
    s:eobj.POSTCActivity="" eobj.POSTCActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.POSTCCode,eobj.POSTCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSPostDict).%New()
            //s eobj.POSTCSeqNo=..GetSeqNo()
            s:eobj.POSTCCreateDate="" eobj.POSTCCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.POSTCCreateTime="" eobj.POSTCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.POSTCCreateUser="" eobj.POSTCCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.POSTCCreateDate=eobj.POSTCCreateDate		//系统创建日期
			s obj.POSTCCreateTime=eobj.POSTCCreateTime		//系统创建时间
			d obj.POSTCCreateUserSetObjectId(eobj.POSTCCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSPostDict).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSPostDict).%New()
            s bobj.ID=eobj.ID 
            s bobj.POSTCCode=obj.POSTCCode	//岗位代码
            s bobj.POSTCDesc= obj.POSTCDesc	//岗位名称
            if $IsObject(obj.POSTCDomainCode){
				s bobj.POSTCDomainCode = obj.POSTCDomainCode.%Id() 	//业务域代码
			}
			if $IsObject(obj.POSTCPOSCCode){
				s bobj.POSTCPOSCCode = obj.POSTCPOSCCode.%Id() 	//职位代码
			} 
			if $IsObject(obj.POSTCPROFTCode){
				s bobj.POSTCPROFTCode = obj.POSTCPROFTCode.%Id() 	//职务字典代码
			}
			if $IsObject(obj.POSTCPHWCode){
				s bobj.POSTCPHWCode = obj.POSTCPHWCode.%Id() 	//岗位中心词
			}
			if $IsObject(obj.POSTCFHWCode){
				s bobj.POSTCFHWCode = obj.POSTCFHWCode.%Id() 	//流程中心词
			}
			s bobj.POSTCShortDesc=obj.POSTCShortDesc	//岗位简称   
			if $IsObject(obj.POSTCType){
				s bobj.POSTCType = obj.POSTCType.%Id() 	//岗位类型
			}
			s bobj.POSTCActivity=obj.POSTCActivity	//是否有效(Y/N)
			s bobj.POSTCStartDate=obj.POSTCStartDate		//开始日期
			s bobj.POSTCEndDate=obj.POSTCEndDate		//结束日期
			s bobj.POSTCCreateDate=obj.POSTCCreateDate		//系统创建日期
			s bobj.POSTCCreateTime=obj.POSTCCreateTime		//系统创建时间
			if $IsObject(obj.POSTCCreateUser){
				s bobj.POSTCCreateUser = obj.POSTCCreateUser.%Id() 	//系统创建人
			}
			s bobj.POSTCSeqNo=obj.POSTCSeqNo		//系统排序号
			s bobj.POSTCLastUpdateDate=obj.POSTCLastUpdateDate		//系统最后更新日期
			s bobj.POSTCLastUpdateTime=obj.POSTCLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.POSTCLastUpdateUser){
				s bobj.POSTCLastUpdateUser = obj.POSTCLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.POSTCPYCode=obj.POSTCPYCode		//拼音码
			s bobj.POSTCWBCode=obj.POSTCWBCode		//五笔码
			s bobj.POSTCMark=obj.POSTCMark		//备注
			
        }
        s obj.POSTCCode=eobj.POSTCCode	//岗位代码
        s obj.POSTCDesc= eobj.POSTCDesc	//岗位名称
        	
		d obj.POSTCDomainCodeSetObjectId(eobj.POSTCDomainCode) 	//业务域代码
		d obj.POSTCPOSCCodeSetObjectId(eobj.POSTCPOSCCode) 	//职位代码
		d obj.POSTCPROFTCodeSetObjectId(eobj.POSTCPROFTCode) 	//职务字典代码
		d obj.POSTCPHWCodeSetObjectId(eobj.POSTCPHWCode) 	//岗位中心词
		d obj.POSTCFHWCodeSetObjectId(eobj.POSTCFHWCode) 	//流程中心词
		s obj.POSTCShortDesc=eobj.POSTCShortDesc	//岗位简称
		d obj.POSTCTypeSetObjectId(eobj.POSTCType) 	//岗位类型
			
		s obj.POSTCActivity=eobj.POSTCActivity	//是否有效(Y/N)
		s obj.POSTCStartDate=eobj.POSTCStartDate		//开始日期
		s obj.POSTCEndDate=eobj.POSTCEndDate		//结束日期
		s obj.POSTCSeqNo=eobj.POSTCSeqNo		//系统排序号
		s obj.POSTCLastUpdateDate=eobj.POSTCLastUpdateDate		//系统最后更新日期
		s obj.POSTCLastUpdateTime=eobj.POSTCLastUpdateTime		//系统最后更新时间
		d obj.POSTCLastUpdateUserSetObjectId(eobj.POSTCLastUpdateUser)	//系统最新更新人
		s:eobj.POSTCPYCode="" eobj.POSTCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.POSTCDesc)
		s obj.POSTCPYCode=eobj.POSTCPYCode		//拼音码
		s:eobj.POSTCWBCode="" eobj.POSTCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.POSTCDesc,1)
		s obj.POSTCWBCode=eobj.POSTCWBCode		//五笔码
		s obj.POSTCMark=eobj.POSTCMark		//备注
			  
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostDict","CT.BDP.CT.HOSPostDict","岗位字典",id,eobj.POSTCDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostDict","CT.BDP.CT.HOSPostDict","岗位字典",eobj.ID,eobj.POSTCDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位字典","web.DHCBL.CT.HOSPostDict","SaveEntity",eobj)
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
/// Other:w ##class(web.DHCBL.CT.HOSPostDict).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    if $d(^CT.BDP.CT.HOSPostI("IndexPOSTCCode",id)){
        s myInfo=myInfo_"<业务岗位>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除岗位字典的内容
/// Table：CT.BDP.CT.HOSPostDict
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSPostDict).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    s pobj = ##class(CT.BDP.CT.HOSPostDict).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSPostDict).%New()
    s eobj.ID = id
    s eobj.POSTCCode=pobj.POSTCCode	//岗位代码
    s eobj.POSTCDesc= pobj.POSTCDesc	//岗位名称
    if $IsObject(pobj.POSTCDomainCode){
		s eobj.POSTCDomainCode = pobj.POSTCDomainCode.%Id() 	//业务域代码
	}
	if $IsObject(pobj.POSTCPOSCCode){
		s eobj.POSTCPOSCCode = pobj.POSTCPOSCCode.%Id() 	//职位代码
	} 
	if $IsObject(pobj.POSTCPROFTCode){
		s eobj.POSTCPROFTCode = pobj.POSTCPROFTCode.%Id() 	//职务字典代码
	}
	if $IsObject(pobj.POSTCPHWCode){
		s eobj.POSTCPHWCode = pobj.POSTCPHWCode.%Id() 	//岗位中心词
	}
	if $IsObject(pobj.POSTCFHWCode){
		s eobj.POSTCFHWCode = pobj.POSTCFHWCode.%Id() 	//流程中心词
	}
	s eobj.POSTCShortDesc=pobj.POSTCShortDesc	//岗位简称   
	if $IsObject(pobj.POSTCType){
		s eobj.POSTCType = pobj.POSTCType.%Id() 	//岗位类型
	}   
	s eobj.POSTCActivity=pobj.POSTCActivity	//是否有效(Y/N)
	s eobj.POSTCStartDate=pobj.POSTCStartDate		//开始日期
	s eobj.POSTCEndDate=pobj.POSTCEndDate		//结束日期
	s eobj.POSTCSeqNo=pobj.POSTCSeqNo		//系统排序号
	
	s eobj.POSTCPYCode=pobj.POSTCPYCode		//拼音码
	s eobj.POSTCWBCode=pobj.POSTCWBCode		//五笔码
	s eobj.POSTCMark=pobj.POSTCMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSPostDict).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_PostDict","CT.BDP.CT.HOSPostDict","岗位字典",id,eobj.POSTCDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("岗位字典","web.DHCBL.CT.HOSPostDict","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    } 
    q result
}

}
