Class dhcinterface.TeleReg Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// ljq-对账
ClassMethod CheckAccount(HospitalId As %String = "", BankCode As %String = "", AccStartDate As %String = "", AccStartHour As %String = "", AccStartMinute As %String = "", AccEndDate As %String = "", AccEndHour As %String = "", AccEndMinute As %String = "", AccType As %String = "") As %String
{
	
	s sendobj=##class(dhcinterface.SendMsg).%New()
	s sendobj.HospitalId=HospitalId
	s sendobj.BankCode=BankCode
	s sendobj.AccStartDate=AccStartDate
	s sendobj.AccStartHour=AccStartHour
	s sendobj.AccStartMinute=AccStartMinute
	s sendobj.AccEndDate=AccEndDate
	s sendobj.AccEndHour=AccEndHour
	s sendobj.AccEndMinute=AccEndMinute
	s sendobj.AccType=AccType
	s status=sendobj.XMLExportToString(.CheckAccountXml,"Request")
	Q CheckAccountXml
}

/// ljq-医院对账
ClassMethod CheckAccountMsg(inStream As %GlobalCharacterStream) As %String
{
	S inStreamXML=""
	s Xml=""
	while (inStream.AtEnd=0) {
		s inStreamXML=inStreamStr_inStream.Read(2000)
	}
	s ^CACHETMPTML("BANK","CheckAccountMsg","SendMsg")=inStreamXML
	
	d ##class(web.HXExternal.ProtalAccount).Account(inStreamXML)
	
	s msgobj=##class(dhcinterface.ReturnMsg).%New()
	s msgobj.Result=0
	s status=msgobj.XMLExportToString(.Xml,"Response")
	s ^CACHETMPTML("BANK","CheckAccountMsg","ReturnMsg")=Xml
	Q:$system.Status.IsError(status) 0
	
	Q Xml
}

ClassMethod CheckApptRange(rsappt As %String, Usdr As %String) As %String
{
	s MethorDR=$O(^RBC("APTM",0,"Code","TEL",0))
	s:Usdr="hxadmin01" MethorDR=$O(^RBC("APTM",0,"Code","WEB",0))
	s:Usdr="hxperson" MethorDR=$O(^RBC("APTM",0,"Code","PERW",0))
	s MethodrCode=$p(^RBC("APTM",MethorDR),"^",1)
	
	set obj=##class(User.RBApptSchedule).%OpenId(rsappt)
	set ASDate=obj.ASDate
	do obj.%Close()
	s range =$p(^DHCOPRegConfig("AppConfig",MethodrCode),"^",2)
	i +$h+range<ASDate 
	{
		q 1
	}
	else 
	{
		q 0
	}
}

/// New对帐明细
ClassMethod CheckInAccountDetailInfo(XmlPara) As %String
{
	s Xml=""
	s ^CACHETMPTML("114","CheckInAccountDetailInfo","SendMsg")=XmlPara
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	s Flag=1
	
	While reader.Next(.telepara,.sc)  {
	   s TransactionId=telepara.TransactionId
	   s CheckId=telepara.CheckId
	   s checkinfoobject=##class(dhcinterface.CheckInfo).GetByCheckId(CheckId)
	   If $IsObject(checkinfoobject){
		   s ErrorMsg=""
		   s ResultCode=0
		   s Flag=0
	   }else{
		   s ResultCode=1
		   s ErrorMsg="无效交易流水号"
	   }
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=Flag
		s msgobj.ErrorMsg=ErrorMsg
		i Flag=0 {
			s msgobj.CheckDetails=##class(dhcinterface.CheckInfoDetail).GetCheckDetailsByCheckId(CheckId)
		}
		s status=msgobj.XMLExportToString(.Xml,"Response")
		s ^CACHETMPTML("114","CheckInAccountDetailInfo","ReturnMsg")=Xml
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
	} 
	Q Xml
}

/// New 检验114操作员编码?坐席客户机地址
ClassMethod CheckteleUserID(UserID As %String, ClientAddress As %String, AppMethod As %String = "") As %Integer
{
	;q 1
	;自动冲正不需要验证坐席机ip和用户
	q:AppMethod="autoComplemented" 1
	;内网测试
	q:ClientAddress="133.40.124.69" 1
	S teleUserCount=0
	;&sql(Select Count(*) into :teleUserCount From sqluser.dhc_teleuserinfo Where UserID=:UserID And ClientAddress=:ClientAddress And AppMethod=:AppMethod)   ;gry
	if (teleUserCount=0) 
	{
		s ^CACHETMPTML("114checkError",$p($h,",",1),$p($h,",",2))=UserID_":"_ClientAddress_":"_AppMethod
		Q 1 ;临时用
		;q -1
	}
	Q 1
}

/// New对帐确认
ClassMethod ConfirmCheckInAccountInfo(XmlPara) As %String
{
	s Xml=""
	s ^CACHETMPTML("114","ConfirmCheckInAccountInfo","SendMsg")=XmlPara
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	While reader.Next(.telepara,.sc)  {
		 s TransactionId=telepara.TransactionId
		 s CheckId=telepara.CheckId
		 //新增接收请求数据
		 s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"cancelRegistration","",XmlPara,0,"Response","")
		 if (TransactionId'="")
		 {
			 s Flag=0
			 s rtn=##class(web.DHCRBCheckInAccount).ConfirmCheckInAccountInfo(ApptId)
		 	 i (rtn=0) { 
		 		s Flag=0
		 		s ErrorMsg=""
		 	 }
		 	 else  {
				s Flag=1
			 	s ErrorMsg="对帐确认失败"
			 }
		 }
		 else
		 {
			 s Flag=1
			 s ErrorMsg="写交易日志失败,对帐确认失败"
		 }
		
		 s msgobj=##class(dhcinterface.ReturnMsg).%New()
		 s msgobj.ResultCode=Flag
		 s msgobj.ErrorMsg=ErrorMsg
		 s status=msgobj.XMLExportToString(.Xml,"Response")
		 s ^CACHETMPTML("114","ConfirmCheckInAccountInfo","ReturnMsg")=Xml
		 If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		 }
	}
	
	Q Xml
}

/// New获取对帐信息
ClassMethod CreateCheckInfo(infoDate As %String) As %Status
{
	;对帐流水号^交易日期^挂号费总额^诊查费总额^预约费总额
	;^预约次数^取号次数^取消预约次数^违约次数
	;^预约交易号串^取号交易号串^取消预约号串^违约交易号串
	
	;并将明细存入CheckInfoDetail
	
	Quit $$$OK
}

/// ljq-获得挂号信息 Flag^RegFee^AdmitRange^AdmitAddress^RegFeeDR^ErrorMsg
ClassMethod GetRegInfo(ApptRowId As %String) As %String
{
	; d ##class(dhcinterface.TeleReg).GetRegInfo("")
	s Flag=1
	s RegFee=""
	s AdmitRange=""
	s AdmitAddress=""
	s ErrorMsg=""
	
	s RESDR=$p($g(ApptRowId),"||",1)
	s ASChildDR=$p($g(ApptRowId),"||",2)
	s APPTChildDR=$p($g(ApptRowId),"||",3)
	
	s PAAdmDR=$p($g(^RBAS(RESDR,ASChildDR,"APPT",APPTChildDR)),"^",4)
	s RegFeeDR=$o(^User.DHCRegistrationFeeI("ADM"," "_$g(PAAdmDR),""))
	s RegInfo=##class(web.DHCOPAdmReg).GetPrintData(RegFeeDR,"")
	s PAPMIDR=$P($G(^PAADM(PAAdmDR)),"^",1)
	if (RegInfo'="") {
		s RegFee=$p(RegInfo,"^",17)
		s AdmitRange=$p(RegInfo,"^",7)
		s AdmitAddress=$p(RegInfo,"^",10)
		if (RegFee'="")&&(AdmitRange'="")&&(AdmitAddress'="") {
			s Flag=0
			s ErrorMsg=""
		} else {
			s Flag=1
			s RegFee=""
			s AdmitRange=""
			s AdmitAddress=""
			s ErrorMsg="部分挂号信息为空"
		}
	} else {
		s Flag=1
		s RegFee=""
		s AdmitRange=""
		s AdmitAddress=""
		s ErrorMsg="没有挂号信息"
	}
	
	q Flag_"^"_RegFee_"^"_AdmitRange_"^"_AdmitAddress_"^"_PAAdmDR_"^"_RegFeeDR_"^"_PAPMIDR_"^"_ErrorMsg
}

/// 获取单条排班信息
ClassMethod GetSingleWorkInfo(RBASId As %String, apptMethod As %String = "") As %GlobalCharacterStream
{
	;w ##class(dhcinterface.TeleReg).GetSingleWorkInfo(RBASId)
	s count=0
	s Xml=""
	s object=##class(dhcinterface.SendMsg).%New()
	s object.HospitalId="002"
	//s RBASObject=##class(dhcinterface.RBASRec).GetByID(RBASId,apptMethod)
	s RBASObject=##class(dhcinterface.RBASRec).GetByID(RBASId)
	Q:RBASObject.RBASSessionLoad=0 ""
	s AvailableRegNum=##Class(dhcinterface.TeleReg).GetAvailableRegNum(RBASId)
	;取剩余的可挂号数
	s RBASObject.RBASSessionLoad=AvailableRegNum
	d object.RBAS.Insert(RBASObject)
	s status=object.XMLExportToStream(.Xml,"Request")
	;b ;新增发送请求数据
	If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
		Quit ""
	}
	
	;更新发送请求数据
	s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","GetSingleWorkInfo",Xml,"",0,"Request","")
	;s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","GetWorkInfo",saveXml,"",0,"Request","")
	
	If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	}
	Quit Xml
}

/// 获取排班信息
ClassMethod GetWorkInfo(StartDate As %String, EndDate As %String, AppMethod As %String = "") As %GlobalCharacterStream
{
	s count=0
	s Xml=""
	s object=##class(dhcinterface.SendMsg).%New()
	s object.HospitalId="002"
	;s testcount=0
	s ResRowId=0 f  S ResRowId=$o(^RB("RES",ResRowId)) Q:ResRowId=""  d
	.Q:'($D(^RB("RES",ResRowId)))
	.;s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.f ASDate=StartDate:1:EndDate  d
	..s ASSessStartTime=0  f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime)) Q:ASSessStartTime=""  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) Q:ASChildSub=""  d
	....s RBASId=ResRowId_"||"_ASChildSub
	....s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	....s statuscode=""
	....i status'="" s statuscode=$P(^DHCRBCASStatus(status),"^",1)
	....Q:(statuscode="S")!(statuscode="TR")
	....;s RBASObject=##class(dhcinterface.RBASRec).GetByID(RBASId,AppMethod)
	....s RBASObject=##class(dhcinterface.RBASRec).GetByID(RBASId)
	....Q:RBASObject.RBASSessionLoad=0
	....s count=count+1
	....d object.RBAS.Insert(RBASObject)
	....;s ^zTom("count1")=$g(^zTom("count1"))_RBASId
	s ^zTom("count")=count
	;w count,!
	;....s testcount=testcount+1
	;保留交易记录ID?传输排班记录起止日期

	s saveXml=""
	s saveobject=##class(dhcinterface.SendMsg).%New()
	s saveobject.RBAStartDate=StartDate
	s saveobject.RBAEndDate=EndDate
	s savestatus=saveobject.XMLExportToString(.saveXml,"Request")
	If ($system.Status.IsError(savestatus)) {
		Do $system.OBJ.DisplayError(savestatus)
	}
	s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","GetWorkInfo",saveXml,"",0,"Request","")
	If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	}
	s object.TransactionId=TransactionId
	s status=object.XMLExportToString(.Xml1,"Request")
	s status=object.XMLExportToStream(.Xml,"Request")
	
	;b ;新增发送请求数据
	If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
		Quit Xml
	}
	
	;更新发送请求数据
	;s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"GetWorkInfo",saveXml,Xml,0,"","")
	If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	}
	;w Xml1
	Quit Xml
}

