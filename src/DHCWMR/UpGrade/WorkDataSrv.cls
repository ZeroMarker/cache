/// 名称: DHCWMR.UpGrade.WorkDataSrv
/// 描述: 系统升级 业务数据处理
/// 编写者：zhufei
/// 编写日期: 2014-08-27
Class DHCWMR.UpGrade.WorkDataSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// ****************************************************
/// 一、升级需要重点检查方法
/// 1 病案拆分方法 ：##Class(DHCWMR.UpGrade.WorkDataSrv).ProcessAdmVol（未调试）
/// 2 处理卷状态方法 ：##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeVolStatus
/// 3 处理历史卷方法 ：##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeHisAdmInfo（未调试）
/// 4 获取卷步骤方法 ：##Class(DHCWMR.UpGrade.WorkDataSrv).GetVolStepInfo
/// 5 取号码类型方法 ：##class(DHCWMR.SSCustom.ReceiptSrv).GetNoTypeByMrTp
/// 
/// 二、升级业务数据执行方法
/// 1 业务数据处理方法 ：w ##Class(DHCWMR.UpGrade.WorkDataSrv).ProcWorkData()
/// 参数说明
/// 	1:按就诊分号需要病案拆分
///     0:按病人分号不需要拆分
/// 
/// 三、升级完成执行数据检查
/// 1 业务数据检查方法 ：w ##Class(DHCWMR.UpGrade.CheckDataSrv).CheckWorkData()
/// 参数说明
/// 	1:按就诊分号需要病案拆分
///     0:按病人分号不需要拆分
/// ****************************************************
ClassMethod ProcWorkData(aFlag As %String = 0)
{
	New (aFlag)
	
	//根据项目病案操作项目列表设置
	Set ^DHCWMR.UG.Config("OAStatusList")="|初始状态|"
	Set ^DHCWMR.UG.Config("ODStatusList")="|病案收回|回收待完善|收回整理|整理装订|病案编目|病案质控|主治签字|终末质控（等待）|终末质控（完成）|"
	Set ^DHCWMR.UG.Config("OSStatusList")="|归档上架|"
	Set ^DHCWMR.UG.Config("LStatusList")="|借阅病案|借阅归还|病案归还|归还病案|"
	Set ^DHCWMR.UG.Config("CStatusList")="|复印病案|复印归还|"
	Set ^DHCWMR.UG.Config("SStatusList")="|封存病案|病案解封|"
	Set ^DHCWMR.UG.Config("QStatusList")=""
	
	//处理病案号、检查号码类型
	Kill ^DHCWMR.SS.MrNoD
	Kill ^DHCWMR.SS.MrNoI
	Kill ^DHCWMR.SS.MrNoC
	Set flg=##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeMrNo()
	
	//处理病案主表
	Kill ^DHCWMR.SS.MainD
	Kill ^DHCWMR.SS.MainI
	Set flg=##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeMain()
	
	//处理病案卷表、操作记录表、卷状态表、卷基本信息表
	Kill ^DHCWMR.SS.VolumeD
	Kill ^DHCWMR.SS.VolumeI
	Kill ^DHCWMR.SS.BatchNumber
	Kill ^DHCWMR.SS.OperationD
	Kill ^DHCWMR.SS.OperationI
	Kill ^DHCWMR.SS.RequestD
	Kill ^DHCWMR.SS.RequestI
	Set flg=##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeVolume()
	
	//处理编目数据
	Kill ^DHCWMR.FP.FrontPageD
	Kill ^DHCWMR.FP.FrontPageI
	Set flg=##Class(DHCWMR.UpGrade.WorkDataSrv).ChangeFrontPage()
	
	//按就诊分号需要病案拆分,按病人分号不需要拆分
	Set:aFlag=1 flg=##Class(DHCWMR.UpGrade.WorkDataSrv).ProcessAdmVol()
	
	Quit "OK"
}

ClassMethod ChangeFrontPage()
{
	New
	
	Set xID="",Count=0
	For {
		Set xID=$o(^DHCWMRFP(xID),-1)
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRFP(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "编目记录：已处理 "_Count_" 条!",!
		
		Set VolumeDr=$p(tmpInfo,"^",1)
		Continue:VolumeDr=""
		
		Continue:'$d(^DHCWMRFPICD(0,"FP",xID)) //编目记录无明细退出
		
		Set FpID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolumeDr,"F",0))
		If FpID'="" {
			Write "编目记录重复,卷ID="_VolumeDr,!
			Continue //重复数据过滤
		}
		
		Set ^DHCWMR.FP.FrontPageD=xID-1
		Set InputStr=""_"^"_VolumeDr                //卷ID
		Set InputStr=InputStr_"^"_"F"               //编目类型（首次、二次）
		Set InputStr=InputStr_"^"_1                 //是否完成
		Set InputStr=InputStr_"^"_$p(tmpInfo,"^",4) //创建日期
		Set InputStr=InputStr_"^"_$p(tmpInfo,"^",5) //创建时间
		Set InputStr=InputStr_"^"_$p(tmpInfo,"^",3) //创建人
		Set InputStr=InputStr_"^"_$p(tmpInfo,"^",3) //修改人
		Set InputStr=InputStr_"^"_$p(tmpInfo,"^",2) //备注信息
		Set flg=##class(DHCWMR.FP.FrontPage).Update(InputStr,"^")
		If flg'=xID {
			Write "编目主表："_xID_"'="_flg_","_InputStr,!
		} Else {
			Set flg=..ChangeFPICD(xID)
			If (+flg)<1 {
				Write "编目诊断表：ret="_xID,!
			}
		}
	}
	Set ^DHCWMR.FP.FrontPageD=$o(^DHCWMR.FP.FrontPageD(""),-1)
	
	Quit Count
}

