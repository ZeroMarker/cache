/// 同义词库
Class DHCHAI.RME.ParserWords Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 词库版本
Property BTVersionDr As DHCHAI.RME.Version [ Required ];

/// 同义词
Property BTKeyWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关联属性
Property BTLimitWord As %String(MAXLEN = 100, TRUNCATE = 1);

/// 同义词组
Property BTWordGroup As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 同义词语境（如：超声心动图发现赘生物）
Property BTContext As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 归一词
Property BTOneWordDr As DHCHAI.RME.OneWords;

/// 是否审核
Property BTIsCheck As %Boolean;

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人(ID|姓名)
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexWordGroup On (BTVersionDr, BTWordGroup) [ Unique ];

Index IndexKeyWord On (BTVersionDr, BTKeyWord As Exact);

Index IndexOneWordDr On (BTVersionDr, BTOneWordDr As Exact);

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据ID取同义词信息
/// Table：       DHCHAI.RME.ParserWords
/// Input：       aId : DHCHAI.RME.ParserWords.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ParserWords).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ParserWords
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ParserWords).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ParserWords).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据版本ID和归一词取信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aVersionDr : DHCHAI.RME.Version.ID
///               aKeyWord   : 关键词
///               aLimitWord : 关联属性
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ParserWords).GetObjByVerKeyWord("1","三叉神经疼","")
ClassMethod GetObjByVerKeyWord(aVersionDr As %String, aKeyWord As %String, aLimitWord As %String) As DHCHAI.RME.OneWords
{
	New (aVersionDr,aKeyWord,aLimitWord)
	Set return=""
	Quit:(aVersionDr="")||(aKeyWord="") return
	
	Set WordGroup=aKeyWord_"!!"_aLimitWord
	Set ID=$o(^DHCHAI.RME.ParserWordsI("IndexWordGroup",aVersionDr," "_$zcvt(WordGroup,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  更新同义词信息
/// Table：       DHCHAI.RME.ParserWords
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ParserWords).Update("^2^同义词2^属性1|属性2|属性3|属性4^1^1^1^2017-08-11^12:34:44^周波1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set VersionDr  = $p(aInputStr,aSeparete,2)
	Set KeyWord    = $p(aInputStr,aSeparete,3)
	Set LimitWord  = $p(aInputStr,aSeparete,4)
	Set Context    = $p(aInputStr,aSeparete,5)
	Set OneWordDr  = $p(aInputStr,aSeparete,6)
	Set IsCheck    = +$p(aInputStr,aSeparete,7)
	Set IsActive   = +$p(aInputStr,aSeparete,8)
	Set ActDate    = $p(aInputStr,aSeparete,9)
	Set ActTime    = $p(aInputStr,aSeparete,10)
	Set ActUser    = $p(aInputStr,aSeparete,11)
	Quit:(VersionDr="")||(KeyWord="") return
	Set KeyWord = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(KeyWord) //去掉特殊字符
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objVersion=##class(DHCHAI.RME.Version).GetObjById(VersionDr)
	Quit:'$IsObject(objVersion) return
	
	Set objOneWords=##class(DHCHAI.RME.OneWords).GetObjById(OneWordDr)
	
	Set WordGroup=KeyWord_"!!"_LimitWord
	
	// 词库版本ID+归一词+同义词唯一性
	Set tID=$o(^DHCHAI.RME.ParserWordsI("IndexWordGroup",VersionDr," "_$zcvt(WordGroup,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ParserWords).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ParserWords).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTVersionDr  = objVersion
	Set obj.BTKeyWord    = KeyWord
	Set obj.BTLimitWord  = LimitWord
	Set obj.BTWordGroup  = WordGroup
	Set obj.BTContext    = Context
	Set obj.BTOneWordDr  = objOneWords
	Set obj.BTIsCheck    = IsCheck
	Set obj.BTIsActive   = IsActive
	Set obj.BTActDate    = ActDate
	Set obj.BTActTime    = ActTime
	Set obj.BTActUser    = ActUser
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-16
/// Description:  作废同义词信息
/// Table：       DHCHAI.RME.ParserWords
/// Input：       aId : DHCHAI.RME.ParserWords.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ParserWords).CancelById(1)
ClassMethod CancelById(aId As %String, aUserDr As %String) As %String
{
	New (aId,aUserDr)
	Set return=0
	Quit:aId="" return
	
	Set obj=##class(DHCHAI.RME.ParserWords).%OpenId(aId)
	Quit:'$IsObject(obj) return
	
	Set obj.BTIsActive   = 0
	Set obj.BTActDate    = +$h
	Set obj.BTActTime    = $p($h,",",2)
	Set obj.BTActUser    = aUserDr
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  删除同义词信息
/// Table：       DHCHAI.RME.ParserWords
/// Input：       aId : DHCHAI.RME.ParserWords.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ParserWords).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ParserWords")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ParserWords).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ParserWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTVersionDr</Value>
</Value>
<Value name="3">
<Value>BTKeyWord</Value>
</Value>
<Value name="4">
<Value>BTLimitWord</Value>
</Value>
<Value name="5">
<Value>BTWordGroup</Value>
</Value>
<Value name="6">
<Value>BTContext</Value>
</Value>
<Value name="7">
<Value>BTOneWordDr</Value>
</Value>
<Value name="8">
<Value>BTIsCheck</Value>
</Value>
<Value name="9">
<Value>BTIsActive</Value>
</Value>
<Value name="10">
<Value>BTActDate</Value>
</Value>
<Value name="11">
<Value>BTActTime</Value>
</Value>
<Value name="12">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ParserWordsD</DataLocation>
<DefaultData>ParserWordsDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ParserWordsD</IdLocation>
<IndexLocation>^DHCHAI.RME.ParserWordsI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ParserWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
