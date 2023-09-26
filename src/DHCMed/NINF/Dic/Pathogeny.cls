/// 名称: DHCMed.NINF.Dic.Pathogeny
/// 描述: 病原体字典
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.Pathogeny Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property PYCode As %String(TRUNCATE = 1) [ Required ];

/// whonet码
Property PYWhonet As %String(TRUNCATE = 1);

/// 名称
Property PYDesc As %String(TRUNCATE = 1) [ Required ];

/// 名称1
Property PYDesc1 As %String(TRUNCATE = 1);

/// 是否有效
Property PYActive As %Boolean;

/// 备注
Property PYResume As %String(TRUNCATE = 1);

/// 是否多重耐药菌
Property PYIsMultires As %Boolean;

/// 多重耐药菌分组("NINFMultiresGroup")
Property PYMultiresGroup As DHCMed.SS.Dictionary;

/// 拼音码
Property PYPinyin As %String(TRUNCATE = 1);

/// 病原体大类代码  //add by wuqk 2013-02-25
Property PYCateCode As %String(TRUNCATE = 1);

/// 病原体子类代码 //add by wuqk 2013-02-25
Property PYSubCateCode As %String(TRUNCATE = 1);

Index IndexCode On PYCode As SqlUpper;

Index IndexDesc On PYDesc As SqlUpper;

Index IndexDesc1 On PYDesc1 As SqlUpper;

Index IndexPinyin On PYPinyin As SqlUpper;

/// 大类 子类 索引  //add by wuqk 2013-02-25
Index IndexCate On (PYCateCode As SqlUpper, PYSubCateCode As SqlUpper);

/// WHONet编码索引
Index IndexWHONet On PYWhonet As SqlUpper;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取病原体字典
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Input：       DHCMed.NINF.Dic.Pathogeny.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.Pathogeny
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.Pathogeny).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新病原体字典
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.Pathogeny).Update("8^0008^伯尔德隐秘杆菌^Actinomyces bernardiae^1^^0^^abe^hgjghgg","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.Pathogeny).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.Pathogeny).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PYCode=$p(aInput,aSeparate,2)
	Set obj.PYDesc=$p(aInput,aSeparate,3)
	Set obj.PYDesc1=$p(aInput,aSeparate,4)
	Set obj.PYActive=+$p(aInput,aSeparate,5)
	Set obj.PYResume=$p(aInput,aSeparate,6)
	Set obj.PYIsMultires=+$p(aInput,aSeparate,7)
	Set obj.PYMultiresGroup=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,8))
	Set obj.PYWhonet=$p(aInput,aSeparate,9)
	Set obj.PYPinyin=$zcvt($p(aInput,aSeparate,10),"U")   //update by zhangxing 20121018
	Set obj.PYCateCode=$zcvt($p(aInput,aSeparate,11),"U")   //Add by wuqk 2013-02-25
	Set obj.PYSubCateCode=$zcvt($p(aInput,aSeparate,12),"U")   //Add by wuqk 2013-02-25
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
/// CreatDate：   2012-05-25
/// Description:  删除病原体字典
/// Table：       DHCMed.NINF.Dic.Pathogeny
/// Input：       DHCMed.NINF.Dic.Pathogeny.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.Pathogeny).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// This parameter provides the default XMLTYPE for the class. If it is
/// empty then the class name will be used to construct a default XML type.
/// 
/// The default XMLTYPE is used when naming and referencing this type 
/// in a schema and the schema context did not provide an XML type name.
Parameter XMLTYPE = "DHCMed.NINF.Dic.Pathogeny";

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PYCode</Value>
</Value>
<Value name="3">
<Value>PYDesc</Value>
</Value>
<Value name="4">
<Value>PYDesc1</Value>
</Value>
<Value name="5">
<Value>PYActive</Value>
</Value>
<Value name="6">
<Value>PYResume</Value>
</Value>
<Value name="7">
<Value>PYIsMultires</Value>
</Value>
<Value name="8">
<Value>PYMultiresGroup</Value>
</Value>
<Value name="9">
<Value>PYWhonet</Value>
</Value>
<Value name="10">
<Value>PYPinyin</Value>
</Value>
<Value name="11">
<Value>PYCateCode</Value>
</Value>
<Value name="12">
<Value>PYSubCateCode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("Py")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("Py")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("Py",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.PathogenyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
