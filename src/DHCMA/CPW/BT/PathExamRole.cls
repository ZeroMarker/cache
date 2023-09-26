/// 名称: DHCMA.CPW.BT.PathExamRole
/// 描述: 表单发布审核角色维护
/// 编写者：yankai
/// 编写日期: 2021-11-04
Class DHCMA.CPW.BT.PathExamRole Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 角色代码  
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 角色名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 角色对象值(USER:DHCMA.Util.EPx.SSUser.OID；安全组:DHCMA.Util.EP.SSGroup.OID；科室:DHCMA.Util.EPx.Location.OID)
Property BTValue As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 角色类型（USER用户、LOC科室)[说明：项目如有特殊角色要求，可个性话扩充，如安全组：Group/G]
Property BTType As %String(DISPLAYLIST = "USER,LOC", VALUELIST = ",U,L") [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 优先级（数值越低，级别越高，优先接收消息；数值相等，优先级相同）
Property BTPriority As %Integer [ InitialExpression = 0 ];

/// 院区
Property BTHospID As %String;

Index IdxofCode On BTCode [ Unique ];

Index IdxofPriority On (BTIsActive, BTHospID As Exact, BTPriority);

Index IdxofType On (BTIsActive, BTHospID As Exact, BTType As Exact);

/// Creator：     yankai
/// CreatDate：   2021-11-04
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.PathExamRole
/// Input：       aId :  DHCMA.CPW.BT.PathExamRole.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathExamRole).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathExamRole
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathExamRole).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathExamRole).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2021-11-04
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.PathExamRole
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathExamRole).Update("^003^测试3^1^U^1^1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=0
	Quit:aInputStr="" return

	Set ID       = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set Value    = $p(aInputStr,aSeparete,4)
	Set Type     = $p(aInputStr,aSeparete,5)
	Set IsActive = +$p(aInputStr,aSeparete,6)
	Set:IsActive="" IsActive=1
	Set Priority = $p(aInputStr,aSeparete,7)
	Set HospID	 = $p(aInputStr,aSeparete,8)
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.PathExamRole).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathExamRole).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code      //写入数据
	Set obj.BTDesc		= Desc
	Set obj.BTValue		= Value
	Set obj.BTType		= $zcvt(Type,"U")
	Set obj.BTIsActive	= IsActive
	Set obj.BTPriority	= Priority
	Set obj.BTHospID	= HospID
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

/// Creator：     yankai
/// CreatDate：   2021-11-04
/// Description:  删除审核角色
/// Table：       DHCMA.CPW.BT.PathExamRole
/// Input：       aId :  DHCMA.CPW.BT.PathExamRole.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathExamRole).DeleteById(3)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set sc = ##class(DHCMA.CPW.BT.PathExamRole).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-11-24
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.CPW.BT.PathExamRole
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.CPW.BT.PathExamRole).CheckPTCode("010")
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.CPW.BT.PathExamRoleI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.CPW.BT.PathExamRoleI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

Storage Default
{
<Data name="PathExamRoleDefaultData">
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
<Value>BTValue</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTPriority</Value>
</Value>
<Value name="8">
<Value>BTHospID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathExamRoleD</DataLocation>
<DefaultData>PathExamRoleDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathExamRoleD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathExamRoleI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathExamRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
