/// 名称: DHCCPW.IO.FromHisSrv
/// 描述: HIS提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-06-18
Class DHCCPW.IO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-04-02
/// Description:  Medtrak中原有转换大写方法
/// Input：       Value : 值
/// Return:		  返回String
/// w ##class(DHCCPW.IO.FromHisSrv).ALPHAUP("aaa-")
ClassMethod ALPHAUP(aValue As %String) As %String
{
	New (aValue)
	Set return=$$ALPHAUP^SSUTIL4(aValue)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-29
/// Description:  切换滚医嘱方式设置（From医生站）
/// Input：       EpisodeID : 就诊号
/// Return:		  返回return=1：新医嘱，return=0：旧医嘱
/// w ##class(DHCCPW.IO.FromHisSrv).isV7Episode(12)
ClassMethod isV7Episode(aEpisodeID As %String)
{
	New (aEpisodeID)
	//##Class(web.DHCDocMain).isV7Episode(aEpisodeID)
	Set isV7=+$g(^PAADM(+aEpisodeID,"VER"))
	Quit:isV7="7" 1
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-06-30
/// Description:  检查是否长期医嘱（From医生站）
/// Input：       PriorityID : 医嘱类型
/// Return:		  返回return=1：长期医嘱，return=0：非长期医嘱
/// w ##class(DHCCPW.IO.FromHisSrv).ISLongOrderPrior(12)
ClassMethod ISLongOrderPrior(aPriorityID As %String)
{
	New (aPriorityID)
	//##class(appcom.OEOrdItem).ISLongOrderPrior(aPriorityID)
	Set PriorCode=$p($g(^OECPR(+aPriorityID)),"^")
	If (PriorCode="S")||(PriorCode="OMST") {
		Quit 1
	}
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-07-01
/// Description:  医嘱项是否是小时医嘱（From医生站）
/// Input：       OEItemID : 医嘱ID
/// Return:		  返回return=1：是，return=0：否
/// w ##class(DHCCPW.IO.FromHisSrv).IsHourOrder(12)
ClassMethod IsHourOrder(aArcimID As %String) As %String
{
	New (aArcimID)
	Set $ZT="IsHourOrderErr"
	Set return=##Class(web.DHCDocOrderCommon).IsHourItem(aArcimID)
	Quit return
IsHourOrderErr
	Set ArcimUom=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),8)),"^",14)  //医嘱单位
	Set:ArcimUom'="" ArcimUom=$p($g(^CT("UOM",ArcimUom)),"^",1)
	Quit:$zcvt(ArcimUom,"U")="HOUR" 1
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-06-18
/// Description:  判断医嘱（药品）是否有库存（From医生站）
/// Input：       ArcimID : 医嘱项
/// Return:		  返回return=1：有库存，return=0：无库存
/// w ##class(DHCCPW.IO.FromHisSrv).CheckArcimInci("","")
ClassMethod CheckArcimInci(aEpisodeID As %String, aArcimID As %String) As %String
{
	New (aEpisodeID,aArcimID)
	Set return=0
	Quit:(aEpisodeID="")||(aArcimID="") return
	Set $ZT="CheckArcimInciErr"
	Set ret=##Class(web.DHCDocOrderEntry).GetStockQty(aEpisodeID,aArcimID)
	Set return=$s(+ret>0:1,1:0)
	Quit return
CheckArcimInciErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-07-07
/// Description:  取医嘱套日期
/// Input：       ARCOSID : 医嘱套ID
/// Return:		  返回String
/// w ##class(DHCCPW.IO.FromHisSrv).GetOrderSetDate(1)
ClassMethod GetOrderSetDate(aARCOSID As %String) As %String
{
	New (aARCOSID)
	Set return=##class(web.DHCDocOrderEntry).GetOrderSetDate(aARCOSID) 
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-18
/// Description:  取患者年龄（From计费组）
/// Input：       PatientID : 病人ID
///               EpisodeID : 就诊号
///               Date : 日期（可选，为空按当前日期计算）
///               Time : 时间（可选，为空按当前时间计算）
/// Return:		  返回String 格式：*岁*月*天
/// w ##class(DHCCPW.IO.FromHisSrv).GetPapmiAge(100,"","2015-01-01","")
ClassMethod GetPapmiAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
	Set return=0
	Quit:(aPatientID="")&&(aEpisodeID="") return
	Set $ZT="UDHCJFGetPapmiAgeErr"
	Set return=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,aEpisodeID,aDate,aTime)
	Quit return
UDHCJFGetPapmiAgeErr
	Set return=..CalAge(aPatientID,aEpisodeID,aDate,aTime)
	Quit return
}

ClassMethod CalAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
	Set return=""
	Quit:(aPatientID="")&&(aEpisodeID="") return
	
	Set $ZT="CalAgeErr"
	
	Set:aDate["-" aDate=$zdh(aDate,3)
	Set:aDate["/" aDate=$zdh(aDate,4)
	
	Set:aEpisodeID'="" aPatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:aPatientID="" return
	Set IBirth=$p($g(^PAPER(aPatientID,"ALL")),"^",6)
	Set IToday=$s(aDate'="":aDate,1:+$h)
	
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
	s IBirth=$g(IBirth),IToday=$g(IToday)
	i IBirth>2980000 s IBirth=""
	i IBirth<0 s IBirth=""
	q:'$G(IBirth) ""
	s XBirth=$ZD(IBirth)
	s XToday=$ZD(IToday)
	s AgeMth=XToday-XBirth
	s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
	s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
	s AgeYear=CurrYear-BirthYear
	i AgeDay<0 d
	. s AgeMth=AgeMth-1
	. s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	. q:XToday'=2
	. s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0  d
	.s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 d
	..s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	i AgeYear>0 d
	.s AgeMth=0
	.s AgeDay=0
	
	Set:AgeYear>0 return=AgeYear_"岁"
	Set:AgeMth>0 return=AgeMth_"月"
	Set:AgeDay>0 return=AgeDay_"天"
	Quit return
CalAgeErr
	Quit ""
}

}
