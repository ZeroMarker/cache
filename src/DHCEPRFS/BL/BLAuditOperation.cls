Class DHCEPRFS.BL.BLAuditOperation Extends %RegisteredObject
{

/// Function: 根据起止日期查询审计表的记录
/// CreateDate；2022-12-09
/// Creator: zhangjianhua
/// Table: DHCEPRFS_INST.AuditOperation
/// Return:1 ->成功;其他->失败
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAuditOperation","QryRecordByDate","66451","66453")
Query QryRecordByDate(DateFrom As %String = "", DateTo As %String = "") As %SQLQuery(ROWSPEC = "UserID:%String,UserName:%String,OperateDate:%Date,OperateTime:%Time,Type:%String,IP:%String,MachineName:%String,MacAddr:%String")
{
	select
	UserID,UserName,OperateDate,OperateTime,Type,IP,MachineName,MacAddr
	from DHCEPRFS_INST.AuditOperation
	where operateDate between :DateFrom and :DateTo
}

/// Function: 添加一条数据到操作审计表
/// CreateDate；2022-12-08
/// Creator: zhangjianhua
/// Table: DHCEPRFS_INST.AuditOperation
/// Input:	AUserID
/// 		AUserName
/// 		AType
/// 		AIP
/// 		AMachineName
/// 		AMacAddr
/// Return:1 ->成功;0->失败
/// Debug: w ##class(DHCEPRFS.BL.BLAuditOperation).AddRecord("DHC119","Mediway","LOGIN","10.122.134.112","LocalPC","3C-91-80-30-B9-61")
ClassMethod AddRecord(AUserID As %String = "", AUserName As %String = "", AType As %String = "", AIP As %String = "", AMachineName As %String = "", AMacAddr As %String = "") As %String
{
		s objAudit = ##class(DHCEPRFS.INST.AuditOperation).%New()
		s objAudit.UserID = AUserID
		s objAudit.UserName = AUserName
		s objAudit.Type = AType
		s objAudit.IP = AIP
		s objAudit.MachineName = AMachineName
		s objAudit.MacAddr = AMacAddr
		s objAudit.OperateDate = +$h
		s objAudit.OperateTime = $p($h,",",2)
		s status = objAudit.%Save()
		if ($$$ISOK(status))
		{
			q 1
		}
		else
		{
			q 0
		}
}

}
