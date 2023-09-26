/// 名称: DHCHAI.IRS.INFCSSSHSrv
/// 描述: 医院感染病例调查相关服务(实时)
/// 编写者：pylian
/// 编写日期: 2017-08-11
Class DHCHAI.IRS.INFCSSSHSrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2021-09-13
/// Description:  获得实时现患（院感诊断未转归或院感转归未愈在院）现患患者
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QrySHAdm","")
Query QrySHAdm(aIntputs As %String) As %Query(ROWSPEC = "EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,SortAge:%Float,AdmType,VisitStatus,AdmDate,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,AdmTimes,AllDiag,OBSCnt,CurrAdmLoc,CurrAdmWard,CurrAdmBed,OperFlagDesc,OperDesc,OperType,CuteType,IsPICC,IsUC,IsVAP,AllDiag,AntiIsUser,AntUsePurpose,CombinedMed,AntIsInspected,yscl,InfSubDesc,HosInfDate,HosIRBacteria,HosInfPosDesc,HosInfDias,ComInfDate,ComIRBacteria,ComInfPosDesc,ComInfDias") [ SqlProc ]
{
}

ClassMethod QrySHAdmExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Quit:aIntputs="" $$$OK
 	Set aHospIDs 	= $p(aIntputs,"^",1)  // 院区	
 	Set aDateFrom = $p(aIntputs,"^",2)	  // 开始日期
 	Set aDateTo 	= $p(aIntputs,"^",3)  // 结束日期
 	Set aLocID 	= $p(aIntputs,"^",4)      // 科室
 	Set aHCSSFlag 	= $p(aIntputs,"^",5)      // 仅现患
    Set aLocType  = $p(aIntputs,"^",6)      // 科室类型
 	Quit:(aHospIDs="") $$$OK
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

 	Set xPaadms =""
 	Set NIndex="QrySHAdm"
	Kill ^TMP($zn,$j,NIndex)
	if (aDateFrom="")&&(aDateTo){
		//方案1. 遍历当前院感未转归患者，根据时点获取所在科室
		//Do buildData1  此功能待定，需要新建索引
	}else{
 		//方案2. 某段日期的在科人数，获取院感信息
 		Do buildData2
	}
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
buildData1	
	Set xPaadmId=""
	For {
		Set xPaadmId=$o(^DHCHAI.IR.INFDiagnosI("IndexInfXPaadm","-100000000000000"),xPaadmId)
		Quit:xPaadmId=""
		if '$d(^TMP($zn,$j,NIndex,"PaadmId",xPaadmId)){
			Set ^TMP($zn,$j,NIndex,"PaadmId",xPaadmId)=""
		}else{
			continue //一个患者只需要遍历一次
		}
		/// 获得患者基本信息
		Set PaadmData = ..BuildPaadmData(xPaadmId,aDateFrom,aDateTo,aHCSSFlag)
		Continue:PaadmData=""
	
		Set ^CacheTemp(repid,ind)=PaadmData
		Set ind=ind+1	
	}

buildData2
    Set listLocID=$listfromstring(aLocID,",")
    Set CateCode="",LocID=""
    If (aLocID'="")&($l(aLocID,",")=1){
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
		Quit:'$IsObject(objLoc) 
		Quit:'$IsObject(objLoc.BTCateDr) 
		Set CateCode=objLoc.BTCateDr.BTCode
        Set LocID=aLocID
        Set:'$IsObject(objLoc.BTTypeDr) aLocType=objLoc.BTTypeDr.BTCode
	}
    Set:aLocType'="W" aLocType="E"
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,aLocType)         
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set xPaadmId  = $LIST(TransInfo,2)
        Continue:(aLocID'="")&($listfind(listLocID,LocID)<1)
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospDr)<1)	
       
		If '$d(^TMP($zn,$j,NIndex,"PaadmId",xPaadmId)){
			Set ^TMP($zn,$j,NIndex,"PaadmId",xPaadmId)=""
		}Else{
			continue //一个患者只需要遍历一次
		}
		
		/// 获得患者基本信息
		Set PaadmData = ..GetPaadmData(xPaadmId,aDateFrom,aDateTo,aHCSSFlag)
		Continue:PaadmData=""
		
		Set ^CacheTemp(repid,ind)=PaadmData
		Set ind=ind+1
	}
}

ClassMethod QrySHAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySHAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySHAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySHAdmExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2019-11-12/2020-09-07
/// Description:  获取患者现患信息，参考自##class(DHCHAI.STATV2.AbstractComm).BuildPaadmData(就诊号)
/// 一方面 跨类调方法会影响速度，另一方面以后可能有个性化字段添加，所以方法独立出来
/// Return：      返回ROWSPEC
/// 取病人信息方法，输出列和内容不要乱动！否则上面query输出会混乱
/// w ##class(DHCHAI.IRS.INFCSSSHSrv).GetPaadmData(1,$zdh("2020-12-12",3),$zdh("2020-12-12",3))
ClassMethod GetPaadmData(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "", aHCSSFlag As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aHCSSFlag)
	Set return=""
	Quit:aEpisodeID="" return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))

	Quit:PAAdmData="" return
	
	Set Sex = $li(PAAdmData,7)
	Set Age = $li(PAAdmData,37)
	Set MrNo = $li(PAAdmData,5)
	Set PapmiNo = $li(PAAdmData,4)
	Set PatName = $li(PAAdmData,6)
	Set AdmType = $li(PAAdmData,18)
	Set AdmDate = $li(PAAdmData,20)
	Set AdmTime = $li(PAAdmData,21)
	Set AdmLocDr = $li(PAAdmData,22)
	Set AdmWardDr =$li(PAAdmData,23)
	Set AdmRoom  = $li(PAAdmData,24)
	Set AdmBedDr = $li(PAAdmData,25)
	Set AdmTimes = $li(PAAdmData,38)
	Set PatientIDx = $li(PAAdmData,3)
	Set EpisodeIDx = $li(PAAdmData,2)
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = $li(PAAdmData,19)
    
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
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
	
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set AdmDateTime=AdmDate_" "_AdmTime
	
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $li(LocData,4)
		Set LocDesc  = $li(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	Set WardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
	Set AdmWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $li(WardData,4)
		Set WardDesc  = $li(WardData,3)
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmBedData=""
	If (AdmBedDr'="") {
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
	}
	Set AdmBed=""
	If AdmBedData'="" {
		Set AdmBed = $li(AdmBedData,3)
	}
	
	//重复调用了取诊断去除20221012 by chenjb
	//Set AllDiag = ..getDiagnosInfo(aEpisodeID,aDateTo)       //疾病诊断
	//24小时内腹泻次数  针对的是当前日期
	Set OBSCnt=0
	Set xOBSToDate = +aDateFrom-1
	Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+aDateTo,"MR-ObsDiarr","腹泻")

	Set:OBSCnt>0 OBSCnt=1
	if OBSCnt=1{
		Set OBSCnt = "是"
	}else {
		Set OBSCnt = "否"
	}

	//Set CurrAdmLoc=$$getCurrAdmLoc(aEpisodeID,aDateTo)
	Set PatLocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,aDateTo,"00:00:01")
	Quit:PatLocWardInfo="" ""
	Set CurrAdmLoc  = $p(PatLocWardInfo,"^",1) // 科室
	Set:CurrAdmLoc'="" CurrAdmLoc=$lg($g(^DHCHAI.BT.LocationD(CurrAdmLoc)),4)
	Set:CurrAdmLoc="" CurrAdmLoc=AdmLocDesc     //当前科室为空则默认就诊科室
	Set CurrAdmWard  = $p(PatLocWardInfo,"^",2) // 病区
	Set:CurrAdmWard'="" CurrAdmWard=$lg($g(^DHCHAI.BT.LocationD(CurrAdmWard)),4)
	Set CurrAdmBed = $p(PatLocWardInfo,"^",3) // 床位
	Set:CurrAdmBed'="" CurrAdmBed=$lg($g(^DHCHAI.BT.PACBedD(CurrAdmBed)),3)
	/// 获取现患信息
	Set InfData = ..GetInfData(aEpisodeID,aDateFrom,aDateTo)
	if InfData=""{
		quit:aHCSSFlag=1 ""
		Set InfData=$lb("","","")
		Set InfData=InfData_$lb("","","")
		Set InfData=InfData_$lb("","","")
	}else{
		Set InfData=$ListFromString(InfData,"^")
	}
	/// 获取截止日期之前的手术信息 是否手术，手术名称 ，手术切口
	Set OperInfo = $$GetOperInfo(aEpisodeID,aDateTo)
	/// 获取一段时间内插管信息
	Set TubeInfo = ..getTubeInfo(aEpisodeID,aDateFrom,aDateTo) 
	/// 获取就诊的诊断信息
	Set AllDiag = ..getDiagnosInfo(aEpisodeID)
	/// 获取一段时间内抗菌药物信息 是否使用抗生素，使用目的，联用情况，（-使用前是否送检）
    Set AntInfo =##class(DHCHAI.STATV2.AbstractComm).GetAntCombInfo(aEpisodeID,aDateFrom,aDateTo) 
	Set len=$l(AntInfo,$c(1))
	Set AntiIsUser = "否",(AntUsePurpose,CombinedMed)=""
    for AntInd=1:1:AntInfo.Count(){
	    Set AntiIsUser = "是"
        Set OrderInfo=AntInfo.GetAt(AntInd)
        
		Set UsePurpose = $li(OrderInfo,11)
        Set:AntUsePurpose'[UsePurpose AntUsePurpose=AntUsePurpose_","_UsePurpose
		
        //联合用药等级
        Set CombCount=$lg(OrderInfo,14)
        Set:+CombCount=1 CombinedMed="一联"
        Set:+CombCount=2 CombinedMed="二联"
        Set:+CombCount=3 CombinedMed="三联"
        Set:+CombCount>=4 CombinedMed="四联及以上"
    }
    // 是否治疗前送检 AntIsInspected
	Set AntIsInspected="否"
	if (AntUsePurpose["治疗"){
		Set LabInfoArr=##class(DHCHAI.STATV2.AbstractComm).GetLabInfo(aEpisodeID,"",aDateTo)
		Set:LabInfoArr.Count()>0 AntIsInspected="是"
	}
	
	//取患者疑似标识
	Set ScAttDr = $o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,""),-1)
	Set objAtt =##class(DHCHAI.IR.CCScreenAtt).GetObjById(ScAttDr)
	Set FlagAtt = 0	,IsSuspend=""
	If ($Isobject(objAtt))
	{
		Set:(objAtt.CSIsSusInf=1) FlagAtt = 1
		//取患者疑似待处理标志
		Set IsSuspend = objAtt.CSIsSuspend
	}
	
	Set yscl = ""
	Set:(FlagAtt=1)&&(IsSuspend=0) yscl ="疑似待处理"
	Set:(FlagAtt=1)&&(IsSuspend=1) yscl ="疑似已处理"
	Set SortAge=""
	If (Age["岁")&&(Age["月"){
		Set SortAge=+$TR(+$TR(Age,"岁","."),"月")
	}
	If (Age'["岁")&&(Age["月"){
		Set SortAge="0."_+$p(Age,"月",1)
		}
	If (Age["岁")&&(Age'["月"){
		Set SortAge=+$TR(Age,"岁","")
		
		}	
		
	//就诊号，登记号，病案号，患者姓名，性别，年龄，就诊类型，住院or门诊，就诊时间，就诊科室，就诊病区
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,SortAge,AdmType,VisitStatus,AdmDate,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed)
	Set return=return_$lb(AdmTimes,AllDiag,OBSCnt,CurrAdmLoc,CurrAdmWard,CurrAdmBed)_OperInfo_TubeInfo_$lb(AllDiag,AntiIsUser,AntUsePurpose,CombinedMed,AntIsInspected,yscl)_InfData
	Quit return
///根据接口取调查结束日所在科室--当前科室
getCurrAdmLoc(EpisodeID,DateTo)
	Set PatLocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,DateTo,"00:00:01")
	Quit:PatLocWardInfo="" ""
	Set CurrAdmLoc  = $p(PatLocWardInfo,"^",1) // 科室
	Quit CurrAdmLoc

GetOperInfo(EpisodeID, aDateTo = "")
	//手术 切口类型
	Set OperFlag = 0 ,OperDesc = "" ,OperType = "" ,OperIncision=""
	
	If $d(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",EpisodeID)){
		Set xDate=""
		For {
			Set xDate = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",EpisodeID,xDate))
			Quit:xDate=""
			Continue:(aDateTo'="")&&(xDate>aDateTo)
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",EpisodeID,xDate,xID))
				Quit:xID=""	
				Set OperFlag =OperFlag+1
				
				Set OperData=$g(^DHCHAI.DP.OROperAnaesD(xID))
				Quit:OperData=""
				Set IsActive 	= $lg(OperData,31)
				Quit:IsActive'=1 
	
				Set SCode 		= $lg(OperData,22) 
				Set OperICD 	= $lg(OperData,3)
				Set subOperDesc = $lg(OperData,4)
				Set subOperType = $lg(OperData,5)
				Set Incision = $lg(OperData,16)
				Set SCode = $lg(OperData,22)
				Set IncisionInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"CuteType",Incision)  
				If (IncisionInfo'="") {
					Set ORIncision = $p(IncisionInfo,"^",3)
				}Else {
					Set ORIncision = Incision
				}
	
				Set:OperDesc'[subOperDesc OperDesc= OperDesc_","_subOperDesc   //手术名称
				Set:OperType'[subOperType OperType=OperType_","_subOperType   //手术类型
				Set:OperIncision'[ORIncision OperIncision=OperIncision_","_ORIncision   //切口等级
			}
		}
		Set:OperDesc'="" OperDesc=$e(OperDesc,2,*)
		Set:OperType'="" OperType=$e(OperType,2,*)
		Set:OperIncision'="" OperIncision=$e(OperIncision,2,*)
	}
	
	Set OperFlagDesc = "否"   //是否手术描述
	Set:+OperFlag>0 OperFlagDesc = "是"   //是否手术描述
	
	Quit $lb(OperFlagDesc,OperDesc,OperType,OperIncision)
}

