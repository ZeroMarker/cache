Class DHCExternalService.RegInterface.RegManager Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

Parameter HospitalCode = "BJXH";

Parameter RegServicePackageNmae = "DTROrderMana";

Parameter RegServiceClassNmae = "DTROrderMana.DTROrderManaSoap";

Parameter BookServicePackageNmae = "DTRXTBSServiceAppointManage";

Parameter BookServiceClassNmae = "DTRXTBSServiceAppointMang.DTRXTBSServiceAppointManageSoap";

/// 修改停诊通知状态
ClassMethod UpdateNotifyStatus(ApptID As %String = "", UserID As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).UpdateNotifyStatus(ApptID,1)
	n (ApptID,UserID)
	s $ZT="UpdateNotifyStatusErr"
	s Obj=##class(User.RBAppointment).%OpenId(ApptID)
	q:Obj.APPTSystemSession="" "0^"
	s InputObj=..GetInputObj("1007",UserID)
	s InputObj.OrderCode=Obj.APPTSystemSession
	s InputObj.NotifyStatus="Y"
	s InputObj.HospitalId=Obj.APPTASParRef.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
	s RtnObj=ClsObj.UpdateNotifyStatus(InputObj)
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent
UpdateNotifyStatusErr
	q "-1^UpdateNotifyStatus调用异常"
}

/// 发送锁号请求
ClassMethod LockOrder(RBASID As %String = "", PatientID As %String = "", UserID As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).LockOrder("81||16",49,1)
	n (RBASID,PatientID,UserID)
	s $ZT="LockOrderErr"
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	s InputObj=..GetInputObj("1008",UserID)
	s InputObj.ScheduleItemCode=RBASID
	s InputObj.HospitalId=Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s Obj=##class(User.PAPatMas).%OpenId(PatientID)
	s InputObj.CardNo=..GetCardNoByPatientID(PatientID)
	s InputObj.CredTypeCode=##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(Obj.PAPMICardTypeDRGetObjectId())
	s InputObj.IDCardNo=Obj.PAPMIDVAnumber
	b ;InputObj.CardNo
	s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
	s RtnObj=ClsObj.LockOrder(InputObj)
	b
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent_"^"_RtnObj.LockQueueNo
LockOrderErr
	q "-1^LockOrder调用异常"_$ZERROR
}

/// 发送解除锁号请求
ClassMethod RemoveLockOrder(RBASID As %String = "", PatientID As %String = "", UserID As %String = "", ExpStr As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).RemoveLockOrder("81||16",49,1,"142241110211039407714")
	n (RBASID,PatientID,UserID,ExpStr)
	s $ZT="RemoveLockOrderErr"
	s Obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	s InputObj=..GetInputObj("1009",UserID)
	s InputObj.ScheduleItemCode=RBASID
	s InputObj.HospitalId=Obj.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s Obj=##class(User.PAPatMas).%OpenId(PatientID)
	s InputObj.CardNo=..GetCardNoByPatientID(PatientID)
	s InputObj.CredTypeCode=##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(Obj.PAPMICardTypeDRGetObjectId())
	s InputObj.IDCardNo=Obj.PAPMIDVAnumber
	s InputObj.LockQueueNo=ExpStr
	;b ;InputObj.LockQueueNo
	s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
	s RtnObj=ClsObj.RemoveLockOrder(InputObj)
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent
RemoveLockOrderErr
	q "-1^RemoveLockOrder调用异常"_$ZERROR
}

/// his先预约及预约取号时调用平台接口
ClassMethod InToOut(ApptID As %String = "", UserID As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).InToOut("81||16||1","1")
	n (ApptID,UserID)
	s $ZT="InToOutErr"
	q:ApptID="" "0^"
	s ApptObj=##class(User.RBAppointment).%OpenId(ApptID)
	s OrderCode=ApptObj.APPTSystemSession
	s ExApptObj=##class(User.DHCRBAppointment).%OpenId(ApptID)
	s LockQueueNo=ExApptObj.APPTLockQueueNo
	s rtn="0^不走外部程序"
	i (OrderCode="")&&(LockQueueNo'=""){ ;预约同时支付
		s rtn=..BookService(ApptObj,UserID)
	}elseif(OrderCode'=""){  ;&&(LockQueueNo="")  支付
		s rtn=..PaymentOrder(ApptObj,UserID)
	}
	q rtn
InToOutErr
	q "-1^InToOut调用异常"_$ZERROR
}

