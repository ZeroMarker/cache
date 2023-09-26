Import sqluser

/// Descript:药品库存管理信息相关的公共方法
/// Creater: ZhangDongmei
/// CreateDate: 2012-05-03
Class web.DHCST.Common.DrugStkCommon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

ClassMethod Bat(inclbid) As %Library.String
{
 s incibid=""
 i ($p(inclbid,"||",1)'="")&($p(inclbid,"||",2)'="")&($p(inclbid,"||",3)'="") d 
 .q:'$d(^INCI($p(inclbid,"||",1),"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)))
 .s incibid=$p(^INCI($p(inclbid,"||",1),"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
 s batno=""
 i incibid'=""  d
 .s batno=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",1)
 .s expdate=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",2)
 .i expdate'="" s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
 q $g(batno)_"^"_$g(expdate)
}

ClassMethod GetStkBin(dept, inci) As %Library.String
{
 k P0
 &SQL(select incil_incsb_dr->incsb_desc,incil_incsb_dr into :csbdes,:incsb from inc_itmloc 
 where incil_ctloc_dr=:dept and incil_inci_parref=:inci)
 s P0=$g(csbdes)
 q $g(csbdes)_"^"_$g(incsb)
}

/// 取货位名称
/// Author:zhwh
/// Date:2012-08-10
/// Argu:
///  incil - 科室库存项目的rowid
/// Return:
/// 货位名称
ClassMethod GetStkBinByIncil(incil) As %Library.String
{
 &SQL(select incil_incsb_dr->incsb_desc,incil_incsb_dr into :csbdes,:incsb from inc_itmloc 
 where %id=:incil)
 q $g(csbdes)_"^"_$g(incsb)
}

/// Description:根据批次取某药品的厂家
/// Input:inc_itmlcbt表rowid
/// Output:厂家id^厂家名称
/// Creator:zdm
/// CreateDate:2012-02-01
ClassMethod GetManfInfoByInclb(inclb) As %Library.String
{
 q:inclb="" ""
 s inci=+inclb
 s il=$p(inclb,"||",2)
 s lb=$p(inclb,"||",3)
 s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
 q:incib="" ""
 s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
 q:dhcincib="" ""
 s manfid=$p(^DHCINCIB(dhcincib),"^",7)
 ;批次表里没存的话取入库子表
 i manfid=""  d
 .s dhcingr=""
 .f  s dhcingr=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr),-1)  q:(dhcingr="")!(manfid'="")  d
 ..s chl=""
 ..f  s chl=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr,chl),-1)  q:(chl="")!(manfid'="")  d
 ...s manfid=$p(^DHCINGR(dhcingr,"GRI",chl),"^",29)
 ..
 .
 s:manfid'="" manf=$p($g(^PHMNF(manfid)),"^",2)
 q manfid_"^"_$g(manf)
}

ClassMethod GetInclbVend(inclb, dah) As %Library.String
{

 ;查找截止到某日期的最后一个供应商
 q:inclb="" ""
 s dhcingr=..GetClbDHCIngr(inclb,dah)
 s dhcingr=+dhcingr
 q:dhcingr="0" ""
 s vendr=$p(^DHCINGR(dhcingr),"^",3)
 q:vendr="" ""
 q:'$d(^APC("APCVM",vendr)) ""
 s vendesc=$p(^APC("APCVM",vendr),"^",3)
 q vendr_"^"_vendesc
}

/// Description:取某药品最后一次入库的供应商
/// Input:库存项rowid
/// Output:供应商id^供应商名称
/// Creator:zdm
/// CreateDate:2012-06-19
ClassMethod GetLastVen(IncId) As %Library.String
{
 s VenDes=""
 s Ingr=""
 f  s Ingr=$o(^DHCINGR(0,"INCI",IncId,Ingr),-1) q:(Ingr="")!(VenDes'="")  d
 .q:'$d(^DHCINGR(Ingr))
 .s IngrDate=$P(^DHCINGR(Ingr),"^",4)
 .q:IngrDate=""
 .s Apcvm=$p(^DHCINGR(Ingr),"^",3)
 .q:Apcvm=""
 .q:'$d(^APC("APCVM",Apcvm))
 .s VenDes=$p(^APC("APCVM",Apcvm),"^",3)
 .s VenCod=$p(^APC("APCVM",Apcvm),"^",2)
 q $g(Apcvm)_"^"_$g(VenDes)
}

/// Description:取某药品最后一次入库的厂商
/// Input:库存项rowid
/// Output:厂商id^厂商名称
/// Creator:zdm
/// CreateDate:2012-06-19
ClassMethod GetLastManf(IncId) As %Library.String
{
 s ManfDesc=""
 s Ingr=""
 f  s Ingr=$o(^DHCINGR(0,"INCI",IncId,Ingr),-1) q:(Ingr="")!(ManfDesc'="")  d
 .s Chl=""
 .f  s Chl=$o(^DHCINGR(0,"INCI",IncId,Ingr,Chl),-1) q:(Chl="")!(ManfDesc'="")  d
 ..q:'$d(^DHCINGR(Ingr))
 ..s IngrDate=$P(^DHCINGR(Ingr),"^",4)
 ..q:IngrDate=""
 ..s ManfId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",29)
 ..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
 ..
 .
 q $g(ManfId)_"^"_$g(ManfDesc)
}

ClassMethod GetClbDHCIngr(inclb, dah = "") As %Library.String
{

 ;查找截止到某日期的最后一个入库单
 s inclb=$g(inclb),dah=$g(dah)
 i dah="" s dah=+$h
 q:inclb="" ""
 s incib=$p($g(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3))),"^",1) 
 q:incib="" ""
 s tingr="",INGR="",chidId=""
 s INGR=""
 f  s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR),-1)  q:(tingr'="")!(INGR="")   d
 . s grdate=$p(^DHCINGR(INGR),"^",4)
 . s:grdate'>dah tingr=INGR
 . s chidId=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""))
 s dhcingr=tingr
 q:dhcingr="" ""
 q:'$d(^DHCINGR(dhcingr)) ""
 q dhcingr_"||"_chidId
}

