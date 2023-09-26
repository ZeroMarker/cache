/// 名称:DHCMed.EPDService.SuspCasesXSrv
/// 描述: 传染病筛查日志相关服务
/// 编写者：pylian
/// 编写日期: 2019-02-12
Class DHCMed.EPDService.SuspCasesXSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-02-12
/// Description:  传染病筛查日志查询
/// Table：       DHCMed.EPD.Casesx
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.EPDService.SuspCasesXSrv","QryCasesX","1,2","1","01/01/2016","28/02/2019","","","I,O,E","")
Query QryCasesX(aHospID As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aInfDics As %String, aLocID As %String, aAdmType As %String = "", aIsRep As %String = "", aRstType As %String = "", aPapmiNo As %String = "", aIsDiag As %String = "") As %Query(ROWSPEC = "CasesXID:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmType:%String,ActDate:%String,ActLoc:%String,ActDiagnos:%String,EpdStatusCode:%String,EpdStatusDesc:%String,EpdDiagnosID:%String,EpdDiagnos:%String,IsReAdm:%String,IsReAdmDesc:%String,Opinion:%String,IsReVis:%String,IsReVisDesc:%String,IsCarry:%String,IsCarryDesc:%String,IsDecla:%String,IsDeclaDesc:%String,Remark:%String,RepList:%String,OldFlag:%String,OldRepList:%String,ActDiagnosID:%String")
{
}

