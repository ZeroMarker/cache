Class DHCMed.EPDService.EpidemicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildQryEpidemic(objRep) As %List
{
	New (objRep,%session)
	Set return=""
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set ReportID=objRep.%Id()                       //报告ID
	Set PatientID=objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID=objRep.MEPDText1                  //EpisodeID
	Set MrAdm	= $p(^PAADM(+EpisodeID),"^",61)		//就诊病例ID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		//统一调用年龄计算方法
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
		//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
   
		Set PersonalID=objPatient.PersonalID        //身份证号
	}
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set DiseaseDr = objRep.MEPDICDDR.%Id()
	If $IsObject(objRep.MEPDICDDR){
		Set RepICD=objRep.MEPDICDDR.MIFICD			//ICD
		Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称
		Set:RepDisease'="" RepDisease = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.EPD.Infection","MIFDisease",Languages,RepDisease)
		Set RepKind=objRep.MEPDICDDR.MIFKind        //病例分类
		Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKind,"")
		If $IsObject(objRepKind){
			Set RepKind=objRepKind.Description
		}
		Set RepRank=objRep.MEPDICDDR.MIFRank        //传染病类别(甲、乙、丙)
		Set objRepRank=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicRank",RepRank,"")
		If $IsObject(objRepRank){
			Set RepRank=objRepRank.Description
		}
		Set MREPDDiag=..GetMREpdDiagnose(EpisodeID,ReportID) //取报告相关临床传染病诊断
		Set:MREPDDiag="" MREPDDiag=RepDisease
		Set MIFAppendix = objRep.MEPDICDDR.MIFAppendix	 // 取附卡内容
	}
	Set RepLoc=objRep.MEPDLocDR                     //报告科室
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
		Set:RepLoc'="" RepLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,RepLoc)
	}
	Set RepPlace=objRep.MEPDRepPlace                //上报位置
	Set objRepPlace=##class(DHCMed.SS.Dictionary).GetByTypeCode("REPPLACE",RepPlace,"")
	If $IsObject(objRepPlace){
		Set RepPlace=objRepPlace.Description
		Set RepPlace = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACAdmCategory","ADMCATDesc",Languages,RepPlace)
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
		Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserName)	
	}
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	//Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set:RepStatusDesc'="" RepStatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,RepStatusDesc)
		Set RepStatusCode=objRepStatus.Code
	}
	Set RepIsUpload=$s(objRep.MEPDIsUpload="Y":"已上报",1:"未上报")  //是否上报CDC
	Set CheckDate=objRep.MEPDCheckDate              //审核日期
	//Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=objRep.MEPDCheckTime              //审核时间
	Set:CheckTime'="" CheckTime=$zt(CheckTime,2)
	Set CheckUser=objRep.MEPDCheckUsrDR                 //审核人
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	If (RepStatusDesc'="已审")&&(RepStatusDesc'="被订"){
		Set CheckDate=""
		Set CheckTime=""
		Set CheckUserCode=""
		Set CheckUserName=""
	}
	Set FamName=objRep.MEPDFamName                  //家长姓名
	Set Occupation=objRep.MEPDOccupation            //职业
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetByTypeCode("Career",Occupation,"")
	If $IsObject(objOccupation){
		Set Occupation=objOccupation.Description
	}
	Set Company=objRep.MEPDCompany                  //工作单位
	Set TelPhone=objRep.MEPDTelPhone                //联系电话
	Set Address=objRep.MEPDAddress                  //现住址
	Set IDAddress=objRep.MEPDIDAddress              //户籍地址
	Set SickDate=objRep.MEPDSickDate                //发病日期
	//Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	//Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
	Set DeathDate=objRep.MEPDDeathDate              //死亡日期
	//Set:DeathDate'="" DeathDate=$zd(DeathDate,3)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	
	//通过计算得到卡片编号
	Set RepNo=objRep.MEPDText2
	
	//退卡原因或删除原因
	Set DelReason=objRep.MEPDDelReason
	//Set:($g(RepStatusCode)'="9")&&($g(RepStatusCode)'["0") DelReason=""
	
	//备注
	Set DemoInfo=objRep.MEPDDemo
	//有效证件类型
	Set CardType=objRep.MEPDText4
	Set objCardType=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
	If $IsObject(objCardType){
		Set CardType=objCardType.Description
	}
	//有效证件号
	Set CardNo=objRep.MEPDText5
	//add 20200203 
    Set Severity=objRep.MEPDSeverity                     //临床严重程度
	Set SeverityDesc=""
	Set objSeverity=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSeverity",Severity,"")
	If $IsObject(objSeverity) {
		Set SeverityDesc=objSeverity.Description
	}
	Set MepdDR=objRep.MEPDMepdDR         //被订正报告
	//历史上报信息
	Set HistoryRep="",DiagnosList=""
	Set InfectionDr=""
	For {
		Set InfectionDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr))
		Quit:InfectionDr=""
		
		Set xHisRepID=""
		For {
			Set xHisRepID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr,xHisRepID))
			Quit:xHisRepID=""
			
			Continue:xHisRepID=ReportID //不包括 本条报卡记录
			Set objHisRep=##class(DHCMed.EPD.Epidemic).GetObjById(xHisRepID)
			Continue:'$IsObject(objHisRep)
			Continue:objHisRep.MEPDStatus="4"  //被订状态报告无效
			Continue:objHisRep.MEPDStatus="6"  //草稿状态报告无效
			Continue:objHisRep.MEPDStatus="7"  //删除状态报告无效
			Continue:'$IsObject(objHisRep.MEPDICDDR)
			
			Set Diagnos=objHisRep.MEPDICDDR.MIFDisease		//传染病诊断大类DHCMed.EPD.Infection中MIFKind属性值
			Continue:Diagnos=""
			set IsActive=objHisRep.MEPDICDDR.MIFIsActive
			Continue:IsActive'="Y"
			
			Set MIFKind=""
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",objHisRep.MEPDICDDR.MIFKind,"")
			Set:$IsObject(objDic) MIFKind=objDic.Description
			Set:MIFKind="AFP" Diagnos=Diagnos_"(AFP)"
			
			Continue:$listfind(DiagnosList,Diagnos)>0   //重复报卡过滤
			Set DiagnosList=DiagnosList_$lb(Diagnos)
			Set HistoryRep=HistoryRep_","_Diagnos
		}
	}
	Set:HistoryRep'="" HistoryRep=$e(HistoryRep,2,$l(HistoryRep))
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
    If (DischDate'="")&&(DischTime'="") {
	    Set DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	    Set DischTime=$zt(DischTime,1)
    }else{
	    Set DischDate=""
	    Set DischTime=""
	}
	Set return=return_$lb($g(ReportID))                 //报告ID
	Set return=return_$lb($g(PatientID))                //PatientID
	Set return=return_$lb($g(PapmiNo))                  //登记号
	Set return=return_$lb($g(PatientName))              //姓名
	Set return=return_$lb($g(PatientSex))               //性别
	Set return=return_$lb($g(PatientAge))               //年龄
	Set return=return_$lb($g(RepICD))                   //疾病ICD
	Set return=return_$lb($g(RepDisease))               //疾病名称
	Set return=return_$lb($g(RepLoc))                   //报告科室
	Set return=return_$lb($g(RepPlace))                 //上报位置
	Set return=return_$lb($g(RepUserCode))              //报告人工号
	Set return=return_$lb($g(RepUserName))              //报告人
	Set return=return_$lb($g(RepDate))                  //报告日期
	Set return=return_$lb($g(RepTime))                  //报告时间
	Set return=return_$lb($g(RepStatusDesc))            //报告状态
	Set return=return_$lb($g(EpisodeID))                //EpisodeID
	Set return=return_$lb($g(RepIsUpload))              //是否上报CDC
	Set return=return_$lb($g(RepStatusCode))            //报告状态代码
	
	Set return=return_$lb($g(CheckUserCode))            //审核人工号
	Set return=return_$lb($g(CheckUserName))            //审核人
	Set return=return_$lb($g(CheckDate))                //审核日期
	Set return=return_$lb($g(CheckTime))                //审核时间
	Set return=return_$lb($g(RepKind))                  //传染病类别
	Set return=return_$lb($g(RepRank))                  //传染病级别
	Set return=return_$lb($g(FamName))                  //家属姓名
	Set return=return_$lb($g(Occupation))               //职业
	Set return=return_$lb($g(Company))                  //工作单位
	Set return=return_$lb($g(Address))                  //现住址
	Set return=return_$lb($g(IDAddress))                //户籍地址
	Set return=return_$lb($g(TelPhone))                 //联系电话
	Set return=return_$lb($g(SickDate))                 //发病日期
	Set return=return_$lb($g(DiagDate))                 //诊断日期
	Set return=return_$lb($g(DeathDate))                //死亡日期
	Set return=return_$lb($g(RepNo))                    //卡片编号
	Set return=return_$lb($g(PersonalID))               //身份证号
	Set return=return_$lb($g(DelReason))                //退回或删除原因
	Set return=return_$lb($g(DemoInfo))                 //备注
	Set return=return_$lb($g(EncryptLevel))             //病人密级
	Set return=return_$lb($g(PatLevel))                 //病人级别
	Set return=return_$lb($g(HistoryRep))               //历史上报
	Set return=return_$lb($g(MREPDDiag))                //HIS传染病诊断
	Set return=return_$lb($g(CardType))                 //有效证件类型
	Set return=return_$lb($g(CardNo))                   //有效证件号
	Set return=return_$lb($g(DiseaseDr))                //传染病诊断ID
	Set return=return_$lb($g(SeverityDesc))             //临床严重程度
	Set return=return_$lb($g(MepdDR))                   //被订报告
	Set return=return_$lb($g(MrAdm))                    //病例ID
	Set return=return_$lb($g(MIFAppendix))              //附卡ID
	Set return=return_$lb($g(DischDate))              	//出院日期
	Set return=return_$lb($g(DischTime))              	//出院时间
	Quit return
}

