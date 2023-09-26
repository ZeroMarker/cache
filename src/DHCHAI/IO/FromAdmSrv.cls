/// 名称: DHCHAI.IO.FromAdmSrv
/// 描述: 检索就诊记录方法
/// 编写者：zhufei
/// 编写日期: 2016-1-19
Class DHCHAI.IO.FromAdmSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-1-19
/// Description:  取出院时间索引
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       
/// Return：      return=出院时间索引
/// w ##Class(DHCHAI.IO.FromAdmSrv).GetDischDateIndex()
ClassMethod GetDischDateIndex() As %String
{
	New
	//If $d(^PAADMi("DischargeDateExt")) {
	If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
		Set return="DischargeDateExt"
	} Else {
		Set return="DischDate"
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-1-21
/// Description:  取出院时间接口
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       aEpisodeID : 就诊号
/// Return：      return=DischDate_"^"_DischTime
/// w ##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(849)
ClassMethod GetDischDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	Set DischDate="",DischTime=""
	// update 2021-08-31 修复bug2123400，根据临床就诊状态统一处理出院时间、转科记录
	Set AdmStr = $g(^PAADM(+aEpisodeID))
	Set VisitStatus = $p(AdmStr,"^",20)	//就诊状态
	Quit:VisitStatus'="D" return
	
	//If $d(^PAADMi("DischargeDateExt")) {
	If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
		Set DischDate=$p($g(^PAADM(aEpisodeID,"DHC")),"^",29)
		Set DischTime=$p($g(^PAADM(aEpisodeID,"DHC")),"^",30)
	}Else{
		Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
		Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	}
	Set return=DischDate_"^"_DischTime
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-2-18
/// Description:  取入院时间索引
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       
/// Return：      return=入院时间索引
/// w ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateIndex()
ClassMethod GetAdmDateIndex() As %String
{
	New
	If $d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed")){
		Set return="AdminDateExt"      
	} Else {
		Set return="PAADM_AdmDate"    
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-1-21
/// Description:  取入院时间接口
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       aEpisodeID : 就诊号
/// Return：      return=AdmDate_"^"_AdmTime
/// w ##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(849)
ClassMethod GetAdmDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	Set AdmDate="",AdmTime="",AdmType=""
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)

	If ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(AdmType="I")){
		Set AdmDate=$p($g(^PAADM(aEpisodeID,"DHC")),"^",31)
		Set AdmTime=$p($g(^PAADM(aEpisodeID,"DHC")),"^",32)
		//add pylian 20160301 按分床日期为入院日期时，若为空，计算住院日期时导致问题 
		If (AdmDate="")&&(AdmTime=""){
			Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
			Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
		}
	}Else{
		Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
		Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	}
	Set return=AdmDate_"^"_AdmTime
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-9-29
/// Description:  取病案号接口
/// Table：       PA_PatMas
/// Input：       EpisodeID
/// Return：      return=病案号
/// w ##Class(DHCHAI.IO.FromAdmSrv).GetMrNoByAdm()
ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID = $p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	//Set MrNo = $p($g(^PAPER(PatientID,"PAT",1)),"^",22)  //病人基本信息表取病案号
	Set MrNo ="" //update 20200511 按产品部要求修改
	
	Set $ZT="GetMrNoByAdmErr"
	Set return=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(+aEpisodeID,"I")  //参数缺少实际取值是病人基本信息表病案号
	Quit return
	
GetMrNoByAdmErr
	Set return=MrNo
	Quit return
}

}
