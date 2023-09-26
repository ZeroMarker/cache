/// 无菌包
Class CIS.AN.SterilityPack Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SterilityPack ]
{

/// 手术清点
Property RecordSheet As CIS.AN.RecordSheet [ SqlColumnNumber = 2 ];

/// 无菌包名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 无菌包条号
Property BarCode As %String [ SqlColumnNumber = 4 ];

/// 消毒日期
Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

/// 消毒时间
Property ActiveTime As %Time [ SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 失效时间
Property ExpireTime As %Time [ SqlColumnNumber = 8 ];

/// 无菌包检查用户ID
Property CheckUserID As %String [ SqlColumnNumber = 9 ];

/// 无菌包检查日期
Property CheckDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 无菌包检查时间
Property CheckTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11 ];

/// 包装者
Property PackProv As %String [ SqlColumnNumber = 12 ];

/// 消毒员
Property Disinfectioner As %String [ SqlColumnNumber = 13 ];

/// 灭菌器
Property Sterilizer As %String [ SqlColumnNumber = 14 ];

/// 批次号
Property BatchNo As %String [ SqlColumnNumber = 15 ];

/// 消毒包卡片照片
Property CardImage As %GlobalCharacterStream(LOCATION = "^CIS.AN.SterilityPackS") [ SqlColumnNumber = 16 ];

/// 手术麻醉记录表单索引
Index IRecordSheet On RecordSheet;

/// 条码号索引
Index IBarCode On BarCode;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SterilityPackDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>BarCode</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ActiveTime</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>ExpireTime</Value>
</Value>
<Value name="8">
<Value>CheckUserID</Value>
</Value>
<Value name="9">
<Value>CheckDate</Value>
</Value>
<Value name="10">
<Value>CheckTime</Value>
</Value>
<Value name="11">
<Value>PackProv</Value>
</Value>
<Value name="12">
<Value>Disinfectioner</Value>
</Value>
<Value name="13">
<Value>Sterilizer</Value>
</Value>
<Value name="14">
<Value>BatchNo</Value>
</Value>
<Value name="15">
<Value>CardImage</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SterilityPackD</DataLocation>
<DefaultData>SterilityPackDefaultData</DefaultData>
<IdLocation>^CIS.AN.SterilityPackD</IdLocation>
<IndexLocation>^CIS.AN.SterilityPackI</IndexLocation>
<StreamLocation>^CIS.AN.SterilityPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
