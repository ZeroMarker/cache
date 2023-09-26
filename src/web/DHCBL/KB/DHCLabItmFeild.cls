Import SQLUser

/// 名称: 检验条目字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.DHCBL.KB.DHCLabItmFeild Extends %RegisteredObject
{

/// 石萧伟
/// Description：为combobox查询取数据
/// Table：User.DHCLabItmFeild
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLabItmFeild","GetDataForCmb1","","","")
Query GetNewDataForCmb1(rowid As %String, code As %String, q As %String) As %Query(ROWSPEC = "PHLFRowId:%String,PHLFCode:%String,PHLFDesc:%String")
{
}

ClassMethod GetNewDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCLabItmFeild).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLFRowId=rowid
        s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
        s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
        s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
        d:PHLFActiveFlag="Y" OutputRowCmbNew
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:q'="" desc=$ZCONVERT(q,"U") //转换成大写
        s PHLFRowId=0
        for {
            s PHLFRowId=$o(^DHCLABIF(PHLFRowId))
            q:PHLFRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHLFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
                s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
                s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
                continue:PHLFActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLFDesc)
                if ($ZCONVERT(PHLFCode,"U")[code)&(($ZCONVERT(PHLFDesc,"U")[q)||(PINYIN[q))
                {
                    d OutputRowCmbNew
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmbNew
    set Data=$lb(PHLFRowId,PHLFCode,PHLFDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetNewDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Description：修改时打开的数据
/// Table：User.DHCLabItmFeild
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCLabItmFeild).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCLabItmFeild).%New()
    s eobj.PHLFRowId=id
    s eobj.PHLFCode=$p($g(^DHCLABIF(id)),"^",1)
    s eobj.PHLFDesc=$p($g(^DHCLABIF(id)),"^",2)
    s eobj.PHLFActiveFlag=$p($g(^DHCLABIF(id)),"^",3)
    s eobj.PHLFSysFlag=$p($g(^DHCLABIF(id)),"^",4)
    
    s:eobj.PHLFActiveFlag="Y" eobj.PHLFActiveFlag="true" 
    s:eobj.PHLFSysFlag="Y" eobj.PHLFSysFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：HISUI修改时打开的数据
/// Table：User.DHCLabItmFeild
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCLabItmFeild).NewOpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCLabItmFeild).%New()
    s eobj.PHLFRowId=id
    s eobj.PHLFCode=$p($g(^DHCLABIF(id)),"^",1)
    s eobj.PHLFDesc=$p($g(^DHCLABIF(id)),"^",2)
    s eobj.PHLFActiveFlag=$p($g(^DHCLABIF(id)),"^",3)
    s eobj.PHLFSysFlag=$p($g(^DHCLABIF(id)),"^",4)
    
    s:eobj.PHLFActiveFlag="" eobj.PHLFActiveFlag="Y" 
    s:eobj.PHLFSysFlag="" eobj.PHLFSysFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCLabItmFeild
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCLABIF(0,"Code",code))
    s:desc'="" flagd=$d(^DHCLABIF(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCLABIF(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCLABIF(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存检验条目字典的内容
