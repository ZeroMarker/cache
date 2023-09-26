Class web.DHCWLTJSXMTJQuery Extends %RegisteredObject
{

/// Creator：		CHENYI
/// CreatDate：		2018-07-10
/// Description：	项目统计明细
/// Table：			dhc_workload
/// Input：			
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLTJSXMTJQuery","QueryItmDetail","2022-10-01","2022-10-30","","N","YZX","","","")
Query QueryItmDetail(startDate As %String, endDate As %String, hosId As %String, isFlag As %String, itmtype As %String, admTypeId As %String, resDepId As %Text, recDepId As %Text) As %Query(ROWSPEC = "tarCode:%String,tarDesc:%String,patName:%String,regNo:%String,resDepDesc:%String,recDepDesc:%String,resDocDesc:%String,dateDesc:%String,arcimBig:%String,arcimSub:%String,qty:%Float,fee:%Float,uPrice:%Float") [ SqlProc ]
{
}

ClassMethod QueryItmDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, isFlag As %String, itmtype As %String, admTypeId As %String, resDepId As %Text, recDepId As %Text) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
	s ^TEMPDHCWL("cy")=startDate_","_endDate_","_hosId_","_isFlag_","_itmtype_","_admTypeId_","_resDepId_","_recDepId
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	k ^||TEMPDHCWL($j)
	//1.1-将开单科室id串转换成数组
	k resDepArr
	s num=$l($g(resDepId),",")
	i $g(resDepId)'="" d
	.f i=1:1:num d
	..s id=$p($g(resDepId),",",i)
	..s resDepArr(id)=""
	
	//1.2-将接收科室id串转换成数组
	k recDepArr
	s num=$l($g(recDepId),",")
	i $g(recDepId)'="" d
	.f i=1:1:num d
	..s id=$p($g(recDepId),",",i)
	..s recDepArr(id)=""
	
	//1.3-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	
	//1.4-将就诊类型id串转换成数组
	k admTypeArr
	s num=$l($g(admTypeId),",")
	i $g(admTypeId)'="" d
	.f i=1:1:num d
	..s id=$p($g(admTypeId),",",i)
	..s admTypeArr(id)=""
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d
	.s wlId=0
	.f  s wlId=$o(^DHCWorkLoad(0,"ORDDATE",date,wlId)) q:wlId=""  d
	..s admType=$p($G(^DHCWorkLoad(wlId)),"^",4)
	..q:('$d(admTypeArr(admType)))&&($g(admTypeId)'="")
	..s fee=$p(^DHCWorkLoad(wlId),"^",16)
	..s qty=$p(^DHCWorkLoad(wlId),"^",15)
	..s ordLoc=$p(^DHCWorkLoad(wlId),"^",23)      //医嘱科室
	..q:('$d(resDepArr(ordLoc)))&&($g(resDepId)'="")
	..s ihosDr=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(ordLoc)
	..q:('$d(hosArr(ihosDr)))&&($g(hosId)'="")
	..s recLoc=$p(^DHCWorkLoad(wlId),"^",1)      //执行科室
	..s:recLoc="" recLoc="999999"
	..q:('$d(recDepArr(recLoc)))&&($g(recDepId)'="")
	..s ordDoc=+$p(^DHCWorkLoad(wlId),"^",19)     //医嘱医生
	..s itemCat=$p(^DHCWorkLoad(wlId),"^",9)	//医嘱子类
	..q:$d(^ARC("IC",0,"OrderType","R",itemCat))  //医嘱子类  是药品的直接过滤掉
	..s itmMast=$p(^DHCWorkLoad(wlId),"^",2)	//医嘱项
	..s mflag="Y"
	..s tarDr=$p(^DHCWorkLoad(wlId),"^",22)
	..s papmi=$p(^DHCWorkLoad(wlId),"^",13)
	..s oeori=$p(^DHCWorkLoad(wlId),"^",21)
	..s uPrice=$p(^DHCWorkLoad(wlId),"^",14)
	..s nod1=tarDr_","_papmi_","_ordLoc_","_recLoc_","_ordDoc_","_itemCat_","_date_","_uPrice
	..s ^||TEMPDHCWL($j,"DATE","sfx",nod1,"sfxqty")=$g(^||TEMPDHCWL($j,"DATE","sfx",nod1,"sfxqty"))+qty
	..s ^||TEMPDHCWL($j,"DATE","sfx",nod1,"sfxfee")=$g(^||TEMPDHCWL($j,"DATE","sfx",nod1,"sfxfee"))+fee
	..
	..s pbId=$p(^DHCWorkLoad(wlId),"^",20)	//账单id	
	..s yzxPrice=$$GetOrderPrice^DHCWLCommon(pbId,itmMast,date,ihosDr,oeori)
	..s nod2=itmMast_","_papmi_","_ordLoc_","_recLoc_","_ordDoc_","_itemCat_","_date_","_yzxPrice
	..s ^||TEMPDHCWL($j,"DATE","yzx",nod2,"yzxfee")=$g(^||TEMPDHCWL($j,"DATE","yzx",nod2,"yzxfee"))+fee
	..
	..s ^||TEMPDHCWL($j,"TRANS",nod2,"yzxfee")=$g(^||TEMPDHCWL($j,"TRANS",nod2,"yzxfee"))+fee
	
	//trans
	s nod3=""
	f  s nod3=$o(^||TEMPDHCWL($j,"TRANS",nod3)) q:nod3=""  d
	.s fee=$g(^||TEMPDHCWL($j,"TRANS",nod3,"yzxfee"))
	.s uPrice=$p(nod3,",",8)
	.i +uPrice'=0 s yzxqty=$fn((fee/uPrice),"",2)
	.e  s yzxqty=0
	.s ^||TEMPDHCWL($j,"DATE","yzx",nod3,"yzxqty")=$g(^||TEMPDHCWL($j,"DATE","yzx",nod3,"yzxqty"))+yzxqty
	
	//output
	i itmtype="SFX" d
	.s nod="" f  s nod=$o(^||TEMPDHCWL($j,"DATE","sfx",nod)) q:nod=""  d
	..s tarDr=$p(nod,",",1)
	..s tarCode=$$GetTARICode^DHCWLBuildDimDataTARI(tarDr)
	..s tarDesc=$$GetTARIName^DHCWLBuildDimDataTARI(tarDr)
	..s args=tarDr_"~XMTJSFX"
	..s mflag="Y"
	..i isFlag="Y" s mflag=$$GetBSSubDesc^DHCWLBuildDimDataGetSubGrp(args)
	..q:$ZCVT(mflag,"U")="NULL"
   ..s papmi=$p(nod,",",2)
   ..s patName=$$GetPapmiName^DHCWLCommon(papmi)
   ..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)
   ..s itemCat=$p(nod,",",6)
   ..s arcimBigDr=$p(^ARC("IC",itemCat),"^",8) ;医嘱大类	;医嘱大类
   ..s arcimBig=$p(^OEC("ORCAT",arcimBigDr),"^",2)
   ..s arcimSub=$$GetARCICDesc^DHCWLBuildDimDataARCIC(itemCat)	;医嘱子类
   ..;s uomDesc=$$GetTARIUnit(tarDr)
   ..s ordLoc=$p(nod,",",3)
   ..s resDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ordLoc)
   ..s recLoc=$p(nod,",",4)
   ..s recDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(recLoc)
   ..s ordDoc=$p(nod,",",5)
   ..s resDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(ordDoc)
   ..s mDate=$p(nod,",",7)
   ..s dateDesc=$zd(mDate,3)
   ..s uPrice=$p(nod,",",8)
   ..s qty=$g(^||TEMPDHCWL($j,"DATE","sfx",nod,"sfxqty"))
   ..s fee=$g(^||TEMPDHCWL($j,"DATE","sfx",nod,"sfxfee"))
   ..d OutRow 
	e  d
	.s nod="" f  s nod=$o(^||TEMPDHCWL($j,"DATE","yzx",nod)) q:nod=""  d
	..s itmMast=$p(nod,",",1)
	..s tarCode=$$GetARCIMCode^DHCWLBuildDimDataARCIM(itmMast)
	..s tarDesc=$$GetARCIMName^DHCWLBuildDimDataARCIM(itmMast)
	..s args=itmMast_"~XMTJYZX"
	..s mflag="Y"
   ..i isFlag="Y" s mflag=$$GetBSSubDesc^DHCWLBuildDimDataGetSubGrp(args)
	..q:$ZCVT(mflag,"U")="NULL"
   ..s papmi=$p(nod,",",2)
   ..s patName=$$GetPapmiName^DHCWLCommon(papmi)
   ..s regNo=$$GetPapmiNo^DHCWLCommon(papmi)
   ..s itemCat=$p(nod,",",6)
   ..s arcimBigDr=$p(^ARC("IC",itemCat),"^",8) ;医嘱大类	;医嘱大类
   ..s arcimBig=$p(^OEC("ORCAT",arcimBigDr),"^",2)
   ..s arcimSub=$$GetARCICDesc^DHCWLBuildDimDataARCIC(itemCat)	;医嘱子类
   ..;s uomDesc=$$GetTARIUnit(tarDr)
   ..s ordLoc=$p(nod,",",3)
   ..s resDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(ordLoc)
   ..s recLoc=$p(nod,",",4)
   ..s recDepDesc=$$GetDepDesc^DHCWLBuildDimDataCTLOC(recLoc)
   ..s ordDoc=$p(nod,",",5)
   ..s resDocDesc=$$GetDocDesc^DHCWLBuildDimDataCTPCP(ordDoc)
   ..s mDate=$p(nod,",",7)
   ..s dateDesc=$zd(mDate,3)
   ..s uPrice=$p(nod,",",8)
   ..s qty=$g(^||TEMPDHCWL($j,"DATE","yzx",nod,"yzxqty"))
   ..s fee=$g(^||TEMPDHCWL($j,"DATE","yzx",nod,"yzxfee"))
   ..d OutRow 
   
	k ^||TEMPDHCWL($j)
 	Quit $$$OK

	
