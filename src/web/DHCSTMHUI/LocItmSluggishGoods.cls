Import sqluser

Class web.DHCSTMHUI.LocItmSluggishGoods Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 取呆滞记录数据串(json)
/// Author:zhwh
/// Date:2012-07-30
/// Argu: Start,Limit,Sort,Dir,StrPar(科室^sd^ed^业务台帐类型$日期,...),user
/// Return: 呆滞记录数据串(json)
/// 2015-07-08 改为直接遍历global
/// w ##class(web.DHCSTMHUI.LocItmSluggishGoods).jsLocItmSluggishGoods(1,15,"","",,"")
ClassMethod jsLocItmSluggishGoods(page As %String, rows As %String, Sort As %String = "", Dir As %String = "", StrPar As %String, User As %String, BusinessTypes As %String) As %String
{
	n (page,rows,Sort,Dir,StrPar,User,BusinessTypes)
	s Start=(page-1)*rows
	s Limit=rows
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(StrPar)
	s Loc=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s UserId=PJObj.%Get("UserId")
	s HospID=$p(^CTLOC(Loc),"^",22)
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s UserCatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),Loc,"",HospID)
	s count = 0
	s end = Start+Limit
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()

	s inci=0
	f  s inci=$o(^INCI("IL_LOC",Loc,inci)) q:inci=""  d
	.s NotUseFlag=$p(^INCI(inci,2),"^",9)
	.q:NotUseFlag="Y"
	.
	.s ScgGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s ScgType=$p(ScgGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s Scg=$p(ScgGrpInfo,"^",5)
	.q:("^"_UserCatGrpStr_"^")'[("^"_Scg_"^")
	.
	.s code=$p(^INCI(inci,1),"^",1)
	.s desc=$p(^INCI(inci,1),"^",2)
	.s pUom=$p(^INCI(inci,3),"^",6)
	.s stkUom=$p(^CT("UOM",pUom),"^",2)
	.s bUom=$p(^INCI(inci,1),"^",10)
	.s bUomDesc=$p(^CT("UOM",bUom),"^",2)
	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s pFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
	.s il=0
	.f  s il=$o(^INCI("IL_LOC",Loc,inci,il)) q:il=""  d
	..s incil=inci_"||"_il
	..s incilInfo=^INCI(inci,"IL",il)
	..
	..s logQty=$p(incilInfo,"^",3)
	..q:+logQty=0
	..s incsb=$p(incilInfo,"^",2)
	..s sbDesc=$s(incsb'="":$p($g(^INC("SB",incsb)),"^",2),1:"")
	..
	..s move=0
	..s cnt=$l(BusinessTypes,",")
	..f i=1:1:cnt q:move=1  d
	...s typeInfo=$p(BusinessTypes,",",i)
	...s type=$p(typeInfo,"$",1)
	...s limitNum=+$p(typeInfo,"$",2)
	...s move=..CheckMoveInfo(incil,StartDate,EndDate,type,limitNum)
	...q:move=1
	..q:move=1
	..
	..s LastImpDate=..LastImpDate(incil,EndDate)
	..s LastTrOutDate=..LastTrOutDate(incil,EndDate)
	..s LastTrInDate=..LastTrInDate(incil,EndDate)
	..s LastIpDate=..LastIpDate(incil,EndDate)
	..s LastOpDate=..LastOpDate(incil,EndDate)
	..s lb=0
	..f  s lb=$O(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	...s inclb=incil_"||"_lb
	...s stkQty=$P(^INCI(inci,"IL",il,"LB",lb),"^",2)
	...q:+stkQty=0   //滤除零库存的批次
	...s dirtyQty=$P(^INCI(inci,"IL",il,"LB",lb),"^",3)
	...s avaQty=stkQty-dirtyQty
	...s incib=$P(^INCI(inci,"IL",il,"LB",lb),"^",1)
	...s batNo=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)
	...s expDate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
	...i expDate'="" s expDate=..DL2H(expDate)
	...s vendor=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb,EndDate),"^",2)
	...s manf=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,+$h,pUom,HospID)
	...s stkQty=stkQty/pFac
	...s avaQty=avaQty/pFac
	...
	...s count=count+1
	...q:count<(Start+1)||(count>end)
	...s Data1=inclb_"^"_code_"^"_desc_"^"_spec_"^"_manf_"^"_batNo_"^"_expDate_"^"_vendor_"^"_stkUom_"^"_stkQty
	...s Data2=avaQty_"^"_sp_"^"_sbDesc_"^"_LastImpDate_"^"_LastTrOutDate_"^"_LastTrInDate_"^"_LastIpDate_"^"_LastOpDate
	...s DataStr=Data1_"^"_Data2
	...d json.InsertRowData(DataStr)
	s TitleStr="inclb^InciCode^InciDesc^Spec^manf^batNo^expDate^vendor^stkUom^stkQty:number"
		_"^avaQty:number^sp:number^sbDesc^LastImpDate^LastTrOutDate^LastTrInDate^LastIpDate^LastOpDate"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// 查询某科室一段日期范围内的业务呆滞情况
