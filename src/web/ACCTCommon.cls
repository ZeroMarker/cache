Import SQLUser

/// Class Name:web.CSSDCommon
/// Description:common method for acct
/// Creator:zdm
/// CreatDate:2010-06-30
Class web.ACCTCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据科室名称取rowid
/// Table:CT_Loc
/// Input:科室名称
/// Output:
/// Return:rowid
/// Others：
ClassMethod LocDescToRowid(locDesc As %String) As %String
{
	n (locDesc)
	q:locDesc="" ""
	s locDesc=$$ALPHAUP^SSUTIL4(locDesc)
	s rowid=$o(^CTLOC(0,"Desc",locDesc,""))
	q rowid
}

/// Creator:zdm
/// CreatDate:2010-06-30
/// Description:取凭证交换系统中业务类型对应的检索条件
/// Table:acct_sysbusitype
/// Input:业务类型^....
/// Output:
/// Return:业务类型^....
/// Others：
ClassMethod GetWhileSqlForBusiType(typeId As %String) As %String
{
	n (typeId)
	q:typeId="" ""
	s objBusiType=##class(User.ACCTSysBusiType).%OpenId(typeId)
	q:objBusiType="" ""
	s whileSql=objBusiType.WhileSql
	q whileSql
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据库存项rowid取规格
/// Table:DHC_ItmAddionInfo
/// Input:库存项rowid
/// Output:
/// Return:rowid
/// Others：
ClassMethod GetSpec(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""
	s info=$o(^DHCITMINFO(0,"INCI",itmRowid,""))
	q:info="" ""
	s spec=$p(^DHCITMINFO(info),"^",27)
	i spec=""  d
	.s spec=$p(^INCI(itmRowid,3),"^",9)
	.
	q spec
}

/// Creator:zdm
/// CreatDate:2010-07-2
/// Description:根据库存项rowid取库存分类
/// Table:
/// Input:库存项rowid
/// Output:
/// Return:库存分类rowid
/// Others：
ClassMethod GetIncStkCat(itmRowid As %String) As %String
{
	n (itmRowid)
	q:itmRowid="" ""
	s stkcat=$p(^INCI(itmRowid,2),"^",2)
	;
	q stkcat
}

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:根据业务类型取模块号
/// Table:ACCT_SysBusiType,ACCT_SysMode
/// Input:业务类型id
/// Output:
/// Return:模块号
/// Others：
ClassMethod GetModCodeByBusiType(busiTypeId As %String) As %String
{
	n (busiTypeId)
	q:busiTypeId="" ""
	s objBusiType=##class(User.ACCTSysBusiType).%OpenId(busiTypeId)
	;
	q:objBusiType="" ""
	s objMod=objBusiType.AcctSysModeDr
	;
	;q:modId="" ""
	;s objMod=##class(User.ACCTSysMode).%OpenId(modId)
	;b
	q:objMod="" ""
	s modCode=objMod.ModCode
	i objBusiType'=""  d objBusiType.%Close()
	i objMod'=""  d objMod.%Close()
	;
	q modCode
}

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:加锁
/// Table
/// Input:锁类型，加锁对象
/// Output:
/// Return:0，成功；-10，已经加锁；-11，失败
/// Others：
ClassMethod AddLock(lockType As %String, lockObject As %String) As %String
{
	n (lockType,lockObject)
	q:lockType="" 0
	q:lockObject="" 0
	s err=0
	i $d(^ACCTLOCK(lockType,lockObject))  d
 	.s err="-10"							;某用户正在处理该对象			
 	q:err'=0
 	l +^ACCTLOCK(lockType,lockObject):10  e  d
 	.s err="-11"							;加锁失败
 	q err
}

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:对某对象解锁
/// Table
/// Input:锁类型，锁对象
/// Output:
/// Return:
/// Others：
ClassMethod RemoveLock(lockType As %String, lockObject As %String) As %String
{
	n (lockType,lockObject)
	q:lockType="" 0
	q:lockObject="" 0
	
 	l -^ACCTLOCK(lockType,lockObject)			
 	q 0
}

/// Creator:zdm
/// CreatDate:2010-07-02
/// Description:取某科目对应的库房和库存分类
/// Table:ACCT_SubjMap
/// Input:模块号，科目id
/// Output:
/// Return:库房1^库房2,库存分类1^库存分类2
/// Others：
ClassMethod GetSubjMap(modCode As %String, subjId As %String) As %String
{
	n (modCode,subjId)
	q:subjId="" ""
	q:modCode="" ""
	s strLoc=""
	s strCat=""
	s modId=$o(^User.ACCTSysModeI("PKModeCode",$c(32)_modCode,""))
	s mapId=""
	f  s mapId=$o(^User.ACCTSubjMapI("IndexModSubj",modId,subjId,mapId)) q:mapId=""  d
	.s objSubjMap=##class(User.ACCTSubjMap).%OpenId(mapId)
	.q:objSubjMap=""
	.s locId=objSubjMap.LocDr.%Id()
	.s catId=objSubjMap.TypeCode
	.i (strLoc'="")&'$f(strLoc,locId)  d
	..s strLoc=strLoc_"^"_locId
	.e  d
	..s strLoc=locId
	.i (strCat'="")& '$f(strCat,catId) d
	..s strCat=strCat_"^"_catId
	.e  d
	..s strCat=catId
	.d objSubjMap.%Close()
	q strLoc_","_strCat
}

/// Creator:zdm
/// CreatDate:2010-07-02
/// Description:取批次进价
/// Table:
/// Input:inclb
/// Output:
/// Return:进价
/// Others：
ClassMethod GetRp(inclb As %String, uom As %String) As %Numeric
{
	n (inclb,uom)
	q:inclb="" 0
	q:$$ChkRIngr(+inclb)=1 $$GetManPrice(inclb,uom)	;制剂取进价
 	s LASTINGRI=$$LastINGRI(inclb) q:LASTINGRI="" ""
 	s DHCINGR=$P(LASTINGRI,"||",1)
 	s DHCINGRCH=$P(LASTINGRI,"||",2)
 	s RP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)    ; Real Price (in)
 	s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
 	s BUOM=$p(^INCI(+inclb,1),"^",10)
 	i $g(uom)="" s uom=BUOM
 	q:uom=RECUOM RP      
 	s fac1=..UOMFac(uom,BUOM)
 	s fac2=..UOMFac(RECUOM,BUOM)
 	s RP=RP/fac2*fac1
 	q RP
 
ChkRIngr(inci) ;check inci if Drug-Manu
 q:inci="" 0
 s recsub=""
 s recsub=$o(^INCI(inci,"REC","0"))
 q:(recsub=0)!(recsub="") 0
 q 1
 
GetManPrice(inclb,uomdr="")
 n (inclb,uomdr)
 q:inclb="" ""
 s il=$p(inclb,"||",2)
 s lb=$p(inclb,"||",3)
 s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
 q:incib="" ""
 s manid=""
 s manid=$o(^DHCINMAN(0,"INCIB",incib,""),-1)
 q:manid="" ""
 q:'$d(^DHCINMAN(manid)) ""
 s rp=+$p(^DHCINMAN(manid),"^",11)
 S muomdr=$p(^DHCINMAN(manid),"^",8)
 S buomdr=$P(^INCI(+inclb,1),"^",10)
 I uomdr="" S uomdr=buomdr
 Q:muomdr=uomdr rp
 s fac1=..UOMFac(uomdr,buomdr)
 s fac2=..UOMFac(muomdr,buomdr)
 s rp=rp/fac2*fac1
 q rp
 
LastINGRI(inclb)
 n (inclb)
 s il=$p(inclb,"||",2)
 s lb=$p(inclb,"||",3)
 s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
 q:incib="" ""
 s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
 i INGR d
 .s INGRCH=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""))
 .s INGRI=INGR_"||"_INGRCH
 q $g(INGRI)
}

