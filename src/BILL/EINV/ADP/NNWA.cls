Class BILL.EINV.ADP.NNWA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：guoyunlong  2021-04-10
/// 其    他：w ##class(BILL.EINV.ADP.NNWA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
    s $zt="Invoice"
	;s StatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据流水号查询是否存在已经已经开具的电子票据
	;q:StatusRtn="0" RtnFlag  ;存在的开具记录的时 获取结果直接返回
	
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s ServiceCode="issueEInvoiceRecord.do"		;服务名称
	s ResOutput=""   ; ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.NNWA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用富深http接口
	s ObjJsonStream=##class(%GlobalBinaryStream).%New()
	s JsonStr={}.%FromJSON(ResOutput)
	s code=JsonStr.code
	if (code="0"){
	  s resultdata=JsonStr.data
	  s ObjInvUpDetail.IUDBillBatchCode=resultdata.%GetAt(0).einvoiceCode    ;电子票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=resultdata.%GetAt(0).einvoiceNumber    ;电子票据号码
	  s ObjInvUpDetail.IUDCheckCode=resultdata.%GetAt(0).randomNumber      ;电子校验码
	  s ObjInvUpDetail.IUDDate=resultdata.%GetAt(0).issueDate              ;开票日期
	  s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取开票状态信息
	  s:InvStatusRtn'="0" RtnFlag="0"
	  s Errmsg="电子发票开票成功！查询票据信息失败"
	}else{ 
	   //;为开票失败或异常，不能进行后续的开票状态查询。
	   s Errmsg="电子票据开具失败！"
	   s RtnFlag="-1"
	}	
		
	q RtnFlag
Invoice
    s RtnFlag="-1"
    q RtnFlag
}

