/// 名称: web.DHCCPW.MR.ClinPathWaysStatNew
/// 描述: 临床路径统计（在院统计+出院统计）
/// 编写者：zhufei
/// 编写日期: 2012-12-16
Class web.DHCCPW.MR.ClinPathWaysStatNew Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildData(aPaadm As %String) As %List
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Set (CPWLoc,CPWDesc)=""
	Set (IsInPathWay,IsOutPathWay,IsClosePathWay,IsVariance)=0
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aPaadm)
	Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
	If PathWayID'="" {
		Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		If $IsObject(objPathWay){
			//路径科室、路径名称
			Set CPWLoc=objPathWay.CPWInLoc
			Set:CPWLoc'="" CPWLoc=$p($g(^CTLOC(CPWLoc)),"^",2)
			If $IsObject(objPathWay.CPWPathwayDR){
				Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
			}
			//是否入径、是否出径、是否完成
			Set CPWStatus=objPathWay.CPWStatus
			Set IsInPathWay=1
			Set:CPWStatus="O" IsOutPathWay=1
			Set:CPWStatus="C" IsClosePathWay=1
			
			If $IsObject(objPathWay.CPWPathwayDR){
				Set PathwayDR=objPathWay.CPWPathwayDR.%Id()
				Set PathWayDesc=objPathWay.CPWPathwayDR.CPWDesc
				Set RefCost=objPathWay.CPWPathwayDR.CPWCost
				Set RefDays=objPathWay.CPWPathwayDR.CPWDays
			}
			If $IsObject(objPathWay.CPWPathwayEpStepDR){
				Set EpStepDR=objPathWay.CPWPathwayEpStepDR.%Id()
				Set EPStepDesc=objPathWay.CPWPathwayEpStepDR.CPWSDesc
				Set PathWayEpDR=$p(EpStepDR,"||",1)_"||"_$p(EpStepDR,"||",2)
				Set objPathWayEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(PathWayEpDR)
				If $IsObject(objPathWayEp){
					Set PathWayEpDesc=objPathWayEp.EPDesc
				}
			}
			Set Status=objPathWay.CPWStatus
			Set StatusDesc=$s(Status="I":"在径",Status="O":"出径",Status="C":"完成",1:"ERROR")
			Set InDoctorDR=objPathWay.CPWInDoctorDR
			Set:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
			Set InDate=objPathWay.CPWInDate
			Set InTime=objPathWay.CPWInTime
			Set:InDate'="" InDate=$zd(+InDate,3)
			Set:InTime'="" InTime=$zt(+InTime,2)
			Set OutDoctorDR=objPathWay.CPWOutDoctorDR
			Set:OutDoctorDR'="" OutDoctorDesc=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
			Set OutDate=objPathWay.CPWOutDate
			Set OutTime=objPathWay.CPWOutTime
			Set:OutDate'="" OutDate=$zd(+OutDate,3)
			Set:OutTime'="" OutTime=$zt(+OutTime,2)
			If $IsObject(objPathWay.CPWOutReasonDR){
				Set OutReasonDR=objPathWay.CPWOutReasonDR.%Id()
				Set OutReasonDesc=objPathWay.CPWOutReasonDR.VRDesc
			}
			Set Comments=objPathWay.CPWComments
			//变异原因、是否变异
			Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(PathWayID)
			If VarInfo'="" {
				Set VarCount=$list(VarInfo,1)
				Set VarReason=$list(VarInfo,2)
			}Else{
				Set VarCount=0
				Set VarReason=""
			}
			Set:VarCount>0 IsVariance=1
		}
	}
	
	//路径科室为空，取就诊科室
	If CPWLoc="" {
		Set AdmInfo=$g(^PAADM(aPaadm))
		Set CPWLoc=$p(AdmInfo,"^",4)
		Set:CPWLoc'="" CPWLoc=$p($g(^CTLOC(CPWLoc)),"^",2)
	}
	Set:$l($p(CPWLoc,"-",2))>1 CPWLoc=$p(CPWLoc,"-",2)
	Set:CPWLoc="" CPWLoc="其它"
	
	//未入径患者，判断是否符合路径
	If CPWDesc="" {
		Set CPWDesc=""
		Set CPWInfo=..CheckDiagnos(aPaadm)
		If CPWInfo'="" {
			Set CPWDesc=$list(CPWInfo,1)
			Set Diagnos=$list(CPWInfo,2)
		}
	}
	Set:CPWDesc="" CPWDesc="其它"
	
	Set CPWLocInd=$s(CPWLoc="其它":"1"_CPWLoc,1:"0"_CPWLoc)
	Set CPWDescInd=$s(CPWDesc="其它":"1"_CPWDesc,1:"0"_CPWDesc)
	
	Set return=$lb(aPaadm)                  //就诊号
	Set return=return_$lb(CPWLocInd)        //科室排序
	Set return=return_$lb(CPWLoc)           //科室名称
	Set return=return_$lb(CPWDescInd)       //病种排序
	Set return=return_$lb(CPWDesc)          //病种名称
	Set return=return_$lb(IsInPathWay)      //是否入径
	Set return=return_$lb(IsOutPathWay)     //是否出径
	Set return=return_$lb(IsClosePathWay)   //是否完成
	Set return=return_$lb(IsVariance)       //是否变异
	
	Set return=return_$lb($g(PathWayID))
	Set return=return_$lb($g(StatusDesc))
	Set return=return_$lb($g(InDoctorDesc))
	Set return=return_$lb($g(InDate))
	Set return=return_$lb($g(InTime))
	Set return=return_$lb($g(OutDoctorDesc))
	Set return=return_$lb($g(OutDate))
	Set return=return_$lb($g(OutTime))
	Set return=return_$lb($g(OutReasonDesc))
	Set return=return_$lb($g(VarReason))
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(aPaadm)
    If $IsObject(objPaadm){
	    If $IsObject(objPaadm.PAADMPAPMIDR){
		    Set objPatient=objPaadm.PAADMPAPMIDR
		    Set PatientID=objPatient.%Id()
		    //Set PapmiNo=objPatient.PAPMINo
		    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		    Set PatName=objPatient.PAPMIName
		    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
		    Set Birthday=objPatient.PAPMIDOB
		    Set:Birthday'="" Birthda=$zd(Birthday,3)
			
		    //update by zf 20150228 统一调用年龄计算方法
		    Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,aPaadm,"","")	//返回“*岁*月*天”

		    Set PersonalID=objPatient.PAPMIID
		}
		
	    //Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(aPaadm)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DisDate=objPaadm.PAADMDischgDate
	    //Set DisTime=objPaadm.PAADMDischgTime
	    //Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(aPaadm)
		Set DisDate=$p(DischDateTime,"^",1)
		Set DisTime=$p(DischDateTime,"^",2)
	    If DisDate'="" {
		    Set AdmDays=DisDate-AdmitDate
	    } Else {
			Set AdmDays=+$h-AdmitDate
		}
	    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	    Set:DisDate'="" DisDate=$zd(DisDate,3)
	    Set:DisTime'="" DisTime=$zt(DisTime,1)
	    If $IsObject(objPaadm.PAADMDepCodeDR)
	    {
		    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
		    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
	    If $IsObject(objPaadm.PAADMCurrentWardDR)
	    {
		    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
		    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		}
		If $IsObject(objPaadm.PAADMCurrentRoomDR)
		{
			Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
		}
		If $IsObject(objPaadm.PAADMCurrentBedDR)
		{
			Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
		}
		If $IsObject(objPaadm.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
		}
		Set AdmStatus=objPaadm.PAADMVisitStatus
	}
	
	Set InMedicare=##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID(aPaadm)
	
	//If AdmStatus'="A" {
	//	Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(aPaadm)
	//} Else {
	//	Set strCost=""
	//}
	//Set CountCost=+$p(strCost,"^",1)  //住院总费用
	//Set DrugCost=+$p(strCost,"^",2)   //住院总药费
	
    Set return=return_$lb($g(PatientID))
    Set return=return_$lb($g(PapmiNo))
    Set return=return_$lb($g(InMedicare))
    Set return=return_$lb($g(PatName))
    Set return=return_$lb($g(Sex))
    Set return=return_$lb($g(Birthday))
    Set return=return_$lb($g(Age))
    Set return=return_$lb($g(PersonalID))
	Set return=return_$lb($g(AdmitDate))
	Set return=return_$lb($g(AdmitTime))
	Set return=return_$lb($g(DisDate))
	Set return=return_$lb($g(DisTime))
	Set return=return_$lb($g(AdmLoc))
	Set return=return_$lb($g(AdmWard))
	Set return=return_$lb($g(AdmRoom))
	Set return=return_$lb($g(AdmBed))
	Set return=return_$lb($g(AdmDoc))
	Set return=return_$lb($g(AdmDays))
    Set return=return_$lb($g(CountCost))
	Set return=return_$lb($g(DrugCost))
	
	Quit return
}