ClassMethod ChangeFPICD(aFrontPageID As %String)
{
	New (aFrontPageID)
	Set return=0
	Quit:aFrontPageID="" return
	
	Set ICDVer=+$g(^DHCWMRICDSetting("D"))
	Set OPRVer=+$g(^DHCWMRICDSetting("O"))
	
	Set DRowIndex=0,ORowIndex=0
	Set xFPIcdID=0,Count=0
	For {
		Set xFPIcdID=$o(^DHCWMRFPICD(0,"FP",aFrontPageID,xFPIcdID))
		Quit:xFPIcdID=""
		
		Set tmpFPICD=$g(^DHCWMRFPICD(xFPIcdID))
		Continue:tmpFPICD=""
		
		Set ICDType=$p(tmpFPICD,"^",10)  //诊断手术分类
		Continue:ICDType=""
		Set ICDTypeCode=$p($g(^DHCWMRDIC(ICDType)),"^",2)
		Continue:(ICDTypeCode'="D")&&(ICDTypeCode'="O")
		
		If ICDTypeCode="D" {  //诊断
			Set ICDDr=$p(tmpFPICD,"^",2)
			Continue:ICDDr=""
			Set:ICDVer=1 ICDDr=$o(^DHCWMR.FP.ICDDxI("IndexMRCDr"," "_ICDDr,0))
			Continue:ICDDr=""
			
			Set DRowIndex=+$p(tmpFPICD,"^",11)
			Set TypeID=$p(tmpFPICD,"^",14)
			Set AdmitCond=$p(tmpFPICD,"^",3)
			Set DischCond=""
			Set IsDefinite=$p(tmpFPICD,"^",12)
			
			Set Count=Count+1
			
			Set InputStr=aFrontPageID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_""  //诊断版本
			Set InputStr=InputStr_"^"_DRowIndex
			Set InputStr=InputStr_"^"_ICDDr
			Set InputStr=InputStr_"^"_TypeID
			Set InputStr=InputStr_"^"_AdmitCond
			Set InputStr=InputStr_"^"_DischCond
			Set InputStr=InputStr_"^"_IsDefinite
			Set InputStr=InputStr_"^"_""  //首页数据
			Set InputStr=InputStr_"^"_""  //暂存数据
			Set flg=##class(DHCWMR.FP.FPDiagnos).Update(InputStr,"^")
			If (+flg)<1 {
				Write "编目诊断表：ret="_flg_","_InputStr,!
				Continue
			}
		}
		If ICDTypeCode="O" {  //手术
			Set ICDDr=$p(tmpFPICD,"^",2)
			Continue:ICDDr=""
			Set:OPRVer=1 ICDDr=$o(^DHCWMR.FP.ICDDxI("IndexORCDr"," "_ICDDr,0))
			Continue:ICDDr=""
			
			Set DRowIndex=+$p(tmpFPICD,"^",11)
			Set TypeID=$p(tmpFPICD,"^",14)
			Set SttDate=$p(tmpFPICD,"^",13)
			Set SttTime=""
			Set EndDate=""
			Set EndTime=""
			Set Operator=$p(tmpFPICD,"^",4)
			Set:(+Operator)=0 Operator=""
			Set Assistant1=$p(tmpFPICD,"^",5)
			Set:(+Assistant1)=0 Assistant1=""
			Set Assistant2=$p(tmpFPICD,"^",6)
			Set:(+Assistant2)=0 Assistant2=""
			Set NarcosisType=$p(tmpFPICD,"^",7)
			Set NarcosisDoc=$p(tmpFPICD,"^",8)
			Set:(+NarcosisDoc)=0 NarcosisDoc=""
			Set OperatorTxt=""
			Set Assistant1Txt=""
			Set Assistant2Txt=""
			Set NarcosisDocTxt=""
			Set CutType=""
			Set Healing=""
			Set OperLevel=$p(tmpFPICD,"^",15)
			
			Set tmpCloseUp=$p(tmpFPICD,"^",9)
			Set tmpCloseUp=$p($g(^DHCWMRDIC(+tmpCloseUp)),"^",3)
			If tmpCloseUp'="" {
				//Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPCutType",$p(tmpCloseUp,"/",1))
				Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("FPCutType",$p(tmpCloseUp,"/",1))
				If $IsObject(objDic) Set CutType=objDic.%Id()
				//Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPHealing",$p(tmpCloseUp,"/",2))
				Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("FPHealing",$p(tmpCloseUp,"/",2))
				If $IsObject(objDic) Set Healing=objDic.%Id()
			}
			
			Set OperatorTxt=$p($g(^SSU("SSUSR",+Operator)),"^",2)
			Set Assistant1Txt=$p($g(^SSU("SSUSR",+Assistant1)),"^",2)
			Set Assistant2Txt=$p($g(^SSU("SSUSR",+Assistant2)),"^",2)
			Set NarcosisDocTxt=$p($g(^SSU("SSUSR",+NarcosisDoc)),"^",2)
			Set tmpUserList=$p(tmpFPICD,"^",12)
			If $l(tmpUserList,"#")=4 {
				Set:$p(tmpUserList,"#",1)'="" OperatorTxt=$p(tmpUserList,"#",1)
				Set:$p(tmpUserList,"#",2)'="" NarcosisDocTxt=$p(tmpUserList,"#",2)
				Set:$p(tmpUserList,"#",3)'="" Assistant1Txt=$p(tmpUserList,"#",3)
				Set:$p(tmpUserList,"#",4)'="" Assistant2Txt=$p(tmpUserList,"#",4)
			}
			//Set:OperatorTxt=$p($g(^SSU("SSUSR",+Operator)),"^",2) Operator=""
			//Set:Assistant1Txt=$p($g(^SSU("SSUSR",+Assistant1)),"^",2) Assistant1=""
			//Set:Assistant2Txt=$p($g(^SSU("SSUSR",+Assistant2)),"^",2) Assistant2=""
			//Set:NarcosisDocTxt=$p($g(^SSU("SSUSR",+NarcosisDoc)),"^",2) NarcosisDoc=""
			
			Set Count=Count+1
			
			Set InputStr=aFrontPageID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_""  //诊断版本
			Set InputStr=InputStr_"^"_DRowIndex
			Set InputStr=InputStr_"^"_ICDDr
			Set InputStr=InputStr_"^"_TypeID
			Set InputStr=InputStr_"^"_SttDate
			Set InputStr=InputStr_"^"_SttTime
			Set InputStr=InputStr_"^"_EndDate
			Set InputStr=InputStr_"^"_EndTime
			Set InputStr=InputStr_"^"_Operator
			Set InputStr=InputStr_"^"_OperatorTxt
			Set InputStr=InputStr_"^"_Assistant1
			Set InputStr=InputStr_"^"_Assistant1Txt
			Set InputStr=InputStr_"^"_Assistant2
			Set InputStr=InputStr_"^"_Assistant2Txt
			Set InputStr=InputStr_"^"_NarcosisType
			Set InputStr=InputStr_"^"_NarcosisDoc
			Set InputStr=InputStr_"^"_NarcosisDocTxt
			Set InputStr=InputStr_"^"_CutType
			Set InputStr=InputStr_"^"_Healing
			Set InputStr=InputStr_"^"_OperLevel
			Set InputStr=InputStr_"^"_""  //首页数据
			Set InputStr=InputStr_"^"_""  //暂存数据
			Set flg=##class(DHCWMR.FP.FPOperation).Update(InputStr,"^")
			If (+flg)<1 {
				Write "编目手术表：ret="_flg_","_InputStr,!
				Continue
			}
		}
	}
	
	Quit Count
}

