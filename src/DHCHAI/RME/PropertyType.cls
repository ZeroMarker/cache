/// 属性类型
Class DHCHAI.RME.PropertyType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexCode On BTCode As Exact;

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据ID取属性类型信息
/// Table：       DHCHAI.RME.PropertyType
/// Input：       aId : DHCHAI.RME.PropertyType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.RME.PropertyType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.RME.PropertyType
{
	New (aId)
	Quit:'##class(DHCHAI.RME.PropertyType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.RME.PropertyType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据Code取属性类型信息
/// Table：       DHCHAI.RME.PropertyType
/// Input：       aCode : DHCHAI.RME.PropertyType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.RME.PropertyType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.RME.PropertyType
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	Set ID=$o(^DHCHAI.RME.PropertyTypeI("IndexCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  更新属性类型信息
/// Table：       DHCHAI.RME.PropertyType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.RME.PropertyType).Update("^Property01^属性类型01","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	// 代码唯一性
	Set tID=$o(^DHCHAI.RME.PropertyTypeI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.RME.PropertyType).%New()
	}Else{
		Set obj=##class(DHCHAI.RME.PropertyType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode  = Code
	Set obj.BTDesc  = Desc
	
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
/// CreatDate：   2017-08-10
/// Description:  删除属性类型信息
/// Table：       DHCHAI.RME.PropertyType
/// Input：       aId : DHCHAI.RME.PropertyType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.RME.PropertyType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.RME.PropertyType")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.RME.PropertyType).%DeleteId(aId)
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
<Data name="PropertyTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DTCode</Value>
</Value>
<Value name="3">
<Value>DTDesc</Value>
</Value>
<Value name="4">
<Value>BTCode</Value>
</Value>
<Value name="5">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.RME.PropertyTypeD</DataLocation>
<DefaultData>PropertyTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.RME.PropertyTypeD</IdLocation>
<IndexLocation>^DHCHAI.RME.PropertyTypeI</IndexLocation>
<StreamLocation>^DHCHAI.RME.PropertyTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
