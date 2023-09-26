Class web.DHCWLHSQuery Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      yuanxu
/// CreatDate：    2016-1-14
/// Description:： 根据维度取出该维度下的大组或子组
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       dimCode:维度类型CODE type:G大组;SG子组
/// Output：      id,Code,Desc
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetGrpListByDimCode","CTLOC")
/// 
Query GetGrpListByDimCode(dimCode As %String) As %Query(ROWSPEC = "hs,id:%String,Code:%String,Desc:%String,dimCode,kpiRule") [ SqlProc ]
{
}

ClassMethod GetGrpListByDimCodeExecute(ByRef qHandle As %Binary, dimCode As %String) As %Status
{
    n (qHandle,dimCode,kpiRule)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:(dimCode="") $$$OK
    s hs=$case(dimCode,"CTLOC":"全部科室","TAREC":"核算子分类","TARAC":"会计子分类","TARIC":"住院子分类","TAROC":"门诊子分类","TARSC":"收费子分类","TARMC":"病案子分类")
    i dimCode="CTLOC" s id="",Code=hs,Desc=hs
    e  s id="",Code=dimCode,Desc=hs
    d OutPutRow
    s dimCode=$ZCVT(dimCode,"U")
    s dimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",dimCode,""))
    q:dimId="" $$$OK
    s id="" f  s id=$o(^DHCWL.CodeCfg.GroupI("DimDr",dimId,id)) q:id=""  d
    .s Code=$li(^DHCWL.CodeCfg.GroupD(id),2)
    .s Desc=$li(^DHCWL.CodeCfg.GroupD(id),3)
    .s hs=$case(dimCode,"CTLOC":"科室子组","TAREC":"核算分类子组","TARAC":"会计分类子组","TARIC":"住院分类子组","TAROC":"门诊分类子组","TARSC":"收费分类子组","TARMC":"病案分类子组")
    .d OutPutRow
    s id="" f  s id=$o(^DHCWL.CodeCfg.ItemGroupI("DimDr",dimId,id)) q:id=""  d
    .s Code=$li(^DHCWL.CodeCfg.ItemGroupD(id),2)
    .s Desc=$li(^DHCWL.CodeCfg.ItemGroupD(id),3)
    .s hs=$case(dimCode,"CTLOC":"科室大组","TAREC":"核算分类大组","TARAC":"会计分类大组","TARIC":"住院分类大组","TAROC":"门诊分类大组","TARSC":"收费分类大组","TARMC":"病案分类大组")
    .d OutPutRow
    s kpiRule="KPHS0001,KPHS0002,KPHS0003,KPHS0004,KPHS0005,KPHS0006,KPHS0007,KPHS0008"
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutPutRow
    s Data=$lb(hs,id,Code,Desc,dimCode,kpiRule)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetGrpListByDimCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpListByDimCodeExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetGrpListByDimCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpListByDimCodeExecute ]
{
    n (AtEnd,qHandle,Row)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2016-1-14
/// Description:： 根据统计子组code 取出明细数据
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       
/// Output：     子组描述、code、顺序、明细科室id
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetSubGrpDetailByDimCode","Loctext")
/// 子组描述、code、顺序、明细科室id
Query GetSubGrpDetailByDimCode(dimCode As %String) As %Query(ROWSPEC = "subgrpDesc,subgrpCode,subgrpSort,locdr") [ SqlProc ]
{
}

ClassMethod GetSubGrpDetailByDimCodeExecute(ByRef qHandle As %Binary, dimCode As %String) As %Status
{
    n (qHandle,dimCode,type)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:(dimCode="") $$$OK
    s dimCode=$zcvt(dimCode,"U")
    s subGrpList=""
    s grpId=0 f  s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_dimCode,grpId)) q:grpId=""  d
    .s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
    ..s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
    ..s subgrpDesc=value.SGrpDesc
    ..s subgrpCode=value.SGrpCode
    ..s subgrpSort=value.SGrpSort
    ..s itemid="" f  s itemid=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,itemid)) q:itemid=""  d
    ...s locdr=$p(itemid," ",2)
    ...d OutPutRow1
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutPutRow1
    s Data=$lb(subgrpDesc,subgrpSort,locdr)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetSubGrpDetailByDimCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubGrpDetailByDimCodeExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSubGrpDetailByDimCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubGrpDetailByDimCodeExecute ]
{
    n (AtEnd,qHandle,Row)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2016-1-14
/// Description:： 根据统计大组code 取出明细数据
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       
/// Output：     明细科室id\描述、顺序
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetGrpDetailByDimCode","LCKS")
/// 明细科室id\描述、顺序
Query GetGrpDetailByDimCode(dimCode As %String) As %Query(ROWSPEC = "locdr,locdesc,subgrpSort") [ SqlProc ]
{
}

ClassMethod GetGrpDetailByDimCodeExecute(ByRef qHandle As %Binary, dimCode As %String) As %Status
{
    n (qHandle,dimCode,type)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:(dimCode="") $$$OK
    s dimCode=$zcvt(dimCode,"U")
    s subGrpList=""
    s grpId=0 f  s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_dimCode,grpId)) q:grpId=""  d
    .s ItemDR=0 f  s ItemDR=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId,ItemDR)) q:ItemDR=""  d
    ..s id="" f  s id=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId,ItemDR,id)) q:id=""  d
    ...s value=##class(DHCWL.CodeCfg.ItemGroupDetails).%OpenId(id)
    ...s locdr=value.ItmGrpDetItemDR
    ...s subgrpSort=value.ItmGrpDetSort
    ...s locdesc=$p(^CTLOC(locdr),"^",2)
    ...i locdesc["-" s locdesc=$p(locdesc,"-",2)
    ...d OutPutRow2
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow2
    s Data=$lb(locdr,locdesc,subgrpSort)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetGrpDetailByDimCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpDetailByDimCodeExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetGrpDetailByDimCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpDetailByDimCodeExecute ]
{
    n (AtEnd,qHandle,Row)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CreatDate：    2016-1-14
/// Description:： 取科室数据
/// Table：       CT_lco、DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       
/// Output：     明细科室id\描述、顺序
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetLoc","EC1")
/// 明细科室id\描述、顺序
Query GetLoc(dimCode As %String = "") As %Query(ROWSPEC = "hsks,locdr,locdesc,subgrpSort") [ SqlProc ]
{
}

ClassMethod GetLocExecute(ByRef qHandle As %Binary, dimCode As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    ;hsks,locdr,locdesc,subgrpSort
    s dimCode=$zcvt(dimCode,"U")
    i (dimCode="全部科室") d
    .s locdr=0 f  s locdr=$o(^CTLOC(locdr)) q:locdr=""  d
    ..s ctloctype=$p(^CTLOC(locdr),"^",13)
    ..s locdesc=$p(^CTLOC(locdr),"^",2)
    ..i locdesc["-" s locdesc=$p(locdesc,"-",2)
    ..s subgrpSort=""
    ..s hsks="全部"
    ..d OutPutRow3
    i (dimCode="TAREC") d
    .s tarECDr=0 f  s tarECDr=$o(^DHCTarC("EC",tarECDr)) q:tarECDr=""  d
    ..s tarECDesc=$p($g(^DHCTarC("EC",tarECDr)),"^",2)
    ..s tarECCode=$p($g(^DHCTarC("EC",tarECDr)),"^",1)
    ..s locdesc=tarECDesc
    ..s locdr=tarECDr
    ..d OutPutRow3
    i (dimCode="TARAC") d
    .s tarACDr=0 f  s tarACDr=$o(^DHCTarC("AC",tarACDr)) q:tarACDr=""  d
    ..s tarACDesc=$p($g(^DHCTarC("AC",tarACDr)),"^",2)
    ..s tarACCode=$p($g(^DHCTarC("AC",tarACDr)),"^",1)
    ..s locdesc=tarACDesc
    ..s locdr=tarACDr
    ..d OutPutRow3
    i (dimCode="TARIC") d
    .s tarICDr=0 f  s tarICDr=$o(^DHCTarC("IC",tarICDr)) q:tarICDr=""  d
    ..s tarICDesc=$p($g(^DHCTarC("IC",tarICDr)),"^",2)
    ..s tarICCode=$p($g(^DHCTarC("IC",tarICDr)),"^",1)
    ..s locdesc=tarICDesc
    ..s locdr=tarICDr
    ..d OutPutRow3
    i (dimCode="TAROC") d
    .s tarOCDr=0 f  s tarOCDr=$o(^DHCTarC("OC",tarOCDr)) q:tarOCDr=""  d
    ..s tarOCDesc=$p($g(^DHCTarC("OC",tarOCDr)),"^",2)
    ..s tarOCCode=$p($g(^DHCTarC("OC",tarOCDr)),"^",1)
    ..s locdesc=tarOCDesc
    ..s locdr=tarOCDr
    ..d OutPutRow3
    i (dimCode="TARSC") d
    .s tarSCDr=0 f  s tarSCDr=$o(^DHCTarC("SC",tarSCDr)) q:tarSCDr=""  d
    ..s tarSCDesc=$p($g(^DHCTarC("SC",tarSCDr)),"^",2)
    ..s tarSCCode=$p($g(^DHCTarC("SC",tarSCDr)),"^",1)
    ..s locdesc=tarSCDesc
    ..s locdr=tarSCDr
    ..d OutPutRow3
    i (dimCode="TARMC") d
    .s tarMCDr=0 f  s tarMCDr=$o(^DHCTarC("MC",tarMCDr)) q:tarMCDr=""  d
    ..s tarMCDesc=$p($g(^DHCTarC("MC",tarMCDr)),"^",2)
    ..s tarMCCode=$p($g(^DHCTarC("MC",tarMCDr)),"^",1)
    ..s locdesc=tarMCDesc
    ..s locdr=tarMCDr
    ..d OutPutRow3
    i $d(^DHCWL.CodeCfg.ItemGroupI("Code"," "_dimCode)) d
    .s grpId=0 f  s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_dimCode,grpId)) q:grpId=""  d
    ..s dimid=$li(^DHCWL.CodeCfg.ItemGroupD(grpId),8)
    ..s codedim=$li(^DHCWL.MKPI.MKPIDimTypeD(dimid),2)
    ..s codedim=$zcvt(codedim,"U")
    ..s ItemDR=0 f  s ItemDR=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId,ItemDR)) q:ItemDR=""  d
    ...s id="" f  s id=$o(^DHCWL.CodeCfg.ItemGroupDetailsI("GrpIM",grpId,ItemDR,id)) q:id=""  d
    ....s value=##class(DHCWL.CodeCfg.ItemGroupDetails).%OpenId(id)
    ....s locdr=value.ItmGrpDetItemDR
    ....s subgrpSort=value.ItmGrpDetSort
    ....;codedim,locdr
    ....s nod=..GetDetail(codedim,locdr)
    ....s locdesc=$p(nod,"^",3)
    ....;i locdesc["-" s locdesc=$p(locdesc,"-",2)
    ....s hsks="统计大组"
    ....;s hsks=$case(dimCode,"CTLOC":"科室大组","TAREC":"核算分类大组","TARAC":"会计分类大组","TARIC":"住院分类大组","TAROC":"门诊分类大组","TARSC":"收费分类大组","TARMC":"病案分类大组")
    ....d OutPutRow3
    i $d(^DHCWL.CodeCfg.GroupI("Code"," "_dimCode)) d
    .s subGrpList=""
    .s grpId=0 f  s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_dimCode,grpId)) q:grpId=""  d
    ..s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
    ...s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
    ...s subgrpDesc=value.SGrpDesc
    ...s subgrpCode=value.SGrpCode
    ...s subgrpSort=value.SGrpSort
    ...s itemid="" f  s itemid=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,itemid)) q:itemid=""  d
    ....s locdr=$p(itemid," ",2)
    ....s locdesc=subgrpDesc
    ....s hsks="统计子组"
    ....;s hsks=$case(dimCode,"CTLOC":"科室子组","TAREC":"核算分类子组","TARAC":"会计分类子组","TARIC":"住院分类子组","TAROC":"门诊分类子组","TARSC":"收费分类子组","TARMC":"病案分类子组")
    ....d OutPutRow3
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow3
    s Data=$lb(hsks,locdr,locdesc,subgrpSort)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocExecute ]
{
    n (AtEnd,qHandle,Row)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 根据 code 取出明细数据
/// w ##class(web.DHCWLHSQuery).GetDetail("TAREC","1")
ClassMethod GetDetail(dimCode, id)
{
    
    s (hsks,locdr,locdesc,subgrpSort)="",detail="^^^"
    q:dimCode="" detail="^^^"
    i (dimCode="CTLOC") d
    .s locdr=id
    .s locdesc=$p(^CTLOC(id),"^",2)
    .i locdesc["-" s locdesc=$p(locdesc,"-",2)
    i (dimCode="TAREC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("EC",id)),"^",2)
    i (dimCode="TARAC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("AC",id)),"^",2)
    i (dimCode="TARIC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("IC",id)),"^",2)
    i (dimCode="TAROC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("OC",id)),"^",2)
    i (dimCode="TARSC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("SC",id)),"^",2)
    i (dimCode="TARMC") d
    .s locdr=id
    .s locdesc=$p($g(^DHCTarC("MC",id)),"^",2)
    ;hsks,locdr,locdesc,subgrpSort
    s detail=hsks_"^"_locdr_"^"_locdesc_"^"_subgrpSort
    q detail
}

/// Creator：      ch
/// CreatDate：    2014-02-18
/// Description:： 取医院ID code desc
/// Table：        ^DHCWLInitStat("Hospital")
/// Input：       ""
/// Output：     mLocId,mLocCode,mLocDesc
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","QueryHos")
Query QueryHos() As %Query(ROWSPEC = "mHosId:%String,mHosCode:%String,mHosDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryHosExecute(ByRef qHandle As %Binary) As %Status
{
    n (qHandle)
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1,flag=1
    s mHosId=0,mHosCode="mHosCode",mHosDesc="mHosDesc"
    s mHosId=+$G(^DHCWLInitStat("Hospital"))
    i $d(^DHCWLCFG("HOS",mHosId)) d
    .s mHosCode=$p($g(^DHCWLCFG("HOS",mHosId)),"^",1)
    .s mHosDesc=$p($g(^DHCWLCFG("HOS",mHosId)),"^",2)
    d OutPutHos
    
    Quit $$$OK
OutPutHos
    s Data=$lb(mHosId,mHosCode,mHosDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod QueryHosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHosExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryHosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHosExecute ]
{
    n (qHandle,Row,AtEnd)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2014-02-18
/// Description:： 取核算内容
/// Table：        ^TEMPDHCWLHS($j,"HS"
/// Input：       ""
/// Output：     raqdesc,kpicode,kpidesc
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","QueryHSWork")
Query QueryHSWork() As %Query(ROWSPEC = "id,raqdesc:%Text,kpicode:%Text,kpidesc:%Text,indexdate,hscode,hsdesc") [ SqlProc ]
{
}

ClassMethod QueryHSWorkExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    k ^CacheTemp(repid)
    s qHandle=$lb(0,repid,0)
    s int=1
    k PLIST
    d SetHSWork^DHCWLHSInit()
    f i=1:1:$o(PLIST(""),-1) d
    .s id=$p(PLIST(i),"^",1)
    .s raqdesc=$p(PLIST(i),"^",2)
    .s kpicode=$p(PLIST(i),"^",3)
    .s kpidesc=$p(PLIST(i),"^",4)
    .s indexdate=$p(PLIST(i),"^",5)
    .s hscode=$p(PLIST(i),"^",6)
    .s hsdesc=$p(PLIST(i),"^",7)
    .s ^CacheTemp(repid,int)=$lb(id,raqdesc,kpicode,kpidesc,indexdate,hscode,hsdesc)
    .s int=int+1
    Quit $$$OK
}

ClassMethod QueryHSWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHSWorkExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryHSWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHSWorkExecute ]
{
    n (qHandle,Row,AtEnd)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      yuanxu
/// CreatDate：    2016-1-14
/// Description:： 根据维度取出该维度下的大组或子组
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgGroup  DHCWL_CodeCfg.DHCWLCodeCfgItemGroup
/// Input：       dimCode:维度类型CODE type:G大组;SG子组
/// Output：      id,Code,Desc
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetHSGrpListByDimCode")
/// 
Query GetHSGrpListByDimCode() As %Query(ROWSPEC = "hs:%Text,id:%String,Code:%Text,Desc:%Text,kpi:%Text") [ SqlProc ]
{
}

ClassMethod GetHSGrpListByDimCodeExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s dimCode=""
    k PLIST
    d SetHSWork^DHCWLHSInit()
    f i=1:1:$o(PLIST(""),-1) d
    .s kpicode=$p(PLIST(i),"^",3)
    .s hscode=$p(PLIST(i),"^",6)
    .s kpi=kpicode
    .s dimCodeHS=$ZCVT(hscode,"U")
    .s hs=$case(dimCodeHS,"TAREC":"核算子分类","TARAC":"会计子分类","TARIC":"住院子分类","TAROC":"门诊子分类","TARSC":"收费子分类","TARMC":"病案子分类")
    .s id="",Code=dimCodeHS,Desc=hs
    .d OutPutRowhs
    .s dimId=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCodeHS,"U"),""))
    .q:dimId=""
    .s id="" f  s id=$o(^DHCWL.CodeCfg.GroupI("DimDr",dimId,id)) q:id=""  d
    ..s Code=$li(^DHCWL.CodeCfg.GroupD(id),2)
    ..s Desc=$li(^DHCWL.CodeCfg.GroupD(id),3)
    ..s hs=$case(dimCodeHS,"TAREC":"核算分类子组","TARAC":"会计分类子组","TARIC":"住院分类子组","TAROC":"门诊分类子组","TARSC":"收费分类子组","TARMC":"病案分类子组")
    ..d OutPutRowhs
    .s id="" f  s id=$o(^DHCWL.CodeCfg.ItemGroupI("DimDr",dimId,id)) q:id=""  d
    ..s Code=$li(^DHCWL.CodeCfg.ItemGroupD(id),2)
    ..s Desc=$li(^DHCWL.CodeCfg.ItemGroupD(id),3)
    ..s hs=$case(dimCodeHS,"TAREC":"核算分类大组","TARAC":"会计分类大组","TARIC":"住院分类大组","TAROC":"门诊分类大组","TARSC":"收费分类大组","TARMC":"病案分类大组")
    ..d OutPutRowhs
    
    s qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutPutRowhs
    s Data=$lb(hs,id,Code,Desc,kpi)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetHSGrpListByDimCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHSGrpListByDimCodeExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetHSGrpListByDimCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHSGrpListByDimCodeExecute ]
{
    n (AtEnd,qHandle,Row)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// ------------------------------------------------取数query----------------------
/// Creator：      zl
/// CreatDate：    2016-11-24
/// Description:： 科室核算字表取数程序
/// Table：        
/// Input：       ""
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetLocHSDataQuery","2013-05-01","2013-05-01","","KPHS0001,KPHS0002") ,,,,,,,
Query GetLocHSDataQuery(startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Query(ROWSPEC = "raqDesc,hscode,hssubdesc,kpi,contractTye,month,monthCol2,monthCol3,dimIdCol1,dimIdCol2,dimIdCol3,dimIdCol4,dimIdCol5,dimIdCol6,dimDesCol1,dimDesCol2,dimDesCol3,dimDesCol4,dimDesCol5,dimDesCol6,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float") [ SqlProc ]
{
}

ClassMethod GetLocHSDataQueryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Status
{
    n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set qHandle=$lb(0,repid,0)
    q:(startDate="") $$$OK
    q:(endDate="") $$$OK
    Set ind=1
    s ^temp("zl",1)=startDate
    s ^temp("zl",2)=endDate
    s ^temp("zl",3)=kpiRule
    k ^TEMPDHCWL($j)
    s hsnod=$$GetHSinfobykpiCode^DHCWLHSInit(kpiRule)   ;根据指标code，取到描述，费用分类
    s raqDesc=$p(hsnod,"^",1),hscode=$p(hsnod,"^",2),hssubdesc=$p(hsnod,"^",3)
    ;startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam
    ;d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewKpiQueryGrideShow",kpi,startDate,endDate,choiceType,isRealData,filterRuler)
    Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:NewKpiQueryGrideShow")
    Set columns = rset.GetColumnCount()
    Set sc = rset.Execute(startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
    While (rset.Next())
    {
      ;kpi,contractTye,month,monthCol2,monthCol3,
      ;monthCol4,monthCol5,dimIdCol1,dimIdCol2,dimIdCol3,
      ;dimIdCol4,dimIdCol5,dimIdCol6,dimIdCol7,dimIdCol8,
      ;dimIdCol9,dimIdCol10,dimIdCol11,dimIdCol12,dimIdCol13,
      ;dimIdCol14,dimIdCol15,dimIdCol16,dimDesCol1,dimDesCol2,
      ;dimDesCol3,dimDesCol4,dimDesCol5,dimDesCol6,dimDesCol7,
      ;dimDesCol8,dimDesCol9,dimDesCol10,dimDesCol11,dimDesCol12,
      ;dimDesCol13,dimDesCol14:%String,dimDesCol15:%String,dimDesCol16:%String,kpiValueCol1:%Float,
      ;kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float,kpiValueCol5:%Float,kpiValueCol6:%Float,kpiValueCol7:%Float,kpiValueCol8:%Float,kpiValueCol9:%Float,kpiValueCol10:%Float,kpiValueCol11:%Float,kpiValueCol12:%Float,kpiValueCol13:%Float,kpiValueCol14:%Float,kpiValueCol15:%Float,kpiValueCol16:%Float,kpiValueCol17:%Float,kpiValueCol18:%Float,kpiValueCol19:%Float,kpiValueCol20:%Float,kpiValueCol21:%Float,kpiValueCol22:%Float,kpiValueCol23:%Float,kpiValueCol24:%Float,kpiValueCol25:%Float,kpiValueCol26:%Float,kpiValueCol27:%Float,kpiValueCol28:%Float,kpiValueCol29:%Float,kpiValueCol30:%Float
      s kpi=rset.GetData(1)
      s contractTye=rset.GetData(2)
      s month=rset.GetData(3)
      s monthCol2=rset.GetData(4)
      s monthCol3=rset.GetData(5)
      s dimIdCol1=rset.GetData(8)
      s dimIdCol2=rset.GetData(9)
      s dimIdCol3=rset.GetData(10)
      s dimIdCol4=rset.GetData(11)
      s dimIdCol5=rset.GetData(12)
      s dimIdCol6=rset.GetData(13)
      s dimDesCol1=rset.GetData(24)
      s dimDesCol2=rset.GetData(25)
      s dimDesCol3=rset.GetData(26)
      s dimDesCol4=rset.GetData(27)
      s dimDesCol5=rset.GetData(28)
      s dimDesCol6=rset.GetData(29)
      s kpiValueCol1=rset.GetData(40)
      s kpiValueCol2=rset.GetData(41)
      s kpiValueCol3=rset.GetData(42)
      s kpiValueCol4=rset.GetData(43)
      d OutPutRowD
    }
    Do rset.Close()     
    k ^TEMPDHCWL($j) 
    Quit $$$OK

OutPutRowD
    s Data=$lb(raqDesc,hscode,hssubdesc,kpi,contractTye,month,monthCol2,monthCol3,dimIdCol1,dimIdCol2,dimIdCol3,dimIdCol4,dimIdCol5,dimIdCol6,dimDesCol1,dimDesCol2,dimDesCol3,dimDesCol4,dimDesCol5,dimDesCol6,kpiValueCol1,kpiValueCol2,kpiValueCol3,kpiValueCol4)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
}

ClassMethod GetLocHSDataQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocHSDataQueryExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocHSDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocHSDataQueryExecute ]
{
    n (qHandle,Row,AtEnd)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2016-11-24
/// Description:： 科室核算字表取数程序
/// Table：        
/// Input：       ""
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetLocHSDataQueryKS","2013-05-01","2013-05-31","","KPHS0012") ,,,,,,,
Query GetLocHSDataQueryKS(startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Query(ROWSPEC = "raqDesc,hscode,hssubdesc,kpi,contractTye,month,monthCol2,monthCol3,dimIdCol1,dimIdCol2,dimIdCol3,dimIdCol4,dimIdCol5,dimIdCol6,dimDesCol1,dimDesCol2,dimDesCol3,dimDesCol4,dimDesCol5,dimDesCol6,kpiValueCol1:%Float,kpiValueCol2:%Float,kpiValueCol3:%Float,kpiValueCol4:%Float") [ SqlProc ]
{
}

ClassMethod GetLocHSDataQueryKSExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String, kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", dynParam = "", execParam As %Text = "") As %Status
{
    n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set qHandle=$lb(0,repid,0)
    q:(startDate="") $$$OK
    q:(endDate="") $$$OK
    Set ind=1
    s ^temp("zl",1)=startDate
    s ^temp("zl",2)=endDate
    s ^temp("zl",3)=kpiRule
    k ^TEMPDHCWL($j)
    s hsnod=$$GetHSinfobykpiCode^DHCWLHSInit(kpiRule)   ;根据指标code，取到描述，费用分类
    s raqDesc=$p(hsnod,"^",1),hscode=$p(hsnod,"^",2),hssubdesc=$p(hsnod,"^",3)
    ;startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam
    ;d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","NewKpiQueryGrideShow",kpi,startDate,endDate,choiceType,isRealData,filterRuler)
    Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:NewKpiQueryGrideShow")
    Set columns = rset.GetColumnCount()
    Set sc = rset.Execute(startDate,endDate,dateType,kpiRule,filterRule,mode,contract,dynParam,execParam)
    While (rset.Next())
    {
      s kpi=rset.GetData(1)
      s contractTye=rset.GetData(2)
      s month=rset.GetData(3)
      s monthCol2=rset.GetData(4)
      s monthCol3=rset.GetData(5)
      s dimIdCol1=rset.GetData(8)
      s dimIdCol2=rset.GetData(9)
      s dimIdCol3=rset.GetData(10)
      s dimIdCol4=rset.GetData(11)
      s dimIdCol5=rset.GetData(12)
      s dimIdCol6=rset.GetData(13)
      s dimDesCol1=rset.GetData(24)
      s dimDesCol2=rset.GetData(25)
      s dimDesCol3=rset.GetData(26)
      s dimDesCol4=rset.GetData(27)
      s dimDesCol5=rset.GetData(28)
      s dimDesCol6=rset.GetData(29)
      s kpiValueCol1=rset.GetData(40)
      s kpiValueCol2=rset.GetData(41)
      s kpiValueCol3=rset.GetData(42)
      s kpiValueCol4=rset.GetData(43)
      i (kpiRule="KPHS0010")!(kpiRule="KPHS0011")!(kpiRule="KPHS0012")!(kpiRule="KPHS0013") continue:dimDesCol4="N"
      ;特殊费用需要过滤掉非药品、非手术的费用
      d OutPutRowDKS
    }
    Do rset.Close()     
    k ^TEMPDHCWL($j) 
    Quit $$$OK

OutPutRowDKS
    s Data=$lb(raqDesc,hscode,hssubdesc,kpi,contractTye,month,monthCol2,monthCol3,dimIdCol1,dimIdCol2,dimIdCol3,dimIdCol4,dimIdCol5,dimIdCol6,dimDesCol1,dimDesCol2,dimDesCol3,dimDesCol4,dimDesCol5,dimDesCol6,kpiValueCol1,kpiValueCol2,kpiValueCol3,kpiValueCol4)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
}

ClassMethod GetLocHSDataQueryKSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocHSDataQueryKSExecute ]
{
    n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocHSDataQueryKSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocHSDataQueryKSExecute ]
{
    n (qHandle,Row,AtEnd)
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2016-12-27
/// Description:： 查询科室收费项目明细数据
/// Table：        dhc_workload
/// Input：       ""
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","DHCWLGetTaritemFee","2017-02-18","2017-02-18") ,,,,,,,
Query DHCWLGetTaritemFee(startDate As %String, endDate As %String, cykb As %String = "", itemdr As %Text = "", type As %String = "", resloc As %String = "", Doc As %String = "") As %Query(ROWSPEC = "type,recloc,reclocdesc,resloc,reslocdesc,patloc,patlocdesc,resdoc,resdocdesc,adm,taritem,mTarItemdesc,fee:%Float,qua:%Float,papmi,patname,patno,sex,age") [ SqlProc ]
{
}

ClassMethod DHCWLGetTaritemFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, cykb As %String = "", itemdr As %Text = "", type As %String = "", resloc As %String = "", Doc As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j,"LOCDE")
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    s ^TEMPCANSHU("zl")=startDate_"^"_endDate_"^"_cykb_"^"_Doc
    s startDate=$zdh(startDate,3)
    s endDate=$zdh(endDate,3)
    f OrdDate=startDate:1:endDate d
    .s WLRowid=""
    .f  s WLRowid=$o(^DHCWorkLoad(0,"ORDDATE",OrdDate,WLRowid)) q:WLRowid=""  d
    ..s mType=$p(^DHCWorkLoad(WLRowid),"^",4)
    ..i ((type'="null")&&(type'="")) q:$F(","_type_",",","_mType_",")=0
    ..s mRecLoc=$p(^DHCWorkLoad(WLRowid),"^",1) ;接收科室
    ..i mRecLoc="" s mRecLoc=99999
    ..i ((cykb'="null")&&(cykb'="")) q:$F(","_cykb_",",","_mRecLoc_",")=0
    ..s mResDoc=$p($g(^DHCWorkLoad(WLRowid)),"^",19)  ;开单医生
    ..i mResDoc="" s mResDoc=99999
    ..i ((Doc'="null")&&(Doc'="")) q:$F(","_Doc_",",","_mResDoc_",")=0
    ..s mResLoc=$p($g(^DHCWorkLoad(WLRowid)),"^",23)    ;开单科室
    ..i mResLoc="" s mResLoc=99999
    ..s mPatLoc=$p($g(^DHCWorkLoad(WLRowid)),"^",3) ;病人科室
    ..i ((resloc'="null")&&(resloc'="")) q:$F(","_resloc_",",","_mResLoc_",")=0
    ..s mAdm=$p(^DHCWorkLoad(WLRowid),"^",12)
    ..s mTarItem=$p(^DHCWorkLoad(WLRowid),"^",22)
    ..i ((itemdr'="null")&&(itemdr'="")) q:$F(","_itemdr_",",","_mTarItem_",")=0
    ..s mTarItemdesc=$p(^DHCTARI(mTarItem),"^",2)
    ..s mUnitPrice=$p(^DHCWorkLoad(WLRowid),"^",14)
    ..s mTotalPrice=$p(^DHCWorkLoad(WLRowid),"^",16)
    ..s mQuantity=$p(^DHCWorkLoad(WLRowid),"^",15)
    ..s ^TEMPDHCWL($j,"LOCDE",mType,mRecLoc,mResLoc,mPatLoc,mResDoc,mAdm,mTarItem,"Fee")=$g(^TEMPDHCWL($j,"LOCDE",mType,mRecLoc,mResLoc,mPatLoc,mResDoc,mAdm,mTarItem,"Fee"))+$g(mTotalPrice)
    ..s ^TEMPDHCWL($j,"LOCDE",mType,mRecLoc,mResLoc,mPatLoc,mResDoc,mAdm,mTarItem,"QUA")=$g(^TEMPDHCWL($j,"LOCDE",mType,mRecLoc,mResLoc,mPatLoc,mResDoc,mAdm,mTarItem,"QUA"))+$g(mQuantity)
    s type="" f  s type=$o(^TEMPDHCWL($j,"LOCDE",type)) q:type=""  d
    .s recloc="" f  s recloc=$o(^TEMPDHCWL($j,"LOCDE",type,recloc)) q:recloc=""  d
    ..s reclocdesc=$p($g(^CTLOC(recloc)),"^",2)
    ..i reclocdesc["-" s reclocdesc=$p(reclocdesc,"-",2)
    ..s resloc="" f  s resloc=$o(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc)) q:resloc=""  d
    ...s reslocdesc=$p($g(^CTLOC(resloc)),"^",2)
    ...i reslocdesc["-" s reslocdesc=$p(reslocdesc,"-",2)
    ...s patloc="" f  s patloc=$o(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc)) q:patloc=""  d
    ....s patlocdesc=$p($g(^CTLOC(patloc)),"^",2)
    ....i patlocdesc["-" s patlocdesc=$p(patlocdesc,"-",2)
    ....s resdoc="" f  s resdoc=$o(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc,resdoc)) q:resdoc=""  d
    .....s resdocdesc=$p($g(^CTPCP(resdoc,1)),"^",2)
    .....s adm="" f  s adm=$o(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc,resdoc,adm)) q:adm=""  d
    ......s papmi=$p(^PAADM(adm),"^",1)
    ......s patname=$$GetPapmiName^DHCWLCommon(papmi)
    ......s patno=$$GetPapmiNo^DHCWLCommon(papmi)
    ......s sex=$$GetSex^DHCWLCommon(papmi)
    ......s age=$$GetAge^DHCWLCommon(papmi)
    ......s taritem="" f  s taritem=$o(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc,resdoc,adm,taritem)) q:taritem=""  d
    .......s mTarItemdesc=$p(^DHCTARI(taritem),"^",2)
    .......s fee=+$g(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc,resdoc,adm,taritem,"Fee"))
    .......s qua=+$g(^TEMPDHCWL($j,"LOCDE",type,recloc,resloc,patloc,resdoc,adm,taritem,"QUA"))
    .......d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    s data=$lb(type,recloc,reclocdesc,resloc,reslocdesc,patloc,patlocdesc,resdoc,resdocdesc,adm,taritem,mTarItemdesc,fee,qua,papmi,patname,patno,sex,age)
    Set ^CacheTemp(repid,ind)=data
    Set ind=ind+1
    quit
}

ClassMethod DHCWLGetTaritemFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCWLGetTaritemFeeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DHCWLGetTaritemFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCWLGetTaritemFeeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
    }
    Else      {             // fetch row
    Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

// 通过模糊查询获得科室

// d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetLocbyname","zh")

ClassMethod GetLocbynameExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:loc="" $$$OK
    
    s loc=$zcvt(loc,"U")
    s ctprowid="" f  s ctprowid=$o(^CTLOC(ctprowid)) q:ctprowid=""  d
    .s descname=$p(^CTLOC(ctprowid),"^",2)
    .i loc'="" q:$zcvt(descname,"U")'[loc
    .i descname["-" s descname=$p(descname,"-",2)
    .s code=$p(^CTLOC(ctprowid),"^",1) 
    .d OutputRowloc

    q $$$OK 

OutputRowloc
    
    s Data=$lb(code,descname,ctprowid)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetLocbynameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocbynameExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetLocbynameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocbynameExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetLocbyname(loc As %String) As %Query(ROWSPEC = "code:%String,desc:%String,ctprowid:%String") [ SqlProc ]
{
}

/// 取收费项目名称
///   d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","GetItemName","ybz")
Query GetItemName(ARCIMDesc As %Text) As %Query(ROWSPEC = "ArcimID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod GetItemNameExecute(ByRef qHandle As %Binary, ARCIMDesc As %Text) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:ARCIMDesc="" $$$OK
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
    s ARCIMDesc=$zcvt(ARCIMDesc,"U")
    s ArcimID=0 
    f  s ArcimID=$o(^DHCTARI(ArcimID)) q:ArcimID=""  d
    .q:('$d(^DHCTARI(ArcimID)))
    .q:'$d(^DHCTARAL("A",ArcimID))
    .s tar="" f  s tar=$o(^DHCTARAL("A",ArcimID,tar)) q:tar=""  d
    ..s py=$p(^DHCTARAL(tar),"^",3)
    ..s py=$zcvt(py,"U")
    ..q:py'[ARCIMDesc
    ..s Desc=$p($g(^DHCTARI(ArcimID)),"^",2)
    ..Do OutputRowArcName
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowArcName
    set Data=$lb(ArcimID,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetItemNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemNameExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }
    Else {      
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetItemNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemNameExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// ---------------------------病人费用明细------------
/// Creator：      zl
/// CreatDate：    2015-05-06
/// Description:： 根据adm或登记号 获取就诊信息
/// Table：       pa_adm
/// Input：       mPAPDr,mAdm
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","DHCWLGetAdm","","","")
Query DHCWLGetAdm(ipno As %String, mPAPDr As %String, mAdm As %String) As %Query(ROWSPEC = "ipmedno,mNO:%String,mName:%String,mSex:%String,mAdmDate:%String,mDisDate:%String,mAdmLoc:%String,mFee:%Float,mDiag:%String,admno:%String,mType:%String") [ SqlProc ]
{
}

ClassMethod DHCWLGetAdmExecute(ByRef qHandle As %Binary, ipno As %String, mPAPDr As %String, mAdm As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^DHCWLTEMP($j,"ADMTEMP")
    q:((ipno="")&&(mPAPDr="")&&(mAdm="")) $$$OK
    i mPAPDr'="" d
    .s len=$l(mPAPDr) 
    .i len<10 d
    ..f i=1:1:(10-len) s mPAPDr="0"_""_mPAPDr
    .;w mPAPDr,! 登记号补0，,10位
    .s mPAPDr1=$o(^PAPERi("PAPMI_PatNo",mPAPDr,""))
    .q:mPAPDr1=""
    .s admtype="" f  s admtype=$o(^PAPERdr(mPAPDr1,"ADM",admtype)) q:admtype=""  d
    ..s adm="" f  s adm=$o(^PAPERdr(mPAPDr1,"ADM",admtype,adm)) q:adm=""  d
    ...s ^DHCWLTEMP($j,"ADMTEMP",adm)=1
    ...s mNO=$$GetPapmiNo^DHCWLCommon(mPAPDr1)
    ...s mName=$$GetPapmiName^DHCWLCommon(mPAPDr1)
    ...s mSex=$$GetSex^DHCWLCommon(mPAPDr1)
    ...s mAdmDate=$p($g(^PAADM(adm)),"^",6)
    ...s mAdmDate=$zd(mAdmDate,3)
    ...s mDisDate=$p($g(^PAADM(adm)),"^",17)
    ...i mDisDate'="" s mDisDate=$zd(mDisDate,3)
    ...s mAdmLoc=$p($g(^PAADM(adm)),"^",4)
    ...s mAdmLoc=$p($p($g(^CTLOC(mAdmLoc)),"^",2),"-",2)
    ...s mFee=..GetFeebyAdm(adm)
    ...s mDiag=..GetDiag(adm)
    ...s admno=adm
    ...s mType=admtype
    ...s mType=$Case(mType,"I":"住院","O":"门诊","E":"急诊",:"未知")
    ...i mType="住院" s ipmedno=$$GetPapmiMedtare^DHCWLCommon(mPAPDr1)
    ...e  s ipmedno=""
    ...d OutputRowPat
    i ipno'="" d
    .s mPAPDr1="" 
    .s mPAPDr1=$o(^PAPERi("Medicare1",ipno,mPAPDr1))
    .q:mPAPDr1=""
    .s adm="" f  s adm=$o(^PAPERdr(mPAPDr1,"ADM","I",adm)) q:adm=""  d
    ..s ^DHCWLTEMP($j,"ADMTEMP",adm)=1
    ..s mNO=$$GetPapmiNo^DHCWLCommon(mPAPDr1)
    ..s mName=$$GetPapmiName^DHCWLCommon(mPAPDr1)
    ..s mSex=$$GetSex^DHCWLCommon(mPAPDr1)
    ..s mAdmDate=$p($g(^PAADM(adm)),"^",6)
    ..s mAdmDate=$zd(mAdmDate,3)
    ..s mDisDate=$p($g(^PAADM(adm)),"^",17)
    ..i mDisDate'="" s mDisDate=$zd(mDisDate,3)
    ..s mAdmLoc=$p($g(^PAADM(adm)),"^",4)
    ..s mAdmLoc=$p($p($g(^CTLOC(mAdmLoc)),"^",2),"-",2)
    ..s mFee=..GetFeebyAdm(adm)
    ..s mDiag=..GetDiag(adm)
    ..s admno=adm
    ..s mType="I"
    ..s mType=$Case(mType,"I":"住院","O":"门诊","E":"急诊",:"未知")
    ..i mType="住院" s ipmedno=$$GetPapmiMedtare^DHCWLCommon(mPAPDr1)
    ..e  s ipmedno=""
    ..d OutputRowPat
    i mAdm'="" d
    .q:'$d(^PAADM(mAdm))
    .q:$d(^DHCWLTEMP($j,"ADMTEMP",mAdm))
    .s mPAPDr=$p($g(^PAADM(mAdm)),"^",1)
    .s mNO=$$GetPapmiNo^DHCWLCommon(mPAPDr)
    .s mName=$$GetPapmiName^DHCWLCommon(mPAPDr)
    .s mSex=$$GetSex^DHCWLCommon(mPAPDr)
    .s mAdmDate=$p($g(^PAADM(mAdm)),"^",6)
    .s mAdmDate=$zd(mAdmDate,3)
    .s mDisDate=$p($g(^PAADM(mAdm)),"^",17)
    .i mDisDate'="" s mDisDate=$zd(mDisDate,3)
    .s mAdmLoc=$p($g(^PAADM(mAdm)),"^",4)
    .s mAdmLoc=$p($p($g(^CTLOC(mAdmLoc)),"^",2),"-",2)
    .s mFee=..GetFeebyAdm(mAdm)
    .s mDiag=..GetDiag(mAdm)
    .s admno=mAdm
    .s mType=$p($g(^PAADM(mAdm)),"^",2)
    .s mType=$Case(mType,"I":"住院","O":"门诊","E":"急诊",:"未知")
    .i mType="住院" s ipmedno=$$GetPapmiMedtare^DHCWLCommon(mPAPDr)
    .e  s ipmedno=""
    .d OutputRowPat
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK  
OutputRowPat
    s data=$lb(ipmedno,mNO,mName,mSex,mAdmDate,mDisDate,mAdmLoc,mFee,mDiag,admno,mType)
    Set ^CacheTemp(repid,ind)=data
    Set ind=ind+1
    quit
}

ClassMethod DHCWLGetAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCWLGetAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DHCWLGetAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCWLGetAdmExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
    }
    Else      {             // fetch row
    Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetFeebyAdm(adm)
{
    s num=0
    s mwlid=0 f  s mwlid=$o(^DHCWorkLoad(0,"PAADM",adm,mwlid)) q:mwlid=""  d
    .s mFee=$p($g(^DHCWorkLoad(mwlid)),"^",16)
    .s num=num+mFee
    q $g(num)
}

ClassMethod GetDiag(mAdm)
{
    s diagdesc=""
    s mrid=0 f  s mrid=$o(^MR(mAdm,"DIA",mrid)) q:mrid=""  d
    .s mricdid=$p($g(^MR(mAdm,"DIA",mrid)),"^",1)
    .q:mricdid=""
    .q:'$d(^MRC("ID",mricdid))
    .s diag=$p($g(^MRC("ID",mricdid)),"^",2)
    .q:diag=""
    .s diagdesc=diagdesc_" "_diag
    q $g(diagdesc)
}

/// Creator：      zl
/// CreatDate：    2015-05-06
/// Description:： 根据adm取病人费用明细
/// Table：       dhc_workload
/// Input：       mAdm
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLHSQuery","DHCWLGetFeeDetail","2359")
Query DHCWLGetFeeDetail(mAdmFee As %String, sumnod As %String = "", cykb As %String = "", recloc As %String = "", patloc As %String = "", tardr As %String = "", startDate As %String = "", endDate As %String = "") As %Query(ROWSPEC = "time,docdesc,orddesc,mAdmFee:%String,mAdmDate:%String,mOrdDate:%String,mOrd:%String,mTardr:%String,mTardesc:%String,mquant:%Float,mFee:%Float,mResLoc:%String,mRecLoc:%String,mPatLoc:%String,mFlagDate:%String,mBillDr:%String,mBillDeDr:%String,feetype") [ SqlProc ]
{
}

ClassMethod DHCWLGetFeeDetailExecute(ByRef qHandle As %Binary, mAdmFee As %String, sumnod As %String = "", cykb As %String = "", recloc As %String = "", patloc As %String = "", tardr As %String = "", startDate As %String = "", endDate As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(mAdmFee="") $$$OK
    s mwlid="" f  s mwlid=$o(^DHCWorkLoad(0,"PAADM",mAdmFee,mwlid)) q:mwlid=""  d
    .s mAdmDate=$p($g(^PAADM(mAdmFee)),"^",6)
    .s mAdmDate=$zd(mAdmDate,3)
    .s mOrdDate=$p($g(^DHCWorkLoad(mwlid)),"^",5)
    .s mOrdDate1=$p($g(^DHCWorkLoad(mwlid)),"^",5)
    .s mOrdDate=$zd(mOrdDate,3)
    .i (startDate'="")&&(endDate'="") s startDate=$zth(startDate,3),endDate=$zdh(endDate,3)
    .;i (startDate'="")&&(endDate'="") q:((mOrdDate1<startDate)!(mOrdDate1>endDate))
    .s time=$p($g(^DHCWorkLoad(mwlid)),"^",6)
    .s time=$zt(time,1)
    .s mOrd=$p($g(^DHCWorkLoad(mwlid)),"^",21)
    .s mTardr=$p($g(^DHCWorkLoad(mwlid)),"^",22)
    .i ((tardr'="null")&&(tardr'="")) q:$F(","_tardr_",",","_mTardr_",")=0   ;收费项目
    .s mTardesc=$p($g(^DHCTARI(mTardr)),"^",2)
    .s mquant=$p($g(^DHCWorkLoad(mwlid)),"^",15)
    .s mFee=$p($g(^DHCWorkLoad(mwlid)),"^",16)
    .s mResLoc=$p($g(^DHCWorkLoad(mwlid)),"^",23)
    .s mResLoc1=$p($g(^DHCWorkLoad(mwlid)),"^",23)
    .i ((cykb'="null")&&(cykb'="")) q:$F(","_cykb_",",","_mResLoc1_",")=0   ;开单科室
    .s mResLoc=$p($p($g(^CTLOC(mResLoc)),"^",2),"-",2) ;开单科室
    .s mRecLoc=$p($g(^DHCWorkLoad(mwlid)),"^",1)
    .s mRecLoc1=$p($g(^DHCWorkLoad(mwlid)),"^",1)
    .i ((recloc'="null")&&(recloc'="")) q:$F(","_recloc_",",","_mRecLoc1_",")=0   ;接收科室
    .s mRecLoc=$p($p($g(^CTLOC(mRecLoc)),"^",2),"-",2)  ;执行科室
    .s mPatLoc=$p($g(^DHCWorkLoad(mwlid)),"^",3)
    .s mPatLoc1=$p($g(^DHCWorkLoad(mwlid)),"^",3)
    .i ((patloc'="null")&&(patloc'="")) q:$F(","_patloc_",",","_mPatLoc1_",")=0   ;病人科室
    .s mPatLoc=$p($p($g(^CTLOC(mPatLoc)),"^",2),"-",2)  ;病人科室
    .s mFlagDate=$p($g(^DHCWorkLoad(mwlid)),"^",27)
    .i mFlagDate'="" s mFlagDate=$zd(mFlagDate,3)
    .s mBillDr=$p($g(^DHCWorkLoad(mwlid)),"^",20)   ;账单
    .s mBillDeDr=$p($g(^DHCWorkLoad(mwlid)),"^",48) ;账单明细
    .s tarac=$p($g(^DHCWorkLoad(mwlid)),"^",40)
    .s taracDesc=$p($g(^DHCTarC("AC",tarac)),"^",2)
    .i taracDesc["药" s feetype="药品费"
    .e  s feetype="非药品费"
    .i sumnod'="" q:feetype'=sumnod
    .s itmord=$p($g(^DHCWorkLoad(mwlid)),"^",2)
    .s orddesc=$p(^ARCIM($p(itmord,"||",1),$p(itmord,"||",2),1),"^",2)
    .s resdoc=$p($g(^DHCWorkLoad(mwlid)),"^",19)
    .i resdoc="" s resdoc=99999
    .s docdesc=$p(^CTPCP(resdoc,1),"^",2)
    .d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK  
OutputRow1
    s data=$lb(time,docdesc,orddesc,mAdmFee,mAdmDate,mOrdDate,mOrd,mTardr,mTardesc,mquant,mFee,mResLoc,mRecLoc,mPatLoc,mFlagDate,mBillDr,mBillDeDr,feetype)
    Set ^CacheTemp(repid,ind)=data
    Set ind=ind+1
    quit
}

ClassMethod DHCWLGetFeeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCWLGetFeeDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DHCWLGetFeeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCWLGetFeeDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
    }
    Else      {             // fetch row
    Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：      zl
/// CreatDate：    2015-05-06
/// Description:： 根据adm取病人费用明细
/// Table：       dhc_workload
/// Input：       mAdm
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLGetFeeDetail","DHCWLGetSumFee","1")
Query DHCWLGetSumFee(mAdmFee As %String, sumnod As %String = "") As %Query(ROWSPEC = "nodDesc:%String,sumFee:%Float") [ SqlProc ]
{
}

ClassMethod DHCWLGetSumFeeExecute(ByRef qHandle As %Binary, mAdmFee As %String, sumnod As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    k ^DHCWLTEMP($j,"SumFee")
    q:(mAdmFee="")||(sumnod="") $$$OK
    s mwlid="" f  s mwlid=$o(^DHCWorkLoad(0,"PAADM",mAdmFee,mwlid)) q:mwlid=""  d
    .i sumnod'="" d
    ..s nod=$p($g(^DHCWorkLoad(mwlid)),"^",sumnod)
    ..q:nod=""
    ..s mFee=$p($g(^DHCWorkLoad(mwlid)),"^",16)
    ..s ^DHCWLTEMP($j,"SumFee",nod)=$g(^DHCWLTEMP($j,"SumFee",nod))+mFee
    s nod="" f  s nod=$o(^DHCWLTEMP($j,"SumFee",nod)) q:nod=""  d
    .s sumFee=$g(^DHCWLTEMP($j,"SumFee",nod))
    .i (sumnod=1)||(sumnod=23)||(sumnod=3) s nodDesc=$p($p(^CTLOC(nod),"^",2),"-",2)
    .i (sumnod=5)||(sumnod=27) s nodDesc=$zd(nodDesc,3)
    .d OutputRow2
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK  
OutputRow2
    s data=$lb(nodDesc,sumFee)
    Set ^CacheTemp(repid,ind)=data
    Set ind=ind+1
    quit
}

ClassMethod DHCWLGetSumFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCWLGetSumFeeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DHCWLGetSumFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCWLGetSumFeeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
    }
    Else      {             // fetch row
    Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Storage Default
{
<Data name="DHCWLHSQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLHSQueryD</DataLocation>
<DefaultData>DHCWLHSQueryDefaultData</DefaultData>
<IdLocation>^web.DHCWLHSQueryD</IdLocation>
<IndexLocation>^web.DHCWLHSQueryI</IndexLocation>
<StreamLocation>^web.DHCWLHSQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
