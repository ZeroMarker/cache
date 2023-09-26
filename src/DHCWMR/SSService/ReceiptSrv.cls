/// 名称: DHCWMR.SSService.ReceiptSrv
/// 描述: 病案接诊服务
/// 编写者：liyi
/// 编写日期: 2014-08-29
Class DHCWMR.SSService.ReceiptSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2014-08-29
/// Description:  接诊主程序
/// Input：       EpisodeID:就诊ID
///               MrClass:病案分类
///               MrNo:病案号
///               LocID:接诊科室
///               UserID:接诊操作用户
/// Return:		  成功：>0，失败：<0
/// w ##class(DHCWMR.SSService.ReceiptSrv).GroupReceipt("5","","117","9","6||1")
ClassMethod GroupReceipt(aEpisodeID As %String, aMrNo As %String, aLocID As %String, aUserID As %String, aNoTypeID As %String = "") As %String
{
	New (aEpisodeID,aMrNo,aLocID,aUserID,aNoTypeID)
	Set return=-1_"^入参错误"
	Quit:(aEpisodeID="")||(aNoTypeID="")||(aLocID="")||(aUserID="") return
	
	//Set ^ZF=$lb(aEpisodeID,aMrNo,aLocID,aUserID,aNoTypeID)
	
	Set $ZT="GroupReceiptError"
	
	//如果入参病案号为空，则判断有无其他就诊卡对应的病案号
	Set:aMrNo="" aMrNo=..GetMrNoByEpisodeID(aEpisodeID)
	
	//接诊入口日志
	Set LogString ="^"_0_"^"_""_"^"_aMrNo_"^"_""_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=-2_"^就诊信息错误"
	Quit:'$d(^PAADM(aEpisodeID)) return
	Quit:$p($g(^PAADM(+aEpisodeID)),"^",20)="C" return    //取消就诊不建病案
	Quit:$p($g(^PAADM(+aEpisodeID)),"^",75)'="" return    //婴儿不建病案
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	If AdmType="I" {
    	Set tmpAdmitDept=##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(aEpisodeID)
    	Set AdmLoc=$p(tmpAdmitDept,",",1)
    	Set:AdmLoc="" AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	} Else {
    	Set AdmLoc=$p($g(^PAADM(+aEpisodeID)),"^",4)
	}
	Quit:AdmLoc="" return
	
	Set return=-3_"^当前就诊已建病历"
	Set xVolID="",VolumeID="",xMrNo = ""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
		Quit:xVolID=""
		Quit:VolumeID'=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Set VolumeID=objVol.%Id()
		Set xMrNo = objVol.SVMainDr.SMMrNo
	}
	Set return = return_"^^"_xMrNo
	Quit:VolumeID'="" return
	
	Set return=-4_"^号码类型错误"
	Set NoTypeID=aNoTypeID
	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
	Quit:'$IsObject(objNoType) return
	Set NoTypeID=objNoType.%Id()
	Set objMrType=objNoType.Parref
	Quit:'$IsObject(objMrType) return
	Set MrTypeID=objMrType.%Id()
	Set ReceiptType=""
	If $IsObject(objMrType.MTReceiptType) {
		Set ReceiptType=objMrType.MTReceiptType.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set RecycleType=+RecycleType
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	
	//病案记录、病案号、病人病案号、输入病案号
	Set MainID="",MrNo=""
	If ReceiptType="M" {
		Set xVolID=""
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_PatientID,xVolID))
			Quit:xVolID=""
			Quit:MainID'=""
			
			//add by zf 20150318 避免卷有效、就诊无效情况
			Set xSubID=0,IsActive=0
			For {
				Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_PatientID,xVolID,xSubID))
				Quit:xSubID=""
				Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSubID)
				Continue:'$IsObject(objVolPaadm)
				Set Paadm=objVolPaadm.VPEpisodeID
				Continue:Paadm=""
				Continue:$p($g(^PAADM(Paadm)),"^",20)="C"  //取消就诊
				Set IsActive=1
				Quit:IsActive=1
			}
			Continue:IsActive=0
			
			Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
			Continue:'$IsObject(objVol)
			Continue:objVol.SVIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr)
			Continue:objVol.SVMainDr.SMIsActive'=1
			Continue:'$IsObject(objVol.SVMainDr.SMMrType)
			Continue:objVol.SVMainDr.SMMrType.%Id()'=MrTypeID
			
			Set MainID=objVol.SVMainDr.%Id()
			Set MrNo=objVol.SVMainDr.SMMrNo
		}
		If (MainID="")&&(aMrNo="")&&(RecycleType=0)&&(NoFiled'="") {
			Set aMrNo=##class(DHCWMR.SSService.MrNoSrv).GetHisMrNo(PatientID,NoFiled)
		}
	}
	If (MainID="")&&(aMrNo'="") {
		//fix bug 108600 by pylian 2015-07-17 增加判断手工录入的病案号是否存在
	  	if $d(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_aMrNo,1)) {
		  	Set IsSamePat=..CheckIsSamePat(MrTypeID,aMrNo,PatientID)
		  	If IsSamePat=1 {
			  	Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_aMrNo,1,0))
		  	}else{
				Set return=-100_"^病案号已存在"
				Quit return
		  	}
		}else{
			Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_aMrNo,1,0))
		}
	}
	Set:MrNo="" MrNo=aMrNo
	
	If MainID'="" {  //存在有效病案
		Set return=-5.1_"^病案接诊失败"
		Set flg=..ReceiptByReg(aEpisodeID,MrTypeID,MrNo,MainID,aLocID,aUserID)
		If (+flg)<1 {
			Quit return
		}
		Set VolumeID=flg
	} ElseIf aMrNo'="" {  //手工输入病案号或历史病案号
		Set return=-5.2_"^病案接诊失败"
		Set MrNo=aMrNo
		Set flg=..ReceiptByReg(aEpisodeID,MrTypeID,MrNo,"",aLocID,aUserID)
		If (+flg)<1 {
			Quit return
		}
		Set VolumeID=flg
	} Else {  //自动分配新号码
		Set return=-5.3_"^病案接诊失败"
		Set MrNo=##class(DHCWMR.SS.MrNo).GetNewMrNo(NoTypeID,aLocID,aUserID)
		Set flg=..ReceiptByReg(aEpisodeID,MrTypeID,MrNo,"",aLocID,aUserID)
		If (+flg)<1 {
			If RecycleType=1 {
				//只回收自动分配的号码，历史号码和手工输入的号码通通不回收
				Set flg=##class(DHCWMR.SS.MrNo).SetMrNoAct(MrTypeID,MrNo,aLocID,aUserID)
			}
			Quit return
		}
		Set VolumeID=flg
	}
	
	Set return=1_"^病案接诊成功^"_VolumeID_"^"_MrNo
	Quit return
	
