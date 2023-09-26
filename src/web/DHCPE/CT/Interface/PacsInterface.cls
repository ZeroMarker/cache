/// 名称:     体检提供检查检验接口方法       
/// 编写者:   薛迎
/// 编写日期: 2022-10-17
Class web.DHCPE.CT.Interface.PacsInterface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    xy
/// CreatDate：  20221017
/// Description: 获取总检状态
/// Table：      总检结论表 User.DHCPEGeneralSummarize
/// Input:       PAAdmId : 就诊ID
/// Return：     -1/1 (1:总检已经审核；-1:总检未审核)
/// Debug: w ##class(web.DHCPE.CT.Interface.PacsInterface).GetGenSumStatus()
ClassMethod GetGenSumStatus(PAAdmId As %String)
{
	q:PAAdmId="" "-1"
    s generalAdvisorId=$o(^DHCPEGS(0,"PAADM",PAAdmId,0))
    q:generalAdvisorId="" "-1"
	s auditUserId=$p($g(^DHCPEGS(generalAdvisorId,1)),"^",5)
	q:auditUserId'="" "1"
}

/// Description: 根据医嘱ID获取医嘱实际价格
/// Input:       OEORIDR：OE_OrdItem的rowid
/// Return：     FactAmount (实际价格)
/// Debug: w ##class(web.DHCPE.CT.Interface.PacsInterface).GetFAmountByOEORIDR()
ClassMethod GetFAmountByOEORIDR(OEORIDR)
{
    s FactAmount=0
    s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORIDR,0))
    q:CRMORowId="" "0"
    s CRMOCRMORI=$p(^DHCPECRMO(CRMORowId),"^",2)
	q:CRMOCRMORI="" "0"
	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMOCRMORI, "", "")
	q FactAmount
}

}