/// Creator:ZhangDongMei;
/// CreatDate:2012-02-15
/// Description:判断是否管理药
/// Table:DHC_StkCatGroup
/// Input:库存项id
/// Return:1:管理药;0:非管理药
ClassMethod GetManageflag(LocId, InciId) As %Library.String
{
  s Flag=0 
  q:LocId="" 0
  q:InciId="" 0
  ;管理药
  s incilCh=$o(^INCI("IL_LOC",LocId,InciId,""))
  q:incilCh="" Flag
  s incil=InciId_"||"_incilCh
  q:incil="" Flag
  s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
  q:dhcincil="" Flag
  s Flag=$p($G(^DHCINCIL(dhcincil)),"^",9)
  s:Flag'=1 Flag=0
  
  q Flag
}

/// Descript: 根据库存项的ID、药房及开始时间取基本单位数量
/// Creater: Zhouyg
/// CreateDate: 20100302
/// Input: 	inci,loc,dd
/// Output: 	Return
/// Return： 基本单位数量
ClassMethod IL(inci, loc, dd)
{
 ;ret value :
 ; <0 - error occurs
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

ClassMethod LocDayQtyUom(inci, loc, UOM, dd) As %Library.String
{
 q:inci="" 0
 q:loc="" 0
 q:UOM="" 0
 ;
 s BUOM=$p(^INCI(inci,1),"^",10) 
 q:BUOM="" 0
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UOM,BUOM)
 s dd=+dd
 s:dd=0 dd=+$h
 s qty=..IL(inci,loc,dd)
 s qty=qty/fac
 q qty
}

ClassMethod GetItmLocMNRQtyUO(InciId, LocId, UomId) As %Library.String
{
  q:InciId="" ""
  q:LocId="" ""
  q:UomId="" ""
  s Chl=$o(^INCI("IL_LOC",LocId,InciId,0))
  q:Chl="" ""
  s MinQty=$p(^INCI(InciId,"IL",Chl),"^",4)
  s MaxQty=$p(^INCI(InciId,"IL",Chl),"^",7)
  s RepQty=$p(^INCI(InciId,"IL",Chl),"^",6)
  s BUomId=$p(^INCI(InciId,1),"^",10)
  s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
  s MinQty=$fn(MinQty/ConFac,"",2)
  s MaxQty=$fn(MaxQty/ConFac,"",2)
  s RepQty=$fn(RepQty/ConFac,"",2)
  q MinQty_"^"_MaxQty_"^"_RepQty
}

ClassMethod QtyINCLBUom(inclb, UOM, dd) As %Library.String
{
 q:inclb="" 0
 ;
 s inci=+inclb
 s BUOM=$p(^INCI(inci,1),"^",10) 
 q:BUOM="" 0
 s:UOM="" UOM=BUOM
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UOM,BUOM)
 s dd=+dd
 s:dd=0 dd=+$h
 s qty=..QtyINCLB(inclb,dd)
 s qty=qty/fac
 q qty
}

