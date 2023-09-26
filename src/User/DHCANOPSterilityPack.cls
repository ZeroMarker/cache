/// 手术无菌包
Class User.DHCANOPSterilityPack Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SP_RowId, SqlTableName = DHC_AN_OPSterilityPack, StorageStrategy = CacheStorage ]
{

/// 无菌包关联的手术申请ID
Property SPOPADR As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = SP_OPA_DR ];

/// 无菌包条码号
Property SPNo As %String [ SqlColumnNumber = 3, SqlFieldName = SP_No ];

/// 无菌包名称
Property SPDesc As %String [ SqlColumnNumber = 4, SqlFieldName = SP_Desc ];

/// 无菌包灭菌日期
Property SPSterilizingDate As %Date [ SqlColumnNumber = 5, SqlFieldName = SP_SterilizingDate ];

/// 无菌包灭菌时间
Property SPSterilizingTime As %Time [ SqlColumnNumber = 6, SqlFieldName = SP_SterilizingTime ];

/// 无菌包失效日期
Property SPExpiredDate As %Date [ SqlColumnNumber = 7, SqlFieldName = SP_ExpiredDate ];

/// 无菌包失效时间
Property SPExpiredTime As %Time [ SqlColumnNumber = 8, SqlFieldName = SP_ExpiredTime ];

/// 无菌包是否合格
Property SPQualified As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SP_Qualified ];

/// 无菌包扫描用户
Property SPScaningUserDR As %String [ SqlColumnNumber = 10, SqlFieldName = SP_ScaningUser_DR ];

/// 无菌包扫描日期
Property SPScaningDate As %Date [ SqlColumnNumber = 11, SqlFieldName = SP_ScaningDate ];

/// 无菌包扫描时间
Property SPScaningTime As %Time [ SqlColumnNumber = 12, SqlFieldName = SP_ScaningTime ];

Index OPA On SPOPADR;

Storage CacheStorage
{
<Data name="DHCANOPSterilityPackDefaultData">
<Value name="1">
<Value>SPOPADR</Value>
</Value>
<Value name="2">
<Value>SPDesc</Value>
</Value>
<Value name="3">
<Value>SPNo</Value>
</Value>
<Value name="4">
<Value>SPSterilizingDate</Value>
</Value>
<Value name="5">
<Value>SPSterilizingTime</Value>
</Value>
<Value name="6">
<Value>SPExpiredDate</Value>
</Value>
<Value name="7">
<Value>SPExpiredTime</Value>
</Value>
<Value name="8">
<Value>SPQualified</Value>
</Value>
<Value name="9">
<Value>SPScaningUserDR</Value>
</Value>
<Value name="10">
<Value>SPScaningDate</Value>
</Value>
<Value name="11">
<Value>SPScaningTime</Value>
</Value>
<Value name="12">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCANOPSterilityPack</DataLocation>
<DefaultData>DHCANOPSterilityPackDefaultData</DefaultData>
<IdLocation>^DHCANOPSterilityPack</IdLocation>
<IndexLocation>^DHCANOPSterilityPack(0)</IndexLocation>
<StreamLocation>^User.DHCANOPSterilityPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
