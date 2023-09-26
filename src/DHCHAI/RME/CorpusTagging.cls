/// 感染标注词库-语料库
Class DHCHAI.RME.CorpusTagging Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 短语 与归一词对应
Property BTPhrase As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标注分类（诊断、症状、用药等）
Property BTTagCat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 感染语义词（多词#分隔）
Property BTInfWord As %String(MAXLEN = 500, TRUNCATE = 1);

/// 感染部位词（多词#分隔）
Property BTPosWord As %String(MAXLEN = 500, TRUNCATE = 1);

/// 标注类型（阳性+、阴性-、疑似?）
Property BTTagType As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexPhrase On BTPhrase;

Index IndexInfWord On BTInfWord;

Index IndexPosWord On BTPosWord;

/// Creator：     zhufei
/// CreatDate：   2019-09-04
/// Description:  根据短语取感染标注词库信息
/// Table：       DHCHAI.RME.CorpusTagging
/// Input：       aPhrase : 短语
/// Return：      返回obj
/// w ##class(DHCHAI.RME.CorpusTagging).GetObjByPhrase("上腹压痛")
ClassMethod GetObjByPhrase(aPhrase As %String) As DHCHAI.RME.CorpusTagging
{
	New (aPhrase)
	Set return = ""
	Quit:(aPhrase="") return
	
	Set ID=$o(^DHCHAI.RME.CorpusTaggingI("IndexPhrase"," "_$zcvt(aPhrase,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-04
/// Description:  根据ID取感染标注词库信息
/// Table：       DHCHAI.RME.CorpusTagging
/// Input：       aId : DHCHAI.RME.CorpusTagging.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.CorpusTagging).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.CorpusTagging
{
	New (aId)
	Quit:'##class(DHCHAI.RME.CorpusTagging).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.CorpusTagging).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2019-09-04
/// Description:  更新感染标注词库信息
/// Table：       DHCHAI.RME.CorpusTagging
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.CorpusTagging).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set Phrase     = $p(aInputStr,aSeparete,2)
	Set TagCat     = $p(aInputStr,aSeparete,3)
	Set IsActive   = +$p(aInputStr,aSeparete,4)
	Quit:(Phrase="") return
	
	// 短语唯一性
	Set tID=$o(^DHCHAI.RME.CorpusTaggingI("IndexPhrase"," "_$zcvt(Phrase,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.CorpusTagging).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.CorpusTagging).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTPhrase     = Phrase
	Set obj.BTTagCat     = TagCat
	Set obj.BTIsActive   = IsActive
	Set obj.BTActDate    = +$h
	Set obj.BTActTime    = $p($h,",",2)
	
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
/// CreatDate：   2019-09-04
/// Description:  更新标注词库感染信息
/// Table：       DHCHAI.RME.CorpusTagging
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.CorpusTagging).UpdateInfWord()
ClassMethod UpdateInfWord(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set InfWord    = $p(aInputStr,aSeparete,2)
	Set PosWord    = $p(aInputStr,aSeparete,3)
	Set TagType   = $p(aInputStr,aSeparete,4)
	Quit:(ID="")||(InfWord="") return
	
	Set obj=##class(DHCHAI.RME.CorpusTagging).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.BTInfWord    = InfWord
	Set obj.BTPosWord    = PosWord
	Set obj.BTTagType   = TagType
	
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
/// CreatDate：   2019-09-04
/// Description:  删除感染标注词库信息
/// Table：       DHCHAI.RME.CorpusTagging
/// Input：       aId : DHCHAI.RME.CorpusTagging.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.CorpusTagging).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.CorpusTagging")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.CorpusTagging).%DeleteId(aId)
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
<Data name="CorpusTaggingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTPhrase</Value>
</Value>
<Value name="3">
<Value>BTTagCat</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTInfWord</Value>
</Value>
<Value name="8">
<Value>BTPosWord</Value>
</Value>
<Value name="9">
<Value>BTTagType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.CorpusTaggingD</DataLocation>
<DefaultData>CorpusTaggingDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.CorpusTaggingD</IdLocation>
<IndexLocation>^DHCHAI.RME.CorpusTaggingI</IndexLocation>
<StreamLocation>^DHCHAI.RME.CorpusTaggingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