GroupReceiptError
    Set ErrMsg="-999^程序其他错误："_$ZE
    Quit ErrMsg
}

/// w ##class(DHCWMR.SSService.ReceiptSrv).ReceiptByReg()
ClassMethod ReceiptByReg(aEpisodeID As %String, aMrTypeID As %String, aMrNo As %String, aMainID As %String, aLocID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aMrTypeID,aMrNo,aMainID,aLocID,aUserID)
	Set return = -1_"^入参错误"
	Quit:(aEpisodeID="")||(aMrTypeID="")||(aMrNo="")||(aLocID="")||(aUserID="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	//不回收病案号,病案号必须写入病人基本信息表
	Quit:(RecycleType=0)&&(NoFiled="") return
	
	Set return = -2_"^无有效初始工作流项目"
	Set objInitItem = ##class(DHCWMR.SS.WorkFItem).GetInitWFItem(aMrTypeID)
	Quit:'$IsObject(objInitItem) return
	Quit:'$IsObject(objInitItem.WFIItem) return
	Set InitItemID=objInitItem.WFIItem.%Id()
	
	Set return = -3_"^当前病案无效"
	If aMainID'="" {
		Set objMain=##Class(DHCWMR.SS.Main).GetObjById(aMainID)
		Quit:'$IsObject(objMain) return
	}
	
	Set return=-4_"^病人基本信息取值错误"
	Quit:'$d(^PAADM(aEpisodeID)) return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	TStart
	
	If aMainID="" {
		Set return=-5_"^更新病案主表错误"
		Set InputStr=""
		Set InputStr=InputStr_"^"_aMrTypeID
		Set InputStr=InputStr_"^"_aMrNo
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_1
		Set InputStr=InputStr_"^"_""          //备注
		Set InputStr=InputStr_"^"_""          //特殊标示
		Set InputStr=InputStr_"^"_""          //归档号
		Set InputStr=InputStr_"^"_""          //病案条码
		Set InputStr=InputStr_"^"_aUserID     //建档人
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
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		Set MainID=flg
	} Else {
		Set MainID=aMainID
	}
	
	Set return=-6_"^更新病案卷表错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_InitItemID
	Set InputStr=InputStr_"^"_"A"
	Set InputStr=InputStr_"^"_""  //借阅流程
	Set InputStr=InputStr_"^"_""  //复印流程
	Set InputStr=InputStr_"^"_""  //封存流程
	Set InputStr=InputStr_"^"_""  //质控流程
	Set InputStr=InputStr_"^"_""  //出院日期
	Set InputStr=InputStr_"^"_""  //回收日期
	Set InputStr=InputStr_"^"_""  //第几次入院
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""  //卷条码
	Set InputStr=InputStr_"^"_1
	Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	Set VolumeID=flg
	
	Set return=-7_"^更新卷首页错误"
	Set flg=##class(DHCWMR.SS.VolPaadm).Update(VolumeID,aEpisodeID)
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	
	Set return=-8_"^更新病案卷状态错误！"	
	Set InputStr=VolumeID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_InitItemID
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_+$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	
	Set return=-9_"^更新HIS病案号错误"
	If RecycleType=1 {
		If (NoFiled'="")&&(IsBWMrNo=1) {
			//病案号如果不回收,必须把号码存入病人基本信息表
			Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,aMrNo)
			If (+flg)<1 Trollback
			Quit:(+flg)<1 return
		}
	} Else {
		//病案号如果不回收,必须把号码存入病人基本信息表
		Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,aMrNo)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	TCommit
	
	//添加接诊日志
	Set LogString="^"_1_"^"_aMrTypeID_"^"_aMrNo_"^"_VolumeID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=VolumeID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-02
