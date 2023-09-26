Class EMRinstance.AnySignLog Extends %Persistent
{

/// d ##class(EMRinstance.AnySignLog).%BuildIndices()
Index IdxInsID On InsID;

/// 签名是否有效 0/1
Property IsValid As %Boolean;

/// 病历实例ID
Property InsID As %String(TRUNCATE = 1);

/// 签名日期
Property CreateDate As %Date;

/// 签名时间
Property CreateTime As %Time;

/// 修改日期，目前与签名日期一致
Property UpdateDate As %Date;

/// 修改时间，目前与签名时间一致
Property UpdateTime As %Time;

/// 第三方数据: CA的签名算法
Property Algorithm As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 第三方数据：生物特征值(指纹图计算得出)
Property BioFeature As %GlobalCharacterStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 第三方数据：事件证书
Property EventCert As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 第三方数据：签名结果
Property SigValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 第三方数据：时间戳值
Property TSValue As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 第三方数据：CA版本
Property Version As %String(TRUNCATE = 1);

/// 第三方数据：笔迹图
Property SignScript As %GlobalCharacterStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 第三方数据：摄像头拍照
Property HeaderImage As %GlobalCharacterStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 第三方数据：指纹图
Property FingerPrint As %GlobalCharacterStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 签名时传给CA的待签数据，与摘要值一致
Property PlainText As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 第三方数据：部分CA返回的整个签名结果数据包
Property SignData As %GlobalCharacterStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 病历原文 病历xml
Property InstanceData As %GlobalBinaryStream(LOCATION = "^DHCEMRI.AnySignLogS");

/// 摘要值
Property Digest As %String(MAXLEN = 999999, TRUNCATE = 0);

/// 文档签名类型(cdaxml 签名域/compressxml 压缩整个原文签名/xml 非压缩整个原文签名/layoutxml 展现部分签名)
Property DocSignType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AnySignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsValid</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>DocUserID</Value>
</Value>
<Value name="5">
<Value>PrintDocID</Value>
</Value>
<Value name="6">
<Value>EPRNum</Value>
</Value>
<Value name="7">
<Value>InsID</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Algorithm</Value>
</Value>
<Value name="10">
<Value>BioFeature</Value>
</Value>
<Value name="11">
<Value>EventCert</Value>
</Value>
<Value name="12">
<Value>SigValue</Value>
</Value>
<Value name="13">
<Value>TSValue</Value>
</Value>
<Value name="14">
<Value>Version</Value>
</Value>
<Value name="15">
<Value>SignUser</Value>
</Value>
<Value name="16">
<Value>SignTime</Value>
</Value>
<Value name="17">
<Value>SignScript</Value>
</Value>
<Value name="18">
<Value>FingerPrint</Value>
</Value>
<Value name="19">
<Value>PlainText</Value>
</Value>
<Value name="20">
<Value>CreateDate</Value>
</Value>
<Value name="21">
<Value>CreateTime</Value>
</Value>
<Value name="22">
<Value>UpdateDate</Value>
</Value>
<Value name="23">
<Value>UpdateTime</Value>
</Value>
<Value name="24">
<Value>HeaderImage</Value>
</Value>
<Value name="25">
<Value>SignData</Value>
</Value>
<Value name="26">
<Value>InstanceData</Value>
</Value>
<Value name="27">
<Value>Digest</Value>
</Value>
<Value name="28">
<Value>DocSignType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AnySignLogD</DataLocation>
<DefaultData>AnySignLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AnySignLogD</IdLocation>
<IndexLocation>^DHCEMRI.AnySignLogI</IndexLocation>
<StreamLocation>^DHCEMRI.AnySignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
