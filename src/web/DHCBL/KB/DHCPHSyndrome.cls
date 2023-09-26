Import SQLUser

/// 名称: 证型字典表
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-8-22
Class web.DHCBL.KB.DHCPHSyndrome Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCPHSyndrome
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHSyndrome).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHSyndrome).%New()
    s eobj.DRORowId=id
    s eobj.DROCode=$p($g(^DHCPHSYDRO(id)),"^",1)
    s eobj.DRODesc=$p($g(^DHCPHSYDRO(id)),"^",2)
    s eobj.DROActiveFlag=$p($g(^DHCPHSYDRO(id)),"^",3)
    
    s:eobj.DROActiveFlag="" eobj.DROActiveFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHSyndrome
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHSyndrome).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHSyndrome).%New()
    s eobj.DRORowId=id
    s eobj.DROCode=$p($g(^DHCPHSYDRO(id)),"^",1)
    s eobj.DRODesc=$p($g(^DHCPHSYDRO(id)),"^",2)
    s eobj.DROActiveFlag=$p($g(^DHCPHSYDRO(id)),"^",3)
    
    s:eobj.DROActiveFlag="Y" eobj.DROActiveFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHSyndrome
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHSYDRO(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHSYDRO(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHSYDRO(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHSYDRO(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存证型字典表的内容
/// Table：User.DHCPHSyndrome
/// Input：web.Entity.KB.DHCPHSyndrome 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHSyndrome).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHSyndrome) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.DRORowId,eobj.DROCode,eobj.DRODesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.DRORowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHSyndrome).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHSyndrome).%OpenId(eobj.DRORowId)
                s bobj=##class(web.Entity.KB.DHCPHSyndrome).%New()
                s bobj.DRORowId=eobj.DRORowId
                s bobj.DROCode=obj.DROCode
                s bobj.DRODesc = obj.DRODesc          //修改描述
                s bobj.DROActiveFlag = obj.DROActiveFlag 
            }
            Ts
            s obj.DROCode = eobj.DROCode
            s obj.DRODesc = eobj.DRODesc          //修改描述
            s:eobj.DROActiveFlag="" eobj.DROActiveFlag ="N" 
            s obj.DROActiveFlag = eobj.DROActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.DRORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndrome","User.DHCPHSyndrome","证型字典表",id,eobj.DRODesc,"A",eobj)
                //修改时，日志
                d:eobj.DRORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndrome","User.DHCPHSyndrome","证型字典表",eobj.DRORowId,eobj.DRODesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典表","web.DHCBL.KB.DHCPHSyndrome","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典表","web.DHCBL.KB.DHCPHSyndrome","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询证型字典表的内容
/// Table：User.DHCPHSyndrome
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndrome","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DRORowId:%String,DROCode:%String,DRODesc:%String,DROActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHSyndrome).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s DRORowId=rowid
        s DROCode=$p($g(^DHCPHSYDRO(DRORowId)),"^",1)
        s DRODesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
        s DROActiveFlag=$p($g(^DHCPHSYDRO(DRORowId)),"^",3)
        s:DROActiveFlag="" DROActiveFlag="Y"
    
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s DRORowId=0
        for {
            s DRORowId=$o(^DHCPHSYDRO(DRORowId))
            q:DRORowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_DRORowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s DROCode=$p($g(^DHCPHSYDRO(DRORowId)),"^",1)
                s DRODesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
                s DROActiveFlag=$p($g(^DHCPHSYDRO(DRORowId)),"^",3)
                s:DROActiveFlag="" DROActiveFlag="Y"
                
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DRODesc)
    
                if ($ZCONVERT(DROCode,"U")[code)&(($ZCONVERT(DRODesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(DRORowId,DROCode,DRODesc,DROActiveFlag)
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
/// Table：User.DHCPHSyndrome
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSyndrome","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DRORowId:%String,DROCode:%String,DRODesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHSyndrome).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s DRORowId=rowid
        s DROCode=$p($g(^DHCPHSYDRO(DRORowId)),"^",1)
        s DRODesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
        s DROActiveFlag=$p($g(^DHCPHSYDRO(DRORowId)),"^",3) 
        s:DROActiveFlag="" DROActiveFlag="Y"
        
        d:DROActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s DRORowId=0
        for {
            s DRORowId=$o(^DHCPHSYDRO(DRORowId))
            q:DRORowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_DRORowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s DROCode=$p($g(^DHCPHSYDRO(DRORowId)),"^",1)
                s DRODesc=$p($g(^DHCPHSYDRO(DRORowId)),"^",2)
                s DROActiveFlag=$p($g(^DHCPHSYDRO(DRORowId)),"^",3)
                s:DROActiveFlag="" DROActiveFlag="Y"
                 
                continue:DROActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DRODesc)
                if ($ZCONVERT(DROCode,"U")[code)&(($ZCONVERT(DRODesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(DRORowId,DROCode,DRODesc)
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

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHSyndrome).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""

    i ($d(^DHCPHSYNICD(0,"SYN",id)))
    {
        s myInfo=myInfo_"<诊断与证型关联表>"
    }
    
    s flag=0,DRORowId=0
    for
    {
        s DRORowId=$o(^DHCPHSYNCON(DRORowId)) q:(DRORowId="")||(flag=1)  d
        s DROCode=$p($g(^DHCPHSYNCON(DRORowId)),"^",1)
        s code=$p($g(^DHCPHSYDRO(id)),"^",1)
        i DROCode=code
        {
            s flag=1
            s myInfo=myInfo_"<证型字典对照表>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除证型字典表的内容
/// Table：User.DHCPHSyndrome
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.KB.DHCPHSyndrome).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        //new Entity对象，用于保存日志
        s pobj = ##class(User.DHCPHSyndrome).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHSyndrome).%New()
        s eobj.DRORowId = id
        s eobj.DROCode=pobj.DROCode
        s eobj.DRODesc=pobj.DRODesc
        s eobj.DROActiveFlag=pobj.DROActiveFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHSyndrome).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSyndrome","User.DHCPHSyndrome","证型字典表",id,eobj.DRODesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("证型字典表","web.DHCBL.KB.DHCPHSyndrome","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