/// 预约挂号
ClassMethod BookService(ApptObj As User.RBAppointment, UserID As %String = "") As %String
{
	n (ApptObj,UserID)
	s $ZT="BookServiceErr"
	s InputObj=..GetInputObj("1000",UserID)
	s InputObj.HospitalId=ApptObj.APPTASParRef.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s InputObj.HISApptID=ApptObj.%Id()
	s InputObj.ScheduleItemCode=ApptObj.APPTASParRefGetObjectId()
	s DHCApptObj=##class(User.DHCRBApptSchedule).%OpenId(InputObj.ScheduleItemCode)
	s TimeRangeDesc=DHCApptObj.ASTimeRangeDR.TRDesc
	;人员信息
	s PatientID=ApptObj.APPTPAPMIDRGetObjectId()
	;s PersonObj=##class(User.PAPatMas).%OpenId(PatientID)
	s InputObj.CardNo=..GetCardNoByPatientID(PatientID)
	s InputObj.CredTypeCode=##class(DHCExternalService.RegInterface.GetRelate).GetOuterCredTypeCode(ApptObj.APPTPAPMIDR.PAPMICardTypeDRGetObjectId())
	s InputObj.IDCardNo=ApptObj.APPTPAPMIDR.PAPMIDVAnumber
	s InputObj.TelePhoneNo=ApptObj.APPTPAPMIDR.PAPMIRowId.PAPERTelH
	s InputObj.MobileNo=ApptObj.APPTPAPMIDR.PAPMIMobPhone
	s InputObj.PatientName=ApptObj.APPTPAPMIDR.PAPMIRowId.PAPERName
	s ExApptObj=##class(User.DHCRBAppointment).%OpenId(ApptObj.%Id())
	s InputObj.LockQueueNo=ExApptObj.APPTLockQueueNo
	//LockQueueNo
	s InputObj.Gender=##class(DHCExternalService.RegInterface.GetRelate).GetOuterSexCode(ApptObj.APPTPAPMIDR.PAPMISexDRGetObjectId())
	s InputObj.Address=ApptObj.APPTPAPMIDR.PAPMIRowId.PAPERStName.GetAt(ApptObj.APPTPAPMIDR.PAPMIRowId.PAPERStName.Count())
	s AdmID= ApptObj.APPTAdmDRGetObjectId()
	if AdmID'="" d
 	.s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",AdmID,0))
 	.s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
 	.;号的信息
	.s InputObj.SeqCode=RegFeeObj.RegfeeNo
	.//得到分时段信息
	.s InputObj.AdmitRange=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(InputObj.ScheduleItemCode,InputObj.SeqCode,TimeRangeDesc)
	.;支付信息
	.s InvID=RegFeeObj.Regfeetemp1.%Id()
	.s PaiedInfo=..GetPaiedInfoByInvID(InvID)
	.s InputObj.PayFlag="Y"
	.s InputObj.PayModeCode=$P(PaiedInfo,"^",1)
	.s InputObj.PayBankCode=$P(PaiedInfo,"^",2)
	.s InputObj.PayCardNo=$P(PaiedInfo,"^",3)
	.s InputObj.PayFee=$P(PaiedInfo,"^",4)
	.s InputObj.PayInsuFee=$P(PaiedInfo,"^",5)
	.;s InputObj.PayTradeNo=""
	.s InputObj.TransactionId=$P(PaiedInfo,"^",6)  ;银医卡支付的流水号
	;调用接口方法
	s ClsObj=$ZOBJCLASSMETHOD(..#BookServiceClassNmae,"%New")
	s RtnObj=ClsObj.BookService(InputObj)
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
		
	i RtnObj.ResultCode=0{
		;保存订单号
		s ApptObj.APPTSystemSession=RtnObj.OrderCode
		s sc=ApptObj.%Save()  //成功的话sc为1
		If ($System.Status.IsError(sc))	
		{
			q "-1^"_$System.Status.GetErrorText(sc)
		}
	}
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent_"^"_RtnObj.OrderCode
BookServiceErr
	q "-1^BookService调用异常"_$ZERROR
}

/// 支付确认
ClassMethod PaymentOrder(ApptObj As User.RBAppointment, UserID As %String = "") As %String
{
	n (ApptObj,UserID)
	s $ZT="PaymentOrderErr"
	s InputObj=..GetInputObj("1002",UserID)
	s InputObj.HospitalId=ApptObj.APPTASParRef.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s InputObj.HISApptID=ApptObj.%Id()
	s InputObj.OrderCode=ApptObj.APPTSystemSession
	s DHCApptObj=##class(User.DHCRBApptSchedule).%OpenId(ApptObj.APPTASParRefGetObjectId())
	s TimeRangeDesc=DHCApptObj.ASTimeRangeDR.TRDesc
	s AdmID= ApptObj.APPTAdmDRGetObjectId()
	i AdmID'="" d
	.s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",AdmID,0))
 	.s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
 	.;号的信息
	.s InputObj.SeqCode=RegFeeObj.RegfeeNo
	.//得到分时段信息
	.s InputObj.AdmitRange=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(ApptObj.APPTASParRefGetObjectId(),InputObj.SeqCode,TimeRangeDesc)
	.;支付信息
	.s InvID=RegFeeObj.Regfeetemp1.%Id()
	.s PaiedInfo=..GetPaiedInfoByInvID(InvID)
	.s InputObj.PayModeCode=$P(PaiedInfo,"^",1)
	.s InputObj.PayBankCode=$P(PaiedInfo,"^",2)
	.s InputObj.PayCardNo=$P(PaiedInfo,"^",3)
	.s InputObj.PayFee=$P(PaiedInfo,"^",4)
	.s InputObj.PayInsuFee=$P(PaiedInfo,"^",5)
	.;s InputObj.PayTradeNo=""
	.s InputObj.TransactionId=$P(PaiedInfo,"^",6)  ;银医卡支付的流水号
	
	;调用接口方法
	s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
	s RtnObj=ClsObj.PaymentOrder(InputObj)
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent
PaymentOrderErr
	q "-1^PaymentOrder调用异常"_$ZERROR
}

/// 退号以及取消预约  his调用平台接口
ClassMethod RefundReg(ApptID As %String = "", UserID As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).RefundReg("81||16||1","1")
	n (ApptID,UserID)
	s $ZT="RefundRegErr"
	s ApptObj=##class(User.RBAppointment).%OpenId(ApptID)
	s OrderCode=ApptObj.APPTSystemSession
	i OrderCode="" q "0^不需要走平台"
	s AdmID=ApptObj.APPTAdmDRGetObjectId()
	i AdmID=""{
		s InputObj=..GetInputObj("1001",UserID)
		s InputObj.HospitalId=ApptObj.APPTASParRef.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
		s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
		s InputObj.OrderCode=OrderCode
		s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
		s RtnObj=ClsObj.CancelOrder(InputObj)
	}else{
		s InputObj=..GetInputObj("1003",UserID)
		s InputObj.HospitalId=ApptObj.APPTASParRef.ASRESParRef.RESCTLOCDR.CTLOCHospitalDRGetObjectId()
		s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
		s InputObj.OrderCode=OrderCode
		s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",AdmID,0))
		s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
		s InvID=RegFeeObj.Regfeetemp1.%Id()
		s RefInvID=$O(^DHCINVPRT(0,"InitInvDR",InvID,0))
		s InvInfo=..GetPaiedInfoByInvID(RefInvID)
		;PayModeCode_"^"_PayBankCode_"^"_PayCardNo_"^"_PayFee_"^"_PayInsuFee_"^"_TransactionId_"^"_RefundType
		s InputObj.TransactionId=$P(InvInfo,"^",6)
		s InputObj.PayBankCode=$P(InvInfo,"^",2)
		s InputObj.PayCardNo=$P(InvInfo,"^",3)
		s InputObj.PayModeCode=$P(InvInfo,"^",1)
		s InputObj.PayFee=$P(InvInfo,"^",4)
		s InputObj.PayInsuFee=$P(InvInfo,"^",5)
		s InputObj.RefundType=$P(InvInfo,"^",7)
		;调用接口方法
		s ClsObj=$ZOBJCLASSMETHOD(..#RegServiceClassNmae,"%New")
		s RtnObj=ClsObj.RefundReg(InputObj)
	}
	i RtnObj.ResultCode>0 s RtnObj.ResultCode=-RtnObj.ResultCode
	q RtnObj.ResultCode_"^"_RtnObj.ResultContent
	
RefundRegErr
	q "-1^RefundReg调用异常"_$ZERROR
}

/// 平台调用此方法向HIS中插入预约以及挂号信息
ClassMethod ImportApptToHIS(InputObj As DHCExternalService.RegInterface.Entity.ImportApptToHISRt) As DHCExternalService.RegInterface.Entity.ImportApptToHISRp
{
	;set rp=##class(DHCExternalService.RegInterface.RegManager).ImportApptToHIS(Obj)
	;n (InputObj)
	s $ZT="ImportApptToHISErr"
	set RtnXml=""
	d InputObj.XMLExportToString(.RtnXml,"Request")
	s ^wrz("ImportApptToHIS")=RtnXml
	//set InputObj=##Class(DHCExternalService.RegInterface.Entity.ImportApptToHISRt).%New()
	//do InputObj.XMLNodeDeserialize(.InputObj,"Request",^wrz("ImportApptToHIS"))
	
	s ^tmpens="aa"
	
	set HospitalId=InputObj.HospitalId
	if (HospitalId'="") set HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId)
	
	s ErrStr=""
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.ImportApptToHISRp).%New()
	i InputObj.RBASId=""{
		s ErrStr = "-1^预约资源不能为空"
		goto SetRtnObj
	}
	i '$D(^RBAS(+InputObj.RBASId,$P(InputObj.RBASId,"||",2))){
		s ErrStr = "-1^预约资源His中不存在"
		goto SetRtnObj
	}
	i InputObj.PatientNo=""{
		s CommonPatientID=""
		s CommonCardNo=##class(web.DHCOPRegConfig).GetSpecConfigNode("CommonCardNo")
		i (CommonCardNo'="") {
			s ExpStr=""_$c(2)_""_$C(2)_"PatInfo"
			s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CommonCardNo,"",ExpStr)
			s retcode=$P(ret,"^",1)
			if (retcode="-201")!(retcode="0"){
			s CommonPatientID=$P(ret,"^",8)
			}
		}
		i CommonPatientID=""{
			s ErrStr = "-1^His系统没有设置公共卡,不能匿名预约"
			goto SetRtnObj
		}
		s InputObj.PatientNo=CommonPatientID
	}else{
		s InputObj.PatientNo=$O(^PAPERi("PAPMI_PatNo",InputObj.PatientNo,0))
		i InputObj.PatientNo=""{
			s ErrStr = "-1^病人主索引不存在"
			goto SetRtnObj
		}
	}
	i InputObj.OrderCode=""{
		s ErrStr = "-1^预约单号不能为空"
		goto SetRtnObj
	}
	s Method=InputObj.Method
	b ;Method
	i Method'="" s Method=$O(^RBC("APTM",0,"Code",Method,0))	
	s BookingSystem=InputObj.ExtOrgCode //预约机构
	i BookingSystem="" s BookingSystem="H1" ;如果为空默认为东华HIS
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,BookingSystem)
	
	s RegType="APP" ;预约方式NORN现场号  APP预约
	s EmployeeNo="" ;工号
	s NeedListen="" ;需要听课证
	s SystemSession=InputObj.OrderCode //订单号
	
	
	s SourceType="AMP"
	i (BookingSystem="H1")&&(InputObj.ClientType="ATM") s SourceType="ATM"
	;s BookingSystem=##class(web.DHCRBCReasonNotAvail).GetBookingSystemByCode(BookingSystem)
	s QueueNo=""
	s ApptStr=InputObj.PatientNo_"^"_InputObj.RBASId_"^"_Method_"^"_"O"_"^"_UserID_"^"_QueueNo
	s ApptStr=ApptStr_"^"_RegType_"^"_EmployeeNo_"^"_NeedListen_"^"_SystemSession_"^"_BookingSystem
	
	s InputObj.CredTypeCode=##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("",InputObj.CredTypeCode)
	;                    姓名                      联系电话                   手机                  证件类型              证件号码
	s ApptStr=ApptStr_"^"_InputObj.PatientName_"^"_InputObj.TelePhoneNo_"^"_InputObj.MobileNo_"^"_InputObj.CredTypeCode_"^"_InputObj.IDCardNo
	//如果已经预约,不是支付的退出
	if (InputObj.ApptId'="")&&(InputObj.PayFlag'="Y"){
		s ErrStr="-1^已经存在预约记录"_InputObj.ApptId_"请调用支付"
		goto SetRtnObj
	}
	TSTART
	i InputObj.ApptId=""{ ;先预约
		s ret=##class(web.DHCRBAppointment).Insert(ApptStr)
		i +ret=0{
			s ApptID=$P(ret,"^",2)
			s SeqCode=$P(ret,"^",3)
		}else{
			TROLLBACK
			s ErrStr="-1^插入预约记录失败"_ret
			goto SetRtnObj
		}
		i InputObj.PayFlag'="Y"{
			TCOMMIT
			s RtnObj.ApptId=ApptID
			s RtnObj.SeqCode=SeqCode
			s ErrStr="0^插入预约记录成功"
			goto SetRtnObj
		}
	}else{ ;确认支付
		s ApptID=InputObj.ApptId
	}
	s Patient=InputObj.PatientNo_"^N"
	s RBAS=InputObj.RBASId_"^"_ApptID
	s AdmReason=""
	s PayModeCode=InputObj.PayModeCode
	s PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode)
	i PayModeCode'="" d
	.s PayModeCode=$P(^CT("CTPM",PayModeCode),"^",1)
	
	s PayModeCode=PayModeCode_"^"_InputObj.PayCardNo_"^"_##class(DHCExternalService.RegInterface.GetRelate).GetLoc(InputObj.ExtUserID)_"^"_HospitalId
	
	;s BankCardNo=$P(PayModeCode,"^",2)
	;s LocID=$P(PayModeCode,"^",3)
	;s HospitalID=$P(PayModeCode,"^",4)
	;s PayModeCode=$P(PayModeCode,"^",1)
	
	
	set AccInfo=..getaccinfofromcardno(InputObj.CardNo,"")
	s AccRowId=$piece(AccInfo,"^",2)
	b ;AccRowId
	;s UserID=UserID
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(InputObj.ExtUserID)
	s AdmType=""
	s DiagnosCatRowId=""
	s TabFreeRegFlag=""
	s TabFreeCheckFlag=""
	s Temp=""
	s myrtn="" ;医保信息串
	s Temp2=""
	s Type="Reg"
	s EmployeeNo="" ;工号
	s InsuranceStr="" ;医保支付串
	;PayBankCode	银行代码
	;PayCardNo	银行卡卡号
	;PayFee	支付费用
	;TransactionId 交易流水号
	;根据银医卡接口需要确定如下四个参数如何使用
	;号源平台传过来的费用和his计算费用的比较
	s PayBankCode=InputObj.PayBankCode
	s PayCardNo=InputObj.PayCardNo
	s PayFee=InputObj.PayFee
	s TransactionId=InputObj.TransactionId
	b ;#HospitalCode
	i ..#HospitalCode="BJXH"{
		s TotalFee=##class(web.DHCOPAdmReg).GetSchedulFeeByConStr(InputObj.RBASId,"")
		;判断所需费用是否一致
		i +PayFee'=+TotalFee
		{
			TROLLBACK
			s ErrStr="-1^挂号所需费用和传入费用不符"_TotalFee
			goto SetRtnObj
			q 
		}
		s CheckFee=##class(web.DHCOPAdmReg).GetSchedulFeeByConStr(InputObj.RBASId,"Check")
		s FeeStr=TotalFee_"||"_CheckFee_"||0||0||0||0||0"
		b ;
		;
		Set ResRowID=$piece(InputObj.RBASId,"||",1)
		Set LocDR=$piece(^RB("RES",ResRowID),"^",1)
		Set rtn=##class(web.DHCDocHardCoded).IsNeedFocusZF(LocDR,InputObj.PatientNo,AdmReason)
		if (rtn=1)
		{
			Set AdmReason=1
		}
		s ret=##class(web.DHCOPAdmReg).OPRegistBroker(Patient,RBAS,AdmReason,QueueNo,FeeStr,PayModeCode,AccRowId,UserID,GroupID,AdmType,DiagnosCatRowId,TabFreeRegFlag,TabFreeCheckFlag,Temp,myrtn,Temp2,Type,EmployeeNo,InsuranceStr,SourceType)
		/// 增加HIS计费和银行扣费的校验
		if ($piece(ret,"$",1)=0)
		{
			set HISFee=$piece(ret,"^",18)+$piece(ret,"^",19)+$piece(ret,"^",20)
			if +PayFee'=+HISFee
			{
				TROLLBACK
				s ErrStr="-1^挂号所需费用和传入费用不符"_HISFee
				goto SetRtnObj
				q 
			}
		}
	}else{
		;判断所需费用是否一致
		s Info=##class(web.DHCOPAdmReg).GetMarkRegFee(InputObj.RBASId,"","")
		s RegFee=$P(Info,"^",12)
		s CheckupFee=$P(Info,"^",14)
		s ServiceFee=""
		s OtherFee=$P(Info,"^",16)+$P(Info,"^",18)+$P(Info,"^",20)
		s TotalFee=RegFee+CheckupFee+ServiceFee+OtherFee //总挂号费
		i +PayFee'=+TotalFee
		{
			TROLLBACK
			s ErrStr="-1^挂号所需费用和传入费用不符"_TotalFee
			goto SetRtnObj
			q 
		}
		s ret=##class(web.DHCOPAdmReg).OPAppArriveBroker("","", ApptID, UserID, GroupID, PayModeCode, AccRowId,"AMP")
	}
	s retFlag=$P(ret,"$",1)
	i (retFlag'=0){
		TROLLBACK
		s ErrStr="-1^插入挂号数据失败"_ret
		goto SetRtnObj
		q 
	}
	i ..#HospitalCode'="BJXH"{
		s AdmitRange="" ;时段信息
		s RegFeeID=$P(ret,"^",38)
	}else{
		s AdmitRange=$P(ret,"^",37) ;时段信息
		s RegFeeID=$P(ret,"^",42)
	}
	s SeqCode=$P(ret,"^",8) ;挂号序号
	s RegFee=$P(ret,"^",17) ;费用
	b ;RegFeeID
	s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
	s InvID=RegFeeObj.Regfeetemp1.%Id()
	/*
	//更新交易流水对应的信息
	s ret=##class(web.DHCBillBankLogicBJXH).UpdateTradeSub(TransactionId,InvID,"")
	i (+ret'=0){
		TROLLBACK
		s ErrStr="-1^交易流水数据失败"_ret
		goto SetRtnObj
		q 
	}
	*/
	s BankOutputXML="<Response><AcctDate>"_+$H_"</AcctDate><AcctTime>"_..%SysTime()_"</AcctTime>"
	s RegNo=..PatientIDToNo(InputObj.PatientNo)
	s BankOutputXML=BankOutputXML_"<TransactionId>"_TransactionId_"</TransactionId><PatientID>"_RegNo_"</PatientID>"
	s BankOutputXML=BankOutputXML_"<ResultCode>000</ResultCode><ErrorMsg></ErrorMsg></Response>"
	//PatType, Guser, BankTradeType, BankOutputXML As %String, ExpStr As %String
	b ;
	if (TransactionId'="")
	{
		s ret=##class(web.DHCBillBankLogicBJXH).UpdateTradeInfo("OP",UserID,"C",TransactionId,InvID,"",BankOutputXML,"")
		b ;UpdateTradeInfo
		i (+ret'=0){
			TROLLBACK
			s ErrStr="-1^交易数据失败"_ret
			goto SetRtnObj
			q 
		}
	}
	//更新交易流水对应的信息End
	
	s InvInfo=..GetPaiedInfoByInvID(InvID)
	b ;InvInfo
	;PayModeCode_"^"_PayBankCode_"^"_PayCardNo_"^"_PayFee_"^"_PayInsuFee_"^"_TransactionId_"^"_RefundType
	s TransactionId=$P(InvInfo,"^",6)
	/*
	s InputObj.PayBankCode=$P(InvInfo,"^",2)
	s InputObj.PayCardNo=$P(InvInfo,"^",3)
	s InputObj.PayModeCode=$P(InvInfo,"^",1)
	s InputObj.PayFee=$P(InvInfo,"^",4)
	s InputObj.PayInsuFee=$P(InvInfo,"^",5)
	s InputObj.RefundType=$P(InvInfo,"^",7)
	*/
	s RtnObj.ApptId=ApptID
	s RtnObj.SeqCode=SeqCode ;挂号序号
	s RtnObj.RegFee=RegFee ;费用
	s RtnObj.AdmitRange=AdmitRange ;时段信息
	s RtnObj.TransactionId=TransactionId ;交易流水号
	b ;TCOMMIT
	TCOMMIT
	
	s ErrStr="0^插入数据成功"
	goto SetRtnObj
	q
SetRtnObj
	s RtnObj.Result=$P(ErrStr,"^",1)
	s RtnObj.ErrorMsg=$P(ErrStr,"^",2)
	q RtnObj
ImportApptToHISErr
	TROLLBACK
	s ErrStr="-1^ImportApptToHIS调用异常"_$ZERROR
	goto SetRtnObj
}