/// 获取排班信息1
ClassMethod GetWorkInfo1(StartDate As %String, EndDate As %String) As %GlobalCharacterStream
{
	s count=0
	s Xml=""
	s object=##class(dhcinterface.SendMsg).%New()
	s object.HospitalId="002"
	;s testcount=0
	s ResRowId=0 f  S ResRowId=$o(^RB("RES",ResRowId)) Q:ResRowId=""  d
	.Q:'($D(^RB("RES",ResRowId)))
	.;s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.f ASDate=StartDate:1:EndDate  d
	..s ASSessStartTime=0  f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime)) Q:ASSessStartTime=""  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) Q:ASChildSub=""  d
	....s RBASId=ResRowId_"||"_ASChildSub
	....s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	....s statuscode=""
	....i status'="" s statuscode=$P(^DHCRBCASStatus(status),"^",1)
	....Q:(statuscode="S")!(statuscode="TR")
	....s RBASObject=##class(dhcinterface.RBASRec).GetByID(RBASId)
	....Q:RBASObject.RBASSessionLoad=0
	....s count=count+1
	....s a="<RBASId>"_RBASObject.RBASId_"</RBASId>"
	....s a=a_"<RBASDate>"_RBASObject.RBASDate_"</RBASDate>"
	....s a=a_"<RBASSessionCode>"_RBASObject.RBASSessionCode_"</RBASSessionCode>"
	....s a=a_"<DoctorId>"_RBASObject.DoctorId_"</DoctorId>"
	....s a=a_"<DoctorName>"_RBASObject.DoctorName_"</DoctorName>"
	....s a=a_"<DoctorTitle>"_RBASObject.DoctorTitle_"</DoctorTitle>"
	....s a=a_"<DeptId>"_RBASObject.DeptId_"</DeptId>"
	....s a=a_"<Dept>"_RBASObject.Dept_"</Dept>"
	....s a=a_"<SubjectId>"_RBASObject.SubjectId_"</SubjectId>"
	....s a=a_"<Subject>"_RBASObject.Subject_"</Subject>"
	....s a=a_"<DoctorIntro>"_RBASObject.DoctorIntro_"</DoctorIntro>"
	....s a=a_"<RBASPrice>"_RBASObject.RBASPrice_"</RBASPrice>"
	....s a=a_"<RBASSessionTypeId>"_RBASObject.RBASSessionTypeId_"</RBASSessionTypeId>"
	....s a=a_"<RBASSessionType>"_RBASObject.RBASSessionType_"</RBASSessionType>"
	....s a=a_"<RBASSessionLoad>"_RBASObject.RBASSessionLoad_"</RBASSessionLoad>"
	....w a,!
	....s ^ljqtemp("GETWorkInfoXML",count)=a
}

/// ljq-预约挂号支付确认
/// debug:w ##class(dhcinterface.TeleReg).PaymentRegistration("")
ClassMethod PaymentRegistration(XMLPara As %String) As %String
{
	//<Request><TransactionId></TransactionId><TranNo></TranNo><BankCode></BankCode><PaymentMode></PaymentMode><PaymentFee></PaymentFee><UserID></UserID></Request>
	/*
	1.TransactionId	平台流水号
	2.TranNo		交易流水表No
	3.BankCode		支付银行
	4.PaymentMode	支付方式
	5.PaymentFee	支付金额
	6.UserID		支付用户
	*/
	s XML=""
	s ^CACHETMPTML("Portal","PaymentRegistration","SendMsg")=XMLPara

	s reader=##Class(%XML.Reader).%New()
	s sc=reader.OpenString(XMLPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	s ResultCode=1
	s ErrorMsg=""
	s ReTradeNo=""
	d reader.Correlate("Request","dhcinterface.SendMsg")
	
	while reader.Next(.portalpara,.sc) {
		s TransactionId=portalpara.TransactionId
		b //新增接收请求数据
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"PaymentRegistration",XMLPara,"",0,"Response","")
		if (TransactionId'="") {
			s UserID=portalpara.UserID				//支付用户
			s BankCode=portalpara.BankCode			//支付银行
			s PaymentMode=portalpara.PaymentMode	//支付方式
			s PaymentFee=portalpara.PaymentFee		//支付金额
			s TradeNo=portalpara.ApptId			//交易流水表RowID
			
			s TradeBizDR=$o(^HXTB(0,"TradeNo",TradeNo,""))			//取得交易流水表RowID
			if (TradeBizDR="") {									//检查交易流水RowID是否存在
				s ResultCode=1
				s ErrorMsg="没有预约记录"
			} elseif (0) { //(+PaymentFee'=+$p($g(^HXTB(TradeBizDR)),"^",9)) {				//验证交易金额是否一致
				s ResultCode=1
				s ErrorMsg="交易金额不正确"
			} elseif ($p($g(^HXTB(TradeBizDR)),"^",11)'=1) {
				s ResultCode=1
				s ErrorMsg="预约状态错误" 
			} else {
				/*
				Update HXTradeBiz 交易状态
				Insert HXTradePay
				取号
				*/

				s TradeTime=$p($g(^HXTB(TradeBizDR)),"^",8)
				s TradeDate=$p($g(^HXTB(TradeBizDR)),"^",7)
				s PayChannel=$p($g(^HXTB(TradeBizDR)),"^",2)
				s PayCardNo=$p($g(^HXTB(TradeBizDR)),"^",3)
				s ReTradeNo=""
				
				TSTART
				//写交易流水表状态
				s str=TransactionId_"^"_$p($g(^HXTB(TradeBizDR)),"^",5)_"^"_4_"^"_UserID_"^"_$p($g(^HXTB(TradeBizDR)),"^",12)_"^"_2_"^"_PaymentFee_"^"_"O"_"^"_PayCardNo
				s rtn=..WriteTradeBiz("Insert","",str)
				s BFlag=$p(rtn,"^",1)
				s TradeDR=$p(rtn,"^",2)
				if (BFlag=0){
					//写支付表记录
					s BizPayStr=TradeDR_"^"_PaymentFee_"^"_PaymentMode_"^"_
					UserID_"^"_TradeNo_"^"_TradeDate_"^"_TradeTime_"^"_PayChannel_"^"_
					BankCode_"^"_PayCardNo
					s rtn=..WriteTradeBizPay("Insert",BizPayStr)
					s PFlag=$p(rtn,"^",1)
					s PFlagCode=$p(rtn,"^",2)
					if PFlag=0 {
						//预约取号
						s ret=##class(web.DHCOPAdmReg).OPAppArrive($p($g(^HXTB(TradeDR)),"^",12),"575","53","","")
						b ;end ret
						if ret'=0 {
							TRollBack
							s ResultCode=1,ErrorMsg="取号失败"
						} else {
							s ResultCode=0
							s ErrorMsg=""
							s ReTradeNo=$p($g(^HXTB(TradeDR)),"^",10)
							B ;RETRADENO
							TCOMMIT
						}
						
					} else {
						s ResultCode=1
						s ErrorMsg="写支付表信息失败"
						TRollBack
					}
				}else{
					s ResultCode=1
					s ErrorMsg="写交易流水表信息失败"
					TRollBack
				}
			}
			
		}else {
			s ResultCode=1
			s ErrorMsg="写交易日志失败,支付确认失败" 
		}
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.ApptId=ReTradeNo
		s status=msgobj.XMLExportToString(.XML,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s XML=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"PaymentRegistration","",XML,0,"","")
	}
	s ^CACHETMPTML("Portal","PaymentRegistration","ReturnMsg")=XML
	Quit XML
}

/// New接受差异明细信息
ClassMethod ReceiveErrorCheckDetailInfo(XmlPara) As %String
{
	set ResultCode=1
	s Xml=""
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	
	While reader.Next(.telepara,.sc)  {
		set ErrorCheckDetails=telepara.ErrorCheckDetails
		set CheckId=telepara.CheckId
		set len=$ListLength(ErrorCheckDetails.CheckInfoDetails)
		set Flag=1
		
		ts
		for i=1:1:len
		{
			If $IsObject(ErrorCheckDetails){
				;???
				s checkdetailinfo=$ListGet(ErrorCheckDetails.CheckInfoDetails,i)
				IF $IsObject(checkdetailinfo){
					s saveobj=##class(User.DHCRBteleErrorCheckInfoDetail).%New()
					s saveobj.ApptId=checkdetailinfo.ApptId
					s saveobj.BookedFee=checkdetailinfo.BookedFee
					s saveobj.CheckId=CheckId
					s saveobj.ExamineFee=checkdetailinfo.ExamineFee
					s saveobj.RegistrationFee=checkdetailinfo.RegistrationFee
					s saveobj.Remark=checkdetailinfo.Remark
					s saveobj.TransactionDate=checkdetailinfo.TransactionDate
					s saveobj.SRCTransactionId=checkdetailinfo.SRCTransactionId
					s saveobj.TransactionType=checkdetailinfo.TransactionType
					s sc=saveobj.%Save()
					
					If $$$ISERR(sc){
						do saveobj.%Close()
						Do $System.Status.DisplayError()
						s ResultCode=1
						s ErrorMsg="接收差异明细失败,保存明细数据失败"
						q
					}else{
						s ResultCode=0
						s ErrorMsg=""
					}
				}else{
					s ResultCode=1
					s ErrorMsg="接收差异明细失败,明细数据错误"
					q
				}
			}else{
				s ResultCode=1
				s ErrorMsg="接收差异明细失败,节点数据错误"
				Quit
			}
		}
		if ResultCode=1 { tro}
		tc
	    s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
}
 ;s myxml="<Request><TransactionIds>20070914-140028-142722</TransactionIds></Request>"
	//set Xml="<Response><ResultCode>0</ResultCode><SeqCode>2</SeqCode><ApptId>1540||7||2</ApptId></Response>"

	Quit Xml
}

