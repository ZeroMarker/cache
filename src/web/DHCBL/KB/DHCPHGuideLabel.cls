/// 指南目录
/// 描述: 增删改查方法类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-13
Class web.DHCBL.KB.DHCPHGuideLabel Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：石萧伟
/// CreatDate: 2017-07-25
/// Description：获取修改时的记录
/// Table：User.DHCPHGuideLabel
/// Other: d ##class(web.DHCBL.KB.DHCPHGuideLabel).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    n (id)
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHGuideLabel).%New()
    s pobj = ##class(User.DHCPHGuideLabel).%OpenId(id)
    s eobj.PGLRowId = id
    s eobj.PGLCode = pobj.PGLCode
    s eobj.PGLDesc = pobj.PGLDesc
    s eobj.PGLActiveFlag =pobj.PGLActiveFlag
    s eobj.PGLSysFlag=pobj.PGLSysFlag
    s:pobj.PGLActiveFlag="" eobj.PGLActiveFlag="Y"
    s:pobj.PGLSysFlag="" eobj.PGLSysFlag="Y"    

    s str = eobj.JsonS()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate:2017-4-13
/// Description：查询指南目录表内容
/// Table：User.DHCPHGuideLabel
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHGuideLabel","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PGLRowId,PGLCode,PGLDesc,PGLActiveFlag,PGLSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHGuideLabel).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PGLRowId=rowid 
        s PGLCode=$p($g(^DHCPHGULA(PGLRowId)),"^",1)  //代码
        s PGLDesc=$p($g(^DHCPHGULA(PGLRowId)),"^",2)  //描述
        s PGLActiveFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",3)  //是否可用
        s PGLSysFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",4)  //是否系统标识
        s:PGLActiveFlag="" PGLActiveFlag="Y"
        s:PGLSysFlag="" PGLSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PGLRowId=0
        for  
        {   
            s PGLRowId=$o(^DHCPHGULA(PGLRowId)) q:PGLRowId="" 
            s strRowId = "{ID:"_PGLRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PGLCode=$p($g(^DHCPHGULA(PGLRowId)),"^",1)  //代码
                s PGLCodeU=$ZCONVERT(PGLCode,"U")
                s PGLDesc=$p($g(^DHCPHGULA(PGLRowId)),"^",2)  //描述
                s PGLDescU=$ZCONVERT(PGLDesc,"U")
                s PGLActiveFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",3)  //是否可用
                s PGLSysFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",4)  //是否系统标识
                s:PGLActiveFlag="" PGLActiveFlag="Y"
        		s:PGLSysFlag="" PGLSysFlag="Y"
        
                
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PGLDescU)
                i (PGLCodeU[code)&((PGLDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PGLRowId,PGLCode,PGLDesc,PGLActiveFlag,PGLSysFlag)
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
/// CreatDate:2017-04-13
/// Description:查询 2017-4-13
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHGuideLabel","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PGLRowId:%String,PGLDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PGLRowId=rowid
        s PGLDesc=$p($g(^DHCPHGULA(PGLRowId)),"^",2)
        s PGLActiveFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",3)  //是否可用
        d:PGLActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHGuideLabel).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PGLRowId=0
        for
        {
            s PGLRowId=$o(^DHCPHGULA(PGLRowId)) q:PGLRowId=""
            s strRowId="{ID:"_PGLRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PGLActiveFlag=$p($g(^DHCPHGULA(PGLRowId)),"^",3)  //是否可用
                continue:PGLActiveFlag="N"
                s PGLDesc=$p($g(^DHCPHGULA(PGLRowId)),"^",2)
                s PGLDesc1=$ZCONVERT(PGLDesc,"U")
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PGLDesc1)
                i (PGLDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PGLRowId,PGLDesc)
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
/// CreateDate:2017-4-13
/// w ##class(web.DHCBL.KB.DHCPHGuideLabel).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    n (code,desc,id)
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHGULAi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHGULAi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHGULAi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHGULAi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-13
/// Description：保存修改内容
/// Table：User.DHCPHGuideLabel
/// Input：web.Entity.KB.DHCPHGuideLabel 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHGuideLabel) As %String
{
    n (eobj,%session)
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PGLRowId,eobj.PGLCode,eobj.PGLDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PGLRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHGuideLabel).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHGuideLabel).%OpenId(eobj.PGLRowId)
                
                s bobj = ##class(web.Entity.KB.DHCPHGuideLabel).%New()
                s bobj.PGLRowId = eobj.PGLRowId
                s bobj.PGLCode = obj.PGLCode
                s bobj.PGLDesc = obj.PGLDesc
                s bobj.PGLActiveFlag= obj.PGLActiveFlag
                s bobj.PGLSysFlag = obj.PGLSysFlag
            }
    
            s obj.PGLCode = eobj.PGLCode
            s obj.PGLDesc = eobj.PGLDesc
            i eobj.PGLActiveFlag="Y"
            {
                s obj.PGLActiveFlag = "Y"
            }
            else
            {
                s obj.PGLActiveFlag = "N"
            }
            i eobj.PGLSysFlag="Y"
            {
                s obj.PGLSysFlag = "Y"
            }
            else
            {
                s obj.PGLSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PGLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHGuideLabel","User.DHCPHGuideLabel","指南目录",id,eobj.PGLDesc,"A",eobj)
                d:eobj.PGLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHGuideLabel","User.DHCPHGuideLabel","指南目录",eobj.PGLRowId,eobj.PGLDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("指南目录","web.DHCBL.KB.DHCPHGuideLabel","SaveData",eobj)
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
/// CreatDate: 2017-04-13
/// Description：获取修改时的记录
/// Table：User.DHCPHGuideLabel
/// Other: d ##class(web.DHCBL.KB.DHCPHGuideLabel).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    n (id)
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHGuideLabel).%New()
    s pobj = ##class(User.DHCPHGuideLabel).%OpenId(id)
    s eobj.PGLRowId = id
    s eobj.PGLCode = pobj.PGLCode
    s eobj.PGLDesc = pobj.PGLDesc
    s:pobj.PGLActiveFlag="Y" eobj.PGLActiveFlag="true"
    s:pobj.PGLSysFlag="Y" eobj.PGLSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHGuideLabel).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    n (id)
    s return="", myInfo=""
    
    s flag=0
    s PGLCode=$p($g(^DHCPHGULA(id)),"^",1) 
    if ($d(^DHCPHGENUSCON(0,"Label",id))>0)
    {
        s myInfo=myInfo_"<推导目录表>"
    }
    
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHDISGU(RowId)) q:(RowId="")||(flag=1)  d
        s LabelDr=$p($g(^DHCPHDISGU(RowId)),"^",2)
        i LabelDr=id
        {
            s flag=1
            s myInfo=myInfo_"<确诊病症指南>"
        }
    }
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2014-04-13
/// Description:根据id删除
/// Table:User.DHCPHGuideLabel
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHGuideLabel).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    n (id,%session)
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHGuideLabel).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHGuideLabel).%New()
        s pobj = ##class(User.DHCPHGuideLabel).%OpenId(id)
        s eobj.PGLRowId = id
        s eobj.PGLCode = pobj.PGLCode
        s eobj.PGLDesc = pobj.PGLDesc
        s eobj.PGLActiveFlag = pobj.PGLActiveFlag
        s eobj.PGLSysFlag = pobj.PGLSysFlag
    
        s sc=##class(User.DHCPHGuideLabel).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHGuideLabel","User.DHCPHGuideLabel","指南目录",id,eobj.PGLDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("指南目录","web.DHCBL.KB.DHCPHGuideLabel","DeleteData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

}
