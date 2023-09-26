/// 名称: DHCHAI.RMES.CorpusPhrasesSrv
/// 描述: 短语规则服务类
/// 编写者：zhufei
/// 编写日期: 2019-08-16
Class DHCHAI.RMES.CorpusPhrasesSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCHAI.RMES.CorpusPhrasesSrv).ImportOneWords(1)
ClassMethod ImportOneWords(aVersionDr As %String) As %String
{
	New (aVersionDr)
	Set return=0,Count=0
	Quit:aVersionDr="" return
	
	Set xOneWordsDr=0
	For {
		Set xOneWordsDr=$o(^DHCHAI.RME.OneWordsD(xOneWordsDr))
		Quit:xOneWordsDr=""
		
		Set OneWordInfo=$g(^DHCHAI.RME.OneWordsD(xOneWordsDr))
		Continue:OneWordInfo=""
		Set tOneWord=$lg(OneWordInfo,3)
		Continue:tOneWord=""
		Set tCatDr=$lg(OneWordInfo,4)
		Set tCatCode=""
		If tCatDr'="" {
			Set tCatInfo=$g(^DHCHAI.RME.ResultCatD(tCatDr))
			Set tCatCode=$lg(tCatInfo,2)
		}
		
		Set xxWord=$tr(tOneWord,"1234567890. -:/+","")
		If xxWord'=tOneWord {
			Continue:$tr(tOneWord,"1234567890. -:/+年月日时分小时分钟岁周天入院停经绝经首次末次日期余年前身高cm体重Kg血压mmHg","")=""
		}
		Continue:($l(tOneWord)<2)&("ABCDEFGHIJKLMNOPQRSTUVWXYZ"[$zcvt(tOneWord,"U"))
		
		Set LimitWords=tOneWord
		
		Set IsActive=1,Context=""
		Set xID=$o(^DHCHAI.RME.CorpusPhrasesI("IdxLimitWords"," "_LimitWords,0))
		If xID'="" {
			Continue  //如果已经存在，不再导入
			Set obj=##class(DHCHAI.RME.CorpusPhrases).GetObjById(xID)
			If $IsObject(obj){
				Set IsActive = obj.BTIsActive
				Set Context  = obj.BTContext
			}
		}
		
		Set InputStr=xID
		Set InputStr=InputStr_"^"_tOneWord
		Set InputStr=InputStr_"^"_Context
		Set InputStr=InputStr_"^"_LimitWords
		Set InputStr=InputStr_"^"_IsActive
		
		Set flg=##class(DHCHAI.RME.CorpusPhrases).Update(InputStr,"^")
		If (+flg)>0 {
			Set Count=Count+1
			
			//保存标注词库（对应归一词库）
			Set ID="",Phrase=tOneWord,TagCat=tCatCode,IsActive=1
			Set objTag=##class(DHCHAI.RME.CorpusTagging).GetObjByPhrase(tOneWord)
			If $IsObject(objTag){
				Set ID=objTag.%Id()
				Set Phrase=objTag.BTPhrase
				Set TagCat=objTag.BTTagCat
				Set:TagCat="" TagCat=tCatCode
				Set IsActive=objTag.BTIsActive
			}
			Set InputStr=ID
			Set InputStr=InputStr_"^"_Phrase
			Set InputStr=InputStr_"^"_TagCat
			Set InputStr=InputStr_"^"_IsActive
			Set flg=##class(DHCHAI.RME.CorpusTagging).Update(InputStr,"^")
		}
	}
	Set return=Count
	Quit return
}

/// w ##class(DHCHAI.RMES.CorpusPhrasesSrv).ImportParserWords(1)
ClassMethod ImportParserWords(aVersionDr As %String) As %String
{
	New (aVersionDr)
	Set return=0,Count=0
	Quit:aVersionDr="" return
	
	Set xParserWordsDr=0
	For {
		Set xParserWordsDr=$o(^DHCHAI.RME.ParserWordsD(xParserWordsDr))
		Quit:xParserWordsDr=""
		
		Set ParserWordInfo=$g(^DHCHAI.RME.ParserWordsD(xParserWordsDr))
		Continue:ParserWordInfo=""
		Set tKeyWord=$lg(ParserWordInfo,3)
		Set tLimitWords=$lg(ParserWordInfo,4)
		Set tContext=$lg(ParserWordInfo,6)
		Set tOneWordDr=$lg(ParserWordInfo,7)
		Continue:tOneWordDr=""
		Set OneWordInfo=$g(^DHCHAI.RME.OneWordsD(tOneWordDr))
		Continue:OneWordInfo=""
		Set tOneWord=$lg(OneWordInfo,3)
		Continue:tOneWord=""
		Set tCatDr=$lg(OneWordInfo,4)
		Set tCatCode=""
		If tCatDr'="" {
			Set tCatInfo=$g(^DHCHAI.RME.ResultCatD(tCatDr))
			Set tCatCode=$lg(tCatInfo,2)
		}
		
		Set xxWord=$tr(tOneWord,"1234567890. -:/+","")
		If xxWord'=tOneWord {
			Continue:$tr(tOneWord,"1234567890. -:/+年月日时分小时分钟岁周天入院停经绝经首次末次日期余年前身高cm体重Kg血压mmHg","")=""
		}
		Continue:($l(tOneWord)<2)&("ABCDEFGHIJKLMNOPQRSTUVWXYZ"[$zcvt(tOneWord,"U"))
		
		Set LimitWords=$s(tLimitWords'="":tLimitWords,1:tKeyWord)
		Continue:LimitWords=""
		
		Set IsActive=1,Context=tContext
		Set xID=$o(^DHCHAI.RME.CorpusPhrasesI("IdxLimitWords"," "_$zcvt(LimitWords,"U"),0))
		If xID'="" {
			Continue  //如果已经存在，不再导入
			Set obj=##class(DHCHAI.RME.CorpusPhrases).GetObjById(xID)
			If $IsObject(obj){
				Set IsActive = obj.BTIsActive
				Set Context  = obj.BTContext
			}
		}
		
		Set InputStr=xID
		Set InputStr=InputStr_"^"_tOneWord
		Set InputStr=InputStr_"^"_Context
		Set InputStr=InputStr_"^"_LimitWords
		Set InputStr=InputStr_"^"_IsActive
		
		Set flg=##class(DHCHAI.RME.CorpusPhrases).Update(InputStr,"^")
		If (+flg)>0 {
			Set Count=Count+1
			
			//保存标注词库（对应归一词库）
			Set ID="",Phrase=tOneWord,TagCat=tCatCode,IsActive=1
			Set objTag=##class(DHCHAI.RME.CorpusTagging).GetObjByPhrase(tOneWord)
			If $IsObject(objTag){
				Set ID=objTag.%Id()
				Set Phrase=objTag.BTPhrase
				Set TagCat=objTag.BTTagCat
				Set:TagCat="" TagCat=tCatCode
				Set IsActive=objTag.BTIsActive
			}
			Set InputStr=ID
			Set InputStr=InputStr_"^"_Phrase
			Set InputStr=InputStr_"^"_TagCat
			Set InputStr=InputStr_"^"_IsActive
			Set flg=##class(DHCHAI.RME.CorpusTagging).Update(InputStr,"^")
		}
	}
	Set return=Count
	Quit return
}

}
