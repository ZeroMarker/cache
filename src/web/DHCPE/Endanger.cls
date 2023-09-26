Class web.DHCPE.Endanger Extends %Persistent
{

ClassMethod UpdateEndangerType(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).UpdateEndangerType("","")
	if ID="" d
	.s obj=##class(User.DHCPEEndangerType).%New()
	e  d
	.s obj=##class(User.DHCPEEndangerType).%OpenId(ID)
	s obj.EDTCode=$P(InfoStr,"^",1)
	s obj.EDTDesc=$P(InfoStr,"^",2)
	s obj.EDTActive=$P(InfoStr,"^",3)
	s obj.EDTVIPLevel=$P(InfoStr,"^",4)
	s obj.EDTExpInfo=$P(InfoStr,"^",5)
	s obj.EDTRemark=$P(InfoStr,"^",6)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEndangerTypeInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s obj=##class(User.DHCPEEndangerType).%OpenId(ID)
	s Code=obj.EDTCode
	s Desc=obj.EDTDesc
	s ExpInfo=obj.EDTExpInfo
	s Remark=obj.EDTRemark
	s PEType=obj.EDTVIPLevel
	s Active=obj.EDTActive
	q Code_"^"_Desc_"^"_Active_"^"_PEType_"^"_ExpInfo_"^"_Remark
}

ClassMethod UpdateEndanger(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).UpdateEndanger("","")
	if ID="" d
	.s obj=##class(User.DHCPEEndanger).%New()
	e  d
	.s obj=##class(User.DHCPEEndanger).%OpenId(ID)
	s obj.EDCode=$P(InfoStr,"^",1)
	s obj.EDDesc=$P(InfoStr,"^",2)
	s obj.EDActive=$P(InfoStr,"^",3)
	d obj.EDEDTypeDRSetObjectId($P(InfoStr,"^",4))
	s obj.EDExpInfo=$P(InfoStr,"^",5)
	s obj.EDRemark=$P(InfoStr,"^",6)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEndangerInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEndanger).%OpenId(ID)
	s Code=obj.EDCode
	s Desc=obj.EDDesc
	s Active=obj.EDActive
	s ExpInfo=obj.EDExpInfo
	s Remark=obj.EDRemark
	s EDType=obj.EDEDTypeDRGetObjectId()
	q Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark_"^"_EDType
}

ClassMethod EDIllnessSave(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).EDIllnessSave("","")
	if ID="" d
	.s obj=##class(User.DHCPEEDIllness).%New()
	.d obj.EDIlParrefSetObjectId($P(InfoStr,"^",1))
	e  d
	.s obj=##class(User.DHCPEEDIllness).%OpenId(ID)
	d obj.EDIIllndessDRSetObjectId($P(InfoStr,"^",2))
	d obj.EDIOMETypeDRSetObjectId($P(InfoStr,"^",3))
	s obj.EDIActive=$P(InfoStr,"^",4)
	s obj.EDIExpInfo=$P(InfoStr,"^",5)
	s obj.EDIRemark=$P(InfoStr,"^",6)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod EDIllnessDelete(ID)
{
	;w ##class(web.DHCPE.Endanger).EDIllnessDelete("","")
	s obj=##class(User.DHCPEEDIllness).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEDIllnessInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	S IllndessDesc="",OMETypeDesc="",Active="",ExpInfo="",Remark=""
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDIllness).%OpenId(ID)
	s IllndessDR=obj.EDIIllndessDRGetObjectId()
	s:IllndessDR'="" IllndessDesc=$LG(^User.DHCPEOMEIllnessD(IllndessDR),3)
	;s IllndessDesc=obj.EDIIllndessDRGetObjectId()
	;s OMETypeDesc=obj.EDIOMETypeDRGetObjectId()
	s OMETypeDR=obj.EDIOMETypeDRGetObjectId()
	s:OMETypeDR'="" OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3)
	s Active=obj.EDIActive
	s ExpInfo=obj.EDIExpInfo
	s Remark=obj.EDIRemark
	q IllndessDesc_"^"_OMETypeDesc_"^"_Active_"^"_ExpInfo_"^"_Remark_"^"_IllndessDR_"^"_OMETypeDR
}

