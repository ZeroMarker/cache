/// 描述: 系统模块角色表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.MdlRole Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.Util.BT.MdlDef [ Cardinality = parent, Inverse = ChildRole ];

/// 角色代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 角色名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IdxofCode On (BTCode, Parref) [ Unique ];

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-28
/// Description:  根据ID取对象
/// Table：       DHCMA.Util.BT.MdlRole	
/// Input：       aId : DHCMA.Util.BT.MdlRole.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.MdlRole).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.MdlRole
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.MdlRole).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.MdlRole).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-28
/// Description:  根据ID删除
/// Table：       DHCMA.Util.BT.MdlRole	
/// Input：       aId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.MdlRole).DeleteById("2||2")
ClassMethod DeleteById(aId)
{
	New (aId)
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.Util.BT.MdlRole")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCMA.Util.BT.MdlRole).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-28
/// Description:  更新
/// Table：       DHCMA.Util.BT.MdlRole	
/// Input：       aInStr 各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码  （=0 参数错误）
/// w ##class(DHCMA.Util.BT.MdlRole).Update("2^^03^0","")
ClassMethod Update(aInStr As %String, aSeparete As %String = "^") As %String
{
	New (aInStr,aSeparete)
	Set return=0
	Quit:aInStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParRef       = $p(aInStr,aSeparete,1)
	Set ChildSub     = $p(aInStr,aSeparete,2)
	Set BTCode    = $p(aInStr,aSeparete,3)
	Set BTDesc       = $p(aInStr,aSeparete,4)
	Quit:(ParRef="")||(BTCode="")||(BTCode="") return
	
	Set objParref=##class(DHCMA.Util.BT.MdlDef).GetObjById(ParRef)
	Quit:'$IsObject(objParref) return
	
	Set tChildSub=$o(^DHCMA.Util.BT.MdlDefI("R","IdxofCode"," "_$zcvt(BTCode,"U"),ParRef,0))
	Quit:(tChildSub'="")&(ChildSub'=tChildSub) -2	    //根据代码找ID,如果id对不上号 返回-2
	
	If ChildSub="" {
		set obj=##class(DHCMA.Util.BT.MdlRole).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCMA.Util.BT.MdlRole).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref  = objParref
	Set obj.BTCode  = BTCode
	Set obj.BTDesc  = BTDesc
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="MdlRoleDefaultData">
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
<DataLocation>{%%PARENT}("R")</DataLocation>
<DefaultData>MdlRoleDefaultData</DefaultData>
<IdLocation>{%%PARENT}("R")</IdLocation>
<IndexLocation>^DHCMA.Util.BT.MdlDefI("R")</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.MdlRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
