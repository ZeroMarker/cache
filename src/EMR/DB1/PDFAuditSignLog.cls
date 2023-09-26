/// 名称:	EMR.DB.PDFAuditSignLog
/// 描述:	患者PDF签日志
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB1.PDFAuditSignLog Extends %Persistent
{

Index IdxUniqueDocID On UniqueDocID;

Index IdxBusiness On (UniqueDocID, IsValid);

Index IdxInstance On (EpisodeID, DocumentID, IsValid);

/// 就诊号
Property EpisodeID As User.PAAdm [ SqlColumnNumber = 2 ];

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 签名单元
Property Code As %String(TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 病历ID
Property DocumentID As EMR.DB1.DocumentData [ SqlColumnNumber = 6 ];

/// 病历顺序号
Property ListNo As %String [ SqlColumnNumber = 7 ];

/// 签名用户ID
Property UsrID As User.SSUser [ SqlColumnNumber = 8 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 9 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 10 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 11 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 12 ];

/// 数字签名有效
Property IsValid As %Boolean [ SqlColumnNumber = 13 ];

/// 文档编号
Property UniqueDocID As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// 业务编号
Property BusinessNo As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// 签名关键字“[患者签名]”
Property KeyWord As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// 患者推送签名表ID CA.DigitalSignPatPush.ID
Property PatPushSignID As %String(TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// CA端业务编号GUID
Property CABusinessGUID As %String(TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// PDF的文件名
Property FileName As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// PDF在FTP上全路径
Property FilePath As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// 签名类型：患者签名——patsigned 机构签章orgsealed
Property Action As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",patsigned,PATSIGNED,orgsealed,ORGSEALED") [ SqlColumnNumber = 21 ];

/// 签名状态，TOSIGN 待签，SIGNED 已签名
Property SignStatus As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",TOSIGN,SIGNED,CANCEL,PUSHED,EXPIRE") [ SqlColumnNumber = 22 ];

/// 存储类型：FTP——ftp 数据库存储Base64—-db
/// 	混合：hybrid传输使用FTP中转，db存储签后PDF Base64
Property StoreType As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",db,DB,ftp,FTP,hybrid,HYBRID") [ SqlColumnNumber = 23 ];

/// 企业签章后的PDF Base64字符串，解码后即为PDF的二进制文件
Property PDFBase64 As %GlobalCharacterStream(LOCATION = "^EMR.DB1.PDFAuditSignLogS") [ SqlColumnNumber = 24 ];

/// 待签名的PDF Base64字符串，解码后即为PDF的二进制文件
Property OriginalPDFBase64 As %GlobalCharacterStream(LOCATION = "^EMR.DB1.PDFAuditSignLogS") [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="PDFAuditSignLogDefaultData">
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
<Value>DocumentID</Value>
</Value>
<Value name="7">
<Value>ListNo</Value>
</Value>
<Value name="8">
<Value>UsrID</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>IsValid</Value>
</Value>
<Value name="14">
<Value>UniqueDocID</Value>
</Value>
<Value name="15">
<Value>BusinessNo</Value>
</Value>
<Value name="16">
<Value>KeyWord</Value>
</Value>
<Value name="17">
<Value>PatPushSignID</Value>
</Value>
<Value name="18">
<Value>CABusinessGUID</Value>
</Value>
<Value name="19">
<Value>FileName</Value>
</Value>
<Value name="20">
<Value>FilePath</Value>
</Value>
<Value name="21">
<Value>Action</Value>
</Value>
<Value name="22">
<Value>SignStatus</Value>
</Value>
<Value name="23">
<Value>StoreType</Value>
</Value>
<Value name="24">
<Value>PDFBase64</Value>
</Value>
<Value name="25">
<Value>OriginalPDFBase64</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.PDFAuditSignLogD</DataLocation>
<DefaultData>PDFAuditSignLogDefaultData</DefaultData>
<IdLocation>^EMR.DB1.PDFAuditSignLogD</IdLocation>
<IndexLocation>^EMR.DB1.PDFAuditSignLogI</IndexLocation>
<StreamLocation>^EMR.DB1.PDFAuditSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