/// Creator:zdm
/// CreatDate:2010-07-02
/// Description:计算单位转换因子
/// Table:
/// Input:
/// Output:
/// Return:单位转换因子
/// Others：
ClassMethod UOMFac(fr As %String, to As %String) As %String
{
	q:fr=to 1    //if from-uom is as same as to-uom then return 1
	s rowid=$o(^CT("CTCF",0,"UOM",fr,to,"")) 
	i rowid'="" d       
	.s fac=$p(^CT("CTCF",rowid),"^",3)
	.s fac=$p(fac,$c(1))
	e  d
	.s fac=1
	q $g(fac)
}

/// Creator:zdm
/// CreatDate:2010-07-05
/// Description:判断某类型的记录是否是凭证系统中指定的业务类型
/// 如：类型为"G"的记录是否是"采购入库"
/// Table:acct_sysbusitype
/// Input:台帐记录ID,凭证交换系统中业务类型对应的设置条件
/// Output:
/// Return:1,true;0,false
/// Others：
ClassMethod CheckIfSpecBusiType(trid As %String, whileSql As %String) As %String
{
	n (trid,whileSql)
	q:trid="" 0
	q:whileSql="" 0
	s tmpType=$p(whileSql,",",1)								;业务类型
	s pointer=$p(^DHCINTR(trid),"^",9)
	s type=$p(^DHCINTR(trid),"^",1)
	s ret=1
	i type="G"  d
	.s tmpIngrType=$p(whileSql,",",2)				;入库类型
	.s chageReceipt=$p(whileSql,",",3)				;调价换票标志
	.s present=$p(whileSql,",",4)					;捐赠标志
	.s dhcingr=+pointer
	.s ingrType=$p(^DHCINGR(dhcingr),"^",23)
	.s:ingrType'="" ingrType=$p(^DHCOPTYPE(ingrType),"^",2)
	.s receiptFlag=$p(^DHCINGR(dhcingr),"^",18)		
	.s presentFlag=$p(^DHCINGR(dhcingr),"^",19)
	.
	.i chageReceipt="Y"  d                              		;调价换票入库业务
	..s:(receiptFlag'="1")&('$f(tmpIngrType,ingrType)) ret=0
	.e  i present="Y"  d                                        ;捐赠入库业务
	..s:(presentFlag'="1")&('$f(tmpIngrType,ingrType)) ret=0
	.e  d                                                       ;其它入库业务通过入库类型标识，如果没有定义入库类型，认为只有一种入库业务
	..s:receiptFlag'="0" ret=0									;非调价换票业务过滤掉调价换票记录
	..s:presentFlag'="0" ret=0									;非捐赠入库业务过滤掉捐赠入库记录
	..i tmpIngrType'="" d
	...s:'$f(tmpIngrType,ingrType) ret=0			;	
	i (type="T")!(type="K")  d
	.s tmpTrType=$p(whileSql,",",2)								;转出类型
	.s initType=$p(^DHCINIT(+pointer),"^",20)					;出库类型
	.s:initType'="" initType=$p(^DHCOPTYPE(initType),"^",2)
	.i tmpTrType'=""  d
	..s:'$f(tmpTrType,initType) ret=0				;如果没有定义出库类型，认为只有一种出库业务
	i type="A"  d                                               ;库存调整
	.s reason=$p(whileSql,",",2)									;调整原因
	.s adjReasonDr=$p(^DHCINAD(+pointer),"^",6)					;
	.s:adjReasonDr'="" adjReason=$p(^INC("ADJ",adjReasonDr),"^",2)
	.i reason'=""  d
	..s:'$f(reason,adjReason) ret=0
	.
	q ret
}