///  Creator：     李阳
///  CreatDate：   2010-04-07
///  Description:  通过上报日期查询传染病报告
///  Table：       DHCMed.EPD.Epidemic
///  Input：       FromDate：开始上报日期 ToDate：结束上报日期 Loc：科室 Status：状态 RepPlace：报告位置 Hospital：院区 上报CDC状态：UploadStatus 疾病类别：MIFKind
///  d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicSrv","QueryEpdRepByDate","2011-01-01","2011-12-31","","*1*2*3*","ALL","3","N","")
Query QueryEpdRepByDate(FromDate As %String, ToDate As %String, Loc As %String, Status As %String, RepPlace As %String, Hospital As %String, UploadStatus As %String, MIFKind As %String, aRegNo As %String = "", aPatName As %String = "", aIsInHosp As %String = "") As %Query(ROWSPEC = "RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,DiseaseICD:%String:ICD,DiseaseName:%String:疾病名称,ReportDep:%String:上报科室,RepPlace:%String:上报位置,RepUserCode:%String:上报人工号,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,IsUpload:%String:是否上报CDC,StatusCode:%String,CheckUserCode:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepKind:%String:传染病类别,RepRank:%String:传染病级别,FamName:%String,Occupation:%String,Company:%String,Address:%String,IDAddress:%String,TelPhone:%String,SickDate:%String,DiagDate:%String,DeathDate:%String,RepNo:%String,PersonalID:%String,DelReason:%String,DemoInfo:%String,EncryptLevel:%String,PatLevel:%String,HistoryRep:%String,MREPDDiag:%String,CardType:%String,CardNo:%String,DiseaseDr:%String,SeverityDesc:%String,MepdDR:%String,MrAdm:%String,MIFAppendix:%String,DischDate:%String,DischTime:%String,HIVRepID:%String,OldRepFlag:%String,DiagDateTime:%String,IsPrint:%String")
{
}

