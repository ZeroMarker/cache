/// 名称: DHCHAI.IRS.INFReportSrv
/// 描述: 医院感染报告相关服务
/// 编写者：chenjb
/// 编写日期: 2017-07-17
Class DHCHAI.IRS.INFICUPICCSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-11-17
/// Description:  通过就诊查询本次就诊感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       aEpisodeID: 就诊ID
/// Return：      成功：返回字符串，失败：空
/// w ##class(DHCHAI.IRS.INFICUPICCSrv).GetInfRepList("20")
ClassMethod GetInfRepList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
    Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID)) return
	Set InfRepList=""
	Set xType= ""
	For {
		Set xType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xType))
		Quit:xType=""
		Continue:(xType'=1)
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xType,xID))
			Quit:xID=""
		
			Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objRep)
			Continue:'$IsObject(objRep.IRStatusDr)
			Set RepStatus = objRep.IRStatusDr.BTDesc
			Set RepStatusCode = objRep.IRStatusDr.BTCode
			Continue:RepStatusCode=4
		    Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			// 感染诊断信息
			Set (InfPosDescs,InfSubDescs,InfDateDescs,InfLocDescs)=""
			Set Flg =0
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				
				// 感染部位/感染诊断
				Set objInfPos = objDiags.IRInfPosDr
				If $IsObject(objInfPos){
					Set InfPosID = objDiags.IRInfPosDr.%Id()
					Set Flg=1
					Set InfPosDescs = InfPosDescs_","_objInfPos.BTDesc
				}
			    
				// 感染分类
				Set objInfSub = objDiags.IRInfSubDr
				If $IsObject(objInfSub){
					Set InfSubDescs = InfSubDescs_","_objInfSub.BTDesc
				}
				// 感染日期
				Set InfDate = objDiags.IRInfDate
				Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				Set:InfDate'="" InfDateDescs=InfDateDescs_","_InfDate
			}
			Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			Set:InfSubDescs'="" InfSubDescs = $e(InfSubDescs,2,$l(InfSubDescs))
			Set:InfDateDescs'="" InfDateDescs = $e(InfDateDescs,2,$l(InfDateDescs))
		    Continue:Flg=0
		    Set InfRepList =InfRepList_"^"_xID_" "_InfDateDescs_" "_InfPosDescs_" "_InfSubDescs_" "_RepStatus
		}

	}
	Set:InfRepList'="" InfRepList=$e(InfRepList,2,$l(InfRepList))
	Set return=InfRepList
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-07-07
/// Description:  查询ICU在科/出科患者
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFICUPICCSrv","QryICUAdmByStatus","2023-04-19","2023-04-19",189,"",3,"ALL","","")
Query QryICUAdmByStatus(aSttDate As %String, aEndDate As %String, aLocDr As %String, aStatus As %String, aType As %String, aIntuType As %String = "", aEpisodeID As %String = "", aDateType As %String = "") As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,AdmLocID:%String,AdmLocDesc:%String,AdmWardID:%String,AdmWardDesc:%String,PapmiNo:%String,Paadm:%String,PatientName:%String,Sex:%String,Age:%String,PAAdmBed:%String,PAAdmDate:%String,PADischDate:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,PatWeight:%String,IsNewIn:%String,IsNewOut:%String,RepID:%String,RepStatus:%String,RepUserID:%String,RepUserName:%String,RepDate:%String,RegNo:%String,APACHEScore:%String,InfInfo:%String")
{
}

