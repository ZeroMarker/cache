Class web.DHCFHQ.Arcim.ArcimB Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetArcimPrice(arcimdr, pattype)
{
 S del="^",ErrFlag="False"
 if $g(pattype)="" s pattype=""
 s taridr="",tarprice=0,ordprice=0
 if pattype="" s pattype=$o(^PAC("ADMREA",0))
 f  s taridr=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr)) q:taridr=""  d
 .s startdate=""
 .f  s startdate=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr,startdate)) q:startdate=""  d
 ..q:startdate>+$h
 ..s oltrid=""
 ..f  s oltrid=$o(^DHCOLT(0,"ARTTA",arcimdr,taridr,startdate,oltrid)) q:oltrid=""  d
 ...s enddate=$p(^DHCOLT(oltrid),del,5)
 ...q:((enddate'="") & (enddate<+$h))
 ...S qty=$p(^DHCOLT(oltrid),del,3)
 ...if $g(qty)="" s qty=1
 ...s tarprice=##class(web.DHCFHQ.DHCFBTARI).GetTarPrice(taridr,pattype)
 ...q:$p(tarprice,del,1)=ErrFlag
 ...s tarprice=$p(tarprice,del,1) * qty
 ...s ordprice=ordprice+tarprice
 q $fn(ordprice,"",2)
}

ClassMethod GetArcimByAlia(repid As %Integer, ArcAlia As %String) As %Integer
{
	S RetNum=1
	s del="^"
 S ArcAlia=$$ALPHAUP^SSUTIL4(ArcAlia),aliaval=ArcAlia
 s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" "),-1)
 f  s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" ")) q:(ArcAlia="")!(ArcAlia'[aliaval)  d
 .S desc=""
 .f  s desc=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc)) q:desc=""  d
 ..s aliaid=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc,""))
 ..s ArcId=$p(^ARC("ALIAS",aliaid),del,1)
 ..Q:($g(ArcId)="")
 ..s ArcId1=$p(ArcId,"||",1),ArcId2=$p(ArcId,"||",2)
 ..q:'$d(^ARCIM(ArcId1,ArcId2))
 ..s ArcInfo=##class(web.DHCFHQ.Arcim.ArcimB).GetArcimById(ArcId)
 ..q:ArcInfo=""
	 ..s ArcCode=$p(ArcInfo,del,2)
	 ..s ArcDesc=$p(ArcInfo,del,3)
	 ..s SubCat=$p(ArcInfo,del,4)
	 ..s drug=$p(ArcInfo,del,5)
	 ..s startdate=$p(ArcInfo,del,6)
	 ..s enddate=$p(ArcInfo,del,7)
	 ..s Priority=$p(ArcInfo,del,8)
 ..s drug=$p(^ARCIM(ArcId1,ArcId2,1),del,12)
 ..i $g(drug)'="" d
 ...s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
 ..q:(($g(stopflag)'="")&(enddate<$zd($h,3)))
 ..s ^CacheTempFHQ(repid,RetNum)=ArcId_del_ArcDesc_del_ArcCode_del_SubCat_del_drug_del_startdate_del_enddate_del_Priority
 ..s RetNum=RetNum+1
 Q RetNum-1
}

ClassMethod GetArcimById(ArcimId As %String) As %String
{
	q:$g(ArcimId)="" ""
	s del="^"
	s ArcCode="",ArcDesc="",subcat="",drug="",startdate="",enddate="",Priority=""
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	q:'$d(^ARCIM(ArcimId1,ArcimId2))
	s Unit=""
 s ArcCode=$p(^ARCIM(ArcimId1,ArcimId2,1),del,1)
 s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
 s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 s:subcat'="" subcat=$p(^ARC("IC",subcat),del,2)
 s UnitDr=$p(^ARCIM(ArcimId1,ArcimId2,8),del,14)
 s:$g(UnitDr)'="" Unit=$p(^CT("UOM",UnitDr),del,2)
 s drug=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
 i $g(drug)'="" d
 .s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
 s startdate=$P($p(^ARCIM(ArcimId1,ArcimId2,1),del,13),"Z",1)
 if $g(startdate)'="" s startdate=$zd(startdate,3)
 s enddate=$p(^ARCIM(ArcimId1,ArcimId2,7),del,1)
 if $g(enddate)'="" s enddate=$zd(enddate,3)
 q:(($g(stopflag)'="")&(enddate<$zd($h,3)))
 s Priority=$p(^ARCIM(ArcimId1,ArcimId2,8),del,22)
 IF $G(Priority)'="" S Priority=$p(^OECPR(Priority),del,2)
 s RetStr=ArcimId_del_ArcCode_del_ArcDesc_del_subcat_del_drug_del_startdate_del_enddate_del_Priority_del_Unit
	q RetStr
}

//w ##class(web.DHCFHQ.Arcim.ArcimB).GetArcimDrugCon("11500||1")

/// 获取医嘱项单位与药品基本单位的转换系数
ClassMethod GetArcimDrugCon(ArcimId) As %String
{
	q:$g(ArcimId)="" ""
	s del="^",RetStr=0
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	q:((ArcimId1="")!('$d(^ARCIM(ArcimId1)))) "医嘱项目ID不存在"
	q:((ArcimId2="")!('$d(^ARCIM(ArcimId1,ArcimId2)))) "医嘱项目子ID不存在"
	s ArcSubCatId=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
	q:'$d(^ARC("IC",ArcSubCatId)) "医嘱子类不存在"
	s ArcSubCatType=$p(^ARC("IC",ArcSubCatId),del,7)
	s ArcimUomId=$p(^ARCIM(ArcimId1,ArcimId2,8),del,14)
	s ArcimUomDesc=$p(^CT("UOM",ArcimUomId),del,2)
	q:'$d(^CT("UOM",ArcimUomId)) ""
	if ArcSubCatType="R" d
	.s DrugFormId=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
	.s PhcDrgId=$p(DrugFormId,"||",1)
	.s PhcDrgFormId=$p(DrugFormId,"||",2)
	.s PhcUomId=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,2),del,4)
	.q:'$d(^CT("UOM",PhcUomId))
	.s PhcUomDesc=$p(^CT("UOM",PhcUomId),del,2)
	.s PhcUomBaseQty=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,2),del,5)
	.s CircleFlag=1
	.s ToUomId=0
	.f  s ToUomId=$o(^CT("CTCF",0,"UOM",ArcimUomId,ToUomId)) q:((ToUomId="")!(CircleFlag=0))  d
	..if ToUomId=PhcUomId  d
	...s CircleFlag=0
	...s ConFacId=$o(^CT("CTCF",0,"UOM",ArcimUomId,ToUomId,""))
	...s ConFac=$p(^CT("CTCF",ConFacId),del,3)
	...//        医嘱项单位　　医嘱项单位		转换系数	药品基本单位　药品基本单位
	...s RetStr=ArcimUomId_del_ArcimUomDesc_del_ConFac_del_PhcUomId_del_PhcUomDesc
	else  d
	.s RetStr=ArcimUomId_del_ArcimUomDesc_del_"1"_del_ArcimUomId_del_ArcimUomDesc
	q RetStr
}

//w ##class(web.DHCFHQ.Arcim.ArcimB).GetArcimDrugCon("11500||1")

/// 获取医嘱项单位与药品基本单位的转换系数
ClassMethod GetOrdDoseCon(ArcimId, DoseUomId) As %String
{
	q:$g(ArcimId)="" ""
	q:$g(DoseUomId)="" ""
	q:'$d(^CT("UOM",DoseUomId)) "单位ID不存在"
	s del="^",RetStr=0
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	q:((ArcimId1="")!('$d(^ARCIM(ArcimId1)))) "医嘱项目ID不存在"
	q:((ArcimId2="")!('$d(^ARCIM(ArcimId1,ArcimId2)))) "医嘱项目子ID不存在"
	s ArcSubCatId=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
	q:'$d(^ARC("IC",ArcSubCatId)) "医嘱子类不存在"
	s ArcSubCatType=$p(^ARC("IC",ArcSubCatId),del,7)
	if ArcSubCatType="R" d
	.s ArcimUomId=$p(^ARCIM(ArcimId1,ArcimId2,8),del,14)
	.s ArcimUomDesc=$p(^CT("UOM",ArcimUomId),del,2)
	.q:'$d(^CT("UOM",ArcimUomId))
	.s DrugFormId=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
	.s PhcDrgId=$p(DrugFormId,"||",1)
	.s PhcDrgFormId=$p(DrugFormId,"||",2)
	.s RetStr=##class(web.DHCFHQ.Arcim.ArcimB).DoseToBaseUnit(DrugFormId,DoseUomId)
	q RetStr
}

//w ##class(web.DHCFHQ.Arcim.ArcimB).DoseToBaseUnit("1||1","2")

/// 等效单位与基本单位转换系统
ClassMethod DoseToBaseUnit(FormId, DoseUomId) As %String
{
	q:$g(FormId)="" ""
	q:$g(DoseUomId)="" ""
	s RetStr=0,del="^"
	s PhcDrgId=$p(FormId,"||",1)
	s PhcDrgFormId=$p(FormId,"||",2)
	s PhcUomId=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,2),del,4)
	q:'$d(^CT("UOM",PhcUomId))
	s PhcUomDesc=$p(^CT("UOM",PhcUomId),del,2)
	s PhcUomBaseQty=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,2),del,5)
	if DoseUomId=PhcUomId d
	.s RetStr=1
	if RetStr=0 d
	.s EqId=""
	.s CircleFlag=1
	.f  s EqId=$o(^PHCD(PhcDrgId,"DF",PhcDrgFormId,"EQ",EqId)) q:((EqId="")!(CircleFlag=0))  d
	..s DoseEqUomId=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,"EQ",EqId),del,1)
	..if DoseUomId=DoseEqUomId d
	...//取等效量
	...s DoseEqCon=$p(^PHCD(PhcDrgId,"DF",PhcDrgFormId,"EQ",EqId),del,2)
	...s CircleFlag=0
	...s RetStr=DoseEqCon
	q RetStr
}

}