/// Creator:zdm
/// CreatDate:2010-07-01
/// Description:根据业务类型取模块号
/// Table:ACCT_SysBusiType,ACCT_SysMode
/// Input:业务类型id
/// Output:
/// Return:模块号
/// Others：
ClassMethod GetDateByYearPeriod(yearPeriodId As %String) As %String
{
	n (yearPeriodId)
	q:yearPeriodId="" ""
	s objYearPeriod=##class(User.ACCTYearPeriod).%OpenId(yearPeriodId)
	q:objYearPeriod="" ""
	s startDate=objYearPeriod.BeginDate
	s endDate=objYearPeriod.EndDate
	d objYearPeriod.%Close()
	;
	q startDate_"^"_endDate
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:根据库存项取售价
/// Table:
/// Input:库存项rowid，单位rowid
/// Output:
/// Return:售价
/// Others：
ClassMethod GetSp(itmRowid As %String, uomRowid As %String) As %String
{
	
  	n (itmRowid,uomRowid)
  	q:itmRowid="" 0
  	q:'$d(^INCI(itmRowid)) 0
  	s price=0
  	s excudate=+$h+1
  	s excudate=$o(^INASP(0,"INCI",itmRowid,excudate),-1)
  	q:excudate=""
  	s adjrow=$o(^INASP(0,"INCI",itmRowid,excudate,""),-1)
    q:adjrow="" 0
  	s price=+$p(^INASP(adjrow),"^",7)
  	s adjuom=$p(^INASP(adjrow),"^",10)
  	s ctuomprice=+$p(^INASP(adjrow),"^",11)
  	s buom=$p(^INCI(itmRowid,1),"^",10) ;base uom
  	i uom="" s uom=buom ;base uom
  	i uom=adjuom  d
  	.s price=ctuomprice
  	e  d
  	.s factor=..UOMFac(uom,buom)
  	.s price=price*factor
  	s price=+$j($g(price),7,6)
  	q price
}

/// Creator:zdm
/// CreatDate:2010-06-21
/// Description:取入库类型、出库类型的描述
/// Table:
/// Input:rowid
/// Output:
/// Return:类型
/// Others：
ClassMethod GetOperateTypeDesc(typeRowid As %String) As %String
{
	
  	n (typeRowid)
  	q:typeRowid="" ""
  	s typeDesc=$p(^DHCOPTYPE(typeRowid),"^",2)
  	q typeDesc
}

Query IncCat() As %SQLQuery(CONTAINID = 1)
{
	select incsc_desc,incsc_rowid From inc_stkcat
}

}
