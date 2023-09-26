Import SQLUser

/// 名称:地理信息 - 3 省
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 陈莹
/// 编写日期:  2012-9-10
Class web.DHCBL.CT.CTProvince Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2013-2-20
/// Description:查询 省
/// Table:User.CTProvince
/// Input:rowid,code,desc,regiondr
/// Return:PROVRowId,PROVCode,PROVDesc,PROVRegionDR,PROVDateFrom,PROVDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTProvince","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, regiondr As %String, countrydr) As %Query(ROWSPEC = "PROVRowId:%String,PROVCode:%String,PROVDesc:%String,PROVRegionDR:%String,PROVDateFrom:%String,PROVDateTo:%String,PROVRomanCode,PROVRomanDesc,PROVCountryCode,PROVActivity,PROVSeqNo,PROVPYCode,PROVWBCode,PROVMark,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, regiondr As %String, countrydr) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s PROVRowId=rowid
        s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
        s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)  
        s PROVRegionDR=$p($g(^CT("PROV",PROVRowId)),"^",3)
        if PROVRegionDR'="" {
            s PROVRegionDR=$p($g(^CT("RG",PROVRegionDR)),"^",2)
        }
        s PROVDateFrom=$p($g(^CT("PROV",PROVRowId)),"^",4)
        s PROVDateTo=$p($g(^CT("PROV",PROVRowId)),"^",5)
        s:PROVDateFrom'="" PROVDateFrom=$zd(PROVDateFrom,1)
        s:PROVDateTo'="" PROVDateTo=$zd(PROVDateTo,1)
        
        s PROVRomanCode=$p($g(^CT("PROV",PROVRowId)),"^",7)		//省级行政区罗马代码
	    s PROVRomanDesc=$p($g(^CT("PROV",PROVRowId)),"^",8)		//省级行政区罗马名称
	    
	    s PROVCountryCode = $p($g(^CT("PROV",PROVRowId)),"^",9) 		//国家-外键
	    s:PROVCountryCode'="" PROVCountryCode=$p($g(^CT("COU",PROVCountryCode)),"^",2)
	    s PROVActivity=$p($g(^CT("PROV",PROVRowId)),"^",10)		//是否有效(Y/N)
	    s:PROVActivity="" PROVActivity="Y"
	    s PROVSeqNo=$p($g(^CT("PROV",PROVRowId)),"^",14)		//系统排序号
		s PROVPYCode=$p($g(^CT("PROV",PROVRowId)),"^",18)		//拼音码
		s PROVWBCode=$p($g(^CT("PROV",PROVRowId)),"^",19)		//五笔码
		s PROVMark=$p($g(^CT("PROV",PROVRowId)),"^",20)		//备注
	
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Province",PROVRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)
        s BDPInternalDesc = $p($g(resultStr),"^",2)
        s BDPHospNationalCode=$p($g(resultStr),"^",3)  
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s AuFlag=0
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PROVRegionDRAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s PROVRegionDRAuFlag=0
        if (PROVRegionDRAuStr="")||(PROVRegionDRAuStr["limited:0") s PROVRegionDRAuFlag=1
        
        s CountryCodeAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s CountryCodeAuFlag=0
        if (CountryCodeAuStr="")||(CountryCodeAuStr["limited:0") s CountryCodeAuFlag=1
        
        s PROVRowId=0
        for
        {
            s PROVRowId=$o(^CT("PROV",PROVRowId)) q:PROVRowId=""
            s PROVRegionDR=$p($g(^CT("PROV",PROVRowId)),"^",3)
            s PROVCountryCode = $p($g(^CT("PROV",PROVRowId)),"^",9) 		//国家-外键
            s strRowId="{ID:"_PROVRowId_"}"
            s PROVRegionDRstrRowId="{ID:"_PROVRegionDR_"}"
            s CountryCodestrRowId="{ID:"_PROVCountryCode_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((PROVRegionDRAuStr[PROVRegionDRstrRowId)||(PROVRegionDRAuFlag=1))&&((CountryCodeAuStr[CountryCodestrRowId)||(CountryCodeAuFlag=1)) ;用来筛选授权数据
            {
                s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
                s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)
                S CTRGRowId=PROVRegionDR
                if PROVRegionDR'=""
                {
                    s PROVRegionDR=$p($g(^CT("RG",PROVRegionDR)),"^",2)
                }
                s PROVDateFrom=$p($g(^CT("PROV",PROVRowId)),"^",4)
                s PROVDateTo=$p($g(^CT("PROV",PROVRowId)),"^",5)
                s:PROVDateFrom'="" PROVDateFrom=$zd(PROVDateFrom,1)
                s:PROVDateTo'="" PROVDateTo=$zd(PROVDateTo,1)
                
                s PROVRomanCode=$p($g(^CT("PROV",PROVRowId)),"^",7)		//省级行政区罗马代码
			    s PROVRomanDesc=$p($g(^CT("PROV",PROVRowId)),"^",8)		//省级行政区罗马名称
			    
			    
			    continue:((countrydr'="")&&(countrydr'=PROVCountryCode))
			    s:PROVCountryCode'="" PROVCountryCode=$p($g(^CT("COU",PROVCountryCode)),"^",2)
			    s PROVActivity=$p($g(^CT("PROV",PROVRowId)),"^",10)		//是否有效(Y/N)
			    s:PROVActivity="" PROVActivity="Y"
			    s PROVSeqNo=$p($g(^CT("PROV",PROVRowId)),"^",14)		//系统排序号
				s PROVPYCode=$p($g(^CT("PROV",PROVRowId)),"^",18)		//拼音码
				s PROVWBCode=$p($g(^CT("PROV",PROVRowId)),"^",19)		//五笔码
				s PROVMark=$p($g(^CT("PROV",PROVRowId)),"^",20)		//备注
		
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Province",PROVRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Province",PROVRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROVDesc)
                i ($ZCONVERT(PROVCode,"U")[code)&(($ZCONVERT(PROVDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))&((CTRGRowId=regiondr)||(regiondr=""))*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Province",PROVRowId,PROVDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(PROVCode,"U")[code) &(AliasFlag=1)&((CTRGRowId=regiondr)||(regiondr=""))      
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PROVRowId,PROVCode,PROVDesc,PROVRegionDR,PROVDateFrom,PROVDateTo ,PROVRomanCode,PROVRomanDesc,PROVCountryCode,PROVActivity,PROVSeqNo,PROVPYCode,PROVWBCode,PROVMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：陈莹
/// CreatDate: 2013-2-20
/// Description:为combobox查询取数据
/// Table:User.CTProvince
/// Input:code,desc,regiondr
/// Return:PROVRowId,PROVCode,PROVDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTProvince","GetDataForCmb1","","","",1)
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, regiondr As %String, countrydr) As %Query(ROWSPEC = "PROVRowId:%String,PROVCode:%String,PROVDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, regiondr As %String, countrydr) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PROVRowId=rowid
        s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
        s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)  
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        ;未授权情况下，默认显示全部数据
        s AuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s AuFlag=0
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PROVRegionDRAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s PROVRegionDRAuFlag=0
        if (PROVRegionDRAuStr="")||(PROVRegionDRAuStr["limited:0") s PROVRegionDRAuFlag=1
        s CountryCodeAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s CountryCodeAuFlag=0
        if (CountryCodeAuStr="")||(CountryCodeAuStr["limited:0") s CountryCodeAuFlag=1
        
        s CountryID=countrydr
        s PROVRowId=0
        for
        {
            s PROVRowId=$o(^CT("PROV",PROVRowId)) q:PROVRowId=""
	            
            s PROVRegionDR=$p($g(^CT("PROV",PROVRowId)),"^",3)
            s PROVCountryCode = $p($g(^CT("PROV",PROVRowId)),"^",9) 		//国家-外键
            s strRowId="{ID:"_PROVRowId_"}"
            s PROVRegionDRstrRowId="{ID:"_PROVRegionDR_"}"
            s CountryCodestrRowId="{ID:"_PROVCountryCode_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((PROVRegionDRAuStr[PROVRegionDRstrRowId)||(PROVRegionDRAuFlag=1))&&((CountryCodeAuStr[CountryCodestrRowId)||(CountryCodeAuFlag=1)) ;用来筛选授权数据
            {
                s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
                s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)
                
                continue:((PROVCountryCode'=countrydr)&&(countrydr'=""))
			    
                s PROVActivity=$p($g(^CT("PROV",PROVRowId)),"^",10)		//是否有效(Y/N)
                continue:PROVActivity="N"
                s PROVDateFrom=$p($g(^CT("PROV",PROVRowId)),"^",4)
                continue:(PROVDateFrom'="")&&(PROVDateFrom>+$h)
                s PROVDateTo=$p($g(^CT("PROV",PROVRowId)),"^",5) 
                continue:(PROVDateTo'="")&&(PROVDateTo<+$h)
                
                
                s PROVCode1=$ZCONVERT(PROVCode,"U")
                s PROVDesc1=$ZCONVERT(PROVDesc,"U")
                s CTRGRowId=$p($g(^CT("PROV",PROVRowId)),"^",3)
                
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Province",PROVRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PROVDesc1)
                i (PROVCode1[code)&((PROVDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))&((CTRGRowId=regiondr)||(regiondr=""))*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Province",PROVRowId,PROVDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(PROVCode,"U")[code) &(AliasFlag=1)&((CTRGRowId=regiondr)||(regiondr=""))                      
                {
                    d OutputRowCmb
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PROVRowId,PROVCode,PROVDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetDataForCmb2(rowid As %String, code As %String, desc As %String, regiondr As %String) As %Query(ROWSPEC = "PROVRowId:%String,PROVCode:%String,PROVDesc:%String")
{
}

/// Creator：陈莹
/// CreatDate: 2015-1-1
/// Description:为邮编里的省份下拉框查询取数据
/// Table:User.CTProvince
/// Input:code,desc,regiondr
/// Return:PROVRowId,PROVCode,PROVDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTProvince","GetDataForCmb2","","","","1")
ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, regiondr As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PROVRowId=rowid
        s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
        s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)  
        d OutputRowCmb2
    }
    else
    {
        
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        ;未授权情况下，默认显示全部数据
        s AuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s AuFlag=0
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PROVRegionDRAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s PROVRegionDRAuFlag=0
        if (PROVRegionDRAuStr="")||(PROVRegionDRAuStr["limited:0") s PROVRegionDRAuFlag=1
        s CountryCodeAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s CountryCodeAuFlag=0
        if (CountryCodeAuStr="")||(CountryCodeAuStr["limited:0") s CountryCodeAuFlag=1
        
        s PROVRowId=0
        for
        {
            s PROVRowId=$o(^CT("PROV",PROVRowId)) q:PROVRowId=""
            s PROVRegionDR=$p($g(^CT("PROV",PROVRowId)),"^",3)
            s PROVCountryCode = $p($g(^CT("PROV",PROVRowId)),"^",9) 		//国家-外键
	            
            s strRowId="{ID:"_PROVRowId_"}"
            s PROVRegionDRstrRowId="{ID:"_PROVRegionDR_"}"
            s CountryCodestrRowId="{ID:"_PROVCountryCode_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((PROVRegionDRAuStr[PROVRegionDRstrRowId)||(PROVRegionDRAuFlag=1))&&((CountryCodeAuStr[CountryCodestrRowId)||(CountryCodeAuFlag=1)) ;用来筛选授权数据
            {
                s PROVCode=$p($g(^CT("PROV",PROVRowId)),"^",1)
                s PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)
                s PROVActivity=$p($g(^CT("PROV",PROVRowId)),"^",10)		//是否有效(Y/N)
                continue:PROVActivity="N"
                s PROVCode1=$ZCONVERT(PROVCode,"U")
                s PROVDesc1=$ZCONVERT(PROVDesc,"U")
                s CTRGRowId=$p($g(^CT("PROV",PROVRowId)),"^",3)
                s PROVDateFrom=$p($g(^CT("PROV",PROVRowId)),"^",4)
                s PROVDateTo=$p($g(^CT("PROV",PROVRowId)),"^",5)
                continue:(PROVDateTo'="")&&(PROVDateTo<+$h)
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Province",PROVRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                
                i (PROVCode1[code)&((PROVDesc1[desc)||(ALIASText1[desc))&(CTRGRowId=regiondr)*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Province",PROVRowId,PROVDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(PROVCode,"U")[code) &(AliasFlag=1)&(CTRGRowId=regiondr)
                {
                    d OutputRowCmb2
                }
            }
        }
        
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(PROVRowId,PROVCode,PROVDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// PROV_Region_DR->CT_Region

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.CTProvince
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTProvince).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s flag=""
    if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s idc=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
		if ((idc'="")&&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	if ($$ALPHAUP^SSUTIL4(desc)'="")
	{
		s idd=$o(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(desc),0))
		if ((idd'="")&&(idd'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
    q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:双击修改时,从后台取数据
/// Table:User.CTProvince
/// Input:id
/// Return:Json格式的字符串str={list:[PROVCode,PROVDesc,PROVRegionDR,PROVDateFrom,PROVDateTo,PROVRowId]}
/// Other:d ##class(web.DHCBL.CT.CTProvince).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    n (id)
    s str=""
    s pobj = ##class(User.CTProvince).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTProvince).%New()
    s eobj.PROVRowId = id
    s eobj.PROVCode = pobj.PROVCode
    s eobj.PROVDesc = pobj.PROVDesc
    if $IsObject(pobj.PROVRegionDR){
        s eobj.PROVRegionDR = pobj.PROVRegionDR.%Id() 
        }
    s eobj.PROVDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PROVDateFrom)
    s eobj.PROVDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.PROVDateTo)
    
    s eobj.PROVRomanCode=pobj.PROVRomanCode		//省级行政区罗马代码
    s eobj.PROVRomanDesc=pobj.PROVRomanDesc		//省级行政区罗马名称
    if $IsObject(pobj.PROVCountryCode){
            s eobj.PROVCountryCode = pobj.PROVCountryCode.%Id() 		//国家-外键
    }
    s eobj.PROVActivity=pobj.PROVActivity		//是否有效(Y/N)
    s:((eobj.PROVActivity="")||(eobj.PROVActivity="Y")) eobj.PROVActivity="true"
    s:pobj.PROVActivity="Y" eobj.PROVActivity="true"
    s eobj.PROVSeqNo=pobj.PROVSeqNo		//系统排序号
	s eobj.PROVPYCode=pobj.PROVPYCode		//拼音码
	s eobj.PROVWBCode=pobj.PROVWBCode		//五笔码
	s eobj.PROVMark=pobj.PROVMark		//备注
			
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:增加/修改 省
/// Table:User.CTProvince
/// Input:web.Entity.CT.CTProvince
/// Return:成功返回success:'true'和新增或修改的数据的PROVRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTProvince) As %String
{
    new (eobj,%session)
    s result=""
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    }  
    
    s:eobj.PROVLastUpdateDate="" eobj.PROVLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.PROVLastUpdateTime="" eobj.PROVLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.PROVLastUpdateUser="" eobj.PROVLastUpdateUser=UserID	//系统最新更新人
    
    if $IsObject(eobj)
    {
        //前台js已添加空值判断、重复判断、开始日期是否小于结束日期
        s:eobj.PROVDateFrom'="" eobj.PROVDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROVDateFrom)
        s:eobj.PROVDateTo'="" eobj.PROVDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PROVDateTo)
        s:eobj.PROVDateFrom="" eobj.PROVDateFrom=+$h
        s:eobj.PROVActivity="" eobj.PROVActivity="N"
        if (eobj.PROVRowId="")       
        {
            s obj=##class(User.CTProvince).%New()
            s:eobj.PROVCreateDate="" eobj.PROVCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.PROVCreateTime="" eobj.PROVCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.PROVCreateUser="" eobj.PROVCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.PROVCreateDate=eobj.PROVCreateDate		//系统创建日期
			s obj.PROVCreateTime=eobj.PROVCreateTime		//系统创建时间
			d obj.PROVCreateUserSetObjectId(eobj.PROVCreateUser)	//系统创建人
        }
        else                           
        {
            s obj=##class(User.CTProvince).%OpenId(eobj.PROVRowId)
            s bobj=##class(web.Entity.CT.CTProvince).%New()
            s bobj.PROVRowId = eobj.PROVRowId
            s bobj.PROVCode = obj.PROVCode
            s bobj.PROVDesc = obj.PROVDesc
            if $IsObject(obj.PROVRegionDR){
                    s bobj.PROVRegionDR = obj.PROVRegionDR.%Id() 
                }
            s bobj.PROVDateFrom=obj.PROVDateFrom
            s bobj.PROVDateTo=obj.PROVDateTo
            
            s bobj.PROVRomanCode=obj.PROVRomanCode		//省级行政区罗马代码
            s bobj.PROVRomanDesc=obj.PROVRomanDesc		//省级行政区罗马名称
            if $IsObject(obj.PROVCountryCode){
                    s bobj.PROVCountryCode = obj.PROVCountryCode.%Id() 		//国家-外键
            }
            s bobj.PROVActivity=obj.PROVActivity		//是否有效(Y/N)
            s bobj.PROVCreateDate=obj.PROVCreateDate		//系统创建日期
            s bobj.PROVCreateTime=obj.PROVCreateTime		//系统创建时间
            if $IsObject(obj.PROVCreateUser){
                    s bobj.PROVCreateUser = obj.PROVCreateUser.%Id() 		//系统创建人
            }
            s bobj.PROVSeqNo=obj.PROVSeqNo		//系统排序号
			s bobj.PROVLastUpdateDate=obj.PROVLastUpdateDate		//系统最后更新日期
			s bobj.PROVLastUpdateTime=obj.PROVLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.PROVLastUpdateUser){
				s bobj.PROVLastUpdateUser = obj.PROVLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.PROVPYCode=obj.PROVPYCode		//拼音码
			s bobj.PROVWBCode=obj.PROVWBCode		//五笔码
			s bobj.PROVMark=obj.PROVMark		//备注
            

        }
        s obj.PROVCode = eobj.PROVCode
        s obj.PROVDesc = eobj.PROVDesc
        d obj.PROVRegionDRSetObjectId(eobj.PROVRegionDR)
        //s obj.PROVRegionDR=##class(User.CTRegion).%OpenId(eobj.PROVRegionDR)
        s obj.PROVDateFrom=eobj.PROVDateFrom
        s obj.PROVDateTo=eobj.PROVDateTo
        
        s obj.PROVRomanCode=eobj.PROVRomanCode		//省级行政区罗马代码
        s obj.PROVRomanDesc=eobj.PROVRomanDesc		//省级行政区罗马名称
        d obj.PROVCountryCodeSetObjectId(eobj.PROVCountryCode)		//国家-外键
        
        s obj.PROVActivity=eobj.PROVActivity		//是否有效(Y/N)
        s obj.PROVSeqNo=eobj.PROVSeqNo		//系统排序号
		s obj.PROVLastUpdateDate=eobj.PROVLastUpdateDate		//系统最后更新日期
		s obj.PROVLastUpdateTime=eobj.PROVLastUpdateTime		//系统最后更新时间
		d obj.PROVLastUpdateUserSetObjectId(eobj.PROVLastUpdateUser) 	//系统最新更新人
		s:eobj.PROVPYCode="" eobj.PROVPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.PROVDesc)
		s obj.PROVPYCode=eobj.PROVPYCode		//拼音码
		s:eobj.PROVWBCode="" eobj.PROVWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.PROVDesc,1)
		s obj.PROVWBCode=eobj.PROVWBCode		//五笔码
		s obj.PROVMark=eobj.PROVMark		//备注
        
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            if (eobj.PROVRowId="")
            {
	            s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.PROVDesc)
	            s listData ="^"_"CT_Province"_"^"_Alias_"^"_id
	            s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
            }
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.PROVRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Province","User.CTProvince","省",id,eobj.PROVDesc,"A",eobj)
            d:eobj.PROVRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Province","User.CTProvince","省",id,eobj.PROVDesc,"U",eobj,bobj)
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("省","web.DHCBL.CT.CTProvince","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator:陈莹
/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s CTCITRowId=0,flag=0
    for
    {
        s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:(CTCITRowId="")||(flag=1)
        s CTCITProvinceDR=$p($g(^CT("CIT",CTCITRowId)),"^",4)
        i CTCITProvinceDR=id
        {
            s flag=1
            s myInfo=myInfo_"<城市>"
        }
    }
    if $d(^CT("ZIP",0,"Prov",id))
    {
        s myInfo=myInfo_"<邮编>"
    }
    if $d(^CT("ADD",0,"Province",id))
    {
        s myInfo=myInfo_"<地址>"
    }
    
    if $d(^CT.BDP.CT.HOSOrganizationI("IndexPROVCode",id)){
        s myInfo=myInfo_"<组织机构树>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexNPPROVCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    if $d(^CT.BDP.CT.HOSPersonI("IndexAddrPROVCode",id)){
        s myInfo=myInfo_"<组织人员>"
    }
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    q return
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:根据id删除 省
/// Table:User.CTProvince
/// Input:id(CTProvince的PROVRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.CTProvince).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    
    s re=##class(web.DHCBL.CT.CTProvince).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    s pobj = ##class(User.CTProvince).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTProvince).%New()
    s eobj.PROVRowId = id
    s eobj.PROVCode = pobj.PROVCode
    s eobj.PROVDesc = pobj.PROVDesc
    if $IsObject(pobj.PROVRegionDR){
        s eobj.PROVRegionDR = pobj.PROVRegionDR.%Id() 
        }
    //s:pobj.PROVDateFrom'="" eobj.PROVDateFrom =$zd(pobj.PROVDateFrom,1)
    //s:pobj.PROVDateTo'="" eobj.PROVDateTo = $zd(pobj.PROVDateTo,1)
    s eobj.PROVDateFrom =pobj.PROVDateFrom
    s eobj.PROVDateTo = pobj.PROVDateTo
    
    s eobj.PROVRomanCode=pobj.PROVRomanCode		//省级行政区罗马代码
    s eobj.PROVRomanDesc=pobj.PROVRomanDesc		//省级行政区罗马名称
    if $IsObject(pobj.PROVCountryCode){
            s eobj.PROVCountryCode = pobj.PROVCountryCode.%Id() 		//国家-外键
    }
    s eobj.PROVActivity=pobj.PROVActivity		//是否有效(Y/N)
    s eobj.PROVSeqNo=pobj.PROVSeqNo		//系统排序号
	s eobj.PROVPYCode=pobj.PROVPYCode		//拼音码
	s eobj.PROVWBCode=pobj.PROVWBCode		//五笔码
	s eobj.PROVMark=pobj.PROVMark		//备注
	
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTProvince).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Province","User.CTProvince","省",id,eobj.PROVDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("省","web.DHCBL.CT.CTProvince","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

/// Debug:d ##class(web.DHCBL.CT.CTProvince).UpdateCountryCode()
ClassMethod UpdateCountryCode()
{
	&SQL(Update	SQLUser.CT_Province set PROV_CountryCode=1)
}

}
