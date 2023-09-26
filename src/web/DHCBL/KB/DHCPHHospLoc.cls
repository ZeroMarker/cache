Import SQLUser

/// 名称: 科室字典表
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
Class web.DHCBL.KB.DHCPHHospLoc Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCPHHospLoc
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHHospLoc).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHHospLoc).%New()
    s eobj.HOSPLRowId=id
    s eobj.HOSPLCode=$p($g(^DHCPHHLOC(id)),"^",1)
    s eobj.HOSPLDesc=$p($g(^DHCPHHLOC(id)),"^",2)
    s eobj.HOSPLActiveFlag=$p($g(^DHCPHHLOC(id)),"^",3)
    
    s:eobj.HOSPLActiveFlag="" eobj.HOSPLActiveFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHHospLoc
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHHospLoc).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHHospLoc).%New()
    s eobj.HOSPLRowId=id
    s eobj.HOSPLCode=$p($g(^DHCPHHLOC(id)),"^",1)
    s eobj.HOSPLDesc=$p($g(^DHCPHHLOC(id)),"^",2)
    s eobj.HOSPLActiveFlag=$p($g(^DHCPHHLOC(id)),"^",3)
    
    s:eobj.HOSPLActiveFlag="Y" eobj.HOSPLActiveFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHHospLoc
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHHLOC(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHHLOC(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHHLOC(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHHLOC(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存科室字典表的内容
/// Table：User.DHCPHHospLoc
/// Input：web.Entity.KB.DHCPHHospLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHHospLoc).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHHospLoc) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.HOSPLRowId,eobj.HOSPLCode,eobj.HOSPLDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.HOSPLRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHHospLoc).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHHospLoc).%OpenId(eobj.HOSPLRowId)
                s bobj=##class(web.Entity.KB.DHCPHHospLoc).%New()
                s bobj.HOSPLRowId=eobj.HOSPLRowId
                s bobj.HOSPLCode=obj.HOSPLCode
                s bobj.HOSPLDesc = obj.HOSPLDesc          //修改描述
                s bobj.HOSPLActiveFlag = obj.HOSPLActiveFlag 
            }
            Ts
            s obj.HOSPLCode = eobj.HOSPLCode
            s obj.HOSPLDesc = eobj.HOSPLDesc          //修改描述
            s:eobj.HOSPLActiveFlag="" eobj.HOSPLActiveFlag ="N" 
            s obj.HOSPLActiveFlag = eobj.HOSPLActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.HOSPLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLoc","User.DHCPHHospLoc","科室字典表",id,eobj.HOSPLDesc,"A",eobj)
                //修改时，日志
                d:eobj.HOSPLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLoc","User.DHCPHHospLoc","科室字典表",eobj.HOSPLRowId,eobj.HOSPLDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典表","web.DHCBL.KB.DHCPHHospLoc","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典表","web.DHCBL.KB.DHCPHHospLoc","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询科室字典表的内容
/// Table：User.DHCPHHospLoc
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHHospLoc","GetList","","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "HOSPLRowId:%String,HOSPLCode:%String,HOSPLDesc:%String,HOSPLActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHHospLoc).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPLRowId=rowid
        s HOSPLCode=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",1)
        s HOSPLDesc=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",2)
        s HOSPLActiveFlag=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",3)
        s:HOSPLActiveFlag="" HOSPLActiveFlag="Y"
    
        d OutputRow
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s HOSPLRowId=0
        for {
            s HOSPLRowId=$o(^DHCPHHLOC(HOSPLRowId))
            q:HOSPLRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_HOSPLRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s HOSPLCode=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",1)
                s HOSPLDesc=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",2)
                s HOSPLActiveFlag=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",3)
                s:HOSPLActiveFlag="" HOSPLActiveFlag="Y"
                
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPLDesc)
    
                if (($ZCONVERT(HOSPLDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(HOSPLRowId,HOSPLCode,HOSPLDesc,HOSPLActiveFlag)
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
/// Table：User.DHCPHHospLoc
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHHospLoc","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "HOSPLRowId:%String,HOSPLCode:%String,HOSPLDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHHospLoc).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPLRowId=rowid
        s HOSPLCode=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",1)
        s HOSPLDesc=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",2)
        s HOSPLActiveFlag=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",3) 
        s:HOSPLActiveFlag="" HOSPLActiveFlag="Y" 
        d:HOSPLActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s HOSPLRowId=0
        for {
            s HOSPLRowId=$o(^DHCPHHLOC(HOSPLRowId))
            q:HOSPLRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_HOSPLRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s HOSPLCode=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",1)
                s HOSPLDesc=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",2)
                s HOSPLActiveFlag=$p($g(^DHCPHHLOC(HOSPLRowId)),"^",3) 
                s:HOSPLActiveFlag="" HOSPLActiveFlag="Y" 
                continue:HOSPLActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPLDesc)
                if ($ZCONVERT(HOSPLCode,"U")[code)&(($ZCONVERT(HOSPLDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(HOSPLRowId,HOSPLCode,HOSPLDesc)
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
/// w ##class(web.DHCBL.KB.DHCPHHospLoc).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""

    i ($d(^DHCPHHLOCICD(0,"Loc",id)))
    {
        s myInfo=myInfo_"<科室与诊断关联表>"
    }
    
    s flag=0,HOSPLRowId=0
    for
    {
        s HOSPLRowId=$o(^DHCPHHLOCCON(HOSPLRowId)) q:(HOSPLRowId="")||(flag=1)  d
        s HOSPLCode=$p($g(^DHCPHHLOCCON(HOSPLRowId)),"^",1)
        s code=$p($g(^DHCPHHLOC(id)),"^",1)
        i HOSPLCode=code
        {
            s flag=1
            s myInfo=myInfo_"<科室字典对照表>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除科室字典表的内容
/// Table：User.DHCPHHospLoc
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.KB.DHCPHHospLoc).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        //new Entity对象，用于保存日志
        s pobj = ##class(User.DHCPHHospLoc).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHHospLoc).%New()
        s eobj.HOSPLRowId = id
        s eobj.HOSPLCode=pobj.HOSPLCode
        s eobj.HOSPLDesc=pobj.HOSPLDesc
        s eobj.HOSPLActiveFlag=pobj.HOSPLActiveFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHHospLoc).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLoc","User.DHCPHHospLoc","科室字典表",id,eobj.HOSPLDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室字典表","web.DHCBL.KB.DHCPHHospLoc","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
