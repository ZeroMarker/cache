/// 名称 : DHCMed.SS.DiseaseICD
/// 说明 : 疾病ICD10维护
Class DHCMed.SS.DiseaseICD Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.SS.Disease [ Cardinality = parent, Inverse = ChildICD ];

/// ICD10
Property IDICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 疾病名称
Property IDICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 排除关键字(多值#分隔)
Property IDExWords As %String(MAXLEN = 100, TRUNCATE = 1);

/// 以ICD10为索引
Index IndexICD10 On IDICD10;

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  取疾病ICD
/// Table：       DHCMed.SS.DiseaseICD
/// Input：       Id : DHCMed.SS.DiseaseICD.ID
/// Return：      返回Object
/// w ##class(DHCMed.SS.DiseaseICD).GetObjById("")
ClassMethod GetObjById(aId As %String) As DHCMed.SS.DiseaseICD
{
	new (aId)
	quit:'##class(DHCMed.SS.DiseaseICD).%ExistsId(aId) ""
	set obj=##Class(DHCMed.SS.DiseaseICD).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  更新疾病ICD
/// Table：       DHCMed.SS.DiseaseICD
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.DiseaseICD).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set ICD10=$p(aInputStr,aSeparate,3)
	Set ICDDesc=$p(aInputStr,aSeparate,4)
	Set ExWords=$p(aInputStr,aSeparate,5)
	Quit:(Parref="")||(ICD10="")||(ICDDesc="") return
	
	Set objParref=##class(DHCMed.SS.Disease).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.SS.DiseaseICD).%New()
	} Else {
		Set obj=##class(DHCMed.SS.DiseaseICD).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.IDICD10=ICD10
	Set obj.IDICDDesc=ICDDesc
	Set obj.IDExWords=ExWords
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  删除疾病ICD
/// Table：       DHCMed.SS.DiseaseICD
/// Input：       Id : DHCMed.SS.DiseaseICD.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.DiseaseICD).DeleteById("")
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCMed.SS.DiseaseICD).%DeleteId(aId)
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
<Value>IDICD10</Value>
</Value>
<Value name="3">
<Value>IDICDDesc</Value>
</Value>
<Value name="4">
<Value>IDExWords</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^DHCMed.SS.DiseaseI("DI")</IndexLocation>
<StreamLocation>^DHCMed.SS.DiseaseICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