/// 平台调用 取消HIS中的预约
ClassMethod CancelOrderToHIS(InputObj As DHCExternalService.RegInterface.Entity.CancelOrderToHISRt) As DHCExternalService.RegInterface.Entity.CancelOrderToHISRp
{
	n (InputObj)
	s $ZT="CancelOrderToHISErr"
	d InputObj.XMLExportToString(.RtnXml,"Request")
	s ^wrz("CancelOrderToHIS")=RtnXml
	//set InputObj=##Class(DHCExternalService.RegInterface.Entity.CancelOrderToHISRt).%New()
	//do InputObj.XMLNodeDeserialize(.InputObj,"Request",^wrz("CancelOrderToHIS"))
	s ErrStr=""
	s RtnObj=##class(DHCExternalService.RegInterface.Entity.CancelOrderToHISRp).%New()
	s ApptObj=##class(User.RBAppointment).%OpenId(InputObj.ApptId)
	if '($IsObject(ApptObj))
	{
		s ErrStr="-1^传入预约记录ID不存在"
		goto SetObj
	}
	s BookingSystem=InputObj.ExtOrgCode //预约机构
	i BookingSystem="" s BookingSystem="H1" ;如果为空默认为东华HIS	
	s PatientID=ApptObj.APPTPAPMIDRGetObjectId()
	s UserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser(InputObj.ExtUserID,BookingSystem)
	s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(InputObj.ExtUserID)
	s LocID=##class(DHCExternalService.RegInterface.GetRelate).GetLoc(InputObj.ExtUserID)
	s TransactionId=InputObj.TransactionId
	if ApptObj.APPTAdmDRGetObjectId()=""{
		s ret=##class(web.DHCRBAppointment).CancelAppointment(InputObj.ApptId,UserID,"AMP")
	}else{
		
		s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",ApptObj.APPTAdmDRGetObjectId(),0))
		s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
		s OldInvID=RegFeeObj.Regfeetemp1.%Id()
		i ..#HospitalCode'="BJXH"{
			s ret=##class(web.DHCOPAdmReg).CancelOPRegistBroker("","",RegFeeID,UserID,GroupID,LocID,"AMP")
		}else{
			s ret=##class(web.DHCOPAdmReg).CancelOPRegistBroker("","",RegFeeID,UserID,GroupID,LocID,0,"AMP")
		}	
	}
	i $P(ret,"$",1)'=0{
		TROLLBACK
		s ErrStr="-1^退号失败"_$P(ret,"$",1)
		goto SetObj
	}
	if (ApptObj.APPTAdmDRGetObjectId()'="")&&(OldInvID'=""){
		//s RegFeeObj=##class(User.DHCRegistrationFee).%OpenId(RegFeeID)
		s RefInvID=$O(^DHCINVPRT(0,"InitInvDR",OldInvID,0))
		s InvID=$O(^DHCINVPRT(0,"OldINV",OldInvID,0))
		set InvInfo=..GetPaiedInfoByInvID(OldInvID)
		set CardNo=$piece(InvInfo,"^",3)
		set PaidHISTransactionId=$piece(InvInfo,"^",6)
		set HospitalId=$piece(InvInfo,"^",7)
		set PrtDate=$piece(^DHCINVPRT(OldInvID),"^",5)
		if (PaidHISTransactionId'="")
		{
			set TradeType="D"      //"D" 当日退费 ；"T" 隔日退费
			if (InputObj.RefundType="TH") set TradeType="T"
			if (PrtDate'=..%SysDate()) set TradeType="T"
			set HISTransRtn=##class(web.DHCBillBankLogicBJXH).SetTradeID(CardNo,TradeType,HospitalId,"")
			set HISTransactionId=$piece(HISTransRtn,"^",3)
			/*
			//更新交易流水对应的信息
			s ret=##class(web.DHCBillBankLogicBJXH).UpdateTradeSub(HISTransactionId,InvID,RefInvID)
			i (+ret'=0){
				TROLLBACK
				s ErrStr="-1^交易流水数据失败"_ret
				goto SetObj
				q 
			}
			*/
			s BankOutputXML="<Response><AcctDate>"_+$H_"</AcctDate><AcctTime>"_..%SysTime()_"</AcctTime>"
			s RegNo=..PatientIDToNo(PatientID)
			s BankOutputXML=BankOutputXML_"<TransactionId>"_TransactionId_"</TransactionId><PatientID>"_RegNo_"</PatientID>"
			s BankOutputXML=BankOutputXML_"<ResultCode>000</ResultCode><ErrorMsg></ErrorMsg></Response>"
			//PatType, Guser, BankTradeType, BankOutputXML As %String, ExpStr As %String
			s ret=##class(web.DHCBillBankLogicBJXH).UpdateTradeInfo("OP",UserID,TradeType,HISTransactionId,InvID,RefInvID,BankOutputXML,"")
			i (+ret'=0){
				TROLLBACK
				s ErrStr="-1^交易数据失败"_ret
				goto SetObj
				q 
			}
		
			s InvInfo=..GetPaiedInfoByInvID(RefInvID)
			;PayModeCode_"^"_PayBankCode_"^"_PayCardNo_"^"_PayFee_"^"_PayInsuFee_"^"_TransactionId_"^"_RefundType
			s RtnObj.TransactionId=$P(InvInfo,"^",6)
		}	
	}
	s ErrStr="0^退号成功"
	goto SetObj
	q
SetObj
	s RtnObj.ResultCode=$P(ErrStr,"^",1)
	s RtnObj.ErrorMsg=$P(ErrStr,"^",2)
	q RtnObj
CancelOrderToHISErr
	TROLLBACK
	s ErrStr="-1^CancelOrderToHIS调用异常"_$ZERROR
	goto SetObj
}

/// 挂号退费通知 调用平台接口
ClassMethod RegfeeRefund(ApptID As %String = "", ExpStr As %String = "") As %String
{
	;http://10.64.16.204:57772/csp/dhcens/KZF.BS.Web.Cardpayment.cls?wsdl
	;ExpStr "HospitalId^TransactionId^PayBankCode^PayCardNo^PayFee^PaidTransactionId"
	n (ApptID,ExpStr)
	s $ZT="RegfeeRefundErr"
	q:ApptID="" "-2^预约记录不能为空"
	s ApptObj=##class(User.RBAppointment).%OpenId(ApptID)
	s InputObj=##class(DHCExternalService.RegInterface.Entity.RegfeeRefund).%New()
	s InputObj.OrderCode=ApptObj.APPTSystemSession
	s InputObj.HospitalId=$P(ExpStr,"^",1)
	s InputObj.HospitalId=..GetHospitalCode(InputObj.HospitalId)
	s InputObj.TransactionId=$P(ExpStr,"^",2)
	s InputObj.TradeCode="2002"
	s InputObj.PayBankCode=$P(ExpStr,"^",3)
	s InputObj.PayCardNo=$P(ExpStr,"^",4)
	s InputObj.PayFee=$P(ExpStr,"^",5)
	s InputObj.PayFee=..GetFormatNum(InputObj.PayFee)
	s InputObj.PayTradeNo=""
	s InputObj.PayDate=ApptObj.APPTTransDate
	s InputObj.PayDate=..GetFormatDate(InputObj.PayDate)
	s InputObj.PayTime=ApptObj.APPTTransTime
	s InputObj.PayTime=..GetFormatTime(InputObj.PayTime)
	s InputObj.RefundDate=..%SysDate()
	s InputObj.RefundDate=..GetFormatDate(InputObj.RefundDate)
	s InputObj.RefundTime=..%SysTime()
	s InputObj.RefundTime=..GetFormatTime(InputObj.RefundTime)
	s InputObj.PaidTransactionId=$P(ExpStr,"^",6)
	;d InputObj.XMLExportToString(.RequestXml,"Response")
	s rtn=##class(InterfaceMethods).RegfeeRefund(InputObj)
	if (rtn="^") quit "-3^银行退费通知交易返回失败"
	q rtn
RegfeeRefundErr
	q "-1^RegfeeRefund调用异常"_$ZERROR
}

/// 得到入参对象
ClassMethod GetInputObj(TradeCode As %String = "", UserID As %String = "") As DHCDoc.Util.RegisteredObject
{
	n (TradeCode,UserID)
	s:TradeCode="1007" ClassName=..#RegServicePackageNmae_".UpdateNotifyStatusRt"
	s:TradeCode="1008" ClassName=..#RegServicePackageNmae_".LockOrderRt"
	s:TradeCode="1009" ClassName=..#RegServicePackageNmae_".RemoveLockOrderRt"
	s:TradeCode="1002" ClassName=..#RegServicePackageNmae_".PaymentOrderRt"
	s:TradeCode="1003" ClassName=..#RegServicePackageNmae_".RefundRegRt"
	s:TradeCode="1001" ClassName=..#RegServicePackageNmae_".CancelOrderRt"
	s:TradeCode="1000" ClassName=..#BookServicePackageNmae_".ServiceBookRt"
	
	s InputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	s InputObj.TradeCode=TradeCode //交易类型
	s InputObj.ClientType="WIN" //客户端类型
	s InputObj.ExtUserID=UserID //用户
	s InputObj.ExtOrgCode="H1" //预约机构
	q InputObj
}

/// 根据病人ID得到第一个可用的卡号
ClassMethod GetCardNoByPatientID(PatientID)
{
	;w ##class(DHCExternalService.RegInterface.CardManager).GetCardNoByPatientID(2)
	n (PatientID)
	s CardNo=""
	s CFID=0
	f  s CFID=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFID)) q:(CFID="")||(CardNo'="")  d
	.s Status=$P(^DHCCARD("CF",CFID),"^",10)
	.q:Status'="N"
	.s CardNo=$P(^DHCCARD("CF",CFID),"^",2)
	q CardNo
}

