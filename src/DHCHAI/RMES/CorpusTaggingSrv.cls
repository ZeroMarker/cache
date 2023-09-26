/// 名称: DHCHAI.RMES.CorpusTaggingSrv
/// 描述: 标注词库服务类
/// 编写者：zhufei
/// 编写日期: 2019-09-04
Class DHCHAI.RMES.CorpusTaggingSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCHAI.RMES.CorpusTaggingSrv).SelectInfWords()
ClassMethod SelectInfWords() As %String
{
	New
	Set return="",Count=0
	
	Set MapRuleCatDr=""
	Set objMapRuleCat=##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule","感染语义词对照")
	If $Isobject(objMapRuleCat) {
		Set MapRuleCatDr=objMapRuleCat.%Id()
	}
	
	Set MapRuleCatDr2=""
	Set objMapRuleCat2=##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule","感染部位词对照")
	If $Isobject(objMapRuleCat2) {
		Set MapRuleCatDr2=objMapRuleCat2.%Id()
	}
	
	Set xPhrase=""
	For {
		Set xPhrase=$o(^DHCHAI.RME.CorpusTaggingI("IndexPhrase",xPhrase))
		Quit:xPhrase=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.RME.CorpusTaggingI("IndexPhrase",xPhrase,xID))
			Quit:xID=""
			
			Set objTag=##class(DHCHAI.RME.CorpusTagging).GetObjById(xID)
			Continue:'$isobject(objTag)
			Set Phrase=objTag.BTPhrase
			Set InfWord=objTag.BTInfWord
			Set PosWord=objTag.BTPosWord
			Set TagType=objTag.BTTagType
			//Continue:TagType'=""
			
			Set tInfWord=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(MapRuleCatDr,Phrase)
			Continue:tInfWord=""
			w tInfWord,!
			Set tInfWord=$tr(tInfWord,"^","#")
			
			Set tInfPos=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(MapRuleCatDr2,Phrase)
			Set tInfPos=$tr(tInfPos,"^","#")
			
			Set InputStr=xID_"^"_tInfWord_"^"_tInfPos_"^"_TagType
			Set flg=##class(DHCHAI.RME.CorpusTagging).UpdateInfWord(InputStr)
			If (+flg)>0 {
				Set Count=Count+1
			}
		}
	}
	
	Set return=Count
	Quit return
}

/// w ##class(DHCHAI.RMES.CorpusTaggingSrv).UpdateTagType("心绞痛^疼痛^0")
ClassMethod UpdateTagType(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return="",Count=0
	
	Set Phrase=$p(aInputStr,"^",1)
	Set InfWord=$p(aInputStr,"^",2)
	Set PosWord=$p(aInputStr,"^",3)
	Set TagType=$p(aInputStr,"^",4)
	Quit:(Phrase="")||(TagType="") return
	
	Set TagType=$s(TagType=1:"阳性(+)",TagType=2:"疑似(?)",1:"阴性(-)")
	
	Set objTag=##class(DHCHAI.RME.CorpusTagging).GetObjByPhrase(Phrase)
	Quit:'$isobject(objTag) return
	Set tID=objTag.%Id()
	Set tPhrase=objTag.BTPhrase
	Set tInfWord=objTag.BTInfWord
	Set:tInfWord="" tInfWord=InfWord
	Set tPosWord=objTag.BTPosWord
	Set:tPosWord="" tPosWord=PosWord
	
	Set InputStr=tID_"^"_tInfWord_"^"_tPosWord_"^"_TagType
	Set flg=##class(DHCHAI.RME.CorpusTagging).UpdateInfWord(InputStr)
	Set return=+flg
	Quit return
}

}
