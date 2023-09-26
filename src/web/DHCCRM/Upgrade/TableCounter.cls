/// 系统升级表计数器迁移
Class web.DHCCRM.Upgrade.TableCounter Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// User表计数器修改方法（默认参数 新旧计数器下都更新）
/// w ##class(web.DHCCRM.Upgrade.TableCounter).SetCounter(0)
ClassMethod SetCounter(aFlag As %Boolean = 1) As %String
{
	New (aFlag)
	
	//************************************************************************
	//随访系统^mdata计数器修改
	//************************************************************************
	//User.DHCCRMARCIMEx.cls
	Set:aFlag>0 ^DHCCRMARCIMEx=+$o(^DHCCRMARCIMEx("9999999999999999"),-1)
	Set ^mdata("DHCCRMARCIMEX")=+$o(^DHCCRMARCIMEx("9999999999999999"),-1)
	
	//User.DHCCRMBirthSend.cls
	Set:aFlag>0 ^DHCCRMBS=+$o(^DHCCRMBS("9999999999999999"),-1)
	Set ^mdata("DHCCRMBIRTHSEND")=+$o(^DHCCRMBS("9999999999999999"),-1)
	
	//User.DHCCRMCallbackSend.cls
	Set:aFlag>0 ^DHCCRMCBS=+$o(^DHCCRMCBS("9999999999999999"),-1)
	Set ^mdata("DHCCRMCALLBACKSEND")=+$o(^DHCCRMCBS("9999999999999999"),-1)
	
	//User.DHCCRMFURecord.cls
	Set:aFlag>0 ^DHCCRMFUR=+$o(^DHCCRMFUR("9999999999999999"),-1)
	Set ^mdata("DHCCRMFURECORD")=+$o(^DHCCRMFUR("9999999999999999"),-1)
	
	//User.DHCCRMFUSubject.cls
	Set:aFlag>0 ^DHCCRMFUS=+$o(^DHCCRMFUS("9999999999999999"),-1)
	Set ^mdata("DHCCRMFUSUBJECT")=+$o(^DHCCRMFUS("9999999999999999"),-1)
	
	//User.DHCCRMIPSubject.cls
	Set:aFlag>0 ^DHCCRMIPS=+$o(^DHCCRMIPS("9999999999999999"),-1)
	Set ^mdata("DHCCRMIPSUBJECT")=+$o(^DHCCRMIPS("9999999999999999"),-1)
	
	//User.DHCCRMLabResultSend.cls
	Set:aFlag>0 ^DHCCRMLRS=+$o(^DHCCRMLRS("9999999999999999"),-1)
	Set ^mdata("DHCCRMLABRESULTSEND")=+$o(^DHCCRMLRS("9999999999999999"),-1)
	
	//User.DHCCRMQRecord.cls
	Set:aFlag>0 ^DHCCRMQR=+$o(^DHCCRMQR("9999999999999999"),-1)
	Set ^mdata("DHCCRMQRECORD")=+$o(^DHCCRMQR("9999999999999999"),-1)
	
	Quit "OK!!!"
}

}
