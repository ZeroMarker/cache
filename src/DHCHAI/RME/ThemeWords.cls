/// 主题词库
Class DHCHAI.RME.ThemeWords Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主题类型
Property BTThemeTypeDr As DHCHAI.RME.ThemeType [ Required ];

/// 主题关键词（如：赘生物）
Property BTKeyWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关联属性（如：超声心动图）
Property BTLimitWord As %String(MAXLEN = 100, TRUNCATE = 1);

/// 词组（如：赘生物+超声心动图）
Property BTWordGroup As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关键词分类（症状或体征、诊断、检出菌、常规检验异常）
Property BTWordTypeDr As DHCHAI.RME.ThWordType;

/// 主题词语境（如：超声心动图发现赘生物）
Property BTContext As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人(ID|姓名)
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主题词属性（1：特异  2：一般）
Property BTWordAttr As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexWordGroup On (BTThemeTypeDr, BTWordGroup) [ Unique ];

Index IndexKeyWord On (BTThemeTypeDr, BTKeyWord);

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  根据ID取主题词库信息
/// Table：       DHCHAI.RME.ThemeWords
/// Input：       aId : DHCHAI.RME.ThemeWords.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThemeWords).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ThemeWords
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ThemeWords).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ThemeWords).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  根据Code取主题词库信息
/// Table：       DHCHAI.RME.ThemeWords
/// Input：       aThemeTypeDr  : DHCHAI.RME.ThemeWords.BTThemeTypeDr
/// 	          aKeyWord : DHCHAI.RME.ThemeWords.BTKeyWord
///               aLimitWord : DHCHAI.RME.ThemeWords.BTLimitWord
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThemeWords).GetObjByCode("1","赘生物","超声心动图")
ClassMethod GetObjByCode(aThemeTypeDr As %String, aKeyWord As %String, aLimitWord As %String) As DHCHAI.RME.ThemeWords
{
	New (aThemeTypeDr,aKeyWord,aLimitWord)
	Quit:(aThemeTypeDr="")||(aKeyWord="") ""
	
	Set WordGroup=aKeyWord_"!!"_aLimitWord
	Set ID=$o(^DHCHAI.RME.ThemeWordsI("IndexWordGroup",aThemeTypeDr," "_$zcvt(WordGroup,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  更新主题词库信息
/// Table：       DHCHAI.RME.ThemeWords
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThemeWords).Update("^1^赘生物1^1^关联属性1^语境次包含赘生物1^1^2017-08-14^12:12:23^周波2","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set ThemeTypeDr = $p(aInputStr,aSeparete,2)
	Set KeyWord     = $p(aInputStr,aSeparete,3)
	Set LimitWord   = $p(aInputStr,aSeparete,4)
	Set WordTypeDr  = $p(aInputStr,aSeparete,5)
	Set Context     = $p(aInputStr,aSeparete,6)
	Set IsActive    = +$p(aInputStr,aSeparete,7)
	Set ActDate     = $p(aInputStr,aSeparete,8)
	Set ActTime     = $p(aInputStr,aSeparete,9)
	Set ActUser     = $p(aInputStr,aSeparete,10)
	Set WordAttr    = $p(aInputStr,aSeparete,11)
	Quit:(ThemeTypeDr="")||(KeyWord="") return
	Set KeyWord = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(KeyWord) //去掉特殊字符
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(ThemeTypeDr)
	Quit:'$IsObject(objThemeType) return
	
	Set objWordType=##class(DHCHAI.RME.ThWordType).GetObjById(WordTypeDr)
	
	Set WorkGroup=KeyWord_"!!"_LimitWord
	
	// 主题类型、关键词、语境唯一性
	Set tID=$o(^DHCHAI.RME.ThemeWordsI("IndexWordGroup",ThemeTypeDr," "_$zcvt(WorkGroup,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ThemeWords).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ThemeWords).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTThemeTypeDr = objThemeType
	Set obj.BTKeyWord     = KeyWord
	Set obj.BTLimitWord   = LimitWord
	Set obj.BTWordGroup   = WorkGroup
	Set obj.BTWordTypeDr  = objWordType
	Set obj.BTContext     = Context
	Set obj.BTIsActive    = IsActive
	Set obj.BTActDate     = ActDate
	Set obj.BTActTime     = ActTime
	Set obj.BTActUser     = ActUser
	Set obj.BTWordAttr    = WordAttr
	
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
/// CreatDate：   2017-08-14
/// Description:  删除主题词库信息
/// Table：       DHCHAI.RME.ThemeWords
/// Input：       aId : DHCHAI.RME.ThemeWords.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThemeWords).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ThemeWords")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ThemeWords).%DeleteId(aId)
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
<Data name="ThemeWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTThemeTypeDr</Value>
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
<Value>BTWordTypeDr</Value>
</Value>
<Value name="7">
<Value>BTContext</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUser</Value>
</Value>
<Value name="12">
<Value>BTWordAttr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ThemeWordsD</DataLocation>
<DefaultData>ThemeWordsDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ThemeWordsD</IdLocation>
<IndexLocation>^DHCHAI.RME.ThemeWordsI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ThemeWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