/// 
/// Author:zhwh
/// Date:2012-07-30
/// Argu:
///  Loc - 科室RowId
///  StartDate -业务起始日期
///  EndDate - -业务截止日期
///  BusinessTypes - 业务类型与呆滞参照数("T$100,P$200")
/// 
Query LocItmSluggishGoods(Params As %String, BusinessTypes As %String) As Query(ROWSPEC = "inclb,InciCode,InciDesc,Spec,manf,batNo,expDate,vendor,stkUom,stkQty:%Float,avaQty:%Float,sp:%Float,sbDesc,LastImpDate,LastTrOutDate,LastTrInDate,LastIpDate,LastOpDate")
{
}

ClassMethod LocItmSluggishGoodsExecute(ByRef qHandle As %Binary, Params As %String, BusinessTypes As %String) As %Status
{
	n (qHandle,Params,BusinessTypes)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s UserId=PJObj.%Get("UserId")
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s HospID=$p(^CTLOC(Loc),"^",22)
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s UserCatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),Loc,"",HospID)

	s inci=0
	f  s inci=$o(^INCI("IL_LOC",Loc,inci)) q:inci=""  d
	.s NotUseFlag=$p(^INCI(inci,2),"^",9)
	.q:NotUseFlag="Y"
	.
	.s ScgGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s ScgType=$p(ScgGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s Scg=$p(ScgGrpInfo,"^",5)
	.q:("^"_UserCatGrpStr_"^")'[("^"_Scg_"^")
	.
	.s code=$p(^INCI(inci,1),"^",1)
	.s desc=$p(^INCI(inci,1),"^",2)
	.s pUom=$p(^INCI(inci,3),"^",6)
	.s stkUom=$p(^CT("UOM",pUom),"^",2)
	.s bUom=$p(^INCI(inci,1),"^",10)
	.s bUomDesc=$p(^CT("UOM",bUom),"^",2)
	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	.s pFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
	.s il=0
	.f  s il=$o(^INCI("IL_LOC",Loc,inci,il)) q:il=""  d
	..s incil=inci_"||"_il
	..s incilInfo=^INCI(inci,"IL",il)
	..
	..s logQty=$p(incilInfo,"^",3)
	..q:+logQty=0
	..s incsb=$p(incilInfo,"^",2)
	..s sbDesc=$s(incsb'="":$p($g(^INC("SB",incsb)),"^",2),1:"")
	..
	..s move=0
	..s cnt=$l(BusinessTypes,",")
	..f i=1:1:cnt q:move=1  d
	...s typeInfo=$p(BusinessTypes,",",i)
	...s type=$p(typeInfo,"$",1)
	...s limitNum=+$p(typeInfo,"$",2)
	...s move=..CheckMoveInfo(incil,StartDate,EndDate,type,limitNum)
	...q:move=1
	..q:move=1
	..
	..s LastImpDate=..LastImpDate(incil,EndDate)
	..s LastTrOutDate=..LastTrOutDate(incil,EndDate)
	..s LastTrInDate=..LastTrInDate(incil,EndDate)
	..s LastIpDate=..LastIpDate(incil,EndDate)
	..s LastOpDate=..LastOpDate(incil,EndDate)
	..s lb=0
	..f  s lb=$O(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	...s inclb=incil_"||"_lb
	...s stkQty=$P(^INCI(inci,"IL",il,"LB",lb),"^",2)
	...q:+stkQty=0   //滤除零库存的批次
	...s dirtyQty=$P(^INCI(inci,"IL",il,"LB",lb),"^",3)
	...s avaQty=stkQty-dirtyQty
	...s incib=$P(^INCI(inci,"IL",il,"LB",lb),"^",1)
	...s batNo=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)
	...s expDate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2)
	...i expDate'="" s expDate=..DL2H(expDate)
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb,EndDate)
	...s vendor=$p(VendorInfo,"^",2)
	...s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	...s manf=$P(ManfInfo,"^",2)
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,+$h,pUom,HospID)
	...s stkQty=stkQty/pFac
	...s avaQty=avaQty/pFac
	...d OutPutRow

	Quit $$$OK
