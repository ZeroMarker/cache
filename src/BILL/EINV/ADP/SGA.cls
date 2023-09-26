/// 税歌电子发票参数组织
Class BILL.EINV.ADP.SGA Extends %RegisteredObject
{

/// 电子发票开具接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).Invoice开始")
	;kais
	s RtnFlag="0"
	b	;根据流水号查询是否存在已经已经开具的电子票据
	s StatusRtn=..GetEINVResultByBusNo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  
	B ;StatusRtn返回开票状态开票状态（1：普通 2：作废 3：换开）
	q:(StatusRtn="1")||(StatusRtn="3") RtnFlag  ;存在正常的开具记录的时获取结果直接返回
	
	s InputJson=..EInvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)  ;组织票据开具参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	b ;InputJson
	
	s ServiceCode="einvoices"		;服务名称
	s ResOutput= ##class(BILL.EINV.DTO.SGA.EInvStatusRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)	;调用税歌http接口
	b ;;发票开具成功 
	i SRVRtnFlg="0" d 
	.; 由于税歌的开具接口和返回结果是异步的，这儿改下，延时请求返回结果 ，
	.s MaxRequestNum=6 ;最大请求次数
	.s RequstTime=0.1   ;请求时间 /每隔几秒请求一次 使用等比法 即 0 0.1 0.2 0.4 0.8 1.6 
	.s SleepTime=0      ;延时时间
	.s InvStatusRtn="-1" ;返回结果
	.f requestIndex=1:1:MaxRequestNum  q:(+InvStatusRtn=1)||(+InvStatusRtn=2)||(+InvStatusRtn=3)  d
	..i requestIndex="1" s SleepTime=0
	..e  s SleepTime = RequstTime*(2**(requestIndex-2))  
	..HANG SleepTime  ;等待延时  
	..b ;  invoice  GetEINVResultByBusNo      
	..s InvStatusRtn=..GetEINVResultByBusNo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;
	..;s:InvStatusRtn'="0" RtnFlag="-1"
	.i (+InvStatusRtn'=1)&&(+InvStatusRtn'=2)&&(+InvStatusRtn'=3) d      ;开具成功，但是查询失败情况下也需要保存。
	..;s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	..;s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
	..;s ObjInvUpDetail.EInvFlg="I"	
	..s ObjInvUpDetail.Xstr5=ResOutput.data.acceptId       				;受理代码
								   ;发票状态
	e  d  ;为开票失败或异常，不能进行后续的开票状态查询。
	.s RtnFlag="-1"
	.s InvociePam.ErrMsgInfo=ResOutput.msg
	q RtnFlag
}

/// 功能描述：电子发票红冲接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	b ;Invalid
	;根据流水号查询是否存在已经已经开具的电子票据
	s ObjInvUpDetail.IUDBusNo=ObjInvUpDetail.OriInvUpDetail.IUDBusNo  //作废是业务流水号使用原业务流水号
	s StatusRtn=..GetEINVResultByBusNo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  
	;StatusRtn返回开票状态开票状态（1：普通 2：作废 3：换开）
	q:StatusRtn="2" RtnFlag  ;存在作废的开具记录的时获取结果直接返回
	;s InputJson=..EInvalid(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	;组织红冲参数
	s timestamp=$replace($zd(+$h,3),"-","")_$replace($zt($p($h,",",2),1),":","")
	;s InputJson="{""institutionCode"":"""_InvociePam.HospitalInfoMap.GetAt("HospitalNo")_""","_"""einvoiceNo"":"""_ObjInvUpDetail.IUDBusNo_""","_"""einvoiceCode"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_""","_"""einvoiceNumber"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo_"""}"		;流水号
	;s InputJson="institutionCode="_InvociePam.ObjUPConfig.HospitalNo_"&einvoiceNo="_ObjInvUpDetail.IUDBusNo		;流水号
	s InputJson=##class(%DynamicObject).%New()
	s InputJson.institutionCode=InvociePam.HospitalInfoMap.GetAt("HospitalNo")    ;单位代码（系统分配）
	s InputJson.einvoiceNo=ObjInvUpDetail.OriInvUpDetail.IUDBusNo                   ;被冲红票据流水号（原票流水号）
	s InputJson.einvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode                                     ;被冲红票据代码
	s InputJson.issueEinvoiceNo=ObjInvUpDetail.IUDBusNo                                    ;红票流水号（等同票据流水号，且互不重复）
	s InputJson.issueEinvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;红票票据代码
	s InputJson.issueRemark="患者要求"                                       ;冲红原因
	s InputJson.issueEinvoiceNumber=""                               ;红票票据号码（his自己管理票据号码的，需要消耗一个票据号）
	s InputJson=InputJson.%ToJSON()
	s ServiceCode="einvoices/cancel"
	s ResOutput=##class(BILL.EINV.DTO.SGA.EInvStatusRes).%New()    ;接收返回
	//调用税歌http接口
	 b ;calnel
	;业务入参
	s lnvalidFlag=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,InvociePam,.ResOutput)
	b ;;作废成功后，调用查询交易查询
	if (lnvalidFlag="0") d
	  	.;s StatusRtn=..GetEINVResultByBusNo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam) 
		.;StatusRtn返回开票状态开票状态（1：普通 2：作废 3：换开）
		.;s:StatusRtn'="2" RtnFlag="-1"
	  	.; 由于税歌的开具接口和返回结果是异步的，这儿改下，延时请求返回结果 ，
		.s MaxRequestNum=6 ;最大请求次数
		.s RequstTime=0.1   ;请求时间 /每隔几秒请求一次 使用等比法 即 0 0.1 0.2 0.4 0.8 1.6 
		.s SleepTime=0      ;延时时间
		.s StatusRtn="-1" ;返回结果
		.f requestIndex=1:1:MaxRequestNum q:+StatusRtn=2  d
		..i requestIndex="1" s SleepTime=0
		..e  s SleepTime = RequstTime*(2**(requestIndex-2))  
		..HANG SleepTime  ;等待延时 
		..b ; HANG         
		..s StatusRtn=..GetEINVResultByBusNo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;
		..;s:InvStatusRtn'="0" RtnFlag="-1"
		.i +StatusRtn'=2 d      ;作废成功，但是查询失败情况下也需要保存。
		..s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
		..s ObjInvUpDetail.IUDResultMeg="冲红成功"   						   ;查询状态 信息是否成功
		..s ObjInvUpDetail.EInvFlg="S"	
		..s ObjInvUpDetail.Xstr5=ResOutput.data.acceptId       				;受理代码  
	e  d  ;为冲红失败或异常，不能进行后续的状态查询。
	.s RtnFlag="-1"
	q RtnFlag
}