ClassMethod QueryEpdRepByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Loc As %String, Status As %String, RepPlace As %String, Hospital As %String, UploadStatus As %String, MIFKind As %String, aRegNo As %String = "", aPatName As %String = "", aIsInHosp As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	// add ByChenRui 20220-10-13 传染病报告增加是否在院条件 优先级高
	// 查询所有当前在院的住院患者，并有传染病报告的，找到疾病的重复报告时限，超过时限则不计入
	if (aIsInHosp=1){
		Set xPACWardID=0
		For {
			Set xPACWardID=$o(^PAADMi("CurrWard",xPACWardID))
			Quit:xPACWardID=""
			Set xRoom=""
			For {
				Set xRoom=$o(^PAADMi("CurrWard",xPACWardID,xRoom))
				Quit:xRoom=""
				Set xPaadm=0
				For {
					Set xPaadm=$o(^PAADMi("CurrWard",xPACWardID,xRoom,xPaadm))
					Quit:xPaadm=""
					Set AdmInfo=$g(^PAADM(xPaadm))
					Set PatientID=$p(AdmInfo,"^",1) 
					Continue:($p(AdmInfo,"^",2)'="I") // 过滤非住院的患者
					Set xRepID=""
					for {
						Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",xPaadm,xRepID))
						Quit:xRepID=""
						Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
						Continue:'$IsObject(objRep)
						Set aMEPDICDDr = objRep.MEPDICDDR.%Id()
						Set IsOverTime = ..GetIsOverTime(xRepID,aMEPDICDDr)
						Continue:(IsOverTime=1)
						Set tmpData=..BuildQryEpidemic(objRep)
						Set HIVRepID=""
						Set objHIVRep=##class(DHCMed.EPD.CaseFollow).GetObjByPatId(objRep.MEPDPapmiDR)
						If $IsObject(objHIVRep){
							Set HIVRepID=objHIVRep.%Id()
						}
						Set DiagDateTime=$$GetDiagDateTime(objRep)
						Set IsPrint=##class(DHCMed.EPDService.EpidemicSrv).IsPrintByEpidemicLog(xRepID,"","")
						Set ^CacheTemp(repid,ind)=tmpData_$lb(HIVRepID,"",DiagDateTime,IsPrint)
						Set ind=ind+1
					}
				}
			}
		}
		Quit $$$OK
	}
	
	if ((aRegNo'="")||(aPatName'="")){
		Set xEpisodeID=""
		for {
			Set xEpisodeID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",xEpisodeID))
			Quit:xEpisodeID=""
			Set AdmStr=$g(^PAADM(xEpisodeID))
			Set PatientID=$p(AdmStr,"^",1) 
			Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
			Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
			//通过姓名和登记号
			continue:((aPatName="")||(PatientName'[aPatName))&&((aRegNo="")||(PapmiNo'[aRegNo))
			
			Set xRepID=""
			for {
				Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",xEpisodeID,xRepID))
				Quit:xRepID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				
				Set tmpData=..BuildQryEpidemic(objRep)
				Set HIVRepID=""
				Set objHIVRep=##class(DHCMed.EPD.CaseFollow).GetObjByPatId(objRep.MEPDPapmiDR)
				If $IsObject(objHIVRep){
					Set HIVRepID=objHIVRep.%Id()
				}
				Set DiagDateTime=$$GetDiagDateTime(objRep)
				Set IsPrint=##class(DHCMed.EPDService.EpidemicSrv).IsPrintByEpidemicLog(xRepID,"","")
				Set ^CacheTemp(repid,ind)=tmpData_$lb(HIVRepID,"",DiagDateTime,IsPrint)
				Set ind=ind+1
			}	
		}
		Quit $$$OK
	}

	Set FromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FromDate)
	Set ToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ToDate)
	Set:FromDate'="" FromDate=+FromDate
	Set:ToDate'="" ToDate=+ToDate
	Quit:((FromDate="")||(ToDate="")) $$$OK
	
	//Set UserHospitalID=Hospital
	For tmpDate=FromDate:1:ToDate {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""
			Continue:((Loc'="")&&(tmpLoc'=Loc))
			//Set tmpHospitalID=$p($g(^CTLOC(tmpLoc)),"^",22)
			//Continue:((tmpHospitalID'=UserHospitalID)&&(UserHospitalID'=""))
			if Hospital'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,Hospital)
				continue:flg<1
			}
			
			Set RepRowID=""
			For {
				Set RepRowID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,RepRowID))
				Quit:RepRowID=""
				
				set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepRowID)
				Continue:'$IsObject(objRep)
				
				Set rRepStatus=objRep.MEPDStatus
				Continue:((Status'="")&&(Status'[("*"_rRepStatus_"*")))
				
				Set rRepUpload=objRep.MEPDIsUpload
				Set:UploadStatus="ALL" UploadStatus=""
				Continue:((UploadStatus'="")&&(UploadStatus'=rRepUpload))
				
				Set rRepPlace=objRep.MEPDRepPlace
				Set:RepPlace="ALL" RepPlace=""
				Continue:((RepPlace'="")&&(RepPlace'=rRepPlace))
				
				If $IsObject(objRep.MEPDICDDR) {
					Set RepKindValue=objRep.MEPDICDDR.MIFKind	//病例分类
					Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKindValue,"")
					If $IsObject(objRepKind){
						Set RepKind=objRepKind.Code
						Continue:((MIFKind'="")&&(MIFKind'=RepKind))
					}
				}
				//Add By LiYang 2014-08-08 FixBug：1430 医政管理-传染病管理系统-传染病报告查询-在【疾病类别】中选择任意疾病，查询的结果总是包含【疾病名称】为空的报告
				Continue:(($IsObject(objRep.MEPDICDDR)=0)&&(RepKind'=""))
				
				Set tmpData=..BuildQryEpidemic(objRep)
				Set HIVRepID=""
				Set objHIVRep=##class(DHCMed.EPD.CaseFollow).GetObjByPatId(objRep.MEPDPapmiDR)
				If $IsObject(objHIVRep){
					Set HIVRepID=objHIVRep.%Id()
				}
				Set DiagDateTime=$$GetDiagDateTime(objRep)
				Set IsPrint=##class(DHCMed.EPDService.EpidemicSrv).IsPrintByEpidemicLog(RepRowID,"","")
				Set ^CacheTemp(repid,ind)=tmpData_$lb(HIVRepID,"",DiagDateTime,IsPrint)
				Set ind=ind+1
			}
		}
	}
	
	Set xDate=""
	For xDate=FromDate:1:ToDate {
 		Set RowID=""
 		For {
	 		Set RowID=$o(^MA.EPD.ImportReportI("IndexRepDate",xDate,RowID))
	 		Quit:RowID=""
			Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(RowID)
			Continue:'$IsObject(objRep)
			
		    Set ReportID    = objRep.ReportID   
			Set RepCardNo   = objRep.RepCardNo  
			Set RegNo       = objRep.RegNo      
			Set EPDName     = objRep.EPDName    
			Set Birthday    = objRep.Birthday 
			Set:Birthday'="" Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(Birthday)  
			Set Sex         = objRep.Sex        
			Set CardType    = objRep.CardType   
			Set PersonalID  = objRep.PersonalID 
			Set TelPhone    = objRep.TelPhone   
			Set CurAddress  = objRep.CurAddress 
			Set FamName     = objRep.FamName    
			Set Occupation  = objRep.Occupation 
			Set Company     = objRep.Company    
			Set Area        = objRep.Area       
			Set DiseaseName = objRep.DiseaseName
			Set DiseaseKind = objRep.DiseaseKind
			Set DiseaseRank = objRep.DiseaseRank
			Set SickDate = objRep.EPDSickDate
			Set:SickDate'="" SickDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SickDate)  
			Set DiagDate = objRep.EPDDiagDate
			Set:DiagDate'="" DiagDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DiagDate)  
			Set DiagDegree  = objRep.DiagDegree 
			Set DeathDate   = objRep.DeathDate 
			Set:DeathDate'="" DeathDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DeathDate)   
			Set Severity    = objRep.Severity   
			Set IsInEPD     = objRep.IsInEPD    
			Set EnterUser   = objRep.EnterUser  
			Set ReportLoc   = objRep.ReportLoc  
			Set EnterDate   = objRep.EnterDate
			Set:EnterDate'="" EnterDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EnterDate)    
			Set EnterTime   = objRep.EnterTime 
			Set:EnterTime'="" EnterTime=$zt(EnterTime,2)
			Set EPDStatus   = objRep.EPDStatus 
			
			Set ^CacheTemp(repid,ind)=$lb(ReportID,"",RegNo,EPDName,Sex,"","",DiseaseName,ReportLoc,"","",EnterUser,EnterDate,EnterTime,EPDStatus,"","",StatusCode,"","","","",DiseaseKind,DiseaseRank,FamName,Occupation,Company,CurAddress,"",TelPhone,SickDate,DiagDate,DeathDate,RepCardNo,PersonalID,"","","","","","",CardType,PersonalID,"",SeverityDesc,"","","1","","")
			Set ind=ind+1
		}
	}
	Quit $$$OK
GetDiagDateTime(objRep)
	set DiagDateTime=objRep.MEPDDiagDateTime
	if DiagDateTime="" {
		set DiagDate=objRep.MEPDSickDate
		Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
		set:DiagDate'="" DiagDateTime=DiagDate_" 00:00"
	}
	Quit DiagDateTime
}

ClassMethod QueryEpdRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEpdRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEpdRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEpdRepByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIsOverTime(aRepID As %String, aMEPDICDDr As %String) As %String
{
	new (aMEPDICDDr,aRepID)
	Set return = ""
	Quit:((aRepID="")||(aMEPDICDDr="")) return
	Set InfectInfo = $g(^DHCMed.EPDC("IF",aMEPDICDDr))
	Quit:InfectInfo="" return
	Set LimitDate = $p(InfectInfo,"^",8)
	Set EPDInfo = $g(^DHCMed.EPD("EPD",aRepID))
	Quit:EPDInfo="" return
	Set TRepDate =  $p(EPDInfo,"^",17)
	Set NowDate	 = +$h
	if ((TRepDate+LimitDate)<NowDate){
		Set return = 1
	}
	quit return
}

ClassMethod SaveEpidemicReport(ReportStr, ReportSubStr)
{
	TStart
	//保存日志
	Set LogID=##class(DHCMed.EPD.EpidemicLog).SaveEPDEditLog(ReportStr, ReportSubStr)
	s reportID=##class(DHCMed.EPD.Epidemic).Update(ReportStr,$c(1))
	if (reportID<0)
	{
		TRollback
		quit -1
	}
	//保存日志(新建报告时无报告ID)
	If $p(ReportStr,$c(1),1)="" {		;MEPD_Rowid
		 Set $p(ReportStr,$c(1),1)=reportID
		 Set LogID=##class(DHCMed.EPD.EpidemicLog).SaveEPDEditLog(ReportStr, ReportSubStr)
	}
	
	s ret=##class(DHCMed.EPD.EpidemicSub).DeleteEpidemicSub(reportID)
	
	set intCounter=0
	set failFlag=0
	for intCounter=1:1:$l(ReportSubStr,$c(2)) {
		set tmp=$p(ReportSubStr,$c(2),intCounter)
		continue:tmp=""
		set $p(tmp,$c(1),1)=reportID
		set subRowid=##class(DHCMed.EPD.EpidemicSub).Update(tmp,$c(1))
		if (subRowid<0)	
		{
			set failFlag=1
		}
		quit:failFlag=1
	} 
	if failFlag=1
	{
		TRollback
	} 
	quit:failFlag=1 subRowid
	
	TCommit
	quit reportID
}