/// 功能说明：整理电子票据开具组织入参(住院、门诊公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
/// 修改履历：guoyunlong 2021-04-10
/// 其    他：w ##class(BILL.EINV.ADP.NNWA).InvoiceCom("","","","1") 
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
     //票据信息
     s billcode=""
     i ObjInvUpDetail.IUDPayAdmType="OP" d
     .s billcode="0601"
     i ObjInvUpDetail.IUDPayAdmType="IP" d
     .s billcode="0602"
     i ObjInvUpDetail.IUDPayAdmType="DEP" d
     .s billcode="0609"
      
	s invobj=##class(BILL.EINV.DTO.NNWA.EInvoiceReq).%New()
	s invobj.bizCode=ObjInvUpDetail.IUDBusNo						;业务流水号
	s invobj.classCode=billcode     ;票据种类代码  门诊：0601,住院：0602  预缴金：0609
    s invobj.relatedType="1"    ;1：普通票 2：红冲票
    if ObjInvUpDetail.OriInvUpDetail.IUDBatchNo'="" d
    .s invobj.relatedType="2"
    s invobj.invoicingPartyCode=""    ;开票单位代码	String	30	开票单位社会信用代码
    s invobj.invoicingPartyName=""    ;开票单位名称	String	100
    s invobj.placeCode=""     ;开票点编号	String	20	如果是多院区，此处为院区编号，如果冲红，此项可为空
    s invobj.recName=ObjInvPrtInfo.BusUserDesc      ;收款人名称	String	100
    s invobj.handlingPerson=ObjInvPrtInfo.BusUserDesc   ;开票人名称	String	20
    s invobj.checker=ObjInvPrtInfo.BusUserDesc   ;复核人名称	String	20
    s invobj.payerPartyType="1"   ;交款人类型	String	1	1:个人2:单位
    s invobj.payerPartyCode=""  ;交款人代码	String	30	单位为社会信用代码个人一般为身份证号
    s invobj.payerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName   ;交款人名称	String	200
    s invobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex    ;性别	String	2
    s invobj.payerTel=ObjInvPrtInfo.PatBaseInfo.Mobphone  ;交款人手机号	String	20	用于电子票据短信通知
    s invobj.payerEmail=ObjInvPrtInfo.PatBaseInfo.PatEmail   ;交款人邮箱	String	100
    s invobj.cardType=ObjInvPrtInfo.PatBaseInfo.CardType   ;卡类型	String	2	缴费时使用的卡类型 01：就诊卡 02：社保卡 03：户口簿 99：其他
    s invobj.cardNo=ObjInvPrtInfo.PatBaseInfo.CardNo    ;卡号	String	50	卡类型对应的卡号
    s invobj.address=ObjInvPrtInfo.PatBaseInfo.Address  ;地址	String	200	
    s invobj.totalAmount=ObjInvPrtInfo.InvShareAmt  ;总金额	Currency
    s invobj.payMode="1"     ;测试暂时用现金   ;1：现金；2：银行卡；3：支付宝；4：微信；9：其他
    s invobj.payerAcct=""   ;交款人账号	String	50	银行卡支付为银行账号，支付宝支付为UserID，微信支付时为支付订单号
    s invobj.payerOpbk=""   ;交款人开户行	String	100	银行卡支付时填写
    s invobj.businessNumber=ObjInvUpDetail.IUDBusNo  ;业务单号	String	32	在HIS系统中的交易单号，同一单开多张票单号相同
    s invobj.businessDate=$tr($zd(+$h,3),"-","")   ;业务日期	Date
    ///门诊信息
    s ObjPatieentObj=##class(BILL.EINV.DTO.NNWA.EInvPatientData).%New()
    s ObjPatieentObj.patientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo   ;门诊号	String	30	
    s ObjPatieentObj.medicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate   ;就诊日期	Date
    s ObjPatieentObj.caseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode  ;病例号	String	50	病历号
    s ObjPatieentObj.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc  ;科室名称	String	50
    s ObjPatieentObj.departmentCode=ObjInvPrtInfo.PatAdmInfo.DepCode  ;科室编号	String	50
    s ObjPatieentObj.orgType=""   ;医疗机构类型
    s ObjPatieentObj.medicalInsuranceType=""  ;医保类型	String	30
    s ObjPatieentObj.medicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId  ;医保编号	String	30	参保人在医保系统中的唯一标识（医保号）
    s ObjPatieentObj.fundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0  ;医保统筹基金支付
    s ObjPatieentObj.otherPayAmount="" ;ObjInvPrtInfo.InsuDivInfo  ;其他支付
    s ObjPatieentObj.accountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0  ;个人账户支付
    s ObjPatieentObj.ownPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0  ;;个人现金支付
    s ObjPatieentObj.selfpaymentAmount=ObjInvPrtInfo.InsuDivInfo.SelfAmt  ;个人自付
    s ObjPatieentObj.selfpaymentCost=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt  ;个人自费
    s invobj.patient=ObjPatieentObj    ;门诊票据
    
    ///住院信息
    s ObjHospitalObj=##class(BILL.EINV.DTO.NNWA.EInvHospitalData).%New()
    s ObjHospitalObj.orgType=""   ;医疗机构类型	String	30	
    s ObjHospitalObj.medicalInsuranceType=""  ;医保类型
    s ObjHospitalObj.medicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId   ;医保编号
    s ObjHospitalObj.fundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0   ;医保统筹基金支付
    s ObjHospitalObj.otherPayAmount=""   ;其他支付
    s ObjHospitalObj.accountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0  ;个人账户支付
    s ObjHospitalObj.ownPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0  ;个人现金支付
    s ObjHospitalObj.selfpaymentAmount=ObjInvPrtInfo.InsuDivInfo.SelfAmt   ;个人自付
    s ObjHospitalObj.selfpaymentCost=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt   ;个人自费
    s ObjHospitalObj.caseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode   ;病例号
    s ObjHospitalObj.hospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.IPNo  ;住院号
    s ObjHospitalObj.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc  ;科室名称
    s ObjHospitalObj.departmentCode=ObjInvPrtInfo.PatAdmInfo.DepCode  ;科室编号
    s ObjHospitalObj.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate  ;住院日期
    s ObjHospitalObj.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate  ;出院日期
    s ObjHospitalObj.prepayAmount=ObjInvPrtInfo.RecAmt   ;预缴金额
    s ObjHospitalObj.rechargeAmount=ObjInvPrtInfo.RefAmt  ;补缴金额
    s ObjHospitalObj.refundAmount=""	;退费金额
    
    ///住院关联的预交金信息列表
    s ObjPrepayObj=##class(BILL.EINV.DTO.NNWA.EInvPrepayData).%New()
    s ObjPrepayObj.prepayBizCode=""   ;预缴金业务流水号
    s ObjPrepayObj.prepayCode=""   ;预缴金票据代码
    s ObjPrepayObj.prepayNumber=""  ;预缴金票据号码
    s ObjHospitalObj.prepayItem=ObjPrepayObj
    

	//项目信息
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size d
	.s detailslistobj=##class(BILL.EINV.DTO.NNWA.EInvItemData).%New()
	.s detailslistobj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code		;项目编码
	.s detailslistobj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc		;项目名称
	.s detailslistobj.itemQuantity="" 										;数量
	.s detailslistobj.itemUnit=""											;单位
	.s detailslistobj.itemAmount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	.s detailslistobj.itemRemark=""											;项目备注
	.d invobj.details.Insert(detailslistobj)
	
	//项目清单
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s auxdetailslistobj=##class(BILL.EINV.DTO.NNWA.EInvAuxItemData).%New()
	.s auxdetailslistobj.auxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;对应项目编码
	.s auxdetailslistobj.auxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;对应项目名称
	.s auxdetailslistobj.auxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;收费明细项目编码
	.s auxdetailslistobj.auxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;收费明细项目名称
	.s auxdetailslistobj.auxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	.s auxdetailslistobj.auxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	.s auxdetailslistobj.auxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	.s auxdetailslistobj.auxItemRemark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark		;收费明细项目备注
	.d invobj.auxdetails.Insert(auxdetailslistobj)
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong  2021-04-10
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"	
	s InputJson="{""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_"}"		;流水号 
	s ServiceCode="queryEInvoiceRecord.do"                      ;接口服务名称
	s ReqJsonStr=InputJson										;业务入参
	
	s ResOutput=""    ;##class(BILL.EINV.DTO.FSA.EInvoiceRes).%New()    ;接收返回
	//调用诺诺网接口
	s SRVRtnFlg=##class(BILL.EINV.BI.NNWA.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonStr, InvociePam, .ResOutput)
	//获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg>0){
		s state=ResOutput.data.state  ;开票状态 1成功，0失败
		if (state="1") {
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.einvoicecode       ;电子票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.einvoicenumber       ;电子票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.randomnumber           ;校验码
			s ObjInvUpDetail.IUDBillBatchStatus=state                           ;开票状态 1成功，0失败
			s ObjInvUpDetail.Xstr1=ResOutput.data.einvoiceid                    ;电子票据ID
			s ObjInvUpDetail.Xstr2=ResOutput.data.einvoicefilename              ;电子票据文件名称
			s ObjInvUpDetail.Xstr3=ResOutput.data.bizcode                       ;业务流水号(服务商返回的)
			
			s NowDateTimeStr=$h
			s iNowDate=$p(NowDateTimeStr, ",", 1)
			s iNowTime=$p(NowDateTimeStr, ",", 2)
			s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			
			s RtnFlag="0"
		}else{
			s tmpErrMsg=ResOutput.msg
			s:tmpErrMsg="" tmpErrMsg="获取开票状态信息为失败状态["_state_"]"
			s InvociePam.ErrMsgInfo=tmpErrMsg	
		}
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="查询开票结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	
	
	q RtnFlag
}

}
