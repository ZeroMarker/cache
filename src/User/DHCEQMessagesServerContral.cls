Class User.DHCEQMessagesServerContral Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MSC_RowID, SqlTableName = DHC_EQMessagesServerContral, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MSC_BussType
Property MSCBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MSC_BussType ];

/// MSC_EquipTypeIDs
Property MSCEquipTypeIDs As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MSC_EquipTypeIDs ];

/// MSC_HospitalID
Property MSCHospitalID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MSC_HospitalID ];

/// MSC_ActionDR
Property MSCActionDR As User.DHCEQCAction [ SqlColumnNumber = 5, SqlFieldName = MSC_ActionDR ];

/// MSC_Length
Property MSCLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MSC_Length ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessagesServerContral("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MSC_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MSC_BussType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MSC_EquipTypeIDs">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MSC_HospitalID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MSC_Length">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMessagesServerContral</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MSC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MSC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAction">
<Global>^DHCEQMessagesServerContral</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MSC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Action"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MSC_ActionDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessagesServerContralS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