/// 通过病人ID查询传染病报告
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicSrv","QryByPapmi",112582)
Query QryByPapmi(aEpisodeID As %String) As %Query(ROWSPEC = "RowID:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:姓别,Age:%String:年龄,DiseaseICD:%String:ICD,DiseaseName:%String:疾病名称,ReportDep:%String:上报科室,RepPlace:%String:上报位置,RepUserCode:%String:上报人工号,RepUserName:%String:上报人姓名,RepDate:%String:上报日期,RepTime:%String:上报时间,Status:%String:状态,Paadm:%String,IsUpload:%String:是否上报CDC,StatusCode:%String,CheckUserCode:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepKind:%String:传染病类别,RepRank:%String:传染病级别,FamName:%String,Occupation:%String,Company:%String,Address:%String,IDAddress:%String,TelPhone:%String,SickDate:%String,DiagDate:%String,DeathDate:%String,RepNo:%String,PersonalID:%String,DelReason:%String,DemoInfo:%String,EncryptLevel:%String,PatLevel:%String,HistoryRep:%String,MREPDDiag:%String,CardType:%String,CardNo:%String,DiseaseDr:%String,SeverityDesc:%String,MepdDR:%String,MIFAppendix:%String,HIVRepID:%String,OldRepFlag:%String,IsCASign:%String")
{
}

ClassMethod QryByPapmiExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set PatientID = $p($g(^PAADM(+aEpisodeID)),"^",1)
	Set InfectionDr=""
	For {
		Set InfectionDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr))
		Quit:InfectionDr=""
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr,RowID))
			Quit:RowID=""
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RowID)
			Continue:'$IsObject(objRep)
			// 传染病报卡过滤非本就诊院区报告的数据
			Set EpdPopupIsCurrAdmHosp = +##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpdPopupIsCurrAdmHosp","")	
			if (EpdPopupIsCurrAdmHosp="1"){
				Set ThisPaadm = objRep.MEPDText1				// 该份报告的就诊号
				Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
				Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)		// 此次就诊号的院区ID
				Set LastAdmLoc=+$p($g(^PAADM(+ThisPaadm)),"^",4)
				Set LastHospID=+$p($g(^CTLOC(+LastAdmLoc)),"^",22)	// 该份报告就诊号的院区ID
				Continue:HospID'=LastHospID
			}
			
			Set Data=..BuildQryEpidemic(objRep)
			Set HIVRepID=""
			Set objHIVRep=##class(DHCMed.EPD.CaseFollow).GetObjByPatId(PatientID)
			If $IsObject(objHIVRep){
				Set HIVRepID=objHIVRep.%Id()
			}
			Set OldRepFlag=0
			Set IsCASign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("EPD","EPD",RowID,"S")	//是否CA认证
			
			Set ^CacheTemp(repid,ind)=Data_$lb(HIVRepID)_$lb(OldRepFlag)_$lb(IsCASign)
			Set ind=ind+1
		}			
	}
	
	//查询从老系统中导入的数据
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 姓名
	Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
	Quit:IdentityCode="" $$$OK
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期
	Set xRowID=""
	For {
   		Set xRowID=$o(^MA.EPD.ImportReportI("IndexPersonId"," "_$ZCVT(PatName,"U"),Birthday," "_$ZCVT(IdentityCode,"U"),xRowID))
   		Quit:xRowID=""
   		
   		Set objRep = ##class(DHCMed.EPD.ImportReport).GetObjById(xRowID)
		Continue:'$IsObject(objRep)
			
	    Set ReportID    = objRep.ReportID   
		Set RepCardNo   = objRep.RepCardNo  
		Set RegNo       = objRep.RegNo      
		//Set:Birthday'="" Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(Birthday)  
		Set Sex         = objRep.Sex        
		Set CardType    = objRep.CardType   
		Set PersonalID  = objRep.PersonalID 
		Set TelPhone    = objRep.TelPhone   
		Set CurAddress  = objRep.CurAddress 
		Set FamName     = objRep.FamName    
		Set Occupation  = objRep.Occupation 
		Set Company     = objRep.Company    
		Set Area        = objRep.Area       
		Set DiseaseName = objRep.DiseaseName
		Set DiseaseKind = objRep.DiseaseKind
		Set DiseaseRank = objRep.DiseaseRank
		Set SickDate = objRep.EPDSickDate
		Set:SickDate'="" SickDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(SickDate)  
		Set DiagDate = objRep.EPDDiagDate
		Set:DiagDate'="" DiagDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DiagDate)  
		Set DiagDegree  = objRep.DiagDegree 
		Set DeathDate   = objRep.DeathDate 
		Set:DeathDate'="" DeathDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DeathDate)   
		Set Severity    = objRep.Severity   
		Set IsInEPD     = objRep.IsInEPD    
		Set EnterUser   = objRep.EnterUser  
		Set ReportLoc   = objRep.ReportLoc  
		Set EnterDate   = objRep.EnterDate
		Set:EnterDate'="" EnterDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(EnterDate)    
		Set EnterTime   = objRep.EnterTime 
		Set:EnterTime'="" EnterTime=$zt(EnterTime,1)
		Set EPDStatus   = objRep.EPDStatus
		Set OldRepFlag	= 1
		Set IsCASign	= 0	//是否CA认证
		
		Set ^CacheTemp(repid,ind)=$lb(ReportID,"",RegNo,PatName,Sex,Age,"",DiseaseName,ReportLoc,"","",EnterUser,EnterDate,EnterTime,EPDStatus,"","",StatusCode,"","","","",DiseaseKind,DiseaseRank,FamName,Occupation,Company,CurAddress,"",TelPhone,SickDate,DiagDate,DeathDate,RepCardNo,PersonalID,"","","","","","",CardType,PersonalID,"",SeverityDesc,"","",OldRepFlag,IsCASign)
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryByPapmiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPapmiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryByPapmiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPapmiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Create Date:2011-07-21
/// Description：为导出数据组织数据
///  Input：       FromDate：开始上报日期 ToDate：结束上报日期 Loc：科室 Status：状态 RepPlace：报告位置
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicSrv","QueryForExport","2008-5-1","2011-12-31","","","1","")
Query QueryForExport(FromDate As %String, ToDate As %String, Loc As %String, Status As %String, RepPlace As %String, Hospital As %String, UploadStatus As %String) As %Query(ROWSPEC = "RegNo:%String:卡片编号,PatientName:%String:患者姓名,RepDep:%String:填卡科室,Status:%String:卡片状态,Sex:%String:性别名称,Birthday:%String:出生日期,RelTel:%String:联系电话,PersonalID:%String:身份证号,Company:%String:工作单位,Address:%String:详细现住地址,DiseaseDate:%String:发病日期,DiagnoseDate:%String:诊断日期,DiagnoseType:%String:诊断类型名称,ResumeText:%String:备注,RepDate:%String:医生填卡日期,RepDoctor:%String:填卡医生,DiseaseType:%String:疾病病种名称,Occupation:%String:职业名称,ReturnReason:%String:退卡原因,RepDoctor1:%String:填卡医生姓名,RepDoctorCode:%String:医生工号")
{
}

ClassMethod QueryForExportExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Loc As %String, Status As %String, RepPlace As %String, Hospital As %String, UploadStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set FromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(FromDate)
	Set ToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ToDate)

	Quit:((FromDate="")||(ToDate="")) $$$OK
	
	Set UserHospitalID=Hospital
	For tmpDate=FromDate:1:ToDate {
		Set tmpLoc=""
		For {
			Set tmpLoc=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc))
			Quit:tmpLoc=""		
			Continue:((Loc'="") && (tmpLoc'=Loc))
			set objTmpLoc=##class(DHCMed.Base.Ctloc).GetObjById(tmpLoc)
			Do objTmpLoc.%Close()
			Set tmpHospitalID=objTmpLoc.HospitalDr
			Set objTmpLoc=""
			kill objTmpLoc
			//Continue:((tmpHospitalID'=UserHospitalID)&&(UserHospitalID'=""))
			if UserHospitalID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(tmpLoc,UserHospitalID)
				continue:flg<1
			}
			Set rowid=""	
			For {
				Set rowid=$o(^DHCMed.EPDi("EPD",0,"DateLoc",tmpDate,tmpLoc,rowid))
				Quit:rowid=""
				set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(rowid)
				Continue:$IsObject(objRep)=0
				d objRep.%Close()
				Continue:((Status'="")&&(Status'[("*"_objRep.MEPDStatus_"*")))
				Continue:((RepPlace'="")&&(objRep.MEPDRepPlace'=RepPlace))
				Continue:((UploadStatus'="")&&(objRep.MEPDIsUpload'=UploadStatus))
				Set tmpData=$$BuildForExport(objRep)
				Set ^CacheTemp(repid,ind)=tmpData
				Set ind=ind+1		
			}
		}
	}
	Quit $$$OK
	
