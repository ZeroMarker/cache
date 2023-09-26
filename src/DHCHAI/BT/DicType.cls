/// 名称: DHCHAI.BT.DicType
/// 描述: 字典分类表
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.BT.DicType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

Index IdxofCode On BTCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取字典分类信息
/// Table：       DHCHAI.BT.DicType
/// Input：       aId : DHCHAI.BT.DicType.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.DicType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.DicType
{
	New (aId)
	Quit:'##class(DHCHAI.BT.DicType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.DicType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-04-10
/// Description:  根据Code取字典分类信息
/// Table：       DHCHAI.BT.DicType
/// Input：       aCode : DHCHAI.BT.DicType.Code
/// Return：      返回obj
/// w ##class(DHCHAI.BT.DicType).GetObjByCode("UserType")
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.DicType
{
	New (aCode)
	Set ID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新字典分类信息
/// Table：       DHCHAI.BT.DicType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.DicType).Update("^P01^PDesc^1^1","")
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
	
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.DicType).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.DicType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	
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
/// CreatDate：   2017-03-15
/// Description:  删除字典分类信息
/// Table：       DHCHAI.BT.DicType
/// Input：       aId : DHCHAI.BT.DicType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.DicType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.DicType")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.DicType).%DeleteId(aId)
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
<Data name="DicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.DicTypeD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.DicTypeD</IdLocation>
<IndexLocation>^DHCHAI.BT.DicTypeI</IndexLocation>
<StreamLocation>^DHCHAI.BT.DicTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
