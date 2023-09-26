Class User.DHCEQMaintPlanItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPI_RowID, SqlTableName = DHC_EQMaintPlanItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MPI_MaintPlanDR
Property MPIMaintPlanDR As User.DHCEQMaintPlan [ SqlColumnNumber = 2, SqlFieldName = MPI_MaintPlanDR ];

/// MPI_MaintPartDR
Property MPIMaintPartDR As User.DHCEQCPart [ SqlColumnNumber = 3, SqlFieldName = MPI_MaintPartDR ];

/// MPI_MaintItemDR
Property MPIMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 4, SqlFieldName = MPI_MaintItemDR ];

/// MPI_MaintUserDR
Property MPIMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MPI_MaintUserDR ];

/// MPI_Remark
Property MPIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MPI_Remark ];

/// MPI_Hold1
Property MPIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MPI_Hold1 ];

/// MPI_Hold2
Property MPIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MPI_Hold2 ];

/// MPI_Hold3
Property MPIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MPI_Hold3 ];

/// MPI_Hold4
Property MPIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MPI_Hold4 ];

/// MPI_Hold5
Property MPIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MPI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMaintPlanItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MPI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MPI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MPI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MPI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MPI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MPI_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPI_MaintPartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MPI_MaintPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPI_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MPI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMaintPlanItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MPI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MPI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaintPlan">
<Global>^DHCEQMaintPlanItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MPI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MaintPlan"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MPI_MaintPlanDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MPI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMaintPlanItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
