/// 名称 : DHCMed.FBD.SusAbRepSign
/// 描述 : 主要症状与体征
Class DHCMed.FBD.SusAbRepSign Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.FBD.SusAbRep [ Cardinality = parent, Inverse = ChildSign ];

/// 主要症状与体征
Property RSSignDr As DHCMed.FBD.SignDic;

/// 附加项值 呕吐次数、体温数值、其他附加内容
Property RSExtraText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 以主要症状与体征为索引
Index IndexSign On RSSignDr;

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取主要症状与体征
/// Table：       DHCMed.SusAb.ReportSign
/// Input：       Id : DHCMed.SusAb.ReportSign.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.SusAbRepSign).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.SusAbRepSign
{
	New (aID)
	Quit:'##class(DHCMed.FBD.SusAbRepSign).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.SusAbRepSign).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新主要症状与体征
/// Table：       DHCMed.SusAb.ReportSign
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.SusAbRepSign).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set SignDr=$p(aInputStr,aSeparate,3)
	Set ExtraText=$p(aInputStr,aSeparate,4)
	Quit:(Parref="")||(SignDr="") return
	
	Set objParref=##class(DHCMed.FBD.SusAbRep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set objSign=##class(DHCMed.FBD.SignDic).GetObjById(SignDr)
	Quit:'$IsObject(objSign) return
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.FBD.SusAbRepSign).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.SusAbRepSign).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.RSSignDr=objSign
	Set obj.RSExtraText=ExtraText
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

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  删除主要症状与体征
/// Table：       DHCMed.SusAb.ReportSign
/// Input：       Id : DHCMed.SusAb.ReportSign.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.SusAb.ReportSign).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.SusAbRepSign).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="SusAbRepSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RSSignDr</Value>
</Value>
<Value name="3">
<Value>RSExtraText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSign")</DataLocation>
<DefaultData>SusAbRepSignDefaultData</DefaultData>
<IdLocation>^DHCMed.FBD.SusAbRepC("ChildSign")</IdLocation>
<IndexLocation>^DHCMed.FBD.SusAbRepI("RSI")</IndexLocation>
<StreamLocation>^DHCMed.FBD.SusAbRepSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
