/// 名称:	EMR.DB.EMRCASignLog
/// 描述:	数字签名日志
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.EMRSignLog Extends %Persistent
{

Index IdxEMRSignID On EMRSignID;

Index IdxDocument On DocumentID;

/// 数字签名ID
Property EMRSignID As EMR.DB.EMRSign;

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 签名单元
Property Code As %String(TRUNCATE = 1);

/// 签名单元编码
Property ElementCode As %String(TRUNCATE = 1);

/// 病历ID
Property DocumentID As EMR.DB.DocumentData;

/// 病历顺序号
Property ListNo As %String(TRUNCATE = 1);

/// 签名用户ID
Property UsrID As User.SSUser;

/// 签名用户登录科室
Property UsrLoginLocID As User.CTLoc;

/// 签名状态（CF.EMR.DOC.SignRole）
Property Action As %String(TRUNCATE = 1);

/// 签名类型(CA CA签、SYS 系统签、AnySign 患者签)
Property Type As %String;

/// 签名日期
Property SignDate As %Date;

/// 签名时间
Property SignTime As %Time;

/// 数字签名有效
Property isValid As %Boolean;

/// CA签名ID(医护指向 CA.DigitalSignature，患者 EMR.DB.PatientSign)
Property SignID As %String;

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 1);

Storage Default
{
<Data name="EMRSignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRSignID</Value>
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
<Value>Code</Value>
</Value>
<Value name="7">
<Value>ElementCode</Value>
</Value>
<Value name="8">
<Value>DocumentID</Value>
</Value>
<Value name="9">
<Value>ListNo</Value>
</Value>
<Value name="10">
<Value>UsrID</Value>
</Value>
<Value name="11">
<Value>UsrLoginLocID</Value>
</Value>
<Value name="12">
<Value>Action</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
<Value name="14">
<Value>SignDate</Value>
</Value>
<Value name="15">
<Value>SignTime</Value>
</Value>
<Value name="16">
<Value>isValid</Value>
</Value>
<Value name="17">
<Value>SignID</Value>
</Value>
<Value name="18">
<Value>Digest</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.EMRSignLogD</DataLocation>
<DefaultData>EMRSignLogDefaultData</DefaultData>
<IdLocation>^EMR.DB.EMRSignLogD</IdLocation>
<IndexLocation>^EMR.DB.EMRSignLogI</IndexLocation>
<StreamLocation>^EMR.DB.EMRSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
