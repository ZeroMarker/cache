/// 名称：User.DHCANCItmMaterLink
/// 描述：常用医嘱关联HIS医嘱项，事件选项关联HIS医嘱项，麻醉方法关联HIS医嘱项
/// 编写者：陈长青
/// 编写日期：2015年3月13日
Class User.DHCANCItmMaterLink Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = ANCIM_RowId, SqlTableName = DHC_ANC_ItmMasterLink, StorageStrategy = CacheStorage ]
{

Property ANCIMARCIMDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCIM_ARCIM_Dr ];

Property ANCIMARCOSDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCIM_ARCOS_Dr ];

Property ANCIMComOrdDr As DHCANCCommonOrd [ SqlColumnNumber = 4, SqlFieldName = ANCIM_ComOrd_Dr ];

Property ANCIMAnaMethodDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANCIM_AnaMethod_Dr ];

Property ANCIMEventDetailCode As %String [ SqlColumnNumber = 6, SqlFieldName = ANCIM_EventDetailCode ];

Property ANCIMEventDetailValue As %String [ SqlColumnNumber = 7, SqlFieldName = ANCIM_EventDetailValue ];

Property ANCIMAvailable As %String [ SqlColumnNumber = 8, SqlFieldName = ANCIM_Available ];

Property ANCIMDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = ANCIM_DateFrom ];

Property ANCIMDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = ANCIM_DateTo ];

Storage CacheStorage
{
<Data name="DataMaster">
<Value name="1">
<Value>ANCIMARCIMDr</Value>
</Value>
<Value name="2">
<Value>ANCIMARCOSDr</Value>
</Value>
<Value name="3">
<Value>ANCIMComOrdDr</Value>
</Value>
<Value name="4">
<Value>ANCIMAnaMethodDr</Value>
</Value>
<Value name="5">
<Value>ANCIMEventDetailCode</Value>
</Value>
<Value name="6">
<Value>ANCIMEventDetailValue</Value>
</Value>
<Value name="7">
<Value>ANCIMAvailable</Value>
</Value>
<Value name="8">
<Value>ANCIMDateFrom</Value>
</Value>
<Value name="9">
<Value>ANCIMDateTo</Value>
</Value>
<Value name="10">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCANC("IMLink")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("IMLink")</IdLocation>
<IndexLocation>^DHCANC("IMLink",0)</IndexLocation>
<SqlRowIdName>ANCIM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCANCItmMasterLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
