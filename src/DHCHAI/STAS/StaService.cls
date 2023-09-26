/// 名称: DHCHAI.STAS.StaService
/// 描述: 统计报表服务
/// 编写者：pylian
/// 编写日期: 2017-08-23
Class DHCHAI.STAS.StaService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-10-11
/// Description:  根据HIS登录科室找对应医院分组下的医院列表
/// Table：       CT_LOC、DHCHAI.BT.Hospital、DHCHAI.BT.HospGroup
/// Input：       aLocID : HIS登录科室ID(CT_LOC.ID)
/// d ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QryHospListByLoc","117")
Query QryHospListByLoc(aLocID As %String) As %Query(ROWSPEC = "ID:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHospListByLocExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Set aHospID=$p($g(^CTLOC(+aLocID)),"^",22)
	Set:aHospID="" aHospID=$o(^CT("HOSP",0))  //部分科室没有关联医院
	Set objHospMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode("HISSYS",aHospID)
	Quit:'$IsObject(objHospMap) $$$OK
	Quit:'$IsObject(objHospMap.BTMapHospDr) $$$OK
    Set HISCode=objHospMap.BTMapHospDr.BTXCode

    Set aHospID=$o(^DHCHAI.BT.HospitalI("IndexXCode",HISCode,0))
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(aHospID)
	Quit:'$IsObject(objHosp) $$$OK
	Quit:'$IsObject(objHosp.BTGroupDr) $$$OK
	Set HospGrpID=objHosp.BTGroupDr.%Id()
	Set HospGrpDesc=objHosp.BTGroupDr.BTDesc
	Quit:HospGrpID="" $$$OK

	Kill arrResult
	Set HospIDs=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",HospGrpID,xID))
		Quit:xID=""
		
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
		Continue:'$IsObject(objHosp)
		Continue:objHosp.BTIsActive'=1
		Set HospCode=objHosp.BTCode
	    Set HospDesc=objHosp.BTDesc
	    Set HospDesc2=objHosp.BTDesc2
		Set:HospDesc2'="" HospDesc=HospDesc2
		
		Set HospIDs=$s(HospIDs="":xID,1:HospIDs_"|"_xID)  //用“,”分割会造成报表输出描述全部院区有问题
		Set arrResult(xID)=$lb(xID,HospDesc)
	}
	
	If HospIDs'=aLocID {
		Set Data=$lb(HospIDs,"全部院区")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set xID=0
	For {
		Set xID=$o(arrResult(xID))
		Quit:xID=""
		Set Data=$g(arrResult(xID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrResult
	
	Quit $$$OK
}

ClassMethod QryHospListByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospListByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospListByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospListByLocExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-09-27
/// Description:  查询同期在院人数/在院天数(全院)
/// Input:        aHospIDs： 多个医院用"|"连接
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期     
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryInPatient","","","2017-07-01","2017-07-03")
Query QryInPatient(aHospIDs As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,Paadm:%String,InCount:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,IsOut:%Integer") [ SqlProc ]
{
}

ClassMethod QryInPatientExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 		
 	Set NIndex="QryInPatient"
	Kill ^TMP($zn,$j,NIndex)
	//同期在院天数
	Set Count=0
	For xDate=aDateFrom:1:aDateTo {	
	 	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(xDate,xDate,aHospIDs,aLocIDs,"I") //某天的在院人数
		For index=1:1:ListArray.Count() {
			Set EpisodeID=ListArray.GetAt(index)	
			Continue:EpisodeID=""
			Set ^TMP($zn,$j,NIndex,EpisodeID)=EpisodeID
			Set Count=$i(^TMP($zn,$j,NIndex,EpisodeID,"InDays"))
		}
		
	}
	
    //同期住院人数
	Set xPaadm="",InCount=0
	For {
		Set xPaadm=$o(^TMP($zn,$j,NIndex,xPaadm))
		Quit:xPaadm="" 
		
		Set PatData=..BuildPaadmData(xPaadm)
		Continue:PatData="" 
		Set DischDate=$lg(PatData,14)
		Set:DischDate'="" DischDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DischDate)
		Set IsOut=0         //查询时段是否出院	
		If (DischDate'="")&&((DischDate>=aDateFrom)&&(DischDate<=aDateTo)) {
			Set IsOut =1
		}
      	Set InCount=$g(^TMP($zn,$j,NIndex,xPaadm,"InDays"))
      	Set Data=$lb(ind,xPaadm,InCount)_PatData_$lb(IsOut)  
        Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInPatientExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-09-27
/// Description:  查询同期在科人数(科室/病区)
///               同一个病人一次就诊多次入住同一科室/病区记为一人
///               一天内多次转科(转入同一科)记为最初所在科室
/// Input:        aHospIDs： 多个医院用"|"连接
///         	  aLocType： 科室E、病区W
///               aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期       
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryInLocAdm","","E","54","2017-12-01","2017-12-21")
Query QryInLocAdm(aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,LocID:%String,LocDesc:%String,Paadm:%String,InCount:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryInLocAdmExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocType As %String = "", aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
 	
    Set NIndex="QryInLocAdm"
	Kill ^TMP($zn,$j,NIndex)

    //同期在科天数
    Set Count=0,num=0
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,aLocType,"","I") //某段时间的在科人数
    For index=1:1:ListArray.Count() {
		Set TransInfo=ListArray.GetAt(index)	
		Continue:TransInfo=""	
		Set Date   = $LIST(TransInfo,1)
		Set Paadm  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Set num=$i(^TMP($zn,$j,NIndex,Date,Paadm,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
        Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
        Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,objLoc.BTHospDr.%Id())<1)  //按医院过滤	
		Set ^TMP($zn,$j,NIndex,LocID,Paadm)=Paadm
		Set Count=$i(^TMP($zn,$j,NIndex,LocID,Paadm,"InDays"))		
    }
   
	//同期在科人数
	Set xLocID="",InCount=0
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,xLocID))
		Quit:xLocID=""
	
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set xLocDesc=objLoc.BTDesc2
		Set:xLocDesc="" xLocDesc=objLoc.BTDesc
		Set xPaadm=""
		For {
			Set xPaadm=$o(^TMP($zn,$j,NIndex,xLocID,xPaadm))
			Quit:xPaadm=""
			
	        Set PatData=..BuildPaadmData(xPaadm)
			Continue:PatData="" 
          	Set InCount=$g(^TMP($zn,$j,NIndex,xLocID,xPaadm,"InDays"))  	
          	Set Data=$lb(ind,xLocID,xLocDesc,xPaadm,InCount)_PatData
            Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInLocAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInLocAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInLocAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInLocAdmExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	Quit:(AdmType'="I")&&(AdmType'="EP") return
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set return = $lb(PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-25
/// Description:  住院患者体温异常血培养送检率
/// Input:        aHospID： 院区ID
/// 			  aLocID：   科室
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryFeverAbnoBlood","1|2","","2017-11-01","2018-01-09","HIS01")
Query QryFeverAbnoBlood(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aSCode As %String) As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,LocDr:%String,LocDesc:%String,AbnoFlg:%String,SubmitFlg:%String") [ SqlProc ]
{
}

ClassMethod QryFeverAbnoBloodExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aSCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	//出院患者
	Set DischDateIndex=##class(DHCHAI.IO.FromAdmSrv).GetDischDateIndex()  //取出院时间索引
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=0
		For {
			Set xEpisodeID=$o(^PAADMi(DischDateIndex,xDate,xEpisodeID))
			Quit:xEpisodeID=""
		
			Set xEpisodeID=aSCode_"||"_xEpisodeID
			Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(xEpisodeID)
			Continue:'$IsObject(objAdm)
			Set AdmLocDr  = objAdm.PAAdmLocDr
			Continue:'$IsObject(AdmLocDr)
			Set LocDr     = AdmLocDr.%Id()
			Continue:(aLocID'="")&&(aLocID'=LocDr)
			if $IsObject(AdmLocDr.BTHospDr){
				Continue:(aHospIDs'="")&($listfind(aHospIDs,AdmLocDr.BTHospDr.%Id())<1)
			}
			Set LocDesc   = AdmLocDr.BTDesc2
			Set:LocDesc="" LocDesc=AdmLocDr.BTDesc
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			
			Set EpisodeDr =  objAdm.%Id()
			Set AbnoFlg   =..CheckFeverAbno(EpisodeDr,aDateFrom,xDate)
			Continue:AbnoFlg'=1    // 过滤非体温异常患者
			Set SubmitFlg =..CheckBloodSub(EpisodeDr,aDateFrom,xDate)
			
			Set Data=$lb(ind,EpisodeDr,LocDr,LocDesc,AbnoFlg,SubmitFlg)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	// 最后一天在科患者
	// 按出科日期算，不算入科日期
	Set xTransDays=""
	For {
		Set xTransDays = $o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysOutDate","W",xTransDays))
		Quit:xTransDays=""
	
		Set xOutDate = $s(xTransDays>-1:aDateTo-1,"1":"")
		For {
			Set xOutDate = $o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysOutDate","W",xTransDays,xOutDate))
			Quit:xOutDate=""
			Continue:(xTransDays>0)&&((xOutDate-xTransDays)>aDateTo)	//已出科但是入科日期在查询时间之外
		
			Set xTransID = ""
			For {
				Set xTransID = $o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysOutDate","W",xTransDays,xOutDate,xTransID))
				Quit:xTransID=""
			
				Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
				Continue:'$isobject(objTrans)
				Continue:'$isobject(objTrans.PATransLocDr)
				Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
				Continue:'$isobject(objTrans.PAEpisodeDr)
				Set TransDate = objTrans.PATransDate
				Continue:(xTransDays<0)&&(TransDate>aDateTo)	//在科但是入科日期在结束日期之后
				
				Set LocDr = objTrans.PATransLocDr.%Id()
				Continue:(aLocID'="")&&(aLocID'=LocDr)
				if $IsObject(objTrans.PATransLocDr.BTHospDr){
					Continue:(aHospIDs'="")&($listfind(aHospIDs,objTrans.PATransLocDr.BTHospDr.%Id())<1)
				}
				Set LocDesc   = objTrans.PATransLocDr.BTDesc2
				Set:LocDesc="" LocDesc = objTrans.PATransLocDr.BTDesc
				Set:LocDesc["-" LocDesc= $p(LocDesc,"-",2)
			
				Set EpisodeDr = objTrans.PAEpisodeDr.%Id()
				Set AbnoFlg   =..CheckFeverAbno(EpisodeDr,aDateFrom,aDateTo)
				Continue:AbnoFlg'=1    // 过滤非体温异常患者
				Set SubmitFlg =..CheckBloodSub(EpisodeDr,aDateFrom,aDateTo)
				
				Set Data=$lb(ind,EpisodeDr,LocDr,LocDesc,AbnoFlg,SubmitFlg)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryFeverAbnoBloodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeverAbnoBloodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFeverAbnoBloodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeverAbnoBloodExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-09-25
/// Description:  判断是否进行血培养送检
/// Return：      1：送检    0：未送检
/// w ##class(DHCHAI.STAS.StaService).CheckBloodSub(2103,"2017-08-01","2017-08-29")
ClassMethod CheckBloodSub(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Submit")
    Quit:'$IsObject(objItmMast) return
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" return
    
    For xDate=aDateFrom:1:aDateTo {
	    Quit:return=1
 		Set xID=0
		For {
	 		Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,ItemID,xDate,xID))
	 		Quit:(xID="")||(return=1)
	 		Set objRtl=##class(DHCHAI.IR.CCResult).GetObjById(xID)
	 		Continue:'$IsObject(objRtl)
			Continue:objRtl.CCIsActive'=1
	 		Set CCSpecimen = objRtl.CCSpecimen
	 		Continue:CCSpecimen'["血"
	 		Set return=1
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-25
/// Description:  判断体温异常
/// Return：      1：体温异常    0：体温正常
/// w ##class(DHCHAI.STAS.StaService).CheckFeverAbno(2103,"2017-08-01","2017-08-29")
ClassMethod CheckFeverAbno(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsFever")
    Quit:'$IsObject(objItmMast) return
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" return
    
	For xDate=aDateFrom:1:aDateTo {
		Quit:return=1
 		Set xID=0
		For {
	 		Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,ItemID,xDate,xID))
	 		Quit:(xID="")||(return=1)
	 		Set objRtl=##class(DHCHAI.IR.CCResult).GetObjById(xID)
	 		Continue:'$IsObject(objRtl)
			Continue:objRtl.CCIsActive'=1
	 		Set objKey = objRtl.CCKeyWordDr
	 		Continue:'$IsObject(objKey)
 			Set CCDesc = objKey.CCDesc
 			Continue:CCDesc'="发热"
 			// 排除术后72小时内的异常体温记录
 			Set OperFlg =..CheckOper(aEpisodeID,(xDate-3),xDate)
 			Continue:OperFlg=1
 			Set return=1
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-26
/// Description:  判断一段时间内是否有手术
/// Return：      1：有    0：无
/// w ##class(DHCHAI.STAS.StaService).CheckOper(2103,"2017-08-01","2017-08-29")
ClassMethod CheckOper(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeID="") return
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate))
		Quit:(xDate="")||(return=1)
		Quit:xDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeID,xDate,xID))
			Quit:(xID="")||(return=1)
			
			Set objOperAnaes=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
			Continue:'$IsObject(objOperAnaes)
			Continue:objOperAnaes.ORIsActive'=1
			Continue:'$IsObject(objOperAnaes.OREpisodeDr)
			Set Incision=objOperAnaes.ORIncision       //手术切口类型
			Continue:Incision=""
			Set return=1
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-23
/// Description:  漏报查询       
/// Input:        aHospIDs：多个医院用"|"连接
/// 			  aLocID：科室
/// 			  aDateFrom：查询开始日期
/// 			  aDateTo：查询结束日期
/// D ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QryInfMissing","1|2","","2017-12-01","2017-12-21")
Query QryInfMissing(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,LocID:%Integer,LocDesc:%String,EpisodeID:%String,PapmiNo:%String,PatName:%String,AdmDate:%String,DischDate:%String,IsNeed:%Integer,IsRep:%Integer,IsMiss:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfMissingExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	/*  //调整为统一查询接口
	For xDate=aDateFrom:1:aDateTo {
			Set xTime=""
			For {
				Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime))
				Quit:xTime=""
				Set xPaadm = ""
				For {
					Set xPaadm=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime","I",xDate,xTime,xPaadm))
					Quit:xPaadm=""
					Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
					Continue:'$IsObject(objPaadm)
					Set (IsNeed,IsRep,IsMiss)="0"  //需上报 已报 漏报
					Set IsNeed = ##class(DHCHAI.IRS.CCScreeningSrv).GetEpisodeStatus(xPaadm)
					Set IsRep = ##class(DHCHAI.IRS.INFReportSrv).GetInfReportStatus(xPaadm)
					Set:(IsNeed="1")&&(IsRep'="1") IsMiss ="1"	
									
					Set xTDate ="" //转科日期
					For {
						//转科表数据 按科室+转科日期分组计数
						Set xTDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",xPaadm,xTDate))
						Quit:xTDate=""
						Set xTransID =""
						For {
							Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",xPaadm,xTDate,xTransID))
							Quit:xTransID=""
							Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
							Continue:'$IsObject(objTrans)	
							Continue:'$IsObject(objTrans.PATransLocDr)
							Continue:(aLocID'="")&&(objTrans.PATransLocDr.%Id()'=aLocID)
							Set LocType = objTrans.PATransLocDr.BTTypeDr				
							Set objHosp = objTrans.PATransLocDr.BTHospDr
							
							Continue:'$IsObject(objHosp)
							Continue:(aHospIDs'="")&($listfind(aHospIDs,objHosp.%Id())<1)  //医院过滤
							Continue:'$IsObject(LocType)
							Continue:LocType.BTCode'="E"    //非执行科室排除						
							Set Data=$lb(ind,objTrans.PATransLocDr.%Id(),objTrans.PATransLocDr.BTDesc2)
							Set AdmDate = objTrans.PATransDate
							Set DisDate = objTrans.PAOutLocDate
							Set:AdmDate'="" AdmDate = $zd(AdmDate,3)
							Set:DisDate'="" DisDate = $zd(DisDate,3)
														
							Set Data=Data_$lb(objPaadm.%Id(),objPaadm.PAMrNo,objPaadm.PAPatName,AdmDate,DisDate)
							Set Data=Data_$lb(IsNeed,IsRep,IsMiss)
							Set ^CacheTemp(repid,ind)=Data
    						Set ind=ind+1
						}
					}
				}
			}
	}	
	*/
	Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(aDateFrom,aDateTo,"E",aLocID,"I")
	FOR index=1:1:RstEpisArr.Count() {
		Set TransInfo=RstEpisArr.GetAt(index)
		Set xPaadm = $LIST(TransInfo,1)
		Set TransLocDr = $LIST(TransInfo,2)
		Set xTransID = $LIST(TransInfo,3)
		
		Quit:xTransID=""
		Set objTrans = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
		Continue:'$IsObject(objTrans)	
		Continue:'$IsObject(objTrans.PATransLocDr)
		Continue:(aLocID'="")&&(objTrans.PATransLocDr.%Id()'=aLocID)
		Set LocType = objTrans.PATransLocDr.BTTypeDr
		Set objHosp = objTrans.PATransLocDr.BTHospDr
		Continue:'$IsObject(objHosp)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,objHosp.%Id())<1) //医院过滤 
		
		Continue:'$IsObject(LocType)
		Continue:LocType.BTCode'="E"    //非执行科室排除
		Set LocDesc=objTrans.PATransLocDr.BTDesc2
		Set:LocDesc="" LocDesc=objTrans.PATransLocDr.BTDesc
		Continue:LocDesc=""
		Set Data=$lb(ind,objTrans.PATransLocDr.%Id(),LocDesc)
		Set AdmDate = objTrans.PATransDate
		Set DisDate = objTrans.PAOutLocDate
		//Set:AdmDate'="" AdmDate = $zd(AdmDate,3)
		//Set:DisDate'="" DisDate = $zd(DisDate,3)
		Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set:DisDate'="" DisDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DisDate)
		
		Quit:xPaadm=""
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
		Continue:'$IsObject(objPaadm)
		Set (IsNeed,IsRep,IsMiss)="0"  //需上报 已报 漏报
		
		Set OmissionIsFollow=##class(DHCHAI.BT.Config).GetValByCode("OmissionIsFollow",objHosp.%Id())
		Set xScreenID = ""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",xPaadm,xScreenID))
			Quit:xScreenID=""
			Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			If (+objScreen.CSStatus=1){
				Set IsNeed=1
				Quit
			}
			//检查日志中是否有确诊历史
			If (IsNeed=0)&&(OmissionIsFollow="1"){
				Set xScreenLogSub=""
				For {
					Set xScreenLogSub=$o(^DHCHAI.IR.CCScreeningI("Log","IndexParref",xScreenID,xScreenLogSub))
					Quit:xScreenLogSub=""
					Set objScreenLog=##class(DHCHAI.IR.CCScreenLog).GetObjById(xScreenID_"||"_xScreenLogSub)
					Continue:'$IsObject(objScreenLog)
					If objScreenLog.CSStatus=1{
						Set IsNeed=1
						Quit
					}
				}
			}
			Quit:IsNeed=1
		}
		Continue:IsNeed=0
		Set IsRep = ##class(DHCHAI.IRS.INFReportSrv).GetInfReportStatus(xPaadm)
		Set:(IsNeed="1")&&(IsRep'="1") IsMiss ="1"
		
		Set Data=Data_$lb(objPaadm.%Id(),objPaadm.PAMrNo,objPaadm.PAPatName,AdmDate,DisDate)
		Set Data=Data_$lb(IsNeed,IsRep,IsMiss)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfMissingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfMissingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfMissingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfMissingExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-08-23
/// Description:  查询所有现患率调查执行记录
/// Input：       
/// output:       
/// D ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QrySurvExec","2")
Query QrySurvExec(aHospIDs As %String, aSurvMethod As %String = "", aFromDate As %String = "", aToDate As %String = "") As %Query(ROWSPEC = "ind:%String,RowID:%String,SurvNumber:%String,HospCode:%String,HospDesc:%String,SurvMethod:%String,SurvSttDate:%String,SurvEndDate:%String") [ SqlProc ]
{
}

ClassMethod QrySurvExecExecute(ByRef qHandle As %Binary, aHospIDs As %String, aSurvMethod As %String = "", aFromDate As %String = "", aToDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit $$$OK
}

ClassMethod QrySurvExecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurvExecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QrySurvExecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurvExecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-23
/// Description:  查询感染现患（例次）率
/// Input:        aHospIDs：多个医院用"|"连接
/// 			  aSurvNumber：调查编号
/// 			  aSurvLoc：科室
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QrySurvRec","2","201609220005","")
Query QrySurvRec(aHospIDs As %String, aSurvNumber As %String, aSurvLoc As %String) As %Query(ROWSPEC = "RowID:%String,SurvNumber:%String,SurvDate:%String,SurvDept:%String,SurvDeptDesc:%String,SurvWard:%String,SurvWardDesc:%String,ReportID:%String,IsInf:%Integer,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,AdmDays:%String") [ SqlProc ]
{
}

ClassMethod QrySurvRecExecute(ByRef qHandle As %Binary, aHospIDs As %String, aSurvNumber As %String, aSurvLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit $$$OK
}

ClassMethod QrySurvRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurvRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QrySurvRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurvRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set index=$LIST(qHandle,3)
 	Set index=$o(^CacheTemp(repid,index))
 	If index="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,index)
 	}
 	s qHandle=$lb(AtEnd,repid,index)

	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-10-31
/// Description:  根据就诊ID、日期取检验送检记录
/// Table：       DHCHAI.DP.LabVisitNumber
/// Input：       aEpisodeID : 就诊ID
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
/// Return：      返回%List
/// w ##class(DHCHAI.STAS.StaService).GetVisitNumber("4710","2017-07-01","2017-07-10")
ClassMethod GetVisitNumber(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="")||(aDateFrom="")||(aDateTo="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	
	Set $ZT="GetVisitNumberErr"
	Set NIndex="VisitNumber"
    Kill ^TMP($zn,$j,NIndex)
    
    Set Count=0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeID,xSCode))
		Quit:xSCode=""
		
	    Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeID,xSCode,xDate))
			Quit:xDate=""
			Quit:(xDate>aDateTo)
           
			Set xLabNumID=""
			For {
				Set xLabNumID=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeID,xSCode,xDate,xLabNumID))
				Quit:xLabNumID=""

				Set objLabNum=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xLabNumID)
				Continue:'$IsObject(objLabNum)
				Continue:objLabNum.LabIsActive'=1
				Set EpisodeNo=objLabNum.LabEpisodeNo  //检验号/标本号
				Set LocDr=objLabNum.LabLocDr.%Id()    //送检科室
			    Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
				Continue:'$IsObject(objLoc)
				Continue:'$IsObject(objLoc.BTHospDr)
			    
			    Set SCode    = objLabNum.LabSCode
				Set Specimen = objLabNum.LabSpecimen
				Set RecDate  = objLabNum.LabRecDate      //接收日期
				Set RecTime  = objLabNum.LabRecTime      //接收时间
				    
			    Set DataInfo=$lb(xLabNumID,EpisodeNo,Specimen,RecDate,RecTime)
				Set Count=Count+1
				Do return.SetAt(DataInfo,Count)	
			}	
		}
	}
	Quit return
	
GetVisitNumberErr
	Set aMsgErr=$Zerror
	Kill ^TMP($zn,$j,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-10-31
/// Description:  根据送检标本取检验结果(排除污染标本)
/// Table：       DHCHAI_DP.LabVisitReport,DHCHAI_DP.LabVisitRepResult
/// Input：       aVisitRepID : 检验报告ID
/// Return：      返回%List
/// w ##class(DHCHAI.STAS.StaService).GetVisitRepResult("759698")
ClassMethod GetVisitRepResult(aVisitRepID As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aVisitRepID,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aVisitRepID="") return
	
	Set $ZT="GetVisitRepResultErr"
	
	Set NIndex="RepResult"
    Kill ^TMP($zn,$j,NIndex)
    
	Set num=0
	Set xTestSetDr=""
	For {
		Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitRepID,xTestSetDr),"-1")
		Quit:xTestSetDr=""
	   
		//最新报告
		Set xLabRepOrder="",Flg=0
		For {
			Set xLabRepOrder=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitRepID,xTestSetDr,xLabRepOrder))
			Quit:xLabRepOrder=""
			Quit:Flg=1
	        
			Set xLabRepID="",ResultList=""
			For {
				Set xLabRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",aVisitRepID,xTestSetDr,xLabRepOrder,xLabRepID))
				Quit:xLabRepID=""
			    
				Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xLabRepID)
				Continue:'$IsObject(objReport)
				Set Status = objReport.LabStatus
				//Continue:Status=6	//作废
				Set IsActive = objReport.LabIsActive
				Continue:IsActive=0
				Set ReportID=objReport.%Id()
			    Set TSReportID=objReport.LabReportID  //检验报告号
	            Set AuthDate=objReport.LabAuthDate
	            Set AuthTime=objReport.LabAuthTime
	            Set TestSetRow=objReport.LabTestSetRow
	            Set SCode=objReport.LabSCode
	            Set objTestSet=objReport.LabTestSetDr
				Continue:'$IsObject(objTestSet)
	            Set OrdTSDesc=objTestSet.LabOrdTSDesc
	            Set TestSetDesc=objTestSet.LabTestSetDesc
				Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
				Continue:'$IsObject(objTestSetMap) 
				Continue:'$IsObject(objTestSetMap.BTMapItemDr)
				Continue:'$IsObject(objTestSetMap.BTMapItemDr.BTCatDr)
				Set MapTSDesc=objTestSetMap.BTMapItemDr.BTTestSet
				Set MapTSCatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
				Continue:MapTSCatDesc'="微生物送检"

				If (xLabRepID=ReportID) {
					Set Flg=1 
					Set xResultID=""
					For {
						Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xLabRepID,xResultID))
						Quit:xResultID=""
						Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
						Continue:'$IsObject(objResult)
						Set RstFormat=objResult.LabRstFormat
						Continue:RstFormat=""
						Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
						Continue:MapRstFormat=""
						Continue:MapRstFormat'="M"
						Set Bacteria=objResult.LabResult
						Continue:Bacteria=""
						Continue:(Bacteria["阴性")||(Bacteria["-")
						Continue:(Bacteria["大于3种菌")
						Continue:(Bacteria["无")&&(Bacteria["生长")
						Continue:(Bacteria["未见")&&(Bacteria["菌")
						Continue:(Bacteria["未检出")&&(Bacteria["菌")
						Continue:$listfind(ResultList,Bacteria)>0  //判断是否同种菌
						Set ResultList=ResultList_$lb(Bacteria)
                      
                        Set num=$i(^TMP($zn,$j,NIndex,ReportID))
                        Set ^TMP($zn,$j,NIndex,ReportID,xResultID)=xResultID
					}
				}
			}
		}
	}
	Set xReportID="",Count=0,Num=0
	For {
		Set xReportID=$o(^TMP($zn,$j,NIndex,xReportID))
		Quit:xReportID=""
		Set Num=$g(^TMP($zn,$j,NIndex,xReportID))
		Continue:Num>=3
	
		Set xResultID=""
		For {
			Set xResultID=$o(^TMP($zn,$j,NIndex,xReportID,xResultID))
			Quit:xResultID=""
          	
		    Set DataInfo=$lb(xReportID,xResultID)
			Set Count=Count+1
			Do return.SetAt(DataInfo,Count)		
		}
	}
	Quit return
	
GetVisitRepResultErr
	Set aMsgErr=$Zerror
	Kill ^TMP($zn,$j,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：		pylian
/// CreateDate：	2017-08-24
/// Description:	采集日期查询检验报告病原体(医院感染病原体构成比、革兰氏阴/阳性菌占比)
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryPathogeny","2|1","W","","2017-05-01","2017-09-24")
Query QryPathogeny(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,LabNumID:%String,EpisodeNo:%String:%String,Specimen:%String,ReportID:%String,ResultID:%String,RecDate:%String,RecTime:%String,BacID:%String,BacCode:%String,BacDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPathogenyExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
 	/*	
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""
	*/
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
     
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
	
		Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set ResultList=""
	    Set ListVisitArray=..GetVisitNumber(xEpisodeID,aDateFrom,aDateTo)
		For indx=1:1:ListVisitArray.Count() {
		    Set VisitInfo=ListVisitArray.GetAt(indx)	
			Continue:VisitInfo=""
			Set LabNumID  = $LIST(VisitInfo,1)
			Set EpisodeNo = $LIST(VisitInfo,2)
			Set Specimen  = $LIST(VisitInfo,3)			
			Set RecDate   = $LIST(VisitInfo,4)	 //接收日期
			Set RecTime   = $LIST(VisitInfo,5)   //接收时间
		    Set IPHour=((RecDate-AdmDate)*24)+((RecTime-AdmTime)\3600)  //排除CA
			Continue:IPHour<48

			//采集病区
			Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,RecDate,RecTime)
		    Set LocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
			Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
		   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objRecLoc)
		    Set LocDesc=objRecLoc.BTDesc2
		    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
			//Continue:'$IsObject(objRecLoc.BTHospDr)
			//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	
			Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
			Set:RecTime'="" RecTime=$zt(RecTime)

			Set ListResultArray=..GetVisitRepResult(LabNumID)
			For indy=1:1:ListResultArray.Count() {
		    	Set ResultInfo=ListResultArray.GetAt(indy)
		    	Continue:ResultInfo=""
				Set ReportID = $LIST(ResultInfo,1)
				Set ResultID = $LIST(ResultInfo,2)
				Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(ReportID)
				Continue:'$IsObject(objReport)	
			    Set TSReportID=objReport.LabReportID  //检验报告号
	            Set SCode=objReport.LabSCode
	            
				Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set Bacteria  = objResult.LabResult
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1                     
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/

				Set CatID="",CatCode="",CatDesc=""
				Set TypeID="",TypeCode="",TypeDesc=""
				Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BacID)
				Continue:'$Isobject(objBact)
				If $IsObject(objBact.BTCatDr){
					Set CatID   = objBact.BTCatDr.%Id()
					Set CatCode = objBact.BTCatDr.BTCode
					Set CatDesc = objBact.BTCatDr.BTDesc
				}
				If $IsObject(objBact.BTTypeDr){
					Set TypeID   = objBact.BTTypeDr.%Id()
					Set TypeCode = objBact.BTTypeDr.BTCode
					Set TypeDesc = objBact.BTTypeDr.BTDesc
				}
				Set AbFlag    = objResult.LabAbFlag
				Set MDRResult = objResult.LabMDRResult
			
				Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,LabNumID,EpisodeNo,Specimen,ReportID,ResultID,RecDate,RecTime,BacID,BacCode,BacDesc,CatID,CatCode,CatDesc,TypeID,TypeCode,TypeDesc)
				Set ^CacheTemp(repid,ind)=$lb(ind)_Data
				Set ind=ind+1			
			}
		}
	}	

	Quit $$$OK
}

ClassMethod QryPathogenyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathogenyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathogenyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathogenyExecute ]
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

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询检验报告病原体药敏结果(医院感染病原体对抗菌药物的耐药率)
///                 统计病原体感染类型为HA，HA例次与医院感染例次一致
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRepRstSen","2|1","W","","2017-05-01","2017-09-24")
Query QryRepRstSen(aHospIDs As %String = "", aLocType As %String, aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,LabNumID:%String,EpisodeNo:%String,Specimen:%String,ReportID:%String,ResultID:%String,BacID:%String,BacCode:%String,BacDesc:%String,RecDate:%String,RecTime:%String,AntDesc:%String,MapTestSen:%String") [ SqlProc ]
{
}

ClassMethod QryRepRstSenExecute(ByRef qHandle As %Binary, aHospIDs As %String = "", aLocType As %String, aLocIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")
	/*
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""
		*/
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
			
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
	     
	    Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set ResultList=""
	    Set ListVisitArray=..GetVisitNumber(xEpisodeID,aDateFrom,aDateTo)
		For indx=1:1:ListVisitArray.Count() {
		    Set VisitInfo=ListVisitArray.GetAt(indx)	
			Continue:VisitInfo=""
			Set LabNumID  = $LIST(VisitInfo,1)
			Set EpisodeNo = $LIST(VisitInfo,2)
			Set Specimen  = $LIST(VisitInfo,3)			
			Set RecDate   = $LIST(VisitInfo,4)	 //接收日期
			Set RecTime   = $LIST(VisitInfo,5)   //接收时间
		    Set IPHour=((RecDate-AdmDate)*24)+((RecTime-AdmTime)\3600)  //排除CA
			Continue:IPHour<48
			
			//采集病区
			Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,RecDate,RecTime)
		      Set LocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
			Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
		   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objRecLoc)
		    Set LocDesc=objRecLoc.BTDesc2
		    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
			//Continue:'$IsObject(objRecLoc.BTHospDr)
			//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	
			Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
			Set:RecTime'="" RecTime=$zt(RecTime)
	
			Set ListResultArray=..GetVisitRepResult(LabNumID)
			For indy=1:1:ListResultArray.Count() {
		    	Set ResultInfo=ListResultArray.GetAt(indy)
		    	Continue:ResultInfo=""
				Set ReportID = $LIST(ResultInfo,1)
				Set ResultID = $LIST(ResultInfo,2)
				Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(ReportID)
				Continue:'$IsObject(objReport)	
			    Set TSReportID=objReport.LabReportID  //检验报告号
	            Set SCode=objReport.LabSCode
	            
				Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set Bacteria  = objResult.LabResult
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1                     
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/
				
			    Set xSenID = ""
				For {
			    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
			    	Quit:xSenID=""
					
					Set objSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
					Continue:'$isobject(objSen)
					Set AntCode = objSen.LabAntCode
					Set AntDesc = objSen.LabAntDesc
                    Continue:AntDesc=""
					Set TestSen = objSen.LabSensitivity
					Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
				 
					Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,LabNumID,EpisodeNo,Specimen,ReportID,ResultID,BacID,BacCode,BacDesc,RecDate,RecTime,AntDesc,MapTestSen)
					Set ^CacheTemp(repid,ind)=$lb(ind)_Data
					Set ind=ind+1
				}
			}
		}
	}	
			
	Quit $$$OK
}

