/// 名称 : DHCMed.SS.DiseaseAlias
/// 说明 : 疾病别名维护
Class DHCMed.SS.DiseaseAlias Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.SS.Disease [ Cardinality = parent, Inverse = ChildAlias ];

/// 别名
Property IDAlias As %String(MAXLEN = 100, TRUNCATE = 1);

/// 以别名为索引
Index IndexAlias On IDAlias;

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  取疾病别名
/// Table：       DHCMed.SS.DiseaseAlias
/// Input：       Id : DHCMed.SS.DiseaseAlias.ID
/// Return：      返回Object
/// w ##class(DHCMed.SS.DiseaseAlias).GetObjById("")
ClassMethod GetObjById(aId As %String) As DHCMed.SS.DiseaseAlias
{
	new (aId)
	quit:'##class(DHCMed.SS.DiseaseAlias).%ExistsId(aId) ""
	set obj=##Class(DHCMed.SS.DiseaseAlias).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-17
/// Description:  更新疾病别名
/// Table：       DHCMed.SS.DiseaseAlias
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.DiseaseAlias).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set Alias=$p(aInputStr,aSeparate,3)
	Quit:(Parref="")||(Alias="") return
	
	Set objParref=##class(DHCMed.SS.Disease).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.SS.DiseaseAlias).%New()
	} Else {
		Set obj=##class(DHCMed.SS.DiseaseAlias).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.IDAlias=Alias
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
/// Description:  删除疾病别名
/// Table：       DHCMed.SS.DiseaseAlias
/// Input：       Id : DHCMed.SS.DiseaseAlias.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SS.DiseaseAlias).DeleteById("")
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCMed.SS.DiseaseAlias).%DeleteId(aId)
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
<Value>IDAlias</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("A")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("A")</IdLocation>
<IndexLocation>^DHCMed.SS.DiseaseI("DA")</IndexLocation>
<StreamLocation>^DHCMed.SS.DiseaseAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
