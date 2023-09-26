Class DHCDoc.Interface.Inside.IOT.InMedicalOrder Extends %RegisteredObject
{

/// date:2019-09-09
/// desc:互联互通共享文档【1.6住院药品医嘱主信息表(DHCENSCDA.User.Order.InMedicalOrder)】
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.InMedicalOrder","GetInMedicalOrder","2019-09-10","2019-09-10","")
ClassMethod GetInMedicalOrderExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Hospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set qHandle = $lb(0,repid,0)
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s (HDSD0004027,HDSD0004026,HDSD00040271,HDSD00040261,HDSD0004024,HDSD0004025,HDSD0004022,HDSD00040221,HDSD0004023,HDSD0004021,HDSD0004028,HDSD0002021,HDSD0002051,HDSD0002062,HDSD00020621,AdmID,OrderSn,HDSD0015004)=""
	for Date=StartDate:1:EndDate {
		s orderParref=""
		for {
			s orderParref=$O(^OEORDi(0,"StDt",Date,orderParref))
			q:orderParref=""
			s AdmID=$P(^OEORD(orderParref),"^",1)
			s PAADMType=$p($g(^PAADM(AdmID)),"^",2)
			continue:(PAADMType'="I")
			s orderId = 0 
			for{
				s orderId = $O(^OEORDi(0,"StDt",Date,orderParref,orderId))
				q:orderId=""
				s OEORIRowID=orderParref_"||"_orderId
				s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID,0)
				s ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
				continue:(ARCIMRowId="") 
				s ArcItmObj=##class(User.ARCItmMast).%OpenId(ARCIMRowId,0)
				s ARCIMCode=ArcItmObj.ARCIMCode
				s ARCIMDesc=ArcItmObj.ARCIMDesc
				do ArcItmObj.%Close()
				s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID,0)
				s OEORIInstrDR=OrdObj.OEORIInstrDR
				if $ISOBJECT(OEORIInstrDR){
					s OEORIInstrDR=OrdObj.OEORIInstrDR.%Id()
					s InstrObj=##class(User.PHCInstruc).%OpenId(OEORIInstrDR,0)
					if $ISOBJECT(InstrObj) {
					   s HDSD0004027=InstrObj.PHCINCode  //药物使用途径代码
					   s HDSD00040271 =InstrObj.PHCINDesc1  //药物使用途径描述
					   do InstrObj.%Close()
					}
				}
				s OEORIPHFreqDR=OrdObj.OEORIPHFreqDR
				if $ISOBJECT(OEORIPHFreqDR){
					s OEORIPHFreqDR=OrdObj.OEORIPHFreqDR.%Id()
					s FreqObj=##class(User.PHCFreq).%OpenId(OEORIPHFreqDR,0)
					if $ISOBJECT(FreqObj) {
					   s HDSD0004026=FreqObj.PHCFRCode   //药物使用频次代码
					   s HDSD00040261=FreqObj.PHCFRDesc1  //药物使用频次描述
					   do FreqObj.%Close()
					}
				}
				s HDSD0004024=OrdObj.OEORIDoseQty ///药物使用次剂量
				s OEORIUnitDR=OrdObj.OEORIUnitDR
				if $ISOBJECT(OEORIUnitDR){
					s OEORIUnitDR=OrdObj.OEORIUnitDR.%Id()
					s UnitObj=##class(User.CTUOM).%OpenId(OEORIUnitDR,0)
					if $ISOBJECT(UnitObj) {
					   s OEORIUnitCode=UnitObj.CTUOMCode 
					   s HDSD0004025=UnitObj.CTUOMDesc //药物使用剂量单位
					   do UnitObj.%Close()
					}
				}
				s HDSD0004022=""
				s HDSD00040221=""
				s HDSD0004021=""
				s inci=$O(^INCI(0,"ARCIM_DR",$P(ARCIMRowId,"||",1),""))
				if (inci'=""){
					S Phcdf=$P(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1),"^",12)
					if (Phcdf'=""){
						 S Phcd=$P(Phcdf,"||",1)
						 S DfSub=$P(Phcdf,"||",2)
						 if ($D(^PHCD(Phcd,"DF",DfSub)) ){
							 S PhcfDr=$P(^PHCD(Phcd,"DF",DfSub,1),"^",1)
							 if (PhcfDr'=""){
							 S HDSD0004022=$P(^PHCF(PhcfDr),"^",1) ///药物剂型代码	
							 S HDSD00040221=$P(^PHCF(PhcfDr),"^",2) ///药物剂型描述	
							 }
						 }
					}
					s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
					if (add'=""){
					s HDSD0004021=$p($G(^DHCITMINFO(add)),"^",27) //药物规格
					}
				}
				s ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
				s ArcItmObj=##class(User.ARCItmMast).%OpenId(ARCIMRowId,0)
				s HDSD0004023=ArcItmObj.ARCIMDesc  ///药物名称	HDSD0004023
				s HDSD0004028=OrdObj.OEORIPhQtyOrd //药物使用总剂量
				///药物用法	HDSD0002021
				s HDSD0002021=HDSD00040271
				///药物不良反应情况	HDSD0002051
				s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(orderParref,orderId)
				if (SkinAbnorm="Y"){
					s HDSD0002051="Y"
				}else{
					s HDSD0002051="N"
				}
				///中药使用类别代码	HDSD0002062
				///中药使用类别描述	HDSD00020621
				s AdmID=$P(^OEORD(orderParref),"^",1) ///就诊ID号	AdmID
				s OrderSn=OEORIRowID ///医嘱号
				s HDSD0015004=OrdObj.OEORIPrescNo ///处方药品组号（医嘱序号）
				d OutputRow1
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(HDSD0004027,HDSD0004026,HDSD00040271,HDSD00040261,HDSD0004024,HDSD0004025,HDSD0004022,HDSD00040221,HDSD0004023,HDSD0004021,HDSD0004028,HDSD0002021,HDSD0002051,HDSD0002062,HDSD00020621,AdmID,OrderSn,HDSD0015004)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetInMedicalOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInMedicalOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
       Set AtEnd=1
	   Set Row=""
    }Else{Set Row=^CacheTemp(repid,ind)}
    s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInMedicalOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInMedicalOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetInMedicalOrder(StartDate As %String, EndDate As %String, Hospital As %String) As %Query(ROWSPEC = "HDSD0004027,HDSD0004026,HDSD00040271,HDSD00040261,HDSD0004024,HDSD0004025,HDSD0004022,HDSD00040221,HDSD0004023,HDSD0004021,HDSD0004028,HDSD0002021,HDSD0002051,HDSD0002062,HDSD00020621,AdmID,OrderSn,HDSD0015004")
{
}

}
