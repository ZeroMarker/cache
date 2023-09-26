/// 名称:药学-医嘱状态变化原因
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2015-1-12
Class web.DHCBL.CT.OECAdminStatusChReason Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2015-1-12
/// Description:查询 医嘱状态变化原因
/// Table:User.OECAdminStatusChReason
/// Input:rowid,code,desc
/// Return:ASCRRowId,ASCRCode,ASCRDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECAdminStatusChReason","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ASCRRowId:%String,ASCRCode:%String,ASCRDesc:%String,ASCRCancelOperaReason,ASCRPDAExcuteReason,ASCRDateFrom,ASCRDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s ASCRRowId=rowid
        s ASCRCode=$p($g(^OEC("ASCR",ASCRRowId)),"^",1)
        s ASCRDesc=$p($g(^OEC("ASCR",ASCRRowId)),"^",2)
        s ASCRCancelOperaReason=$p($g(^OEC("ASCR",ASCRRowId)),"^",3)
        s ASCRPDAExcuteReason=$p($g(^OEC("ASCR",ASCRRowId)),"^",4)
        s ASCRDateFrom=$p($g(^OEC("ASCR",ASCRRowId)),"^",5)
        s ASCRDateTo=$p($g(^OEC("ASCR",ASCRRowId)),"^",6)
        s:ASCRCancelOperaReason="" ASCRCancelOperaReason="N"
        s:ASCRPDAExcuteReason="" ASCRPDAExcuteReason="N"
        s:ASCRDateFrom ASCRDateFrom=$zd(ASCRDateFrom,1)   
        s:ASCRDateTo ASCRDateTo=$zd(ASCRDateTo,1) 
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_AdminStatusChReason",ASCRRowId)
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
        s AuStr=##class(web.DHCBL.Authorize.OECAdminStatusChReason).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s ASCRRowId=0
        for
        {
            s ASCRRowId=$o(^OEC("ASCR",ASCRRowId)) q:ASCRRowId=""
            s strRowId="{ID:"_ASCRRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s ASCRCode=$p($g(^OEC("ASCR",ASCRRowId)),"^",1)
                s ASCRDesc=$p($g(^OEC("ASCR",ASCRRowId)),"^",2)
                s ASCRCancelOperaReason=$p($g(^OEC("ASCR",ASCRRowId)),"^",3)
                s ASCRPDAExcuteReason=$p($g(^OEC("ASCR",ASCRRowId)),"^",4)
                s ASCRDateFrom=$p($g(^OEC("ASCR",ASCRRowId)),"^",5)
                s ASCRDateTo=$p($g(^OEC("ASCR",ASCRRowId)),"^",6)
                s:ASCRCancelOperaReason="" ASCRCancelOperaReason="N"
                s:ASCRPDAExcuteReason="" ASCRPDAExcuteReason="N"
                s:ASCRDateFrom ASCRDateFrom=$zd(ASCRDateFrom,1)   
                s:ASCRDateTo ASCRDateTo=$zd(ASCRDateTo,1) 
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_AdminStatusChReason",ASCRRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)
                s BDPInternalDesc = $p($g(resultStr),"^",2)
                s BDPHospNationalCode=$p($g(resultStr),"^",3)  
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                if (desc'="")            
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_AdminStatusChReason",ASCRRowId,ASCRDesc,desc)
                }
                else
                {
                    s AliasFlag=1   
                }
                i ($ZCONVERT(ASCRCode,"U")[code)&(AliasFlag=1)
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ASCRRowId,ASCRCode,ASCRDesc,ASCRCancelOperaReason,ASCRPDAExcuteReason,ASCRDateFrom,ASCRDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:User.OECAdminStatusChReason
/// Input:code,desc
/// Return:ASCRRowId,ASCRCode,ASCRDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECAdminStatusChReason","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ASCRRowId:%String,ASCRCode:%String,ASCRDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s ASCRRowId=rowid
        s ASCRCode=$p($g(^OEC("ASCR",ASCRRowId)),"^",1)
        s ASCRDesc=$p($g(^OEC("ASCR",ASCRRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.OECAdminStatusChReason).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s ASCRRowId=0
        for
        {
            s ASCRRowId=$o(^OEC("ASCR",ASCRRowId)) q:ASCRRowId=""
            s strRowId="{ID:"_ASCRRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            { 
                s ASCRDateFrom=$p($g(^OEC("ASCR",ASCRRowId)),"^",5) 
                continue:(ASCRDateFrom'="")&&(ASCRDateFrom>+$h)
                s ASCRDateTo=$p($g(^OEC("ASCR",ASCRRowId)),"^",6)
                continue:(ASCRDateTo'="")&&(ASCRDateTo<+$h)
                s ASCRCode=$p($g(^OEC("ASCR",ASCRRowId)),"^",1)
                s ASCRDesc=$p($g(^OEC("ASCR",ASCRRowId)),"^",2)
                if (desc'="")            
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_AdminStatusChReason",ASCRRowId,ASCRDesc,desc)
                }
                else
                {
                    s AliasFlag=1   
                }
                i ($ZCONVERT(ASCRCode,"U")[code)&(AliasFlag=1)
                {
                    d OutputRowCmb
                }
            }
        }

    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ASCRRowId,ASCRCode,ASCRDesc)
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

/// Creator:陈莹
/// CreatDate:2015-1-12  modified @201702015
/// Description:数据重复验证方法,js调用
/// Table:User.OECAdminStatusChReason
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.OECAdminStatusChReason).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^OEC("ASCR",0,"Code",code))
    s:desc'="" flagd=$d(^OEC("ASCR",0,"Desc",desc))
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
        s:code'="" idc=$o(^OEC("ASCR",0,"Code",code,0))
        s:desc'="" idd=$o(^OEC("ASCR",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
            
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2015-1-12
/// Description:双击修改时从后台取数据
/// Table:User.OECAdminStatusChReason
/// Input:id
/// Return:Json格式的字符串str={list:[ASCRCode,ASCRDesc,ASCRRowId]}
/// Other:d ##class(web.DHCBL.CT.OECAdminStatusChReason).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    new (id)
    s str=""
    s pobj = ##class(User.OECAdminStatusChReason).%OpenId(id)
    s eobj = ##class(web.Entity.CT.OECAdminStatusChReason).%New()
    s eobj.ASCRRowId = id
    s eobj.ASCRCode = pobj.ASCRCode
    s eobj.ASCRDesc = pobj.ASCRDesc
    s eobj.ASCRCancelOperaReason=pobj.ASCRCancelOperaReason
    s:eobj.ASCRCancelOperaReason="Y" eobj.ASCRCancelOperaReason="true"
    s eobj.ASCRPDAExcuteReason=pobj.ASCRPDAExcuteReason
    s:eobj.ASCRPDAExcuteReason="Y" eobj.ASCRPDAExcuteReason="true"
    s:pobj.ASCRDateFrom'="" eobj.ASCRDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASCRDateFrom)
    s:pobj.ASCRDateTo'="" eobj.ASCRDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASCRDateTo)
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2015-1-12
/// Description:增加/修改 医嘱状态变化原因
/// Table:User.OECAdminStatusChReason
/// Input:web.Entity.CT.OECAdminStatusChReason 实体类
/// Return:成功返回success:'true'和新增或修改的数据的ASCRRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.OECAdminStatusChReason) As %String
{
    new (eobj,%session)
    s result=""
    if $IsObject(eobj)
    {
        //前台js已添加空值判断、重复判断
        s flag=..FormValidate(eobj.ASCRRowId,eobj.ASCRCode,eobj.ASCRDesc)
        if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
        if (eobj.ASCRRowId="")       
        {
            s obj=##class(User.OECAdminStatusChReason).%New()
        }
        else                           
        {
            s obj=##class(User.OECAdminStatusChReason).%OpenId(eobj.ASCRRowId)
            s bobj=##class(web.Entity.CT.OECAdminStatusChReason).%New()
            s bobj.ASCRRowId = eobj.ASCRRowId
            s bobj.ASCRCode = obj.ASCRCode
            s bobj.ASCRDesc = obj.ASCRDesc
            s bobj.ASCRCancelOperaReason=obj.ASCRCancelOperaReason 
            s bobj.ASCRPDAExcuteReason=obj.ASCRPDAExcuteReason 
            s bobj.ASCRDateFrom =obj.ASCRDateFrom
            s bobj.ASCRDateTo=obj.ASCRDateTo 
        }
        s:eobj.ASCRDateFrom'="" eobj.ASCRDateFrom =##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASCRDateFrom)
        s:eobj.ASCRDateTo'="" eobj.ASCRDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASCRDateTo)
        s:eobj.ASCRCancelOperaReason="" eobj.ASCRCancelOperaReason="N"
        s:eobj.ASCRPDAExcuteReason="" eobj.ASCRPDAExcuteReason="N"
        s obj.ASCRCode = eobj.ASCRCode
        s obj.ASCRDesc = eobj.ASCRDesc
        s obj.ASCRCancelOperaReason=eobj.ASCRCancelOperaReason 
        s obj.ASCRPDAExcuteReason=eobj.ASCRPDAExcuteReason 
        s obj.ASCRDateFrom =eobj.ASCRDateFrom
        s obj.ASCRDateTo=eobj.ASCRDateTo
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.ASCRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_AdminStatusChReason","User.OECAdminStatusChReason","医嘱状态变化原因",id,eobj.ASCRDesc,"A",eobj)
            d:eobj.ASCRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_AdminStatusChReason","User.OECAdminStatusChReason","医嘱状态变化原因",id,eobj.ASCRDesc,"U",eobj,bobj)
        }else{
            Trollback
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱状态变化原因","web.DHCBL.CT.OECAdminStatusChReason","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        }             
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator:陈莹
/// CreatDate:2015-1-12
/// Description:根据id删除 医嘱状态变化原因
/// Table:User.OECAdminStatusChReason
/// Input:id(OECAdminStatusChReason的ASCRRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.OECAdminStatusChReason).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    n (id,%session)
    s result=""
    s pobj = ##class(User.OECAdminStatusChReason).%OpenId(id)
    s eobj = ##class(web.Entity.CT.OECAdminStatusChReason).%New()
    s eobj.ASCRRowId = id
    s eobj.ASCRCode = pobj.ASCRCode
    s eobj.ASCRDesc = pobj.ASCRDesc
    s eobj.ASCRCancelOperaReason=pobj.ASCRCancelOperaReason 
    s eobj.ASCRPDAExcuteReason=pobj.ASCRPDAExcuteReason 
    s eobj.ASCRDateFrom =pobj.ASCRDateFrom
    s eobj.ASCRDateTo=pobj.ASCRDateTo
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.OECAdminStatusChReason).%DeleteId(id)
    if $$$ISOK(sc){
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_AdminStatusChReason","User.OECAdminStatusChReason","医嘱状态变化原因",id,eobj.ASCRDesc,"D",eobj)
    }
    else{
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱状态变化原因","web.DHCBL.CT.OECAdminStatusChReason","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }
    q result
}

}
