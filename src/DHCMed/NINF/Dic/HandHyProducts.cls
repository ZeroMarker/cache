/// 名称: DHCMed.NINF.Dic.HandHyProducts
/// 描述: 手卫生用品字典字典
/// 编写者：zhufei
/// 编写日期: 2013-07-19
Class DHCMed.NINF.Dic.HandHyProducts Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property HHPCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property HHPDesc As %String(TRUNCATE = 1) [ Required ];

/// 名称1
Property HHPDesc1 As %String(TRUNCATE = 1);

/// 拼音码
Property HHPPinyin As %String(TRUNCATE = 1);

/// 规格
Property HHPSpec As %String(TRUNCATE = 1) [ Required ];

/// 单位
Property HHPUnit As %String(TRUNCATE = 1) [ Required ];

/// 是否有效
Property HHPActive As %Boolean;

/// 备注
Property HHPResume As %String(TRUNCATE = 1);

/// 分类("NINFHandHyProductGrp")
Property HHPGroup As DHCMed.SS.Dictionary;

Index IndexCodeSpec On (HHPCode, HHPSpec) [ Unique ];

Index IndexDesc On HHPDesc As SqlUpper;

Index IndexDesc1 On HHPDesc1 As SqlUpper;

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  取手卫生用品字典字典
/// Table：       DHCMed.NINF.Dic.HandHyProducts
/// Input：       DHCMed.NINF.Dic.HandHyProducts.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.HandHyProducts).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.HandHyProducts
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.HandHyProducts).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-07-19
/// Description:  更新手卫生用品字典字典
/// Table：       DHCMed.NINF.Dic.HandHyProducts
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.HandHyProducts).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.HandHyProducts).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.HandHyProducts).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HHPCode=$zcvt($p(aInput,aSeparate,2),"U")
	Set obj.HHPDesc=$p(aInput,aSeparate,3)
	Set obj.HHPDesc1=$p(aInput,aSeparate,4)
	Set obj.HHPPinyin=$zcvt($p(aInput,aSeparate,5),"U")
	Set obj.HHPSpec=$p(aInput,aSeparate,6)
	Set obj.HHPUnit=$p(aInput,aSeparate,7)
	Set obj.HHPActive=+$p(aInput,aSeparate,8)
	Set obj.HHPResume=$p(aInput,aSeparate,9)
	Set obj.HHPGroup=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,10))
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
/// CreatDate：   2013-07-19
/// Description:  删除手卫生用品字典字典
/// Table：       DHCMed.NINF.Dic.HandHyProducts
/// Input：       DHCMed.NINF.Dic.HandHyProducts.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.HandHyProducts).%DeleteId(+aId)
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
<Value>HHPCode</Value>
</Value>
<Value name="3">
<Value>HHPDesc</Value>
</Value>
<Value name="4">
<Value>HHPDesc1</Value>
</Value>
<Value name="5">
<Value>HHPPinyin</Value>
</Value>
<Value name="6">
<Value>HHPSpec</Value>
</Value>
<Value name="7">
<Value>HHPUnit</Value>
</Value>
<Value name="8">
<Value>HHPActive</Value>
</Value>
<Value name="9">
<Value>HHPResume</Value>
</Value>
<Value name="10">
<Value>HHPGroup</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("HHP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("HHP")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("HHP",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.HandHyProductsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
