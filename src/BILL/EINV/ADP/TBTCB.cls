/// 杭州未来科技（同步天成）--中间库模式
Class BILL.EINV.ADP.TBTCB Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong  2022-06-21  新做成
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invoice开始")
	s RtnFlag="-1"
	
	;;;;推送数据之前，先根据流水号查询一下该流水号下是否开具过发票
	s InputQueryXml="<Request></Data><SettlementNo>"_ObjInvUpDetail.IUDBusNo_"</SettlementNo></Data></Request>"
	///调用平台接口查询
	s QueryRtn="" 
	/*
	解析查询返回值判断是否继续进行开票操作
	1.需要调用开票接口的 
	  1.1查询结果为空，继续走开票接口
	  1.2查询结果出来主表结果Scjg<>1(1.处理成功 2.明细缺损或主表金额与明细不符 3.正在上传，4.其它错误，55、电子票号已用完)
	2.不需要调用开票的
	  2.1 查询开票结果表，返回开票信息的，不需要开票
	  2.2 查询发票信息主表，Scjg=1的，不需要开票
	*/		
	//1.组织开具接口入参
	s InputReqXml=..InvoiceData(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;InputReqXml
	
	//2.调用平台接口处理
	s ResultRtn=""
	s InvoiceRtn=..XMLPathData(ResultRtn,"/Response/ResultCode")
    q:InvoiceRtn'="0" RtnFlag
	
	///3.组织明细参数
	s InputDetailXML=..InvoiceDetailsData(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	
	//4.调用平台接口处理
	s DetailRtn=""
	s InvoiceRtn=..XMLPathData(DetailRtn,"/Response/ResultCode")
    q:InvoiceRtn'="0" RtnFlag
	
	///5.组织诊断参数
	s InputDiseXML=..InvoiceDiseData(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	
	//6.调用平台接口处理
	s DiseRtn=""
	s InvoiceRtn=..XMLPathData(DetailRtn,"/Response/ResultCode")
    q:InvoiceRtn'="0" RtnFlag
    
    s ObjInvUpDetail.Xstr5="Y"    ;;;存一个标志，是否推送成功过数据Y，推送成功，其他，未推送成功
	s RtnFlag=0
	q RtnFlag
}

/// 按照指定XML节点解析XMl节点值
/// w ##class(BILL.EINV.ADP.TBTCB).XMLPathData("<Response><ReturnCode>456</ReturnCode></Response>","/Response/ReturnCode")
ClassMethod XMLPathData(ResOutput As %String, XMlPathAddress As %String) As %String
{
	
	s tDocument="",RtnCode=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResOutput, .tDocument)
	s tRes=""
    //set tSC=tDocument.EvaluateExpression("/business/RESPONSE_COMMON_FPKJ/RETURNCODE","text()",.tRes)
    set tSC=tDocument.EvaluateExpression(XMlPathAddress,"text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set RtnCode=$tr(fieldValue,$c(0),"")	
	}
	q RtnCode
}

/// 功能说明：整理电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：guoyunlong  2022-06-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceData("","","") 
ClassMethod InvoiceData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{

	;s IPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceReq).%New()
	s InvoiceReqObj=##class(BILL.EINV.DTO.TBTCB.EInvComReq).%New()
	
	s InvoiceDataObj=##class(BILL.EINV.DTO.TBTCB.EInvComDataReq).%New()
	
	s InvoiceDataObj.Zid=""  /// Zid	自增id 号	Number	16	是
    s InvoiceDataObj.Organ=InvociePam.HospitalInfoMap.GetAt("Hosp_Code")   	///机构代码	Varchar	4	是
    s InvoiceDataObj.SettlementNo=ObjInvPrtInfo.InsuDivInfo.INPAYdjlsh0	///结算号	Varchar	32	是
    s InvoiceDataObj.SettlementTime=$tr(ObjInvPrtInfo.BusDate,"-","")_$tr(ObjInvPrtInfo.BusTime,":","")	///结算时间	Varchar	14	是yyyyMMddHHmmssSSS 年
    s InvoiceDataObj.Sjlx=$case(ObjInvUpDetail.IUDPayAdmType,"IP":"2",:"1")	///票据类型	Varchar	2	是1.门诊，2.住院
    ///测试暂时传1，项目确认上传来源，是否根据操作员判断
    s InvoiceDataObj.UploadSource="1"	  ///上传来源	Varchar	2	是   1.窗口结算 2.诊间结算 3.自助结算
    s InvoiceDataObj.RandomNumber=##class(BILL.EINV.COM.Common).CreateCheckeCode("6")	///校验码	Varchar	6	是 6 位随机数字校验码

    ////参数字典有矛盾，测试暂时传1
    s InvoiceDataObj.VisitType="1"	  ///就诊类型	Varchar	2	是1.成人及青少年 2.婴幼儿 3.急救 4.体检
    s InvoiceDataObj.Sickid=ObjInvPrtInfo.PatBaseInfo.PAPMINO	///病人信息ID	Varchar	32	是
    s InvoiceDataObj.Sfz=ObjInvPrtInfo.PatBaseInfo.PatID	/// 身份证号	Varchar	18	
    s InvoiceDataObj.Ybk=ObjInvPrtInfo.PatBaseInfo.CardNo   ;;ObjInvPrtInfo.PatBaseInfo.CardType	  ///医保卡号	Varchar	50	能 同
    s InvoiceDataObj.Jkk="" 	///健康卡号	Varchar	50	
    s InvoiceDataObj.Jzk=""	   ///就诊卡号	Varchar	50
    
    ////卡类型根据项目实际情况修改
    if ObjInvPrtInfo.PatBaseInfo.CardType="01"  d
    .s InvoiceDataObj.Ybk=""    ///医保卡号
    else  if ObjInvPrtInfo.PatBaseInfo.CardType="02"  d
    .s InvoiceDataObj.Jkk=""	///健康卡号
    else  if ObjInvPrtInfo.PatBaseInfo.CardType="03"  d
    .s InvoiceDataObj.Jzk=""	   ///就诊卡号
    s InvoiceDataObj.Hzh=""	///护照号	varchar	50	
    s InvoiceDataObj.Txz=""	///港澳通行证	varchar	50	
    s InvoiceDataObj.ZdyCardNo1=""	///自定义卡号 1	Varchar	50	
    s InvoiceDataObj.ZdyCardNo2=""	///自定义卡号 2	Varchar	50
    s InvoiceDataObj.CardRemark=""	///卡信息备注	Varchar	100	
    s InvoiceDataObj.MedicalInstitutionCode=""	///社会信用代码	Varchar	20
    s InvoiceDataObj.yljgbm=InvociePam.HospitalInfoMap.GetAt("yljgbm")	///医疗机构编码	Varchar	30	是	
    s InvoiceDataObj.MedicalInstitutionType=InvociePam.HospitalInfoMap.GetAt("MedicalInstitutionType")	///医疗机构类型	Varchar	20	是	
    s InvoiceDataObj.SiteName=""	///站点名称	Varchar	100		
    s InvoiceDataObj.VisitingDepartment=ObjInvPrtInfo.PatAdmInfo.DepDesc	///就诊科室	Varchar	20
    s InvoiceDataObj.CaseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode	///病历号	Varchar	20	是	
    s InvoiceDataObj.HospitalizationNo	=ObjInvPrtInfo.PatAdmInfo.IPNo    ///住院号,门诊号	Varchar	20	是	
    s InvoiceDataObj.SickName=ObjInvPrtInfo.PatBaseInfo.PatName	   ///就诊人姓名	Varchar	200	是	
    s InvoiceDataObj.Gender=ObjInvPrtInfo.PatBaseInfo.Sex	///性别	Varchar	10	是
    s InvoiceDataObj.MedicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	  ///医保类型	Varchar	30	是	
   if ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'=""  d
   .s InvoiceDataObj.SocialSecurityNumber=ObjInvPrtInfo.PatBaseInfo.PatID	///社会保障号码	Varchar	50	是
   else  d
   .s InvoiceDataObj.SocialSecurityNumber="无"	///社会保障号码	Varchar	50	是	
    s InvoiceDataObj.Headcust=""	///头部自定义域	Varchar	100	
    s InvoiceDataObj.Bodycust=""	///主体自定义域	Varchar	100	
    s InvoiceDataObj.CollectionUnit=""    /// 收款单位	Varchar	100	是
    s InvoiceDataObj.RecName=ObjInvPrtInfo.BusUserDesc	    ///收款人	Varchar	50	是
    s InvoiceDataObj.Pblx="1"	  ///票版类型	varchar	1	是
    s InvoiceDataObj.SYBXR1=""  ///本次赔付金额	Number	16,2
    s InvoiceDataObj.SYBXN1=""	///起付标准累计额	Number	16,2
    s InvoiceDataObj.SYBXN2=""		///累计金额	Number	16,2
    s InvoiceDataObj.SYBXR2=""	   /// 本次赔付金额	Number	16,2
    s InvoiceDataObj.SYBXN3=""		///起付标准累计额	Number	16,2
    s InvoiceDataObj.SYBXN4=""	   ///累计金额	Number	16,2
    s InvoiceDataObj.PayerPartyType=""	   ///交款人类型	Varchar	1	是
    s InvoiceDataObj.PayerPartyCode=""	   ///交款人代码	Varchar	30	是
    s InvoiceDataObj.Age=ObjInvPrtInfo.PatBaseInfo.Age	///年龄	Number	3		门 诊
    s InvoiceDataObj.MedicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate	  ///就诊日期	Varchar	20	必须
    s InvoiceDataObj.MedicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId	///医保编号	Varchar	30	是	
    s InvoiceDataObj.FundPayAmount	=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1   ///医保统筹基	Number	16,2
    s InvoiceDataObj.FundDJJZAmount=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5	///道交救助基金垫付	Number	16,2		
    s InvoiceDataObj.FundDJJZDept=""	///道交救助基金垫付机构	Varchar	200		
    s InvoiceDataObj.FundDJJZDate=""	///道交救助基金垫付日期	Varchar	20		
    s InvoiceDataObj.OtherPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay7	///其他支付	Number	16,2		
    s InvoiceDataObj.AccountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	///个人账户支付	Number	16,2		
    s InvoiceDataObj.OwnPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0	///个人现金支付	Number	16,2
    s InvoiceDataObj.SelfpaymentAmount=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt	///个人自负	Number	16,2
    s SelfpaymentCost=ObjInvPrtInfo.InsuDivInfo.selfPayAmt ///	个人自费	number	16,2
    s InvoiceDataObj.PhoneNumber=ObjInvPrtInfo.PatBaseInfo.Mobphone	  ///	手机号	Varchar	20	
    s InvoiceDataObj.FundPayAmountInfo=""	  ///	医保统筹基金支付说明	Varchar	500	
    s InvoiceDataObj.FundDJJZAmountInfo=""	  ///	道交救助基金垫付说明	Varchar	500	
    s InvoiceDataObj.OtherPayAmountInfo=""	  ///	其他支付说明	Varchar	500	
    s InvoiceDataObj.OwnPayAmountInfo=""	  ///	个人现金支付说明	Varchar	500	
    s InvoiceDataObj.SelfpaymentCare=""	  ///	个人自理	Number		16,2
    s InvoiceDataObj.PayMode=""	  ///	交款方式	Varchar	30	
    s InvoiceDataObj.BizCode=""	  ///	业务流水号	Varchar	32	是
    s InvoiceDataObj.CurrencyType=""	  ///	货币种类	Varchar	30	
    s InvoiceDataObj.ExchangeRate=""	  ///	汇率	Number
    s InvoiceDataObj.Checker=InvociePam.HospitalInfoMap.GetAt("FHR")	  ///	复核人	Varchar	20	是	
    s InvoiceDataObj.SupervisorRemark=""	  ///	财政部门备注	Varchar	500	
    s InvoiceDataObj.MedicalType=""	  ///	医疗类别	Varchar	30	是	
    s InvoiceDataObj.SocialSecurityCardNo=""	  ///	社保卡号	Varchar	50
    s InvoiceDataObj.Remark=""	  ///	备注	Varchar	500		记录写库当前服
    s InvoiceDataObj.Rksj=""	  ///	务器时间	Varchar	17	是	
    s InvoiceDataObj.Total=""	  ///	合计	Number	16,2	是
    s InvoiceDataObj.CashPayment=""	  ///	现金支付	Varchar	500	
    s InvoiceDataObj.PaymentThisYear=""	  ///	本年支付	Number	16,2
    s InvoiceDataObj.BalanceThisYear=""	  ///	本年余额	Number	16,2
    s InvoiceDataObj.PaymentLastYear=""	  ///	历年支付	Number	16,2
    s InvoiceDataObj.BalanceLastYear=""	  ///	历年余额	Number	16,2
    s InvoiceDataObj.MedicalInsuranceAccount=""	  ///	医保账户	Varchar	500	
    s InvoiceDataObj.Workplace=""	  ///	工作单位	Varchar	100		
    s InvoiceDataObj.BedNumber=ObjInvPrtInfo.PatAdmInfo.BedCode	  ///	床位号	Varchar	20
    s InvoiceDataObj.HospitalizationDate=ObjInvPrtInfo.PatAdmInfo.AdmDate	  ///	住院日期	Varchar	50	是
    s InvoiceDataObj.WesternMedicineFee=""	  ///	西药费	Number	16,2		西药费(其中自
    s InvoiceDataObj.SelfPayWesternMedicineFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.ChinesePatentMedicine=""	  ///	中成药	Number	16,2
    s InvoiceDataObj.SelfPayChinesePatentMedici=""	  ///	中成药(其中自ne	理自费)	Number	16,2
    s InvoiceDataObj.ChineseHerbalMedicine=""	  ///	中草药	Number	16,2
    s InvoiceDataObj.SelfPayChineseHerbalMedici=""	  ///	中草药(其中自ne	理自费)	Number	16,2
    s InvoiceDataObj.BedFee=""	  ///	床位费	Number	16,2		床位费(其中自	
    s InvoiceDataObj.SelfPayBedFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.DiagnosisFee=""	  ///	诊查费	Number	16,2		诊查费(其中自
    s InvoiceDataObj.SelfPayDiagnosisFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.InspectionFee=""	  ///	检查费	Number	16,2		检查费(其中自	
    s InvoiceDataObj.SelfPayInspectionFee=""	  ///	理自费)	Number	16,2	
    s InvoiceDataObj.ExamineFee=""	  ///	检验费	Number	16,2		检验费(其中自
    s InvoiceDataObj.SelfExamineFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.TreatmentFee=""	  ///	治疗费	Number
    s InvoiceDataObj.SelfPayTreatmentFee=""	  ///	治疗费(其中自	Number
    s InvoiceDataObj.OperationFee=""	  ///	手术费	Number	16,2		手术费(其中自
    s InvoiceDataObj.SelfPayOperationFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.BloodTransfusionFee=""	  ///	输血费	Number	16,2		输血费(其中自
    s InvoiceDataObj.SelfPayBloodTransfusionFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.NursingFee=""	  ///	护理费	Number	16,2		护理费(其中自
    s InvoiceDataObj.SelfPayNursingFee=""	  ///	理自费)	Number	16,2	
    s InvoiceDataObj.MaterialFee=""	  ///	材料费	Number	16,2		材料费(其中自
    s InvoiceDataObj.SelfPayMaterialFee=""	  ///	理自费)	Number	16,2
    s InvoiceDataObj.OtherFee=""	  ///	其它	Number	16,2		其它(其中自理
    s InvoiceDataObj.SelfPayOtherFee=""	  ///	自费)	Number	16,2		合计(其中自理
    s InvoiceDataObj.SelfPayTotal=""	  ///	自费)	Number	16,2
    s InvoiceDataObj.Cash=""	  ///	现金(支票)	Number	16,2
    s InvoiceDataObj.ThisYearAccount=""	  ///	本年账户	Number	16,2
    s InvoiceDataObj.LastYearAccount=""	  ///	历年账户	Number	16,2
    s InvoiceDataObj.InsuranceAccount=""	  ///	医保账户	Number	16,2
    s InvoiceDataObj.SettlementTotal=""	  ///	(结算信息)合计	Number	16,2
    s InvoiceDataObj.AdvancepPayment=""	  ///	预缴款	Number	16,2
    s InvoiceDataObj.PayBack=ObjInvPrtInfo.RecAmt	  ///	补缴	Number	16,2		( 缴款) 其中: 现
    s InvoiceDataObj.PayBackCash=""	  ///	金	Number	16,2		( 缴款) 其中: 支
    s InvoiceDataObj.PayBackCheck=""	  ///	票	Number	16,2		
    s InvoiceDataObj.Refund=ObjInvPrtInfo.RefAmt	  ///	退款	Number	16,2		( 退款) 其中: 现
    s InvoiceDataObj.RefundCash	=""	  ///金	Number	16,2	
    s InvoiceDataObj.Payee=""	  ///	领款人	Varchar	50		收费项目名称自	
    s InvoiceDataObj.ItemNameCust1=""	  ///	定义 1	Varchar	50		收费项目金额自	
    s InvoiceDataObj.ItemMoneyCust1=""	  ///	定义 1	Number	16,2		收费项目自理自
    s InvoiceDataObj.SelfPayItemMoneyCust1=""	  ///	费自定义 1	Number	16,2		收费项目名称自	
    s InvoiceDataObj.ItemNameCust2=""	  ///	定义 2	Varchar	50		
    s InvoiceDataObj.ItemMoneyCust2=""	  ///	收费项目金额自定义 2	Number	16,2
    s InvoiceDataObj.SelfPayItemMoneyCust2=""	  ///	收费项目自理自费自定义 2	Number	16,2		
    s InvoiceDataObj.ItemNameCust3=""	  ///	收费项目名称自定义 3	Varchar	50		
    s InvoiceDataObj.ItemMoneyCust3=""	  ///	收费项目金额自定义 3	Number	16,2		
    s InvoiceDataObj.SelfPayItemMoneyCust3=""	  ///	收费项目自理自费自定义 3	Number	16,2		
    s InvoiceDataObj.ItemNameCust4=""	  ///	收费项目名称自定义 4	Varchar	50		
    s InvoiceDataObj.ItemMoneyCust4=""	  ///	收费项目金额自定义 4	Number	16,2		
    s InvoiceDataObj.SelfPayItemMoneyCust4=""	  ///	收费项目自理自自定义 4	Number	16,2		
    s InvoiceDataObj.ItemNameCust5=""	  ///	收费项目名称自定义 5	Varchar	50		
    s InvoiceDataObj.ItemMoneyCust5=""	  ///	收费项目金额自定义 5	Number	16,2		
    s InvoiceDataObj.SelfPayItemMoneyCust5=""	  ///	收费项目自理自费自定义 5	Number	16,2		
    s InvoiceDataObj.SettleItemNameCust1=""	  ///	结算项目名称自定义 1	Varchar	50		
    s InvoiceDataObj.SettleItemMoneyCust1=""	  ///	结算项目金额自定义 1	Number	16,2		
    s InvoiceDataObj.SettleItemNameCust2=""	  ///	 结算项目名称自定义 2	Varchar	50		
    s InvoiceDataObj.SettleItemMoneyCust2=""	  ///	结算项目金额自定义 2	Number	16,2		
    s InvoiceDataObj.SettleItemNameCust3=""	  ///	 结算项目名称自定义 3	Varchar	50		
    s InvoiceDataObj.SettleItemMoneyCust3=""	  ///	结算项目金额自定义 3	Number	16,2		
    s InvoiceDataObj.PayBackCust=""	  ///	补缴自定义：银行卡	Number	16,2		
    s InvoiceDataObj.PayBackMoneyCust=""	  ///		补缴金额自定退款自定义：银义：银行卡	Number	16,2		
    s InvoiceDataObj.RefundCust=""	  ///	行卡	Number	16,2		
    s InvoiceDataObj.RefundMoneyCust=""	  ///	退款金额自定义：银行卡	Number	16,2
    s InvoiceDataObj.PayeeCust=""	  ///	领款人处自定义;支票	Number	16,2
    s InvoiceDataObj.PayeeMoneyCust=""	  ///	领款人处金额自	Number	16,2
    s InvoiceDataObj.PayBackAlipay=""	  ///	补缴支付宝 补缴智慧医疗账		Number	16,2		
    s InvoiceDataObj.PayBackSmartMedical=""	  ///	户	Number	16,2		
    s InvoiceDataObj.RefundAlipay=""	  ///	退款支付宝 退款智慧医疗账	Number	16,2		
    s InvoiceDataObj.RefundSmartMedical=""	  ///	户	Number	16,2		
    s InvoiceDataObj.HospitalTemplate=""	  ///	医院自定义模板	Varchar	2		
    ///s InvoiceDataObj.Scjg=""	  ///	上传结果	Varchar	2		
    ///s InvoiceDataObj.Zwcwxx	=""	  ///中文错误信息	Varchar	200		
    ///s InvoiceDataObj.Sccs=""	  ///	上传次数	Number	2	是	
    s InvoiceDataObj.Dzjg=""	  ///	订正结果默认数据库服务	Varchar	2		
    s InvoiceDataObj.Autotime=""	  ///	器时间	date			
    s InvoiceDataObj.Entercode=""	  ///	执收单位编码	Varchar	20	是
    
    s InvoiceReqObj.Data=InvoiceDataObj			
    s ReqInputXml=""
	d InvoiceReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	
    q ReqInputXml
}

