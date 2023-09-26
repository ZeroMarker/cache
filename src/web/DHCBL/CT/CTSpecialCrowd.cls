/// Function:特殊人群  
/// Creator: sunfengchao
/// CreateDate:2018-03-15
Class web.DHCBL.CT.CTSpecialCrowd Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：查询特殊人群的内容
/// Table：User.CTSpecialCrowd
/// Input：rowid,code,desc
/// Return: CTSPECRRowId:CTSPECRCode:CTSPECRDesc:CTSPECRActiveFlag:
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpecialCrowd","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTSPECRRowId:%String,CTSPECRCode:%String,CTSPECRDesc:%String,CTSPECRActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTSPECRRowId=rowid
        s CTSPECRCode=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",1)
        s CTSPECRDesc=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",2)
        s CTSPECRActiveFlag=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",3) 
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s CTSPECRRowId=0
        for {
            s CTSPECRRowId=$o(^CT("CTSPECR",CTSPECRRowId))
            q:CTSPECRRowId=""

            s CTSPECRCode=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",1)
            s CTSPECRDesc=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",2)
            s CTSPECRActiveFlag=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",3) 
            
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTSPECRDesc)
            
            if ($ZCONVERT(CTSPECRCode,"U")[code)&(($ZCONVERT(CTSPECRDesc,"U")[desc)||(PINYIN[desc))
            {
                d OutputRow
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTSPECRRowId,CTSPECRCode,CTSPECRDesc,CTSPECRActiveFlag)
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

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description:为combobox查询取数据
/// Table：User.CTSpecialCrowd
/// Input：rowid,code,desc
/// Return: CTSPECRRowId:CTSPECRCode:CTSPECRDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTSpecialCrowd","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTSPECRRowId:%String,CTSPECRCode:%String,CTSPECRDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTSPECRRowId=rowid
        s CTSPECRCode=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",1)
        s CTSPECRDesc=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",2)
        s CTSPECRActiveFlag=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",3) 
        d:CTSPECRActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
         s CTSPECRRowId=0
        for {
            s CTSPECRRowId=$o(^CT("CTSPECR",CTSPECRRowId))
            q:CTSPECRRowId=""

            s CTSPECRCode=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",1)
            s CTSPECRDesc=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",2)
            s CTSPECRActiveFlag=$p($g(^CT("CTSPECR",CTSPECRRowId)),"^",3)   
            continue:CTSPECRActiveFlag="N"
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTSPECRDesc)
            if ($ZCONVERT(CTSPECRCode,"U")[code)&(($ZCONVERT(CTSPECRDesc,"U")[desc)||(PINYIN[desc))
            {
                d OutputRowCmb
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(CTSPECRRowId,CTSPECRCode,CTSPECRDesc)
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

/// Creator:    sunfengchao
/// CreatDate:  2018-03-15
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串{"CTSPECRActiveFlag":"Y","CTSPECRCode":"PUBLIC","CTSPECRDesc":"公共","CTSPECRRowId":"9"}
/// Other: w ##class(web.DHCBL.CT.CTSpecialCrowd).NewOpenData("9")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.CTSpecialCrowd).%New()
    s obj = ##class(User.CTSpecialCrowd).%OpenId(id)
    s eobj.CTSPECRRowId=id
    s eobj.CTSPECRCode= obj.CTSPECRCode
    s eobj.CTSPECRDesc= obj.CTSPECRDesc
    s eobj.CTSPECRActiveFlag=obj.CTSPECRActiveFlag   
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：数据重复验证方法，由js调用
/// Table：User.CTSpecialCrowd
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTSpecialCrowd).FormValidate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^CT("CTSPECR",0,"Code",code))
    s:desc'="" flagd=$d(^CT("CTSPECR",0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^CT("CTSPECR",0,"Code",code,0))
        s:desc'="" idd=$o(^CT("CTSPECR",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:    sunfengchao
/// CreatDate:  2018-03-15
/// Description 保存内容
/// Table：     User.CTSpecialCrowd
/// Input：     web.Entity.CT.CTSpecialCrowd 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.CTSpecialCrowd).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.CTSpecialCrowd) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.CTSPECRRowId,eobj.CTSPECRCode,eobj.CTSPECRDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.CTSPECRRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.CTSpecialCrowd).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.CTSpecialCrowd).%OpenId(eobj.CTSPECRRowId)
                s bobj=##class(web.Entity.CT.CTSpecialCrowd).%New()
                s bobj.CTSPECRRowId=eobj.CTSPECRRowId
                s bobj.CTSPECRCode=obj.CTSPECRCode
                s bobj.CTSPECRDesc = obj.CTSPECRDesc          //修改描述
                s bobj.CTSPECRActiveFlag = obj.CTSPECRActiveFlag 
            }
            Ts
            s obj.CTSPECRCode = eobj.CTSPECRCode
            s obj.CTSPECRDesc = eobj.CTSPECRDesc          //修改描述
            s:eobj.CTSPECRActiveFlag="" eobj.CTSPECRActiveFlag ="N" 
            s obj.CTSPECRActiveFlag = eobj.CTSPECRActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.CTSPECRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SpecialCrowd","User.CTSpecialCrowd","特殊人群",id,eobj.CTSPECRDesc,"A",eobj)
                //修改时，日志
                d:eobj.CTSPECRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SpecialCrowd","User.CTSpecialCrowd","特殊人群",eobj.CTSPECRRowId,eobj.CTSPECRDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群","web.DHCBL.CT.CTSpecialCrowd","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群","web.DHCBL.CT.CTSpecialCrowd","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除特殊人群的内容
/// Table：User.CTSpecialCrowd
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.CTSpecialCrowd).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(User.CTSpecialCrowd).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTSpecialCrowd).%New()
    s eobj.CTSPECRRowId = id
    s eobj.CTSPECRCode=pobj.CTSPECRCode
    s eobj.CTSPECRDesc=pobj.CTSPECRDesc
    s eobj.CTSPECRActiveFlag=pobj.CTSPECRActiveFlag
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.CTSpecialCrowd).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_SpecialCrowd","User.CTSpecialCrowd","特殊人群",id,eobj.CTSPECRDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("特殊人群","web.DHCBL.CT.CTSpecialCrowd","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
