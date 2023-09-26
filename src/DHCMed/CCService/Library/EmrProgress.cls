/// 名称: DHCMed.CCService.Library.EmrProgress
/// 描述: 电子病历病程记录监控
/// 编写者：zhufei
/// 编写日期: 2014-02-26
Class DHCMed.CCService.Library.EmrProgress Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.EmrProgress).Test()
ClassMethod Test()
{
	New
	Set %FromDate="2013-10-01"
	Set %ToDate="2016-7-12"
	
	Set %EpisodeID=149
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckMultiData()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-02-26
/// Description:  日常病程监测函数库
/// Table：       
/// Input：       
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(DHCMed.CCService.Library.EmrProgress).CheckMultiData()
ClassMethod CheckMultiData() As %String
{
	New (%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckMultiDataErr"
	
	
	Set Count=0
	Set arrRec=##Class(DHCMed.DPCustom.Data.EmrProgress).GetDataByAdm(%EpisodeID,%FromDate,%ToDate,"EMR-PN")
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set DataValue=objRec.DataValue
		Continue:DataValue=""
		Set ActWords=objRec.ActWords
		Set OthWords=$lb("无","未闻及")
		Set AAAWords=""
		For indKey=1:1:$l(ActWords,"^") {
			Set KeyWord=$p(ActWords,"^",indKey)
			Continue:KeyWord=""
			
			For indOth=1:1:$listlength(OthWords) {
				Set OthKeyWord=$list(OthWords,indOth)
				Continue:OthKeyWord=""
				
				Set tmpKeyWord=OthKeyWord_KeyWord
				Set tmpDataValue=""
				For indVal=1:1:$l(DataValue,tmpKeyWord) {
					Set tmpDataValue=tmpDataValue_$p(DataValue,tmpKeyWord,indVal)
				}
				Set DataValue=tmpDataValue
				Continue:DataValue=""
			}
			Continue:DataValue=""
			Continue:DataValue'[KeyWord
			Set AAAWords=AAAWords_"^"_KeyWord
		}
		Continue:AAAWords=""
		Set:AAAWords'="" AAAWords=$e(AAAWords,2,$l(AAAWords))
		
		Set Count=Count+1
		
		Set TempData=""
		Set $p(TempData,$c(3),1)="【"_objRec.Title_"】"_$tr(AAAWords,"^","、")
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=AAAWords
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.HappenDate
		Set $p(TempData,$c(3),9)=objRec.HappenTime
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	Set return=Count
	
	Quit return
	
CheckMultiDataErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
