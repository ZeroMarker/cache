/// 住院开具发票业务入参组织对象
Class BILL.EINV.DTO.BSA.IPInvoiceReq Extends %RegisteredObject
{

/// 业务流水号
Property busNo As %String(TRUNCATE = 1, XMLNAME = "busNo");

/// 业务标识
Property busType As %String(TRUNCATE = 1, XMLNAME = "busType");

/// 患者姓名
Property payer As %String(TRUNCATE = 1, XMLNAME = "payer");

/// 业务发生时间：yyyyMMddHHmmssSSS
Property busDateTime As %String(TRUNCATE = 1, XMLNAME = "busDateTime");

/// 开票点编码
Property placeCode As %String(TRUNCATE = 1, XMLNAME = "placeCode");

/// 收费员
Property payee As %String(TRUNCATE = 1, XMLNAME = "payee");

/// 票据编制人
Property author As %String(TRUNCATE = 1, XMLNAME = "author");

/// 开票总金额
Property totalAmt As %String(TRUNCATE = 1, XMLNAME = "totalAmt");

/// 备注
Property remark As %String(TRUNCATE = 1, XMLNAME = "remark");

/// 患者支付宝账户
Property alipayCode As %String(TRUNCATE = 1, XMLNAME = "alipayCode");

/// 微信支付订单号
Property weChatOrderNo As %String(TRUNCATE = 1, XMLNAME = "weChatOrderNo");

/// 微信公众号或者小程序ID
Property openID As %String(TRUNCATE = 1, XMLNAME = "openID");

/// 缴款人手机号或电话号码
Property tel As %String(TRUNCATE = 1, XMLNAME = "tel");

/// 患者邮箱地址
Property email As %String(TRUNCATE = 1, XMLNAME = "email");

/// 患者身份证号码
Property idCardNo As %String(TRUNCATE = 1, XMLNAME = "idCardNo");

/// 卡类型
Property cardType As %String(TRUNCATE = 1, XMLNAME = "cardType");

/// 卡号
Property cardNo As %String(TRUNCATE = 1, XMLNAME = "cardNo");

/// 医保类型名称
Property medicalCareType As %String(TRUNCATE = 1, XMLNAME = "medicalCareType");

/// 医疗机构类型
Property medicalInstitution As %String(TRUNCATE = 1, XMLNAME = "medicalInstitution");

/// 医保类型编码
Property medCareTypeCode As %String(TRUNCATE = 1, XMLNAME = "medCareTypeCode");

/// 医保机构编码
Property medCareInstitution As %String(TRUNCATE = 1, XMLNAME = "medCareTypeCode");

/// 人员类别
Property payerType As %String(TRUNCATE = 1, XMLNAME = "payerType");

/// 入院科室名称
Property category As %String(TRUNCATE = 1, XMLNAME = "category");

/// 入院科室编码
Property categoryCode As %String(TRUNCATE = 1, XMLNAME = "categoryCode");

/// 出院科室名称
Property leaveCategory As %String(TRUNCATE = 1, XMLNAME = "leaveCategory");

/// 出院科室编码
Property leaveCategoryCode As %String(TRUNCATE = 1, XMLNAME = "leaveCategoryCode");

/// 患者住院号
Property hospitalNo As %String(TRUNCATE = 1, XMLNAME = "hospitalNo");

///  住院就诊编号
Property visitNo As %String(TRUNCATE = 1, XMLNAME = "visitNo");

/// 患者唯一ID
Property patientId As %String(TRUNCATE = 1, XMLNAME = "patientId");

///  患者就诊编号
Property patientNo As %String(TRUNCATE = 1, XMLNAME = "patientNo");

/// 性别
Property sex As %String(TRUNCATE = 1, XMLNAME = "sex");

/// 年龄
Property age As %String(TRUNCATE = 1, XMLNAME = "age");

/// 病区
Property hospitalArea As %String(TRUNCATE = 1, XMLNAME = "hospitalArea");

/// 床号
Property bedNo As %String(TRUNCATE = 1, XMLNAME = "bedNo");

/// 病历号
Property caseNumber As %String(TRUNCATE = 1, XMLNAME = "caseNumber");

/// 住院日期
Property inHospitalDate As %String(TRUNCATE = 1, XMLNAME = "inHospitalDate");

/// 出院日期
Property outHospitalDate As %String(TRUNCATE = 1, XMLNAME = "outHospitalDate");

/// 住院天数
Property hospitalDays As %String(TRUNCATE = 1, XMLNAME = "hospitalDays");

/// 预交金凭证消费扣款列表
Property payMentVoucher As list Of BILL.EINV.DTO.BSA.IPPayMentVoucher(XMLNAME = "payMentVoucher");

/// 个人账户支付
Property accountPay As %String(TRUNCATE = 1, XMLNAME = "accountPay");

/// 医保统筹基金支付
Property fundPay As %String(TRUNCATE = 1, XMLNAME = "fundPay");

/// 其它医保支付
Property otherfundPay As %String(TRUNCATE = 1, XMLNAME = "otherfundPay");

/// 个人自费金额
Property ownPay As %String(TRUNCATE = 1, XMLNAME = "ownPay");

/// 个人自负
Property selfConceitedAmt As %String(TRUNCATE = 1, XMLNAME = "selfConceitedAmt");

/// 个人自付
Property selfPayAmt As %String(TRUNCATE = 1, XMLNAME = "selfPayAmt");

/// 个人现金支付
Property selfCashPay As %String(TRUNCATE = 1, XMLNAME = "selfCashPay");

/// 现金预交款金额
Property cashPay As %String(TRUNCATE = 1, XMLNAME = "cashPay");

/// 支票预交款金额
Property chequePay As %String(TRUNCATE = 1, XMLNAME = "chequePay");

/// 转账预交款金额
Property transferAccountPay As %String(TRUNCATE = 1, XMLNAME = "transferAccountPay");

/// 补交金额(现金)
Property cashRecharge As %String(TRUNCATE = 1, XMLNAME = "cashRecharge");

/// 补交金额(支票)
Property chequeRecharge As %String(TRUNCATE = 1, XMLNAME = "chequeRecharge");

/// 补交金额(转账)
Property transferRecharge As %String(TRUNCATE = 1, XMLNAME = "transferRecharge");

/// 退还金额(现金)
Property cashRefund As %String(TRUNCATE = 1, XMLNAME = "cashRefund");

/// 退还金额(支票)
Property chequeRefund As %String(TRUNCATE = 1, XMLNAME = "chequeRefund");

/// 退还金额(转账)
Property transferRefund As %String(TRUNCATE = 1, XMLNAME = "transferRefund");

/// 个人账户余额
Property ownAcBalance As %String(TRUNCATE = 1, XMLNAME = "ownAcBalance");

/// 报销总金额
Property reimbursementAmt As %String(TRUNCATE = 1, XMLNAME = "reimbursementAmt");

/// 结算号
Property balanceNumber As %String(TRUNCATE = 1, XMLNAME = "balanceNumber");

/// 患者医保编号
Property medicalInsuranceID As %String(TRUNCATE = 1, XMLNAME = "medicalInsuranceID");

/// 其他扩展信息列表
Property otherInfo As list Of BILL.EINV.DTO.BSA.IPOtherInfo(XMLNAME = "otherInfo");

/// 其它医保信息列表
Property otherMedicalList As list Of BILL.EINV.DTO.BSA.IPOtherMedicalList(XMLNAME = "otherMedicalList");

/// 交费渠道
Property payChannelDetail As list Of BILL.EINV.DTO.BSA.IPPayChannelDetail(XMLNAME = "payChannelDetail");

/// 业务票据关联号
Property eBillRelateNo As %String(TRUNCATE = 1, XMLNAME = "eBillRelateNo");

/// 是否可流通
Property isArrears As %String(TRUNCATE = 1, XMLNAME = "isArrears");

/// 不可流通原因
Property arrearsReason As %String(TRUNCATE = 1, XMLNAME = "arrearsReason");

/// 收费项目明细
Property chargeDetail As list Of BILL.EINV.DTO.BSA.IPChargeDetail(XMLNAME = "chargeDetail");

/// 清单项目明细
Property listDetail As list Of BILL.EINV.DTO.BSA.IPListDetail(XMLNAME = "listDetail");

}
