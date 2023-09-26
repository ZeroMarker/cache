/// 名称: DHCHAI.BT.PACBed
/// 描述: 床位列表
/// 编写者：zhufei
/// 编写日期: 2017-09-12
Class DHCHAI.BT.PACBed Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病区（不包括虚拟病区）
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 床位
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

/// 排序码（大排行,也是房间内的排列顺序）
Property BTIndNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 自定义病区（包括虚拟病区）
Property BTXLocDr As DHCHAI.BT.Location;

/// 房间
Property BTRoomDr As DHCHAI.BT.PACRoom;

/// 记录索引码（HIS中床位ID）
Property BTXCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 记录索引码索引
Index IndexXCode On (BTLocDr, BTXCode As Exact);

Index IndexLocDrDesc On (BTLocDr, BTDesc As Exact);

Index IndexRoomDr On BTRoomDr;

Index IndexLocDrIndNo On (BTLocDr, BTIndNo As Exact);

Index IndexLocIndNoBeds On (BTXLocDr, BTIndNo As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  根据ID取床位信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       aId : DHCHAI.BT.PACBed.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PACBed).GetObjById(5655)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.PACBed
{
	New (aId)
	Quit:'##class(DHCHAI.BT.PACBed).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.PACBed).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-15
/// Description:  根据XCode取床位信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       aLocDr : DHCHAI.BT.PACBed.LocDr
///               aXCode    : DHCHAI.BT.PACBed.XCode
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PACBed).GetObjByXCode(1,1)
ClassMethod GetObjByXCode(aLocDr As %String, aXCode As %String) As DHCHAI.BT.PACBed
{
	New (aLocDr,aXCode)
	Set return = ""
	Quit:(aLocDr="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.BT.PACBedI("IndexXCode",aLocDr,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新科室信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACBed).Update("^22^0101床^^^5||1^1^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set LocDr       = $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set IndNo       = $p(aInputStr,aSeparete,4)
	Set XLocDr		= $p(aInputStr,aSeparete,5)
	Set RoomDr      = $p(aInputStr,aSeparete,6)
	Set XCode		= $p(aInputStr,aSeparete,7)
	Set IsActive	= +$p(aInputStr,aSeparete,8)
	Set ActDate		= $p(aInputStr,aSeparete,9)
	Set ActTime		= $p(aInputStr,aSeparete,10)
	Set ActUserDr   = $p(aInputStr,aSeparete,11)
	Quit:(LocDr="")||(Desc="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	Set:XLocDr="" XLocDr=LocDr
	Set objXLoc=##class(DHCHAI.BT.Location).GetObjById(XLocDr)
	Quit:'$IsObject(objXLoc) return
	Set objRoom=##class(DHCHAI.BT.PACRoom).GetObjById(RoomDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set XCode=$zcvt(XCode,"U")
	Set tID=$o(^DHCHAI.BT.PACBedI("IndexXCode",LocDr,XCode,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.PACBed).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.PACBed).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Set obj.BTLocDr     = objLoc      //病区
	Set obj.BTDesc	    = Desc
	Set obj.BTIndNo     = IndNo
	Set obj.BTXLocDr	= objXLoc     //自定义病区
	Set obj.BTRoomDr    = objRoom
	Set obj.BTXCode		= XCode
	Set obj.BTIsActive 	= IsActive
	Set obj.BTActDate 	= ActDate
	Set obj.BTActTime 	= ActTime
	Set obj.BTActUserDr = objActUser
	
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

/// Creator：     mayanpeng
/// CreatDate：   2017-09-15
/// Description:  病区、房间、床位关联
/// Table：       DHCHAI.BT.PACBed
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACBed).UpdateRoom("1^5^1")
ClassMethod UpdateRoom(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)	
	Set return = ""
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Id		 = $p(aInputStr,aSeparete,1)
	Set XLocDr	 = $p(aInputStr,aSeparete,2)
	Set RoomDr	 = $p(aInputStr,aSeparete,3)
	Quit:((Id="")||(XLocDr="")||(RoomDr="")) return
	
	Quit:'##class(DHCHAI.BT.PACBed).%ExistsId(Id) return
	Set obj=##Class(DHCHAI.BT.PACBed).%OpenId(Id)
	Set obj.BTXLocDr = ##class(DHCHAI.BT.Location).GetObjById(XLocDr)
	Set obj.BTRoomDr = ##class(DHCHAI.BT.PACRoom).GetObjById(RoomDr)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-15
/// Description:  删除床位指向的房间
/// Table：       DHCHAI.BT.PACBed
/// Input：       aId : DHCHAI.BT.PACBed.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACBed).DeleteRoom(1)
ClassMethod DeleteRoom(aId As %String) As %String
{
	New (aId)
	Set return = -1
	Quit:'##class(DHCHAI.BT.PACBed).%ExistsId(aId) return
	Set obj=##Class(DHCHAI.BT.PACBed).%OpenId(aId)
	Set obj.BTXLocDr = ""
	Set obj.BTRoomDr = ""
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  删除床位信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       aId : DHCHAI.BT.PACBed.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACBed).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.PACBed).%DeleteId(aId)
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
<Data name="PACBedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTLocDr</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIndNo</Value>
</Value>
<Value name="5">
<Value>BTRoomDr</Value>
</Value>
<Value name="6">
<Value>BTXCode</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserDr</Value>
</Value>
<Value name="11">
<Value>BTXLocDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.PACBedD</DataLocation>
<DefaultData>PACBedDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.PACBedD</IdLocation>
<IndexLocation>^DHCHAI.BT.PACBedI</IndexLocation>
<StreamLocation>^DHCHAI.BT.PACBedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
