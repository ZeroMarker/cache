/// 高频词-语料库
Class DHCHAI.RME.CorpusWords Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 高频词
Property BTKeyWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 高频词-反词
Property BTNegWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 是否否定词
Property BTIsNegator As %Boolean;

/// 是否疑似词
Property BTIsSuspect As %Boolean;

/// 激活日期
Property BTActDate As %Date;

/// 激活时间
Property BTActTime As %Time;

/// 作为唯一索引使用
Index IdxKeyWord On BTKeyWord As Exact;

Index IndexKeyWord On (BTIsActive, BTKeyWord As Exact);

Index IndexNegWord On (BTIsActive, BTNegWord As Exact);

/// Creator：     zhufei
/// CreatDate：   2019-08-13
/// Description:  根据ID取高频词信息
/// Table：       DHCHAI.RME.CorpusWords
/// Input：       aId : DHCHAI.RME.CorpusWords.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.CorpusWords).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.CorpusWords
{
	New (aId)
	Quit:'##class(DHCHAI.RME.CorpusWords).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.CorpusWords).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-08-13
/// Description:  更新高频词信息
/// Table：       DHCHAI.RME.CorpusWords
/// Input：       aInputStr ：高频词信息
/// Return：      成功：返回ID，失败：返回-1
/// w ##class(DHCHAI.RME.CorpusWords).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set KeyWord   = $p(aInputStr,aSeparete,2)
	Set IsActive  = +$p(aInputStr,aSeparete,3)
	Set IsNegator = +$p(aInputStr,aSeparete,4)
	Set IsSuspect = +$p(aInputStr,aSeparete,5)
	Quit:KeyWord="" return
	
	Set NegWord=""
	For indLen=1:1:$l(KeyWord) {
		Set NegWord=NegWord_$e(KeyWord,*-indLen+1)
	}
	
	Set tID=$o(^DHCHAI.RME.CorpusWordsI("IdxKeyWord",KeyWord,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	If tID="" {
		Set obj=##class(DHCHAI.RME.CorpusWords).%New()
	} Else {
		Set obj=##class(DHCHAI.RME.CorpusWords).GetObjById(tID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTKeyWord   = KeyWord
	Set obj.BTNegWord   = NegWord
	Set obj.BTIsActive  = IsActive
	Set obj.BTIsNegator = IsNegator
	Set obj.BTIsSuspect = IsSuspect
	Set obj.BTActDate   = +$h
	Set obj.BTActTime   = $p($h,",",2)
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-08-13
/// Description:  删除高频词信息
/// Table：       DHCHAI.RME.CorpusWords
/// Input：       aId : DHCHAI.RME.CorpusWords.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.CorpusWords).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.CorpusWords")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.CorpusWords).%DeleteId(aId)
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
<Data name="CorpusWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTKeyWord</Value>
</Value>
<Value name="3">
<Value>BTNegWord</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTIsNegator</Value>
</Value>
<Value name="6">
<Value>BTIsSuspect</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.CorpusWordsD</DataLocation>
<DefaultData>CorpusWordsDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.CorpusWordsD</IdLocation>
<IndexLocation>^DHCHAI.RME.CorpusWordsI</IndexLocation>
<StreamLocation>^DHCHAI.RME.CorpusWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