/// 功能说明：整理电子票据冲红入参组织(门诊、住院公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：guoyunlong  20200414  新做成
/// 其    他：w ##class(BILL.EINV.ADP.SGA).EInvoiceCom("","","") 
ClassMethod EInvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;注意  所有非必填字段不能穿空字符串"",要传null 
	set rtn=""
	//票据信息
	set PayAdmType=ObjInvUpDetail.IUDPayAdmType
	set invobj=##class(BILL.EINV.DTO.SGA.EInvoiceReq).%New()
	set invobj.einvoiceNo=ObjInvUpDetail.IUDBusNo      		 ;业务流水号
	set invobj.einvoiceType=$case(PayAdmType,"OP":"330601","REG":"330601","IP":"330602")	 ;票据代码类型
	set invobj.einvoiceCode=invobj.einvoiceType_$E($zd(+$h,3),3,4)   ;票据代码 票据种类+年后两位
	set invobj.einvoiceNumber=""	                            ;票据号码								      				     ;票据号码  先传成""
	set invobj.opeType="1"                                    ;处理类型 ：1 正常            
	set invobj.totalAmount=ObjInvPrtInfo.InvAmt   		;开票总金额
	
	b ;单位代码（系统分配）？？？？ 是否做成配置
	set invobj.institutionCode= InvociePam.HospitalInfoMap.GetAt("HospitalNo")    ;InvociePam.ObjUPConfig.HospitalNo  ;改成配置
	set invobj.recName=InvociePam.UserDesc   	 		 ;收费员
	set invobj.recAcct=InvociePam.UserCode				 ;收款人账号
	set invobj.payerPartyType="1"									//交款人类型(固定1)
	set invobj.payerPartyCode=ObjInvPrtInfo.PatBaseInfo.PAPMINO 		//交款人代码
	set invobj.payerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName 		//交款人全称
	set invobj.payerPartyAcct=ObjInvPrtInfo.PatBaseInfo.Mobphone  	//交款人账号(手机号)
	set invobj.payerPartyOpBank=""									//交款人开户行
	set invobj.handlingPerson=InvociePam.UserDesc					//开票人(默认是系统)
	set invobj.checker=InvociePam.UserDesc							//复核人
	set invobj.medicalNo=ObjInvPrtInfo.PatBaseInfo.PAPMINO		//病例号   ;门诊病人没有病历号 取登记号
	set invobj.medicalCardNo=ObjInvPrtInfo.PatBaseInfo.CardNo	    //就诊卡号(健康卡号)
	if ObjInvPrtInfo.PatBaseInfo.CardType="06" s invobj.medicalCardNo="3160"_$e(invobj.medicalCardNo,5,$l(invobj.medicalCardNo))  //群岛通卡 前面4位需要改成3160，医生站建卡处理问题
	set invobj.issueDate=$zd(+$h,3)									//开票日期
	set invobj.issueTimeStr=$zt($P($h,",",2))						//开票时间
	;自费患者自费总金额=发票总金额
	;医保患者自费总金额=发票总金额-基金支付金额 ，测试时候和第三方确认一下
	set invobj.totalAmountSelf= $fn(ObjInvPrtInfo.InvShareAmt,"",2)
	if ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'="" d 
	.set invobj.totalAmountSelf=$fn(ObjInvPrtInfo.InvShareAmt-ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0,"",2)	//自费总金额
	;测试时候和医院核实医疗结构类型 也取配置
	set invobj.medicalType=	##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("HospitalNoSet", ObjInvPrtInfo.PrtHospDr,7)     ;核实医疗结构类型 取配置
	    
	set invobj.idCardNo=ObjInvPrtInfo.PatBaseInfo.PatID				//身份证
	set invobj.patientName=	ObjInvPrtInfo.PatBaseInfo.PatName		//病人名称
	set invobj.patientGender=ObjInvPrtInfo.PatBaseInfo.Sex			//病人性别
	set invobj.patientMedicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc 		//病人医保类型
	set:invobj.patientMedicalInsuranceType="" invobj.patientMedicalInsuranceType="自费" //非空字段
	;病人社会保障号码(区别于ssnNo，patientSsn打印于票上，可以做隐蔽处理)
	set invobj.patientSsn=ObjInvPrtInfo.PatBaseInfo.PatID	    //病人社会保障号码 ;税歌都穿身份证号
	;社保卡号取医保登记表卡卡号。
	set invobj.ssnNo=ObjInvPrtInfo.PatBaseInfo.PatID					//社保卡号 ;税歌都穿身份证号
	set invobj.patientCompany=ObjInvPrtInfo.InsuDivInfo.InsuAddress  //病人工作单位
	set:invobj.patientCompany="" invobj.patientCompany=ObjInvPrtInfo.PatBaseInfo.Address		//病人工作单位
	
	set invobj.section=ObjInvPrtInfo.PatAdmInfo.DepDesc				//科别
	set invobj.patientTreatmentStartDate=ObjInvPrtInfo.PatAdmInfo.AdmDate					//病人治疗起始日期(YYYY-MM-DD)
	set invobj.patientTreatmentEndDate=	ObjInvPrtInfo.PatAdmInfo.OutDate						//病人治疗结束日期(YYYY-MM-DD)
	set invobj.admissionNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode									//病人住院号
	set:invobj.admissionNumber="" invobj.admissionNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo   //控制住院号不能为空
	set invobj.prepaidFunds=ObjInvPrtInfo.DepositAmt				//预交款
	set invobj.additionalPayment=ObjInvPrtInfo.RecAmt				//补缴
	set invobj.additionalCashPayment=0								//补缴现金
	set invobj.additionalCheckPayment=0								//补缴支票
	set invobj.refunds=ObjInvPrtInfo.RefAmt								//退款
	set invobj.refundsCash=0											//退款现金
	set invobj.payee=""												//领款人
	set invobj.cashOrCheck=	$fn(ObjInvPrtInfo.InvShareAmt-ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0-ObjInvPrtInfo.DiscAmt	,"",2)	    //现金(支票)  这儿要处理下，否则账面不平										
	set invobj.allAmountCn=##class(web.UDHCOPINVPrtIF).RMBConvert(ObjInvPrtInfo.InvShareAmt)		//合计金额(大写)											
	set invobj.allAmount=ObjInvPrtInfo.InvShareAmt					//合计金额
	set invobj.invoicingPartyName=""							//开票方单位名称
	set invobj.healthCareAccountPayment=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0-ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0		//改成基金支付-	账户支付  原因医保结算存储没做处理
	set invobj.individualAccountCurrPayment=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo,"^",1),"",2)					//个人账户_本年支付  ;先默认为0，项目上修改
	set invobj.individualAccountCurrBalance=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo,"^",2),"",2)					//个人账户_本年余额 先默认为0，项目上修改
	set invobj.individualAccountPrevPayment=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo,"^",3),"",2)					//个人账户_历年支付 先默认为0，项目上修改
	set invobj.individualAccountPrevBalance=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo,"^",4),"",2)					//个人账户_历年余额 先默认为0，项目上修改
	set invobj.cashPayment=""								//现金支付信息
	set invobj.healthCareAccount=""						        //医保支付信息
	
	//现金支付明细 医保支付明细
	f i=1:1:ObjInvPrtInfo.PayModeInfo.Size  d
	.set payChobj=##class(BILL.EINV.DTO.SGA.CashPayList).%New()
	.set PayCode=ObjInvPrtInfo.PayModeInfo.GetAt(i).Code  //支付方式code
	.i (PayCode'["INSU")&&(PayCode'["YB") d  ;不包含医保则认为是现金结
	..set payChobj.cashPayName=ObjInvPrtInfo.PayModeInfo.GetAt(i).Desc			;支付方式名称
	..set payChobj.cashPayAmount=$fn(ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt,"",2) ;支付金额
	..i payChobj.cashPayAmount>0 d ;只上传非0金额
	...i invobj.cashPayment="" s invobj.cashPayment=payChobj.cashPayName_":"_payChobj.cashPayAmount 
	...e  set invobj.cashPayment=invobj.cashPayment_","_payChobj.cashPayName_":"_payChobj.cashPayAmount  //现金支付信息拼串
	...d invobj.cashPayDetails.Insert(payChobj)
	.e  d  //医保支付明细
	..set INSYPayobj=##class(BILL.EINV.DTO.SGA.INSUPayList).%New()
    ..set INSYPayobj.accountPayName=ObjInvPrtInfo.PayModeInfo.GetAt(i).Desc			;支付方式名称
    ..set INSYPayobj.accountPayAmount=$fn(ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt,"",2) ;支付金额
	..i INSYPayobj.accountPayAmount>0 d ;只上传非0金额
	...i invobj.healthCareAccount="" s invobj.healthCareAccount=INSYPayobj.accountPayName_":"_INSYPayobj.accountPayAmount 
	...e  set invobj.healthCareAccount=invobj.healthCareAccount_","_INSYPayobj.accountPayName_":"_INSYPayobj.accountPayAmount   //医保支付信息拼串
	...d invobj.accountPayDetail.Insert(INSYPayobj)

	//"healthCareAccount": "基金支付:0.00本次起付标准:0.00起付标准累计:0.00自费:0.00(其中历年帐户:0.00)自理:2.29( 其中历年帐户:2.29)自负:0.00(其中历年帐户:0.00)<普通>",
	;set invobj.healthCareAccount="基金支付："_ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0_","_"账户支付："_ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0_","_"统筹支付："_ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1_"大额支付："_ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2_","_"公务员补充支付："_ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3
	;set invobj.healthCareAccount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)
	;invobj.healthCareAccount123
	if (+ObjInvPrtInfo.DiscAmt>0)&&(PayAdmType'="IP") d
    .i invobj.healthCareAccount="" s invobj.healthCareAccount="惠民支付："_$fn(ObjInvPrtInfo.InvAmt-ObjInvPrtInfo.InvShareAmt,"",2)
	.e  s invobj.healthCareAccount=invobj.healthCareAccount_","_"惠民支付："_ObjInvPrtInfo.DiscAmt

	 ;院区编码  (需要医院预先在院区页面自行增加)  ;是否做配置
	set invobj.affiliatedAreaCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("HospitalNoSet", ObjInvPrtInfo.PrtHospDr,5)     ;院区编码 取配置
	set invobj.visitNo=ObjInvPrtInfo.PatAdmInfo.AdmNo  					   ;就诊号
    set invobj.visitDeptName=ObjInvPrtInfo.PatAdmInfo.DepDesc                ;就诊科室
	set invobj.totalBalance=ObjInvPrtInfo.InvShareAmt                             ;结算合计

	set invobj.remark="" //备注
	set invobj.remarkName1=""										//备注名1
	set invobj.remarkContent1=""									//备注内容1
	if PayAdmType="IP"	d 
	.s invobj.remark= $p(ObjInvPrtInfo.InsuDivInfo.OtherInsuInfo,"!",2)							
	if (+ObjInvPrtInfo.DiscAmt>0)&&(PayAdmType="IP") d
    .s invobj.remarkName1="免费金额"
    .set invobj.remarkName1=ObjInvPrtInfo.DiscAmt
	b ;invobj.healthCareAccount
	set invobj.remarkName2=""										//备注名2
	set invobj.remarkContent2=""									//备注内容2
	set invobj.remarkName3=""										//备注名3
	set invobj.remarkContent3=""									//备注内容3
	set invobj.remarkName4=""										//备注名4
	set invobj.remarkContent4=""									//备注内容4
	set invobj.remarkName5=""										//备注名5
	set invobj.remarkContent5=""									//备注内容5
	
	//发票费用分类  门诊传明细，住院传大类
	if (PayAdmType="IP"){
		s No=1
		s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo,InvociePam.ObjUPConfig, "IP")
		f num=1:1:$l(FeeConStr,",") d
		.s detailObj=##class(BILL.EINV.DTO.SGA.EInvDetailList).%New()
		.s CatFeeInfo=$p(FeeConStr,",",num)       ;费用分类编码
		.set detailObj.itemName=$p(CatFeeInfo,"^",2)        //药品名称
	    .set detailObj.itemCode=$p(CatFeeInfo,"^",1)
	    .set detailObj.itemAmount=$p(CatFeeInfo,"^",3)							//项目金额
	    .set detailObj.itemUnit=""									//项目单位
	    .set detailObj.itemQuantity=""							//项目数量
	    .set detailObj.itemStd=""										//项目标准(规格)
	    .set detailObj.itemType=""									//项目种类
	    .set detailObj.itemAmountSelf="0"                    //自费金额
	    .set detailObj.itemAmountPercent=""					//自费比例
	    .set detailObj.itemAmountType=$p(CatFeeInfo,"^",1)         ;费用分类编码   需要对照						//收费类别 不需要传
	    .set detailObj.itemPrice=""									//项目单价
	    .set detailObj.itemGrp="1"
	    .set detailObj.itemRemark="1"	
	    .do invobj.items.Insert(detailObj)				
	    .s No=No+1
	}else {   //门诊传费用明细
	    s No=1
	    f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	    .set detailObj=##class(BILL.EINV.DTO.SGA.EInvDetailList).%New()
	    .set detailObj.itemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc        //药品名称
	    .set detailObj.itemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode 		//项目编码	 需要对照
	    .set detailObj.itemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt								//项目金额
	    .set detailObj.itemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit									//项目单位
	    .set detailObj.itemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty							//项目数量
	    .set detailObj.itemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec										//项目标准(规格)
	    .set detailObj.itemType=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Insutjdm									//项目种类  （"必选项"，医保等级 甲乙丙 ，必填）
	    .set detailObj.itemAmountSelf=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SelfAmt   //自费费用
	    .set detailObj.itemAmountPercent="100"                           //自费比例
	    .set detailObj.itemAmountPercent=(1-ObjInvPrtInfo.InvItmDetInfo.GetAt(i).InsuScale)*100					//自费比例

	    .;if ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc="" s detailObj.itemAmountPercent="100"	//病人医保类型为空，自费100%
	    .;set detailObj.itemAmountType=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc         ;费用分类编码   需要对照						//收费类别 不需要传
        .set detailObj.itemAmountType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConSG",ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc,5)
	    . ;ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc
	    .set detailObj.itemPrice=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price //项目单价
	    .set detailObj.itemGrp=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConSG",ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc,5)
	    .set detailObj.itemRemark="1"			
	    .do invobj.items.Insert(detailObj)				
	    .s No=No+1	
	    
	    s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo,InvociePam.ObjUPConfig, "OP")
		;FeeConStr
		f num=1:1:$l(FeeConStr,",") d
		.s detailObj=##class(BILL.EINV.DTO.SGA.EInvDetailList).%New()
		.s CatFeeInfo=$p(FeeConStr,",",num)       ;费用分类编码
		.set detailObj.itemName=$p(CatFeeInfo,"^",2)        //药品名称
	    .set detailObj.itemCode=$p(CatFeeInfo,"^",1)
	    .set detailObj.itemAmount=$p(CatFeeInfo,"^",3)							//项目金额
	    .set detailObj.itemUnit=""									//项目单位
	    .set detailObj.itemQuantity=""							//项目数量
	    .set detailObj.itemStd=""										//项目标准(规格)
	    .set detailObj.itemType=""									//项目种类
	    .set detailObj.itemAmountSelf="0"                    //自费金额
	    .set detailObj.itemAmountPercent=""					//自费比例
	    .set detailObj.itemAmountType=$p(CatFeeInfo,"^",1)         ;费用分类编码   需要对照						//收费类别 不需要传
	    .set detailObj.itemPrice=""									//项目单价
	    .set detailObj.itemGrp=$p(CatFeeInfo,"^",1)	
	    .do invobj.items.Insert(detailObj)		
	}
	////add  2021-12-30
	s invobj.payMode=""
	s invobj.currencyType=""
	s invobj.exchangeRate=""
	s invobj.supervisorRemark=""
	s invobj.phoneNumber=ObjInvPrtInfo.PatBaseInfo.Mobphone
	s invobj.bedNo=ObjInvPrtInfo.PatAdmInfo.BedCode
	s MainExtobj=##class(BILL.EINV.DTO.SGA.MainExt).%New()
	s MainExtobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex
	s MainExtobj.age=ObjInvPrtInfo.PatBaseInfo.Age
	s MainExtobj.medicalType=""    ;医疗类别
	s MainExtobj.patientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo
	s MainExtobj.medicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate
	s MainExtobj.orgType=""
	s MainExtobj.medicalInsuranceType=""
	s MainExtobj.medicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId
	s MainExtobj.fundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1
	s MainExtobj.fundPayAmountInfo=""
	s MainExtobj.fundDJJZAmount=""
	s MainExtobj.fundDJJZAmountInfo=""
	s MainExtobj.otherPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0-ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1
	s MainExtobj.otherPayAmountInfo=""
	s MainExtobj.accountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0
	s MainExtobj.ownPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0
	s MainExtobj.ownPayAmountInfo=""
	s MainExtobj.selfpaymentAmount=""
	s MainExtobj.selfpaymentCost=""
	s MainExtobj.selfpaymentCare=""
	s MainExtobj.caseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode
	s MainExtobj.hospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.IPNo
	s MainExtobj.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc
	s MainExtobj.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate
	s MainExtobj.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate
	s MainExtobj.prepayAmount=ObjInvPrtInfo.DepositAmt
	s MainExtobj.rechargeAmount=ObjInvPrtInfo.RecAmt
	s MainExtobj.refundAmount=ObjInvPrtInfo.RefAmt
	s MainExtobj.payCode=""
	
	s Blamesobj=##class(BILL.EINV.DTO.SGA.Blames).%New()
	s Blamesobj.bName=""
	s Blamesobj.claimAmount=""
	s Blamesobj.deductibleAmount=""
	s Blamesobj.accumulatedAmount=""
	do MainExtobj.blames.Insert(Blamesobj)
	
	s DiagnosisListobj=##class(BILL.EINV.DTO.SGA.DiagnosisList).%New()
	s DiagnosisListobj.diagnosisCode=""
	s DiagnosisListobj.diagnosisName=""
	do MainExtobj.diagnosisList.Insert(Blamesobj)
	s invobj.mainExt=MainExtobj
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

