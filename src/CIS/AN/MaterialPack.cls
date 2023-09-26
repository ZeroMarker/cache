/// 手术包登记
Class CIS.AN.MaterialPack Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MaterialPack ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 手术包
Property MaterialPackId As CT.AN.SurgicalKit [ SqlColumnNumber = 3 ];

/// 手术包数量
Property MaterialNumber As %String [ SqlColumnNumber = 4 ];

/// 手术麻醉记录表单索引
Index IMPack On RecordSheet;

Storage Default
{
<Data name="MaterialPackDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>MaterialPackId</Value>
</Value>
<Value name="3">
<Value>MaterialNumber</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.MaterialPackD</DataLocation>
<DefaultData>MaterialPackDefaultData</DefaultData>
<IdLocation>^CIS.AN.MaterialPackD</IdLocation>
<IndexLocation>^CIS.AN.MaterialPackI</IndexLocation>
<StreamLocation>^CIS.AN.MaterialPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
