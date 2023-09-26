/// 名称:	EMR.GB.Lock
/// 描述:	病历锁
/// 编写者：yejian
/// 编写日期: 2023-5-5
/// 产品组：电子病历产品组
Class EMR.GB.Lock Extends %Persistent
{

Index IdxMain On DocumentID [ Unique ];

Index IdxUserLock On (UserID, EpisodeID, DOCCode);

Index IdxDocEpisodeID On (DOCCode, EpisodeID);

Index IdxSessionID On SessionID;

Index IdxEpisodeID On EpisodeID;

Index IdxUserID On UserID;

/// 实例ID
Property DocumentID As %Integer;

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template;

/// 锁定日期
Property LockDate As %Date;

/// 锁定日间
Property LockTime As %Time;

/// 用户ID
Property UserID As User.SSUser;

/// 用户科室ID
Property UserLocID As User.CTLoc;

/// 计算机IP
Property ComputerIP As %String;

/// 计算机名ComputerName
Property ComputerName As %String;

/// session(关闭浏览器)
Property SessionID As %String;

/// 项目标识（OP 门诊，IP 住院）
Property Product As %String;

Storage Default
{
<Data name="LockDefaultData">
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
<Value>DOCCategoryCode</Value>
</Value>
<Value name="5">
<Value>DOCCode</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>LockDate</Value>
</Value>
<Value name="8">
<Value>LockTime</Value>
</Value>
<Value name="9">
<Value>UserID</Value>
</Value>
<Value name="10">
<Value>UserLocID</Value>
</Value>
<Value name="11">
<Value>ComputerIP</Value>
</Value>
<Value name="12">
<Value>ComputerName</Value>
</Value>
<Value name="13">
<Value>SessionID</Value>
</Value>
<Value name="14">
<Value>Product</Value>
</Value>
<Value name="15">
<Value>DocumentID</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.LockD</DataLocation>
<DefaultData>LockDefaultData</DefaultData>
<IdLocation>^EMR.GB.LockD</IdLocation>
<IndexLocation>^EMR.GB.LockI</IndexLocation>
<StreamLocation>^EMR.GB.LockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
