Import SQLUser

/// 名称: 症状字典表
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
Class web.DHCBL.KB.DHCPHSymptom Extends %RegisteredObject
{

/// Description：修改时打开的数据
/// Table：User.DHCPHSymptom
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHSymptom).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHSymptom).%New()
    s eobj.SYMRowId=id
    s eobj.SYMCode=$p($g(^DHCPHSYMP(id)),"^",1)
    s eobj.SYMDesc=$p($g(^DHCPHSYMP(id)),"^",2)
    s eobj.SYMActiveFlag=$p($g(^DHCPHSYMP(id)),"^",3)
    
    s:eobj.SYMActiveFlag="Y" eobj.SYMActiveFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// 石萧伟
/// Table：User.DHCPHSymptom
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHSymptom).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHSymptom).%New()
    s eobj.SYMRowId=id
    s eobj.SYMCode=$p($g(^DHCPHSYMP(id)),"^",1)
    s eobj.SYMDesc=$p($g(^DHCPHSYMP(id)),"^",2)
    s eobj.SYMActiveFlag=$p($g(^DHCPHSYMP(id)),"^",3)
    
    s:eobj.SYMActiveFlag="" eobj.SYMActiveFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHSymptom
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHSYMP(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHSYMP(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHSYMP(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHSYMP(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存症状字典表的内容
/// Table：User.DHCPHSymptom
/// Input：web.Entity.KB.DHCPHSymptom 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHSymptom).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHSymptom) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    s ^SYMCode=eobj.SYMCode
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.SYMRowId,eobj.SYMCode,eobj.SYMDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.SYMRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHSymptom).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHSymptom).%OpenId(eobj.SYMRowId)
                s bobj=##class(web.Entity.KB.DHCPHSymptom).%New()
                s bobj.SYMRowId=eobj.SYMRowId
                s bobj.SYMCode=obj.SYMCode
                s bobj.SYMDesc = obj.SYMDesc          //修改描述
                s bobj.SYMActiveFlag = obj.SYMActiveFlag 
            }
            Ts
            s obj.SYMCode = eobj.SYMCode
            s obj.SYMDesc = eobj.SYMDesc          //修改描述
            s:eobj.SYMActiveFlag="" eobj.SYMActiveFlag ="N" 
            s obj.SYMActiveFlag = eobj.SYMActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.SYMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSymptom","User.DHCPHSymptom","症状字典表",id,eobj.SYMDesc,"A",eobj)
                //修改时，日志
                d:eobj.SYMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSymptom","User.DHCPHSymptom","症状字典表",eobj.SYMRowId,eobj.SYMDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典表","web.DHCBL.KB.DHCPHSymptom","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典表","web.DHCBL.KB.DHCPHSymptom","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询症状字典表的内容
/// Table：User.DHCPHSymptom
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSymptom","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SYMRowId:%String,SYMCode:%String,SYMDesc:%String,SYMActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHSymptom).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s SYMRowId=rowid
        s SYMCode=$p($g(^DHCPHSYMP(SYMRowId)),"^",1)
        s SYMDesc=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
        s SYMActiveFlag=$p($g(^DHCPHSYMP(SYMRowId)),"^",3)
    	s:SYMActiveFlag="" SYMActiveFlag="Y"
    	
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s SYMRowId=0
        for {
            s SYMRowId=$o(^DHCPHSYMP(SYMRowId))
            q:SYMRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_SYMRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s SYMCode=$p($g(^DHCPHSYMP(SYMRowId)),"^",1)
                s SYMDesc=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
                s SYMActiveFlag=$p($g(^DHCPHSYMP(SYMRowId)),"^",3)
                s:SYMActiveFlag="" SYMActiveFlag="Y"
                
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SYMDesc)
    
                if ($ZCONVERT(SYMCode,"U")[code)&(($ZCONVERT(SYMDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SYMRowId,SYMCode,SYMDesc,SYMActiveFlag)
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
/// Table：User.DHCPHSymptom
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHSymptom","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SYMRowId:%String,SYMCode:%String,SYMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHSymptom).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s SYMRowId=rowid
        s SYMCode=$p($g(^DHCPHSYMP(SYMRowId)),"^",1)
        s SYMDesc=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
        s SYMActiveFlag=$p($g(^DHCPHSYMP(SYMRowId)),"^",3) 
        s:SYMActiveFlag="" SYMActiveFlag="Y" 
        d:SYMActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s SYMRowId=0
        for {
            s SYMRowId=$o(^DHCPHSYMP(SYMRowId))
            q:SYMRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_SYMRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s SYMCode=$p($g(^DHCPHSYMP(SYMRowId)),"^",1)
                s SYMDesc=$p($g(^DHCPHSYMP(SYMRowId)),"^",2)
                 s SYMActiveFlag=$p($g(^DHCPHSYMP(SYMRowId)),"^",3)
                 s:SYMActiveFlag="" SYMActiveFlag="Y" 
                 continue:SYMActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SYMDesc)
                if ($ZCONVERT(SYMCode,"U")[code)&(($ZCONVERT(SYMDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(SYMRowId,SYMCode,SYMDesc)
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
/// w ##class(web.DHCBL.KB.DHCPHSymptom).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""

    i ($d(^DHCPHDLSY(0,"SYM",id)))
    {
        s myInfo=myInfo_"<诊断与症状关联表>"
    }
    
    s flag=0,SYMRowId=0
    for
    {
        s SYMRowId=$o(^DHCPHSYMCON(SYMRowId)) q:(SYMRowId="")||(flag=1)  d
        s SYMCode=$p($g(^DHCPHSYMCON(SYMRowId)),"^",1)
        s code=$p($g(^DHCPHSYMP(id)),"^",1)
        i SYMCode=code
        {
            s flag=1
            s myInfo=myInfo_"<症状字典对照表>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除症状字典表的内容
/// Table：User.DHCPHSymptom
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.KB.DHCPHSymptom).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        //new Entity对象，用于保存日志
        s pobj = ##class(User.DHCPHSymptom).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHSymptom).%New()
        s eobj.SYMRowId = id
        s eobj.SYMCode=pobj.SYMCode
        s eobj.SYMDesc=pobj.SYMDesc
        s eobj.SYMActiveFlag=pobj.SYMActiveFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHSymptom).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHSymptom","User.DHCPHSymptom","症状字典表",id,eobj.SYMDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状字典表","web.DHCBL.KB.DHCPHSymptom","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