BuildForExport(objRep)
	n (objRep)
	//获取病人信息
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objRep.MEPDPapmiDR)
	Do objPatient.%Close()
	
	//获取传染病字典信息
	Set objInfection=objRep.MEPDICDDR
	Set:$IsObject(objInfection)=0 objInfection=##class(DHCMed.EPD.Infection).%New()
	
	
	//获取科室信息
	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(objRep.MEPDLocDR)
	Set:$IsObject(objLoc)=0 objLoc=##class(DHCMed.Base.Ctloc).%New()
	Do objLoc.%Close()
	
	//获取用户信息
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objRep.MEPDRepUsrDR)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()
	
	//上报位置信息
	Set objRepPlace=##class(DHCMed.SS.Dictionary).GetByTypeCode("REPPLACE",objRep.MEPDRepPlace,1)
	Set:objRepPlace="" objRepPlace=##class(DHCMed.SS.Dictionary).%New()
	Do objRepPlace.%Close()
	
	//状态信息
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",objRep.MEPDStatus,1)
	Set:objStatus="" objStatus=##class(DHCMed.SS.Dictionary).%New()
	Do objStatus.%Close()
	
	//诊断等级
	Set objDiagnoseType=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICDIAGNOSEDEGREE",objRep.MEPDStatus,1)
	Set:objDiagnoseType="" objDiagnoseType=##class(DHCMed.SS.Dictionary).%New()
	Do objDiagnoseType.%Close()
	
	//职业
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetByTypeCode("CAREER",objRep.MEPDStatus,1)
	Set:objOccupation="" objOccupation=##class(DHCMed.SS.Dictionary).%New()
	Do objOccupation.%Close()	
	
	
	Set data=$lb("")
	Set $li(data,1)=..GetReportNo(objRep.%Id())    //RegNo:%String:卡片编号
	Set $li(data,2)=objPatient.PatientName //PatientName:%String:患者姓名
	Set $li(data,3)=objLoc.Descs //RepDep:%String:填卡科室
	Set $li(data,4)=objStatus.Description   //Status:%String:卡片状态
	Set $li(data,5)=objPatient.Sex     //Sex:%String:性别名称
	Set $li(data,6)=objPatient.Birthday  //Birthday:%String:出生日期
	Set $li(data,7)=objPatient.RelativeTelephone  // RelTel:%String:联系电话
	Set $li(data,8)=objPatient.PersonalID    //PersonalID:%String:身份证号
	Set $li(data,9)=objPatient.WorkAddress  // Company:%String:工作单位
	Set $li(data,10)=objPatient.Address   //Address:%String:详细现住地址
	Set $li(data,11)=$zd(objRep.MEPDSickDate,3)    //DiseaseDate:%String:发病日期
	Set $li(data,12)=$s(objRep.MEPDDiagDate="":"",1:$zd(objRep.MEPDDiagDate,3))   // DiagnoseDate:%String:诊断日期
	Set $li(data,13)=objDiagnoseType.Description // DiagnoseType:%String:诊断类型名称
	Set $li(data,14)=objRep.MEPDDemo   //ResumeText:%String:备注
	Set $li(data,15)=$zd(objRep.MEPDRepDate,3)  //RepDate:%String:医生填卡日期
	Set $li(data,16)=objUser.Name  //RepDoctor:%String:填卡医生
	Set $li(data,17)=objInfection.MIFDisease  //DiseaseType:%String:疾病病种名称
	Set $li(data,18)=objOccupation.Description   //Occupation:%String:职业名称
	Set $li(data,19)=objRep.MEPDDelReason //ReturnReason:%String:退卡原因
	Set $li(data,20)=objUser.Name  //RepDoctor1:%String:填卡医生姓名
	Set $li(data,21)=objUser.Code  //RepDoctorCode:%String:医生工号
	Quit data
}

ClassMethod QueryForExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryForExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryForExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryForExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取一份报告的编号（日期+顺序号）
/// w ##class(DHCMed.EPDService.EpidemicSrv).GetReportNo(13)
ClassMethod GetReportNo(EpdID)
{
	n (EpdID)
	Quit:EpdID="" ""
	Set objEpd=##class(DHCMed.EPD.Epidemic).GetObjById(EpdID)
	Quit:$IsObject(objEpd)=0 ""
	Do objEpd.%Close()
	Set repDate=objEpd.MEPDRepDate
	Set RowID=""
	Set num=0
	For {
		Set RowID=$o(^DHCMed.EPDi("EPD",0,"RepDate",repDate,RowID))
		Quit:RowID=""
		Set num=num+1
	}
	Set tmpDate=$zd(repDate,3)
	For {
		Quit:$l(num)>3
		Set num="0"_num
	}
	Set ret=$tr(tmpDate,"-","")_num
	Quit ret
}

/// 检查某个患者是否已经上报过传染病报告
/// EpisodeID:患者的Paadm
/// InfectionID:传染病字典ID
/// 返回值：如果未上报返回空字符串，否则返回已上报的ID列表，以"^"分割
/// w ##class(DHCMed.EPDService.EpidemicSrv).IsReported(54,124)
ClassMethod IsReported(EpisodeID, InfectionID)
{
	n (EpisodeID,InfectionID)
	Quit:((EpisodeID="")||(InfectionID="")) ""
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:$IsObject(objAdm)=0 ""
	Set PatientID=objAdm.PatientID
	Quit:PatientID="" ""
	Set RowID=""
	Set ret=""
	For {
		Set RowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionID,RowID))
		Quit:RowID=""
		Set objEpd=##class(DHCMed.EPD.Epidemic).GetObjById(RowID)
		Continue:$IsObject(objEpd)=0
		Do objEpd.%Close()
		Continue:objEpd.MEPDStatus'=2 //必须是 “已审” 状态
		Set:ret'="" ret=ret_"^"
		Set ret=ret_RowID
	}
	Quit ret
}

