/// 名称: DHCHAI.IRS.INFICUVAPSrv
/// 描述: 呼吸机相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-23
Class DHCHAI.IRS.INFICUVAPSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-07-07
/// Description:  根据病人查询ICU带管记录
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFICUVAPSrv","QryICUVAPByPaadm","1",22)
Query QryICUVAPByPaadm(aPaadm As %String, aLocID As %String) As %Query(ROWSPEC = "ID:%String,IRIntuDate:%String,IRExtuDate:%String,IRVAPType:%String,IRVAPTypeDesc:%String,IROperDoc:%String,IROperDocDesc:%String,IROperLoc:%String,IROperLocDesc:%String,IRIsInf:%String,IRInfDate:%String,IRInfSymptoms:%String,IRInfSymptomsDesc:%String,IRBacteria:%String,IRBacteriaDesc:%String,IsCheck:%String")
{
}

ClassMethod QryICUVAPByPaadmExecute(ByRef qHandle As %Binary, aPaadm As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPaadm="") $$$OK
 	
 	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",aPaadm,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set IRIntuDate = obj.IRIntuDate
		//Set:+IRIntuDate'=0 IRIntuDate=$zd(+IRIntuDate,3)
		Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
		Set IRExtuDate = obj.IRExtuDate
		//Set:+IRExtuDate'=0 IRExtuDate = $zd(+IRExtuDate,3)
		Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
		//置管人员 ...
		Set (IRVAPType,IRVAPTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)=""
		
		if $Isobject(obj.IRVAPType)
		{
			Set IRVAPType =obj.IRVAPType.%Id()
			Set IRVAPTypeDesc =obj.IRVAPType.BTDesc
		}
		if $Isobject(obj.IROperDoc)
		{
			Set IROperDoc =obj.IROperDoc.%Id()
			Set IROperDocDesc =obj.IROperDoc.BTDesc
		}
		if $Isobject(obj.IROperLoc)
		{
			Set IROperLoc =obj.IROperLoc.%Id()
			Set IROperLocDesc =obj.IROperLoc.BTDesc
		}
		Set IRIsInf = obj.IRIsInf
		Set IRInfDate = obj.IRInfDate
		//Set:+IRInfDate'=0 IRInfDate=$zd(+obj.IRInfDate,3)
		Set:IRInfDate'="" IRInfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRInfDate)
		if $Isobject(obj.IRInfSymptoms)
		{
			Set IRInfSymptoms =obj.IRInfSymptoms.%Id()
			Set IRInfSymptomsDesc =obj.IRInfSymptoms.BTDesc
		}
		//病原体
		if $Isobject(obj.IRBacteria)
		{
			Set IRBacteria =obj.IRBacteria.%Id()
			Set IRBacteriaDesc =obj.IRBacteria.BTBacDesc
		}
		Set IsCheck = obj.IRIsCheck
		Set Data=$lb(xID,IRIntuDate,IRExtuDate)
		Set Data=Data_$lb(IRVAPType,IRVAPTypeDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc)
		//感染信息
		Set Data=Data_$lb(IRIsInf,IRInfDate,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryICUVAPByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUVAPByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUVAPByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUVAPByPaadmExecute ]
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