ClassMethod QryRepRstSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepRstSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepRstSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepRstSenExecute ]
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

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询监控结果多重耐药菌药敏(多重耐药医院感染病原体对抗菌药物的耐药率)
///                 统计病原体感染类型为HA，HA例次与医院感染例次一致
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRstMRBSen","2|1","W","","2017-05-01","2017-10-24")
Query QryRstMRBSen(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,ResultID:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,SenID:%String,AntDesc:%String,MapTestSen:%String") [ SqlProc ]
{
}

ClassMethod QryRstMRBSenExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
		
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
    //Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")	 	

    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
     /*
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""	 
   */
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))	
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
	
	    Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set xDate=aDateFrom-1,ResultList=""
		For {
	 		Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate))
			Quit:xDate=""
	    	Quit:(xDate>aDateTo)   //日期控制？
	    	
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate,xID))
				Quit:xID=""
			
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Continue:'$Isobject(objResult.CCMRBTpDr)
				Set ActDate=objResult.CCActDate
				Set ActTime=objResult.CCActTime
				Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA?
				Continue:IPHour<48
			    
			    //采集病区
			    Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,ActDate,ActTime)
			    Set LocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
				Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
			   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
				Continue:'$IsObject(objRecLoc)
			    Set LocDesc=objRecLoc.BTDesc2
			    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
				//Continue:'$IsObject(objRecLoc.BTHospDr)
				//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	

				Set MRBID=objResult.CCMRBTpDr.%Id()
				Set MRBDesc = objResult.CCMRBTpDr.BTDesc
				Set MRBCode = objResult.CCMRBTpDr.BTCode
				Set LocID="", LocCode="", LocDesc=""
				If $IsObject(objResult.CCActLocDr){
					Set LocID =  objResult.CCActLocDr.%Id()
					Set LocCode = objResult.CCActLocDr.BTCode
					Set LocDesc = objResult.CCActLocDr.BTDesc2
				}
				Set SCode    = objResult.CCSCode      //子系统代码
		        Set Specimen = objResult.CCSpecimen   //原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
		        If $IsObject(objSpe) {
			        If $IsObject(objSpe.BTMapItemDr){
						Set SpeID=objSpe.BTMapItemDr.%Id()
						Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
						Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
					}
		        }
		     
				Set Bacteria  = objResult.CCBacteria 
				Continue:Bacteria=""
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1                     
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/
		
				Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
			    Set xSenID = ""
				For {
			    	Set xSenID =$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
			    	Quit:xSenID=""
					
					Set objSen = ##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
					Continue:'$Isobject(objSen)
					Set AntCode = objSen.LabAntCode
					Set AntDesc = objSen.LabAntDesc
                    Continue:AntDesc=""
					Set TestSen = objSen.LabSensitivity
					Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
			
					Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,ResultID,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDate,ActTime,xSenID,AntDesc,MapTestSen)
					Set ^CacheTemp(repid,ind)=$lb(ind)_Data
					Set ind=ind+1
					
				}
			}
		}
	}	
	Quit $$$OK
}

