/// 传染病CDC对照数据
/// 创建者：刘宇辉
/// 创建日期：2016-12-23
Class DHCMed.EPD.CDCDicMapping Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 对照类型字典ID
Property Category As %String(TRUNCATE = 1);

/// 源值 传染病疾病字典ID或基础字典ID
Property SrcObjectID As %String(TRUNCATE = 1);

/// 目标值描述
Property TargetDesc As %String(TRUNCATE = 1);

/// 对照类别和源ID索引
Index IndexCategorySrcID On (Category, SrcObjectID) [ Unique ];

ClassMethod GetObjById(aId As %String) As DHCMed.EPD.CDCDicMapping
{
	New (aId)
	Set obj=##Class(DHCMed.EPD.CDCDicMapping).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuyh
/// CreatDate：   2016-12-23
/// Description:  更新传染病CDC字典对照
/// Table：       DHCMed.EPD.CDCDicMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPD.CDCDicMapping).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE

	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set SrcObjectID=$p(aInput,aSeparate,3)
	Set TargetDesc=$p(aInput,aSeparate,4)
	
	Quit:(Category="")||(SrcObjectID="") return
	
	If (ID="") {
		Set obj=##class(DHCMed.EPD.CDCDicMapping).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.CDCDicMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=Category
	Set obj.SrcObjectID=SrcObjectID
	Set obj.TargetDesc=TargetDesc

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

Storage Default
{
<Data name="CDCDicMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>SrcObjectID</Value>
</Value>
<Value name="4">
<Value>SrcDescription</Value>
</Value>
<Value name="5">
<Value>TargetDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.CDCDicMappingD</DataLocation>
<DefaultData>CDCDicMappingDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.CDCDicMappingD</IdLocation>
<IndexLocation>^DHCMed.EPD.CDCDicMappingI</IndexLocation>
<StreamLocation>^DHCMed.EPD.CDCDicMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
