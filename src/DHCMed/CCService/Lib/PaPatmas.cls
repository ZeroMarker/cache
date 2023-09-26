/// 名称: DHCMed.CCService.Lib.PaPatmas
/// 描述: 与病人基本信息相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.PaPatmas Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.PaPatmas).Test()
ClassMethod Test()
{
	New
	/*
	Set %EpisodeID=2194338
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetPatAge()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=2194338
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..GetPatSex()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	*/
	Set %EpisodeID=5583036
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..IsNewBaby()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-28
/// Description:  通过就诊号取患者年龄(岁)
/// Table：       Pa_Patmas
/// Input：       
/// Return：      ret>0:年龄  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.PaPatmas).GetPatAge()
ClassMethod GetPatAge() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,%AutoRunFlag,%CurrentDate)
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %CurrentDate=$g(%CurrentDate)
	Set:%CurrentDate="" %CurrentDate=+$h-1		//update by liuyh 这个日期与监控自动任务中的 ExamPaadmList 中的日期对应
	
	Set $ZT="GetPatAgeErr"
	Set Papmi=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:Papmi="" return
	Set DOB=$p($g(^PAPER(Papmi,"ALL")),"^",6)
	Quit:DOB="" return
	
	//Update by pylian 2016-01-21 修改出院时间取值方式
	//Set DisDate=$p($g(^PAADM(%EpisodeID)),"^",17)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(%EpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
	
	Set CurrDate=$g(%CurrentDate) //Modified By LiYang 2012-06-21 以传入日期计算年龄，用于今后补监控操作
	Set:DisDate'="" CurrDate=DisDate
	Set:CurrDate="" CurrDate=+$h
	Set Age=(CurrDate-DOB)\365
	Set:Age<1 Age=1
	
	Set return=$$BuildGetPatAgeResult(DOB,Age) 
	Set %ExtraData=%ExtraData_$lb(return)
	Set return=Age
	Quit return
	
GetPatAgeErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetPatAgeResult(DOB,Age) //Add By LiYang 2012-06-20
	n (DOB,Age,%AutoRunFlag,%CurrentDate)
	Set Rst="出生日期:"_$zd(+DOB,3)_",年龄:"_Age_"岁"
	//b //aa
	/* removed by wuqk 2012-08-31 不再使用次标记
	If $g(%AutoRunFlag)'=1
	{
		Set tmp=Rst
	}
	else
	{ */
	
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
		Set tmp=""
		Set $p(tmp,$c(3),1)=Rst
		Set $p(tmp,$c(3),2)=%CurrentDate
		Set $p(tmp,$c(3),3)=0
		Set $p(tmp,$c(3),4)=Age
		Set $p(tmp,$c(3),5)=0
		Set $p(tmp,$c(3),6)=0
		Set $p(tmp,$c(3),7)=""		
	//}
	Quit tmp
}

/// Creator：     wuqk
/// CreatDate：   2011-09-08
/// Description:  通过就诊号取患者性别
/// Table：       Pa_Patmas
/// Input：       
/// Return：      性别描述  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.PaPatmas).GetPatSex()
ClassMethod GetPatSex() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetPatSexErr"
	Set Papmi=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:Papmi="" return
	Set Sex=$p($g(^CT("SEX",$p($g(^PAPER(Papmi,"ALL")),"^",7))),"^",2)
	Set return=$$BuildGetPatSexResult(Sex)
	Set %ExtraData=%ExtraData_$lb(return)
	Set return=Sex
	Quit return
	
GetPatSexErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetPatSexResult(Sex) //Add By LiYang 2012-06-20
	New (Sex,%AutoRunFlag)
	Set Rst=Sex
	/* removed by wuqk 2012-08-31 不再使用次标记
	If $g(%AutoRunFlag)'=1
	{
		Set tmp=Rst
	}
	else
	{*/
	
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
		Set tmp=""
		Set $p(tmp,$c(3),1)="性别:"_Rst
		Set $p(tmp,$c(3),2)=+$h
		Set $p(tmp,$c(3),3)=$p($h,",",2)
		Set $p(tmp,$c(3),4)=Rst
		Set $p(tmp,$c(3),5)=0
		Set $p(tmp,$c(3),6)=0
		Set $p(tmp,$c(3),7)=""		
	//}
	Quit tmp
}

/// Creator：     wuqk
/// CreatDate：   2012-08-31
/// Description:  根据入院日期判断是否新生儿(入院时不足28天为新生儿)
/// Table：       Pa_Patmas
/// Input：       
/// Return：      ret>0:是  ret=0:否 ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.PaPatmas).IsNewBaby()
ClassMethod IsNewBaby() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData,%CurrentDate)
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	Set %CurrentDate=$g(%CurrentDate)
	Set:%CurrentDate="" %CurrentDate=+$h-1
	
	Set $ZT="IsNewBabyErr"
	Set Papmi=$p($g(^PAADM(%EpisodeID)),"^",1)
	Quit:Papmi="" return
	Set DOB=$p($g(^PAPER(Papmi,"ALL")),"^",6)
	Quit:DOB="" return
	//Set AdmDate=$p($g(^PAADM(%EpisodeID)),"^",6)    //就诊日期
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(%EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set Days=AdmDate-DOB
	Quit:Days>28 return
	
	Set return=$$BuildIsNewBabyResult(AdmDate,DOB,Days) 
	Set %ExtraData=%ExtraData_$lb(return)
	Set return=1
	Quit return
	
IsNewBabyErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildIsNewBabyResult(AdmDate,DOB,Days)
	n (AdmDate,DOB,Days,%CurrentDate)

	// 若新生儿年龄不足一天,按一天计算
	Set:Days=0 Days=1

	Set Rst="年龄:"_Days_"天,出生日期:"_$zd(DOB,3)_",就诊日期:"_$zd(AdmDate,3)
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=Rst
	Set $p(tmp,$c(3),2)=%CurrentDate
	Set $p(tmp,$c(3),3)=0
	Set $p(tmp,$c(3),4)=Days_"天"
	Set $p(tmp,$c(3),5)=0
	Set $p(tmp,$c(3),6)=0
	Set $p(tmp,$c(3),7)=""
	
	Quit tmp
}

}
