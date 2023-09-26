Import sqluser

/// Descript:药品库存管理信息相关的公共方法
/// Creater: ZhangDongmei
/// CreateDate: 2012-05-03
Class web.DHCSTMHUI.Common.DrugStkCommon Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:将基本单位库存转换成带单位的库存量（××盒××支）
/// Creater: ZhangDongmei
/// CreateDate: 2012-02-15
/// Table:
/// Input:库存项id,基本单位库存量
/// Output:
/// Return：库存量
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom()
ClassMethod QtyWithUom(inci, qty) As %Library.String
{
	n (inci, qty)
	q:inci="" 0
	q:+qty=0 0
	s tmpqty=0
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
	.s qty=$tr($fn(qty,","),",")		;避免.5形式
	.s PackQty=qty_PurUomDesc
	e  d
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUom,BUOM)
	.s remainder=qty#fac     ;取余
	.s remainder=$tr($fn(remainder,","),",")
	.i remainder=0  d
	..s PackQty=qty/fac_PurUomDesc
	.e  d
	..s IntQty=qty\fac
	..i IntQty>0  d
	...s PackQty=IntQty_PurUomDesc_remainder_BUomDesc
	..e  d
	...s PackQty=remainder_BUomDesc
	q:tmpqty<0 "-"_PackQty
	q PackQty
}

/// 库存批次的可用数
/// Date:2012-07-19
/// Argu：
///   incil - 科室库存rowid
///   uomdr - 单位rowid
/// Return:
///  库存批次的可用数，Type:1（只考虑占用）2（考虑在途和占用）其他(不考虑占用和在途)
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB()
ClassMethod CurItmAvaQtyB(incil As %String, uomdr As %String, Type As %String = "1", LockFlag As %String = "", CheckExpFlag As %String = "") As %String
{
	n (incil,uomdr,Type,LockFlag,CheckExpFlag)
	s inci=+incil q:inci="" 0
	s ilsub=$p(incil,"||",2) q:ilsub="" 0
	q:'$d(^INCI(inci,"IL",ilsub)) 0
	s loc=$p(^INCI(inci,"IL",ilsub),"^",1)
	s buom=$p(^INCI(inci,1),"^",10) q:buom="" 0
	s:uomdr="" uomdr=buom 
	
	s lbsub="0",aqty=0
	f  s lbsub=$o(^INCI(inci,"IL",ilsub,"LB",lbsub)) q:(lbsub="")!(lbsub="0")  d
	.s inclb=inci_"||"_ilsub_"||"_lbsub
	.s Incib=$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",1)
	.s IB=$p(Incib,"||",2)
	.s ReCallFlag=$p(^INCI(inci,"IB",IB),"^",3)
	.q:(LockFlag="Y")&&(ReCallFlag'="Y")		//批次锁定
	.q:(LockFlag="N")&&(ReCallFlag="Y")
	.s ExpDate=$p(^INCI(inci,"IB",IB),"^",2)
	.i +ExpDate=0 s ExpDate=$zdh("9999-12-31",3)
	.q:(CheckExpFlag="Y")&&(ExpDate<=+$h)
	.s aqty=aqty+..CurInclbAvaQty(inclb,"",Type)
	
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,buom)
	s aqty=aqty/fac
	q aqty
}

