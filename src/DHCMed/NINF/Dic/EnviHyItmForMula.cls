/// 名称: DHCMed.NINF.Dic.EnviHyItmForMula
/// 描述: 环境卫生学监测报告 计算公式
/// 编写者：yhb
/// 编写日期: 2013-11-11
Class DHCMed.NINF.Dic.EnviHyItmForMula Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Dic.EnviHyItem [ Cardinality = parent, Inverse = ChildMula ];

/// 计算公式
Property EHIFForMula As %String;

/// 是否有效
Property EHIFIsActive As %Boolean;

/// 备注
Property EHIFResume As %String(MAXLEN = 200, TRUNCATE = 1);

Index IndexParRef On ParRef;

// add by zhoubo 2014-12-19

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  取环境卫生学监测报告 计算公式
/// Table：       DHCMed_NINF_Dic.EnviHyItmForMula
/// Input：       DHCMed.NINF.Dic.EnviHyItmForMula.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.EnviHyItmForMula).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyItmForMula
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.EnviHyItmForMula).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  更新环境卫生学监测报告 计算公式
/// Table：       DHCMed_NINF_Dic.EnviHyItmForMula
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.EnviHyItmForMula).Update("1||1^1^50000N/(AXT)^1^test","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyItmForMula).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyItmForMula).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set ParRef=$p(aInput,CHR1,2)
	Set obj.ParRef = ##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ParRef)
	Set obj.EHIFForMula=$p(aInput,CHR1,3)
	Set obj.EHIFIsActive=$p(aInput,CHR1,4)
	Set obj.EHIFResume=$p(aInput,CHR1,5)
	
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

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  删除环境卫生学监测报告 计算公式
/// Table：       DHCMed_NINF_Dic.EnviHyItmForMula
/// Input：       DHCMed_NINF_Dic.EnviHyItmForMula.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.EnviHyItmForMula).DeleteById("1||4")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.EnviHyItmForMula).%DeleteId(aId)
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
<Value>EHIFForMula</Value>
</Value>
<Value name="3">
<Value>EHIFIsActive</Value>
</Value>
<Value name="4">
<Value>EHIFResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FM")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FM")</IdLocation>
<IndexLocation>^DHCMed.NINFi("EHI",0,"FM")</IndexLocation>
<StreamLocation>^DHCMed.NIN8E9F.EnviHyItmFo6B2DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
