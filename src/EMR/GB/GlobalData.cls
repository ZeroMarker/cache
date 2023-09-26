/// 名称:	EMR.GB.GlobalData
/// 描述:	全局图表记录
/// 编写者：yejian
/// 编写日期: 2022-7-20
/// 产品组：电子病历产品组
Class EMR.GB.GlobalData Extends %Persistent
{

Index IdxMain On (EpisodeID, DOCCategoryCode, ListNo) [ Unique ];

Index IdxEpisodeIDBDMCCode On (EpisodeID, DOCCategoryCode, DOCCode, ListNo);

/// 就诊号
Property EpisodeID As User.PAAdm [ Required ];

/// 业务活动分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0) [ Required ];

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0) [ Required ];

/// 版本
Property ListNo As %Integer [ Required ];

/// 分片数据节点ID，冗余数据
Property NodeID As %String;

Storage Default
{
<Data name="GlobalDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DOCCategoryCode</Value>
</Value>
<Value name="4">
<Value>DOCCode</Value>
</Value>
<Value name="5">
<Value>ListNo</Value>
</Value>
<Value name="6">
<Value>NodeID</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.GlobalDataD</DataLocation>
<DefaultData>GlobalDataDefaultData</DefaultData>
<IdLocation>^EMR.GB.GlobalDataD</IdLocation>
<IndexLocation>^EMR.GB.GlobalDataI</IndexLocation>
<StreamLocation>^EMR.GB.GlobalDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
