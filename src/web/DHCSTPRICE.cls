Import SQLUser

/// Descript:取库存项价格
/// Creater:zhouyg
/// CreateDate:2011-12-12
Class web.DHCSTPRICE Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:	取进价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-03-20
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回进价(不带千分位)
ClassMethod GetRp(inclb, dah, uomID, HospID, timeh = "") As %String
{
	q:inclb="" 0
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID, dah)	//进价规则
	q:(RuleFlag=2)&(dah="") 0
	q:(RuleFlag=3)&(dah="") 0
	s RetRp=0
	i RuleFlag=1 d
	.i $p(inclb,"||",3)'="" d
	..s RetRp=+..LastInPrice(inclb,uomID,HospID)	//入库进价
	.e  d
	..s inciID=$p(inclb,"||",1)
	..s RetRp=+..GetInciLRp(inciID,uomID,HospID,dah)	//按库存项取最后一次入库的进价
	else  if RuleFlag=2 d
	.s inciID=$p(inclb,"||",1)
	.s RetRp=+..GetInciBasicRp(inciID,dah,uomID,HospID)	//统一进价
	else  if RuleFlag=3 d
	.i $p(inclb,"||",3)'="" d
	..s RetStr=..GetPriceByInclb(inclb,dah,uomID,HospID,timeh) //批次进价,按批次调价表
	..s RetRp=+$p(RetStr,"^",1)
	.e  d
	..s inciID=$p(inclb,"||",1)
	..s incib=##Class(web.DHCSTCOMINC).GetLastIncib(inciID,HospID,dah)	//zhouyg 20141203 根据医院取最后一个批次ID
	..s RetStr=..GetPriceByIncib(incib,dah,uomID,HospID,timeh)		//最后一个批次的批次进价
	..s RetRp=+$p(RetStr,"^",1)
	..//s RetRp=+..GetInciLRp(inciID,uomID,HospID)	//按库存项取最后一次入库的进价
	else  d
	.s RetRp=0	
	q RetRp
}

/// Descript:	取售价,支持各种售价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-16
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式),HospID-医院ID(如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// 			exStr-扩展参数字符串(OE_OrdItem的ID^DHC_OEDispensing的ID^DHCOEDispBatch的ID,按从小到大顺序取价格,如果小的参数为空就取大的,如果都为空再按inclb取价格)
/// 			billFlag-是否为计费对已开立的医嘱的调用(Y)
/// Return：	返回售价(不带千分位)
/// Modify：	2019-08-13,按计费点判断定价规则,dah也是计费点日期
/// 			2020-02-24,增加参数billFlag,为Y时,如果价格为0,则按日期往后取第一个价格
/// 					   ##class(web.DHCSTINTERFACE).GetBatchSp中传Y
/// 			2021-04-30,计费对已开立的医嘱调用时优先按照打包子表取价格,支持8.5,之前版本需改发药程序
/// Debug:		w ##class(web.DHCSTPRICE).GetSp("3405||7||1",+$h,"","","","","Y")
/// 			w ##class(web.DHCSTPRICE).GetSp("3405",+$h-1,"49","2","","","Y")
ClassMethod GetSp(inclb, dah, uomID, HospID, timeh = "", exStr = "", billFlag = "") As %String
{
	q:(inclb="")&(exStr="") 0
	q:(dah="")&(exStr="") 0
	s RetSp=0
	s dspBatch=$p(exStr,"^",3)
	s dspID=$p(exStr,"^",2)
	s oeorID=$p(exStr,"^",1)
	i dspBatch'="" d
	.s RetSp=+..GetDspBatSp(dspBatch)
	.i uomID'="" d
	..s buom=$p(^INCI(+inclb,1),"^",10)
	..s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uomID,buom)
	..s RetSp=RetSp*factor
	q:RetSp'=0 RetSp
	//
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID,dah)	//进价规则,加日期
	i (RuleFlag=1)!(RuleFlag=2) d
	.s inciID=$p(inclb,"||",1)
	.q:inciID=""
	.s RetSp=+..GetPriceU(inciID,dah,uomID,HospID)	//统一售价
	.i (billFlag="Y")&&(RetSp=0) d
	..s RetSp=+..GetPriceU(inciID,dah,uomID,HospID,1)
	else  if RuleFlag=3 d
	.i dspID'="" d
	..s RetSp=+..GetDspSp(dspID)
	..i uomID'="" d
	...s buom=$p(^INCI(+inclb,1),"^",10)
	...s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uomID,buom)
	...s RetSp=RetSp*factor
	.q:RetSp'=0
	.i oeorID'="" d
	..s RetSp=+..GetOeSp(oeorID)
	..i uomID'="" d
	...s buom=$p(^INCI(+inclb,1),"^",10)
	...s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uomID,buom)
	...s RetSp=RetSp*factor
	.q:RetSp'=0
	.i $p(inclb,"||",3)'="" d
	..s RetStr=..GetPriceByInclb(inclb,dah,uomID,HospID,timeh) //批次售价,按批次调价表
	..s RetSp=+$p(RetStr,"^",2)
	..i (billFlag="Y")&&(RetSp=0) d
	...s RetStr=..GetPriceByInclb(inclb,dah,uomID,HospID,timeh,1)
	...s RetSp=+$p(RetStr,"^",2)
	.e  d
	..s inciID=$p(inclb,"||",1)
	..q:inciID=""
	..s incib=##Class(web.DHCSTCOMINC).GetLastIncib(inciID,HospID,dah)	//zhouyg 20141203 根据医院取最后一个批次ID
	..s RetStr=..GetPriceByIncib(incib,dah,uomID,HospID,timeh)		//最后一个批次的批次售价
	..s RetSp=+$p(RetStr,"^",2)
	..i (billFlag="Y")&&(RetSp=0) d
	...s RetStr=..GetPriceByIncib(incib,dah,uomID,HospID,timeh,1)
	...s RetSp=+$p(RetStr,"^",2)
	.//20190822 zhouyg 修改如果取不到价格最后按统一价取
	.i RetSp=0 d
	..s inciID=$p(inclb,"||",1)
	..q:inciID=""
	..s RetSp=+..GetPriceU(inciID,dah,uomID,HospID)	//统一售价
	..i (billFlag="Y")&&(RetSp=0) d
	...s RetSp=+..GetPriceU(inciID,dah,uomID,HospID,1)
	else  d
	.s RetSp=0	
	q RetSp
}

