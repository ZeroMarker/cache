/// ************************************************************
/// * Class Name:	EPRinstance.Quality.QualitySpotCheck
/// * Description:	Just for manual spot check
/// * Author:		Zuoxiang Xie
/// * Create Date:	2011-01-14
/// * Version:		
/// ************************************************************/
Class EPRinstance.Quality.QualitySpotCheck Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeID On EpisodeID [ Unique ];

Index IdxAdmitDate On AdmitDate;

Relationship Details As EPRinstance.Quality.QualitySpotCheckDetail [ Cardinality = children, Inverse = TheSpotCheck ];

Property EpisodeID As %String(TRUNCATE = 1);

Property AdmitDate As %Date;

/// 终末质控标志
Property IsActive As %String;

/// 环节质控标志(多次)
Property IsAdmActive As %String;

/// 门诊质控标志
Property IsOutActive As %String;

/// 环节质控缺陷标志  0无缺陷  1有缺陷未修正  2有缺陷全部修正
Property IsMessageActive As %String;

/// 首页质控标志  Y质控  P通过
Property IsBSYActive As %String;

/// 科室首页质控标志  Y质控  P通过
Property IsSYActive As %String;

/// 交叉质控标志 CQC终末交叉质控 IA 环节交叉质控 AO 门诊交叉质控
Property IsCrossActive As %String;

Property ResumeText As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0);

Storage Default
{
<Data name="QualitySpotCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>AdmitDate</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>IsAdmActive</Value>
</Value>
<Value name="10">
<Value>CreateAdmUser</Value>
</Value>
<Value name="11">
<Value>AdmUserGroupID</Value>
</Value>
<Value name="12">
<Value>CreateOutUser</Value>
</Value>
<Value name="13">
<Value>IsOutActive</Value>
</Value>
<Value name="14">
<Value>IsMessageActive</Value>
</Value>
<Value name="15">
<Value>IsBSYActive</Value>
</Value>
<Value name="16">
<Value>IsSYActive</Value>
</Value>
<Value name="17">
<Value>IsCrossActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualitySpotCheckD</DataLocation>
<DefaultData>QualitySpotCheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualitySpotCheckD</IdLocation>
<IndexLocation>^DHCEPRQ.QualitySpotCheckI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualitySpotCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
