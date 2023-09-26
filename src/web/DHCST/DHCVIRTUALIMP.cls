Import sqluser

/// Descript:虚拟入库
/// Creater:    caoting
/// CreateDate:	2012-11-26
/// 
Class web.DHCST.DHCVIRTUALIMP Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Query QueryBatInfo(Parref As %String) As %Query(ROWSPEC = "Inclb:%String,Incicode:%String,Incidesc:%String,Batno:%String,Expdate:%String,Uom:%String,Rp:%String,Sp:%String,StkQty:%String") [ SqlProc ]
{
}

ClassMethod QueryBatInfoExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
 s endpage=Start+Limit  //结束行
 s stpage=Start+1 //开始行
 s h=0
 s pid=..NewPid()
 s ingrdate=$p(Parref,"^",1)
 s locdr=$p(Parref,"^",2)
 s inci=$p(Parref,"^",3)
 ;s sqlStr = "select inclb_rowid as inclb,inclb_incib_dr->incib_no as batno,inclb_incib_dr->incib_expdate as expdate  from inc_itmlcbt"_ 
 ;  " where inclb_incil_parref->incil_ctloc_dr="_locdr_" and inclb_incil_parref->incil_inci_parref="_inci
 s cilsub=$o(^INCI("IL_LOC",locdr,inci,""))
 s clbsub=""
 f  s clbsub=$o(^INCI(inci,"IL",cilsub,"LB",clbsub)) q:clbsub=""  d
 .s inclb=inci_"||"_cilsub_"||"_clbsub
 .s qty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
 .s incibdr=$p(^INCI(inci,"IL",cilsub,"LB",clbsub),"^",1)
 .s incibsub=$p(incibdr,"||",2)
 .s incibno=$p(^INCI(inci,"IB",incibsub),"^",1)
 .s expdate=$p(^INCI(inci,"IB",incibsub),"^",2)
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s incidesc=$p(^INCI(inci,1),"^",2)
 .s buom=$p(^INCI(inci,1),"^",10)
 .s uom=$p(^INCI(inci,3),"^",6)  //入库单位作为缺省单位
 .i uom="" s uom=buom
 .s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
 .s qty=qty/fac
 .s uomdesc=$p(^CT("UOM",uom),"^",2)
 .i expdate'="" s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
 .s data=inclb_"^"_incicode_"^"_incidesc_"^"_incibno_"^"_expdate_"^"_uomdesc_"^"_qty_"^"_uom
 .s h=h+1
 .s ^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)=data
 
 q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s maxrow=h
 i endpage>maxrow s endpage=maxrow
 s count=0
 s h=""
 f  s h=$o(^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)) q:h=""  d
 .s data=^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)
 .s inclb=$p(data,"^",1)
 .s incicode=$p(data,"^",2)
 .s incidesc=$p(data,"^",3)
 .s incibno=$p(data,"^",4)
 .s expdate=$p(data,"^",5)
 .s uom=$p(data,"^",8)
 .s qty=$p(data,"^",7)
 .s uomdesc=$p(data,"^",6)
 .s count=count+1
 .q:count<stpage
 .q:count>endpage
 
 .s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inclb",inclb)
 .s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Incicode",inclb)
 .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Incidesc",inclb)
 .s batno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Batno",incibno)
 .s expdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Expdate",expdate)
 .s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Uom",uom)
 .w !,uom
 .s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UomDesc",uomdesc)
 .w !,uomdesc
 .s stkqty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("StkQty",qty)
 .s tmpstr=inclb_incicode_incidesc_batno_expdate_uom_uomdesc_stkqty
 .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
 .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
 .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
 .i count=stpage w startString
 .i count<endpage w firstrow
 .i count=endpage w lastrow
 k ^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid)
 q ""
}

ClassMethod QueryBatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBatInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryBatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBatInfoExecute ]
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

