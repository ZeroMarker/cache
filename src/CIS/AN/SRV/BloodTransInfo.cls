/// 输血配血信息
Class CIS.AN.SRV.BloodTransInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 血袋条码编号
Property BarCode As %String;

/// 患者住院号
Property InpatNo As %String;

/// 患者姓名
Property PatName As %String;

/// 患者性别
Property PatGender As %String;

/// 患者年龄
Property PatAge As %String;

/// 患者ABO血型(复检)
Property PatABO As %String;

/// 患者RH血型(复检)
Property PatRH As %String;

/// 复检人工号
Property RetestProv As %String;

/// 复检人姓名
Property RetestProvDesc As %String;

/// 储血编码
Property TransCode As %String;

/// 输血血型
Property TransABO As %String;

/// 血液种类
Property BloodSpecies As %String;

/// 血量
Property BloodVolume As %String;

/// 血量单位
Property BloodVolumeUnit As %String;

/// 交叉配血（盐水+聚凝胺+镜检）
Property CrossMatching As %String;

/// 配血者工号
Property MatchingProv As %String;

/// 配血者姓名
Property MatchingProvDesc As %String;

/// 配血日期时间
Property MatchingDT As %String;

/// 发血者工号
Property DispenseProv As %String;

/// 发血者姓名
Property DispenseProvDesc As %String;

/// 取血者工号
Property BloodTaker As %String;

/// 取血者姓名
Property BloodTakerDesc As %String;

/// 取血日期时间
Property BloodTakeDT As %String;

/// 输血执行者工号
Property TransProv As %String;

/// 输血执行者姓名
Property TransProvDesc As %String;

/// 输血核对者工号
Property TransChecker As %String;

/// 输血核对者姓名
Property TransCheckerDesc As %String;

/// 输血开始日期时间
Property TransStartDT As %String;

/// 输血结束日期时间
Property TransEndDT As %String;

}
