/// 名称: DHCMA.Util.BT.DeleteControl
/// 描述: 基础字典删除权限控制表
/// 编写者：pylian
/// 编写日期: 2020-08-12
Class DHCMA.Util.BT.DeleteControl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 产品代码
Property ProCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 基础字典表代码
Property TableCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 基础字典表名称
Property TableDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 允许删除标志
Property TableAllowDel As %Boolean;

/// 代码索引
Index IndexCode On TableCode As Exact;

/// 名称索引
Index IndexDesc On TableDesc As Exact;

/// Creator：     pylian
/// CreatDate：   2020-08-12
/// Description:  根据ID取基础字典删除权限控制表
/// Table：       DHCMA.Util.BT.DeleteControl
/// Input：       ID:    DHCMA.Util.BT.DeleteControl.ID
/// Return：      返回Object
/// w ##class(DHCMA.Util.BT.DeleteControl).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMA.Util.BT.DeleteControl
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCMA.Util.BT.DeleteControl).%ExistsId(+id) return
	
	Set obj=##Class(DHCMA.Util.BT.DeleteControl).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-12
/// Description:  根据代码取基础字典删除权限控制
/// Table：       DHCMA.Util.BT.DeleteControl
/// Input：       aCode:   细菌代码
/// Return：      返回Object
/// w ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("")
ClassMethod GetAllowDel(aCode As %String) As %String
{
	New (aCode)
	Set return=0
	Quit:(aCode="") return
	
	Set id=""
	Set id = $o(^CT.MA.Util.BT.DeleteControlI("IndexCode",aCode,0))
	Quit:id="" return
	Set obj=..GetObjById(id)
	Quit:obj.TableAllowDel'=1 return //允许删除
	Quit 1
}

/// Creator：     pylian
/// CreatDate：   2020-08-12
/// Description:  更新基础字典删除权限控制表
/// Table：       DHCMA.Util.BT.DeleteControl
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.DeleteControl).Update("1^shs^四环素")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID		 	= $p(aInputStr,aSeparete,1)
	Set ProCode		= $p(aInputStr,aSeparete,2)
	Set Code		= $p(aInputStr,aSeparete,3)
	Set Desc		= $p(aInputStr,aSeparete,4)
	Set AllowDel    = $p(aInputStr,aSeparete,5)
	Quit:(ProCode="")||(Code="")||(Desc="") return

	//代码唯一性
	Set tID =$o(^CT.MA.Util.BT.DeleteControlI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -2
		
	if ID="" {
		Set obj=##class(DHCMA.Util.BT.DeleteControl).%New()
	}else{
		Set obj=##class(DHCMA.Util.BT.DeleteControl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ProCode		    = ProCode
	Set obj.TableCode		= Code
	Set obj.TableDesc		= Desc
	Set obj.TableAllowDel	= AllowDel
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-12
/// Description:  删除基础字典删除权限控制表
/// Table：       DHCMA.Util.BT.DeleteControl
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId)
{
	New (aId)
	Set sc = ##class(DHCMA.Util.BT.DeleteControl).%DeleteId(+aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProCode</Value>
</Value>
<Value name="3">
<Value>TableCode</Value>
</Value>
<Value name="4">
<Value>TableDesc</Value>
</Value>
<Value name="5">
<Value>TableAllowDel</Value>
</Value>
</Data>
<DataLocation>^CT.MA.Util.BT.DeleteControlD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.MA.Util.BT.DeleteControlD</IdLocation>
<IndexLocation>^CT.MA.Util.BT.DeleteControlI</IndexLocation>
<StreamLocation>^CT.MA.Util.BT.DeleteControlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
