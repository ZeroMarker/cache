/// 名称: DHCMA.IMP.IPS.IMPRecordSrv
/// 描述: 重点患者筛查服务
/// 编写者：zhangdc
/// 编写日期: 2020-05-26
Class DHCMA.IMP.IPS.IMPRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-05-26
/// Description:  查询筛查的重点病人
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aAdmStatus：就诊状态（在院A、出院D）
///               aCategory：重点患者分类
///               aHospIDs：医院IDs
///               aLocID：科室ID
///               aWardID：病区ID
///               aDateFrom：开始日期
///               aDateTo：结束日期
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryRecordList","2,3","2020-06-10","2020-09-08","","","")
Query QryRecordList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCategory As %String, aLocID As %String = "", aWard As %String = "") As %Query(ROWSPEC = "RecordID:%String,CateFlag:%String,CateDesc:%String,LinkedEpisodeID:%String,LinkedSurInfo:%String,StatusDesc:%String,EpisodeID:%String,Opinion:%String,PatientID:%String,RegNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmType:%String,AdmitDate:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,Room:%String,Bed:%String,DoctorID:%String,DoctorName:%String,DischDate:%String,DischTime:%String,KeywordScr:%String,VisitStatus:%String")
{
}

ClassMethod QryRecordListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aCategory As %String, aLocID As %String = "", aWard As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	For xDate = aDateFrom:1:aDateTo{
		Set xCateDr = ""
		For {
			Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
			Quit:xCateDr=""
			Set xID=""
			For{
				Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
				Quit:xID=""
				
				Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
				Continue:'$IsObject(objRecord)
				Set EpisodeID = objRecord.EpisodeID
				Continue:EpisodeID=""
				Set CategoryDesc = objRecord.IMPCateDr.BTDesc
				Continue:(aCategory'="")&&(aCategory'=CategoryDesc)
				Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",2)
				//Continue:(aAdmStatus'="")&&((","_aAdmStatus_",")'[(","_VisitStatus_","))
				Set VisitStatus= $s(VisitStatus="O":"门诊",VisitStatus="I":"住院",1:"")
				//过滤科室、病区、医院
				Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
				Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
				//统一病区筛查维度
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:'$IsObject(objAdm)
				//Continue:objAdm.AdmType'="I"
				Set PatientID=objAdm.PatientID
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(objPatient)
				Set AdmWard=objAdm.Ward
				Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
				Continue:(aWard'="")&&(aWard'=AdmWard)	//aWard是传入的科室
				If (aHospIDs'=""){
			 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospIDs)
			 		Continue:flg<1
		 		}
		 		Set Data=..BuildRecordData(objRecord)
		 		Continue:Data=""
		 		Set ^CacheTemp(repid,ind)=Data_$lb(VisitStatus)
		 		Set ind=ind+1
			}
		}
	}
 	
	Quit $$$OK
}