/// Descript: 根据库存项的ID、药房及开始时间取基本单位数量
/// Creater: Zhouyg
/// CreateDate: 20100302
/// Input: 	inci,loc,dd
/// Output: 	Return
/// Return： 基本单位数量
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).IL()
ClassMethod IL(inci, loc, dd, TimeH = "")
{
	n (inci,loc,dd,TimeH)
	q:inci="" 0
	q:loc="" 0
	q:dd="" 0
	
	s DateIntr=""		;当天TimeH前面的一条台帐
	i (TimeH'="")&&(TimeH'="86399") d
	.s Intr=""
	.f  s Intr=$o(^DHCINTR(0,"INCI",inci,dd,Intr),-1) q:(Intr="")||(DateIntr'="")  d
	..s IntrTime=$p(^DHCINTR(Intr),"^",3)
	..q:IntrTime>=TimeH
	..s Inclb=$p(^DHCINTR(Intr),"^",7)
	..s sub=$p(Inclb,"||",2)
	..s IntrLoc=$p(^INCI(inci,"IL",sub),"^",1)
	..q:IntrLoc'=loc
	..s DateIntr=Intr
	.
	.;当前TimeH前没有台帐的, 取前一天的结存
	.i DateIntr="" s dd=dd-1
	
	;若当前TimeH之前有台帐, 取次台帐结存,否则按日期取结存
	i DateIntr'="" s qty=$p(^DHCINTR(DateIntr),"^",18) q qty
	
	s nextdate=dd+1
	s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
	i rr="" q 0
	s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
	i rr="" q 0
	s qty=+$p(^DHCLOCTOT(rr),"^",4)
	q qty
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom()
ClassMethod LocDayQtyUom(inci, loc, UOM, dd, TimeH = "") As %Library.String
{
	n (inci,loc,UOM,dd,TimeH)
	q:inci="" 0
	q:loc="" 0
	q:UOM="" 0
	
	s BUOM=$p(^INCI(inci,1),"^",10) 
	q:BUOM="" 0
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UOM,BUOM)
	s dd=+dd
	s:dd=0 dd=+$h
	s qty=..IL(inci,loc,dd,TimeH)
	s qty=qty/fac
	q qty
}

/// 获取某科室某物资的可用数量
/// Author:zhangxiao
/// Date:2015-02-13
/// Argu:
///       Loc - 科室rowid
///       INCI - 库存项id
///        UOM - 单位id
/// Return:
///   
///    <0 - failure
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(163,3,67)
ClassMethod GetAvaQty(Loc As %String, INCI As %String, UOM As %String) As %String
{
	n (Loc,INCI,UOM)
	s allavaQty=0
	q:Loc="" 0
	q:INCI="" 0
	
	s chl=""
	f  s chl=$o(^INCI("IL_LOC",Loc,INCI,chl)) q:chl=""  d
	.s logQty=$p(^INCI(INCI,"IL",chl),"^",3)
	.s ResQty=$p(^INCI(INCI,"IL",chl),"^",10)
	.s avaQty=logQty-ResQty
	.s dirtyQty=$p(^INCI(INCI,"IL",chl),"^",9)
	.s:dirtyQty<0 dirtyQty=0
	.s avaQty=avaQty-dirtyQty  ;可用库存减去占用数
	.s allavaQty=allavaQty+avaQty
	.s ch2="",RecallFlag="N"
	.f  s ch2=$o(^INCI(INCI,"IL",chl,"LB",ch2)) q:ch2=""  d
	..s Incib=$p(^INCI(INCI,"IL",chl,"LB",ch2),"^",1)
	..s IncibPhyQty=$p(^INCI(INCI,"IL",chl,"LB",ch2),"^",2)
	..s IncibDirtyQty=$p(^INCI(INCI,"IL",chl,"LB",ch2),"^",3)
	..s IncibavaQty=IncibPhyQty-IncibDirtyQty
	..s Incibsub=$p(Incib,"||",2)
	..s:Incibsub'="" RecallFlag=$p($g(^INCI(INCI,"IB",Incibsub)),"^",3)
	..s:RecallFlag="Y" allavaQty=allavaQty-IncibavaQty
	
	s BUomId=$p(^INCI(INCI,1),"^",10)
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UOM,BUomId)
	s allavaQty=allavaQty/ConFac
	q allavaQty
}

/// 某科室库存项的占用数
/// Date:2012-07-19
/// Argu:
///  incil -科室库存rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   批次的占用数
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty()
ClassMethod CurIncResQty(incil As %String, uomdr As %String) As %String
{
	n (incil,uomdr)
	s inci=$p(incil,"||",1) q:inci="" 0
	s ilsub=$p(incil,"||",2) q:ilsub="" 0
	q:'$d(^INCI(inci,"IL",ilsub)) ""
	s dqty=+$p(^INCI(inci,"IL",ilsub),"^",9)
	s buomdr=$p(^INCI(inci,1),"^",10)
	i uomdr="" s uomdr=buomdr
	s fact=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,buomdr)
	s qty=+dqty/fact
	q qty
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom()
ClassMethod QtyINCLBUom(inclb, UOM, dd) As %Library.String
{
	n (inclb, UOM, dd)
	q:inclb="" 0
	
	s inci=+inclb
	s BUOM=$p(^INCI(inci,1),"^",10) 
	q:BUOM="" 0
	s:UOM="" UOM=BUOM
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UOM,BUOM)
	s dd=+dd
	s:dd=0 dd=+$h
	s qty=..QtyINCLB(inclb,dd)
	s qty=qty/fac
	q qty
}

