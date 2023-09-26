/// 名称: DHCHAI.DPS.BPRegisterSrv
/// 描述: 血透登记患者服务类
/// 编写者: zhoubo
/// 编写日期: 2022-10-17
Class DHCHAI.DPS.BPRegisterSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-17
/// Description:  血透患者查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.BPRegisterSrv","QryBPAdm","^2023-05-16^2023-05-16^^^^^1")
Query QryBPAdm(aIntputs As %String) As %Query(ROWSPEC = "BPRegID:%String,PABPRegID:%String,PAEpisodeID:%String,PAPatientID:%String,PAMrNo:%String,PAPatName:%String,PapmiNo:%String,PAPatSex:%String,PAPatAge:%Float,PAPatType:%String,PABirthday:%String,PARelTel:%String,PAHDTime:%String,PAAdmDoc:%String,PAAdmNurse:%String,PAEpiInfo:%String,PABPPatType:%String,PADiagnosis:%String,PAStartDate:%String,PAEndDate:%String,PAStatusDate:%String,PAStatusTime:%String,PARegDate:%String,PARegTime:%String,AdmLocID:%String,AdmLocDesc:%String,PAIsActive:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String") [ SqlProc ]
{
}

ClassMethod QryBPAdmExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	
 	Set aHospIDs 	= $p(aIntputs,"^",1)
 	Set aDateFrom 	= $p(aIntputs,"^",2)
 	Set aDateTo  	= $p(aIntputs,"^",3)
 	Set aPatName 	= $p(aIntputs,"^",4)
 	Set aPapmiNo 	= $p(aIntputs,"^",5)
 	Set aMrNo 		= $p(aIntputs,"^",6)
 	Set aBDLocID    = $p(aIntputs,"^",7)
 	Set aDateType   = $p(aIntputs,"^",8)
 	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set NIndex = "QryBPAdm"
 	kill ^TMP($zn,$j,NIndex)
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If (aDateType=1){ // 在院日期
		// 维护血透室科室ID
		Set BDLocIDs=##class(DHCHAI.BT.Config).GetValByCode("BloodDialysisLocIDs")
		//同期在科:某段时间的在科人数
	    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I")
	    For index1=1:1:ListLocArray.Count() {
			Set TransInfo=ListLocArray.GetAt(index1)	
			Continue:TransInfo=""
			Set Date   = $LIST(TransInfo,1)
			Set Paadm  = $LIST(TransInfo,2)
			Set Status = $LIST(TransInfo,3)			
			Set LocID  = $LIST(TransInfo,4)	
			Set TansID = $LIST(TransInfo,5)
			Continue:$d(^TMP($zn,$j,NIndex,"AdmPat",Paadm)) // 避免重复取重复病人
			Set ^TMP($zn,$j,NIndex,"AdmPat",Paadm)=""
			Set LocFlag=0
			If (BDLocIDs'=""){
				Set LocLinks=##class(DHCHAI.BT.LocationLink).GetLocLinks(LocID)
				Set:LocLinks="" LocLinks=LocID
				For xi=1:1:$l(LocLinks,"|"){
					Set xLocID=$p(LocLinks,"|",xi)
					Continue:xLocID=""
					If (((","_BDLocIDs_",")[(","_xLocID_","))||((","_BDLocIDs_",")[(","_LocID_","))){
						Set LocFlag=1
					}
				}
				Continue:LocFlag'=1
			}
			Set xBPRegID = $o(^MA.HAI.DP.BPRegisterI("IndexBPRegID"," "_Paadm,0))
			Set ObjReg = ##class(DHCHAI.DP.BPRegister).GetObjById(xBPRegID)
			Continue:'$IsObject(ObjReg)
			Do BuildBPData
	    }
	}ElseIf (aDateType=2){  // 登记日期
		For xDate = aDateFrom:1:aDateTo{
			Set xTime = ""
			For {
				Set xTime = $o(^MA.HAI.DP.BPRegisterI("IndexRegDateTime",xDate,xTime))
				Quit:xTime=""
				Set xBPRegID = ""
				For {
					Set xBPRegID = $o(^MA.HAI.DP.BPRegisterI("IndexRegDateTime",xDate,xTime,xBPRegID))
					Quit:xBPRegID=""
					Do BuildBPData
				}
			}
		}
	}Else{  // 透析日期
		Set xBPRegID = ""
		For {
			Set xBPRegID = $o(^MA.HAI.DP.BPRegisterD(xBPRegID))
			Quit:xBPRegID=""
			
			// 判断患者在调查期间是否进行透析
			Set RecordID="",HDDoDate=""
			Set xRecordID = ""
			For {
				Set xRecordID = $o(^MA.HAI.DP.BPRecordI("IndexHDBPRegID",xBPRegID,xRecordID),-1)
				Quit:xRecordID=""
				Set RecordData=$g(^MA.HAI.DP.BPRecordD(xRecordID))
				Continue:RecordData=""
				Set HDDoDate = $li(RecordData,7)
				Continue:((HDDoDate<aDateFrom)||(HDDoDate>aDateTo))  // 日期过滤
				Set RecordID = xRecordID
				Quit
			}
			Continue:RecordID=""  //在调查期间没有透析记录
			
			Do BuildBPData
		}
	}
 	kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildBPData
	Set BPRegData=$g(^MA.HAI.DP.BPRegisterD(xBPRegID))
	Quit:BPRegData=""
	Set PABPRegID    = $li(BPRegData,2) 
	Set PAEpisodeID  = $li(BPRegData,3) 
	Set PAPatientID	 = $li(BPRegData,4)
	Set PAMrNo		 = $li(BPRegData,5)
	Set PAPatName	 = $li(BPRegData,6)
	Set PAPatSex	 = $li(BPRegData,7)
	Set PAPatAge	 = $li(BPRegData,8)
	Set PAPatType	 = $li(BPRegData,9)
	Set PABirthday	 = $li(BPRegData,10)
	Set PARelTel	 = $li(BPRegData,11)
	Set PAAdmLoc	 = $li(BPRegData,12)
	Set PAHDTime     = $li(BPRegData,13)
	Set PAAdmDoc	 = $li(BPRegData,14)
	Set PAAdmNurse	 = $li(BPRegData,15)
	Set PAEpiInfo    = $li(BPRegData,16)
	Set PABPPatType  = $li(BPRegData,17)
	Set PADiagnosis  = $li(BPRegData,18)
	Set PAStartDate  = $li(BPRegData,19)
	Set PAEndDate    = $li(BPRegData,20)
	Set PAStatusDate = $li(BPRegData,21)
	Set PAStatusTime = $li(BPRegData,22)
	Set PARegDate    = $li(BPRegData,23)
	Set PARegTime    = $li(BPRegData,24)
	Set PAIsActive   = $li(BPRegData,25)
	Set PapmiNo=""
	If (PAPatientID'=""){
		Set PapmiNo = $p($g(^PAPER(PAPatientID,"PAT",1)),"^",1)
	}
	Quit:(aPatName'="")&&(PAPatName'[aPatName)
	Quit:(aPapmiNo'="")&&(PapmiNo'="")&&(aPapmiNo'[PapmiNo)
	Quit:(aPapmiNo'="")&&(PapmiNo="")
	Quit:(aMrNo'="")&&(aMrNo'[PAMrNo)
	Set PAStartDate  = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStartDate)
	Set PAEndDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAEndDate)
	Set PAStatusDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAStatusDate)
	Set PARegDate    = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PARegDate)
	Set PAPatSex     = $s(PAPatSex="M":"男",PAPatSex="F":"女",1:"")
	Set PABirthday   = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PABirthday)
	Set PAPatType    = $s(PAPatType="O":"门诊",PAPatType="E":"急诊",PAPatType="EP":"急诊留观",PAPatType="I":"住院",1:"")
	Set PAIsActive   = $s(PAIsActive="1":"是",1:"否")
	Set:PAStatusTime'="" PAStatusTime=$zt(PAStatusTime,1)
	Set:PARegTime'="" PARegTime=$zt(PARegTime,1)
	
	Set AdmLocID=PAAdmLoc,AdmLocDesc=""
	If (AdmLocID'=""){
		Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocID))
		If (LocData'=""){
			Set HospDr = $li(LocData,8)
			Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
			Set AdmLocDesc = $li(LocData,3)
		}
	}
	Quit:(aBDLocID'="")&&((","_aBDLocID_",")'[(","_AdmLocID_","))
	If (PAAdmDoc'=""){
		Set PAAdmDoc = $p(PAAdmDoc,"|",3)
	}
	If (PAAdmNurse'=""){
		Set PAAdmNurse = $p(PAAdmNurse,"|",3)
	}
	Set AdmDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(+PAEpisodeID)	//入院日期
	Set AdmDate	= $p(AdmDateTime,"^",1)
	Set AdmTime	= $p(AdmDateTime,"^",2)
	Set DischDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(+PAEpisodeID)
	Set DischDate = $p(DischDateTime,"^",1)
	Set DischTime = $p(DischDateTime,"^",2)
	Set AdmDate   = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)
	//多语言处理
	Set PAPatSex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",PAPatSex,"User.CTSex")  //性别
	Set:PAPatAge["岁" PAPatAge=$Replace(PAPatAge,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
	Set:PAPatAge["月" PAPatAge=$Replace(PAPatAge,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
	Set:PAPatAge["天" PAPatAge=$Replace(PAPatAge,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
	
	Set PAAdmDoc = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
	Set PAPatType=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpregpatqry.csp",PAPatType)
	Set PAAdmNurse = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmNurse,"User.SSUser")
	Set PAEpiInfo=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpregpatqry.csp",PAEpiInfo)
	Set PABPPatType=##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpregpatqry.csp",PABPPatType)
	Set PADiagnosis = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("MRCIDDesc",PADiagnosis,"User.MRCICDDx")
	Set PAIsActive = ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.bpregpatqry.csp",PAIsActive)
	
	Set Data=$lb(xBPRegID,PABPRegID,PAEpisodeID,PAPatientID,PAMrNo,PAPatName,PapmiNo,PAPatSex,PAPatAge,PAPatType,PABirthday,PARelTel,PAHDTime,PAAdmDoc,PAAdmNurse,PAEpiInfo,PABPPatType,PADiagnosis,PAStartDate,PAEndDate,PAStatusDate,PAStatusTime,PARegDate,PARegTime,AdmLocID,AdmLocDesc,PAIsActive,AdmDate,AdmTime,DischDate,DischTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryBPAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBPAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBPAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBPAdmExecute ]
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
/// CreatDate：   2022-10-18
/// Description:  查询就诊信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.BPRegisterSrv","QryAdmInfoByName","100273")
Query QryAdmInfoByName(aIntputs As %String) As %Query(ROWSPEC = "PatientID:%String,HISEpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,AdmType:%String,AdmDate:%String,AdmTime:%String") [ SqlProc ]
{
}

ClassMethod QryAdmInfoByNameExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	Set aPatName1  = $p(aIntputs,"^",1)
 	Set aPapmiNo1  = $p(aIntputs,"^",1)
 	Set aMrNo1 	   = $p(aIntputs,"^",1)
 	
 	if (aPatName1'="")&&(ind=1){
		Set Count=0
		Set xPatName = ""
		For {
			Set xPatName=$o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName))
			Quit:xPatName=""
			
			Continue:'(xPatName[aPatName1)
			
			Set xPaadmId = ""
			For {
				Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPatName",xPatName,xPaadmId))
				Quit:xPaadmId=""
				Set Data = ..BuildPaadmData(xPaadmId)
			 	Continue:Data=""
			 	Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			Set Count=Count+1
	    	Quit:Count>10 //超过10条不在输出
		}
	}
	If (aPapmiNo1'="")&&(ind=1){
		Set xPaadmId = ""
		For {
			Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexPapmiNo",aPapmiNo1,xPaadmId))
			Quit:xPaadmId=""
			Set Data = ..BuildPaadmData(xPaadmId)
		 	Continue:Data=""
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (aMrNo1'="")&&(ind=1){
		Set xPaadmId = ""
		For {
			Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexMrNo",aMrNo1,xPaadmId))
			Quit:xPaadmId=""
			Set Data = ..BuildPaadmData(xPaadmId)
		 	Continue:Data=""
		 	Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	If (ind=1){
		Set PatientID=""
		If (aPapmiNo1'="") {
   			Set PatientID=$o(^PAPERi("PAPER_PatName",$zcvt(aPapmiNo1,"U"),""))
 		} Elseif (aMrNo1'="") {
 			Set PatientID=$o(^PAPERi("Medicare1",$zcvt(aMrNo1,"U"),"")) //病案号在病人基本信息表中(如在病案编目系统中，需单独处理)
 			Set:PatientID="" PatientID=$o(^PAPERi("Medicare",$zcvt(aMrNo1,"U"),""))
 		}Elseif (aPatName1'="") {
 			Set PatientID=$o(^PAPERi("PAPER_PatName",$zcvt(aPatName1,"U"),""))
 		}
 		Quit:PatientID="" $$$OK
		//取该人最近一次就诊号
		Set HISEpisodeID=""
		Set AdmType =""
		Set xAdmType=""
		For {
			Set xAdmType = $o(^PAPERdr(PatientID,"ADM",xAdmType),-1)
			Quit:xAdmType=""
			Quit:HISEpisodeID'=""
			Continue:(xAdmType'="O")&&(xAdmType'="I")&&(xAdmType'="E")
			Set xEpisodeID=""
			For {
				Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM",xAdmType,xEpisodeID),-1)
				Quit:xEpisodeID=""
				Set HISEpisodeID = xEpisodeID
				Set AdmType = xAdmType
				Quit:HISEpisodeID'=""
			}
		}
		//病人信息
		Set PapmiNo     = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		Set PatName     = $p($g(^PAPER(PatientID,"ALL")),"^",1)
		Set BirthDay    = $p($g(^PAPER(PatientID,"ALL")),"^",6)
		Set DeathDate   = $p($g(^PAPER(PatientID,"ALL")),"^",13)
		Set DeathTime   = $p($g(^PAPER(PatientID,"ALL")),"^",8)
		Set Sex	        = $p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
		Set MrNo        = ##Class(DHCHAI.IO.FromAdmSrv).GetMrNoByAdm(HISEpisodeID)
		Set AdmDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(+HISEpisodeID)	//入院日期
		Set AdmDate	= $p(AdmDateTime,"^",1)
		Set AdmTime	= $p(AdmDateTime,"^",2)
		Set Age = ##class(DHCHAI.IO.FromHisSrv).GetPapmiAge(PatientID,HISEpisodeID,AdmDate,AdmTime)
		Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set:AdmTime'="" AdmTime=$zt(AdmTime)
		Set AdmType = $s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="EP":"急诊留观",AdmType="I":"住院",1:"")
		
		Set Data=$lb(PatientID,HISEpisodeID,PapmiNo,MrNo,PatName,Sex,Birthday,Age,AdmType,AdmDate,AdmTime)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAdmInfoByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmInfoByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmInfoByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmInfoByNameExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID As %String) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set HISEpisodeID = $p(EpisodeIDx,"||",2)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院P、在院A、出院D、退院C、作废U
	Set PatientID  = objPaadm.PAPatientIDx
	Set PapmiNo    = objPaadm.PAPapmiNo
	Set MrNo       = objPaadm.PAMrNo
	Set PatName    = objPaadm.PAPatName
	
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	Set AdmType = $s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="EP":"急诊留观",AdmType="I":"住院",1:"")
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	
	
	Set return = $lb(PatientID,HISEpisodeID,PapmiNo,MrNo,PatName,Sex,Birthday,Age,AdmType,AdmDate,AdmTime)
	Quit return
}

}
