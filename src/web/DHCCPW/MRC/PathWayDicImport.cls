/// 名称: web.DHCCPW.MRC.PathWayDicImport
/// 描述：处理临床路径数据(V2.0-->V3.0)
/// 编写者：李阳
/// 编写日期：2011-01-30
Class web.DHCCPW.MRC.PathWayDicImport Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.MRC.PathWayDicImport).ImportOldPathDic()
ClassMethod ImportOldPathDic()
{
	n
	s rowid=""
	f  s rowid=$o(^DHCMRC("CPW",rowid)) q:rowid=""  d
	.s objPath=##class(User.DHCMRCClinPathWays).%OpenId(rowid)
	.q:'$IsObject(objPath)
	.w objPath.CPWCPWTypeDR.CLPTDesc,!
	.s objPathDic=##class(User.DHCMRCClinPathWaysDic).%New()
	.s objPathDic.CPWDCode=objPath.CPWCode
	.s objPathDic.CPWDDesc=objPath.CPWDesc
	.s objPathDic.CPWDCPWTypeDR=objPath.CPWCPWTypeDR
	.s objPathDic.CPWDActive=objPath.CPWActive
	.s objPathDic.CPWDDateFrom=objPath.CPWDateFrom
	.s objPathDic.CPWDDateTo=objPath.CPWDateTo
	.s objPathDic.CPWDVersion=""
	.s ret=objPathDic.%Save()
	.s objPath.CPWCPWDicDR=objPathDic
	.s objPath.CPWVersion=1
	.s ret=objPath.%Save()
	.d:objPath'="" objPath.%Close()
	.d:objPathDic'="" objPathDic.%Close()
	.k objPath
	.k objPathDic
	q ""
}

}