ClassMethod EDCheckCycleSave(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).EDCheckCycleSave("","")
	s ^tempdhcpe("EDCheckCycleSave")=$lb(ID, InfoStr)
	s Code=$P(InfoStr,"^",2)
	s Desc=$P(InfoStr,"^",3)
	s TypeDR=$P(InfoStr,"^",4)
	s Active=$P(InfoStr,"^",5)
	s ExpInfo=$P(InfoStr,"^",6)
	s Remark=$P(InfoStr,"^",7)
	s oldCode="",OldDesc=""
	if ID="" d
	.s obj=##class(User.DHCPEEDCheckCycle).%New()
	.d obj.EDCParrefSetObjectId($P(InfoStr,"^",1))
	e  d
	.s obj=##class(User.DHCPEEDCheckCycle).%OpenId(ID)
	.s oldCode=obj.EDCCode
	.s OldDesc=obj.EDCDesc
	
	q:(oldCode'=Code)&&($d(^User.DHCPEEDCheckCycleI("EDCCodeIndex"," "_Code))) "-1^代码重复"
	q:(OldDesc'=Desc)&&($d(^User.DHCPEEDCheckCycleI("EDCDescIndex"," "_Desc))) "-1^描述重复"
	s obj.EDCCode=Code
	s obj.EDCDesc=Desc
	d obj.EDCOMETypeDRSetObjectId(TypeDR)
	s obj.EDCActive=Active
	s obj.EDCExpInfo=ExpInfo
	s obj.EDCRemark=Remark
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc)) 
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod EDCheckCycleDelete(ID)
{
	;w ##class(web.DHCPE.Endanger).EDCheckCycleDelete("","")
	s obj=##class(User.DHCPEEDCheckCycle).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEDCheckCycleInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s OMETypeDesc="",Active="",ExpInfo="",Remark=""
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDCheckCycle).%OpenId(ID)
	s Code=obj.EDCCode
	s Desc=obj.EDCDesc
	s OMETypeDR=obj.EDCOMETypeDRGetObjectId()
	I OMETypeDR'="" S OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3)
	s Active=obj.EDCActive
	s ExpInfo=obj.EDCExpInfo
	s Remark=obj.EDCRemark
	q Code_"^"_Desc_"^"_OMETypeDesc_"^"_Active_"^"_ExpInfo_"^"_Remark_"^"_OMETypeDR
}

ClassMethod EDCheckCriteriaSave(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).EDCheckCriteriaSave("","")
	if ID="" d
	.s obj=##class(User.DHCPEEDCheckCriteria).%New()
	.d obj.EDCCParrefSetObjectId($P(InfoStr,"^",1))
	e  d
	.s obj=##class(User.DHCPEEDCheckCriteria).%OpenId(ID)
	s obj.EDCCCode=$P(InfoStr,"^",2)
	d obj.EDCCDCDRSetObjectId($P(InfoStr,"^",3))
	d obj.EDCCOMETypeDRSetObjectId($P(InfoStr,"^",4))
	s obj.EDCCActive=$P(InfoStr,"^",5)
	s obj.EDCCExpInfo=$P(InfoStr,"^",6)
	s obj.EDCCRemark=$P(InfoStr,"^",7)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod EDCheckCriteriaDelete(ID)
{
	;w ##class(web.DHCPE.Endanger).EDCheckCriteriaDelete("","")
	s obj=##class(User.DHCPEEDCheckCriteria).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEDCheckCriteriaInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s OMETypeDesc="",Active="",ExpInfo="",Remark=""
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDCheckCriteria).%OpenId(ID)
	s Code=obj.EDCCCode
	s DCDR=obj.EDCCDCDRGetObjectId()
	s Desc=$LG(^User.DHCPEDiagnosticCriteriaD(DCDR),3)
	s OMETypeDR=obj.EDCCOMETypeDRGetObjectId()
	I OMETypeDR'="" S OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3)
	s Active=obj.EDCCActive
	s ExpInfo=obj.EDCCExpInfo
	s Remark=obj.EDCCRemark
	q Code_"^"_DCDR_"^"_Desc_"^"_OMETypeDesc_"^"_Active_"^"_ExpInfo_"^"_Remark_"^"_OMETypeDR
}

/// 危害因素对应的诊断标准
Query SearchEDCheckCriteria(Parref As %Library.String = "") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDCDR:%String,TDiagnosticCriteria:%String,TOMEType:%String,TActive:%String,TExpInfo:%String,TRemark:%String,TOMETypeDR:%String")
{
}

