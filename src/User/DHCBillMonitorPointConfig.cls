Class User.DHCBillMonitorPointConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = MPC_RowID, SqlTableName = DHC_BillMonitorPointConfig, StorageStrategy = SQLStorage ]
{

Relationship ChildCheckData As User.DHCBillCheckData [ Cardinality = children, Inverse = CDParRef ];

/// 监控点代码
Property MPCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MPC_Code ];

/// 监控点描述
Property MPCDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = MPC_Desc ];

/// 监控点说明
Property MPCExplain As %String(MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MPC_Explain ];

Property MPCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MPC_ActiveFlag ];

/// Inherent:固有, Custom:自定义
Property MPCType As %String(DISPLAYLIST = ",Inherent,Custom", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,C") [ SqlColumnNumber = 6, SqlFieldName = MPC_Type ];

Property MPCHospDR As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = MPC_Hosp_DR ];

/// 能否审核标识 2022-04-28 ZhYW
Property MPCReviewedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MPC_ReviewedFlag ];

Index MPCHospCodeUnqIdx On (MPCHospDR, MPCCode) [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMPConfig)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MPC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MPC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MPC_Explain">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MPC_ReviewedFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MPC_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMPConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MPC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMPConfigi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MPC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MPC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillMonitorPointConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
