/// 名称: DHCHAI.BT.UserGroup
/// 描述: 角色分类维护
/// 编写者：chenjb
/// 编写日期: 2021-11-09
Class DHCHAI.BT.UserGroup Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 角色编码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 角色描述
Property BTDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 角色主页名称
Property BTMainDesc As %String(MAXLEN = 250, TRUNCATE = 1);

/// 角色主页url
Property BTMainUrl As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexBTCode On BTCode As Exact;

Index IndexBTDesc On BTDesc As Exact;

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  根据ID取维护信息
/// Table：       
/// Input：       aId : 
/// Return：      返回obj
/// w ##class(DHCHAI.BT.UserGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.UserGroup
{
	New (aId)
	Quit:'##class(DHCHAI.BT.UserGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.UserGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.UserGroup
{
	New (aCode)
	Set ID=$o(^DHCHAI.BT.UserGroupI("IndexBTCode",aCode,0))
	Quit:ID="" ""
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2021-08-03
/// Description:  根据描述取信息
/// Table：       DHCHAI.BT.UserGroup
/// Input：       aTypeCode : DHCHAI.BT.UserGroup.Code
/// Return：      返回
/// w ##class(DHCHAI.BT.UserGroup).GetValsByDesc("住院医生")
ClassMethod GetValsByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Set return =""
	Quit:(aDesc="") return
	Set ID=$o(^DHCHAI.BT.UserGroupI("IndexBTDesc",aDesc,0))
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Set return=obj.BTCode
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2021-08-03
/// Description:  根据描述取信息
/// Table：       DHCHAI.BT.UserGroup
/// Input：       aTypeCode : DHCHAI.BT.UserGroup.Code
/// Return：      返回
/// w ##class(DHCHAI.BT.UserGroup).GetValsByCode("ys")
ClassMethod GetValsByCode(aCode As %String) As %String
{
	New (aCode)
	Set return =""
	Quit:(aCode="") return
	Set objR=..GetObjByCode(aCode)
	Quit:'$IsObject(objR) return
	Set return=objR.%Id()_"^"_objR.BTCode_"^"_objR.BTDesc_"^"_objR.BTMainDesc_"^"_objR.BTMainUrl
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  更新维护信息
/// Table：       DHCHAI.BT.UserGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.UserGroup).Update("^ys^医生^首页^dhcma.hai.main.welcome.csp","^")
/// w ##class(DHCHAI.BT.UserGroup).Update("^hs^护士^首页^dhcma.hai.main.welcome.csp","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set BTCode	   = $p(aInputStr,aSeparete,2)
	Set BTDesc   = $p(aInputStr,aSeparete,3)
	Set BTMainDesc    = $p(aInputStr,aSeparete,4)
	Set BTMainDesc = "首页"  //固定
	Set BTMainUrl = $p(aInputStr,aSeparete,5)
	
	Quit:(BTCode="")||(BTDesc="")||(BTMainDesc="")||(BTMainUrl="") return
	
	Set tID=$o(^DHCHAI.BT.UserGroupI("IndexBTCode",BTCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set tID=$o(^DHCHAI.BT.UserGroupI("IndexBTDesc",BTDesc,0))
	Quit:(tID'="")&(ID'=tID) -3
	
	Set BTMainDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(BTMainDesc) //去掉特殊字符

	If ID="" {
		Set obj=##class(DHCHAI.BT.UserGroup).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.UserGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = BTCode
	Set obj.BTDesc    = BTDesc
	Set obj.BTMainDesc     = BTMainDesc
	Set obj.BTMainUrl  = BTMainUrl
	
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

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  删除维护信息
/// Table：       DHCHAI.BT.UserGroup
/// Input：       aId : DHCHAI.BT.UserGroup.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.UserGroup).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.UserGroup")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.UserGroup).%DeleteId(aId)
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
<Data name="UserGroupDefaultData">
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
<Value>BTMainDesc</Value>
</Value>
<Value name="5">
<Value>BTMainUrl</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.UserGroupD</DataLocation>
<DefaultData>UserGroupDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.UserGroupD</IdLocation>
<IndexLocation>^DHCHAI.BT.UserGroupI</IndexLocation>
<StreamLocation>^DHCHAI.BT.UserGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