/// Description:  取消接诊主程序
/// Input：       EpisodeID:就诊ID
///               MrClass:病案分类
///               LocID:接诊科室
///               UserID:接诊操作用户
/// Return:		  成功：>0，失败：<0
/// w ##class(DHCWMR.SSService.ReceiptSrv).GroupUnReceipt("4305203","85","4479")
ClassMethod GroupUnReceipt(aEpisodeID As %String, aLocID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aLocID,aUserID)
	Set return = -1_"^入参错误"
	Quit:(aEpisodeID="")||(aLocID="")||(aUserID="") return
	
	Set $ZT = "GroupUnReceiptError"
	
	Set return = -2_"^无就诊记录"
	Quit:'$d(^PAADM(aEpisodeID)) return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	//add by pylian 20151230 fix bug 162750 分娩的婴儿不接诊,退院时不判断取消接诊是否成功
	Quit:$p($g(^PAADM(+aEpisodeID)),"^",75)'="" 1    //婴儿不建病案

	Set return =-3_"^无就诊对应病案卷"
	Set (MainID,VolumeID,MrTypeID,MrNo,RecycleType,NoFiled,IsBWMrNo)=""
	Set xVolID =""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
		Quit:xVolID=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Set VolumeID=objVol.%Id()
		Set MainID=objVol.SVMainDr.%Id()
		Set MrNo=objVol.SVMainDr.SMMrNo
		Set objMrType=objVol.SVMainDr.SMMrType
		Set MrTypeID=objMrType.%Id()
		Set RecycleType=objMrType.MTRecycleType
		Set RecycleType=+RecycleType
		Set NoField=""
		If $IsObject(objMrType.MTNoFiled) {
			Set NoFiled=objMrType.MTNoFiled.SDCode
		}
		Set IsBWMrNo=objMrType.MTIsBWMrNo
	}
	Quit:(VolumeID="")||(MainID="")||(MrNo="") return
	
	//查找当前病案下是否还有有效卷
	Set xVolID=0,ActVolCnt=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",MainID,xVolID))
		Quit:xVolID=""
		Continue:xVolID=VolumeID  //当前作废卷不算
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Set ActVolCnt=ActVolCnt+1
	}
	
	//取消接诊入口日志
	Set LogString ="^"_2_"^"_MrTypeID_"^"_MrNo_"^"_VolumeID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(aLocID)
	Set SetPublicNoMrType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("SetPublicNoMrType",CTHospID)
	
	Tstart
	
	Set return = -4_"^作废病案卷错误"
	Set flg=##class(DHCWMR.SS.Volume).CancelVolume(VolumeID)
	If flg<1 TrollBack
	Quit:flg<1 return
	
	//当前病案下无有效卷
	If ActVolCnt<1 {
		Set return = -5_"^作废病案错误"
		Set flg=##class(DHCWMR.SS.Main).CancelMain(MainID)
		If flg<1 TrollBack
		Quit:flg<1 return
		
		//update by zf 20150611 病案号未被其他病案类型占用,病案号回收
		Set IsMrNoAct=1
		If SetPublicNoMrType'="" {
			For indMrType=1:1:$l(SetPublicNoMrType,",") {
				Set xMrTypeID=$p(SetPublicNoMrType,",",indMrType)
				Continue:xMrTypeID=""
				Continue:xMrTypeID=MrTypeID
				Continue:'$d(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_$zcvt(MrNo,"U"),1))
				Set IsMrNoAct=0  //病案号已被其他病案类型占用
			}
		}
		If IsMrNoAct=1 {
			Set MrNoID=$o(^DHCWMR.SS.MrNoI("IndexMrTypeMrNo",MrTypeID," "_$zcvt(MrNo,"U"),0))
			If MrNoID'="" {
				//当前病案号回收
				If RecycleType=1 {
					Set return=-6_"^病案号回收错误"
					Set flg=##class(DHCWMR.SS.MrNo).SetMrNoAct(MrTypeID,MrNo,aLocID,aUserID)
					If flg>0 {
						If (NoFiled'="")&&(IsBWMrNo=1) {
							Set return = -7_"^更新HIS病案号错误"
							Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,"")
							if (+flg)<0 Trollback
							Quit:(+flg)<0 return
						}
					}
				}
			}
			else{
				//当前病案号回收
				If RecycleType=1 {
					Set return=-6_"^病案号回收错误"
					If flg>0 {
						If (NoFiled'="")&&(IsBWMrNo=1) {
							Set return = -7_"^更新HIS病案号错误"
							Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(PatientID,NoFiled,"")
							if (+flg)<0 Trollback
							Quit:(+flg)<0 return
						}
					}
				}
			}
		}
	}
	
	Tcommit
	
	//取消接诊出口日志
	Set LogString="^"_3_"^"_MrTypeID_"^"_MrNo_"^"_VolumeID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=1_"^取消接诊成功"
	Quit return	
GroupUnReceiptError
    Set ErrMsg="-999^程序其他错误："_$ZE
    Quit ErrMsg
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  按就诊获取病案接诊方式
/// Table：       
/// Input：       aTpCode : 类型
/// Return：      ret=A:自动接诊 ret=H:手工接诊 ret=HN:手工输入病案号接诊
/// w ##class(DHCWMR.SSService.ReceiptSrv).GetReceiptType(5)
ClassMethod GetReceiptType(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set CTHospID="",CTLocID=AdmLoc,CTPatType=""
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Quit:CTHospID="" return
	
	If AdmType="I" {  //住院登记
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeI",CTHospID)
	} ElseIf AdmType="O" {  //挂号
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeO",CTHospID)
	} ElseIf AdmType="E" {  //挂号
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeE",CTHospID)
	} Else {}
	
	Set:return="" return="A"
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-21
/// Description:  通过就诊号取号码类型（自动接诊）
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.NoTypeLnk
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCWMR.SSService.ReceiptSrv).GetNoTypeByAdm(5)
ClassMethod GetNoTypeByAdm(aEpisodeID As %String, aMrNo As %String = "") As %String
{
	New (aEpisodeID,aMrNo)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT = "GetMrTypeByAdmErr"
	
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)
	Set AdmLoc=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set CTHospID="",CTLocID=AdmLoc,CTPatType=""
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Quit:CTHospID="" return
	Set CTPatType=$p($g(^PAADM(aEpisodeID,1)),"^",7)
	
	Set IOCheckNoTpLnk=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IOCheckNoTpLnk",CTHospID)
	Set IOCheckNoTpLnk=+IOCheckNoTpLnk
	
	Set IOCheckNoTpLocList=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IOCheckNoTpLocList",CTHospID)
	Set IOCheckNoTpLocList=","_IOCheckNoTpLocList_","
	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
		Quit:xID=""
		//Quit:(+return)>0
		
		Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(xID)
		Continue:'$IsObject(objMrType)
		Continue:'$IsObject(objMrType.MTMrClass)
		Set xAdmType=objMrType.MTAdmType
		Set xAdmType="#"_xAdmType_"#"
		Continue:xAdmType'[("#"_AdmType_"#")
		Set MTHospIDs="#"_objMrType.MTHospIDs_"#"
		Continue:MTHospIDs'[("#"_CTHospID_"#")
		
		Set rNoTypeID=""
		Set xSub=0
	 	For {
		 	Set xSub=$o(^DHCWMR.SS.MrTypeD(xID,"NT",xSub))
		 	Quit:xSub=""
			//Quit:(+return)>0
			
		 	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(xID_"||"_xSub)
		 	Continue:'$IsObject(objNoType)
		 	Continue:objNoType.NTIsActive'=1
			Set NoTypeID=objNoType.%Id()
			
		 	If IOCheckNoTpLnk=1 { //通过医院过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexHospID",xID,xSub," "_CTHospID))
		 	} ElseIf IOCheckNoTpLnk=2 { //通过科室过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexLocID",xID,xSub," "_CTLocID))
		 	} ElseIf IOCheckNoTpLnk=3 { //通过病人类型过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexPatType",xID,xSub," "_CTPatType))
		 	} ElseIf IOCheckNoTpLnk=4 { //通过科室列表区分院区
		 		Set LinkLocID=$o(^DHCWMR.SS.MrTypeI("MNTL","IndexLocID",xID,xSub,""))
		 		Continue:LinkLocID=""
		 		Set LinkLocID=$tr(LinkLocID," ","")
		 		
		 		Set IsNoTpAct=0
		 		Set xLLID=0
		 		For {
			 		Set xLLID=$o(^CT("LL",xLLID))
			 		Quit:xLLID=""
			 		Set LLCode=$p($g(^CT("LL",xLLID)),"^",1)
			 		Set LLCode=","_LLCode_","
			 		Continue:IOCheckNoTpLocList'[LLCode
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",LinkLocID))
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",AdmLoc))
		 			Set IsNoTpAct=1
			 	}
			 	Continue:IsNoTpAct'=1
		 	} Else {
			 	If aMrNo'="" {
					Set tCheckMrNoInput=..CheckMrNoInput(NoTypeID,aMrNo)
					If +tCheckMrNoInput>0 {
						Set rNoTypeID=NoTypeID
					}
				}
			 	Set IsDefault=objNoType.NTIsDefault
			 	Continue:IsDefault'=1
			}
			Set return=NoTypeID
	 	}
	}
	Set:rNoTypeID'="" return=rNoTypeID
	
	Quit return
	
