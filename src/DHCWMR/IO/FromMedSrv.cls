/// 名称: DHCWMR.IO.FromMedSrv
/// 描述: 医政组提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-04-03
Class DHCWMR.IO.FromMedSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-04-03
/// Description:  取值死亡日期
/// Input：       EpisodeID : 就诊号
/// Return：      返回String（同$H格式）
/// w ##class(DHCWMR.IO.FromMedSrv).GetDeathDateTime(9726218)
ClassMethod GetDeathDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetDeathDateTimeErr"
	Set DeathDateTime=##class(DHCMed.DTHService.ReportInterface).GetDeathDateTime(aEpisodeID)
	If DeathDateTime="" {
		Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
		Quit:PatientID="" return
		Set IsDeath=$p($g(^PAPER(PatientID,"ALL")),"^",12)
		Quit:IsDeath'="Y" return
		//update by pylian 2016-01-22
		Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(aEpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DeathDate=$p($g(^PAPER(PatientID,"ALL")),"^",13)
		Set:DeathDate="" DeathDate=DischDate
		//Set:DeathDate="" DeathDate=$p($g(^PAADM(aEpisodeID)),"^",17)
		Quit:DeathDate="" return
		
		//Set AdmitDate=$p($g(^PAADM(aEpisodeID)),"^",6)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
		Set AdmitDate=$p(AdmDateTime,"^",1)
	
		Quit:AdmitDate>DeathDate return
		//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
		Set:DischDate="" DischDate=+$h
		Quit:DischDate<DeathDate return
	} Else {
		Set DeathDate=$p(DeathDateTime,",",1)
	}
	Set return=DeathDate
	Quit return
	
GetDeathDateTimeErr
	Quit ""
}

}
