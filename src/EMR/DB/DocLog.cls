/// 名称:	EMR.DB.DocLog
/// 描述:	门诊病历-存储病历操作日志和状态
/// 编写者：yejian
/// 编写日期: 2021-7-15
/// 产品组：电子病历产品组
Class EMR.DB.DocLog Extends %Persistent
{

Index IdxDoc On DocumentData;

Index IdxEpisodeIDDoc On (EpisodeID, DocumentData);

Index IdxDocActionDateTime On (DocumentData, Action, OperateDate, OperateTime);

Index IdxDocFinalStatusDateTime On (DocumentData, FinalStatus, OperateDate, OperateTime);

Index IdxEMRSignID On EMRSignID;

Index IdxActionDateTimeUserID On (Action, OperateDate, OperateTime, OperateUserID);

Index IdxOperUserDocDateTimeFinal On (OperateUserID, DocumentData, OperateDate, OperateTime, FinalStatus);

/// 实例ID
Property DocumentData As EMR.DB.DocumentData;

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 操作状态
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 最终操作状态
Property FinalStatus As CF.EMR.DOC.EMRStatus;

/// 初始状态
Property InitStatus As CF.EMR.DOC.EMRStatus;

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template;

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 操作者ID
Property OperateUserID As User.SSUser;

/// 操作用户
Property OperateUserName As %String(TRUNCATE = 1);

/// 登录用户ID
Property LoginUserID As User.SSUser;

/// 登录用户名
Property LoginUserName As %String(TRUNCATE = 1);

/// 登录科室
Property UserLoginLocID As %String(TRUNCATE = 1);

/// 签名日志
Property EMRSignID As %String(TRUNCATE = 1);

/// 产品模块
Property ProductSource As %String(TRUNCATE = 1);

/// EMRSignLog
Property EMRSignLogID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DocLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentData</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Action</Value>
</Value>
<Value name="5">
<Value>OperateDate</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>FinalStatus</Value>
</Value>
<Value name="8">
<Value>InitStatus</Value>
</Value>
<Value name="9">
<Value>TemplateID</Value>
</Value>
<Value name="10">
<Value>OperateMachineIP</Value>
</Value>
<Value name="11">
<Value>OperateUserID</Value>
</Value>
<Value name="12">
<Value>OperateUserName</Value>
</Value>
<Value name="13">
<Value>LoginUserID</Value>
</Value>
<Value name="14">
<Value>LoginUserName</Value>
</Value>
<Value name="15">
<Value>UserLoginLocID</Value>
</Value>
<Value name="16">
<Value>EMRSignID</Value>
</Value>
<Value name="17">
<Value>ProductSource</Value>
</Value>
<Value name="18">
<Value>EMRSignLogID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.DocLogD</DataLocation>
<DefaultData>DocLogDefaultData</DefaultData>
<IdLocation>^EMR.DB.DocLogD</IdLocation>
<IndexLocation>^EMR.DB.DocLogI</IndexLocation>
<StreamLocation>^EMR.DB.DocLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