// 组织门诊红冲接口参数

ClassMethod EInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid开始.")
	
	//组织3.1.5	票据作废（通过流水号）入参       单位代码（系统分配,流水号
	//测试时候确认一下流水号是该交易重新生成的流水号，还是原交易的流水号？？
	
	/*
	ObjInvUpDetail.OriInvUpDetail
	*/
	s timestamp=$replace($zd(+$h,,3),"-","")_$replace($zt($p($h,",",2),1),":","")
	s InputJson="{""institutionCode"":"_" "_","_"einvoiceNo"":"_ObjInvUpDetail.OriInvUpDetail.IUDBusNo
	_","_"einvoiceCode"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode
	_","_"issueEinvoiceNo"":"_ObjInvUpDetail.IUDBusNo_","_"issueEinvoiceCode"":"_ObjInvUpDetail.IUDBillBatchCode_","_"issueEinvoiceNumber"":"_ObjInvUpDetail.IUDBatchNo_"}"		;流水号
	
 	;s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	;业务入参
	s ServiceCode="einvoices/cancel"
	s ResOutput=##class(BILL.EINV.DTO.SGA.EInvStatusRes).%New()    ;接收返回
	//调用税歌http接口
	s outData=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequestGet(ServiceCode,InputJson, InvociePam,ResOutput)
	if (outData="0"){
		
		;???   票据作废返回值
		
	}else{
	   s tmpErrMsg=ResOutput.msg
	   s:tmpErrMsg="" tmpErrMsg="票据作废结果失败"
	   s InvociePam.ErrMsgInfo=tmpErrMsg	
		
	}
	
	
	;返回值处理
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvalid结束.Rtn=")
	q Rtn
}

