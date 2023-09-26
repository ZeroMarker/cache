/// 医嘱明细表
Class User.DHCMRClinicalPathWayOrder Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MR_ClinicalPathWayOrder ]
{

/// 出入径ID
Property CPWOPathWayID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱ID 指向OE_OrdItem
Property CPWOOEItemID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱项ID 指向ARC_ItmMast
Property CPWOArcimID As %String(MAXLEN = 30, TRUNCATE = 1);

/// 通用名 指向PHC_Generic.Desc
Property CPWOGeneric As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱状态 指向OEC_OrderStatus.Desc
Property CPWOOrdStatus As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱类型 指向OEC_Priority.Desc
Property CPWOPriority As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱类型 指向PHC_Freq.Desc
Property CPWOPHCFreq As %String(MAXLEN = 30, TRUNCATE = 1);

/// 医嘱开始日期
Property CPWOSttDate As %Date;

/// 医嘱开始时间
Property CPWOSttTime As %Time;

/// 医嘱停止日期
Property CPWOXDate As %Date;

/// 医嘱停止时间
Property CPWOXTime As %Time;

/// 医嘱天数
Property CPWOOrdDays As %String;

/// 是否有效
Property CPWOIsActive As %Boolean;

/// 更新日期
Property CPWOUpdateDate As %Date;

/// 更新时间
Property CPWOUpdateTime As %Time;

Index IndexOEItem On (CPWOPathWayID, CPWOOEItemID) [ Unique ];

Index IndexUpdateDate On (CPWOPathWayID, CPWOUpdateDate, CPWOUpdateTime);

Index IndexGeneric On (CPWOPathWayID As Exact, CPWOGeneric As Exact, CPWOIsActive As Exact, CPWOOrdDays As Exact, CPWOSttDate As Exact);

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  根据ID取路径医嘱
/// Table：       User.DHCMRClinicalPathWayOrder
/// Input：       Id : User.DHCMRClinicalPathWayOrder.ID
/// Return：      返回Object
/// w ##class(User.DHCMRClinicalPathWayOrder).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRClinicalPathWayOrder
{
	new (aId)
	quit:'##class(User.DHCMRClinicalPathWayOrder).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRClinicalPathWayOrder).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  更新路径医嘱
/// Table：       User.DHCMRClinicalPathWayOrder
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCMRClinicalPathWayOrder).Update("")
ClassMethod Update(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set PathWayID=$p(aInputStr,"^",1)
	Set OEItemID=$p(aInputStr,"^",2)
	Set ArcimID=$p(aInputStr,"^",3)
	Set Generic=$p(aInputStr,"^",4)
	Set OrdStatus=$p(aInputStr,"^",5)
	Set Priority=$p(aInputStr,"^",6)
	Set PHCFreq=$p(aInputStr,"^",7)
	Set SttDate=$p(aInputStr,"^",8)
	Set SttTime=$p(aInputStr,"^",9)
	Set XDate=$p(aInputStr,"^",10)
	Set XTime=$p(aInputStr,"^",11)
	Set OrdDays=+$p(aInputStr,"^",12)
	Set IsActive=+$p(aInputStr,"^",13)
	Set UpdateDate=$p(aInputStr,"^",14)
	Set UpdateTime=$p(aInputStr,"^",15)
	Quit:(PathWayID="")||(OEItemID="")||(ArcimID="")||(Generic="") return
	
	Set ID=$o(^DHCMRi("Order","IndexOEItem"," "_PathWayID," "_OEItemID,0))
	
	If ID="" {
		Set obj=##class(User.DHCMRClinicalPathWayOrder).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayOrder).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CPWOPathWayID   = PathWayID
	Set obj.CPWOOEItemID    = OEItemID
	Set obj.CPWOArcimID     = ArcimID
	Set obj.CPWOGeneric     = Generic
	Set obj.CPWOOrdStatus   = OrdStatus
	Set obj.CPWOPriority    = Priority
	Set obj.CPWOPHCFreq     = PHCFreq
	Set obj.CPWOSttDate     = SttDate
	Set obj.CPWOSttTime     = SttTime
	Set obj.CPWOXDate       = XDate
	Set obj.CPWOXTime       = XTime
	Set obj.CPWOOrdDays     = OrdDays
	Set obj.CPWOIsActive    = IsActive
	Set obj.CPWOUpdateDate  = UpdateDate
	Set obj.CPWOUpdateTime  = UpdateTime
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  删除路径医嘱
/// Table：       User.DHCMRClinicalPathWayOrder
/// Input：       Id : User.DHCMRClinicalPathWayOrder.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRClinicalPathWayOrder).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(User.DHCMRClinicalPathWayOrder).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWOPathWayID</Value>
</Value>
<Value name="3">
<Value>CPWOOEItemID</Value>
</Value>
<Value name="4">
<Value>CPWOArcimID</Value>
</Value>
<Value name="5">
<Value>CPWOGeneric</Value>
</Value>
<Value name="6">
<Value>CPWOOrdStatus</Value>
</Value>
<Value name="7">
<Value>CPWOPriority</Value>
</Value>
<Value name="8">
<Value>CPWOPHCFreq</Value>
</Value>
<Value name="9">
<Value>CPWOSttDate</Value>
</Value>
<Value name="10">
<Value>CPWOSttTime</Value>
</Value>
<Value name="11">
<Value>CPWOXDate</Value>
</Value>
<Value name="12">
<Value>CPWOXTime</Value>
</Value>
<Value name="13">
<Value>CPWOOrdDays</Value>
</Value>
<Value name="14">
<Value>CPWOIsActive</Value>
</Value>
<Value name="15">
<Value>CPWOUpdateDate</Value>
</Value>
<Value name="16">
<Value>CPWOUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMR("Order")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("Order")</IdLocation>
<IndexLocation>^DHCMRi("Order")</IndexLocation>
<StreamLocation>^User.DHCMRClinicalPathWayOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
