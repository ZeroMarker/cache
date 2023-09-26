/// 名称: DHCMA.CPW.BTS.PathFormTCMSrv
/// 描述: 项目中药方剂 维护 服务类
Class DHCMA.CPW.BTS.PathFormTCMSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据方剂ID，获取方剂医嘱信息
/// 查询关联医嘱信息
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormTCMSrv","QueryTCMDtl","16")
Query QueryTCMDtl(aTCMID As %String) As %Query(ROWSPEC = "ParrefID:%String,subID:%String,ArcID:%String,ArcDesc:%String,ArcType:%String,DoseQty:%String,CTUnit:%String,PHCFreq:%String,PHCInstruc:%String,PHCSpec:%String,SPriority:%String,OtherChoice:%String,ArcTypeDesc:%String,CTUnitDesc:%String,PHCFreqDesc:%String,PHCInstrucDesc:%String,IsChecked:%String,IsArcInci:%String,ArcResumeID:%String,ArcResume:%String")
{
}

ClassMethod QueryTCMDtlExecute(ByRef qHandle As %Binary, aTCMID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set ^tmpzgz814=aTCMID
	Set xType=""
 	For {
	 	Set xType=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofTypeDr",xType))
	 	Quit:xType=""
		Set xSub=""
	 	For {	
	 		Set xSub=$o(^DHCMA.CPW.BT.PathTCMI("EXT","IdxofTypeDr",xType,aTCMID,xSub))
	 		Quit:xSub=""
	 		Set ID=aTCMID_"||"_xSub
	 		Set obj=##class(DHCMA.CPW.BT.PathTCMExt).GetObjById(ID)
	 		Continue:'$IsObject(obj)
	 		Set (COSArcID,COSArcDesc,ArcType,DoseQty,CTUnit,PHCFreq,PHCInstruc,PHCSpec,SPriority,OtherChoice,ArcTypeDesc,CTUnitDesc,PHCFreqDesc,PHCInstrucDesc,IsArcInci)=""
	 		Set OrdMastDesc      = obj.BTOrdMastID  //lzh将该字段按医嘱名称作处理，将就先用
	 		Set TypeID="",TypeDesc=""
	 		If $IsObject(obj.BTTypeDr){
			 	Set ArcType         = obj.BTTypeDr.%Id()
		 		Set ArcTypeDesc     = obj.BTTypeDr.BTDesc
	 		}
	 		//Set IOrdMastDesc=$tr($tr(OrdMastDesc,"[",""),"]","")
	 		Set IOrdMastDesc=$$ALPHAUP^SSUTIL4(OrdMastDesc)
			Set ArcMID=$o(^ARCIM(0,"Desc",IOrdMastDesc,""),-1)
			Set VerID=$o(^ARCIM(0,"Desc",IOrdMastDesc,ArcMID,""),-1)
			Set ArcID=ArcMID_"||"_VerID
			Set ArcDesc=OrdMastDesc	
			Set DoseQty=obj.DoseQty
			Set CTUnit=obj.CTUnit
			Set ArcResumeID=obj.ArcResume
			Set DocConfigList = $lfs($g(^DHCDocConfig("CNMedItemPhSpecInstr")),"^")
			Set ArcResume=$p($lg(DocConfigList,ArcResumeID),$c(1),2)
			/*
			For inds=1:1:$ll(DocConfigList){
				Set ConfigID=$p($li(DocConfigList,inds),$c(1),1)
				Continue:ArcResumeID'=ConfigID
				Set ArcResume = $p($li(DocConfigList,inds),$c(1),2)
			}*/
			Set SPriority=obj.SPriority
			Set Data=$lb(aTCMID,xSub,ArcID,ArcDesc,ArcType,DoseQty,CTUnit,PHCFreq,PHCInstruc,PHCSpec,SPriority,OtherChoice,ArcTypeDesc,CTUnitDesc,PHCFreqDesc,PHCInstrucDesc,IsChecked,IsArcInci,ArcResumeID,ArcResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}
	Quit $$$OK
}

ClassMethod QueryTCMDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCMDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryTCMDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCMDtlExecute ]
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

/// Description:  项目中药方剂
/// Table：       DHCMA.CPW.BT.PathFormTCM
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathFormTCMSrv","QryPathFormTCM","4||1||10")
Query QryPathFormTCM(aFormItem As %String, aHospID As %String = "") As %Query(ROWSPEC = "PathFormSympDr:%String,PathFormDr:%String,FormVerDesc:%String,SympDiagIDs:%String,SympDiagnos:%String,SympTCMDr:%String,SympTCMDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String,FormTCMID:%String,Linked:%String")
{
}

ClassMethod QryPathFormTCMExecute(ByRef qHandle As %Binary, aFormItem As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aFormItem="" $$$OK
 	Set FormDr=$p(aFormItem,"||",1)
 	Set SubEpisID=$p(aFormItem,"||",2)
 	Set SubItemID=$p(aFormItem,"||",3)
 	Quit:FormDr="" $$$OK
	Set xSympSub=0
	For {
		Set xSympSub=$o(^DHCMA.CPW.BT.PathFormD(FormDr,"SYMP",xSympSub))
		Quit:xSympSub=""
		
		Set PathFormSympDr=FormDr_"||"_xSympSub
		Set objFormSymp=##class(DHCMA.CPW.BT.PathFormSymp).GetObjById(PathFormSympDr)
		Continue:'$IsObject(objFormSymp)
		Set objForm=objFormSymp.Parref
		Set PathFormDr=objForm.%Id()
		Set FormVerDesc=objForm.FormVersion
 		Set FormVerDesc="v"_FormVerDesc_".0"
 		Set FormIsActive=objForm.FormIsActive
 		If FormIsActive<1 {
	 		Set FormVerDesc=FormVerDesc_"(作废)"
 		} Else {
 			Set FormIsOpen=objForm.FormIsOpen
	 		Set:FormIsOpen>0 FormVerDesc=FormVerDesc_"(已发布)"
	 	}
 		Set SympDiagIDs=objFormSymp.SympDiagnos
		Set SympDiagnos=""
		For indx=1:1:$l(SympDiagIDs,","){
			Set xSympDiagID=$p(SympDiagIDs,",",indx)
			Set xDiagInfo=##Class(DHCMA.CPW.IO.FromDoc).GetMRCICDDX(xSympDiagID)
			Set xSympDesc=$p(xDiagInfo,"^",3)
			Set SympDiagnos=SympDiagnos_","_xSympDesc	
		}
		Set:SympDiagnos'="" SympDiagnos=$e(SympDiagnos,2,$l(SympDiagnos))
			 	
 		
 		Set SympTCMDr="",SympTCMDesc=""
 		If $IsObject(objFormSymp.SympTCMDr){
	 		Set SympTCMDr=objFormSymp.SympTCMDr.%Id()
	 		Set SympTCMDesc=objFormSymp.SympTCMDr.BTDesc
	 	}
	
	 	Set Linked=0,FormTCMDr="",(ActDate,ActTime,ActUserID,ActUserDesc)=""
	 	if ($d(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormDr,SubEpisID,SubItemID,SympTCMDr))) {
		 	Set Linked=1
		 	Set SubFormTCMID=$o(^DHCMA.CPW.BT.PathFormI("TCM","PItemTCM",FormDr,SubEpisID,SubItemID,SympTCMDr,""),-1)
		 	Set FormTCMDr=aFormItem_"||"_SubFormTCMID
		 	Set objFormTCM=##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(FormTCMDr)
		 	Set ActDate=objFormTCM.TCMActDate
		 	Set ActTime=objFormTCM.TCMActTime
		 	//Set:ActDate'="" ActDate=$ZD(ActDate,3)
			Set DateLogRet=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWHISIODateLogicalToHtml",aHospID)
			Set:(ActDate'="")&(DateLogRet'=1) ActDate = $ZD(ActDate,3)
			Set:(ActDate'="")&(DateLogRet=1) ActDate = ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		 	Set:ActTime'="" ActTime=$ZT(ActTime,1)
		 	Set ActUserID=objFormTCM.TCMActUserID
		 	Set ActUserDesc=""
		 	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		 	If ($IsObject(objUser)) {
		 		Set ActUserDesc=objUser.BTDesc
		 	}
	 	}
	 	;w "SympTCMDr="_SympTCMDr_",FormTCMDr="_FormTCMDr,!
	 	Set Data=$lb(PathFormSympDr,PathFormDr,FormVerDesc,SympDiagIDs,SympDiagnos,SympTCMDr,SympTCMDesc,ActDate,ActTime,ActUserID,ActUserDesc,FormTCMDr,Linked)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPathFormTCMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathFormTCMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathFormTCMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathFormTCMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMA.CPW.BTS.PathFormTCMSrv).test()
ClassMethod test()
{
	Set xdesc=""
	for {
		Set xdesc=$o(^ARCIM(0,"Desc",xdesc))
		Quit:xdesc=""
		b:xdesc["半夏"
		
		}
}

}