/// 功能说明：开票单位调用发票开具接口（3.1.1）后，可根据开具时提交的票据流水号加单位代码调用本接口查询票据信息，
///           可用于确认票据是否已经开具成功或查看票据代码票据号码打印次数等信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：guoyunlong  2020-04-10
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetEINVResultByBusNo("","","") 
ClassMethod GetEINVResultByBusNo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1",outData="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).GetEINVResultByBusNo开始.")
	
	//组织电子票据开票状况入参       单位代码（系统分配,流水号 维护到医院代码
	;时间戳 公共参数
	s timestamp=$replace($zd(+$h,3),"-","")_$replace($zt($p($h,",",2)),":","")
 
	s InputJson="institutionCode="_InvociePam.HospitalInfoMap.GetAt("HospitalNo")_"&einvoiceNo="_ObjInvUpDetail.IUDBusNo  ;_"&einvoiceNo=null"		;流水号
 	;s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	;业务入参
	s ServiceCode="einvoices"
	s ResOutput=##class(BILL.EINV.DTO.SGA.EInvStatusRes).%New()    ;接收返回
	b ;//调用税歌http接口
	if (ResOutput.code'="OK") d   ;当没有返回的时候才调用查询，原因，税歌的开具 ，冲红 、查询是异步的，开具成功调用查询可能查不到 ，这儿做控制
	.s outData=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequestGet(ServiceCode, InputJson, InvociePam,.ResOutput)
	b ;outData
	  if (outData=0){
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.einvoiceCode       ;票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.einvoiceNumber      ;票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.acceptId              ;受理号码
			s ObjInvUpDetail.IUDBillBatchStatus= ResOutput.data.einvoiceStatus ;开票状态（1：普通 2：作废 3：换开）
			s ObjInvUpDetail.IUDPrintFlag=ResOutput.data.printFlag              ;打印标识（1: 未打印 0：已打印）
			s ObjInvUpDetail.Xstr3=ResOutput.data.einvoiceNo                    ;业务流水号
			s ObjInvUpDetail.Xstr4=ResOutput.data.totalAmount            ;开票金额(是否更新业务表里面的开票金额)
			s ObjInvUpDetail.IUDCreatAmt=ResOutput.data.totalAmount 
			s ObjInvUpDetail.IUDCreatDate=$zdh(ResOutput.data.issueDate,"3"	)					   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=$zth(ResOutput.data.issueTime)							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.Xstr5=ResOutput.data.acceptId       				;受理代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.einvoiceNumber      ;票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.acceptId              ;受理号码
			s ObjInvUpDetail.IUDBillBatchStatus= ResOutput.data.einvoiceStatus ;开票状态（1：普通 2：作废 3：换开）
			s ObjInvUpDetail.IUDPrintFlag=ResOutput.data.printFlag              ;打印标识（1: 未打印 0：已打印）
			s ObjInvUpDetail.Xstr3=ResOutput.data.einvoiceNo                    ;业务流水号
			;s ObjInvUpDetail.Xstr4=ResOutput.data.totalAmount            ;开票金额(是否更新业务表里面的开票金额)
			;s ObjInvUpDetail.IUDCreatAmt=ResOutput.data.totalAmount 
			s ObjInvUpDetail.IUDCreatDate=$zdh(ResOutput.data.issueDate,"3"	)					   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=$zth(ResOutput.data.issueTime)							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			i ResOutput.data.einvoiceStatus="2"  d 					;	如果是作废的情况下
			.s ObjInvUpDetail.IUDResultMeg="冲红成功"   						   ;查询状态 信息是否成功
			.s ObjInvUpDetail.EInvFlg="S"									   ;发票状态
			s RtnFlag="0"
			s RtnFlag=ResOutput.data.einvoiceStatus                            ;通过开票状态 判断
	  }else{
		    s tmpErrMsg=ResOutput.msg
		    s:tmpErrMsg="" tmpErrMsg="查询开票结果失败"
		    s InvociePam.ErrMsgInfo=tmpErrMsg
		
	}
	
	;返回值处理
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).GetEINVResultByBusNo结束.Rtn="_RtnFlag)
	q RtnFlag
}