GetMrTypeByAdmErr
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-23
/// Description:  查询号码类型（手工接诊）
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.NoTypeLnk
/// Input：       AdmType : 就诊类型
///               LGLocID : 登录科室
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.ReceiptSrv","QryNoTypeList","I","263")
Query QryNoTypeList(aAdmType As %String, aLocID As %String) As %Query(ROWSPEC = "NoTypeID:%String,NoTypeDesc:%String,MrTypeID:%String,MrTypeDesc:%String,IsDefault:%String") [ SqlProc ]
{
}

ClassMethod QryNoTypeListExecute(ByRef qHandle As %Binary, aAdmType As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aAdmType="")||(aLocID="") $$$OK
 	
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(aLocID)
	Quit:CTHospID="" $$$OK
	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
		Quit:xID=""
		
		Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(xID)
		Continue:'$IsObject(objMrType)
		Continue:'$IsObject(objMrType.MTMrClass)
		Set MTAdmType=objMrType.MTAdmType
		Set MTAdmType="#"_MTAdmType_"#"
		Continue:MTAdmType'=("#"_aAdmType_"#")
		If CTHospID'="" {
			Set MTHospIDs="#"_objMrType.MTHospIDs_"#"
			Continue:MTHospIDs'[("#"_CTHospID_"#")
		}
		
		Set xSub=0
	 	For {
		 	Set xSub=$o(^DHCWMR.SS.MrTypeD(xID,"NT",xSub))
		 	Quit:xSub=""
		 	
		 	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(xID_"||"_xSub)
		 	Continue:'$IsObject(objNoType)
		 	Continue:objNoType.NTIsActive'=1
			Set IsDefault=objNoType.NTIsDefault
			
			Set MrTypeID=objMrType.%Id()
			Set MrTypeDesc=objMrType.MTDesc
			Set NoTypeID=objNoType.%Id()
			Set NoTypeDesc=objNoType.NTDesc
			Set IsDefault=objNoType.NTIsDefault
			
			Set Data=$lb(NoTypeID,NoTypeDesc,MrTypeID,MrTypeDesc,IsDefault)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}
	
	Quit $$$OK
}

