/// 名称: web.DHCCPW.IO.FromAdmSrv
/// 描述: 检索就诊记录方法
/// 编写者：zhufei
/// 编写日期: 2016-1-19
Class web.DHCCPW.IO.FromAdmSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(MAXLEN = 30);

/// 病人ID
Property PatientID As %String(MAXLEN = 30);

/// 就诊类型（O、E、I）
Property AdmType As %String(MAXLEN = 30);

/// 就诊日期
Property AdmitDate As %Date;

/// 出院日期
Property DischDate As %Date;

/// 就诊状态（A、D、C、P）
Property AdmStatus As %String(MAXLEN = 30);

/// 就诊院区(CT_Hospital.ID)
Property AdmHospID As %String(MAXLEN = 30);

/// 就诊科室(CT_Loc.ID)
Property AdmLocID As %String(MAXLEN = 30);

/// 就诊病区(CT_Loc.ID)
Property AdmWardID As %String(MAXLEN = 30);

/// Creator：     zhufei
/// CreatDate：   2016-1-19
/// Description:  取出院时间索引
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       
/// Return：      return=出院时间索引
/// w ##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()
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

/// Creator：     zhufei
/// CreatDate：   2016-1-19
/// Description:  根据出院日期检索就诊记录
/// Table：       Pa_Adm
/// Input：       DischDate ：出院日期
///               AdmList : 就诊列表
///               LocID ：科室/病区
///               HospID ：院区
/// Return：      return>0:查询成功，return<=0:查询失败
/// Set admList = ##Class(%ListOfObjects).%New()
/// w ##class(web.DHCCPW.IO.FromAdmSrv).GetDischAdmList("2013-02-18",.admList)
ClassMethod GetDischAdmList(aDischDate As %String, ByRef AdmList As %ListOfObjects, aLocID As %String = "", aHospID As %String = "") As %String
{
	New (aDischDate,AdmList,aLocID,aHospID)
	Set return=0
	Quit:aDischDate="" return
	
	Set $ZT="GetDischAdmListErr"
	
	Set:aDischDate["-" aDischDate=$zdh(aDischDate,3)  //日期格式转换
	Do AdmList.Clear()  //清空原有数据
	
	Set DischDateIndex=..GetDischDateIndex()  //取出院时间索引
	
	Set Count=0
	Set xPaadm=0
	For {
		Set xPaadm=$o(^PAADMi(DischDateIndex,aDischDate,xPaadm))
		Quit:xPaadm=""
		
		Set EpisodeID=xPaadm
		Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
		Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		Set AdmitDate=$p($g(^PAADM(EpisodeID)),"^",6)
		Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
		Set AdmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		Set AdmLocID=$p($g(^PAADM(EpisodeID)),"^",4)
		Set AdmWardID=$p($g(^PAADM(EpisodeID)),"^",70)
		If AdmWardID'="" {
			Set AdmWardID=$p($g(^PAWARD(AdmWardID)),"^",5)
		}
		Continue:(aLocID'="")&((aLocID'=AdmLocID)&&(aLocID'=AdmWardID))
		Set AdmHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLocID)
		Continue:(aHospID'="")&(aHospID'=AdmHospID)
		
		Set obj=##Class(web.DHCCPW.IO.FromAdmSrv).%New()
		Set obj.EpisodeID=EpisodeID
		Set obj.PatientID=PatientID
		Set obj.AdmType=AdmType
		Set obj.AdmitDate=AdmitDate
		Set obj.DischDate=DischDate
		Set obj.AdmStatus=AdmStatus
		Set obj.AdmHospID=AdmHospID
		Set obj.AdmLocID=AdmLocID
		Set obj.AdmWardID=AdmWardID
		If obj'="" Do obj.%Close()
		
		Set Count=Count+1
		Do AdmList.Insert(obj)
	}
	Set return=Count
	Quit return
	
GetDischAdmListErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2016-1-21
/// Description:  取出院时间接口
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       aEpisodeID : 就诊号
/// Return：      return=DischDate_"^"_DischTime
/// w ##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(849)
ClassMethod GetDischDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	Set DischDate="",DischTime=""
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
/// w ##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateIndex()
ClassMethod GetAdmDateIndex() As %String
{
	New
	//If $d(^PAADMi("DischargeDateExt")) {
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
/// w ##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(849)
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

}
