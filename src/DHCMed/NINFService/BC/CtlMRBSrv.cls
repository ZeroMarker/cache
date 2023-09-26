/// 名称:DHCMed.NINFService.BC.CtlMRBSrv
/// 描述: 目标性监测关联信息
/// 编写者：zhufei
/// 编写日期: 2014-06-22
Class DHCMed.NINFService.BC.CtlMRBSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.BC.CtlMRBSrv).GetMRBReportJS("21-DT")
ClassMethod GetMRBReportJS(aSSHospCode As %String) As %String
{
	New (aSSHospCode)
	Set return=0
	Quit:(aSSHospCode="") return
	
	If aSSHospCode="11-XH" {  //北京协和
		Write "<script type='text/javascript' src='../scripts/dhcmed/ninf/BC/CtlAimReport/MDRRep_Gui.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcmed/ninf/BC/CtlAimReport/MDRRep_Event.js'></script>",!
	} Else {                  //统一版本
		Write "<script type='text/javascript' src='../scripts/dhcmed/ninf/BC/CtlAimReport/MRBRep_Gui.js'></script>",!
		Write "<script type='text/javascript' src='../scripts/dhcmed/ninf/BC/CtlAimReport/MRBRep_Event.js'></script>",!
	}
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-22
/// Description:  查询目标性监测(多重耐药)记录
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input:        就诊号
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlMRBSrv","QryMDRReport",3471687)
Query QryMDRReport(aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,ReportID:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,PathDate:%String,SampleTypeID:%String,SampleTypeDesc:%String,PathogenyID:%String,PathogenyDesc:%String,IsolateTypeID:%String,IsolateTypeDesc:%String,HandHygieneID:%String,HandHygieneDesc:%String,SecondaryCasesID:%String,SecondaryCasesDesc:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,RepDateTime:%String,RepStatusID:%String,RepStatusDesc:%String,NINFStationID:%String,NINFStationDesc:%String,DataSource:%String")
{
}

ClassMethod QryMDRReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set RepTypeCode="MDR",RepTypeID=""
	Set objRepType=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType",RepTypeCode,"")
	If $IsObject(objRepType){
		Set RepTypeID=objRepType.%Id()
	}
	Quit:RepTypeID="" $$$OK
	
	Set xTransID=""
	For {
		Set xTransID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID))
		Quit:xTransID=""
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID,xRepID))
			Quit:xRepID=""
			
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"MDR",xSubID))
				Quit:xSubID=""
				
				Set ReportID=xRepID_"||"_xSubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
				}
				
				Set SubData=..BuildMDRData(ReportID)
				Continue:SubData=""
				
				Set ^CacheTemp(repid,ind)=$lb(xRepID,xSubID)_SubData
				Set ind=ind+1
			}
	
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMDRReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMDRReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMDRReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMDRReportExecute ]
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

ClassMethod BuildMDRData(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	
	Set $ZT="BuildMDRDataErr"
	
	Set (PathDate,SampleTypeID,SampleTypeDesc,PathogenyID,PathogenyDesc)=""
	Set (IsolateTypeID,IsolateTypeDesc,HandHygieneID,HandHygieneDesc,SecondaryCasesID,SecondaryCasesDesc)=""
	Set (RepStatusID,RepStatusDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc,NINFStationID,NINFStationDesc)=""
	Set (DataSource)=""
	
	Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(aReportID)
	Quit:'$IsObject(objRepSub) return
	
	Set TransID=objRepSub.ParRef.TransID
	Set TransLocID=objRepSub.ParRef.TransLoc
	Set:TransLocID'="" TransLocDesc=$p($g(^CTLOC(+TransLocID)),"^",2)
	Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
	
	Set objRepStatus=objRepSub.RepStatus
	If $IsObject(objRepStatus) {
		Set RepStatusID=objRepStatus.%Id()
		Set RepStatusDesc=objRepStatus.Description
	}
	
	Set PathDate=objRepSub.PathDate
	Set:PathDate'="" PathDate=$zd(+PathDate,3)
	Set objSampleType=objRepSub.SampleType
	If $IsObject(objSampleType) {
		Set SampleTypeID=objSampleType.%Id()
		Set SampleTypeDesc=objSampleType.Description
	}
	Set objPathogeny=objRepSub.Pathogeny
	If $IsObject(objPathogeny) {
		Set PathogenyID=objPathogeny.%Id()
		Set PathogenyDesc=objPathogeny.Description
	}
	Set objIsolateType=objRepSub.IsolateType
	If $IsObject(objIsolateType) {
		Set IsolateTypeID=objIsolateType.%Id()
		Set IsolateTypeDesc=objIsolateType.Description
	}
	Set objHandHygiene=objRepSub.HandHygiene
	If $IsObject(objHandHygiene) {
		Set HandHygieneID=objHandHygiene.%Id()
		Set HandHygieneDesc=objHandHygiene.Description
	}
	Set objSecondaryCases=objRepSub.SecondaryCases
	If $IsObject(objSecondaryCases) {
		Set SecondaryCasesID=objSecondaryCases.%Id()
		Set SecondaryCasesDesc=objSecondaryCases.Description
	}
	
	Set RepLoc=objRepSub.RepLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc) {
		Set RepLocID=objRepLoc.Rowid
		Set RepLocDesc=objRepLoc.Descs
	}
	Set RepUser=objRepSub.RepUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser) {
		Set RepUserID=objRepUser.Rowid
		Set RepUserDesc=objRepUser.Name
	}
	Set RepDate=objRepSub.RepDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepTime=objRepSub.RepTime
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepDateTime=RepDate_" "_RepTime
	
	Set objNINFStation=objRepSub.NINFStation
	
	If $IsObject(objNINFStation) {
		Set NINFStationID=objNINFStation.%Id()
		Set NINFStationDesc=objNINFStation.Description
	}
	
	Set DataSource=objRepSub.DataSource
	
	Set return=$lb(aReportID,TransID,TransLocID,TransLocDesc,PathDate,SampleTypeID,SampleTypeDesc,PathogenyID,PathogenyDesc)
	Set return=return_$lb(IsolateTypeID,IsolateTypeDesc,HandHygieneID,HandHygieneDesc,SecondaryCasesID,SecondaryCasesDesc)
	Set return=return_$lb(RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime,RepDateTime,RepStatusID,RepStatusDesc,NINFStationID,NINFStationDesc)
	Set return=return_$lb(DataSource)
	
	Quit return
	