/// Creator：     mxp
/// CreatDate：   2017-07-10
/// Description:  取患者与传染病报告相关的传染病诊断（临床）
/// w ##class(DHCMed.EPDService.EpidemicSrv).GetMREpdDiagnose(9,6)
ClassMethod GetMREpdDiagnose(aEpisodeID As %String, aReportID As %String) As %String
{
	New (aEpisodeID,aReportID)
	Set return=""
	Quit:(aEpisodeID="")||(aReportID="") return
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.MEPDICDDR) return
	Quit:objRep.MEPDICDDR.MIFIsActive'="Y" return
	Set EPDICDDR=objRep.MEPDICDDR.%Id()
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(aEpisodeID)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set ICD10=objRec.ICD10
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		Set tmpICDDesc=ICDDesc
		Set:Comments'="" tmpICDDesc=tmpICDDesc_";"_Comments
		Set tmpICDDesc=$zcvt(tmpICDDesc,"U")
		Set tmpICDDesc=$tr(tmpICDDesc," ","")
		
		Set CtlEpdRstList=""
		Set xID=0
		For {
			Set xID=$o(^DHCMed.EPDC("IF",xID))
			Quit:xID=""
			Quit:$listfind(CtlEpdRstList,xID)>0
			Continue:(EPDICDDR'="")&&(xID'=EPDICDDR)
			
			Set IsActive=$p($g(^DHCMed.EPDC("IF",xID)),"^",12)
			Continue:IsActive'="Y"
			
			If ICD10'="" {
				//通过传染病诊断ICD判断
				Set IFICD=$p($g(^DHCMed.EPDC("IF",xID)),"^",1)
				Set IFICD=$zcvt(IFICD,"U"),IFICD=$tr(IFICD," ","")
				If ICD10=IFICD {
					Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
				}
				Continue:$listfind(CtlEpdRstList,xID)>0
				
				//通过传染病诊断ICD列表检索(别名表,类型为2)
				Set xAlias=0
				For {
					Set xAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias))
					Quit:xAlias=""
					Quit:$listfind(CtlEpdRstList,xID)>0
					
					Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",2)
					Continue:AliasType'=2
					Set IFICD=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",1)
					Set IFICD=$zcvt(IFICD,"U"),IFICD=$tr(IFICD," ","")
					If ICD10=IFICD {
						Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
					}
				}
				Continue:$listfind(CtlEpdRstList,xID)>0
			}
			
			If tmpICDDesc'="" {
				//通过传染病诊断关键字列表检索(别名表,类型为1)
				Set xAlias=0,flg=0
				For {
					Set xAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias))
					Quit:xAlias=""
					Quit:$listfind(CtlEpdRstList,xID)>0
					
					Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",2)
					Continue:AliasType'=1
					Set IFKey1=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",1)
					Set IFKey1=$zcvt(IFKey1,"U"),IFKey1=$tr(IFKey1," ","")
					Continue:IFKey1=""
					If tmpICDDesc[IFKey1 {
						Set yAlias=0,flg=0
						For {
							Set yAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias))
							Quit:yAlias=""
							Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias)),"^",2)
							Continue:AliasType'=3
							Set IFKey0=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias)),"^",1)
							Set IFKey0=$zcvt(IFKey0,"U"),IFKey0=$tr(IFKey0," ","")
							Continue:IFKey0=""
							Set:tmpICDDesc[IFKey0 flg=1
						}
						Continue:flg=1
						Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
					}
				}
				Continue:$listfind(CtlEpdRstList,xID)>0
			}
		}
		
		Set:$ll(CtlEpdRstList)>0 return=return_","_ICDDesc
	
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-08-31
/// Description:  修改获取传染病报告返回对象的方法
/// Table：       DHCMed.EPD.Epidemic
/// Input：       ID: DHCMed.EPD.Epidemic.ID
/// Return：      返回obj
/// W ##class(DHCMed.EPDService.EpidemicSrv).GetObjById("1")
ClassMethod GetObjById(ID As %String) As DHCMed.EPD.Epidemic
{
	New (ID)
	Set return = "{}"
	
	Set obj =##class(DHCMed.EPD.Epidemic).GetObjById(ID)
	Quit:obj="" return
	Set return=obj
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-02-16
/// Description:  根据ID获取传染病报告
/// Table：       DHCMed.EPD.Epidemic
/// Input：       ID: DHCMed.EPD.Epidemic.ID
/// Return：      返回obj
/// W ##class(DHCMed.EPDService.EpidemicSrv).GetRepByID("123")
ClassMethod GetRepByID(aID As %String) As %String
{
	New (aID,%session)
	Set return =""
	Set separete=..#SEPARATE
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.MEPDICDDR) return
	
	Set PapmiDR = objRep.MEPDPapmiDR
	Set Area=objRep.MEPDArea                       //所属区域
	Set AreaDesc=""
	Set objArea=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicReportRegion",Area,"")
	If $IsObject(objArea){
		Set AreaDesc=objArea.Description
		Set AreaDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,AreaDesc)
	}
	
	Set Occupation=objRep.MEPDOccupation            //职业
	Set OccupationDesc=""
	Set objOcc=##class(DHCMed.SS.Dictionary).GetByTypeCode("Career",Occupation,"")
	If $IsObject(objOcc){
		Set OccupationDesc=objOcc.Description
		Set OccupationDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,OccupationDesc)
	}
	Set FamName=objRep.MEPDFamName                  //家长姓名	
	Set DiseaseDr = objRep.MEPDICDDR.%Id()          //疾病ID
	Set DiseaseICD = objRep.MEPDICDDR.MIFICD	    //ICD
	Set Disease = objRep.MEPDICDDR.MIFDisease	    //疾病名称
	Set:Disease'="" Disease = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.EPD.Infection","MIFDisease",Languages,Disease)
    //add 20200203 
    Set Severity=objRep.MEPDSeverity                     //临床严重程度
	Set SeverityDesc=""
	Set objSeverity=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSeverity",Severity,"")
	If $IsObject(objSeverity) {
		Set SeverityDesc=objSeverity.Description
		Set SeverityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,SeverityDesc)
	}
	
    Set Intimate=objRep.MEPDIntimateCode            //密切接触情况	
	Set IntimateDesc=""
	Set objInt=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicContact",Intimate,"")
	If $IsObject(objInt){
		Set IntimateDesc=objInt.Description
		Set IntimateDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,IntimateDesc)
	}
		
	Set DiagnoseType=objRep.MEPDDiagnoseType            // 诊断类型	
	Set DiagnoseDesc=""                                
	Set objDiag=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",DiagnoseType,"")
	If $IsObject(objDiag){
		Set DiagnoseDesc=objDiag.Description
		Set DiagnoseDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,DiagnoseDesc)
	}
	
	Set DiagDegree=objRep.MEPDDiagDegree                 // 诊断分类
	Set DiagDegreeDesc=""
	Set objDegree=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicDiagnoseDegree",DiagDegree,"")
	If $IsObject(objDegree){
		Set DiagDegreeDesc=objDegree.Description
		Set DiagDegreeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,DiagDegreeDesc)
	}
	Set SickKind=objRep.MEPDSickKind                     // 发病程度
	Set SickKindDesc=""
	Set objSick=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSickQuality",SickKind,"")
	If $IsObject(objSick){
		Set SickKindDesc=objSick.Description
		Set SickKindDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,SickKindDesc)
	}
	
	Set Company=objRep.MEPDCompany                  //工作单位
	Set TelPhone=objRep.MEPDTelPhone                //联系电话
	Set IDAddress=objRep.MEPDIDAddress              //户籍地址
	Set SickDate=objRep.MEPDSickDate                //发病日期
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
	Set DeathDate=objRep.MEPDDeathDate              //死亡日期
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)

	Set DiagDateTime=objRep.MEPDDiagDateTime         //诊断日期时间
	Set DiagDate=$p(DiagDateTime," ",1)
	Set DiagTime=$p(DiagDateTime," ",2)
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
	
	Set (Province,City,County,Village)=""
	Set ProvinceID=objRep.MEPDProvince
	If ProvinceID'="" {
		Set ProvinceDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(ProvinceID)
		Set ProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,ProvinceDesc)	
		Set:ProvinceDesc'="" Province=ProvinceID_$c(2)_ProvinceDesc
	}
	Set CityID=objRep.MEPDCity
	If CityID'="" {
		Set CityDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(CityID)
		Set CityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,CityDesc)
		Set:CityDesc'="" City=CityID_$c(2)_CityDesc
	}
	set CountyID=objRep.MEPDCounty
	If CountyID'="" {
		Set CountyDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(CountyID)
		Set CountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,CountyDesc)
		Set:CountyDesc'="" County=CountyID_$c(2)_CountyDesc
	}
	set VillageID=objRep.MEPDVillage
	If VillageID'="" {
		Set VillageDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(VillageID)
		Set VillageDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,VillageDesc)
		Set:VillageDesc'="" Village=VillageID_$c(2)_VillageDesc
	}	
	Set Road=objRep.MEPDRoad
	Set Address=objRep.MEPDAddress                  //现住址
	if (Languages="EN"){
		Set Address = $p(ProvinceDesc,$c(2),2)_$p(CityDesc,$c(2),2)_$p(CountyDesc,$c(2),2)_$p(VillageDesc,$c(2),2)_Road
	}
	Set RepIsUpload=objRep.MEPDIsUpload  //是否上报CDC	
	Set MepdDR=objRep.MEPDMepdDR         //被订正报告
	Set EpisodeID=objRep.MEPDText1       //就诊号	
	Set RepNo=objRep.MEPDText2           //卡片编号	
	Set DelReason=objRep.MEPDDelReason   //退卡原因或删除原因	
	Set DemoInfo=objRep.MEPDDemo         //备注
	Set DText6=objRep.MEPDText6          //备用字段6
	
	Set CardType=objRep.MEPDText4 	     //有效证件类型
	Set CardTypeDesc=""
	Set objCardType=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
	If $IsObject(objCardType){
		Set CardTypeDesc=objCardType.Description
		Set CardTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,CardTypeDesc)
	}
	Set CardNo=objRep.MEPDText5          //有效证件号
	
    Set RepWardID = objRep.MEPDText3   //报告病区
    
    Set MEPDContr = objRep.MEPDContr   //入境前国家地区  
    Set MEPDIsInEPD=objRep.MEPDIsInEPD              //
	Set MEPDIsInEPDDesc="" 
	Set objRepMEPDIsInEPD=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicYesNo",MEPDIsInEPD,"")
	If $IsObject(objRepMEPDIsInEPD){
		Set MEPDIsInEPDDesc=objRepMEPDIsInEPD.Description
		Set MEPDIsInEPDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,MEPDIsInEPDDesc)
	}
    Set RepWard=""
    Set objRepWard=##class(DHCMed.Base.Ctloc).GetObjById(RepWardID)   
	If $IsObject(objRepWard){
		Set RepWard=objRepWard.Descs
	}
   	
	Set RepLocID=objRep.MEPDLocDR
	Set RepLoc=""              
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)   //报告科室
	If $IsObject(objRepLoc){
		Set RepLoc=objRepLoc.Descs
		Set RepLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,RepLoc)	
	}
	Set RepPlace=objRep.MEPDRepPlace              //上报位置
	Set RepPlaceDesc="" 
	Set objRepPlace=##class(DHCMed.SS.Dictionary).GetByTypeCode("REPPLACE",RepPlace,"")
	If $IsObject(objRepPlace){
		Set RepPlaceDesc=objRepPlace.Description
		Set RepPlaceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACAdmCategory","ADMCATDesc",Languages,RepPlaceDesc)
	}
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserCode="",RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
		Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserName)	
			
	}
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set RepStatusCode="",RepStatusDesc=""
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,RepStatusDesc)
	}

	Set CheckDate=objRep.MEPDCheckDate              //审核日期
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime=objRep.MEPDCheckTime              //审核时间
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	Set CheckUser=objRep.MEPDCheckUsrDR                 //审核人
	Set CheckUserCode="",CheckUserName=""
	Set objCheckUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	If $IsObject(objCheckUser){
		Set CheckUserCode=objCheckUser.Code
		Set CheckUserName=objCheckUser.Name
	}
	 
	Set return=aID_separete                                         //报告ID
	Set return=return_PapmiDR_separete                              //PatientID
	set return=return_Area_$c(2)_AreaDesc_separete                  //所属区域
	Set return=return_Occupation_$c(2)_OccupationDesc_separete      //职业             
	Set return=return_FamName_separete                              //家长姓名
	Set return=return_DiseaseDr_$c(2)_Disease_separete              //疾病ID 疾病名称
	Set return=return_Intimate_$c(2)_IntimateDesc_separete          //密切接触
	Set return=return_DiagnoseType_$c(2)_DiagnoseDesc_separete      //诊断类型
	Set return=return_SickDate_separete                             //发病日期
	Set return=return_DiagDegree_$c(2)_DiagDegreeDesc_separete      //诊断分类
    Set return=return_DiagDate_separete                             //诊断日期
	Set return=return_DiagDate_" "_DiagTime_separete              //诊断日期时间
	Set return=return_SickKind_$c(2)_SickKindDesc_separete          //发病程度
	Set return=return_DeathDate_separete                            //死亡日期	
	Set return=return_Company_separete                              //工作单位
	Set return=return_Address_separete                              //现住址
	Set return=return_IDAddress_separete                            //户籍地址
	Set return=return_TelPhone_separete                             //联系电话
	Set return=return_RepNo_separete                                //卡片编号
	Set return=return_CardType_$c(2)_CardTypeDesc_separete          //有效证件类型
	Set return=return_CardNo_separete                               //有效证件号
	Set return=return_Province_separete                             // 居住地省市
	Set return=return_City_separete                                 // 居住地地市
	Set return=return_County_separete                               // 居住地区县
	Set return=return_Village_separete                              // 居住地乡镇
	Set return=return_Road_separete                                 // 街道门牌号
	Set return=return_RepIsUpload_separete                           //是否上报CDC
	Set return=return_RepLocID_$c(2)_RepLoc_separete                     //报告科室
	Set return=return_RepWardID_$c(2)_RepWard_separete                   //报告病区
	Set return=return_RepPlace_$c(2)_RepPlaceDesc_separete               //上报位置
	Set return=return_RepUser_$c(2)_RepUserName_separete                 //报告人
	Set return=return_RepDate_separete                                   //报告日期
	Set return=return_RepTime_separete                                   //报告时间
	Set return=return_RepStatus_$c(2)_RepStatusDesc_separete             //报告状态
	Set return=return_CheckUser_$c(2)_CheckUserName_separete             //审核人
	Set return=return_CheckDate_separete                              //审核日期
	Set return=return_CheckTime_separete                              //审核时间
	Set return=return_DelReason_separete                              //退回或删除原因
	Set return=return_DemoInfo_separete                               //备注
	Set return=return_MepdDR_separete                                 //被订正报告
	Set return=return_DText6_separete                                 //备用字段
	Set return=return_EpisodeID_separete                              //就诊号
	Set return=return_Severity_$c(2)_SeverityDesc_separete            //临床严重程度 add 20200203
	Set return=return_MEPDIsInEPD_$c(2)_MEPDIsInEPDDesc_separete      
	 Set return=return_MEPDContr_separete
	Quit return
}

