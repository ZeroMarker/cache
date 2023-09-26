/// 名称: DHCHAI.BT.LocRelevant
/// 描述: 相关科室相互关联
/// 编写者: mayanpeng
/// 编写日期: 2018-07-10
Class DHCHAI.BT.LocRelevant Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 名称(多科室关联新命名,可空)
Property BTName As %String;

/// 相关性类别("LocRelevant")
Property BTTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 科室列表(DHCHAI.BT.Location)
Property BTLocList As %String [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 类型索引
Index IndexTypeDr On BTTypeDr;

/// 类型和科室列表索引
Index IndexTypeLocList On (BTTypeDr, BTLocList As Exact);

/// Creator：     mayanpeng
/// CreatDate：   2018-07-10
/// Description:  根据ID取关联科室对象
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aId : DHCHAI.BT.LocRelevant.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocRelevant).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.LocRelevant
{
	New (aId)
	Quit:'##class(DHCHAI.BT.LocRelevant).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.LocRelevant).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-10
/// Description:  根据ID取关联科室列表
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aId : DHCHAI.BT.LocRelevant.ID
/// Return：      返回List
/// w ##class(DHCHAI.BT.LocRelevant).GetLocListById(1)
ClassMethod GetLocListById(aId As %String) As %String
{
	New (aId)
	Set return=""
	
	Set obj=..GetObjById(+aId)
	Quit:'$IsObject(obj) return
	Set LocList=##class(DHCHAI.Utils.CommonSrv).ListFromString(obj.BTLocList,"|")
	Quit LocList
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-10
/// Description:  更新科室信息
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocRelevant).Update("^^399^11^1^^^3884")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Name		= $p(aInputStr,aSeparete,2)
	Set Type		= $p(aInputStr,aSeparete,3)
	Set LocList     = $p(aInputStr,aSeparete,4)
	Set IsActive	= +$p(aInputStr,aSeparete,5)
	Set ActDate		= $p(aInputStr,aSeparete,6)
	Set ActTime		= $p(aInputStr,aSeparete,7)
	Set ActUserDr   = $p(aInputStr,aSeparete,8)
	Quit:(LocList="") return
	
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(Type)
	Quit:'$IsObject(objDic) return
	
	//科室去重
	Set LocList=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(LocList,"|")
	Set LocList=##class(DHCHAI.Utils.CommonSrv).ListFromString(LocList,"|")
	Set tempLocList=""
	For ind=1:1:$ListLength(LocList){
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById($List(LocList,ind))
		Continue:'$IsObject(objLoc)
		Set:tempLocList'="" tempLocList=tempLocList_"|"_$List(LocList,ind)
		Set:tempLocList="" tempLocList=$List(LocList,ind)
	}
	Quit:tempLocList="" return
	
	Set:IsActive="" IsActive="1"
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.LocRelevant).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.LocRelevant).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Set obj.BTName		= Name
	Set obj.BTTypeDr	= objDic
	Set obj.BTLocList   = tempLocList //科室列表
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
/// CreatDate：   2018-07-10
/// Description:  根据ID取删除数据
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aId : DHCHAI.BT.LocRelevant.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocRelevant).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.LocRelevant).%DeleteId(aId)
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
<Data name="LocRelevantDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTypeDr</Value>
</Value>
<Value name="3">
<Value>BTLocList</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUserDr</Value>
</Value>
<Value name="8">
<Value>BTName</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.LocRelevantD</DataLocation>
<DefaultData>LocRelevantDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.LocRelevantD</IdLocation>
<IndexLocation>^DHCHAI.BT.LocRelevantI</IndexLocation>
<StreamLocation>^DHCHAI.BT.LocRelevantS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
