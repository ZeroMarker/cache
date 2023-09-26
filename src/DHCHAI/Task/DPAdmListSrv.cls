/// 名称: DHCHAI.Task.DPAdmListSrv
/// 描述: 就诊相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.Task.DPAdmListSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-04-05
/// Description:  取HIS就诊列表(期内出院+当前在院)
/// Input：       aDateFrom : 出院开始日期
/// 			  aDateTo：出院结束日期
/// 			  aHospCode：组织机构代码
/// Return：      返回%Library.ArrayOfDataTypes (DHCHAI.DP.PAAdm.PAEpisodeIDX)
/// w ##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeIDXByDate("2014-04-21","2017-04-21","DHSZHYY")
ClassMethod GetEpisodeIDXByDate(aDateFrom As %String, aDateTo As %String, aHospCode As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aHospCode)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetEpisodeIDXByDateErr"
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set xAdmType="",Count=0
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=""  //xAdmDays<0 表示住院病人
			Set:xAdmDays>=0 xDate=aDateFrom-xAdmDays-15  //xAdmDays>0 表示出院病人  往前找15天
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xPAAdmID = ""
				For {
					Set xPAAdmID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate,xPAAdmID))
					Quit:xPAAdmID=""
					
					Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPAAdmID)
					Continue:'$isobject(objAdm)
					Continue:(aHospCode'="")&&(objAdm.PAAdmLocDr.BTHospDr.BTCode'=aHospCode)
					Set VisitStatus=objAdm.PAVisitStatus
					Continue:(VisitStatus="P")  //处理预住院
					
					Set EpisodeID = objAdm.PAEpisodeIDx
					Set Count=Count+1
					Do return.SetAt(EpisodeID,Count)
				}	
			}
		}
	}
	Quit return
	
GetEpisodeIDXByDateErr
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-08
/// Description:  取数据池就诊列表(期内出院+当前在院)
/// Input：       aDateFrom : 出院开始日期
/// 			  aDateTo：出院结束日期
/// 			  aHospCode：组织机构代码
/// Return：      返回%Library.ArrayOfDataTypes (DHCHAI.DP.PAAdm.ID)
/// w ##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate("2014-04-21","2017-04-21","DHSZHYY")
ClassMethod GetEpisodeDrByDate(aDateFrom As %String, aDateTo As %String, aHospCode As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aHospCode)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetEpisodeDrByDateErr"
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set xAdmType="",Count=0
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=""  //xAdmDays<0 表示住院病人
			Set:xAdmDays>=0 xDate=aDateFrom-xAdmDays-15  //xAdmDays>0 表示出院病人  往前找15天
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xPAAdmID = ""
				For {
					Set xPAAdmID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate,xPAAdmID))
					Quit:xPAAdmID=""
					
					Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xPAAdmID)
					Continue:'$isobject(objAdm)
					Continue:(aHospCode'="")&&(objAdm.PAAdmLocDr.BTHospDr.BTCode'=aHospCode)
					Set VisitStatus=objAdm.PAVisitStatus
					Continue:(VisitStatus="P")  //处理预住院

					Set EpisodeDr=objAdm.%Id()
					Set Count=Count+1
					Do return.SetAt(EpisodeDr,Count)
				}	
			}
		}
	}
	Quit return
	
GetEpisodeDrByDateErr
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-25
/// Description:  测试ArrayOfDataTypes存储最大记录数
///               运行23847730（2千多万）条记录后报错
/// Set arr=##class(DHCHAI.Task.DPAdmListSrv).GetTest(100000000)
ClassMethod GetTest(aCount As %String) As %Library.ArrayOfDataTypes
{
	New (aCount)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set $ZT="GetTestErr"
	
	For indT=1:1:aCount {
		Set EpisodeID=100000000000
		Do return.SetAt(EpisodeID,indT)
	}
	Quit return
	
GetTestErr
	Do return.Clear()
	Quit return
}

}
