/// 名称: DHCMed.NINF.Dic.EnviHyItmMap
/// 描述: 环境卫生学监测报告 检测项目与判定标准关联
/// 编写者：yhb
/// 编写日期: 2013-11-11
Class DHCMed.NINF.Dic.EnviHyItmMap Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not Final, Not ProcedureBlock, Not SqlRowIdPrivate ]
{

Relationship ParRef As DHCMed.NINF.Dic.EnviHyItem [ Cardinality = parent, Inverse = ChildMap ];

/// 结果判定标准
Property EHIMNorm As DHCMed.NINF.Dic.EnviHyNorms;

/// 是否有效
Property EHIMIsActive As %Boolean;

/// 备注
Property EHIMResume As %String(MAXLEN = 200, TRUNCATE = 1);

Index IndexEHIMNorm On EHIMNorm;

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  取环境卫生学监测报告 检测项目值判定标准
/// Table：       DHCMed_NINF_Dic.EnviHyItmMap
/// Input：       DHCMed_NINF_Dic.EnviHyItmMap.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.EnviHyItmMap).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyItmMap
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.EnviHyItmMap).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  更新环境卫生学监测报告 检测项目值判定标准
/// Table：       DHCMed_NINF_Dic.EnviHyItmMap
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// 标准值ID^标准ID^检测项目ID^是否有效^备注
/// w ##Class(DHCMed.NINF.Dic.EnviHyItmMap).Update("1^1^1^1^试一试","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set ID=$p(aInput,CHR1,1)
	Set NormID=$p(aInput,CHR1,2)
	Set ItemID=$p(aInput,CHR1,3)
	Quit:(ItemID="")||(NormID="") return
	
	Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ItemID)
	Quit:'$IsObject(objItem) return
	
	Set objNorm=##class(DHCMed.NINF.Dic.EnviHyNorms).GetObjById(NormID)
	Quit:'$IsObject(objNorm) return
	
	Set MapID=$o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",NormID,ItemID,0))
	Set:MapID'="" ID=ItemID_"||"_MapID
	
	if (ID=""){
		Set obj=##Class(DHCMed.NINF.Dic.EnviHyItmMap).%New()
	}else{
		Set obj=##class(DHCMed.NINF.Dic.EnviHyItmMap).%OpenId(ID)
	}
	
	Set obj.ParRef=objItem
	Set obj.EHIMNorm=objNorm
	Set obj.EHIMIsActive=+$p(aInput,CHR1,4)
	Set obj.EHIMResume=$p(aInput,CHR1,5)
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

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  删除环境卫生学监测报告 检测项目值判定标准
/// Table：       DHCMed_NINF_Dic.EnviHyItmMap
/// Input：       DHCMed_NINF_Dic.EnviHyItmMap.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.EnviHyItmMap).%DeleteId(aId)
	If $System.Status.IsError(sc) {  
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
<Value>EHIMNorm</Value>
</Value>
<Value name="3">
<Value>EHIMIsActive</Value>
</Value>
<Value name="4">
<Value>EHIMResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MAP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("MAP")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("EHI",0,"MAP")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.EnviHyItmMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
