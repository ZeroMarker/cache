/// 名称:	EMR.DOC.BL.PowerUser
/// 描述:	医生级别需要(重写)
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PowerUser Extends EMR.DOC.COM.ActionBase
{

/// Desc: 取医师级别
/// Creaotr:    Candy
/// CreateDate: 2016-8-15
/// Debug: w ##Class(EMRservice.BL.BLPowerUser).GetHisUserLevel(180)
ClassMethod GetHisUserLevel(AUserPvID As %String) As %String
{
	s result = ""
	q:(AUserPvID = "") result
	s levelId = $p($g(^CTPCP(AUserPvID,1)),"^",4)
	q:(levelId = "") result
	s levelCode = $p($g(^CT("CPT",levelId)),"^",1)
	/*
	s rowId = $o(^DHCEMRM.SignRoleI("IdxNSCode"," "_levelCode,""))
	s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
	s result = obj.ActionCode
	*/
	s result = levelCode
	q result
}

}