/// Descript:将基本单位库存转换成带单位的库存量（××盒××支）
/// Creater: ZhangDongmei
/// CreateDate: 2012-02-15
/// Table:
/// Input:库存项id,基本单位库存量
/// Output:
/// Return：库存量
/// 
ClassMethod QtyWithUom(inci, qty) As %Library.String
{
 q:inci="" 0
 q:+qty=0 0
 i qty<0 s tmpqty=qty,qty=-qty
 
 s BUOM=$p(^INCI(inci,1),"^",10) 
 q:BUOM="" 0
 s PurUom=$p(^INCI(inci,3),"^",6)
 s:PurUom="" PurUom=BUOM
 s PurUomDesc=$p(^CT("UOM",PurUom),"^",2)
 i $f(PurUomDesc,"[")  d
 .s PurUomDesc=$p(PurUomDesc,"[",1)
 s BUomDesc=$p(^CT("UOM",BUOM),"^",2)
 
 i PurUom=BUOM d
 .;s:qty<1 qty="0"_qty
 .s PackQty=qty_PurUomDesc
 e  d
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BUOM)
 .s remainder=qty#fac     ;取余
 .;s:remainder<1 remainder="0"_remainder
 .i remainder=0  d
 ..s PackQty=qty/fac_PurUomDesc
 .e  d
 ..s IntQty=qty\fac
 ..i IntQty>0  d
 ...s PackQty=IntQty_PurUomDesc_remainder_BUomDesc
 ..e  d
 ...s PackQty=remainder_BUomDesc
 q:$g(tmpqty)<0 "-"_PackQty
 q PackQty
}

/// 管理组
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  inci - 库存项目rowid
///  locdr - 科室rowid
/// Return:
///  科室库存项管理组rowid
ClassMethod ManGrp(inci, locdr) As %String
{
 q:inci="" ""
 q:locdr="" ""
 s ch=$o(^INCI("IL_LOC",locdr,inci,"")) q:ch="" ""
 s incil=inci_"||"_ch
 q ..ManGrpByIncil(incil)
}

/// 管理组
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  inci - 库存项目rowid
///  locdr - 科室rowid
/// Return:
///  科室库存项管理组rowid
ClassMethod ManGrpByIncil(incil) As %String
{
 q:incil="" ""
 &sql(select incil_lmgrp_dr into :grp from dhc_incitmloc    
  where incil_incil_dr=:incil )
 q $g(grp)
}

/// 是否为管理药？
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  inci - 库存项目rowid
///  locdr - 科室rowid
/// Return:
///   Y - 是
///   '=Y - 否
ClassMethod UseFlag(inci, locdr) As %String
{
 s Flag="N"
 q:inci="" Flag
 q:locdr="" Flag
 s ch=$o(^INCI("IL_LOC",locdr,inci,"")) q:ch="" Flag
 s incil=inci_"||"_ch
 s UseFlag=""
 &sql(select incil_useflag into :UseFlag from dhc_incitmloc    
  where incil_incil_dr=:incil)
 i UseFlag=1 s Flag="Y"
 
 q $g(Flag)
}

