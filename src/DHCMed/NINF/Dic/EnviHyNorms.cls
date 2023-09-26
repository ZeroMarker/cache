/// 名称: DHCMed.NINF.Dic.EnviHyNorms
/// 描述: 环境卫生学监测 结果判断标准
/// 编写者：zhufei
/// 编写日期: 2012-08-13
Class DHCMed.NINF.Dic.EnviHyNorms Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 环境类别("NINFEnviHyNormCategory")
Property EHNCateg As DHCMed.SS.Dictionary;

/// 范围
Property EHNRange As %String(TRUNCATE = 1);

/// 结果判定标准
Property EHNNorm As %String(TRUNCATE = 1);

/// 中心值标准
Property EHNNormMax As %String(TRUNCATE = 1);

/// 周边值标准
Property EHNNormMin As %String(TRUNCATE = 1);

/// 标本数量  选中监测标准自动带出标本数量
Property SpecimenNum As %String(TRUNCATE = 1);

/// 中心个数  
Property CenterNum As %String(TRUNCATE = 1);

/// 周边个数
Property SurroundNum As %String(TRUNCATE = 1);

/// 项目对象
Property ItemObj As %String(TRUNCATE = 1);

/// 标本类型 "NINFEnviHySpecimenType"
Property SpecimenType As DHCMed.SS.Dictionary;

/// 是否有效
Property EHNIsActive As %Boolean;

/// 备注
Property EHNResume As %String(TRUNCATE = 1);

Index IndexCategRange1 On (EHNCateg, EHNRange, SpecimenType) [ Unique ];

Index IndexActive On EHNIsActive As Exact;

Index IndexCategRange On (EHNCateg As Exact, EHNRange As Exact, SpecimenType As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  取环境卫生学监测结果判断标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       DHCMed.NINF.Dic.EnviHyNorms.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.EnviHyNorms).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyNorms
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.EnviHyNorms).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  更新环境卫生学监测结果判断标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.EnviHyNorms).Update("^3014^桌面^5^10^1^1^测试","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyNorms).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyNorms).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.EHNCateg=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,2))
	Set obj.EHNRange=$p(aInput,aSeparate,3)
	Set obj.EHNNorm=$p(aInput,aSeparate,4)
	Set obj.EHNNormMax=$p(aInput,aSeparate,5)
	Set obj.EHNNormMin=$p(aInput,aSeparate,6)
	Set obj.EHNIsActive=$p(aInput,aSeparate,7)
	Set obj.EHNResume=$p(aInput,aSeparate,8)
	Set obj.SpecimenType =##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,9))
	Set obj.SpecimenNum =$p(aInput,aSeparate,10)
	Set obj.CenterNum =$p(aInput,aSeparate,11)
	Set obj.SurroundNum =$p(aInput,aSeparate,12)
	Set obj.ItemObj=$p(aInput,aSeparate,13)
	Set ItemID=$p(aInput,aSeparate,14)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set NormID=obj.%Id()
		If (ItemID'=""){
			Set MapStr = ""_"^"_NormID_"^"_ItemID_"^"_1_"^"
			Set flg=##Class(DHCMed.NINF.Dic.EnviHyItmMap).Update(MapStr,"^")
		}
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-14
/// Description:  删除环境卫生学监测结果判断标准
/// Table：       DHCMed.NINF.Dic.EnviHyNorms
/// Input：       DHCMed.NINF.Dic.EnviHyNorms.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.EnviHyNorms).%DeleteId(+aId)
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
<Value>EHNCateg</Value>
</Value>
<Value name="3">
<Value>EHNRange</Value>
</Value>
<Value name="4">
<Value>EHNNorm</Value>
</Value>
<Value name="5">
<Value>EHNNormMax</Value>
</Value>
<Value name="6">
<Value>EHNNormMin</Value>
</Value>
<Value name="7">
<Value>EHNIsActive</Value>
</Value>
<Value name="8">
<Value>EHNResume</Value>
</Value>
<Value name="9">
<Value>ItemObj</Value>
</Value>
<Value name="10">
<Value>SpecimenNum</Value>
</Value>
<Value name="11">
<Value>SpecimenType</Value>
</Value>
<Value name="12">
<Value>CenterNum</Value>
</Value>
<Value name="13">
<Value>SurroundNum</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("EHN")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("EHN")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("EHN",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.EnviHyNormsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
