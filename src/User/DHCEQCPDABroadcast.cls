Class User.DHCEQCPDABroadcast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PB_RowID, SqlTableName = DHC_EQCPDABroadcast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PB_BroadcastType
Property PBBroadcastType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PB_BroadcastType ];

/// PB_Name
Property PBName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PB_Name ];

/// PB_Key
Property PBKey As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PB_Key ];

/// PB_Brand
Property PBBrand As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PB_Brand ];

/// PB_Model
Property PBModel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PB_Model ];

/// PB_FixedSetting
Property PBFixedSetting As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PB_FixedSetting ];

/// PB_Remark
Property MSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PB_Remark ];

/// PB_Activity
Property PBActivity As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PB_Activity ];

/// PB_Invalid
Property PBInvalid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PB_Invalid ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCPDABroadcast",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PB_Activity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PB_Brand">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PB_BroadcastType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PB_FixedSetting">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PB_Invalid">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PB_Key">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PB_Model">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PB_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCPDABroadcast"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCPDABroadcast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BroadcastType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PB_BroadcastType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCPDABroadcastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
