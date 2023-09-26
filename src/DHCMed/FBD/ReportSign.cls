/// 名称 : DHCMed.FBD.ReportSign
/// 描述 : 主要症状与体征
Class DHCMed.FBD.ReportSign Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.FBD.Report [ Cardinality = parent, Inverse = ChildSign ];

/// 主要症状与体征
Property RSSignDr As DHCMed.FBD.SignDic;

/// 附加项值 呕吐次数、体温数值、其他附加内容
Property RSExtraText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 以主要症状与体征为索引
Index IndexSign On RSSignDr;

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取主要症状与体征
/// Table：       DHCMed.FBD.ReportSign
/// Input：       Id : DHCMed.FBD.ReportSign.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.ReportSign).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.ReportSign
{
	New (aID)
	Quit:'##class(DHCMed.FBD.ReportSign).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.ReportSign).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新主要症状与体征
/// Table：       DHCMed.FBD.ReportSign
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportSign).Update("","")
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
	
	Set objParref=##class(DHCMed.FBD.Report).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set objSign=##class(DHCMed.FBD.SignDic).GetObjById(SignDr)
	Quit:'$IsObject(objSign) return
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.FBD.ReportSign).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.ReportSign).%OpenId(Parref_"||"_ChildSub)
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
/// Table：       DHCMed.FBD.ReportSign
/// Input：       Id : DHCMed.FBD.ReportSign.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportSign).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.ReportSign).%DeleteId(aID)
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
<Data name="DefaultData">
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
<DataLocation>{%%PARENT}("SI")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SI")</IdLocation>
<IndexLocation>^DHCMed.FBD.ReportI("RSI")</IndexLocation>
<StreamLocation>^DHCMed.FBD.ReportSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
