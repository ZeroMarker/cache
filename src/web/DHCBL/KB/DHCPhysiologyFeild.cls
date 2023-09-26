Class web.DHCBL.KB.DHCPhysiologyFeild Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询生理字典表内容
/// Table：User.DHCPhysiologyFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPhysiologyFeild","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHYFRowId,PHYFCode,PHYFDesc,PHYFType,PHYFActiveFlag,PHYFSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPhysiologyFeild).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHYFRowId=rowid 
        s PHYFCode=$p($g(^DHCPHYSIF(PHYFRowId)),"^",1)  //代码
        s PHYFDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)  //描述
        s PHYFType=$p($g(^DHCPHYSIF(PHYFRowId)),"^",3)  //类型
        s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)  //是否可用
        s PHYFSysFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",5)  //是否系统标识
        s:PHYFActiveFlag="" PHYFActiveFlag="Y"
        s:PHYFSysFlag="" PHYFSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHYFRowId=0
        for  
        {   
            s PHYFRowId=$o(^DHCPHYSIF(PHYFRowId)) q:PHYFRowId="" 
            s strRowId = "{ID:"_PHYFRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHYFCode=$p($g(^DHCPHYSIF(PHYFRowId)),"^",1)  //代码
                s PHYFCodeU=$ZCONVERT(PHYFCode,"U")
                s PHYFDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)  //描述
                s PHYFDescU=$ZCONVERT(PHYFDesc,"U")
                s PHYFType=$p($g(^DHCPHYSIF(PHYFRowId)),"^",3)  //类型
                s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)  //是否可用
                s PHYFSysFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",5)  //是否系统标识
                s:PHYFActiveFlag="" PHYFActiveFlag="Y"
        		s:PHYFSysFlag="" PHYFSysFlag="Y"
        
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHYFDescU))
                i (PHYFCodeU[code)&((PHYFDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHYFRowId,PHYFCode,PHYFDesc,PHYFType,PHYFActiveFlag,PHYFSysFlag)
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
/// CreatDate:2014-11-10
/// Description:查询 生理字典
/// Input:desc
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHYFRowId:%String,PHYFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHYFRowId=rowid
        s PHYFDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)
        s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)  //是否可用
        d:PHYFActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPhysiologyFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHYFRowId=0
        for
        {
            s PHYFRowId=$o(^DHCPHYSIF(PHYFRowId)) q:PHYFRowId=""
            s strRowId="{ID:"_PHYFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)  //是否可用
                continue:PHYFActiveFlag="N"
                s PHYFDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)
                s PHYFDesc1=$ZCONVERT(PHYFDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHYFDesc1))
                i (PHYFDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHYFRowId,PHYFDesc)
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
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPhysiologyFeild).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHYSIFi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHYSIFi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHYSIFi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHYSIFi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPhysiologyFeild
/// Input：web.Entity.KB.DHCPhysiologyFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPhysiologyFeild) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHYFRowId,eobj.PHYFCode,eobj.PHYFDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHYFRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPhysiologyFeild).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPhysiologyFeild).%OpenId(eobj.PHYFRowId)
                s bobj = ##class(web.Entity.KB.DHCPhysiologyFeild).%New()
                s bobj.PHYFRowId = eobj.PHYFRowId
                s bobj.PHYFCode = obj.PHYFCode
                s bobj.PHYFDesc = obj.PHYFDesc
                s bobj.PHYFType = obj.PHYFType
                s bobj.PHYFActiveFlag= obj.PHYFActiveFlag
                s bobj.PHYFSysFlag = obj.PHYFSysFlag
            }
    
            s obj.PHYFCode = eobj.PHYFCode
            s obj.PHYFDesc = eobj.PHYFDesc
            s obj.PHYFType = eobj.PHYFType
            i eobj.PHYFActiveFlag="Y"
            {
                s obj.PHYFActiveFlag = "Y"
            }
            else
            {
                s obj.PHYFActiveFlag = "N"
            }
            i eobj.PHYFSysFlag="Y"
            {
                s obj.PHYFSysFlag = "Y"
            }
            else
            {
                s obj.PHYFSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHYFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologyFeild","User.DHCPhysiologyFeild","生理字典",id,eobj.PHYFDesc,"A",eobj)
                d:eobj.PHYFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologyFeild","User.DHCPhysiologyFeild","生理字典",eobj.PHYFRowId,eobj.PHYFDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("生理字典","web.DHCBL.KB.DHCPhysiologyFeild","SaveData",eobj)
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
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPhysiologyFeild
/// Other: d ##class(web.DHCBL.KB.DHCPhysiologyFeild).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPhysiologyFeild).%New()
    s pobj = ##class(User.DHCPhysiologyFeild).%OpenId(id)
    s eobj.PHYFRowId = id
    s eobj.PHYFCode = pobj.PHYFCode
    s eobj.PHYFDesc = pobj.PHYFDesc
    s eobj.PHYFType = pobj.PHYFType
    s:pobj.PHYFActiveFlag="Y" eobj.PHYFActiveFlag="true"
    s:pobj.PHYFSysFlag="Y" eobj.PHYFSysFlag="true"  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCPhysiologyFeild
/// Other: d ##class(web.DHCBL.KB.DHCPhysiologyFeild).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPhysiologyFeild).%New()
    s pobj = ##class(User.DHCPhysiologyFeild).%OpenId(id)
    s eobj.PHYFRowId = id
    s eobj.PHYFCode = pobj.PHYFCode
    s eobj.PHYFDesc = pobj.PHYFDesc
    s eobj.PHYFType = pobj.PHYFType 
    s eobj.PHYFActiveFlag=pobj.PHYFActiveFlag
    s eobj.PHYFSysFlag=pobj.PHYFSysFlag 
    s:pobj.PHYFActiveFlag="" eobj.PHYFActiveFlag="Y"
    s:pobj.PHYFSysFlag="" eobj.PHYFSysFlag="Y"

    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""   
    
    s PHYVRowId=0,flag=0
    for
    {
        s PHYVRowId=$o(^DHCPHYVAL(PHYVRowId)) q:(PHYVRowId="")||(flag=1)  d
        s PHYVFeildDr=$p($g(^DHCPHYVAL(PHYVRowId)),"^",2)
        i PHYVFeildDr=id
        {
            s flag=1
            s myInfo=myInfo_"<生理业务表>"
        }
    }   
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPhysiologyFeild
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPhysiologyFeild).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPhysiologyFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {

        Tstart
        s eobj = ##class(web.Entity.KB.DHCPhysiologyFeild).%New()
        s pobj = ##class(User.DHCPhysiologyFeild).%OpenId(id)
        s eobj.PHYFRowId = id
        s eobj.PHYFCode = pobj.PHYFCode
        s eobj.PHYFDesc = pobj.PHYFDesc
        s eobj.PHYFType = pobj.PHYFType
        s eobj.PHYFActiveFlag = pobj.PHYFActiveFlag
        s eobj.PHYFSysFlag = pobj.PHYFSysFlag
    
        s sc=##class(User.DHCPhysiologyFeild).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologyFeild","User.DHCPhysiologyFeild","生理字典",id,eobj.PHYFDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("生理字典","web.DHCBL.KB.DHCPhysiologyFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