/// 病案拆分
ClassMethod ProcessAdmVol()
{
	New
	
	Set xMainID=0,Count=0
	For {
		Set xMainID=$o(^DHCWMRMAIN(xMainID))
		Quit:xMainID=""
		
		Set objMain=##class(DHCWMR.SS.Main).GetObjById(xMainID)
		Continue:'$IsObject(objMain)
		Set MrNo=objMain.SMMrNo
		
		Set xVolID=0,VolIndex=0
		For {
			Set xVolID=$o(^DHCWMRVOL(0,"Main",xMainID,xVolID))
			Quit:xVolID=""
			
			Set Count=Count+1
			Write:(Count#1000)=0 "病案拆分：已处理 "_Count_" 条!",!
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Set VolMrNo=$p($g(^DHCWMRVOL(xVolID)),"^",10)
			
			Set VolIndex=VolIndex+1
			If VolIndex=1 {
				Set objXMain=##class(DHCWMR.SS.Main).%OpenId(xMainID)
				Set objXMain.SMMrNo=$s(VolMrNo'="":VolMrNo,1:MrNo)
				Set sc=objXMain.%Save()
				If $System.Status.IsError(sc) {
			   		Do $System.OBJ.DisplayError(sc)
				} Else {
					Do objXMain.%Close()
				}
			} Else {
				Set objXMain=##class(DHCWMR.SS.Main).%New()
				Set objXMain.SMMrType    =  objMain.SMMrType
				Set objXMain.SMMrNo      =  $s(VolMrNo'="":VolMrNo,1:MrNo)
				Set objXMain.SMBuildDate =  objMain.SMBuildDate
				Set objXMain.SMBuildTime =  objMain.SMBuildTime
				Set objXMain.SMIsActive  =  objMain.SMIsActive
				Set objXMain.SMResume    =  objMain.SMResume
				Set sc=objXMain.%Save()
				If $System.Status.IsError(sc) {
			   		Do $System.OBJ.DisplayError(sc)
				} Else {
					Set tmpMainID=objXMain.%Id()
					Set SMBarcode=##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("01",tmpMainID)
					Set objXMain.SMBarcode=SMBarcode
					Set sc=objXMain.%Save()
					Do objXMain.%Close()
					
					//Set objXVol=##class(DHCWMR.SS.Volume).%New()
					//Set objXVol.SVMainDr=tmpMainID
					//Set sc=objXVol.%Save()
					Set objVol.SVMainDr=objXMain
					Set sc=objVol.%Save()
					If $System.Status.IsError(sc) {
				   		Do $System.OBJ.DisplayError(sc)
					} Else {
						//Do objXVol.%Close()
						Do objVol.%Close()
					}
				}
			}
		}
	}
	
	Quit Count
}

ClassMethod ChangeVolume()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRVOL(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRVOL(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "病案卷表：已处理 "_Count_" 条!",!
		
		Set Paadm=$p(tmpInfo,"^",2)
		Set HisAdm=$p(tmpInfo,"^",3)
		Set AdmInfo="",HisAdmInfo=""
		Set:Paadm'="" AdmInfo=$g(^PAADM(Paadm))
		Set:HisAdm'="" HisAdmInfo=$g(^DHCWMRHISADM(HisAdm))
		Continue:(AdmInfo="")&&(HisAdmInfo="")  //卷无就诊信息退出
		
		Set SVMainDr=$p(tmpInfo,"^",1)
		Continue:SVMainDr=""
		Set MainInfo=$g(^DHCWMRMAIN(SVMainDr))
		Continue:MainInfo=""  //卷无主表信息退出
		Set MrTypeID=+$p($g(^DHCWMRMAIN(SVMainDr)),"^",1)  //病案类型
		Set SVStatus=$p(tmpInfo,"^",6)
		Set SVIPTimes=+$p(tmpInfo,"^",9)
		Set SVIsActive=$p(tmpInfo,"^",7)
		Set SVIsActive=$s(SVIsActive["Y":1,1:0)
		Set SVResume=$tr(tmpInfo,"^","!")
		
		//主表无效，卷也无效
		Set IsActive=$p($g(^DHCWMRMAIN(+SVMainDr)),"^",6)
		Set:IsActive'["Y" SVIsActive=0
		
		//获取生成日期
		Set xStatusID=$o(^DHCWMRVOL(xID,"S",0))
		If xStatusID'="" {
			Set BuildDate=$p($g(^DHCWMRVOL(xID,"S",xStatusID)),"^",3)
			Set BuildTime=$p($g(^DHCWMRVOL(xID,"S",xStatusID)),"^",4)
		} Else {
			Set BuildDate=+$h
			Set BuildTime=$p($h,",",2)
		}
		Set SVBuildDate=BuildDate
		Set SVBuildTime=BuildTime
		
		//当前步骤（顺序、突发）、出院日期、回收日期
		Set tmpVolStep=..GetVolStepInfo(xID)
		If tmpVolStep'="" {
			Set SVOrdStep=$p(tmpVolStep,"^",1)
			Set SVIsLend=+$p(tmpVolStep,"^",2)
			Set SVIsCopy=+$p(tmpVolStep,"^",3)
			Set SVIsStore=+$p(tmpVolStep,"^",4)
			Set SVQCLock=+$p(tmpVolStep,"^",5)
			Set SVDischDate=$p(tmpVolStep,"^",6)
			Set SVBackDate=$p(tmpVolStep,"^",7)
		} Else {
			Set SVOrdStep="C"
			Set SVIsLend=0
			Set SVIsCopy=0
			Set SVIsStore=0
			Set SVQCLock=0
			Set SVDischDate=""
			Set SVBackDate=""
		}
		
		Set ^DHCWMR.SS.VolumeD=xID-1
		Set InputStr=""_"^"_SVMainDr
		Set InputStr=InputStr_"^"_SVStatus
		Set InputStr=InputStr_"^"_SVOrdStep
		Set InputStr=InputStr_"^"_SVIsLend
		Set InputStr=InputStr_"^"_SVIsCopy
		Set InputStr=InputStr_"^"_SVIsStore
		Set InputStr=InputStr_"^"_SVQCLock
		Set InputStr=InputStr_"^"_SVDischDate
		Set InputStr=InputStr_"^"_SVBackDate
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_SVBuildDate
		Set InputStr=InputStr_"^"_SVBuildTime
		Set InputStr=InputStr_"^"_SVIsActive
		Set InputStr=InputStr_"^"_"" //备注信息
		Set InputStr=InputStr_"^"_##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("02",xID) //卷条码
		Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
		If flg'=xID {
			Write "病案卷表："_xID_"'="_flg_","_InputStr,!
		} Else {
			Set flg=..ChangeVolPaadm(xID)
			If (+flg)<1 {
				Write "病案卷就诊表：ret="_xID,!
			}
			Set flg=..ChangeVolStatus(xID)
			If (+flg)<1 {
				Write "病案卷状态表：ret="_xID,!
			}
		}
	}
	Set ^DHCWMR.SS.VolumeD=$o(^DHCWMR.SS.VolumeD(""),-1)
	
	Quit Count
}

ClassMethod ChangeVolPaadm(aVolID As %String)
{
	New (aVolID)
	Set return=0
	Quit:aVolID="" return
	
	Set Paadm=$p($g(^DHCWMRVOL(aVolID)),"^",2)
	Set HisAdm=$p($g(^DHCWMRVOL(aVolID)),"^",3)
	Set AdmInfo="",HisAdmInfo=""
	
	Set:Paadm'="" AdmInfo=$g(^PAADM(Paadm))
	If AdmInfo'="" {
		Set flg=##class(DHCWMR.SS.VolPaadm).Update(aVolID,Paadm)
		If (+flg)<1 {
			Write "病案卷就诊表1：ret="_flg_","_aVolID_","_Paadm,!
			Quit return
		}
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCWMRVOL(aVolID,"ADM",xSubID))
			Quit:xSubID=""
			Set yPaadm=$g(^DHCWMRVOL(aVolID,"ADM",xSubID))
			Continue:yPaadm=""
			Continue:Paadm=yPaadm
			Set flg=##class(DHCWMR.SS.VolPaadm).Update(aVolID,Paadm)
			If (+flg)<1 {
				Write "病案卷就诊表2：ret="_flg_","_aVolID_","_Paadm,!
			}
		}
	}
	
	Set:HisAdm'="" HisAdmInfo=$g(^DHCWMRHISADM(HisAdm))
	If HisAdmInfo'="" {
		Set flg=..ChangeHisAdmInfo(aVolID)
		If (+flg)<1 {
			Write "病案卷就诊表3：ret="_flg_","_aVolID_","_HisAdm,!
			Quit return
		}
	}
	
	Set return=1
	Quit return
}