/// 库存批次的占用数
/// Date:2012-07-19
/// Argu:
///  inclb -批次rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   批次的占用数
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty()
ClassMethod CurInclbResQty(inclb As %String, uomdr As %String) As %String
{
	n (inclb,uomdr)
	s inci="",ilsub="",lbsub="",dqty=0,qty=0
	s inci=$p(inclb,"||",1) q:inci="" 0
	s ilsub=$p(inclb,"||",2) q:ilsub="" 0
	s lbsub=$p(inclb,"||",3) q:lbsub="" 0
	q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) ""
	s dqty=+$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)
	s buomdr=$p(^INCI(+inclb,1),"^",10)
	i uomdr="" s uomdr=buomdr
	s fact=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,buomdr)
	s qty=+dqty/fact
	q qty
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).
/// 库存批次的在途数(dhc_incitmlcbt--INCLB_ReservedQty)
/// Date:	2017-01-10
/// Argu:
///  inclb -批次rowid
///  uomdr - 单位rowid (若为空，则自动使用基本单位)
/// Return:
///   批次的占用数
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbReservedQty()
ClassMethod CurInclbReservedQty(inclb As %String, uomdr As %String) As %String
{
	n (inclb,uomdr)
	s inci="",ilsub="",lbsub="",dqty=0,qty=0
	s inci=$p(inclb,"||",1) q:inci="" 0
	s ilsub=$p(inclb,"||",2) q:ilsub="" 0
	s lbsub=$p(inclb,"||",3) q:lbsub="" 0
	q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) ""
	s dhcInclb=$o(^DHCINCLB(0,"LB",inclb,0))
	q:dhcInclb="" 0
	s resqty=$p($g(^DHCINCLB(dhcInclb)),"^",3)
	s buomdr=$p(^INCI(+inclb,1),"^",10)
	i uomdr="" s uomdr=buomdr
	s fact=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,buomdr)
	s qty=+resqty/fact
	q qty
}

/// 当前批次的可用数量
/// Date:2012-07-19
/// Argu:
///  inclb - 批次rowid
///  uomdr - 单位rowid
/// Return: 
///  数量,Type:1（只考虑占用）2（考虑在途和占用）其他(不考虑占用和在途)
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty()
ClassMethod CurInclbAvaQty(inclb As %String, uomdr As %String, Type = "2") As %String
{
	n (inclb,uomdr,Type)
	s buomdr=$p(^INCI(+inclb,1),"^",10) q:buomdr="" 0
	s:uomdr="" uomdr=buomdr
	s eqty=..QtyINCLBU(inclb,+$h,uomdr)
	s dirtyqty=..CurInclbResQty(inclb,uomdr)
	s reservedqty=..CurInclbReservedQty(inclb,uomdr)	;批次在途(批次售价使用)
	s aqty=0
	i Type=1 d
	.s aqty=eqty-dirtyqty
	e  i Type=2 d
	.s aqty=eqty-dirtyqty-reservedqty
	e  d
	.s aqty=eqty
	q aqty
}

