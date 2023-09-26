/// 医保结算信息表
Class BILL.EINV.DTO.COM.InsuDivideInfo Extends %RegisteredObject
{

///  人员类别
Property PatType As %String(CAPTION = "人员类别");

/// 患者医保编号(参保人在医保系统中的唯一标识(医保号))
Property InsuId As %String(CAPTION = "患者医保编号");

///  医疗机构类型
Property HospitalType As %String(CAPTION = "医疗机构类型");

///  医保机构编码
Property HospitalNo As %String(CAPTION = "医保机构编码");

/// 医保类型编码
Property InsuTypeCode As %String(CAPTION = "医保类型编码");

///  医保类型名称
Property InsuTypeDesc As %String(CAPTION = "医保类型名称");

///  报销总金额(基金支付)
Property INPAYjjzfe0 As %Library.Float(CAPTION = "基金支付额");

///  个人账户支付
Property INPAYzhzfe0 As %Library.Float(CAPTION = "个人账户支付");

///  个人现金支付
Property INPAYgrzfe0 As %Library.Float(CAPTION = "个人现金支付");

///  医保统筹基金支付
Property INPAYInsuPay1 As %String(CAPTION = "医保统筹基金支付");

///  大病基金支付
Property INPAYInsuPay2 As %String(CAPTION = "医保大病基金支付");

///  公务员基金支付
Property INPAYInsuPay3 As %String(CAPTION = "医保公务员基金支付");

///  民政救助基金支付
Property INPAYInsuPay4 As %String(CAPTION = "民政救助基金支付");

///  离休基金支付
Property INPAYInsuPay5 As %String(CAPTION = "离休基金支付");

///  自费补充支付
Property INPAYInsuPay6 As %String(CAPTION = "自费补充支付");

/// 二乙基金支付
Property INPAYInsuPay7 As %String(CAPTION = "二乙基金支付");

///  军转基金支付
Property INPAYInsuPay8 As %String(CAPTION = "军转基金支付");

///  医院垫付
Property INPAYInsuPay9 As %String(CAPTION = "医院垫付");

///  医保误差（HIS总费用与医保返回数据的误差）
Property INPAYInsuPay10 As %String(CAPTION = "医保误差");

/// 自费金额(患者本次就医所发生的医疗费用中按照有关规定不属于基本医疗保险目录范围而全部由个人支付的费用;如无金额，填写0)
Property SelfAmt As %String(CAPTION = "自费金额");

/// 个人自负(医保患者起付标准内个人支付费用)
Property selfConceitedAmt As %String(CAPTION = "个人自负");

/// 个人自付(患者本次就医所发生的医疗费用中由个人负担的属于基本医疗保险目录范围内自付部分的金额；
/// 开展按病种、病组、床日等打包付费方式且由患者定额付费的费用。)
Property selfPayAmt As %String(CAPTION = "个人自付");

///  个人账户余额
Property INPAYZstr23 As %String(CAPTION = "个人账户余额");

/// 结算号
Property INPAYdjlsh0 As %String(CAPTION = "结算号");

/// 结算状态
Property INPAYFlag As %String(CAPTION = "结算状态");

Property CardNo As %String(CAPTION = "医保卡号");

/// 其它医保信息列表(暂时放到一个字符串里面)
/// Property OtherInsuInfo As %String(CAPTION = "其它医保信息列表");
/// 参保地区 add by xubaobao 2020 11 08
Property CenterNo As %String(CAPTION = "参保地区");

Property qfx As %Library.Float(CAPTION = "起付线");

///  符合政策范围金额
Property INPAYZstr26 As %String(CAPTION = "符合政策范围金额");

///  先行自付金额
Property INPAYZstr13 As %String(CAPTION = "先行自付金额");

///  超限价自费费用
Property INPAYZstr14 As %String(CAPTION = "超限价自费费用");

///  基本医疗保险统筹基金支付比例
Property INPAYZstr24 As %String(CAPTION = "基本医疗保险统筹基金支付比例");

///  个人账户共济支付金额
Property INPAYZstr21 As %String(CAPTION = "个人账户共济支付金额");

///  个人负担总金额
Property INPAYZstr22 As %String(CAPTION = "个人负担总金额");

}