/// ljq-医院退号
ClassMethod RefundRegistration(XMLPara As %String) As %String
{
	/*
	1.TransactionId	平台交易流水号
	2.ApptId		病人预约挂号唯一标识
	3.RefundType	退号方式
	4.UserID		退号用户
	*/
	s XML=""
	s ^CACHETMPTML("Portal","RefundRegistration","SendMsg")=XMLPara
	
	s reader=##Class(%XML.Reader).%New()
	s sc=reader.OpenString(XMLPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("Request","dhcinterface.SendMsg")
	s ResultCode=1
	s ErrorMsg=""
	s ReTradeNo=""
	s RefundFee=""
	s BankCode=""

	while (reader.Next(.portalpara,.sc)) {
		s TransactionId=portalpara.TransactionId	//交易流水号
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"RefundRegistration",XMLPara,"",0,"Response","")
		
		if (TransactionId'="") {
			s TradeNo=portalpara.ApptId				//病人预约挂号唯一标识
			s PaymentMode=portalpara.PaymentMode		//退号方式
			s UserID=portalpara.UserID					//交易渠道
			b //需新增
			s ReTradeNo=""
			s TradeBizDR=$o(^HXTB(0,"TradeNo",TradeNo,""))			//取得交易流水表RowID
			if (TradeBizDR'="") {
				s TradeType=##class(web.DHCRBResourceRule).GetTradeStatus(TradeBizDR)
				s TradeFlag=$p($g(TradeType),"^",1)
				s TradeError=$p($g(TradeType),"^",2)
				if (TradeFlag) {
					s ApptId=$p($g(^HXTB(TradeBizDR)),"^",12)
					s RegInfo=..GetRegInfo(ApptId)
					s RegInfoFlag=$p($g(RegInfo),"^",1)
					s RegFeeDR=$p($g(RegInfo),"^",6)
					s FINVPrtDR=$lg(^User.DHCRegistrationFeeD(RegFeeDR),11)	//老发票DR
					if (RegInfoFlag=0)
					{
						TSTART
						s ret=##class(web.DHCOPAdmReg).CancelOPRegist($p($g(RegInfo),"^",6),"575","53","")
						s retFlag=$p($g(ret),"$",1)
						b ; ret
						if (retFlag=0) {
							s RegFeeDR=$p($g(RegInfo),"^",6)
							S SINVPrtDR=$o(^DHCINVPRT(0,"InitInvDR",FINVPrtDR,""))	//负发票DR
							s TINVPrtDR=$lg(^User.DHCRegistrationFeeD(RegFeeDR),11)	//新发票DR
							s ReRegFee=$p($G(^DHCINVPRT(TINVPrtDR)),"^",1)+$p($G(^DHCINVPRT(SINVPrtDR)),"^",1)
							B ;=============================
							s TradeBizDR=$o(^HXTB(0,"TradeNo",TradeNo,""))
							s str=TransactionId_"^"_$p($g(^HXTB(TradeBizDR)),"^",5)_"^"_3_"^"_UserID_"^"_$p($g(^HXTB(TradeBizDR)),"^",12)_"^"_1_"^"_ReRegFee_"^"_"O"_"^"_$p($g(^HXTB(TradeBizDR)),"^",3)
							s TradeBiz=..WriteTradeBiz("Insert","",str)
							s TBFlag=$p($g(TradeBiz),"^",1)
							if (TBFlag=0) {
								if ReRegFee'="" {
									TCommit
									s ResultCode=0
									s ErrorMsg=""
									s BankCode=##class(web.DHCRBResourceRule).GetRBankCode(TradeBizDR)
									i $f(ReRegFee,"-") { s ReRegFee=$p(ReRegFee,"-",2)}
									s RefundFee=ReRegFee
									s ReTradeNo=$p($g(^HXTB($p($g(TradeBiz),"^",2))),"^",10)
								} else {
									TRollBack
									s ResultCode=1
									s ErrorMsg="不能获取退费金额"
									s BankCode=""
									s RefundFee=""
								}
							
							} else {
								TRollBack
								s ResultCode=1
								s ErrorMsg="写交易记录失败"
								s BankCode=""
								s RefundFee=""
							}
						} else {
							TRollBack
							s ResultCode=1
							s ErrorMsg="退号失败"
							s BankCode=""
							s RefundFee=""
						}
					} else {
						s ResultCode=1
						s ErrorMsg=$p($g(RegInfo),"^",7)
						s BankCode=""
						s RefundFee=""
					}
				} else {
					s ResultCode=1
					if (TradeError="RefundAppoint") {s ErrorMsg="已退费"}
					elseif (TradeError="Appoint") {s ErrorMsg="未支付"}
					else {s ErrorMsg="交易状态错误"}
					s BankCode=""
					s RefundFee=""
				}
			}else {
				s ResultCode=1
				s ErrorMsg="无预约记录"
				s BankCode=""
				s RefundFee=""
			}
			
		
		}else {
			s ResultCode=1
			s ErrorMsg="写交易日志失败,支付确认失败"
			s BankCode=""
			s RefundFee=""
		}
		
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.BankCode=BankCode
		s msgobj.RefundFee="0.01" //RefundFee
		s msgobj.ApptId=ReTradeNo
		s status=msgobj.XMLExportToString(.XML,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s XML=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"RefundRegistration","",XML,0,"","")
	}
	s ^CACHETMPTML("Portal","RefundRegistration","ReturnMsg")=XML
	Quit XML
}

/// ljq-查询医院退号
ClassMethod SearchRefundRegistration(XMLPara As %String) As %String
{
	/*
	1.TransactionId 流水号
	2.UserID 用户ID
	3.ApptID 病人预约挂号唯一标识
	4.RefundType 退费方式
	*/
	s XML=""
	s ^CACHETMPTML("Portal","SearchRefundRegistration","SendMsg")=XMLPara
	
	s reader=##Class(%XML.Reader).%New()
	s sc=reader.OpenString(XMLPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d reader.Correlate("Request","dhcinterface.SendMsg")
	s ResultCode=1
	s ErrorMsg=""
	B ;STOP
	while (reader.Next(.portalpara,.sc)) {
		s TransactionId=portalpara.TransactionId	//交易流水号
		;s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"RefundRegistration",XMLPara,"",0,"Response","")
		
		if (TransactionId'="") {
			s TradeNo=portalpara.ApptId				//病人预约挂号唯一标识
			s RefundType=portalpara.Method			//退号方式
			s UserID=portalpara.UserID					//退号用户

			s TradeDR=$o(^HXTB(0,"TradeNo",TradeNo,""))
			if TradeDR'="" {
				s IsReturnReg=##class(web.DHCRBResourceRule).IsReturnReg(TradeDR)
				s IsReturnRegFlag=$p($g(IsReturnReg),"^",1)
				s TradeDR=$p($g(IsReturnReg),"^",2)
				b ;ssss
				if IsReturnReg {
					s ResultCode=0
					s ErrorMsg=""
					s BankCode=$p($g(^HXTB(TradeDR)),"^",2)
					S RefundFee=$p($g(^HXTB(TradeDR)),"^",9)
				}else{
					s ResultCode=1
					s ErrorMsg="交易类型错误"
					s BankCode=""
					S RefundFee=""
				}
			} else {
				s ResultCode=1
				s ErrorMsg="无退号记录"
				s BankCode=""
				S RefundFee=""
			}
		}else {
			s ResultCode=1
			s ErrorMsg="写交易日志失败,支付确认失败"
			s BankCode=""
			S RefundFee=""
		}
		
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.BankCode=BankCode
		s msgobj.RefundFee=RefundFee
		s status=msgobj.XMLExportToString(.XML,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s XML=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"RefundRegistration","",XML,0,"","")
	}
	s ^CACHETMPTML("Portal","RefundRegistration","ReturnMsg")=XML
	Quit XML
}

/// New传对帐信息
ClassMethod SendCheckInAccountInfo(Date As %Date) As %String
{
	 s Xml=""
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.CheckInfo=##class(dhcinterface.CheckInfo).GetByDate(Date)
	 If '$IsObject(paraobj.CheckInfo) {
		Do $system.OBJ.DisplayError("")
		Quit ""
	 }
	 
	 //新增发送请求数据
	 s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","SendCheckInAccountInfo","","",0,"Request","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }

	 s paraobj.TransactionId=TransactionId
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }

	  //更新发送请求数据
	 s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"",Xml,"",0,"","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 Q Xml
}

/// New违约通知
ClassMethod SendOverdueInfo(ApptIdStr As %String) As %String
{
	 ;w ##class(portalinterface.SYTest).SendOverdueInfoTest("1201||2||2")
	
	s ^CACHETMPTML("Portal","SendOverdueInfo","SendMsg")=ApptIdStr
	 s Xml=""
	 
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.ApptId=ApptIdStr
	  //新增发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","SendOverdueInfo","","",0,"Request","")
	 s TransactionId=$tr(ApptIdStr,"||","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 s paraobj.TransactionId=TransactionId
	 //add by ouziran
	 s ApptDR=ApptIdStr
	 if $length(ApptIdStr,"^")>1 {
	    s ApptDR=$p(ApptIdStr,"^",1)
	 }
	 s ResDR=$p(ApptDR,"||",1)
	 s ASDR=$p(ApptDR,"||",2)
	 s SubDR=$p(ApptDR,"||",3)
	 s Status=$p(^RBAS(ResDR,ASDR,"APPT",SubDR),"^",3)
	 if Status="J" {
		 s paraobj.ApptType="1" ;违约
	 }
	 else
	 {
		 s paraobj.ApptType="2" ;医院取消预约
	 }
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }
	  //更新发送请求数据
	;s ^ozrtest(1)=Xml
	s TransactionId=paraobj.TransactionId
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"",Xml,"",0,"","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 
	 Q Xml
}

/// 同步排班剩余数量 
ClassMethod GetAvailableRegNumOld(RBASId As %String) As %String
{
	;w ##class(dhcinterface.TeleReg).GetAvailableRegNum("1||11")
	 ;
	 s AvailableRegNum=0
	 
	 s appMethod="TEL"
	 
	 If RBASId'="" {
		s ResRowId=$P(RBASId,"||",1)
		s ASChildSub=$P(RBASId,"||",2)
		;预约限额
		s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
		s IsUnity=$p($g(^DHCOPRegConfig("AppConfig",appMethod)),"^",3)
		s:IsUnity="" IsUnity=0 
		;w IsUnity,!
		s WinMethodAppLoad=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,appMethod)
		s:IsUnity=1 WinMethodAppLoad=AppLoad
		s AppLoad=WinMethodAppLoad
		
		s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCountNew(RBASId,appMethod)
		s AppedCount=$P(UsedSeqNoCount,"^",2)
		if (AppedCount<AppLoad){
			s AvailableRegNum=AppLoad-AppedCount
		}
	}
	 
	 Q AvailableRegNum
}