/// 病种/路径、诊断ICD+诊断描述
/// 根据类型判断入院诊断是否符合临床路径准入标准ICD
ClassMethod CheckDiagnos(aPaadm As %String) As %List
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(aPaadm)
	Quit:MRAdm="" return
	
	Set LocationDR=$p($g(^PAADM(aPaadm)),"^",4)
	
	//通过诊断来判断是否临床路径患者
	Set CPWDID="",CPWDDesc="",MRICD10="",MRICDDesc=""
	Set GetCPWICDType=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("GetCPWICDType")
	If GetCPWICDType=1 {
		//通过临床诊断的第一主要诊断来判断
		Set MRDiagnos=0
		For {
			Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
			Quit:MRDiagnos=""
			Quit:MRICDDesc'=""  //取到符合标准的数据就退出（只取第一个符合的诊断）
			
			Set TypeDicCode=""
			Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
			If MRDiagType'="" {
				Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
				Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
			}
			Continue:TypeDicCode'="M" //Main(M)为主要诊断类型
			
			Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
			Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
			Set ICD10=$p(tmpICD,"^",4)
			Set ICDDesc=$p(tmpICD,"^",3)
			Continue:ICDDesc=""
			Set MRICD10=ICD10
			Set MRICDDesc=ICDDesc
		}
	}Else{
		//无主要诊断 通过临床诊断的第一诊断来判断
		Set MRDiagnos=0
		For {
			Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
			Quit:MRDiagnos=""
			Quit:MRICDDesc'=""  //取到符合标准的数据就退出（只取第一个符合的诊断）
			
			Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
			Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
			Set ICD10=$p(tmpICD,"^",4)
			Set ICDDesc=$p(tmpICD,"^",3)
			Continue:ICDDesc=""
			Set MRICD10=ICD10
			Set MRICDDesc=ICDDesc
		}
	}
	Set MRICDInfo=MRICD10_" "_MRICDDesc
	
	//判断此诊断符合哪条路径的准入标准,根据准入ICD来判断
	If MRICD10'="" {
		Set CPWID=0
		For {
			;Set CPWID=$o(^DHCMRC("CPWD",CPWID)) 
			Set CPWID=$o(^DHCMRC("CPW",CPWID))
			Quit:CPWID=""
			Quit:CPWDID'=""  //找到符合的病种
			
			Set (CPWDesc,CPWICD,CurrCPWDID,CurrVersion)=""
			Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			If $IsObject(objCPW) {
				Set CPWDesc=objCPW.CPWDesc
				Set CPWICD=objCPW.CPWICD
				Set CPWKeys=objCPW.CPWKeys
				Set CPWOperICD=objCPW.CPWOperICD
				Set CPWOperKeys=objCPW.CPWOperKeys
				If $IsObject(objCPW.CPWCPWDicDR) {
					Set CurrCPWDID=objCPW.CPWCPWDicDR.%Id()
					Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
				}
			}
			Continue:CurrVersion'=CPWID
			Continue:CPWICD=""
			Continue:'$d(^DHCMRCi("DEPCPW",0,"IndexCPW",CurrCPWDID," "_LocationDR))
			
			Set flg1=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(MRICD10,CPWICD)
			Continue:flg1<=0
			If (CPWKeys'="")&&(MRICDDesc'="")
			{
				Set flg2=##Class(web.DHCCPW.MR.SysBaseSrv).CheckKeysArea(MRICDDesc,CPWKeys)
				Continue:flg2<=0
			}
			Set CPWDID=CurrCPWDID
			Set CPWDDesc=CPWDesc
		}
	}
	
	Set return=$lb(CPWDDesc,MRICDInfo)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-12-16
