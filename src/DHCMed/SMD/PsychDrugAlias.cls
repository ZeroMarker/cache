/// 名称: DHCMed.SMD.PsychDrugAlias
/// 描述: 精神类药品字典别名维护
/// 编写者：zhufei
/// 编写日期: 2015-05-14
Class DHCMed.SMD.PsychDrugAlias Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.SMD.PsychDrug [ Cardinality = parent, Inverse = ChildAlias ];

/// 别名
Property PDAlias As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexAlias On (PDAlias, ParRef);

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 取精神类药品字典别名
/// Table       : DHCMed.SMD.PsychDrugAlias
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.SMD.PsychDrugAlias).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.SMD.PsychDrugAlias
{
	New (aID)
	Quit:'##class(DHCMed.SMD.PsychDrugAlias).%ExistsId(aID) ""
	Set obj=##class(DHCMed.SMD.PsychDrugAlias).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 更新精神类药品字典别名
/// Table       : DHCMed.SMD.PsychDrugAlias
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.PsychDrugAlias).Update("1^^FFDSP","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set Parref     = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set PDAlias	   = $p(aInputStr,aSeparete,3)
	
	Quit:(Parref="")||(PDAlias="") return
	
	Set objParref=##class(DHCMed.SMD.PsychDrug).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set ChildSub=$o(^DHCMed.SMD.PsychDrugI("Alias","IndexAlias"," "_$ZCVT(PDAlias,"U"),Parref,0))
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.SMD.PsychDrugAlias).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.PsychDrugAlias).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef		= objParref
	Set obj.PDAlias		= PDAlias
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

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 删除精神类药品字典别名
/// Table       : DHCMed.SMD.PsychDrugAlias
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.SMD.PsychDrugAlias).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.SMD.PsychDrugAlias).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
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
<Value>PDAlias</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Alias")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Alias")</IdLocation>
<IndexLocation>^DHCMed.SMD.PsychDrugI("Alias")</IndexLocation>
<StreamLocation>^DHCMed.SMD.PsychDrugAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