ClassMethod ChangeHisAdmInfo(aVolumeID As %String)
{
	New (aVolumeID)
	Set return=0
	Quit:aVolumeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolumeID)
	Quit:'$IsObject(objVol) return
	
	Set MainID=$p($g(^DHCWMRVOL(aVolumeID)),"^",1)
	Quit:MainID="" return
	Set HisAdm=$p($g(^DHCWMRVOL(aVolumeID)),"^",3)
	Quit:HisAdm="" return
	Set HisAdmInfo=$g(^DHCWMRHISADM(HisAdm))
	Quit:HisAdmInfo="" return
	
	Set PatientID=$p($g(^DHCWMRMAIN(MainID)),"^",3)
	Set HisPatID=$p($g(^DHCWMRMAIN(MainID)),"^",4)
	Set IsDeath=$p($g(^DHCWMRMAIN(MainID)),"^",5)
	Set HisPatInfo="",PatInfo=""
	If HisPatID'="" {
		Set HisPatInfo=$g(^DHCWMRHISTORY(+HisPatID))
	}
	If HisPatInfo="" {
		Quit:PatientID="" return
		Set objPatient=##class(DHCWMR.Base.Patient).GetObjById(PatientID)
		Quit:'$IsObject(objPatient) return
	}
	
	Set obj=##Class(DHCWMR.SS.VolPaadm).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			  = objVol
	Set obj.VPPatientID       = PatientID
	Set obj.VPEpisodeID       = ""
	Set obj.VPAdmitStatus     = $p(HisAdmInfo,"^",5)
	Set obj.VPAdmitDate       = $p(HisAdmInfo,"^",2)
	Set obj.VPAdmitTime       = $p(HisAdmInfo,"^",3)
	Set obj.VPAdmitDept       = $p(HisAdmInfo,"^",4)
	Set obj.VPAdmitWard       = ""
	Set obj.VPAdmitDiagnos    = ""
	Set obj.VPEstimDischDate  = $p(HisAdmInfo,"^",6)
	Set obj.VPEstimDischTime  = $p(HisAdmInfo,"^",7)
	Set obj.VPDischDate       = $p(HisAdmInfo,"^",6)
	Set obj.VPDischTime       = $p(HisAdmInfo,"^",7)
	Set obj.VPDischDept       = $p(HisAdmInfo,"^",8)
	Set obj.VPDischWard       = ""
	Set obj.VPDischBed        = ""
	Set obj.VPDischDiagnos    = $p(HisAdmInfo,"^",9)
	Set obj.VPIsDeath         = $s(IsDeath="Y":1,1:0)
	Set obj.VPDeathDate       = ""
	Set obj.VPDeathTime       = ""
	
	If HisPatInfo'="" {
		Set obj.VPPatName         = $p(HisPatInfo,"^",1)
		Set obj.VPNameSpell       = $p(HisPatInfo,"^",2)
		Set obj.VPSex             = $p(HisPatInfo,"^",3)
		Set obj.VPBirthday        = $p(HisPatInfo,"^",4)
		Set obj.VPAge             = $p(HisPatInfo,"^",5)
		Set obj.VPWedlock         = $p(HisPatInfo,"^",6)
		Set obj.VPOccupation      = $p(HisPatInfo,"^",7)
		Set obj.VPRegAddress      = ""
		Set obj.VPRegProvince     = ""
		Set obj.VPRegCity         = $p(HisPatInfo,"^",8)
		Set obj.VPRegCounty       = $p(HisPatInfo,"^",9)
		Set obj.VPNation          = $p(HisPatInfo,"^",10)
		Set obj.VPNationality     = $p(HisPatInfo,"^",11)
		Set obj.VPIdentityCode    = $p(HisPatInfo,"^",12)
		Set obj.VPCompany         = $p(HisPatInfo,"^",13)
		Set obj.VPCompanyTel      = $p(HisPatInfo,"^",14)
		Set obj.VPCompanyZip      = $p(HisPatInfo,"^",15)
		Set obj.VPHomeAddress     = $p(HisPatInfo,"^",16)
		Set obj.VPHomeProvince    = ""
		Set obj.VPHomeCity        = ""
		Set obj.VPHomeCounty      = ""
		Set obj.VPHomeTel         = $p(HisPatInfo,"^",17)
		Set obj.VPHomeZip         = $p(HisPatInfo,"^",18)
		Set obj.VPRelationDesc    = $p(HisPatInfo,"^",19)
		Set obj.VPRelativeName    = $p(HisPatInfo,"^",20)
		Set obj.VPRelativeTel     = $p(HisPatInfo,"^",21)
		Set obj.VPRelativeAddress = $p(HisPatInfo,"^",22)
	} Else {
		Set NameSpell=$p($g(^PAPER(PatientID,"ALL")),"^",2)
		Set Birthday=objPatient.Birthday
		Set Birthday=##class(DHCWMR.SSService.CommonSrv).GetCacheDate(Birthday)
		Set Nationality=objPatient.Country
		Set:$p(Nationality,"-",2)'="" Nationality=$p(Nationality,"-",2)
		Set obj.VPPatName         = objPatient.PatientName
		Set obj.VPNameSpell       = NameSpell
		Set obj.VPSex             = objPatient.Sex
		Set obj.VPBirthday        = Birthday
		Set obj.VPAge             = objPatient.Age
		Set obj.VPWedlock         = objPatient.Marital
		Set obj.VPOccupation      = ""
		Set obj.VPRegAddress      = ""
		Set obj.VPRegProvince     = objPatient.Province
		Set obj.VPRegCity         = objPatient.City
		Set obj.VPRegCounty       = ""
		Set obj.VPNation          = objPatient.Nation
		Set obj.VPNationality     = Nationality
		Set obj.VPIdentityCode    = objPatient.PersonalID
		Set obj.VPCompany         = objPatient.WorkAddress
		Set obj.VPCompanyTel      = ""
		Set obj.VPCompanyZip      = ""
		Set obj.VPHomeAddress     = objPatient.Address
		Set obj.VPHomeProvince    = ""
		Set obj.VPHomeCity        = ""
		Set obj.VPHomeCounty      = ""
		Set obj.VPHomeTel         = objPatient.Telephone
		Set obj.VPHomeZip         = ""
		Set obj.VPRelationDesc    = objPatient.Relation
		Set obj.VPRelativeName    = objPatient.RelativeName
		Set obj.VPRelativeTel     = objPatient.RelativeTelephone
		Set obj.VPRelativeAddress = objPatient.RelativeAddress
	}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Quit return
}