/// 获取现患感染信息(基于院感报告或者疑似筛查) 可参照##class(DHCHAI.STATV2.S450SHCSSPosBac).GetInfPosInfo("133",$zdh("2019-12-01",3),$zdh("2019-12-30",3),1)
/// 要求：1.入参患者患者就诊号，开始时间，结束时间
/// 	  2.返回该患者这段时间是否现患，若是现患再返回感染分类，医院感染日期，医院感染病原体，医院感染诊断，医院感染诊断ID,社区感染日期，社区感染病原体,社区感染诊断，社区感染诊断ID
/// 	  3.如果患者有多个感染诊断，获取多个诊断
/// //获取感染科室和病区Set PatLocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,IRInfDate,"00:00:00")
/// GetInfData.
ClassMethod GetInfData(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String)
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Quit:aEpisodeID="" ""
	Set (InfSubDesc,HosInfDate,HosIRBacteria,HosInfPosDesc,HosInfDias,ComInfDate,ComIRBacteria,ComInfPosDesc,ComInfDias)=""
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
		Quit:xID=""
			
		Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.IRInfPosDr)
		Set InfDiagnosDr=obj.%Id()
		Set InfPosDr=obj.IRInfPosDr.%Id()
		Set InfPosDesc=obj.IRInfPosDr.BTDesc
		Set RepList=$$getInfRep(xID)
		Continue:RepList=""	
		Set InfDate=obj.IRInfDate
		Continue:InfDate=""
		Set InfXDate = obj.IRInfXDate
		//转归情况
		Set InfEffect=""
		Set:$IsObject(obj.IRInfEffectDr) InfEffect = obj.IRInfEffectDr.BTDesc
		Continue:(InfDate>aDateTo) 					//感染日期大于调查结束日期表明感染还未开始
		if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
		}
		
		Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
		//Continue:获取诊断病原体
		Set IRBacteria="",aDataType="DHCHAI.IR.INFLab"
		for indx1=1:1:$ll(RepList){
			Set ReportID=$lg(RepList,indx1) 
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),ReportID,xSub))
				Quit:xSub=""
		
				Set RepExtID=ReportID_"||"_xSub
				Set objExt=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(objExt)
				Set LabID=objExt.IRObjectID
				Continue:LabID=""
				Set objINFLab = ##class(DHCHAI.IR.INFLab).GetObjById(LabID)
				Continue:'$IsObject(objINFLab)
				Continue:'$IsObject(objINFLab.IREpisodeDr)
				
				Set xSubID = ""
				For {
					Set xSubID = $o(^DHCHAI.IR.INFLabD(LabID,"BACT",xSubID))
					Quit:xSubID=""
					
					Set objINFLabBact = ##class(DHCHAI.IR.INFLabBact).GetObjById(LabID_"||"_xSubID)
					Continue:'$IsObject(objINFLabBact)
					Continue:'$IsObject(objINFLabBact.IRBactDicDr)
					Set Bacteria = objINFLabBact.IRBactDicDr.BTBacDesc
					Set:IRBacteria'[Bacteria IRBacteria=IRBacteria_","_Bacteria
				}
			}
		}
		Set:IRBacteria'="" IRBacteria=$e(IRBacteria,2,*)
		
		If $IsObject(obj.IRInfSubDr) {
			Set xInfDiagDesc=obj.IRInfSubDr.BTDesc
			Set:xInfDiagDesc'="" InfPosDesc=InfPosDesc_"（"_xInfDiagDesc_"）"
		}
		set IRInfType = obj.IRInfType		//感染类型（0：社区感染，1：医院感染）
		Set:IRInfType="" IRInfType=1
		if (IRInfType=0){
			Set:ComIRBacteria'[IRBacteria ComIRBacteria=ComIRBacteria_"#"_IRBacteria
			Set:ComInfDate'[InfDate ComInfDate=ComInfDate_","_InfDate
			Set:InfSubDesc'["社区感染" InfSubDesc=InfSubDesc_",社区感染"
			Set ComInfPosDesc= ComInfPosDesc _"#"_InfPosDesc
			Set ComInfDias = ComInfDias_"#"_InfDiagnosDr
		}
		if (IRInfType=1){
			set:HosIRBacteria'[IRBacteria HosIRBacteria=HosIRBacteria_"#"_IRBacteria
			Set:HosInfDate'[InfDate HosInfDate=HosInfDate_","_InfDate
			Set:InfSubDesc'["医院感染" InfSubDesc=InfSubDesc_",医院感染"
			Set HosInfPosDesc= HosInfPosDesc _"#"_InfPosDesc
			Set HosInfDias = HosInfDias_"#"_InfDiagnosDr
		}
		Set IsReportDiag=obj.IRIsReportDiag		//是否临床上报诊断
	}
	Set:InfSubDesc'="" InfSubDesc=$e(InfSubDesc,2,*)  //$l(InfSubDesc)
	Set:HosInfDate'="" HosInfDate=$e(HosInfDate,2,*)
	Set:HosIRBacteria'="" HosIRBacteria=$e(HosIRBacteria,2,*)
	Set:HosInfDias'="" HosInfDias=$e(HosInfDias,2,*)
	Set:ComInfDate'="" ComInfDate=$e(ComInfDate,2,*)
	Set:HosInfPosDesc'="" HosInfPosDesc=$e(HosInfPosDesc,2,*)
	Set:ComIRBacteria'="" ComIRBacteria=$e(ComIRBacteria,2,*)
	Set:ComInfPosDesc'="" ComInfPosDesc=$e(ComInfPosDesc,2,*)	
	Set:ComInfDias'="" ComInfDias=$e(ComInfDias,2,*)
	
	Set return=InfSubDesc_"^"_HosInfDate_"^"_HosIRBacteria_"^"_HosInfPosDesc_"^"_HosInfDias_"^"_ComInfDate_"^"_ComIRBacteria_"^"_ComInfPosDesc_"^"_ComInfDias

	Set:InfSubDesc="" return=""
	Quit return
	