/// 库存批次的可用数
/// Date:2012-07-19
/// Argu：
///   incil - 科室库存rowid
///   uomdr - 单位rowid
/// Return:
///  库存批次的可用数
///  w ##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB("533||5","")
ClassMethod CurItmAvaQtyB(incil As %String, uomdr As %String) As %String
{
 s inci=+incil q:inci="" 0
 s ilsub=$p(incil,"||",2) q:ilsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub)) 0
 s loc=$p(^INCI(inci,"IL",ilsub),"^",1)
 s buom=$p(^INCI(inci,1),"^",10) q:buom="" 0
 s:uomdr="" uomdr=buom 
 s lbsub="0",rqty=0,inclbrqty=0,inclbnouseqty=0
 f  s lbsub=$o(^INCI(inci,"IL",ilsub,"LB",lbsub)) q:(lbsub="")!(lbsub="0")  d
 .s inclb=inci_"||"_ilsub_"||"_lbsub
 .s inclbnotuse=..IfDhcInclbNotUse(inclb)
 .s incib=$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",1)
 .q:+$p(incib,"||",2)=0
 .s expdate=+$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
 .i ((inclbnotuse="Y")||((expdate'=0)&&(expdate<=+$h))) s inclbnouseqty=..CurQtyINCLB(inclb)+inclbnouseqty q 
 .s rqty=rqty+..CurInclbResQty(inclb,"")
 .s inclbrqty=0 //inclbrqty+..InclbReservedQty(inclb,"") ///20170110,yunhaibao
 s eqty=..IL(inci,loc,+$h+1)
 s aqty=eqty-rqty-inclbrqty-inclbnouseqty
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buom)
 s aqty=aqty/fac
 q aqty
}

/// 当前科室库存项目的可用数
/// Date:2012-07-19
/// Argu： 
/// itmcode -代码
/// locdesc - 科室 名称
/// uomdesc -单位名称
/// Return: 
///  可用数量
ClassMethod CurItmAvaQty(itmcode As %String, locdesc As %String, uomdesc As %String) As %String
{
 s inci=##class(web.DHCST.Common.DrugInfoCommon).ItemCodeToID(itmcode)
 s loc=##class(web.DHCST.Common.UtilCommon).LocToRowID(locdesc)
 s buom=$p(^INCI(inci,1),"^",10)
 i uomdesc="" s uom=buom
 e   d
 . &sql(select %ID into :uom from CT_UOM where ctuom_desc=:uomdesc)
 q:uom="" 0
 s ilsub=$o(^INCI("IL_LOC",loc,inci,"")) q:$g(ilsub)="" 0
 s incil=inci_"||"_ilsub
 s aqty=..CurItmAvaQtyB(incil,uom)
 q aqty
}

/// 库存批次的占用数
/// Date:2012-07-19
/// Argu:
///  inclb -批次rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   批次的占用数
ClassMethod CurInclbResQty(inclb As %String, uomdr As %String) As %String
{
 s inci="",ilsub="",lbsub="",dqty=0,qty=0
 s inci=$p(inclb,"||",1) q:inci="" 0
 s ilsub=$p(inclb,"||",2) q:ilsub="" 0
 s lbsub=$p(inclb,"||",3) q:lbsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) ""
 s dqty=+$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)
 s buomdr=$p(^INCI(+inclb,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
 s qty=+dqty/fact
 q qty
}

/// 某科室库存项的占用数
/// Date:2012-07-19
/// Argu:
///  incil -科室库存rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   
ClassMethod CurIncResQty(incil As %String, uomdr As %String) As %String
{
 s inci=$p(incil,"||",1) q:inci="" 0
 s ilsub=$p(incil,"||",2) q:ilsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub)) ""
 s dqty=+$p(^INCI(inci,"IL",ilsub),"^",9)
 s buomdr=$p(^INCI(inci,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
 s qty=+dqty/fact
 q qty
}

/// 某科室库存项的占用数(批次占用数的和)
/// Date:2012-07-19
/// Argu:
///  incil -科室库存rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   
ClassMethod CurIncResQtyLb(incil As %String, uomdr As %String) As %String
{
 s inci=$p(incil,"||",1) q:inci="" 0
 s ilsub=$p(incil,"||",2) q:ilsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub)) ""
 //s dqty=+$p(^INCI(inci,"IL",ilsub),"^",9)
 s dqty=0,ilch=""
 f  s ilch=$o(^INCI(inci,"IL",ilsub,"LB",ilch)) q:ilch=""  d
 .s dqtylb=+$p(^INCI(inci,"IL",ilsub,"LB",ilch),"^",3)
 .s dqtylb=+dqtylb
 .s dqty=dqty+dqtylb
 s buomdr=$p(^INCI(inci,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
 s qty=+dqty/fact
 q qty
}

/// 按单位取某库存批次的可用数量
/// Date:2012-07-19
/// Argu:
///   inclb - 批次rowid
///   uomdesc - 单位名称
/// Return:
///  批次可用库存数量
///  
ClassMethod CurInclbAvaQtyUom(inclb As %String, uomdesc As %String) As %String
{
 &sql(select %ID into :uomdr from CT_UOM where ctuom_desc=:uomdesc)
 q:uomdr="" 0
 s aqty=..CurInclbAvaQty(inclb,uomdr)
 q aqty
}

/// 当前批次的可用数量
/// Date:2012-07-19
/// Argu:
///  inclb - 批次rowid
///  uomdr - 单位rowid
/// Return: 
///  数量
ClassMethod CurInclbAvaQty(inclb As %String, uomdr As %String) As %String
{
 s buomdr=$p(^INCI(+inclb,1),"^",10) q:buomdr="" 0
 s:uomdr="" uomdr=buomdr
 s eqty=..CurQtyINCLBURid(inclb,uomdr)
 s rqty=..CurInclbResQty(inclb,uomdr)
 s inclbrqty=0 //..InclbReservedQty(inclb,uomdr) //yunhaibao20170807,可用库存=实际库存-占用库存
 s aqty=eqty-rqty-inclbrqty
 q aqty
}

/// 按要求单位取某批次的当前库存量 
/// Argu: 
///   INCLB -批次rowid
///   UOM - 单位rowid
/// Return:
///   数量 
ClassMethod CurQtyINCLBURid(INCLB As %String, UOM As %String) As %String
{
 q ..QtyINCLBU(INCLB,+$h,UOM)
}

/// 取某批次的当前库存
/// Date:20120-07-19
/// Argu:
///   INCLB - 库存批次rowid
/// Return：
///   库存数量(基本单位)
ClassMethod CurQtyINCLB(INCLB As %String) As %String
{
 q:INCLB="" 0
 s today=$zd(+$h,3)  ; convert time format into "3" 
 q ..QtyINCLB(INCLB,today)
}

/// 取某批次某日期的库存
/// Date:20120-07-19
/// Argu:
/// INCLB - 库存批次rowid
/// DA - 日期 (可以是:内部格式，格式3，格式4)
/// Return：
/// 库存数量(基本单位)
/// 
ClassMethod QtyINCLB(INCLB As %String, DA As %String) As %String
{
 s qty=""
 i DA'="" s DA=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DA)
 s DA=DA+1 q:DA="" 0
 s DD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DA),-1) q:DD="" 0
 s LCBTD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,""),-1)  q:LCBTD="" 0
 s LCBTCH=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,LCBTD,""),-1) q:LCBTCH="" 0
 s qty=$p(^DHCBTLOCTOT(LCBTD,"I",LCBTCH),"^",3)
 q qty
}