// 得到卡号、银行代码、交易流水号需要补充

/// 根据发票表ID得到支付信息
ClassMethod GetPaiedInfoByInvID(InvID)
{
	;w ##class(DHCExternalService.RegInterface.RegManager).GetPaiedInfoByInvID("180273")
	;PayModeCode_"^"_PayBankCode_"^"_PayCardNo_"^"_PayFee_"^"_PayInsuFee_"^"_TransactionId_"^"_RefundType
	n (InvID)
	s (RtnStr,PayModeCode,PayBankCode,PayCardNo,PayFee,PayInsuFee,TransactionId,HosptialID)=""
	s i=1
	s sub=0
	f  s sub=$O(^DHCINVPRT(InvID,"P",sub)) q:sub=""  d
	.s PayModeID=$P(^DHCINVPRT(InvID,"P",sub),"^",1)
	.b ;PayModeID
	.s Fee=$P(^DHCINVPRT(InvID,"P",sub),"^",3)
	.s:i=1 PayModeCode=##class(DHCExternalService.RegInterface.GetRelate).GetOuterPayModeCode(PayModeID)
	.s:i=1 PayFee=Fee
	.s:i>1 PayInsuFee=PayInsuFee+Fee
	.s i=i+1
	//根据发票得到交易流水信息以及卡号信息
	s TradID=##class(web.DHCBillBankLogicBJXH).GetOriginalTradeRowID(InvID)
	i TradID'="" d
	.s TransactionId=$p(^DHCINVBTP(TradID),"^",32)
	.s PayCardNo=$p(^DHCINVBTP(TradID),"^",3)
	.s HosptialID=$p(^DHCINVBTP(TradID),"^",28)
	.s CardID=$O(^DHCCARDi("CF",0,"CardNo",PayCardNo,0))
	.i CardID'="" d
	..s CardType=$P(^DHCCARD("CF",CardID),"^",16)
	..i CardType'="" d
	...s PayBankCode=##class(CardInterface.GetRelate).GetBankCodeByCardType(CardType)
	s RtnStr=PayModeCode_"^"_PayBankCode_"^"_PayCardNo_"^"_PayFee_"^"_PayInsuFee_"^"_TransactionId_"^"_HosptialID
	q RtnStr
}

/// PatientID to RegNo
ClassMethod PatientIDToNo(PatientID As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).PatientIDToNo("6")
	n (PatientID)
	q:PatientID="" ""
	q $P(^PAPER(PatientID,"PAT",1),"^",1)
}

/// RegNo to PatientID
ClassMethod PatientNoToID(RegNo As %String = "") As %String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).PatientNoToID("00000006")
	n (RegNo)
	q:RegNo="" ""
	q $O(^PAPERi("PAPMI_PatNo",RegNo,0))
}