getInfRep(xDiaID)
    Set return="" 
	Set RepList="",RepFlag=0
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xDiaID)
	Quit:arrInfRep.Count()<1 return
	For indIR=1:1:arrInfRep.Count() {
		Set objInfRep=arrInfRep.GetAt(indIR)
		Continue:'$IsObject(objInfRep)
		Set RepFlag=1
		Set (ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
		If $IsObject(objInfRep.IRStatusDr) {
			Set ReportStatusID=objInfRep.IRStatusDr.%Id()
			Set ReportStatusCode=objInfRep.IRStatusDr.BTCode
			Set ReportStatusDesc=objInfRep.IRStatusDr.BTDesc
		}
        Set InfRepType=objInfRep.IRRepType
		//1保存、2提交、3审核、4作废、5退回、6取消审核
		Continue:(ReportStatusCode'="3")
		Continue:(InfRepType'=1)  //感染报告 
		Set ReportID=objInfRep.%Id()
		Continue:$listfind(RepList,ReportID)>0
		
		Set RepList=RepList_$lb(ReportID)
	}
	Quit:(RepFlag=1)&&(RepList="") return // 说明报告已删除
	//Set:RepList="" return=$listToString(RepList)
	Quit RepList
}

/// 获取患者感染病原体:基于感染报告，获到诊断再得到患者病原体（合并）（仅测试）
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryUnRepScreen","121")
/// 返回感染分类，医院感染日期，医院感染病原体，医院感染诊断，医院感染诊断ID,社区感染日期，社区感染病原体,社区感染诊断，社区感染诊断ID
ClassMethod GetInfData1(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, IRInfType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,IRInfType)
	Quit:aEpisodeID="" ""
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Set (InfSubDesc,HosInfDate,HosIRBacteria,HosInfPosDesc,HosInfDias,ComInfDate,ComIRBacteria,ComInfPosDesc,ComInfDias)=""
	/// 获取患者院感报告
	/// 获取患者院感关联检验信息
	Set RepType="",Count=0
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Quit:'$IsObject(objINFRep)
			Set RepStatus=objINFRep.IRStatusDr
			Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
			Continue:RepStatus.BTCode'="3"
			// 如果院感报告有关联病原体信息，那么就不必根据诊断去查询疑似筛查里的细菌信息了
			Set RepLabFlag="",Bacterias=""
			Set LinkLabs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFLab")
			For indx = 1:1:$l(LinkLabs,","){
				Set xLabID = $p(LinkLabs,",",indx)
				Continue:xLabID=""
				Set objINFLab = ##class(DHCHAI.IR.INFLab).GetObjById(xLabID)
				Continue:'$IsObject(objINFLab)
				Continue:'$IsObject(objINFLab.IREpisodeDr)
				
				Set xSubID = ""
				For {
					Set xSubID = $o(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
					Quit:xSubID=""
					
					Set objINFLabBact = ##class(DHCHAI.IR.INFLabBact).GetObjById(xLabID_"||"_xSubID)
					Continue:'$IsObject(objINFLabBact)
					Continue:'$IsObject(objINFLabBact.IRBactDicDr)
					Set Bacteria = objINFLabBact.IRBactDicDr.BTBacDesc
					
					Set Bacterias = Bacterias_"#"_Bacteria
					Set RepLabFlag=1
				}
			}
			// 感染诊断信息,获取部位信息
			Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
				Continue:'$IsObject(objDiags)
				// 感染日期
				Set InfDate  = objDiags.IRInfDate
				Set InfXDate = objDiags.IRInfXDate
				//转归情况
				Set InfEffect=""
				Set:$IsObject(objDiags.IRInfEffectDr) InfEffect = objDiags.IRInfEffectDr.BTDesc
				Continue:(InfDate>aDateTo) 					//感染日期大于调查结束日期表明感染还未开始
				if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
					Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
				}
				// 感染诊断
				Set objInfPos = objDiags.IRInfPosDr
				// 感染诊断
				Set InfPosDesc=obj.IRInfPosDr.BTDesc	//感染部位
				set IRInfType = obj.IRInfType		//感染类型（0：社区感染，1：医院感染）
				if (RepLabFlag=""){
					//获取病原体信息
					Set Bacterias =..getBacteria(xDiagID)
				}
			}
			Set:Bacterias'="" Bacterias = $e(Bacterias,2,$length(Bacterias))
		}
		//院内感染  感染部位 感染病原体
		//社区感染  感染部位
		Set InfBacInfo=$lb(InfSubDesc,HosInfDate,HosIRBacteria,HosInfPosDesc,HosInfDias,
		ComInfDate,ComIRBacteria,ComInfPosDesc,ComInfDias)
		Set Count=Count+1
		Do return.SetAt(InfBacInfo,Count)
	}
}

/// 根据诊断获取病原体信息（仅测试）
ClassMethod getBacteria(aDiagID As %String, aIRInfType As %String = "", ByRef Bacterias As %String = "") As %String
{
	New (aDiagID,aIRInfType,BacInfo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Set Bacterias="" //病原体+检验报告id
	Set xScreenID=""
	For {
		Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",aDiagID,xScreenID))
		Quit:xScreenID=""
		   	
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
		Continue:'$IsObject(objScreen)
		Continue:'$IsObject(objScreen.CSItmScreenDr)
		Set ItmScreenTxt =objScreen.CSItmScreenTxt
		Set:ItmScreenTxt=xScreenID ItmScreenTxt=""  //手工添加感染诊断的
		Quit:ItmScreenTxt=""
		
		Set IsConfirm =0  //判断是否有确诊
		Set xSubID=""
	   	For {
		    Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",aDiagID,xScreenID,xSubID))
		    Quit:xSubID=""
		   	Quit:IsConfirm=1
		   	Set xID =xScreenID_"||"_xSubID
		   	Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
			Continue:'$IsObject(objScreenDtl)
			Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
			Continue:(objScreen.CSStatus'=1)		
			Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
			Continue:IsActive'=1
			Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	       //项目确诊感染诊断信息ID
			Continue:InfDiagID'=DiagID
			Set IsConfirm=1
	   	}
	   	continue:IsConfirm=0
	   	Set BacDesc=$p(ItmScreenTxt," ",2)
	   	Continue:Bacterias[BacDesc
	   	Set:BacDesc'="" Bacterias=Bacterias_","_BacDesc
	   	//根据病原体名继续往下查，查到检验结果细菌类型为HA或CA的检验报告ID
	   	Set EpisodeDr = aEpisodeID
    	Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItemID))
			Quit:xItemID=""
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			Set xDate="",LabReportID=""
			Set DateTo=+$H //截止日期最晚为当天
			Set:aDateTo'="" DateTo=aDateTo   //调查结束日期记为截止时间
			For {
				Set xDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",EpisodeDr,xItemID,xDate))   //IndexItemDrRepDate对应报告审核时间   IndexItemDrActDate对应标本接受时间
				Quit:xDate=""
				Quit:xDate>DateTo
				Set xID=""
				For {
	 				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,xItemID,xDate,xID))
					Quit:xID=""
					
					Set RstData = $g(^DHCHAI.IR.CCResultD(xID))
					Continue:RstData=""
					Continue:$lg(RstData,14)'=1
					Set ActDate=$lg(RstData,8)
					Set ActTime=$lg(RstData,9)
					Set IPHour=((ActDate-AdmDate)*24)+((ActTime-AdmTime)\3600)  
					Set IPHourFlag=0             // 排除CA入院小于48小时
					Set:IPHour<48 IPHourFlag=1   // CA标志
				
					Set CCRepDate =$lg(RstData,11)
					Set CCRepTime =$lg(RstData,12)
				
					// 采集病区
			   	 	Set LocWardInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,ActDate,ActTime)
			   		Set LocDr  = $p(LocWardInfo,"^",1) // 科室
					Set WardDr = $p(LocWardInfo,"^",2) // 病区
					Continue:(aLocID'="")&&(aLocID'=LocDr)&&(aLocID'=WardDr)
								
					Set ActDateTime = ActDate_" "_ActTime
					Set RepDateTime = CCRepDate_" "_CCRepTime
			
					Set SCode    = $lg(RstData,17)             // 子系统代码
		        	Set Specimen = $lg(RstData,22)             // 原始标本名称
		        	Set SpeID="",SpeCode="",SpeDesc=""
		        	Set SpeMapID = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,Specimen,0))
					If (SpeMapID'="") {
						Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpeMapID))
						Set MapItemDr = $lg(SpecMapData,3)
						If (MapItemDr'="") {
							Set SpeID=MapItemDr
							Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(MapItemDr))
							Set:SpecData'="" SpeCode = $li(SpecData,2)
							Set:SpecData'="" SpecDesc = $li(SpecData,3)
						}
					}
					Set:SpeDesc="" SpeDesc=Specimen
	
		        	Set Bacteria = $lg(RstData,23)    //原始细菌名称
		        	Continue:Bacteria=""
		     		Set BactMapID = $o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",SCode,Bacteria,0))
					Continue:BactMapID=""
					Set BactMapData = $g(^DHCHAI.DP.LabBactMapD(BactMapID))
					Set BacID = $lg(BactMapData,3)
					Continue:BacID=""
					Set BactData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
					Continue:BactData=""
					Set BacCode = $li(BactData,2)
					Set BacDesc = $li(BactData,3)
				
					Set BacTypeCode="",BacTypeDesc=""
					Set BacTypeDr=$List(BactData,5)
					If (BacTypeDr'=""){
						Set TypeInfo = $g(^DHCHAI.DP.LabBactTypeD(BacTypeDr))
						If TypeInfo'="" {
							Set BacTypeCode = $List(TypeInfo,2)
							Set BacTypeDesc = $List(TypeInfo,3)
						}
					}
					// 判断HA
					Set ResultID=$p($lg(RstData,19),"=",2)  // 检验结果ID	
					Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(ResultID))
					Continue:RepRstData=""
					Set LabInfType       = $lg(RepRstData,13)   //感染类型标记
					Set LabReportDr      = $lg(RepRstData,2)
					Continue:LabReportDr=""
					Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
					Continue:LabReportData=""
					Set LabVisitNumberDr = $lg(LabReportData,2)
					Continue:LabVisitNumberDr=""
					
					Set Data=$lb(xID,LabVisitNumberDr,LabReportDr,ResultID,SpeDesc,BacDesc,BacTypeCode,BacTypeDesc,IPHourFlag,IsInfFlag,ActDateTime,RepDateTime,LocDr,WardDr)
			   		Set Count=Count+1
					Do return.SetAt(Data,Count)
				}
			}
				
		}
	}
	//Quit BacInfo
	Quit Bacterias
}

