/// 名称: DHCHAI.RMES.CorpusWordsSrv
/// 描述: 高频词服务类
/// 编写者：zhufei
/// 编写日期: 2019-08-14
Class DHCHAI.RMES.CorpusWordsSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCHAI.RMES.CorpusWordsSrv).ImportData("阿^啊^哎^哀^唉")
ClassMethod ImportData(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0,Count=0
	Quit:aInputStr="" return
	
	For indIS=1:1:$l(aInputStr,"^") {
		Set tKeyWord=$p(aInputStr,"^",indIS)
		Continue:tKeyWord=""
		
		Set IsActive=1,IsNegator=0,IsSuspect=0
		Set xID=$o(^DHCHAI.RME.CorpusWordsI("IdxKeyWord",tKeyWord,0))
		If xID'="" {
			Set obj=##class(DHCHAI.RME.CorpusWords).GetObjById(xID)
			If $IsObject(obj){
				Set IsActive=obj.BTIsActive
				Set IsNegator=obj.BTIsNegator
				Set IsSuspect=obj.BTIsSuspect
			}
		}
		
		Set InputStr=xID
		Set InputStr=InputStr_"^"_tKeyWord
		Set InputStr=InputStr_"^"_+IsActive
		Set InputStr=InputStr_"^"_+IsNegator
		Set InputStr=InputStr_"^"_+IsSuspect
		
		Set flg=##class(DHCHAI.RME.CorpusWords).Update(InputStr,"^")
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
}

/// w ##class(DHCHAI.RMES.CorpusWordsSrv).CheckCorpusPhrases()
ClassMethod CheckCorpusPhrases() As %String
{
	New
	Set return=0,Count=0
	
	Kill ^TMPCorusWords
	
	Set xCorpusPhrasesDr=0
	For {
		Set xCorpusPhrasesDr=$o(^DHCHAI.RME.CorpusPhrasesD(xCorpusPhrasesDr))
		Quit:xCorpusPhrasesDr=""
		
		Set CorpusPhrasesInfo=$g(^DHCHAI.RME.CorpusPhrasesD(xCorpusPhrasesDr))
		Continue:CorpusPhrasesInfo=""
		Set tLimitWords=$lg(CorpusPhrasesInfo,4)
		Continue:tLimitWords=""
		//Continue:$l(tLimitWords,";")<2
		
		For indLW=1:1:$l(tLimitWords,";") {
			Set tKeyWord=$p(tLimitWords,";",indLW)
			Continue:tKeyWord=""
			
			Set xxWord=$tr(tKeyWord,"1234567890. -:/+","")
			If xxWord'=tKeyWord {
				Continue:$tr(tKeyWord,"1234567890. -:/+年月日时分小时分钟岁周天入院停经绝经首次末次日期余年前身高cm体重Kg血压mmHg","")=""
			}
			Continue:($l(tKeyWord)<2)&("ABCDEFGHIJKLMNOPQRSTUVWXYZ"[$zcvt(tKeyWord,"U"))
			
			Set tKeyWord=$tr(tKeyWord,"|"," ")
			
			Set yKeyWord=""
			Set tCorpusWords=##class(DHCHAI.RMES.AnalyCorpusSrv).GetCorpusWords(tKeyWord)
			If tCorpusWords="" {
				Set ^TMPCorusWords("未结构化",tKeyWord)=tCorpusWords
			} Else {
				For indCW=1:2:$ll(tCorpusWords){
					Set tCorpusWord=$lg(tCorpusWords,indCW)
					Continue:tCorpusWord=""
					Set yKeyWord=yKeyWord_tCorpusWord
				}
				If yKeyWord'=tKeyWord {
					Set ^TMPCorusWords("结构化有误",tKeyWord)=tCorpusWords
				}
			}
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
}

}