ClassMethod RegQueryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = RegQueryExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RegQueryExecute(ByRef QHandle As %Binary, StDate, EdDate, RLoc, RDoc, CardNo, RegNo, PatName, HadGot, RegfeeID) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCExternalService.RegInterface.RegManager","RegQuery","61345","61345","","","","","")
   	Set repid=$I(^CacheTemp)
   	If $g(ind)="" Set ind=1
   	i RegNo'="" d
   	.s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	.s RegNo=$e("0000000000000000000",1,myPatLen-$l(RegNo))_RegNo
	i StDate="" s StDate=1
  	i EdDate="" s EdDate=..%SysDate()+30
  	
   	i RegfeeID'="" d
   	.d GetOneInfo(RegfeeID,"")
   	e  i RegNo'=""  d
  	.s PatientID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
  	.q:PatientID=""
  	.d GetInfoByPatientID(PatientID)
  	e  i CardNo'=""  d
  	.s CardID=0
  	.f  s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID)) q:CardID=""  d
  	..s Status=$p(^DHCCARD("CF",CardID),"^",10)
  	..q:Status'="N"
  	..s PatientID=$p(^DHCCARD("CF",CardID),"^",4)
  	..d GetInfoByPatientID(PatientID)
  	e  i PatName'=""  d
  	.s Name=$ZCVT(PatName,"U")
  	.s PName=$O(^PAPERi("PAPER_PatName",Name),-1)
  	.f  s PName=$O(^PAPERi("PAPER_PatName",PName)) q:(PName'[Name)||(PName="")  d
  	..s PatientID=""
  	..f  s PatientID=$O(^PAPERi("PAPER_PatName",PName,PatientID)) q:PatientID=""  d
  	...d GetInfoByPatientID(PatientID)
  	e  d
  	.i RDoc'=""  d
  	..s Type=""
  	..f  s Type=$O(^PAADMi("TypeLocDocDateTime",Type)) q:Type=""  d
  	...q:(Type'="O")&&(Type'="E")
  	...s Date=EdDate+1
  	...f  s Date=$O(^PAADMi("TypeLocDocDateTime",Type,RLoc,RDoc,Date),-1) q:(Date="")||(Date<StDate)  d
	....s Time=""
	....f  s Time=$O(^PAADMi("TypeLocDocDateTime",Type,RLoc,RDoc,Date,Time),-1) q:(Time="")  d
	.....s Adm=""
	.....f  s Adm=$O(^PAADMi("TypeLocDocDateTime",Type,RLoc,RDoc,Date,Time,Adm),-1) q:(Adm="")  d
	......d GetOneInfo("",Adm)
  	.e  i RLoc'=""  d
  	..s Type=""
  	..f  s Type=$O(^PAADMi("TDepDateTime",Type)) q:Type=""  d
  	...q:(Type'="O")&&(Type'="E")
  	...s Date=EdDate+1
  	...f  s Date=$O(^PAADMi("TDepDateTime",Type,RLoc,Date),-1) q:(Date="")||(Date<StDate)  d
	....s Time=""
	....f  s Time=$O(^PAADMi("TDepDateTime",Type,RLoc,Date,Time),-1) q:(Time="")  d
	.....s Adm=""
	.....f  s Adm=$O(^PAADMi("TDepDateTime",Type,RLoc,Date,Time,Adm),-1) q:(Adm="")  d
	......d GetOneInfo("",Adm)
  	.e  d
  	..s Type=""
  	..f  s Type=$O(^PAADMi("TypeDate",Type)) q:Type=""  d
  	...q:(Type'="O")&&(Type'="E")
  	...s Date=EdDate+1
  	...f  s Date=$O(^PAADMi("TypeDate",Type,Date),-1) q:(Date="")||(Date<StDate)  d
  	....s Time=""
  	....f  s Time=$O(^PAADMi("TypeDate",Type,Date,Time),-1) q:(Time="")  d
  	.....s Adm=""
  	.....f  s Adm=$O(^PAADMi("TypeDate",Type,Date,Time,Adm),-1) q:(Adm="")  d
  	......d GetOneInfo("",Adm)
  	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
GetInfoByPatientID(PatientID)
	s Type=""
  	f  s Type=$O(^PAPERdr(PatientID,"ADM",Type)) q:Type=""  d
  	.q:(Type'="O")&&(Type'="E")
  	.s Adm=""
  	.f  s Adm=$O(^PAPERdr(PatientID,"ADM",Type,Adm),-1) q:Adm=""  d
  	..d GetOneInfo("",Adm)
  	q
	
GetOneInfo(RegID,AdmID)
	d SerVarDefault
	i RegID'="" d
	.s RegObj=##class(User.DHCRegistrationFee).%OpenId(RegID)
	.s AdmID=RegObj.RegfeeAdmDr.%Id()
	.s AdmObj=##class(User.PAAdm).%OpenId(AdmID)
	e  d
	.s AdmObj=##class(User.PAAdm).%OpenId(AdmID)
	.s RegID=$O(^User.DHCRegistrationFeeI("ADM",AdmID,""))
	.s RegObj=##class(User.DHCRegistrationFee).%OpenId(RegID)
	Q:'$IsObject(RegObj)
	s Status=AdmObj.PAADMVisitStatus
	q:Status="C"
	s THadGot=RegObj.RegfeePrint
	q:(THadGot="Y")&&(HadGot="")
	q:(THadGot'="Y")&&(HadGot'="")
	i THadGot="Y" d
	.s THadGot="1"
	e  d
	.s THadGot=0
	s TPatNo=AdmObj.PAADMPAPMIDR.PAPMINo
	q:(RegNo'="")&&(RegNo'=TPatNo)
	s TPatName=AdmObj.PAADMPAPMIDR.PAPMIName
	q:(PatName'="")&&(TPatName'[PatName)
	s TPatMNo=AdmObj.PAADMPAPMIDR.PAPMIMedicare
	s RegLoc=AdmObj.PAADMDepCodeDRGetObjectId()
	q:(RLoc'="")&&(RLoc'=RegLoc)
	s TRegLoc=AdmObj.PAADMDepCodeDR.CTLOCDesc
	s RegDoc=AdmObj.PAADMAdmDocCodeDRGetObjectId()
	q:(RDoc'="")&&(RDoc'=RegDoc)
	s TRegDoc=AdmObj.PAADMAdmDocCodeDR.CTPCPDesc
	s TRegDate=AdmObj.PAADMAdmDate
	q:(TRegDate<StDate)||(TRegDate>EdDate)
	s TRegDate=$ZD(TRegDate,3)
	s TRegfeeID=RegID
	s TArcType=RegObj.RegfeeSessionTypeDr.%Id()
	i TArcType'="" s TArcType=$p(^RBC("SESS",TArcType),"^",2)
	s FeeInfo=..GetRegFee(RegID)
	s TRegFee=$P(FeeInfo,"^",3)
	s TFormFee=$P(FeeInfo,"^",5)
	s TExamFee=$P(FeeInfo,"^",4)
	s TInsuFee=$P(FeeInfo,"^",6)
	i $D(^RBAS("PAADM_DR",AdmID)) d
   	.s resID=$O(^RBAS("PAADM_DR",AdmID,""))
   	.s resSub=$O(^RBAS("PAADM_DR",AdmID,resID,""))
   	.s apptSub=$O(^RBAS("PAADM_DR",AdmID,resID,resSub,""))
   	.s methodDR=$P(^RBAS(resID,resSub,"APPT",apptSub),"^",12)
   	.q:methodDR=""
   	.s TRegType=$P(^RBC("APTM",methodDR),"^",2)
   	e  s TRegType="即日"
	s TInvNo=RegObj.Regfeetemp1.%Id()
	i TInvNo'="" s TInvNo=$p(^DHCINVPRT(TInvNo),"^",14)
	d OutputRow3
	q
OutputRow3
    set Data=$lb(TPatNo,TPatMNo,TPatName,TRegLoc,TRegDoc,TArcType,TRegDate,TRegFee,TFormFee,TExamFee,TRegTime,TRegType,TInvNo,THadGot,TRegfeeID,TSelect,TInsuFee)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
SerVarDefault
	s (TPatNo,TPatMNo,TPatName,TRegLoc,TRegDoc,TArcType,TRegDate,TRegFee,TFormFee,TExamFee,TRegTime,TRegType,TInvNo,THadGot,TRegfeeID,TSelect,TInsuFee)=""
	q
}

ClassMethod RegQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegQueryExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query RegQuery(StDate, EdDate, RLoc, RDoc, CardNo, RegNo, PatName, HadGot, RegfeeID) As %Query(ROWSPEC = "TPatNo:%String,TPatMNo:%String,TPatName:%String,TRegLoc:%String,TRegDoc:%String,TArcType:%String,TRegDate:%String,TRegFee:%String,TFormFee:%String,TExamFee:%String,TRegTime:%String,TRegType:%String,TInvNo:%String,THadGot:%String,TRegfeeID:%String,TSelect:%String,TInsuFee:%String")
{
}

// 根据挂号记录计算挂号费用

ClassMethod GetRegFee(RegID)
{
	;w ##class(DHCExternalService.RegInterface.CardManager).GetRegFee("1390")
	n (RegID,Type)
	s (TotalFee,AppFee,RegFee,CheckFee,OtherFee,InsuFee)=0
	s RegObj=##class(User.DHCRegistrationFee).%OpenId(RegID)
	s InvID=RegObj.Regfeetemp1.%Id()
	q:InvID="" TotalFee
	s ConRowId=$O(^DHCBCI(0,"INV",InvID,0))
	q:ConRowId="" TotalFee
	s PBRowId=$P(^DHCBCI(ConRowId),"^",2)
	q:PBRowId="" TotalFee
	s InsuInfo1=RegObj.RegfeeInsuCount ;个人账户
	s InsuInfo2=RegObj.RegfeeInsuFund ;基金支付
	s InsuFee=$P(InsuInfo1,"!",2)+$P(InsuInfo2,"!",2)
	s PBOChild=0 
	f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
	.s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
	.Q:ArcimId=""
	.s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
	.s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
	.i type="App" d
	..s AppFee=AppFee+BillSum
	.e  i type="Reg" d
	..s RegFee=RegFee+BillSum
	.e  i type="Check" d
	..s CheckFee=CheckFee+BillSum
	.e  d
	..s OtherFee=OtherFee+BillSum
	.s TotalFee=TotalFee+BillSum
	q TotalFee_"^"_AppFee_"^"_RegFee_"^"_CheckFee_"^"_OtherFee_"^"_InsuFee
}

// 更新领取发票标志

ClassMethod GetInv(InvNo, RegIDs, UserID, GroupID, LocID, InsuInfo)
{
	n (InvNo,RegIDs,UserID,GroupID,LocID,InsuInfo)
	s Hospital=$P(LocID,"^",2)
	s LocID=$P(LocID,"^",1)
	s NowDate=..%SysDate()
	s NowTime=$piece($H,",",2)
	Set InvoiceId=$List(^User.DHCRegistrationFeeD(RegIDs),11)
	q:InvoiceId="" "非东华系统挂号,请到联众取票!"
	TSTART
	s SQLCODE=0
	s l=$L(RegIDs,"^")
	f i=1:1:l
	{
		s RegID=$P(RegIDs,"^",i)
		//&SQL(Update Sqluser.DHCRegistrationFee set RegfeePrint='Y',RegfeePrintUserDR=:UserID,RegfeePrintDate=:NowDate,RegfeePrintTime=:NowTime where ID=:RegID)
		q:SQLCODE'=0
	}
	i SQLCODE'=0{
		TROLLBACK
		q SQLCODE_"RegFee"
	}
	Set InvoiceId=$List(^User.DHCRegistrationFeeD(RegIDs),11)
	Set RegLocId=$List(^User.DHCRegistrationFeeD(RegIDs),13)
	Set RegLocDesc=""
	if RegLocId'="" {
		Set RegLocDesc=$p(^CTLOC(RegLocId),"^",2)	
	}
	if InvoiceId'=""{
		Set InvoiceNo=$P(^DHCINVPRT(InvoiceId),"^",14)
		if (InvoiceNo="")&&(RegLocDesc["特需") {
			if (InvNo'=""){ ;红冲发票
				s NeedInvFlag=""
				i InvNo'="" s NeedInvFlag="Y" ;判断是否需要更新发票号
				s ExpStr="S^"_NeedInvFlag
				s SQLCODE=##class(web.DHCOPAdmReg).OPReBillCharge(RegIDs, UserID,GroupID,LocID,ExpStr,InsuInfo)
				i SQLCODE'=0{
					TROLLBACK
					s:SQLCODE=109 SQLCODE="-109没有票据"
					q SQLCODE_"OPReBillCharge"
				}
				TCOMMIT
				q SQLCODE	
			}
		}else{
			//Set ^DHCDocRegInvPrint("InvPrint",InvoiceId)=""
			TCOMMIT
			Quit 0	
		}
	}
}

