/// 名称: DHCHAI.BT.PACRoom
/// 描述: 房间分布定义
/// 编写者：zhufei
/// 编写日期: 2017-09-12
Class DHCHAI.BT.PACRoom Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室指针
Property BTLocDr As DHCHAI.BT.Location [ Required ];

/// 房间
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 上边距（px）
Property BTPosTop As %Integer;

/// 左边距（px）
Property BTPosLeft As %Integer;

/// 宽度（px）
Property BTPosWidth As %Integer;

/// 高度（px）
Property BTPosHeight As %Integer;

/// 倾斜度（deg）
Property BTPosRotate As %Integer;

/// 预设床位（6人间、3人间、2人间、单间等）
Property BTBedCnt As %Integer;

/// 左边床位数
Property BTLeftBedCnt As %Integer;

/// 右边床位数
Property BTRightBedCnt As %Integer;

/// 床宽度（px）
Property BTBedWidth As %Integer;

/// 床高度（px）
Property BTBedHeight As %Integer;

/// 床间距（px）
Property BTBedGap As %Integer;

/// 房间号位置(1上，2下，3左，4右)
Property BTDescPos As %String(MAXLEN = 1, TRUNCATE = 1);

/// 房间类型
Property BTTypeDr As DHCHAI.BT.Dictionary;

/// 病区分区
Property BTWardDr As DHCHAI.BT.PACWard;

/// 房间背景色
Property BTRoomColor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 房间图标
Property BTRoomIcon As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexLocWardDrDesc On (BTLocDr, BTWardDr, BTDesc As Exact);

Index IndexWardDrDesc On (BTWardDr, BTDesc As Exact);

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  根据ID取房间分布信息
/// Table：       DHCHAI.BT.PACRoom
/// Input：       aId : DHCHAI.BT.PACRoom.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.PACRoom).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.PACRoom
{
	New (aId)
	Quit:'##class(DHCHAI.BT.PACRoom).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.PACRoom).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-09-12
/// Description:  更新房间分布信息
/// Table：       DHCHAI.BT.PACRoom
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACRoom).Update("^5^测试房间^20^10^300^500^40^6^4^4^20^50","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set LocDr       = $p(aInputStr,aSeparete,2)
	Set Desc        = $p(aInputStr,aSeparete,3)
	Set DescPos		= $p(aInputStr,aSeparete,4)
	Set TypeDr		= $p(aInputStr,aSeparete,5)
	Set PosTop      = +$p(aInputStr,aSeparete,6)
	Set PosLeft     = +$p(aInputStr,aSeparete,7)
	Set PosWidth    = +$p(aInputStr,aSeparete,8)
	Set PosHeight   = +$p(aInputStr,aSeparete,9)
	Set PosRotate   = +$p(aInputStr,aSeparete,10)
	Set LeftBedCnt  = +$p(aInputStr,aSeparete,11)
	Set RightBedCnt = +$p(aInputStr,aSeparete,12)
	Set BedWidth    = +$p(aInputStr,aSeparete,13)
	Set BedHeight   = +$p(aInputStr,aSeparete,14)
	Set WardDr      = $p(aInputStr,aSeparete,15)
	Set RoomColor   = $p(aInputStr,aSeparete,16)
	Set RoomIcon    = $p(aInputStr,aSeparete,17)
	Quit:(LocDr="")||(Desc="") return
	Set BedCnt = LeftBedCnt+RightBedCnt
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(objLoc) return
	
	Set tID=$o(^DHCHAI.BT.PACRoomI("IndexLocWardDrDesc",LocDr,WardDr,Desc,0))
	Quit:(tID'="")&(ID'=tID) -2
	Set objWard=##class(DHCHAI.BT.PACWard).GetObjById(WardDr)
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(TypeDr)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.PACRoom).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.PACRoom).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTLocDr       = objLoc
	Set obj.BTDesc        = Desc
	Set obj.BTDescPos	  = DescPos
	Set obj.BTTypeDr	  = objType
	Set obj.BTPosTop      = PosTop
	Set obj.BTPosLeft     = PosLeft
	Set obj.BTPosWidth    = PosWidth
	Set obj.BTPosHeight   = PosHeight
	Set obj.BTPosRotate   = PosRotate
	Set obj.BTBedCnt      = BedCnt
	Set obj.BTLeftBedCnt  = LeftBedCnt
	Set obj.BTRightBedCnt = RightBedCnt
	Set obj.BTBedWidth    = BedWidth
	Set obj.BTBedHeight   = BedHeight
	Set obj.BTWardDr      = objWard
	Set obj.BTRoomColor   = RoomColor
	Set obj.BTRoomIcon    = RoomIcon
	
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
/// Description:  删除房间分布信息
/// Table：       DHCHAI.BT.PACRoom
/// Input：       aId : DHCHAI.BT.PACRoom.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.PACRoom).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.PACRoom).%DeleteId(aId)
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
<Data name="PACRoomDefaultData">
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
<Value>BTPosTop</Value>
</Value>
<Value name="5">
<Value>BTPosLeft</Value>
</Value>
<Value name="6">
<Value>BTPosWidth</Value>
</Value>
<Value name="7">
<Value>BTPosHeight</Value>
</Value>
<Value name="8">
<Value>BTPosRotate</Value>
</Value>
<Value name="9">
<Value>BTBedCnt</Value>
</Value>
<Value name="10">
<Value>BTLeftBedCnt</Value>
</Value>
<Value name="11">
<Value>BTRightBedCnt</Value>
</Value>
<Value name="12">
<Value>BTBedWidth</Value>
</Value>
<Value name="13">
<Value>BTBedHeight</Value>
</Value>
<Value name="14">
<Value>BTDescPos</Value>
</Value>
<Value name="15">
<Value>BTTypeDr</Value>
</Value>
<Value name="16">
<Value>BTWardDr</Value>
</Value>
<Value name="17">
<Value>BTBedGap</Value>
</Value>
<Value name="18">
<Value>BTRoomColor</Value>
</Value>
<Value name="19">
<Value>BTRoomIcon</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.PACRoomD</DataLocation>
<DefaultData>PACRoomDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.PACRoomD</IdLocation>
<IndexLocation>^DHCHAI.BT.PACRoomI</IndexLocation>
<StreamLocation>^DHCHAI.BT.PACRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
