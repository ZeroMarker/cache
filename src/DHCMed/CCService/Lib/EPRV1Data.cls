/// 名称: DHCMed.CCService.Lib.EPRV1Data
/// 描述: 与1.0版电子病历相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-05-05
Class DHCMed.CCService.Lib.EPRV1Data Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.EPRV1Data).Test()
ClassMethod Test()
{
	New
	Set %EpisodeID=2698897
	
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckSingleData("#{44||1-G-1016-dbx108-T}","肿瘤")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-05-05
/// Description:  通过关键字检查唯一模板的单元值
/// Table：       
/// Input：       Input: "唯一模板单元","霍乱"
/// Return：      ret=-1：Error，ret=0：不包含，ret=1：包含
/// w ##class(DHCMed.CCService.Lib.EPRV1Data).CheckSingleData(单元Code,关键字)
ClassMethod CheckSingleData(argElCode As %String, argDesc As %String) As %String
{
	New (argElCode,argDesc,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Quit:(argElCode="")||(argDesc="") return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckSingleDataErr"
	ZN "EPR"
	Set EPRData=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(%EpisodeID,argElCode,0)
	ZN "WEBSOURCE"
	Set EPRData=$tr(EPRData,$c(13),";")
	Quit:EPRData="" return
	Quit:EPRData'[argDesc return
	
	Set return=1
	Set EPRRst=EPRData
	Set ElDesc=$p(argElCode,"#",1)
	Set:ElDesc'="" EPRRst=$$BuildCheckSingleDataResult(1)
	Set %ExtraData=%ExtraData_$lb(EPRRst)
	
	Quit return
	
CheckSingleDataErr
	ZN "WEBSOURCE"
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckSingleDataResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=EPRRst_"("_ElDesc_")"
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=0 //日期
	Set $p(tmp,$c(3),3)=0 //事件
	Set $p(tmp,$c(3),4)=tmpDesc
	Set $p(tmp,$c(3),5)=0 //ID
	Set $p(tmp,$c(3),6)=0 //User ID
	Set $p(tmp,$c(3),7)="argElCode="_argElCode_";argDesc="_argDesc
	Quit tmp
}

}