/// 取某批次某日期的库存
/// Date:20120-07-19
/// Argu:
/// INCLB - 库存批次rowid
/// DA - 日期 (可以是:内部格式，格式3，格式4)
/// Return：
/// 库存数量(基本单位)
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB()
ClassMethod QtyINCLB(INCLB As %String, DA As %String, TimeH = "") As %String
{
	n (INCLB,DA,TimeH)
	q:INCLB="" ""
	s:DA="" DA=+$h
	
	s DateIntr=""		;当天TimeH前面的一条台帐
	i (TimeH'="")&&(TimeH'="86399") d
	.s Intr=""
	.f  s Intr=$o(^DHCINTR(0,"INCLB",INCLB,DA,Intr),-1) q:(Intr="")||(DateIntr'="")  d
	..s IntrTime=$p(^DHCINTR(Intr),"^",3)
	..q:IntrTime>=TimeH
	..s DateIntr=Intr
	.
	.;当前TimeH前没有台帐的, 取前一天的结存
	.i DateIntr="" s DA=DA-1
	
	;若当前TimeH之前有台帐, 取次台帐结存,否则按日期取结存
	i DateIntr'="" s qty=$p(^DHCINTR(DateIntr),"^",19) q qty
	
	s DA=DA+1
	s DD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DA),-1) q:DD="" 0
	s LCBTD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,""),-1) q:LCBTD="" 0
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
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU()
ClassMethod QtyINCLBU(INCLB As %String, dah As %String, uomdr As %String = "", TimeH = "") As %String
{
	n (INCLB,dah,uomdr,TimeH)
	q:INCLB="" 0
	q:dah="" 0
	s INCI=+INCLB q:INCI="0" 0 
	s BUOM=$p(^INCI(INCI,1),"^",10) q:BUOM="" 0
	i uomdr="" s uomdr=BUOM
	s qty=..QtyINCLB(INCLB,dah,TimeH)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,BUOM)
	s qty=+qty/fac
	q qty
}

/// Description:获取某物资对应业务的结存数
/// 			有台帐的,取台帐结存,否则按+$h取库存数量
/// Creator:	wangjiabin
/// CreateDate:	2017-11-22
/// Input:		台帐类型
/// Output:		Qty
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("K","164||1")
ClassMethod GetIntrStkQty(Type, Pointer) As %String
{
	n (Type,Pointer)
	q:(Type="")||(Pointer="") 0
	s IntrStkQtyB=""
	s Intr=$o(^DHCINTR(0,"TypePointer",Type,Pointer,0))
	i Intr'="" d
	.s IntrStkQtyB=$p(^DHCINTR(Intr),"^",18)
	e  d
	.s PointerInfo=$$GetPointerInfo(Type,Pointer)
	.s Inci=$p(PointerInfo,"^",1)
	.s LocId=$p(PointerInfo,"^",2)
	.q:(Inci="")||(LocId="")
	.s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,LocId,+$h)

	q IntrStkQtyB

/// 获取 库存项id^科室id
GetPointerInfo(Type,Pointer)
	n (Type,Pointer)
	s MainId=$p(Pointer,"||",1),Ch=$p(Pointer,"||",2)
	s (Inci,LocId)=""
	i Type="G" d
	.s LodId=$p(^DHCINGR(MainId,"GRI",Ch),"^",3)
	.s Inci=$p(^DHCINGR(MainId,"GRI",Ch),"^",25)
	e  i Type="R" d
	.s Inclb=$p(^INGRT(MainId,"DHCGRR",Ch),"^",6)
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	e  i Type="T" d
	.s Inclb=$p(^DHCINIT(MainId,"ITI",Ch),"^",3)
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	e  i Type="K" d
	.s FrInclb=$p(^DHCINIT(MainId,"ITI",Ch),"^",3)
	.s Inci=$p(FrInclb,"||",1)
	.s LocId=$p(^DHCINIT(MainId),"^",6)
	e  i Type="A" d
	.s Inclb=$p(^DHCINAD(MainId,"ADI",Ch),"^",1)
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	e  i Type="D" d
	.s Inclb=$p(^DHCINSP(MainId,"I",Ch),"^",1)
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	
	q Inci_"^"_LocId
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin()
ClassMethod GetStkBin(dept, inci) As %Library.String
{
	n (dept,inci)
	q:dept="" ""
	q:inci="" ""
	s incilch=$o(^INCI("IL_LOC",dept,inci,""))
	q:incilch="" ""
	s incsb=$p(^INCI(inci,"IL",incilch),"^",2)
	q:incsb="" ""
	s csbdes=$p(^INC("SB",incsb),"^",2)
	q csbdes_"^"_incsb
}