/// Descript:	取当前进价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-18
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回进价(不带千分位)
ClassMethod GetCurRp(inclb, uomID, HospID) As %String
{
	s dateh=+$h
	s timeh=$p($h,",",2)
	s RetRp=..GetRp(inclb,dateh,uomID,HospID,timeh)
	q RetRp
}

/// Descript:	取当前售价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-18
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回售价(不带千分位)
ClassMethod GetCurSp(inclb, uomID, HospID) As %String
{
	s dateh=+$h
	s timeh=$p($h,",",2)
	s RetSp=..GetSp(inclb,dateh,uomID,HospID,timeh)
	q RetSp
}

/// Descript:	取格式化后的进价
/// Creater：	zhouyg
/// CreateDate：2014-12-04
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回进价(带千分位)
ClassMethod GetFormatRp(inclb, dah, uomID, HospID, timeh = "") As %String
{
	s RetRp=..GetRp(inclb,dah,uomID,HospID,timeh)
	s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s RetRp=##Class(web.DHCST.Common.AppCommon).TFormatRp(RetRp,HospID,1,,HerbFlag)
	q RetRp
}

/// Descript:	取格式化后的售价
/// Creater：	zhouyg
/// CreateDate：2014-12-04
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回售价(带千分位)
ClassMethod GetFormatSp(inclb, dah, uomID, HospID, timeh = "") As %String
{
	 s RetSp=..GetSp(inclb,dah,uomID,HospID,timeh)
	 s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	 s RetSp=##Class(web.DHCST.Common.AppCommon).TFormatSp(RetSp,HospID,1,,HerbFlag)
	 q RetSp
}

/// Descript:	调价的生效时间(通用)
/// Creater：	zhouyg
/// CreateDate：2014-12-04
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空)
/// 			dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return：	返回进价(不带千分位)
ClassMethod GetPriceExeDate(inclb, dah, HospID, timeh = "") As %String
{
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	s (retDate,retTime,retStr)=""
	i (RuleFlag=1)!(RuleFlag=2) d
	.s inciID=$p(inclb,"||",1)
	.s retStr=..GetSpExeDate(inclb,dah, HospID)
	else  if RuleFlag=3 d
	.i $p(inclb,"||",3)'="" d
	..s retStr=..GetSpExeDateByInclb(inclb,dah,HospID,timeh) //批次售价,按批次调价表
	.e  d
	..s inciID=$p(inclb,"||",1)
	..s incib=##Class(web.DHCSTCOMINC).GetLastIncib(inciID,HospID)
	..s retStr=..GetSpExeDateByIncib(incib,dah, HospID, timeh)
	s retDate=$p(retStr,"^",1)
	s retTime=$p(retStr,"^",2)
	q retDate_"^"_retTime
}

/// Descript：	取批次调价的生效时间
/// CreatDate：	2014-12-04
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmbat的ID,日期(数值格式),CT_Hospital的ID,时间(数值格式)
/// Return:		格式进价^格式售价^批次调价ID^未格式进价^未格式售价
ClassMethod GetSpExeDateByIncib(incib, dateh, HospID = "", timeh = "") As %String
{
	q:incib="" ""
	i dateh="" s dateh=+$h
	i timeh="" s timeh=86399 //23:59:59
	s (retDate,retTime)=0
	s apbID=""
	s nTime=timeh+1
	I HospID'="" D
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime),-1) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime,""),-1)
	..i apbID'="" d
	...s retDate=dateh
	...s retTime=execTime
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate),-1) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,execTime,""),-1)
	...i apbID'="" d
	....s retDate=execDate
	....s retTime=execTime
	i apbID="" d
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime),-1) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime,""),-1)
	..i apbID'="" d
	...s retDate=dateh
	...s retTime=execTime
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"INCIB",incib,execDate),-1) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,execTime,""),-1)
	...i apbID'="" d
	....s retDate=execDate
	....s retTime=execTime
	Q:apbID="" ""
	i retDate'="" s retDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate)
	i retTime'="" s retTime=$zt(retTime,1)
	q retDate_"^"_retTime
}

