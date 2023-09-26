Class web.DHCBL.KB.DHCExamineFeild Extends %RegisteredObject
{

/// Creator:石萧伟
/// CreatDate:2018-08-01
/// Description:查询 检查结果
/// Input:desc
Query GetNewDataForCmb1(rowid As %String, q As %String) As %Query(ROWSPEC = "ExaRowId:%String,ExaResult:%String")
{
}

ClassMethod GetNewDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s ExaRowId=rowid
        s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
        s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
        d:ExaActiveFlag="Y" OutputRowCmbNew
    }
    else
    {

        s:q'="" q=$ZCONVERT(q,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCExamineFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s ExaRowId=0
        for
        {
            s ExaRowId=$o(^DHCEXAMINE(ExaRowId)) q:ExaRowId=""
            s strRowId="{ID:"_ExaRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
                continue:ExaActiveFlag="N"
                s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
                s ExaResult1=$ZCONVERT(ExaResult,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ExaResult1))
                i (ExaResult1[q)||(PINYIN[q)
                {
                    d OutputRowCmbNew
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmbNew
    set Data=$lb(ExaRowId,ExaResult)
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
/// Description：查询检查结果字典表内容
/// Table：User.DHCExamineFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExamineFeild","GetList","","","","","")
Query GetList(rowid, code, desc, lib) As %Query(ROWSPEC = "ExaRowId,ExaCode,ExaResult,ExaActiveFlag,ExaLibDr,PHLIDesc,ExaSysFlag,ExaDataPool")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCExamineFeild).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ExaRowId=rowid
        s ExaCode=$p($g(^DHCEXAMINE(ExaRowId)),"^",1)  //代码
        s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)  //描述
        s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
        s ExaLibDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",3)  //知识库标识DR
        s:ExaLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(ExaLibDr)),"^",2) //知识库标识名称
        s ExaSysFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",5)  //是否系统标识
        s:ExaActiveFlag="" ExaActiveFlag="Y"
        s:ExaSysFlag="" ExaSysFlag="Y"
        
        s ExaDataPool=$p($g(^DHCEXAMINE(ExaRowId)),"^",6)  //数据池标识
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s:lib'="" lib=$ZCONVERT(lib,"U")
        s ExaRowId=0
        for  
        {   
            s ExaRowId=$o(^DHCEXAMINE(ExaRowId)) q:ExaRowId="" 
            s strRowId = "{ID:"_ExaRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s ExaCode=$p($g(^DHCEXAMINE(ExaRowId)),"^",1)  //代码
                s ExaCodeU=$ZCONVERT(ExaCode,"U")
                s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)  //描述
                s ExaResultU=$ZCONVERT(ExaResult,"U")
                s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
                s ExaLibDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",3)  //知识库标识DR
                s ExaLibDrU=$ZCONVERT(ExaLibDr,"U")
                s:ExaLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(ExaLibDr)),"^",2) //知识库标识名称
                s ExaSysFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",5)  //是否系统标识
                s:ExaActiveFlag="" ExaActiveFlag="Y"
        		s:ExaSysFlag="" ExaSysFlag="Y"
        
                s ExaDataPool=$p($g(^DHCEXAMINE(ExaRowId)),"^",6)  //数据池标识
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ExaResultU))
                i (ExaCodeU[code)&((ExaResultU[desc)||(PINYIN[desc))&((ExaLibDrU=lib)||(lib=""))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ExaRowId,ExaCode,ExaResult,ExaActiveFlag,ExaLibDr,PHLIDesc,ExaSysFlag,ExaDataPool)
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
/// CreatDate:2014-11-11
/// Description:查询 检查结果
/// Input:desc
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ExaRowId:%String,ExaResult:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s ExaRowId=rowid
        s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
        s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
        d:ExaActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCExamineFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s ExaRowId=0
        for
        {
            s ExaRowId=$o(^DHCEXAMINE(ExaRowId)) q:ExaRowId=""
            s strRowId="{ID:"_ExaRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
                continue:ExaActiveFlag="N"
                s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)
                s ExaResult1=$ZCONVERT(ExaResult,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(ExaResult1))
                i (ExaResult1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ExaRowId,ExaResult)
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
/// w ##class(web.DHCBL.KB.DHCExamineFeild).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCEXAMINEi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCEXAMINEi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCEXAMINEi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCEXAMINEi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCExamineFeild
/// Input：web.Entity.KB.DHCExamineFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCExamineFeild) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.ExaRowId,eobj.ExaCode,eobj.ExaResult)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.ExaRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCExamineFeild).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCExamineFeild).%OpenId(eobj.ExaRowId)
                s bobj = ##class(web.Entity.KB.DHCExamineFeild).%New()
                s bobj.ExaRowId = eobj.ExaRowId
                s bobj.ExaCode = obj.ExaCode
                s bobj.ExaResult = obj.ExaResult
                s:obj.ExaLibDr'="" bobj.ExaLibDr = obj.ExaLibDr.%Id()
                s bobj.ExaActiveFlag=  obj.ExaActiveFlag
                s bobj.ExaSysFlag = obj.ExaSysFlag
            }
    
            s obj.ExaCode = eobj.ExaCode
            s obj.ExaResult = eobj.ExaResult
            d:eobj.ExaLibDr'="" obj.ExaLibDrSetObjectId(eobj.ExaLibDr)
            d:eobj.ExaLibDr="" obj.ExaLibDrSetObjectId("")   
            i eobj.ExaActiveFlag="Y"
            {
                s obj.ExaActiveFlag = "Y"
            }
            else
            {
                s obj.ExaActiveFlag = "N"
            }
            i eobj.ExaSysFlag="Y"
            {
                s obj.ExaSysFlag = "Y"
            }
            else
            {
                s obj.ExaSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.ExaRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExamineFeild","User.DHCExamineFeild","检查结果字典",id,eobj.ExaResult,"A",eobj)
                d:eobj.ExaRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExamineFeild","User.DHCExamineFeild","检查结果字典",eobj.ExaRowId,eobj.ExaResult,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查结果字典","web.DHCBL.KB.DHCExamineFeild","SaveData",eobj)
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
/// Table：User.DHCExamineFeild
/// Other: d ##class(web.DHCBL.KB.DHCExamineFeild).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCExamineFeild).%New()
    s pobj = ##class(User.DHCExamineFeild).%OpenId(id)
    s eobj.ExaRowId = id
    s eobj.ExaCode = pobj.ExaCode
    s eobj.ExaResult = pobj.ExaResult
    s:pobj.ExaLibDr'="" eobj.ExaLibDr = pobj.ExaLibDr.%Id()
    s:pobj.ExaActiveFlag="Y" eobj.ExaActiveFlag="true"
    s:pobj.ExaSysFlag="Y" eobj.ExaSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-08
/// Description：获取修改时的记录
/// Table：User.DHCExamineFeild
/// Other: d ##class(web.DHCBL.KB.DHCExamineFeild).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCExamineFeild).%New()
    s pobj = ##class(User.DHCExamineFeild).%OpenId(id)
    s eobj.ExaRowId = id
    s eobj.ExaCode = pobj.ExaCode
    s eobj.ExaResult = pobj.ExaResult
    s:pobj.ExaLibDr'="" eobj.ExaLibDr = pobj.ExaLibDr.%Id()
    s eobj.ExaActiveFlag=pobj.ExaActiveFlag
    s eobj.ExaSysFlag=pobj.ExaSysFlag  
	s:eobj.ExaActiveFlag="" eobj.ExaActiveFlag="Y"
    s:eobj.ExaSysFlag="" eobj.ExaSysFlag="Y"  
    
    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-11-11
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    i $d(^DHCSPEP(0,"EXA",id)){
        s myInfo=myInfo_"<特殊人群与检查结果关联表>"
    }
    
    s EXAIRowId=0,flag=0
    for
    {
        s EXAIRowId=$o(^DHCLIBEXAI(EXAIRowId)) q:(EXAIRowId="")||(flag=1)  d
        s EXAIExamDr=$p($g(^DHCLIBEXAI(EXAIRowId)),"^",2)
        i EXAIExamDr=id
        {
            s flag=1
            s myInfo=myInfo_"<检查结果业务表>"
        }
    }       
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCExamineFeild
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCExamineFeild).DeleteData("2")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    
    s re=##class(web.DHCBL.KB.DHCExamineFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCExamineFeild).%New()
        s pobj = ##class(User.DHCExamineFeild).%OpenId(id)
        s eobj.ExaRowId = id
        s eobj.ExaCode = pobj.ExaCode
        s eobj.ExaResult = pobj.ExaResult
        s:pobj.ExaLibDr'="" eobj.ExaLibDr = pobj.ExaLibDr.%Id() 
        s eobj.ExaActiveFlag = pobj.ExaActiveFlag
        s eobj.ExaSysFlag = pobj.ExaSysFlag
    
        s sc=##class(User.DHCExamineFeild).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExamineFeild","User.DHCExamineFeild","检查结果字典",id,eobj.ExaResult,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查结果字典","web.DHCBL.KB.DHCExamineFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// Description：查询未选检查结果的列表内容