/// Table：User.DHCLabItmFeild
/// Input：web.Entity.KB.DHCLabItmFeild 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCLabItmFeild).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCLabItmFeild) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.PHLFRowId,eobj.PHLFCode,eobj.PHLFDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.PHLFRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCLabItmFeild).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCLabItmFeild).%OpenId(eobj.PHLFRowId)
                s bobj=##class(web.Entity.KB.DHCLabItmFeild).%New()
                s bobj.PHLFRowId=eobj.PHLFRowId
                s bobj.PHLFCode=obj.PHLFCode
                s bobj.PHLFDesc = obj.PHLFDesc          //修改描述
                s bobj.PHLFActiveFlag = obj.PHLFActiveFlag 
                s bobj.PHLFSysFlag = obj.PHLFSysFlag
            }
            Ts
            s obj.PHLFCode = eobj.PHLFCode
            s obj.PHLFDesc = eobj.PHLFDesc          //修改描述
            s:eobj.PHLFActiveFlag="" eobj.PHLFActiveFlag ="N" 
            s obj.PHLFActiveFlag = eobj.PHLFActiveFlag 
            s:eobj.PHLFSysFlag="" eobj.PHLFSysFlag ="N" 
            s obj.PHLFSysFlag = eobj.PHLFSysFlag    
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.PHLFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmFeild","User.DHCLabItmFeild","检验条目字典",id,eobj.PHLFDesc,"A",eobj)
                //修改时，日志
                d:eobj.PHLFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmFeild","User.DHCLabItmFeild","检验条目字典",eobj.PHLFRowId,eobj.PHLFDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验条目字典","web.DHCBL.KB.DHCLabItmFeild","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验条目字典","web.DHCBL.KB.DHCLabItmFeild","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询检验条目字典的内容
/// Table：User.DHCLabItmFeild
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLabItmFeild","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHLFRowId:%String,PHLFCode:%String,PHLFDesc:%String,PHLFActiveFlag:%String,PHLFSysFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCLabItmFeild).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLFRowId=rowid
        s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
        s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
        s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
        s PHLFSysFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",4)
    	
    	s:PHLFActiveFlag="" PHLFActiveFlag="Y"
        s:PHLFSysFlag="" PHLFSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s PHLFRowId=0
        for {
            s PHLFRowId=$o(^DHCLABIF(PHLFRowId))
            q:PHLFRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHLFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
                s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
                s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
                s PHLFSysFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",4)
                s:PHLFActiveFlag="" PHLFActiveFlag="Y"
        		s:PHLFSysFlag="" PHLFSysFlag="Y"
        
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLFDesc)
                if ($ZCONVERT(PHLFCode,"U")[code)&(($ZCONVERT(PHLFDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHLFRowId,PHLFCode,PHLFDesc,PHLFActiveFlag,PHLFSysFlag)
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
/// Table：User.DHCLabItmFeild
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCLabItmFeild","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHLFRowId:%String,PHLFCode:%String,PHLFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCLabItmFeild).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLFRowId=rowid
        s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
        s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
        s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
        d:PHLFActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s PHLFRowId=0
        for {
            s PHLFRowId=$o(^DHCLABIF(PHLFRowId))
            q:PHLFRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHLFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHLFCode=$p($g(^DHCLABIF(PHLFRowId)),"^",1)
                s PHLFDesc=$p($g(^DHCLABIF(PHLFRowId)),"^",2)
                s PHLFActiveFlag=$p($g(^DHCLABIF(PHLFRowId)),"^",3)
                continue:PHLFActiveFlag="N"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLFDesc)
                if ($ZCONVERT(PHLFCode,"U")[code)&(($ZCONVERT(PHLFDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHLFRowId,PHLFCode,PHLFDesc)
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
/// CreatDate:2014-11-7
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    if $d(^DHCSPEP(0,"LAB",id))
    {
        s myInfo=myInfo_"<特殊人群与指标关联字典>"
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除检验条目字典的内容
/// Table：User.DHCLabItmFeild
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=##class(web.DHCBL.KB.DHCLabItmFeild).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0)
    {
        s pobj = ##class(User.DHCLabItmFeild).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCLabItmFeild).%New()
        s eobj.PHLFRowId = id
        s eobj.PHLFCode=pobj.PHLFCode
        s eobj.PHLFDesc=pobj.PHLFDesc
        s eobj.PHLFActiveFlag=pobj.PHLFActiveFlag
        s eobj.PHLFSysFlag=pobj.PHLFSysFlag

        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCLabItmFeild).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmFeild","User.DHCLabItmFeild","检验条目字典",id,eobj.PHLFDesc,"D",eobj)
            d eobj.%Close()
        }
        else
        {
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检验条目字典","web.DHCBL.KB.DHCLabItmFeild","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }   
    }
    else
    {
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
