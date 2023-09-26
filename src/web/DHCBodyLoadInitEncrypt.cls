Class web.DHCBodyLoadInitEncrypt Extends %RegisteredObject
{

ClassMethod GetAllEncryptStr() As %String
{
	s HospitalCode=..GetCurrentHospitalCode()
	s retStr=""
	s GetOutpatEPRStatusName="GetOutpatEPRStatus"
	s GetOutpatEPRStatusValue=##Class(websys.Page).Encrypt($lb("web.DHCBodyLoadInitEncrypt.GetOutpatEPRStatus"))
    
    ;补录医嘱
	s InsertContinuousOrderName="InsertContinuousOrder"
	s InsertContinuousOrderValue=##Class(websys.Page).Encrypt($lb("web.DHCOEOrdItem.InsertContinuousOrder"))
	;医保实时结算
	s GetInsuBillParaName="GetInsuBillPara"
	s GetInsuBillParaValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdm.GetInsuBillPara"))
	;取医保指针
	s GetINADMRowidName="GetINADMRowid"
	s GetINADMRowidValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdm.GetINADMRowid"))
	;取医保admsource
	s GetREAAdmSourceName="GetREAAdmSource"
	s GetREAAdmSourceValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdmReg.GetREAAdmSource"))
	
	;大保取科室
	s GetDiaCatRegDeptName="GetDiaCatRegDept"
	s GetDiaCatRegDeptValue=##Class(websys.Page).Encrypt($lb("web.DHCDiagnosCat.GetDiaCatRegDept"))
	
	;退号取是否就诊标志
	s CheckAdmDiagnosName="CheckAdmDiagnos"
	s CheckAdmDiagnosValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdmReg.CheckAdmDiagnos"))
	
	;取保险应付的钱
	s CalPayMoneyName="CalPayMoney"
	s CalPayMoneyValue=##Class(websys.Page).Encrypt($lb("web.DHCInsuComConfig.CalPayMoney"))


	s InsertInsuComPayName="InsertInsuComPay"
	s InsertInsuComPayValue=##Class(websys.Page).Encrypt($lb("web.DHCInsuComConfig.InsertInsuComPay"))
	s DeleteInsuComPayName="DeleteInsuComPay"
	s DeleteInsuComPayValue=##Class(websys.Page).Encrypt($lb("web.DHCInsuComConfig.DeleteInsuComPay"))
	
	
	
	;病情证明单
	s GetPatDefaultInfoName="GetPatDefaultInfo"
	s GetPatDefaultInfoValue=##Class(websys.Page).Encrypt($lb("web.DHCPatConditionProof.GetPatDefaultInfo"))
	s InsertName="Insert"
	s InsertValue=##Class(websys.Page).Encrypt($lb("web.DHCPatConditionProof.Insert"))
	

	s CheckNewCardName="CheckNewCard"
	s CheckNewCardValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdmReg.CheckNewCard"))
	

	s GetPatientByRowidName="GetPatientByRowid"
	s GetPatientByRowidValue=##Class(websys.Page).Encrypt($lb("web.DHCDocOrderEntry.GetPatientByRowid"))

	s CheckOtherLimitName="CheckOtherLimit"
	s CheckOtherLimitValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdmReg.CheckOtherLimit"))


	s GetRegOrdQtyName="GetRegOrdQty"
	s GetRegOrdQtyValue=##Class(websys.Page).Encrypt($lb("web.DHCOPAdmReg.GetRegOrdQty"))
	

	s GetlocidandroomidName="Getlocidandroomid"
	s GetlocidandroomidValue=##Class(websys.Page).Encrypt($lb("web.DHCOPRegSupplement.Getlocidandroomid"))



	
	//如果是多个用$C(2)分开
	s retStr=GetOutpatEPRStatusName_$C(1)_GetOutpatEPRStatusValue
	s retStr=retStr_$C(2)_InsertContinuousOrderName_$C(1)_InsertContinuousOrderValue
	s retStr=retStr_$C(2)_GetInsuBillParaName_$C(1)_GetInsuBillParaValue_$C(2)_GetINADMRowidName_$C(1)_GetINADMRowidValue_$C(2)_GetREAAdmSourceName_$C(1)_GetREAAdmSourceValue_$C(2)_CheckAdmDiagnosName_$C(1)_CheckAdmDiagnosValue
	s retStr=retStr_$C(2)_CalPayMoneyName_$C(1)_CalPayMoneyValue_$C(2)_InsertInsuComPayName_$C(1)_InsertInsuComPayValue_$C(2)_DeleteInsuComPayName_$C(1)_DeleteInsuComPayValue
	s retStr=retStr_$C(2)_GetPatDefaultInfoName_$C(1)_GetPatDefaultInfoValue_$C(2)_InsertName_$C(1)_InsertValue
	s retStr=retStr_$C(2)_CheckNewCardName_$C(1)_CheckNewCardValue
	s retStr=retStr_$C(2)_GetPatientByRowidName_$C(1)_GetPatientByRowidValue
	s retStr=retStr_$C(2)_GetDiaCatRegDeptName_$C(1)_GetDiaCatRegDeptValue
	s retStr=retStr_$C(2)_CheckOtherLimitName_$C(1)_CheckOtherLimitValue
	s retStr=retStr_$C(2)_GetRegOrdQtyName_$C(1)_GetRegOrdQtyValue_$C(2)_GetlocidandroomidName_$C(1)_GetlocidandroomidValue
	

	Q retStr
}

/// Description:? 得到医生站设置里当前医院的代码
/// Table?        
/// Input?        
/// Return?       医院的代码 
/// Others?
ClassMethod GetCurrentHospitalCode() As %String
{
	s HospitalCode=""
	s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
	i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
	Q HospitalCode
}

/// 由于电子病历模版的问题这个方法暂时不使用
/// Description:	控制放在打印处方的时候 入参是ADM，返回值Y/N 任意一个病历填了内容且保存了就是Y   
/// Input:		EpisodeID
/// Output:		状态^描述   状态(Y/N) 描述(文本)
/// w ##Class(web.DHCBodyLoadInitEncrypt).GetOutpatEPRStatus(76596)
ClassMethod GetOutpatEPRStatus(argEpisodeID As %String) As %String
{
	q ""
	s ^RP("epr_GetOutpatEPRStatus")=argEpisodeID
	q:(($d(argEpisodeID)=0)||(argEpisodeID="")) ""
	
	;定义变量
	s Status=""
	s AdmType="" ,DisDept="" ,DisDeptDR=""
	;病人类型检查
	s AdmType = $p($g(^PAADM(argEpisodeID)),"^",2)
	q:(AdmType'="O") ""
	;病人科室检查(妇产科不控制)
	;44	妇产科门诊	FCKMZ-妇产科门诊
	;45	妇科门诊	FKMZ-妇科门诊
	;73    预防门诊    YFMZ-预防门诊
	s DisDept=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(argEpisodeID,"DiTan")
	q:(DisDept="") ""
	s DisDeptDR=$p($g(DisDept),"^",1)
	q:((DisDeptDR="44")||(DisDeptDR="45")||(DisDeptDR="73")) ""
	;初诊通用模板定义(一般情况主诉.现病史既往史.体格检查.辅助检查.初步诊断.治疗处理意见)
	s FirTemplateId1 = "76"
	s FirTemplateId2 = "77"
	s FirTemplateId3 = "78"
	s FirTemplateId4 = "79"
	s FirTemplateId5 = "80"
	s FirTemplateId6 = "81"
	s FirTime	= "门诊初诊.就诊时间#TYPE:Simple#TID:76#TVER:0#SCODE:D0025#VTYPE:V"
	s FirRec1	= "门诊初诊.主诉#TYPE:TextDesc#TID:76#TVER:0#ECODE:E0055"
	s FirRec2	= "门诊初诊.现病史#TYPE:TextDesc#TID:77#TVER:0#ECODE:E0056"
	s FirCheck	= "门诊初诊.体格检查#TYPE:TextDesc#TID:78#TVER:0#ECODE:E0171" 
	s FirDoctor	= "门诊初诊.医师签名#TYPE:Simple#TID:81#TVER:0#SCODE:I0002#VTYPE:V" 
	
	;复诊通用模板定义
	s SecTemplateId = "257"
	s SecTime	= "门诊复诊.就诊时间#TYPE:Simple#TID:257#TVER:0#SCODE:D0007#VTYPE:V"
	s SecCheck	= "门诊复诊.病史查体#TYPE:TextDesc#TID:257#TVER:0#ECODE:E0047"
	s SecDoctor	= "门诊复诊.医师签名#TYPE:Simple#TID:257#TVER:0#SCODE:I0043#VTYPE:V"
	
	;定义变量
	s SecTemplateStatus=""
	s IsSecTime="" ,IsSecCheck="" ,IsSecDoctor=""
	s FirTemplateStatus=""
	s IsFirTime="" ,IsFirRec1="" ,IsFirRec2="" ,IsFirCheck="" ,IsFirDoctor=""

	
	;判断复诊病历完整性  1=Save  0=UnSave
	b ;argEpisodeID,SecTemplateId
	s SecTemplateStatus = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,SecTemplateId)
	b ; SecTemplateStatus
	if SecTemplateStatus = 1 {
		s IsSecTime = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecTime)
		s IsSecCheck =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecCheck)
		s IsSecDoctor = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,SecDoctor)
		
		if (IsSecTime'="")&&(IsSecCheck'="")&&(IsSecDoctor'="") {
			s Status = "Y^复诊病历保存成功,完整性检查成功!"
		}
		else {
			s Status = "N^复诊病历保存成功,完整性检查失败!"
		}

	}
	;判断初诊病历完整性
	else {
		
		s FirTemplateStatus1 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId1)
		s FirTemplateStatus2 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId2)
		s FirTemplateStatus3 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId3)
		;s FirTemplateStatus4 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId4)
		;s FirTemplateStatus5 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId5)
		;s FirTemplateStatus6 = ##Class(EPRservice.Quality.BOQuaExpExplain).GetInstanceDataStatus(argEpisodeID,FirTemplateId6)
		
		if (FirTemplateStatus1 && FirTemplateStatus2 && FirTemplateStatus3 ) {
			s SecTemplateStatus = 1
		}
		
		if SecTemplateStatus = 1 {
			s IsFirTime = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirTime)
			s IsFirRec1 =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirRec1)
			s IsFirRec2 = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirRec2)
			s IsFirCheck =##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirCheck)
			s IsFirDoctor = ##Class(EPRservice.BOScatterData).GetEPRData(argEpisodeID,FirDoctor)
			
			/*if (IsFirTime'="")&&(IsFirRec1'="")&&(IsFirRec2'="")&&(IsFirCheck'="")&&(IsFirDoctor'="") {
				s Status = "Y^初诊病历保存成功,完整性检查成功!"	
			}*/
			if (IsFirTime'="")&&(IsFirRec1'="")&&(IsFirRec2'="") {
				s Status = "Y^初诊病历保存成功,完整性检查成功!"
				
			}
			
			else {
				s Status = "N^初诊病历保存成功,完整性检查失败!"
			}
		}
		else {
			s Status = "N^初诊病历未保存,复诊病历未保存!"
		}
	}
    q Status
}

}
