/// 深圳富深公司的电子票据接口
Class BILL.EINV.ADP.FSA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：ZhaoZW   2019-12-25  新做成
///           董科锋 2020-01-03 程序流程修改
/// 其    他：w ##class(BILL.EINV.ADP.FSA).Invoice("14@BILL.EINV.DTO.COM.InvUpDetailInfo","7@BILL.EINV.DTO.COM.InvPrtInfo","4@BILL.EINV.DTO.COM.InvocieInputPam") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	b ;11111111113
	s StatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据流水号查询是否存在已经已经开具的电子票据
	q:StatusRtn="0" RtnFlag  ;存在的开具记录的时 获取结果直接返回
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ObjInvUpDetail.IUDPayAdmType)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	s ServiceCode="mkomedicaleinvoice"		;服务名称
	;s ServiceCode="MKOMEDICALEINVOICE"
	s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()  ;接收返回
	;s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRtn).%New() 
	;调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	;b ;052
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用富深http接口
	s hospid=InvociePam.HospitalID
	q:hospid="" "-1"   ;院区为空
	b ;2222222222调用平台接口kaishi
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;053
	i SRVRtnFlg="0" d 
	.hang 2     ;异步调用  加一个延迟3秒
	.b ;3333333333333333
	.s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取开票状态信息
	.s:InvStatusRtn'="0" RtnFlag="-1"
	e  d  ;为开票失败或异常，不能进行后续的开票状态查询。
	.s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：ZhaoZW   2019-12-26  新做成
///           董科锋 2020-01-03 程序流程修改
/// 其    他：w ##class(BILL.EINV.ADP.FSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	;b ;01235
	s StatusRtn=..GetInvStatusOfInvalid(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据业务流水号查询是否存在已经已经开具的冲红电子票据
	q:StatusRtn="0" RtnFlag  ;冲红电子票据 获取结果直接返回
	s InputJson=..InvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ObjInvUpDetail.IUDPayAdmType)   ;冲红电子票据的参数组织
	s:InputJson="" InvociePam.ErrMsgInfo="组织[冲红电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	//查询不到红冲开票信息时 调用红冲开票业务
	s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	;s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRtn).%New() 
	s ServiceCode="mkoredmedicaleinvoice"		;服务名称
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用冲红电子票据接口
	b ;调用红冲---------------平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;SRVRtnFlg
	i SRVRtnFlg="0" d 
	.hang 2     ;异步调用  加一个延迟3秒
	.s InvStatusRtn=..GetInvStatusOfInvalid(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取红冲开票状态信息
	.s:InvStatusRtn'="0" RtnFlag="-1"
	e  d  ;为冲红失败或异常，不能进行后续的状态查询。
	.s RtnFlag="-1"
	.s InvociePam.ErrMsgInfo=ResOutput.msg
	q RtnFlag
}

