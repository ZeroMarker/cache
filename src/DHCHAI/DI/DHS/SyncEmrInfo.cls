/// 名称: DHCHAI.DI.DHS.SyncEmrInfo
/// 描述: 同步东华电子病历数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncEmrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-09-15
/// Description:  根据日期同步东华病历数据
/// Input：       aEpisodeID：就诊号
/// 			  aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrByDateAdm("EMR01","HIS01||50388041","2018-01-01","2018-04-08")
ClassMethod SyncEmrByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncEmrByDateAdmErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="EMR" return  //电子病历系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	//二版电子病历2.0、三版电子病历3.0
	//Set EMRSystemVer=##class(DHCHAI.BT.Config).GetValByCode("DPEMRSystemVer")
	
	Set arrEmrCode=##class(%ListOfDataTypes).%New()
	Set EmrCodeStr=##class(DHCHAI.BT.Config).GetValByCode("DPEmrDailyCourseCode","")	//日常病程
	Set EmrCodeStr2=##class(DHCHAI.BT.Config).GetValByCode("DPEmrFirstCourseCode","")	//首程（病例特点、初步诊断、诊断依据）
	Set EmrCodeStr3=##class(DHCHAI.BT.Config).GetValByCode("DPEmrAdmDiagnosCode","")	//入院记录（初步诊断、鉴别诊断）
	Set EmrCodeStr4=##class(DHCHAI.BT.Config).GetValByCode("DPEmrDisDiagnosCode","")	//出院记录（出院诊断）
	Set IsSyncTCMPage = ##class(DHCHAI.BT.Config).GetValByCode("DPEmrIsSyncTCMPage")  // 1：同步
    If (EmrCodeStr4="")&&(IsSyncTCMPage=1) {
		Set EmrCodeStr4=##class(DHCHAI.BT.Config).GetValByCode("DPEmrTCMDisDiagnosCode","")	//东华中医住院病案首页术语集代码
    }
	Set EmrCodesList=$lb(EmrCodeStr,EmrCodeStr2,EmrCodeStr3,EmrCodeStr4)
	
	For indList=1:1:$ll(EmrCodesList){
		Set DocType=""
		Set:indList=1 DocType="日常病程"
		Set:indList=2 DocType="首程"
		Set:indList=3 DocType="入院记录"
		Set:indList=4 DocType="出院记录"
		Set EmrCodeStr=$listget(EmrCodesList,indList)
		Continue:EmrCodeStr=""
		For indEC=1:1:$l(EmrCodeStr,",") {
			Set tEmrCodeStr=$p(EmrCodeStr,",",indEC)
			Continue:tEmrCodeStr=""
			Set TitleSub=$p(tEmrCodeStr,":",1)
			Set EmrCodes=$p(tEmrCodeStr,":",2)
			Continue:(TitleSub="")||(EmrCodes="")
			Set tEmrCodeStr=DocType_"|"_TitleSub_":"_EmrCodes
			Do arrEmrCode.Insert(tEmrCodeStr)
		}
	}
	
	For indEC=1:1:arrEmrCode.Count() {
		Set tEmrCodeStr=arrEmrCode.GetAt(indEC)
		Continue:tEmrCodeStr=""
		Set DocType=$p(tEmrCodeStr,":",1)
		Set EmrCodes=$p(tEmrCodeStr,":",2)
		Set DocTypeDesc=$p(DocType,"|",1)
		Set DocTitleSub=$p(DocType,"|",2)
		Continue:(DocTypeDesc="")||(DocTitleSub="")||(EmrCodes="")
		
		//文档类型
		Set objDocType=##class(DHCHAI.DP.EmrDocType).GetObjByCodeDesc("",DocTypeDesc)
		Continue:'$IsObject(objDocType)
		Set DocTypeDr=objDocType.%Id()
		
		For indDT=1:1:$l(EmrCodes,"|") {
			Set tEmrCode=$p(EmrCodes,"|",indDT)
			Continue:tEmrCode=""
		    Set DiagnosCode = $p(tEmrCode,"#",1)
		    
			Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(EpisodeID,DiagnosCode,aDateFrom,aDateTo)

			Set xInstanceID=""
			For	{
			    Set value=arr.GetNext(.xInstanceID)
			    Quit:xInstanceID=""
			    
				Set XCode    	= $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
				Set DocTitle    = $p(value,$c(1),1)          // 标题
				Set DocDate     = $p(value,$c(1),2)          // 文档日期
				Set ActDate     = $p(value,$c(1),2)          // 发生日期
				Set ActTime     = $p(value,$c(1),3)          // 发生时间
				Set ActUserID   = $p(value,$c(1),6)          // 填写医生
				Set ActUserCode = $p(value,$c(1),7)          // 医生代码
				Set ActUserDesc = $p(value,$c(1),8)          // 医生名称
				Set GlossaryCode= $p(value,$c(1),9)          // 术语集代码
				Set GlossaryDesc= $p(value,$c(1),10)         // 术语集名称
				Set DocContent  = $p(value,$c(1),11)         // 病程内容
				Continue:GlossaryCode=""
				//Set DocContent  = $tr(DocContent," ","")
				//Set DocContent  = $tr(DocContent,$c(10),"")
				
				Set IsActive=1                               // 是否有效
				Set:DocContent="" IsActive=0
				If DocTypeDesc["日常病程" {
					Set:$l(DocContent)<10 IsActive=0 //少于10个字符算无效
				} Else {
					Set:$l(DocContent)<1 IsActive=0 //少于1个字符算无效
				}
				
				Set EmrRecordDr=""
				Set objEmrRecord = ##class(DHCHAI.DP.EmrRecord).GetObjByXCode(aSCode,XCode,GlossaryCode)
				If $IsObject(objEmrRecord){
					Set EmrRecordDr=objEmrRecord.%Id()
				}
				
				//处理字符串超长问题 默认最长8000
				If $l(DocContent)>8000 {
					Set DocContent=$e(DocContent,1,8000)
				}
				
				Set InputStr = EmrRecordDr
				Set InputStr = InputStr_$c(1)_EpisodeDr
				Set InputStr = InputStr_$c(1)_DocTypeDr            // 文档类型
				Set InputStr = InputStr_$c(1)_DocTitle             // 文档标题
				Set InputStr = InputStr_$c(1)_DocDate              // 文档日期
				Set InputStr = InputStr_$c(1)_DocContent		   // 文档内容
				Set InputStr = InputStr_$c(1)_ActDate			   // 发生日期
				Set InputStr = InputStr_$c(1)_ActTime              // 发生时间
				Set InputStr = InputStr_$c(1)_ActUserID_"|"_ActUserCode_"|"_ActUserDesc  // 填写医生
				Set InputStr = InputStr_$c(1)_aSCode               // 子系统代码
				Set InputStr = InputStr_$c(1)_XCode				   // 记录索引码
				Set InputStr = InputStr_$c(1)_IsActive        	   // 有效标志
				Set InputStr = InputStr_$c(1)_+$h                  // 更新日期
				Set InputStr = InputStr_$c(1)_+$p($h,",",2)        // 更新时间
				Set InputStr = InputStr_$c(1)_GlossaryDesc         // 文档子标题(术语集名称)
				Set InputStr = InputStr_$c(1)_GlossaryCode         // 术语集代码
				Set EmrRecordDr = ##class(DHCHAI.DP.EmrRecord).Update(InputStr,$c(1))
				If (+EmrRecordDr)<0 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DP.EmrRecord"
					Set ErrMethod = "Update"
					Set $p(InputStr,$c(1),6)="详细内容略"  //字符串超长
					Set ErrArgStr = $lb(InputStr,$c(1))
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
				Quit:(+EmrRecordDr)<1
				
				Set Count = Count+1
			}
		}
	}

    Set return=Count
    Quit return
    
SyncEmrByDateAdmErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-27
/// Description:  根据EpisodeID同步患者电子病历出院诊断证明书
/// Table：       DHCHAI.DP.MRDiagnos
/// Input：       aEpisodeIDX : 东华HIS就诊ID
/// Return：      返回处理条数
/// w ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrDiagnos("HIS01","HIS01||54680247","2019-09-20","2019-09-26")
ClassMethod SyncEmrDiagnos(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	// update 20190920 先把病人所有诊断无效
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		//把非临床诊断置成无效，使用索引更好
		Set objDiag= ##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
	    Continue:'$IsObject(objDiag)
	    Continue:(objDiag.MRDiagSource'="E")&&(objDiag.MRDiagSource'="D")
	    
		D ##class(DHCHAI.DP.MRDiagnos).CancelById(xID)
	}
	//add chenjb 20211124 定时任务生成的出院诊断疑似记录删除
	Set DisInfID  = $o(^DHCHAI.IR.CCDiagnosI("IndexEpisodeDr",EpisodeDr,0))
	Set objDisInf = ##class(DHCHAI.IR.CCDiagnos).GetObjById(DisInfID)
	If ($IsObject(objDisInf)) {
		Set ActStatus  = objDisInf.IRStatus
		Set ActOpinion = objDisInf.IROpinion   // 处置意见
		Do:(ActStatus=2)&(ActOpinion="定时任务") ##class(DHCHAI.IR.CCDiagnos).DeleteById(DisInfID)
	}
	//调用取电子病历出院诊断记录接口
	Set DiagnosInfo = ..GetEmrDischDiagnos(EpisodeID,"","")
	Set DiagnosCount = $listlength(DiagnosInfo)
	Quit:DiagnosCount=0 return
	For Index = 1:1:DiagnosCount{
		Set TmpDiagnos = $list(DiagnosInfo,Index)
		Continue:TmpDiagnos=""
		
		Set XCode      = $list(TmpDiagnos,1)  //记录ID
		Set DiagDesc   = $list(TmpDiagnos,3)
		Set DiagNote   = $list(TmpDiagnos,4)
		Set DiagDesc   = $s(DiagDesc="":DiagNote,1:DiagDesc)
		Continue:(XCode="")||((DiagDesc="")&&(DiagNote=""))
		Set DiagSource = $list(TmpDiagnos,10)
		Set:DiagSource="" DiagSource="E"
		//检查诊断是否有效
		Set objICDDxMap=##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(aSCode,DiagDesc)
		If $IsObject(objICDDxMap) {
			Continue:objICDDxMap.BTIsActive'=1
		}
		
        Set DiagnosDr=""
        Set objDiagnos=##class(DHCHAI.DP.MRDiagnos).GetObjByXCode(aSCode,XCode)
        If $IsObject(objDiagnos) {
	        Set DiagnosDr=objDiagnos.%Id()
        }
        
        Set InputStr = DiagnosDr
		Set InputStr = InputStr_"^"_EpisodeDr					//就诊记录指针
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,2)			//诊断ICD10
		Set InputStr = InputStr_"^"_DiagDesc					//诊断名称
		Set InputStr = InputStr_"^"_DiagNote					//诊断备注
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,5)			//诊断类型代码
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,6)			//诊断类型描述
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,7)			//诊断日期
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,8)			//诊断时间
		Set InputStr = InputStr_"^"_DiagSource				    //诊断来源（C临床、E首页、F编目、D出院诊断书）
		Set InputStr = InputStr_"^"_aSCode						//子系统代码
		Set InputStr = InputStr_"^"_XCode						//记录索引码
		Set InputStr = InputStr_"^"_"1"							//有效标志
		Set InputStr = InputStr_"^"_+$h
		Set InputStr = InputStr_"^"_+$p($h,",",2)
		Set InputStr = InputStr_"^"_$list(TmpDiagnos,9)          //入院病情
	
		Set DiagnosDr = ##class(DHCHAI.DP.MRDiagnos).Update(InputStr,"^")
		If (+DiagnosDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.MRDiagnos"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
		Continue:(+DiagnosDr)<1
		//add chenjb 20211124 判断出院诊断是否是感染诊断
		Set xDisInfID=$o(^DHCHAI.IR.CCDiagnosI("IndexEpisodeDr",EpisodeDr,0))
		If ((DiagSource="D")||(DiagSource="E"))&((+xDisInfID)=0) {
			Set IsInfDiagFlg =##class(DHCHAI.IRS.INFDiagnosSrv).CheckInfDiag(DiagDesc)
			Set InputStrCCD  = EpisodeDr_"^"_"2"_"^"_"定时任务"_"^"  // 处置人为空
			Do:(IsInfDiagFlg=1) ##class(DHCHAI.IRS.CCDiagnosSrv).SaveCCDiagnos(InputStrCCD,"^")
        }        
		//计数
		Set Count=Count+1
		
		//诊断名称存入对照表 
		Set objMRICDDxMap=##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(aSCode,DiagDesc)
		If '$isobject(objMRICDDxMap){
			Set MapItemDr=""
			Set objMRICDDx=##class(DHCHAI.DP.MRICDDx).GetObjByCodeDesc("",DiagDesc)
			Set:$isobject(objMRICDDx) MapItemDr=objMRICDDx.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_DiagDesc					//诊断名称
			Set InputStr = InputStr_"^"_MapItemDr					//标准名称
			Set InputStr = InputStr_"^"_""							//标准备注
			Set InputStr = InputStr_"^"_aSCode						//子系统代码
			Set InputStr = InputStr_"^"_1							//有效标志
			Set InputStr = InputStr_"^"_""							//处置日期
			Set InputStr = InputStr_"^"_""							//处置时间
			Set InputStr = InputStr_"^"_""							//处置人
			Set ICDDxMapDr=##class(DHCHAI.DP.MRICDDxMap).Update(InputStr,"^")
			If (+ICDDxMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.MRICDDxMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
		// 诊断类型对照（重复记录不再处理）
		Set DiagTypeCode = $list(TmpDiagnos,5)	
		Set DiagTypeDesc = $list(TmpDiagnos,6)
		If (DiagTypeDesc'="")&&(DiagTypeCode'="") {
			Set InputStr=""
			Set $p(InputStr,"^",1)="DiagType"  // 诊断类型
			Set $p(InputStr,"^",2)=DiagTypeCode
			Set $p(InputStr,"^",3)=DiagTypeDesc
			Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
			If (+PhraseMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
				Set ErrMethod = "SavePhraseMap"
				Set ErrArgStr = $lb(InputStr,aSCode)
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-27
/// Description:  通过就诊号取患者电子病历出院诊断记录
/// Input：       aEpisodeID:就诊号
/// Return：      
/// w ##Class(DHCHAI.DI.DHS.SyncEmrInfo).GetEmrDischDiagnos(54680247,"2019-09-01","2019-09-28")
ClassMethod GetEmrDischDiagnos(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set $ZT="GetEmrDischDiagnosErr"
	Set IsSyncTCMPage = ##class(DHCHAI.BT.Config).GetValByCode("DPEmrIsSyncTCMPage")  // 1：同步
	Set EmrCodeStr=##class(DHCHAI.BT.Config).GetValByCode("DPEmrDisDiagnosCode","")	//东华住院病案首页术语集代码
    If (EmrCodeStr="")&&(IsSyncTCMPage=1) {
		Set EmrCodeStr=##class(DHCHAI.BT.Config).GetValByCode("DPEmrTCMDisDiagnosCode","")	//东华中医住院病案首页术语集代码
    }
	For indEC=1:1:$l(EmrCodeStr,",") {
		Set tEmrCodeStr=$p(EmrCodeStr,",",indEC)
		Continue:tEmrCodeStr=""
		Set TypeCode="DIS"
		Set TypeDesc=$p(tEmrCodeStr,":",1)
		Set EmrCodes=$p(tEmrCodeStr,":",2)
		Continue:(TypeDesc="")||(EmrCodes="")
		Continue:TypeDesc'="出院诊断"
		For indECs=1:1:$l(EmrCodes,"|") {
			Set tEmrCodes=$p(EmrCodes,"|",indECs)
			Continue:tEmrCodes=""
			Set DiagnosCode = $p(tEmrCodes,"#",1)
			Set AdmissionCode = $p(tEmrCodes,"#",2)
			Set DiagSource = $p(tEmrCodes,"#",3)
		    
			Set (ICD10,Note,ICDDesc,Admission)=""
			
			Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(aEpisodeID,DiagnosCode,"","")	
			
			Set xInstanceID=""
			For	{
			    Set value=arr.GetNext(.xInstanceID)
			    Quit:xInstanceID=""
			    
				Set InstanceID  = $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
			    Set DocTitle    = $p(value,$c(1),1)          // 标题
				Set DocDate     = $p(value,$c(1),2)          // 文档日期
				Set ActDate     = $p(value,$c(1),2)          // 发生日期
				Set ActTime     = $p(value,$c(1),3)          // 发生时间
				Set ActUserID   = $p(value,$c(1),6)          // 填写医生
				Set ActUserCode = $p(value,$c(1),7)          // 医生代码
				Set ActUserDesc = $p(value,$c(1),8)          // 医生名称
				Set GlossaryCode= $p(value,$c(1),9)          // 术语集代码
				Set GlossaryDesc= $p(value,$c(1),10)         // 术语集名称
				Set ICDDesc     = $p(value,$c(1),11)         // 诊断名称
			    Continue:ICDDesc=""
			  
			    Set arrAdmission=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(aEpisodeID,AdmissionCode,"","")
			  
			    Set AdmissionInfo=arrAdmission.GetNext(.xInstanceID)
			    Quit:AdmissionInfo=""    //不退出，错误数据死循环
			    Set Admission = $p(AdmissionInfo,$c(1),11)   //入院病情
			   
				Set Data = $lb(aEpisodeID_"||"_InstanceID_"||"_DiagnosCode,ICD10,ICDDesc,Note,TypeCode,TypeDesc,ActDate,ActTime,Admission,DiagSource)
				Set return = return_$lb(Data)
			}
		}
	}
	
	Quit return
GetEmrDischDiagnosErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2019-09-17
/// Description:  根据日期同步东华首程病程诊断数据
/// Input：       aEpisodeID：就诊号
/// 			  aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrAdmDiagnos("HIS01","HIS01||54808773","2019-10-23","2019-10-25")
ClassMethod SyncEmrAdmDiagnos(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncEmrAdmDiagnosErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="HIS" return  //HIS系统
		
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set EmrCodeStr=##class(DHCHAI.BT.Config).GetValByCode("DPEmrFirstDiagnosCode","")	//首程（初步诊断）
	For indEC=1:1:$l(EmrCodeStr,",") {
		Set tEmrCodeStr=$p(EmrCodeStr,",",indEC)
		Continue:tEmrCodeStr=""
		Set TypeCode="ADM"
		Set TypeDesc=$p(tEmrCodeStr,":",1)
		Set EmrCodes=$p(tEmrCodeStr,":",2)
		Continue:(TypeDesc="")||(EmrCodes="")

		Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(EpisodeID,EmrCodes,"","")
		Set DocContent=""
		Set xInstanceID=""
		For	{
		    Set value=arr.GetNext(.xInstanceID)
		    Quit:xInstanceID=""
		   
			Set XCode    	= $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
			Set DocTitle    = $p(value,$c(1),1)          // 标题
			Set DocDate     = $p(value,$c(1),2)          // 文档日期
			Set ActDate     = $p(value,$c(1),2)          // 发生日期
			Set ActTime     = $p(value,$c(1),3)          // 发生时间
			Set ActUserID   = $p(value,$c(1),6)          // 填写医生
			Set ActUserCode = $p(value,$c(1),7)          // 医生代码
			Set ActUserDesc = $p(value,$c(1),8)          // 医生名称
			Set GlossaryCode= $p(value,$c(1),9)          // 术语集代码
			Set GlossaryDesc= $p(value,$c(1),10)         // 术语集名称
			Set DocContent  = $p(value,$c(1),11)         // 内容
			Continue:GlossaryCode=""   
		}
		Continue:DocContent=""
	
		Set DocContent = $tr(DocContent,"入院诊断:","")
		For indDC =1:1:$l(DocContent,$c(10))  {
			Set Diagons = $p(DocContent,$c(10),indDC)
			Set Diagons = $tr(Diagons," ","")
			Continue:Diagons=""
			Continue:$l(Diagons)>50   //处理非标准的病历输入导致无法存储的情况 20191025
			Set DiagnosDr=""
	        Set objDiagnos=##class(DHCHAI.DP.MRDiagnos).GetObjByXCode(aSCode,XCode_"||"_EmrCodes_"||"_indDC)
	        If $IsObject(objDiagnos) {
		        Set DiagnosDr=objDiagnos.%Id()
	        }
       
	        Set InputStr = DiagnosDr
			Set InputStr = InputStr_"^"_EpisodeDr			//就诊记录指针
			Set InputStr = InputStr_"^"_""			        //诊断ICD10
			Set InputStr = InputStr_"^"_Diagons			    //诊断名称
			Set InputStr = InputStr_"^"_""					//诊断备注
			Set InputStr = InputStr_"^"_TypeCode			//诊断类型代码
			Set InputStr = InputStr_"^"_TypeDesc			//诊断类型描述
			Set InputStr = InputStr_"^"_ActDate			    //诊断日期
			Set InputStr = InputStr_"^"_ActTime  			//诊断时间
			Set InputStr = InputStr_"^"_"A"		            //诊断来源（C临床、E首页、F编目、D出院诊断书,A:首程）
			Set InputStr = InputStr_"^"_aSCode			    //子系统代码
			Set InputStr = InputStr_"^"_XCode_"||"_EmrCodes_"||"_indDC	 //记录索引码
			Set InputStr = InputStr_"^"_"1"					             //有效标志
			Set InputStr = InputStr_"^"_+$h
			Set InputStr = InputStr_"^"_+$p($h,",",2)
			Set InputStr = InputStr_"^"_""                                //入院病情
		   
			Set DiagnosDr = ##class(DHCHAI.DP.MRDiagnos).Update(InputStr,"^")
			
			If (+DiagnosDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.MRDiagnos"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
			Continue:(+DiagnosDr)<1
			//计数
			Set Count=Count+1
		}
	}
	
	Set return=Count
    Quit return
    
SyncEmrAdmDiagnosErr
	Set return="-999^"_$ZError
	Quit return
}

}
