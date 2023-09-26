Class DHCDoc.DHCDocConfig.LocExt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->科室功能设置->科室扩展设定 查询所有科室扩展设置
Query GetLocExtConfig(LocId As %String, HospId As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,RecLocByLogonLoc:%String,NoReferral:%String,NotPackQty:%String,ARCOSInputByLogonLoc:%String,NotNeedInstrArcim:%String,AddDocByNotPriceOEItem:%String,StopOrderDiscExec:%String,ModifySttDateTimeAuthority:%String,DocAppIntervalTime:%String,LocCAVerify:%String,BloodPressureByEntryDiagnosis:%String,INCHighMaterialTrack:%String,OnlyThisDepStop:%String,AllowCostInputReg:%String,IsChinaMed:%String,NotAutoChangeRecloc:%String,ForbidDosingInstr:%String,OpenUseDKB:%String,NotDisplayNoPayOrd:%String,ModifySttDateTimeUpHour:%String,NotAllowAdmissionsIFNoCall:%String,OutPriorAllowPoisonDrug:%String,DiagFromTempOrHisAutoSave:%String,ModifyDateTimeAuthority:%String,ModifyDateTimeUpHour:%String,IsGynaecology:%String,DiagCertificateMaxDaysOff:%String,SDSDiagEntry:%String,DiagDefFirstReg:%String,DealExecStartOnZeroBySpecOrder:%String,DefOpenAllHosp:%String")
{
}

ClassMethod GetLocExtConfigExecute(ByRef qHandle As %Binary, LocId As %String, HospId As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LocExt","GetLocExtConfig")
    Set repid=$I(^CacheTemp)
    Set ind=1
    s LocRowID=0  f  s LocRowID=$o(^CTLOC(LocRowID)) q:LocRowID=""  d
    .s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowID,HospId)
	.q:flag="N"
	.s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
	.Q:LocHospDr'=HospId
    .s LocDesc=$p(^CTLOC(LocRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
	.q:($P(^CTLOC(LocRowID),"^",14)'="Y")
    .q:(CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP")
    .q:(LocId'="")&&(LocRowID'=LocId)
	.q:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
    .s CTLocContactName=$P(^CTLOC(LocRowID),"^",43)
    .s LocDesc=CTLocContactName_" "_LocDesc
    .s RecLocByLogonLoc=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",1))
    .s NoReferral=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",3))
    .s NotPackQty=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",4))
    .s ARCOSInputByLogonLoc=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",5))
    .s NotNeedInstrArcim=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",6))
    .s AddDocByNotPriceOEItem=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",7))
    .s StopOrderDiscExec=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",8))
    .s ModifySttDateTimeAuthority=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",9))
     .s DocAppIntervalTime=$P($G(^CTLOC(LocRowID,"DHC")),"^",10) //..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",10))
    .s LocCAVerify=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",11))
    .s BloodPressureByEntryDiagnosis=$P($G(^CTLOC(LocRowID,"DHC")),"^",12) //..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",12))
    .s BloodPressureByEntryDiagnosis=$case(BloodPressureByEntryDiagnosis,"Y":"","N":"",:BloodPressureByEntryDiagnosis)
    .s INCHighMaterialTrack=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",13))
    .s OnlyThisDepStop=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",14))
    .s AllowCostInputReg=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",15))
    .s IsChinaMed=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",16))
    .s NotAutoChangeRecloc=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",17))
    .s ForbidDosingInstr=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",18))
    .s OpenUseDKB=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",19))
    .s NotDisplayNoPayOrd=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",20))
    .s ModifySttDateTimeUpHour=$P($G(^CTLOC(LocRowID,"DHC")),"^",21)
    .s NotAllowAdmissionsIFNoCall=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",22))
    .s OutPriorAllowPoisonDrug=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",23))
    .s DiagFromTempOrHisAutoSave=$P($G(^CTLOC(LocRowID,"DHC")),"^",24)
    .if (DiagFromTempOrHisAutoSave="undefined") s DiagFromTempOrHisAutoSave=""
    .s ModifyDateTimeAuthority=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",25))
    .s ModifyDateTimeUpHour=$P($G(^CTLOC(LocRowID,"DHC")),"^",26) 
    .s IsGynaecology=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",27))
    .s DiagCertificateMaxDaysOff=$P($G(^CTLOC(LocRowID,"DHC")),"^",28)
    .s SDSDiagEntry=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",29))
    .s DiagDefFirstReg=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",30))
    .s DealExecStartOnZeroBySpecOrder=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",31))
    .s DefOpenAllHosp=..FormatValue($P($G(^CTLOC(LocRowID,"DHC")),"^",32))
    .Do OutputRowGetLocExtConfig
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowGetLocExtConfig
    set Data=$lb($g(LocRowID),$g(LocDesc),$g(RecLocByLogonLoc),$g(NoReferral),$g(NotPackQty),$g(ARCOSInputByLogonLoc),$g(NotNeedInstrArcim),$g(AddDocByNotPriceOEItem),$g(StopOrderDiscExec),$g(ModifySttDateTimeAuthority),$g(DocAppIntervalTime),$g(LocCAVerify),$g(BloodPressureByEntryDiagnosis),$g(INCHighMaterialTrack),$g(OnlyThisDepStop),$g(AllowCostInputReg),$g(IsChinaMed),$G(NotAutoChangeRecloc),$G(ForbidDosingInstr),$g(OpenUseDKB),$g(NotDisplayNoPayOrd),ModifySttDateTimeUpHour,$g(NotAllowAdmissionsIFNoCall),$g(OutPriorAllowPoisonDrug),$g(DiagFromTempOrHisAutoSave),$g(ModifyDateTimeAuthority),$g(ModifyDateTimeUpHour),$G(IsGynaecology),$g(DiagCertificateMaxDaysOff),SDSDiagEntry,$G(DiagDefFirstReg),$G(DealExecStartOnZeroBySpecOrder),DefOpenAllHosp)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod GetLocExtConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocExtConfigExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLocExtConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocExtConfigExecute ]
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

ClassMethod FormatValue(value As %String) As %String
{
    i value=1 s value="Y"
    e  s value="N"
    q value
}

ClassMethod SetDHCCTLOCFieldValue(Rowid As %String, DHCFieldNumStr As %String, ValStr As %String) As %String
{
   For i=1:1:$l(DHCFieldNumStr,"^") d
   .s DHCFieldNum=$p(DHCFieldNumStr,"^",i)
   .s Val=$p(ValStr,"^",i)
   .s $P(^CTLOC(Rowid,"DHC"),"^",DHCFieldNum)=Val
   q 0
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->科室功能设置->科室扩展设定 查询所有科室扩展设置
Query GetLocExtConfigNew(LocId As %String, HospId As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocAlias:%String")
{
}

ClassMethod GetLocExtConfigNewExecute(ByRef qHandle As %Binary, LocId As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LocExt","GetLocExtConfig")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s LocRowID=0  f  s LocRowID=$o(^CTLOC(LocRowID)) q:LocRowID=""  d
    .//s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowID,HospId)
	.//q:flag="N"
	.s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
	.Q:(LocHospDr'=HospId)&&(HospId'="")
    .s LocDesc=$p(^CTLOC(LocRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
	.q:($P(^CTLOC(LocRowID),"^",14)'="Y")
    .q:(CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP")
    .q:(LocId'="")&&(LocRowID'=LocId)
    .q:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
    .s ContactName=$p(^CTLOC(LocRowID),"^",43)
	.Do OutputRowGetLocExtConfigNew
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetLocExtConfigNew
	set Data=$lb($g(LocRowID),$g(LocDesc),ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetLocExtConfigNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocExtConfigNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocExtConfigNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocExtConfigNewExecute ]
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

ClassMethod LocActive(LocID)
{
	n (LocID)
	Q:LocID="" 0
	s CurDate=+$H
	s DateFrom=$p(^CTLOC(LocID),"^",24)
	Q:(DateFrom="")||(DateFrom>CurDate) 0
	s DateTo=$p(^CTLOC(LocID),"^",25)
	Q:(DateTo'="")&&(DateTo<=CurDate) 0
	s CTActive=$p($g(^CTLOC(LocID)),"^",14)
	q:CTActive'="Y" 0
	Q 1
}

}