/// 取货位名称
/// Author:zhwh
/// Date:2012-08-10
/// Argu:
///  incil - 科室库存项目的rowid
/// Return:
/// 货位名称
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil()
ClassMethod GetStkBinByIncil(incil) As %Library.String
{
	n (incil)
	s (csbdes,incsb)=""
	s inci=+incil
	s chl=$p(incil,"||",2)
	s incsb=$p(^INCI(inci,"IL",chl),"^",2)
	s:incsb'="" csbdes=$p(^INC("SB",incsb),"^",2)
	q csbdes_"^"_incsb
}

/// Description:取某药品最后一次入库的供应商
/// Input:库存项rowid
/// Output:供应商id^供应商名称
/// Creator:zdm
/// CreateDate:2012-06-19
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen()
ClassMethod GetLastVen(IncId As %String, Loc As %String = "") As %Library.String
{
	n (IncId,Loc)
	s VenDes="",Apcvm=""
	s Ingr=""
	f  s Ingr=$o(^DHCINGR(0,"INCI",IncId,Ingr),-1) q:(Ingr="")!(VenDes'="")  d
	.q:'$d(^DHCINGR(Ingr))
	.s IngrDate=$P(^DHCINGR(Ingr),"^",4)
	.q:IngrDate=""
	.s Apcvm=$p(^DHCINGR(Ingr),"^",3)
	.q:Apcvm=""
	.q:'$d(^APC("APCVM",Apcvm))
	 .s locId=$p(^DHCINGR(Ingr),"^",13)
	 .q:(Loc'="")&&(locId'=Loc)
	.s VenDes=$p(^APC("APCVM",Apcvm),"^",3)
	.s VenCod=$p(^APC("APCVM",Apcvm),"^",2)
	q Apcvm_"^"_VenDes
}

/// 管理组
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  inci - 库存项目rowid
///  locdr - 科室rowid
/// Return:
///  科室库存项管理组rowid
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil("2054||1")
ClassMethod ManGrpByIncil(incil) As %String
{
	n (incil)
	q:incil="" ""
	s grp=""
	s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	q:dhcincil="" ""
	s grp=$p(^DHCINCIL(dhcincil),"^",7)
	
	q grp
}

/// 获取供应科室
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(4453,163)
ClassMethod GetprovLoc(inci, loc)
{
	n (inci,loc)
	q:inci="" ""
	s (ProvLocId,ProvLocDesc)=""
	
	i loc'="" d
	.s incilchl=$o(^INCI("IL_LOC",loc,inci,""))
	.i incilchl'="" s ProvLocId=$p(^INCI(inci,"IL",incilchl),"^",8)
	.i ProvLocId="" d
	..s inccat=$p(^INCI(inci,2),"^",2)
	..s ReqPrvId=$o(^DHCItmRepLoc(0,"LOCSC",loc,inccat,""))
	..s:ReqPrvId'="" ProvLocId=$p(^DHCItmRepLoc(ReqPrvId),"^",3)
	
	s:ProvLocId="" ProvLocId=$p(^INCI(inci,2),"^",1)
	s:ProvLocId'="" ProvLocDesc=$p(^CTLOC(ProvLocId),"^",2)
	
	q ProvLocId_"^"_ProvLocDesc
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetItmLocMNRQtyUO()
ClassMethod GetItmLocMNRQtyUO(InciId, LocId, UomId) As %Library.String
{
	n (InciId,LocId,UomId)
	q:InciId="" ""
	q:LocId="" ""
	q:UomId="" ""
	s Chl=$o(^INCI("IL_LOC",LocId,InciId,0))
	q:Chl="" ""
	s MinQty=$p(^INCI(InciId,"IL",Chl),"^",4)
	s MaxQty=$p(^INCI(InciId,"IL",Chl),"^",7)
	s RepQty=$p(^INCI(InciId,"IL",Chl),"^",6)
	s BUomId=$p(^INCI(InciId,1),"^",10)
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	s MinQty=$fn(MinQty/ConFac,"",2)
	s MaxQty=$fn(MaxQty/ConFac,"",2)
	s RepQty=$fn(RepQty/ConFac,"",2)
	q MinQty_"^"_MaxQty_"^"_RepQty
}

/// Descript:	根据inc_itmlcbt表RowID取inc_itmbat表rowid
/// Creater:	Zhouyg
/// CreateDate:	20110630
/// Input:		Inclb-inc_itmlcbt表RowID
/// Output:		Return
/// Return：	inc_itmbat表rowid
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIncib()
ClassMethod GetIncib(Inclb As %String) As %String
{
	n (Inclb)
	q:Inclb="" ""
	s InciID=$p(Inclb,"||",1)
	s ILSub=$p(Inclb,"||",2)
	s LBSub=$p(Inclb,"||",3)
	q:(InciID="")||(ILSub="")||(LBSub="") ""
	s Incib=$p($g(^INCI(InciID,"IL",ILSub,"LB",LBSub)),"^",1)
	q Incib
}

/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat()
ClassMethod Bat(inclbid) As %Library.String
{
	n (inclbid)
	s incibid=""
	i ($p(inclbid,"||",1)'="")&($p(inclbid,"||",2)'="")&($p(inclbid,"||",3)'="") d 
	.q:'$d(^INCI($p(inclbid,"||",1),"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)))
	.s incibid=$p(^INCI($p(inclbid,"||",1),"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	s batno="",expdate=""
	i incibid'=""  d
	.s batno=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",1)
	.s expdate=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",2)
	.i expdate'="" s expdate=..DL2H(expdate)
	q batno_"^"_expdate
}

/// Description:根据批次取某药品的生产厂家
/// Input:inc_itmlcbt表rowid
/// Output:生产厂家id^生产厂家名称
/// Creator:zdm
/// CreateDate:2012-02-01
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb()
ClassMethod GetManfInfoByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s manfid=$p($g(^DHCINCIB(dhcincib)),"^",7)
	;批次表里没存的话取入库子表
	i manfid=""  d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr),-1)  q:(dhcingr="")!(manfid'="")  d
	..s chl=""
	..f  s chl=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr,chl),-1)  q:(chl="")!(manfid'="")  d
	...s manfid=$p(^DHCINGR(dhcingr,"GRI",chl),"^",29)
	..
	.
	s manf=""
	s:manfid'="" manf=$p($g(^PHMNF(manfid)),"^",2)
	q manfid_"^"_manf
}

/// Description:根据批次取某药品的供应商
/// Input:inc_itmlcbt表rowid
/// Output:供应商id^供应商名称
/// Creator:zx
/// CreateDate:2014-07-25
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb("2022||1||18")
ClassMethod GetvendorInfoByInclb(inclb, dah = "") As %Library.String
{
	n (inclb,dah)
	q:inclb="" ""
	
	s:dah="" dah=+$h
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s venid=$p(^DHCINCIB(dhcincib),"^",8)
	;批次表里没存的话取入库子表
	i venid=""  d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr),-1) q:(dhcingr="")!(venid'="")  d
	..s grdate=$p(^DHCINGR(dhcingr),"^",4)
	..s:grdate'>dah venid=$p(^DHCINGR(dhcingr),"^",3)
	
	s vendorname=""
	s:venid'="" vendorname=$p(^APC("APCVM",venid),"^",3)
	q venid_"^"_vendorname
}

/// Description:根据批次取资金来源
/// Input:inc_itmlcbt表rowid
/// Output:
/// Creator:
/// CreateDate:
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb()
ClassMethod GetSourceOfFundInfoByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s SourceOfFund=$p(^DHCINCIB(dhcincib),"^",12)
	s SourceOfFundDesc=""
	s:SourceOfFund'="" SourceOfFundDesc=$p(^DHCSOUROFFUND(SourceOfFund),"^",2)
	q SourceOfFund_"^"_SourceOfFundDesc
}