/// / 电子票据下载 -3.1.7	票据下载
/// 功能说明：用于下载财政电子票据的pdf原件，开票单位如果有自己的手机APP，
///           可以由APP调用本接口获取电子票据原件，用于提供给缴款人在APP中接收查看开给自己的电子票据
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：guoyunlong  2020-04-10
/// 其    他：w ##class(BILL.EINV.ADP.BSA).EInvDownLoad("","","") 
ClassMethod EInvDownLoad(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvDownLoad开始.")
	s timestamp=$replace($zd(+$h,,3),"-","")_$replace($zt($p($h,",",2),1),":","")
	//组织3.1.7	票据下载入参  
	;测试注意流水号是否使用原纪录流水号，还是新流水号    
	;s InputJson="{""institutionCode"":"_" "_","_"einvoiceNo"":"_ObjInvUpDetail.IUDBusNo_","_"einvoiceCode"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_","_"einvoiceNumber"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo_"}"		;流水号
	s InputJson="{""institutionCode"":"_" "_","_"einvoiceNo"":"_ObjInvUpDetail.IUDBusNo_","_"einvoiceCode"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_","_"einvoiceNumber"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo_","_"timestamp"":"_timestamp_"}"		;流水号
 	;s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	;业务入参
	s ServiceCode="file/download"
	//调用税歌http接口
	s outData=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequestGet(ServiceCode, InputJson, InvociePam)
	if (outData="0"){
		
		;???   电子票据下载返回值
		
	}else{
	   s tmpErrMsg=ResOutput.msg
	   s:tmpErrMsg="" tmpErrMsg="电子票据下载结果失败"
	   s InvociePam.ErrMsgInfo=tmpErrMsg	
		
	}
	;返回值处理
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvDownLoad结束.Rtn=")
	q Rtn
}