ClassMethod QryRstMRBSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRstMRBSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRstMRBSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRstMRBSenExecute ]
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

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询检验报告病原体结果(多重耐药菌检出率)
///                 统计病原体感染类型为HA/CA/定值/HA重复/CA重复/定值重复，排除污染类型
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryMRBRst","2|1","W","","2017-05-01","2017-10-31")
Query QryMRBRst(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,LabNumID:%String,EpisodeNo:%String,Specimen:%String,ReportID:%String,ResultID:%String,BacID:%String,BacCode:%String,BacDesc:%String,MDRResult:%String,RecDate:%String,RecTime:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,FlgID:%String") [ SqlProc ]
{
}

ClassMethod QryMRBRstExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
    //Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")	 	

 	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
   
    Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""

		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
			
		Set ListVisitArray=..GetVisitNumber(xEpisodeID,aDateFrom,aDateTo)
		For indx=1:1:ListVisitArray.Count() {
		    Set VisitInfo=ListVisitArray.GetAt(indx)	
			Continue:VisitInfo=""
			Set LabNumID  = $LIST(VisitInfo,1)
			Set EpisodeNo = $LIST(VisitInfo,2)
			Set Specimen  = $LIST(VisitInfo,3)			
			Set RecDate   = $LIST(VisitInfo,4)	 //接收日期
			Set RecTime   = $LIST(VisitInfo,5)   //接收时间
				
			//采集病区
			Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,RecDate,RecTime)
		    Set LocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
			Continue:(aLocIDs'="")&($listfind(aLocIDs,LocID)<1)  //按科室过滤
		   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objRecLoc)
		    Set LocDesc=objRecLoc.BTDesc2
		    Set:LocDesc="" LocDesc=objRecLoc.BTDesc
			//Continue:'$IsObject(objRecLoc.BTHospDr)
			//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	
			Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
			Set:RecTime'="" RecTime=$zt(RecTime)
	
			Set ListResultArray=..GetVisitRepResult(LabNumID)
			For indy=1:1:ListResultArray.Count() {
		    	Set ResultInfo=ListResultArray.GetAt(indy)
		    	Continue:ResultInfo=""
				Set ReportID = $LIST(ResultInfo,1)
				Set ResultID = $LIST(ResultInfo,2)
				Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(ReportID)
				Continue:'$IsObject(objReport)	
			    Set TSReportID=objReport.LabReportID  //检验报告号
	            Set SCode=objReport.LabSCode
	            
				Set objResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set Bacteria  = objResult.LabResult
				Set AbFlag    = objResult.LabAbFlag
				Set MDRResult = objResult.LabMDRResult
				Set TestCode  = objResult.LabTestCode
				
				Set FlgID="",MRBFlg=0
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				If $d(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID)) {
					Set MRBFlg=1	
				}
				Set FlgID=$o(^DHCHAI.IR.CRuleMRBI("BACT","IndexBact",BacID,0))  //对应的多重耐药菌类型ID					
				Continue:MRBFlg=0   //非多重耐药菌对应的细菌不记录
										    
			    Set ObjectID=TSReportID_"||"_TestCode
			    Set MRBID="",MRBCode="",MRBDesc=""
			    Set xRstID = ""
			    For {
			    	Set xRstID =$o(^DHCHAI.IR.CCResultI("IndexObjectID",xEpisodeID,ItemID,SCode,ObjectID,xRstID))
			        Quit:xRstID=""
					Set objRst = ##class(DHCHAI.IR.CCResult).GetObjById(xRstID)
					Continue:'$Isobject(objRst)
					Continue:'$Isobject(objRst.CCMRBTpDr) //判断是否多耐菌   
					Set MRBID = objRst.CCMRBTpDr.%Id() 
					Set objMRB = ##class(DHCHAI.IR.CRuleMRB).GetObjById(MRBID)
					Continue:'$Isobject(objMRB)
	                Set MRBCode=objMRB.BTCode
	                Set MRBDesc=objMRB.BTDesc
				}
				
				Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,LabNumID,EpisodeNo,Specimen,ReportID,ResultID,BacID,BacCode,BacDesc,MDRResult,RecDate,RecTime,MRBID,MRBCode,MRBDesc,FlgID)
                Set ^CacheTemp(repid,ind)=$lb(ind)_Data
			    Set ind=ind+1
			}
		}
	}	
			
	Quit $$$OK
}

ClassMethod QryMRBRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBRstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBRstExecute ]
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

