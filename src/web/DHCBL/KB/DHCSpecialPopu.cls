Import SQLUser

/// 名称: 特殊人群字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
Class web.DHCBL.KB.DHCSpecialPopu Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopu
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopu).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.DHCSpecialPopu).%OpenId(id)   
    s eobj = ##class(web.Entity.KB.DHCSpecialPopu).%New()
    s eobj.SPERowId=id
    s eobj.SPECode=pobj.SPECode
    s eobj.SPEDesc=pobj.SPEDesc
    s eobj.SPEType=pobj.SPEType
    if $IsObject(pobj.SPELibDr){
        s eobj.SPELibDr=pobj.SPELibDr.%Id()
    }
    s eobj.SPEActiveFlag=pobj.SPEActiveFlag
    s eobj.SPESysFlag=pobj.SPESysFlag
    
    s:eobj.SPEActiveFlag="" eobj.SPEActiveFlag="Y" 
    s:eobj.SPESysFlag="" eobj.SPESysFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// Table：User.DHCSpecialPopu
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCSpecialPopu).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.DHCSpecialPopu).%OpenId(id)   
    s eobj = ##class(web.Entity.KB.DHCSpecialPopu).%New()
    s eobj.SPERowId=id
    s eobj.SPECode=pobj.SPECode
    s eobj.SPEDesc=pobj.SPEDesc
    s eobj.SPEType=pobj.SPEType
    if $IsObject(pobj.SPELibDr){
        s eobj.SPELibDr=pobj.SPELibDr.%Id()
    }
    s eobj.SPEActiveFlag=pobj.SPEActiveFlag
    s eobj.SPESysFlag=pobj.SPESysFlag
    
    s:eobj.SPEActiveFlag="Y" eobj.SPEActiveFlag="true" 
    s:eobj.SPESysFlag="Y" eobj.SPESysFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCSpecialPopu
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCSPEP(0,"Code",code))
    s:desc'="" flagd=$d(^DHCSPEP(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCSPEP(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCSPEP(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存特殊人群字典的内容
/// Table：User.DHCSpecialPopu
/// Input：web.Entity.KB.DHCSpecialPopu 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCSpecialPopu).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCSpecialPopu) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.SPERowId,eobj.SPECode,eobj.SPEDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.SPERowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCSpecialPopu).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCSpecialPopu).%OpenId(eobj.SPERowId)
                s bobj=##class(web.Entity.KB.DHCSpecialPopu).%New()
                s bobj.SPERowId=eobj.SPERowId
                s bobj.SPECode=obj.SPECode
                s bobj.SPEDesc = obj.SPEDesc          //修改描述
                s bobj.SPEType = obj.SPEType 
                if $IsObject(obj.SPELibDr){         
                    s bobj.SPELibDr = obj.SPELibDr.%Id()
                }
                s bobj.SPEActiveFlag = obj.SPEActiveFlag 
                s bobj.SPESysFlag = obj.SPESysFlag
            }
            Ts
            s obj.SPECode = eobj.SPECode
            s obj.SPEDesc = eobj.SPEDesc          //修改描述
            s obj.SPEType = eobj.SPEType
            d obj.SPELibDrSetObjectId(eobj.SPELibDr)        
            s:eobj.SPEActiveFlag="" eobj.SPEActiveFlag ="N" 
            s obj.SPEActiveFlag = eobj.SPEActiveFlag 
            s:eobj.SPESysFlag="" eobj.SPESysFlag ="N" 
            s obj.SPESysFlag = eobj.SPESysFlag  
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.SPERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopu","User.DHCSpecialPopu","特殊人群字典",id,eobj.SPEDesc,"A",eobj)
                //修改时，日志
                d:eobj.SPERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopu","User.DHCSpecialPopu","特殊人群字典",eobj.SPERowId,eobj.SPEDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群字典","web.DHCBL.KB.DHCSpecialPopu","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群字典","web.DHCBL.KB.DHCSpecialPopu","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
    //q "{success:'true',id:'"_id_"'}"  //返回RowId
}