/// 功能说明：组织电子票据明细参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：guoyunlong  2022-06-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceData("","","") 
ClassMethod InvoiceDetailsData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s EInvDetailListObj=##class(BILL.EINV.DTO.TBTCB.EInvDetailList).%New()
	
	s EInvDetailsObj=##class(BILL.EINV.DTO.TBTCB.EInvDetails).%New()
	
	;;;业务类型
	s LogicType=ObjInvUpDetail.IUDPayAdmType
	s Sjlx=$case(LogicType,"IP":"2",:"1")
	for index=1:1:ObjInvPrtInfo.InvItmDetInfo.Size   d
	.s EInvDetailsObj.Zid=""  /// Zid	自增id 号	Number	16	是
    .s EInvDetailsObj.Organ=InvociePam.HospitalInfoMap.GetAt("Hosp_Code")   	///机构代码	Varchar	4	是财政分配Organ+ SettlementNo
    .s EInvDetailsObj.SettlementNo=ObjInvUpDetail.IUDBusNo   	///结算号	Varchar	32	是	建主索引
    .s EInvDetailsObj.Sjlx=Sjlx  	///	票据类型	Varchar	2	是	1.门诊，2.住院	
    .s EInvDetailsObj.ItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).CateCode	///	收费项目 代码	Varchar	20	是	医疗收费项目信息 T_YLSFXMXX 中对应的 ItemCode 收费大类代码(财政)
    .s EInvDetailsObj.ItemExtClassName=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).CateDesc   	///	收费项目 名称	Varchar	200	是	医疗收费项目信息 T_YLSFXMXX 中对应的 Itemname 收费大类名称（如：治疗费）
    .s EInvDetailsObj.ItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Qty  	///	数量	Number	16,4	是	
    .s EInvDetailsObj.ItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Unit   	///	计量单位	Varchar	20
    .s EInvDetailsObj.ItemStd="" ;ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Unit  	///	标准	Number	16,4	是	
    .s EInvDetailsObj.ItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Amt   	///	金额	Number	16,2	是	收费明细项目编码需要使用浙江省统一的医保目录编码（药品、诊疗、服务），无论是否进医保或者自费都一样，统一使用医保目录编码
    /// ，除医保目录内没有可对应的编码外，不可对应自费通用编码，具体咨询 his 或者医院医保部门。
    .s EInvDetailsObj.ItemExtId=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).TarCode   	///	收费明细项目编码	Varchar	30	是	
    .s EInvDetailsObj.ItemExtClassId=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Insuxmlb   	///	项目类别 ID	Varchar	32	是
    .s EInvDetailsObj.ItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).TarDesc   	///	收费明细项目名称	Varchar	100	是	需与医保结算系统编码一致
    .s EInvDetailsObj.ItemExtClassify=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Insutjdm  	///	类	Varchar	20	是	收费明细项目对应的“类”甲 乙 丙
    .s EInvDetailsObj.ItemExtSelfPay=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).SelfAmt   	///	自理自费 金额	Number	16,2	是	
    .s EInvDetailsObj.ItemExtSelfProportion=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).InsuScale   	///	自理自费 比率	Number	16,2	是	
    .s EInvDetailsObj.ItemExtAccountCode=""   	///	会计科目代码	Varchar	20	
    .s EInvDetailsObj.ItemExtAccountName=""   	///	会计科目名称	Varchar	200	
    .s EInvDetailsObj.ItemExtDeptName=""   	///	开单科室名称	Varchar	200	
    .s EInvDetailsObj.ItemExtDeptAccountCode=""   	///	科室核算码	Varchar	20
    .s EInvDetailsObj.ItemExtDeptAccountName=""   	///	科室核算码名称	Varchar	200	
    .s EInvDetailsObj.ItemExtExcuteDeptName=""   	///	执行科室 名称	Varchar	200	
    .s EInvDetailsObj.ItemExtDrawer=""   	///	开单人	Varchar	50
    .s EInvDetailsObj.ItemExtExecutor=""   	///	执行人	Varchar	50
    .s EInvDetailsObj.Rksj=##class(BILL.EINV.BL.COM.Common).GetBusDate(+$h,$p($h,",",2))  ///	记录写库 当前时间	Varchar	17	是	yyyyMMddHHmmssSSS年月日时分秒毫秒
    .s EInvDetailsObj.Itemtype=""   	///	项目类型	Varchar	1	是	1、财政主项目传“0”；2、明细(医保)子项目传“1” 。
    .s EInvDetailsObj.Remark=ObjInvPrtInfo.InvItmDetInfo.GetAt(index).Remark  	///	项目备注	Varchar	500	
    .s EInvDetailsObj.Autotime=$zd(+$h,3)_"-"_$zt($p($h,",",2),1)   	///	默认数据 库服务器 时间	date			Yyyy-mm-dd-hh:mm:ss
    .d EInvDetailListObj.Details.Insert(EInvDetailsObj)
    s ReqInputXml=""
	d EInvDetailListObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	
    q ReqInputXml
}

