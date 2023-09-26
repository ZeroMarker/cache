/// Descript:   清除临床药学数据
/// Creator:    qunianpeng
/// CreateDate: 2016-11-07
Class web.DHCClearData Extends %RegisteredObject
{

/// 清除基础数据（临床药学）
/// d ##class(web.DHCClearData).KillBascData()
ClassMethod KillBascData() As %String
{
	k ^DHCPHML
	k ^DHCPHMI
	k ^DHCPHMS
	k ^DHCPHPDT
	k ^DHCPHFULIB
	k ^DHCPHFULITM
	k ^DHCPHFUTHE
	k ^DHCPHCONT
	k ^DHCPHCONQT
	k ^DHCPHCONTB
	;k ^DHCPHADRE    //事件名称
	k ^DHCPHADRRM   //用药原因
 	k ^DHCPHADRW	 //填报意愿
 	k ^DHCPHADRII 	//患者相关
	k ^DHCPHADRS
	k ^DHCPHADRP
	k ^DHCPHADRS
	k ^DHCPHMSC
	k ^DHCPHCONSC
	k ^DHCPHDSD
}

/// 清除业务数据（临床药学）
/// d ##class(web.DHCClearData).KilProfessData()
ClassMethod KilProfessData() As %String
{
	k ^DHCPHPC
	k ^DHCPHBMT
	k ^DHCPHBMS
	k ^DHCPHWR
	k ^DHCPHCP
	k ^DHCPHME
	k ^DHCPHCONS
	k ^DHCPHCOND
	k ^DHCPHCONI
	k ^DHCPHAE
	k ^DHCPHM
	k ^DHCPHAD
	k ^DHCPHDMR
	k ^DHCPHDQER
	k ^DHCPHADRR
	k ^DHCPHEP
	k ^DHCPHMAT
	k ^DHCPHDQER
	k ^DHCPHFULITM
}

}
