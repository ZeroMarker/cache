/// 名称:	EMR.GB.AuthRequestEpisode
/// 描述:	申请授权就诊表
/// 编写者：yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class EMR.GB.AuthRequestEpisode Extends %Persistent
{

Index IdxEpisode On EpisodeID;

Index IdxReqEpisode On (AuthRequest, EpisodeID);

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 授权申请表
Property AuthRequest As EMR.GB.AuthRequest;

Storage Default
{
<Data name="AuthRequestEpisodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>AuthRequest</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.AuthRequestEpisodeD</DataLocation>
<DefaultData>AuthRequestEpisodeDefaultData</DefaultData>
<IdLocation>^EMR.GB.AuthRequestEpisodeD</IdLocation>
<IndexLocation>^EMR.GB.AuthRequestEpisodeI</IndexLocation>
<StreamLocation>^EMR.GB.AuthRequestEpisodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