/// 功能说明：组织电子票据诊断参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：guoyunlong  2022-06-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceData("","","") 
ClassMethod InvoiceDiseData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s EInvDiseInfoListObj=##class(BILL.EINV.DTO.TBTCB.EInvDiseInfoList).%New()
	s EInvDiseInfo=##class(BILL.EINV.DTO.TBTCB.EInvDiseInfo).%New()
	for index=1:1:ObjInvPrtInfo.DiagnosisInfo.Size   d
	 .s EInvDiseInfo.SETTLEMNTNO=ObjInvUpDetail.IUDBusNo	  ///结算号	Varchar	30	是	Organ+ SettlementNo关键字唯一，建主索引
     .s EInvDiseInfo.ORGAN=""	  ///	机构代码	Varchar	4	是	财政分配
     .s EInvDiseInfo.DIAGNOSISCODE=ObjInvPrtInfo.DiagnosisInfo.GetAt(index).DiagnosICDCode	  ///	诊断编码	Varchar	50	是	没有诊断信息统一传 “无”, 针对基层医疗机构或者疾病诊断不 明确（挂号、急救等）的情况下：
     .///保持现在疾病诊断列表必传的要 求，遇到不明确的情况下，统一疾病诊断编码传“0”，疾病诊断名称传“未知”。
     .s EInvDiseInfo.DIAGNOSISNAME=ObjInvPrtInfo.DiagnosisInfo.GetAt(index).DiagnosDesc	  ///	诊断名称	Varchar	128	是	
     .s EInvDiseInfo.REMARK=ObjInvPrtInfo.DiagnosisInfo.GetAt(index).DiagStat	  ///	备注	Varchar	200			
     .d EInvDiseInfoListObj.Details.Insert(EInvDiseInfo)
    s ReqInputXml=""
	d EInvDiseInfoListObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoice -1
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.EbillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.EbillNo			;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=+$h									;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.EinvprtNo=VoucherResultObj.EbillBatchCode_VoucherResultObj.EbillNo  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=InvoiceResObj.Head.MsgNo
	s ObjInvUpDetail.Xstr2=VoucherResultObj.SettlementNo	;结算号
	b ;SetInvResultOfInvoice -2
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInitResult("","") 
ClassMethod DecryptionInitResult(XMLRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.InitMsgVoucherResult) As %String
{
	s rtn="-1"
	
	//s XMLRes="<?xml version='1.0' encoding='UTF-8'?><Invoice><Head><MsgNo>5901</MsgNo><Version>1.0</Version><AppId>KPQZDWB5629411</AppId><MsgId>20190703105001999</MsgId><MsgRef>20190703105000000</MsgRef><DateTime>20190703105001999</DateTime><Reserve></Reserve></Head><Msg>PFZvdWNoZXI+PEFjY2Vzc1Rva2VuPmFhYWFiYmJiYjExMTExMzMzMzMzPC9BY2Nlc3NUb2tlbj48RXhwaXJlc0luPjcyMDA8L0V4cGlyZXNJbj48L1ZvdWNoZXI+</Msg></Invoice>"
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	//1.将报文头xml转换为对象
	s InitResObj=##class(BILL.EINV.DTO.TBTCA.InitRes).%New()
	s InitRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.InitRes", .InitResObj)
	q:InitRtn'="0" rtn
	;b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InitResObj.Msg,"UTF8")
	;b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.InitMsgVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.InitMsgVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	;b ;3   VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
    q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoiceStutas(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoiceStutas
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.EbillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.EbillNo			;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.EinvprtNo=VoucherResultObj.EbillBatchCode_VoucherResultObj.EbillNo  ;发票编码+发票号码
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s createTime=VoucherResultObj.EbillingTime
	s createDateTime=$e(createTime,1,$l(createTime)-3)
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	s ObjInvUpDetail.IUDCreatDate=createDate								;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=createTime							;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.IUDResultCode="0000"
	s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalidStutas(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoiceStutas
	//对返回结果的时间戳进行分割
	i VoucherResultObj.EbillChargeOffStatus="1" d			;保存红票信息
	.s createTime=VoucherResultObj.EbillChargeOffTime
	.s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.CancelEbillBatchCode		;红票票据编码
	.s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.CancelEbillNo			;红票票据号码
	.s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;红票校验码
	.s ObjInvUpDetail.EinvprtNo=VoucherResultObj.CancelEbillBatchCode_VoucherResultObj.CancelEbillNo  ;发票编码+发票号码
	.s ObjInvUpDetail.EInvFlg="S"										;发票状态
	.s createDateTime=$e(createTime,1,$l(createTime)-3)
	.s createDate=$zdh($e(createDateTime,1,8),8)
	.s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	.s ObjInvUpDetail.IUDCreatDate=createDate								;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=createTime							;电子票据生成时间
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	.s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	.s ObjInvUpDetail.IUDResultCode="0000"
	.s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	.s RtnFlg="0"
	e  d
	.s RtnFlg="-1"
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	
	q RtnFlg
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInvalidResult("","") 
ClassMethod DecryptionInvalidResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult) As %String
{
	s rtn="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult开始.")
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	;b ;0
	//1.将报文头xml转换为对象
	;s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceRes).%New()
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3  VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult结束.")
    q rtn
}

}
