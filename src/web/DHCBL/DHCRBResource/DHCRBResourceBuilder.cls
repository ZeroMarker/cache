Class web.DHCBL.DHCRBResource.DHCRBResourceBuilder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod DHCRBResourceUpdate(RBResourceInfo As %String) As %String
{
 TStart

 s PRBResourceInfo=##class(web.DHCEntity.PCA.RBResource).%New()
	d PRBResourceInfo.XMLNodeDeserialize(.RBResourceInfo,"TransContent",RBResourceInfo)
 set status=##class(web.DHCRBResource).RBResourceUpdate(RBResourceInfo)
	if status="-100" {
		TRollback
		quit -100 
	}
	TCommit
 quit 0
}

ClassMethod RBResourceServerDelete(Infostr As %String) As %String
{
 TStart

 s Info=##class(web.DHCEntity.PCA.DHCRBCSessionTypeService).%New()
	d Info.XMLNodeDeserialize(.Infostr,"TransContent",Infostr)
 set status=##class(web.DHCRBResource).RBResourceServerDelete(Infostr)
	if status="-100" {
		TRollback
		quit -100 
	}
	TCommit
 quit 0
}

ClassMethod RBResourceServerSave(Infostr As %String) As %String
{
 TStart
    s Info=##class(web.DHCEntity.PCA.DHCRBCSessionTypeService).%New()
	d Info.XMLNodeDeserialize(.Infostr,"TransContent",Infostr)
	if (..CheckRepeatService(Infostr)=1) {
		TRollback
		quit "记录重复！" 
	}
   set status=##class(web.DHCRBResource).RBResourceServerSave(Infostr)
   if status="-100" {
		TRollback
		quit -100 
    }
	TCommit
 quit 0
}

ClassMethod CheckRepeatService(Info As web.DHCEntity.PCA.DHCRBCSessionTypeService) As %String
{
	s ID=Info.ID
	if (+Info.ID>0){
		s SERParRef=+Info.ID
	}else{
		s SERParRef=Info.SERParRef
	}
	s ServiceRepeatFlag=0
	s SERChildsub=0
	for {
		s SERChildsub=$o(^RBC("SESS",SERParRef,"SER",SERChildsub)) Q:(SERChildsub="")||(ServiceRepeatFlag=1)
		continue:(+ID'=0)&&((ID=(SERParRef_"||"_SERChildsub)))
		s SERARCIMDR=$p(^RBC("SESS",SERParRef,"SER",SERChildsub),"^",1)
		s SERHospDR=$p(^RBC("SESS",SERParRef,"SER",SERChildsub),"^",2)
		s SESSType=$p(^RBC("SESS",SERParRef,"SER",SERChildsub),"^",3)
		continue:(((SESSType="")&&(Info.SERType'="OrderNorm"))||((SESSType'="")&&(Info.SERType'=SESSType)))
		if ((Info.SERType'="OrderDiag")&&(Info.SERRBCServiceDR=SERARCIMDR)&&(Info.HospID=SERHospDR)) s ServiceRepeatFlag=1
		s DiagnoseDr=$p(^RBC("SESS",SERParRef,"SER",SERChildsub),"^",4)
		if ((Info.SERType="OrderDiag")&&(Info.SERDiagnoseDr=DiagnoseDr)&&(Info.HospID=SERHospDR)) s ServiceRepeatFlag=1
	}
	Q ServiceRepeatFlag
}

Query FindAllItem(Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "", AppendedArcimFlag As %String = "", LogonWard As %String = "", GroupID As %String = "", TYPE As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean,SameFreqDifferentDosesFlag:%String,DischargeOrdFlag:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary, Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "", AppendedArcimFlag As %String = "", LogonWard As %String = "", GroupID As %String = "", TYPE As %String = "", HospId As %String = "") As %Status
{
	set ^TMP("FindAllItem")=$lb(Alias, StopAfterLongOrder, NotAutoStop, AppendedArcimFlag, LogonWard, GroupID, TYPE, HospId)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias="")&&(StopAfterLongOrder="")&&(NotAutoStop="")&&(AppendedArcimFlag=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s UserID=%session.Data("LOGON.USERID")
	s LocId=%session.Get("LOGON.CTLOCID")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	i ($g(GroupID)="")&&($d(%session)) s GroupID=%session.Get("LOGON.GROUPID")
	s GroupID=$replace(GroupID,$C(1),"")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
	k TempARCMList($j)
	if (AppendedArcimFlag="on")&&(LogonWard'="") {
		s ArcimID=0
		for {
			s ArcimID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR","A",LogonWard,ArcimID)) q:ArcimID=""
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
			continue:($d(TempARCMList($j,ArcimID)))
			s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
			continue:ArcimDesc=""
			s selected=0,TempARCMList($j,ArcimID)=1
			s Find=0
			if (Alias'=""){
				s ALIASRowId=0
				for {
					s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,ALIASRowId)) Q:(ALIASRowId="")||(Find=1)
					s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					s ALIASText=$$ALPHAUP^SSUTIL4(ALIASText)
					if ALIASText[Alias s Find=1
				}
			}
			continue:(Alias'="")&&(Find=0)&&($$ALPHAUP^SSUTIL4(ArcimDesc)'[Alias)
			d OutputRowFindAllItem
		}
		/*s Alias=$$ALPHAUP^SSUTIL4(Alias)
		s ArcimID=0
		for {
			s ArcimID=$o(^DHCDocConfig("ArcimWardAdd",LogonWard,ArcimID)) Q:ArcimID=""
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
			continue:($d(TempARCMList($j,ArcimID)))
			s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
			continue:ArcimDesc=""
			s selected=0,TempARCMList($j,ArcimID)=1
			s Find=0
			if (Alias'=""){
				s ALIASRowId=0
				for {
					s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,ALIASRowId)) Q:(ALIASRowId="")||(Find=1)
					s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					s ALIASText=$$ALPHAUP^SSUTIL4(ALIASText)
					if ALIASText[Alias s Find=1
				}
			}
			continue:(Alias'="")&&(Find=0)&&($$ALPHAUP^SSUTIL4(ArcimDesc)'[Alias)
			d OutputRowFindAllItem
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK*/
	}
	s count=0
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d rs1.Execute(Alias,GroupID,"","",TYPE,"","","","","",UserID,"","",LocId_$C(3)_HospId,"","^1")
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		continue:ArcimID=""
		continue:($d(TempARCMList($j,ArcimID)))
		s ARCIMType=rs1.GetData(4)
		continue:ARCIMType="ARCOS"
		s OrderType=rs1.GetData(6)
		continue:OrderType="R"
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s selected=0 ,TempARCMList($j,ArcimID)=1
		d OutputRowFindAllItem
		/*s count=count+1
		if (count>1000){
			q
		}*/
	}
	if (StopAfterLongOrder=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("StopAfterAllLongOrder",ArcimID)) q:ArcimID=""  d
		.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.d OutputRowFindAllItem
	}
	if (NotAutoStop=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("NotAutoStopLongOrder",ArcimID)) q:ArcimID=""  d
		.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.d OutputRowFindAllItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	;医嘱只允许开一次标志/同频次不同剂量医嘱标志->此处常用用法选择医嘱项用
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ArcimID,""))
	if (DARCIMRowid'=""){
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ArcimID,HospId)
	Set Data=$lb(ArcimID,ArcimDesc,selected,SameFreqDifferentDosesFlag,DischargeOrdFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
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

}
