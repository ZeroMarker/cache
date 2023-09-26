/// 名称: DHCHAI.DP.Outofbed
/// 描述: 离床超过一日患者
/// 编写者：pylian
/// 编写日期: 2020-03-11
Class DHCHAI.DP.Outofbed Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 操作日志
Relationship ChildLog As DHCHAI.DP.OutofbedLog [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property EpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 就诊状态（预住院P、在院A、出院D、退院C、作废U）
Property VisitStatus As %String(DISPLAYLIST = ",A,D,C,U,P", VALUELIST = ",A,D,C,U,P") [ Required ];

/// 离床日期
Property OutbedDate As %Date;

/// 离床时间
Property OutbedTime As %Time;

/// 标记状态（0未标记、1标记、2取消标记）
Property OprStatus As %Integer;

/// 标记出院日期
Property DischDate As %Date;

/// 标记出院时间
Property DischTime As %Time;

/// 有效标志
Property IsActive As %Boolean [ Required ];

/// 更新日期
Property UpdateDate As %Date [ Required ];

/// 更新时间
Property UpdateTime As %Time [ Required ];

/// 就诊状态+就诊索引
Index IndexEpisodeDr On EpisodeDr As Exact;

/// 就诊状态+就诊索引
Index IndexEpsStatus On (VisitStatus As Exact, EpisodeDr As Exact);

/// 就诊状态+就诊索引
Index IndexOprStatus On OprStatus As Exact;

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  根据ID取离床超过一日患者
/// Table：       DHCHAI.DP.Outofbed
/// Input：       aId : DHCHAI.DP.Outofbed.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.Outofbed).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.Outofbed
{
	New (aId)
	Quit:'##class(DHCHAI.DP.Outofbed).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.Outofbed).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  更新离床超过一日患者
/// Table：       DHCHAI.DP.Outofbed
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.Outofbed).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set EpisodeDr   = $p(aInputStr,aSeparete,2)
	Set VisitStatus = $p(aInputStr,aSeparete,3)
	Set OutbedDate  = $p(aInputStr,aSeparete,4)
	Set OutbedTime  = $p(aInputStr,aSeparete,5)
	Set OprStatus   = $p(aInputStr,aSeparete,6)
	Set DischDate   = $p(aInputStr,aSeparete,7)
	Set DischTime   = $p(aInputStr,aSeparete,8)
	Set IsActive    = +$p(aInputStr,aSeparete,9)
	Set UpdateDate  = $p(aInputStr,aSeparete,10)
	Set UpdateTime  = $p(aInputStr,aSeparete,11)	
	Quit:(EpisodeDr="")||(VisitStatus="") return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objAdm) return
	
	Set:OutbedDate'="" OutbedDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(OutbedDate)
	Set:OutbedTime[":" OutbedTime = $zth(OutbedTime,1)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DischDate)
	Set:DischTime[":" DischTime = $zth(DischTime,1)
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h   //当前日期
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	
	Set tID=$o(^DHCHAI.DP.OutofbedI("IndexEpisodeDr",EpisodeDr,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.Outofbed).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.Outofbed).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeDr   = objAdm  
	Set obj.VisitStatus = VisitStatus
	Set obj.OutbedDate  = OutbedDate 
	Set obj.OutbedTime  = OutbedTime 
	Set obj.OprStatus   = OprStatus  
	Set obj.DischDate   = DischDate  
	Set obj.DischTime   = DischTime  
	Set obj.IsActive    = IsActive   
	Set obj.UpdateDate  = UpdateDate 
	Set obj.UpdateTime  = UpdateTime 
	
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

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  删除离床超过一日患者
/// Table：       DHCHAI.DP.Outofbed
/// Input：       aId : DHCHAI.DP.Outofbed.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.Outofbed).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.Outofbed).%DeleteId(aId)
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
<Data name="OutofbedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeDr</Value>
</Value>
<Value name="3">
<Value>VisitStatus</Value>
</Value>
<Value name="4">
<Value>OutbedDate</Value>
</Value>
<Value name="5">
<Value>OutbedTime</Value>
</Value>
<Value name="6">
<Value>OprStatus</Value>
</Value>
<Value name="7">
<Value>DischDate</Value>
</Value>
<Value name="8">
<Value>DischTime</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OutofbedD</DataLocation>
<DefaultData>OutofbedDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OutofbedD</IdLocation>
<IndexLocation>^DHCHAI.DP.OutofbedI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OutofbedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