ClassMethod QryCasesXExecute(ByRef qHandle As %Binary, aHospID As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aInfDics As %String, aLocID As %String, aAdmType As %String = "", aIsRep As %String = "", aRstType As %String = "", aPapmiNo As %String = "", aIsDiag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aFromDate=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
    
    Set:aDateType="" aDateType=1
    Set:aDateType=1 IndexCode="IndexSubjectActDate"  //发生日期
 	Set:aDateType=2 IndexCode="IndexSubjectRstDate"  //结果日期
  
	For xDate=aDateFrom:1:aDateTo {
 		Set xCasesXID=""
 		For {
 			Set xCasesXID=$o(^DHCMed.EPDi("CasesX",IndexCode,"EPDCC",xDate,xCasesXID))
 			Quit:xCasesXID=""
 		  
 			Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
 			Continue:'$IsObject(objCasesX)
			Set IsActive=objCasesX.CXIsActive
			Continue:IsActive'=1

		  	Set xSubID="", tflg =0
			For {
				Set xSubID=$o(^DHCMed.EPD("CasesX",xCasesXID,"DTL",xSubID))
				Quit:xSubID=""
				Continue:tflg=1
				Set DtlID = xCasesXID_"||"_xSubID
				Set objDtl=##class(DHCMed.EPD.CasesXDtl).GetObjById(DtlID)
				Continue:'$IsObject(objDtl)
				Continue:'$IsObject(objDtl.CXDScreeningDr)
				Continue:objDtl.CXDScreeningDr.BTIsActive'=1  // 对已经置为无效的筛查条件，不再展现
				Set IsActive=objDtl.CXDIsActive
				Continue:IsActive'=1
				Set ScreenID = objDtl.CXDScreeningDr.%Id()
			    Set Type = objDtl.CXDScreeningDr.BTType
			    Set:Type="K" Type="I"
			    if ((Type="K")||(Type="I")){
 					Set DContent = objDtl.CXDContent
 					Continue:DContent'["MRICD:"    //非诊断项目不判断
 					Set DResultID =objDtl.CXDResultID
 					Set MRADMDR = $p(DResultID,"||",1)
 					Set DiagSub = $p(DResultID,"||",2)   
 					Continue:'$d(^MR(MRADMDR,"DIA",DiagSub)) 
				}
			    Continue:(aRstType'="")&&(aRstType'[Type)
			    Set tflg =1
			}
			
			Continue:tflg=0
			Set EpisodeID=objCasesX.CXEpisodeID
			Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objPaadm) 
 			Set AdmInfo=$g(^PAADM(EpisodeID))
 			Set AdmType=$p(AdmInfo,"^",2)                   //就诊类型过滤
 			Continue:(aAdmType'="")&&(aAdmType'[AdmType)
 			Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"其他")
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
	
			Set xAdmLoc=$p(AdmInfo,"^",4)
			Continue:xAdmLoc=""
			Set xAdmWard=$p(AdmInfo,"^",70)
			Continue:(AdmType="I")&&(xAdmWard="")
			
 			Set HospID=$p($g(^CTLOC(xAdmLoc)),"^",22)
			Continue:(aHospID'="")&&((","_aHospID_",")'[(","_HospID_","))
		   
			Set PatientID=objPaadm.PatientID
			Set objPatient=##Class(DHCMed.Base.Patient).GetObjById(PatientID)
			Set PapmiNo=objPatient.PapmiNo		// 登记号
			Continue:((aPapmiNo'="")&&(aPapmiNo'=PapmiNo))
			Set PatName=objPatient.PatientName
			Set Sex=objPatient.Sex
			Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
			Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
			Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,"","")	//返回“*岁*月*天”
			Set (LocType,LocDesc) = ""
			if (aLocID'=""){
				Set tmpLoc=$g(^CTLOC(aLocID))
				Set LocType=$p(tmpLoc,"^",13)
				Set LocDesc=$p(tmpLoc,"^",2)
			}
            Set AdmLoc=objPaadm.Department
	        Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
            Set AdmWard=objPaadm.Ward
			Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
			Continue:((LocType="E")&&(LocDesc'=AdmLoc))
			Continue:((LocType="W")&&(LocDesc'=AdmWard))
			
			Set AdmRoom=objPaadm.Room
			Set AdmBed=objPaadm.Bed
			Set AdmDoc=objPaadm.DoctorName
			
		    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmitDate=$p(AdmDateTime,"^",1)
			Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate) 
			Set AdmitTime=$p(AdmDateTime,"^",2)
			Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
			Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
			Set DisDate=$p(DischDateTime,"^",1)
			Set DisTime=$p(DischDateTime,"^",2)
			Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DisDate)
    		Set:DisTime'="" DisTime=$zt(DisTime,1)

			Set ActDate=objCasesX.CXActDate
			Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
			Set ActLoc=objCasesX.CXActLoc
			Set ActDiagnos=objCasesX.CXActDiagnos
			Set ActDiagnosID = ""
			Set ActDiagnosID = ##class(DHCMed.EPDService.InfectionSrv).GetInfectIDByDesc(ActDiagnos)
			Set InfDic="",flg=0
		    For indx=1:1:$l(aInfDics,",") {
			    Set InfDic= $p(aInfDics,",",indx)
			    Continue:flg=1
			    Continue:InfDic=""
			    Continue:((InfDic'["新型冠状病毒")&&(InfDic'=ActDiagnos))
			    Continue:((InfDic["新型冠状病毒")&&(ActDiagnos'["新型冠状病毒"))
			    Set flg=1
		    }
		    Continue:(aInfDics'="")&&(flg'=1)
 			
 			Set EpdStatus=objCasesX.CXEpdStatus	
			Set EpdStatusDesc=$s(EpdStatus="0":"排除",EpdStatus="1":"确诊",-1:"未处置")
			Continue:((aIsDiag'="")&&(aIsDiag'[EpdStatusDesc))
			Set EpdDiagnosID=objCasesX.CXEpdDiagnos
		    Set EpdDiagnos=""
			If (EpdDiagnosID'="") {	
				Set objInf=##class(DHCMed.EPD.Infection).GetObjById(EpdDiagnosID)
				Set:$IsObject(objInf) EpdDiagnos=objInf.MIFDisease
			}
			
			Set IsReAdm=objCasesX.CXIsReAdm	
			Set IsReAdmDesc=$s(IsReAdm="A":"初诊",IsReAdm="R":"复诊")			
			Set Opinion=objCasesX.CXOpinion
			Set IsReVis=objCasesX.CXIsReVis
			Set IsReVisDesc=$s(IsReVis="A":"初诊",IsReVis="R":"复诊",1:"")
			Set IsCarry=objCasesX.CXIsCarry
			Set IsCarryDesc=$s(IsCarry="1":"携带",IsCarry="2":"非携带",1:"")
			Set IsDecla=objCasesX.CXIsDecla
			Set IsDeclaDesc=$s(IsDecla="1":"网报",IsDecla="2":"未网报",1:"")
			Set Remark=objCasesX.CXRemark
		
			//同类传染病报告列表
			Set RepList = ##class(DHCMed.EPDService.SuspCasesXSrv).GetReportByCasesX(xCasesXID)
		    Continue:(aIsRep=1)&&(RepList="")
		    Continue:((aIsRep=0)&&(RepList'="")||((aIsRep=0)&&(EpdStatusDesc="排除")))
		    
			Set OldFlag=0 
			Set OldRepList="" 
			Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
			Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期	
			Continue:(Birthday="")
			Set xRowID=""
			For {
		   		Set xRowID=$o(^MA.EPD.ImportReportI("IndexPersonId"," "_$ZCVT(PatName,"U"),Birthday," "_$ZCVT(IdentityCode,"U"),xRowID))
		   		Quit:xRowID=""
	
		   		Set OldRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
				Continue:'$IsObject(OldRep)
				
				Set OldFlag=1
				Set OldRepStatus=OldRep.EPDStatus
				Set DiseaseName=OldRep.DiseaseName
				Set OldRepList=OldRepList_","_DiseaseName
			}
		    Set:OldRepList'="" OldRepList=$e(OldRepList,2,$l(OldRepList)) 
		   
			Set Data=$lb(xCasesXID,EpisodeID,PatientID,PapmiNo,PatName,Sex,Age,AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmType,ActDate,ActLoc,ActDiagnos,EpdStatus,EpdStatusDesc,EpdDiagnosID,EpdDiagnos,IsReAdm,IsReAdmDesc,Opinion,IsReVis,IsReVisDesc,IsCarry,IsCarryDesc,IsDecla,IsDeclaDesc,Remark,RepList,OldFlag,OldRepList,ActDiagnosID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryCasesXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXExecute ]
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
/// CreatDate：   2019-02-12
/// Description:  根据筛查日志查询传染病筛查明细
/// Table：       DHCMed.EPD.Casesx、DHCMed.EPD.CasesxDtl
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.EPDService.SuspCasesXSrv","QryCasesXDtl","1")
Query QryCasesXDtl(aCasesXID As %String) As %Query(ROWSPEC = "CasesXID:%String,SubID:%String,CasesXDtlID:%String,ScreenID:%String,Type:%String,TypeDesc:%String,Condition:%String,DContent:%String,DHappenDate:%String,DHappenTime:%String,DActUser:%String,ContDesc:%String")
{
}

ClassMethod QryCasesXDtlExecute(ByRef qHandle As %Binary, aCasesXID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aCasesXID="") $$$OK
  
     Set xSubID=""
 	 For {
		Set xSubID=$o(^DHCMed.EPD("CasesX",aCasesXID,"DTL",xSubID))
		Quit:xSubID=""
 		Set DtlID = aCasesXID_"||"_xSubID
		Set objDtl=##class(DHCMed.EPD.CasesXDtl).GetObjById(DtlID)
		Continue:'$IsObject(objDtl)
		Continue:'$IsObject(objDtl.CXDScreeningDr)
		
		Set IsActive=objDtl.CXDIsActive
		Continue:IsActive'=1
		Set ScreenID = objDtl.CXDScreeningDr.%Id()
		Set Condition = objDtl.CXDScreeningDr.BTCondition
	    Set Type = objDtl.CXDScreeningDr.BTType
	    Set TypeDesc=$s(Type="K":"关键词",Type="I":"ICD编码",Type="L":"检验",Type="R":"检查")   
	 
		Set DContent=objDtl.CXDContent
        Set ContDesc = $p(DContent,":",1)
        ;Set Description = $tr(DContent,(ContDesc_":")," ")
		Set Description = $p(DContent,":","2")
        Set Desc1 = $p(Description,"#",1)
	    Set Desc2 = $p(Description,"#",2)
	    Set Desc3 = $p(Description,"#",3)
	    Set Desc4 = $p(Description,"#",4)
	    Set Desc5 = $p(Description,"#",5)
	    If (ContDesc="MRICD") {
		    Set ContDesc=" 诊断ID:"_" "_Desc1_" ICD编码:"_" "_Desc2_" 诊断名称:"_" "_Desc3 
	    }
	    If (ContDesc="RIS") {
		    Set ContDesc=" 检查ID:"_" "_Desc1_" 报告编号:"_" "_Desc2_" 医嘱:"_" "_Desc5 
	    }
	    If (ContDesc="EMR") {
		    Set ContDesc=" 病历诊断ICD:"_" "_Desc1_" 诊断名称:"_" "_Desc2
	    }
	    If (ContDesc="LIS") {
		    Set TSOrdDesc=""
		    For ind4=1:1:$l(Desc4,"!!") {
			    Set tTS=$p(Desc4,"!!",ind4)
			    Continue:tTS=""
				Set tTSOrdDesc=$p(tTS,"$",2)
				Continue:$listfind(TSOrdDesc,tTSOrdDesc)>0
				Set TSOrdDesc=TSOrdDesc_$lb(tTSOrdDesc)
		    }
		    Set ContDesc=" 检验号:"_" "_Desc2_" 检验项目:"_" "_Desc5_" 医嘱名称:"_" "_$listtostring(TSOrdDesc,"+")
	    }
	 
		Set DHappenDate=objDtl.CXDHappenDate
		Set:DHappenDate'="" DHappenDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DHappenDate)
		Set DHappenTime=objDtl.CXDHappenTime
		Set:DHappenTime'="" DHappenTime=$zt(DHappenTime,1)
		Set DActUser=objDtl.CXDActUser
		
		Set Data=$lb(aCasesXID,xSubID,DtlID,ScreenID,Type,TypeDesc,Condition,DContent,DHappenDate,DHappenTime,DActUser,ContDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCasesXDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
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
/// CreatDate：   2016-02-29
/// Description:  检查当前状态是否允许处置操作
/// Table：       DHCMed.EPD.CasesX
/// Input：       主题配置代码\筛查ID
/// Return：      返回Object
/// w ##class(DHCMed.EPDService.SuspCasesXSrv).CheckCasesStatus("EPDCC",15)
ClassMethod CheckCasesStatus(aSubjectCode As %String, aCasesXID As %String) As %String
{
	new (aSubjectCode,aCasesXID)
	Set return=0
	Quit:(aSubjectCode="")||(aCasesXID="") return
	
	Set $ZT="CheckCasesStatusError"
	
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
 
	If (EpdStatus="0")||(EpdStatus="1") {
		Set return=-1
		Quit return
	}
 	Set return=1
	Quit return
	
CheckCasesStatusError
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2016-02-29
/// Description:  处理传染病处置记录(排除\确诊)
/// Table：       DHCMed.EPD.CasesX
/// Input：       就诊号\传染病筛查记录ID\操作代码\诊断\意见\操作员登录科室\操作员
/// Return：      返回Object
/// w ##class(DHCMed.EPDService.SuspCasesXSrv).ProcCasesHandle("EPDCC","29","1","1","3333","117","9")
ClassMethod ProcCasesHandle(aSubjectCode As %String, aCasesXID As %String, aOperation As %String, aDiagnosID As %String, aOpinion As %String, aLocID As %String, aUserID As %String)
{
	new (aSubjectCode,aCasesXID,aOperation,aDiagnosID,aOpinion,aLocID,aUserID)
	Set return=0
	Quit:(aSubjectCode="")||(aCasesXID="")||(aOperation="") return
	
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
	Set EpisodeID=objCasesX.CXEpisodeID
	
    Set inputStr=aCasesXID		
	Set inputStr=inputStr_"^"_aSubjectCode
	Set inputStr=inputStr_"^"_EpisodeID
	Set inputStr=inputStr_"^"_objCasesX.CXActDate
	Set inputStr=inputStr_"^"_objCasesX.CXActLoc
		
	Set inputStr=inputStr_"^"_objCasesX.CXActDiagnos
	Set inputStr=inputStr_"^"_objCasesX.CXIsReAdm
	Set inputStr=inputStr_"^"_objCasesX.CXLnkResults
	Set inputStr=inputStr_"^"_aOperation
	Set inputStr=inputStr_"^"_aDiagnosID
	Set inputStr=inputStr_"^"_aOpinion 
	Set inputStr=inputStr_"^"_+$h
	Set inputStr=inputStr_"^"_$p($h,",",2)
	Set inputStr=inputStr_"^"_aLocID
	Set inputStr=inputStr_"^"_aUserID
	Set inputStr=inputStr_"^"_objCasesX.CXIsActive
	Set inputStr=inputStr_"^"_objCasesX.CXResume
	Set inputStr=inputStr_"^"_objCasesX.CXRstDate
	
	Set inputStr=inputStr_"^"_objCasesX.CXIsReVis
	Set inputStr=inputStr_"^"_objCasesX.CXIsCarry
	Set inputStr=inputStr_"^"_objCasesX.CXIsDecla
	Set inputStr=inputStr_"^"_objCasesX.CXRemark
	
	Set flg=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
	Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
	Set AdmHospID = +$p($g(^CTLOC(+AdmLoc)),"^",22)
	Set EpdSuspAutoSendMsg = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdSuspAutoSendMsg",AdmHospID)	// 传染病筛查后自动发消息
	// 没有配置传染病自动筛查后发送消息，点击处置才会发送消息
	if (EpdSuspAutoSendMsg=0){
		//传染病排除/确诊消息推送
		If aOperation="1"  {//确诊
		    Set RepFlag=##class(DHCMed.EPDService.SuspCasesXSrv).IsReportByCasesXID(aCasesXID)
		    IF (RepFlag=1) {
		   		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"4",EpisodeID)
		    }ElseIf(RepFlag=0) {
				Set SendMessage = ##class(websys.DHCMessageInterface).Send(aOpinion,"1018",aUserID,EpisodeID,"","","{""linkParam"":""EpisodeID="_EpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
				Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"1",EpisodeID)
		    }
		}ElseIf aOperation="0"{    //排除
			Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"2",EpisodeID)
		}
	}
	
	Set return=1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-02
/// Description:  检查处置操作的患者是否上报传染病
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       筛查ID
/// Return：      上报传染病报告（传染病诊断名称、传染病报卡日期）,是，"",否
/// w ##class(DHCMed.EPDService.CasesXSrv).GetIsReportByCasesXID(15)
ClassMethod GetIsReportByCasesXID(aCasesXID As %String) As %String
{
	new (aCasesXID)
	Set return=""
	Quit:(aCasesXID="") return
		
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
    Set EpisodeID=objCasesX.CXEpisodeID
    Quit:'$d(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID)) return  //无报告退出
   
    Set RepDiseases="" ,RepDates="",RepDisease="" ,RepDate=""
    Set RepID=""
    For {
	    Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,RepID))
	    Quit:RepID=""
	    
	    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	    Continue:'$IsObject(objRep)
	  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Set RepDisease=objRep.MEPDICDDR.MIFDisease
	    Set RepDate=objRep.MEPDRepDate
	    Set:RepDate'="" RepDate=$zd(RepDate,3)
	    
	    Set RepDiseases=RepDiseases_","_RepDisease
		Set RepDates=RepDates_","_RepDate   
    }
    
	Set:RepDiseases'="" RepDiseases=$e(RepDiseases,2,$l(RepDiseases))
	Set:RepDates'="" RepDates=$e(RepDates,2,$l(RepDates))
	
	Set:(RepDiseases'="")&&(RepDates'="") return=RepDiseases_"^"_RepDates
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-29
/// Description:  检查处置操作的患者是否上报某种传染病
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       筛查ID
/// Return：      是:1,否:0
/// w ##class(DHCMed.EPDService.CasesXSrv).IsReportByCasesXID(1)
ClassMethod IsReportByCasesXID(aCasesXID As %String)
{
	new (aCasesXID)
	Set return=0
	Quit:(aCasesXID="") return
		
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
    Set EpisodeID=objCasesX.CXEpisodeID
    Quit:'$d(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID)) return  //无报告退出
    
    Set EpdDiagnos=objCasesX.CXEpdDiagnos  //确诊诊断
    
    Set RepID=""
    For {
	    Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,RepID))
	    Quit:RepID=""
	    Quit:return=1
	    
	    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	    Continue:'$IsObject(objRep)
	  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Set EpdDesc=objRep.MEPDICDDR.MIFDisease
		Set EpdID=objRep.MEPDICDDR.%Id()
		Continue:(EpdID'="")&&(EpdDiagnos'=EpdID)
		Set return=1
    }
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-02-26
/// Description:  传染病筛查患者上报同大类传染病列表
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       筛查ID
/// Return：      传染病报告列表
/// w ##class(DHCMed.EPDService.SuspCasesXSrv).GetReportByCasesX(43)
ClassMethod GetReportByCasesX(aCasesXID As %String) As %String
{
	new (aCasesXID)
	Set return=""
	Quit:(aCasesXID="") return
		
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
    Set EpisodeID=objCasesX.CXEpisodeID
    Set PatientID = $p(^PAADM(EpisodeID),"^",1)
    Quit:'$d( ^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID)) return  //无报告退出
    Set ActDiagnos=objCasesX.CXActDiagnos
    Set InfDicDr=$o(^DHCMed.EPD.SuspInfectDicI("IdxofDesc",ActDiagnos,0))
    Quit:InfDicDr="" return
    
	Set objPatient=##Class(DHCMed.Base.Patient).GetObjById(PatientID)
	Set PapmiNo=objPatient.PapmiNo
	
    Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(InfDicDr)
	Quit:'$Isobject(objDic) return
	
    Set (KindID,Kind)=""
    If $Isobject(objDic.BTKindDr){
	    Set KindID = objDic.BTKindDr.%Id()
	    Set Kind = objDic.BTKindDr.Description
    } 
  
    Set RepLists="" 
    Set xInfDr=""
    For {
	    Set xInfDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfDr))
	    Quit:xInfDr=""
	   
	    Set objInf = ##class(DHCMed.EPD.Infection).GetObjById(xInfDr)
	    Continue:'$IsObject(objInf)
	    Set RepKind=objInf.MIFKind        //诊断分类
	    Set RepKindID=""
	    Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKind,"")
		If $IsObject(objRepKind){
			Set RepKindID=objRepKind.%Id()
		}
		Continue:(KindID'="")&&(KindID'=RepKindID)

	    Set xRepID=""
	    For {
		    Set xRepID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfDr,xRepID))
		    Quit:xRepID=""
	    
		    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		    Continue:'$IsObject(objRep)
		  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
			Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
			Continue:objRep.MEPDStatus="7"  //删除状态报告无效
			Continue:'$IsObject(objRep.MEPDICDDR)
			Set RepStatusDesc=""
			Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",objRep.MEPDStatus,"")
			If $IsObject(objRepStatus){
				Set RepStatusDesc=objRepStatus.Description
			}
	
			Set RepDisease=objRep.MEPDICDDR.MIFDisease
		    Set RepDate=objRep.MEPDRepDate
		    Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
            
            Set RepLoc=objRep.MEPDLocDR                     //报告科室
			Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
			If $IsObject(objRepLoc){
				Set RepLoc=objRepLoc.Descs
			}
		    
		    Set RepLists=RepLists_","_xRepID_" "_RepDisease_" "_RepStatusDesc_" "_RepDate_" "_RepLoc
	    } 
    }
    
	Set:RepLists'="" RepLists=$e(RepLists,2,$l(RepLists))
	Set return=RepLists
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-02-27
/// Description:  判断患者是否上报某大类传染病
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aEpisodeID
///               aInfDicID
/// Return：      传染病报告列表
/// w ##class(DHCMed.EPDService.SuspCasesXSrv).GetIsReportEpd("59","1")
ClassMethod GetIsReportEpd(aEpisodeID As %String, aInfDicID As %String) As %String
{
	new (aEpisodeID,aInfDicID)
	Set return=0
	Quit:((aEpisodeID="")||(aInfDicID="")) return
		
    Set PatientID = $p(^PAADM(aEpisodeID),"^",1)
    Quit:'$d( ^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID)) return  //无报告退出
   
    Set objDic = ##class(DHCMed.EPD.SuspInfectDic).GetObjById(aInfDicID)
	Quit:'$Isobject(objDic) return
	
    Set (KindID,Kind)=""
    If $Isobject(objDic.BTKindDr){
	    Set KindID = objDic.BTKindDr.%Id()
	    Set Kind = objDic.BTKindDr.Description
    } 
   
    Set IsRep=0
    Set xInfDr=""
    For {
	    Set xInfDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfDr))
	    Quit:xInfDr=""
	    Continue:IsRep=1
	    
	    Set objInf = ##class(DHCMed.EPD.Infection).GetObjById(xInfDr)
	    Continue:'$IsObject(objInf)
	    Set RepKind=objInf.MIFKind        //诊断分类
	    Set RepKindID=""
	    Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKind,"")
		If $IsObject(objRepKind){
			Set RepKindID=objRepKind.%Id()
		}
	
		Continue:(KindID'="")&&(KindID'=RepKindID)

	    Set xRepID=""
	    For {
		    Set xRepID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfDr,xRepID))
		    Quit:xRepID=""
	        Continue:IsRep=1
	       
		    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		    Continue:'$IsObject(objRep)
		  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
			Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
			Continue:objRep.MEPDStatus="7"  //删除状态报告无效
			Continue:'$IsObject(objRep.MEPDICDDR)
		
		    Set IsRep=1
	    } 
    }
	Set return=IsRep
	
	Quit return
}

/// Creator：     luotiantian
/// CreatDate：   2020-06-19
/// Description:  处理传染病筛查复诊、携带、网报、备注列
/// Table：       DHCMed.EPD.CasesX
/// Input：       就诊号\字段ID\数据\备注\
/// Return：      返回ID
/// w ##class(DHCMed.EPDService.SuspCasesXSrv).ProcCasesEdit("17","1","A")
ClassMethod ProcCasesEdit(aCasesXID As %String, aTypeId As %String, aTypeDesc As %String, aRemark As %String = "")
{
	new (aCasesXID,aTypeId,aTypeDesc,aRemark)
	Set return=0
	Quit:(aCasesXID="") return
	
	Set objCasesX=##class(DHCMed.EPD.CasesX).%OpenId(aCasesXID)
	Quit:'$IsObject(objCasesX) return 
	
	If (aTypeId=1){
		set objCasesX.CXIsReVis=aTypeDesc
	}
	If (aTypeId=2){
		set objCasesX.CXIsCarry=aTypeDesc
	}
	If (aTypeId=3){
		set objCasesX.CXIsDecla=aTypeDesc
	} 
	If (aTypeId=4){
		set objCasesX.CXRemark=aRemark
	}
		
	set sc=objCasesX.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=objCasesX.%Id()
	}
	
	do objCasesX.%Close()
	Quit return
}

}
