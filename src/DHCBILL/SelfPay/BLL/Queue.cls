/// 名称: DHCBILL.SelfPay.BLL.Queue.cls
/// 描述: 自助叫号业务处理类
/// 编写者: ZhYW
/// 编写日期: 2021-08-19
/// 产品组：计费医保组
Class DHCBILL.SelfPay.BLL.Queue Extends %RegisteredObject
{

/// Creator: Suhuide
/// CreatDate: 2021-08-16
/// Description: 自助机办理取号业务(入院登记、血透押金、门诊押金、住院押金、出院结算)
/// Debug: w ##class(DHCBILL.SelfPay.BLL.Queue).GetPatQueueInfo("<Request><TradeCode>7001</TradeCode><HospitalID>2</HospitalID><CardNo></CardNo><SecrityNo>0</SecrityNo><CardType></CardType><PatientID>0000000010</PatientID><MedicalNo>100001</MedicalNo><UserCode>SF01</UserCode><TerminalID>ZZJ001</TerminalID><AimFlag>IPDep</AimFlag><ExpStr></ExpStr></Request>").Read()
ClassMethod GetPatQueueInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="GetPatQueueInfoET"
	set InputObj=##class(DHCBILL.SelfPay.Entity.Queue.Req.Request).%New()
    do InputObj.XMLNodeDeserialize(.InputObj, "Request", Input)
    set CardNo=InputObj.CardNo				//卡号
    set CardType=InputObj.CardType			//卡类型
    set SecrityNo=InputObj.SecrityNo		//卡校验号
    set PatientNo=InputObj.PatientID		//登记号
    set MedicalNo=InputObj.MedicalNo		//病案号
    set AimFlag=InputObj.AimFlag			//业务类型(IPReg,OPDep,HDDep,IPDep,IPPay)
    set UserCode=InputObj.UserCode			//用户
    set TerminalID=InputObj.TerminalID		//终端号
    set HospitalID=InputObj.HospitalID
    
    if (HospitalID="") set HospitalID=$o(^CT("HOSP","0"))
    set UserID=""
    if (UserCode'="") {
	    set UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	    set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	}
	set OutputObj=##class(DHCBILL.SelfPay.Entity.Queue.Res.Response).%New()

	if ((CardNo="")&&(PatientNo="")&&(MedicalNo="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "卡号和登记号不能都为空")
		Quit OutputXML
	}
	
	if ((UserID="")||('$d(^SSU("SSUSR",UserID)))){
	 	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "用户代码传入有误")
		quit OutputXML
	}
	
	set GLoc=$p($g(^SSU("SSUSR",UserID)),"^",4)
	set Grup=$p($g(^SSU("SSUSR",UserID)),"^",5)
	
	if (AimFlag=""){
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "业务类型不能为空")
		quit OutputXML
	}
	
	set Papmi=""
	set PatInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatCommInfo(CardNo, CardType, SecrityNo, PatientNo)
	if (" 0 -201 "[(" "_$p(PatInfo,"^",1)_" ")) {
		set Papmi=$p(PatInfo,"^",8)
	}
	
	if ((Papmi="")&&(MedicalNo'="")) set Papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicalNo, "I", HospitalID)
	
	if (Papmi="") {
	 	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者信息传入有误")
		quit OutputXML
	}
	
	//电子住院证
	set IPBook=##class(DHCBILL.SelfPay.BLL.DHCIPBillPayLogic).GetIPBookIDByPatientID(Papmi)
	if (AimFlag="IPReg")&&(IPBook=""){
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "没有预约住院信息")
		quit OutputXML
	}
	
	set QueueType="IP"
	
	set Adm=""		//就诊记录
	if (AimFlag="IPReg") {
		//根据住院证取患者最后一次有效就诊记录
		set IPBookingJsonStr=##class(web.DHCIPBillReg).GetIPBookingInfo(IPBook)
		set IPBookingJson={}.%FromJSON(IPBookingJsonStr)
		 if (+IPBookingJson.success) {
			set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, IPBookingJson.msg)
			quit OutputXML
	  	}
	  	set Adm=##class(web.DHCBillCommon).GetPropValById("DHCDocIPBooking", IPBook, "EpisodeIDFrom")
	}elseif(" OPDep HDDep "[(" "_AimFlag_" ")) {
		set QueueType="OP"
		//根据患者ID取门诊最后一次就诊记录
		set Adm=$o(^PAPERdr(Papmi,"ADM","O",Adm),-1) 
		if (Adm=""){
			set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "门诊患者最后一次就诊记录不存在")
			quit OutputXML
		}
	}elseif(AimFlag="IPDep"){
		//根据患者ID取住院最后一次就诊记录
		//默认找在院就诊,无在院就诊找最近一次未结算就诊记录
		set InAdm="", NotPayAdm=""
		for  set Adm=$o(^PAPERdr(Papmi,"ADM","I",Adm),-1) quit:((Adm="")||(InAdm'=""))  do
		.set VisitStatus=$p(^PAADM(Adm),"^",20)
		.quit:(VisitStatus="C")
		.if (VisitStatus="A") do
		..set InAdm=Adm
		.set NoPayNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(Adm)
		.if ((NotPayAdm="")&&(NoPayNum>0)) do
		..set NotPayAdm=Adm   //只找最近一次未结算就诊
		
		if ((InAdm="")&&(NotPayAdm'="")) set InAdm=NotPayAdm
		If (InAdm=""){
			set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "无可交押金就诊记录")
			quit OutputXML
		}
		set Adm=InAdm
	}else {				//出院结算
		//根据患者ID取住院最后一次就诊记录
	    set NotPayAdm=""
	    for  set Adm=$o(^PAPERdr(Papmi,"ADM","I",Adm),-1) Quit:((Adm="")||(NotPayAdm'=""))  do
	    .set VisitStatus=$p(^PAADM(Adm),"^",20)
	    .quit:(VisitStatus'="D")
	    .set NoPayNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(Adm)
	    .quit:(+NoPayNum=0)
	    .set NotPayAdm=Adm
	    if (NotPayAdm=""){
			set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -1, "患者未出院或无可结算出院记录")
			quit OutputXML
		}
		set Adm=NotPayAdm
	}
	set IsCreateAdm="Y"					//默认存在最后一次有效就诊
	if (Adm="") set IsCreateAdm="N"		//不存在有效就诊 
	 
	//创建队列
	set dto=##class(%DynamicObject).%New()
	set dto.PAPMIDR=Papmi
	set dto.AdmDR=Adm
	set dto.CreatServer=TerminalID
	set dto.CreatUserDR=UserID
	set dto.BIZType=AimFlag
	set dto.QueueType=QueueType
	set dto.HospDR=HospitalID
	set rtnValue=##class(BILL.AUX.BL.CallQueue).CreatQueue(dto.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	if (+rtn){
		set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, rtn, $p(rtnValue,"^",2))
		quit OutputXML
	}
	set queueId=$p(rtnValue,"^",2) 		//队列ID
	&SQL(SELECT QueueNo, CreatDate, CreatTime
		INTO :queueNo, :creatDate, :creatTime
		FROM BILL_AUX.CallQueue
		WHERE %ID = :queueId)
	set creatDate=##class(websys.Conversions).DateLogicalToHtml(creatDate)
	set creatTime=##class(websys.Conversions).TimeLogicalToHtml(creatTime)
		
	//组织输出患者基本信息和就诊信息
	//1.获取患者基本信息
	set BaseInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatBaseInfo(Papmi, HospitalID)
	//2.获取患者就诊信息
	set AdmInfo=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).GetPatAdmInfo(Adm)
	
	set OutputObj.PatientID=$p(BaseInfo,"^",2)				//登记号
	set OutputObj.PatName=$p(BaseInfo,"^",3)			    //患者姓名
	set OutputObj.Sex=$p(BaseInfo,"^",4)					//患者性别
	set OutputObj.DOB=$p(BaseInfo,"^",5)					//患者出生日期
	set OutputObj.Medical=$p(BaseInfo,"^",7)				//病案号
	set OutputObj.AimFlag=AimFlag							//业务类型
	set OutputObj.IsActiveAdm=IsCreateAdm					//就诊标识
	set OutputObj.QueueNo=queueNo						    //队列号
	set OutputObj.CreatDate=creatDate
	set OutputObj.CreatTime=creatTime
	
	set AdmInfoObj=##class(DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo).%New()
	set AdmInfoObj.AdmID=Adm									//就诊号
	set AdmInfoObj.AdmDate=$p(AdmInfo,"^",1)					//就诊日期
	set AdmInfoObj.AdmDept=$p(AdmInfo,"^",2)					//就诊科室
	set AdmInfoObj.AdmReason=$p(AdmInfo,"^",3)					//就诊费别
	do OutputObj.AdmInfoList.Insert(AdmInfoObj)

	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, 0, "成功")
	quit OutputXML

GetPatQueueInfoET
	set $zt=""
    set OutputObj=##class(DHCBILL.SelfPay.Entity.Queue.Res.Response).%New()
	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj, -99, "程序处理错误:"_$ze)
	quit OutputXML
}

}
