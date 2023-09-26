/// 名称: DHCHAI.IR.ICUIExA
/// 描述: ICU插拔管评估表
/// 编写者：ShenC
/// 编写日期: 2020-08-29
Class DHCHAI.IR.ICUIExA Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.ICUIExAExt [ Cardinality = children, Inverse = Parref ];

/// 就诊记录
Property IExAEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 插管类型
Property IExAIntuTypeDr As DHCHAI.BT.Dictionary [ Required ];

/// 插管日期
Property IExAIntuDate As %Date [ Required ];

/// 拔管日期
Property IExAExtuDate As %Date;

/// 留置原因
Property IExARetReason As %String;

/// 是否有效
Property IExAIsActive As %Boolean;

/// 就诊记录 索引
Index IndexEpisodeDr On IExAEpisodeDr;

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  根据RowId取ICU插拔管评估信息
/// Table：       DHCHAI.IR.ICUIExA
/// Input：       RowID    DHCHAI.IR.ICUIExA
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ICUIExA).GetObjById(2)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ICUIExA
{
	New (aId)
	Set Return=""
	Quit:'##class(DHCHAI.IR.ICUIExA).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.ICUIExA).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  更新ICU插拔管评估
/// Table：       DHCHAI.IR.ICUExA
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICUIExA).Update("^2598^672^2020-10-10^^^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set ID			= $p(aInputStr,aSeparete,1)
	Set EpisodeID   = $p(aInputStr,aSeparete,2)
	Set EpisodeDr	= ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(EpisodeDr) return
	Set IntuTypeID	= $p(aInputStr,aSeparete,3)
	Set IntuTypeDr  = ##class(DHCHAI.BT.Dictionary).GetObjById(IntuTypeID)
	Quit:'$IsObject(IntuTypeDr) return
	Set IntuDate	= $p(aInputStr,aSeparete,4)
	Set ExtuDate	= $p(aInputStr,aSeparete,5)
	Set RetReason	= $p(aInputStr,aSeparete,6)
	Set IsActive	= $p(aInputStr,aSeparete,7)
	//转化日期
	Set IntuDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IntuDate)
	Set ExtuDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ExtuDate)
	If ID="" {
		Set obj=##class(DHCHAI.IR.ICUIExA).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.ICUIExA).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IExAEpisodeDr  	= EpisodeDr   
	Set obj.IExAIntuTypeDr	= IntuTypeDr
	Set obj.IExAIntuDate	= IntuDate	    
	Set obj.IExAExtuDate	= ExtuDate	
	Set obj.IExAIsActive	= IsActive	
	Set obj.IExARetReason	= RetReason
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  删除ICU插拔管评估
/// Table：       DHCHAI.IR.OccExpReg
/// Input：       aId : DHCHAI.IR.OccExpReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICUIExAExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ICUIExA).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     chenjianbo
/// CreatDate：   2022-10-31
/// Description:  更新ICU插拔管评估
/// Table：       DHCHAI.IR.ICUExA
/// Input：       各属性列表 
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICUIExA).UpdateIsActive("1","0")
ClassMethod UpdateIsActive(aIExAID As %String, aIsActive As %String = "1") As %String
{
	New (aIExAID,aIsActive)
	Set return=0
	Quit:aIExAID="" return
	
	Set obj=##class(DHCHAI.IR.ICUIExA).%OpenId(aIExAID)
	Quit:'$Isobject(obj) return
	
	Set obj.IExAIsActive	= +aIsActive
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="ICUIExADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IExAEpisodeDr</Value>
</Value>
<Value name="3">
<Value>IExAIntuTypeDr</Value>
</Value>
<Value name="4">
<Value>IExAIntuDate</Value>
</Value>
<Value name="5">
<Value>IExAExtuDate</Value>
</Value>
<Value name="6">
<Value>IExARetReason</Value>
</Value>
<Value name="7">
<Value>IExAIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ICUIExAD</DataLocation>
<DefaultData>ICUIExADefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ICUIExAD</IdLocation>
<IndexLocation>^DHCHAI.IR.ICUIExAI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ICUIExAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