/// 功能说明：调用服务接口获取换开纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：ZhaoZW   2019-12-26  新做成
/// 其    他：	w ##class(BILL.EINV.ADP.FSA).PrintPaper("","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	s StatusRtn=..GetPrintPaperStatus(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据业务流水号查询是否存在已经换开纸质的电子票据
	q:StatusRtn="0" RtnFlag  ;换开纸质票据 获取结果直接返回
	
	s InputJson=..TurnPaperInvoice(ObjInvUpDetail,InvociePam)	;组织换开纸质票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[换开纸质票据]的参数失败！"
	q:InputJson="" "-1"		;组织入参发生错误
	
	//查询不到换开票据信息时 调用换开票据业务
	s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	s ServiceCode="remkomedicaleinvoice"		;服务名称
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用换开电子票据接口
    ;调用平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	;b ;SRVRtnFlg
	i SRVRtnFlg="0" d 
	.hang 2
	.s InvStatusRtn=..GetPrintPaperStatus(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取换开状态信息
	.s:InvStatusRtn'="0" RtnFlag="-1"
	e  d  ;为换开失败或异常，不能进行后续的状态查询。
	.s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：整理电子票据开具组织入参(住院、门诊公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
/// 修改履历：ZhaoZW   2019-12-25  新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).InvoiceCom("19@BILL.EINV.DTO.COM.InvUpDetailInfo","12@BILL.EINV.DTO.COM.InvPrtInfo","9@BILL.EINV.DTO.COM.InvocieInputPam","PE") 
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, PayAdmType As %String) As %String
{
	s rtn=""
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.FSA).InvoiceCom开始")
	;b ;0101
	//s ^TMP0910("WZH")=ObjInvUpDetail_"^"_ObjInvPrtInfo_"^"_InvociePam_"^"_PayAdmType
	s einvoicespecimen=""
	i (PayAdmType="OP") || (PayAdmType="REG")|| (PayAdmType="PE") d
	.s einvoicespecimen="1"
	i PayAdmType="IP" d
	.s einvoicespecimen="2"
	;其它PayAdmType类型后续再添加
	
	s invobj=##class(BILL.EINV.DTO.FSA.EInvoiceReq).%New()
	s invobj.einvoicespecimen=einvoicespecimen							;电子票据模板 1:门诊2:住院
	s Date=ObjInvUpDetail.IUDDate						
	;b ;开票日期
	s:Date'="" invobj.issuedate=$replace($zd(Date,3),"-","")			;开票日期 yyyyMMdd
	s Time=ObjInvUpDetail.IUDTime
	s:Time'="" invobj.issuetime=$replace($zt(Time,1),"-","")			;开票时间 hh:mm:ss
	s invobj.payerpartytype="1"	//ObjInvPrtInfo.PatBaseInfo.PatType // 2021-12-04    "1"											;交款人类型  1:个人 2:单位
	s invobj.payerpartycode=ObjInvPrtInfo.PatBaseInfo.PatID				;交款人代码
	s invobj.payerpartyname=ObjInvPrtInfo.PatBaseInfo.PatName			;交款人名称
	s invobj.payeracct=""												;交款人账号
	s invobj.payeropbk=""												;交款人开户行
	s invobj.payerphonenumber=ObjInvPrtInfo.PatBaseInfo.Mobphone		;交款人手机号
	;s invobj.recname=ObjInvPrtInfo.BusUserDesc   ;InvociePam.UserDesc                            	;收款人
	s invobj.recname=ObjInvPrtInfo.BusUserCode
	s invobj.recacct=""													;收款人账号
	s invobj.recopbk=""													;收款人开户行
	s invobj.totalamount=ObjInvPrtInfo.InvShareAmt	// 2021-12-04  ObjInvPrtInfo.InvAmt							;总金额
	s invobj.bizcode=ObjInvUpDetail.IUDBusNo							;业务流水号
	;s invobj.handlingperson=ObjInvPrtInfo.BusUserDesc   ;InvociePam.UserDesc 					    ;开票人（收款人）
	s invobj.handlingperson=ObjInvPrtInfo.BusUserCode   ;开票人（收款人）
	s invobj.checker="ZT276" ;ObjInvPrtInfo.BusUserCode  ;InvociePam.HospitalInfoMap.GetAt("XSF_FHR")	;复核人
	;b ;测试时使用传测试代码2
	s hosp=InvociePam.HospitalID
	s:hosp="20" invobj.checker="SQ00037"
	s invobj.remark="" 												;其他信息
	s invobj.relatedinvoicecode=ObjInvUpDetail.IUDBillBatchCode			;相关票据代码
	s invobj.relatedinvoicenumber=ObjInvUpDetail.IUDBillBatchNo			;相关票据号码
	
	s invobj.businessnumber=ObjInvPrtInfo.BusinessNo 					;业务单号
	s invobj.businessdate=$zd(ObjInvPrtInfo.BusDate,3)							;业务日期
	s invobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex 						;性别
	i ((invobj.gender="未知性别")||(invobj.gender="未说明性别")) s invobj.gender=""
	s invobj.medicaltype=""												;医疗类别
	s invobj.patientnumber=ObjInvPrtInfo.PatAdmInfo.AdmNo 				;门诊号
	s invobj.medicaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate				;就诊日期
	;s invobj.orgtype=ObjInvPrtInfo.InsuDivInfo.HospitalType				;医疗机构类型
	s invobj.orgtype=InvociePam.HospitalInfoMap.GetAt("Hospital_Name")				;医疗机构类型
	s invobj.medicalinsurancetype=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型
	i invobj.medicalinsurancetype="" d
	.s invobj.medicalinsurancetype="全自费"
	s invobj.medicalinsuranceid=ObjInvPrtInfo.InsuDivInfo.InsuId			;医保编号
	s invobj.casenumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode			;病例号
	s invobj.hospitalizationnumber=ObjInvPrtInfo.PatAdmInfo.IPNo		;住院号
	s invobj.departmentname=$p(ObjInvPrtInfo.PatAdmInfo.OutDepDesc,"-",1)			;科别
	s invobj.inhospitaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;住院日期
	s invobj.outhospitaldate=ObjInvPrtInfo.PatAdmInfo.OutDate			;出院日期
	i (PayAdmType="OP") || (PayAdmType="REG")||(PayAdmType="PE") d
	.s invobj.outhospitaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;就诊日期
	s invobj.state="2"          					                    ;获取返回参数方式 1：直接返回data，需等待2：无data，后续发主动获取接口查询（空值，默认为2）

	// 费用
	s invobj.fundpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay10)			;   2021-12-04 医保统筹基金支付//+ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0		;医保统筹基金支付
	s invobj.otherpayamount=""											;其他支付
	
	
	s invobj.accountpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	;个人账户支付
	;非医保患者个人现金支付不能从医保结算
	s invobj.ownpayamount=ObjInvPrtInfo.InvShareAmt  //   2021-12-04         ObjInvPrtInfo.InvAmt			                ;个人现金支付
	i ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'=""  d
	.s invobj.ownpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0		;个人现金支付
	s invobj.selfpaymentamount=+ObjInvPrtInfo.InsuDivInfo.selfPayAmt	;个人自付
	s invobj.selfpaymentcost=+ObjInvPrtInfo.InsuDivInfo.SelfAmt			;个人自费
	s invobj.prepayamount=ObjInvPrtInfo.DepositAmt											;预缴金额
	s invobj.rechargeamount=""											;补缴金额
	s invobj.refundamount=""											;退费金额
	b ;0102111
	if ObjInvUpDetail.IUDPayAdmType="IP" d
	.if ObjInvPrtInfo.DepositAmt-invobj.ownpayamount>0 d
	..s invobj.refundamount=$zabs(ObjInvPrtInfo.DepositAmt-invobj.ownpayamount)
	.else  d
	..s invobj.rechargeamount=$zabs(ObjInvPrtInfo.DepositAmt-invobj.ownpayamount)
	i invobj.medicalinsurancetype["工伤" d
	.s invobj.otherpayamount=invobj.fundpayamount+invobj.accountpayamount+invobj.ownpayamount
	.s invobj.fundpayamount=""
	.s invobj.accountpayamount=""
	.s invobj.ownpayamount=""
	.s invobj.rechargeamount=""
	
	//项目信息
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size d
	.s detailslistobj=##class(BILL.EINV.DTO.FSA.detailslist).%New()
	.s detailslistobj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code		;项目编码
	.s detailslistobj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc		;项目名称
	.s detailslistobj.itemquantity="" 										;数量
	.s detailslistobj.itemunit=""											;单位
	.s detailslistobj.itemstd=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;标准
	.s detailslistobj.itemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	.s detailslistobj.itemremark=""											;项目备注
	.d invobj.details.Insert(detailslistobj)
	s ^njl("totalamount")=$lb(invobj.totalamount,invobj.fundpayamount,invobj.accountpayamount,invobj.ownpayamount)
	b ;项目明细 项目明细 项目明细  ^njl("totalamount")
	/* 
	//项目清单
	if (ObjInvUpDetail.IUDPayAdmType="IP"){
		f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	    .s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()
	    .s auxdetailslistobj.auxitemrelatedcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;对应项目编码
	    .s auxdetailslistobj.auxitemrelatedname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;对应项目名称
	    .s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code		;收费明细项目编码
	    .s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费明细项目名称
	    .s auxdetailslistobj.auxitemquantity="1"		;收费明细项目数量
	    .s auxdetailslistobj.auxitemunit=""			;收费明细项目单位
	    .s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	    .s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			;收费明细项目金额
	    .s auxdetailslistobj.auxitemremark=""		;收费明细项目备注
	    .d invobj.auxdetails.Insert(auxdetailslistobj)	
	}else {
	   f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	    .s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()
	    .s auxdetailslistobj.auxitemrelatedcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	    .s auxdetailslistobj.auxitemrelatedname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;对应项目名称
	    .s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode		;收费明细项目编码
	    .s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;收费明细项目名称
	    .s auxdetailslistobj.auxitemquantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	    .s auxdetailslistobj.auxitemunit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	    .s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	    .s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	    .s auxdetailslistobj.auxitemremark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark		;收费明细项目备注
	    .d invobj.auxdetails.Insert(auxdetailslistobj)
	    .b ;mingxi
		}
		*/
	
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()

	.s auxdetailslistobj.auxitemrelatedcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	.s auxdetailslistobj.auxitemrelatedname=$e(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc,1,49)	;对应项目名称
	
	.s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode		;收费明细项目编码
	.s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;收费明细项目名称
	.//i auxdetailslistobj.auxitemname["*" s auxdetailslistobj.auxitemname=$tr(auxdetailslistobj.auxitemname,"*","--")
	.//i auxdetailslistobj.auxitemname["(" s auxdetailslistobj.auxitemname=$tr(auxdetailslistobj.auxitemname,"(","（")
	.//i auxdetailslistobj.auxitemname[")" s auxdetailslistobj.auxitemname=$tr(auxdetailslistobj.auxitemname,")","）")
	.//i auxdetailslistobj.auxitemname[":" s auxdetailslistobj.auxitemname=$tr(auxdetailslistobj.auxitemname,":","：")
	
	.s auxdetailslistobj.auxitemquantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	.s auxdetailslistobj.auxitemunit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	.s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	.s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	.s auxdetailslistobj.auxitemremark="" ;$e(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark,1,49)		;收费明细项目备注
	
	.d invobj.auxdetails.Insert(auxdetailslistobj)
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	;s rtn=Stream.Read()
	;b  ;;rtn
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.FSA).InvoiceCom结束"_rtn)
	;s ^tempgyl("BILL.EINV.ADP.FSA")=rtn
	;q rtn
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.FSA).InvoiceCom结束"_Stream)
	;s ^tempgyl("BILL.EINV.ADP.FSA")=Stream
	b ;Stream 完成字符串
	q Stream
}

