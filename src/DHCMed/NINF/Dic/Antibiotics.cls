/// 名称: DHCMed.NINF.Dic.Antibiotics
/// 描述: 抗生素字典
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.Antibiotics Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property ANTCode As %String(TRUNCATE = 1) [ Required ];

/// whonet码
Property ANTWhonet As %String(TRUNCATE = 1);

/// 名称
Property ANTDesc As %String(TRUNCATE = 1) [ Required ];

/// 名称1
Property ANTDesc1 As %String(TRUNCATE = 1);

/// 是否有效
Property ANTActive As %Boolean;

/// 备注
Property ANTResume As %String(TRUNCATE = 1);

/// 拼音码
Property ANTPinyin As %String(TRUNCATE = 1);

/// 抗菌药物大类代码  //add by wuqk 2013-02-25
Property ANTCateCode As %String(TRUNCATE = 1);

/// 抗菌药物子类代码 //add by wuqk 2013-02-25
Property ANTSubCateCode As %String(TRUNCATE = 1);

Index IndexCode On ANTCode As SqlUpper;

Index IndexDesc On ANTDesc As SqlUpper;

Index IndexDesc1 On ANTDesc1 As SqlUpper;

Index IndexPinyin On ANTPinyin As SqlUpper;

/// 大类 子类 索引  //add by wuqk 2013-02-25
Index IndexCate On (ANTCateCode As SqlUpper, ANTSubCateCode As SqlUpper);

/// WHONet编码索引
Index IndexWHONet On ANTWhonet As SqlUpper;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取抗生素字典
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       DHCMed.NINF.Dic.Antibiotics.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.Antibiotics
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.Antibiotics).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     wuqk
/// CreatDate：   2013-03-08
/// Description:  取抗生素字典
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       WHONet
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.Antibiotics).GetObjByWHONet("apx")
ClassMethod GetObjByWHONet(aWHONet As %String) As DHCMed.NINF.Dic.Antibiotics
{
	New (aWHONet)
	set aWHONet=$zcvt(aWHONet,"U")
	Set Id=$o(^DHCMed.NINFDi("Anti",0,"IndexWHONet"," "_aWHONet,""))
	Quit:Id="" ""
	Set obj=##Class(DHCMed.NINF.Dic.Antibiotics).%OpenId(Id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新抗生素字典
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.Antibiotics).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.Antibiotics).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.Antibiotics).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ANTCode=$p(aInput,aSeparate,2)
	Set obj.ANTDesc=$p(aInput,aSeparate,3)
	Set obj.ANTDesc1=$p(aInput,aSeparate,4)
	Set obj.ANTActive=+$p(aInput,aSeparate,5)
	Set obj.ANTResume=$p(aInput,aSeparate,6)
	Set obj.ANTWhonet=$p(aInput,aSeparate,7)
	Set obj.ANTPinyin=$zcvt($p(aInput,aSeparate,8),"U")   //update by zhangxing 20121018
	Set obj.ANTCateCode=$zcvt($p(aInput,aSeparate,9),"U")   //Add by wuqk 2013-02-25
	Set obj.ANTSubCateCode=$zcvt($p(aInput,aSeparate,10),"U")   //Add by wuqk 2013-02-25
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
/// Description:  删除抗生素字典
/// Table：       DHCMed.NINF.Dic.Antibiotics
/// Input：       DHCMed.NINF.Dic.Antibiotics.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.Antibiotics).%DeleteId(+aId)
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
Parameter XMLTYPE = "DHCMed.NINF.Dic.Antibiotics";

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ANTCode</Value>
</Value>
<Value name="3">
<Value>ANTDesc</Value>
</Value>
<Value name="4">
<Value>ANTDesc1</Value>
</Value>
<Value name="5">
<Value>ANTActive</Value>
</Value>
<Value name="6">
<Value>ANTResume</Value>
</Value>
<Value name="7">
<Value>ANTWhonet</Value>
</Value>
<Value name="8">
<Value>ANTPinyin</Value>
</Value>
<Value name="9">
<Value>ANTCateCode</Value>
</Value>
<Value name="10">
<Value>ANTSubCateCode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("Anti")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("Anti")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("Anti",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.AntibioticsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