/// 取某批次某日期的库存(按要求的库存单位返回)
/// Date:20120-07-19
/// Argu:
/// INCLB - 库存批次rowid
/// dah - 日期
/// uomdr - 库存单位rowid(若为空则自动使用基本单位)
/// Return：
/// 库存数量
ClassMethod QtyINCLBU(INCLB As %String, dah As %String, uomdr As %String) As %String
{
 q:INCLB="" 0
 q:dah="" 0
 s INCI=+INCLB q:INCI="0" 0 
 s BUOM=$p(^INCI(INCI,1),"^",10) q:BUOM="" 0
 i uomdr="" s uomdr=BUOM
 s qty=..QtyINCLB(INCLB,dah)
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,BUOM)
 s qty=+qty/fac
 q qty
}

/// 取出某批次最后的入库记录 
/// Author:zhwh
/// Date:2012-10-31
/// Argu:
/// 	inclb - 库存批次rowid
/// Return:
/// 	入库明细rowid(DHC_InGdRecItm)
ClassMethod LastINGRI(inclb As %String) As %String
{
 s incib=$$CIBrow^at299(inclb)
 q:incib="" ""
 s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
 i INGR d
 .s INGRCH=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""))
 .s INGRI=INGR_"||"_INGRCH
 q $g(INGRI)
}

ClassMethod VendManfByIncIb(incib As %String) As %String
{
 s retstr=""
 s Dhcingr=$o(^DHCINGR(0,"GRI_INCIB",incib,""))
 q:Dhcingr="" ""
 s Dhcingri=$o(^DHCINGR(0,"GRI_INCIB",incib,Dhcingr,""))
 q:Dhcingri="" ""
 s gmanfid=""
 s gmanfid=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",29)
 s Manf=""
 s:gmanfid'="" Manf=$p($g(^PHMNF(gmanfid)),"^",2) 
 s vendordr=""
 s vendordesc=""
 s vendordr=$p(^DHCINGR(Dhcingr),"^",3)
 s:vendordr'="" vendordesc=$p(^APC("APCVM",vendordr),"^",3) 
 s retstr=vendordr_"^"_vendordesc_"^"_gmanfid_"^"_Manf
 q retstr
}