/// 同步排班剩余数量 
ClassMethod GetAvailableRegNum(RBASId As %String, UserID As %String) As %String
{
	;w ##class(dhcinterface.TeleReg).GetAvailableRegNum("1||11")
	 ;
	 s AvailableRegNum=0
	 
	 s appMethod="TEL"
	 
	 If RBASId'="" {
		s ResRowId=$P(RBASId,"||",1)
		s ASChildSub=$P(RBASId,"||",2)
		;预约限额
		s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
		s IsUnity=$p($g(^DHCOPRegConfig("AppConfig",appMethod)),"^",3)
		s:IsUnity="" IsUnity=0 
		;w IsUnity,!
		s WinMethodAppLoad=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,appMethod)
		s:IsUnity=1 WinMethodAppLoad=AppLoad
		s AppLoad=WinMethodAppLoad
		
		s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCountNew(RBASId,appMethod)
		s AppedCount=$P(UsedSeqNoCount,"^",2)
		if (AppedCount<AppLoad){
			s AvailableRegNum=AppLoad-AppedCount
		}
	}
	
	//同步预约数
	s paraobj=##class(dhcinterface.SendMsg).%New()
	s paraobj.RBASId=RBASId
	s paraobj.AvailableRegCount=AvailableRegNum
	s paraobj.HospitalId="002"

	s status=paraobj.XMLExportToString(.Xml,"Request")
	s serviceobj=##Class(dhcserviceclient.BSTServiceSoap).%New()
    s MsgXml=serviceobj.SynAvailableRegCount(Xml)
	Q AvailableRegNum
}

/// 同步排班剩余数量 
ClassMethod SynAvailableRegCount(RBASId As %String) As %String
{
	;w ##class(dhcinterface.TeleReg).SynAvailableRegCount("1||11")
	 ;w ##class(portalinterface.SYTest).SynAvailableRegCountTest("1201||1")
	 s Xml=""
	 //s appMethod="WEB"
	 s appMethod="TEL"
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.RBASId=RBASId
	 s paraobj.AvailableRegCount=0
	  //新增发送请求数据
	 
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","SynAvailableRegCount","","",0,"Request","")
	 s TransactionId=$tr(RBASId,"||","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 s paraobj.TransactionId=TransactionId
	  //add by ouziran
	If RBASId'="" {
		s ResRowId=$P(RBASId,"||",1)
		s ASChildSub=$P(RBASId,"||",2)
		;预约限额
		s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
		s IsUnity=$p($g(^DHCOPRegConfig("AppConfig",appMethod)),"^",3)
		s:IsUnity="" IsUnity=0 
		;w IsUnity,!
		s WinMethodAppLoad=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,appMethod)
		s:IsUnity=1 WinMethodAppLoad=AppLoad
		s AppLoad=WinMethodAppLoad
		
		s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCountNew(RBASId,appMethod)
		s AppedCount=$P(UsedSeqNoCount,"^",2)
		if (AppedCount<AppLoad){
			s paraobj.AvailableRegCount=AppLoad-AppedCount
		}
	}
	 
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }
	  //更新发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"SynAvailableRegCount",Xml,"",0,"","")
	 s TransactionId=paraobj.TransactionId
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 Q Xml
}

/// ljq-写交易流水表
ClassMethod WriteTradeBiz(Type As %String, TradeBizDR As %String, Str As %String) As %String
{
	; 调用者流水号^病人唯一索引^交易类型^交易渠道^本地相关关键字^交易状态^交易金额^业务类型^外部信息
	;w ##class(dhcinterface.TeleReg).WriteTradeBiz("Insert","1^2^O^95533^3^不确定^10^A^10121212")
	s MerchantNo=$p(Str,"^",1)			//调用者流水号
	s PatientID=$p(Str,"^",2) 			//病人唯一索引
	s TradeType=$p(Str,"^",3) 			//交易类型
	s Channel=$p(Str,"^",4) 			//交易渠道
	s TradeKey=$p(Str,"^",5)			//本地相关关键字(预约?发票唯一标示)
	s Status=$p(Str,"^",6) 				//交易状态
	s TradeAmt=$p(Str,"^",7) 			//交易金额
	s BizType=$p(Str,"^",8) 			//业务类型
	s MerchantKey=$p(Str,"^",9)			//外部信息(银行卡号)

	if (Type="Insert") {
		k PLIST
		s PLIST(2)=BizType,PLIST(3)=##class(web.DHCRBResourceRule).GetChannelDR(Channel)
		s PLIST(4)=MerchantKey,PLIST(5)=MerchantNo
		s PLIST(6)="",PLIST(7)="",PLIST(8)="",PLIST(9)="",PLIST(10)="",PLIST(11)=PatientID
		s PLIST(12)=Status,PLIST(13)=TradeAmt,PLIST(14)=$P($H,",",1),PLIST(15)=TradeKey
		s PLIST(17)=$P($H,",",2),PLIST(18)=TradeType

		q:BizType="" "1^业务类型为空"
		q:Channel="" "1^交易渠道为空"
		q:MerchantKey="" "1^外部信息为空"
		q:MerchantNo="" "1^调用者流水号为空"
		q:PatientID="" "1^病人ID为空"
		q:Status="" "1^交易状态为空"
		q:TradeAmt="" "1^交易金额为空"
		q:TradeKey="" "1^本地相关关键字为空"
		q:TradeType="" "1^交易类型为空"
		TSTART
		b ;stop
		;&sql(Insert into sqluser.HX_TradeBiz values :PLIST())   ;gry
		s TradeBizDR=$p(%ROWID,$c(1))
		If SQLCODE TRollBack  Quit "1^写交易失败:"_SQLCODE
		TCOMMIT
	} elseif (Type="UStatus"){
		q:TradeBizDR="" "1^更新ID为空"
		q:Status="" "1^状态为空"
		TSTART
		;&sql(Update sqluser.HX_TradeBiz set HTB_Status=:Status where HTB_RowId=:TradeBizDR)  ;gry
		s TradeBizDR=$p(%ROWID,$c(1))
		If SQLCODE TRollBack  Quit "1^写交易失败:"_SQLCODE
		TCOMMIT
	}
	q "0^"_TradeBizDR
}

/// ljq-写支付表记录
ClassMethod WriteTradeBizPay(Type As %String, Str As %String) As %String
{
	b ;start HXTradeBizPay
	;d ##class(dhcinterface.TeleReg).WriteTradeBizPay("","")
	q:$p(Str,"^",1)="" "1^无交易流水表DR" s TradeBizDR=$p(Str,"^",1)
	q:$p(Str,"^",2)="" "1^无支付金额" s PayAmt=$p(Str,"^",2)
	q:$p(Str,"^",3)="" "1^无支付方式" s PayMode=$p(Str,"^",3)
	q:$p(Str,"^",4)="" "1^无支付用户" s PayUser=$p(Str,"^",4)
	q:$p(Str,"^",5)="" "1^无交易流水号" s TradeNo=$p(Str,"^",5)
	q:$p(Str,"^",6)="" "1^无交易日期" s TradeDate=$p(Str,"^",6)
	q:$p(Str,"^",7)="" "1^无交易时间" s TradeTime=$p(Str,"^",7)
	//q:$p(Str,"^",8)="" "1^无支付渠道" s PayChannel="CCBNet-P" //$p(Str,"^",8)
	s PayChannel="CCBNet-P"
	q:$p(Str,"^",9)="" "1^无支付方名称" s PayAgency=$p(Str,"^",9)
	q:$p(Str,"^",10)="" "1^无交易卡号" s PayCardNo=$p(Str,"^",10)
	
	k PLIST
	s PLIST(0)=TradeBizDR						//交易流水表DR
	s PLIST(2)=$P($H,",",1)						//创建日期
	s PLIST(3)=$P($H,",",2)						//创建时间
	s PLIST(4)=""								//Note1
	s PLIST(5)=""								//Note2
	s PLIST(6)=""								//Note3
	s PLIST(7)=""								//Note4
	s PLIST(8)=""								//Note5
	s PLIST(9)=PayAgency						//支付方名称
	s PLIST(10)=PayAmt							//支付金额
	s PLIST(11)=PayCardNo						//交易卡号
	s PLIST(12)=##class(web.DHCRBResourceRule).GetChannelDR(PayChannel)								//支付渠道
	s PLIST(13)=##class(web.DHCRBResourceRule).GetCTTradePayModeDR(PayMode)							//支付方式							//PaySub
	s PLIST(15)=PayUser							//支付用户
	s PLIST(16)=TradeDate						//交易日期
	s PLIST(17)=TradeNo							//交易流水号
	s PLIST(18)=TradeTime						//交易时间
	b ;liujianqiu
	;s CreateDate=$p($h,",",1)
	;s CreateTime=$p($h,",",2)
	
	TSTART
	if (Type="Insert") {
		;&sql(Insert into sqluser.HX_TradeBizPay values :PLIST())  ;gry
		s TradeBizPayDR=$p(%ROWID,$c(1))
		If SQLCODE TRollBack  Quit "1^写交易失败:"_SQLCODE
	} elseif (Type="Update") {
		/*
		&sql(Update sqluser.HX_TradeBizPay(HTP_CreateDate,HTP_CreateTime,
		HTP_PayAgency,HTP_PayAmt,HTP_PayCardNo,HTP_PayChannel,HTP_PayMode_DR,HTP_PayUser,HTP_TradeDate,
		HTP_TradeNo,HTP_TradeTime) values (:CreateDate,:CreateTime,:PayAgency,:PayAmt,:PayCardNo,
		:PayChannel,:PayMode,:PayUser,:TradeDate,:TradeNo,:TradeTime) 
		where HTP_RowId=:TradeBizPayDR)
		If SQLCODE TRollBack  Quit "0^更新交易失败:"_SQLCODE
		*/
	} else {
		q "0^无此类型"
	}
	TCOMMIT
	k PLIST
	Q "0^"_TradeBizPayDR
}

