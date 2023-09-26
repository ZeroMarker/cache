Class DHCMA.CPW.SD.DataSrv.FPInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s a=##class(DHCMA.CPW.SD.DataSrv.FPInfoSrv).GetDataByAdm("185","1||266")
ClassMethod GetDataByAdm(aEpisodeID As %String, aItemID As %String = "") As DHCMA.CPW.SD.Data.FPInfo
{
	New (aEpisodeID,aItemID)
	Set $zt="GetDataByAdmErr"
	Set return=""
	Set FPID=$o(^DHCMA.CPW.SD.Data.FPInfoI("IdxAdm",aEpisodeID,""),-1)
	If (FPID="") {
		d ..SynFPInfoByAdm(aEpisodeID)	
		Set FPID=$o(^DHCMA.CPW.SD.Data.FPInfoI("IdxAdm",aEpisodeID,""),-1)
	}
	Quit:FPID="" return
	Set return=##class(DHCMA.CPW.SD.Data.FPInfo).GetObjById(FPID)
	If (aItemID'=""){
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(objItem) return
		Set aItemDesc=objItem.BTDesc
		Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
		Quit:DicID="" return
		Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
		Quit:TabelInfo="" return
		Quit:TabelInfo'["FP" return
		Set Field=$p(TabelInfo,"^",2)
		set $property(return,Field)="*"_$property(return,Field)
	}
	Quit return
GetDataByAdmErr
	Quit return
}

/// w ##class(DHCMA.CPW.SD.DataSrv.FPInfoSrv).SynFPInfoByAdm(185)
ClassMethod SynFPInfoByAdm(aEpisodeID As %String) As DHCMA.CPW.SD.Data.FPInfo
{
	New (aEpisodeID)
	Set return="未成功同步费用信息"
	Quit:(aEpisodeID="") return
	Set (M4DICD10,M6DICD10,MDignosDesc,M4OCM3,M6OCM3,MOperDesc,ODICD10,ODICDDesc)=""
	//获取编目诊断
	Set DiaStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(aEpisodeID,"D")
	For dLen=1:1:$l(DiaStr,$c(1)) {
		Set dStr=$p(DiaStr,$c(1),dLen)
		Continue:dStr=""
		Set ICD10=$p(dStr,$c(2),1)
		Set ICDDesc=$p(dStr,$c(2),2)
		Set DischCondDesc=$p(dStr,$c(2),4)
		Set dType=$p(dStr,$c(2),9)
		If (dType=1){
			Set M4DICD10=$e(ICD10,1,5)	
			Set M6DICD10=$e(ICD10,1,7)
			Set MDignosDesc=ICDDesc
			Set:$e(ICD10,8,8)="x" M6DICD10=$e(ICD10,1,11)
		}elseIf (dType=2)&&(ODICD10="") {
			Set ODICD10=ICD10
			Set ODICDDesc=ICDDesc
		} 
	}
	//获取编目手术 (第一手术默认为主手术)
	Set OperStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(aEpisodeID,"O/1",1)
	Set:OperStr="" OperStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(aEpisodeID,"O/2",1)
	Set CM3Code=$p(OperStr,$c(2),1)
	Set OperDesc=$p(OperStr,$c(2),2)
	Set M4OCM3=$e(CM3Code,1,5)
	Set M6OCM3=$e(CM3Code,1,7)
	Set:$e(CM3Code,8,8)="x" M6OCM3=$e(CM3Code,1,11)
	Set MOperDesc=OperDesc
	Set xInputStr=aEpisodeID_"^"_M4DICD10_"^"_M6DICD10_"^"_MDignosDesc_"^"_M4OCM3_"^"_M6OCM3_"^"_MOperDesc_"^"_ODICD10_"^"_ODICDDesc
	Quit:M4DICD10="" "未获取编目信息"
	Set ret=##class(DHCMA.CPW.SD.Data.FPInfo).Update(xInputStr,"^")
	Set:ret>0 return="同步编目信息成功"
	Quit return
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.FPInfoSrv","QryFPInfo",1,"1||1")
Query QryFPInfo(aEpisodeID As %String, aItemID As %String, aGetType As %String = "D") As %Query(ROWSPEC = "Type:%String,ICD10:%String,ICDDesc:%String,OutStatus:%String,OperSDateT:%String,OperEDateT:%String,CutType:%String")
{
}

ClassMethod QryFPInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aItemID As %String, aGetType As %String = "D") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="") $$$OK
 	If (aItemID'="") {
	 	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	 	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	 	//根据配置信息，标记特定信息
 	}
 	If (aGetType["D") {
		Set DiaStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(aEpisodeID,aGetType)
		For dLen=1:1:$l(DiaStr,$c(1)) {
			Set dStr=$p(DiaStr,$c(1),dLen)
			Continue:dStr=""
			Set ICD10=$p(dStr,$c(2),1)
			Set ICDDesc=$p(dStr,$c(2),2)
			Set DischCondDesc=$p(dStr,$c(2),4)
			Set dType=$p(dStr,$c(2),9)
			Set Data=$lb(dType,ICD10,ICDDesc,DischCondDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 }else{
		Set OperStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(aEpisodeID,"O/1")
		For oLen=1:1:$l(OperStr,$c(1)) {
			Set oStr=$p(OperStr,$c(1),oLen)
			Continue:dStr=""
			Set ICD10=$p(oStr,$c(2),1)
			Set ICDDesc=$p(oStr,$c(2),2)
			Set OperSDate=$p(oStr,$c(2),3)
			Set OperSDateT=""
			Set OperEDateT=""
			Set CutType=$p(oStr,$c(2),5)
			Set OutStatus=$p(oStr,$c(2),7) //愈合情况
			Set dType=$p(oStr,$c(2),9)
			Set Data=$lb("手术",ICD10,ICDDesc,OutStatus,OperSDateT,OperEDateT,CutType)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryFPInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFPInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFPInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFPInfoExecute ]
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

}
