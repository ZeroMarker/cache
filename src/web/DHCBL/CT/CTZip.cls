Import SQLUser

/// 名称:地理信息 -5 邮编
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-12
Class web.DHCBL.CT.CTZip Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2013-2-20
/// Description:查询 邮编
/// Table:User.CTZip
/// Input:rowid,code,desc
/// Return:CTZIPRowId,CTZIPCode,CTZIPDesc,CTZIPRegionDR,CTZIPProvinceDR,CTZIPHCADR,CTZIPCITYDR,CTZIPCITYAREADR,CTZIPDateFrom,CTZIPDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTZip","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTZIPRowId:%String,CTZIPCode:%String,CTZIPDesc:%String,CTZIPRegionDR:%String,CTZIPProvinceDR:%String,CTZIPHCADR:%String,CTZIPCITYDR:%String,CTZIPCITYAREADR:%String,CTZIPDateFrom:%String,CTZIPDateTo:%String,CTZIPRegionDR1:%String,CTZIPProvinceDR1:%String,CTZIPCITYDR1:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s CTZIPRowId=rowid
        s CTZIPCode=$p($g(^CT("ZIP",CTZIPRowId)),"^",1)
        s CTZIPDesc=$p($g(^CT("ZIP",CTZIPRowId)),"^",2)
        s CTRGRowId=$p($g(^CT("ZIP",CTZIPRowId)),"^",3)
        
        i CTRGRowId'="" {
            s CTZIPRegionDR=$p($g(^CT("RG",CTRGRowId)),"^",2)
        }
        else {
            s CTZIPRegionDR=""
        }
        s PROVRowId=$p($g(^CT("ZIP",CTZIPRowId)),"^",4)
        
        i PROVRowId'="" {
            s CTZIPProvinceDR=$p($g(^CT("PROV",PROVRowId)),"^",2)
        }
        else { 
            s CTZIPProvinceDR=""
        }
        s HCARowId=$p($g(^CT("ZIP",CTZIPRowId)),"^",5)
        i HCARowId'="" {
            s CTZIPHCADR=$p($g(^CT("HCA",HCARowId)),"^",2)
        }
        else {
            s CTZIPHCADR=""
        }
        s CTCITRowId=$p($g(^CT("ZIP",CTZIPRowId)),"^",6)
        i CTCITRowId'="" {
            s CTZIPCITYDR=$p($g(^CT("CIT",CTCITRowId)),"^",2)
        }
        else {
            s CTZIPCITYDR=""
        }
        
        s CTZIPRegionDR1=CTRGRowId
        s CTZIPProvinceDR1=PROVRowId
        s CTZIPCITYDR1=CTCITRowId
        
        s CITAREARowId=$p($g(^CT("ZIP",CTZIPRowId)),"^",7)
        i CITAREARowId'="" {
            s CTZIPCITYAREADR=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
        }
        else {
            s CTZIPCITYAREADR=""
        }
        ;s CTZIPActive=$p($g(^CT("ZIP",CTZIPRowId)),"^",10)
        s CTZIPDateFrom=$p($g(^CT("ZIP",CTZIPRowId)),"^",15)
        s CTZIPDateTo=$p($g(^CT("ZIP",CTZIPRowId)),"^",16)
        s:CTZIPDateFrom'="" CTZIPDateFrom=$zd(CTZIPDateFrom,1)
        s:CTZIPDateTo'="" CTZIPDateTo=$zd(CTZIPDateTo,1)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Zip",CTZIPRowId)
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
        s AuStr=##class(web.DHCBL.Authorize.CTZip).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s CTZIPRegionDRAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s CTZIPRegionDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPRegionDRAuStr="")||(CTZIPRegionDRAuStr["limited:0") s CTZIPRegionDRAuFlag=1
        
        s CTZIPProvinceDRAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s CTZIPProvinceDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPProvinceDRAuStr="")||(CTZIPProvinceDRAuStr["limited:0") s CTZIPProvinceDRAuFlag=1
        
        s CTZIPCITYDRAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
        s CTZIPCITYDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPCITYDRAuStr="")||(CTZIPCITYDRAuStr["limited:0") s CTZIPCITYDRAuFlag=1
        
        s CTZIPCITYAREADRAuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
        s CTZIPCITYAREADRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPCITYAREADRAuStr="")||(CTZIPCITYAREADRAuStr["limited:0") s CTZIPCITYAREADRAuFlag=1
        
        s CTZIPHCADRAuStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
        s CTZIPHCADRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPHCADRAuStr="")||(CTZIPHCADRAuStr["limited:0") s CTZIPHCADRAuFlag=1
        
        s CTZIPRowId=0
        for
        {
            s CTZIPRowId=$o(^CT("ZIP",CTZIPRowId)) q:CTZIPRowId=""
            s CTZIPRegionDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",3)
            s CTZIPProvinceDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",4)
            s CTZIPCITYDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",6)
            s CTZIPCITYAREADR=$p($g(^CT("ZIP",CTZIPRowId)),"^",7)
            s CTZIPHCADR=$p($g(^CT("ZIP",CTZIPRowId)),"^",5)
        
            s strRowId="{ID:"_CTZIPRowId_"}"
            s CTZIPRegionDRstrRowId="{ID:"_CTZIPRegionDR_"}"
            s CTZIPProvinceDRstrRowId="{ID:"_CTZIPProvinceDR_"}"
            s CTZIPCITYDRstrRowId="{ID:"_CTZIPCITYDR_"}"
            s CTZIPCITYAREADRstrRowId="{ID:"_CTZIPCITYAREADR_"}"
            s CTZIPHCADRstrRowId="{ID:"_CTZIPHCADR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTZIPRegionDRAuStr[CTZIPRegionDRstrRowId)||(CTZIPRegionDRAuFlag=1))&&((CTZIPProvinceDRAuStr[CTZIPProvinceDRstrRowId)||(CTZIPProvinceDRAuFlag=1))&&((CTZIPCITYDRAuStr[CTZIPCITYDRstrRowId)||(CTZIPCITYDRAuFlag=1))&&((CTZIPCITYAREADRAuStr[CTZIPCITYAREADRstrRowId)||(CTZIPCITYAREADRAuFlag=1))&&((CTZIPHCADRAuStr[CTZIPHCADRstrRowId)||(CTZIPHCADRAuFlag=1))    ;用来筛选授权数据
            {
                s CTZIPCode=$p($g(^CT("ZIP",CTZIPRowId)),"^",1)
                s CTZIPDesc=$p($g(^CT("ZIP",CTZIPRowId)),"^",2)
                s CTZIPCode1=$ZCONVERT(CTZIPCode,"U")
                s CTZIPDesc1=$ZCONVERT(CTZIPDesc,"U")
                s CTRGRowId=CTZIPRegionDR
                i CTRGRowId'="" {
                    s CTZIPRegionDR=$p($g(^CT("RG",CTRGRowId)),"^",2)
                }
                s PROVRowId=CTZIPProvinceDR
                i PROVRowId'="" {
                    s CTZIPProvinceDR=$p($g(^CT("PROV",PROVRowId)),"^",2)
                }
                
                s HCARowId=CTZIPHCADR
                i HCARowId'="" {
                    s CTZIPHCADR=$p($g(^CT("HCA",HCARowId)),"^",2)
                }
                
                s CTCITRowId=CTZIPCITYDR
                i CTCITRowId'="" {
                    s CTZIPCITYDR=$p($g(^CT("CIT",CTCITRowId)),"^",2)
                }
            
                s CITAREARowId=CTZIPCITYAREADR
                i CITAREARowId'="" {
                    s CTZIPCITYAREADR=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
                }
                
                s CTZIPRegionDR1=CTRGRowId
                s CTZIPProvinceDR1=PROVRowId
                s CTZIPCITYDR1=CTCITRowId
        
                ;s CTZIPActive=$p($g(^CT("ZIP",CTZIPRowId)),"^",10)
                s CTZIPDateFrom=$p($g(^CT("ZIP",CTZIPRowId)),"^",15)
                s CTZIPDateTo=$p($g(^CT("ZIP",CTZIPRowId)),"^",16)
                s:CTZIPDateFrom'="" CTZIPDateFrom=$zd(CTZIPDateFrom,1)
                s:CTZIPDateTo'="" CTZIPDateTo=$zd(CTZIPDateTo,1)
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Zip",CTZIPRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                 
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Zip",CTZIPRowId,CTZIPDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTZIPCode,"U")[code) &(AliasFlag=1)       
                {
                    d OutputRow
                }
            }
        }
        
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTZIPRowId,CTZIPCode,CTZIPDesc,CTZIPRegionDR,CTZIPProvinceDR,CTZIPHCADR,CTZIPCITYDR,CTZIPCITYAREADR,CTZIPDateFrom,CTZIPDateTo,CTZIPRegionDR1,CTZIPProvinceDR1,CTZIPCITYDR1,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate: 2013-2-22
/// Description:为combobox查询取数据
/// Table:User.CTZip
/// Input:code,desc
/// Return:CTZIPRowId,CTZIPCode,CTZIPDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTZip","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTZIPRowId:%String,CTZIPCode:%String,CTZIPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s CTZIPRowId=rowid
        s CTZIPCode=$p($g(^CT("ZIP",CTZIPRowId)),"^",1)
        s CTZIPDesc=$p($g(^CT("ZIP",CTZIPRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.CTZip).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s CTZIPRegionDRAuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s CTZIPRegionDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPRegionDRAuStr="")||(CTZIPRegionDRAuStr["limited:0") s CTZIPRegionDRAuFlag=1
        
        s CTZIPProvinceDRAuStr=##class(web.DHCBL.Authorize.CTProvince).DHCGetDataByDefaultSession()
        s CTZIPProvinceDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPProvinceDRAuStr="")||(CTZIPProvinceDRAuStr["limited:0") s CTZIPProvinceDRAuFlag=1
        
        s CTZIPCITYDRAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
        s CTZIPCITYDRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPCITYDRAuStr="")||(CTZIPCITYDRAuStr["limited:0") s CTZIPCITYDRAuFlag=1
        
        s CTZIPCITYAREADRAuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
        s CTZIPCITYAREADRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPCITYAREADRAuStr="")||(CTZIPCITYAREADRAuStr["limited:0") s CTZIPCITYAREADRAuFlag=1
        
        s CTZIPHCADRAuStr=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByDefaultSession()
        s CTZIPHCADRAuFlag=0
        ;未授权情况下，默认显示全部数据
        if (CTZIPHCADRAuStr="")||(CTZIPHCADRAuStr["limited:0") s CTZIPHCADRAuFlag=1
        
        s CTZIPRowId=0
        for
        {
            s CTZIPRowId=$o(^CT("ZIP",CTZIPRowId)) q:CTZIPRowId=""
            s CTZIPRegionDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",3)
            s CTZIPProvinceDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",4)
            s CTZIPCITYDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",6)
            s CTZIPCITYAREADR=$p($g(^CT("ZIP",CTZIPRowId)),"^",7)
            s CTZIPHCADR=$p($g(^CT("ZIP",CTZIPRowId)),"^",5)
        
            s strRowId="{ID:"_CTZIPRowId_"}"
            s CTZIPRegionDRstrRowId="{ID:"_CTZIPRegionDR_"}"
            s CTZIPProvinceDRstrRowId="{ID:"_CTZIPProvinceDR_"}"
            s CTZIPCITYDRstrRowId="{ID:"_CTZIPCITYDR_"}"
            s CTZIPCITYAREADRstrRowId="{ID:"_CTZIPCITYAREADR_"}"
            s CTZIPHCADRstrRowId="{ID:"_CTZIPHCADR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTZIPRegionDRAuStr[CTZIPRegionDRstrRowId)||(CTZIPRegionDRAuFlag=1))&&((CTZIPProvinceDRAuStr[CTZIPProvinceDRstrRowId)||(CTZIPProvinceDRAuFlag=1))&&((CTZIPCITYDRAuStr[CTZIPCITYDRstrRowId)||(CTZIPCITYDRAuFlag=1))&&((CTZIPCITYAREADRAuStr[CTZIPCITYAREADRstrRowId)||(CTZIPCITYAREADRAuFlag=1))&&((CTZIPHCADRAuStr[CTZIPHCADRstrRowId)||(CTZIPHCADRAuFlag=1))    ;用来筛选授权数据
            {
                s CTZIPCode=$p($g(^CT("ZIP",CTZIPRowId)),"^",1)
                s CTZIPDesc=$p($g(^CT("ZIP",CTZIPRowId)),"^",2)
                s CTZIPDateFrom=$p($g(^CT("ZIP",CTZIPRowId)),"^",15)
                continue:(CTZIPDateFrom'="")&&(CTZIPDateFrom>+$h)
                s CTZIPDateTo=$p($g(^CT("ZIP",CTZIPRowId)),"^",16) 
                continue:(CTZIPDateTo'="")&&(CTZIPDateTo<+$h)
                s CTZIPCode1=$ZCONVERT(CTZIPCode,"U")
                s CTZIPDesc1=$ZCONVERT(CTZIPDesc,"U")
                 
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Zip",CTZIPRowId,CTZIPDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTZIPCode,"U")[code) &(AliasFlag=1)                   
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTZIPRowId,CTZIPCode,CTZIPDesc)
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

// CTZIP_Region_DR->CT_Region

// CTZIP_Province_DR->CT_Province

// CTZIP_CITY_DR->CT_City

// CTZIP_CITYAREA_DR->CT_CityArea

// CTZIP_HCA_DR->CT_HealthCareArea

/*ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^CT("ZIP",0,"Code",code))
    s:desc'="" flagd=$d(^CT("ZIP",0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0))
        {
            s flag=1  //返回重复标志
        }
        else
        {
            s flag=0 //返回不重复标志
        }
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s idd=""
        s:code'="" idc=$o(^CT("ZIP",0,"Code",code,0))
        s:desc'="" idd=$o(^CT("ZIP",0,"Desc",desc,0))
        if (desc="")
        {
            if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
        else
        {
            if (code="")
            {
                if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
                else  s flag=0 //返回不重复标志
            }
            else
            {
                if ((idc'=id)||(idd'=id))&((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
                else  s flag=0 //返回不重复标志
            }
        }
    }
    q flag
}*/
/// Creator:谷雪萍
/// CreatDate:2016-9-20
/// Description:代码和描述可以重复，要合起来校验
/// Table:User.CTZip
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTZip).FormValidate("","102300","门头沟区")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s flag=0
    if ($$ALPHAUP^SSUTIL4(code)'="")
    {
        
        s idc=0
        for
        {
            s idc=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            s CTZIPCode=$p($g(^CT("ZIP",idc)),"^",1) 
            s CTZIPDesc=$p($g(^CT("ZIP",idc)),"^",2) 
            s CTZIPDateTo=$p($g(^CT("ZIP",idc)),"^",16)
            continue:(CTZIPDateTo'="")
            if (CTZIPCode=code)&&(CTZIPDesc=desc)&&(id'=idc)
            {
	            s flag=1  //返回重复标志
            }
        }
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:双击修改时,从后台取数据
/// Table:User.CTZip
/// Input:id
/// Return:Json格式的字符串str={list:[CTZIPCode,CTZIPDesc,CTZIPRegionDR,CTZIPProvinceDR,CTZIPHCADR,
///                                 CTZIPCITYDR,CTZIPCITYAREADR,CTZIPDateFrom,CTZIPDateTo,CTZIPRowId]}
/// Other:d ##class(web.DHCBL.CT.CTZip).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    new (id)
    s str=""
    s pobj = ##class(User.CTZip).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTZip).%New()
    s eobj.CTZIPRowId = id
    s eobj.CTZIPCode = pobj.CTZIPCode
    s eobj.CTZIPDesc = pobj.CTZIPDesc
    if $IsObject(pobj.CTZIPRegionDR){
        s eobj.CTZIPRegionDR = pobj.CTZIPRegionDR.%Id() 
        }
    if $IsObject(pobj.CTZIPProvinceDR){
        s eobj.CTZIPProvinceDR = pobj.CTZIPProvinceDR.%Id() 
        }
    if $IsObject(pobj.CTZIPCITYDR){
        s eobj.CTZIPCITYDR = pobj.CTZIPCITYDR.%Id() 
        }
    if $IsObject(pobj.CTZIPHCADR){
        s eobj.CTZIPHCADR = pobj.CTZIPHCADR.%Id() 
        }
    if $IsObject(pobj.CTZIPCITYAREADR){
        s eobj.CTZIPCITYAREADR = pobj.CTZIPCITYAREADR.%Id() 
        }
    s eobj.CTZIPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTZIPDateFrom)
    s eobj.CTZIPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTZIPDateTo)
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:增加/修改 邮编
/// Table:User.CTZip
/// Input:web.Entity.CT.CTZip
/// Return:成功返回success:'true'和新增或修改的数据的CTZIPRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTZip) As %String
{
    new (eobj,%session)
    s result=""
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.CTZIPRowId,eobj.CTZIPCode,eobj.CTZIPDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            //前台js已添加空值判断、重复判断、开始日期是否小于结束日期
            s:eobj.CTZIPDateFrom'="" eobj.CTZIPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTZIPDateFrom)
            s:eobj.CTZIPDateTo'="" eobj.CTZIPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTZIPDateTo)     
            s:eobj.CTZIPDateFrom="" eobj.CTZIPDateFrom=+$h
            if (eobj.CTZIPRowId="")       
            {
                s obj=##class(User.CTZip).%New()
            }   
            else                           
            {
                s obj=##class(User.CTZip).%OpenId(eobj.CTZIPRowId)
            
                s bobj = ##class(web.Entity.CT.CTZip).%New()
                s bobj.CTZIPRowId = eobj.CTZIPRowId
                s bobj.CTZIPCode = obj.CTZIPCode
                s bobj.CTZIPDesc = obj.CTZIPDesc
                if $IsObject(obj.CTZIPRegionDR){
                    s bobj.CTZIPRegionDR = obj.CTZIPRegionDR.%Id() 
                }
                if $IsObject(obj.CTZIPProvinceDR){
                    s bobj.CTZIPProvinceDR = obj.CTZIPProvinceDR.%Id() 
                }
                if $IsObject(obj.CTZIPCITYDR){
                    s bobj.CTZIPCITYDR = obj.CTZIPCITYDR.%Id() 
                }
                if $IsObject(obj.CTZIPHCADR){
                    s bobj.CTZIPHCADR = obj.CTZIPHCADR.%Id() 
                }
                if $IsObject(obj.CTZIPCITYAREADR){
                    s bobj.CTZIPCITYAREADR = obj.CTZIPCITYAREADR.%Id() 
                }
                s bobj.CTZIPDateFrom=obj.CTZIPDateFrom
                s bobj.CTZIPDateTo=obj.CTZIPDateTo
            
            }
            s obj.CTZIPCode = eobj.CTZIPCode
            s obj.CTZIPDesc = eobj.CTZIPDesc
            d obj.CTZIPRegionDRSetObjectId(eobj.CTZIPRegionDR)
            d obj.CTZIPProvinceDRSetObjectId(eobj.CTZIPProvinceDR)
            d obj.CTZIPCITYDRSetObjectId(eobj.CTZIPCITYDR)
            d obj.CTZIPHCADRSetObjectId(eobj.CTZIPHCADR)
            d obj.CTZIPCITYAREADRSetObjectId(eobj.CTZIPCITYAREADR)
            //s obj.CTZIPRegionDR=##class(User.CTRegion).%OpenId(eobj.CTZIPRegionDR)
            //s obj.CTZIPProvinceDR=##class(User.CTProvince).%OpenId(eobj.CTZIPProvinceDR)
            //s obj.CTZIPCITYDR=##class(User.CTCity).%OpenId(eobj.CTZIPCITYDR)
            //s obj.CTZIPHCADR=##class(User.CTHealthCareArea).%OpenId(eobj.CTZIPHCADR)
            //s obj.CTZIPCITYAREADR=##class(User.CTCityArea).%OpenId(eobj.CTZIPCITYAREADR)
            s obj.CTZIPDateFrom=eobj.CTZIPDateFrom
            s obj.CTZIPDateTo=eobj.CTZIPDateTo
        
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                if (eobj.CTZIPRowId="")
                {
	                s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.CTZIPDesc)
	                s listData ="^"_"CT_Zip"_"^"_Alias_"^"_id
	                s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
                }
                s result = "{success:'true',id:'"_id_"'}"
                d:eobj.CTZIPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Zip","User.CTZip","邮编",id,eobj.CTZIPDesc,"A",eobj)
                d:eobj.CTZIPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Zip","User.CTZip","邮编",id,eobj.CTZIPDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("邮编","web.DHCBL.CT.CTZip","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   

    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator:陈莹
/// CreatDate:2012-9-12
/// Description:根据id删除 邮编
/// Table:User.CTZip
/// Input:id(CTZip的CTZIPRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTZip).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s pobj = ##class(User.CTZip).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTZip).%New()
    s eobj.CTZIPRowId = id
    s eobj.CTZIPCode = pobj.CTZIPCode
    s eobj.CTZIPDesc = pobj.CTZIPDesc
    if $IsObject(pobj.CTZIPRegionDR){
        s eobj.CTZIPRegionDR = pobj.CTZIPRegionDR.%Id() 
        }
    if $IsObject(pobj.CTZIPProvinceDR){
        s eobj.CTZIPProvinceDR = pobj.CTZIPProvinceDR.%Id() 
        }
    if $IsObject(pobj.CTZIPCITYDR){
        s eobj.CTZIPCITYDR = pobj.CTZIPCITYDR.%Id() 
        }
    if $IsObject(pobj.CTZIPHCADR){
        s eobj.CTZIPHCADR = pobj.CTZIPHCADR.%Id() 
        }
    if $IsObject(pobj.CTZIPCITYAREADR){
        s eobj.CTZIPCITYAREADR = pobj.CTZIPCITYAREADR.%Id() 
        }
    s eobj.CTZIPDateFrom =pobj.CTZIPDateFrom
    s eobj.CTZIPDateTo = pobj.CTZIPDateTo
    //s:pobj.CTZIPDateFrom'="" eobj.CTZIPDateFrom =$zd(pobj.CTZIPDateFrom,1)
    //s:pobj.CTZIPDateTo'="" eobj.CTZIPDateTo = $zd(pobj.CTZIPDateTo,1)
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTZip).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Zip","User.CTZip","邮编",id,eobj.CTZIPDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("邮编","web.DHCBL.CT.CTZip","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    q result
}

}
