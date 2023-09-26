Class User.DHCEQMaintItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MTI_RowID, SqlTableName = DHC_EQMaintItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MTI_MaintDR
Property MTIMaintDR As User.DHCEQMaint [ SqlColumnNumber = 2, SqlFieldName = MTI_MaintDR ];

/// MTI_MaintPartDR
Property MTIMaintPartDR As User.DHCEQCPart [ SqlColumnNumber = 3, SqlFieldName = MTI_MaintPartDR ];

/// MTI_MaintItemDR
Property MTIMaintItemDR As User.DHCEQCMaintItem [ SqlColumnNumber = 4, SqlFieldName = MTI_MaintItemDR ];

/// MTI_MaintUserDR
Property MTIMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MTI_MaintUserDR ];

/// MTI_MaintState
Property MTIMaintState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MTI_MaintState ];

/// MTI_Remark
Property MTIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MTI_Remark ];

/// MTI_Hold
Property MTIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MTI_Hold1 ];

/// MTI_Hold2
Property MTIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MTI_Hold2 ];

/// MTI_Hold3
Property MTIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MTI_Hold3 ];

/// MTI_Hold4
Property MTIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MTI_Hold4 ];

/// MTI_NormalFlag
Property MTINormalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MTI_NormalFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMaintItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MTI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
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
<Data name="MTI_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MTI_MaintItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MTI_MaintPartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Data name="MTI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQMaintItem</Global>
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
<Global>^DHCEQMaintItem</Global>
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
<StreamLocation>^User.DHCEQMaintItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