ClassMethod QryNoTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoTypeListExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  检查病案号输入
/// Table：       DHCWMR.SS.NoType
/// Input：       NoTypeID : 号码类型
///               MrNo : 病案号
/// Return：      返回Object
/// w ##class(DHCWMR.SSService.ReceiptSrv).CheckMrNoInput()
ClassMethod CheckMrNoInput(aNoTypeID As %String, aMrNo As %String) As %String
{
	New (aNoTypeID,aMrNo)
	Set return="0^参数错误"
	Quit:(aNoTypeID="") return
	
	Set $ZT = "CheckMrNoInputErr"
	
	Set:aMrNo'="" aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	Quit:aMrNo="" return
	
	Set MrNo=aMrNo
	Set MrTypeID=+aNoTypeID
	If $d(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_MrNo,1)) {
		Set return="1^"_MrNo
		Quit return
	}
	Set NoTypeID=aNoTypeID
	If $d(^DHCWMR.SS.MrNoI("IndexMrTypeMrNo",MrTypeID," "_MrNo)) {
		Set return="1^"_MrNo
		Quit return
	}
	
	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
	Quit:'$IsObject(objNoType) return
	Set NoTypeDesc=objNoType.NTDesc
	Set NoHead=objNoType.NTNoHead
	Set:NoHead'="" NoHead=$zcvt(NoHead,"U")
	Set NoLen=objNoType.NTNoLen
	Set:NoLen'="" NoLen=+NoLen
	Set MaxNo=objNoType.NTMaxNo
	Set:MaxNo'="" MaxNo=+MaxNo
	Set MinNo=objNoType.NTMinNo
	Set:MinNo'="" MinNo=+MinNo
	
	Set return="-1^病案号格式错误"
	If (NoHead'="") {
		Quit:($e(MrNo,1,$l(NoHead))'=NoHead) return
		Set Num=$e(MrNo,$l(NoHead)+1,$l(MrNo))
	} Else {
		Set Num=MrNo
	}
	Set tmpNum=Num
	For indNum=1:1:$l(Num) {
		Set xChar=$e(Num,indNum,indNum)
		Continue:xChar="0"
		Set tmpNum=$e(Num,indNum,$l(Num))
		Quit //退出循环
	}
	Quit:(+tmpNum)'=tmpNum return  //数字部分包含特殊字符
	Quit:tmpNum<1 return  //数字部分小于1
	Quit:(MinNo'="")&(tmpNum<MinNo) return  //数字部分小于最小号
	Quit:(MaxNo'="")&(tmpNum>MaxNo) return  //数字部分大于最大号
	Quit:(NoLen'="")&($l(tmpNum)>NoLen) return
	
	Set tmpMrNo=""
	If NoLen'="" {
		Set $p(tmpMrNo,"0",NoLen+1-$l(tmpNum))=tmpNum
	} Else {
		Set tmpMrNo=tmpNum
	}
	Set MrNo=NoHead_tmpMrNo  //格式化后的病案号
	
	Set return="1^"_MrNo
	Quit return
	
CheckMrNoInputErr
    Set ErrMsg="-999^"_$ZE
    Quit ErrMsg
}

/// **********************************************************************************
/// 以下内容为按病人建档分号程序 add by zf 20150513
/// **********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2015-05-13
/// Description:  病案建档主程序
/// Input：       PatientID:病人ID
///               MrClass:病案分类
///               MrNo:病案号
///               LocID:接诊科室
///               UserID:接诊操作用户
///               NoTypeID:号码类型
/// Return:		  成功：>0，失败：<0
/// w ##class(DHCWMR.SSService.ReceiptSrv).GroupReceiptByPat("1","","117","9","6||1","^63^838^2013-03-05^134^202^^198","1^9^117^12","张翰^DTHEALTHXTZL^男^1993-02-01^22岁^驾照^511024199302012231^丧偶^科管技术^汉族^中国^北京市^崇文区^北京市东城区^642313^四川成都^642314^^王城^夫妻^四川省成都市武侯区人民南路1段1号^19837628742")
ClassMethod GroupReceiptByPat(aPatientID As %String, aMrNo As %String, aLocID As %String, aUserID As %String, aNoTypeID As %String = "", aFirstInfo As %String = "", aFeeInfo As %String = "", aPatInfo As %String = "") As %String
{
	New (aPatientID,aMrNo,aLocID,aUserID,aNoTypeID,aFirstInfo,aFeeInfo,aPatInfo)
	Set return=-1_"^入参错误"
	Quit:(aPatientID="")||(aNoTypeID="")||(aLocID="")||(aUserID="")||(aNoTypeID="") return
	
	//Set ^ZF=$lb(aPatientID,aMrNo,aLocID,aUserID,aNoTypeID,aFirstInfo,aFeeInfo,aPatInfo)

	Set $ZT="GroupReceiptByPatError"
	
	//接诊入口日志
	Set EpisodeID=$p(aFirstInfo,"^",5)
	Set LogString ="^"_0_"^"_""_"^"_aMrNo_"^"_""_"^"_EpisodeID_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)_"^"_aPatientID
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=-2_"^病人信息错误"
	Quit:'$d(^PAPER(aPatientID)) return
	
	Set return=-3_"^号码类型错误"
	Set NoTypeID=aNoTypeID
	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(NoTypeID)
	Quit:'$IsObject(objNoType) return
	Set NoTypeID=objNoType.%Id()
	Set objMrType=objNoType.Parref
	Quit:'$IsObject(objMrType) return
	Set MrTypeID=objMrType.%Id()
	Set ReceiptType=""
	If $IsObject(objMrType.MTReceiptType) {
		Set ReceiptType=objMrType.MTReceiptType.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set RecycleType=+RecycleType
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	
	Set return=-4_"^当前病人已分配病案号"
	Set xVolID="",VolumeID=""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID))
		Quit:xVolID=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Continue:objVol.SVMainDr.SMMrType.%Id()'=MrTypeID
		Set VolumeID=objVol.%Id()
		Quit //退出
	}
	Quit:VolumeID'="" return
	
	//病案记录、病案号
	Set MainID="",MrNo=""
	If (aMrNo="")&&(RecycleType=0)&&(NoFiled'="") {
		Set aMrNo=##class(DHCWMR.SSService.MrNoSrv).GetHisMrNo(aPatientID,NoFiled)
	}
	If (MainID="")&&(aMrNo'="") {
		//add by liyi 2016-04-19 特殊处理已存在输入病案号返回值
		if $d(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_aMrNo,1)) {
			Set return=-100_"^病案号已存在"
			Quit return
		}else{
			Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",MrTypeID," "_aMrNo,1,0))
		}
	}
	Set:MrNo="" MrNo=aMrNo

	If MainID'="" {  //存在有效病案
		Set return=-5.1_"^分配病案号失败"
		Set flg=..ReceiptByReg02(aPatientID,MrTypeID,MrNo,MainID,aLocID,aUserID,aFirstInfo,aFeeInfo,aPatInfo)
		If (+flg)<1 {
			Quit return
		}
		Set VolumeID=flg
	} ElseIf MrNo'="" {  //手工输入病案号或历史病案号
		Set return=-5.2_"^分配病案号失败"
		Set flg=..ReceiptByReg02(aPatientID,MrTypeID,MrNo,"",aLocID,aUserID,aFirstInfo,aFeeInfo,aPatInfo)
		If (+flg)<1 {
			Quit return
		}
		Set VolumeID=flg
	} Else {  //自动分配新号码
		Set return=-5.3_"^分配病案号失败"
		Set MrNo=##class(DHCWMR.SS.MrNo).GetNewMrNo(NoTypeID,aLocID,aUserID)
		Set flg=..ReceiptByReg02(aPatientID,MrTypeID,MrNo,"",aLocID,aUserID,aFirstInfo,aFeeInfo,aPatInfo)
		If (+flg)<1 {
			If RecycleType=1 {
				//只回收自动分配的号码，历史号码和手工输入的号码通通不回收
				Set flg=##class(DHCWMR.SS.MrNo).SetMrNoAct(MrTypeID,MrNo,aLocID,aUserID)
			}
			Quit return
		}
		Set VolumeID=flg
	}
	
	Set return=1_"^病案建档成功^"_VolumeID_"^"_MrNo
	Quit return
	
GroupReceiptByPatError
    Set ErrMsg="-999^程序其他错误："_$ZE
    Quit ErrMsg
}

