Class EMRservice.entity.EInstanceData Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String;

/// 病历创建日期
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRInstanceStream($J)");

/// 实例数据-是模板元数据定义的实例，与InstanceData对应
Property InstanceMetaData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRInstanceStream($J)");

Property InstanceScriptData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRInstanceStream($J)");

Property InstanceMedia As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRInstanceStream($J)");

Property InstanceInitialData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRInstanceStream($J)");

Property ListNo As %String(TRUNCATE = 1);

/// 病历修改日期
Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property Title As %String(TRUNCATE = 1);

/// 历次病程记录备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

Property TitleCode As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

/// 备注
Property Memo As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 起始页
Property StartPageNum As %Integer;

/// 起始行
Property StartRowNum As %Integer;

/// 结束页
Property EndPageNum As %Integer;

/// 结束行
Property EndRowNum As %Integer;

/// 是否加密
Property IsEncrypt As %Integer;

}