/// Creator：     xwj
/// CreatDate：   2019-02-04
/// Description:  根据登记号查询HIV个案随访表
/// Table：       DHCMed.EPDService.EpidemicSrv
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicSrv","QryHIVRepByEpisodeID",63,59)
Query QryHIVRepByEpisodeID(aEpisodeID As %String, aPatientID As %String) As %Query(ROWSPEC = "ReportID:%String,PatName:%String,FollowStatus:%String,HIVDate:%String,SurveyOrgan:%String,SurveyName:%String,SurveyDate:%String")
{
}

ClassMethod QryHIVRepByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="") $$$OK
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.EPD.CaseFollowI("HIVEpisodeIDIndex"," "_$zcvt(aEpisodeID,"U"),xRepID))
		
		Quit:xRepID=""
		
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(aPatientID)
		If $IsObject(objPatient){
			Set PatName=objPatient.PatientName      //姓名
		}
		Set objRep=##class(DHCMed.EPD.CaseFollow).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
				
		Set (FollowStatus,HIVDate,SurveyOrgan,SurveyName,SurveyDate)=""
		Set FollowStatus=objRep.FollowStatus.Description
		Set FollowStatus = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",FollowStatus)
		Set HIVDate=objRep.HIVDate
		Set:HIVDate'="" HIVDate=$zd(HIVDate,3)
		Set SurveyOrgan=objRep.SurveyOrgan
		Set SurveyName=objRep.SurveyName
		Set SurveyDate=objRep.SurveyDate
		Set:SurveyDate'="" SurveyDate=$zd(SurveyDate,3)
		
		Set Data=$lb(xRepID,PatName,FollowStatus,HIVDate,SurveyOrgan,SurveyName,SurveyDate)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHIVRepByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHIVRepByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHIVRepByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHIVRepByEpisodeIDExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2022-11-14
