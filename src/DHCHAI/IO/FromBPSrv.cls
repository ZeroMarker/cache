/// ClassName:    DHCHAI.IO.FromBPSrv
/// Description:  对接血透系统相关服务类
/// Creator：     zhoubo
/// CreatDate:    2022-10-26
Class DHCHAI.IO.FromBPSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-26
/// Description:  根据日期同步血透患者就诊、护理、检验、检查信息
/// 透析医嘱：D ##class(%ResultSet).RunQuery("web.DHCBPInterface","FindBPOrderItem","5")
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// Return：      处理同步数量
/// w ##class(DHCHAI.IO.FromBPSrv).SyncBPPatInfo("2022-12-01","2022-12-19")
ClassMethod SyncBPPatInfo(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom'["-" aDateFrom=$zd(aDateFrom,3)
	Set:aDateTo'["-" aDateTo=$zd(aDateTo,3)
	
	// 获取一段期间的血透记录
	Set rs=##Class(%ResultSet).%New("web.DHCBPInterface:FindBPArrangeId")
  	Set sc=rs.Execute(aDateFrom,aDateTo,"")
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    Set bpaId   = rs.Data("bpaId")    // 血液透析记录ID
	    Set papmiId = rs.Data("papmiId")  // HIS病人ID
	    Set admId   = rs.Data("admId")    // HIS就诊ID
	    Set regNo   = rs.Data("regNo")    // 登记号
	    Set bpprId  = rs.Data("bpprId")   // 血透登记ID
	    
		Set AdmType=""
		For {
			Set AdmType = $o(^PAPERdr(papmiId,"ADM",AdmType))
			Quit:AdmType=""
			Continue:(AdmType'="O")&&(AdmType'="E")
			Set EpisodeID=""
			For {
			Set EpisodeID=$o(^PAPERdr(papmiId,"ADM",AdmType,EpisodeID),-1)
				Quit:EpisodeID=""
				Set EpisodeDr = ##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(EpisodeID,"0")
				If (EpisodeDr=""){
					// 根据EpisodeID同步病人基本信息、就诊信息
					Set EpisodeDr = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID("HIS01",EpisodeID)
				}
				Set xEpisodeID ="HIS01||"_EpisodeID 
				//一： 先处理作废、修改、删除记录数据不一致问题
				// ---------Start--------------//   
				//1. 护理记录
				Set flg=##class(DHCHAI.DI.ERR.SyncNisErrInfo).SyncNisErrByEpis("NIS01",xEpisodeID,aDateFrom,aDateTo)
				//2. 检查报告
				Do ##class(DHCHAI.DI.ERR.SyncPacsErrInfo).SyncPacsErrByEpis("RIS01",xEpisodeID,aDateFrom,aDateTo)
				//3. 检验结果
				Set flg=##class(DHCHAI.DI.ERR.SyncLabErrInfo).SyncLabErrByEpis("LIS01",xEpisodeID,aDateFrom,aDateTo)
				//-----------End----------------//
				//二：在同步患者信息
				//1. 护理记录
				Set ret=##class(DHCHAI.DI.DHS.SyncNisInfo).SyncNisByDateAdm("NIS01",xEpisodeID,aDateFrom,aDateTo)
				If (+ret)<0 {
					Set ErrClass  = "DHCHAI.DI.DHS.SyncNisInfo"
					Set ErrMethod = "SyncNisByDateAdm"
					Set ErrArgStr = $lb(ret)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
			    }
			    //2 检查报告
				Set ret= ##class(DHCHAI.DI.DHS.SyncPacsInfo).SyncPacsByDateAdm("RIS01",xEpisodeID,aDateFrom,aDateTo)
				If (+ret)<0 {
					Set ErrClass  = "DHCHAI.DI.DHS.SyncPacsInfo"
					Set ErrMethod = "SyncPacsByDateAdm"
					Set ErrArgStr = $lb(ret)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
			    }
				//3 送检+检验结果
				Set ret =##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01",xEpisodeID,aDateFrom,aDateTo)
				If (+ret)<0 {
					Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
					Set ErrMethod = "SyncLabVisitNumber"
					Set ErrArgStr = $lb(ret)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
			    }
				Set ret = ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01",xEpisodeID,aDateFrom,aDateTo)
				If (+ret)<0 {
					Set ErrClass  = "DHCHAI.DI.DHS.SyncLabInfo"
					Set ErrMethod = "SyncLabRepByDate"
					Set ErrArgStr = $lb(ret)
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
			    }
			}
		}
    }
    Quit "OK"
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-26
/// Description:  根据日期同步血透患者登记信息、透析记录、血管通路
/// Input：       aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// Return：      处理同步数量
/// w ##class(DHCHAI.IO.FromBPSrv).SyncBPReg("2022-12-01","2022-12-19")
ClassMethod SyncBPReg(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	// 维护血透室科室ID
	Set BDLocIDs=##class(DHCHAI.BT.Config).GetValByCode("BloodDialysisLocIDs")
	// 血透患者数据来源1：血透系统2：血透室(PABPRegID血透记录ID即就诊ID)
	Set IsBPPatSource=##class(DHCHAI.BT.Config).GetValByCode("IsBPPatSource")
	If (IsBPPatSource=2){
		// 同步血透室患者到血透登记表中
		Set xAdmType = ""
		For {
			Set xAdmType = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType))
			Quit:xAdmType=""
			For xAdmDate = aDateFrom:1:aDateTo{
				Set xAdmTime = ""
				For {
					Set xAdmTime = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime))
					Quit:xAdmTime=""
					Set xPaadmId = ""
					For {
						Set xPaadmId = $o(^DHCHAI.DP.PAAdmI("IndexAdmDateTime",xAdmType,xAdmDate,xAdmTime,xPaadmId))
						Quit:xPaadmId=""
						Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPaadmId)
						Continue:'$isobject(objPaadm)
						Set EpisodeIDx=objPaadm.PAEpisodeIDx
						Set SCode = $p(EpisodeIDx,"||",1)
						Set VisitStatus = objPaadm.PAVisitStatus
						Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
						If VisitStatusInfo'="" {
							Set VisitStatus=$p(VisitStatusInfo,"^",2)
						}
						Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
						Set bpprId     = xPaadmId
						Set EpisodeIDx = objPaadm.PAEpisodeIDx
						Set admId      = $p(EpisodeIDx,"||",2)
						Set papmiId    = objPaadm.PAPatientIDx
						Set MrNo       = objPaadm.PAMrNo
						Set PatName    = objPaadm.PAPatName
						Set Sex        = objPaadm.PASex
						Set Sex        = $s(Sex="M":"男",Sex="F":"女",1:"")
						Set BirthDay   = objPaadm.PABirthday
						Set:BirthDay'="" BirthDay = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BirthDay)
						Set PatAge     = objPaadm.PAAge
						Set AdmType    = objPaadm.PAAdmType
						Set AdmType    = $s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="EP":"急诊留观",AdmType="I":"住院",1:"")
						Set RelativeTel= objPaadm.PARelativeTel
						Set objAdmWard = objPaadm.PAAdmWardDr
						Set objAdmLoc  = objPaadm.PAAdmLocDr
						Set PABPHDLoc  = ""   //透析科室ID
						If $isobject(objAdmLoc) {
							Set PABPHDLoc = objAdmLoc.%Id()
						}
						Set PABPHDWard  = ""   //透析病区ID
						If $isobject(objAdmWard) {
							Set PABPHDWard = objAdmWard.%Id()
						}
						Continue:(BDLocIDs'="")&&(((","_BDLocIDs_",")'[(","_PABPHDLoc_","))&&((","_BDLocIDs_",")'[(","_PABPHDWard_",")))
						Set:(","_BDLocIDs_",")[(","_PABPHDWard_",") PABPHDLoc=PABPHDWard
						
						Set MainDoctorDesc = objPaadm.PAAdmDoc
						Set BPPatType    = "常规"
						Set AdmDate      = objPaadm.PAAdmDate
						Set AdmTime      = objPaadm.PAAdmTime
						Set PADischDate  = objPaadm.PADischDate
						Set DischTime    = objPaadm.PADischTime
						Set PatStartDate = AdmDate
						Set PatEndDate   = PADischDate
						Set PAStatusDate = PADischDate
						Set PAStatusTime = DischTime
						Set PatRegDate   = AdmDate
						Set PatRegTime   = AdmTime
						
						Set (PAHDTime,MainNurseDesc,PatInfection,PatDiagnosis) = ""
						Set PatDiagnosis = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(xPaadmId,"")
						Set BPID=$o(^MA.HAI.DP.BPRegisterI("IndexBPRegID"," "_bpprId,0))
					    // 1，保存血透登记表
					    Set InputStr = BPID
						Set InputStr = InputStr_"^"_bpprId
						Set InputStr = InputStr_"^"_admId
						Set InputStr = InputStr_"^"_papmiId
						Set InputStr = InputStr_"^"_MrNo
						Set InputStr = InputStr_"^"_PatName 
						Set InputStr = InputStr_"^"_Sex
						Set InputStr = InputStr_"^"_PatAge
						Set InputStr = InputStr_"^"_AdmType
						Set InputStr = InputStr_"^"_BirthDay
						Set InputStr = InputStr_"^"_RelativeTel
						Set InputStr = InputStr_"^"_PABPHDLoc
						Set InputStr = InputStr_"^"_PAHDTime
						Set InputStr = InputStr_"^"_MainDoctorDesc
						Set InputStr = InputStr_"^"_MainNurseDesc
						Set InputStr = InputStr_"^"_PatInfection
						Set InputStr = InputStr_"^"_BPPatType
						Set InputStr = InputStr_"^"_PatDiagnosis
						Set InputStr = InputStr_"^"_PatStartDate
						Set InputStr = InputStr_"^"_PatEndDate
						Set InputStr = InputStr_"^"_PAStatusDate
						Set InputStr = InputStr_"^"_PAStatusTime
						Set InputStr = InputStr_"^"_PatRegDate
						Set InputStr = InputStr_"^"_PatRegTime
						Set InputStr = InputStr_"^"_1      // 是否有效
						Set InputStr = InputStr_"^"_""
						Set InputStr = InputStr_"^"_""
						Set BPRegDr  = ##class(DHCHAI.DP.BPRegister).Update(InputStr,"^")
						If (+BPRegDr)>1 {
							Set Count=Count+1
						}
					}
				}
			}
		}
	}Else{
		// 获取一段期间的血透记录
		Set rs=##Class(%ResultSet).%New("web.DHCBPInterface:FindBPArrangeId")
	  	Set sc=rs.Execute(aDateFrom,aDateTo,"")
	  	If $$$ISERR(sc) {
		  	Do $System.Status.DisplayError(sc)
		  	Quit return
	  	}
		Set rowData=##Class(%ArrayOfDataTypes).%New()
		If rowData'="" Do rowData.%Close()
	    While (rs.Next()){
		    Set bpaId   = rs.Data("bpaId")    // 血液透析记录ID
		    Set papmiId = rs.Data("papmiId")  // HIS病人ID
		    Set admId   = rs.Data("admId")    // HIS就诊ID
		    Set regNo   = rs.Data("regNo")    // 登记号
		    Set bpprId  = rs.Data("bpprId")   // 血透登记ID
		    // 根据透析记录ID获取透析记录信息
		    Set BPRecordInfo = ##Class(web.DHCBPInterface).GetBPArrangeSummary(bpaId)
		    Continue:BPRecordInfo=""
		    Set (PatAge,HDDoDate,HDBedNo,BPPatType,HDStatus,BPRegDate,PAStatusDate,HDDoMethod,AccessType,PABPHDLoc,BADoUser,BAccessDate,PAHDTime,HDFreqTime,HDBedGroup,BATypeBody)=""
		  	Set PatAge       = $p(BPRecordInfo,"^",2)   // 年龄
			Set HDDoDate	 = $p(BPRecordInfo,"^",3)   // 透析日期
			Set HDBedNo   	 = $p(BPRecordInfo,"^",4)   // 床位
			Set BPPatType	 = $p(BPRecordInfo,"^",5)   // 透析类型(常规、临时)
			Set HDStatus	 = $p(BPRecordInfo,"^",6)   // 状态
			Set BPRegDate	 = $p(BPRecordInfo,"^",7)   // 登记日期
			Set PAStatusDate = $p(BPRecordInfo,"^",8)   // 转归日期
			Set HDDoMethod	 = $p(BPRecordInfo,"^",9)   // 透析方式
			Set AccessType	 = $p(BPRecordInfo,"^",10)  // 血管通路
			Set PABPHDLoc	 = $p(BPRecordInfo,"^",11)  // 透析科室
			Set BADoUser	 = $p(BPRecordInfo,"^",12)  // 创建人员
			Set BAccessDate	 = $p(BPRecordInfo,"^",13)  // 创建时间
			Set PAHDTime	 = $p(BPRecordInfo,"^",14)  // 透析次数
			Set HDFreqTime	 = $p(BPRecordInfo,"^",15)  // 透析时长
			Set HDBedGroup	 = $p(BPRecordInfo,"^",16)  // 床位组
			Set BATypeBody	 = $p(BPRecordInfo,"^",17)  // 通路部位
		  	Set objHDLoc     = ##class(DHCHAI.BT.Location).GetObjByLocDesc2(PABPHDLoc)
		  	Set:PAHDTime<0 PAHDTime=0
		    //根据透析记录ID获取患者登记信息
		    Set rsreg=##Class(%ResultSet).%New("web.DHCBPInterface:FindBPPatRegister")
		  	Set screg=rsreg.Execute(bpaId)
		  	If $$$ISERR(screg) {
			  	Do $System.Status.DisplayError(screg)
		  	}
		  	Set (PatRegDate,PatBPNo,PatType,PatStatus,PatDiagnosis,PatMRCICD,PatStartDate,PatEndDate,PatVisitStatus,PatBPCount,MainDoctorDesc,MainNurseDesc,PatInfection)=""
		  	While (rsreg.Next()){
			    Set PatRegDate     = rsreg.Data("PatDate")        // 登记日期
			    Set PatBPNo        = rsreg.Data("PatBPNo")        // 透析编号
			    Set PatType        = rsreg.Data("PatType")        // 病人类型
			    Set PatStatus      = rsreg.Data("PatStatus")      // 状态
			    Set PatDiagnosis   = rsreg.Data("PatDiagnosis")   // 诊断
			    Set PatMRCICD      = rsreg.Data("PatMRCICD")      // 透析原因
			    Set PatStartDate   = rsreg.Data("PatStartDate")   // 首次透析日期
			    Set PatEndDate     = rsreg.Data("PatEndDate")     // 转归日期
			    Set PatVisitStatus = rsreg.Data("PatVisitStatus") // 转归原因
			    Set PatBPCount     = rsreg.Data("PatBPCount")     // 登记透析次数
			    Set MainDoctorDesc = rsreg.Data("MainDoctorDesc") // 主管医生
			    Set MainNurseDesc  = rsreg.Data("MainNurseDesc")  // 主管护士
			    Set PatInfection   = rsreg.Data("PatInfection")   // 传染病类型  
		  	}
		    Set:PatEndDate="" PatEndTime=""
		    // 获取病人基本信息
		    Set AdmStr      = $g(^PAADM(+admId))
			Set AdmType     = $p(AdmStr,"^",2)	//就诊类型
			Set AdmType     = $s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="EP":"急诊留观",AdmType="I":"住院",1:"")
			Set PapmiNo  	= $p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			Set PatName  	= $p($g(^PAPER(papmiId,"ALL")),"^",1)
			Set BirthDay 	= $p($g(^PAPER(papmiId,"ALL")),"^",6)
			Set RelativeTel	= $p($g(^PAPER(papmiId,"ALL")),"^",4)
		    Set Sex	        = $p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
			Set MrNo        = ##Class(DHCHAI.IO.FromAdmSrv).GetMrNoByAdm(admId)
		    Set AdmDateTime = ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(+admId)	//入院日期
			Set AdmDate	    = $p(AdmDateTime,"^",1)
			Set AdmTime	    = $p(AdmDateTime,"^",2)
			Set:PatAge="" PatAge = ##class(DHCHAI.IO.FromHisSrv).GetPapmiAge(papmiId,admId,AdmDate,AdmTime)
			If ($IsObject(objHDLoc)){
				Set PABPHDLoc = objHDLoc.%Id()
			}
			Set BPID=$o(^MA.HAI.DP.BPRegisterI("IndexBPRegID"," "_bpprId,0))
		    // 1，保存血透登记表
		    Set InputStr = BPID
			Set InputStr = InputStr_"^"_bpprId
			Set InputStr = InputStr_"^"_admId
			Set InputStr = InputStr_"^"_papmiId
			Set InputStr = InputStr_"^"_MrNo
			Set InputStr = InputStr_"^"_PatName 
			Set InputStr = InputStr_"^"_Sex
			Set InputStr = InputStr_"^"_PatAge
			Set InputStr = InputStr_"^"_AdmType
			Set InputStr = InputStr_"^"_BirthDay
			Set InputStr = InputStr_"^"_RelativeTel
			Set InputStr = InputStr_"^"_PABPHDLoc
			Set InputStr = InputStr_"^"_PAHDTime
			Set InputStr = InputStr_"^"_MainDoctorDesc
			Set InputStr = InputStr_"^"_MainNurseDesc
			Set InputStr = InputStr_"^"_PatInfection
			Set InputStr = InputStr_"^"_BPPatType
			Set InputStr = InputStr_"^"_PatDiagnosis
			Set InputStr = InputStr_"^"_PatStartDate
			Set InputStr = InputStr_"^"_PatEndDate
			Set InputStr = InputStr_"^"_PatEndDate
			Set InputStr = InputStr_"^"_PatEndTime
			Set InputStr = InputStr_"^"_PatRegDate
			Set InputStr = InputStr_"^"_1
			Set InputStr = InputStr_"^"_1      // 是否有效
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set BPRegDr  = ##class(DHCHAI.DP.BPRegister).Update(InputStr,"^")
			If (+BPRegDr)<1 {
				Continue
			} 
			Set PatAge       = $p(BPRecordInfo,"^",2)   // 年龄
			Set HDDoDate	 = $p(BPRecordInfo,"^",3)   // 透析日期
			Set HDBedNo   	 = $p(BPRecordInfo,"^",4)   // 床位
			Set BPPatType	 = $p(BPRecordInfo,"^",5)   // 透析类型(常规、临时)
			Set HDStatus	 = $p(BPRecordInfo,"^",6)   // 状态
			Set BPRegDate	 = $p(BPRecordInfo,"^",7)   // 登记日期
			Set PAStatusDate = $p(BPRecordInfo,"^",8)   // 转归日期
			Set HDDoMethod	 = $p(BPRecordInfo,"^",9)   // 透析方式
			Set AccessType	 = $p(BPRecordInfo,"^",10)  // 血管通路
			Set PABPHDLoc	 = $p(BPRecordInfo,"^",11)  // 透析科室
			Set BADoUser	 = $p(BPRecordInfo,"^",12)  // 创建人员
			Set BAccessDate	 = $p(BPRecordInfo,"^",13)  // 创建时间
			Set PAHDTime	 = $p(BPRecordInfo,"^",14)  // 透析次数
			Set HDFreqTime	 = $p(BPRecordInfo,"^",15)  // 透析时长
			Set HDBedGroup	 = $p(BPRecordInfo,"^",16)  // 床位组
			Set BATypeBody	 = $p(BPRecordInfo,"^",17)  // 通路部位
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("BPAccessType",AccessType)
			If ('$IsObject(objDic)){
				Set DicStr = ""
				Set DicStr = DicStr_"^"_AccessType
				Set DicStr = DicStr_"^"_AccessType
				Set DicStr = DicStr_"^"_$o(^DHCHAI.BT.DicTypeI("IdxofCode","BPAccessType",0))
				Set DicStr = DicStr_"^"_"99^1"
				Set AccessTypeDr = ##class(DHCHAI.BT.Dictionary).Update(DicStr,"^")
			}Else{
				Set AccessTypeDr = objDic.%Id()
			}
		    // 2，保存透析记录
		    Set RecID=$o(^MA.HAI.DP.BPRecordI("IndexHDRegHDialID"," "_BPRegDr," "_bpaId,0))
		    Set InputStr = RecID
			Set InputStr = InputStr_"^"_bpaId
			Set InputStr = InputStr_"^"_BPRegDr
			Set InputStr = InputStr_"^"_HDBedGroup
			Set InputStr = InputStr_"^"_HDBedNo
			Set InputStr = InputStr_"^"_HDStatus
			Set InputStr = InputStr_"^"_HDDoDate 
			Set InputStr = InputStr_"^"_HDDoMethod
			Set InputStr = InputStr_"^"_""             // 透析频率
			Set InputStr = InputStr_"^"_HDFreqTime
			Set InputStr = InputStr_"^"_AccessTypeDr
			Set InputStr = InputStr_"^"_BATypeBody
			Set InputStr = InputStr_"^"_"1"            // 是否有效
			Set InputStr = InputStr_"^"_""
			Set InputStr = InputStr_"^"_""
			Set BPRecDr  = ##class(DHCHAI.DP.BPRecord).Update(InputStr,"^")
			
		    //根据透析记录ID获取血管通路列表
		    Set rsvas=##Class(%ResultSet).%New("web.DHCBPInterface:FindBPVascularAccess")
		  	Set scvas=rsvas.Execute(bpaId)
		  	If $$$ISERR(scvas) {
			  	Do $System.Status.DisplayError(scvas)
		  	}
		  	Set (AccessDr,VascularAccess,BodySite,BuildingDate,StartDate,Status,PatMRCICD,Reason,UpdateUser,UpdateDate)=""
		  	While (rsvas.Next()){
			  	Set AccessDr       = rsvas.Data("Id")             // 血管通路类型ID 
			    Set VascularAccess = rsvas.Data("VascularAccess") // 通路类型
			    Set BodySite       = rsvas.Data("BodySite")       // 建立部位
			    Set BuildingDate   = rsvas.Data("BuildingDate")   // 建立日期
			    Set StartDate      = rsvas.Data("StartDate")      // 启动日期
			    Set Status         = rsvas.Data("Status")         // 状态
			    Set Reason         = rsvas.Data("Reason")         // 备注
			    Set UpdateUser     = rsvas.Data("UpdateUser")     // 创建者
			    Set UpdateDate     = rsvas.Data("UpdateDate")     // 更新日期
			    Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("BPAccessType",VascularAccess)
				If ('$IsObject(objDic)){
					Set DicStr = ""
					Set DicStr = DicStr_"^"_VascularAccess
					Set DicStr = DicStr_"^"_VascularAccess
					Set DicStr = DicStr_"^"_$o(^DHCHAI.BT.DicTypeI("IdxofCode","BPAccessType",0))
					Set DicStr = DicStr_"^"_"99^1"
					Set AccessTypeDr = ##class(DHCHAI.BT.Dictionary).Update(DicStr,"^")
				}Else{
					Set AccessTypeDr = objDic.%Id()
				}
			   	Set AccID=$o(^MA.HAI.DP.BPAccessTypeI("IndexBARegAccessID"," "_BPRegDr," "_AccessDr,0))
			    // 3，保存血管通路类型
			    Set InputStr = AccID
				Set InputStr = InputStr_"^"_AccessDr
				Set InputStr = InputStr_"^"_BPRegDr
				Set InputStr = InputStr_"^"_AccessTypeDr
				Set InputStr = InputStr_"^"_BodySite
				Set InputStr = InputStr_"^"_Status
				Set InputStr = InputStr_"^"_BuildingDate 
				Set InputStr = InputStr_"^"_StartDate
				Set InputStr = InputStr_"^"_""             // 停止日期
	 			Set InputStr = InputStr_"^"_BADoUser
				Set InputStr = InputStr_"^"_1              // 是否有效
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set BPAccDr  = ##class(DHCHAI.DP.BPAccessType).Update(InputStr,"^")
		  	}
			Set Count=Count+1
	    }
	}
	Set return=Count
	
	Quit return
}

}
