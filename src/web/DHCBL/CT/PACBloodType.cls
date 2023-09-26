/// Fuction:血型
/// CreateDate:2020-10-26
/// Creator:sunfengchao
Class web.DHCBL.CT.PACBloodType Extends %RegisteredObject
{

/// Table：血型
/// Input：rowid,code,desc
/// Return: BLDTRowId:BLDTCode:BLDTDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBloodType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BLDTRowId:%String,BLDTCode:%String,BLDTDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    if (rowid'="") //根据rowid返回该条记录
    {
        s BLDTRowId=rowid
        s BLDTCode=$p($g(^PAC("BLDT",BLDTRowId)),"^",1)
        s BLDTDesc=$p($g(^PAC("BLDT",BLDTRowId)),"^",2) 
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s BLDTRowId=0
        for {
            s BLDTRowId=$o(^PAC("BLDT",BLDTRowId))
            q:BLDTRowId=""

            s BLDTCode=$p($g(^PAC("BLDT",BLDTRowId)),"^",1)
            s BLDTDesc=$p($g(^PAC("BLDT",BLDTRowId)),"^",2) 
            
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BLDTDesc) 
            if ($ZCONVERT(BLDTCode,"U")[code)&(($ZCONVERT(BLDTDesc,"U")[desc)||(PINYIN[desc))
            {
                d OutputRow
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(BLDTRowId,BLDTCode,BLDTDesc)
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
/// Table：User.PACBloodType
/// Input：rowid,code,desc
/// Return: BLDTRowId:BLDTCode:BLDTDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBloodType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BLDTRowId:%String,BLDTCode:%String,BLDTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
     
    if (rowid'="") //根据rowid返回该条记录
    {
        s BLDTRowId=rowid
        s BLDTCode=$p($g(^PAC("BLDT",BLDTRowId)),"^",1)
        s BLDTDesc=$p($g(^PAC("BLDT",BLDTRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s BLDTRowId=0
        for 
        {
            s BLDTRowId=$o(^PAC("BLDT",BLDTRowId))
            q:BLDTRowId=""

            s BLDTCode=$p($g(^PAC("BLDT",BLDTRowId)),"^",1)
            s BLDTDesc=$p($g(^PAC("BLDT",BLDTRowId)),"^",2)
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BLDTDesc)
            if ($ZCONVERT(BLDTCode,"U")[code)&(($ZCONVERT(BLDTDesc,"U")[desc)||(PINYIN[desc))
            {
                d OutputRowCmb
            } 
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(BLDTRowId,BLDTCode,BLDTDesc)
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
/// Return:Json格式的字符串{"BLDTCode":"PUBLIC","BLDTDesc":"公共","BLDTRowId":"9"}
/// Other: w ##class(web.DHCBL.CT.PACBloodType).NewOpenData("9")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.PACBloodType).%New()
    s obj = ##class(User.PACBloodType).%OpenId(id)
    s eobj.BLDTRowId=id
    s eobj.BLDTCode= obj.BLDTCode
    s eobj.BLDTDesc= obj.BLDTDesc
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：数据重复验证方法，由js调用
/// Table：User.PACBloodType
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACBloodType).FormValidate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写   
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^PAC("BLDT",0,"Code",code))
    s:desc'="" flagd=$d(^PAC("BLDT",0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^PAC("BLDT",0,"Code",code,0))
        s:desc'="" idd=$o(^PAC("BLDT",0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:    sunfengchao
/// CreatDate:  2018-03-15
/// Description 保存内容
/// Table：     User.PACBloodType
/// Input：     web.Entity.CT.PACBloodType 实体类
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.PACBloodType).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.PACBloodType) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.BLDTRowId,eobj.BLDTCode,eobj.BLDTDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.BLDTRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.PACBloodType).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.PACBloodType).%OpenId(eobj.BLDTRowId)
                s bobj=##class(web.Entity.CT.PACBloodType).%New()
                s bobj.BLDTRowId=eobj.BLDTRowId
                s bobj.BLDTCode=obj.BLDTCode
                s bobj.BLDTDesc = obj.BLDTDesc          //修改描述
            }
            TSTART
            s obj.BLDTCode = eobj.BLDTCode
            s obj.BLDTDesc = eobj.BLDTDesc          //修改描述
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                TCOMMIT
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.BLDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BloodType","User.PACBloodType","血型",id,eobj.BLDTDesc,"A",eobj)
                //修改时，日志
                d:eobj.BLDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BloodType","User.PACBloodType","血型",eobj.BLDTRowId,eobj.BLDTDesc,"U",eobj,bobj)
            }
            else
            {
                TROLLBACK
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("血型","web.DHCBL.CT.PACBloodType","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("血型","web.DHCBL.CT.PACBloodType","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除血型的内容
/// Table：User.PACBloodType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.PACBloodType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(User.PACBloodType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBloodType).%New()
    s eobj.BLDTRowId = id
    s eobj.BLDTCode=pobj.BLDTCode
    s eobj.BLDTDesc=pobj.BLDTDesc
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.PACBloodType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BloodType","User.PACBloodType","血型",id,eobj.BLDTDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("血型","web.DHCBL.CT.PACBloodType","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