// 验证医保信息是否正确

ClassMethod CheckInsuCard(RegfeeID, CardNo, YBCode)
{
	n (RegfeeID,CardNo,YBCode)
	s PatientID=""
	s CardID=0
  	f  s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID)) q:CardID=""  d
  	.s Status=$p(^DHCCARD("CF",CardID),"^",10)
  	.q:Status'="N"
  	.s PatientID=$p(^DHCCARD("CF",CardID),"^",4)
  	q:PatientID="" "-1^医保卡好还没有对照病人信息"
  	s OldYBCode=$P(^PAPER(PatientID,"ALL"),"^",19)
  	q:OldYBCode'=YBCode "-1^医保号和原有医保号不一致"
  	s AdmID=$LG(^User.DHCRegistrationFeeD(RegfeeID),2)
  	s OldPatient=$P(^PAADM(AdmID),"^",1)
  	q:OldPatient'=PatientID "-1^挂号患者和医保卡持有者不是一个人"
  	q 0
}

// 得到医保挂号信息串

ClassMethod GetInsuInfo(RegfeeID, UserID)
{
	n (RegfeeID,UserID)
	s AdmID=$LG(^User.DHCRegistrationFeeD(RegfeeID),2)
  	s Patient=$P(^PAADM(AdmID),"^",1)
	s RBASID=$LG(^User.DHCRegistrationFeeD(RegfeeID),18)
	s obj=##class(User.RBApptSchedule).%OpenId(RBASID)
	s loc=obj.ASRESParRef.RESCTLOCDRGetObjectId()
	s AdmReason=$P(^PAADM(AdmID,1),"^",7)
	s FeeInfo=..GetRegFee(RegfeeID)
	s totalFee=$P(FeeInfo,"^",1)
	s checkFee=$P(FeeInfo,"^",4)
	s FeeStr=totalFee_"||"_checkFee_"||"_0_"||"_0_"||"_0_"||"_0_"||"_0
	q ##class(web.DHCOPAdm).GetInsuBillPara(loc,"",Patient,UserID,RBASID,AdmReason,FeeStr,"","","","")
}

/// 得到医院代码
ClassMethod GetHospitalCode(ID)
{
	q:ID="" ""
	q ##class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(ID)
	//q $P($G(^CT("HOSP",ID)),"^",1)
}

/// 得到规定格式的日期
ClassMethod GetFormatDate(DateNum)
{
	q:DateNum="" ""
	q $ZD(DateNum,3)
}

/// 得到规定格式的时间
ClassMethod GetFormatTime(TimeNum)
{
	q:TimeNum="" ""
	q ..%ZT(TimeNum)
}

/// 得到规定格式的数值
ClassMethod GetFormatNum(Num)
{
	q:Num="" "0.0"
	q $j(Num,1,2)
}

ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String) As %Library.String
{
	;w ##class(DHCExternalService.RegInterface.RegManager).getaccinfofromcardno("0000000137","")
	n (cardno, securityno)
	
	q:cardno="" "-200^^^^^^^^"		;;无效卡标志
	
	s rtn=0
	
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myACFlag=-200		;无效卡
	
	s myAccType="P"
	
	;逻辑：找到有效卡后，不应该在循环了
	s dd=##class(web.UDHCCardInfoResume).AutoRepairSec(cardno,securityno)
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s cardid="0"
	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:(ActiveFlag'="N")&&(ActiveFlag'="UA")
	.;s CardID=cardid
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.;b
	.;q:SecurityNO'=mySecNoEncrypt			;securityno
	.;判断有效卡标志
	.s myACFlag=0		;此卡有效
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s myCardRowID=cardid
	.s PAPMINo=##Class(web.PAPatMas).GetRegistration(Papmi)
	.s cfrowid=$p(^DHCCARD("CF",cardid),"^",1)
	.q:cfrowid=""
	.s AccStatus=$p(^DHCACD("AccM",cfrowid),"^",13)
	.q:AccStatus'="N"
	.s AccID=cfrowid
	.s AccNo=$p(^DHCACD("AccM",cfrowid),"^",1)
	.;s RegNo=$p(^DHCACD("AccM",cfrowid),"^",3)
	.;s CardNo=$p(^DHCACD("AccM",cfrowid),"^",4)
	.s Balance=$p(^DHCACD("AccM",cfrowid),"^",8)
	.s Pass=$p(^DHCACD("AccM",cfrowid),"^",12)
	.s DepPrice=$p(^DHCACD("AccM",cfrowid),"^",14)
	.s left=Balance-DepPrice
	.s myAccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.;s AccType= $p(^DHCACD("AccM",cfrowid),"^",16)
	.;s CredTypeID=$p(^DHCACD("AccM",cfrowid),"^",17)
	.;s IDCardNo=$p(^DHCACD("AccM",cfrowid),"^",18)
	
	s rtn=myACFlag
	;卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) d
	.s rtn=-201
	
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	
	q str
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装HIS预约方法
ClassMethod AppInsert(ApptStr As %String) As %String
{
	;1.先调用HIS预约
	;2.提交,如果失败撤销锁号
	n (ApptStr)
	s $ZT="ERROR^DHCSSERR"
	s PatientID=$P(Para,"^",1) ;病人ID
	s RBASId=$P(Para,"^",2) ;资源ID
	s MethodDR=$P(Para,"^",3) ;预约方式ID
	s AdmType=$P(Para,"^",4) ;病人类型
	s UserDR=$P(Para,"^",5) ;用户
	s MethodCode=""
	i MethodDR'="" s MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
	s SystemSession=$P(ApptStr,"^",10) //订单号
	TS
	s ret=##class(web.DHCRBAppointment).Insert(ApptStr)
	s ApptRowid=$p(ret,"^",2)
	if +ret'=0 {
		goto ROLLBACKAppInsert
	}
	TC
	
	Q ret
