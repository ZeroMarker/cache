/// 主题词映射
Class DHCHAI.RME.ThWordsMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主题词
Property BTThWordDr As DHCHAI.RME.ThemeWords [ Required ];

/// 归一词
Property BTOneWordDr As DHCHAI.RME.OneWords [ Required ];

/// 文档类型
Property BTDocTypeDr As DHCHAI.RME.DocType;

/// 段落类型
Property BTSectionTypeDr As DHCHAI.RME.SectionType;

/// 属性类型
Property BTPropertyTypeDr As DHCHAI.RME.PropertyType;

/// 属性值
Property BTDocProperty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人(ID|姓名)
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否审核
Property BTIsCheck As %Boolean;

/// 审核日期
Property BTCheckDate As %Date;

/// 审核时间
Property BTCheckTime As %Time;

/// 审核人(ID|姓名)
Property BTCheckUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主题词+归一词索引
Index IndexThWordOneWord On (BTThWordDr, BTOneWordDr);

/// 归一词+主题词索引
Index IndexOneWordThWord On (BTOneWordDr, BTThWordDr);

/// 是否审核 索引
Index IndexThWordIsCheck On (BTThWordDr, BTIsCheck);

/// Creator：     zhufei
/// CreatDate：   2017-10-15
/// Description:  取归一词与主题词对照
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       aThWordDr : DHCHAI.RME.ThWordsMap.BTThWordDr
///               aOneWordDr : DHCHAI.RME.ThWordsMap.BTOneWordDr
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThWordsMap).GetThWordsMapByThOne(88,517)
ClassMethod GetThWordsMapByThOne(aThWordDr As %String, aOneWordDr As %String) As DHCHAI.RME.ThWordsMap
{
	New (aThWordDr,aOneWordDr)
	Set return = ""
	Quit:(aThWordDr="")||(aOneWordDr="") return
	
	Set ID=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",aThWordDr,aOneWordDr,0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  根据ID取主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       aId : DHCHAI.RME.ThWordsMap.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThWordsMap).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ThWordsMap
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ThWordsMap).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ThWordsMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  更新主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordsMap).Update("^1^赘生物^1^1^2017-08-14^12:12:23^周波1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID             = $p(aInputStr,aSeparete,1)
	Set ThWordDr       = $p(aInputStr,aSeparete,2)
	Set OneWordDr      = $p(aInputStr,aSeparete,3)
	Set DocTypeDr      = $p(aInputStr,aSeparete,4)
	Set SectionTypeDr  = $p(aInputStr,aSeparete,5)
	Set PropertyTypeDr = $p(aInputStr,aSeparete,6)
	Set DocProperty    = $p(aInputStr,aSeparete,7)
	Set ActDate        = $p(aInputStr,aSeparete,8)
	Set ActTime        = $p(aInputStr,aSeparete,9)
	Set ActUser        = $p(aInputStr,aSeparete,10)
	Set IsActive       = +$p(aInputStr,aSeparete,11)
	Set IsCheck        = +$p(aInputStr,aSeparete,12)
	Set CheckDate      = $p(aInputStr,aSeparete,13)
	Set CheckTime      = $p(aInputStr,aSeparete,14)
	Set CheckUser      = $p(aInputStr,aSeparete,15)
	Quit:(ThWordDr="")||(OneWordDr="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objThemeWords=##class(DHCHAI.RME.ThemeWords).GetObjById(ThWordDr)
	Quit:'$IsObject(objThemeWords) return
	Set objOneWords=##class(DHCHAI.RME.OneWords).GetObjById(OneWordDr)
	Quit:'$IsObject(objOneWords) return
	
	// 归一词和主题词 唯一性  不能重复保存
	Set tID=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",ThWordDr,OneWordDr,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objDocType=##class(DHCHAI.RME.DocType).GetObjById(DocTypeDr)
	Set objSectionType=##class(DHCHAI.RME.SectionType).GetObjById(SectionTypeDr)
	Set objPropertyType=##class(DHCHAI.RME.PropertyType).GetObjById(PropertyTypeDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ThWordsMap).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ThWordsMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTThWordDr       = objThemeWords
	Set obj.BTOneWordDr      = objOneWords
	Set obj.BTDocTypeDr      = objDocType
	Set obj.BTSectionTypeDr  = objSectionType
	Set obj.BTPropertyTypeDr = objPropertyType
	Set obj.BTDocProperty    = DocProperty
	Set obj.BTIsActive       = IsActive
	Set obj.BTActDate        = ActDate
	Set obj.BTActTime        = ActTime
	Set obj.BTActUser        = ActUser
	Set obj.BTIsCheck        = IsCheck
	Set obj.BTCheckDate      = CheckDate
	Set obj.BTCheckTime      = CheckTime
	Set obj.BTCheckUser      = CheckUser
	
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
/// CreatDate：   2019-04-09
/// Description:  设置主题词映射信息是否有效
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordsMap).SetIsAct()
ClassMethod SetIsAct(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID             = $p(aInputStr,aSeparete,1)
	Set IsActive       = +$p(aInputStr,aSeparete,2)
	Set ActDate        = $p(aInputStr,aSeparete,3)
	Set ActTime        = $p(aInputStr,aSeparete,4)
	Set ActUser        = $p(aInputStr,aSeparete,5)
	Quit:(ID="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set obj=##class(DHCHAI.RME.ThWordsMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.BTIsActive       = IsActive
	Set obj.BTActDate        = ActDate
	Set obj.BTActTime        = ActTime
	Set obj.BTActUser        = ActUser
	
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
/// CreatDate：   2019-04-09
/// Description:  审核主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordsMap).SetIsCheck()
ClassMethod SetIsCheck(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID             = $p(aInputStr,aSeparete,1)
	Set IsActive       = +$p(aInputStr,aSeparete,2)
	Set IsCheck        = +$p(aInputStr,aSeparete,3)
	Set CheckDate      = $p(aInputStr,aSeparete,4)
	Set CheckTime      = $p(aInputStr,aSeparete,5)
	Set CheckUser      = $p(aInputStr,aSeparete,6)
	Quit:(ID="") return
	
	Set:CheckDate'="" CheckDate=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
	Set:CheckDate="" CheckDate=+$h
	Set:CheckTime[":" CheckTime=$zth(CheckTime,1)
	Set:CheckTime="" CheckTime=$p($h,",",2)
	
	Set obj=##class(DHCHAI.RME.ThWordsMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.BTIsActive       = IsActive
	Set obj.BTIsCheck        = IsCheck
	Set obj.BTCheckDate      = CheckDate
	Set obj.BTCheckTime      = CheckTime
	Set obj.BTCheckUser      = CheckUser
	
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
/// Description:  删除主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       aId : DHCHAI.RME.ThWordsMap.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThWordsMap).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ThWordsMap")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ThWordsMap).%DeleteId(aId)
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
<Data name="ThWordsMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTThWordDr</Value>
</Value>
<Value name="3">
<Value>BTOneWordDr</Value>
</Value>
<Value name="4">
<Value>BTDocTypeDr</Value>
</Value>
<Value name="5">
<Value>BTSectionTypeDr</Value>
</Value>
<Value name="6">
<Value>BTPropertyTypeDr</Value>
</Value>
<Value name="7">
<Value>BTDocProperty</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUser</Value>
</Value>
<Value name="11">
<Value>BTIsActive</Value>
</Value>
<Value name="12">
<Value>BTIsCheck</Value>
</Value>
<Value name="13">
<Value>BTCheckDate</Value>
</Value>
<Value name="14">
<Value>BTCheckTime</Value>
</Value>
<Value name="15">
<Value>BTCheckUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ThWordsMapD</DataLocation>
<DefaultData>ThWordsMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ThWordsMapD</IdLocation>
<IndexLocation>^DHCHAI.RME.ThWordsMapI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ThWordsMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