/// Description:根据批次具体规格
/// Input:inc_itmlcbt表rowid
/// Output:
/// Creator:
/// CreateDate:
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb()
ClassMethod GetSpecDescByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s SpecDesc=$p(^DHCINCIB(dhcincib),"^",13)
	q SpecDesc
}

/// Description:根据科室库存批次取灭菌批号
/// Input:inc_itmlcbt表rowid
/// Output:灭菌批号
/// Creator:lihui
/// CreateDate:20161208
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb()
ClassMethod GetSterilizedBatByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s SterilizedBat=$p(^DHCINCIB(dhcincib),"^",19)
	q SterilizedBat
}

/// Description:根据科室库存批次取赠送标志
/// Input:inc_itmlcbt表rowid
/// Output:赠送标志: Y 赠送;N非赠送;
/// Creator:lihui
/// CreateDate:20170925
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetGiftFlagByInclb()
ClassMethod GetGiftFlagByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s GiftFlag=$p(^DHCINCIB(dhcincib),"^",15)
	s:GiftFlag="" GiftFlag="N"
	q GiftFlag
}

/// Description:根据批次取税额
/// Input:inc_itmlcbt表rowid
/// Output:
/// Creator:
/// CreateDate:
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetTaxByInclb("2005||1||19")
ClassMethod GetTaxByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s Tax=$p(^DHCINCIB(dhcincib),"^",21)
	s:Tax="" Tax=0
	q Tax
}