/// 获取抗菌药物信息
/// Creator：     liuzhenhe
/// CreatDate：   2021-07-20
/// Description:  返回患者就诊号+联用情况+抗菌用药信息...
/// 参照-##class(DHCHAI.STATV2.S132AntComb).GetAntComb("2",$zdh("2020-01-01",3),$zdh("2021-04-28",3))
/// ps.如果有抗菌药物信息，但联用为0，说明该抗菌药物没有标准对照
/// w ##class(DHCHAI.STATV2.S430SHCssAntUse).GetAntInfo("2",$zdh("2020-07-15",3),$zdh("2021-07-15",3))
ClassMethod GetAntInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String)
{
	New (aEpisodeID,aDateFrom,aDateTo)     
	
	Set MIndex="GetAntInfo"
	Kill ^TMP($zn,$j,MIndex)
	Set xScode = "",Num=1
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0	
	           
	            Set SttDate = $li(OEOrdItemData,15)	
				Set EndDate = $li(OEOrdItemData,17)
				Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
				}else{
					If EndDate=""{		// 长期医嘱未停止只计算到传入结束日期
						Set EndDate = aDateTo
					}
				}
				Continue:EndDate<aDateFrom  // 停药日期在转入日期前
				Continue:SttDate>aDateTo	// 用药日期在转出日期后
				
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				//记录抗菌药物使用
				Set AntiDesc = $li(OEOrdItemData,4)
				
				Set AntiMapDr=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xScode,AntiDesc)
				Continue:'$ISObject(AntiMapDr)
				If $ISObject(AntiMapDr)&&$ISObject(AntiMapDr.BTMapItemDr){
					Set AntiMapDesc=AntiMapDr.BTMapItemDr.BTName    //如果有标准对照取标准对照名称，纳入联用统计
					for xDate=SttDate:1:EndDate{
						Set ^TMP($zn,$j,MIndex,"AntComb",xDate,AntiMapDesc)=""   
					}
				}else{
					Set AntiMapDesc=AntiDesc
				}
				
				Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set UsePurpose = $li(OEOrdItemData,30) //用药目的
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)   
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				
				Set OEOrdLocDr=$li(OEOrdItemData,12)
				Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
				If OEOrdLocData'="" {
					Set OrdLocDesc=$li(OEOrdLocData,3)
				} Else {
					Set OrdLocDesc=$li(OEOrdItemData,39)  //ID|Code|Desc
					Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
				}
				//名称1+目的2+开始时间3+结束时间4+开医嘱科室5
				Set ^TMP($zn,$j,MIndex,aEpisodeID,Num)=AntiMapDesc_"^"_UsePurpose_"^"_SttDate_"^"_EndDate_"^"_OrdLocDesc
				Set Num=Num+1
			}
		}
	}
	//最大抗菌药物联用和日期
	Set CombCount=0
	Set xDate="",maxDate=""
	for{
		Set xDate=$o(^TMP($zn,$j,MIndex,"AntComb",xDate))
		Quit:xDate=""
		Continue:(xDate<aDateFrom)||(xDate>aDateTo)
		
		Set Count=0,xAntiDesc=""
		for{
			Set xAntiDesc=$o(^TMP($zn,$j,MIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
		}
		Set:Count>CombCount CombCount=Count,maxDate=xDate
	}
	Set Num=0
	Set xNum="",return=aEpisodeID_$C(1)_CombCount 
	for{
		Set xNum=$o(^TMP($zn,$j,MIndex,aEpisodeID,xNum))
		Quit:xNum=""
		Set return=return_$C(1)_$g(^TMP($zn,$j,MIndex,aEpisodeID,xNum))
	}

	kill ^TMP($zn,$j,MIndex)
	
	
	Quit return
}

/// 取这段时间的插管信息 ,返回字符串列表
/// w ##class(DHCHAI.IRS.INFCSSSHSrv).getTubeInfo(3,"2017-07-13","2017-07-14")
ClassMethod getTubeInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String)
{
	New (aEpisodeID,aDateFrom,aDateTo)

	//取血管，呼吸机，导尿管是否插管	
	Set IsPICC ="否",IsUC="否",IsVAP ="否"
	Set xDate = aDateFrom-1
	For {
		Set xDate = $o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Continue:'$d(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate,aEpisodeID))
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate,aEpisodeID,xID))
			Quit:xID=""	
	
			Set ICULogDtlData = $g(^DHCHAI.IR.ICULogDtlD(xID))
			Quit:ICULogDtlData=""
			set PICC  = $lg(ICULogDtlData,6) 
			Set UC 	= $lg(ICULogDtlData,7) 
			Set VAP 	= $lg(ICULogDtlData,5) 
			Set:IsPICC'="是" IsPICC= $s(PICC=1:"是",PICC=0:"否") 
			Set:IsUC'="是" IsUC= $s(UC=1:"是",UC=0:"否") 
			Set:IsVAP'="是" IsVAP= $s(VAP=1:"是",VAP=0:"否") 
		}
	}

	Quit $lb(IsPICC,IsUC,IsVAP)
}

/// 获取患者疾病诊断
/// W ##class(DHCHAI.IRS.INFCSSSHSrv).getDiagnosInfo(1)
ClassMethod getDiagnosInfo(aEpisodeID As %String, aDateTo As %String = "")
{
	New (aEpisodeID,aDateTo)
    Set listDiag=""
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set DiagnosData = $g(^DHCHAI.DP.MRDiagnosD(xDiagnosID))
		Continue:DiagnosData=""
		Set IsActive = $lg(DiagnosData,13)
		Continue:IsActive'=1
		Set MRDiagSource = $lg(DiagnosData,10)
		Continue:MRDiagSource'="C"  //临床诊断
		Set MRDiagDate= $lg(DiagnosData,8)
		Continue:(aDateTo'="")&&(aDateTo<MRDiagDate)
		Set SCode	   = $lg(DiagnosData,11)
		Set ICD10  	   = $lg(DiagnosData,3)
		Set DiagDesc   = $lg(DiagnosData,4)
		Set DiagTpCode = $lg(DiagnosData,6)
		Set DiagTpDesc = $lg(DiagnosData,7)
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
        /*If DiagTpDesc="入院诊断"{
            Set AdmitDiag = AdmitDiag_","_DiagDesc
        }elseif DiagTpDesc="主要诊断"{
            Set MainDiag = MainDiag_","_DiagDesc
        }elseif DiagTpDesc="出院诊断"{
            Set DischDiag = DischDiag_","_DiagDesc
        }else {
            Set OtherDiag = OtherDiag_","_DiagDesc
        }*/
        Set:$listfind(listDiag,DiagDesc)<1 listDiag=listDiag_$lb(DiagDesc)
	}
    /*Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
    Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
    Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
    Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
    Set AllDiag =""  //基础诊断 #
    Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
    Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
    Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
    Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
    Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
    */
    Set AllDiag=$listtostring(listDiag,"#") 
	Quit AllDiag
}

/// Creator：     chenjb
/// CreatDate：   2018-01-26
/// Description:  获取某类型的筛查项目时间段里的触发次数 "MR-ObsDiarr","腹泻" LAB-Bacteria 检出菌
/// Return：      返回ROWSPEC
/// 参考##class(DHCHAI.IRS.INFCSSSHSrv).GetKeyWordCntData("18","64496","64500","MR-ObsDiarr","腹泻")
ClassMethod GetKeyWordCntData(aEpisodeID As %String, aSttDate As %String = "", aEndDate As %String = "", aCCType As %String, aKeyWord As %String = "") As %String
{
	New (aEpisodeID, aSttDate,aEndDate,aCCType,aKeyWord)
	Set return =0
	Quit:aKeyWord="" return
	
	Set KeyWords=aKeyWord

	Set xItemID=0,num=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'=aCCType // "MR-ObsFever" 护理-发热
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:KeyWords'[tKeyword  //发热
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				Continue:'((aSttDate<=ActDate)&(aEndDate>=ActDate))
				Set return=return+1
				//Set arrResult(ActDate,"Rst",xID)=$lb(xID,ActDate)
				
				//判断是否入院48小时后项目
				//Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				//Set arrResult(ActDate,"48H",+flg)=""
			}
		}
	}
	Quit return
}

/// do ##class(DHCHAI.IRS.INFCSSSHSrv).test()
ClassMethod test()
{
	do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QrySHAdm","1|3|4^2021-09-18^2021-09-18^25^1")
}

/// Creator：     chenjb
/// CreatDate：   2018-01-26
/// Description:  横断面病例查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QryAdm","4^^2019-08-19^^^")
Query QryAdm(aIntputs As %String) As %Query(ROWSPEC = "RepID:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,AllDiag:%String,OBSCnt:%String,InfDias:%String,AntiIsUser:%String,AntUsePurpose:%String,CombinedMed:%String,AntIsSubmiss:%String,OperFlag:%String,CuteTypeID:%String ,CuteType:%String,BacDescs:%String,OperFlagDesc:%String,InfPosDescs:%String,BacIDs:%String,IRHbsAgDr:%String,IRHCVDr:%String,IRHIVDr:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,IsJMSY:%String,InfCategory:%String,CSSID:%String,IsNewBaby:%String,FlagAtt:%String") [ SqlProc ]
{
}

ClassMethod QryAdmExecute(ByRef qHandle As %Binary, aIntputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aIntputs="" $$$OK
 	
 	Set aHospIDs 	= $p(aIntputs,"^",1) 	
 	Set aLocationID = $p(aIntputs,"^",2)
 	Set aSEDate 	= $p(aIntputs,"^",3)   //调查日期
 	Set aPatName 	= $p(aIntputs,"^",4)
 	Set aPapmiNo 	= $p(aIntputs,"^",5)
 	Set aMrNo 		= $p(aIntputs,"^",6)
 	Set aFlag 		= $p(aIntputs,"^",7)   //1=现患病人 2=疑似病人 3=现患疑似病人 暂不使用
 	Quit:(aHospIDs="")||(aSEDate="") $$$OK
	
 	Set aDateFrom 	= aSEDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= aSEDate
 	//
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//某段日期的在科人数
 	Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLocationID,"I") 
 	Set xPaadms =""
 	Set NIndex="QryAdm"
	Kill ^TMP($zn,$j,NIndex)
 	For i=1:1:RstEpisArr.Count()	//
	{
		Set TransInfo= RstEpisArr.GetAt(i)
		Continue:TransInfo=""	
		Set Date   = $LIST(TransInfo,1)
		Set xPaadmId  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Set num=$i(^TMP($zn,$j,NIndex,Date,xPaadmId,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
		Continue:'((xPaadmId'="")&($listfind(xPaadms,xPaadmId)<1))  //去重复
		Set xPaadms=xPaadms_$lb(xPaadmId)
		
		Set Data = ..BuildPaadmData(xPaadmId,aHospIDs,aSEDate)
 		Continue:Data=""
 		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	//Set objItem2 = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransIDArray(RstEpisArr,xDate,LocID,"A")
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmExecute ]
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
/// CreatDate：   2018-01-26
/// Description:  横断面病例查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QryCSSByPaadm","2773","3")
Query QryCSSByPaadm(aEpisodeID As %String, aSurNumber As %String) As %Query(ROWSPEC = "RepID:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,AllDiag:%String,OBSCnt:%String,InfDias:%String,AntiIsUser:%String,AntUsePurpose:%String,CombinedMed:%String,AntIsSubmiss:%String,OperFlag:%String,CuteTypeID:%String ,CuteType:%String,BacDescs:%String,OperFlagDesc:%String,InfPosDescs:%String,BacIDs:%String,IRHbsAgDr:%String,IRHCVDr:%String,IRHIVDr:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,IsJMSY:%String,InfCategory:%String,CSSID:%String") [ SqlProc ]
{
}

