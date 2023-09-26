Class User.DHCEQMMaintPlanItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MPI_RowID, SqlTableName = DHC_EQMMaintPlanItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MPI_MaintPlanDR
Property MPIMaintPlanDR As User.DHCEQMMaintPlan [ SqlColumnNumber = 2, SqlFieldName = MPI_MaintPlanDR ];

/// MPI_MaintPartDR
Property MPIMaintPartDR As User.DHCEQMCPart [ SqlColumnNumber = 3, SqlFieldName = MPI_MaintPartDR ];

/// MPI_MaintItemDR
Property MPIMaintItemDR As User.DHCEQMCMaintItem [ SqlColumnNumber = 4, SqlFieldName = MPI_MaintItemDR ];

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

/// MPI_MaintContent
Property MPIMaintContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MPI_MaintContent ];

/// MPI_Result
Property MPIResult As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MPI_Result ];

/// MPI_ProviderDR
Property MPIProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 14, SqlFieldName = MPI_ProviderDR ];

/// MPI_Step
Property MPIStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MPI_Step ];

/// MPI_MaintFee
Property MPIMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MPI_MaintFee ];

/// MPI_TotalFee
Property MPITotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MPI_TotalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintPlanItem("0"))</SqlIdExpression>
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
<Data name="MPI_MaintContent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MPI_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
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
<Data name="MPI_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MPI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MPI_Result">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MPI_Step">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MPI_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQMMaintPlanItem</Global>
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
<Global>^DHCEQMMaintPlanItem</Global>
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
<StreamLocation>^User.DHCEQMMaintPlanItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
