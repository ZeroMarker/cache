/// 短语规则-语料库
Class DHCHAI.RME.CorpusPhrases Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 短语 与归一词对应
Property BTPhrase As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 语境
Property BTContext As %String(MAXLEN = 500, TRUNCATE = 1);

/// 关联词组（例：腹主动脉;多发;斑块）
Property BTLimitWords As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 激活日期
Property BTActDate As %Date;

/// 激活时间
Property BTActTime As %Time;

/// 唯一索引
Index IdxLimitWords On BTLimitWords [ Unique ];

Index IndexLimitWords On (BTIsActive, BTLimitWords As Exact);

Index IndexPhrase On BTPhrase;

Index IndexContext On BTContext;

/// Creator：     zhufei
/// CreatDate：   2019-08-13
/// Description:  根据ID取短语规则信息
/// Table：       DHCHAI.RME.CorpusPhrases
/// Input：       aId : DHCHAI.RME.CorpusPhrases.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.CorpusPhrases).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.CorpusPhrases
{
	New (aId)
	Quit:'##class(DHCHAI.RME.CorpusPhrases).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.CorpusPhrases).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-08-13
/// Description:  更新短语规则信息
/// Table：       DHCHAI.RME.CorpusPhrases
/// Input：       aInputStr ：短语规则信息
/// Return：      成功：返回ID，失败：返回-1
/// w ##class(DHCHAI.RME.CorpusPhrases).Update()
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Phrase    = $p(aInputStr,aSeparete,2)
	Set Context   = $p(aInputStr,aSeparete,3)
	Set LimitWords= $p(aInputStr,aSeparete,4)
	Set IsActive  = +$p(aInputStr,aSeparete,5)
	Quit:(Phrase="")||(LimitWords="") return
	
	Set tID=$o(^DHCHAI.RME.CorpusPhrasesI("IdxLimitWords"," "_$zcvt(LimitWords,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	If tID="" {
		Set obj=##class(DHCHAI.RME.CorpusPhrases).%New()
	} Else {
		Set obj=##class(DHCHAI.RME.CorpusPhrases).GetObjById(tID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTPhrase    = Phrase
	Set obj.BTContext   = Context
	Set obj.BTLimitWords= LimitWords
	Set obj.BTIsActive  = IsActive
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
/// Description:  删除短语规则信息
/// Table：       DHCHAI.RME.CorpusPhrases
/// Input：       aId : DHCHAI.RME.CorpusPhrases.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.CorpusPhrases).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.CorpusPhrases")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.CorpusPhrases).%DeleteId(aId)
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
<Data name="CorpusPhrasesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTPhrase</Value>
</Value>
<Value name="3">
<Value>BTContext</Value>
</Value>
<Value name="4">
<Value>BTLimitWords</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.CorpusPhrasesD</DataLocation>
<DefaultData>CorpusPhrasesDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.CorpusPhrasesD</IdLocation>
<IndexLocation>^DHCHAI.RME.CorpusPhrasesI</IndexLocation>
<StreamLocation>^DHCHAI.RME.CorpusPhrasesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
