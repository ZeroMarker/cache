/// 名称: DHCMed.DCEns.LIS.TSResultTask
/// 描述: 检验结果手工同步类
/// 编写者：jiangpengpeng
/// 编写日期: 2016-03-30
Class DHCMed.DCEns.LIS.TSResultHand Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-30
/// Description:  检验数据同步
/// Table：       ^TTAB()、DHCMed.DC.LIS.*
/// Input：       aLISVer ：检验系统版本
/// 			  aHospCode : 医院缩写码
/// 			  aItemType : 同步项目
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultHand).SyncData("V1","3","BTABOBG")
ClassMethod SyncData(aLISVer As %String, aHospCode As %String, aItemType As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aLISVer,aHospCode,aItemType,aDateFrom,aDateTo)
	Set return="入参不完整"
	Quit:(aLISVer="")||(aHospCode="")||(aItemType="") return
	
	Set return="找不到对应方法"
	Set (flg,ClassName,MethodName)=""
	
	If (aLISVer="V1") {
		Set ClassName="Set flg=##class(DHCMed.DCEns.LIS.TSResultByV1)."
	} ElseIf (aLISVer="V2") {
		Set ClassName="Set flg=##class(DHCMed.DCEns.LIS.TSResultByV2)."
	} Else {
	}
	
	Set MethodName="Change"_aItemType_"("_aHospCode_")"
	Set:aItemType="Report" MethodName="SyncRepByDate("_aDateFrom_","_aDateTo_","_aHospCode_")"
	Quit:(ClassName="")||(MethodName="") return
	
	Set valExpress=ClassName_MethodName
	X valExpress
	Set ^DHCMed.LISUpdateTime(aHospCode,aLISVer,aItemType)=$zd(+$H,3)_" "_$zt($p($H,",",2),2)
	
	Set return=flg
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-30
/// Description:  获取检验数据同步时间
/// Table：       ^TTAB()、DHCMed.DC.LIS.*
/// Input：       aLISVer ：检验系统版本
/// 			  aHospCode : 医院缩写码
/// 			  aItemType : 同步项目
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultHand).SyncData("V1","3","Report")
ClassMethod GetUpdateTime(aLISVer As %String, aHospCode As %String, aItemType As %String) As %String
{
	New (aLISVer,aHospCode,aItemType)
	Set return="入参不完整"
	Quit:(aLISVer="")||(aHospCode="") return
	If (aItemType'="") {
		Set LastTime=$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,aItemType))
	} Else {
	Set LastTime=$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"Doctor"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTABOBG"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTAntibiotics"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTOrganism"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTSensitivity"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTSpecimen"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTTestCode"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTTestCodeSC"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTTestSet"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"BTWorkGroup"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"Loc"))
	Set LastTime=LastTime_"^"_$g(^DHCMed.LISUpdateTime(aHospCode,aLISVer,"Report"))
	}
	Set return=LastTime
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-31
/// Description:  获取检验报告数据
/// Table：       DHCMed.DC.LIS.*
/// Input：       aFromDate ：开始日期
/// 			  aToDate : 结束日期
/// 			  aArgument : 同步项目
/// Return：      
/// d ##class(%ResultSet).RunQuery("DHCMed.DCEns.LIS.TSResultHand","QryLabRepInfo","2015-03-09","2015-03-10","100002||A001||1")
Query QryLabRepInfo(aFromDate As %String, aToDate As %String, aArgument As %String) As %Query(ROWSPEC = "ind:%String,TestSetRow:%String,TestSetDesc:%String,SpecimenDesc:%String,LocDesc:%String,CollectDT:%String,AuthDT:%String")
{
}

ClassMethod QryLabRepInfoExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aArgument As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aArgument="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If (aArgument["||") {
		Set TSRowID=aArgument
		Set EpisodeId=""
	} Else {
		Set EpisodeId=aArgument
		Set TSRowID=""
	}
	
	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime))
			Quit:xTime=""
			Set xID=0
			For {
				Set xID=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime,xID))
				Quit:xID=""
				
				Set objLabRep=##class(DHCMed.DC.LIS.LabReport).GetObjById(xID)
				Continue:'$IsObject(objLabRep)
				Continue:objLabRep.IsActive'=1
				Set TestSetNo=objLabRep.TestSetNo
				
				Set IsTestSetRow=0
				Set TestSetRowStr=##class(DHCMed.DC.LIS.LabTestSet).GetTSRowByTSNo(TestSetNo)
				For indRow=1:1:$l(TestSetRowStr,",") {
					Set tTestSetRow=$p(TestSetRowStr,",",indRow)
					Continue:tTestSetRow=""
					Continue:(TSRowID'="")&&(tTestSetRow'=TSRowID)
					Set IsTestSetRow=1
				}
				Continue:IsTestSetRow<1
				
				Set EpisodeNo=##class(DHCMed.DC.LIS.LabReport).GetEpisodeNoByTSNo(TestSetNo)
				Set OEOrdID=""
				Set OEOrdID=$o(^OEORD(0,"EpisNo",EpisodeNo,OEOrdID))
				Continue:OEOrdID=""
				Set Paadm=$p($g(^OEORD(+OEOrdID)),"^",1)
				Continue:(EpisodeId'="")&&(Paadm'=EpisodeId)
				
				Set TestSetDesc=objLabRep.TestSetDesc
				Set SpecimenDesc=objLabRep.SpecimenDR.CName
				Set LocDesc= objLabRep.LocationDR.CName
				Set CollectDT=$zd(objLabRep.ReceiveDate,3)_" "_$zt(objLabRep.ReceiveTime,2)
				Set AuthDT=$zd(objLabRep.AuthDate,3)_" "_$zt(objLabRep.CollectTime,2)
				
				Set Data=$lb(ind,TestSetRow,TestSetDesc,SpecimenDesc,LocDesc,CollectDT,AuthDT)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	
	Quit $$$OK
}

ClassMethod QryLabRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabRepInfoExecute ]
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