/// Table：User.DHCExamineFeild
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExamineFeild","GetUnSelExamList","","")
Query GetUnSelExamList(InstId As %String, examStr As %String, desc As %String) As %Query(ROWSPEC = "ExaRowId,ExaCode,ExaResult,ExaActiveFlag,ExaSysFlag,ExaLibDr,PHLIDesc")
{
}

ClassMethod GetUnSelExamListExecute(ByRef qHandle As %Binary, InstId As %String, examStr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    	s AuStr=##class(web.DHCBL.Authorize.DHCExamineFeild).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s selectStr = ##class(web.DHCBL.KB.DHCLibExaItm).GetExamDr(InstId)
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s ExaRowId=0
        for {
            s ExaRowId=$o(^DHCEXAMINE(ExaRowId)) q:ExaRowId=""
            s strRowId = "{ID:"_ExaRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
	            s ExaCode=$p($g(^DHCEXAMINE(ExaRowId)),"^",1)  //代码
	            s Code = "<"_ExaCode_">"
	            s ExaResult=$p($g(^DHCEXAMINE(ExaRowId)),"^",2)  //描述
	            s ExaResultU=$ZCONVERT(ExaResult,"U")
	            s ExaActiveFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",4)  //是否可用
	            continue:ExaActiveFlag="N"
	            s ExaLibDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",3)  //知识库标识DR
	            s:ExaLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(ExaLibDr)),"^",2) //知识库标识名称
	            continue:PHLIDesc'="心电"
	            s ExaSysFlag=$p($g(^DHCEXAMINE(ExaRowId)),"^",5)  //是否系统标识
	            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ExaResult)
	            if ('(selectStr[Code))&('(examStr[Code))&((ExaResultU[desc)||(PINYIN[desc)) //2016-08-09
	            {
	                d OutputRowUnSel
	            }
            }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUnSel
    set Data=$lb(ExaRowId,ExaCode,ExaResult,ExaActiveFlag,ExaSysFlag,ExaLibDr,PHLIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelExamListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelExamListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelExamListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelExamListExecute ]
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