ClassMethod autoComplemented(XmlPara) As %String
{
	;k ^CACHETMPTML("114","autoComplemented")
	set ResultCode=1
	s Xml=""
	s ^CACHETMPTML("114","autoComplemented","114SendMsg",$p($h,",",1),$p($h,",",2))=XmlPara
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	While reader.Next(.telepara,.sc)  {
		s UserID=telepara.UserID
		s ClientAddress=telepara.ClientAddress
		s result=""
		s ErrorMsg=""
		s haveError=0
		if (..CheckteleUserID(UserID,ClientAddress,"autoComplemented")'=1){
			s ErrorMsg="用户验证失败"
		}else{
			set TransactionIds=telepara.TransactionIds
			set len=$Length(TransactionIds,",")
			for iTrans=1:1:len {
				s result=""
		   		s TransactionId=$Piece(TransactionIds,",",iTrans)
		   		//新增接收请求数据
		  		s TransactionRowId=##class(web.DHCTeleTransaction).GetRowId(TransactionId)
	;w !,iTrans,":",TransactionId,":",TransactionRowId,":"
		  		s Transaction=##class(User.DHCTeleTransaction).%OpenId(TransactionRowId)
		  		if '$IsObject(Transaction){
			  		s haveError=1
		  		}else{
			  		d Transaction.RequestMsg.Rewind()
			  		s mylen=2000
			   		s XmlStr=Transaction.RequestMsg.ReadLine(.mylen)
			  		s TransType=Transaction.TransactionType
			  		;w TransType,",xmlstr:",XmlStr
			  		;XmlStr="<Request><HospitalId>002</HospitalId><TransactionId>0000000793</TransactionId><ApptId>0000000304</ApptId></Request>"
			   		if (TransType="cancelRegistration"){ ;114方调用本地
				   		;b ;cancelRegistration
				 		set:XmlStr'="" result=##class(dhcinterface.TeleReg).cancelRegistration(XmlStr)
				 		s:result="" haveError=1
					}elseif (TransType="confirmRegistration"){ ;114方调用本地
				   		;b confirmRegistration
				 		set:XmlStr'="" result=##class(dhcinterface.TeleReg).confirmRegistration(XmlStr)
				 		s:result="" haveError=1
					}elseif (TransType="GetWorkInfo"){ ;本地?但与主动发送分开
						;b ;GetWorkInfo
						set:XmlStr'="" result=##class(dhcinterface.TeleReg).reSendWorkInfo(XmlStr)
						s result="oo"
						s:result="" haveError=1
					}elseif (TransType="notifyChangeWork"){ ;本地?但与主动发送分开
						;b ;notifyChangeWork
						set:XmlStr'="" result=##class(dhcinterface.TeleClient).reSendnotifyChangeWork(XmlStr)
						s:result="" haveError=1
					}elseif (TransType="notifyGetNumber"){ ;本地?与主动发送一致?需初始化原来的变量
						;b ;notifyGetNumber
						if (XmlStr'=""){
							Set reader=##class(%XML.Reader).%New()
							Set sc=reader.OpenString(XmlStr)
							If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
							Do reader.Correlate("Request","dhcinterface.SendMsg")
							While reader.Next(.xmltelepara,.sc)  {
								s ApptId=xmltelepara.ApptId
					 			s:ApptId'="" result=##class(dhcinterface.TeleReg).notifyGetNumber(ApptId)
					 			s:result="" haveError=1
							}
						}
					}elseif (TransType="notifyStopWork"){ ;本地?与主动发送一致?需初始化原来的变量
						;b ;notifyStopWork
						if (XmlStr'=""){
							Set reader=##class(%XML.Reader).%New()
							Set sc=reader.OpenString(XmlStr)
							If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
							Do reader.Correlate("Request","dhcinterface.SendMsg")
							While reader.Next(.xmltelepara,.sc)  {
								s RBASId=xmltelepara.RBASId
					 			s:RBASId'="" result=##class(dhcinterface.TeleReg).notifyStopWork(RBASId)
					 			s:result="" haveError=1
							}
						}
					}else{
						;b
					}
					;if (haveError=1){b}
		  		}
		  		;;;;;;
			}
		}
		
		//只要有错误就返回1
		if (haveError=1) {
			set ResultCode=1
		}else{
			set ResultCode=0
		}
	    s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s status=msgobj.XMLExportToString(.Xml,"Response")
		s ^CACHETMPTML("114","autoComplemented","HISReturnMsg")=Xml
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
	}
	
	;s myxml="<Request><TransactionIds>20070914-140028-142722</TransactionIds></Request>"
	//set Xml="<Response><ResultCode>0</ResultCode><SeqCode>2</SeqCode><ApptId>1540||7||2</ApptId></Response>"
	Quit Xml
}

/// 取消预约
ClassMethod cancelRegistration(XmlPara) As %String
{
	;w ##class(portalinterface.SYTest).cancelRegistration("")
	//test数据
	;set XmlPara="<Request><TransactionId>120123</TransactionId><ApptId>1201||2||3</ApptId><UserID>4402</UserID><ClientAddress></ClientAddress><Method>1</Method></Request>"
	
	s Xml=""
	s ^CACHETMPTML("114","cancelRegistration","SendMsg")=$zd(+$h,3)_":"_$zt($p($h,",",2),1)_"XmlPara:"_XmlPara
	s AvailableRegNum=0
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	s ErrorMsg=""
	While reader.Next(.telepara,.sc)  {
		s TransactionId=telepara.TransactionId
		s ApptId=telepara.ApptId
		s rtn=##class(web.DHCRBAppointment).CancelAppointment(ApptId)
				if (+rtn=0) { 
					Set RBASId=$Piece(ApptId,"||",1,2)
					;s AvailableRegNum=##Class(dhcinterface.TeleReg).GetAvailableRegNum(RBASId)
					s AvailableRegNum=##Class(dhcinterface.TeleReg).GetAvailableRegNum(RBASId,"") //zhaoym 20090910
					s Flag=0
					s ErrorMsg=""
					
				}
				else {
					s Flag=1
					s ErrorMsg="取消预约失败,Code:"_rtn
				}
		//s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"cancelRegistration",XmlPara,"",0,"Response","")
		/*
		if (TransactionId'=""){		
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			
			if (..CheckteleUserID(UserID,ClientAddress,"cancelRegistration")'=1){
				s Flag=1
				s ErrorMsg="用户验证失败"
			}else{
				s Flag=0
				s rtn=##class(web.DHCRBAppointment).CancelAppointment(ApptId)
				if (rtn=0) { 
					s Flag=0
					s ErrorMsg=""
				}
				else {
					s Flag=1
					s ErrorMsg="取消预约失败,Code:"_rtn
				}
			}
		}
		else
		{
			s Flag=1
			s ErrorMsg="写交易日志失败,取消预约失败"
		}
		*/
		 s msgobj=##class(dhcinterface.ReturnMsg).%New()
		 s msgobj.ResultCode=Flag
		 s msgobj.ErrorMsg=ErrorMsg
		 s msgobj.SynAvailableRegCountRt=AvailableRegNum           //
		 s status=msgobj.XMLExportToString(.Xml,"Response")
		 If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		 }
		 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"cancelRegistration","",Xml,0,"","")
	}
	s ^CACHETMPTML("114","cancelRegistration","ReturnMsg")=Xml
	Q Xml
}

/// 实名卡验证
ClassMethod checkUserInfo(XmlPara) As %String
{
	;w ##class(dhcinterface.TeleReg).checkUserInfo(XmlPara)
 ;Set XmlPara="<Request><PatientCard>000000000003251</PatientCard><CardType>15</CardType><TransactionId>21189</TransactionId><UserID>4402</UserID><ClientAddress></ClientAddress></Request>"
	
	Set ^DHCSML="^"_XmlPara_"^"
	s Xml=""
	Set reader = ##class(%XML.Reader).%New()
	s ^CACHETMPTML("114","checkUserInfo","SendMsg")=XmlPara
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	While reader.Next(.telepara,.sc)  
	{
		s TransactionId=telepara.TransactionId
		//s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"checkUserInfo",XmlPara,"",0,"Response","")
		if (TransactionId'=""){
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			//if (..CheckteleUserID(UserID,ClientAddress,"checkUserInfo")'=1)
			//{
			//	s Flag=1
			//	s ErrorMsg="用户验证失败"
			//}
			//else
			//{
			   s PatientCardNo=telepara.PatientCard
			   ;s CardType=telepara.CardType
			  ; if $length(PatientCardNo)=15,$e(PatientCardNo,1,3)="000" 
			   ;{
				   s CardType=""
				   &sql(select CF_CardType_DR into :CardType from sqluser.dhc_cardref where cf_cardno=:PatientCardNo)
				   if (CardType="")
				   {
					    s ResultCode=1
					    s Flag="-200" 
					    s ErrorMsg="无效卡"
					    s PatientID=""
					    
				   }
				   else
				   {
					   s RegType=$p(^DHCCARDTYPEDef(CardType),"^",35)
					   i RegType="REG"
					   {
						    s ResultCode=0
						    s Flag="0" 
						    s ErrorMsg=""
						   /*
						    s ResultCode=1
						    s Flag="-201" 
						    s ErrorMsg="此卡不能预约"
						    s PatientID=""
						    */
					   }
					   else
					   {
						   ;s CardType=15 ;写死就诊卡
						   s rtn=##class(dhcinterface.PatientInfo).GetCardInfo(PatientCardNo,CardType)			   
						   s Flag=$P(rtn,"^",1)
						   i Flag=0 {
							    s ErrorMsg=""
							    s ResultCode=0
								s PatientID=$P(rtn,"^",2)
								s patobj=##class(dhcinterface.PatientInfo).GetByPatinetID(PatientID,CardType)
								s patobj.Company=patobj.Company_"^^"_$P(rtn,"^",3)
								s ^gry("cardtype")=patobj.Company
						   }else{
							    s ResultCode=1
							    i Flag="-200" s ErrorMsg="无效卡"
							    s PatientID=""
						   }
					   }
				   }
			    ;}
			    ;else
			    ;{
				    /*
				   s rtn=##class(dhcinterface.PatientInfo).GetPatInfo(PatientCardNo)
				   s Flag=$P(rtn,"^",1)
				   i Flag=0 {
					    s ErrorMsg=""
					    s ResultCode=0
						s PatientID=$P(rtn,"^",2)
						s patobj=##class(dhcinterface.PatientInfo).GetByPatinetID(PatientID)
				   }elseif Flag="-202" {
					    s ResultCode=1
					    s ErrorMsg="病人证件号重复"
					    s PatientID=""
				   }elseif Flag="-203" {
					    s ResultCode=1
					    s ErrorMsg="无效病人证件号"
					    s PatientID=""
				   }elseif Flag="-204" {
					    s ResultCode=1
					    s ErrorMsg="无有效注册医疗卡"
					    s PatientID=""
				   }   
				   */
			  ; }
			//}
		}
		else{
			s Flag=1
			s ErrorMsg="写交易日志失败,实名卡验证失败"
		}
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=Flag
		s msgobj.ErrorMsg=ErrorMsg
		i Flag=0 {s msgobj.PatientInfo=patobj}
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
		//s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"checkUserInfo","",Xml,0,"","")
	} 
	s ^CACHETMPTML("114","checkUserInfo","ReturnMsg")=Xml
	Q Xml
}