/// Descript：		取某科室某药品某一天的结余售价金额
/// CreateDate:		2014-02-12
/// Argu:
/// INCIL - 科室库存项rowid
/// dah - 	日期
/// Return：	结余售价金额
/// 
ClassMethod GetSpAmt(INCIL As %String, dah As %String) As %String
{
 q:INCIL="" 0
 i dah="" s dah=+$h
 s INCI=+INCIL q:INCI="0" 0
 s ILSub=$p(INCIL,"||",2)
 q:+ILSub=0 0
 s LocID=$p($g(^INCI(INCI,"IL",ILSub)),"^",1)
 q:LocID="" 0
 s TSpAmt=0
 s HospID=$p($g(^CTLOC(LocID)),"^",22)
 s bUomId=$p(^INCI(INCI,1),"^",10)
 s pUomId=$p(^INCI(INCI,3),"^",6)
 s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUomId,bUomId)
 s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
 i (RuleFlag=1)!(RuleFlag=2) d
 .s ILQty=..IL(INCI,LocID,dah)
 .s pILQty=ILQty\bpFac			// 入库单位数量
 .i pILQty>0 d
 ..s Sp=##Class(web.DHCSTPRICE).GetSp(INCI,dah,pUomId,HospID,"")
 ..s TSpAmt=TSpAmt+(pILQty*Sp)
 .s bILQty=ILQty-(pILQty*bpFac)	// 基本单位数量
 .i bILQty>0 d
 ..s Sp=##Class(web.DHCSTPRICE).GetSp(INCI,dah,bUomId,HospID,"")
 ..s TSpAmt=TSpAmt+(bILQty*Sp)
 else  if RuleFlag=3 d
 .s LBSub=0
 .f  s LBSub=$o(^INCI(INCI,"IL",ILSub,"LB",LBSub)) q:LBSub=""  d
 ..s INCLB=INCI_"||"_ILSub_"||"_LBSub
 ..s LBQty=..QtyINCLB(INCLB,dah)
 ..s pLBQty=LBQty\bpFac			// 入库单位数量
 ..i pLBQty>0 d
 ...s Sp=##Class(web.DHCSTPRICE).GetSp(INCLB,dah,pUomId,HospID,"")
 ...s TSpAmt=TSpAmt+(pLBQty*Sp)
 ..s bLBQty=LBQty-(pLBQty*bpFac)	// 基本单位数量
 ..i bLBQty>0 d
 ...s Sp=##Class(web.DHCSTPRICE).GetSp(INCLB,dah,bUomId,HospID,"")
 ...s TSpAmt=TSpAmt+(bLBQty*Sp)
 s TSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(TSpAmt,HospID)
 q TSpAmt
}

/// Descript：		取某科室某药品某一天的结余进价金额
/// CreateDate:		2014-02-12
/// Argu:
/// INCIL - 科室库存项rowid
/// dah - 	日期
/// Return：	结余进价金额
/// 
ClassMethod GetRpAmt(INCIL As %String, dah As %String) As %String
{
 q:INCIL="" 0
 i dah="" s dah=+$h
 s INCI=+INCIL q:INCI="0" 0
 s ILSub=$p(INCIL,"||",2)
 q:+ILSub=0 0
 s LocID=$p($g(^INCI(INCI,"IL",ILSub)),"^",1)
 q:LocID="" 0
 s TRpAmt=0
 s bUomId=$p(^INCI(INCI,1),"^",10)
 s pUomId=$p(^INCI(INCI,3),"^",6)
 s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUomId,bUomId)
 s HospID=$p($g(^CTLOC(LocID)),"^",22)
 s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
 i (RuleFlag=2) d
 .s Rp=##Class(web.DHCSTPRICE).GetRp(INCI,dah,"",HospID,"")
 .s ILQty=..IL(INCI,LocID,dah)
 .s pILQty=ILQty\bpFac			// 入库单位数量
 .i pILQty>0 d
 ..s Rp=##Class(web.DHCSTPRICE).GetRp(INCI,dah,pUomId,HospID,"")
 ..s TRpAmt=TRpAmt+(pILQty*Rp)
 .s bILQty=ILQty-(pILQty*bpFac)	// 基本单位数量
 .i bILQty>0 d
 ..s Rp=##Class(web.DHCSTPRICE).GetRp(INCI,dah,bUomId,HospID,"")
 ..s TRpAmt=TRpAmt+(bILQty*Rp)
 else  if (RuleFlag=1)!(RuleFlag=3) d
 .s LBSub=0
 .f  s LBSub=$o(^INCI(INCI,"IL",ILSub,"LB",LBSub)) q:LBSub=""  d
 ..s INCLB=INCI_"||"_ILSub_"||"_LBSub
 ..s LBQty=..QtyINCLB(INCLB,dah)
 ..s pLBQty=LBQty\bpFac			
 ..i pLBQty>0 d
 ...s Rp=##Class(web.DHCSTPRICE).GetRp(INCLB,dah,pUomId,HospID,"")
 ...s TRpAmt=TRpAmt+(pLBQty*Rp)
 ..s bLBQty=LBQty-(pLBQty*bpFac)
 ..i bLBQty>0 d
 ...s Rp=##Class(web.DHCSTPRICE).GetRp(INCLB,dah,bUomId,HospID,"")
 ...s TRpAmt=TRpAmt+(bLBQty*Rp)
 s TRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(TRpAmt,HospID)
 q TRpAmt
}

