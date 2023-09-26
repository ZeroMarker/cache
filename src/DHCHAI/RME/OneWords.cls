/// 归一词库
Class DHCHAI.RME.OneWords Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 词库版本
Property BTVersionDr As DHCHAI.RME.Version [ Required ];

/// 归一词
Property BTOneWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 实体分类
Property BTCatDr As DHCHAI.RME.ResultCat;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人(ID|姓名)
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexOneWord On (BTVersionDr, BTOneWord As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-08-11
/// Description:  根据OneWord取归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aVersionDr : DHCHAI.RME.OneWords.DMVersionDr
///               aOneWord : DHCHAI.RME.OneWords.BTOneWord
/// Return：      返回obj
/// w ##class(DHCHAI.RME.OneWords).GetObjByOneWord(1,"上腹压痛")
ClassMethod GetObjByOneWord(aVersionDr As %String, aOneWord As %String) As DHCHAI.RME.OneWords
{
	New (aVersionDr,aOneWord)
	Set return = ""
	Quit:(aVersionDr="")||(aOneWord="") return
	
	Set ID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",aVersionDr,aOneWord,0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据ID取归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aId : DHCHAI.RME.OneWords.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.OneWords).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.OneWords
{
	New (aId)
	Quit:'##class(DHCHAI.RME.OneWords).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.OneWords).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-30
/// Description:  判断归一词是否对照
/// Table：       DHCHAI.RME.OneWords
/// Input：       aThemeTypeDr : DHCHAI.RME.ThemeType.ID
///               aOneWordDr   : DHCHAI.RME.OneWords.ID
/// Return：      返回:  "" :没对照     不为空：返回对照的主题词
/// w ##class(DHCHAI.RME.OneWords).CheckOneWordsIsMap("1","归一词1")
ClassMethod CheckOneWordsIsMap(aThemeTypeDr As %String, aOneWordDr As %String) As %String
{
	New (aThemeTypeDr,aOneWordDr)
	Set return=""
	Quit:(aThemeTypeDr="")||(aOneWordDr="") return
	
	Set xThemeWordDr=0,ThemeWord=""
	For {
		Set xThemeWordDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",aOneWordDr,xThemeWordDr))
		Quit:xThemeWordDr=""
		
		Set objThemeWords=##class(DHCHAI.RME.ThemeWords).GetObjById(xThemeWordDr)
		Continue:'$IsObject(objThemeWords)
		Continue:'$IsObject(objThemeWords.BTThemeTypeDr)
		Continue:objThemeWords.BTThemeTypeDr.%Id()'=aThemeTypeDr
		Set return = objThemeWords.BTKeyWord
		Quit  //退出
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据版本ID和归一词取信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aVersionDr : DHCHAI.RME.Version.ID
///               aOneWord   : DHCHAI.RME.OneWords.BTOneWord
/// Return：      返回obj
/// w ##class(DHCHAI.RME.OneWords).GetObjByVerWord("1","归一词1")
ClassMethod GetObjByVerWord(aVersionDr As %String, aOneWord As %String) As DHCHAI.RME.OneWords
{
	New (aVersionDr,aOneWord)
	Set return=""
	Quit:(aVersionDr="")||(aOneWord="") return
	Set ID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",aVersionDr,aOneWord,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  更新归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.OneWords).Update("^3^归一词3^属性1|属性2|属性3|属性4^2017-08-11^12:34:44^周波2","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set VersionDr  = $p(aInputStr,aSeparete,2)
	Set OneWord    = $p(aInputStr,aSeparete,3)
	Set CatDr      = $p(aInputStr,aSeparete,4)
	Set ActDate    = $p(aInputStr,aSeparete,5)
	Set ActTime    = $p(aInputStr,aSeparete,6)
	Set ActUser    = $p(aInputStr,aSeparete,7)
	Set OneWord = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OneWord) //去掉特殊字符
	Quit:(VersionDr="")||(OneWord="") return
	Set objVersion=##class(DHCHAI.RME.Version).GetObjById(VersionDr)
	Quit:'$IsObject(objVersion) return
	Set objCat=##class(DHCHAI.RME.ResultCat).GetObjById(CatDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	// 归一词和词库版本ID唯一性
	Set tID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,OneWord,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.OneWords).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.OneWords).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTVersionDr  = objVersion
	Set obj.BTOneWord    = OneWord
	Set obj.BTCatDr      = objCat
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

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  删除归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aId : DHCHAI.RME.OneWords.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.OneWords).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.OneWords")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.OneWords).%DeleteId(aId)
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
<Data name="OneWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTVersionDr</Value>
</Value>
<Value name="3">
<Value>BTOneWord</Value>
</Value>
<Value name="4">
<Value>BTCatDr</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.OneWordsD</DataLocation>
<DefaultData>OneWordsDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.OneWordsD</IdLocation>
<IndexLocation>^DHCHAI.RME.OneWordsI</IndexLocation>
<StreamLocation>^DHCHAI.RME.OneWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
