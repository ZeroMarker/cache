/// 名称: DHCMed.NINF.Dic.InfDiagnoseGist
/// 描述: 诊断标准字典
/// 编写者：zhangxing
/// 编写日期: 2012-12-03
Class DHCMed.NINF.Dic.InfDiagnoseGist Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.NINF.Dic.InfDiagnose [ Cardinality = parent, Inverse = ChildSub ];

/// 诊断标准类型
Property IDGType As DHCMed.SS.Dictionary;

/// 诊断标准代码
Property IDGCode As %String;

/// 诊断标准内容
Property IDGDesc As %String(MAXLEN = 1000);

Index InCode On (IDGCode, Parref) [ Unique ];

/// Creator：     zhangxing
/// CreatDate：   2012-12-03
/// Description:  取诊断标准字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       DHCMed.NINF.Dic.InfDiagnoseGist.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.InfDiagnoseGist).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.InfDiagnoseGist
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.InfDiagnoseGist).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangxing
/// CreatDate：   2012-12-23
/// Description:  更新诊断标准字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.InfDiagnoseGist).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set Parref=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Dic.InfDiagnoseGist).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.InfDiagnoseGist).%OpenId(Parref_"||"_ChildSub)         //ID是指rowid 因为不可能只有childsub
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(Parref)
	Set obj.IDGType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
	Set obj.IDGCode=$p(aInput,aSeparate,4)
	Set obj.IDGDesc=$p(aInput,aSeparate,5)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		//Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhangxing
/// CreatDate：   2012-12-03
/// Description:  删除诊断标准字典
/// Table：       DHCMed.NINF.Dic.InfDiagnoseGist
/// Input：       DHCMed.NINF.Dic.InfDiagnoseGist.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.InfDiagnoseGist).DeleteById(2||5)
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Dic.InfDiagnoseGist).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDGType</Value>
</Value>
<Value name="3">
<Value>IDGCode</Value>
</Value>
<Value name="4">
<Value>IDGDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GIST")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("GIST")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("InfDia",0,"GIST")</IndexLocation>
<StreamLocation>^DHCMed.NIN8E9F.InfDiagnoseCC2CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
