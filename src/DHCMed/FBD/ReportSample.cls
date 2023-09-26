/// 名称 : DHCMed.FBD.ReportSample
/// 描述 : 生物样本采集
Class DHCMed.FBD.ReportSample Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.FBD.Report [ Cardinality = parent, Inverse = ChildSample ];

/// 样本编号
Property RSNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 样本类型("FBDSampleType")   粪便/肛拭子/血液/脑脊液/其他
Property RSType As DHCMed.SS.Dictionary;

/// 样本数量
Property RSNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位("FBDSampleUnit")    g/mL/份
Property RSUnit As DHCMed.SS.Dictionary;

/// 采样日期
Property RSDate As %Date;

/// 备注
Property RSResume As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取生物样本采集
/// Table：       DHCMed.FBD.ReportSample
/// Input：       Id : DHCMed.FBD.ReportSample.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.ReportSample).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.ReportSample
{
	New (aID)
	Quit:'##class(DHCMed.FBD.ReportSample).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.ReportSample).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新生物样本采集
/// Table：       DHCMed.FBD.ReportSample
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportSample).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set No=$p(aInputStr,aSeparate,3)
	Set TypeID=$p(aInputStr,aSeparate,4)
	Set Number=+$p(aInputStr,aSeparate,5)
	Set UnitID=$p(aInputStr,aSeparate,6)
	Set Date=$p(aInputStr,aSeparate,7)
	Set Resume=$p(aInputStr,aSeparate,8)
	Quit:(Parref="")||(No="")||(TypeID="")||(UnitID="")||(Date="") return
	
	Set objParref=##class(DHCMed.FBD.Report).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCMed.SS.Dictionary).GetObjById(TypeID)
	Quit:'$IsObject(objType) return
	Set objUnit=##class(DHCMed.SS.Dictionary).GetObjById(UnitID)
	Quit:'$IsObject(objUnit) return
	
	;Set:Date["-" Date=$zdh(Date,3)
	;Set:Date["/" Date=$zdh(Date,4)
	;Set Date=+Date
	Set:Date'="" Date=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Date)
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.FBD.ReportSample).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.ReportSample).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.RSNo=No
	Set obj.RSType=objType
	Set obj.RSNumber=Number
	Set obj.RSUnit=objUnit
	Set obj.RSDate=Date
	Set obj.RSResume=Resume
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
/// Description:  删除生物样本采集
/// Table：       DHCMed.FBD.ReportSample
/// Input：       Id : DHCMed.FBD.ReportSample.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportSample).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.ReportSample).%DeleteId(aID)
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
<Value>RSNo</Value>
</Value>
<Value name="3">
<Value>RSType</Value>
</Value>
<Value name="4">
<Value>RSNumber</Value>
</Value>
<Value name="5">
<Value>RSUnit</Value>
</Value>
<Value name="6">
<Value>RSDate</Value>
</Value>
<Value name="7">
<Value>RSResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SA")</IdLocation>
<IndexLocation>^DHCMed.FBD.ReportI("RSA")</IndexLocation>
<StreamLocation>^DHCMed.FBD.ReportSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
