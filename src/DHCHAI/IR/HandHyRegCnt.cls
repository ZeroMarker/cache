/// 描述: 手卫生依从性调查人数
/// 编写者：zhufei
/// 编写日期: 2017-12-15
Class DHCHAI.IR.HandHyRegCnt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.HandHyReg [ Cardinality = parent, Inverse = ChildCnt ];

/// 专业/职业("HandHyObsType")
Property HHObsTypeDr As DHCHAI.BT.Dictionary;

/// 调查人数
Property HHObsCount As %Integer;

/// 区分调查人标记/保证调查人数与填写内容一直,无实际意义
Property HHObsSign As %String(MAXLEN = 100, TRUNCATE = 1);

/// 专业索引 
Index IndexType On (Parref, HHObsTypeDr, HHObsSign As Exact);

/// 专业索引 
Index IndexSign On (Parref, HHObsSign As Exact);

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  获取手卫生依从性调查人数信息
/// Table：       DHCHAI.IR.HandHyRegCnt
/// Input：       DHCHAI.IR.HandHyRegCnt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.HandHyRegCnt).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.HandHyRegCnt
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.HandHyRegCnt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-30
/// Description:  根据调查表ID+专业类型取专业人数
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aLocDr
/// Return：      返回DHCHAI.IR.HandHyReg.%Id()
/// w ##class(DHCHAI.IR.HandHyRegCnt).GetCntByType(1,"A")
ClassMethod GetCntByType(aParref As %String, aObsType As %String) As %String
{
	New (aParref,aObsType)
	Set return=""
	
	Quit:((aParref="")||(aObsType="")) return
	// 专业
	If (aObsType="A"){
		Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType","医生","1")
	}ElseIf (aObsType="B"){
		Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType","护士","1")
	}ElseIf (aObsType="C"){
		Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType","护理员","1")
	}ElseIf (aObsType="D"){
		Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType","卫生员","1")
	}Else{
		Set ObsTypeDr=""
	}
	Quit:ObsTypeDr="" return
	Set ID=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",aParref,ObsTypeDr,0))
	Quit:ID="" return
	Set obj=..GetObjById(aParref_"||"_ID)
	Quit:'$IsObject(obj) return
	Quit obj.HHObsCount
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  保存手卫生依从性调查人数信息
/// Table：       DHCHAI.IR.HandHyRegCnt
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.HandHyRegCnt).Update("3^^680^20","")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set Parref       = $p(aInput,aSeparete,1)
	Set ChildSub     = $p(aInput,aSeparete,2)
	Set ObsTypeDr    = $p(aInput,aSeparete,3)
	Set ObsCount     = +$p(aInput,aSeparete,4)
	Set ObsSign      = $p(aInput,aSeparete,5)
	Quit:(ObsTypeDr="")||(ObsCount="")||(ObsSign="") return
	
	Set objParref=##class(DHCHAI.IR.HandHyReg).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objObsType=##class(DHCHAI.BT.Dictionary).GetObjById(ObsTypeDr)
	Quit:'$IsObject(objObsType) return
    
    // 调查表+某个标记  保持一条记录 (修改职业类型导致索引标化，人数会发生变化)
	Set ChildSub=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexSign",Parref,ObsSign,0))
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.HandHyRegCnt).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.HandHyRegCnt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.HHObsTypeDr  = objObsType
	Set obj.HHObsCount   = ObsCount
	Set obj.HHObsSign    = ObsSign
	
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
/// Description:  删除手卫生依从性调查人数信息
/// Table：       DHCHAI.IR.HandHyRegCnt
/// Input：       aId : DHCHAI.IR.HandHyRegCnt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.HandHyRegCnt).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.HandHyRegCnt).%DeleteId(aId)
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
<Data name="HandHyRegCntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHObsTypeDr</Value>
</Value>
<Value name="3">
<Value>HHObsCount</Value>
</Value>
<Value name="4">
<Value>HHObsSign</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Cnt")</DataLocation>
<DefaultData>HandHyRegCntDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Cnt")</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyRegI("Cnt")</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyRegCntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
