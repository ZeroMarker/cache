Class web.DHCST.StkTypeG Extends %RegisteredObject [ Abstract ]
{

Parameter StkTypeCode = "G";

Parameter StkTypeDesc = "药品";

ClassMethod sssCode() As %String
{
 q ..%GetParameter("StkTypeCode")
}

ClassMethod sssDesc() As %String
{
 q ..%GetParameter("StkTypeDesc")
}

ClassMethod sssLock(lockName As %String) As %String
{
  q ##class(web.DHCST.Common.AppCommon).Lock(lockName)
}

ClassMethod sssUnLock(lockName As %String)
{
	d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)
}

/// 返回科室所在医院的RowId
ClassMethod sssHospId(ctloc As %String) As %String
{
 s ctloc=$G(ctloc)
 q:ctloc="" ""
 s HospID=$p($G(^CTLOC(ctloc)),"^",22)
 q HospID
}

/// Description:html日期(date)Logical格式,转换为html格式
ClassMethod DL2H(d As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).DateLogicalToHtml(d)
}

/// Description:html日期(date)格式,转换为Logical格式
ClassMethod DH2L(d As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).DateHtmlToLogical(d)
}

ClassMethod TL2H(t As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).TimeLogicalToHtml(t)
}

/// Description:html时间(time)格式,转换为Logical格式
ClassMethod TH2L(t As %String) As %String [ Final ]
{
	q ##class(websys.Conversions).TimeHtmlToLogical(t)
}

/// 取登录者身份参数串
/// Date:2020-11-23
/// Author:
/// Arguments:
/// Return: 安全组ID^科室ID^用户ID^医院ID
ClassMethod sssParamStr() As %String
{
   q:'$g(%session) ""
   q $g(%session.Data("LOGON.GROUPID"))_"^"_$g(%session.Data("LOGON.CTLOCID"))_"^"_$g(%session.Data("LOGON.USERID"))_"^"_$g(%session.Data("LOGON.HOSPID"))
}

/// 取用户姓名
/// 
/// 2020-11-23
/// user - RowId Of SSUser
ClassMethod sssUserName(user As %String) As %String
{
 q:+user=0 ""
 s name=$p($G(^SSU("SSUSR",user)),"^",2)
 q name
}

/// Description:格式化combo返回值,用于ext中Combo.setValue(***). 注:使用双引号
/// Creator:	wangjiabin
/// CreatDate：	2014-07-15
/// Input:		rowid, desc
/// Output:
/// Return:		
ClassMethod sssComboStr(RowId As %String, Description As %String) As %Library.String
{
	s str="{""RowId"":"""_RowId_""",""Description"":"""_Description_"""}"
	q str
}

/// Description: 公用NewPid方法
ClassMethod NewPid()
{
	q $i(^DHCSTPID("PID"))
}

}
