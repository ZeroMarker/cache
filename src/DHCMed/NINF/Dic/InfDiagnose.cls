/// 名称: DHCMed.NINF.Dic.InfDiagnose
/// 描述: 院感诊断字典
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.InfDiagnose Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 指向子表
Relationship ChildSub As DHCMed.NINF.Dic.InfDiagnoseGist [ Cardinality = children, Inverse = Parref ];

/// 代码
Property IDCode As %String(TRUNCATE = 1) [ Required ];

/// 描述
Property IDDesc As %String(TRUNCATE = 1) [ Required ];

/// ICD
Property IDICD10 As %String(TRUNCATE = 1);

/// 是否有效
Property IDActive As %Boolean;

/// 拼音/别名
Property IDAlias As %String(TRUNCATE = 1);

/// 备注
Property IDResume As %String(TRUNCATE = 1);

Index IndexCode On IDCode As SqlUpper;

Index IndexDesc On IDDesc As SqlUpper;

Index IndexAlias On IDAlias As SqlUpper;

Index IndexICD10 On IDICD10 As SqlString;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取感染诊断字典
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       DHCMed.NINF.Dic.InfDiagnose.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.InfDiagnose
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.InfDiagnose).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新感染诊断字典
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.InfDiagnose).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.InfDiagnose).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.InfDiagnose).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IDCode=$p(aInput,aSeparate,2)
	Set obj.IDDesc=$p(aInput,aSeparate,3)
	Set obj.IDICD10=$p(aInput,aSeparate,4)
	Set obj.IDActive=+$p(aInput,aSeparate,5)
	Set obj.IDAlias=$p(aInput,aSeparate,6)
	Set obj.IDResume=$p(aInput,aSeparate,7)
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
/// Description:  删除感染诊断字典
/// Table：       DHCMed.NINF.Dic.InfDiagnose
/// Input：       DHCMed.NINF.Dic.InfDiagnose.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.InfDiagnose).%DeleteId(+aId)
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
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>IDDesc</Value>
</Value>
<Value name="4">
<Value>IDICD10</Value>
</Value>
<Value name="5">
<Value>IDActive</Value>
</Value>
<Value name="6">
<Value>IDAlias</Value>
</Value>
<Value name="7">
<Value>IDResume</Value>
</Value>
<Value name="8">
<Value>ChildSub</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("InfDia")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("InfDia")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("InfDia",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.InfDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
