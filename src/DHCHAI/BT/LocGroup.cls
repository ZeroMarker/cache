/// 名称: DHCHAI.BT.LocGroup
/// 描述: 科室分组表（医学专业学科分类代码）
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.BT.LocGroup Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

/// 排序码
Property BTIndNo As %String(TRUNCATE = 1);

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// 顺序号+名称 索引
Index IndexIndNoGrpDesc On (BTIndNo, BTDesc);

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取科室分组信息
/// Table：       DHCHAI.BT.LocGroup
/// Input：       aId : DHCHAI.BT.LocGroup.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.LocGroup
{
	New (aId)
	Quit:'##class(DHCHAI.BT.LocGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.LocGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-07-17
/// Description:  根据科室分组名称取科室对象
/// Table：       DHCHAI.BT.LocGroup
/// Input：       aDesc : DHCHAI.BT.LocGroup.BTDesc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocGroup).GetObjByDesc("其他科")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.BT.LocGroup
{
	New (aDesc)
	Set return=""
	Quit:(aDesc="") return
	
	Set xID=$o(^DHCHAI.BT.LocGroupI("IdxofDesc",aDesc,0))
	Set obj=..GetObjById(xID)	
	Set return=obj
		
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新科室分组信息
/// Table：       DHCHAI.BT.LocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocGroup).Update("^P01^PDesc^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set IndNo    = $p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.LocGroupI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.LocGroup).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.LocGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTIndNo    = IndNo
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
/// Description:  删除科室分组信息
/// Table：       DHCHAI.BT.LocGroup
/// Input：       aId : DHCHAI.BT.LocGroup.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocGroup).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.LocGroup")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.BT.LocGroup).%DeleteId(aId)
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
<Value name="4">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.LocGroupD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.LocGroupD</IdLocation>
<IndexLocation>^DHCHAI.BT.LocGroupI</IndexLocation>
<StreamLocation>^DHCHAI.BT.LocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