/// / 3.1.8	票据库存分配
/// 功能说明：发票管理，HIS自己管理电子票据时候，需要使用此接口申请票据，如果第三方管理，则不需要此接口
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：guoyunlong  2020-04-10
/// 其    他：w ##class(BILL.EINV.ADP.BSA).EInvManage("","","") 
ClassMethod EInvManage(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvDownLoad开始.")
	
	//组织3.1.8	票据库存分配入参       单位代码（系统分配,流水号
	s timestamp=$replace($zd(+$h,,3),"-","")_$replace($zt($p($h,",",2),1),":","")
	s InputJson="{""institutionCode"":"_" "_","_"einvoiceNo"":"_ObjInvUpDetail.IUDBusNo      ;单位代码（系统分配）
	s InputJson=InputJson_","_"applyNo"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode     ;申请编号
	s InputJson=InputJson_","_"applyerName"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo  ;申请人名称
	s InputJson=InputJson_","_"applyTime"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;申请人名称
	s InputJson=InputJson_","_"einvoiceType"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode    ;票据种类（例：330601）
	s InputJson=InputJson_","_"applyNumber"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode    ;申请分数
	s InputJson=InputJson_","_"Remark"":"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_","_"timestamp"":"_timestamp_"}"  ;备注
	
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	;业务入参
	s ServiceCode="substock"
	//调用税歌http接口
	s outData=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequest(ServiceCode,HISUniqueID, Message, ObjUPConfig)
	if (outData="0"){
		
		;???   票据库存分配返回值
		
	}else{
	   s tmpErrMsg=ResOutput.msg
	   s:tmpErrMsg="" tmpErrMsg="下载票据库存分配结果失败"
	   s InvociePam.ErrMsgInfo=tmpErrMsg	
		
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.SGA).EInvDownLoad结束.Rtn=")
	q Rtn
}

