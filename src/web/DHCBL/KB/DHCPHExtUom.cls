Class web.DHCBL.KB.DHCPHExtUom Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询单位字典表内容
/// Table：User.DHCPHExtUom
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtUom","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHEURowId,PHEUCode,PHEUDesc,PHEUActiveFlag,PHEUSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtUom).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEURowId=rowid 
        s PHEUCode=$p($g(^DHCPHEUO(PHEURowId)),"^",1)  //代码
        s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)  //描述
        s PHEUActiveFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",3)  //是否可用
        s PHEUSysFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",4)  //是否系统标识
        s:PHEUActiveFlag="" PHEUActiveFlag="Y"
        s:PHEUSysFlag="" PHEUSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHEURowId=0
        for  
        {   
            s PHEURowId=$o(^DHCPHEUO(PHEURowId)) q:PHEURowId="" 
            s strRowId = "{ID:"_PHEURowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHEUCode=$p($g(^DHCPHEUO(PHEURowId)),"^",1)  //代码
                s PHEUCodeU=$ZCONVERT(PHEUCode,"U")
                s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)  //描述
                s PHEUDescU=$ZCONVERT(PHEUDesc,"U")
                s PHEUActiveFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",3)  //是否可用
                s PHEUSysFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",4)  //是否系统标识
                s:PHEUActiveFlag="" PHEUActiveFlag="Y"
        		s:PHEUSysFlag="" PHEUSysFlag="Y"
        
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEUDescU))
                i (PHEUCodeU[code)&((PHEUDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHEURowId,PHEUCode,PHEUDesc,PHEUActiveFlag,PHEUSysFlag)
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
/// CreatDate:2014-12-4
/// Description:查询 单位
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtUom","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHEURowId:%String,PHEUDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEURowId=rowid
        s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)
        s PHEUActiveFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",3)  //是否可用
        d:PHEUActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHExtUom).DHCGetDataByDefaultSession()
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
                s PHEUActiveFlag=$p($g(^DHCPHEUO(PHEURowId)),"^",3)  //是否可用
                continue:PHEUActiveFlag="N"
                s PHEUDesc=$p($g(^DHCPHEUO(PHEURowId)),"^",2)
                s PHEUDesc1=$ZCONVERT(PHEUDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEUDesc1))
                i (PHEUDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEURowId,PHEUDesc)
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
/// w ##class(web.DHCBL.KB.DHCPHExtUom).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHEUOi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHEUOi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHEUOi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHEUOi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtUom
/// Input：web.Entity.KB.DHCPHExtUom 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtUom) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHEURowId,eobj.PHEUCode,eobj.PHEUDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHEURowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtUom).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtUom).%OpenId(eobj.PHEURowId)
                
                s re=##class(web.DHCBL.KB.DHCPHExtUom).GetRefFlag(eobj.PHEURowId)
                s RefFlag=$p(re,"^",1)
                s str=$p(re,"^",2)
                if (RefFlag=1)&(str["<单位对照>"){
                    s result = "{success:'false',errorinfo:'在单位对照中被引用，不能修改!'}"  //返回错误信息
                    q result
                }
                
                s bobj = ##class(web.Entity.KB.DHCPHExtUom).%New()
                s bobj.PHEURowId = eobj.PHEURowId
                s bobj.PHEUCode = obj.PHEUCode
                s bobj.PHEUDesc = obj.PHEUDesc
                s bobj.PHEUActiveFlag= obj.PHEUActiveFlag
                s bobj.PHEUSysFlag = obj.PHEUSysFlag
            }
    
            s obj.PHEUCode = eobj.PHEUCode
            s obj.PHEUDesc = eobj.PHEUDesc
            i eobj.PHEUActiveFlag="Y"
            {
                s obj.PHEUActiveFlag = "Y"
            }
            else
            {
                s obj.PHEUActiveFlag = "N"
            }
            i eobj.PHEUSysFlag="Y"
            {
                s obj.PHEUSysFlag = "Y"
            }
            else
            {
                s obj.PHEUSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHEURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtUom","User.DHCPHExtUom","单位字典",id,eobj.PHEUDesc,"A",eobj)
                d:eobj.PHEURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtUom","User.DHCPHExtUom","单位字典",eobj.PHEURowId,eobj.PHEUDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位字典","web.DHCBL.KB.DHCPHExtUom","SaveData",eobj)
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
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtUom).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtUom).%New()
    s pobj = ##class(User.DHCPHExtUom).%OpenId(id)
    s eobj.PHEURowId = id
    s eobj.PHEUCode = pobj.PHEUCode
    s eobj.PHEUDesc = pobj.PHEUDesc
    s:pobj.PHEUActiveFlag="Y" eobj.PHEUActiveFlag="true"
    s:pobj.PHEUSysFlag="Y" eobj.PHEUSysFlag="true"  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-07
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtUom).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtUom).%New()
    s pobj = ##class(User.DHCPHExtUom).%OpenId(id)
    s eobj.PHEURowId = id
    s eobj.PHEUCode = pobj.PHEUCode
    s eobj.PHEUDesc = pobj.PHEUDesc
      
	s eobj.PHEUActiveFlag=pobj.PHEUActiveFlag
    s eobj.PHEUSysFlag=pobj.PHEUSysFlag
    s:eobj.PHEUActiveFlag="" eobj.PHEUActiveFlag="Y"
    s:eobj.PHEUSysFlag="" eobj.PHEUSysFlag="Y"
    
    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHExtUom).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s PDARowId=0,flag=0
    for
    {
        s PDARowId=$o(^DHCPHPAGEL(PDARowId)) q:(PDARowId="")||(flag=1)  d
        s PDAUomDr=$p($g(^DHCPHPAGEL(PDARowId)),"^",7)
        i PDAUomDr=id
        {
            s flag=1
            s myInfo=myInfo_"<年龄字典>"
        }
    }
    
    s flag=0
    s PHEUCode=$p($g(^DHCPHEUO(id)),"^",1) 
    s PHUCTRowId=0
    for  
    {   
        s PHUCTRowId=$o(^DHCPHUOCON(PHUCTRowId)) q:PHUCTRowId=""||(flag=1)  d 
        s PHUCTCode=$p($g(^DHCPHUOCON(PHUCTRowId)),"^",1)  //his代码
        i (PHUCTCode=PHEUCode){
            s flag=1
            s myInfo=myInfo_"<单位对照>"    
        }   
    }
    
    s LABIRowId=0,flag=0
    for
    {
        s LABIRowId=$o(^DHCLIBLABI(LABIRowId)) q:(LABIRowId="")||(flag=1)  d
        s LABIUomDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",5)
        i LABIUomDr=id
        {
            s flag=1
            s myInfo=myInfo_"<检验指标业务表>"
        }
    }
    
    s PDARowId=0,flag=0
    for
    {
        s PDARowId=$o(^DHCPHDISAGE(PDARowId)) q:(PDARowId="")||(flag=1)  d
        s PDAUomDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",5)
        i PDAUomDr=id
        {
            s flag=1
            s myInfo=myInfo_"<年龄业务表>"
        }
    }
    
    s PHUSDORowId=0,flag=0
    for
    {
        s PHUSDORowId=$o(^DHCPHUSDO(PHUSDORowId)) q:(PHUSDORowId="")||(flag=1)  d
        s PHUSDOOnceQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",6)
        s PHUSDOOneDayQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",9)
        s PHUSDOOnceMaxQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",11)
        s PHUSDOOneDayMaxQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",13)
        s PHUSDOFristTimeQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",16)
        s PHUSDODurationQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",19)
        s PHUSDOSpaceQtyUomDr=$p($g(^DHCPHUSDO(PHUSDORowId)),"^",22)
        i (PHUSDOOnceQtyUomDr=id)||(PHUSDOOneDayQtyUomDr=id)||(PHUSDOOnceMaxQtyUomDr=id)||(PHUSDOOneDayMaxQtyUomDr=id)||(PHUSDOFristTimeQtyUomDr=id)||(PHUSDODurationQtyUomDr=id)||(PHUSDOSpaceQtyUomDr=id)
        {
            s flag=1
            s myInfo=myInfo_"<用法用量表>"
        }
    }
    s PHECRowId=0,flag=0
    for
    {
        s PHECRowId=$o(^DHCPHEC(PHECRowId)) q:(PHECRowId="")||(flag=1)  d
        s PHECUomDr=$p($g(^DHCPHEC(PHECRowId)),"^",4)
        i PHECUomDr=id
        {
            s flag=1
            s myInfo=myInfo_"<整组浓度含量>"
        }
    }
    s PHMQRowId=0,flag=0
    for
    {
        s PHMQRowId=$o(^DHCPHMQ(PHMQRowId)) q:(PHMQRowId="")||(flag=1)  d
        s PHECUomDr=$p($g(^DHCPHMQ(PHMQRowId)),"^",5)
        i PHECUomDr=id
        {
            s flag=1
            s myInfo=myInfo_"<溶媒量>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtUom).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHExtUom).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtUom).%New()
        s pobj = ##class(User.DHCPHExtUom).%OpenId(id)
        s eobj.PHEURowId = id
        s eobj.PHEUCode = pobj.PHEUCode
        s eobj.PHEUDesc = pobj.PHEUDesc
        s eobj.PHEUActiveFlag = pobj.PHEUActiveFlag
        s eobj.PHEUSysFlag = pobj.PHEUSysFlag
    
        s sc=##class(User.DHCPHExtUom).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtUom","User.DHCPHExtUom","单位字典",id,eobj.PHEUDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位字典","web.DHCBL.KB.DHCPHExtUom","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
