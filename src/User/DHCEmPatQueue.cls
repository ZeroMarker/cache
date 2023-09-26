/// 分诊队列表
/// yangyongtao
/// 2021-03-19
/// d ##class(User.DHCEmPatQueue).%BuildIndices()
Class User.DHCEmPatQueue Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmPatQueue ]
{

/// 代码 PQ_Code
Property PQCode As %String [ SqlColumnNumber = 2, SqlFieldName = PQ_Code ];

/// 描述 PQ_Desc
Property PQDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PQ_Desc ];

/// 级别 PQ_Level  User.CTAcuity
Property PQLevel As User.CTAcuity [ SqlColumnNumber = 4, SqlFieldName = PQ_Level ];

/// 自定义码 PQ_SeqNo
Property PQSeqNo As %String [ SqlColumnNumber = 5, SqlFieldName = PQ_SeqNo ];

/// 是否可用 PQ_ActiveFlag
Property PQActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PQ_ActiveFlag ];

/// 集团化医院 PQ_Hosp_Dr
Property PQHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = PQ_Hosp_Dr ];

/// 默认 PQ_DefLevel_Dr
Property PQDefLevelDr As User.CTAcuity [ SqlColumnNumber = 8, SqlFieldName = PQ_DefLevel_Dr ];

/// 是否默认进抢救 PQ_SalvageFlag
Property PQSalvageFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PQ_SalvageFlag ];

/// PQCode索引
Index IndexCode On PQCode As AlphaUp;

/// PQLevel索引
Index IndexLevel On (PQLevel As AlphaUp, PQDefLevelDr As AlphaUp);

Storage Default
{
<Data name="DHCEmPatQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PQCode</Value>
</Value>
<Value name="3">
<Value>PQDesc</Value>
</Value>
<Value name="4">
<Value>PQLevel</Value>
</Value>
<Value name="5">
<Value>PQSeqNo</Value>
</Value>
<Value name="6">
<Value>PQActiveFlag</Value>
</Value>
<Value name="7">
<Value>PQHospDr</Value>
</Value>
<Value name="8">
<Value>PQDefLevelDr</Value>
</Value>
<Value name="9">
<Value>PQSalvageFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatQueueD</DataLocation>
<DefaultData>DHCEmPatQueueDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatQueueD</IdLocation>
<IndexLocation>^User.DHCEmPatQueueI</IndexLocation>
<StreamLocation>^User.DHCEmPatQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
