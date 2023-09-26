Class DHCEPRFS.BI.BIToFee Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	加入PDF生成队列接口,住院每日HZ
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToFee).DHCBillFinanceIPDailyHZPrt("")
ClassMethod DHCBillFinanceIPDailyHZPrt(AParameter As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateIPBillDailyHZ()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","FEE",AParameter)
	q ret
}

/// Desc:	加入PDF生成队列接口,住院每日
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToFee).DHCBillFinanceIPDailyPrt("")
ClassMethod DHCBillFinanceIPDailyPrt(AParameter As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateIPBillDaily()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","FEE",AParameter)
	q ret
}

/// Desc:	加入PDF生成队列接口,门诊每日HZ
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToFee).DHCBillFinanceOPDailyHZPrt("")
ClassMethod DHCBillFinanceOPDailyHZPrt(AParameter As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateOPBillDailyHZ()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","FEE",AParameter)
	q ret
}

/// Desc:	加入PDF生成队列接口,门诊每日
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToFee).DHCBillFinanceOPDailyPrt("")
ClassMethod DHCBillFinanceOPDailyPrt(AParameter As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateOPBillDaily()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","FEE",AParameter)
	q ret
}

}