ClassMethod ChangeVolStatus(aVolID As %String)
{
	New (aVolID)
	Set return=0
	Quit:aVolID="" return
	
	Set MainID=$p($g(^DHCWMRVOL(aVolID)),"^",1)
	Quit:MainID="" return
	Set MrTypeID=$p($g(^DHCWMRMAIN(MainID)),"^",1)  //病案类型
	Quit:MrTypeID="" return
	
	Set xSubID=0,Count=0
	For {
		Set xSubID=$o(^DHCWMRVOL(aVolID,"S",xSubID))
		Quit:xSubID=""
		
		Set tmpStatus=$g(^DHCWMRVOL(aVolID,"S",xSubID))
		Continue:tmpStatus=""
		Set StatusID=$p(tmpStatus,"^",1)
		Continue:StatusID=""
		Set StatusDesc=$p($g(^DHCWMRWITM(StatusID)),"^",2)
		Set UserFromDr=$p(tmpStatus,"^",2)
		Set CurrDate=$p(tmpStatus,"^",3)
		Set CurrTime=$p(tmpStatus,"^",4)
		Set UserToDr=$p(tmpStatus,"^",5)
		Set BatchNumber=..GetBatchNumber()
		Set VSResume=$tr(tmpStatus,"^","!")
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_MrTypeID
		Set InputStr=InputStr_"^"_StatusID
		Set InputStr=InputStr_"^"_UserFromDr
		Set InputStr=InputStr_"^"_CurrDate
		Set InputStr=InputStr_"^"_CurrTime
		Set InputStr=InputStr_"^"_UserToDr
		Set InputStr=InputStr_"^"_BatchNumber
		Set InputStr=InputStr_"^"_"1" //是否有效
		Set InputStr=InputStr_"^"_""  //备注信息
		Set flg=##class(DHCWMR.SS.Operation).Update(InputStr,"^")
		If (+flg)<1 {
			Write "病案卷操作表：ret="_flg_","_InputStr,!
			Continue
		}
		
		Set Count=Count+1
		Set ^DHCWMR.SS.VolumeD(aVolID,"S")=xSubID-1
		Set InputStr=aVolID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_StatusID
		Set InputStr=InputStr_"^"_UserFromDr
		Set InputStr=InputStr_"^"_CurrDate
		Set InputStr=InputStr_"^"_CurrTime
		Set InputStr=InputStr_"^"_UserToDr
		Set InputStr=InputStr_"^"_BatchNumber
		Set InputStr=InputStr_"^"_""  //撤销操作
		Set InputStr=InputStr_"^"_""  //撤销日期
		Set InputStr=InputStr_"^"_""  //撤销时间
		Set InputStr=InputStr_"^"_""  //撤销人
		Set InputStr=InputStr_"^"_""  //撤销原因
		Set InputStr=InputStr_"^"_""  //备注信息
		Set InputStr=InputStr_"^"_""  //病历分类
		Set InputStr=InputStr_"^"_""  //申请单
		Set InputStr=InputStr_"^"_""  //关联操作
		Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
		If (+flg)<1 {
			Write "病案卷状态表：ret="_flg_","_InputStr,!
		}
	}
	
	Quit Count
}

