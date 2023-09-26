Import SQLUser

/// 名称: 年龄字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-30
Class web.DHCBL.KB.DHCPHPatAgeList Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCPHPatAgeList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHPatAgeList).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.DHCPHPatAgeList).%OpenId(id)  
    s eobj = ##class(web.Entity.KB.DHCPHPatAgeList).%New()
    s eobj.PDARowID=id
    s eobj.PDAAgeCode=pobj.PDAAgeCode
    s eobj.PDAAgeDesc=pobj.PDAAgeDesc
    s eobj.PDAAgeMin=pobj.PDAAgeMin
    s eobj.PDAAgeMax=pobj.PDAAgeMax
    s eobj.PDAActiveFlag=pobj.PDAActiveFlag
    s eobj.PDASysFlag=pobj.PDASysFlag   
    s:eobj.PDAActiveFlag="" eobj.PDAActiveFlag="Y" 
    s:eobj.PDASysFlag="" eobj.PDASysFlag="Y" 
    if $IsObject(pobj.PDAUomDr){
        s eobj.PDAUomDr = pobj.PDAUomDr.%Id() 
        }
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHPatAgeList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHPatAgeList).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.DHCPHPatAgeList).%OpenId(id)  
    s eobj = ##class(web.Entity.KB.DHCPHPatAgeList).%New()
    s eobj.PDARowID=id
    s eobj.PDAAgeCode=pobj.PDAAgeCode
    s eobj.PDAAgeDesc=pobj.PDAAgeDesc
    s eobj.PDAAgeMin=pobj.PDAAgeMin
    s eobj.PDAAgeMax=pobj.PDAAgeMax
    s eobj.PDAActiveFlag=pobj.PDAActiveFlag
    s eobj.PDASysFlag=pobj.PDASysFlag   
    s:eobj.PDAActiveFlag="Y" eobj.PDAActiveFlag="true" 
    s:eobj.PDASysFlag="Y" eobj.PDASysFlag="true" 
    if $IsObject(pobj.PDAUomDr){
        s eobj.PDAUomDr = pobj.PDAUomDr.%Id() 
        }
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHPatAgeList
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHPAGEL(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHPAGEL(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHPAGEL(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHPAGEL(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存年龄字典的内容
/// Table：User.DHCPHPatAgeList
/// Input：web.Entity.KB.DHCPHPatAgeList 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHPatAgeList).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHPatAgeList) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.PDARowID,eobj.PDAAgeCode,eobj.PDAAgeDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.PDARowID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHPatAgeList).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHPatAgeList).%OpenId(eobj.PDARowID)
                s bobj=##class(web.Entity.KB.DHCPHPatAgeList).%New()
                s bobj.PDARowID=eobj.PDARowID
                s bobj.PDAAgeCode=obj.PDAAgeCode
                s bobj.PDAAgeDesc = obj.PDAAgeDesc          //修改描述
                s bobj.PDAAgeMin = obj.PDAAgeMin          
                s bobj.PDAAgeMax = obj.PDAAgeMax
                s bobj.PDAActiveFlag = obj.PDAActiveFlag 
                s bobj.PDASysFlag = obj.PDASysFlag
                if $IsObject(obj.PDAUomDr){
                    s bobj.PDAUomDr = obj.PDAUomDr.%Id() 
                }
                
            }
            Ts
            s obj.PDAAgeCode = eobj.PDAAgeCode
            s obj.PDAAgeDesc = eobj.PDAAgeDesc          //修改描述
            s obj.PDAAgeMin = eobj.PDAAgeMin         
            s obj.PDAAgeMax = eobj.PDAAgeMax
            s:eobj.PDAActiveFlag="" eobj.PDAActiveFlag ="N" 
            s obj.PDAActiveFlag = eobj.PDAActiveFlag 
            s:eobj.PDASysFlag="" eobj.PDASysFlag ="N" 
            s obj.PDASysFlag = eobj.PDASysFlag  
            d obj.PDAUomDrSetObjectId(eobj.PDAUomDr)
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.PDARowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHPatAgeList","User.DHCPHPatAgeList","年龄字典",id,eobj.PDAAgeDesc,"A",eobj)
                //修改时，日志
                d:eobj.PDARowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHPatAgeList","User.DHCPHPatAgeList","年龄字典",eobj.PDARowID,eobj.PDAAgeDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("年龄字典","web.DHCBL.KB.DHCPHPatAgeList","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("年龄字典","web.DHCBL.KB.DHCPHPatAgeList","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHPatAgeList).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s PDARowId=0,flag=0
    for
    {
        s PDARowId=$o(^DHCPHDISAGE(PDARowId)) q:(PDARowId="")||(flag=1)  d
        s PDAAgeDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",2)
        i PDAAgeDr=id
        {
            s flag=1
            s myInfo=myInfo_"<知识库编辑器>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除年龄字典的内容
/// Table：User.DHCPHPatAgeList
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s re=##class(web.DHCBL.KB.DHCPHPatAgeList).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=0){
    //new Entity对象，用于保存日志
    s eobj = ##class(web.Entity.KB.DHCPHPatAgeList).%New()
    s eobj.PDARowID = id
    s eobj.PDAAgeCode=$p($g(^DHCPHPAGEL(id)),"^",1)
    s eobj.PDAAgeDesc=$p($g(^DHCPHPAGEL(id)),"^",2)
    s eobj.PDAAgeMin=$p($g(^DHCPHPAGEL(id)),"^",3)
    s eobj.PDAAgeMax=$p($g(^DHCPHPAGEL(id)),"^",4)
    s eobj.PDAActiveFlag=$p($g(^DHCPHPAGEL(id)),"^",5)
    s eobj.PDASysFlag=$p($g(^DHCPHPAGEL(id)),"^",6)
    s eobj.PDAUomDr=$p($g(^DHCPHPAGEL(id)),"^",7)
    s sc=##class(User.DHCPHPatAgeList).%DeleteId(id)
    if $$$ISOK(sc)
    {
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHPatAgeList","User.DHCPHPatAgeList","年龄字典",id,eobj.PDAAgeDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("年龄字典","web.DHCBL.KB.DHCPHPatAgeList","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
 }
 else
 {
     s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 
 q result
}

/// Description：查询年龄字典的内容
/// Table：User.DHCPHPatAgeList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPatAgeList","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PDARowID:%String,PDAAgeCode:%String,PDAAgeDesc:%String,PDAAgeMin:%String,PDAAgeMax:%String,PDAActiveFlag:%String,PDASysFlag:%String,PDAUomDr:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHPatAgeList).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PDARowID=rowid
        s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
        s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
        s PDAAgeMin=$p($g(^DHCPHPAGEL(PDARowID)),"^",3)
        s PDAAgeMax=$p($g(^DHCPHPAGEL(PDARowID)),"^",4)
        s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
        s PDASysFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",6)
        s:PDAActiveFlag="" PDAActiveFlag="Y"
        s:PDASysFlag="" PDASysFlag="Y"
        
        s UomRowId=$p($g(^DHCPHPAGEL(PDARowID)),"^",7)
        i UomRowId'="" {
            s PDAUomDr=$p($g(^DHCPHEUO(UomRowId)),"^",2)
        }
        else {
            s PDAUomDr=""
        }
    
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s PDARowID=0
        for {
            s PDARowID=$o(^DHCPHPAGEL(PDARowID))
            q:PDARowID=""
            //筛选授权后的数据
            s strRowId="{ID:"_PDARowID_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
                s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
                s PDAAgeMin=$p($g(^DHCPHPAGEL(PDARowID)),"^",3) 
                s PDAAgeMax=$p($g(^DHCPHPAGEL(PDARowID)),"^",4)
                s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
                s PDASysFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",6)
                s:PDAActiveFlag="" PDAActiveFlag="Y"
        		s:PDASysFlag="" PDASysFlag="Y"
        
                s UomRowId=$p($g(^DHCPHPAGEL(PDARowID)),"^",7)
                i UomRowId'="" {
                    s PDAUomDr=$p($g(^DHCPHEUO(UomRowId)),"^",2)
                }
                else {
                    s PDAUomDr=""
                }
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PDAAgeDesc)
                if ($ZCONVERT(PDAAgeCode,"U")[code)&(($ZCONVERT(PDAAgeDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PDARowID,PDAAgeCode,PDAAgeDesc,PDAAgeMin,PDAAgeMax,PDAActiveFlag,PDASysFlag,PDAUomDr)
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

/// Description：为combobox查询取数据
/// Table：User.DHCPHPatAgeList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPatAgeList","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PDARowID:%String,PDAAgeCode:%String,PDAAgeDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHPatAgeList).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PDARowID=rowid
        s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
        s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
        s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
        d:PDAActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s PDARowID=0
        for {
            s PDARowID=$o(^DHCPHPAGEL(PDARowID))
            q:PDARowID=""
            //筛选授权后的数据
            s strRowId="{ID:"_PDARowID_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
                continue:PDAActiveFlag="N"
                s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
                s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PDAAgeDesc)
                if ($ZCONVERT(PDAAgeCode,"U")[code)&(($ZCONVERT(PDAAgeDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PDARowID,PDAAgeCode,PDAAgeDesc)
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

/// Creator:谷雪萍
/// CreatDate:2014-12-17
/// Description:查询 单位年月日
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHPatAgeList","GetDataForCmbYMD","","")
Query GetDataForCmbYMD(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHEURowId:%String,PHEUDesc:%String")
{
}

ClassMethod GetDataForCmbYMDExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEURowId=rowid
        s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)
        d OutputRowYMD
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.SSGroup).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHEURowId=0
        for
        {
            s PHEURowId=$o(^DHCPHEUO(PHEURowId)) q:PHEURowId=""
            s strRowId="{ID:"_PHEURowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)
                s PHEUDesc1=$ZCONVERT(PHEUDesc,"U")
                i (PHEUDesc1[desc)&((PHEUDesc="年")!(PHEUDesc="月")!(PHEUDesc="日"))
                {
                    d OutputRowYMD
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowYMD
    set Data=$lb(PHEURowId,PHEUDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbYMDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbYMDExecute ]
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

ClassMethod GetDataForCmbYMDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbYMDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description：根据Id获取最大值最小值
/// Table：User.DHCPHPatAgeList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHPatAgeList).getMaxMin("1")
ClassMethod getMaxMin(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.DHCPHPatAgeList).%OpenId(id)  
    s eobj = ##class(web.Entity.KB.DHCPHPatAgeList).%New()
    s eobj.PDARowID=id
    s eobj.PDAAgeMin=pobj.PDAAgeMin
    s eobj.PDAAgeMax=pobj.PDAAgeMax
    //s UomDesc=""
    if $IsObject(pobj.PDAUomDr){
        s eobj.PDAUomDr = pobj.PDAUomDr.%Id() 
        s UomDesc=$p($g(^DHCPHEUO(eobj.PDAUomDr)),"^",2)  //描述
    }
    d pobj.%Close()
    k pobj
    s str = "{""PDAAgeMin"":"""_eobj.PDAAgeMin_""",""PDAAgeMax"":"""_eobj.PDAAgeMax_""",""PDAUomDr"":"""_eobj.PDAUomDr_""",""UomDesc"":"""_UomDesc_"""}"  
    d eobj.%Close()
    q str
}

}
