/// 名称: DHCMed.CCService.Lib.PaAdm
/// 描述: 与就诊信息相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.PaAdm Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.PaAdm).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=5626265
	Set %ExtraData=""
	Set %ErrorData=""
	Set %CurrentDate=+$h
	Set return=..InHospital()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=5626265
	Set %ExtraData=""
	Set %ErrorData=""
	Set %CurrentDate=+$h
	Set return=..GetPatInHospDays(10)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     liuyuhui
/// CreatDate：   2012-02-8
/// Description:  通过就诊号判断住院天数是否大于给定值
/// Table：       Pa_adm
/// Input：       
/// Return：      ret>0:住院天数  ret=-1:小于
/// w ##class(DHCMed.CCService.Lib.PaAdm).GetPatInHospDays(10)
ClassMethod GetPatInHospDays(days As %String) As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,days,%AutoRunFlag,%CurrentDate) //Modified By LiYang 2012-06-26 增加自动监控支持
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set:$g(%CurrentDate)="" %CurrentDate=+$h
	Set $ZT="GetPatAgeErr"
	Set Papmi=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:Papmi="" return
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	
	//Set DisDate=$p($g(^PAADM(%EpisodeID)),"^",17)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(%EpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
	Quit:AdmDate="" return
	Set CurrDate=$s(DisDate'="":DisDate,1:+$h)
	If (CurrDate-AdmDate+1)>days {
		Set num=CurrDate-AdmDate+1
		Set Rst="住院天数为:"_num_"天"
		Set %ExtraData=%ExtraData_$lb(Rst)
		Set return=num
	} Else {
		Set return=-1
	}
	Quit return
	
GetPatAgeErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetPatInHospDaysResult(Days) //Add By LiYang 2012-06-20
	Set Rst="住院天数为:"_num_"天"
	If $g(%AutoRunFlag)
	{
		Set %ExtraData=%ExtraData_$lb(Rst)
	}
	else
	{
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
		Set tmp=""
		Set $p(tmp,$c(3),1)=Rst
		Set $p(tmp,$c(3),2)=+$h
		Set $p(tmp,$c(3),3)=$p($h,",",2)
		Set $p(tmp,$c(3),4)=Days
		Set $p(tmp,$c(3),5)=0
		Set $p(tmp,$c(3),6)=0
		Set $p(tmp,$c(3),7)=""
		Set %ExtraData=%ExtraData_$lb(Rst)		
	}
}

ClassMethod InHospital() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,%CurrentDate)
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set:$g(%CurrentDate)="" %CurrentDate=+$h
	
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	//Set DisDate=$p($g(^PAADM(%EpisodeID)),"^",17)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(%EpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
	
	Quit:AdmDate="" return
	Set Days=+$g(%CurrentDate)-AdmDate
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(%EpisodeID)
	Do objAdm.%Close()
	Set DepID=objAdm.DepartmentID
	Set WardID=objAdm.WardID
	Set extra=$$BuildInHospitalResult(Days)
	Set %ExtraData=%ExtraData_$lb(extra)
	Quit Days
	
BuildInHospitalResult(Days) //Add By LiYang 2012-06-20
	Set Rst="住院第"_Days_"天，"_objAdm.Department_"，"_objAdm.Ward
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
		Set tmp=""
		Set $p(tmp,$c(3),1)=Rst
		Set $p(tmp,$c(3),2)=+%CurrentDate
		Set $p(tmp,$c(3),3)=$p($h,",",2)
		Set $p(tmp,$c(3),4)=Days_"^"_DepID_"^"_WardID
		Set $p(tmp,$c(3),5)=0
		Set $p(tmp,$c(3),6)=0
		Set $p(tmp,$c(3),7)=""
		Quit tmp
}

}