ClassMethod GetBatchNumber() As %String
{
	New
	Set return=""
	Set xDate=$zd(+$h-1,3)
	Set num=$i(^DHCWMR.SS.BatchNumber(xDate))
	If $l(num)<13 {
		Set $p(return,"0",13-$l(num))=num
	} Else {
		Set return=num
	}
	Set return="B"_return
	Quit return
}

ClassMethod ChangeMain()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRMAIN(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRMAIN(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "病案主表：已处理 "_Count_" 条!",!
		
		Set SMMrType=$p(tmpInfo,"^",1)
		Set SMMrNo=$p(tmpInfo,"^",2)
		Set SMBuildDate=+$p(tmpInfo,"^",8)
		Set SMBuildTime=0
		Set SMIsActive=$p(tmpInfo,"^",6)
		Set SMIsActive=$s(SMIsActive["Y":1,1:0)
		Set SMResume=$tr(tmpInfo,"^","!")
		
		Set ^DHCWMR.SS.MainD=xID-1
		Set InputStr=""_"^"_SMMrType
		Set InputStr=InputStr_"^"_SMMrNo
		Set InputStr=InputStr_"^"_SMBuildDate
		Set InputStr=InputStr_"^"_SMBuildTime
		Set InputStr=InputStr_"^"_SMIsActive
		Set InputStr=InputStr_"^"_""          //备注信息
		Set InputStr=InputStr_"^"_""          //标识/标记（如：高干、VIP、生殖科标记、妇科标记等）
		Set InputStr=InputStr_"^"_""          //归档号（归档上架号）
		Set InputStr=InputStr_"^"_##Class(DHCWMR.SSService.CommonSrv).FormatBarcode("01",xID)  //病案条码
		Set InputStr=InputStr_"^"_""          //建档人
		Set InputStr=InputStr_"^"_""          //初诊院区
		Set InputStr=InputStr_"^"_""          //初诊科室
		Set InputStr=InputStr_"^"_""          //初诊医生
		Set InputStr=InputStr_"^"_""          //初诊日期
		Set InputStr=InputStr_"^"_""          //初诊就诊
		Set InputStr=InputStr_"^"_""          //病人来源
		Set InputStr=InputStr_"^"_""          //急诊来源
		Set InputStr=InputStr_"^"_""          //就诊状态
		Set InputStr=InputStr_"^"_""          //指初始记录（修改病案号会记录）		
		Set flg=##class(DHCWMR.SS.Main).Update(InputStr,"^")
		If flg'=xID {
			Write "病案主表："_xID_"'="_flg_","_InputStr,!
		}
	}
	Set ^DHCWMR.SS.MainD=$o(^DHCWMR.SS.MainD(""),-1)
	
	Quit Count
}

