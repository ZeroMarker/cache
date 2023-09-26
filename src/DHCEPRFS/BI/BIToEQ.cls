Class DHCEPRFS.BI.BIToEQ Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	加入PDF生成队列接口,设备
/// Input:	AParameter - 打印时需要的参数集合，以^分隔多个参数，RowID^用户名^FundsTypeDR
/// Return：ID - 记入队列的ID， 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToEQ).DHCEQDepreList("")
ClassMethod DHCEQDepreList(AParameter As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateDHCEQDEPRE()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC","","50",schemeType,"S","","EQ",AParameter)
	q ret
}

}
