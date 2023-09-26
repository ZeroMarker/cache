/// 名称:	EMR.DB1.EMRSign
/// 描述:	签名表(CA、系统签)
/// 编写者：yejian
/// 编写日期: 2022-8-5
/// 产品组：电子病历产品组
Class EMR.DB1.EMRSign Extends %Persistent
{

Index IdxDocument On DocumentID;

Index IdxUnique On (EpisodeID, DOCCode, ListNo, Code, Action) [ Unique ];

Index IdxMain On (EpisodeID, DOCCode, ListNo, Action);

Index IdxLast On (EpisodeID, DOCCode, ListNo, SignDate, SignTime);

Index IdxAction On (Action, SignDate, SignTime, DOCCode);

Index IdxCode On (DocumentID, ListNo, Code);

Index IdxElementCode On (DocumentID, ListNo, ElementCode);

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 签名路径
Property Code As %String(TRUNCATE = 1);

/// 签名单元编码
Property ElementCode As %String(TRUNCATE = 1);

/// 病历顺序号
Property ListNo As %String(TRUNCATE = 1);

/// 病历ID, 
Property DocumentID As EMR.DB1.DocumentData;

/// 签名用户ID
Property UsrID As User.SSUser;

/// 签名用户登录科室
Property UsrLoginLocID As User.CTLoc;

/// 签名状态（CF.EMR.DOC.SignRole）
Property Action As %String(TRUNCATE = 1);

/// 签名类型(CA or SYS)
Property Type As %String;

/// 签名日期
Property SignDate As %Date;

/// 签名时间
Property SignTime As %Time;

/// CA签名ID(医护指向 CA.DigitalSignature，患者 EMR.DB.PatientSign)
Property SignID As %String;

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 数字签名有效
Property isValid As %Boolean;

Storage Default
{
<Data name="EMRSignDefaultData">
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
<Value>Code</Value>
</Value>
<Value name="6">
<Value>ElementCode</Value>
</Value>
<Value name="7">
<Value>ListNo</Value>
</Value>
<Value name="8">
<Value>DocumentID</Value>
</Value>
<Value name="9">
<Value>UsrID</Value>
</Value>
<Value name="10">
<Value>UsrLoginLocID</Value>
</Value>
<Value name="11">
<Value>Action</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>SignDate</Value>
</Value>
<Value name="14">
<Value>SignTime</Value>
</Value>
<Value name="15">
<Value>SignID</Value>
</Value>
<Value name="16">
<Value>Digest</Value>
</Value>
<Value name="17">
<Value>isValid</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.EMRSignD</DataLocation>
<DefaultData>EMRSignDefaultData</DefaultData>
<IdLocation>^EMR.DB1.EMRSignD</IdLocation>
<IndexLocation>^EMR.DB1.EMRSignI</IndexLocation>
<StreamLocation>^EMR.DB1.EMRSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