ClassMethod QryICUAdmByStatusExecute(ByRef qHandle As %Binary, aSttDate As %String, aEndDate As %String, aLocDr As %String, aStatus As %String, aType As %String, aIntuType As %String = "", aEpisodeID As %String = "", aDateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:((aSttDate="")||(aEndDate="")||(aLocDr=""))&(aEpisodeID="") $$$OK
 	
 	Set:aStatus="" aStatus="0"  //默认值在科
	Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(aLocDr)
	Quit:'$Isobject(objLoc) $$$OK
	Set LocDesc=objLoc.BTDesc2 //取本地数据对象
	Set:LocDesc="" LocDesc=objLoc.BTDesc
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Quit:LocDesc="" $$$OK
	//获取是科室关联病区
	//NICU无数据
	Set:aDateType="" aDateType="1" //在院
	if ($Isobject(objLoc.BTTypeDr))&(objLoc.BTTypeDr.BTCode="E")
	{
		//如果传入的为科室
		Set aLocDr=+##class(DHCHAI.BT.LocationLink).GetLocLinks(aLocDr)	
	}
 	//Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
 	Set aSttDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
 	Set aEndDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
 	//去掉重复内容
 	Set NIndex = "QryICUAdmByStatus"
 	Kill ^TMP($zn,$j,NIndex)
 	if (aEpisodeID="")
 	{
	 	Set arrEpisodeDr=##Class(%ArrayOfDataTypes).%New()
	 	Set Count =0
	 	If (aDateType=1){
			//Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aSttDate,aEndDate,"",aLocDr,"I")
	 		Set arrTransEpis=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2(aSttDate,aEndDate,"W",aLocDr,"I")
			
			For indEpis=1:1:arrTransEpis.Count() {
				Set TransInfo=arrTransEpis.GetAt(indEpis)
				Set idxDate      = $listget(TransInfo,1)
				Set idxEpisodeDr = $listget(TransInfo,2)
				Set idxStatus    = $listget(TransInfo,3)
				Continue:(aStatus="0")&(idxStatus="D")
				//Continue:(aStatus="0")&(idxStatus="A2")  //当天入当天出 处理需求：3071429
				
				Continue:(aStatus'="0")&(idxStatus="A")
				Continue:(aStatus'="0")&(idxStatus="I")  //当天入
				
			
				Continue:$d(^TMP($zn,$j,NIndex,idxEpisodeDr))
				Set ^TMP($zn,$j,NIndex,idxEpisodeDr)=""
				Set Count=Count+1
				Do arrEpisodeDr.SetAt(idxEpisodeDr,Count)
			}
	 	}Else{
			Set xDate=aSttDate-1
			For {
				Set xDate=$o(^DHCHAI.IR.INFReportI("IndexRepDate",3,xDate))
				Quit:xDate=""
				Quit:xDate>aEndDate
						
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexRepDate",3,xDate,xRepID))
					Quit:xRepID=""
					
					Set INFRepData=$g(^DHCHAI.IR.INFReportD(xRepID))
					Continue:INFRepData=""
					Set RepStatus=$lg(INFRepData,8)
					Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
					Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)="4"
					Set iEpisodeDr =$lg(INFRepData,2)
					Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(iEpisodeDr)
					Continue:'$IsObject(objAdm)
					
					Continue:$d(^TMP($zn,$j,NIndex,iEpisodeDr))
					Set ^TMP($zn,$j,NIndex,iEpisodeDr)=""
					
					//当前科室 就诊科室 就诊病区
					Set (AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)=""
					If $IsObject(objAdm.PAAdmLocDr){
						Set AdmLocID = objAdm.PAAdmLocDr.%Id()
						Set AdmLocDesc = objAdm.PAAdmLocDr.BTDesc
						Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
						Set AdmLocDesc2 = objAdm.PAAdmLocDr.BTDesc2
						Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
					}
					If $IsObject(objAdm.PAAdmWardDr){
						Set AdmWardID = objAdm.PAAdmWardDr.%Id()
						Set AdmWardDesc = objAdm.PAAdmWardDr.BTDesc
						Set:$p(AdmWardDesc,"-",2)'="" AdmWardDesc=$p(AdmWardDesc,"-",2)
						Set AdmWardDesc2 = objAdm.PAAdmWardDr.BTDesc2
						Set:AdmWardDesc2'="" AdmWardDesc=AdmWardDesc2
					}
					Continue:(aLocDr'="")&&(aLocDr'=AdmLocID)&&(aLocDr'=AdmWardID)
					Set VisitStatus=objAdm.PAVisitStatus
					Continue:(aStatus="0")&(VisitStatus'="A")&(aEpisodeID="")
					Continue:(aStatus'="0")&(VisitStatus'="D")&(aEpisodeID="")
					Set Count=Count+1
					Do arrEpisodeDr.SetAt(iEpisodeDr,Count)
					
					
					
				}
			}
		}		
 	}
 	else
 	{
	 	Set arrEpisodeDr=##Class(%ArrayOfDataTypes).%New()
	 	Do arrEpisodeDr.SetAt(aEpisodeID,1)
	}
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set EpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:(EpisodeDr="")
		
		Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
		Continue:'$IsObject(objAdm)
		Set VisitStatus=objAdm.PAVisitStatus
		//Continue:(aStatus="0")&(VisitStatus'="A")&(aEpisodeID="")
		//Continue:(aStatus'="0")&(VisitStatus'="D")&(aEpisodeID="")
		
		Set (PatientID,PatientName,Sex,Age,Type,BedDr,BedDesc)=""
		Set xPaadm     = objAdm.%Id()
		Set PatientID  = objAdm.PAPatientIDx
		Set PatientName= objAdm.PAPatName
		Set PapmiNo    = objAdm.PAMrNo
		Set Sex        = objAdm.PASex        //性别
		Set Sex        = $s(Sex="M":"男",Sex="F":"女",1:"其他")
		Set Age        = objAdm.PAAge
		Set RegNo      = objAdm.PAPapmiNo    //登记号
		If $IsObject(objAdm.PAAdmBedDr){     // 床位
			Set BedDr  = objAdm.PAAdmBedDr.%Id()
			Set BedDesc= objAdm.PAAdmBedDr.BTDesc
		}
		Set PAAdmDate  = objAdm.PAAdmDate    //入院日期
		Set PADischDate= objAdm.PADischDate  //出院日期
		
		Set (IsPICC,IsUC,IsVAP)="0"  //无
		Set IsPICC=##class(DHCHAI.IRS.ICULogSrv).IsStartOEOrd(xPaadm,aSttDate,aEndDate,"PICC")
		Set IsUC=##class(DHCHAI.IRS.ICULogSrv).IsStartOEOrd(xPaadm,aSttDate,aEndDate,"UC")
		Set IsVAP=##class(DHCHAI.IRS.ICULogSrv).IsStartOEOrd(xPaadm,aSttDate,aEndDate,"VAP")
		Set:IsPICC="0" IsPICC=##class(DHCHAI.IRS.ICULogSrv).IsEndDtOEOrd(xPaadm,aSttDate,aEndDate,"PICC")
		Set:IsUC="0" IsUC=##class(DHCHAI.IRS.ICULogSrv).IsEndDtOEOrd(xPaadm,aSttDate,aEndDate,"UC")
		Set:IsVAP="0" IsVAP=##class(DHCHAI.IRS.ICULogSrv).IsEndDtOEOrd(xPaadm,aSttDate,aEndDate,"VAP")
		If (aIntuType'=""){ //过滤插管类型
			Continue:(aIntuType["VAP")&&(IsVAP="0")
			Continue:(aIntuType["UC")&&(IsUC="0")
			Continue:(aIntuType["PICC")&&(IsPICC="0")
		}
		
		//体重
		Set PatWeight = objAdm.PAAdmitWeight
		
		//新入科、新出科
		Set (IsNewIn,IsNewOut)=0
		If PAAdmDate'="" {
			If (PAAdmDate>aSttDate)&(PAAdmDate<aEndDate) {
				Set IsNewIn="1"   //新入科
			}
		}
		If PADischDate'="" {
			If (PADischDate>aSttDate)&(PADischDate<aEndDate) {
				Set IsNewOut="1"   //新入科
			}
		}
		
		//入院日期、出院日期
		Set:PAAdmDate'="" PAAdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PAAdmDate)
		Set:PADischDate'="" PADischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(PADischDate)
		
		//当前科室 就诊科室 就诊病区
		Set (AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)=""
		If $IsObject(objAdm.PAAdmLocDr){
			Set AdmLocID = objAdm.PAAdmLocDr.%Id()
			Set AdmLocDesc = objAdm.PAAdmLocDr.BTDesc
			Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
			Set AdmLocDesc2 = objAdm.PAAdmLocDr.BTDesc2
			Set:AdmLocDesc2'="" AdmLocDesc=AdmLocDesc2
		}
		If $IsObject(objAdm.PAAdmWardDr){
			Set AdmWardID = objAdm.PAAdmWardDr.%Id()
			Set AdmWardDesc = objAdm.PAAdmWardDr.BTDesc
			Set:$p(AdmWardDesc,"-",2)'="" AdmWardDesc=$p(AdmWardDesc,"-",2)
			Set AdmWardDesc2 = objAdm.PAAdmWardDr.BTDesc2
			Set:AdmWardDesc2'="" AdmWardDesc=AdmWardDesc2
		}
		Set:IsPICC="0" IsPICC=""
		Set:IsUC="0" IsUC=""
		Set:IsVAP="0" IsVAP=""
		Set Data=$lb(ind,aLocDr,LocDesc,AdmLocID,AdmLocDesc,AdmWardID,AdmWardDesc)
		Set Data=Data_$lb(PapmiNo,xPaadm,PatientName,Sex,Age,BedDesc,PAAdmDate,PADischDate)
		Set Data=Data_$lb(IsPICC,IsUC,IsVAP,PatWeight,IsNewIn,IsNewOut)
		
		//调查报告信息
		Set (RepID,RepStatus,RepUserID,RepUserName,RepDate,APACHEScore)=""
		Set xRepID = ""
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,aType,xRepID))
		if +xRepID'=0 {
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			if $Isobject(objRep)
			{
				Set RepID =objRep.%Id()
				if $Isobject(objRep.IRStatusDr)
				{
					Set RepStatus = objRep.IRStatusDr.BTDesc
				}
				if $Isobject(objRep.IRRepUser)
				{
					Set RepUserID = objRep.IRRepUser.%Id()
					Set RepUserName =objRep.IRRepUser.BTDesc
				}
				Set RepDate = objRep.IRRepDate
				//Set:+RepDate'=0 RepDate = $zd(RepDate,3)
				Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
				Set APACHEScore = objRep.IRAPACHEScore				
			}
		}
		Set InfInfo = ..GetInfRepList(xPaadm)
		
		Set:RepStatus="" RepStatus="未调查"
		Set Data=Data_$lb(RepID,RepStatus,RepUserID,RepUserName,RepDate,RegNo,APACHEScore,InfInfo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	} 	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryICUAdmByStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUAdmByStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUAdmByStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUAdmByStatusExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-07-07
/// Description:  根据病人查询ICU带管记录
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFICUPICCSrv","QryICUPICCByPaadm","1",22)
Query QryICUPICCByPaadm(aPaadm As %String, aLocDr As %String) As %Query(ROWSPEC = "ID:%String,IRIntuDate:%String,IRExtuDate:%String,IRPICCType:%String,IRPICCTypeDesc:%String,IRPICCCnt:%String,IRPICCCntDesc:%String,IRPICCPos:%String,IRPICCPosDesc:%String,IROperDoc:%String,IROperDocDesc:%String,IROperLoc:%String,IROperLocDesc:%String,IRIsInf:%String,IRInfDate:%String,IRInfSymptoms:%String,IRInfSymptomsDesc:%String,IRBacteria:%String,IRBacteriaDesc:%String,IsCheck:%String")
{
}

ClassMethod QryICUPICCByPaadmExecute(ByRef qHandle As %Binary, aPaadm As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aPaadm="") $$$OK
 	
 	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",aPaadm,xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set IRIntuDate = obj.IRIntuDate
		//Set:+IRIntuDate'=0 IRIntuDate=$zd(+IRIntuDate,3)
		Set:IRIntuDate'="" IRIntuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRIntuDate)
		Set IRExtuDate = obj.IRExtuDate
		//Set:+IRExtuDate'=0 IRExtuDate = $zd(+IRExtuDate,3)
		Set:IRExtuDate'="" IRExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(IRExtuDate)
		//导管类型 导管腔数 置管部位 ...
		Set (IRPICCType,IRPICCTypeDesc,IRPICCCnt,IRPICCCntDesc)=""
		Set (IRPICCPos,IRPICCPosDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)=""
		if $Isobject(obj.IRPICCType)
		{
			Set IRPICCType =obj.IRPICCType.%Id()
			Set IRPICCTypeDesc =obj.IRPICCType.BTDesc
		}
		if $Isobject(obj.IRPICCCnt)
		{
			Set IRPICCCnt =obj.IRPICCCnt.%Id()
			Set IRPICCCntDesc =obj.IRPICCCnt.BTDesc
		}
		if $Isobject(obj.IRPICCPos)
		{
			Set IRPICCPos =obj.IRPICCPos.%Id()
			Set IRPICCPosDesc =obj.IRPICCPos.BTDesc
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
		Set IsCheck=obj.IRIsCheck
		Set Data=$lb(xID,IRIntuDate,IRExtuDate,IRPICCType,IRPICCTypeDesc,IRPICCCnt,IRPICCCntDesc)
		Set Data=Data_$lb(IRPICCPos,IRPICCPosDesc,IROperDoc,IROperDocDesc,IROperLoc,IROperLocDesc)
		//感染信息
		Set Data=Data_$lb(IRIsInf,IRInfDate,IRInfSymptoms,IRInfSymptomsDesc,IRBacteria,IRBacteriaDesc,IsCheck)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryICUPICCByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUPICCByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUPICCByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUPICCByPaadmExecute ]
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
