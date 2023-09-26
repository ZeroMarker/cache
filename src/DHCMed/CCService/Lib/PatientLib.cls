/// 患者基本信息类
/// 创建者：李阳
/// 创建日期：2010-10-08
Class DHCMed.CCService.Lib.PatientLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 返回病人的ID
ClassMethod Papmi()
{
		n (%Patient)
		q %Patient.Papmi
}

/// 返回病人的姓名
ClassMethod PatientName()
{
		n (%Patient)
		q %Patient.PatientName
}

/// 病人就诊卡号码
ClassMethod PapmiNo()
{
		n (%Patient)
		q %Patient.PapmiNo
}

/// 性别
ClassMethod Sex()
{
		n (%Patient)
		q %Patient.Sex
}

/// 出生日期
ClassMethod Birthday()
{
		n (%Patient)
		q %Patient.Birthday
}

/// 年龄(年)
ClassMethod Age()
{
		n (%Patient)
		q %Patient.Age
}

/// 年龄(月)
ClassMethod AgeMonth()
{
		n (%Patient)
		q %Patient.AgeMonth
}

/// 年龄(日)
ClassMethod AgeDay()
{
		n (%Patient)
		q %Patient.AgeDay
}

/// 身份证号码
ClassMethod PersonalID()
{
		n (%Patient)
		q %Patient.PersonalID
}

/// 省
ClassMethod Province()
{
		n (%Patient)
		q %Patient.Province
}

/// 市
ClassMethod City()
{
		n (%Patient)
		q %Patient.City
}

/// 婚姻
ClassMethod Marital()
{
		n (%Patient)
		q %Patient.Marital
}

/// 民族
ClassMethod Nation()
{
		n (%Patient)
		q %Patient.Nation
}

/// 联系电话
ClassMethod Telephone()
{
		n (%Patient)
		q %Patient.Telephone
}

/// 学历
ClassMethod Education()
{
		n (%Patient)
		q %Patient.Education
}

/// 工作单位
ClassMethod WorkAddress()
{
		n (%Patient)
		q %Patient.WorkAddress
}

/// 与联系人的关系
ClassMethod Relation()
{
		n (%Patient)
		q %Patient.Relation
}

/// 联系人地址
ClassMethod RelativeAddress()
{
		n (%Patient)
		q %Patient.RelativeAddress
}

/// 联系人姓名
ClassMethod RelativeName()
{
		n (%Patient)
		q %Patient.RelativeName
}

/// 联系人电话
ClassMethod RelativeTelephone()
{
		n (%Patient)
		q %Patient.RelativeTelephone
}

/// 住址
ClassMethod Address()
{
		n (%Patient)
		q %Patient.Address
}

/// 国籍
ClassMethod Country()
{
		n (%Patient)
		q %Patient.Country
}

/// 住院病案号
ClassMethod InPatMrNo()
{
		n (%Patient)
		q %Patient.InPatMrNo
}

/// 门诊病案号
ClassMethod OpPatMrNo()
{
		n (%Patient)
		q %Patient.OpPatMrNo
}

/// 手机号（工作电话）
ClassMethod MobileTel()
{
		n (%Patient)
		q %Patient.MobileTel
}

}