OutRow
	s Data=$lb(tarCode,tarDesc,patName,regNo,resDepDesc,recDepDesc,resDocDesc,dateDesc,arcimBig,arcimSub,qty,fee,uPrice)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
 	;根据就诊号，和时间，取出该时间病人所在病区^科室  数据来自转科表 add by chenyi.2014-3-20
	;input:时间date，paadm号
	;output:病区^科室：currwarddr_"^"_currlocdr
	;d $$selectlocwarddate^^DHCMRIPLoad(63006,310194)
SelectLocWardDate(date,admid)    ;根据就诊号，和时间，取出该时间病人所在病区^科室 add by chenyi.2014-3-20
	
	s currlocdr=""
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:transsub=""  d    //!(flag=2)
	.s locdr=$p(^PAADM(admid,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admid,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admid,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $G(mTransSDate)'>$G(date) d  ;转科时间小于或等于 当时时间
	..s currlocdr=locdr
	q currlocdr
	///desc:	根据就诊号取病人的诊断信息：第一条诊断
	///output:	入院诊断^出院诊断^其他诊断
	///creator:	chenyi
	///date:	2014-3-28
	///w $$GetFirstDiagByAdmDr^DHCWLCommon(adm)		 
GetFirstDiagByAdmDr(admDr) 
	;n (admDr)
	s diag=""
	s mrAdm=$P(^PAADM(admDr),"^",61)   
	s mMRDiagnosRowId=0
	f  s mMRDiagnosRowId=$o(^MR(mrAdm,"DIA",mMRDiagnosRowId)) q:(mMRDiagnosRowId="")||($g(diag)'="")  d 	;遍历诊断子表rowid
	.s diag1=$g(^MR(mrAdm,"DIA",mMRDiagnosRowId,"DES",1))
	.i diag1'="" s diag=diag1
	.s mIDCDodeDr=$p(^MR(mrAdm,"DIA",mMRDiagnosRowId),"^",1)
	.q:$g(mIDCDodeDr)=""
	.s mMRCIDDesc=$p(^MRC("ID",mIDCDodeDr),"^",2)
	.i $g(mMRCIDDesc)'="" s diag=mMRCIDDesc

	q $g(diag)
	
GetTARIUnit(mTarItemDr)
	s unitDesc=""
 	q:$g(mTarItemDr)="" "Null"
 	s tariUom=$p($G(^DHCTARI(mTarItemDr)),"^",3)
 	i tariUom="" s unitDesc=""
 	e  d
 	.s unitDesc=$P(^CT("UOM",tariUom),"^",2)
    q unitDesc
}

ClassMethod QueryItmDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItmDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryItmDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItmDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