/// creator:yunhaibao
/// createdate:2015-12-03
/// description:根据库存项,日期,单位获取指定单位的全院库存,默认基本单位
/// input:库存项id,日期,单位id,院区
/// w ##class(web.DHCST.Common.DrugStkCommon).QtyHospInc(886,"","","")
ClassMethod QtyHospInc(Inci As %String, Hospital As %String = "", date As %String = "", UomDr As %String = "") As %String
{
 i date="" s date=+$h
 e  s date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
 s Inci=+Inci
 q:Inci="0" 0 
 s BUOM=$p(^INCI(Inci,1),"^",10) q:Inci="" 0
 i UomDr="" s UomDr=BUOM
 s hospincqty=0
 s incich=""
 f  s incich=$o(^INCI(Inci,"IL",incich)) q:incich=""  d
 .q:+incich=0
 .q:$p($g(^INCI(Inci,"IL",incich)),"^",1)=""
 .s locrowid=$p(^INCI(Inci,"IL",incich),"^",1)
 .q:+locrowid=0
 .s hospid=$p($g(^CTLOC(locrowid)),"^",22)
 .q:(Hospital'="")&&(Hospital'=hospid)
 .s incilocqty=..IL(Inci, locrowid, date)
 .s hospincqty=hospincqty+incilocqty
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BUOM)
 s hospincqty=+hospincqty/fac
 q hospincqty
}

/// creator:yunhaibao
/// createdate:2015-12-21
/// description:根据库存项,日期,单位,科室获取指定单位的非过期科室库存,默认基本单位
/// input:库存项id,科室id,单位id,日期
/// w ##class(web.DHCST.Common.DrugStkCommon).LocNotOutOfDateQtyUom(858,"loc","uom","date")
ClassMethod LocNotOutOfDateQtyUom(inci, loc, UOM, dd) As %Library.String
{
 q:inci="" 0
 q:loc="" 0
 q:UOM="" 0
 s BUOM=$p(^INCI(inci,1),"^",10) 
 q:BUOM="" 0
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UOM,BUOM)
 s dd=+dd
 s:dd=0 dd=+$h
 s qty=0
 q:'$d(^INCI("IL_LOC",loc,inci)) 0
 s incich=$o(^INCI("IL_LOC",loc,inci,"")) q:incich=""  d
 s incilb=""
 f  s incilb=$o(^INCI(inci,"IL",incich,"LB",incilb)) q:incilb=""  d
 .q:+incilb=0
 .s inclb=inci_"||"_incich_"||"_incilb
 .s incib=$p(^INCI(inci,"IL",incich,"LB",incilb),"^",1)
 .q:+$p(incib,"||",2)=0
 .s expdate=0      ;失效天数
 .s expdate=+$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
 .q:(expdate'=0)&&(expdate<=+dd)
 .s inclbqty=..QtyINCLB(inclb,dd)
 .s qty=qty+inclbqty
 s qty=qty/fac
 q qty
}

/// creator:yunhaibao
/// createdate:20151230
/// description:获取药品批次不可用标志,用于发药,出库是否过滤掉不可用批次用
/// 此处仅作过滤条件使用,以防之后添加其他条件
/// input:批次id
/// return:Y-过滤,其他不过滤
/// w ##class(web.DHCST.Common.DrugStkCommon).IfDhcInclbNotUse("858||2||1")
ClassMethod IfDhcInclbNotUse(inclb)
{
 s inclbnotuse="Y"
 q:+inclb=0 inclbnotuse
 q:'$d(^DHCINCLB(0,"LB",inclb)) inclbnotuse
 s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""),-1)
 s:dhcinclb'="" inclbnotuse=$p(^DHCINCLB(dhcinclb),"^",2)
 i inclbnotuse="Y" s inclbnotuse="N"
 e  s inclbnotuse="Y"
 q inclbnotuse
}