/// Description:  临床路径在院统计
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStatNew","QryInHospStat")
Query QryInHospStat() As %Query(ROWSPEC = "Paadm:%String,CPWLocInd:%String,CPWLoc:%String,CPWDescInd:%String,CPWDesc:%String,IsInPathWay:%String,IsOutPathWay:%String,IsClosePathWay:%String,IsVariance:%String,PathWayID:%String,StatusDesc:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDesc:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,CountCost:%String,DrugCost:%String") [ SqlProc ]
{
}

ClassMethod QryInHospStatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set xWardID=0,Count=0
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))  //通过病区、病房查找在院病人人数
		Quit:xWardID=""
		Set xRoomID=0
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				//Set Count=Count+1
				//Quit:Count>30
				//w "Count="_Count_",Paadm="_xPaadm,!
				
				Set Data=..BuildData(xPaadm)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryInHospStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInHospStatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInHospStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInHospStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-12-16
/// Description:  临床路径出院统计(出院日期查询)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStatNew","QryDischStat","2012-12-01","2012-12-03")
Query QryDischStat(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Paadm:%String,CPWLocInd:%String,CPWLoc:%String,CPWDescInd:%String,CPWDesc:%String,IsInPathWay:%String,IsOutPathWay:%String,IsClosePathWay:%String,IsVariance:%String,PathWayID:%String,StatusDesc:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDesc:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,CountCost:%String,DrugCost:%String") [ SqlProc ]
{
}

ClassMethod QryDischStatExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDischDate=aDateFrom:1:aDateTo {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDischDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
			Continue:$p(AdmInfo,"^",20)'="D" //就诊状态过滤
			
			Set Data=..BuildData(xPaadm)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDischStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDischStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-12-16
/// Description:  临床路径出院统计(入院日期查询)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStatNew","QryDischAdmStat","2012-12-01","2012-12-03")
Query QryDischAdmStat(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Paadm:%String,CPWLocInd:%String,CPWLoc:%String,CPWDescInd:%String,CPWDesc:%String,IsInPathWay:%String,IsOutPathWay:%String,IsClosePathWay:%String,IsVariance:%String,PathWayID:%String,StatusDesc:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDesc:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,CountCost:%String,DrugCost:%String") [ SqlProc ]
{
}

ClassMethod QryDischAdmStatExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	Set AdmDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex() //update by pylian 2016-02-18 取入院时间索引
	For xAdmDate=aDateFrom:1:aDateTo {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(AdmDateIndex,xAdmDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
			Continue:$p(AdmInfo,"^",20)'="D" //就诊状态过滤
			
			Set Data=..BuildData(xPaadm)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryDischAdmStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischAdmStatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDischAdmStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischAdmStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	} Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
