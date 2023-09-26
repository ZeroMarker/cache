Import sqluser

Class CHSSWeb.DrugStorage.PhaInfoCommon Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// 根据库存项代码或RowID取得规格
ClassMethod GetSpec(incicode, inci) As %Library.String
{
	;根据库存项代码取得规格 -07-11-02
	;incicode : 代码
	;inci : rowid of INC_Itm
	;"inci"为空时根据"incicode"取，否则使用"inci"
	n (incicode,inci)
	k P9
	i $g(inci)="" d
	.;q:incicode="" ""
	.s inci=..ItemCodeToID(incicode)
	q:$g(inci)="" ""
	s spec=""
	//s spec=$p(^INCI(inci,3),"^",9)
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec    
	
	//s incicode=$g(incicode)
	//以下是旧版使用的"规格"
	//&sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_officialcode
	//       into :spec
	//      from inc_itm
	//     where inci_code=:incicode)
	s P9=spec  
	q P9
}

ClassMethod ItemCodeToID(incicode)
{
 
 n QQ
 &sql(SELECT INCI_ROWID INTO :QQ FROM INC_ITM WHERE INCI_CODE=:incicode)
 q $g(QQ)
}

/// Descript:	根据库存项的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
ClassMethod GetManf(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S ManfStr=..GetManfByPhcd(Phcd)
 Q ManfStr
}

/// Descript:	根据PHC_DrgMast的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
ClassMethod GetManfByPhcd(PhcdDr)
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S ManfDr=$P(^PHCD(PhcdDr,2),"^",4)
 Q:ManfDr="" ""
 Q:'$D(^PHMNF(ManfDr)) ""
 S ManfCode=$P(^PHMNF(ManfDr),"^",1)
 S ManfName=$P(^PHMNF(ManfDr),"^",2)
 Q ManfDr_"^"_ManfCode_"^"_ManfName
}

/// Descript:	根据库存项ID取入库单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	入库单位ID^入库单位描述
ClassMethod GetIncPuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S puomdr=$P(^INCI(InciDr,3),"^",6)
 Q:puomdr="" ""
 Q:'$D(^CT("UOM",puomdr)) ""
 S puomdesc=$P(^CT("UOM",puomdr),"^",2)
 Q puomdr_"^"_puomdesc
}

/// Descript:	根据库存项ID、入库单位及院区取得入库单位进价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid, uom, HospID
/// Output:		Return
/// Return：	入库单位进价
ClassMethod GetInciLRp(inci, uom, HospID = "")
{
 n (inci,uom,HospID)
 q:inci="" 0
 i ..ChkRIngr(inci)=1 s lrp=..GetItmManPrice(inci,uom,HospID)	;制剂取进价
 s ingr="",rp=0
 f  s ingr=$o(^DHCINGR(0,"INCI",inci,ingr),-1) q:(ingr="")!(rp'=0)  d
 .q:($d(^DHCINGR(ingr))=0)!(($d(^DHCINGR(ingr))=10))
 .q:$p(^DHCINGR(ingr),"^",8)=""	//未审核
 .S LocHospID=..GetHospIDByIngr(ingr)
 .Q:(HospID'="")&(HospID'=LocHospID)
 .s ingrsub=$o(^DHCINGR(0,"INCI",inci,ingr,""),-1) q:ingrsub=""
 .q:($d(^DHCINGR(ingr,"GRI",ingrsub))=0)!(($d(^DHCINGR(ingr,"GRI",ingrsub))=10))
 .s recuom=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",10)
 .s rp=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",30)
 .s buom=$p(^INCI(inci,1),"^",10)
 .i uom="" s uom=buom
 .Q:uom=recuom
 .s fac1=..UOMFac(uom,buom)
 .s fac2=..UOMFac(recuom,buom)
 .s rp=rp/fac2*fac1
 q rp
}

ClassMethod ChkRIngr(inci)
{
 q:inci="" 0
 s recsub=""
 s recsub=$o(^INCI(inci,"REC","0"))
 q:(recsub=0)!(recsub="") 0
 q 1
}

ClassMethod GetItmManPrice(inci, uomdr, HospID = "")
{
 n (inci,uomdr,HospID)
 q:inci="" ""
 s manid="",rp=0
 F  s manid=$o(^DHCINMAN(0,"INCI",inci,manid),-1) Q:(manid="")!(rp'=0)  D
 .q:manid=""
 .q:'$d(^DHCINMAN(manid))
 .S locdr=$P(^DHCINMAN(manid),"^",3)
 .S LocHospID=$P(^CTLOC(locdr),"^",22)
 .Q:(HospID'="")&(LocHospID'=HospID)
 .s rp=+$p(^DHCINMAN(manid),"^",11)
 .S muomdr=$p(^DHCINMAN(manid),"^",8)
 .S buomdr=$P(^INCI(inci,1),"^",10)
 .I uomdr="" S uomdr=buomdr
 .Q:muomdr=uomdr
 .s fac1=..UOMFac(uomdr,buomdr)
 .s fac2=..UOMFac(muomdr,buomdr)
 .s rp=rp/fac2*fac1
 q rp
}

ClassMethod GetHospIDByIngr(ingr)
{
 N (ingr)
 Q:ingr="" ""
 Q:'$D(^DHCINGR(ingr)) ""
 S locdr=$P(^DHCINGR(ingr),"^",13)
 Q:locdr="" ""
 Q:'$D(^CTLOC(locdr)) ""
 S HospID=$P(^CTLOC(locdr),"^",22)
 Q HospID
}

/// Descript:	根据两个传入单位取得转换率
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		fr, to
/// Output:		Return
/// Return：	转换率
ClassMethod UOMFac(fr, to)
{
 n (fr,to)
 q:fr=to 1    ;if from-uom is as same as to-uom then return 1
 s rowid=""
 s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 i rowid'="" d       
 .s fac=$p(^CT("CTCF",rowid),"^",3)
 .s fac=$p(fac,$c(1))
 e  d
 .s fac=1
 q $g(fac)
}

/// Descript:	根据库存项ID、开始时间、入库单位及院区取得入库单位售价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	入库单位售价
ClassMethod GetPriceElse(inciid, stdate, uom, HospID = "")
{
  n (inciid,stdate,uom,HospID)
  Q:inciid="" 0
  Q:'$D(^INCI(inciid)) 0
  s price=0
  S adjrow="",excudate=stdate+1
  I HospID="" D
  .s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
  .Q:excudate=""
  .s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
  E  D
  .s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
  .Q:excudate=""
  .s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
  Q:adjrow="" 0
  s price=+$p(^INASP(adjrow),"^",7)
  s adjuom=$p(^INASP(adjrow),"^",10)
  s ctuomprice=+$p(^INASP(adjrow),"^",11)
  s buom=$p(^INCI(inciid,1),"^",10) ;base uom
  i uom="" s uom=buom ;base uom
  i uom=adjuom  d
  .s price=ctuomprice
  e  d
  .s factor=..UOMFac(uom,buom)
  .s price=price*factor
  s price=+$j($g(price),7,6)
  q price
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S buomdr=$P(^INCI(InciDr,1),"^",10)
 Q:buomdr="" ""
 Q:'$D(^CT("UOM",buomdr)) ""
 S buomdesc=$P(^CT("UOM",buomdr),"^",2)
 Q buomdr_"^"_buomdesc
}

/// Descript:	根据库存项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuomByInc(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=..GetArcim(InciDr)
 Q ..GetArcBuom(ArcimDr)
}

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid 
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S ArcimDr=$P(^INCI(InciDr,1),"^",3)
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuom(ArcimDr)
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S BillUomDr=$P(^ARCIM(Arcsub,Arcver,8),"^",14)
 Q:BillUomDr="" ""
 Q:'$D(^CT("UOM",BillUomDr)) ""
 S BillUomDesc=$P(^CT("UOM",BillUomDr),"^",2)
 Q BillUomDr_"^"_BillUomDesc
}