ClassMethod SearchEDCheckCriteriaExecute(ByRef qHandle As %Binary, Parref As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEDCheckCriteria")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i Parref="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDCheckCriteriaChild",ID)) q:ID=""  d
 	.s Str=..GetOneEDCheckCriteriaInfo(Parref_"||"_ID)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(Parref_"||"_ID,$P(Str,"^",1),$P(Str,"^",2),$P(Str,"^",3),$P(Str,"^",4),$P(Str,"^",5),$P(Str,"^",6),$P(Str,"^",7),$P(Str,"^",8))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod EDItemSave(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).EDItemSave("","")
	if ID="" d
	.s obj=##class(User.DHCPEEDItem).%New()
	.d obj.EDIParrefSetObjectId($P(InfoStr,"^",1))
	e  d
	.s obj=##class(User.DHCPEEDItem).%OpenId(ID)
	s obj.EDIItemMastID=$P(InfoStr,"^",2)
	s obj.EDINeedFlag=$P(InfoStr,"^",3)
	d obj.EDIOMETypeDRSetObjectId($P(InfoStr,"^",4))
	s obj.EDISetsFlag=$P(InfoStr,"^",5)
	s obj.EDIActive=$P(InfoStr,"^",6)
	s obj.EDIExpInfo=$P(InfoStr,"^",7)
	s obj.EDIRemark=$P(InfoStr,"^",8)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod EDItemDelete(ID)
{
	;w ##class(web.DHCPE.Endanger).EDItemDelete("","")
	s obj=##class(User.DHCPEEDItem).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// w ##class(web.DHCPE.Endanger).GetOneEDItemInfo("1||1")
ClassMethod GetOneEDItemInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s EDIItemMast="",EDINeedFlag="",OMETypeDesc="",SetsFlag="",Active="",ExpInfo="",Remark="",EDIItemMastID=""
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDItem).%OpenId(ID)
	s EDIItemMastID=obj.EDIItemMastID
	s EDINeedFlag=obj.EDINeedFlag
	//s OMETypeDesc=obj.EDIOMETypeDRGetObjectId()
	s OMETypeDR=obj.EDIOMETypeDRGetObjectId()
	s:OMETypeDR'="" OMETypeDesc=$LG(^User.DHCPEOMETypeD(OMETypeDR),3)

	s SetsFlag=obj.EDISetsFlag
	i SetsFlag="Y" d
	.s EDIItemMast=$P(^ARCOS(+EDIItemMastID),"^",2)
	e  d
	.s EDIItemMast=##class(web.DHCPE.DHCPECommon).GetArcDesc(EDIItemMastID)
	s Active=obj.EDIActive
	s ExpInfo=obj.EDIExpInfo
	s Remark=obj.EDIRemark
	q EDIItemMast_"^"_EDINeedFlag_"^"_OMETypeDesc_"^"_SetsFlag_"^"_Active_"^"_ExpInfo_"^"_Remark_"^"_EDIItemMastID_"^"_ID_"^"_OMETypeDR
}