/// 日报数据上传(每天凌晨上传前一天的开票数据)
/// input:StDate    --开始日期
///       EndDate   --结束日期
/// /// w ##class(BILL.EINV.ADP.SGA).UpLoadDailyReport("2021-12-30","2021-12-30")
ClassMethod UpLoadDailyReport(StDate As %String = "", EndDate As %String = "") As %String
{
	s RtnFlag="-1"
    s:StDate="" StDate=+$h-1,EndDate=+$h
    
    s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	if (RtnConfig'="1"){
		s QuitMsg="-1^获取电子票据服务的全局配置失败."
	}
	q:RtnConfig'="1" QuitMsg
	s hospitalNo=""
	s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New() 
    s InvociePam.ObjUPConfig=ObjConfig
	s hospitalInfoNum=##class(BILL.EINV.COM.Common).GetHospitalInfoByDic(InvociePam.HospitalInfoMap, hospitalNo)  ;获取医院的配置信息
	
    
	s DailyReportInfo=##class(BILL.EINV.ADP.SGA).UPDailyReport(StDate,EndDate) 
	s NormalData=$p(DailyReportInfo,"#",1)    ;正常票据数据
	s StrikeData=$p(DailyReportInfo,"#",2)    ;冲红票据数据
	q:(NormalData="")&&(StrikeData="") RtnFlag
	s InputJson=##class(%DynamicObject).%New()
	s InputJson.institutionCode=InvociePam.HospitalInfoMap.GetAt("HospitalNo")    ;单位代码（系统分配）
	s InputJson.issueDate=$zd($P(NormalData,"^",1),3)                 ;开票日期
	s InputJson.hNoramlCount=$P(NormalData,"^",2)           ;电子票据笔数，不包含冲红票，但包含被冲红的票。
	s InputJson.hNoramlMoney=$P(NormalData,"^",3)          ;电子票据金额，不包含冲红票，但包含被冲红的票。      
	s InputJson.hRedCount=$P(StrikeData,"^",2)   ;Y	冲红电子票据笔数
	s InputJson.hRedMoney=$P(StrikeData,"^",3)     ;Decimal(20,2)	Y	冲红电子票据金额（负数）
	s InputJson.affiliatedAreaCode=""                  ;院区编码，为空时，表示整个医院
	s InputJson=InputJson.%ToJSON()
	s ServiceCode="einvoices/dailyReport"
	s ResOutput=##class(BILL.EINV.DTO.SGA.EInvStatusRes).%New()    ;接收返回
	//调用税歌http接口
	 b ;calnel
	;业务入参
	s DailyReportFlag=##class(BILL.EINV.BI.SGA.HTTPRequest).InvoiceRequest(ServiceCode,InputJson,InvociePam,.ResOutput)
	b ;DailyReportFlag
	q DailyReportFlag
}

