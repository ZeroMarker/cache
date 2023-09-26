/// Function:私有数据关联医院
/// Creator: sunfengchao
/// CreateDate:2018-4-13
Class User.BDPMappingHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_MappingHosp ]
{

/// 表名称
Property BDPMPHTableName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = BDPMPH_TableName ];

/// 对应表数据RowID
Property BDPMPHDataReference As %String(MAXLEN = "") [ Required, SqlColumnNumber = 3, SqlFieldName = BDPMPH_DataReference ];

/// 关联的医院
Property BDPMPHHospital As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = BDPMPH_Hospital ];

Index DataRef On (BDPMPHTableName As Exact, BDPMPHHospital As Exact, BDPMPHDataReference As Exact);

Index HospRef On (BDPMPHTableName As Exact, BDPMPHDataReference As Exact, BDPMPHHospital As Exact);

Index TableRef On BDPMPHTableName As Exact;

Index TableHospRef On (BDPMPHTableName As Exact, BDPMPHHospital As Exact);

Storage Default
{
<Data name="BDPMappingHospDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPMPHTableName</Value>
</Value>
<Value name="3">
<Value>BDPMPHDataReference</Value>
</Value>
<Value name="4">
<Value>BDPMPHHospital</Value>
</Value>
</Data>
<DataLocation>^User.BDPMappingHospD</DataLocation>
<DefaultData>BDPMappingHospDefaultData</DefaultData>
<IdLocation>^User.BDPMappingHospD</IdLocation>
<IndexLocation>^User.BDPMappingHospI</IndexLocation>
<StreamLocation>^User.BDPMappingHospS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
