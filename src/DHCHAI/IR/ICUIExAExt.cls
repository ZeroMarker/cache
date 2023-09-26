/// 名称: DHCHAI.IR.ICUIExAExt
/// 描述: ICU插拔管评估表(明细表)
/// 编写者：ShenC
/// 编写日期: 2020-08-29
Class DHCHAI.IR.ICUIExAExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.ICUIExA [ Cardinality = parent, Inverse = ChildExt ];

/// 项目名称
Property IExAItemDr As DHCHAI.BT.Dictionary [ Required ];

/// 评估第几天
Property IExADay As %Integer [ Required ];

/// 项目值(是/否/空、1/-1/0)
Property IExAItemVal As %Integer;

/// 评估人
Property IExAUser As DHCHAI.BT.SysUser;

/// 评估日期
Property IExAUserDate As %Date [ Required ];

/// 评估时间
Property IExAUserTime As %Time;

/// 评估天数+项目 索引
Index IndexIExADateItem On (Parref, IExADay As Exact, IExAItemDr As Exact);

/// 评估天数+评估人 索引
Index IndexIExADateUser On (Parref, IExADay As Exact, IExAUser As Exact);

/// 评估天数+评估日期 索引
Index IndexIExADateUserDate On (Parref, IExADay As Exact, IExAUserDate As Exact);

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  根据RowId取ICU插拔管评估明细表
/// Table：       DHCHAI.IR.ICUIExA
/// Input：       RowID    DHCHAI.IR.ICUIExA
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ICUIExAExt).GetObjById("1||2")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ICUIExAExt
{
	New (aId)
	Set Return=""
	Quit:'##class(DHCHAI.IR.ICUIExAExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.ICUIExAExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2020-08-14
/// Description:  更新ICU插拔管评估明细表
/// Table：       DHCHAI.IR.ICUIExAExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICUIExAExt).Update("5^^716^2^0^1208^2020-09-10^50970")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref     	= $p(aInputStr,aSeparete,1)
    Set ChildSub	= $p(aInputStr,aSeparete,2)
	Set ItemID   	= $p(aInputStr,aSeparete,3)
	Set ItemDr  	= ##class(DHCHAI.BT.Dictionary).GetObjById(ItemID)
	Quit:'$IsObject(ItemDr) return
	Set IExADay   	= $p(aInputStr,aSeparete,4)
	Set ItemVal   	= $p(aInputStr,aSeparete,5)
	Set UserID   	= $p(aInputStr,aSeparete,6)
	Set:UserID'="" User=##class(DHCHAI.BT.SysUser).GetObjById(UserID)
	Set UserDate 	= $p(aInputStr,aSeparete,7)
    Set:UserDate'="" UserDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UserDate)
    Set UserTime	=$p(aInputStr,aSeparete,8)
    
	Set objParref=##class(DHCHAI.IR.ICUIExA).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.ICUIExAExt).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.ICUIExAExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       	= objParref
	Set obj.IExAItemDr	 	= ItemDr	 
	Set obj.IExADay 		= IExADay
	Set obj.IExAItemVal   	= ItemVal  
	Set obj.IExAUser   		= User  
	Set obj.IExAUserDate   	= UserDate 
    Set obj.IExAUserTime   	= UserTime 
    
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

/// Creator：     ShenC
/// CreatDate：   2020-08-30
/// Description:  删除ICU评估明细表
/// Table：       DHCHAI.IR.ICUIExAExt
/// Input：       aId : DHCHAI.IR.ICUIExAExt
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICUIExAExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ICUIExAExt).%DeleteId(aId)
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
<Data name="ICUIExAExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IExAIntuDay</Value>
</Value>
<Value name="3">
<Value>IExAResDr</Value>
</Value>
<Value name="4">
<Value>IExAResValue</Value>
</Value>
<Value name="5">
<Value>IExAUser</Value>
</Value>
<Value name="6">
<Value>IExADate</Value>
</Value>
<Value name="7">
<Value>IExAItemDr</Value>
</Value>
<Value name="8">
<Value>IExAItemVal</Value>
</Value>
<Value name="9">
<Value>IExAUserDate</Value>
</Value>
<Value name="10">
<Value>IExAUserTime</Value>
</Value>
<Value name="11">
<Value>IExADay</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExt")</DataLocation>
<DefaultData>ICUIExAExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildExt")</IdLocation>
<IndexLocation>^DHCHAI.IR.ICUIExAExtI("ChildExt")</IndexLocation>
<StreamLocation>^DHCHAI.IR.ICUIExAExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
