/// Function: 组织机构
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSOrganization Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织机构信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT_BDP_CT.HOS_Organization   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrganization","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ORGCode,ORGDesc,ORGUSCC,ORGAbbrev,ORGIntro,ORGLegalEntity,ORGHeader,ORGORGCode,ORGORGMCCode,ORGCountryCode,ORGPROVCode,ORGCITYCode,ORGDISTRCode,ORGAddress,ORGZipCode,ORGTel,ORGFax,ORGEmail,ORGWebSite,ORGFoundDate,ORGCancelDate,ORGActivity,ORGStartDate,ORGEndDate,ORGSeqNo,ORGPYCode,ORGWBCode,ORGMark,ORGStandardCode,ORGStandardDesc,ORGCodeBefore")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSOrganization).DHCGetDataByDefaultSession()
	s AuFlag=0	
	s ParAuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s ParAuFlag=1
	
	s OrgMinCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgMinCategory).DHCGetDataByDefaultSession()
	s OrgMinCategoryAuFlag=0	
	if (OrgMinCategoryAuStr="")||(OrgMinCategoryAuStr["limited:0") s OrgMinCategoryAuFlag=1
	s CTCountryAuStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
	s CTCountryAuFlag=0	
	if (CTCountryAuStr="")||(CTCountryAuStr["limited:0") s CTCountryAuFlag=1
	s CTProvinceAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
	s CTProvinceAuFlag=0	
	if (CTProvinceAuStr="")||(CTProvinceAuStr["limited:0") s CTProvinceAuFlag=1
	s CTCityAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
	s CTCityAuFlag=0	
	if (CTCityAuStr="")||(CTCityAuStr["limited:0") s CTCityAuFlag=1
	
	s CTCityAreaAuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
	s CTCityAreaAuFlag=0	
	if (CTCityAreaAuStr="")||(CTCityAreaAuStr["limited:0") s CTCityAreaAuFlag=1
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid


	    s ORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),2)	//组织代码
	    s ORGDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),3)	//组织名称
	    s ORGUSCC=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),4)	//统一社会信用代码
		s ORGAbbrev=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),5)		//组织简称
		s ORGIntro=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),6)		//组织简介
		
		s ORGLegalEntity=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),7)		//组织法人
		s ORGHeader=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),8)		//组织负责人
		
		s ORGORGCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),9) 	//上级机构
		s:ORGORGCode'="" ORGORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ORGORGCode)),3)
		
		s ORGORGMCCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),10) 	//组织小类
		s:ORGORGMCCode'="" ORGORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ORGORGMCCode)),3)
		
		s ORGCountryCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),11) 	//组织所在国家
		s:ORGCountryCode'="" ORGCountryCode=$p($g(^CT("COU",ORGCountryCode)),"^",2)
		s ORGPROVCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),12) 	//组织所在省
		s:ORGPROVCode'="" ORGPROVCode=$p($g(^CT("PROV",ORGPROVCode)),"^",2) 
		s ORGCITYCode = $listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),13) 	//组织所在市
		s:ORGCITYCode'="" ORGCITYCode=$p($g(^CT("CIT",ORGCITYCode)),"^",2)
		s ORGDISTRCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),14) 	//组织所在区
		s:ORGDISTRCode'="" ORGDISTRCode=$p($g(^CT("CITAREA",ORGDISTRCode)),"^",2)
		s ORGAddress=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),15) 		//组织地址
		s ORGZipCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),16) 		//组织邮编
		s ORGTel=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),17) 		//联系电话
		s ORGFax=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),18) 		//传真
		s ORGEmail=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),19) 		//邮件
		s ORGWebSite=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),20) 		//官网
		s ORGFoundDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),21) 		//建立日期
		s:ORGFoundDate'="" ORGFoundDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGFoundDate) 
		s ORGCancelDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),22) 		//注销日期
		s:ORGCancelDate'="" ORGCancelDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCancelDate) 		
	    
		s ORGActivity=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),23)	//是否有效(Y/N)
		s ORGStartDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),24)		//开始日期
		s:ORGStartDate'="" ORGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGStartDate) 
		s ORGEndDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),25)		//结束日期
		s:ORGEndDate'="" ORGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGEndDate) 
		s ORGSeqNo=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),29)		//系统排序号
		
		s ORGPYCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),33)		//拼音码
		s ORGWBCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),34)		//五笔码
		s ORGMark=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),35)		//备注
		s ORGStandardCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),36)		//标准编码
		s ORGStandardDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),37)		//标准名称
		s ORGCodeBefore=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),38)		//原系统编码
		
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSOrganizationD(ID))
            q:ID="" 
            s ORGORGCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),9) 	//上级机构
            s ORGORGMCCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),10) 	//组织小类
            s ORGCountryCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),11) 	//组织所在国家
            s ORGPROVCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),12) 	//组织所在省
            s ORGCITYCode = $listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),13) 	//组织所在市
            s ORGDISTRCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),14) 	//组织所在区
            
            s strRowId = "{ID:"_ID_"}"
            s ORGCodestrRowId = "{ID:"_ORGORGCode_"}"
            s ORGMCCodestrRowId = "{ID:"_ORGORGMCCode_"}"
            s CountryCodestrRowId = "{ID:"_ORGCountryCode_"}"
            s PROVCodestrRowId = "{ID:"_ORGPROVCode_"}"
            s CITYCodestrRowId = "{ID:"_ORGCITYCode_"}"
            s DISTRCodestrRowId = "{ID:"_ORGDISTRCode_"}"
            ;用来筛选授权数据，如果未授权情况下筛选无效
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[ORGCodestrRowId)||(ParAuFlag=1))&&((OrgMinCategoryAuStr[ORGMCCodestrRowId)||(OrgMinCategoryAuFlag=1))&&((CTCountryAuStr[CountryCodestrRowId)||(CTCountryAuFlag=1))&&((CTProvinceAuStr[PROVCodestrRowId)||(CTProvinceAuFlag=1))&&((CTCityAuStr[CITYCodestrRowId)||(CTCityAuFlag=1))&&((CTCityAreaAuStr[DISTRCodestrRowId)||(CTCityAreaAuFlag=1)) 
			{
	            s ORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),2)	//组织代码
			    s ORGDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),3)	//组织名称
			    s ORGUSCC=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),4)	//统一社会信用代码
				s ORGAbbrev=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),5)		//组织简称
				s ORGIntro=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),6)		//组织简介
				
				s ORGLegalEntity=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),7)		//组织法人
				s ORGHeader=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),8)		//组织负责人
				
				
				s:ORGORGCode'="" ORGORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ORGORGCode)),3)
				
				
				s:ORGORGMCCode'="" ORGORGMCCode=$listget($g(^CT.BDP.CT.HOSOrgMinCategoryD(ORGORGMCCode)),3)
				
				
				s:ORGCountryCode'="" ORGCountryCode=$p($g(^CT("COU",ORGCountryCode)),"^",2)
				
				s:ORGPROVCode'="" ORGPROVCode=$p($g(^CT("PROV",ORGPROVCode)),"^",2) 
				
				s:ORGCITYCode'="" ORGCITYCode=$p($g(^CT("CIT",ORGCITYCode)),"^",2)
				
				s:ORGDISTRCode'="" ORGDISTRCode=$p($g(^CT("CITAREA",ORGDISTRCode)),"^",2)
				s ORGAddress=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),15) 		//组织地址
				s ORGZipCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),16) 		//组织邮编
				s ORGTel=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),17) 		//联系电话
				s ORGFax=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),18) 		//传真
				s ORGEmail=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),19) 		//邮件
				s ORGWebSite=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),20) 		//官网
				s ORGFoundDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),21) 		//建立日期
				s:ORGFoundDate'="" ORGFoundDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGFoundDate) 
				s ORGCancelDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),22) 		//注销日期
				s:ORGCancelDate'="" ORGCancelDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGCancelDate) 
						
			    
				s ORGActivity=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),23)	//是否有效(Y/N)
				s ORGStartDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),24)		//开始日期
				s:ORGStartDate'="" ORGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGStartDate) 
				s ORGEndDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),25)		//结束日期
				s:ORGEndDate'="" ORGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ORGEndDate) 
				s ORGSeqNo=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),29)		//系统排序号
				
				s ORGPYCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),33)		//拼音码
				s ORGWBCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),34)		//五笔码
				s ORGMark=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),35)		//备注
				s ORGStandardCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),36)		//标准编码
				s ORGStandardDesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),37)		//标准名称
				s ORGCodeBefore=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),38)		//原系统编码
	            if (($zcvt(ORGCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
				
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,ORGCode,ORGDesc,ORGUSCC,ORGAbbrev,ORGIntro,ORGLegalEntity,ORGHeader,ORGORGCode,ORGORGMCCode,ORGCountryCode,ORGPROVCode,ORGCITYCode,ORGDISTRCode,ORGAddress,ORGZipCode,ORGTel,ORGFax,ORGEmail,ORGWebSite,ORGFoundDate,ORGCancelDate,ORGActivity,ORGStartDate,ORGEndDate,ORGSeqNo,ORGPYCode,ORGWBCode,ORGMark,ORGStandardCode,ORGStandardDesc,ORGCodeBefore)
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
/// Tables: CT_BDP_CT.HOS_Organization
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSOrganization", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ORGCode,ORGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSOrganization).DHCGetDataByDefaultSession()
	s AuFlag=0	
	s ParAuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s ParAuFlag=1
	
	s OrgMinCategoryAuStr=##class(web.DHCBL.Authorize.HOSOrgMinCategory).DHCGetDataByDefaultSession()
	s OrgMinCategoryAuFlag=0	
	if (OrgMinCategoryAuStr="")||(OrgMinCategoryAuStr["limited:0") s OrgMinCategoryAuFlag=1
	s CTCountryAuStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
	s CTCountryAuFlag=0	
	if (CTCountryAuStr="")||(CTCountryAuStr["limited:0") s CTCountryAuFlag=1
	s CTProvinceAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
	s CTProvinceAuFlag=0	
	if (CTProvinceAuStr="")||(CTProvinceAuStr["limited:0") s CTProvinceAuFlag=1
	s CTCityAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
	s CTCityAuFlag=0	
	if (CTCityAuStr="")||(CTCityAuStr["limited:0") s CTCityAuFlag=1
	
	s CTCityAreaAuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
	s CTCityAreaAuFlag=0	
	if (CTCityAreaAuStr="")||(CTCityAreaAuStr["limited:0") s CTCityAreaAuFlag=1
		 
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s ORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),2)	//组织代码
    	s ORGDesc= $listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),3)	//组织名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSOrganizationD(ID))
       		q:ID=""
       		s ORGORGCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),9) 	//上级机构
            s ORGORGMCCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),10) 	//组织小类
            s ORGCountryCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),11) 	//组织所在国家
            s ORGPROVCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),12) 	//组织所在省
            s ORGCITYCode = $listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),13) 	//组织所在市
            s ORGDISTRCode =$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),14) 	//组织所在区
            
            s strRowId = "{ID:"_ID_"}"
            s ORGCodestrRowId = "{ID:"_ORGORGCode_"}"
            s ORGMCCodestrRowId = "{ID:"_ORGORGMCCode_"}"
            s CountryCodestrRowId = "{ID:"_ORGCountryCode_"}"
            s PROVCodestrRowId = "{ID:"_ORGPROVCode_"}"
            s CITYCodestrRowId = "{ID:"_ORGCITYCode_"}"
            s DISTRCodestrRowId = "{ID:"_ORGDISTRCode_"}"
            ;用来筛选授权数据，如果未授权情况下筛选无效
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[ORGCodestrRowId)||(ParAuFlag=1))&&((OrgMinCategoryAuStr[ORGMCCodestrRowId)||(OrgMinCategoryAuFlag=1))&&((CTCountryAuStr[CountryCodestrRowId)||(CTCountryAuFlag=1))&&((CTProvinceAuStr[PROVCodestrRowId)||(CTProvinceAuFlag=1))&&((CTCityAuStr[CITYCodestrRowId)||(CTCityAuFlag=1))&&((CTCityAreaAuStr[DISTRCodestrRowId)||(CTCityAreaAuFlag=1)) 
			{
	       		s ORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),2)	//组织代码
		    	s ORGDesc= $listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),3)	//组织名称
		    	
		    	s ORGActivity=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),23)	//是否有效(Y/N)
				continue:ORGActivity="N"
				s ORGStartDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),24)		//开始日期
				continue:(ORGStartDate'="")&&(ORGStartDate>+$h) 
				s ORGEndDate=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),25)		//结束日期
				continue:(ORGEndDate'="")&&(ORGEndDate<+$h)
				s ORGPYCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(ID)),33)		//拼音码 			
				      		
				if (($zcvt(ORGCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(ORGDesc,"U")[$zcvt(desc,"U"))||($zcvt(ORGPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			} 
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,ORGCode,ORGDesc)
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
/// Other:     w ##class(web.DHCBL.CT.HOSOrganization).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSOrganization).%New()
    s pobj = ##class(CT.BDP.CT.HOSOrganization).%OpenId(id)
    s eobj.ID=id
    s eobj.ORGCode=pobj.ORGCode	//组织代码
    s eobj.ORGDesc= pobj.ORGDesc	//组织名称
    s eobj.ORGUSCC=pobj.ORGUSCC	//统一社会信用代码
	s eobj.ORGAbbrev=pobj.ORGAbbrev		//组织简称
	s eobj.ORGIntro=pobj.ORGIntro		//组织简介

	s eobj.ORGLegalEntity=pobj.ORGLegalEntity		//组织法人
	s eobj.ORGHeader=pobj.ORGHeader		//组织负责人
	if $IsObject(pobj.ORGORGCode){
		s eobj.ORGORGCode = pobj.ORGORGCode.%Id() 	//上级机构
	}
	
	if $IsObject(pobj.ORGORGMCCode){
		s eobj.ORGORGMCCode = pobj.ORGORGMCCode.%Id() 	//组织小类
	}
	
	if $IsObject(pobj.ORGCountryCode){
		s eobj.ORGCountryCode = pobj.ORGCountryCode.%Id() 	//组织所在国家
	}
	if $IsObject(pobj.ORGPROVCode){
		s eobj.ORGPROVCode = pobj.ORGPROVCode.%Id() 	//组织所在省
	}
	if $IsObject(pobj.ORGCITYCode){
		s eobj.ORGCITYCode = pobj.ORGCITYCode.%Id() 	//组织所在市
	}
	if $IsObject(pobj.ORGDISTRCode){
		s eobj.ORGDISTRCode = pobj.ORGDISTRCode.%Id() 	//组织所在区
	}
	s eobj.ORGAddress=pobj.ORGAddress		//组织地址
	s eobj.ORGZipCode=pobj.ORGZipCode		//组织邮编
	s eobj.ORGTel=pobj.ORGTel		//联系电话
	s eobj.ORGFax=pobj.ORGFax		//传真
	s eobj.ORGEmail=pobj.ORGEmail		//邮件
	s eobj.ORGWebSite=pobj.ORGWebSite		//官网
	s eobj.ORGFoundDate=pobj.ORGFoundDate		//建立日期
	s eobj.ORGCancelDate=pobj.ORGCancelDate		//注销日期
			
    
	s eobj.ORGActivity=pobj.ORGActivity	//是否有效(Y/N)
	s eobj.ORGStartDate=pobj.ORGStartDate		//开始日期
	s:eobj.ORGStartDate'="" eobj.ORGStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGStartDate) 
	s eobj.ORGEndDate=pobj.ORGEndDate		//结束日期
	s:eobj.ORGEndDate'="" eobj.ORGEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ORGEndDate) 
	s eobj.ORGSeqNo=pobj.ORGSeqNo		//系统排序号
	
	s eobj.ORGPYCode=pobj.ORGPYCode		//拼音码
	s eobj.ORGWBCode=pobj.ORGWBCode		//五笔码
	s eobj.ORGMark=pobj.ORGMark		//备注
	s eobj.ORGStandardCode=pobj.ORGStandardCode		//标准编码
	s eobj.ORGStandardDesc=pobj.ORGStandardDesc		//标准名称
	s eobj.ORGCodeBefore=pobj.ORGCodeBefore		//原系统编码
		
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-11-10
/// Table：   CT.BDP.CT.HOSOrganization
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSOrganization).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSOrganizationI("IndexCode"," "_$zconvert(code,"u"),0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
		s idd=$o(^CT.BDP.CT.HOSOrganizationI("IndexDesc"," "_$zconvert(desc,"u"),0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织内容
/// Creator:    钟荣枫
/// CreatDate:  2022-11-10
/// Table：     CT.BDP.CT.HOSOrganization
/// Input：     web.Entity.CT.HOSOrganization  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSOrganization).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSOrganization) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 

    s:eobj.ORGStartDate'="" eobj.ORGStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGStartDate) 
    s:eobj.ORGEndDate'="" eobj.ORGEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ORGEndDate)
    s:eobj.ORGStartDate="" eobj.ORGStartDate=+$h
    s:eobj.ORGLastUpdateDate="" eobj.ORGLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.ORGLastUpdateTime="" eobj.ORGLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.ORGLastUpdateUser="" eobj.ORGLastUpdateUser=UserID	//系统最新更新人
    s:eobj.ORGActivity="" eobj.ORGActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.ORGCode,eobj.ORGDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSOrganization).%New()
            //s eobj.ORGSeqNo=..GetSeqNo()
            s:eobj.ORGCreateDate="" eobj.ORGCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.ORGCreateTime="" eobj.ORGCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.ORGCreateUser="" eobj.ORGCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.ORGCreateDate=eobj.ORGCreateDate		//系统创建日期
			s obj.ORGCreateTime=eobj.ORGCreateTime		//系统创建时间
			d obj.ORGCreateUserSetObjectId(eobj.ORGCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSOrganization).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSOrganization).%New()
            s bobj.ID=eobj.ID 
            s bobj.ORGCode=obj.ORGCode	//组织代码
            s bobj.ORGDesc= obj.ORGDesc	//组织名称
            s bobj.ORGUSCC=obj.ORGUSCC	//统一社会信用代码
			s bobj.ORGAbbrev=obj.ORGAbbrev		//组织简称
			s bobj.ORGIntro=obj.ORGIntro		//组织简介

			s bobj.ORGLegalEntity=obj.ORGLegalEntity		//组织法人
			s bobj.ORGHeader=obj.ORGHeader		//组织负责人
			if $IsObject(obj.ORGORGCode){
				s bobj.ORGORGCode = obj.ORGORGCode.%Id() 	//上级机构
			}

			if $IsObject(obj.ORGORGMCCode){
				s bobj.ORGORGMCCode = obj.ORGORGMCCode.%Id() 	//组织小类
			}
			
			if $IsObject(obj.ORGCountryCode){
				s bobj.ORGCountryCode = obj.ORGCountryCode.%Id() 	//组织所在国家
			}
			if $IsObject(obj.ORGPROVCode){
				s bobj.ORGPROVCode = obj.ORGPROVCode.%Id() 	//组织所在省
			}
			if $IsObject(obj.ORGCITYCode){
				s bobj.ORGCITYCode = obj.ORGCITYCode.%Id() 	//组织所在市
			}
			if $IsObject(obj.ORGDISTRCode){
				s bobj.ORGDISTRCode = obj.ORGDISTRCode.%Id() 	//组织所在区
			}
			s bobj.ORGAddress=obj.ORGAddress		//组织地址
			s bobj.ORGZipCode=obj.ORGZipCode		//组织邮编
			s bobj.ORGTel=obj.ORGTel		//联系电话
			s bobj.ORGFax=obj.ORGFax		//传真
			s bobj.ORGEmail=obj.ORGEmail		//邮件
			s bobj.ORGWebSite=obj.ORGWebSite		//官网
			s bobj.ORGFoundDate=obj.ORGFoundDate		//建立日期
			s bobj.ORGCancelDate=obj.ORGCancelDate		//注销日期
			
			s bobj.ORGActivity=obj.ORGActivity	//是否有效(Y/N)
			s bobj.ORGStartDate=obj.ORGStartDate		//开始日期
			s bobj.ORGEndDate=obj.ORGEndDate		//结束日期
			s bobj.ORGCreateDate=obj.ORGCreateDate		//系统创建日期
			s bobj.ORGCreateTime=obj.ORGCreateTime		//系统创建时间
			if $IsObject(obj.ORGCreateUser){
				s bobj.ORGCreateUser = obj.ORGCreateUser.%Id() 	//系统创建人
			}
			s bobj.ORGSeqNo=obj.ORGSeqNo		//系统排序号
			s bobj.ORGLastUpdateDate=obj.ORGLastUpdateDate		//系统最后更新日期
			s bobj.ORGLastUpdateTime=obj.ORGLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.ORGLastUpdateUser){
				s bobj.ORGLastUpdateUser = obj.ORGLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.ORGPYCode=obj.ORGPYCode		//拼音码
			s bobj.ORGWBCode=obj.ORGWBCode		//五笔码
			s bobj.ORGMark=obj.ORGMark		//备注
			s bobj.ORGStandardCode=obj.ORGStandardCode		//标准编码
			s bobj.ORGStandardDesc=obj.ORGStandardDesc		//标准名称
			s bobj.ORGCodeBefore=obj.ORGCodeBefore		//原系统编码

			
        }
        
        s obj.ORGCode=eobj.ORGCode	//组织代码
        s obj.ORGDesc= eobj.ORGDesc	//组织名称
        s obj.ORGUSCC=eobj.ORGUSCC	//统一社会信用代码
		s obj.ORGAbbrev=eobj.ORGAbbrev		//组织简称
		s obj.ORGIntro=eobj.ORGIntro		//组织简介
		
		s obj.ORGLegalEntity=eobj.ORGLegalEntity		//组织法人
		s obj.ORGHeader=eobj.ORGHeader		//组织负责人
		
		d obj.ORGORGCodeSetObjectId(eobj.ORGORGCode) 	//上级机构
		d obj.ORGORGMCCodeSetObjectId(eobj.ORGORGMCCode) 	//组织小类
		d obj.ORGCountryCodeSetObjectId(eobj.ORGCountryCode) 	//组织所在国家
		d obj.ORGPROVCodeSetObjectId(eobj.ORGPROVCode) 	//组织所在省
		d obj.ORGCITYCodeSetObjectId(eobj.ORGCITYCode) 	//组织所在市
		d obj.ORGDISTRCodeSetObjectId(eobj.ORGDISTRCode) 	//组织所在区
		s obj.ORGAddress=eobj.ORGAddress		//组织地址
		s obj.ORGZipCode=eobj.ORGZipCode		//组织邮编
		s obj.ORGTel=eobj.ORGTel		//联系电话
		s obj.ORGFax=eobj.ORGFax		//传真
		s obj.ORGEmail=eobj.ORGEmail		//邮件
		s obj.ORGWebSite=eobj.ORGWebSite		//官网
		s obj.ORGFoundDate=eobj.ORGFoundDate		//建立日期
		s obj.ORGCancelDate=eobj.ORGCancelDate		//注销日期
		
		s obj.ORGActivity=eobj.ORGActivity	//是否有效(Y/N)
		s obj.ORGStartDate=eobj.ORGStartDate		//开始日期
		s obj.ORGEndDate=eobj.ORGEndDate		//结束日期

		s obj.ORGSeqNo=eobj.ORGSeqNo		//系统排序号
		s obj.ORGLastUpdateDate=eobj.ORGLastUpdateDate		//系统最后更新日期
		s obj.ORGLastUpdateTime=eobj.ORGLastUpdateTime		//系统最后更新时间
		d obj.ORGLastUpdateUserSetObjectId(eobj.ORGLastUpdateUser) 	//系统最新更新人
		s:eobj.ORGPYCode="" eobj.ORGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.ORGDesc)
		s obj.ORGPYCode=eobj.ORGPYCode		//拼音码
		s:eobj.ORGWBCode="" eobj.ORGWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.ORGDesc,1)
		s obj.ORGWBCode=eobj.ORGWBCode		//五笔码
		s obj.ORGMark=eobj.ORGMark		//备注
		s obj.ORGStandardCode=eobj.ORGStandardCode		//标准编码
		s obj.ORGStandardDesc=eobj.ORGStandardDesc		//标准名称
		s obj.ORGCodeBefore=eobj.ORGCodeBefore		//原系统编码
		
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Organization","CT.BDP.CT.HOSOrganization","组织机构",id,eobj.ORGDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Organization","CT.BDP.CT.HOSOrganization","组织机构",eobj.ID,eobj.ORGDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构","web.DHCBL.CT.HOSOrganization","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSOrganization
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSOrganization).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSOrganizationI("IndexSeqNo",""),-1)
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
/// Other:w ##class(web.DHCBL.CT.HOSOrganization).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""

    if $d(^CT.BDP.CT.HOSORGEmployeeI("IndexORGCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    
    if $d(^CT("RFC",0,"OrgGrade",id)){
        s myInfo=myInfo_"<医疗机构>"
    }
    if $d(^CT.BDP.CT.HOSOrganizationI("IndexORGCode",id)){
        s myInfo=myInfo_"<组织机构>"
    }
    if $d(^CT.BDP.CT.HOSDepartmentI("IndexORGCode",id)){
        s myInfo=myInfo_"<组织部门>"
    }  
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2022-11-10
/// Description：根据ID删除组织机构的内容
/// Table：CT.BDP.CT.HOSOrganization
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSOrganization).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSOrganization).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSOrganization).%New()
	    s eobj.ID = id
	    s eobj.ORGCode=pobj.ORGCode	//组织代码
	    s eobj.ORGDesc= pobj.ORGDesc	//组织名称
	    s eobj.ORGUSCC=pobj.ORGUSCC	//统一社会信用代码
		s eobj.ORGAbbrev=pobj.ORGAbbrev		//组织简称
		s eobj.ORGIntro=pobj.ORGIntro		//组织简介

		s eobj.ORGLegalEntity=pobj.ORGLegalEntity		//组织法人
		s eobj.ORGHeader=pobj.ORGHeader		//组织负责人
		if $IsObject(pobj.ORGORGCode){
			s eobj.ORGORGCode = pobj.ORGORGCode.%Id() 	//上级机构
		}
		
		if $IsObject(pobj.ORGORGMCCode){
			s eobj.ORGORGMCCode = pobj.ORGORGMCCode.%Id() 	//组织小类
		}
		
		if $IsObject(pobj.ORGCountryCode){
			s eobj.ORGCountryCode = pobj.ORGCountryCode.%Id() 	//组织所在国家
		}
		if $IsObject(pobj.ORGPROVCode){
			s eobj.ORGPROVCode = pobj.ORGPROVCode.%Id() 	//组织所在省
		}
		if $IsObject(pobj.ORGCITYCode){
			s eobj.ORGCITYCode = pobj.ORGCITYCode.%Id() 	//组织所在市
		}
		if $IsObject(pobj.ORGDISTRCode){
			s eobj.ORGDISTRCode = pobj.ORGDISTRCode.%Id() 	//组织所在区
		}
		s eobj.ORGAddress=pobj.ORGAddress		//组织地址
		s eobj.ORGZipCode=pobj.ORGZipCode		//组织邮编
		s eobj.ORGTel=pobj.ORGTel		//联系电话
		s eobj.ORGFax=pobj.ORGFax		//传真
		s eobj.ORGEmail=pobj.ORGEmail		//邮件
		s eobj.ORGWebSite=pobj.ORGWebSite		//官网
		s eobj.ORGFoundDate=pobj.ORGFoundDate		//建立日期
		s eobj.ORGCancelDate=pobj.ORGCancelDate		//注销日期
				
	    
		s eobj.ORGActivity=pobj.ORGActivity	//是否有效(Y/N)
		s eobj.ORGStartDate=pobj.ORGStartDate		//开始日期
		s eobj.ORGEndDate=pobj.ORGEndDate		//结束日期
		s eobj.ORGSeqNo=pobj.ORGSeqNo		//系统排序号
		
		s eobj.ORGPYCode=pobj.ORGPYCode		//拼音码
		s eobj.ORGWBCode=pobj.ORGWBCode		//五笔码
		s eobj.ORGMark=pobj.ORGMark		//备注
		s eobj.ORGStandardCode=pobj.ORGStandardCode		//标准编码
		s eobj.ORGStandardDesc=pobj.ORGStandardDesc		//标准名称
		s eobj.ORGCodeBefore=pobj.ORGCodeBefore		//原系统编码

	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSOrganization).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}" 
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Organization","CT.BDP.CT.HOSOrganization","组织机构",id,eobj.ORGDesc,"D",eobj)
	        d eobj.%Close()
	        
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织机构","web.DHCBL.CT.HOSOrganization","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
        
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
