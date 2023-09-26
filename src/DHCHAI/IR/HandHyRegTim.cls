/// 描述: 手卫生依从性调查时机
/// 编写者：zhufei
/// 编写日期: 2017-12-15
Class DHCHAI.IR.HandHyRegTim Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.HandHyReg [ Cardinality = parent, Inverse = ChildTim ];

/// 专业/职业("HandHyObsType")
Property HHObsTypeDr As DHCHAI.BT.Dictionary;

/// 调查时机
Property HHObsTime As %Integer;

/// 手卫生指征("HandHyOpportunity")
Property HHOpportList As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手卫生措施(行为)("HandHyFacilities")
Property HHFacilitDr As DHCHAI.BT.Dictionary;

/// 是否戴手套
Property HHIsGloving As %Boolean;

/// 是否正确
Property HHIsCorrect As %Boolean;

/// 被调查人姓名
Property HHObsName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 不正确原因("HandHyErrReason")
Property HHErrResDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 区分被查标记/保证填写内容与展示内容一直,无实际意义
Property HHObsSign As %String(MAXLEN = 100, TRUNCATE = 1);

/// 不正确原因(其他)
Property HHErrResText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 调查专业+调查时机
Index IndexObsTypeTime On (Parref, HHObsTypeDr, HHObsTime, HHObsSign As Exact);

/// 区分被查标记+调查时机
Index IndexSingTime On (Parref, HHObsSign As Exact, HHObsTime);

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  获取手卫生依从性调查时机
/// Table：       DHCHAI.IR.HandHyRegTim
/// Input：       DHCHAI.IR.HandHyRegTim.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.HandHyRegTim).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.HandHyRegTim
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.HandHyRegTim).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  保存手卫生依从性调查时机
/// Table：       DHCHAI.IR.HandHyRegTim
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.HandHyRegTim).Update("1^^680^1^677,672,674^678^1^1","")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set Parref       = $p(aInput,aSeparete,1)
	Set ChildSub     = $p(aInput,aSeparete,2)
	Set ObsTypeDr    = $p(aInput,aSeparete,3)
	Set ObsTime      = $p(aInput,aSeparete,4)
	Set OpportList   = $p(aInput,aSeparete,5)
	Set FacilitDr    = $p(aInput,aSeparete,6)
	Set IsGloving    = $p(aInput,aSeparete,7)
	Set IsCorrect    = $p(aInput,aSeparete,8)
	Set ObsName      = $p(aInput,aSeparete,9)
	Set ErrResList   = $p(aInput,aSeparete,10)
	Set ObsSign      = $p(aInput,aSeparete,11)	
	Set HHErrResText      = $p(aInput,aSeparete,12)	
	Quit:(ObsTypeDr="")||(ObsTime="") return
	
	Set objParref=##class(DHCHAI.IR.HandHyReg).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objObsType=##class(DHCHAI.BT.Dictionary).GetObjById(ObsTypeDr)
	Quit:'$IsObject(objObsType) return
	Set objFacilit=##class(DHCHAI.BT.Dictionary).GetObjById(FacilitDr)
	Quit:'$IsObject(objFacilit) return
	
    // 调查表+某个专业+某个时机 保持一条记录
    // 职业可选时，一张调查表可以有相同的职业，需要区分
    Set tChildSub=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexSingTime",Parref,ObsSign,ObsTime,0))
	If tChildSub="" {
		Set obj=##class(DHCHAI.IR.HandHyRegTim).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.HandHyRegTim).%OpenId(Parref_"||"_tChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.HHObsTypeDr  = objObsType
	Set obj.HHObsTime    = ObsTime
	Set obj.HHOpportList = OpportList
	Set obj.HHFacilitDr  = objFacilit
	Set obj.HHIsGloving  = IsGloving
	Set obj.HHIsCorrect  = IsCorrect
	Set obj.HHObsName    = ObsName
	Set obj.HHErrResDr   = ErrResList
	Set obj.HHObsSign    = ObsSign
	Set obj.HHErrResText =HHErrResText
	
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

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  删除手卫生依从性调查时机
/// Table：       DHCHAI.IR.HandHyRegTim
/// Input：       aId : DHCHAI.IR.HandHyRegTim.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyRegTim).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.HandHyRegTim).%DeleteId(aId)
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
<Data name="HandHyRegTimDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHObsTypeDr</Value>
</Value>
<Value name="3">
<Value>HHObsTime</Value>
</Value>
<Value name="4">
<Value>HHOpportDr</Value>
</Value>
<Value name="5">
<Value>HHFacilitDr</Value>
</Value>
<Value name="6">
<Value>HHIsGloving</Value>
</Value>
<Value name="7">
<Value>HHIsCorrect</Value>
</Value>
<Value name="8">
<Value>HHOpportList</Value>
</Value>
<Value name="9">
<Value>HHObsName</Value>
</Value>
<Value name="10">
<Value>HHErrResDr</Value>
</Value>
<Value name="11">
<Value>HHObsSign</Value>
</Value>
<Value name="12">
<Value>HHErrResText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Tim")</DataLocation>
<DefaultData>HandHyRegTimDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Tim")</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyRegI("Tim")</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyRegTimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