/// ljq-确认预约  OK--20090709
ClassMethod confirmRegistration(XmlPara) As %String
{
	;w ##class(dhcinterface.TeleReg).confirmRegistration("")
	//test数据
	//set XmlPara="<Request><RBAEndDate></RBAEndDate><HospitalId></HospitalId><HospitalCode></HospitalCode><PatientCard></PatientCard><PatientID>07156970</PatientID><RBASId>440||149</RBASId><TransactionId>book200908181426513</TransactionId><ApptId></ApptId><TransactionIds></TransactionIds><CardType></CardType><CheckId></CheckId><ClientAddress>portalserver</ClientAddress><RBAStartDate></RBAStartDate><UserID>hxperson</UserID><RBASREASON></RBASREASON><ApptType></ApptType><AvailableRegCount></AvailableRegCount><Method></Method><BankCode></BankCode><PaymentMode></PaymentMode><PaymentFee></PaymentFee><RefundType></RefundType><AccStartDate></AccStartDate><AccStartHour></AccStartHour><AccStartMinute></AccStartMinute><AccEndDate></AccEndDate><AccEndHour></AccEndHour><AccEndMinute></AccEndMinute><AccType></AccType><RefundFee></RefundFee></Request>"
	
	s Xml=""
	s ^CACHETMPTML("114","confirmRegistration","SendMsg")=XmlPara

	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	s ResultCode=1
	s ErrorMsg=""
	s TradeNo=""
	s RegFee=""
	s AdmitRange=""
	s AdmitAddress=""
	While reader.Next(.telepara,.sc)  {
		set ^TMP("HospitalCode")=telepara.HospitalCode
		set HospitalID=..GetHospitalIDByCode(telepara.HospitalCode)     //根据平台的医疗机构的代码取其在HIS表中的ID
		s RBASId=telepara.RBASId
		s PatientID=telepara.PatientID
		s UserID=telepara.UserID
		s MethorDR=telepara.Method //$O(^RBC("APTM",0,"Code","TEL",0))
		s:((UserID="hxadmin01")&&(PatientID'="")) PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		s:((UserID="hxadmin01")&&(PatientID="")) PatientID="895709"   //895709对应公共卡登记号06995166的papami_rowid
		s:UserID="hxperson" PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		s MethorDR=$O(^RBC("APTM",0,"Code","TEL",0))
		s:UserID="hxadmin01" MethorDR=$O(^RBC("APTM",0,"Code","WEB",0))
		s:UserID="hxperson" MethorDR=$O(^RBC("APTM",0,"Code","PERW",0))
		if MethorDR="" s MethorDR=$O(^RBC("APTM",0,"Code","TEL",0))   ;gry
		
		s MethodrCode=$p(^RBC("APTM",MethorDR),"^",1)
		s Para=PatientID_"^"_RBASId_"^"_MethorDR_"^O^^^^"_HospitalID

		s rtn=##class(web.DHCRBAppointment).Insert(Para)
		s ^PPP(0)=rtn
		if (+rtn=0){
			s ResultCode=0
			s Flag=0
			s TradeNo=""
			s AdmitRange=""
			s AdmitAddress="AdmitAddress"
			s rtnDocStr=##class(web.DHCOPAdmReg).GetMarkRegFee(RBASId,"")
			s APPTRowId=$P(rtn,"^",2)
			s QueueNo=$P(rtn,"^",3)
			s ErrorMsg=##class(web.DHCOPAdmReg).GetAdmTimeRange(RBASId,QueueNo)
			s AdmitRange=##class(web.DHCOPAdmReg).GetAdmTimeRange(RBASId,QueueNo)
			;s AdmitAddress=##class(web.DHCRBResourceRule).GetRoomDesc(RBASId)   //暂缺
			s RegFee=$p(rtnDocStr,"^",12)+$p(rtnDocStr,"^",14)+$p(rtnDocStr,"^",20)+2
		}else {
			s ResultCode=1
			s Flag=1
			s APPTRowId=""
			s TradeNo=""
		   	s QueueNo=""
		   	if rtn="-203" {
			   	s ErrorMsg="预约失败,预约医生已停诊,Code:"_rtn
		   	}elseif (rtn="-201"){
			   	s ErrorMsg="预约失败,预约医生号已满,Code:"_rtn
		   	}elseif (rtn="-202") {
			   	s ErrorMsg="预约失败,预约医生当日不出诊,Code:"_rtn
		   	}else{
				s ErrorMsg="预约失败,Code:"_rtn
		   	}
			s RegFee=""
		    s AdmitRange=""
		    s AdmitAddress=""
		}
	/*
	   s TransactionId=telepara.TransactionId
	   s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"confirmRegistration",XmlPara,"",0,"Response","")
	   if (TransactionId'="")
	   {
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			s Method=telepara.Method
			if (..CheckteleUserID(UserID,ClientAddress,"confirmRegistration")'=1)&&(UserID=""){
					s Flag=1
					s TradeNo=""
		   			s QueueNo=""
					s ErrorMsg="用户验证失败"
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
			}elseif ('##class(web.DHCRBResourceRule).CheckScheduleDate(telepara.RBASId)){
					s Flag=1
					s TradeNo=""
		   			s QueueNo=""
					s ErrorMsg="节假日不能预约"
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
			}else{
				s RBASId=telepara.RBASId
		   		s PatientID=telepara.PatientID
		   		s:((UserID="hxadmin01")&&(PatientID'="")) PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		   		s:((UserID="hxadmin01")&&(PatientID="")) PatientID="1736495"
		   	    s:UserID="hxperson" PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		   		s MethorDR=$O(^RBC("APTM",0,"Code","TEL",0))
		   		s:UserID="hxadmin01" MethorDR=$O(^RBC("APTM",0,"Code","WEB",0))
		   		s:UserID="hxperson" MethorDR=$O(^RBC("APTM",0,"Code","PERW",0))
		   		s MethodrCode=$p(^RBC("APTM",MethorDR),"^",1)
		   		s PatientCardRow=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
		   		s PatientCardNo=$p(^DHCCARD("CF",PatientCardRow),"^",2)
		   		s commCardNo=$p($g(^DHCOPRegConfig("AppConfig",MethodrCode)),"^",1)
		   		s ret=0
		   		s:((commCardNo="")||(commCardNo'=PatientCardNo)) ret=##class(web.DHCOPAdmReg).CheckRegCountLimit(PatientID,RBASId)
		   		s RBASId=telepara.RBASId
		   		s PatientID=telepara.PatientID
		   		s MethorDR=telepara.Method //$O(^RBC("APTM",0,"Code","TEL",0))
				if ret=0 {
	   				s Para=PatientID_"^"_RBASId_"^"_MethorDR_"^O^"
			   		s rtn=##class(web.DHCRBAppointment).Insert(Para)
			  		s Flag=$P(rtn,"^",1)
			   		if Flag=0 {
				   		//ljq-预约挂号新增
				   		s RegInfo=..GetRegInfo($P(rtn,"^",2))   //获取挂号信息Flag^RegFee^AdmitRange^AdmitAddress^PAAdmDR^RegFeeDR^PAPMIDR^ErrorMsg
				   		s RegFlag=$p($g(RegInfo),"^",1)
				   		s RegErrorMsg=$p($g(RegInfo),"^",8)
				   		if (RegFlag=0) {
					   		s str=TransactionId_"^"_PatientID_"^"_"预约"_"^"_UserID_"^"_$P(rtn,"^",2)_"^"_1_"^"_$p($g(RegInfo),"^",2)_"^"_"O"_"^"_"CardNo"
				   			s ret=..WriteTradeBiz("Insert","",str)
				   			s Flag=$p($g(ret),"^",1)
				   			s TradeDR=$p($g(ret),"^",2)
				   			if Flag=0 {
				    			s ResultCode=0
				    			s TradeNo=$p($g(^HXTB(TradeDR)),"^",10)
				   				s QueueNo=$P(rtn,"^",3)
				    			s ErrorMsg=""
				    			s RegFee=$p($g(RegInfo),"^",2)
				    			s AdmitRange=$p($g(RegInfo),"^",3)
				    			s AdmitAddress=$p($g(RegInfo),"^",4)
				   			}else{
					   			s TradeNo=""
				   				s QueueNo=""
								s ResultCode=1
								s ErrorMsg=$p($g(ret),"^",2)
								s RegFee=""
								s AdmitRange=""
								s AdmitAddress=""
					   		}
					   	} else {
							s Flag=1
							s TradeNo=""
		   					s QueueNo=""
							s ErrorMsg=RegErrorMsg
							s RegFee=""
							s AdmitRange=""
							s AdmitAddress=""
						}
			   		}else{
				   		s ResultCode=1
				   		s TradeNo=""
				   		s QueueNo=""
				   		i Flag=-200 s ErrorMsg="系统忙,请稍后重试"
				   		i Flag=-201 s ErrorMsg="无可用预约号"
				   		i Flag=-202 s ErrorMsg="无此排班记录"
				   		s RegFee=""
						s AdmitRange=""
						s AdmitAddress=""
			   		}
				}else{
				   	s TradeNo=""
				   	s QueueNo=""
					s ResultCode=1
					s ErrorMsg="超过个人的预约限额,不允许再预约" 
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
				}
		   }
		}else {
		   s ResultCode=1
		   s TradeNo=""
		   s QueueNo=""
		   s ErrorMsg="写交易日志失败,取消挂号失败"
		   s RegFee=""
		   s AdmitRange=""
		   s AdmitAddress=""
		}
	  	s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.TradeNo=TradeNo
		s msgobj.SeqCode=QueueNo
		s msgobj.RegFee=RegFee
		s msgobj.AdmitRange=AdmitRange
		s msgobj.AdmitAddress=AdmitAddress
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"confirmRegistration","",Xml,0,"","")
		
		*/
	}
	
	//调用同步接口,必须启动电话预约接口
		s AvailableRegNum=0
		s CFIFTeleAppStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFTeleAppStart")
		if (ResultCode=0),(CFIFTeleAppStart=1),(MethodrCode="TEL"){
			s ^ozr("SynPortal",RBASId)=MethodrCode
			set ^PPP(4)=$get(RBASId)
			//set myrtn=##class(portalinterface.PortalClient).SynAvailableRegCount(RBASId)			
			;s AvailableRegNum=##Class(dhcinterface.TeleReg).GetAvailableRegNum(RBASId)
			s AvailableRegNum=##Class(dhcinterface.TeleReg).GetAvailableRegNum(RBASId,"")
		}
		set ^PPP(3)=Xml
		
	s msgobj=##class(dhcinterface.ReturnMsg).%New()
	    s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.TradeNo=TradeNo
		s msgobj.SeqCode=QueueNo
		s msgobj.RegFee=RegFee
		s msgobj.AdmitRange=AdmitRange
		s msgobj.AdmitAddress=AdmitAddress
		s msgobj.ApptId=APPTRowId
		set msgobj.SynAvailableRegCountRt=AvailableRegNum
		s status=msgobj.XMLExportToString(.Xml,"Response")
		set ^PPP(1)=status
		set ^PPP(2)=Xml
		 If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		 }
	
	s ^CACHETMPTML("114","confirmRegistration","ReturnMsg")=Xml
	Quit Xml
}

/// 确认预约
ClassMethod confirmRegistration1(XmlPara) As %String
{
	s Xml=""
	s ^CACHETMPTML("114","confirmRegistration","SendMsg")=XmlPara
   
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	s ResultCode=1
	s ErrorMsg=""
	s TradeNo=""
	s RegFee=""
	s AdmitRange=""
	s AdmitAddress=""
	While reader.Next(.telepara,.sc)  {
	   s TransactionId=telepara.TransactionId
	   s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"confirmRegistration",XmlPara,"",0,"Response","")
	   if (TransactionId'="")
	   {
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			s Method=telepara.Method
			if (..CheckteleUserID(UserID,ClientAddress,"confirmRegistration")'=1)&&(UserID=""){
					s Flag=1
					s TradeNo=""
		   			s QueueNo=""
					s ErrorMsg="用户验证失败"
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
			}elseif ('##class(web.DHCRBResourceRule).CheckScheduleDate(telepara.RBASId)){
					s Flag=1
					s TradeNo=""
		   			s QueueNo=""
					s ErrorMsg="节假日不能预约"
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
			}else{
				s RBASId=telepara.RBASId
		   		s PatientID=telepara.PatientID
		   		s:((UserID="hxadmin01")&&(PatientID'="")) PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		   		s:((UserID="hxadmin01")&&(PatientID="")) PatientID="895709"  //895709对应公共卡登记号06995166的papami_rowid
		   	    s:UserID="hxperson" PatientID=$o(^PAPERi("PAPMI_PatNo",PatientID,""),-1)
		   		s MethorDR=$O(^RBC("APTM",0,"Code","TEL",0))
		   		s:UserID="hxadmin01" MethorDR=$O(^RBC("APTM",0,"Code","WEB",0))
		   		s:UserID="hxperson" MethorDR=$O(^RBC("APTM",0,"Code","PERW",0))
		   		s MethodrCode=$p(^RBC("APTM",MethorDR),"^",1)
		   		s PatientCardRow=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
		   		s PatientCardNo=$p(^DHCCARD("CF",PatientCardRow),"^",2)
		   		s commCardNo=$p($g(^DHCOPRegConfig("AppConfig",MethodrCode)),"^",1)
		   		s ret=0
		   		s:((commCardNo="")||(commCardNo'=PatientCardNo)) ret=##class(web.DHCOPAdmReg).CheckRegCountLimit(PatientID,RBASId)
		   		s RBASId=telepara.RBASId
		   		//s PatientID=telepara.PatientID   //cwg,2009.07.09
		   		s MethorDR=telepara.Method //$O(^RBC("APTM",0,"Code","TEL",0))
				if ret=0 {
	   				s Para=PatientID_"^"_RBASId_"^"_MethorDR_"^O^"
			   		s rtn=##class(web.DHCRBAppointment).Insert(Para)
			  		s Flag=$P(rtn,"^",1)
			   		if Flag=0 {
				   		//ljq-预约挂号新增
				   		s RegInfo=..GetRegInfo($P(rtn,"^",2))   //获取挂号信息Flag^RegFee^AdmitRange^AdmitAddress^PAAdmDR^RegFeeDR^PAPMIDR^ErrorMsg
				   		s RegFlag=$p($g(RegInfo),"^",1)
				   		s RegErrorMsg=$p($g(RegInfo),"^",8)
				   		if (RegFlag=0) {
					   		s str=TransactionId_"^"_PatientID_"^"_"预约"_"^"_UserID_"^"_$P(rtn,"^",2)_"^"_1_"^"_$p($g(RegInfo),"^",2)_"^"_"O"_"^"_"CardNo"
				   			s ret=..WriteTradeBiz("Insert","",str)
				   			s Flag=$p($g(ret),"^",1)
				   			s TradeDR=$p($g(ret),"^",2)
				   			if Flag=0 {
				    			s ResultCode=0
				    			s TradeNo=$p($g(^HXTB(TradeDR)),"^",10)
				   				s QueueNo=$P(rtn,"^",3)
				    			s ErrorMsg=""
				    			s RegFee=$p($g(RegInfo),"^",2)
				    			s AdmitRange=$p($g(RegInfo),"^",3)
				    			s AdmitAddress=$p($g(RegInfo),"^",4)
				   			}else{
					   			s TradeNo=""
				   				s QueueNo=""
								s ResultCode=1
								s ErrorMsg=$p($g(ret),"^",2)
								s RegFee=""
								s AdmitRange=""
								s AdmitAddress=""
					   		}
					   	} else {
							s Flag=1
							s TradeNo=""
		   					s QueueNo=""
							s ErrorMsg=RegErrorMsg
							s RegFee=""
							s AdmitRange=""
							s AdmitAddress=""
						}
			   		}else{
				   		s ResultCode=1
				   		s TradeNo=""
				   		s QueueNo=""
				   		i Flag=-200 s ErrorMsg="系统忙,请稍后重试"
				   		i Flag=-201 s ErrorMsg="无可用预约号"
				   		i Flag=-202 s ErrorMsg="无此排班记录"
				   		s RegFee=""
						s AdmitRange=""
						s AdmitAddress=""
			   		}
				}else{
				   	s TradeNo=""
				   	s QueueNo=""
					s ResultCode=1
					s ErrorMsg="超过个人的预约限额,不允许再预约" 
					s RegFee=""
					s AdmitRange=""
					s AdmitAddress=""
				}
		   }
		}else {
		   s ResultCode=1
		   s TradeNo=""
		   s QueueNo=""
		   s ErrorMsg="写交易日志失败,取消挂号失败"
		   s RegFee=""
		   s AdmitRange=""
		   s AdmitAddress=""
		}
		
		
	  	s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.TradeNo=TradeNo
		s msgobj.SeqCode=QueueNo
		s msgobj.RegFee=RegFee
		s msgobj.AdmitRange=AdmitRange
		s msgobj.AdmitAddress=AdmitAddress
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"confirmRegistration","",Xml,0,"","")
	}
	s ^CACHETMPTML("114","confirmRegistration","ReturnMsg")=Xml
	Quit Xml
}

/// 根据排班信息获取可挂号数
ClassMethod getAvailableRegCount(XmlPara, appMethod As %String = "TEL") As %String
{
	;Set XmlPara="<Request><RBASId>90||261</RBASId><TransactionId>22222222222222222222</TransactionId></Request>"
	;w ##class(dhcinterface.TeleReg).getAvailableRegCount(XmlPara)
	s Xml=""
	s ^CACHETMPTML("114","getAvailableRegCount","SendMsg")=XmlPara
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit ""
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	s ResultCode=1
	s ErrorMsg=""
	s AvailableRegCount=0
	While reader.Next(.telepara,.sc)  {	
	   s TransactionId=telepara.TransactionId
	   //新增接收请求数据
	   s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"getAvailableRegCount",XmlPara,"",0,"Response","")
	   if (TransactionId'="")
	   {
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			if (..CheckteleUserID(UserID,ClientAddress,"getAvailableRegCount")'=1){
					s ResultCode=1
					s ErrorMsg="用户验证失败"
			}
			else{
		   		s RBASId=telepara.RBASId
		   		If RBASId'="" {
					s ResRowId=$P(RBASId,"||",1)
					s ASChildSub=$P(RBASId,"||",2)
					;预约限额
					s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
					s IsUnity=$p($g(^DHCOPRegConfig("AppConfig",appMethod)),"^",3)
					s:IsUnity="" IsUnity=0 
					;w IsUnity,!
					s WinMethodAppLoad=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,appMethod)
					s:IsUnity=1 WinMethodAppLoad=AppLoad
					s AppLoad=WinMethodAppLoad
					
					s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCountNew(RBASId,appMethod)
					s AppedCount=$P(UsedSeqNoCount,"^",2)
					if (AppedCount>=AppLoad){
						s ResultCode=0 
						s ErrorMsg="无预约号"
					}
					else
					{
						s ResultCode=0
						s AvailableRegCount=AppLoad-AppedCount
					}
		   		}
		   		else
		   		{
			   		s ResultCode=1 
					s ErrorMsg="排班指针为空,查询排班可预约数失败"
		   		}
					
		   }
		}else {
		   s ResultCode=1
		   s QueueNo=""
		   s ErrorMsg="写交易日志失败,查询排班可预约数失败"
		}

	  s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=ResultCode
		s msgobj.ErrorMsg=ErrorMsg
		s msgobj.AvailableRegCount=AvailableRegCount
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"getAvailableRegCount","",Xml,0,"","")
	}
	s ^CACHETMPTML("114","getAvailableRegCount","ReturnMsg")=Xml
	Quit Xml
}

/// 获取公告信息
ClassMethod getBulletinInfo(XmlPara) As %String
{
	s Xml=""
	s Flag=1
	s ErrorMsg=""
	s reader = ##class(%XML.Reader).%New()
	s ^CACHETMPTML("114","getBulletinInfo","SendMsg")=XmlPara
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	While reader.Next(.telepara,.sc)  {
		s TransactionId=telepara.TransactionId
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"getBulletinInfo",XmlPara,"",0,"Request","")
		if (TransactionId'=""){		
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			if (..CheckteleUserID(UserID,ClientAddress,"getBulletinInfo")'=1){
				s Flag=1
				s ErrorMsg="用户验证失败"
			}else{
				s Flag=0
				s ErrorMsg=""
			}
		}else{
			s Flag=1
			s ErrorMsg="写交易日志失败,实名卡验证失败"
		}
		 s msgobj=##class(dhcinterface.ReturnMsg).%New()
		 s infoobj=##class(dhcinterface.BulletinInfo).GetByID(i)
	 	 d msgobj.BulletinInfos.Insert(infoobj)
		 s msgobj.ResultCode=Flag
		 s msgobj.ErrorMsg=ErrorMsg
		 s status=msgobj.XMLExportToString(.Xml,"Response")
		 If ($system.Status.IsError(status)) {
			Do $system.OBJ.DisplayError(status)
			s Xml=""
		 }
		 s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"getBulletinInfo","",Xml,0,"","")
	}
	s ^CACHETMPTML("114","getBulletinInfo","ReturnMsg")=Xml
	Q Xml
}