ClassMethod QryRecordListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRecordListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：	  zhangdc
/// CreatDate：   2020-05-26
/// Description:  构建重点患者筛查数据
ClassMethod BuildRecordData(objRecord As %String) As %List
{
	New (objRecord)
	Set return=""
	Quit:'$IsObject(objRecord) return
	
	Set $ZT="BuildDataErr"
	
	Set RecordID=objRecord.%Id()
	Set CateFlag="",CateDesc=""
	If $IsObject(objRecord.IMPCateDr){
		Set CateFlag=objRecord.IMPCateDr.BTCateFlag
		Set CateDesc=objRecord.IMPCateDr.BTDesc
	}
	Set EpisodeID=objRecord.EpisodeID
	Set LinkedEpisodeID=objRecord.LnkEpisInfo
	Set LinkedSurInfo=objRecord.LnkOperInfo
	Set Status=objRecord.StatusDr
	//Set:'$IsObject(Status) StatusDesc="手动标记"
	//Set StatusDesc=Status.BTDesc
	if ($IsObject(Status)){
		Set StatusDesc=Status.BTDesc
	}else{
		Set StatusDesc="手动标记"
	}
	if (CateFlag'="")&&(StatusDesc="排除"){
		Set CateFlag=$P(CateFlag,".",1)_"_N.png"	//图标定义
	}
	//Set Remarks=objRecord.Remarks
	Set Opinion=objRecord.Opinion
	Set KeywordScr=objRecord.IMPKeywords
	
	Set (PatientID,RegNo,PatientName,Sex,PatientAge,AdmitDate,Room,Bed,AdmType,LocDesc,WardDesc)=""
	Set (LocID,WardID,DoctorID,DoctorName)=""
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objAdm) return
	Quit:objAdm.AdmType'="I" return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	
	//统一调用年龄计算方法
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set DischDateTime= ##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
		
	Set AdmLoc=objAdm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	
	Set Data=$lb("")
	Set $li(Data,1)  = RecordID
	Set $li(Data,2)  = CateFlag
	Set $li(Data,3)  = CateDesc
	Set $li(Data,4)  = LinkedEpisodeID
	Set $li(Data,5)  = LinkedSurInfo
	//Set $li(Data,6)  = LinkedRegInfo
	Set $li(Data,6)  = StatusDesc
	Set $li(Data,7)  = EpisodeID
	//Set $li(Data,9)  = Remarks
	Set $li(Data,8) = Opinion
	Set $li(Data,9) = PatientID
	Set $li(Data,10) = objPatient.PapmiNo
	Set $li(Data,11) = objPatient.PatientName
	Set $li(Data,12) = objPatient.Sex
	Set $li(Data,13) = PatientAge
	Set $li(Data,14) = objAdm.AdmType
	Set $li(Data,15) = AdmDate
	Set $li(Data,16) = objAdm.DepartmentID
	Set $li(Data,17) = AdmLoc
	Set $li(Data,18) = objAdm.WardID
	Set $li(Data,19) = AdmWard
	Set $li(Data,20) = objAdm.Room
	Set $li(Data,21) = objAdm.Bed
	Set $li(Data,22) = objAdm.DoctorID
	Set $li(Data,23) = objAdm.DoctorName
	Set $li(Data,24) = DischDate
	Set $li(Data,25) = DischTime
	Set $li(Data,26) = KeywordScr
	Quit Data
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-27
/// Description:  标记排除更新
/// Table：       DHCMA.IMP.IP.IMPRecord   
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).UpdateStatus("!8^1^^334^9","^")
ClassMethod UpdateStatus(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set length=$l(aInputStr,"!")
	Set ^TEMPZDC20201020=aInputStr
	Set Count=0,Num=0
	For index=1:1:length {
		Set InputStrNew=$P(aInputStr,"!",index)
		Set ID          =  	$p(InputStrNew,aSeparete,1)
		Set Status      =   $p(InputStrNew,aSeparete,2)
		Set Opinion	    =   $p(InputStrNew,aSeparete,3)
		Set EvalLoc	    = 	$p(InputStrNew,aSeparete,4)
		Set EvalUser    = 	$p(InputStrNew,aSeparete,5)
		Set EvalDate    =   +$h
		Set EvalTime    =   $p($h,",",2)
		Continue:(ID="")||(Status="")
	
		If Status=1 {								// Status=1是确诊状态
			Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
			Continue:'$IsObject(objRecord)
			
			Set objRecord.StatusDr     	= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("IMPStatus","Diagnosis")
			//Set objRecord.Remarks    	= Opinion
			Set objRecord.OccuLocID     = EvalLoc
			Set objRecord.ActUserID 	= EvalUser
			Set objRecord.ActDate 		= EvalDate
			Set objRecord.ActTime 		= EvalTime
			
			if (objRecord.IMPReasonDr'=""){
				Set objRecord.IMPReasonDr 		= ""
			}
			
			Set sc=objRecord.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
   				Do $system.OBJ.DisplayError(sc) 
   				Set flg=-1
			}Else{
				Set flg=objRecord.%Id()
			}
			Do objRecord.%Close()
			
			Set:(+flg<0) Count=Count+1		//失败条数
			Set:(+flg>0) Num=Num+1			//成功条数
		}Elseif(Status=0){									// Status=0是排除状态
			Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
			Continue:'$IsObject(objRecord)
			Set objRecord.StatusDr     	= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("IMPStatus","Exclude")
			Set objRecord.Opinion    	= Opinion
			Set objRecord.OccuLocID     = EvalLoc
			Set objRecord.ActUserID 	= EvalUser
			Set objRecord.ActDate 		= EvalDate
			Set objRecord.ActTime 		= EvalTime
			
			Set sc=objRecord.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
   				Do $system.OBJ.DisplayError(sc) 
   				Set flg=-1
			}Else{
				Set flg=objRecord.%Id()
			}
			Do objRecord.%Close()
			
			Set:(+flg<0) Count=Count+1		//失败条数
			Set:(+flg>0) Num=Num+1			//成功条数
		}Elseif(Status=2){									// Status=2是审核状态
			Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
			Continue:'$IsObject(objRecord)
			Set objRecord.StatusDr     	= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("IMPRegStatus","Check")
			Set objRecord.Opinion    	= Opinion
			Set objRecord.OccuLocID     = EvalLoc
			Set objRecord.ActUserID 	= EvalUser
			Set objRecord.ActDate 		= EvalDate
			Set objRecord.ActTime 		= EvalTime
			
			Set sc=objRecord.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
   				Do $system.OBJ.DisplayError(sc) 
   				Set flg=-1
			}Else{
				Set flg=objRecord.%Id()
			}
			Do objRecord.%Close()
			
			Set:(+flg<0) Count=Count+1		//失败条数
			Set:(+flg>0) Num=Num+1			//成功条数
		}Elseif(Status=3){									// Status=3是终结状态
			Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
			Continue:'$IsObject(objRecord)
			
			Set objRecord.StatusDr     	= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("IMPStatus","End")
			//Set objRecord.Remarks    	= Opinion
			Set objRecord.OccuLocID     = EvalLoc
			Set objRecord.ActUserID 	= EvalUser
			Set objRecord.ActDate 		= EvalDate
			Set objRecord.ActTime 		= EvalTime
			
			Set sc=objRecord.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
   				Do $system.OBJ.DisplayError(sc) 
   				Set flg=-1
			}Else{
				Set flg=objRecord.%Id()
			}
			Do objRecord.%Close()
			
			Set:(+flg<0) Count=Count+1		//失败条数
			Set:(+flg>0) Num=Num+1			//成功条数
		}
		
	}
	Set return=Num_"/"_Count
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-18
/// Description:  根据就诊id取基本信息
/// Table：            
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).getEssentialInfo(5)
ClassMethod getEssentialInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set AdmInfo=$g(^PAADM(aEpisodeID))
	Set MRAdm=$p(AdmInfo,"^",61)				//MR_Adm
	
	Set childSub=0
	Set diagDesc=""
	For{
		Set childSub=$o(^MR(MRAdm,"DIA",childSub))
		Quit:childSub=""
		
		Set MRDiagnosInfo=$g(^MR(MRAdm,"DIA",childSub))
		Set MRCICDDx=$p(MRDiagnosInfo,"^",1)				//MRC_ICDDx
		continue:MRCICDDx=""
		Set MRCICDDxInfo=$g(^MRC("ID",MRCICDDx))
		Set MRCICDDxDesc=$p(MRCICDDxInfo,"^",2)
		//Set:MRCICDDxDesc'="" diagDesc=diagDesc_";"_MRCICDDxDesc
		if (diagDesc=""){
			Set diagDesc=MRCICDDxDesc
		}else{
			Set diagDesc=diagDesc_";"_MRCICDDxDesc
		}
	}
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objAdm) return
	Quit:objAdm.AdmType'="I" return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	
	//统一调用年龄计算方法
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set DischDateTime= ##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
		
	Set AdmLoc=objAdm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	
	Set return=objPatient.PapmiNo_"^"_objPatient.PatientName_"^"_objPatient.Sex_"^"_PatientAge_"^"_AdmLoc_"^"_objAdm.Room_"^"_objAdm.Bed_"^"_diagDesc
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-19
/// Description:  根据就诊id查询手术信息
/// Table：       DHC_AN_OPArrange、OR_Anaesthesia、OR_Anaest_Operation、OEC_BodySite
/// Input:        aEpisodeID
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryOperationInfo",392)
Query QryOperationInfo(aEpisodeID As %String) As %Query(ROWSPEC = "OperStatus:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,BladeDesc:%String,BODSDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOperationInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:aEpisodeID="" $$$OK

	Set OperArr=0
	For {
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,OperArr))			//手术排班表 DHC_AN_OPArrange
		Quit:OperArr=""
		
		//手术状态
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)				//手术状态
		Set OperStatus = $S(OperStatus="A":"申请",OperStatus="D":"拒绝",OperStatus="R":"安排",OperStatus="I":"术中",OperStatus="L":"术毕",OperStatus="F":"完成",OperStatus="N":"非预约",OperStatus="P":"恢复",OperStatus="C":"撤销")
		Set StartDate = $p($g(^DHCANOPArrange(OperArr)),"^",14)
		Set:StartDate'="" StartDate=$zd(StartDate,3)
		Set StartTime = $p($g(^DHCANOPArrange(OperArr)),"^",15)
		Set:StartTime'="" StartTime=$zt(StartTime,1)
		Set EndDate = $p($g(^DHCANOPArrange(OperArr)),"^",16)
		Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set EndTime = $p($g(^DHCANOPArrange(OperArr)),"^",17)
		Set:EndTime'="" EndTime=$zt(EndTime,1)
		Set AnaestDr=$p($g(^DHCANOPArrange(OperArr)),"^",2)				//麻醉表OR_Anaesthesia
		continue:AnaestDr=""
		
		Set AnaestDrChild=$p(AnaestDr,"||",2)
		Set ANAOPChild = $o(^OR(aEpisodeID,"ANA",AnaestDrChild,"OP",0))	//手术表OR_Anaest_Operation
		continue:ANAOPChild=""
		
		Set Blade=$p($g(^OR(aEpisodeID,"ANA",AnaestDrChild,"OP",ANAOPChild)),"^",9)				//手术切口
		Set:Blade'="" BladeDesc = $p($g(^ORC("BLDTP",Blade)),"^",2)
		Set BodySiteDR=$p($g(^OR(aEpisodeID,"ANA",AnaestDrChild,"OP",ANAOPChild)),"^",24)				//手术部位
		Set:BodySiteDR'="" BODSDesc=$p($g(^OEC("BODS",BodySiteDR)),"^",2)
		
		Set Data=$lb(OperStatus,StartDate,StartTime,EndDate,EndTime,BladeDesc,BODSDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryOperationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperationInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOperationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperationInfoExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-06-19
/// Description:  根据就诊id查询就诊信息
/// Table：       PA_Adm
/// Input:        aEpisodeID
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryVisitInfo",5,"手术并发症")
Query QryVisitInfo(aEpisodeID As %String, CateDesc As %String, aIMPOrdNo As %String) As %Query(ROWSPEC = "Type:%String,AdmLoc:%String,AdmWard:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,diagDesc:%String") [ SqlProc ]
{
}

ClassMethod QryVisitInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, CateDesc As %String, aIMPOrdNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:(aEpisodeID="")||(CateDesc="")||(aIMPOrdNo="") $$$OK
	
	Set Category = ##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc(CateDesc)
	Quit:'$IsObject(Category) $$$OK
	
	Set Category=Category.%Id()
	Set ID=""
	Set ID=$o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),Category,aIMPOrdNo,ID))
	Quit:ID="" $$$OK
	
	Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(ID)
	Set LinkedEpisodeID =objRecord.LnkEpisInfo
	Set Date=$lb(aEpisodeID,LinkedEpisodeID)
	
	For indBar=1:1:2{
		Set Id=$LI(Date,indBar)
		Quit:Id=""
		Set AdmInfo=$g(^PAADM(Id))
		Set Type=$p(AdmInfo,"^",2)
		Set:Type'="" Type = $S(Type="I":"住院",Type="O":"门诊",Type="E":"急诊",Type="H":"体检")
		Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Id)
		Set AdmLoc=objAdm.Department
		Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		Set AdmWard=objAdm.Ward
		Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
		Set AdmitDate=$p(AdmInfo,"^",6)
		Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
		Set AdmitTime=$p(AdmInfo,"^",7)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
		Set DisDate=$p(AdmInfo,"^",17)
		Set:DisDate'="" DisDate=$zd(DisDate,3)
		Set DisTime=$p(AdmInfo,"^",18)
		Set:DisTime'="" DisTime=$zt(DisTime,1)
		Set MRAdm=$p(AdmInfo,"^",61)				//MR_Adm
		
		Set childSub=0
		Set diagDesc=""
		For{
			Quit:MRAdm=""
			Set childSub=$o(^MR(MRAdm,"DIA",childSub))
			Quit:childSub=""
		
			Set MRDiagnosInfo=$g(^MR(MRAdm,"DIA",childSub))
			Set MRCICDDx=$p(MRDiagnosInfo,"^",1)				//MRC_ICDDx
			continue:MRCICDDx=""
			Set MRCICDDxInfo=$g(^MRC("ID",MRCICDDx))
			Set MRCICDDxDesc=$p(MRCICDDxInfo,"^",2)
			//Set:MRCICDDxDesc'="" diagDesc=diagDesc_";"_MRCICDDxDesc
			if (diagDesc=""){
				Set diagDesc=MRCICDDxDesc
			}else{
				Set diagDesc=diagDesc_";"_MRCICDDxDesc
			}
		}
		
		Set Data=$lb(Type,AdmLoc,AdmWard,AdmitDate,AdmitTime,DisDate,DisTime,diagDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryVisitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVisitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVisitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVisitInfoExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-06-19
/// Description:  根据就诊id查询登记表信息
/// Table：       
/// Input:        aEpisodeID
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryRegisInfo",5)
Query QryRegisInfo(aEpisodeID As %String, CateDesc As %String, aIMPOrdNo As %String) As %Query(ROWSPEC = "OperDesc:%String,OperType:%String,OperLocDesc:%String,OperDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,OpertorName:%String,AnesMethod:%String,Incision:%String,ASAScorer:%String,ComplTypeDesc:%String,ComplDate:%String,ComplLvlDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRegisInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, CateDesc As %String, aIMPOrdNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:(aEpisodeID="")||(CateDesc="")||(aIMPOrdNo="") $$$OK
	
	Set Category = ##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc(CateDesc)
	Quit:'$IsObject(Category) $$$OK
	
	Set Category=Category.%Id()
	Set ID=""
	Set ID=$o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(aEpisodeID,"U"),Category,aIMPOrdNo,ID))
	Quit:ID="" $$$OK
	
	Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr"," "_$zcvt(ID,"U"),0))
	
	Quit:RegistId="" $$$OK
	Set RegistObj= ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
	Quit:'$IsObject(RegistObj) $$$OK
		
	Set RegType=RegistObj.RegType
	Set CompRegId=""
	if (RegType=1){
		Set CompRegId=$o(^MA.IMP.IPOperCompRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
		Quit:CompRegId="" $$$OK
	}
	Set SurgeryCompl = ##class(DHCMA.IMP.IP.OperCompReg).GetObjById(CompRegId)
	Quit:'$IsObject(SurgeryComplj) $$$OK
	
	Set xComplDate=SurgeryCompl.ComplDate
	Set SurID=SurgeryCompl.OperationID
	Quit:SurID="" $$$OK
	
	Set ComplDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xComplDate)  //并发症发生日期
	Set ComplTypeStr = SurgeryCompl.ComplTypes	
	Set ComplTypeDesc = ""    //并发症类型
	if (ComplTypeStr["!"){
		For indCom=1:1:$l(ComplTypeStr,"!"){
			Set ComplTypeID=$p(ComplTypeStr,"!",indCom)
			Set objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeID)
			Set ComplTypeDesc=ComplTypeDesc_","_objComlType.BTDesc
		}
			 Set:ComplTypeDesc'="" ComplTypeDesc=$e(ComplTypeDesc,2,$l(ComplTypeDesc))
	}else{
		Set:ComplTypeStr'="" objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeStr)
		Set ComplTypeDesc = objComlType.BTDesc
	}
	Set ComplLvlID =SurgeryCompl.ComplLevelDr.%Id()
	Set:ComplLvlID'="" objComplLevel = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(ComplLvlID)
	Set ComplLvlDesc = objComplLevel.BTCode_"级"   //并发症分级
		
	Set OperData = ##class(DHCMA.IMP.IPS.OperaCompRegSrv).GetOperByEpisodeID(aEpisodeID,SurID)
	if (OperData'=""){
		Set OperDesc = $lg(OperData,2)
		Set OperType = $lg(OperData,3)
		Set OperLocDesc = $lg(OperData,4)
		Set OperDate = $lg(OperData,5)
		Set StartTime = $lg(OperData,6)
		Set EndDate = $lg(OperData,7)
		Set EndTime = $lg(OperData,8)
		Set OpertorName = $lg(OperData,9)
		Set AnesMethod = $lg(OperData,10)
		Set Incision = $lg(OperData,11)
		Set ASAScorer = $lg(OperData,12)
					
		Set StartTime = OperDate_" "_StartTime
	  	Set EndTime = EndDate_" "_EndTime
	}	
		
		Set Data=$lb(OperDesc,OperType,OperLocDesc,OperDate,StartTime,EndDate,EndTime,OpertorName,AnesMethod,Incision,ASAScorer,ComplTypeDesc,ComplDate,ComplLvlDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryRegisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRegisInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRegisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRegisInfoExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-06-22
/// Description:  根据就诊id查询医嘱信息
/// Table：       OE_Order、OE_OrdItem、ARC_ItmMast、OEC_OrderStatus
/// Input:        aEpisodeID
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryOrderInfo",231)
Query QryOrderInfo(aEpisodeID As %String) As %Query(ROWSPEC = "Desc:%String,OSTATDesc:%String,SttDat:%String,SttTim:%String,DoctorDesc:%String,XDate:%String,XTime:%String,DRCrossDRDesc:%String,DepartmentDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOrderInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Quit:aEpisodeID="" $$$OK
	
	Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,""))						//医嘱表OE_Order
	Quit:OrderID="" $$$OK

	Set xID = 0
	For {
		Set xID = $o(^OEORD(OrderID,"I",xID))							//医嘱明细表OE_OrdItem 
		Quit:xID=""
		Set OEORIItemStatDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",13)	//OEORIItemStatDR->医嘱状态OEC_OrderStatus
		Set OSTATCode=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)		//医嘱状态
		Continue:OSTATCode'="V"											//过滤为非核实状态的
		Set OEORIItmMastDR = $p($G(^OEORD(OrderID,"I",xID,1)),"^",2)	//OEORIItmMastDR->医嘱项ARC_ItmMast
		Continue:OEORIItmMastDR=""
		Set Code1=$p(OEORIItmMastDR,"||",1)				
		Set Code2=$p(OEORIItmMastDR,"||",2)
		Set Desc = $p(^ARCIM(Code1,Code2,1),"^",2)						//ARCIMDesc
		if ((Desc="病危") || (Desc="病重")){
			Set OSTATDesc=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
			Set SttDat = $p($G(^OEORD(OrderID,"I",xID,1)),"^",9)
			Set:SttDat'="" SttDat=$zd(SttDat,3)	
			Set SttTim = $p($G(^OEORD(OrderID,"I",xID,1)),"^",10)
			Set:SttTim'="" SttTim=$zt(SttTim,1)	
			Set DoctorDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",11)
			Set:DoctorDR'="" DoctorDesc=$p($G(^CTPCP(DoctorDR,1)),"^",2)
			Set XDate = $p($G(^OEORD(OrderID,"I",xID,3)),"^",34)
			Set:XDate'="" XDate=$zd(XDate,3)	
			Set XTime = $p($G(^OEORD(OrderID,"I",xID,2)),"^",15)
			Set:XTime'="" XTime=$zt(XTime,1)	
			Set DRCrossDR = $p($G(^OEORD(OrderID,"I",xID,2)),"^",14)
			Set:DRCrossDR'="" DRCrossDRDesc=$p($G(^CTPCP(DRCrossDRDR,1)),"^",2)
			Set DepartmentDR = $p($G(^OEORD(OrderID,"I",xID,7)),"^",2)
			Set:DepartmentDR'="" DepartmentDesc=$p($G(^CTLOC(DepartmentDR)),"^",2)
			
			Set Data=$lb(Desc,OSTATDesc,SttDat,SttTim,DoctorDesc,XDate,XTime,DRCrossDRDesc,DepartmentDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryOrderInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrderInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOrderInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrderInfoExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-08-11
/// Description:  重点患者筛查科室列表
/// Table：       DHCMed.Base.Patient、DHCMA.IMP.IP.IMPRecord
/// Input：       aHospIDs  : 医院代码 多值"^"分割
/// 				  aCategory：重点患者分类
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期             
///               aPatInfo  : 患者信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryRecordLocList","2,3","","2019-01-01","2020-10-16","")
Query QryRecordLocList(aHospIDs As %String, aCategory As %String = "", aDateFrom As %String, aDateTo As %String, aPatInfo As %String = "", aDateType As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String,InPatientCnt:%String,ScreeningCnt:%String,ScreenProCnt:%String,ScreenExclude:%String,ScreenDiagnosis:%String,ScreenExamine:%String,CategoryDesc:%String") [ SqlProc ]
{
}

ClassMethod QryRecordLocListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aCategory As %String = "", aDateFrom As %String, aDateTo As %String, aPatInfo As %String = "", aDateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set:aDateType="" aDateType="0"
 	Set aPatName =$p(aPatInfo,"^",1)
    Set aRegNo = $p(aPatInfo,"^",2)
    Set aMrNo = $p(aPatInfo,"^",3)
    Set aBed = $p(aPatInfo,"^",4)
    
 	Kill ^TMP($zn,$j)
	For xDate = aDateFrom:1:aDateTo{
		if (aDateType="0"){
			Set xCateDr = ""
			For {
				Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
				Quit:xCateDr=""
				Set xID=""
				For{
					Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
					Quit:xID=""
					
					Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
					Continue:'$IsObject(objRecord)
					Set EpisodeID = objRecord.EpisodeID
					Continue:EpisodeID=""
					Set IMPOrdNo = objRecord.IMPOrdNo
					Set CategoryDesc = objRecord.IMPCateDr.BTDesc
					Set Category = objRecord.IMPCateDr.%Id()
					Continue:(aCategory'="")&&(aCategory'=Category)
				
					Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",2)
					//Continue:(aAdmStatus'="")&&((","_aAdmStatus_",")'[(","_VisitStatus_","))
					Set VisitStatus= $s(VisitStatus="O":"门诊",VisitStatus="I":"住院",1:"")
					//过滤科室、病区、医院
					Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
					//Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
					//统一病区筛查维度
					Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
					Continue:'$IsObject(objAdm)
					//Continue:objAdm.AdmType'="I"
					Set PatientID=objAdm.PatientID
					Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
					Continue:'$IsObject(objPatient)
					Set AdmWard=objAdm.Ward
					Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
					//Continue:(aWard'="")&&(aWard'=AdmWard)	//aWard是传入的科室
					If (aHospIDs'=""){
				 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospIDs)
				 		Continue:flg<1
			 		}
			 		Do BuildDataToRecordLoc(EpisodeID,aHospIDs,Category,IMPOrdNo)
				}
				
			}
		} elseif(aDateType="1"){
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Continue:$p(AdmInfo,"^",20)="D"           //过滤出院患者
				
				Set xCateDr = "",LastPaadm = ""
				For{
					Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr))
					//if ((xCateDr="")&&(xPaadm'=LastPaadm)) Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
					if (xCateDr=""){
						quit
					}
					Set xOrdNo = ""
					For{
						Set xOrdNo = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo))
						quit:xOrdNo=""
						//if (xOrdNo="") Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
						
						Set xID = ""
						Set xID = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo,xID))
						Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
						Continue:'$IsObject(objRecord)
						Set EpisodeID = objRecord.EpisodeID
						Continue:EpisodeID=""
						Set IMPOrdNo = objRecord.IMPOrdNo
						Set CategoryDesc = objRecord.IMPCateDr.BTDesc
						Set Category = objRecord.IMPCateDr.%Id()
						Continue:(aCategory'="")&&(aCategory'=Category)
						Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",2)
						//Continue:(aAdmStatus'="")&&((","_aAdmStatus_",")'[(","_VisitStatus_","))
						Set VisitStatus= $s(VisitStatus="O":"门诊",VisitStatus="I":"住院",1:"")
						//过滤科室、病区、医院
						Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
						//Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
						//统一病区筛查维度
						Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
						Continue:'$IsObject(objAdm)
						//Continue:objAdm.AdmType'="I"
						Set PatientID=objAdm.PatientID
						Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
						Continue:'$IsObject(objPatient)
						Set AdmWard=objAdm.Ward
						Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
						//Continue:(aWard'="")&&(aWard'=AdmWard)	//aWard是传入的科室
						If (aHospIDs'=""){
					 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospIDs)
					 		Continue:flg<1
				 		}
				 		Do BuildDataToRecordLoc(EpisodeID,aHospIDs,Category,IMPOrdNo)	
					}			
				}
				
			}
		}elseif(aDateType="2"){
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("DischDate",xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Continue:$p(AdmInfo,"^",20)'="D"           //过滤出院患者
				
				Set xCateDr = "",LastPaadm = ""
				For{
					Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr))
					//if ((xCateDr="")&&(xPaadm'=LastPaadm)) Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
					if (xCateDr=""){
						quit
					}
					Set xOrdNo = ""
					For{
						Set xOrdNo = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo))
						quit:xOrdNo=""
						//if (xOrdNo="") Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
						
						Set xID = ""
						Set xID = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo,xID))
						Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
						Continue:'$IsObject(objRecord)
						Set EpisodeID = objRecord.EpisodeID
						Continue:EpisodeID=""
						Set IMPOrdNo = objRecord.IMPOrdNo
						Set CategoryDesc = objRecord.IMPCateDr.BTDesc
						Set Category = objRecord.IMPCateDr.%Id()
						Continue:(aCategory'="")&&(aCategory'=Category)
						Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",2)
						//Continue:(aAdmStatus'="")&&((","_aAdmStatus_",")'[(","_VisitStatus_","))
						Set VisitStatus= $s(VisitStatus="O":"门诊",VisitStatus="I":"住院",1:"")
						//过滤科室、病区、医院
						Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
						//Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
						//统一病区筛查维度
						Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
						Continue:'$IsObject(objAdm)
						//Continue:objAdm.AdmType'="I"
						Set PatientID=objAdm.PatientID
						Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
						Continue:'$IsObject(objPatient)
						Set AdmWard=objAdm.Ward
						Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
						//Continue:(aWard'="")&&(aWard'=AdmWard)	//aWard是传入的科室
						If (aHospIDs'=""){
					 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospIDs)
					 		Continue:flg<1
				 		}
				 		Do BuildDataToRecordLoc(EpisodeID,aHospIDs,Category,IMPOrdNo)	
					}			
				}
				
			}
		}
	}

	Set xHospID=0
	For {
		Set xHospID=$o(^TMP($zn,$j,"RecordLoc-Cnt",xHospID))
		Quit:xHospID=""
		
		Set xLocID=0
		For {
			Set xLocID=$o(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID))
			Quit:xLocID=""
			
			Set tLoc=$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID))
			Continue:tLoc=""
			Set HospDesc=$listget(tLoc,1)
			Set LocDesc=$listget(tLoc,2)
			//Set Category=$listget(tLoc,3)
			//Set CategoryDesc=##class(DHCMA.IMP.BT.IMPCategory).GetObjById(Category).CateDesc
			Set InPatientCnt=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"InPatientCnt"))  //住院病人
			Set ScreeningCnt=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"ScreeningCnt"))  //筛查人数
			Set ScreenProCnt=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"ScreenProCnt"))  //疑似人数
			Set ScreenExclude=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"ScreenExclude"))  //排除人数
			Set ScreenDiagnosis=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"ScreenDiagnosis"))  //确诊人数
			Set ScreenExamine=+$g(^TMP($zn,$j,"RecordLoc-Cnt",xHospID,xLocID,"ScreenExamine"))      //审核人数
			
			Set Data=$lb(xLocID,LocDesc,xHospID,HospDesc,InPatientCnt,ScreeningCnt,ScreenProCnt,ScreenExclude,ScreenDiagnosis,ScreenExamine,CategoryDesc)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToRecordLoc(aEpisodeID,aHospIDs,Category,IMPOrdNo)
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objAdm)
	
	Quit:(objAdm.AdmType'="I")
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient)
	
	Set LocID=objAdm.DepartmentID
	Set HospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(LocID)
	Quit:(aHospIDs'="")&((aHospIDs)'[(HospID))  //医院过滤
	
	Set LocDesc=objAdm.Department
	Set:$p(LocDesc,"-",2)'="" AdmLoc=$p(LocDesc,"-",2)
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	Set PapmiNo=objPatient.PapmiNo				//登记号
	Set MrNo=objAdm.MrNo						//病案号
	Set PatientName=objPatient.PatientName		//姓名
	Set Bed=objAdm.Bed							//床位
	Quit:(aRegNo'="")&&(aRegNo'=PapmiNo)
	Quit:(aMrNo'="")&&(aMrNo'=MrNo)
	Quit:(aPatName'="")&&(PatientName'[aPatName)
	Quit:(aBed'="")&&(aBed'=Bed)
	
	Set ^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID)=$lb(HospDesc,LocDesc)       //科室信息
	Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"InPatientCnt"))      //住院病例
  
	//Set ScreenAttInfo=##class(DHCMA.IMP.IP.IMPRecord).GetObjByEpisodeID(aEpisodeID)
	Set ScreenAttInfo=##class(DHCMA.IMP.IP.IMPRecord).GetObjByEpisodeIDAndCategory(aEpisodeID,Category,IMPOrdNo)
	Set StatusDr=""
	Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",ScreenAttInfo.%Id(),0))
	if (RegistId'=""){
		Set objRegister = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
		Set StatusDr=objRegister.StatusDr.BTCode
	}
	
	if ($IsObject(ScreenAttInfo)){
		
		Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"ScreeningCnt"))	//筛查人数
	}
	
	Set Status=ScreenAttInfo.StatusDr.BTCode
	if (Status="AutoSign")||(Status="ManualSign"){
		
		Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"ScreenProCnt"))	//疑似人数
	}
	
	if (Status="Exclude"){
		Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"ScreenExclude"))	//排除人数
	}
	
	if (Status="Diagnosis"){
		Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"ScreenDiagnosis"))	//确诊人数
	}
	
	if (Status="Check"){
		Set num=$i(^TMP($zn,$j,"RecordLoc-Cnt",HospID,LocID,"ScreenExamine"))	//审核人数
	}
	
    
	Quit
}