/// 根据时间获取电子发票信息
/// 适用于浙江舟山税歌电子发票日报数据上传
/// w ##class(BILL.EINV.ADP.SGA).UPDailyReport("2021-12-30","2021-12-30") 
ClassMethod UPDailyReport(IUDStDate As %String, IUDEdDate As %String) As %String
{

   s nornum=0,noramt=0,strikenum=0,strikeamt=0,NormalStrsum="",StrikeStrsum=""
   q:(IUDStDate="")||(IUDEdDate="") ""	
	//获取上传成功的发票业务信息
	k ^TEMPEINVNorm
	k ^TEMPEINVStrike
    s IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    s IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
    for date=IUDStDate:1:IUDEdDate  d
    .s IUDID=""
    .b ;date
    .for  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxIvcDate",date,IUDID)) q:IUDID=""  d
    ..s ObjIUDInfo=$g(^BILL.EINV.PO.InvUpDetailsD(IUDID))    ;##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
    ..s IUDUplodeFlag=$lg(ObjIUDInfo,8)  ;ObjIUDInfo.IUDUplodeFlag  			    ;上传标志（Y:上传成功，N:上传失败）
    ..b ;IUDUplodeFlag
    ..q:IUDUplodeFlag'="Y"    
    ..s EInvFlg=$lg(ObjIUDInfo,40)                                  ;过滤上传成功的
    ..s IUDCreatAmt=$lg(ObjIUDInfo,17)     ;ObjIUDInfo.IUDCreatAmt 						;开票金额
    ..i ((EInvFlg="I")||(EInvFlg="B")) d
    ...s nornum=nornum+1
    ...i $d(^TEMPEINVNorm("0",date))  d
    ....s ^TEMPEINVNorm("0",date)=nornum_"^"_($p($g(^TEMPEINVNorm("0",date)),"^",2)+IUDCreatAmt)
    ...else  d
    ....s ^TEMPEINVNorm("0",date)=nornum_"^"_IUDCreatAmt
    ..else  d
    ...s strikenum=strikenum+1
    ...i $d(^TEMPEINVStrike("0",date))  d
     ....s ^TEMPEINVStrike("0",date)=strikenum_"^"_($p($g(^TEMPEINVStrike("0",date)),"^",2)+IUDCreatAmt)
    ...else  d
    ....s ^TEMPEINVStrike("0",date)=strikenum_"^"_IUDCreatAmt
    
    s normDate=""
    for normDate=$o(^TEMPEINVNorm("0",normDate)) q:normDate=""  d
       .s normalData=$g(^TEMPEINVNorm("0",normDate))
       .s nnum=$p(normalData,"^",1)
       .s namt=$p(normalData,"^",2)
       .i NormalStrsum="" d
       ..s NormalStrsum=normDate_"^"_nnum_"^"_namt
       .else  d
       ..s NormalStrsum=NormalStrsum_"$"_normDate_"^"_nnum_"^"_namt
       
	s StrikeDate=""
    for StrikeDate=$o(^TEMPEINVStrike("0",StrikeDate)) q:StrikeDate=""  d
       .s strikeData=$g(^TEMPEINVStrike("0",StrikeDate))
       .s snum=$p(strikeData,"^",1)
       .s samt=$p(strikeData,"^",2)
       .i StrikeStrsum="" d
       ..s StrikeStrsum=StrikeDate_"^"_snum_"^"_samt
       .else  d
       ..s StrikeStrsum=StrikeStrsum_"$"_StrikeDate_"^"_snum_"^"_samt
    
    q NormalStrsum_"#"_StrikeStrsum
}

}