/// w ##class(DHCWMR.SSService.ReceiptSrv).ReceiptByReg02()
ClassMethod ReceiptByReg02(aPatientID As %String, aMrTypeID As %String, aMrNo As %String, aMainID As %String, aLocID As %String, aUserID As %String, aFirstInfo As %String = "", aFeeInfo As %String = "", aPatInfo As %String = "") As %String
{
	New (aPatientID,aMrTypeID,aMrNo,aMainID,aLocID,aUserID,aFirstInfo,aFeeInfo,aPatInfo)
	Set return = -1_"^入参错误"
	Quit:(aPatientID="")||(aMrTypeID="")||(aMrNo="")||(aLocID="")||(aUserID="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	//不回收病案号,病案号必须写入病人基本信息表
	Quit:(RecycleType=0)&&(NoFiled="") return
	
	Set return = -2_"^无有效初始工作流项目"
	Set objInitItem = ##class(DHCWMR.SS.WorkFItem).GetInitWFItem(aMrTypeID)
	Quit:'$IsObject(objInitItem) return
	Quit:'$IsObject(objInitItem.WFIItem) return
	Set InitItemID=objInitItem.WFIItem.%Id()
	
	Set return = -3_"^当前病案无效"
	If aMainID'="" {
		Set objMain=##Class(DHCWMR.SS.Main).GetObjById(aMainID)
		Quit:'$IsObject(objMain) return
	}
	
	Set return=-4_"^病人信息错误"
	Quit:'$d(^PAPER(aPatientID)) return
	
	Set FirstHospID=$p(aFirstInfo,"^",1)
	Set FirstLocID=$p(aFirstInfo,"^",2)
	Set:FirstLocID'="" FirstHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(FirstLocID)
	Set FirstDocID=$p(aFirstInfo,"^",3)
	Set FirstDate=$p(aFirstInfo,"^",4)
	;Set:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	Set FirstDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(FirstDate)
	Set FirstAdm=$p(aFirstInfo,"^",5)
	Set PatFrom=$p(aFirstInfo,"^",6)
	Set EPPatFrom=$p(aFirstInfo,"^",7)
	Set AdmStatus=$p(aFirstInfo,"^",8)
	TStart
	
	If aMainID="" {
		Set return=-5_"^更新病案主表错误"
		Set InputStr=""
		Set InputStr=InputStr_"^"_aMrTypeID
		Set InputStr=InputStr_"^"_aMrNo
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_1
		Set InputStr=InputStr_"^"_""          //备注
		Set InputStr=InputStr_"^"_""          //特殊标示
		Set InputStr=InputStr_"^"_""          //归档号
		Set InputStr=InputStr_"^"_""          //病案条码
		Set InputStr=InputStr_"^"_aUserID     //建档人
		Set InputStr=InputStr_"^"_FirstHospID //初诊院区
		Set InputStr=InputStr_"^"_FirstLocID  //初诊科室
		Set InputStr=InputStr_"^"_FirstDocID  //初诊医生
		Set InputStr=InputStr_"^"_FirstDate   //初诊日期
		Set InputStr=InputStr_"^"_FirstAdm    //初诊就诊
		Set InputStr=InputStr_"^"_PatFrom     //病人来源
		Set InputStr=InputStr_"^"_EPPatFrom   //急诊来源
		Set InputStr=InputStr_"^"_AdmStatus   //就诊状态
		Set InputStr=InputStr_"^"_""          //指初始记录（修改病案号会记录）
		Set flg=##class(DHCWMR.SS.Main).Update(InputStr,"^")
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		Set MainID=flg
	} Else {
		Set MainID=aMainID
	}

	Set return=-6_"^更新病案卷表错误"
	Set InputStr=""
	Set InputStr=InputStr_"^"_MainID
	Set InputStr=InputStr_"^"_InitItemID
	Set InputStr=InputStr_"^"_"P" //***病案建档的卷都是预约(P)状态
	Set InputStr=InputStr_"^"_""  //借阅流程
	Set InputStr=InputStr_"^"_""  //复印流程
	Set InputStr=InputStr_"^"_""  //封存流程
	Set InputStr=InputStr_"^"_""  //质控流程
	Set InputStr=InputStr_"^"_""  //出院日期
	Set InputStr=InputStr_"^"_""  //回收日期
	Set InputStr=InputStr_"^"_""  //第几次入院
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""  //卷条码
	Set InputStr=InputStr_"^"_1
	Set flg=##class(DHCWMR.SS.Volume).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	Set VolumeID=flg
	
	Set return=-7_"^更新卷首页错误"
	Set flg=##class(DHCWMR.SS.VolPaadm).UpdateByPat(VolumeID,aPatientID,aPatInfo)
	
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	if (aPatInfo'=""){
		Set flg=##class(DHCWMR.SS.VolPaadm).UpdateByMrNo(aMrTypeID,aMrNo,aPatInfo,aFirstInfo)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	Set return=-8_"^更新病案卷状态错误！"	
	Set InputStr=VolumeID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_InitItemID
	Set InputStr=InputStr_"^"_aUserID
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_+$p($h,",",2)
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.SS.VolStatus).Update(InputStr,"^")
	If (+flg)<1 Trollback
	Quit:(+flg)<1 return
	
	Set return=-9_"^更新HIS病案号错误"
	If RecycleType=1 {
		If (NoFiled'="")&&(IsBWMrNo=1) {
			//病案号如果不回收,必须把号码存入病人基本信息表
			Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(aPatientID,NoFiled,aMrNo)
			If (+flg)<1 Trollback
			Quit:(+flg)<1 return
		}
	} Else {
		//病案号如果不回收,必须把号码存入病人基本信息表
		Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(aPatientID,NoFiled,aMrNo)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	Set return=-5.1_"^保存病案建档费记录错误"
	If aFeeInfo'="" {
		Set flg=##class(DHCWMR.SSService.NewRecordSrv).SaveNewFee(MainID,aFeeInfo)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
	}
	
	TCommit
	
	//添加接诊日志
	Set LogString="^"_1_"^"_aMrTypeID_"^"_aMrNo_"^"_VolumeID_"^"_""_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)_"^"_aPatientID
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=VolumeID
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-13
/// Description:  取消病案建档主程序
/// Input：       PatientID:病人ID
///               MrClass:病案分类
///               LocID:接诊科室
///               UserID:接诊操作用户
/// Return:		  成功：>0，失败：<0
/// w ##class(DHCWMR.SSService.ReceiptSrv).GroupUnReceiptByPat("1","6","59","9")
ClassMethod GroupUnReceiptByPat(aPatientID As %String, aMrTypeID As %String, aLocID As %String, aUserID As %String) As %String
{
	New (aPatientID,aLocID,aUserID,aMrTypeID)
	Set return = -1_"^入参错误"
	Quit:(aPatientID="")||(aMrTypeID="")||(aLocID="")||(aUserID="") return
	
	//Set ^LIYI = $lb(aPatientID,aMrTypeID,aLocID,aUserID)
	
	Set $ZT = "GroupUnReceiptByPatError"
	
	Set return = -2_"^无病人信息"
	Quit:'$d(^PAPER(aPatientID)) return
	
	Set return=-3_"^号码类型错误"
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Set MrTypeID=objMrType.%Id()
	Set ReceiptType=""
	If $IsObject(objMrType.MTReceiptType) {
		Set ReceiptType=objMrType.MTReceiptType.SDCode
	}
	Set RecycleType=objMrType.MTRecycleType
	Set RecycleType=+RecycleType
	Set NoFiled=""
	If $IsObject(objMrType.MTNoFiled) {
		Set NoFiled=objMrType.MTNoFiled.SDCode
	}
	Set IsBWMrNo=objMrType.MTIsBWMrNo
	
	Set return =-3_"^无对应病案卷"
	Set (MainID,VolumeID,MrNo)=""
	Set xVolID =""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID))
		Quit:xVolID=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:objVol.SVMainDr.SMIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Continue:objVol.SVMainDr.SMMrType.%Id()'=MrTypeID
		//Continue:objVol.SVOrdStep'="P" //预约状态      修复bug168219
		Set VolumeID=objVol.%Id()
		Set MainID=objVol.SVMainDr.%Id()
		Set MrNo=objVol.SVMainDr.SMMrNo
	}
	Quit:(VolumeID="")||(MainID="")||(MrNo="") return
	
	//查找当前病案下是否还有有效卷
	Set xVolID=0,ActVolCnt=0
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",MainID,xVolID))
		Quit:xVolID=""
		Continue:xVolID=VolumeID  //当前作废卷不算
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Set ActVolCnt=ActVolCnt+1
	}
	
	//取消接诊入口日志
	Set LogString ="^"_2_"^"_MrTypeID_"^"_MrNo_"^"_VolumeID_"^"_""_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)_"^"_aPatientID
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(aLocID)
	Set SetPublicNoMrType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("SetPublicNoMrType",CTHospID)
	
	Tstart
	
	Set return = -4_"^作废病案卷错误"
	Set flg=##class(DHCWMR.SS.Volume).CancelVolume(VolumeID)
	If flg<1 TrollBack
	Quit:flg<1 return
	
	//当前病案下无有效卷
	If ActVolCnt<1 {
		Set return = -5_"^作废病案错误"
		Set flg=##class(DHCWMR.SS.Main).CancelMain(MainID)
		If flg<1 TrollBack
		Quit:flg<1 return
		
		Set return=-5.1_"^保存病案建档退费记录错误"
		Set flg=##class(DHCWMR.SSService.NewRecordSrv).RetNewFee(MainID,aUserID,aLocID)
		If (+flg)<1 Trollback
		Quit:(+flg)<1 return
		
		//update by zf 20150611 病案号未被其他病案类型占用,病案号回收
		Set IsMrNoAct=1
		If SetPublicNoMrType'="" {
			For indMrType=1:1:$l(SetPublicNoMrType,",") {
				Set xMrTypeID=$p(SetPublicNoMrType,",",indMrType)
				Continue:xMrTypeID=""
				Continue:xMrTypeID=MrTypeID
				Continue:'$d(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrTypeID," "_$zcvt(MrNo,"U"),1))
				Set IsMrNoAct=0  //病案号已被其他病案类型占用
			}
		}
		If IsMrNoAct=1 {
			Set MrNoID=$o(^DHCWMR.SS.MrNoI("IndexMrTypeMrNo",MrTypeID," "_$zcvt(MrNo,"U"),0))
			If MrNoID'="" {
				//当前病案号回收
				If RecycleType=1 {
					Set return=-6_"^病案号回收错误"
					Set flg=##class(DHCWMR.SS.MrNo).SetMrNoAct(MrTypeID,MrNo,aLocID,aUserID)
					If flg>0 {
						If (NoFiled'="")&&(IsBWMrNo=1) {
							Set return = -7_"^更新HIS病案号错误"
							Set flg=##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(aPatientID,NoFiled,"")
							if (+flg)<0 Trollback
							Quit:(+flg)<0 return
						}
					}
				}
			}
		}
	}
	
	Tcommit
	
	//取消接诊出口日志
	Set LogString="^"_3_"^"_MrTypeID_"^"_MrNo_"^"_VolumeID_"^"_""_"^"_aLocID_"^"_aUserID_"^"_+$h_"^"_+$p($h,",",2)_"^"_aPatientID
	Do ##class(DHCWMR.SS.ReceiptLog).Update(LogString,"^")
	
	Set return=1_"^取消病案建档成功"
	Quit return	