BuildMDRDataErr
	Quit ""
}

/// w ##Class(DHCMed.NINFService.BC.CtlMRBSrv).SaveMDRRep("^3471687^3471687||10^102^2014-06-22^2548^1973^785^3884","^")
ClassMethod SaveMDRRep(aInputStr As %String, aSeparete As %String) As %String
{
	new (aInputStr,aSeparete)
	set return=0
	quit:aInputStr="" return
	
	set ReportID   = $p(aInputStr,aSeparete,1)
	set EpisodeID  = $p(aInputStr,aSeparete,2)
	set TransID    = $p(aInputStr,aSeparete,3)
	set TransLoc   = $p(aInputStr,aSeparete,4)
	set PathDate   = $p(aInputStr,aSeparete,5)
	set SampleType = $p(aInputStr,aSeparete,6)
	set Pathogeny  = $p(aInputStr,aSeparete,7)
	set LogLocID   = $p(aInputStr,aSeparete,8)
	set LogUserID  = $p(aInputStr,aSeparete,9)
	set DataSource = $p(aInputStr,aSeparete,10)
	
	set Parref=$p(ReportID,"||",1)
	set SubID=$p(ReportID,"||",2)
	
	set RepTpCode="MDR",RepTpID=""
	if Parref="" {
		set objRepTp=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType",RepTpCode,"")
		if $IsObject(objRepTp){
			set RepTpID=objRepTp.%Id()
		}
		quit:RepTpID="" return
		set Parref=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTpID,EpisodeID,TransID,0))
	}
	
	if Parref="" {
		set inputStr = ""
		set inputStr = inputStr_$c(1)_RepTpCode
		set inputStr = inputStr_$c(1)_EpisodeID
		set inputStr = inputStr_$c(1)_TransID
		set inputStr = inputStr_$c(1)_TransLoc
		set inputStr = inputStr_$c(1)_""
		set inputStr = inputStr_$c(1)_""
		set inputStr = inputStr_$c(1)_""
		set inputStr = inputStr_$c(1)_""
		set inputStr = inputStr_$c(1)_""
		set inputStr = inputStr_$c(1)_LogLocID
		set inputStr = inputStr_$c(1)_LogUserID
		set inputStr = inputStr_$c(1)_""
		
		set flg = ##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(inputStr, $c(1))
		if (+flg>0){
			set Parref = +flg
		}
	}
	quit:Parref="" return
	
	set (IsolateType,HandHygiene,SecondaryCases,NINFStation,StatusCode)=""
	if SubID'="" {
		set objSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
		if $IsObject(objSub){
			if $IsObject(objSub.IsolateType){
				set IsolateType=objSub.IsolateType.%Id()
			}
			
			if $IsObject(objSub.IsolateType){
				set HandHygiene=objSub.HandHygiene.%Id()
			}
			
			if $IsObject(objSub.IsolateType){
				set SecondaryCases=objSub.SecondaryCases.%Id()
			}
			
			if $IsObject(objSub.IsolateType){
				set NINFStation=objSub.NINFStation.%Id()
			}
			
			if $IsObject(objSub.RepStatus){
				set StatusCode=objSub.RepStatus.Code
			}
		}
	}
	set:StatusCode="" StatusCode="2"  //提交状态
	
	set inputStr = Parref
	set inputStr = inputStr_$c(1)_SubID
	set inputStr = inputStr_$c(1)_PathDate
	set inputStr = inputStr_$c(1)_SampleType
	set inputStr = inputStr_$c(1)_Pathogeny
	set inputStr = inputStr_$c(1)_IsolateType
	set inputStr = inputStr_$c(1)_HandHygiene
	set inputStr = inputStr_$c(1)_SecondaryCases
	set inputStr = inputStr_$c(1)_LogLocID
	set inputStr = inputStr_$c(1)_LogUserID
	set inputStr = inputStr_$c(1)_StatusCode
	set inputStr = inputStr_$c(1)_NINFStation
	set inputStr = inputStr_$c(1)_DataSource
	
	set flg = ##Class(DHCMed.NINFService.Rep.AimReportMDR).SaveReport(inputStr, $c(1))
	set return=flg
	
	quit return
}

