/// 名称: DHCMed.CCService.Library.PaPatmas
/// 描述: 与病人基本信息相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Library.PaPatmas Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.PaPatmas).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=62
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetPatAge()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	/*
	Set %EpisodeID=3861130
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetPatSex()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=3861130
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..IsNewBaby()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-04-15
/// Description:  通过就诊号取患者年龄(岁)
/// Table：       Pa_Patmas
/// Input：       
/// Return：      ret>0:年龄  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.PaPatmas).GetPatAge()
ClassMethod GetPatAge() As %String
{
	New (%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetPatAgeErr"
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	
	Quit:PatientID="" return
	Set DOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Quit:DOB="" return
	
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(%EpisodeID)),"^",7)
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
  
	Quit:AdmDate="" return

	//update by zf 20150228 统一调用年龄计算方法
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,%EpisodeID,AdmDate,AdmTime)	//返回“*岁*月*天”
	Quit:Age="" return
	If Age["岁" {
		Set Age=+$p(Age,"岁",1)
	} Else {
		Set Age=1
	}

	Set TempData=""
	Set $p(TempData,$c(3),1)=Age_"岁("_$zd(DOB,3)_")"
	Set $p(TempData,$c(3),2)=AdmDate
	Set $p(TempData,$c(3),3)=AdmTime
	Set $p(TempData,$c(3),4)=Age_"岁"
	Set $p(TempData,$c(3),5)=PatientID_"||AGE"
	Set $p(TempData,$c(3),6)=""
	Set $p(TempData,$c(3),7)=""
	Set $p(TempData,$c(3),8)=AdmDate
	Set $p(TempData,$c(3),9)=AdmTime
	Set $p(TempData,$c(3),10)="PAT"
	Set $p(TempData,$c(3),11)=""
	Set $p(TempData,$c(3),12)=""
	Set $p(TempData,$c(3),13)=""
	Set $p(TempData,$c(3),14)=""
	Set %ExtraData=%ExtraData_$lb(TempData)
	
	Set return=Age
	Quit return
	
GetPatAgeErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-04-15
/// Description:  通过就诊号取患者性别
/// Table：       Pa_Patmas
/// Input：       
/// Return：      性别描述  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.PaPatmas).GetPatSex()
ClassMethod GetPatSex() As %String
{
	New (%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=""
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetPatSexErr"
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:PatientID="" return
	Set Sex=$p($g(^CT("SEX",+$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	Quit:Sex="" return
	
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(%EpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Quit:AdmDate="" return
	
	Set AdmDate=$zd(AdmDate,3)
	Set AdmTime=$zt(AdmDate,1)
	
	Set TempData=""
	Set $p(TempData,$c(3),1)=Sex
	Set $p(TempData,$c(3),2)=AdmDate
	Set $p(TempData,$c(3),3)=AdmTime
	Set $p(TempData,$c(3),4)=Sex
	Set $p(TempData,$c(3),5)=PatientID_"||SEX"
	Set $p(TempData,$c(3),6)=""
	Set $p(TempData,$c(3),7)=""
	Set $p(TempData,$c(3),8)=AdmDate
	Set $p(TempData,$c(3),9)=AdmTime
	Set $p(TempData,$c(3),10)="PAT"
	Set $p(TempData,$c(3),11)=""
	Set $p(TempData,$c(3),12)=""
	Set $p(TempData,$c(3),13)=""
	Set $p(TempData,$c(3),14)=""
	Set %ExtraData=%ExtraData_$lb(TempData)
	
	Set return=Sex
	Quit return
	
GetPatSexErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-04-15
/// Description:  根据入院日期判断是否新生儿(入院时不足28天为新生儿)
/// Table：       Pa_Patmas
/// Input：       
/// Return：      ret>0:是  ret=0:否 ret=-1:Error
/// w ##class(DHCMed.CCService.Library.PaPatmas).IsNewBaby()
ClassMethod IsNewBaby() As %String
{
	New (%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetPatAgeErr"
	
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:PatientID="" return
	Set DOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Quit:DOB="" return
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(%EpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Quit:AdmDate="" return
	Set Days=(AdmDate-DOB)+1
	Set:Days<1 Days=1
	Quit:Days>28 return
	
	Set AdmDate=$zd(AdmDate,3)
	Set AdmTime=$zt(AdmDate,1)
	
	Set TempData=""
	Set $p(TempData,$c(3),1)="新生儿(出生"_Days_"天"_")"
	Set $p(TempData,$c(3),2)=AdmDate
	Set $p(TempData,$c(3),3)=AdmTime
	Set $p(TempData,$c(3),4)=Days
	Set $p(TempData,$c(3),5)=PatientID_"||NEWBABY"
	Set $p(TempData,$c(3),6)=""
	Set $p(TempData,$c(3),7)=""
	Set $p(TempData,$c(3),8)=AdmDate
	Set $p(TempData,$c(3),9)=AdmTime
	Set $p(TempData,$c(3),10)="PAT"
	Set $p(TempData,$c(3),11)=""
	Set $p(TempData,$c(3),12)=""
	Set $p(TempData,$c(3),13)=""
	Set $p(TempData,$c(3),14)=""
	Set %ExtraData=%ExtraData_$lb(TempData)
	
	Set return=Days
	Quit return
	
IsNewBabyErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