/// Descript:	根据库存项ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项ID
/// Output:		Return
/// Return：	剂型代码^描述
ClassMethod GetForm(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S FormStr=..GetFormByPhcdf(Phcdf)
 Q FormStr
}

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr)
{
 N (InciDr)
 S ArcimDr=..GetArcim(InciDr)
 Q:ArcimDr="" ""
 S Phcdf=..GetPhcdfByArcim(ArcimDr)
 Q Phcdf
}

/// Descript:	根据PHC_DrgForm的ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Output:		Return
/// Return：	剂型代码^描述
ClassMethod GetFormByPhcdf(PhcdfDr)
{
 N (PhcdfDr)
 Q:PhcdfDr="" ""
 S Phcd=$P(PhcdfDr,"||",1)
 S DfSub=$P(PhcdfDr,"||",2)
 Q:Phcd="" ""
 Q:DfSub="" ""
 Q:'$D(^PHCD(Phcd,"DF",DfSub)) ""
 S PhcfDr=$P(^PHCD(Phcd,"DF",DfSub,1),"^",1)
 Q:PhcfDr="" ""
 Q:'$D(^PHCF(PhcfDr)) ""
 S PhcfCode=$P(^PHCF(PhcfDr),"^",1)
 S PhcfDesc=$P(^PHCF(PhcfDr),"^",2)
 Q PhcfCode_"^"_PhcfDesc
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr)
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
 Q Phcdf
}

/// Descript:	根据库存项的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodName(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S GoodName=..GetGoodNameByPhcd(Phcd)
 Q GoodName
}

/// Descript:	根据PHC_DrgMast的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodNameByPhcd(PhcdDr)
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S GoodName=$P(^PHCD(PhcdDr,2),"^",7)
 Q GoodName
}

/// Descript:	根据库存项的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	通用名代码^通用名描述
ClassMethod GetGene(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S GeneStr=..GetGeneByPhcd(Phcd)
 Q GeneStr
}

/// Descript:	根据PHC_DrgMast的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	通用名
ClassMethod GetGeneByPhcd(PhcdDr)
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S GeneDr=$P(^PHCD(PhcdDr,4),"^",1)
 Q:GeneDr="" ""
 Q:'$D(^PHCGE("GE",GeneDr)) ""
 S GeneCode=$P(^PHCGE("GE",GeneDr),"^",1)
 S GeneName=$P(^PHCGE("GE",GeneDr),"^",2)
 Q GeneCode_"^"_GeneName
}

/// Descript:	根据库存项的ID、药房及开始时间取基本单位数量
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		inci,loc,dd
/// Output:		Return
/// Return：	基本单位数量
ClassMethod IL(inci, loc, dd)
{
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

}