/// w ##class(web.DHCST.DHCVIRTUALIMP).GetBatInfo("0","30","257^XKF000092")
ClassMethod GetBatInfo(Start As %String, Limit As %String, Parref As %String) As %String
{
 n (Start,Limit,Parref)
 //s ^YSJTMP("GetBatInfo")=$LB(Start,Limit,Parref)
 s endpage=Start+Limit  //结束行
 s stpage=Start+1 //开始行
 s h=0
 s pid=..NewPid()
 s $zt="ErrorGetBatInfo"
 s locdr=$p(Parref,"^",1)
 s code=$p(Parref,"^",2)
 s code=$$ALPHAUP^SSUTIL4(code)
 q:code="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s inci=$o(^INCI(0,"Code",code,0))
 q:inci="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s cilsub=$o(^INCI("IL_LOC",locdr,inci,""))
 q:cilsub="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s clbsub=0
 f  s clbsub=$o(^INCI(inci,"IL",cilsub,"LB",clbsub)) q:clbsub=""  d
 .s inclb=inci_"||"_cilsub_"||"_clbsub
 .s qty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
 .s incibdr=$p(^INCI(inci,"IL",cilsub,"LB",clbsub),"^",1)
 .s incibsub=$p(incibdr,"||",2)
 .s incibno=$p(^INCI(inci,"IB",incibsub),"^",1)
 .s expdate=$p(^INCI(inci,"IB",incibsub),"^",2)
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s incidesc=$p(^INCI(inci,1),"^",2)
 .s buom=$p(^INCI(inci,1),"^",10)
 .s uom=$p(^INCI(inci,3),"^",6)  //入库单位作为缺省单位
 .i uom="" s uom=buom
 .s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
 .s qty=qty/fac
 .s uomdesc=$p(^CT("UOM",uom),"^",2)
 .i expdate'="" s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
 .s manfinfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)  //批次厂家
 .s manfid=$p(manfinfo,"^",1)
 .s manfdesc=$p(manfinfo,"^",2)
 .s lastingri=##class(web.DHCST.Common.DrugStkCommon).LastINGRI(inclb)
 .s sp="",rp=""
 .i (+$p(lastingri,"||",2)'=0)&&($d(^DHCINGR(+lastingri,"GRI",$p(lastingri,"||",2)))) d
 ..s lastuom=$p(^DHCINGR(+lastingri,"GRI",$p(lastingri,"||",2)),"^",10)
 ..s sp=$p(^DHCINGR(+lastingri,"GRI",$p(lastingri,"||",2)),"^",32)
 ..s rp=$p(^DHCINGR(+lastingri,"GRI",$p(lastingri,"||",2)),"^",30)
 ..i lastuom'=uom d
 ...s lufac=##Class(web.DHCSTCOMMONSRV).UOMFac(lastuom,buom)
 ...s sp=(sp*lufac)/fac
 ...s rp=(rp*lufac)/fac
 ...i $d(^$R("^web.DHCSTCOMMPARA.1")) d
 ....s LocId=$p(^INCI(inci,"IL",cilsub),"^",1)
 ....s HospID=$p($g(^CTLOC(LocId)),"^",22)
 ....S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID) //DHC_STCustomer
 ....S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 ....S StkTypeDesc=$P(CatGrpStr,"^",4)
 ....S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 ....i uom=buom d
 .....s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",2)
 .....s sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(sp,Perv,"FmtRP",2)
 ....e  d
 .....s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,Perv,"FmtRP",1)
 .....s sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(sp,Perv,"FmtRP",1)
 .s data=inclb_"^"_incicode_"^"_incidesc_"^"_incibno_"^"_expdate_"^"_uomdesc_"^"_qty_"^"_uom_"^"_inci_"^"_manfid_"^"_manfdesc_"^"_rp_"^"_sp
 .s h=h+1
 .s ^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)=data 
 q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s maxrow=h
 i endpage>maxrow s endpage=maxrow
 s count=0
 s h=""
 f  s h=$o(^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)) q:h=""  d
 .s data=^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid,"index",h)
 .s inclb=$p(data,"^",1)
 .s incicode=$p(data,"^",2)
 .s incidesc=$p(data,"^",3)
 .s incibno=$p(data,"^",4)
 .s expdate=$p(data,"^",5)
 .s uom=$p(data,"^",8)
 .s qty=$p(data,"^",7)
 .s uomdesc=$p(data,"^",6)
 .s inci=$p(data,"^",9)
 .s manf=$p(data,"^",10)
 .s manfdesc=$p(data,"^",11)
 .s rp=$p(data,"^",12)
 .s sp=$p(data,"^",13)
 .s count=count+1
 .q:count<stpage
 .q:count>endpage 
 .s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inclb",inclb)
 .s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Incicode",incicode)
 .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Incidesc",incidesc)
 .s batno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Batno",incibno)
 .s expdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Expdate",expdate)
 .s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Uom",uom)
 .s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UomDesc",uomdesc)
 .s inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inci",inci)
 .s manfdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Manf",manfdesc)
 .s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfId",manf)
 .s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",rp)
 .s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Sp",sp)
 .s stkqty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("StkQty",qty)
 .s tmpstr=inclb_incicode_incidesc_batno_expdate_uom_uomdesc_inci_manf_manfdesc_rp_sp_stkqty
 .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
 .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
 .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
 .i count=stpage w startString
 .i count<endpage w firstrow
 .i count=endpage w lastrow
 k ^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid)
 q ""
