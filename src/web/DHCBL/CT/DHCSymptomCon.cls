Import SQLUser

/// 名称: 症状分级关联表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-5-16
Class web.DHCBL.CT.DHCSymptomCon Extends %RegisteredObject
{

/// Description：保存症状分级关联表字典的内容
/// Table：User.DHCSymptomCon
/// Input：fieldStr，levDr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.DHCSymptomCon).SaveData()
ClassMethod SaveData(fieldStr As %String, levDr As %String) As %String
{

    s result=""

    s argsLen=$Length(fieldStr,"^")
    s fieldDr="",SYCRowId=""
    for i=1:1:argsLen
    {
      s fieldDr=$p(fieldStr,"^",i)
        
      s SYCRowId=$o(^DHCSYMCONi(0,levDr,fieldDr,0))
      if (SYCRowId="")
      {

        s obj=##class(User.DHCSymptomCon).%New()
        d:levDr'="" obj.SYCLevDrSetObjectId(levDr)
        d:fieldDr'="" obj.SYCFieldDrSetObjectId(fieldDr)
        s:levDr'="" obj.SYCSequence=$o(^DHCSYMCONi(0,"SEQ",levDr,""),-1)+1
        s:levDr="" obj.SYCSequence=0
        //s:fieldDr'="" obj.SYCSequence=fieldDr    //顺序
        

        ;用药频率json
        s logJson="{SYCLevDr:"_$c(34)_levDr_$C(34)_",SYCFieldDr:"_$C(34)_fieldDr_$c(34)_"}"
        TS
        s sc=obj.%Save()
        d obj.%Close()  
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"   
            s fieldDrDesc=""
            s:fieldDr'="" fieldDrDesc=$P($g(^DHCSYMFEI(fieldDr)),"^",2)   
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_SymptomCon","User.DHCSymptomCon","症状分级关联表",id,fieldDrDesc,"A",logJson) 
        }
        else
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"_'}"    //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状分级关联表","web.DHCBL.CT.DHCSymptomCon","SaveData",logJson)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }           
      }
      else
      {
        s result="{success:'true',info:'已经保存'}"
      }
    }
    q result
}

/// Description：根据ID删除症状分级关联表的内容
/// Table：User.DHCSymptomCon
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result = ""
    //new Entity对象，用于保存日志
    s pobj=##class(User.DHCSymptomCon).%OpenId(id)
    s eobj = ##class(web.Entity.CT.DHCSymptomCon).%New()
    s eobj.SYCRowId = id
    if $IsObject(pobj.SYCLevDr)
    {
        s eobj.SYCLevDr=pobj.SYCLevDr.%Id()
    }
    if $IsObject(pobj.SYCFieldDr)
    {
        s eobj.SYCFieldDr=pobj.SYCFieldDr.%Id()
    }
    s eobj.SYCSequence=pobj.SYCSequence 
    s fieldDesc=$p($g(^DHCSYMFEI(eobj.SYCFieldDr)),"^",2)
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(User.DHCSymptomCon).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LabItmResult","User.DHCSymptomCon","症状分级关联表",id,fieldDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    }
    q result
}

/// Description：查询症状分级关联表的内容
/// Table：User.DHCSymptomCon
/// Input：rowid,lev
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCSymptomCon","GetList","","1","","")
Query GetList(rowid As %String, lev As %String) As %Query(ROWSPEC = "SYCRowId:%String,SYCLevDr:%String,SYCFieldDr:%String,SYCSequence:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, lev As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    
    if (rowid'="") //根据rowid返回该条记录
    {
        
        s SYCRowId=rowid
        s SYCLevDr=$LISTGET($G(^User.DHCSymptomLevD(lev)),3)
        s FieldRowId=$p($g(^DHCSYMCON(SYCRowId)),"^",2)

        i FieldRowId'="" 
        {
            s SYCFieldDr=$p($g(^DHCSYMFEI(FieldRowId)),"^",2)
        }
        else 
        {
            s SYCFieldDr=""
        }

        d OutputRow
        
    }
    else
    {
        s FieldRowId=0
        for 
        {
            s FieldRowId=$o(^DHCSYMCONi(0,lev,FieldRowId)) q:FieldRowId=""
            s SYCLevDr=$LISTGET($G(^User.DHCSymptomLevD(lev)),3)
            s SYCRowId="",SYCFieldDr="",SYCSequence=""
            i FieldRowId'="" 
            {
                s SYCFieldDr=$p($g(^DHCSYMFEI(FieldRowId)),"^",2)
                s SYFActiveFlag=$p($g(^DHCSYMFEI(FieldRowId)),"^",3)
                continue:SYFActiveFlag'="Y"
                s SYCRowId=$o(^DHCSYMCONi(0,lev,FieldRowId,0))
                s:SYCRowId'="" SYCSequence=$p($g(^DHCSYMCON(SYCRowId)),"^",3)
            }
            
            d OutputRow

        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(SYCRowId,SYCLevDr,SYCFieldDr,SYCSequence)
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

/// Description：保存上移下移的顺序
/// Other: d ##class(web.DHCBL.CT.DHCSymptomCon).SaveOrder()
ClassMethod SaveOrder(checkId, changeId) As %String
{
    s $zt="ERROE"
    s result=""

    if ((checkId'="")&(changeId'=""))
    {
        
        //先保存选中行的顺序
        s obj1=##class(User.DHCSymptomCon).%OpenId(checkId)
        s obj2=##class(User.DHCSymptomCon).%OpenId(changeId)
        s OrderNum1=obj1.SYCSequence
        s OrderNum2=obj2.SYCSequence
        s obj1.SYCSequence=OrderNum2
        s obj2.SYCSequence=OrderNum1

        TS
        s sc1=obj1.%Save()
        s sc2=obj2.%Save()
        d obj1.%Close()
        d obj2.%Close()
        s sc=sc1&sc2
        If $$$ISOK(sc)
        {
            Tc
            s result = "{success:'true'}"  
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        }
    }    
    else
    {
        s result = "{success:'true'}"
    }
    q result
ERROE
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
