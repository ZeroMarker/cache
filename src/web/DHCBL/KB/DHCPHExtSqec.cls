Class web.DHCBL.KB.DHCPHExtSqec Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2017-07-25
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtSqec).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtSqec).%New()
    s pobj = ##class(User.DHCPHExtSqec).%OpenId(id)
    s eobj.PHSRowId = id
    s eobj.PHSCode = pobj.PHSCode
    s eobj.PHSDesc = pobj.PHSDesc
    s eobj.PHSActiveFlag = pobj.PHSActiveFlag
    s eobj.PHSSysFlag = pobj.PHSSysFlag
    s:pobj.PHSActiveFlag="" eobj.PHSActiveFlag="Y"
    s:pobj.PHSSysFlag="" eobj.PHSSysFlag="Y"    

    s str = eobj.JsonS()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate: 2016-9-30
/// Description：查询药品规格字典表内容
/// Table：User.DHCPHExtSqec
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtSqec","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHSRowId,PHSCode,PHSDesc,PHSActiveFlag,PHSSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtSqec).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHSRowId=rowid 
        s PHSCode=$p($g(^DHCPHESQE(PHSRowId)),"^",1)  //代码
        s PHSDesc=$p($g(^DHCPHESQE(PHSRowId)),"^",2)  //描述
        s PHSActiveFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",3)  //是否可用
        s PHSSysFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",4)  //是否系统标识
        s:PHSActiveFlag="" PHSActiveFlag="Y"
        s:PHSSysFlag="" PHSSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHSRowId=0
        for  
        {   
            s PHSRowId=$o(^DHCPHESQE(PHSRowId)) q:PHSRowId="" 
            s strRowId = "{ID:"_PHSRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHSCode=$p($g(^DHCPHESQE(PHSRowId)),"^",1)  //代码
                s PHSCodeU=$ZCONVERT(PHSCode,"U")
                s PHSDesc=$p($g(^DHCPHESQE(PHSRowId)),"^",2)  //描述
                s PHSDescU=$ZCONVERT(PHSDesc,"U")
                s PHSActiveFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",3)  //是否可用
                s PHSSysFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",4)  //是否系统标识
                s:PHSActiveFlag="" PHSActiveFlag="Y"
        		s:PHSSysFlag="" PHSSysFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHSDescU))
                i (PHSCodeU[code)&((PHSDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHSRowId,PHSCode,PHSDesc,PHSActiveFlag,PHSSysFlag)
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

/// Creator:谷雪萍
/// CreatDate:2014-12-4
/// Description:查询 单位
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtSqec","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHSRowId:%String,PHSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHSRowId=rowid
        s PHSDesc=$p($g(^DHCPHESQE(PHSRowId)),"^",2)
        s PHSActiveFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",3)  //是否可用
        d:PHSActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHExtSqec).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHSRowId=0
        for
        {
            s PHSRowId=$o(^DHCPHESQE(PHSRowId)) q:PHSRowId=""
            s strRowId="{ID:"_PHSRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHSActiveFlag=$p($g(^DHCPHESQE(PHSRowId)),"^",3)  //是否可用
                continue:PHSActiveFlag="N"
                s PHSDesc=$p($g(^DHCPHESQE(PHSRowId)),"^",2)
                s PHSDesc1=$ZCONVERT(PHSDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHSDesc1))
                i (PHSDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHSRowId,PHSDesc)
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
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2016-9-30    
/// w ##class(web.DHCBL.KB.DHCPHExtSqec).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHESQE(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHESQE(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHESQE(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHESQE(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2016-9-30
/// Description：保存修改内容
/// Table：User.DHCPHExtSqec
/// Input：web.Entity.KB.DHCPHExtSqec 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtSqec) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHSRowId,eobj.PHSCode,eobj.PHSDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHSRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtSqec).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtSqec).%OpenId(eobj.PHSRowId)
                
                s re=##class(web.DHCBL.KB.DHCPHExtSqec).GetRefFlag(eobj.PHSRowId)
                s RefFlag=$p(re,"^",1)
                s str=$p(re,"^",2)
                if (RefFlag=1)&(str["<规格与His对照>"){
                    s result = "{success:'false',errorinfo:'在规格与His对照中被引用，不能修改!'}"  //返回错误信息
                    q result
                }
                
                s bobj = ##class(web.Entity.KB.DHCPHExtSqec).%New()
                s bobj.PHSRowId = eobj.PHSRowId
                s bobj.PHSCode = obj.PHSCode
                s bobj.PHSDesc = obj.PHSDesc
                s bobj.PHSActiveFlag= obj.PHSActiveFlag
                s bobj.PHSSysFlag = obj.PHSSysFlag
            }
    
            s obj.PHSCode = eobj.PHSCode
            s obj.PHSDesc = eobj.PHSDesc
            i eobj.PHSActiveFlag="Y"
            {
                s obj.PHSActiveFlag = "Y"
            }
            else
            {
                s obj.PHSActiveFlag = "N"
            }
            i eobj.PHSSysFlag="Y"
            {
                s obj.PHSSysFlag = "Y"
            }
            else
            {
                s obj.PHSSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtSqec","User.DHCPHExtSqec","药品规格字典",id,eobj.PHSDesc,"A",eobj)
                d:eobj.PHSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtSqec","User.DHCPHExtSqec","药品规格字典",eobj.PHSRowId,eobj.PHSDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品规格字典","web.DHCBL.KB.DHCPHExtSqec","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：谷雪萍
/// CreatDate: 2016-9-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtSqec).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtSqec).%New()
    s pobj = ##class(User.DHCPHExtSqec).%OpenId(id)
    s eobj.PHSRowId = id
    s eobj.PHSCode = pobj.PHSCode
    s eobj.PHSDesc = pobj.PHSDesc
    s:pobj.PHSActiveFlag="Y" eobj.PHSActiveFlag="true"
    s:pobj.PHSSysFlag="Y" eobj.PHSSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHExtSqec).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    s flag=0
    s PHSCode=$p($g(^DHCPHESQE(id)),"^",1) 
    s PHSCRowId=0
    for  
    {   
        s PHSCRowId=$o(^DHCPHSCO(PHSCRowId)) q:PHSCRowId=""||(flag=1)  d 
        s PHUCTCode=$p($g(^DHCPHSCO(PHSCRowId)),"^",1)  //his代码
        i (PHUCTCode=PHSCode){
            s flag=1
            s myInfo=myInfo_"<规格与His对照>"    
        }   
    }
    

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2016-9-30
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtSqec).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHExtSqec).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtSqec).%New()
        s pobj = ##class(User.DHCPHExtSqec).%OpenId(id)
        s eobj.PHSRowId = id
        s eobj.PHSCode = pobj.PHSCode
        s eobj.PHSDesc = pobj.PHSDesc
        s eobj.PHSActiveFlag = pobj.PHSActiveFlag
        s eobj.PHSSysFlag = pobj.PHSSysFlag
    
        s sc=##class(User.DHCPHExtSqec).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtSqec","User.DHCPHExtSqec","药品规格字典",id,eobj.PHSDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品规格字典","web.DHCBL.KB.DHCPHExtSqec","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

}
