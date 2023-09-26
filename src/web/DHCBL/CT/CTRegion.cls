Import SQLUser

/// 名称:地理信息 - 2 区域
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-9-10
Class web.DHCBL.CT.CTRegion Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-2-19
/// Description:查询 区域
/// Table:User.CTRegion
/// Input:rowid,code,desc
/// Return:CTRGRowId,CTRGCode,CTRGDesc,CTRGCountryDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTRegion","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRGRowId:%String,CTRGCode:%String,CTRGDesc:%String,CTRGCountryDR:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s CTRGRowId=rowid
        s CTRGCode=$p($g(^CT("RG",CTRGRowId)),"^",1)
        s CTRGDesc=$p($g(^CT("RG",CTRGRowId)),"^",2)
        s CTCOURowId=$p($g(^CT("RG",CTRGRowId)),"^",4)
        i CTCOURowId'="" {
            s CTRGCountryDR=$p($g(^CT("COU",CTCOURowId)),"^",2)
        }
        else {
            s CTRGCountryDR=""
        }
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Region",CTRGRowId)
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
        ;未授权情况下，默认显示全部数据
        s AuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s AuFlag=0
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s CTRGCountryDRAuStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
        s CTRGCountryDRAuFlag=0
        if (CTRGCountryDRAuStr="")||(CTRGCountryDRAuStr["limited:0") s CTRGCountryDRAuFlag=1
        s CTRGRowId=0
        for
        {
            s CTRGRowId=$o(^CT("RG",CTRGRowId)) q:CTRGRowId=""
            s CTRGCountryDR=$p($g(^CT("RG",CTRGRowId)),"^",4)
            s strRowId="{ID:"_CTRGRowId_"}"
            s CTRGCountryDRstrRowId="{ID:"_CTRGCountryDR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTRGCountryDRAuStr[CTRGCountryDRstrRowId)||(CTRGCountryDRAuFlag=1)) ;用来筛选授权数据
            {
                s CTRGCode=$p($g(^CT("RG",CTRGRowId)),"^",1)
                s CTRGDesc=$p($g(^CT("RG",CTRGRowId)),"^",2)
                s CTCOURowId=CTRGCountryDR
                i CTRGCountryDR'="" {
                    s CTRGCountryDR=$p($g(^CT("COU",CTRGCountryDR)),"^",2)
                }
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Region",CTRGRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Region",CTRGRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTRGDesc)
                i ($ZCONVERT(CTRGCode,"U")[code)&(($ZCONVERT(CTRGDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Region",CTRGRowId,CTRGDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTRGCode,"U")[code) &(AliasFlag=1)                
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTRGRowId,CTRGCode,CTRGDesc,CTRGCountryDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator:陈莹
/// CreatDate:2013-2-22
/// Description:为combobox查询取数据
/// Table:User.CTRegion
/// Input:code,desc
/// Return:CTRGRowId,CTRGCode,CTRGDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTRegion","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTRGRowId:%String,CTRGCode:%String,CTRGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s CTRGRowId=rowid
        s CTRGCode=$p($g(^CT("RG",CTRGRowId)),"^",1)
        s CTRGDesc=$p($g(^CT("RG",CTRGRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        ;未授权情况下，默认显示全部数据
        s AuStr=##class(web.DHCBL.Authorize.CTRegion).DHCGetDataByDefaultSession()
        s AuFlag=0
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s CTRGCountryDRAuStr=##class(web.DHCBL.Authorize.CTCountry).DHCGetDataByDefaultSession()
        s CTRGCountryDRAuFlag=0
        if (CTRGCountryDRAuStr="")||(CTRGCountryDRAuStr["limited:0") s CTRGCountryDRAuFlag=1
        s CTRGRowId=0
        for
        {
            s CTRGRowId=$o(^CT("RG",CTRGRowId)) q:CTRGRowId=""
            s CTRGCountryDR=$p($g(^CT("RG",CTRGRowId)),"^",4)
            s strRowId="{ID:"_CTRGRowId_"}"
            s CTRGCountryDRstrRowId="{ID:"_CTRGCountryDR_"}"
            if ((AuStr[strRowId)||(AuFlag=1))&&((CTRGCountryDRAuStr[CTRGCountryDRstrRowId)||(CTRGCountryDRAuFlag=1)) ;用来筛选授权数据
            {
                s CTRGCode=$p($g(^CT("RG",CTRGRowId)),"^",1)
                s CTRGDesc=$p($g(^CT("RG",CTRGRowId)),"^",2)
                s CTRGCode1=$ZCONVERT(CTRGCode,"U")
                s CTRGDesc1=$ZCONVERT(CTRGDesc,"U")
                
                //别名查询
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Region",CTRGRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTRGDesc1)
                i (CTRGCode1[code)&((CTRGDesc1[desc)||(ALIASText1[desc)||(PINYIN[desc))*/
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Region",CTRGRowId,CTRGDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                }  
                if ($ZCONVERT(CTRGCode,"U")[code) &(AliasFlag=1)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTRGRowId,CTRGCode,CTRGDesc)
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

// CTRG_Country_DR->CT_Country

/// Creator:陈莹
/// CreatDate:2012-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.CTRegion
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTRegion).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^CT("RG",0,"Code",code))
    s:desc'="" flagd=$d(^CT("RG",0,"Desc",desc))
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
        s:code'="" idc=$o(^CT("RG",0,"Code",code,0))
        s:desc'="" idd=$o(^CT("RG",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:双击修改时从后台取数据
/// Table:User.CTRegion
/// Input:id
/// Return:Json格式的字符串str={list:[CTRGCode,CTRGDesc,CTRGCountryDR,CTRGRowId]}
/// Other:d ##class(web.DHCBL.CT.CTRegion).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    n (id)
    s str=""
    s pobj = ##class(User.CTRegion).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTRegion).%New()
    s eobj.CTRGRowId = id
    s eobj.CTRGCode = pobj.CTRGCode
    s eobj.CTRGDesc = pobj.CTRGDesc
    if $IsObject(pobj.CTRGCountryDR){
        s eobj.CTRGCountryDR = pobj.CTRGCountryDR.%Id() 
        }
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:增加/修改 区域
/// Table:User.CTRegion
/// Input:web.Entity.CT.CTRegion 实体类
/// Return:成功返回success:'true'和新增或修改的数据的CTRGRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTRegion) As %String
{
    s result=""
    if $IsObject(eobj)
    {
        //前台js已添加空值判断、重复判断
        if (eobj.CTRGRowId="")       
        {
            s obj=##class(User.CTRegion).%New()
        }
        else                           
        {
            s obj=##class(User.CTRegion).%OpenId(eobj.CTRGRowId)
            s bobj = ##class(web.Entity.CT.CTRegion).%New()
            s bobj.CTRGRowId = eobj.CTRGRowId
            s bobj.CTRGCode = obj.CTRGCode
            s bobj.CTRGDesc = obj.CTRGDesc
            if $IsObject(obj.CTRGCountryDR){
                    s bobj.CTRGCountryDR = obj.CTRGCountryDR.%Id() 
                }
        }

        s obj.CTRGCode = eobj.CTRGCode
        s obj.CTRGDesc = eobj.CTRGDesc
        d obj.CTRGCountryDRSetObjectId(eobj.CTRGCountryDR)
        //s obj.CTRGCountryDR=##class(User.CTCountry).%OpenId(eobj.CTRGCountryDR)
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.CTRGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Region","User.CTRegion","区域",id,eobj.CTRGDesc,"A",eobj)
            d:eobj.CTRGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Region","User.CTRegion","区域",id,eobj.CTRGDesc,"U",eobj,bobj)
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("区域","web.DHCBL.CT.CTRegion","SaveEntity",eobj)
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
    
    s PROVRowId=0,flag=0
    for
    {
        s PROVRowId=$o(^CT("PROV",PROVRowId)) q:(PROVRowId="")||(flag=1)
        s PROVRegionDR=$p($g(^CT("PROV",PROVRowId)),"^",3)
        i PROVRegionDR=id
        {
            s flag=1
            s myInfo=myInfo_"<省份>"
        }
    }

    s CTZIPRowId=0,flag=0
    for
    {
        s CTZIPRowId=$o(^CT("ZIP",CTZIPRowId)) q:(CTZIPRowId="")||(flag=1)
        s CTZIPRegionDR=$p($g(^CT("ZIP",CTZIPRowId)),"^",3)
        i CTZIPRegionDR=id
        {
            s flag=1
            s myInfo=myInfo_"<邮编>"
        }
    }
          
    s HCPRowId=0,flag=0
    for
    {
        s HCPRowId=$o(^CT("HCP",HCPRowId))  q:(HCPRowId="")||(flag=1)
        s HCPRegionDR=$p($g(^CT("HCP",HCPRowId)),"^",5)
        i HCPRegionDR=id
        {
            s flag=1
            s myInfo=myInfo_"<合同单位>"
        }
    }
    
    s PAADMRowID=0,flag=0
    for
    {
        s PAADMRowID=$o(^PAADM(PAADMRowID)) q:(PAADMRowID="")||(flag=1)
        s PAADMRegionDR=$p($g(^PAADM(PAADMRowID,1)),"^",3)
        i PAADMRegionDR=id
        {
            s flag=1
            s myInfo=myInfo_"<病人就诊信息>"  //PAAdm
        }
    
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:根据id删除 区域
/// Table:User.CTRegion
/// Input:id(CTRegion的CTRGRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTRegion).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    
    s re=##class(web.DHCBL.CT.CTRegion).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
    s pobj = ##class(User.CTRegion).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTRegion).%New()
    s eobj.CTRGRowId = id
    s eobj.CTRGCode = pobj.CTRGCode
    s eobj.CTRGDesc = pobj.CTRGDesc
    if $IsObject(pobj.CTRGCountryDR){
        s eobj.CTRGCountryDR = pobj.CTRGCountryDR.%Id() 
        }
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTRegion).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Region","User.CTRegion","区域",id,eobj.CTRGDesc,"D",eobj)
    }
    else{
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("区域","web.DHCBL.CT.CTRegion","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