GroupUnReceiptByPatError
    Set ErrMsg="-999^程序其他错误："_$ZE
    Quit ErrMsg
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  按科室获取病案接诊方式
/// Table：       
/// Input：       aMrClass : 病案分类
///               aMrClass : 病案分类
/// Return：      ret=A:自动接诊 ret=H:手工接诊 ret=HN:手工输入病案号接诊
/// w ##class(DHCWMR.SSService.ReceiptSrv).GetReceiptTypeByLoc("I","117")
ClassMethod GetReceiptTypeByLoc(aMrClass As %String, aFirstLocID As %String, aFirstHospID As %String = "") As %String
{
	New (aMrClass,aFirstLocID,aFirstHospID)
	Set return=""
	Quit:(aMrClass="") return
	Quit:(aFirstLocID="")&&(aFirstHospID="") return
	
	Set $ZT="GetReceiptTypeByLocErr"
	
	Set CTHospID="",CTLocID=aFirstLocID,CTPatType=""
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(CTLocID)
	Set:CTHospID="" CTHospID=aFirstHospID
	Quit:CTHospID="" return
	
	If aMrClass="I" {  //住院
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeI",CTHospID)
	} ElseIf aMrClass="O" {  //门诊
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeO",CTHospID)
	} ElseIf (aMrClass="E")||(aMrClass="L") {  //急诊、急诊留观
		Set return=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("GetReceiptTypeE",CTHospID)
	} Else {}
	
	Set:return="" return="A"
	Quit return
	
GetReceiptTypeByLocErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-13
/// Description:  通过登录科室取号码类型（自动接诊）
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType、DHCWMR.SS.NoTypeLnk
/// Input：       LogLocID : 登录科室
/// Return：      返回String
/// w ##class(DHCWMR.SSService.ReceiptSrv).GetNoTypeByLoc("I","117")
ClassMethod GetNoTypeByLoc(aMrClass As %String, aFirstLocID As %String, aFirstHospID As %String = "") As %String
{
	New (aMrClass,aFirstLocID,aFirstHospID)
	Set return=""
	Quit:(aMrClass="") return
	Quit:(aFirstLocID="")&&(aFirstHospID="") return
	
	Set $ZT = "GetNoTypeByLocErr"
	
	Set CTHospID="",CTLocID=aFirstLocID,CTPatType=""
	Set CTHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(CTLocID)
	Set:CTHospID="" CTHospID=aFirstHospID
	Quit:CTHospID="" return
	
	Set IOCheckNoTpLnk=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IOCheckNoTpLnk",CTHospID)
	Set IOCheckNoTpLnk=+IOCheckNoTpLnk
	
	Set IOCheckNoTpLocList=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IOCheckNoTpLocList",CTHospID)
	Set IOCheckNoTpLocList=","_IOCheckNoTpLocList_","
	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
		Quit:xID=""
		Quit:(+return)>0
		
		Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(xID)
		Continue:'$IsObject(objMrType)
		Continue:'$IsObject(objMrType.MTMrClass)
		Continue:objMrType.MTMrClass.MCCode'=aMrClass
		Set MTHospIDs="#"_objMrType.MTHospIDs_"#"
		Continue:MTHospIDs'[("#"_CTHospID_"#")
		
		Set xSub=0
	 	For {
		 	Set xSub=$o(^DHCWMR.SS.MrTypeD(xID,"NT",xSub))
		 	Quit:xSub=""
			Quit:(+return)>0
			
		 	Set objNoType=##class(DHCWMR.SS.NoType).GetObjById(xID_"||"_xSub)
		 	Continue:'$IsObject(objNoType)
		 	Continue:objNoType.NTIsActive'=1
			Set NoTypeID=objNoType.%Id()
			
		 	If IOCheckNoTpLnk=1 { //通过医院过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexHospID",xID,xSub," "_CTHospID))
		 	} ElseIf IOCheckNoTpLnk=2 { //通过科室过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexLocID",xID,xSub," "_CTLocID))
		 	} ElseIf IOCheckNoTpLnk=3 { //通过病人类型过滤
		 		Continue:'$d(^DHCWMR.SS.MrTypeI("MNTL","IndexPatType",xID,xSub," "_CTPatType))
		 	} ElseIf IOCheckNoTpLnk=4 { //通过科室列表区分院区
		 		Set LinkLocID=$o(^DHCWMR.SS.MrTypeI("MNTL","IndexLocID",xID,xSub,""))
		 		Continue:LinkLocID=""
		 		Set LinkLocID=$tr(LinkLocID," ","")
		 		
		 		Set IsNoTpAct=0
		 		Set xLLID=0
		 		For {
			 		Set xLLID=$o(^CT("LL",xLLID))
			 		Quit:xLLID=""
			 		Set LLCode=$p($g(^CT("LL",xLLID)),"^",1)
			 		Set LLCode=","_LLCode_","
			 		Continue:IOCheckNoTpLocList'[LLCode
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",LinkLocID))
					Continue:'$d(^CT("LL",xLLID,"LOC",0,"Loc",CTLocID))
		 			Set IsNoTpAct=1
			 	}
			 	Continue:IsNoTpAct'=1
		 	} Else {
			 	Set IsDefault=objNoType.NTIsDefault
			 	Continue:IsDefault'=1
			}
			Set return=NoTypeID
	 	}
	}
	
	Quit return
	
GetNoTypeByLocErr
    Quit return
}