/// Descript:根据库存项ID和医院取某一库存项的最后入库进价
ClassMethod GetInciLRp(inci, uom, HospID = "", dah = "") As %String
{
	q:inci="" 0
	i dah="" s dah=+$h
	i ..ChkRIngr(inci)=1 s lrp=..GetItmManPrice(inci,uom,HospID)	;制剂取进价
	s buom=$p(^INCI(inci,1),"^",10)
	s puom=$p(^INCI(inci,3),"^",6)
	s ingr="",rp=0
	f  s ingr=$o(^DHCINGR(0,"INCI",inci,ingr),-1) q:(ingr="")!(rp'=0)  d
	.q:($d(^DHCINGR(ingr))=0)!(($d(^DHCINGR(ingr))=10))
	.q:$p(^DHCINGR(ingr),"^",8)=""	//未审核
	.S LocHospID=..GetHospIDByIngr(ingr)
	.Q:(HospID'="")&(HospID'=LocHospID)
	.s ingrlocdr=$p(^DHCINGR(ingr),"^",13)
	.s locDesc=$p(^CTLOC(ingrlocdr),"^",2)
	.q:locDesc'["库"	//zhouyg 20141203去掉非库房的初始化数据
	.s ingrsub=$o(^DHCINGR(0,"INCI",inci,ingr,""),-1) q:ingrsub=""
	.q:($d(^DHCINGR(ingr,"GRI",ingrsub))=0)!(($d(^DHCINGR(ingr,"GRI",ingrsub))=10))
	.s auditdah=$p(^DHCINGR(ingr),"^",4)
	.q:auditdah>dah	//zhouyg 20141203 取某一日期之前的最后售价
	.s recuom=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",10)
	.s rp=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",30)
	.i uom="" s uom=buom
	.Q:uom=recuom
	.s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
	.s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(recuom,buom)
	.s rp=rp/fac2*fac1
	
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(inci)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((uom=buom)&&(puom'=buom):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,fmtCode,dFlag)
}

// ********************以下函数不作为外部class或csp或js调用使用*****************************//

/// Descript:根据库存项批次取最后的入库ID
/// Input:incib-inc_itmbat的RowID
/// Output:入库子表ID
ClassMethod LastINGRIByIB(incib) As %String
{
	q:incib="" ""
	s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
	i INGR d
	.s INGRCH=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""))
	.s INGRI=INGR_"||"_INGRCH
	q $g(INGRI)
}

/// Descript:根据科室库存项批次取最后的入库ID
/// Input:incib-inc_itmbat的RowID
/// Output:入库子表ID
ClassMethod LastINGRI(inclb) As %String
{
	s incib=$$CIBrow^at299(inclb)
	q:incib="" ""
	s INGRI=..LastINGRIByIB(incib)
	q INGRI
}

/// Descript:取入库表的进价，实际进货价
/// Input:inclb-科室库存项ID,UOM-单位ID,HospID-医院ID
/// 
ClassMethod LastInPrice(inclb, UOM, HospID = "") As %String
{
	q:inclb="" ""
	Q:..ChkRIngr(+inclb)=1 ..GetManPrice(inclb,UOM)	;制剂取进价
	s LASTINGRI=..LastINGRI(inclb) q:LASTINGRI="" ""
	s DHCINGR=$P(LASTINGRI,"||",1)
	s DHCINGRCH=$P(LASTINGRI,"||",2)
	s RP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)    ; Real Price (in)
	s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
	s BUOM=$p(^INCI(+inclb,1),"^",10)
	s PUOM=$p(^INCI(+inclb,3),"^",6)
	i $g(UOM)="" s UOM=BUOM
	i UOM=RECUOM q RP     ; if the specified uom equals to the rec uom 
	s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
	s RP=RP/fac2*fac1
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((UOM=BUOM)&&(PUOM'=BUOM):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,perv,fmtCode,dFlag)
}

/// Descript:取入库表的批价
ClassMethod LastInPurPrice(inclb, UOM, HospID = "") As %String
{
	Q:..ChkRIngr(+inclb)=1 ..GetManPrice(inclb,UOM)	;制剂取进价
	s LASTINGRI=..LastINGRI(inclb)
	s DHCINGR=$P(LASTINGRI,"||",1)
	s DHCINGRCH=$P(LASTINGRI,"||",2)
	s PP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)    ; Real Price (in)
	s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
	s BUOM=$p(^INCI(+inclb,1),"^",10)
	s PUOM=$p(^INCI(+inclb,3),"^",6)
	i UOM="" s UOM=BUOM
	i UOM=RECUOM q PP     ; if the specified uom equals to the rec uom 
	s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
	s PP=PP/fac2*fac1
	
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((UOM=BUOM)&&(PUOM'=BUOM):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(PP,perv,fmtCode,dFlag)
}

/// Descript:取入库表的进价和批价
ClassMethod LastPrice(inclb, UOM, HospID = "") As %String
{
	S Recflag=..ChkRIngr(+inclb) ;制剂取进价
	I Recflag=1  S RP=..GetManPrice(inclb,UOM)
	Q:Recflag=1 RP_"^"_RP
	s LASTINGRI=..LastINGRI(inclb)
	q:LASTINGRI="" ""
	s DHCINGR=$P(LASTINGRI,"||",1)
	s DHCINGRCH=$P(LASTINGRI,"||",2)
	s RP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)    ; Real Price (in)
	s PP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)    ; Purchase Price (in)
	s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
	s BUOM=$p(^INCI(+inclb,1),"^",10)
	s PUOM=$p(^INCI(+inclb,3),"^",6)
	i UOM="" s UOM=BUOM
	i UOM=RECUOM q PP_"^"_RP    ; if the specified uom equals to the rec uom 
	s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
	s RP=RP/fac2*fac1
	s PP=PP/fac2*fac1
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((UOM=BUOM)&&(PUOM'=BUOM):2,1:1)
	s RP=##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,perv,fmtCode,dFlag)
	s PP=##Class(web.DHCSTCOMMPARA).GetNumbDec(PP,perv,"FmtPP",2)
	q PP_"^"_RP
}

/// Descript:根据DHC_InGdRecItm表的rowid取价格(批价和进价)
ClassMethod GetPriceByDIngri(ingri, UOM) As %String
{
	q:ingri="" ""
	s DHCINGR=$p(ingri,"||",1) q:DHCINGR="" ""
	s DHCINGRCH=$p(ingri,"||",2) q:DHCINGRCH="" ""
	s INGRIDATA = $g(^DHCINGR(DHCINGR,"GRI",DHCINGRCH))
	s RP=$p(INGRIDATA,"^",30)    ; Real Price (in)
	s PP=$p(INGRIDATA,"^",35)    ; Purchase Price (in)
	s RECUOM=$p(INGRIDATA,"^",10) ; UOM
	s INCI=$p(INGRIDATA,"^",25)
	s BUOM=$p(^INCI(+INCI,1),"^",10)
	s PUOM=$p(^INCI(+INCI,3),"^",6)
	i UOM="" s UOM=BUOM
	q:UOM=RECUOM PP_"^"_RP     ; if the specified uom equals to the rec uom 
	s Fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s Fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
	s RP=RP/Fac2*Fac1
	s PP=PP/Fac2*Fac1
	s LocID=$P(^DHCINGR(DHCINGR),"^",13)
	s HospID=$P(^CTLOC(LocID),"^",22)
 
	s $p(Perv,"^",5)=HospID
	s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(INCI)
	s FmtCode = $s(HerbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s DFlag = $s((UOM=BUOM)&&(PUOM'=BUOM):2,1:1)
	s RP=##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,Perv,FmtCode,DFlag)
	s PP=##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,Perv,"FmtPP",DFlag)
	q PP_"^"_RP
}

/// Descript:根据inc_itmbat的RowID取
ClassMethod GetRPByIncib(incib, UOM, HospID = "") As %String
{
	s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
	i INGR d
	.s INGRCH=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR,""))
	.s INGRI=INGR_"||"_INGRCH
	q:$g(INGRI)="" ""
	s DHCINGR=$p(INGRI,"||",1)
	s DHCINGRCH=$p(INGRI,"||",2)
	s INGRIDATA=$g(^DHCINGR(DHCINGR,"GRI",DHCINGRCH))
	s RP=$p(INGRIDATA,"^",30)    ; Real Price (in)
	s RECUOM=$p(INGRIDATA,"^",10) ; UOM
	s BUOM=$p(^INCI(+incib,1),"^",10)
	s PUOM=$p(^INCI(+incib,3),"^",6)
	i UOM="" s UOM=BUOM
	q:UOM=RECUOM RP     ; if the specified uom equals to the rec uom 
	s Fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(UOM,BUOM)
	s Fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(RECUOM,BUOM)
	s RP=RP/Fac2*Fac1
	
	s $p(perv,"^",5)=HospID
	s HerbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+incib)
	s FmtCode = $s(HerbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s DFlag = $s((UOM=BUOM)&&(PUOM'=BUOM):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(RP,perv,FmtCode,DFlag)
}

/// Descript:根据代码和医院取某一库存项的最后入库进价
ClassMethod GetItmLastRP(itmcode, uom, HospID = "") As %String
{
	q:itmcode="" 0
	s inci=""
	s inci=##Class(web.DHCSTCOMMONSRV).ItemCodeToID(itmcode) q:inci="" 0
	i uom'="" s uom=##Class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
	q ..GetInciLRp(inci,uom,HospID)
}

/// Descript:根据库存项ID和医院取某一库存项的最后入库进价，同函数GetInciLRp
ClassMethod GetInciLastRp(inci, uom, HospID = "") As %String
{
	S rp=..GetInciLRp(inci,uom,HospID)
	q rp
}

/// Descript：根据代码取调价表的调整批价
ClassMethod GetCurItmBRp(itmcode, uomdesc, HospID = "") As %String
{
	s inci=##Class(web.DHCSTCOMMONSRV).ItemCodeToID(itmcode)
	q:inci="" 0
	s uomdr=""
	s:uomdesc'="" uomdr=##Class(web.DHCSTCOMMONSRV).CTUOMToID(uomdesc)
	q ..GetInciBasicRp(inci,+$h,uomdr,HospID)
}

/// Descript：根据库存项ID取调价表的调整批价
ClassMethod GetInciBasicRp(inciid, stdate, uom, HospID = "") As %String
{
	s buom=$p(^INCI(inciid,1),"^",10)
	s puom=$p(^INCI(inciid,3),"^",6)
	i uom="" s uom=buom
	s retrp=0,adjrow=""
	s excudate=stdate+1
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag(HospID)  //yunhaibao20151222,集团化医院各自管理价格
	I (HospID'="")&&(GroupFlag=2) D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
	//20141201 zhouyg 添加判断根据医院取不到数据的情况下取公共价格
	i (GroupFlag'=2)&&(adjrow="") d
	.s excudate=stdate+1
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	q:adjrow="" 0
	s inaspData=$g(^INASP(adjrow))
	s price=$p(inaspData,"^",16)
	s adjuom=$p(inaspData,"^",10)
	s ctuomprice=$p(inaspData,"^",14)
	i uom=adjuom  d
	.s retrp=ctuomprice
	e  d
	.s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
	.s retrp=price*factor
	
	s $p(comPerv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(inciid)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((uom=buom)&&(puom'=buom):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(retrp,comPerv,fmtCode,dFlag)
}

/// Descript：根据inclb取最后入库的进价，制剂则从制剂业务表取
ClassMethod GetLastImpPrice(inclb, uomdr) As %String
{
	i ..ChkRIngr(+inclb)=1 s lrp=..GetManPrice(inclb,uomdr)	;制剂取进价
	e  s lrp=..LastInPrice(inclb,uomdr)
	q lrp
}

/// Descript：根据inclb从制剂表取进价（只对制剂库存项）
ClassMethod GetManPrice(inclb, uomdr = "", HospID = "") As %String
{
	q:inclb="" ""
	s incib=$$CIBrow^at299(inclb)
	q:incib="" ""
	s manid=""
	s manid=$o(^DHCINMAN(0,"INCIB",incib,""),-1)
	q:manid="" ""
	q:'$d(^DHCINMAN(manid)) ""
	s rp=+$p(^DHCINMAN(manid),"^",11)
	S muomdr=$p(^DHCINMAN(manid),"^",8)
	S buomdr=$P(^INCI(+inclb,1),"^",10)
	s puomdr=$P(^INCI(+inclb,3),"^",6)
	I uomdr="" S uomdr=buomdr
	Q:muomdr=uomdr rp
	s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
	s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(muomdr,buomdr)
	s rp=rp/fac2*fac1

	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((uomdr=buomdr)&&(puomdr'=buomdr):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,fmtCode,dFlag)
}

/// Descript：根据库存项ID从制剂表取进价（只对制剂库存项）
ClassMethod GetItmManPrice(inci, uomdr, HospID = "") As %String
{
	q:inci="" ""
	S buomdr=$P($g(^INCI(inci,1)),"^",10)
	S puomdr=$P($g(^INCI(inci,3)),"^",6)
	I uomdr="" S uomdr=buomdr
	s manid="",rp=0
	F  s manid=$o(^DHCINMAN(0,"INCI",inci,manid),-1) Q:(manid="")!(rp'=0)  D
	.q:manid=""
	.q:'$d(^DHCINMAN(manid))
	.S locdr=$P(^DHCINMAN(manid),"^",3)
	.S LocHospID=$P(^CTLOC(locdr),"^",22)
	.Q:(HospID'="")&(LocHospID'=HospID)
	.s rp=+$p(^DHCINMAN(manid),"^",11)
	.S muomdr=$p(^DHCINMAN(manid),"^",8)
	.Q:muomdr=uomdr
	.s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
	.s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(muomdr,buomdr)
	.s rp=rp/fac2*fac1
 
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inci)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((uomdr=buomdr)&&(puomdr'=buomdr):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,fmtCode,dFlag)
}

/// Descript：判断是否制剂
ClassMethod ChkRIngr(inci) As %String
{
	q:inci="" 0
	s recsub=""
	s recsub=$o(^INCI(inci,"REC","0"))
	q:(recsub=0)!(recsub="") 0
	q 1
}

/// Descript:取某库存项某供应商的最新进价和批价
/// itmid - 必需的参数
/// uomid - 非必需(若为空,则返回最新入库的单位)
/// venid - 非必需(若为空,则返回最新入库的供应商)
ClassMethod FinalIV(itmid, uomid, venid, HospID = "") As %String
{
	Q:itmid="" ""
	s ok=0
	s rp="",pp=""
	s fac=""
	s buom=$p(^INCI(itmid,1),"^",10)
	s puom=$p(^INCI(itmid,3),"^",6)
	s ingr=""
	f  s ingr=$o(^DHCINGR(0,"INCI",itmid,ingr),-1) q:(ingr="")!(ok>0)  d   //循环查找入库
	.s ingrdate=$p(^DHCINGR(ingr),"^",4) q:ingrdate'>0  //必须是审核过的
	.i venid'="" q:'$d(^DHCINGR(0,"Vendor",venid,ingr))   //验证供应商
	.S LocHospID=..GetHospIDByIngr(ingr)
	.Q:(HospID'="")&(HospID'=LocHospID)
	.s ch=$o(^DHCINGR(0,"INCI",itmid,ingr,0)) q:ch=""
	.s ok=1
	.s ingriData=$g(^DHCINGR(ingr,"GRI",ch))
	.s rp=$p(ingriData,"^",30)  //进价
	.s pp=$p(ingriData,"^",35)  //批价
	.s uom=$p(ingriData,"^",10)
	.S fac=""
	.i uomid="" d
	..s uomid=uom
	..s fac=1
	.e  d
	..s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uomid,buom) 
	..s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom) 
	..i +fac1=0 q 
	..s fac=fac2/fac1
	.q:fac=""
	.s rp=rp/fac
	.s pp=pp/fac
	.i venid="" s venid=$p(^DHCINGR(ingr),"^",3)  //若不输入供应商则返回最新供应商

	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+itmid)
	s fmtCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s dFlag = $s((uomid=buom)&&(puom'=buom):2,1:1)
	s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,fmtCode,dFlag)	
	s pp=##Class(web.DHCSTCOMMPARA).GetNumbDec(pp,perv,"FmtPP",dFlag)	
	q rp_"^"_pp_"^"_venid_"^"_uomid
}

/// Descript：取某一代码的售价和进价
ClassMethod GetRpAndSp(code, ctloc, HospID = "") As %String
{
	s inci=##Class(web.DHCSTCOMMONSRV).ItemCodeToID(code)
	q:inci="" 0
	S Sp=$p(##Class(web.DHCSTCOMMONSRV).GetItemSp(code,HospID),"^",1)
	S Rp=..GetInciLRp(inci,"",HospID)
	q Rp_"^"_Sp
}

/// Descript：根据代码取调价表的调整批价（建议用GetCurItmBRp）
ClassMethod GetItemRp(code, HospID = "") As %String
{
	s itemcode=$p(code,"^",1)
	s uom=$p(code,"^",2)
	Q ..GetCurItmBRp(itemcode,uom,HospID)
}

/// Descript：根据代码和单位取调价表的调整批价（建议用GetCurItmBRp）
ClassMethod GetItemRpUO(itemcode, uo, HospID = "") As %String
{
	s itemcode=itemcode_"^"_uo
	s sp=..GetItemRp(itemcode,HospID)
	q sp
}

/// Descript：取调价表的调整批价（建议用GetInciBasicRp）
ClassMethod GetPriceElse(inciid, stdate, uom, HospID = "") As %String
{
	Q ..GetInciBasicRp(inciid,stdate,uom,HospID)
}

/// Creator:zdm
/// CreatDate:2009-3-31
/// Description:取该批次最后一次入库的售价和单位
/// Table:DHC_INGdRecItm
/// Input:inc_itmlcbt的rowid
/// OutPut:
/// Return:售价^单位
ClassMethod GetLastRecSp(inclb) As %String
{
	s ingri=..LastINGRI(inclb) 
	q:ingri="" ""
	s ingr=$p(ingri,"||",1)
	s chl=$p(ingri,"||",2)
	s recsp=$p(^DHCINGR(ingr,"GRI",chl),"^",45)
	s recuom=$p(^DHCINGR(ingr,"GRI",chl),"^",10)
	q recsp_"^"_recuom
}

/// Creator:zhouyg
/// CreatDate:2009-6-19
/// Description:取某一库存项的最后的入库售价
/// Table:DHC_INGdRecItm
/// Input:库存项代码,单位描述
/// OutPut:
/// Return:入库售价
ClassMethod GetItmLastNewSP(itmcode, uom, HospID = "") As %String
{
	q:itmcode="" 0
	s inci=""
	s inci=##Class(web.DHCSTCOMMONSRV).ItemCodeToID(itmcode) q:inci="" 0
	i uom'="" s uom=##Class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
	q ..GetInciLastNewSp(inci,uom,HospID)
}

/// Description:取某一库存项的最后的入库售价
ClassMethod GetInciLastNewSp(inci, uom, HospID = "") As %String
{
	q:inci="" 0
	s buom=$p($g(^INCI(inci,1)),"^",10)
	s puom=$p($g(^INCI(inci,3)),"^",6)
	i uom="" s uom=buom
	S ingr="",newsp=0
	F  s ingr=$o(^DHCINGR(0,"INCI",inci,ingr),-1) q:(ingr="")!(newsp'=0)  D
	.q:($d(^DHCINGR(ingr))=0)!(($d(^DHCINGR(ingr))=10))
	.q:$p(^DHCINGR(ingr),"^",8)=""	//未审核
	.S LocHospID=..GetHospIDByIngr(ingr)
	.Q:(HospID'="")&(HospID'=LocHospID)
	.s ingrsub=$o(^DHCINGR(0,"INCI",inci,ingr,""),-1) q:ingrsub=""
	.q:($d(^DHCINGR(ingr,"GRI",ingrsub))=0)!(($d(^DHCINGR(ingr,"GRI",ingrsub))=10))
	.s recuom=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",10)
	.s newsp=+$p(^DHCINGR(ingr,"GRI",ingrsub),"^",45)
	.Q:uom=recuom
	.s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
	.s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(recuom,buom)
	.s newsp=newsp/fac2*fac1
	
	s $p(perv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inci)
	s fmtCode = $s(herbFlag="Y":"FmtSPHerb",1:"FmtSP")
	s dFlag = $s((uom=buom)&&(puom'=buom):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(newsp,perv,fmtCode,dFlag)
}

/// Descript:根据代码取某一日期的调价表的批价
ClassMethod GetItemDateRp(code, stdate, HospID = "") As %String
{
   
  s itemcode=$p(code,"^",1)
  s uom=$p(code,"^",2)
  i uom'="" d
  .s uom=##Class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
  .S uom=$p(uom,$c(1))
  s inciid=$p(##Class(web.DHCSTCOMMONSRV).ItemCodeToID(itemcode),$c(1))
  s rp=..GetInciBasicRp(inciid,stdate,uom,HospID)
  q rp
}

/// Descript:	根据入库主表ID取医院ID
/// Input:		ingr-DHC_InGdRec的Rowid
/// Output:	CT_Hospital的Rowid
ClassMethod GetHospIDByIngr(ingr) As %String
{
	Q:ingr="" ""
	Q:'$D(^DHCINGR(ingr)) ""
	S locdr=$P(^DHCINGR(ingr),"^",13)
	Q:locdr="" ""
	Q:'$D(^CTLOC(locdr)) ""
	S HospID=$P(^CTLOC(locdr),"^",22)
	Q HospID
}

/// Descript:	根据批次取批次表保存的进价
/// CreateDate：2011-04-21
/// Creater：	周永刚
/// Input：		inclb-批次rowid
/// Return：	单位入库时的进价
ClassMethod GetClbRp(inclb, UomID) As %String
{
	Q:inclb="" 0
	S RecRp=0
	S incib=$$CIBrow^at299(inclb)
	I incib'="" D
	.S dhcincib=$O(^DHCINCIB(0,"INCIB",incib,""))
	.I dhcincib'="" D
	..S inci=$P(inclb,"||",1)
	..Q:inci=""
	..S BUomID=$P(^INCI(inci,1),"^",10)
	..S PUomID=$P(^INCI(inci,3),"^",6)
	..I UomID="" S UomID=BUomID
	..S bRecRp=+$P(^DHCINCIB(dhcincib),"^",3)
	..I UomID=BUomID D
	...S RecRp=bRecRp
	..Else  If UomID=PUomID D
	...S RecRp=+$P(^DHCINCIB(dhcincib),"^",4)
	..Else
	...S Fac=##Class(web.DHCSTCOMMONSRV).UOMFac(UomID,BUomID)
	...S RecRp=bRecRp*Fac
	Q RecRp
}

/// Descript：	根据INCLB取某一天的进价（如果入库之后调价取调价表批价，否则取入库表进价）
/// 			目前批次没有里没有根据入库日期，如果同一批次在调价后又入库，就只能取入库的进价，如果再次调价就会导致批次的损益计算不精确
/// CreateDate：2011-04-21
/// Creater：	zhouyg
ClassMethod GetDayRp(inclb, dah, UomID, HospID = "") As %String
{
	Q:inclb="" 0
	I dah="" S dah=+$H
	S dah=dah+1
	S inci=$P(inclb,"||",1)
	Q:inci="" 0
	Q:'$D(^INCI(inci,1)) 0
	S BUomID=""
	I UomID="" D
	.S BUomID=$P(^INCI(inci,1),"^",10)
	.S UomID=BUomID
	Q:UomID="" 0
	S arp=0,RecRp=0,RetRp=0
	//最后的调价生效日期
	I HospID="" D
	.S AspDah=$O(^INASP(0,"INCI",inci,dah),-1)
	E  D
	.S AspDah=$O(^INASP(0,"HOSPI",HospID,inci,dah),-1)
	I AspDah'="" D
	.S arp=..GetInciBasicRp(inci,AspDah,UomID,HospID)
	//最后的入库日期
	S RecDate="",RecTime=""
	S incib=$$CIBrow^at299(inclb)
	I incib'="" D
	.S INGR=""
	.F  S INGR=$O(^DHCINGR(0,"GRI_INCIB",incib,INGR),-1) Q:(INGR="")!(RecDate'="")  D
	..S tRecDate=$P($G(^DHCINGR(INGR)),"^",4)
	..I tRecDate<dah D
	...S RecDate=tRecDate
	...//S RecTime=$P($G(^DHCINGR(INGR)),"^",9)
	.S RecRp=..GetClbRp(inclb,UomID)
	I AspDah>RecDate D
	.I arp'=0 D
	..S RetRp=arp
	.E  D
	..S RetRp=RecRp
	E  D 
	.I RecRp'=0 D
	..S RetRp=RecRp
	.E  D
	..S RetRp=arp
	Q RetRp
}

/// Creator:zdm
/// CreatDate:2010-06-11
/// Description:根据入库明细rowid取进价
/// Table:dhc_InGdRecItm
/// Input:入库明细rowid
/// OutPut:
/// Return:进价
ClassMethod GetRpByIngri(ingri, uom) As %String
{
	q:ingri="" 0
	s ingr=$P(ingri,"||",1)
	s chl=$P(ingri,"||",2)
	s rp=$p(^DHCINGR(ingr,"GRI",chl),"^",30)    ; Real Price (in)
	s recuom=$p(^DHCINGR(ingr,"GRI",chl),"^",10) ; UOM
	s inclb=$p(^DHCINGR(ingr,"GRI",chl),"^",1)
	s buom=$p(^INCI(+inclb,1),"^",10)
	i $g(uom)="" s uom=buom
	q:uom=recuom rp							; if the specified uom equals to the rec uom 
	s fac1=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
	s fac2=##Class(web.DHCSTCOMMONSRV).UOMFac(recuom,buom)
	s rp=rp/fac2*fac1
	q rp
}

/// Descript：	根据库存项批次取批次调价表的进价和售价
/// CreatDate：	2013-07-16
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmbat的ID,日期(数值格式),单位ID,CT_Hospital的ID,时间(数值格式),dirFlag(正序或倒序取)
/// Return:		格式进价^格式售价^批次调价ID^未格式进价^未格式售价
/// w ##class(web.DHCSTPRICE).GetPriceByIncib("3405||5",+$h-1,"","3","",1)
ClassMethod GetPriceByIncib(incib, dateh, uomID, HospID = "", timeh = "", dirFlag = "") As %String
{
	i dirFlag=1 s dirFlag=1
	e  s dirFlag=-1
	q:incib="" "0^0^^0^0"
	i dateh="" s dateh=+$h
	i timeh="" s timeh=86399 //23:59:59
	s (retrp,retsp)=0
	s apbID=""
	s nTime=timeh+1
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag(HospID) //yunhaibao20151222,集团化医院各自管理价格
	I (HospID'="")&&(GroupFlag=2) D
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime),-1) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime,""),-1)
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate),dirFlag) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,execTime,""),-1)
	i (GroupFlag'=2)&&(apbID="") d
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime),dirFlag) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime,""),-1)
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"INCIB",incib,execDate),dirFlag) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,execTime,""),-1)
	Q:apbID="" "0^0^^0^0"
	s inciID=$p(incib,"||",1)
	s buomID=$p(^INCI(inciID,1),"^",10)
	s puomID=$p(^INCI(inciID,3),"^",6)
	i uomID="" s uomID=buomID
	s inapbData = $g(^DHCSTINAPB(apbID))
	s adjuomID=$p(inapbData,"^",5)
	s adjuomRp=$p(inapbData,"^",7)
	s adjuomSp=$p(inapbData,"^",9)
	s buomRp=$p(inapbData,"^",11)
	s buomSp=$p(inapbData,"^",13)
	i uomID=adjuomID  d
	.s retrp=adjuomRp
	.s retsp=adjuomSp
	e  d
	.s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uomID,buomID)
	.s retrp=buomRp*factor
	.s retsp=buomSp*factor
	
	s $p(comPerv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(inciID)
	s fmtRPCode = $s(herbFlag="Y":"FmtRPHerb",1:"FmtRP")
	s fmtSPCode = $s(herbFlag="Y":"FmtSPHerb",1:"FmtSP")
	s dFlag = $s((uomID=buomID)&&(puomID'=buomID):2,1:1)
	s retrp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retrp,comPerv,fmtRPCode,dFlag)
	s retsp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retsp,comPerv,fmtSPCode,dFlag)
	q retrp_"^"_retsp_"^"_apbID_"^"_retrp_"^"_retsp	//zhouyg 20141203 添加返回apbID_"^"_retrp_"^"_retsp
}

/// Descript：	根据科室库存项批次取批次调价表的进价和售价
/// CreatDate：	2013-07-16
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmlcbt的ID,日期(数值格式),单位ID,CT_Hospital的ID,时间(数值格式),dirFlag(正序或倒序取)
/// Return:		格式进价^格式售价^批次调价ID^未格式进价^未格式售价
ClassMethod GetPriceByInclb(inclb, dateh, uomID, HospID = "", timeh = "", dirFlag = "") As %String
{
	q:inclb="" "0^0^^0^0"
	s incib=##Class(web.DHCSTCOMINC).GetIncib(inclb)
	q:incib="" "0^0^^0^0"
	s RetStr=..GetPriceByIncib(incib,dateh,uomID,HospID,timeh,dirFlag)
	q RetStr
}

/// Descript：	取调价生效日期
/// CreatDate：	2014-12-04
/// Creater：	zhouyg
/// Input:		库存项ID,日期(H格式),医院ID
ClassMethod GetSpExeDate(inciid, stdate, HospID = "") As %String
{
	Q:inciid="" 0
	Q:'$D(^INCI(inciid)) 0
	s price=0
	S adjrow="",excudate=stdate+1
	I HospID'="" D
	.s aexcudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:aexcudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,aexcudate,""),-1)
	i adjrow="" d
	.s aexcudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:aexcudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,aexcudate,""),-1)
	Q:adjrow="" ""
	i aexcudate'="" s aexcudate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(aexcudate)
	s exeTime="00:00:00"
	q aexcudate_"^"_exeTime
}

/// Descript：	取批次调价的时间
/// CreatDate：	2014-12-04
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmlcbt的ID,日期(数值格式),单位ID,CT_Hospital的ID,时间(数值格式)
/// Return:		格式进价^格式售价^批次调价ID^未格式进价^未格式售价
ClassMethod GetSpExeDateByInclb(inclb, dateh, HospID = "", timeh = "") As %String
{
	q:inclb="" ""
	s incib=##Class(web.DHCSTCOMINC).GetIncib(inclb)
	q:incib="" ""
	s RetStr=..GetSpExeDateByIncib(incib,dateh,HospID,timeh)
	q RetStr
}

/// Descript:	取调价售价(非批次价)从DHCSTCOMMONSRV.GetPriceElse移过来
/// Creater：	zhouyg
/// CreateDate：	2015-01-13
/// Input：		inciid-库存项ID, stdate-H格式, uom-单位ID, HospID
/// Return：		售价（四舍五入，但是没有千分位）
/// w ##class(web.DHCSTPRICE).GetPriceU()
ClassMethod GetPriceU(inciid, stdate, uom, HospID = "", dirFlag = "") As %String
{
	i dirFlag=1 s dirFlag=1
	e  s dirFlag=-1
	k price
	Q:inciid="" 0
	Q:'$D(^INCI(inciid)) 0
	s GroupFlag=##Class(web.DHCSTCOMMPARA).GetGroupFlag(HospID) //yunhaibao20151222,集团化医院各自管理价格

	s price=0
	i dirFlag=-1 s excudate=stdate+1
	e  s excudate=stdate
	S adjrow=""
	I (HospID'="")&&(GroupFlag=2) D
	.s aexcudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),dirFlag)
	.Q:aexcudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,aexcudate,""),dirFlag)
	i (GroupFlag'=2)&&(adjrow="") d
	.s aexcudate=$o(^INASP(0,"INCI",inciid,excudate),dirFlag)
	.Q:aexcudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,aexcudate,""),dirFlag)
	Q:adjrow="" 0
	s inaspData = ^INASP(adjrow)
	s price=+$p(inaspData,"^",7)
	s adjuom=$p(inaspData,"^",10)
	s ctuomprice=+$p(inaspData,"^",11)
	s buom=$p(^INCI(inciid,1),"^",10) ;base uom
	s puom=$p(^INCI(inciid,3),"^",6) 
	i uom="" s uom=buom ;base uom
	i uom=adjuom  d
	.s price=ctuomprice
	e  d
	.s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(uom,buom)
	.s price=price*factor

	s $p(comPerv,"^",5)=HospID
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(inciid)
	s fmtCode = $s(herbFlag="Y":"FmtSPHerb",1:"FmtSP")
	s dFlag = $s((uom=buom)&&(puom'=buom):2,1:1)
	q ##Class(web.DHCSTCOMMPARA).GetNumbDec(price,comPerv,fmtCode,dFlag)
}

/// Descript：	获取配药批次表中第一个批次售价(门诊按医嘱取价格)
/// Creater：	zhouyg
/// CreateDate：2015-01-14
/// Return:		售价
ClassMethod GetOeSp(OrdItmdr As %String)
{
	q:OrdItmdr="" 0
	s oedosdr="",batsp=0
	s oedosdr=$o(^DHCOEDISQTY(0,"OEORI",OrdItmdr,oedosdr))
	q:(oedosdr="") 0
	q:'$D(^DHCOEDISQTY(oedosdr)) 0
	s batsp=..GetDspSp(oedosdr)
	q batsp
}

/// Descript：	取医嘱执行记录售价(住院按执行取价格)
/// Creater：	zhouyg
/// CreateDate：2014-12-24
/// Table：		DHC_OEDispensing,DHC_OEDispBatch
/// Input：		DspID-DHC_OEDispensing的ID
/// Output：	批次售价
/// Return：	批次售价
ClassMethod GetDspSp(DspID As %String) As %String
{
	q:DspID="" 0
	s dspBatSub="0",findflag=0,batsp=0
	f  s dspBatSub=$o(^DHCOEDISQTY(DspID,"I",dspBatSub)) q:(dspBatSub="")||(findflag=1)  d
	.s DspBatchID=DspID_"||"_dspBatSub
	.s batsp=..GetDspBatSp(DspBatchID)
	.s findflag=1
	q batsp
}

/// Descript：	取打包子表记录售价
/// Creater：	zhouyg
/// CreateDate：2021-04-30
/// Table：		DHC_OEDispBatch
/// Input：		DspBatchID-DHC_OEDispBatch的ID
/// Return：	售价
ClassMethod GetDspBatSp(DspBatchID As %String) As %String
{
	q:DspBatchID="" 0
	s DspID=+$p(DspBatchID,"||",1)
	s dspBatSub=+$p(DspBatchID,"||",2)
	q:(DspID=0)||(dspBatSub=0) 0
	q:'$D(^DHCOEDISQTY(DspID,"I",dspBatSub)) 0
	s batsp=+$p(^DHCOEDISQTY(DspID,"I",dspBatSub),"^",4)
	q batsp
}

/// Author：	MaYuqiang
/// CreateDate：2022-08-01
/// Descript：	根据医嘱项获取默认价格
/// 			仅在医嘱录入界面展示价格使用，当医嘱项对应库存项均不可用时，默认返回最后一个库存项对应的价格
/// Input：		arcimId - ARC_ItmMast的ID , hospId - 院区id
/// Return：	售价
/// w ##class(web.DHCSTPRICE).GetDefSpByArcim()
ClassMethod GetDefSpByArcim(arcimId As %String, hospId As %String) As %String
{
	q:arcimId="" 0
	s inci = +$o(^INCI(0, "ARCIM_DR", $p(arcimId,"||",1), ""), -1)
	s retSp = ##Class(web.DHCSTPRICE).GetCurSp(inci, "", hospId)
	q retSp
}

}