/// 换诊通知
ClassMethod notifyChangeWork(OldRBASId As %String, NewRBASId As %String, AppMehod As %String = "") As %String
{
	 ;w ##class(dhcinterface.TeleReg).notifyChangeWork("870||2","874||1","")
	
	 s Xml=""
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.RBASId=OldRBASId
	 ;s RBASObject=##class(dhcinterface.RBASRec).GetByID(NewRBASId,AppMehod)
	 s RBASObject=##class(dhcinterface.RBASRec).GetByID(NewRBASId)   //guorongyong 
	 s paraobj.RBASRec=RBASObject
	 //新增发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","notifyChangeWork","","",0,"Request","")
	 s TransactionId=$tr(NewRBASId,"||","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 s paraobj.TransactionId=TransactionId
	 //add by ouziran
	 s ParRef=$p(OldRBASId,"||",1)
	 s SubDR=$p(OldRBASId,"||",2)
	 s ReasonDesc=""
	 s ReasonID=$p(^RBAS(ParRef,SubDR,"DHC"),"^",11)
	 if ReasonID'="" s ReasonDesc=$p(^RBC("NA",ReasonID),"^",2)
	 s paraobj.RBASREASON=ReasonDesc
	 
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }
	 //更新发送请求数据
	//s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"notifyChangeWork",Xml,"",0,"","")
	s TransactionId=paraobj.TransactionId
	If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	}
	 Q Xml
}