ErrorGetBatInfo
	k ^TMP("DHCST","DHCVIRTUALIMP","GetBatInfo",pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

ClassMethod NewPid() As %String
{
	q $I(^DHCSTPID("DHCVIRTUALIMP"))
}

ClassMethod Save(MainInfo As %String, ListData As %String) As %String
{
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s IngrId=..InsMaster(MainInfo)     ;保存入库主表
    
    i +IngrId<=0 trollback
    q:+IngrId<=0 IngrId
    
    i ListData'=""  d
    .s Ret=..InsRecItm(IngrId,ListData)
    tcommit    ;只要有入库单明细保存成功，则提交事务
    q:Ret<0 Ret
    q IngrId
}

ClassMethod InsMaster(MainInfo As %String) As %String
{
	n (MainInfo)
	s VenId=$P(MainInfo,"^",2)
	s LocId=$p(MainInfo,"^",1)
	s CreateUser=$p(MainInfo,"^",4)
	s CreateDate=+$h-30000
    s CreateTime=$p($h,",",2)
    s StkGrpId=$p(MainInfo,"^",3)
    s IngrNo=$p(MainInfo,"^",5)
    s tmpIngrId=""
    i IngrNo'="" d
    .&SQL(SELECT INGR_RowId into :tmpIngrId FROM DHC_INGdRec WHERE INGR_No=:IngrNo)
    q:tmpIngrId'="" tmpIngrId
    s AppName=##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
    ;生成单号需加锁
    s ret=##class(web.DHCST.Common.AppCommon).Lock("IMPORTNO")  
    q:ret'=0 -99  ;加锁失败
    ;
    s rowid=($o(^DHCINGR(""),-1)+1)
    i AppName="" d
    .s IngrNo="XUNI"_rowid
    e  d
    .s IngrNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
    i IngrNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("IMPORTNO")
    q:IngrNo="" -2   ;生成单号失败
    
    s Err=0
    
    s PLIST(2)=VenId   ;vendor
    s PLIST(10)=IngrNo    ; 入库单号
    s PLIST(5)=CreateDate			;rec date
    s PLIST(17)=CreateDate   ; create date
    s PLIST(3)="Y"    ;completed flag
    s PLIST(16)=CreateUser   ; user
    s PLIST(13)=CreateUser  ;user
    s PLIST(14)=CreateTime
    s PLIST(18)=PLIST(14)    ; rec time
    s PLIST(15)=LocId
    s PLIST(30)="Y"
    s PLIST(31)=..sssCode()
    &sql(insert into DHC_InGdrec values PLIST())
    i SQLCODE'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:dhc_ingdrec",IngrNo,SQLCODE_":"_%msg)
    .s Err=-4  
    s dhcingr=%ROWID
    d ##class(web.DHCST.Common.AppCommon).UnLock("IMPORTNO")
    q:Err'=0 Err
    q:+dhcingr'>0 -5
    q dhcingr
}

ClassMethod InsRecItm(IngrId As %String, ListData As %String) As %String
{
	
	s Len=$l(ListData,$c(1))
    s Count=0
    s Err1=""
    f i=1:1:Len  d
    .s Detail=$p(ListData,$c(1),i)
    .s Ret=..InsertDetail(IngrId,Detail)
    .i Ret=""  d
    ..s Err1=Err1_","_Ret
    .e  d
    ..s Count=Count+1
    q:Count=0 -6  ;所有明细保存均失败
    q:Err1'="" -7 //_"^"_Err  ;保存失败的药品
    q 0
}

ClassMethod InsertDetail(IngrId As %String, Detail As %String) As %String
{
 s Err=0
 s inclb=$p(Detail,"^",1)
 s tmpIngdItmId=""
 &SQL(SELECT INGRI_RowId into :tmpIngdItmId FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef=:IngrId AND INGRI_INCLB_DR=:inclb)
 q:tmpIngdItmId'="" tmpIngdItmId
 s incicode=$p(Detail,"^",2)
 s incidesc=$p(Detail,"^",3)
 s batno=$p(Detail,"^",4)
 s expdate=$p(Detail,"^",5)
 s expdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(expdate)
 s uom=$p(Detail,"^",6)
 s uom=##class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
 s rp=$p(Detail,"^",7)
 s sp=$p(Detail,"^",8)
 s stkqty=$p(Detail,"^",9)
 s recqty=$p(Detail,"^",10)
 s manfid=$p(Detail,"^",11)
 S BUomID=$P(^INCI(+inclb,1),"^",10)
 s SpAmt=sp*recqty			//售价金额
 s RpAmt=rp*recqty			//进价金额
 s recloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
 Q:recloc="" -3
 
 s ch=$o(^DHCINGR(IngrId,"GRI",""),-1)+1
 s PLIST(0)=IngrId
 s PLIST(2)=batno
 s PLIST(4)=ch
 s PLIST(5)=recloc
 s PLIST(6)=uom  
 s PLIST(8)=expdate 
 s PLIST(12)=inclb
 s PLIST(18)=+recqty
 s PLIST(21)=incidesc
 s PLIST(28)=+inclb   ;inci_dr
 s PLIST(33)=+rp  		;进价
 s PLIST(34)=+RpAmt   	;进价金额
 s PLIST(35)=+sp
 s PLIST(38)=+rp   		;批价
 s PLIST(3)=+RpAmt   	;批价金额
 s PLIST(54)=+SpAmt   	;售价金额
 s PLIST(48)=+sp   		;入库售价
 s PLIST(49)=+SpAmt   	;入库售价金额
 s PLIST(32)=manfid     ;厂商
 &sql(insert into dhc_ingdrecitm values PLIST())
 i SQLCODE'=0  d
 .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_INGdRecItm",incidesc,SQLCODE_":"_%msg)
 .s Err=-3
 q:Err'=0 ""    ;保存入库明细失败
 q $p($g(%ROWID),$c(1))
}

}
