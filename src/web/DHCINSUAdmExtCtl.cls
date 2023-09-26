/// 就诊扩展医保信息表操作类
/// 存储医保挂号、登记、结算等交易发生前,由个业务部门填写的信息
Class web.DHCINSUAdmExtCtl Extends %RegisteredObject
{

/// 保存
/// w ##class(web.DHCINSUAdmExtCtl).Save("4^10^1^0^0^1^0^2^2022-12-12^16:30")
/// 10010
ClassMethod Save(InString As %String, USERID As %String) As %String
{
	 s rtnStr = $$Save^DHCINSUAdmExt(InString,USERID)
	 q rtnStr
}

/// 按照ADMDR查询就诊扩展医保信息
/// w ##class(web.DHCINSUAdmExtCtl).GetInfoByAdmDr("9")
ClassMethod GetInfoByAdmDr(AdmRowid As %String) As %String
{
	 s rtnStr = $$GetINSUAdmExtAdmDr^DHCINSUAdmExt(AdmRowid)
	 i +rtnStr<0 d
	 .s rtnStr="^^^^^^^^^^^"
	 q rtnStr
}

/// 按照ADMDR查询就诊类型
/// w ##class(web.DHCINSUAdmExtCtl).GetTypeByAdmDr("9")
ClassMethod GetTypeByAdmDr(AdmRowid As %String) As %String
{
	 q:AdmRowid="" "AdmDr为空"
	 s PatTpye=$p($g(^PAADM(AdmRowid)),"^",2)
	 i PatTpye="I"          d
	 .s rtn="IP"
	 e                      d
	 .s rtn="OP"
	 q rtn
}

/// 按照Rowid查询就诊扩展医保信息
/// w ##class(web.DHCINSUAdmExtCtl).GetInfoByID("2")
ClassMethod GetInfoByID(Rowid As %String) As %String
{
	 s rtnStr = $$GetINSUAdmExtById^DHCINSUAdmExt(Rowid)
	 i +rtnStr<0 d
	 .s rtnStr="^^^^^^^^^^^"
	 q rtnStr
}

/// 按照操作人ID查询名称
/// w ##class(web.DHCINSUAdmExtCtl).GetMessByOpterId("9")
ClassMethod GetMessByOpterId(OpterId As %String) As %String
{
	 q:OpterId="" ""
	 s rtn=$p($g(^SSU("SSUSR",OpterId)),"^",2)
	 q rtn
}

}