/// 用户取号通知
ClassMethod notifyGetNumber(ApptId As %String) As %String
{
	 ;w ##class(portalinterface.SYTest).notifyGetNumberTest("90||4||14")
	
	 s Xml=""
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.ApptId=ApptId
	 //新增发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","notifyGetNumber",ApptId,"",0,"Request","")
	 s TransactionId=$tr(ApptId,"||","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 s paraobj.TransactionId=TransactionId
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }
	 //更新发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"notifyGetNumber",Xml,"",0,"","")
	 s TransactionId=paraobj.TransactionId
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 Q Xml
}

/// 停诊通知
ClassMethod notifyStopWork(RBASId As %String) As %String
{
	 ;w ##class(dhcinterface.TeleReg).notifyStopWork("613||1")
	 ;
	 s Xml=""
	 s paraobj=##class(dhcinterface.SendMsg).%New()
	 s paraobj.HospitalId="002"
	 s paraobj.RBASId=RBASId
	  //新增发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert","","notifyStopWork","","",0,"Request","")
	 s TransactionId=$tr(RBASId,"||","")
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 s paraobj.TransactionId=TransactionId
	  //add by ouziran
	 s ParRef=$p(RBASId,"||",1)
	 s SubDR=$p(RBASId,"||",2)
	 s ReasonDesc=""
	 s ReasonID=$p($g(^RBAS(ParRef,SubDR,"DHC")),"^",11)
	 if ReasonID'="" s ReasonDesc=$p($g(^RBC("NA",ReasonID)),"^",2)
	 s paraobj.RBASREASON=ReasonDesc
	 
	 s status=paraobj.XMLExportToString(.Xml,"Request")
	 If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
	 }
	  //更新发送请求数据
	 //s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"notifyStopWork",Xml,"",0,"","")
	 s TransactionId=paraobj.TransactionId
	 If (TransactionId="") {
		Do $system.OBJ.DisplayError(TransactionId)
		Quit TransactionId
	 }
	 Q Xml
}

/// 根据交易流水号?重发排班信息
ClassMethod reSendWorkInfo(XmlPara) As %String
{
	s Xml=""
	s Flag=1
	s ErrorMsg=""
	Set reader=##class(%XML.Reader).%New()
	Set sc=reader.OpenString(XmlPara)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	Do reader.Correlate("Request","dhcinterface.SendMsg")
	While reader.Next(.telepara,.sc)  {
		s TransactionId=telepara.TransactionId
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Insert",TransactionId,"reSendWorkInfo",XmlPara,"",0,"Response","")
		if (TransactionId'=""){
			s UserID=telepara.UserID
			s ClientAddress=telepara.ClientAddress
			if (..CheckteleUserID(UserID,ClientAddress,"reSendWorkInfo")'=1){
				s Flag=1
				s ErrorMsg="用户验证失败"
			}else{
				s ReTransactionId=telepara.CheckId
				s TransactionRowId=##class(web.DHCTeleTransaction).GetRowId(ReTransactionId)
				s Transaction=##class(User.DHCTeleTransaction).%OpenId(TransactionRowId)
				if $IsObject(Transaction){
					d Transaction.RequestMsg.Rewind()
					s mylen=2000
					s saveXml=Transaction.RequestMsg.ReadLine(.mylen)
					if (saveXml'=""){
						Set savereader = ##class(%XML.Reader).%New()
						Set sc=savereader.OpenString(saveXml)
						If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
						Do savereader.Correlate("Request","dhcinterface.SendMsg")
						While savereader.Next(.savepara,.sc)  {
							s RBAStartDate=savepara.RBAStartDate
							s RBAEndDate=savepara.RBAEndDate
							q:RBAStartDate=""
							q:RBAEndDate=""
							d ##class(dhcinterface.TeleClient).updateWorkInfo(RBAStartDate,RBAEndDate)
							s Flag=0
							s ErrorMsg=""
						}
					}else{
						s Flag=1
						s ErrorMsg="重发排班信息失败,上次传输失败"
					}
				}else{
					w ReTransactionId,!
					s Flag=1
					s ErrorMsg="重发排班信息失败,无交易记录"
				}
			}
		}else{
			s Flag=1
			s ErrorMsg="写交易日志失败,实名卡验证失败"
		}
		
		s msgobj=##class(dhcinterface.ReturnMsg).%New()
		s msgobj.ResultCode=Flag
		s msgobj.ErrorMsg=ErrorMsg
		s status=msgobj.XMLExportToString(.Xml,"Response")
		If ($system.Status.IsError(status)) {
		Do $system.OBJ.DisplayError(status)
			s Xml=""
		}
		s TransactionId=##class(dhcinterface.TeleReg).writeLog("Update",TransactionId,"reSendWorkInfo","",Xml,0,"","")
	}
	quit Xml
}

ClassMethod test() As %String
{
	;d ##class(dhcinterface.TeleReg).test()
	;w ##class(dhcinterface.TeleReg).confirmRegistration("<Request><RBAEndDate></RBAEndDate><HospitalId></HospitalId><PatientCard></PatientCard><PatientID>0000038261</PatientID><RBASId>1||80</RBASId><TransactionId>book200905151820302</TransactionId><ApptId></ApptId><TransactionIds></TransactionIds><CardType></CardType><CheckId></CheckId><ClientAddress>portalserver</ClientAddress><RBAStartDate></RBAStartDate><UserID>hxperson</UserID><RBASREASON></RBASREASON><ApptType></ApptType><AvailableRegCount></AvailableRegCount><Method></Method><BankCode></BankCode><PaymentMode></PaymentMode><PaymentFee></PaymentFee><RefundType></RefundType><AccStartDate></AccStartDate><AccStartHour></AccStartHour><AccStartMinute></AccStartMinute><AccEndDate></AccEndDate><AccEndHour></AccEndHour><AccEndMinute></AccEndMinute><AccType></AccType></Request>")
	;w ##class(dhcinterface.TeleReg).PaymentRegistration("<Request><RBAEndDate></RBAEndDate><HospitalId></HospitalId><PatientCard></PatientCard><PatientID></PatientID><RBASId></RBASId><TransactionId>payment200905151005119</TransactionId><ApptId>61496346822</ApptId><TransactionIds></TransactionIds><CardType></CardType><CheckId></CheckId><ClientAddress>portalserver</ClientAddress><RBAStartDate></RBAStartDate><UserID>hxadmin01</UserID><RBASREASON></RBASREASON><ApptType></ApptType><AvailableRegCount></AvailableRegCount><Method></Method><BankCode>CCB</BankCode><PaymentMode>WEBBANK</PaymentMode><PaymentFee>5.00</PaymentFee><RefundType></RefundType><AccStartDate></AccStartDate><AccStartHour></AccStartHour><AccStartMinute></AccStartMinute><AccEndDate></AccEndDate><AccEndHour></AccEndHour><AccEndMinute></AccEndMinute><AccType></AccType></Request>")
	;w ##class(dhcinterface.TeleReg).RefundRegistration("<Request><RBAEndDate></RBAEndDate><HospitalId></HospitalId><PatientCard></PatientCard><PatientID></PatientID><RBASId></RBASId><TransactionId>refund200905151356302</TransactionId><ApptId>61496346822</ApptId><TransactionIds></TransactionIds><CardType></CardType><CheckId></CheckId><ClientAddress>portalserver</ClientAddress><RBAStartDate></RBAStartDate><UserID>hxadmin01</UserID><RBASREASON></RBASREASON><ApptType></ApptType><AvailableRegCount></AvailableRegCount><Method></Method><BankCode></BankCode><PaymentMode></PaymentMode><PaymentFee></PaymentFee><RefundType>WEBBANK</RefundType><AccStartDate></AccStartDate><AccStartHour></AccStartHour><AccStartMinute></AccStartMinute><AccEndDate></AccEndDate><AccEndHour></AccEndHour><AccEndMinute></AccEndMinute><AccType></AccType><RefundFee>0</RefundFee></Request>")
	;w ##class(dhcinterface.TeleReg).SearchRefundRegistration("<Request><TransactionId>1</TransactionId><ApptId>614935827628</ApptId><Method>WEB</Method><UserID>23</UserID></Request>")
	;w ##class(dhcinterface.TeleReg).checkUserInfo("<Request><PatientCard>1</PatientCard></Request>")
	;w ##class(dhcinterface.TeleReg).GetWorkInfo(60858,60860)
	;w ##class(dhcinterface.TeleReg).notifyChangeWork("1103||9","1103||9")
	;w ##class(dhcinterface.TeleReg).getBulletinInfo("")
	;w ##class(dhcinterface.TeleReg).GetCheckInfo(60858)
	;w ##class(dhcinterface.TeleReg).SendCheckInAccountInfo(60858),!
}

ClassMethod writeLog(Mode As %String, TransactionId As %String, TransactionType As %String, RequestMsg As %String, ResponseMsg As %String, Status As %Integer, Type As %String, ErrorMsg As %String)
{
	;w Mode,":",RequestMsg,ResponseMsg,!
	//set ^ozrtest(1)="conform1:"_Mode_"^"_TransactionId_"^"_RequestMsg_"^"_"^"_
	if (Mode="Insert")
	{
	  	set InvokeId=##class(web.DHCTeleTransaction).Insert(TransactionId,TransactionType,RequestMsg,ResponseMsg,Status,Type,ErrorMsg)
	}
	else 
	{
		set InvokeId=##class(web.DHCTeleTransaction).Update(TransactionId,RequestMsg,ResponseMsg,Status,ErrorMsg)
	}
	
	quit InvokeId
}

ClassMethod GetHospitalIDByCode(HospitalCode As %String = "") As %String
{
	set HospitalID=""
	quit:HospitalCode="" HospitalID
	set Today=+$H
	set APPTBSRowId=""
	while ($order(^PAC("APPTBS",0,"Code",$$ALPHAUP^SSUTIL4(HospitalCode),APPTBSRowId))'="")
	{
		set APPTBSRowId=$order(^PAC("APPTBS",0,"Code",$$ALPHAUP^SSUTIL4(HospitalCode),APPTBSRowId))
		set DateFrom=$piece($get(^PAC("APPTBS",APPTBSRowId)),"^",4)
		set DateTo=$piece($get(^PAC("APPTBS",APPTBSRowId)),"^",5)
		if ((DateFrom'="")&&(DateFrom>Today)) continue
		if ((DateTo'="")&&(DateTo<Today)) continue
		set HospitalID=APPTBSRowId
		
	}
	quit HospitalID
}

}