ROLLBACKAppInsert
	d ..RemoveLockOrder(RBASId,PatientID,UserDR,LockQueueNo)
	TRO
	Q "-203"
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装预约锁号源平台号方法,如果是院内预约则需要锁号,外部预约都由号源平台锁号
ClassMethod AppLockOrder(SystemSession As %String, MethodCode As %String) As %String
{
	n (SystemSession,MethodCode)
	s LockQueueNo=""
	i (SystemSession="")&&(MethodCode'="VIP")&&(MethodCode'="DOC")&&(MethodCode'="DOCADD")
	{
		s ret=..LockOrder(RBASId,PatientID,UserDR)
		i +ret=0 {
			s LockQueueNo=$P(ret,"^",3)
		}
	}
	
	Q LockQueueNo
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装出HIS挂号回调号源平台方法,供HIS挂号调用
ClassMethod RegSourcePlat(Para As %String) As %String
{
	n (Para)
	s ret=0
	s APPTRowId=$p(Para,"^",1)
	s SourceType=$p(Para,"^",2)
	s LocID=$p(Para,"^",3)
	s group=$p(Para,"^",4)
	s HospitalID=$p(Para,"^",5)
	s user=$p(Para,"^",6)
	s InvoiceRowid=$p(Para,"^",7)
	s BankCardNo=$p(Para,"^",8)
	
	s $ZT="ERROR^DHCSSERR"
	TS
	s BankPayFlag=1
	i (SourceType="His")||(SourceType="ATM"){ 
		;his发起或者自助发起的交易调用银医卡支付接口
		s BankExpStr=LocID_"^"_group_"^"_HospitalID
		s ret=##class(web.DHCBillBankLogicBJXH).BankPay("OP",user,InvoiceRowid,"",BankCardNo,"P",BankExpStr)
		i +ret=-1{  //不是银医卡支付
			s BankPayFlag=0
		}elseif +ret'=0{
			TRollback
			q -2011_"银医卡支付失败"
		}
	}
	i (APPTRowId'="")&&(SourceType="His"){
		//号源平台接口
		s ret=##class(DHCExternalService.RegInterface.RegManager).InToOut(APPTRowId,user)
		i (+ret'=0)&&(BankPayFlag=0){  //不是银医卡支付参与事务处理
			TRollback
			q ret
		}
		i (+ret'=0){ ;错误做出记录因为银医卡已经支付不回滚
			s ^DHCOPAMPInterface("Failure","InToOut",APPTRowId)=$H
		}
	}
	TC
	
	Q ret
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装出HIS退号回调号源平台方法,供HIS挂号调用
ClassMethod RegRefundSourcePlat(Para As %String) As %String
{
	n (Para)
	;s Para=InvoiceId_"^"_DoType_"^"_LogonLocRowId_"^"_GroupRowId_"^"_HospitalId_"^"_APPTRowId_"^"_UserRowId_"^"_NewInvoiceId
	s ret=0
	s InvoiceId=$p(Para,"^",1)
	s DoType=$p(Para,"^",2)
	s LogonLocRowId=$p(Para,"^",3)
	s GroupRowId=$p(Para,"^",4)
	s HospitalId=$p(Para,"^",5)
	s APPTRowId=$p(Para,"^",6)
	s UserRowId=$p(Para,"^",7)
	s NewInvoiceId=$p(Para,"^",8)
	
	s $ZT="ERROR^DHCSSERR"
	TS
	i InvoiceId'=""{
		s AbortInvoiceID=$O(^DHCINVPRT(0,"InitInvDR",InvoiceId,0))
		s InvID=$O(^DHCINVPRT(0,"OldINV",InvoiceId,0))
		s BankPayFlag=1
		i (DoType'="AMP"){
			s OldBankInfo=##class(DHCExternalService.RegInterface.RegManager).GetPaiedInfoByInvID(InvoiceId)
			s PayTransactionId=$P(OldBankInfo,"^",6)
			s PayFee=$P(OldBankInfo,"^",4)
			s BankCode=$P(OldBankInfo,"^",2)
			s BankCardNo=$P(OldBankInfo,"^",3)
			//s HospitalId=$P(OldBankInfo,"^",7)
			s BankExpStr=LogonLocRowId_"^"_GroupRowId_"^"_HospitalId
			s BookingCode="",ApptDate="",PatientID=""
			i APPTRowId'="" d
			.//判断是否银行预约的记录
			.s ApptObj=##class(User.RBAppointment).%OpenId(APPTRowId)
			.s ApptDate=ApptObj.APPTTransDate
			.s BookingCode=ApptObj.APPTBookingSystemDR.APPTBSCode
			.s PatientID=ApptObj.APPTPAPMIDRGetObjectId()
			i (BookingCode="01")||(BookingCode="02")||(BookingCode="03")||(BookingCode="04")
			{ //工行预约过来的工行负责退费
				s BankTradeType="D"
				i ApptDate'=..%SysDate() s BankTradeType="T"
				s FeeRefundExp=UserRowId_"^"_BankCardNo_"^"_BankTradeType_"^"_HospitalId_"^"_BankCode_"^"_PayTransactionId_"^"_PayFee_"^"_PatientID_"^"_AbortInvoiceID_"^"_InvID
				s ret=..RegfeeRefundICBC(APPTRowId,FeeRefundExp)
				i +ret'=0{
					TROLLBACK
					q -2022_"银行退费通知错误"_ret
				}
			
			}else{
				s ret=##class(web.DHCBillBankLogicBJXH).BankRefund("OP",UserRowId,AbortInvoiceID,NewInvoiceId,BankCardNo,BankExpStr)
				i +ret=-1{  //不是银医卡支付
					s BankPayFlag=0
				}elseif $P(ret,"^",1)'=0{
					TRollback
					q -2011_"银医卡支付失败"
				}
			}
		
		}
	}
	//调用号源平台退号接口
	i (APPTRowId'="")&&(DoType'="AMP"){
		
		s ret=##class(DHCExternalService.RegInterface.RegManager).RefundReg(APPTRowId,UserRowId)
		i (+ret'=0)&&(BankPayFlag=0){
			TRollback
			q "-220"_ret
		}
		i (+ret'=0){ ;错误做出记录因为银医卡已经退费不回滚
			s ^DHCOPAMPInterface("Failure","RefundReg",APPTRowId)=$H
		}
	}
	TC
	
	Q ret
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装HIS挂号方法
ClassMethod OPRegistBroker(PatientID As %String, ASRowId As %Library.String = "", AdmReason As %String, QueueNo As %Library.String = "", FeeStr As %Library.String = "", PayModeCode As %Library.String = "", AccRowId As %Library.String = "", user As %Library.String = "", group As %Library.String = "", AdmType As %Library.String = "", DiagnosCatRowId As %Library.String = "", FreeRegFlag As %Library.String = "", FreeCheckFlag As %Library.String = "", ByRef RegfeeRowId As %String = "", ByRef InsuJoinStr As %String = "", ByRef DiscountFactor As %String = "", SaveType As %String = "Reg", EmployeeNo As %String = "", InsuranceStr As %String = "", SourceType As %String = "His") As %String
{
	;1.先调用HIS挂号
	;2.提交,如果失败撤销锁号
	n (ApptStr)
	s $ZT="ERROR^DHCSSERR"
	
	TS
	s ret=##class(web.DHCOPAdmReg).OPRegistBroker(PatientID,ASRowId,AdmReason,QueueNo,FeeStr,PayModeCode,AccRowId,user,group,AdmType,DiagnosCatRowId,FreeRegFlag,FreeCheckFlag,.RegfeeRowId,.InsuJoinStr,.DiscountFactor,SaveType,EmployeeNo,InsuranceStr,SourceType)
	s retCode=$p(ret,"$",1)
	if retCode'=0 {
		goto ROLLBACKOPRegist
	}
	TC
	
	Q ret
ROLLBACKOPRegist
	d ..RemoveLockOrder(ASRowId,PatientID,user,LockQueueNo)
	TRO
	Q "-215"
}

/// creator:郭荣勇
/// date:2012-07-18
/// desc:增加可复用性,封装HIS预约取号方法
ClassMethod OPAppArriveBroker(ApptID, UserID, GroupID, PayModeCode, AccRowId, SourceType) As %String
{
	;1.先调用HIS取号
	;2.提交,如果失败撤销锁号
	n (ApptStr)
	s $ZT="ERROR^DHCSSERR"
	s PatientID=$p($g(^RBAS(+ApptID,+$p(ApptID,"||",2),"APPT",+$p(ApptID,"||",3))),"^",2)
	s LockQueueNo=$p($g(^RBAS(+ApptID,+$p(ApptID,"||",2),"APPT",+$p(ApptID,"||",3),"DHC")),"^",11)
	TS
	s ret=##class(web.DHCOPAdmReg).OPAppArriveBroker("","", ApptID, UserID, GroupID, PayModeCode, AccRowId,SourceType)
	s retCode=$p(ret,"$",1)
	if retCode'=0 {
		goto ROLLBACKAppArrive
	}
	TC
	
	Q ret
ROLLBACKAppArrive
	d ..RemoveLockOrder($p(ApptID,"||",1,2),PatientID,UserID,LockQueueNo)
	TRO
	Q "-215"
}

/// 如果是退工行的费用,调用退费通知
ClassMethod RegfeeRefundICBC(ApptID As %String = "", ExpStr As %String = "")
{
	;n (ApptID,ExpStr)
	;T 退货  D  退费
	s BankCardNO=$P(ExpStr,"^",2)
	s BankTradeType=$P(ExpStr,"^",3)
	s HospDR=$P(ExpStr,"^",4)
	s BankCode=$P(ExpStr,"^",5)
	s PayTransactionId=$P(ExpStr,"^",6)
	s PayFee=$P(ExpStr,"^",7)
	s PatientID=$P(ExpStr,"^",8)
	s AbortInvID=$P(ExpStr,"^",9)
	s InvID=$P(ExpStr,"^",10)
	s TradeExpStr=""
	s ret=##class(web.DHCBillBankLogicBJXH).SetTradeID(BankCardNO, BankTradeType,HospDR,TradeExpStr)
	i (+ret'=0)&&(BankTradeType="D") q ret  ;交易为退费,不成功退出
	;ExpStr "HospitalId^TransactionId^PayBankCode^PayCardNo^PayFee^PaidTransactionId"
	s TransactionId=$P(ret,"^",3)
	s FeeRefundExpStr=HospDR_"^"_TransactionId_"^"_BankCode_"^"_BankCardNO_"^"_PayFee_"^"_PayTransactionId
	if (BankTradeType'="T")
	{
		s ret=##class(DHCExternalService.RegInterface.RegManager).RegfeeRefund(ApptID,FeeRefundExpStr)
		i +ret'=0 q ret
	}
	s BankOutputXML="<Response><AcctDate>"_+$H_"</AcctDate><AcctTime>"_..%SysTime()_"</AcctTime>"
	s RegNo=##class(DHCExternalService.RegInterface.RegManager).PatientIDToNo(PatientID)
	s BankOutputXML=BankOutputXML_"<TransactionId>"_TransactionId_"</TransactionId><PatientID>"_RegNo_"</PatientID>"
	s BankOutputXML=BankOutputXML_"<ResultCode>000</ResultCode><ErrorMsg></ErrorMsg></Response>"
	s UserID=$P(ExpStr,"^",1)
	s ret=##class(web.DHCBillBankLogicBJXH).UpdateTradeInfo("OP",UserID,BankTradeType,TransactionId,InvID,AbortInvID,BankOutputXML,"")
	q ret
	//##class(web.DHCBillBankLogicBJXH).SetTradeID(BankCardNO, BankTradeType,HospDR,ExpStr)
}

/// 获取医保上传数据
ClassMethod GetYBUploadData(RBASID As %String, CardNo As %String, PatientID As %String, InsuReadCardInfo As %String, ExpStr As %String) As %String
{
	set $zt="GetYBUploadDataET"
	set ResultCode="100",ResultContent="没有获取到医保上传数据"
	if (RBASID="") quit "-101^排班ID不能为空"
	if (PatientID="") quit "-102^病人ID不能为空"
	if (InsuReadCardInfo="") quit "-103^医保卡读取信息不能为空"
	set PAPMIDr=$O(^PAPERi("PAPMI_PatNo",PatientID,0))
	if '$Data(^RBAS(+RBASID,$Piece(RBASID,"||",2))) quit "-101^排班ID不存在"
	if (PAPMIDr="") quit "-105^病人ID不存在"
	set myUserID=##class(DHCExternalService.RegInterface.GetRelate).GetUser("")
	set myrtn=##class(web.DHCOPAdm).GetInsuBillPara("", "", PAPMIDr, myUserID, RBASID, "", "", "", "", "", InsuReadCardInfo)
	
GetYBUploadDataET
	quit "-1^程序出错："_$ZERROR
}

/// 取排班的一个预约方式的已预约数量
ClassMethod GetApptedCount(RBASID As %String, APPTMethodCode As %String) As %String
{
	Set num=0
	Set ResourceID=$piece(RBASID,"||",1)
	Set ApptScheID=$piece(RBASID,"||",2)
	Set myRBASID=0
	while(($order(^RBAS(ResourceID,ApptScheID,"APPT",myRBASID)))'="")
	{
		Set myRBASID=$order(^RBAS(ResourceID,ApptScheID,"APPT",myRBASID))
		Set myAPTMID=$order(^RBC("APTM",0,"Code",APPTMethodCode,0))
		Set APTMID=$piece(^RBAS(ResourceID,ApptScheID,"APPT",myRBASID),"^",12)
		if (myAPTMID'=APTMID) continue
		Set APPTStatus=$piece(^RBAS(ResourceID,ApptScheID,"APPT",myRBASID),"^",3)
		if (APPTStatus="A")||(APPTStatus="I")
		{
			Set num=num+1
		}
	}
	quit num
}

/// 判断当前时间是否可以挂号，0-不可挂；1-可挂
/// 配置位于医生站安全组功能维护-对外预约挂号设置配置中
/// 若未配置。默认时间为 23:30-00:30
/// 
ClassMethod CheckRegTime(GroupRowID, HospitalId)
{
	n (GroupRowID,CurrTime,HospitalId,%session)
	s ret=1
	Q:GroupRowID="" 0
	s CurrTime=..%SysTime()
	s OutRegStartTime=1800
	s OutRegStartTimeC=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowID,"OutRegStartTime",HospitalId)
	if OutRegStartTimeC'=""{
		s OutRegStartTimeC=..%ZTH(OutRegStartTimeC,1)
		s OutRegStartTime=OutRegStartTimeC
	}
	s OutRegEndTime=84600
	s OutRegEndTimeC=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupRowID,"OutRegEndTime",HospitalId)
	if OutRegEndTimeC'=""{
		s OutRegEndTimeC=..%ZTH(OutRegEndTimeC,1)
		s OutRegEndTime=OutRegEndTimeC
	}
	i (CurrTime>OutRegEndTime)!(CurrTime<OutRegStartTime) s ret=0
	q ret
}

