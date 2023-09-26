/// 语义词库版本
Class DHCHAI.RME.Version Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 版本代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 版本名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 外部关联码
Property BTLCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexCode On BTCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据ID取语义词库版本信息
/// Table：       DHCHAI.RME.Version
/// Input：       aId : DHCHAI.RME.Version.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.Version).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.Version
{
	New (aId)
	Quit:'##class(DHCHAI.RME.Version).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.Version).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  根据Code取语义词库版本信息
/// Table：       DHCHAI.RME.Version
/// Input：       aCode : DHCHAI.RME.Version.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.Version).GetObjByCode("V1.0.0")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.RME.Version
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCHAI.RME.VersionI("IndexCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  更新语义词库版本信息
/// Table：       DHCHAI.RME.Version
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.Version).Update("^Version02^语义词版本2","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set LCode    = $p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.VersionI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.Version).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.Version).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTLCode    = LCode
	
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
/// CreatDate：   2017-08-09
/// Description:  删除语义词库版本信息
/// Table：       DHCHAI.RME.Version
/// Input：       aId : DHCHAI.RME.Version.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.Version).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.Version")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.Version).%DeleteId(aId)
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
<Data name="VersionDefaultData">
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
<Value>BTLCode</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.VersionD</DataLocation>
<DefaultData>VersionDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.VersionD</IdLocation>
<IndexLocation>^DHCHAI.RME.VersionI</IndexLocation>
<StreamLocation>^DHCHAI.RME.VersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