ClassMethod DelMDRRep(aReportID As %String) As %String
{
	new (aReportID)
	set return=0
	quit:aReportID="" return
	set return=##Class(DHCMed.NINF.Rep.AimReportMDR).DeleteById(aReportID)
	quit return
}

/// w ##Class(DHCMed.NINFService.BC.CtlMRBSrv).GetMDRByCtlRst(521856)
ClassMethod GetMDRByCtlRst(aCtlRstID As %String) As %String
{
	new (aCtlRstID)
	set return=""
	quit:(aCtlRstID="") return
	
	set objResult=##class(DHCMed.CC.CtlResult).GetObjById(aCtlRstID)
	quit:'$IsObject(objResult) return
	
	set EpisodeID=objResult.EpisodeID
	set ObjectID=objResult.ObjectID
	set OccurDate=objResult.OccurDate
	set OccurTime=objResult.OccurTime
	set Epis=$p(ObjectID,"||",1)
	set TS=$p(ObjectID,"||",2)
	set TSCount=$p(ObjectID,"||",3)
	quit:(Epis="")||(TS="")||(TSCount="") return
	set TestSetRow=Epis_"||"_TS_"||"_TSCount
	
	//送检日期
	Set SubmisDate=OccurDate
	Set:SubmisDate'="" SubmisDate=$zd(SubmisDate,3)
	//送检标本
	Set OrdID=$o(^OEORD(0,"EpisNo",Epis,0))
	Set SubID=$o(^OEORD(0,"EpisNo",Epis,+OrdID,0))
	Quit:(OrdID="")||(SubID="") return
	Set OEItemID=OrdID_"||"_SubID
	Set SpecimenCode="",SpecimenDesc=""
	/* update by zf 修改检验医嘱标本取值方法
	Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
	Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
	If SpecimenDesc="" {
		Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
		Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
	}
	*/
	Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrdID_"||"_SubID)
	Set SpecDr=$p(tSpecimenInfo,"^",1)
	Set SpecimenCode=$p(tSpecimenInfo,"^",2)
	Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
	If SpecimenDesc'="" {
		Set SpecimenDesc=##class(DHCMed.NINFService.Srv.CommonCls).GetMapping("XHAIMDicSpecimen",SpecimenDesc,"","*"_SpecimenDesc)
	}
	//多耐名称
	Set MRBPy=objResult.Summary
	Set MRBId="",MRBDesc=""
	For {
		Set MRBId=$o(^DHCMed.NINFD("MRB",MRBId))
		Quit:MRBId=""
		
		Set objMRB=##class(DHCMed.NINF.Dic.MRB).GetObjById(MRBId)
		Quit:'$IsObject(objMRB)
		Set IsActive=objMRB.Active
		Continue:IsActive'=1
		Set tmpMRBDesc=objMRB.Description
		Continue:MRBPy'[tmpMRBDesc
		
		Set MRBDesc=tmpMRBDesc
		Quit:MRBDesc'=""
	}
	If MRBDesc'="" {
		Set MRBDesc=##class(DHCMed.NINFService.Srv.CommonCls).GetMapping("XHAIMDicMRB",MRBDesc,"","*"_MRBDesc)
	}
	
	Set DataSource="CTLOBJ:"_ObjectID
	Set MRBRepID=..GetMRBRepID(EpisodeID,ObjectID)
	
	Set return=SubmisDate_$c(1)_SpecimenDesc_$c(1)_MRBDesc_$c(1)_DataSource_$c(1)_MRBRepID
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.BC.CtlMRBSrv).GetMRBRepID()
ClassMethod GetMRBRepID(aEpisodeID As %String, aObjectID As %String) As %String
{
	New (aEpisodeID,aObjectID)
	Set return=""
	Quit:(aEpisodeID="")||(aObjectID="") return
	
	Set aDataSource="CTLOBJ:"_aObjectID
	
	Set RepTypeCode="MDR",RepTypeID=""
	Set objRepType=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType",RepTypeCode,"")
	If $IsObject(objRepType){
		Set RepTypeID=objRepType.%Id()
	}
	Quit:RepTypeID="" return
	
	Set xTransID=""
	For {
		Set xTransID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID))
		Quit:xTransID=""
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,aEpisodeID,xTransID,xRepID))
			Quit:xRepID=""
			
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"MDR",xSubID))
				Quit:xSubID=""
				
				Set ReportID=xRepID_"||"_xSubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
				}
				
				Set DataSource=objRepSub.DataSource
				Continue:DataSource'=aDataSource
				Set return=ReportID
			}
		}
	}
	
	Quit return
}

}