/// 功能说明：整理电子票据冲红入参组织(门诊、住院公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：ZhaoZW   2019-12-26  新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).InvalidOP("","","") 
ClassMethod InvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, PayAdmType As %String) As %String
{
	s rtn="",einvoicespecimen=""
	
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.FSA).InvalidCom开始")
	i (PayAdmType="OP") || (PayAdmType="REG")||(PayAdmType="PE") d
	.s einvoicespecimen="1"
	i PayAdmType="IP" d
	.s einvoicespecimen="2"
	;其它PayAdmType类型后续再添加
	
	//票据信息
	s invobj=##class(BILL.EINV.DTO.FSA.EInvalidReq).%New()
	s invobj.einvoicespecimen=einvoicespecimen							;电子票据模板 1:门诊2:住院
	s invobj.issuedate=$replace($zd($p($h,",",1),3),"-","")				;开票日期
	s invobj.issuetime=$replace($zt($p($h,",",2),1),"-","")				;开票时间
	s invobj.payerpartytype="1"											;交款人类型  1:个人 2:单位
	s invobj.payerpartycode=ObjInvPrtInfo.PatBaseInfo.PatID				;交款人代码
	s invobj.payerpartyname=ObjInvPrtInfo.PatBaseInfo.PatName			;交款人名称
	s invobj.payeracct=""												;交款人账号
	s invobj.payeropbk=""												;交款人开户行
	s invobj.payerphonenumber=ObjInvPrtInfo.PatBaseInfo.Mobphone		;交款人手机号
	i ObjInvUpDetail.OriInvUpDetail.IUDUser'="" d
	.s UserDesc=$p($g(^SSU("SSUSR",ObjInvUpDetail.OriInvUpDetail.IUDUser)),"^",2)		;操作员名称
	.s UserCode=$p($g(^SSU("SSUSR",ObjInvUpDetail.OriInvUpDetail.IUDUser)),"^",1)		;操作员工号
	s invobj.recname=UserCode				                            ;收款人
	s invobj.recacct=""													;收款人账号
	s invobj.recopbk=""													;收款人开户行
	s invobj.totalamount=ObjInvPrtInfo.InvShareAmt  //ObjInvPrtInfo.InvAmt		20211208					;总金额
	s invobj.bizcode=ObjInvUpDetail.OriInvUpDetail.IUDBusNo  ;ObjInvUpDetail.IUDBusNo							;业务流水号
	;s invobj.handlingperson=UserDesc		 					;开票人（收款人）
	s invobj.handlingperson=UserCode		 					;开票人（收款人）
	s invobj.checker="ZT276" ;UserCode ;InvociePam.HospitalInfoMap.GetAt("XSF_FHR")		;复核人
	
	s invobj.remark="" 	;其他信息   --测试时候使用，测试完成之后，传空
	
	s invobj.relatedinvoicecode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;相关票据代码
	s invobj.relatedinvoicenumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;相关票据号码
	;红冲票据流水号要原开票流水号
	i invobj.relatedinvoicenumber'="" d
	.s invobj.bizcode=ObjInvUpDetail.OriInvUpDetail.IUDBusNo
	;处理开票人复核人收款人前期上传的是汉字名称问题，判断原票是修改前开出来的
	s invobj.businessnumber=ObjInvPrtInfo.BusinessNo 					;业务单号
	s invobj.businessdate=$zd(ObjInvPrtInfo.BusDate,3)							;业务日期
	s invobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex 						;性别
	i ((invobj.gender="未知性别")||(invobj.gender="未说明性别")) s invobj.gender=""
	s invobj.medicaltype=""												;医疗类别
	s invobj.patientnumber=ObjInvPrtInfo.PatAdmInfo.AdmNo 				;门诊号
	s invobj.medicaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate				;就诊日期
	;s invobj.orgtype=ObjInvPrtInfo.InsuDivInfo.HospitalType				;医疗机构类型
	s invobj.orgtype=InvociePam.HospitalInfoMap.GetAt("Hospital_Name")  ;"承德医学院附属医院"				;医疗机构类型
	s invobj.medicalinsurancetype=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型
	i invobj.medicalinsurancetype="" d
	.s invobj.medicalinsurancetype="全自费"    ;$p($g(^PAC("ADMREA",ObjInvPrtInfo.InsTypeDr)),"^",2)
	b ;invobj.medicalinsurancetype
	s invobj.medicalinsuranceid=ObjInvPrtInfo.InsuDivInfo.InsuId			;医保编号
	s invobj.casenumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode			;病例号
	s invobj.hospitalizationnumber=ObjInvPrtInfo.PatAdmInfo.IPNo		;住院号
	s invobj.departmentname=$P(ObjInvPrtInfo.PatAdmInfo.OutDepDesc,"-",2)			;科别
	s invobj.inhospitaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;住院日期
	s invobj.outhospitaldate=ObjInvPrtInfo.PatAdmInfo.OutDate			;出院日期
	i (PayAdmType="OP") || (PayAdmType="REG")|| (PayAdmType="PE")   d
	.s invobj.outhospitaldate=ObjInvPrtInfo.PatAdmInfo.AdmDate
	s invobj.state="2"          					                    ;获取返回参数方式 1：直接返回data，需等待2：无data，后续发主动获取接口查询（空值，默认为2）

	// 费用
	s invobj.fundpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5) +(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6)+(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay10)  ;+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay7+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay8		;医保统筹基金支付 //ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0   ;+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay7+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay8		;医保统筹基金支付
	s invobj.fundpayamount=$zabs(invobj.fundpayamount)
	i (invobj.fundpayamount[".")&&($p(invobj.fundpayamount,".",1)="") s invobj.fundpayamount=0_invobj.fundpayamount
	s invobj.otherpayamount=""											;其他支付
	s invobj.accountpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	;个人账户支付
	s invobj.accountpayamount=$zabs(invobj.accountpayamount)
	i (invobj.accountpayamount[".")&&($p(invobj.accountpayamount,".",1)="") s invobj.accountpayamount=0_invobj.accountpayamount
	
	;b ;非医保患者个人现金支付不能从医保结算
	s invobj.ownpayamount=ObjInvPrtInfo.InvShareAmt //ObjInvPrtInfo.InvAmt  //$fn(ObjInvPrtInfo.InvAmt,"",2)	 ;个人现金支付
	s invobj.ownpayamount=$zabs(invobj.ownpayamount)
	i (invobj.ownpayamount[".")&&($p(invobj.ownpayamount,".",1)="") s invobj.ownpayamount=0_invobj.ownpayamount
	i ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'=""  d
	.s invobj.ownpayamount=+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0  //+$fn(ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)		;个人现金支付
	.s invobj.ownpayamount=$zabs(invobj.ownpayamount)
	.i (invobj.ownpayamount[".")&&($p(invobj.ownpayamount,".",1)="") s invobj.ownpayamount=0_invobj.ownpayamount
	s invobj.selfpaymentamount=+ObjInvPrtInfo.InsuDivInfo.selfPayAmt	;个人自付
	s invobj.selfpaymentcost=+ObjInvPrtInfo.InsuDivInfo.SelfAmt			;个人自费
	s invobj.prepayamount=ObjInvPrtInfo.DepositAmt											;预缴金额
	s invobj.rechargeamount=""											;补缴金额
	s invobj.refundamount=""											;退费金额
	if ObjInvUpDetail.IUDPayAdmType="IP" d
	.if ObjInvPrtInfo.DepositAmt-invobj.ownpayamount>0 d
	..s invobj.refundamount=$zabs(ObjInvPrtInfo.DepositAmt-invobj.ownpayamount)
	.else  d
	..s invobj.rechargeamount=$zabs(ObjInvPrtInfo.DepositAmt-invobj.ownpayamount)
	i invobj.medicalinsurancetype["工伤" d
	.s invobj.otherpayamount=invobj.fundpayamount+invobj.accountpayamount+invobj.ownpayamount
	.s invobj.fundpayamount=""
	.s invobj.accountpayamount=""
	.s invobj.ownpayamount=""
	.s invobj.rechargeamount=""
	//项目信息
	f i=1:1:ObjInvPrtInfo.InvCateInfo.Size d
	.s detailslistobj=##class(BILL.EINV.DTO.FSA.detailslist).%New()
	.s detailslistobj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code		;项目编码
	.s detailslistobj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc		;项目名称
	.s detailslistobj.itemquantity="" 										;数量
	.s detailslistobj.itemunit=""											;单位
	.s detailslistobj.itemstd=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;标准
	.s detailslistobj.itemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	.s detailslistobj.itemremark=""											;项目备注
	.d invobj.details.Insert(detailslistobj)
	s ^njl("totalamountbackBill")=$lb(invobj.totalamount,invobj.fundpayamount,invobj.accountpayamount,invobj.ownpayamount)
	b ;22222222222222   totalamountbackBill
	if (ObjInvUpDetail.IUDPayAdmType="IP"){
		f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	    .s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()
	    .s auxdetailslistobj.auxitemrelatedcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;对应项目编码
	    .s auxdetailslistobj.auxitemrelatedname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;对应项目名称
	    .s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code		;收费明细项目编码
	    .s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费明细项目名称
	    .s auxdetailslistobj.auxitemquantity="1"		;收费明细项目数量
	    .s auxdetailslistobj.auxitemunit=""			;收费明细项目单位
	    .s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	    .s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			;收费明细项目金额
	    .s auxdetailslistobj.auxitemremark=""		;收费明细项目备注
	    .d invobj.auxdetails.Insert(auxdetailslistobj)	
	}else {
	   f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	    .s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()
	    .s auxdetailslistobj.auxitemrelatedcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	    .s auxdetailslistobj.auxitemrelatedname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;对应项目名称
	    .s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode		;收费明细项目编码
	    .s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;收费明细项目名称
	    .s auxdetailslistobj.auxitemquantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	    .s auxdetailslistobj.auxitemunit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	    .s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	    .s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	    .s auxdetailslistobj.auxitemremark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark		;收费明细项目备注
	    .d invobj.auxdetails.Insert(auxdetailslistobj)
		}
	//项目清单
	/*
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s auxdetailslistobj=##class(BILL.EINV.DTO.FSA.auxdetailslist).%New()
	
	.s auxdetailslistobj.auxitemrelatedcode= ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	.s auxdetailslistobj.auxitemrelatedname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;对应项目名称
	
	.s auxdetailslistobj.auxitemcode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode		;收费明细项目编码
	.s auxdetailslistobj.auxitemname=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;收费明细项目名称
	
	.s auxdetailslistobj.auxitemquantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	.s auxdetailslistobj.auxitemunit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	.s auxdetailslistobj.auxitemstd=""													;收费明细项目标准
	.s auxdetailslistobj.auxitemamount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	.s auxdetailslistobj.auxitemremark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark		;收费明细项目备注
	.d invobj.auxdetails.Insert(auxdetailslistobj)
	*/
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	;b ;0302
	;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.FSA).InvalidCom结束"_rtn)
	;s ^temp("WZH")=rtn
	q rtn
	;q Stream
}

/// 功能说明：4.3.2	换开纸质票据（电子票据打印）接口
///           4.3.3	重新换开纸质票据接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：ZhaoZW   2019-12-26  新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).TurnPaperInvoice("","","") 
ClassMethod TurnPaperInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	//换开纸质票据
	s ObjInvUpDetail.IUDPrtDate=+$h              ;换开时存业务发生日期
	s ObjInvUpDetail.IUDPrtTime=$p($h,"",2)      ;换开时存业务发生时间
	s TurnPaperRt=##class(BILL.EINV.DTO.FSA.EInvTurnPaperReq).%New()
	;s TurnPaperRt.bizcode=ObjInvUpDetail.IUDBusNo									;业务流水号
	;update  富深，换开时候流水号需要用开具电子票据的流水号
	s TurnPaperRt.bizcode=ObjInvUpDetail.OriInvUpDetail.IUDBusNo
	s TurnPaperRt.einvoicecode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode		;电子票据代码
	s TurnPaperRt.einvoicenumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo		        ;电子票据号码
	s TurnPaperRt.billcode=InvociePam.pBillBatchCode                          ;纸质票据代码								
	s TurnPaperRt.billnumber=InvociePam.pBillNo					                    ;纸质票据号
	;测试代码，测试完删除
	S TurnPaperRt.remark=""
	
	b //调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	s rtn=Stream.Read()
	q rtn
	;q Stream
}

/// 功能说明：获取电子票据文件
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 		  InvociePam		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：         
/// 修改履历：guoyunlong   2020-04-15 
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetMedicaleInvoice("","","") 
ClassMethod GetMedicaleInvoice(ByRef ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="",PhotoInfoStr=""
    s InputJson=..GetMedicalInput(ObjInvUpDetail,InvociePam)
    q:InputJson="-1" RtnFlag
    s ServiceCode="getmedicaleinvoice"     ;接口服务名称									;业务入参

	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvMedicalInfo).%New() 
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;调用平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //获取返回数据成功后。
	if (SRVRtnFlg="0"){
		    s Len=ResOutput.data.Size
		    for i=1:1:Len  d
			.;s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.GetAt(1).einvoicecode       ;电子票据代码
			.;s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.GetAt(1).einvoicenumber       ;电子票据号码
			.;s ObjInvUpDetail.IUDCheckCode=ResOutput.data.GetAt(1).randomnumber           ;校验码
	
			.;s ObjInvUpDetail.Xstr1=ResOutput.data.GetAt(1).einvoiceid                    ;电子票据ID
			.;????是否保存返回的电子票据文件图片和数据
			.s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(i).einvoicefilename              ;电子票据文件名称
			.s PhotoInfo=ResOutput.data.GetAt(i).einvoicefile                  ;电子票据文件
			
			.if PhotoInfoStr="" d
			..s PhotoInfoStr=PhotoInfo
			.else  d
			..s PhotoInfoStr=PhotoInfoStr_"^"_PhotoInfo
			.b ;;mingxi
			s ^tempgyl("Einv")=PhotoInfoStr
			s RtnFlag="0"
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="电子票据文件结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	b ;111
	q RtnFlag_"^"_PhotoInfoStr
}

/// 功能说明：获取电子票据文件
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 		  InvociePam		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：         
/// 修改履历：guoyunlong   2020-04-15 
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetMedicaleInvoice("","","") 
ClassMethod GetMedicaleInvoiceLen(ByRef ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="",PhotoInfoStr=""
    s InputJson=..GetMedicalInput(ObjInvUpDetail,InvociePam)
    q:InputJson="-1" RtnFlag
    s ServiceCode="getmedicaleinvoice"     ;接口服务名称									;业务入参

	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvMedicalInfo).%New() 
	s ObjNote=##class(BILL.EINV.DTO.COM.Notes).%New() 
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;调用平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //获取返回数据成功后。
	if (SRVRtnFlg="0"){
		    s Len=ResOutput.data.Size
		    for i=1:1:Len  d
			.s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(i).einvoicefilename              ;电子票据文件名称
			.s:i=1 ObjNote.note1= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=2 ObjNote.note2= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=3 ObjNote.note3= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=4 ObjNote.note4= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=5 ObjNote.note5= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=6 ObjNote.note6= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=7 ObjNote.note7= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=8 ObjNote.note8= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=9 ObjNote.note9= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=10 ObjNote.note10= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=11 ObjNote.note11= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=12 ObjNote.note12= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=13 ObjNote.note13= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=14 ObjNote.note14= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=15 ObjNote.note15= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=16 ObjNote.note16= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=17 ObjNote.note17= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=18 ObjNote.note18= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=19 ObjNote.note19= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=20 ObjNote.note20= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=21 ObjNote.note21= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=22 ObjNote.note22= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=23 ObjNote.note23= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=24 ObjNote.note24= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=25 ObjNote.note25= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=26 ObjNote.note26= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=27 ObjNote.note27= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=28 ObjNote.note28= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=29 ObjNote.note29= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=30 ObjNote.note30= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=31 ObjNote.note31= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=32 ObjNote.note32= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=32 ObjNote.note32= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=34 ObjNote.note34= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=35 ObjNote.note35= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=36 ObjNote.note36= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=37 ObjNote.note37= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=38 ObjNote.note38= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=39 ObjNote.note39= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=40 ObjNote.note40= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=41 ObjNote.note41= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=42 ObjNote.note42= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=43 ObjNote.note43= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=44 ObjNote.note44= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=45 ObjNote.note45= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=46 ObjNote.note46= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=47 ObjNote.note47= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=48 ObjNote.note48= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=49 ObjNote.note49= ResOutput.data.GetAt(i).einvoicefile 
			.s:i=50 ObjNote.note50= ResOutput.data.GetAt(i).einvoicefile 
			

			
			s RtnFlag="0"
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="电子票据文件结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjNote,.Stream)
	;s rtn=Stream.Read(Stream.Size)
	b ;00999
	q RtnFlag_"^"_Len_"^"_Stream
}

ClassMethod GetMedicaleInvoiceDetail(ByRef ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, i As %String) As %String
{
	s RtnFlag="",PhotoInfoStr=""
    s InputJson=..GetMedicalInput(ObjInvUpDetail,InvociePam)
    q:InputJson="-1" RtnFlag
    s ServiceCode="getmedicaleinvoice"     ;接口服务名称									;业务入参

	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvMedicalInfo).%New() 
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;调用平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //获取返回数据成功后。
	if (SRVRtnFlg="0"){
		    s Len=ResOutput.data.Size
		   
			s PhotoInfo=ResOutput.data.GetAt(i).einvoicefile                  ;电子票据文件
			
			
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="电子票据文件结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	b ;111
	q PhotoInfo
}

/// 功能说明：组织获取电子票据文件入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 		  InvociePam		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：guoyunlong   2020-04-15 
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetMedicaleInvoice("","","") 
ClassMethod GetMedicalInput(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s InputPam=##class(BILL.EINV.DTO.FSA.EGetInvoiceReq).%New()
	s InputPam.bizcode=ObjInvUpDetail.IUDBusNo						;业务流水号
	s InputPam.einvoicecode=ObjInvUpDetail.IUDBillBatchCode			;电子票据代码
	s InputPam.einvoicenumber=ObjInvUpDetail.IUDBillBatchNo			;电子票据号码
	s InputPam.randomnumber=ObjInvUpDetail.IUDCheckCode				;校验码
	s InputPam.payerpartyname=ObjInvUpDetail.IUDUser				;交款人
	s InputPam.writedate=$zd(ObjInvUpDetail.IUDCreatDate,3)				;开票日期
	s InputPam.billfiletype="1"										;电子票据格式 1：png（默认）2：pdf 3：ofd（暂无）
	s InputPam.remark=""

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InputPam,.Stream)
	s rtn=Stream.Read()
	q rtn
	;q Stream
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：ZhaoZW   2019-12-31 
///           董科锋 2020-01-03 程序流程修改
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	b ;7777777777777777
	s RtnFlag="-1"
	s InputJson="{""bizcode"":"""_ObjInvUpDetail.IUDBusNo_"""}"		;流水号 ""remark""":2
	;测试使用，测试完屏蔽掉
	;s InputJson="{""bizcode"":"""_ObjInvUpDetail.IUDBusNo_""",""remark"":2}"
	;s InputJson="{""bizcode"":""HH05YDY737235OP20200310172701077"",""remark"":2}"
    s ServiceCode="search/meinvoicestatus"     ;接口服务名称
	;s ServiceCode="MEINVOICESTATUS"
	s ReqJsonStr=InputJson										;业务入参
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(InputJson)
	;s ResOutput=##class(BILL.EINV.DTO.FSA.EInvoiceRes).%New()    ;接收返回  2020-03-11
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRtn).%New() 
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonStr, InvociePam, .ResOutput)
	b ;调用平台接口 ServiceCode
	//s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, stream, InvociePam, .ResOutput)
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //SRVRtnFlg 1111111获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg="0"){
		s state=ResOutput.data.GetAt(1).state
		b ;kaipaio 
		if (state="1") {
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.GetAt(1).einvoicecode       ;电子票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.GetAt(1).einvoicenumber       ;电子票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.GetAt(1).randomnumber           ;校验码
			s ObjInvUpDetail.IUDBillBatchStatus=state                           ;开票状态 1成功，0失败
			s ObjInvUpDetail.Xstr1=ResOutput.data.GetAt(1).einvoiceid                    ;电子票据ID
			s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(1).einvoicefilename              ;电子票据文件名称
			s ObjInvUpDetail.Xstr3=ResOutput.data.GetAt(1).bizcode                       ;业务流水号(服务商返回的)
			
			s NowDateTimeStr=$h
			s iNowDate=$p(NowDateTimeStr, ",", 1)
			s iNowTime=$p(NowDateTimeStr, ",", 2)
			s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo
			
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

/// 功能说明：调用服务接口获取电子票据冲红结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：董科锋 2020-01-03 新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetInvStatusOfInvalid("","","") 
ClassMethod GetInvStatusOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"	
	s InputJson="{""bizcode"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBusNo_"""}"		;流水号 测试完之后放开
	;s InputJson="{""bizcode"":"""_ObjInvUpDetail.IUDBusNo_""",""remark"":2}"
	s ServiceCode="mredeinvoicestatus"                   ;接口服务名称
	s ReqJsonStr=InputJson										;业务入参
	;s stream=##class(%GlobalCharacterStream).%New()
	;d stream.Write(InputJson)
	;s ResOutput=##class(BILL.EINV.DTO.FSA.EInvoiceRes).%New()    ;接受返回
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRtn).%New() 
	//调用富深http接口
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, stream, InvociePam, .ResOutput)
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg=0){
		s state=ResOutput.data.GetAt(1).state  ;开票状态 1成功，0失败
		if (state="1") {
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.GetAt(1).einvoicecode       ;电子票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.GetAt(1).einvoicenumber       ;电子票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.GetAt(1).randomnumber           ;校验码
			s ObjInvUpDetail.IUDBillBatchStatus=state                                    ;开票状态 1成功，0失败
			s ObjInvUpDetail.Xstr1=ResOutput.data.GetAt(1).einvoiceid                    ;电子票据ID
			s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(1).einvoicefilename              ;电子票据文件名称
			s ObjInvUpDetail.Xstr3=ResOutput.data.GetAt(1).bizcode                       ;业务流水号(服务商返回的)
			
			s NowDateTimeStr=$h
			s iNowDate=$p(NowDateTimeStr, ",", 1)
			s iNowTime=$p(NowDateTimeStr, ",", 2)
			s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="冲红成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="S"									   ;发票状态
			
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
	
	b ;023
	q RtnFlag
}

/// 功能说明：设置开具开票结果信息到交易对象表对象中
/// 入参说明：ResOutput  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod ESetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ByRef ResOutput As BILL.EINV.DTO.FSA.EInvComRes) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.FSA.EInvoiceMegRes).%New()
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(ResOutput)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	//对返回结果的时间戳进行分割
	s writedate=ResultMegObj.writedate
	s writedate=$zdh(writedate,8)
								
	s ObjInvUpDetail.Xstr1=ResultMegObj.einvoicename				;电子票据名称
	
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.einvoicecode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.einvoicenumber		;电子票据号码
	s ObjInvUpDetail.IUDBusNo=ResultMegObj.bizcode					;业务流水号
	s ObjInvUpDetail.IUDUser=ResultMegObj.payerpartyname			;交款人
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.randomnumber			;校验码
	s ObjInvUpDetail.IUDCreatDate=writedate							;开票日期
	
	s ObjInvUpDetail.Xstr2=ResultMegObj.einvoicefilename			;电子票据格式
	s ObjInvUpDetail.Xstr3=ResultMegObj.einvoicefilename			;文件名称
	s ObjInvUpDetail.Xstr4=ResultMegObj.einvoicefile				;文件
	s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：设置红冲开票结果信息到交易对象表对象中
/// 入参说明：ResOutput  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod ESetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.PO.InvUpDetails, ByRef ResOutput As BILL.EINV.DTO.FSA.EInvComRes) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.BSA.OPInvalidMegRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(ResOutput)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	//对返回结果的时间戳进行分割
	s writedate=ResultMegObj.writedate
	s writedate=$zdh(writedate,8)
								
	s ObjInvUpDetail.Xstr1=ResultMegObj.einvoicename				;电子票据名称
	
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.einvoicecode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.einvoicenumber		;电子票据号码
	s ObjInvUpDetail.IUDBusNo=ResultMegObj.bizcode					;流水号
	s ObjInvUpDetail.IUDUser=ResultMegObj.payerpartyname			;交款人
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.randomnumber			;校验码
	s ObjInvUpDetail.IUDCreatDate=writedate							;开票日期
	
	s ObjInvUpDetail.Xstr2=ResultMegObj.einvoicefilename			;电子票据格式
	s ObjInvUpDetail.Xstr3=ResultMegObj.einvoicefilename			;文件名称
	s ObjInvUpDetail.Xstr4=ResultMegObj.einvoicefile				;文件
	
	s RtnFlg="0"
	q RtnFlg
}

/// 测试
/// s OutputObj=##class(BILL.EINV.DTO.FSA.EinvoiceRep).%New()
/// w ##class(BILL.EINV.ADP.FSA).test(.OutputObj) 
ClassMethod test(OutputObj) As %String
{
	s rtn=""
	s Str="{""code"":""1"",""message"":""消息"",""data"":{""name"":""zhaozw"",""minzu"":""han""}}"
	;s OutputObj=##class(BILL.EINV.DTO.FSA.EinvoiceRep).%New()
	if $isobject(OutputObj)=0 {
		s OutputObj=##class(BILL.EINV.DTO.FSA.EInvComRes).%New()
	}
	
	set Stream=##class(%GlobalCharacterStream).%New()
	do Stream.Write(Str)
	do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	
	b ;00
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(obj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：调用服务接口获取换开纸质票据结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：郭云龙 2020-01-03 新做成 	REMEINVOICESTATUS
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetPrintPaperStatus("","","") 
ClassMethod GetPrintPaperStatus(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	;换开查询流水号需要用原电子票据流水号，换开业务也是用原电子票据流水号	
	s InputJson="{""bizcode"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBusNo_"""}"		;流水号 测试完之后放开
	;s InputJson="{""bizcode"":"""_ObjInvUpDetail.IUDBusNo_""",""remark"":2}"
	s ServiceCode="search/remeinvoicestatus"                   ;接口服务名称                 
	s ReqJsonStr=InputJson										;业务入参
	;s stream=##class(%GlobalCharacterStream).%New()
	;d stream.Write(InputJson)
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvPaperRes).%New()    ;接受返回
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;调用平台接口
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, stream, InvociePam, .ResOutput)
	;b ;053
	b //获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg=0){
		s state=ResOutput.data.GetAt(1).state  ;开票状态 1成功，0失败
		if (state="1") {
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.GetAt(1).billcode       ;纸质票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.GetAt(1).billnumber       ;纸质票据号码
			s ObjInvUpDetail.IUDBillBatchStatus=state                           ;开票状态 1成功，0失败
			s ObjInvUpDetail.Xstr1=ResOutput.data.GetAt(1).einvoicecode                   ;电子票据代码
			s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(1).einvoicenumber                ;电子票据号码
			s ObjInvUpDetail.Xstr3=ResOutput.data.GetAt(1).bizcode                       ;业务流水号(服务商返回的)
			
			s NowDateTimeStr=$h
			s iNowDate=$p(NowDateTimeStr, ",", 1)
			s iNowTime=$p(NowDateTimeStr, ",", 2)
			s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="换开成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo
			
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

/// 4.3.1.	SENDEINVOICEGATHER发送日终汇总金额、条数信息(富深)
/// InputPam  入参 开票日期^电子票据代码^开票数量^总金额
/// BalanceDay -保存对帐数据实体类
/// InvociePam -配置信息，扩展参数
ClassMethod DLEInvBalance(InputPam As %String, ByRef BalanceDay As BILL.EINV.PO.BalanceDay, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
	s RtnFlag="-1"  ;错误代码
	s busBgnDate=$p(InputPam,"^",1)      ;开票日期   yyyyMMdd
	s EinvoiceCode=$p(InputPam,"^",2)       ;电子票据代码
	s Invoicequantity=$p(InputPam,"^",3)  ;开票数量
	s Amt=$p(InputPam,"^",4)      ;总金额

	s InputJson="{""issuedate"":"_busBgnDate_",""einvoicecode"":"_EinvoiceCode_",""invoicequantity"":"_Invoicequantity_",""amt"":"_Amt_"}"		;流水号 
	b //将字符串转换为字符流
	s objstream=##class(%Stream.GlobalCharacter).%New()
	//d objstream.Write(InputJson)
	//s InputJson=objstream
	
	s ServiceCode="sendeinvoicegather"                          ;接口服务名称
	s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRtn).%New()  ;接收返回
	b // 调用4.3.1.	SENDEINVOICEGATHER发送日终汇总金额、条数信息，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)	;调用富深http接口
	b //SRVRtnFlg1111111111111111111111111111111111
	q:SRVRtnFlg'="0" RtnFlag
	
	s RtnFlag=0
	
	q RtnFlag									;业务入参
}

/// 获取获取日终对账结果(富深)
/// InputPam  入参 开票日期
/// BalanceDay -保存对帐数据实体类
/// InvociePam -配置信息，扩展参数
ClassMethod GetInvBalance(InputPam As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam)
{
	s RtnFlag="-1"  ;错误代码
	s busBgnDate=$p(InputPam,"^",1)      ;开票日期   yyyyMMdd
	s InputJson="{""issuedate"":"""_busBgnDate_"""}"
	//将字符串转换为字符流
	//s objstream=##class(%Stream.GlobalCharacter).%New()
	//d objstream.Write(InputJson)
	//s InputJson=objstream
	
	s ServiceCode="meinvoiceaccresult"                          ;接口服务名称
	//s ServiceCode="search/meinvoiceaccresult"  	
	;s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRtn).%New()  ;接收返回
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvBalanaceRes).%New()
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)	;
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;SRVRtnFlg
	if (SRVRtnFlg="0"){
		tstart
		f i=1:1:ResOutput.data.Size  d
		.s Billbatchcode=ResOutput.data.GetAt(i).einvoicecode
		.s BusDate=$zdh($e(ResOutput.data.GetAt(i).issuedate,1,4)_"-"_ $e(ResOutput.data.GetAt(i).issuedate,5,6)_"-"_ $e(ResOutput.data.GetAt(i).issuedate,7,8),3)
		.s BalanceDay=##class(BILL.EINV.PO.BalanceDay).%New()  ;交易对象
		.;b ;321
		.i $d(^BILL.EINV.PO.BalanceDayI("IdxDateAndCode",BusDate,Billbatchcode))>0 d
		..s ID=$o(^BILL.EINV.PO.BalanceDayI("IdxDateAndCode",BusDate,Billbatchcode,""),-1) 
		..i ID'="" d
		...s BalanceDay=##class(BILL.EINV.PO.BalanceDay).%OpenId(ID)  ;交易对象
		.;b ;123
		.s BalanceDay.BusDate=$zdh($e(ResOutput.data.GetAt(i).issuedate,1,4)_"-"_ $e(ResOutput.data.GetAt(i).issuedate,5,6)_"-"_ $e(ResOutput.data.GetAt(i).issuedate,7,8),3)          ;对账日期
	    .s BalanceDay.Einvoicecode=ResOutput.data.GetAt(i).einvoicecode    ;电子票据代码
	    .s BalanceDay.Einvoicename=ResOutput.data.GetAt(i).einvoicename    ;电子票据名称
	    .s BalanceDay.AllTotalNum=ResOutput.data.GetAt(i).fincount           ;财政汇总条数
	    .s BalanceDay.AllTotalAmt=ResOutput.data.GetAt(i).finamt            ;财政总金额
	    .s BalanceDay.XStr1=ResOutput.data.GetAt(i).reconresult       ;对账结果
	    .s BalanceDay.XStr2=ResOutput.data.GetAt(i).invoicingpartyamt   ;单位传递金额
	    .s BalanceDay.XStr3=ResOutput.data.GetAt(i).invoicingpartycount ;单位传递条数
	    .s BalanceDay.XStr4=ResOutput.data.GetAt(i).invoicingpartycode   ;开票单位代码
	    .s BalanceDay.XStr5=ResOutput.data.GetAt(i).invoicingpartyname   ;开票单位名称
	    .b //123
	    .s sc=BalanceDay.%Save()
		.if ($System.Status.IsError(sc)) d
		..s RtnFlag="-1"
		..trollback
		.else  d
		..s RtnFlag="0"
		tcommit
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="获取日终对账结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	
	q RtnFlag
}

/// 上传富深电子票据明细
ClassMethod UPDetailsInfo(DetailInfoObj As BILL.EINV.DTO.COM.EInvDetailData, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s Stream=##class(%GlobalCharacterStream).%New()
	;d ##class(ext.util.JsonObject).ObjectToJSONStream(DetailInfoObj,.Stream)
	s InputJson=##class(ext.util.JsonObject).ObjToJson(DetailInfoObj)
	;s InputJson=Stream.Read(Stream.Size)
	;s InputJson=Stream
	b ;InputJson  InputJson
	s InputJson=$P(InputJson,"[",2)
	s InputJson="["_$P(InputJson,"]",1)_"]"
	//s InputJson=$P(InputJson,"]",1)
	//d Stream.Write(InputJson)
	q:InputJson="" RtnFlag
	
	b ;InputJson InputJson  InputJson
	s ServiceCode="sendeinvoicedetail"                          ;接口服务名称	
	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvComRtn).%New()
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	//s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, .Stream, InvociePam, .ResOutput)	;调用富深http接口
	if (SRVRtnFlg="0"){
			s RtnFlag="0"
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="发送开票明细失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	q RtnFlag
}

/// 功能说明：获取电子票据文件
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 		  InvociePam		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：         
/// 修改履历：guoyunlong   2020-04-15 
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetMedicaleInvoice("","","") 
ClassMethod GetMedicaleInvoiceNew(ByRef ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, AdmType, InvPrt, IUDPrintType, job) As %String
{
	s RtnFlag="",PhotoInfoStr=""
    s InputJson=..GetMedicalInput(ObjInvUpDetail,InvociePam)
    q:InputJson="-1" RtnFlag
    s ServiceCode="getmedicaleinvoice"     ;接口服务名称									;业务入参

	s ResOutput=##class(BILL.EINV.DTO.FSA.EInvMedicalInfo).%New() 
	;s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)
	b ;调用平台接口
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequestESN(ServiceCode, InputJson, InvociePam, .ResOutput)
	b //获取返回数据成功后。
	s Len=0
	if (SRVRtnFlg="0"){
		    s Len=ResOutput.data.Size
		    for i=1:1:Len  d
			.;s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.GetAt(1).einvoicecode       ;电子票据代码
			.;s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.GetAt(1).einvoicenumber       ;电子票据号码
			.;s ObjInvUpDetail.IUDCheckCode=ResOutput.data.GetAt(1).randomnumber           ;校验码
	
			.;s ObjInvUpDetail.Xstr1=ResOutput.data.GetAt(1).einvoiceid                    ;电子票据ID
			.;????是否保存返回的电子票据文件图片和数据
			.s ObjInvUpDetail.Xstr2=ResOutput.data.GetAt(i).einvoicefilename              ;电子票据文件名称
			.s PhotoInfo=ResOutput.data.GetAt(i).einvoicefile                  ;电子票据文件
			.s ^DHCBILLEINV("PhotoInfo",AdmType,InvPrt,IUDPrintType,job,i)=PhotoInfo
			s RtnFlag="0"
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="电子票据文件结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	b ;111
	q RtnFlag_"^"_job_"^"_Len
}

}
