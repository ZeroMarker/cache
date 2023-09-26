/// 名称: DHCMA.Util.EPS.OIDService
/// 描述: OID有效性（格式：字典ID!!系统ID）
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPS.OIDService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  OID有效性检查
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aOID ：DHCMA.Util.EP.*.OID
/// Return：      返回ID
/// w ##class(DHCMA.Util.EPS.OIDService).GetValidOID("2!!1")
ClassMethod GetValidOID(aOID As %String) As %String
{
	New (aOID)
	Set return=""
	Quit:aOID="" return
	
	Set IDx=$p(aOID,"!!",1)
	Set SYSDr=$p(aOID,"!!",2)
	Quit:IDx="" return
	If SYSDr="" {
		Set SYSDr=$o(^DHCMA.Util.BT.SYSTEMD(0))
		Set return=IDx_"!!"_SYSDr
	} Else {
		If $d(^DHCMA.Util.BT.SYSTEMD(SYSDr)) {
			Set return=aOID
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据OID获取系统指针
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aOID ：DHCMA.Util.EP.*.OID
/// Return：      返回ID
/// w ##class(DHCMA.Util.EPS.OIDService).GetSYSDr(aOID)
ClassMethod GetSYSDr(aOID As %String) As DHCMA.Util.BT.SYSTEM
{
	New (aOID)
	Set SYSDr=$p(aOID,"!!",2)
	Set return=##class(DHCMA.Util.BT.SYSTEM).GetObjById(SYSDr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据OID获取字典指针
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aOID ：DHCMA.Util.EP.*.OID
/// Return：      返回ID
/// w ##class(DHCMA.Util.EPS.OIDService).GetSYSOID(aOID)
ClassMethod GetSYSOID(aOID As %String) As DHCMA.Util.BT.SYSTEM
{
	New (aOID)
	Set return=$p(aOID,"!!",1)
	Quit return
}

}