ClassMethod QryCSSByPaadmExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aSurNumber As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="")||(aSurNumber="") $$$OK
 	
 	Set aHospIDs=""
	Set Data = ..BuildPaadmData(aEpisodeID,aHospIDs,aSurNumber)
 	Quit:Data="" $$$OK 		
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1	
 		
	Quit $$$OK
}

ClassMethod QryCSSByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSByPaadmExecute ]
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
/// CreatDate：   2018-02-02
/// Description:  横断面病例查询 单个患者
/// Return：      返回ROWSPEC
/// S list =  ##class(DHCHAI.IRS.INFCSSSHSrv).BuildPaadmData("671",$lb("1","2","3","4"),"3")
ClassMethod BuildPaadmData(aEpisodeID As %String, aHospIDs As %String = "", aSEDate As %String) As %String
{
	New (aEpisodeID,aHospIDs,aSEDate,aPatName,aPapmiNo,aMrNo)
	Set return=""
	Quit:aEpisodeID="" return

 	Set aDateFrom 	= aSEDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= aSEDate
 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院P、在院A、出院D、退院C、作废U
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") return
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) return
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) return

	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Nation = objPaadm.PANation
	Set Birthday = objPaadm.PABirthday
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge
	Set IdentityCode = objPaadm.PAIdentityCode
	Set HomeAddress = objPaadm.PAHomeAddress
	Set Company = objPaadm.PACompany
	Set RelativeName = objPaadm.PARelativeName
	Set RelativeTel = objPaadm.PARelativeTel
	Set IsDeath = objPaadm.PAIsDeath
	Set DeathDate = objPaadm.PADeathDate
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmTimes = objPaadm.PAAdmTimes
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
		Set HospGroupID=""
		If $isobject(objPaadm.PAAdmLocDr.BTHospDr){
			Set HospID=objPaadm.PAAdmLocDr.BTHospDr.%Id()
			Quit:($g(aHospIDs)'="")&($listfind($g(aHospIDs),HospID)<1) return	//医院过滤
		}
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	
	Set AdmRoom = objPaadm.PAAdmRoom
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
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
	Set AdmDays = objPaadm.PAAdmDays
	if AdmDays=-1{
		Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
	}
	Set IsNewBaby = objPaadm.PAIsNewBaby
	Set BirthWeight = objPaadm.PABirthWeight
	Set AdmitWeight = objPaadm.PAAdmitWeight
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set ICD10  	   = objDiagnos.MRDiagICD10
		Set DiagDesc   = objDiagnos.MRDiagDesc
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
		If DiagTpDesc="入院诊断"{
			Set AdmitDiag = AdmitDiag_","_DiagDesc
		}elseif DiagTpDesc="主要诊断"{
			Set MainDiag = MainDiag_","_DiagDesc
		}elseif DiagTpDesc="出院诊断"{
			Set DischDiag = DischDiag_","_DiagDesc
		}else {
			Set OtherDiag = OtherDiag_","_DiagDesc
		}
	}
	Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
	Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
	Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
	Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
	Set AllDiag =""  //基础诊断 #
	Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
	Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
	Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
	Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
	Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
	//取报告横断面调查
	Set xRepID = ""
	Set CSSID = "" 
	Set xRepID = "" //$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"7",xRepID))
	Set IRHbsAgDr = "",IRHCVDr="",IRHIVDr="",IsPICC ="",IsUC="",IsVAP =""
	if (xRepID ="")
	{
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			Set InfSubDesc=""
			If $IsObject(obj.IRInfSubDr) {
				Set InfSubDesc=obj.IRInfSubDr.BTDesc
			}
			Set IsReportDiag=obj.IRIsReportDiag
			
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
			Set ReportCnt=listReports.Count()
			
			// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
			If (IsReportDiag=1)&&(ReportCnt<1){
				Continue
			}
			Set IRBacteria = obj.IRBacteria  //病原体#分割
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr
			Set:InfDias="" InfDias = InfDiagnosDr	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
		//抗菌药物 用药目的 0 预防 1 治疗 联合用药 是否送检
		Set AntiIsUser =0,AntUsePurpose ="",CombinedMed = "",AntIsSubmiss =0
		Set xItemID=0,xNum=0
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
			Quit:xItemID=""
			
			Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItmMast)
			Continue:objItmMast.CCCode'="OE-AntiUse" // 抗菌用药
			
			Set xKeyWordDr=""
			For {
				Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
				Quit:xKeyWordDr=""
				
				Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
				Continue:'$IsObject(objKeyWord)
				Set tKeyword=objKeyWord.CCDesc
				Continue:"抗菌用药"'[tKeyword  //
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.CCEpisodeDr)
					Continue:'$IsObject(obj.CCItemDr)
					Continue:obj.CCIsActive'=1
					
					Set SCode=obj.CCSCode
					Set ActDate=obj.CCActDate
					Set RepDate=obj.CCRepDate
					Continue:ActDate=""
					Set xObjItem = ##class(DHCHAI.DP.OEOrdItem).GetObjById(obj.CCObjectID)
					Continue:'$Isobject(xObjItem)
					Continue:xObjItem.OEIsActive=0  //无效作废医嘱不算
					Set xNum =xNum + 1
					Set AntiIsUser = 1
					Set:xObjItem.OEAntIsSubmiss AntIsSubmiss=1   //是否送检
					Set:obj.CCIsAbFlag AntUsePurpose="治疗"
					Set:obj.CCIsAbFlag=0 AntUsePurpose="预防"
				}
			}
		}
		Set CombinedMed  = $s(xNum=1:"一联",xNum=2:"二联",xNum=3:"三联",xNum=4:"四联",xNum>4:"四联以上",1:"")
		//手术 切口类型
		Set OperFlag = 0 ,CuteTypeID = "" ,CuteType = ""
		Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""		
			
			Set OperFlag =OperFlag+1
			Set OperAnaData = ##class(DHCHAI.DPS.OROperAnaesSrv).BuildOperData(xID,"")
			Continue:OperAnaData=""
			
			Set CuteTypeID 	= $lg(OperAnaData,18)  //切口类型
			Set CuteType 	= $lg(OperAnaData,19)
		}
		Set OperFlagDesc = "否"   //是否手术描述
		Set:OperFlag>0 OperFlagDesc = "是"   //是否手术描述		
		//药敏耐药性
		Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0,BacDescs="",BacIDs = ""     //HA、HA重复、定值、定值重复
	    Set ResultList=""
	    Set ListVisitArray=##class(DHCHAI.STAS.StaService).GetVisitNumber(aEpisodeID,aDateFrom,aDateTo)
		For indx=1:1:ListVisitArray.Count() {
		    Set VisitInfo=ListVisitArray.GetAt(indx)	
			Continue:VisitInfo=""
			Set LabNumID  = $LIST(VisitInfo,1)			
		    //Set IPHour=((RecDate-AdmDate)*24)+((RecTime-AdmTime)\3600)  //排除CA
			//Continue:IPHour<48
			Set ListResultArray=##class(DHCHAI.STAS.StaService).GetVisitRepResult(LabNumID)
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
				/* //判断HA重复 ？
				If ((ResultList'="")&&($listfind(ResultList,BacDesc)>0)) { 
					Set IsHACF=1 
					Continue:IsHACF=1                     
				}
				*/			
				Set xSenID = "",AntiStr=""
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
					
					Set MapTestSenDesc = $s(MapTestSen="R":"耐药",MapTestSen="S":"敏感",MapTestSen="I":"中介",MapTestSen="SDD":"SDD",1:"未对照")
					Set:AntiStr'="" AntiStr=AntiStr_"||"_AntDesc_":"_MapTestSenDesc
					Set:AntiStr="" AntiStr=AntDesc_":"_MapTestSenDesc
				}
				Set ResultList=ResultList_$lb(BacID_"^"_BacDesc_"||"_AntiStr)
			}
		}
		
		For indx=1:1:$ll(ResultList) {
			Set tmp = $lg(ResultList,indx)
			Set IDTmp = $p(tmp,"^",1)
			Set BacDesc=$p(tmp,"^",2)
			Set:BacIDs'="" BacIDs=BacIDs_"#"_IDTmp
			Set:BacIDs="" BacIDs=IDTmp
			Set:BacDescs'="" BacDescs=BacDescs_"#"_BacDesc
			Set:BacDescs="" BacDescs=BacDesc
		}	
	}
	
	Set IsNewBaby   = objPaadm.PAIsNewBaby   // 新生儿标志
	Set AdmitWeight = objPaadm.PAAdmitWeight // 新生儿入院体重
	//取患者疑似标识
	Set ScAttDr = $o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,""),-1)
	Set objAtt =##class(DHCHAI.IR.CCScreenAtt).GetObjById(ScAttDr)
	Set FlagAtt = 0	
	If ($Isobject(objAtt))
	{
		Set:(objAtt.CSIsSusInf=1) FlagAtt = 1
	}
	
	//,HomeAddress,Company,RelativeName,RelativeTel,IsDeath,DeathDate,DeathTime,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc,IsNewBaby,BirthWeight,AdmitWeight,AdmTimes,AdmDays,MainDiag,AdmitDiag,OtherDiag,DischDiag
	Set return = $lb(xRepID,SurvNumber,aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,IdentityCode,AdmTimes,AllDiag,OBSCnt,InfDias,AntiIsUser,AntUsePurpose,CombinedMed,AntIsSubmiss,OperFlag,CuteTypeID ,CuteType,BacDescs,OperFlagDesc,InfPosDescs,BacIDs)
	Set return =return_$lb(IRHbsAgDr,IRHCVDr,IRHIVDr,IsPICC,IsUC,IsVAP,IsJMSY,InfCategory,CSSID,IsNewBaby,FlagAtt)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-04-03