ClassMethod ChangeMrNo()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRNO(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRNO(xID))
		Continue:tmpInfo=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "病案号表：已处理 "_Count_" 条!",!
		
		//取病案号对应号码类型
		Set MNMrType=$p(tmpInfo,"^",1)
		Set MNMrNo=$p(tmpInfo,"^",2)
		Continue:(MNMrType="")||(MNMrNo="")
		Set MNIsActive=$p(tmpInfo,"^",3)
		Continue:MNIsActive'="Y"
		Set MNIsActive=$s(MNIsActive["Y":1,1:0)
		
		//检查病案号是否被使用
		Set xMainID=0,CurrMainID=""
		For {
			Set xMainID=$o(^DHCWMRMAIN(0,"TypeNO",MNMrType,MNMrNo,xMainID))
			Quit:xMainID=""
			Quit:CurrMainID'=""
			Continue:$p($g(^DHCWMRMAIN(xMainID)),"^",6)'="Y"
			Set CurrMainID=xMainID
		}
		Continue:CurrMainID'=""
		
		Set ret=..GetNoTypeByMrTp(MNMrType,MNMrNo)
		If (+ret)<0 {
			Write "病案号表："_xID_",号码类型为空,MrTypeID="_MNMrType_",MrNo="_MNMrNo,!
			Continue
		} Else {
			Set MNNoType=$p(ret,"^",2)
		}
		
		Set MNActLoc=$p(tmpInfo,"^",4)
		Set MNActUser=$p(tmpInfo,"^",5)
		Set MNActDate=$p(tmpInfo,"^",6)
		Set MNActTime=$p(tmpInfo,"^",7)
		Set MNResume=$tr(tmpInfo,"^","!")
		
		Set ^DHCWMR.SS.MrNoD=xID-1
		Set InputStr=""_"^"_MNMrType
		Set InputStr=InputStr_"^"_MNMrNo
		Set InputStr=InputStr_"^"_MNNoType
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_MNActLoc
		Set InputStr=InputStr_"^"_MNActUser
		Set InputStr=InputStr_"^"_MNActDate
		Set InputStr=InputStr_"^"_MNActTime
		Set InputStr=InputStr_"^"_MNIsActive
		Set InputStr=InputStr_"^"_"" //备注信息
		Set flg=##class(DHCWMR.SS.MrNo).Update(InputStr,"^")
		If flg'=xID {
			Write "病案号表："_xID_"'="_flg_","_InputStr,!
		}
	}
	Set ^DHCWMR.SS.MrNoD=$o(^DHCWMR.SS.MrNoD(""),-1)
	
	Quit Count
}

