Import sqluser

/// Descript:依据库存上下限生成采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-01
Class web.DHCST.INPurPlanAuxByLim Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:根据库存上下限生成采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-03
/// Table:INC_ItmLoc
/// Input:科室id,类组id,补货标准取整比例
/// Output:     
/// Return:Inci^InciCode^InciDesc^PurUomId^PurUomDesc^PurQty^ManfDesc^VenDesc^CarrierDesc^Spec^StkQty^Rp^MaxQty^MinQty^RepQty^LevelQty^BUomId^ConFac
ClassMethod QueryLocItmForPurch(StrParam As %String) As %Library.String
{
    n (StrParam,%session)
    s PurLocId=$p(StrParam,"^",1)
    s StkGrpId=$p(StrParam,"^",2)
    s IntFac=$p(StrParam,"^",3)
    s userId=$p(StrParam,"^",4)
    s zbflag=$p(StrParam,"^",5)
    s StkCatId=$p(StrParam,"^",6)
    s gGroupId=$p(StrParam,"^",7)
    ;
    q:PurLocId="" -1
    ;s json = ##class(Code.JsonObj).%New()
    s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(userId,..sssCode())  //若类组为空，则传递User类组串
    S HospID=$P(^CTLOC(PurLocId),"^",22)
    s appName=##class(web.DHCST.INPurPlan).%GetParameter("AppName")
    s params=gGroupId_"^"_PurLocId_"^"_userId_"^"_HospID
	s getQtyWay = ##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName, "GetQtyWay", params)
    s Title="Inci^InciCode^InciDesc^PurUomId^PurUomDesc^PurQty^ManfDesc^VenDesc^CarrierDesc^Spec^StkQty^Rp^MaxQty^MinQty^RepQty^LevelQty^BUomId^ConFac^VenId^ManfId^CarrierId^RepLev^ApcWarn^StkCatDesc^Qty"
    s count=0
    w "{results:0,rows:["
    s Inci=0
    f  s Inci=$O(^INCI("IL_LOC",PurLocId,Inci)) q:Inci=""  d
    .s obj=##class(User.INCItm).%OpenId(Inci,0)
    .s notUseFlag=obj.INCINotUseFlag
    .q:notUseFlag="Y"
    .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
    .s TmpSktGrp=$p(StkGrpInfo,"^",5)
    .q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpSktGrp_"^"))
    . 
    .s incZBFlag=..GetItmPbFlag(Inci)
    .q:(zbflag="2")&&(incZBFlag'=1) //招标
    .q:(zbflag="3")&&(incZBFlag=1)  //非招标
    .
    .s StkCatIditm=$p(^INCI(Inci,2),"^",2) // 库存分类
    .s:StkCatIditm'="" StkCatDesc=$p(^INC("SC",StkCatIditm),"^",2)
    .q:(StkCatId'="")&(StkCatIditm'=StkCatId)
    .
    .s ch=$O(^INCI("IL_LOC",PurLocId,Inci,"")) 
    .q:ch=""
    .;b ;00
    .s maxQty=$p(^INCI(Inci,"IL",ch),"^",7) 
    .s minQty=$p(^INCI(Inci,"IL",ch),"^",4) 
    .//q:maxQty=""
    .//q:minQty=""
    
    .;b ;01
    .s repqty=$p(^INCI(Inci,"IL",ch),"^",6)     ;标准库存
    .q:(repqty="")&&((maxQty="")||(minQty=""))
    .q:+repqty<0   ; if the repqty is less than zero then  quit
    .;b ;1
    .s replev=$p(^INCI(Inci,"IL",ch),"^",5)    ;补货标准 
    .s:repqty="" repqty=minQty+((maxQty-minQty)/2)  //参照标准数(上限和下限的中间值)
    .s curqty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PurLocId,+$h)  ; present qty 
    .s levelQty=repqty
    .q:curqty>levelQty   //没必要补货
    .;b ;2 
    .s bpurqty=+repqty-curqty
    .q:bpurqty'>0    ; no need to repire the stock qt
    .;b ;3
    .s code=obj.INCICode
    .s desc=obj.INCIDesc
    .s uom=obj.INCICTUOMDR.%Id()
    . 
    .s uomdesc=obj.INCICTUOMDR.CTUOMDesc
    . 
    .s pUom=obj.INCICTUOMPurchDR.%Id()
    .s pUomDesc=obj.INCICTUOMPurchDR.CTUOMDesc
    .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,uom)
    . 
    .s purqty=+bpurqty/fac  ; puruom qty  
    .s incsb=$p(^INCI(Inci,"IL",ch),"^",2)    ; bin
    .i incsb'=""  s sbDesc=$p($G(^INC("SB",incsb)),"^",2)   ; stkbin desc
    .//s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,+$h,pUom,HospID)
    .s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,+$h,pUom,HospID,"G","")
    .;b ;4
    .s oripurqty=purqty
    .i IntFac'=""  d
    ..s purqty=##class(web.DHCST.DHCINIsTrfAuxByLim).GetFinalQty(Inci,PurLocId,bpurqty,IntFac)
    ..s bpurqty=purqty
    ..s purqty=purqty/fac
    .q:(IntFac'="")&(+purqty<1)
    .q:(IntFac="")&(+purqty'>0)
    .;b ;5
    .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
    .s curqty=curqty/fac    
    .s repqty=repqty/fac
    .s levelQty=levelQty/fac
    .s maxQty=maxQty/fac
    .s minQty=minQty/fac
    .s replev=replev/fac
    .s ItmInfo=##class(web.DHCST.INPurPlan).GetItmInfo(Inci,gGroupId_"^"_PurLocId_"^"_userId)
    .s VenId=$p(ItmInfo,"^",1)
    .s VenDesc=$p(ItmInfo,"^",2)
    .s ManfId=$p(ItmInfo,"^",3)
    .s ManfDesc=$p(ItmInfo,"^",4)
    .s CarrierId=$p(ItmInfo,"^",5)
    .s CarrierDesc=$p(ItmInfo,"^",6)
    .s ret=0
    .s ApcWarn = ##class(PHA.IN.Cert.Query).CheckExpDate(VenId,ManfId)
    .s Rp=$p(ItmInfo,"^",9)
    .s qty = purqty
    .i $d(^DHCITMINFO(0,"INCI",Inci)) d
    ..s ItmInfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
    ..s packPurFac=$p(^DHCITMINFO(ItmInfoId),"^",52)
    ..i +packPurFac>0 d
    ...i (getQtyWay = "2") d
    ....s qty = $SYSTEM.SQL.FLOOR(purqty/packPurFac) * packPurFac  //向下取整后转换  
    ...i (getQtyWay = "3") d
    ....s qty = ##class(%SYSTEM.SQL).CEILING(purqty/packPurFac) * packPurFac  //向上取整后转换  by zhaoxinlong  2022.04.01
    .s Data1=Inci_"^"_code_"^"_desc_"^"_pUom_"^"_pUomDesc_"^"_purqty_"^"_ManfDesc_"^"_VenDesc
    .s Data2=CarrierDesc_"^"_spec_"^"_curqty_"^"_Rp_"^"_maxQty_"^"_minQty_"^"_repqty_"^"_levelQty_"^"_uom_"^"_fac
    .s Data3=VenId_"^"_ManfId_"^"_CarrierId_"^"_replev_"^"_ApcWarn_"^"_StkCatDesc _"^"_ qty
    .s Data=Data1_"^"_Data2_"^"_Data3
    .s count=count+1
    .i count=1 d
    ..w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    .e  d
    ..w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    .
    .;d json.InsertRowData(Data)
    .
    
    w "]}"
    
    //s Title="Inci^InciCode^InciDesc^PurUomId^PurUomDesc^PurQty^ManfDesc^VenDesc^CarrierDesc^Spec^StkQty^Rp^MaxQty^MinQty^RepQty^LevelQty^BUomId^ConFac^VenId^ManfId^CarrierId^RepLev^ApcWarn"
    //s resultString = json.getJsonData(Title,count)
    ;k json
    ;Q resultString
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("INPurPlanAuxByLim"))
}