/// Description:  横断面病例查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","StaCSSByNo","1|2|3|4","6","")
Query StaCSSByNo(aHospIDs As %String, aSurNumber As %String, aLocIDs As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,SurNumber:%String,xPaadmId:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmTimes:%String,AllDiag:%String,AdmBed:%String,RepID:%String,IsOpr:%String,CutType:%String,InfType:%String,InfPosDesc:%String,InfDiagDesc:%String,InfDateDesc:%String,InfPosBac:%String,IsAnti:%String,AntiComb:%String,AntiPos:%String,AntiSen:%String,RepUser:%String,RepLoc:%String,RepDate,IRHbsAg:%String,IRHCV:%String,IRHIV:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,IsJMSY:%String,IsXH:%String") [ SqlProc ]
{
}

ClassMethod StaCSSByNoExecute(ByRef qHandle As %Binary, aHospIDs As %String, aSurNumber As %String, aLocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aHospIDs="")||(aSurNumber="") $$$OK
 	
 	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumber)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber
 	//
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	/// 取所有需要调查的科室  默认是全院科室
	Set NIndex="StaCSSByNo"
	Kill ^TMP($zn,$j,NIndex)

    //同期在科天数
    Set Count=0,num=0
    Set ListArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E","","I") //某段时间的在科人数
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
        Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocID)
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Continue:(aLocIDs'="")&(aLocIDs'=LocID)  //按科室过滤
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
		Set LocDesc	    = ##class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(xLocDesc)
		Set xPaadm="",xPaadms = ""
		For {
			Set xPaadm=$o(^TMP($zn,$j,NIndex,xLocID,xPaadm))
			Quit:xPaadm=""
			
			Set (EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,AdmTimes,AllDiag,AdmBed,AdmDays)=""
			
			Continue:'((xPaadm'="")&($listfind(xPaadms,xPaadm)<1))  
			Set xPaadms=xPaadms_$lb(xPaadm)
			
			Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadm)
			Continue:'$isobject(objPaadm)
			
			Set EpisodeIDx=objPaadm.PAEpisodeIDx
			Set SCode = $p(EpisodeIDx,"||",1)
			Set VisitStatus = objPaadm.PAVisitStatus
			Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
			If VisitStatusInfo'="" {
				Set VisitStatus=$p(VisitStatusInfo,"^",2)
			}
			Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
			
			Set EpisodeIDx = objPaadm.PAEpisodeIDx
			Set PatientIDx = objPaadm.PAPatientIDx
			Set PapmiNo = objPaadm.PAPapmiNo
			Set MrNo = objPaadm.PAMrNo
			Set PatName = objPaadm.PAPatName

			Set Sex = objPaadm.PASex
			Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
			Set Birthday = objPaadm.PABirthday
			Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
			Set Age = objPaadm.PAAge
			Set IsDeath = objPaadm.PAIsDeath
			
			Set AdmType = objPaadm.PAAdmType
			Set AdmDate = objPaadm.PAAdmDate
			Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set AdmTime = objPaadm.PAAdmTime
			Set:AdmTime'="" AdmTime=$zt(AdmTime)
			Set objAdmLoc = objPaadm.PAAdmLocDr
			Set AdmTimes = objPaadm.PAAdmTimes
			
			
			Set AdmRoom = objPaadm.PAAdmRoom
			Set (AdmBedDr,AdmBed)=""
			If $IsObject(objPaadm.PAAdmBedDr){
				Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
				Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
			}
			
			Set AdmDays = objPaadm.PAAdmDays
			if AdmDays=-1{
				Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
			}
			// 增加返回诊断信息
			Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
			Set xDiagnosID = ""
			For {
				Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",xPaadm,xDiagnosID))
				Quit:xDiagnosID=""
				
				Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
				Continue:'$isobject(objDiagnos)
				Set IsActive = objDiagnos.MRIsActive
				Continue:IsActive'=1
				Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
				Set SCode	   = objDiagnos.MRSCode
				Set ICD10  	   = objDiagnos.MRDiagICD10
				Set DiagDesc   = objDiagnos.MRDiagDesc
				Set DiagTpCode = objDiagnos.MRDiagTpCode
				Set DiagTpDesc = objDiagnos.MRDiagTpDesc
				Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
				If DiagTypeMap'="" {
					Set DiagTpCode=$p(DiagTypeMap,"^",2)
					Set DiagTpDesc=$p(DiagTypeMap,"^",3)
				}
				
				If DiagTpDesc="入院诊断"{
					Set AdmitDiag = AdmitDiag_","_DiagDesc
				}elseif DiagTpDesc="主要诊断"{
					Set MainDiag = MainDiag_","_DiagDesc
				}elseif DiagTpDesc="出院诊断"{
					Set DischDiag = DischDiag_","_DiagDesc
				}else {
					Set OtherDiag = OtherDiag_","_DiagDesc
				}
			}
			Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
			Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
			Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
			Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
			Set AllDiag =""  //基础诊断 #
			Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
			Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
			Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
			Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
			Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
			//横断面调查信息
			Set xRepID = ""
			Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xPaadm,"7",xRepID))			
			Set (RepID,IsOpr,CuteType,InfType,InfPosDesc,InfDiagDesc,InfDateDesc,InfPosBac,IsAnti,AntiComb,AntiPos,AntiSen,RepUser,RepLoc,RepDate)=""
			Set (IRHbsAg,IRHCV,IRHIV,IsPICC,IsUC,IsVAP,IsJMSY)=""  
			Set IsXH=0 //现患例次数
			if (xRepID'=""){
				//取报告里的信息
				Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				if $Isobject(xObjRep) {
					Set:$Isobject(xObjRep.IRRepUser) RepUser = xObjRep.IRRepUser.BTDesc
					Set:$Isobject(xObjRep.IRRepLocDr) RepLoc = xObjRep.IRRepLocDr.BTDesc
					Set RepDate = ##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xObjRep.IRRepDate)
					Set RepID = xRepID				
					Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
					Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
					if $IsObject(xObj) {
						Set InfType = xObj.IRInfCategoryDr  //0院内/1社区感染
						Set OBSCnt        = xObj.IROBSDiarrhea   //是否腹泻
						Set:+OBSCnt>0 OBSCnt= 1
						Set IsOpr      = xObj.IROperFlag      //是否手术
						Set CuteTypeID="",CuteType=""            //手术切口
						If $IsObject(xObj.IROperCuteTypeDr) {
							Set CuteTypeID = xObj.IROperCuteTypeDr.%Id()
							Set CuteType   = xObj.IROperCuteTypeDr.BTDesc
						}
						Set IsAnti    = xObj.IRAntiFlag      //是否抗菌药物
						Set AntiPos     = xObj.IRAntiUsePurposeDr
						Set:$Isobject(AntiPos) AntiPos=AntiPos.BTDesc
						Set AntiComb = xObj.IRAntiCombinedMedDr
						Set:$Isobject(AntiComb) AntiComb =AntiComb.BTDesc 
						Set AntiSen  = xObj.IRAntiSenFlag   //是否药敏用药
						//药敏
						//Set IsHA=0,IsHACF=0,IsDZ=0,IsDZCF=0,BacDescs=""
						Set:$Isobject(xObj.IRHbsAgDr) IRHbsAg =xObj.IRHbsAgDr.BTDesc
						Set:$Isobject(xObj.IRHCVDr) IRHCV = xObj.IRHCVDr.BTDesc
						Set:$Isobject(xObj.IRHIVDr) IRHIV =xObj.IRHIVDr.BTDesc
						Set IsPICC = xObj.IRAddPICC
						Set IsUC = xObj.IRAddUC
						Set IsVAP = xObj.IRAddVAP
						Set IsJMSY = xObj.IRAddJMSY	
						//感染信息
						Set InfPosList="",InfSubList="",InfDateList=""
						Set InfDiagList=xObjRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
						For indInfD=1:1:$l(InfDiagList,","){													
							Set xInfDiagnosID=$p(InfDiagList,",",indInfD)
							Continue:xInfDiagnosID=""
							Set objInfDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xInfDiagnosID)
							Continue:'$IsObject(objInfDiagnos)
							Continue:'$IsObject(objInfDiagnos.IRInfPosDr)			
							Set tInfPos=objInfDiagnos.IRInfPosDr.BTDesc
							Set tInfSub=objInfDiagnos.IRInfSubDr.BTDesc
							Set tInfDate=objInfDiagnos.IRInfDate
							Set InfXDate=objInfDiagnos.IRInfXDate
							
							//Continue:tInfDate>aDateFrom  //调查时未感染开始
							Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
							//Set:tInfDate="" tInfDate=$zd(tInfDate,3)
							Set:tInfDate'="" tInfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(tInfDate)
							Set InfPosList=InfPosList_$lb(tInfPos)
							Set InfSubList=InfSubList_$lb(tInfSub)
							Set InfDateList=InfDateList_$lb(tInfDate)
							Set InfPosBac =objInfDiagnos.IRBacteria
							
						}
						Set IsXH = $ll(InfPosList)
						Set InfPosDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfPosList,";")
						Set InfDiagDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSubList,";")
						Set InfDateDesc=##class(DHCHAI.Utils.CommonSrv).ListToString(InfDateList,";")									
					}
				}
			}
			Set Data = $lb(xLocID,LocDesc,SurNumber,xPaadm,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,AdmTimes,AllDiag,AdmBed)		
			Set Data =Data_$lb(RepID,IsOpr,CuteType,InfType,InfPosDesc,InfDiagDesc,InfDateDesc,InfPosBac,IsAnti,AntiComb,AntiPos,AntiSen,RepUser,RepLoc,RepDate)
			Set Data =Data_$lb(IRHbsAg,IRHCV,IRHIV,IsPICC,IsUC,IsVAP,IsJMSY,IsXH)
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
		}
	}
	Quit $$$OK
}

ClassMethod StaCSSByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaCSSByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StaCSSByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaCSSByNoExecute ]
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
/// CreatDate：   2017-03-07
/// Description:  通过编码查询
/// Table：       DHCHAI.BT.Config
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QueryByCode","1|2|3|4")
Query QueryByCode(aHospIDs As %String = "") As %Query(ROWSPEC = "ID:%String,SESurvNumber:%String,SESurvSttDate:%String,SESurvEndDate:%String,HospDr:%String,HospCode:%String,HospDesc:%String,UserDr:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryByCodeExecute(ByRef qHandle As %Binary, aHospIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set aCode=$ZCVT($g(aCode),"U")
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.SurveyExecD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.SurveyExec).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.SESurvNumber
	 	Set SESurvSttDate=obj.SESurvSttDate
	 	Set SESurvEndDate=obj.SESurvEndDate
		Set HospID="",HospCode="",HospDesc=""
		If $IsObject(obj.SEHospDr) {
			Set HospID  =obj.SEHospDr.%Id()
	 		Set HospCode=obj.SEHospDr.BTCode
	 		Set HospDesc=obj.SEHospDr.BTDesc
	 		Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)
		}
		
		Set UserDr="",UserDesc=""
		If $IsObject(obj.SEUpdateUserDr) {
			Set UserDr=obj.SEUpdateUserDr.BTCode
			Set UserDesc=obj.SEUpdateUserDr.BTDesc
		}
		Set:SESurvSttDate'="" SESurvSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvSttDate)
		Set:SESurvEndDate'="" SESurvEndDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvEndDate)
		Set Data=$lb(ID,Code,SESurvSttDate,SESurvEndDate,HospID,HospCode,HospDesc,UserDr,UserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByCodeExecute ]
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

