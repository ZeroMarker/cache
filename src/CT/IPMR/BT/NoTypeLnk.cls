/// 名称: CT.IPMR.BT.NoTypeLnk
/// 描述: 号码类型关联
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.NoTypeLnk Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As CT.IPMR.BT.NoType [ Cardinality = parent, Inverse = ChildLnk ];

/// 关联医院ID (指向CT_Hospital 或 CT_IPMR_BT.Hospital)
Property BNHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联科室ID (指向CT_Loc 或 CT_IPMR_BT.Location)
Property BNLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联病人类型("MrNoType")
Property BNPatType As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexLocID On (Parref, BNLocID);

Index IndexHospID On (Parref, BNHospID);

Index IndexPatType On (Parref, BNPatType);

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  取病案号码类型关联
/// Table：       CT.IPMR.BT.NoTypeLnk
/// Input：       Id : CT.IPMR.BT.NoTypeLnk.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.NoTypeLnk).GetObjById("1||1||1")
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.NoTypeLnk
{
	new (aId)
	quit:'##class(CT.IPMR.BT.NoTypeLnk).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.NoTypeLnk).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  更新病案号码类型关联
/// Table：       CT.IPMR.BT.NoTypeLnk
/// Input：       InputStr : Parref^ChildSub^NTLHospID^NTLLocID^NTLPatType
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.NoTypeLnk).Update("1||1^^2^103^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref		= $p(aInputStr,aSeparate,1)
	Set ChildSub	= $p(aInputStr,aSeparate,2)
	Set HospID		= $p(aInputStr,aSeparate,3)
	Set LocID		= $p(aInputStr,aSeparate,4)
	Set PatType		= $p(aInputStr,aSeparate,5)
	Quit:(Parref="") return
	Quit:(HospID="")||(LocID="") return
	
	Set objParref	= ##class(CT.IPMR.BT.NoType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj	= ##class(CT.IPMR.BT.NoTypeLnk).%New()
	} Else {
		Set obj	= ##class(CT.IPMR.BT.NoTypeLnk).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.BNHospID  = HospID
	Set obj.BNLocID   = LocID
	Set obj.BNPatType = PatType
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  删除病案号码类型关联
/// Table：       CT.IPMR.BT.NoTypeLnk
/// Input：       Id : CT.IPMR.BT.NoTypeLnk.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.NoTypeLnk).DeleteById("1||1||3")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set sc = ##class(CT.IPMR.BT.NoTypeLnk).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}Else{
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BNHospID</Value>
</Value>
<Value name="3">
<Value>BNLocID</Value>
</Value>
<Value name="4">
<Value>BNPatType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Link")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Link")</IdLocation>
<IndexLocation>^CT.IPMR.BT.MrTypeI("Link")</IndexLocation>
<StreamLocation>^CT.IPMR.BT.NoTypeLnkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
