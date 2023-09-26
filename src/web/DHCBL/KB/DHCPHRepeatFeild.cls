Class web.DHCBL.KB.DHCPHRepeatFeild Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2017-3-15
/// Description：查询重复用药规则字典表内容
/// Table：User.DHCPHRepeatFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHRepeatFeild","GetList","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHRFRowId,PHRFCode,PHRFDesc,PHRFActiveFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHRepeatFeild).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHRFRowId=rowid
        s PHRFCode=$p($g(^DHCPHRFE(PHRFRowId)),"^",1)  //代码
        s PHRFDesc=$p($g(^DHCPHRFE(PHRFRowId)),"^",2)  //描述
        s PHRFActiveFlag=$p($g(^DHCPHRFE(PHRFRowId)),"^",3)  //是否可用
        s:PHRFActiveFlag="" PHRFActiveFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHRFRowId=0
        for  
        {   
            s PHRFRowId=$o(^DHCPHRFE(PHRFRowId)) q:PHRFRowId="" 
            s strRowId = "{ID:"_PHRFRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHRFCode=$p($g(^DHCPHRFE(PHRFRowId)),"^",1)  //代码
                s PHRFCodeU=$ZCONVERT(PHRFCode,"U")
                s PHRFDesc=$p($g(^DHCPHRFE(PHRFRowId)),"^",2)  //描述
                s PHRFDescU=$ZCONVERT(PHRFDesc,"U")
                s PHRFActiveFlag=$p($g(^DHCPHRFE(PHRFRowId)),"^",3)  //是否可用
                s:PHRFActiveFlag="" PHRFActiveFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHRFDescU))
                i (PHRFCodeU[code)&((PHRFDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHRFRowId,PHRFCode,PHRFDesc,PHRFActiveFlag)
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

/// Creator:高姗姗
/// CreatDate:2017-3-15
/// Description:查询 指针重复用药规则 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHRepeatFeild","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHRFRowId:%String,PHRFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHRFRowId=rowid
        s PHRFDesc=$p($g(^DHCPHRFE(PHRFRowId)),"^",2)
        s PHRFActiveFlag=$p($g(^DHCPHRFE(PHRFRowId)),"^",3)  //是否可用
        d:PHRFActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHRepeatFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHRFRowId=0
        for
        {
            s PHRFRowId=$o(^DHCPHRFE(PHRFRowId)) q:PHRFRowId=""
            s strRowId="{ID:"_PHRFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHRFDesc=$p($g(^DHCPHRFE(PHRFRowId)),"^",2)
                s PHRFActiveFlag=$p($g(^DHCPHRFE(PHRFRowId)),"^",3)  //是否可用
                continue:PHRFActiveFlag="N"
                s PHRFDesc1=$ZCONVERT(PHRFDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHRFDesc1))
                i (PHRFDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHRFRowId,PHRFDesc)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2017-3-15    
/// w ##class(web.DHCBL.KB.DHCPHRepeatFeild).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHRFEi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHRFEi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHRFEi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHRFEi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2017-3-15
/// Description：保存修改内容
/// Table：User.DHCPHRepeatFeild
/// Input：web.Entity.KB.DHCPHRepeatFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHRepeatFeild) As %String
{
    s result = ""
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.PHRFRowId,eobj.PHRFCode,eobj.PHRFDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHRFRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHRepeatFeild).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHRepeatFeild).%OpenId(eobj.PHRFRowId)
                
                s bobj = ##class(web.Entity.KB.DHCPHRepeatFeild).%New()
                s bobj.PHRFRowId = eobj.PHRFRowId
                s bobj.PHRFCode = obj.PHRFCode
                s bobj.PHRFDesc = obj.PHRFDesc
                s bobj.PHRFActiveFlag= obj.PHRFActiveFlag
            }
    
            s obj.PHRFCode = eobj.PHRFCode
            s obj.PHRFDesc = eobj.PHRFDesc
            i eobj.PHRFActiveFlag="Y"
            {
                s obj.PHRFActiveFlag = "Y"
            }
            else
            {
                s obj.PHRFActiveFlag = "N"
            }
        
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHRFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHRepeatFeild","User.DHCPHRepeatFeild","重复用药规则字典",id,eobj.PHRFDesc,"A",eobj)
                d:eobj.PHRFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHRepeatFeild","User.DHCPHRepeatFeild","重复用药规则字典",eobj.PHRFRowId,eobj.PHRFDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("重复用药规则字典","web.DHCBL.KB.DHCPHRepeatFeild","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            }
        }   
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：高姗姗
/// CreatDate: 2017-3-15
/// Description：获取修改时的记录
/// Table：User.DHCPHRepeatFeild
/// Other: d ##class(web.DHCBL.KB.DHCPHRepeatFeild).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHRepeatFeild).%New()
    s pobj = ##class(User.DHCPHRepeatFeild).%OpenId(id)
    s eobj.PHRFRowId = id
    s eobj.PHRFCode = pobj.PHRFCode
    s eobj.PHRFDesc = pobj.PHRFDesc
    s:pobj.PHRFActiveFlag="Y" eobj.PHRFActiveFlag="true"

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-09
/// Description：获取修改时的记录
/// Table：User.DHCPHRepeatFeild
/// Other: d ##class(web.DHCBL.KB.DHCPHRepeatFeild).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHRepeatFeild).%New()
    s pobj = ##class(User.DHCPHRepeatFeild).%OpenId(id)
    s eobj.PHRFRowId = id
    s eobj.PHRFCode = pobj.PHRFCode
    s eobj.PHRFDesc = pobj.PHRFDesc
    s eobj.PHRFActiveFlag=pobj.PHRFActiveFlag
    s:pobj.PHRFActiveFlag="" eobj.PHRFActiveFlag="Y"

    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHRepeatFeild).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    ;User.DHCPHRepeatItm
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHRITM(RowId)) q:(RowId="")||(flag=1)  d
        s RuleDr=$p($g(^DHCPHRITM(RowId)),"^",3)
        i RuleDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-重复用药>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2017-3-15
/// Description:根据id删除
/// Table:User.DHCPHRepeatFeild
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHRepeatFeild).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHRepeatFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHRepeatFeild).%New()
        s pobj = ##class(User.DHCPHRepeatFeild).%OpenId(id)
        s eobj.PHRFRowId = id
        s eobj.PHRFCode = pobj.PHRFCode
        s eobj.PHRFDesc = pobj.PHRFDesc
        s eobj.PHRFActiveFlag = pobj.PHRFActiveFlag
    
        s sc=##class(User.DHCPHRepeatFeild).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHRepeatFeild","User.DHCPHRepeatFeild","重复用药规则字典",id,eobj.PHRFDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("重复用药规则字典","web.DHCBL.KB.DHCPHRepeatFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