/// Description：查询特殊人群字典的内容
/// Table：User.DHCSpecialPopu
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopu","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, lib As %String) As %Query(ROWSPEC = "SPERowId:%String,SPECode:%String,SPEDesc:%String,SPEType:%String,SPELibDr:%String,SPEActiveFlag:%String,SPESysFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, lib As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopu).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s SPERowId=rowid
        s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
        s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
        s SPEType=$p($g(^DHCSPEP(SPERowId)),"^",3)
        s LibRowId=$p($g(^DHCSPEP(SPERowId)),"^",4)
        i LibRowId'="" {
            s SPELibDr=$p($g(^DHCPHLIBL(LibRowId)),"^",2)
        }
        else{
            s SPELibDr=""
        }
        s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
        s SPESysFlag=$p($g(^DHCSPEP(SPERowId)),"^",6)
        s:SPEActiveFlag="" SPEActiveFlag="Y"
        s:SPESysFlag="" SPESysFlag="Y"
    
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s SPERowId=0
        for {
            s SPERowId=$o(^DHCSPEP(SPERowId))
            q:SPERowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_SPERowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
                s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
                s SPEType=$p($g(^DHCSPEP(SPERowId)),"^",3)  
                s LibRowId=$p($g(^DHCSPEP(SPERowId)),"^",4)
                i LibRowId'="" {
                    s SPELibDr=$p($g(^DHCPHLIBL(LibRowId)),"^",2)
                }
                else{
                    s SPELibDr=""
                }
                s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
                s SPESysFlag=$p($g(^DHCSPEP(SPERowId)),"^",6)
                s:SPEActiveFlag="" SPEActiveFlag="Y"
        		s:SPESysFlag="" SPESysFlag="Y"
        
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SPEDesc)
                if ($ZCONVERT(SPECode,"U")[code)&(($ZCONVERT(SPEDesc,"U")[desc)||(PINYIN[desc))&((LibRowId=lib)||(lib=""))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SPERowId,SPECode,SPEDesc,SPEType,SPELibDr,SPEActiveFlag,SPESysFlag)
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

///  Description:为combobox查询取数据
/// Table：User.DHCSpecialPopu
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopu","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "SPERowId:%String,SPECode:%String,SPEDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopu).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s SPERowId=rowid
        s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
        s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
        s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
        d:SPEActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s SPERowId=0
        for {
            s SPERowId=$o(^DHCSPEP(SPERowId))
            q:SPERowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_SPERowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
                s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
                s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
                continue:SPEActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SPEDesc)
                if ($ZCONVERT(SPECode,"U")[code)&(($ZCONVERT(SPEDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(SPERowId,SPECode,SPEDesc)
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

/// 获取特殊人群json，动态生成checkbox
/// w ##class(web.DHCBL.KB.DHCSpecialPopu).GetSpecJson()
ClassMethod GetSpecJson() As %String
{
    s json=""
    s SPERowId=0
    for {
            s SPERowId=$o(^DHCSPEP(SPERowId)) q:SPERowId=""
            s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
            s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
            continue:SPEActiveFlag="N"
            s json=json_SPERowId_"^"_SPEDesc_","
    }
    q json
}

/// Description：根据ID删除特殊人群字典的内容
/// Table：User.DHCSpecialPopu
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s SPEPIRowId=0,flag=0
    for
    {
        s SPEPIRowId=$o(^DHCLIBSPEPI(SPEPIRowId)) q:(SPEPIRowId="")||(flag=1)  d
        s SPEPISpecDr=$p($g(^DHCLIBSPEPI(SPEPIRowId)),"^",2)
        i SPEPISpecDr=id
        {
            s flag=1
            s myInfo=myInfo_"<知识库编辑器>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCSpecialPopu).GetRefFlag("7")
/// Description：根据ID删除特殊人群字典的内容
/// Table：User.DHCSpecialPopu
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s re=##class(web.DHCBL.KB.DHCSpecialPopu).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0)
    {
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        //new Entity对象，用于保存日志
        s eobj = ##class(web.Entity.KB.DHCSpecialPopu).%New()
        s pobj = ##class(User.DHCSpecialPopu).%OpenId(id)
        s eobj.SPERowId = id
        s eobj.SPECode=pobj.SPECode
        s eobj.SPEDesc=pobj.SPEDesc
        s eobj.SPEType=pobj.SPEType
        s:pobj.SPELibDr'="" eobj.SPELibDr = pobj.SPELibDr.%Id() 
        s eobj.SPEActiveFlag=pobj.SPEActiveFlag
        s eobj.SPESysFlag=pobj.SPESysFlag
        s sc=##class(User.DHCSpecialPopu).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SpecialPopu","User.DHCSpecialPopu","特殊人群字典",id,eobj.SPEDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群字典","web.DHCBL.KB.DHCSpecialPopu","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Description：查询未选特殊人群字典的列表内容
/// Table：User.DHCSpecialPopu
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCSpecialPopu","GetUnSelPopuList","782","<XJGR>^<SH>^","")
Query GetUnSelPopuList(InstId As %String, PopuStr As %String, desc As %String) As %Query(ROWSPEC = "SPERowId:%String,SPECode:%String,SPEDesc:%String")
{
}

ClassMethod GetUnSelPopuListExecute(ByRef qHandle As %Binary, InstId As %String, PopuStr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCSpecialPopu).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    s selectStr = ##class(web.DHCBL.KB.DHCLibSpecPopuItm).GetPopuDr(InstId)
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s SPERowId=0
    for {
        s SPERowId=$o(^DHCSPEP(SPERowId))
        q:SPERowId=""
        //筛选授权后的数据
        s strRowId="{ID:"_SPERowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) {        
	        s SPEActiveFlag=$p($g(^DHCSPEP(SPERowId)),"^",5)
	        continue:SPEActiveFlag="N"
	        s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
	        s Code = "<"_SPECode_">"
	        s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
	        s SPEDescU=$ZCONVERT(SPEDesc,"U")
	        s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SPEDesc)
	        if ('(selectStr[Code))&('(PopuStr[Code))&((SPEDescU[desc)||(PINYIN[desc)) 
	        {
	            d OutputRowUn
	        }
        }    
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUn
    set Data=$lb(SPERowId,SPECode,SPEDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelPopuListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelPopuListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelPopuListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelPopuListExecute ]
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

}
