/// 创建者：李阳
/// 创建日期：2013-12-24
/// 功能：对文本进行分析，用来检索关键字
Class DHCMed.DPCustom.Meta.HIS.TextAnalyse Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(DHCMed.DPCustom.Meta.HIS.TextAnalyse).ExtractData(0,0,"EPRKeyWord")

/// 获取拆分字符串，用来将文本中的话语依照标点符号拆分成短语，然后再进行比对
ClassMethod GetSplitCharList() As %String
{
	Set KeyWord=""
	Set ret=""
	For {
		Set KeyWord=$o(^DHCMed.DP.Meta.KeyWordI("IndexKeyWord","Delimiter",1,KeyWord))
		Quit:KeyWord=""
		Set tKeyWord=KeyWord
		Set ret=ret_tKeyWord
	}
	Quit ret_$c(13,10)
}

/// 获取否定性词语的列表，用来判断短语中是否包含否定意思
ClassMethod GetNegativeList() As %String
{
		Quit "否^不^无"
}

ClassMethod ExtractData(FromDate As %Date, ToDate As %Date, KeyWordCategory As %String) As %Integer
{
	n (FromDate,ToDate,KeyWordCategory)
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.DP.Meta.EmrProgressNoteD(RowID))
			Quit:RowID=""
			Continue:'##class(DHCMed.DP.Meta.EmrProgressNote).%ExistsId(RowID)
			Set objNote=##class(DHCMed.DP.Meta.EmrProgressNote).GetObjById(RowID)
			Continue:'$IsObject(objNote)
			Do objNote.%Close()
			Set ret=..ExamContent(objNote.EPNProNoteRec,KeyWordCategory)
			Continue:ret=""
			Set objNote.EPNKeyWords=ret
			W objNote.%Id(),!
			Do objNote.%Save()
		}
		Quit "OK"
}

ClassMethod ExamContent(Content As %GlobalCharacterStream, KWCategory As %String) As %String
{
		n (Content,KWCategory)
		Set repid=$I(^CacheTemp)
		Set SplitCharList=..GetSplitCharList()
		Set PartStr=""
		Do Content.Rewind()
		Set ret=""
		For {
			Quit:Content.AtEnd
			Set char=Content.Read(1) //读取一个字符
			if (SplitCharList[char) {
				Set tmpRet=..ExamPhrase(PartStr,KWCategory)
				if (tmpRet'="") {
					Set WordList(tmpRet)=""
					Set PartStr=""
				}
			}
			else {
				Set PartStr=PartStr_char
			}
		}
		Set Word=""
		For {
			Set Word=$o(WordList(Word))
			Quit:Word=""
			Set:ret'="" ret=ret_"^"
			Set ret=ret_Word
		}
		Quit ret
}

/// 短语分析
ClassMethod ExamPhrase(strPhrase As %String, KeyWordCategory As %String) As %String
{
		n (strPhrase,KeyWordCategory)
		Quit:strPhrase="" ""
		Set ret=""
		Set KeyWord=""
		Set IsNegative=0
		For {
			Set KeyWord=$o(^DHCMed.DP.Meta.KeyWordI("IndexKeyWord","NegativeWord",1,KeyWord))
			Quit:KeyWord=""
			Set tKeyWord=$Extract(KeyWord,2,$l(KeyWord))
			Set PosList=..ContainsWord(strPhrase,tKeyWord)
			Continue:PosList=0
			Set IsNegative=1
			//w "包含否定词语："_KeyWord,!
		}
		Quit:IsNegative "" //包含否定词语，不再进行下一步判断
		
		Set KeyWordList=""
		For {
			Set KeyWordList=$o(^DHCMed.DP.Meta.KeyWordI("IndexKeyWord",KeyWordCategory,1,KeyWordList))
			Quit:KeyWordList=""
			For i=1:1:$l(KeyWordList,"^") {
				Set KeyWord=$p(KeyWordList,"^",i)
				Continue:KeyWord=""
				Set PosList=..ContainsWord(strPhrase,KeyWord)
				Continue:PosList=0
				Set WordID=""
				For {
					Set WordID=$o(^DHCMed.DP.Meta.KeyWordI("IndexKeyWord",KeyWordCategory,1,KeyWordList,WordID))
					Quit:WordID=""
					Set objWord=##class(DHCMed.DP.Meta.KeyWord).%OpenId(WordID)
					Continue:'$IsObject(objWord)
					Do objWord.%Close()
					Set:ret'="" ret=ret_$c(1)
					Set ret=ret_KeyWord_"^"_objWord.Name
					Set objWord=""
					Kill objWord
				}
			}
		}
		Quit ret
}

/// 判断一个短语中是否包含某个词语
/// 参数：
/// Phrase:需要分析的短语
/// Word:待匹配的词语
/// 返回值：
/// 词语出现的位置列表，如果多次出现，返回位置用^拆分，如果没找到，返回0
ClassMethod ContainsWord(Phrase As %String, Word As %String) As %String
{
		n (Phrase,Word)
		Quit:Word="" 0
		Set ret=""
		Set Pos=0
		For {
			Set Pos=$find(Phrase,Word,Pos) //查找字符串
			Quit:(Pos=0)
			Set:ret'="" ret=ret_"^"
			Set ret=ret_(Pos-$l(Word))
		}	
		Set:ret="" ret=0
		Quit ret
}

}
