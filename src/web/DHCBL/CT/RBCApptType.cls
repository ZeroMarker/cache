/// Function:预约渠道
/// CreateDate:2021-11-15
/// Creator:sunfengchao
Class web.DHCBL.CT.RBCApptType Extends %RegisteredObject
{

/// Description:查询预约渠道的内容
/// Creator:    sunfengchao
/// CreatDate:  2021-11-15 
/// Table：     RBC_ApptType 
/// Input：     rowid,code,desc
/// Return:  
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCApptType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ATRowId:%String,ATCode:%String,ATDesc:%String,ATDateFrom:%String,ATDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ATRowId=rowid
        s ATCode=$p($g(^RBC("AT",ATRowId)),"^",1)
        s ATDesc=$p($g(^RBC("AT",ATRowId)),"^",2) 
        s ATDateFrom=$p($g(^RBC("AT",ATRowId)),"^",4)
        s ATDateTo=$p($g(^RBC("AT",ATRowId)),"^",5)
        s:ATDateFrom'="" ATDateFrom=$zd(ATDateFrom,3)   
        s:ATDateTo'="" ATDateTo=$zd(ATDateTo,3)  
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s ATRowId=0
        for 
        {
            s ATRowId=$o(^RBC("AT",ATRowId))
            q:ATRowId="" 
            s ATCode=$p($g(^RBC("AT",ATRowId)),"^",1)
            s ATDesc=$p($g(^RBC("AT",ATRowId)),"^",2) 
            if (desc'="")  // ;需要对描述或者别名进行检索   
            { 
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ApptType",ATRowId,ATDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }   
            if ($ZCONVERT(ATCode,"U")[code)&(AliasFlag=1) 
            {
                s ATDateFrom=$p($g(^RBC("AT",ATRowId)),"^",4)
                s ATDateTo=$p($g(^RBC("AT",ATRowId)),"^",5)
                s:ATDateFrom'="" ATDateFrom=$zd(ATDateFrom,3)   
                s:ATDateTo'="" ATDateTo=$zd(ATDateTo,3) 
                d OutputRow
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ATRowId,ATCode,ATDesc,ATDateFrom,ATDateTo)
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

/// Description:为combobox查询取数据
/// Creator:    sunfengchao
/// CreatDate:  2021-11-15 
/// Table：     RBC_ApptType 
/// Input：     rowid,code,desc 
/// Return:     ATRowId:ATCode:ATDesc:
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCApptType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ATRowId:%String,ATCode:%String,ATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ATRowId=rowid
        s ATCode=$p($g(^RBC("AT",ATRowId)),"^",1)
        s ATDesc=$p($g(^RBC("AT",ATRowId)),"^",2) 
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
         s ATRowId=0
        for 
        {
            s ATRowId=$o(^RBC("AT",ATRowId))
            q:ATRowId=""
            s ATDateFrom=$p($g(^RBC("AT",ATRowId)),"^",4)
            continue:(ATDateFrom'="")&&(ATDateFrom>+$h)
            s ATDateTo=$p($g(^RBC("AT",ATRowId)),"^",5)
            continue:(ATDateTo'="")&&(ATDateTo<+$h) 
            s ATCode=$p($g(^RBC("AT",ATRowId)),"^",1)
            s ATDesc=$p($g(^RBC("AT",ATRowId)),"^",2) 
            if (desc'="")  // ;需要对描述或者别名进行检索   
            { 
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_ApptType",ATRowId,ATDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }   
            if ($ZCONVERT(ATCode,"U")[code)&(AliasFlag=1)
            {
                d OutputRowCmb
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ATRowId,ATCode,ATDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Description：修改时打开的数据
/// Creator:    sunfengchao
/// CreatDate:  2021-11-15 
/// Table：     RBC_ApptType 
/// Input：     rowid,code,desc 
/// Input：     id 
/// Return:     Json格式的字符串{"ATCode":"PUBLIC","ATDesc":"公共","ATRowId":"9"}
/// Other:      w ##class(web.DHCBL.CT.RBCApptType).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.RBCApptType).%New()
    s obj = ##class(User.RBCApptType).%OpenId(id)
    s eobj.ATRowId=id
    s eobj.ATCode= obj.ATCode
    s eobj.ATDesc= obj.ATDesc  
    s:obj.ATDateFrom'="" eobj.ATDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.ATDateFrom)
    s:obj.ATDateTo'="" eobj.ATDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.ATDateTo) 
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除预约渠道的内容
/// Table：User.RBCApptType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.RBCApptType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(User.RBCApptType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.RBCApptType).%New()
    s eobj.ATRowId = id
    s eobj.ATCode=pobj.ATCode
    s eobj.ATDesc=pobj.ATDesc 
    s eobj.ATDateFrom = pobj.ATDateFrom
    s eobj.ATDateTo=pobj.ATDateTo
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.RBCApptType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ApptType","User.RBCApptType","预约渠道",id,eobj.ATDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约渠道","web.DHCBL.CT.RBCApptType","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：数据重复验证方法，由js调用
/// Table：User.RBCApptType
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.RBCApptType).FormValidate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^RBC("AT",0,"Code",code))
    s:desc'="" flagd=$d(^RBC("AT",0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^RBC("AT",0,"Code",code,0))
        s:desc'="" idd=$o(^RBC("AT",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:    sunfengchao
/// CreatDate:  2018-03-15
/// Description 保存内容
/// Table：     User.RBCApptType
/// Input：     web.Entity.CT.RBCApptType 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.RBCApptType).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.RBCApptType) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.ATRowId,eobj.ATCode,eobj.ATDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if eobj.ATDateFrom'="" s eobj.ATDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ATDateFrom)   
            if eobj.ATDateTo'="" s eobj.ATDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ATDateTo)      
  
            if (eobj.ATRowId="")   
            {
                s obj=##class(User.RBCApptType).%New()
            }
            else                   
            {
                s obj=##class(User.RBCApptType).%OpenId(eobj.ATRowId)
                s bobj=##class(web.Entity.CT.RBCApptType).%New()
                s bobj.ATRowId=eobj.ATRowId
                s bobj.ATCode=obj.ATCode
                s bobj.ATDesc = obj.ATDesc 
                s bobj.ATDateFrom=obj.ATDateFrom
                s bobj.ATDateTo=obj.ATDateTo        
            }
            Ts
            s obj.ATCode = eobj.ATCode
            s obj.ATDesc = eobj.ATDesc 
            s obj.ATDateFrom=eobj.ATDateFrom
            s obj.ATDateTo=eobj.ATDateTo             
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"   
                d:eobj.ATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ApptType","User.RBCApptType","预约渠道",id,eobj.ATDesc,"A",eobj) 
                d:eobj.ATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_ApptType","User.RBCApptType","预约渠道",eobj.ATRowId,eobj.ATDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约渠道","web.DHCBL.CT.RBCApptType","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
            }
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("预约渠道","web.DHCBL.CT.RBCApptType","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