/// w ##Class(DHCWMR.UpGrade.WorkDataSrv).GetNoTypeByMrTp(7)
ClassMethod GetNoTypeByMrTp(aMrTypeID As %String, aMrNo As %String = "") As %String
{
	New (aMrTypeID,aMrNo)
	Set return=-1
	Quit:(aMrTypeID="") return
	
	Set xSub="",NoTypeID=""
	For {
		Set xSub=$o(^DHCWMR.SS.MrTypeD(aMrTypeID,"NT",xSub))
		Quit:xSub=""
		Quit:NoTypeID'=""
		
		Set NoTypeID=aMrTypeID_"||"_xSub
		Set objNoType = ##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
		Continue:'$IsObject(objNoType)
		Continue:objNoType.NTIsActive'=1
		Continue:objNoType.NTIsDefault'=1
		Set NoTypeID=objNoType.%Id()
	}
	Quit:NoTypeID="" return
	
	Set return="1^"_NoTypeID
	Quit return
}

ClassMethod GetVolStepInfo(aVolID)
{
	New (aVolID)
	Set return=""
	Quit:aVolID="" return
	
	Set OAStatusList = $g(^DHCWMR.UG.Config("OAStatusList"))
	Set ODStatusList = $g(^DHCWMR.UG.Config("ODStatusList"))
	Set OSStatusList = $g(^DHCWMR.UG.Config("OSStatusList"))
	Set QStatusList = $g(^DHCWMR.UG.Config("QStatusList"))
	Set LStatusList = $g(^DHCWMR.UG.Config("LStatusList"))
	Set CStatusList = $g(^DHCWMR.UG.Config("CStatusList"))
	Set SStatusList = $g(^DHCWMR.UG.Config("SStatusList"))
	
	//获取出院日期
	Set DischDate=""
	Set Paadm=$p($g(^DHCWMRVOL(aVolID)),"^",2)
	Set HisAdm=$p($g(^DHCWMRVOL(aVolID)),"^",3)
	If Paadm'="" {
		Set tmpDischDate=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(Paadm)
		Set DischDate=$p(tmpDischDate,"^",1)
	} ElseIf HisAdm'="" {
		Set DischDate=$p($g(^DHCWMRHISADM(+HisAdm)),"^",6)
	} Else {}
	
	Set OStatusFlag=1,IsLend=0,IsCopy=0,IsStore=0,QCStatus=0
	
	//检查状态表
	Set StatusDescStr=""
	Set BackDate=""
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCWMRVOL(aVolID,"S",xSubID))
		Quit:xSubID=""
		//Quit:BackDate'=""  update by zf 20150319
		
		Set StatusID=$p($g(^DHCWMRVOL(aVolID,"S",xSubID)),"^",1)
		Continue:StatusID=""
		Set StatusDesc=$p($g(^DHCWMRWITM(StatusID)),"^",2)
		Set StatusDescStr=StatusDescStr_"|"_StatusDesc
		If ODStatusList[("|"_StatusDesc_"|") {
			Set:BackDate="" BackDate=$p($g(^DHCWMRVOL(aVolID,"S",xSubID)),"^",3)
			Set:OStatusFlag<2 OStatusFlag=2
		} ElseIf OSStatusList[("|"_StatusDesc_"|") {
			Set:OStatusFlag<3 OStatusFlag=3
		} Else {}
		Set:LStatusList[("|"_StatusDesc_"|") IsLend=1
		Set:CStatusList[("|"_StatusDesc_"|") IsCopy=1
		Set:SStatusList[("|"_StatusDesc_"|") IsStore=1
		Set:QStatusList[("|"_StatusDesc_"|") QCStatus=-1
	}
	
	//卷状态特殊处理
	Set VolStatus=$p($g(^DHCWMRVOL(aVolID)),"^",6)
	Quit:VolStatus="" return
	Set StatusDesc=$p($g(^DHCWMRWITM(+VolStatus)),"^",2)
	Set StatusDescStr=StatusDesc_StatusDescStr
	If OAStatusList[("|"_StatusDesc_"|") {
		Set OStatusFlag=1
	} ElseIf ODStatusList[("|"_StatusDesc_"|") {
		Set OStatusFlag=2
	} ElseIf OSStatusList[("|"_StatusDesc_"|") {
		Set OStatusFlag=3
	} Else {}
	Set:LStatusList[("|"_StatusDesc_"|") IsLend=1
	Set:CStatusList[("|"_StatusDesc_"|") IsCopy=1
	Set:SStatusList[("|"_StatusDesc_"|") IsStore=1
	Set:QStatusList[("|"_StatusDesc_"|") QCStatus=-1
	
	Set OrdStep="A"
	Set:OStatusFlag=1 OrdStep="A"
	Set:OStatusFlag=2 OrdStep="D"
	Set:OStatusFlag=3 OrdStep="S"
	
	Set return=OrdStep_"^"_IsLend_"^"_IsCopy_"^"_IsStore_"^"_QCStatus_"^"_DischDate_"^"_BackDate_"^"_StatusDescStr
	Quit return
}

}