ClassMethod QryRecordLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRecordLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordLocListExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-08-12
/// Description:  重点患者筛查病人列表
/// Table：       DHCHAI.DP.PAAdm、DHCMA.IMP.IP.IMPRecord
/// Input：       
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aPatInfo  : 患者信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryRecordPatList","2018-10-02","2020-10-20","95","^^^","",1)
Query QryRecordPatList(aDateFrom As %String, aDateTo As %String, aLocID As %String, aPatInfo As %String = "", aCategory As %String = "", aLocFlag As %String = "", aDateType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CateFlag:%String,CateDesc:%String,StatusDesc:%String,SuspendCode:%String,SuspendDesc:%String,CurrBed:%String,VisitStatus:%String,CurrLocDesc:%String,InHospDate:%String,AdmDocDesc:%String,CategoryDR:%String,RecordID:%String,IMPOrdNo:%String,LocID:%String,HappenDate:%String,IsOper:%String,IsEnd:%String,PatientID:%String") [ SqlProc ]
{
}

ClassMethod QryRecordPatListExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aPatInfo As %String = "", aCategory As %String = "", aLocFlag As %String = "", aDateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Set:aDateType="" aDateType= "0" 	
    Set aPatName =$p(aPatInfo,"^",1)
    Set aRegNo = $p(aPatInfo,"^",2)
    Set aMrNo = $p(aPatInfo,"^",3)
    Set aBed = $p(aPatInfo,"^",4)
    Set aEpisodeID = $p(aPatInfo,"^",5)
   
 
 	Kill ^TMP($zn,$j)
	
	For xDate = aDateFrom:1:aDateTo{
		if (aLocFlag=1){
			//临床科室查询该科室所有住院病人
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				Continue:$p(AdmInfo,"^",20)="D"           //过滤出院患者
				
				Set xCateDr = "",LastPaadm = ""
				For{
					Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr))
					//if ((xCateDr="")&&(xPaadm'=LastPaadm)) Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
					if ((xCateDr="")&&(xPaadm=LastPaadm)){
						quit
					}elseif(xCateDr=""){
						Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
					}
					
					Set xOrdNo = ""
					For{
						Set xOrdNo = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo))
						quit:xOrdNo=""
						//if (xOrdNo="") Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
						
						Set xID = ""
						Set xID = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo,xID))
						Set xID = $ZSTRIP(xID,"<W")
						Set:xID'="" LastPaadm =xPaadm
						Do BuildDataToRecordPat(xPaadm,aLocID,xID)
				
					}
					
				}
				
			}
		}else{
			//医务室查询该科室所有筛查病人
			if (aDateType="0"){
				Set xCateDr = ""
				For {
				Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
				Quit:xCateDr=""
					Set xID=""
					For{
						Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
						Quit:xID=""
						
						Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
						Continue:'$IsObject(objRecord)
						Set Category = objRecord.IMPCateDr.%Id()
						Continue:(aCategory'="")&&(aCategory'=Category)
						Set EpisodeID = objRecord.EpisodeID
						Continue:EpisodeID=""
						Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
				 		Do BuildDataToRecordPat(EpisodeID,aLocID,xID)
					}
				}
			}elseif (aDateType="1"){
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					Continue:$p(AdmInfo,"^",20)="D"           //过滤出院患者
					
					Set xCateDr = "",LastPaadm = ""
					For{
						Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr))
						//if ((xCateDr="")&&(xPaadm'=LastPaadm)) Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
						if (xCateDr=""){
							quit
						}
						
						Set xOrdNo = ""
						For{
							Set xOrdNo = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo))
							quit:xOrdNo=""
							//if (xOrdNo="") Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
							
							Set xID = ""
							Set xID = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo,xID))
							Set xID = $ZSTRIP(xID,"<W")
							Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
							Continue:'$IsObject(objRecord)
							Set Category = objRecord.IMPCateDr.%Id()
							Continue:(aCategory'="")&&(aCategory'=Category)
							Set:xID'="" LastPaadm =xPaadm
							Do BuildDataToRecordPat(xPaadm,aLocID,xID)
					
						}
						
					}
					
				}	
			}elseif(aDateType="2"){
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("DischDate",xDate,xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
					Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
					Continue:$p(AdmInfo,"^",20)'="D"           //过滤出院患者
					
					Set xCateDr = "",LastPaadm = ""
					For{
						Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr))
						//if ((xCateDr="")&&(xPaadm'=LastPaadm)) Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
						if (xCateDr=""){
							quit
						}
						
						Set xOrdNo = ""
						For{
							Set xOrdNo = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo))
							quit:xOrdNo=""
							//if (xOrdNo="") Do BuildDataToRecordPat(xPaadm,aLocID,"") quit
							
							Set xID = ""
							Set xID = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(xPaadm,"U"),xCateDr,xOrdNo,xID))
							Set xID = $ZSTRIP(xID,"<W")
							Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
							Continue:'$IsObject(objRecord)
							Set Category = objRecord.IMPCateDr.%Id()
							Continue:(aCategory'="")&&(aCategory'=Category)
							Set:xID'="" LastPaadm =xPaadm
							Do BuildDataToRecordPat(xPaadm,aLocID,xID)
					
						}
						
					}
					
				}	
			}
		}
		
	}
	
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToRecordPat(aEpisodeID,aLocID,xID)
	Set CateFlag="",CateDesc="",CategoryDR="",StatusDesc="",SuspendCode="",SuspendDesc="",IMPOrdNo="",HappenDate="",IsOper="",IsEnd=""
	if (xID '= ""){
		Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
		Set RecordID=objRecord.%Id()
		
		If $IsObject(objRecord.IMPCateDr){
		Set CateFlag=objRecord.IMPCateDr.BTCateFlag
		Set CateDesc=objRecord.IMPCateDr.BTDesc
		Set CategoryDR=objRecord.IMPCateDr.%Id()
		}
		
		Set Status=objRecord.StatusDr
		Set StatusDesc=Status.BTDesc  
		/**
		if (CateFlag'="")&&(StatusDesc="排除"){
			Set CateFlag=$P(CateFlag,".",1)_"_N.png"	//图标定义
		}
		if (StatusDesc="自动标记")||(StatusDesc="手动标记"){
			Set CateFlag=""	
		}
		**/
		Set SuspendCode=Status.BTCode
		
		if (StatusDesc="自动标记")||(StatusDesc="手动标记"){
			Set SuspendDesc="未处理"
		}else{
			Set SuspendDesc="已处理"
		}
		Set:CateDesc'="" CateDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",CateDesc)
		Set:StatusDesc'="" StatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",StatusDesc)
		Set:SuspendDesc'="" SuspendDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",SuspendDesc)
		Set Opinion=objRecord.Opinion
		Set KeywordScr=objRecord.IMPKeywords
		
		Set HappenDate=objRecord.HappenDate
		Set:HappenDate'="" HappenDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HappenDate)
		Set IsOper=objRecord.IMPCateDr.BTIsOper
		Set IsEnd=objRecord.IMPCateDr.BTIsEnd
		Set IMPOrdNo=objRecord.IMPOrdNo
	}
	
	Set (PatientID,RegNo,PatientName,Sex,PatientAge,AdmitDate,Room,Bed,AdmType,LocDesc,WardDesc)=""
	Set (LocID,WardID,DoctorID,DoctorName)=""
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objAdm) return
	Quit:objAdm.AdmType'="I" return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	Set LocID=objAdm.DepartmentID
	Quit:(aLocID'="")&&(aLocID'=LocID)  
	
	//统一调用年龄计算方法
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set DischDateTime= ##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
		
	Set AdmLoc=objAdm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	
	Quit:(aPatName'="")&&(objPatient.PatientName'[aPatName)
	Quit:(aRegNo'="")&&(aRegNo'=objPatient.PapmiNo)
	Quit:(aMrNo'="")&&(aMrNo'=objAdm.MrNo)
	Quit:(aBed'="")&&(aBed'=objAdm.Bed)
	
	Set BedDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","床")
	Set CurrBed=objAdm.Bed
	Set:CurrBed'["床" CurrBed=CurrBed_BedDesc
	
	Set VisitStatus=$p($g(^PAADM(aEpisodeID)),"^",2)
	Set VisitStatus= $s(VisitStatus="O":"门诊",VisitStatus="I":"住院",1:"")
	Set:VisitStatus'="" VisitStatus = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",VisitStatus)
	
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	Set:AdmWard'="" AdmWard = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
 	
 	Set Data=$lb(aEpisodeID,objPatient.PapmiNo,objPatient.PatientName,objPatient.Sex,PatientAge,CateFlag,CateDesc,StatusDesc,SuspendCode,SuspendDesc,CurrBed,VisitStatus,AdmWard,AdmDate,objAdm.DoctorName,CategoryDR,RecordID,IMPOrdNo,LocID,HappenDate,IsOper,IsEnd,PatientID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QryRecordPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRecordPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordPatListExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-08-13
/// Description:  根据就诊id查询筛查记录
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       aEpisodeID : 就诊号
/// 			  CateCode	 : 分类代码
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryRecordResult","1","","")
Query QryRecordResult(aEpisodeID As %String, CategoryDR As %String, aIMPOrdNo As %String) As %Query(ROWSPEC = "ScreenProgram:%String,ScreenDetails:%String")
{
}

ClassMethod QryRecordResultExecute(ByRef qHandle As %Binary, aEpisodeID As %String, CategoryDR As %String, aIMPOrdNo As %String) As %Status
{
	Set repid2=$I(^CacheTemp)
	Set qHandle=$lb(0,repid2,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
 	Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjByEpisodeIDAndCategory(aEpisodeID,CategoryDR,aIMPOrdNo)
 	Set RegType="",RegistId="",RecordId="",objCategory=""
 	if ($IsObject(objRecord)){
	 	Set RecordId=objRecord.%Id()
	 	Set StatusDesc = objRecord.StatusDr.BTDesc
	 	
	 	Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",RecordId,0))
	 	if (RegistId'=""){
	 		Set RegistObj= ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
	 		Set:$IsObject(RegistObj) RegType=RegistObj.RegType
	 		//Set StatusDr = RegistObj.StatusDr
	 		//Set Opinion = RegistObj.Opinion
 		}
 	}
 	
 	Set:CategoryDR'="" objCategory = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(CategoryDR)
 	//Quit:('$IsObject(objCategory))||('$IsObject(objRecord)) $$$OK
 	if ($IsObject(objCategory)){
	 	Set CategoryDesc = objCategory.BTDesc
 	}else{
	 	Set CategoryDesc = ""
 	}
 	
 	
 	//手术并发症
 	
 	Set BFZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","并发症信息")
 	Set BFZSSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","并发症手术信息")
 	Set GJCSC = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","关键词筛查")
 	Set SSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","手术信息")
 	Set SCZT = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","筛查状态")
 	Set SFSB = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","是否上报")
 	Set YZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","医嘱信息")
	Set HLJB = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","护理级别")
 	Set FJHCFSSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","非计划重返手术信息")
 	Set TYFX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","特因分析")
 	Set JZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","","就诊信息")
 	
	if (CategoryDesc="手术并发症"){
		if (RegType = 1){
			//"并发症信息","并发症手术信息","关键词筛查","筛查状态","是否上报"
			Set ScreenPrograms=$lb(BFZXX,BFZSSXX,GJCSC,SCZT,SFSB)
		}else{
			//"并发症信息","手术信息","关键词筛查","筛查状态","是否上报"
			Set ScreenPrograms=$lb(BFZXX,SSXX,GJCSC,SCZT,SFSB)
		}
	}
	//危重病例
	if (CategoryDesc="危重病例"){
		//"医嘱信息","护理级别","关键词筛查","筛查状态","是否上报"
		Set ScreenPrograms=$lb(YZXX,HLJB,GJCSC,SCZT,SFSB)
	}
	//非计划重返手术
	if (CategoryDesc="非计划重返手术"){
		if (RegType = 2){
			//"非计划重返手术信息","关键词筛查","筛查状态","是否上报"
			Set ScreenPrograms=$lb(FJHCFSSXX,GJCSC,SCZT,SFSB)
		}else{
			//"手术信息","关键词筛查","筛查状态","是否上报"
			Set ScreenPrograms=$lb(YZXX,GJCSC,SCZT,SFSB)
		}
		
	}
	//非计划重返ICU
	if ((CategoryDesc="非计划重返ICU") || (CategoryDesc="长期住院")){
		//"就诊信息","关键词筛查","筛查状态","是否上报"
		Set ScreenPrograms=$lb(JZXX,GJCSC,SCZT,SFSB)
	}
	//非计划重返住院
	if (CategoryDesc="非计划重返住院"){
		//"就诊信息","关键词筛查","筛查状态","特因分析","是否上报"
		Set ScreenPrograms=$lb(JZXX,GJCSC,SCZT,TYFX,SFSB)
	}
	//未标记的
	if (CategoryDesc=""){
		//"筛查状态"
		Set ScreenPrograms=$lb(SCZT)
	}
	For I = 1:1:$LL(ScreenPrograms){
		Set ScreenProgram=$LI(ScreenPrograms,I)
		
		Set ScreenDetails= ##class(DHCMA.IMP.IPS.IMPRecordSrv).getResultByProgram(aEpisodeID,ScreenProgram,CategoryDR,RecordId)
		
		Set Data=$lb(ScreenProgram,ScreenDetails)
		Set ^CacheTemp(repid2,ind)=Data
		Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryRecordResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRecordResultExecute ]
{
	Set repid2=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid2)
 	Quit $$$OK
}

ClassMethod QryRecordResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRecordResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid2=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid2,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid2,ind)
 	}
 	s qHandle=$lb(AtEnd,repid2,ind)
	Quit $$$OK
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-13
/// Description:  根据筛查项目获取筛查明细
/// Table：       DHCMA.IMP.IP.IMPRecord
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).getResultByProgram("1","筛查状态","","")
ClassMethod getResultByProgram(aEpisodeID As %String, aProgram As %String, CategoryDR As %String, RecordId As %String) As %String
{
	New (aEpisodeID,aProgram,CategoryDR,RecordId,%session)
	Set return=""
	Quit:(aEpisodeID="")||(aProgram="") return
	
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	
	Set BFZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"并发症信息")
 	Set BFZSSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"并发症手术信息")
 	Set GJCSC = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"关键词筛查")
 	Set SSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"手术信息")
 	Set SCZT = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"筛查状态")
 	Set SFSB = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"是否上报")
 	Set YZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"医嘱信息")
	Set HLJB = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"护理级别")
 	Set FJHCFSSXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"非计划重返手术信息")
 	Set TYFX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"特因分析")
 	Set JZXX = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"就诊信息")
	
	if (aProgram=BFZXX){//"并发症信息"
		Set:RecordId'="" RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",RecordId,0))
		Quit:RegistId="" return
		
		Set RegistObj= ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
		Quit:'$IsObject(RegistObj) return
		Set RegType=RegistObj.RegType
		Set CompRegId=""
		if (RegType=1){
			Set CompRegId=$o(^MA.IMP.IPOperCompRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
			Quit:CompRegId="" $$$OK
		}
		Set SurgeryCompl = ##class(DHCMA.IMP.IP.OperCompReg).GetObjById(CompRegId)
		Quit:'$IsObject(SurgeryCompl) return
		
		Set xComplDate=SurgeryCompl.ComplDate
		Set SurID=SurgeryCompl.OperationID
		Quit:SurID="" return
		
		Set ComplDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xComplDate)  //并发症发生日期
		Set ComplTypeStr = SurgeryCompl.ComplTypes	
		Set ComplTypeDesc = ""    //并发症类型
		if (ComplTypeStr["!"){
			For indCom=1:1:$l(ComplTypeStr,"!"){
				Set ComplTypeID=$p(ComplTypeStr,"!",indCom)
				Set objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeID)
				Set ComplTypeDesc=ComplTypeDesc_","_objComlType.BTDesc
			}
			Set:ComplTypeDesc'="" ComplTypeDesc=$e(ComplTypeDesc,2,$l(ComplTypeDesc))
		}else{
			Set:ComplTypeStr'="" objComlType = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(ComplTypeStr)
			Set ComplTypeDesc = objComlType.BTDesc
		}
		Set ComplLvlID =SurgeryCompl.ComplLevelDr.%Id()
		Set:ComplLvlID'="" objComplLevel = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(ComplLvlID)
		Set ComplLvlDesc = objComplLevel.BTCode_"级"   //并发症分级
		
		Set return="并发症类型: "_ComplTypeDesc_","_"并发症分级: "_ComplLvlDesc_","_"并发症日期: "_ComplDate
		Quit return
	}
	
	if (aProgram=SSXX){//"手术信息"
		Set rs=##Class(%Library.ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForM")
		Do rs.Execute("","",aEpisodeID)
		while(rs.Next()){
			Set OperDesc=rs.GetData(4)
			Set OperType=rs.GetData(5)
			Set StartDate=rs.GetData(6)
			Set StartTime=rs.GetData(7)
			Set EndDate=rs.GetData(8)
			Set EndTime=rs.GetData(9)
			Set OperLocDesc=rs.GetData(12)
			Set OpertorName=rs.GetData(14)
			Set AnesMethod=rs.GetData(22)
			Set Incision=rs.GetData(18)
			Set ASAScore=rs.GetData(24)
			Set StartTime = StartDate_" "_StartTime
			Set EndTime = EndDate_" "_EndTime

			Set x=OperDesc_","_OperType_","_OperLocDesc_","_StartTime_"->"_EndTime_","_OpertorName_","_AnesMethod_","_Incision_","_ASAScore_"!"_OperDesc_"("_StartDate_"->"_EndDate_")"_"("_OperType_")"
			
			Set return=return_";"_x
		}
		Set:return'="" return=$e(return,2,$l(return))
		Quit return
	}
	
	if (aProgram=GJCSC){//"关键词筛查"
		Set:RecordId'="" objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordId)
		Quit:'$IsObject(objRecord)
		Set KeywordScr = objRecord.IMPKeywords
		Set return=KeywordScr
		Quit return
	}
	
	if (aProgram=SCZT){//"筛查状态"
		if (RecordId'=""){
			Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordId)
			Set Status = objRecord.StatusDr.BTDesc
			if ((Status = "排除") || (Status = "审核")){
				Set return = Status_"("_objRecord.Opinion_")"
			}else{
				Set aFlag = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,Status)
				Set return = aFlag
			}
		}else{
			Set aFlag = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"未标记")
			Set return = aFlag
		}
		
		
		//Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr"," "_$zcvt(RecordId,"U"),0))
		//if (RegistId=""){
			//Set return = Status.BTDesc
		//}else{
			//Set RegistObj= ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
			//Set:$IsObject(RegistObj) RegistStatus=RegistObj.StatusDr
			//Set return = RegistStatus.BTDesc
		//}
		Quit return
	}
	/**
	if (aProgram="排除原因"){
		Set objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordId)
		Set Opinion = objRecord.Opinion
		Set return = Opinion
		Quit return
	}
	
	if (aProgram="审核意见"){
		Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr"," "_$zcvt(RecordId,"U"),0))
		Set RegistObj= ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
		Set Opinion=RegistObj.Opinion
		Set return = Opinion
		Quit return
	}
	**/
	if (aProgram=YZXX){//"医嘱信息"
		Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,""))						//医嘱表OE_Order
		Quit:OrderID="" return
		Set xID = 0
		For {
			Set xID = $o(^OEORD(OrderID,"I",xID))							//医嘱明细表OE_OrdItem 
			Quit:xID=""
			Set OEORIItemStatDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",13)	//OEORIItemStatDR->医嘱状态OEC_OrderStatus
			Set OSTATCode=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)		//医嘱状态
			Continue:OSTATCode'="V"											//过滤为非核实状态的
			Set OEORIItmMastDR = $p($G(^OEORD(OrderID,"I",xID,1)),"^",2)	//OEORIItmMastDR->医嘱项ARC_ItmMast
			Continue:OEORIItmMastDR=""
			Set Code1=$p(OEORIItmMastDR,"||",1)				
			Set Code2=$p(OEORIItmMastDR,"||",2)
			Set Desc = $p(^ARCIM(Code1,Code2,1),"^",2)						//ARCIMDesc
			if ((Desc="病危") || (Desc="病重")){
				Set OSTATDesc=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
				Set SttDat = $p($G(^OEORD(OrderID,"I",xID,1)),"^",9)
				Set:SttDat'="" SttDat=$zd(SttDat,3)	
				Set SttTim = $p($G(^OEORD(OrderID,"I",xID,1)),"^",10)
				Set:SttTim'="" SttTim=$zt(SttTim,1)	
				Set DoctorDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",11)
				Set:DoctorDR'="" DoctorDesc=$p($G(^CTPCP(DoctorDR,1)),"^",2)
				Set XDate = $p($G(^OEORD(OrderID,"I",xID,3)),"^",34)
				Set:XDate'="" XDate=$zd(XDate,3)	
				Set XTime = $p($G(^OEORD(OrderID,"I",xID,2)),"^",15)
				Set:XTime'="" XTime=$zt(XTime,1)	
				Set DRCrossDR = $p($G(^OEORD(OrderID,"I",xID,2)),"^",14)
				Set DRCrossDRDesc=""
				Set:DRCrossDR'="" DRCrossDRDesc=$p($G(^CTPCP(DRCrossDRDR,1)),"^",2)
				Set DepartmentDR = $p($G(^OEORD(OrderID,"I",xID,7)),"^",2)
				Set:DepartmentDR'="" DepartmentDesc=$p($G(^CTLOC(DepartmentDR)),"^",2)
				Set StartTime = SttDat_" "_SttTim
				Set EndTime = XDate_" "_XTime
				
				Set x=Desc_","_OSTATDesc_","_DepartmentDesc_","_StartTime_"->"_EndTime_","_"开医嘱人: "_DoctorDesc_","_"停医嘱人: "_DRCrossDRDesc_"!"_Desc_"("_SttDat_"->"_XDate_")"_"("_OSTATDesc_")"
				Set return=return_";"_x
			}
		}
		Set:return'="" return=$e(return,2,$l(return))
		Quit return
	}
	
	if (aProgram=HLJB){//"护理级别"
		Set return=##class(Nur.CommonInterface.Patient).getCareLevel(aEpisodeID)
		Quit return
	}
	
	if (aProgram=JZXX){//"就诊信息"
		Set:RecordId'="" objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordId)
		Set LinkedEpisodeID =objRecord.LnkEpisInfo
		Set Data=$lb(aEpisodeID,LinkedEpisodeID)
		For indBar=1:1:2{
			Set Id=$LI(Data,indBar)
			Continue:Id=0
			Set AdmInfo=$g(^PAADM(Id))
			Set Type=$p(AdmInfo,"^",2)
			Set:Type'="" Type = $S(Type="I":"住院",Type="O":"门诊",Type="E":"急诊",Type="H":"体检")
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Id)
			Set AdmLoc=objAdm.Department
			Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
			Set AdmWard=objAdm.Ward
			Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
			Set AdmitDate=$p(AdmInfo,"^",6)
			Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
			Set AdmitTime=$p(AdmInfo,"^",7)
			Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
			Set DisDate=$p(AdmInfo,"^",17)
			Set:DisDate'="" DisDate=$zd(DisDate,3)
			Set DisTime=$p(AdmInfo,"^",18)
			Set:DisTime'="" DisTime=$zt(DisTime,1)
			Set MRAdm=$p(AdmInfo,"^",61)				//MR_Adm
			Set StartTime = AdmitDate_" "_AdmitTime
			Set EndTime = DisDate_" "_DisTime
			
			Set:AdmitDate'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmitDate)
			if (DisDate'=""){
				Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DisDate)
			} else{
				Set DateTo=""
			}
			If DateTo'="" {
				Set AdmDays=DateTo-DateFrom
			} Else {
				Set AdmDays=(+$h)-DateFrom
			}
			Set AdmDays=AdmDays_"天"
			
			Set childSub=0
			Set diagDesc=""
			For{
				Quit:MRAdm=""
				Set childSub=$o(^MR(MRAdm,"DIA",childSub))
				Quit:childSub=""
		
				Set MRDiagnosInfo=$g(^MR(MRAdm,"DIA",childSub))
				Set MRCICDDx=$p(MRDiagnosInfo,"^",1)				//MRC_ICDDx
				continue:MRCICDDx=""
				Set MRCICDDxInfo=$g(^MRC("ID",MRCICDDx))
				Set MRCICDDxDesc=$p(MRCICDDxInfo,"^",2)
				//Set:MRCICDDxDesc'="" diagDesc=diagDesc_";"_MRCICDDxDesc
				if (diagDesc=""){
					Set diagDesc=MRCICDDxDesc
				}else{
					Set diagDesc=diagDesc_"/"_MRCICDDxDesc
				}
			}
			Set x=Type_","_AdmLoc_","_AdmWard_","_StartTime_"->"_EndTime_","_AdmDays_","_diagDesc_"!"_AdmLoc_"("_AdmitDate_"->"_DisDate_")"_"("_AdmDays_")"_"("_diagDesc_")"
			Set return=return_";"_x
		}
		Set:return'="" return=$e(return,2,$l(return))
		Quit return
	}
	
	
	if (aProgram=TYFX){//"特因分析"
		Set:RecordId'="" objRecord=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordId)
		Quit:'$IsObject(objRecord)
		Set ReasonDic = objRecord.IMPReasonDr.BTDesc
		Set return = ReasonDic
		Quit return
	}
	
	if (aProgram=BFZSSXX){//"并发症手术信息"
		Set:RecordId'="" RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",RecordId,0))
		Set CompRegId=$o(^MA.IMP.IPOperCompRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
		Set objCompReg= ##class(DHCMA.IMP.IP.OperCompReg).GetObjById(CompRegId)
		Set OperationID=objCompReg.OperationID
		
		Set rs=##Class(%Library.ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForIMP")
		Do rs.Execute("","",aEpisodeID,OperationID)
		while(rs.Next()){
			Set OperDesc=rs.GetData(4)
			Set OperType=rs.GetData(5)
			Set StartDate=rs.GetData(6)
			Set StartTime=rs.GetData(7)
			Set EndDate=rs.GetData(8)
			Set EndTime=rs.GetData(9)
			Set OperLocDesc=rs.GetData(12)
			Set OpertorName=rs.GetData(14)
			Set AnesMethod=rs.GetData(22)
			Set Incision=rs.GetData(18)
			Set ASAScore=rs.GetData(24)
			Set StartTime = StartDate_" "_StartTime
			Set EndTime = EndDate_" "_EndTime

			Set x=OperDesc_","_OperType_","_OperLocDesc_","_StartTime_"->"_EndTime_","_OpertorName_","_AnesMethod_","_Incision_","_ASAScore_"!"_OperDesc_"("_StartDate_"->"_EndDate_")"_"("_OperType_")"
			
			Set return=return_";"_x
		}
		Set:return'="" return=$e(return,2,$l(return))
		Quit return
	}
	
	if (aProgram=FJHCFSSXX){//"非计划重返手术信息"
		Set:RecordId'="" RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",RecordId,0))
		
		Set OperRegId=$o(^MA.IMP.IPURTOperRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
		Set objOperReg= ##class(DHCMA.IMP.IP.URTOperReg).GetObjById(OperRegId)
		Set FirstOperID=objOperReg.FirstOperID
		Set ReoperID=objOperReg.ReoperID
		Set OperID=FirstOperID_","_ReoperID

		Set rs=##Class(%Library.ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForIMP")
		Do rs.Execute("","",aEpisodeID,OperID)
		while(rs.Next()){
			Set OperDesc=rs.GetData(4)
			Set OperType=rs.GetData(5)
			Set StartDate=rs.GetData(6)
			Set StartTime=rs.GetData(7)
			Set EndDate=rs.GetData(8)
			Set EndTime=rs.GetData(9)
			Set OperLocDesc=rs.GetData(12)
			Set OpertorName=rs.GetData(14)
			Set AnesMethod=rs.GetData(22)
			Set Incision=rs.GetData(18)
			Set ASAScore=rs.GetData(24)
			Set StartTime = StartDate_" "_StartTime
			Set EndTime = EndDate_" "_EndTime

			Set x=OperDesc_","_OperType_","_OperLocDesc_","_StartTime_"->"_EndTime_","_OpertorName_","_AnesMethod_","_Incision_","_ASAScore_"!"_OperDesc_"("_StartDate_"->"_EndDate_")"_"("_OperType_")"
			
			Set return=return_";"_x
		}
		Set:return'="" return=$e(return,2,$l(return))
		Quit return
	}
	
	
	if (aProgram=SFSB){ //"是否上报"
		Set:RecordId'="" RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",RecordId,0))
		
		if (RegistId=""){
			Set return = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"未上报")
		}else{
			Set objRegister=##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
			Set Status = objRegister.StatusDr.BTCode
			Set:((Status="Submit")||(Status="Check")) return = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc",Languages,"已上报")
		}
		Quit return
	}
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-17
/// Description:  更新重点患者特因分析
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).UpdateReason("128^231^2^1")
ClassMethod UpdateReason(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set RecordID                    = $p(aInputStr,aSeparete,1)
	Set Reason                      = $p(aInputStr,aSeparete,2)
	Set Reasontxt                   = $p(aInputStr,aSeparete,3)

	Quit:(RecordID="") return
	Set obj=##class(DHCMA.IMP.IP.IMPRecord).GetObjById(RecordID)
	Quit:'$IsObject(obj) return
	
	Set:Reason'="" obj.IMPReasonDr = ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(Reason)
	Set:Reasontxt'="" obj.Opinion = Reasontxt
	Set obj.StatusDr = ##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","排除")
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// 重点患者病例统计
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryStat","2,3","2019-01-01","2020-09-16","","")
Query QryStat(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aCategory As %String) As %Query(ROWSPEC = "xID:%String,InLocDesc:%String,CategoryDesc:%String,Status:%String,Reason:%String,RegInfo:%String,IsMarkAuto:%String") [ SqlProc ]
{
}

ClassMethod QryStatExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aCategory As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)

	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
    For xDate=aDateFrom:1:aDateTo {
		Set xCateDr = ""
		For{
			Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
			Quit:xCateDr=""
			Set xID=""
			For{
				Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
				Quit:xID=""
				
				Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
				Continue:'$IsObject(objRecord)
				Set EpisodeID = objRecord.EpisodeID
				Continue:EpisodeID=""
				Set IsMarkAuto = objRecord.IsMarkAuto
				Set CategoryDesc = objRecord.IMPCateDr.BTDesc
				Set Category = objRecord.IMPCateDr.%Id()
				Continue:(aCategory'="")&&(aCategory'=Category)
				Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
				Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
				Set InLocDesc=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).Department
				If (aHospID'=""){
			 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
			 		Continue:flg<1
		 		}
				Set Status = objRecord.StatusDr.BTDesc 
				Set (Reason,RegInfo,ComplLvL,ComplDic)=""
				Set ReasonDic = objRecord.IMPReasonDr
				Set:$IsObject(ReasonDic) Reason=ReasonDic.BTDesc
				Set RegInfo = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",xID,0))
				//Set RegInfo = objRecord.LinkedRegInfo
				//手术并发症统计表
				//if (CategoryDesc="手术并发症"){
					//Set:$IsObject(RegInfo) SurgeryCompl = RegInfo.SurgeryCompl
					//Set:$IsObject(SurgeryCompl) ComplLvL = SurgeryCompl.ComplLevel.%Id()
					//Set:$IsObject(SurgeryCompl) ComplDic = SurgeryCompl.ComplType
					//Continue:(aComplLvL'="")&&(aComplLvL'=ComplLvL)	
					//Continue:(aComplDic'="")&&(aComplDic'=ComplDic)
				//}
				
				Set Data=$lb(xID,InLocDesc,CategoryDesc,Status,Reason,RegInfo,IsMarkAuto)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatExecute ]
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

/// 手术并发症患者病例统计
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryStatOperComp","2,3","2019-01-01","2020-09-16","","","1")
Query QryStatOperComp(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aComplLvL As %String, aComplDic As %String) As %Query(ROWSPEC = "xID:%String,InLocDesc:%String,CategoryDesc:%String,Status:%String,Reason:%String,RegInfo:%String,IsMarkAuto:%String") [ SqlProc ]
{
}

ClassMethod QryStatOperCompExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aComplLvL As %String, aComplDic As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set ^TEMPZDC20201118=aComplDic
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
    For xDate=aDateFrom:1:aDateTo {
		Set xCateDr = ""
		For{
			Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
			Quit:xCateDr=""
			Set xID=""
			For{
				Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
				Quit:xID=""
				
				Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
				Continue:'$IsObject(objRecord)
				Set EpisodeID = objRecord.EpisodeID
				Continue:EpisodeID=""
				Set CategoryDesc = objRecord.IMPCateDr.BTDesc
				Set Category = objRecord.IMPCateDr.%Id()
				Continue:(CategoryDesc'="手术并发症")
				Set (Reason,RegInfo,ComplLvL,ComplDic)=""
				Set ReasonDic = objRecord.IMPReasonDr
				Set:$IsObject(ReasonDic) Reason=ReasonDic.BTDesc
				Set Status = objRecord.StatusDr.BTDesc 
				Set InLocDesc=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).Department
				Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
				Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
				If (aHospID'=""){
			 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
			 		Continue:flg<1
		 		}
				Set IsMarkAuto = objRecord.IsMarkAuto
				
				Set RegistId = "",ComplLvL = "",ComplDic = ""
				Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",xID,0))
				if (RegistId'=""){
					Set RegistObj = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
					Set RegType=RegistObj.RegType
					Set CompRegId=""
					if (RegType=1){
						Set CompRegId=$o(^MA.IMP.IPOperCompRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
					}
					Set SurgeryCompl = ##class(DHCMA.IMP.IP.OperCompReg).GetObjById(CompRegId)
					Set:SurgeryCompl'="" ComplLvL = SurgeryCompl.ComplLevelDr.%Id()
					Set:SurgeryCompl'="" ComplDic = SurgeryCompl.ComplTypes
				} 
				if ((aComplLvL'="") || (aComplDic'="")){
					if (RegistId=""){
						quit
					}else{
						continue:(aComplLvL'="")&(aComplLvL'=ComplLvL)	
						//quit:(aComplDic'="")&&(ComplDic'[aComplDic)
						Set res =""
						if (ComplDic["!"){
							For indCom=1:1:$l(ComplDic,"!"){
								Set ComplTypeID=$p(ComplDic,"!",indCom)
								Set:(aComplDic'="")&(ComplTypeID=aComplDic) res =1
							}
					 	}else{
						 	Set:(aComplDic'="")&(ComplDic=aComplDic) res =1
						}
						continue:(aComplDic'="")&(res'=1)
					} 
					
				}
			
				Set Data=$lb(xID,InLocDesc,CategoryDesc,Status,Reason,RegistId,IsMarkAuto)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryStatOperCompClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatOperCompExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatOperCompFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatOperCompExecute ]
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

/// 非计划重返手术室患者病例统计
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.IPS.IMPRecordSrv","QryStatUnplanSur","2,3","2019-01-01","2020-09-16","")
Query QryStatUnplanSur(aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Query(ROWSPEC = "xID:%String,InLocDesc:%String,CategoryDesc:%String,Status:%String,RegInfo:%String,Time:%String,Time24H:%String,Time15D:%String,Time31D:%String,IsMarkAuto:%String") [ SqlProc ]
{
}

ClassMethod QryStatUnplanSurExecute(ByRef qHandle As %Binary, aHospID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
 	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
    For xDate=aDateFrom:1:aDateTo {
		Set xCateDr = ""
		For{
			Set xCateDr = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr))
			Quit:xCateDr=""
			Set xID=""
			For{
				Set xID = $o(^MA.IMP.IPIMPRecordI("IdxOfCateHappenDate",xCateDr,xDate,xID))
				Quit:xID=""
				
				Set objRecord = ##class(DHCMA.IMP.IP.IMPRecord).GetObjById(xID)
				Continue:'$IsObject(objRecord)
				Set EpisodeID = objRecord.EpisodeID
				Continue:EpisodeID=""
				Set CategoryDesc = objRecord.IMPCateDr.BTDesc
				Set Category = objRecord.IMPCateDr.%Id()
				Continue:(CategoryDesc'="非计划重返手术")
				Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID	// 从DHCMed.Base.PatientAdm获取患者的科室ID
				Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室
				If (aHospID'=""){
			 		Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
			 		Continue:flg<1
		 		}
				Set InLocDesc=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).Department
				Set Status = objRecord.StatusDr.BTDesc 
				Set IsMarkAuto = objRecord.IsMarkAuto
				
				Set (RegistId,Time,Time24H,Time15D,Time31D,FirstOperID,ReoperID)=""
				Set RegistId = $o(^MA.IMP.IPIMPRegisterI("IdxofIMPRecordDr",xID,0))
				if (RegistId'=""){
					Set RegistObj = ##class(DHCMA.IMP.IP.IMPRegister).GetObjById(RegistId)
					Set RegType=RegistObj.RegType
					if (RegType=2){
						Set OperRegId=$o(^MA.IMP.IPURTOperRegI("IdxofRegisterDr"," "_$zcvt(RegistId,"U"),0))
					}
					Set ObjOperReg = ##class(DHCMA.IMP.IP.URTOperReg).GetObjById(OperRegId)
					Set FirstOperID = ObjOperReg.FirstOperID
					Set ReoperID = ObjOperReg.ReoperID
				}
				
				Set Time = ##class(DHCMA.IMP.IPS.IMPRecordSrv).NotPlanReturnSurgeryTime(EpisodeID,FirstOperID,ReoperID)
				
				if ((Time="A")&&(Status="确诊")){
					Set Time24H="A"
				}
				if ((Time="B")&&((Status="确诊"))){
					Set Time15D="B"
				}
				if ((Time="C")&&((Status="确诊"))){
					Set Time31D="C"
				}
				
				Set Data=$lb(xID,InLocDesc,CategoryDesc,Status,RegistId,Time,Time24H,Time15D,Time31D,IsMarkAuto)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				}
		}
	}
	Quit $$$OK
}

ClassMethod QryStatUnplanSurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatUnplanSurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStatUnplanSurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatUnplanSurExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-09-18
/// Description:  非计划重返手术室
/// 				  	同一次住院，有多次手术，且本次手术开始时间与上次手术结束时间间隔分别在24小时内、2-15天、16-31天
/// return： 	  24小时返回A，2-15天返回B,16-31天返回C    
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).NotPlanReturnSurgeryTime(4,10,36)
ClassMethod NotPlanReturnSurgeryTime(EpisodeID As %String, FirstOperID As %String, ReoperID As %String) As %String
{
	New (EpisodeID,FirstOperID,ReoperID)
	Set return="N"
	Quit:(FirstOperID="")||(ReoperID="")||(EpisodeID="") return
	
	Set OperDataFirst = ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetOperByEpisodeID(EpisodeID,FirstOperID)
	if (OperDataFirst'=""){
		Set OperDateFirst = $lg(OperDataFirst,5)
		Set OperDateFirst=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(OperDateFirst)
		Set StartTimeFirst = $lg(OperDataFirst,6)
		Set StartTimeFirst=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(StartTimeFirst)
	}
	
	Set OperDataReoper = ##class(DHCMA.IMP.IPS.OperCompRegSrv).GetOperByEpisodeID(EpisodeID,ReoperID)
	if (OperDataReoper'=""){
		Set OperDateReoper = $lg(OperDataReoper,5)
		Set OperDateReoper=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(OperDateReoper)
		Set StartTimeReoper = $lg(OperDataReoper,6)
		Set StartTimeReoper=##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical(StartTimeReoper)
	}
		
	
	Set result=OperDateReoper-OperDateFirst
	if (result>=2)&&(result<=15){
		Set return="B"					//2-15天
	}
	if (result>=16)&&(result<=31){
		Set return="C"					//16-31天
	}
	if (result=0){
		Set return="A"					//24小时内
		
	}
	if (result=1){
		Set:StartTimeReoper<StartTimeFirst return="A"			//24小时内
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-11-13
/// Description:  手动标记重点患者
/// Table：       DHCMA.IMP.IP.IMPRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).UpdateMark("^1^9")
ClassMethod UpdateMark(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID                    = $p(aInputStr,aSeparete,1)
	Set EpisodeID             = $p(aInputStr,aSeparete,2)
	Set IMPCateDr             = $p(aInputStr,aSeparete,3)

	Quit:(EpisodeID="")||(IMPCateDr="") return
	Set objCategory = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(IMPCateDr)
	Quit:'$IsObject(objCategory) return
	
	Set CategoryBTCode = objCategory.BTCode
	if (CategoryBTCode="02"){
		Set operInfo = ##class(%ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForM")
		Do operInfo.Execute("","",EpisodeID)
		Quit:operInfo.Next()=0 -102
		}
	if (CategoryBTCode="03"){
		Set operInfo = ##class(%ResultSet).%New("DHCMA.IMP.IPS.OperCompRegSrv:GetAnOpListForM")
		Do operInfo.Execute("","",EpisodeID)
		Quit:operInfo.Next()=0 -103
		}
	
	Set CategoryFlag=objCategory.BTCateFlag
	Quit:objCategory.BTIsManMark'=1 -1

	Set aCategory=objCategory.%Id()
	Set objReMark = $o(^MA.IMP.IPIMPRecordI("IndexEpisCateOrdNo"," "_$zcvt(EpisodeID,"U"),aCategory,-1))
	Set ReMake=objCategory.BTIsReMark
	Quit:(ReMake'=1)&(objReMark'="") -2
	
	Set AdmDoc=$p($g(^PAADM(EpisodeID)),"^",9)
	Set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(EpisodeID)),"^",70)
	Set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5) 
	Set IMPOrdNo = ##class(DHCMA.IMP.Task.IMPScreeningSrv).getOrdNo(EpisodeID,IMPCateDr)
	Set HappenDateAndTime = ##class(DHCMA.IMP.Task.IMPScreeningSrv).getHappenDateAndTime(EpisodeID,IMPCateDr)
	Set HappenDate=$p(HappenDateAndTime,",",1)
	Set HappenTime=$p(HappenDateAndTime,",",2)
	Set Status=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPStatus","手动标记")
	Set:$IsObject(Status) Status=Status.%Id()
	Set LinkedEpisodeID=##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastEpisodeID(EpisodeID)
	Set LinkedSurInfoID=##class(DHCMA.IMP.Task.IMPScreeningSrv).getLastSurInfoID(EpisodeID)
	set aInputStr=ID_"^"_EpisodeID_"^"_LinkedEpisodeID_"^"_LinkedSurInfoID_"^"_IMPCateDr_"^"_IMPOrdNo_"^"_""_"^"_""_"^"_AdmLoc_"^"_AdmWard_"^"_AdmDoc_"^"_HappenDate_"^"_HappenTime_"^"_Status_"^"_""_"^"_+$h_"^"_$p($h,",",2)_"^"_""_"^"_0
	set ID=##class(DHCMA.IMP.IP.IMPRecord).Update(aInputStr)
	if (ID>0){
		Set return=IMPCateDr_"^"_IMPOrdNo_"^"_CategoryFlag_"^"_HappenDate_"^"_ID
	}
	
	Quit return
}

/// 清除业务数据
/// w ##class(DHCMA.IMP.IPS.IMPRecordSrv).ClearWorkData()
ClassMethod ClearWorkData() As %String
{
	w "开始清除重点患者业务数据...",!
	;"重点患者筛查记录"
	K ^MA.IMP.IPIMPRecordD
	K ^MA.IMP.IPIMPRecordI
	;重点患者登记主表
	K ^MA.IMP.IPIMPRegisterD
	K ^MA.IMP.IPIMPRegisterI
	;"重点患者登记表"
	K ^MA.IMP.IPCriticalIllRegD
	K ^MA.IMP.IPCriticalIllRegI
	K ^MA.IMP.IPLangHospRegD
	K ^MA.IMP.IPLangHospRegI
	K ^MA.IMP.IPOperCompRegD
	K ^MA.IMP.IPOperCompRegI
	K ^MA.IMP.IPURTHospRegD
	K ^MA.IMP.IPURTHospRegI
	K ^MA.IMP.IPURTOperRegD
	K ^MA.IMP.IPURTOperRegI
	Quit "完毕"
}

}
