/// 电子票据开具接口入参组织对象
Class BILL.EINV.DTO.BSA.OPInvoiceReq Extends %RegisteredObject
{

/// 票据信息
Property busNo As %String(CAPTION = "业务流水号");

Property busType As %String(CAPTION = "业务标识");

Property payer As %String(CAPTION = "患者姓名");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property placeCode As %String(CAPTION = "开票点编码");

Property payee As %String(CAPTION = "收费员");

Property author As %String(CAPTION = "票据编制人");

Property totalAmt As %String(CAPTION = "开票总金额");

Property remark As %String(CAPTION = "备注");

/// 缴费信息
Property alipayCode As %String(CAPTION = "患者支付宝账户");

Property weChatOrderNo As %String(CAPTION = "微信支付订单号");

Property openID As %String(CAPTION = "微信公众号或小程序用户ID");

/// 通知信息
Property tel As %String(CAPTION = "患者手机号码");

Property email As %String(CAPTION = "患者邮箱地址");

Property payerType As %String(CAPTION = "交款人类型");

Property idCardType As %String(CAPTION = "证件类型");

Property idCardNo As %String(CAPTION = "患者身份证号码");

Property cardType As %String(CAPTION = "卡类型");

Property cardNo As %String(CAPTION = "卡号");

/// 就诊信息
Property medicalInstitution As %String(CAPTION = "医疗机构类型");

Property medCareInstitution As %String(CAPTION = "医保机构编码");

Property medCareTypeCode As %String(CAPTION = "医保类型编码");

Property medicalCareType As %String(CAPTION = "医保类型名称");

Property medicalInsuranceID As %String(CAPTION = "患者医保编号");

Property medCareAreaCode As %String(CAPTION = "医保行政区划码");

Property chargeDate As %String(CAPTION = "缴费日期");

Property consultationDate As %String(CAPTION = "就诊日期");

Property patientCategory As %String(CAPTION = "就诊科室");

Property patientCategoryCode As %String(CAPTION = "就诊科室编码");

Property patientNo As %String(CAPTION = "患者就诊编号");

Property patientId As %String(CAPTION = "患者唯一ID");

Property sex As %String(CAPTION = "性别");

Property age As %String(CAPTION = "年龄");

Property caseNumber As %String(CAPTION = "病历号");

Property ICD As %String(CAPTION = "疾病编码");

Property specialDiseasesName As %String(CAPTION = "特殊病种名称");

/// 费用信息
Property accountPay As %String(CAPTION = "个人账户支付");

Property fundPay As %String(CAPTION = "医保统筹基金支付");

Property otherfundPay As %String(CAPTION = "其它医保支付");

Property ownPay As %String(CAPTION = "自费金额");

Property selfConceitedAmt As %String(CAPTION = "个人自负");

Property selfPayAmt As %String(CAPTION = "个人自付");

Property selfCashPay As %String(CAPTION = "个人现金支付");

Property cashPay As %String(CAPTION = "现金预交款金额");

Property chequePay As %String(CAPTION = "支票预交款金额");

Property transferAccountPay As %String(CAPTION = "转账预交款金额");

Property cashRecharge As %String(CAPTION = "补交金额(现金)");

Property chequeRecharge As %String(CAPTION = "补交金额(支票)");

Property transferRecharge As %String(CAPTION = "补交金额（转账）");

Property cashRefund As %String(CAPTION = "退还金额(现金)");

Property chequeRefund As %String(CAPTION = "退交金额(支票)");

Property transferRefund As %String(CAPTION = "退交金额(转账)");

Property ownAcBalance As %String(CAPTION = "个人账户余额");

Property reimbursementAmt As %String(CAPTION = "报销总金额");

Property balancedNumber As %String(CAPTION = "结算号");

Property otherInfo As list Of BILL.EINV.DTO.BSA.OPOtherInfo(CAPTION = "其它扩展信息列表");

Property otherMedicalList As list Of BILL.EINV.DTO.BSA.OPOtherMedicalList(CAPTION = "其它医保信息列表");

Property payChannelDetail As list Of BILL.EINV.DTO.BSA.OPPayChannelDetail(CAPTION = "交费渠道列表");

/// 其它
Property eBillRelateNo As %String(CAPTION = "业务票据关联号");

Property isArrears As %String(CAPTION = "是否可流通");

Property arrearsReason As %String(CAPTION = "不可流通原因");

/// 项目
Property chargeDetail As list Of BILL.EINV.DTO.BSA.OPChargeDetail(CAPTION = "收费项目明细");

Property listDetail As list Of BILL.EINV.DTO.BSA.OPListDetail(CAPTION = "清单项目明细");

}
