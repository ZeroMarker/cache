/// 名称: DHCMA.CPW.CP.PathwayOrd
/// 描述: 医嘱的执行记录
/// 编写者：jiangpengpeng
/// 编写日期: 2018-12-13
Class DHCMA.CPW.CP.PathwayOrd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.PathwayImpl [ Cardinality = parent, Inverse = ChildOrd ];

Property CPFormOrdDr As DHCMA.CPW.BT.PathFormOrd;

/// 增加字段医嘱执行指向方剂指针
Property CPFormTCMDr As DHCMA.CPW.BT.PathFormTCM;

/// 实际执行医嘱ID
Property CPOrdID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 有效标志
Property CPIsActive As %Boolean;

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxofParRef On (Parref, CPFormOrdDr As Exact);

Index IdxofFJParRef On (Parref, CPFormTCMDr As Exact);

Index IdxofOrd On CPOrdID As Exact;

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-13
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayOrd
/// Input：       aId : DHCMA.CPW.CP.PathwayOrd.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayOrd).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayOrd
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayOrd).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayOrd).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-12-13
/// Description:  更新数据(同步)
/// Table：       DHCMA.CPW.CP.PathwayOrd
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayOrd).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set FormOrdID=$p(aInputStr,aSeparete,3)
	Set OrdID=$p(aInputStr,aSeparete,4)
	Set ActUserID=$p(aInputStr,aSeparete,5)
	Set FormTCMDr=$p(aInputStr,aSeparete,6)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objFormOrd=##class(DHCMA.CPW.BT.PathFormOrd).GetObjById(FormOrdID)
	Quit:(objFormOrd'="")&&('$IsObject(objFormOrd)) return   //关联方剂的项目 是没有PathFormOrd信息的。
	Set objFormTCM=##class(DHCMA.CPW.BT.PathFormTCM).GetObjById(FormTCMDr)
	Quit:(objFormTCM'="")&&('$IsObject(objFormTCM)) return 
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayOrd).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayOrd).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPFormOrdDr=objFormOrd
	Set obj.CPOrdID=OrdID
	
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPFormTCMDr=objFormTCM
	
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

Storage Default
{
<Data name="PathwayOrdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPFormOrdDr</Value>
</Value>
<Value name="3">
<Value>CPOrdID</Value>
</Value>
<Value name="4">
<Value>CPIsActive</Value>
</Value>
<Value name="5">
<Value>CPActDate</Value>
</Value>
<Value name="6">
<Value>CPActTime</Value>
</Value>
<Value name="7">
<Value>CPActUserID</Value>
</Value>
<Value name="8">
<Value>CPFormTCMDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORD")</DataLocation>
<DefaultData>PathwayOrdDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORD")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("IMPL","ORD")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayOrdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