/// creator:yunhaibao
/// createdate:20160203
/// description:库存批次的在途数
/// Argu:
/// inclb -批次rowid
/// uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
ClassMethod InclbReservedQty(inclb As %String, uomdr As %String = "") As %String
{
 s inci="",ilsub="",lbsub=""
 s inci=$p(inclb,"||",1) q:inci="" 0
 s ilsub=$p(inclb,"||",2) q:ilsub="" 0
 s lbsub=$p(inclb,"||",3) q:lbsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) 0
 q:'$d(^DHCINCLB(0,"LB",inclb)) 0
 s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
 s inclbresqty=+$p(^DHCINCLB(dhcinclb),"^",3)
 s buomdr=$p(^INCI(+inclb,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
 s qty=+inclbresqty/fact
 q qty
}

/// Description:取某药品最后一次入库的效期
/// Input:库存项rowid,科室id
/// Output:最后入库效期(9999-12-31)
/// Creator:yunhaibao
/// CreateDate:2016-04-12
ClassMethod GetLastExpDate(IncId, LocId = "") As %Library.String
{
 s LastExpDate=""
 s Ingr=""
 f  s Ingr=$o(^DHCINGR(0,"INCI",IncId,Ingr),-1) q:(Ingr="")!(LastExpDate'="")  d
 .q:'$d(^DHCINGR(Ingr))
 .s IngrAudit=$P(^DHCINGR(Ingr),"^",29)
 .q:IngrAudit'="Y"
 .s IngrLoc=$P(^DHCINGR(Ingr),"^",13)
 .q:(LocId'="")&&(LocId'=IngrLoc)
 .s IngrItm=""
 .f  s IngrItm=$o(^DHCINGR(0,"INCI",IncId,Ingr,IngrItm),-1) q:(IngrItm="")!(LastExpDate'="")  d
 ..q:+IngrItm=0
 ..s LastExpDate=$p(^DHCINGR(Ingr,"GRI",IngrItm),"^",9)
 ..q:LastExpDate=""
 ..s LastExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(LastExpDate,"ST")
 q LastExpDate
}

/// Description:判断某药品是否有批次不可用但是有库存的药品
/// Creator:	hulihua
/// CreateDate:	2017-12-8
/// Table:		    
/// Input:		inci-库存项ID、loc-科室ID		
/// Output:		
/// Return：	0-否，1-是  
/// w ##class(web.DHCST.Common.DrugStkCommon).CheckStoNoZeroBt("2253","102")
ClassMethod CheckStoNoZeroBt(inci, loc) As %Library.String
{
	q:inci="" 0
	q:loc="" 0
	q:'$d(^INCI("IL_LOC",loc,inci)) 0
	s NoZeroFlag=0
	s inclb=""
	f  s inclb=$o(^DHCINCLBi("ACIBT","N",loc,inci,inclb)) q:(inclb="")!(NoZeroFlag'=0)  d 
	.q:+inclb=0
	.s inclbqty=..QtyINCLB(inclb,+$h)
	.s:inclbqty'=0 NoZeroFlag=1
	q NoZeroFlag
}

/// Decription	: 计算进价金额时使用大+小单位计算。避免误差
/// Creator		: yangsj
/// CreateDate	: 2021-08-02
/// Input		: inclb,qty,hosp,uom
/// Output		:
/// Table		:
/// Debugger	: w ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt("3194||7||4",2999985,2,2)
ClassMethod GetInclbRpAmt(inclb, qty, uom, hosp)
{
	s RpAmt = 0
	s inci = +inclb
	s buom = $P(^INCI(inci,1),"^",10)
	s puom = $P(^INCI(inci,3),"^",6)
	s fac1 = ##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	s fac2 = ##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s qty  = qty * fac1 
	s PQty = qty \ fac2
	i PQty > 0  d
	.s PRp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,puom,hosp,"G",+$h,"")
	.s RpAmt = PQty * PRp
	s BQty = qty - (PQty * fac2)
	i BQty > 0  d
	.s BRp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,buom,hosp,"G",+$h,"")
	.s RpAmt = RpAmt + (BQty * BRp)
	s RpAmt = ##class(web.DHCST.Common.AppCommon).FormatSpAmt(RpAmt,hosp)
	
	q RpAmt
}

/// Decription	: 计算售价金额时使用大+小单位计算。避免误差
/// Creator		: yangsj
/// CreateDate	: 2021-08-02
/// Input		: inclb,qty,hosp,uom
/// Output		:
/// Table		:
/// Debugger	: w ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt("3194||7||4",2999985,2,2)
ClassMethod GetInclbSpAmt(inclb, qty, uom, hosp)
{
	s SpAmt = 0
	s inci = +inclb
	s buom = $P(^INCI(inci,1),"^",10)
	s puom = $P(^INCI(inci,3),"^",6)
	s fac1 = ##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	s fac2 = ##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s qty  = qty * fac1 
	s PQty = qty \ fac2
	i PQty > 0  d
	.s PSp = ##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,puom,hosp,"G","")
	.s SpAmt = PQty * PSp
	s BQty = qty - (PQty * fac2)
	i BQty > 0  d
	.s BSp = ##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,buom,hosp,"G","")
	.s SpAmt = SpAmt + (BQty * BSp)
	s SpAmt = ##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,hosp)
	
	q SpAmt
}

}
