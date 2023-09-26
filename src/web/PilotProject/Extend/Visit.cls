/// CTOR: QP
/// DATE: 2021-01-15
/// DESC: 临床药理访视医嘱
Class web.PilotProject.Extend.Visit Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-01-15
/// DESC: 查询病人阶段免费医嘱
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.Extend.Visit","QryFreeOrd","19","","15")
Query QryFreeOrd(PPRowId = "", InArcim = "", InStage = "") As %Query(ROWSPEC = "ArcimRowId:%String,Arcimdesc:%String,PPFRowId:%String,PPFSttDate:%String,PPFSttTime:%String,PPFEndDate:%String,PPFEndTime:%String,PPFFreeNum:%String,PPFLimitEntryAfterNoFreeNum:%String,PPFStageDr,PPFStageDesc")
{
}

ClassMethod QryFreeOrdExecute(ByRef qHandle As %Binary, PPRowId, InArcim = "", InStage = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^QP("QryFreeOrd")=$LB(PPRowId,InArcim,InStage)
	s langid=..%LanguageID()
	s CDate=+$H,CTime=$p($h,",",2)
	s PPFChildSub=0
	f  s PPFChildSub=$o(^DHCDocPPF(PPRowId,PPFChildSub)) q:PPFChildSub=""  d
	.s str=$g(^DHCDocPPF(PPRowId,PPFChildSub))
	.s PPFSttDate=$p(str,"^",1)
	.i PPFSttDate'="" s PPFSttDate=##class(websys.Conversions).DateLogicalToHtml(PPFSttDate)
	.s PPFSttTime=$p(str,"^",2)
	.s SFlag=##class(web.PilotProject.Com.Func).CompareDate(PPFSttDate,CDate,PPFSttTime,CTime)
	.;q:SFlag=""
	.i PPFSttTime'="" s PPFSttTime=$zt(PPFSttTime,1)
	.s PPFEndDate=$p(str,"^",3)
	.i PPFEndDate'="" s PPFEndDate=##class(websys.Conversions).DateLogicalToHtml(PPFEndDate)
	.s PPFEndTime=$p(str,"^",4)
	.s EFlag=##class(web.PilotProject.Com.Func).CompareDate(PPFEndDate,CDate,PPFEndTime,CTime)
	.;q:EFlag=""
	.q:(SFlag=1)||(EFlag=-1)
	.i PPFEndTime'="" s PPFEndTime=$zt(PPFEndTime,1)
	.s PPFItmMastDR=$p(str,"^",5)
	.s PPFItmMastDesc=$p($g(^ARCIM(+PPFItmMastDR,$p(PPFItmMastDR,"||",2),1)),"^",2)
	.s PPFItmMastDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",PPFItmMastDesc,langid)
	.s PPFFreeNum=$p(str,"^",6)
	.s PPFLimitEntryAfterNoFreeNum=$p(str,"^",7)
	.s PPFStageDesc=""
	.s PPFStageDr=$p(str,"^",8)
	.q:(InStage'="")&&(PPFStageDr'=InStage)
	.q:(InArcim'="")&&(InArcim'=PPFItmMastDR)
	.i PPFStageDr'="" d
	..s PPFStageDesc=$p(^CF.DOC.Pilot.OEStageD(PPFStageDr),"^",1)
	..s PPFStageDesc= ##class(User.DHCDocPilotProStage).GetTranByDesc("STName",PPFStageDesc,langid)
	
	.Do OutputRowFreeOrd
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFreeOrd
    B //1
	set Data=$lb(PPFItmMastDR,PPFItmMastDesc,PPRowId_"||"_PPFChildSub,PPFSttDate,PPFSttTime,PPFEndDate,PPFEndTime,PPFFreeNum,PPFLimitEntryAfterNoFreeNum,PPFStageDr,PPFStageDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod QryFreeOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFreeOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFreeOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFreeOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2020-01-18
/// DESC: 访视医嘱确定后加载到医嘱录入的方法
/// IN  :   itmjs: AddCopyItemToList  	
/// 			itmjsex: ''
/// 			EpisodeId - PA_Adm表Id
/// OUT : 0
/// EXEC: d ##class(web.PilotProject.Extend.Visit).GetAddToListArcimInfo("1246","1483||1","AddCopyItemToList",2)
ClassMethod GetAddToListArcimInfo(EpisodeID, ArcimList, itmjs, HospID) As %String
{
	s ret=0
	s ^QP("TEMMP",1)=$lb(EpisodeID,ArcimList, itmjs)
	s jsval=""
	s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
	for i=1:1:$l(ArcimList,",") {
		s arcim=$p(ArcimList,",",i)
		S InstrucDR=""
		s Instruc="",FormDurDesc="",FormDurRowid="",FormDurFactor=""
		
		s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
		s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
		s OrderType=..GetOrderType(arcim)
		i OrderType'="R" {
			;添加默认疗程 20130106
			s cfgDur=$g(^DHCDocConfig("HospDr_"_HospID,"FrequencedItemDur"))
			i cfgDur'="" s FormDurRowid=cfgDur
		  	i FormDurRowid'=""  d
			.s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
			.s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		}
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
		i DrgformRowid'=""   d
		.s PHCDRowid=$P(DrgformRowid,"||",1)
	  	.s ChildSub=$P(DrgformRowid,"||",2)
		.s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  	.s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  	.;添加取等效单位及默认值
	  	.s eqSub=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  	.i eqSub'="" d
	  	..s FormDoseUOMRowid=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",1)
	  	..s FormDoseQty=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",3)
	  	..s FormDoseQty=##class(DHCAnt.KSS.Common.Method).ComDealToNum(FormDoseQty)
	  	..s FormDoseQty=##class(DHCAnt.KSS.MainInterface).GetFormDoseQty(DrgformRowid)
	  	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  	.;添加默认疗程 20130106
	  	.s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  	.i FormDurRowid'=""  d
		..s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		..s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		
		.;频率
	  	.s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	    .i FormFreqRowid'=""  d
		..s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		..s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		..s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		s OrderActionRowid="",OrderAction="",OrderSkinTest="N"
		;跟医生站的默认走，只要有一个标志勾上，就表示皮试
		s PSFlag=##class(DHCAnt.KSS.Common.Method).GetPSFlag(arcim)
		i PSFlag=1 s OrderSkinTest="Y"
		s YYInfo=##class(DHCAnt.KSS.Common.Method).GetOrderActionYY()
		s YYFlag=##class(DHCAnt.KSS.Common.Method).GetOrderActionFlag(arcim,PAAdmType)
		i YYFlag=1 d
		.s OrderSkinTest="Y"
		.s OrderActionRowid=$p(YYInfo,"^",1)
		.s OrderAction=$p(YYInfo,"^",2)
		//临床药理门诊患者开立医嘱非药品清空疗程
		i (OrderType'="R")&&(PAAdmType'="I"){
			s FormDurRowid=""
			s FormDurDesc=""
			s FormDurFactor	=0
		}
		s AARowid="",UseReasonID=""
		s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
		s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
		s ItemData=ItemData_"^"_Instruc_$C(1)_InstrucDR
		s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^^^^^"
		s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID	//12
		s ItemData=ItemData_"^^^^^^^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest	//21
		
		s OrderType="",OrderSeqNo="",ID=""
		s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_""";"
		 
	}
	
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary,1);"
		&javascript<#(jsval)#>
	}
	q ret
}

/// CTOR: QP
/// DATE: 2021-12-01
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Visit).GetOrderType("1483||1")
ClassMethod GetOrderType(ArcimID) As %String
{
	s mRtn=""
	s ArcimSub=$p(ArcimID,"||",2)
	s itemDR=$p(^ARCIM(+ArcimID,ArcimSub,1),"^",10)
	Q:itemDR="" mRtn	
	s mRtn=$P(^ARC("IC",itemDR),"^",7) 
	
	Q mRtn
}

}