OutPutRow
	s Data=$lb(inclb,code,desc,spec,manf,batNo,expDate,vendor,stkUom,stkQty,
		avaQty,sp,sbDesc,LastImpDate,LastTrOutDate,LastTrInDate,LastIpDate,LastOpDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 检查某科室库存项某段日期内的某业务是否呆滞
/// Author:
/// zhwh
/// Date:2012-07-30
/// Argu:
/// incil -科室库存rowid
/// sd - 起始日期
/// ed - 截止日期
/// type -业务类型代码
/// limitNum - 呆滞参照数（即业务发生数少于此数时可认定为呆滞）,此数值为按入库单位计的数量
/// Return: 0--呆滞, 1-非呆滞
ClassMethod CheckMoveInfo(incil As %String, sd As %String, ed As %String, type As %String, limitNum As %String) As %String
{
 n (incil,sd,ed,type,limitNum)
 s move=0
 s buom=$P($g(^INCI(+incil,1)),"^",10)
 //计算参考值
 //
 s pUom=$P($G(^INCI(+incil,3)),"^",6) i pUom="" s pUom=buom
 s pFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,buom)
 s limitNum=limitNum*pFac   //换算为基本单位的量
 
 s sumPY=0
 s sumFH=0
 s sumTrQty=0
 f dd=sd:1:ed q:move=1  d  
 .s intr=""
 .f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd,intr)) q:(intr="")!(move=1)  d
 ..s trQty=$p(^DHCINTR(intr),"^",6)
 ..s uom=$p(^DHCINTR(intr),"^",10)
 ..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
 ..s trQty=trQty*fac   //换算为基本单位
 ..//w trQty,!
 ..i (type["MP") ! (type["MY") d 
 ...s sumPY=sumPY+trQty
 ...i (+limitNum>0)&(-sumPY>+limitNum) s move=1 q
 ..e  i (type["MF") ! (type["MH") d
 ...s sumFH=sumFH+trQty
 ...i (+limitNum>0)&(-sumFH>+limitNum) s move=1 q
 ..e  d
 ...s:type="T" trQty=-trQty
 ...s sumTrQty=sumTrQty+trQty
 ...s:sumTrQty>=limitNum move=1
 ..q:move=1
 q move
}

/// 取某科室某日期前的最后入库日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的入库日期
ClassMethod LastImpDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"G",dd)
 i d>0 q ..DL2H(d)
 q ""
}

/// ;最后转移出库日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的转移出库日期
ClassMethod LastTrOutDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"T",dd)
 i d>0 q ..DL2H(d)
 q ""
}

/// ;最后转移入库日期
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的转移入库日期
ClassMethod LastTrInDate(incil As %String, dd As %String) As %String
{
 n (incil,dd)
 s d=..LastDate(incil,"K",dd)
 i d>0 q ..DL2H(d)
 q ""
}

/// ;最后住院发/退日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的住院发(退)药日期
ClassMethod LastIpDate(incil, dd)
{
  n (incil,dd)
  s d1=..LastDate(incil,"P",dd)
  s d2=..LastDate(incil,"Y",dd)
  s d=d2
  i +d1>+d2 s d=d1
     i d>0 q ..DL2H(d)
  q ""
}

/// ;最后门诊发/退日期 
/// Date:2012-07-30
/// Argu:
///  incil -科室库存rowid
///  dd - 日期(number)
/// Return:最后的门诊发(退)药日期
ClassMethod LastOpDate(incil, dd)
{
  n (incil,dd)
  s d1=..LastDate(incil,"MF",dd)
  s d2=..LastDate(incil,"MH",dd)
  s d3=..LastDate(incil,"S",dd)
  s d4=..LastDate(incil,"Z",dd)
  k ^TMP($j,"LASTOPDATEX")
  i d1>0 s ^TMP($j,"LASTOPDATEX",d1)=""
  i d2>0 s ^TMP($j,"LASTOPDATEX",d2)=""
  i d3>0 s ^TMP($j,"LASTOPDATEX",d3)=""
  i d4>0 s ^TMP($j,"LASTOPDATEX",d4)=""
  s d=$o(^TMP($j,"LASTOPDATEX",""),-1)
  k ^TMP($j,"LASTOPDATEX")
  i d>0 q ..DL2H(d)
  q ""
}

/// 取某科室﹜某库存项﹜某项业务的最后日期
/// Date:2012-07-30
/// Argu:
///   incil  -科室库存rowid
///   type  -业务类型代码
///   dd  - 截至日期
/// Return :
///   某项业务的最后日期
ClassMethod LastDate(incil As %String, type As %String, dd As %String) As %String
{
 n (incil,type,dd)
 i dd="" s dd=+$H
 q:incil="" ""
 q:type="" ""
 s lastdate=$o(^DHCINTR(0,"ILTYPEDATE",incil,type,dd),-1)  ;最后入库日期
 q +lastdate
}

}