/// Descript:	根据库存项ID和医院取本院最后一个批次
/// Input:		InciDr-inci_rowid,HospID,日期
/// Return：	批次ID(INC_ItmBat的ID)
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastIncib(22)
ClassMethod GetLastIncib(InciDr As %String, HospID As %String = "", dah As %String = "") As %String
{
	N (InciDr,HospID,dah)
	Q:InciDr="" ""
	
	s RetIncib="",BakIncib=""
	i HospID="" d
	.s ibSub=""
	.f  s ibSub=$o(^INCI(InciDr,"IB",ibSub),-1) q:(+ibSub=0)!(RetIncib'="")  d
	..s INCIB=InciDr_"||"_ibSub
	..s BakIncib=INCIB
	..s IBAddDate=0
	..s dhcIB=$o(^DHCINCIB(0,"INCIB",INCIB,""))
	..i dhcIB'="" s IBAddDate=$p(^DHCINCIB(dhcIB),"^",10)
	..q:(dah'="")&(IBAddDate>dah)
	..s RetIncib=INCIB
	e  d
	.s ibSub=""
	.f  s ibSub=$o(^INCI(InciDr,"IB",ibSub),-1) q:(+ibSub=0)!(RetIncib'="")  d
	..s INCIB=InciDr_"||"_ibSub
	..s BakIncib=INCIB
	..s IBAddDate=0
	..s dhcIB=$o(^DHCINCIB(0,"INCIB",INCIB,""))
	..i dhcIB'="" s IBAddDate=$p(^DHCINCIB(dhcIB),"^",10)
	..q:(dah'="")&(IBAddDate>dah)
	..s ilSub=""
	..f  s ilSub=$o(^INCI("LB_IB",INCIB,InciDr,ilSub)) q:(ilSub="")!(RetIncib'="")  d
	...s locID=$p($g(^INCI(InciDr,"IL",ilSub)),"^",1)
	...q:locID=""
	...s ilHosp=$p(^CTLOC(locID),"^",22)
	...q:(HospID'=ilHosp)
	...s RetIncib=INCIB
	i RetIncib="" s RetIncib=BakIncib
	q RetIncib
}

/// 获取第三方BatDetailId
ClassMethod GetDetailIdByInclb(Inclb) As %Library.String
{
	n (Inclb)
	q:Inclb="" ""
	s Inci=+Inclb,IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	q:Incib="" ""
	s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	q:DHCIncib="" ""
	s DetailId=$p(^DHCINCIB(DHCIncib),"^",20)
	q DetailId
}

/// Description:根据科室库存批次取生产日期
/// Input: INC_ItmLcBt 表rowid
/// Output: 生产日期
/// Creator: lihui
/// CreateDate: 20211215
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetProduceDateByInclb()
ClassMethod GetProduceDateByInclb(inclb) As %Library.String
{
	n (inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s ProduceDate=$p(^DHCINCIB(dhcincib),"^",2)
	s:ProduceDate'="" ProduceDate=..DL2H(ProduceDate)
	q ProduceDate
}

/// Description:根据批次取注册证号
/// Input:INC_ItmBat表rowid
/// Output:注册证号
/// Creator:wxj
/// CreateDate:2023-04-10
/// w ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetCertNoByInclb("2||1")
ClassMethod GetCertNoByInclb(Inclb) As %Library.String
{
	n (Inclb)
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s certNo=$p($g(^DHCINCIB(dhcincib)),"^",34)
	q certNo
}

}
