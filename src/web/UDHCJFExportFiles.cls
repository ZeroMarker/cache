Class web.UDHCJFExportFiles Extends %RegisteredObject
{

/// 成批导出住院类文件
/// d ##class(web.UDHCJFExportFiles).ExportIPClass()
ClassMethod ExportIPClass()
{
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","UDHCJF","d:\DHCIP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCIPBILL","d:\DHCIP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCIPBill","d:\DHCIP\class\")
}

/// 成批导出住院组件
/// d ##class(web.UDHCJFExportFiles).ExportIPComponent()
ClassMethod ExportIPComponent()
{
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("UDHCJF","d:\DHCIP\component\")
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("DHCIP","d:\DHCIP\component\")
}

/// 成批导入住院组件
/// d ##class(web.UDHCJFExportFiles).ImportIPComponent()
ClassMethod ImportIPComponent()
{
	d ##Class(web.DHCMedUtil.UtilService).PutComponents("ComponentList.TXT","/temp/Components/")
}

/// 成批导出门诊类文件
/// d ##class(web.UDHCJFExportFiles).ExportOPClass()
ClassMethod ExportOPClass()
{
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPC","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","UDHCOP","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCBill","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","UDHCA","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCAC","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","UDHCOE","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPB","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","udhcOP","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOP","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCSOPF","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","UDHCJFOP","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCEntity","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPBILL","d:\DHCOP\class\")
}

/// 成批导出门诊组件
/// d ##class(web.UDHCJFExportFiles).ExportOPComponent()
ClassMethod ExportOPComponent()
{
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("udhc","d:\DHCOP\component\")
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("DHCOPB","d:\DHCOP\component\")
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("DHCOPF","d:\DHCOP\component\")
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("DHCOPB","d:\DHCOP\component\")
	d ##Class(web.DHCMedUtil.UtilService).GetComponents("UDHCJFOP","d:\DHCOP\component\")
}

/// 银行卡表结构导出
/// d ##class(web.UDHCJFExportFiles).ExportOPBankClass()
ClassMethod ExportOPBankClass()
{
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCINVBankAccount","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCINVBankConSub","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCINVBankTradePay","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCIPInvBankTradeSub","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCIPRcptBankTradeSub","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCCTPayModeExp","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCCTPayModeRefundRule","d:\DHCOP\class\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","udhcOP","d:\DHCOP\class\")
}

/// 银行卡表结构导出
/// d ##class(web.UDHCJFExportFiles).ExportOPBankWebClass()
ClassMethod ExportOPBankWebClass()
{
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCBillBankLogic","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCIPBillIPRcptBankTrade","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCIPBillInvBankTrade","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPBillINVBankConSub","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPBillINVBankPay","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPBillAccDaily","d:\DHCOP\class1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("web","DHCOPBillINVBankAcount","d:\DHCOP\class1\")
}

/// 表结构导出
/// d ##class(web.UDHCJFExportFiles).ExportOPUserClass()
ClassMethod ExportOPUserClass()
{
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCAccPayINV","d:\DHCOP\user1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCAccPayList","d:\DHCOP\user1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCAccPreDeposit","d:\DHCOP\user1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCINVPRT","d:\DHCOP\user1\")
	d ##Class(web.DHCMedUtil.UtilService).ExportClassforSVNOnName("User","DHCINVPRTReports","d:\DHCOP\user1\")
}

/// d ##class(web.UDHCJFExportFiles).ExpAll()
ClassMethod ExpAll()
{
	d ##class(web.UDHCJFExportFiles).ExportIPClass()
	d ##class(web.UDHCJFExportFiles).ExportIPComponent()
	d ##class(web.UDHCJFExportFiles).ExportOPClass()
	d ##class(web.UDHCJFExportFiles).ExportOPComponent()
}

}