/// Creator：		pylian
/// CreateDate：	2017-09-25
/// Description:	查询监控结果多重耐药菌(多重耐药菌发现率)
///                 统计感染类型HA，排除HA重复、CA/CA重复、定值/定值重复(千日定值率另算)、污染
/// Input:          aHospIDs： 多个医院用"|"连接
///         	    aLocType： 科室E、病区W
///                 aLocIDs：  科室/病区ID（DHCHAI.BT.Location.ID）
/// 				aDateFrom：开始日期
/// 				aDateTo：  结束日期 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRstMRB","2|1","W","","2017-05-01","2017-05-24")
Query QryRstMRB(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,ResultID:%String,Specimen:%String,BacID:%String,BacCode:%String,BacDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,ActDate:%String,ActTime:%String,IsDZ:%Integer,IsDZDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRstMRBExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
    //Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aLocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aLocIDs,"|")	 	

    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
    Quit:'$IsObject(objItmMast) $$$OK
    Set ItemID=objItmMast.%Id()
    Quit:ItemID="" $$$OK
    /*
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))
		Quit:xEpisodeID=""
	*/
	Set ListArray=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I") 
	For index=1:1:ListArray.Count() {
		Set xEpisodeID=ListArray.GetAt(index)	
		Continue:xEpisodeID=""
		Continue:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID))	
		
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$Isobject(objAdm)
		Set PatientID = objAdm.PAPatientIDx
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set AdmDate   = objAdm.PAAdmDate
		Set AdmTime   = objAdm.PAAdmTime
		Set Age       = objAdm.PAAge
	   
	    Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0     //HA、HA重复、定值、定值重复
	    Set xDate=aDateFrom-1,ResultList=""
		For {
	 		Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate))
			Quit:xDate=""
	    	Quit:(xDate>aDateTo)    //日期控制？
	    	
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeID,ItemID,xDate,xID))
				Quit:xID=""
			
				Set objResult = ##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$Isobject(objResult)
				Continue:objResult.CCIsActive'=1
				Continue:'$Isobject(objResult.CCMRBTpDr)
			
				Set ActDate=objResult.CCActDate
				Set ActTime=objResult.CCActTime
				Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  //排除CA?
				Continue:IPHour<48
			    
				//采集病区
			    Set LocIfno=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeID,ActDate,ActTime)
			    Set ActLocID = $s(aLocType="E":$p(LocIfno,"^",1),1:$p(LocIfno,"^",2))
				Continue:(aLocIDs'="")&($listfind(aLocIDs,ActLocID)<1)  //按科室过滤
			   	Set objRecLoc = ##class(DHCHAI.BT.Location).GetObjById(ActLocID)
				Continue:'$IsObject(objRecLoc)
			    Set ActLocDesc=objRecLoc.BTDesc2
			    Set:ActLocDesc="" ActLocDesc=objRecLoc.BTDesc
				//Continue:'$IsObject(objRecLoc.BTHospDr)
				//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRecLoc.BTHospDr.%Id())<1)  //按医院过滤	
                Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime)
				
				Set MRBID    = objResult.CCMRBTpDr.%Id()
				Set MRBDesc  = objResult.CCMRBTpDr.BTDesc
				Set MRBCode  = objResult.CCMRBTpDr.BTCode
				Set SCode    = objResult.CCSCode      //子系统代码
		        Set Specimen = objResult.CCSpecimen   //原始标本名称
		        Set SpeID="",SpeCode="",SpeDesc=""
		        Set objSpe=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
		        If $IsObject(objSpe) {
			        If $IsObject(objSpe.BTMapItemDr){
						Set SpeID=objSpe.BTMapItemDr.%Id()
						Set SpeCode=objSpe.BTMapItemDr.BTSpecCode
						Set SpeDesc=objSpe.BTMapItemDr.BTSpecDesc
					}
		        }
		        Set Bacteria = objResult.CCBacteria   //原始细菌名称
		        Continue:Bacteria=""
	            Set objBactMap = ##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
	            Continue:'$IsObject(objBactMap)
				Continue:'$IsObject(objBactMap.BTMapItemDr)
				Set BacID=objBactMap.BTMapItemDr.%Id()
				Set BacCode=objBactMap.BTMapItemDr.BTBacCode
				Set BacDesc=objBactMap.BTMapItemDr.BTBacDesc
				/***********如何判断HA?*******/
				/*****************************/
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { //判断HA重复 ？
				   Set IsHACF=1 
				   Continue:IsHACF=1                     
				}
				Set ResultList=ResultList_$lb(BacDesc)
				/*****判断定值、定值重复******/
				/*****************************/
				Set IsDZDesc=$s(IsDZ=1:"是",1:"否")
				Set ResultID = $p(objResult.CCParams,"=",2)  //检验结果ID
			   	Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,ActLocID,ActLocDesc,ResultID,Specimen,BacID,BacCode,BacDesc,MRBID,MRBCode,MRBDesc,ActDate,ActTime,IsDZ,IsDZDesc)
				Set ^CacheTemp(repid,ind)=$lb(ind)_Data
				Set ind=ind+1
			}	
		}
	}	
	Quit $$$OK
}

ClassMethod QryRstMRBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRstMRBExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRstMRBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRstMRBExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-10-12
/// Description:  手术部位感染发病率统计
/// Table：       DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QryOPSPosINFRate","","2017-10-12","2017-12-21")
Query QryOPSPosINFRate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,OperICD:%String,OperDesc:%String,OperHour:%Integer,OperLocID:%String,OperLocDesc:%String,MapIncDicDesc:%String,MapASADicDesc:%String,MapNNISDicDesc:%String,InfPosDesc:%String,IRIsOperInf:%String,OperType:%String") [ SqlProc ]
{
}

ClassMethod QryOPSPosINFRateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set SCode="OPS01"
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xOperLocDr)
				Set HospID=$p(HospInfo,"^",1)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 	Continue:'$IsObject(obj.OREpisodeDr)
				 	
				 	Do BuildDataOperInfo
				}
			}
		}
	}
	Quit $$$OK
	
BuildDataOperInfo
 	Set EpisodeDr   = obj.OREpisodeDr.%Id()
	Set EpisodeID   = obj.OREpisodeDr.PAEpisodeIDx
	Set PatientID   = obj.OREpisodeDr.PAPatientIDx
	Set PapmiNo     = obj.OREpisodeDr.PAPapmiNo
	
	// 手术信息
	Set OperICD     = obj.OROperICD          // 手术ICD
	Set OperDesc    = obj.OROperDesc         // 手术名称
	Set OperHour    = +obj.OROperHour        // 手术时长
	Set OperLocID="",OperLocDesc=""
	If $IsObject(obj.OROperLocDr) {
		Set OperLocID   = obj.OROperLocDr.%Id()     // 手术科室ID
		Set OperLocDesc = obj.OROperLocDr.BTDesc    // 手术科室
		Set OperLocDesc2 = obj.OROperLocDr.BTDesc2  // 手术科室2
		Set:OperLocDesc'="" OperLocDesc=OperLocDesc2
		Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
	}
	Quit:OperLocDesc=""
	Set Incision    = obj.ORIncision         // 切口等级
	Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
	If (IncisionInfo'="") {
		Set MapIncDicDR   = $p(IncisionInfo,"^",1)
		Set MapIncDicCode = $p(IncisionInfo,"^",2)
		Set MapIncDicDesc = $p(IncisionInfo,"^",3)
	}Else {
		Set MapIncDicDR   = ""
		Set MapIncDicCode = ""
		Set MapIncDicDesc = Incision
	}
	Set ASAScore = obj.ORASAScore   // ASA评分
	Set ASAScoreInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"ASAScore",ASAScore)  
	If (ASAScoreInfo'="") {
		Set MapASADicDR   = $p(ASAScoreInfo,"^",1)
		Set MapASADicCode = $p(ASAScoreInfo,"^",2)
		Set MapASADicDesc = $p(ASAScoreInfo,"^",3)
	}Else {
		Set MapASADicDR   = ""
		Set MapASADicCode = ""
		Set MapASADicDesc = ASAScore
	}
	Set NNISGrade   = obj.ORNNISGrade        // NNIS分级
	Set NNISGradeInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"NNISLevel",NNISGrade)  
	If (NNISGradeInfo'="") {
		Set MapNNISDicDR   = $p(NNISGradeInfo,"^",1)
		Set MapNNISDicCode = $p(NNISGradeInfo,"^",2)
		Set MapNNISDicDesc = $p(NNISGradeInfo,"^",3)
	}Else {
		Set MapNNISDicDR   = ""
		Set MapNNISDicCode = ""
		Set MapNNISDicDesc = NNISGrade
	}
	
	Set IsImplants = obj.ORIsImplants   // 是否植入物
	Set OperType   = obj.OROperType     // 手术类型  
	// 手术切口调查表
	Set (ReportID,InfPosDesc,IROperName,IRImplantFlag,IROperHours,IRIsOperInf)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,xID)
	If ($IsObject(objINFOPS)) {
		Set ReportID      = objINFOPS.%Id()
		Set IROperName    = objINFOPS.IROperName       // 标准手术名称
		Set IRIsOperInf   = objINFOPS.IRIsOperInf      // 是否切口感染
		Set IRImplantFlag = objINFOPS.IRImplantFlag    // 是否有植入物
		Set IROperHours   = objINFOPS.IROperHours      // 手术时长
		Set IRNNISLevelDr = objINFOPS.IRNNISLevelDr
		If $IsObject(objINFOPS.IRNNISLevelDr){
			Set IRNNISLevelDesc = objINFOPS.IRNNISLevelDr.BTDesc
			Set:IRNNISLevelDesc'="" MapNNISDicDesc=IRNNISLevelDesc
		}
		If $IsObject(objINFOPS.IROperTypeDr){
			Set OperTypeDesc = objINFOPS.IROperTypeDr.BTDesc
			Set:OperTypeDesc'="" OperType=OperTypeDesc
		}
		If $IsObject(objINFOPS.IRASAScore){
			Set IRASAScoreDesc = objINFOPS.IRASAScore.BTDesc
			Set:IRASAScoreDesc'="" MapASADicDesc=IRASAScoreDesc
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){
			Set IRCuteTypeDesc = objINFOPS.IRCuteTypeDr.BTDesc
			Set:IRCuteTypeDesc'="" MapIncDicDesc=IRCuteTypeDesc
		}
		If $IsObject(objINFOPS.IRInfTypeDr){
			Set InfPosDesc = objINFOPS.IRInfTypeDr.BTDesc  // 感染部位
		}
	}
	Set:IROperName'="" OperDesc=IROperName
	// 计算NNIS分级
	If (MapNNISDicDesc="") {
		Set:OperHour>=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=3 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapIncDicCode)=4 MapNNISDicDesc=(+MapNNISDicDesc)+1
		Set:(+MapASADicCode)>2 MapNNISDicDesc=(+MapNNISDicDesc)+1
	}
	Set MapNNISDicDesc=+MapNNISDicDesc
	
	Set Data=$lb(xID,EpisodeDr,OperICD,OperDesc,OperHour,OperLocID,OperLocDesc,MapIncDicDesc,MapASADicDesc,MapNNISDicDesc,InfPosDesc,IRIsOperInf,OperType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryOPSPosINFRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPSPosINFRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPSPosINFRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPSPosINFRateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  手术感染、预防用药相关统计
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aHospIDs : 医院ID多值逗号分隔
///               aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QryOPSINFPrevAnti","1|2|3|4","2017-05-01","2017-05-31")
Query QryOPSINFPrevAnti(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,xLocDr:%String,OperLocDesc:%String,OperPatientNum:%Integer,OperPosInfNum:%Integer,OneIncPatientNum:%Integer,OneIncAPatientNum:%Integer,OneIncPosPatientNum:%Integer,OneIncPrevMedicNum:%Integer,OneIncUseAntiDays:%Integer,OneIncUseAntiPrevSum:%Integer,OneIncEndPrevAntiSum:%Integer,ThreeHoursSum:%Integer,BloodLossAddAntiSum:%Integer,PrevOperTowAddSum:%Integer,OperCurrAntiNum:%Integer,OperCurrAntiThreeNum:%Integer,OperCurrAntiBloodNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryOPSINFPrevAntiExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set SCode="OPS01"
	Set NIndex="QryOPSINFPrevAnti"
	Kill ^TMP($zn,$j,NIndex)
	For xDate=aDateFrom:1:aDateTo {
		Set xTime=""
		For {
 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xOperLocDr=""
			For {
				Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
				Quit:xOperLocDr=""
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xOperLocDr)
				Set HospID=$p(HospInfo,"^",1)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	Continue:obj.ORIsActive'=1
				 	Continue:'$IsObject(obj.OREpisodeDr)
				 	
				 	Do BuildDataOperAntiInfo
				}
			}
		}
	}
	Set xLocDr=""
	For {
		Set xLocDr=$o(^TMP($zn,$j,NIndex,xLocDr))
		Quit:xLocDr=""
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(xLocDr)
		Continue:'$IsObject(objLoc)
		Set OperLocDesc  = objLoc.BTDesc
		Set OperLocDesc2 = objLoc.BTDesc2
		Set:OperLocDesc'="" OperLocDesc=OperLocDesc2
		Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
		Set xDate=""
		For {
			Set xDate=$o(^TMP($zn,$j,NIndex,xLocDr,xDate))
			Quit:xDate=""
			
			Set OperPatientNum       = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OperPatientNum"))
			Set OperPosInfNum        = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OperPosInfNum"))
			Set OneIncPatientNum     = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncPatientNum"))
			Set OneIncAPatientNum    = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncAPatientNum"))
			Set OneIncPosPatientNum  = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncPosPatientNum"))
			Set OneIncPrevMedicNum   = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncPrevMedicNum"))
			Set OneIncUseAntiDays    = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncUseAntiDays"))
			Set OneIncUseAntiPrevSum = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncUseAntiPrevSum"))
			Set OneIncEndPrevAntiSum = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OneIncEndPrevAntiSum"))
			Set ThreeHoursSum        = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"ThreeHoursSum"))
			Set BloodLossAddAntiSum  = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"BloodLossAddAntiSum"))
			Set PrevOperTowAddSum    = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"PrevOperTowAddSum"))
			Set OperCurrAntiNum      = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OperCurrAntiNum"))
			Set OperCurrAntiThreeNum = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OperCurrAntiThreeNum"))
			Set OperCurrAntiBloodNum = $g(^TMP($zn,$j,NIndex,xLocDr,xDate,"OperCurrAntiBloodNum"))
			
	        Set ^CacheTemp(repid,ind)=$lb(ind,xLocDr,OperLocDesc,OperPatientNum,OperPosInfNum,OneIncPatientNum,OneIncAPatientNum,OneIncPosPatientNum,OneIncPrevMedicNum,OneIncUseAntiDays,OneIncUseAntiPrevSum,OneIncEndPrevAntiSum,ThreeHoursSum,BloodLossAddAntiSum,PrevOperTowAddSum,OperCurrAntiNum,OperCurrAntiThreeNum,OperCurrAntiBloodNum)
			Set ind=ind+1
		}
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
	
