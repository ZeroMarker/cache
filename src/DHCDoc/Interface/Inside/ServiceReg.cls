/// creator:guorongyong
/// date:2020-06-15
/// desc:和东华医为内部系统的接口类【主要是提供给其他产品组的接口】，仅患者管理（主索引相关），本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.ServiceReg Extends %RegisteredObject
{

/// Creator:      宋春莉
/// CreatDate:    2019.01.14
/// Description:  插入/更新患者信息表
/// Table:        
/// Input:       PatObj 患者信息对象 详见:web.DHCEntity.PCA.PATMAS
/// Return:      myrtn_"^"_PAPMIRowID  myrtn 0:保存成功 其他失败 , PAPMIRowID  新建/更新信息表ID
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceReg).SavePatInfo()
ClassMethod SavePatInfo(PatObj As web.DHCEntity.PCA.PATMAS) As %String
{
	Q ##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(PatObj)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  建卡
/// Table:        
/// Input:       ConfigInfo:卡类型配置XML串 PaPatInfo:病人基本信息XML串 CardInfo:病人卡信息XML串 AccInfo:病人账户信息XML串 DepositInfo:病人预交金信息XML串 CardINVInfo:病人卡费用XML串 SepcialInfo ExpStr
/// Return:      myrtn_$c(1)_myOCardINVInfo_$c(1)_myOAccPreInfo_$c(1)_myCodeBarInfo_$c(1)_myPAPMIInfo_$c(1)_myCardRefInfo  myrtn 0:保存成功 其他失败
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceReg).SavePCAInfoToServer()
ClassMethod SavePCAInfoToServer(ConfigInfo As %String, PaPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, CardINVInfo As %String, SepcialInfo As %String, ExpStr As %String) As %String
{
	Q ##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo,PaPatInfo,CardInfo,AccInfo,DepositInfo,CardINVInfo,SepcialInfo,ExpStr)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  返回患者信息html
/// Table:        
/// Input:       EpisodeID - 就诊ID CONTEXT - 上下文 PatientID - 患者ID HospId - 院区
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceReg).GetPatInfoBar() 
ClassMethod GetPatInfoBar(EpisodeID As %String, CONTEXT As %String, PatientID As %String = "", HospId As %String = "") As %String
{
	Q ##class(web.DHCDoc.OP.AjaxInterface).GetOPInfoBar(EpisodeID,CONTEXT,PatientID,HospId)
}

/// Creator:      屈坚
/// CreatDate:    2023.04.25
/// Description:  判断身份证号和姓名是否一致
/// Table:        0 一致 1 不一致
/// Input:       CredNo 身份证号 Name 姓名
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceReg).CheckCredNoName() 
ClassMethod CheckCredNoName(CredNo, Name)
{
	set rtn=0
	set PatientID=$O(^PAPERi("PAPMI_PatNo",CredNo,""))
 	if (PatientID'="") {
	 	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
	 	if (PatName'=Name) {s rtn=1}
	 	}
	 q rtn
}

}
