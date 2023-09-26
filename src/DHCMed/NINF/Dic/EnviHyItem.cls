/// 名称: DHCMed.NINF.Dic.EnviHyItem
/// 描述: 环境卫生学监测 项目字典
/// 编写者：zhufei
/// 编写日期: 2012-08-13
Class DHCMed.NINF.Dic.EnviHyItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 计算公式
Relationship ChildMula As DHCMed.NINF.Dic.EnviHyItmForMula [ Cardinality = children, Inverse = ParRef ];

/// 检测项目值判定标准
Relationship ChildMap As DHCMed.NINF.Dic.EnviHyItmMap [ Cardinality = children, Inverse = ParRef ];

/// 代码
Property EHICode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property EHIDesc As %String(TRUNCATE = 1) [ Required ];

/// 检测内容
Property EHIContent As %String(TRUNCATE = 1);

/// 项目默认值
Property EHIDefaultValue As %String(TRUNCATE = 1);

/// 分类("NINFEnviHyItemCategory")
Property EHICateg As DHCMed.SS.Dictionary;

/// 频率("NINFEnviHyItemFrequency")
Property EHIFreq As DHCMed.SS.Dictionary;

/// 标准值单位("NINFEnviHyNormUom")
Property EHINormUom As DHCMed.SS.Dictionary;

/// 是否有效
Property EHIActive As %Boolean;

/// 备注
Property EHIResume As %String(TRUNCATE = 1);

Index IndexCode On EHICode [ Unique ];

Index IndexItemCateg On EHICateg;

Index IndexDesc On EHIDesc [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  取环境卫生学监测项目字典
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       DHCMed.NINF.Dic.EnviHyItem.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyItem
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.EnviHyItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  更新环境卫生学监测项目字典
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       "^"分隔
/// Return：      return>0:成功【返回对象ID】  return=0:失败【创建或打开对象错误】return=-1：失败【对象保存出错】
/// w ##Class(DHCMed.NINF.Dic.EnviHyItem).Update("^01^非洁净区空气^^1^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHICode=$p(aInput,aSeparate,2)
	Set obj.EHIDesc=$p(aInput,aSeparate,3)
	Set obj.EHIContent=$p(aInput,aSeparate,4)
	Set obj.EHICateg=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,5))
	Set obj.EHIFreq=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,6))
	Set obj.EHINormUom=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,7))
	Set obj.EHIActive=+$p(aInput,aSeparate,8)
	Set obj.EHIResume=$p(aInput,aSeparate,9)
	if (($p(aInput,aSeparate,10)'="")&&(ID="")){
		Set objFormula = ##class(DHCMed.NINF.Dic.EnviHyItmForMula).%New()
		Set objFormula.EHIFForMula = $p(aInput,aSeparate,10)
		Set objFormula.EHIFIsActive = 1
		Set scFormula = objFormula.%Save()
		do obj.ChildMula.Insert(objFormula)
		Do objFormula.%Close()
	}
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
/// CreatDate：   2012-08-14
/// Description:  删除环境卫生学监测项目字典
/// Table：       DHCMed.NINF.Dic.EnviHyItem
/// Input：       DHCMed.NINF.Dic.EnviHyItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.EnviHyItem).%DeleteId(+aId)
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
<Value>EHICode</Value>
</Value>
<Value name="3">
<Value>EHIDesc</Value>
</Value>
<Value name="4">
<Value>EHICateg</Value>
</Value>
<Value name="5">
<Value>EHIFreq</Value>
</Value>
<Value name="6">
<Value>EHINormUom</Value>
</Value>
<Value name="7">
<Value>EHIActive</Value>
</Value>
<Value name="8">
<Value>EHIResume</Value>
</Value>
<Value name="9">
<Value>EHIContent</Value>
</Value>
<Value name="10">
<Value>Formula</Value>
</Value>
<Value name="11">
<Value>EHIDefaultValue</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("EHI")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("EHI")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("EHI",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.EnviHyItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
