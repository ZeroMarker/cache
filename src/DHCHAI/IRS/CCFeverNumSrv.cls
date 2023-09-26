/// 名称: DHCHAI.IRS.CCFeverNumSrv
/// 描述: 科室发热人数服务
/// 编写者：mayanpeng
/// 编写日期: 2018-01-10
Class DHCHAI.IRS.CCFeverNumSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-01-10
/// Description:  监控各科室发热人数
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       起止时间
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverByDate("1|2","2017-08-31","2017-08-31")
ClassMethod GetFerverByDate(aHospIDs As %String = "", aDateFrom As %String, aDateTo As %String) As %String
{
	New (aHospIDs,aDateFrom,aDateTo)
	Set return=""
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom="" aDateFrom=+$h
	Set:aDateTo="" aDateTo=+$h
	
	Set ZIndex=$zn,JIndex=$j,NIndex="FerverNum"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Set arrEpisodeDr=##class(DHCHAI.DPS.PAAdmSrv).GetEpisodeDrByDate(aDateFrom,aDateTo,aHospIDs,"","I")
	Quit:arrEpisodeDr.Count()<1 return  //无住院病人
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		For xDate=aDateFrom:1:aDateTo{
			//根据时间点取科室、病区信息
			Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(xEpisodeDr,xDate)
			Continue:TransInfo=""
			Set TransWardDr=$p(TransInfo,"^",2)
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(TransWardDr)
			Continue:'$IsObject(objLoc)
			Set LocDr=objLoc.%Id()
			// 入院24小时未计入监控范围
			Set IsFever=##class(DHCHAI.IRS.CCWarningSrv).GetFerverByAdm(xEpisodeDr,xDate,xDate,"")
			If (IsFever>0){
				Set num=$i(^TMP(ZIndex,JIndex,NIndex,LocDr,xDate))
			}
		}
	}
	
	Set xLocDr=0
	For {
		Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,xLocDr))
		Quit:xLocDr=""
		Set xDate=""
		For {
			Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,xLocDr,xDate))
			Quit:xDate=""
			
			Set LocCount=$g(^TMP(ZIndex,JIndex,NIndex,xLocDr,xDate))
			Set objFerver=##class(DHCHAI.IR.CCFeverNum).GetObjByLocDate(xLocDr,xDate)
			Set FerverID=""
			If ($IsObject(objFerver)){ //该天存在该科室(当天执行多次任务)
				Set FerverID=objFerver.%Id()
			}
			Set return=##class(DHCHAI.IR.CCFeverNum).Update(FerverID_"^"_xLocDr_"^"_xDate_"^"_LocCount,"^")
			Quit:return<=0
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-13
/// Description:  获取科室各日期发热人数列表
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       科室ID,起止时间
/// Return：      发热信息列表
/// w ##class(DHCHAI.IRS.CCFeverNumSrv).GetFerverArrByLoc("653","2017-03-01","2017-03-30")
ClassMethod GetFerverArrByLoc(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	New (aLocID,aDateFrom,aDateTo)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set Count=0
	For xDate=aDateFrom:1:aDateTo{
		Set objFerver=##class(DHCHAI.IR.CCFeverNum).GetObjByLocDate(aLocID,xDate)
		Set FerverNum=0
		If ($IsObject(objFerver)){
			Set FerverNum=objFerver.CCFeverNum
		}
		//Set FerverInfo=$lb(aLocID,xDate,FerverNum)
		Set Count=Count+1
		Do return.SetAt(FerverNum,Count)
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-17
/// Description:  获取科室日期内发热标准差
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       科室ID,起止时间
/// Return：      标准差
/// w ##class(DHCHAI.IRS.CCFeverNumSrv).GetStandByLocDate("653","2017-03-01","2017-03-30")
ClassMethod GetStandByLocDate(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aLocID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set FerverArr=..GetFerverArrByLoc(aLocID,aDateFrom,aDateTo)
	Set return=##Class(DHCHAI.Utils.CommonSrv).GetStandDev(FerverArr)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-17
/// Description:  获取科室日期内发热平均值
/// Table：       DHCHAI.IR.CCFeverNum
/// Input：       科室ID,起止时间
/// Return：      平均值
/// w ##class(DHCHAI.IRS.CCFeverNumSrv).GetAveByLocDate("653","2017-03-01","2017-03-30")
ClassMethod GetAveByLocDate(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aLocID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aLocID="")||(aDateFrom="")||(aDateTo="") return
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set FerverArr=..GetFerverArrByLoc(aLocID,aDateFrom,aDateTo)
	Set return=##Class(DHCHAI.Utils.CommonSrv).GetAverage(FerverArr)
	Quit return
}

}