/// Description:  根据报告ID查询报告修改日志
/// Table：       DHCMed.EPDService.EpidemicSrv
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.EpidemicSrv","QryEpidemicLog","74","","","","","")
Query QryEpidemicLog(aReportID As %String, aFromDate As %String, aToDate As %String, aHospital As %String, aLoc As %String, aStatusCode As %String) As %Query(ROWSPEC = "LogID:%String,EpisodeID:%String,StatusCode:%String,StatusDesc:%String,LocID:%String,LocCode:%String,LocDesc:%String,EPDDate:%String,EPDTime:%String,UserID:%String,UserCode:%String,UserName:%String,EPDOpinion:%String,Resume:%String,EPDEditContent:%String")
{
}

ClassMethod QryEpidemicLogExecute(ByRef qHandle As %Binary, aReportID As %String, aFromDate As %String, aToDate As %String, aHospital As %String, aLoc As %String, aStatusCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aReportID="" $$$OK
	Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	
	Set xData=""
	Set:aFromDate'="" xData=aToDate+1
	For {
		Set xData=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData),-1)
		Quit:xData=""
		Quit:xData<aFromDate
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData,xTime),-1)
			Quit:xTime=""
			
			Set xLogID=""
			For {
				Set xLogID=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData,xTime,xLogID),-1)
				Quit:xLogID=""
				
				Set objLog=##class(DHCMed.EPD.EpidemicLog).GetObjById(xLogID)
				Continue:'$IsObject(objLog)
				
				Set EpisodeID	= objLog.EpisodeID
				Set EPDStatus	= objLog.EPDStatus
				Set StatusCode="",StatusDesc=""
				If $IsObject(EPDStatus) {
					Set StatusCode	= EPDStatus.Code
					Set StatusDesc	= EPDStatus.Description
				}
				Continue:(aStatusCode'="")&&(StatusCode'=aStatusCode)
				
				//重新命名描述
				//1待审、2已审、3订正、4被订、5退回、6草稿、7作废、8复诊、9漏报
				Set:StatusCode="1" StatusDesc="提交"
				Set:StatusCode="2" StatusDesc="审核"
				
				Set LocID	= objLog.EPDLoc
				Continue:(aLoc'="")&&(LocID'=aLoc)
				If aHospital'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospital)
					continue:flg<1
				}
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
				Set LocCode="",LocDesc=""
				If $IsObject(objLoc) {
					Set LocCode=objLoc.Code
			   		Set LocDesc=objLoc.Descs
				}
				Set EPDDate		= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(xData)
				Set EPDTime		= $zt(xTime,1)
				Set UserID	= objLog.EPDUser
				Set objUser=##Class(DHCMed.Base.SSUser).GetObjById(UserID)
				If $IsObject(objUser) {
					Set UserCode=objUser.Code
					Set UserName=objUser.Name
				}
				Set EPDOpinion	= objLog.EPDOpinion
				Set Resume		= objLog.Resume
				Set EPDEditContent = objLog.EPDEditContent
				Set:EPDEditContent'="" EPDEditContent=$replace(EPDEditContent,$C(1),"<br>")
				
				Set Data=$lb(xLogID,EpisodeID,StatusCode,StatusDesc,LocID,LocCode,LocDesc,EPDDate,EPDTime,UserID,UserCode,UserName,EPDOpinion,Resume,EPDEditContent)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEpidemicLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEpidemicLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEpidemicLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEpidemicLogExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2023-01-19
/// Description:  通过传染病日志表，判断报告是否被打印过
/// Table：       
/// Input：       
/// Return：      %String 0或1
/// w ##class(DHCMed.EPDService.EpidemicSrv).IsPrintByEpidemicLog(93,"","")
ClassMethod IsPrintByEpidemicLog(aReportID As %String, aFromDate As %String = "", aToDate As %String = "") As %String
{
	New (aReportID,aFromDate,aToDate)
	Set return=0
	Quit:aReportID="" return

	Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	
	Set xData=""
	Set:aFromDate'="" xData=aToDate+1
	For {
		Set xData=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData),-1)
		Quit:xData=""
		Quit:xData<aFromDate
		Quit:return=1
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData,xTime),-1)
			Quit:xTime=""
			Quit:return=1
			
			Set xLogID=""
			For {
				Set xLogID=$o(^DHCMed.EPD.EpidemicLogI("IndexReportIDDateTime",aReportID,xData,xTime,xLogID),-1)
				Quit:xLogID=""
				Quit:return=1
				
				Set objLog=##class(DHCMed.EPD.EpidemicLog).GetObjById(xLogID)
				Continue:'$IsObject(objLog)
				
				Set EpisodeID	= objLog.EpisodeID
				Set EPDStatus	= objLog.EPDStatus
				Continue:EPDStatus'=""			//打印的日志记录状态为空
				Set EPDEditContent	= objLog.EPDEditContent
				If EPDEditContent["打印" {
					Set return=1
					Quit
				}
			}
		}
	}
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-11-22
/// Description:  判断同一患者，同一次就诊，同一诊断是否有历史报告数据
/// Table：       
/// Input：       EpisodeID:    User.PAADM   aInfectID: 诊断ID
/// Return：      %List
/// w ##class(DHCMed.EPDService.EpidemicSrv).getPatHisDiag(1708,48)
ClassMethod getPatHisDiag(aEpisodeID As %String, aInfectID As %String) As %String
{
	New (aEpisodeID,aInfectID)
	Set return = ""
	Set TipStr = ""
	// 取患者本次就诊传染病分类列表
	Set DiagnosList = ##class(DHCMed.EPDService.Service).getEpdThisTimeList(aEpisodeID)
	
	Set IFDiagnosMIFKind = $p($g(^DHCMed.EPDC("IF",aInfectID)),"^",3)	// 传染病类别
	Set TimeLimit		 = $p($g(^DHCMed.EPDC("IF",aInfectID)),"^",8)   // 重复上报时限时限
	Set IFDesc			 = $p($g(^DHCMed.EPDC("IF",aInfectID)),"^",2)	// 传染病疾病描述
	// 本次就诊已报告的类型不重复提示
	if ($listfind(DiagnosList,IFDiagnosMIFKind)>0){
		Set RepDate=##class(DHCMed.EPDService.Service).GetRepDate(aEpisodeID,IFDiagnosMIFKind)
		Set Days=(+$h)-RepDate   //上次上报距当前时间相差天数
		 // 计算时间差是否在上报时限内
		If (Days<=TimeLimit) {
			Set return=1    
			Set TipStr=IFDesc_",此传染病已上报过"
			Set RepDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
		    Set TipStr = TipStr_","_"最近一次上报时间为"_RepDate
		}
	}
	Set return=return_"^"_TipStr
	Quit return
}

}
