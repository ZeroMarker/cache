/// 名称: DHCHAI.BT.PACWard
/// 描述: 病区分布定义
/// 编写者：zhufei
/// 编写日期: 2017-09-12
Class DHCHAI.BT.PACWard Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病区
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 病房大楼（WardBuilding）
Property BTBuildingDr As DHCHAI.BT.Dictionary;

/// 楼层（如：11F）
Property BTFloor As %Integer;

/// 区域（如：A区、B区）
Property BTArea As %String(MAXLEN = 100, TRUNCATE = 1);

/// 分区号
Property BTSubNo As %Integer;

/// 上边距（px）
Property BTPosTop As %Integer;

/// 左边距（px）
Property BTPosLeft As %Integer;

/// 宽度（px）
Property BTWidth As %Integer;

/// 高度（px）
Property BTHeight As %Integer;

/// 背景色
Property BTAreaColor As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxofLocDr On BTLocDr;

Index IdxofLocDrSubNo On (BTLocDr, BTSubNo);

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  根据ID取病区分布信息
/// Table：       DHCHAI.BT.PACWard
/// Input：       aId : DHCHAI.BT.PACWard.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PACWard).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.PACWard
{
	New (aId)
	Quit:'##class(DHCHAI.BT.PACWard).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.PACWard).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-14
/// Description:  根据病区取病区分布对象
/// Table：       DHCHAI.BT.PACWard
/// Input：       aLocDr : DHCHAI.BT.PACWard.BTLocDr
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PACWard).GetObjByLocDr(1)
ClassMethod GetObjByLocDr(aLocDr As %String, aSubNo As %String) As DHCHAI.BT.PACWard
{
	
	New (aLocDr,aSubNo)
	Set return = ""
	Quit:(aLocDr="")||(aSubNo="") return
	
	Set id=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",aLocDr,aSubNo,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  更新病区分布信息
/// Table：       DHCHAI.BT.PACWard
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACWard).Update("^P01^PDesc^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID        = $p(aInputStr,aSeparete,1)
	Set LocDr     = $p(aInputStr,aSeparete,2)
	Set BuildingDr= $p(aInputStr,aSeparete,3)
	Set Floor     = $p(aInputStr,aSeparete,4)
	Set Area      = $p(aInputStr,aSeparete,5)
	Set SubNo     = $p(aInputStr,aSeparete,6)
	Set AreaColor = $p(aInputStr,aSeparete,7)
	Set:SubNo="" SubNo=1   // 分区号默认等于1
	Quit:(LocDr="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Set objBuilding=##class(DHCHAI.BT.Dictionary).GetObjById(BuildingDr)
	
	Set tID=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocDr,SubNo,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.PACWard).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.PACWard).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTLocDr     = objLoc
	Set obj.BTBuildingDr= objBuilding
	Set obj.BTFloor     = Floor
	Set obj.BTArea      = Area
	Set obj.BTSubNo     = SubNo
	Set obj.BTAreaColor = AreaColor
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
/// Description:  删除病区分布信息
/// Table：       DHCHAI.BT.PACWard
/// Input：       aId : DHCHAI.BT.PACWard.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACWard).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.PACWard).%DeleteId(aId)
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
<Data name="PACWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTLocDr</Value>
</Value>
<Value name="3">
<Value>BTBuildingDr</Value>
</Value>
<Value name="4">
<Value>BTFloor</Value>
</Value>
<Value name="5">
<Value>BTArea</Value>
</Value>
<Value name="6">
<Value>BTSubNo</Value>
</Value>
<Value name="7">
<Value>BTPosTop</Value>
</Value>
<Value name="8">
<Value>BTPosLeft</Value>
</Value>
<Value name="9">
<Value>BTWidth</Value>
</Value>
<Value name="10">
<Value>BTHeight</Value>
</Value>
<Value name="11">
<Value>BTAreaColor</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.PACWardD</DataLocation>
<DefaultData>PACWardDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.PACWardD</IdLocation>
<IndexLocation>^DHCHAI.BT.PACWardI</IndexLocation>
<StreamLocation>^DHCHAI.BT.PACWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