/// Creator：     zhangdc/chenr
/// CreatDate：   2020-09-07
/// Description:  实时现患列表查询
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFCSSSHSrv","QryAdms","1|2","2019-11-14","")
Query QryAdms(aHospIDs As %String, aDateFrom As %String, aLoc As %String = "") As %Query(ROWSPEC = "RepID:%String,SurvNumber:%String,EpisodeID:%String,EpisodeIDx:%String,PatientIDx:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmTimes:%String,AllDiag:%String,OBSCnt:%String,InfDias:%String,AntiIsUser:%String,AntUsePurpose:%String,CombinedMed:%String,AntIsSubmiss:%String,OperFlag:%String,CuteTypeID:%String ,CuteType:%String,BacDescs:%String,OperFlagDesc:%String,InfPosDescs:%String,BacIDs:%String,IRHbsAgDr:%String,IRHCVDr:%String,IRHIVDr:%String,IsPICC:%String,IsUC:%String,IsVAP:%String,IsJMSY:%String,InfCategory:%String,CSSID:%String,IsNewBaby:%String,FlagAtt:%String,zy:%String,ygbg:%String,lcgy:%String,yscl:%String,AdmitDate:%String,DischDate:%String,IsSuspend:%String,InfSubDesc:%String,HosInfDate:%String,HosIRBacteria:%String,ComInfDate:%String,ComIRBacteria:%String,OperDesc:%String,AdmLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAdmsExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=aDateFrom
	Quit:(aHospIDs="")||(aDateFrom="") $$$OK
 	//某段日期的在科人数
 	Set RstEpisArr = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(aDateFrom,aDateTo,"E",aLoc,"I") 
 	Set xPaadms =""
 	Set NIndex="QryAdms"
	Kill ^TMP($zn,$j,NIndex)
 	For i=1:1:RstEpisArr.Count()	//
	{
		Set TransInfo= RstEpisArr.GetAt(i)
		Continue:TransInfo=""	
		Set Date   = $LIST(TransInfo,1)
		Set xPaadmId  = $LIST(TransInfo,2)
		Set Status = $LIST(TransInfo,3)			
		Set LocID  = $LIST(TransInfo,4)	
		Set TansID = $LIST(TransInfo,5)
		Set num=$i(^TMP($zn,$j,NIndex,Date,xPaadmId,LocID))
		Continue:num>1                        //当天转出不算在内
		Continue:(Status="I")                 //当天转入不算在内
		Continue:'((xPaadmId'="")&($listfind(xPaadms,xPaadmId)<1))  //去重复
		Set xPaadms=xPaadms_$lb(xPaadmId)
		Set Data = ..BuildPaadmDatas(xPaadmId,aHospIDs,aDateFrom,aDateTo)
 		Continue:Data=""
 		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	//Set objItem2 = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransIDArray(RstEpisArr,xDate,LocID,"A")
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAdmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmsExecute ]
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