ClassMethod EDItemDetailSave(ID, InfoStr)
{
	;w ##class(web.DHCPE.Endanger).EDItemDetailSave("","")
	if ID="" d
	.s obj=##class(User.DHCPEEDItemDetail).%New()
	.d obj.EDDParrefSetObjectId($P(InfoStr,"^",1))
	e  d
	.s obj=##class(User.DHCPEEDItemDetail).%OpenId(ID)
	d obj.EDIDDetailDRSetObjectId($P(InfoStr,"^",2))
	s obj.EDIActive=$P(InfoStr,"^",3)
	s obj.EDIExpInfo=$P(InfoStr,"^",4)
	s obj.EDIRemark=$P(InfoStr,"^",5)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// / Description: 职业病判断是否重点检查细项
/// Debug: w ##class(web.DHCPE.Endanger).IsEDDetail(1208,"5002||1","1||31")
ClassMethod IsEDDetail(PAADM, ArcimID, ODID)
{
	s Ret=0
	
	q:(PAADM="")||(ODID="")||(ArcimID="") Ret
	
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" Ret
	s PIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
	
	s PIADMEx=$o(^User.DHCPEPreIADMExI("PreIADMID",PIADM,0))
	q:PIADMEx="" Ret
	s Endangers=$LG(^User.DHCPEPreIADMExD(PIADMEx),9) // 危害因素  $lb($lb($lb("1","2"),"3","1"),$lb($lb("42","43"),"2",""),$lb($lb("1"),"1",""))
	s OEMType=$LG(^User.DHCPEPreIADMExD(PIADMEx),3)
	s Length=$LL(Endangers)
	
	f i=1:1:Length  d
	.s EndangerList=$LG($LG(Endangers,i),1)
	.f m=1:1:$LL(EndangerList) d
	..s Endanger=$lg(EndangerList,m)
	..q:Endanger=""
	..s CurItemSub=""
	..s ItemSub=""
	..f  s ItemSub=$O(^User.DHCPEEDItemI("ItemIDIndex"," "_ArcimID,Endanger,ItemSub)) q:(ItemSub="")||(CurItemSub'="")  d
	...s CurOEMType=$LG($g(^User.DHCPEEndangerD(Endanger,"EDItemChild",ItemSub)),5)
	...q:CurOEMType'=OEMType
	...s CurItemSub=ItemSub
	..q:CurItemSub=""
	..s ItemDetailSub=$O(^User.DHCPEEDItemDetailI("DetailDRIndex",ODID,Endanger,CurItemSub,0))
	..q:ItemDetailSub=""
	..s ActiveFlag=$LG(^User.DHCPEEndangerD(Endanger,"EDItemChild",CurItemSub,"EDItemDetailChild",ItemDetailSub),3)
	..s:ActiveFlag="Y" Ret=1
	q Ret
}

/*
ClassMethod EDItemDetailDelete(ID)
{
	;w ##class(web.DHCPE.Endanger).EDItemDetailDelete("","")
	s obj=##class(User.DHCPEEDItemDetail).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetOneEDItemDetailInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDItemDetail).%OpenId(ID)
	s EDIDDetail=obj.EDIDDetailDR
	s Active=obj.EDIActive
	s ExpInfo=obj.EDIExpInfo
	s Remark=obj.EDIRemark
	q EDIDDetail_"^"_Active_"^"_ExpInfo_"^"_Remark
}
*/
/// 危害因素分类
Query SearchEndangerType() As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TVIPLevelDR:%String,TVIPLevel:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchEndangerTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEndangerType")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=""
 	f  s ID=$O(^User.DHCPEEndangerTypeD(ID)) q:ID=""  d
 	.;d Clear
 	.s TCode=$LG(^User.DHCPEEndangerTypeD(ID),2)
	.s TDesc=$LG(^User.DHCPEEndangerTypeD(ID),3)
	.s TActive=$LG(^User.DHCPEEndangerTypeD(ID),4)
	.i TActive="Y" S TActive="是"
	.e  S TActive="否"
	.s TVIPLevelDR=$LG(^User.DHCPEEndangerTypeD(ID),5)
	.;s:TVIPLevelDR'="" TVIPLevel=$P($G(^DHCPEVIPLevel("VIP",TVIPLevelDR)),"^",2)
	.s:TVIPLevelDR'="" TVIPLevel=$lg($g(^CT.PE.VIPLevelD(TVIPLevelDR)),3)  //多院区改造 
	.s TExpInfo=$LG(^User.DHCPEEndangerTypeD(ID),6)
	.s TRemark=$LG(^User.DHCPEEndangerTypeD(ID),7)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Clear
	s (TCode,TDesc,TActive,TVIPLevelDR,TVIPLevel,TExpInfo,TRemark)=""
	q 
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,TVIPLevelDR,TVIPLevel,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEndangerTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEndangerTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEndangerTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEndangerTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 危害因素
Query SearchEndanger(EDEDTypeDR As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchEndangerExecute(ByRef qHandle As %Binary, EDEDTypeDR As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEndanger")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerI("EDTypeIndex",EDEDTypeDR,ID)) q:ID=""  d
 	.;d Clear
 	.s TCode=$LG(^User.DHCPEEndangerD(ID),2)
	.s TDesc=$LG(^User.DHCPEEndangerD(ID),3)
	.s TActive=$LG(^User.DHCPEEndangerD(ID),4)
	.i TActive="Y" S TActive="是"
	.E  S TActive="否"
	.s TExpInfo=$LG(^User.DHCPEEndangerD(ID),6)
	.s TRemark=$LG(^User.DHCPEEndangerD(ID),7)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Clear
	s (TCode,TDesc,TActive,TExpInfo,TRemark)=""
	q 
FindBuild      
	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEndangerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEndangerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEndangerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEndangerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 危害因素对应的目标疾病
Query SearchEDIllness(Parref As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TIllnessDesc:%String,TOMEType:%String,TActive:%String,TExpInfo:%String,TRemark:%String,TOMETypeDR:%String,TIllnessDR:%String")
{
}

ClassMethod SearchEDIllnessExecute(ByRef qHandle As %Binary, Parref As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEDIllness","14")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Parref=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDIllnessChild",ID)) q:ID=""  d
 	.s Str=..GetOneIllnessInfo(Parref_"||"_ID)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(Parref_"||"_ID,$P(Str,"^",1),$P(Str,"^",2),$P(Str,"^",3),$P(Str,"^",4),$P(Str,"^",5),$P(Str,"^",6),$P(Str,"^",7))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEDIllnessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEDIllnessExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEDIllnessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEDIllnessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneIllnessInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s TOMEType="",Illndess=""
	s obj=##class(User.DHCPEEDIllness).%OpenId(ID)
	s IllndessDR=obj.EDIIllndessDRGetObjectId()
	s:IllndessDR'="" Illndess=$LG(^User.DHCPEOMEIllnessD(IllndessDR),3)
 	s TOMETypeDR=obj.EDIOMETypeDRGetObjectId()
 	s:TOMETypeDR'="" TOMEType=$LG(^User.DHCPEOMETypeD(TOMETypeDR),3)
	s TActive=obj.EDIActive
	i TActive="Y" S TActive="是"
	e  s TActive="否"
	s TExpInfo=obj.EDIExpInfo
	s TRemark=obj.EDIRemark
	
	q Illndess_"^"_TOMEType_"^"_TActive_"^"_TExpInfo_"^"_TRemark_"^"_TOMETypeDR_"^"_IllndessDR
}

/// 危害因素对应的检查周期
/// 危害因素对应的检查周期
Query SearchEDCheckCycle(Parref As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TOMEType:%String,TActive:%String,TExpInfo:%String,TRemark:%String,TOMETypeDR:%String")
{
}

ClassMethod SearchEDCheckCycleExecute(ByRef qHandle As %Binary, Parref As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEDCheckCycle")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Parref=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDCheckCycleChild",ID)) q:ID=""  d
 	.s Str=..GetOneCheckCycleInfo(Parref_"||"_ID)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(Parref_"||"_ID,$P(Str,"^",1),$P(Str,"^",2),$P(Str,"^",3),$P(Str,"^",4),$P(Str,"^",5),$P(Str,"^",6),$P(Str,"^",7))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEDCheckCycleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEDCheckCycleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEDCheckCycleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEDCheckCycleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneCheckCycleInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s TOMEType=""
	s obj=##class(User.DHCPEEDCheckCycle).%OpenId(ID)
	s TCode=obj.EDCCode
	s TDesc=obj.EDCDesc
	s TOMETypeDR=obj.EDCOMETypeDRGetObjectId()
	s:TOMETypeDR'="" TOMEType=$LG(^User.DHCPEOMETypeD(TOMETypeDR),3)
	s TActive=obj.EDCActive
	i TActive="Y" s TActive="是"
	e  s TActive="否"
	s TExpInfo=obj.EDCExpInfo
	s TRemark=obj.EDCRemark
	q TCode_"^"_TDesc_"^"_TOMEType_"^"_TActive_"^"_TExpInfo_"^"_TRemark_"^"_TOMETypeDR
}

/// 危害因素对应的检查项目
Query SearchEDItem(Parref As %Library.String = "", hospId As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TArcimCode:%String,TArcimDesc:%String,TNeedFlag:%String,TOMEType:%String,TSetsFlag:%String,TActive:%String,TExpInfo:%String,TRemark:%String,TArcimID:%String,TOMETypeDR:%String")
{
}

ClassMethod SearchEDItemExecute(ByRef qHandle As %Binary, Parref As %Library.String = "", hospId As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEDItem","1")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Parref=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDItemChild",ID)) q:ID=""  d
 	.s Str=..GetOneItemInfo(Parref_"||"_ID,hospId)
 	.q:Str=""
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(Parref_"||"_ID,$P(Str,"^",1),$P(Str,"^",2),$P(Str,"^",3),$P(Str,"^",4),$P(Str,"^",5),$P(Str,"^",6),$P(Str,"^",7),$P(Str,"^",8),$P(Str,"^",9),$P(Str,"^",10))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEDItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEDItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEDItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEDItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneItemInfo(ID, hospId As %Library.String = "")
{
	q:ID="" "^^^^^^^^^^^"
	S flag=0
	s ID=$P(ID,"$",1)
	s TOMEType=""
	s obj=##class(User.DHCPEEDItem).%OpenId(ID)
	s ArcimID=obj.EDIItemMastID
	s TNeedFlag=obj.EDINeedFlag
	i TNeedFlag="Y" s TNeedFlag="是"
	e  s TNeedFlag="否"
	
	s TSetsFlag=obj.EDISetsFlag
	i TSetsFlag="Y" s TSetsFlag="是"
	e  s TSetsFlag="否"
	
	i TSetsFlag="是" d
 	.s TArcimCode=$P($g(^ARCOS(+ArcimID)),"^",1)
 	.s TArcimDesc=$P($g(^ARCOS(+ArcimID)),"^",2)
 	
 	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_OrdSets",ArcimID,hospId)
	.i HOSPshowFlag="N" S flag=1

 	e  d
 	.s TArcimCode=$P($g(^ARCIM(+ArcimID,1,1)),"^",1)
 	.s TArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID)
 	
 	.s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("ARC_ItmMast",ArcimID,hospId)
	.i HOSPshowFlag="N" S flag=1
	q:flag=1 ""


	s TOMETypeDR=obj.EDIOMETypeDRGetObjectId()
	s:TOMETypeDR'="" TOMEType=$LG(^User.DHCPEOMETypeD(TOMETypeDR),3) 
	s TActive=obj.EDIActive
	i TActive="Y" s TActive="是"
	e  s TActive="否"
	s TExpInfo=obj.EDIExpInfo
	s TRemark=obj.EDIRemark
	q TArcimCode_"^"_TArcimDesc_"^"_TNeedFlag_"^"_TOMEType_"^"_TSetsFlag_"^"_TActive_"^"_TExpInfo_"^"_TRemark_"^"_ArcimID_"^"_TOMETypeDR
}

/// 危害因素检查项目的重点检查内容
Query SearchEDItemDetail(Parref As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TDetailCode:%String,TDetailDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod SearchEDItemDetailExecute(ByRef qHandle As %Binary, Parref As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger", "SearchEDItemDetail")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Parref=""
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s ID=0
 	f  s ID=$O(^User.DHCPEEndangerD(+Parref,"EDItemChild",$P(Parref,"||",2),"EDItemDetailChild",ID)) q:ID=""  d
 	.s Str=..GetOneItemDetailInfo(Parref_"||"_ID)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(Parref_"||"_id,$P(Str,"^",1),$P(Str,"^",2),$P(Str,"^",3),$P(Str,"^",4),$P(Str,"^",5))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchEDItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchEDItemDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchEDItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchEDItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneItemDetailInfo(ID)
{
	q:ID="" "^^^^^^^^^^^"
	s ID=$P(ID,"$",1)
	s obj=##class(User.DHCPEEDItemDetail).%OpenId(ID)
	s EDIDDetailDR=obj.EDIDDetailDR
	s TDetailCode=$p(^DHCPEST(+EDIDDetailDR,"OD",$p(EDIDDetailDR,"||",2)),"^",11)
	s TDetailDesc=$p(^DHCPEST(+EDIDDetailDR,"OD",$p(EDIDDetailDR,"||",2)),"^",1)
	s TActive=obj.EDIActive
	s TExpInfo=obj.EDIExpInfo
	s TRemark=obj.EDIRemark
	q TDetailCode_"^"_TDetailDesc_"^"_TActive_"^"_TExpInfo_"^"_TRemark
}

/// 疾病
Query IllnessList(Desc As %Library.String = "") As %Query(ROWSPEC = "ID:%String,IT_Code:%String:代码,IT_Desc:%String:描述,IT_ConclusionDR:%String:结论分类,IT_ExpInfo:%String:扩展信息,IT_Remark:%String:备注")
{
}

ClassMethod IllnessListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger","IllnessList")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Desc'="" d
 	.s ID=0
 	.s ID=$O(^User.DHCPEOMEIllnessI("ITDescIndex"," "_Desc,ID))
 	.q:ID=""
 	.s Code=$LG(^User.DHCPEOMEIllnessD(ID),2)
	.s Active=$LG(^User.DHCPEOMEIllnessD(ID),4)
	.q:Active="N"
	.s ConclusionDR=$LG(^User.DHCPEOMEIllnessD(ID),5)
	.s Conclusion=""
	.i (ConclusionDR'="")&&($d(^User.DHCPEConclusionD(ConclusionDR)))  s Conclusion=$LG(^User.DHCPEConclusionD(ConclusionDR),3)
	.s ExpInfo=$LG(^User.DHCPEOMEIllnessD(ID),6)
	.s Remark=$LG(^User.DHCPEOMEIllnessD(ID),7)
	.d FindBuild
	e  d
	.s ID=0
	.f  s ID=$O(^User.DHCPEOMEIllnessD(ID)) q:ID=""  d
	..s Code=$LG(^User.DHCPEOMEIllnessD(ID),2)
	..s Desc=$LG(^User.DHCPEOMEIllnessD(ID),3)
	..s Active=$LG(^User.DHCPEOMEIllnessD(ID),4)
	..q:Active="N"
	..s ConclusionDR=$LG(^User.DHCPEOMEIllnessD(ID),5)
	..s Conclusion=""
	..i (ConclusionDR'="")&&($d(^User.DHCPEConclusionD(ConclusionDR)))  s Conclusion=$LG(^User.DHCPEConclusionD(ConclusionDR),3)
	..s ExpInfo=$LG(^User.DHCPEOMEIllnessD(ID),6)
	..s Remark=$LG(^User.DHCPEOMEIllnessD(ID),7)
	..d FindBuild
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,Code,Desc,Conclusion,ExpInfo,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod IllnessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IllnessListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IllnessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IllnessListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 检查种类
Query OMETypeList(Desc As %Library.String = "") As %Query(ROWSPEC = "ID:%String,OMET_Code:%String:代码,OMET_Desc:%String:描述,OMET_VIPLevel:%String:VIP等级,OMET_ExpInfo:%String:扩展信息,OMET_Remark:%String:备注")
{
}

ClassMethod OMETypeListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger","OMETypeList")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Desc'="" d
 	.s ID=0
 	.s ID=$O(^User.DHCPEOMETypeI("OMETDescIndex"," "_Desc,ID))
 	.q:ID=""
 	.s Code=$LG(^User.DHCPEOMETypeD(ID),2)
	.s Active=$LG(^User.DHCPEOMETypeD(ID),4)
	.q:Active="N"
	.s VIPLevel=$LG(^User.DHCPEOMETypeD(ID),5)
	.s:VIPLevel'="" VIPLevel=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	.s ExpInfo=$LG(^User.DHCPEOMETypeD(ID),6)
	.s Remark=$LG(^User.DHCPEOMETypeD(ID),7)
	.d FindBuild
	e  d
	.s ID=0
	.f  s ID=$O(^User.DHCPEOMETypeD(ID)) q:ID=""  d
	..s Code=$LG(^User.DHCPEOMETypeD(ID),2)
	..s Desc=$LG(^User.DHCPEOMETypeD(ID),3)
	..s Active=$LG(^User.DHCPEOMETypeD(ID),4)
	..q:Active="N"
	..s VIPLevel=$LG(^User.DHCPEOMETypeD(ID),5)
	..s:VIPLevel'="" VIPLevel=$P($G(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	..s ExpInfo=$LG(^User.DHCPEOMETypeD(ID),6)
	..s Remark=$LG(^User.DHCPEOMETypeD(ID),7)
	..d FindBuild
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,Code,Desc,VIPLevel,ExpInfo,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OMETypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OMETypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OMETypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OMETypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 诊断标准
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Endanger","CheckCriteriaList","")
Query CheckCriteriaList(Desc As %Library.String = "", Active As %Library.String = "Y") As websys.Query(ROWSPEC = "TID:%String,TCode:%String,TDesc:%String,TActive:%String,TExpInfo:%String,TRemark:%String")
{
}

ClassMethod CheckCriteriaListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Active As %Library.String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	s ID=0
	f  s ID=$O(^User.DHCPEDiagnosticCriteriaD(ID)) q:ID=""  d
	.s TCode=$LG(^User.DHCPEDiagnosticCriteriaD(ID),2)
	.s TDesc=$LG(^User.DHCPEDiagnosticCriteriaD(ID),3)
	.q:((Desc'="")&&(TDesc'[Desc))
	.s TActive=$LG(^User.DHCPEDiagnosticCriteriaD(ID),4)
	.q:((Active'="")&&(TActive'=Active))
	.s TExpInfo=$LG(^User.DHCPEDiagnosticCriteriaD(ID),5)
	.s TRemark=$LG(^User.DHCPEDiagnosticCriteriaD(ID),6)
	.d CheckCriteriaList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
CheckCriteriaList      
	set Data=$lb(ID,TCode,TDesc,TActive,TExpInfo,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/*ClassMethod GetEDItemDetailChecked(ParRef,ODDR)
{
	s ParID=+ParRef
	s ParrefID=$p(ParRef,"||",2)
	s ChildSub=0
	f  s ChildSub=$o(^User.DHCPEEDItemDetailI("DetailDRIndex",ODDR,ParID,ParrefID,ChildSub)) q:ChildSub=""  d
	.s Active=$LG(^User.DHCPEEndangerD(ParID,"EDItemChild",ParrefID,"EDItemDetailChild",ChildSub),3)
	q Active
}*/
/// 得到选择框是否选中
/// w ##class(web.DHCPE.Endanger).GetEDItemDetailChecked("1||2","1||21")
/// 提供给Web页面 显示指组合项目的所有子项(列表) 
/// 细项列表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderDetailRelate","SreachOrderDetailRelate","","23441||1")
Query SreachOrderDetailRelate(ParRef As %Library.String = "", ParARCIMDR As %Library.String = "") As %Query(ROWSPEC = "ODR_RowId:%String, ODR_ARCIM_DR:%String, ODR_OD_DR:%String, ODR_ARCIM_DR_Name:%String, ODR_OD_DR_Name:%String, ODR_OD_DR_Code:%String, ODR_Sequence:%String, ODR_Required:%String, ODR_Parent_DR:%String, ODR_Parent_DR_Name:%String, ODR_Cascade:%String, Checked:%String,EDItemDetailID:%String")
{
}

ClassMethod SreachOrderDetailRelateExecute(ByRef qHandle As %Binary, ParRef As %Library.String = "", ParARCIMDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (""=ParARCIMDR) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
 	f  s id=$o(^DHCPEODR(0,"ARCIM",ParARCIMDR,id)) q:id=""  d
	.s CurData=$g(^DHCPEODR(id))
	.
	.//ODR_ARCIM_DR 大项RowId
	.s ODRARCIMDR=$p(CurData,"^",1)
    .// ARCIM_Desc	大项名称(ARC_ItmMast)
    .s ARCIMSubscript=$p(ODRARCIMDR,"||",1)		//ARCIM_Subscript
    .s ARCIMVersion=$p(ODRARCIMDR,"||",2)		//ARCIM_Version
    .s ODRARCIMDRName=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.
	.
	.//ODR_OD_DR 细项RowId
    .s ODRODDR=$p(CurData,"^",2)
    .q:ODRODDR=""
    .// OD_Desc 细项名称
    .s STRowId=$p(ODRODDR,"||",1)
    .s ODChildSub=$p(ODRODDR,"||",2)
    .s ODRODDRName=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)
    .q:(""=ODRODDRName) 
    .// OD_Code 细项编码
    .s ODRODDRCode=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",11)
	.
	.// ODR_Sequence	顺序号
	.s ODRSequence=$p(CurData,"^",3)
	.
	.// ODR_Required	是否必填项
	.s ODRRequired=$p(CurData,"^",4)
	.
	.// ODR_Parent_DR	大类指针
	.s ODRParentDR=$p(CurData,"^",5)
	.
	.i ""'=ODRParentDR d
	..s PODRODDR=$p($g(^DHCPEODR(ODRParentDR)),"^",2)
	..i ""'=PODRODDR
	..s PSTRowId=$p(PODRODDR,"||",1)
	..q:PSTRowId=""
	..s PODChildSub=$p(PODRODDR,"||",2)
	..s ODRParentDRName=$p($G(^DHCPEST(PSTRowId,"OD",PODChildSub)),"^",1)
	.e  d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.
	.// ODR_Cascade	层次
	.s ODRCascade=$p(CurData,"^",6)
	.i "1"=ODRCascade d
	..s ODRParentDR=""
	..s ODRParentDRName=""
	.s ParID=+ParRef
	.s ParrefID=$p(ParRef,"||",2)
	.s ChildSub=0
	.f  s ChildSub=$o(^User.DHCPEEDItemDetailI("DetailDRIndex",ODRODDR,ParID,ParrefID,ChildSub)) q:ChildSub=""  d
	..s checked=$LG(^User.DHCPEEndangerD(ParID,"EDItemChild",ParrefID,"EDItemDetailChild",ChildSub),3)
	..S EDItemDetailID=ParID_"||"_ParrefID_"||"_ChildSub
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	set Data=$lb($g(id),ODRARCIMDR,ODRODDR,ODRARCIMDRName,ODRODDRName,ODRODDRCode, ODRSequence, ODRRequired,ODRParentDR,ODRParentDRName,ODRCascade,checked,EDItemDetailID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SreachOrderDetailRelateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SreachOrderDetailRelateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SreachOrderDetailRelateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SreachOrderDetailRelateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemDetailChecked(ODRODDR, ParRef)
{
	s ParID=+ParRef
	s ParrefID=$p(ParRef,"||",2)
	q:'$d(^User.DHCPEEDItemDetailI("DetailDRIndex",ODRODDR,ParID,ParrefID)) ""
	s ChildSub=$o(^User.DHCPEEDItemDetailI("DetailDRIndex",ODRODDR,ParID,ParrefID,0)) 
	s checked=$LG(^User.DHCPEEndangerD(ParID,"EDItemChild",ParrefID,"EDItemDetailChild",ChildSub),3)
	q checked
}

/// 判断检查种类是否被使用
/// w ##class(web.DHCPE.Endanger).IsUseredOMEType(1)
ClassMethod IsUseredOMEType(OMEType)
{
	s flag=0
	s Parref=0
	f  s Parref=$o(^User.DHCPEEndangerD(Parref)) q:((Parref="")||(flag=1))  d
	.s ID=0
 	.f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDItemChild",ID)) q:ID=""  d
	..s obj=##class(User.DHCPEEDItem).%OpenId(Parref_"||"_ID)
	..s TOMEType="",TOMETypeDR=""
  	..s TOMETypeDR=obj.EDIOMETypeDRGetObjectId()
  	..q:TOMETypeDR=""
  	..q:'$d(^User.DHCPEOMETypeD(TOMETypeDR))
  	..s TOMEType=$LG(^User.DHCPEOMETypeD(TOMETypeDR),3) 
  	..s:OMEType=TOMEType flag=1
  	q flag
}

/// 判断检查项目或套餐是否重复
ClassMethod IsExistItem(Parref, ItemID)
{
	s ID=0,flag=0
 	f  s ID=$O(^User.DHCPEEndangerD(Parref,"EDItemChild",ID)) q:(ID="")||(flag=1)  d
    .s ArcimID=$LG(^User.DHCPEEndangerD(Parref,"EDItemChild",ID),2)
    .i ItemID=ArcimID s flag=1
    q flag
}

Storage Default
{
<Data name="EndangerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.EndangerD</DataLocation>
<DefaultData>EndangerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.EndangerD</IdLocation>
<IndexLocation>^web.DHCPE.EndangerI</IndexLocation>
<StreamLocation>^web.DHCPE.EndangerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
