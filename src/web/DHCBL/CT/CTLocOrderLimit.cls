/// Function: 科室开医嘱限制
/// CreateDate:2019-11-08
/// Creator: sunfengchao
Class web.DHCBL.CT.CTLocOrderLimit Extends %RegisteredObject
{

/// Creator：sunfengchao
/// CreatDate: 2019-11-09
/// Description：查询科室开医嘱限制的内容
/// Table：  User.CTLocOrderLimit
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocOrderLimit","GetList","314","")
Query GetList(ParRef As %String, rowid As %String, ARCIMDR As %String) As %Query(ROWSPEC = "OrderLimtRowId,CTLocDesc,OrderLimtARCItmMastDR,ARCIMCode,ARCIMDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, ARCIMDR As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s OrderLimtRowId=rowid
        s OrderLimtParRef=$p(rowid,"||",1)
        s OrderLimtChildsub=$p(rowid,"||",2)
        s OrderLimtARCItmMastDR=$p($g(^CTLOC(OrderLimtParRef,"OrderLimit",OrderLimtChildsub)),"^",1) 
        s ARCIMCode=""
        s CTLocDesc=""
        if OrderLimtARCItmMastDR'="" 
        {
            s ARCIMCode=$p($g(^ARCIM($p(OrderLimtARCItmMastDR,"||",1),$p(OrderLimtARCItmMastDR,"||",2),1)),"^",1)  
            s ARCIMDesc=$p($g(^ARCIM($p(OrderLimtARCItmMastDR,"||",1),$p(OrderLimtARCItmMastDR,"||",2),1)),"^",2) 
        }
        s CTLocDesc=$P($g(^CTLOC(OrderLimtParRef)),"^",2)
        d OutputRow 
    }
    else
    { 
        s OrderLimtParRef=ParRef
        s OrderLimtChildsub=0
        for
        {
            s OrderLimtChildsub=$o(^CTLOC(OrderLimtParRef,"OrderLimit",OrderLimtChildsub)) 
            q:OrderLimtChildsub=""   
            s OrderLimtRowId=OrderLimtParRef_"||"_OrderLimtChildsub
            s OrderLimtARCItmMastDR=$p($g(^CTLOC(OrderLimtParRef,"OrderLimit",OrderLimtChildsub)),"^",1) 
            s ARCIMCode=""
            s ARCIMDesc=""
            if OrderLimtARCItmMastDR'="" 
            {
                s ARCIMCode=$p($g(^ARCIM($p(OrderLimtARCItmMastDR,"||",1),$p(OrderLimtARCItmMastDR,"||",2),1)),"^",1)  
                s ARCIMDesc=$p($g(^ARCIM($p(OrderLimtARCItmMastDR,"||",1),$p(OrderLimtARCItmMastDR,"||",2),1)),"^",2) 
            }
           s CTLocDesc=""
           if (ARCIMDR=OrderLimtARCItmMastDR) ||(ARCIMDR="")
           {
                s CTLocDesc=$P($g(^CTLOC(OrderLimtParRef)),"^",2)
                d OutputRow
           }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(OrderLimtRowId,CTLocDesc,OrderLimtARCItmMastDR,ARCIMCode,ARCIMDesc)
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

/// Creator：  sunfengchao
/// CreatDate: 2019-11-09
/// Description:删除科室开医嘱限制
/// Table：    User.CTLocOrderLimit
/// Input：    id
/// Return：   成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
    s result=""
    s eobj = ##class(web.Entity.CT.CTLocOrderLimit).%New()
    s pobj = ##class(User.CTLocOrderLimit).%OpenId(id)
    s eobj.OrderLimtParRef = pobj.OrderLimtParRef.%Id()
    s eobj.OrderLimtARCItmMastDR = pobj.OrderLimtARCItmMastDR.%Id()
    s CTLOCDesc=$p($g(^CTLOC(eobj.OrderLimtParRef)),"^",2)   
    s ARCIMDesc= $p($g(^ARCIM($p(eobj.OrderLimtARCItmMastDR,"||",1),$p(eobj.OrderLimtARCItmMastDR,"||",2),1)),"^",2)
    s sc=##class(User.CTLocOrderLimit).%DeleteId(id)
    if $$$ISOK(sc)
    {
        s result= "{success:'true',info:'删除成功！'}"   
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc_OrderLimit","User.CTLocOrderLimit","科室开医嘱限制",id,CTLOCDesc_"->"_ARCIMDesc,"D",eobj)

    }
    else 
    {
        s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室开医嘱限制","web.DHCBL.CT.CTLocOrderLimit","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
    }
    q result
}

/// Description：数据重复验证方法
/// Creator：sunfengchao
/// CreatDate: 2019-11-8 
/// Table：User.CTLocOrderLimit
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:  w ##class(web.DHCBL.CT.CTLocOrderLimit).Validate("","","")
ClassMethod Validate(OrderLimtParRef As %String, OrderLimtRowId As %String, ARCIMDR As %String) As %String
{
 
    s flag="",flagc="" 
    if (OrderLimtRowId="")&(OrderLimtParRef'="") //如果为空,增加时的重复判断
    {
        s flagc=$d(^CTLOC(OrderLimtParRef,"OrderLimit",0,"ARCMastDR",ARCIMDR))
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：保存修改科室开医嘱限制的内容
/// Table：User.CTLocOrderLimit
/// Input：web.Entity.CT.CTLocOrderLimit 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTLocOrderLimit).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocOrderLimit) As %String
{
    s ^TMPA111=eobj.OrderLimtParRef_","_eobj.OrderLimtARCItmMastDR
    s result="" 
    s flag=  ..Validate(eobj.OrderLimtParRef,eobj.OrderLimtRowId,eobj.OrderLimtARCItmMastDR)  //调用重复验证 
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        Ts
        s obj=##class(User.CTLocOrderLimit).%New(eobj.OrderLimtParRef) 
        d:eobj.OrderLimtParRef'="" obj.OrderLimtParRefSetObjectId(eobj.OrderLimtParRef)
        d obj.OrderLimtARCItmMastDRSetObjectId(eobj.OrderLimtARCItmMastDR)  
        s CTLOCDesc1=$p($g(^CTLOC(eobj.OrderLimtParRef)),"^",2)   
        s CTLOCDesc2=$p($g(^ARCIM($p(eobj.OrderLimtARCItmMastDR,"||",1),$p(eobj.OrderLimtARCItmMastDR,"||",2),1)),"^",2) 
        s sc=obj.%Save() 
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result= "{success:'true',id:'"_id_"'}"         //返回RowId
            d:eobj.OrderLimtRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc_OrderLimit","User.CTLocOrderLimit","科室开医嘱限制",id,CTLOCDesc1_"->"_CTLOCDesc2,"A",eobj)
        }
        else
        {
            Trollback
            s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室开医嘱限制","web.DHCBL.CT.CTLocOrderLimit","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    } 
    q result
}

/// Function:判断某个医嘱项在科室下是否受限制
/// CreatDate:2019-12-31
/// Creator:sunfengchao
/// Input:  CTLocID 科室id,OrderId 医嘱id
/// Output: 0 不受限  1 受限
/// Others: w ##class(web.DHCBL.CT.CTLocOrderLimit).GetOrderLimtFlag("1","1||1")
ClassMethod GetOrderLimtFlag(CTLocID As %String, OrderId As %String) As %String
{
    s return=0
    q:(CTLocID="")||(OrderId="") return
    if ($d(^CTLOC(CTLocID,"OrderLimit",0,"ARCMastDR",OrderId))) s return=1
    q return
}

}
