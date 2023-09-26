/// 名称: DHCMed.CCService.Library.RISReport
/// 描述: 与RIS相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-04-17
Class DHCMed.CCService.Library.RISReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.RISReport).Test()
ClassMethod Test()
{
	New
	Set %FromDate=""
	Set %ToDate=""
	
	Set %EpisodeID=3882195
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckChest()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-04-13
/// Description:  根据关键词筛查胸片
/// Table：       DHCRB_Report
/// Input：       aItemAlias 项目描述
/// Return：      返回RIS数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.RISReport).CheckChest()
ClassMethod CheckChest(aItemAlias As %String = "") As %String
{
	New (aItemAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckChestErr"
	
	Set aItemAlias=$zcvt(aItemAlias,"U"),aItemAlias=$tr(aItemAlias," ","")
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.RISReport).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"RIS-CHESTITM")

	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set OEItemDesc=objRec.OEItemDesc
		Continue:(aItemAlias'="")&&(OEItemDesc'[aItemAlias)
		
		Set ResultDesc=objRec.ResultDesc
		Continue:ResultDesc=""
		Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("RIS-CHESTDAT",ResultDesc)
		Continue:checkFlag'=""
		Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check1("RIS-CHESTDAT",ResultDesc)
		Continue:checkFlag=""
		Set WordList=""
		For indWord=1:1:$listlength(checkFlag) {
			Set tmpWord=$list(checkFlag,indWord)
			Continue:tmpWord=""
			Set WordList=WordList_"^"_tmpWord
		}
		Set:WordList'="" WordList=$e(WordList,2,$l(WordList))
		Continue:WordList=""
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set Count=Count+1
		
		Set Summary="【"_WordList_"】"_objRec.ResultDesc_";"_objRec.ExamDesc
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=WordList
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)="aItemAlias="_aItemAlias
		Set $p(TempData,$c(3),8)=objRec.RegDate
		Set $p(TempData,$c(3),9)=objRec.RegTime
		Set $p(TempData,$c(3),10)="RIS"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckChestErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