/// Description:取得某库存项的招标标志
/// Input:inci_itmRowid
/// Output:0-非招标,1-招标
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
ClassMethod GetItmPbFlag(inci)
{
 n (inci)
 q:inci="" ""
 s pbflag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inci)
 q pbflag
}

Query GetAllLocStk(Inci As %String) As %Query(ROWSPEC = "Loc:%String,Uom:%String,StkQty:%String,MaxQty:%String,MinQty:%String,RepQty:%String")
{
}

ClassMethod GetAllLocStkExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 s incicode=$p(^INCI(Inci,1),"^",1)
 s ctuom=$p(^INCI(Inci,1),"^",10)
 s pctuom=$p(^INCI(Inci,3),"^",6)
 s factor=+##Class(web.DHCSTCOMMONSRV).UOMFac(pctuom,ctuom)
 s pctuom=$p(^CT("UOM",pctuom),"^",2)
 ;s dispensing="D"
 ;s orderFieldName=""
 ;s Sort=$$ALPHAUP^SSUTIL4(Sort)
 ;s:Sort="CTLOC" orderFieldName="ctloc"
 ;s:Sort="MAXQTY" orderFieldName="maxqty"
 ;s:Sort="MINQTY" orderFieldName="minqty"
 ;s:Sort="REPQTY" orderFieldName="repqty"
 
 ;s sql="select INCIL_CTLOC_DR->ctloc_desc ctloc,"
 ;s sql=sql_"incil_maxqty maxqty,"
 ;s sql=sql_"incil_minqty minqty,"
 ;s sql=sql_"incil_repqty repqty"
 ;s sql=sql_" from inc_itmloc"
 ;s sql=sql_" where INCIL_INCI_ParRef="_Inci_" and INCIL_CTLOC_DR->CTLOC_Type="_dispensing
 
 
 ;s xrs=##class(%Library.ResultSet).%New()
 ;d xrs.Prepare(sql)
 ;s sc=xrs.Execute()
 ;i $$$ISERR(sc) q $$$OK
 
 ;while (xrs.Next())
 ;{
 ; s ctloc=xrs.Data("ctloc")
 ; s maxqty=xrs.Data("maxqty")
 ; s minqty=xrs.Data("minqty")
 ; s repqty=xrs.Data("repqty")
 ; s qty=$$CurQtyU(incicode,loc,pctuom)
 ; s maxqty=maxqty/factor
 ; s minqty=minqty/factor
 ; s repqty=repqty/factor
 ; d OutPutRow1
 ;}
 s incilsub=""
 f  s incilsub=$o(^INCI(Inci,"IL",incilsub)) q:incilsub=""  d
 .s locdr=$p(^INCI(Inci,"IL",incilsub),"^",1)
 .s locdesc=$p(^CTLOC(locdr),"^",2)
 .s loctype=$p(^CTLOC(locdr),"^",13)
 .q:loctype'="D"
 .s maxqty=$p(^INCI(Inci,"IL",incilsub),"^",7)
 .s minqty=$p(^INCI(Inci,"IL",incilsub),"^",4)
 .s repqty=$p(^INCI(Inci,"IL",incilsub),"^",6)
 .s qty=$$CurQtyU1(Inci,locdr,pctuom)
 .d OutPutRow11
 q $$$OK
OutPutRow11
 s Data=$lb(locdesc,pctuom,qty,maxqty,minqty,repqty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
CurQtyU1(inci,loc,UOMDesc)
 n (inci,loc,UOMDesc)
 q:inci="" 0
 q:loc="" 0
 q:UOMDesc="" 0
 s UOM=##Class(web.DHCSTCOMMONSRV).CTUOMToID(UOMDesc) q:UOM="" 0    
 s BUOM=$p(^INCI(inci,1),"^",10) q:BUOM="" 0
 s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
 s dd=+$h
 s qty=$$IL1(inci,loc,dd)
 s qty=qty/fac
 q qty
IL1(inci,loc,dd) 
 ;ret value :
 ; <0 - error occurs
 n (inci,loc,dd)
 q:inci="" 0
 q:loc="" 0
 q:dd="" 0
 s nextdate=dd+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$p(^DHCLOCTOT(rr),"^",4)
 q qty
}

ClassMethod GetAllLocStkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllLocStkExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetAllLocStkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllLocStkExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