BuildDataOperAntiInfo
 	Set EpisodeDr   = obj.OREpisodeDr.%Id()
	Set EpisodeID   = obj.OREpisodeDr.PAEpisodeIDx
	Set PatientID   = obj.OREpisodeDr.PAPatientIDx
	Set PapmiNo     = obj.OREpisodeDr.PAPapmiNo
	Set OperLocID="",OperLocDesc=""
	If $IsObject(obj.OROperLocDr) {
		Set OperLocID   = obj.OROperLocDr.%Id()     // 手术科室ID
		Set OperLocDesc = obj.OROperLocDr.BTDesc    // 手术科室
		Set OperLocDesc2 = obj.OROperLocDr.BTDesc2  // 手术科室2
		Set:OperLocDesc'="" OperLocDesc=OperLocDesc2
		Set:$p(OperLocDesc,"-",2)'="" OperLocDesc=$p(OperLocDesc,"-",2)
	}
	Quit:OperLocDesc=""
	// 手术切口调查表
	Set (ReportID,OperName,IsOperInf,OperHours,OpersSttDate,OpersSttTime,OpersEndDate,OpersEndTime,BloodLoss,HealingDesc,CuteTypeDesc,InfPosDesc)=""
	Set objINFOPS = ##class(DHCHAI.IR.INFOPS).GetObjByEpOperDr(EpisodeDr,xID)
	If ($IsObject(objINFOPS)) {
		Set ReportID      = objINFOPS.%Id()
		Set OperName      = objINFOPS.IROperName       // 标准手术名称
		Set IsOperInf     = objINFOPS.IRIsOperInf      // 是否切口感染
		Set OperHours     = objINFOPS.IROperHours      // 手术时长
		Set OpersSttDate  = objINFOPS.IROperDate       // 手术开始日期
		Set OpersSttTime  = objINFOPS.IRSttTime        // 手术开始时间
		Set OpersEndDate  = objINFOPS.IREndDate        // 手术结束日期
		Set OpersEndTime  = objINFOPS.IREndTime        // 手术结束时间
		Set BloodLoss     = +objINFOPS.IRBloodLoss     // 失血量
		If $IsObject(objINFOPS.IRCuteHealingDr){
			Set HealingCode = objINFOPS.IRCuteHealingDr.BTCode   // 愈合情况
			Set HealingDesc = objINFOPS.IRCuteHealingDr.BTDesc
		}
		If $IsObject(objINFOPS.IRCuteTypeDr){
			Set CuteTypeDesc = objINFOPS.IRCuteTypeDr.BTDesc     // 切口类型
			Set CuteTypeCode = objINFOPS.IRCuteTypeDr.BTCode
		}
		If $IsObject(objINFOPS.IRInfTypeDr){
			Set InfPosDesc = objINFOPS.IRInfTypeDr.BTDesc        // 手术感染部位
		}
	}
	Set:OpersSttDate="" OpersSttDate = obj.OROperDate
	Set:OpersSttTime="" OpersSttTime = obj.ORSttTime
	Set:OpersEndDate="" OpersEndDate = obj.OREndDate
	Set:OpersEndTime="" OpersEndTime = obj.OREndTime
	Quit:OpersSttDate=""
	Set:OperHours="" OperHours = +obj.OROperHour   // 手术时长
	Set:BloodLoss="" BloodLoss = +obj.ORLoseBlood  // 失血量
	// 手术患者总人数
	If ('$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPatientNum",EpisodeID))){
		Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPatientNum",EpisodeID)=""
		Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPatientNum"))
	}
	// 手术部位感染人数
	If ('$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPosInfNum",EpisodeID))&&(InfPosDesc'="")){
		Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPosInfNum",EpisodeID)=""
		Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperPosInfNum"))
	}
	// 没填院感报表或者手术切口调查表,就取手麻系统过来的切口类型
	If (CuteTypeDesc="") {
		Set Incision    = obj.ORIncision         // 切口等级
		Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
		If (IncisionInfo'="") {
			Set MapIncDicDesc = $p(IncisionInfo,"^",3)
		}Else {
			Set MapIncDicDesc = Incision
		}
		Set CuteTypeDesc = MapIncDicDesc
	}
	;Quit ((CuteTypeDesc="")||(CuteTypeDesc["无")) // 排除无切口的手术
	// Ⅰ类切口患者总人数
	If ((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类")){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPatientNum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPatientNum",EpisodeID)=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPatientNum"))
		}
	}
	If (HealingDesc="") {
		Set ORHealing = obj.ORHealing   // 愈合情况
		Set ORHealingInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteHealing",ORHealing)  
		If (ORHealingInfo'="") {
			Set MapHealDicDesc = $p(ORHealingInfo,"^",3)
		}Else {
			Set MapHealDicDesc = ORHealing
		}
		Set HealingDesc = MapHealDicDesc
	}
	// I类切口甲级愈合总人数
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&((HealingDesc="甲")||(HealingDesc["甲"))){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncAPatientNum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncAPatientNum",EpisodeID)=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncAPatientNum"))
		}
	}
	// I类切口手术部位感染病例总人数
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(InfPosDesc'="")){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPosPatientNum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPosPatientNum",EpisodeID)=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPosPatientNum"))
		}
	}
	// I类切口预防使用抗菌药物患者数（人） 术前24小时,术后72小时
	Set AntiSttDate=(OpersSttDate-1),AntiSttTime=OpersSttTime
	Set AntiEndDate=(OpersSttDate+3),AntiEndTime=OpersSttTime
	Set UseAntiFlg=..CheckUesAnti(EpisodeDr,AntiSttDate,AntiSttTime,AntiEndDate,AntiEndTime)
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(UseAntiFlg=1)){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPrevMedicNum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPrevMedicNum",EpisodeID)=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncPrevMedicNum"))
		}
	}
	// I类切口预防使用抗菌药物天数(天)
	Set UseAntiInfo=..UesAntiDays(EpisodeDr,AntiSttDate,AntiSttTime,AntiEndDate,AntiEndTime)
	Set:UseAntiInfo'="" UseAntiDays=$p(UseAntiInfo,"^",1)
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(UseAntiDays>0)){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiDays",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiDays",EpisodeID)=""
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiDays")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiDays"))+UseAntiDays
		}
	}
	// I类切口术后预防用药例次数
	Set:UseAntiInfo'="" UseAntiPrevSum=$p(UseAntiInfo,"^",2)
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(UseAntiPrevSum>0)){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiPrevSum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiPrevSum",EpisodeID)=""
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiPrevSum")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncUseAntiPrevSum"))+UseAntiPrevSum
		}
	}
	// I类切口术后24小时内结束预防用药例次数 
	If (OpersEndDate'=""){
		Set EndPrevAntiSum=..OperAfterEndPrevAnti(EpisodeDr,OpersEndDate,OpersEndTime,(OpersEndDate+1),OpersEndTime)
		If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(EndPrevAntiSum>0)){
			If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncEndPrevAntiSum",EpisodeID)){
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncEndPrevAntiSum",EpisodeID)=""
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncEndPrevAntiSum")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OneIncEndPrevAntiSum"))+EndPrevAntiSum
			}
		}
	}
	// 手术当天预防性应用抗菌药物的手术例次数
	Set UseAntiFlg=..CheckUesAnti(EpisodeDr,OpersSttDate,OpersSttTime,OpersSttDate,OpersSttTime)
	If (UseAntiFlg=1) {
		Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiNum")=""
		Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiNum"))
	}
	// 手术时长大于3小时术中追加抗菌用药例次 
	If (OperHours>3) {
		Set AddAntiSum=..CheckAddUesAnti(EpisodeDr,OpersSttDate,OpersSttTime,OpersEndDate,OpersEndTime,"")
		If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(AddAntiSum>0)){
			If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"ThreeHoursSum",EpisodeID)){
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"ThreeHoursSum",EpisodeID)=""
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"ThreeHoursSum")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"ThreeHoursSum"))+AddAntiSum
			}
		}
		// 手术当天预防性应用抗菌药物且手术时长大于3小时的手术例次数
		If (UseAntiFlg=1) {
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiThreeNum")=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiThreeNum"))
		}
	}
	// 失血量大于1500ml术中追加抗菌用药例次
	If (BloodLoss>1500) {
		Set AddAntiSum=..CheckAddUesAnti(EpisodeDr,OpersSttDate,OpersSttTime,OpersEndDate,OpersEndTime,"")
		If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(AddAntiSum>0)){
			If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"BloodLossAddAntiSum",EpisodeID)){
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"BloodLossAddAntiSum",EpisodeID)=""
				Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"BloodLossAddAntiSum")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"BloodLossAddAntiSum"))+AddAntiSum
			}
		}
		// 手术当天预防性应用抗菌药物且失血量大于1500ml的手术例次数
		If (UseAntiFlg=1) {
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiBloodNum")=""
			Set num=$i(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"OperCurrAntiBloodNum"))
		}
	}
	// 术前0.5~2小时预防使用抗菌药物例次
	Set PrevFiveDateTime=##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OpersSttDate,OpersSttTime,"-0.5")
	Set PrevTowDateTime=##class(DHCHAI.Utils.CommonSrv).GetTimeByHours(OpersSttDate,OpersSttTime,"-2")
	Set AddAntiSum=..CheckAddUesAnti(EpisodeDr,$p(PrevFiveDateTime,",",1),$p(PrevFiveDateTime,",",2),$p(PrevFiveDateTime,",",1),$p(PrevFiveDateTime,",",2),"1")  
	If (((CuteTypeDesc["Ⅰ")||(CuteTypeDesc="Ⅰ类"))&&(AddAntiSum>0)){
		If '$d(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"PrevOperTowAddSum",EpisodeID)){
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"PrevOperTowAddSum",EpisodeID)=""
			Set ^TMP($zn,$j,NIndex,xOperLocDr,xDate,"PrevOperTowAddSum")=+$g(^TMP($zn,$j,NIndex,xOperLocDr,xDate,"PrevOperTowAddSum"))+AddAntiSum
		}
	}
	Quit
}

ClassMethod QryOPSINFPrevAntiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPSINFPrevAntiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPSINFPrevAntiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPSINFPrevAntiExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  判断在一段时间内是否使用预防抗菌药物
/// Return：      1：使用    0：未使用
/// w ##class(DHCHAI.STAS.StaService).CheckUesAnti(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod CheckUesAnti(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set UseAntiFlg =0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:((xSCode="")||(UseAntiFlg=1))
		Set xSttDate = ""
		For {
			Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate))
			Quit:((xSttDate="")||(UseAntiFlg=1))
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:((xID="")||(UseAntiFlg=1))
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:AntUsePurpose'["预防"
				Set OESttDate = objOrdItem.OESttDate   // 执行医嘱日期
				Set OEEndDate = objOrdItem.OEXDate     // 停医嘱日期
				Set:OEEndDate="" OEEndDate = +$h
				Continue:((OEEndDate<aFromDate)&&(aFromDate'=""))
				Continue:((OESttDate>aToDate)&&(aToDate'=""))
				Set OESttTime = objOrdItem.OESttTime
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(aFromTime<OESttTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(aToTime>OESttTime))
				}
				Set UseAntiFlg=1
			}
		}	
	}
	Set return=UseAntiFlg
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  判断在一段时间内是否追加抗菌药物例数
/// Input:        aFlag=1:预防抗菌药物
/// Return：      1：追加    0：未追加
/// w ##class(DHCHAI.STAS.StaService).CheckAddUesAnti(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod CheckAddUesAnti(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String, aFlag As %String = "") As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime,aFlag)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set AddAntiSum =0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		Set xSttDate = ""
		For {
			Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate))
			Quit:xSttDate=""
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:xID=""
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:(AntUsePurpose'["预防")&&(aFlag=1)
				Set OESttDate = objOrdItem.OESttDate   // 执行医嘱日期
				Set OEEndDate = objOrdItem.OEXDate     // 停医嘱日期
				Set:OEEndDate="" OEEndDate = +$h
				Continue:((OEEndDate<aFromDate)&&(aFromDate'=""))
				Continue:((OESttDate>aToDate)&&(aToDate'=""))
				Set OESttTime = objOrdItem.OESttTime
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(aFromTime<OESttTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(aToTime>OESttTime))
				}
				Set AddAntiSum=AddAntiSum+1
			}
		}	
	}
	Set return=AddAntiSum
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  术后24小时内结束预防用药例次数
/// Return：      术后24小时内结束预防用药例次数
/// w ##class(DHCHAI.STAS.StaService).OperAfterEndPrevAnti(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod OperAfterEndPrevAnti(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set EndSum =0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		Set xSttDate = ""
		For {
			Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate))
			Quit:xSttDate=""
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:xID=""
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:AntUsePurpose'["预防"
				Set OESttDate = objOrdItem.OESttDate   // 执行医嘱日期
				Set OEEndDate = objOrdItem.OEXDate     // 停医嘱日期
				Continue:OEEndDate=""
				Set OEEndTime = objOrdItem.OEXTime
				Continue:((OEEndDate<aFromDate)&&(aFromDate'=""))
				Continue:((OESttDate>aToDate)&&(aToDate'=""))
				If (OEEndDate=aFromDate) {
					Continue:((aFromTime'="")&&(aFromTime<OEEndTime))
				}
				If (OEEndDate=aToDate) {
					Continue:((aToTime'="")&&(aToTime>OEEndTime))
				}
				Set EndSum=EndSum+1
			}
		}	
	}
	Set return=EndSum
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  取患者一段时间内使用预防抗菌药物天数、例次数
/// Return：      用药天数^例次数
/// w ##class(DHCHAI.STAS.StaService).UesAntiDays(3,"2017-07-13","00:23:00","2017-07-14","00:23:00")
ClassMethod UesAntiDays(aEpisodeDr As %String, aFromDate As %String, aFromTime As %String, aToDate As %String, aToTime As %String) As %String
{
	New (aEpisodeDr,aFromDate,aFromTime,aToDate,aToTime)
	Set return=0
	Quit:(aEpisodeDr="") return
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aToTime[":" aToTime=$zth(aToTime,1)
	Quit:(aFromDate>aToDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aToDate)&&(aFromTime>aToTime) return
	Set UseAntiDays=0
	Set PrevAntiSum=0
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		Set xSttDate = ""
		For {
			Set xSttDate = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate))
			Quit:xSttDate=""
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,"1",xSttDate,xID))
				Quit:xID=""
				Set objOrdItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				Continue:'$IsObject(objOrdItem)
				Continue:objOrdItem.OEIsActive=0
				Set AntUsePurpose = objOrdItem.OEAntUsePurpose
				Continue:AntUsePurpose'["预防"
				Set OESttDate = +objOrdItem.OESttDate   // 执行医嘱日期
				Set OEEndDate = objOrdItem.OEXDate     // 停医嘱日期
				Set:OEEndDate="" OEEndDate = +$h
				Continue:((OEEndDate<aFromDate)&&(aFromDate'=""))
				Continue:((OESttDate>aToDate)&&(aToDate'=""))
				Set OESttTime = objOrdItem.OESttTime
				If (xSttDate=aFromDate) {
					Continue:((aFromTime'="")&&(aFromTime<OESttTime))
				}
				If (xSttDate=aToDate) {
					Continue:((aToTime'="")&&(aToTime>OESttTime))
				}
				Set UseAntiDays=UseAntiDays+(OEEndDate-OESttDate)
				Set PrevAntiSum=PrevAntiSum+1
			}
		}	
	}
	Set return=UseAntiDays_"^"_PrevAntiSum
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-10-16
/// Description:  查询根据医院、科室的感染明细
/// Input：       
/// output:       
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRstInf","1","E","","2017-08-01","2017-08-31")
Query QryRstInf(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,IsXH:%String,InfPosList:%String,InfCount:%String") [ SqlProc ]
{
}

ClassMethod QryRstInfExecute(ByRef qHandlex As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandlex=$lb(0,repidx,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
  
    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}  	    
    While (rs.Next()) {
	    Set xEpisodeID=rs.Data("Paadm")	   
		Set PapmiNo   = rs.Data("PapmiNo")
		Set MrNo      = rs.Data("MrNo")
		Set PatName   = rs.Data("PatName")
		Set Sex       = rs.Data("Sex")
		Set AdmDate   = rs.Data("AdmDate")
		Set AdmTime   = rs.Data("AdmTime")
		Set Age       = rs.Data("Age")
	    Set LocID = rs.Data("LocID")
	    Set LocDesc =rs.Data("LocDesc")
	    
	    Set xInfID=""
	    Set xInfPosList ="" //记录部位及时间,相同的使用最新的
	    Set IsXH = 0  //是否现患标志
	    Set InfCount = 0  //感染例次数
	    Set InfPosLists=""
	    /*
		For {			
	 		Set xInfID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID,xInfID),-1)
			Quit:xInfID=""
			Set objInf = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfID)
			Set IRInfDate = objInf.IRInfDate
			Continue:'$IsObject(objInf.IRInfPosDr)	
			Set IRInfPosDr = objInf.IRInfPosDr.%Id()
			Set IRInfPosDrDesc =objInf.IRInfPosDr.BTDesc
			Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_IRInfDate)  //重复控制
			Set xInfPosList = xInfPosList_","_(IRInfPosDrDesc_"-"_IRInfDate)	    	    	
	    	Set InfCount =InfCount+1 //例次加1
			//治愈
			If $IsObject(objInf.IRInfEffectDr){
				Set IRInfEffectDr = objInf.IRInfEffectDr.%Id()
				Set IRInfEffectDrDesc = objInf.IRInfEffectDr.BTDesc				
				Set:IRInfEffectDrDesc'["治愈" IsXH=IsXH +1
			}
		}
		*/
		//默认24小时内不起用		
		Set xRepType=""
		For {
			Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,xRepType))
			Quit:xRepType=""
			Quit:return>0  //退出
			
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,xRepType,xRepID))
				Quit:xRepID=""
				Quit:return>0  //退出
				
				Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.IRStatusDr)
				Set Status=objRep.IRStatusDr.BTDesc
				Set StatusCode=objRep.IRStatusDr.BTCode
				Continue:StatusCode=4   //作废|删除
				
				Set arrInfDiag=objRep.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
				Continue:arrInfDiag.Count()<1
				For indD=1:1:arrInfDiag.Count() {
					Set objInfDiag=arrInfDiag.GetAt(indD)
					Continue:'$IsObject(objInfDiag)
					
					Set InfDate=objInfDiag.IRInfDate
					Continue:InfDate=""
					Continue:'$IsObject(objInfDiag.IRInfPosDr)	
					Set InfLocID=""
					If $IsObject(objInfDiag.IRInfLocDr){
						Set InfLocID=objInfDiag.IRInfLocDr.%Id()
					}
					Continue:LocID'=InfLocID
					Set IRInfPosDr = objInfDiag.IRInfPosDr.%Id()
					Set IRInfPosDrDesc =objInfDiag.IRInfPosDr.BTDesc
					//Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_$zd(InfDate,3))  //重复控制
					Set InfPosList=IRInfPosDrDesc_"-"_$zd(InfDate,3)
					Continue:($listfind(xInfPosList,InfPosList)>0)
					Set xInfPosList = xInfPosList_$lb(InfPosList)
					Set InfPosLists=InfPosLists_","_InfPosList
				   	Set InfCount =InfCount+1 //例次加1
					Set InfXDate=objInfDiag.IRInfXDate
					If InfXDate'="" {
						Continue:InfXDate<aDateFrom
					}
					Set IsXH=IsXH +1
				}
			}
		}
		Set:InfPosLists'="" InfPosLists=$e(InfPosLists,2,$l(InfPosLists))
		Set Datax=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,IsXH,InfPosLists,InfCount)
		Set ^CacheTemp(repidx,indx)=$lb(indx)_Datax
		Set indx=indx+1	
	}	
	Quit $$$OK
}

ClassMethod QryRstInfClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryRstInfExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryRstInfFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRstInfExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2017-10-16
/// Description:  查询根据医院、科室的感染明细
/// Input：       
/// output: 
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryRstInfMX","","E","54","2017-12-01","2017-12-21")
Query QryRstInfMX(aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,LocID:%String,LocDesc:%String,IsXH:%String,InfPosList:%String,InfCount:%String") [ SqlProc ]
{
}

ClassMethod QryRstInfMXExecute(ByRef qHandlex As %Binary, aHospIDs As %String, aLocType As %String, aLocIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandlex=$lb(0,repidx,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK

    Set rs=##Class(%ResultSet).%New("DHCHAI.STAS.StaService:QryInLocAdm")
  	Set sc=rs.Execute(aHospIDs,aLocType,aLocIDs,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}
  	//ind:%String,LocID:%String,LocDesc:%String,Paadm:%String,InCount:%Integer
  	//PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,
  	//AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String
  	//AdmWardDesc:%String,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc"
  	    
    While (rs.Next()) {
	    Set xEpisodeID=rs.Data("Paadm")	   
		Set PapmiNo   = rs.Data("PapmiNo")
		Set MrNo      = rs.Data("MrNo")
		Set PatName   = rs.Data("PatName")
		Set Sex       = rs.Data("Sex")
		Set AdmDate   = rs.Data("AdmDate")
		Set AdmTime   = rs.Data("AdmTime")
		Set Age       = rs.Data("Age")
	    Set LocID = rs.Data("LocID")
	    Set LocDesc =rs.Data("LocDesc")
	    Set xInfID=""
	    Set xInfPosList ="" //记录部位及时间,相同的使用最新的
	    Set IsXH = 0  //是否现患标志
	    Set InfCount = 0  //感染例次数
		For {			
	 		Set xInfID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",xEpisodeID,xInfID),-1)
			Quit:xInfID=""
			Set objInf = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfID)
			Set IRInfDate = objInf.IRInfDate
			Continue:'$IsObject(objInf.IRInfPosDr)	
			Set IRInfPosDr = objInf.IRInfPosDr.%Id()
			Set IRInfPosDrDesc =objInf.IRInfPosDr.BTDesc
			Continue:xInfPosList[","_(IRInfPosDrDesc_"-"_IRInfDate)  //重复控制
			Set xInfPosList = xInfPosList_","_(IRInfPosDrDesc_"-"_IRInfDate)	    	    	
	    	Set InfCount =InfCount+1 //例次加1
			//治愈
			If $IsObject(objInf.IRInfEffectDr){
				Set IRInfEffectDr = objInf.IRInfEffectDr.%Id()
				Set IRInfEffectDrDesc = objInf.IRInfEffectDr.BTDesc				
				Set:IRInfEffectDrDesc'["治愈" IsXH=IsXH +1
			}
		}
		Set:xInfPosList'="" xInfPosList=$e(xInfPosList,2,$l(xInfPosList))
		Continue:IsXH=0
		Set Datax=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,LocID,LocDesc,IsXH,xInfPosList,InfCount)
		Set ^CacheTemp(repidx,indx)=$lb(indx)_Datax
		Set indx=indx+1	
	}	
	Quit $$$OK
}

ClassMethod QryRstInfMXClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryRstInfMXExecute ]
{
	Set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
 	Quit $$$OK
}

ClassMethod QryRstInfMXFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRstInfMXExecute ]
{
	Set AtEnd=$LIST(qHandlex,1)
 	Set repidx=$LIST(qHandlex,2)
 	Set indx=$LIST(qHandlex,3)
 	Set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repidx,indx)
 	}
 	// Save QHandle
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-27
/// Description:  新生儿器械使用率及其相关感染发病率统计
/// Table：       DHCHAI.IR.ICULog
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","StaNICUSurvery","2017-06-01","2017-10-27")
Query StaNICUSurvery(aHospIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,NewInHospSum1:%Integer,InHospSum1:%Integer,PICCSum1:%Integer,VNTSum1:%Integer,NewInHospSum2:%Integer,InHospSum2:%Integer,PICCSum2:%Integer,VNTSum2:%Integer,NewInHospSum3:%Integer,InHospSum3:%Integer,PICCSum3:%Integer,VNTSum3:%Integer,NewInHospSum4:%Integer,InHospSum4:%Integer,PICCSum4:%Integer,VNTSum4:%Integer,TotalInHospSum1:%Integer,TotalInHospSum2:%Integer,TotalInHospSum3:%Integer,TotalInHospSum4:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUSurveryExecute(ByRef qHandle As %Binary, aHospIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aFromDate,aToDate,"W","","I")
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsNICU = objLoc.BTIsNICU
		Continue:IsNICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		For xDate=aFromDate:1:aToDate {
			Quit:xDate>(+$h)
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10)=0
			Set (Item11,Item12,Item13,Item14,Item15,Item16)=0
			
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			
			Set objItem1 =##class(DHCHAI.IRS.ICULogSrv).GetTransIDArray(RstEpisArr,xDate,xLocID,"I")
			Set objItem2 =##class(DHCHAI.IRS.ICULogSrv).GetTransIDArray(RstEpisArr,xDate,xLocID,"A")
			// 按体重计算新入科人数
			For i=1:1:objItem1.Count() {
				Set xTansID= objItem1.GetAt(i)
				Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTansID)
				Continue:'$Isobject(objAdmTrans)
				Set objAdm = objAdmTrans.PAEpisodeDr
				Set Weight =+objAdm.PAAdmitWeight
				Set:Weight<=1000 Item1 = Item1+1
				Set:(Weight<=1500)&&(Weight>1000) Item5 = Item5+1 
				Set:(Weight<=2500)&&(Weight>1500) Item9 = Item9+1 
				Set:(Weight>2500) Item13 = Item13+1 
			}
			// 按体重计算在科人数
			For i=1:1:objItem2.Count() {
				Set xTansID = objItem2.GetAt(i)
				Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTansID)
				Continue:'$Isobject(objAdmTrans)
				Set objAdm  = objAdmTrans.PAEpisodeDr
				Set Weight  = +objAdm.PAAdmitWeight
				Set ArrCnt  = ##class(DHCHAI.IRS.ICULogDtlSrv).GetCntByPaAdm(xLocID,xDate,objAdm.%Id())
				Set PICCCnt = +$p(ArrCnt,"^",1)
				Set VAPCnt  = +$p(ArrCnt,"^",2)
				If Weight<=1000
				{
					Set Item2 = Item2+1
					Set:PICCCnt>0 Item3 = Item3+1
					Set:VAPCnt>0 Item4  = Item4+1				
				}
				If (Weight<=1500)&&(Weight>1000)
				{
					Set Item6 = Item6+1 
					Set:PICCCnt>0 Item7 = Item7+1
					Set:VAPCnt>0 Item8  = Item8+1	
				}
				If (Weight<=2500)&&(Weight>1500)
				{
					Set Item10 = Item10+1
					Set:PICCCnt>0 Item11 = Item11+1
					Set:VAPCnt>0 Item12  = Item12+1	
				}
				If (Weight>2500)
				{
					Set Item14 = Item14+1 
					Set:PICCCnt>0 Item15 = Item15+1
					Set:VAPCnt>0 Item16  = Item16+1	
				}			
			}
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1")=num+Item1
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1")=num+Item2
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1")=num+Item3
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1")=num+Item4
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2")=num+Item5
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2")=num+Item6
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2")=num+Item7
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2")=num+Item8
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3")=num+Item9
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3")=num+Item10
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3")=num+Item11
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3")=num+Item12
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4")=num+Item13
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4")=num+Item14
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4")=num+Item15
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4")=num+Item16
		}
	}
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		
		Set NewInHospSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1"))
		Set InHospSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1"))
		Set PICCSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1"))
		Set VNTSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1"))
		
		Set NewInHospSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2"))
		Set InHospSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2"))
		Set PICCSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2"))
		Set VNTSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2"))
		
		Set NewInHospSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3"))
		Set InHospSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3"))
		Set PICCSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3"))
		Set VNTSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3"))
		
		Set NewInHospSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4"))
		Set InHospSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4"))
		Set PICCSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4"))
		Set VNTSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4"))
		
		Set TotalInHospSum1=NewInHospSum1+InHospSum1
		Set TotalInHospSum2=NewInHospSum2+InHospSum2
		Set TotalInHospSum3=NewInHospSum3+InHospSum3
		Set TotalInHospSum4=NewInHospSum4+InHospSum4

		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(NewInHospSum1,InHospSum1,PICCSum1,VNTSum1)
		Set Data=Data_$lb(NewInHospSum2,InHospSum2,PICCSum2,VNTSum2)
		Set Data=Data_$lb(NewInHospSum3,InHospSum3,PICCSum3,VNTSum3)
		Set Data=Data_$lb(NewInHospSum4,InHospSum4,PICCSum4,VNTSum4)
		Set Data=Data_$lb(TotalInHospSum1,TotalInHospSum2,TotalInHospSum3,TotalInHospSum4)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	
	Quit $$$OK
}

