/// 名称: DHCMed.NINF.Rep.AimAdmTransDay
/// 描述: 目标性监测 科室住院记录明细
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.NINF.Rep.AimAdmTransDay Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimAdmTrans [ Cardinality = parent, Inverse = ChildDay ];

/// 住院科室
Property TransLoc As %String(TRUNCATE = 1);

/// 在院日期
Property TransDate As %Date;

Index IndexLocDate On (TransLoc As Exact, TransDate As Exact);

Index IndexParRef On (ParRef As Exact, TransDate As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  取目标性监测 科室住院记录明细
/// Table：       DHCMed.NINF.Rep.AimAdmTransDay
/// Input：       DHCMed.NINF.Rep.AimAdmTransDay.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimAdmTransDay).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimAdmTransDay
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimAdmTransDay).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  更新目标性监测 科室住院记录明细
/// Table：       DHCMed.NINF.Rep.AimAdmTransDay
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimAdmTransDay).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildID=$p(aInput,aSeparate,2)
	If ChildID="" {
		Set obj=##Class(DHCMed.NINF.Rep.AimAdmTransDay).%New()
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.AimAdmTransDay).%OpenId(ParRef_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.AimAdmTrans).GetObjById(ParRef)
	Set obj.TransLoc=$p(aInput,aSeparate,3)
	Set obj.TransDate=$p(aInput,aSeparate,4)
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

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  删除目标性监测 科室住院记录明细
/// Table：       DHCMed.NINF.Rep.AimAdmTransDay
/// Input：       DHCMed.NINF.Rep.AimAdmTransDay.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimAdmTransDay).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
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
<Value>TransLoc</Value>
</Value>
<Value name="3">
<Value>TransDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Day")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Day")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimTrans",0,"Day")</IndexLocation>
<StreamLocation>^DHCMed.NINF493.AimAdmTransDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