/// add by mxp 2017-09-19
/// 根据病案号和病人ID判断是否是同一个人
ClassMethod CheckIsSamePat(aMrTypeID As %String, aMrNo As %String, aPatientID As %String)
{
	New (aMrTypeID,aMrNo,aPatientID)
	Set return=0
	Quit:(aMrTypeID="")||(aMrNo="")||(aPatientID="") return
	
	Set PatName=$p($g(^PAPER(aPatientID,"ALL")),"^",1)
	Set PatName=$ZCVT(PatName,"U")
	Set Birthday=$p($g(^PAPER(aPatientID,"ALL")),"^",6)
	Set PersonalID=$p($g(^PAPER(aPatientID,"ALL")),"^",9)
	
	Set PatientList=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,aMrTypeID)
	Quit:PatientList="" return
	
	For indPat=1:1:$l(PatientList,",") {
		Set xPatientID=$P(PatientList,",",indPat)
		Continue:xPatientID=""
		Set xPatName=$p($g(^PAPER(xPatientID,"ALL")),"^",1)
		Set xPatName=$ZCVT(xPatName,"U")
		Set xBirthday=$p($g(^PAPER(xPatientID,"ALL")),"^",6)
		Set xPersonalID=$p($g(^PAPER(xPatientID,"ALL")),"^",9)
		If (xPersonalID'="") {
			Set:(xPersonalID=PersonalID) return=1
		}else{
			Set:(xPatName'="")&&(xPatName=PatName)&&(xBirthday'="")&&(xBirthday=Birthday) return=1
		}
		Quit:return=1
	}
	
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2018-04-08
/// Description:  通过就诊号获取不同就诊卡对应的病案号
/// Input：       EpisodeID : 就诊rowid
/// Return：      病案号
/// w ##class(DHCWMR.SSService.ReceiptSrv).GetMrNoByEpisodeID(349)
ClassMethod GetMrNoByEpisodeID(EpisodeID As %String) As %String
{
	New (EpisodeID)
	
	Set return=""
	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Quit:PatientID="" return	
	
	Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	Quit:AdmType="" return
	
	Set xPatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set xPatName=$ZCVT(xPatName,"U")
	Set xBirthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set xPersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	
	Quit:(xPersonalID="") return
	
	Set papmi=""
	For {
		Set papmi=$o(^PAPERi("PAPMI_ICPPBC",xPersonalID_"Z",papmi))
		Quit:(papmi="")||(return'="")
		
		Continue:papmi=PatientID	//同一个卡
		
		Set tPatName=$p($g(^PAPER(papmi,"ALL")),"^",1)
		Set tPatName=$ZCVT(tPatName,"U")
		Set tBirthday=$p($g(^PAPER(papmi,"ALL")),"^",6)
		Set tPersonalID=$p($g(^PAPER(papmi,"ALL")),"^",9)
		Continue:(xPersonalID'=tPersonalID)||(xPatName'=tPatName)
		
		Set MrNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(papmi,AdmType)
		Set:MrNo'="" return=MrNo
		
	}
	
	Quit return
}

}
