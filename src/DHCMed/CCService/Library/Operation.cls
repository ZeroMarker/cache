/// 名称: DHCMed.CCService.Library.Operation
/// 描述: 手术记录监控
/// 编写者：zhufei
/// 编写日期: 2014-05-29
Class DHCMed.CCService.Library.Operation Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.Operation).Test()
ClassMethod Test()
{
	New
	Set %FromDate="2016-04-29"
	Set %ToDate="2016-04-29"
	
	Set %EpisodeID=21977096
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckCutGrade("I")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-02-26
/// Description:  手术切口等级监测函数库
/// Table：       
/// Input：       
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(DHCMed.CCService.Library.Operation).CheckCutGrade()
ClassMethod CheckCutGrade(aCutGrade As %String = "") As %String
{
	New (aCutGrade,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckCutGradeErr"
	
	Set Count=0
	Set arrRec=##Class(DHCMed.DPCustom.Data.Operation).GetDataByAdm(%EpisodeID,%FromDate,%ToDate)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set CutGrade=objRec.CutGrade
		
		Continue:(aCutGrade'="")&&(aCutGrade'=CutGrade)
		Set Count=Count+1
		Set Summary="【"_CutGrade_"】"_objRec.OperDesc
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=objRec.OperDesc
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="OPR"
		Set $p(TempData,$c(3),11)=objRec.SttDate
		Set $p(TempData,$c(3),12)=objRec.SttTime
		Set $p(TempData,$c(3),13)=objRec.EndDate
		Set $p(TempData,$c(3),14)=objRec.EndTime
		
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	Set return=Count
	
	Quit return
	
CheckCutGradeErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
