Class web.DHCBL.KB.DHCDisHistoryFeild Extends %RegisteredObject
{

/// Creator:石萧伟
/// CreatDate:2018-07-31
/// Description:查询 既往史
/// Input:desc
Query GetNewDataForCmb1(rowid As %String, q As %String) As %Query(ROWSPEC = "DHIRowId:%String,DHIDesc:%String")
{
}

ClassMethod GetNewDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s DHIRowId=rowid
        s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)
        s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
        s:DHIActiveFlag="" DHIActiveFlag="Y"
        d:DHIActiveFlag="Y" OutputRowCmbNew
    }
    else
    {

        s:q'="" q=$ZCONVERT(q,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCDisHistoryFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s DHIRowId=0
        for
        {
            s DHIRowId=$o(^DHCDISHISF(DHIRowId)) q:DHIRowId=""
            s strRowId="{ID:"_DHIRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
                s:DHIActiveFlag="" DHIActiveFlag="Y"
                continue:DHIActiveFlag="N"
                s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)
                s DHIDesc1=$ZCONVERT(DHIDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DHIDesc1)
                i (DHIDesc1[q)||(PINYIN[q)
                {
                    d OutputRowCmbNew
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmbNew
    set Data=$lb(DHIRowId,DHIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetNewDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询既往史字典表内容
/// Table：User.DHCDisHistoryFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCDisHistoryFeild","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "DHIRowId,DHICode,DHIDesc,DHIActiveFlag,DHISysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCDisHistoryFeild).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s DHIRowId=rowid
        s DHICode=$p($g(^DHCDISHISF(DHIRowId)),"^",1)  //代码
        s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)  //描述
        s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
        s DHISysFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",4)  //是否系统标识
        s:DHIActiveFlag="" DHIActiveFlag="Y"
        s:DHISysFlag="" DHISysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s DHIRowId=0
        for  
        {   
            s DHIRowId=$o(^DHCDISHISF(DHIRowId)) q:DHIRowId="" 
            s strRowId = "{ID:"_DHIRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s DHICode=$p($g(^DHCDISHISF(DHIRowId)),"^",1)  //代码
                s DHICodeU=$ZCONVERT(DHICode,"U")
                s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)  //描述
                s DHIDescU=$ZCONVERT(DHIDesc,"U")
                s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
                s DHISysFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",4)  //是否系统标识
                s:DHIActiveFlag="" DHIActiveFlag="Y"
        		s:DHISysFlag="" DHISysFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DHIDescU))
                i (DHICodeU[code)&((DHIDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(DHIRowId,DHICode,DHIDesc,DHIActiveFlag,DHISysFlag)
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
/// Description:查询 既往史
/// Input:desc
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "DHIRowId:%String,DHIDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s DHIRowId=rowid
        s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)
        s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
        d:DHIActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCDisHistoryFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s DHIRowId=0
        for
        {
            s DHIRowId=$o(^DHCDISHISF(DHIRowId)) q:DHIRowId=""
            s strRowId="{ID:"_DHIRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s DHIActiveFlag=$p($g(^DHCDISHISF(DHIRowId)),"^",3)  //是否可用
                continue:DHIActiveFlag="N"
                s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)
                s DHIDesc1=$ZCONVERT(DHIDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DHIDesc1))
                i (DHIDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(DHIRowId,DHIDesc)
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
/// w ##class(web.DHCBL.KB.DHCDisHistoryFeild).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCDISHISFi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCDISHISFi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCDISHISFi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCDISHISFi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCDisHistoryFeild
/// Input：web.Entity.KB.DHCDisHistoryFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCDisHistoryFeild) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.DHIRowId,eobj.DHICode,eobj.DHIDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.DHIRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCDisHistoryFeild).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCDisHistoryFeild).%OpenId(eobj.DHIRowId)
                s bobj = ##class(web.Entity.KB.DHCDisHistoryFeild).%New()
                s bobj.DHIRowId = eobj.DHIRowId
                s bobj.DHICode = obj.DHICode
                s bobj.DHIDesc = obj.DHIDesc
                s bobj.DHIActiveFlag= obj.DHIActiveFlag
                s bobj.DHISysFlag = obj.DHISysFlag
            }
    
            s obj.DHICode = eobj.DHICode
            s obj.DHIDesc = eobj.DHIDesc
            i eobj.DHIActiveFlag="Y"
            {
                s obj.DHIActiveFlag = "Y"
            }
            else
            {
                s obj.DHIActiveFlag = "N"
            }
            i eobj.DHISysFlag="Y"
            {
                s obj.DHISysFlag = "Y"
            }
            else
            {
                s obj.DHISysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.DHIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryFeild","User.DHCDisHistoryFeild","既往史字典",id,eobj.DHIDesc,"A",eobj)
                d:eobj.DHIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryFeild","User.DHCDisHistoryFeild","既往史字典",eobj.DHIRowId,eobj.DHIDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("既往史字典","web.DHCBL.KB.DHCDisHistoryFeild","SaveData",eobj)
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
/// Table：User.DHCDisHistoryFeild
/// Other: d ##class(web.DHCBL.KB.DHCDisHistoryFeild).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCDisHistoryFeild).%New()
    s pobj = ##class(User.DHCDisHistoryFeild).%OpenId(id)
    s eobj.DHIRowId = id
    s eobj.DHICode = pobj.DHICode
    s eobj.DHIDesc = pobj.DHIDesc
    s:pobj.DHIActiveFlag="Y" eobj.DHIActiveFlag="true"
    s:pobj.DHISysFlag="Y" eobj.DHISysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCDisHistoryFeild
/// Other: d ##class(web.DHCBL.KB.DHCDisHistoryFeild).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCDisHistoryFeild).%New()
    s pobj = ##class(User.DHCDisHistoryFeild).%OpenId(id)
    s eobj.DHIRowId = id
    s eobj.DHICode = pobj.DHICode
    s eobj.DHIDesc = pobj.DHIDesc
    s eobj.DHIActiveFlag=pobj.DHIActiveFlag
    s eobj.DHISysFlag=pobj.DHISysFlag  
	s:pobj.DHIActiveFlag="" eobj.DHIActiveFlag="Y"
    s:pobj.DHISysFlag="" eobj.DHISysFlag="Y" 
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
    
    s DHKRowId=0,flag=0
    for
    {
        s DHKRowId=$o(^DHCDISHISK(DHKRowId)) q:(DHKRowId="")||(flag=1)  d
        s DHKDHDr=$p($g(^DHCDISHISK(DHKRowId)),"^",1)
        i DHKDHDr=id
        {
            s flag=1
            s myInfo=myInfo_"<既往史关键字表>"
        }
    }
    
    s LDHRowId=0,flag=0
    for
    {
        s LDHRowId=$o(^DHCLIBDISHISI(LDHRowId)) q:(LDHRowId="")||(flag=1)  d
        s LDHDhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)
        i LDHDhDr=id
        {
            s flag=1
            s myInfo=myInfo_"<既往史业务表>"
        }
    }
    
    i $d(^DHCSPEP(0,"DH",id)){
        s myInfo=myInfo_"<特殊人群与既往史关联表>"
    }   
        
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCDisHistoryFeild
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCDisHistoryFeild).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    
    s re=##class(web.DHCBL.KB.DHCDisHistoryFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCDisHistoryFeild).%New()
        s pobj = ##class(User.DHCDisHistoryFeild).%OpenId(id)
        s eobj.DHIRowId = id
        s eobj.DHICode = pobj.DHICode
        s eobj.DHIDesc = pobj.DHIDesc
        s eobj.DHIActiveFlag = pobj.DHIActiveFlag
        s eobj.DHISysFlag = pobj.DHISysFlag
    
        s sc=##class(User.DHCDisHistoryFeild).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_DisHistoryFeild","User.DHCDisHistoryFeild","既往史字典",id,eobj.DHIDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("既往史字典","web.DHCBL.KB.DHCDisHistoryFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