ClassMethod StaNICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-10-27
/// Description:  新生儿调查感染统计
/// Table：       DHCHAI.IR.ICULog
/// Input:        aFromDate 开始日期,aToDAte 结束日期,aStatType 统计类型
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","StaNICUInfection","1,2","2017-12-01","2017-12-21","1")
Query StaNICUInfection(aHospIDs As %String, aFromDate As %String, aToDate As %String, aStatType As %String = "1") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,InfAdmSum:%Integer,InfPatSum1:%Integer,InfAdmSum1:%Integer,InfNPICCSum1:%Integer,InfNVAPSum1:%Integer,InfPatSum2:%Integer,InfAdmSum2:%Integer,InfNPICCSum2:%Integer,InfNVAPSum2:%Integer,InfPatSum3:%Integer,InfAdmSum3:%Integer,InfNPICCSum3:%Integer,InfNVAPSum3:%Integer,InfPatSum4:%Integer,InfAdmSum4:%Integer,InfNPICCSum4:%Integer,InfNVAPSum4:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUInfectionExecute(ByRef qHandle As %Binary, aHospIDs As %String, aFromDate As %String, aToDate As %String, aStatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Kill ^TMP($zn,$j,"StaNICUInfection")
	// 从新生儿调查报告获取获取新生儿感染信息
	If aStatType="1" {
		// PICC感染信息
		For xDate=aFromDate:1:aToDate{
			Set xPICCID=""
			For {
				Set xPICCID=$o(^DHCHAI.IR.INFICUPICCI("IndexIRInfDate",xDate,xPICCID))
				Quit:xPICCID=""
				Set objPICC = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
				Continue:'$IsObject(objPICC)
				Continue:(objPICC.IRIsInf'=1)   // 过滤非感染信息
				Set objAdm  = objPICC.IREpisodeDr
				Continue:'$IsObject(objAdm)
				Set LocID = objPICC.IRLocDr.%Id()    // 调查科室 update for 626976
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(LocID)
		                Set HospID=$p(HospInfo,"^",1)
		                Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Continue:(objAdm.PAIsNewBaby'=1)
				Set EpisodeID = objAdm.PAEpisodeIDx
				Set Weight  = +objAdm.PAAdmitWeight
				Continue:Weight<1
				If Weight<=1000 {
					Set WeightGp=1
				} ElseIf (Weight>1000)&&(Weight<=1500) {
					Set WeightGp=2
				} ElseIf (Weight>1500)&&(Weight<=2500) {
					Set WeightGp=3
				} Else {
					Set WeightGp=4
				}
				
				// 感染人数
				If '$d(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmList",EpisodeID)) {
					Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfPatSum"))
					Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfPatSum")=num+1
					Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmList",EpisodeID)=""
				}
				// 感染例次
				Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmSum"))
				Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmSum")=num+1
				// NPICC插管感染例次
				Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfNPICCSum"))
				Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfNPICCSum")=num+1
			}
		}
		// VAP感染信息
		For xDate=aFromDate:1:aToDate {
			Set xVAPID=""
			For {
				Set xVAPID=$o(^DHCHAI.IR.INFICUVAPI("IndexIRInfDate",xDate,xVAPID))
				Quit:xVAPID=""
				Set objVAP = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
				Continue:'$IsObject(objVAP)
				Continue:(objVAP.IRIsInf'=1)   // 过滤非感染信息
				Set objAdm  = objVAP.IREpisodeDr
				Continue:'$IsObject(objAdm)
				Set LocID = objVAP.IRLocDr.%Id()    // 调查科室 update for 626976
				Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(LocID)
		                Set HospID=$p(HospInfo,"^",1)
		                Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
				Continue:(objAdm.PAIsNewBaby'=1)
				Set EpisodeID = objAdm.PAEpisodeIDx
				Set Weight  = +objAdm.PAAdmitWeight
				Continue:Weight<1
				If Weight<=1000 {
					Set WeightGp=1
				} ElseIf (Weight>1000)&&(Weight<=1500) {
					Set WeightGp=2
				} ElseIf (Weight>1500)&&(Weight<=2500) {
					Set WeightGp=3
				} Else {
					Set WeightGp=4
				}
				
				// 感染人数
				If '$d(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmList",EpisodeID)) {
					Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfPatSum"))
					Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfPatSum")=num+1
					Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmList",EpisodeID)=""
				}
				// 感染例次
				Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmSum"))
				Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfAdmSum")=num+1
				// NVAP插管感染例次
				Set num=+$g(^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfNVAPSum"))
				Set ^TMP($zn,$j,"StaNICUInfection",LocID,WeightGp,"InfNVAPSum")=num+1
			}
		}
		
	}
	
	//从医院感染报告获取新生儿感染信息
	If aStatType="2" {
		//后期补充
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUInfection",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		
		Set InfPatSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfPatSum"))  // 感染人数
		Set InfAdmSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfAdmSum"))  // 感染例数
		Set InfNPICCSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfNPICCSum"))  // NPICC感染例数
		Set InfNVAPSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfNVAPSum"))    // NVAP感染例数
		
		Set InfPatSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfPatSum"))
		Set InfAdmSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfAdmSum"))
		Set InfNPICCSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfNPICCSum"))
		Set InfNVAPSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfNVAPSum"))
		
		Set InfPatSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfPatSum"))
		Set InfAdmSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfAdmSum"))
		Set InfNPICCSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfNPICCSum"))
		Set InfNVAPSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfNVAPSum"))
		
		Set InfPatSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfPatSum"))
		Set InfAdmSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfAdmSum"))
		Set InfNPICCSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfNPICCSum"))
		Set InfNVAPSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfNVAPSum"))
		Set InfAdmSum=InfAdmSum1+InfAdmSum2+InfAdmSum3+InfAdmSum4
		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(InfAdmSum,InfPatSum1,InfAdmSum1,InfNPICCSum1,InfNVAPSum1)
		Set Data=Data_$lb(InfPatSum2,InfAdmSum2,InfNPICCSum2,InfNVAPSum2)
		Set Data=Data_$lb(InfPatSum3,InfAdmSum3,InfNPICCSum3,InfNVAPSum3)
		Set Data=Data_$lb(InfPatSum4,InfAdmSum4,InfNPICCSum4,InfNVAPSum4)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaNICUInfection")
	
	Quit $$$OK
}

ClassMethod StaNICUInfectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUInfectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUInfectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUInfectionExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-10-30
/// Description:  三管感染发病率统计
/// Table：       DHCHAI.IR.ICULog
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","StaICUSurvery","","2018-02-01","2018-02-05")
Query StaICUSurvery(aHospIDs As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,TotalInHospSum:%Integer,NewInHospSum:%Integer,InHospSum:%Integer,UCSum:%Integer,PICCSum:%Integer,VAPSum:%Integer,InfPICCPatSum:%Integer,InfPICCSum:%Integer,InfUCPatSum:%Integer,InfUCSum:%Integer,InfVAPPatSum:%Integer,InfVAPSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUSurveryExecute(ByRef qHandle As %Binary, aHospIDs As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aFromDate>aToDate) $$$OK
	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Kill ^TMP($zn,$j,"StaICUSurvery")
	Kill ^TMP($zn,$j,"StaICUInfection")
	Set RstEpisArr=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aFromDate,aToDate,"W","","I")
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set IsICU = objLoc.BTIsICU
		Continue:IsICU'=1
		Set HospInfo=##Class(DHCHAI.BTS.LocationSrv).GetHospCodeByLoc(xLocID)
		Set HospID=$p(HospInfo,"^",1)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  //按科室院区过滤
		
		//插管信息
		For xDate=aFromDate:1:aToDate {
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10)=0
			Set (Item11,Item12,Item13,Item14,Item15,Item16)=0
			
			Set xLogID=$o(^DHCHAI.IR.ICULogI("IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCHAI.IR.ICULog).GetObjById(xLogID)
			Continue:'$IsObject(objLog)
			Set PICCCnt=objLog.ILIsPICC             //中心静脉置管日数
			Set VAPCnt=objLog.ILIsVAP               //呼吸机置管日数
			Set UCCnt=objLog.ILIsUC                 //导尿管置管日数
			
			Set arrInHospNew=##class(DHCHAI.IRS.ICULogSrv).GetTransIDArray(RstEpisArr,xDate,xLocID,"I")
			Set arrInfHosp=##class(DHCHAI.IRS.ICULogSrv).GetTransIDArray(RstEpisArr,xDate,xLocID,"A")
			Set InHospNewCnt=arrInHospNew.Count()   // 新入科人数
			Set InHospCnt=arrInfHosp.Count()        // 在科人数
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum")=num+InHospNewCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum")=num+InHospCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum")=num+UCCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum")=num+VAPCnt
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum")=num+PICCCnt
			
			For i=1:1:arrInfHosp.Count() {
				Set xTansID=arrInfHosp.GetAt(i)
				Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTansID)
				Continue:'$Isobject(objAdmTrans)
				Continue:'$Isobject(objAdmTrans.PAEpisodeDr)
				Set EpisodeDr=objAdmTrans.PAEpisodeDr.%Id()
				
				//update by zf 20180205 默认从感染报告取值
				//三管感染信息从ICU报告取值
				//Do ICUINFInfoByICURep(EpisodeDr,xDate,xLocID)
				//三管感染信息从感染报告取值
				Do ICUINFInfoByInfRep(EpisodeDr,xDate,xLocID)
			}
		}
		
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xLocID)
		Continue:'$isobject(objLoc)
		Set LocDesc = objLoc.BTDesc2
		Set:LocDesc="" LocDesc = objLoc.BTDesc
		Continue:LocDesc=""
		Set NewInHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
		Set InHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))
		Set UCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
		Set PICCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
		Set VAPSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
		
		Set InfPICCPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum"))
		Set InfPICCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
		Set InfUCPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum"))
		Set InfUCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
		Set InfVAPPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum"))
		Set InfVAPSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
		
		Set TotalInHospSum=NewInHospSum+InHospSum
		
		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(TotalInHospSum,NewInHospSum,InHospSum,UCSum,PICCSum,VAPSum)
		Set Data=Data_$lb(InfPICCPatSum,InfPICCSum,InfUCPatSum,InfUCSum,InfVAPPatSum,InfVAPSum)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaICUSurvery")
	Kill ^TMP($zn,$j,"StaICUInfection")
	Quit $$$OK
	
