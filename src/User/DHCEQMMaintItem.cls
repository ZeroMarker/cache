Class User.DHCEQMMaintItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MTI_RowID, SqlTableName = DHC_EQMMaintItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MTI_MaintDR
Property MTIMaintDR As User.DHCEQMMaint [ SqlColumnNumber = 2, SqlFieldName = MTI_MaintDR ];

/// MTI_MaintPartDR
Property MTIMaintPartDR As User.DHCEQMCPart [ SqlColumnNumber = 3, SqlFieldName = MTI_MaintPartDR ];

/// MTI_MaintItemDR
Property MTIMaintItemDR As User.DHCEQMCMaintItem [ SqlColumnNumber = 4, SqlFieldName = MTI_MaintItemDR ];

/// MTI_MaintUserDR
Property MTIMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MTI_MaintUserDR ];

/// MTI_MaintState
Property MTIMaintState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MTI_MaintState ];

/// MTI_Remark
Property MTIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MTI_Remark ];

/// MTI_MaintRequestDR
Property MTIMaintRequestDR As User.DHCEQMMaintRequest [ SqlColumnNumber = 8, SqlFieldName = MTI_MaintRequestDR ];

/// MTI_Hold2
Property MTIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MTI_Hold2 ];

/// MTI_Hold3
Property MTIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MTI_Hold3 ];

/// MTI_Hold4
Property MTIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MTI_Hold4 ];

/// MTI_NormalFlag
Property MTINormalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MTI_NormalFlag ];

/// MTI_MaintContent
Property MTIMaintContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MTI_MaintContent ];

/// MTI_Result
Property MTIResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MTI_Result ];

/// MTI_ProviderDR
Property MTIProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 15, SqlFieldName = MTI_ProviderDR ];

/// MTI_Step
Property MTIStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MTI_Step ];

/// MTI_Hold5
Property MTIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MTI_Hold5 ];

/// MTI_MaintFee
Property MTIMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MTI_MaintFee ];

/// MTI_TotalFee
Property MTITotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MTI_TotalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MTI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MTI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MTI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MTI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MTI_MaintContent">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MTI_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MTI_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MTI_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MTI_MaintPartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MTI_MaintRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MTI_MaintState">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MTI_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MTI_NormalFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MTI_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MTI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MTI_Result">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MTI_Step">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MTI_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCEQMMaintItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MTI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MTI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaint">
<Global>^DHCEQMMaintItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MTI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Maint"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTI_MaintDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMaintRequest">
<Global>^DHCEQMMaintItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MTI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MaintRequest"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MTI_MaintRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MTI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
