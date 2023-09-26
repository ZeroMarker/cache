Class web.DHCBL.KB.DHCAllergyFeild Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询过敏史字典表内容
/// Table：User.DHCAllergyFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCAllergyFeild","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "ALFRowId,ALFCode,ALFDesc,ALFActiveFlag,ALFSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCAllergyFeild).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ALFRowId=rowid
        s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
        s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
        s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
        s ALFSysFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",4)  //是否系统标识
        s:ALFActiveFlag="" ALFActiveFlag="Y"
        s:ALFSysFlag="" ALFSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s ALFRowId=0
        for  
        {   
            s ALFRowId=$o(^DHCALLERGY(ALFRowId)) q:ALFRowId="" 
            s strRowId = "{ID:"_ALFRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
                s ALFCodeU=$ZCONVERT(ALFCode,"U")
                s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
                s ALFDescU=$ZCONVERT(ALFDesc,"U")
                s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
                s ALFSysFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",4)  //是否系统标识
                s:ALFActiveFlag="" ALFActiveFlag="Y"
        		s:ALFSysFlag="" ALFSysFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ALFDescU))
                i (ALFCodeU[code)&((ALFDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ALFRowId,ALFCode,ALFDesc,ALFActiveFlag,ALFSysFlag)
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
/// Description:查询 过敏史 
/// Input:desc
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ALFRowId:%String,ALFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s ALFRowId=rowid
        s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)
        s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
        d:ALFActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCAllergyFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s ALFRowId=0
        for
        {
            s ALFRowId=$o(^DHCALLERGY(ALFRowId)) q:ALFRowId=""
            s strRowId="{ID:"_ALFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
                continue:ALFActiveFlag="N"
                s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)
                s ALFDesc1=$ZCONVERT(ALFDesc,"U")
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ALFDesc1))
                i (ALFDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ALFRowId,ALFDesc)
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
/// w ##class(web.DHCBL.KB.DHCAllergyFeild).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCALLERGYi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCALLERGYi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCALLERGYi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCALLERGYi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCAllergyFeild
/// Input：web.Entity.KB.DHCAllergyFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCAllergyFeild) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.ALFRowId,eobj.ALFCode,eobj.ALFDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.ALFRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCAllergyFeild).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCAllergyFeild).%OpenId(eobj.ALFRowId)
                s bobj = ##class(web.Entity.KB.DHCAllergyFeild).%New()
                s bobj.ALFRowId = eobj.ALFRowId
                s bobj.ALFCode = obj.ALFCode
                s bobj.ALFDesc = obj.ALFDesc
                s bobj.ALFActiveFlag= obj.ALFActiveFlag
                s bobj.ALFSysFlag = obj.ALFSysFlag
            }
    
            s obj.ALFCode = eobj.ALFCode
            s obj.ALFDesc = eobj.ALFDesc
            i eobj.ALFActiveFlag="Y"
            {
                s obj.ALFActiveFlag = "Y"
            }
            else
            {
                s obj.ALFActiveFlag = "N"
            }
            i eobj.ALFSysFlag="Y"
            {
                s obj.ALFSysFlag = "Y"
            }
            else
            {
                s obj.ALFSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.ALFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyFeild","User.DHCAllergyFeild","过敏史字典",id,eobj.ALFDesc,"A",eobj)
                d:eobj.ALFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyFeild","User.DHCAllergyFeild","过敏史字典",eobj.ALFRowId,eobj.ALFDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏史字典","web.DHCBL.KB.DHCAllergyFeild","SaveData",eobj)
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
/// Table：User.DHCAllergyFeild
/// Other: d ##class(web.DHCBL.KB.DHCAllergyFeild).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCAllergyFeild).%New()
    s pobj = ##class(User.DHCAllergyFeild).%OpenId(id)
    s eobj.ALFRowId = id
    s eobj.ALFCode = pobj.ALFCode
    s eobj.ALFDesc = pobj.ALFDesc
    s:pobj.ALFActiveFlag="Y" eobj.ALFActiveFlag="true"
    s:pobj.ALFSysFlag="Y" eobj.ALFSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCAllergyFeild
/// Other: d ##class(web.DHCBL.KB.DHCAllergyFeild).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCAllergyFeild).%New()
    s pobj = ##class(User.DHCAllergyFeild).%OpenId(id)
    s eobj.ALFRowId = id
    s eobj.ALFCode = pobj.ALFCode
    s eobj.ALFDesc = pobj.ALFDesc
    s eobj.ALFActiveFlag=pobj.ALFActiveFlag
    s eobj.ALFSysFlag=pobj.ALFSysFlag   
	s:pobj.ALFActiveFlag="" eobj.ALFActiveFlag="Y"
    s:pobj.ALFSysFlag="" eobj.ALFSysFlag="Y"
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
    
    s ALKRowId=0,flag=0
    for
    {
        s ALKRowId=$o(^DHCALLGYKEY(ALKRowId)) q:(ALKRowId="")||(flag=1)  d
        s ALKALDr=$p($g(^DHCALLGYKEY(ALKRowId)),"^",1)
        i ALKALDr=id
        {
            s flag=1
            s myInfo=myInfo_"<过敏史关键字表>"
        }
    }
    
    s LALCRowId=0,flag=0
    for
    {
        s LALCRowId=$o(^DHCLIBALLI(LALCRowId)) q:(LALCRowId="")||(flag=1)  d
        s LALCAllergyDr=$p($g(^DHCLIBALLI(LALCRowId)),"^",2)
        i LALCAllergyDr=id
        {
            s flag=1
            s myInfo=myInfo_"<过敏史业务表>"
        }
    }
        
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCAllergyFeild
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCAllergyFeild).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    
    s re=##class(web.DHCBL.KB.DHCAllergyFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCAllergyFeild).%New()
        s pobj = ##class(User.DHCAllergyFeild).%OpenId(id)
        s eobj.ALFRowId = id
        s eobj.ALFCode = pobj.ALFCode
        s eobj.ALFDesc = pobj.ALFDesc
        s eobj.ALFActiveFlag = pobj.ALFActiveFlag
        s eobj.ALFSysFlag = pobj.ALFSysFlag
    
        s sc=##class(User.DHCAllergyFeild).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_AllergyFeild","User.DHCAllergyFeild","过敏史字典",id,eobj.ALFDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("过敏史字典","web.DHCBL.KB.DHCAllergyFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
