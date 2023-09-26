/// 主题分类
Class DHCHAI.RME.ThemeType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标签
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 说明
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 词库版本
Property BTVersionDr As DHCHAI.RME.Version;

/// 是否有效
Property BTIsActive As %Boolean;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人(ID|姓名)
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On BTCode;

/// 词库版本索引
Index IndexVersionDr On BTVersionDr;

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据ID取主题分类信息
/// Table：       DHCHAI.RME.ThemeType
/// Input：       aId : DHCHAI.RME.ThemeType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThemeType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.ThemeType
{
	New (aId)
	Quit:'##class(DHCHAI.RME.ThemeType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.ThemeType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据Code取主题分类信息
/// Table：       DHCHAI.RME.ThemeType
/// Input：       aCode : DHCHAI.RME.ThemeType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThemeType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.RME.ThemeType
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCHAI.RME.ThemeTypeI("IndexCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-10-16
/// Description:  根据主题代码取语义词版本
/// Table：       DHCHAI.RME.ThemeType、DHCHAI.RME.Version
/// Input：       aCode : DHCHAI.RME.ThemeType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.ThemeType).GetVersionByThCode("HAI")
ClassMethod GetVersionByThCode(aThCode As %String) As DHCHAI.RME.Version
{
	New (aThCode)
	Set return=""
	Quit:aThCode="" return
	Set ID=$o(^DHCHAI.RME.ThemeTypeI("IndexCode"," "_$zcvt(aThCode,"U"),0))
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Set return=obj.BTVersionDr
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  更新主题分类信息
/// Table：       DHCHAI.RME.ThemeType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThemeType).Update("^ThemeType04^主题分类04^2^1^2017-08-10^12:12:23^周波2","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set Code      = $p(aInputStr,aSeparete,2)
	Set Desc      = $p(aInputStr,aSeparete,3)
	Set VersionDr = $p(aInputStr,aSeparete,4)
	Set IsActive  = +$p(aInputStr,aSeparete,5)
	Set ActDate   = $p(aInputStr,aSeparete,6)
	Set ActTime   = $p(aInputStr,aSeparete,7)
	Set ActUser   = $p(aInputStr,aSeparete,8)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objVersion=##class(DHCHAI.RME.Version).GetObjById(VersionDr)
	Quit:'$IsObject(objVersion) return
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.ThemeTypeI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.ThemeType).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.ThemeType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode      = Code
	Set obj.BTDesc      = Desc
	Set obj.BTVersionDr = objVersion
	Set obj.BTIsActive  = IsActive
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUser   = ActUser
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Do objVersion.%Close()
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  删除主题分类信息
/// Table：       DHCHAI.RME.ThemeType
/// Input：       aId : DHCHAI.RME.ThemeType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.ThemeType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.ThemeType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.ThemeType).%DeleteId(aId)
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
<Data name="ThemeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTVersionDr</Value>
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
<Value name="8">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.ThemeTypeD</DataLocation>
<DefaultData>ThemeTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.ThemeTypeD</IdLocation>
<IndexLocation>^DHCHAI.RME.ThemeTypeI</IndexLocation>
<StreamLocation>^DHCHAI.RME.ThemeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