/// Creator：     zhangdc/chenr
/// CreatDate：   2019-11-12/2020-09-07
/// Description:  实时现患列表 单个患者
/// Return：      返回ROWSPEC
/// S list =  ##class(DHCHAI.IRS.INFCSSSHSrv).BuildPaadmDatas("580","1|3|4","2020-12-08","2020-12-08")
ClassMethod BuildPaadmDatas(aEpisodeID As %String, aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aHospIDs,aDateFrom,aDateTo,aPatName,aPapmiNo,aMrNo)
	Set return=""
	Quit:aEpisodeID="" return

 	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	//增加入院日期和出院日期
	Set AdmitDate=objPaadm.PAAdmDate
	If (AdmitDate'="")
	{
		Set AdmitDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmitDate)
	}
	Set DischDate=objPaadm.PADischDate
	If (DischDate'="")
	{
		Set DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	}
	
	Set EpisodeIDx=objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院P、在院A、出院D、退院C、作废U
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx	//就诊序号
	Set PatientIDx = objPaadm.PAPatientIDx	//病人主索引
	Set PapmiNo = objPaadm.PAPapmiNo	//登记号
	Set MrNo = objPaadm.PAMrNo			//病案号
	Set PatName = objPaadm.PAPatName	//姓名
	Quit:('(PatName[$g(aPatName)))&&($g(aPatName)'="") return
	Quit:($g(aPapmiNo)'="")&&($g(aPapmiNo)'=PapmiNo) return
	Quit:($g(aMrNo)'="")&&($g(aMrNo)'=MrNo) return

	Set Sex = objPaadm.PASex	//性别
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Nation = objPaadm.PANation	//民族
	Set Birthday = objPaadm.PABirthday	//生日
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set Age = objPaadm.PAAge	//年龄
	Set IdentityCode = objPaadm.PAIdentityCode	//身份证
	Set HomeAddress = objPaadm.PAHomeAddress	//家庭住址
	Set Company = objPaadm.PACompany			//单位
	Set RelativeName = objPaadm.PARelativeName	//联系人
	Set RelativeTel = objPaadm.PARelativeTel	//联系电话
	Set IsDeath = objPaadm.PAIsDeath			//死亡标志
	Set DeathDate = objPaadm.PADeathDate		//死亡日期
	Set:DeathDate'="" DeathDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DeathDate)
	Set DeathTime = objPaadm.PADeathTime		//死亡时间
	Set:DeathTime'="" DeathTime=$zt(DeathTime)
	Set AdmType = objPaadm.PAAdmType			//就诊类型
	//Set AdmDate = objPaadm.PAAdmDate			//入院日期
	//Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime			//入院时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr			//就诊科室
	Set AdmTimes = objPaadm.PAAdmTimes
	
	
	
	
	
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
	
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)

	}
	//判断病人是否转科，如果转科，当前科室就是转科科室，如果没有则为就诊科室
	Set zk=""
	if $d(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID)) 
	{
		for{
			s zk=$O(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID,zk))
			quit:zk=""
			set objzk = ##class(DHCHAI.DP.PAAdmTrans).GetObjById(zk)
			quit:'$isobject(objzk)
			set AdmLocDesc = objzk.PATransLocDr.BTDesc
			quit:aDateFrom<=objzk.PATransDate
		}
	}
	
	
	
	
	Set objAdmWard = objPaadm.PAAdmWardDr			//就诊病区
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmRoom = objPaadm.PAAdmRoom			//就诊房间
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objPaadm.PAAdmBedDr){
		Set AdmBedDr=objPaadm.PAAdmBedDr.%Id()
		Set AdmBed=objPaadm.PAAdmBedDr.BTDesc
	}
	
	Set DischDate = objPaadm.PADischDate		//出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime		//出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr		//出院科室
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr	//出院日期
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmDays = objPaadm.PAAdmDays			//住院天数
	if AdmDays=-1{
		Set AdmDays = (+$h)-objPaadm.PAAdmDate+1	//未出院患者计算入院到当天天数
	}
	Set IsNewBaby = objPaadm.PAIsNewBaby		//是否是新生儿
	Set BirthWeight = objPaadm.PABirthWeight	//新生儿出生体重
	Set AdmitWeight = objPaadm.PAAdmitWeight	//新生儿入院体重
	// 增加返回诊断信息
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		Set SCode	   = objDiagnos.MRSCode
		Set ICD10  	   = objDiagnos.MRDiagICD10
		Set DiagDesc   = objDiagnos.MRDiagDesc
		Set DiagTpCode = objDiagnos.MRDiagTpCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		
		If DiagTpDesc="入院诊断"{
			Set AdmitDiag = AdmitDiag_","_DiagDesc
		}elseif DiagTpDesc="主要诊断"{
			Set MainDiag = MainDiag_","_DiagDesc
		}elseif DiagTpDesc="出院诊断"{
			Set DischDiag = DischDiag_","_DiagDesc
		}else {
			Set OtherDiag = OtherDiag_","_DiagDesc
		}
	}
	Set:MainDiag'="" MainDiag = $e(MainDiag,2,$l(MainDiag))
	Set:AdmitDiag'="" AdmitDiag = $e(AdmitDiag,2,$l(AdmitDiag))
	Set:DischDiag'="" DischDiag = $e(DischDiag,2,$l(DischDiag))
	Set:OtherDiag'="" OtherDiag = $e(OtherDiag,2,$l(OtherDiag))
	Set AllDiag =""  //基础诊断 #
	Set:MainDiag'="" AllDiag = AllDiag_"#"_MainDiag
	Set:AdmitDiag'="" AllDiag = AllDiag_"#"_AdmitDiag
	Set:DischDiag'="" AllDiag = AllDiag_"#"_DischDiag 
	Set:OtherDiag'="" AllDiag = AllDiag_"#"_OtherDiag 
	Set:AllDiag'="" AllDiag = $e(AllDiag,2,$l(AllDiag))
	//取报告横断面调查
	Set xRepID = ""
	Set CSSID = "" 
	Set xRepID = "" //$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,"7",xRepID))
	Set IRHbsAgDr = "",IRHCVDr="",IRHIVDr=""
	if (xRepID ="")
	{
		//24小时内腹泻次数  针对的是当前日期
		Set xOBSToDate = +$h-1
		Set OBSCnt = ..GetKeyWordCntData(aEpisodeID,xOBSToDate,+$h,"MR-ObsDiarr","腹泻")
		Set:OBSCnt>0 OBSCnt=1
		if OBSCnt=1{
			Set OBSCnt = "是"
		}else {
			Set OBSCnt = "否"
		}
		//感染信息 现患的
		Set InfDias =""
		Set InfPosDescs = ""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.IRInfPosDr)
			Set InfDiagnosDr=obj.%Id()
			Set InfPosDr=obj.IRInfPosDr.%Id()
			Set InfPosDesc=obj.IRInfPosDr.BTDesc
			
			Set InfDate=obj.IRInfDate
			Continue:InfDate=""
			Set InfXDate=obj.IRInfXDate				//感染转归日期
			Set InfPosDesc=obj.IRInfPosDr.BTDesc	//感染部位
	
			
			set IRInfType = obj.IRInfType	//感染类型（0：社区感染，1：医院感染）
			if (IRInfType=0){
				set ComInfDate = obj.IRInfDate		//社区感染日期
				set ComIRBacteria = obj.IRBacteria	//社区感染病原体(以#分割)
				Set:ComInfDate'="" ComInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ComInfDate)
				Set InfSubDesc="社区感染"
			}
			if (IRInfType=1){
				set HosInfDate = obj.IRInfDate		//医院感染日期
				set HosIRBacteria = obj.IRBacteria	//医院感染病原体(以#分割)
				Set:HosInfDate'="" HosInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(HosInfDate)
				Set InfSubDesc="医院感染"
			}
			else{
				set ComInfDate = obj.IRInfDate		//社区感染日期
				set ComIRBacteria = obj.IRBacteria	//社区感染病原体(以#分割)
				Set:ComInfDate'="" ComInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ComInfDate)
				set HosInfDate = obj.IRInfDate		//医院感染日期
				set HosIRBacteria = obj.IRBacteria	//医院感染病原体(以#分割)
				Set:HosInfDate'="" HosInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(HosInfDate)
				Set InfSubDesc="社区感染,医院感染"
			}
			
			
			
			Set IsReportDiag=obj.IRIsReportDiag		//是否临床上报诊断
			//Continue:InfDate>aDateFrom  //调查时未感染开始
			Continue:(+InfXDate'=0)&(InfXDate<aDateFrom)  //感染转归日期小于调查日期即调查时已经结束
			Set:InfDias'="" InfDias = InfDias_"#"_InfDiagnosDr
			Set:InfDias="" InfDias = InfDiagnosDr	
			Set:InfPosDescs'="" InfPosDescs = InfPosDescs _"#"_InfPosDesc
			Set:InfPosDescs="" InfPosDescs =InfPosDesc 			
		}
		
		//抗菌药物 用药目的 0 预防 1 治疗 联合用药 是否送检
		Set AntiIsUser =0,AntUsePurpose ="",CombinedMed = "",AntIsSubmiss =0,xBTSCode=""
		Set OrdID="", xInd=1,xNum=0
		For{
			Set OrdID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",aEpisodeID,OrdID))
			Quit:OrdID=""
			Set objOEOrd = ##class(DHCHAI.DP.OEOrdItem).GetObjById(OrdID)
			Continue:'$IsObject(objOEOrd)
			Continue:objOEOrd.OEAntUseFlag'=1  // 过滤非抗菌用药医嘱
			Continue:objOEOrd.OEIsActive=0  //无效作废医嘱不算
			Set AntIsSubmiss=objOEOrd.OEAntIsSubmiss	//是否送检
			Set AntiIsUser=objOEOrd.OEAntUseFlag	//是否使用抗生素
			Set xItemAnit = objOEOrd.OEOrdDesc
			Set StratDate = objOEOrd.OESttDate
			Set StratTime = objOEOrd.OESttTime
			Set EndDate = objOEOrd.OEXDate
			Set EndTime = objOEOrd.OEXTime
			Set AntUsePurpose=objOEOrd.OEAntUsePurpose
			Set:AntUsePurpose'="" AntUsePurpose=$p(AntUsePurpose,"-",1)
			Set:AntUsePurpose'="" AntUsePurpose=$s(AntUsePurpose="治疗":"治疗用药",AntUsePurpose="预防":"预防用药",1:"其他用药") //联用情况
			Set ^TMP("CROEOrdDesc",xInd)=xItemAnit_"^"_StratDate_"^"_StratTime_"^"_EndDate_"^"_EndTime
			Set xInd = xInd+1
		}
		set max=1
			set TolCount = xInd-1
			set xInd=1
			if (TolCount=1){
				set xNum=1
			}else{
				for i=1:1:TolCount{
					for j=i:1:TolCount-i{
						set xItemAnit=$p(^TMP("CROEOrdDesc",j),"^",1)
						set StratDate=$p(^TMP("CROEOrdDesc",i),"^",2)
						set StratTime=$p(^TMP("CROEOrdDesc",i),"^",3)
						set EndDate=$p(^TMP("CROEOrdDesc",i),"^",4)
						set EndTime=$p(^TMP("CROEOrdDesc",i),"^",5)
						set tmpxItemAnit=$p(^TMP("CROEOrdDesc",j+1),"^",1)
						set tmpStratDate=$p(^TMP("CROEOrdDesc",j+1),"^",2)
						set tmpStratTime=$p(^TMP("CROEOrdDesc",j+1),"^",3)
						set tmpEndDate=$p(^TMP("CROEOrdDesc",j+1),"^",4)
						set tmpEndTime=$p(^TMP("CROEOrdDesc",j+1),"^",5)
						if (EndDate=""){
							set EndDate	= +$h
							set EndTime =$p($h,",",2)
						}
						if (tmpEndDate=""){
							set tmpEndDate	= +$h
							set tmpEndTime = $p($h,",",2)
						}
						set xBTSCode="HIS01"
						Set aID=""
						For {
							Set aID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,xItemAnit,aID))
							Quit:aID=""
		 					Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjById(aID)
							Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
							If $IsObject(objMap.BTMapItemDr) {
							Set BTMapItemDr=objMap.BTMapItemDr.%Id()
							Set BTMapItemCode=objMap.BTMapItemDr.BTCode
							Set BTMapItemDesc=objMap.BTMapItemDr.BTName
							}
						}
						For {
							Set aID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,tmpxItemAnit,aID))
							Quit:aID=""
		 					Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjById(aID)
							Set tmpBTMapItemDr="",tmpBTMapItemCode="",tmpBTMapItemDesc=""
						If $IsObject(objMap.BTMapItemDr) {
							Set tmpBTMapItemDr=objMap.BTMapItemDr.%Id()
							Set tmpBTMapItemCode=objMap.BTMapItemDr.BTCode
							Set tmpBTMapItemDesc=objMap.BTMapItemDr.BTName
						}
					}
					if ((EndDate=tmpStratDate)&&(EndTime>tmpStratTime)&&(BTMapItemDesc'=tmpBTMapItemDesc)){
						set max = max+1
					}
					if ((EndDate>tmpStratDate)&&(BTMapItemDesc'=tmpBTMapItemDesc)){
						set max = max+1
					}
					if (xNum<max){
						set xNum = max
					}
							
				}
						
			}
		}
		Kill ^TMP("CROEOrdDesc")
		Set CombinedMed  = $s(xNum=1:"一联",xNum=2:"二联",xNum=3:"三联",xNum=4:"四联",xNum>4:"四联以上",1:"") //联用情况
		if AntiIsUser =1{	//是否使用抗生素
			Set AntiIsUser = "是"
		}else{
			Set AntiIsUser = "否"
			Set CombinedMed=""
		}
		if AntIsSubmiss =1{
			Set AntIsSubmiss = "是"
		}else{
			Set AntIsSubmiss = "否"
		}
		
		//手术 切口类型
		Set OperFlag = 0 ,CuteTypeID = "" ,CuteType = ""
		Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""		
			
			Set OperFlag =OperFlag+1
			Set OperAnaData = ##class(DHCHAI.DPS.OROperAnaesSrv).BuildOperData(xID,"")

			set OperDesc    = $lg(OperAnaData,4)   //手术名称
			Set CuteTypeID 	= $lg(OperAnaData,18)  //切口类型
			Set CuteType 	= $lg(OperAnaData,19)
		}
		Set OperFlagDesc = "否"   //是否手术描述
		Set:OperFlag>0 OperFlagDesc = "是"   //是否手术描述		
	//取血管，呼吸机，导尿管是否插管
	
		Set IsPICC ="",IsUC="",IsVAP =""
		Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.IR.ICULogDtlI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""		
			Set objICU = ##class(DHCHAI.IR.ICULogDtl).GetObjById(xID)
			Quit:'$IsObject(objICU)
			set IsPICC  = objICU.ILIsPICC
			Set IsUC 	= objICU.ILIsUC
			Set IsVAP 	= objICU.ILIsVAP
			Set IsPICC 	= $s(IsPICC=1:"是",IsPICC=0:"否") 
			Set IsUC 	= $s(IsUC=1:"是",IsUC=0:"否") 
			Set IsVAP 	= $s(IsVAP=1:"是",IsVAP=0:"否") 
		}
		
	//取患者疑似标识
	Set ScAttDr = $o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,""),-1)
	Set objAtt =##class(DHCHAI.IR.CCScreenAtt).GetObjById(ScAttDr)
	Set FlagAtt = 0	
	If ($Isobject(objAtt))
	{
		Set:(objAtt.CSIsSusInf=1) FlagAtt = 1
	}
	
	//取患者疑似待处理标志
	Set IsSuspend = objAtt.CSIsSuspend
	Set zy = ""
	Set ygbg = ""
	Set lcgy = ""
	Set yscl = ""
	Set:(FlagAtt=1)&&(IsSuspend=0) yscl ="疑似待处理"
	Set:(FlagAtt=1)&&(IsSuspend=1) yscl ="疑似已处理"
	//,HomeAddress,Company,RelativeName,RelativeTel,IsDeath,DeathDate,DeathTime,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc,IsNewBaby,BirthWeight,AdmitWeight,AdmTimes,AdmDays,MainDiag,AdmitDiag,OtherDiag,DischDiag
	Set return = $lb(xRepID,SurvNumber,aEpisodeID,EpisodeIDx,PatientIDx,PapmiNo,MrNo,PatName,Sex,Age,IdentityCode,AdmTimes,AllDiag,OBSCnt,InfDias,AntiIsUser,AntUsePurpose,CombinedMed,AntIsSubmiss,OperFlag,CuteTypeID,CuteType,BacDescs,OperFlagDesc,InfPosDescs,BacIDs)
	Set return =return_$lb(IRHbsAgDr,IRHCVDr,IRHIVDr,IsPICC,IsUC,IsVAP,IsJMSY,InfCategory,CSSID,IsNewBaby,FlagAtt,zy,ygbg,lcgy,yscl,AdmitDate,DischDate,IsSuspend,InfSubDesc,HosInfDate,HosIRBacteria,ComInfDate,ComIRBacteria,OperDesc,AdmLocDesc)
	Quit return
	}
}

}