ICUINFInfoByInfRep(xEpisodeDr,xInfDate,xLocID)
	// 三管感染信息（感染报告）
	Set xDiagID=0
	For {
		Set xDiagID=$o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",xEpisodeDr,xInfDate,xDiagID))
		Quit:xDiagID=""
		
		Set objDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiagnos)
		Continue:'$IsObject(objDiagnos.IREpisodeDr)
		Continue:'$IsObject(objDiagnos.IRInfSubDr)
		Set InfSubCode=objDiagnos.IRInfSubDr.BTCode
		Continue:(InfSubCode'["CAUTI")&(InfSubCode'["VAP")&(InfSubCode'["CLABSI")&(InfSubCode'["CRBSI")
		Set EpisodeDr=objDiagnos.IREpisodeDr.%Id()
		Set InfDate=objDiagnos.IRInfDate
		
		Set arrInfRepIDs=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiagID)
		Continue:arrInfRepIDs.Count()<1
		
		If InfSubCode["CAUTI" {
			//导尿管相关泌尿系感染(CA-UTI)
			
			// UC插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum")=num+1
			
			// UC插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum")=num+1
		}
		If InfSubCode["VAP" {
			//呼吸机相关性肺炎(VAP)
			
			// VAP插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum")=num+1
			
			// VAP插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum")=num+1
		}
		If (InfSubCode["CLABSI")||(InfSubCode["CRBSI") {
			//导管相关血流感染（CLABSI）
			//导管所致血流感染（CRBSI）
			
			// PICC插管感染例次
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum")=num+1
			
			// PICC插管感染人次
			Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr)=""
			Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum"))
			Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum")=num+1
		}
	}
	Quit 1
	
ICUINFInfoByICURep(xEpisodeDr,xInfDate,xLocID)
	// 三管感染信息（ICU调查报告）
	// PICC感染信息
	Set xPICCID=""
	For {
		Set xPICCID=$o(^DHCHAI.IR.INFICUPICCI("IndexEpisInfDate",xEpisodeDr,xInfDate,xPICCID))
		Quit:xPICCID=""
		Set objPICC = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
		Continue:'$IsObject(objPICC)
		Continue:(objPICC.IRIsInf'=1)           // 过滤非感染信息
		Set objAdm  = objPICC.IREpisodeDr
		Continue:'$IsObject(objAdm)
		Set LocID = objPICC.IRLocDr.%Id()       // 调查科室
		Continue:LocID'=xLocID
		Continue:(objAdm.PAIsNewBaby=1)         // 过滤新生儿
		Set EpisodeDr = objAdm.IREpisodeDr.%Id()
		
		// PICC插管感染例次
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum")=num+1
		
		// PICC插管感染人次
		Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCAdmList",EpisodeDr)=""
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCPatSum")=num+1
	}
	// UC感染信息
	Set xUCID=""
	For {
		Set xUCID=$o(^DHCHAI.IR.INFICUUCI("IndexEpisInfDate",xEpisodeDr,xInfDate,xUCID))
		Quit:xUCID=""
		Set objUC = ##class(DHCHAI.IR.INFICUUC).GetObjById(xUCID)
		Continue:'$IsObject(objUC)
		Continue:(objUC.IRIsInf'=1)           // 过滤非感染信息
		Set objAdm  = objUC.IREpisodeDr
		Continue:'$IsObject(objAdm)
		Set LocID = objUC.IRLocDr.%Id()       // 调查科室
		Continue:LocID'=xLocID
		Continue:(objAdm.PAIsNewBaby=1)       // 过滤新生儿
		Set EpisodeDr = objAdm.IREpisodeDr.%Id()
		
		// UC插管感染例次
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum")=num+1
		
		// UC插管感染人次
		Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCAdmList",EpisodeDr)=""
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCPatSum")=num+1
	}
	// VAP感染信息
	Set xVAPID=""
	For {
		Set xVAPID=$o(^DHCHAI.IR.INFICUVAPI("IndexEpisInfDate",xEpisodeDr,xInfDate,xVAPID))
		Quit:xVAPID=""
		Set objVAP = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
		Continue:'$IsObject(objVAP)
		Continue:(objVAP.IRIsInf'=1)      // 过滤非感染信息
		Set objAdm  = objVAP.IREpisodeDr
		Continue:'$IsObject(objAdm)
		Set LocID = objVAP.IRLocDr.%Id()        // 调查科室
		Continue:LocID'=xLocID
		Continue:(objAdm.PAIsNewBaby=1)   // 过滤新生儿
		Set EpisodeDr = objAdm.IREpisodeDr.%Id()
		
		// VAP插管感染例次
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum")=num+1
		
		// VAP插管感染人次
		Continue:$d(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPAdmList",EpisodeDr)=""
		Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum"))
		Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPPatSum")=num+1
	}
	Quit 1
}

ClassMethod StaICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUSurveryExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-11-13
/// Description:  医院感染发病例次率统计
/// Input:        aHospIDs： 多个医院用|连接
/// 			  aDateType：日期类型(1：报告日期、2：感染日期)
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.StaService","QryInfReport","2","1","2017-08-01","2017-10-29")
Query QryInfReport(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,EpisodeID:%String,PatientID:%String,ReportID:%String,ReportLoc:%String,ReportDate:%String,InfDate:%String,InfLoc:%String") [ SqlProc ]
{
}

ClassMethod QryInfReportExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateType="")||(aDateFrom="")||(aDateTo="") $$$OK
		
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set:aDateFrom>+$h aDateFrom=+$h
 	//Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	
	//报告日期
	if aDateType=1 {
		For xDate=aDateFrom:1:aDateTo {
			Set xReportID = 0
			For {
				Set xReportID = $o(^DHCHAI.IR.INFReportI("IndexRepDate",1,xDate,xReportID))
				Quit:xReportID=""
				
				Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				
				Set EpisodeID = objRep.IREpisodeDr.%Id()
				Set PatientID = objRep.IREpisodeDr.PAPatientIDx
				Set ReportID  = xReportID
				Set ReportLocDr = objRep.IRRepLocDr
				Continue:'$IsObject(objRep.IRRepLocDr.BTHospDr)
				//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRep.IRRepLocDr.BTHospDr.%Id())<1)  //按医院过滤	
	
				Set ReportLoc = ""
				If ReportLocDr'=""{
					Set ReportLoc = ReportLocDr.BTDesc
					Set ReportLoc2 = ReportLocDr.BTDesc2
					Set:ReportLoc2'="" ReportLoc = ReportLoc2
				}
				Set (StatusCode,StatusDesc)=""
				If $IsObject(objRep.IRStatusDr) {
					Set StatusCode = objRep.IRStatusDr.BTCode
					Set StatusDesc = objRep.IRStatusDr.BTDesc
				}
				Continue:StatusCode'=3  // 过滤非审核状态的报告
				
				Set ReportDate = objRep.IRRepDate
				Set:ReportDate'="" ReportDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReportDate)
				Set xChild = ""
				For {
					Set xChild = $o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),ReportID,xChild))
					Quit:xChild=""
					
					Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(ReportID_"||"_xChild)
					Continue:'$IsObject(objExt)
					Set objDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(objExt.IRObjectID)
					Continue:'$IsObject(objDiagnos)
					Set InfDate = objDiagnos.IRInfDate
					Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				    Set InfLocDr=objDiagnos.IRInfLocDr
				    Continue:'$IsObject(objDiagnos.IRInfLocDr.BTHospDr)
				    Continue:(aHospIDs'="")&($listfind(aHospIDs,objDiagnos.IRInfLocDr.BTHospDr.%Id())<1)  //按医院过滤	
	                Set InfLoc = ""
					If InfLocDr'=""{
						Set InfLoc = InfLocDr.BTDesc
						Set InfLoc2 = InfLocDr.BTDesc2
						Set:InfLoc2'="" InfLoc = InfLoc2
					}
					Set Data=$lb(ind,EpisodeID,PatientID,ReportID,ReportLoc,ReportDate,InfDate,InfLoc)
        			Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	//感染日期
	}Else{
		For xDate=aDateFrom:1:aDateTo {
			Set xInfDiagID = ""
			For {
				Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xInfDiagID))
				Quit:xInfDiagID=""
				
				Set objDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
				Quit:'$IsObject(objDiagnos)
				Set EpisodeID = objDiagnos.IREpisodeDr.%Id()
				Set PatientID = objDiagnos.IREpisodeDr.PAPatientIDx
				Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xInfDiagID,""))
				Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
				Continue:'$IsObject(objRep)
				Set ReportLocDr = objRep.IRRepLocDr
				Continue:'$IsObject(objRep.IRRepLocDr.BTHospDr)
				//Continue:(aHospIDs'="")&($listfind(aHospIDs,objRep.IRRepLocDr.BTHospDr.%Id())<1)  //按医院过滤	

				Set ReportLoc = ""
				If ReportLocDr'="" {
					Set ReportLoc = ReportLocDr.BTDesc
					Set ReportLoc2 = ReportLocDr.BTDesc2
					Set:ReportLoc2'="" ReportLoc = ReportLoc2
				}
				Set (StatusCode,StatusDesc)=""
				If $IsObject(objRep.IRStatusDr) {
					Set StatusCode = objRep.IRStatusDr.BTCode
					Set StatusDesc = objRep.IRStatusDr.BTDesc
				}
				Continue:StatusCode'=3  // 过滤非审核状态的报告
				
				Set ReportDate = objRep.IRRepDate
				Set:ReportDate'="" ReportDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ReportDate)
				Set InfDate = objDiagnos.IRInfDate
				Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				Set InfLocDr=objDiagnos.IRInfLocDr
				Continue:'$IsObject(objDiagnos.IRInfLocDr.BTHospDr)
				Continue:(aHospIDs'="")&($listfind(aHospIDs,objDiagnos.IRInfLocDr.BTHospDr.%Id())<1)  //按医院过滤	
	            Set InfLoc = ""
				If InfLocDr'=""{
					Set InfLoc = InfLocDr.BTDesc
					Set InfLoc2 = InfLocDr.BTDesc2
					Set:InfLoc2'="" InfLoc = InfLoc2
				}
				Set Data=$lb(ind,EpisodeID,PatientID,ReportID,ReportLoc,ReportDate,InfDate,InfLoc)
        		Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryInfReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfReportExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-03-06
/// Description:  院感报告手术部位感染信息统计
/// Table：       DHCHAI.IR.INFReport、DHCHAI.DP.OROperAnaes
/// Input:        aHospIDs： 多个医院用"|"连接
/// Input：       aDateFrom: 开始日期
///               aDateTo  : 结束日期
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STAS.StaService","QryOPSByINFRep","","2017-03-06","2018-03-06")
Query QryOPSByINFRep(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,PulmInfNum:%Integer,OperPosInfNum:%Integer,NNIS0InfNum:%Integer,NNIS1InfNum:%Integer,NNIS2InfNum:%Integer,NNIS3InfNum:%Integer,SelectOperInfNum:%Integer,SOperPulmInfNum:%Integer,HospInfNum:%Integer") [ SqlProc ]
{
}

ClassMethod QryOPSByINFRepExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set NIndex="QryOPSByINFRep"
	Kill ^TMP($zn,$j,NIndex)
	For xDate=aDateFrom:1:aDateTo {
		Set xInfDiagID = ""
		For {
			Set xInfDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexIRInfDate",xDate,xInfDiagID))
			Quit:xInfDiagID=""
			
			Set objDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagID)
			Quit:'$IsObject(objDiagnos)
			Set EpisodeDr = objDiagnos.IREpisodeDr.%Id()
			Set PatientID = objDiagnos.IREpisodeDr.PAPatientIDx
			Set ReportID = $o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xInfDiagID,""))
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
			Continue:'$IsObject(objRep)
			Set IRInfLocDr = objDiagnos.IRInfLocDr
			Continue:'$IsObject(objDiagnos.IRInfLocDr.BTHospDr)
			Continue:(aHospIDs'="")&($listfind(aHospIDs,objDiagnos.IRInfLocDr.BTHospDr.%Id())<1)  //按医院过滤	
			Set (InfLoc ,InfLocID)= "" //  感染科室
			If IRInfLocDr'="" {
				Set InfLoc  = IRInfLocDr.BTDesc
				Set InfLoc2 = IRInfLocDr.BTDesc2
				Set:InfLoc2'="" InfLoc = InfLoc2
				Set InfLocID = IRInfLocDr.%Id()
			}
			Continue:InfLocID=""
			Set (StatusCode,StatusDesc)=""
			If $IsObject(objRep.IRStatusDr) {
				Set StatusCode = objRep.IRStatusDr.BTCode
				Set StatusDesc = objRep.IRStatusDr.BTDesc
			}
			Continue:StatusCode'=3  // 过滤非审核状态的报告
			Set InfPosDesc=""
			If $IsObject(objDiagnos.IRInfPosDr) {
				Set InfPosDesc=objDiagnos.IRInfPosDr.BTDesc
			}
			Set OperFlg=0        // 是否有手术信息
			// 取手术信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),ReportID,xSub))
				Quit:xSub=""
				Set RepExtID=ReportID_"||"_xSub
				Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(obj)
				Set ObjectID=obj.IRObjectID
				Continue:ObjectID=""
				Set objINFOPS =##class(DHCHAI.IR.INFOPS).GetObjById(ObjectID)
				Continue:'$IsObject(objINFOPS)
				Set OperFlg=1
				Set IRNNISLevelDesc=""
				Set IRNNISLevelDr = objINFOPS.IRNNISLevelDr
				If $IsObject(objINFOPS.IRNNISLevelDr){
					Set IRNNISLevelDesc = objINFOPS.IRNNISLevelDr.BTDesc
					Set:IRNNISLevelDesc'="" MapNNISDicDesc=IRNNISLevelDesc
				}
				If $IsObject(objINFOPS.IROperTypeDr){
					Set OperTypeDesc = objINFOPS.IROperTypeDr.BTDesc
					Set:OperTypeDesc'="" OperType=OperTypeDesc
				}
				Set IsOperInf   = objINFOPS.IRIsOperInf   // 是否手术切口感染
				Set IsInHospInf = objINFOPS.IRIsInHospInf // 是否引起院感
				// 患者手术部位感染例数
				If (IsOperInf=1){
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"OperPosInfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"OperPosInfNum")=num+1
				}
				// NNIS 0级 感染例数
				If (IRNNISLevelDesc="0级"){
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"NNIS0InfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"NNIS0InfNum")=num+1
				}
				// NNIS 1级 感染例数
				If (IRNNISLevelDesc="1级"){
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"NNIS1InfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"NNIS1InfNum")=num+1
				}
				// NNIS 2级 感染例数
				If (IRNNISLevelDesc="2级"){
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"NNIS2InfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"NNIS2InfNum")=num+1
				}
				// NNIS 3级 感染例数
				If (IRNNISLevelDesc="3级"){
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"NNIS3InfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"NNIS3InfNum")=num+1
				}
				If (OperTypeDesc="择期"){
					// 择期手术感染例数
					Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"SelectOperInfNum"))
					Set ^TMP($zn,$j,NIndex,InfLoc,"SelectOperInfNum")=num+1
					If (InfPosDesc="肺炎") {	
						// 择期手术患者肺部感染例数
						Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"SOperPulmInfNum"))
						Set ^TMP($zn,$j,NIndex,InfLoc,"SOperPulmInfNum")=num+1
					}
				}
			}
			If ((InfPosDesc="肺炎")&&(OperFlg=1)) {	
				// 患者肺部感染例数
				Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"PulmInfNum"))
				Set ^TMP($zn,$j,NIndex,InfLoc,"PulmInfNum")=num+1
			}
			If (OperFlg=1) {	
				// 手术相关医院感染例数
				Set num=+$g(^TMP($zn,$j,NIndex,InfLoc,"HospInfNum"))
				Set ^TMP($zn,$j,NIndex,InfLoc,"HospInfNum")=num+1
			}
		}
	}
	
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,xLocDesc))
		Quit:xLocDesc=""
		Set PulmInfNum       = +$g(^TMP($zn,$j,NIndex,xLocDesc,"PulmInfNum"))
		Set OperPosInfNum    = +$g(^TMP($zn,$j,NIndex,xLocDesc,"OperPosInfNum"))
		Set NNIS0InfNum      = +$g(^TMP($zn,$j,NIndex,xLocDesc,"NNIS0InfNum"))
		Set NNIS1InfNum      = +$g(^TMP($zn,$j,NIndex,xLocDesc,"NNIS1InfNum"))
		Set NNIS2InfNum      = +$g(^TMP($zn,$j,NIndex,xLocDesc,"NNIS2InfNum"))
		Set NNIS3InfNum      = +$g(^TMP($zn,$j,NIndex,xLocDesc,"NNIS3InfNum"))
		Set SelectOperInfNum = +$g(^TMP($zn,$j,NIndex,xLocDesc,"SelectOperInfNum"))
		Set SOperPulmInfNum  = +$g(^TMP($zn,$j,NIndex,xLocDesc,"SOperPulmInfNum"))
		Set HospInfNum       = +$g(^TMP($zn,$j,NIndex,xLocDesc,"HospInfNum"))
		
		Set Data=$lb(xLocDesc,PulmInfNum,OperPosInfNum,NNIS0InfNum,NNIS1InfNum,NNIS2InfNum,NNIS3InfNum,SelectOperInfNum,SOperPulmInfNum,HospInfNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryOPSByINFRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOPSByINFRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOPSByINFRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOPSByINFRepExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