/// w ##class(DHCExternalService.RegInterface.RegManager).IsExistDepSchedule(258,+$H,+$H)
/// 科室是否在某段日期内存出诊记录,如果是查询科室下的某个医生在某段日期内是否有出诊记录,这需要使用索引:
/// ^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId}),其他判断都类似
ClassMethod IsExistDepSchedule(DepId As %String, StartDate As %String, EndDate As %String, HospitalId As %String = "") As %String
{
	new (DepId,StartDate,EndDate,HospitalId,%session)
	Set ExistFlag=0
	if (StartDate="")!(EndDate=""){
		Set ExistFlag=1
		Quit ExistFlag
	}
	if HospitalId=""{
		s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(DepId)
	}
	if $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	if $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	if EndDate="" s EndDate=StartDate
	Set TimeRange=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime("",HospitalId)
	Set RowId=0 for {
		Set RowId=$o(^RB("RES",0,"CTLOC",DepId,RowId)) quit:RowId=""
		Set CTPCPRowId=$P(^RB("RES",RowId),"^",2)
		Set RESDateActiveTo=$P(^RB("RES",RowId),"^",23)
		continue:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)  //截止了的不允许生成
		;如果非医生则退出
		continue:CTPCPRowId=""
		;判断是否需要排班
		Set ScheSt=$p(^RB("RES",RowId),"^",6)
		continue:(ScheSt'="Y")
		for SerDate=StartDate:1:EndDate {
			Set ASRowIdStr=##Class(web.DHCRBApptSchedule).GetAvailRA(RowId,SerDate,"",TimeRange,"","","")
        	if ASRowIdStr'="" Set ExistFlag=1 Quit
		}
		Quit:ExistFlag=1
	}
	
	Quit ExistFlag
}

/// w ##class(DHCExternalService.RegInterface.RegManager).CheckCancelOPRegist(6389,"239",2)
ClassMethod CheckCancelOPRegist(AdmId As %String = "", GroupRowId As %String = "", HospRowId As %String = "")
{
	n (AdmId,GroupRowId,HospRowId,%session)
	s ReturnMsg=""
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCOPAdmReg"_"||"_"CheckCancelOPRegist")
 	if (flag=1){
		s checkret=##class(web.DHCOPAdmReg).CheckCancelOPRegist(AdmId,GroupRowId,HospRowId)
		if checkret'=""{
			s ReturnMsg=$p(checkret,"^",2)
		}
 	}
 	if ReturnMsg=""{
	 	s RegFeeRowId=$o(^User.DHCRegistrationFeeI("ADM",AdmId,""))
	 	s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
	 	s InvPrtFlag=""
	 	i InvoiceId'=""{
		 	s Paymode=""
			s InvPayModeID=$O(^DHCINVPRT(InvoiceId,"P",0))
			s:InvPayModeID'="" Paymode=$p(^DHCINVPRT(InvoiceId,"P",InvPayModeID),"^")
			if Paymode'=""{
				s PaymodeCode=$zcvt($p(^CT("CTPM",Paymode),"^",1),"U")
				if PaymodeCode="CASH"{
					s ReturnMsg="不可退号,现金支付的挂号记录请到窗口退号"
				}
			}
			if ReturnMsg=""{
				S ACCPINVDR=$P($G(^DHCINVPRT(InvoiceId)),"^",4)
				s InvPrtFlag=$P(^DHCINVPRT(InvoiceId),"^",3)
				if (ACCPINVDR'=""){
					S ACCPINVPrtFlag=$P($G(^DHCINVPRTAP(ACCPINVDR)),"^",2)
					if (ACCPINVPrtFlag="N"){
						s ReturnMsg="不可退号,该挂号记录请先到窗口撤销集中打印发票"
					}
				}else{
					if (InvPrtFlag="P"){
						s ReturnMsg="不可退号,该挂号记录发票已打印,请到窗口进行退号"
					}
				}
			}
		}
	}
 	Q ReturnMsg
}

ClassMethod CheckBeforeReg(ScheduleItemCode, PatientID, HospitalId As %String = "")
{
	n (ScheduleItemCode, PatientID, HospitalId,%session)
	if HospitalId=""{
		s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode("",ScheduleItemCode) 	
	}
	set checkmsg=""
 	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCOPAdmReg"_"||"_"CheckRegDeptAgeSex")
 	if (flag=1){
		s checkret=##class(web.DHCOPAdmReg).CheckRegDeptAgeSex(ScheduleItemCode,PatientID)
		s checkflag=$p(checkret,$c(2),1)
		s AllowSexDesc=$p(checkret,$c(2),2)
		s AgeRange=$p(checkret,$c(2),3)
		if checkflag'=0{
			if AllowSexDesc'=""{
				s checkmsg="此科室支持性别【"_AllowSexDesc_"】"
			}
			if (AgeRange'="") {
				s AgeRangeDesc="此科室支持年龄段【"_AgeRange_"】"
				if (checkmsg="") {
					s checkmsg=AgeRangeDesc
				}else{
					s checkmsg=checkmsg_","_AgeRangeDesc
				}
			}
			s checkmsg="不允许挂此科室,"_checkmsg
		}
 	}
 	if checkmsg=""{
	 	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCOPAdmReg"_"||"_"CheckBeforeReg")
	 	if (flag=1){
			s checkret=##class(web.DHCOPAdmReg).CheckBeforeReg(ScheduleItemCode,PatientID,"","","",HospitalId,"","SERV")
			if checkret'=0{
				s checkmsg=$p(checkret,"^",2)
			}
	 	}
	 }
 	Q checkmsg
}

/// w ##class(DHCExternalService.RegInterface.RegManager).SavePayInfo(7,"1",2,"2","<Response><PayModeCode>CASH<PayModeCode>","",.A)
ClassMethod SavePayInfo(AdmDr As %String, PayModeDr As %String, PayFee As %String, PatientCard As %String, PayDetailsObj As %ObjectHandle, ExpStr As %String, ByRef Errmsg As %String = "")
{
	n (AdmDr,PayModeDr, PayFee,PatientCard,PayDetailsObj,ExpStr,Errmsg,%session)
	s ret=0
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmDr,""))
	s JFPayMode=" "_PayModeDr
	if $d(^User.DHCCTPayModeExpI("PMEPayModeIDIndex",JFPayMode)){
		if (PayFee>0) {
			Set TradeType="OP"
			Set InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(PatientCard,AdmDr,"","C",PayFee,ExpStr)
			Set RetCode=$p(InsTraderInfo,"^",1)
			if (+RetCode'=0){
		    	s ret="-1"
		    	s Errmsg="生成交易流水号失败！"
		    }
		    Set OrderNo=$p(InsTraderInfo,"^",3)
		    Set TradeID=OrderNo
			Set IBPRowID=$p(InsTraderInfo,"^",2)
			set InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeRowId),11)
			Set RetCode=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(OrderNo,InvoiceId,.PayDetailsObj,ExpStr)
			If (RetCode'=0){
				s ret="-2"
				s Errmsg="保存交易信息失败！"
			}else{
				s ret=0_"^"_InsTraderInfo	
			}
		}
	}
	Q ret
}

ClassMethod SavePayInfoNew(PatientCard As %String, PayModeDr As %String, PayFee As %String, PayDetailsObj As %ObjectHandle, TExpStr As %String)
{
	n (PatientCard, PayModeDr,PayFee, PayDetailsObj, TExpStr)
	s TradeType="OP"
	s PayCallInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDr)
	s PayCallFlag=+$p(PayCallInfo,"^",1)
	if PayCallFlag=0{
		Q 0	
	}
	
	TS
	s InsTraderInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SetHISTradeNo(PatientCard,"","","C",PayFee,TExpStr)
	s RetCode=$p(InsTraderInfo,"^",1)
	if (+RetCode'=0){
		TRO
		Q "-1001514^生成交易流水号失败:"_InsTraderInfo
    }
    s ETPRowID=$p(InsTraderInfo,"^",2)
    s TransactionId=$p(InsTraderInfo,"^",3)
	s TradeType="OP"
	s SaveRet=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).SavePayInfo(TransactionId,"",.PayDetailsObj,TExpStr)
	if +SaveRet'=0{
		TRO
		Q "-1001514^保存交易信息失败！"
	}
	TC
	Q InsTraderInfo
}

}
